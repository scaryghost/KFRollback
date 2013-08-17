class KFRPerkProgressList extends KFPerkProgressList;

function PerkChanged(KFSteamStatsAndAchievements KFStatsAndAchievements, int NewPerkIndex) {
    RequirementString.Length= 0;
    RequirementProgressString.Length= 0;
    RequirementPRogress.Length= 0;

    if (MyScrollBar != none ) {
        MyScrollBar.AlignThumb();
    }
}
