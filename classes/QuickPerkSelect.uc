class QuickPerkSelect extends KFGui.KFQuickPerkSelect;

function bool InternalOnClick(GUIComponent Sender)
{
    local PlayerController PC;

    // Grab the Player Controller for later use
    PC = PlayerOwner();
    
    if ( Sender.IsA('KFIndexedGUIImage') && !KFPlayerController(PC).bChangedVeterancyThisWave )
    {
        KFPlayerController(PC).SelectedVeterancy = class'PerkList'.default.perks[KFIndexedGUIImage(Sender).Index];
        PC.ConsoleCommand("mutate perkchange "$KFIndexedGUIImage(Sender).Index);
        PC.SaveConfig();
        bPerkChange = true;
    }
    
    return false;   
}

function bool MyOnDraw(Canvas C)
{                                                                                                         
    local int i, j;

    super.OnDraw(C);
    
    C.SetDrawColor(255, 255, 255, 255);
    
    // make em square
    if ( !bResized )
    {
        ResizeIcons(C);
    }   
        
    // Current perk background
    C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);
    C.DrawTileScaled(CurPerkBack, (WinHeight * C.ClipY) / CurPerkBack.USize, (WinHeight * C.ClipY) / CurPerkBack.USize);
    
    // check if the current perk has changed recently

    CheckPerks(KFStatsAndAchievements);

    j = 0;
    
    // Draw the available perks
    for ( i = 0; i < MaxPerks; i++ )
    {
        if ( i != CurPerk )
        {       
            PerkSelectIcons[j].Image = class'PerkList'.default.perks[i].default.OnHUDIcon;
            PerkSelectIcons[j].Index = i;
        
            if ( KFPlayerController(PlayerOwner()).bChangedVeterancyThisWave )
            {
                PerkSelectIcons[j].ImageColor.A = 64;   
            }
            else
            {
                PerkSelectIcons[j].ImageColor.A = 255;  
            }
            
            j++;
        }
    }

    // Draw current perk
    DrawCurrentPerk(C, CurPerk);
    
    return false;
}

function DrawCurrentPerk(Canvas C, Int PerkIndex)
{       
    C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);             
    C.DrawTileScaled(class'PerkList'.default.perks[PerkIndex].default.OnHUDIcon, (WinHeight * C.ClipY) / class'PerkList'.default.perks[PerkIndex].default.OnHUDIcon.USize, (WinHeight * C.ClipY) / class'PerkList'.default.perks[PerkIndex].default.OnHUDIcon.USize);
}

function CheckPerks(KFSteamStatsAndAchievements StatsAndAchievements)
{
    local int i;
    local KFPlayerController KFPC;

    // Grab the Player Controller for later use
    KFPC = KFPlayerController(PlayerOwner());
                                                                                         
    // Hold onto our reference
    KFStatsAndAchievements = StatsAndAchievements;

    // Update the ItemCount and select the first item
    MaxPerks = class'PerkList'.default.perks.Length;
    //SetIndex(0);

    for ( i = 0; i < MaxPerks; i++ )
    {
        if (class'PerkList'.default.perks[i] == KFPC.SelectedVeterancy) {
            CurPerk = i;
        }
    }
    
    bPerkChange = false;
}
