class KFRLevelRules extends KFLevelRules;

simulated function PostBeginPlay() {
    local int i;

    for(i= 17; i < MAX_BUYITEMS; i++) {
        ItemForSale[i]= none;
    }
}

defaultproperties {
    ItemForSale(0)=Class'KFMod.ShotgunPickup'
    ItemForSale(1)=Class'KFMod.BoomStickPickup'
    ItemForSale(2)=Class'KFMod.SinglePickup'
    ItemForSale(3)=Class'KFMod.DualiesPickup'
    ItemForSale(4)=Class'KFMod.WinchesterPickup'
    ItemForSale(5)=Class'KFRollback.DeaglePickup'
    ItemForSale(6)=Class'KFMod.CrossbowPickup'
    ItemForSale(7)=Class'KFRollback.DualDeaglePickup'
    ItemForSale(8)=Class'KFMod.BullpupPickup'
    ItemForSale(9)=Class'KFRollback.AK47Pickup'
    ItemForSale(10)=Class'KFMod.KnifePickup'
    ItemForSale(11)=Class'KFRollback.MachetePickup'
    ItemForSale(12)=Class'KFRollback.AxePickup'
    ItemForSale(13)=Class'KFRollback.KatanaPickup'
    ItemForSale(14)=Class'KFRollback.ChainsawPickup'
    ItemForSale(15)=Class'KFMod.FlameThrowerPickup'
    ItemForSale(16)=Class'KFRollback.LAWPickup'
}

