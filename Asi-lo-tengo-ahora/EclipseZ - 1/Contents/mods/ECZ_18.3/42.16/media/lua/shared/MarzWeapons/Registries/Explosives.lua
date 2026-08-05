local OrdnanceFactory = require("ExplosivesSystems/OrdnanceFactory")

OrdnanceFactory.Register("MarzGuns.M67", {
    throwForce          = 8,
    maxThrowDist        = 15,
    floorBounces        = 5,
    bounceEnergy        = 0.2,
    forwardOffset       = 0.50,
    heightOffset        = 0.55,

    detonateOnImpact    = false,
    detonationDelay     = 3,

    explosionFXObject   = "MarzGuns.explosion_0",
    explosionFXDuration = 5,
})

OrdnanceFactory.Register("MarzGuns.M18", {
    throwForce          = 8,
    maxThrowDist        = 15,
    floorBounces        = 5,
    bounceEnergy        = 0.2,
    forwardOffset       = 0.50,
    heightOffset        = 0.55,

    detonateOnImpact    = false,
    detonationDelay     = 3,

    explosionFXObject   = "MarzGuns.explosion_0",
    explosionFXDuration = 5,
})

OrdnanceFactory.Register("MarzGuns.M14_Incendiary", {
    throwForce          = 8,
    maxThrowDist        = 15,
    floorBounces        = 5,
    bounceEnergy        = 0.2,
    forwardOffset       = 0.50,
    heightOffset        = 0.55,

    detonateOnImpact    = false,
    detonationDelay     = 3,

    explosionFXObject   = "MarzGuns.explosion_0",
    explosionFXDuration = 5,
})

OrdnanceFactory.RegisterAmmo("MarzGuns.40mm_Round_HE", {
    throwSpeed          = 25,
    maxThrowDist        = 40,
    arcFactor           = 0.03,

    detonateOnImpact    = true,

    parentItem          = "MarzGuns.40mm_HE_Explosion",

    worldModel          = "MarzGuns.M67",
    explosionFXObject   = "MarzGuns.explosion_0",
    explosionFXDuration = 5,
})

OrdnanceFactory.RegisterAmmo("MarzGuns.40mm_Round_Incendiary", {
    throwSpeed          = 25,
    maxThrowDist        = 40,
    arcFactor           = 0.03,

    detonateOnImpact    = true,

    parentItem          = "MarzGuns.40mm_Incendiary_Explosion",

    worldModel          = "MarzGuns.M67",
    explosionFXObject   = "MarzGuns.explosion_0",
    explosionFXDuration = 5,
})
