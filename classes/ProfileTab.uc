class ProfileTab extends KFTab_Profile;

function SaveSettings()
{
	local PlayerController PC;

	PC = PlayerOwner();

	if ( sChar != sCharD )
	{
		sCharD = sChar;
		PC.ConsoleCommand("ChangeCharacter"@sChar);

		if ( !PC.IsA('xPlayer') )
		{
			PC.UpdateURL("Character", sChar, True);
		}

		if ( PlayerRec.Sex ~= "Female" )
		{
			PC.UpdateURL("Sex", "F", True);
		}
		else
		{
			PC.UpdateURL("Sex", "M", True);
		}
	}

	class'KFPlayerController'.default.SelectedVeterancy = class'KFGameType'.default.LoadedSkills[lb_PerkSelect.GetIndex()];

	if ( KFPlayerController(PC) != none )
	{
		KFPlayerController(PC).SelectedVeterancy = class'KFGameType'.default.LoadedSkills[lb_PerkSelect.GetIndex()];
		KFPlayerController(PC).SendSelectedVeterancyToServer();
		PC.SaveConfig();
	}
	else
	{
		class'KFPlayerController'.static.StaticSaveConfig();
	}
}

function OnPerkSelected(GUIComponent Sender)
{
	if ( KFStatsAndAchievements.bUsedCheats )
	{
		lb_PerkEffects.SetContent(class'LobbyMenu'.default.PerksDisabledString);
	}
	else
	{
		lb_PerkEffects.SetContent(class'KFGameType'.default.LoadedSkills[lb_PerkSelect.GetIndex()].default.LevelEffects[KFStatsAndAchievements.PerkHighestLevelAvailable(lb_PerkSelect.GetIndex())]);

		lb_PerkProgress.List.PerkChanged(KFStatsAndAchievements, lb_PerkSelect.GetIndex());
	}
}

