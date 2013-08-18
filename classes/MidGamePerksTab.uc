class MidGamePerksTab extends KFTab_MidGamePerks;

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local PlayerController PC;

    PC = PlayerOwner();
    KFPlayerController(PC).SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
    PC.ConsoleCommand("mutate perkchange "$lb_PerkSelect.GetIndex());
    return true;
}

function OnPerkSelected(GUIComponent Sender) {
    lb_PerkEffects.SetContent(class'PerkList'.default.perks[lb_PerkSelect.GetIndex()].default.LevelEffects[KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkillLevel]);
    lb_PerkProgress.List.PerkChanged(KFStatsAndAchievements, lb_PerkSelect.GetIndex());
}

defaultproperties {
    Begin Object Class=KFPerkSelectListBox Name=PerkSelectList
        OnCreateComponent=PerkSelectList.InternalOnCreateComponent
        WinTop=0.057760
        WinLeft=0.029240
        WinWidth=0.437166
        WinHeight=0.742836
        DefaultListClass="KFRollback.KFRPerkSelectList"
    End Object
    lb_PerkSelect=KFPerkSelectListBox'KFRollback.MidGamePerksTab.PerkSelectList'

    Begin Object Class=KFPerkProgressListBox Name=PerkProgressList
        OnCreateComponent=PerkProgressList.InternalOnCreateComponent
        WinTop=0.476850
        WinLeft=0.499269
        WinWidth=0.463858
        WinHeight=0.341256
        DefaultListClass="KFRollback.KFRPerkProgressList"
    End Object
    lb_PerkProgress=KFPerkProgressListBox'KFRollback.MidGamePerksTab.PerkProgressList'
}
