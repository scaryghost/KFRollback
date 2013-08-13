class KFRMutator extends Mutator;

function PostBeginPlay() {
    if (KFGameType(Level.Game) == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    Level.Game.PlayerControllerClass= class'KFRollback.KFRPlayerController';
    Level.Game.PlayerControllerClassName= "KFRollback.KFRPlayerController";
}

defaultproperties {
    GroupName="KFRollback"
    FriendlyName="KF Rollback"
    Description="Rolls back the game to 2009, mixing parts of the Level Up and Heavy Metal updates"
}
