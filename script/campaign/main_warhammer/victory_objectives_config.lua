_victory_objectives_ie = {}
_victory_objectives_ie_config = {}

core:add_listener(
	"InitializeVictoryObjectivesIEConfig",
	"WorldCreated",
	true,
	function(context)
		_victory_objectives_ie_config = {
			victory_types = {
				short = {
					mission_key = "wh_main_short_victory",
					victory_type_key = "wh3_combi_victory_type_faction",
				},
				long = {
					mission_key = "wh_main_long_victory",
					victory_type_key = "wh3_combi_victory_type_subculture",
				},
				domination = {
					mission_key = "wh_main_domination_victory",
					victory_type_key = "wh3_combi_victory_type_domination",
				},
				multiplayer = {
					mission_key = "wh3_main_mp_victory",
					victory_type_key = "wh3_combi_victory_type_multiplayer",
				},
			},
			factions = {
----- BEASTMEN -----
				wh_dlc03_bst_beastmen = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_emp_middenland"}, true),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({	"wh2_dlc17_bst_ritual_legendary_lord_malagor",
																			"wh2_dlc17_bst_ritual_legendary_lord_morgur",
																			"wh2_dlc17_bst_ritual_legendary_lord_taurox",},
																			1, true,
																			"mission_text_text_wh3_dlc29_bst_unlock_beastmen_legendary_lord_short"),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh2_dlc17_bst_ritual_unit_cap_bestigor_herd"}, 3, nil, "mission_text_text_wh3_dlc29_bst_raise_bestigor_herd_unit_capacity_short"),
							generate_KILL_X_ENTITIES_BY_objective(2800, "bst_dlc03_bestigors", "mission_text_text_wh3_dlc29_bst_kill_n_entities_with_bestigor_herd_short", true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 60, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_short", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_bst_khazrak_victory_objective_short",
							ancillary = "wh3_dlc29_anc_bst_talisman_of_dark_gods",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh_main_emp_middenland", "wh_main_emp_empire", "wh_main_emp_wissenland"}, true),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({	"wh2_dlc17_bst_ritual_legendary_lord_malagor",
																			"wh2_dlc17_bst_ritual_legendary_lord_morgur",
																			"wh2_dlc17_bst_ritual_legendary_lord_taurox",},
																			2, true,
																			"mission_text_text_wh3_dlc29_bst_unlock_all_beastmen_legendary_lords"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("BEASTMEN_RITUAL_UNITS", 50, "mission_text_text_wh3_dlc29_bst_khazrak_perform_unit_cap_rituals"),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 150, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_long"),
						},
						payloads = {
							pooled_resource = {{"bst_herdstone_shard", "wh2_dlc17_bst_herdstone_shard_gain_abandon_settlement", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_lord_recruit_rank_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc17_bst_taurox = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_claim_rampage_rewards_n_times_short", "mission_text_text_wh3_dlc29_bst_claim_rampage_rewards_n_times", 2, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 60, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_win_n_battles_in_one_turn_short", "mission_text_text_wh3_dlc29_bst_win_n_battles_in_one_turn_short", 3, 0, true),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({	"wh2_dlc17_bst_ritual_unit_cap_minotaurs",
																			"wh2_dlc17_bst_ritual_unit_cap_minotaurs_great_weapons",
																			"wh2_dlc17_bst_ritual_unit_cap_minotaurs_shield",}, 3, nil, "mission_text_text_wh3_dlc29_bst_raise_minotaur_unit_capacity_short"),
							generate_KILL_X_ENTITIES_BY_objective(2800, "bst_dlc03_minotaurs", "mission_text_text_wh3_dlc29_bst_kill_n_entities_with_minotaurs_short", true),
							generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective({}, 30),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_short", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_bst_taurox_victory_objective_short",
							ancillary = "wh3_dlc29_anc_bst_talisman_of_dark_gods",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 150, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_claim_rampage_rewards_n_times_long", "mission_text_text_wh3_dlc29_bst_claim_rampage_rewards_n_times", 6, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_long", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_long", 3, 0, true),
						},
						payloads = {
							pooled_resource = {{"bst_herdstone_shard", "wh2_dlc17_bst_herdstone_shard_gain_abandon_settlement", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_lord_recruit_rank_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_dlc05_bst_morghur_herd = {
					short = {
						objectives = {
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 60, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_short"),
							generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective({}, 30),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_short", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc05_qb_bst_morghur_stave_of_ruinous_corruption"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_bst_morghur_victory_objective_short",
							ancillary = "wh3_dlc29_anc_bst_talisman_of_dark_gods",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 150, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_long", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_long", 5, 0, true),
							generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective({"wh3_main_combi_region_the_oak_of_ages"},1),
						},
						payloads = {
							pooled_resource = {{"bst_herdstone_shard", "wh2_dlc17_bst_herdstone_shard_gain_abandon_settlement", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_lord_recruit_rank_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc17_bst_malagor = {
					short = {
						objectives = {
							generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective({}, 30),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh2_dlc17_bst_ritual_hero_capacity_bray_shaman"}, 3, nil, "mission_text_text_wh3_dlc29_bst_malagor_increase_bray_shaman_capacity_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc_bst_get_n_bray_shamans_to_rank_10_short", "mission_text_text_wh3_dlc_bst_get_n_bray_shamans_to_rank_10_short", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_short", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_short"),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 60, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_bst_malagor_victory_objective_short",
							ancillary = "wh3_dlc29_anc_bst_talisman_of_dark_gods",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("bst_ruination", 150, true, "mission_text_text_wh3_dlc29_bst_reach_ruination_tier_long"),
							generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective({}, 60),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bst_construct_special_herdstone_long", "mission_text_text_wh3_dlc29_bst_construct_special_herdstone_long", 3, 0, true),
						},
						payloads = {
							pooled_resource = {{"bst_herdstone_shard", "wh2_dlc17_bst_herdstone_shard_gain_abandon_settlement", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_lord_recruit_rank_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- LIZARDMEN -----
				wh2_main_lzd_hexoatl = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_jungles_of_pahualaxa",
																				"wh3_main_combi_province_isthmus_of_lustria",
																				"wh3_main_combi_province_the_isthmus_coast"},
																				3),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_hexoatl_construct_landmark_short", "mission_text_text_wh3_dlc29_lzd_hexoatl_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh2_main_lzd_unlock_lord_kroak_short", "effect_bundles_localised_title_wh3_main_effect_gain_lord_kroak_dummy"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_blessed_spawning_temple_guard_capacity_bundle", "wh3_dlc29_ie_victory_conditions_geomantic_buildings_bundle"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_jungles_of_pahualaxa",
																				"wh3_main_combi_province_isthmus_of_lustria",
																				"wh3_main_combi_province_the_isthmus_coast",
																				"wh3_main_combi_province_culchan_plains",
																				"wh3_main_combi_province_headhunters_jungle",
																				"wh3_main_combi_province_spine_of_sotek",
																				"wh3_main_combi_province_the_lost_valley",
																				"wh3_main_combi_province_river_qurveza",
																				"wh3_main_combi_province_mosquito_swamps",
																				"wh3_main_combi_province_the_gwangee_valley",
																				"wh3_main_combi_province_the_turtle_isles",
																				"wh3_main_combi_province_scorpion_coast",
																				"wh3_main_combi_province_the_creeping_jungle",
																				"wh3_main_combi_province_jungles_of_green_mist",
																				"wh3_main_combi_province_aymara_swamps",
																				"wh3_main_combi_province_copper_desert",
																				"wh3_main_combi_province_the_night_forest_road",
																				"wh3_main_combi_province_the_capes",
																				"wh3_main_combi_province_volcanic_islands"},
																				19,
																				"mission_text_text_wh_main_objective_override_mazdamundi_control"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_construct_landmark_buldings_in_region", "mission_text_text_wh3_dlc29_lzd_kroq_construct_landmark_buldings_1_short"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_lzd_last_defenders = {
					short = {
						objectives = {
							generate_RECRUIT_N_UNITS_FROM_objective({"wh2_main_lzd_inf_saurus_warriors_blessed_1", "wh2_main_lzd_inf_saurus_spearmen_blessed_1"}, 8, false, "mission_text_text_wh3_dlc29_lzd_recruit_n_blessed_saurus_short"),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(	6,
																			{	"wh2_main_tech_lzd_7_1",
																				"wh2_main_tech_lzd_1_3",
																				"wh2_main_tech_lzd_7_2",
																				"wh2_main_tech_lzd_7_5",
																				"wh2_main_tech_lzd_7_3",
																				"wh2_main_tech_lzd_7_4"},
																			true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_kroqgar_construct_landmark_short", "mission_text_text_wh3_dlc29_lzd_kroqgar_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh2_main_lzd_unlock_lord_kroak_short", "effect_bundles_localised_title_wh3_main_effect_gain_lord_kroak_dummy"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_DESTROY_FACTION_objective({"wh3_main_skv_clan_morbidus","wh2_main_skv_clan_mordkin"}, true),

						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_lzd_kroqgar_victory_objective_short",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_blessed_spawning_saurus_warriors_capacity_bundle",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_the_golden_pass",
																				"wh3_main_combi_province_central_jungles",
																				"wh3_main_combi_province_western_jungles",
																				"wh3_main_combi_province_southern_jungles",
																				"wh3_main_combi_province_the_jungles_of_the_gods",
																				"wh3_main_combi_province_kingdom_of_beasts",
																				"wh3_main_combi_province_the_dragon_isles"},
																				5),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_lzd_tlaqua = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_western_jungles",
																				"wh3_main_combi_province_central_jungles",},
																				2),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(	6,
																			{	"wh2_main_tech_lzd_8_1",
																				"wh2_main_tech_lzd_8_6",
																				"wh2_main_tech_lzd_8_5",
																				"wh2_main_tech_lzd_8_7",
																				"wh2_main_tech_lzd_1_5",
																				"wh2_main_tech_lzd_beasts_6"},
																			true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_recruit_n_flying_units_short", "mission_text_text_wh3_dlc29_lzd_recruit_n_flying_units_short", 5, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_blessed_spawning_ripperdactyl_terradon_capacity_bundle", "wh3_dlc29_bundle_ie_victory_objective_lzd_climate_penalties_nulified"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_the_golden_pass",
																				"wh3_main_combi_province_central_jungles",
																				"wh3_main_combi_province_western_jungles",
																				"wh3_main_combi_province_southern_jungles",
																				"wh3_main_combi_province_the_jungles_of_the_gods",
																				"wh3_main_combi_province_kingdom_of_beasts",
																				"wh3_main_combi_province_dawns_landing",
																				"wh3_main_combi_province_heart_of_the_jungle"
																			},
																			8),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc12_lzd_cult_of_sotek = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_pestilens","wh2_main_skv_clan_spittel", "wh3_main_skv_clan_skrat"}, true),
							generate_SCRIPTED_MISSION_objective("prophecy_of_sotek_1", "mission_text_text_mis_activity_sotek_stage_one"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "lzd_sacrificial_offerings"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_SCRIPTED_MISSION_objective("wh2_main_lzd_unlock_lord_kroak_short", "effect_bundles_localised_title_wh3_main_effect_gain_lord_kroak_dummy"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_blessed_spawning_skink_capacity_bundle", "wh3_dlc29_ie_victory_conditions_post_battle_captives_add_bundle",},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_construct_landmark_buldings_in_region", "mission_text_text_wh3_dlc29_lzd_kroq_construct_landmark_buldings_1_short"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_jungles_of_pahualaxa",
																				"wh3_main_combi_province_isthmus_of_lustria",
																				"wh3_main_combi_province_the_isthmus_coast",
																				"wh3_main_combi_province_culchan_plains",
																				"wh3_main_combi_province_headhunters_jungle",
																				"wh3_main_combi_province_spine_of_sotek",
																				"wh3_main_combi_province_the_lost_valley",
																				"wh3_main_combi_province_river_qurveza",
																				"wh3_main_combi_province_mosquito_swamps",
																				"wh3_main_combi_province_the_gwangee_valley",
																				"wh3_main_combi_province_the_turtle_isles",
																				"wh3_main_combi_province_scorpion_coast",
																				"wh3_main_combi_province_the_creeping_jungle",
																				"wh3_main_combi_province_jungles_of_green_mist",
																				"wh3_main_combi_province_aymara_swamps",
																				"wh3_main_combi_province_copper_desert",
																				"wh3_main_combi_province_the_night_forest_road",
																				"wh3_main_combi_province_the_capes",
																				"wh3_main_combi_province_volcanic_islands"},
																				19,
																				"mission_text_text_wh_main_objective_override_mazdamundi_control"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
							generate_SCRIPTED_MISSION_objective("prophecy_of_sotek_3", "mission_text_text_mis_activity_sotek_stage_three"),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc13_lzd_spirits_of_the_jungle = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_gain_5_nakai_temples", "mission_text_text_wh3_dlc29_ie_gain_5_nakai_temples"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("STANDARD_RITUAL", 5, "mission_text_text_wh3_dlc29_nakai_victory_objective_perform_5_rites"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(	4,
																			{	"wh2_dlc13_tech_lzd_nakai_expansion_1",
																				"wh2_dlc13_tech_lzd_nakai_expansion_2",
																				"wh2_dlc13_tech_lzd_nakai_expansion_3",
																				"wh2_dlc13_tech_lzd_nakai_expansion_4"},
																			true),
							generate_DESTROY_FACTION_objective({"wh3_dlc27_sla_the_tormentors"}, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_blessed_spawning_kroxigor_capacity_bundle", "wh3_dlc29_ie_victory_conditions_temple_of_the_old_ones_favour_production_mult_bundle"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "lzd_old_ones_favour", "mission_text_text_wh3_dlc29_lzd_nakai_spend_favour_on_temples_long", "temple_rewards"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
							generate_DESTROY_FACTION_objective({"wh2_dlc11_def_the_blessed_dread",
																"wh3_main_vmp_caravan_of_blue_roses",
																"wh2_main_skv_clan_eshin",
																"wh3_dlc20_chs_vilitch"},
																true),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_lzd_itza = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_pestilens",
																"wh3_dlc20_nur_pallid_nurslings",
																"wh3_dlc26_kho_skulltaker",
															 	"wh2_main_skv_clan_spittel"},
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_kroq_construct_landmark_buldings_short", "mission_text_text_wh3_dlc29_lzd_kroq_construct_landmark_buldings_short"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cast_20_deliverance_of_itza",
																"mission_text_text_wh3_dlc29_cast_20_deliverance_of_itza_spells",
																20,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_blessed_spawning_saurus_warriors_capacity_bundle",
							ancillary = "wh3_dlc29_anc_lzd_follower_veteran_healer",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_kroq_construct_landmark_buldings_long", "mission_text_text_wh3_dlc29_lzd_kroq_construct_landmark_buldings_long"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_jungles_of_pahualaxa",
																				"wh3_main_combi_province_isthmus_of_lustria",
																				"wh3_main_combi_province_the_isthmus_coast",
																				"wh3_main_combi_province_culchan_plains",
																				"wh3_main_combi_province_headhunters_jungle",
																				"wh3_main_combi_province_spine_of_sotek",
																				"wh3_main_combi_province_the_lost_valley",
																				"wh3_main_combi_province_river_qurveza",
																				"wh3_main_combi_province_mosquito_swamps",
																				"wh3_main_combi_province_the_gwangee_valley",
																				"wh3_main_combi_province_the_turtle_isles",
																				"wh3_main_combi_province_scorpion_coast",
																				"wh3_main_combi_province_the_creeping_jungle",
																				"wh3_main_combi_province_jungles_of_green_mist",
																				"wh3_main_combi_province_aymara_swamps",
																				"wh3_main_combi_province_copper_desert",
																				"wh3_main_combi_province_the_night_forest_road",
																				"wh3_main_combi_province_the_capes",
																				"wh3_main_combi_province_volcanic_islands"},
																				19,
																				"mission_text_text_wh_main_objective_override_mazdamundi_control"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning")
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc17_lzd_oxyotl = {
					short = {
						objectives = {
							generate_COMPLETE_N_MISSIONS_OF_CATEGORY_objective(10, {"Chaos_Map_Easy", "Chaos_Map_Medium"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_build_10_silent_sanctums",
																"mission_text_text_wh3_dlc29_build_10_silent_sanctums_in_enemy_territory",
																10,
																0,
																true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_main_lzd_sacred_spawning"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_lzd_oxyotl_sanctum_gems_victory_objective_short",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_blessed_spawning_skink_capacity_bundle",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_COMPLETE_N_MISSIONS_OF_CATEGORY_objective(20, {"Chaos_Map_Medium", "Chaos_Map_Hard"}),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_main_lzd_sacred_spawning"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_lzd_oxyotl_build_silent_sactums_in_regions_long", "mission_text_text_wh3_dlc29_lzd_oxyotl_build_silent_sactums_in_regions_long"),
						},
						payloads = {
							pooled_resource = {{"wh3_main_lzd_sacred_spawning", "missions", 5000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- HIGH ELF -----
				wh2_main_hef_eataine = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_cult_of_excess", "wh2_dlc11_cst_noctilus"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tyrion_champions_of_ulthuan_short",
																"mission_text_text_tyrion_champions_of_ulthuan_short_victory",
																10,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_and_upgrade_eataine_patron_seat",
																"mission_text_text_wh3_dlc29_hold_and_upgrade_eataine_patron_seat"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_construct_lothern_landmark", "mission_text_text_wh3_dlc29_hef_construct_lothern_landmark"),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_hef_court_bard",
										"wh2_main_anc_talisman_diamond_guardian_phoenix",
										"wh2_main_anc_armour_helm_of_khaine"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_eataine",
																				"wh3_main_combi_province_caledor",
																				"wh3_main_combi_province_tiranoc",
																				"wh3_main_combi_province_ellyrion",
																				"wh3_main_combi_province_nagarythe",
																				"wh3_main_combi_province_avelorn",
																				"wh3_main_combi_province_chrace",
																				"wh3_main_combi_province_cothique",
																				"wh3_main_combi_province_saphery",
																				"wh3_main_combi_province_northern_yvresse",
																				"wh3_main_combi_province_southern_yvresse",
																				"wh3_main_combi_province_eagle_gate",
																				"wh3_main_combi_province_griffon_gate",
																				"wh3_main_combi_province_unicorn_gate",
																				"wh3_main_combi_province_phoenix_gate"},
																				15),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tyrion_confederate_atleast_1_hef",
																"mission_text_text_wh3_dlc29_tyrion_confederate_atleast_1_hef"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_tyrion_construct_landmark_long", "mission_text_text_wh3_dlc29_hef_tyrion_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tyrion_champions_of_ulthuan_long",
																"mission_text_text_tyrion_champions_of_ulthuan_short_victory",
																20,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh2_main_def_cult_of_pleasure", "wh2_main_def_naggarond"}, true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_hef_order_of_loremasters = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_main_skv_clan_morbidus", "wh3_main_tze_oracles_of_tzeentch", "wh_main_grn_orcs_of_the_bloody_hand"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_and_upgrade_any_patron_seat",
																"mission_text_text_wh3_dlc29_hold_and_upgrade_any_patron_seat"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_perform_secrets_of_white_tower_actions_short",
																"mission_text_text_teclis_secrets_of_white_tower_short_victory",
																12,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_teclis_construct_landmark_short", "mission_text_text_wh3_dlc29_hef_teclis_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_recruit_mages_with_secrets_of_white_tower",
																"mission_text_text_wh3_dlc29_recruit_mages_with_secrets_of_white_tower",
																2,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_objective_hef_teclis_short",
							ancillary = {"wh2_main_anc_enchanted_item_ring_of_hukon",
										"wh2_main_anc_talisman_sapphire_guardian_phoenix"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_perform_secrets_of_white_tower_actions_long",
																"mission_text_text_teclis_secrets_of_white_tower_long_victory",
																24,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_recruit_each_school_mage_with_secrets_of_white_tower",
																"mission_text_text_wh3_dlc29_recruit_each_school_mage_with_secrets_of_white_tower",
																5,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_teclis_rankup_mages_long",
																"mission_text_text_wh3_dlc29_hef_teclis_rankup_mages_long",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh2_main_hef_order_of_loremasters",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_hef_avelorn = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_scourge_of_khaine", "wh2_main_def_cult_of_excess", "wh3_main_sla_seducers_of_slaanesh"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_and_upgrade_gaean_vale_patron_seat",
																"mission_text_text_wh3_dlc29_hold_and_upgrade_gaean_vale_patron_seat"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_construct_gaean_vale_landmark", "mission_text_text_wh3_dlc29_hef_construct_gaean_vale_landmark"),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_hef_allariele_handmaiden",
										"wh2_main_anc_talisman_emerald_collar",
										"wh2_main_anc_armour_enchanted_ithilmar_breastplate"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_dlc11_cst_noctilus", "wh2_main_def_cult_of_pleasure"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_own_N_wood_elf_settlements",
																"mission_text_text_wh3_dlc29_own_N_wood_elf_settlements",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_alarielle_construct_landmark_long", "mission_text_text_wh3_dlc29_hef_alarielle_construct_landmark_long"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_eataine",
																				"wh3_main_combi_province_caledor",
																				"wh3_main_combi_province_tiranoc",
																				"wh3_main_combi_province_ellyrion",
																				"wh3_main_combi_province_nagarythe",
																				"wh3_main_combi_province_avelorn",
																				"wh3_main_combi_province_chrace",
																				"wh3_main_combi_province_cothique",
																				"wh3_main_combi_province_saphery",
																				"wh3_main_combi_province_northern_yvresse",
																				"wh3_main_combi_province_southern_yvresse",
																				"wh3_main_combi_province_eagle_gate",
																				"wh3_main_combi_province_griffon_gate",
																				"wh3_main_combi_province_unicorn_gate",
																				"wh3_main_combi_province_phoenix_gate"},
																				15),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh2_main_hef_avelorn",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_hef_nagarythe = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_alith_assasinate_targets_short",
																"mission_text_text_wh3_dlc29_alith_assasinate_targets",
																3,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh2_main_def_karond_kar",
																"wh2_main_def_naggarond",
																"wh2_dlc11_cst_the_drowned",
																"wh2_main_def_scourge_of_khaine"},
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_nagarythe"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_and_upgrade_nagarythe_patron_seat",
																"mission_text_text_wh3_dlc29_hold_and_upgrade_nagarythe_patron_seat"),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_standard_hef_shadow_banner",
										"wh2_main_anc_weapon_reaver_bow",
										"wh2_main_anc_talisman_amulet_of_foresight"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_alith_assasinate_targets_long",
																"mission_text_text_wh3_dlc29_alith_assasinate_targets",
																10,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh2_main_def_cult_of_pleasure",
																"wh2_main_def_hag_graef",
																"wh2_twa03_def_rakarth"},
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective(province_key_list_from_region_group("wh3_dlc24_schemes_theatre_ie_naggaroth"),
																			3,
																			"mission_text_text_wh3_dlc29_alith_control_N_provinces_in_X_theatre"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh2_main_hef_nagarythe",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_hef_yvresse = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_athel_tamarha_upgrades_short_victory",
																"mission_text_text_mis_upgrade_athel_tamarha_victory"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_two_patron_seats_with_one_upgraded",
																"mission_text_text_wh3_dlc29_hold_two_patron_seats_with_one_upgraded"),
							generate_DESTROY_FACTION_objective({"wh_main_grn_top_knotz",
																"wh_main_grn_teef_snatchaz",
																"wh3_dlc26_grn_gorbad_ironclaw"},
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_eltharion_construct_landmark_short", "mission_text_text_wh3_dlc29_hef_eltharion_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_hef_mistwalker_unit_cap_short",
											"wh3_dlc29_bundle_ie_victory_objective_hef_athel_tamarha_short",},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_athel_tamarha_max_upgrades_long_victory",
																"mission_text_text_mis_upgrade_max_athel_tamarha_victory"),
							generate_DESTROY_FACTION_objective({"wh_main_grn_necksnappers",
																"wh_main_grn_scabby_eye",
																"wh2_main_skv_clan_mors",
																"wh2_main_skv_clan_skryre",
																"wh2_dlc15_grn_broken_axe",},
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh2_main_hef_yvresse",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_tor_yvresse"},
																		1,
																		"mission_text_text_mis_upgrade_tor_yvresse_safe"),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc15_hef_imrik = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_imrik_encounter_legendary_dragons_short",
																"mission_text_text_wh3_dlc29_imrik_encounter_legendary_dragons",
																2,
																0,
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_plain_of_bones"}, 1),
							generate_DESTROY_FACTION_objective({"wh2_dlc09_skv_clan_rictus",
																"wh3_main_nur_poxmakers_of_nurgle",
																"wh3_main_ogr_thunderguts",
																"wh3_dlc23_chd_legion_of_azgorh"},
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hold_and_upgrade_any_patron_seat",
																"mission_text_text_wh3_dlc29_hold_and_upgrade_any_patron_seat"),
							generate_OWN_N_UNITS_objective(3, { "wh2_main_def_mon_black_dragon",
																"wh2_dlc15_hef_mon_forest_dragon_0",
																"wh2_main_hef_mon_moon_dragon",
																"wh2_main_hef_mon_star_dragon",
																"wh2_main_hef_mon_sun_dragon"},
																nil, nil, nil, nil, "mission_text_text_wh3_dlc29_imrik_control_n_dragons"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_hef_dragon_princes_short",
							ancillary = {"wh2_main_anc_enchanted_item_ring_of_hukon",
										"wh2_main_anc_armour_crown_of_authority"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_hef_construct_dragon_graveyard_landmark", "mission_text_text_wh3_dlc29_hef_construct_dragon_graveyard_landmark"),
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_mors",
																"wh3_dlc26_grn_gorbad_ironclaw",
																"wh3_main_kho_exiles_of_khorne",},
																true),
							generate_OWN_N_UNITS_objective(6, { "wh2_main_def_mon_black_dragon",
																"wh2_dlc15_hef_mon_forest_dragon_0",
																"wh2_main_hef_mon_moon_dragon",
																"wh2_main_hef_mon_star_dragon",
																"wh2_main_hef_mon_sun_dragon"},
																nil, nil, nil, nil, "mission_text_text_wh3_dlc29_imrik_control_n_dragons"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_imrik_encounter_legendary_dragons_long",
																"mission_text_text_wh3_dlc29_imrik_encounter_legendary_dragons",
																5,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh2_dlc15_hef_imrik",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc27_hef_aislinn = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_aislinn_unlock_drahonship_short",
																"mission_text_text_wh3_dlc27_mission_hef_aislinn_dragonships_short_victory",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_aislinn_establish_colonies_short",
																"mission_text_text_wh3_dlc27_mis_activity_establish_colonies",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_aislinn_gift_colonies_short",
																"mission_text_text_wh3_dlc29_aislinn_gift_colonies_short",
																5,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh3_main_cst_dread_rock_privateers"}, true),
							generate_OWN_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_tower_of_the_sun",
																		"wh3_main_combi_region_tower_of_the_stars",
																		"wh3_main_combi_region_tor_elasor"},
																		3,
																		"mission_text_text_wh3_dlc27_mission_narrative_hef_aislinn_colonies",
																		"wh2_main_sc_hef_high_elves"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_hef_dragonship_building_construction_short",
							ancillary = {"wh2_main_anc_weapon_sea_gold_parrying_blade",
										"wh2_main_anc_arcane_item_jewel_of_the_dusk"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_main_cst_dread_rock_privateers",
																"wh2_dlc11_cst_vampire_coast",
																"wh2_dlc11_cst_pirates_of_sartosa",
																"wh2_dlc11_def_the_blessed_dread"},
																true),
							generate_OWN_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_fortress_of_dawn",
																		"wh3_main_combi_region_tower_of_the_sun",
																		"wh3_main_combi_region_tower_of_the_stars",
																		"wh3_main_combi_region_tor_elasor",
																		"wh3_main_combi_region_gronti_mingol",
																		"wh3_main_combi_region_citadel_of_dusk",
																		"wh3_main_combi_region_the_star_tower",
																		"wh3_main_combi_region_great_turtle_isle",
																		"wh3_main_combi_region_arnheim"},
																		9,
																		"mission_text_text_wh3_dlc27_mission_narrative_hef_aislinn_colonies",
																		"wh2_main_sc_hef_high_elves"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc27_qb_hef_aislinn_final_battle"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_spend_2000_influence_wh3_dlc27_hef_aislinn",
																"mission_text_text_wh3_dlc29_tyrion_spend_2000_influence",
																2000,
																0,
																true),
						},
						payloads = {
							influence = 2000,
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- DWARF -----
				wh_main_dwf_dwarfs = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_grn_crooked_moon", "wh3_dlc26_grn_gorbad_ironclaw"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_confederate_other_legendary_lord_dwarfs_short",
																"mission_text_text_wh3_dlc29_confederate_other_legendary_lord_dwarfs",
																1,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_construct_throne_hall_landmark", "mission_text_text_wh3_dlc29_dwf_construct_throne_hall_landmark"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader", "wh3_dlc29_bundle_ie_victory_objective_dwf_age_of_reckoning_progress_after_reset"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_ornate_great_gate", "mission_text_text_wh3_dlc29_construct_ornate_great_gate"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_battle_of_hel_fenn"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_confederate_other_legendary_lord_dwarfs_long",
																"mission_text_text_wh3_dlc29_confederate_other_legendary_lord_dwarfs",
																3,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_dwf_karak_kadrin = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc15_grn_bonerattlaz", "wh_main_grn_red_eye"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers_short",
																"mission_text_text_wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers",
																10,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_construct_slayer_shrine_landmark", "mission_text_text_wh3_dlc29_dwf_construct_slayer_shrine_landmark"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_5_6_ancient_dragon_cave"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_dwf_ungrim_lord_victory_objective_short",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers_long",
																"mission_text_text_wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers",
																20,
																0,
																true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_ornate_great_gate", "mission_text_text_wh3_dlc29_construct_ornate_great_gate"),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_dwf_karak_izor = {
					short = {
						objectives = {
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_karak_eight_peaks"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh_main_grn_necksnappers", "wh_main_grn_crooked_moon"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_rank_50_with_belegar_and_start_heroes",
																"mission_text_text_wh3_dlc29_reach_rank_50_with_belegar_and_start_heroes",
																60,
																5,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader",
											"wh3_dlc29_bundle_ie_victory_objective_dwf_rightful_home"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_belegar_landmark_long", "mission_text_text_wh3_dlc29_construct_belegar_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_ornate_great_gate", "mission_text_text_wh3_dlc29_construct_ornate_great_gate"),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_dwf_the_ancestral_throng = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_naggarond", "wh2_main_def_har_ganeth"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_grombindal_rankup_units_short", "mission_text_text_wh3_dlc29_dwf_grombindal_rankup_units_short", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader",
											"wh3_dlc29_bundle_ie_victory_objective_dwf_dwarf_stonemason"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_ornate_great_gate", "mission_text_text_wh3_dlc29_construct_ornate_great_gate"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_destroy_at_least_n_factions",
																"mission_text_text_wh3_dlc29_destroy_at_least_n_factions"),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc17_dwf_thorek_ironbrow = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_thorek_reforge_raton_collar",
																"mission_text_text_wh3_dlc29_thorek_reforge_raton_collar"),
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_last_defenders", "wh_main_grn_orcs_of_the_bloody_hand", "wh3_main_kho_exiles_of_khorne"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc17_qb_dwf_thorek_klad_brakak"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_thorek_landmark_short", "mission_text_text_wh3_dlc29_construct_thorek_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader",
											"wh3_dlc29_bundle_ie_victory_objective_dwf_dwarf_forge_assistant"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_thorek_reforge_n_artefacts",
																"mission_text_text_wh3_dlc29_thorek_reforge_n_artefacts",
																5,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_ornate_great_gate", "mission_text_text_wh3_dlc29_construct_ornate_great_gate"),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc25_dwf_malakai = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_n_malakai_legenday_battles_short",
																"mission_text_text_malakai_oath_steel_glory_short_victory",
																4,
																0,
																true),
							generate_CONSTRUCT_BUILDINGS_INCLUDING_objective(1, "wh3_dlc25_dwf_malakai", {"wh3_dlc25_dwarf_spirit_of_grungni_airship_hull_4"}, nil, "mission_text_text_wh3_dlc29_upgrade_malakai_airship_frame_to_reinforced"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short",
																"mission_text_text_wh3_dlc29_finish_grudge_cycle_in_X_tier_Y_times",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dwf_malakai_construct_landmark_short", "mission_text_text_wh3_dlc29_dwf_malakai_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_single_legendary_grudge",
																"mission_text_text_wh3_dlc29_complete_single_legendary_grudge",
																1,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_dwf_oathgold_trader",
											"wh3_dlc29_bundle_ie_victory_objective_dwf_workshop_assistant"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_x_legendary_grudges",
																"mission_text_text_wh3_dlc29_complete_x_legendary_grudges",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_complete_n_malakai_legenday_battles_long",
																"mission_text_text_malakai_oath_steel_glory_long_victory",
																7,
																0,
																true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "dwf_oathgold", "mission_text_text_wh3_dlc29_spend_oathgold_for_crafting", "forging_items"),
						},
						payloads = {
							pooled_resource =  {{"dwf_oathgold", "missions", 3000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- CHAOS DWARF -----
				wh3_dlc23_chd_astragoth = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_grn_greenskins"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_astragoth_construct_landmark_short", "mission_text_text_wh3_dlc29_chd_astragoth_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_own_n_seats_in_toz_short",
																"mission_text_text_wh3_dlc29_own_n_seats_in_toz_short",
																10,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_objective_chaos_dwarfs_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_OWN_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_zharr_naggrund"}, 1),
							generate_DESTROY_FACTION_objective({"wh_main_dwf_dwarfs", "wh_main_dwf_karak_kadrin"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_construct_landmark_long", "mission_text_text_wh3_dlc29_chd_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_astragoth_unlock_conclave",
																"mission_text_text_wh3_dlc29_astragoth_unlock_conclave"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("HELLFORGE_CAPS_BULL_CENTAURS", 9, "mission_text_text_wh3_dlc29_chd_astragot_increase_bull_centaur_unit_cap_long"),
						},
						payloads = {
							ancillary = {"wh3_dlc23_anc_armour_lesser_relic_of_skavor",
										"wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
										"wh3_dlc23_anc_weapon_lesser_relic_of_smednir"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc23_chd_legion_of_azgorh = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc15_hef_imrik", "wh3_main_nur_poxmakers_of_nurgle"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_drazhoath_construct_landmarks_short", "mission_text_text_wh3_dlc29_chd_drazhoath_construct_landmarks_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc23_qb_chd_drazhoath_hellshard_amulet"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(10000, "wh3_dlc23_chd_armaments", "mission_text_text_wh3_dlc29_chd_drazhoath_spend_armaments_in_hellforge_short", "wh3_dlc23_chd_hellforge")
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_objective_chaos_dwarfs_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_OWN_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_zharr_naggrund"}, 1),
							generate_DESTROY_FACTION_objective({"wh_main_dwf_dwarfs", "wh_main_dwf_karak_kadrin", "wh_main_grn_greenskins"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_construct_landmark_long", "mission_text_text_wh3_dlc29_chd_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_drazhoath_unlock_toz_tier3_industry",
																"mission_text_text_wh3_dlc29_drazhoath_unlock_toz_tier3_industry"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_perform_n_hellforge_rituals",
																"mission_text_text_wh3_dlc29_perform_n_hellforge_rituals",
																25,
																0,
																true),
						},
						payloads = {
							ancillary = {"wh3_dlc23_anc_armour_lesser_relic_of_skavor",
										"wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
										"wh3_dlc23_anc_weapon_lesser_relic_of_smednir"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc23_chd_zhatan = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_main_cth_the_northern_provinces", "wh3_dlc27_nor_sayl"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_zhatan_construct_landmarks_short", "mission_text_text_wh3_dlc29_chd_zhatan_construct_landmarks_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_zhatan_complete_n_convoys",
																"mission_text_text_wh3_dlc29_zhatan_complete_n_convoys",
																6,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_zhatan_gain_n_labour_short",
																"mission_text_text_wh3_dlc29_zhatan_gain_n_labour",
																15000,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_objective_chaos_dwarfs_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_OWN_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_zharr_naggrund"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_zhatan_gain_n_labour_long",
																"mission_text_text_wh3_dlc29_zhatan_gain_n_labour",
																30000,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chd_construct_landmark_long", "mission_text_text_wh3_dlc29_chd_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_zhatan_unlock_toz_tier3_military",
																"mission_text_text_wh3_dlc29_zhatan_unlock_toz_tier3_military"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("HELLFORGE_CAPS_WARMACHINES", 5, "mission_text_text_wh3_dlc29_zhatan_perform_n_war_machines_hellforge_rituals"),
						},
						payloads = {
							ancillary = {"wh3_dlc23_anc_armour_lesser_relic_of_skavor",
										"wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
										"wh3_dlc23_anc_weapon_lesser_relic_of_smednir"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- BRETONNIA -----
				wh_main_brt_bretonnia = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_marches_of_couronne",
																				"wh3_main_combi_province_coast_of_lyonesse",
																				"wh3_main_combi_province_northern_grey_mountains",
																				"wh3_main_combi_province_gisoreux_gap",
																				"wh3_main_combi_province_forest_of_arden"},
																				5 ),
							generate_DESTROY_FACTION_objective({"wh_main_vmp_mousillon", "wh2_dlc11_vmp_the_barrow_legion"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brt_construct_landmark_short", "mission_text_text_wh3_dlc29_brt_louen_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_short", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_short"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_brt_town_crier",
							scripted_reward = "dummy_wh3_dlc29_brt_louen_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_main_chs_shadow_legion"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_long", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brt_construct_landmark_long", "mission_text_text_wh3_dlc29_brt_louen_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brettonia_win_final_errantry_battle_long_victory", "mission_text_text_mis_activity_win_errantry_war"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_marches_of_couronne",
																				"wh3_main_combi_province_coast_of_lyonesse",
																				"wh3_main_combi_province_northern_grey_mountains",
																				"wh3_main_combi_province_gisoreux_gap",
																				"wh3_main_combi_province_forest_of_arden",
																				"wh3_main_combi_province_river_brienne",
																				"wh3_main_combi_province_bastonne",
																				"wh3_main_combi_province_barrows_of_cuileux",
																				"wh3_main_combi_province_forest_of_chalons",
																				"wh3_main_combi_province_carcassonne"},
																				10 ),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
											"wh3_dlc29_bundle_ie_victory_objective_brt_dedicated_characters_dummy"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_brt_bordeleaux = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_dlc26_kho_skulltaker", "wh2_dlc11_cst_vampire_coast", "wh3_dlc27_sla_masque_of_slaanesh"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_short", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bordeleaux_grail_vow", "mission_text_text_mis_activity_complete_grail_vow_alberic"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_brt_town_crier",
							ancillary = "wh3_dlc29_anc_follower_brt_experienced_sailor",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_bordeleaux_3_grail_vows",
																"mission_text_text_wh3_dlc29_bordeleaux_3_grail_vows",
																3,
																0,
																true),
							generate_DESTROY_FACTION_objective({"wh2_dlc11_cst_noctilus"}, true),
							generate_OWN_N_PORTS_INCLUDING_objective({}, 10),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_long", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brettonia_win_final_errantry_battle_long_victory", "mission_text_text_mis_activity_win_errantry_war"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
											"wh3_dlc29_bundle_ie_victory_objective_brt_dedicated_characters_dummy"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_brt_carcassonne = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_carcassonne_virtue_thoth", "mission_text_text_mis_activity_complete_troth_of_virute_vow_enchantress"),
							generate_DESTROY_FACTION_objective({"wh2_dlc15_grn_broken_axe", "wh2_main_skv_clan_skryre"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brt_construct_landmark_short", "mission_text_text_wh3_dlc29_brt_fay_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_short", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_short"),

						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_brt_town_crier",
							scripted_reward = "dummy_wh3_dlc29_brt_fay_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_carcassonne",
																				"wh3_main_combi_province_forest_of_chalons",
																				"wh3_main_combi_province_barrows_of_cuileux"},
																				3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_carcassonne_complete_n_virtue_thoths",
																"mission_text_text_wh3_dlc29_carcassonne_complete_n_virtue_thoths",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_long", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brettonia_win_final_errantry_battle_long_victory", "mission_text_text_mis_activity_win_errantry_war"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
											"wh3_dlc29_bundle_ie_victory_objective_brt_dedicated_characters_dummy"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc14_brt_chevaliers_de_lyonesse = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_followers_of_nagash", "wh3_dlc29_nag_host_of_nagash"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_short", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc14_vortex_brt_repanse_sword_of_lyonesse_stage_4"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brt_construct_landmark_short", "mission_text_text_wh3_dlc29_brt_repanse_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_brt_town_crier", "wh3_dlc29_bundle_ie_victory_objective_brt_repanse_speed_of_virtue"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_reach_n_chivalry_level_long", "mission_text_text_wh3_dlc29_reach_n_chivalry_level_long"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_coast_of_araby",
																				"wh3_main_combi_province_atalan_mountains",
																				"wh3_main_combi_province_land_of_assassins",
																				"wh3_main_combi_province_great_desert_of_araby",
																				"wh3_main_combi_province_the_cracked_land",
																				"wh3_main_combi_province_great_mortis_delta",
																				"wh3_main_combi_province_land_of_the_dervishes",
																				"wh3_main_combi_province_shifting_sands",
																				"wh3_main_combi_province_land_of_the_dead"},
																				9),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_brettonia_win_final_errantry_battle_long_victory", "mission_text_text_mis_activity_win_errantry_war"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
											"wh3_dlc29_bundle_ie_victory_objective_brt_dedicated_characters_dummy"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- WOOD ELF -----
				wh_dlc05_wef_wood_elves = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_short", "mission_text_text_wh3_dlc29_wef_perfrom_2_rituals_of_rebirth"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_argwylon",
																				"wh3_main_combi_province_wydrioth",
																				"wh3_main_combi_province_yn_edri_eternos",
																				"wh3_main_combi_province_talsyn",
																				"wh3_main_combi_province_torgovann"},
																				5),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wef_worldroots_athel_loren", 300, false, "mission_text_text_wh3_dlc29_wef_have_at_least_n_oak_of_ages_health"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_raze_n_settlements",
																"mission_text_text_wh3_dlc29_wef_raze_n_settlements",
																15,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_wef_forest_health_boost",
							scripted_reward = "dummy_wh3_dlc29_wef_orion_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_orion_fill_all_offices_with_rank_15_characters",
																"mission_text_text_wh3_dlc29_wef_fill_all_offices_with_rank_15_characters",
																6,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_long", "mission_text_text_wh3_dlc29_wef_perfrom_7_rituals_of_rebirth"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_oak_of_ages_rebirth", "mission_text_text_wh3_dlc29_wef_perform_ritual_of_rebirth_atel_loren_long"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc05_qb_wef_grand_defense_of_the_oak"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_bundle_ie_victory_objective_wef_forest_builder"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_dlc05_wef_argwylon = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_durthu_upgrade_n_forest_spirits_with_aspects",
																"mission_text_text_wh3_dlc29_wef_durthu_upgrade_n_forest_spirits_with_aspects",
																15,
																0,
																true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wef_worldroots_athel_loren", 300, false, "mission_text_text_wh3_dlc29_wef_have_at_least_n_oak_of_ages_health"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_short", "mission_text_text_wh3_dlc29_wef_perfrom_2_rituals_of_rebirth"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_argwylon",
																				"wh3_main_combi_province_wydrioth",
																				"wh3_main_combi_province_yn_edri_eternos",
																				"wh3_main_combi_province_talsyn",
																				"wh3_main_combi_province_torgovann"},
																				5),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_wef_forest_health_boost",
							scripted_reward = "dummy_wh3_dlc29_wef_durthu_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_durthu_fill_all_offices_with_rank_15_characters",
																"mission_text_text_wh3_dlc29_wef_fill_all_durthu_offices_with_rank_15_characters",
																4,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_long", "mission_text_text_wh3_dlc29_wef_perfrom_7_rituals_of_rebirth"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_oak_of_ages_rebirth", "mission_text_text_wh3_dlc29_wef_perform_ritual_of_rebirth_atel_loren_long"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc05_qb_wef_grand_defense_of_the_oak"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_bundle_ie_victory_objective_wef_forest_builder"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc16_wef_sisters_of_twilight = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc17_bst_taurox"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_short", "mission_text_text_wh3_dlc29_wef_perfrom_2_rituals_of_rebirth"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(20, "wef_forge_daiths_favour", nil, "forging_items"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_construct_landmark_short", "mission_text_text_wh3_dlc29_wef_sisters_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_wef_forest_health_boost",
							scripted_reward = "dummy_wh3_dlc29_wef_sisters_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_long", "mission_text_text_wh3_dlc29_wef_perfrom_7_rituals_of_rebirth"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_oak_of_ages_rebirth", "mission_text_text_wh3_dlc29_wef_perform_ritual_of_rebirth_atel_loren_long"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc05_qb_wef_grand_defense_of_the_oak"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(60, "wef_forge_daiths_favour", nil, "forging_items"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_argwylon",
																				"wh3_main_combi_province_wydrioth",
																				"wh3_main_combi_province_yn_edri_eternos",
																				"wh3_main_combi_province_talsyn",
																				"wh3_main_combi_province_torgovann"},
																				5),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_bundle_ie_victory_objective_wef_forest_builder"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc16_wef_drycha = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_emp_ostermark", "wh_main_emp_talabecland"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_rituals_of_rebirth_short", "mission_text_text_wh3_dlc29_wef_perfrom_2_rituals_of_rebirth"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_durthu_upgrade_n_forest_spirits_with_aspects",
																"mission_text_text_wh3_dlc29_wef_durthu_upgrade_n_forest_spirits_with_aspects",
																15,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_drycha_unlock_coeddil", "mission_text_text_wh3_dlc29_wef_drycha_unlock_coeddil"),
							generate_RECRUIT_N_UNITS_FROM_objective({	"wh2_dlc16_wef_mon_giant_spiders_0",
																		"wh3_main_monster_feral_bears",
																		"wh2_dlc16_wef_mon_wolves_0",
																		"wh2_dlc16_wef_mon_cave_bats",
																		"wh2_dlc16_wef_inf_malicious_dryads_0",
																		"wh2_dlc16_wef_mon_hawks_0",
																		"wh2_dlc16_wef_mon_feral_manticore",},
																		7, false, "mission_text_text_wh3_dlc29_wef_drycha_recruit_n_wild_spirits_short", true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_construct_landmark_short", "mission_text_text_wh3_dlc29_wef_drycha_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_wef_forest_health_boost", "wh3_dlc29_bundle_ie_victory_objective_wef_forest_wild_spirits_rank"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_argwylon",
																				"wh3_main_combi_province_wydrioth",
																				"wh3_main_combi_province_yn_edri_eternos",
																				"wh3_main_combi_province_talsyn",
																				"wh3_main_combi_province_torgovann"},
																				5),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_wef_perform_oak_of_ages_rebirth", "mission_text_text_wh3_dlc29_wef_perform_ritual_of_rebirth_atel_loren_long"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc05_qb_wef_grand_defense_of_the_oak"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_bundle_ie_victory_objective_wef_forest_builder"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- UNDEAD LEGIONS -----
				wh3_dlc29_nag_host_of_nagash = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc09_tmb_khemri", "wh3_main_emp_cult_of_sigmar"}, true),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("NAGASH_MORTARCH_LORDS", 2, "mission_text_text_wh3_dlc29_nagash_unlock_mortarchs_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nag_build_landmark_short", "mission_text_text_wh3_dlc29_nag_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nag_black_pyramid_sigils_short", "mission_text_text_wh3_dlc29_nag_black_pyramid_sigils", 50, 0),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nag_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nag_build_landmark_long", "mission_text_text_wh3_dlc29_nag_build_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nag_build_nagashizzar_landmark_long", "mission_text_text_wh3_dlc29_nag_build_nagashizzar_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nagash_collect_n_books", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 6, 0, true),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("NAGASH_MORTARCH_LORDS", 6, "mission_text_text_wh3_dlc29_nagash_unlock_mortarchs_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nag_black_pyramid_sigils_long", "mission_text_text_wh3_dlc29_nag_black_pyramid_sigils", 150, 0),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_nag_final_battle"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nag_long",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- SKAVEN -----
				wh2_main_skv_clan_mors = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_grn_crooked_moon", "wh_main_dwf_karak_izor"}, true),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_karak_eight_peaks"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_queek_construct_landmark_short", "mission_text_text_wh3_dlc29_skv_queek_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats", "wh3_dlc29_bundle_ie_victory_objective_skv_queek_new_empire"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_queek_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_queek_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_kill_n_legendary_lords_long",
																"mission_text_text_wh3_dlc29_skv_kill_n_legendary_lords_long",
																13,
																0,
																true),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_skv_clan_pestilens = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_itza", "wh2_main_lzd_xlanhuapec", "wh2_main_lzd_tlaxtlan", "wh2_dlc12_lzd_cult_of_sotek"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_skrolk_construct_landmark_short", "mission_text_text_wh3_dlc29_skv_skrolk_construct_landmark_short"),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(1, "wh2_main_skv_clan_pestilens", "wh2_dlc14_under_empire_annexation_plague_cauldron_2", nil, "mission_text_text_wh3_dlc29_skv_construct_in_under_empire_single"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_skv_cloak_of_rats", "wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_hexoatl"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_skrolk_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_skrolk_construct_landmark_long"),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(3, "wh2_main_skv_clan_pestilens", "wh2_dlc14_under_empire_annexation_plague_cauldron_2", nil, "mission_text_text_wh3_dlc29_skv_construct_in_under_empire_multiple"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc09_skv_clan_rictus = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc15_hef_imrik", "wh3_dlc29_vmp_neferata"}, true),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_nagashizzar", "wh3_main_combi_region_zharr_naggrund"}, 1),
							generate_KILL_X_ENTITIES_BY_objective(2800, "wh3_dlc29_skv_stormvermin", "mission_text_text_wh3_dlc29_skv_control_n_ranked_stormvermins_short", true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats",
							ancillary = "wh3_dlc29_anc_follower_stormvermin_commander",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_dlc23_chd_legion_of_azgorh", "wh3_dlc23_chd_conclave"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
							generate_KILL_X_ENTITIES_BY_objective(8000, "wh3_dlc29_skv_stormvermin", "mission_text_text_wh3_dlc29_skv_control_n_ranked_stormvermins_short", true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_tretch_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_tretch_construct_landmark_long"),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_skv_clan_skryre = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_brt_bretonnia", "wh_main_brt_carcassonne"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_forbidden_workshop_upgrade_short", "mission_text_text_mis_activity_workshop_rank_achieved"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_ikit_construct_landmark_short", "mission_text_text_wh3_dlc29_skv_ikit_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh2_main_skv_clan_skryre", {"wh2_dlc12_under_empire_annexation_doomsday_2"}, nil, "mission_text_text_wh3_dlc29_skv_construct_in_under_empire_single"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_skv_doomrocket_cap", "wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats"},
							pooled_resource = {
								{"skv_nuke", "workshop_production", 2},
								{"skv_reactor_core", "workshop_upgrade", 3}
							},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_forbidden_workshop_upgrade_long", "mission_text_text_mis_activity_workshop_last_rank_achieved"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_ikit_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_ikit_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_ikit_construct_doomspheres_long",
																"mission_text_text_wh3_dlc29_skv_construct_doomsphere_in_under_empire_multiple",
																3,
																0,
																true),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_skv_clan_eshin = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc11_def_the_blessed_dread", "wh3_main_cth_the_northern_provinces"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_eshin_reach_revered_reputation_with_one_clan_short",
																"mission_text_text_wh3_dlc29_skv_eshin_reach_revered_reputation_with_one_clan_short"),
							generate_CAPTURE_REGIONS_objective(region_key_list_from_region_group("wh3_dlc29_cathay_gates"), 2, nil, nil, nil, "mission_text_text_wh3_dlc29_skv_snikch_occupy_cathay_gates_short"),							
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																2,
																0,
																true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_skv_faster_scheming", "wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_snikch_perform_say_so_n_times_long",
																"mission_text_text_wh3_dlc29_skv_snikch_perform_say_so_n_times_long",
																4,
																1,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_eshin_reach_exalted_reputation_with_two_clans_long", "mission_text_text_wh3_dlc29_skv_eshin_reach_exalted_reputation_with_two_clans_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																6,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_snikch_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_snikch_construct_landmark_long"),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_skv_clan_moulder = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_main_ksl_the_great_orthodoxy", "wh3_main_ksl_the_ice_court"}, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "skv_mutagen", "mission_text_text_wh3_dlc29_skv_throt_spend_mutagen", "wh2_dlc16_throt_flesh_lab_mutagen_used_augment"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_throt_purchase_n_lab_upgrades_short",
																"mission_text_text_wh3_dlc29_skv_throt_purchase_n_lab_upgrades_short",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats",
							ancillary = "wh3_dlc29_anc_follower_moulder_leash_holder",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_dlc25_dwf_malakai"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_throt_purchase_n_lab_upgrades_long",
																"mission_text_text_wh3_dlc29_skv_throt_purchase_n_lab_upgrades_long",
																9,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_throt_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_throt_construct_landmark_long"),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc29_skv_clan_scruten = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_dwf_karak_kadrin"}, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(7500, "wh3_dlc29_skv_warpstone", "mission_text_text_wh3_dlc29_skv_spend_warpstone_on_clan_secrets_short", "wh3_dlc29_token_shop"),
							--generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_thanquol_unlock_verminking_short", "mission_text_text_wh3_dlc29_skv_thanquol_unlock_verminking_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_short",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																5,
																0,
																true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_skv_thanquol_death_from_within"),
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_bundle_ie_victory_objective_skv_busy_rats",
								"wh3_dlc29_bundle_ie_victory_objective_skv_thanquol"
							}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_control_n_under_empire_regions_long",
																"mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions",
																13,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_thanquol_construct_landmark_long", "mission_text_text_wh3_dlc29_skv_thanquol_construct_landmark_long"),
							--generate_SCRIPTED_MISSION_objective("wh3_dlc29_skv_unlock_all_clan_secrets_for_single_clan_long", "mission_text_text_wh3_dlc29_skv_unlock_all_clan_secrets_for_single_clan_long"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_skv_thanquol_final_battle"),
							
						},
						payloads = {
							effect_bundle = {
								"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", 
								"wh3_dlc29_bundle_ie_victory_objective_skv_feast",
								"wh3_dlc29_skv_thanquol_long_victory_reward"
							},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- KHORNE -----
				wh3_main_kho_exiles_of_khorne = {
					short = {
						objectives = {
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(15000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_short", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_construct_landmark_short", "mission_text_text_wh3_dlc29_kho_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_win_slaughter_and_carnage_battle_short", "mission_text_text_mis_activity_complete_slaughter_carnage"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																8,
																0,
																true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_skull_collector",
							effect_bundle = "wh3_dlc29_bundle_kho_skull_throne_ritual_cooldown_reduction_reward",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(55000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_long", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_spawn_n_bloodhosts_long",
																"mission_text_text_wh3_dlc29_kho_spawn_n_bloodhosts_long",
																20,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_raze_n_settlements_long",
																"mission_text_text_wh3_dlc29_kho_raze_n_settlements_long",
																50,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_kho_skulls", "events", 2000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc26_kho_skulltaker = {
					short = {
						objectives = {
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(15000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_short", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_skulltaker_empower_skulls_short",
																"mission_text_text_wh3_dlc29_kho_skulltaker_empower_skulls_short",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																8,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_kill_n_lords_in_battle_short",
																"mission_text_text_wh3_dlc29_kho_kill_n_lords_in_battle",
																25,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_champions_essence_bonus",
							ancillary = "wh3_dlc29_anc_follower_skull_collector",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(55000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_long", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_kill_n_lords_in_battle_long",
																"mission_text_text_wh3_dlc29_kho_kill_n_lords_in_battle",
																50,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_skulltaker_empower_skulls_long",
																"mission_text_text_wh3_dlc29_kho_skulltaker_empower_skulls_short",
																8,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_kho_skulls", "events", 2000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc26_kho_arbaal = {
					short = {
						objectives = {
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(15000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_short", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_arbaal_complete_n_perfect_battles_short",
																"mission_text_text_wh3_dlc29_kho_arbaal_complete_n_perfect_battles_short",
																3,
																0,
																true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_arbaal_gain_n_favour_short",
																"mission_text_text_wh3_dlc29_kho_arbaal_gain_n_favour",
																80,
																0,
																true),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_skull_collector", "wh3_dlc29_anc_enchanted_item_blessing_of_khorne"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(55000, "wh3_main_kho_skulls", "mission_text_text_wh3_dlc29_khorne_spend_skulls_on_throne_long", "the_skull_throne"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_arbaal_complete_n_ultimate_battles_long",
																"mission_text_text_wh3_dlc29_kho_arbaal_complete_n_ultimate_battles_long",
																10,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_arbaal_gain_n_favour_long", "mission_text_text_wh3_dlc29_kho_arbaal_gain_n_favour",
																160,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_kho_raze_n_settlements_long",
																"mission_text_text_wh3_dlc29_kho_raze_n_settlements_long",
																50,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_kho_skulls", "events", 2000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- SLAANESH -----
				wh3_main_sla_seducers_of_slaanesh = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_hef_avelorn", "wh2_main_hef_eataine", "wh2_main_hef_yvresse",}, true, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_construct_landmark_short", "mission_text_text_wh3_dlc29_sla_construct_landmark_short"),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_shrine_of_asuryan"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																6,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_vassalize_faction_via_seduction_short",
																"mission_text_text_wh3_dlc29_sla_vassalize_faction_via_seduction_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_sla_nkari_victory_objective_short",
							ancillary = "wh3_dlc29_anc_follower_sla_recruiter",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_construct_n_cult_buildings_long",
																"mission_text_text_wh3_dlc29_sla_build_20_cult_building_long",
																20,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_vassalize_faction_via_seduction_long",
																"mission_text_text_wh3_dlc29_sla_vassalize_n_factions_via_seduction_long",
																5,
																0,
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_eataine",
																				"wh3_main_combi_province_caledor",
																				"wh3_main_combi_province_tiranoc",
																				"wh3_main_combi_province_ellyrion",
																				"wh3_main_combi_province_nagarythe",
																				"wh3_main_combi_province_avelorn",
																				"wh3_main_combi_province_chrace",
																				"wh3_main_combi_province_cothique",
																				"wh3_main_combi_province_saphery",
																				"wh3_main_combi_province_northern_yvresse",
																				"wh3_main_combi_province_southern_yvresse",
																				"wh3_main_combi_province_eagle_gate",
																				"wh3_main_combi_province_griffon_gate",
																				"wh3_main_combi_province_unicorn_gate",
																				"wh3_main_combi_province_phoenix_gate"},
																			15)
						},
						payloads = {
							pooled_resource =  {{"wh3_main_sla_devotees", "events", 1000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc27_sla_the_tormentors = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_dlc13_emp_golden_order",}, true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_dlc27_sla_the_tormentors", {"wh3_dlc27_sla_dec_palace_settlement_4"}, nil, "mission_text_text_wh3_dlc29_sla_build_wing_of_satisfaction_short"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_cathayan_hinterlands",
																				"wh3_main_combi_province_serpent_estuary",
																				"wh3_main_combi_province_the_great_canal",
																				"wh3_main_combi_province_mount_li",
																				"wh3_main_combi_province_nongchang_basin",},
																			4),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_dlc27_sla_decadence"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_sla_dechala_thralls_multiplier",
							ancillary = "wh3_dlc29_anc_follower_sla_recruiter",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_eshin", "wh3_main_cth_the_northern_provinces", "wh3_main_cth_the_western_provinces"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_build_4_pleasure_palaces_long",
									"mission_text_text_wh3_dlc29_sla_build_4_pleasure_palaces_long",
									4,
									0,
									true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_broken_lands_of_tian_li",
																				"wh3_main_combi_province_wastelands_of_jinshen",
																				"wh3_main_combi_province_warpstone_desert",
																				"wh3_main_combi_province_forests_of_the_moon",
																				"wh3_main_combi_province_jade_river_delta",
																				"wh3_main_combi_province_plains_of_xen",
																				"wh3_main_combi_province_imperial_road",
																				"wh3_main_combi_province_lands_of_stone_and_steel",
																				"wh3_main_combi_province_gunpowder_road",
																				"wh3_main_combi_province_ivory_road"},
																			10),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc27_qb_sla_dechala_final_battle"),
						},
						payloads = {
							pooled_resource =  {{"wh3_dlc27_sla_thralls", "other", 1000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc27_sla_masque_of_slaanesh = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc13_emp_the_huntmarshals_expedition", "wh3_dlc24_cth_the_celestial_court",}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_jungles_of_green_mist",
																				"wh3_main_combi_province_the_creeping_jungle",
																				"wh3_main_combi_province_scorpion_coast",},
																			3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_reach_the_highest_tempo_level_with_all_4_dances",
																"mission_text_text_wh3_dlc29_sla_reach_the_highest_tempo_level_with_all_4_dances",
																4,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																6,
																0,
																true),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_sla_recruiter", "wh3_dlc29_anc_follower_sla_frenetic_dancing_troupe"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_hexoatl", "wh2_main_lzd_itza"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns",
																"mission_text_text_wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns_empty_long", 20, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_sla_spawn_n_disciple_armies_long",
																"mission_text_text_wh3_dlc29_sla_spawn_n_disciple_armies_long",
																10,
																0,
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_aymara_swamps",
																				"wh3_main_combi_province_jungles_of_pahualaxa",
																				"wh3_main_combi_province_isthmus_of_lustria",
																				"wh3_main_combi_province_the_isthmus_coast",},
																			4),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_sla_devotees", "events", 1000}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- NURGLE -----
				wh3_main_nur_poxmakers_of_nurgle = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_construct_landmark_short", "mission_text_text_wh3_dlc29_nur_construct_landmark_short"),
							generate_DESTROY_FACTION_objective({"wh3_main_vmp_caravan_of_blue_roses", "wh2_dlc15_hef_imrik", "wh3_main_ogr_goldtooth"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_perfrom_n_plagues_with_at_least_1_blessed_symptom_short",
																"mission_text_text_wh3_dlc29_nur_perfrom_n_plagues_with_at_least_1_blessed_symptom_short",
																7,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																7,
																0,
																true),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_nur_plague_caretaker", "wh3_dlc29_anc_enchanted_item_nur_plaguefather_item"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_spread_plague_n_times_long",
																"mission_text_text_wh3_dlc29_nur_spread_plague_n_times_long",
																100,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_have_n_lord_become_exalted_unclean_long",
																"mission_text_text_wh3_dlc29_nur_have_n_lord_become_exalted_unclean_long",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_perfrom_n_plagues_with_at_all_blessed_symptoms_long",
																"mission_text_text_wh3_dlc29_nur_perfrom_n_plagues_with_at_all_blessed_symptoms_long",
																7,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_complete_n_cycles_of_advances_military_chains_long",
																"mission_text_text_wh3_dlc29_nur_complete_n_cycles_of_advances_military_chains_long",
																7,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nur_units_recruit_health",
							pooled_resource = {{"wh3_main_nur_infections", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc25_nur_tamurkhan = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_dlc20_chs_kholek", "wh_main_grn_greenskins"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_tamurkhan_chieftaion_devoted_battle_short",
																"mission_text_text_tamurkhan_chieftain_devoted_deference_short",
																3,
																0,
																true),
							generate_RECRUIT_N_UNITS_FROM_objective({	"wh3_dlc25_nur_chieftain_cav_chaos_chariot_mnur",
																		"wh3_dlc25_nur_chieftain_cav_rot_knights",
																		"wh3_dlc25_nur_chieftain_mon_toad_dragon",
																		"wh3_dlc25_nur_chieftain_inf_aspiring_champions_0",
																		"wh3_dlc25_nur_chieftain_art_hellcannon",
																		"wh3_dlc25_nur_chieftain_mon_dragon_ogre_shaggoth",
																		"wh3_dlc25_nur_chieftain_mon_fimir_0",
																		"wh3_dlc25_nur_chieftain_mon_fimir_1",
																		"wh3_dlc25_nur_chieftain_mon_frost_wyrm_0",
																		"wh3_dlc25_nur_chieftain_mon_war_mammoth_1",
																		"wh3_dlc25_nur_chieftain_mon_war_mammoth_0",
																		"wh3_dlc25_nur_chieftain_mon_skinwolves_0",
																		"wh3_dlc25_nur_chieftain_mon_ghorgon",
																		"wh3_dlc25_nur_chieftain_inf_cygor_0",
																		"wh3_dlc25_nur_chieftain_inf_centigors_1",
																		"wh3_dlc25_nur_chieftain_veh_dreadquake_mortar",
																		"wh3_dlc25_nur_chieftain_inf_infernal_guard_fireglaives",
																		"wh3_dlc25_nur_chieftain_inf_chaos_dwarf_blunderbusses",},
																	7, false, "mission_text_text_wh3_dlc29_nur_tamurkhan_recruit_chieftain_units_short"),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_nur_plague_caretaker", "wh3_dlc29_anc_follower_nur_chieftain_trainer"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_nuln"}, 1),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_tamurkhan_chieftaion_devoted_battle_long",
																"mission_text_text_tamurkhan_chieftain_devoted_deference_short",
																6,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_tamurkhan_recruit_all_chieftain_units_long",
																"mission_text_text_wh3_dlc29_nur_tamurkhan_recruit_all_chieftain_units_long",
																18,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nur_units_recruit_health",
							pooled_resource = {{"wh3_main_nur_infections", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc25_nur_epidemius = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_hag_graef", "wh3_main_ksl_ursun_revivalists", "wh3_dlc25_dwf_malakai"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_noisome_tumour", "wh3_main_combi_province_plain_of_illusions", "wh3_main_combi_province_the_eternal_lagoon"}, 3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																7,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_epidemius_reach_surging_tally_of_pestilence_short",
																"mission_text_text_wh3_dlc29_nur_epidemius_reach_surging_tally_of_pestilence_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_nur_plague_caretaker",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nur_epidemius_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_main_ksl_the_ice_court", "wh3_main_ksl_the_great_orthodoxy"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_spread_plague_n_times_long",
																"mission_text_text_wh3_dlc29_nur_spread_plague_n_times_long",
																100,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nur_epidemius_reach_epidemical_tally_of_pestilence_long",
																"mission_text_text_wh3_dlc29_nur_epidemius_reach_epidemical_tally_of_pestilence_long"),
							generate_KILL_X_ENTITIES_BY_objective(75000, "nur_plaguebearers", "mission_text_text_wh3_dlc29_nur_kill_n_entities_with_plaguebearer_long")
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nur_units_recruit_health",
							pooled_resource = {{"wh3_main_nur_infections", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- TZEENTCH -----
				wh3_main_tze_oracles_of_tzeentch = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_hef_order_of_loremasters", "wh2_dlc17_lzd_oxyotl"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_the_southern_wastes",
																				"wh3_main_combi_province_the_ice_fire_plains",
																				"wh3_main_combi_province_the_abyssal_glacier",
																				"wh3_main_combi_province_the_daemonium_hills"},
																				4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_perform_all_unholy_manifestations_short",
																"mission_text_text_wh3_dlc29_kho_perform_all_unholy_manifestations_short",
																9,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_perform_n_cotw_actions_short",
																"mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions",
																20,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_recruit_cult_magus_short",
																"mission_text_text_wh3_dlc29_tze_recruit_cult_magus_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_tze_librarian",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_tze_well_stocked_library",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh_main_grn_orcs_of_the_bloody_hand", "wh2_main_lzd_tlaqua"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_construct_n_cult_buildings_long",
																"mission_text_text_wh3_dlc29_sla_build_20_cult_building_long",
																20,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_perform_n_cotw_actions_long",
																"mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions",
																40,
																0,
																true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_the_southern_wastes",
																				"wh3_main_combi_province_the_ice_fire_plains",
																				"wh3_main_combi_province_the_abyssal_glacier",
																				"wh3_main_combi_province_the_daemonium_hills",
																				"wh3_main_combi_province_dawns_landing",
																				"wh3_main_combi_province_southern_jungles",
																				"wh3_main_combi_province_central_jungles",
																				"wh3_main_combi_province_western_jungles",
																				"wh3_main_combi_province_heart_of_the_jungle"},
																				9),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_main_tze_grimoires", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc24_tze_the_deceivers = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_changeling_win_grand_schemes_short",
																"mission_text_text_wh3_dlc29_tze_changeling_win_grand_schemes",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_changeling_unlock_legendary_transforms_short",
																"mission_text_text_wh3_dlc29_tze_changeling_unlock_legendary_transforms",
																5,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_perform_n_cotw_actions_short",
																"mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions",
																10,
																0,
																true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(3, "wh3_dlc24_tze_the_deceivers", {	"wh3_dlc24_tze_the_changeling_raise_army_symbiotic_2",
																											"wh3_dlc24_tze_the_changeling_raise_army_parasitic_2",
																											"wh3_dlc24_tze_the_changeling_plunder_2"}),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_tze_librarian",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_tze_logistics_expert_dummy",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_changeling_win_grand_schemes_long",
																"mission_text_text_wh3_dlc29_tze_changeling_win_grand_schemes",
																5,
																0,
																true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ie"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_changeling_unlock_legendary_transforms_long",
																"mission_text_text_wh3_dlc29_tze_changeling_unlock_legendary_transforms",
																15,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tze_perform_n_cotw_actions_long",
																"mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions",
																20,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_main_tze_grimoires", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- DAEMONS OF CHAOS -----
				wh3_main_dae_daemon_prince = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_hag_graef", "wh3_dlc25_nur_epidemius"}, true),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({	"wh3_main_ritual_dae_ascend_khorne",
																			"wh3_main_ritual_dae_ascend_nurgle",
																			"wh3_main_ritual_dae_ascend_slaanesh",
																			"wh3_main_ritual_dae_ascend_tzeentch",
																			"wh3_main_ritual_dae_ascend_undivided"},
																			1,
																			true,
																			"mission_text_text_wh3_dlc29_dae_dedicate_to_any_chaos_god_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dae_equip_daemonic_gifts_of_the_same_god_in_every_slot_short", "mission_text_text_wh3_dlc29_dae_equip_daemonic_gifts_of_the_same_god_in_every_slot_short"),
						},
						payloads = {
							scripted_reward = {"dummy_wh3_dlc29_dae_victory_objective_grant_glory_short", "dummy_wh3_dlc29_dae_victory_objective_grant_lord_short"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_dae_reach_maximum_glory_with_chaos_god_long", "mission_text_text_wh3_dlc29_dae_reach_maximum_glory_with_chaos_god_long"),
 							generate_CAPTURE_REGIONS_objective(region_key_list_from_region_group("wh3_dlc29_kislev_capitals"), 3, nil, nil, nil, "mission_text_text_wh3_dlc29_deamon_prince_occupy_kislev_long_victory"),        							
 							generate_DESTROY_FACTION_objective({"wh_main_chs_chaos"}, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- KISLEV -----
				wh3_main_ksl_the_ice_court = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_moulder", "wh3_dlc20_chs_azazel"}, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_main_ksl_support_level_ice_court", 10),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_katarina_construct_landmark_short", "mission_text_text_wh3_dlc29_ksl_katarina_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_recruit_n_frost_maidens_short",
																"mission_text_text_wh3_dlc29_ksl_recruit_n_frost_maidens_short",
																2,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_recruit_n_ice_witch_short",
																"mission_text_text_wh3_dlc29_ksl_recruit_n_ice_witch_short",
																2,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ksl_ice_court_trainer",
							ancillary = "wh3_dlc29_anc_follower_ksl_kislevite_priest",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_troll_country",
																				"wh3_main_combi_province_the_cursed_city",
																				"wh3_main_combi_province_river_urskoy",
																				"wh3_main_combi_province_eastern_oblast",
																				"wh3_main_combi_province_southern_oblast",
																				"wh3_main_combi_province_black_blood_pass"},
																				6),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_katarin_construct_landmarks_long", "mission_text_text_wh3_dlc29_ksl_katarina_construct_landmarks_long"),
							generate_DESTROY_FACTION_objective({"wh3_dlc20_chs_festus", "wh3_main_dae_daemon_prince", "wh_main_chs_chaos"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_have_n_atamans_assigned_long",
																"mission_text_text_wh3_dlc29_ksl_have_n_atamans_assigned_long",
																3,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_ksl_support_boon_ice_court", "other", 3},
												{"wh3_main_ksl_support_boon_orthodoxy", "other", 1}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_ksl_the_great_orthodoxy = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_moulder", "wh3_dlc20_chs_azazel"}, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_main_ksl_support_level_orthodoxy", 10),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_kostaltyn_construct_landmarks_short", "mission_text_text_wh3_dlc29_ksl_kostaltyn_construct_landmark1_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_get_n_patriarchs_to_rank_10_short",
																"mission_text_text_wh3_dlc29_ksl_get_n_patriarchs_to_rank_10_short",
																3,
																0,
																true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ksl_orthodoxy_support",
							ancillary = "wh3_dlc29_anc_follower_ksl_kislevite_priest",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_troll_country",
																				"wh3_main_combi_province_the_cursed_city",
																				"wh3_main_combi_province_river_urskoy",
																				"wh3_main_combi_province_eastern_oblast",
																				"wh3_main_combi_province_southern_oblast",
																				"wh3_main_combi_province_black_blood_pass"},
																				6),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_kostaltyn_construct_landmarks_long", "mission_text_text_wh3_dlc29_ksl_kostaltyn_construct_landmarks_long"),
							generate_DESTROY_FACTION_objective({"wh3_dlc20_chs_festus", "wh3_main_dae_daemon_prince", "wh_main_chs_chaos"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_have_n_atamans_assigned_long",
																"mission_text_text_wh3_dlc29_ksl_have_n_atamans_assigned_long",
																3,
																0,
																true),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_ksl_support_boon_ice_court", "other", 1},
												{"wh3_main_ksl_support_boon_orthodoxy", "other", 3}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_ksl_ursun_revivalists = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_chs_chaos", "wh3_main_kho_bloody_sword"}, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_main_ksl_support_level_ice_court", 5),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_main_ksl_support_level_orthodoxy", 5),
							generate_KILL_X_ENTITIES_BY_objective(2800, "wh3_main_ksl_war_bears", "mission_text_text_wh3_dlc29_ksl_kill_n_entities_with_war_bears", true),
							generate_CAPTURE_REGIONS_objective(region_key_list_from_region_group("cai_region_hint_area_chaos_wastes"), 10, nil, nil, nil, "mission_text_text_wh3_dlc29_ksl_ursun_occupy_chaos_wastes_settlements_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_ksl_boris_victory_objective_short",
							ancillary = "wh3_dlc29_anc_follower_ksl_kislevite_priest",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_main_dae_daemon_prince", "wh_dlc08_nor_wintertooth", "wh3_dlc20_chs_kholek"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_have_n_atamans_assigned_long",
																"mission_text_text_wh3_dlc29_ksl_have_n_atamans_assigned_long",
																3,
																0,
																true),
							generate_KILL_X_ENTITIES_BY_objective(8000, "wh3_main_ksl_war_bears", "mission_text_text_wh3_dlc29_ksl_kill_n_entities_with_war_bears", true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_ursun_have_0_corruption_in_provinces_long", "mission_text_text_wh3_dlc29_ksl_ursun_have_0_corruption_in_provinces_long"),
							generate_CAPTURE_REGIONS_objective(region_key_list_from_region_group("cai_region_hint_area_chaos_wastes"), 20, nil, nil, nil, "mission_text_text_wh3_dlc29_ksl_ursun_occupy_chaos_wastes_settlements_long"),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_ksl_support_boon_ice_court", "other", 2},
												{"wh3_main_ksl_support_boon_orthodoxy", "other", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc24_ksl_daughters_of_the_forest = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes_short",
																"mission_text_text_wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_unlock_n_witch_hut_ingridients_short",
																"mission_text_text_wh3_dlc29_ksl_dotf_unlock_n_witch_hut_ingridients_short",
																9,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_get_n_hag_witches_to_rank_10_short",
																"mission_text_text_wh3_dlc29_ksl_dotf_get_n_hag_witches_to_rank_10_short",
																3,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_ostankya_construct_landmark_short", "mission_text_text_wh3_dlc29_ksl_ostankya_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ksl_stolen_from_the_woods", "wh3_dlc29_bundle_ksl_animal_den_construction_time"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_unlock_all_witch_hut_ingridients_long",
																"mission_text_text_wh3_dlc29_ksl_dotf_unlock_all_witch_hut_ingridients_long",
																18,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_create_n_incantations_long",
																"mission_text_text_wh3_dlc29_ksl_dotf_create_n_incantations_long",
																20,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes_long",
																"mission_text_text_wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes",
																5,
																0,
																true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ksl_dotf_perform_the_final_hex_malediction_long",
																"mission_text_text_wh3_dlc29_ksl_dotf_perform_the_final_hex_malediction_long"),
						},
						payloads = {
							pooled_resource =  {{"wh3_main_ksl_support_boon_ice_court", "other", 2},
												{"wh3_main_ksl_support_boon_orthodoxy", "other", 2}},
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- WARRIORS OF CHAOS -----
				wh_main_chs_chaos = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_six_treasures_of_chaos_set_short", "mission_text_text_wh3_dlc29_main_chs_acquire_six_treasures_of_chaos_set_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_wh_main_anc_mount_chs_archaon_dorghar", "ancillaries_onscreen_name_wh_main_anc_mount_chs_archaon_dorghar"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_wh_main_anc_armour_the_armour_of_morkar", "ancillaries_onscreen_name_wh_main_anc_armour_the_armour_of_morkar"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_wh_main_anc_talisman_the_eye_of_sheerian", "ancillaries_onscreen_name_wh_main_anc_talisman_the_eye_of_sheerian"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_wh_main_anc_weapon_the_slayer_of_kings", "ancillaries_onscreen_name_wh_main_anc_weapon_the_slayer_of_kings"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_acquire_wh_main_anc_enchanted_item_the_crown_of_domination", "ancillaries_onscreen_name_wh_main_anc_enchanted_item_the_crown_of_domination"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_parent_objective_short", "mission_text_text_wh3_dlc29_main_chs_parent_objective_short"),
							generate_OWN_N_UNITS_objective(80),
							generate_ACHIEVE_CHARACTER_RANK_objective(1, 40, nil, "wh_main_chs_archaon", true, "434568115"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_control_n_dark_fortresses_short", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_subjugate_each_chaos_god_faction_short",
																"mission_text_text_wh3_dlc29_main_chs_subjugate_each_chaos_god_faction_short",
																4,
																0,
																true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_archaon_units_victory_objective_short",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_chs_archaon_unit_cap"
						},
					},
					long = {
						-- Long Victory Objectives are modified after reaching short Victory in wh3_dlc29_archaon_narrative.lua
						objectives = archaon_long_victory_default_objectives_list,
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc29_chs_host_of_the_triplets = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_glottkin_control_n_dark_fortresses_short", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 4, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_chs_glottkin_final_battle"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_glottkin_build_garden_of_nurgle_in_altdorf_and_middenheim_short", "mission_text_text_wh3_dlc29_chs_glottkin_build_garden_of_nurgle_in_altdorf_and_middenheim_short"),
							generate_KILL_X_ENTITIES_BY_objective(3000, "wh3_dlc29_nur_putrid_blightkings", "mission_text_text_wh3_dlc29_chs_kill_n_entities_with_putrid_blight_knigs"),
							generate_SCRIPTED_MISSION_objective("maggots_lords_chain_completed", "mission_text_text_wh3_dlc29_mis_activity_complete_maggots_lords_chain"),
						},
						payloads = {
							ancillary = "wh3_dlc29_chs_anc_weapon_flail_of_a_thousand_coughs",
							effect_bundle = "wh3_dlc29_bundle_chs_glottkin_short_victory"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective(province_key_list_from_region_group("cai_region_hint_area_empire"), 22, "mission_text_text_wh3_dlc29_chs_glottkin_control_all_empire_provinces_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_glottkin_marks_of_nurgle_long", "mission_text_text_wh3_dlc29_chs_glottkin_marks_of_nurgle_long", 4, 0, true),
							generate_KILL_X_ENTITIES_BY_objective(7000, "wh3_dlc29_nur_putrid_blightkings", "mission_text_text_wh3_dlc29_chs_kill_n_entities_with_putrid_blight_knigs"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", "mission_text_text_wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", 7, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_kholek = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_cp1_cth_tiger_warriors", "wh3_main_cth_the_northern_provinces"}, true, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_kholek_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_kholek_warband_upgrade_units", 3, 0, true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_dlc20_chs_kholek", {"wh3_dlc20_settlement_woc_dark_fortress_4"}, nil, "mission_text_text_wh3_dlc29_chs_upgrade_dark_fortress_to_max_tier"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_kholek_equip_gifts_of_gods_short", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods", 4, 0, true),
							generate_KILL_X_ENTITIES_BY_objective(3000, "wh3_dlc29_woc_dragon_ogres", "mission_text_text_wh3_dlc29_chs_kholek_kill_n_entities_with_dragon_ogres", true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_todtheim"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_chs_kholek_unit_cap",
							scripted_reward = "dummy_wh3_dlc29_chs_kholek_units_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_wei_jin", "wh3_main_combi_region_nan_gau", "wh3_main_combi_region_shang_yang"}, 3, "mission_text_text_wh3_dlc29_chs_own_dark_fortresses_in_cathay"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_kholek_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_subjugate_factions_long", "mission_text_text_wh3_dlc29_chs_subjugate_factions", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_kholek_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_kholek_warband_upgrade_units", 10, 0, true),
							generate_KILL_X_ENTITIES_BY_objective(6000, "wh3_dlc29_woc_dragon_ogres", "mission_text_text_wh3_dlc29_chs_kholek_kill_n_entities_with_dragon_ogres", true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_kholek_equip_gifts_of_gods_long", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods_of_every_god", 4, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_sigvald = {
					short = {
						objectives = {
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_sliverslash"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_seduce_units_short", "mission_text_text_wh3_dlc29_chs_sigvald_seduce_units", 20, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_sacrifice_souls_short", "mission_text_text_wh3_dlc29_chs_sigvald_sacrifice_souls_to_slaanesh", 5000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_vassalize_factions_short", "mission_text_text_wh3_dlc29_chs_sigvald_vassalize_factions", 2, 0, true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_dlc20_chs_sigvald", {"wh3_dlc20_settlement_woc_dark_fortress_4"}, nil, "mission_text_text_wh3_dlc29_chs_upgrade_dark_fortress_to_max_tier"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_azazel_sigvald_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_sacrifice_souls_long", "mission_text_text_wh3_dlc29_chs_sigvald_sacrifice_souls_to_slaanesh", 15000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_seduce_units_long", "mission_text_text_wh3_dlc29_chs_sigvald_seduce_units", 50, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_sigvald_vassalize_factions_long", "mission_text_text_wh3_dlc29_chs_sigvald_vassalize_factions", 4, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_chs_shadow_legion = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_dlc29_chs_host_of_the_triplets", "wh3_dlc20_chs_azazel"}, true, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_create_daemon_prince_short", "mission_text_text_wh3_dlc29_chs_belakor_create_daemon_prince_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_equip_gifts_of_gods_short", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_kholek_warband_upgrade_units", 3, 0, true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_main_chs_shadow_legion", {"wh3_dlc20_settlement_woc_dark_fortress_4"}, nil, "mission_text_text_wh3_dlc29_chs_upgrade_dark_fortress_to_max_tier"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_chs_belakor"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_create_daemon_prince_long", "mission_text_text_wh3_dlc29_chs_belakor_create_daemon_prince_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_kholek_warband_upgrade_units", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_belakor_equip_gifts_of_gods_all_slots_long", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_god_all_slots", 11, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_festus = {
					short = {
						objectives = {
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_middenheim", "wh3_main_combi_region_altdorf", "wh3_main_combi_region_kislev"}, 3),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_dlc20_chs_festus", {"wh3_dlc20_settlement_woc_dark_fortress_4"}, nil, "mission_text_text_wh3_dlc29_chs_upgrade_dark_fortress_to_max_tier"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_sacrifice_souls_short", "mission_text_text_wh3_dlc29_chs_festus_sacrifice_souls_to_nurgle", 5000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_festus_warband_upgrade_units", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_spread_plagues_short", "mission_text_text_wh3_dlc29_nur_spread_plague_n_times_long", 50, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_festus_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_sacrifice_souls_long", "mission_text_text_wh3_dlc29_chs_festus_sacrifice_souls_to_nurgle", 15000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_create_daemon_prince_long", "mission_text_text_wh3_dlc29_chs_festus_create_daemon_prince_of_nurgle"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_festus_warband_upgrade_units", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_festus_spread_plagues_long", "mission_text_text_wh3_dlc29_nur_spread_plague_n_times_long", 100, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_azazel = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_trollheim_mountains", "wh3_main_combi_province_troll_country", "wh3_main_combi_province_the_cursed_city"}, 3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_construct_dark_fortress_praag_short", "mission_text_text_wh3_dlc29_chs_azazel_construct_dark_fortress_praag"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_vassalize_factions_short", "mission_text_text_wh3_dlc29_chs_azazel_vassalize_factions", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_seduce_units_short", "mission_text_text_wh3_dlc29_chs_sigvald_seduce_units", 20, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_sacrifice_souls_short", "mission_text_text_wh3_dlc29_chs_sigvald_sacrifice_souls_to_slaanesh", 5000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_azazel_warband_upgrade_units", 3, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_azazel_sigvald_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_seduce_units_long", "mission_text_text_wh3_dlc29_chs_sigvald_seduce_units", 50, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_vassalize_factions_long", "mission_text_text_wh3_dlc29_chs_azazel_vassalize_factions", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_create_daemon_prince_long", "mission_text_text_wh3_dlc29_chs_azazel_create_daemon_prince_of_slaanesh"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_sacrifice_souls_long", "mission_text_text_wh3_dlc29_chs_sigvald_sacrifice_souls_to_slaanesh", 15000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_azazel_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_azazel_warband_upgrade_units", 10, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_vilitch = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_red_wastes", "wh3_main_combi_province_eastern_great_bastion", "wh3_main_combi_province_central_great_bastion", "wh3_main_combi_province_western_great_bastion"}, 4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_perform_cotw_actions_short", "mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions", 20, 0, true),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(2, "wh3_dlc20_chs_vilitch", "wh3_dlc20_settlement_woc_dark_fortress_4"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_sacrifice_souls_short", "mission_text_text_wh3_dlc29_chs_vilitch_sacrifice_souls_to_tzeentch", 5000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_vilitch_warband_upgrade_units", 3, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_vilitch_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_perform_cotw_actions_long", "mission_text_text_wh3_dlc29_tze_perform_n_cotw_actions", 40, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_sacrifice_souls_long", "mission_text_text_wh3_dlc29_chs_vilitch_sacrifice_souls_to_tzeentch", 15000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_create_daemon_prince_long", "mission_text_text_wh3_dlc29_chs_vilitch_create_daemon_prince_of_tzeencth"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_vilitch_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_vilitch_warband_upgrade_units", 10, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc20_chs_valkia = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_ironfrost_glacier", "wh3_dlc20_combi_province_frigid_wasteland", "wh3_main_combi_province_the_road_of_skulls"}, 3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_warband_upgrade_units_short", "mission_text_text_wh3_dlc29_chs_valkia_warband_upgrade_units", 3, 0, true),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh3_dlc20_chs_valkia", {"wh3_dlc20_settlement_woc_dark_fortress_4"}, nil, "mission_text_text_wh3_dlc29_chs_upgrade_dark_fortress_to_max_tier"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_sacrifice_souls_short", "mission_text_text_wh3_dlc29_chs_valkia_sacrifice_souls_to_khorne", 5000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_kill_lords_short", "mission_text_text_wh3_dlc29_kho_kill_n_lords_in_battle", 25, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_chs_soul_catcher",
							scripted_reward = "dummy_wh3_dlc29_chs_valkia_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_warband_upgrade_units_long", "mission_text_text_wh3_dlc29_chs_valkia_warband_upgrade_units", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_control_n_dark_fortresses_long", "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_sacrifice_souls_long", "mission_text_text_wh3_dlc29_chs_valkia_sacrifice_souls_to_khorne", 15000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_kill_lords_long", "mission_text_text_wh3_dlc29_kho_kill_n_lords_in_battle", 50, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_valkia_create_daemon_prince_long", "mission_text_text_wh3_dlc29_chs_valkia_create_daemon_prince_of_khorne"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_chs_devolting_a_lord"},
							pooled_resource = {{"wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 10000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- EMPIRE -----
				wh_main_emp_middenland = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc11_vmp_the_barrow_legion", "wh_main_vmp_schwartzhafen", "wh3_dlc20_chs_festus"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_boris_landmark_short", "mission_text_text_wh3_dlc29_construct_boris_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_boris_perform_winter_rites_short", "mission_text_text_wh3_dlc29_emp_boris_perform_winter_rites", 4, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_dlc29_emp_middenland_sacred_flame", 12, true, "mission_text_text_wh3_dlc29_reach_tier_2_sacred_flame_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_emp_boris_todbringer_the_final_duel"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_emp_boris_short",
							ancillary = "wh3_dlc29_anc_follower_boris_brother_of_axe",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_construct_boris_landmark_long", "mission_text_text_wh3_dlc29_construct_boris_landmark_long"),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_dlc29_emp_middenland_sacred_flame", 24, true, "mission_text_text_wh3_dlc29_reach_tier_4_sacred_flame_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_boris_defeat_chaos_armies_in_battle_long", "mission_text_text_wh3_dlc29_emp_boris_defeat_chaos_armies_in_battle_long", 25, 0, true),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("MIDDENLAND_ARMY_RITUALS", 20, "mission_text_text_wh3_dlc29_emp_boris_perform_winter_rituals"),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("emp_imperial_authority_new", 100, false, "mission_text_text_wh3_dlc29_emp_karl_have_max_authority"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc29_emp_fervour", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_emp_empire = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc11_vmp_the_barrow_legion", "wh_main_vmp_schwartzhafen", "wh3_dlc20_chs_festus"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_karl_perform_decrees_short", "mission_text_text_wh3_dlc29_emp_karl_perform_decrees", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_karl_appoint_elector_counts_short", "mission_text_text_wh3_dlc29_emp_karl_appoint_elector_counts_short", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_karl_rankup_units_short", "mission_text_text_wh3_dlc29_emp_karl_rankup_units_short", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_construct_karl_landmark_short", "mission_text_text_wh3_dlc29_emp_construct_karl_landmark_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_black_fire_pass"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_emp_elector_count_recruitment",
							ancillary = "wh3_dlc29_anc_follower_chronicler_of_the_reik",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_reikland",
																				"wh3_main_combi_province_wissenland",
																				"wh3_main_combi_province_solland",
																				"wh3_main_combi_province_averland",
																				"wh3_main_combi_province_stirland",
																				"wh3_main_combi_province_southern_sylvania",
																				"wh3_main_combi_province_talabecland",
																				"wh3_main_combi_province_ostermark",
																				"wh3_main_combi_province_hochland",
																				"wh3_main_combi_province_ostland",
																				"wh3_main_combi_province_the_wasteland",
																				"wh3_main_combi_province_middenland",
																				"wh3_main_combi_province_nordland"}, 13),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("emp_imperial_authority_new", 100, false, "mission_text_text_wh3_dlc29_emp_karl_have_max_authority"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_karl_perform_decrees_long", "mission_text_text_wh3_dlc29_emp_karl_perform_decrees", 9, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_construct_karl_landmark_long", "mission_text_text_wh3_dlc29_emp_construct_karl_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_karl_summon_the_elector_counts_long", "mission_text_text_wh3_dlc29_emp_karl_summon_the_elector_counts_long"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"emp_prestige", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc13_emp_golden_order = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions_short", "mission_text_text_wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions", 12, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_complete_com_single_actions_short", "mission_text_text_wh3_dlc29_emp_gelt_complete_com_single_actions_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_short", "mission_text_text_wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_short", 2, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_battle_of_bloodpine_woods"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_build_landmark_short", "mission_text_text_wh3_dlc29_emp_gelt_build_landmark_short"),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_emp_gelt_lord_victory_objective_short",
							ancillary = "wh3_dlc29_anc_talisman_scholary_aegis",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions_long", "mission_text_text_wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions", 24, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_long", "mission_text_text_wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_long", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_gelt_complete_com_single_actions_long", "mission_text_text_wh3_dlc29_emp_gelt_complete_com_single_actions_long", 5, 0, true),
							
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc25_emp_arcane_essays", "other", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc13_emp_the_huntmarshals_expedition = {
					short = {
						objectives = {
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("emp_progress", 60, false, "mission_text_text_wh3_dlc29_emp_wulfhart_acclaim_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_wulfhart_unlock_all_hunters_short", "mission_text_text_wh3_dlc29_emp_wulfhart_unlock_all_hunters_short", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_wulfhart_receive_supplies_short", "mission_text_text_wh3_dlc29_emp_wulfhart_receive_supplies_short", 5, 0, true),
							generate_DESTROY_FACTION_objective({"wh2_dlc11_cst_vampire_coast", "wh2_main_lzd_itza"}, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_emp_climate_penalties_nulified",
							scripted_reward = "dummy_wh3_dlc29_emp_markus_imperial_supplies_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("emp_progress", 100, false, "mission_text_text_wh3_dlc29_emp_wulfhart_acclaim_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_wulfhart_unlock_all_hunters_stories_long", "mission_text_text_wh3_dlc29_emp_wulfhart_unlock_all_hunters_stories_long", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_wulfhart_reach_hostility_long", "mission_text_text_wh3_dlc29_emp_wulfhart_reach_hostility_long", 5, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							scripted_reward = "dummy_wh3_dlc29_emp_markus_imperial_supplies_victory_objective_long",
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_emp_cult_of_sigmar = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_land_of_the_dervishes", "wh3_main_combi_province_great_desert_of_araby", "wh3_main_combi_province_great_mortis_delta", "wh3_main_combi_province_the_cracked_land"}, 4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_volkmar_construct_landmark_short", "mission_text_text_wh3_dlc29_emp_volkmar_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_short", "mission_text_text_wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_short", 5, 0, true),
							generate_DESTROY_FACTION_objective({"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_followers_of_nagash", "wh3_dlc29_nag_host_of_nagash"}, true),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_emp_volkmar_lord_victory_objective_short",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_emp_elector_count_recruitment",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_long", "mission_text_text_wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_long", 9, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_volkmar_construct_landmark_long", "mission_text_text_wh3_dlc29_emp_volkmar_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_volkmar_rankup_n_warrior_priests_long", "mission_text_text_wh3_dlc29_emp_volkmar_rankup_n_warrior_priests_long", 3, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_emp_wissenland = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_vmp_schwartzhafen", "wh3_dlc20_chs_festus"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_short", "mission_text_text_wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_perform_armory_upgrades_short", "mission_text_text_wh3_dlc29_emp_elspeth_perform_armory_upgrades_short", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_purchase_amethyst_units_short", "mission_text_text_wh3_dlc29_emp_elspeth_purchase_amethyst_units_short", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_construct_landmark_short", "mission_text_text_wh3_dlc29_emp_elspeth_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr_short", "mission_text_text_wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr", 2, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_learned_scavenger",
							scripted_reward = "dummy_wh3_dlc29_emp_elspeth_amethyst_units_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("emp_imperial_authority_new", 100, false, "mission_text_text_wh3_dlc29_emp_karl_have_max_authority"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_rankup_units_long", "mission_text_text_wh3_dlc29_emp_elspeth_rankup_units_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_construct_landmark_long", "mission_text_text_wh3_dlc29_emp_elspeth_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_perform_amethyst_upgrades_long", "mission_text_text_wh3_dlc29_emp_elspeth_perform_amethyst_upgrades_long", 6, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_long", "mission_text_text_wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr_long", "mission_text_text_wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr", 5, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc25_emp_research", "other", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- NORSCA -----
				wh_dlc08_nor_norsca = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_wulfrik_gain_allegiance_short", "mission_text_text_mis_activity_attain_chaos_god_favour"),
							generate_OWN_N_PORTS_INCLUDING_objective({} , 5),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "wh3_dlc27_nor_spoils", "mission_text_text_wh3_dlc29_nor_spend_spoils_on_occupation_and_marauding", {"marauding_activities", "settlements_captured"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_wulfrik_kill_legendary_lords_short", "mission_text_text_wh3_dlc29_skv_kill_n_legendary_lords_long", 5, 0, true),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_nor_scavenger", "wh3_dlc29_anc_follower_nor_loot_mammoth"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_wulfrik_gain_allegiance_long", "mission_text_text_mis_activity_attain_god_favour_4"),
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(20),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(4000, "wh3_dlc27_nor_spoils", "mission_text_text_wh3_dlc29_nor_spend_spoils_on_occupation_and_marauding", {"marauding_activities", "settlements_captured"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_wulfrik_kill_legendary_lords_long", "mission_text_text_wh3_dlc29_skv_kill_n_legendary_lords_long", 10, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc27_nor_spoils", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_dlc08_nor_wintertooth = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_monster_hunts_short", "mission_text_text_wh3_dlc27_throgg_defeat_monsters", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_reach_troll_tier_short", "mission_text_text_wh3_dlc29_nor_throgg_reach_troll_tier_short"),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_khazid_bordkarag"}, 1, "mission_text_text_mis_activity_own_n_regions_1_of_1"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_construct_landmark_short", "mission_text_text_wh3_dlc29_nor_throgg_construct_landmark_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_nor_scavenger",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_nor_throgg_troll_builder",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_become_supreme_hunter_long", "mission_text_text_wh3_dlc29_nor_throgg_become_supreme_hunter_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_capture_troll_dens_long", "mission_text_text_wh3_dlc29_nor_throgg_capture_troll_dens_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_throgg_reach_troll_tier_long", "mission_text_text_wh3_dlc29_nor_throgg_reach_troll_tier_long"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc27_nor_spoils", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc27_nor_sayl = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_sayl_perform_manipulations_short", "mission_text_text_sayl_manipulations_short_victory", 6, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("wh3_dlc27_nor_sayl_dark_ritual", 10, true, "mission_text_text_wh3_dlc29_nor_sayl_reach_binding_tier_dark_ritual_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_sayl_resolve_attention_dilemmas_short", "mission_text_text_wh3_dlc29_nor_sayl_resolve_attention_dilemmas_short", 5, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "wh3_dlc27_nor_spoils", "mission_text_text_wh3_dlc29_nor_spend_spoils_on_occupation_and_marauding", {"marauding_activities", "settlements_captured"}),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc27_qb_nor_sayl_winds_of_magic_hef_fire_metal"),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_follower_nor_scavenger", "wh3_dlc29_anc_enchanted_item_nor_hooded_cloak"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_sayl_perform_manipulations_long", "mission_text_text_sayl_manipulations_long_victory", 12, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(3000, "wh3_dlc27_nor_spoils", "mission_text_text_wh3_dlc29_nor_spend_spoils_on_occupation_and_marauding", {"marauding_activities", "settlements_captured"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_nor_sayl_resolve_attention_dilemmas_long", "mission_text_text_wh3_dlc29_nor_sayl_resolve_attention_dilemmas_long", 2, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc27_qb_nor_sayl_final_battle"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"wh3_dlc27_nor_spoils", "events", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- DARK ELF -----
				wh2_main_def_naggarond = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc17_bst_taurox", "wh2_main_hef_nagarythe", "wh3_dlc20_chs_valkia"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malekith_construct_landmarks_short", "mission_text_text_wh3_dlc29_def_malekith_construct_landmarks_short"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_iron_foothills", "wh3_main_combi_province_the_black_flood", "wh3_main_combi_province_obsidian_peaks"}, 3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malekith_confederate_def_faction_short", "mission_text_text_wh3_dlc29_def_malekith_confederate_def_faction_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							effect_bundle = "wh3_dlc29_bundle_ruthless_expansion",	
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malekith_construct_landmark_long", "mission_text_text_wh3_dlc29_def_malekith_construct_landmark_long"),
							generate_DESTROY_FACTION_objective({"wh2_main_hef_eataine", "wh2_main_hef_avelorn", "wh2_main_hef_yvresse"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({	"wh3_main_combi_province_eataine",
																				"wh3_main_combi_province_caledor",
																				"wh3_main_combi_province_tiranoc",
																				"wh3_main_combi_province_ellyrion",
																				"wh3_main_combi_province_nagarythe",
																				"wh3_main_combi_province_avelorn",
																				"wh3_main_combi_province_chrace",
																				"wh3_main_combi_province_cothique",
																				"wh3_main_combi_province_saphery",
																				"wh3_main_combi_province_northern_yvresse",
																				"wh3_main_combi_province_southern_yvresse",}, 8),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_def_cult_of_pleasure = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_def_har_ganeth"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_construct_landmark_short", "mission_text_text_wh3_dlc29_def_morathi_construct_landmark_short"),
							generate_CONSTRUCT_BUILDINGS_FROM_objective(1, "wh2_main_def_cult_of_pleasure", {"wh2_main_def_pleasure_cult_4"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_rankup_units_short", "mission_text_text_wh3_dlc29_def_morathi_rankup_units_short", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_rankup_heroes_short", "mission_text_text_wh3_dlc29_def_morathi_rankup_heroes_short", 2, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							scripted_reward = "dummy_wh3_dlc29_def_malekith_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_nagarythe"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_rankup_heroes_long", "mission_text_text_wh3_dlc29_def_morathi_rankup_heroes_long", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_construct_landmark_long", "mission_text_text_wh3_dlc29_def_morathi_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_morathi_acquire_sword_of_khaine_long", "mission_text_text_wh3_dlc29_def_morathi_acquire_sword_of_khaine_long"),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_def_har_ganeth = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_construct_landmark1_short", "mission_text_text_wh3_dlc29_def_morathi_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_acquire_sword_of_khaine_short", "mission_text_text_wh3_dlc29_def_morathi_acquire_sword_of_khaine_long"),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh2_main_ritual_def_mathlann"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_rankup_heroes_short", "mission_text_text_wh3_dlc29_def_hellebron_rankup_heroes_short", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_trigger_death_nights_short", "mission_text_text_wh3_dlc29_def_hellebron_trigger_death_nights", 8, 0, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							effect_bundle = "wh3_dlc29_bundle_def_hellebron_death_night_cost",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_main_def_cult_of_pleasure"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_construct_landmark2_long", "mission_text_text_wh3_dlc29_def_hellebron_construct_landmark2_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_rankup_heroes_long", "mission_text_text_wh3_dlc29_def_hellebron_rankup_heroes_long", 5, 0, true),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_ancient_city_of_quintex"}, 1, "mission_text_text_mis_activity_control_n_regions_quintex"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_hellebron_trigger_death_nights_long", "mission_text_text_wh3_dlc29_def_hellebron_trigger_death_nights", 20, 0, true),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc11_def_the_blessed_dread = {
					short = {
						objectives = {
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_beichai", "wh3_main_combi_region_zhanshi", "wh3_main_combi_region_li_zhu", "wh3_main_combi_region_fu_chow", "wh3_main_combi_region_dai_cheng"}, 5, "mission_text_text_occupy_the_following_port_settlements"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_lokhir_black_arks_short", "mission_text_text_wh3_dlc29_def_lokhir_black_arks_short", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_lokhir_construct_landmark2_short", "mission_text_text_wh3_dlc29_def_lokhir_construct_landmark2_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							effect_bundle = "wh3_dlc29_bundle_def_black_arks_growth",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_dlc27_hef_aislinn"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_lokhir_construct_landmarks_long", "mission_text_text_wh3_dlc29_def_lokhir_construct_landmarks_long"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_eastern_colonies"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_lokhir_black_arks_long", "mission_text_text_wh3_dlc29_def_lokhir_black_arks_long", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_lokhir_max_level_black_arks_long", "mission_text_text_wh3_dlc29_def_lokhir_max_level_black_arks_long", 3, 0, true),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_main_def_hag_graef = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_cold_mires", "wh3_main_combi_province_the_eternal_lagoon", "wh3_main_combi_province_the_noisome_tumour", "wh3_main_combi_province_plain_of_illusions"}, 4, "mission_text_text_own_provinces_in_chaos_wastes"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_demonic_form_short", "mission_text_text_wh3_dlc29_def_malus_demonic_form", 3, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc14_vor_def_malus_warpsword_of_khaine_stage_4"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_tzarkan_whispers_short", "mission_text_text_wh3_dlc29_def_malus_tzarkan_whispers_short", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_black_arks_short", "mission_text_text_wh3_dlc29_def_malus_black_arks_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							effect_bundle = "wh3_dlc29_bundle_def_malus_warmaster_ritual_unlock",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_construct_landmark_long", "mission_text_text_wh3_dlc29_def_morathi_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_acquire_sword_of_khaine_long", "mission_text_text_wh3_dlc29_def_morathi_acquire_sword_of_khaine_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_demonic_form_long", "mission_text_text_wh3_dlc29_def_malus_demonic_form", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_kill_hef_legendary_lords_long", "mission_text_text_wh3_dlc29_def_malus_kill_hef_legendary_lords_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_malus_black_arks_long", "mission_text_text_wh3_dlc29_def_malus_black_arks_long", 3, 0, true),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_twa03_def_rakarth = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_rakarth_monster_pen_short", "mission_text_text_wh3_dlc29_def_rakarth_monster_pen_short", 10, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_twa03_qb_def_rakarth_whip_of_agony"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_turtle_isles"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_rakarth_construct_landmark_short", "mission_text_text_wh3_dlc29_def_rakarth_construct_landmark_short"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_follower_def_ruthless_captor",
							effect_bundle = "wh3_dlc29_bundle_def_rakarth_beast_tamer",
							scripted_reward = "dummy_wh3_dlc29_def_rakarth_lord_victory_objective_short",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_hexoatl", "wh2_main_lzd_itza"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_rakarth_monster_pen_long", "mission_text_text_wh3_dlc29_def_rakarth_monster_pen_long", 17, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_rakarth_rankup_units_long", "mission_text_text_wh3_dlc29_def_rakarth_rankup_units_long", 20, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_def_rakarth_black_arks_long", "mission_text_text_wh3_dlc29_def_malus_black_arks_long", 3, 0, true),
						},
						payloads = {
							pooled_resource = {{"def_slaves", "missions", 2000}},
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_def_long", "wh3_dlc29_bundle_ie_victory_objective_hero_recruitment_rank"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- GREENSKINS -----
				wh_main_grn_greenskins = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_win_wagh_short", "mission_text_text_wh3_dlc29_mission_win_wagh_of_any_type", 2, 0, true),
							generate_CONTROL_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_zharr_naggrund"}, 1, "mission_text_text_mis_activity_control_settlement"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_construct_landmark_short", "mission_text_text_wh3_dlc29_grn_grimgor_construct_landmark_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_black_fire_pass"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet",
							ancillary = {"wh_main_anc_magic_standard_da_immortulz", "wh_main_anc_magic_standard_da_immortulz"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_win_wagh_long", "mission_text_text_wh3_dlc29_mission_win_biggest_wagh", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_construct_landmark_long", "mission_text_text_wh3_dlc29_grn_grimgor_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_confederate_greenskins_long", "mission_text_text_wh3_dlc29_grn_grimgor_confederate_greenskins_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grimgor_kill_legendary_lords_long", "mission_text_text_wh3_dlc29_skv_kill_n_legendary_lords_long", 5, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc15_grn_bonerattlaz = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_main_ksl_the_ice_court", "wh3_main_ksl_the_great_orthodoxy"}, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_azhag_win_wagh_short", "mission_text_text_wh3_dlc29_grn_azhag_win_wagh_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_todtheim"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet",
							scripted_reward = "dummy_wh3_dlc29_grn_azhag_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh_main_emp_empire", "wh_main_emp_wissenland", "wh_main_emp_middenland"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_azhag_win_wagh_1_long", "mission_text_text_wh3_dlc29_mission_win_wagh_of_any_type", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_azhag_win_wagh_2_long", "mission_text_text_wh3_dlc29_mission_win_biggest_wagh_single"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_azhag_confederate_greenskins_long", "mission_text_text_wh3_dlc29_grn_grimgor_confederate_greenskins_long", 3, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_grn_crooked_moon = {
					short = {
						objectives = {
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_karak_eight_peaks"}, 1, "mission_text_text_mis_activity_control_settlement"),
							generate_DESTROY_FACTION_objective({"wh_main_dwf_dwarfs", "wh_main_grn_necksnappers"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_rankup_agents_short", "mission_text_text_wh3_dlc29_grn_skarsnik_rankup_agents_short", 2, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_construct_landmark_short", "mission_text_text_wh3_dlc29_grn_skarsnik_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet", "wh3_dlc29_ie_victory_conditions_grn_new_home"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_construct_landmark_long", "mission_text_text_wh3_dlc29_grn_skarsnik_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_win_wagh_1_long", "mission_text_text_wh3_dlc29_mission_win_wagh_of_any_type", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_win_wagh_2_long", "mission_text_text_wh3_dlc29_mission_win_biggest_wagh_single"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_rankup_agents_long", "mission_text_text_wh3_dlc29_grn_skarsnik_rankup_agents_long", 3, 0, true),
							generate_DESTROY_FACTION_objective({"wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_skarsnik_confederate_greenskins_long", "mission_text_text_wh3_dlc29_grn_grimgor_confederate_greenskins_long", 3, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_grn_orcs_of_the_bloody_hand = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_lzd_tlaqua", "wh2_main_lzd_last_defenders"}, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_wurrzag_construct_landmark_short", "mission_text_text_wh3_dlc29_grn_wurrzag_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_wurrzag_rankup_units_short", "mission_text_text_wh3_dlc29_grn_wurrzag_rankup_units_short", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_wurrzag_win_any_quest_battle_short", "mission_text_text_wh3_dlc29_grn_wurrzag_win_any_quest_battle_short"),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(3, "wh_main_grn_orcs_of_the_bloody_hand", "wh3_dlc26_special_gork_mork_idols_1"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet",
							scripted_reward = "dummy_wh3_dlc29_grn_wurrzag_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_wurrzag_confederate_greenskins_long", "mission_text_text_wh3_dlc29_grn_grimgor_confederate_greenskins_long", 4, 0, true),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(6, "wh_main_grn_orcs_of_the_bloody_hand", "wh3_dlc26_special_gork_mork_idols_1"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_wurrzag_construct_landmarks_long", "mission_text_text_wh3_dlc29_grn_wurrzag_construct_landmarks_long"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc15_grn_broken_axe = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_unlock_all_ingridient_slots_short", "mission_text_text_wh3_dlc29_grn_grom_unlock_all_ingridient_slots_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_unlock_ingridients_short", "mission_text_text_wh3_dlc29_grn_grom_unlock_ingridients_short", 15, 1, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_win_wagh_short", "mission_text_text_wh3_dlc29_grn_grom_win_wagh_short"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet", "wh3_dlc29_ie_victory_conditions_grn_old_knives"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_cook_unique_recipes_long", "mission_text_text_wh3_dlc29_grn_grom_cook_unique_recipes_long", 15, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_win_wagh_1_long", "mission_text_text_wh3_dlc29_mission_win_wagh_of_any_type", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_grom_win_wagh_2_long", "mission_text_text_wh3_dlc29_grn_grom_win_wagh_2_long", 2, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc26_grn_gorbad_ironclaw = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_construct_landmark_short", "mission_text_text_wh3_dlc29_grn_gorbad_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_unlock_da_plans_short", "mission_text_text_wh3_dlc29_grn_gorbad_unlock_da_plans", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_confederate_greenskins_short", "mission_text_text_wh3_dlc29_grn_gorbad_confederate_greenskins_short"),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "grn_salvage", "mission_text_text_wh3_dlc29_grn_mission_spend_scrap_on_unit_upgrades", "wh2_dlc15_resource_factor_unit_upgrade"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_grn_trophy_cabinet",
							ancillary = "wh3_dlc29_anc_grn_follower_da_planner",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_unlock_da_plans_long", "mission_text_text_wh3_dlc29_grn_gorbad_unlock_da_plans", 25, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_equip_da_plans_long", "mission_text_text_wh3_dlc29_grn_gorbad_equip_da_plans_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_win_wagh_1_long", "mission_text_text_wh3_dlc29_mission_win_wagh_of_any_type", 4, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_grn_gorbad_win_wagh_2_long", "mission_text_text_wh3_dlc29_grn_gorbad_win_wagh_2_long"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"grn_salvage", "missions", 1000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- OGRE KINGDOMS -----
				wh3_main_ogr_goldtooth = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_ivory_road", "wh3_main_combi_province_mountains_of_mourn", "wh3_main_combi_province_bone_road"}, 3),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_construct_camp_short",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_single",
														   1,
														   0,
														   true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_construct_landmarks_short", "mission_text_text_wh3_dlc29_ogr_greasus_construct_landmarks_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_use_tyrant_demands_short", "mission_text_text_wh3_dlc29_ogr_greasus_use_tyrant_demands", 12, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_confederate_ogres_short", "mission_text_text_wh3_dlc29_ogr_confederate_ogres_short", 2, 0, true),
						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_ogr_follower_meat_grinder", "wh3_dlc29_anc_ogr_follower_accountant"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_construct_camp_long",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_multiple",
														   3,
														   0,
														   true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_complete_bounties_long", "mission_text_text_wh3_dlc29_ogr_greasus_complete_bounties_long", 10, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_greasus_use_tyrant_demands_long", "mission_text_text_wh3_dlc29_ogr_greasus_use_tyrant_demands", 24, 0, true),
							generate_HAVE_AT_LEAST_X_MONEY_objective(100000),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_ogr_camp_capacity", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_ogr_disciples_of_the_maw = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_teb_border_princes"}, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_skrag_construct_camp_short",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_single",
														   1,
														   0,
														   true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_short", "mission_text_text_wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_short", 5, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(500, "wh3_main_ogr_meat", "mission_text_text_wh3_dlc29_ogr_skrag_spend_meat_on_offerings_short", "offered_to_the_great_maw"),

						},
						payloads = {
							ancillary = {"wh3_dlc29_anc_ogr_follower_meat_grinder", "wh3_dlc29_anc_ogr_follower_expert_butcher"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_skrag_construct_camp_long",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_multiple",
														   3,
														   0,
														   true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_long", "mission_text_text_wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_long", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_skrag_rankup_agents_long", "mission_text_text_wh3_dlc29_ogr_skrag_rankup_agents_long", 2, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_ogr_camp_capacity", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc26_ogr_golgfag = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_complete_war_contracts_short", "mission_text_text_wh3_dlc29_complete_war_contracts", 7, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_gain_surplus_money_from_war_contracts_short", "mission_text_text_wh3_dlc29_gain_surplus_money_from_war_contracts", 2000, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_complete_bounties_short", "mission_text_text_wh3_dlc29_ogr_greasus_complete_bounties_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_construct_camp_short",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_single",
														   1,
														   0,
														   true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_ogr_follower_meat_grinder",
							effect_bundle = "wh3_dlc29_ie_victory_conditions_ogr_bountiful_contracts",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_complete_war_contracts_long", "mission_text_text_wh3_dlc29_complete_war_contracts", 20, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_construct_camp_long",
														   "mission_text_text_wh3_dlc29_ogr_construct_in_camp_multiple",
														   3,
														   0,
														   true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_ogr_golgfag_rankup_units_long", "mission_text_text_wh3_dlc29_ogr_golgfag_rankup_units_long", 20, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_ogr_camp_capacity", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- TOMB KINGS -----
				wh2_dlc09_tmb_khemri = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_followers_of_nagash", "wh3_dlc29_nag_host_of_nagash"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_shifting_sands", "wh3_main_combi_province_land_of_the_dead", "wh3_main_combi_province_land_of_the_dervishes", "wh3_main_combi_province_great_mortis_delta"}, 4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_settra_construct_landmarks_short", "mission_text_text_wh3_dlc29_tmb_settra_construct_landmarks_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc09_qb_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_settra_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 3, 0, true),
							generate_OWN_N_UNITS_objective(36),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_tmb_follower_organ_grinder",
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_lord_capacity_one", "wh3_dlc29_ie_victory_conditions_tmb_gather_the_dead"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_settra_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 6, 0, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_the_cracked_land", "wh3_main_combi_province_great_desert_of_araby", "wh3_main_combi_province_land_of_assassins", "wh3_main_combi_province_coast_of_araby"}, 4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_settra_unlock_royal_standard_long", "mission_text_text_wh3_dlc29_tmb_settra_unlock_royal_standard_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_settra_construct_landmarks_long", "mission_text_text_wh3_dlc29_tmb_settra_construct_landmarks_long"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"tmb_canopic_jars", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc09_tmb_exiles_of_nehek = {
					short = {
						objectives = {
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_red_desert", "wh3_main_combi_province_the_witchwood", "wh3_main_combi_province_doom_glades", "wh3_main_combi_province_ironsand_desert"}, 4),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh2_dlc09_ritual_crafting_tmb_carrion", "wh2_dlc09_ritual_crafting_tmb_necropolis_knights", "wh2_dlc09_ritual_crafting_tmb_nehekhara_horsemen", "wh2_dlc09_ritual_crafting_tmb_nehekhara_warriors"}, 4, true, "mission_text_text_mis_activity_legions_of_legends_all"),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh3_main_ritual_crafting_tmb_cursing_word", "wh3_main_ritual_crafting_tmb_ualatp_order", "wh3_main_ritual_crafting_tmb_centuries_sigil", "wh3_main_ritual_crafting_tmb_sacred_eye", "wh3_main_ritual_crafting_tmb_khsar_fury"}, 2, nil, "mission_text_text_wh3_dlc29_tmb_craft_banners_via_cult"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_tmb_follower_organ_grinder",
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_lord_capacity_one", "wh3_dlc29_ie_victory_conditions_tmb_equipped_traveller"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_khatep_rankup_agents_long", "mission_text_text_wh3_dlc29_tmb_khatep_rankup_agents_long", 4, 0, true),
							generate_PERFORM_RITUAL_BY_KEY_LIST_objective({"wh2_dlc09_ritual_crafting_tmb_armour_scorpion_armour", "wh2_dlc09_ritual_crafting_tmb_enchanted_item_vambraces_of_the_sun", "wh2_dlc09_ritual_crafting_tmb_talisman_amulet_of_pha_stah", "wh2_dlc09_ritual_crafting_tmb_weapon_crook_and_flail_of_radiance"}, 4, true, "mission_text_text_wh3_dlc29_tmb_craft_all_unique_items_via_cult"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("CANOPIC_RITUAL", 10, "mission_text_text_wh3_dlc29_tmb_use_nehekhara_decrees"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"tmb_canopic_jars", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc09_tmb_lybaras = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_main_vmp_the_silver_host", "wh2_main_vmp_necrarch_brotherhood", "wh_main_vmp_vampire_counts", "wh3_main_ie_vmp_sires_of_mourkain"}, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_khalida_construct_landmark_short", "mission_text_text_wh3_dlc29_tmb_khalida_construct_landmark_short"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_crater_of_the_waking_dead", "wh3_main_combi_province_devils_backbone"}, 2),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_khalida_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 3, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1000, "tmb_canopic_jars", "mission_text_text_wh3_dlc29_tmb_spend_canopic_jars_on_mortuary_cult", "mortuary_cult"),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_tmb_follower_organ_grinder",
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_lord_capacity_one", "wh3_dlc29_ie_victory_conditions_tmb_rightful_home"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh3_dlc29_nag_host_of_nagash", "wh2_dlc09_tmb_followers_of_nagash", "wh3_dlc29_vmp_neferata"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_shifting_sands", "wh3_main_combi_province_land_of_the_dead", "wh3_main_combi_province_land_of_the_dervishes", "wh3_main_combi_province_great_mortis_delta"}, 4),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_khalida_construct_landmark_long", "mission_text_text_wh3_dlc29_tmb_khalida_construct_landmark_long"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("CANOPIC_RITUAL", 10, "mission_text_text_wh3_dlc29_tmb_use_nehekhara_decrees"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_khalida_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 6, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"tmb_canopic_jars", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc09_tmb_followers_of_nagash = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh2_dlc14_brt_chevaliers_de_lyonesse", "wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_lybaras"}, true),
							generate_CONTROL_N_REGIONS_FROM_objective({"wh3_main_combi_region_black_tower_of_arkhan"}, 1, "mission_text_text_mis_activity_own_n_regions_1_of_1"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_arkhan_construct_landmark_short", "mission_text_text_wh3_dlc29_tmb_arkhan_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_arkhan_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_arkhan_nagash_collect_n_books", 4, 1, true),
						},
						payloads = {
							ancillary = "wh3_dlc29_anc_tmb_follower_organ_grinder",
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_lord_capacity_one", "wh3_dlc29_ie_victory_conditions_tmb_deal_between_the_dead"},
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(2000, "tmb_canopic_jars", "mission_text_text_wh3_dlc29_tmb_spend_canopic_jars_on_mortuary_cult", "mortuary_cult"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("CANOPIC_RITUAL", 10, "mission_text_text_wh3_dlc29_tmb_use_nehekhara_decrees"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_tmb_arkhan_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_arkhan_nagash_collect_n_books", 9, 1, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle",
							pooled_resource = {{"tmb_canopic_jars", "missions", 2000}},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- VAMPIRE COAST -----
				wh2_dlc11_cst_vampire_coast = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_restore_mind_dummy_parent_objective_short", "mission_text_text_wh3_dlc29_cst_luthor_restore_mind_dummy_parent_objective_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_construct_landmark_sub_objective_short", "mission_text_text_wh3_dlc29_cst_luthor_construct_landmark_sub_objective_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_complete_quest_sub_objective_short", "mission_text_text_wh3_dlc29_cst_luthor_complete_quest_sub_objective_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_upgrade_ship_short", "mission_text_text_wh3_dlc29_cst_luthor_upgrade_ship_short"),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 8000),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_gain_pieces_of_eight_short", "mission_text_text_wh3_dlc29_cst_luthor_gain_pieces_of_eight", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_establish_pirate_coves_short", "mission_text_text_wh3_dlc29_cst_luthor_establish_pirate_coves_short", 3, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_cst_pirate_flag",
							scripted_reward = "dummy_wh3_dlc29_cst_luthor_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_upgrade_ship_long", "mission_text_text_wh3_dlc29_cst_luthor_upgrade_ship_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_fill_offices_long", "mission_text_text_wh3_dlc29_cst_luthor_fill_offices_long", 8, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_unlock_sea_shanties_long", "mission_text_text_wh3_dlc29_cst_luthor_unlock_sea_shanties_long", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_luthor_gain_pieces_of_eight_long", "mission_text_text_wh3_dlc29_cst_luthor_gain_pieces_of_eight", 5, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 25000),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_cst_long_victory", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc11_cst_noctilus = {
					short = {
						objectives = {
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 8000),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_upgrade_ship_short", "mission_text_text_wh3_dlc29_cst_noctilus_upgrade_ship", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_establish_pirate_coves_short", "mission_text_text_wh3_dlc29_cst_noctilus_establish_pirate_coves_short", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_construct_landmark_short", "mission_text_text_wh3_dlc29_cst_noctilus_construct_landmark_short"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_cst_pirate_flag",
							ancillary = "wh3_dlc29_anc_cst_follower_deckhand"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_upgrade_ship_long", "mission_text_text_wh3_dlc29_cst_noctilus_upgrade_ship", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_upgrade_ship_special_long", "mission_text_text_wh3_dlc29_cst_noctilus_upgrade_ship_special_long"),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(4, {"wh2_dlc11_tech_cst_admirals_01", "wh2_dlc11_tech_cst_admirals_02", "wh2_dlc11_tech_cst_admirals_03", "wh2_dlc11_tech_cst_admirals_04"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_noctilus_rankup_units_long", "mission_text_text_wh3_dlc29_cst_noctilus_rankup_units_long", 3, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 25000),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_cst_long_victory", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc11_cst_pirates_of_sartosa = {
					short = {
						objectives = {
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 8000),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_construct_landmark_short", "mission_text_text_wh3_dlc29_cst_aranessa_construct_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_upgrade_ship_short", "mission_text_text_wh3_dlc29_cst_luthor_upgrade_ship_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_gain_pieces_of_eight_short", "mission_text_text_wh3_dlc29_cst_luthor_gain_pieces_of_eight", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_complete_treasure_hunts_short", "mission_text_text_wh3_dlc29_cst_aranessa_complete_treasure_hunts_short", 5, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc11_qb_cst_aranessa_saltspite_krakens_bane"),
							
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_cst_pirate_flag", "wh3_dlc29_ie_victory_conditions_cst_lucky"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_construct_landmark_long", "mission_text_text_wh3_dlc29_cst_aranessa_construct_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_upgrade_ship_long", "mission_text_text_wh3_dlc29_cst_aranessa_upgrade_ship_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_gain_pieces_of_eight_long", "mission_text_text_wh3_dlc29_cst_luthor_gain_pieces_of_eight", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_aranessa_gain_money_sacking_long", "mission_text_text_wh3_dlc29_cst_aranessa_gain_money_sacking_long", 50000, 0, true),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 25000),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_cst_long_victory", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc11_cst_the_drowned = {
					short = {
						objectives = {
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 8000),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_unlock_sea_shanties_short", "mission_text_text_wh3_dlc29_cst_cylostra_unlock_sea_shanties_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_establish_pirate_coves_short", "mission_text_text_wh3_dlc29_cst_cylostra_establish_pirate_coves_short", 5, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh2_dlc11_qb_cst_cylostra_shifting_isles_battle_bretonnia"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_rankup_units_short", "mission_text_text_wh3_dlc29_cst_cylostra_rankup_units_short", 5, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_ie_victory_conditions_cst_pirate_flag",
							scripted_reward = "dummy_wh3_dlc29_cst_cylostra_victory_objective_short"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective("cst_infamy", 25000),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_upgrade_ship_long", "mission_text_text_wh3_dlc29_cst_cylostra_upgrade_ship_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_unlock_sea_shanties_long", "mission_text_text_wh3_dlc29_cst_luthor_unlock_sea_shanties_long", 3, 0, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_eataine"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cst_cylostra_construct_landmark_long", "mission_text_text_wh3_dlc29_cst_cylostra_construct_landmark_long"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_cst_long_victory", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- VAMPIRE COUNTS -----
				wh3_dlc29_vmp_neferata = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_perform_manipulation_rituals_short", "mission_text_text_wh3_dlc29_vmp_neferata_perform_manipulation_rituals", 6, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals_short", "mission_text_text_wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_build_max_tier_silver_pinnacles_short", "mission_text_text_wh3_dlc29_vmp_neferata_build_max_tier_silver_pinnacles"),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(5, {"wh3_dlc29_tech_nef_handmaidens_2a", "wh3_dlc29_tech_nef_handmaidens_2b", "wh3_dlc29_tech_nef_handmaidens_2c", "wh3_dlc29_tech_nef_handmaidens_2d", "wh3_dlc29_tech_nef_handmaidens_2e"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_build_covens_short", "mission_text_text_wh3_dlc29_vmp_neferata_build_covens", 6, 0, true),
						},
						payloads = {
							scripted_reward = 	"dummy_wh3_dlc29_vmp_neferata_victory_objective_short",
							effect_bundle = 	"wh3_dlc29_bundle_ie_victory_objective_vmp_misstress_of_silence",
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_perform_manipulation_rituals_long", "mission_text_text_wh3_dlc29_vmp_neferata_perform_manipulation_rituals", 12, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals_long", "mission_text_text_wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals", 6, 0, true),
							generate_RESEARCH_N_TECHS_INCLUDING_objective(5, {"wh3_dlc29_tech_nef_handmaidens_3a", "wh3_dlc29_tech_nef_handmaidens_3b", "wh3_dlc29_tech_nef_handmaidens_3c", "wh3_dlc29_tech_nef_handmaidens_3d", "wh3_dlc29_tech_nef_handmaidens_3e"}),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_neferata_build_covens_or_own_settlement_long", "mission_text_text_wh3_dlc29_vmp_neferata_build_covens_or_own_settlement"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc29_qb_vmp_dream_of_lahmia"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh_main_vmp_vampire_counts = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_collect_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 4, 0, true),
							generate_DESTROY_FACTION_objective({"wh2_dlc09_tmb_khemri", "wh3_main_emp_cult_of_sigmar", "wh2_dlc14_brt_chevaliers_de_lyonesse", "wh3_dlc29_nag_host_of_nagash"}, true, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_awaken_bloodline_lords_short", "mission_text_text_wh3_dlc29_vmp_mannfred_awaken_bloodline_lords", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_build_landmark_short", "mission_text_text_wh3_dlc29_vmp_mannfred_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland_short", "mission_text_text_wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland", 4, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_vmp_lair_builder",
							ancillary = 	"wh3_dlc29_anc_vmp_follower_keeper_of_forbidden_lore"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_collect_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", 9, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_awaken_bloodline_lords_long", "mission_text_text_wh3_dlc29_vmp_mannfred_awaken_bloodline_lords", 6, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland_long", "mission_text_text_wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland", 8, 0, true),
							generate_CONTROL_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_castle_drakenhof"}, 1),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_mannfred_build_landmark_long", "mission_text_text_wh3_dlc29_vmp_mannfred_build_landmark_long"),
							generate_DESTROY_FACTION_objective({"wh_main_vmp_schwartzhafen"}, true, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				-- Vlad and Isabella von Carstein use different victory conditions but have the same faction, defined by lord subtype key
				wh_dlc04_vmp_vlad_con_carstein = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals_short", "mission_text_text_wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_build_landmark_short", "mission_text_text_wh3_dlc29_vmp_vlad_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_confederate_vassalise_destroy_short", "mission_text_text_wh3_dlc29_vmp_vlad_confederate_vassalise_destroy", 1, 0, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_southern_sylvania", "wh3_main_combi_province_northern_sylvania", "wh3_main_combi_province_reikland", "wh3_main_combi_province_wissenland"}, 4),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_vmp_empowering_the_bloodline",
							ancillary = 	"wh3_dlc29_anc_vmp_follower_castellan_of_drakenhof"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals_long", "mission_text_text_wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals", 6, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_confederate_vassalise_destroy_long", "mission_text_text_wh3_dlc29_vmp_vlad_confederate_vassalise_destroy", 3, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_vlad_build_landmark_long", "mission_text_text_wh3_dlc29_vmp_vlad_build_landmark_long"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective(province_key_list_from_region_group("cai_region_hint_area_empire"), 22, "mission_text_text_wh3_dlc29_chs_glottkin_control_all_empire_provinces_long"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				-- Vlad and Isabella von Carstein use different victory conditions but have the same faction, defined by lord subtype key
				wh_pro02_vmp_isabella_von_carstein = {
					short = {
						objectives = {
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(7500, "wh3_dlc29_vmp_power", "mission_text_text_wh3_dlc29_vmp_isabella_spend_shyish_on_recruitement", "recruitment"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_isabella_rankup_heroes_short", "mission_text_text_wh3_dlc29_vmp_isabella_rankup_heroes_short", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_isabella_kill_human_lords_short", "mission_text_text_wh3_dlc29_vmp_isabella_kill_human_lords", 9, 0, true),
							generate_CONSTRUCT_BUILDINGS_INCLUDING_objective(1, "wh_main_vmp_schwartzhafen", {"wh3_dlc29_vmp_vampires_3"}),
							generate_DESTROY_FACTION_objective({"wh_main_emp_middenland", "wh_main_emp_wissenland"}, true, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_vmp_empowering_the_bloodline",
							ancillary = 	"wh3_dlc29_anc_vmp_follower_sanguine_steward"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh_main_emp_empire"}, true, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(15000, "wh3_dlc29_vmp_power", "mission_text_text_wh3_dlc29_vmp_isabella_spend_shyish_on_recruitement", "recruitment"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_isabella_confederate_via_bloodline_long", "mission_text_text_wh3_dlc29_vmp_isabella_confederate_via_bloodline_long", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_isabella_kill_human_lords_long", "mission_text_text_wh3_dlc29_vmp_isabella_kill_human_lords", 18, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_isabella_build_landmark_long", "mission_text_text_wh3_dlc29_vmp_vlad_build_landmark_short"),
							generate_CONSTRUCT_N_OF_A_BUILDING_objective(4, "wh_main_vmp_schwartzhafen", "wh3_dlc29_vmp_vampires_3"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh2_dlc11_vmp_the_barrow_legion = {
					short = {
						objectives = {
							generate_CONTROL_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_couronne", "wh3_main_combi_region_castle_carcassonne"}, 2),
							generate_DESTROY_FACTION_objective({"wh_main_brt_bretonnia", "wh_main_brt_carcassonne"}, true, true),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("VAMPIRE_PROVINCE", 5, "mission_text_text_wh3_dlc29_vmp_use_shyish_actions"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_la_maisontaal_abbey"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_kemmler_build_landmark_short", "mission_text_text_wh3_dlc29_vmp_kemmler_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_kemmler_rankup_units_short", "mission_text_text_wh3_dlc29_vmp_kemmler_rankup_units_short", 8, 0, true),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_vmp_vengeful_spirits",
							ancillary = 	"wh3_dlc29_anc_vmp_follower_wraithbringer"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_REGIONS_INCLUDING_objective({"wh3_main_combi_region_altdorf"}, 1),
							generate_DESTROY_FACTION_objective({"wh_main_emp_empire"}, true, true),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("VAMPIRE_PROVINCE", 10, "mission_text_text_wh3_dlc29_vmp_use_shyish_actions"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_kemmler_confederate_via_bloodline_long", "mission_text_text_wh3_dlc29_vmp_isabella_confederate_via_bloodline_long", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_kemmler_build_landmark_long", "mission_text_text_wh3_dlc29_vmp_kemmler_build_landmark_long"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_vmp_caravan_of_blue_roses = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_main_nur_poxmakers_of_nurgle"}, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(10000, "wh3_dlc29_vmp_corpses", "mission_text_text_wh3_dlc29_vmp_ghorst_spend_corpses_on_recruitement", "recruitment"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_ghorst_rankup_units_short", "mission_text_text_wh3_dlc29_vmp_ghorst_rankup_units_short", 7, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_ghorst_build_landmark_short", "mission_text_text_wh3_dlc29_vmp_ghorst_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_ghorst_build_max_tier_settlement_short", "mission_text_text_wh3_dlc29_vmp_neferata_build_max_tier_silver_pinnacles"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_4_glacial_lake"),
						},
						payloads = {
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_vmp_raise_the_dead",
							ancillary = 	"wh3_dlc29_anc_vmp_follower_corpse_collector"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_DESTROY_FACTION_objective({"wh2_dlc15_hef_imrik", "wh2_dlc13_emp_golden_order"}, true, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(30000, "wh3_dlc29_vmp_corpses", "mission_text_text_wh3_dlc29_vmp_ghorst_spend_corpses_on_recruitement", "recruitment"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_vmp_ghorst_confederate_via_bloodline_long", "mission_text_text_wh3_dlc29_vmp_isabella_confederate_via_bloodline_long", 2, 0, true),
							generate_RESEARCH_TECHNOLOGY_objective("wh3_main_tech_vmp_necromancers_final_2"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_bundle_ie_victory_objective_vmp_long_victory", "wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle"}
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
----- GRAND CATHAY -----
				wh3_main_cth_the_northern_provinces = {
					short = {
						objectives = {
							generate_DESTROY_FACTION_objective({"wh3_dlc23_chd_zhatan", "wh3_dlc20_chs_vilitch", "wh3_dlc27_nor_sayl"}, true),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_gunpowder_road", "wh3_main_combi_province_lands_of_stone_and_steel", "wh3_main_combi_province_imperial_road", "wh3_main_combi_province_western_great_bastion", "wh3_main_combi_province_central_great_bastion", "wh3_main_combi_province_eastern_great_bastion"}, 6),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_upgrade_gates_short", "mission_text_text_wh3_dlc29_cth_miao_upgrade_gates_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_build_landmark_short", "mission_text_text_wh3_dlc29_cth_miao_build_landmark_short"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_win_battles_against_factions_short", "mission_text_text_wh3_dlc29_cth_miao_win_battles_against_factions", 20, 0, true),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_cth_miao_ying_victory_objective_short",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_cth_greater_protection"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_kill_legendary_lords_long", "mission_text_text_wh3_dlc29_skv_kill_n_legendary_lords_long", 5, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_upgrade_gates_long", "mission_text_text_wh3_dlc29_cth_miao_upgrade_gates_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_build_landmark_long", "mission_text_text_wh3_dlc29_cth_miao_build_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_miao_win_battles_against_factions_long", "mission_text_text_wh3_dlc29_cth_miao_win_battles_against_factions", 50, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_main_cth_the_western_provinces = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short", "mission_text_text_wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally"),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_warpstone_desert", "wh3_main_combi_province_wastelands_of_jinshen", "wh3_main_combi_province_ivory_road", "wh3_main_combi_province_forests_of_the_moon", "wh3_main_combi_province_celestial_riverlands"}, 5),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_zhao_resolve_caravan_events_short", "mission_text_text_wh3_dlc29_cth_zhao_resolve_caravan_events_short", 20, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_caravan_capacity", "wh3_dlc29_bundle_ie_victory_objective_cth_greater_protection"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_CONTROL_N_PROVINCES_INCLUDING_objective({"wh3_main_combi_province_gunpowder_road", "wh3_main_combi_province_lands_of_stone_and_steel", "wh3_main_combi_province_imperial_road", "wh3_main_combi_province_western_great_bastion", "wh3_main_combi_province_central_great_bastion", "wh3_main_combi_province_eastern_great_bastion"}, 6),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_zhao_build_landmark_long", "mission_text_text_wh3_dlc29_cth_zhao_build_landmark_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_zhao_send_caravans_long", "mission_text_text_wh3_dlc29_cth_zhao_send_caravans_long", 10, 0, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_dlc24_cth_the_celestial_court = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_yuanbo_construct_astromantic_relays_short", "mission_text_text_wh3_dlc29_cth_yuanbo_construct_astromantic_relays_short"),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc24_cth_yuan_bo_dragons_fang"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_yuanbo_perform_matters_of_state_actions_short", "mission_text_text_wh3_dlc29_cth_yuanbo_perform_matters_of_state_actions_short", 2, 0, true),
						},
						payloads = {
							scripted_reward = "dummy_wh3_dlc29_cth_yuan_bo_victory_objective_short",
							effect_bundle = "wh3_dlc29_bundle_ie_victory_objective_cth_greater_protection"
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_yuanbo_construct_astromantic_relays_long", "mission_text_text_wh3_dlc29_cth_yuanbo_construct_astromantic_relays_long"),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_yuanbo_empower_compass_directions_long", "mission_text_text_wh3_dlc29_cth_yuanbo_empower_compass_directions_long", 4, 0, true),
							generate_FIGHT_SET_PIECE_BATTLE_objective("wh3_dlc24_cth_yuan_bo_compass"),
							generate_PERFORM_RITUAL_BY_CATEGORY_objective("YUAN_BO_ACTION", 20, "mission_text_text_wh3_dlc29_cth_yuanbo_perform_matters_of_state_actions_long"),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
				wh3_cp1_cth_tiger_warriors = {
					short = {
						objectives = {
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_bhashiva_reach_tiger_court_max_level_short", "mission_text_text_wh3_cp1_bhashiva_tiger_court_short_victory", 1, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_bhashiva_complete_zhao_goals_short", "mission_text_text_wh3_cp1_bhashiva_zhao_goals_short_victory", 4, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(1500, "wh3_cp1_cth_iron_favour", "mission_text_text_wh3_dlc29_cth_bhashiva_spend_iron_favour"),
							generate_DESTROY_FACTION_objective({"wh3_main_ogr_mountaineaters", "wh3_main_ogr_sons_of_the_mountain", "wh_main_grn_greenskins", "wh3_main_ogr_fulg"}, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_lord_capacity", "wh3_dlc29_bundle_ie_victory_objective_cth_greater_protection"}
						},
					},
					long = {
						objectives = {
							generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_bhashiva_reach_tiger_court_max_level_long", "mission_text_text_wh3_cp1_bhashiva_tiger_court_long_victory", 2, 0, true),
							generate_SCRIPTED_MISSION_objective("wh3_dlc29_cth_bhashiva_complete_zhao_goals_long", "mission_text_text_wh3_cp1_bhashiva_zhao_goals_long_victory", 10, 0, true),
							generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective(3000, "wh3_cp1_cth_iron_favour", "mission_text_text_wh3_dlc29_cth_bhashiva_spend_iron_favour"),
							generate_DESTROY_FACTION_objective({"wh3_dlc23_chd_minor_faction", "wh3_dlc23_chd_legion_of_azgorh", "wh3_dlc23_chd_conclave"}, true),
						},
						payloads = {
							effect_bundle = {"wh3_dlc29_ie_victory_conditions_characters_recruit_rank_bundle", "wh3_dlc29_ie_victory_conditions_global_recruitement_reward_bundle"},
						},
					},
					domination = {
						objectives = {
							generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective(272),
						},
					},
					multiplayer = {
						objectives = {
							generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective(100),
						},
					},
				},
			},
		}

		--_victory_objectives_ie = {}
		_victory_objectives_ie.config = _victory_objectives_ie_config
	end,
	false
)

_victory_objectives_ie.listeners = {
----- BEASTMEN -----

	-- Khazrak
	["wh_dlc03_bst_beastmen"] = function(faction_key)

		-- Khazrak: Build a Special Herdstone
		_victory_objectives_ie.listeners.bst_shared_objective_listeners(faction_key)
	end,

	-- Taurox
	["wh2_dlc17_bst_taurox"] = function(faction_key)

		-- Taurox: Claim Rampage Reward 2/4 times for short/long victory
		local rampage_ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_"

		core:add_listener(
			"IEVictoryConditionRampageRewardClaimed",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), rampage_ritual_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_bst_claim_rampage_rewards_n_times_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_bst_claim_rampage_rewards_n_times_long", 1)
			end,
			true
		)

		-- Taurox: Win 3 battles in one turn for short victory
		local required_win_streak = 3

		core:add_listener(
			"IEVictoryConditionTauroxWinStreak",
			"CharacterCompletedBattle",
			function(context)
				return context:character():faction():name() == faction_key and cm:pending_battle_cache_faction_won_battle(faction_key)
			end,
			function(context)
				local last_win_turn_number = cm:get_saved_value("taurox_win_streak_turn_number") or 1
				local current_win_streak = cm:get_saved_value("taurox_win_streak") or 0
				local current_turn_number = cm:turn_number()

				if last_win_turn_number == current_turn_number then
					current_win_streak = current_win_streak + 1
				else
					current_win_streak = 1
				end

				cm:set_saved_value("taurox_win_streak", current_win_streak)
				cm:set_saved_value("taurox_win_streak_turn_number", current_turn_number)

				if current_win_streak >= required_win_streak then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_bst_win_n_battles_in_one_turn_short", true)
					core:remove_listener("IEVictoryConditionTauroxWinStreak")
				end

			end,
			true
		)

		-- Taurox: Build a Special Herdstone
		_victory_objectives_ie.listeners.bst_shared_objective_listeners(faction_key)
	end,

	-- Morghur
	["wh_dlc05_bst_morghur_herd"] = function(faction_key)

		-- Morghur: Build a Special Herdstone
		_victory_objectives_ie.listeners.bst_shared_objective_listeners(faction_key)
	end,

	-- Malagor
	["wh2_dlc17_bst_malagor"] = function(faction_key)

		-- Malagor: Get 3 Bray Shamans to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionMalagorRankUpBrayShaman",
			"wh_main_short_victory",
			"wh3_dlc_bst_get_n_bray_shamans_to_rank_10_short",
			faction_key,
			{"wh_dlc03_bst_bray_shaman_wild", "wh_dlc03_bst_bray_shaman_shadows", "wh_dlc03_bst_bray_shaman_death", "wh_dlc03_bst_bray_shaman_beasts",},
			10,
			3
		)

		-- Malagor: Build a Special Herdstone
		_victory_objectives_ie.listeners.bst_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["bst_shared_objective_listeners"] = function(faction_key)

		-- Khazrak, Taurox, Morghur, Malagor: Build a Special Herdstone to level 5 for short victory
		-- Taurox, Morghur: Build 5 Special Herdstones for long victory
		-- Malagor: Build 3 Special Herdstones for long victory
		local herdstone_region_key_list = {
			"wh3_main_combi_region_altdorf",
			"wh3_main_combi_region_black_crag",
			"wh3_main_combi_region_castle_drakenhof",
			"wh3_main_combi_region_couronne",
			"wh3_main_combi_region_hexoatl",
			"wh3_main_combi_region_karaz_a_karak",
			"wh3_main_combi_region_kislev",
			"wh3_main_combi_region_lothern",
			"wh3_main_combi_region_naggarond",
			"wh3_main_combi_region_the_oak_of_ages",
			"wh3_main_combi_region_wei_jin",
			"wh3_main_combi_region_zharr_naggrund",
		}
		local required_herdstones_per_faction_long_victory = {
			["wh2_dlc17_bst_taurox"] = 3,
			["wh_dlc05_bst_morghur_herd"] = 5,
			["wh2_dlc17_bst_malagor"] = 3,
		}

		-- Update UI state after load
		local short_victory_special_herdstone_built_in_regions = cm:get_saved_value("short_victory_special_herdstone_built_in_regions") or {}
		local long_victory_special_herdstones_built_in_regions = cm:get_saved_value("long_victory_special_herdstones_built_in_regions") or {}
		update_mission_entity_completion_states(herdstone_region_key_list, short_victory_special_herdstone_built_in_regions, "region_key", "wh_main_short_victory", "wh3_dlc29_bst_construct_special_herdstone_short")
		if required_herdstones_per_faction_long_victory[faction_key] then
			update_mission_entity_completion_states(herdstone_region_key_list, long_victory_special_herdstones_built_in_regions, "region_key", "wh_main_long_victory", "wh3_dlc29_bst_construct_special_herdstone_long")
		end

		-- Short VC: 1 Herdstone at level 5
		core:add_listener(
			"IEVictoryConditionBeastmenBuildSpecialHerdstone",
			"BuildingCompleted",
			function(context)
				return context:building():faction():name() == faction_key and string.starts_with(context:building():name(), "wh2_dlc17_bst_special_settlement_")
			end,
			function(context)
				local short_victory_special_herdstone_built_in_regions = cm:get_saved_value("short_victory_special_herdstone_built_in_regions") or {}
				local region_key = context:building():region():name()
				local building_level = context:building():building_level()

				if building_level >= 4 then
					if not table.contains(short_victory_special_herdstone_built_in_regions, region_key) then
						cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_bst_construct_special_herdstone_short", true)
						table.insert(short_victory_special_herdstone_built_in_regions, region_key)
						cm:set_saved_value("short_victory_special_herdstone_built_in_regions", short_victory_special_herdstone_built_in_regions)
						update_mission_entity_completion_states(herdstone_region_key_list, short_victory_special_herdstone_built_in_regions, "region_key", "wh_main_short_victory", "wh3_dlc29_bst_construct_special_herdstone_short")
					end
				end
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionBeastmenCaptureSpecialHerdstone",
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				return region:owning_faction():name() == faction_key and table.contains(herdstone_region_key_list, region:name())
			end,
			function(context)
				local region_key = context:region():name()

				-- Short VC: 1 Herdstone at level 4
				if Ruination.herdstone_upgrade_ritual_progress[faction_key] >= 4 then
					local short_victory_special_herdstone_built_in_regions = cm:get_saved_value("short_victory_special_herdstone_built_in_regions") or {}
					if not table.contains(short_victory_special_herdstone_built_in_regions, region_key) then
						cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_bst_construct_special_herdstone_short", true)
						table.insert(short_victory_special_herdstone_built_in_regions, region_key)
						cm:set_saved_value("short_victory_special_herdstone_built_in_regions", short_victory_special_herdstone_built_in_regions)
						update_mission_entity_completion_states(herdstone_region_key_list, short_victory_special_herdstone_built_in_regions, "region_key", "wh_main_short_victory", "wh3_dlc29_bst_construct_special_herdstone_short")
					end
				end

				-- Long VC: 5 Herdstones at any level
				if required_herdstones_per_faction_long_victory[faction_key] then
					local long_victory_special_herdstones_built_in_regions = cm:get_saved_value("long_victory_special_herdstones_built_in_regions") or {}
					if not table.contains(long_victory_special_herdstones_built_in_regions, region_key) then
						cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_bst_construct_special_herdstone_long", 1)
						table.insert(long_victory_special_herdstones_built_in_regions, region_key)
						cm:set_saved_value("long_victory_special_herdstones_built_in_regions", long_victory_special_herdstones_built_in_regions)
						update_mission_entity_completion_states(herdstone_region_key_list, long_victory_special_herdstones_built_in_regions, "region_key", "wh_main_long_victory", "wh3_dlc29_bst_construct_special_herdstone_long")
					end
				end
			end,
			true
		)

	end,

----- LIZARDMEN -----

	-- Mazdamundi
	["wh2_main_lzd_hexoatl"] = function(faction_key)

		-- Mazdamundi: Build landmark: Stellar Pyramids of the Southern Skies for Short Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildItzaLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_lzd_hexoatl_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_hexoatl",
			{"wh2_main_special_hexoatl_stellar_pyramids"}
		)

		-- Mazdamundi: Build The Emerald Pools and The Vault of the Old Ones in Itza for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildItzaLandmarksLong",
			"wh_main_long_victory",
			"wh3_dlc29_lzd_construct_landmark_buldings_in_region",
			faction_key,
			"wh3_main_combi_region_itza",
			{"wh2_main_special_itza_emerald_pools", "wh2_main_special_itza_vaults_of_the_old_ones"}
		)

		-- Mazdamundi: Unlock Lord Kroak
		_victory_objectives_ie.listeners.lzd_shared_objective_listeners(faction_key)
	end,

	-- Kroq-Gar
	["wh2_main_lzd_last_defenders"] = function(faction_key)

		-- Kroq-Gar: Build Landmark: Golden Tower of the Gods for Short Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionKroqgarBuildLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_lzd_kroqgar_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_the_golden_tower",
			{"wh2_main_special_golden_tower_of_the_gods_lzd"}
		)

		-- Kroq-Gar: Unlock Lord Kroak
		_victory_objectives_ie.listeners.lzd_shared_objective_listeners(faction_key)
	end,

	-- Tiqtaqto
	["wh2_main_lzd_tlaqua"] = function(faction_key)

		-- Tiqtaqto: Recruit 5 Flying units (Ripperdactyl Riders, Terradon Riders, Coatl) and get them to rank 6 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionLzdRankUpNUnits",
			"wh_main_short_victory",
			"wh3_dlc29_lzd_recruit_n_flying_units_short",
			faction_key,
			{"wh2_dlc12_lzd_cav_ripperdactyl_riders_0", "wh2_main_lzd_cav_terradon_riders_0", "wh2_dlc17_lzd_mon_coatl_0"},
			6
		)
	end,

	-- Tehenhauin
	["wh2_dlc12_lzd_cult_of_sotek"] = function(faction_key)

		-- Tehenhauin: Build The Emerald Pools and The Vault of the Old Ones in Itza for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildItzaLandmarks",
			"wh_main_long_victory",
			"wh3_dlc29_lzd_construct_landmark_buldings_in_region",
			faction_key,
			"wh3_main_combi_region_itza",
			{"wh2_main_special_itza_emerald_pools", "wh2_main_special_itza_vaults_of_the_old_ones"}
		)

		-- Tehenhauin: Complete Stage 1 of the Prophecy of Sotek
		core:add_listener(
			"IEVictoryConditionTehenhauinProphecyCompleted",
			"ScriptEventPoSStage1Completed",
			true,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "prophecy_of_sotek_1", true)
			end,
			true
		)

		-- Tehenhauin: Complete Stage 3 of the Prophecy of Sotek
		core:add_listener(
			"IEVictoryConditionTehenhauinProphecyCompleted",
			"ScriptEventSacrificeTier5Unlocked",
			true,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "prophecy_of_sotek_3", true)
			end,
			true
		)

		_victory_objectives_ie.listeners.lzd_shared_objective_listeners(faction_key)
	end,

	-- Nakai
	["wh2_dlc13_lzd_spirits_of_the_jungle"] = function(faction_key)

		-- Nakai: Have 5 temples dedicated to an Old One
		local nakai_required_temples = 5
		core:add_listener(
			"IEVictoryConditionNakaiGain5Temples",
			"ScriptEventNakaiTempleCountUpdate",
			true,
			function(context)
				if context.number >= nakai_required_temples then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_gain_5_nakai_temples", true)
					core:remove_listener("IEVictoryConditionNakaiGain5Temples")
				end
			end,
			true
		)

		-- Warning:
		-- Following Nakai listeners were transfered from old Victory Conditions script in order to fully disable its listeners.
		-- Ideally this should not be here but Nakai doesn't have dedicated script to put this in.

		-- Trigger dilemma for Nakai if he completes his short objective and Skrolk is still alive 
		local pestilens_faction_key = "wh2_main_skv_clan_pestilens"
		core:add_listener(
			"IEVictoryConditionNakaiShortVictoryDilemma",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key() == "wh_main_short_victory" and not cm:get_faction(pestilens_faction_key):is_dead()
			end,
			function()
				cm:trigger_dilemma(faction_key, "wh3_dlc21_lzd_lingering_pestilence_dilemma_nakai")
			end,
			false
		)

		-- Nakai chooses the dilemma option to spawn an army
		core:add_listener(
			"IEVictoryConditionNakaiDilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == "wh3_dlc21_lzd_lingering_pestilence_dilemma_nakai" and context:choice() == 0
			end,
			function(context)
				local units = "wh2_main_lzd_inf_saurus_spearmen_1,wh2_main_lzd_inf_saurus_spearmen_1,wh2_main_lzd_mon_kroxigors,wh2_main_lzd_mon_kroxigors,wh2_main_lzd_inf_saurus_warriors_1,wh2_main_lzd_inf_saurus_warriors_0,wh2_main_lzd_inf_saurus_warriors_0,wh2_main_lzd_inf_skink_cohort_1,wh2_main_lzd_inf_skink_cohort_1,wh2_main_lzd_mon_stegadon_1,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_bastiladon_2"
				
				local agents = {
					wh2_main_lzd_saurus_scar_veteran = "champion",
					wh2_main_lzd_skink_chief = "spy",
					wh2_main_lzd_skink_priest_heavens = "wizard",
				}
				
				if cm:get_faction(faction_key):at_war_with(cm:get_faction(pestilens_faction_key)) == false then
					cm:force_declare_war(faction_key, pestilens_faction_key, false, false)
				end
				
				local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, "wh3_main_combi_region_itza", false, true, 10)
				
				cm:create_force(
					faction_key,
					units,
					"wh3_main_combi_region_itza",
					pos_x,
					pos_y,
					false,
					function(cqi)
						local force = cm:get_character_by_cqi(cqi):military_force()
						
						for subtype, type in pairs(agents) do
							local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, "wh3_main_combi_region_itza", false, true, 10)
							local agent = cm:create_agent(faction_key, type, subtype, agent_x, agent_y)
							cm:add_agent_experience(cm:char_lookup_str(agent:command_queue_index()), cm:random_number(16, 10), true)
							cm:embed_agent_in_force(agent, force)
						end
						
						local character = cm:char_lookup_str(cqi)
						
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 8)
						cm:add_experience_to_units_commanded_by_character(character, 7)
						cm:add_growth_points_to_horde(force, 8)
						
						cm:add_building_to_force(force:command_queue_index(), 
							{
								"wh2_dlc13_horde_lizardmen_ziggurat_minor_1",
								"wh2_dlc13_horde_lizardmen_support_upkeep_1",
								"wh2_dlc13_horde_lizardmen_portal_quetzl_1" 
							}
						)
					end
				)
			end,
			true
		)
	end,

	-- Gor-Rok
	["wh2_main_lzd_itza"] = function(faction_key)

		-- Gor-Rok: Build The Emerald Pools in Itza, The Serpent Lairs of Sotek in Quetza for Short Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionLzdGorrokBuildLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_lzd_kroq_construct_landmark_buldings_short",
			faction_key,
			{
				wh3_main_combi_region_itza = "wh2_main_special_itza_emerald_pools",
				wh3_main_combi_region_quetza = "wh2_main_special_quetza_serpent_lairs",
			}
		)

		-- Gor-Rok: Build Temple of Mists, Vault of the old ones for Long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionLzdGorrokBuildLandmarksLong",
			"wh_main_long_victory",
			"wh3_dlc29_lzd_kroq_construct_landmark_buldings_long",
			faction_key,
			{
				wh3_main_combi_region_itza = "wh2_main_special_itza_vaults_of_the_old_ones",
				wh3_main_combi_region_xlanhuapec = "wh2_main_special_xlanhuapec_temple_of_mists",
			}
		)

		-- Gor-Rok: Cast Deliverance of Itza 20 times with Lord Kroak
		core:add_listener(
			"IEVictoryConditionDeliveranceOfItzaCasted",
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle()
				local gorrok_faction_key_cqi = cm:get_faction(faction_key):command_queue_index()
				return pb:has_been_fought()
						and cm:pending_battle_cache_faction_is_involved(faction_key)
						and (	pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_1") > 0
						or 		pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_2") > 0
						or 		pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_3") > 0)
			end,
			function()
				local pb = cm:model():pending_battle()
				local gorrok_faction_key_cqi = cm:get_faction(faction_key):command_queue_index()
				local current_spell_casts_amount =  pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_1")
													+ pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_2")
													+ pb:get_how_many_times_ability_has_been_used_in_battle(gorrok_faction_key_cqi, "wh2_dlc12_spell_kroak_deliverance_of_itza_3")
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cast_20_deliverance_of_itza", current_spell_casts_amount)
			end,
			true
		)
	end,

	-- Oxyotl
	["wh2_dlc17_lzd_oxyotl"] = function(faction_key)


		local oxyotl_silent_sanctum_region_groups_to_consider = {
			"cai_region_hint_area_athel_loren",
			"cai_region_hint_area_badlands",
			"cai_region_hint_area_border_princes",
			"cai_region_hint_area_bretonnia",
			"cai_region_hint_area_cathay",
			"cai_region_hint_area_chaos_wastes",
			"cai_region_hint_area_darklands",
			"cai_region_hint_area_dwarf_empire",
			"cai_region_hint_area_empire",
			"cai_region_hint_area_kislev",
			"cai_region_hint_area_lustria",
			"cai_region_hint_area_mountains_of_mourn",
			"cai_region_hint_area_naggarond",
			"cai_region_hint_area_norsca",
			"cai_region_hint_area_southern_wastes",
			"cai_region_hint_area_southlands",
			"cai_region_hint_area_ulthuan",
		}

		local oxyotl_silent_sanctum_ritual_key = "wh2_dlc17_lzd_ritual_unlock_silent_sanctum"

		-- Oxyotl: Build 10 Silent Sanctums for short victory
		core:add_listener(
			"IEVictoryConditionSilentSanctumConstructed",
			"RitualCompletedEvent",
			function(context)
				return context:succeeded() and oxyotl_silent_sanctum_ritual_key == context:ritual():ritual_key()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_build_10_silent_sanctums", 1)
			end,
			true
		)

		-- Oxyotl: Build a Silent Sanctums in any 6 of these regions for long victory
		local silent_sanctum_regions_long_victory = {
			{region_key = "wh3_main_combi_region_altdorf",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_black_crag",			ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_castle_drakenhof",		ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_couronne",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_hexoatl",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_karaz_a_karak",		ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_kislev",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_lothern",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_naggarond",			ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_the_oak_of_ages",		ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_wei_jin",				ritual_key = oxyotl_silent_sanctum_ritual_key},
			{region_key = "wh3_main_combi_region_zharr_naggrund",		ritual_key = oxyotl_silent_sanctum_ritual_key},
		}

		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS(
			"IEVictoryConditionLzdOxyotlBuildSanctums",
			"wh_main_long_victory",
			"wh3_dlc29_lzd_oxyotl_build_silent_sactums_in_regions_long",
			faction_key,
			silent_sanctum_regions_long_victory,
			6,
			true
		)
	end,

	-- Shared
	["lzd_shared_objective_listeners"] = function(faction_key)

		-- Mazdamundi, Kroq-Gar, Tehenhauin: Unlock Lord Kroak for short victory
		core:add_listener(
			"IEVictoryConditionUnlockKroak",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():find("lord_kroak")
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh2_main_lzd_unlock_lord_kroak_short", true)
			end,
			true
		)
	end,

----- HIGH ELF -----

	-- Tyrion
	["wh2_main_hef_eataine"] = function(faction_key)

		-- Tyrion: Construct landmarks: Upgrade Gates of Lothern for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefTyrinBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_hef_construct_lothern_landmark",
			faction_key,
			"wh3_main_combi_region_lothern",
			{"wh2_main_special_lothern_port_3"}
		)

		-- Tyrion: Perform 10/20 Champion of Ulthuan Actions for short/long victory
		core:add_listener(
			"IEVictoryConditionChampionsOfUlthuanCompletion",
			"RitualCompletedEvent",
			function(context)
				local category = context:ritual():ritual_category()
				local tyrion_ritual_categories = {
					"TYRION_IMPERATIVE_ALLIANCE",
					"TYRION_IMPERATIVE_HEIR",
				}
				return table.contains(tyrion_ritual_categories, category)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tyrion_champions_of_ulthuan_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tyrion_champions_of_ulthuan_long", 1)
			end,
			true
		)

		-- Tyrion: Confederate at least one other High Elf faction
		core:add_listener(
			"IEVictoryConditionConfederateAtleast1Hef",
			"FactionJoinsConfederation",
			function(context)
				local hef_subculture_key = "wh2_main_sc_hef_high_elves"
				return context:confederation():name() == faction_key and context:faction():subculture() == hef_subculture_key
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_tyrion_confederate_atleast_1_hef", true)
			end,
			true
		)
		-- Tyrion: Construct landmarks: Upgrade Gates of Lothern for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefTyrinBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_hef_tyrion_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_lothern",
			{"wh2_main_special_phoenix_king_court"}
		)

		-- Tyrion: Spend at least 2000 Influence (which is not pooled resource)
		-- Tyrion: Hold the Eataine Patron seat and fully upgrade it
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Teclis
	["wh2_main_hef_order_of_loremasters"] = function(faction_key)

		-- Teclis: Construct landmark: Great Waystone at Fortress of Dawn for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefTeclisConstructLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_hef_teclis_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_fortress_of_dawn",
			{"wh3_dlc27_hef_special_colony_fortress_of_dawn"}
		)

		local teclis_ritual_categories = {
			"SWT_BEING",
			"SWT_BRILLIANCE",
			"SWT_DARKNESS",
			"SWT_LOREMASTER",
			"SWT_OBLIVION",
		}

		local teclis_mage_summon_rituals = {
			"wh3_dlc27_secrets_of_the_white_tower_being_summon_beasts",
			"wh3_dlc27_secrets_of_the_white_tower_being_summon_life",
			"wh3_dlc27_secrets_of_the_white_tower_brilliance_summon_heavens",
			"wh3_dlc27_secrets_of_the_white_tower_brilliance_summon_light",
			"wh3_dlc27_secrets_of_the_white_tower_darkness_summon_death",
			"wh3_dlc27_secrets_of_the_white_tower_darkness_summon_shadows",
			"wh3_dlc27_secrets_of_the_white_tower_high_loremaster_summon_high",
			"wh3_dlc27_secrets_of_the_white_tower_oblivion_summon_fire",
			"wh3_dlc27_secrets_of_the_white_tower_oblivion_summon_metal",
		}

		-- Teclis: Perform 12/24 Secrets of the White Tower Actions for short/long victory
		core:add_listener(
			"IEVictoryConditionTeclisSecretsOfTheWhiteTower",
			"RitualCompletedEvent",
			function(context)
				local category = context:ritual():ritual_category()
				return table.contains(teclis_ritual_categories, category)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_perform_secrets_of_white_tower_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_perform_secrets_of_white_tower_actions_long", 1)
			end,
			true
		)

		-- Teclis: Recruit 2 Mages using the Secrets of the White Tower action and increase their rank to rank 15 for short victory
		local required_mage_rank = 15
		local required_mages_total = 2

		local function update_rank_up_agents_objective(character_obj)
			if character_obj:rank() >= required_mage_rank then
				local ranked_up_agent_fm_list = cm:get_saved_value("VictoryConditionsTeclisWhiteTowerMagesFmListRankedUp") or {}
				local agent_fm_cqi = character_obj:family_member():command_queue_index()
				if not table.contains(ranked_up_agent_fm_list, agent_fm_cqi) then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_recruit_mages_with_secrets_of_white_tower", 1)
					table.insert(ranked_up_agent_fm_list, agent_fm_cqi)
					cm:set_saved_value("VictoryConditionsTeclisWhiteTowerMagesFmListRankedUp", ranked_up_agent_fm_list)
				end

				if table.size(ranked_up_agent_fm_list) >= required_mages_total then
					core:remove_listener("IEVictoryConditionTeclisRankUpWhiteTowerMagesStoreCharacters")
					core:remove_listener("IEVictoryConditionTeclisRankUpWhiteTowerMagesRankUp")
				end
			end
		end

		-- Store FM cqi of each mage summoned from Secrets of White Tower
		core:add_listener(
			"IEVictoryConditionTeclisRankUpWhiteTowerMagesStoreCharacters",
			"ScriptEventVictoryConditionWhiteTowerMageRecruited",
			true,
			function(context)
				local new_mage_character_obj = cm:get_character_by_cqi(context.number)
				local mages_fm_cqi_list = cm:get_saved_value("VictoryConditionsTeclisWhiteTowerMagesFmList") or {}
				local new_mage_fm_cqi = new_mage_character_obj:family_member():command_queue_index()
				table.insert(mages_fm_cqi_list, new_mage_fm_cqi)
				cm:set_saved_value("VictoryConditionsTeclisWhiteTowerMagesFmList", mages_fm_cqi_list)
				-- Check if newly recruited mage already has high enough rank to trigger the condition
				update_rank_up_agents_objective(new_mage_character_obj)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionTeclisRankUpWhiteTowerMagesRankUp",
			"CharacterRankUp",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local agent_obj = context:character()
				local agent_fm_cqi = agent_obj:family_member():command_queue_index()
				local mages_fm_cqi_list = cm:get_saved_value("VictoryConditionsTeclisWhiteTowerMagesFmList") or {}
				if table.contains(mages_fm_cqi_list, agent_fm_cqi) then
					update_rank_up_agents_objective(agent_obj)
				end
			end,
			true
		)

		-- Teclis: Get 3 Mages to Rank 25 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionTeclisMagesRankUpLong",
			"wh_main_long_victory",
			"wh3_dlc29_hef_teclis_rankup_mages_long",
			faction_key,
			{"wh2_dlc10_hef_mage_heavens",
			"wh2_dlc10_hef_mage_shadows",
			"wh2_dlc15_hef_mage_beasts",
			"wh2_dlc15_hef_mage_death",
			"wh2_dlc15_hef_mage_fire",
			"wh2_dlc15_hef_mage_metal",
			"wh2_main_hef_mage_high",
			"wh2_main_hef_mage_life",
			"wh2_main_hef_mage_light",},
			25,
			3
		)

		-- Teclis: Recruit a Mage from each lore of magic for long victory
		core:add_listener(
			"IEVictoryConditionTeclisRecruitEachSchoolMage",
			"RitualCompletedEvent",
			function(context)
				local ritual_key = context:ritual():ritual_key()
				local category = context:ritual():ritual_category()
				local teclis_summoned_mages_of_school = cm:get_saved_value("teclis_summoned_mages_of_school") or {}
				-- Ritual is mage summoning and Ritual School was not previously used
				return table.contains(teclis_mage_summon_rituals, ritual_key) and
					not table.contains(teclis_summoned_mages_of_school, category)
			end,
			function(context)
				local teclis_summoned_mages_of_school = cm:get_saved_value("teclis_summoned_mages_of_school") or {}
				table.insert(teclis_summoned_mages_of_school, context:ritual():ritual_category())
				cm:set_saved_value("teclis_summoned_mages_of_school", teclis_summoned_mages_of_school)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_recruit_each_school_mage_with_secrets_of_white_tower", 1)
			end,
			true
		)

		-- Teclis: Spend at least 2000 Influence (which is not pooled resource)
		-- Teclis: Hold at least one Patron seat on Ulthuan and fully upgrade it
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Alarielle
	["wh2_main_hef_avelorn"] = function(faction_key)

		-- Alarielle: Construct Landmark: The World Root Entrance for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefAlarielleBuildLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_hef_construct_gaean_vale_landmark",
			faction_key,
			"wh3_main_combi_region_gaean_vale",
			{"wh2_dlc10_special_world_root_entrance_3"}
		)

		-- Alarielle: Own two Wood Elf settlements through ownership or alliance
		local wood_elf_subculture = "wh_dlc05_sc_wef_wood_elves"

		-- When region changes faction
		core:add_listener(
			"IEVictoryConditionOwnWoodElfSettlements",
			"RegionFactionChangeEvent",
			function(context)
				local alarielle_owned_wood_elf_regions = cm:get_saved_value("alarielle_owned_wood_elf_regions") or {}
				return wood_elf_subculture == context:previous_faction():subculture()
						and faction_key == context:region():owning_faction():name()
						and not table.contains(alarielle_owned_wood_elf_regions, context:region():name())
			end,
			function(context)
				local alarielle_owned_wood_elf_regions = cm:get_saved_value("alarielle_owned_wood_elf_regions") or {}
				table.insert(alarielle_owned_wood_elf_regions, context:region():name())
				cm:set_saved_value("alarielle_owned_wood_elf_regions", alarielle_owned_wood_elf_regions)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_own_N_wood_elf_settlements", 1)
			end,
			true
		)

		-- When Wood Elf becomes vassal
		core:add_listener(
			"IEVictoryConditionOwnWoodElfSettlements",
			"FactionBecomesVassal",
			function(context)
				return wood_elf_subculture == context:vassal():subculture() and context:vassal():is_vassal_of(faction_key)
			end,
			function(context)
				local new_gained_regions = 0
				local alarielle_owned_wood_elf_regions = cm:get_saved_value("alarielle_owned_wood_elf_regions") or {}
				for i = 0, #context:vassal():region_list():num_items() - 1 do
					local current_region = context:vassal():region_list():item_at(i):name()
					if not table.contains(alarielle_owned_wood_elf_regions, current_region) then
						new_gained_regions = new_gained_regions + 1
						table.insert(alarielle_owned_wood_elf_regions, current_region)
						cm:set_saved_value("alarielle_owned_wood_elf_regions", alarielle_owned_wood_elf_regions)
					end
				end
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_own_N_wood_elf_settlements", new_gained_regions)
			end,
			true
		)
		-- Alarielle: Construct Landmark: The World Root Entrance for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefAlarielleBuildLandmarksLong",
			"wh_main_long_victory",
			"wh3_dlc29_hef_alarielle_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_gaean_vale",
			{"wh2_main_special_everqueen_court_hef"}
		)
		-- Alarielle: Spend at least 2000 Influence (which is not pooled resource)
		-- Alarielle: Hold the Gaean Vale Patron Seat and have it fully upgraded
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Alith
	["wh2_main_hef_nagarythe"] = function(faction_key)

		-- Alith: Eliminate 3/10 marked characters for short/long victory
		core:add_listener(
			"IEVictoryConditionEliminateMarkedCharacters",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():starts_with("wh2_dlc10_alith_anar_assassination")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_alith_assasinate_targets_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_alith_assasinate_targets_long", 1)
			end,
			true
		)

		-- Alith: Spend at least 2000 Influence (which is not pooled resource)
		-- Alith: Hold Nagarythe Patron Seat and fully upgrade it
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Eltharion
	["wh2_main_hef_yvresse"] = function(faction_key)

		-- Eltharion: Construct Landmark: Warworn Stronghold for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionHefEltharionConstructLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_hef_eltharion_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_gronti_mingol",
			{"wh3_dlc27_hef_special_colony_gronti_mingol"}
		)

		-- Eltharion: Upgrade Athel Tamarha 5 Times using Warden?s Supplies for short victory
		-- Eltharion: Upgrade all of Athel Tamarha Facilities to maximum using Warden Supplies
		core:add_listener(
			"IEVictoryConditionEltharionTamarhaUpgrade",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "ATHEL_TAMARHA_RITUAL"
			end,
			function()
				-- Player facing condition is 5 for short and 15 for long, but +8 is added to each counter to accomadate for eight the rank 1 'ruined' rituals that are completed on campaign start
				local athel_tamarha_upgrade_count = cm:get_saved_value("eltharion_tamarha_upgrades_count") or 0
				athel_tamarha_upgrade_count = athel_tamarha_upgrade_count +1
				cm:set_saved_value("eltharion_tamarha_upgrades_count", athel_tamarha_upgrade_count)
				if  athel_tamarha_upgrade_count >= 23 then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_athel_tamarha_max_upgrades_long_victory", true)
				elseif athel_tamarha_upgrade_count == 13 then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_athel_tamarha_upgrades_short_victory", true)
				end
			end,
			true
		)

		-- Eltharion: Spend at least 2000 Influence (which is not pooled resource)
		-- Eltharion: Hold two patron seats with one fully upgraded
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Imrik
	["wh2_dlc15_hef_imrik"] = function(faction_key)

		-- Tyrion: Construct Purified Graves of the Dragon in following region for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildImrikLandmark",
			"wh_main_long_victory",
			"wh3_dlc29_hef_construct_dragon_graveyard_landmark",
			faction_key,
			"wh3_main_combi_region_the_bone_gulch",
			{"wh2_dlc15_special_graves_of_the_dragons_2_hef"}
		)

		--Imrik: Encounter 2/5 Legendary Dragons for short/long victory
		core:add_listener(
			"IEVictoryConditionImrikDragonEncounterFinished",
			"DilemmaIssuedEvent",
			function(context)
				return context:faction():name() == faction_key and context:dilemma():starts_with("wh2_dlc15_dilemma_dragon_encounter_special_")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_imrik_encounter_legendary_dragons_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_imrik_encounter_legendary_dragons_long", 1)
			end,
		true
		)

		-- Imrik: Spend at least 2000 Influence (which is not pooled resource)
		-- Imrik: Hold at least one Patron seat on Ulthuan and fully upgrade it
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Aislinn
	["wh3_dlc27_hef_aislinn"] = function(faction_key)

		-- Aislinn: Unlock 3 Dragonships
		core:add_listener(
			"IEVictoryConditionAislinnDragonShipUnlocked",
			"ScriptEventNewDragonShipUnlocked",
			true,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_aislinn_unlock_drahonship_short", 1)
			end,
			true
		)

		local aislinn_colonise_options = {
			["1212349371"] = true,
			["556969995"] = true,
			["1044297972"] = true,
			["1156478547"] = true,
			["1636165653"] = true,
			["1545063178"] = true,
		}

		local aislinn_gift_options = {
			["2050244199"] = true,
			["96128829"] = true
		}

		-- Aislinn: Estabslish 3 Colonies
		core:add_listener(
			"IEVictoryConditionAislinnEstablsihColonies",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local colonise_or_gift = aislinn_colonise_options[context:occupation_decision()] or aislinn_gift_options[context:occupation_decision()]
				return context:character():faction():name() == faction_key and colonise_or_gift
			end,
			function(context)
				if aislinn_colonise_options[context:occupation_decision()] then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_aislinn_establish_colonies_short", 1)
				elseif aislinn_gift_options[context:occupation_decision()] then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_aislinn_gift_colonies_short", 1)
				end
			end,
			true
		)

		-- Aislinn: Spend at least 2000 Influence (which is not pooled resource)
		_victory_objectives_ie.listeners.hef_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["hef_shared_objective_listeners"] = function(faction_key)

		-- Tyrion, Teclis, Alarielle, Alith, Eltharion, Imrik, Aislinn: Spend at least 2000 Influence (which is not pooled resource) for long victory
		core:add_listener(
			"IEVictoryConditionSpend2000Influence" .. faction_key,
			"InfluenceChangedEvent",
			true,
			function(context)
				local amount_changed = context:amount()
				if amount_changed < 0 then
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_spend_2000_influence_" .. faction_key, (0 - amount_changed))
				end
			end,
			true
		)

		-- Short Victory
		-- Tyrion: Hold the Eataine Patron seat and fully upgrade it
		-- Teclis: Hold at least one Patron seat on Ulthuan and fully upgrade it
		-- Alarielle: Hold the Gaean Vale Patron Seat and have it fully upgraded
		-- Alith: Hold Nagarythe Patron Seat and fully upgrade it
		-- Eltharion: Hold two patron seats with one fully upgraded
		-- Imrik: Hold at least one Patron seat on Ulthuan and fully upgrade it
		local patron_seats_conditions = {
			{	faction_key = "wh2_main_hef_eataine",
				script_key = "wh3_dlc29_hold_and_upgrade_eataine_patron_seat",
				amount_of_seats = 1,
				specific_seat_province_key = "wh3_main_combi_province_eataine"
			},
			{	faction_key = "wh2_main_hef_order_of_loremasters",
				script_key = "wh3_dlc29_hold_and_upgrade_any_patron_seat",
				amount_of_seats = 1
			},
			{	faction_key = "wh2_main_hef_avelorn",
				script_key = "wh3_dlc29_hold_and_upgrade_gaean_vale_patron_seat",
				amount_of_seats = 1,
				specific_seat_province_key = "wh3_main_combi_province_avelorn"
			},
			{	faction_key = "wh2_main_hef_nagarythe",
				script_key = "wh3_dlc29_hold_and_upgrade_nagarythe_patron_seat",
				amount_of_seats = 1,
				specific_seat_province_key = "wh3_main_combi_province_nagarythe"
			},
			{	faction_key = "wh2_main_hef_yvresse",
				script_key = "wh3_dlc29_hold_two_patron_seats_with_one_upgraded",
				amount_of_seats = 2
			},
			{	faction_key = "wh2_dlc15_hef_imrik",
				script_key = "wh3_dlc29_hold_and_upgrade_any_patron_seat",
				amount_of_seats = 1
			},
		}

		local patron_associated_provinces = {
			"wh3_main_combi_province_caledor",
			"wh3_main_combi_province_tiranoc",
			"wh3_main_combi_province_avelorn",
			"wh3_main_combi_province_eataine",
			"wh3_main_combi_province_ellyrion",
			"wh3_main_combi_province_chrace",
			"wh3_main_combi_province_nagarythe",
			"wh3_main_combi_province_cothique",
			"wh3_main_combi_province_saphery",
			"wh3_main_combi_province_northern_yvresse",
			"wh3_main_combi_province_southern_yvresse",
		}

		local patron_seat_max_rank = 3

		for i = 1, #patron_seats_conditions do
		if patron_seats_conditions[i].faction_key == faction_key then
			core:add_listener(
				"IEVictoryConditionHEFPatronSeatsUpdate",
				"ScriptEventIEIntrigueAtTheCourtUpdate",
				true,
				function(context)
					local current_patron_seats_conditions = patron_seats_conditions[i]
					local provinces_to_consider = {}
					local occupied_seat_rank_list = {}
					-- If mission objective requires specific patron seat we check only this seat, otherwise we check all of them
					if current_patron_seats_conditions.specific_seat_province_key then
						table.insert(provinces_to_consider, cm:get_province(current_patron_seats_conditions.specific_seat_province_key))
					else
						provinces_to_consider = patron_associated_provinces
					end
					local current_faction_interface = cm:get_faction(patron_seats_conditions[i].faction_key)
					-- Check provinces, get amount of seats occupied and ranks of seats for given faction
					for j = 1, #provinces_to_consider do
						local province_interface = cm:get_province(provinces_to_consider[j])
						local occupying_fm_cqi = hef_intrigue_at_the_court:get_occupying_fm_cqi_for_slot(province_interface)
						if occupying_fm_cqi ~= 0 then
							local occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)
							if not occupying_fm_interface:is_null_interface() then
								if occupying_fm_interface:character_details():faction():name() == current_faction_interface:name() then
									local current_patron_seat_rank = hef_intrigue_at_the_court:get_current_occupied_rank_for_slot(province_interface)
									if current_patron_seat_rank ~= 0 then
										table.insert(occupied_seat_rank_list, current_patron_seat_rank)
									end
								end
							end
						end
					end
					if table.size(occupied_seat_rank_list) >= current_patron_seats_conditions.amount_of_seats and table.contains(occupied_seat_rank_list, patron_seat_max_rank) then
						cm:complete_scripted_mission_objective(current_patron_seats_conditions.faction_key, "wh_main_short_victory", current_patron_seats_conditions.script_key, true)
					end
				end,
				true
			)
		end
		end
	end,

----- DWARF -----

	-- Thorgrim
	["wh_main_dwf_dwarfs"] = function(faction_key)

		-- Thorgrim: Construct the Throne Hall of the High King Landmark building in following region for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildThorgrimLandmark",
			"wh_main_short_victory",
			"wh3_dlc29_dwf_construct_throne_hall_landmark",
			faction_key,
			"wh3_main_combi_region_karaz_a_karak",
			{"wh_main_special_high_king_throne_hall"}
		)

		local legendary_dwarfs_factions = {"wh2_dlc17_dwf_thorek_ironbrow",
											"wh_main_dwf_karak_kadrin",
											"wh3_main_dwf_the_ancestral_throng",
											"wh3_dlc25_dwf_malakai",
											"wh_main_dwf_karak_izor"}

		-- Thorgrim: Confederate at least 2/5 other Dwarf Legendary Lords for short/long victory
		core:add_listener(
			"IEVictoryConditionConfederateLLDwarfs",
			"FactionJoinsConfederation",
			function(context)
				return context:confederation():name() == faction_key and table.contains(legendary_dwarfs_factions, context:faction():name())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_confederate_other_legendary_lord_dwarfs_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_confederate_other_legendary_lord_dwarfs_long", 1)
			end,
			true
		)

		-- Thorgrim: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Thorgrim: Complete a 1/3 Legendary Grudges for short/long victory
		-- Thorgrim: Build Ornate Great Gate for long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Ungrim
	["wh_main_dwf_karak_kadrin"] = function(faction_key)

		-- Ungrim: Maintain 10 Slayer Units at Rank 6 (Slayers, Giant Slayers, Slayer Pirates) for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionDwfRankUpNUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers_short",
			faction_key,
			{"wh2_dlc10_dwf_inf_giant_slayers", "wh3_dlc25_dwf_inf_slayer_pirates", "wh_main_dwf_inf_slayers", "wh3_dlc25_dwf_inf_slayers_grudge_unit"},
			6
		)

		-- Ungrim: Maintain 20 Slayer Units at Rank 6 (Slayers, Giant Slayers, Slayer Pirates) for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionDwfRankUpNUnitsLong",
			"wh_main_long_victory",
			"wh3_dlc29_dwf_ungrim_maintain_n_ranked_slayers_long",
			faction_key,
			{"wh2_dlc10_dwf_inf_giant_slayers", "wh3_dlc25_dwf_inf_slayer_pirates", "wh_main_dwf_inf_slayers", "wh3_dlc25_dwf_inf_slayers_grudge_unit"},
			6
		)

		-- Ungrim: Build Great Slayer Shrine of Karak Kadrin for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildUngrimLandmark",
			"wh_main_short_victory",
			"wh3_dlc29_dwf_construct_slayer_shrine_landmark",
			faction_key,
			"wh3_main_combi_region_karak_kadrin",
			{"wh_main_special_great_slayer_shrine"}
		)

		-- Ungrim: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Ungrim: Complete a 1/3 Legendary Grudges for short/long victory
		-- Ungrim: Build Ornate Great Gate for long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Belegar
	["wh_main_dwf_karak_izor"] = function(faction_key)

		-- Belegar: Build Landmark building Ancestors Tombs at Karak Eight Peaks for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildBelegarLandmark",
			"wh_main_long_victory",
			"wh3_dlc29_construct_belegar_landmark_long",
			faction_key,
			"wh3_main_combi_region_karak_eight_peaks",
			{"wh_dlc06_dwf_eight_peaks_3"}
		)

		-- Belegar: Reach rank 60 accumulatively across Belegar and his Ancestor Heroes. They are all immortal and cannot be disbanded
		-- Collect and store all Belegar unique character to keep track of
		if is_nil(cm:get_saved_value("victory_condition_belegar_characters_fm_cqi_list")) then
			
			local belegar_characters_unique_traits_list = {
				"wh_dlc06_clan_angrund_ancestor_master_engineer",
				"wh_dlc06_clan_angrund_ancestor_runesmith",
				"wh_dlc06_clan_angrund_ancestor_thane",
				"wh_dlc06_clan_angrund_ancestor_thane_other",
			}

			local belegar_faction_obj = cm:get_faction(faction_key)
			local belegar_character_fm_cqi_list = {}
			local belegar_fm_cqi = belegar_faction_obj:faction_leader():family_member():command_queue_index()
			table.insert(belegar_character_fm_cqi_list, belegar_fm_cqi)

			local faction_character_obj_list = belegar_faction_obj:character_list()
			for i = 0, faction_character_obj_list:num_items() - 1 do
				local character_obj = faction_character_obj_list:item_at(i)
				for j = 1, #belegar_characters_unique_traits_list do
					if character_obj:has_trait(belegar_characters_unique_traits_list[j]) then
						table.insert(belegar_character_fm_cqi_list, character_obj:family_member():command_queue_index())
					end
				end
			end

			cm:set_saved_value("victory_condition_belegar_characters_fm_cqi_list", belegar_character_fm_cqi_list)

		end

		core:add_listener(
			"IEVictoryConditionBelegarDwarvesRankUp",
			"CharacterRankUp",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local belegar_character_fm_cqi_list = cm:get_saved_value("victory_condition_belegar_characters_fm_cqi_list")
				if table.contains(belegar_character_fm_cqi_list, context:character():family_member():command_queue_index()) then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_reach_rank_50_with_belegar_and_start_heroes", context:ranks_gained())
				end
			end,
			true
		)

		-- Belegar: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Belegar: Complete a 1/3 Legendary Grudges for short/long victory
		-- Belegar: Build Ornate Great Gate for long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Grombindal
	["wh3_main_dwf_the_ancestral_throng"] = function(faction_key)

		-- Grombindal: Recruit 5 Grudge Settler Units and increase their rank to Rank 6 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionDwfGrombindalRankUpGrudgeSettlers",
			"wh_main_short_victory",
			"wh3_dlc29_dwf_grombindal_rankup_units_short",
			faction_key,
			{"wh_main_dwf_inf_quarrellers_1_grudge_reward",
			"wh_main_dwf_inf_slayers_grudge_reward",
			"wh3_dlc25_dwf_art_grudge_thrower_grudge_reward",
			"wh_main_dwf_inf_longbeards_1_grudge_reward",
			"wh_main_dwf_inf_irondrakes_0_grudge_reward",
			"wh_main_dwf_inf_hammerers_grudge_reward",
			"wh_main_dwf_veh_gyrocopter_1_grudge_reward",
			"wh_main_dwf_art_flame_cannon_grudge_reward"},
			6
		)

		-- Grombindal: Destroy at least 5 of these factions for long victory
		local enemy_faction_list = {
			"wh2_main_def_cult_of_pleasure",
			"wh2_dlc11_def_the_blessed_dread",
			"wh2_twa03_def_rakarth",
			"wh2_main_hef_eataine",
			"wh2_main_hef_order_of_loremasters",
			"wh2_main_hef_avelorn",
			"wh2_main_hef_nagarythe",
			"wh2_main_hef_yvresse",
			"wh2_dlc15_hef_imrik",
			"wh3_dlc27_hef_aislinn",
			"wh_dlc05_wef_wood_elves",
			"wh_dlc05_wef_argwylon",
			"wh2_dlc16_wef_sisters_of_twilight",
			"wh2_dlc16_wef_drycha",
		}

		local min_amount_factions_to_kill = 5

		-- Update UI state after load
		for _ , enemy_faction_key in dpairs(enemy_faction_list) do
			cm:set_scripted_mission_entity_completion_states("wh_main_long_victory", "wh3_dlc29_destroy_at_least_n_factions", {{cm:get_faction(enemy_faction_key), cm:get_faction(enemy_faction_key):is_dead()}})
		end

		core:add_listener(
			"IEVictoryConditionDestroyAtLeastNFactions",
			"FactionDeath",
			function(context)
				return table.contains(enemy_faction_list, context:faction():name())
			end,
			function(context)
				local amount_of_dead_factions = cm:get_saved_value("amount_of_dead_grombindal_enemy_factions_victory_condition") or 0
				amount_of_dead_factions = amount_of_dead_factions + 1
				cm:set_saved_value("amount_of_dead_grombindal_enemy_factions_victory_condition", amount_of_dead_factions)
				cm:set_scripted_mission_entity_completion_states("wh_main_long_victory", "wh3_dlc29_destroy_at_least_n_factions", {{context:faction(), context:faction():is_dead()}})
				if amount_of_dead_factions >= min_amount_factions_to_kill then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_destroy_at_least_n_factions", true)
				end
			end,
			true
		)

		-- Grombindal: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Grombindal: Complete a 1/3 Legendary Grudges for short/long victory
		-- Grombindal: Build Ornate Great Gate for long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Thorek
	["wh2_dlc17_dwf_thorek_ironbrow"] = function(faction_key)

		-- Thorek: Build the Hall of Ancestors Landmark building for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBuildThorekLandmark",
			"wh_main_short_victory",
			"wh3_dlc29_construct_thorek_landmark_short",
			faction_key,
			"wh3_main_combi_region_karak_zorn",
			{"wh3_dlc25_special_ancestors_hall_1"}
		)

		-- Thorek: Reforge Ratons Collar of Bestial Control / Reforge 5 Artefacts for short/long victory
		local specific_artefact_ritual_key = "wh2_dlc17_dwf_ritual_thorek_artifact_1"
		core:add_listener(
			"IEVictoryConditionThorekArtefactsReforged",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "CRAFTING_RITUAL" and context:ritual():ritual_key():starts_with("wh2_dlc17_dwf_ritual_thorek_artifact_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_thorek_reforge_n_artefacts", 1)
				if context:ritual():ritual_key() == specific_artefact_ritual_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_thorek_reforge_raton_collar", true)
				end
			end,
			true
		)

		-- Thorek: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Thorek: Complete a 1/3 Legendary Grudges for short/long victory
		-- Thorek: Build Ornate Great Gate for long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Malakai
	["wh3_dlc25_dwf_malakai"] = function(faction_key)

		-- Malakai: Build Landmark building The Silver Hall for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDwfMalakaiConstructLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_dwf_malakai_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_kraka_drak",
			{"wh2_main_special_silver_hall"}
		)

		local malakai_legendary_battles_list = {
			"wh3_dlc25_mis_dwf_malakai_undead_empowered_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_spider_swarm_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_dragon_hunters_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_narrative_battle_ie",
			"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle_ie",
		}

		-- Malakai: Complete 4/7 Legendary Battles in Malakai?s Adventures for short/long victory
		core:add_listener(
			"IEVictoryConditionMalakaiLegendaryBattles",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and table.contains(malakai_legendary_battles_list, context:mission():mission_record_key())
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_complete_n_malakai_legenday_battles_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_complete_n_malakai_legenday_battles_long", 1)
			end,
			true
		)

		-- Malakai: Finish an Age of Reckoning in Gorm tier two times for short victory
		-- Malakai: Complete a 1/3 Legendary Grudges for short/long victory
		_victory_objectives_ie.listeners.dwf_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["dwf_shared_objective_listeners"] = function(faction_key)

		local gorm_tier = 4

		-- Finish an Age of Reckoning in Gorm tier two times for short victory
		core:add_listener(
			"IEVictoryConditionFinishAgeOfReckoningAtTier4",
			"ScriptEventGrudgeCycleFinished",
			function(context)
				return context.number >= gorm_tier
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_finish_grudge_cycle_in_x_tier_y_times_short", 1)
			end,
			true
		)

		-- Complete a 1/3 Legendary Grudges for short/long victory
		core:add_listener(
			"IEVictoryConditionDwarfsGrudgesCompleted",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():starts_with("wh3_dlc25_grudge_legendary_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_complete_single_legendary_grudge", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_complete_x_legendary_grudges", 1)
			end,
			true
		)

		-- All except Malakai: Build Ornate Great Gate in any of the following unique locations: Karak Eight Peaks, Skavenblight, or Zharr-Naggrund for long victory
		if faction_key ~= "wh3_dlc25_dwf_malakai" then

			local required_regions = {"wh3_main_combi_region_karak_eight_peaks", "wh3_main_combi_region_skavenblight", "wh3_main_combi_region_zharr_naggrund"}
			local required_building = "wh3_main_DWARFS_underdeep_2"

			-- Update UI state after load
			local regions_with_building = cm:get_saved_value("dwarf_ornate_great_gate_regions") or {}
			update_mission_entity_completion_states(required_regions, regions_with_building, "region_key", "wh_main_long_victory", "wh3_dlc29_construct_ornate_great_gate")

			core:add_listener(
				"IEVictoryConditionBuildDeep",
				"BuildingCompleted",
				function(context)
					return context:building():name() == required_building
					and table.contains(required_regions, context:building():region():name())
					and context:building():faction():name() == faction_key
				end,
				function(context)
					local regions_with_building = cm:get_saved_value("dwarf_ornate_great_gate_regions") or {}
					local current_region = context:building():region()
					if not table.contains(regions_with_building, current_region:name()) then
						table.insert(regions_with_building, current_region:name())
						cm:set_scripted_mission_entity_completion_states("wh_main_long_victory", "wh3_dlc29_construct_ornate_great_gate", {{current_region, true}})
						cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_construct_ornate_great_gate", true)
						cm:set_saved_value("dwarf_ornate_great_gate_regions", regions_with_building)
					end
				end,
				true
			)
		end
	end,

----- CHAOS DWARF -----

	-- Astragoth
	["wh3_dlc23_chd_astragoth"] = function(faction_key)

		-- Astragoth: Build Landmark Gromril-Tipped Drill Assembly Line for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionChdAstragothBuildLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_chd_astragoth_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_uzkulak",
			{"wh3_dlc23_special_astragoth_great_drill_of_hashut_3"}
		)

		local astragoth_required_seats = 10
		local chaos_dwarf_culture = "wh3_dlc23_chd_chaos_dwarfs"

		-- Astragoth: Own 10 Seats in the Tower of Zharr for short victory
		-- Astragoth: Unlock the Conclave in Tower of Zharr for long victory
		core:add_listener(
			"IEVictoryConditionAstragothUnlockToZ",
			"RitualCompletedEvent",
			function(context)
				-- Seats can be taken by other chaos dwarf factions so we check for all ToZ rituals and add/subtract seats to/from player seat count
				if context:performing_faction() ~= nil and not context:performing_faction():is_null_interface() then
					if context:performing_faction():culture() == chaos_dwarf_culture and context:ritual():ritual_category():find("DISTRICT") then
						return true
					end
				end
				return false
			end,
			function(context)
				local current_seat_amount = 0
				local stored_seat_amount = cm:get_saved_value("astragoth_amount_of_toz_seats") or 0
				for _ , toz_seat in dpairs(tower_of_zharr.seats) do
					if toz_seat.current_owner == faction_key then
						current_seat_amount = current_seat_amount + 1
					end
				end
				cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_own_n_seats_in_toz_short", "mission_text_text_wh3_dlc29_own_n_seats_in_toz_short", current_seat_amount, astragoth_required_seats)
				cm:set_saved_value("astragoth_amount_of_toz_seats", current_seat_amount)
				if tower_of_zharr.tiers.toz_tier_4.locked_status == false then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_astragoth_unlock_conclave", true)
				end
			end,
			true
		)

		-- Astragoth: Build Landmark building The Great Temple of Hashut for long victory
		_victory_objectives_ie.listeners.chd_shared_objective_listeners(faction_key)
	end,

	-- Drazhoath
	["wh3_dlc23_chd_legion_of_azgorh"] = function(faction_key)

		-- Drazhoath: Construct landmarks: Gromril-Tipped Drill Assembly Line, Infernal Barracks and Karum for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionChdDrazhoathBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_chd_drazhoath_construct_landmarks_short",
			faction_key,
			{
				wh3_main_combi_region_black_fortress = "wh3_dlc23_special_drazhoath_great_drill_of_hashut_3",
				wh3_main_combi_region_the_sentinels = "wh3_dlc23_special_sentinels_trade_station_chd",
			}
		)

		-- Drazhoath: Unlock a Tier 3 Industry District
		core:add_listener(
			"IEVictoryConditionUnlockTier3ToZIndustry",
			"RitualCompletedEvent",
			function(context)
				if context:performing_faction() ~= nil and not context:performing_faction():is_null_interface() then
					if context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "DISTRICTS_INDUSTRY_T3" then
						return true
				 	end
				end
				return false
			end,
			function(context)
				if tower_of_zharr.districts.DISTRICTS_INDUSTRY_T3.complete_status == true then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_drazhoath_unlock_toz_tier3_industry", true)
				end
			end,
			true
		)

		-- Drazhoath: Increase unit capacity 25 times across any unit
		core:add_listener(
			"IEVictoryConditionPerformNHellforgeRituals",
			"RitualCompletedEvent",
			function(context)
				if context:performing_faction() ~= nil and not context:performing_faction():is_null_interface() then
					if context:performing_faction():name() == faction_key and context:ritual():ritual_key():find("wh3_dlc23_chd_ritual_unit_cap") then
						return true
					end
				end
				return false
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_perform_n_hellforge_rituals", 1)
			end,
			true
		)

		-- Drazhoath: Build Landmark building The Great Temple of Hashut for long victory
		_victory_objectives_ie.listeners.chd_shared_objective_listeners(faction_key)
	end,

	-- Zhatan
	["wh3_dlc23_chd_zhatan"] = function(faction_key)

		-- Zhatan: Construct landmarks Gromril-Tipped Drill Assembly Line and Tomb of Khengai Khan for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionChdZhatanBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_chd_zhatan_construct_landmarks_short",
			faction_key,
			"wh3_main_combi_region_the_volary",
			{"wh3_dlc23_special_zhatan_great_drill_of_hashut_3", "wh3_dlc23_special_the_volary_tomb_of_khengai_khan_chd"}
		)

		-- Zhatan: Unlock a Tier 3 Military District for long victory
		core:add_listener(
			"IEVictoryConditionZhatanUnlockTier3ToZMilitary",
			"RitualCompletedEvent",
			function(context)
				if context:performing_faction() ~= nil and not context:performing_faction():is_null_interface() then
					if context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "DISTRICTS_MILITARY_T3" then
						return true
					end
				end
				return false
			end,
			function(context)
				if tower_of_zharr.districts.DISTRICTS_MILITARY_T3.complete_status == true then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_zhatan_unlock_toz_tier3_military", true)
				end
			end,
			true
		)

		-- Zhatan: Complete 6 convoy journeys for short victory
		core:add_listener(
			"IEVictoryConditionZhatanCompleteNConvoys",
			"ScriptEventCaravanCompleted",
			function(context)
				return faction_key == context:faction():name()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_zhatan_complete_n_convoys", 1)
			end,
			true
		)

		-- Zhatan: Gain 15000/30000 labour accumulatively over time for short/long victory
		local chd_labour_pooled_resource_key = "wh3_dlc23_chd_labour"
		local chd_labour_pooled_resource_moved_factor_key = "wh3_dlc23_chd_labour_moved"
		core:add_listener(
			"IEVictoryConditionZhatanAccumulateLabour",
			"PooledResourceChanged",
			function(context)
				if context:has_faction() == true and faction_key == context:faction():name()  then
					if context:resource():key() == chd_labour_pooled_resource_key and context:amount() > 0 then
						if not context:factor():is_null_interface() and context:factor():key() ~= chd_labour_pooled_resource_moved_factor_key then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_zhatan_gain_n_labour_short", context:amount())
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_zhatan_gain_n_labour_long", context:amount())
			end,
			true
		)

		-- Zhatan: Build Landmark building The Great Temple of Hashut for long victory
		_victory_objectives_ie.listeners.chd_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["chd_shared_objective_listeners"] = function(faction_key)

		-- Astragoth, Zhatan, Drazhoath: Build Landmark building The Great Temple of Hashut for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionChdBuildLandmarkLong" .. faction_key,
			"wh_main_long_victory",
			"wh3_dlc29_chd_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_zharr_naggrund",
			{"wh3_dlc23_special_great_temple_of_hashut_chd"}
		)
	end,

----- BRETONNIA -----

	-- Louen
	["wh_main_brt_bretonnia"] = function(faction_key)

		-- Louen: Construct Special Landmark Couronne Tournament Grounds for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBrtBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_brt_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_couronne",
			{"wh_main_special_tournament_grounds"}
		)

		-- Louen: Construct Special Landmark Abbey of the Grail Companions for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBrtBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_brt_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_couronne",
			{"wh_main_brt_legendary_grail_abbey"}
		)

		-- Reach Honourable/Chivalrous Chivalry Level for short/long victory
		-- Complete the final Errantry War Battle
		_victory_objectives_ie.listeners.brt_shared_objective_listeners(faction_key)
	end,

	-- Alberic
	["wh_main_brt_bordeleaux"] = function(faction_key)

		-- Alberic: Complete the Grail Vow for short victory
		core:add_listener(
			"IEVictoryConditionAlbericGrailVowComplete",
			"ScriptEventBretonniaGrailVowCompleted",
			function(context)
				return context:character():character_subtype("wh_dlc07_brt_alberic")
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_bordeleaux_grail_vow", true)
			end,
			true
		)

		-- Complete Grail Vow with three characters (not including Alberic) for long victory
		core:add_listener(
			"IEVictoryConditionAlberic3GrailVowsComplete",
			"ScriptEventBretonniaGrailVowCompleted",
			function(context)
				return not context:character():character_subtype("wh_dlc07_brt_alberic")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_bordeleaux_3_grail_vows", 1)
			end,
			true
		)

		-- Reach Honourable/Chivalrous Chivalry Level for short/long victory
		-- Complete the final Errantry War Battle
		_victory_objectives_ie.listeners.brt_shared_objective_listeners(faction_key)
	end,

	-- The Fay Enchantress
	["wh_main_brt_carcassonne"] = function(faction_key)

		-- The Fay Enchantress : Construct Special Landmark Tower of the Enchantress for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBrtBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_brt_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_castle_carcassonne",
			{"wh_main_brt_legendary_enchantress_tower"}
		)

		-- The Fay Enchantress: Complete the Troth of Virtue Vow
		core:add_listener(
			"IEVictoryConditionFayEnchantressVirtueTrothCompleted",
			"ScriptEventBretonniaVirtueTrothCompleted",
			function(context)
				return context:character():character_subtype("wh_dlc07_brt_fay_enchantress")
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_carcassonne_virtue_thoth", true)
			end,
			true
		)

		-- The Fay Enchantress: Complete Troth of Virtue Vow with 3 Characters (not including Fay Enchantress)
		core:add_listener(
			"IEVictoryConditionFayEnchantressVirtueTrothCompleted",
			"ScriptEventBretonniaVirtueTrothCompleted",
			function(context)
				return not context:character():character_subtype("wh_dlc07_brt_fay_enchantress")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_carcassonne_complete_n_virtue_thoths", 1)
			end,
			true
		)

		-- Reach Honourable/Chivalrous Chivalry Level for short/long victory
		-- Complete the final Errantry War Battle
		_victory_objectives_ie.listeners.brt_shared_objective_listeners(faction_key)
	end,

	-- Repanse
	["wh2_dlc14_brt_chevaliers_de_lyonesse"] = function(faction_key)

		-- Repanse : Construct Special Landmark The Holy Monastary of the Divine Origo for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionBrtBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_brt_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_fyrus",
			{"wh2_dlc14_special_fyrus_holy_monastery"}
		)

		-- Reach Honourable/Chivalrous Chivalry Level for short/long victory
		-- Complete the final Errantry War Battle
		_victory_objectives_ie.listeners.brt_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["brt_shared_objective_listeners"] = function(faction_key)

		-- Reach Honourable/Chivalrous Chivalry Level for short/long victory
		local short_victory_chivalry_threshold = 2000
		local long_victory_chivalry_threshold = 8000
		core:add_listener(
			"IEVictoryConditionReachChivalryLevel",
			"ScriptEventChivalryLevelUp",
			function(context)
				return true
			end,
			function(context)
				local faction = cm:get_faction(faction_key)
				if faction:pooled_resource_manager():resource("brt_chivalry"):value() >= short_victory_chivalry_threshold then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_reach_n_chivalry_level_short", true)
				end
				if faction:pooled_resource_manager():resource("brt_chivalry"):value() >= long_victory_chivalry_threshold then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_reach_n_chivalry_level_long", true)
				end
			end,
			true
		)

		-- Complete the final Errantry War Battle
		local final_errantry_war_battle_key_list = {
			"wh_dlc07_qb_brt_louen_errantry_war_badlands_stage_1_the_lost_idol",
			"wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_stage_1_cliff_of_beasts",
			"wh3_main_ie_qb_brt_repanse_defend_or_conquer_crusader",
			"wh3_main_ie_qb_brt_repanse_defend_or_conquer_guardian",
		}
		core:add_listener(
			"IEVictoryConditionFinalErrantryBattleComplete",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and table.contains(final_errantry_war_battle_key_list, context:mission():mission_record_key())
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_brettonia_win_final_errantry_battle_long_victory", true)
			end,
			true
		)
	end,

----- WOOD ELF -----

	-- Orion
	["wh_dlc05_wef_wood_elves"] = function(faction_key)

		-- Orion: Raze 15 Settlements
		core:add_listener(
			"IEVictoryConditionOrionRaze15Settlements",
			"CharacterRazedSettlement",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_wef_raze_n_settlements", 1)
			end,
			true
		)

		-- Orion: Fill all offices on Orion?s Chosen with rank 15 characters
		-- Orion: Perform the Ritual of Rebirth at the Oak of Ages
		_victory_objectives_ie.listeners.wef_shared_objective_listeners(faction_key)
	end,

	-- Durthu
	["wh_dlc05_wef_argwylon"] = function(faction_key)

		-- Durthu: Fill all offices of Durthu?s Gathering of the Ancients with rank 15 characters
		-- Durthu: Perform the Ritual of Rebirth at the Oak of Ages
		_victory_objectives_ie.listeners.wef_shared_objective_listeners(faction_key)
	end,

	-- Sisters of Twilight
	["wh2_dlc16_wef_sisters_of_twilight"] = function(faction_key)

		-- Sisters of Twilight: Construct special landmark Temple of Anath Raema for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionWefBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_wef_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_the_witchwood",
			{"wh_dlc05_wef_temple_anath_raema_1"}
		)

		-- Sisters of Twilight: Perform the Ritual of Rebirth at the Oak of Ages
		_victory_objectives_ie.listeners.wef_shared_objective_listeners(faction_key)
	end,

	-- Drycha
	["wh2_dlc16_wef_drycha"] = function(faction_key)

		-- Drycha: Construct special landmark Overgrown temple of Ereth Khial for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionWefBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_wef_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_gryphon_wood",
			{"wh_dlc05_wef_temple_ereth_khial_1"}
		)

		-- Drycha: Complete the ?Coeddil Unchained? quest battle to recruit Coeddil
		core:add_listener(
			"IEVictoryConditionDrychaCompletesCoeddilQuest",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh3_main_ie_qb_wef_drycha_coeddil_unchained"
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_wef_drycha_unlock_coeddil", true)
			end,
			true
		)

		-- Drycha of Twilight: Perform the Ritual of Rebirth at the Oak of Ages
		_victory_objectives_ie.listeners.wef_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["wef_shared_objective_listeners"] = function(faction_key)

		-- Orion, Durthu, Sisters, Drycha: Perform 2 Rituals of Rebirth for short Victory
		local full_region_to_ritual_list = {
			--{region_key = "wh3_main_combi_region_the_oak_of_ages",					ritual_key = "wh2_dlc16_ritual_rebirth_athel_loren"},
			{region_key = "wh3_main_combi_region_the_sacred_pools",					ritual_key = "wh2_dlc16_ritual_rebirth_emerald_pools"},
			{region_key = "wh3_main_combi_region_gaean_vale",						ritual_key = "wh2_dlc16_ritual_rebirth_gaean_vale"},
			{region_key = "wh3_main_combi_region_gryphon_wood",						ritual_key = "wh2_dlc16_ritual_rebirth_gryphon_wood"},
			{region_key = "wh3_main_combi_region_oreons_camp",						ritual_key = "wh2_dlc16_ritual_rebirth_heart_of_the_jungle"},
			{region_key = "wh3_main_combi_region_jungles_of_chian",					ritual_key = "wh2_dlc16_ritual_rebirth_jungles_of_chian"},
			{region_key = "wh3_main_combi_region_laurelorn_forest",					ritual_key = "wh2_dlc16_ritual_rebirth_laurelorn"},
			{region_key = "wh3_main_combi_region_the_witchwood",					ritual_key = "wh2_dlc16_ritual_rebirth_naggarond_glade"},
			{region_key = "wh3_main_combi_region_the_haunted_forest",				ritual_key = "wh2_dlc16_ritual_rebirth_the_haunted_forest"},
			{region_key = "wh3_main_combi_region_forest_of_gloom",					ritual_key = "wh2_dlc16_ritual_rebirth_vale_of_webs"},
		}
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS(
			"IEVictoryConditionPerformRebirthRituals",
			"wh_main_short_victory",
			"wh3_dlc29_wef_perform_rituals_of_rebirth_short",
			faction_key,
			full_region_to_ritual_list,
			2,
			false
		)

		-- Orion, Durthu, Sisters, Drycha: Perform the Ritual of Rebirth at the Oak of Ages for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS(
			"IEVictoryConditionPerformRebirthRituals",
			"wh_main_long_victory",
			"wh3_dlc29_wef_perform_oak_of_ages_rebirth",
			faction_key,
			{{region_key = "wh3_main_combi_region_the_oak_of_ages", ritual_key = "wh2_dlc16_ritual_rebirth_athel_loren"}},
			1,
			false
		)

		-- Orion, Durthu, Sisters: Perform 6 Rituals of Rebirth for long Victory
		if faction_key == "wh_dlc05_wef_wood_elves" or faction_key == "wh_dlc05_wef_argwylon" or faction_key == "wh2_dlc16_wef_sisters_of_twilight" then
			victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS(
				"IEVictoryConditionPerformRebirthRituals",
				"wh_main_long_victory",
				"wh3_dlc29_wef_perform_rituals_of_rebirth_long",
				faction_key,
				full_region_to_ritual_list,
				6,
				false
			)
		end

		-- Orion: Fill all offices on Orion?s Chosen with rank 15 characters
		-- Durthu: Fill all offices of Durthu?s Gathering of the Ancients with rank 15 characters
		local wef_offices_objective_data = {
			wh_dlc05_wef_wood_elves = {
				ministers_total = 6,
				script_key = "wh3_dlc29_wef_orion_fill_all_offices_with_rank_15_characters",
			},
			wh_dlc05_wef_argwylon = {
				ministers_total = 4,
				script_key = "wh3_dlc29_wef_durthu_fill_all_offices_with_rank_15_characters",
			},
		}

		if wef_offices_objective_data[faction_key] then
			local wef_required_minister_rank = 15
			local wef_ministerial_position_key = "wh_dlc05_minister_wef_"
			local wef_mission_text = "mission_text_text_wh3_dlc29_wef_fill_all_offices_with_rank_15_characters"

			local function update_wef_office_objective(context)
				local wef_new_ranked_ministers = 0
				local character_list = context:character():faction():character_list()
				for i = 0, character_list:num_items() - 1 do
					local character = character_list:item_at(i)
					if character:ministerial_position():starts_with(wef_ministerial_position_key) then
						if character:rank() >= wef_required_minister_rank then
							wef_new_ranked_ministers = wef_new_ranked_ministers + 1
						end
					end
				end
				
				cm:set_scripted_mission_text("wh_main_long_victory", wef_offices_objective_data[faction_key].script_key, wef_mission_text, wef_new_ranked_ministers, wef_offices_objective_data[faction_key].ministers_total)
				if wef_new_ranked_ministers >= wef_offices_objective_data[faction_key].ministers_total then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory",  wef_offices_objective_data[faction_key].script_key, true)
					core:remove_listener("IEVictoryConditionOrionFillOfficesWithRankedCharacters_AssignedToPost" .. faction_key)
					core:remove_listener("IEVictoryConditionOrionFillOfficesWithRankedCharacters_RankedUp" .. faction_key)
					core:remove_listener("IEVictoryConditionOrionFillOfficesWithRankedCharacters_RemovedPost" .. faction_key)
				end
			end

			-- Check when assigning new character in office
			core:add_listener(
				"IEVictoryConditionOrionFillOfficesWithRankedCharacters_AssignedToPost" .. faction_key,
				"CharacterAssignedToPost",
				function(context)
					return context:character():faction():name() == faction_key
				end,
				function(context)
					update_wef_office_objective(context)
				end,
				true
			)

			-- Check when character in office ranks up
			core:add_listener(
				"IEVictoryConditionOrionFillOfficesWithRankedCharacters_RankedUp" .. faction_key,
				"CharacterRankUp",
				function(context)
					return context:character():faction():name() == faction_key and context:character():ministerial_position():starts_with(wef_ministerial_position_key)
				end,
				function(context)
					update_wef_office_objective(context)
				end,
				true
			)

			-- Check when removing character from office
			core:add_listener(
				"IEVictoryConditionOrionFillOfficesWithRankedCharacters_RemovedPost" .. faction_key,
				"CharacterRemovedFromPost",
				function(context)
					return context:character():faction():name() == faction_key
				end,
				function(context)
					update_wef_office_objective(context)
				end,
				true
			)

		end

		-- Durthu / Drycha: Upgrade 15 Forest Spirit units with aspects of the forest
		if faction_key == "wh_dlc05_wef_argwylon" or faction_key == "wh2_dlc16_wef_drycha" then
			core:add_listener(
			"IEVictoryConditionAspectUnitEffectPurchased",
			"UnitEffectPurchased",
			function(context)
				return context:effect():record_key():starts_with("wh2_dlc16_wef_upgrade_aspect_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_wef_durthu_upgrade_n_forest_spirits_with_aspects", 1)
			end,
			true
		)
		end
	end,

----- UNDEAD LEGIONS -----

	-- Nagash
	["wh3_dlc29_nag_host_of_nagash"] = function(faction_key)

		-- Nagash: Empower sigils for victory
		local nagash_sigils_short = 50
		local nagash_sigils_long = 150

		core:add_listener(
			"IEVictoryConditionNagashEmpoweredSigils",
			"FactionInitiativeActivationChangedEvent",
			function(context)
				return context:faction():name() == faction_key and context:initiative_set():record_key() == "wh3_dlc29_pyramid_initiative_set"
			end,
			function(context)
				local total_empowered_sigils = math.max(0, context:initiative_set():active_initiatives():num_items() - 1) -- the start sigil is not included

				out.design("----------------------------------------------------------------------------------")
				out.design(nagash_sigils_short)
				out.design(nagash_sigils_long)
				cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_nag_black_pyramid_sigils_short", "mission_text_text_wh3_dlc29_nag_black_pyramid_sigils", total_empowered_sigils, nagash_sigils_short)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_nag_black_pyramid_sigils_long", "mission_text_text_wh3_dlc29_nag_black_pyramid_sigils", total_empowered_sigils, nagash_sigils_long)
				if total_empowered_sigils >= nagash_sigils_short then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_nag_black_pyramid_sigils_short", true)
				end
				if total_empowered_sigils >= nagash_sigils_long then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nag_black_pyramid_sigils_long", true)
				end
			end,
			true
		)

		-- Nagash: Construct special landmark Vault of Nagash for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionNagBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_nag_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_black_pyramid_of_nagash",
			{"wh3_dlc29_special_pyramid_of_nagash_nag_2"}
		)

		-- Nagash: Construct special landmark Sigiled Study for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionNagBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_nag_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_black_pyramid_of_nagash",
			{"wh3_dlc29_special_pyramid_of_nagash_nag_3"}
		)

		-- Nagash: Construct special landmark Great Halls of Nagashizzar for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionNagBuildNagashizzarLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_nag_build_nagashizzar_landmark_long",
			faction_key,
			"wh3_main_combi_region_nagashizzar",
			{"wh3_dlc29_special_nagashizzar_nag"}
		)

		-- Nagash: Collect 6 books of Nagash
		local books_of_nagash_to_collect = 6
		core:add_listener(
			"IEVictoryConditionUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_nagash_collect_n_books", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect)
				if (context.number >= books_of_nagash_to_collect) then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nagash_collect_n_books", true)
				end
			end,
			true
		)
	end,

----- SKAVEN -----

	-- Queek
	["wh2_main_skv_clan_mors"] = function(faction_key)

		-- Queek: Construct special landmark Pillar-city Hub for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_skv_queek_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_karak_eight_peaks",
			{"wh2_main_special_underway_hub_skv_1"}
		)

		-- Queek: Construct special landmark Plundered Dwarfen Treasury for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_queek_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_karak_eight_peaks",
			{"wh2_main_special_eight_peaks_skv_3"}
		)

		-- Queek: Defeat any 13 Legendary Lords
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionSkvQueekDefeatNLegendaryLords",
			"wh_main_long_victory",
			"wh3_dlc29_skv_kill_n_legendary_lords_long",
			faction_key,
			true
		)

		-- Queek: Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Skrolk
	["wh2_main_skv_clan_pestilens"] = function(faction_key)

		-- Skrolk: Construct special landmark Plagued Emerald Pool in Itza for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_skv_skrolk_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_itza",
			{"wh3_dlc29_special_itza_emerald_pools_skv"}
		)

		-- Skrolk: Construct special landmark Ransacked Stellar Pyramids in Hexoatl for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_skrolk_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_hexoatl",
			{"wh3_dlc29_special_hexoatl_stellar_pyramids_skv"}
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Tretch
	["wh2_dlc09_skv_clan_rictus"] = function(faction_key)

		-- Tretch: Construct special landmark The Great Temple of Hashut (Desecrated) in Zharr-Naggrund for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_tretch_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_zharr_naggrund",
			{"wh3_dlc23_special_great_temple_of_hashut_other"}
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Ikit
	["wh2_main_skv_clan_skryre"] = function(faction_key)

		-- Ikit: Construct special landmark Warpstone Tractor-Beam for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_skv_ikit_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_skavenblight",
			{"wh2_dlc12_special_warpstone_tractor_beam_2"}
		)

		-- Ikit: Construct special landmarks Council Chamber of the Thirteen and The Shattered Tower for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_ikit_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_skavenblight",
			{"wh2_main_special_skavenblight_council13", "wh2_main_special_skavenblight_shattered_tower"}
		)

		-- Ikit: Construct 3 Doomspheres in Under-Empire settlements for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_FOREIGN_SLOT_BUILDING(
			"IEVictoryConditionIkitConstructDoomspheresLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_ikit_construct_doomspheres_long",
			faction_key,
			"wh2_dlc12_under_empire_annexation_doomsday_2"
		)

		-- Ikit: Level up Forbidden Workshop to Tier 3/4 for short/long victory
		local workshop_dilemma_keys = {short = "wh2_dlc12_incident_skv_workshop_upgrade_3", long = "wh2_dlc12_incident_skv_workshop_upgrade_4"}
		core:add_listener(
			"IEVictoryConditionIkitClawIncidentWorkshop",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and (workshop_dilemma_keys.short == context:dilemma() or workshop_dilemma_keys.long == context:dilemma())
			end,
			function(context)
				if workshop_dilemma_keys.short == context:dilemma() then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_skv_forbidden_workshop_upgrade_short", true)
				end
				if workshop_dilemma_keys.long == context:dilemma() then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_skv_forbidden_workshop_upgrade_long", true)
					core:remove_listener("Ikit_Claw_Incident_Workshop")
				end
			end,
			true
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Snikch
	["wh2_main_skv_clan_eshin"] = function(faction_key)

		-- Snikch: Construct special landmark Occupied Celestial Palace for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_snikch_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_wei_jin",
			{"wh3_dlc24_special_celestial_palace_other"}
		)

		-- Snikch: Increase available Schemes to 4 by using Nightlord Say-so for long victory
		local nightlord_ritual_name = "wh2_dlc14_eshin_actions_mortal_empires_mission_"
		core:add_listener(
			"IEVictoryConditionSnikchSaySoCompleted",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), nightlord_ritual_name)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_skv_snikch_perform_say_so_n_times_long", 1)
			end,
		true
		)

		-- Snikch: Reach Revered reputation with any 1 clan in Shadowy Dealings for short victory
		-- Snikch: Reach Exalted reputation with any 2 clans in Shadowy Dealings
		local snikch_ritual_key = "wh2_dlc14_eshin_contracts_"
		local reputation_requirement_short = 40
		local reputation_requirement_long = 80
		local snikch_required_reputation_key_list = {
			"skv_clan_mors",
			"skv_clan_moulder",
			"skv_clan_pestilens",
			"skv_clan_skryre",
		}

		core:add_listener(
			"IEVictoryConditionSnikchClanContractCompleted",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), snikch_ritual_key)
			end,
			function(context)
				local exalted_reputation_factions = 0
				for i = 1, #snikch_required_reputation_key_list do
					local reputation_value = context:performing_faction():pooled_resource_manager():resource(snikch_required_reputation_key_list[i]):value()
					if reputation_value >= reputation_requirement_short then
						cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_skv_eshin_reach_revered_reputation_with_one_clan_short", true)
					end
					if reputation_value >= reputation_requirement_long then
						exalted_reputation_factions = exalted_reputation_factions + 1
						if exalted_reputation_factions >= 2 then
							cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_skv_eshin_reach_exalted_reputation_with_two_clans_long", true)
							core:remove_listener("IEVictoryConditionSnikchClanContractCompleted")
						end
					end
				end
			end,
		true
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 2, 6)
	end,

	-- Throt
	["wh2_main_skv_clan_moulder"] = function(faction_key)

		-- Throt: Construct special landmark Depths of Hell-Pit for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_throt_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_hell_pit",
			{"wh2_main_special_hellpit_pits_moulder_2"}
		)

		-- Throt: Purchase any 2 upgrades for the Flesh Laboratory for short victory
		-- Throt: Purchase all upgrades for the Flesh Laboratory
		local flesh_lab_upgrade_ritual_key = "wh2_dlc16_throt_flesh_lab_upgrade_"
		core:add_listener(
			"IEVictoryConditionUpgradeFleshLab",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), flesh_lab_upgrade_ritual_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_skv_throt_purchase_n_lab_upgrades_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_skv_throt_purchase_n_lab_upgrades_long", 1)
			end,
			true
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Thanquol
	["wh3_dlc29_skv_clan_scruten"] = function(faction_key)

		-- Thanquol: Summon Skreech Verminking for short victory
		local skreech_subtype_key = "wh3_dlc29_skv_skreech_verminking"
		core:add_listener(
			"IEVictoryConditionThanquolSummonsSkreech",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and context:character():character_subtype(skreech_subtype_key)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_skv_thanquol_unlock_verminking_short", true)
			end,
			true
		)

		-- Thanquol: Construct Morskittar Engine building for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSkvBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_skv_thanquol_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_zhufbar",
			{"wh3_dlc29_skv_special_morskittar_engine_5"}
		)

		-- Control 5/13 Under-empire regions for short/long victory
		_victory_objectives_ie.listeners.skv_shared_objective_listeners(faction_key, 5, 13)
	end,

	-- Shared
	["skv_shared_objective_listeners"] = function(faction_key, short, long)

		local function update_under_empire_mission_status()
			local under_empire_region_amount = cm:get_faction(faction_key):foreign_slot_managers():num_items()
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_skv_control_n_under_empire_regions_short", "mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions", under_empire_region_amount, short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_skv_control_n_under_empire_regions_long", "mission_text_text_wh3_dlc29_skv_control_n_under_empire_regions", under_empire_region_amount, long)
			if under_empire_region_amount >= long then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_skv_control_n_under_empire_regions_long", true)
				core:remove_listener("IEVictoryConditionCreateUnderEmpireRegions")
				core:remove_listener("IEVictoryConditionRemoveUnderEmpireRegions")
			end
			if under_empire_region_amount >= short then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_skv_control_n_under_empire_regions_short", true)
			end
		end

		--update UI to account for initial under empires
		update_under_empire_mission_status()

		core:add_listener(
			"IEVictoryConditionCreateUnderEmpireRegions",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key
			end,
			function(context)
				update_under_empire_mission_status()
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionRemoveUnderEmpireRegions",
			"ForeignSlotManagerRemovedEvent",
			function(context)
				return context:owner():name() == faction_key
			end,
			function(context)
				update_under_empire_mission_status()
			end,
			true
		)

	end,

----- KHORNE -----

	-- Skarbrand
	["wh3_main_kho_exiles_of_khorne"] = function(faction_key)

		-- Skarbrand: Construct special landmark Pillar of Bone for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionKhoBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_kho_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_deff_gorge",
			{"wh3_dlc24_special_pillar_of_bone_kho"}
		)

		-- Skarbrand: Win the Slaughter and Carnage Battle for short victory
		core:add_listener(
			"IEVictoryConditionSkarbrandWinQuestBattle",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_kho_skarbrand_slaughter_and_carnage"
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_kho_win_slaughter_and_carnage_battle_short", true)
				core:remove_listener("IEVictoryConditionSkarbrandWinQuestBattle")
			end,
			true
		)

		-- Skarbrand: Spawn 20 Bloodhost Armies for long victory
		core:add_listener(
			"IEVictoryConditionBloodHostSpawned",
			"ScriptEventBloodHostSpawned",
			function(context)
				return context:faction():name() == faction_key
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_spawn_n_bloodhosts_long", 1)
			end,
			true
		)

		-- Skarbrand: Raze 50 Settlements for long victory
		-- Skarbrand: Perform all 4 unholy manifestations for short victory
		_victory_objectives_ie.listeners.kho_shared_objective_listeners(faction_key)
	end,

	-- Skulltaker
	["wh3_dlc26_kho_skulltaker"] = function(faction_key)

		-- Skulltaker: Kill 25/50 Lords in battle for short/long victory
		core:add_listener(
			"IEVictoryConditionDefeatNLords",
			"CharacterConvalescedOrKilled",
			function(context)
				return context:character():faction():name() ~= faction_key
						and context:character():character_details():character_type("general")
						and context:character():convalesence_cause() == 3
						and cm:pending_battle_cache_faction_is_involved(faction_key)
						and cm:pending_battle_cache_fm_is_involved(context:character():family_member())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_kho_kill_n_lords_in_battle_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_kill_n_lords_in_battle_long", 1)
			end,
			true
		)

		-- Skulltaker: Empower 3/8 Skulls on the Cloak of Skulls to level 3 for short/long victory
		core:add_listener(
			"IEVictoryConditionEmpowerSkulls",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "CLOAK_OF_SKULLS" and string.ends_with(context:ritual():ritual_key(), "_3")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_kho_skulltaker_empower_skulls_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_skulltaker_empower_skulls_long", 1)
			end,
			true
		)

		-- Skulltaker: Perform all 4 unholy manifestations for short victory
		_victory_objectives_ie.listeners.kho_shared_objective_listeners(faction_key)
	end,

	-- Arbaal
	["wh3_dlc26_kho_arbaal"] = function(faction_key)

		local mission_key_perfect_challenge = "wh3_dlc26_arbaal_wrath_of_khorne_mission_medium_"
		local mission_key_ultimate_challenge = "wh3_dlc26_arbaal_wrath_of_khorne_mission_strong_"
		local arbaal_khorne_favour_pooled_resource_key = "wh3_dlc26_kho_arbaal_wrath_of_khorne_progress"

		-- Arbaal: Complete 5 Perfect Battles for short victory
		core:add_listener(
			"IEVictoryConditionArbaalCompletePerfectChallenge",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key():starts_with(mission_key_perfect_challenge)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_kho_arbaal_complete_n_perfect_battles_short", 1)
			end,
			true
		)

		-- Arbaal: Complete 10 Ultimate Bloodbath battles for long victory
		core:add_listener(
			"IEVictoryConditionArbaalCompletePerfectChallenge",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key():starts_with(mission_key_ultimate_challenge)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_arbaal_complete_n_ultimate_battles_long", 1)
			end,
			true
		)

		-- Arbaal: Earn 80/160 Favour for short/long victory
		core:add_listener(
			"IEVictoryConditionArbaalEarnFavour",
			"PooledResourceChanged",
			function(context)
				return context:has_faction() == true and context:faction():name() == faction_key and context:resource():key() == arbaal_khorne_favour_pooled_resource_key and context:amount() > 0
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_kho_arbaal_gain_n_favour_short", context:amount())
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_arbaal_gain_n_favour_long", context:amount())
			end,
			true
		)

		-- Arbaal: Raze 50 Settlements for long victory
		_victory_objectives_ie.listeners.kho_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["kho_shared_objective_listeners"] = function(faction_key)

		-- Skarbrand, Arbaal: Raze 50 Settlements for long victory
		if faction_key == "wh3_main_kho_exiles_of_khorne" or faction_key == "wh3_dlc26_kho_arbaal" then
			core:add_listener(
				"IEVictoryConditionKhorneRaze50Settlements",
				"CharacterRazedSettlement",
				function(context)
					return context:character():faction():name() == faction_key
				end,
				function()
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_raze_n_settlements_long", 1)
				end,
				true
			)

			local required_ritual_key = "wh3_main_ritual_kho_gg_4"
			core:add_listener(
				"IEVictoryConditionKhorneRaze50Settlements",
				"RitualCompletedEvent",
				function(context)
					return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), required_ritual_key)
				end,
				function()
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_kho_raze_n_settlements_long", 1)
				end,
				true
			)
		end

		-- Skarbrand, Skulltaker: Perform N unholy manifestations for short victory
		if faction_key == "wh3_main_kho_exiles_of_khorne" or faction_key == "wh3_dlc26_kho_skulltaker" then
			victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_FROM_CATEGORIES(
				"IEVictoryConditionKhoPerformUnholyManifestation",
				"wh_main_short_victory",
				"wh3_dlc29_kho_perform_all_unholy_manifestations_short",
				faction_key,
				"GREAT_GAME"
			)
		end

	end,

----- SLAANESH -----

	-- N'Kari
	["wh3_main_sla_seducers_of_slaanesh"] = function(faction_key)

		-- N'Kari: Construct special landmark Altar to Ecstatic Hunt for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionSlaBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_sla_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_shrine_of_kurnous",
			{"wh3_dlc24_special_ecstatic_hunt"}
		)

		-- N'Kari: Build 20 Cult buildings for long victory
		core:add_listener(
			"IEVictoryConditionNkariBuildCultBuilding",
			"ForeignSlotBuildingCompleteEvent",
			function(context)
				return context:slot_manager():faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_sla_construct_n_cult_buildings_long", 1)
			end,
			true
		)

		-- N'Kari: Vassalise any other faction via Seduction for short victory
		-- N'Kari: Vassalise 5 factions via Seduction
		core:add_listener(
			"IEVictoryConditionNkariVassalizeFaction",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "FORCE_VASSAL" and context:performing_faction():name() == faction_key
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_sla_vassalize_faction_via_seduction_short", true)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_sla_vassalize_faction_via_seduction_long", 1)
			end,
			true
		)

		-- N'Kari: Perform all 4 unholy manifestations for short victory
		_victory_objectives_ie.listeners.sla_shared_objective_listeners(faction_key)
	end,

	-- Dechala
	["wh3_dlc27_sla_the_tormentors"] = function(faction_key)

		core:add_listener(
			"IEVictoryConditionDechalaConstructPleasurePalaces",
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				return region:owning_faction():name() == faction_key and region:settlement():settlement_type_key() == "wh3_dlc27_dechala_pleasure_palace"
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_sla_build_4_pleasure_palaces_long", 1)
			end,
			true
		)
	end,

	-- Masque of Slaanesh
	["wh3_dlc27_sla_masque_of_slaanesh"] = function(faction_key)

		-- Masque of Slaanesh: Maintain the Highest Level of Tempo with one army for 20 consecutive turns for long victory
		local required_consecutive_turns_to_keep_max_tempo = 20
		local disciple_army_subtype = "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army"

		local function get_best_max_tempo_streak_character(max_tempo_character_fm_cqi_list)
			local best_character_fm_cqi
			local earliest_turn_number = -1
			local best_turn_streak = 0

			if table.is_empty(max_tempo_character_fm_cqi_list) then
				return nil, 0
			end

			-- Find the lowest fm_cqi_to_number_turn_pair.turn_number (lower turn_number means longer turn streak on max tempo)
			for _ , fm_cqi_to_number_turn_pair in dpairs(max_tempo_character_fm_cqi_list) do

				-- Store first character data from the list to compare them with each other
				if earliest_turn_number == -1 then
					earliest_turn_number = fm_cqi_to_number_turn_pair.turn_number
					best_character_fm_cqi = fm_cqi_to_number_turn_pair.character_fm_cqi
				end

				if fm_cqi_to_number_turn_pair.turn_number < earliest_turn_number then
					earliest_turn_number = fm_cqi_to_number_turn_pair.turn_number
					best_character_fm_cqi = fm_cqi_to_number_turn_pair.character_fm_cqi
				end
			end

			best_turn_streak = cm:turn_number() - earliest_turn_number
			return cm:get_character_by_fm_cqi(best_character_fm_cqi), best_turn_streak
		end

		-- Objective display: character with current best turn streak of max tempo and counter of turn streak. If character with top streak have lost tempo (or died) - show second best character and streak
		local function update_turn_streak_counter(max_tempo_character_fm_cqi_list, mission_success)
			if is_nil(mission_success) then
				mission_success = false
			end
			local best_character_obj, best_turn_streak = get_best_max_tempo_streak_character(max_tempo_character_fm_cqi_list)
			if best_character_obj and not best_character_obj:is_null_interface() then
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns", "mission_text_text_wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns_long", best_turn_streak, required_consecutive_turns_to_keep_max_tempo)
				cm:set_scripted_mission_entity_completion_states("wh_main_long_victory", "wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns", {{best_character_obj, mission_success}})
			else
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns", "mission_text_text_wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns_empty_long", 0, required_consecutive_turns_to_keep_max_tempo)
			end
			-- If character lost tempo we remove him from the objectives
			local removed_character_fm_cqi = cm:get_saved_value("masque_max_tempo_last_removed_character_fm_cqi")
			local removed_character_obj = cm:get_character_by_fm_cqi(removed_character_fm_cqi)
			if removed_character_obj and not removed_character_obj:is_null_interface() then
				cm:remove_scripted_mission_entities("wh_main_long_victory", "wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns", {removed_character_obj})
			end
		end

		local function remove_stored_character_on_losing_max_tempo(character_fm_cqi)
			local max_tempo_character_fm_cqi_list = cm:get_saved_value("masque_max_tempo_character_fm_cqi_list") or {}
			local index_to_remove = 0
			for idx , fm_cqi_to_number_turn_pair in dpairs(max_tempo_character_fm_cqi_list) do
				if fm_cqi_to_number_turn_pair.character_fm_cqi == character_fm_cqi then
					index_to_remove = idx
					cm:set_saved_value("masque_max_tempo_last_removed_character_fm_cqi", character_fm_cqi)
				end
			end
			table.remove(max_tempo_character_fm_cqi_list, index_to_remove)
			cm:set_saved_value("masque_max_tempo_character_fm_cqi_list", max_tempo_character_fm_cqi_list)
			update_turn_streak_counter(max_tempo_character_fm_cqi_list)
		end

		-- Store character and current turn when he reaches max tempo
		core:add_listener(
			"IEVictoryConditionMasqueStoreMaxTempoCharacter",
			"EternalDanceTempoThresholdUpgraded",
			function(context)
				return context.stored_table.general:faction():name() == faction_key and context.stored_table.tempo_level >= 4
			end,
			function(context)
				local max_tempo_character_fm_cqi_list = cm:get_saved_value("masque_max_tempo_character_fm_cqi_list") or {}
				local character_fm_cqi_to_turn_number_pair = {character_fm_cqi = context.stored_table.general:character_details():family_member():command_queue_index(), turn_number = cm:turn_number()}
				table.insert(max_tempo_character_fm_cqi_list, character_fm_cqi_to_turn_number_pair)
				cm:set_saved_value("masque_max_tempo_character_fm_cqi_list", max_tempo_character_fm_cqi_list)
				update_turn_streak_counter(max_tempo_character_fm_cqi_list)
			end,
			true
		)

		-- Remove stored character when losing max tempo
		core:add_listener(
			"IEVictoryConditionMasqueRemoveMaxTempoCharacterOnTempoLost",
			"EternalDanceTempoThresholdDowngraded",
			function(context)
				return context.stored_table.general:faction():name() == faction_key and context.stored_table.tempo_level < 4
			end,
			function(context)
				remove_stored_character_on_losing_max_tempo(context.stored_table.general:character_details():family_member():command_queue_index())
			end,
			true
		)

		-- Remove stored character when he dies
		core:add_listener(
			"IEVictoryConditionMasqueRemoveMaxTempoCharacterOnDeath",
			"CharacterConvalescedOrKilled",
			function(context)
				return context:character():faction():name() == faction_key and context:character():character_type_key() == "general" and context:character():character_subtype_key() ~= disciple_army_subtype
			end,
			function(context)
				remove_stored_character_on_losing_max_tempo(context:character():character_details():family_member():command_queue_index())
			end,
			true
		)

		-- Update turn streak counter each turn
		-- Trigger Victory condition if required turn number is reached
		core:add_listener(
			"IEVictoryConditionMasqueMaintainMaxTempo",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local max_tempo_character_fm_cqi_list = cm:get_saved_value("masque_max_tempo_character_fm_cqi_list") or {}
				if not table.is_empty(max_tempo_character_fm_cqi_list) then
					for _, fm_cqi_to_number_turn_pair in dpairs(max_tempo_character_fm_cqi_list) do
						if fm_cqi_to_number_turn_pair.turn_number + required_consecutive_turns_to_keep_max_tempo <= cm:turn_number() then
							update_turn_streak_counter(max_tempo_character_fm_cqi_list, true)
							cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_sla_maintain_the_highest_tempo_level_for_20_turns", true)
							core:remove_listener("IEVictoryConditionMasqueMaintainMaxTempo")
							core:remove_listener("IEVictoryConditionMasqueRemoveMaxTempoCharacterOnDeath")
							core:remove_listener("IEVictoryConditionMasqueRemoveMaxTempoCharacterOnTempoLost")
							core:remove_listener("IEVictoryConditionMasqueStoreMaxTempoCharacter")
							return
						end
					end
				end
				update_turn_streak_counter(max_tempo_character_fm_cqi_list)
			end,
			true
		)

		-- Masque of Slaanesh: Spawn 10 Disciple armies for long victory
		core:add_listener(
			"IEVictoryConditionMasqueSpawnDiscipleArmy",
			"MilitaryForceCreated",
			function(context)
				return context:military_force_created():general_character():character_subtype(disciple_army_subtype) and context:military_force_created():faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_sla_spawn_n_disciple_armies_long", 1)
			end,
			true
		)

		-- Masque of Slaanesh: Perform all 4 Dance Finales for short victory
		local required_initiative_record_key = "ETERNAL_DANCE_OF"
		core:add_listener(
			"IEVictoryConditionMasquePerform4DanceFinales",
			"CharacterInitiativePresetActivatedEvent",
			function(context)
				return string.find(context:category(), required_initiative_record_key) and context:preset_is_finished() and context:character():faction():name() == faction_key
			end,
			function(context)
				local masque_dance_initiative_sets_completed = cm:get_saved_value("masque_dance_initiative_sets_completed") or {}
				local initiative_set = context:category()
				for i = 1, #masque_dance_initiative_sets_completed do
					if initiative_set == masque_dance_initiative_sets_completed[i] then
						return false
					end
				end

				table.insert(masque_dance_initiative_sets_completed, initiative_set)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_sla_reach_the_highest_tempo_level_with_all_4_dances", 1)
			end,
			true
		)

		-- Masque of Slaanesh: Perform all 4 unholy manifestations for short victory
		_victory_objectives_ie.listeners.sla_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["sla_shared_objective_listeners"] = function(faction_key)

		-- N'kari, Masque of Slaanesh: Perform all N Unholy Manifestations for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_FROM_CATEGORIES(
			"IEVictoryConditionSlaPerformUnholyManifestation",
			"wh_main_short_victory",
			"wh3_dlc29_sla_perform_all_unholy_manifestations_short",
			faction_key,
			"GREAT_GAME"
		)
	end,

----- NURGLE -----

	-- Ku'gath
	["wh3_main_nur_poxmakers_of_nurgle"] = function(faction_key)

		-- Ku'gath: Construct The Sea Dragon's Teeth (Great Landing) for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionNurBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_nur_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_dragon_fang_mount",
			{"wh2_dlc14_special_dragon_isle_port_3"}
		)

		-- Ku'gath: Perform 7 Plagues with at least 1 Blessed Symptom
		-- Ku'gath: Perform 7 Plagues with all 3 Blessed Symptoms

		local nur_plague_agent_key = "wh3_main_nur_cultist_plague_ritual"

		local function update_blessed_symptoms_plague_objective(plague_symptoms)
			local blessed_symptoms_amount = 0
			for i = 0, plague_symptoms:num_items() - 1 do
				if plague_symptoms:item_at(i):has_state("BLESSED") then
					blessed_symptoms_amount = blessed_symptoms_amount + 1
				end
			end
			if blessed_symptoms_amount >= 1 then
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_nur_perfrom_n_plagues_with_at_least_1_blessed_symptom_short", 1)
			end
			if blessed_symptoms_amount >= 3 then
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_perfrom_n_plagues_with_at_all_blessed_symptoms_long", 1)
			end
		end

		core:add_listener(
			"IEVictoryObjectiveRegionInfected",
			"RegionInfectionEvent",
			function(context)
				if context:plague():creator_faction():name() == faction_key then
					if context:target_region():owning_faction():name() == faction_key then
						if context:is_creation() and not context:is_removed() then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				local plague_symptoms = context:plague():plague_components()
				update_blessed_symptoms_plague_objective(plague_symptoms)
			end,
			true
		)

		core:add_listener(
			"IEVictoryObjectiveMilitaryForceInfected",
			"MilitaryForceInfectionEvent",
			function(context)
				if context:plague():creator_faction():name() == faction_key then
					if context:target_force():faction():name() == faction_key then
						if context:is_creation() and not context:is_removed() then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				local plague_symptoms = context:plague():plague_components()
				update_blessed_symptoms_plague_objective(plague_symptoms)
			end,
			true
		)

		core:add_listener(
			"IEVictoryObjectivePlagueAgentCreated",
			"AgentPlagueDataCreatedEvent",
			function(context)
				return context:faction():name() == faction_key and context:agent():character():character_subtype(nur_plague_agent_key)
			end,
			function(context)
				local plague_symptoms = context:agent():character():try_get_agent_plague_components()
				update_blessed_symptoms_plague_objective(plague_symptoms)
			end,
			true
		)

		-- Ku'gath: Have two lords become exalted great unclean ones
		local dilemma_key = "wh3_main_dilemma_exalted_greater_daemon_nur"
		core:add_listener(
			"IEVictoryObjectiveHave2ExaltedUncleanHeroes",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:faction():name() == faction_key and context:dilemma() == dilemma_key and context:choice_key() == "FIRST"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_have_n_lord_become_exalted_unclean_long", 1)
			end,
			true
		)

		-- Ku'gath: Complete 7 Cycles of the 2 Advanced Military Building Chains
		local kugath_advanced_military_buildings = {"wh3_main_nur_5_8", "wh3_main_nur_4_8"}
		core:add_listener(
			"IEVictoryObjectiveCompleteNCyclesOfTheAdvancedMilitary",
			"BuildingLifecycleDevelops",
			function(context)
				return context:faction():name() == faction_key and table.contains(kugath_advanced_military_buildings, context:previous())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_complete_n_cycles_of_advances_military_chains_long", 1)
			end,
			true
		)

		-- Ku'gath: Perform all 4 unholy manifestations for short victory
		-- Ku'gath: Have Plagues spread 100 times
		_victory_objectives_ie.listeners.nur_shared_objective_listeners(faction_key)
	end,

	-- Tamurkhan
	["wh3_dlc25_nur_tamurkhan"] = function(faction_key)

		-- Tamurkhan: Complete 3/6 Chieftain Devoted Battles for short/long victory
		local tamurkhan_chieftain_devoted_battles_key = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_"
		core:add_listener(
			"IEVictoryConditionTamurkanDevotedBattles",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():starts_with(tamurkhan_chieftain_devoted_battles_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_nur_tamurkhan_chieftaion_devoted_battle_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_tamurkhan_chieftaion_devoted_battle_long", 1)
			end,
			true
		)

		-- Tamurkhan: Recruit one of every unit from the Chieftains unit recruitment for long victory
		local tamurkhan_chieftaion_units_key = "wh3_dlc25_nur_chieftain_"
		core:add_listener(
			"IEVictoryConditionTamurkanRecruitChieftainUnits",
			"UnitCreated",
			function(context)
				return context:unit():faction():name() == faction_key and string.starts_with(context:unit():unit_key(), tamurkhan_chieftaion_units_key)
			end,
			function(context)
				local tamurkhan_recruited_chieftain_units = cm:get_saved_value("tamurkhan_recruited_chieftain_units_long_victory") or {}
				if not table.contains(tamurkhan_recruited_chieftain_units, context:unit():unit_key()) then
					table.insert(tamurkhan_recruited_chieftain_units, context:unit():unit_key())
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_tamurkhan_recruit_all_chieftain_units_long", 1)
					cm:set_saved_value("tamurkhan_recruited_chieftain_units_long_victory", tamurkhan_recruited_chieftain_units)
				end
			end,
			true
		)
	end,

	-- Epidemius
	["wh3_dlc25_nur_epidemius"] = function(faction_key)

		-- Epidemius: Reach the Surging / Epidemical Tier of the Tally of Pestilence for short / long victory
		local epidemius_tally_of_pestilence_pooled_resource = "nur_epidemius_tally_of_pestilence"
		local epidemius_tally_of_pestilence_required_short_victory = 5
		local epidemius_tally_of_pestilence_required_long_victory = 20

		core:add_listener(
			"IEVictoryObjectiveEpidemiusTallyOfPestilence",
			"PooledResourceChanged",
			function(context)
				if context:has_faction() and not context:faction():is_null_interface() then
					if context:faction():name() == faction_key then
						if context:resource():key() == epidemius_tally_of_pestilence_pooled_resource then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				if context:resource():value() >= epidemius_tally_of_pestilence_required_short_victory then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_nur_epidemius_reach_surging_tally_of_pestilence_short", true)
				end
				if context:resource():value() >= epidemius_tally_of_pestilence_required_long_victory then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nur_epidemius_reach_epidemical_tally_of_pestilence_long", true)
				end
			end,
			true
		)

		-- Epidemius: Perform all 4 unholy manifestations for short victory
		-- Epidemius: Have Plagues spread 100 times
		_victory_objectives_ie.listeners.nur_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["nur_shared_objective_listeners"] = function(faction_key)

		-- Ku'gath, Epidemius: Perform all N Unholy Manifestations for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_FROM_CATEGORIES(
			"IEVictoryConditionNurPerformUnholyManifestation",
			"wh_main_short_victory",
			"wh3_dlc29_nur_perform_all_unholy_manifestations_short",
			faction_key,
			"GREAT_GAME"
		)

		-- Ku'gath, Epidemius: Have Plagues spread 100 times
		core:add_listener(
			"IEVictoryObjectiveRegionInfected",
			"RegionInfectionEvent",
			function(context)
				return context:plague():creator_faction():name() == faction_key and not context:is_removed()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_spread_plague_n_times_long", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryObjectiveMilitaryForceInfected",
			"MilitaryForceInfectionEvent",
			function(context)
				return context:plague():creator_faction():name() == faction_key and not context:is_removed()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nur_spread_plague_n_times_long", 1)
			end,
			true
		)
	end,

----- TZEENTCH -----

	-- Kairos
	["wh3_main_tze_oracles_of_tzeentch"] = function(faction_key)

		-- Kairos: Perform 9 unholy manifestations for short victory
		local required_ritual_key = "wh3_main_ritual_tze_gg_"
		core:add_listener(
			"IEVictoryConditionPerformUnholyManifestation",
			"RitualStartedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), required_ritual_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tze_perform_all_unholy_manifestations_short", 1)
			end,
			true
		)

		-- Kairos: Build 20 Cult buildings for long victory
		core:add_listener(
			"IEVictoryConditionKairosBuildCultBuilding",
			"ForeignSlotBuildingCompleteEvent",
			function(context)
				return context:slot_manager():faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tze_construct_n_cult_buildings_long", 1)
			end,
			true
		)

		-- Kairos: Recruit a Cult Magus for short victory
		local cult_magus_character_subtype_key = "wh3_main_tze_cult_magus"
		core:add_listener(
			"IEVictoryConditionRecruitCultMagus",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and context:character():character_subtype(cult_magus_character_subtype_key)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_tze_recruit_cult_magus_short", true)
			end,
			true
		)

		-- Kairos: Perform 20/40 Changing of the Ways Actions for short/long victory
		_victory_objectives_ie.listeners.tze_shared_objective_listeners(faction_key)
	end,

	-- Changeling
	["wh3_dlc24_tze_the_deceivers"] = function(faction_key)

		-- Changeling: Unlock and Win 2/5 Grand Schemes for short/long victory
		local changeling_grand_scheme_mission_key_start = "wh3_dlc24_mission_schemes_"
		local changeling_grand_scheme_mission_key_end = "_grand"
		core:add_listener(
			"IEVictoryConditionChangelingGrandSchemes",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and
					string.starts_with(context:mission():mission_record_key(), changeling_grand_scheme_mission_key_start) and
					string.ends_with(context:mission():mission_record_key(), changeling_grand_scheme_mission_key_end)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tze_changeling_win_grand_schemes_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tze_changeling_win_grand_schemes_long", 1)
			end,
			true
		)

		-- Changeling: Unlock 5/15 Legendary Lord forms for transformation for short/long victory
		core:add_listener(
			"IEVictoryConditionChangelingGainsForm",
			"ScriptEventChangelingGainsForm",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tze_changeling_unlock_legendary_transforms_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tze_changeling_unlock_legendary_transforms_long", 1)
			end,
			true
		)

		-- Changeling: Perform 10/20 Changing of the Ways Actions for short/long victory
		_victory_objectives_ie.listeners.tze_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["tze_shared_objective_listeners"] = function(faction_key)

		-- Kairos: Perform 20/40 Changing of the Ways Actions for short/long victory
		-- Changeling: Perform 10/20 Changing of the Ways Actions for short/long victory
		local tzeentch_cotw_ritual_key = "_tze_cotw_"
		core:add_listener(
			"IEVictoryConditionPerformCOTWRitualsPerform",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.find(context:ritual():ritual_key(), tzeentch_cotw_ritual_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tze_perform_n_cotw_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tze_perform_n_cotw_actions_long", 1)
			end,
		true
		)

		core:add_listener(
			"IEVictoryConditionPerformCOTWDiplomacyManipulationsPerform",
			"DiplomacyManipulationExecutedEvent",
			function(context)
				return context:performing_faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_tze_perform_n_cotw_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_tze_perform_n_cotw_actions_long", 1)
			end,
		true
		)
	end,

----- DAEMONS OF CHAOS -----

	-- Daemon Prince
	["wh3_main_dae_daemon_prince"] = function(faction_key)

		-- Daemon Prince: Equip the Demonic Gifts of the same god or undivided in 7 equipment slots for short victory
		local categories = {"khorne", "nurgle", "slaanesh", "tzeentch", "generic"}
		core:add_listener(
			"IEVictoryConditionDaemonPrinceEquipAllSlots",
			"CharacterArmoryItemEquipped",
			function(context)
				return context:character():faction():name() == faction_key and string.find(context:character():character_subtype_key(), faction_key)
			end,
			function(context)
				local armory = context:character():family_member():armory()
				local min_items_in_one_category_required = 7
				for i = 1, #categories do
					if armory:number_of_equipped_items_of_ui_type(categories[i]) >= min_items_in_one_category_required then
						cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_dae_equip_daemonic_gifts_of_the_same_god_in_every_slot_short", true)
						core:remove_listener("IEVictoryConditionDaemonPrinceEquipAllSlots")
					end
				end
			end,
			true
		)

		-- Daemon Prince: Reach the end of the Glory path of any chaos god or undivided for long victory
		local dae_glory_pooled_resource_key = "wh3_main_dae_"
		local dae_chaos_god_glory_required_long_victory = 4400
		local dae_undivided_pooled_resource_key = "wh3_main_dae_undivided_points"
		local dae_chaos_undivided_glory_required_long_victory = 5610

		core:add_listener(
			"IEVictoryConditionDaemonPrinceReachMaxGlory",
			"PooledResourceChanged",
			function(context)
				if context:has_faction() and not context:faction():is_null_interface() then
					if context:faction():name() == faction_key then
						if string.starts_with(context:resource():key(), dae_glory_pooled_resource_key) then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				local required_amount = dae_chaos_god_glory_required_long_victory
				if context:resource():key() == dae_undivided_pooled_resource_key then
					required_amount = dae_chaos_undivided_glory_required_long_victory
				end
				if context:resource():value() >= required_amount then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_dae_reach_maximum_glory_with_chaos_god_long", true)
					core:remove_listener("IEVictoryConditionDaemonPrinceReachMaxGlory")
				end
			end,
			true
		)

		-- Required for the rewards setup: Listener to detect which ascendancy path was chosen
		core:add_listener(
			"IEVictoryConditionRewardsDaemonPrinceAscends",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.find(context:ritual():ritual_key(), "wh3_main_ritual_dae_ascend_")
			end,
			function(context)
				cm:set_saved_value("IEVictoryConditionRewardsDaemonPrinceAscendancyPath", context:ritual():ritual_key())
			end,
			false
		)
	end,

----- KISLEV -----

	-- Tzarina Katarin
	["wh3_main_ksl_the_ice_court"] = function(faction_key)

		-- Tzarina Katarin: Construct special landmark Bokha Square for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionKslBuildLandmarkShortKatarin",
			"wh_main_short_victory",
			"wh3_dlc29_ksl_katarina_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_kislev",
			{"wh3_main_special_ksl_kislev_1_2"}
		)

		-- Tzarina Katarin: Construct landmarks: Citadel of Praag, Erengrad Harbour for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionKslKatarinBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_ksl_katarin_construct_landmarks_long",
			faction_key,
			{
				wh3_main_combi_region_praag = "wh3_main_special_ksl_praag_2_3",
				wh3_main_combi_region_erengrad = "wh3_main_special_ksl_erengrad_2_3",
			}
		)

		-- Tzarina Katarin: Recruit 2 Frost Maidens via the Ice Court for short victory
		local katarina_frost_maiden_key = "wh3_main_ksl_frost_maiden_"
		core:add_listener(
			"IEVictoryConditionKatarinaRecruitFrostMaiden",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:character():character_subtype_key(), katarina_frost_maiden_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ksl_recruit_n_frost_maidens_short", 1)
			end,
			true
		)

		-- Tzarina Katarin: Recruit 2 Ice Witch Lords via the Ice Court for short victory
		local katarina_ice_witch_key = "wh3_main_ksl_ice_witch_"
		core:add_listener(
			"IEVictoryConditionKatarinaRecruitIceWitch",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:character():character_subtype_key(), katarina_ice_witch_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ksl_recruit_n_ice_witch_short", 1)
			end,
			true
		)

		-- Tzarina Katarin: Assign 3 Attamans to different provinces for long victory
		_victory_objectives_ie.listeners.ksl_shared_objective_listeners(faction_key)
	end,

	-- Kostaltyn
	["wh3_main_ksl_the_great_orthodoxy"] = function(faction_key)

	-- Kostaltyn: Construct landmarks: Njevski Citadel for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionKslKostaltynBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_ksl_kostaltyn_construct_landmarks_short",
			faction_key,
			"wh3_main_combi_region_castle_alexandronov",
			{"wh3_dlc24_special_njevskis_citadel"}
		)


		-- Kostaltyn:  Construct landmarks: Citadel of Praag, Erengrad Harbour, Imperial Diplomat Quarters for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionKslKostaltynBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_ksl_kostaltyn_construct_landmarks_long",
			faction_key,
			{
				wh3_main_combi_region_praag = "wh3_main_special_ksl_praag_2_3",
				wh3_main_combi_region_erengrad = "wh3_main_special_ksl_erengrad_2_3",
				wh3_main_combi_region_kislev = "wh3_main_special_ksl_kislev_2_4"
			}
		)

		-- Kostaltyn: Get 3 Patriarchs to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionKostaltynRankUpPatriarch",
			"wh_main_short_victory",
			"wh3_dlc29_ksl_get_n_patriarchs_to_rank_10_short",
			faction_key,
			{"wh3_main_ksl_patriarch"},
			10,
			3
		)

		-- Kostaltyn: Assign 3 Attamans to different provinces for long victory
		_victory_objectives_ie.listeners.ksl_shared_objective_listeners(faction_key)
	end,

	-- Boris
	["wh3_main_ksl_ursun_revivalists"] = function(faction_key)

		-- Boris: Have 0 Chaos Corruption in provinces Bloodfire Falls, The Blood Marshes, Plain of Illusions for long victory
		local required_province_list = {
			"wh3_main_combi_province_bloodfire_falls",
			"wh3_main_combi_province_the_blood_marshes",
			"wh3_main_combi_province_plain_of_illusions"
		}
		local required_corruption_resource_list = {
			"wh3_main_corruption_chaos",
			"wh3_main_corruption_khorne",
			"wh3_main_corruption_nurgle",
			"wh3_main_corruption_slaanesh",
			"wh3_main_corruption_tzeentch"
		}

		-- Update UI state after load
		local boris_provinces_with_zero_chaos_corruption = cm:get_saved_value("boris_provinces_with_zero_chaos_corruption") or {}
		update_mission_entity_completion_states(required_province_list, boris_provinces_with_zero_chaos_corruption, "province_key", "wh_main_long_victory", "wh3_dlc29_ksl_ursun_have_0_corruption_in_provinces_long")

		core:add_listener(
			"IEVictoryConditionBorisHas0CorruptionInProvinces",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local boris_provinces_with_zero_chaos_corruption = {}
				for i = 1, #required_province_list do
					if context:faction():holds_entire_province(required_province_list[i], true) then
						local province_has_zero_chaos_corruption = true
						local province_resource_list = cm:get_province(required_province_list[i]):pooled_resource_manager():resources()
						for j = 0, province_resource_list:num_items() - 1 do
							if table.contains(required_corruption_resource_list, province_resource_list:item_at(j):key()) then
								if province_resource_list:item_at(j):value() ~= 0 then
									province_has_zero_chaos_corruption = false
								end
							end
						end
						if province_has_zero_chaos_corruption then
							table.insert(boris_provinces_with_zero_chaos_corruption, required_province_list[i])
						end
					end
				end
				cm:set_saved_value("boris_provinces_with_zero_chaos_corruption", boris_provinces_with_zero_chaos_corruption)
				update_mission_entity_completion_states(required_province_list, boris_provinces_with_zero_chaos_corruption, "province_key", "wh_main_long_victory", "wh3_dlc29_ksl_ursun_have_0_corruption_in_provinces_long")
				if table.size(boris_provinces_with_zero_chaos_corruption) >= 3 then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_ksl_ursun_have_0_corruption_in_provinces_long", true)
					core:remove_listener("IEVictoryConditionBorisHas0CorruptionInProvinces")
				end
			end,
			true
		)

		-- Boris: Assign 3 Attamans to different provinces for long victory
		_victory_objectives_ie.listeners.ksl_shared_objective_listeners(faction_key)
	end,

	-- Mother Ostankya
	["wh3_dlc24_ksl_daughters_of_the_forest"] = function(faction_key)

		-- Mother Ostankya: Construct special landmark Ostankya's Hut for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionKslBuildLandmarkOstankyaShort",
			"wh_main_short_victory",
			"wh3_dlc29_ksl_ostankya_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_bleak_hold_fortress",
			{"wh3_dlc24_special_ostankyas_hut"}
		)

		-- Mother Ostankya: Obtain 3/5 Forbidden Hexes for short/long victory
		local ostankya_hex_mission_key_1 = "wh3_dlc24_ie_ksl_mother_ostankya_hex_"
		local ostankya_hex_mission_key_2 = "wh3_dlc24_camp_narrative_ie_mother_ostankya_defeat_initial_enemy_01"

		core:add_listener(
			"IEVictoryConditionOstankyaObtainHexes",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and
					(string.starts_with(context:mission():mission_record_key(), ostankya_hex_mission_key_1) or
					string.starts_with(context:mission():mission_record_key(), ostankya_hex_mission_key_2))
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ksl_dotf_obtain_n_forbidden_hexes_long", 1)
			end,
			true
		)

		-- Mother Ostankya: Unlock 9/18 Ingredients for the Witch's Hut for short/long victory
		core:add_listener(
			"IEVictoryConditionOstankyaObtainIngredients",
			"ScriptEventOstankyaIngridientUnlocked",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ksl_dotf_unlock_n_witch_hut_ingridients_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ksl_dotf_unlock_all_witch_hut_ingridients_long", 1)
			end,
			true
		)

		-- Mother Ostankya: Get 3 Hag Witches to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionOstankyaRankUpWitches",
			"wh_main_short_victory",
			"wh3_dlc29_ksl_dotf_get_n_hag_witches_to_rank_10_short",
			faction_key,
			{"wh3_dlc24_ksl_hag_witch_shadows", "wh3_dlc24_ksl_hag_witch_hag", "wh3_dlc24_ksl_hag_witch_death", "wh3_dlc24_ksl_hag_witch_beasts",},
			10,
			3
		)

		-- Mother Ostankya: Create 20 incantations of any combination for long victory
		local ostankya_incantation_research_key = "wh3_dlc24_tech_ksl_ostankya_witches_hut_unlock"
		core:add_listener(
			"IEVictoryConditionOstankyaCreateIncantations",
			"FactionCookedDish",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ksl_dotf_create_n_incantations_long", 1)
			end,
			true
		)

		-- Mother Ostankya: Perform the final hex the Malediction of Ruin for long victory
		local ostankya_malediction_of_ruin_ritual_key = "wh3_dlc24_ritual_ksl_hex_6"
		core:add_listener(
			"IEVictoryConditionOstankyaPerformMaledictionOfRuin",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_key() == ostankya_malediction_of_ruin_ritual_key
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_ksl_dotf_perform_the_final_hex_malediction_long", true )
			end,
			true
		)
	end,

	-- Shared
	["ksl_shared_objective_listeners"] = function(faction_key)

		-- Katarin, Kostaltyn, Boris: Assign 3 Attamans to different provinces for long victory
		core:add_listener(
			"IEVictoryConditionKislevAssignAtaman",
			"ProvinceGovernorAppointed",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ksl_have_n_atamans_assigned_long", 1)
			end,
			true
		)
	end,

----- WARRIORS OF CHAOS -----

	-- Archaon The Everchosen
	["wh_main_chs_chaos"] = function(faction_key)

		-- Set indices (starting from 0) of objectives which need to be put in a "sub-list" in order they are declared in _victory_objectives_ie_config
		cm:set_script_state(cm:get_faction(faction_key), "short_victory_mission_sub_objectives_index_list", "1;2;3;4;5;7;8;9")

		-- Archaon: PARENT-OBJECTIVE Acquire "Six treasures of chaos" set (actually includes 5 items) for short victory
		local archaon_ancillaries_list = {
			"wh_main_anc_mount_chs_archaon_dorghar",
			"wh_main_anc_armour_the_armour_of_morkar",
			"wh_main_anc_talisman_the_eye_of_sheerian",
			"wh_main_anc_weapon_the_slayer_of_kings",
			"wh_main_anc_enchanted_item_the_crown_of_domination",
		}

		core:add_listener(
			"IEVictoryConditionArchaonAcquiresTreasuresOfChaos",
			"CharacterAncillaryGained",
			function(context)
				return context:character():faction():name() == faction_key and table.contains(archaon_ancillaries_list, context:ancillary())
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_main_chs_acquire_" .. context:ancillary(), true)
				local unlocked_items = cm:get_saved_value("victory_condition_archaon_unlocked_items") or 0
				unlocked_items = unlocked_items + 1
				cm:set_saved_value("victory_condition_archaon_unlocked_items", unlocked_items)
				if unlocked_items >= table.size(archaon_ancillaries_list) then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_main_chs_acquire_six_treasures_of_chaos_set_short", true)
				end
			end,
			true
		)

		-- Archaon: Confederate 1 Legendary Lord or Vassalise 1 faction of each of the Chaos Gods for short victory
		local woc_culture = "wh_main_chs_chaos"
		local chaos_factions_to_ignore = {"wh3_main_chs_shadow_legion"}
		local cultures_to_subjugate = {
			["wh_main_chs_chaos"] = true,
			["wh3_main_nur_nurgle"] = true,
			["wh3_main_kho_khorne"]	= true,
			["wh3_main_tze_tzeentch"] = true,
			["wh3_main_sla_slaanesh"] = true,
		}

		local woc_factions_to_culture = {
			["wh3_dlc20_chs_kholek"]			   = "wh3_main_kho_khorne",
			["wh3_dlc20_chs_sigvald"]			   = "wh3_main_sla_slaanesh",
			["wh3_dlc20_chs_valkia"]			   = "wh3_main_kho_khorne",
			["wh3_dlc20_chs_festus"]			   = "wh3_main_nur_nurgle",
			["wh3_dlc20_chs_azazel"]			   = "wh3_main_sla_slaanesh",
			["wh3_dlc20_chs_vilitch"]			   = "wh3_main_tze_tzeentch",
			["wh3_dlc29_chs_host_of_the_triplets"] = "wh3_main_nur_nurgle",
		}

		local function update_subjugated_cultures_objective(faction_to_subjugate_key)
			if table.contains(chaos_factions_to_ignore, faction_to_subjugate_key) then
				return
			end
			local subjugated_cultures_list = cm:get_saved_value("archaon_subjugated_cultures_victory_condition") or {}
			local culture_to_subjugate = cm:get_faction(faction_to_subjugate_key):culture()
			if culture_to_subjugate == woc_culture then
				culture_to_subjugate = woc_factions_to_culture[faction_to_subjugate_key]
			end
			if not table.contains(subjugated_cultures_list, culture_to_subjugate) then
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_main_chs_subjugate_each_chaos_god_faction_short", 1)
				table.insert(subjugated_cultures_list, culture_to_subjugate)
				cm:set_saved_value("archaon_subjugated_cultures_victory_condition", subjugated_cultures_list)
			end
		end

		-- Archaon confederates WoC faction or his vassal owner confederates Major Chaos Faction
		core:add_listener(
			"IEVictoryConditionArchaonConfederatesChaosFaction",
			"ScriptEventArchaonSubjugatesChaosFaction",
			true,
			function(context)
				local subjugated_faction_key = context.string
				update_subjugated_cultures_objective(subjugated_faction_key)
			end,
			true
		)

		-- Archaon vassalizes Chaos faction directly
		core:add_listener(
			"IEVictoryConditionArchaonVassalizesChaosFaction",
			"FactionBecomesVassal",
			function(context)
				return context:vassal():master():name() == faction_key and cultures_to_subjugate[context:vassal():culture()]
			end,
			function(context)
				local subjugated_faction_key = context:vassal():name()
				update_subjugated_cultures_objective(subjugated_faction_key)
			end,
			true
		)

		-- Archaon: PARENT-OBJECTIVE: Prepare a warband worthy of the End Times:
		core:add_listener(
			"IEVictoryConditionArchaonParentObjectiveShort",
			"ScriptEventArchaonPreparesWarband",
			true,
			function(context)
				local prepare_warband_completed_objectives = cm:get_saved_value("victory_conditions_archaon_prepare_warband_objectives_completed") or 0
				prepare_warband_completed_objectives = prepare_warband_completed_objectives + 1
				cm:set_saved_value("victory_conditions_archaon_prepare_warband_objectives_completed", prepare_warband_completed_objectives)
				if prepare_warband_completed_objectives >= 3 then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_main_chs_parent_objective_short", true)
					core:remove_listener("IEVictoryConditionArchaonParentObjectiveShort")
				end
			end,
			true
		)

		-- Archaon: SUB-OBJECTIVE Prepare a warband worthy of the End Times: Strength rank 1 for short victory
		core:add_listener(
			"IEVictoryConditionArchaonReachFactionStrengthRank",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				if cm:model():world():faction_strength_rank(context:faction()) == 1 then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_main_chs_reach_strength_rank_1_short", true)
				end
			end,
			true
		)

		-- Archaon: SUB-OBJECTIVE Prepare a warband worthy of the End Times: Archaon rank 40 for short victory
		local required_rank = 40
		core:add_listener(
			"IEVictoryConditionArchaonRank40",
			"CharacterRankUp",
			function(context)
				local character = context:character()
				return (character == cm:get_faction(faction_key):faction_leader()) and (character:rank() >= required_rank)
			end,
			function(context)
				core:trigger_event("ScriptEventArchaonPreparesWarband")
			end,
			true
		)

		-- Archaon: SUB-OBJECTIVE Prepare a warband worthy of the End Times: Have 80 units for short victory
		local required_unit_count = 80
		local function update_military_forces_objective(faction_military_force_list)
			cm:callback(
				function()
					local units = 0
					for i = 0, faction_military_force_list:num_items() - 1 do
						local mf = faction_military_force_list:item_at(i)
						if mf:is_army() and not mf:is_armed_citizenry() and mf:has_general() then
							units = units + mf:unit_list():num_items()
						end
					end
					if units >= required_unit_count then
						core:trigger_event("ScriptEventArchaonPreparesWarband")
					end
				end,
				0.5
			)
		end

		core:add_listener(
			"IEVictoryConditionArchaonHasNFullArmiesAfterCreatingUnit",
			"UnitCreated",
			function(context)
				return context:unit():faction():name() == faction_key
			end,
			function(context)
				local faction_military_force_list = context:unit():faction():military_force_list()
				update_military_forces_objective(faction_military_force_list)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionArchaonHasNFullArmiesAfterMergingArmies",
			"CampaignArmiesMergeCompleted",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local faction_military_force_list = context:character():faction():military_force_list()
				update_military_forces_objective(faction_military_force_list)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionArchaonHasNFullArmiesAfterConfederation",
			"FactionJoinsConfederation",
			function(context)
				return context:confederation():name() == faction_key
			end,
			function(context)
				local faction_military_force_list = context:confederation():military_force_list()
				update_military_forces_objective(faction_military_force_list)
			end,
			true
		)

		-- Archaon: SUB-OBJECTIVE Prepare a warband worthy of the End Times: 8 Dark Fortresses
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Glottkin
	["wh3_dlc29_chs_host_of_the_triplets"] = function(faction_key)

		-- Glottkin: Build a Garden of Nurgle in Altdorf and Middenheim for short victory
		local regions_to_convert_list = {"wh3_main_combi_region_altdorf", "wh3_main_combi_region_middenheim"}
		-- Update UI state after load
		local glottkin_gardens_regions_sv = "short_victory_glottkin_garden_regions"
		local glottkin_garden_regions = cm:get_saved_value(glottkin_gardens_regions_sv) or {}
		update_mission_entity_completion_states(regions_to_convert_list, glottkin_garden_regions, "region_key", "wh_main_short_victory", "wh3_dlc29_chs_glottkin_build_garden_of_nurgle_in_altdorf_and_middenheim_short")
		core:add_listener(
			"IEVictoryConditionGlottkinSettlementTypeConvertedEvent",
			"SettlementTypeConvertedEvent",
			function(context)
				local settlement = context:settlement()
				return string.find(settlement:settlement_type_key(), "wh3_dlc29_woc_glottkin_garden_of_nurgle") and table.contains(regions_to_convert_list, settlement:region():name())
			end,
			function(context)
				local region = context:settlement():region()
				local region_key = region:name()
				
				if not table.contains(glottkin_garden_regions, region_key) then
					local mission_key = "wh_main_short_victory"
					local script_key = "wh3_dlc29_chs_glottkin_build_garden_of_nurgle_in_altdorf_and_middenheim_short"

					table.insert(glottkin_garden_regions, region_key)
					cm:set_saved_value(glottkin_gardens_regions_sv, glottkin_garden_regions)
					cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{region, true}})
					if table.size(glottkin_garden_regions) >= table.size(regions_to_convert_list) then
						cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
					end
				end
			end,
			true
		)

		-- Glottkin: Raze 15 Empire Settlements for short victory
		local empire_region_list = region_key_list_from_region_group("cai_region_hint_area_empire")
		core:add_listener(
			"IEVictoryConditionGlottkinRaze15Settlements",
			"CharacterRazedSettlement",
			function(context)
				return context:character():faction():name() == faction_key and  table.contains(empire_region_list, context:garrison_residence():region():name())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_glottkin_raze_n_empire_settlements_short", 1)
			end,
			true
		)

		-- Glottkin: Build all 7 Gardens of Nurgle
		local total_required_gardens = 7
		local settlement_garden_of_nurgle_type_key = "wh3_dlc29_woc_glottkin_garden_of_nurgle"

		local function get_total_gardens_of_nurlge()
			local total_gardens = 0
			local glottkin_faction_obj = cm:get_faction(faction_key)
			local regions_list = glottkin_faction_obj:region_list()
			for i = 0, regions_list:num_items() - 1 do
				local current_region = regions_list:item_at(i)
				local current_settlement = current_region:settlement()
				if string.starts_with(current_settlement:settlement_type_key(), settlement_garden_of_nurgle_type_key) then
					total_gardens = total_gardens + 1
				end
			end

			return total_gardens
		end

		core:add_listener(
			"IEVictoryConditionGlottkinBuildOrRemovedGardenOfNurgle",
			"SettlementTypeConvertedEvent",
			function(context)
				local settlement = context:settlement()
				return settlement:faction():name() == faction_key
			end,
			function(context)
				local total_gardens = get_total_gardens_of_nurlge()
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", "mission_text_text_wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", total_gardens, total_required_gardens)
				if total_gardens >= total_required_gardens then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", true)
				end
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionGlottkinLostGardenOfNurgle",
			"RegionFactionChangeEvent",
			function(context)
				return context:previous_faction():name() == faction_key
			end,
			function(context)
				local total_gardens = get_total_gardens_of_nurlge()
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", "mission_text_text_wh3_dlc29_chs_glottkin_build_7_gardens_of_nurgle_long", total_gardens, total_required_gardens)
			end,
			true
		)

		-- Complete the Maggots Lords Chain 
		core:add_listener(
			"IEVictoryConditionGlottkinMaggotsLordsChain",
			"ScriptEventMaggotsLordsMissionsCompleted",
			function(context)
				return context:faction():name() == faction_key
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "maggots_lords_chain_completed", true)
			end,
			true
		)

		-- Have 4 Marks of Nurgle at max tier
		local marks_of_nurgle_prefix = "wh3_dlc29_marks_of_nurgle"
		local marks_max_tier_suffix = "level_3"
		core:add_listener(
			"IEVictoryConditionMaxTierMarksOfNurgle",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				local record_key = context:initiative():record_key()
				return context:character():faction():name() == faction_key and record_key:starts_with(marks_of_nurgle_prefix) and record_key:ends_with(marks_max_tier_suffix)
	end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_glottkin_marks_of_nurgle_long", 1)
			end,
			false
		)

		-- Control 4 Dark Fortresses for short victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Kholek Suneater
	["wh3_dlc20_chs_kholek"] = function(faction_key)

		-- Kholek Suneater: Equip 4 Gifts of the Gods for short victory
		-- Kholek Suneater: Equip Gifts of the Gods of every chaos god for long victory
		local gifts_of_chaos_god_categories = {
			"DLC20_KHORNE_INITIATIVES",
			"DLC20_NURGLE_INITIATIVES",
			"DLC20_SLAANESH_INITIATIVES",
			"DLC20_TZEENTCH_INITIATIVES",
			
		}
		local undivided_gifts_of_chaos_category = "DLC20_UNDIVIDED_INITIATIVES"
		local required_inititiatives_for_short_victory = 4
		core:add_listener(
			"IEVictoryConditionKholekActivatesGiftOfChaos",
			"FactionInitiativeActivationChangedEvent",
			function(context)
				local initiative_category_key = context:initiative_set():category_key()
				return context:faction():name() == faction_key and (table.contains(gifts_of_chaos_god_categories, initiative_category_key) or initiative_category_key == undivided_gifts_of_chaos_category)
			end,
			function(context)
				local currently_active_unique_initiative_set_categories = {}
				local currently_active_initiatives_total = 0

				local faction_initiative_set_obj_list = context:faction():faction_initiative_sets()
				local faction_initiative_sets_total = faction_initiative_set_obj_list:num_items()

				if faction_initiative_sets_total >= required_inititiatives_for_short_victory then
					for i = 0, faction_initiative_sets_total - 1 do

						local current_initiative_set_obj = faction_initiative_set_obj_list:item_at(i)
						local current_initiative_set_category_key = current_initiative_set_obj:category_key()
						local active_initiatives_in_current_category_obj_list = current_initiative_set_obj:active_initiatives()
						local active_initiatives_in_current_category_total = active_initiatives_in_current_category_obj_list:num_items()

						if active_initiatives_in_current_category_total > 0 then
							for j = 0, active_initiatives_in_current_category_total - 1 do
								currently_active_initiatives_total = currently_active_initiatives_total + 1
							end
							
							if table.contains(gifts_of_chaos_god_categories, current_initiative_set_category_key) and not table.contains(currently_active_unique_initiative_set_categories, current_initiative_set_category_key) then
								table.insert(currently_active_unique_initiative_set_categories, current_initiative_set_obj:category_key())
							end
						end

					end
				end

				cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_chs_kholek_equip_gifts_of_gods_short", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods", currently_active_initiatives_total, required_inititiatives_for_short_victory)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_chs_kholek_equip_gifts_of_gods_long", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods_of_every_god", table.size(currently_active_unique_initiative_set_categories), table.size(gifts_of_chaos_god_categories))

				if currently_active_initiatives_total >= required_inititiatives_for_short_victory then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_chs_kholek_equip_gifts_of_gods_short", true)
				end

				if table.size(currently_active_unique_initiative_set_categories) >= table.size(gifts_of_chaos_god_categories) then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_kholek_equip_gifts_of_gods_long", true)
					core:remove_listener("IEVictoryConditionKholekActivatesGiftOfChaos")
				end
			end,
			true
		)

		-- Kholek Suneater: Subjugate 10 Factions for long victory
		core:add_listener(
			"IEVictoryConditionKholekVassalizesFaction",
			"FactionBecomesVassal",
			function(context)
				return context:vassal():master():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_subjugate_factions_long", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionKholekConfederatesFaction",
			"FactionJoinsConfederation",
			function(context)
				return context:confederation():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_subjugate_factions_long", 1)
			end,
			true
		)

		-- Kholek Suneater: Control 8 Dark Fortresses for long victory
		-- Kholek Suneater: Upgrade 3/10 units to Chaos Siege Giant, Aspiring Champions, or Gorebeast Chariots using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Sigvald the Magnificent
	["wh3_dlc20_chs_sigvald"] = function(faction_key)

		-- Sigvald the Magnificent: Vassalise 2/4 Elf or Beastmen factions via Seductive influence for short/long victory
		local cultures_to_vassalize = {
			"wh2_main_hef_high_elves",
			"wh2_main_def_dark_elves",
			"wh_dlc05_wef_wood_elves",
			"wh_dlc03_bst_beastmen"
		}
		core:add_listener(
			"IEVictoryConditionSigvaldVassalizeFaction",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "FORCE_VASSAL" and context:performing_faction():name() == faction_key and table.contains(cultures_to_vassalize, context:ritual_target_faction():culture())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_sigvald_vassalize_factions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_sigvald_vassalize_factions_long", 1)
			end,
			true
		)

		-- Sigvald the Magnificent: Seduce units 20/50 times in battle for short/long victory
		core:add_listener(
			"IEVictoryConditionSigvaldSeducesUnit",
			"FactionPaidForBribingUnits",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local bribed_units_count = context:units_count()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_sigvald_seduce_units_short", bribed_units_count)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_sigvald_seduce_units_long", bribed_units_count)
			end,
			true
		)

		-- Sigvald: Sacrifice 5000/15000 Souls to Slaanesh for short/long victory
		-- Sigvald the Magnificent: Control 8 Dark Fortresses for long victory
		-- Sigvald the Magnificent: Upgrade 3/10 units to Champions of Slaanesh using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Belakor
	["wh3_main_chs_shadow_legion"] = function(faction_key)

		-- Belakor: Equip 4 Gifts of the Gods for short victory
		-- Belakor: Equip Gifts of the Gods of every chaos god for long victory
		-- Belakor: Equip Gifts of the Gods in all available slots for long victory
		local gifts_of_chaos_god_categories = {
			"DLC20_KHORNE_INITIATIVES",
			"DLC20_NURGLE_INITIATIVES",
			"DLC20_SLAANESH_INITIATIVES",
			"DLC20_TZEENTCH_INITIATIVES",
			
		}
		local undivided_gifts_of_chaos_category = "DLC20_UNDIVIDED_INITIATIVES"
		local required_inititiatives_for_short_victory = 4
		local required_inititiatives_for_long_victory = 11
		core:add_listener(
			"IEVictoryConditionBelakorActivatesGiftOfChaos",
			"FactionInitiativeActivationChangedEvent",
			function(context)
				local initiative_category_key = context:initiative_set():category_key()
				return context:faction():name() == faction_key and (table.contains(gifts_of_chaos_god_categories, initiative_category_key) or initiative_category_key == undivided_gifts_of_chaos_category)
			end,
			function(context)
				local currently_active_unique_initiative_set_categories = {}
				local currently_active_initiatives_total = 0

				local faction_initiative_set_obj_list = context:faction():faction_initiative_sets()
				local faction_initiative_sets_total = faction_initiative_set_obj_list:num_items()

				if faction_initiative_sets_total >= required_inititiatives_for_short_victory then
					for i = 0, faction_initiative_sets_total - 1 do

						local current_initiative_set_obj = faction_initiative_set_obj_list:item_at(i)
						local current_initiative_set_category_key = current_initiative_set_obj:category_key()
						local active_initiatives_in_current_category_obj_list = current_initiative_set_obj:active_initiatives()
						local active_initiatives_in_current_category_total = active_initiatives_in_current_category_obj_list:num_items()

						if active_initiatives_in_current_category_total > 0 then
							for j = 0, active_initiatives_in_current_category_total - 1 do
								currently_active_initiatives_total = currently_active_initiatives_total + 1
							end
							
							if table.contains(gifts_of_chaos_god_categories, current_initiative_set_category_key) and not table.contains(currently_active_unique_initiative_set_categories, current_initiative_set_category_key) then
								table.insert(currently_active_unique_initiative_set_categories, current_initiative_set_obj:category_key())
							end
						end

					end
				end

				cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_short", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods", currently_active_initiatives_total, required_inititiatives_for_short_victory)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_all_slots_long", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_god_all_slots", currently_active_initiatives_total, required_inititiatives_for_long_victory)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_long", "mission_text_text_wh3_dlc29_chs_equip_gifts_of_gods_of_every_god", table.size(currently_active_unique_initiative_set_categories), table.size(gifts_of_chaos_god_categories))


				if currently_active_initiatives_total >= required_inititiatives_for_short_victory then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_short", true)
				end

				if currently_active_initiatives_total >= required_inititiatives_for_long_victory then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_all_slots_long", true)
					core:remove_listener("IEVictoryConditionBelakorActivatesGiftOfChaos")
				end

				if table.size(currently_active_unique_initiative_set_categories) >= table.size(gifts_of_chaos_god_categories) then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_belakor_equip_gifts_of_gods_long", true)
				end
			end,
			true
		)

		-- Belakor: Turn 1/3 Lords into Daemon Prince for short/long victory
		core:add_listener(
			"IEVictoryConditionBelakorCreatesDaemonPrince",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and context:dilemma() == "wh3_main_incident_belakor_daemon_prince_created"
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_chs_belakor_create_daemon_prince_short", true)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_belakor_create_daemon_prince_long", 1)
			end,
			true
		)

		-- Belakor: Control 8 Dark Fortresses for long victory
		-- Belakor: Upgrade 3/10 units to Chaos Siege Giant, Aspiring Champions, or Gorebeast Chariots using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Festus the Leechlord
	["wh3_dlc20_chs_festus"] = function(faction_key)

		-- Festus the Leechlord: Turn 1 Lord into Daemon Prince of Nurgle for long victory
		local daemon_prince_initiatives_prefix = "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle"
		core:add_listener(
			"IEVictoryConditionFestusCreatesDaemonPrince",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:initiative():record_key():starts_with(daemon_prince_initiatives_prefix)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_festus_create_daemon_prince_long", true)
			end,
			false
		)

		-- Festus the Leechlord: Have Plagues spread 50/100 times for short/long victory
		core:add_listener(
			"IEVictoryObjectiveFestusRegionInfected",
			"RegionInfectionEvent",
			function(context)
				return context:plague():creator_faction():name() == faction_key and not context:is_removed()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_festus_spread_plagues_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_festus_spread_plagues_long", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryObjectiveFestusMilitaryForceInfected",
			"MilitaryForceInfectionEvent",
			function(context)
				return context:plague():creator_faction():name() == faction_key and not context:is_removed()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_festus_spread_plagues_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_festus_spread_plagues_long", 1)
			end,
			true
		)

		-- Festus: Sacrifice 5000/15000 Souls to Nurgle for short/long victory
		-- Festus the Leechlord: Control 8 Dark Fortresses for long victory
		-- Festus the Leechlord: Upgrade 3/10 units Putrid Blightkings or Rot Knights using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Azazel
	["wh3_dlc20_chs_azazel"] = function(faction_key)

		-- Azazel: Vassalise 2/4 Human factions via Seductive influence for short/long victory
		local cultures_to_vassalize = {
			"wh_main_emp_empire",
			"wh3_main_cth_cathay",
			"wh_main_brt_bretonnia",
			"wh3_main_ksl_kislev",
		}
		core:add_listener(
			"IEVictoryConditionAzazelVassalizeFaction",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "FORCE_VASSAL" and context:performing_faction():name() == faction_key and table.contains(cultures_to_vassalize, context:ritual_target_faction():culture())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_azazel_vassalize_factions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_azazel_vassalize_factions_long", 1)
			end,
			true
		)

		-- Azazel: Seduce units 20/50 times in battle for short/long victory
		core:add_listener(
			"IEVictoryConditionAzazelSeducesUnit",
			"FactionPaidForBribingUnits",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local bribed_units_count = context:units_count()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_azazel_seduce_units_short", bribed_units_count)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_azazel_seduce_units_long", bribed_units_count)
			end,
			true
		)

		-- Azazel: Turn 1 Lord into Daemon Prince of Slaanesh for long victory
		local daemon_prince_initiatives_prefix = "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh"
		core:add_listener(
			"IEVictoryConditionAzazelCreatesDaemonPrince",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:initiative():record_key():starts_with(daemon_prince_initiatives_prefix)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_azazel_create_daemon_prince_long", true)
			end,
			false
		)

		-- Azazel: Control Praag and upgrade it to Dark Fortress level for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionChsAzazelBuildDarkFortressShort",
			"wh_main_short_victory",
			"wh3_dlc29_chs_azazel_construct_dark_fortress_praag_short",
			faction_key,
			"wh3_main_combi_region_praag",
			{"wh3_dlc20_settlement_woc_dark_fortress_4"}
		)

		-- Azazel: Sacrifice 5000/15000 Souls to Slaanesh for short/long victory
		-- Azazel: Control 8 Dark Fortresses for long victory
		-- Azazel: Upgrade 3/10 units to Champions of Slaanesh using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)

	end,

	-- Vilitch
	["wh3_dlc20_chs_vilitch"] = function(faction_key)

		-- Vilitch: Turn 1 Lord into Daemon Prince of Tzeentch for long victory
		local daemon_prince_initiatives_prefix = "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch"
		core:add_listener(
			"IEVictoryConditionVilitchCreatesDaemonPrince",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:initiative():record_key():starts_with(daemon_prince_initiatives_prefix)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_vilitch_create_daemon_prince_long", true)
			end,
			false
		)

		-- Vilitch: Perform 20/40 Changing of the Ways actions for short/long victory
		local tzeentch_cotw_ritual_key = "_tze_cotw_"
		core:add_listener(
			"IEVictoryConditionVilitchPerformCOTWRitual",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.find(context:ritual():ritual_key(), tzeentch_cotw_ritual_key)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_vilitch_perform_cotw_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_vilitch_perform_cotw_actions_long", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionPerformCOTWDiplomacyManipulationsPerform",
			"DiplomacyManipulationExecutedEvent",
			function(context)
				return context:performing_faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_vilitch_perform_cotw_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_vilitch_perform_cotw_actions_long", 1)
			end,
			true
		)

		-- Vilitch: Sacrifice 5000/15000 Souls to Tzeentch for short/long victory
		-- Vilitch: Control 8 Dark Fortresses for long victory
		-- Vilitch: Upgrade 3/10 units to Doom Knights of Tzeentch using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)
	end,

	-- Valkia
	["wh3_dlc20_chs_valkia"] = function(faction_key)

		-- Valkia: Turn 1 Lord into Daemon Prince of Khorne for long victory
		local daemon_prince_initiatives_prefix = "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne"
		core:add_listener(
			"IEVictoryConditionValkiaCreatesDaemonPrince",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:initiative():record_key():starts_with(daemon_prince_initiatives_prefix)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_chs_valkia_create_daemon_prince_long", true)
			end,
			false
		)

		-- Valkia: Kill 25/50 Lords in battle for short/long victory
		core:add_listener(
			"IEVictoryConditionChsValkiaKillLords",
			"CharacterConvalescedOrKilled",
			function(context)
				return context:character():faction():name() ~= faction_key
						and context:character():character_details():character_type("general")
						and context:character():convalesence_cause() == 3
						and cm:pending_battle_cache_faction_is_involved(faction_key)
						and cm:pending_battle_cache_fm_is_involved(context:character():family_member())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_chs_valkia_kill_lords_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_chs_valkia_kill_lords_long", 1)
			end,
			true
		)

		-- Valkia: Sacrifice 5000/15000 Souls to Khorne for short/long victory
		-- Valkia: Control 8 Dark Fortresses for long victory
		-- Valkia: Upgrade 3/10 units to Skullcrushers of Khorne or Gorebeast Chariots of Khorne using Warband upgrades for short/long victory
		_victory_objectives_ie.listeners.chs_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["chs_shared_objective_listeners"] = function(faction_key)

		-- (All): Control 8 Dark fortresses for long victory
		-- Archaon The Everchosen: Control 8 Dark fortresses for short victory
		local dark_fortress_required_amount = 8

		local mission_data_list = {
			wh_main_chs_chaos = 			{victory_mission = "wh_main_short_victory", script_key = "wh3_dlc29_main_chs_control_n_dark_fortresses_short"},
			wh3_dlc20_chs_kholek = 			{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_kholek_control_n_dark_fortresses_long"},
			wh3_dlc20_chs_sigvald = 		{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_sigvald_control_n_dark_fortresses_long"},
			wh3_main_chs_shadow_legion = 	{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_belakor_control_n_dark_fortresses_long"},
			wh3_dlc20_chs_festus = 			{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_festus_control_n_dark_fortresses_long"},
			wh3_dlc20_chs_azazel = 			{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_azazel_control_n_dark_fortresses_long"},
			wh3_dlc20_chs_vilitch = 		{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_vilitch_control_n_dark_fortresses_long"},
			wh3_dlc20_chs_valkia = 			{victory_mission = "wh_main_long_victory", 	script_key = "wh3_dlc29_chs_valkia_control_n_dark_fortresses_long"},
			wh3_dlc29_chs_host_of_the_triplets = {victory_mission = "wh_main_short_victory", 	script_key = "wh3_dlc29_chs_glottkin_control_n_dark_fortresses_short"},
		}

		core:add_listener(
			"IEVictoryConditionCapturesDarkFortress" .. faction_key,
			"RegionFactionChangeEvent",
			function(context)
				return context:region():is_contained_in_region_group("wh3_dlc20_dark_fortress_region_group")
			end,
			function(context)
				local region_obj = context:region()
				local region_key = region_obj:name()
				local controlled_dark_fortresses_key_list = cm:get_saved_value("victory_conditions_controlled_dark_fortresses" .. faction_key) or {}
				local controlled_fortresses_total = table.size(controlled_dark_fortresses_key_list)

				if region_obj:owning_faction():name() == faction_key then
					table.insert(controlled_dark_fortresses_key_list, region_key)
					cm:set_saved_value("victory_conditions_controlled_dark_fortresses" .. faction_key, controlled_dark_fortresses_key_list)
					controlled_fortresses_total = controlled_fortresses_total + 1
					cm:set_scripted_mission_text(mission_data_list[faction_key].victory_mission, mission_data_list[faction_key].script_key, "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", controlled_fortresses_total, dark_fortress_required_amount)
				elseif context:previous_faction():name() == faction_key then
					local _, idx = table.find(controlled_dark_fortresses_key_list, region_key)
					if idx then
						table.remove(controlled_dark_fortresses_key_list, idx)
						controlled_fortresses_total = controlled_fortresses_total - 1
						cm:set_scripted_mission_text(mission_data_list[faction_key].victory_mission, mission_data_list[faction_key].script_key, "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short", controlled_fortresses_total, dark_fortress_required_amount)
					end
				end
				
				if controlled_fortresses_total >= dark_fortress_required_amount then
					core:remove_listener("IEVictoryConditionCapturesDarkFortress" .. faction_key)
					if faction_key == "wh_main_chs_chaos" then
						core:trigger_event("ScriptEventArchaonPreparesWarband")
					end
				end
			end,
			true
		)

		-- Kholek: Suneater: Upgrade 3/10 units to Chaos Siege Giant, Aspiring Champions, or Gorebeast Chariots using Warband upgrades for short/long victory
		-- Sigvald: the Magnificent: Upgrade 3/10 units to Champions of Slaanesh using Warband upgrades for short/long victory
		-- Belakor: Upgrade 3/10 units to Chaos Siege Giant, Aspiring Champions, or Gorebeast Chariots using Warband upgrades for short/long victory
		-- Festus: the Leechlord: Upgrade 3/10 units to Putrid Blightkings or Rot Kings using Warband upgrades for short/long victory
		-- Azazel: Upgrade 3/10 units to Champions of Slaanesh using Warband upgrades for short/long victory
		-- Vilitch: Upgrade 3/10 units to Doom Knights of Tzeentch using Warband upgrades for short/long victory
		-- Valkia: Upgrade 3/10 units to Skullcrushers of Khorne or Gorebeast Chariots of Khorne using Warband upgrades for short/long victory

		local required_warband_units_per_faction = {
			wh3_dlc20_chs_kholek = { 
				short_script_key = "wh3_dlc29_chs_kholek_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_kholek_warband_upgrade_units_long", 
				unit_list = {
					"wh3_dlc29_chs_mon_chaos_siege_giant",
					"wh_dlc06_chs_inf_aspiring_champions_0",
					"wh_dlc01_chs_cav_gorebeast_chariot",
					"wh3_main_kho_cav_gorebeast_chariot"
				}
			},

			wh3_dlc20_chs_sigvald = {
				short_script_key = "wh3_dlc29_chs_sigvald_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_sigvald_warband_upgrade_units_long", 
				unit_list = {
					"wh3_dlc27_sla_mon_champions_of_slaanesh",
				}
			},

			wh3_main_chs_shadow_legion = {
				short_script_key = "wh3_dlc29_chs_belakor_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_belakor_warband_upgrade_units_long", 
				unit_list = {
					"wh3_dlc29_chs_mon_chaos_siege_giant",
					"wh_dlc06_chs_inf_aspiring_champions_0",
					"wh_dlc01_chs_cav_gorebeast_chariot",
					"wh3_main_kho_cav_gorebeast_chariot"
				}
			},
			
			wh3_dlc20_chs_festus = {
				short_script_key = "wh3_dlc29_chs_festus_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_festus_warband_upgrade_units_long", 
				unit_list = {
					"wh3_dlc20_chs_inf_chosen_mnur",
					"wh3_dlc20_chs_inf_chosen_mnur_greatweapons",
					"wh3_dlc29_chs_inf_chosen_mnur_ror",
				}
			},

			wh3_dlc20_chs_azazel = {
				short_script_key = "wh3_dlc29_chs_azazel_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_azazel_warband_upgrade_units_long", 
				unit_list = {
					"wh3_dlc20_chs_inf_chosen_msla",
					"wh3_dlc20_chs_inf_chosen_msla_hellscourges",
				}
			},

			wh3_dlc20_chs_vilitch = {
				short_script_key = "wh3_dlc29_chs_vilitch_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_vilitch_warband_upgrade_units_long", 
				unit_list = {
					"wh3_main_tze_cav_doom_knights_0",
				}
			},

			wh3_dlc20_chs_valkia = {
				short_script_key = "wh3_dlc29_chs_valkia_warband_upgrade_units_short", 
				long_script_key = "wh3_dlc29_chs_valkia_warband_upgrade_units_long", 
				unit_list = {
					"wh3_main_kho_cav_gorebeast_chariot",
					"wh3_main_kho_cav_skullcrushers_0",
				}
			},
		}

		if required_warband_units_per_faction[faction_key] then 
			core:add_listener(
				"IEVictoryConditionWarbandUpgradeUnit" .. faction_key,
				"UnitUpgraded",
				function(context)
					local unit_obj = context:unit()
					return unit_obj:faction():name() == faction_key and table.contains(required_warband_units_per_faction[faction_key].unit_list, unit_obj:unit_key())
				end,
				function(context)
					cm:increase_scripted_mission_count("wh_main_short_victory", required_warband_units_per_faction[faction_key].short_script_key, 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", required_warband_units_per_faction[faction_key].long_script_key, 1)
				end,
				true
			)
		end

		-- Festus: Sacrifice 5000/15000 Souls to Nurgle for short/long victory
		-- Sigvald: Sacrifice 5000/15000 Souls to Slaanesh for short/long victory
		-- Azazel: Sacrifice 5000/15000 Souls to Slaanesh for short/long victory
		-- Valkia: Sacrifice 5000/15000 Souls to Khorne for short/long victory
		-- Vilitch: Sacrifice 5000/15000 Souls to Tzeentch for short/long victory

		local sacrifice_souls_objective_data = {
			wh3_dlc20_chs_festus = {
				short_script_key = "wh3_dlc29_chs_festus_sacrifice_souls_short", 
				long_script_key = "wh3_dlc29_chs_festus_sacrifice_souls_long", 
				pooled_resource_key  = "wh3_dlc20_chs_souls_spent_nur",
			},
			wh3_dlc20_chs_sigvald = {
				short_script_key = "wh3_dlc29_chs_sigvald_sacrifice_souls_short", 
				long_script_key = "wh3_dlc29_chs_sigvald_sacrifice_souls_long", 
				pooled_resource_key  = "wh3_dlc20_chs_souls_spent_sla",
			},
			wh3_dlc20_chs_azazel = {
				short_script_key = "wh3_dlc29_chs_azazel_sacrifice_souls_short", 
				long_script_key = "wh3_dlc29_chs_azazel_sacrifice_souls_long", 
				pooled_resource_key  = "wh3_dlc20_chs_souls_spent_sla",
			},
			wh3_dlc20_chs_valkia = {
				short_script_key = "wh3_dlc29_chs_valkia_sacrifice_souls_short", 
				long_script_key = "wh3_dlc29_chs_valkia_sacrifice_souls_long", 
				pooled_resource_key  = "wh3_dlc20_chs_souls_spent_kho",
			},
			wh3_dlc20_chs_vilitch = {
				short_script_key = "wh3_dlc29_chs_vilitch_sacrifice_souls_short", 
				long_script_key = "wh3_dlc29_chs_vilitch_sacrifice_souls_long", 
				pooled_resource_key  = "wh3_dlc20_chs_souls_spent_tze",
			},
		}

		if sacrifice_souls_objective_data[faction_key] then
			core:add_listener(
				"IEVictoryConditionSoulsSacrificed" .. faction_key,
				"PooledResourceChanged",
				function(context)
					return context:has_faction() and not context:faction():is_null_interface() and context:faction():name() == faction_key and context:resource():key() == sacrifice_souls_objective_data[faction_key].pooled_resource_key
				end,
				function(context)
					local changed_amount = context:amount()
					cm:increase_scripted_mission_count("wh_main_short_victory", sacrifice_souls_objective_data[faction_key].short_script_key, changed_amount)
					cm:increase_scripted_mission_count("wh_main_long_victory", sacrifice_souls_objective_data[faction_key].long_script_key, changed_amount)
				end,
				true
			)
		end
	end,

----- EMPIRE -----

	-- Boris Toddbringer
	["wh_main_emp_middenland"] = function(faction_key)

		-- Boris Toddbringer: Construct the Knights of the Whiote Wolf and Knights Panther Chapterhouse landmarks
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionEmpBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_construct_boris_landmark_short",
			faction_key,
			{
				wh3_main_combi_region_carroburg = "wh_main_special_knights_panther_chapterhouse",
				wh3_main_combi_region_salzenmund = "wh3_dlc29_special_salzenmund_chapter_house_white_wolf",
			}
		)

		-- Boris Toddbringer: Construct the Great Fortress-Temple of Middenheim Landmark building
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionEmpBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_construct_boris_landmark_long",
			faction_key,
			{
				wh3_main_combi_region_middenheim = "wh_main_special_great_temple_of_ulric_4",
			}
		)

		-- Boris Todbringer: Perform 4 unique Winter Rites for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS(
			"IEVictoryConditionEmpBorisWinterRitesShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_boris_perform_winter_rites_short",
			faction_key,
			"wh3_dlc29_middenland_",
			"_u2"
		)

		-- Boris Toddbringer: Defeat Chaos factions in battle x times for long victory
		core:add_listener(
			"IEVictoryConditionEmpBorisWinBattlesAgainstChaos",
			"BattleCompleted",
			function(context)
				local pb = cm:model():pending_battle()
				return pb:has_been_fought() and cm:pending_battle_cache_faction_won_battle(faction_key) and 
					(cm:pending_battle_cache_culture_is_involved("wh3_main_kho_khorne") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_nur_nurgle") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_sla_slaanesh")
					or cm:pending_battle_cache_culture_is_involved("wh3_main_tze_tzeentch")
					or cm:pending_battle_cache_culture_is_involved("wh3_main_dae_daemons")
					or cm:pending_battle_cache_culture_is_involved("wh_main_chs_chaos"))
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_boris_defeat_chaos_armies_in_battle_long", 1)
			end,
			true
		)

	end,

	-- Karl Franz
	["wh_main_emp_empire"] = function(faction_key)

		-- Karl Franz: Construct Castle Reikguard and Altdorf Colleges of Magic Landmark buildings in Altdorf for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpKarlBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_construct_karl_landmark_short",
			faction_key,
			"wh3_main_combi_region_altdorf",
			{"wh2_main_special_altdorf_castle_reikguard"}
		)

		-- Karl Franz: Recruit 5 Elector Count State Troops and increase their rank to rank 6 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionEmpKarlRankupUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_karl_rankup_units_short",
			faction_key,
			{"wh2_dlc13_emp_inf_greatswords_ror_0",
			"wh2_dlc13_emp_cav_empire_knights_ror_0",
			"wh2_dlc13_emp_cav_empire_knights_ror_1",
			"wh2_dlc13_emp_cav_empire_knights_ror_2",
			"wh2_dlc13_emp_cav_outriders_ror_0",
			"wh2_dlc13_emp_inf_spearmen_ror_0",
			"wh2_dlc13_emp_inf_swordsmen_ror_0",
			"wh2_dlc13_emp_inf_halberdiers_ror_0",
			"wh2_dlc13_emp_inf_handgunners_ror_0",
			"wh2_dlc13_emp_art_mortar_ror_0",
			"wh2_dlc13_emp_inf_crossbowmen_ror_0",
			"wh2_dlc13_emp_cav_pistoliers_ror_0",
			"wh2_dlc13_emp_veh_steam_tank_ror_0",},
			6
		)

		-- Karl Franz: Appoint Elector Counts to 3 Different Seats for short victory
		core:add_listener(
			"IEVictoryConditionEmpKarlAppointElectorCounts",
			"CharacterAssignedToPost",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local new_ministerial_position = context:character():ministerial_position()
				local elector_counts_table = cm:get_saved_value("IEVIctoryConditionEmpKarlAppointedElectorCountSeats") or {}
				if not table.contains(elector_counts_table, new_ministerial_position) then
					table.insert(elector_counts_table, new_ministerial_position)
					cm:set_saved_value("IEVIctoryConditionEmpKarlAppointedElectorCountSeats", elector_counts_table)
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_karl_appoint_elector_counts_short", 1)
				end
			end,
			true
		)

		-- Karl Franz: Construct Imperial Palace landmark building and College of Magic in Altdorf for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpKarlBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_construct_karl_landmark_long",
			faction_key,
			"wh3_main_combi_region_altdorf",
			{"wh2_main_special_altdorf_imperial_palace", "wh_main_special_college_of_magic"}
		)

		-- Karl Franz: Use 4 unique Emperor?s Decrees for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS(
			"IEVictoryConditionEmpKarlDecreesShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_karl_perform_decrees_short",
			faction_key,
			"wh3_dlc25_emperors_decrees_",
			"_upgraded"
		)

		-- Karl Franz: Use 9 unique Emperor?s Decrees for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS(
			"IEVictoryConditionEmpKarlDecreesLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_karl_perform_decrees_long",
			faction_key,
			"wh3_dlc25_emperors_decrees_",
			"_upgraded"
		)

		-- Karl Franz: Summon the elector counts for long victory
		core:add_listener(
			"IEVictoryConditionEmpKarlSummonElectorCounts",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_key() == "wh3_dlc25_summon_the_elector_counts"
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_emp_karl_summon_the_elector_counts_long", true)
			end,
			true
		)

	end,

	-- Balthazar Gelt
	["wh2_dlc13_emp_golden_order"] = function(faction_key)

		local wizard_subtype_key_list = {
			"wh_main_emp_light_wizard",
			"wh_main_emp_celestial_wizard",
			"wh_main_emp_bright_wizard",
			"wh_dlc05_emp_grey_wizard",
			"wh_dlc05_emp_jade_wizard",
			"wh_dlc03_emp_amber_wizard",
			"wh3_dlc25_emp_gold_wizard",
			"wh2_pro07_emp_amethyst_wizard",
		}

		local gelt_repeatable_rituals = {
			"wh3_dlc25_college_of_magic_wizard_amber",
			"wh3_dlc25_college_of_magic_wizard_amethyst",
			"wh3_dlc25_college_of_magic_wizard_bright",
			"wh3_dlc25_college_of_magic_wizard_celestial",
			"wh3_dlc25_college_of_magic_wizard_grey",
			"wh3_dlc25_college_of_magic_wizard_jade",
			"wh3_dlc25_college_of_magic_wizard_light",
			"wh3_dlc25_college_of_magic_wizard_metal",
			"wh3_dlc25_college_of_magic_metal_transmutation",
			"wh3_dlc25_college_of_magic_bright_damage_walls",
			"wh3_dlc25_college_of_magic_grey_ambush_attack",
			"wh3_dlc25_college_of_magic_amber_cata_spell",
			"wh3_dlc25_college_of_magic_amber_summon",
			"wh3_dlc25_college_of_magic_amethyst_cata_spell",
			"wh3_dlc25_college_of_magic_bright_cata_spell",
			"wh3_dlc25_college_of_magic_celestial_cata_spell",
			"wh3_dlc25_college_of_magic_grey_cata_spell",
			"wh3_dlc25_college_of_magic_jade_cata_spell",
			"wh3_dlc25_college_of_magic_light_barrier",
			"wh3_dlc25_college_of_magic_light_cata_spell",
			"wh3_dlc25_college_of_magic_metal_corrosion",
			"wh3_dlc25_college_of_magic_celestial_action_points",
			"wh3_dlc25_college_of_magic_amethyst_damage_enemies",
			"wh3_dlc25_college_of_magic_jade_heal",
		}

		local gelt_single_use_riutals = {
			"wh3_dlc25_college_of_magic_amber_costs",
			"wh3_dlc25_college_of_magic_amber_item",
			"wh3_dlc25_college_of_magic_amethyst_costs",
			"wh3_dlc25_college_of_magic_amethyst_item",
			"wh3_dlc25_college_of_magic_bright_costs",
			"wh3_dlc25_college_of_magic_bright_item",
			"wh3_dlc25_college_of_magic_celestial_costs",
			"wh3_dlc25_college_of_magic_celestial_item",
			"wh3_dlc25_college_of_magic_grey_costs",
			"wh3_dlc25_college_of_magic_grey_item",
			"wh3_dlc25_college_of_magic_jade_costs",
			"wh3_dlc25_college_of_magic_jade_item",
			"wh3_dlc25_college_of_magic_light_costs",
			"wh3_dlc25_college_of_magic_light_item",
			"wh3_dlc25_college_of_magic_metal_armour",
			"wh3_dlc25_college_of_magic_metal_cata_spell",
			"wh3_dlc25_college_of_magic_metal_costs",
			"wh3_dlc25_college_of_magic_metal_weapon",
		}

		-- Balthazar Gelt: Build landmark Temple of Elemental Winds for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpGeltBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_gelt_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_temple_of_elemental_winds",
			{"wh3_dlc25_special_gelt_elemental_temple"}
		)

		-- Balthazar Gelt: Recruit and rank up 2 Battle Wizards to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionGeltRankUpWizardsShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_short",
			faction_key,
			wizard_subtype_key_list,
			10,
			2,
			nil,
			nil,
			true
		)

		-- Balthazar Gelt: Have 4 Battle Wizards that are at least rank 20 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionGeltRankUpWizardsLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_long",
			faction_key,
			wizard_subtype_key_list,
			20,
			4,
			true,
			"mission_text_text_wh3_dlc29_emp_gelt_rank_up_n_battle_wizards_long",
			true
		)

		-- Balthazar Gelt: Complete 12/24 College of Magic Repeatable Actions for short/long victory
		core:add_listener(
			"IEVictoryConditionEmpGeltPerformCollegeActions",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(gelt_repeatable_rituals, context:ritual():ritual_key())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_gelt_complete_n_college_of_magic_actions_long", 1)
			end,
			true
		)

		-- Balthazar Gelt: Complete 1/5 College of Magic Single use Actions for short/long victory
		core:add_listener(
			"IEVictoryConditionEmpGeltPerformCollegeActions",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(gelt_single_use_riutals, context:ritual():ritual_key())
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_emp_gelt_complete_com_single_actions_short", true)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_gelt_complete_com_single_actions_long", 1)
			end,
			true
		)

	end,

	-- Markus Wulfhart
	["wh2_dlc13_emp_the_huntmarshals_expedition"] = function(faction_key)

		-- Markus Wulfhart: Unlock all unique hunters for short victory
		core:add_listener(
			"IEVictoryConditionEmpWulfhartUnlocksHunters",
			"HunterUnlocked",
			true,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_wulfhart_unlock_all_hunters_short", 1)
			end,
			true
		)

		-- Markus Wulfhart: Complete all stories of the 4 unique hunters for long victory
		core:add_listener(
			"IEVictoryConditionEmpWulfhartCompleteHuntersStory",
			"ScriptEventHunterStoryCompleted",
			true,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_wulfhart_unlock_all_hunters_stories_long", 1)
			end,
			true
		)

		-- Markus Wulfhart: Receive Imperial Supplies 5 times for short victory
		core:add_listener(
			"IEVictoryConditionEmpWulfhartReceiveSuppliesIncident",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), "wh2_dlc13_wulfhart_extra_reinforcement_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_wulfhart_receive_supplies_short", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionEmpWulfhartReceiveSuppliesDilemma",
			"DilemmaIssuedEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), "wh2_dlc13_wulfhart_imperial_guards_st_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_wulfhart_receive_supplies_short", 1)
			end,
			true
		)

		-- Markus Wulfhart: Reach level 5 Hostility 5 times for long victory
		core:add_listener(
			"IEVictoryConditionEmpWulfhartReachMaxHostility",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), "wh2_dlc13_emp_wulfhart_wanted_level_5")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_wulfhart_reach_hostility_long", 1)
			end,
			true
		)

	end,

	-- Volkmar the Grim
	["wh3_main_emp_cult_of_sigmar"] = function(faction_key)

		-- Volkmar the Grim: Seal 5 Books of Nagash for short victory
		-- Volkmar the Grim: Seal all (9) Books of Nagash for long victory
		local books_of_nagash_to_collect_short = 5
		local books_of_nagash_to_collect_long = 9

		local function update_books_of_nagash_objective(books_amount)
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_short", "mission_text_text_wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_short", books_amount, books_of_nagash_to_collect_short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_long", "mission_text_text_wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_long", books_amount, books_of_nagash_to_collect_long)
			if (books_amount >= books_of_nagash_to_collect_long) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_long", true)
			end
			if (books_amount >= books_of_nagash_to_collect_short) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_emp_volkmar_seal_n_books_of_nagash_short", true)
			end
		end

		core:add_listener(
			"IEVictoryConditionUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				update_books_of_nagash_objective(context.number)
			end,
			true
		)

		-- Volkmar the Grim: Build Landmark: Buried Caravanserai, Vault of Nagash for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionEmpVolkmarBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_volkmar_construct_landmark_short",
			faction_key,
			{
				wh3_main_combi_region_great_desert_of_araby = "wh3_main_special_the_great_desert_other_2",
				wh3_main_combi_region_black_pyramid_of_nagash = "wh2_main_special_pyramid_of_nagash_other",
			}
		)

		-- Volkmar the Grim: Construct the Great Halls of Nagashizzar Landmark Building in Nagashizzar for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpVolkmarBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_volkmar_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_nagashizzar",
			{"wh2_dlc14_special_nagashizzar_other"}
		)

		-- Volkmar the Grim: Have 3 Warrior Priests that are at least rank 20 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionVolkmarRankUpPriestsLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_volkmar_rankup_n_warrior_priests_long",
			faction_key,
			{"wh_main_emp_warrior_priest"},
			20,
			3,
			true,
			"mission_text_text_wh3_dlc29_emp_volkmar_rankup_n_warrior_priests_long"
		)

	end,

	-- Elspeth von Draken
	["wh_main_emp_wissenland"] = function(faction_key)

		-- Elspeth von Draken: Upgrade to Tier III ? Laboratorium Magi in Imperial Gunnery School for short victory
		core:add_listener(
			"IEVictoryConditionCollectBooksOfNagash",
			"GunnerySchoolTierComplete3",
			true,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_short", true)
			end,
			false
		)

		-- Elspeth von Draken: Upgrade to Tier IV ? Academy of Excellence in Imperial Gunnery School for long victory
		core:add_listener(
			"IEVictoryConditionLoseBooksOfNagash",
			"GunnerySchoolTierComplete4",
			true,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_emp_elspeth_unlock_gunnery_school_tier_long", true)
			end,
			false
		)

		-- Elspeth von Draken: Construct the Nuln Cannon Foundry Landmark Building in Nuln for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpElspethBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_emp_elspeth_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_nuln",
			{"wh_main_special_nuln_cannon_foundry"}
		)

		-- Elspeth von Draken: Build 2 Gardens of Morr for short victory
		-- Elspeth von Draken: Build 5 Gardens of Morr for long victory
		core:add_listener(
			"IEVictoryConditionElspethBuildGoM",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_key() == "wh3_dlc25_emp_ritual_construct_black_tower"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_elspeth_construct_n_gardens_of_morr_long", 1)
			end,
			true
		)

		-- Elspeth von Draken: Upgrade units in the Imperial Armoury 10 times for short victory
		local imperial_armory_ritual_list = {
			"wh3_dlc25_ritual_emp_don_cannons_1",
			"wh3_dlc25_ritual_emp_don_cannons_2",
			"wh3_dlc25_ritual_emp_don_cannons_3",
			"wh3_dlc25_ritual_emp_don_cav_guns_1",
			"wh3_dlc25_ritual_emp_don_cav_guns_2",
			"wh3_dlc25_ritual_emp_don_cav_guns_3",
			"wh3_dlc25_ritual_emp_don_helblasters_1",
			"wh3_dlc25_ritual_emp_don_helblasters_2",
			"wh3_dlc25_ritual_emp_don_helblasters_3",
			"wh3_dlc25_ritual_emp_don_helstorm_1",
			"wh3_dlc25_ritual_emp_don_helstorm_2",
			"wh3_dlc25_ritual_emp_don_helstorm_3",
			"wh3_dlc25_ritual_emp_don_inf_guns_1",
			"wh3_dlc25_ritual_emp_don_inf_guns_2",
			"wh3_dlc25_ritual_emp_don_inf_guns_3",
			"wh3_dlc25_ritual_emp_don_land_ship_1",
			"wh3_dlc25_ritual_emp_don_land_ship_2",
			"wh3_dlc25_ritual_emp_don_land_ship_3",
			"wh3_dlc25_ritual_emp_don_mortors_1",
			"wh3_dlc25_ritual_emp_don_mortors_2",
			"wh3_dlc25_ritual_emp_don_mortors_3",
			"wh3_dlc25_ritual_emp_don_steam_tank_1",
			"wh3_dlc25_ritual_emp_don_steam_tank_2",
			"wh3_dlc25_ritual_emp_don_steam_tank_3",
		}
		core:add_listener(
			"IEVictoryConditionElspethPerformsImperialArmoryUpgrades",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(imperial_armory_ritual_list, context:ritual():ritual_key())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_elspeth_perform_armory_upgrades_short", 1)
			end,
			true
		)

		-- Elspeth von Draken: Purchase 2 Amethyst Outrider units in the Amethyst Armoury for short victory
		core:add_listener(
			"IEVictoryConditionElspethPurchaseAmethystOutriders",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_key() == "wh3_dlc25_ritual_emp_don_buckshot_reaper_cap"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_emp_elspeth_purchase_amethyst_units_short", 1)
			end,
			true
		)

			-- Elspeth von Draken: Construct the Nuln Gunnery School Landmark Building in Nuln for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionEmpElspethBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_elspeth_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_nuln",
			{"wh_main_special_nuln_gunnery_school"}
		)

		-- Elspeth von Draken: Upgrade Amethyst Units in the Amethyst Armoury 6 times for long victory
		local amethyst_armory_ritual_list = {
			"wh3_dlc25_ritual_emp_don_amethyst_ironsides_1",
			"wh3_dlc25_ritual_emp_don_amethyst_ironsides_2",
			"wh3_dlc25_ritual_emp_don_amethyst_ironsides_3",
			"wh3_dlc25_ritual_emp_don_amethyst_ironsides_4",
			"wh3_dlc25_ritual_emp_don_buckshot_reaper_1",
			"wh3_dlc25_ritual_emp_don_buckshot_reaper_2",
			"wh3_dlc25_ritual_emp_don_buckshot_reaper_3",
			"wh3_dlc25_ritual_emp_don_buckshot_reaper_4",
			"wh3_dlc25_ritual_emp_don_deathstorm_battery_1",
			"wh3_dlc25_ritual_emp_don_deathstorm_battery_2",
			"wh3_dlc25_ritual_emp_don_deathstorm_battery_3",
			"wh3_dlc25_ritual_emp_don_deathstorm_battery_4",
			"wh3_dlc25_ritual_emp_don_black_rose_1",
			"wh3_dlc25_ritual_emp_don_black_rose_2",
			"wh3_dlc25_ritual_emp_don_black_rose_3",
			"wh3_dlc25_ritual_emp_don_black_rose_4",
		}
		core:add_listener(
			"IEVictoryConditionElspethPerformsAmethystArmoryUpgrades",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(amethyst_armory_ritual_list, context:ritual():ritual_key())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_emp_elspeth_perform_amethyst_upgrades_long", 1)
			end,
			true
		)

		-- Elspeth von Draken: Recruit 3 Amethyst Helstorm Rocket Battery units and increase their rank to rank 9 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionEmpElspethRankupUnitsLong",
			"wh_main_long_victory",
			"wh3_dlc29_emp_elspeth_rankup_units_long",
			faction_key,
			{"wh3_dlc25_emp_art_helstorm_rocket_battery_morr"},
			9
		)

	end,

----- NORSCA -----

	-- Wulfrik the Wanderer
	["wh_dlc08_nor_norsca"] = function(faction_key)

		-- Wulfrik the Wanderer: Attain Level 3/4 Allegiance with any god for short/long victory
		core:add_listener(
			"IEVictoryConditionNorWulfrikAttainAllegiance",
			"PooledResourceEffectChangedEvent",
			function(context)
				return string.find(context:resource():key(), "nor_progress_") and not is_nil(context:faction()) and context:faction():name() == faction_key
			end,
			function(context)
				if string.find(context:new_effect(), "_3") then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_nor_wulfrik_gain_allegiance_short", true)
				elseif string.find(context:new_effect(), "_4") then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nor_wulfrik_gain_allegiance_long", true)
					core:remove_listener("IEVictoryConditionNorWulfrikAttainAllegiance")
				end
			end,
			true
		)

		-- Wulfrik the Wanderer: Kill 5 Legendary Lords in battle for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionNorWulfrikDefeatNLegendaryLordsShort",
			"wh_main_short_victory",
			"wh3_dlc29_nor_wulfrik_kill_legendary_lords_short",
			faction_key,
			true
		)

		-- Wulfrik the Wanderer: Kill 10 Legendary Lords in battle for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionNorWulfrikDefeatNLegendaryLordsLong",
			"wh_main_long_victory",
			"wh3_dlc29_nor_wulfrik_kill_legendary_lords_long",
			faction_key,
			true
		)

	end,

	-- Throgg
	["wh_dlc08_nor_wintertooth"] = function(faction_key)

		-- Throgg: Complete 4 Monster Hunts for short victory
		core:add_listener(
			"IEVictoryConditionThroggMonsterHunts",
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				if not mission_key then
					return false
				end
				return string.find(mission_key, "_qb_nor_monster_hunt_") or (string.find(mission_key, "nor_monster_hunt_taming_") and string.find(mission_key, "stage_2"))
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_nor_throgg_monster_hunts_short", 1)
			end,
			true
		)

		-- Throgg: Construct the landmark building Cave of the Rocky Throne for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionNorThroggBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_nor_throgg_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_khazid_bordkarag",
			{"wh_main_nor_erengrad_unique"}
		)

		-- Throgg: Unlock Tier 3: The Troll-kin March for short victory
		-- Throgg: Unlock Tier 6: Empire of the Trolls for long victory
		core:add_listener(
			"IEVictoryConditionThroggExpansion",
			"PooledResourceEffectChangedEvent",
			function(context)
				return context:resource():key() == "wh3_dlc27_nor_troll_expansion"
			end,
			function(context)
				local next_effect = context:new_effect()
				if string.match(next_effect, "wh3_dlc27_bundle_nor_troll_expansion_3") then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_nor_throgg_reach_troll_tier_short", true)
				elseif string.match(next_effect, "wh3_dlc27_bundle_nor_troll_expansion_6") then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nor_throgg_reach_troll_tier_long", true)
				end
			end,
			true
		)

		-- Throgg: Become Supreme Hunter for long victory
		core:add_listener(
			"IEVictoryConditionNorThroggSupremeHunter",
			"ScriptEventUltimateMonsterHunterActivated",
			function(context)
				return context.string == faction_key
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_nor_throgg_become_supreme_hunter_long", true)
			end,
			true
		)

		-- Throgg Capture and Hold 3 out of 3 Troll Den settlements for long victory
		core:add_listener(
			"IEVictoryConditionNorThroggCaptureTrollDens",
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				return region:resource_exists("res_bile_trolls")
					or region:resource_exists("res_chaos_trolls")
					or region:resource_exists("res_river_trolls")
					or region:resource_exists("res_stone_trolls")
			end,
			function(context)
				local current_dens_total = cm:get_saved_value("nor_throgg_troll_den_captured_total") or 0
				if context:region():owning_faction():name() == faction_key then
					current_dens_total = current_dens_total + 1
				elseif context:previous_faction():name() == faction_key then
					current_dens_total = current_dens_total - 1
				end
				cm:set_saved_value("nor_throgg_troll_den_captured_total", current_dens_total)
				cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_nor_throgg_capture_troll_dens_long", "mission_text_text_wh3_dlc29_nor_throgg_capture_troll_dens_long", current_dens_total, 3)
			end,
			true
		)

	end,

	-- Sayl the Faithless
	["wh3_dlc27_nor_sayl"] = function(faction_key)

		-- Sayl the Faithless: Perform 6 Unique Manipulations for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS(
			"IEVictoryConditionNorSaylPerformManipulationsShort",
			"wh_main_short_victory",
			"wh3_dlc29_nor_sayl_perform_manipulations_short",
			faction_key,
			"wh3_dlc27_sayl_manipulations_"
		)

		-- Sayl the Faithless: Perform 12 Unique Manipulations for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS(
			"IEVictoryConditionNorSaylPerformManipulationsLong",
			"wh_main_long_victory",
			"wh3_dlc29_nor_sayl_perform_manipulations_long",
			faction_key,
			"wh3_dlc27_sayl_manipulations_"
		)

		-- Sayl the Faithless: Resolve 5 Tier 1 and Tier 2 Attention of the Gods dilemmas for short victory
		-- Sayl the Faithless: Resolve 2 Tier 3 Attention of the Gods Dilemmas for long victory
		local sayl_dilemma_key = "wh3_dlc27_sayl_manipulation_attention_"
		core:add_listener(
			"IEVictoryConditionNorSaylDilemmasComplete",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), sayl_dilemma_key)
			end,
			function(context)
				if string.starts_with(context:dilemma(), sayl_dilemma_key .. "1") or string.starts_with(context:dilemma(), sayl_dilemma_key .. "2") then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_nor_sayl_resolve_attention_dilemmas_short", 1)
				elseif string.starts_with(context:dilemma(), sayl_dilemma_key .. "3") then
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_nor_sayl_resolve_attention_dilemmas_long", 1)
				end
			end,
			true
		)

	end,

----- DARK ELF -----

	-- Malekith
	["wh2_main_def_naggarond"] = function(faction_key)

		-- Malekith: Construct Landmarks: The Altar of Ultimate Darkness, Towers of the Black Guards for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionDefMalekithBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_def_malekith_construct_landmarks_short",
			faction_key,
			{
				wh3_main_combi_region_naggarond = "wh2_main_special_naggarond_blackguard",
				wh3_main_combi_region_altar_of_ultimate_darkness = "wh2_main_special_altar_of_ultimate_darkness",
			}
		)

		-- Malekith: Confederate another Dark Elf faction for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_FACTIONS_OF_CULTURE(
			"IEVictoryConditionDefMalekithConfederateDefFactionShort",
			"wh_main_short_victory",
			"wh3_dlc29_def_malekith_confederate_def_faction_short",
			faction_key,
			1,
			"wh2_main_def_dark_elves"
		)
		
		-- Malekith: Construct Landmarks: The Black Tower of Malekith for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefMalekithBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_def_malekith_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_naggarond", 
			{"wh2_main_special_naggarond_witch_king_def"}
		)

	end,

	-- Morathi
	["wh2_main_def_cult_of_pleasure"] = function(faction_key)

		-- Morathi: Construct landmark building Vaults of Quintex for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefMorathiBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_def_morathi_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_ancient_city_of_quintex",
			{"wh2_main_special_quintex_1"}
		)

		-- Morathi: Recruit 5 Daemonettes of Slaanesh and increase their rank to Rank 6 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionDefMorathiRankupUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_def_morathi_rankup_units_short",
			faction_key,
			{"wh3_main_sla_inf_daemonette_0"},
			6
		)

		-- Morathi: Recruit 2 Supreme Sorceress' of either Lore of Magic and increase their rank to rank 10 for short victory
		local morathi_agent_subtype_key_list = {
			"wh2_dlc10_def_supreme_sorceress_beasts",
			"wh2_dlc10_def_supreme_sorceress_dark",
			"wh2_dlc10_def_supreme_sorceress_death",
			"wh2_dlc10_def_supreme_sorceress_fire",
			"wh2_dlc10_def_supreme_sorceress_shadow",
		}
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionDefMorathiRankupAgentsShort",
			"wh_main_short_victory",
			"wh3_dlc29_def_morathi_rankup_heroes_short",
			faction_key,
			morathi_agent_subtype_key_list,
			10,
			2
		)

		-- Morathi: Recruit 5 Supreme Sorceress' of each Lore of Magic and increase their rank to rank 15 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionDefMorathiRankupAgentsLong",
			"wh_main_long_victory",
			"wh3_dlc29_def_morathi_rankup_heroes_long",
			faction_key,
			morathi_agent_subtype_key_list,
			15,
			5
		)

		-- Morathi: Construct the Shrine of the Widowmaker for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefMorathiBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_def_morathi_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_shrine_of_khaine",
			{"wh2_main_special_shrine_of_khaine_def_1"}
		)

		-- Morathi: Get the Sword of Khaine for long victory
		core:add_listener(
			"IEVictoryConditionDefMorathiGainSwordOfKhaineLong",
			"CharacterAncillaryGained",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:ancillary(), "wh2_dlc10_anc_weapon_the_widowmaker_")
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_def_morathi_acquire_sword_of_khaine_long", true)
			end,
			true
		)
	end,

	-- Crone Hellebron
	["wh2_main_def_har_ganeth"] = function(faction_key)

		-- Crone Hellebron: Construct the Shrine of the Widowmaker for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefHellebronBuildLandmark1Short",
			"wh_main_short_victory",
			"wh3_dlc29_def_hellebron_construct_landmark1_short",
			faction_key,
			"wh3_main_combi_region_shrine_of_khaine",
			{"wh2_main_special_shrine_of_khaine_def_1"}
		)

		-- Crone Hellebron: Get the Sword of Khaine for short victory
		core:add_listener(
			"IEVictoryConditionDefHellebronGainSwordOfKhaineShort",
			"CharacterAncillaryGained",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:ancillary(), "wh2_dlc10_anc_weapon_the_widowmaker_")
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_def_hellebron_acquire_sword_of_khaine_short", true)
			end,
			true
		)


		-- Crone Hellebron: Recruit 2 Death Hags and increase their rank to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionDefHellebronRankupAgentsShort",
			"wh_main_short_victory",
			"wh3_dlc29_def_hellebron_rankup_heroes_short",
			faction_key,
			{"wh2_main_def_death_hag"},
			10,
			2
		)

		-- Crone Hellebron: Construct Hellebron?s Palace and the Fiery Pits of Sacrifice Landmark buildings for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefHellebronBuildLandmark2Long",
			"wh_main_long_victory",
			"wh3_dlc29_def_hellebron_construct_landmark2_long",
			faction_key,
			"wh3_main_combi_region_har_ganeth",
			{"wh2_main_special_har_ganeth_hellebron_palace", "wh2_main_special_har_ganeth_temple_of_khaine_1"}
		)

		-- Crone Hellebron: Recruit 5 Death Hags and increase their rank to rank 10 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionDefHellebronRankupAgentsLong",
			"wh_main_long_victory",
			"wh3_dlc29_def_hellebron_rankup_heroes_long",
			faction_key,
			{"wh2_main_def_death_hag"},
			10,
			5
		)

		-- Crone Hellebron: Trigger 8/20 Death Nights for short/long victory
		core:add_listener(
			"IEVictoryConditionDefHellebronDeathNight",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), "wh2_dlc10_incident_def_death_night")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_def_hellebron_trigger_death_nights_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_hellebron_trigger_death_nights_long", 1)
			end,
			true
		)

	end,

	-- Lokhir Fellheart
	["wh2_dlc11_def_the_blessed_dread"] = function(faction_key)

		-- Lokhir Fellheart: Construct Landmarks: Great Dragon Fleet Harbour for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefLokhirBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_def_lokhir_construct_landmark2_short",
			faction_key,
			"wh3_main_combi_region_fu_chow", 
			{"wh3_dlc24_special_fu_chow_port_2"}
		)

		-- Lokhir Fellheart: Recruit 2 Black Arks and upgrade them to Grand Black Ark level for short victory
		-- Lokhir Fellheart: Level up 3 Black Arks to Gargantuan Black Ark for long victory
		core:add_listener(
			"IEVictoryConditionDefLokhirBlackArksUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:building(), "wh2_main_horde_def_settlement_")
			end,
			function(context)
				local black_ark_level_name = context:building()
				if string.ends_with(black_ark_level_name, "3") then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_def_lokhir_black_arks_short", 1)
				elseif string.ends_with(black_ark_level_name, "5") then
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_lokhir_max_level_black_arks_long", 1)
				end
			end,
			true
		)
		
		-- Lokhir Fellheart: Construct Landmarks: Great Dragon Fleet Port and Raised Talon of Agon Landmarks for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionDefLokhirBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_def_lokhir_construct_landmarks_long",
			faction_key,
			{
			wh3_main_combi_region_haichai = "wh3_dlc24_special_talon_of_agony_2",
			wh3_main_combi_region_fu_chow = "wh3_dlc24_special_fu_chow_port_3",
			}
		)
		
		-- Lokhir Fellheart: Recruit 5 Black Arks for long victory
		core:add_listener(
			"IEVictoryConditionDefLokhirBlackArksRecruit",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and context:character():character_subtype("wh2_main_def_black_ark") and not context:has_respawned()
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_lokhir_black_arks_long", 1)
			end,
			true
		)
	end,

	-- Malus Darkblade
	["wh2_main_def_hag_graef"] = function(faction_key)

		-- Malus Darkblade: Use Tzarkans Demonic form in battle 3/5 times for short/long victory
		core:add_listener(
			"IEVictoryConditionDefMalusDemonicFormCasted",
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle()
				local malus_faction_cqi = cm:get_faction(faction_key):command_queue_index()
				return pb:has_been_fought()
						and cm:pending_battle_cache_faction_is_involved(faction_key)
						and (	pb:get_how_many_times_ability_has_been_used_in_battle(malus_faction_cqi, "wh2_dlc14_lord_abilities_tzarkan") > 0
						or 		pb:get_how_many_times_ability_has_been_used_in_battle(malus_faction_cqi, "wh2_dlc14_lord_abilities_tzarkan_mp") > 0
						or 		pb:get_how_many_times_ability_has_been_used_in_battle(malus_faction_cqi, "wh2_dlc14_lord_abilities_tzarkan_spite") > 0
						or 		pb:get_how_many_times_ability_has_been_used_in_battle(malus_faction_cqi, "wh2_dlc14_lord_abilities_tzarkan_spite_mp") > 0)
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_def_malus_demonic_form_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_malus_demonic_form_long", 1)
			end,
			true
		)

		-- Malus Darkblade: Complete 3 Tzarkans Whispers quests for short victory
		core:add_listener(
			"IEVictoryConditionDefMalusCompletesTzarkanWhisper",
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				if not mission_key then
					return false
				end
				return string.starts_with(mission_key, "wh2_dlc14_tzarkan_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_def_malus_tzarkan_whispers_short", 1)
			end,
			true
		)

		-- Malus Darkblade: Upgrade a Black Ark to an Enormous Black Ark level for short victory
		-- Malus Darkblade: Upgrade at least 3 Black Arcs to Grand Black Ark level or higher for long victory
		core:add_listener(
			"IEVictoryConditionDefMalusBlackArksUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:building(), "wh2_main_horde_def_settlement_")
			end,
			function(context)
				local black_ark_level_name = context:building()
				if string.ends_with(black_ark_level_name, "4") then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_def_malus_black_arks_short", true)
				elseif string.ends_with(black_ark_level_name, "3") then
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_malus_black_arks_long", 1)
				end
			end,
			true
		)

		-- Malus Darkblade: Construct the Shrine of the Widowmaker for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefMalusBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_def_malus_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_shrine_of_khaine",
			{"wh2_main_special_shrine_of_khaine_def_1"}
		)

		-- Malus Darkblade: Get the Sword of Khaine for long victory
		core:add_listener(
			"IEVictoryConditionDefMalusGainSwordOfKhaineLong",
			"CharacterAncillaryGained",
			function(context)
				return context:character():faction():name() == faction_key and string.starts_with(context:ancillary(), "wh2_dlc10_anc_weapon_the_widowmaker_")
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_def_malus_acquire_sword_of_khaine_long", true)
			end,
			true
		)

		-- Malus Darkblade: Kill 3 High Elf Legendary Lords for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionDefMalusDefeatNLegendaryLords",
			"wh_main_long_victory",
			"wh3_dlc29_def_malus_kill_hef_legendary_lords_long",
			faction_key,
			true,
			"wh2_main_hef_high_elves"
		)

	end,

	-- Rakarth
	["wh2_twa03_def_rakarth"] = function(faction_key)

		-- Rakarth: Unlock 10/17 units from the Monster Pen for short/long victory
		local rakarth_unit_list = {
			"wh2_main_def_mon_black_dragon",
			"wh2_main_lzd_cav_cold_ones_feral_0",
			"wh2_twa03_def_mon_wolves_0",
			"wh2_main_lzd_mon_stegadon_0",
			"wh2_main_def_inf_harpies",
			"wh2_dlc14_def_mon_bloodwrack_medusa_0",
			"wh2_main_lzd_mon_carnosaur_0",
			"wh2_dlc10_def_mon_feral_manticore_0",
			"wh2_dlc10_def_mon_kharibdyss_0",
			"wh2_twa03_def_mon_war_mammoth_0",
			"wh2_main_def_mon_war_hydra",
			"wh_twa03_def_inf_squig_explosive_0",
			"wh3_main_monster_feral_bears",
			"wh3_main_monster_feral_ice_bears",
			"wh2_dlc16_wef_mon_giant_spiders_0",
			"wh3_main_ogr_mon_sabretusk_pack_0",
			"wh2_twa03_grn_mon_wyvern_0",
		}
		core:add_listener(
			"IEVictoryConditionDefRakarthRecruitFromMonsterPen",
			"UnitCreated",
			function(context)
				return context:unit():faction():name() == faction_key and table.contains(rakarth_unit_list, context:unit():unit_key())
			end,
			function(context)
				local current_unit_key = context:unit():unit_key()
				local recruited_monsters = cm:get_saved_value("VictoryConditionRakarthUnlockedMonsters") or {}
				if not table.contains(recruited_monsters, current_unit_key) then
					table.insert(recruited_monsters, current_unit_key)
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_def_rakarth_monster_pen_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_rakarth_monster_pen_long", 1)
					cm:set_saved_value("VictoryConditionRakarthUnlockedMonsters", recruited_monsters)
				end
			end,
			true
		)

		-- Rakarth: Construct Landmark The Chamber of Visions for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionDefRakarthBuildLandmarkLong",
			"wh_main_short_victory",
			"wh3_dlc29_def_rakarth_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_chamber_of_visions",
			{"wh2_main_special_chamber_of_visions"}
		)

		-- Rakarth: Get 20 Monster Pen units to rank 9 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionDefRakarthRankupUnitsLong",
			"wh_main_long_victory",
			"wh3_dlc29_def_rakarth_rankup_units_long",
			faction_key,
			rakarth_unit_list,
			9
		)

		-- Rakarth: Upgrade at least 3 Black Arcs to Grand Black Ark level or higher for long victory
		core:add_listener(
			"IEVictoryConditionDefRakarthBlackArksUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:building() == "wh2_main_horde_def_settlement_3"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_def_rakarth_black_arks_long", 1)
			end,
			true
		)

	end,

----- GREENSKINS -----

	-- Grimgor Ironhide
	["wh_main_grn_greenskins"] = function(faction_key)

		-- Grimgor Ironhide: Construct Landmark Big Fort for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnGrimgorBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_grimgor_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_karak_vrag",
			{"wh2_main_special_big_fort"}
		)

		-- Grimgor Ironhide: Construct Landmark The Great Temple of Hashut (Desecrated) for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnGrimgorBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_grn_grimgor_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_zharr_naggrund",
			{"wh3_dlc23_special_great_temple_of_hashut_other"}
		)

		-- Grimgor Ironhide: Kill 5 Legendary Lords for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionGrnGrimgorKillLegendaryLordsLong",
			"wh_main_long_victory",
			"wh3_dlc29_grn_grimgor_kill_legendary_lords_long",
			faction_key,
			true
		)

		-- Grimgor Ironhide: Win 2 WAAAGH trophies of any kind for short victory
		-- Grimgor Ironhide: Win 3 Da Biggest WAAAGH trophies for long victory
		-- Grimgor Ironhide: Confederate 3 Greenskins factions for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Azhag the Slaughterer
	["wh2_dlc15_grn_bonerattlaz"] = function(faction_key)

		-- Azhag the Slaughterer: Win 1 WAAAGH trophy against Kislev or Dwarfs for short victory
		-- Azhag the Slaughterer: Win 5 WAAAGH trophies of any kind for long victory
		-- Azhag the Slaughterer: Win 1 Da Biggest WAAAGH trophiy for long victory
		-- Azhag the Slaughterer: Confederate 3 Greenskins factions for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Skarsnik
	["wh_main_grn_crooked_moon"] = function(faction_key)

		-- Skarsnik: Construct Landmark Brightstone mine for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnSkarsnikBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_skarsnik_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_mount_gunbad",
			{"wh3_dlc26_special_brightstone_mine_grn"}
		)

		-- Skarsnik: Construct Landmark Defiled Ancestor Tombs for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnSkarsnikBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_grn_skarsnik_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_karak_eight_peaks",
			{"wh_dlc06_grn_eight_peaks_3"}
		)

		-- Skarsnik: Recruit 2 Goblin Big Boss?s and increase their rank to rank 10 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionGrnSkarsnikRankupAgentsShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_skarsnik_rankup_agents_short",
			faction_key,
			{"wh_main_grn_goblin_big_boss"},
			10,
			2
		)

		-- Skarsnik: Recruit 3 Night Goblin Warboss?s and increase their rank to rank 10 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionGrnSkarsnikRankupAgentsLong",
			"wh_main_long_victory",
			"wh3_dlc29_grn_skarsnik_rankup_agents_long",
			faction_key,
			{"wh_dlc06_grn_night_goblin_warboss"},
			10,
			3
		)

		-- Skarsnik: Win 4 WAAAGH trophies of any kind for long victory
		-- Skarsnik: Win 1 Da Biggest WAAAGH trophie for long victory
		-- Skarsnik: Confederate 3 Greenskins factions for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Wurrzag
	["wh_main_grn_orcs_of_the_bloody_hand"] = function(faction_key)

		-- Wurrzag: Construct Landmark Bone Nose Idols for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnWurrzagBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_wurrzag_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_cuexotl",
			{"wh3_dlc26_special_bone_nose_idols_1"}
		)

		-- Wurrzag: Construct Landmarks Bonewood Totems and Iron penz for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionGrnWurrzagBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_grn_wurrzag_construct_landmarks_long",
			faction_key,
			{
				wh3_main_combi_region_springs_of_eternal_life = "wh3_dlc26_special_bonewood_totems_1",
				wh3_main_combi_region_stormhenge = "wh3_dlc26_special_iron_penz_1",
			}
		)

		-- Wurrzag: Get 10 Savage Orc units and and increase their rank to rank 9 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionGrnWurrzagRankupUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_wurrzag_rankup_units_short",
			faction_key,
			{"wh3_dlc26_grn_cha_savage_orc_great_shaman",
			"wh3_dlc26_grn_cha_savage_orc_great_shaman_boar",
			"wh3_dlc26_grn_cha_savage_orc_great_shaman_wyvern",
			"wh_main_grn_cav_savage_orc_boar_boy_big_uns",
			"wh_main_grn_cav_savage_orc_boar_boyz",
			"wh_main_grn_inf_savage_orc_arrer_boyz",
			"wh_main_grn_inf_savage_orc_big_uns",
			"wh_main_grn_inf_savage_orcs",},
			9
		)

		-- Wurrzag: Win any of Wurrzag?s quest battles (Baleful Mask, Squiggly Beast, or Bonewood Staff) for short victory
		local wurrzag_mission_key = "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_"
		core:add_listener(
			"IEVictoryConditionWurrzagCompleteQuestBattle",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:mission():mission_record_key(), wurrzag_mission_key)
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_grn_wurrzag_win_any_quest_battle_short", true)
			end,
			true
		)

		-- Wurrzag: Confederate 4 Greenskins factions for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Grom the Paunch
	["wh2_dlc15_grn_broken_axe"] = function(faction_key)

		-- Grom the Paunch: Complete the Hag Merchants Cooking challenge twice to unlock all ingredient slots for short victory
		core:add_listener(
			"IEVictoryConditionGromUnlocksAllIngredientSlots",
			"GromUnlockedAllTheCauldronSlots",
			true,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_grn_grom_unlock_all_ingridient_slots_short", true)
			end,
			true
		)

		-- Grom the Paunch: Unlock 15 Ingredients for short victory
		core:add_listener(
			"IEVictoryConditionGromUnlocksIngredient",
			"IngredientUnlocked",
			true,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_grn_grom_unlock_ingridients_short", 1)
			end,
			true
		)

		-- Grom the Paunch: Cook all 15 recipes in Grom's cauldron at least once for long victory
		core:add_listener(
			"IEVictoryConditionGromCooksDish",
			"FactionCookedDish",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local grom_cooked_dishes = cm:get_saved_value("VictoryConditionGromCookedUniqueDishes") or {}
				local new_recipe = context:dish():recipe()
				if not table.contains(grom_cooked_dishes, new_recipe) then
					table.insert(grom_cooked_dishes, new_recipe)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_grn_grom_cook_unique_recipes_long", 1)
					cm:set_saved_value("VictoryConditionGromCookedUniqueDishes", grom_cooked_dishes)
				end
			end,
			true
		)

		-- Grom the Paunch: Win 1 WAAAGH trophy against a Bretonnia faction for short victory
		-- Grom the Paunch: Win 4 WAAAGH trophies of any kind for long victory
		-- Grom the Paunch: Win 1 WAAAGH trophy against High Elf, Bretonnia or Dwarf factions for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Gorbad Ironclaw
	["wh3_dlc26_grn_gorbad_ironclaw"] = function(faction_key)

		-- Gorbad Ironclaw: Construct Landmark Dork's Rock for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionGrnGorbadBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_grn_gorbad_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_black_crag",
			{"wh2_main_special_dorks_rock"}
		)

		-- Gorbad Ironclaw: Activate 10 unique Da Plans for short victory
		-- Gorbad Ironclaw: Activate 25 unique Da Plans for long victory
		-- Gorbad Ironclaw: Have 3 Master Taktics Equipped at the same time for long victory
		local da_plan_iniative_key_start = "wh3_dlc26_force_initiative_grn_da_plan_"
		core:add_listener(
			"IEVictoryConditionGorbadActivatesUniqueDaPlans",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:initiative():record_key():starts_with(da_plan_iniative_key_start) and context:initiative():is_active()
			end,
			function(context)
				local unique_da_plans_activated = cm:get_saved_value("VictoryConditionUniqueDaPlansActivated") or {}
				local da_plan_key = context:initiative():record_key()
				if not table.contains(unique_da_plans_activated, da_plan_key) then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_grn_gorbad_unlock_da_plans_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_grn_gorbad_unlock_da_plans_long", 1)
					table.insert(unique_da_plans_activated, da_plan_key)
					cm:set_saved_value("VictoryConditionUniqueDaPlansActivated", unique_da_plans_activated)
				end

				-- Gorbad Ironclaw: Have 3 Master Taktics Equipped at the same time for long victory
				if string.ends_with(da_plan_key, "_3") then
					local initiative_list = context:initiative_set():active_initiatives()
					local master_taktics_initiatives_active = 0
					for i = 0, initiative_list:num_items() - 1 do
						local iniatiative_record_key = initiative_list:item_at(i):record_key()
						if string.starts_with(iniatiative_record_key, da_plan_iniative_key_start) and string.ends_with(iniatiative_record_key, "_3") then
							master_taktics_initiatives_active = master_taktics_initiatives_active + 1
						end
					end

					if master_taktics_initiatives_active >= 3 then
						cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_grn_gorbad_equip_da_plans_long", true)
					end
				end

			end,
			true
		)

		-- Gorbad Ironclaw: Confederate 1 Greenskins faction for short victory
		-- Gorbad Ironclaw: Win 4 WAAAGH trophies of any kind for long victory
		-- Gorbad Ironclaw: Win 1 WAAAGH trophy against Empire for long victory
		_victory_objectives_ie.listeners.grn_shared_objective_listeners(faction_key)
	end,

	-- Shared
	["grn_shared_objective_listeners"] = function(faction_key)

		local wagh_victory_conditions = {
			-- Grimgor Ironhide: Win 2 WAAAGH trophies of any kind for short victory
			-- Grimgor Ironhide: Win 3 Da Biggest WAAAGH trophies for long victory
			["wh_main_grn_greenskins"] = {
				["wh3_dlc29_grn_grimgor_win_wagh_short"] = { victory_mission = "wh_main_short_victory", total = 2 },
				["wh3_dlc29_grn_grimgor_win_wagh_long"] =  { victory_mission = "wh_main_long_victory", total = 3, reward_level = 3},
			},
			-- Azhag the Slaughterer: Win 1 WAAAGH trophy against Kislev or Dwarfs for short victory
			-- Azhag the Slaughterer: Win 4 WAAAGH trophies of any kind for long victory
			-- Azhag the Slaughterer: Win 1 Da Biggest WAAAGH trophiy for long victory
			["wh2_dlc15_grn_bonerattlaz"] = {
				["wh3_dlc29_grn_azhag_win_wagh_short"] =  { victory_mission = "wh_main_short_victory", total = 1, target_culture = {"wh3_main_ksl_kislev", "wh_main_dwf_dwarfs"}},
				["wh3_dlc29_grn_azhag_win_wagh_1_long"] = { victory_mission = "wh_main_long_victory", total = 4},
				["wh3_dlc29_grn_azhag_win_wagh_2_long"] = { victory_mission = "wh_main_long_victory", total = 1, reward_level = 3},
			},
			-- Skarsnik: Win 4 WAAAGH trophies of any kind for long victory
			-- Skarsnik: Win 1 Da Biggest WAAAGH trophie for long victory
			["wh_main_grn_crooked_moon"] = {
				["wh3_dlc29_grn_skarsnik_win_wagh_1_long"] = { victory_mission = "wh_main_long_victory", total = 4},
				["wh3_dlc29_grn_skarsnik_win_wagh_2_long"] = { victory_mission = "wh_main_long_victory", total = 1, reward_level = 3},
			},
			-- Grom the Paunch: Win 1 WAAAGH trophy against a Bretonnia faction for short victory
			-- Grom the Paunch: Win 4 WAAAGH trophies of any kind for long victory
			-- Grom the Paunch: Win 1 WAAAGH trophy against High Elf, Bretonnia or Dwarf factions for long victory
			["wh2_dlc15_grn_broken_axe"] = {
				["wh3_dlc29_grn_grom_win_wagh_short"] =  { victory_mission = "wh_main_short_victory", total = 1, target_culture = {"wh_main_brt_bretonnia"}},
				["wh3_dlc29_grn_grom_win_wagh_1_long"] = { victory_mission = "wh_main_long_victory", total = 4},
				["wh3_dlc29_grn_grom_win_wagh_2_long"] = { victory_mission = "wh_main_long_victory", total = 1, target_culture = {"wh2_main_hef_high_elves", "wh_main_brt_bretonnia", "wh_main_dwf_dwarfs"}},
			},
			-- Gorbad Ironclaw: Win 4 WAAAGH trophies of any kind for long victory
			-- Gorbad Ironclaw: Win 1 WAAAGH trophy against Empire for long victory
			["wh3_dlc26_grn_gorbad_ironclaw"] = {
				["wh3_dlc29_grn_gorbad_win_wagh_1_long"] = { victory_mission = "wh_main_long_victory", total = 4},
				["wh3_dlc29_grn_gorbad_win_wagh_2_long"] = { victory_mission = "wh_main_long_victory", total = 1, target_culture = {"wh_main_emp_empire"}},
			},
		}

		if wagh_victory_conditions[faction_key] then
			core:add_listener(
				"IEVictoryConditionWinWagh" .. faction_key,
				"PlayerWaghEndedSuccessful",
				function(context)
					return context:faction():name() == faction_key
				end,
				function(context)
					for script_key, wagh_data in dpairs(wagh_victory_conditions[faction_key]) do
						local wagh_level_condition_met = false
						local wagh_culture_condition_met = false

						if wagh_data.target_culture then
							if table.contains(wagh_data.target_culture, waaagh.factions[faction_key].target_culture) then
								wagh_culture_condition_met = true
							end
						else
							wagh_culture_condition_met = true
						end

						if wagh_data.reward_level then
							if waaagh.factions[faction_key].reward_level == wagh_data.reward_level then
								wagh_level_condition_met = true
							end
						else
							wagh_level_condition_met = true
						end

						if wagh_culture_condition_met and wagh_level_condition_met then
							if wagh_data.total == 1 then
								cm:complete_scripted_mission_objective(faction_key, wagh_data.victory_mission, script_key, true)
							else
								cm:increase_scripted_mission_count(wagh_data.victory_mission, script_key, 1)
							end
						end
					end
				end,
				true
			)
		end

		-- Grimgor Ironhide: Confederate 3 Greenskins factions for long victory
		-- Azhag the Slaughterer: Confederate 3 Greenskins factions for long victory
		-- Skarsnik: Confederate 3 Greenskins factions for long victory
		-- Wurrzag: Confederate 4 Greenskins factions for long victory
		-- Gorbad: Confederate 1 Greenskins faction for short victory
		local confederate_victory_conditions = {
			["wh_main_grn_greenskins"] = 				{ victory_mission = "wh_main_long_victory", script_key = "wh3_dlc29_grn_grimgor_confederate_greenskins_long", total = 3},
			["wh2_dlc15_grn_bonerattlaz"] = 			{ victory_mission = "wh_main_long_victory", script_key = "wh3_dlc29_grn_azhag_confederate_greenskins_long", total = 3},
			["wh_main_grn_crooked_moon"] = 				{ victory_mission = "wh_main_long_victory", script_key = "wh3_dlc29_grn_skarsnik_confederate_greenskins_long", total = 3},
			["wh_main_grn_orcs_of_the_bloody_hand"] = 	{ victory_mission = "wh_main_long_victory", script_key = "wh3_dlc29_grn_wurrzag_confederate_greenskins_long", total = 4},
			["wh3_dlc26_grn_gorbad_ironclaw"] = 		{ victory_mission = "wh_main_short_victory", script_key = "wh3_dlc29_grn_gorbad_confederate_greenskins_short", total = 1},
		}

		if confederate_victory_conditions[faction_key] then
			victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_FACTIONS_OF_CULTURE(
				"IEVictoryConditionGrnConfederateFactionLong" .. faction_key,
				confederate_victory_conditions[faction_key].victory_mission,
				confederate_victory_conditions[faction_key].script_key,
				faction_key,
				confederate_victory_conditions[faction_key].total,
				"wh_main_grn_greenskins"
			)
		end

	end,

----- OGRE KINGDOMS -----

	-- Greasus Goldtooth
	["wh3_main_ogr_goldtooth"] = function(faction_key)

		-- Greasus Goldtooth: Construct 1/3 Great Maw Sites in camps for short/long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrGreasusConstructCampShort",
			"wh_main_short_victory",
			"wh3_dlc29_ogr_greasus_construct_camp_short",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrGreasusConstructCampLong",
			"wh_main_long_victory",
			"wh3_dlc29_ogr_greasus_construct_camp_long",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)

		-- Greasus Goldtooth: Construct Landmarks Goldtooth?s Toll Gate and Bells of Lazarghs for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionOgrgreasusBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_ogr_greasus_construct_landmarks_short",
			faction_key,
			{
				wh3_main_combi_region_great_hall_of_greasus = "wh3_main_special_goldtooths_toll_gate",
				wh3_main_combi_region_the_maw_gate = "wh3_dlc24_special_bells_of_the_lazarghs",
			}
		)

		-- Greasus Goldtooth: Confederate 2 Ogre Factions for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_FACTIONS_OF_CULTURE(
			"IEVictoryConditionOgrGreasusConfederateFactionsShort",
			"wh_main_short_victory",
			"wh3_dlc29_ogr_greasus_confederate_ogres_short",
			faction_key,
			2,
			"wh3_main_ogr_ogre_kingdoms"
		)

		-- Greasus Goldtooth: Use Tyrant?s Demand 12 Times for short victory
		-- Greasus Goldtooth: Use Tyrant?s Demand 24 Times for long victory
		core:add_listener(
			"IEVictoryConditionGreasusUseTyrantDemands",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_key():starts_with("wh3_dlc26_ogr_tyrants_demands_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ogr_greasus_use_tyrant_demands_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ogr_greasus_use_tyrant_demands_long", 1)
			end,
			true
		)

		-- Greasus Goldtooth: Complete 10 Bounties for long victory
		core:add_listener(
			"IEVictoryConditionOgrGreasusCompleteBounties",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key():find("wh3_main_mission_ogre_contract")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ogr_greasus_complete_bounties_long", 1)
			end,
			true
		)

	end,

	-- Skrag the Slaughterer
	["wh3_main_ogr_disciples_of_the_maw"] = function(faction_key)

		-- Skrag the Slaughterer: Construct 1/3 Great Maw Sites in camps for short/long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrSkragConstructCampShort",
			"wh_main_short_victory",
			"wh3_dlc29_ogr_skrag_construct_camp_short",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrSkragConstructCampLong",
			"wh_main_long_victory",
			"wh3_dlc29_ogr_skrag_construct_camp_long",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)

		-- Skrag the Slaughterer: Have 2 Slaughtermaster Lords and increase their rank to rank 20 for long victory
		local skrag_agent_subtype_key_list = {
			"wh3_dlc26_ogr_cha_slaughtermaster_death",
			"wh3_dlc26_ogr_cha_slaughtermaster_heavens",
			"wh3_main_ogr_slaughtermaster_beasts",
			"wh3_main_ogr_slaughtermaster_great_maw",
		}
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionOgrSkragRankupAgentsLong",
			"wh_main_long_victory",
			"wh3_dlc29_ogr_skrag_rankup_agents_long",
			faction_key,
			skrag_agent_subtype_key_list,
			20,
			2,
			true,
			"mission_text_text_wh3_dlc29_ogr_skrag_rankup_agents_long"
		)

		-- Skrag the Slaughterer: Maintain Feeder status on the Path of the Butcher for at least 5 turns for short victory
		-- Skrag the Slaughterer: Maintain Prophet of the Maw status on Path of the Butcher for at least 5 turns for long victory
		local required_amount_short_vc = 4
		local required_amount_long_vc = 10
		core:add_listener(
			"IEVictoryConditionOgrSkragMaintainButcherStatus",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local path_of_the_butcher_pooled_resource = context:faction():pooled_resource_manager():resource("ogr_path_of_the_butcher")
				if not is_nil(path_of_the_butcher_pooled_resource) and not path_of_the_butcher_pooled_resource:is_null_interface() then
					if path_of_the_butcher_pooled_resource:value() >= required_amount_short_vc then
						cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_short", 1)
					end
					if path_of_the_butcher_pooled_resource:value() >= required_amount_long_vc then
						cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ogr_skrag_maintain_path_of_the_butcher_long", 1)
					end
				end
			end,
			true
		)

	end,

	-- Golgfag Maneater
	["wh3_dlc26_ogr_golgfag"] = function(faction_key)

		-- Golgfag Maneater: Construct 1/3 Great Maw Sites in camps for short/long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrGolgfagConstructCampShort",
			"wh_main_short_victory",
			"wh3_dlc29_ogr_golgfag_construct_camp_short",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING(
			"IEVictoryConditionOgrGolgfagConstructCampLong",
			"wh_main_long_victory",
			"wh3_dlc29_ogr_golgfag_construct_camp_long",
			faction_key,
			"wh3_main_ogr_camp_town_centre_5"
		)

		-- Golgfag Maneater: Recruit 20 Maneater units and increase their rank to rank 6 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionOgrGolgfagRankupUnitsLong",
			"wh_main_long_victory",
			"wh3_dlc29_ogr_golgfag_rankup_units_long",
			faction_key,
			{"wh3_dlc26_ogr_inf_golgfags_maneaters",
			"wh3_main_ogr_inf_maneaters_0",
			"wh3_main_ogr_inf_maneaters_1",
			"wh3_main_ogr_inf_maneaters_2",
			"wh3_main_ogr_inf_maneaters_3"},
			6
		)

		-- Golgfag Maneater: Complete 7 Mercenary Contracts for short victory
		-- Golgfag Maneater: Complete 20 Mercenary Contracts for long victory
		core:add_listener(
			"IEVictoryConditionOgrGolgfagCompleteWarContracts",
			"WarContractSuccessEvent",
			function(context)
				return context:hired_faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ogr_golgfag_complete_war_contracts_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_ogr_golgfag_complete_war_contracts_long", 1)
			end,
			true
		)

		-- Golgfag Maneater: Gain 2000 Treasury from surplus client satisfaction from contracts for short victory
		core:add_listener(
			"IEVictoryConditionOgrGolgfagGainSurplusRewardFromWarContract",
			"ScriptEventSurplusTreasuryFromWarContractAwarded",
			function(context)
				return context.string == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ogr_golgfag_gain_surplus_money_from_war_contracts_short", context.number)
			end,
			true
		)

		-- Golgfag Maneater: Complete 3 Bounties for short victory
		core:add_listener(
			"IEVictoryConditionOgrGolgfagCompleteBounties",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and context:mission():mission_record_key():find("wh3_main_mission_ogre_contract")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_ogr_golgfag_complete_bounties_short", 1)
			end,
			true
		)
	end,

----- TOMB KINGS -----

	-- Settra the Imperishable
	["wh2_dlc09_tmb_khemri"] = function(faction_key)

		-- Settra the Imperishable: Construct Landmarks: Great Pyramid of Settra, Pyramid of Prince Tutankhanut, Pyramid of King Phar, Vault of Nagash for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionTmbSettraBuildLandmarks_Short",
			"wh_main_short_victory",
			"wh3_dlc29_tmb_settra_construct_landmarks_short",
			faction_key,
			{
				wh3_main_combi_region_khemri = "wh2_dlc09_special_pyramid_settra",
				wh3_main_combi_region_numas = "wh2_dlc09_special_pyramid_tutankhanut",
				wh3_main_combi_region_quatar = "wh2_dlc09_special_pyramid_phar",
				wh3_main_combi_region_black_pyramid_of_nagash = "wh2_main_special_pyramid_of_nagash_other",
			}
		)

		-- Settra the Imperishable: Construct Landmarks: Pyramid of King Khatep, Pyramid of King Alcadizaar, Pyramid of King Amenemhetum for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionTmbSettraBuildLandmarks_Long",
			"wh_main_long_victory",
			"wh3_dlc29_tmb_settra_construct_landmarks_long",
			faction_key,
			{
				wh3_main_combi_region_ka_sabar = "wh2_dlc09_special_pyramid_khatep",
				wh3_main_combi_region_bhagar = "wh2_dlc09_special_pyramid_alcadizaar",
				wh3_main_combi_region_zandri = "wh2_dlc09_special_pyramid_amenemhetum",
			}
		)

		-- Settra the Imperishable: Maintain Control of at least 3 Books of Nagash for short victory
		-- Settra the Imperishable: Maintain Control of at least 6 Books of Nagash for long victory
		local books_of_nagash_to_collect_short = 3
		local books_of_nagash_to_collect_long = 6

		local function update_books_of_nagash_objective(context)
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_tmb_settra_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_tmb_settra_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_long)
			if (context.number >= books_of_nagash_to_collect_short) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_tmb_settra_get_books_of_nagash_short", true)
			end
			if (context.number >= books_of_nagash_to_collect_long) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_tmb_settra_get_books_of_nagash_long", true)
			end
		end

		core:add_listener(
			"IEVictoryConditionTmbSettraUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				update_books_of_nagash_objective(context)
			end,
			true
		)

		-- Settra the Imperishable: Unlock the Royal Standard of Settra banner via the Mortuary Cult for long victory
		core:add_listener(
			"IEVictoryConditionTmbSettraUnlockRoyalStandardLong",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_key() == "wh3_main_ritual_crafting_tmb_settra_banner"
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_tmb_settra_unlock_royal_standard_long", true)
			end,
			true
		)

	end,

	-- Grand Hierophant Khatep
	["wh2_dlc09_tmb_exiles_of_nehek"] = function(faction_key)

		-- Grand Hierophant Khatep: Recruit a Liche Priest from all 4 Lores of Magic and get them to rank 20: Death, Light, Nehekhara, Shadows for long victory
		local liche_priest_list = {
			"wh2_dlc09_tmb_liche_priest_death",
			"wh2_dlc09_tmb_liche_priest_light",
			"wh2_dlc09_tmb_liche_priest_nehekhara",
			"wh2_dlc09_tmb_liche_priest_shadow",
		}
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionTmbKhatepRankupAgentsLong",
			"wh_main_long_victory",
			"wh3_dlc29_tmb_khatep_rankup_agents_long",
			faction_key,
			liche_priest_list,
			20,
			4,
			nil,
			nil,
			true
		)

	end,

	-- High Queen Khalida
	["wh2_dlc09_tmb_lybaras"] = function(faction_key)

		-- High Queen Khalida: Build Landmark: Hall of Rebirth for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionTmbKhalidaBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_tmb_khalida_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_lahmia",
			{"wh3_dlc24_special_hall_of_of_rebirth"}
		)

	-- High Queen Khalida: Build Landmark: House of Everlasting Life for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionTmbKhalidaBuildLandmark_Long",
			"wh_main_long_victory",
			"wh3_dlc29_tmb_khalida_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_lahmia",
			{"wh3_main_tmb_house_everlasting_life"}
		)

		-- High Queen Khalida: Maintain Control of at least 3 Books of Nagash for short victory
		-- High Queen Khalida: Maintain Control of at least 6 Books of Nagash for long victory
		local books_of_nagash_to_collect_short = 3
		local books_of_nagash_to_collect_long = 6

		local function update_books_of_nagash_objective(context)
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_tmb_khalida_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_tmb_khalida_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_long)
			if (context.number >= books_of_nagash_to_collect_short) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_tmb_khalida_get_books_of_nagash_short", true)
			end
			if (context.number >= books_of_nagash_to_collect_long) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_tmb_khalida_get_books_of_nagash_long", true)
			end
		end

		core:add_listener(
			"IEVictoryConditionTmbKhalidaUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				update_books_of_nagash_objective(context)
			end,
			true
		)

	end,

	-- Arkhan the Black
	["wh2_dlc09_tmb_followers_of_nagash"] = function(faction_key)

		-- Arkhan the Black: Build Landmark: Black Tower of Arkhan for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionTmbArkhanBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_tmb_arkhan_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_black_tower_of_arkhan",
			{"wh2_dlc09_special_black_tower_of_arkhan"}
		)

		-- Arkhan the Black: You or Nagash Maintain Control of 3 Books of Nagash for short victory
		-- Arkhan the Black: You or Nagash Maintain Control of 9 Books of Nagash for long victory
		local books_of_nagash_to_collect_short = 4
		local books_of_nagash_to_collect_long = 9
		local host_of_nagash_faction_key = "wh3_dlc29_nag_host_of_nagash"

		local function update_books_of_nagash_objective(context)

			-- books_of_nagash_count_ saved value might not be set if faction did not gain or lost books yet. Set default values as 1 in this case.
			local arkhan_books_of_nagash_count = cm:get_saved_value("books_of_nagash_count_" .. faction_key) or 1
			local nagash_books_of_nagash_count = cm:get_saved_value("books_of_nagash_count_" .. host_of_nagash_faction_key) or 0

			local total_books_controlled = arkhan_books_of_nagash_count + nagash_books_of_nagash_count
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_tmb_arkhan_get_books_of_nagash_short", "mission_text_text_wh3_dlc29_arkhan_nagash_collect_n_books", total_books_controlled, books_of_nagash_to_collect_short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_tmb_arkhan_get_books_of_nagash_long", "mission_text_text_wh3_dlc29_arkhan_nagash_collect_n_books", total_books_controlled, books_of_nagash_to_collect_long)
			if (total_books_controlled >= books_of_nagash_to_collect_short) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_tmb_arkhan_get_books_of_nagash_short", true)
			end
			if (total_books_controlled >= books_of_nagash_to_collect_long) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_tmb_arkhan_get_books_of_nagash_long", true)
			end
		end

		core:add_listener(
			"IEVictoryConditionTmbArkhanUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				local book_recipient_faction_key = context:faction():name()
				return book_recipient_faction_key == faction_key or book_recipient_faction_key == host_of_nagash_faction_key
			end,
			function(context)
				update_books_of_nagash_objective(context)
			end,
			true
		)
	end,

----- VAMPIRE COAST -----

	-- Luthor Harkon
	["wh2_dlc11_cst_vampire_coast"] = function(faction_key)

		-- Set indices (starting from 0) of objectives which need to be put in a "sub-list" in order they are declared in _victory_objectives_ie_config
		cm:set_script_state(cm:get_faction(faction_key), "short_victory_mission_sub_objectives_index_list", "1;2")

		-- Luthor Harkon: PARENT-Objective - Restore Harkon?s mind
		core:add_listener(
			"IEVictoryConditionCstLuthorRestoreMind_Short",
			"ScriptEventHarkonRestored",
			true,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cst_luthor_restore_mind_dummy_parent_objective_short", true)
			end,
			false
		)

		-- Luthor Harkon: SUB-Objective - Build Landmark Ancient Vault for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCstLuthorBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_cst_luthor_construct_landmark_sub_objective_short",
			faction_key,
			"wh3_main_combi_region_the_awakening",
			{"wh2_dlc11_special_ancient_vault_2"}
		)

		-- Luthor Harkon: SUB-Objective - Complete the Quest Slann Gold for short victory
		core:add_listener(
			"IEVictoryConditionCstLuthorCompleteMainQuest",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh3_main_ie_qb_cst_harkon_quest_for_slann_gold"
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cst_luthor_complete_quest_sub_objective_short", true)
				
				-- This mission also rewards one piece of eight for another objective
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_luthor_gain_pieces_of_eight_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_luthor_gain_pieces_of_eight_long", 1)
			end,
			false
		)

		-- Luthor Harkon: Upgrade a Ship to a Captains Cabin for short victory
		-- Luthor Harkon: Upgrade a Ship to a Great Cabin, with The Black Coffin special deck building for long victory
		local captains_cabin_level_key = "wh2_dlc11_vampirecoast_ship_captains_cabin_3"
		local black_coffin_special_deck_level_key = "wh2_dlc11_special_ship_harkon_1"
		core:add_listener(
			"IEVictoryConditionCstLuthorShipUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local building_name = context:building()
				if building_name == captains_cabin_level_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cst_luthor_upgrade_ship_short", true)
				end

				if building_name == black_coffin_special_deck_level_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_cst_luthor_upgrade_ship_long", true)
				end

			end,
			true
		)

		-- Luthor Harkon: Gain 2 Pieces of Eight for short victory
		-- Luthor Harkon: Gain 5 Pieces of Eight for long victory
		core:add_listener(
			"IEVictoryConditionCstLuthorUnlockPiecesOfEight",
			"MissionSucceeded",
			function(context)
				return string.starts_with(context:mission():mission_record_key(), "wh2_dlc11_mission_piece_of_eight_")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_luthor_gain_pieces_of_eight_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_luthor_gain_pieces_of_eight_long", 1)
			end,
			true
		)

		-- Luthor Harkon: Establish 3 Pirate Coves in Lustria for short victory
		core:add_listener(
			"IEVictoryConditionCstLuthorCreatePirateCoves",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key and context:new_slot_manager():region():is_contained_in_region_group("cai_region_hint_area_lustria")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_luthor_establish_pirate_coves_short", 1)
			end,
			true
		)

		-- Luthor Harkon: Unlock all 3 Sea Shanties for long victory
		core:add_listener(
			"IEVictoryConditionCstLuthorGainsSeaShanty",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:mission():mission_record_key(), "wh2_dlc11_mission_sea_shanty_")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_luthor_unlock_sea_shanties_long", 1)
			end,
			true
		)

		-- Luthor Harkon: Fill all Fleet Offices positions with Lords of rank 10 and above for long victory
		local total_ministerial_positions = 8
		local required_minister_rank = 10
		local ministerial_position_key = "wh2_dlc11_minister_cst_fleet_"
		
		local function update_cst_offices_objective(context)
			local new_ranked_ministers = 0
			local character_list = context:character():faction():character_list()
			for i = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(i)
				if character:ministerial_position():starts_with(ministerial_position_key) then
					if character:rank() >= required_minister_rank then
						new_ranked_ministers = new_ranked_ministers + 1
					end
				end
			end
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_cst_luthor_fill_offices_long", "mission_text_text_wh3_dlc29_cst_luthor_fill_offices_long", new_ranked_ministers, total_ministerial_positions)
			if new_ranked_ministers >= total_ministerial_positions then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory",  "wh3_dlc29_cst_luthor_fill_offices_long", true)
				core:remove_listener("IEVictoryConditionCstMinisterialPositionAssign" .. faction_key)
				core:remove_listener("IEVictoryConditionCstMinisterialPositionRankUp" .. faction_key)
				core:remove_listener("IEVictoryConditionCstMinisterialPositionRemovedPost" .. faction_key)
			end
		end

		-- Check when assigning new character in office
		core:add_listener(
			"IEVictoryConditionCstMinisterialPositionAssign" .. faction_key,
			"CharacterAssignedToPost",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				update_cst_offices_objective(context)
			end,
			true
		)

		-- Check when character in office ranks up
		core:add_listener(
			"IEVictoryConditionCstMinisterialPositionRankUp" .. faction_key,
			"CharacterRankUp",
			function(context)
				return context:character():faction():name() == faction_key and context:character():ministerial_position():starts_with(ministerial_position_key)
			end,
			function(context)
				update_cst_offices_objective(context)
			end,
			true
		)

		-- Check when removing character from office
		core:add_listener(
			"IEVictoryConditionCstMinisterialPositionRemovedPost" .. faction_key,
			"CharacterRemovedFromPost",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				update_cst_offices_objective(context)
			end,
			true
		)

	end,

	-- Count Noctilus
	["wh2_dlc11_cst_noctilus"] = function(faction_key)

		-- Count Noctilus: Build Landmark Wreck of the Heldenhammer for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCstNoctilusBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_cst_noctilus_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_the_galleons_graveyard",
			{"wh2_dlc11_special_galleons_graveyard_wreck_1"}
		)

		-- Count Noctilus: Have 2 Ships upgraded to a Captains Cabin level for short victory
		-- Count Noctilus: Upgrade a Ship to a Great Cabin, with the Sylvania Battlements special deck building for long victory
		-- Count Noctilus: Have 5 Ships at Captains Cabin level and above for long victory
		local captains_cabin_level_key = "wh2_dlc11_vampirecoast_ship_captains_cabin_3"
		local special_deck_level_key = "wh2_dlc11_special_ship_noctilus_1"
		core:add_listener(
			"IEVictoryConditionCstNoctilusShipUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local building_name = context:building()
				if building_name == captains_cabin_level_key then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_noctilus_upgrade_ship_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_noctilus_upgrade_ship_long", 1)
				end

				if building_name == special_deck_level_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_cst_noctilus_upgrade_ship_special_long", true)
				end
			end,
			true
		)

		-- Count Noctilus: Establish 3 Pirate Coves in High Elf Settlements for short victory
		core:add_listener(
			"IEVictoryConditionCstLuthorCreatePirateCoves",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key and context:slot_owner():culture() == "wh2_main_hef_high_elves"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_noctilus_establish_pirate_coves_short", 1)
			end,
			true
		)

		-- Count Noctilus: Recruit 3 Necrofex Collosus units and increase their rank to rank 6 for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionCstNoctilusRankupUnitsLong",
			"wh_main_long_victory",
			"wh3_dlc29_cst_noctilus_rankup_units_long",
			faction_key,
			{"wh2_dlc11_cst_mon_necrofex_colossus_0"},
			6
		)

	end,

	-- Aranessa Saltspite
	["wh2_dlc11_cst_pirates_of_sartosa"] = function(faction_key)

		-- Aranessa Saltspite: Build Landmarks: Peg Street Pawn Shop, Smithy?s Tavern, Dragon Tooth Lighthouse for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCstAranessaBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_cst_aranessa_construct_landmark_short",
			faction_key,
			"wh3_main_combi_region_sartosa",
			{"wh2_main_special_peg_street_pawnshop", "wh2_main_special_smithys_tavern"}
		)

		-- Aranessa Saltspite: Gain 2 Pieces of Eight for short victory
		-- Aranessa Saltspite: Gain 5 Pieces of Eight for long victory
		core:add_listener(
			"IEVictoryConditionCstAranessaCompleteMainQuest",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh3_main_ie_qb_cst_aranessa_krakens_bane"
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_aranessa_gain_pieces_of_eight_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_aranessa_gain_pieces_of_eight_long", 1)
			end,
			false
		)

		core:add_listener(
			"IEVictoryConditionCstAranessaUnlockPiecesOfEight",
			"MissionSucceeded",
			function(context)
				return string.starts_with(context:mission():mission_record_key(), "wh2_dlc11_mission_piece_of_eight_")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_aranessa_gain_pieces_of_eight_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_aranessa_gain_pieces_of_eight_long", 1)
			end,
			true
		)
		
		-- Aranessa Saltspite: Build Landmarks: Dragon Tooth Lighthouse for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCstAranessaBuildLandmark_Long",
			"wh_main_long_victory",
			"wh3_dlc29_cst_aranessa_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_sartosa",
			{"wh2_dlc11_special_dragon_tooth_lighthouse_1"}
		)
		
		-- Aranessa Saltspite: Upgrade a Ship to a Captains Cabin for short victory
		-- Aranessa Saltspite: Upgrade a Ship to a Great Cabin, with The Saw Shark?s Blade special deck building for long victory
		local captains_cabin_level_key = "wh2_dlc11_vampirecoast_ship_captains_cabin_3"
		local special_deck_level_key = "wh2_dlc11_special_ship_aranessa_1"
		core:add_listener(
			"IEVictoryConditionCstAranessaShipUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				local building_name = context:building()
				if building_name == captains_cabin_level_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cst_aranessa_upgrade_ship_short", true)
				end

				if building_name == special_deck_level_key then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_cst_aranessa_upgrade_ship_long", true)
				end
			end,
			true
		)

		-- Aranessa Saltspite: Complete 5 Treasure Hunts for short victory
		core:add_listener(
			"IEVictoryConditionCstAranessaFindsTreasure",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:mission():mission_record_key(), "wh2_dlc11_cst_treasure_map_")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_aranessa_complete_treasure_hunts_short", 1)
			end,
			true
		)

		-- Aranessa Saltspite: Gain 50000 treasury from Sacking Settlements for long victory
		core:add_listener(
			"IEVictoryConditionCstAranessaSacksSettlement",
			"CharacterSackedSettlement",
			function(context)
				return context:character():faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_aranessa_gain_money_sacking_long", context:loot())
			end,
			true
		)

	end,

	-- Cylostra Direfin
	["wh2_dlc11_cst_the_drowned"] = function(faction_key)

		-- Cylostra Direfin: Build the landmark: Cylostra?s Opera House for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCstCylostraBuildLandmark_Long",
			"wh_main_long_victory",
			"wh3_dlc29_cst_cylostra_construct_landmark_long",
			faction_key,
			"wh3_main_combi_region_lothern",
			{"wh2_dlc11_special_cylostra_opera_house_1"}
		)

		-- Cylostra Direfin: Upgrade a Ship to a Great Cabin, with Cylostra?s Balcony special deck building for long victory
		local special_deck_level_key = "wh2_dlc11_special_ship_cylostra_1"
		core:add_listener(
			"IEVictoryConditionCstCylostraShipUpgrade",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:building() == special_deck_level_key
			end,
			function(context)
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_cst_cylostra_upgrade_ship_long", true)
			end,
			false
		)

		-- Cylostra Direfin: Gain the first Sea Shanty Verse for short victory
		-- Cylostra Direfin: Gain all 3 Sea Shanty Verses for long victory
		core:add_listener(
			"IEVictoryConditionCstCylostraGainsSeaShanty",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:mission():mission_record_key(), "wh2_dlc11_mission_sea_shanty_")
			end,
			function()
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cst_cylostra_unlock_sea_shanties_short", true)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cst_cylostra_unlock_sea_shanties_long", 1)
			end,
			true
		)

		-- Cylostra Direfin: Establish 5 Pirate Coves for short victory
		core:add_listener(
			"IEVictoryConditionCstCylostraCreatePirateCoves",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cst_cylostra_establish_pirate_coves_short", 1)
			end,
			true
		)

		-- Cylostra Direfin: Recruit 5 Syreen units and increase their rank to rank 6 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionCstCylostraRankupUnitsLong",
			"wh_main_short_victory",
			"wh3_dlc29_cst_cylostra_rankup_units_short",
			faction_key,
			{"wh2_dlc11_cst_inf_syreens"},
			6
		)

	end,

----- VAMPIRE COUNTS -----

	-- Neferata
	["wh3_dlc29_vmp_neferata"] = function(faction_key)

		-- Neferata: Upgrade the Silver Pinnacle to tier 5 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpNeferataBuildTier5Capital_Short",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_neferata_build_max_tier_silver_pinnacles_short",
			faction_key,
			"wh3_main_combi_region_silver_pinnacle",
			{"wh3_main_special_settlement_silver_pinnacle_5"}
		)

		-- Neferata: Perform 6/12 Manipulations actions for short/long victory
		local web_of_power_action_prefix = "wh3_dlc29_neferata_actions"

		core:add_listener(
			"IEVictoryConditionVmpNeferataPerformWebOfPowerRituals",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), web_of_power_action_prefix)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_neferata_perform_manipulation_rituals_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_neferata_perform_manipulation_rituals_long", 1)
			end,
			true
		)

		-- Neferata: Empower the Lahmian Bloodline 3/6 times for short/long victory
		local lahmian_bloodline_ritual_prefix = "wh2_dlc11_ritual_bloodlines_lahmian"
		core:add_listener(
			"IEVictoryConditionVmpNeferataPerformBloodlineEmpowerRituals",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), lahmian_bloodline_ritual_prefix)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_neferata_perform_lahmian_empower_rituals_long", 1)
			end,
			true
		)

		-- Neferata: Build 6 Vampire Covens for short victory
		-- Neferata: Maintain control of OR have a Coven in the following regions for Long Victory
		local required_region_list = {
			"wh3_main_combi_region_silver_pinnacle",
			"wh3_main_combi_region_castle_drakenhof",
			"wh3_main_combi_region_altdorf",
			"wh3_main_combi_region_nuln",
			"wh3_main_combi_region_kislev",
			"wh3_main_combi_region_marienburg",
			"wh3_main_combi_region_khemri",
			"wh3_main_combi_region_lahmia",
			"wh3_main_combi_region_miragliano",
			"wh3_main_combi_region_wei_jin",
			"wh3_main_combi_region_shang_yang"
		}

		-- Neferata controls Silver Pinnacle at the campaign start
		if cm:is_new_game() then 
			cm:set_saved_value("long_victory_neferata_occupied_regions", {"wh3_main_combi_region_silver_pinnacle"})
		end

		-- Update UI state after load
		local neferata_occupied_regions = cm:get_saved_value("long_victory_neferata_occupied_regions") or {}
		update_mission_entity_completion_states(required_region_list, neferata_occupied_regions, "region_key", "wh_main_long_victory", "wh3_dlc29_vmp_neferata_build_covens_or_own_settlement_long")

		local function update_neferata_regions_objective(region_key, is_gained)
			local neferata_occupied_regions = cm:get_saved_value("long_victory_neferata_occupied_regions") or {}

			if table.contains(required_region_list, region_key) then
				if is_gained then
					if not table.contains(neferata_occupied_regions, region_key) then
						table.insert(neferata_occupied_regions, region_key)
					end
				else
					local _ , idx_to_remove = table.find(neferata_occupied_regions, region_key)
					if idx_to_remove then
						table.remove(neferata_occupied_regions, idx_to_remove)
					else
						return
					end
				end
				cm:set_saved_value("long_victory_neferata_occupied_regions", neferata_occupied_regions)
				update_mission_entity_completion_states(required_region_list, neferata_occupied_regions, "region_key", "wh_main_long_victory", "wh3_dlc29_vmp_neferata_build_covens_or_own_settlement_long")

				if table.size(neferata_occupied_regions) >= table.size(required_region_list) then
					cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_vmp_neferata_build_covens_or_own_settlement_long", true)
					core:remove_listener("IEVictoryConditionVmpNeferataCreateVampireCoves")
					core:remove_listener("IEVictoryConditionVmpNeferataLoseVampireCoves")
					core:remove_listener("IEVictoryConditionVmpNeferataOccupySettlements")
				end
			end
		end

		core:add_listener(
			"IEVictoryConditionVmpNeferataCreateVampireCoves",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key and context:new_slot_manager():slot_set_key() == "wh3_dlc29_slot_set_vampire_coven"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_neferata_build_covens_short", 1)
				update_neferata_regions_objective(context:region():name(), true)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionVmpNeferataLoseVampireCoves",
			"ForeignSlotManagerRemovedEvent",
			function(context)
				return context:owner():name() == faction_key
			end,
			function(context)
				update_neferata_regions_objective(context:region():name(), false)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionVmpNeferataOccupySettlements",
			"RegionFactionChangeEvent",
			function(context)
				return table.contains(required_region_list, context:region():name())
			end,
			function(context)
				local region = context:region()
				if region:owning_faction():name() == faction_key then
					update_neferata_regions_objective(context:region():name(), true)
				elseif context:previous_faction():name() == faction_key then
					update_neferata_regions_objective(context:region():name(), false)
				end
			end,
			true
		)

	end,

	-- Mannfred von Carstein
	["wh_main_vmp_vampire_counts"] = function(faction_key)

		-- Mannfred von Carstein: Build Landmark: Vault of Nagash for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpMannfredBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_mannfred_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_black_pyramid_of_nagash",
			{"wh2_main_special_pyramid_of_nagash_vmp"}
		)

		-- Mannfred von Carstein: Build Landmark: Malevolent Museum in Castle Drakenhof for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpMannfredBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_vmp_mannfred_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_castle_drakenhof",
			{"wh3_main_special_drakenhof_malevolent_museum"}
		)

		-- Mannfred von Carstein: Collect 4/9 Books of Nagash for short/long victory
		local books_of_nagash_to_collect_short = 4
		local books_of_nagash_to_collect_long = 9

		local function update_books_of_nagash_objective(context)
			cm:set_scripted_mission_text("wh_main_short_victory", "wh3_dlc29_vmp_mannfred_collect_books_of_nagash_short", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_short)
			cm:set_scripted_mission_text("wh_main_long_victory", "wh3_dlc29_vmp_mannfred_collect_books_of_nagash_long", "mission_text_text_wh3_dlc29_nagash_collect_n_books", context.number, books_of_nagash_to_collect_long)
			if (context.number >= books_of_nagash_to_collect_short) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_vmp_mannfred_collect_books_of_nagash_short", true)
			end
			if (context.number >= books_of_nagash_to_collect_long) then
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "wh3_dlc29_vmp_mannfred_collect_books_of_nagash_long", true)
			end
		end

		core:add_listener(
			"IEVictoryConditionVmpMannfredUpdateBooksOfNagash",
			"ScriptEventBookOfNagashUpdated",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				update_books_of_nagash_objective(context)
			end,
			true
		)

		-- Mannfred von Carstein: Awaken 3/6 Bloodline lords for short/long victory
		core:add_listener(
			"IEVictoryConditionVmpMannfredAwakenVampireLord",
			"ScriptEventVampireLairAwakened",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_mannfred_awaken_bloodline_lords_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_mannfred_awaken_bloodline_lords_long", 1)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionVmpMannfredConvertsClimate",
			"SettlementClimateChanged",
			function(context)
				local garrison = context:garrison_residence()
				if garrison and not garrison:is_null_interface() then
					local faction = context:garrison_residence():faction()
					if faction and not faction:is_null_interface() then
						if faction:name() == faction_key and context:new_climate_type() == "climate_vampiric" then
							return true
						end
					end
				end
				return false
			end,
			function(context)
				local province_key = context:garrison_residence():region():province_name()
				local converted_provinces = cm:get_saved_value("IEVictoryConditionsMannfredCovertedProvincesToWastelandClimate") or {}
				if not table.contains(converted_provinces, province_key) then
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland_long", 1)
					table.insert(converted_provinces, province_key)
					cm:set_saved_value("IEVictoryConditionsMannfredCovertedProvincesToWastelandClimate", converted_provinces)
				end
			end,
			true
		)

	end,

	-- Vlad von Carstein
	["wh_dlc04_vmp_vlad_con_carstein"] = function(faction_key)

		-- Vlad von Carstein: Confederate, vassalise or destroy 1 or 3 of the other vampire count legendary lords
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_VASSALISE_OR_DESTROY_X_FACTIONS(
			"IEVictoryConditionVmpVladConfederateVassaliseDestroyShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_vlad_confederate_vassalise_destroy_short",
			faction_key,
			{
				"wh3_main_vmp_caravan_of_blue_roses",
				"wh3_dlc29_vmp_neferata",
				"wh2_dlc11_vmp_the_barrow_legion",
				"wh_main_vmp_vampire_counts",
				"wh_main_vmp_mousillon"
			},
			1
		)

		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_VASSALISE_OR_DESTROY_X_FACTIONS(
			"IEVictoryConditionVmpVladConfederateVassaliseDestroyLong",
			"wh_main_long_victory",
			"wh3_dlc29_vmp_vlad_confederate_vassalise_destroy_long",
			faction_key,
			{
				"wh3_main_vmp_caravan_of_blue_roses",
				"wh3_dlc29_vmp_neferata",
				"wh2_dlc11_vmp_the_barrow_legion",
				"wh_main_vmp_vampire_counts",
				"wh_main_vmp_mousillon"
			},
			3
		)

		-- Vlad von Carstein: Build Landmark: Von Carstein Court Hall in Castle Drakenhof for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpVladBuildLandmark_Short",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_vlad_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_castle_drakenhof",
			{"wh2_main_special_drakenhof_court_2"}
		)

		-- Vlad von Carstein: Build Landmark: Occupied Imperial Palace in Altdorf for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpVladBuildLandmark_Long",
			"wh_main_long_victory",
			"wh3_dlc29_vmp_vlad_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_altdorf",
			{"wh2_main_special_altdorf_imperial_palace_vmp"}
		)

		-- Vlad von Carstein: Empower the Von Carstein bloodline 3/6 times for short/long victory
		local carstein_bloodline_ritual_prefix = "wh2_dlc11_ritual_bloodlines_von_carstein"
		core:add_listener(
			"IEVictoryConditionVmpVladPerformBloodlineEmpowerRituals",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), carstein_bloodline_ritual_prefix)
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_vlad_perform_carstein_empower_rituals_long", 1)
			end,
			true
		)

		-- Vlad von Carstein: Confederate 1/all Vampire Lords via Bloodlines for short/long victory
		_victory_objectives_ie.listeners.vmp_shared_objective_listeners(faction_key)

	end,

	-- Isabella von Carstein
	["wh_pro02_vmp_isabella_von_carstein"] = function(faction_key)

		-- Isabella von Carstein: Build Landmark: Von Carstein Court Hall for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpIsabelladBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_vmp_isabella_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_castle_drakenhof",
			{"wh2_main_special_drakenhof_court_2"}
		)

		-- Isabella von Carstein: Rank up 2 Vampire Heroes (shadow and death) up to rank 20 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS(
			"IEVictoryConditionVmpIsabellaRankUpHeroesShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_isabella_rankup_heroes_short",
			faction_key,
			{"wh_dlc05_vmp_vampire_shadow", "wh_main_vmp_vampire_death"},
			20,
			2
		)

		-- Isabella von Carstein: Kill 9/18 Human lords in battle for short/long victory
		local human_cultures = {
			"wh_main_emp_empire",
			"wh3_main_cth_cathay",
			"wh_main_brt_bretonnia",
		}
		core:add_listener(
			"IEVictoryConditionVmpIsabellaKillHumanLords",
			"CharacterConvalescedOrKilled",
			function(context)
				return context:character():faction():name() ~= faction_key
						and table.contains(human_cultures, context:character():faction():culture())
						and context:character():character_details():character_type("general")
						and context:character():convalesence_cause() == 3
						and cm:pending_battle_cache_faction_is_involved(faction_key)
						and cm:pending_battle_cache_fm_is_involved(context:character():family_member())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_vmp_isabella_kill_human_lords_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_vmp_isabella_kill_human_lords_long", 1)
			end,
			true
		)

		-- Isabella von Carstein: Confederate 2 Vampire Lords via Bloodlines for long victory
		_victory_objectives_ie.listeners.vmp_shared_objective_listeners(faction_key)

	end,

	-- Heinrich Kemmler
	["wh2_dlc11_vmp_the_barrow_legion"] = function(faction_key)

		-- Heinrich Kemmler: Build Landmark: Castle Drachenfels' Library in Blackstone Post for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpKemmlerBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_kemmler_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_blackstone_post",
			{"wh2_main_special_castle_drachenfels_2"}
		)

		-- Heinrich Kemmler: Build Landmark: Altdorf College of Forbidden Magic in Altdorf for long victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpKemmlerBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_vmp_kemmler_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_altdorf",
			{"wh_main_special_college_of_magic_vampires"}
		)

		-- Heinrich Kemmler: Recruit 8 of Cairn Wraiths and Hexwraiths and rank them up to rank 7 for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionVmpKemmlerRankupUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_kemmler_rankup_units_short",
			faction_key,
			{"wh_main_vmp_inf_cairn_wraiths", "wh_main_vmp_cav_hexwraiths"},
			7
		)

		-- Heinrich Kemmler: Confederate 2 Vampire Lords via Bloodlines for long victory
		_victory_objectives_ie.listeners.vmp_shared_objective_listeners(faction_key)

	end,

	-- Helman Ghorst
	["wh3_main_vmp_caravan_of_blue_roses"] = function(faction_key)

		-- Helman Ghorst: Build Landmark: Copse of Sacrilege for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpGhorstBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_ghorst_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_the_haunted_forest",
			{"wh3_main_special_desecrated_grove_2"}
		)

		-- Helman Ghorst: Upgrade the Haunted Forest to a Dark Castle for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionVmpGhorstUpgrateCapitalShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_ghorst_build_max_tier_settlement_short",
			faction_key,
			"wh3_main_combi_region_the_haunted_forest",
			{"wh_main_vmp_settlement_major_5"}
		)

		-- Helman Ghorst: Recruit 7 units of Zombies and increase their rank to 7  for short victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS(
			"IEVictoryConditionVmpGhorstRankupUnitsShort",
			"wh_main_short_victory",
			"wh3_dlc29_vmp_ghorst_rankup_units_short",
			faction_key,
			{"wh_main_vmp_inf_zombie"},
			7
		)

		-- Helman Ghorst: Confederate 2 Vampire Lords via Bloodlines for long victory
		_victory_objectives_ie.listeners.vmp_shared_objective_listeners(faction_key)

	end,

	-- Shared
	["vmp_shared_objective_listeners"] = function(faction_key)

		-- Isabella von Carstein:Confederate 2 Vampire Lord via Bloodlines for long victory
		-- Heinrich Kemmler: Confederate 2 Vampire Lord via Bloodlines for long victory
		-- Helman Ghorst: Confederate 2 Vampire Lord via Bloodlines for long victory
		local confederate_victory_conditions = {
			["wh_pro02_vmp_isabella_von_carstein"] = 	{["wh_main_long_victory"] 	= "wh3_dlc29_vmp_isabella_confederate_via_bloodline_long"},
			["wh2_dlc11_vmp_the_barrow_legion"] = 		{["wh_main_long_victory"]	= "wh3_dlc29_vmp_kemmler_confederate_via_bloodline_long"},
			["wh3_main_vmp_caravan_of_blue_roses"] = 	{["wh_main_long_victory"]	= "wh3_dlc29_vmp_ghorst_confederate_via_bloodline_long"},
		}

		local variant_key = faction_key
		local faction_obj = cm:get_faction(faction_key)
		local bloodline_confederate_ritual_prefix = "wh3_dlc29_vmp_ritual_confederate_lord_"

		if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
			variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
		end

		if confederate_victory_conditions[variant_key] then
			for victory_type, script_key in dpairs(confederate_victory_conditions[variant_key]) do
				core:add_listener(
					"IEVictoryConditionVmpPerformBloodlineConfederateRituals" .. variant_key .. victory_type,
					"RitualCompletedEvent",
					function(context)
						return context:performing_faction():name() == faction_key and string.starts_with(context:ritual():ritual_key(), bloodline_confederate_ritual_prefix)
					end,
					function(context)
						cm:increase_scripted_mission_count(victory_type, script_key, 1)
					end,
					true
				)
			end
		end

	end,

----- GRAND CATHAY -----

	-- Miao Ying, the Storm Dragon
	["wh3_main_cth_the_northern_provinces"] = function(faction_key)

		-- Miao Ying, the Storm Dragon: Build Landmarks: Terracotta Road
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCthMiaoBuildLandmarkShort",
			"wh_main_short_victory",
			"wh3_dlc29_cth_miao_build_landmark_short",
			faction_key,
			"wh3_main_combi_region_nan_gau",
			{"wh3_cp1_cth_special_terracotta_road"}
		)

		-- Miao Ying, the Storm Dragon: Upgrade the Snake Gate, Dragon Gate and Turtle Gate to Bastion Citadels for Short Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionCthMiaoBuildGatesShort",
			"wh_main_short_victory",
			"wh3_dlc29_cth_miao_upgrade_gates_short",
			faction_key,
			{
				wh3_main_combi_region_snake_gate = "wh3_main_cth_bastion_primary_3",
				wh3_main_combi_region_dragon_gate = "wh3_main_cth_bastion_primary_3",
				wh3_main_combi_region_turtle_gate = "wh3_main_cth_bastion_primary_3",
			}
		)

		-- Miao Ying, the Storm Dragon: Build Landmarks: The Ninth Wall for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCthMiaoBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_cth_miao_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_nan_gau",
			{"wh3_main_special_the_ninth_wall"}
		)
			
		-- Miao Ying, the Storm Dragon: Upgrade the Snake Gate, Dragon Gate and Turtle Gate to Bastion Fortress for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionCthMiaoBuildGatesLong",
			"wh_main_long_victory",
			"wh3_dlc29_cth_miao_upgrade_gates_long",
			faction_key,
			{
				wh3_main_combi_region_snake_gate = "wh3_main_cth_bastion_primary_5",
				wh3_main_combi_region_dragon_gate = "wh3_main_cth_bastion_primary_5",
				wh3_main_combi_region_turtle_gate = "wh3_main_cth_bastion_primary_5",
			}
		)

		-- Miao Ying, the Storm Dragon: Defeat 5 Legendary Lords in battle for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS(
			"IEVictoryConditionCthMiaoDefeatNLegendaryLords",
			"wh_main_long_victory",
			"wh3_dlc29_cth_miao_kill_legendary_lords_long",
			faction_key,
			true
		)

		-- Miao Ying, the Storm Dragon: Defeat Warriors of Chaos, Daemons of Chaos or Chaos Dwarfs in battle 20/50 times for Short/Long Victory
		core:add_listener(
			"IEVictoryConditionCthMiaoWinBattlesAgainstChaos",
			"BattleCompleted",
			function(context)
				local pb = cm:model():pending_battle()
				return pb:has_been_fought() and cm:pending_battle_cache_faction_won_battle(faction_key) and 
					(cm:pending_battle_cache_culture_is_involved("wh3_dlc23_chd_chaos_dwarfs")
					or cm:pending_battle_cache_culture_is_involved("wh3_main_kho_khorne") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_nur_nurgle") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_sla_slaanesh") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_tze_tzeentch") 
					or cm:pending_battle_cache_culture_is_involved("wh3_main_dae_daemons") 
					or cm:pending_battle_cache_culture_is_involved("wh_main_chs_chaos"))
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cth_miao_win_battles_against_factions_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cth_miao_win_battles_against_factions_long", 1)
			end,
			true
		)
		
	end,

	-- Zhao Ming, the Iron Dragon
	["wh3_main_cth_the_western_provinces"] = function(faction_key)

		-- Zhao Ming, the Iron Dragon: Build Landmark: The Great Embassy for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION(
			"IEVictoryConditionCthZhaoBuildLandmarkLong",
			"wh_main_long_victory",
			"wh3_dlc29_cth_zhao_build_landmark_long",
			faction_key,
			"wh3_main_combi_region_shang_yang",
			{"wh3_main_special_the_great_embassy"}
		)

		-- Zhao Ming, the Iron Dragon: Destroy Faction or make a Military Alliance: Goldtooth for Short Victory
		local goldtooth_faction_key = "wh3_main_ogr_goldtooth"

		-- Init UI after initialization
		local goldtooth_obective_complete = nil
		if cm:get_saved_value("IEVictoryConditionCthZhaoDefeatOrAllyGoldtooth") then
			goldtooth_obective_complete = goldtooth_faction_key
		end
		update_mission_entity_completion_states({goldtooth_faction_key}, {goldtooth_obective_complete}, "faction_key", "wh_main_short_victory", "wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short")

		core:add_listener(
			"IEVictoryConditionCthZhaoDefeatGoldtooth",
			"FactionDeath",
			function(context)
				return goldtooth_faction_key == context:faction():name()
			end,
			function(context)
				update_mission_entity_completion_states({goldtooth_faction_key}, {goldtooth_faction_key}, "faction_key", "wh_main_short_victory", "wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short")
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short", true)
				core:remove_listener("IEVictoryConditionCthZhaoAllyGoldtooth")
				cm:set_saved_value("IEVictoryConditionCthZhaoDefeatOrAllyGoldtooth", true)
			end,
			false
		)

		core:add_listener(
			"IEVictoryConditionCthZhaoAllyGoldtooth",
			"PositiveDiplomaticEvent",
			function(context)
				return (goldtooth_faction_key == context:proposer():name() and faction_key == context:recipient():name() and context:is_military_alliance()) or
					(faction_key == context:proposer():name() and goldtooth_faction_key == context:recipient():name() and context:is_military_alliance())
			end,
			function(context)
				update_mission_entity_completion_states({goldtooth_faction_key}, {goldtooth_faction_key}, "faction_key", "wh_main_short_victory", "wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short")
				cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "wh3_dlc29_cth_zhao_destroy_faction_or_make_military_ally_short", true)
				core:remove_listener("IEVictoryConditionCthZhaoDefeatGoldtooth")
				cm:set_saved_value("IEVictoryConditionCthZhaoDefeatOrAllyGoldtooth", true)
			end,
			false
		)

		-- Zhao Ming, the Iron Dragon: Resolve 20 Caravan Events for Short Victory
		core:add_listener(
			"IEVictoryConditionCthZhaoResolveCaravanEvents",
			"DilemmaIssuedEvent",
			function(context)
				return context:faction():name() == faction_key and context:dilemma():starts_with("wh3_main_dilemma_cth_caravan")
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cth_zhao_resolve_caravan_events_short", 1)
			end,
			true
		)

		-- Zhao Ming, the Iron Dragon: Send a Caravan to every location at least once for Long Victory
		local required_destinations = caravans.destinations_key.main_warhammer.cathay

		-- Init UI after initialization
		local completed_destinations = cm:get_saved_value("IEVictoryConditionsCthZhaoCompletedCaravanDestionationList") or {}
		update_mission_entity_completion_states(required_destinations, completed_destinations, "region_key", "wh_main_long_victory", "wh3_dlc29_cth_zhao_send_caravans_long")

		core:add_listener(
			"IEVictoryConditionCthZhaoSendCaravans",
			"CaravanCompleted",
			function(context)
				return context:faction():name() == faction_key
			end,
			function(context)
				local region_key = context:complete_position():node():region_key()
				local completed_destinations = cm:get_saved_value("IEVictoryConditionsCthZhaoCompletedCaravanDestionationList") or {}
				if not table.contains(completed_destinations, region_key) then
					table.insert(completed_destinations, region_key)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cth_zhao_send_caravans_long", 1)
					cm:set_saved_value("IEVictoryConditionsCthZhaoCompletedCaravanDestionationList", completed_destinations)
					update_mission_entity_completion_states(required_destinations, completed_destinations, "region_key", "wh_main_long_victory", "wh3_dlc29_cth_zhao_send_caravans_long")
				end
			end,
			true
		)

	end,

	-- Yuan Bo, the Jade Dragon
	["wh3_dlc24_cth_the_celestial_court"] = function(faction_key)

		-- Yuan Bo, the Jade Dragon: Construct 2 of the four Astromantic Relay buildings for Short Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionCthYuanBoBuildLandmarksShort",
			"wh_main_short_victory",
			"wh3_dlc29_cth_yuanbo_construct_astromantic_relays_short",
			faction_key,
			{
				wh3_main_combi_region_great_turtle_isle = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_the_star_tower = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_hexoatl = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_the_southern_sentinels = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
			},
			2
		)

		-- Yuan Bo, the Jade Dragon: Construct all four Astromantic Relay buildings for Long Victory
		victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS(
			"IEVictoryConditionCthYuanBoBuildLandmarksLong",
			"wh_main_long_victory",
			"wh3_dlc29_cth_yuanbo_construct_astromantic_relays_long",
			faction_key,
			{
				wh3_main_combi_region_great_turtle_isle = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_the_star_tower = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_hexoatl = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
				wh3_main_combi_region_the_southern_sentinels = "wh3_dlc24_cth_special_jade_dragon_astromantic_relay",
			},
			4
		)

		-- Yuan Bo, the Jade Dragon: Complete a Balanced Action 2 times for Short Victory
		local balanced_action_ritual_key_list = {
			"wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine",
			"wh3_dlc24_ritual_cth_mos_balance_army_harmony_supremacy",
		}
		core:add_listener(
			"IEVictoryConditionCthYuanboPerformBalancedActions",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(balanced_action_ritual_key_list, context:ritual():ritual_key())
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cth_yuanbo_perform_matters_of_state_actions_short", 1)
			end,
			true
		)

		-- Yuan Bo, the Jade Dragon: Empower the Broken Lands, Dragon River, Ashshair and Nongchang Basin for Long Victory
		core:add_listener(
			"IEVictoryConditionCthYuanBoEmpowersCompass",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:dilemma(), "wh3_dlc24_story_panel_yuan_bo_compass_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cth_yuanbo_empower_compass_directions_long", 1)
			end,
			true
		)
		
	end,

	-- Bashiva, the White Tiger
	["wh3_cp1_cth_tiger_warriors"] = function(faction_key)
		
		core:add_listener(
			"IEVictoryConditionCthBhashivaTigerCourtReachMaxLevel",
			"PooledResourceChanged",
			function(context)
				return context:has_faction() and not context:faction():is_null_interface() and context:faction():name() == faction_key and string.starts_with(context:resource():key(), "wh3_cp1_cth_court")
			end,
			function(context)
				local pooled_resource_obj = context:resource()
				local pooled_resource_key = pooled_resource_obj:key()
				local max_level_tiger_court_pillars = cm:get_saved_value("IEVictoryConditionsBhashivaMaxLevelTigerCourtPillarsList") or {}

				if pooled_resource_obj:value() >= pooled_resource_obj:maximum_value() and not table.contains(max_level_tiger_court_pillars, pooled_resource_key) then
					table.insert(max_level_tiger_court_pillars, pooled_resource_key)
					cm:set_saved_value("IEVictoryConditionsBhashivaMaxLevelTigerCourtPillarsList", max_level_tiger_court_pillars)
					cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cth_bhashiva_reach_tiger_court_max_level_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cth_bhashiva_reach_tiger_court_max_level_long", 1)
				end
			end,
			true
		)


		core:add_listener(
			"IEVictoryConditionCthBhashivaCompleteZhaoGoals",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == faction_key and string.starts_with(context:mission():mission_record_key(), "wh3_cp1_camp_cth_enemies_of_cathay_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "wh3_dlc29_cth_bhashiva_complete_zhao_goals_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "wh3_dlc29_cth_bhashiva_complete_zhao_goals_long", 1)
			end,
			true
		)
		
	end,
}

-- Scripted rewards contain lord/hero payloads, adding unit to pools via campaign_payload, etc. They are represented with dummy campaign_payload or meant as a hidden part of other payload.
_victory_objectives_ie.scripted_rewards = {
----- BEASTMEN -----
	
	-- Khazrak
	["wh_dlc03_bst_beastmen"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_dlc03_bst_beastlord", 9, "wh3_dlc29_skill_innate_bst_unique_reward_1")
		end,
	},

	-- Taurox
	["wh2_dlc17_bst_taurox"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_dlc17_bst_doombull", 9, "wh3_dlc29_skill_innate_bst_unique_reward_2")
		end,
	},

	-- Morghur
	["wh_dlc05_bst_morghur_herd"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_twa04_bst_great_bray_shaman_wild", 9, "wh3_dlc29_skill_innate_bst_unique_reward_3")
		end,
	},

	-- Malagor
	["wh2_dlc17_bst_malagor"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_twa04_bst_great_bray_shaman_wild", 9, "wh3_dlc29_skill_innate_bst_unique_reward_4")
		end,
	},

----- LIZARDMEN -----

	-- Mazdamundi
	["wh2_main_lzd_hexoatl"] = {
		short_victory = function(faction_key)
			-- Call recalculate through delayed callback because unit cap increase bonus values take some time to apply
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_temple_guard_merc")
				end, 
				0.5
			)
		end,
	},

	-- Kroq-Gar
	["wh2_main_lzd_last_defenders"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_hero(faction_key, "champion", "wh2_main_lzd_saurus_scar_veteran", 10, "wh3_dlc29_skill_innate_lzd_unique_reward_1")
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_saurus_warrior_merc")
				end, 
				0.5
			)
		end,
	},

	-- Tiqtaqto
	["wh2_main_lzd_tlaqua"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_ripperdactyl_terradon_merc")
				end, 
				0.5
			)
		end,
	},

	-- Tehenhauin
	["wh2_dlc12_lzd_cult_of_sotek"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_skinks_merc")
				end, 
				0.5
			)
		end,
	},

	-- Nakai
	["wh2_dlc13_lzd_spirits_of_the_jungle"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_kroxigor_merc")
				end, 
				0.5
			)
		end,
	},

	-- Gor-Rok
	["wh2_main_lzd_itza"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_saurus_warrior_merc")
				end, 
				0.5
			)
		end,
	},

	-- Oxyotl
	["wh2_dlc17_lzd_oxyotl"] = {
		short_victory = function(faction_key)
			-- default pooled resource payload will break the sanctum gem to sanctum points conversion, therefore script call
			Silent_Sanctums:add_sanctum_gems(2)

			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_blessed_skinks_merc")
				end, 
				0.5
			)
		end,
	},

----- HIGH ELF -----
	
	-- Eltharion
	["wh2_main_hef_yvresse"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_mistwalker_units")
				end, 
				0.5
			)
		end,
	},

----- DWARF -----

	-- Ungrim
	["wh_main_dwf_karak_kadrin"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_main_dwf_lord", 9, "wh3_dlc29_skill_innate_dwf_unique_reward_1")
		end,
	},

----- BRETONNIA -----

	-- Louen
	["wh_main_brt_bretonnia"] = {
		short_victory = function(faction_key)

			local reward_lord_subtype_key = "wh_main_brt_lord"

			core:add_listener(
				"IEVictoryConditionRewards_SetMaxVowProgress_LouenShortVictory",
				"CharacterCreated",
				function(context)
					local character_obj = context:character()
					return not context:has_respawned() and not character_obj:is_wounded() and character_obj:faction():name() == faction_key and character_obj:character_subtype(reward_lord_subtype_key)
				end,
				function(context)
					local character_obj = context:character()

					for i = 1, 6 do
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
					end
				end,
				false
			)

			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, reward_lord_subtype_key, 9)
		end,

		long_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.bretonnia_max_out_vows(faction_key)
		end,

		persistent_scripted_reward = {
			long_victory = true
		},
	},

	-- Alberic
	["wh_main_brt_bordeleaux"] = {
		long_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.bretonnia_max_out_vows(faction_key)
		end,

		persistent_scripted_reward = {
			long_victory = true
		},
	},

	-- The Fay Enchantress
	["wh_main_brt_carcassonne"] = {
		short_victory = function(faction_key)

			local reward_lord_subtype_key = "wh_dlc07_brt_prophetess_life"

			core:add_listener(
				"IEVictoryConditionRewards_SetMaxVowProgress_FayShortVictory",
				"CharacterCreated",
				function(context)
					local character_obj = context:character()
					return not context:has_respawned() and not character_obj:is_wounded() and character_obj:faction():name() == faction_key and character_obj:character_subtype(reward_lord_subtype_key)
				end,
				function(context)
					local character_obj = context:character()

					for i = 1, 6 do
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
						add_vow_progress(character_obj, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
					end
				end,
				false
			)

			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, reward_lord_subtype_key, 9)
		end,

		long_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.bretonnia_max_out_vows(faction_key)
		end,

		persistent_scripted_reward = {
			long_victory = true
		},
	},

	-- Repanse
	["wh2_dlc14_brt_chevaliers_de_lyonesse"] = {
		long_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.bretonnia_max_out_vows(faction_key)
		end,

		persistent_scripted_reward = {
			long_victory = true
		},
	},

----- WOOD ELF -----

	-- Orion
	["wh_dlc05_wef_wood_elves"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_dlc05_wef_glade_lord", 9, "wh3_dlc29_skill_innate_wef_unique_reward_1")
		end,
	},

	-- Durthu
	["wh_dlc05_wef_argwylon"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_dlc05_wef_ancient_treeman", 9, "wh3_dlc29_skill_innate_wef_unique_reward_2")
		end,
	},

	-- Sisters of Twilight
	["wh2_dlc16_wef_sisters_of_twilight"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_dlc16_wef_spellweaver_life", 9, "wh3_dlc29_skill_innate_wef_unique_reward_3")
		end,
	},

----- EMPIRE -----

	-- Karl Franz
	["wh_main_emp_empire"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
				end, 
				0.5
			)
		end,
	},

	-- Balthazar Gelt
	["wh2_dlc13_emp_golden_order"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_main_emp_lord", 9, "wh3_dlc29_skill_innate_emp_unique_reward_1")
		end,
	},

	-- Markus Wulfhart
	["wh2_dlc13_emp_the_huntmarshals_expedition"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_emp_markus_imperial_supplies_victory_objective_short")
		end,
		long_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_emp_markus_imperial_supplies_victory_objective_long")
		end,
	},

	-- Volkmar the Grim
	["wh3_main_emp_cult_of_sigmar"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_dlc04_emp_arch_lector", 9, "wh3_dlc29_skill_innate_emp_unique_reward_2")
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
				end, 
				0.5
			)
		end,
	},

	-- Elspeth von Draken
	["wh_main_emp_wissenland"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_emp_elspeth_amethyst_units_victory_objective_short")
		end,
	},

----- SLAANESH -----

	-- N'Kari
	["wh3_main_sla_seducers_of_slaanesh"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_dlc20_chs_lord_msla", 9, "wh3_dlc29_skill_innate_sla_unique_reward_1")
		end,
	},

----- VAMPIRE COUNTS -----

	-- Neferata
	["wh3_dlc29_vmp_neferata"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_dlc11_vmp_bloodline_lahmian", 9, "wh3_dlc29_skill_innate_vmp_unique_reward_1")
		end,
	},
	

----- TZEENTCH -----

	-- Changeling
	["wh3_dlc24_tze_the_deceivers"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.apply_foreign_slot_regions_effect_bundle(faction_key, "wh3_dlc29_bundle_ie_victory_objective_tze_logistics_expert")
		end,

		persistent_scripted_reward = {
			short_victory = true
		},
	},

----- GRAND CATHAY ------
	-- Miao Ying
	["wh3_main_cth_the_northern_provinces"] = {
		short_victory = function(faction_key)
			local faction = cm:get_faction(faction_key)
			local home_region = faction:home_region()
			local harmony = home_region:faction_province():pooled_resource_manager():resource("wh3_dlc24_cth_province_harmony")
			if harmony and not harmony:is_null_interface() then 
				if harmony:value() > 0 then
					_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_cth_dragon_blooded_shugengan_yang", 9, "wh3_dlc29_skill_innate_cth_unique_reward_1")
				else
					_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_cth_dragon_blooded_shugengan_yin", 9, "wh3_dlc29_skill_innate_cth_unique_reward_1")
				end
			else
				_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_cth_dragon_blooded_shugengan_yin", 9, "wh3_dlc29_skill_innate_cth_unique_reward_1")
			end
		end,
	},

	-- Yuan Bo 
	["wh3_dlc24_cth_the_celestial_court"] = {
		short_victory = function(faction_key)
			local faction = cm:get_faction(faction_key)
			local home_region = faction:home_region()
			local harmony = home_region:faction_province():pooled_resource_manager():resource("wh3_dlc24_cth_province_harmony")
			if harmony and not harmony:is_null_interface() then 
				if harmony:value() > 0 then
					_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_dlc24_cth_celestial_general_yang", 9, "wh3_dlc29_skill_innate_cth_unique_reward_2")
				else
					_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_dlc24_cth_celestial_general_yin", 9, "wh3_dlc29_skill_innate_cth_unique_reward_2")
				end
			else
				_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_dlc24_cth_celestial_general_yang", 9, "wh3_dlc29_skill_innate_cth_unique_reward_2")
			end
		end,
	},

----- DAEMONS OF CHAOS -----

	["wh3_main_dae_daemon_prince"] = {
		short_victory = function(faction_key)

			local ascendancy_ritual_key_to_agent_subtype_key_list = {
				wh3_main_ritual_dae_ascend_khorne = {
					agents = {"wh3_main_kho_exalted_bloodthirster"},
					effect_bundle = "wh3_dlc29_ie_victory_objective_dae_dedicate_to_khorne",
				},
				wh3_main_ritual_dae_ascend_nurgle = {
					agents = {
						"wh3_main_nur_exalted_great_unclean_one_death",
						"wh3_main_nur_exalted_great_unclean_one_nurgle",
					},
					effect_bundle = "wh3_dlc29_ie_victory_objective_dae_dedicate_to_nurgle",
				},
				wh3_main_ritual_dae_ascend_slaanesh = {
					agents = {
						"wh3_main_sla_exalted_keeper_of_secrets_shadow",
						"wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
					},
					effect_bundle = "wh3_dlc29_ie_victory_objective_dae_dedicate_to_slaanesh",
				},
				wh3_main_ritual_dae_ascend_tzeentch = {
					agents = {
						"wh3_main_tze_exalted_lord_of_change_metal",
						"wh3_main_tze_exalted_lord_of_change_tzeentch",
					},
					effect_bundle = "wh3_dlc29_ie_victory_objective_dae_dedicate_to_tzeentch",
				},
				wh3_main_ritual_dae_ascend_undivided = {
					agents = {
						"wh3_main_kho_exalted_bloodthirster",
						"wh3_main_nur_exalted_great_unclean_one_death",
						"wh3_main_nur_exalted_great_unclean_one_nurgle",
						"wh3_main_sla_exalted_keeper_of_secrets_shadow",
						"wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
						"wh3_main_tze_exalted_lord_of_change_metal",
						"wh3_main_tze_exalted_lord_of_change_tzeentch",
					},
					effect_bundle = "wh3_dlc29_ie_victory_objective_dae_dedicate_to_undivided",
				},
			}

			local agent_subtype_key_to_spawn
			local agent_subtype_key_candidate_list
			local effect_bundle_to_apply

			local ascendancy_ritual_key = cm:get_saved_value("IEVictoryConditionRewardsDaemonPrinceAscendancyPath")

			if ascendancy_ritual_key and ascendancy_ritual_key_to_agent_subtype_key_list[ascendancy_ritual_key] then
				agent_subtype_key_candidate_list = ascendancy_ritual_key_to_agent_subtype_key_list[ascendancy_ritual_key].agents
				effect_bundle_to_apply = ascendancy_ritual_key_to_agent_subtype_key_list[ascendancy_ritual_key].effect_bundle
			else
				agent_subtype_key_candidate_list = ascendancy_ritual_key_to_agent_subtype_key_list["wh3_main_ritual_dae_ascend_undivided"].agents
				effect_bundle_to_apply = ascendancy_ritual_key_to_agent_subtype_key_list["wh3_main_ritual_dae_ascend_undivided"].effect_bundle
			end
			
			agent_subtype_key_to_spawn = agent_subtype_key_candidate_list[cm:random_number(#agent_subtype_key_candidate_list)]

			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, agent_subtype_key_to_spawn, 9)
			cm:apply_effect_bundle(effect_bundle_to_apply, faction_key, 0)
		end,
	},


----- WARRIORS OF CHAOS -----

	-- Archaon
	["wh_main_chs_chaos"] = {
		short_victory = function(faction_key)
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_chs_archaon_units_victory_objective_short")
				end,
				0.5
			)
		end,
	},

	-- Kholek
	["wh3_dlc20_chs_kholek"] = {
		short_victory = function(faction_key)	
			cm:callback(
				function() 
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_chs_kholek_units_victory_objective_short")
				end,
				0.5
			)
		end,
	},

	-- Sigvald
	["wh3_dlc20_chs_sigvald"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_sla_exalted_keeper_of_secrets_slaanesh")
		end,
	},
	-- Festus
	["wh3_dlc20_chs_festus"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_nur_exalted_great_unclean_one_nurgle")
		end,
	},
	-- Azazel
	["wh3_dlc20_chs_azazel"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_sla_exalted_keeper_of_secrets_slaanesh")
		end,
	},
	-- Vilitch
	["wh3_dlc20_chs_vilitch"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_tze_exalted_lord_of_change_tzeentch")
		end,
	},
	-- Valkia
	["wh3_dlc20_chs_valkia"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_kho_exalted_bloodthirster")
		end,
	},

----- VAMPIRE COAST -----

	-- Luthor Harkon
	["wh2_dlc11_cst_vampire_coast"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_dlc11_cst_admiral_deep", 9, "wh3_dlc29_skill_innate_cst_unique_reward_1", 10)
		end,
	},	

	-- Cylostra
	["wh2_dlc11_cst_the_drowned"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_dlc11_cst_admiral_fem_vampires", 9, "wh3_dlc29_skill_innate_cst_unique_reward_2", 10)
		end,
	},	

----- KISLEV -----

	-- Tzarina Katarin
	["wh3_main_ksl_the_ice_court"] = {
		short_victory = function(faction_key)
			local ice_court_subtype_keys = {
				"wh3_main_ksl_ice_witch_ice",
				"wh3_main_ksl_ice_witch_tempest",
				"wh3_main_pro_ksl_frost_maiden_ice",
				"wh3_main_ksl_frost_maiden_tempest",
				"wh3_main_ksl_frost_maiden_ice",
			}

			core:add_listener(
				"IEVictoryConditionRewardsGrantDevotionForTrainingIceCourtChars",
				"CharacterCreated",
				function(context)
					local character_obj = context:character()
					return not context:has_respawned() and not character_obj:is_wounded() and character_obj:faction():name() == faction_key and table.contains(ice_court_subtype_keys, character_obj:character_subtype_key())
				end,
				function(context)
					cm:faction_add_pooled_resource(faction_key, "wh3_main_ksl_support_tracker_ice_court", "faction", 50)
				end,
				true
			)
		end,

		persistent_scripted_reward = {
			short_victory = true
		},
	},

	-- Boris Ursus
	["wh3_main_ksl_ursun_revivalists"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh3_main_ksl_ataman", 9, "wh3_dlc29_skill_innate_ksl_unique_reward_1")
		end,
	},
	
----- DARK ELF -----

	-- Morathi
	["wh2_main_def_cult_of_pleasure"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh2_main_def_dreadlord", 9, "wh3_dlc29_skill_innate_def_unique_reward_1", 10)
		end,
	},

	-- Crone Hellebron
	["wh2_main_def_har_ganeth"] = {
		short_victory = function(faction_key)
			-- delayed callback to give time for bonus values to be applied by rewarded effect bundle
			cm:callback(
				function() 
					local victory_reward_cost_cap_modifier = cm:get_factions_bonus_value(faction_key, "wh3_dlc29_def_death_night_cost_cap_mod")
					local victory_reward_current_cost_modifier = cm:get_factions_bonus_value(faction_key, "wh3_dlc29_def_death_night_cost_mod")
					death_night.cost.cap = math.clamp(death_night.cost.cap + death_night.cost.cap * victory_reward_cost_cap_modifier / 100, 1, death_night.cost.cap)
					death_night.cost.current = math.clamp(death_night.cost.current + death_night.cost.current * victory_reward_current_cost_modifier / 100, 1, death_night.cost.cap)
					death_night:update_ui()
				end,
				0.5
			)
		end,
	},

	-- Malus Darkblade
	["wh2_main_def_hag_graef"] = {
		short_victory = function(faction_key)
			-- delayed callback to give time for bonus values to be applied by rewarded effect bundle
			cm:callback(
				function()
					local faction_obj = cm:get_faction(faction_key)
					malus_sanity:update_effects(faction_obj)
				end,
				0.5
			)
		end,
	},

	-- Rakarth
	["wh2_twa03_def_rakarth"] = {
		short_victory = function(faction_key)
			cm:callback(
				function()
					cm:recalculate_faction_mercenary_unit_caps(faction_key)
					_victory_objectives_ie.scripted_rewards.apply_campaign_payload(faction_key, "wh3_dlc29_ie_victory_conditions_reward_rakarth_beasts_short")
				end,
				0.5
			)
		end,
	},
----- GREENSKINS -----

	-- Azhag
	["wh2_dlc15_grn_bonerattlaz"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_main_grn_orc_warboss", 9, "wh3_dlc29_skill_innate_grn_unique_reward_1")
		end,
	},

	-- Wurrzag
	["wh_main_grn_orcs_of_the_bloody_hand"] = {
		short_victory = function(faction_key)
			_victory_objectives_ie.scripted_rewards.spawn_general(faction_key, "wh_main_grn_goblin_great_shaman", 9, "wh3_dlc29_skill_innate_grn_unique_reward_2")
		end,
	},
	

----- UTILS -----
	spawn_general = function(faction_key, general_subtype_key, bonus_levels, background_skill_key, loyalty, mortal)
		local spawn_x, spawn_y = -1, -1
		local spawn_region_key
		local faction_obj = cm:get_faction(faction_key)
		local faction_leader = faction_obj:faction_leader()
		local tries = 1
		local max_tries = 5
		local spawn_with_no_background_skill = not(is_nil(background_skill_key))

		-- First try to spawn near Faction Leader, then try to spawn near any settlement, last resort - spawn near any other character
		while spawn_x == -1 and tries <= max_tries do
			if faction_leader:is_null_interface() == false then 
				if faction_leader:is_wounded() == false then
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(faction_leader), true, 5)
					spawn_region_key = faction_leader:region():name()
				elseif faction_obj:region_list():is_empty() == false then
					spawn_region_key = faction_obj:region_list():item_at(0)
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, spawn_region_key, false, true, 5)
				elseif faction_obj:character_list():is_empty() == false then
					local character_to_spawn_at = faction_obj:character_list():item_at(0)
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character_to_spawn_at), true, 5)
					spawn_region_key = character_to_spawn_at:region():name()
				else
					script_error("ERROR: tried to spawn general (short victory reward) for " .. faction_key .. " but faction has no generals and settlements")
				end
			end
			tries = tries + 1
		end
	
		if spawn_x == -1 then
			return
		end

		cm:create_force_with_general(
			faction_key,
			"",
			spawn_region_key,
			spawn_x,
			spawn_y,
			"general",
			general_subtype_key,
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				local character_object = cm:get_character_by_cqi(cqi)
				if is_nil(character_object) == false and character_object:is_null_interface() == false then
					CampaignUI.ClearSelection()
					local character_lookup = cm:char_lookup_str(character_object)
					cm:randomise_character_name(character_object)
					
					if is_nil(bonus_levels) == false then 
						cm:add_agent_experience(character_lookup, bonus_levels, true)
					end

					if spawn_with_no_background_skill then 
						cm:pick_background_skill(character_object, background_skill_key)
					end

					if is_nil(loyalty) == false then 
						cm:modify_character_personal_loyalty_factor(character_lookup, loyalty)
					end

					if not mortal then
						local character_details = character_object:character_details()
						cm:character_details_add_skill_point(character_details, "wh2_main_skill_all_immortality_lord")
					end
				end
			end,
			nil,
			spawn_with_no_background_skill
		)
	end,

	spawn_hero = function(faction_key, hero_type, hero_subtype_key, bonus_levels, background_skill_key, mortal)
		local spawn_x, spawn_y = -1, -1
		local spawn_region_key
		local faction_obj = cm:get_faction(faction_key)
		local faction_leader = faction_obj:faction_leader()
		local tries = 1
		local max_tries = 5
		local spawn_with_no_background_skill = not(is_nil(background_skill_key))

		-- First try to spawn near Faction Leader, then try to spawn near any settlement, last resort - spawn near any other character
		while spawn_x == -1 and tries <= max_tries do
			if faction_leader:is_null_interface() == false then 
				if faction_leader:is_wounded() == false then
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(faction_leader), true, 5)
					spawn_region_key = faction_leader:region():name()
				elseif faction_obj:region_list():is_empty() == false then
					spawn_region_key = faction_obj:region_list():item_at(0)
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, spawn_region_key, false, true, 5)
				elseif faction_obj:character_list():is_empty() == false then
					local character_to_spawn_at = faction_obj:character_list():item_at(0)
					spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character_to_spawn_at), true, 5)
					spawn_region_key = character_to_spawn_at:region():name()
				else
					script_error("ERROR: tried to spawn hero (short victory reward) for " .. faction_key .. " but faction has no generals and settlements")
				end
			end
			tries = tries + 1
		end
	
		if spawn_x == -1 then
			return
		end

		local new_hero = cm:create_agent(
			faction_key,
			hero_type,
			hero_subtype_key,
			spawn_x,
			spawn_y,
			true,
			true
		)

		if new_hero and not new_hero:is_null_interface() then
			local character_lookup = cm:char_lookup_str(new_hero)
			
			if is_nil(bonus_levels) == false then 
				cm:add_agent_experience(character_lookup, bonus_levels, true)
			end

			if spawn_with_no_background_skill then 
				cm:pick_background_skill(new_hero, background_skill_key)
			end

			if not mortal then
				local character_details = new_hero:character_details()
				cm:character_details_add_skill_point(character_details, "wh2_main_skill_all_immortality_hero")
			end
		end
	end,

	apply_campaign_payload = function(faction_key, campaign_payload_record_key)
		local campaign_payload = cm:create_payload()
		local faction_obj = cm:get_faction(faction_key)
		campaign_payload:components_from_record(campaign_payload_record_key, faction_obj, faction_obj)
		cm:apply_payload(campaign_payload, faction_obj)
	end,

	bretonnia_max_out_vows = function(faction_key)

		local vow_agents = {
			["wh_main_brt_paladin"] = true,
			["wh2_dlc14_brt_henri_le_massif"] = true,
			["wh_main_brt_damsel_heavens"] = true,
			["wh_dlc07_brt_damsel_beasts"] = true,
			["wh_dlc07_brt_damsel_life"] = true
		}
		
		core:add_listener(
			"IEVictoryConditionRewards_SetMaxVowProgress_LongVictory" .. faction_key,
			"CharacterCreated",
			function(context)
				local character_obj = context:character()
				return not context:has_respawned() and not character_obj:is_wounded() and character_obj:faction():name() == faction_key
			end,
			function(context)
				local character_obj = context:character()
				local vow_suffix = ""

				if vow_agents[character_obj:character_subtype_key()] then 
					vow_suffix = "_agent"
				end

				for i = 1, 6 do
					add_vow_progress(character_obj, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge" .. vow_suffix, true, false)
					add_vow_progress(character_obj, "wh_dlc07_trait_brt_questing_vow_protect_pledge" .. vow_suffix, true, false)
					add_vow_progress(character_obj, "wh_dlc07_trait_brt_grail_vow_valour_pledge" .. vow_suffix, true, false)
				end
			end,
			true
		)
	end,

	apply_foreign_slot_regions_effect_bundle = function(faction_key, effect_bundle_key)

		-- Apply effect_bundle to all existing regions with Skaven foreign slot manager the moment Short Victory Reward is received
		local faction_obj = cm:get_faction(faction_key)
		local foreign_slot_manager_list = faction_obj:foreign_slot_managers()
		for i = 0, foreign_slot_manager_list:num_items() - 1 do
			local foreign_slot_obj = foreign_slot_manager_list:item_at(i)
			local region_key = foreign_slot_obj:region():name()
			cm:apply_effect_bundle_to_region(effect_bundle_key, region_key, 0)
		end

		-- Set up listeners to add and remove effect bundle when new foregin slots are created / existing slots removed
		core:add_listener(
			"IEVictoryConditionRewardsCreateForeignSlot" .. faction_key,
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key
			end,
			function(context)
				cm:apply_effect_bundle_to_region(effect_bundle_key, context:region():name(), 0)
			end,
			true
		)

		core:add_listener(
			"IEVictoryConditionRewardsRemoveForeignSlot" .. faction_key,
			"ForeignSlotManagerRemovedEvent",
			function(context)
				return context:owner():name() == faction_key
			end,
			function(context)
				cm:remove_effect_bundle_from_region(effect_bundle_key, context:region():name())
			end,
			true
		)
	end,

	apply_region_bundle = function(faction_key, effect_bundle_key, region_key)
		-- Apply effect_bundle to the supplied region
		local faction_obj = cm:get_faction(faction_key)
		local region = cm:get_region(region_key)

		if region:owning_faction() == faction_obj then 
			cm:apply_effect_bundle_to_region(effect_bundle_key, region_key, 0)
		end

		-- Set up listeners to add and remove effect bundle if/when the region is gained by the faction
		core:add_listener(
			"IEVictoryConditionRewardsSpecificRegionChangeEvent" .. faction_key,
			"RegionFactionChangeEvent",
			function(context)
				return context:region():owning_faction():name() == faction_key
			end,
			function(context)
				cm:apply_effect_bundle_to_region(effect_bundle_key, context:region():name(), 0)
			end,
			true
		)
	end,
}

_victory_objectives_ie.factions_using_lord_as_variant_key = {
	wh_main_vmp_schwartzhafen = true,
}

-- Add victory missions for each human faction at the start of the campaign
cm:add_first_tick_callback_new(
	function()
		local human_factions = cm:get_human_factions()
		local multiplayer = false
		if #human_factions > 1 then
			multiplayer = true
		end

		for i = 1, #human_factions do
			local faction_key = human_factions[i]
			_victory_objectives_ie:initialise_victory_missions(faction_key, multiplayer)
		end

		cm:set_saved_value("IEVictoryConditionUseDLC29Config", true)
	end
)

-- This function creates the victory missions for all playable factions
function _victory_objectives_ie:initialise_victory_missions(faction_key, multiplayer)

	-- Multiplayer victory
	if multiplayer then
		self:create_victory_mission(faction_key, "multiplayer")
	end

	-- Short victory
	self:create_victory_mission(faction_key, "short")

	-- Long victory
	self:create_victory_mission(faction_key, "long")

	-- Domination victory
	self:create_victory_mission(faction_key, "domination")

end

function _victory_objectives_ie:create_victory_mission(faction_key, type)

	local variant_key = faction_key
	if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
		local faction_obj = cm:get_faction(faction_key)
		variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
	end

	local mm = mission_manager:new(faction_key, self.config.victory_types[type].mission_key)
	local objectives = self.config.factions[variant_key] and self.config.factions[variant_key][type] and self.config.factions[variant_key][type].objectives or nil
	if objectives == nil then
		return
	end
	self:add_objectives(mm, objectives)
	self:trigger_victory_mission(faction_key, mm, type, variant_key)
end

function _victory_objectives_ie:trigger_victory_mission(faction_key, mm, type, variant_key)
	
	self:add_victory_mission_payload(faction_key, mm, type, variant_key)

	-- Setup the mission as an actual victory mission (as this uses different library functions) and trigger it
	mm:set_victory_type(self.config.victory_types[type].victory_type_key)
	mm:set_victory_mission(true)
	mm:set_show_mission(false)
	mm:trigger()
end

-- Takes the objectives generated by the victory-specific functions, and passes them through to the mission manager
function _victory_objectives_ie:add_objectives(mm, objectives)

	for i = 1, #objectives do
		if objectives[i].type ~= nil then
			mm:add_new_objective(objectives[i].type)
			for j = 1, #objectives[i].conditions do
				mm:add_condition(objectives[i].conditions[j])
			end
		end
	end

end

-- Set up payload for victory mission. Victory mission payloads are not granted on mission completion but only used to display them in rewards panel
function _victory_objectives_ie:add_victory_mission_payload(faction_key, mm, type, variant_key)

	local payloads = self.config.factions[variant_key] and self.config.factions[variant_key][type] and self.config.factions[variant_key][type].payloads or {}
	for payload_type , payload_data in dpairs(payloads) do
		local payload_string = ""
		if is_table(payload_data) then
			for _, payload_object in dpairs(payload_data) do
				payload_string = self:get_mission_payload_string(payload_type, payload_object, faction_key)
				mm:add_payload(payload_string)
			end
		else
			payload_string = self:get_mission_payload_string(payload_type, payload_data, faction_key)
			mm:add_payload(payload_string)
		end
	end

	local should_add_game_victory = type == "multiplayer" or type == "domination"
	-- If payloads are missing we forcibly add victory as fallback, otherwise the mission will fail to generate
	if payloads == nil or should_add_game_victory then
		mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
		mm:add_payload("game_victory")
	end
end

function _victory_objectives_ie:get_mission_payload_string(payload_type, payload_object, faction_key)

	local payload_string
	if payload_type == "scripted_reward" then
		payload_string = payload.text_display(payload_object)
	elseif payload_type == "effect_bundle" then
		if is_table(payload_object) then
			payload_string = payload.effect_bundle_mission_payload(payload_object[1], payload_object[2])
		else
			payload_string = payload.effect_bundle_mission_payload(payload_object)
		end
	elseif payload_type == "pooled_resource" then
		payload_string = payload.pooled_resource_mission_payload(payload_object[1], payload_object[2], payload_object[3])
	elseif payload_type == "ancillary" then
		payload_string = payload.ancillary_mission_payload_specific(faction_key, payload_object)
	elseif payload_type == "influence" then
		payload_string = "influence " .. tostring(payload_object)
	else
		script_error("ERROR: unsupported payload type " .. payload_type .. " for victory mission for " .. faction_key)
		payload_string = payload.text_display("dummy_wh3_dlc29_main_ie_victory_objective")
	end

	return payload_string
end

-- Victory Incident serves as "Mission Completed" event because victory missions don't have event message at all, also grants victory rewards
function _victory_objectives_ie:trigger_victory_incident(faction_obj, mission_key, incident_key, victory_type)
	local faction_key = faction_obj:name()
	local incident_builder = cm:create_incident_builder(incident_key)
	local payload_builder = cm:create_payload()

	local variant_key = faction_key

	if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
		variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
	end

	local payloads = self.config.factions[variant_key] and self.config.factions[variant_key][victory_type] and self.config.factions[variant_key][victory_type].payloads or nil
	for payload_type , payload_data in dpairs(payloads or {}) do
		if is_table(payload_data) then
			for _, payload_object in dpairs(payload_data) do
				self:add_victory_incident_payload(payload_builder, payload_type, payload_object, faction_obj)
			end
		else
			self:add_victory_incident_payload(payload_builder, payload_type, payload_data, faction_obj)
		end
	end

	incident_builder:set_payload(payload_builder)

	-- Not entirely sure when this happens, but someone somewhere suppresses the event feed and prevents this from triggering. 
	-- This callback fixes this issue.
	cm:callback(
		function()
			cm:launch_custom_incident_from_builder(incident_builder, faction_obj)
		end,
		0.1
	)
end

function _victory_objectives_ie:add_victory_incident_payload(payload_builder, payload_type, payload_object, faction_obj)

	if payload_type == "scripted_reward" then
		payload_builder:text_display(payload_object)
	elseif payload_type == "effect_bundle" then
		local effect_bundle
		if is_table(payload_object) then
			effect_bundle = cm:create_new_custom_effect_bundle(payload_object[1])
			effect_bundle:set_duration(payload_object[2])
		else
			effect_bundle = cm:create_new_custom_effect_bundle(payload_object)
		end
		payload_builder:effect_bundle_to_faction(effect_bundle)
	elseif payload_type == "pooled_resource" then
		payload_builder:faction_pooled_resource_transaction(payload_object[1], payload_object[2], payload_object[3], false)
	elseif payload_type == "ancillary" then
		payload_builder:faction_ancillary_gain(faction_obj, payload_object)
	elseif payload_type == "influence" then
		payload_builder:influence_adjustment(payload_object)
	else
		script_error("ERROR: unsupported payload type " .. payload_type .. " for victory mission for " .. faction_obj:name())
		payload_builder:text_display("dummy_wh3_dlc29_main_ie_victory_objective")
	end
end

-- Handles creation of all scripted objectives listeners and listeners to issue victory incidents
function _victory_objectives_ie:add_scripted_victory_listeners()
	
	-- If campaign was started before Victory Conditions Overhaul - add old listeners from victory_objectives.lua
	if is_nil(cm:get_saved_value("IEVictoryConditionUseDLC29Config")) then
		return
	end

	-- Victory mission payload will not be granted to player. Victory mission rewards will be given by Victory Achieved incident
	cm:set_victory_mission_rewards_disabled(true)

	-- Add Scripted objectives listeners
	local human_factions = cm:get_human_factions()
	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction_obj = cm:get_faction(faction_key)
		local variant_key = faction_key

		if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
			variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
		end

		if _victory_objectives_ie.listeners[variant_key] then
			_victory_objectives_ie.listeners[variant_key](faction_key)
		end
	end

	-- Listener to trigger Short Victory Incident and award scripted rewards
	core:add_listener(
		"IEVictoryConditionShortVictoryAchieved",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_short_victory"
		end,
		function(context)
			local faction_obj = context:faction()
			local faction_key = faction_obj:name()
			local variant_key = faction_key

			if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
				variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
			end

			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "complete_faction_victory", true)
			_victory_objectives_ie:trigger_victory_incident(faction_obj, "wh_main_short_victory", "wh3_main_ie_victory_short", "short")

			local short_victory_factions_list = cm:get_saved_value("factions_achieved_short_victory") or {}
			table.add_unique(short_victory_factions_list, variant_key)
			cm:set_saved_value("factions_achieved_short_victory", short_victory_factions_list)

			if _victory_objectives_ie.scripted_rewards[variant_key] and _victory_objectives_ie.scripted_rewards[variant_key].short_victory then
				_victory_objectives_ie.scripted_rewards[variant_key].short_victory(faction_key)
			end
		end,
		true
	)

	-- Listener to trigger Long Victory Incident and award scripted rewards
	core:add_listener(
		"IEVictoryConditionLongVictoryAchieved",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_long_victory"
		end,
		function(context)
			local faction_obj = context:faction()
			local faction_key = faction_obj:name()
			local variant_key = faction_key

			if _victory_objectives_ie.factions_using_lord_as_variant_key[faction_key] then
				variant_key = _victory_objectives_ie:variant_key_getters(faction_obj)
			end

			_victory_objectives_ie:trigger_victory_incident(faction_obj, "wh_main_long_victory", "wh3_main_ie_victory_long", "long")

			local long_victory_factions_list = cm:get_saved_value("factions_achieved_long_victory") or {}
			table.add_unique(long_victory_factions_list, variant_key)
			cm:set_saved_value("factions_achieved_long_victory", long_victory_factions_list)

			if _victory_objectives_ie.scripted_rewards[variant_key] and _victory_objectives_ie.scripted_rewards[variant_key].long_victory then
				_victory_objectives_ie.scripted_rewards[variant_key].long_victory(faction_key)
			end
		end,
		true
	)

	
	-- Reinitialize scripted reward listeners which provide ongoing reward effect if victory was already achieved
	local short_victory_factions_list = cm:get_saved_value("factions_achieved_short_victory") or {}
	for _, faction_key in dpairs(short_victory_factions_list) do
		if _victory_objectives_ie.scripted_rewards[faction_key] and 
			_victory_objectives_ie.scripted_rewards[faction_key].short_victory and 
			_victory_objectives_ie.scripted_rewards[faction_key].persistent_scripted_reward and 
			_victory_objectives_ie.scripted_rewards[faction_key].persistent_scripted_reward.short_victory == true then

				_victory_objectives_ie.scripted_rewards[faction_key].short_victory(faction_key)
		end
	end

	local long_victory_factions_list = cm:get_saved_value("factions_achieved_long_victory") or {}
	for _, faction_key in dpairs(long_victory_factions_list) do
		if _victory_objectives_ie.scripted_rewards[faction_key] and 
			_victory_objectives_ie.scripted_rewards[faction_key].long_victory and 
			_victory_objectives_ie.scripted_rewards[faction_key].persistent_scripted_reward and 
			_victory_objectives_ie.scripted_rewards[faction_key].persistent_scripted_reward.long_victory == true then

				_victory_objectives_ie.scripted_rewards[faction_key].long_victory(faction_key)
		end
	end

end

-- In the case of factions with multiple possible lords, the find the faction leader and use their unit subtype as the variant key as they are the one who will be used to determine the victory objectives and rewards
function _victory_objectives_ie:variant_key_getters(faction_obj)

	local faction_leader = faction_obj:faction_leader()
	if not faction_leader:is_null_interface() then
		return faction_leader:character_subtype_key()
	else
		script_error(string.format("ERROR: Could not set up faction victory conditions. Faction '%s' was marked as using its lord as a variant key, but has no valid faction leader character.", faction_obj:name()))
		return nil
	end
end