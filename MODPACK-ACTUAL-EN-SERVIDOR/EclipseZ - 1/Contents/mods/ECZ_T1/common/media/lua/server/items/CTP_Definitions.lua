local CTPDef = {
-- use all for specific containers that spawn the same loot reguardless of location

    all = {
	
		Crucifix = {
			rolls = 1,
			items = {
				"CorpseMale", 50,
				"CorpseFemale", 50,
			}
		},
		
		Body_Bag = {
			rolls = 1,
			items = {
				"CorpseMale", 50,
				"CorpseFemale", 50,
			}
		},
		
		Coffin = {
			rolls = 1,
			items = {
				"CorpseMale", 50,
				"CorpseFemale", 50,
			}
		},
		
		BulletinBoard = {
			procedural = true,
			procList = {
				{name="MagazineRackMaps", min=1, max=4, weightChance=40},
				{name="MagazineRackMixed", min=1, max=99, weightChance=100},
				{name="MagazineRackNewspaper", min=1, max=4, weightChance=40},
				{name="HospitalMagazineRack", min=0, max=99, weightChance=20},
				{name="GiftStoreCards", min=0, max=99, weightChance=20},
			}
		},
		
		Cassette_Shelf = {
			rolls = 5,
			items = {
				"Disc_Retail", 2,
				"CDplayer", 1,
				"Earbuds", 2,
			}
		},
		
		Airdrop_Crate = {
			procedural = true,
			procList = {
				{name="ArmySurplusAmmoBoxes", min=0, max=1, weightChance=20},
				{name="ArmySurplusBackpacks", min=0, max=99, weightChance=100},
				{name="ArmySurplusCases", min=0, max=1, weightChance=20},
				{name="ArmySurplusCots", min=0, max=1, weightChance=40},
				{name="ArmySurplusFootwear", min=0, max=99, weightChance=100},
				{name="ArmySurplusOutfit", min=0, max=99, weightChance=100},
				{name="ArmySurplusMisc", min=0, max=99, weightChance=100},
				{name="ArmySurplusTools", min=0, max=99, weightChance=100},
				{name="ArmySurplusWater", min=0, max=1, weightChance=100},
				{name="CampingStoreGear", min=0, max=2, weightChance=60},
				{name="ClothingStorageWinter", min=0, max=2, weightChance=60},
			}
		},
		
		Tailoring_Bench = {
			procedural = true,
			procList = {
				{name="SewingStoreTools", min=1, max=99, weightChance=100},
                {name="SewingStoreFabric", min=1, max=99, weightChance=100},
				{name="CrateFabric_Cotton", min=1, max=99, weightChance=60},
                {name="CrateFabric_DenimBlack", min=0, max=99, weightChance=20},
                {name="CrateFabric_DenimBlue", min=0, max=99, weightChance=40},
                {name="CrateFabric_DenimDarkBlue", min=0, max=99, weightChance=20},
				{name="CrateIndustrialDye", min=0, max=1, weightChance=20},
				{name="TailoringLiterature", min=0, max=99, weightChance=10},
				{name="ArtStoreLiterature", min=0, max=99, weightChance=10},
			}
		},
		
		Metalworking_Bench = {
			procedural = true,
			procList = {
				{name="ToolStoreMetalwork", min=0, max=99, weightChance=100},
				{name="CrateMetalwork", min=0, max=99, weightChance=100},
				{name="WeldingWorkshopFuel", min=0, max=1, weightChance=60},
				{name="WeldingWorkshopMetal", min=0, max=99, weightChance=100},
				{name="WeldingWorkshopTools", min=0, max=99, weightChance=100},
				{name="CrateSheetMetal", min=0, max=4, weightChance=20},
			}
		},
		
		Electrical_Bench = {
			procedural = true,
			procList = {
				{name="ArmyStorageElectronics", min=0, max=99, weightChance=10},
				{name="CrateElectronics", min=0, max=1, weightChance=100},
				{name="ElectronicStoreCases", min=0, max=2, weightChance=20},
				{name="ElectronicStoreAppliances", min=0, max=4, weightChance=60},
				{name="ElectronicStoreComputers", min=0, max=4, weightChance=80},
				{name="ElectronicStorePhones", min=0, max=4, weightChance=100},
				{name="ElectronicStoreMagazines", min=0, max=99, weightChance=80},
				{name="ElectronicStoreMisc", min=0, max=99, weightChance=100},
				{name="ElectronicStoreLights", min=0, max=1, weightChance=10},
				{name="ElectronicStoreMusic", min=0, max=1, weightChance=10},
				{name="ElectronicStoreHAMRadio", min=0, max=1, weightChance=10},
				{name="GigamartHouseElectronics", min=1, max=2, weightChance=60},
				{name="CyberCafeFilingCabinet", min=1, max=2, weightChance=10},
			}
		},
		
		Woodworking_Bench = {
			procedural = true,
			procList = {
				{name="GarageCarpentry", min=0, max=2, weightChance=100},
				{name="CrateCarpentry", min=0, max=1, weightChance=100},
				{name="ToolStoreCarpentry", min=0, max=99, weightChance=100},
				{name="CarpenterTools", min=1, max=4, weightChance=20},
				{name="CarpenterOutfit", min=1, max=2, weightChance=20},
				{name="CarpentryBooks", min=0, max=99, weightChance=10},
			}
		},
		
		Drug_Lab = {
			procedural = true,
			procList = {
				{name="DrugShackWeapons", min=0, max=1, weightChance=10},
				{name="DrugShackDrugs", min=0, max=1, weightChance=20},
				{name="DrugShackTools", min=0, max=1, weightChance=20},
				{name="DrugLabOutfit", min=0, max=1, weightChance=20},
				{name="DrugLabMoney", min=0, max=1, weightChance=40},
				{name="DrugLabSupplies", min=1, max=99, weightChance=100},
				{name="FreezerDrugLab", min=0, max=99, weightChance=20},
				{name="FridgeDrugLab", min=0, max=99, weightChance=20},
			}
		},
		
		-- using ["name here"] allows spaces in the container name
		["Gunsmithing Bench"] = {
			procedural = true,
			procList = {
				{name="GunStoreAccessories", min=0, max=1, weightChance=40},
				{name="GunStoreMagazineRack", min=0, max=99, weightChance=40},
				{name="GunStoreAmmunition", min=0, max=99, weightChance=20},
				{name="GunStoreLiterature", min=0, max=99, weightChance=10},
			}
		},
				
				
		
		StackedAmmoPallet = {
			procedural = true,
			procList = {
				{name="GunStoreBodyArmor", min=0, max=1, weightChance=10},
				{name="GunStoreAmmunition", min=0, max=99, weightChance=50},
				{name="PoliceStorageGuns", min=0, max=99, weightChance=25},
				{name="ArmySurplusCases", min=0, max=99, weightChance=100},
				{name="ArmyStorageOutfit", min=0, max=99, weightChance=100},
				{name="SWATStorageGuns", min=0, max=99, weightChance=25},
				{name="ArmyStorageAmmunition", min=0, max=99, weightChance=50},
			}
		},
		
		WeaponPallet = {
			procedural = true,
			procList = {
				{name="GunStoreAmmunition", min=0, max=99, weightChance=50},
				{name="ArmyStorageAmmunition", min=0, max=99, weightChance=50},
				{name="SWATStorageAmmunition", min=0, max=99, weightChance=50},
				{name="PoliceStorageAmmunition", min=0, max=99, weightChance=50},
			}
		},
		
		ToolPallet = {
			procedural = true,
			procList = {
				{name="ToolCabinetMechanics", min=0, max=99, weightChance=20},
				{name="Bag_JanitorToolbox", min=0, max=99, weightChance=20},
				{name="CrateTools", min=0, max=99, weightChance=20},
				{name="WeldingWorkshopTools", min=0, max=99, weightChance=20},
				{name="CarSupplyTools", min=0, max=99, weightChance=20},
				{name="BurglarTools", min=0, max=1, weightChance=10},
				{name="CrateToolsOld", min=0, max=1, weightChance=10},
				{name="EngineerTools", min=0, max=1, weightChance=10},
			}
		},
		
		SuppliesPallet = {
			procedural = true,
			procList = {
				{name="LaundryCleaning", min=0, max=99},
			}
		},
		
		FoodPallet = {
			procedural = true,
			procList = {
				{name="KitchenCannedFood", min=1, max=1, weightChance=100},
				{name="KitchenDryFood", min=0, max=1, weightChance=100},
				{name="KitchenBreakfast", min=0, max=1, weightChance=100},
				{name="KitchenBottles", min=0, max=1, weightChance=100},
				{name="KitchenRandom", min=0, max=1, weightChance=100},
				{name="GigamartCannedFood", min=1, max=99, weightChance=100},
				{name="GigamartBakingMisc", min=0, max=99, weightChance=40},
				{name="GigamartDryGoods", min=0, max=99, weightChance=60},
			}
		},
		
		 ExoticPot = {
            rolls = 1,
            items = {        
                "TheBong", 50, 
                "Greenfire.Cannabis", 100,
                "Greenfire.Cannabis", 100,
                "Greenfire.Cannabis", 100,                      
            }
        },
		
		Rusty = {
            rolls = 1,
            items = {        
                "Rusty", 100,                     
            }
        },
		
		WireShelves = {
			procedural = true,
			procList = {
				{name="Antiques", min=0, max=1, weightChance=1},
				{name="BurglarTools", min=0, max=1, weightChance=1},
				{name="CrateCamping", min=0, max=1, weightChance=1},
				{name="CrateCostume", min=0, max=1, weightChance=1},
				{name="CrateMannequins", min=0, max=1, weightChance=1},
				{name="Hiker", min=0, max=1, weightChance=1},
				{name="Homesteading", min=0, max=1, weightChance=1},
				{name="Hunter", min=0, max=1, weightChance=1},
				{name="MechanicSpecial", min=0, max=1, weightChance=1},
				{name="SurvivalGear", min=0, max=1, weightChance=1},
				{name="Trapper", min=0, max=1, weightChance=1},
				{name="ArtSupplies", min=0, max=1, weightChance=5},
				{name="Chemistry", min=0, max=1, weightChance=5},
				{name="CrateCanning", min=0, max=1, weightChance=5},
				{name="CrateDishes", min=0, max=1, weightChance=5},
				{name="CrateInstruments", min=0, max=1, weightChance=5},
				{name="CrateLinens", min=0, max=1, weightChance=5},
				{name="CratePetSupplies", min=0, max=1, weightChance=5},
				{name="CratePhotos", min=0, max=1, weightChance=5},
				{name="CrateSports", min=0, max=1, weightChance=5},
				{name="CrateToys", min=0, max=1, weightChance=5},
				{name="EngineerTools", min=0, max=1, weightChance=5},
				{name="FitnessTrainer", min=0, max=1, weightChance=5},
				{name="Gifts", min=0, max=1, weightChance=5},
				{name="Hobbies", min=0, max=1, weightChance=5},
				{name="HolidayStuff", min=0, max=1, weightChance=5},
				{name="ImprovisedCrafts", min=0, max=1, weightChance=5},
				{name="JunkHoard", min=0, max=1, weightChance=5},
				{name="Photographer", min=0, max=1, weightChance=5},
				{name="PlumbingSupplies", min=0, max=1, weightChance=5},
				{name="ScienceMisc", min=0, max=1, weightChance=5},
				{name="VacationStuff", min=0, max=1, weightChance=5},
				{name="WallDecor", min=0, max=1, weightChance=5},
				{name="CrateComputer", min=0, max=1, weightChance=10},
				{name="CrateTV", min=0, max=1, weightChance=10},
				{name="CrateTVWide", min=0, max=1, weightChance=10},
				{name="CrateElectronics", min=0, max=1, weightChance=10},
				{name="ClothingStorageWinter", min=0, max=1, weightChance=10},
				{name="CrateClothesRandom", min=0, max=1, weightChance=10},
				{name="CrateFootwearRandom", min=0, max=1, weightChance=10},
				{name="CrateBlacksmithing", min=0, max=1, weightChance=1},
				{name="CrateCarpentry", min=0, max=1, weightChance=10},
				{name="CrateFarming", min=0, max=1, weightChance=10},
				{name="CrateFishing", min=0, max=1, weightChance=10},
				{name="CrateMechanics", min=0, max=1, weightChance=10},
				{name="CrateMetalwork", min=0, max=1, weightChance=10},
				{name="CrateTailoring", min=0, max=1, weightChance=10},
				{name="CrateTools", min=0, max=1, weightChance=10},
				{name="CrateToolsOld", min=0, max=1, weightChance=20},
				{name="CrateFabric_Cotton", min=0, max=1, weightChance=1},
				{name="CrateFabric_DenimBlack", min=0, max=1, weightChance=1},
				{name="CrateFabric_DenimBlue", min=0, max=1, weightChance=1},
				{name="CrateFabric_DenimDarkBlue", min=0, max=1, weightChance=1},
				{name="CrateRandomJunk", min=0, max=4, weightChance=60},
			}
		},
		
		extinguisher_box = {
			rolls = 1,
			items = {
				"Extinguisher",100,
			}
		},
		
		SpoonRack = {
			rolls = 8,
			items = {
				"Ladle", 25,
				"Ladle", 25,
				"Whisk", 10,
				"GrillBrush", 10,
				"Spatula", 10,
				"CarvingFork2", 10,
				"BreadKnife", 5,
				"MeatCleaver", 5,
				"KitchenTongs", 1,
				"PizzaCutter", 1,
				"SteakKnife", 1,
				"LargeKnife", 1,
				"KitchenKnife", 1,
				"KnifeFillet", 1,
				"KnifeParing", 1,
			}
		},		
		
		StandingToolbox = {
			procedural = true,
			procList = {
				{name="ToolCabinetMechanics", min=0, max=99, weightChance=20},
				{name="Bag_JanitorToolbox", min=0, max=99, weightChance=20},
				{name="CrateTools", min=0, max=99, weightChance=20},
				{name="WeldingWorkshopTools", min=0, max=99, weightChance=20},
				{name="CarSupplyTools", min=0, max=99, weightChance=20},
				{name="CrateToolsOld", min=0, max=1, weightChance=10},
			}
		},
		
		ToolTray = {
			procedural = true,
			procList = {
				{name="ToolCabinetMechanics", min=0, max=99, weightChance=20},
				{name="Bag_JanitorToolbox", min=0, max=99, weightChance=20},
				{name="CrateTools", min=0, max=99, weightChance=20},
				{name="WeldingWorkshopTools", min=0, max=99, weightChance=20},
				{name="CarSupplyTools", min=0, max=99, weightChance=20},
				{name="BurglarTools", min=0, max=1, weightChance=10},
				{name="CrateToolsOld", min=0, max=1, weightChance=10},
				{name="EngineerTools", min=0, max=1, weightChance=10},
			}
		},
		
		Safe = {
			procedural = true,
			procList = {
				{name="BankDeposit", min=0, max=1, weightChance=10},
				{name="CarDealerDesk", min=0, max=1, weightChance=10},
				{name="DerelictHouseCrime", min=0, max=1, weightChance=10},
				{name="DrugLabMoney", min=0, max=1, weightChance=10},
				{name="PlankStashMoney", min=0, max=1, weightChance=10},
				{name="PoliceEvidence", min=0, max=1, weightChance=10},
			}
		},
		
	},
	
	kitchen = {
		WireShelves = {
			rolls = 10,
			items = {
				"Pot", 20,
				"BakingPan", 20,
				"BakingTray", 20,
				"MuffinTray", 20,
				"Bowl", 10,
				"Saucepan", 8,
				"SaucepanCopper", 5,
			}
		},
	},
}

table.insert(Distributions, 2, CTPDef);