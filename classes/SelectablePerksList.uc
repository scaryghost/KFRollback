class SelectablePerksList extends GUIList;

function DrawItem(Canvas Canvas, int CurIndex, float X, float Y, 
        float Width, float Height, bool bSelected, bool bPending) {
    local float StringWidth, StringHeight;

    if (bSelected) {
        Canvas.SetDrawColor(192, 192, 192, 128);
        Canvas.SetPos(X, Y);
        Canvas.DrawTileStretched(Texture'InterfaceArt_tex.Menu.progress_bar', Width, Height);
    }
    Canvas.SetPos(X + 4, Y);
    Canvas.DrawTile(Texture(Elements[CurIndex].ExtraData), Height, Height, 0, 0, 256, 256);

    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.StrLen(Elements[CurIndex].Item, StringWidth, StringHeight);
    Canvas.SetPos(X + Height + 10.0, Y + ((Height - StringHeight) / 2.0));
    Canvas.DrawText(Elements[CurIndex].Item);
}

defaultproperties {
    OnDrawItem= DrawItem;
}
