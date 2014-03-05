class BuyMenuSaleList extends KFBuyMenuSaleList_Story;

function UpdateForSaleBuyables() {
    if (PlayerOwner().GameReplicationInfo.IsA('KF_StoryGRI')) {
        super.UpdateForSaleBuyables();
    } else {
        super(KFBuyMenuSaleList).UpdateForSaleBuyables();
    }
}

function FilterBuyablesList() {
    CurrFilterIndex = KFPlayerController( PlayerOwner() ).BuyMenuFilterIndex;
}
