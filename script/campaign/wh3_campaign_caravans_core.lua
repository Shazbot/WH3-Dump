
out.design("*** Caravans script loaded ***");

caravans = {}

caravans.enemy_force_cqi = 0

caravans.event_tables = {}
------------------
------DATA--------
------------------
caravans.cultures_to_destination = {
	"cathay",
	"chaos_dwarfs"
}

-- This keeps track of all the individual convoy- events for each Chaos dwarf faction and its current cooldown that gets reduced each turn
caravans.events_cooldown = {}

caravans.event_max_cooldown = 15

caravans.culture_to_faction = {
	wh3_main_cth_cathay = "cathay",
	wh3_dlc23_chd_chaos_dwarfs = "chaos_dwarfs"
}

caravans.destinations_key = {
	main_warhammer = {
		cathay = {
			"wh3_main_combi_region_frozen_landing",
			"wh3_main_combi_region_myrmidens",
			"wh3_main_combi_region_erengrad",
			"wh3_main_combi_region_karaz_a_karak",
			"wh3_main_combi_region_castle_drakenhof",
			"wh3_main_combi_region_altdorf",
			"wh3_main_combi_region_marienburg",
			"wh3_main_combi_region_barak_varr",
			"wh3_main_combi_region_gisoreux",
			"wh3_main_combi_region_nuln"
		},

		chaos_dwarfs = {
			"wh3_main_combi_region_great_hall_of_greasus",
			"wh3_main_combi_region_the_haunted_forest",
			"wh3_main_combi_region_the_volary",
			"wh3_main_combi_region_castle_drakenhof",
			"wh3_main_combi_region_the_crystal_spires",
			"wh3_main_combi_region_bay_of_blades",
			"wh3_main_combi_region_black_crag",
			"wh3_main_combi_region_grung_zint",
			"wh3_main_combi_region_the_silvered_tower_of_sorcerers",
			"wh3_main_combi_region_troll_fjord",
			"wh3_main_combi_region_wizard_caliphs_palace",
			"wh3_main_combi_region_karond_kar"
		}
	},

	wh3_main_chaos = {
		cathay = {
			"wh3_main_chaos_region_frozen_landing",
			"wh3_main_chaos_region_shattered_stone_bay",
			"wh3_main_chaos_region_novchozy",
			"wh3_main_chaos_region_erengrad",
			"wh3_main_chaos_region_castle_drakenhof",
			"wh3_main_chaos_region_altdorf",
			"wh3_main_chaos_region_marienburg",
			"wh3_dlc23_chaos_region_the_haunted_forest"
		},

		chaos_dwarfs = {
			"wh3_dlc23_chaos_region_the_haunted_forest",
			"wh3_main_chaos_region_titans_notch",
			"wh3_main_chaos_region_castle_drakenhof",
			"wh3_main_chaos_region_the_volary",
			"wh3_dlc20_chaos_region_grung_zint",
			"wh3_main_chaos_region_bay_of_blades",
			"wh3_main_chaos_region_the_crystal_spires",
			"wh3_main_chaos_region_troll_fjord",
			"wh3_main_chaos_region_the_silvered_tower_of_sorcerers",
			"wh3_main_chaos_region_the_palace_of_ruin"
		}
	}
}	

--Initial caravan forces
caravans.traits_to_units = {
	---CATHAY
	["wh3_main_skill_innate_cth_caravan_master_cavalry"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_cav_jade_lancers_0",
		"wh3_main_cth_cav_jade_lancers_0",
		"wh3_main_cth_cav_jade_lancers_0",
		"wh3_main_cth_cav_jade_lancers_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_gunner"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_veh_sky_lantern_0",
		"wh3_main_cth_veh_sky_lantern_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_stealth"] = {
		{"wh3_main_cth_inf_peasant_archers_0", 2},
		{"wh3_main_cth_inf_peasant_archers_0", 2},
		{"wh3_main_cth_inf_peasant_spearmen_1", 2},
		{"wh3_main_cth_inf_peasant_spearmen_1", 2},
		{"wh3_main_cth_inf_jade_warriors_0", 4},
		{"wh3_main_cth_inf_jade_warriors_0", 2},
		{"wh3_main_cth_inf_jade_warriors_1", 4},
		{"wh3_main_cth_inf_jade_warrior_crossbowmen_1", 4},
		{"wh3_main_cth_inf_jade_warrior_crossbowmen_1", 4}
	},

	["wh3_main_skill_innate_cth_caravan_master_royalty"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_iron_hail_gunners_0",
		"wh3_main_cth_inf_iron_hail_gunners_0",
		"wh3_main_cth_cav_jade_lancers_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Dragon-Blooded"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_dragon_guard_0",
		"wh3_main_cth_inf_dragon_guard_crossbowmen_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Former-Artillery-Officer"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_art_grand_cannon_0",
		"wh3_main_cth_art_grand_cannon_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Humble-Born"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1"
	},

	["wh3_main_skill_innate_cth_caravan_master_Longma-Whisperer"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_cav_jade_longma_riders_0",
		"wh3_main_cth_cav_jade_longma_riders_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Nan-Gau"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_crane_gunners_0",
		"wh3_main_cth_inf_crane_gunners_0",
		"wh3_main_cth_art_fire_rain_rocket_battery_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Ogre-Ally"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_ogr_inf_maneaters_0",
		"wh3_main_ogr_inf_maneaters_1"
	},

	["wh3_main_skill_innate_cth_caravan_master_Shang-Yang"] = {
		"wh3_main_cth_cha_alchemist_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_jade_warriors_0",
		"wh3_main_cth_inf_jade_warriors_0"
	},

	["wh3_main_skill_innate_cth_caravan_master_Western-Idealist"] = {
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_archers_0",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_peasant_spearmen_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh3_main_cth_inf_jade_warriors_1",
		"wh_main_emp_inf_halberdiers",
		"wh_main_emp_inf_halberdiers",
		"wh_main_emp_inf_handgunners",
		"wh_main_emp_inf_crossbowmen"
	},

	---CHAOS DWARFS
	["wh3_dlc23_skill_innate_chd_convoy_overseer_bull_centaur_master"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_cav_bull_centaurs_greatweapons",
		"wh3_dlc23_chd_cav_bull_centaurs_axe"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_cannonry_experience"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_infernal_guard",
		"wh_main_chs_art_hellcannon"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_connected"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors_great_weapons",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors_great_weapons"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_covert"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_infernal_guard_fireglaives",
		"wh3_dlc23_chd_inf_infernal_guard_fireglaives",
		"wh3_dlc23_chd_inf_infernal_guard",
		"wh3_dlc23_chd_inf_infernal_guard"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_hobgoblin_favour"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_hobgoblin_sneaky_gits",
		"wh3_dlc23_chd_inf_hobgoblin_sneaky_gits",
		"wh3_dlc23_chd_inf_hobgoblin_archers",
		"wh3_dlc23_chd_cav_hobgoblin_wolf_raiders_swords"
	},
	
	["wh3_dlc23_skill_innate_chd_convoy_overseer_kdaai_domination"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_mon_kdaai_fireborn",
		"wh3_dlc23_chd_mon_kdaai_destroyer"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_metallic_resilience"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_infernal_ironsworn",
		"wh3_dlc23_chd_inf_infernal_ironsworn"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_monster_commander"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_mon_great_taurus",
		"wh3_dlc23_chd_mon_lammasu"
	},

	["wh3_dlc23_skill_innate_chd_convoy_overseer_ogre_controller"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_main_ogr_inf_maneaters_1",
		"wh3_main_ogr_inf_maneaters_0"
	},		

	["wh3_dlc23_skill_innate_chd_convoy_overseer_retired_daemonsmither"] = {
		"wh3_dlc23_chd_cha_bull_centaur_taurruk",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_cav_bull_centaurs_greatweapons"
	},			

	["wh3_dlc23_skill_innate_chd_convoy_overseer_sharpshooter"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_infernal_guard_fireglaives",
		"wh3_dlc23_chd_inf_infernal_guard_fireglaives"
	},		
	
	["wh3_dlc23_skill_innate_chd_convoy_overseer_war_machinist"] = {
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_veh_iron_daemon",
		"wh3_dlc23_chd_veh_skullcracker_1dreadquake"
	}		
}

