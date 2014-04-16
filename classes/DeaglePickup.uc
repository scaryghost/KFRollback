class DeaglePickup extends KFMod.DeaglePickup;

function inventory SpawnCopy(pawn Other) {
    local Inventory I;

    for (I= Other.Inventory; I != none; I= I.Inventory ) {
        // can't just cast to Deagle to check, because golden deagle is a deagle
        // but we don't want to take your golden deagle and give you dual
        // normal deagles
        if (I.Class == class'KFRollback.Deagle') {
            if( Inventory != none )
                Inventory.Destroy();
            InventoryType = Class'KFRollback.DualDeagle';
            AmmoAmount[0] += Deagle(I).AmmoAmount(0);
            MagAmmoRemaining += Deagle(I).MagAmmoRemaining;
            I.Destroyed();
            I.Destroy();
            Return Super(KFWeaponPickup).SpawnCopy(Other);
        }
    }

    InventoryType = Default.InventoryType;
    return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties {
    Weight=4.000000
    ItemName="Handcannon"
    ItemShortName="Handcanno*"
    InventoryType=Class'KFRollback.Deagle'
}
