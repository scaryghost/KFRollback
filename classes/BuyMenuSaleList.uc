class BuyMenuSaleList extends KFBuyMenuSaleList_Story;

var KFRLinkedReplicationInfo kfrLRepInfo;

event InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
}

function UpdateForSaleBuyables() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.UpdateForSaleBuyables();
    } else {
        super(KFBuyMenuSaleList).UpdateForSaleBuyables();
    }
}

function FilterBuyablesList() {
    CurrFilterIndex = KFPlayerController( PlayerOwner() ).BuyMenuFilterIndex;
}

function int PopulateBuyables()
{
    local array<RollbackPack.DualInfo> dualWeapons;
    local class<KFVeterancyTypes> PlayerVeterancy;
    local KFPlayerReplicationInfo KFPRI;
    local GUIBuyable ForSaleBuyable;
    local class<KFWeaponPickup> ForSalePickup;
    local int currentIndex, i, j, DualDivider, dualIndex;
    local bool bZeroWeight, skip;

    DualDivider = 1;

    dualWeapons= kfrLRepInfo.pack.getDualWeapons();
    // Grab Players Veterancy for quick reference
    if ( KFPlayerController(PlayerOwner()) != none && KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill != none )
    {
        PlayerVeterancy = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;
    }
    else
    {
        PlayerVeterancy = class'KFVeterancyTypes';
    }

    KFPRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

    //Grab the perk's weapons first
    for ( j = 0; j < KFLR.ItemForSale.Length; j++ )
    {
        if ( KFLR.ItemForSale[j] != none )
        {
            skip= false;
            ForSalePickup = class<KFWeaponPickup>(KFLR.ItemForSale[j]);

            //if( ForSalePickup != class'KFMod.Potato' )
            //{
                //Let's see if this is a vest, first aid kit, ammo or stuff we already have
                if ( class<Vest>(KFLR.ItemForSale[j]) != none || class<FirstAidKit>(KFLR.ItemForSale[j]) != none ||
                     class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType) == none || KFLR.ItemForSale[j].IsA('Ammunition') ||
                     class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType).default.bKFNeverThrow ||
                     IsVariantInInventory(ForSalePickup) )
                {
                    continue;
                }
            //}

            for(i= 0; i < dualWeapons.Length && !skip; i++) {
                skip= ForSalePickup.default.InventoryType == dualWeapons[i].singleWeapon && IsInInventory(dualWeapons[i].dualWeapon.default.PickupClass);
                if (ForSalePickup.default.InventoryType == dualWeapons[i].dualWeapon && IsInInventory(dualWeapons[i].singleWeapon.default.PickupClass)) {
                    DualDivider= 2;
                    break;
                }
            }
            if (skip) {
                continue;
            }
            dualIndex= i;

            if ( currentIndex >= ForSaleBuyables.Length )
            {
                ForSaleBuyable = new class'GUIBuyable';
                ForSaleBuyables[ForSaleBuyables.Length] = ForSaleBuyable;
            }
            else
            {
                ForSaleBuyable = ForSaleBuyables[currentIndex];
            }

            currentIndex++;

            ForSaleBuyable.ItemName         = ForSalePickup.default.ItemName;
            ForSaleBuyable.ItemDescription  = ForSalePickup.default.Description;
            ForSaleBuyable.ItemCategorie    = KFLR.EquipmentCategories[i].EquipmentCategoryName;
            /*if( ForSalePickup == class'KFMod.Potato' )
            {
                ForSaleBuyable.ItemImage        = Texture'Potato_T.ui_potato';
                ForSaleBuyable.ItemAmmoClass    = none;
            }
            else*/
            //{
                ForSaleBuyable.ItemImage        = class<KFWeapon>(ForSalePickup.default.InventoryType).default.TraderInfoTexture;
                ForSaleBuyable.ItemAmmoClass    = class<KFWeapon>(ForSalePickup.default.InventoryType).default.FireModeClass[0].default.AmmoClass;
            //}
            ForSaleBuyable.ItemWeaponClass  = class<KFWeapon>(ForSalePickup.default.InventoryType);
            ForSaleBuyable.ItemPickupClass  = ForSalePickup;
            ForSaleBuyable.ItemCost         = int((float(ForSalePickup.default.Cost)
                                              * PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
            ForSaleBuyable.ItemAmmoCost     = 0;
            ForSaleBuyable.ItemFillAmmoCost = 0;

            if (dualIndex < dualWeapons.Length) {
                ForSaleBuyable.ItemWeight= ForSalePickup.default.Weight - dualWeapons[dualIndex].singleWeapon.default.Weight;
                log("I am a dual weapon!"@ForSaleBuyable.ItemWeight);
            } else  {
                ForSaleBuyable.ItemWeight   = ForSalePickup.default.Weight;
            }

            ForSaleBuyable.ItemPower        = ForSalePickup.default.PowerValue;
            ForSaleBuyable.ItemRange        = ForSalePickup.default.RangeValue;
            ForSaleBuyable.ItemSpeed        = ForSalePickup.default.SpeedValue;
            ForSaleBuyable.ItemAmmoCurrent  = 0;
            ForSaleBuyable.ItemAmmoMax      = 0;
            ForSaleBuyable.ItemPerkIndex    = ForSalePickup.default.CorrespondingPerkIndex;

            // Make sure we mark the list as a sale list
            ForSaleBuyable.bSaleList = true;

            bZeroWeight = false;
        }
    }
    return currentIndex;
}
