class KFRSteamStats extends KFSteamStatsAndAchievements;

var KFRLinkedReplicationInfo kfrLRepInfo;

function WaveEnded() {
    super.WaveEnded();

    if (kfrLRepInfo == None) {
        kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.
                findLRI(PlayerController(Owner).PlayerReplicationInfo);
    }
    KFPlayerReplicationInfo(PlayerController(Owner).PlayerReplicationInfo).
            ClientVeteranSkillLevel= kfrLRepInfo.desiredPerkLevel;
}
