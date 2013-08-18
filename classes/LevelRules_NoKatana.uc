class LevelRules_NoKatana extends KFLevelRules;

simulated function PostBeginPlay() {
    local int i;

    for(i= 16; i < MAX_BUYITEMS; i++) {
        ItemForSale[i]= none;
    }
}

defaultproperties {
    ItemForSale(0)=Class'KFMod.ShotgunPickup'
    ItemForSale(1)=Class'KFMod.BoomStickPickup'
    ItemForSale(2)=Class'KFRollback.LAWPickup'
    ItemForSale(3)=Class'KFMod.SinglePickup'
    ItemForSale(4)=Class'KFMod.DualiesPickup'
    ItemForSale(5)=Class'KFMod.WinchesterPickup'
    ItemForSale(6)=Class'KFRollback.DeaglePickup'
    ItemForSale(7)=Class'KFMod.CrossbowPickup'
    ItemForSale(8)=Class'KFRollback.DualDeaglePickup'
    ItemForSale(9)=Class'KFMod.BullpupPickup'
    ItemForSale(10)=Class'KFRollback.AK47Pickup'
    ItemForSale(11)=Class'KFMod.KnifePickup'
    ItemForSale(12)=Class'KFRollback.MachetePickup'
    ItemForSale(13)=Class'KFRollback.AxePickup'
    ItemForSale(14)=Class'KFRollback.ChainsawPickup'
    ItemForSale(15)=Class'KFMod.FlameThrowerPickup'
}

