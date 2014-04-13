class KFRLinkedReplicationInfo extends LinkedReplicationInfo;

var RollbackPack pack;

replication {
    reliable if (Role != ROLE_Authority)
       buyWeapon,changePerk;
}

simulated function buyWeapon();
simulated function changePerk(class<KFVeterancyTypes> perk, int level);
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
