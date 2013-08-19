class BuyMenuSaleList extends KFBuyMenuSaleList;

function int PopulateBuyablesbyPerk(int Perk, bool HasPerk, int currentIndex) {
    local class<KFVeterancyTypes> PlayerVeterancy;
    local KFPlayerReplicationInfo KFPRI;
    local KFLevelRules KFLR, KFLRit;
    local GUIBuyable ForSaleBuyable;
    local class<KFWeaponPickup> ForSalePickup;
    local int i, j, DualDivider;
    local bool bZeroWeight, shouldSkip;

    DualDivider = 1;

    // Grab Players Veterancy for quick reference
    KFPRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
    if (KFPlayerController(PlayerOwner()) != none && KFPRI.ClientVeteranSkill != none) {
        PlayerVeterancy = KFPRI.ClientVeteranSkill;
    } else {
        PlayerVeterancy = class'KFVeterancyTypes';
    }

    // Grab the items for sale
    foreach PlayerOwner().DynamicActors(class'KFLevelRules', KFLRit) {
        KFLR = KFLRit;
        Break;
    }


    //Grab the perk's weapons first
    for (j = 0; j < KFLR.MAX_BUYITEMS; j++) {

        if (KFLR.ItemForSale[j] != none) {
            ForSalePickup = class<KFWeaponPickup>(KFLR.ItemForSale[j]);

            //Let's see if this is a vest, first aid kit, ammo or stuff we already have
            shouldSkip= class<Vest>(KFLR.ItemForSale[j]) != none || class<FirstAidKit>(KFLR.ItemForSale[j]) != none ||
                class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType) == none || KFLR.ItemForSale[j].IsA('Ammunition') ||
                class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType).default.bKFNeverThrow ||
                IsInInventory(ForSalePickup) || ((ForSalePickup.default.CorrespondingPerkIndex != Perk) == HasPerk) ||
                (Perk != 7 && ForSalePickup.default.CorrespondingPerkIndex == 7) || 
                (ForSalePickup.default.InventoryType == class'Deagle' && IsInInventory(class'DualDeaglePickup')); 
                
            if (shouldSkip) {
                continue;
            }

            if (class<DualDeagle>(ForSalePickup.default.InventoryType) != none) {
                if (IsInInventory(class'DeaglePickup')) {
                    DualDivider = 2;
                }
            }
            else {
                DualDivider = 1;
                bZeroWeight = false;
            }

            if (currentIndex >= ForSaleBuyables.Length) {
                ForSaleBuyable = new class'GUIBuyable';
                ForSaleBuyables[ForSaleBuyables.Length] = ForSaleBuyable;
            }
            else {
                ForSaleBuyable = ForSaleBuyables[currentIndex];
            }

            currentIndex++;

            ForSaleBuyable.ItemName         = ForSalePickup.default.ItemName;
            ForSaleBuyable.ItemDescription  = ForSalePickup.default.Description;
            ForSaleBuyable.ItemCategorie    = KFLR.EquipmentCategories[i].EquipmentCategoryName;
            ForSaleBuyable.ItemImage        = class<KFWeapon>(ForSalePickup.default.InventoryType).default.TraderInfoTexture;
            ForSaleBuyable.ItemWeaponClass  = class<KFWeapon>(ForSalePickup.default.InventoryType);
            ForSaleBuyable.ItemAmmoClass    = class<KFWeapon>(ForSalePickup.default.InventoryType).default.FireModeClass[0].default.AmmoClass;
            ForSaleBuyable.ItemPickupClass  = ForSalePickup;
            ForSaleBuyable.ItemCost         = int((float(ForSalePickup.default.Cost)
                                              * PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
            ForSaleBuyable.ItemAmmoCost     = 0;
            ForSaleBuyable.ItemFillAmmoCost = 0;

            if (bZeroWeight) {
                ForSaleBuyable.ItemWeight   = 1.f;
            } else {
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
