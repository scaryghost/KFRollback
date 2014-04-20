class SelectablePerksList extends GUIList;

event InitComponent(GUIController MyController, GUIComponent MyOwner) {
    Super.InitComponent(MyController, MyOwner);
    OnDrawItem = DrawItem;
}

function DrawItem(Canvas Canvas, int CurIndex, float X, float Y, 
        float Width, float Height, bool bSelected, bool bPending) {
    local float StringWidth, StringHeight;

    Canvas.SetPos(X + 4, Y + 4);
    Canvas.DrawTile(Texture(Elements[CurIndex].ExtraData), Height - 8, Height - 8, 0, 0, 256, 256);

    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.StrLen(Elements[CurIndex].Item, StringWidth, StringHeight);
    Canvas.SetPos(X + Height + 10.0, Y + ((Height - StringHeight) / 2.0));
    Canvas.DrawText(Elements[CurIndex].Item);
}
