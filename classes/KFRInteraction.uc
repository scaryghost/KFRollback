class KFRInteraction extends Interaction;

var array<class<Pickup> > itemsToRemove;
var string buyMenuClass, lobbyMenuClass;

function removeItems() {
    local LevelRules it;
    local int i;

    log("How many items do I gotta remove?"@itemsToRemove.Length);
    foreach ViewportOwner.Actor.DynamicActors(class'KFRollback.LevelRules', it) {
        for(i= 0; i < itemsToRemove.Length; i++) {
            it.remove(itemsToRemove[i]);
        }
    }
}

event NotifyLevelChange() {
    Master.RemoveInteraction(self);
}

function Tick (float DeltaTime) {
    local KFRLinkedReplicationInfo kfrLRepInfo;
    local KFGUIController guiController;
    local int i;

    guiController= KFGUIController(ViewportOwner.GUIController);
    if (guiController != none && guiController.ActivePage != none && guiController.ActivePage.class == class'KFGui.LobbyMenu') {
        kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(ViewportOwner.Actor.PlayerReplicationInfo);
        KFPlayerController(ViewportOwner.Actor).LobbyMenuClassString= lobbyMenuClass;
        ViewportOwner.Actor.ClientCloseMenu(true, true);
        KFPlayerController(ViewportOwner.Actor).ShowLobbyMenu();
        i= Rand(kfrLRepInfo.pack.getPerks().Length);
        KFPlayerController(ViewportOwner.Actor).SelectedVeterancy= kfrLRepInfo.pack.getPerks()[i];
        kfrLRepInfo.changePerk(KFPlayerController(ViewportOwner.Actor).SelectedVeterancy, kfrLRepInfo.pack.getMaxPerkLevel());
        bRequiresTick= false;
    }
}


function bool KeyEvent(EInputKey Key, EInputAction Action, float Delta ) {
    local string alias;
    local ShopVolume shop;
    local bool touchingShopVolume;

    alias= ViewportOwner.Actor.ConsoleCommand("KEYBINDING"@ViewportOwner.Actor.ConsoleCommand("KEYNAME"@Key));
    if (Action == IST_Press && alias ~= "use" && !KFGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo).bWaveInProgress) {
        foreach ViewportOwner.Actor.Pawn.TouchingActors(class'ShopVolume', shop) {
            touchingShopVolume= true;
            break;
        }
        if (touchingShopVolume && Len(buyMenuClass) > 0) {
            ViewportOwner.Actor.ClientOpenMenu(buyMenuClass,,"MyTrader", string(KFHumanPawn(ViewportOwner.Actor.Pawn).MaxCarryWeight));
            return true;
        }
    }
    return false;
}

defaultproperties {
    bActive= true
    bRequiresTick= true

    buyMenuClass="KFRollback.BuyMenu"
    lobbyMenuClass="KFRollback.LobbyMenu"
}

