pcall(require, "Items/ProceduralDistributions")

IDBFS = IDBFS or {}

local function registerDistributions()
    local pd = ProceduralDistributions
    if not pd or not pd.list then
        return false
    end

    if IDBFS._distributionsRegistered then
        return true
    end
    IDBFS._distributionsRegistered = true

    local function add(listName, itemType, weight)
        local list = pd.list[listName]
        if not list then
            return
        end
        list.items = list.items or {}
        table.insert(list.items, itemType)
        table.insert(list.items, weight)
    end

    add("KitchenBaking", "IDBFS.StarterYeast", 1.0)
    add("BakeryKitchenBaking", "IDBFS.StarterYeast", 3.0)
    add("GigamartBakingMisc", "IDBFS.StarterYeast", 2.0)
    add("StoreKitchenBaking", "IDBFS.StarterYeast", 2.0)

    add("KitchenCannedFood", "Base.Olives", 0.8)
    add("KitchenDryFood", "Base.Olives", 0.6)
    add("KitchenRandom", "Base.Olives", 0.4)
    add("GigamartCannedFood", "Base.Olives", 1.2)
    add("GigamartDryGoods", "Base.Olives", 0.8)
    add("GigamartSpices", "Base.Olives", 1.5)
    add("StoreShelfCombo", "Base.Olives", 0.8)
    add("StoreShelfSpices", "Base.Olives", 1.0)
    add("RestaurantKitchenFridge", "Base.Olives", 0.8)
    add("RestaurantKitchenFreezer", "Base.Olives", 0.3)
    add("CrateCannedFood", "Base.Olives", 1.2)
    add("CrateCondiments", "Base.Olives", 1.0)
    add("CrateOilOlive", "Base.Olives", 2.0)
    add("GroceryStorageCrate1", "Base.Olives", 1.0)
    add("GroceryStorageCrate2", "Base.Olives", 1.0)
    add("GroceryStorageCrate3", "Base.Olives", 1.0)
    add("FoodGourmet", "Base.Olives", 2.0)

    return true
end

registerDistributions()
if Events and Events.OnPreDistributionMerge then
    Events.OnPreDistributionMerge.Add(registerDistributions)
elseif Events and Events.OnInitGlobalModData then
    Events.OnInitGlobalModData.Add(registerDistributions)
end
