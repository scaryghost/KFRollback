class KFRLinkedReplicationInfo extends LinkedReplicationInfo;

var KFRMutator mut;
var RollbackPack pack;
var localized string perkChangeTraderMsg;

replication {
    reliable if (Role != ROLE_Authority)
       buyWeapon,changePerk,sellWeapon;
}

function buyWeapon(Class<Weapon> WClass, float ItemWeight) {
    local KFPlayerController kfPC;
    local Inventory I, J;
    local float Price;
    local bool bIsDualWeapon, bHasDual9mms, bHasDualHCs, bHasDualRevolvers;

    kfPC= KFPlayerController(Owner);
    if ( !KFPawn(kfPC.Pawn).CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass) == none ) {
        return;
    }

    if (Class<KFWeapon>(WClass).Default.AppID > 0 && Class<KFWeapon>(WClass).Default.UnlockedByAchievement != -1) {
        if (KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements) == none ||
            (!KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).PlayerOwnsWeaponDLC(Class<KFWeapon>(WClass).Default.AppID) &&
             KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).Achievements[Class<KFWeapon>(WClass).Default.UnlockedByAchievement].bCompleted != 1 )) {
            return;
        }

    } else if (Class<KFWeapon>(WClass).Default.AppID > 0) {
        if (KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements) == none ||
            !KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).PlayerOwnsWeaponDLC(Class<KFWeapon>(WClass).Default.AppID)) {
            return;
        }
    }
    else if (Class<KFWeapon>(WClass).Default.UnlockedByAchievement != -1) {
        if (KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements) == none ||
             KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).Achievements[Class<KFWeapon>(WClass).Default.UnlockedByAchievement].bCompleted != 1 ) {
            return;
        }
    }

    Price= class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;
    if (KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill != none) {
        Price *= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo), WClass.Default.PickupClass);
    }

    for (I= kfPC.Pawn.Inventory; I != None; I= I.Inventory ) {
        if (I.Class==WClass) {
            Return; // Already has weapon.
        }

        if (I.Class == class'Dualies') {
            bHasDual9mms = true;
        }
        else if (I.Class == class'DualDeagle' || I.Class == class'GoldenDualDeagle') {
            bHasDualHCs = true;
        }
        else if (I.Class == class'Dual44Magnum') {
            bHasDualRevolvers = true;
        }
    }

    if (WClass == class'DualDeagle') {
        for (J= kfPC.Pawn.Inventory; J != None; J = J.Inventory) {
            if ( J.class == class'Deagle' )
            {
                Price = Price / 2;
                break;
            }
        }

        bIsDualWeapon = true;
        bHasDualHCs = true;
    }

    if ( WClass == class'GoldenDualDeagle' )
    {
        for ( J = kfPC.Pawn.Inventory; J != None; J = J.Inventory )
        {
            if ( J.class == class'GoldenDeagle' )
            {
                Price = Price / 2;
                break;
            }
        }

        bIsDualWeapon = true;
        bHasDualHCs = true;
    }

    if ( WClass == class'Dual44Magnum' )
    {
        for ( J = kfPC.Pawn.Inventory; J != None; J = J.Inventory )
        {
            if ( J.class == class'Magnum44Pistol' )
            {
                Price = Price / 2;
                break;
            }
        }

        bIsDualWeapon = true;
        bHasDualRevolvers = true;
    }

    if ( WClass == class'DualMK23Pistol' )
    {
        for ( J = kfPC.Pawn.Inventory; J != None; J = J.Inventory )
        {
            if ( J.class == class'MK23Pistol' )
            {
                Price = Price / 2;
                break;
            }
        }

        bIsDualWeapon = true;
    }

    if ( WClass == class'DualFlareRevolver' )
    {
        for ( J = kfPC.Pawn.Inventory; J != None; J = J.Inventory )
        {
            if ( J.class == class'FlareRevolver' )
            {
                Price = Price / 2;
                break;
            }
        }

        bIsDualWeapon = true;
    }

    bIsDualWeapon = bIsDualWeapon || WClass == class'Dualies';

    if ( !KFPawn(kfPC.Pawn).CanCarry(ItemWeight) )
    {
        Return;
    }

    if ( kfPC.PlayerReplicationInfo.Score < Price )
    {
        Return; // Not enough CASH.
    }

    I = Spawn(WClass);

    if ( I != none )
    {
        mut.weaponSpawned(I);

        KFWeapon(I).UpdateMagCapacity(kfPC.PlayerReplicationInfo);
        KFWeapon(I).FillToInitialAmmo();
        KFWeapon(I).SellValue = Price * 0.75;
        I.GiveTo(kfPC.Pawn);
        kfPC.PlayerReplicationInfo.Score -= Price;

        if ( bIsDualWeapon )
        {
            KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).OnDualsAddedToInventory(bHasDual9mms, bHasDualHCs, bHasDualRevolvers);
        }

        KFPawn(kfPC.Pawn).ClientForceChangeWeapon(I);
    }

    KFPawn(kfPC.Pawn).SetTraderUpdate();
}

