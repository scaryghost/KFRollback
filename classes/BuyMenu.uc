class BuyMenu extends GUIBuyMenu_Story;

var Texture perkIcon;
var automated GUIImage playerPerk, perkBack;
var bool ignoreChange, resized;
var automated GUIComboBox perkSelect;
var KFRLinkedReplicationInfo kfrLRepInfo;

function bool MyOnDraw(Canvas C) {
    if (!resized) {
        perkBack.WinWidth= (C.ClipY / C.ClipX) * perkBack.WinHeight;
        playerPerk.WinWidth= (C.ClipY / C.ClipX) * playerPerk.WinHeight;
        resized= true;
    }
    return super.OnDraw(C);
}

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
        if (KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill == perks[i]) {
            perkSelect.SetIndex(i);
            playerPerk.Image= perks[i].default.OnHUDIcon;
            perkIcon= perks[i].default.OnHUDIcon;
        }
    }
    ignoreChange= false;
}

function FillInfoFromVolume() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.FillInfoFromVolume();
    }
}

function InternalOnChange(GUIComponent sender) {
    if (!ignoreChange && sender == perkSelect) {
        kfrLRepInfo.changePerk(perkSelect.GetIndex());
        playerPerk.Image= KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.default.OnHUDIcon;
        perkIcon= KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.default.OnHUDIcon;
        perkSelect.DisableMe();
    }
}

defaultproperties {
    ignoreChange=true
    OnDraw=MyOnDraw

    Begin Object class=GUIImage Name=perkBG
        Image=Texture'KF_InterfaceArt_tex.Menu.Perk_box'
        ImageStyle=ISTY_Scaled
        WinTop=0.011906
        WinLeft=0.008008
        WinHeight=0.075
    End Object
    perkBack=perkBG

    Begin Object class=GUIImage Name=currPerk
        ImageStyle=ISTY_Scaled
        WinTop=0.011906
        WinLeft=0.008008
        WinHeight=0.075
    End Object
    playerPerk=currPerk

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
        WinTop=0.029400
        WinLeft=0.09000
        WinWidth=0.216601
        WinHeight=0.030000
        MyListBox=ListBox1
        OnChange=BuyMenu.InternalOnChange
    End Object
    perkSelect=QS

    QuickPerkSelect=None

    PanelClass(0)="KFRollback.BuyMenuTab"
    PanelClass(1)="KFRollback.PerksTab"
}    
