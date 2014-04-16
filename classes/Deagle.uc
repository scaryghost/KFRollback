class Deagle extends KFMod.Deagle;

simulated function bool PutDown() {
    if (Instigator.PendingWeapon.class == class'KFRollback.DualDeagle') {
        bIsReloading = false;
    }

    return super(KFWeapon).PutDown();
}

defaultproperties {
    PickupClass=Class'KFRollback.DeaglePickup'
    Weight=4.000000
    ItemName="Handcannon"
}