caravans.reward_list = {
	wh3_main_cth_cathay = {
		wh3_main_chaos_region_frozen_landing     	= {"wh3_main_anc_caravan_frost_wyrm_skull", "wh3_main_cth_caravan_completed_frozen_landing", "wh3_main_ksl_mon_snow_leopard_0"},
		wh3_main_combi_region_frozen_landing		= {"wh3_main_anc_caravan_frost_wyrm_skull", "wh3_main_cth_caravan_completed_frozen_landing", "wh3_main_ksl_mon_snow_leopard_0"},

		wh3_main_chaos_region_shattered_stone_bay	= {"wh3_main_anc_caravan_sky_titan_relic", "wh3_main_cth_caravan_completed_stone_bay", "wh3_main_ogr_veh_ironblaster_0"},

		wh3_main_chaos_region_novchozy            	= {"wh3_main_anc_caravan_frozen_pendant", "wh3_main_cth_caravan_completed_novchozy", "wh3_dlc24_ksl_mon_the_things_in_the_woods"},

		wh3_main_chaos_region_erengrad           	= {"wh3_main_anc_caravan_gryphon_legion_lance", "wh3_main_cth_caravan_completed_erengrad", "wh3_dlc24_ksl_inf_akshina_ambushers"},
		wh3_main_combi_region_erengrad				= {"wh3_main_anc_caravan_gryphon_legion_lance", "wh3_main_cth_caravan_completed_erengrad", "wh3_dlc24_ksl_inf_akshina_ambushers"},

		wh3_main_chaos_region_castle_drakenhof   	= {"wh3_main_anc_caravan_von_carstein_blade", "wh3_main_cth_caravan_completed_castle_drakenhof", "wh2_dlc13_emp_inf_huntsmen_0"},
		wh3_main_combi_region_castle_drakenhof		= {"wh3_main_anc_caravan_von_carstein_blade", "wh3_main_cth_caravan_completed_castle_drakenhof", "wh2_dlc13_emp_inf_huntsmen_0"},

		wh3_main_chaos_region_altdorf            	= {"wh3_main_anc_caravan_luminark_lens", "wh3_main_cth_caravan_completed_altdorf", "wh_main_emp_cav_pistoliers_1"},
		wh3_main_combi_region_altdorf				= {"wh3_main_anc_caravan_luminark_lens", "wh3_main_cth_caravan_completed_altdorf", "wh_main_emp_cav_pistoliers_1"},

		wh3_main_chaos_region_marienburg          	= {"wh3_main_anc_caravan_warrant_of_trade", "wh3_main_cth_caravan_completed_marienburg", "wh_main_emp_art_great_cannon"},
		wh3_main_combi_region_marienburg			= {"wh3_main_anc_caravan_warrant_of_trade", "wh3_main_cth_caravan_completed_marienburg", "wh_main_emp_art_great_cannon"},

		wh3_main_combi_region_karaz_a_karak			= {"wh2_dlc10_dwf_anc_talisman_the_ankor_chain_caravan", "wh3_main_cth_caravan_completed_karaz_a_karak", "wh_main_dwf_veh_gyrocopter_0"},

		wh3_main_combi_region_myrmidens				= {"wh3_main_anc_caravan_grant_of_land", "wh3_main_cth_caravan_completed_tilea", "wh3_dlc25_dwf_inf_slayer_pirates"},

		wh3_main_combi_region_barak_varr			= {"wh2_dlc10_dwf_anc_armour_starmetal_plate_caravan", "wh3_main_cth_caravan_completed_barak_varr", "wh_main_dwf_art_organ_gun"},

		wh3_main_combi_region_gisoreux				= {"wh3_main_anc_caravan_mantle_of_damsel_elena", "wh3_main_cth_caravan_completed_gisoreux", "wh_dlc07_brt_cav_questing_knights_0"},

		wh3_main_combi_region_nuln					= {"wh3_dlc25_anc_weapon_experimental_explosive_caravan", "wh3_main_cth_caravan_completed_nuln", "wh_main_emp_art_helstorm_rocket_battery"}
	},
	wh3_dlc23_chd_chaos_dwarfs = {
		wh3_main_chaos_region_titans_notch 							= {"wh3_dlc23_anc_convoy_bones_of_the_maw", "wh3_dlc23_chd_convoy_unique_completed_titans_notch", "wh3_main_ogr_inf_maneaters_3"},
		wh3_main_combi_region_great_hall_of_greasus 				= {"wh3_dlc23_anc_convoy_bones_of_the_maw", "wh3_dlc23_chd_convoy_unique_completed_great_hall_of_greasus", "wh3_main_ogr_inf_maneaters_3"},

		wh3_main_chaos_region_castle_drakenhof 						= {"wh3_dlc23_anc_convoy_crown_of_skulls", "wh3_dlc23_chd_convoy_unique_completed_castle_drakenhof", "wh_main_vmp_mon_varghulf"},
		wh3_main_combi_region_castle_drakenhof 						= {"wh3_dlc23_anc_convoy_crown_of_skulls", "wh3_dlc23_chd_convoy_unique_completed_castle_drakenhof", "wh_main_vmp_mon_varghulf"},

		wh3_main_chaos_region_the_palace_of_ruin 					= {"wh3_dlc23_anc_convoy_everchanging_shield", "wh3_dlc23_chd_convoy_unique_completed_the_palace_of_ruin", "wh_main_chs_mon_giant"},
		wh3_main_combi_region_black_crag 							= {"wh3_dlc23_anc_convoy_everchanging_shield", "wh3_dlc23_chd_convoy_unique_completed_black_crag", "wh_main_chs_mon_giant"},

		wh3_main_chaos_region_bay_of_blades 						= {"wh3_dlc23_anc_convoy_everlasting_glacier", "wh3_dlc23_chd_convoy_unique_completed_bay_of_blades", "wh_dlc08_nor_mon_war_mammoth_0"},
		wh3_main_combi_region_bay_of_blades 						= {"wh3_dlc23_anc_convoy_everlasting_glacier", "wh3_dlc23_chd_convoy_unique_completed_bay_of_blades", "wh_dlc08_nor_mon_war_mammoth_0"},

		wh3_main_chaos_region_the_volary 							= {"wh3_dlc23_anc_convoy_mirror_blade", "wh3_dlc23_chd_convoy_unique_completed_the_volary", "wh3_main_tze_mon_soul_grinder_0"},
		wh3_main_combi_region_the_volary 							= {"wh3_dlc23_anc_convoy_mirror_blade", "wh3_dlc23_chd_convoy_unique_completed_the_volary", "wh3_main_tze_mon_soul_grinder_0"},

		wh3_main_chaos_region_the_silvered_tower_of_sorcerers 		= {"wh3_dlc23_anc_convoy_obedient_mutant", "wh3_dlc23_chd_convoy_unique_completed_the_silvered_tower_of_sorcerers", "wh_dlc01_chs_mon_dragon_ogre_shaggoth"},
		wh3_main_combi_region_the_silvered_tower_of_sorcerers 		= {"wh3_dlc23_anc_convoy_obedient_mutant", "wh3_dlc23_chd_convoy_unique_completed_the_silvered_tower_of_sorcerers", "wh_dlc01_chs_mon_dragon_ogre_shaggoth"},

		wh3_dlc20_chaos_region_grung_zint 							= {"wh3_dlc23_anc_convoy_orc_shaman", "wh3_dlc23_chd_convoy_unique_completed_grung_zint", "wh_main_grn_mon_arachnarok_spider_0"},
		wh3_main_combi_region_grung_zint 							= {"wh3_dlc23_anc_convoy_orc_shaman", "wh3_dlc23_chd_convoy_unique_completed_grung_zint", "wh_main_grn_mon_arachnarok_spider_0"},

		wh3_main_chaos_region_troll_fjord 							= {"wh3_dlc23_anc_convoy_powerful_berserker", "wh3_dlc23_chd_convoy_unique_completed_troll_fjord", "wh_dlc08_nor_mon_war_mammoth_2"},
		wh3_main_combi_region_troll_fjord 							= {"wh3_dlc23_anc_convoy_powerful_berserker", "wh3_dlc23_chd_convoy_unique_completed_troll_fjord", "wh_dlc08_nor_mon_war_mammoth_2"},

		wh3_main_chaos_region_the_crystal_spires 					= {"wh3_dlc23_anc_convoy_radiating_spike", "wh3_dlc23_chd_convoy_unique_completed_the_crystal_spires", "wh3_dlc20_chs_inf_chosen_msla"},
		wh3_main_combi_region_the_crystal_spires 					= {"wh3_dlc23_anc_convoy_radiating_spike", "wh3_dlc23_chd_convoy_unique_completed_the_crystal_spires", "wh3_dlc20_chs_inf_chosen_msla"},
	
		wh3_dlc23_chaos_region_the_haunted_forest 					= {"wh3_dlc23_anc_convoy_ring_of_thorns", "wh3_dlc23_chd_convoy_unique_completed_the_haunted_forest", "wh_main_vmp_inf_grave_guard_0"},
		wh3_main_combi_region_the_haunted_forest 					= {"wh3_dlc23_anc_convoy_ring_of_thorns", "wh3_dlc23_chd_convoy_unique_completed_the_haunted_forest", "wh_main_vmp_inf_grave_guard_0"},

		wh3_main_combi_region_karond_kar 							= {"wh3_dlc23_anc_convoy_spiked_whip", "wh3_dlc23_chd_convoy_unique_completed_karond_kar", "wh2_main_def_mon_war_hydra"},

		wh3_main_combi_region_wizard_caliphs_palace 				= {"wh3_dlc23_anc_convoy_eternal_servant", "wh3_dlc23_chd_convoy_unique_completed_wizard_caliphs_palace", "wh2_dlc09_tmb_veh_khemrian_warsphinx_0"}
	}
}

