class KFRLinkedReplicationInfo extends LinkedReplicationInfo;

var RollbackPack pack;
var localized string perkChangeTraderMsg;

replication {
    reliable if (Role != ROLE_Authority)
       buyWeapon,changePerk;
}

simulated function buyWeapon();
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
