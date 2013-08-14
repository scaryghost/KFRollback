class KFRLobbyMenu extends LobbyMenu;

var string profilePage;

function bool ShowPerkMenu(GUIComponent Sender) {
    if (PlayerOwner() != none) {
        PlayerOwner().ClientOpenMenu(profilePage, false);
    }
    return true;
}

function DrawPerk(Canvas Canvas)
{
	local float X, Y, Width, Height;
	local int CurIndex, LevelIndex;
	local float TempX, TempY;
	local float TempWidth, TempHeight;
	local float IconSize, ProgressBarWidth, PerkProgress;
	local string PerkName, PerkLevelString;
	local bool focused;

	DrawPortrait();

	focused = Controller.ActivePage == self;

	if (focused)
	{
		VideoTimer += Controller.RenderDelta;
	}
	else
	{
		if (LobbyMenuAd == None || !LobbyMenuAd.MenuMovie.IsPlaying())
		{
			VideoTimer = 0.0;
		}

		VideoPlayed = false;
	}

	if (focused && LobbyMenuAd != None)
	{
		Canvas.SetPos(0.066797 * Canvas.ClipX + 5, 0.325208 * Canvas.ClipY + 30);
		X = Canvas.ClipX / 1024; // X & Y scale

		AdBackground.WinWidth = 320 * X + 10;
		AdBackground.WinHeight = 240 * X + 37;

//		if ( !VideoOpened && (LobbyMenuAd.GetState() == ADASSET_STATE_DOWNLOADED))
//		{
//			// Open the video
//			VideoOpened = true;
//
//			LobbyMenuAd.MenuMovie.Open(LobbyMenuAd.DownloadPath);
//		}
		/*else*/ if ( !VideoOpened /*&& (LobbyMenuAd.GetState() == ADASSET_STATE_ERROR)*/)
		{
			// Open the video
			VideoOpened = true;
			LobbyMenuAd.MenuMovie.Open("../Movies/Movie"$(rand(MAX_MOVIES) + 1)$".bik");
		}

		// Hold on the first frame for 3 seconds so it doesn't
		// Overwhelm the player
		if ( !VideoPlayed && VideoTimer > 3.0 )
		{
			// Start video
			VideoPlayed = true;
			LobbyMenuAd.MenuMovie.Play(false);
		}

		Canvas.DrawTile(LobbyMenuAd.MenuMovie, 320 * X, 240 * X,
				0, 0, 320, 240);
	}

	if ( KFPlayerController(PlayerOwner()) == none || KFPlayerController(PlayerOwner()).SelectedVeterancy == none ||
		 KFSteamStatsAndAchievements(PlayerOwner().SteamStatsAndAchievements) == none )
	{
		return;
	}
	else

	CurIndex = KFPlayerController(PlayerOwner()).SelectedVeterancy.default.PerkIndex;
	LevelIndex = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkillLevel;
	PerkName =  KFPlayerController(PlayerOwner()).SelectedVeterancy.default.VeterancyName;
	PerkLevelString = LvAbbrString @ LevelIndex;
	PerkProgress = 0;

	//Get the position size etc in pixels
	X = i_BGPerk.ActualLeft() + 5;
	Y = i_BGPerk.ActualTop() + 30;

	Width = i_BGPerk.ActualWidth() - 10;
	Height = i_BGPerk.ActualHeight() - 37;

	// Offset for the Background
	TempX = X;
	TempY = Y + ItemSpacing / 2.0;

	// Initialize the Canvas
	Canvas.Style = 1;
	Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);
	//Canvas.DrawTileStretched(ItemBackground, Width, Height);

	IconSize = Height - ItemSpacing;

	// Draw Item Background
	Canvas.DrawTileStretched(PerkBackground, IconSize, IconSize);
	Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
	Canvas.DrawTileStretched(InfoBackground, Width - IconSize, Height - ItemSpacing - 14);

	IconSize -= IconBorder * 2.0 * Height;

	// Draw Icon
	Canvas.SetPos(TempX + IconBorder * Height, TempY + IconBorder * Height);
	Canvas.DrawTile(class'KFGameType'.default.LoadedSkills[CurIndex].default.OnHUDIcon, IconSize, IconSize, 0, 0, 256, 256);

	TempX += IconSize + (IconToInfoSpacing * Width);
	TempY += TextTopOffset * Height + ItemBorder * Height;

	ProgressBarWidth = Width - (TempX - X) - (IconToInfoSpacing * Width);

	// Select Text Color
	Canvas.SetDrawColor(0, 0, 0, 255);

	// Draw the Perk's Level name
	Canvas.StrLen(PerkName, TempWidth, TempHeight);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawText(PerkName);

	// Draw the Perk's Level
	if ( PerkLevelString != "" )
	{
		Canvas.StrLen(PerkLevelString, TempWidth, TempHeight);
		Canvas.SetPos(TempX + ProgressBarWidth - TempWidth, TempY);
		Canvas.DrawText(PerkLevelString);
	}

	TempY += TempHeight + (0.04 * Height);

	// Draw Progress Bar
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawTileStretched(ProgressBarBackground, ProgressBarWidth, ProgressBarHeight * Height);
	Canvas.SetPos(TempX + 3.0, TempY + 3.0);
	Canvas.DrawTileStretched(ProgressBarForeground, (ProgressBarWidth - 6.0) * PerkProgress, (ProgressBarHeight * Height) - 6.0);

	if ( PlayerOwner().SteamStatsAndAchievements.bUsedCheats )
	{
		if ( CurrentVeterancyLevel != 255 )
		{
			lb_PerkEffects.SetContent(PerksDisabledString);
			CurrentVeterancyLevel = 255;
		}
	}
	else if ( CurrentVeterancy != KFPlayerController(PlayerOwner()).SelectedVeterancy || CurrentVeterancyLevel != LevelIndex )
	{
		lb_PerkEffects.SetContent(KFPlayerController(PlayerOwner()).SelectedVeterancy.default.LevelEffects[LevelIndex]);
		CurrentVeterancy = KFPlayerController(PlayerOwner()).SelectedVeterancy;
		CurrentVeterancyLevel = LevelIndex;
	}
}


defaultproperties {
    profilePage="KFRollback.KFRProfilePage"

    Begin Object Class=KFRLobbyFooter Name=Footer
        RenderWeight=0.300000
        TabOrder=8
        bBoundToParent=False
        bScaleToParent=False
        OnPreDraw=BuyFooter.InternalOnPreDraw
    End Object
    t_Footer=LobbyFooter'KFRollback.KFRLobbyMenu.Footer'
}
