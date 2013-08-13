class KFRPerkSelectList extends KFPerkSelectList;

function InitList(KFSteamStatsAndAchievements StatsAndAchievements)
{
	local int i;
	local KFRPlayerController KFPC;

	// Grab the Player Controller for later use
	KFPC = KFRPlayerController(PlayerOwner());

	// Hold onto our reference
	KFStatsAndAchievements = StatsAndAchievements;

	// Update the ItemCount and select the first item
	ItemCount = class'PerkList'.default.perks.Length;
	SetIndex(0);

	PerkName.Remove(0, PerkName.Length);
	PerkLevelString.Remove(0, PerkLevelString.Length);
	PerkProgress.Remove(0, PerkProgress.Length);

	for ( i = 0; i < ItemCount; i++ )
	{
		PerkName[PerkName.Length] = class'PerkList'.default.perks[i].default.VeterancyName;
		PerkLevelString[PerkLevelString.Length] = LvAbbrString @ (KFStatsAndAchievements.PerkHighestLevelAvailable(i));
		PerkProgress[PerkProgress.Length] = KFStatsAndAchievements.GetPerkProgress(i);

		if ( (KFPC != none && class'PerkList'.default.perks[i] == KFPC.SelectedVeterancy) ||
			 (KFPC == none && class'PerkList'.default.perks[i] == class'KFRPlayerController'.default.SelectedVeterancy) )
		{
			SetIndex(i);
		}
	}

	if ( bNotify )
 	{
		CheckLinkedObjects(Self);
	}

	if ( MyScrollBar != none )
	{
		MyScrollBar.AlignThumb();
	}
}

