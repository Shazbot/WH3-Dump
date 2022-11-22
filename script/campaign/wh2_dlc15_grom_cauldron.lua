local grom_faction_key = "wh2_dlc15_grn_broken_axe"
local food_trait = "wh2_dlc15_grom_food_collector"
local food_trait_threshold = {0, 4, 8, 12, 15}
local cooked_dish = {}

local blacktoof_required_ingredients_number = 6
local blacktoof_required_recipe_number = 12
local dishcookedhag = false

local ingredients_data = {
	wh2_dlc15_boar = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_1",
		ancillaries_required = {
			wh2_pro09_anc_mount_grn_black_orc_big_boss_war_boar = true,
			wh_main_anc_mount_grn_orc_warboss_war_boar = true,
			wh_main_anc_mount_grn_wizard_orc_shaman_war_boar = true
		}
	},
	wh2_dlc15_goblin = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_2",
		waaagh_unlocks = true
	},
	wh2_dlc15_lion = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_3",
		units_to_defeat = {
			"wh2_dlc15_hef_mon_war_lions_of_chrace_0",
			"wh2_dlc15_hef_mon_war_lions_of_chrace_ror_0",
			"wh2_dlc15_hef_veh_lion_chariot_of_chrace_0",
			"wh2_main_hef_inf_white_lions_of_chrace_0",
			"wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply",
			"wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply",
			"wh_main_emp_cav_demigryph_knights_0",
			"wh_main_emp_cav_demigryph_knights_1",
			"wh2_dlc10_def_mon_feral_manticore_0",
			"wh_dlc03_bst_feral_manticore",
			"wh_dlc06_chs_feral_manticore",
			"wh_dlc08_nor_feral_manticore",
			"wh2_dlc15_hef_cha_alastair_1",
			"wh2_main_hef_cha_alastair_0",
			"wh2_main_hef_cha_alastair_3",
			"wh2_main_hef_cha_alastair_4",
			"wh2_main_hef_cha_alastair_5",
			"wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0",
			"wh_dlc07_brt_cav_royal_hippogryph_knights_0",
			"wh2_dlc16_wef_mon_feral_manticore",
			"wh3_main_ogr_mon_sabretusk_pack_0",
			"wh2_dlc15_hef_cha_eltharion_the_grim_2",	-- mounts
			"wh2_dlc15_hef_cha_prince_6",
			"wh2_dlc15_hef_cha_princess_6",
			"wh_dlc03_emp_cha_boris_todbringer_3",
			"wh_dlc03_emp_cha_wizard_beasts_3",
			"wh_main_emp_cha_general_3",
			"wh_main_emp_cha_karl_franz_1",
			"wh2_dlc10_def_cha_crone_5",
			"wh2_dlc10_def_cha_supreme_sorceress_beasts_4",
			"wh2_dlc10_def_cha_supreme_sorceress_dark_4",
			"wh2_dlc10_def_cha_supreme_sorceress_death_4",
			"wh2_dlc10_def_cha_supreme_sorceress_fire_4",
			"wh2_dlc10_def_cha_supreme_sorceress_shadow_4",
			"wh2_dlc14_def_cha_high_beastmaster_2",
			"wh_dlc01_chs_cha_chaos_lord_10",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_9",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_9",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_9",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_3",
			"wh_dlc01_chs_cha_chaos_sorcerer_shadows_3",
			"wh_dlc01_chs_cha_exalted_hero_10",
			"wh_main_chs_cha_chaos_sorcerer_death_9",
			"wh_main_chs_cha_chaos_sorcerer_fire_9",
			"wh_main_chs_cha_chaos_sorcerer_metal_9",
			"wh2_dlc14_brt_cha_henri_le_massif_3",
			"wh_dlc07_brt_cha_alberic_bordeleaux_3",
			"wh_main_brt_cha_king_louen_leoncoeur_1",
			"wh_main_brt_cha_lord_2",
			"wh2_twa03_def_cha_rakarth_2"
		}
	},
	wh2_dlc15_lizard = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_4",
		units_to_defeat = {
			"wh2_dlc13_lzd_mon_dread_saurian_0",
			"wh2_dlc13_lzd_mon_dread_saurian_1",
			"wh2_dlc13_lzd_mon_dread_saurian_ror_0",
			"wh2_dlc12_lzd_mon_ancient_stegadon_1_nakai",
			"wh2_dlc12_lzd_mon_ancient_stegadon_1",
			"wh2_dlc12_lzd_mon_ancient_stegadon_ror_0",
			"wh2_main_lzd_mon_ancient_stegadon",
			"wh2_main_lzd_mon_stegadon_0",
			"wh2_main_lzd_mon_stegadon_1",
			"wh2_main_lzd_mon_stegadon_blessed_1",
			"wh2_dlc12_lzd_mon_bastiladon_3_nakai",
			"wh2_dlc12_lzd_mon_bastiladon_3",
			"wh2_main_lzd_mon_bastiladon_0",
			"wh2_main_lzd_mon_bastiladon_1",
			"wh2_main_lzd_mon_bastiladon_2",
			"wh2_main_lzd_mon_bastiladon_blessed_2",
			"wh2_main_lzd_mon_carnosaur_0",
			"wh2_main_lzd_mon_carnosaur_blessed_0",
			"wh2_dlc17_dwf_mon_carnosaur_thorek_0",
			"wh2_dlc17_lzd_mon_troglodon_0",
			"wh2_dlc17_lzd_mon_troglodon_ror_0",
			"wh2_dlc12_lzd_cha_skink_chief_red_crested_3",	-- mounts
			"wh2_dlc12_lzd_cha_skink_priest_beasts_4",
			"wh2_dlc12_lzd_cha_skink_priest_heavens_4",
			"wh2_dlc12_lzd_cha_tehenhauin_3",
			"wh2_main_lzd_cha_kroq_gar_1",
			"wh2_main_lzd_cha_lord_mazdamundi_1",
			"wh2_main_lzd_cha_saurus_old_blood_2",
			"wh2_main_lzd_cha_saurus_scar_veteran_2",
			"wh2_main_lzd_cha_skink_chief_2",
			"wh2_main_lzd_cha_skink_chief_3",
			"wh2_main_lzd_cha_skink_priest_beasts_2",
			"wh2_main_lzd_cha_skink_priest_beasts_3",
			"wh2_main_lzd_cha_skink_priest_heavens_2",
			"wh2_main_lzd_cha_skink_priest_heavens_3",
			"wh2_dlc17_lzd_cha_skink_oracle_troglodon_0"
		}
	},
	wh2_dlc15_troll = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_5",
		start_unlocked = true
	},
	wh2_dlc15_bat = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_6",
		units_to_defeat = {
			"wh2_dlc12_lzd_cav_terradon_riders_0_tlaqua",
			"wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua",
			"wh2_dlc12_lzd_cav_terradon_riders_ror_0",
			"wh2_main_lzd_cav_terradon_riders_0",
			"wh2_main_lzd_cav_terradon_riders_1",
			"wh2_main_lzd_cav_terradon_riders_blessed_1",
			"wh2_dlc12_lzd_cav_ripperdactyl_riders_0",
			"wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0",
			"wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0",
			"wh2_dlc13_huntmarshall_veh_obsinite_gyrocopter_0",
			"wh_main_dwf_veh_gyrobomber",
			"wh_main_dwf_veh_gyrocopter_0",
			"wh_main_dwf_veh_gyrocopter_1",
			"wh_main_grn_art_doom_diver_catapult",
			"wh2_dlc12_lzd_cha_tiktaqto_1",	-- mounts
			"wh2_main_lzd_cha_skink_chief_1",
			"wh2_main_lzd_cha_skink_priest_beasts_1",
			"wh2_main_lzd_cha_skink_priest_heavens_1",
			"wh2_dlc12_lzd_cha_skink_chief_red_crested_2",
			"wh2_dlc12_lzd_cha_tehenhauin_2",
			"wh_dlc06_grn_cha_wurrzag_1"
		}
	},
	wh2_dlc15_dragon = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_7",
		units_to_defeat = {
			"wh2_main_hef_mon_moon_dragon",
			"wh2_main_hef_mon_star_dragon",
			"wh2_main_hef_mon_sun_dragon",
			"wh_dlc05_wef_forest_dragon_0",
			"wh2_main_def_mon_black_dragon",
			"wh2_dlc15_grn_mon_wyvern_waaagh_0",
			"wh_dlc08_nor_mon_frost_wyrm_0",
			"wh_dlc08_nor_mon_frost_wyrm_ror_0",
			--mounts
			"wh2_dlc10_def_cha_supreme_sorceress_beasts_5",
			"wh2_dlc10_def_cha_supreme_sorceress_dark_5",
			"wh2_dlc10_def_cha_supreme_sorceress_death_5",
			"wh2_dlc10_def_cha_supreme_sorceress_fire_5",
			"wh2_dlc10_def_cha_supreme_sorceress_shadow_5",
			"wh2_dlc11_def_cha_lokhir_fellheart_1",
			"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_1",
			"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_3",
			"wh2_dlc11_vmp_cha_bloodline_lahmian_lord_3",
			"wh2_dlc11_vmp_cha_bloodline_necrarch_lord_3",
			"wh2_dlc11_vmp_cha_bloodline_von_carstein_lord_3",
			"wh2_dlc15_hef_cha_imrik_2",
			"wh2_dlc15_hef_cha_mage_fire_3",
			"wh2_main_def_cha_dreadlord_4",
			"wh2_main_def_cha_dreadlord_female_4",
			"wh2_main_def_cha_malekith_3",
			"wh2_main_hef_cha_alastar_4",
			"wh2_main_hef_cha_alastar_5",
			"wh2_main_hef_cha_prince_4",
			"wh2_main_hef_cha_prince_5",
			"wh2_main_hef_cha_princess_4",
			"wh2_main_hef_cha_princess_5",
			"wh_dlc01_chs_cha_chaos_lord_2",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_10",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_10",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_10",
			"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_4",
			"wh_dlc05_vmp_cha_red_duke_3",
			"wh_dlc05_wef_cha_female_glade_lord_3",
			"wh_dlc05_wef_cha_glade_lord_3",
			"wh_dlc08_chs_cha_chaos_lord_2_qb",
			"wh_dlc08_nor_cha_kihar_0",
			"wh_main_vmp_cha_mannfred_von_carstein_3",
			"wh_main_vmp_cha_vampire_lord_3",
			"wh2_dlc15_hef_cha_archmage_beasts_4",
			"wh2_dlc15_hef_cha_archmage_death_4",
			"wh2_dlc15_hef_cha_archmage_fire_4",
			"wh2_dlc15_hef_cha_archmage_heavens_4",
			"wh2_dlc15_hef_cha_archmage_high_4",
			"wh2_dlc15_hef_cha_archmage_life_4",
			"wh2_dlc15_hef_cha_archmage_light_4",
			"wh2_dlc15_hef_cha_archmage_metal_4",
			"wh2_dlc15_hef_cha_archmage_shadows_4",
			"wh_main_grn_cha_azhag_the_slaughterer_1",
			"wh_main_grn_cha_orc_warboss_1",
			"wh2_dlc16_wef_cha_sisters_of_twilight_1",
			"wh2_twa03_def_cha_rakarth_3",
			"wh3_main_cth_cha_iron_dragon_0",
			"wh3_main_cth_cha_iron_dragon_1",
			"wh3_main_cth_cha_storm_dragon_0",
			"wh3_main_cth_cha_storm_dragon_1"
		}
	},
	wh2_dlc15_eagle = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_8",
		mission_unlock = "wh3_main_ie_qb_grn_grom_axe_of_grom"
	},
	wh2_dlc15_harpy = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_9",
		subculture_to_sack = "wh2_main_sc_def_dark_elves"
	},
	wh2_dlc15_phoenix = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_10",
		waaagh_elf_trophy_unlocks = true
	},
	wh2_dlc15_clams = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_11",
		cooking_callback = function() cm:treasury_mod(grom_faction_key, cm:random_number(4, 1) * 1000) end,
		dropped_via_sea_encounter = true,
		subculture_to_sack = "wh_main_sc_brt_bretonnia"
	},
	wh2_dlc15_crab = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_12",
		cooking_callback = function() cm:faction_add_pooled_resource(grom_faction_key, "grn_salvage", "looting", 10) end,
		dropped_via_sea_encounter = true,
		subculture_to_sack = "wh2_dlc11_sc_cst_vampire_coast"
	},
	wh2_dlc15_gold_fish = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_13",
		dropped_via_sea_encounter = true,
		subculture_to_sack = "wh_main_sc_emp_empire"
	},
	wh2_dlc15_puffer_fish = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_14",
		cooking_callback = function() cm:add_units_to_faction_mercenary_pool(cm:get_faction(grom_faction_key):command_queue_index(), "wh_dlc06_grn_inf_squig_explosive_0", 5) end,
		dropped_via_sea_encounter = true,
		units_to_defeat = {
			"wh2_dlc11_cst_mon_bloated_corpse_0"
		}
	},
	wh2_dlc15_tentacle = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_15",
		dropped_via_sea_encounter = true,
		subculture_to_sack = "wh_dlc08_sc_nor_norsca"
	},
	wh2_dlc15_glowing = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_16",
		heroes_to_rank_up = {
			wh_main_grn_goblin_great_shaman = true,
			wh_main_grn_night_goblin_shaman = true,
			wh2_dlc15_grn_goblin_great_shaman_raknik = true
		}
	},
	wh2_dlc15_green = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_17",
		cooking_callback = function() cm:faction_add_pooled_resource(grom_faction_key, "grn_waaagh", "wh2_dlc15_resource_factor_waaagh_other", 5) end,
		mission_unlock = "wh2_dlc15_grn_grom_black_toof_1"
	},
	wh2_dlc15_indigo = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_18",
		heroes_to_rank_up = {
			wh_main_grn_orc_shaman = true
		}
	},
	wh2_dlc15_pepper = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_19",
		units_to_recruit = {
			wh_main_grn_inf_night_goblin_fanatics = true,
			wh_main_grn_inf_night_goblin_fanatics_1 = true
		}
	},
	wh2_dlc15_stinky = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_20",
		heroes_to_rank_up = {
			wh2_dlc15_grn_river_troll_hag = true
		}
	},
	wh2_dlc15_ale = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_21",
		subculture_to_sack = "wh_main_sc_dwf_dwarfs"
	},
	wh2_dlc15_discharge = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_22",
		units_to_recruit = {
			wh2_dlc15_grn_mon_river_trolls_ror_0 = true
		}
	},
	wh2_dlc15_ectoplasm = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_23",
		units_to_defeat = {
			"wh_main_vmp_cha_banshee",
			"wh_main_vmp_inf_cairn_wraiths",
			"wh2_dlc09_tmb_cav_hexwraiths",
			"wh_main_vmp_cav_hexwraiths",
			"wh_dlc04_vmp_cav_chillgheists_0",
			"wh2_dlc11_cst_inf_syreens",
			"wh_dlc04_vmp_veh_mortis_engine_0",
			"wh_dlc04_vmp_veh_claw_of_nagash_0",
			"wh2_dlc09_tmb_art_casket_of_souls_0",
			"wh2_dlc09_tmb_cha_khatep_3",
			"wh2_dlc11_cst_cha_cylostra_direfin_0",
			"wh2_dlc11_cst_cha_cylostra_direfin_1",
			"wh_dlc07_brt_cha_green_knight_0",
			"wh2_dlc11_cst_cha_damned_paladin_0",
			"wh2_dlc11_cst_cha_damned_paladin_1",
			"wh_dlc06_dwf_cha_master_engineer_ghost_0",
			"wh_dlc06_dwf_cha_runesmith_ghost_0",
			"wh_dlc06_dwf_cha_thane_ghost_0",
			"wh_dlc06_dwf_cha_thane_ghost_1",
			"wh2_dlc11_cst_inf_deck_gunners_ror_0",
			"wh2_dlc09_tmb_inf_nehekhara_warriors_ror",
			"wh2_dlc11_cst_cha_mourngul_haunter",
			"wh2_dlc11_cst_mon_mournguls_0",
			"wh2_dlc11_cst_mon_mournguls_ror_0",
			"wh2_dlc17_dwf_cha_thane_ghost_2",
			"wh2_dlc16_wef_cav_great_stag_knights_ror_0",
			"wh3_main_ksl_mon_elemental_bear_0"
		}
	},
	wh2_dlc15_milk = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_24",
		units_to_defeat = {
			"wh_dlc03_bst_inf_centigors_0",
			"wh_dlc03_bst_inf_centigors_1",
			"wh_dlc03_bst_inf_centigors_2",
			"wh_pro04_bst_inf_centigors_ror_0",
			"wh_dlc01_chs_mon_dragon_ogre", 
			"wh_dlc01_chs_mon_dragon_ogre_shaggoth",
			"wh_pro04_chs_mon_dragon_ogre_ror_0",
			"wh2_dlc09_tmb_mon_necrosphinx_0",
			"wh2_dlc09_tmb_mon_necrosphinx_ror",
			"wh_dlc03_bst_mon_chaos_spawn_0",
			"wh_main_chs_mon_chaos_spawn",
			"wh_pro04_chs_mon_chaos_spawn_ror_0",
			"wh3_main_kho_mon_spawn_of_khorne_0",
			"wh3_main_nur_mon_spawn_of_nurgle_0",
			"wh3_main_sla_mon_spawn_of_slaanesh_0",
			"wh3_main_tze_mon_spawn_of_tzeentch_0",
			"wh2_dlc16_wef_mon_zoats",
			"wh2_dlc16_wef_mon_zoats_ror_0",
			"wh2_dlc17_bst_inf_centigors_ror_1"
		}
	},
	wh2_dlc15_yolk = {
		merchant_dilemma = "wh2_dlc15_dilemma_food_merchant_25",
		cooking_callback = function() cm:add_units_to_faction_mercenary_pool(cm:get_faction(grom_faction_key):command_queue_index(), "wh2_dlc15_grn_cav_forest_goblin_spider_riders_waaagh_0", 5) end,
		units_to_recruit = {
			wh_main_grn_mon_arachnarok_spider_0 = true,
			wh2_dlc15_grn_mon_arachnarok_spider_waaagh_0 = true
		}
	}
}

