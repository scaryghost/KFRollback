class LobbyFooter extends KFGui.LobbyFooter;

function bool OnFooterClick(GUIComponent Sender) {
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local GUIController C;
    local PlayerController PC;

    PC= PlayerOwner();
    C= Controller;
    if(Sender == b_Cancel) {
        //Kill Window and exit game/disconnect from server
        LobbyMenu(PageOwner).bAllowClose = true;
        C.ViewportOwner.Console.ConsoleCommand("DISCONNECT");
        KFGUIController(C).ReturnToMainMenu();
    } else if (Sender == b_Ready) {
        if (PC.PlayerReplicationInfo.Team != none) {
            if (PC.Level.NetMode == NM_Standalone || !PC.PlayerReplicationInfo.bReadyToPlay) {
                if (KFPlayerController(PC) != none) {
                    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PC.PlayerReplicationInfo);
                    kfrLRepInfo.changePerk(KFPlayerController(PC).SelectedVeterancy, kfrLRepInfo.pack.getMaxPerkLevel());
                }

                //Set Ready
                PC.ServerRestartPlayer();
                PC.PlayerReplicationInfo.bReadyToPlay = True;
                if (PC.Level.GRI.bMatchHasBegun) {
                    PC.ClientCloseMenu(true, false);
                }

                b_Ready.Caption= UnreadyString;
            } else {
                if (KFPlayerController(PC) != none) {
                    KFPlayerController(PC).ServerUnreadyPlayer();
                    PC.PlayerReplicationInfo.bReadyToPlay = False;
                    b_Ready.Caption= ReadyString;
                }
            }
        }
    } else if (Sender == b_Options) {
        PC.ClientOpenMenu("KFGUI.KFSettingsPage", false);
    } else if (Sender == b_Perks) {
        if (!Controller.CheckSteam()) {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(class'KFMainMenu'.default.SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
            return false;
        } else {
            PC.ClientOpenMenu(class'LobbyMenu'.default.profilePage, false);
        }
    }

    return false;
}
