class ModelSelect extends KFModelSelect;

var array<string> allowedCharacters;

function RefreshCharacterList(string ExcludedChars, optional string Race) {
    local int i, j, len;
    local array<string> Excluded;

    // Prevent list from calling OnChange events
    CharList.List.bNotify = False;
    CharList.Clear();

    Split(ExcludedChars, ";", Excluded);
    len= PlayerList.Length;
    while(i < len) {
        // Check that this character is selectable
        if (PlayerList[i].DefaultName != "") {
            for (j = 0; j < allowedCharacters.Length; j++) {
                if (allowedCharacters[j] ~= PlayerList[i].DefaultName) {
                    if (IsUnLocked(PlayerList[i])) {
                        CharList.List.Add(Playerlist[i].Portrait, i, 0);
                    }
                    else if (Playerlist[i].LockedPortrait == none) {
                        CharList.List.Add(Playerlist[i].Portrait, i, 1);
                    }
                    else {
                        CharList.List.Add(Playerlist[i].LockedPortrait, i, 1);
                    }
                    break;
                }
            }
            if (j < allowedCharacters.Length) {
                i++;
            } else {
                PlayerList.Remove(i, 1);
                len--;
            }
        } else {
            i++;
        }
    }

    CharList.List.LockedMat= LockedImage;
    CharList.List.bNotify= True;
}

defaultproperties {
    allowedCharacters(0)="Agent_Wilkes"
    allowedCharacters(1)="Ash_Harding"
    allowedCharacters(2)="Captain_Wiggins"
    allowedCharacters(3)="Chopper_Harris"
    allowedCharacters(4)="Corporal_Lewis"
    allowedCharacters(5)="Dave_The_Butcher_Roberts"
    allowedCharacters(6)="DJ_Scully"
    allowedCharacters(7)="Dr_Gary_Glover"
    allowedCharacters(8)="Dr_Jeffrey_Tamm"
    allowedCharacters(9)="FoundryWorker_Aldridge"
    allowedCharacters(10)="Harold_Hunt"
    allowedCharacters(11)="Kerry_Fitzpatrick"
    allowedCharacters(12)="Kevo_Chav"
    allowedCharacters(13)="LanceCorporal_Lee_Baron"
    allowedCharacters(14)="Lieutenant_Masterson"
    allowedCharacters(15)="Mike_Noble"
    allowedCharacters(16)="Mr_Foster"
    allowedCharacters(17)="Mrs_Foster"
    allowedCharacters(18)="Paramedic_Alfred_Anderson"
    allowedCharacters(19)="Police_Constable_Briar"
    allowedCharacters(20)="Police_Sergeant_Davin"
    allowedCharacters(21)="Private_Schnieder"
    allowedCharacters(22)="Reverend_Alberts"
    allowedCharacters(23)="Samuel_Avalon"
    allowedCharacters(24)="Security_Officer_Thorne"
    allowedCharacters(25)="Sergeant_Powers"
    allowedCharacters(26)="Shadow_Ferret"
    allowedCharacters(27)="Trooper_Clive_Jenkins"
}
