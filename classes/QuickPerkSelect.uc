class QuickPerkSelect extends GUIMultiComponent;

var Texture perkBack;
var KFRLinkedReplicationInfo kfrLRepInfo;
var automated GUIComboBox perkSelect;

event Opened(GUIComponent Sender) {
    local int i;
    local array<class<KFVeterancyTypes> > perks;
    local class<KFVeterancyTypes> playerPerk;

    super.Opened(Sender);

    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
    perks= kfrLRepInfo.pack.getPerks();
    playerPerk= KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;

    if (!KFPlayerController(PlayerOwner()).bChangedVeterancyThisWave) {
        perkSelect.EnableMe();
        for(i= 0; i < perks.Length; i++) {
            perkSelect.AddItem(perks[i].default.VeterancyName, perks[i].default.OnHUDIcon);
            if (playerPerk == perks[i]) {
                perkSelect.SetIndex(i);
            }
        }
        perkSelect.OnChange=InternalOnChange;
    } else {
        perkSelect.Edit.SetText(playerPerk.default.VeterancyName);
    }
}

event Closed(GUIComponent Sender, bool bCancelled) {
    super.Closed(Sender, bCancelled);

    perkSelect.OnChange=None;
    perkSelect.Clear();
    kfrLRepInfo= None;
}

function InternalOnChange(GUIComponent sender) {
    if (sender == perkSelect) {
        kfrLRepInfo.changePerk(perkSelect.GetIndex());
        perkSelect.DisableMe();
    }
}

function bool MyOnDraw(Canvas C) {
    local class<KFVeterancyTypes> perk;

    super.OnDraw(C);
    perk= KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;
    C.SetDrawColor(255, 255, 255, 255);
    C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);
    C.DrawTileScaled(perkBack, (WinHeight * C.ClipY) / perkBack.USize, (WinHeight * C.ClipY) / perkBack.USize);
    C.DrawTileScaled(perk.default.OnHUDIcon, (WinHeight * C.ClipY) / perk.default.OnHUDIcon.USize, 
            (WinHeight * C.ClipY) / perk.default.OnHUDIcon.USize);
        
    return false;
}

defaultproperties {
    perkBack=Texture'KF_InterfaceArt_tex.Menu.Perk_box'

    Begin Object Class=GUIListBox Name=ListBox1
        StyleName="ComboListBox"
        RenderWeight=0.700000
        bTabStop=False
        bVisible=False
        bNeverScale=True
        DefaultListClass="KFRollback.SelectablePerksList"
    End Object

    Begin Object class=GUIComboBox Name=QS
        WinTop=0.031400
        WinLeft=0.09000
        WinWidth=0.215000
        WinHeight=0.030000
        MyListBox=ListBox1
    End Object
    perkSelect=QS
}
