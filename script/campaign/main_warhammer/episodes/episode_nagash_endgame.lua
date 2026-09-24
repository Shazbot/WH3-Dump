episode_nagash_endgame = {
	episode_disabled = false,
	episode_name = "episode_nagash_endgame",
	episode_set = "end_times",
	-- this is the full name of the shared state that tells if the episode is active or not
	episode_active_shared_state = "episode_nagash_endgame",
	episode_audio_stage_change_dynamic_dialogue_event = "campaign_vo_cs_end_times_structure_nagash",

	episode_frontend_enabled_shared_state_key = "endgame_nagash_rises_enabled",
	episode_frontend_difficulty_shared_state_key = "endgame_episode_nagash_difficulty",

	post_episode_cooldown = 10,
	prerequisites = {
		min_turn = 80
	},

	movie_path = "warhammer3/endtimes/dlc29_end_times_nagash",
	movie_registry = "dlc29_end_times_nagash",
	
	foreshadow_incident_key_1 = "wh3_dlc29_nagash_endgame_episode_foreshadow_1",
	foreshadow_incident_key_2 = "wh3_dlc29_nagash_endgame_episode_foreshadow_2",
	foreshadow_main_event_key = "nagash_endgame_popup_main_event",

	final_battle_mission_key = "wh3_dlc29_nagash_episodes_endgame_final_battle",
	victory_incident = "wh3_dlc29_nagash_endgame_episode_victory",

	diplomacy_bundle = "wh3_dlc29_episodes_endgame_shield_of_civilization_nagash",
	nagash_faction_key = "wh3_dlc29_nag_host_of_nagash",

	nagashizzar_region_key = "wh3_main_combi_region_nagashizzar",
	black_pyramid_region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
	black_pyramid_chain_model_override_key = "wh3_dlc29_special_settlement_pyramid_of_nagash_nag_floating",
	army_template = "endgame_pyramid_of_nagash",

	devastation_culture_key = "devastation_nagash",
	-- the climate change is in climate_change.priorities
	-- maybe this one should be land_of_the_dead?
	devastation_climate_key = "vampire_corpses",
	devastated_region_bundle = "wh3_dlc29_ritual_nag_devaste_province",

	starting_lord_rank_high = 50,
	starting_lord_rank_low = 30,
	starting_unit_rank_high = 9,
	starting_unit_rank_low = 6,

	untargetable_region_bundle = "wh3_dlc29_nagash_endgame_nagashizzar_effect_bundle",
	necropolis_settlement_type = "wh3_dlc29_nag_necropolis",
	faction_boost_effect_bundle = "wh3_dlc29_nagash_endgame_faction_boost",
	military_upkeep_free_force_effect_bundle = "wh_main_bundle_military_upkeep_free_force",
	nagash_army_cap = 60,
	---------------- score calculation
	score_per_army = 1,
	score_per_settlement = 1,
	score_per_mortarch = 5,
	score_per_nagash = 10,
	score_per_devastated_province = 2,

	nameless_mortarch_setup = {
		forename = "names_name_193688344",
		surname = "",
		clanname = "",
		othername = "", 
		age = 50, 
		is_male = true,
		agent_key = "general", 
		agent_subtype_key = "wh_dlc04_emp_arch_lector", 
		is_immortal = false, 
		art_set = "wh_dlc04_art_set_emp_arch_lector_04", 
	},

	-- we can give it a lot more info, bundles, names and so on with time
	scores_for_rank = {
		{
			needed_power = 0,
			faction_bundle_key = "wh3_dlc29_nagash_endgame_power_level_1",
		},
		{
			needed_power = 41,
			faction_bundle_key = "wh3_dlc29_nagash_endgame_power_level_2",
		},
		{
			needed_power = 81,
			faction_bundle_key = "wh3_dlc29_nagash_endgame_power_level_3",
		},
		{
			needed_power = 121,
			faction_bundle_key = "wh3_dlc29_nagash_endgame_power_level_4",
		},
		{
			needed_power = 200,
			faction_bundle_key = "wh3_dlc29_nagash_endgame_power_level_5",
		},
	},

	devastation_thresholds = {
		{
			required_devastation = 0,
			battle_parameter = "age_of_undeath_fb_provinces_threshold_01",
		},
		{
			required_devastation = 45,
			battle_parameter = "age_of_undeath_fb_provinces_threshold_02",
		},

		{
			required_devastation = 145,
			battle_parameter = "age_of_undeath_fb_provinces_threshold_03",
		},
	},

	necropolis_thresholds = {
		{
			required_necropolises = 0,
			battle_parameter = "age_of_undeath_fb_necropolis_threshold_01",
		},
		{
			required_necropolises = 5,
			battle_parameter = "age_of_undeath_fb_necropolis_threshold_02",
		},

		{
			required_necropolises = 15,
			battle_parameter = "age_of_undeath_fb_necropolis_threshold_03",
		},
	},

	black_pyramid_marker = "wh3_dlc29_nag_black_pyramid",

	-- positions are pre-computed for the straight line path between the Black Pyramid to Nagashizzar. you can change them to be prettier
	pyramid_positions = 
	{
		{ 592, 289 },
		{ 605, 295 },
		{ 618, 301 },
		{ 631, 307 },
		{ 644, 313 },
		{ 657, 319 },
		{ 670, 325 },
		{ 683, 331 },
		{ 696, 337 },
		{ 709, 343 },
		{ 713, 350 },
		{ 738, 354 },
		{ 741, 369 },
		{ 754, 381 },
		{ 768, 382 },
		{ 781, 381 },
		{ 800, 385 },
		{ 813, 391 },
		{ 830, 398 },
		{ 849, 396 },
	},
	-------------- shared state strings
	nagash_pyramid_start_journey_shared_state = "pyramid_journey_start_turn",
	nagash_pyramid_journey_duration_shared_state = "pyramid_journey_turns",
	total_devastated_regions_shared_state = "nagash_devastated_regions",
	number_of_spawned_mortarchs_shared_state = "number_of_spawned_mortarchs",
	nagash_power_level_state_keys = {
		from_armies			= "nagash_power_level_from_armies",
		from_settlements	= "nagash_power_level_from_settlements",
		from_mortarchs		= "nagash_power_level_from_mortarchs",
		from_nagash			= "nagash_power_level_from_nagash",
		from_devastation	= "nagash_power_level_from_devastation",
		total 				= "nagash_power_level_total",
		bundle_key			= "nagash_power_level_bundle",
	},

	
	-- this needs separate saving and loading, because the episode manager loads the persistent table too late for our use
	persistent_nagash_family_member_cqi = -1,
	persistent_nagash_family_member_cqi_saved_value_name = "nagash_family_member_cqi",

	persistent = {
		current_stage = 1,
		stages_persistent_data = {},
		invasion_spawned = false,
		invasion_forces = {},
		-- [agent_subtype] = family member cqi - tracked from new campaign so dead mortarchs can still be resurrected
		mortarchs_family_cqi = {},
		spawned_mortarchs_cqi = {},
		held_books_of_nagash_indexes = {},
		total_devastated_regions = 0,
		pyramid_power_level = 1,
		pyramid_journey_start_turn = -1,
		current_nagash_power_level_index = -1,
	},

	-- all of these will be vassalized once the true invasion starts
	vassalized_subcultures = 
	{
		["wh_main_sc_vmp_vampire_counts"] = 
		{
			bundle = "wh3_dlc29_nagash_endgame_vassals_boost",
			armies_to_spawn = 3,
			treasury = 10000,
			unit_list = {
				--Infantry - 15
				wh_main_vmp_inf_skeleton_warriors_0 			= 4,
				wh_main_vmp_inf_skeleton_warriors_1 			= 5,
				wh3_dlc29_vmp_inf_spirit_host 					= 3,
				wh_main_vmp_inf_crypt_ghouls 					= 3,

				--Cavalry & Vehicles - 8
				wh_main_vmp_cav_black_knights_0 				= 3,
				wh_main_vmp_cav_black_knights_3 				= 3,
				wh_dlc04_vmp_veh_corpse_cart_2 					= 2,

				--Monsters - 8
				wh_main_vmp_mon_fell_bats 						= 3,
				wh_main_vmp_mon_dire_wolves 					= 2,
				wh_main_vmp_mon_crypt_horrors 					= 3,
			},
		},
		["wh2_dlc11_sc_cst_vampire_coast"] = 
		{
			bundle = "wh3_dlc29_nagash_endgame_vassals_boost",
			armies_to_spawn = 2,
			treasury = 20000,
			unit_list = {
				--Infantry - 15
				wh2_dlc11_cst_inf_zombie_deckhands_mob_0 			= 6,
				wh2_dlc11_cst_inf_zombie_deckhands_mob_1 			= 6,
				wh2_dlc11_cst_inf_syreens				 			= 3,

				--Cavalry & Vehicles - 4
				wh2_dlc11_cst_cav_deck_droppers_1 					= 2,
				wh2_dlc11_cst_cav_deck_droppers_2 					= 2,

				--Monsters - 8
				wh2_dlc11_cst_mon_bloated_corpse_0 					= 2,
				wh2_dlc11_cst_mon_animated_hulks_0 					= 3,
				wh2_dlc11_cst_mon_mournguls_0 						= 3,

				--Artillery & Missiles - 8
				wh2_dlc11_cst_inf_zombie_gunnery_mob_1 				= 4,			
				wh2_dlc11_cst_art_mortar 							= 2,
				wh2_dlc11_cst_art_carronade 						= 2,
			},
		},
	},

	-- if any of these nations are humans, the episode won't be available
	mandatory_non_human_factions = 
	{
		["wh3_dlc29_nag_host_of_nagash"] = true,		-- Nagash himself
		["wh2_dlc09_tmb_followers_of_nagash"] = true,	-- Arkhan the Black
		["wh2_dlc11_cst_vampire_coast"] = true,			-- Luthor Harkon
	},

	mandatory_non_human_cultures = 
	{
		["wh_main_sc_vmp_vampire_counts"] = true,
	},

	-- this maps the character agent type to the region_key they should be spawned at
	mortarch_spawn_data = {
		["wh2_dlc09_tmb_arkhan"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_arkhan",
			region_key = "wh3_main_combi_region_black_tower_of_arkhan",	-- province wh3_main_combi_province_the_cracked_land
			army = "arkhan_unit_list",
			supporting_army = "arkhan_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_arkhan"
		},
		["wh2_dlc11_cst_harkon"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_luthor",
			region_key = "wh3_main_combi_region_the_awakening",			-- province wh3_main_combi_province_vampire_coast
			army = "harkon_unit_list",
			supporting_army = "harkon_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_luthor"
		},
		["wh_main_vmp_mannfred_von_carstein"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_mannfred",
			region_key = "wh3_main_combi_region_morgheim",					-- province wh3_main_combi_province_marshes_of_madness
			army = "mannfred_unit_list",
			supporting_army = "mannfred_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_mannfred"
		},
		["wh3_dlc29_vmp_neferata"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_neferata",
			region_key = "wh3_main_combi_region_silver_pinnacle", 			-- province wh3_main_combi_province_the_blasted_wastes
			army = "neferata_unit_list",
			supporting_army = "neferata_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_neferata"
		},
		["wh_dlc04_vmp_vlad_con_carstein"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_vlad",
			region_key = "wh3_main_combi_region_castle_drakenhof", 		-- province wh3_main_combi_province_southern_sylvania
			army = "vlad_unit_list",
			supporting_army = "vlad_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_vlad"
		},
		["wh3_dlc29_vmp_dieter_helsnicht"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_dieter",
			region_key = "wh3_main_combi_region_shang_wu", 				-- province wh3_main_combi_province_celestial_riverlands
			army = "dieter_unit_list",
			supporting_army = "dieter_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_dieter"
		},
		["wh3_dlc29_vmp_krell"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_krell",
			region_key = "wh3_main_combi_region_mousillon", 				-- province wh3_main_combi_province_coast_of_lyonesse
			army = "krell_unit_list",
			supporting_army = "krell_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_krell"
		},
		["wh3_dlc29_vmp_walach_harkon"] = 
		{
			ritual_key = "wh3_dlc29_nag_mortarchs_walach",
			region_key = "wh3_main_combi_region_the_howling_citadel", 		-- province wh3_main_combi_province_bloodfire_falls
			army = "walach_unit_list",
			supporting_army = "walach_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_walach"
		},
		["wh_dlc04_emp_arch_lector"] =
		{
			region_key = "wh3_main_combi_region_the_howling_citadel", 		-- backup if no player theatre
			army = "nameless_unit_list",
			supporting_army = "nameless_unit_list",
			mission_key = "wh3_dlc29_nagash_endgame_episode_destroy_mortarch_nameless"
		}
	},

	-- Nameless Mortarch: spawn in a province with human presence, in a non-human province region, 
	-- or at the paired sea region if the whole province is human-owned.
	nameless_theatre_spawn_data = {
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_naggaroth" },
			province_key = "wh3_main_combi_province_the_broken_lands",
			sea_region_key = "wh3_main_combi_region_sea_of_chill",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_ulthuan" },
			province_key = "wh3_main_combi_province_southern_yvresse",
			sea_region_key = "wh3_main_combi_region_straits_of_lothern",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_darklands" },
			province_key = "wh3_main_combi_province_the_dragon_isles",
			sea_region_key = "wh3_main_combi_region_sea_of_storms",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_badlands" },
			province_key = "wh3_main_combi_province_crater_of_the_waking_dead",
			sea_region_key = "wh3_main_combi_region_the_bitter_sea",
		},
		{
			region_groups = {"wh3_dlc29_theatre_ie_southern_chaos_wastes"},
			province_key = "wh3_main_combi_province_the_abyssal_glacier",
			sea_region_key = "wh3_main_combi_region_the_churning_gulf",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_bretonnia" },
			province_key = "wh3_main_combi_province_tilea",
			sea_region_key = "wh3_main_combi_region_tilean_sea",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_lustria" },
			province_key = "wh3_main_combi_province_the_isthmus_coast",
			sea_region_key = "wh3_main_combi_region_straits_of_fear",
		},
		{
			region_groups = { "wh3_dlc24_schemes_theatre_ie_norsca" },
			province_key = "wh3_main_combi_province_ice_tooth_mountains",
			sea_region_key = "wh3_main_combi_region_sea_of_claws",
		},
	},
	mortarch_army_size = 18,
	nagash_army_size = 18,
	support_armies_per_mortarch = 2,
	support_armies_per_mortarch_size = 18,

	invasion_armies = {
		["nagash_unit_list"] = {
			unit_list = {
				--Infantry - 13
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 6,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 4,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_death 			= 1,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow 			= 1,
				wh2_dlc11_cst_inf_depth_guard_0 						= 1,
		
				--Cavalry & Vehicles - 8
				wh3_main_vmp_blood_knights_sword_shield 				= 3,
				wh_dlc02_vmp_cav_blood_knights_0 						= 3,
				wh2_dlc09_tmb_cav_necropolis_knights_0 					= 1,
				wh2_dlc09_tmb_cav_necropolis_knights_1 					= 1,
		
				--Monsters - 6
				wh3_dlc29_vmp_mon_morghast_harbingers 					= 2,
				wh3_dlc29_vmp_mon_morghast_archai 						= 2,
				wh3_dlc29_tmb_mon_khemric_titan 						= 1,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 1,
		
				--Artillery & Missiles - 3
				wh2_pro06_tmb_mon_bone_giant_0 							= 2,
				wh2_dlc11_cst_mon_necrofex_colossus_0 					= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_nagash",
		},
		["arkhan_unit_list"] = {
			unit_list = {
				--Infantry - 14
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 5,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 5,
				wh_main_vmp_inf_crypt_ghouls 							= 4,
		
				--Cavalry & Vehicles - 6
				wh2_dlc09_tmb_cav_necropolis_knights_0 					= 3,
				wh2_dlc09_tmb_cav_necropolis_knights_1 					= 3,
		
				--Monsters - 6
				wh2_dlc09_tmb_mon_necrosphinx_0 						= 1,
				wh_main_vmp_mon_crypt_horrors 							= 3,
				wh3_dlc29_vmp_mon_morghast_harbingers 					= 1,
				wh3_dlc29_vmp_mon_morghast_archai 						= 1,
		
				--Artillery & Missiles - 4
				wh2_pro06_tmb_mon_bone_giant_0 							= 1,
				wh2_dlc09_tmb_mon_ushabti_1 							= 2,
				wh2_dlc09_tmb_art_casket_of_souls_0 					= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["harkon_unit_list"] = {
			unit_list = {
				--Infantry - 10
				wh2_dlc11_cst_inf_syreens 								= 4,
				wh2_dlc11_cst_inf_depth_guard_0 						= 3,
				wh2_dlc11_cst_inf_depth_guard_1 						= 3,
		
				---Cavalry & Vehicles - 3
				wh2_dlc11_cst_cav_deck_droppers_1 						= 2,
				wh2_dlc11_cst_cav_deck_droppers_2 						= 1,
		
				--Monsters - 5
				wh2_dlc11_cst_mon_rotting_prometheans_0 				= 3,
				wh2_dlc11_cst_mon_rotting_leviathan_0 					= 2,
		
				--Artillery & Missiles - 7
				wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 	= 3,
				wh2_dlc11_cst_mon_necrofex_colossus_0 					= 2,
				wh2_dlc11_cst_inf_deck_gunners_0 						= 2,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["dieter_unit_list"] = {
			unit_list = {
				--Infantry - 15
				wh_main_vmp_inf_grave_guard_0 							= 5,
				wh2_dlc11_cst_inf_depth_guard_0 						= 2,
				wh2_dlc11_cst_inf_depth_guard_1 						= 2,
				wh_main_vmp_inf_cairn_wraiths 							= 3,
				wh2_dlc11_cst_inf_syreens 								= 3,
		
				---Cavalry & Vehicles - 8
				wh_main_vmp_cav_hexwraiths 								= 3,
				wh3_main_vmp_blood_knights_sword_shield 				= 2,
				wh_dlc02_vmp_cav_blood_knights_0 						= 2,
				wh_dlc04_vmp_veh_mortis_engine_0 						= 1,
		
				--Monsters - 6
				wh_main_vmp_mon_terrorgheist 							= 1,
				wh2_dlc09_tmb_mon_heirotitan_0 							= 1,
				wh3_dlc29_vmp_mon_morghast_harbingers 					= 2,
				wh3_dlc29_vmp_mon_morghast_archai 						= 2,
		
				--Artillery & Missiles - 7
				wh2_pro06_tmb_mon_bone_giant_0 							= 2,
				wh2_dlc11_cst_mon_necrofex_colossus_0 					= 1,
				wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 	= 2,
				wh2_dlc09_tmb_art_screaming_skull_catapult_0 			= 2,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["nameless_unit_list"] = {
			unit_list = {
				--Infantry - 18
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 4,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 4,
				wh_main_vmp_inf_cairn_wraiths 							= 5,
				wh2_dlc11_cst_inf_syreens 								= 5,
		
				---Cavalry & Vehicles - 8
				wh_main_vmp_cav_hexwraiths 								= 4,
				wh3_main_vmp_blood_knights_sword_shield 				= 1,
				wh_dlc02_vmp_cav_blood_knights_0 						= 1,
				wh2_dlc09_tmb_cav_necropolis_knights_0 					= 1,
				wh2_dlc09_tmb_cav_necropolis_knights_1 					= 1,
		
				--Monsters - 4
				wh3_dlc29_vmp_mon_zombie_dragon 						= 2,
				wh3_dlc29_vmp_mon_morghast_harbingers 					= 1,
				wh3_dlc29_vmp_mon_morghast_archai 						= 1,
		
				--Artillery & Missiles - 7
				wh2_pro06_tmb_mon_bone_giant_0 							= 1,
				wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 	= 1,
				wh2_dlc09_tmb_mon_ushabti_1 							= 2,
				wh2_dlc09_tmb_art_casket_of_souls_0 					= 3,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["krell_unit_list"] = {
			unit_list = {
				--Infantry - 16
				wh_main_vmp_inf_grave_guard_0 							= 4,
				wh3_main_vmp_inf_grave_guard_2 							= 4,
				wh_main_vmp_inf_grave_guard_1 							= 4,
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 2,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 2,
		
				---Cavalry & Vehicles - 6
				wh_main_vmp_cav_black_knights_0 						= 3,
				wh_main_vmp_cav_black_knights_3 						= 3,
		
				--Monsters - 6
				wh3_dlc29_vmp_mon_morghast_harbingers 					= 3,
				wh3_dlc29_vmp_mon_morghast_archai 						= 3,
		
				--Artillery & Missiles - 4
				wh2_pro06_tmb_mon_bone_giant_0 							= 2,
				wh2_dlc09_tmb_art_screaming_skull_catapult_0 			= 2,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["mannfred_unit_list"] = {
			unit_list = {
				--Infantry - 14
				wh_main_vmp_inf_grave_guard_0 							= 2,
				wh3_main_vmp_inf_grave_guard_2 							= 4,
				wh_main_vmp_inf_grave_guard_1 							= 4,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_death 			= 2,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow 			= 2,
		
				---Cavalry & Vehicles - 8
				wh_main_vmp_cav_black_knights_0 						= 2,
				wh_main_vmp_cav_black_knights_3 						= 2,
				wh3_dlc29_vmp_cav_drakenhof_templars 					= 4,
		
				--Monsters - 7
				wh_main_vmp_mon_vargheists 								= 3,
				wh_main_vmp_mon_varghulf 								= 2,
				wh_main_vmp_mon_terrorgheist 							= 1,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["neferata_unit_list"] = {
			unit_list = {
				--Infantry - 16
				wh_main_vmp_inf_grave_guard_0 							= 3,
				wh3_main_vmp_inf_grave_guard_2 							= 3,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_death 			= 5,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow 			= 5,
		
				---Cavalry & Vehicles - 8
				wh3_main_vmp_blood_knights_sword_shield 				= 2,
				wh_dlc02_vmp_cav_blood_knights_0 						= 2,
				wh3_dlc29_vmp_veh_coven_throne 							= 4,
		
				--Monsters - 5
				wh_main_vmp_mon_varghulf 								= 2,
				wh_main_vmp_mon_terrorgheist 							= 2,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["vlad_unit_list"] = {
			unit_list = {
				--Infantry - 14
				wh_main_vmp_inf_grave_guard_0 							= 6,
				wh_main_vmp_inf_grave_guard_1 							= 4,
				wh3_main_vmp_inf_grave_guard_2 							= 4,
		
				---Cavalry & Vehicles - 10
				wh3_main_vmp_blood_knights_sword_shield 				= 2,
				wh_dlc02_vmp_cav_blood_knights_0 						= 2,
				wh3_dlc29_vmp_cav_drakenhof_templars 					= 3,
				wh_dlc04_vmp_veh_mortis_engine_0 						= 3,
		
				--Monsters - 8
				wh_main_vmp_mon_vargheists 								= 3,
				wh_main_vmp_mon_varghulf 								= 2,
				wh_main_vmp_mon_terrorgheist 							= 2,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["walach_unit_list"] = {
			unit_list = {
				--Infantry - 10
				wh_main_vmp_inf_grave_guard_0 							= 4,
				wh_main_vmp_inf_grave_guard_1 							= 3,
				wh3_main_vmp_inf_grave_guard_2 							= 3,
		
				---Cavalry & Vehicles - 12
				wh3_main_vmp_blood_knights_sword_shield 				= 4,
				wh_dlc02_vmp_cav_blood_knights_0 						= 4,
				wh3_dlc29_vmp_cav_drakenhof_templars 					= 4,
		
				--Monsters - 4
				wh_main_vmp_mon_terrorgheist 							= 2,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 2,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["invasion_weak_unit_list"] = {
			unit_list = {
				--Infantry - 28
				wh_main_vmp_inf_cairn_wraiths 							= 4,
				wh_main_vmp_inf_grave_guard_0 							= 4,
				wh3_main_vmp_inf_grave_guard_2 							= 3,
				wh_main_vmp_inf_grave_guard_1 							= 3,
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 5,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 5,
				wh2_dlc11_cst_inf_syreens 								= 4,
		
				---Cavalry & Vehicles - 10
				wh_main_vmp_cav_black_knights_0 						= 2,
				wh_main_vmp_cav_black_knights_3 						= 2,
				wh_main_vmp_cav_hexwraiths 								= 3,
				wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 			= 2,
				wh_dlc04_vmp_veh_mortis_engine_0 						= 1,
		
				--Monsters - 13
				wh_main_vmp_mon_crypt_horrors 							= 3,
				wh_main_vmp_mon_vargheists 								= 3,
				wh_main_vmp_mon_varghulf 								= 1,
				wh2_dlc09_tmb_mon_ushabti_0 							= 3,
				wh2_dlc09_tmb_mon_tomb_scorpion_0 						= 1,
				wh2_dlc11_cst_mon_mournguls_0 							= 2,
		
				--Artillery & Missiles - 5
				wh2_dlc11_cst_inf_deck_gunners_0 						= 1,
				wh2_dlc09_tmb_art_casket_of_souls_0 					= 1,
				wh2_dlc09_tmb_mon_ushabti_1 							= 2,
				wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 	= 1,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		["invasion_strong_unit_list"] = {
			unit_list = {
				--Infantry - 15
				wh2_dlc09_tmb_inf_tomb_guard_0 							= 3,
				wh2_dlc09_tmb_inf_tomb_guard_1 							= 3,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_death 			= 2,
				wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow 			= 2,
				wh2_dlc11_cst_inf_depth_guard_0							= 2,
				wh2_dlc11_cst_inf_depth_guard_1							= 3,
		
				---Cavalry & Vehicles - 8
				wh3_main_vmp_blood_knights_sword_shield 				= 2,
				wh_dlc02_vmp_cav_blood_knights_0 						= 2,
				wh_main_vmp_cav_hexwraiths 								= 1,
				wh3_dlc29_vmp_cav_drakenhof_templars 					= 1,
				wh2_dlc09_tmb_cav_necropolis_knights_0 					= 1,
				wh2_dlc09_tmb_cav_necropolis_knights_1					= 1,
		
				--Monsters - 7
				wh_main_vmp_mon_varghulf 								= 2,
				wh_main_vmp_mon_terrorgheist 							= 1,
				wh3_dlc29_vmp_mon_zombie_dragon 						= 1,
				wh2_dlc09_tmb_mon_heirotitan_0 							= 1,
				wh2_dlc09_tmb_mon_necrosphinx_0 						= 1,
				wh2_dlc09_tmb_mon_khemrian_warsphinx_0 					= 1,
		
				--Artillery & Missiles - 6
				wh2_pro06_tmb_mon_bone_giant_0 							= 2,
				wh2_dlc11_cst_mon_necrofex_colossus_0 					= 2,
				wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 	= 2,
			},
			bundle = "wh3_dlc29_episodes_nagash_invasion_force_nag",
		},
		
	},
	region_weights = {
		average_distance_to_adjacent_regions = 2151, -- precomputed, squared distance
		proximity_to_necropolis_coefficient = 5,
		proximity_to_player_coefficient = 5,
		player_region_coefficient = 0.1,
	},
	start_of_turn_devastation_spawned_army_size = 19,
	override_personality_key = "wh3_combi_undead_nagash_endgame",
}

episode_nagash_endgame.nagash_is_alive = function(self) -- for some definition of "alive"
	local nagash_family_member = cm:get_family_member_by_cqi(episode_nagash_endgame.persistent_nagash_family_member_cqi)
	local nagash_character = nagash_family_member:character()
	return is_character(nagash_character) and cm:char_is_mobile_general_with_army(nagash_character)
end

episode_nagash_endgame.stages = 
{
	-- Foreshadow 1 - the Black Pyramid and Nagashizzar have become eerily quiet. 
	{
		stage_key = "episode_nagash_endgame_stage_foreshadow_1",
		duration = 10,
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_nagash_endgame.foreshadow_incident_key_1,
			},
		},
		audio_stage_type = episodes_manager.audio_stage_types.foreshadow,

		on_started = function(self)
			episode_nagash_endgame:disable_targeting_of_region(episode_nagash_endgame.nagashizzar_region_key)
			episode_nagash_endgame:disable_targeting_of_region(episode_nagash_endgame.black_pyramid_region_key)

			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_narrator_001")
		end
	},
	-- Foreshadow 2 - Something big is coming
	{
		stage_key = "episode_nagash_endgame_stage_foreshadow_2",
		duration = 10,
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_nagash_endgame.foreshadow_incident_key_2,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.imminent,

		on_started = function(self)
			episode_nagash_endgame:put_mortarchs_in_limbo()
			episode_nagash_endgame:take_all_non_player_books_of_nagash()
			-- Do this early so we pay the performance cost of invalidating analysis before the other performance intensive stuff in stage 3
			cm:force_change_cai_faction_personality(episode_nagash_endgame.nagash_faction_key, episode_nagash_endgame.override_personality_key)

			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_narrator_002")
		end,
	},
	-- Main Event - Nagash returns
	{
		stage_key = "episode_nagash_endgame_stage_main",
		duration = 20,
		main_event = true,
		payloads = {}, -- Payloads are handled in the post_payload event, due to requiring specific timing functions rather than just sequential execution
		audio_stage_type = episodes_manager.audio_stage_types.main_event,

		on_started = function(self)
			-- Disable the entire event feed as we don't want any events while creating the invasion
			cm:disable_event_feed_events(true, "all")

			-- we check if the Nagash is dead and needs to be respawned
			local pos_x, pos_y, spawn_region_key = episode_nagash_endgame:get_nagash_spawn_position()

			local nagash_family_member = cm:get_family_member_by_cqi(episode_nagash_endgame.persistent_nagash_family_member_cqi)
			local nagash_character = nagash_family_member:character()

			if nagash_character and nagash_character:is_alive() and nagash_character:has_military_force() then
				cm:teleport_to(cm:char_lookup_str(nagash_character), pos_x, pos_y)
				episode_nagash_endgame:boost_nagash()
			else
				episode_nagash_endgame:spawn_nagash(pos_x, pos_y, spawn_region_key)
			end

			episode_nagash_endgame:play_endgame_movie()
			episode_nagash_endgame:spawn_mortarchs()
			episode_nagash_endgame:vassalize_undead()
			episode_nagash_endgame:declare_war_on_everyone_you_meet()
			episode_nagash_endgame.persistent.declare_war_on_everyone_you_meet = true

			-- The Black Pyramid (a marker looking like the Pyramid) is moved somewhere and it takes 20 turns to reach Nagashizar.
			local current_turn = cm:turn_number()
			cm:set_script_state(episode_nagash_endgame.nagash_pyramid_start_journey_shared_state, current_turn)
			cm:set_script_state(episode_nagash_endgame.nagash_pyramid_journey_duration_shared_state, 20)
			episode_nagash_endgame.persistent.pyramid_journey_start_turn = current_turn
			-- we override the Black Pyramid region visuals
			episode_nagash_endgame:remove_nagash_region_pyramid()
			-- we create a marker that looks like a pyramid flying towards Nagashizar
			episode_nagash_endgame:move_black_pyramid()

			-- we check if we need to devastate any regions Nagash owned before the episode started
			episode_nagash_endgame:check_all_nagash_regions_devastation()

			cm:callback(function()
				episode_nagash_endgame:toggle_endgame_ui()
				cm:activate_music_trigger("Episode_Start", "wh3_dlc29_sc_nag_undead_legions")
				episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_nagash_003")
			end, 2)

			-- Apply effect bundle boost to Nagash faction
			cm:apply_effect_bundle(episode_nagash_endgame.faction_boost_effect_bundle, episode_nagash_endgame.nagash_faction_key, 0)

			cm:disable_event_feed_events(false, "all")
		end,

	},
	-- The pyramid arrived at Nagashizar, the final battle is possible
	{
		stage_key = "episode_nagash_endgame_stage_battle",
		payloads =
		{
			{
				payload_type = "mission",
				mission_key = episode_nagash_endgame.final_battle_mission_key,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.main_event_02,

		on_started = function(self)
			-- we hide the journey section from the UI
			cm:remove_script_state(episode_nagash_endgame.nagash_pyramid_start_journey_shared_state)

			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_narrator_006")
		end,

		on_mission_succeeded = function(self, mission_key)
			if mission_key == episode_nagash_endgame.final_battle_mission_key then
				episodes_manager.mark_mission_completed(episode_nagash_endgame, mission_key)
				episodes_manager:advance_stage(episode_nagash_endgame)
			end
		end,
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
				incident_key = episode_nagash_endgame.victory_incident,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.ended,

		on_started = function(self)
			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_narrator_008")

			-- Play some music!
			cm:activate_music_trigger("Episode_Finish", "wh3_dlc29_sc_nag_undead_legions")

			cm:kill_faction(episode_nagash_endgame.nagash_faction_key)

			-- Hide the Endgame UI elements
			cm:set_script_state("current_episode_popup", "")
			local uic = core:get_or_create_component("foreshadow_popup", "UI/Campaign UI/dlc29_endgame_crisis_scenarios.twui.xml")
			uic:SetVisible(false)

			episode_nagash_endgame:remove_all_nagash_devastation()
			cm:set_script_state("current_episode_popup", "")
			local uic = core:get_or_create_component("foreshadow_popup", "UI/Campaign UI/dlc29_endgame_crisis_scenarios.twui.xml")
			uic:SetVisible(false)
			
			local all_factions = cm:get_faction_list()
			for i = 0, all_factions:num_items() - 1 do
				local faction = all_factions:item_at(i)
				if faction:is_dead() == false then
					local faction_key = faction:name()
					cm:remove_effect_bundle(episode_nagash_endgame.diplomacy_bundle, faction_key)
				end
			end

			-- we remove the targeting restrictions
			cm:remove_effect_bundle_from_region(episode_nagash_endgame.untargetable_region_bundle, episode_nagash_endgame.nagashizzar_region_key)
			cm:remove_effect_bundle_from_region(episode_nagash_endgame.untargetable_region_bundle, episode_nagash_endgame.black_pyramid_region_key)

			cm:cai_enable_targeting_against_settlement("settlement:"..episode_nagash_endgame.nagashizzar_region_key)
			cm:cai_enable_targeting_against_settlement("settlement:"..episode_nagash_endgame.black_pyramid_region_key)
		end,

		get_next_stage_index = function()
			return -1 -- This ends the episode
		end
	},
}

episode_nagash_endgame.try_get_nagash_family_member_cqi = function(self)
	local nagash_faction_interface = cm:get_faction(episode_nagash_endgame.nagash_faction_key)
	if is_faction(nagash_faction_interface)
		and nagash_faction_interface:faction_leader() 
		and nagash_faction_interface:faction_leader():is_null_interface() == false
	then
		-- local variable for easier debugging
		local result = nagash_faction_interface:faction_leader():family_member():command_queue_index()
		return result or -1
	end
	return -1
end

episode_nagash_endgame.can_start = function(self)
	if (not is_number(self.persistent_nagash_family_member_cqi))
		or self.persistent_nagash_family_member_cqi <= 0
	then
		return false
	end
	return true
end

episode_nagash_endgame.is_available_this_game = function(self)
	-- First check the frontend setting to make sure it was enabled
	local episode_enabled = cm:model():shared_states_manager():get_state_as_bool_value(self.episode_frontend_enabled_shared_state_key)
	if episode_enabled == false then
		return false
	end

	-- The episode is not available when there is no Nagash, or he is human
	local nagash_faction_obj = cm:get_faction(self.nagash_faction_key)
	if (not nagash_faction_obj) or nagash_faction_obj:is_null_interface() then
		--NAGASH INVASION: Nagash faction was nil or null interface probably we are loading an old save
		return false
	elseif nagash_faction_obj:is_human() == true then
		return false
	end

	-- the mortarchs can't be human either
	for _, mortarch_data in dpairs(nag_mortarchs_config.dynamic_ritual_data) do
		if is_string(mortarch_data.agent) then
			local has_spawned, mortarch_faction, cqi = nag_mortarchs:is_mortarch_spawned(mortarch_data.agent)
			if mortarch_faction and mortarch_faction:is_human() then
				return false
			end
		end
	end

	-- if any of the vassalized factions of the Mortarchs is human, the episode is not available
	local human_factions = cm:get_human_factions();
	for i = 1, #human_factions do
		local faction_name = human_factions[i]
		if self.mandatory_non_human_factions[faction_name] then
			return false
		end

		local faction_obj = cm:get_faction(faction_name)
		if is_faction(faction_obj) == false then
			return false
		end

		local subculture = faction_obj:subculture()
		if self.mandatory_non_human_cultures[subculture] then
			return false
		end
	end

	return true
end

episode_nagash_endgame.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
	cm:set_script_state(self.episode_active_shared_state, true)
end

episode_nagash_endgame.disable_targeting_of_region = function(self, region_key)
	local region_obj = cm:get_region(region_key)
	if is_region(region_obj) == false then
		return
	end

	if region_obj:owning_faction():name() ~= self.nagash_faction_key then
		cm:transfer_region_to_faction(region_key, self.nagash_faction_key, self.necropolis_settlement_type)
	end
	local foreign_slots_list_interface = region_obj:foreign_slot_managers()
	local foreign_slot_number = foreign_slots_list_interface:num_items()
	-- Does it have any foreign slots in it? - we need to first store and then remove them
	local foreign_slot_owners_keys_table = {}
	for i = 0, foreign_slot_number - 1 do
		local foreign_slot = foreign_slots_list_interface:item_at(i)
		local faction_owner_obj = foreign_slot:faction()
		local faction_owner_key = faction_owner_obj:name()
		if is_number(foreign_slot_owners_keys_table[faction_owner_key]) == false then
			foreign_slot_owners_keys_table[faction_owner_key] = faction_owner_obj:command_queue_index()
		end
	end
	for _faction_owner_key, faction_cqi in dpairs(foreign_slot_owners_keys_table) do
		cm:remove_faction_foreign_slots_from_region(faction_cqi, region_obj:cqi());
	end
	cm:cai_disable_targeting_against_settlement("settlement:" .. region_key)
	cm:apply_effect_bundle_to_region(self.untargetable_region_bundle, region_key, 0)
end

-- this will spawn the mortarchs and indirectly call on_nagash_taking_mortarch_character - and that will actually put them in Limbo
episode_nagash_endgame.put_mortarchs_in_limbo = function(self)
	nag_mortarchs:check_unlocks_for_ai(true)

	-- the nameless mortarch is added differently
	local nameless_mortarch = cm:spawn_character_to_pool(
		self.nagash_faction_key,
		self.nameless_mortarch_setup.forename,
		self.nameless_mortarch_setup.surname,
		self.nameless_mortarch_setup.clanname,
		self.nameless_mortarch_setup.othername,
		self.nameless_mortarch_setup.age,
		self.nameless_mortarch_setup.is_male,
		self.nameless_mortarch_setup.agent_key,
		self.nameless_mortarch_setup.agent_subtype_key,
		self.nameless_mortarch_setup.is_immortal,
		self.nameless_mortarch_setup.art_set
	)
	local nameless_fm_cqi = nameless_mortarch:family_member():command_queue_index()
	self.persistent.mortarchs_family_cqi[self.nameless_mortarch_setup.agent_subtype_key] = nameless_fm_cqi
	cm:enter_limbo("family_member_cqi:"..nameless_fm_cqi)

	for subtype_key, spawn_data in dpairs(self.mortarch_spawn_data) do
		if is_string(spawn_data.ritual_key) then
			cm:perform_ritual(self.nagash_faction_key, "", spawn_data.ritual_key)
		end
	end
end

episode_nagash_endgame.on_nagash_taking_mortarch_character = function(self, character_cqi)
	local mortarch_character = cm:get_character_by_cqi(character_cqi)
	if is_character(mortarch_character) == false then
		return
	end
	local family_member_cqi = mortarch_character:family_member():command_queue_index()
	-- wh_pro02_vmp_isabella_von_carstein_hero is spawned but she is not a mortarch, so we don't save her cqi to later spawning
	local subtype_key = mortarch_character:character_subtype_key()
	if self.mortarch_spawn_data[subtype_key] then
		self.persistent.mortarchs_family_cqi[subtype_key] = family_member_cqi
	end
	cm:enter_limbo("family_member_cqi:"..family_member_cqi)
end

episode_nagash_endgame.spawn_nagash = function(self, pos_x, pos_y, spawn_region_key)
	local unit_list = self.invasion_armies.nagash_unit_list.unit_list
	local nagash_army_template = self.army_template .. "_nagash"
	local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(nagash_army_template, unit_list, self.nagash_army_size)

	local resurrected_character = cm:resurrect_family_member(self.persistent_nagash_family_member_cqi, self.nagash_faction_key)
	if not is_character(resurrected_character) then
		return
	end

	cm:create_force_with_existing_general(
		cm:char_lookup_str(resurrected_character),
		self.nagash_faction_key,
		generated_unit_list,
		spawn_region_key,
		pos_x,
		pos_y,
		function(char_cqi, force_cqi)
			episode_nagash_endgame:boost_nagash()
		end
	);
end

episode_nagash_endgame.boost_nagash = function()
	local nagash_family_member = cm:get_family_member_by_cqi(episode_nagash_endgame.persistent_nagash_family_member_cqi)
	local nagash_character = nagash_family_member:character()

	local character_details = nagash_character:character_details()
	cm:character_details_set_rank(character_details, episode_nagash_endgame.starting_lord_rank_high, false)


	local nagash_lookup = cm:char_lookup_str(nagash_character:command_queue_index())
	cm:add_experience_to_units_commanded_by_character(nagash_lookup, episode_nagash_endgame.starting_unit_rank_high)
end

episode_nagash_endgame.region_in_theatre_groups = function(self, region, group_keys)
	if (not region) or region:is_null_interface() then
		return false
	end
	for i = 1, #group_keys do
		if region:is_contained_in_region_group(group_keys[i]) then
			return true
		end
	end
	return false
end

episode_nagash_endgame.theatre_has_mortarch = function(self, theatre_entry)
	for subtype_key, spawn_data in dpairs(self.mortarch_spawn_data) do
		if subtype_key ~= self.nameless_mortarch_setup.agent_subtype_key then
			local region = cm:get_region(spawn_data.region_key)
			if self:region_in_theatre_groups(region, theatre_entry.region_groups) then
				return true
			end
		end
	end
	return false
end

episode_nagash_endgame.human_has_presence_in_theatre = function(self, theatre_entry)
	local human_faction_keys = cm:get_human_factions()
	for i = 1, #human_faction_keys do
		local faction = cm:get_faction(human_faction_keys[i])
		if faction and not faction:is_null_interface() then
			local region_list = faction:region_list()
			for j = 0, region_list:num_items() - 1 do
				if self:region_in_theatre_groups(region_list:item_at(j), theatre_entry.region_groups) then
					return true
				end
			end

			local military_force_list = faction:military_force_list()
			for j = 0, military_force_list:num_items() - 1 do
				local force = military_force_list:item_at(j)
				if force:has_general() then
					local general = force:general_character()
					local force_type = force:force_type()
					local force_type_key = force_type:key()
					if general:character_subtype("wh3_dlc23_chd_lord_convoy_overseer") == false 
						and general:character_subtype("wh3_main_cth_lord_caravan_master") == false
						and force_type_key ~= "CONVOY"
						and force_type_key ~= "CARAVAN"
					then
						if general:has_region() and self:region_in_theatre_groups(general:region(), theatre_entry.region_groups) then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

-- Prefer any non-human region in the province (capital first). If every region is human-owned, spawn in the theatre's sea region.
episode_nagash_endgame.resolve_spawn_for_theatre = function(self, theatre)
	local province = cm:get_province(theatre.province_key)
	if (not province) or province:is_null_interface() then
		return nil
	end

	local province_regions = province:regions()
	local non_human_region = nil
	local all_human = true

	for j = 0, province_regions:num_items() - 1 do
		local region = province_regions:item_at(j)
		local owner = region:owning_faction()
		if not owner or owner:is_null_interface() or not owner:is_human() then
			all_human = false
			if region:is_province_capital() then
				non_human_region = region
			elseif not non_human_region then
				non_human_region = region
			end
		end
	end

	if all_human then
		local capital = province:capital_region()
		if capital and not capital:is_null_interface() and theatre.sea_region_key then
			return {
				region_key = theatre.sea_region_key,
				-- pathfinder needs a land settlement
				settlement_region_key = capital:name(),
				spawn_on_sea = true,
				army = self.invasion_armies.invasion_strong_unit_list,
			}
		end
	elseif non_human_region then
		return {
			region_key = non_human_region:name(),
			settlement_region_key = non_human_region:name(),
			spawn_on_sea = false,
		}
	end

	return nil
end

-- Prefer a human theatre that already has a Mortarch (spawn at that Mortarch's region).
-- Else a human theatre with no Mortarch (Nameless-style placement).
-- Else the Mortarch spawn region closest to a human capital.
episode_nagash_endgame.get_nagash_spawn_position = function(self)
	local human_capital_regions = self:get_human_capital_regions()
	local closest_squared_distance = -1
	local suitable_x = -1
	local suitable_y = -1
	local suitable_region_key = ""

	-- 1) Human theatre that also contains a Mortarch — stay near that Mortarch
	for _, theatre in ipairs(self.nameless_theatre_spawn_data) do
		if self:human_has_presence_in_theatre(theatre) then
			for subtype_key, spawn_data in dpairs(self.mortarch_spawn_data) do
				if subtype_key ~= self.nameless_mortarch_setup.agent_subtype_key then
					local region = cm:get_region(spawn_data.region_key)
					if self:region_in_theatre_groups(region, theatre.region_groups) then
						local squared_distance_to_closest_human_capital = self:squared_distance_to_closest_region(region, human_capital_regions)
						if closest_squared_distance < 0
							or (squared_distance_to_closest_human_capital >= 0
								and squared_distance_to_closest_human_capital < closest_squared_distance)
						then
							local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
								self.nagash_faction_key,
								spawn_data.region_key,
								false,
								true,
								20)

							if x_pos > 0 and y_pos > 0 then
								closest_squared_distance = squared_distance_to_closest_human_capital
								suitable_x = x_pos
								suitable_y = y_pos
								suitable_region_key = spawn_data.region_key
							end
						end
					end
				end
			end
		end
	end

	if suitable_x > 0 then
		return suitable_x, suitable_y, suitable_region_key
	end

	-- 2) Human theatre with no Mortarch — reuse Nameless theatre placement
	for _, theatre in ipairs(self.nameless_theatre_spawn_data) do
		if self:human_has_presence_in_theatre(theatre) then
			local spawn_choice = self:resolve_spawn_for_theatre(theatre)
			if spawn_choice then
				local find_region_key = spawn_choice.spawn_on_sea and spawn_choice.settlement_region_key or spawn_choice.region_key
				local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
					self.nagash_faction_key,
					find_region_key,
					spawn_choice.spawn_on_sea,
					not spawn_choice.spawn_on_sea,
					20)
				if x_pos > 0 and y_pos > 0 then
					return x_pos, y_pos, spawn_choice.region_key
				end
			end
		end
	end

	-- 3) No human theatre match — closest Mortarch spawn region to a human capital
	closest_squared_distance = -1
	suitable_x = -1
	suitable_y = -1
	suitable_region_key = ""
	for subtype_key, spawn_data in dpairs(self.mortarch_spawn_data) do
		if subtype_key ~= self.nameless_mortarch_setup.agent_subtype_key then
			local region = cm:get_region(spawn_data.region_key)
			local squared_distance_to_closest_human_capital = self:squared_distance_to_closest_region(region, human_capital_regions)

			if closest_squared_distance < 0
				or (squared_distance_to_closest_human_capital >= 0
					and squared_distance_to_closest_human_capital < closest_squared_distance)
			then
				local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
					self.nagash_faction_key,
					spawn_data.region_key,
					false,
					true,
					20)

				if x_pos > 0 and y_pos > 0 then
					closest_squared_distance = squared_distance_to_closest_human_capital
					suitable_x = x_pos
					suitable_y = y_pos
					suitable_region_key = spawn_data.region_key
				end
			end
		end
	end

	return suitable_x, suitable_y, suitable_region_key
end

-- Prefer a Mortarch-free theatre with human presence; else a random Mortarch-free theatre.
episode_nagash_endgame.get_nameless_spawn_choice = function(self)
	for _, theatre in ipairs(self.nameless_theatre_spawn_data) do
		if self:human_has_presence_in_theatre(theatre) and not self:theatre_has_mortarch(theatre) then
			local spawn_choice = self:resolve_spawn_for_theatre(theatre)
			if spawn_choice then
				return spawn_choice
			end
		end
	end

	local free_theatres = {}
	for _, theatre in ipairs(self.nameless_theatre_spawn_data) do
		if not self:theatre_has_mortarch(theatre) then
			table.insert(free_theatres, theatre)
		end
	end

	if #free_theatres > 0 then
		local theatre = free_theatres[cm:random_number(#free_theatres, 1)]
		return self:resolve_spawn_for_theatre(theatre)
	end

	return nil
end

episode_nagash_endgame.play_endgame_movie = function(self)
	core:svr_save_registry_bool(episode_nagash_endgame.movie_registry, true)
	cm:register_instant_movie(episode_nagash_endgame.movie_path)
end

-- Snapshot equipped ancillaries before kill+resurrect of general mortarchs.
-- kill_character_and_commanded_unit strips equipped items; resurrect_family_member does not restore them.
episode_nagash_endgame.get_character_ancillary_keys = function(self, character)
	local ancillary_keys = {}
	if not is_character(character) then
		return ancillary_keys
	end

	local character_cco = cco("CcoCampaignCharacter", character:command_queue_index())
	if not character_cco then
		return ancillary_keys
	end

	local ancillary_count = character_cco:Call("AncillaryList.Size")
	if not is_number(ancillary_count) then
		return ancillary_keys
	end

	for i = 0, ancillary_count - 1 do
		local ancillary_key = character_cco:Call("AncillaryList.At(" .. i .. ").AncillaryRecordContext.Key")
		if is_string(ancillary_key) then
			table.insert(ancillary_keys, ancillary_key)
		end
	end

	return ancillary_keys
end

episode_nagash_endgame.restore_character_ancillaries = function(self, character, ancillary_keys)
	if not is_character(character) or not is_table(ancillary_keys) then
		return
	end

	for i = 1, #ancillary_keys do
		cm:force_add_ancillary(character, ancillary_keys[i], true, true)
	end
end

episode_nagash_endgame.spawn_mortarchs = function(self)
	for _, mortarch_family_cqi in dpairs(self.persistent.mortarchs_family_cqi) do
		local family_member = cm:get_family_member_by_cqi(mortarch_family_cqi)
		local character_details = family_member:character_details()
		local character_type_key = character_details:character_type_key()
		local character_subtype_key = character_details:character_subtype_key()
		-- there is probably a much better way to do this, this is only a placeholder

		local mortarch_spawn_data = self.mortarch_spawn_data[character_type_key]
		if not mortarch_spawn_data then 
			mortarch_spawn_data = self.mortarch_spawn_data[character_subtype_key]
		end

		if mortarch_spawn_data then 
			local army = self.invasion_armies[mortarch_spawn_data.army]
			local region_key = mortarch_spawn_data.region_key
			local settlement_region_key = region_key
			local spawn_on_sea = false

			if character_subtype_key == self.nameless_mortarch_setup.agent_subtype_key then
				local spawn_choice = self:get_nameless_spawn_choice()
				if spawn_choice then
					region_key = spawn_choice.region_key
					settlement_region_key = spawn_choice.settlement_region_key
					spawn_on_sea = spawn_choice.spawn_on_sea
					army = spawn_choice.army or army
				end
			end

			if not army or not army.unit_list then
				script_error("ERROR: Nagash endgame spawn_mortarchs missing invasion army for mortarch [" .. tostring(character_subtype_key) .. "] (army key [" .. tostring(mortarch_spawn_data.army) .. "])! Falling back to invasion_strong_unit_list.")
				army = self.invasion_armies.invasion_strong_unit_list
			end

			local unit_list = army.unit_list
			local mortarch_army_template = self.army_template .. "_" .. mortarch_spawn_data.army
			local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(mortarch_army_template, unit_list, self.mortarch_army_size)

			-- region_key might be a SEA region, thus region_obj being NULL_SCRIPT_INTERFACE
			-- In order to spawn an army at sea, we need to pass a land region and at_sea=true to
			-- find_valid_spawn_location_for_character_from_settlement(), then pass the same region 
			-- and coordinates to create_force()
			local region_obj = cm:get_region(region_key)
			-- it could also be a sea region for the Nameless mortarch
			if is_region(region_obj) and not spawn_on_sea then
				if region_obj:owning_faction():is_human() == false then
					if region_obj:is_province_capital() then
						cm:transfer_region_to_faction(region_key, self.nagash_faction_key, self.necropolis_settlement_type)
					else
						cm:transfer_region_to_faction(region_key, self.nagash_faction_key)
					end
				else
					--if it is human owned, try and find a neighboring non-human owned region
					local near_non_human_region = self:try_find_close_non_human_region(region_obj)
					if is_region(near_non_human_region) then
						region_obj = near_non_human_region
					else
						-- if that fails as well, we spawn one province away (in a neighboring province)
						local adjacent_provinces = region_obj:province():adjacent_provinces()
						if adjacent_provinces:num_items()  > 0 then
							region_obj = adjacent_provinces:item_at(0):capital_region()
						end
					end
				end
			end

			-- Sea: pathfind from land settlement; create_force uses the sea region_key
			local find_region_key = spawn_on_sea and settlement_region_key or region_key
			local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
				self.nagash_faction_key,
				find_region_key,
				spawn_on_sea,
				not spawn_on_sea,
				20)

			-- TODO: if no valid place is found, check other regions

			-- Generals: kill limbo char first, resurrect into a recruitable state, then create their army.
			-- Agents: leave limbo and embed into a new army.
			local character_lookup = "family_member_cqi:"..mortarch_family_cqi
			local on_mortarch_force_ready = function(force_cqi)
				local new_force_interface = cm:get_military_force_by_cqi(force_cqi)
				cm:apply_effect_bundle_to_force(self.military_upkeep_free_force_effect_bundle, force_cqi, 0)
				-- we make mortarchs mortal so we only need to kill them once
				cm:set_character_immortality(character_lookup, false)

				-- Unit XP must go through the commanding general (heroes do not command the force).
				local general = new_force_interface:general_character()
				cm:character_details_set_rank(general:character_details(), episode_nagash_endgame.starting_lord_rank_high, false)
				cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(general), episode_nagash_endgame.starting_unit_rank_high)

				-- Hero mortarchs are embedded under a placeholder general — boost the hero as well.
				local mortarch_character = cm:get_family_member_by_cqi(mortarch_family_cqi):character()
				if is_character(mortarch_character) and mortarch_character:command_queue_index() ~= general:command_queue_index() then
					cm:character_details_set_rank(mortarch_character:character_details(), episode_nagash_endgame.starting_lord_rank_high, false)
				end

				local held_books = self.persistent.held_books_of_nagash_indexes
				-- we give the mortarch a Book of Nagash, if available
				if #held_books > 0 then
					local book_number = held_books[1]
					table.remove(held_books, 1)
					clear_cooldown_for_book(book_number)
					local new_owner_faction_interface = new_force_interface:faction()
					grant_book_to_new_book_participant_owner(book_number, new_force_interface, new_owner_faction_interface)
				end
				table.insert(self.persistent.spawned_mortarchs_cqi, mortarch_family_cqi)
				-- we create a mission for the human players to beat the mortarch.
				self:create_defeat_mortarch_mission(mortarch_spawn_data.mission_key, force_cqi)
			end

			if character_type_key == "general" then
				-- Capture ancillaries before kill; kill+resurrect drops equipped items
				local limbo_character = family_member:character()
				local ancillary_keys = self:get_character_ancillary_keys(limbo_character)

				cm:set_character_immortality(character_lookup, false)
				cm:suppress_immortality(mortarch_family_cqi, true)
				cm:kill_character_and_commanded_unit(character_lookup, true, false)

				local resurrected_character = cm:resurrect_family_member(mortarch_family_cqi, self.nagash_faction_key)
				if is_character(resurrected_character) then
					cm:create_force_with_existing_general(
						cm:char_lookup_str(resurrected_character),
						self.nagash_faction_key,
						generated_unit_list,
						find_region_key,
						x_pos,
						y_pos,
						function(cqi, force_cqi)
							self:restore_character_ancillaries(resurrected_character, ancillary_keys)
							on_mortarch_force_ready(force_cqi)
						end
					)
				end
			else
				cm:create_force(
					self.nagash_faction_key,
					generated_unit_list,
					find_region_key,
					x_pos,
					y_pos,
					true,
					function(cqi, force_cqi)
						cm:leave_limbo(character_lookup, x_pos, y_pos, true)
						local mortarch_character = cm:get_family_member_by_cqi(mortarch_family_cqi):character()
						local force = cm:get_military_force_by_cqi(force_cqi)
						if is_character(mortarch_character) and force and not force:is_null_interface() then
							cm:embed_agent_in_force(mortarch_character, force)
						end
						on_mortarch_force_ready(force_cqi)
					end
				)
			end

			-- we spawn support armies to help the mortarch
			for j = 1, self.support_armies_per_mortarch do
				local unit_list = nil
				local support_army_template = nil
				if mortarch_spawn_data.supporting_army then
					unit_list = self.invasion_armies[mortarch_spawn_data.supporting_army].unit_list
					if unit_list then
						support_army_template = mortarch_spawn_data.supporting_army .. "_support"
					end
				end

				if is_table(unit_list) == false then
					unit_list = self.invasion_armies.invasion_strong_unit_list.unit_list
					support_army_template = mortarch_spawn_data.army .. "_support"
				end
				local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(support_army_template, unit_list, self.support_armies_per_mortarch_size)
				self:spawn_support_army(
					self.nagash_faction_key,
					region_obj,
					generated_unit_list,
					spawn_on_sea,
					settlement_region_key,
					self.military_upkeep_free_force_effect_bundle
				)
			end
		end
	end

	cm:set_script_state(self.number_of_spawned_mortarchs_shared_state, #self.persistent.spawned_mortarchs_cqi)
end

episode_nagash_endgame.take_all_non_player_books_of_nagash = function(self)
	for book_number = 1, books_of_nagash_max_count do
		if is_book_held_by_human(book_number) == false then
			remove_book_from_current_owner(book_number)

			local active_stage = self.stages[self.persistent.current_stage_index]
			local book_cooldown_duration_override = nil
			if is_table(active_stage) then
				book_cooldown_duration_override = active_stage.duration
			end
			
			clear_cooldown_for_book(book_number)
			set_book_on_cooldown(book_number, {}, book_cooldown_duration_override)
			fail_books_of_nagash_mission_for_other_participant_factions(get_book_and_mission_key_for_index(book_number))
			table.insert(episode_nagash_endgame.persistent.held_books_of_nagash_indexes, book_number)
		end
	end
end

episode_nagash_endgame.toggle_endgame_ui = function(self)
	cm:set_script_state("current_episode_popup", self.foreshadow_main_event_key)
	common.call_context_command("ToggleHUDPanel('dlc29_endgame_crisis_scenarios')")
end

----------------------------------------------
-- DEVASTATION SECTION

episode_nagash_endgame.should_region_be_devastated = function(self, region_obj)
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

	local nagash_regions = 0
	for i = 0, region_count - 1 do
		local region = region_list:item_at(i)

		local owner_key = region:owning_faction():name()
		if owner_key == self.nagash_faction_key then
			nagash_regions = nagash_regions + 1
		end
	end
	
	-- During this endgame areas with 50% or more of their regions owned by Nagash get devastated
	local razed_ratio = nagash_regions / region_count
	if razed_ratio < 0.5 then
		return false
	end
	return true
end

-- returns if any change happened
episode_nagash_endgame.check_region_devastation = function(self, region_obj)
	local is_devastated = devastation_manager:is_region_devastated(region_obj:name())
	local should_be_devastated = self:should_region_be_devastated(region_obj)

	if is_devastated and should_be_devastated then
		-- region is already devastated
		return false
	end

	if is_devastated == false and should_be_devastated == false then
		-- region is fine as it is
		return false
	end

	local change_occured = true
	if should_be_devastated then
		change_occured = devastation_manager:devastate_region(
			region_obj:name(), 
			self.devastation_culture_key,
			self.devastation_climate_key,
			self.devastated_region_bundle
		)

		if change_occured then
			self.persistent.total_devastated_regions = self.persistent.total_devastated_regions + 1
			cm:set_script_state(self.total_devastated_regions_shared_state, self.persistent.total_devastated_regions)
		end
	else
		devastation_manager:remove_devastation(region_obj:name())
	end
	return change_occured
end

-- this is called at the start of the invasion, after we give the first regions to Nagash
episode_nagash_endgame.check_all_nagash_regions_devastation = function(self)
	local nagash_faction_obj = cm:get_faction(self.nagash_faction_key)
	local region_list = nagash_faction_obj:region_list()
	local any_change_happened = false
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i)
		if self:check_region_devastation(current_region) then
			any_change_happened = true
		end
	end
	if any_change_happened then
		self:recalculate_nagash_power_level()
	end
end

episode_nagash_endgame.remove_all_nagash_devastation = function(self)
	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i)
		local devastation_culture = devastation_manager:get_region_devastation_culture(current_region:name())
		if devastation_culture == self.devastation_culture_key then
			devastation_manager:remove_devastation(current_region:name())
		end
	end
end

-- END OF DEVASTATION SECTION 
----------------------------------------------

episode_nagash_endgame.create_defeat_mortarch_mission = function(self, mission_key, mortarch_force_cqi)
	local human_factions = cm:get_human_factions()
	for i = 1, #human_factions do
		local human_faction_key = human_factions[i]
		local mm = mission_manager:new(human_faction_key, mission_key);
		mm:set_mission_issuer("CLAN_ELDERS");
		mm:add_new_objective("ENGAGE_FORCE");
		
		mm:add_condition("cqi " .. mortarch_force_cqi)
		mm:add_condition("requires_victory")
		
		mm:add_payload("text_display dummy_nagash_endgame_mortarch_reward_a")
		mm:add_payload("text_display dummy_nagash_endgame_mortarch_reward_b")
		
		mm:set_should_whitelist(false)
		mm:trigger()
	end
end

episode_nagash_endgame.vassalize_undead = function(self)
	local nagash_faction_interface = cm:get_faction(self.nagash_faction_key)
	for subculture_key, support_table in pairs(self.vassalized_subcultures) do
		local factions_list = cm:model():world():factions_with_subculture(subculture_key)
		for i = 0, factions_list:num_items() - 1 do
			local faction = factions_list:item_at(i)
			if faction:is_dead() == false 
				and faction:is_human() == false
			then
				local faction_key = faction:name()
				if not faction:is_ally_vassal_or_client_state_of(nagash_faction_interface) then
					cm:force_make_vassal(self.nagash_faction_key, faction_key, false)
					if is_string(support_table.bundle) then
						cm:apply_effect_bundle(support_table.bundle, faction_key, 0)
					end

					if is_number(support_table.treasury) then
						cm:treasury_mod(faction_key, support_table.treasury)
					end

					if is_number(support_table.armies_to_spawn) then
						for j = 1, support_table.armies_to_spawn do
							local vassal_army_template = self.army_template .. "_vassal_" .. subculture_key
							local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(vassal_army_template, support_table.unit_list, 20)
							local faction_capital = faction:home_region()
							local faction_leader = faction:faction_leader()
							if faction_capital:is_null_interface() == false then
								self:spawn_support_army(faction_key, faction_capital, generated_unit_list)
							elseif is_character(faction_leader) and is_region(faction_leader:region()) then
								self:spawn_support_army(faction_key, faction_leader:region(), generated_unit_list)
							end
						end
					end
				end
			end
		end
	end
end

episode_nagash_endgame.debug_show_all_pyramid_positions = function(self)
	local marker = Interactive_Marker_Manager:get_marker("black_pyramid")
	if not marker then
		-- 1 here means the markers last 1 turn
		marker = Interactive_Marker_Manager:new_marker_type("black_pyramid", self.black_pyramid_marker, 1)
	end

	for index, coordinates in ipairs(episode_nagash_endgame.pyramid_positions) do
		local pos_x = coordinates[1]
		local pos_y = coordinates[2]
		-- we use marker:spawn because marker:spawn_at_location tries to find a suitable place, and we don't care about walkability or other characters - the pyramid is flying
		marker:spawn("black_pyramid:" .. tostring(index),pos_x,pos_y)
	end
end

episode_nagash_endgame.move_black_pyramid = function(self)
	if (not is_number(self.persistent.pyramid_journey_start_turn)) or self.persistent.pyramid_journey_start_turn < 0 then
		return
	end
	local journey_position_index = cm:turn_number() - self.persistent.pyramid_journey_start_turn + 1
	if journey_position_index < 1 or journey_position_index > #self.pyramid_positions then
		return
	end

	local marker = Interactive_Marker_Manager:get_marker("black_pyramid")
	if not marker then
		-- 1 here means the markers last 1 turn
		marker = Interactive_Marker_Manager:new_marker_type("black_pyramid", self.black_pyramid_marker, 1)
	end
	
	local pyramid_position = self.pyramid_positions[journey_position_index]
	local pos_x = pyramid_position[1]
	local pos_y = pyramid_position[2]
	-- we use marker:spawn because marker:spawn_at_location tries to find a suitable place, and we don't care about walkability or other characters - the pyramid is flying
	marker:despawn_on_interaction(false)
	marker:spawn("black_pyramid:" .. tostring(journey_position_index),pos_x,pos_y)
end

episode_nagash_endgame.transfer_event_area_to_nagash = function(self, region)
	local region_list = region:regions_in_same_event_area()
	if region_list and not region_list:is_null_interface() then
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			self:trigger_event_message(current_region:owning_faction(), current_region)
			if current_region:is_province_capital() then
				cm:transfer_region_to_faction(current_region:name(), self.nagash_faction_key, self.necropolis_settlement_type)
			else
				cm:transfer_region_to_faction(current_region:name(), self.nagash_faction_key)
			end
		end
	else
		self:trigger_event_message(region:owning_faction(), region)
		if region:is_province_capital() then
			cm:transfer_region_to_faction(region:name(), self.nagash_faction_key, self.necropolis_settlement_type)
		else
			cm:transfer_region_to_faction(region:name(), self.nagash_faction_key)
		end
	end
end

episode_nagash_endgame.get_regions_with_a_necropolis = function(self)
	local necropolis_regions = {}
	local nagash_faction_interface = cm:get_faction(episode_nagash_endgame.nagash_faction_key)
	local nagash_regions = nagash_faction_interface:region_list()
	for i = 0, nagash_regions:num_items() - 1 do
		local region = nagash_regions:item_at(i)
		if region:garrison_residence():settlement_interface():settlement_type_key() == self.necropolis_settlement_type then
			table.insert(necropolis_regions, region)
		end
	end
	return necropolis_regions
end

episode_nagash_endgame.get_human_capital_regions = function(self)
	local human_capital_regions = {}
	local human_faction_keys = cm:get_human_factions()
	for i = 1, #human_faction_keys do
		local faction = cm:get_faction(human_faction_keys[i])
		if faction:has_home_region() then
			local home_region = faction:home_region()
			table.insert(human_capital_regions, home_region)
		end
	end
	return human_capital_regions
end

episode_nagash_endgame.event_area_has_any_human_regions = function(self, region)
	local region_list = region:regions_in_same_event_area()
	if region_list and not region_list:is_null_interface() then
		for i = 0, region_list:num_items() - 1 do
			if region_list:item_at(i):owning_faction():is_human() then
				return true
			end
		end
	else
		if region:owning_faction():is_human() then
			return true
		end
	end

	return false
end

episode_nagash_endgame.squared_distance_to_closest_region = function(self, region, regions)
	local settlement = region:garrison_residence():settlement_interface()
	local x, y = settlement:logical_position_x(), settlement:logical_position_y()
	
	local closest_squared_distance = -1
	for i = 1, #regions do
		local other_settlement = regions[i]:garrison_residence():settlement_interface()
		local other_x, other_y = other_settlement:logical_position_x(), other_settlement:logical_position_y()
		local distance = distance_squared(x, y, other_x, other_y)
		if closest_squared_distance < 0 or distance < closest_squared_distance then
			closest_squared_distance = distance
		end
	end

	return closest_squared_distance
end

episode_nagash_endgame.get_weighted_regions_for_devastation = function(self)
	local all_regions = cm:model():world():region_manager():region_list()
	local weighted_regions = weighted_list:new()
	local necropolis_regions = self:get_regions_with_a_necropolis()
	local human_capital_regions = self:get_human_capital_regions()

	for i = 0, all_regions:num_items() - 1 do
		local region = all_regions:item_at(i)
		if not devastation_manager:is_region_devastated(region:name()) then
			-- The targeting logic for the Devastated provinces will be weighted random selection based on the proximity to the player and the proximity of a Necropolis in the world
			local weight = 1

			-- Higher chance to be closer to Necropolis
			local squared_distance_to_closest_necropolis = self:squared_distance_to_closest_region(region, necropolis_regions)
			if squared_distance_to_closest_necropolis == 0 then
				weight = weight + self.region_weights.proximity_to_necropolis_coefficient
			elseif squared_distance_to_closest_necropolis > 0 then
				weight = weight + self.region_weights.proximity_to_necropolis_coefficient * self.region_weights.average_distance_to_adjacent_regions / squared_distance_to_closest_necropolis
			end

			if self:event_area_has_any_human_regions(region) then
				-- Lower chance if a player controls part of the area (since we'll devastate the entire area)
				weight = math.min(1, weight / self.region_weights.player_region_coefficient)
			else
				-- Higher chance to be near a player
				local squared_distance_to_closest_human_capital = self:squared_distance_to_closest_region(region, human_capital_regions)
				if squared_distance_to_closest_human_capital > 0 then
					weight = weight + self.region_weights.proximity_to_player_coefficient * self.region_weights.average_distance_to_adjacent_regions / squared_distance_to_closest_human_capital
				end
			end

			weight = math.max(1, math.round(weight)) -- due to underlying implementation, weighted_list only works with positive integers
			weighted_regions:add_item(region, weight)
		end
	end

	return weighted_regions
end

episode_nagash_endgame.devastate_on_round_start = function(self)
	-- Every turn that the final battle is not fought the X* number of provinces are Devastated and given to Nagash around the world

	-- X* being the number of alive mortarchs + 1
	local new_devastations_count = #self.persistent.spawned_mortarchs_cqi + 1
	local nagash_endgame_faction = cm:get_faction(self.nagash_faction_key)
	local nagash_total_armies = 0

	if not nagash_endgame_faction or nagash_endgame_faction:is_null_interface() then 
		return
	end

	-- This effectively means if the player does not fight the battle at some point they will lose their empire and die

	local weighted_regions = self:get_weighted_regions_for_devastation()

	for mf_index = 0, nagash_endgame_faction:military_force_list():num_items() - 1 do 
		local mf = nagash_endgame_faction:military_force_list():item_at(mf_index)
		
		-- Check only against normal armies, disregard transported forces and armed citizenry
		if mf and not mf:is_null_interface() then 
			if not mf:is_armed_citizenry() and 
				not mf:is_transported_army() then
					nagash_total_armies = nagash_total_armies + 1
			end
		end
	end

	for i = 1, new_devastations_count do
		while not weighted_regions:is_empty() do
			local region, _ = weighted_regions:weighted_select(true) -- pops the item out of the list
			if is_region(region) == false then
				break
			end
			if devastation_manager:can_region_be_devastated(region:name()) then
				-- Just transfer to Nagash, the regular devastation check will devastate it.
				self:transfer_event_area_to_nagash(region)

				if nagash_total_armies < self.nagash_army_cap then 
					-- Once a province is Devastated in this way armies will also be spawned from the Devastated region for Nagash
					-- This means provinces local to the player being Devastated are also a threat not just losing your own province
					local unit_list = self.invasion_armies.invasion_weak_unit_list.unit_list
					local devastation_army_template = self.army_template .. "_devastation"
					local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(devastation_army_template, unit_list, self.start_of_turn_devastation_spawned_army_size)
					self:spawn_support_army(self.nagash_faction_key, region, generated_unit_list)
				end
				break
			end
		end
	end
end

episode_nagash_endgame.trigger_event_message = function(self, faction, region)
	if not faction:is_human() then
		return
	end

	local settlement_interface = region:garrison_residence():settlement_interface()
	cm:show_message_event_located(
		faction:name(),
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nagash_endgame_region_lost_title",
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nagash_endgame_region_lost_primary_detail",
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nagash_endgame_region_lost_secondary_detail",
		settlement_interface:display_position_x(),
		settlement_interface:display_position_y(),
		true,
		1977
	)
end

episode_nagash_endgame.play_voiceline = function(self, adivce_level)
	core:cache_and_set_advisor_priority(1500, true)
	cm:show_advice(adivce_level, true, false, nil, 0, 0)
end

----------------------------------------------
-- NAGASH POWER LEVEL SECTION
episode_nagash_endgame.recalculate_nagash_power_level = function(self)
	if is_number(self.persistent.current_stage_index) == false
		or self.persistent.current_stage_index < 0
		or self.persistent.current_stage_index > #self.stages
	then
		return false
	end

	local active_stage = self.stages[self.persistent.current_stage_index]
	if is_table(active_stage) == false
		or is_string(active_stage.stage_key) == false 
	then
		return false
	end

	-- we only recalculate in the pyramid travel phase - once the pyramid arrives the power is fixed
	if active_stage.stage_key ~= "episode_nagash_endgame_stage_main" then
		return
	end

	local score_from_armies = self:score_for_armies()
	cm:set_script_state(self.nagash_power_level_state_keys.from_armies, score_from_armies)

	local score_from_settlements = self:score_for_settlements()
	cm:set_script_state(self.nagash_power_level_state_keys.from_settlements, score_from_settlements)

	local score_from_mortarchs = self:score_for_mortarchs()
	cm:set_script_state(self.nagash_power_level_state_keys.from_mortarchs, score_from_mortarchs)

	local score_from_nagash = self:score_for_nagash()
	cm:set_script_state(self.nagash_power_level_state_keys.from_nagash, score_from_nagash)

	local score_from_devastation = self:score_for_devastation()
	cm:set_script_state(self.nagash_power_level_state_keys.from_devastation, score_from_devastation)

	local total_score = score_from_armies + score_from_settlements + score_from_mortarchs + score_from_nagash + score_from_devastation
	cm:set_script_state(self.nagash_power_level_state_keys.total, total_score)

	local current_power_level_index = nil
	for index, power_level_setup in ipairs(self.scores_for_rank) do
		if power_level_setup.needed_power <= total_score then
			current_power_level_index = index
		end
	end
	
	if self.persistent.current_nagash_power_level_index == current_power_level_index then
		-- no change needed
		return
	end

	-- The higher the power level of the Black Pyramid the stronger Nagash will be in the final battle
	-- The threshold upon arriving at Nagashizzar will be locked in as Nagash’s power level for the final battle and passed to the final battle script
	local current_power_level_setup = self.scores_for_rank[current_power_level_index]
	local previous_power_level_setup = self.scores_for_rank[self.persistent.current_nagash_power_level_index]

	if previous_power_level_setup and is_string(previous_power_level_setup.faction_bundle_key) then
		cm:remove_effect_bundle(previous_power_level_setup.faction_bundle_key, self.nagash_faction_key)
	end
	
	if current_power_level_setup and is_string(current_power_level_setup.faction_bundle_key) then
		cm:apply_effect_bundle(current_power_level_setup.faction_bundle_key, self.nagash_faction_key, 0)
		cm:set_script_state(self.nagash_power_level_state_keys.bundle_key, current_power_level_setup.faction_bundle_key)
	else 
		cm:remove_script_state(self.nagash_power_level_state_keys.bundle_key)
	end
	self.persistent.current_nagash_power_level_index = current_power_level_index
end

episode_nagash_endgame.score_for_armies = function(self)
	local nagash_faction_interface = cm:get_faction(self.nagash_faction_key)
	local military_force_list = nagash_faction_interface:military_force_list();
	local armies_count = 0;
	
	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		
		if mf:has_general() then
			armies_count = armies_count + 1;
		end;
	end;

	local score = armies_count * self.score_per_army
	return score
end

episode_nagash_endgame.score_for_settlements = function(self)
	local nagash_faction_interface = cm:get_faction(self.nagash_faction_key)
	local region_number = nagash_faction_interface:num_regions()
	local score = region_number * self.score_per_settlement
	return score
end

episode_nagash_endgame.score_for_mortarchs = function(self)
	local number_of_spawned_mortarchs = #self.persistent.spawned_mortarchs_cqi
	local score = number_of_spawned_mortarchs * self.score_per_mortarch
	return score
end

episode_nagash_endgame.score_for_nagash = function(self)
	if self:nagash_is_alive() then
		return self.score_per_nagash
	end
	return 0
end

episode_nagash_endgame.score_for_devastation = function(self)
	local number_of_devastated_regions = self.persistent.total_devastated_regions or 0
	local score = number_of_devastated_regions * self.score_per_devastated_province
	return score
end

-- END OF NAGASH POWER LEVEL SECTION
----------------------------------------------

episode_nagash_endgame.on_loaded = function(self)
	self.persistent.current_nagash_power_level_index = self.persistent.current_nagash_power_level_index or -1
	-- if we are migrating from a save where the Nagash Family Member CQI was saved in persistent.nagash_family_member_cqi, we need to migrate it
	if is_number(self.persistent.nagash_family_member_cqi)
		and self.persistent.nagash_family_member_cqi > 0
	then
		self.persistent_nagash_family_member_cqi = self.persistent.nagash_family_member_cqi
	end
end

episode_nagash_endgame.spawn_support_army = function(self, faction_owner_key, region_obj, unit_list, on_sea--[[ = false --]], settlement_region_key--[[ = nil --]], effect_bundle_key--[[ = nil --]])
	if on_sea == nil then
		on_sea = false
	end

	-- settlement_region_key is set only when on_sea = true
	local find_region_key = settlement_region_key or region_obj:name()
	local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
		self.nagash_faction_key,
		find_region_key,
		on_sea,
		not on_sea,
		20)

	if x_pos < 0 or y_pos < 0 then
		return false
	end

	cm:create_force(
		faction_owner_key,
		unit_list,
		find_region_key,
		x_pos,
		y_pos,
		true,
		function(char_cqi, force_cqi)
			if is_string(effect_bundle_key) then
				cm:apply_effect_bundle_to_force(effect_bundle_key, force_cqi, 0)
			end
			local character_obj = cm:get_character_by_cqi(char_cqi);
			local character_details = character_obj:character_details()
			cm:character_details_set_rank(character_details, episode_nagash_endgame.starting_lord_rank_low, false)

			local character_lookup = cm:char_lookup_str(char_cqi)
			cm:add_experience_to_units_commanded_by_character(character_lookup, episode_nagash_endgame.starting_unit_rank_low)
		end
	)
	return true
end

episode_nagash_endgame.try_find_close_non_human_region = function(self, region_obj)
	local adjacent_regions = region_obj:adjacent_region_list()
	for adj_region_index = 0, adjacent_regions:num_items() - 1 do 
		local adj_region = adjacent_regions:item_at(adj_region_index)

		if adj_region:owning_faction():is_human() == false then
			local region_key = adj_region:name()
			local region_owner = adj_region:owning_faction():name()
			return adj_region
		end
	end

	return nil
end

episode_nagash_endgame.remove_nagash_region_pyramid = function(self)
	local black_pyramid_region = cm:get_region(self.black_pyramid_region_key)
	cm:override_building_chain_display(black_pyramid_region:settlement():primary_building_chain(), self.black_pyramid_chain_model_override_key, self.black_pyramid_region_key)
end

episode_nagash_endgame.set_final_battle_modifiers = function(self)
	local currently_devastated_regions = self.persistent.total_devastated_regions
	local active_treshhold_index = -1
	for index, devastation_thresholds in ipairs(self.devastation_thresholds) do
		-- we are interested in the highest index that meets the requirements
		if devastation_thresholds.required_devastation <= currently_devastated_regions then
			active_treshhold_index = index
		end
	end

	for index, devastation_thresholds in ipairs(self.devastation_thresholds) do
		core:svr_save_bool(devastation_thresholds.battle_parameter, index == active_treshhold_index)
	end

	local current_necropolises = #self:get_regions_with_a_necropolis()
	for index, necropolises_thresholds in ipairs(self.necropolis_thresholds) do
		if necropolises_thresholds.required_necropolises <= current_necropolises then
			active_treshhold_index = index
		end
	end

	for index, necropolises_thresholds in ipairs(self.necropolis_thresholds) do
		core:svr_save_bool(necropolises_thresholds.battle_parameter, index == active_treshhold_index)
	end
end

episode_nagash_endgame.declare_war_on_everyone_you_meet = function(self)
	local invasion_faction = cm:get_faction(self.nagash_faction_key)
	local factions_met = invasion_faction:factions_met()

	-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
	cm:postpone_cai_analysis()
	for i = 0, factions_met:num_items() - 1 do
		local other_faction = factions_met:item_at(i)
		self:declare_war_on_faction_or_overlord(other_faction)
	end

	cm:resume_cai_analysis()

	-- No diplomacy with the endgame faction
	cm:force_diplomacy("all", "faction:"..self.nagash_faction_key, "all", false, false, true)
	cm:force_diplomacy("faction:"..self.nagash_faction_key, "all", "all", false, false, true)
end

-- checks if the faction is a vassal. if so - declares war on their overlord. otherwise declares war on the faction
episode_nagash_endgame.declare_war_on_faction_or_overlord = function(self, other_faction_obj, give_diplomatic_bundle--[[ = true --]])
	give_diplomatic_bundle = give_diplomatic_bundle or true
	local invasion_faction = cm:get_faction(self.nagash_faction_key)
	local other_faction_key = other_faction_obj:name()

	if other_faction_key == self.nagash_faction_key
		or other_faction_obj:is_ally_vassal_or_client_state_of(invasion_faction)
		or other_faction_obj:is_dead()
	then
		return
	end
	if give_diplomatic_bundle then
		-- all factions fighting against the invasion faction get a bundle so they support each other
		cm:apply_effect_bundle(self.diplomacy_bundle, other_faction_key, 0)
	end
	if other_faction_obj:at_war_with(invasion_faction) == false then
		-- If this faction is a vassal, declare war on their master to avoid issues
		if other_faction_obj:is_vassal() == true then
			local master_faction = other_faction_obj:master()
			if master_faction:at_war_with(invasion_faction) == false and master_faction:is_dead() == false then
				local master_faction_key = other_faction_obj:master():name()
				cm:force_declare_war(self.nagash_faction_key, master_faction_key, false, false)
				if give_diplomatic_bundle then
					-- we give the bundle to the master as well
					cm:apply_effect_bundle(self.diplomacy_bundle, master_faction_key, 0)
				end
			end
		else
			cm:force_declare_war(self.nagash_faction_key, other_faction_key, false, false)
		end
	end
end

episode_nagash_endgame.on_episode_end = function(self)

	-- we clear the shared states from the episode
	cm:remove_script_state(self.total_devastated_regions_shared_state)
	cm:remove_script_state(self.number_of_spawned_mortarchs_shared_state)
	cm:remove_script_state(self.nagash_pyramid_journey_duration_shared_state)
	cm:remove_script_state(self.nagash_pyramid_start_journey_shared_state)

	for _, power_level_shared_state in dpairs(self.nagash_power_level_state_keys) do
		cm:remove_script_state(power_level_shared_state)
	end
end

episode_nagash_endgame.is_main_invasion_active = function(self)
	local current_stage_index = self.persistent.current_stage_index
	local invasion_index = episodes_manager:get_episode_stage_index_by_name(self, "episode_nagash_endgame_stage_main")
	local final_battle_index = episodes_manager:get_episode_stage_index_by_name(self, "episode_nagash_endgame_stage_battle")
	return is_number(current_stage_index) and (current_stage_index == invasion_index or current_stage_index == final_battle_index)
end

---------------
-- LISTENERS --
---------------

cm:add_first_tick_callback(
	function()
		-- if the load fails (e.g. old save) we try and get it anew
		if (not is_number(episode_nagash_endgame.persistent_nagash_family_member_cqi))
			or episode_nagash_endgame.persistent_nagash_family_member_cqi <= 0
		then
			episode_nagash_endgame.persistent_nagash_family_member_cqi = episode_nagash_endgame:try_get_nagash_family_member_cqi()
		end

		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_nagash_endgame:is_available_this_game() then
			return
		end

		episodes_manager:add_available_episode(episode_nagash_endgame)

		if is_number(episode_nagash_endgame.persistent.pyramid_journey_start_turn) and episode_nagash_endgame.persistent.pyramid_journey_start_turn > 0 then
			episode_nagash_endgame:remove_nagash_region_pyramid()
		end
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			-- unfortunately, the Episode manager is not loading the episode soon enough for our purposes
			-- we need to check episode_nagash_endgame.persistent_nagash_family_member_cqi by the time for add_first_tick_callback to register the episode
			-- so we are forced to load earlier to check if we saved Nagash's family member CQI

			episode_nagash_endgame.persistent_nagash_family_member_cqi = cm:load_named_value(
				episode_nagash_endgame.persistent_nagash_family_member_cqi_saved_value_name, 
				episode_nagash_endgame.persistent_nagash_family_member_cqi, 
				context)
		end
	end
)

cm:add_saving_game_callback(
	function(context)
		-- unfortunately, the Episode manager is not loading the episode soon enough for our purposes
		-- we need to check episode_nagash_endgame.persistent_nagash_family_member_cqi by the time for add_first_tick_callback to register the episode
		-- so we are forced to save the value separately
		cm:save_named_value(episode_nagash_endgame.persistent_nagash_family_member_cqi_saved_value_name, episode_nagash_endgame.persistent_nagash_family_member_cqi, context)
	end
)

--nagash_episode_RegionFactionChangeEvent
core:add_listener(
	"nagash_episode_RegionFactionChangeEvent",
	"RegionFactionChangeEvent",
	function(context)
		if is_number(episode_nagash_endgame.persistent.current_stage_index) == false
			or episode_nagash_endgame.persistent.current_stage_index < 0
			or episode_nagash_endgame.persistent.current_stage_index > #episode_nagash_endgame.stages
		then
			return false
		end

		local active_stage = episode_nagash_endgame.stages[episode_nagash_endgame.persistent.current_stage_index]
		if is_table(active_stage) == false
			or is_string(active_stage.stage_key) == false 
		then
			return false
		end

		-- we only devastate in the 2 stages
		if active_stage.stage_key ~= "episode_nagash_endgame_stage_main"
			and active_stage.stage_key ~= "episode_nagash_endgame_stage_battle"
		then
			return false
		end

		-- we only care about regions taken by Nagash
		local region = context:region()
		local owner_key = region:owning_faction():name()
		if owner_key ~= episode_nagash_endgame.nagash_faction_key then
			return false
		end

		return true
	end,
	function(context)
		episode_nagash_endgame:check_region_devastation(context:region())
		episode_nagash_endgame:recalculate_nagash_power_level()
	end,
	true
)

--episode_nagash_endgame_CharacterConvalescedOrKilled
core:add_listener(
	"episode_nagash_endgame_CharacterConvalescedOrKilled",
	"CharacterConvalescedOrKilled",
	function()
		return is_table(episode_nagash_endgame.persistent.spawned_mortarchs_cqi) and #episode_nagash_endgame.persistent.spawned_mortarchs_cqi > 0
	end,
	function(context)
		local character = context:character()
		local character_fm_cqi = character:family_member():command_queue_index()
		local _element, index = table.find(episode_nagash_endgame.persistent.spawned_mortarchs_cqi, character_fm_cqi)
		if is_number(index) then
			table.remove(episode_nagash_endgame.persistent.spawned_mortarchs_cqi, index)
			cm:set_script_state(episode_nagash_endgame.number_of_spawned_mortarchs_shared_state, #episode_nagash_endgame.persistent.spawned_mortarchs_cqi)
			episode_nagash_endgame:recalculate_nagash_power_level()
		end
	end,
	true
)

--episode_nagash_endgame_WorldStartRound
core:add_listener(
	"episode_nagash_endgame_WorldStartRound",
	"WorldStartRound",
	true,
	function(context)
		if is_number(episode_nagash_endgame.persistent.current_stage_index) == false
			or episode_nagash_endgame.persistent.current_stage_index < 0
			or episode_nagash_endgame.persistent.current_stage_index > #episode_nagash_endgame.stages
		then
			return false
		end

		local active_stage = episode_nagash_endgame.stages[episode_nagash_endgame.persistent.current_stage_index]
		if is_table(active_stage) == false
			or is_string(active_stage.stage_key) == false 
		then
			return false
		end

		if active_stage.stage_key == "episode_nagash_endgame_stage_main" then
			episode_nagash_endgame:recalculate_nagash_power_level()
			episode_nagash_endgame:move_black_pyramid()
		elseif active_stage.stage_key == "episode_nagash_endgame_stage_battle" then
			episode_nagash_endgame:devastate_on_round_start()
		end
	end,
	true
)

--episode_nagash_endgame_PendingBattle
core:add_listener(
	"episode_nagash_endgame_PendingBattle",
	"PendingBattle",
	function()
		local pb = cm:model():pending_battle();
		return pb:quest_mission_key() == episode_nagash_endgame.final_battle_mission_key
	end,
	function()
		episode_nagash_endgame:set_final_battle_modifiers()

		cm:callback(function()
			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_nagash_005")
		end, 0.5)
	end,
	true
)

--episode_nagash_FactionEncountersOtherFaction
core:add_listener(
	"episode_nagash_FactionEncountersOtherFaction",
	"FactionEncountersOtherFaction",
	function(context)
		if is_table(episode_nagash_endgame.persistent) == false
			or (not episode_nagash_endgame.persistent.declare_war_on_everyone_you_meet)
		then
			return false
		end

		return true
	end,
	function(context)
		local faction = context:faction()
		local faction_name = faction:name()

		local other_faction = context:other_faction()
		local other_faction_name = other_faction:name()


		if faction_name == episode_nagash_endgame.nagash_faction_key then
			episode_nagash_endgame:declare_war_on_faction_or_overlord(other_faction)
		elseif other_faction_name == episode_nagash_endgame.nagash_faction_key then
			episode_nagash_endgame:declare_war_on_faction_or_overlord(faction)
		end
	end,
	true
)

--episode_nagash_CharacterDestroyed
core:add_listener(
	"episode_nagash_CharacterDestroyed",
	"CharacterDestroyed",
	function(context)
		-- Someone has defeated Nagash or a Mortarch during the main invasion stage
		return episode_nagash_endgame:is_main_invasion_active() and is_number(episode_nagash_endgame.persistent_nagash_family_member_cqi)
	end,
	function(context)
		local family_member = context:family_member()
		if (not family_member)
			or family_member:is_null_interface()
		then
			return
		end

		-- if Nagash was destroyed, we wound him for a long time
		local character_obj = family_member:character()
		if is_character(character_obj) == false then
			return
		end

		local family_member_cqi = family_member:command_queue_index()
		if episode_nagash_endgame.persistent_nagash_family_member_cqi == family_member_cqi then
			cm:set_character_convalescence_time(character_obj, 999)
			episode_nagash_endgame:play_voiceline("Play_wh3_dlc29_endtimes_narrative_nagash_nagash_004")
			return
		end

		-- if this is one of the mortaches, we also wound them for a long time
		for _, mortarch_family_cqi in dpairs(episode_nagash_endgame.persistent.mortarchs_family_cqi) do
			if mortarch_family_cqi == family_member_cqi then
				cm:set_character_convalescence_time(character_obj, 999)
				return
			end
		end
	end,
	true
)