-- ancillaries that don't have an associated end region so are awarded at random when a caravan completes
caravans.special_reward_list = {
	wh3_main_chaos = {
		wh3_main_cth_cathay = {
			{"wh3_main_anc_caravan_bejewelled_dagger", "wh3_main_cth_caravan_completed_ind"},
			{"wh3_main_anc_caravan_statue_of_zharr", "wh3_main_cth_caravan_completed_karaz_a_karak"},
			{"wh3_main_anc_caravan_spy_in_court", "wh3_main_cth_caravan_completed_estalia"},
			{"wh2_dlc10_dwf_anc_talisman_the_ankor_chain_caravan", "wh3_main_cth_caravan_completed_karaz_a_karak"},
			{"wh3_main_anc_caravan_grant_of_land", "wh3_main_cth_caravan_completed_ind"}
		}
	},
	wh3_main_combi = {
		wh3_main_cth_cathay = {
			{"wh3_main_anc_caravan_bejewelled_dagger", "wh3_main_cth_caravan_completed_ind"},
			{"wh3_main_anc_caravan_statue_of_zharr", "wh3_main_cth_caravan_completed_karaz_a_karak"},
			{"wh3_main_anc_caravan_spy_in_court", "wh3_main_cth_caravan_completed_estalia"},
			{"wh3_main_anc_caravan_sky_titan_relic", "wh3_main_cth_caravan_completed_ind"},
			{"wh3_main_anc_caravan_frozen_pendant", "wh3_main_cth_caravan_completed_ind"}
		}
	}
}

