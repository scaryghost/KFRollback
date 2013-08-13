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

	class'KFRPlayerController'.default.SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];

	if ( KFRPlayerController(PC) != none )
	{
		KFRPlayerController(PC).SelectedVeterancy = class'PerkList'.default.perks[lb_PerkSelect.GetIndex()];
		KFRPlayerController(PC).SendSelectedVeterancyToServer();
		PC.SaveConfig();
	}
	else
	{
		class'KFRPlayerController'.static.StaticSaveConfig();
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
		lb_PerkEffects.SetContent(class'PerkList'.default.perks[lb_PerkSelect.GetIndex()].default.LevelEffects[KFStatsAndAchievements.PerkHighestLevelAvailable(lb_PerkSelect.GetIndex())]);

		lb_PerkProgress.List.PerkChanged(KFStatsAndAchievements, lb_PerkSelect.GetIndex());
	}
}

defaultproperties {
    Begin Object Class=KFPerkSelectListBox Name=PerkSelectList
        OnCreateComponent=PerkSelectList.InternalOnCreateComponent
        WinTop=0.082969
        WinLeft=0.323418
        WinWidth=0.318980
        WinHeight=0.654653
        DefaultListClass="KFRollback.KFRPerkSelectList"
    End Object
    lb_PerkSelect=KFPerkSelectListBox'KFRollback.ProfileTab.PerkSelectList'
}
