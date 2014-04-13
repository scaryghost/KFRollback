class RollbackPack extends Object
    abstract;

function array<class<KFVeterancyTypes> > getPerks();
function int getMaxPerkLevel();
function array<class<Pickup> > getWeaponPickups();
function getSinglePickup(class<Pickup> dualPickup);
function class<KFMonstersCollection> getMonstersCollection();
function string replaceActor(Actor other);
