class PerkTab extends KFTab_Perks;

function bool OnSaveButtonClicked(GUIComponent Sender)
{
	local PlayerController PC;

	PC = PlayerOwner();

	if ( KFPlayerController(PC) != none )
	{
		if ( KFPlayerController(PC).bChangedVeterancyThisWave && KFPlayerController(PC).SelectedVeterancy != class'PerkList'.default.perks[lb_PerkSelect.GetIndex()] )
		{
			l_ChangePerkOncePerWave.SetVisibility(true);
		}
		else
		{
			class'KFRPlayerController'.default.SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
			KFPlayerController(PC).SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
            PC.ConsoleCommand("mutate perkchange "$lb_PerkSelect.GetIndex());
			PC.SaveConfig();
		}
	}
	else
	{
		class'KFRPlayerController'.default.SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
		class'KFRPlayerController'.static.StaticSaveConfig();
	}

	return true;
}
