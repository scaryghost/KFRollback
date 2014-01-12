class LevelRules extends KFLevelRules;

var array<class<Pickup> > allowedItems;

simulated function PostBeginPlay() {
    MediItemForSale.Length= 0;
    SuppItemForSale.Length= 3;
    ShrpItemForSale.Length= 8;
    CommItemForSale.Length= 2;
    BersItemForSale.Length= 5;
    FireItemForSale.Length= 1;
    DemoItemForSale.Length= 0;
    NeutItemForSale.Length= 0;
}

simulated function bool remove(class<Pickup> pickupClass) {
    return removeHelper(pickupClass, MediItemForSale) && removeHelper(pickupClass, SuppItemForSale) && 
        removeHelper(pickupClass, ShrpItemForSale) && removeHelper(pickupClass, CommItemForSale) &&
        removeHelper(pickupClass, BersItemForSale) && removeHelper(pickupClass, FireItemForSale) &&
        removeHelper(pickupClass, DemoItemForSale) && removeHelper(pickupClass, NeutItemForSale);
}

simulated function bool removeHelper(class<Pickup> pickupClass, out array<class<Pickup> > pickups) {
    local int i;

    for(i= 0; i < pickups.Length; i++) {
        if (pickupClass == pickups[i]) {
            pickups.Remove(i, 1);
            return true;
        }
    }
    return false;
}

defaultproperties {
    SuppItemForSale(0)=Class'KFMod.ShotgunPickup'
    SuppItemForSale(1)=Class'KFMod.BoomStickPickup'
    SuppItemForSale(2)=Class'KFRollback.LAWPickup'

    ShrpItemForSale(0)=Class'KFMod.SinglePickup'
    ShrpItemForSale(1)=Class'KFMod.DualiesPickup'
    ShrpItemForSale(2)=Class'KFMod.WinchesterPickup'
    ShrpItemForSale(3)=Class'KFMod.DeaglePickup'
    ShrpItemForSale(4)=Class'KFMod.CrossbowPickup'
    ShrpItemForSale(5)=Class'KFMod.DualDeaglePickup'

    CommItemForSale(0)=Class'KFMod.BullpupPickup'
    CommItemForSale(1)=Class'KFMod.AK47Pickup'

    BersItemForSale(0)=Class'KFMod.KnifePickup'
    BersItemForSale(1)=Class'KFRollback.MachetePickup'
    BersItemForSale(2)=Class'KFRollback.AxePickup'
    BersItemForSale(3)=Class'KFRollback.KatanaPickup'
    BersItemForSale(4)=Class'KFRollback.ChainsawPickup'

    FireItemForSale(0)=Class'KFMod.FlameThrowerPickup'
}

