class RollbackPack extends Object
    abstract;

struct DualInfo {
    var class<KFWeapon> dualWeapon;
    var clasS<KFWeapon> singleWeapon;
    var bool keepPrice;
};

function array<class<KFVeterancyTypes> > getPerks();
function int getMaxPerkLevel();
function array<class<Pickup> > getWeaponPickups();
function array<RollbackPack.DualInfo> getDualWeapons();
function class<KFMonstersCollection> getMonstersCollection();
function string replaceActor(Actor other);
function array<string> getPackages();
