class KFRMutator extends Mutator
    config(KFRollBack);

var() config int perkLevel;
var() config bool enableKatana, enableAK;

var localized string perkChangeTraderMsg;
var class<KFLevelRules> levelRules;

simulated function Tick(float DeltaTime) {
    local PlayerController localController;

    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction("KFRollback.KFRInteraction", localController.Player);
    }
    Disable('Tick');
}


function PostBeginPlay() {
    if (KFGameType(Level.Game) == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    DeathMatch(Level.Game).LoginMenuClass= "KFRollback.KFRInvasionLoginMenu";

    //Should find a better way to do this than create 4 level rules classes, but lazy
    if (enableKatana && enableAK) {
        levelRules= class'KFRLevelRules';
    } else if (enableKatana && !enableAK) {
        levelRules= class'KFRLevelRules_NoAK';
    } else if (!enableKatana && enableAK) {
        levelRules= class'KFRLevelRules_NoKatana';
    } else if (!enableKatana && !enableAK) {
        levelRules= class'KFRLevelRules_NoAK_NoKatana';
    }

    if (perkLevel < 0) {
        perkLevel= 0;
    } else if (perkLevel > 5) {
        perkLevel= 5;
    }

    SetTimer(1.0, true);
}

function Timer() {
    KFGameType(Level.Game).KFLRules.destroy();
    KFGameType(Level.Game).KFLRules= spawn(levelRules);
    SetTimer(0.0, false);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    if (KFPlayerReplicationInfo(Other) != none) {
        KFPlayerReplicationInfo(Other).ClientVeteranSkillLevel= perkLevel;
    } else if (Other.class != class'KFMod.Knife') {
        Knife(Other).FireModeClass[0]=class'KFRollback.KnifeFire';
        Knife(Other).FireModeClass[1]=class'KFRollback.KnifeAltFire';
    }
    return super.CheckReplacement(Other, bSuperRelevant);
}

function Mutate(string Command, PlayerController Sender) {
    local KFPlayerController kfPC;
    local KFPlayerReplicationInfo kfRepInfo;
    local array<string> parts;
    local int index;
    Split(Command, " ", parts);

    kfPC= KFPlayerController(Sender);
    kfRepInfo= KFPlayerReplicationInfo(kfPC.PlayerReplicationInfo);
    if (kfPC != none && kfRepInfo != none && parts.Length >= 2 && parts[0] ~= "perkchange") {
        index= int(parts[1]);
        if (index < 0 || index > class'PerkList'.default.perks.Length) {
            Sender.ClientMessage("Usage: mutate perkchange [0-" $ class'PerkList'.default.perks.Length $ "]");
        } else {
            kfPC.SelectedVeterancy= class'PerkList'.default.perks[index];

            if (KFGameReplicationInfo(Level.GRI).bWaveInProgress && kfPC.SelectedVeterancy != kfRepInfo.ClientVeteranSkill) {
                Sender.ClientMessage(perkChangeTraderMsg);
            } else if (!kfPC.bChangedVeterancyThisWave) {
                if (kfPC.SelectedVeterancy != kfRepInfo.ClientVeteranSkill) {
                    Sender.ClientMessage(Repl(kfPC.YouAreNowPerkString, "%Perk%", kfPC.SelectedVeterancy.Default.VeterancyName));
                }
                if (Level.GRI.bMatchHasBegun) {
                    kfPC.bChangedVeterancyThisWave = true;
                }

                kfRepInfo.ClientVeteranSkill = kfPC.SelectedVeterancy;
                kfRepInfo.ClientVeteranSkillLevel= perkLevel;

                if( KFHumanPawn(kfPC.Pawn) != none ) {
                    KFHumanPawn(kfPC.Pawn).VeterancyChanged();
                }    
            } else {
                Sender.ClientMessage(kfPC.PerkChangeOncePerWaveString);
            }
        }
    }    
    super.Mutate(Command, Sender);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    super.FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting("KFRollback", "perkLevel","Perk Level", 0, 1, "Text", "0.1;0:5");
    PlayInfo.AddSetting("KFRollback", "enableKatana","Enable Katana", 0, 1, "Check");
    PlayInfo.AddSetting("KFRollback", "enableAK","Enable AK47", 0, 1, "Check");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "perkLevel":
            return "Sets the perk level for the players";
        case "enableKatana":
            return "Add the katana to the trader menu";
        case "enableAK":
            return "Add the AK47 to the trader menu";
        default:
            return Super.GetDescriptionText(property);
    }
}


defaultproperties {
    GroupName="KFRollback"
    FriendlyName="KF Rollback"
    Description="Rolls back the game to 2009, mixing in bits of the Level Up, Heavy Metal, and 2010 Xmas updates"

    perkChangeTraderMsg="You can only change perks during trader time"

    RemoteRole= ROLE_SimulatedProxy
    bAlwaysRelevant= true
}
