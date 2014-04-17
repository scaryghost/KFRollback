class PerkTab extends KFTab_Perks;

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local PlayerController PC;

    PC = PlayerOwner();

    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PC.PlayerReplicationInfo);
    if (KFPlayerController(PC).bChangedVeterancyThisWave && KFPlayerController(PC).SelectedVeterancy != kfrLRepInfo.pack.getPerks()[lb_PerkSelect.GetIndex()]) {
        l_ChangePerkOncePerWave.SetVisibility(true);
    } else {
        kfrLRepInfo.changePerk(lb_PerkSelect.GetIndex());
    }

    return true;
}
