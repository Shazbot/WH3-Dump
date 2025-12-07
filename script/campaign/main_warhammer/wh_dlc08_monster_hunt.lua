monster_hunt =
{
	config =
	{
		-- Subculture of factions potentially affected by this mechaninc
		subculture = "wh_dlc08_sc_nor_norsca",

		-- Global config for resource rewards for all stages of all hunts. Each stage can add additional rewards or override the amounts.
		global_resource_rewards =
		{
			{
				resource = "wh3_dlc27_nor_kinfolk",
				amount = 50,
				factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
				-- optionally limit by faction
				faction = "wh_dlc08_nor_wintertooth",
			},
			{
				resource = "wh3_dlc27_nor_spoils",
				amount = 200,
				factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
			},
			{
				resource = "treasury",
				amount = 10000,
			},
		},

		-- Rewards from becoming the Ultimate Monster Hunter
		ultimate_monster_hunter_rewards =
		{
			wh_dlc08_nor_norsca = 
			{
				incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
				effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
			},
			wh_dlc08_nor_wintertooth = 
			{
				incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
				effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
			},
			wh3_dlc27_nor_sayl = 
			{
				incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
				effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
			},
		},

		-- Radius of the marker
		marker_radius = 2,

		-- Playable factions that can make use of the mechanic
		playable_monster_hunt_factions =
		{
			"wh_dlc08_nor_norsca",
			"wh_dlc08_nor_wintertooth",
			"wh3_dlc27_nor_sayl",
		},

		-- Auxillary factions used in a specific case when spawning markers
		auxillary_monster_faction = "wh3_dlc27_nor_monstrous_arcanum_wulfrik",

		-- TODO: These are no longer needed?
		-- Used for saves from the previous version of the mechanic that lack the new factions
		monster_faction_per_norsca_faction_alternative_for_old_saves =
		{
			wh_dlc08_nor_norsca = "wh_main_nor_norsca_qb1",
			wh_dlc08_nor_wintertooth = "wh_main_nor_norsca_qb2",
			wh3_dlc27_nor_sayl = "wh_main_nor_norsca_qb3",
		},

		-- We can force a player faction to start a hunt at a certain turn
		forced_hunts =
		{
			wh_dlc08_nor_wintertooth = 5,
		},

		-- Chance to spawn a dilemma at the start of each turn
		dilemma_chance = 30,

		-- Decoy dilemmas are configured per hunt

		-- Pool of possible dilemmas shown every few turns while a hunt is ongoing
		progression_dilemmas = 
		{
			"wh3_dlc27_nor_monster_hunt_dilemma_01",
			"wh3_dlc27_nor_monster_hunt_dilemma_02",
			"wh3_dlc27_nor_monster_hunt_dilemma_03",
			"wh3_dlc27_nor_monster_hunt_dilemma_04",
			"wh3_dlc27_nor_monster_hunt_dilemma_05",
			"wh3_dlc27_nor_monster_hunt_dilemma_06",
			"wh3_dlc27_nor_monster_hunt_dilemma_07",
			"wh3_dlc27_nor_monster_hunt_dilemma_08",
			"wh3_dlc27_nor_monster_hunt_dilemma_09",
			"wh3_dlc27_nor_monster_hunt_dilemma_10",
			"wh3_dlc27_nor_monster_hunt_dilemma_11",
			"wh3_dlc27_nor_monster_hunt_dilemma_12"
		},

		-- Maximum amount of progression dilemmas issued per hunt
		progression_dilemmas_limit = 5,

		-- Dilemma shown if a player is taking a while to complete a hunt
		prolonged_hunt =
		{
			dilemma = "wh3_dlc27_nor_monster_hunt_prolonged_hunt_dilemma",
			turns_to_trigger = 15,
			turns_extension = 5,
			extend_choice = 0,
			abandon_choice = 1,
		},

		--Dilemma for when the monster is found
		monster_found_dilemma = 
		{
			dilemma_key = "wh3_dlc27_nor_monster_hunt_spawn_monster_dilemma",
			attack_choice = 0,
			cancel_choice = 1,
		},

		-- Index of dilemma choice that signifies cancelling the hunt
		dilemma_cancel_choice = 2,

		-- Distances at which markers will attempt to spawn. If there is no config for a marker it will use the last entry.
		marker_distances =
		{
			-- First marker
			{
				min_distance = 1,
				max_distance = 2
			},
			-- Second marker
			{
				min_distance = 1.5,
				max_distance = 3
			},
		},

		-- Distances for markers for replayable hunts
		replayable_hunt_marker_distance =
		{
			min_distance = 2,
			max_distance = 4
		},

		-- Chance for the N-th marker to be the final marker and spawn the monster
		-- Chances after the last entry in the table are considered 100%
		monster_spawn_chance =
		{
			-- Tier 1
			{
				-- Stage 1
				{
					0
				}
			},
			-- Tier 2
			{
				-- Stage 1
				{
					100
				},
				-- Stage 2
				{
					100
				}
			},
			-- Tier 3
			{
				-- Stage 1
				{
					0
				}
			},
		},

		-- Scripted bonus value that modifies the chance for the spawning of the monster of the next marker
		monster_spawn_chance_bonus_value = "monster_spawn_chance",

		-- Scripted bonus value that modifies the distance for spawning of the next marker
		monster_spawn_distance_bonus_value = "monster_spawn_distance",

		-- Scripted bonus value that modifies the hunt rewards
		monster_hunt_resources_bonus_value = "monster_arcanum_resources_reward_increase",

		-- Scripted bonus value that modifies the hunt cooldown
		monster_hunt_cooldown_bonus_value = "monster_arcanum_hunt_cooldown_reduce",

		-- the cooldown end turn is stored in a shared state for easier display
		cooldown_shared_state_name = "shared_state_hunt_cooldown_end_turn",

		-- override the teleportation to the quest battle to be with the selected hunter for the quest
		teleported_character_override_shared_state_name = "teleported_character_override",
		teleported_character_override_mission_shared_state_name = "teleported_character_override_mission_key:",

		-- The algorithm for chooing the location of the marker will increase the distance in case it couldn't find a siutable point at the distance it was
		-- initially attempting. This is the max distance it will attempt, afterwards it will try decreasing the distance instead.
		-- Probably best not to edit this.
		max_marker_distance = 7,

		-- How many markers to use for the heuristic when deciding on a good initial direction for a hunt stage
		heuristic_marker_count = 3,

		-- How fast does the camera scroll to markers
		camera_scroll_speed = 0.5,

		-- Text keys for mission objectives
		stage_1_mission_objective = "campaign_localised_strings_string_wh3_dlc27_monster_hunt_mission_objective_stage_1",
		stage_2_mission_objective = "campaign_localised_strings_string_wh3_dlc27_monster_hunt_mission_objective_stage_2",
		quest_battle_mission_objective = "campaign_localised_strings_string_wh3_dlc27_monster_hunt_mission_objective_quest_battle",

		-- Text keys for event feed message
		event_feed_stage_2_reminder_title = "event_feed_strings_text_wh3_dlc27_scripted_event_nor_monster_hunt_stage_2_reminder_title",
		event_feed_stage_2_reminder_detail = "event_feed_strings_text_wh3_dlc27_scripted_event_nor_monster_hunt_stage_2_reminder_detail",
	
		------------HUNT CONFIGURATION-----------

		-- Config for the tiers
		tier_config =
		{
			--Tier 1 - Taming hunts RoR
			{
				-- This describes the types of the stages for this tier:
				-- "once" - cannot be replayed
				-- "replayable" - can be replayed many times to farm the reward, until the hunt is abandoned
				stages = {"once"},
				-- Cooldown after completing a stage from this tier
				cooldown = 4,
				-- How many hunts from the previous tier are needed to unlock this tier
				hunts_to_unlock = 0,
				-- Which stage is needed to be completed to progress in unlocking the next tier and Ultimate Monster Hunter
				min_hunt_stage_for_tier_unlock = 1,
			},
			-- Tier 2 - Taming Hunts Monster Arcanum
			{
				stages = {"once", "replayable"},
				cooldown = 4,
				hunts_to_unlock = 1,
				min_hunt_stage_for_tier_unlock = 1,
			},
			-- Tier 3 - Trophy hunts
			{
				stages = {"once"},
				cooldown = 4,
				hunts_to_unlock = 3,
				-- How many hunts from the last tier are needed to unlock the  Ultimate Monster Hunter
				hunts_for_umh = 5,
				min_hunt_stage_for_tier_unlock = 1,
			},
		},

		-- For locking/unlocking the mechanic in the UI
		turn_to_unlock =
		{
			wh_dlc08_nor_norsca = 8,
			wh_dlc08_nor_wintertooth = 5,
			wh3_dlc27_nor_sayl = 8,
		},
		disable_mechanic_key = "disable_monster_hunt_button",

		-- the turn to unlock the mechanic is stored in a shared state for easier display
		turn_to_unlock_shared_state_name = "shared_state_monster_hunt_turn_to_unlock",
		
		-- Config for the hunts
		tiers =
		{
			-- tier 1 - Taming Hunts Regiments of Renown
			{
				{
					-- Key of the hunt
					key = "taming_hunts_ror_1",
					-- Localised title key from the campaign_localised_strings table
					title = "monster_hunt_0_title",
					-- Localised description key from the campaign_localised_strings table
					description = "monster_hunt_0_description",
					-- Localised description key from the campaign_localised_strings table
					objective = "monster_hunt_0_objective",
					-- Keys for climate this hunt can be started in
					climates = 
					{
						 "climate_frozen", 
					},
					-- Data for the regions this hunt can be started in.
					-- Either regions or climates are supported but not both together, leave the unused table empty.
					regions =
					{
						--[[
							wh3_main_combi_region_tor_saroir,
							wh3_main_combi_region_gaean_vale
						]]
					},
					-- Display text for regions in the UI, e.g "Ulthuan". Leave as "" if unused
					regions_text_key = "",
					-- Ancillary reward for stage 1
					reward_stage_1_ancillary = "wh_dlc08_anc_enchanted_item_ancient_frost_wyrm_scale",
					-- Regiments of renown unit reward for stage 1
					reward_stage_1_unit_ror = "wh_dlc08_nor_mon_frost_wyrm_ror_0",
					-- Effect bundle reward to be applied to the faction
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_glory_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					-- Mission keys
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_ror_01",
					--Quest battle
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_00",
					--Stage One Mission text reward - must be in campaign_payload_ui_details table
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					-- Optional technology required to unlock the hunt
					technology = "",
					-- Sound to play on challenge (overrides the sound category on the UI element)
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					-- Dynamic dialogue event to play on challenge
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					-- Background for hunt page in ui/skins/default/dlc27_monster_arcanum/monster_arts/
					background = "monster_hunt_0",
					-- Portrait for monster in ui/skins/default/dlc27_monster_arcanum/monster_arts/
					portrait = "monster_hunt_0_portrait",
					-- Pool of possible dilemmas shown on entering a decoy marker
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_00_decoy_dilemma_08",
					},
					-- Rewards for each stage. Rewards defined in the global_resource_rewards config are also given out, they are overriden by this config
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ror_2",
					title = "monster_hunt_6_title",
					description = "monster_hunt_6_description",
					objective = "monster_hunt_6_objective",
					climates = 
					{
						 "climate_frozen",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh_dlc08_anc_magic_standard_ancient_mammoth_cub",
					reward_stage_1_unit_ror = "wh_dlc08_nor_mon_war_mammoth_ror_1",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_glory_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_ror_02",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_06",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "wh3_dlc27_tech_nor_mil_hardened_tusks",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_1",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_6",
					portrait = "monster_hunt_6_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_06_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ror_3",
					--dlc_requirement = "TW_WH3_TIDES_OF_TORMENT_NOR",
					title = "wh3_dlc27_monster_hunt_12_title",
					description = "wh3_dlc27_monster_hunt_12_description",
					objective = "wh3_dlc27_monster_hunt_12_objective",
					climates = 
					{
						 "climate_chaotic",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_spikes_chimera",
					reward_stage_1_unit_ror = "wh3_dlc27_nor_mon_chimera_ror",
					reward_stage_1_unit_ror_required_dlc = "TW_WH3_TIDES_OF_TORMENT_NOR",
					reward_stage_1_unit_ror_no_dlc_alternative = "wh3_dlc27_nor_mon_chimera_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_glory_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_ror_03",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_12",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "wh_dlc08_tech_nor_creatures_01",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_2",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_wh_dlc27_bloodshriek_chimera",
					portrait = "monster_hunt_wh_dlc27_bloodshriek_chimera_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_12_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
			},
			-- tier 2 - Taming Hunts - Monstrous Arcanum
			{
				{
					key = "taming_hunts_ma_1",
					title = "monster_hunt_2_title",
					description = "monster_hunt_2_description",
					objective = "monster_hunt_2_objective",
					climates = 
					{
						 "climate_chaotic",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh_dlc08_anc_enchanted_item_great_horn_of_dragon_ogre",
					reward_stage_2_unit_ma = "wh3_dlc27_chs_mon_dragon_ogre_shaggoth_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_01_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_01_stage_2",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_02",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_2",
					portrait = "monster_hunt_wh_dlc27_dragon_ogre_shaggoth_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_02_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh_dlc08_chs_dragon_ogre_shaggoth_boss",
						army_size = 16,
						mandatory_units = 
						{
							{
								unit_key = "wh_dlc01_chs_mon_dragon_ogre",
								count = 5,
							},
							{
								unit_key = "wh_dlc01_chs_mon_dragon_ogre_shaggoth",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh_dlc01_chs_mon_dragon_ogre_shaggoth",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_feral_manticore",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc01_chs_mon_dragon_ogre",
								random_weight = 1,
							},
							{
								unit_key = "wh_main_chs_mon_trolls",
								random_weight = 2,
							},
							{
								unit_key = "wh_main_chs_mon_chaos_warhounds_0",
								random_weight = 2,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_2",
					title = "wh3_dlc27_monster_hunt_14_title",
					description = "wh3_dlc27_monster_hunt_14_description",
					objective = "wh3_dlc27_monster_hunt_14_objective",
					climates = 
					{
						 "climate_chaotic",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_toad_dragon_venom_glands",
					reward_stage_2_unit_ma = "wh3_dlc27_nur_mon_toad_dragon_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_02_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_02_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_14",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_toad_dragon",
					portrait = "monster_hunt_wh_dlc27_toad_dragon_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_14_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_toad_dragon_boss",
						army_size = 20,
						mandatory_units = 
						{
							{
								unit_key = "wh2_main_skv_inf_plague_monks",
								count = 2,
							},
							{
								unit_key = "wh3_dlc25_bst_inf_pestigors",
								count = 2,
							},
							{
								unit_key = "wh3_dlc25_nur_inf_plague_ogres",
								count = 2,
							},
							{
								unit_key = "wh2_dlc16_skv_mon_brood_horror_0",
								count = 2,
							},
							{
								unit_key = "wh2_main_skv_mon_rat_ogres",
								count = 2,
							},
							{
								unit_key = "wh3_dlc25_nur_mon_bile_trolls",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh3_dlc25_nur_inf_plague_ogres",
								random_weight = 2,
							},
							{
								unit_key = "wh2_main_skv_mon_rat_ogres",
								random_weight = 1,
							},
							{
								unit_key = "wh3_dlc25_nur_mon_bile_trolls",
								random_weight = 2,
							},
							{
								unit_key = "wh3_dlc25_bst_inf_pestigors",
								random_weight = 1,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_3",
					title = "wh3_dlc27_monster_hunt_15_title",
					description = "wh3_dlc27_monster_hunt_15_description",
					objective = "wh3_dlc27_monster_hunt_15_objective",
					climates = 
					{
						 "climate_temperate",
						 "climate_savannah"
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_cockatrice_eye",
					reward_stage_2_unit_ma = "wh3_dlc27_tze_mon_cockatrice_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_03_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_03_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_15",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_cockatrice",
					portrait = "monster_hunt_wh_dlc27_cockatrice_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_15_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_cockatrice_boss",
						army_size = 20,
						mandatory_units = 
						{
							{
								unit_key = "wh3_dlc24_bst_inf_tzaangors",
								count = 3,
							},
							{
								unit_key = "wh_dlc03_bst_inf_bestigor_herd_0",
								count = 3,
							},
							{
								unit_key = "wh3_dlc24_tze_inf_centigors_great_weapons",
								count = 3,
							},
							{
								unit_key = "wh_dlc05_bst_mon_harpies_0",
								count = 2,
							},
							{
								unit_key = "wh_main_chs_mon_chaos_spawn",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh_main_chs_mon_chaos_spawn",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_bestigor_herd_0",
								random_weight = 1,
							},
							{
								unit_key = "wh3_dlc24_bst_inf_tzaangors",
								random_weight = 1,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_4",
					title = "wh3_dlc27_monster_hunt_16_title",
					description = "wh3_dlc27_monster_hunt_16_description",
					objective = "wh3_dlc27_monster_hunt_16_objective",
					climates = 
					{
						 "climate_chaotic",
						 "climate_mountain"
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_feral_manticore_tail",
					reward_stage_2_unit_ma = "wh3_dlc27_chs_feral_manticore_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_04_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_04_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_16",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_feral_manticore",
					portrait = "monster_hunt_wh_dlc27_feral_manticore_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_16_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_feral_manticore_boss",
						army_size = 20,
						mandatory_units = 
						{
							{
								unit_key = "wh_dlc03_bst_inf_bestigor_herd_0",
								count = 4,
							},
							{
								unit_key = "wh_dlc03_bst_inf_centigors_0",
								count = 4,
							},
							{
								unit_key = "wh_dlc03_bst_inf_centigors_1",
								count = 4,
							},
						},
						random_units =
						{
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_0",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_1",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_2",
								random_weight = 1,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_5",
					title = "monster_hunt_1_title",
					description = "monster_hunt_1_description",
					objective = "monster_hunt_1_objective",
					climates = 
					{
						 "climate_temperate",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh_dlc08_anc_talisman_giant_cygor_eyeball",
					reward_stage_2_unit_ma = "wh3_dlc27_bst_inf_cygor_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_05_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_05_stage_2",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_01",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_1",
					portrait = "monster_hunt_1_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_01_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh_dlc08_bst_cygor_boss",
						army_size = 17,
						mandatory_units = 
						{
							{
								unit_key = "wh_dlc03_bst_inf_cygor_0",
								count = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_1",
								count = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_razorgor_herd_0",
								count = 2,
							},
							{
								unit_key = "wh_dlc05_bst_mon_harpies_0",
								count = 3,
							},
						},
						random_units =
						{
							{
								unit_key = "wh_dlc03_bst_inf_cygor_0",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc05_bst_mon_harpies_0",
								random_weight = 3,
							},
							{
								unit_key = "wh_dlc03_bst_inf_razorgor_herd_0",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_0",
								random_weight = 3,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_2",
								random_weight = 3,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_6",
					title = "wh3_dlc27_monster_hunt_17_title",
					description = "wh3_dlc27_monster_hunt_17_description",
					objective = "wh3_dlc27_monster_hunt_17_objective",
					climates = 
					{
						 "climate_jungle",
						 "climate_savannah"
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_jabberslythe_blood",
					reward_stage_2_unit_ma = "wh3_dlc27_bst_mon_jabberslythe_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_06_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_06_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_17",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_jabberslythe",
					portrait = "monster_hunt_wh_dlc27_jabberslythe_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_17_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_jabberslythe_boss",
						army_size = 20,
						mandatory_units = 
						{
							{
								unit_key = "wh2_dlc17_bst_mon_jabberslythe_0",
								count = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_bestigor_herd_0",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh2_dlc17_bst_mon_jabberslythe_0",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_0",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_2",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_razorgor_herd_0",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_bestigor_herd_0",
								random_weight = 3,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_7",
					title = "wh3_dlc27_monster_hunt_18_title",
					description = "wh3_dlc27_monster_hunt_18_description",
					objective = "wh3_dlc27_monster_hunt_18_objective",
					climates = 
					{
						 "climate_temperate",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_ghorgon_blade",
					reward_stage_2_unit_ma = "wh3_dlc27_bst_mon_ghorgon_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_07_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_07_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_18",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_ghorgon",
					portrait = "monster_hunt_wh_dlc27_ghorgon_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_18_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_ghorgon_boss",
						army_size = 16,
						mandatory_units = 
						{
							{
								unit_key = "wh2_dlc17_bst_mon_ghorgon_0",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh2_dlc17_bst_mon_ghorgon_0",
								random_weight = 1,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_0",
								random_weight = 3,
							},
							{
								unit_key = "wh_dlc03_bst_inf_minotaurs_2",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc03_bst_inf_razorgor_herd_0",
								random_weight = 2,
							},
							{
								unit_key = "wh_dlc05_bst_mon_harpies_0",
								random_weight = 3,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "taming_hunts_ma_10",
					title = "wh3_dlc27_monster_hunt_21_title",
					description = "wh3_dlc27_monster_hunt_21_description",
					objective = "wh3_dlc27_monster_hunt_21_objective",
					climates = 
					{
						 "climate_temperate",
					},
					regions = {},
					regions_text_key = "",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_preyton_horns",
					reward_stage_2_unit_ma = "wh3_dlc27_sla_mon_preyton_monst_arcanum_reward",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_1",
					reward_stage_1_effect_bundle_duration = 10,
					reward_stage_2_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_taming_hunt_reward_bundle_2",
					reward_stage_2_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_taming_10_stage_1",
					mission_stage_2 = "wh3_dlc27_nor_monster_hunt_taming_10_stage_2",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_21",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_taming",
					background = "monster_hunt_wh_dlc27_preyton",
					portrait = "monster_hunt_wh_dlc27_preyton_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_21_decoy_dilemma_08",
					},
					generated_army =
					{
						general_agent_subtype = "wh3_dlc27_nor_mon_preyton_boss",
						army_size = 20,
						mandatory_units = 
						{
							{
								unit_key = "wh2_dlc10_def_inf_sisters_of_slaughter",
								count = 2,
							},
							{
								unit_key = "wh3_dlc27_sla_inf_devotees_of_slaanesh",
								count = 3,
							},
							{
								unit_key = "wh3_dlc27_sla_inf_slaangors",
								count = 2,
							},
							{
								unit_key = "wh3_dlc27_sla_inf_devotees_of_slaanesh_crossbows",
								count = 2,
							},
							{
								unit_key = "wh2_dlc16_wef_mon_wolves_0",
								count = 2,
							},
						},
						random_units =
						{
							{
								unit_key = "wh3_dlc27_sla_mon_preyton",
								random_weight = 1,
							},
							{
								unit_key = "wh3_dlc27_sla_inf_devotees_of_slaanesh",
								random_weight = 2,
							},
							{
								unit_key = "wh3_dlc27_sla_inf_devotees_of_slaanesh_crossbows",
								random_weight = 2,
							},
							{
								unit_key = "wh3_main_sla_mon_fiends_of_slaanesh_0",
								random_weight = 1,
							},
						},
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 5000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 100,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 30,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
						-- Stage 2
						{
							{
								resource = "treasury",
								amount = 7500,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 200,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 50,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
			},
			-- tier 3 - Trophy Hunt
			{
				{
					key = "trophy_hunts_1",
					title = "monster_hunt_3_title",
					description = "monster_hunt_3_description",
					objective = "monster_hunt_3_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_agrul_migdhal",
						"wh3_main_combi_region_deff_gorge",
						"wh3_main_combi_region_gor_gazan",
						"wh3_main_combi_region_karak_azgal",
						"wh3_main_combi_region_kradtommen",
						"wh3_main_combi_region_misty_mountain",
						"wh3_main_combi_region_barag_dawazbag",
						"wh3_main_combi_region_barak_varr",
						"wh3_main_combi_region_dok_karaz",
						"wh3_main_combi_region_varenka_hills",
						"wh3_main_combi_region_black_crag",
						"wh3_main_combi_region_iron_rock",
						"wh3_main_combi_region_karag_dron",
						"wh3_main_combi_region_crooked_fang_fort",
						"wh3_main_combi_region_dringorackaz",
						"wh3_main_combi_region_spitepeak",
						"wh3_main_combi_region_karak_eight_peaks",
						"wh3_main_combi_region_valayas_sorrow",
						"wh3_main_combi_region_floating_village",
						"wh3_main_combi_region_morgheim",
						"wh3_main_combi_region_sunken_khernarch",
						"wh3_main_combi_region_galbaraz",
						"wh3_main_combi_region_gronti_mingol",
						"wh3_main_combi_region_stormhenge",
						"wh3_main_combi_region_karaz_a_karak",
						"wh3_main_combi_region_mount_squighorn",
						"wh3_main_combi_region_the_pillars_of_grungni",
						"wh3_main_combi_region_bitterstone_mine",
						"wh3_main_combi_region_dragonhorn_mines",
						"wh3_main_combi_region_ekrund",
						"wh3_main_combi_region_stonemine_tower",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_arachnarok_spider_regions",
					reward_stage_1_ancillary = "wh_dlc08_anc_enchanted_item_arachnarok_eggs",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_01",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_03",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_3",
					portrait = "monster_hunt_3_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_03_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_2",
					title = "monster_hunt_4_title",
					description = "monster_hunt_4_description",
					objective = "monster_hunt_4_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_monolith_of_festerlung",
						"wh3_main_combi_region_the_burning_monolith",
						"wh3_main_combi_region_the_howling_citadel",
						"wh3_dlc20_combi_region_dragons_death",
						"wh3_main_combi_region_floating_mountain",
						"wh3_main_combi_region_the_challenge_stone",
						"wh3_main_combi_region_bloodwind_keep",
						"wh3_main_combi_region_dragons_crossroad",
						"wh3_main_combi_region_iron_storm",
						"wh3_main_combi_region_the_gallows_tree",
						"wh3_main_combi_region_zanbaijin",
						"wh3_main_combi_region_desolation_ridge",
						"wh3_main_combi_region_broken_mount",
						"wh3_main_combi_region_dark_tower",
						"wh3_main_combi_region_rotten_stone",
						"wh3_main_combi_region_blood_mountain",
						"wh3_main_combi_region_infernius",
						"wh3_main_combi_region_the_silvered_tower_of_sorcerers",
						"wh3_main_combi_region_port_of_secrets",
						"wh3_main_combi_region_the_crystal_spires",
						"wh3_main_combi_region_volcanos_heart",
						"wh3_main_combi_region_fortress_of_eyes",
						"wh3_main_combi_region_the_volary",
						"wh3_main_combi_region_monolith_of_bubonicus",
						"wh3_main_combi_region_the_bleeding_spire",
						"wh3_main_combi_region_the_writhing_fortress",
						"wh3_main_combi_region_palace_of_princes",
						"wh3_main_combi_region_the_fetid_catacombs",
						"wh3_main_combi_region_the_folly_of_malofex",
						"wh3_main_combi_region_the_twisted_towers",
						"wh3_main_combi_region_black_rock",
						"wh3_main_combi_region_cliff_of_beasts",
						"wh3_main_combi_region_the_blighted_grove",
						"wh3_main_combi_region_bilious_cliffs",
						"wh3_main_combi_region_the_forest_of_decay",
						"wh3_main_combi_region_the_tower_of_flies",
						"wh3_main_combi_region_foundry_of_bones",
						"wh3_main_combi_region_red_fortress",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_giant_regions",
					reward_stage_1_ancillary = "wh_dlc08_anc_weapon_stinky_giant_club",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_02",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_04",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_4",
					portrait = "monster_hunt_4_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_04_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_3",
					title = "monster_hunt_5_title",
					description = "monster_hunt_5_description",
					objective = "monster_hunt_5_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_waterfall_palace",
						"wh3_main_combi_region_kings_glade",
						"wh3_main_combi_region_vauls_anvil_loren",
						"wh3_main_combi_region_crag_halls_of_findol",
						"wh3_main_combi_region_the_oak_of_ages",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_forest_dragon_regions",
					reward_stage_1_ancillary = "wh_dlc08_anc_weapon_forest_dragon_fang",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_03",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_05",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_5",
					portrait = "monster_hunt_5_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_05_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_4",
					title = "monster_hunt_7_title",
					description = "monster_hunt_7_description",
					objective = "monster_hunt_7_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_averheim",
						"wh3_main_combi_region_grenzstadt",
						"wh3_main_combi_region_the_moot",
						"wh3_main_combi_region_castle_templehof",
						"wh3_main_combi_region_fort_oberstyre",
						"wh3_main_combi_region_waldenhof",
						"wh3_main_combi_region_bechafen",
						"wh3_main_combi_region_essen",
						"wh3_main_combi_region_mordheim",
						"wh3_main_combi_region_nagenhof",
						"wh3_main_combi_region_fort_jakova",
						"wh3_main_combi_region_igerov",
						"wh3_main_combi_region_vitevo",
						"wh3_main_combi_region_zavastra",
						"wh3_main_combi_region_castle_drakenhof",
						"wh3_main_combi_region_eschen",
						"wh3_main_combi_region_swartzhafen",
						"wh3_main_combi_region_flensburg",
						"wh3_main_combi_region_niedling",
						"wh3_main_combi_region_wurtbad",
						"wh3_main_combi_region_kappelburg",
						"wh3_main_combi_region_kemperbad",
						"wh3_main_combi_region_krugenheim",
						"wh3_main_combi_region_talabheim",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_terrorgheist_regions",
					reward_stage_1_ancillary = "wh_dlc08_anc_talisman_terrorgheist_skull",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_04",
					quest_battle = "wh_dlc08_qb_nor_monster_hunt_07",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_7",
					portrait = "monster_hunt_7_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_07_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_5",
					title = "monster_hunt_8_title",
					description = "monster_hunt_8_description",
					objective = "monster_hunt_8_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_tor_saroir",
						"wh3_main_combi_region_gaean_vale",
						"wh3_main_combi_region_evershale",
						"wh3_main_combi_region_vauls_anvil_ulthuan",
						"wh3_main_combi_region_tor_sethai",
						"wh3_main_combi_region_tor_achare",
						"wh3_main_combi_region_shrine_of_kurnous",
						"wh3_main_combi_region_elisia",
						"wh3_main_combi_region_tor_koruali",
						"wh3_main_combi_region_mistnar",
						"wh3_main_combi_region_eagle_gate",
						"wh3_main_combi_region_tower_of_lysean",
						"wh3_main_combi_region_shrine_of_asuryan",
						"wh3_main_combi_region_lothern",
						"wh3_main_combi_region_angerrial",
						"wh3_main_combi_region_whitefire_tor",
						"wh3_main_combi_region_tor_elyr",
						"wh3_main_combi_region_griffon_gate",
						"wh3_main_combi_region_tralinia",
						"wh3_main_combi_region_tor_yvresse",
						"wh3_main_combi_region_phoenix_gate",
						"wh3_main_combi_region_white_tower_of_hoeth",
						"wh3_main_combi_region_tor_finu",
						"wh3_main_combi_region_port_elistor",
						"wh3_main_combi_region_shrine_of_loec",
						"wh3_main_combi_region_elessaeli",
						"wh3_main_combi_region_cairn_thel",
						"wh3_main_combi_region_whitepeak",
						"wh3_main_combi_region_tor_anroc",
						"wh3_main_combi_region_avethir",
						"wh3_main_combi_region_unicorn_gate",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_flamespyre_phoenix_regions",
					reward_stage_1_ancillary = "wh2_dlc10_anc_enchanted_item_burning_phoenix_pinion",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_05",
					quest_battle = "wh2_dlc10_qb_nor_monster_hunt_08",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_8",
					portrait = "monster_hunt_8_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_08_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_6",
					title = "monster_hunt_9_title",
					description = "monster_hunt_9_description",
					objective = "monster_hunt_9_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_cuexotl",
						"wh3_main_combi_region_nahuontl",
						"wh3_main_combi_region_sun_tree_glades",
						"wh3_main_combi_region_dawns_light",
						"wh3_main_combi_region_fortress_of_dawn",
						"wh3_main_combi_region_tor_surpindar",
						"wh3_main_combi_region_serpent_coast",
						"wh3_main_combi_region_temple_of_skulls",
						"wh3_main_combi_region_the_cursed_jungle",
						"wh3_main_combi_region_yuatek",
						"wh3_main_combi_region_zlatlan",
						"wh3_main_combi_region_teotiqua",
						"wh3_main_combi_region_the_golden_tower",
						"wh3_main_combi_region_caverns_of_sotek",
						"wh3_main_combi_region_soteks_trail",
						"wh3_main_combi_region_temple_avenue_of_gold",
						"wh3_main_combi_region_deaths_head_monoliths",
						"wh3_main_combi_region_statues_of_the_gods",
						"wh3_main_combi_region_tlaqua",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_carnosaur_regions",
					reward_stage_1_ancillary = "wh2_dlc10_anc_talisman_carnosaur_skull",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_06",
					quest_battle = "wh2_dlc10_qb_nor_monster_hunt_09",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_9",
					portrait = "monster_hunt_9_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_09_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_7",
					title = "monster_hunt_10_title",
					description = "monster_hunt_10_description",
					objective = "monster_hunt_10_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_dlc20_combi_region_glacial_gardens",
						"wh3_main_combi_region_the_palace_of_ruin",
						"wh3_main_combi_region_blacklight_tower",
						"wh3_main_combi_region_shrine_of_ladrielle",
						"wh3_main_combi_region_the_monoliths",
						"wh3_main_combi_region_har_kaldra",
						"wh3_main_combi_region_naggarond",
						"wh3_dlc20_combi_region_glacier_encampment",
						"wh3_main_combi_region_dagraks_end",
						"wh3_main_combi_region_ironfrost",
						"wh3_main_combi_region_ashrak",
						"wh3_main_combi_region_chill_road",
						"wh3_main_combi_region_ghrond",
						"wh3_main_combi_region_the_great_arena",
						"wh3_main_combi_region_cragroth_deep",
						"wh3_main_combi_region_hag_graef",
						"wh3_main_combi_region_temple_of_khaine",
						"wh3_main_combi_region_black_creek_spire",
						"wh3_main_combi_region_karond_kar",
						"wh3_main_combi_region_slavers_point",
						"wh3_main_combi_region_hoteks_column",
						"wh3_main_combi_region_the_black_forests",
						"wh3_main_combi_region_har_ganeth",
						"wh3_main_combi_region_kauark",
						"wh3_main_combi_region_spite_reach",
						"wh3_main_combi_region_the_black_pillar",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_war_hydra_regions",
					reward_stage_1_ancillary = "wh2_dlc10_anc_talisman_hydra_head",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_07",
					quest_battle = "wh2_dlc10_qb_nor_monster_hunt_10",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_10",
					portrait = "monster_hunt_10_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_10_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_8",
					title = "monster_hunt_11_title",
					description = "monster_hunt_11_description",
					objective = "monster_hunt_11_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_hell_pit",
						"wh3_main_combi_region_novchozy",
						"wh3_main_combi_region_plesk",
						"wh3_main_combi_region_volksgrad",
						"wh3_main_combi_region_yetchitch",
						"wh3_main_combi_region_khazid_bordkarag",
						"wh3_main_combi_region_kraka_drak",
						"wh3_main_combi_region_sjoktraken",
						"wh3_main_combi_region_frozen_landing",
						"wh3_main_combi_region_temple_of_heimkel",
						"wh3_main_combi_region_praag",
						"wh3_main_combi_region_castle_alexandronov",
						"wh3_main_combi_region_fort_ostrosk",
						"wh3_main_combi_region_fort_straghov",
						"wh3_main_combi_region_zoishenk",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_hell_pit_abomination_regions",
					reward_stage_1_ancillary = "wh2_dlc10_anc_weapon_warptech_arsenal",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_08",
					quest_battle = "wh2_dlc10_qb_nor_monster_hunt_11",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_11",
					portrait = "monster_hunt_11_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_11_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_9",
					title = "wh3_dlc27_monster_hunt_22_title",
					description = "wh3_dlc27_monster_hunt_22_description",
					objective = "wh3_dlc27_monster_hunt_22_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_ironspike",
						"wh3_main_combi_region_scarpels_lair",
						"wh3_main_combi_region_sulpharets",
						"wh3_main_combi_region_tyrant_peak",
						"wh3_main_combi_region_hag_hall",
						"wh3_main_combi_region_temple_of_addaioth",
						"wh3_main_combi_region_vauls_anvil_naggaroth",
						"wh3_main_combi_region_altar_of_ultimate_darkness",
						"wh3_main_combi_region_drackla_spire",
						"wh3_main_combi_region_eldar_spire",
						"wh3_main_combi_region_rackdo_gorge",
						"wh3_main_combi_region_shroktak_mount",
						"wh3_main_combi_region_ice_rock_gorge",
						"wh3_main_combi_region_plain_of_dogs",
						"wh3_main_combi_region_circle_of_destruction",
						"wh3_main_combi_region_clar_karond",
						"wh3_main_combi_region_storag_kor",
						"wh3_main_combi_region_venom_glade",
						"wh3_main_combi_region_arnheim",
						"wh3_main_combi_region_bleak_hold_fortress",
						"wh3_main_combi_region_forest_of_arnheim",
						"wh3_main_combi_region_the_moon_shard",
						"wh3_main_combi_region_ancient_city_of_quintex",
						"wh3_main_combi_region_grey_rock_point",
						"wh3_main_combi_region_petrified_forest",
						"wh3_main_combi_region_ssildra_tor",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_black_dragon_regions",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_black_dragon_skull",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_09",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_22",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_wh_dlc27_black_dragon",
					portrait = "monster_hunt_wh_dlc27_black_dragon_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_22_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
	 			{
	 				key = "trophy_hunts_10",
	 				title = "wh3_dlc27_monster_hunt_23_title",
	 				description = "wh3_dlc27_monster_hunt_23_description",
	 				objective = "wh3_dlc27_monster_hunt_23_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_floating_pyramid",
						"wh3_main_combi_region_isle_of_the_crimson_skull",
						"wh3_main_combi_region_the_high_sentinel",
						"wh3_main_combi_region_altar_of_the_horned_rat",
						"wh3_main_combi_region_marks_of_the_old_ones",
						"wh3_main_combi_region_fallen_gates",
						"wh3_main_combi_region_hexoatl",
						"wh3_main_combi_region_macu_peaks",
						"wh3_main_combi_region_pillars_of_unseen_constellations",
						"wh3_main_combi_region_the_blood_hall",
						"wh3_main_combi_region_wellsprings_of_eternity",
						"wh3_main_combi_region_monument_of_the_moon",
						"wh3_main_combi_region_pahuax",
						"wh3_main_combi_region_shrine_of_sotek",
						"wh3_main_combi_region_swamp_town",
						"wh3_main_combi_region_axlotl",
						"wh3_main_combi_region_the_blood_swamps",
						"wh3_main_combi_region_xlanhuapec",
						"wh3_main_combi_region_itza",
						"wh3_main_combi_region_quetza",
						"wh3_main_combi_region_xhotl",
						"wh3_main_combi_region_temple_of_tlencan",
						"wh3_main_combi_region_tlanxla",
						"wh3_main_combi_region_tlaxtlan",
						"wh3_main_combi_region_xahutec",
						"wh3_main_combi_region_monument_of_izzatal",
						"wh3_main_combi_region_spektazuma",
						"wh3_main_combi_region_temple_of_kara",
						"wh3_main_combi_region_chaqua",
						"wh3_main_combi_region_hualotal",
						"wh3_main_combi_region_quittax",
						"wh3_main_combi_region_port_reaver",
						"wh3_main_combi_region_skeggi",
						"wh3_main_combi_region_ziggurat_of_dawn",
						"wh3_main_combi_region_oyxl",
						"wh3_main_combi_region_subatuun",
						"wh3_main_combi_region_the_sentinel_of_time",
						"wh3_main_combi_region_chamber_of_visions",
						"wh3_main_combi_region_golden_ziggurat",
						"wh3_main_combi_region_great_turtle_isle",
						"wh3_main_combi_region_sentinels_of_xeti",
						"wh3_main_combi_region_pox_marsh",
						"wh3_main_combi_region_the_awakening",
						"wh3_main_combi_region_tlax",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_dread_saurian_regions",
	 				reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_dread_saurian_tooth",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
	 				mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_10",
	 				quest_battle = "wh3_dlc27_qb_nor_monster_hunt_23",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
	 				technology = "",
	 				audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
	 				audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
	 				background = "monster_hunt_wh_dlc27_dread_saurian",
	 				portrait = "monster_hunt_wh_dlc27_dread_saurian_portrait",
	 				decoy_dilemmas = 
	 				{
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_01",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_02",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_03",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_04",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_05",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_06",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_07",
	 					"wh3_dlc27_nor_monster_hunt_23_decoy_dilemma_08",
	 				},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
				{
					key = "trophy_hunts_11",
					title = "wh3_dlc27_monster_hunt_24_title",
					description = "wh3_dlc27_monster_hunt_24_description",
					objective = "wh3_dlc27_monster_hunt_24_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_al_haikk",
						"wh3_main_combi_region_copher",
						"wh3_main_combi_region_fyrus",
						"wh3_main_combi_region_great_desert_of_araby",
						"wh3_main_combi_region_black_pyramid_of_nagash",
						"wh3_main_combi_region_lashiek",
						"wh3_main_combi_region_sorcerers_islands",
						"wh3_main_combi_region_wizard_caliphs_palace",
						"wh3_main_combi_region_khemri",
						"wh3_main_combi_region_numas",
						"wh3_main_combi_region_quatar",
						"wh3_main_combi_region_springs_of_eternal_life",
						"wh3_main_combi_region_plain_of_tuskers",
						"wh3_main_combi_region_sudenburg",
						"wh3_main_combi_region_antoch",
						"wh3_main_combi_region_bhagar",
						"wh3_main_combi_region_ka_sabar",
						"wh3_main_combi_region_black_tower_of_arkhan",
						"wh3_main_combi_region_el_kalabad",
						"wh3_main_combi_region_pools_of_despair",
						"wh3_main_combi_region_zandri",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_carrion_regions",
					reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_carrion_spine",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
					mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_11",
					quest_battle = "wh3_dlc27_qb_nor_monster_hunt_24",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
					technology = "",
					audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
					audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
					background = "monster_hunt_wh_dlc27_carrion",
					portrait = "monster_hunt_wh_dlc27_carrion_portrait",
					decoy_dilemmas = 
					{
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_01",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_02",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_03",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_04",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_05",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_06",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_07",
						"wh3_dlc27_nor_monster_hunt_24_decoy_dilemma_08",
					},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
	 			{
	 				key = "trophy_hunts_12",
	 				title = "wh3_dlc27_monster_hunt_25_title",
	 				description = "wh3_dlc27_monster_hunt_25_description",
	 				objective = "wh3_dlc27_monster_hunt_25_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_fu_hung",
						"wh3_main_combi_region_temple_of_elemental_winds",
						"wh3_main_combi_region_village_of_the_tigermen",
						"wh3_main_combi_region_gateway_to_khuresh",
						"wh3_main_combi_region_hidden_landing",
						"wh3_main_combi_region_mountain_pass",
						"wh3_main_combi_region_southern_outpost",
						"wh3_main_combi_region_celestial_monastery",
						"wh3_main_combi_region_zhanshi",
						"wh3_main_combi_region_baleful_hills",
						"wh3_main_combi_region_bridge_of_heaven",
						"wh3_main_combi_region_shang_wu",
						"wh3_main_combi_region_shi_long",
						"wh3_main_combi_region_jade_wind_mountain",
						"wh3_main_combi_region_kunlan",
						"wh3_main_combi_region_village_of_the_moon",
						"wh3_main_combi_region_xing_po",
						"wh3_main_combi_region_nan_gau",
						"wh3_main_combi_region_nan_li",
						"wh3_main_combi_region_city_of_the_shugengan",
						"wh3_main_combi_region_ming_zhu",
						"wh3_main_combi_region_wei_jin",
						"wh3_main_combi_region_beichai",
						"wh3_main_combi_region_chimai",
						"wh3_main_combi_region_fu_chow",
						"wh3_main_combi_region_po_mei",
						"wh3_main_combi_region_terracotta_graveyard",
						"wh3_main_combi_region_weng_chang",
						"wh3_main_combi_region_li_temple",
						"wh3_main_combi_region_li_zhu",
						"wh3_main_combi_region_shi_wu",
						"wh3_main_combi_region_nonchang",
						"wh3_main_combi_region_shiyamas_rest",
						"wh3_main_combi_region_haichai",
						"wh3_main_combi_region_zhizhu",
						"wh3_main_combi_region_dai_cheng",
						"wh3_main_combi_region_tower_of_ashung",
						"wh3_main_combi_region_bamboo_crossing",
						"wh3_main_combi_region_waili_village",
						"wh3_main_combi_region_shang_yang",
						"wh3_main_combi_region_shrine_of_the_alchemist",
						"wh3_main_combi_region_tai_tzu",
						"wh3_main_combi_region_hanyu_port",
						"wh3_main_combi_region_qiang",
						"wh3_main_combi_region_xen_wu",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_celestial_lion_regions",
	 				reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_celestial_lion_feathers",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
	 				mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_12",
	 				quest_battle = "wh3_dlc27_qb_nor_monster_hunt_25",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
	 				technology = "",
	 				audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
	 				audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
	 				background = "monster_hunt_wh_dlc27_celestial_lion",
	 				portrait = "monster_hunt_wh_dlc27_celestial_lion_portrait",
	 				decoy_dilemmas = 
	 				{
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_01",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_02",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_03",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_04",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_05",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_06",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_07",
	 					"wh3_dlc27_nor_monster_hunt_25_decoy_dilemma_08",
	 				},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
	 			{
	 				key = "trophy_hunts_13",
	 				title = "wh3_dlc27_monster_hunt_20_title",
	 				description = "wh3_dlc27_monster_hunt_20_description",
	 				objective = "wh3_dlc27_monster_hunt_20_objective",
					climates = 
					{
					},
					regions = 
					{
						"wh3_main_combi_region_pigbarter",
						"wh3_main_combi_region_ruins_end",
						"wh3_dlc23_combi_region_blasted_expanse",
						"wh3_main_combi_region_desolation_of_drakenmoor",
						"wh3_main_combi_region_howling_rock",
						"wh3_main_combi_region_silver_pinnacle",
						"wh3_main_combi_region_crookback_mountain",
						"wh3_main_combi_region_mount_grey_hag",
						"wh3_main_combi_region_mount_silverspear",
						"wh3_main_combi_region_black_fortress",
						"wh3_main_combi_region_darkhold",
						"wh3_main_combi_region_the_sentinels",
						"wh3_main_combi_region_ash_ridge_mountains",
						"wh3_main_combi_region_the_bone_gulch",
						"wh3_main_combi_region_the_fortress_of_vorag",
						"wh3_dlc23_combi_region_gash_kadrak",
						"wh3_main_combi_region_the_falls_of_doom",
						"wh3_main_combi_region_zharr_naggrund",
						"wh3_main_combi_region_the_daemons_stump",
						"wh3_main_combi_region_the_gates_of_zharr",
						"wh3_main_combi_region_tower_of_gorgoth",
						"wh3_dlc23_combi_region_fort_dorznye_vort",
						"wh3_main_combi_region_great_skull_lakes",
						"wh3_main_combi_region_uzkulak",
					},
					regions_text_key = "ui_text_replacements_localised_text_wh3_dlc27_nor_ma_bale_taurus_regions",
	 				reward_stage_1_ancillary = "wh3_dlc27_anc_enchanted_item_bale_taurus_head",
					reward_stage_1_effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_trophy_hunt_reward_bundle",
					reward_stage_1_effect_bundle_duration = 10,
	 				mission_stage_1 = "wh3_dlc27_nor_monster_hunt_trophy_13",
	 				quest_battle = "wh3_dlc27_qb_nor_monster_hunt_20",
					stage_1_mission_reward_text = "dummy_monst_arcanum_monster_found",
	 				technology = "",
	 				audio_sound_cat_override = "UI_CAM_HUD_monster_hunt_0",
	 				audio_dialogue_event = "campaign_vo_nor_monstrous_arcanum_hunt_killing",
	 				background = "monster_hunt_wh_dlc27_bale_taurus",
	 				portrait = "monster_hunt_wh_dlc27_bale_taurus_portrait",
	 				decoy_dilemmas = 
	 				{
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_01",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_02",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_03",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_04",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_05",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_06",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_07",
	 					"wh3_dlc27_nor_monster_hunt_20_decoy_dilemma_08",
	 				},
					resource_rewards =
					{
						-- Stage 1
						{
							{
								resource = "treasury",
								amount = 10000,
							},
							{
								resource = "wh3_dlc27_nor_spoils",
								amount = 300,
								factor = "wh3_dlc27_nor_spoils_monstrous_arcanum",
							},
							{
								resource = "wh3_dlc27_nor_kinfolk",
								amount = 70,
								factor = "wh3_dlc27_nor_kinfolk_monstrous_arcanum",
								-- optionally limit by faction
								faction = "wh_dlc08_nor_wintertooth",
							},
						},
					}
				},
			},
		},
	},
	--- END OF CONFIG-----

	persistent = 
	{},
	dev_force_enabled = false,
	faction_persistent_template =
	{
		active_hunt = nil,
		active_mission = nil,
		marker_index = 0,
		marker_position_x = nil,
		marker_position_y = nil,
		tier_unlocked = {},
		hunt_states = {},
		cooldown_end_turn = 0,
		turn_hunt_started = nil,
		turn_hunt_will_end = nil,
		decoy_dilemmas = {},
		progression_dilemmas = nil,
		progression_dilemmas_issued = 0,
		last_character_cqi_in_marker = nil,
		monster_found = false,
		monster_units = "",
		ultimate_monster_hunter_performed = false,
		has_started_at_least_one_hunt  = false,
		hunter_cqi = nil,
	},
	--[[ Hunt state takes the form
	{
		is_stage_started = bool,
		last_completed_stage = number,
		is_completed = bool,
		direction = number, -- Used to maintain the same map direction when generating stage markers
	}
	--]]
	ui_persistent =
	{
		has_panel_been_opened = false
	},
	cai_config =
	{
		cai_hunt_cooldown = 6,
		cai_hunt_tier_thresholds = 
		{
			5, -- Tier [index] will start at turn [value]
			20,
			40,
		},
	},

	initialize = function()
		local norsca_factions = cm:get_factions_by_subculture(monster_hunt.config.subculture)
		for _, norsca_faction in ipairs(norsca_factions) do
			if norsca_faction:is_human() then
				for tier_index = 1, #monster_hunt.config.tiers do
					local tier_data = monster_hunt.config.tiers[tier_index]
					for _, hunt_data in ipairs(tier_data) do
						for stage = 1, #monster_hunt.config.tier_config[tier_index].stages do
							monster_hunt.setup_scripted_mission(norsca_faction:name(), hunt_data.key, stage)
						end
					end
				end
			end
		end
	end,


	on_load = function()
		-- Prepare hunt army pools
		for tier_index = 1, #monster_hunt.config.tiers do
			for i = 1, #monster_hunt.config.tiers[tier_index] do
				local data = monster_hunt.config.tiers[tier_index][i]
				local army_data = data.generated_army
				if army_data then
					random_army_manager:new_force(data.key)

					if is_table(army_data.mandatory_units) then
						for unit_index = 1, #army_data.mandatory_units do
							local unit_data = army_data.mandatory_units[unit_index]
							random_army_manager:add_mandatory_unit(data.key, unit_data.unit_key, unit_data.count)
						end
					end

					if is_table(army_data.random_units) then
						for unit_index = 1, #army_data.random_units do
							local unit_data = army_data.random_units[unit_index]
							random_army_manager:add_unit(data.key, unit_data.unit_key, unit_data.random_weight)
						end
					end
				end
			end
		end
	end,

	-- Convert saves from previous version of the mechanic
	convert_saves = function()
		for faction_key, data in dpairs(monster_hunt.persistent) do
			if data.monster_hunt_0 then

				local hunts_to_complete = {}
				
				for _, hunt_data in dpairs(data) do
					if hunt_data.state == "in_progress" then
						cm:cancel_custom_mission(faction_key, hunt_data.qb)

						if cm:is_multiplayer() then
							cm:cancel_custom_mission(faction_key, hunt_data.mpc_mission)
						else
							cm:cancel_custom_mission(faction_key, hunt_data.mission)
						end
					elseif hunt_data.state == "completed" then
						-- cannot match by monster, so match them by ancillary reward
						local ancillary_key = hunt_data.reward
						local found = false
						for tier, tier_data in ipairs(monster_hunt.config.tiers) do
							for _, hunt_data in ipairs(tier_data) do
								if hunt_data.reward_stage_1_ancillary and hunt_data.reward_stage_1_ancillary == ancillary_key then
									table.insert(hunts_to_complete, hunt_data.key)
									found = true
									break
								end
							end
							if found then
								break
							end
						end
						
					end
				end

				-- delete the old data for the faction, get_faction_persistent_data will generate the new one
				monster_hunt.persistent[faction_key] = nil

				local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
				for _, hunt_key in ipairs(hunts_to_complete) do
					faction_persistent_data.hunt_states[hunt_key].is_completed = true
				end
			end
		end
	end,

	get_hunt_config = function(hunt_key)
		for tier_index = 1, #monster_hunt.config.tiers do
			for i = 1, #monster_hunt.config.tiers[tier_index] do
				local data = monster_hunt.config.tiers[tier_index][i]
				if data.key == hunt_key then
					return data, tier_index
				end
			end
		end

		return {}
	end,

	get_hunt_tier = function(hunt_key)
		for tier, tier_data in ipairs(monster_hunt.config.tiers) do
			for _, hunt_data in ipairs(tier_data) do
				if hunt_data.key == hunt_key then
					return tier
				end
			end
		end

		return -1
	end,

	get_faction_persistent_data = function(faction_key)
		if not monster_hunt.persistent[faction_key] then
			monster_hunt.persistent[faction_key] = {}
			for field_name, value in pairs(monster_hunt.faction_persistent_template) do
				if is_table(monster_hunt.faction_persistent_template[field_name]) then
					monster_hunt.persistent[faction_key][field_name] = {}
				else
					monster_hunt.persistent[faction_key][field_name] = value
				end
			end

			for tier_index = 1, #monster_hunt.config.tiers do
				for i = 1, #monster_hunt.config.tiers[tier_index] do
					local data = monster_hunt.config.tiers[tier_index][i]
					monster_hunt.persistent[faction_key].hunt_states[data.key] =
					{
						is_stage_started = false,
						last_completed_stage = 0,
						is_completed = false,
					}
				end
			end

			monster_hunt.persistent[faction_key].tier_unlocked = {}
			monster_hunt.persistent[faction_key].tier_unlocked[1] = true
			for i = 2, #monster_hunt.config.tiers do
				monster_hunt.persistent[faction_key].tier_unlocked[i] = false
			end
		end

		return monster_hunt.persistent[faction_key]
	end,

	activate_a_monster_hunt = function (hunt_key, faction, hunter_cqi, starting_region_key)
		local faction_key = faction:name()
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local character = cm:get_character_by_cqi(hunter_cqi)
		if not character then
			character = faction:faction_leader()
		end
		faction_persistent_data.active_hunt = hunt_key
		faction_persistent_data.turn_hunt_started = cm:model():turn_number()
		faction_persistent_data.marker_index = 1
		faction_persistent_data.hunt_states[hunt_key].is_stage_started = true
		faction_persistent_data.hunt_states[hunt_key].direction = nil
		faction_persistent_data.monster_found = false
		faction_persistent_data.monster_units = ""
		faction_persistent_data.has_started_at_least_one_hunt  = true
		faction_persistent_data.hunter_cqi = character:command_queue_index()

		local hunt_config_data, _ = monster_hunt.get_hunt_config(hunt_key)
		-- Copy the dilemma tables so that we can ensure we don't show duplicates - used dilemmas will be erased
		if is_table(faction_persistent_data.decoy_dilemmas) then
			faction_persistent_data.decoy_dilemmas[hunt_key] = table.copy(hunt_config_data.decoy_dilemmas)
		end
		faction_persistent_data.progression_dilemmas = table.copy(monster_hunt.config.progression_dilemmas)
		faction_persistent_data.progression_dilemmas_issued = 0
		
		Play_Norsca_Advice("dlc08.camp.advice.nor.mon_hunt.002", norsca_info_text_monsters)

		-- The first marker is at a position in the closest region that is suitable for the hunt, after that we use next_monster_hunt_marker_location()
		local region = cm:get_region(starting_region_key)

		local distance = 100
		local tries = 1
		local max_tries = 5
		local monster_faction_key = monster_hunt.config.auxillary_monster_faction
		local spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(monster_faction_key, starting_region_key, false, true, distance)
		while spawn_x == -1 and tries <= max_tries do
			distance = distance / 2
			tries = tries + 1
			spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(monster_faction_key, starting_region_key, false, true, distance)
		end

		if spawn_x == -1 then
			return
		end

		faction_persistent_data.marker_position_x = spawn_x
		faction_persistent_data.marker_position_y = spawn_y

		cm:add_interactable_campaign_marker("monster_hunt_" .. faction_key, "wh3_dlc27_monster_arcanum", spawn_x, spawn_y, monster_hunt.config.marker_radius, faction:name(), "")

		if cm:get_local_faction_name(true) == faction_key then
			local display_x, display_y = cm:log_to_dis(spawn_x, spawn_y)
			local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
			cm:scroll_camera_from_current(false, monster_hunt.config.camera_scroll_speed, {display_x, display_y, cached_d, 0, cached_h})
		end

		local stage = monster_hunt.get_current_stage(faction_key)
		local mission_key = monster_hunt.get_mission_key(hunt_key, stage)
		local mission_manager = cm:get_mission_manager(faction_key, mission_key)
		mission_manager:set_position(spawn_x, spawn_y)
		mission_manager:trigger()
		faction_persistent_data.active_hunt = hunt_key
		faction_persistent_data.active_mission = mission_key

		cm:set_script_state(faction, monster_hunt.config.teleported_character_override_shared_state_name, tonumber(hunter_cqi))
		cm:set_script_state(faction, monster_hunt.config.teleported_character_override_mission_shared_state_name .. hunt_config_data.quest_battle, true)

		--reset dilemma cheat
		if monster_hunt.dev_is_dilemma_cheat_active() then
			monster_hunt.dev_activate_hunt_dilemma_chaining()
		end
	end,

	deactivate_active_hunt = function (faction_key)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		
		monster_hunt.clear_scripted_bonus_values(faction_key)
		
		cm:remove_interactable_campaign_marker("monster_hunt_" .. faction_key)

		local mission = faction_persistent_data.active_mission
		faction_persistent_data.active_mission = nil
		if mission ~= nil then
			cm:cancel_custom_mission(faction_key, mission)
		end
		
		-- Unregister and register again so the mission can be retriggered
		local stage = monster_hunt.get_current_stage(faction_key)
		local mission_manager = cm:get_mission_manager(faction_key, monster_hunt.get_mission_key(faction_persistent_data.active_hunt, stage, false))
		cm:unregister_mission_manager(mission_manager)
		if stage == 1 then
			local quest_battle_mission_manager = cm:get_mission_manager(faction_key, monster_hunt.get_mission_key(faction_persistent_data.active_hunt, stage, true))
			cm:unregister_mission_manager(quest_battle_mission_manager)
		end
		monster_hunt.setup_scripted_mission(faction_key, faction_persistent_data.active_hunt, stage)
		
		local faction = cm:get_faction(faction_key)
		local hunt_config_data, _ = monster_hunt.get_hunt_config(faction_persistent_data.active_hunt)
		cm:remove_script_state(faction, monster_hunt.config.teleported_character_override_shared_state_name)
		cm:remove_script_state(faction, monster_hunt.config.teleported_character_override_mission_shared_state_name .. hunt_config_data.quest_battle)

		faction_persistent_data.active_hunt = nil
		faction_persistent_data.marker_index = 1
		faction_persistent_data.turn_hunt_started = nil
		faction_persistent_data.turn_hunt_will_end = nil
		faction_persistent_data.decoy_dilemmas = {}
		faction_persistent_data.progression_dilemmas = nil
		faction_persistent_data.marker_position_x = nil
		faction_persistent_data.marker_position_y = nil
		faction_persistent_data.hunter_cqi = nil
	end,

	activate_ultimate_monster_hunter = function(faction_key)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		faction_persistent_data.ultimate_monster_hunter_performed = true
		cm:trigger_incident(faction_key, monster_hunt.config.ultimate_monster_hunter_rewards[faction_key].incident, true, true)
		core:trigger_event("ScriptEventUltimateMonsterHunterActivated", faction_key)

		local panel = UIComponent(monster_hunt.panel)
		if panel then
			panel:InterfaceFunction("PlayVoiceEvent", "campaign_vo_nor_monstrous_arcanum_ceremony")
			panel:InterfaceFunction("OnUltimateMonsterHunterActivated", faction_key)
		end
	end,

	get_mission_key = function(hunt_key, stage, is_quest_battle)
		local hunt_config_data, _ = monster_hunt.get_hunt_config(hunt_key)
		if stage == 1 then
			if is_quest_battle and hunt_config_data.quest_battle then
				return hunt_config_data.quest_battle
			elseif not is_quest_battle and hunt_config_data.mission_stage_1 then
				return hunt_config_data.mission_stage_1
			end
		elseif stage == 2 and hunt_config_data.mission_stage_2 then
			return hunt_config_data.mission_stage_2
		end
		return nil
	end,

	get_stage_rewards = function(faction_key, hunt_key, stage)
		local global_resource_rewards = monster_hunt.config.global_resource_rewards
		local hunt_config_data = monster_hunt.get_hunt_config(hunt_key)
		local stage_resource_rewards = hunt_config_data.resource_rewards[stage]

		local composed_resources = table.copy(global_resource_rewards)

		-- if the current stage overrides some resources, we replace them in the composed_resources
		for _, current_resource_data in ipairs(stage_resource_rewards) do
			local found = false
			for i = 1, #composed_resources do
				local current_global_resource_data = global_resource_rewards[i]
				if current_resource_data.resource == current_global_resource_data.resource then
					composed_resources[i].amount = current_resource_data.amount
					found = true
					break
				end
			end
			if not found then
				current_resource_data.amount = current_resource_data.amount
				table.insert(composed_resources, current_resource_data)
			end
		end

		-- value is percentage -> needs to be divided by 100
		local resource_multiplier = cm:get_factions_bonus_value(faction_key, monster_hunt.config.monster_hunt_resources_bonus_value)
		resource_multiplier = 1 + resource_multiplier / 100

		-- we multiply the composed_resources by the bonus
		for i = 1, #composed_resources do
			local global_resource_data = composed_resources[i]
			global_resource_data.amount = resource_multiplier * global_resource_data.amount
			composed_resources[i] = global_resource_data
		end

		return composed_resources
	end,

	setup_scripted_mission = function(faction_key, hunt_key, stage)
		local mission_key = monster_hunt.get_mission_key(hunt_key, stage)
		if not mission_key then
			return
		end

		local quest_battle_mission_key = monster_hunt.get_mission_key(hunt_key, stage, true)
		if not quest_battle_mission_key then
			return
		end

		local mm = mission_manager:new(faction_key, mission_key)
		local listener = stage == 1 and "ScriptEventMonsterHuntStageAdvance_" or "ScriptEventMonsterHuntStageAdvanceBattle_"
		
		local objective_text = stage == 1 and monster_hunt.config.stage_1_mission_objective or monster_hunt.config.stage_2_mission_objective
		mm:add_new_scripted_objective(
			objective_text,
			listener .. mission_key,
			function(context)
				local triggering_faction_key = context.string
				return triggering_faction_key == faction_key
			end
		)
		
		local qbmm
		if stage == 1 then
			qbmm = mission_manager:new(faction_key, quest_battle_mission_key)

			qbmm:add_new_scripted_objective(
				monster_hunt.config.quest_battle_mission_objective,
				"ScriptEventMonsterHuntStageAdvanceBattle_" .. quest_battle_mission_key,
				function(context)
					local triggering_faction_key = context.string
					return triggering_faction_key == faction_key
				end
			)
		end

		local stage_rewards = monster_hunt.get_stage_rewards(faction_key, hunt_key, stage)
		local mission_manager = stage == 1 and qbmm or mm
		for _, resource_data in ipairs(stage_rewards) do
			if not resource_data.faction or resource_data.faction == faction_key then
				if resource_data.resource == "treasury" then
					mission_manager:add_payload("money " .. tostring(resource_data.amount))
				else
					mission_manager:add_payload("faction_pooled_resource_transaction{resource " .. resource_data.resource .. ";factor " .. resource_data.factor .. ";amount " .. resource_data.amount .. ";context absolute;}");
				end
			end
		end

		local hunt_config_data = monster_hunt.get_hunt_config(hunt_key)
		if stage == 1 then
			mm:add_payload("text_display " .. hunt_config_data.stage_1_mission_reward_text)

			if hunt_config_data.reward_stage_1_ancillary then
				qbmm:add_payload("add_ancillary_to_faction_pool{ancillary_key " .. hunt_config_data.reward_stage_1_ancillary .. ";}")
			end
			if hunt_config_data.reward_stage_1_unit_ror then
				if not hunt_config_data.reward_stage_1_unit_ror_required_dlc or cm:faction_has_dlc_or_is_ai(hunt_config_data.reward_stage_1_unit_ror_required_dlc, faction_key) then
					qbmm:add_payload("remove_event_restricted_unit{unit_key " .. hunt_config_data.reward_stage_1_unit_ror .. ";}")
				else
					qbmm:add_payload("add_mercenary_to_faction_pool{unit_key " .. hunt_config_data.reward_stage_1_unit_ror_no_dlc_alternative .. ";amount 1;}")
				end
			end
			if hunt_config_data.reward_stage_1_effect_bundle then
				qbmm:add_payload("effect_bundle{bundle_key " .. hunt_config_data.reward_stage_1_effect_bundle ..";turns " .. hunt_config_data.reward_stage_1_effect_bundle_duration ..";}")
			end
		elseif stage == 2 then
			if hunt_config_data.reward_stage_2_unit_ma then
				mm:add_payload("add_mercenary_to_faction_pool{unit_key " .. hunt_config_data.reward_stage_2_unit_ma .. ";amount 1;}")
			end
			if hunt_config_data.reward_stage_2_effect_bundle then
				mm:add_payload("effect_bundle{bundle_key " .. hunt_config_data.reward_stage_2_effect_bundle ..";turns " .. hunt_config_data.reward_stage_2_effect_bundle_duration ..";}")
			end
		end
	end,

	next_monster_hunt_marker_location = function(character, marker_index, is_replayable_hunt, hunt_key)
		local faction_key = character:faction():name()

		marker_index = math.min(marker_index, #monster_hunt.config.marker_distances)

		local distance_modifier = cm:get_factions_bonus_value(faction_key, monster_hunt.config.monster_spawn_distance_bonus_value)
		local min_distance
		local max_distance
		if is_replayable_hunt then
			min_distance = monster_hunt.config.replayable_hunt_marker_distance.min_distance
			max_distance = monster_hunt.config.replayable_hunt_marker_distance.max_distance
		else 
			min_distance = math.max(1, monster_hunt.config.marker_distances[marker_index].min_distance + distance_modifier)
			max_distance = monster_hunt.config.marker_distances[marker_index].max_distance + distance_modifier
		end
		local direction = is_replayable_hunt and math.rad(cm:random_number(360)) or monster_hunt.choose_preferred_angle(character)

		local spawn_x, spawn_y = monster_hunt.try_find_marker_location_at_distance(character, direction, min_distance, max_distance, true)
		
		-- Stop respecting climate and if necessary increase distance
		while spawn_x == -1 and max_distance <= monster_hunt.config.max_marker_distance do
			spawn_x, spawn_y = monster_hunt.try_find_marker_location_at_distance(character, direction, min_distance, max_distance, false)
			min_distance = max_distance
			max_distance = min_distance + 1
		end

		return spawn_x, spawn_y
	end,

	estimate_marker_route_score = function(marker_positions)
		-- The score is 180 * number of markers in the route, plus the average angle between segments.
		-- We want to reward routes that have an average angle close to 180 degrees and we also want a shorter route to be
		-- strictly worse than a longer one, no matter how good the angles are.
		out("[MONSTER HUNTS] Estimating route score for " .. #marker_positions .. " markers.")
		for i, pos in ipairs(marker_positions) do
			out("[MONSTER HUNTS] Marker " .. i .. ": (" .. pos.x .. ", " .. pos.y .. ")")
		end
		local length_score = #marker_positions * 180
		if #marker_positions < 3 then
			return length_score -- Not enough markers to form a turn, score is just based on the number of markers.
		end
		-- Calculate the average angle between route segments.
		local segment_angles = {}
		local angle_score = 0
		for i = 1, #marker_positions - 1 do
			local dx = marker_positions[i + 1].x - marker_positions[i].x
			local dy = marker_positions[i + 1].y - marker_positions[i].y
			local angle = math.deg(math.atan2(dy, dx))
			table.insert(segment_angles, angle)
			out("[MONSTER HUNTS] Segment " .. i .. " angle: " .. angle .. " degrees.")
		end
		for i = 1, #segment_angles - 1 do
			local angle_diff = segment_angles[i + 1] - segment_angles[i]
			-- Normalize the angle difference to be within [-180, 180]
			if angle_diff > 180 then
				angle_diff = angle_diff - 360
			elseif angle_diff < -180 then
				angle_diff = angle_diff + 360
			end
			angle_score = angle_score + math.abs(angle_diff)
			out("[MONSTER HUNTS] Segment " .. i .. " angle difference: " .. angle_diff .. " degrees.")
		end
		angle_score = angle_score / (#segment_angles - 1)
		out("[MONSTER HUNTS] Average angle score: " .. angle_score .. " degrees.")
		return length_score + 180 - angle_score -- We want to reward routes that have an average angle close to 180 degrees.
	end,

	choose_preferred_angle = function(character)
		-- Heuristics to find a good preferred angle for a route of markers based on the current character's position and the hunt configuration.
		-- We try 8 angles spaced by 45 degrees and we choose the one that gives us the best route score.
		local faction_key = character:faction():name()
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local hunt_persistent_data = faction_persistent_data.hunt_states[faction_persistent_data.active_hunt]

		if hunt_persistent_data.direction then
			out("[MONSTER HUNTS] Using previously calculated preferred angle for stage: " .. math.deg(hunt_persistent_data.direction) .. " degrees.")
			return hunt_persistent_data.direction -- If we already have a preferred angle, use it.
		end

		local distance_modifier = cm:get_factions_bonus_value(faction_key, monster_hunt.config.monster_spawn_distance_bonus_value)
		local hunt_config_data, _ = monster_hunt.get_hunt_config(faction_persistent_data.active_hunt)

		local angle_offset = math.rad(cm:random_number(360)) -- Not 45 but full 360 to avoid biasing the angle choice.
		local angles_to_try = { 
			angle_offset,
			angle_offset + math.rad(45),
			angle_offset + math.rad(90),
			angle_offset + math.rad(135),
			angle_offset + math.rad(180),
			angle_offset + math.rad(225),
			angle_offset + math.rad(270),
			angle_offset + math.rad(315),
		}

		local best_route_score = nil
		local best_angle = nil

		for _, angle in ipairs(angles_to_try) do
			-- Generate a test route using this angle and score it. The fixed number of markers can be adjusted in the config.
			local current_x = character:logical_position_x()
			local current_y = character:logical_position_y()
			local marker_positions = {{x = current_x, y = current_y}}
			out("[MONSTER HUNTS] Trying angle: " .. math.deg(angle) .. " degrees for hunt: " .. faction_persistent_data.active_hunt)
			for marker_index = 1, monster_hunt.config.heuristic_marker_count do
				local marker_distances = monster_hunt.config.marker_distances[math.min(marker_index, #monster_hunt.config.marker_distances)]
				local min_distance = math.max(1, marker_distances.min_distance + distance_modifier)
				local max_distance = marker_distances.max_distance + distance_modifier
				local spawn_x, spawn_y = monster_hunt.try_find_marker_location_at_distance(character, angle, min_distance, max_distance, true, current_x, current_y)

				if spawn_x < 0 or spawn_y < 0 then
					break
				end
				
				table.insert(marker_positions, {x = spawn_x, y = spawn_y})

				current_x = spawn_x
				current_y = spawn_y
			end
			local route_score = monster_hunt.estimate_marker_route_score(marker_positions)
			out("[MONSTER HUNTS] Route score for angle " .. math.deg(angle) .. " degrees: " .. route_score)
			if not best_route_score or route_score > best_route_score then
				out("[MONSTER HUNTS] Replacing previous best route.")
				best_route_score = route_score
				best_angle = angle
			end
		end

		if not best_angle then
			best_angle = 0 -- Fallback to 0 if no angle was found, should not happen.
		end

		-- Store the best angle for this stage in persistent data so we can reuse it for the next markers.
		hunt_persistent_data.direction = best_angle
		out("[MONSTER HUNTS] Best preferred angle for stage: " .. math.deg(best_angle) .. " degrees.")
		return best_angle
	end,

	try_find_marker_location_at_distance = function(character, direction, min_distance, max_distance, respect_climate, initial_x, initial_y)
		local character_x = initial_x or character:logical_position_x()
		local character_y = initial_y or character:logical_position_y()
		local spawn_x = -1
		local spawn_y = -1

		local segments = 4
		local character_ap = character:action_points_per_turn()

		-- Generate segments + 1 point form min_distance to max distance at regular intervals, then shuffle them
		local distances_table = {}
		for i = 1, segments + 1 do
			table.insert(distances_table, min_distance + (i - 1) * (max_distance - min_distance) / segments)
		end
		cm:shuffle_table(distances_table)

		local faction_persistent_data = monster_hunt.get_faction_persistent_data(character:faction():name())
		local hunt_config_data = monster_hunt.get_hunt_config(faction_persistent_data.active_hunt)
		for i = 1, segments do
			local climates = respect_climate and hunt_config_data.climates or {}
			-- on failure to find a position if will return either -1, -1 or the starting position
			spawn_x, spawn_y = cm:find_location_in_climate_from_character(
					{
						character_lookup = cm:char_lookup_str(character),
						preferred_angle = direction,
						min_ap_cost = distances_table[i] * character_ap,
						max_ap_cost = (distances_table[i] + 1.0 / segments) * character_ap, 
						climate_keys = climates,
						override_initial_x = initial_x,
						override_initial_y = initial_y,
					}
				)
			if spawn_x == character_x and spawn_y == character_y then
				spawn_x = -1
				spawn_y = -1
			end
			if spawn_x > 0 and spawn_y > 0 then
				break
			end
		end

		return spawn_x, spawn_y
	end,

	get_monster_faction_key = function(faction_key)
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
		if not faction_data.active_hunt then
			return nil
		end

		local hunt_states = faction_data.hunt_states[faction_data.active_hunt]
		if hunt_states then
			return hunt_states.monster_faction_key
		end

		return nil
	end,

	cleanup_dilemma_monsters = function(faction_key)
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
		local hunt_states = faction_data.hunt_states[faction_data.active_hunt]
		if hunt_states then
			local dilemma_monster_army_leader = cm:get_character_by_cqi(hunt_states.dilemma_monster_army_leader_cqi)
			if dilemma_monster_army_leader:is_alive() then
				cm:kill_character_and_commanded_unit(cm:char_lookup_str(dilemma_monster_army_leader), true, true)

				if faction_key == cm:get_local_faction_name(true) then
					local callback_delay = 0.1
					cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed")
					cm:disable_event_feed_events(true, "", "", "character_dies_battle")
					cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, callback_delay)
					cm:callback(function() cm:disable_event_feed_events(false, "", "", "character_dies_battle") end, callback_delay)
				end
			end
		end
	end,

	revert_marker = function(faction_key)
		local monster_faction_key = monster_hunt.get_monster_faction_key(faction_key)
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
		local spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_position(monster_faction_key, faction_data.marker_position_x, faction_data.marker_position_y, false)
		faction_data.marker_position_x = spawn_x
		faction_data.marker_position_y = spawn_y
		cm:add_interactable_campaign_marker("monster_hunt_" .. faction_key, "wh3_dlc27_monster_arcanum", spawn_x, spawn_y, monster_hunt.config.marker_radius, faction_key, "")
	end,

	get_current_stage = function(faction_key)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		if not faction_persistent_data.active_hunt then
			return -1
		end

		local hunt_config_data, tier = monster_hunt.get_hunt_config(faction_persistent_data.active_hunt)
		local hunt_states = faction_persistent_data.hunt_states[hunt_config_data.key]

		local is_stage_replayable = monster_hunt.config.tier_config[tier].stages[hunt_states.last_completed_stage] == "replayable"
		return is_stage_replayable and hunt_states.last_completed_stage or hunt_states.last_completed_stage + 1
	end,

	is_current_hunt_stage_replayable = function(faction_key, hunt_key)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local _, tier = monster_hunt.get_hunt_config(hunt_key)
		local hunt_states = faction_persistent_data.hunt_states[hunt_key]

		local current_stage = math.min(hunt_states.last_completed_stage + 1, #monster_hunt.config.tier_config[tier].stages)
		return monster_hunt.config.tier_config[tier].stages[current_stage] == "replayable"
	end,

	advance_stage = function(faction_key)
		if not monster_hunt.persistent[faction_key].active_hunt then
			return
		end
		
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local hunt_config_data, tier = monster_hunt.get_hunt_config(faction_persistent_data.active_hunt)
		local hunt_states = faction_persistent_data.hunt_states[hunt_config_data.key]
		
		if not hunt_states.is_stage_started then
			return
		end
		
		local stage = monster_hunt.get_current_stage(faction_key)
		-- Give out rewards to AI
		local faction = cm:get_faction(faction_key)
		if not faction:is_human() then
			if stage == 1 and hunt_config_data.reward_stage_1_ancillary then
				cm:force_add_ancillary(cm:get_faction(faction_key):faction_leader(), hunt_config_data.reward_stage_1_ancillary, false, false)
				cm:apply_effect_bundle(hunt_config_data.reward_stage_1_effect_bundle, faction_key, hunt_config_data.reward_stage_1_effect_bundle_duration)
			elseif stage == 2 then
				if hunt_config_data.reward_stage_1_unit_ror then
					cm:remove_event_restricted_unit_record_for_faction(hunt_config_data.reward_stage_1_unit_ror, faction_key)
				elseif hunt_config_data.reward_stage_2_unit_ma then
					cm:add_units_to_faction_mercenary_pool(cm:get_faction(faction_key):command_queue_index(), hunt_config_data.reward_stage_2_unit_ma, 1)
				end
				cm:apply_effect_bundle(hunt_config_data.reward_stage_2_effect_bundle, faction_key, hunt_config_data.reward_stage_2_effect_bundle_duration)
			end
		end

		-- need to remove the marker in case we advanced via cheat
		cm:remove_interactable_campaign_marker("monster_hunt_" .. faction_key)

		local cooldown_multiplier = cm:get_factions_bonus_value(faction_key, monster_hunt.config.monster_hunt_cooldown_bonus_value)
		cooldown_multiplier = 1 + cooldown_multiplier / 100
		faction_persistent_data.cooldown_end_turn = math.ceil(cm:model():turn_number() + cooldown_multiplier * monster_hunt.config.tier_config[tier].cooldown)
		cm:set_script_state(faction, monster_hunt.config.cooldown_shared_state_name, faction_persistent_data.cooldown_end_turn)

		hunt_states.last_completed_stage = math.min(#monster_hunt.config.tier_config[tier].stages, hunt_states.last_completed_stage + 1)
		hunt_states.is_completed = hunt_states.last_completed_stage == #monster_hunt.config.tier_config[tier].stages
		hunt_states.is_stage_started = false

		if #monster_hunt.config.tier_config[tier].stages > 1 and hunt_states.last_completed_stage == 1 then
			cm:show_message_event(
				faction_key,
				monster_hunt.config.event_feed_stage_2_reminder_title,
				"campaign_localised_strings_string_" .. hunt_config_data.title,
				monster_hunt.config.event_feed_stage_2_reminder_detail,
				true,
				666
			)
		end

		if faction:is_human() and monster_hunt.config.tier_config[tier].stages[stage] == "replayable" then
			-- reset mission manager for replayable stages
			local mission_manager = cm:get_mission_manager(faction_key, monster_hunt.get_mission_key(faction_persistent_data.active_hunt, stage))
			cm:unregister_mission_manager(mission_manager)
			monster_hunt.setup_scripted_mission(faction_key, faction_persistent_data.active_hunt, stage)
		end
		
		faction_persistent_data.marker_index = 0
		faction_persistent_data.turn_hunt_started = nil
		faction_persistent_data.turn_hunt_will_end = nil
		faction_persistent_data.marker_position_x = nil
		faction_persistent_data.marker_position_y = nil

		faction_persistent_data.active_hunt = nil

		if tier < #monster_hunt.config.tier_config
			and monster_hunt.get_hunts_for_tier_unlock(faction_key, tier + 1) >= monster_hunt.config.tier_config[tier + 1].hunts_to_unlock 
		then
			faction_persistent_data.tier_unlocked[tier + 1] = true
		elseif faction_persistent_data.ultimate_monster_hunter_performed == false 
			and monster_hunt.ultimate_monster_hunter_requirements_fulfilled(faction_key)
		then
			monster_hunt.activate_ultimate_monster_hunter(faction_key)
		end

		cm:remove_script_state(faction, monster_hunt.config.teleported_character_override_shared_state_name)
		cm:remove_script_state(faction, monster_hunt.config.teleported_character_override_mission_shared_state_name .. hunt_config_data.quest_battle)
	end,

	clear_scripted_bonus_values = function(faction_key)
		local faction = cm:get_faction(faction_key)
		-- We expect only one such effect on the faction
		local found = false

		local bundles = faction:effect_bundles()
		for i = 0, bundles:num_items() - 1 do

			local bundle = bundles:item_at(i)
			local bundle_effects = bundle:effects()
			for i = 0, bundle_effects:num_items() - 1 do
				local effect = bundle_effects:item_at(i)
				-- we expect that the effect names will contain the bonus value name
				if string.find(effect:key(), monster_hunt.config.monster_spawn_chance_bonus_value) or
					string.find(effect:key(), monster_hunt.config.monster_spawn_distance_bonus_value)
				then
					cm:remove_effect_bundle(bundle:key(), faction_key)
					return
				end
			end
		end
	end,

	get_hunts_for_tier_unlock = function(faction_key, tier)
		if tier <= 1 then
			return 0
		end

		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local count = 0

		for _, current_monster_hunt_data in ipairs(monster_hunt.config.tiers[tier - 1]) do
			local hunt_states = faction_persistent_data.hunt_states[current_monster_hunt_data.key]
			if hunt_states.last_completed_stage >= monster_hunt.config.tier_config[tier].min_hunt_stage_for_tier_unlock then
				count = count + 1
			end
		end
		return count
	end,

	ultimate_monster_hunter_requirements_fulfilled = function(faction_key)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		local last_tier_idx = #monster_hunt.config.tiers
		local last_tier_config = monster_hunt.config.tiers[last_tier_idx]

		local count = 0
		for _, current_monster_hunt_data in ipairs(last_tier_config) do
			local hunt_states = faction_persistent_data.hunt_states[current_monster_hunt_data.key]
			if hunt_states.is_completed then
				count = count + 1
			end
		end

		return monster_hunt.config.tier_config[last_tier_idx].hunts_for_umh <= count
	end,

	init_ui = function(context)
		if context then
			monster_hunt.panel = context.component
		end

		local faction_key = cm:get_local_faction_name(true)
		
		UIComponent(monster_hunt.panel):InterfaceFunction("ClearEntries")
		for tier_index = 1, #monster_hunt.config.tiers do
			for entry_index = 1, #monster_hunt.config.tiers[tier_index] do
				local current_monster_hunt_data = monster_hunt.config.tiers[tier_index][entry_index]
				if current_monster_hunt_data.dlc_requirement == nil or cm:faction_has_dlc_or_is_ai(current_monster_hunt_data.dlc_requirement, faction_key) then
					local persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
					local state = persistent_data.hunt_states[current_monster_hunt_data.key]
					local is_stage_started = state.is_stage_started
					local is_completed = state.is_completed
					local is_current_hunt_stage_replayable = monster_hunt.is_current_hunt_stage_replayable(faction_key, current_monster_hunt_data.key)
					local unit_key
					if current_monster_hunt_data.reward_stage_1_unit_ror then
						if not current_monster_hunt_data.reward_stage_1_unit_ror_required_dlc or cm:faction_has_dlc_or_is_ai(current_monster_hunt_data.reward_stage_1_unit_ror_required_dlc, faction_key) then
							unit_key = current_monster_hunt_data.reward_stage_1_unit_ror
						else
							unit_key = current_monster_hunt_data.reward_stage_1_unit_ror_no_dlc_alternative
						end
					else
						unit_key = current_monster_hunt_data.reward_stage_2_unit_ma or ""
					end
					local turns_remaining = 0
					if persistent_data.turn_hunt_started then
						turns_remaining = math.max(0, persistent_data.turn_hunt_started + monster_hunt.config.prolonged_hunt.turns_to_trigger - cm:turn_number())
					end
					local is_hunt_extended = not (persistent_data.turn_hunt_will_end == nil)

					local additional_rewards = {}
					for stage = 1, #monster_hunt.config.tier_config[tier_index].stages do
						table.insert(additional_rewards, {})
						local stage_rewards = monster_hunt.get_stage_rewards(faction_key, current_monster_hunt_data.key, stage)
						for _, resource_data in ipairs(stage_rewards) do
							if not resource_data.faction or resource_data.faction == faction_key then
								table.insert(additional_rewards[stage], {key = resource_data.resource, amount = resource_data.amount})
							end
						end
					end

					UIComponent(monster_hunt.panel):InterfaceFunction("AddEntry",
						{
							tier_index = tier_index,
							hunt_key = current_monster_hunt_data.key,
							title_key = current_monster_hunt_data.title,
							description_key = current_monster_hunt_data.description,
							objective_key = current_monster_hunt_data.objective,
							climate_keys = current_monster_hunt_data.climates,
							region_keys = current_monster_hunt_data.regions,
							regions_text_key = current_monster_hunt_data.regions_text_key,
							ancillary_key = current_monster_hunt_data.reward_stage_1_ancillary,
							unit_key = unit_key or "",
							reward_stage_1_effect_bundle = current_monster_hunt_data.reward_stage_1_effect_bundle or "",
							reward_stage_1_effect_bundle_duration = current_monster_hunt_data.reward_stage_1_effect_bundle_duration or 0,
							reward_stage_2_effect_bundle = current_monster_hunt_data.reward_stage_2_effect_bundle or "",
							reward_stage_2_effect_bundle_duration = current_monster_hunt_data.reward_stage_2_effect_bundle_duration or 0,
							-- C++ unfortunately treats bools sent from LUA as numbers, even though there is a << operator for bool
							is_stage_started = is_stage_started and 1 or 0,
							last_completed_stage = state.last_completed_stage,
							is_hunt_completed = is_completed and 1 or 0,
							is_current_hunt_stage_replayable = is_current_hunt_stage_replayable and 1 or 0,
							stages_count = #monster_hunt.config.tier_config[tier_index].stages,
							cooldown = math.max(0, persistent_data.cooldown_end_turn - cm:model():turn_number()),
							turns_remaining = turns_remaining,
							is_hunt_extended = is_hunt_extended and 1 or 0,
							technology_key = current_monster_hunt_data.technology,
							audio_sound_category_override = current_monster_hunt_data.audio_sound_cat_override,
							audio_dialogue_event = current_monster_hunt_data.audio_dialogue_event,
							background_file = current_monster_hunt_data.background,
							portrait_file = current_monster_hunt_data.portrait,
							additional_rewards = additional_rewards,
						}
					)
				end
			end
		end

		monster_hunt.update_tier_states(faction_key)
	end,

	update_tier_states = function(faction_key)
		local is_current_stage_replayable = false
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		replayable_stages = {}
		for tier = 1, #monster_hunt.config.tier_config do
			local found = false
			for idx, stage_type in ipairs(monster_hunt.config.tier_config[tier].stages) do
				if stage_type == "replayable" then
					table.insert(replayable_stages, idx)
					found = true
					break
				end
			end
			if not found then
				table.insert(replayable_stages, 0)
			end
		end
		
		local min_stages_for_tier_unlock = {}
		local hunts_to_unlock_next_tier = {}
		for tier = 1, #monster_hunt.config.tier_config do
			table.insert(min_stages_for_tier_unlock, monster_hunt.config.tier_config[tier].min_hunt_stage_for_tier_unlock)
			if tier > 1 then
				table.insert(hunts_to_unlock_next_tier, monster_hunt.config.tier_config[tier].hunts_to_unlock)

				if tier < #monster_hunt.config.tier_config and monster_hunt.get_hunts_for_tier_unlock(faction_key, tier) >= monster_hunt.config.tier_config[tier + 1].hunts_to_unlock then
					monster_hunt.persistent[faction_key].tier_unlocked[tier + 1] = true
				end
			end
		end
		table.insert(hunts_to_unlock_next_tier, monster_hunt.config.tier_config[#monster_hunt.config.tier_config].hunts_for_umh)

		UIComponent(monster_hunt.panel):InterfaceFunction("SetTierStates",
		{
			tier_unlocked = monster_hunt.persistent[faction_key].tier_unlocked,
			min_stages_for_tier_unlock = min_stages_for_tier_unlock,
			hunts_to_unlock_next_tier = hunts_to_unlock_next_tier,
			replayable_stages = replayable_stages,
			active_hunt = monster_hunt.persistent[faction_key].active_hunt or "",
			hunter_cqi = monster_hunt.persistent[faction_key].hunter_cqi or -1,
			current_stage = monster_hunt.get_current_stage(faction_key),
			marker_position_x = faction_persistent_data.marker_position_x or -1,
			marker_position_y = faction_persistent_data.marker_position_y or -1,
			ultimate_monster_hunter_performed = faction_persistent_data.ultimate_monster_hunter_performed and 1 or 0,
			ultimate_monster_hunter_effect_bundle = monster_hunt.config.ultimate_monster_hunter_rewards[faction_key].effect_bundle,
			has_panel_been_opened = monster_hunt.ui_persistent.has_panel_been_opened and 1 or 0
		})
		monster_hunt.ui_persistent.has_panel_been_opened = true
	end,
}

monster_hunt.is_unlocked = function()
	local current_turn = cm:turn_number()
	local faction_key = cm:get_local_faction_name(true)
	if not faction_key then
		return false
	end

	if not monster_hunt.config.turn_to_unlock[faction_key] then
		return false
	end

	return monster_hunt.dev_force_enabled or current_turn >= monster_hunt.config.turn_to_unlock[faction_key]
end

monster_hunt.ui_refresh_availability = function()
	local is_disabled = not monster_hunt.is_unlocked()
	cm:override_ui(monster_hunt.config.disable_mechanic_key, is_disabled)

	for faction_key, turn_to_unlock in dpairs(monster_hunt.config.turn_to_unlock) do
		cm:set_script_state(cm:get_faction(faction_key), monster_hunt.config.turn_to_unlock_shared_state_name, turn_to_unlock)
	end
end

-- Cheat functions
-- Unlocks the mechanic and forces it to be enabled
monster_hunt.dev_unlock = function()
	monster_hunt.dev_force_enabled = true
	monster_hunt.ui_refresh_availability()
end

-- dilemma chaining cheat
-- allows to chain dilemmas for testing purposes
monster_hunt.dev_active_hunt_dilemma_chaining = false
monster_hunt.dev_active_hunt_use_same_marker_pos = false
monster_hunt.dev_active_hunt_dilemma_index = 1
monster_hunt.dev_start_turn_dilemma_index = 1

monster_hunt.dev_is_dilemma_cheat_active = function()
	return monster_hunt.dev_active_hunt_dilemma_chaining
end

-- Returns true if the cheat to use the same marker position for all dilemmas is active
monster_hunt.dev_is_using_same_marker_pos_for_the_active_hunt = function()
	return monster_hunt.dev_active_hunt_use_same_marker_pos
end

monster_hunt.dev_activate_hunt_dilemma_chaining = function()
	monster_hunt.dev_active_hunt_dilemma_chaining = true
	monster_hunt.dev_active_hunt_use_same_marker_pos = true
	monster_hunt.dev_active_hunt_dilemma_index = 1
	monster_hunt.dev_start_of_turn_dilemma_index = 1
end

monster_hunt.dev_get_next_start_turn_dilemma_index = function(dilemmas_count)
	if monster_hunt.dev_is_dilemma_cheat_active() == false then
		return nil
	end
	
	local idx = monster_hunt.dev_start_turn_dilemma_index
	monster_hunt.dev_start_turn_dilemma_index = monster_hunt.dev_start_turn_dilemma_index + 1
	if monster_hunt.dev_start_turn_dilemma_index <= dilemmas_count then
		return idx
	end

	return nil
end

monster_hunt.dev_get_next_active_hunt_dilemma_index = function(dilemmas_count)
	if monster_hunt.dev_is_dilemma_cheat_active() == false then
		return nil
	end

	local idx = monster_hunt.dev_active_hunt_dilemma_index
	monster_hunt.dev_active_hunt_dilemma_index = monster_hunt.dev_active_hunt_dilemma_index + 1
	if monster_hunt.dev_active_hunt_dilemma_index <= dilemmas_count then
		return idx
	end

	return nil
end

-- cheat for finding the monster on the first try
monster_hunt.dev_force_find_monster = false
monster_hunt.dev_enable_force_find_monster = function()
	monster_hunt.dev_force_find_monster = true
end
monster_hunt.is_dev_force_find_monster_enabled = function()
	return monster_hunt.dev_force_find_monster
end


monster_hunt.activate_cheat = function(params)
	local cheat = params[2]
	if cheat == "unlock" then
		monster_hunt.dev_unlock()
	elseif cheat == "unlock_tier" then
		local faction_key = cm:get_local_faction_name(true)
		monster_hunt.persistent[faction_key].tier_unlocked[tonumber(params[3])] = true
		monster_hunt.update_tier_states(faction_key)
	elseif cheat == "complete_stage" then
		local faction_key = cm:get_local_faction_name(true)
		local hunt_key = monster_hunt.persistent[faction_key].active_hunt
		if not hunt_key then
			return
		end
		monster_hunt.advance_stage(faction_key)
		monster_hunt.init_ui()
		monster_hunt.update_tier_states(faction_key)
		UIComponent(monster_hunt.panel):InterfaceFunction("ShowPageForHunt", hunt_key)
	elseif cheat == "skip_cooldowns" then
		local faction_key = cm:get_local_faction_name(true)
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		faction_persistent_data.cooldown_end_turn = cm:model():turn_number()
		cm:set_script_state(cm:get_local_faction(true), monster_hunt.config.cooldown_shared_state_name, faction_persistent_data.cooldown_end_turn)
		monster_hunt.init_ui()
		UIComponent(monster_hunt.panel):InterfaceFunction("RefreshTab")
	elseif cheat == "activate_hunt_dilemma_chaining" then
		monster_hunt.dev_activate_hunt_dilemma_chaining()
	elseif cheat == "find_the_monster" then
		monster_hunt.dev_enable_force_find_monster()
	end
end

-- MonsterHuntCheatListener ContextTriggerEvent
core:add_listener(
	"MonsterHuntCheatListener",
	"ContextTriggerEvent",
	true,
	function(context)
		if not context.string:starts_with("monster_hunt_cheat") then
			return
		end
		local params = context.string:split(":")
		monster_hunt.activate_cheat(params)
	end,
	true
)
-- End of cheat functions

-- MarkerInteracted - MonsterHuntMarkerInteracted
core:add_listener(
	"MonsterHuntMarkerInteracted",
	"MarkerInteracted",
	true,
	function(context)
		local marker_id = context:marker_id()
		if not string.find(marker_id, "monster_hunt") then
			return
		end

		local character = context:family_member():character()
		-- Heroes cannot interact with markers, just lords
		if not character:has_military_force() then
			return
		end
		
		local faction_key = character:faction():name()
		local marker_index = monster_hunt.persistent[faction_key].marker_index
		
		
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
		faction_data.last_character_cqi_in_marker = character:command_queue_index()
		
		local chance_modifier = cm:get_factions_bonus_value(faction_key, monster_hunt.config.monster_spawn_chance_bonus_value)
		local active_hunt = monster_hunt.persistent[faction_key].active_hunt
		local tier = math.max(1, monster_hunt.get_hunt_tier(active_hunt))
		local stage = monster_hunt.get_current_stage(faction_key)
		local is_current_hunt_stage_replayable = monster_hunt.is_current_hunt_stage_replayable(faction_key, active_hunt)
		local spawn_x, spawn_y = monster_hunt.next_monster_hunt_marker_location(character, monster_hunt.persistent[faction_key].marker_index + 1, is_current_hunt_stage_replayable, active_hunt)
		local chance = cm:random_number(100)

		local continue_searching = not faction_data.monster_found
									and not is_current_hunt_stage_replayable
									and marker_index <= #monster_hunt.config.monster_spawn_chance[tier][stage]
									and is_table(faction_data.decoy_dilemmas)
									and is_table(faction_data.decoy_dilemmas[active_hunt])
									and chance > monster_hunt.config.monster_spawn_chance[tier][stage][marker_index] + chance_modifier
									-- in cases where we cannot spawn a marker at a suitable distance (e.g. on a island) we spawn the battle
									and spawn_x > 0 and spawn_y > 0
		
		local override_dilemma_index = monster_hunt.dev_get_next_active_hunt_dilemma_index(#faction_data.decoy_dilemmas[active_hunt])

		local find_the_monster = not continue_searching and not override_dilemma_index
		find_the_monster = monster_hunt.is_dev_force_find_monster_enabled() or find_the_monster
		if not find_the_monster then
			monster_hunt.persistent[faction_key].marker_index = monster_hunt.persistent[faction_key].marker_index + 1
			local dilemma_index = override_dilemma_index or cm:random_number(#faction_data.decoy_dilemmas[active_hunt])

			cm:trigger_dilemma_with_targets(cm:get_faction(
				faction_key):command_queue_index(),
				faction_data.decoy_dilemmas[active_hunt][dilemma_index],
				0,
				0,
				character:command_queue_index(),
				character:military_force():command_queue_index(),
				0,
				0,
				nil,
				true)
			table.remove(faction_data.decoy_dilemmas[active_hunt], dilemma_index)
			if #faction_data.decoy_dilemmas[active_hunt] == 0 then
				local hunt_config_data, _ = monster_hunt.get_hunt_config(active_hunt)
				faction_data.decoy_dilemmas[active_hunt] = table.copy(hunt_config_data.decoy_dilemmas)
			end

			cm:remove_interactable_campaign_marker(marker_id)

			if not monster_hunt.dev_is_using_same_marker_pos_for_the_active_hunt() then
				faction_data.marker_position_x = spawn_x
				faction_data.marker_position_y = spawn_y
			end
			
			-- Spawn next marker after dilemma choice made, because global advice might prevent us from moving the camera
		else
			local hunt_config_data = monster_hunt.get_hunt_config(monster_hunt.persistent[faction_key].active_hunt)
			local spawn_units = faction_data.monster_units
			if not faction_data.monster_found and monster_hunt.is_current_hunt_stage_replayable(faction_key, hunt_config_data.key) then
				-- Generate a random list of units, save it as a new template so that the monster spawned by the dilemma can have the same exact units
				-- Substract 1 from the size because designers count the leader as a unit but this method doesn't
				local army_data = hunt_config_data.generated_army
				local army_size = army_data.army_size - 1

				-- Recalculate the army size if there are no random units as designers don't always update this when updating the units
				if #army_data.random_units == 0 then
					army_size = 0
					for _, army_config in ipairs(army_data.mandatory_units) do
						army_size = army_size + army_config.count
					end
				end
				spawn_units = random_army_manager:generate_force(hunt_config_data.key, army_size)
				faction_data.monster_units = spawn_units
			end
			
			faction_data.monster_found = true

			local hunt_states = faction_data.hunt_states[hunt_config_data.key]
			local monster_faction_key = ""
			local monster_force_cqi = -1
			local monster_faction
			local military_force
			if not is_current_hunt_stage_replayable then
				local quest_battle = hunt_config_data.quest_battle

				-- Spawn an army identical to the one in the quest battle and get data for the dilemma from it
				military_force = cm:spawn_mission_battle_enemy_army(quest_battle)
				monster_faction_key = military_force:faction():name()
				monster_force_cqi = military_force:command_queue_index()
				local general = military_force:general_character()
				hunt_states.general_forename = general:get_forename()
				hunt_states.general_surname = general:get_surname()
				hunt_states.monster_faction_key = monster_faction_key
				hunt_states.general_subtype = general:character_subtype_key()

				monster_faction = cm:get_faction(monster_faction_key)

				spawn_units = ""
				for i = 0, military_force:unit_list():num_items() - 1 do
					local unit_key = military_force:unit_list():item_at(i):unit_key()
					spawn_units = spawn_units .. unit_key .. ","
				end
			else
				monster_faction_key = hunt_states.monster_faction_key

				--Distance is in hexes rather than AP here
				local army_spawn_x, army_spawn_y = cm:find_valid_spawn_location_for_character_from_position(monster_faction_key, character:logical_position_x(), character:logical_position_y(), false, monster_hunt.config.marker_radius)

				cm:create_force_with_general(
					monster_faction_key,
					--TODO: For stage 1 generate spawn units from military force to remove need for duplicated army config in script for quest battles
					spawn_units,
					"wh3_main_combi_region_troll_fjord",
					army_spawn_x,
					army_spawn_y,
					"general",
					hunt_states.general_subtype,
					hunt_states.general_forename,
					"",		-- faction name
					hunt_states.general_surname,
					"",		-- other name
					false,	-- make faction leader
					function(army_leader_cqi)
						local army_leader = cm:get_character_by_cqi(army_leader_cqi)
						military_force = army_leader:military_force()
						monster_force_cqi = military_force:command_queue_index()
					end
				)
				
				monster_faction = cm:get_faction(monster_faction_key)
			end
			
			cm:trigger_dilemma_with_targets(cm:get_faction(faction_key):command_queue_index(),
				monster_hunt.config.monster_found_dilemma.dilemma_key,
				0,
				0,
				0,
				monster_force_cqi,
				0,
				0,
				nil,
				true
			)
		
			local monster_army_leader = military_force:general_character()
			hunt_states.dilemma_monster_army_leader_cqi = monster_army_leader:cqi()

			-- Send it in limbo so it is not visible before the dilemma pops up
			cm:enter_limbo(cm:char_lookup_str(monster_army_leader:cqi()))
		end

		monster_hunt.clear_scripted_bonus_values(faction_key)
	end,
	true
)

-- BattleCompleted - MonsterHuntFinalBattleCompleted
core:add_listener(
	"MonsterHuntFinalBattleCompleted",
	"BattleCompleted",
	true,
	function(context)
		-- Handle retreating from a fight with generated armies
		if not cm:model():pending_battle():has_been_fought() then
			local pb = cm:model():pending_battle()
			if not pb:has_defender() then
				return
			end
			local defender_key = pb:defender():faction():name()
			-- player army could be destroyed on retreat, so just check the monster army
			for _, player_faction_key in dpairs(monster_hunt.config.playable_monster_hunt_factions) do
				-- Sayl's faction is missing on saves from live
				local faction = cm:get_faction(player_faction_key)
				if faction and faction:is_human() then
					local faction_data = monster_hunt.get_faction_persistent_data(player_faction_key)
					if faction_data.has_started_generated_battle and monster_hunt.get_monster_faction_key(player_faction_key) == defender_key then
						monster_hunt.revert_marker(player_faction_key)
						faction_data.has_started_generated_battle = false
						if player_faction_key == cm:get_local_faction_name(true) then
							cm:override_ui("disable_prebattle_autoresolve_monster_hunt", false)
						end
						return
					end
				end
			end
		end
	end,
	true
)

-- BattleConflictFinished MonsterHuntFinalBattleConflictFinished
core:add_listener(
	"MonsterHuntFinalBattleConflictFinished",
	"BattleConflictFinished",
	true,
	function(context)
		local pb = cm:model():pending_battle()
		local attacker = pb:attacker()
		local defender = pb:defender()
		if not pb:has_attacker() or not pb:has_defender() then
			return
		end
		-- In quest battles the player can be the attacker or defender
		local is_player_attacker = attacker:faction():subculture() == monster_hunt.config.subculture and attacker:faction():is_human()
		local is_player_defender = defender:faction():subculture() == monster_hunt.config.subculture and defender:faction():is_human()
		if is_player_attacker or is_player_defender then
			local attacker_key = attacker:faction():name()
			local defender_key = defender:faction():name()
			local faction_key = is_player_attacker and attacker_key or defender_key
			local mission_key = pb:quest_mission_key()
			local stage = monster_hunt.get_current_stage(faction_key)
			local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
			local is_quest_battle = stage == 1 and mission_key == faction_persistent_data.active_mission
			local is_generated_battle = faction_persistent_data.has_started_generated_battle
			-- the player is always the attacker in a generated battle
			if is_quest_battle or is_generated_battle then
				if (is_player_attacker and attacker:won_battle()) or (is_player_defender and defender:won_battle()) then
					core:trigger_event("ScriptEventMonsterHuntStageAdvanceBattle_" .. faction_persistent_data.active_mission, faction_key)
				else
					cm:callback(function() monster_hunt.revert_marker(faction_key) end, 0.1)
				end
				faction_persistent_data.has_started_generated_battle = false
				if is_generated_battle and faction_key == cm:get_local_faction_name(true) then
					cm:override_ui("disable_prebattle_autoresolve_monster_hunt", false)

					local callback_delay = 3
					cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed")
					cm:disable_event_feed_events(true, "", "", "character_dies_battle")
					cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, callback_delay)
					cm:callback(function() cm:disable_event_feed_events(false, "", "", "character_dies_battle") end, callback_delay)
				end
			end
		end
	end,
	true
)

-- MissionSucceeded - MonsterHuntMissionSucceeded
core:add_listener(
	"MonsterHuntMissionSucceeded",
	"MissionSucceeded",
	true,
	function(context)
		local faction_key = context:faction():name()
		local mission_key = context:mission():mission_record_key()
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
		if faction_data and faction_data.active_mission == mission_key then
			monster_hunt.advance_stage(faction_key)
		end
	end,
	true
)

-- DilemmaChoiceMadeEvent - MonsterHuntDilemma
core:add_listener(
	"MonsterHuntDilemma",
	"DilemmaChoiceMadeEvent",
	true,
	function(context)
		local target_faction = context:faction()
		local faction_key = target_faction:name()
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)

		-- Monster found dilemma
		if context:dilemma() == monster_hunt.config.monster_found_dilemma.dilemma_key then

			monster_hunt.cleanup_dilemma_monsters(faction_key)

			local active_hunt = monster_hunt.persistent[faction_key].active_hunt
			
			local stage = monster_hunt.get_current_stage(faction_key)
			local hunt_config_data, _ = monster_hunt.get_hunt_config(active_hunt)
			local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
			local character = cm:get_character_by_cqi(faction_data.last_character_cqi_in_marker)
			
			if not character then
				faction_data.last_character_cqi_in_marker = nil
				return
			end

			local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
			-- Start quest battle mission on first stage, otherwise generate a army
			if stage == 1 and is_string(hunt_config_data.quest_battle) and string.len(hunt_config_data.quest_battle) > 0 then
				-- Complete mission which will give out rewards to human players
				local stage = monster_hunt.get_current_stage(faction_key)
				local mission_key = monster_hunt.get_mission_key(faction_persistent_data.active_hunt, stage)
				
				faction_persistent_data.active_mission = hunt_config_data.quest_battle
				core:trigger_event("ScriptEventMonsterHuntStageAdvance_" .. mission_key, faction_key)
				
				if context:choice() == monster_hunt.config.monster_found_dilemma.attack_choice then
					local mission_manager = cm:get_mission_manager(faction_key, hunt_config_data.quest_battle, true)
					
					mission_manager:set_position(faction_persistent_data.marker_position_x, faction_persistent_data.marker_position_y)
					mission_manager:trigger()
					cm:set_mission_location_override(target_faction, hunt_config_data.quest_battle, faction_data.marker_position_x, faction_data.marker_position_y)
					
					local display_x, display_y = cm:log_to_dis(faction_persistent_data.marker_position_x, faction_persistent_data.marker_position_y)
					cm:teleport_and_prepare_for_battle(character:command_queue_index(), hunt_config_data.quest_battle, display_x, display_y, true, false)
					
					-- Quest battle will spawn its own marker
					cm:remove_interactable_campaign_marker("monster_hunt_" .. faction_key)
				end
			elseif context:choice() == monster_hunt.config.monster_found_dilemma.attack_choice then
				local hunt_states = faction_persistent_data.hunt_states[hunt_config_data.key]
				-- Respawn new monster with same units for a forced battle
				-- Partially copied from Forced_Battle_Manager:trigger_forced_battle_with_generated_army, including the magic value 6
				local forced_battle_key = active_hunt .."_forced_battle"
				local forced_battle = Forced_Battle_Manager:setup_new_battle(forced_battle_key)
				
				local monster_faction_key = monster_hunt.get_monster_faction_key(faction_key)
				local army_data = hunt_config_data.generated_army
				forced_battle:add_new_force(
					forced_battle_key,
					faction_data.monster_units,
					monster_faction_key,
					-- the force will be destroyed after the battle
					true,
					nil,
					army_data.general_agent_subtype,
					nil,
					hunt_states.general_forename,
					hunt_states.general_surname)
				
				local attacker = character:military_force():command_queue_index()
				local defender = forced_battle_key

				local x, y = cm:find_valid_spawn_location_for_character_from_character(monster_faction_key, cm:char_lookup_str(character), true, 6)

				if faction_key == cm:get_local_faction_name(true) then
					cm:override_ui("disable_prebattle_autoresolve_monster_hunt", true)
				end

				forced_battle:trigger_battle(attacker, defender, x, y, false, true)
				faction_persistent_data.has_started_generated_battle = true
			end
		end

		-- Prolonged hunt dilemma
		if context:dilemma() == monster_hunt.config.prolonged_hunt.dilemma then
			if context:choice() == monster_hunt.config.prolonged_hunt.extend_choice then
				faction_data.turn_hunt_will_end = cm:model():turn_number() + monster_hunt.config.prolonged_hunt.turns_extension
			elseif context:choice() == monster_hunt.config.prolonged_hunt.abandon_choice then
				monster_hunt.deactivate_active_hunt(faction_key)
			end
			return
		end
		-- Decoy dilemma
		for tier, tier_data in ipairs(monster_hunt.config.tiers) do
			for _, hunt_data in ipairs(tier_data) do
				for _, dilemma in ipairs(hunt_data.decoy_dilemmas) do
					if context:dilemma() == dilemma then
						if context:choice() == monster_hunt.config.dilemma_cancel_choice then
							monster_hunt.deactivate_active_hunt(faction_key)
						else
							-- Spawn next marker after dilemma choice made, because global advice might prevent us from moving the camera
							local faction_data = monster_hunt.get_faction_persistent_data(faction_key)
							cm:add_interactable_campaign_marker("monster_hunt_" .. faction_key, "wh3_dlc27_monster_arcanum", faction_data.marker_position_x, faction_data.marker_position_y, monster_hunt.config.marker_radius, faction_key, "")

							local mission_key = faction_data.active_mission
							local mission_manager = cm:get_mission_manager(faction_key, mission_key)
							if mission_manager then
								mission_manager:set_position(faction_data.marker_position_x, faction_data.marker_position_y)
							end

							local faction_object = cm:get_faction(faction_key)
							cm:set_mission_location_override(faction_object, mission_key, faction_data.marker_position_x, faction_data.marker_position_y)

							if cm:get_local_faction_name(true) == faction_key then
								local display_x, display_y = cm:log_to_dis(faction_data.marker_position_x, faction_data.marker_position_y)
								local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
								cm:scroll_camera_from_current(false, monster_hunt.config.camera_scroll_speed, {display_x, display_y, cached_d, 0, cached_h})
							end
						end
						return
					end
				end
			end
		end
	end,
	true
)

-- MissionCancelled - MonsterHuntMissionsCancelled
core:add_listener(
	"MonsterHuntMissionsCancelled",
	"MissionCancelled",
	true,
	function(context)
		local faction_key = context:faction():name()
		local mission_key = context:mission():mission_record_key()
		local faction_persistent_data = monster_hunt.get_faction_persistent_data(faction_key)
		if faction_persistent_data and faction_persistent_data.active_mission == mission_key then
			monster_hunt.deactivate_active_hunt(faction_key)
		end
	end,
	true
)

-- PanelOpenedCampaign - MonsterHuntBookListener
core:add_listener(
	"MonsterHuntBookListener",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "book_of_monster_hunts"
	end,
	function(context)
		monster_hunt.init_ui(context)
	end,
	true
)

-- MonsterHuntStartListener UITrigger
core:add_listener(
	"MonsterHuntStartListener",
	"UITrigger",
	function(context)
		return context:trigger():starts_with("MonsterHuntStart")
	end,
	function(context)
		local faction = cm:model():faction_for_command_queue_index(context:faction_cqi())
		local params = context:trigger():split(":")
		local hunt_key = params[2]
		local hunter_cqi = params[3]
		local starting_region_key = params[4]
		monster_hunt.activate_a_monster_hunt(hunt_key, faction, hunter_cqi, starting_region_key)
	end,
	true
)

-- MonsterHuntCancelListener UITrigger
core:add_listener(
	"MonsterHuntCancelListener",
	"UITrigger",
	function(context)
		return context:trigger():starts_with("MonsterHuntCancel")
	end,
	function(context)
		local faction = cm:model():faction_for_command_queue_index(context:faction_cqi())
		local faction_key = faction:name()
		local hunt_key = monster_hunt.persistent[faction_key].active_hunt
		if not hunt_key then
			return
		end
		
		monster_hunt.deactivate_active_hunt(faction_key)
		local local_faction_key = cm:get_local_faction_name(true)
		if local_faction_key == faction_key then
			monster_hunt.init_ui()
			monster_hunt.update_tier_states(faction_key)
			UIComponent(monster_hunt.panel):InterfaceFunction("ShowPageForHunt", hunt_key)
		end
	end,
	true
)

-- MonsterHuntFactionTurnStart FactionTurnStart
core:add_listener (
	"MonsterHuntFactionTurnStart",
	"FactionTurnStart",
	function(context)
		local faction_key = context:faction():name()
		return table.find(monster_hunt.config.playable_monster_hunt_factions, faction_key) and context:faction():is_human() or false
	end,
	function(context)
		local faction_key = context:faction():name()
		local current_turn = cm:turn_number()
		
		local local_faction_key = cm:get_local_faction_name(true)
		if local_faction_key and local_faction_key == faction_key then
			monster_hunt.ui_refresh_availability()
		end		

		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)

		local faction_leader = context:faction():faction_leader()
		if context:faction():is_human() and
			monster_hunt.config.forced_hunts[faction_key] and current_turn >= monster_hunt.config.forced_hunts[faction_key] 
			and (not faction_data.has_started_at_least_one_hunt)
			and faction_leader:is_alive() and (not faction_leader:is_wounded())
		then
			-- Force start the 1st hunt from the 1st tier
			local tier_data = monster_hunt.config.tiers[1]
			local hunt_data = tier_data[1]

			local region_key = cm:find_nearest_region_in_climate_from_character(
				{
					character_lookup = cm:char_lookup_str(faction_leader),
					climate_keys = hunt_data.climates,
				}
			)
			if not (region_key == "") then
				local hunter_cqi = faction_leader:command_queue_index()
				monster_hunt.activate_a_monster_hunt(hunt_data.key, context:faction(), hunter_cqi, region_key)
				-- no dilemmas this turn if we just forced a hunt
				return
			end
		end
		
		if not (monster_hunt.persistent[faction_key] and monster_hunt.persistent[faction_key].active_hunt) then
			return
		end

		if faction_data.turn_hunt_will_end and current_turn == faction_data.turn_hunt_will_end then
			monster_hunt.deactivate_active_hunt(faction_key)
			return
		elseif current_turn == faction_data.turn_hunt_started + monster_hunt.config.prolonged_hunt.turns_to_trigger then
			cm:trigger_dilemma(faction_key, monster_hunt.config.prolonged_hunt.dilemma)
			return
		end

		local override_progression_dilemma_index = monster_hunt.dev_get_next_start_turn_dilemma_index(#faction_data.progression_dilemmas)
		local progression_cheat_active = not not override_progression_dilemma_index
		-- Progression dilemmas
		if faction_data.progression_dilemmas_issued >= monster_hunt.config.progression_dilemmas_limit and not progression_cheat_active then
			return
		end

		local rand = cm:random_number(100)
		if rand > monster_hunt.config.dilemma_chance and not progression_cheat_active then
			return
		end

		-- Search for the lord closest to the marker
		local characters_list = context:faction():character_list()
		local min_distance = 10000000
		local closest_lord = nil
		for i = 0, characters_list:num_items() - 1 do
			local character = characters_list:item_at(i)
			-- Exclude heroes and colonels
			if character:has_military_force() 
				and character:character_type("general")
				and is_number(faction_data.marker_position_x)
				and faction_data.marker_position_x >= 0
				and is_number(faction_data.marker_position_y)
				and faction_data.marker_position_y >= 0
			then
				local distance = distance_squared(character:logical_position_x(), character:logical_position_y(), faction_data.marker_position_x, faction_data.marker_position_y)
				if distance < min_distance then
					min_distance = distance
					closest_lord = character
				end
			end
		end

		if not closest_lord then
			return
		end
		
		local dilemma_index = override_progression_dilemma_index or cm:random_number(#faction_data.progression_dilemmas)
		cm:trigger_dilemma_with_targets(context:faction():command_queue_index(),
			faction_data.progression_dilemmas[dilemma_index],
			0,
			0,
			closest_lord:command_queue_index(),
			closest_lord:military_force():command_queue_index())
		table.remove(faction_data.progression_dilemmas, dilemma_index)
		if #faction_data.progression_dilemmas == 0 then
			faction_data.progression_dilemmas = table.copy(monster_hunt.config.progression_dilemmas)
		end

		faction_data.progression_dilemmas_issued = faction_data.progression_dilemmas_issued + 1
	end,
	true
)

-- MonsterHuntCAIFactionTurnStart FactionTurnStart
core:add_listener (
	"MonsterHuntCAIFactionTurnStart",
	"FactionTurnStart",
	function(context)
		local faction_key = context:faction():name()
		return monster_hunt.persistent[faction_key] and not context:faction():is_human()
	end,
	function(context)
		local faction_key = context:faction():name()
		local faction_data = monster_hunt.get_faction_persistent_data(faction_key)

		if cm:model():turn_number() == faction_data.cooldown_end_turn then 
			local available_tiers = {}
			local available_hunts = {}

			for index, item in ipairs(monster_hunt.cai_config.cai_hunt_tier_thresholds) do
				if cm:turn_number() >= item then
					table.insert(available_tiers, index)
				end
			end
			
			for index in ipairs(monster_hunt.config.tiers) do
				if available_tiers[index] then
					for index, item in ipairs(monster_hunt.config.tiers[index]) do
						if faction_data.hunt_states[item.key].is_completed == false then
							table.insert(available_hunts, item) 
						end
					end
				end
			end

			local rand = cm:random_number(#available_hunts, 1)
			local selected_hunt = available_hunts[rand]

			faction_data.active_hunt = selected_hunt.key
			faction_data.hunt_states[selected_hunt.key].is_stage_started = true
			faction_data.hunt_states[selected_hunt.key].direction = nil
			monster_hunt.advance_stage(faction_key)

			faction_data.cooldown_end_turn = cm:model():turn_number() + monster_hunt.cai_config.cai_hunt_cooldown
			cm:set_script_state(context:faction(), monster_hunt.config.cooldown_shared_state_name, faction_data.cooldown_end_turn)
		end
	end,
	true
)

-- MonsterHuntInitialize FirstTickAfterNewCampaignStarted
core:add_listener (
	"MonsterHuntInitialize",
	"FirstTickAfterNewCampaignStarted",
	true,
	function(context)
		local faction_list = context:model():world():faction_list()

		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
			local faction_key = faction:name()
			if faction:is_human() == false then
				for index, item in ipairs(monster_hunt.config.playable_monster_hunt_factions) do
					if item == faction_key and not monster_hunt.persistent[faction_key] then
						local data = monster_hunt.get_faction_persistent_data(faction_key)
						data.cooldown_end_turn = monster_hunt.cai_config.cai_hunt_cooldown
						cm:set_script_state(faction, monster_hunt.config.cooldown_shared_state_name, data.cooldown_end_turn)
					end
				end
			end
		end

		-- Manually restrict all RoR reward units
		for tier_index = 1, #monster_hunt.config.tiers do
			local tier_data = monster_hunt.config.tiers[tier_index]
			for _, hunt_data in ipairs(tier_data) do
				if hunt_data.reward_stage_1_unit_ror then
					for _, faction_key in ipairs(monster_hunt.config.playable_monster_hunt_factions) do
						cm:add_event_restricted_unit_record_for_faction(hunt_data.reward_stage_1_unit_ror, faction_key)
					end
				end
			end
		end
	end,
	true
)

-- MonsterHuntFirstTickAfterWorldCreated FirstTickAfterWorldCreated
core:add_listener (
	"MonsterHuntFirstTickAfterWorldCreated",
	"FirstTickAfterWorldCreated",
	true,
	function(context)
		monster_hunt.convert_saves()
		monster_hunt.ui_refresh_availability()
	end,
	true
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("Monster_hunts", monster_hunt.persistent, context)
		cm:save_named_value("Monster_hunts_ui_persistent", monster_hunt.ui_persistent, context)
		cm:save_named_value("Monster_hunts_dev_force_enabled", monster_hunt.dev_force_enabled, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		monster_hunt.persistent = cm:load_named_value("Monster_hunts", monster_hunt.persistent or {}, context)
		monster_hunt.ui_persistent = cm:load_named_value("Monster_hunts_ui_persistent", monster_hunt.ui_persistent or {}, context)
		monster_hunt.dev_force_enabled = cm:load_named_value("Monster_hunts_dev_force_enabled", monster_hunt.dev_force_enabled, context)
		monster_hunt.on_load()
	end
)