simulated function sellWeapon(class<Weapon> WClass) {
    local KFPlayerController kfPC;
    local Inventory I;
    local Single NewSingle;
    local Deagle NewDeagle;
    local Magnum44Pistol New44Magnum;
    local MK23Pistol NewMK23;
    local FlareRevolver NewFlare;
    local float Price;

    kfPC= KFPlayerController(Owner);
    if ( !KFPawn(kfPC.Pawn).CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass) == none ) {
        KFPawn(kfPC.Pawn).SetTraderUpdate();
        Return;
    }

    for (I = kfPC.Pawn.Inventory; I != none; I = I.Inventory) {
        if (I.Class == WClass) {
            if (KFWeapon(I) != none && KFWeapon(I).SellValue != -1) {
                Price = KFWeapon(I).SellValue;
            }
            else {
                Price = int(class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

                if (KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill != none) {
                    Price *= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill.static.
                            GetCostScaling(KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo), WClass.Default.PickupClass);
                }
            }

            if ( Dualies(I) != none && DualDeagle(I) == none && Dual44Magnum(I) == none
                && DualMK23Pistol(I) == none && DualFlareRevolver(I) == none )
            {
                NewSingle = Spawn(class'Single');
                NewSingle.GiveTo(kfPC.Pawn);
            }

            if ( DualDeagle(I) != none )
            {
                if( GoldenDualDeagle(I) != none )
                {
                    NewDeagle = Spawn(class'GoldenDeagle');
                }
                else
                {
                    NewDeagle = Spawn(class'Deagle');
                }
                NewDeagle.GiveTo(kfPC.Pawn);
                Price = Price / 2;
                NewDeagle.SellValue = Price;
            }

            if ( Dual44Magnum(I) != none )
            {
                New44Magnum = Spawn(class'Magnum44Pistol');
                New44Magnum.GiveTo(kfPC.Pawn);
                Price = Price / 2;
                New44Magnum.SellValue = Price;
            }

            if ( DualMK23Pistol(I) != none )
            {
                NewMK23 = Spawn(class'MK23Pistol');
                NewMK23.GiveTo(kfPC.Pawn);
                Price = Price / 2;
                NewMK23.SellValue = Price;
            }

            if ( DualFlareRevolver(I) != none )
            {
                NewFlare = Spawn(class'FlareRevolver');
                NewFlare.GiveTo(kfPC.Pawn);
                Price = Price / 2;
                NewFlare.SellValue = Price;
            }

            if ( I == kfPC.Pawn.Weapon || I == kfPC.Pawn.PendingWeapon )
            {
                KFPawn(kfPC.Pawn).ClientCurrentWeaponSold();
            }

            kfPC.PlayerReplicationInfo.Score += Price;

            I.Destroyed();
            I.Destroy();

            KFPawn(kfPC.Pawn).SetTraderUpdate();

            mut.weaponDestroyed(WClass);
            return;
        }
    }
}

simulated function changePerk(class<KFVeterancyTypes> perk, int level) {
    local KFPlayerController kfPC;
    local KFPlayerReplicationInfo kfRepInfo;

    kfPC= KFPlayerController(Owner);
    kfRepInfo= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo);
    if (kfPC != none && kfRepInfo != none) {
            kfPC.SelectedVeterancy= perk;

            if (KFGameReplicationInfo(kfPC.GameReplicationInfo).bWaveInProgress && kfPC.SelectedVeterancy != kfRepInfo.ClientVeteranSkill) {
                kfPC.ClientMessage(perkChangeTraderMsg);
            } else if (!kfPC.bChangedVeterancyThisWave) {
                if (kfPC.SelectedVeterancy != kfRepInfo.ClientVeteranSkill) {
                    kfPC.ClientMessage(Repl(kfPC.YouAreNowPerkString, "%Perk%", kfPC.SelectedVeterancy.Default.VeterancyName));
                }
                if (kfPC.GameReplicationInfo.bMatchHasBegun) {
                    kfPC.bChangedVeterancyThisWave = true;
                }

                kfRepInfo.ClientVeteranSkill = kfPC.SelectedVeterancy;
                kfRepInfo.ClientVeteranSkillLevel= pack.getMaxPerkLevel();

                if( KFHumanPawn(kfPC.Pawn) != none ) {
                    KFHumanPawn(kfPC.Pawn).VeterancyChanged();
                }    
            } else {
                kfPC.ClientMessage(kfPC.PerkChangeOncePerWaveString);
            }
    }
}
function changeRandomPerk() {
    changePerk(pack.getPerks()[Rand(pack.getPerks().Length)], pack.getMaxPerkLevel());
}

static function KFRLinkedReplicationInfo findLRI(PlayerReplicationInfo pri) {
    local LinkedReplicationInfo lriIt;

    for(lriIt= pri.CustomReplicationInfo; lriIt != None && lriIt.class != class'KFRLinkedReplicationInfo';
            lriIt= lriIt.NextReplicationInfo) {
    }
    if (lriIt == None) {
        return None;
    }
    return KFRLinkedReplicationInfo(lriIt);
}

defaultproperties {
    perkChangeTraderMsg="You can only change perks during trader time"
}