caravans.deal_duration_mods = {
	-- percentage increase
	[4] =  0,
	[5] =  10,
	[6] =  21,
	[7] =  33,
	[8] =  46,
	[9] =  61,
	[10] = 77,
	[11] = 95,
	[12] = 114,
	[13] = 136,
	[14] = 159
}

caravans.journey_durations = {
	["wh3_main_chaos"] = {
		["wh3_dlc23_chaos_region_the_haunted_forest"]				= 4,
		["wh3_main_chaos_region_titans_notch"]						= 5,
		["wh3_main_chaos_region_castle_drakenhof"]					= 6,
		["wh3_main_chaos_region_the_volary"]						= 7,
		["wh3_dlc20_chaos_region_grung_zint"]						= 8,
		["wh3_main_chaos_region_bay_of_blades"]						= 8,
		["wh3_main_chaos_region_the_crystal_spires"]				= 8,
		["wh3_main_chaos_region_troll_fjord"]						= 9,
		["wh3_main_chaos_region_the_silvered_tower_of_sorcerers"]	= 10,
		["wh3_main_chaos_region_the_palace_of_ruin"]				= 12
	},
	["main_warhammer"] = {
		["wh3_main_combi_region_great_hall_of_greasus"]				= 4,
		["wh3_main_combi_region_the_haunted_forest"]				= 5,
		["wh3_main_combi_region_the_volary"]						= 5,
		["wh3_main_combi_region_castle_drakenhof"]					= 6,
		["wh3_main_combi_region_the_crystal_spires"]				= 6,
		["wh3_main_combi_region_bay_of_blades"]						= 6,
		["wh3_main_combi_region_black_crag"]						= 7,
		["wh3_main_combi_region_grung_zint"]						= 8,
		["wh3_main_combi_region_the_silvered_tower_of_sorcerers"]	= 9,
		["wh3_main_combi_region_troll_fjord"]						= 9,
		["wh3_main_combi_region_wizard_caliphs_palace"]				= 11,
		["wh3_main_combi_region_karond_kar"]						= 14
	}
}

