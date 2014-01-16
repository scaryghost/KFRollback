class LevelRules extends KFLevelRules;

simulated function bool remove(class<Pickup> pickupClass) {
    local int i;

    for(i= 0; i < ItemForSale.Length; i++) {
        if (pickupClass == ItemForSale[i]) {
            ItemForSale.Remove(i, 1);
            return true;
        }
    }
    return false;
}

defaultproperties {
    ItemForSale(0)=Class'KFMod.ShotgunPickup'
    ItemForSale(1)=Class'KFMod.BoomStickPickup'
    ItemForSale(2)=Class'KFRollback.LAWPickup'
    ItemForSale(3)=Class'KFMod.SinglePickup'
    ItemForSale(4)=Class'KFMod.DualiesPickup'
    ItemForSale(5)=Class'KFMod.WinchesterPickup'
    ItemForSale(6)=Class'KFMod.DeaglePickup'
    ItemForSale(7)=Class'KFMod.CrossbowPickup'
    ItemForSale(8)=Class'KFMod.DualDeaglePickup'
    ItemForSale(9)=Class'KFMod.BullpupPickup'
    ItemForSale(10)=Class'KFMod.AK47Pickup'
    ItemForSale(11)=Class'KFMod.KnifePickup'
    ItemForSale(12)=Class'KFRollback.MachetePickup'
    ItemForSale(13)=Class'KFRollback.AxePickup'
    ItemForSale(14)=Class'KFRollback.KatanaPickup'
    ItemForSale(15)=Class'KFRollback.ChainsawPickup'
    ItemForSale(16)=Class'KFMod.FlameThrowerPickup'
}

