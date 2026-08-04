-- ECLZJobs custom occupation clothing presets.
-- Kept separate from the old B41 file because that file overwrote vanilla defaults.

if not ClothingSelectionDefinitions then
    ClothingSelectionDefinitions = {}
end

local outfits = {}

outfits.taxista = {
    Female = {
        Hat = { items = {"Base.Hat_Beret"} },
        Pants = { items = {"Base.Trousers_Suit"} },
        RightWrist = { items = {"Base.WristWatch_Right_DigitalBlack"} },
    },
}

outfits.joyero = {
    Female = {
        Pants = { items = {"Base.Trousers_SuitTEXTURE"} },
        Hands = { items = {"Base.Gloves_WhiteTINT"} },
        Neck = { items = {"Base.Tie_Full"} },
        Jacket = { items = {"Base.Suit_Jacket"} },
        Necklace = { items = {"Base.Necklace_Gold"} },
    },
}

outfits.camarero = {
    Female = {
        Pants = { items = {"Base.Trousers_SuitTEXTURE"} },
        Neck = { items = {"Base.Tie_BowTieFull"} },
        Shirt = { items = {"Base.Tshirt_WhiteLongSleeve"} },
        TorsoExtra = { items = {"Base.Apron_White"} },
    },
}

outfits.preso = {
    Female = {
        FullSuit = { items = {"Base.Boilersuit_Prisoner"} },
        Shoes = { items = {"Base.Shoes_FlipFlop"} },
    },
}

outfits.farmaceutico = {
    Female = {
        Jacket = { items = {"Base.JacketLong_Doctor"} },
        Pants = { items = {"Base.Trousers_Scrubs"} },
        Shoes = { items = {"Base.Shoes_FlipFlop"} },
    },
}

outfits.armero = {
    Female = {
        Shirt = { items = {"Base.Shirt_CamoDesert"} },
        Pants = { items = {"Base.Shorts_CamoGreenLong"} },
        TorsoExtra = { items = {"Base.Vest_Hunting_Orange"} },
    },
}

outfits.repartidor = {
    Female = {
        Shirt = { items = {"Base.Shirt_Workman"} },
        Pants = { items = {"Base.Trousers_DefaultTEXTURE_TINT"} },
        Hat = { items = {"Base.Hat_BaseballCap"} },
        TorsoExtra = { items = {"Base.Vest_Waistcoat", "Base.Vest_Waistcoat_GigaMart"} },
    },
}

outfits.conserje = {
    Female = {
        FullSuit = { items = {"Base.Boilersuit_BlueRed"} },
        Hat = { items = {"Base.Hat_Beany"} },
        Hands = { items = {"Base.Gloves_WhiteTINT"} },
    },
}

for id, outfit in pairs(outfits) do
    ClothingSelectionDefinitions[id] = outfit
    ClothingSelectionDefinitions["eclzjobs:" .. id] = outfit
end