------------------
----FUNCTIONS-----
------------------
function caravans:initialise()
	--Setup
	if not cm:get_saved_value("ivory_road_demand") then 
		self:initalise_end_node_values();
	end	

	if cm:is_new_game() then
		local human_factions = cm:get_human_factions_of_culture("wh3_dlc23_chd_chaos_dwarfs")

		for i = 1, #human_factions do
			local current_faction = human_factions[i]
			caravans.events_cooldown[current_faction] = {
				["wh3_dlc23_dilemma_chd_convoy_cathay_caravan"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_dwarfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_far_from_home"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_hobgoblin_tribute"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_hungry_daemons"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_localised_elfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_offence_or_defence"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_ogre_mercenaries"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_1"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_2"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_3_a"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_power_overwhelming"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_quick_way_down"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_rats_in_a_tunnel"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_redeadify"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_the_ambush"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_the_guide"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_trading_dark_elfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_training_camp"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_way_of_lava"] = 0
			}
		end
	end

	--Listeners
	core:add_listener(
		"convoy_event_update",
		"WorldStartRound",
		true,
		function()
			for _, faction_cooldowns in pairs(caravans.events_cooldown) do
				for dilemma_key, cooldown in pairs(faction_cooldowns) do
					if cooldown > 0 then
						faction_cooldowns[dilemma_key] = cooldown - 1
					end
				end
			end

			-- select a random caravan for each human player to trigger an event for
			local caravans_system = cm:model():world():caravans_system()
			local human_factions = cm:get_human_factions()

			for i = 1, #human_factions do
				local caravans = caravans_system:faction_caravans_by_key(human_factions[i])
				if not caravans:is_null_interface() then
					local num_caravans = caravans:number_of_active_caravans()

					if num_caravans > 0 then
						local chosen_caravan = cm:random_number(num_caravans)
						local chosen_caravan_cqi = caravans:active_caravans():item_at(chosen_caravan - 1):caravan_force():command_queue_index()
						cm:set_saved_value("chosen_caravan_master_" .. human_factions[i], chosen_caravan_cqi)
					end
				end
			end

			self:adjust_end_node_values_for_demand();
		end,
		true
	);

	core:add_listener(
		"caravan_waylay_query",
		"QueryShouldWaylayCaravan",
		function(context)
			local faction = context:faction()
			return faction:is_human() and context:caravan():caravan_force():command_queue_index() == cm:get_saved_value("chosen_caravan_master_" .. faction:name())
		end,
		function(context)
			if self:event_handler(context) == false then
				out.design("Caravan not valid for event");
			end
		end,
		true
	);

	core:add_listener(
		"caravan_waylaid",
		"CaravanWaylaid",
		true,
		function(context)
			local event_name_formatted = context:context();
			local caravan_handle = context:caravan();
			local event_key = self:read_out_event_key(event_name_formatted);
			
			local culture = caravan_handle:caravan_force():faction():culture()
			local events = self.event_tables[culture]
			--call the action side of the event
			events[event_key][2](event_name_formatted,caravan_handle);
		end,
		true
	);

	core:add_listener(
		"add_inital_force",
		"CaravanRecruited",
		true,
		function(context)
			out.design("*** Caravan recruited ***");
			if context:caravan():caravan_force():unit_list():num_items() < 2 then
				local caravan = context:caravan();
				self:add_inital_force(caravan);
				cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
			end;
		end,
		true
	);

	core:add_listener(
		"add_inital_bundles",
		"CaravanSpawned",
		true,
		function(context)
			out.design("*** Caravan deployed ***");
			local caravan = context:caravan();
			self:set_stance(caravan);
			cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		end,
		true
	);

	core:add_listener(
		"caravan_finished",
		"CaravanCompleted",
		true,
		function(context)
			-- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
			local node = context:complete_position():node()
			local region_name = node:region_key()
			local region = node:region_data():region()
			local region_owner = region:owning_faction();
			
			out.design("Caravan (player) arrived in: "..region_name)
			
			local faction = context:faction()
			local faction_key = faction:name();
			local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
			local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
			cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
			cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
			core:trigger_event("ScriptEventCaravanCompleted", context);
			
			if faction:is_human() then
				self:reward_item_check(faction, region_name, context:caravan_master())
			end
			
			-- faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
			local bv = cm:get_factions_bonus_value(faction, "chd_convoy_trade_tariff_scripted")
			if bv > 0 then
				local trade_modifier = cm:get_saved_value("convoy_trade_modifier_" .. faction_key) or 0
				trade_modifier = trade_modifier + bv
				cm:set_saved_value("convoy_trade_modifier_" .. faction_key, trade_modifier)
				local trade_effect = "wh_main_effect_economy_trade_tariff_mod"
				local trade_effect_bundle_key = "wh3_dlc23_effect_chd_convoy_trade_tariff_scripted_bundle"
				local trade_effect_bundle = cm:create_new_custom_effect_bundle(trade_effect_bundle_key)

				trade_effect_bundle:add_effect(trade_effect, "faction_to_faction_own_unseen", trade_modifier)
				trade_effect_bundle:set_duration(0)

				if faction:has_effect_bundle(trade_effect_bundle_key) then
					cm:remove_effect_bundle(trade_effect_bundle_key, faction_key)
				end
				
				cm:apply_custom_effect_bundle_to_faction(trade_effect_bundle, faction)
			end
				
			if not region_owner:is_null_interface() then
				local region_owner_key = region_owner:name()
				cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

				if region_owner:is_human() and faction_key ~= region_owner_key then
					local incident_key = "wh3_main_cth_caravan_completed_received"
					
					if faction:culture() == "wh3_dlc23_chd_chaos_dwarfs" then
						incident_key = "wh3_dlc23_chd_convoy_completed_received"
					end
					
					cm:trigger_incident_with_targets(
						region_owner:command_queue_index(),
						incident_key,
						0,
						0,
						0,
						0,
						region:cqi(),
						0
					)
				end
			end
			
			--Reduce demand
			local cargo = context:caravan():cargo()
			local value = math.floor(-cargo/18)
			local faction = self.culture_to_faction[context:faction():culture()];
			cm:callback(function()self:adjust_end_node_value(region_name, value, "add", faction) end, 5);
						
		end,
		true
	);

	core:add_listener(
		"caravan_master_heal",
		"CaravanMoved",
		function(context)
			return not context:caravan():is_null_interface();
		end,
		function(context)
			--Heal Lord
			cm:set_unit_hp_to_unary_of_maximum(context:caravan_master():character():military_force():unit_list():item_at(0), 1)
			
			--Spread out caravans
			local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
			local x,y = cm:find_valid_spawn_location_for_character_from_character(
				context:faction():name(),
				caravan_lookup,
				true,
				cm:random_number(15,5)
			)

			cm:teleport_to(caravan_lookup, x, y);
		end,
		true
	);

	core:add_listener(
		"cleanup_caravan_battle",
		"BattleCompleted",
		function(context)
			return self.enemy_force_cqi > 0
		end,
		function()
			self:cleanup_post_battle()
		end,
		true
	)

	core:add_listener(
		"convoy_refresh_values",
		"ActiveContractRefreshEvent",
		function(context)
			return context:faction():culture() == "wh3_dlc23_chd_chaos_dwarfs"
		end,
		function(context)
			local region = context:position():node():region_key()
			local culture = context:faction():culture()

			if(culture == "wh3_dlc23_chd_chaos_dwarfs") then
				caravans:adjust_end_node_value(region, nil, "duration", "chaos_dwarfs", true)
			end
		end,
		true
	);

	core:add_listener(
		"new_contracts_update",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:is_human() and faction:culture() == "wh3_dlc23_chd_chaos_dwarfs"
		end,
		function(context)
			local turn = cm:model():turn_number();
			local faction_key = context:faction():name()
			if turn == 5 then
				cm:trigger_incident(faction_key, "wh3_dlc23_chd_convoy_unlocked", true);
			elseif (turn % 10 == 0) then
				cm:trigger_incident(faction_key, "wh3_dlc23_chd_convoy_new_contracts", true);
			end
		end,
		true
	);

end
--Functions

