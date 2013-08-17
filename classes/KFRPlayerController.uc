class KFRPlayerController extends KFPlayerController;

function ShowBuyMenu(string wlTag,float maxweight) {
	StopForceFeedback();  // jdf - no way to pause feedback

	// Open menu
	ClientOpenMenu("KFRollback.BuyMenu",,wlTag,string(maxweight));
}

defaultproperties {
    LobbyMenuClassString="KFRollback.KFRLobbyMenu"
    MidGameMenuClass="KFRollback.KFRInvasionLoginMenu"
}
