class KFRMutator extends Mutator
    config(KFRollBack);

var() config int perkLevel;

function PostBeginPlay() {
    if (KFGameType(Level.Game) == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    Level.Game.PlayerControllerClass= class'KFRollback.KFRPlayerController';
    Level.Game.PlayerControllerClassName= "KFRollback.KFRPlayerController";
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    if (KFPlayerReplicationInfo(Other) != none) {
        KFPlayerReplicationInfo(Other).ClientVeteranSkillLevel= perkLevel;
    }
    return super.CheckReplacement(Other, bSuperRelevant);
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
}