function caravans:event_handler(context)
	
	--package up some world state
	--generate an event
	
	local caravan_master = context:caravan_master();
	local faction = context:faction();
	
	if context:from():is_null_interface() or context:to():is_null_interface() then
		return false
	end;
	
	local from_node = context:caravan():position():network():node_for_position(context:from());
	local to_node = context:caravan():position():network():node_for_position(context:to());
	
	local route_segment = context:caravan():position():network():segment_between_nodes(
	from_node, to_node);
	
	if route_segment:is_null_interface() then
		return false
	end
	
	local list_of_regions = route_segment:regions();
	
	local num_regions;
	local event_region;
	--pick a region from the route at random - don't crash the game if empty
	if list_of_regions:is_empty() ~= true then
		num_regions = list_of_regions:num_items()
		event_region = list_of_regions:item_at(cm:random_number(num_regions-1,0)):region();
	else
		out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
		out.design("*** Rest of this script will fail ***")
	end;
	
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		table.insert(bandit_list_of_regions,list_of_regions:item_at(i):region():name())
		
		if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
			event_region=list_of_regions:item_at(i):region()
		end;
	end
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	local contextual_event, is_battle = self:generate_event(conditions);
	
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	end;
	
end

function caravans:generate_event(conditions)

	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;

	local culture = conditions.faction:culture()
	local events = caravans.event_tables[culture]
	
	--build table for weighted roll
	for key, val in pairs(events) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;

	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
						contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	if cm:tol_campaign_key() then
		contextual_event_name = nil;
	end;
	
	return contextual_event_name, is_battle
end;

function caravans:read_out_event_key(event_string)
	
	local t = {}
	for v in string.gmatch(event_string, "(%a+)?") do
		table.insert(t, v)
	end
	
	return(t[1])
end;

function caravans:read_out_event_params(event_string,num_args)
	
	local arg_table = {};
	
	local i = 0;
	for v in string.gmatch(event_string, "[_%w]+*") do
		i=i+1;
		
		local substring = v:sub(1, #v - 1)
		arg_table[i] = substring;
		
	end
	
	return(arg_table)
end;

function caravans:find_battle_coords_from_region(faction_key, region_key)
	
	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
		faction_key,
		region_key,
		false,
		true,
		20
		);
	
	if cm:get_campaign_name() == "wh3_main_chaos" then

		local no_spawn_list = self:build_list_of_nodes();
			
		if self:is_pair_in_list({x,y},no_spawn_list) then
			x,y = cm:find_valid_spawn_location_for_character_from_settlement(
				faction_key,
				region_key,
				false,
				true,
				30
				);
		end

	end
	
	return x,y
end

function caravans:spawn_caravan_battle_force(caravan, attacking_force, region, is_ambush, immediate_battle, optional_faction)
	local enemy_faction = optional_faction or "wh3_main_ogr_ogre_kingdoms_qb1"
	local caravan_faction = caravan:caravan_force():faction();
	local enemy_force_cqi = 0;
	
	local x,y = self:find_battle_coords_from_region(caravan_faction:name(), region);
	
	--spawn enemy army
	--ideal solution is that the owner of the force are the regions rebel faction
	cm:create_force(
		enemy_faction,
		attacking_force,
		region,
		x,
		y,
		true,
		function(char_cqi,force_cqi)
			self.enemy_force_cqi = force_cqi

			--suppress events
			cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
			cm:disable_event_feed_events(true, "", "", "character_dies_battle");
			cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
			cm:force_declare_war(enemy_faction, caravan_faction:name(), false, false);	
			cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
			cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
			cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
		end
	);

	if immediate_battle == true then
		if cm:is_multiplayer() then
			self:create_caravan_battle(caravan, self.enemy_force_cqi, x, y, is_ambush)
		else
			cm:trigger_transient_intervention(
				"spawn_caravan_battle_force",
				function(inv)
					self:create_caravan_battle(caravan, self.enemy_force_cqi, x, y, is_ambush)
					inv:complete()
				end
			);
		end
	elseif immediate_battle == false then 
		return self.enemy_force_cqi, x, y
	end
end

function caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
	local caravan_faction = caravan:caravan_force():faction();
	
	--find caravan army spawn
	--find move coords for caravan
	local caravan_x, caravan_y = cm:find_valid_spawn_location_for_character_from_position(
		caravan_faction:name(),
		x,
		y,
		false
	);
	
	local caravan_teleport_cqi = caravan:caravan_force():general_character():command_queue_index();
	local caravan_lookup = cm:char_lookup_str(caravan_teleport_cqi)
	
	--move the carvan here
	cm:teleport_to(caravan_lookup,  caravan_x,  caravan_y);
	
	--add callack to delete enemy force after battle
	local uim = cm:get_campaign_ui_manager();
	uim:override("retreat"):lock();
	
	--attack of opportunity
	cm:force_attack_of_opportunity(
		enemy_force_cqi, 
		caravan:caravan_force():command_queue_index(),
		is_ambush
	);
end;

--Handles battles for dilemmas

function caravans:attach_battle_to_dilemma(dilemma_name, caravan, attacking_force, is_ambush, enemy_faction, target_region, custom_option, halt_choice)
	--Create the enemy force
	local enemy_force_cqi = 0;
	local x = nil;
	local y = nil;
	
	if attacking_force then
		enemy_force_cqi, x, y = self:spawn_caravan_battle_force(caravan, attacking_force[1], target_region, is_ambush, false, enemy_faction)
	end

	core:add_listener(
		"cth_DilemmaChoiceMadeEvent_" .. caravan:caravan_master():character():faction():name(),
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == dilemma_name
		end,
		function(context)
			local choice = context:choice();

			-- fight the battle if the player chooses, otherwise clean up the spawned army
			if attacking_force and (choice == attacking_force[2] or attacking_force[2] == -1) and enemy_force_cqi > 0 then
				self:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
			else
				self:cleanup_post_battle();
			end

			-- run the scripted payload (e.g. extra move)
			if custom_option and (choice == custom_option[2] or custom_option[2] == -1) then
				custom_option[1]();
			end

			-- always move the caravan unless a payload halts it
			if not halt_choice or choice ~= halt_choice then
				cm:move_caravan(caravan);
			end
		end,
		false
	);
	
	return enemy_force_cqi
