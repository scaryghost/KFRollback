class ProfileTab extends KFTab_Profile;

var KFRLinkedReplicationInfo kfrLRepInfo;
var string modelSelectClass;
var automated moNumericEdit perkLevels;
var bool saveButtonPressed;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);

    
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perkLevels.Setup(0, kfrLRepInfo.pack.getMaxPerkLevel(), 1);
    i_BGPerkNextLevel.UnManageComponent(lb_PerkProgress);
    i_BGPerkNextLevel.ManageComponent(perkLevels);
}

function ShowPanel(bool bShow) {
    if (bShow) {
        if (bInit) {
            bRenderDude= True;
            bInit= False;
        }

        lb_PerkSelect.List.InitList(KFStatsAndAchievements);
        perkLevels.SetValue(kfrLRepInfo.desiredPerkLevel);
    }

    lb_PerkSelect.SetPosition(i_BGPerks.WinLeft + 6.0 / float(Controller.ResX),
                              i_BGPerks.WinTop + 38.0 / float(Controller.ResY),
                              i_BGPerks.WinWidth - 10.0 / float(Controller.ResX),
                              i_BGPerks.WinHeight - 35.0 / float(Controller.ResY),
                              true);
    SetVisibility(bShow);
}
function bool PickModel(GUIComponent Sender) {
    if (Controller.OpenMenu(modelSelectClass, PlayerRec.DefaultName, Eval(Controller.CtrlPressed, PlayerRec.Race, ""))) {
        Controller.ActivePage.OnClose = ModelSelectClosed;
    }

    return true;
}

function SaveSettings() {
    local PlayerController PC;

    PC = PlayerOwner();

    if (sChar != sCharD) {
        sCharD = sChar;
        PC.ConsoleCommand("ChangeCharacter"@sChar);

        if (!PC.IsA('xPlayer')) {
            PC.UpdateURL("Character", sChar, True);
        }

        if (PlayerRec.Sex ~= "Female") {
            PC.UpdateURL("Sex", "F", True);
        }
        else {
            PC.UpdateURL("Sex", "M", True);
        }
    }
    if (saveButtonPressed) {
        kfrLRepInfo.desiredPerkLevel= perkLevels.GetValue();
        kfrLRepInfo.changePerk(lb_PerkSelect.GetIndex());
        saveButtonPressed= false;
    }
}

function OnPerkSelected(GUIComponent Sender) {
    lb_PerkEffects.SetContent(kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()].default.LevelEffects[perkLevels.GetValue()]);
}

defaultproperties {
    modelSelectClass="KFRollback.ModelSelect"
    lb_PerkProgress=None

    Begin Object Class=KFPerkSelectListBox Name=PerkSelectBox
        OnCreateComponent=PerkSelectBox.InternalOnCreateComponent
        WinTop=0.082969
        WinLeft=0.323418
        WinWidth=0.318980
        WinHeight=0.654653
        DefaultListClass="KFRollback.PerkSelectList"
    End Object
    lb_PerkSelect=PerkSelectBox

    Begin Object Class=GUISectionBackground Name=PerkConfig
        bFillClient=True
        Caption="Perk Configuration"
        WinTop=0.379668
        WinLeft=0.660121
        WinWidth=0.339980
        WinHeight=0.352235
        OnPreDraw=PerkConfig.InternalPreDraw
    End Object
    i_BGPerkNextLevel=GUISectionBackground'KFRollback.ProfileTab.PerkConfig'

    Begin Object class=moNumericEdit Name=PerkLevelsBox
        Caption="Perk Level"
        Hint="Set perk level"
        OnChange=ProfileTab.OnPerkSelected
    End Object
    perkLevels=moNumericEdit'KFRollback.ProfileTab.PerkLevelsBox'
}
