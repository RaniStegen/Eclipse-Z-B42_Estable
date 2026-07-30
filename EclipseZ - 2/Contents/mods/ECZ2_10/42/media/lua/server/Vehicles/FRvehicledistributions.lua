-- pull the vehicle distributions into a local table
local distributionTable = VehicleDistributions[1]

VehicleDistributions.MilitaryGearTrunk = {
    rolls = 4,
    items ={
        "Bag_ALICEpack_Army", 3,
        "Vest_BulletArmy", 3,
        "556Clip", 3,
        "556Clip", 3,
        "556Clip", 3,
        "556Box", 3,
        "556Box", 3,
        "556Box", 3,
        "556Box", 3,
        "556Box", 3,
        "Hat_Army", 3,
        "Hat_GasMask", 3,
        "Hat_GasMask", 3,
        "Hat_GasMask", 3,
        "AssaultRifle", 2,
        "AssaultRifle", 2,
        "Pistol", 3,
        "Pistol", 3,
        "Pistol", 3,
        "9mmClip", 3,
        "9mmClip", 3,
        "9mmClip", 3,
        "Bullets9mm", 3,
        "Bullets9mm", 3,
        "Bullets9mm", 3,
        "Bullets9mm", 3,
        "Bullets9mm", 3,
		"HolsterSimple", 3,
        "Trousers_CamoGreen", 1,
        "Shirt_CamoGreen", 1,
        "Jacket_ArmyCamoGreen", 1,
        "Hat_BonnieHat_CamoGreen", 1,
        "Hat_PeakedCapArmy", 0.5,
        "Hat_BeretArmy", 0.5,
        "Jacket_CoatArmy", 0.5,
        "Shoes_ArmyBoots", 1,
        "Shirt_CamoGreen", 1,
        "Radio.WalkieTalkie5", 3,
        "HuntingKnife", 3,
        "FirstAidKit", 3,
		"EmptyPetrolCan", 3,
		"PetrolCan", 2,
		"x2Scope", 0.7,
		"x4Scope", 0.5,
		"x8Scope", 0.3,
    }
}

VehicleDistributions.MilitarySeat = {
    rolls = 1,
    items ={
        "556Clip", 3,
        "Hat_Army", 3,
        "Hat_GasMask", 3,
        "Pistol", 3,
        "9mmClip", 3,
		"HolsterSimple", 3,
        "Jacket_ArmyCamoGreen", 3,
        "Hat_BonnieHat_CamoGreen", 3,
        "Hat_PeakedCapArmy", 1,
        "Hat_BeretArmy", 1,
        "Jacket_CoatArmy", 1,
        "Radio.WalkieTalkie5", 3,
        "HuntingKnife", 3,
		"Cigarettes", 7,
        "Bag_ALICEpack_Army", 3,
        "Vest_BulletArmy", 3,
	
    }
}

VehicleDistributions.MadmaxGear = {
    rolls = 1,
    items ={
        "ShotgunShellsBox", 80,
		"DoubleBarrelShotgun", 90,
        "Dogfood", 100,
        "Base.Splint", 100,
    }
}


-- add a new military distributions table
VehicleDistributions.Military = {
    TruckBed = VehicleDistributions.MilitaryGearTrunk;
    TruckbedOpen = VehicleDistributions.MilitaryGearTrunk;

    SeatRearLeft = VehicleDistributions.MilitarySeat;
    SeatRearRight = VehicleDistributions.MilitarySeat;
}

VehicleDistributions.Madmax = {
    SeatRearRight = VehicleDistributions.MadmaxGear;
}

VehicleDistributions.SideBox = {
	TruckBed = VehicleDistributions.TrunkHeavy;
	
	TruckBedOpen = VehicleDistributions.TrunkHeavy;
	
	GloveBox = VehicleDistributions.GloveBox;
	
	SeatRearLeft = VehicleDistributions.Seat;
	SeatRearRight = VehicleDistributions.Seat;
}

