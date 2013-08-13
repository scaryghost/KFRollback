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

    Begin Object Class=KFRLobbyFooter Name=Footer
        RenderWeight=0.300000
        TabOrder=8
        bBoundToParent=False
        bScaleToParent=False
        OnPreDraw=BuyFooter.InternalOnPreDraw
    End Object
    t_Footer=LobbyFooter'KFRollback.KFRLobbyMenu.Footer'
}
