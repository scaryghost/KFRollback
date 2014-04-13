class PerkTab extends KFTab_Perks;

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local PlayerController PC;

    PC = PlayerOwner();

    if (KFPlayerController(PC).bChangedVeterancyThisWave && KFPlayerController(PC).SelectedVeterancy != class'PerkList'.default.perks[lb_PerkSelect.GetIndex()]) {
        l_ChangePerkOncePerWave.SetVisibility(true);
    }
    else {
        kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PC.PlayerReplicationInfo);
        KFPlayerController(PC).SelectedVeterancy = kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()];
        kfrLRepInfo.changePerk(KFPlayerController(PC).SelectedVeterancy, kfrLRepInfo.pack.getMaxPerkLevel());
    }

    return true;
}
