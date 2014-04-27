class ProfilePage extends KFProfilePage;

function SaveButtonClicked() {
    ProfileTab(ProfilePanel).saveButtonPressed= true;
    super.SaveButtonClicked();
}

defaultproperties {
    Begin Object Class=ProfileTab Name=Panel
        WinTop=0.010000
        WinLeft=0.010000
        WinWidth=0.980000
        WinHeight=0.960000
    End Object
    ProfilePanel=Panel
}
    
