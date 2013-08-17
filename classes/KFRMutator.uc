class KFRMutator extends Mutator
    config(KFRollBack);

var() config int perkLevel;
var localized string perkChangeTraderMsg;

function PostBeginPlay() {
    if (KFGameType(Level.Game) == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    Level.Game.PlayerControllerClass= class'KFRollback.KFRPlayerController';
    Level.Game.PlayerControllerClassName= "KFRollback.KFRPlayerController";

    DeathMatch(Level.Game).LoginMenuClass= "KFRollback.KFRInvasionLoginMenu";
    SetTimer(1.0, true);
}

function Timer() {
    KFGameType(Level.Game).KFLRules.destroy();
    KFGameType(Level.Game).KFLRules= spawn(class'KFRLevelRules');
    SetTimer(0.0, false);
    log("I have replaced your level rules!");
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    if (KFPlayerReplicationInfo(Other) != none) {
        KFPlayerReplicationInfo(Other).ClientVeteranSkillLevel= perkLevel;
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
    if (kfPC != none && kfPC.SelectedVeterancy != none && kfRepInfo != none && 
            parts.Length >= 2 && parts[0] ~= "perkchange") {
        index= int(parts[1]);
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
        Sender.SaveConfig();
    }
    super.Mutate(Command, Sender);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    super.FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting("KFRollback", "perkLevel","Perk Level", 0, 1, "Text", "0.1;0:5");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "perkLevel":
            return "Sets the perk level for the players";
        default:
            return Super.GetDescriptionText(property);
    }
}


defaultproperties {
    GroupName="KFRollback"
    FriendlyName="KF Rollback"
    Description="Rolls back the game to 2009, mixing parts of the Level Up and Heavy Metal updates"

    perkChangeTraderMsg="You can only change perks during trader time"
}
