class KFRLobbyFooter extends LobbyFooter;

function bool OnFooterClick(GUIComponent Sender)
{
	local GUIController C;
	local PlayerController PC;
	local int i;

	PC = PlayerOwner();
	C = Controller;
	if(Sender == b_Cancel)
	{
		//Kill Window and exit game/disconnect from server
		LobbyMenu(PageOwner).bAllowClose = true;
		C.ViewportOwner.Console.ConsoleCommand("DISCONNECT");
		KFGUIController(C).ReturnToMainMenu();
	}
	else if(Sender == b_Ready)
	{
		if ( PC.PlayerReplicationInfo.Team != none )
		{
			if ( PC.Level.NetMode == NM_Standalone || !PC.PlayerReplicationInfo.bReadyToPlay )
			{
				if ( KFPlayerController(PC) != none )
				{
                    PC.ConsoleCommand("mutate perkchange "$KFPlayerController(PC).SelectedVeterancy.default.PerkIndex);
				}

				//Set Ready
				PC.ServerRestartPlayer();
				PC.PlayerReplicationInfo.bReadyToPlay = True;
				if ( PC.Level.GRI.bMatchHasBegun )
					PC.ClientCloseMenu(true, false);

				b_Ready.Caption = UnreadyString;
			}
			else
			{
				if ( KFPlayerController(PC) != none )
				{
					KFPlayerController(PC).ServerUnreadyPlayer();
					PC.PlayerReplicationInfo.bReadyToPlay = False;
					b_Ready.Caption = ReadyString;
				}
			}
		}
	}
	else if (Sender == b_Options)
	{
		PC.ClientOpenMenu("KFGUI.KFSettingsPage", false);
	}
	else if ( Sender == b_Perks )
	{
		if( !Controller.CheckSteam() )
		{
			Controller.OpenMenu(Controller.QuestionMenuClass);
			GUIQuestionPage(Controller.TopPage()).SetupQuestion(class'KFMainMenu'.default.SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
			return false;
		}

		if ( PC != none )
		{
			if ( PC.SteamStatsAndAchievements == none )
			{
				if ( PC.Level.NetMode != NM_Client )
				{
					PC.SteamStatsAndAchievements = PC.Spawn(PC.default.SteamStatsAndAchievementsClass, PC);
					if ( !PC.SteamStatsAndAchievements.Initialize(PC) )
					{
						Controller.OpenMenu(Controller.QuestionMenuClass);
						GUIQuestionPage(Controller.TopPage()).SetupQuestion(class'KFMainMenu'.default.UnknownSteamErrorText, QBTN_Ok, QBTN_Ok);
						PC.SteamStatsAndAchievements.Destroy();
						PC.SteamStatsAndAchievements = none;
					}
					else
					{
						PC.SteamStatsAndAchievements.OnDataInitialized = OnSteamStatsAndAchievementsReady;
					}
				}
				else
				{
					Controller.OpenMenu(Controller.QuestionMenuClass);
					GUIQuestionPage(Controller.TopPage()).SetupQuestion(class'KFMainMenu'.default.UnknownSteamErrorText, QBTN_Ok, QBTN_Ok);
				}

				return false;
			}
			else if ( !PC.SteamStatsAndAchievements.bInitialized )
			{
				PC.SteamStatsAndAchievements.OnDataInitialized = OnSteamStatsAndAchievementsReady;
				PC.SteamStatsAndAchievements.GetStatsAndAchievements();
				return false;
			}

			for ( i = 0; i < class'PerkList'.default.perks.Length; i++ )
			{
				if ( KFSteamStatsAndAchievements(PC.SteamStatsAndAchievements).GetPerkProgress(i) < 0.0 )
				{
					Controller.OpenMenu(Controller.QuestionMenuClass);
					GUIQuestionPage(Controller.TopPage()).SetupQuestion(class'KFMainMenu'.default.UnknownSteamErrorText, QBTN_Ok, QBTN_Ok);
					PC.SteamStatsAndAchievements.OnDataInitialized = OnSteamStatsAndAchievementsReady;
					PC.SteamStatsAndAchievements.GetStatsAndAchievements();
					return false;
				}
			}

			PC.ClientOpenMenu(class'KFRLobbyMenu'.default.profilePage, false);
		}
	}

	return false;
}

function OnSteamStatsAndAchievementsReady()
{
	PlayerOwner().ClientOpenMenu(class'KFRLobbyMenu'.default.profilePage, false);
}

