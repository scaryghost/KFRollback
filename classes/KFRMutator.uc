class KFRMutator extends Mutator
    config(KFRollBack);

var() config string rollbackPackName;
var() config array<string> rollbackPacks;

var KFGameType gameType;
var string interactionClass, loginMenuClass;
var RollbackPack pack;

simulated function Tick(float DeltaTime) {
    local PlayerController localController;
    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction(interactionClass, localController.Player);
    }
    Disable('Tick');
}


function PostBeginPlay() {
    local int i;
    local array<string> packages;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    pack= new class<RollbackPack>(DynamicLoadObject(rollbackPackName, class'Class'));
    packages= pack.getPackages();
    AddToPackageMap();
    for(i= 0; i < packages.Length; i++) {
        AddToPackageMap(packages[i]);
    }
    
    DeathMatch(Level.Game).LoginMenuClass= loginMenuClass;
    gameType.MonsterCollection= pack.getMonstersCollection();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local KFPlayerReplicationInfo kfpRepInfo;
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local string replacement;

    kfpRepInfo= KFPlayerReplicationInfo(Other);
    if (kfpRepInfo != none && kfpRepInfo.Owner != None) {
        kfrLRepInfo= kfpRepInfo.Spawn(class'KFRLinkedReplicationInfo', kfpRepInfo.Owner);
        kfrLRepInfo.mut= self;
        kfrLRepInfo.NextReplicationInfo= kfpRepInfo.CustomReplicationInfo;
        kfrLRepInfo.packName= rollbackPackName;
        kfrLRepInfo.pack= pack;
        kfrLRepInfo.desiredPerkLevel= pack.getMaxPerkLevel();
        kfpRepInfo.CustomReplicationInfo= kfrLRepInfo;
        kfpRepInfo.ClientVeteranSkillLevel= kfrLRepInfo.desiredPerkLevel;
    } else if (Weapon(Other) != none || KFWeaponPickup(Other) != none || KFAmmoPickup(Other) != none) {
        replacement= pack.replaceActor(Other);
        if (Len(replacement) != 0) {
            ReplaceWith(Other, replacement);
            return false;
        }
    } else if (KFLevelRules(Other) != none) {
        KFLevelRules(Other).ItemForSale= pack.getWeaponPickups();
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
    PlayInfo.AddSetting(default.GroupName, "rollbackPackName", "Rollback Pack", 0, 1, "Select", 
            class'GUI'.static.JoinArray(default.rollbackPacks, ";"), "Xb",,true);
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "rollbackPackName":
            return "Select the rollback pack to use";
        default:
            return Super.GetDescriptionText(property);
    }
}

defaultproperties {
    GroupName="KFRollback"
    FriendlyName="KF Rollback v3.0"
    Description="Reverts the weapons, perks, and specimens to a previous state"

    RemoteRole= ROLE_SimulatedProxy
    bAlwaysRelevant= true

    interactionClass="KFRollback.KFRInteraction"
    loginMenuClass="KFRollback.InvasionLoginMenu"
}
