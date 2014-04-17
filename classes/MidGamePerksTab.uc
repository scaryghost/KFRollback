class MidGamePerksTab extends KFTab_MidGamePerks;

var KFRLinkedReplicationInfo kfrLRepInfo;
var automated moNumericEdit perkLevels;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);

    
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perkLevels.Setup(0, kfrLRepInfo.pack.getMaxPerkLevel(), 1);
    perkLevels.SetValue(kfrLRepInfo.desiredPerkLevel);
    i_BGPerkNextLevel.UnManageComponent(lb_PerkProgress);
    i_BGPerkNextLevel.ManageComponent(perkLevels);
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if (bShow && PlayerOwner() != none) {
        lb_PerkSelect.List.InitList(KFStatsAndAchievements);
        InitGRI();
    }
}

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local PlayerController PC;

    PC = PlayerOwner();
    KFPlayerController(PC).SelectedVeterancy = kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()];
    kfrLRepInfo.changePerk(KFPlayerController(PC).SelectedVeterancy, kfrLRepInfo.desiredPerkLevel);
    return true;
}

function OnPerkSelected(GUIComponent Sender) {
    lb_PerkEffects.SetContent(kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()].default.LevelEffects[kfrLRepInfo.desiredPerkLevel]);
    lb_PerkProgress.List.PerkChanged(KFStatsAndAchievements, lb_PerkSelect.GetIndex());
}

defaultproperties {
    Begin Object Class=KFPerkSelectListBox Name=PerkSelectBox
        OnCreateComponent=PerkSelectBox.InternalOnCreateComponent
        WinTop=0.057760
        WinLeft=0.029240
        WinWidth=0.437166
        WinHeight=0.742836
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
    i_BGPerkNextLevel=GUISectionBackground'KFRollback.MidGamePerksTab.PerkConfig'

    Begin Object class=moNumericEdit Name=PerkLevelsBox
        Caption="Perk Level"
        Hint="Set perk level"
        OnChange=ProfileTab.InternalOnChange
    End Object
    perkLevels=moNumericEdit'KFRollback.MidGamePerksTab.PerkLevelsBox'
}
