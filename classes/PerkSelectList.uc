class PerkSelectList extends KFPerkSelectList;

function InitList(KFSteamStatsAndAchievements StatsAndAchievements) {
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local int i;
    local KFPlayerController KFPC;

    // Grab the Player Controller for later use
    KFPC= KFPlayerController(PlayerOwner());

    // Hold onto our reference
    KFStatsAndAchievements= StatsAndAchievements;

    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(KFPC.PlayerReplicationInfo);

    // Update the ItemCount and select the first item
    ItemCount= kfrLRepInfo.pack.getPerks().Length;
    SetIndex(0);

    PerkName.Remove(0, PerkName.Length);
    PerkLevelString.Remove(0, PerkLevelString.Length);
    PerkProgress.Remove(0, PerkProgress.Length);

    for (i= 0; i < ItemCount; i++) {
        PerkName[PerkName.Length] = kfrLRepInfo.pack.getPerks()[i].default.VeterancyName;
        PerkLevelString[PerkLevelString.Length] = LvAbbrString @ KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).ClientVeteranSkillLevel;
        PerkProgress[PerkProgress.Length] = 0;

        if (kfrLRepInfo.pack.getPerks()[i] == KFPC.SelectedVeterancy) {
            SetIndex(i);
        }
    }

    if (bNotify) {
        CheckLinkedObjects(Self);
    }

    if (MyScrollBar != none) {
        MyScrollBar.AlignThumb();
    }
}

