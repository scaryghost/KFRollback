class LevelRules extends KFLevelRules;

var int listSize;

simulated function PostBeginPlay() {
    local int i;

    for(i= listSize; i < MAX_BUYITEMS; i++) {
        ItemForSale[i]= none;
    }
}

simulated function remove(class<Pickup> pickupClass) {
    local int i, remove;

    for(i= 0; i < listSize && ItemForSale[i] != pickupClass; i++) {
    }
    if (i < listSize) {
        remove= i;
        log("I'm removing you!"@pickupClass);
        for(i= remove; i < listSize - 1; i++) {
            ItemForSale[i]= ItemForSale[i + 1];
        }
        ItemForSale[listSize - 1]= none;
        listSize--;
    }
}

defaultproperties {
    listSize= 17

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

