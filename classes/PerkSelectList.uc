class PerkSelectList extends KFPerkSelectList;

var KFRLinkedReplicationInfo kfrLRepInfo;

function InitList(KFSteamStatsAndAchievements StatsAndAchievements) {
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

function DrawPerk(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending) {
    local float TempX, TempY;
    local float IconSize, ProgressBarWidth;
    local float TempWidth, TempHeight;

    // Offset for the Background
    TempX = X;
    TempY = Y + ItemSpacing / 2.0;

    // Initialize the Canvas
    Canvas.Style = 1;
    Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
    Canvas.SetDrawColor(255, 255, 255, 255);

    // Calculate the Icon's Size
    IconSize = Height - ItemSpacing;// - (ItemBorder * 2.0 * Height);

    // Draw Item Background
    Canvas.SetPos(TempX, TempY);
    if ( bSelected ) {
        Canvas.DrawTileStretched(SelectedPerkBackground, IconSize, IconSize);
        Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
        Canvas.DrawTileStretched(SelectedInfoBackground, Width - IconSize, Height - ItemSpacing - 14);
    }
    else {
        Canvas.DrawTileStretched(PerkBackground, IconSize, IconSize);
        Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
        Canvas.DrawTileStretched(InfoBackground, Width - IconSize, Height - ItemSpacing - 14);
    }

    IconSize -= IconBorder * 2.0 * Height;

    // Draw Icon
    Canvas.SetPos(TempX + IconBorder * Height, TempY + IconBorder * Height);
    Canvas.DrawTile(kfrLRepInfo.pack.getPerks()[CurIndex].default.OnHUDIcon, IconSize, IconSize, 0, 0, 256, 256);

    TempX += IconSize + (IconToInfoSpacing * Width);
    TempY += TextTopOffset * Height + ItemBorder * Height;

    ProgressBarWidth = Width - (TempX - X) - (IconToInfoSpacing * Width);

    // Select Text Color
    if ( CurIndex == MouseOverIndex ) {
        Canvas.SetDrawColor(255, 0, 0, 255);
    }
    else {
        Canvas.SetDrawColor(0, 0, 0, 255);
    }

    // Draw the Perk's Level Name
    Canvas.StrLen(PerkName[CurIndex], TempWidth, TempHeight);
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawText(PerkName[CurIndex]);

    // Draw the Perk's Level
    if ( PerkLevelString[CurIndex] != "" ) {
        Canvas.StrLen(PerkLevelString[CurIndex], TempWidth, TempHeight);
        Canvas.SetPos(TempX + ProgressBarWidth - TempWidth, TempY);
        Canvas.DrawText(PerkLevelString[CurIndex]);
    }

    TempY += TempHeight - (0.04 * Height);

    // Draw Progress Bar
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawTileStretched(ProgressBarBackground, ProgressBarWidth, ProgressBarHeight * Height);
    Canvas.SetPos(TempX + 3.0, TempY + 3.0);
    Canvas.DrawTileStretched(ProgressBarForeground, (ProgressBarWidth - 6.0) * PerkProgress[CurIndex], (ProgressBarHeight * Height) - 6.0);
}
