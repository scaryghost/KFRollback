class KFRInteraction extends Interaction;

var string buyMenuClass, lobbyMenuClass;

event NotifyLevelChange() {
    Master.RemoveInteraction(self);
}

function Tick (float DeltaTime) {
    if (LobbyMenu(KFGUIController(ViewportOwner.GUIController).ActivePage) != none) {
        KFPlayerController(ViewportOwner.Actor).LobbyMenuClassString= lobbyMenuClass;
        ViewportOwner.Actor.ClientCloseMenu(true, true);
        KFPlayerController(ViewportOwner.Actor).ShowLobbyMenu();
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
    lobbyMenuClass="KFRollback.KFRLobbyMenu"
}