local recipe_index = {
	"wh2_dlc15_food_dish_1",
	"wh2_dlc15_food_dish_2",
	"wh2_dlc15_food_dish_3",
	"wh2_dlc15_food_dish_4",
	"wh2_dlc15_food_dish_5",
	"wh2_dlc15_food_dish_6",
	"wh2_dlc15_food_dish_7",
	"wh2_dlc15_food_dish_8",
	"wh2_dlc15_food_dish_9",
	"wh2_dlc15_food_dish_10"
}

local secret_recipe_index = {
	"wh2_dlc15_food_special_dish_1",
	"wh2_dlc15_food_special_dish_2",
	"wh2_dlc15_food_special_dish_3",
	"wh2_dlc15_food_special_dish_4",
	"wh2_dlc15_food_special_dish_5"
}

-- completing blacktoof mission unlocks a random secret recipe
local blacktoof_missions = {
	wh2_dlc15_grn_grom_black_toof_3_2 = true,
	wh2_dlc15_grom_blacktoof_prophecy_0 = true,
	wh2_dlc15_grom_blacktoof_prophecy_1 = true,
	wh2_dlc15_grom_blacktoof_prophecy_2 = true
}

-- chance of unlocking an ingredient from a sea encounter
local food_sea_encounter_chance = 50

