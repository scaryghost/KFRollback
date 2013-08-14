class KFRLevelRules extends KFLevelRules;

function PostBeginPlay() {
    local int i;

    for(i= 17; i < MAX_BUYITEMS; i++) {
        ItemForSale[i]= none;
    }
}

defaultproperties
{
    ItemForSale(0)=Class'KFMod.ShotgunPickup'
    ItemForSale(1)=Class'KFMod.BoomStickPickup'
    ItemForSale(2)=Class'KFMod.LAWPickup'
    ItemForSale(3)=Class'KFMod.SinglePickup'
    ItemForSale(4)=Class'KFMod.DualiesPickup'
    ItemForSale(5)=Class'KFMod.WinchesterPickup'
    ItemForSale(6)=Class'KFMod.DeaglePickup'
    ItemForSale(7)=Class'KFMod.CrossbowPickup'
    ItemForSale(8)=Class'KFMod.DualDeaglePickup'
    ItemForSale(9)=Class'KFMod.BullpupPickup'
    ItemForSale(10)=Class'KFMod.AK47Pickup'
    ItemForSale(11)=Class'KFMod.KnifePickup'
    ItemForSale(12)=Class'KFMod.MachetePickup'
    ItemForSale(13)=Class'KFMod.AxePickup'
    ItemForSale(14)=Class'KFMod.KatanaPickup'
    ItemForSale(15)=Class'KFMod.ChainsawPickup'
    ItemForSale(16)=Class'KFMod.FlameThrowerPickup'
}

