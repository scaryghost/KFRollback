class BuyMenuTab extends KFTab_BuyMenu;

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
