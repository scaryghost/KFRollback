class MidGamePerksTab extends KFTab_MidGamePerks;

var KFRLinkedReplicationInfo kfrLRepInfo;
var automated moNumericEdit perkLevels;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);

    
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perkLevels.Setup(0, kfrLRepInfo.pack.getMaxPerkLevel(), 1);
    i_BGPerkNextLevel.UnManageComponent(lb_PerkProgress);
    i_BGPerkNextLevel.ManageComponent(perkLevels);
}

function ShowPanel(bool bShow) {
    super(MidGamePanel).ShowPanel(bShow);

    if (bShow && PlayerOwner() != none) {
        lb_PerkSelect.List.InitList(KFStatsAndAchievements);
        perkLevels.SetValue(kfrLRepInfo.desiredPerkLevel);
        InitGRI();
    }
}

function OnPerkSelected(GUIComponent Sender)  {
    lb_PerkEffects.SetContent(kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()].default.LevelEffects[perkLevels.GetValue()]);
    if (Sender == perkLevels) {
        PerkSelectList(lb_PerkSelect.List).updateLevelStrings(perkLevels.GetValue());
    }
}

function bool OnSaveButtonClicked(GUIComponent Sender) {
    kfrLRepInfo.desiredPerkLevel= perkLevels.GetValue();
    kfrLRepInfo.changePerk(lb_PerkSelect.GetIndex());
    return true;
}

defaultproperties {
    lb_PerkProgress=None

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
        WinTop=0.392889
        WinLeft=0.486700
        WinWidth=0.490282
        WinHeight=0.415466
        OnPreDraw=PerkConfig.InternalPreDraw
    End Object
    i_BGPerkNextLevel=GUISectionBackground'KFRollback.MidGamePerksTab.PerkConfig'

    Begin Object class=moNumericEdit Name=PerkLevelsBox
        Caption="Perk Level"
        Hint="Set perk level"
        OnChange=MidGamePerksTab.OnPerkSelected
    End Object
    perkLevels=moNumericEdit'KFRollback.MidGamePerksTab.PerkLevelsBox'
}
