class BuyMenu extends GUIBuyMenu_Story;

var automated QuickPerkSelect quickPerk;

function InitTabs() {
    local int i;

    super.InitTabs();

    for(i= 0; i < c_Tabs.TabStack.Length; i++) {
        if (c_Tabs.TabStack[i].MyPanel.IsA('PerksTab')) {
            PerksTab(c_Tabs.TabStack[i].MyPanel).perksBox= quickPerk.perkSelect;
            break;
        }
    }
}

function UpdateHeader() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        WaveLabel.Caption= "";
        WaveLabel.DisableMe();
        super.UpdateHeader();
    } else {
        ShopTitleLabel.Caption= "";
        ShopTitleLabel.DisableMe();
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
    QuickPerkSelect=None

    Begin Object Class=GUILabel Name=Wave
        Caption="Wave: 7/10"
        TextAlign=TXTA_Center
        TextColor=(B=158,G=176,R=175)
        WinTop=0.052857
        WinLeft=0.336529
        WinWidth=0.327071
        WinHeight=0.035000
    End Object
    WaveLabel=GUILabel'KFRollback.BuyMenu.Wave'

    Begin Object class=QuickPerkSelect name=QPS
         WinTop=0.011906
         WinLeft=0.008008
         WinWidth=0.316601
         WinHeight=0.082460
         OnDraw=QPS.MyOnDraw
    End Object
    quickPerk=QPS

    PanelClass(0)="KFRollback.BuyMenuTab"
    PanelClass(1)="KFRollback.PerksTab"
}    
