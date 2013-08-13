class KFRLobbyMenu extends LobbyMenu;

var string profilePage;

function bool ShowPerkMenu(GUIComponent Sender) {
    if (PlayerOwner() != none) {
        PlayerOwner().ClientOpenMenu(profilePage, false);
    }
    return true;
}

defaultproperties {
    profilePage="KFRollback.KFRProfilePage"
}
