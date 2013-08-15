class KFRVetSharpshooter extends KFVetSharpshooter
    abstract;

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
    if ( Item == class'KFRollback.DeaglePickup' || Item == class'KFRollback.DualDeaglePickup') {
        return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Handcannon/Dual Handcannons/EBR/44 Magnum(s)
    }

    return 1.0;
}

// Modify fire speed
static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other) {
    if (Winchester(Other) != none) {
        if (KFPRI.ClientVeteranSkillLevel == 0) {
            return 1.0;
        }
        return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% faster fire rate with Winchester
    }
    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a  Lever Action Rifle
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Winchester", GetCostScaling(KFPRI, class'WinchesterPickup'));
    }
}

defaultproperties {
    VeterancyName="Sharpshooter"

    LevelEffects(0)="5% more headshot damage with Pistols, Rifle, Crossbow|5% extra Headshot damage with all weapons|10% discount on Pistols"
    LevelEffects(1)="10% more headshot damage with Pistols, Rifle, Crossbow|25% less recoil with Pistols, Rifle, Crossbow|10% faster reload with Pistols, Rifle|10% extra headshot damage|20% discount on Pistols"
    LevelEffects(2)="15% more headshot damage with Pistols, Rifle, Crossbow|50% less recoil with Pistols, Rifle, Crossbow|20% faster reload with Pistols, Rifle|20% extra headshot damage|30% discount on Pistols"
    LevelEffects(3)="20% more headshot damage with Pistols, Rifle, Crossbow|75% less recoil with Pistols, Rifle, Crossbow|30% faster reload with Pistols, Rifle|30% extra headshot damage|40% discount on Pistols"
    LevelEffects(4)="30% more headshot damage with Pistols, Rifle, Crossbow|75% less recoil with Pistols, Rifle, Crossbow|40% faster reload with Pistols, Rifle|40% extra headshot damage|50% discount on Pistols"
    LevelEffects(5)="50% more headshot damage with Pistols, Rifle, Crossbow|75% less recoil with Pistols, Rifle, Crossbow|50% faster reload with Pistols, Rifle|50% extra headshot damage|60% discount on Pistols|Spawn with a Lever Action Rifle"
}
