class KFRLinkedReplicationInfo extends LinkedReplicationInfo
    dependson(RollbackPack);

var KFRMutator mut;
var RollbackPack pack;
var string packName;
var localized string perkChangeTraderMsg;
var int desiredPerkLevel;

replication {
    reliable if (Role != ROLE_Authority)
       buyWeapon, sendPerkToServer, sellWeapon;
    reliable if (Role == ROLE_Authority)
        packName, desiredPerkLevel;
}

simulated function Tick(float DeltaTime) {
    local KFLevelRules it;

    super.Tick(DeltaTime);

    if (pack == None && Role < ROLE_Authority) {
        pack= new class<RollbackPack>(DynamicLoadObject(packName, class'Class'));
        foreach DynamicActors(class'KFMod.KFLevelRules', it) {
            it.ItemForSale= pack.getWeaponPickups();
        }
    }
}

function buyWeapon(Class<Weapon> WClass, float ItemWeight) {
    local int index;
    local array<RollbackPack.DualInfo> dualWeapons;
    local KFPlayerController kfPC;
    local Inventory I, J;
    local float Price;

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
    } else if (Class<KFWeapon>(WClass).Default.UnlockedByAchievement != -1) {
        if (KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements) == none ||
             KFSteamStatsAndAchievements(kfPC.PlayerReplicationInfo.SteamStatsAndAchievements).Achievements[Class<KFWeapon>(WClass).Default.UnlockedByAchievement].bCompleted != 1 ) {
            return;
        }
    }

    Price= class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;
    if (KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill != none) {
        Price *= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo), WClass.Default.PickupClass);
    }

    dualWeapons= pack.getDualWeapons();
    for(index= 0; index < dualWeapons.Length; index++) {
        if (WClass == dualWeapons[index].dualWeapon) {
            for (J= kfPC.Pawn.Inventory; J != None; J = J.Inventory) {
                if (J.class == dualWeapons[index].singleWeapon) {
                    Price = Price / 2;
                    break;
                }
            }
        }
    }

    if (!KFPawn(kfPC.Pawn).CanCarry(ItemWeight)) {
        Return;
    }

    if (kfPC.PlayerReplicationInfo.Score < Price) {
        Return; // Not enough CASH.
    }

    I = Spawn(WClass);

    if (I != none) {
        mut.weaponSpawned(I);

        KFWeapon(I).UpdateMagCapacity(kfPC.PlayerReplicationInfo);
        KFWeapon(I).FillToInitialAmmo();
        KFWeapon(I).SellValue = Price * 0.75;
        I.GiveTo(kfPC.Pawn);
        kfPC.PlayerReplicationInfo.Score -= Price;

        KFPawn(kfPC.Pawn).ClientForceChangeWeapon(I);
    }

    KFPawn(kfPC.Pawn).SetTraderUpdate();
}

simulated function sellWeapon(class<Weapon> WClass) {
    local array<RollbackPack.DualInfo> dualWeapons;
    local KFPlayerController kfPC;
    local KFWeapon newWeapon;
    local Inventory I;
    local float Price;
    local int index;

    kfPC= KFPlayerController(Owner);
    if ( !KFPawn(kfPC.Pawn).CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass) == none ) {
        KFPawn(kfPC.Pawn).SetTraderUpdate();
        Return;
    }
    dualWeapons= pack.getDualWeapons();
    for (I = kfPC.Pawn.Inventory; I != none; I = I.Inventory) {
        if (I.Class == WClass) {
            if (KFWeapon(I) != none && KFWeapon(I).SellValue != -1) {
                Price = KFWeapon(I).SellValue;
            } else {
                Price = int(class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

                if (KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill != none) {
                    Price *= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo).ClientVeteranSkill.static.
                            GetCostScaling(KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo), WClass.Default.PickupClass);
                }
            }

            for(index= 0; index < dualWeapons.Length; index++) {
                if (I.class == dualWeapons[index].dualWeapon) {
                    newWeapon= Spawn(dualWeapons[index].singleWeapon);
                    newWeapon.GiveTo(kfPC.Pawn);
                    Price/= 2;
                    newWeapon.SellValue= Price;
                }
            }

            if (I == kfPC.Pawn.Weapon || I == kfPC.Pawn.PendingWeapon) {
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

simulated function sendPerkToServer(class<KFVeterancyTypes> perk, int level) {
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
                kfRepInfo.ClientVeteranSkillLevel= level;

                if( KFHumanPawn(kfPC.Pawn) != none ) {
                    KFHumanPawn(kfPC.Pawn).VeterancyChanged();
                }    
            } else {
                kfPC.ClientMessage(kfPC.PerkChangeOncePerWaveString);
            }
    }
}

function changePerk(int perkIndex) {
    local KFPlayerController kfPC;

    kfPC= KFPlayerController(Owner);
    kfPC.SelectedVeterancy= pack.getPerks()[perkIndex];
    sendPerkToServer(kfPC.SelectedVeterancy, desiredPerkLevel);
}

function changeRandomPerk() {
    changePerk(Rand(pack.getPerks().Length));
}

static function KFRLinkedReplicationInfo findLRI(PlayerReplicationInfo pri) {
    local LinkedReplicationInfo lriIt;

    if (pri == None) {
        return None;
    }
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
