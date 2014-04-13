class KFRMutator extends Mutator
    config(KFRollBack);

var() config string rollbackPackName;

var localized string perkChangeTraderMsg;
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
    if (KFPlayerReplicationInfo(Other) != none) {
        KFPlayerReplicationInfo(Other).ClientVeteranSkillLevel= pack.getMaxPerkLevel();
    } else if (Weapon(Other) != none) {
        return pack.replaceWeapon(Weapon(Other));
    } else if (KFWeaponPickup(Other) != none) {
        return pack.replaceWeaponPickup(KFWeaponPickup(Other));
    } else if (KFAmmoPickup(Other) != none) {
        return pack.replaceAmmoPickup(KFAmmoPickup(Other));
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
                kfRepInfo.ClientVeteranSkillLevel= pack.getMaxPerkLevel();

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

    perkChangeTraderMsg="You can only change perks during trader time"
    interactionClass="KFRollback.KFRInteraction"
    loginMenuClass="KFRollback.InvasionLoginMenu"
}
