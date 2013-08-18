class DualDeagle extends KFMod.DualDeagle;

function bool HandlePickupQuery(pickup Item) {
    if (Item.InventoryType == Class'KFRollback.Deagle') {
        if( LastHasGunMsgTime < Level.TimeSeconds && PlayerController(Instigator.Controller) != none ) {
            LastHasGunMsgTime = Level.TimeSeconds + 0.5;
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 1);
        }
        return True;
    }

    return Super.HandlePickupQuery(Item);
}

function GiveTo(pawn Other, optional Pickup Pickup) {
    local Inventory I;
    local int OldAmmo;
    local bool bNoPickup;

    MagAmmoRemaining = 0;

    For(I = Other.Inventory; I != None; I =I.Inventory) {
        if (Deagle(I) != none) {
            if(WeaponPickup(Pickup)!= none) {
                WeaponPickup(Pickup).AmmoAmount[0] += Weapon(I).AmmoAmount(0);
            } else {
                OldAmmo = Weapon(I).AmmoAmount(0);
                bNoPickup = true;
            }

            MagAmmoRemaining = Deagle(I).MagAmmoRemaining;

            I.Destroyed();
            I.Destroy();

            Break;
        }
    }

    if (KFWeaponPickup(Pickup) != None && Pickup.bDropped) {
        MagAmmoRemaining= Clamp(MagAmmoRemaining + KFWeaponPickup(Pickup).MagAmmoRemaining, 0, MagCapacity);
    }
    else {
        MagAmmoRemaining= Clamp(MagAmmoRemaining + Class'KFRollback.Deagle'.Default.MagCapacity, 0, MagCapacity);
    }

    Super(Weapon).GiveTo(Other, Pickup);

    if (bNoPickup) {
        AddAmmo(OldAmmo, 0);
        Clamp(Ammo[0].AmmoAmount, 0, MaxAmmo(0));
    }
}

function DropFrom(vector StartLocation) {
    local int m;
    local Pickup Pickup;
    local Inventory I;
    local int AmmoThrown, OtherAmmo;

    if (!bCanThrow)
        return;

    AmmoThrown = AmmoAmount(0);
    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++) {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

    if ( Instigator != None )
        DetachFromPawn(Instigator);

    if (Instigator.Health > 0) {
        OtherAmmo = AmmoThrown / 2;
        AmmoThrown -= OtherAmmo;
        I = Spawn(Class'KFRollback.Deagle');
        I.GiveTo(Instigator);
        Weapon(I).Ammo[0].AmmoAmount = OtherAmmo;
        Deagle(I).MagAmmoRemaining = MagAmmoRemaining / 2;
        MagAmmoRemaining = Max(MagAmmoRemaining-Deagle(I).MagAmmoRemaining,0);
    }

    Pickup= Spawn(Class'KFRollback.DeaglePickup',,, StartLocation);

    if (Pickup != None) {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        WeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
        if( KFWeaponPickup(Pickup)!=None )
            KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }

    Destroyed();
    Destroy();
}

simulated function bool PutDown() {
    if (Instigator.PendingWeapon.class == class'KFRollback.Deagle') {
        bIsReloading = false;
    }

    return super.PutDown();
}

defaultproperties {
    PickupClass=Class'KFMod.DualDeaglePickup'
}
