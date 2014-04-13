class KFRMutator extends Mutator
    config(KFRollBack);

var() config string rollbackPackName;

var KFGameType gameType;
var string interactionClass, loginMenuClass;
var RollbackPack pack;

replication {
    reliable if (Role == ROLE_Authority)
        rollbackPackName;
}

simulated function Tick(float DeltaTime) {
    local PlayerController localController;
    local RollbackPack localPack;

    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction(interactionClass, localController.Player);
        localPack= new class<RollbackPack>(DynamicLoadObject(rollbackPackName, class'Class'));
        class'KFRLinkedReplicationInfo'.static.findLRI(localController.PlayerReplicationInfo).pack= localPack;
    }
    Disable('Tick');
}


function PostBeginPlay() {
    local class<RollbackPack> packClass;
    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    DeathMatch(Level.Game).LoginMenuClass= loginMenuClass;
    packClass= class<RollbackPack>(DynamicLoadObject(rollbackPackName, class'Class'));
    pack= new packClass;

    SetTimer(1.0, false);
}

function Timer() {
    gameType.KFLRules.ItemForSale= pack.getWeaponPickups();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local KFPlayerReplicationInfo kfpRepInfo;
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local string replacement;

    kfpRepInfo= KFPlayerReplicationInfo(Other);
    if (kfpRepInfo != none) {
        kfrLRepInfo= kfpRepInfo.Spawn(class'KFRLinkedReplicationInfo', kfpRepInfo.Owner);
        kfrLRepInfo.mut= self;
        kfrLRepInfo.NextReplicationInfo= kfpRepInfo.CustomReplicationInfo;
        kfpRepInfo.CustomReplicationInfo= kfrLRepInfo;
        kfpRepInfo.ClientVeteranSkillLevel= pack.getMaxPerkLevel();
    } else if (Weapon(Other) != none || KFWeaponPickup(Other) != none || KFAmmoPickup(Other) != none) {
        replacement= pack.replaceActor(Other);
        if (Len(replacement) != 0) {
            ReplaceWith(Other, replacement);
            return false;
        }
    }

    return super.CheckReplacement(Other, bSuperRelevant);
}

function weaponDestroyed(class<Weapon> WClass) {
    gameType.WeaponDestroyed(WClass);
}

function weaponSpawned(Inventory I) {
    gameType.WeaponSpawned(I);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    super.FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting("KFRollback", "rollbackPackName","Rollback Pack Name", 0, 1, "Text");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "rollbackPackName":
            return "Classname of the rollback pack to use";
        default:
            return Super.GetDescriptionText(property);
    }
}


defaultproperties {
    GroupName="KFRollback"
    FriendlyName="KF Rollback v2.0.1"
    Description="Rolls back the game to 2009, mixing in bits of the Level Up, Heavy Metal, and 2010 Xmas updates"

    RemoteRole= ROLE_SimulatedProxy
    bAlwaysRelevant= true

    interactionClass="KFRollback.KFRInteraction"
    loginMenuClass="KFRollback.InvasionLoginMenu"
}
