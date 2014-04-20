class BuyMenu extends GUIBuyMenu_Story;

var automated GUIComboBox perkSelect;
var KFRLinkedReplicationInfo kfrLRepInfo;

function UpdateHeader() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.UpdateHeader();
    } else {
        super(GUIBuyMenu).UpdateHeader();
    }
}

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    local int i;
    local array<class<KFVeterancyTypes> > perks;

    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.InitComponent(MyController, MyOwner);
    } else {
        super(GUIBuyMenu).InitComponent(MyController, MyOwner);
    }
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perks= kfrLRepInfo.pack.getPerks();
    for(i= 0; i < perks.Length; i++) {
        perkSelect.AddItem(perks[i].default.VeterancyName, perks[i].default.OnHUDIcon);
    }
}

function FillInfoFromVolume() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.FillInfoFromVolume();
    }
}

defaultproperties {
    Begin Object Class=GUIListBox Name=ListBox1
        OnCreateComponent=ListBox1.InternalOnCreateComponent
        StyleName="ComboListBox"
        RenderWeight=0.700000
        bTabStop=False
        bVisible=False
        bNeverScale=True
        DefaultListClass="KFRollback.SelectablePerksList"
    End Object

    Begin Object class=GUIComboBox Name=QS
        WinTop=0.011906
        WinLeft=0.008008
        WinWidth=0.316601
        WinHeight=0.082460
        MyListBox=ListBox1
    End Object
    perkSelect=QS
    QuickPerkSelect=None

    PanelClass(0)="KFRollback.BuyMenuTab"
    PanelClass(1)="KFRollback.PerksTab"
}    
