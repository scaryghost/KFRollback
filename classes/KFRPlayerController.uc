class KFRPlayerController extends KFPlayerController;

function SelectVeterancy(class<KFVeterancyTypes> VetSkill, optional bool bForceChange)
{
    if ( VetSkill == none || KFPlayerReplicationInfo(PlayerReplicationInfo) == none )
    {
        return;
    }

    if ( KFSteamStatsAndAchievements(SteamStatsAndAchievements) != none )
    {
        SelectedVeterancy = VetSkill;

        if ( KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress && VetSkill != KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill )
        {
            bChangedVeterancyThisWave = false;
            ClientMessage(Repl(YouWillBecomePerkString, "%Perk%", VetSkill.Default.VeterancyName));
        }
        else if ( !bChangedVeterancyThisWave || bForceChange )
        {
            if ( VetSkill != KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill )
            {
                ClientMessage(Repl(YouAreNowPerkString, "%Perk%", VetSkill.Default.VeterancyName));
            }

            if ( GameReplicationInfo.bMatchHasBegun )
            {
                bChangedVeterancyThisWave = true;
            }

            KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill = VetSkill;

            if( KFHumanPawn(Pawn) != none )
            {
                KFHumanPawn(Pawn).VeterancyChanged();
            }
        }
        else
        {
            ClientMessage(PerkChangeOncePerWaveString);
        }
    }
}

defaultproperties {
    LobbyMenuClassString="KFRollback.KFRLobbyMenu"
}