end;

function caravans:cleanup_post_battle()
	uim:override("retreat"):unlock()

	if self.enemy_force_cqi and self.enemy_force_cqi > 0 then
		local mf = cm:get_military_force_by_cqi(self.enemy_force_cqi)

		if mf then
			cm:kill_all_armies_for_faction(mf:faction())
		end
	end

	cm:callback(
		function()
			cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed")
			cm:disable_event_feed_events(false, "", "", "character_dies_battle")
		end,
		0.2
	)

	self.enemy_force_cqi = 0
end

function caravans:add_inital_force(caravan)
	local commander = caravan:caravan_force():general_character()
	local lord_str = cm:char_lookup_str(commander:command_queue_index());
	local innate_skill = commander:background_skill()

	if self.traits_to_units[innate_skill] then
		local unit_list = self.traits_to_units[innate_skill]
		
		for i = 1, #unit_list do
			local unit_to_add = unit_list[i]
			local add_xp = false
			
			if is_table(unit_to_add) then
				unit_to_add = unit_to_add[1]
				add_xp = true
			end
			
			local units_added = cm:grant_unit_to_character(lord_str, unit_to_add, true, 1)
			
			if add_xp then
				for _, unit in model_pairs(units_added) do
					cm:add_experience_to_unit(unit, unit_list[i][2])
				end
			end
		end
	else
		out("*** Unknown Caravan Master ??? ***")
	end
end

function caravans:set_stance(caravan)
	local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
	
	cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
end;

function caravans:initalise_end_node_values()
	--randomise the end node values
	local end_nodes = {}
	local campaign_name = cm:get_campaign_name();
	
	if campaign_name == "main_warhammer" then
		end_nodes.cathay = {
			["wh3_main_combi_region_frozen_landing"]		= cm:random_number(75, 25),
			["wh3_main_combi_region_myrmidens"]				= cm:random_number(75, 25),
			["wh3_main_combi_region_erengrad"]				= cm:random_number(75, 25),
			["wh3_main_combi_region_karaz_a_karak"]			= cm:random_number(150, 60),
			["wh3_main_combi_region_castle_drakenhof"]		= cm:random_number(150, 60),
			["wh3_main_combi_region_altdorf"]				= cm:random_number(150, 60),
			["wh3_main_combi_region_marienburg"]			= cm:random_number(150, 60),
			["wh3_main_combi_region_barak_varr"]			= cm:random_number(150, 60),
			["wh3_main_combi_region_gisoreux"]				= cm:random_number(150, 60),
			["wh3_main_combi_region_nuln"]					= cm:random_number(150, 60)
		};
		end_nodes.chaos_dwarfs = {
			["wh3_main_combi_region_great_hall_of_greasus"]				= 0,
			["wh3_main_combi_region_the_haunted_forest"]				= 0,
			["wh3_main_combi_region_the_volary"]						= 0,
			["wh3_main_combi_region_castle_drakenhof"]					= 0,
			["wh3_main_combi_region_the_crystal_spires"]				= 0,
			["wh3_main_combi_region_bay_of_blades"]						= 0,
			["wh3_main_combi_region_black_crag"]						= 0,
			["wh3_main_combi_region_grung_zint"]						= 0,
			["wh3_main_combi_region_the_silvered_tower_of_sorcerers"]	= 0,
			["wh3_main_combi_region_troll_fjord"]						= 0,
			["wh3_main_combi_region_wizard_caliphs_palace"]				= 0,
			["wh3_main_combi_region_karond_kar"]						= 0
		};
	elseif campaign_name == "wh3_main_chaos"   then
		end_nodes.cathay = {
			["wh3_main_chaos_region_frozen_landing"]		= cm:random_number(75, 25),
			["wh3_main_chaos_region_shattered_stone_bay"]	= cm:random_number(75, 25),
			["wh3_main_chaos_region_novchozy"]				= cm:random_number(75, 25),
			["wh3_main_chaos_region_erengrad"]				= cm:random_number(150, 60),
			["wh3_main_chaos_region_castle_drakenhof"]		= cm:random_number(150, 60),
			["wh3_main_chaos_region_altdorf"]				= cm:random_number(150, 60),
			["wh3_main_chaos_region_marienburg"]			= cm:random_number(150, 60),
			["wh3_dlc23_chaos_region_the_haunted_forest"]	= cm:random_number(150, 60),
		};
		end_nodes.chaos_dwarfs = {
			["wh3_dlc23_chaos_region_the_haunted_forest"]				= 0,
			["wh3_main_chaos_region_titans_notch"]						= 0,
			["wh3_main_chaos_region_castle_drakenhof"]					= 0,
			["wh3_main_chaos_region_the_volary"]						= 0,
			["wh3_dlc20_chaos_region_grung_zint"]						= 0,
			["wh3_main_chaos_region_bay_of_blades"]						= 0,
			["wh3_main_chaos_region_the_crystal_spires"]				= 0,
			["wh3_main_chaos_region_troll_fjord"]						= 0,
			["wh3_main_chaos_region_the_silvered_tower_of_sorcerers"]	= 0,
			["wh3_main_chaos_region_the_palace_of_ruin"]				= 0
		};
	end
	
	--save them
	cm:set_saved_value("ivory_road_demand", end_nodes);
	local temp_end_nodes = self:safe_get_saved_value_ivory_road_demand()
	
	--apply the effect bundles
	for _, v in ipairs(self.cultures_to_destination) do
		for _, val in ipairs(self.destinations_key[campaign_name][v]) do
			if v == "cathay" then
				self:adjust_end_node_value(val, temp_end_nodes[v][val], "replace", v)
			elseif v == "chaos_dwarfs" then
				self:adjust_end_node_value(val, temp_end_nodes[v][val], "duration", v, true)
			end
		end
	end
end