-- number of turns before the merchant is spawned
local merchant_turns_interval = 10

-- number of turns before ai cooks and grom grows/gains trait
local ai_cook_recipe_turns_interval = 15
local ai_add_trait_turns_interval = 40

local merchant_dilemma_all_ingredients = "wh2_dlc15_dilemma_food_merchant_all_unlocked"

local food_challenge_mission_text_prefix = "wh2_dlc15_objective_override_grom_food_merchant_"

-- grouped by difficulty (easy, medium, hard)
local food_challenge_ids = {{7, 8, 9}, {13, 14, 15, 16, 17}, {1, 2, 3, 4}}

local food_challenge_rewards = {
	{"effect_bundle{bundle_key wh2_dlc15_grom_increase_cooking_slot_1_dummy;turns 0;}", "money 3000"},
	{"effect_bundle{bundle_key wh2_dlc15_grom_increase_cooking_slot_2_dummy;turns 0;}", "money 3000"},
	{"faction_pooled_resource_transaction{resource grn_salvage;factor wh2_dlc12_resource_factor_loot;amount 150;}", "money 5000"}
}

local food_challenge_requirements = {
	["wh2_dlc15_objective_override_grom_food_merchant_1"] = {ingredients = {"wh2_dlc15_bat"}, recipes = {"wh2_dlc15_food_dish_1", "wh2_dlc15_food_dish_3"}},
	["wh2_dlc15_objective_override_grom_food_merchant_2"] = {ingredients = {"wh2_dlc15_boar", "wh2_dlc15_lion"}, recipes = {"wh2_dlc15_food_dish_7"}},
	["wh2_dlc15_objective_override_grom_food_merchant_3"] = {ingredients = {"wh2_dlc15_pepper", "wh2_dlc15_stinky"}, recipes = {"wh2_dlc15_food_dish_8"}},
	["wh2_dlc15_objective_override_grom_food_merchant_4"] = {ingredients = {"wh2_dlc15_clams", "wh2_dlc15_gold_fish", "wh2_dlc15_tentacle", "wh2_dlc15_milk"}, recipes = {"wh2_dlc15_food_dish_9"}},
	["wh2_dlc15_objective_override_grom_food_merchant_7"] = {recipes = {"wh2_dlc15_food_dish_2", "wh2_dlc15_food_special_dish_5"}},
	["wh2_dlc15_objective_override_grom_food_merchant_8"] = {recipes = {"wh2_dlc15_food_dish_7", "wh2_dlc15_food_dish_9"}},
	["wh2_dlc15_objective_override_grom_food_merchant_9"] = {recipes = {"wh2_dlc15_food_dish_4", "wh2_dlc15_food_dish_6", "wh2_dlc15_food_special_dish_2", "wh2_dlc15_food_special_dish_3"}},
	["wh2_dlc15_objective_override_grom_food_merchant_13"] = {recipes = {"wh2_dlc15_food_special_dish_2", "wh2_dlc15_food_special_dish_4"}},
	["wh2_dlc15_objective_override_grom_food_merchant_14"] = {recipes = {"wh2_dlc15_food_special_dish_1", "wh2_dlc15_food_special_dish_2", "wh2_dlc15_food_special_dish_3", "wh2_dlc15_food_special_dish_5"}},
	["wh2_dlc15_objective_override_grom_food_merchant_15"] = {recipes = {"wh2_dlc15_food_special_dish_1", "wh2_dlc15_food_special_dish_4"}},
	["wh2_dlc15_objective_override_grom_food_merchant_16"] = {recipes = {"wh2_dlc15_food_special_dish_1", "wh2_dlc15_food_special_dish_3", "wh2_dlc15_food_special_dish_4", "wh2_dlc15_food_special_dish_5"}},
	["wh2_dlc15_objective_override_grom_food_merchant_17"] = {recipes = {"wh2_dlc15_food_special_dish_2", "wh2_dlc15_food_special_dish_3", "wh2_dlc15_food_special_dish_5"}}
}

