class KFRVetFieldMedic extends KFVetFieldMedic
    abstract;

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI) {
    if (KFPRI.ClientVeteranSkillLevel <= 1) {
        return 1.0;
    }
    return 1.05 + (0.05 * float(KFPRI.ClientVeteranSkillLevel - 2)); // Moves up to 20% faster
}

defaultproperties {
    VeterancyName="Field Medic"

    LevelEffects(0)="10% faster Syringe recharge|10% more potent healing|10% less damage from Bloat Bile|10% discount on Body Armor"
    LevelEffects(1)="25% faster Syringe recharge|25% more potent healing|25% less damage from Bloat Bile|10% better Body Armor|20% discount on Body Armor"
    LevelEffects(2)="50% faster Syringe recharge|25% more potent healing|50% less damage from Bloat Bile|5% faster movement speed|20% better Body Armor|30% discount on Body Armor"
    LevelEffects(3)="75% faster Syringe recharge|50% more potent healing|50% less damage from Bloat Bile|10% faster movement speed|30% better Body Armor|40% discount on Body Armor"
    LevelEffects(4)="100% faster Syringe recharge|50% more potent healing|50% less damage from Bloat Bile|15% faster movement speed|40% better Body Armor|50% discount on Body Armor"
    LevelEffects(5)="150% faster Syringe recharge|50% more potent healing|75% less damage from Bloat Bile|20% faster movement speed|50% better Body Armor|60% discount on Body Armor|Spawn with Body Armor"
}
