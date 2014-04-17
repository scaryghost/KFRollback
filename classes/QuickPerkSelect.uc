class QuickPerkSelect extends KFGui.KFQuickPerkSelect;

var KFRLinkedReplicationInfo kfrLRepInfo;

event InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);
    
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
}

function bool InternalOnClick(GUIComponent Sender) {
    local PlayerController PC;

    // Grab the Player Controller for later use
    PC= PlayerOwner();
    if (Sender.IsA('KFIndexedGUIImage') && !KFPlayerController(PC).bChangedVeterancyThisWave) {
        kfrLRepInfo.changePerk(KFIndexedGUIImage(Sender).Index);
        bPerkChange = true;
    }
    
    return false;   
}

function bool MyOnDraw(Canvas C) {
    local int i, j;

    super.OnDraw(C);
    
    C.SetDrawColor(255, 255, 255, 255);
    
    // make em square
    if (!bResized) {
        ResizeIcons(C);
    }   
        
    // Current perk background
    C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);
    C.DrawTileScaled(CurPerkBack, (WinHeight * C.ClipY) / CurPerkBack.USize, (WinHeight * C.ClipY) / CurPerkBack.USize);
    
    // check if the current perk has changed recently

    CheckPerks(KFStatsAndAchievements);

    j = 0;
    
    // Draw the available perks
    for (i = 0; i < MaxPerks; i++) {
        if (i != CurPerk) {      
            PerkSelectIcons[j].Image = kfrLRepInfo.pack.getPerks()[i].default.OnHUDIcon;
            PerkSelectIcons[j].Index = i;
        
            if (KFPlayerController(PlayerOwner()).bChangedVeterancyThisWave) {
                PerkSelectIcons[j].ImageColor.A = 64;   
            }
            else {
                PerkSelectIcons[j].ImageColor.A = 255;  
            }
            
            j++;
        }
    }

    // Draw current perk
    DrawCurrentPerk(C, CurPerk);
    
    return false;
}

function DrawCurrentPerk(Canvas C, Int PerkIndex) {
    local class<KFVeterancyTypes> perk;

    perk= kfrLRepInfo.pack.getPerks()[PerkIndex];
    C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);
    C.DrawTileScaled(perk.default.OnHUDIcon, (WinHeight * C.ClipY) / perk.default.OnHUDIcon.USize, 
            (WinHeight * C.ClipY) / perk.default.OnHUDIcon.USize);
}

function CheckPerks(KFSteamStatsAndAchievements StatsAndAchievements) {
    local int i;
    local KFPlayerController KFPC;

    // Grab the Player Controller for later use
    KFPC = KFPlayerController(PlayerOwner());
                                                                                         
    // Hold onto our reference
    KFStatsAndAchievements = StatsAndAchievements;

    // Update the ItemCount and select the first item
    MaxPerks = kfrLRepInfo.pack.getPerks().Length;
    //SetIndex(0);

    for (i = 0; i < MaxPerks; i++) {
        if (kfrLRepInfo.pack.getPerks()[i] == KFPC.SelectedVeterancy) {
            CurPerk = i;
        }
    }
    
    bPerkChange = false;
}