-- track the active food challenge
local current_food_challenge = {
	is_active = false,
	objective = -1,
	id = 1
}

function add_grom_food_listeners()
	out("#### Adding Grom Cauldron Listeners ####")
	
	local faction_interface = cm:get_faction(grom_faction_key)
	
	local is_new_game = cm:is_new_game()
	
	if is_new_game then
		cm:force_add_trait(cm:char_lookup_str(faction_interface:faction_leader()), food_trait, true)
	end
	
	if not faction_interface:is_human() then
		cm:add_turn_countdown_event(grom_faction_key, ai_cook_recipe_turns_interval, "ScriptEventAIGromCooksRecipe")
		cm:add_turn_countdown_event(grom_faction_key, ai_add_trait_turns_interval, "ScriptEventAIGromIncreasesTrait")
		
		core:add_listener(
			"ai_grom_cooks_recipe",
			"ScriptEventAIGromCooksRecipe",
			true,
			function()
				if not faction_interface:is_dead() then
					cm:force_cook_recipe(faction_interface, recipe_index[cm:random_number(#recipe_index)], false)
				end
				
				cm:add_turn_countdown_event(grom_faction_key, ai_cook_recipe_turns_interval, "ScriptEventAIGromCooksRecipe")
			end,
			true
		)
		
		core:add_listener(
			"ai_grom_increases_trait",
			"ScriptEventAIGromIncreasesTrait",
			true,
			function()
				if not faction_interface:is_dead() and faction_interface:has_faction_leader() then
					cm:force_add_trait(cm:char_lookup_str(faction_interface:faction_leader()), food_trait, true)
				end
				
				cm:add_turn_countdown_event(grom_faction_key, ai_add_trait_turns_interval, "ScriptEventAIGromIncreasesTrait")
			end,
			true
		)
		
		return -- ignore the player-specific listeners
	end
	
	if is_new_game then
		cm:add_turn_countdown_event(grom_faction_key, merchant_turns_interval, "ScriptEventSpawnGromFoodMerchant")
	end
	
	-- resend the cooked dish to UI
	local component = find_uicomponent(core:get_ui_root(), "grom_goals")
	if component then
		for i = 1, #cooked_dish do
			component:InterfaceFunction("AddCookedRecipe", cooked_dish[i])
		end
	end
	
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(faction_interface)
	
	for ingredient, data in pairs(ingredients_data) do
		if not cooking_interface:is_ingredient_unlocked(ingredient) then
			if data.start_unlocked then
				unlock_ingredient(ingredient)
			end
			
			if data.ancillaries_required then
				core:add_listener(
					"ingredient_ancillary_" .. ingredient,
					"CharacterAncillaryGained",
					function(context)
						return context:character():faction():name() == grom_faction_key and data.ancillaries_required[context:ancillary()]
					end,
					function()
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.waaagh_unlocks then
				core:add_listener(
					"ingredient_waaagh_" .. ingredient,
					"PlayerWaghEndedSuccessful",
					function(context)
						return context:faction():name() == grom_faction_key
					end,
					function()
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.mission_unlock then
				core:add_listener(
					"ingredient_mission_" .. ingredient,
					"MissionSucceeded",
					function(context)
						return context:faction():name() == grom_faction_key and context:mission():mission_record_key() == data.mission_unlock
					end,
					function()
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.waaagh_elf_trophy_unlocks then
				core:add_listener(
					"ingredient_waaagh_elf_trophy_" .. ingredient,
					"PlayerGainedWaghElfTrophy",
					function(context)
						return context:faction():name() == grom_faction_key
					end,
					function()
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.heroes_to_rank_up then
				core:add_listener(
					"ingredient_rank_up_" .. ingredient,
					"CharacterRankUp",
					function(context)
						local character = context:character()
						return character:faction():name() == grom_faction_key and character:rank() >= 15 and data.heroes_to_rank_up[character:character_subtype_key()]
					end,
					function(context)
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.subculture_to_sack then
				core:add_listener(
					"ingredient_sack_" .. ingredient,
					"CharacterSackedSettlement",
					function(context)
						return context:character():faction():name() == grom_faction_key and context:garrison_residence():faction():subculture() == data.subculture_to_sack
					end,
					function(context)
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.units_to_recruit then
				core:add_listener(
					"ingredient_unit_recruited_" .. ingredient,
					"UnitTrained",
					function(context)
						local unit = context:unit()
						return unit:has_force_commander() and unit:force_commander():faction():name() == grom_faction_key and data.units_to_recruit[unit:unit_key()]
					end,
					function()
						unlock_ingredient(ingredient)
					end,
					false
				)
			end
			
			if data.units_to_defeat then
				core:add_listener(
					"ingredient_units_defeated_" .. ingredient,
					"BattleCompleted",
					function()
						return cm:pending_battle_cache_faction_is_involved(grom_faction_key)
					end,
					function()
						return cm:pending_battle_cache_faction_won_battle_against_unit(grom_faction_key, data.units_to_defeat)
					end,
					false
				)
			end
		end
	end
	
	core:add_listener(
		"food_encounter_at_sea",
		"ScriptEventSeaEncounterTriggeredByPlayerThatIsPlayingGrom",
		function()
			return cm:model():random_percent(food_sea_encounter_chance)
		end,
		function()
			local available_ingredients_to_drop = {}
			
			-- get the ingredients that can be dropped via encounters and haven't yet been unlocked
			for ingredient, data in pairs(ingredients_data) do
				if data.dropped_via_sea_encounter and not cooking_interface:is_ingredient_unlocked(ingredient) then
					table.insert(available_ingredients_to_drop, ingredient)
				end
			end
			
			if #available_ingredients_to_drop > 0 then
				-- ensure the table is in alphabetical order to keep mp safe
				table.sort(available_ingredients_to_drop)
				unlock_ingredient(available_ingredients_to_drop[cm:random_number(#available_ingredients_to_drop)])
			end
		end,
		true
	)
	
	-- unlock secret recipes from blacktoof missions
	core:add_listener(
		"blacktoof_food_unlock",
		"MissionSucceeded",
		function(context)
			return blacktoof_missions[context:mission():mission_record_key()]
		end,
		function(context)
			local available_secret_recipes = {}
			for i = 1, #secret_recipe_index do
				if not cooking_interface:is_recipe_unlocked(secret_recipe_index[i]) then
					table.insert(available_secret_recipes, secret_recipe_index[i])
				end
			end
			
			if #available_secret_recipes > 0 then
				local recipe = available_secret_recipes[cm:random_number(#available_secret_recipes)]
				
				cm:unlock_cooking_recipe(context:faction(), recipe)
				cm:trigger_incident(grom_faction_key, "wh2_dlc15_grom_cauldron_food_recipe_unlocked", true)
			end
		end,
		true
	)
	
	cm:add_faction_turn_start_listener_by_name(
		"update_blacktoof_missions",
		grom_faction_key,
		function(context)
			if #cooked_dish >= blacktoof_required_recipe_number then
				core:trigger_event("GromEatenEnoughRecipes")
			end
			
			check_blacktoof_mission_requirement()
		end,
		true
	)
	
	local spawned_merchant_this_turn = false
	
	core:add_listener(
		"spawn_food_merchant",
		"ScriptEventSpawnGromFoodMerchant",
		function()
			return not spawned_merchant_this_turn
		end,
		function()
			spawned_merchant_this_turn = true
			spawn_food_merchant()
		end,
		true
	)
	
	core:add_listener(
		"grom_cooks_dish",
		"FactionCookedDish", 
		function(context)
			return context:faction():name() == grom_faction_key
		end,
		function(context)
			local recipe_already_cooked = false
			local dish_key = context:dish():recipe()
			
			-- if the recipe hasn't been cooked before, increment the number of cooked dishes
			for i = 1, #cooked_dish do
				if cooked_dish[i] == dish_key then
					recipe_already_cooked = true
					break
				end
			end
			
			if not recipe_already_cooked then
				local component = find_uicomponent(core:get_ui_root(), "grom_goals")
				if component then
					component:InterfaceFunction("AddCookedRecipe", dish_key)
				end
				table.insert(cooked_dish, dish_key)
			end
			
			if #cooked_dish >= blacktoof_required_recipe_number then
				core:trigger_event("GromEatenEnoughRecipes")
			end
			
			-- increase the trait's level
			local char_interface = context:faction():faction_leader()
			local current_lvl = char_interface:trait_points(food_trait)
			
			for i = 1, #food_trait_threshold do
				if #cooked_dish >= food_trait_threshold[i] and current_lvl < i then
					cm:force_add_trait(cm:char_lookup_str(char_interface), food_trait, true)
				end
			end
			
			current_lvl = char_interface:trait_points(food_trait)
			
			-- spawn the merchant a turn after cooking a dish
			if not dishcookedhag then
				spawn_food_merchant(1)
			end
			
			-- scripted effects of each ingredient
			local ingredients = context:dish():ingredients()
			
			for i = 1, #ingredients do
				local data = ingredients_data[ingredients[i]]
				
				if is_function(data.cooking_callback) then
					data.cooking_callback()
				end
			end
		end,
		true
	)
	
	-- listener for food challenge
	if current_food_challenge.is_active then
		setup_food_challenge_listener()
	end
	
	-- food merchant interacted with
	core:add_listener(
		"area_entered_trigger_food_merchant",
		"AreaEntered",
		function(context)
			return context:area_key() == "food_merchant"
		end,
		function(context)
			local character = context:family_member():character()
			if not character:is_null_interface() and character:faction():name() == grom_faction_key then
				if get_number_of_ingredients(false) > 0 then
					local available_ingredient_dilemmas = {}
					
					-- get the ingredient dilemmas that haven't yet been unlocked
					for ingredient, data in pairs(ingredients_data) do
						if not cooking_interface:is_ingredient_unlocked(ingredient) then
							table.insert(available_ingredient_dilemmas, data.merchant_dilemma)
						end
					end
					
					if #available_ingredient_dilemmas > 0 then
						-- ensure the table is in alphabetical order to keep mp safe
						table.sort(available_ingredient_dilemmas)
					end
					
					cm:trigger_dilemma(grom_faction_key, available_ingredient_dilemmas[cm:random_number(#available_ingredient_dilemmas)])
				else
					cm:trigger_dilemma(grom_faction_key, merchant_dilemma_all_ingredients)
				end
				
				cm:callback(function() core:trigger_event("ScriptEventGromsCauldronGromMeetsTheFoodMerchantress") end, 0.5) -- delay by a tick so mission events don't come before the dilemma
				
				cm:remove_interactable_campaign_marker("food_merchant")
				
				core:add_listener(
					"foodmerchant_dilemma_choice",
					"DilemmaChoiceMadeEvent",
					true,
					function(context)
						local choice = context:choice()
						local dilemma = context:dilemma()
						
						if dilemma == merchant_dilemma_all_ingredients then
							if choice == 0 then
								create_new_food_challenge()
							elseif choice == 1 then
								cook_random_recipe()
							end
							
							return
						end
						
						for ingredient, data in pairs(ingredients_data) do
							if dilemma == data.merchant_dilemma then
								if choice == 0 then
									unlock_ingredient(ingredient)
								elseif choice == 1 then
									create_new_food_challenge()
								elseif choice == 2 then
									cook_random_recipe()
								end
							end
						end
					end,
					false
				)
			end
		end,
		true
	)
end

function cook_random_recipe()
	local available_recipes = {}
	local active_recipe = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(grom_faction_key)):active_dish()
	
	for i = 1, #recipe_index do
		if active_recipe ~= recipe_index[i] then
			table.insert(available_recipes, recipe_index[i])
		end
	end
	
	dishcookedhag = true
	cm:force_cook_recipe(cm:get_faction(grom_faction_key), available_recipes[cm:random_number(#available_recipes)], false)
	cm:trigger_incident(grom_faction_key, "wh2_dlc15_grom_cauldron_food_cooked", true)
end

function unlock_ingredient(ingredient)
	local faction = cm:get_faction(grom_faction_key)
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(faction)
	
	if not cooking_interface:is_ingredient_unlocked(ingredient) then
		cm:unlock_cooking_ingredient(faction, ingredient)
		cm:trigger_incident(grom_faction_key, "wh2_dlc15_grom_cauldron_food_ingredient_unlocked", true)
		core:trigger_event("IngredientUnlocked")
	end
	
	check_blacktoof_mission_requirement()
end

function check_blacktoof_mission_requirement()
	if get_number_of_ingredients(true) >= blacktoof_required_ingredients_number then
		core:trigger_event("GromHasUnlockedEnoughIngredients")
	end
end

-- check and spawn food merchant
function spawn_food_merchant(queue_time)
	cm:add_turn_countdown_event(grom_faction_key, queue_time or merchant_turns_interval, "ScriptEventSpawnGromFoodMerchant")
	
	if queue_time then
		return
	else
		local region = ""
		local faction = cm:get_faction(grom_faction_key)
		
		if faction then
			local regions = faction:region_list()
			
			if regions:is_empty() then
				return
			else
				region = regions:item_at(cm:random_number(regions:num_items()) - 1):name()
			end
		end
		
		-- spawn the marker near the settlement
		local loc_x, loc_y = cm:find_valid_spawn_location_for_character_from_settlement(grom_faction_key, region, false, true, 9)
		
		if loc_x > -1 then
			cm:add_interactable_campaign_marker("food_merchant", "food_merchant", loc_x, loc_y, 4, grom_faction_key, "")
			cm:trigger_incident_with_targets(faction:command_queue_index(), "wh2_dlc15_grom_cauldron_food_merchant_visits", 0, 0, 0, 0, cm:get_region(region):cqi(), 0)
			core:trigger_event("ScriptEventFoodMerchantSpawned")
		end
		
		spawned_merchant_this_turn = false
	end
end

function get_number_of_ingredients(unlocked)
	local count = 0
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(grom_faction_key))
	
	for ingredient, data in pairs(ingredients_data) do
		if cooking_interface:is_ingredient_unlocked(ingredient) == unlocked then
			count = count + 1
		end
	end
	
	return count
end

-- setup the food challenge mission and listeners
function create_new_food_challenge()
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(grom_faction_key))
	local current_slots = cooking_interface:max_secondary_ingredients() + 1
	
	local selected_objectives = food_challenge_ids[current_slots]
	local available_objectives = {}
	
	-- ensure the same objective isn't issued again
	for i = 1, #selected_objectives do
		if selected_objective ~= current_food_challenge.objective then
			table.insert(available_objectives, selected_objectives[i])
		end
	end
	
	local selected_objective = available_objectives[cm:random_number(#available_objectives)]
	
	if current_food_challenge.is_active then
		core:remove_listener("food_challenge_listener_" .. tostring(current_food_challenge.id))
	end
	
	local mm = mission_manager:new(grom_faction_key, "wh2_dlc15_food_food_challenge")
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key food_challenge_" .. current_food_challenge.id)
	mm:add_condition("override_text mission_text_text_" .. food_challenge_mission_text_prefix .. selected_objective)

	for i = 1, #food_challenge_rewards[current_slots] do
		mm:add_payload(food_challenge_rewards[current_slots][i])
	end
	mm:set_should_whitelist(false)
	mm:trigger()
		
	current_food_challenge.is_active = true
	current_food_challenge.objective = selected_objective
	
	setup_food_challenge_listener()
end

function setup_food_challenge_listener()
	core:add_listener(
		"food_challenge_listener_" .. tostring(current_food_challenge.id),
		"FactionCookedDish", 
		function(context)
			local dish_interface = context:dish()
			local current_requirements = food_challenge_requirements[food_challenge_mission_text_prefix .. current_food_challenge.objective]
			
			local ingredients_check_list = current_requirements.ingredients
			local ingredients_cooked = false
			
			if ingredients_check_list then
				local ingredients = dish_interface:ingredients()
				local matching_ingredients = 0
				
				for i = 1, #ingredients_check_list do
					for j = 1, #ingredients do
						if ingredients[j] == ingredients_check_list[i] then
							matching_ingredients = matching_ingredients + 1
						end
					end
				end
				
				if matching_ingredients >= #ingredients_check_list then
					ingredients_cooked = true
				end
			end
			
			local recipe_check_list = current_requirements.recipes
			local recipe_cooked = false
			
			if recipe_check_list then
				local recipe = dish_interface:recipe()
				for i = 1, #recipe_check_list do
					if recipe == recipe_check_list[i] then
						recipe_cooked = true
						break
					end
				end
			end
			
			return (ingredients_cooked or not ingredients_check_list) and (recipe_cooked or not recipe_check_list)
		end,
		function(context)
			cm:complete_scripted_mission_objective(grom_faction_key, "wh2_dlc15_food_food_challenge", "food_challenge_" .. current_food_challenge.id, true)
			
			local faction = context:faction()
			local current_slots = cm:model():world():cooking_system():faction_cooking_info(faction):max_secondary_ingredients()
			
			if current_slots < 2 then
				cm:set_faction_max_secondary_cooking_ingredients(faction, current_slots + 1)
				
				if current_slots == 1 then
					core:trigger_event("GromUnlockedAllTheCauldronSlots")
				end
			end
			
			current_food_challenge.is_active = false
			current_food_challenge.id = current_food_challenge.id + 1
		end,
		false
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("current_food_challenge", current_food_challenge, context)
		cm:save_named_value("cooked_dish", cooked_dish, context)
		cm:save_named_value("dishcookedhag", dishcookedhag, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			current_food_challenge = cm:load_named_value("current_food_challenge", current_food_challenge, context)
			cooked_dish = cm:load_named_value("cooked_dish", cooked_dish, context)
			dishcookedhag = cm:load_named_value("dishcookedhag", dishcookedhag, context)
		end
	end
)