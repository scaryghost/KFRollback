class KFRLinkedReplicationInfo extends LinkedReplicationInfo;

replication {
    reliable if (Role != ROLE_Authority)
       buyWeapon,changePerk;
}

simulated function BuyWeapon();
simulated function changePerk(class<KFVeterancyTypes> perk, int level);

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