distributionTable["fr_am_gremlin_73"] = distributionTable["CarNormal"]
distributionTable["fr_ag_hmmwv_92_2d_mil"] = distributionTable["Military"]
distributionTable["fr_ag_hmmwv_92_4d_mil"] = distributionTable["Military"]
distributionTable["fr_ag_m151_85_mil"] = distributionTable["Military"]
distributionTable["fr_ag_m35_88_mil"] = distributionTable["Military"]
distributionTable["fr_ag_m49_88_mil"] = distributionTable["Military"]
distributionTable["fr_bu_wildcat_68"] = distributionTable["CarNormal"]
distributionTable["fr_bu_wildcat_68_convert"] = distributionTable["CarNormal"]
distributionTable["fr_ca_deville_79"] = distributionTable["CarNormal"]
distributionTable["fr_ca_deville_79_coupe"] = distributionTable["CarNormal"]
distributionTable["fr_ch_3100_51"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_3100_51_offroad"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_3100_51_old"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_astro_92"] = distributionTable["VanSeats"]
distributionTable["fr_ch_belair_55"] = distributionTable["CarNormal"]
distributionTable["fr_ch_belair_55_taxi"] = distributionTable["CarNormal"]
distributionTable["fr_ch_blazer_87"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_blazer_87_mil"] = distributionTable["Military"]
distributionTable["fr_ch_blazer_87_offroad"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_blazer_87_police"] = distributionTable["PickUpVanLightsPolice"]
distributionTable["fr_ch_c10_71_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_71_lb_ranger"] = distributionTable["PickUpTruckLights0"]
distributionTable["fr_ch_c10_71_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_71_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_71_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_87_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_87_lb_mil"] = distributionTable["Military"]
distributionTable["fr_ch_c10_87_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_87_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_87_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_c10_87_utility"] = distributionTable["PickUpVan"]
distributionTable["fr_ch_c10_87_utility_fire"] = distributionTable["PickUpTruckLightsFire"]
distributionTable["fr_ch_c10_87_utility_mccoy"] = distributionTable["PickUpVanMccoy"]
distributionTable["fr_ch_caprice_87"] = distributionTable["CarNormal"]
distributionTable["fr_ch_caprice_87_police"] = distributionTable["CarLightsPolice"]
distributionTable["fr_ch_caprice_87_taxi"] = distributionTable["CarTaxi"]
distributionTable["fr_ch_caprice_87_wag"] = distributionTable["CarStationWagon"]
distributionTable["fr_ch_chevelle_70"] = distributionTable["CarNormal"]
distributionTable["fr_ch_chevelle_70_convert"] = distributionTable["CarNormal"]
distributionTable["fr_ch_corvette_79"] = distributionTable["SportsCar"]
distributionTable["fr_ch_elcamino_70"] = distributionTable["CarNormal"]
distributionTable["fr_ch_impala_71"] = distributionTable["CarNormal"]
distributionTable["fr_ch_montecarlo_83"] = distributionTable["CarNormal"]
distributionTable["fr_ch_montecarlo_83_ttop"] = distributionTable["CarNormal"]
distributionTable["fr_ch_s10_91_ext_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_ext_lb_ranger"] = distributionTable["PickUpTruckLights0"]
distributionTable["fr_ch_s10_91_ext_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_ext_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_ext_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_lb_ranger"] = distributionTable["PickUpTruckLights0"]
distributionTable["fr_ch_s10_91_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_s10_91_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_ch_stepvan_80"] = distributionTable["StepVan"]
distributionTable["fr_ch_stepvan_80_police"] = distributionTable["PickUpVanLightsPolice"]
distributionTable["fr_ch_suburban_87"] = distributionTable["SUV"]
distributionTable["fr_ch_suburban_87_offroad"] = distributionTable["SUV"]
distributionTable["fr_da_240z_73"] = distributionTable["SportsCar"]
distributionTable["fr_do_charger_69"] = distributionTable["CarNormal"]
distributionTable["fr_do_charger_69_daytona"] = distributionTable["CarNormal"]
distributionTable["fr_do_charger_69_general"] = distributionTable["CarNormal"]
distributionTable["fr_do_dakota_89_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_dakota_89_shelby_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_ram_90_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_ram_90_moving"] = distributionTable["StepVan"]
distributionTable["fr_do_ram_90_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_ram_90_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_ram_90_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_do_viper_92"] = distributionTable["SportsCar"]
distributionTable["fr_fl_bounder_86"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_bronco_80"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_bronco_80_offroad"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_crownvic_85"] = distributionTable["CarNormal"]
distributionTable["fr_fo_crownvic_85_coupe"] = distributionTable["CarNormal"]
distributionTable["fr_fo_crownvic_85_police"] = distributionTable["CarLightsPolice"]
distributionTable["fr_fo_crownvic_85_taxi"] = distributionTable["CarTaxi"]
distributionTable["fr_fo_crownvic_85_wag"] = distributionTable["CarStationWagon"]
distributionTable["fr_fo_crownvic_85_wagtaxi"] = distributionTable["CarTaxi"]
distributionTable["fr_fo_crownvic_92"] = distributionTable["CarNormal"]
distributionTable["fr_fo_crownvic_92_police"] = distributionTable["CarLightsPolice"]
distributionTable["fr_fo_econoline_86"] = distributionTable["Van"]
distributionTable["fr_fo_econoline_86_ambulance"] = distributionTable["VanAmbulance"]
distributionTable["fr_fo_econoline_86_florist"] = distributionTable["Van"]
distributionTable["fr_fo_econoline_rv_86"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_explorer_93"] = distributionTable["SUV"]
distributionTable["fr_fo_explorer_93_jurassic"] = distributionTable["SUV"]
distributionTable["fr_fo_f350_80"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_f350_80_offroad"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_f350_80_offroadquad"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_f350_80_quad"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_f350_ambulance_80"] = distributionTable["VanAmbulance"]
distributionTable["fr_fo_f700_90_boxlarge"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_boxmed"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_dump"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_flatmed"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_flatsmall"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_fuel"] = distributionTable["StepVan"]
distributionTable["fr_fo_f700_90_pickup"] = distributionTable["PickUpTruck"]
distributionTable["fr_fo_f700_90_propane"] = distributionTable["StepVan"]
distributionTable["fr_fo_falcon_73"] = distributionTable["CarNormal"]
distributionTable["fr_fo_falcon_73_pursuit"] = distributionTable["Madmax"]
distributionTable["fr_fo_mustang_64"] = distributionTable["CarNormal"]
distributionTable["fr_fo_mustang_64_convert"] = distributionTable["CarNormal"]
distributionTable["fr_fo_pinto_73"] = distributionTable["CarNormal"]
distributionTable["fr_gr_llv_89"] = distributionTable["StepVanMail"]
distributionTable["fr_is_nrr_93_boxmed"] = distributionTable["StepVan"]
distributionTable["fr_is_nrr_93_dump"] = distributionTable["StepVan"]
distributionTable["fr_is_nrr_93_flatmed"] = distributionTable["StepVan"]
distributionTable["fr_is_nrr_93_flatsmall"] = distributionTable["StepVan"]
distributionTable["fr_je_cherokee_93"] = distributionTable["SUV"]
distributionTable["fr_je_cherokee_93_offroad"] = distributionTable["SUV"]
distributionTable["fr_je_cherokee_93_police"] = distributionTable["PickUpVanLightsPolice"]
distributionTable["fr_je_wagoneer_91"] = distributionTable["SUV"]
distributionTable["fr_je_wrangler_92"] = distributionTable["OffRoad"]
distributionTable["fr_je_wrangler_92_jurassic"] = distributionTable["OffRoad"]
distributionTable["fr_je_wrangler_92_offroad"] = distributionTable["OffRoad"]
distributionTable["fr_pi_engine_90_fire"] = distributionTable["PickUpVanLightsFire"]
distributionTable["fr_po_gto_65"] = distributionTable["CarNormal"]
distributionTable["fr_po_transam_77"] = distributionTable["CarNormal"]
distributionTable["fr_po_transam_77_bandit"] = distributionTable["CarNormal"]
distributionTable["fr_po_transam_77_ttop"] = distributionTable["CarNormal"]
distributionTable["fr_pe_359_82_short"] = distributionTable["Van"]
distributionTable["fr_pe_359_82_med"] = distributionTable["Van"]
distributionTable["fr_pe_359_82_long"] = distributionTable["Van"]
distributionTable["fr_to_celica_91"] = distributionTable["SmallCar"]
distributionTable["fr_to_corolla_90"] = distributionTable["SmallCar"]
distributionTable["fr_to_corolla_90_coupe"] = distributionTable["SmallCar"]
distributionTable["fr_to_corolla_90_hatch"] = distributionTable["SmallCar"]
distributionTable["fr_to_hilux_83_lb"] = distributionTable["PickUpTruck"]
distributionTable["fr_to_hilux_83_offroadlb"] = distributionTable["PickUpTruck"]
distributionTable["fr_to_hilux_83_offroadsb"] = distributionTable["PickUpTruck"]
distributionTable["fr_to_hilux_83_sb"] = distributionTable["PickUpTruck"]
distributionTable["fr_vo_240_93"] = distributionTable["CarNormal"]
distributionTable["fr_vo_240_93_wagon"] = distributionTable["CarStationWagon"]
distributionTable["fr_vw_beetle_72"] = distributionTable["CarNormal"]
distributionTable["Trailer_fr_ch_3100_51"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_moving_large"] = distributionTable["StepVan"]
distributionTable["Trailer_fr_moving_medium"] = distributionTable["StepVan"]
distributionTable["Trailer_fr_open_bed_small"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_open_bed_medium"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_open_bed_big"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_open_bed_large"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_semi_container"] = distributionTable["StepVan"]
distributionTable["Trailer_fr_semi_flatbed"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_semi_sideboards"] = distributionTable["PickUpTruck"]
distributionTable["Trailer_fr_semi_van"] = distributionTable["StepVan"]