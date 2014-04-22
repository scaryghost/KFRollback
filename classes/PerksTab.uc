class PerksTab extends KFTab_Perks;

var KFRLinkedReplicationInfo kfrLRepInfo;
var automated moNumericEdit perkLevels;
var GUIComboBox perksBox;

function ShowPanel(bool bShow) {
    super(UT2K4TabPanel).ShowPanel(bShow);

    if (bShow) {
        if (PlayerOwner() != none) {
            KFStatsAndAchievements= KFSteamStatsAndAchievements(PlayerOwner().SteamStatsAndAchievements);

            // Initialize the List
            lb_PerkSelect.List.InitList(KFStatsAndAchievements);
        }

        l_ChangePerkOncePerWave.SetVisibility(false);
    }
}

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    Super.InitComponent(MyController, MyOwner);
    
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perkLevels.Setup(0, kfrLRepInfo.pack.getMaxPerkLevel(), 1);
    perkLevels.SetValue(kfrLRepInfo.desiredPerkLevel);
    i_BGPerkNextLevel.UnManageComponent(lb_PerkProgress);
    i_BGPerkNextLevel.ManageComponent(perkLevels);

}

function InternalOnChange(GUIComponent sender) {
    if (sender == perkLevels) {
        kfrLRepInfo.desiredPerkLevel= perkLevels.GetValue();
        OnPerkSelected(sender);
    }
}

function OnPerkSelected(GUIComponent Sender) {
    lb_PerkEffects.SetContent(kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()].default.LevelEffects[kfrLRepInfo.desiredPerkLevel]);
}

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local PlayerController PC;

    PC = PlayerOwner();

    if (KFPlayerController(PC).bChangedVeterancyThisWave && KFPlayerController(PC).SelectedVeterancy != kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()]) {
        l_ChangePerkOncePerWave.SetVisibility(true);
    } else {
        perksBox.SetIndex(lb_PerkSelect.GetIndex());
        perksBox.Edit.SetText(KFPlayerController(PC).SelectedVeterancy.default.VeterancyName);
        PerksBox.Edit.SetFocus(None);
    }

    return true;
}

defaultproperties {
    lb_PerkProgress=None

    Begin Object Class=KFPerkSelectListBox Name=PerkSelectList
        OnCreateComponent=PerkSelectList.InternalOnCreateComponent
        WinTop=0.091627
        WinLeft=0.029240
        WinWidth=0.437166
        WinHeight=0.742836
        DefaultListClass="KFRollback.PerkSelectList"
    End Object
    lb_PerkSelect=KFPerkSelectListBox'KFRollback.PerksTab.PerkSelectList'

    Begin Object Class=GUISectionBackground Name=BGPerksNextLevel
        bFillClient=True
        Caption="Perk Configuration"
        WinTop=0.413209
        WinLeft=0.486700
        WinWidth=0.490282
        WinHeight=0.415466
        OnPreDraw=BGPerksNextLevel.InternalPreDraw
    End Object
    i_BGPerkNextLevel=GUISectionBackground'KFRollback.PerksTab.BGPerksNextLevel'

    Begin Object Class=moNumericEdit Name=PerkLevelsBox
        OnChange=PerksTab.InternalOnChange
        Caption="Perk Level"
        Hint="Set perk level"
    End Object
    perkLevels=moNumericEdit'KFRollback.PerksTab.PerkLevelsBox'
}
