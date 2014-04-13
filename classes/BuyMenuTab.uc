class BuyMenuTab extends KFTab_BuyMenu_Story;

var KFRLinkedReplicationInfo kfrLRepInfo;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.InitComponent(MyController, MyOwner);
    } else {
        super(KFTab_BuyMenu).InitComponent(MyController, MyOwner);
    }
    kfrLRepInfo= class'KFRLinkedReplicationInfo'.static.findLRI(PlayerOwner().PlayerReplicationInfo);
}

function FillInfoTextFromVolume() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.FillInfoTextFromVolume();
    }
}

function DoSell() {
    local class<KFWeapon> ItemWeaponClass;

    if (KFPawn(PlayerOwner().Pawn) != none) {
        ItemWeaponClass = TheBuyable.ItemWeaponClass;

        InvSelect.List.Index = -1;
        TheBuyable = none;
        LastBuyable = none;

        kfrLRepInfo.sellWeapon(ItemWeaponClass);
        UpdateBuySellButtons();
    }
}

function DoBuy() {
    if (KFPawn(PlayerOwner().Pawn) != none) {
        if (class<Potato>(TheBuyable.ItemPickupClass) != none) {
            if (PlayerOwner().SteamStatsAndAchievements.DoPotato()) {
                KFPawn(PlayerOwner().Pawn).ServerBuyPotato();
            }
        } else {
            kfrLRepInfo.buyWeapon(TheBuyable.ItemWeaponClass, TheBuyable.ItemWeight);
        }

        MakeSomeBuyNoise();

        SaleSelect.List.SetIndex( -1 );
        SaleSelect.List.BuyableToDisplay = none;
        TheBuyable = none;
        LastBuyable = none;

        UpdateBuySellButtons();
    }
}

defaultproperties {
    Begin Object Class=KFBuyMenuSaleListBox Name=SaleListBox
        OnCreateComponent=SaleListBox.InternalOnCreateComponent
        WinTop=0.064312
        WinLeft=0.672632
        WinWidth=0.325857
        WinHeight=0.674039
        DefaultListClass="KFRollback.BuyMenuSaleList"
    End Object
    SaleSelect=SaleListBox
}