function caravans:adjust_end_node_values_for_demand()
	local campaign_name = cm:get_campaign_name();
	for _, v in ipairs(self.cultures_to_destination) do
		for _, val in ipairs(self.destinations_key[campaign_name][v]) do
			self:adjust_end_node_value(val, 2, "add", v)
		end
	end
end

function caravans:adjust_end_node_value(region_name, value, operation, culture_name, apply_variance)
	local region = cm:get_region(region_name);
	if not region then
		script_error("Could not find region " ..region_name.. " for caravan script")
		return false
	end
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);

	if operation == "replace" then
		local temp_end_nodes = self:safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[culture_name][region_name]=value;
		cm:set_saved_value("ivory_road_demand", temp_end_nodes);
		
	elseif operation == "add" then
		local temp_end_nodes = self:safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes[culture_name];

		if old_value == nil then
			script_error("End node values do not exist - how can this be?")
			return 0;
		end
		
		old_value = old_value[region_name]

		if old_value == nil then
			out.design("Save file does not have value for region " .. region_name .. " - was it added after this save file was created?")
			return 0;
		end

		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[culture_name][region_name]=new_value;
		cm:set_saved_value("ivory_road_demand", temp_end_nodes);
	elseif operation == "duration" then
		local temp_end_nodes = self:safe_get_saved_value_ivory_road_demand()
		local duration = self.journey_durations[cm:get_campaign_name()][region_name]
		local percentage_mod = self.deal_duration_mods[duration]

		if apply_variance then
			-- apply a random variance between 0.9 and 1.2
			variance = cm:random_number(120, 90) / 100
			percentage_mod = math.floor(percentage_mod * variance)
		end

		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", percentage_mod)

		temp_end_nodes[culture_name][region_name] = percentage_mod;
		cm:set_saved_value("ivory_road_demand", temp_end_nodes);
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end

function caravans:safe_get_saved_value_ivory_road_demand()
	
	return cm:get_saved_value("ivory_road_demand");

end		

function caravans:generate_attackers(bandit_threat, force_name)

	local force_non_ogre = 
	{
		daemon_incursion = true,
		daemon_incursion_convoy = true,
		cathay_caravan_army = true,
		skaven_shortcut_army = true,
		dwarf_convoy_army = true,
		hungry_chaos_army = true,
		high_elf_army = true,
		vampire_count_army = true,
		tomb_kings_army = true
	};	
	
	if force_non_ogre[force_name] then

		if cm:turn_number() >= 50 then
			force_name = force_name.."_late"
		end
		
		return random_army_manager:generate_force(force_name, 5, false);
	end

	if bandit_threat < 50 then
			force_name = {"ogre_bandit_low_a","ogre_bandit_low_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 5, false);
		elseif bandit_threat >= 50 and bandit_threat < 70 then
			force_name = {"ogre_bandit_med_a","ogre_bandit_med_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 8, false);
		elseif bandit_threat >= 70 then
			force_name = {"ogre_bandit_high_a","ogre_bandit_high_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 10, false);
	end

end

function caravans:is_pair_in_list(pair, list)
	for i,v in ipairs(list) do
		if (v[1] == pair[1] and v[2] == pair[2]) then
			return true
		end
	end
	return false
end

function caravans:build_list_of_nodes()
	
	local teleporter = cm:model():world():teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos");
	local open_nodes = teleporter:open_nodes()
	local closed_nodes = teleporter:closed_nodes()
	all_nodes = {}
	local n = 0
	local x,y;
	for i=0, closed_nodes:num_items()-1 do n=n+1; x,y = closed_nodes:item_at(i):position(); all_nodes[n]={x,y}; end
	for i=0,   open_nodes:num_items()-1 do n=n+1; x,y =   open_nodes:item_at(i):position(); all_nodes[n]={x,y}; end

	return all_nodes
end

function caravans:reward_item_check(faction, region_key, caravan_master)
	local culture = faction:culture()
	local reward = self.reward_list[culture][region_key]

	-- get a different ancillary if the faction already owns it
	if faction:ancillary_exists(reward[1]) then
		if cm:random_number(5) == 1 then
			local item_list = self.special_reward_list[cm:model():campaign_name_key()][culture]

			if item_list then
				reward = item_list[cm:random_number(#item_list)]

				if faction:ancillary_exists(reward[1]) then return end
			else
				return
			end
		else
			return
		end
	end
	
	local character = caravan_master:character()
	local payload_builder = cm:create_payload();
	
	payload_builder:character_ancillary_gain(character, reward[1], false)
	
	if reward[3] then
		payload_builder:add_unit(character:military_force(), reward[3], 1 + cm:get_factions_bonus_value(faction, "chd_convoy_additional_unit_reward_scripted"), 0)
	end
	
	cm:trigger_custom_incident_with_targets(
		faction:command_queue_index(),
		reward[2],
		true,
		payload_builder,
		0,
		0,
		character:command_queue_index(),
		0,
		0,
		0
	)
end

function caravans:get_best_ogre_faction(self_faction)
	local factions = cm:get_faction(self_faction):factions_met(); --cm:model():world():faction_list();
	local faction = nil;
	local high_score = -500;
	local high_score_faction = nil;
	local max_score = 200
	
	if not factions:is_empty() then
		for i=0, factions:num_items() -1 do
			faction = factions:item_at(i);
			if faction:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and faction:name()~="wh3_main_ogr_ogre_kingdoms_qb1" then
				if faction:diplomatic_standing_with(self_faction) > high_score and faction:diplomatic_standing_with(self_faction) <= max_score then
					high_score = faction:diplomatic_standing_with(self_faction);
					high_score_faction = faction;
				end
			end
		end
	end
	return high_score_faction
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("enemy_force_cqi", caravans.enemy_force_cqi, context);
		cm:save_named_value("events_cooldown", caravans.events_cooldown, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			caravans.enemy_force_cqi = cm:load_named_value("enemy_force_cqi", caravans.enemy_force_cqi, context);
			caravans.events_cooldown = cm:load_named_value("events_cooldown", caravans.events_cooldown, context);
		end;
	end
);