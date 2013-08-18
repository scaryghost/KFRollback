class PerkTab extends KFTab_Perks;

function bool OnSaveButtonClicked(GUIComponent Sender) {
    local PlayerController PC;

    PC = PlayerOwner();

    if (KFPlayerController(PC).bChangedVeterancyThisWave && KFPlayerController(PC).SelectedVeterancy != class'PerkList'.default.perks[lb_PerkSelect.GetIndex()]) {
        l_ChangePerkOncePerWave.SetVisibility(true);
    }
    else {
        KFPlayerController(PC).SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
        PC.ConsoleCommand("mutate perkchange "$lb_PerkSelect.GetIndex());
    }

    return true;
}
