episode_chaos_invasion = {
	episode_disabled = false,
	episode_name = "episode_chaos_invasion",
	episode_set = "end_times",
	-- this is the full name of the shared state that tells if the episode is active or not
	episode_active_shared_state = "episode_chaos_invasion",
	episode_frontend_enabled_shared_state_key = "endgame_chaos_invasion_enabled",
	episode_audio_stage_change_dynamic_dialogue_event = "campaign_vo_cs_end_times_structure_chaos",
	post_episode_cooldown = 10,

	invasion_faction_key = "wh3_dlc29_chaos_invasion_confederation_owner",
	invasion_culture_key = "wh_main_chs_chaos",
	archaon_faction_key = "wh_main_chs_chaos",
	archaon_subtype_key = "wh_main_chs_archaon",

	movie_path = "warhammer3/endtimes/dlc29_end_times_archaon",
	movie_registry = "dlc29_end_times_archaon",
	
	foreshadow_incident_key_1 = "wh3_dlc29_chaos_invasion_episode_foreshadow_1",
	foreshadow_incident_key_2 = "wh3_dlc29_chaos_invasion_episode_foreshadow_2",
	foreshadow_main_event_key = "chaos_invasion_foreshadow_main_event",
	
	dilemma_join_invasion = "wh3_dlc29_episodes_chaos_invasion_ally_dilemma",
	final_battle_mission_key = "wh3_dlc29_chaos_episodes_endgame_final_battle",
	victory_incident = "wh3_dlc29_chaos_invasion_episode_victory",

	diplomacy_bundle = "wh3_dlc29_episodes_endgame_shield_of_civilization_chaos",
	devastated_region_bundle = "wh3_dlc29_episodes_chaos_invasion_devastated_region",
	devastated_province_bundle = "wh3_dlc29_episodes_chaos_invasion_devastated_province",
	faction_trait_effect_bundle = "wh3_dlc29_faction_trait_chaos_invasion",

	invasion_force_count = 50, -- The total number of forces the invasion will spawn, not including Archaon and the Fortresses
	archaon_force_effect_list = {
		{key = "wh3_main_effect_force_enforce_autoresolver_battle", scope = "force_to_force_own", value = 1, value_type = "STATIC", required_bonus = 91},
		{key = "wh3_main_effect_force_ignore_damage_resistance_cap", scope = "force_to_force_own", value = 1, value_type = "STATIC"},
		{key = "wh3_main_effect_force_chaos_invasion_fortress_count", scope = "force_to_force_own", value = 1, value_type = "FORTRESS_COUNT"},
		{key = "wh3_main_effect_force_chaos_invasion_army_count", scope = "force_to_force_own", value = 1, value_type = "FORCE_COUNT"},
		{key = "wh3_main_effect_force_stat_ward_save_endgame", scope = "force_to_force_own_all_units", value = 1, value_type = "INVASION_VALUE"},
		{key = "wh3_main_effect_force_destroyed_after_loss", scope = "force_to_force_own", value = 1, value_type = "STATIC"}
	},

	starting_lord_rank_high = 50,
	starting_lord_rank_low = 30,
	starting_unit_rank_high = 9,
	starting_unit_rank_low = 6,

	dark_fortress_count = 5,
	dark_fortress_support_army_count = 3, -- The number of armies spawned alongside the Fortress (deducts from overall force count)
	dark_fortress_subtype_key = "wh3_dlc29_episode_dark_fortress",
	dark_fortress_stance = "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SETTLE",
	dark_fortress_details = {
		{
			corruption_key = "wh3_main_corruption_chaos",
			battle_maps = {
				fortress = {
					{macro = "minor_p_chs", catchment = ""}
				},
				land = {
					{macro = "wh3_main_macro_chs_wastes_01", catchment = "catchment_02"},
					{macro = "wh3_main_macro_chs_wastes_01", catchment = "catchment_06"},
					{macro = "wh3_main_macro_chs_wastes_01", catchment = "catchment_07"}
				},
				ambush = {
					{macro = "wh3_main_macro_chs_wastes_01", catchment = "catchment_09"}
				},
				chokepoint = {
					{macro = "wh3_main_macro_chs_wastes_01", catchment = "catchment_10"}
				}
			},
			tile_upgrade = "",
			army_key = "chaos_fortress",
			support_army_key = "chaos",
			character_name = ""
		},
		{
			corruption_key = "wh3_main_corruption_khorne",
			battle_maps = {
				fortress = {
					{macro = "minor_p_chs", catchment = ""}
				},
				land = {
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_02"},
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_03"},
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_05"},
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_11"}
				},
				ambush = {
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_19"}
				},
				chokepoint = {
					{macro = "wh3_main_macro_kho_realm_01", catchment = "catchment_16"}
				}
			},
			tile_upgrade = "battle_corruption_khorne",
			army_key = "khorne_fortress",
			support_army_key = "khorne",
			character_name = ""
		},
		{
			corruption_key = "wh3_main_corruption_slaanesh",
			battle_maps = {
				fortress = {
					{macro = "minor_p_chs", catchment = ""}
				},
				land = {
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_01"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_04"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_06"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_10"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_12"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_13"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_14"}
				},
				ambush = {
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_18"}
				},
				chokepoint = {
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_19"},
					{macro = "wh3_main_macro_sla_realm_01", catchment = "catchment_20"}
				}
			},
			tile_upgrade = "battle_corruption_slaanesh",
			army_key = "slaanesh_fortress",
			support_army_key = "slaanesh",
			character_name = ""
		},
		{
			corruption_key = "wh3_main_corruption_tzeentch",
			battle_maps = {
				fortress = {
					{macro = "minor_p_chs", catchment = ""}
				},
				land = {
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_01"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_03"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_08"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_10"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_13"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_18"},
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_19"}
				},
				ambush = {
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_21"}
				},
				chokepoint = {
					{macro = "wh3_main_macro_tze_realm_01", catchment = "catchment_22"}
				}
			},
			tile_upgrade = "battle_corruption_tzeentch",
			army_key = "tzeentch_fortress",
			support_army_key = "tzeentch",
			character_name = ""
		},
		{
			corruption_key = "wh3_main_corruption_nurgle",
			battle_maps = {
				fortress = {
					{macro = "minor_p_chs", catchment = ""}
				},
				land = {
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_04"},
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_07"}
				},
				ambush = {
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_02"},
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_14"},
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_21"}
				},
				chokepoint = {
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_03"},
					{macro = "wh3_main_macro_nur_realm_01", catchment = "catchment_13"}
				}
			},
			tile_upgrade = "battle_corruption_nurgle",
			army_key = "nurgle_fortress",
			support_army_key = "nurgle",
			character_name = ""
		}
	},

	prevent_occupation_options = {
		"1076287141",
		"121892460",
		"179365512",
		"503864292",
		"563",
		"1217849377",
		"1231725576",
		"524353926",
		"618357381",
		"1268451365",
		"1721507530",
		"182625411",
		"1826736048",
		"353169368",
		"1187793590"
	},

	average_distance_to_adjacent_regions = 2151, -- Don't change this value - This distance is the squared and pre-computed average distance between adjacent regions across the campaign
	desired_region_distance_multiplier = 5,
	distance_tolerance_multiplier = 2,
	minimum_distance_to_capitals_multiplier = 4,
	excluded_provinces_and_regions = {
		["wh3_main_combi_province_yn_edri_eternos"] = true,
		["wh3_main_combi_province_talsyn"] = true,
		["wh3_main_combi_province_wydrioth"] = true,
		["wh3_main_combi_province_torgovann"] = true,
		["wh3_main_combi_province_argwylon"] = true,
		["wh3_main_combi_province_the_great_ocean"] = true,
		["wh3_main_combi_province_the_dragon_isles"] = true
	},
	
	chaos_legendary_lords = {
		-- The are all Chaos aligned Legendary lords, add a new entry to the chaos_invasion_armies table and link its key to a lord here if you want them to spawn with a unique army
		-- Lords can have a spawn_position_override which will force them to spawn in one of the locations in the invasion_spawn_positions table below or a hardcoded location
		["wh_main_chs_archaon"] = {status = "unkown", forename = "2147343903", surname = "2147357364", army = "archaon"},
		["wh_dlc01_chs_kholek_suneater"] = {status = "unkown", forename = "2147345931", surname = "2147345934", army = "kholek", spawn_position_override = "with_archaon"},
		["wh_dlc01_chs_prince_sigvald"] = {status = "unkown", forename = "2147345922", surname = "2147357370", army = "chaos", spawn_position_override = "with_archaon"},
		["wh_main_chs_lord_of_change"] = {status = "unkown", forename = "1109414330", surname = "572054320", army = "chaos", spawn_position_override = "with_archaon"},
		["wh3_main_dae_belakor"] = {status = "unkown", forename = "1088515835", surname = "", army = "chaos"},
		["wh_dlc03_bst_khazrak"] = {status = "unkown", forename = "64373862", surname = "1302939549", army = "beastmen", spawn_position_override = "beastmen"},
		["wh_dlc03_bst_malagor"] = {status = "unkown", forename = "1959790099", surname = "266287726", army = "beastmen", spawn_position_override = "beastmen"},
		["wh_dlc05_bst_morghur"] = {status = "unkown", forename = "1889638899", surname = "2145043483", army = "beastmen", spawn_position_override = "beastmen"},
		["wh2_dlc17_bst_taurox"] = {status = "unkown", forename = "2121497307", surname = "1160425427", army = "beastmen", spawn_position_override = "beastmen"},
		["wh_dlc08_nor_wulfrik"] = {status = "unkown", forename = "778590517", surname = "1626025053", army = "norsca", spawn_position_override = "norsca"},
		["wh_dlc08_nor_throgg"] = {status = "unkown", forename = "1304569339", surname = "", army = "norsca", spawn_position_override = "norsca"},
		["wh3_dlc27_nor_sayl_the_faithless"] = {status = "unkown", forename = "292672935", surname = "", army = "norsca", spawn_position_override = "norsca"},
		["wh3_main_kho_skarbrand"] = {status = "unkown", forename = "724664433", surname = "", army = "khorne"},
		["wh3_dlc20_kho_valkia"] = {status = "unkown", forename = "62854889", surname = "", army = "khorne"},
		["wh3_dlc26_kho_arbaal_the_undefeated"] = {status = "unkown", forename = "285628627", surname = "", army = "khorne"},
		["wh3_dlc26_kho_skulltaker"] = {status = "unkown", forename = "1862886738", surname = "", army = "khorne"},
		["wh3_main_sla_nkari"] = {status = "unkown", forename = "1336311045", surname = "", army = "slaanesh"},
		["wh3_dlc20_sla_azazel"] = {status = "unkown", forename = "673785715", surname = "", army = "slaanesh"},
		["wh3_dlc27_sla_dechala"] = {status = "unkown", forename = "2016330353", surname = "", army = "slaanesh"},
		["wh3_dlc27_sla_masque_of_slaanesh"] = {status = "unkown", forename = "103626007", surname = "", army = "slaanesh"},
		["wh3_main_tze_kairos"] = {status = "unkown", forename = "513639814", surname = "", army = "tzeentch"},
		["wh3_dlc20_tze_vilitch"] = {status = "unkown", forename = "1189063808", surname = "", army = "tzeentch"},
		["wh3_dlc24_tze_the_changeling"] = {status = "unkown", forename = "17386640", surname = "", army = "tzeentch"},
		["wh3_main_nur_kugath"] = {status = "unkown", forename = "229754899", surname = "", army = "nurgle"},
		["wh3_dlc20_nur_festus"] = {status = "unkown", forename = "521322027", surname = "", army = "nurgle"},
		["wh3_dlc25_nur_epidemius"] = {status = "unkown", forename = "1726261173", surname = "", army = "nurgle"},
		["wh3_dlc25_nur_tamurkhan"] = {status = "unkown", forename = "1266332593", surname = "", army = "nurgle"},
		["wh3_dlc29_chs_glottkin"] = {status = "unkown", forename = "555976920", surname = "", army = "nurgle"}
	},
	chaos_invasion_armies = {
		-- If an army has a weight specified it can be selected as one of the invasions random spawns, with a weighted roll against all other armies
		-- Units here are placeholder -- See bottom of script for actual setup
		["archaon"] = {
			units = "wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0",
			bundle = "wh3_dlc29_episodes_chaos_invasion_archaon",
		},
		["kholek"] = {
			units = "wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0",
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_chs",
		},
		["chaos"] = {
			units = "wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0",
			valid_lords = {"wh3_dlc20_chs_daemon_prince_undivided", "wh_main_chs_lord"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_chs",
			weight = 4
		},
		["beastmen"] = {
			units = "wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1,wh_dlc03_bst_inf_minotaurs_1",
			valid_lords = {"wh2_dlc17_bst_doombull", "wh_dlc03_bst_beastlord"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_bst",
			weight = 1
		},
		["norsca"] = {
			units = "wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0",
			valid_lords = {"wh_main_nor_marauder_chieftain"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_nor",
			weight = 1
		},
		["khorne"] = {
			units = "wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho",
			valid_lords = {"wh3_dlc20_chs_daemon_prince_khorne", "wh3_dlc20_chs_lord_mkho", "wh3_dlc20_chs_lord_mkho", "wh3_dlc20_chs_lord_mkho", "wh3_dlc20_chs_lord_mkho"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_kho",
			weight = 2
		},
		["slaanesh"] = {
			units = "wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla",
			valid_lords = {"wh3_dlc20_chs_daemon_prince_slaanesh", "wh3_dlc20_chs_lord_msla", "wh3_dlc20_chs_lord_msla", "wh3_dlc20_chs_lord_msla", "wh3_dlc20_chs_lord_msla"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_sla",
			weight = 2
		},
		["tzeentch"] = {
			units = "wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze",
			valid_lords = {"wh3_dlc20_chs_daemon_prince_tzeentch", "wh3_dlc24_chs_lord_mtze", "wh3_dlc24_chs_lord_mtze", "wh3_dlc24_chs_lord_mtze", "wh3_dlc24_chs_lord_mtze"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_tze",
			weight = 2
		},
		["nurgle"] = {
			units = "wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur",
			valid_lords = {"wh3_dlc20_chs_daemon_prince_nurgle", "wh3_dlc25_chs_lord_mnur", "wh3_dlc25_chs_lord_mnur", "wh3_dlc25_chs_lord_mnur", "wh3_dlc25_chs_lord_mnur"},
			bundle = "wh3_dlc29_episodes_chaos_invasion_force_nur",
			weight = 2
		},
		["chaos_fortress"] = {
			units = "wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chosen_0",
			bundle = "wh3_dlc29_episodes_chaos_invasion_fortress_chs"
		},
		["khorne_fortress"] = {
			units = "wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho,wh3_dlc20_chs_inf_chosen_mkho",
			bundle = "wh3_dlc29_episodes_chaos_invasion_fortress_kho"
		},
		["slaanesh_fortress"] = {
			units = "wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla,wh3_dlc20_chs_inf_chosen_msla",
			bundle = "wh3_dlc29_episodes_chaos_invasion_fortress_sla"
		},
		["tzeentch_fortress"] = {
			units = "wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze",
			bundle = "wh3_dlc29_episodes_chaos_invasion_fortress_tze"
		},
		["nurgle_fortress"] = {
			units = "wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur,wh3_dlc20_chs_inf_chosen_mnur",
			bundle = "wh3_dlc29_episodes_chaos_invasion_fortress_nur"
		}
	},
	invasion_spawn_positions = {
		["chaos_wastes"] = {
			position_groups = {
				{
					-- North East
					positions = {{1363, 671}, {1328, 689}, {1288, 711}, {1271, 739}, {1218, 746}, {1174, 741}, {1142, 720}, {1098, 723}, {1056, 727}},
					weight = 4
				},
				{
					-- North Center
					positions = {{972, 846}, {1023, 815}, {935, 871}, {878, 889}, {839, 906}, {776, 928}, {722, 935}, {674, 945}, {609, 944}, {541, 954}, {493, 953}, {454, 944}},
					weight = 6
				},
				{
					-- North West
					positions = {{359, 931}, {320, 913}, {261, 901}, {200, 902}, {146, 903}, {96, 900}, {47, 903}, {13, 862}},
					weight = 4
				},
				{
					-- Southern
					positions = {{193, 16}, {249, 21}, {290, 24}, {320, 23}, {354, 17}, {418, 24}, {452, 29}, {509, 17}, {543, 20}, {589, 17}, {634, 9}, {696, 11}, {747, 20}, {802, 32}, {817, 14}, {854, 16}},
					weight = 3
				}
			}
		},
		["norsca"] = {
			position_groups = {
				{
					positions = {{457, 803}, {499, 825}, {566, 845}, {635, 855}, {682, 841}},
					weight = 1
				}
			}
		},
		["beastmen"] = {
			position_groups = {
				{
					positions = {{497, 678}, {569, 763}, {589, 660}, {721, 666}, {414, 623}, {580, 182}, {151, 220}, {145, 743}, {1084, 498}, {1315, 419}},
					weight = 1
				}
			}
		}
	},
	backup_spawn_regions = {
		"wh3_main_combi_region_the_writhing_fortress",
		"wh3_main_combi_region_the_howling_citadel",
		"wh3_main_combi_region_the_forest_of_decay",
		"wh3_main_combi_region_the_twisted_towers",
		"wh3_main_combi_region_dark_tower",
		"wh3_main_combi_region_the_silvered_tower_of_sorcerers"
	},

	razed_thresholds = {
		{
			required_world_razed_percentage = 0,
			battle_parameter = "chaos_invasion_fb_provinces_threshold_01",
		},
		{
			required_world_razed_percentage = 15,
			battle_parameter = "chaos_invasion_fb_provinces_threshold_02",
		},

		{
			required_world_razed_percentage = 45,
			battle_parameter = "chaos_invasion_fb_provinces_threshold_03",
		},
	},

	dilemmas = {
		good = {key = "wh3_dlc29_episodes_chaos_invasion_progress_good", effects = {"wh3_dlc29_episodes_chaos_invasion_event_good_1", "wh3_dlc29_episodes_chaos_invasion_event_good_2"}},
		bad = {key = "wh3_dlc29_episodes_chaos_invasion_progress_bad", effects = {"wh3_dlc29_episodes_chaos_invasion_event_bad_1", "wh3_dlc29_episodes_chaos_invasion_event_bad_2"}},
		ending = {key = "wh3_dlc29_episodes_chaos_invasion_progress_end", effects = {"wh3_dlc29_episodes_chaos_invasion_event_end_2"}},
		alone = {key = "wh3_dlc29_episodes_chaos_invasion_progress_alone", effects = {"wh3_dlc29_episodes_chaos_invasion_event_alone_2"}}
	},
	factions_awaiting_dilemma = {},

	prerequisites = {
		min_turn = 80
	},
	-- these are saved by the episode manager
	persistent = {
		current_stage = 1,
		stages_persistent_data = {},
		invasion_spawned = false,
		--legendary_lords = {},
		dark_fortresses = {},
		invasion_forces = {},
		dilemmas = {},
		regions_razed = 0,
		world_razed_percentage = 0,
	}
}

episode_chaos_invasion.stages = 
{
	-- Foreshadow 1 - Archaon goes missing
	{
		stage_key = "episode_chaos_invasion_stage_foreshadow_1",
		duration = 10,
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_chaos_invasion.foreshadow_incident_key_1,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.foreshadow,

		on_started = function(self)
			-- We remove archaon from the map and place him in limbo
			local archaon_family_cqi = episode_chaos_invasion.persistent.legendary_lords[episode_chaos_invasion.archaon_subtype_key]

			if archaon_family_cqi then
				local archaon_faction = cm:get_family_member_by_cqi(archaon_family_cqi):character_details():faction()
				
				if archaon_faction:is_human() == false then
					cm:enter_limbo("family_member_cqi:"..archaon_family_cqi)

					-- Prevent Archaon's current faction confederating beyond this point, so he doesn't move to a new human faction and cause issues
					local archaon_faction_key = archaon_faction:name()
					cm:force_diplomacy("all", "faction:"..archaon_faction_key, "form confederation", false, false, true)
					cm:force_diplomacy("faction:"..archaon_faction_key, "all", "form confederation", false, false, true)
				end
				
			end

			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_narrator_001")
		end
	},
	-- Foreshadow 2 - Something big is coming
	{
		stage_key = "episode_chaos_invasion_stage_foreshadow_2",
		duration = 10,
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_chaos_invasion.foreshadow_incident_key_2,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.imminent,

		on_started = function(self)
			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_narrator_002")
		end
	},
	-- Main Event - The Invasion begins!
	{
		stage_key = "episode_chaos_invasion_stage_main",
		main_event = true,
		payloads = {}, -- Payloads are handled in the post_payload event, due to requiring specific timing functions rather than just sequential execution
		audio_stage_type = episodes_manager.audio_stage_types.main_event,

		can_start_stage = function(self)
			-- We need to find Archaon and make sure he's still part of an A.I faction, else we cannot start
			local archaon_family_cqi = episode_chaos_invasion.persistent.legendary_lords[episode_chaos_invasion.archaon_subtype_key]

			if archaon_family_cqi then
				local archaon_is_human = cm:get_family_member_by_cqi(archaon_family_cqi):character_details():faction():is_human()
				
				if archaon_is_human == false then
					return true
				end
			end
			return false
		end,

		on_started = function(self)
			-- Disable the entire event feed as we don't want any events while creating the invasion
			cm:disable_event_feed_events(true, "all")
		end,

		post_payload = function(self)
			local regions_to_raze = episode_chaos_invasion:setup_chaos_invasion()
			cm:fade_scene(0, 3)
			
			cm:callback(function()
				episode_chaos_invasion:raze_invasion_regions(regions_to_raze)
				episode_chaos_invasion:play_endgame_movie()
				episode_chaos_invasion:spawn_chaos_invasion()
				episode_chaos_invasion:trigger_endgame_diplomacy()
				cm:fade_scene(1, 1)

				cm:callback(function()
					local local_faction_key = cm:get_local_faction_name(true)

					if episode_chaos_invasion.factions_awaiting_dilemma[local_faction_key] == nil then
						-- If the local faction didn't just get given a dilemma we can show the UI right away, else we'll do it after the dilemma
						-- This is all MP safe as it is just UI stuff
						episode_chaos_invasion:toggle_endgame_ui()
						episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_archaon_003")
					end

					-- Play some music!
                    cm:activate_music_trigger("Episode_Start", "wh3_main_sc_kho_khorne")

					-- Trigger all missions related to the endgame for all humans, excluding those waiting for the dilemma, as we need to know their choice before giving them missions
					local human_factions = cm:get_human_factions()

					for i = 1, #human_factions do
						if episode_chaos_invasion.factions_awaiting_dilemma[human_factions[i]] == nil then
							episode_chaos_invasion:trigger_endgame_missions(human_factions[i])
						end
					end
					cm:disable_event_feed_events(false, "all")
					episode_chaos_invasion.persistent.invasion_spawned = true
				end, 1.2)
			end, 3)
		end,

		get_next_stage_index = function()
			-- If we don't specify a final battle then we should just skip straight to the ending
			if episode_chaos_invasion.final_battle_mission_key == "" then
				return episodes_manager:get_episode_stage_index_by_name(episode_chaos_invasion, "episode_chaos_invasion_stage_final")
			end
			return episodes_manager:get_episode_stage_index_by_name(episode_chaos_invasion, "episode_chaos_invasion_stage_battle")
		end,
	},
	-- Archaon was defeated in a normal battle - We now trigger the final battle marker via a mission
	{
		stage_key = "episode_chaos_invasion_stage_battle",
		payloads =
		{
			{
				payload_type = "mission",
				mission_key = episode_chaos_invasion.final_battle_mission_key,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.main_event_02,

		on_started = function(self)
			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_archaon_005")
		end
	},
	-- Episode Ending - Show the victory event, end the episode
	{
		stage_key = "episode_chaos_invasion_stage_final",
		duration = 1,
		payloads =
		{
			-- Trigger win incident (all players get this, even if it was a Chaos player part of the invasion)
			{
				payload_type = "incident",
				incident_key = episode_chaos_invasion.victory_incident,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.ended,

		on_started = function(self)
			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_narrator_008")

			-- Play some music!
            cm:activate_music_trigger("Episode_Finish", "wh3_main_sc_kho_khorne")
			
			-- Kill the invasion faction
			cm:kill_faction(episode_chaos_invasion.invasion_faction_key)

			-- Hide the Endgame UI elements
			cm:set_script_state("current_episode_popup", "")
			local uic = core:get_or_create_component("foreshadow_popup", "UI/Campaign UI/dlc29_endgame_crisis_scenarios.twui.xml")
			uic:SetVisible(false)

			-- Remove all effect bundles related to the endgame
			local human_factions = cm:get_human_factions()

			for i = 1, #human_factions do
				local faction_key = human_factions[i]
				for _, dilemma in dpairs(episode_chaos_invasion.dilemmas) do
					for _, effect in ipairs(dilemma.effects) do
						cm:remove_effect_bundle(effect, faction_key)
					end
				end
			end

			local all_factions = cm:get_faction_list()
			for i = 0, all_factions:num_items() - 1 do
				local faction = all_factions:item_at(i)
				if faction:is_dead() == false then
					local faction_key = faction:name()
					cm:remove_effect_bundle(episode_chaos_invasion.diplomacy_bundle, faction_key)
				end
			end

			-- Also remove all region effect bundles
			local region_list = cm:model():world():region_manager():region_list()

			for _, region in model_pairs(region_list) do
				local region_key = region:name()
				cm:remove_effect_bundle_from_region(episode_chaos_invasion.devastated_region_bundle, region_key)
				-- restore normal CAI targeting
				cm:cai_enable_targeting_against_settlement("settlement:"..region_key)
			end

			-- Finally clear the persistent data as its no longer needed
			episode_chaos_invasion.persistent.legendary_lords = {}
			episode_chaos_invasion.persistent.dark_fortresses = {}
			episode_chaos_invasion.persistent.invasion_forces = {}
			episode_chaos_invasion.persistent.dilemmas = {}
		end,

		get_next_stage_index = function()
			return -1 -- This ends the episode
		end
	},
}

episode_chaos_invasion.setup_chaos_invasion = function(self)
	out.invasions("##### setup_chaos_invasion #####")
	local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	cm:awaken_faction_from_death(invasion_faction)
	out.invasions("\tawaken_faction_from_death")

	-- Kill all the Legendary Lords, we aren't going to want duplicates
	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		local family_member_cqi = episode_chaos_invasion.persistent.legendary_lords[lord_subtype]

		if family_member_cqi then
			local family_member = cm:get_family_member_by_cqi(family_member_cqi)

			if family_member:is_null_interface() == false then
				local character_details = family_member:character_details()
				local character = family_member:character()

				if character_details:faction():is_human() == false then
					local character_lookup = "family_member_cqi:"..family_member_cqi
					cm:set_character_immortality(character_lookup, false)
					cm:suppress_immortality(family_member_cqi, true)
					cm:kill_character_and_commanded_unit("family_member_cqi:"..family_member_cqi, true, false)

					if character and character:is_null_interface() == false then
						if character:is_alive() == true then
							script_error("Failed to kill a character at the start of the Invasion?! - "..lord_subtype)
						end
					end
					
					out.invasions("\tkilled - "..lord_subtype)
					lord_details.status = "ready"
				else
					lord_details.status = "human"
				end
			end
		end
	end

	-- Next go through all Chaos-aligned factions, kill all their remaining lords/armies, raze all their regions and then confederate them (confederation is just so they are marked as confederated and thus cannot reappear)
	local faction_list = cm:model():world():lookup_factions_from_faction_set("chaos_invasion_chaos_alligned_all")
	local stored_regions = {}

	-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
	cm:postpone_cai_analysis()
	
	for _, faction in model_pairs(faction_list) do
		if faction:is_null_interface() == false 
			and faction:is_human() == false 
			and faction:is_quest_battle_faction() == false 
			and faction:is_rebel() == false 
			and faction:was_confederated() == false 
			and faction:is_faction(invasion_faction) == false 
		then
			if faction:is_dead() == true then
				cm:awaken_faction_from_death(faction)
			end
			local faction_key = faction:name()
			local character_list = faction:character_list()
			local character_cqis = {}

			-- Snapshot CQIs first so kills cannot invalidate the list mid-iteration
			for char_index = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(char_index)
				if is_character(character) then
					table.insert(character_cqis, character:command_queue_index())
				end
			end

			for _, character_cqi in ipairs(character_cqis) do
				local character = cm:get_character_by_cqi(character_cqi)

				-- There is no need to kill garrison commander characters, confederation handles them
				if is_character(character)
					and character:is_alive()
					and character:has_military_force() == true
					and character:military_force():is_armed_citizenry() == false
				then
					local character_details = character:character_details()
					local family_member_cqi = character_details:family_member():command_queue_index()
					local character_lookup = "family_member_cqi:"..family_member_cqi
					
					-- Kill everyone regardless of who they are
					cm:set_character_immortality(character_lookup, false)
					cm:kill_character(character_lookup, true, true)
				end
			end

			local region_list = faction:region_list()

			for region_index = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(region_index)
				table.insert(stored_regions, region:name())
			end
			cm:force_confederation(episode_chaos_invasion.invasion_faction_key, faction_key)
		end
	end

	cm:resume_cai_analysis()
	return stored_regions
end

episode_chaos_invasion.raze_invasion_regions = function(self, regions_to_raze)
	for _, region_key in ipairs(regions_to_raze) do
		cm:set_region_abandoned(region_key)
		episode_chaos_invasion:update_razed_region(region_key)
		-- Regions razed in script at the start of the invasion will also count as razed by the invasion
		episode_chaos_invasion.persistent.regions_razed = episode_chaos_invasion.persistent.regions_razed + 1
	end
	cm:set_script_state("invasion_regions_razed", episode_chaos_invasion.persistent.regions_razed)
	episode_chaos_invasion:update_world_razed_count()
end

episode_chaos_invasion.get_chaos_alligned_factions = function(self)
	local chaos_factions = {}
	local chaos_faction_set = cm:model():world():lookup_factions_from_faction_set("chaos_invasion_chaos_alligned_all")

	for _, chaos_faction in model_pairs(chaos_faction_set) do
		local chaos_faction_key = chaos_faction:name()
		chaos_factions[chaos_faction_key] = true
	end

	return chaos_factions
end

episode_chaos_invasion.trigger_endgame_diplomacy = function(self)
	-- we trigger a dilemma to all human Chaos factions to support the invasion or not
	local chaos_factions = self:get_chaos_alligned_factions()
	local human_factions = cm:get_human_factions()
	local is_single_player = (#human_factions == 1)

	local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	cm:postpone_cai_analysis()
	-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
	for chaos_faction_key, _ in dpairs(chaos_factions) do
		local chaos_faction = cm:get_faction(chaos_faction_key)
		if chaos_faction:is_human() then
			if is_single_player then
				cm:trigger_dilemma(chaos_faction_key, episode_chaos_invasion.dilemma_join_invasion)
				episode_chaos_invasion.factions_awaiting_dilemma[chaos_faction_key] = true
			else
				self:declare_war_on_faction_or_overlord(invasion_faction, chaos_faction, true, chaos_factions)
			end
		end
	end

	local factions_met = invasion_faction:factions_met()
	for i = 0, factions_met:num_items() - 1 do
		local other_faction = factions_met:item_at(i)
		local other_faction_key = other_faction:name()

		if not chaos_factions[other_faction_key] then -- We want to avoid doing anything with other Chaos factions
			self:declare_war_on_faction_or_overlord(invasion_faction, other_faction, true, chaos_factions)
		end
	end

	cm:resume_cai_analysis()

	-- No diplomacy with the endgame faction
	cm:force_diplomacy("all", "faction:"..episode_chaos_invasion.invasion_faction_key, "all", false, false, true)
	cm:force_diplomacy("faction:"..episode_chaos_invasion.invasion_faction_key, "all", "all", false, false, true)
end

episode_chaos_invasion.trigger_endgame_missions = function(self, faction_key)
	out.invasions("\ttrigger_endgame_missions - "..faction_key)
	for fortress_index, fortress_cqi in pairs(episode_chaos_invasion.persistent.dark_fortresses) do
		local mm = mission_manager:new(faction_key, "wh3_dlc29_chaos_invasion_destroy_dark_fortress_"..fortress_index)
		mm:set_mission_issuer("CLAN_ELDERS")
		mm:add_new_objective("ENGAGE_FORCE")
		mm:add_condition("cqi "..fortress_cqi)
		mm:add_condition("requires_victory")
		--mm:add_new_objective("KILL_CHARACTER_BY_ANY_MEANS")
		--mm:add_condition("family_member "..fortress_cqi)
		mm:add_payload("text_display dummy_chaos_invasion_fortress_reward")
		mm:trigger()
	end
end

episode_chaos_invasion.trigger_endgame_dilemma = function(self, dilemma_key)
	local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)

		if faction:at_war_with(invasion_faction) == true and faction:has_home_region() == true then
			cm:trigger_dilemma(faction_key, dilemma_key)
		end
	end
end

episode_chaos_invasion.spawn_chaos_invasion = function(self)
	out.invasions("##### spawn_chaos_invasion #####")
	local total_forces_to_spawn = episode_chaos_invasion.invasion_force_count
	local invasion_spawn_regions = episode_chaos_invasion:get_invasion_spawn_regions(episode_chaos_invasion.dark_fortress_count + 1)

	out.invasions("\tinvasion_spawn_regions:")
	for _, region_key in ipairs(invasion_spawn_regions) do
		out.invasions("\t\t"..region_key)
	end
	episode_chaos_invasion:raze_invasion_regions(invasion_spawn_regions)

	out.invasions("\tlegendary lords:")
	local lord_count = 1
	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		out.invasions("\t\t"..lord_count.."- "..lord_subtype.." ("..lord_details.status..")")
		lord_count = lord_count + 1

		if lord_details.forename ~= "" then
			lord_details.forename = "names_name_"..lord_details.forename
		end
		if lord_details.surname ~= "" then
			lord_details.surname = "names_name_"..lord_details.surname
		end
	end
	
	-- Create Archaon first
	local archaon_region_key = table.remove(invasion_spawn_regions)
	episode_chaos_invasion:create_archaons_force(episode_chaos_invasion.archaon_subtype_key, archaon_region_key)
	episode_chaos_invasion.chaos_legendary_lords[episode_chaos_invasion.archaon_subtype_key].status = "spawned"

	-- Apply the invasion factions effect bundle
	cm:apply_effect_bundle(episode_chaos_invasion.faction_trait_effect_bundle, episode_chaos_invasion.invasion_faction_key, 0)

	-- Create Archaon's support forces, his old mates Kholek, Sigvald and bird dude
	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		if lord_details.status == "ready" and lord_details.spawn_position_override == "with_archaon" then
			episode_chaos_invasion:create_legendary_lord(nil, archaon_region_key, lord_subtype)
			total_forces_to_spawn = total_forces_to_spawn - 1
			lord_details.status = "spawned"
		end
	end

	-- Create the Fortresses
	out.invasions("\tcreating fortresses:")
	for fortress_index = 1, episode_chaos_invasion.dark_fortress_count do
		local fortress_spawn_region = table.remove(invasion_spawn_regions)
		local fortress_details = episode_chaos_invasion.dark_fortress_details[fortress_index]
		episode_chaos_invasion:create_dark_fortress(fortress_spawn_region, fortress_details)
		out.invasions("\t\t"..fortress_index.."- "..fortress_spawn_region)

		-- For each Dark Fortress, spawn some armies also
		for supporting_force_index = 1, episode_chaos_invasion.dark_fortress_support_army_count do
			episode_chaos_invasion:create_invasion_force(nil, fortress_spawn_region, fortress_details.support_army_key)
			total_forces_to_spawn = total_forces_to_spawn - 1
		end
	end
	cm:set_script_state("dark_fortress_initial_count", episode_chaos_invasion.dark_fortress_count)
	cm:set_script_state("dark_fortress_current_count", episode_chaos_invasion.dark_fortress_count)

	-- Spawn the Norscan LL's in Norsca
	local norsca_spawn_points = episode_chaos_invasion:build_spawn_position_weighted_list("norsca")

	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		if lord_details.status == "ready" and lord_details.spawn_position_override == "norsca" then
			local position, index = norsca_spawn_points:weighted_select(true)
			episode_chaos_invasion:create_legendary_lord(position, nil, lord_subtype)
			total_forces_to_spawn = total_forces_to_spawn - 1
			lord_details.status = "spawned"
		end
	end

	-- Spawn the Beastmen LL's in random forests
	local beastmen_spawn_points = episode_chaos_invasion:build_spawn_position_weighted_list("beastmen")

	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		if lord_details.status == "ready" and lord_details.spawn_position_override == "beastmen" then
			local position, index = beastmen_spawn_points:weighted_select(true)
			episode_chaos_invasion:create_legendary_lord(position, nil, lord_subtype)
			total_forces_to_spawn = total_forces_to_spawn - 1
			lord_details.status = "spawned"
		end
	end

	-- For the remainder of the forces we spawn them along the North and South Chaos Wastes
	-- We use all remaining Legendary Lords to spawn before defaulting to random lords
	local chaos_waste_spawn_points = episode_chaos_invasion:build_spawn_position_weighted_list("chaos_wastes")

	for lord_subtype, lord_details in dpairs(episode_chaos_invasion.chaos_legendary_lords) do
		if lord_details.status == "ready" then
			local position, index = chaos_waste_spawn_points:weighted_select(true)
			episode_chaos_invasion:create_legendary_lord(position, nil, lord_subtype)
			total_forces_to_spawn = total_forces_to_spawn - 1
			lord_details.status = "spawned"

			if total_forces_to_spawn == 0 then
				break
			end
		end
	end
	
	while total_forces_to_spawn > 0 do
		if #chaos_waste_spawn_points.items > 0 then
			local position, index = chaos_waste_spawn_points:weighted_select(true)
			episode_chaos_invasion:create_invasion_force(position, nil, nil)
		else
			-- We have run out of valid spawn positions, as a backup we will spawn them near Archaon
			episode_chaos_invasion:create_invasion_force(nil, archaon_region_key, nil)
		end
		total_forces_to_spawn = total_forces_to_spawn - 1
	end

	-- Apply Archaon's effect bundle
	episode_chaos_invasion:update_archaon_effects(true)

	-- Limit the Endgames occupation options to just razing
	for _, occupation_option in ipairs(episode_chaos_invasion.prevent_occupation_options) do
		cm:add_event_restricted_occupation_option_record_for_faction(occupation_option, episode_chaos_invasion.invasion_faction_key)
	end

	-- Finally update the UI
	local forces_created = episode_chaos_invasion.invasion_force_count - total_forces_to_spawn
	cm:set_script_state("invasion_forces_current_count", forces_created)
	cm:set_script_state("invasion_forces_initial_count", forces_created)
	out.invasions("forces_created = "..forces_created)
end

episode_chaos_invasion.create_archaons_force = function(self, lord_subtype, region_key)
	out.invasions("\tcreate_archaons_force  -  "..region_key)
	-- Find a position for Archaon in the region
	local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
		episode_chaos_invasion.invasion_faction_key,
		region_key,
		false,
		true,
		20
	)
	if x_pos == -1 or y_pos == -1 then
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
			episode_chaos_invasion.invasion_faction_key,
			region_key,
			false,
			false,
			10
		)
	end

	if x_pos == -1 or y_pos == -1 then
		script_error("CHAOS INVASION: Failed to generate Archaon's spawn position")
	end
	region_key = cm:get_region_data_at_position(x_pos, y_pos):key()
	
	local unit_list = episode_chaos_invasion.chaos_invasion_armies["archaon"].units
	local force_bundle = episode_chaos_invasion.chaos_invasion_armies["archaon"].bundle

	local character = cm:create_force_with_general(
		episode_chaos_invasion.invasion_faction_key,
		unit_list,
		region_key,
		x_pos,
		y_pos,
		"general",
		lord_subtype,
		episode_chaos_invasion.chaos_legendary_lords[lord_subtype].forename,
		"",
		episode_chaos_invasion.chaos_legendary_lords[lord_subtype].surname,
		"",
		true,
		function(char_cqi, force_cqi)
			local character_lookup = cm:char_lookup_str(char_cqi)
			cm:set_character_unique(character_lookup, true)
			cm:add_experience_to_units_commanded_by_character(character_lookup, episode_chaos_invasion.starting_unit_rank_high)
			cm:apply_effect_bundle_to_force(force_bundle, force_cqi, 0)
			cm:cai_disable_targeting_against_character(character_lookup)

			-- Reveal this region to the players, also reveal the character as sometimes region alone isn't enough
			episode_chaos_invasion:reveal_region_to_humans(region_key)
			episode_chaos_invasion:reveal_character_to_humans(character_lookup, 999)

			-- Reveal the shroud and zoom the camera to Archaon
			episode_chaos_invasion:zoom_camera_to_archaon(char_cqi)
		end
	)
	if character:is_null_interface() == false then
		local character_details = character:character_details()
		cm:character_details_set_rank(character_details, episode_chaos_invasion.starting_lord_rank_high, false)
	end
	
	-- Corrupt the region with the relevant Chaos corruption
	local region = cm:get_region(region_key)
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_chaos", 100, "events")
end

episode_chaos_invasion.create_legendary_lord = function(self, spawn_position, region_override, lord_subtype)
	out.invasions("\tcreate_legendary_lord  -  "..lord_subtype)
	local army_key = episode_chaos_invasion.chaos_legendary_lords[lord_subtype].army
	local unit_list = episode_chaos_invasion.chaos_invasion_armies[army_key].units
	local force_bundle = episode_chaos_invasion.chaos_invasion_armies[army_key].bundle
	local x_pos = -1
	local y_pos = -1
	local region_key = ""

	if region_override then
		local spawn_distance = cm:random_number(30, 10)

		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
			episode_chaos_invasion.invasion_faction_key,
			region_override,
			false,
			true,
			spawn_distance
		)
	elseif spawn_position then
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_position(episode_chaos_invasion.invasion_faction_key, spawn_position.x, spawn_position.y, true)
	end
	if x_pos == -1 or y_pos == -1 then
		script_error("CHAOS INVASION: Failed to generate LL army spawn position")
	end
	region_key = cm:get_region_data_at_position(x_pos, y_pos):key()

	local character = cm:create_force_with_general(
		episode_chaos_invasion.invasion_faction_key,
		unit_list,
		region_key,
		x_pos,
		y_pos,
		"general",
		lord_subtype,
		episode_chaos_invasion.chaos_legendary_lords[lord_subtype].forename,
		"",
		episode_chaos_invasion.chaos_legendary_lords[lord_subtype].surname,
		"",
		false,
		function(char_cqi, force_cqi)
			local character_lookup = cm:char_lookup_str(char_cqi)
			cm:set_character_unique(character_lookup, true)
			cm:add_experience_to_units_commanded_by_character(character_lookup, episode_chaos_invasion.starting_unit_rank_high)
			cm:apply_effect_bundle_to_force(force_bundle, force_cqi, 0)
			cm:apply_effect_bundle_to_force("wh3_main_effect_force_total_autoresolve_victory", force_cqi, 0)

			local tracker = {}
			tracker.char_cqi = char_cqi
			tracker.force_cqi = force_cqi
			tracker.legendary = true
			table.insert(episode_chaos_invasion.persistent.invasion_forces, tracker)
			out.invasions("Spawned "..char_cqi)
		end
	)
	if character:is_null_interface() == false then
		local character_details = character:character_details()
		cm:character_details_set_rank(character_details, episode_chaos_invasion.starting_lord_rank_high, false)
	end
end

episode_chaos_invasion.create_invasion_force = function(self, spawn_position, region_override, army_override)
	local lord_subtype = "wh_main_chs_lord"
	local x_pos = -1
	local y_pos = -1
	local region_key = ""
	local unit_list = ""
	local force_bundle = ""

	if region_override then
		local spawn_distance = cm:random_number(30, 10)

		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
			episode_chaos_invasion.invasion_faction_key,
			region_override,
			false,
			true,
			spawn_distance
		)
	elseif spawn_position then
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_position(episode_chaos_invasion.invasion_faction_key, spawn_position.x, spawn_position.y, true)
	end
	if x_pos == -1 or y_pos == -1 then
		script_error("CHAOS INVASION: Failed to generate generic army spawn position")
	end
	region_key = cm:get_region_data_at_position(x_pos, y_pos):key()

	if army_override then
		unit_list = episode_chaos_invasion.chaos_invasion_armies[army_override].units
		force_bundle = episode_chaos_invasion.chaos_invasion_armies[army_override].bundle

		if episode_chaos_invasion.chaos_invasion_armies[army_override].valid_lords then
			cm:shuffle_table(episode_chaos_invasion.chaos_invasion_armies[army_override].valid_lords)
			lord_subtype = episode_chaos_invasion.chaos_invasion_armies[army_override].valid_lords[1]
		end
	else
		local possible_armies = weighted_list:new()

		for army_key, army_details in dpairs(episode_chaos_invasion.chaos_invasion_armies) do
			-- Only armies with weights can be randomly spawned
			if army_details.weight then
				possible_armies:add_item(army_key, army_details.weight)
			end
		end

		local selected_army, index = possible_armies:weighted_select()
		unit_list = episode_chaos_invasion.chaos_invasion_armies[selected_army].units
		force_bundle = episode_chaos_invasion.chaos_invasion_armies[selected_army].bundle
	end

	out.invasions("\tcreate_invasion_force  -  "..lord_subtype.." ("..x_pos..", "..y_pos..")")
	local character = cm:create_force_with_general(
		episode_chaos_invasion.invasion_faction_key,
		unit_list,
		region_key,
		x_pos,
		y_pos,
		"general",
		lord_subtype,
		"",	"",	"",	"",
		false,
		function(char_cqi, force_cqi)
			local character_lookup = cm:char_lookup_str(char_cqi)
			cm:add_experience_to_units_commanded_by_character(character_lookup, episode_chaos_invasion.starting_unit_rank_low)
			cm:apply_effect_bundle_to_force(force_bundle, force_cqi, 0)
			cm:apply_effect_bundle_to_force("wh3_main_effect_force_total_autoresolve_victory", force_cqi, 0)
			
			local tracker = {}
			tracker.char_cqi = char_cqi
			tracker.force_cqi = force_cqi
			tracker.legendary = false
			table.insert(episode_chaos_invasion.persistent.invasion_forces, tracker)
			out.invasions("Spawned "..char_cqi)
		end
	)
	if character:is_null_interface() == false then
		local character_details = character:character_details()
		cm:character_details_set_rank(character_details, episode_chaos_invasion.starting_lord_rank_low, false)
	end
end

episode_chaos_invasion.create_dark_fortress = function(self, region_key, fortress_details)
	local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
		episode_chaos_invasion.invasion_faction_key, 
		region_key, 
		false, 
		true, 
		20
	)
	if x_pos == -1 or y_pos == -1 then
		script_error("CHAOS INVASION: Failed to generate Fortress spawn position")
	end
	region_key = cm:get_region_data_at_position(x_pos, y_pos):key()

	local unit_list = episode_chaos_invasion.chaos_invasion_armies[fortress_details.army_key].units

	local character = cm:create_force_with_general(
		episode_chaos_invasion.invasion_faction_key,
		unit_list,
		region_key,
		x_pos,
		y_pos,
		"general",
		episode_chaos_invasion.dark_fortress_subtype_key,
		fortress_details.character_name, "", "", "",
		false,
		function(char_cqi, force_cqi)
			-- Track this fortress so we can issue missions related to it later
			local family_member_cqi = cm:get_character_by_cqi(char_cqi):family_member():command_queue_index()
			table.insert(episode_chaos_invasion.persistent.dark_fortresses, force_cqi)

			local character_lookup = cm:char_lookup_str(char_cqi)
			cm:set_character_unique(character_lookup, true)
			cm:force_character_force_into_stance(character_lookup, episode_chaos_invasion.dark_fortress_stance)
			cm:disable_movement_for_character(character_lookup)
			cm:apply_effect_bundle_to_force(episode_chaos_invasion.chaos_invasion_armies[fortress_details.army_key].bundle, force_cqi, 0)
			cm:apply_effect_bundle_to_force("wh3_main_effect_force_total_autoresolve_victory", force_cqi, 0)
			cm:add_experience_to_units_commanded_by_character(character_lookup, episode_chaos_invasion.starting_unit_rank_high)
			cm:cai_disable_targeting_against_character(character_lookup)

			-- Reveal this region to the players, also reveal the character as sometimes region alone isn't enough
			episode_chaos_invasion:reveal_region_to_humans(region_key)
			episode_chaos_invasion:reveal_character_to_humans(character_lookup, 999)
		end
	)
	if character:is_null_interface() == false then
		local character_details = character:character_details()
		cm:character_details_set_rank(character_details, episode_chaos_invasion.starting_lord_rank_high, false)
	end

	-- Corrupt the region with the relevant chaos corruption
	local region = cm:get_region(region_key)
	cm:change_corruption_in_province_by(region:province_name(), fortress_details.corruption_key, 100, "events")
end

episode_chaos_invasion.build_spawn_position_weighted_list = function(self, area_key)
	if episode_chaos_invasion.invasion_spawn_positions[area_key] then
		local possible_spawn_positions = weighted_list:new()

		for _, group in ipairs(episode_chaos_invasion.invasion_spawn_positions[area_key].position_groups) do
			for _, position in ipairs(group.positions) do
				local new_pos = {x = position[1], y = position[2]}
				possible_spawn_positions:add_item(new_pos, group.weight)
			end
		end
		return possible_spawn_positions
	else
		script_error("CHAOS INVASION: Tried to generate a spawn position list without a valid area key - "..tostring(area_key))
	end
end

episode_chaos_invasion.ensure_invasion_characters_are_unique = function(self)
	local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	if not is_faction(invasion_faction) or invasion_faction:is_dead() then
		return
	end

	local character_list = invasion_faction:character_list()
	for char_index = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(char_index)
		if character:is_null_interface() == false then
			local character_subtype = character:character_details():character_subtype_key()
			if character_subtype == episode_chaos_invasion.archaon_subtype_key
				or character_subtype == episode_chaos_invasion.dark_fortress_subtype_key
				or episode_chaos_invasion.chaos_legendary_lords[character_subtype] ~= nil
			then
				cm:set_character_unique(cm:char_lookup_str(character), true)
			end
		end
	end
end

episode_chaos_invasion.update_archaon_effects = function(self, apply_autoresolve_bundle)
	local archaon_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	local archaon_char = nil
	local character_list = archaon_faction:character_list()

	for char_index = character_list:num_items() - 1, 0, -1 do
		local character = character_list:item_at(char_index)

		if character:character_subtype(episode_chaos_invasion.archaon_subtype_key) == true then
			archaon_char = character
			break
		end
	end

	local active_dark_fortress_count = cm:get_factions_bonus_value(archaon_faction, "endgame_chaos_fortress")
	local active_invasion_force_count = cm:get_factions_bonus_value(archaon_faction, "endgame_invasion_force")
	local ward_save_value = 0

	if archaon_char and archaon_char:is_null_interface() == false and archaon_char:has_military_force() == true then
		local archaon_mf = archaon_char:military_force()
		local force_cqi = archaon_mf:command_queue_index()

		local bundle_key = episode_chaos_invasion.chaos_invasion_armies["archaon"].bundle
		local bundle = cm:create_new_custom_effect_bundle(bundle_key)
		
		if bundle:is_null_interface() == false then
			local total_invasion_value = (10 * active_dark_fortress_count) + (1 * active_invasion_force_count)

			for _, effect in pairs(episode_chaos_invasion.archaon_force_effect_list) do
				-- Some effects require the Ward Save bonus to be at a certain value to appear
				if effect.required_bonus == nil or total_invasion_value >= effect.required_bonus then
					if effect.value_type == "STATIC" then
						-- These effects value are always constant
						bundle:add_effect(effect.key, effect.scope, effect.value)
						out("update_archaon_effects -- "..effect.key.." - "..effect.value)
					elseif effect.value_type == "INVASION_VALUE" then
						-- These effects value are modified based on the total invasion value
						local updated_value = effect.value * total_invasion_value
						bundle:add_effect(effect.key, effect.scope, updated_value)
						out("update_archaon_effects -- "..effect.key.." - "..updated_value)

						if effect.key == "wh3_main_effect_force_stat_ward_save_endgame" then
							ward_save_value = updated_value
						end
					elseif effect.value_type == "FORTRESS_COUNT" then
						-- These effects value are modified based on the remaining amount of fortresses
						local updated_value = effect.value * active_dark_fortress_count
						bundle:add_effect(effect.key, effect.scope, updated_value)
						out("update_archaon_effects -- "..effect.key.." - "..updated_value)
					elseif effect.value_type == "FORCE_COUNT" then
						-- These effects value are modified based on the remaining amount of invasion armies
						local updated_value = effect.value * active_invasion_force_count
						bundle:add_effect(effect.key, effect.scope, updated_value)
						out("update_archaon_effects -- "..effect.key.." - "..updated_value)
					else
						script_error("Unknown value_type in Chaos invasion bonuses: "..effect.value_type)
					end
				end
			end
			out("update_archaon_effects -- apply bundle - "..force_cqi)
			bundle:set_duration(0)
			cm:apply_custom_effect_bundle_to_force(bundle, archaon_mf)
		end

		if apply_autoresolve_bundle then
			cm:apply_effect_bundle_to_force("wh3_main_effect_force_total_autoresolve_victory", force_cqi, 0)
		end
	end
	cm:set_script_state("dark_fortress_current_count", active_dark_fortress_count)
	cm:set_script_state("invasion_forces_current_count", active_invasion_force_count)
	cm:set_script_state("invasion_ward_save", ward_save_value)
end

episode_chaos_invasion.dark_fortress_destroyed = function(self)
	if episode_chaos_invasion.persistent.dilemmas["good"] == nil then
		episode_chaos_invasion.persistent.dilemmas["good"] = true
		episode_chaos_invasion:trigger_endgame_dilemma(episode_chaos_invasion.dilemmas.good.key)
		episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_archaon_004")
	end
end

episode_chaos_invasion.update_razed_region = function(self, region_key)
	out.invasions("update_razed_region - "..region_key)
	-- Regions razed during the endgame get a bundle (different to the bundle given to all regions in a devastated province)
	cm:apply_effect_bundle_to_region(episode_chaos_invasion.devastated_region_bundle, region_key, 0)
	
	-- Stop the CAI from trying to resettle
	cm:cai_disable_targeting_against_settlement("settlement:"..region_key)
	
	-- Check the province to see if it is now devastated
	episode_chaos_invasion:update_province_devastation_for_region(region_key, false)

	-- Update the "total world razed" tooltip
	local razed_percent = episode_chaos_invasion:update_world_razed_count()

	if razed_percent >= 50 and episode_chaos_invasion.persistent.dilemmas["bad"] == nil then
		episode_chaos_invasion.persistent.dilemmas["bad"] = true
		episode_chaos_invasion:trigger_endgame_dilemma(episode_chaos_invasion.dilemmas.bad.key)
	end
	if razed_percent >= 90 and episode_chaos_invasion.persistent.dilemmas["end"] == nil then
		episode_chaos_invasion.persistent.dilemmas["end"] = true
		episode_chaos_invasion:trigger_endgame_dilemma(episode_chaos_invasion.dilemmas.ending.key)
	end
end

episode_chaos_invasion.reveal_region_to_humans = function(self, region_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		cm:make_region_visible_in_shroud(faction_key, region_key)
	end
end

episode_chaos_invasion.reveal_character_to_humans = function(self, character_lookup, duration)
	duration = duration or 1
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		cm:make_character_seen_in_shroud(character_lookup, faction_key, duration)
	end
end

episode_chaos_invasion.zoom_camera_to_archaon = function(self, archaon_cqi)
	local archaon = cm:get_character_by_cqi(archaon_cqi)

	if archaon and archaon:is_null_interface() == false then
		local archaon_x = archaon:display_position_x()
		local archaon_y = archaon:display_position_y()
		cm:set_camera_position(archaon_x, archaon_y, 13, 0, 10)
	end
end

episode_chaos_invasion.should_region_be_devastated = function(self, region_obj)
	local region_list = region_obj:regions_in_same_event_area()
	if (not region_list) or region_list:is_null_interface() then
		return false
	end

	local region_count = region_list:num_items()
	if region_count == 0 then
		-- this should never happen
		script_error("ERROR: region with zero regions in its event area! [" .. region_obj:name() .. "]!");
		return false
	end

	local razed_regions = 0

	for i = 0, region_count - 1 do
		local region = region_list:item_at(i)

		if region:is_abandoned() == true then
			razed_regions = razed_regions + 1
		end
	end
	
	-- During this endgame provinces with 50% or more of their regions razed get devastated
	local razed_ratio = razed_regions / region_count
	if razed_ratio < 0.5 then
		return false
	end

	return true
end

episode_chaos_invasion.update_province_devastation_for_region = function(self, region_key, force_devastation)
	local region_obj = cm:get_region(region_key)
	if is_region(region_obj) == false then
		return false
	end

	local is_devastated = devastation_manager:is_region_devastated(region_key)
	local should_be_devastated = force_devastation or self:should_region_be_devastated(region_obj)

	if should_be_devastated and is_devastated then
		-- region is already devastated
		return false
	end

	if should_be_devastated == false and is_devastated == false then
		-- no need to devastate it
		return false
	end

	if should_be_devastated then
		-- The region and all other regions in the same area should be devastated
		devastation_manager:devastate_region(
			region_key, 
			self.invasion_culture_key,
			"chaos_devastation",
			self.devastated_province_bundle -- this is the region bundle, I'm not sure why it's called province 
		)
	else
		devastation_manager:remove_devastation(region_key)
	end
end

episode_chaos_invasion.get_invasion_spawn_regions = function(self, amount)
	local spawn_regions = {}
	local player_border_regions = {}
	local player_capital_regions = {}
	local human_factions = cm:get_human_factions()

	--------------------------------------------------------------------------------------------------
	---- Find all border regions belonging to players (regions with an adjacent foreign region)   ----
	---- Port regions count as borders so that nearby islands and passable rivers aren't problems ----
	---- If the player is a horde use the regions their armies are in as their 'owned' regions    ----
	---- All provinces in which a player currently resides is added to an exclusion list          ----
	--------------------------------------------------------------------------------------------------
	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)
		local region_list = faction:region_list()

		if region_list:num_items() > 0 then
			local faction_cqi = faction:command_queue_index()
		
			if faction:has_home_region() == true then
				local capital = faction:home_region()
				local capital_x = capital:settlement():logical_position_x()
				local capital_y = capital:settlement():logical_position_y()
				table.insert(player_capital_regions, {x = capital_x, y = capital_y})
			end

			for region_index = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(region_index)
				local region_key = region:name()
				local province_name = region:province_name()
				episode_chaos_invasion.excluded_provinces_and_regions[province_name] = true

				if region:settlement():is_port() == true then
					player_border_regions[region_key] = region
				else
					local adjacent_regions = region:adjacent_region_list()

					for adj_region_index = 0, adjacent_regions:num_items() - 1 do 
						local adj_region = adjacent_regions:item_at(adj_region_index)

						if adj_region:owning_faction():command_queue_index() ~= faction_cqi then
							player_border_regions[region_key] = region
							break
						end
					end
				end
			end
		else
			local military_force_list = faction:military_force_list()

			for force_index = 0, military_force_list:num_items() - 1 do 
				local military_force = military_force_list:item_at(force_index)
				local general_character = military_force:general_character()
				local region = general_character:region()

				if region:is_null_interface() == false then
					local region_key = region:name()
					local province_name = region:province_name()
					player_border_regions[region_key] = region
					episode_chaos_invasion.excluded_provinces_and_regions[province_name] = true

					if general_character:is_faction_leader() == true then
						local capital_x = general_character:logical_position_x()
						local capital_y = general_character:logical_position_y()
						table.insert(player_capital_regions, {x = capital_x, y = capital_y})
					end
				end
			end
		end
	end

	------------------------------------------------------------------------------------------------------------
	---- For all regions calculate the closest player owned border region from the list we generated before ----
	---- We do this as we want to select regions that are closest to a pre-set distance away from players   ----
	---- Based on their closesness to this ideal distance we give them a score used in a weighted selection ----
	---- We exclude regions that fall outside of a pre-set tolerance (too far away from the ideal distance) ----
	---- Regions with exceptional scores (90+) are tracked separately as we'll primarily want to pick these ----
	---- All other regions that fall outside of the distance tolerance are still tracked as backup regions  ----
	------------------------------------------------------------------------------------------------------------
	local all_regions = cm:model():world():region_manager():region_list()
	local perfect_regions = weighted_list:new()
	local valid_regions = weighted_list:new()
	local backup_regions = {}
	local target_distance = episode_chaos_invasion.average_distance_to_adjacent_regions * episode_chaos_invasion.desired_region_distance_multiplier
	local distance_tolerance = target_distance * self.distance_tolerance_multiplier
	local minimum_distance = episode_chaos_invasion.average_distance_to_adjacent_regions * episode_chaos_invasion.minimum_distance_to_capitals_multiplier

	for i = 0, all_regions:num_items() -1 do
		local region = all_regions:item_at(i)
		local province_name = region:province_name()

		if not episode_chaos_invasion.excluded_provinces_and_regions[province_name] then
			local region_x = region:settlement():logical_position_x()
			local region_y = region:settlement():logical_position_y()

			-- First calculate the distance of this region to the player factions capitals, the region must be a minimum distance away
			-- This check prevents small empires ending up with spawns that are relatively close together around their empire
			local is_above_minimum_distance = true

			for _, capital_region in ipairs(player_capital_regions) do
				local distance = distance_squared(region_x, region_y, capital_region.x, capital_region.y)

				if distance < minimum_distance then
					is_above_minimum_distance = false
					break
				end
			end

			if is_above_minimum_distance == true then
				local closest_distance = 999999999
				
				for _, player_border in dpairs(player_border_regions) do
					local border_x = player_border:settlement():logical_position_x()
					local border_y = player_border:settlement():logical_position_y()
					local distance = distance_squared(region_x, region_y, border_x, border_y)

					if distance < closest_distance then
						closest_distance = distance
					end
				end

				-- Calculate a score between 0 - 100 for how close this region is to the desired distance
				local distance_difference = math.abs(closest_distance - target_distance)
				local distance_score = 0

				if distance_difference < distance_tolerance then
					distance_score = (1 - distance_difference / distance_tolerance) * 100
				end
				distance_score = math.floor(distance_score)
				-- Track regions with a score of 90 or higher in another list, 
				if distance_score >= 90 then
					perfect_regions:add_item(region, distance_score)
				elseif distance_score > 0 then
					valid_regions:add_item(region, distance_score)
				else
					table.insert(backup_regions, region)
				end
			end
		end
	end

	--------------------------------------------------------------------------------------------------------------
	---- SINGLEPLAYER -- Assuming the player has a capital region we can be more selective in our approach    ----
	---- We want the selected regions to be evenly spread around the circumference of the players empire      ----
	---- We will divide all regions into a number of groups equal to the amount of regions we want to select  ----
	---- These groups will hold all regions within that slice based on their direction to the players capital ----
	---- Like slices of a pie we then take a region from each slice, ensuring the region spawns are in all    ----
	---- directions from what is likely to be the centre of the players empire (their capital region)         ----
	--------------------------------------------------------------------------------------------------------------
	local primary_player_faction_key = human_factions[1]
	local primary_player_faction = cm:get_faction(primary_player_faction_key)
	local skip_sector_selection = false

	if #perfect_regions.items < amount then
		-- Theres not much point in the complex selection unless there are enough regions
		skip_sector_selection = true
	end

	if skip_sector_selection == false and cm:is_multiplayer() == false and primary_player_faction:has_home_region() == true then
		local capital = primary_player_faction:home_region()
		local capital_x = capital:settlement():logical_position_x()
		local capital_y = capital:settlement():logical_position_y()

		local two_pi = math.pi * 2
		local sector_size = two_pi / amount
		local sectors = {}
		
		for i = 1, amount do
			local sector_list = weighted_list:new()
			table.insert(sectors, sector_list)
		end

		for _, perfect_region in ipairs(perfect_regions.items) do
			local region = perfect_region.item
			local region_x = region:settlement():logical_position_x()
			local region_y = region:settlement():logical_position_y()
			local dx = region_x - capital_x
			local dy = region_y - capital_y
			local angle = math.atan(dy, dx)

			if angle < 0 then
				angle = angle + two_pi
			end

			-- Determine which sector to go into based on its angle direction to the capital
			local sector_index = math.floor(angle / sector_size) + 1
			sectors[sector_index]:add_item(perfect_region.item, perfect_region.weight)
		end

		-- All regions are divided into their respective sectors, so now we can do a weighted select on each
		-- If a sector doesn't have any regions we simply roll to the next
		-- Its safe to do this as we know there are at least the amount of total regions needed across all sectors
		local sector_index = 1

		while #spawn_regions < amount do
			if #sectors[sector_index].items > 0 then
				local region, index = sectors[sector_index]:weighted_select(true)
				local region_key = region:name()
				table.insert(spawn_regions, region_key)
			end

			sector_index = sector_index + 1

			if sector_index > amount then
				sector_index = 1
			end
		end
	else
	----------------------------------------------------------------------------------------------------
	---- MULTIPALYER -- We simply do a weighted select from the perfect regions because unlike with ----
	---- a single human player we can't easily compute a central point from which to divide regions ----
	----------------------------------------------------------------------------------------------------
		while #perfect_regions.items > 0 and #spawn_regions < amount do
			local region, index = perfect_regions:weighted_select(true)
			local region_key = region:name()
			table.insert(spawn_regions, region_key)
		end
	end

	---------------------------------------------------------------------------------------------------
	---- If we run out of perfect regions we'll use the valid regions (those inside the tolerance  ----
	---- Beyond that we take from the backup region list as the second backup option               ----
	---- Lastly if we still don't have enough regions we take from the pre-set list of region keys ----
	---------------------------------------------------------------------------------------------------
	if #spawn_regions < amount then
		-- First Backup - Do a weighted select of the valid regions
		while #valid_regions.items > 0 and #spawn_regions < amount do
			local region, index = valid_regions:weighted_select(true)
			local region_key = region:name()
			table.insert(spawn_regions, region_key)
		end
	end
	if #spawn_regions < amount then
		-- Second Backup - We take randomly from the backup region list
		cm:shuffle_table(backup_regions)
		local backup_index = 1

		while #spawn_regions < amount and #backup_regions >= backup_index do
			table.insert(spawn_regions, backup_regions[backup_index]:name())
			backup_index = backup_index + 1
		end
	end
	if #spawn_regions < amount then
		-- Final Backup - We take from the pre-selected regions
		cm:shuffle_table(episode_chaos_invasion.backup_spawn_regions)
		local backup_index = 1

		-- we have enough hardcoded regions for the fallback, but just in case a mod removes them
		while #spawn_regions < amount and backup_index <= #episode_chaos_invasion.backup_spawn_regions do
			table.insert(spawn_regions, episode_chaos_invasion.backup_spawn_regions[backup_index])
			backup_index = backup_index + 1
		end
	end
	return spawn_regions
end

episode_chaos_invasion.override_dark_fortress_map_for_pending_battle = function(self)
	if not cm:model() then
		return -- this could be called from loading
	end
	if cm:pending_battle_cache_human_is_involved() == false then
		return -- no need to override maps for AI
	end

	local pending_battle = cm:model():pending_battle()

	local region_data = pending_battle:region_data()
	if region_data:is_null_interface() then
		return
	end

	local region = region_data:region()
	if region:is_null_interface() then
		return
	end

	-- Batle Map Priority Order
	-- Battles in which a fortress is attacked = always use a chaos fortress map override
	-- Battles in a province in which a fortress is located = realms maps override
	-- Devastation maps are themselves a map override, but realms maps should take priority
	local fortress_region_bonus_value = cm:get_regions_bonus_value(region, "endgame_chaos_fortress_map")

	if fortress_region_bonus_value > 0 then
		local region_key = region:name()
		local battle_map_key = ""
		local battle_catchment_key = ""
		local battle_type = pending_battle:battle_type()
		local battle_pos_x, battle_pos_y = cm:model():pending_battle():logical_position()
		local defender = pending_battle:defender()
		local defender_military_force = defender:military_force()

		-- We need to determine if we're looking for a land battle map or a fortress map
		if defender_military_force:faction():name() == episode_chaos_invasion.invasion_faction_key then
			if defender:character_subtype(episode_chaos_invasion.dark_fortress_subtype_key) == true or defender_military_force:active_stance() == episode_chaos_invasion.dark_fortress_stance then
				-- We set a default fortress map because unlike land battles we will ALWAYS want to override a fortress map, nomatter what happens in the following corruption check
				battle_type = "fortress"
				battle_map_key = "minor_p_chs"
				battle_catchment_key = ""
			end
		end
		
		-- We now search for the correct variant of the map to use based on province corruption levels
		for _, fortress_details in pairs(episode_chaos_invasion.dark_fortress_details) do
			local corruption = region:province():pooled_resource_manager():resource(fortress_details.corruption_key)

			if corruption:is_null_interface() == false and corruption:value() > 99 then
				local battle_map_list = fortress_details.battle_maps.land

				if battle_type == "fortress" then
					battle_map_list = fortress_details.battle_maps.fortress
				elseif battle_type == "land_ambush" then
					battle_map_list = fortress_details.battle_maps.ambush
				elseif battle_type == "land_bridge" then
					battle_map_list = fortress_details.battle_maps.chokepoint
				end
					
				-- Fortress with no specififed maps means there is no intention to override the map and the battlemap will likely fallback to a devastation override unless we find a relevant corruption
				if battle_map_list and #battle_map_list > 1 then
					-- We want to randomly select a battlemap from the list of possible maps for the relevant corruption type, but players expect the same battlemap to occur at the same positions
					-- To maintain the same battlemap at the same position we do a sudo-random roll that is deterministic based on the logical position coordinates of the battle
					local hash = battle_pos_x * 73856093 + battle_pos_y * 19349663
					hash = math.abs(hash)
					local index = (hash % #battle_map_list) + 1
					index = math.clamp(index, 1, #battle_map_list)
					battle_map_key = battle_map_list[index].macro
					battle_catchment_key = battle_map_list[index].catchment
					if fortress_details.tile_upgrade ~= "" then
						cm:pending_battle_add_scripted_tile_upgrade_tag(fortress_details.tile_upgrade)
					end
					break
				end
			end
		end

		out("set_battle_details_override_for_region - "..region_key.." - "..battle_type.." - "..battle_map_key.." - "..battle_catchment_key)

		if battle_map_key ~= "" or battle_catchment_key ~= "" then
			battle_type = pending_battle:battle_type()
			cm:set_battle_details_override_for_region(region_key, battle_type, battle_map_key, battle_catchment_key)
			cm:pending_battle_add_scripted_tile_upgrade_tag("chaos_invasion_map_override")
			cm:update_pending_battle()
		end
	end
end

episode_chaos_invasion.remove_dark_fortress_map_override_for_last_battle = function(self)
	local pending_battle = cm:model():pending_battle()
	
	local region_data = pending_battle:region_data()
	if region_data:is_null_interface() then
		return
	end

	local region = region_data:region()
	if region:is_null_interface() then
		return
	end
	
	if pending_battle:has_scripted_tile_upgrade("chaos_invasion_map_override") == true then
		local region_key = region:name()
		local battle_type = pending_battle:battle_type()
		out("remove_dark_fortress_map_override_for_last_battle - "..region_key.." - "..battle_type)
		cm:set_battle_details_override_for_region(region_key, battle_type, "", "")
		cm:pending_battle_remove_scripted_tile_upgrade_tags("chaos_invasion_map_override")
		cm:pending_battle_remove_scripted_tile_upgrade_tags("battle_corruption_khorne")
		cm:pending_battle_remove_scripted_tile_upgrade_tags("battle_corruption_slaanesh")
		cm:pending_battle_remove_scripted_tile_upgrade_tags("battle_corruption_tzeentch")
		cm:pending_battle_remove_scripted_tile_upgrade_tags("battle_corruption_nurgle")
	end
end

episode_chaos_invasion.remove_autoresolve_bonus_from_battle = function(self)
	if cm:pending_battle_cache_human_is_involved() then
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
			cm:remove_effect_bundle_from_force("wh3_main_effect_force_total_autoresolve_victory", current_mf_cqi)
		end
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
			cm:remove_effect_bundle_from_force("wh3_main_effect_force_total_autoresolve_victory", current_mf_cqi)
		end
		cm:update_pending_battle()
	end
end

episode_chaos_invasion.toggle_endgame_ui = function(self)
	cm:set_script_state("current_episode_popup", episode_chaos_invasion.foreshadow_main_event_key)
	common.call_context_command("ToggleHUDPanel('dlc29_endgame_crisis_scenarios')")
end

episode_chaos_invasion.update_world_razed_count = function(self)
	local region_list = cm:model():world():region_manager():region_list()
	local razed_total = 0

	for _, region in model_pairs(region_list) do
		if region:is_abandoned() == true then
			razed_total = razed_total + 1
		end
	end
	local razed_percent = (razed_total / region_list:num_items()) * 100
	cm:set_script_state("invasion_world_razed", razed_percent)
	self.persistent.world_razed_percentage = razed_percent
	return razed_percent or 0
end

episode_chaos_invasion.play_endgame_movie = function(self)
	core:svr_save_registry_bool(episode_chaos_invasion.movie_registry, true)
	cm:register_instant_movie(episode_chaos_invasion.movie_path)
end

episode_chaos_invasion.is_main_invasion_active = function(self)
	local current_stage_index = episode_chaos_invasion.persistent.current_stage_index
	local invasion_index = episodes_manager:get_episode_stage_index_by_name(episode_chaos_invasion, "episode_chaos_invasion_stage_main")
	local final_battle_index = episodes_manager:get_episode_stage_index_by_name(episode_chaos_invasion, "episode_chaos_invasion_stage_battle")
	return episode_chaos_invasion.persistent.invasion_spawned and is_number(current_stage_index) and (current_stage_index == invasion_index or current_stage_index == final_battle_index)
end

episode_chaos_invasion.set_final_battle_modifiers = function(self)
	local currently_world_razed_percentage = self.persistent.world_razed_percentage or 0
	local active_treshhold_index = -1
	for index, razed_threshold in ipairs(self.razed_thresholds) do
		-- we are interested in the highest index that meets the requirements
		if razed_threshold.required_world_razed_percentage <= currently_world_razed_percentage then
			active_treshhold_index = index
		end
	end

	for index, devastation_thresholds in ipairs(self.razed_thresholds) do
		core:svr_save_bool(devastation_thresholds.battle_parameter, index == active_treshhold_index)
	end
end

episode_chaos_invasion.play_voiceline = function(self, adivce_level)
	core:cache_and_set_advisor_priority(1500, true)
	cm:show_advice(adivce_level, true, false, nil, 0, 0)
end

episode_chaos_invasion.is_available_this_game = function(self)
	-- First check the frontend setting to make sure it was enabled
	local episode_enabled = cm:model():shared_states_manager():get_state_as_bool_value(episode_chaos_invasion.episode_frontend_enabled_shared_state_key)

	-- this is checked in is_episode_enabled_from_frontend so I'm not sure we need it here as well
	if not episode_enabled then
		episode_chaos_invasion.episode_disabled = true
		return false
	end

	-- The episode is available when we have an Archaon faction and the Invasion faction
	-- This should never be invalid criteria, so we should throw a script error in both cases
	-- If we have Archaons faction we also check he is not human, but this is ok to fail
	local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	if not is_faction(invasion_faction) then
		script_error("CHAOS INVASION: Invasion faction was nil or null interface")
		return false
	end

	local archaon_faction = cm:get_faction(episode_chaos_invasion.archaon_faction_key)
	if archaon_faction == nil or archaon_faction:is_null_interface() then
		script_error("CHAOS INVASION: Archaon faction was nil or null interface")
	elseif archaon_faction:is_human() == true then
		return false
	end
	return true
end

episode_chaos_invasion.can_start = function(self)
	return true
end

episode_chaos_invasion.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
	cm:set_script_state(episode_chaos_invasion.episode_active_shared_state, true)
end

-- checks if other_faction_obj is a vassal. if so - declaring_faction declares war on their overlord. 
-- otherwise declaring_faction declares war on other_faction_obj directly
episode_chaos_invasion.declare_war_on_faction_or_overlord = function(self, declaring_faction, other_faction_obj, give_diplomatic_bundle--[[ = true --]], chaos_factions)
	if give_diplomatic_bundle == nil then
		give_diplomatic_bundle = true
	end
	local declaring_faction_key = declaring_faction:name()
	local other_faction_key = other_faction_obj:name()

	if other_faction_key == declaring_faction_key
		or other_faction_obj:is_dead()
		or other_faction_obj:is_vassal_of(declaring_faction)
		or declaring_faction:is_vassal_of(other_faction_obj)
	then
		return
	end
	if give_diplomatic_bundle then
		-- all factions fighting against the invasion faction get a bundle so they support each other
		cm:apply_effect_bundle(self.diplomacy_bundle, other_faction_key, 0)
	end
	if other_faction_obj:at_war_with(declaring_faction) then
		return
	end
	if other_faction_obj:is_vassal() == false then
		-- If this faction is not a vassal, declare war on them
		cm:force_declare_war(declaring_faction_key, other_faction_key, false, false)
	else
		-- otherwise declare war on their master to avoid issues
		local master_faction = other_faction_obj:master()
		if master_faction:at_war_with(declaring_faction) == false and master_faction:is_dead() == false then
			local master_faction_key = other_faction_obj:master():name()
			if is_table(chaos_factions) == false or chaos_factions[master_faction_key] == nil then
				cm:force_declare_war(declaring_faction_key, master_faction_key, false, false)
				if give_diplomatic_bundle then
					-- we give the bundle to the master as well
					cm:apply_effect_bundle(self.diplomacy_bundle, master_faction_key, 0)
				end
			end
		end
	end
end

episode_chaos_invasion.on_episode_end = function(self)
	cm:remove_script_state("invasion_regions_razed")
	cm:remove_script_state("dark_fortress_initial_count")
	cm:remove_script_state("dark_fortress_current_count")
	cm:remove_script_state("invasion_forces_current_count")
	cm:remove_script_state("invasion_forces_initial_count")
	cm:remove_script_state("invasion_ward_save")
	cm:remove_script_state("invasion_world_razed")
end

---------------
-- LISTENERS --
---------------

--chaos_invasion_FactionTurnStart
core:add_listener(
	"chaos_invasion_FactionTurnStart",
	"FactionTurnStart",
	function(context)
		return episode_chaos_invasion:is_main_invasion_active()
	end,
	function(context)
		local faction = context:faction()
		local faction_key = faction:name()

		local chaos_factions = episode_chaos_invasion:get_chaos_alligned_factions()
		if chaos_factions[faction_key] then -- We want to avoid doing anything with other Chaos factions
			-- this should not happen, but just in case
			return
		end
		local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)

		if faction_key ~= episode_chaos_invasion.invasion_faction_key 
				and faction:allied_with(invasion_faction) == false
				and faction:at_war_with(invasion_faction) == false
				and faction:is_rebel() == false
		then
			-- If this isn't the invasion faction or one of its allies, then this faction gets declared war on by them
			episode_chaos_invasion:declare_war_on_faction_or_overlord(invasion_faction, faction, true, chaos_factions)

			local allied_factions = invasion_faction:factions_allied_with()
			-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
			cm:postpone_cai_analysis()
			for _, allied_faction in model_pairs(allied_factions) do
				episode_chaos_invasion:declare_war_on_faction_or_overlord(allied_faction, faction, true, chaos_factions)
			end
			cm:resume_cai_analysis()
		end
	end,
	true
)

--chaos_invasion_effects_FactionTurnEnd
core:add_listener(
	"chaos_invasion_effects_FactionTurnEnd",
	"FactionTurnEnd",
	function(context)
		return episode_chaos_invasion:is_main_invasion_active() and context:faction():name() == episode_chaos_invasion.invasion_faction_key
	end,
	function(context)
		episode_chaos_invasion:update_archaon_effects()
	end,
	true
)

--chaos_invasion_FactionTurnEnd
core:add_listener(
	"chaos_invasion_FactionTurnEnd",
	"FactionTurnEnd",
	function(context)
		return context:faction():name() == episode_chaos_invasion.invasion_faction_key and episode_chaos_invasion.persistent.dilemmas["alone"] == nil
	end,
	function(context)
		local non_human_non_chaos_alive = false
		local all_factions = cm:get_faction_list()

		for i = 0, all_factions:num_items() - 1 do
			local other_faction = all_factions:item_at(i)
			local other_faction_key = other_faction:name()

			if other_faction:is_human() == false and other_faction_key ~= episode_chaos_invasion.invasion_faction_key then
				if other_faction:is_dead() == false and (other_faction:has_home_region() == true or other_faction:military_force_list():is_empty() == false) then
					non_human_non_chaos_alive = true
				end
			end
		end
		if non_human_non_chaos_alive == false then
			episode_chaos_invasion.persistent.dilemmas["alone"] = true
			episode_chaos_invasion:trigger_endgame_dilemma(episode_chaos_invasion.dilemmas.alone.key)
		end
	end,
	true
)

--chaos_invasion_PendingBattle
core:add_listener(
	"chaos_invasion_PendingBattle",
	"PendingBattle",
	function(context)
		return episode_chaos_invasion:is_main_invasion_active()
	end,
	function(context)
		episode_chaos_invasion:override_dark_fortress_map_for_pending_battle()
		local pb = cm:model():pending_battle();
		if pb:quest_mission_key() == episode_chaos_invasion.final_battle_mission_key then
			episode_chaos_invasion:set_final_battle_modifiers()

			cm:callback(function()
				episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_narrator_006")
			end, 0.5)
		end
		
		if pb:has_been_fought() == false and cm:pending_battle_cache_faction_is_involved(episode_chaos_invasion.invasion_faction_key) then
			local archaon_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)

			if archaon_faction and archaon_faction:is_null_interface() == false and cm:pending_battle_cache_char_is_involved(archaon_faction:faction_leader()) then
				local ward_save = cm:model():shared_states_manager():get_state_as_float_value("invasion_ward_save") or 0
				local required_bonus = 90

				for _, effect in ipairs(episode_chaos_invasion.archaon_force_effect_list) do
					if effect.key == "wh3_main_effect_force_enforce_autoresolver_battle" then
						required_bonus = effect.required_bonus
						break
					end
				end

				cm:win_next_autoresolve_battle(episode_chaos_invasion.invasion_faction_key)
				
				if cm:pending_battle_cache_char_is_attacker(archaon_faction:faction_leader()) then
					cm:modify_next_autoresolve_battle(1, 0, 1, 9, true)
				else
					cm:modify_next_autoresolve_battle(0, 1, 9, 1, true)
				end

				if ward_save < required_bonus then
					episode_chaos_invasion:remove_autoresolve_bonus_from_battle()
				end
			else
				episode_chaos_invasion:remove_autoresolve_bonus_from_battle()
			end
		end
	end,
	true
)

--chaos_invasion_BattleCompleted
core:add_listener(
	"chaos_invasion_BattleCompleted",
	"BattleCompleted",
	function()
		return episode_chaos_invasion:is_main_invasion_active()
	end,
	function(context)
		episode_chaos_invasion:remove_dark_fortress_map_override_for_last_battle()

		if cm:pending_battle_cache_faction_is_involved(episode_chaos_invasion.invasion_faction_key) then
			episode_chaos_invasion:update_archaon_effects(true)
		end
	end,
	true
)

--chaos_invasion_CharacterDestroyed
core:add_listener(
	"chaos_invasion_CharacterDestroyed",
	"CharacterDestroyed",
	function(context)
		-- Someone has defeated Archaon or a Dark Fortress during the main invasion stage
		return episode_chaos_invasion:is_main_invasion_active()
	end,
	function(context)
		local family_member = context:family_member()

		if family_member and family_member:is_null_interface() == false then
			local character_details = family_member:character_details()

			if character_details and character_details:is_null_interface() == false then
				if character_details:character_subtype(episode_chaos_invasion.archaon_subtype_key) then
					local current_stage_index = episode_chaos_invasion.persistent.current_stage_index
					local invasion_index = episodes_manager:get_episode_stage_index_by_name(episode_chaos_invasion, "episode_chaos_invasion_stage_main")
					-- if we are in the main stage invasion and we defeated Archaon, we advance to the final battle
					-- however, if we are in the final battle stage and we cancel the battle, the quest battle character is also destroyed and we should NOT advance
					if current_stage_index == invasion_index then
						episodes_manager:advance_stage(episode_chaos_invasion, episode_chaos_invasion.persistent.current_stage_index)
					end
				elseif character_details:character_subtype(episode_chaos_invasion.dark_fortress_subtype_key) then
					episode_chaos_invasion:dark_fortress_destroyed()
				end
			end
		end
	end,
	true
)

--chaos_invasion_DilemmaChoiceMadeEvent
core:add_listener(
	"chaos_invasion_DilemmaChoiceMadeEvent",
	"DilemmaChoiceMadeEvent",
	function(context)
		return episode_chaos_invasion.dilemma_join_invasion == context:dilemma()
	end,
	function(context)
		local faction = context:faction()
		local faction_key = faction:name()
		local choice = context:choice()

		local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
		if choice == 0 then

			-- Join the Invasion
			cm:force_make_peace(faction_key, episode_chaos_invasion.invasion_faction_key)
			cm:force_alliance(faction_key, episode_chaos_invasion.invasion_faction_key, true)

			-- Declare war on everyone you know
			local known_factions = faction:factions_met()

			-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
			cm:postpone_cai_analysis()

			for i = 0, known_factions:num_items() - 1 do
				local other_faction = known_factions:item_at(i)
				local other_faction_key = other_faction:name()

				if other_faction_key ~= faction_key and other_faction_key ~= episode_chaos_invasion.invasion_faction_key then
					if other_faction:allied_with(invasion_faction) == true then
						-- A previous dilemma offered faction may have already declared war on the world, meaning we'll need to make peace with them and ally
						cm:force_make_peace(faction_key, other_faction_key)
						cm:force_alliance(faction_key, other_faction_key, true)
					else
						episode_chaos_invasion:declare_war_on_faction_or_overlord(faction, other_faction, false)
					end
				end
			end

			-- Also declare war on everyone Archaon is already at war with
			local archaon_war_factions = invasion_faction:factions_at_war_with()

			for i = 0, archaon_war_factions:num_items() - 1 do
				local other_faction = archaon_war_factions:item_at(i)
				local other_faction_key = other_faction:name()
				episode_chaos_invasion:declare_war_on_faction_or_overlord(faction, other_faction, false)
			end

			cm:resume_cai_analysis()
			-- No more diplomacy allowed
			cm:force_diplomacy("all", "faction:"..faction_key, "all", false, false, true)
			cm:force_diplomacy("faction:"..faction_key, "all", "all", false, false, true)
		else
			-- Fight against Archaon
			episode_chaos_invasion:declare_war_on_faction_or_overlord(invasion_faction, faction, true)
			cm:apply_effect_bundle(episode_chaos_invasion.diplomacy_bundle, faction_key, 0)
			-- We can now issue relevant missions now we know they are enemies of the invasion
			episode_chaos_invasion:trigger_endgame_missions(faction_key)
		end

		-- We didn't show this player the custom event earlier, so we do it now they've closed the dilemma
		local local_faction_key = cm:get_local_faction_name(true)
	
		if local_faction_key == faction_key then
			episode_chaos_invasion:toggle_endgame_ui()
			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_chaos_archaon_003")
		end
	end,
	true
)

--chaos_invasion_MissionSucceeded
core:add_listener(
	"chaos_invasion_MissionSucceeded",
	"MissionSucceeded",
	function(context)
		-- Player has completed the final battle mission
		return episode_chaos_invasion:is_main_invasion_active() and context:mission():mission_record_key() == episode_chaos_invasion.final_battle_mission_key
	end,
	function(context)
		episodes_manager:advance_stage(episode_chaos_invasion, episode_chaos_invasion.persistent.current_stage_index)

		local faction_key = context:faction():name()
		local human_factions = cm:get_human_factions()

		-- Cancel the same mission that other players might have, its redundant now and episode progress is "shared" anyway
		for i = 1, #human_factions do
			if human_factions[i] ~= faction_key then
				cm:cancel_custom_mission(human_factions[i], episode_chaos_invasion.final_battle_mission_key)
			end
		end
	end,
	true
)

--chaos_invasion_RegionFactionChangeEvent
core:add_listener(
	"chaos_invasion_RegionFactionChangeEvent",
	"RegionFactionChangeEvent",
	function(context)
		local context_reason = context:reason()
		if episode_chaos_invasion:is_main_invasion_active() and context_reason == "abandoned" then
			return true
		end
		local devastation_culture = devastation_manager:get_region_devastation_culture(context:region():name())
		if episode_chaos_invasion.invasion_culture_key == devastation_culture and context_reason == "unopposed capture" then
			return true
		end
		return false
	end,
	function(context)
		local region_key = context:region():name()
		episode_chaos_invasion:update_razed_region(region_key)
	end,
	true
)

--chaos_invasion_CharacterRazedSettlement
core:add_listener(
	"chaos_invasion_CharacterRazedSettlement",
	"CharacterRazedSettlement",
	function(context)
		return episode_chaos_invasion:is_main_invasion_active()
	end,
	function(context)
		-- Track the number of regions razed by the endgame to show in the UI
		local razing_character = context:character()

		if razing_character:is_null_interface() == false then
			local razing_faction = razing_character:faction():name()

			if razing_faction == episode_chaos_invasion.invasion_faction_key then
				episode_chaos_invasion.persistent.regions_razed = episode_chaos_invasion.persistent.regions_razed + 1
				cm:set_script_state("invasion_regions_razed", episode_chaos_invasion.persistent.regions_razed)
			end
		end
	end,
	true
)

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_chaos_invasion:is_available_this_game() then
			return
		end
		episodes_manager:add_available_episode(episode_chaos_invasion)

		episode_chaos_invasion:generate_armies()

		if episode_chaos_invasion.persistent.legendary_lords == nil then
			-- Track all Chaos Legendary Lords - We'll need their family cqi's later so we can kill them
			episode_chaos_invasion.persistent.legendary_lords = {}
			local invasion_faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
			local faction_list = cm:model():world():lookup_factions_from_faction_set("chaos_invasion_chaos_alligned_all")

			for _, faction in model_pairs(faction_list) do
				if faction:is_null_interface() == false and faction:is_quest_battle_faction() == false and faction:is_rebel() == false and faction:is_faction(invasion_faction) == false then
					local faction_key = faction:name()
					local character_list = faction:character_list()

					for char_index = character_list:num_items() - 1, 0, -1 do
						local character = character_list:item_at(char_index)
						local character_details = character:character_details()
						local character_subtype = character_details:character_subtype_key()

						-- Check if this character is Legendary
						if episode_chaos_invasion.chaos_legendary_lords[character_subtype] then
							local family_member_cqi = character_details:family_member():command_queue_index()
							episode_chaos_invasion.persistent.legendary_lords[character_subtype] = family_member_cqi
						end
					end
				end
			end
		end
	end
)

episode_chaos_invasion.generate_armies = function(self)
	local ram = random_army_manager
	ram:new_force("CI_archaon")
	ram:new_force("CI_kholek")
	ram:new_force("CI_chaos")
	ram:new_force("CI_khorne")
	ram:new_force("CI_slaanesh")
	ram:new_force("CI_tzeentch")
	ram:new_force("CI_nurgle")
	ram:new_force("CI_norsca")
	ram:new_force("CI_beastmen")
	ram:new_force("CI_chaos_fortress")
	ram:new_force("CI_khorne_fortress")
	ram:new_force("CI_slaanesh_fortress")
	ram:new_force("CI_tzeentch_fortress")
	ram:new_force("CI_nurgle_fortress")
	
	-- ARCHAON
	ram:add_mandatory_unit("CI_archaon", "wh_pro04_chs_cav_chaos_knights_ror_0", 1)
	ram:add_mandatory_unit("CI_archaon", "wh_main_chs_cav_chaos_knights_0", 1)
	ram:add_mandatory_unit("CI_archaon", "wh_main_chs_cav_chaos_knights_1", 2)
	ram:add_mandatory_unit("CI_archaon", "wh_pro04_chs_art_hellcannon_ror_0", 1)
	ram:add_mandatory_unit("CI_archaon", "wh_main_chs_art_hellcannon", 1)
	ram:add_mandatory_unit("CI_archaon", "wh_dlc06_chs_inf_aspiring_champions_0", 2)
	ram:add_mandatory_unit("CI_archaon", "wh_main_chs_inf_chosen_0", 4)
	ram:add_mandatory_unit("CI_archaon", "wh_main_chs_inf_chosen_1", 4)
	ram:add_mandatory_unit("CI_archaon", "wh3_dlc29_chs_mon_chaos_siege_giant", 2)
	ram:add_mandatory_unit("CI_archaon", "wh3_dlc20_chs_mon_warshrine", 1)
	
	-- KHOLEK
	ram:add_mandatory_unit("CI_kholek", "wh_pro04_chs_mon_dragon_ogre_ror_0", 1)
	ram:add_mandatory_unit("CI_kholek", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 3)
	ram:add_mandatory_unit("CI_kholek", "wh_dlc01_chs_mon_dragon_ogre", 7)
	ram:add_mandatory_unit("CI_kholek", "wh_dlc01_chs_mon_trolls_1", 3)
	ram:add_mandatory_unit("CI_kholek", "wh_main_chs_mon_giant", 2)
	ram:add_mandatory_unit("CI_kholek", "wh3_dlc29_chs_mon_chaos_siege_giant", 2)
	ram:add_mandatory_unit("CI_kholek", "wh3_dlc20_chs_mon_warshrine", 1)
	
	-- STANDARD CHAOS
	ram:add_mandatory_unit("CI_chaos", "wh3_dlc20_chs_mon_warshrine", 1)
	ram:add_mandatory_unit("CI_chaos", "wh_main_chs_cav_chaos_knights_0", 3)
	ram:add_mandatory_unit("CI_chaos", "wh_main_chs_art_hellcannon", 2)
	ram:add_mandatory_unit("CI_chaos", "wh_dlc06_chs_inf_aspiring_champions_0", 2)
	ram:add_mandatory_unit("CI_chaos", "wh_main_chs_inf_chosen_0", 4)
	ram:add_mandatory_unit("CI_chaos", "wh_main_chs_inf_chosen_1", 4)
	ram:add_mandatory_unit("CI_chaos", "wh_main_chs_mon_giant", 1)
	ram:add_mandatory_unit("CI_chaos", "wh3_dlc29_chs_mon_chaos_siege_giant", 2)

	-- STANDARD KHORNE
	ram:add_mandatory_unit("CI_khorne", "wh3_dlc20_chs_mon_warshrine_mkho", 1)
	ram:add_mandatory_unit("CI_khorne", "wh3_dlc20_chs_cav_chaos_knights_mkho", 3)
	ram:add_mandatory_unit("CI_khorne", "wh_main_chs_art_hellcannon", 2)
	ram:add_mandatory_unit("CI_khorne", "wh3_dlc20_chs_inf_chosen_mkho", 4)
	ram:add_mandatory_unit("CI_khorne", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 4)
	ram:add_mandatory_unit("CI_khorne", "wh3_main_kho_mon_soul_grinder_0", 2)
	ram:add_mandatory_unit("CI_khorne", "wh3_dlc26_kho_mon_slaughterbrute", 1)
	ram:add_mandatory_unit("CI_khorne", "wh3_main_kho_mon_bloodthirster_0", 2)

	-- STANDARD SLAANESH
	ram:add_mandatory_unit("CI_slaanesh", "wh3_dlc20_chs_mon_warshrine_msla", 1)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_dlc20_chs_cav_chaos_knights_msla", 3)
	ram:add_mandatory_unit("CI_slaanesh", "wh_main_chs_art_hellcannon", 2)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_dlc20_chs_inf_chosen_msla", 4)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_dlc20_chs_inf_chosen_msla_hellscourges", 4)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_main_sla_mon_soul_grinder_0", 2)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_dlc27_sla_mon_preyton", 1)
	ram:add_mandatory_unit("CI_slaanesh", "wh3_main_sla_mon_keeper_of_secrets_0", 2)

	-- STANDARD TZEENTCH
	ram:add_mandatory_unit("CI_tzeentch", "wh3_dlc20_chs_mon_warshrine_mtze", 1)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_main_tze_cav_chaos_knights_0", 3)
	ram:add_mandatory_unit("CI_tzeentch", "wh_main_chs_art_hellcannon", 2)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_dlc20_chs_inf_chosen_mtze", 4)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_dlc20_chs_inf_chosen_mtze_halberds", 4)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_main_tze_mon_soul_grinder_0", 2)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_main_tze_mon_lord_of_change_0", 1)
	ram:add_mandatory_unit("CI_tzeentch", "wh3_dlc24_tze_mon_mutalith_vortex_beast", 2)

	-- STANDARD NURGLE
	ram:add_mandatory_unit("CI_nurgle", "wh3_dlc20_chs_mon_warshrine_mnur", 1)
	ram:add_mandatory_unit("CI_nurgle", "wh3_dlc20_chs_cav_chaos_knights_mnur", 3)
	ram:add_mandatory_unit("CI_nurgle", "wh_main_chs_art_hellcannon", 2)
	ram:add_mandatory_unit("CI_nurgle", "wh3_dlc20_chs_inf_chosen_mnur", 4)
	ram:add_mandatory_unit("CI_nurgle", "wh3_dlc20_chs_inf_chosen_mnur_greatweapons", 4)
	ram:add_mandatory_unit("CI_nurgle", "wh3_main_nur_mon_soul_grinder_0", 2)
	ram:add_mandatory_unit("CI_nurgle", "wh3_dlc25_nur_mon_toad_dragon", 1)
	ram:add_mandatory_unit("CI_nurgle", "wh3_main_nur_mon_great_unclean_one_0", 2)
	
	-- NORSCA
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_inf_marauder_champions_0", 5)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_inf_marauder_champions_1", 2)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_mon_fimir_0", 3)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_mon_skinwolves_1", 3)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_mon_war_mammoth_1", 2)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_mon_war_mammoth_2", 1)
	ram:add_mandatory_unit("CI_norsca", "wh3_dlc27_nor_mon_cursd_ettin", 1)
	ram:add_mandatory_unit("CI_norsca", "wh3_dlc27_nor_mon_cursd_ettin_runecaller", 1)
	ram:add_mandatory_unit("CI_norsca", "wh_dlc08_nor_mon_frost_wyrm_0", 1)
	
	-- BEASTMEN
	ram:add_mandatory_unit("CI_beastmen", "wh3_dlc26_kho_inf_khorngors", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh3_dlc24_tze_inf_tzaangors", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh3_dlc27_sla_inf_slaangors", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh3_dlc25_nur_inf_pestigors", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh_dlc03_bst_inf_bestigor_herd_0", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh_dlc03_bst_inf_minotaurs_0", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh_dlc03_bst_inf_minotaurs_1", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh_dlc03_bst_inf_cygor_0", 2)
	ram:add_mandatory_unit("CI_beastmen", "wh2_dlc17_bst_mon_ghorgon_0", 1)
	ram:add_mandatory_unit("CI_beastmen", "wh2_dlc17_bst_mon_jabberslythe_0", 1)
	ram:add_mandatory_unit("CI_beastmen", "wh3_dlc24_ksl_mon_incarnate_elemental_of_beasts", 1)

	-- CHAOS FORTRESS
	ram:add_mandatory_unit("CI_chaos_fortress", "wh3_dlc20_chs_mon_warshrine", 1)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh_main_chs_art_hellcannon", 3)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh_main_chs_inf_chosen_0", 4)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh_main_chs_inf_chosen_1", 7)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh3_main_kho_mon_bloodthirster_0", 1)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh3_main_nur_mon_great_unclean_one_0", 1)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh3_main_sla_mon_keeper_of_secrets_0", 1)
	ram:add_mandatory_unit("CI_chaos_fortress", "wh3_main_tze_mon_lord_of_change_0", 1)

	-- KHORNE FORTRESS
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_dlc20_chs_mon_warshrine_mkho", 1)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh_main_chs_art_hellcannon", 3)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 4)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_dlc20_chs_inf_chosen_mkho", 7)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_main_kho_mon_bloodthirster_0", 1)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_twa08_kho_mon_bloodthirster_0_ror", 1)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh3_dlc26_kho_mon_slaughterbrute", 1)
	ram:add_mandatory_unit("CI_khorne_fortress", "wh2_dlc17_bst_mon_ghorgon_ror_0", 1)

	-- SLAANESH FORTRESS
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_dlc20_chs_mon_warshrine_msla", 1)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh_main_chs_art_hellcannon", 3)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_dlc20_chs_inf_chosen_msla_hellscourges", 4)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_dlc20_chs_inf_chosen_msla", 7)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_main_sla_mon_keeper_of_secrets_0", 1)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_twa08_sla_mon_keeper_of_secrets_0_ror", 1)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_dlc27_sla_mon_preyton", 1)
	ram:add_mandatory_unit("CI_slaanesh_fortress", "wh3_dlc27_sla_mon_preyton_ror", 1)

	-- TZEENTCH FORTRESS
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_dlc20_chs_mon_warshrine_mtze", 1)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh_main_chs_art_hellcannon", 3)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_dlc20_chs_inf_chosen_mtze", 4)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_dlc20_chs_inf_chosen_mtze_halberds", 7)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_main_tze_mon_lord_of_change_0", 1)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_twa08_tze_mon_lord_of_change_0_ror", 1)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_dlc24_tze_mon_mutalith_vortex_beast", 1)
	ram:add_mandatory_unit("CI_tzeentch_fortress", "wh3_dlc24_tze_mon_mutalith_vortex_beast_ror", 1)

	-- NURGLE FORTRESS
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_dlc20_chs_mon_warshrine_mnur", 1)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh_main_chs_art_hellcannon", 3)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_dlc20_chs_inf_chosen_mnur_greatweapons", 4)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_dlc20_chs_inf_chosen_mnur", 7)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_main_nur_mon_great_unclean_one_0", 1)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_twa08_nur_mon_great_unclean_one_0_ror", 1)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_dlc25_nur_mon_toad_dragon", 1)
	ram:add_mandatory_unit("CI_nurgle_fortress", "wh3_dlc20_chs_mon_giant_mnur_ror", 1)
	
	-- Create the force strings
	for army_key, army in dpairs(episode_chaos_invasion.chaos_invasion_armies) do
		army.units = ram:generate_force("CI_"..army_key, 19, false)
	end
end