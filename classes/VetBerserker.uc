class VetBerserker extends KFVetBerserker
    abstract;

var array<float> bloatDamageScale, damageScale;

static function float GetMeleeMovementSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    if (KFPRI.ClientVeteranSkillLevel != 0) {
        return 0.15;
    }
    return 0;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster Instigator, int InDamage, class<DamageType> DmgType) {
    local float scale;

    if (DmgType == class'DamTypeVomit') {
        scale= default.bloatDamageScale[KFPRI.ClientVeteranSkillLevel];
    } else {
        scale= default.damageScale[KFPRI.ClientVeteranSkillLevel];
    }

    return float(InDamage) * scale;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if (Item == class'KFRollback.ChainsawPickup' || Item == class'KFRollback.KatanaPickup') {
        return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel));
    }
    return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them Machete
    if (KFPRI.ClientVeteranSkillLevel == 5) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFRollback.Machete", GetCostScaling(KFPRI, class'KFRollback.MachetePickup'));
    }
}

defaultproperties {
    VeterancyName="Berserker"

    bloatDamageScale(0)=0.9
    bloatDamageScale(1)=0.75
    bloatDamageScale(2)=0.65
    bloatDamageScale(3)=0.50
    bloatDamageScale(4)=0.35
    bloatDamageScale(5)=0.25
    bloatDamageScale(6)=0.20

    damageScale(0)=1.0
    damageScale(1)=0.95
    damageScale(2)=0.90
    damageScale(3)=0.85
    damageScale(4)=0.85
    damageScale(5)=0.80
    damageScale(6)=0.80

    LevelEffects(0)="10% extra melee damage|10% less damage from Bloat Bile|10% discount on Chainsaw and Katana|Can't be grabbed by Clots"
    LevelEffects(1)="20% extra melee damage|5% faster melee attacks|15% faster melee movement|25% less damage from Bloat Bile|5% resistance to all damage|20% discount on Chainsaw and Katana|Can't be grabbed by Clots"
    LevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|35% less damage from Bloat Bile|10% resistance to all damage|30% discount on Chainsaw and Katana|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(3)="60% extra melee damage|10% faster melee attacks|15% faster melee movement|50% less damage from Bloat Bile|15% resistance to all damage|40% discount on Chainsaw and Katana|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
    LevelEffects(4)="80% extra melee damage|15% faster melee attacks|15% faster melee movement|65% less damage from Bloat Bile|15% resistance to all damage|50% discount on Chainsaw and Katana|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
    LevelEffects(5)="100% extra melee damage|20% faster melee attacks|15% faster melee movement|75% less damage from Bloat Bile|20% resistance to all damage|60% discount on Chainsaw and Katana|Spawn with a Machete|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
