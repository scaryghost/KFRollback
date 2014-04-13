class RollbackPack extends Object
    abstract;

function array<class<KFVeterancyTypes> > getPerks();
function int getMaxPerkLevel();
function array<class<Pickup> > getWeaponPickups();
function getSinglePickup(class<Pickup> dualPickup);
function class<KFMonstersCollection> getMonstersCollection();
function bool replaceWeaponPickup(KFWeaponPickup weaponPickup);
function bool replaceAmmoPickup(KFAmmoPickup ammoPickup);
function bool replaceWeapon(Weapon weapon);
