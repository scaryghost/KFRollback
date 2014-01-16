class BuyMenu extends GUIBuyMenu_Story;

function UpdateHeader() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.UpdateHeader();
    } else {
        super(GUIBuyMenu).UpdateHeader();
    }
}

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.InitComponent(MyController, MyOwner);
    } else {
        super(GUIBuyMenu).InitComponent(MyController, MyOwner);
    }
}

function FillInfoFromVolume() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.FillInfoFromVolume();
    }
}

defaultproperties {
    Begin Object class=QuickPerkSelect Name=QS
        WinTop=0.011906
        WinLeft=0.008008
        WinWidth=0.316601
        WinHeight=0.082460
    End Object
    QuickPerkSelect=QS

    PanelClass(0)="KFRollback.BuyMenuTab"
    PanelClass(1)="KFRollback.PerksTab"
}    
