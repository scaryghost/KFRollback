class KFRVetCommando extends KFVetCommando
    abstract;

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'BullpupPickup' || Item == class'KFRollback.AK47Pickup') {
        return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel));
    }
    return 1.0;
}

defaultproperties {
    VeterancyName="Commando"
}
