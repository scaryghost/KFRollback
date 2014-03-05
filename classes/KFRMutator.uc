class KFRMutator extends Mutator
    config(KFRollBack);

struct ReplacementPair {
    var class<Object> oldClass;
    var class<Object> newClass;
};


var() config int perkLevel;
var() config bool enableKatana, enableAK;

var localized string perkChangeTraderMsg;
var class<LevelRules> levelRules;
var KFGameType gameType;
var string interactionClass, loginMenuClass;
var int minPerkLevel, maxPerkLevel;
var array<ReplacementPair> pickupReplacements, firemodeReplacements;

replication {
    reliable if (Role == ROLE_AUTHORITY)
        enableKatana, enableAK;
}

simulated function Tick(float DeltaTime) {
    local KFRInteraction interaction;
    local PlayerController localController;
    local int i;

    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction(interactionClass, localController.Player);
        for(i= 0; i < localController.Player.LocalInteractions.Length; i++) {
            interaction= KFRInteraction(localController.Player.LocalInteractions[i]);
            if (interaction != none) {
                log("Enabled katana? "@enableKatana@", Enabled AK? "@enableAK);
                if (!enableKatana) {
                    interaction.itemsToRemove[interaction.itemsToRemove.Length]= class'KFRollback.KatanaPickup';
                }
                if (!enableAK) {
                    interaction.itemsToRemove[interaction.itemsToRemove.Length]= class'KFMod.AK47Pickup';
                }
                interaction.removeItems();
            }
        }
    }
    Disable('Tick');
}


function PostBeginPlay() {
    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    AddToPackageMap();
    DeathMatch(Level.Game).LoginMenuClass= loginMenuClass;

    if (perkLevel < minPerkLevel) {
        perkLevel= minPerkLevel;
    } else if (perkLevel > maxPerkLevel) {
        perkLevel= maxPerkLevel;
    }

    SetTimer(1.0, false);
}

function Timer() {
    gameType.KFLRules.destroy();
    gameType.KFLRules= spawn(levelRules);

    if (!enableKatana) {
        LevelRules(gameType.KFLRules).remove(class'KFRollback.KatanaPickup');
    }
    if (!enableAK) {
        LevelRules(gameType.KFLRules).remove(class'KFMod.AK47Pickup');
    }
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local int i, j;

    if (KFPlayerReplicationInfo(Other) != none) {
        KFPlayerReplicationInfo(Other).ClientVeteranSkillLevel= perkLevel;
    } else if (Weapon(Other) != none) {
        if ((!enableKatana && Katana(Other) != none) || (!enableAK && AK47AssaultRifle(Other) != none)) {
            return false;
        }
        for(i= 0; i < ArrayCount(Weapon(Other).FireModeClass); i++) {
            j= shouldReplace(Weapon(Other).FireModeClass[i], firemodeReplacements);
            if (j != -1) {
                Weapon(Other).FireModeClass[i]= class<WeaponFire>(firemodeReplacements[j].newClass);
            }
        }
    } else if (KFWeaponPickup(Other) != none || KFAmmoPickup(Other) != none) {
        if ((!enableKatana && KatanaPickup(Other) != none) || (!enableAK && AK47Pickup(Other) != none)) {
            return false;
        }
        i= shouldReplace(Other.class, pickupReplacements);
        if (i != -1) {
            ReplaceWith(Other,String(pickupReplacements[i].newClass));
            return false;
        }
    }

    return super.CheckReplacement(Other, bSuperRelevant);
}

function int shouldReplace(class<Object> classRef, array<ReplacementPair> replacementArray) {
    local int i, replaceIndex;

    replaceIndex= -1;
    for(i=0; replaceIndex == -1 && i < replacementArray.length; i++) {
        if (classRef == replacementArray[i].oldClass) {
            replaceIndex= i;
        }
    }
    
    return replaceIndex;
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
    FriendlyName="KF Rollback v2.0.1"
    Description="Rolls back the game to 2009, mixing in bits of the Level Up, Heavy Metal, and 2010 Xmas updates"

    RemoteRole= ROLE_SimulatedProxy
    bAlwaysRelevant= true

    levelRules=class'LevelRules';
    perkChangeTraderMsg="You can only change perks during trader time"
    interactionClass="KFRollback.KFRInteraction"
    loginMenuClass="KFRollback.InvasionLoginMenu"
    minPerkLevel=0
    maxPerkLevel=5

    firemodeReplacements(0)=(oldClass=class'KFMod.KnifeFire',newClass=class'KFRollback.KnifeFire')
    firemodeReplacements(1)=(oldClass=class'KFMod.KnifeFireB',newClass=class'KFRollback.KnifeAltFire')
    firemodeReplacements(2)=(oldClass=class'KFMod.CrossbowFire',newClass=class'KFRollback.CrossbowFire')
    firemodeReplacements(3)=(oldClass=class'KFMod.BullpupFire',newClass=class'KFRollback.BullpupFire')

    pickupReplacements(0)=(oldClass=class'KFMod.AxePickup',newClass=class'KFRollback.AxePickup')
    pickupReplacements(1)=(oldClass=class'KFMod.ChainsawPickup',newClass=class'KFRollback.ChainsawPickup')
    pickupReplacements(2)=(oldClass=class'KFMod.KatanaPickup',newClass=class'KFRollback.KatanaPickup')
    pickupReplacements(3)=(oldClass=class'KFMod.LAWPickup',newClass=class'KFRollback.LAWPickup')
    pickupReplacements(4)=(oldClass=class'KFMod.LAWAmmoPickup',newClass=class'KFRollback.LAWAmmoPickup')
    pickupReplacements(5)=(oldClass=class'KFMod.MachetePickup',newClass=class'KFRollback.MachetePickup')
}
