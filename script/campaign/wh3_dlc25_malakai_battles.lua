--------------------------
-- Data
--------------------------

MISSION_TYPES = {
	UNIT_TYPE_BATTLE = "unit_type_battle",
	OCCUPY_CLIMATE_SETTLEMENT = "occupy_climate_settlement",
	FIGHT_BATTLE_TYPE = "fight_battle_type",
	MAKE_TRADE_AGREEMENT = "make_trade_agreement",
	FIGHT_SPELLCASTERS = "fight_spellcasters",
	RESEARCH_TECH = "research_tech",
	FIGHT_BATTLE_VAMPIRE_CORRUPTION = "fight_battle_vampire_corruption",
	FIGHT_IN_CLIMATE = "fight_in_climate",
	FIGHT_AGAINST_CULTURE = "fight_against_culture",
	DILEMMA_CHAIN = "dilemma_chain",
	FIGHT_SPECIAL_FORCE = "fight_special_force",
	USE_ABILITY = "use_ability"
}

SPAWN_TYPES = {
	CHARACTER = "character",
	REGION = "region"
}

malakai_battles = {
	-- General data
	malakai_faction = "wh3_dlc25_dwf_malakai",
	adventures_available_incident = "wh3_dcl25_dwf_malakai_adventures_panel_unlock",
	adventure_unlocked_incident = "wh3_dlc25_dwf_malakai_adventures_unlocked_adventure_",
	adventure_battle_ready = "wh3_dlc25_dwf_malakai_adventures_adventure_battle_ready_",
	adventure_battle_complete = "wh3_dlc25_dwf_malakai_adventures_adventure_battle_complete_",
	adventure_mission_complete = "wh3_dlc25_dwf_malakai_adventures_mission_complete_",

	-- Mission set data
	mission_set_list = {
		"dragon_hunters",
		"dreadquake_destruction",
		"spider_swarm",
		"undead_empowered",
		"malevolent_tree_spirits",
		"exalted_bloodthirster",
		"warpstone_bomb"
	},

	-- Scripted missions data by mission set
	mission_data = {
		dragon_hunters = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_dragon_hunters_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_dragon_hunters_switch",
			missions_required_to_trigger_battle_mission = 3,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_1",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_4"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_2",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_3",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_5",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_6"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_dragon_hunters_2 = {
					type = MISSION_TYPES.UNIT_TYPE_BATTLE,
					objective_castes = {
						"melee_cavalry",
						"missile_cavalry",
						"monstrous_cavalry"
					},
					objective_save_key = "dragon_hunters_save_mission_2",
					objective_required_amount = 1,
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_dragon_hunters_level_1"
				},
				wh3_dlc25_mis_dwf_malakai_dragon_hunters_3 = {
					type = MISSION_TYPES.FIGHT_IN_CLIMATE,
					objective_required_amount = 2,
					climate_condition_list = {
						"climate_mountain",
					},					
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_exp_gain_cannons",
					objective_save_key = "dragon_hunters_save_mission_3",
				},
				wh3_dlc25_mis_dwf_malakai_dragon_hunters_5 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh2_main_hef_high_elves"
					},
					objective_required_amount = 2,
					objective_save_key = "dragon_hunters_save_mission_5",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_dragon_hunters_level_2",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_dragon_hunters_5",
						marker_info = "wh3_dlc25_malakai_adventures_battle_high_elves",
						marker_count = 4,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_monolith_of_flesh",
								"wh3_main_combi_region_varg_camp",
								"wh3_main_combi_region_the_forbidden_citadel",
								"wh3_main_combi_region_sarl_encampment",
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_frozen_landing",
								"wh3_main_chaos_region_temple_of_heimkel",
								"wh3_main_chaos_region_sjoktraken",
								"wh3_main_chaos_region_dharko_wharf"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				},
				wh3_dlc25_mis_dwf_malakai_dragon_hunters_6 = {
					type = MISSION_TYPES.DILEMMA_CHAIN,
					dilemma_start_key = "wh3_dlc25_dwf_dilemma_malakai_dwarf_refugees_1",
					dilemma_completion_key = {
						"wh3_dlc25_dwf_dilemma_malakai_dwarf_refugees_2a",
						"wh3_dlc25_dwf_dilemma_malakai_dwarf_refugees_2b"
					},
					treasury_payload = 2500,
					pooled_resource_payload = {
						key = "dwf_oathgold",
						factor = "missions",
						amount = 100
					},
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_dragon_hunters_6",
						marker_info = "wh3_dlc25_malakai_adventures_dilemma_dwarf_refugees",
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_kraka_drak"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_kraka_drak"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
						marker_count = 1,
						dilemma_key = "wh3_dlc25_dwf_dilemma_malakai_dwarf_refugees_1"
					},
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_dragon_hunters_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_dragon_hunters_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_1",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_2",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_3",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_4",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_5",
				"wh3_dlc25_mis_dwf_malakai_dragon_hunters_6"
			},
		},
		dreadquake_destruction = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_dreadquake_destruction_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_dreadquake_destruction_switch",
			missions_required_to_trigger_battle_mission = 3,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_1",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_6"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_2",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_3",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_4",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_5"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_2 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "dreadquake_destruction_save_mission_2",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_gyrocopters_2",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_2",
						spawn_list = {
							"dreadquake_destruction_save_mission_2_caravan",
						},
						dreadquake_destruction_save_mission_2_caravan = {
							force_size = 14,
							patrol_route = {
								main_warhammer = {{x = 571, y = 516}, {x = 531, y = 510}},
								wh3_main_chaos = {{x = 345, y = 141}, {x = 395, y = 112}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_great_skull_lakes",
								wh3_main_chaos = "wh3_main_chaos_region_plesk"
							},
							template_key = "chaos_dwarf_caravan_force",
							faction_key = "wh3_dlc25_chd_chaos_dwarfs_invasion",
							general_subtype = "wh3_dlc23_chd_overseer",
							general_level = 8,
							general_name = "115739290",
							general_surname = "1311842532"
						}
					}
				},
				wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_3 = {
					type = MISSION_TYPES.FIGHT_IN_CLIMATE,
					objective_save_key = "dreadquake_destruction_save_mission_3",
					objective_required_amount = 3,
					climate_condition_list = {
						"climate_wasteland",
					},
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_exp_gain_gyrocopters",
				},
				wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_4 = {
					type = MISSION_TYPES.MAKE_TRADE_AGREEMENT,
					valid_cultures = {
						"wh3_main_cth_cathay",
						"wh3_main_ksl_kislev"
					},
					treasury_payload = 2500,
					pooled_resource_payload = {
						key = "dwf_oathgold",
						factor = "missions",
						amount = 100
					}
				},
				wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_5 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh3_dlc23_chd_chaos_dwarfs"
					},
					objective_required_amount = 5,
					objective_save_key = "dreadquake_destruction_save_mission_5",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_dreadquake_destruction_level_5",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_5",
						marker_info = "wh3_dlc25_malakai_adventures_battle_chaos_dwarfs",
						marker_count = 5,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_the_gates_of_zharr",
								"wh3_main_combi_region_great_skull_lakes",
								"wh3_main_combi_region_the_falls_of_doom",
								"wh3_main_combi_region_black_fortress",
								"wh3_main_combi_region_tower_of_gorgoth"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_uzkulany",
								"wh3_dlc23_chaos_region_gash_kadrak",
								"wh3_main_chaos_region_the_gates_of_zharr",
								"wh3_main_chaos_region_the_tower_of_gorgoth",
								"wh3_main_chaos_region_black_fortress"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_1",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_2",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_3",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_4",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_5",
				"wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_6"
			},			
		},
		spider_swarm = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_spider_swarm_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_spider_swarm_switch",
			missions_required_to_trigger_battle_mission = 4,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_1",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_6"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_2",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_3",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_4",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_5",
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_spider_swarm_2 = {
					type = MISSION_TYPES.UNIT_TYPE_BATTLE,
					objective_castes = {
						"monster",
						"monstrous_infantry",
						"war_beast"
					},
					objective_save_key = "spider_swarm_save_mission_2",
					objective_required_amount = 2,
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_goblin_hewers_2"
				},
				wh3_dlc25_mis_dwf_malakai_spider_swarm_3 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh_main_grn_greenskins"
					},
					objective_required_amount = 4,
					objective_save_key = "spider_swarm_save_mission_3",
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_armour_sundering_goblin_hewer_war",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_spider_swarm_3",
						marker_info = "wh3_dlc25_malakai_adventures_battle_greenskins",
						marker_count = 5,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_black_crag",
								"wh3_main_combi_region_valayas_sorrow",
								"wh3_main_combi_region_bitterstone_mine",
								"wh3_main_combi_region_ekrund",
								"wh3_main_combi_region_stonemine_tower"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_mount_gunbad",
								"wh3_main_chaos_region_gnashraks_lair",
								"wh3_main_chaos_region_karak_raziak",
								"wh3_main_chaos_region_khazid_irkulaz",
								"wh3_main_chaos_region_karak_ungor"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				},
				wh3_dlc25_mis_dwf_malakai_spider_swarm_4 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "spider_swarm_save_mission_4",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_goblin_hewers_4",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_spider_swarm_4",
						spawn_list = {
							"malakai_adventures_spider_swarm_battle",
						},
						malakai_adventures_spider_swarm_battle = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 468, y = 418}, {x = 462, y = 367}},
								wh3_main_chaos = {{x = 498, y = 96}, {x = 456, y = 92}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_forest_of_gloom",
								wh3_main_chaos = "wh3_main_chaos_region_howling_rock"
							},
							template_key = "greenskin_spider_swarm_force",
							faction_key = "wh2_dlc13_grn_greenskins_invasion",
							general_subtype = "wh_dlc06_grn_night_goblin_warboss",
							general_level = 12,
							general_name = "2147344501",
							general_surname = "1717840943"
						}
					}
				},
				wh3_dlc25_mis_dwf_malakai_spider_swarm_5 = {
					type = MISSION_TYPES.FIGHT_IN_CLIMATE,
					objective_save_key = "wh3_dlc25_mis_dwf_malakai_spider_swarm_5",
					objective_required_amount = 5,
					climate_condition_list = {
						"climate_wasteland",
						"climate_mountain"
					},
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_exp_gain_goblin_hewers",
				},
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_spider_swarm_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_spider_swarm_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_1",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_2",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_3",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_4",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_5",
				"wh3_dlc25_mis_dwf_malakai_spider_swarm_6"
			},
		},
		undead_empowered = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_undead_empowered_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_undead_empowered_switch",
			missions_required_to_trigger_battle_mission = 4,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_1",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_6"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_2",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_3",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_4",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_5"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_undead_empowered_2 = {
					type = MISSION_TYPES.FIGHT_SPELLCASTERS,
					objective_save_key = "undead_empowered_save_mission_2",
					objective_required_amount = 1,
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_gyrobombers_2"
				},
				wh3_dlc25_mis_dwf_malakai_undead_empowered_3 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh_main_vmp_vampire_counts",
						"wh2_dlc11_cst_vampire_coast",
						"wh2_dlc09_tmb_tomb_kings",
					},
					objective_required_amount = 5,
					objective_save_key = "undead_empowered_save_mission_3",
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_exp_gain_gyrobombers",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_undead_empowered_3",
						marker_info = "wh3_dlc25_malakai_adventures_battle_vampire_counts",
						marker_count = 5,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_castle_drakenhof",
								"wh3_main_combi_region_swartzhafen",
								"wh3_main_combi_region_the_moot",
								"wh3_main_combi_region_castle_templehof",
								"wh3_main_combi_region_fort_oberstyre"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_castle_drakenhof",
								"wh3_main_chaos_region_konigstein_tower",
								"wh3_main_chaos_region_waldenhof",
								"wh3_main_chaos_region_kusel",
								"wh3_main_chaos_region_bechafen"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				},
				wh3_dlc25_mis_dwf_malakai_undead_empowered_4 = {
					type = MISSION_TYPES.FIGHT_BATTLE_VAMPIRE_CORRUPTION,
					corruption_pr_key = "wh3_main_corruption_vampiric",
					objective_save_key = "undead_empowered_save_mission_4",
					objective_required_amount = 4,
					objective_condition_amount = 50,
					treasury_payload = 5000,
					pooled_resource_payload = {
						key = "dwf_oathgold",
						factor = "missions",
						amount = 100
					}
				},
				wh3_dlc25_mis_dwf_malakai_undead_empowered_5 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "undead_empowered_save_mission_5",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_gyrobombers_5",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_undead_empowered_5",
						spawn_list = {
							"malakai_adventures_undead_crisis_army_1",
							"malakai_adventures_undead_crisis_army_2",
						},
						malakai_adventures_undead_crisis_army_1 = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 475, y = 512}, {x = 427, y = 539}},
								wh3_main_chaos = {{x = 259, y = 22}, {x = 228, y = 36}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_essen",
								wh3_main_chaos = "wh3_main_chaos_region_wurtbad"
							},
							template_key = "wh_main_sc_vmp_vampire_counts",
							faction_key = "wh3_dlc25_vmp_vampire_counts_invasion",
							general_subtype = "wh_main_vmp_master_necromancer",
							general_level = 15,
							general_name = "2147345109",
							general_surname = "1593337280"
						},
						malakai_adventures_undead_crisis_army_2 = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 434, y = 486}, {x = 400, y = 475}},
								wh3_main_chaos = {{x = 279, y = 70}, {x = 235, y = 79}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_niedling",
								wh3_main_chaos = "wh3_main_chaos_region_bechafen"
							},
							template_key = "vmp_ghoul_horde",
							faction_key = "wh3_dlc25_vmp_vampire_counts_invasion",
							general_subtype = "wh_dlc04_vmp_strigoi_ghoul_king",
							general_level = 15,
							general_name = "2147345862",
							general_surname = "1139217754"
						},
					}
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_undead_empowered_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_undead_empowered_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_1",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_2",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_3",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_4",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_5",
				"wh3_dlc25_mis_dwf_malakai_undead_empowered_6"
			},
		},
		malevolent_tree_spirits = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_malevolent_tree_spirits_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_malevolent_tree_spirits_switch",
			missions_required_to_trigger_battle_mission = 4,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_1",
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_2",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_3",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_4",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_5",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_6"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_2 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh_dlc05_wef_wood_elves"
					},
					objective_required_amount = 3,
					objective_save_key = "malevolent_tree_spirits_save_mission_2",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_flame_cannon_2",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_2",
						marker_info = "wh3_dlc25_malakai_adventures_battle_wood_elves",
						marker_count = 3,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_weismund",
								"wh3_main_combi_region_kemperbad",
								"wh3_main_combi_region_talabheim"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_salzenmund",
								"wh3_main_chaos_region_middenheim",
								"wh3_main_chaos_region_delberz"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				},
				wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_3 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "malevolent_tree_spirits_save_mission_3",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_flame_cannon_3",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_3",
						spawn_list = {
							"malakai_adventures_malevolent_tree_spirits_battle",
						},
						malakai_adventures_malevolent_tree_spirits_battle = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 359, y = 540}, {x = 424, y = 536}},
								wh3_main_chaos = {{x = 94, y = 82}, {x = 140, y = 41}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_middenheim",
								wh3_main_chaos = "wh3_main_chaos_region_rosche"
							},
							template_key = "wood_elves_malevolent_trees_and_elves",
							faction_key = "wh3_dlc25_wef_wood_elves_invasion",
							general_subtype = "wh2_dlc16_wef_malicious_ancient_treeman_life",
							general_level = 20,
							general_name = "2147359044"
						},
					}
				},
				wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_4 = {
					type = MISSION_TYPES.MAKE_TRADE_AGREEMENT,
					valid_cultures = {
						"wh3_main_ksl_kislev",
						"wh_main_emp_empire"
					},
					treasury_payload = 5000,
					pooled_resource_payload = {
						key = "dwf_oathgold",
						factor = "missions",
						amount = 100
					}
				},
				wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_5 = {
					type = MISSION_TYPES.UNIT_TYPE_BATTLE,
					objective_castes = {
						"monster",
						"monstrous_infantry",
						"war_beast"
					},
					objective_save_key = "malevolent_tree_spirits_save_mission_5",
					objective_required_amount = 5,
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_flame_cannon_5"
				},
				wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_6 = {
					type = MISSION_TYPES.DILEMMA_CHAIN,
					dilemma_start_key = "wh3_dlc25_dwf_dilemma_malakai_manling_priorities_1",
					dilemma_completion_key = {
						"wh3_dlc25_dwf_dilemma_malakai_manling_priorities_2a",
						"wh3_dlc25_dwf_dilemma_malakai_manling_priorities_2b"
					},
					treasury_payload = 5000,
					pooled_resource_payload = {
						key = "dwf_oathgold",
						factor = "missions",
						amount = 200
					},
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_6",
						marker_info = "wh3_dlc25_malakai_adventures_dilemma_manling_priorities",
						spawn_type = SPAWN_TYPES.REGION,
						marker_count = 1,
						dilemma_key = "wh3_dlc25_dwf_dilemma_malakai_manling_priorities_1",
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_norden"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_norden"
							}
						},
					},
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_1",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_2",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_3",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_4",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_5",
				"wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_6"
			},
		},
		exalted_bloodthirster = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_exalted_bloodthirst_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_exalted_bloodthirst_switch",
			missions_required_to_trigger_battle_mission = 4,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_1",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_3",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_4"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_2",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_5",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_6"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_2 = {
					type = MISSION_TYPES.FIGHT_IN_CLIMATE,
					objective_save_key = "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_2",
					objective_required_amount = 5,
					climate_condition_list = {
						"climate_chaotic"
					},
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_exp_gain_organ_guns",
				},
				wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_5 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "exalted_bloodthirster_save_mission_5",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_organ_guns_5",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_5",
						spawn_list = {
							"malakai_adventures_exalted_bloodthirster_nurgle_champion",
							"malakai_adventures_exalted_bloodthirster_tzeentch_champion",
							"malakai_adventures_exalted_bloodthirster_slaanesh_champion",
						},
						malakai_adventures_exalted_bloodthirster_nurgle_champion = {
							force_size = 17,
							patrol_route = {
								main_warhammer = {{x = 438, y = 726}, {x = 457, y = 701}},
								wh3_main_chaos = {{x = 346, y = 273}, {x = 312, y = 268}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_the_forest_of_decay",
								wh3_main_chaos = "wh3_main_chaos_region_pillar_of_skulls"
							},
							template_key = "wh3_main_sc_nur_nurgle",
							faction_key = "wh3_dlc25_nur_nurgle_invasion",
							general_subtype = "wh3_main_nur_herald_of_nurgle_nurgle",
							general_level = 22,
							general_name = "1410519463",
							general_surname = "143579279"
						},
						malakai_adventures_exalted_bloodthirster_tzeentch_champion = {
							force_size = 17,
							patrol_route = {
								main_warhammer = {{x = 490, y = 713}, {x = 451, y = 724}},
								wh3_main_chaos = {{x = 404, y = 311}, {x = 435, y = 347}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_the_crystal_spires",
								wh3_main_chaos = "wh3_main_chaos_region_the_gallows_tree"
							},
							template_key = "wh3_main_sc_tze_tzeentch",
							faction_key = "wh3_main_tze_tzeentch_invasion",
							general_subtype = "wh3_main_tze_exalted_lord_of_change_tzeentch",
							general_level = 22,
							general_name = "661244876",
							general_surname = "1554253262"
						},
						malakai_adventures_exalted_bloodthirster_slaanesh_champion = {
							force_size = 17,
							patrol_route = {
								main_warhammer = {{x = 534, y = 629}, {x = 597, y = 661}},
								wh3_main_chaos = {{x = 327, y = 360}, {x = 277, y = 367}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_stormvrack_mount",
								wh3_main_chaos = "wh3_main_chaos_region_chimera_plateau"
							},
							template_key = "wh3_main_sc_sla_slaanesh",
							faction_key = "wh3_dlc25_sla_slaanesh_invasion",
							general_subtype = "wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
							general_level = 22,
							general_name = "1599101598",
							general_surname = "1468677416"
						},
					}
				},
				wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_6 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "exalted_bloodthirster_save_mission_6",
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_reload_organ_guns",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_6",
						spawn_list = {
							"malakai_adventures_exalted_bloodthirster_khorne_champion",
						},
						malakai_adventures_exalted_bloodthirster_khorne_champion = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 566, y = 681}, {x = 516, y = 699}},
								wh3_main_chaos = {{x = 292, y = 310}, {x = 252, y = 287}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_the_burning_monolith",
								wh3_main_chaos = "wh3_main_chaos_region_blood_haven"
							},
							template_key = "wh3_main_sc_kho_khorne",
							faction_key = "wh3_dlc25_kho_khorne_invasion",
							general_subtype = "wh3_main_kho_herald_of_khorne",
							general_level = 25,
							general_name = "428437392",
							general_surname = "2122905319"
						},
					}
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_1",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_2",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_3",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_4",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_5",
				"wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_6"
			},
		},
		warpstone_bomb = {
			is_mission_set_active = false,
			activate_ritual = "wh3_dlc25_malakai_feature_warpstone_bomb_activate",
			switch_ritual = "wh3_dlc25_malakai_feature_warpstone_bomb_switch",
			missions_required_to_trigger_battle_mission = 4,
			non_scripted_missions = {
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_1",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_5"
			},

			-- scripted mission data
			scripted_missions_list = {
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_2",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_3",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_4",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_6"
			},
			missions = {
				wh3_dlc25_mis_dwf_malakai_warpstone_bomb_2 = {
					type = MISSION_TYPES.DILEMMA_CHAIN,
					dilemma_start_key = "wh3_dlc25_dwf_dilemma_malakai_caravan_detoured_1",
					dilemma_completion_key = {
						"wh3_dlc25_dwf_dilemma_malakai_caravan_detoured_2a",
						"wh3_dlc25_dwf_dilemma_malakai_caravan_detoured_2b"
					},
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_thunderbarge_2",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_2",
						marker_info = "wh3_dlc25_malakai_adventures_dilemma_caravan_detoured",
						spawn_type = SPAWN_TYPES.REGION,
						marker_count = 1,
						dilemma_key = "wh3_dlc25_dwf_dilemma_malakai_caravan_detoured_1",
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_black_iron_mine"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_karak_kadrin"
							}
						},
					},
				},
				wh3_dlc25_mis_dwf_malakai_warpstone_bomb_3 = {
					type = MISSION_TYPES.FIGHT_AGAINST_CULTURE,
					objective_cultures = {
						"wh2_main_skv_skaven"
					},
					objective_required_amount = 5,
					objective_save_key = "warpstone_bomb_save_mission_3",
					effect_bundle_payload = "wh3_dlc25_dwf_upgrade_missile_resist_thunderbarge_veh",
					-- Marker data
					marker_data = {
						key = "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_3",
						marker_info = "wh3_dlc25_malakai_adventures_battle_skaven",
						marker_count = 5,
						region_area = {
							main_warhammer = {
								"wh3_main_combi_region_valayas_sorrow",
								"wh3_main_combi_region_iron_rock",
								"wh3_main_combi_region_black_crag",
								"wh3_main_combi_region_karak_eight_peaks",
								"wh3_main_combi_region_dringorackaz"
							},
							wh3_main_chaos = {
								"wh3_main_chaos_region_volksgrad",
								"wh3_main_chaos_region_gerslev",
								"wh3_main_chaos_region_fort_jakova",
								"wh3_main_chaos_region_praag",
								"wh3_main_chaos_region_bolgasgrad"
							}
						},
						spawn_type = SPAWN_TYPES.REGION,
					},
				},
				wh3_dlc25_mis_dwf_malakai_warpstone_bomb_4 = {
					type = MISSION_TYPES.FIGHT_SPECIAL_FORCE,
					objective_save_key = "ewarpstone_bomb_save_mission_4",
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_thunderbarge_4",
					-- Spawn force data
					spawn_force_data = {
						script_key = "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_4",
						spawn_list = {
							"malakai_adventures_warpstone_bomb_skaven_leader",
						},
						malakai_adventures_warpstone_bomb_skaven_leader = {
							force_size = 19,
							patrol_route = {
								main_warhammer = {{x = 519, y = 300}, {x = 505, y = 315}},
								wh3_main_chaos = {{x = 438, y = 134}, {x = 405, y = 176}},
							},
							region_key = {
								main_warhammer = "wh3_main_combi_region_misty_mountain",
								wh3_main_chaos = "wh3_main_chaos_region_seep_gore"
							},
							template_key = "wh2_main_sc_skv_skaven",
							faction_key = "wh2_dlc13_skv_skaven_invasion",
							general_subtype = "wh2_dlc12_skv_warlock_master",
							general_level = 30,
							general_name = "1621301403",
							general_surname = "1276401969",
						},
					}
				},
				wh3_dlc25_mis_dwf_malakai_warpstone_bomb_6 = {
					type = MISSION_TYPES.USE_ABILITY,
					objective_save_key = "ewarpstone_bomb_save_mission_6",
					objective_required_amount = 5,
					effect_bundle_payload = "wh3_dlc25_reward_dwf_malakai_thunderbarge_6",
					ability_key = "wh3_dlc25_army_abilities_spirit_of_grungni"
				}
			},

			-- narrative mission data
			missions_completed_count = 0,
			narrative_battle_mission_key = {
				wh3_main_chaos = "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle",
				main_warhammer = "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle_ie"
			},
			missions_required_to_unlock_battle_mission = {
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_1",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_2",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_3",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_4",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_5",
				"wh3_dlc25_mis_dwf_malakai_warpstone_bomb_6"
			}
		}
	},

	-- Narrative Mission data
	mission_issuer = "CLAN_ELDERS",

	-- Ritual activation and switching data
	currently_activated_adventure = "",
	activated_adventures = {},
	completed_missions = {
		dragon_hunters = {},
		dreadquake_destruction = {},
		spider_swarm = {},
		undead_empowered = {},
		malevolent_tree_spirits = {},
		exalted_bloodthirster = {},
		warpstone_bomb = {}
	},
	ritual_lookup = {},

	-- Spawned marker data
	battle_power_modifier = 1,						-- Modfier for calculating composition of spawned armies. Will update as campaign goes on.

	invasion_effect_bundles = {
		no_upkeep = "wh_main_bundle_military_upkeep_free_force",
		region_attrition_immune = "wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",
		immobile = "wh2_dlc17_effect_campaign_movement_immobile"
	},

	-- Spawned marker battle setup functions
	marker_battle_setup_functions = {
		dragon_hunters = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh2_main_hef_high_elves_qb1",
					"hef_high_elf_patrol",
					forced_battle_key_override,
					false,
					nil,
					"wh2_main_hef_prince"
				)
			end
		},
		dreadquake_destruction = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh3_dlc23_chd_chaos_dwarfs_qb1",
					"wh3_dlc23_sc_chd_chaos_dwarfs",
					forced_battle_key_override,
					false,
					nil,
					"wh3_dlc23_chd_overseer"
				)
			end
		},
		spider_swarm = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh_main_grn_greenskins_qb1",
					"wh_main_sc_grn_greenskins",
					forced_battle_key_override,
					false,
					nil,
					"wh_main_grn_goblin_great_shaman"
				)
			end
		},
		undead_empowered = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh_main_vmp_vampire_counts_qb1",
					"wh_main_sc_vmp_vampire_counts",
					forced_battle_key_override,
					false,
					nil,
					"wh_main_vmp_master_necromancer"
				)
			end
		},
		malevolent_tree_spirits = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh_dlc05_wef_wood_elves_qb1",
					"wef_malevolent_spirits",
					forced_battle_key_override,
					false,
					nil,
					"wh2_dlc16_wef_malicious_ancient_treeman_beasts"
				)
			end
		},
		warpstone_bomb = {
			on_battle_trigger_callback = function(self, character, forced_battle_key_override)
				malakai_battles:set_up_generic_encounter_forced_battle(
					character,
					"wh2_main_skv_skaven_qb1",
					"wh2_main_sc_skv_skaven",
					forced_battle_key_override,
					false,
					nil,
					"wh2_dlc12_skv_warlock_master"
				)
			end
		}
	},

	-- AI rewards by turn they should be granted
	ai_rewards_by_turn = {
		[10] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_dragon_hunters_final_reward",
				"wh3_dlc25_dwf_upgrade_grapeshot_cannons",
			},
			ancillary = "wh3_dlc25_anc_banner_dragon_hide_cloaks",
		},
		[20] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_dreadquake_destruction_final_reward",
				"wh3_dlc25_dwf_upgrade_missile_block_gyrocopters",
			},
			ancillary = "wh3_dlc25_anc_weapon_glaive_gun",
		},
		[30] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_spider_swarm_final_reward",
			},
			ancillary = "wh3_dlc25_anc_banner_arachnarok_trophy",
		},
		[40] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_undead_empowered_final_reward",
				"wh3_dlc25_dwf_upgrade_fire_bombs_gyrobomber_veh",
				"wh3_dlc25_reward_dwf_malakai_gyrobombers_5"
			},
			ancillary = "wh3_dlc25_anc_talisman_crimson_gemstone",
		},
		[50] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_malevolent_tree_spirits_final_reward",
				"wh3_dlc25_reward_dwf_malakai_flame_cannon_1",
			},
			ancillary = "wh3_dlc25_anc_enchanted_item_heart_of_malevolence",
		},
		[60] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_exalted_bloodthirster_final_reward",
				"wh3_dlc25_dwf_upgrade_dig_in_organ_guns",
			},
			ancillary = "wh3_dlc25_anc_banner_rune_of_the_furnace",
		},
		[70] = {
			effect_bundles = {
				"wh3_dlc25_reward_dwf_malakai_warpstone_bomb_final_reward",
				"wh3_dlc25_reward_dwf_malakai_thunderbarge_1",
			},
			ancillary = "wh3_dlc25_anc_rune_personal_rune_of_thungni",
		},
	}
}


--------------------------
-- Handlers
--------------------------

function malakai_battles:initialize()
	local faction_interface = cm:get_faction(self.malakai_faction)
	if faction_interface ~= false then
		if faction_interface:is_human() then
			self:setup_ritual_lookup_table()
			self:setup_ritual_blocker_listeners()
			self:victory_condition_listener()
			self:setup_marker_listeners()
			self:setup_incident_listeners()

			for i = 1, #self.mission_set_list do
				local mission_set_key = self.mission_set_list[i]
				if self.mission_data[mission_set_key].is_mission_set_active then
					self:setup_narrative_battle_listeners(mission_set_key)
					self:trigger_scripted_missions(mission_set_key)
				end
			end
		elseif not faction_interface:is_human() and cm:turn_number() <= 70 then
			self:handle_ai_unlocking()
		end
	end

	if cm:is_new_game() then
		-- Highlight pulse the adventures panel button when 1st unlocked
		core:add_listener(
			"highlight_adventure_panel_button_unlocked",
			"FactionTurnStart", 
			function(context)
				return context:faction():name() == self.malakai_faction and cm:turn_number() == 5
			end,
			function()
				highlight_component(true, false, "resources_bar_holder", "dwf_malakai_adventures", "mission_progression")
			end, 
			false
		)

		core:add_listener(
			"unhighlight_adventure_panel_button_unlocked",
			"PanelOpenedCampaign", 
			function(context) return context.string == "dlc25_malakai_oaths" end,
			function()
				core:remove_listener("unhighlight_adventure_panel_button_next_turn")
				highlight_component(false, false, "resources_bar", "dwf_malakai_adventures", "mission_progression")
			end, 
			false
		)

		-- Adding backup unhhighlight if player doesnt open panel
		core:add_listener(
			"unhighlight_adventure_panel_button_next_turn",
			"FactionTurnEnd", 
			function(context)
				return context:faction():name() == self.malakai_faction and cm:turn_number() == 5
			end,
			function()
				core:remove_listener("unhighlight_adventure_panel_button_unlocked")
				highlight_component(false, false, "resources_bar_holder", "dwf_malakai_adventures", "mission_progression")
			end, 
			false
		)
	end
end


function malakai_battles:mission_trigger_handler(mission_set_key)
	self:setup_narrative_battle_listeners(mission_set_key)
	self:trigger_scripted_missions(mission_set_key, true)
	self:trigger_non_scripted_missions(mission_set_key)
	self.mission_data[mission_set_key].is_mission_set_active = true

	cm:trigger_incident(self.malakai_faction, self.adventure_unlocked_incident..mission_set_key, true, true)
end


function malakai_battles:trigger_scripted_missions(mission_set_to_trigger, should_trigger)
	should_trigger = should_trigger or false
	local set_data = self.mission_data[mission_set_to_trigger]

	for i = 1, #set_data.scripted_missions_list do
		local mission_key = set_data.scripted_missions_list[i]
		if not self:is_key_in_list(mission_key, self.completed_missions[mission_set_to_trigger]) then
			local mission = set_data.missions[mission_key]
			if mission.type == MISSION_TYPES.UNIT_TYPE_BATTLE then
				self:setup_fight_against_unit_type_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.OCCUPY_CLIMATE_SETTLEMENT then
				self:setup_occupy_settlement_in_climate_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_BATTLE_TYPE then
				self:setup_fight_ambush_battle_type_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.MAKE_TRADE_AGREEMENT then
				self:setup_form_trade_agreement_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_SPELLCASTERS then
				self:setup_fight_against_spellcasters_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.RESEARCH_TECH then
				self:setup_research_technology_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_BATTLE_VAMPIRE_CORRUPTION then
				self:setup_fight_battle_in_vampire_corruption_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_IN_CLIMATE then
				self:setup_fight_battles_in_climate_mission(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_AGAINST_CULTURE then
				self:setup_fight_battles_against_culture(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.DILEMMA_CHAIN then
				self:setup_complete_dilemma_chain(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.FIGHT_SPECIAL_FORCE then
				self:setup_fight_special_force(mission, mission_key, should_trigger)
			elseif mission.type == MISSION_TYPES.USE_ABILITY then
				self:setup_use_ability(mission, mission_key, should_trigger)
			end
		end
	end
end


function malakai_battles:trigger_non_scripted_missions(mission_set_key)
	local set_data = self.mission_data[mission_set_key].non_scripted_missions
	for i = 1, #set_data do
		if not self:is_key_in_list(set_data[i], self.completed_missions[mission_set_key]) then
			cm:trigger_mission(self.malakai_faction, set_data[i], true)
		end
	end
end


-------------------------
-- Listeners
-------------------------

function malakai_battles:setup_ritual_blocker_listeners()
	self:setup_ritual_locks()

	core:add_listener(
		"oaths_unlocking_set_by_building_completion",
		"RitualCompletedEvent",
		function(context)
			return self.ritual_lookup[context:ritual():ritual_key()]
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local mission_set = self:get_mission_set_from_ritual(ritual_key)
			local activate_ritual = self.mission_data[mission_set].activate_ritual
			local ritual_list = {
				["activate_ritual"] = activate_ritual,
				["switch_ritual"] = self.mission_data[mission_set].switch_ritual
			}

			self:ritual_switch_to_new_adventure(ritual_list)
			if activate_ritual == ritual_key then
				self:mission_trigger_handler(self:get_mission_set_from_ritual(ritual_key))
			end
			self.currently_activated_adventure = mission_set
		end,
		true
	)

	core:add_listener(
		"adventure_sets_mission_completed_listener",
		"MissionSucceeded",
		function(context)
			local mission_data = self.mission_data[self.currently_activated_adventure]
			if mission_data ~= nil then
				return self:is_key_in_list(context:mission():mission_record_key(), mission_data.missions_required_to_unlock_battle_mission)
			end
			return false
		end,
		function(context)
			local completed_missions = self.completed_missions
			table.insert(completed_missions[self.currently_activated_adventure], context:mission():mission_record_key())
		end,
		true
	)
end


-- This listener listens for the completion of all the required missions and once true will trigger the final battle missions for the set
function malakai_battles:setup_narrative_battle_listeners(mission_set)
	local set_data = self.mission_data[mission_set]
	core:add_listener(
		"final_battle_unlock_listener_" .. mission_set,
		"MissionSucceeded",
		function(context)
			if set_data.adventure_battle_completed ~= true then
				if self:is_key_in_list(context:mission():mission_record_key(), set_data.missions_required_to_unlock_battle_mission) then
					set_data.missions_completed_count = set_data.missions_completed_count + 1
					if set_data.missions_completed_count >= set_data.missions_required_to_trigger_battle_mission then
						return true
					end
				end
			end
		end,
		function(context)
			-- trigger narrative battle mission
			local campaign_name = cm:get_campaign_name()
			if not cm:mission_is_active_for_faction(context:faction(), context:mission():mission_record_key()) then
				cm:trigger_mission(self.malakai_faction, set_data.narrative_battle_mission_key[campaign_name], true)
				cm:trigger_incident(self.malakai_faction, self.adventure_battle_ready..mission_set, true, true)
			end
		end,
		false
	)

	core:add_listener(
		"final_battle_complete_listener_" .. mission_set,
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == set_data.narrative_battle_mission_key[cm:get_campaign_name()]
		end,
		function()
			set_data.adventure_battle_completed = true
			out.design(self.adventure_battle_complete..mission_set)
			cm:trigger_incident(self.malakai_faction, self.adventure_battle_complete..mission_set, true, true)
		end,
		true
	)
end

function malakai_battles:victory_condition_listener()
	--- Malakai Oaths of Iron and Glory victory conditions
	local campaign_name = cm:get_campaign_name()
	if campaign_name == "main_warhammer" then
		core:add_listener(
			"IEVictoryConditionShortVictoryMalakaiIronSteelBattles",
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				return context:faction():name() == self.malakai_faction and (mission_key == "wh3_dlc25_mis_dwf_malakai_undead_empowered_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_spider_swarm_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_dragon_hunters_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_narrative_battle_ie" or mission_key == "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle_ie")			
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_short_victory", "oath_iron_glory_short_victory", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "oath_iron_glory_long_victory", 1)
			end,
			true
		)
	elseif campaign_name == "wh3_main_chaos" then 
		core:add_listener(
			"ROCVictoryConditionShortVictoryMalakaiIronSteelBattles",
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				return context:faction():name() == self.malakai_faction and (mission_key == "wh3_dlc25_mis_dwf_malakai_undead_empowered_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_spider_swarm_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_dragon_hunters_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_dreadquake_destruction_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_exalted_bloodthirster_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_malevolent_tree_spirits_narrative_battle" or mission_key == "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle")			
			end,
			function()
				cm:increase_scripted_mission_count("wh_main_long_victory", "malakai_oath_steel_glory_realms_victory", 1)
			end,
			true
		)
	end
end


function malakai_battles:setup_incident_listeners()
	self:setup_missions_list()

	-- Panel unlocking
	core:add_listener(
		"malakai_adventures_tab_available",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.malakai_faction and cm:turn_number() == 5
		end,
		function(context)
			cm:trigger_incident(self.malakai_faction, self.adventures_available_incident, true, true)
		end,
		false
	)

	-- Adventure mission completing incidents
	core:add_listener(
		"malakai_adventures_mission_completed",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == self.malakai_faction and self:is_key_in_list(context:mission():mission_record_key(), self.campaign_missions_list)
		end,
		function(context)
			local adventure_set = self:get_adventure_set_from_mission_key(context:mission():mission_record_key())
			if adventure_set ~= false then
				cm:trigger_incident(self.malakai_faction, self.adventure_mission_complete..adventure_set, true, true)
			end
		end,
		true
	)
end


----------------------------
-- Mission setups
----------------------------


function malakai_battles:setup_fight_against_unit_type_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_unit_type_battle_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"CharacterCompletedBattle",
		function(context)
			-- Check if there are the requisit units in the enemy army and if so complete the mission if done the required amount of times
			local pb = cm:model():pending_battle()

			local _, _, defender_faction_name = cm:pending_battle_cache_get_defender(1)
			local _, _, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
			local matching_unit_count = 0
			local malakai_opponent_units = {}

			if defender_faction_name == self.malakai_faction then
				malakai_opponent_units = cm:pending_battle_cache_get_attacker_units(1)
			elseif attacker_faction_name == self.malakai_faction then
				malakai_opponent_units = cm:pending_battle_cache_get_defender_units(1)
			else
				-- neither faction is malakai so we don't do anything
				return false
			end

			local model = cm:model()
			if malakai_opponent_units ~= nil then
				for i = 0, #malakai_opponent_units do
					local opponent_unit = malakai_opponent_units[i]
					if opponent_unit ~= nil then
						for j = 1, #mission_setup_data.objective_castes do
							if model:unit_caste(opponent_unit.unit_key) == mission_setup_data.objective_castes[j] then
								matching_unit_count = matching_unit_count + 1
							end
						end
					end
				end
			end

			if matching_unit_count > 0 then
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_occupy_settlement_in_climate_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_occupy_settlement_climate_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			-- Check if settlement decision occures in climate that matches the condition
			local character_faction = context:character():faction():name()
			if character_faction == self.malakai_faction and context:garrison_residence():settlement_interface():get_climate() == mission_setup_data.climate_condition_list then
				return true
			end
			return false
		end
	)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_fight_ambush_battle_type_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_ambush_battle_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"BattleCompleted",
		function(context)
			-- Check if battle type is the required one and done it required amount of times
			if cm:pending_battle_cache_faction_won_battle(self.malakai_faction) and cm:model():pending_battle():ambush_battle() then
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_form_trade_agreement_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_form_trade_agreement_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"PositiveDiplomaticEvent",
		function(context)
			-- Check right dip agreement has been made with a faction from the specified cultures
			local proposer = context:proposer()
			local recipient = context:recipient()
			local proposer_is_malakai = proposer:name() == self.malakai_faction
			local recipient_is_malakai = recipient:name() == self.malakai_faction
			if (proposer_is_malakai or recipient_is_malakai) and context:is_trade_agreement() then
				local opposing_faction = ""
				if proposer_is_malakai then
					opposing_faction = recipient
				elseif recipient_is_malakai then
					opposing_faction = proposer
				end

				for i = 1, # mission_setup_data.valid_cultures do
					if self:is_key_in_list(opposing_faction:culture(), mission_setup_data.valid_cultures[i]) then
						return true
					end
				end
			end
			return false
		end
	)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_fight_against_spellcasters_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_spellcasters_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key .. mission_key,
		"CharacterCompletedBattle",
		function(context)
			-- Check if spellcasters are in enemy army and fought required number of times
			local pb = cm:model():pending_battle()
					
			local _, _, defender_faction_name = cm:pending_battle_cache_get_defender(1)
			local _, _, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
			local is_caster_lord = false
			
			if defender_faction_name == self.malakai_faction then
				is_caster_lord = pb:attacker():is_caster()
			elseif attacker_faction_name == self.malakai_faction then
				is_caster_lord = pb:defender():is_caster()
			else
				-- neither faction is malakai so we don't do anything
				return false
			end
			
			if is_caster_lord then
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_research_technology_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_research_technology_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"ResearchCompleted",
		function(context)
			-- Check if research is required one and is for malakai player faction
			if context:faction():name() == self.malakai_faction then
				if context:technology() == mission_setup_data.tech_key then
					return true
				end
			end
			return false
		end
	)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end

function malakai_battles:setup_fight_battle_in_vampire_corruption_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_in_vampire_corruption_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"BattleCompleted",
		function(context)
			-- Check if battle fought in corruption area
			local pb = cm:model():pending_battle()
			local in_corruption = false

			if cm:pending_battle_cache_faction_won_battle(self.malakai_faction) then
				local region_data = pb:region_data()

				if not region_data:is_null_interface() and not region_data:is_sea() then
					local region = region_data:region()
					
					if not region:is_null_interface() then
						local province = region:province()

						if not province:is_null_interface() then
							local province_corruption = province:pooled_resource_manager():resource(mission_setup_data.corruption_pr_key)

							if province_corruption ~= nil then
								local condition_value = 0

								if mission_setup_data.objective_condition_amount ~= nil then
									condition_value = mission_setup_data.objective_condition_amount
								end
								if province_corruption:value() > condition_value then
									in_corruption = true
								end
							end
						end
					end
				end
			end

			if in_corruption then
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_fight_battles_in_climate_mission(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_battle_climate_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"CharacterCompletedBattle",
		function(context)
			-- Check if battle is fought in a climate that matches the condition
			local character = context:character()
			if character:faction():name() == self.malakai_faction and character:has_military_force() then
				local region_data = context:pending_battle():region_data()
				if not region_data:is_null_interface() and not region_data:is_sea() then
					local region = region_data:region()
					if not region:is_null_interface() then
						local battle_climate = region:settlement():get_climate()
						if self:is_key_in_list(battle_climate, mission_setup_data.climate_condition_list) then
							if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
								return true
							end
						end
					end
				end
			end
			return false
		end
	)
	
	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_fight_battles_against_culture(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_battles_against_culture_" .. mission_key
	if not mission_setup_data.marker_data.marker_spawned ~= nil and mission_setup_data.marker_data.marker_spawned ~= true then
		mission_setup_data.marker_data.marker_spawned = false
	end

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"BattleCompleted",
		function(context)
			-- Check if battle is won against target cultures and the required amount of times
			if cm:pending_battle_cache_faction_won_battle_against_culture(self.malakai_faction, mission_setup_data.objective_cultures) then
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					
					-- Remove relevant spawned markers
					if mission_setup_data.marker_data ~= nil then
						self:remove_markers(mission_setup_data)
					end

					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if mission_setup_data.marker_data ~= nil and mission_setup_data.marker_data.marker_spawned ~= true then
		mission_setup_data.marker_data.marker_spawned = true
		self:handle_marker_setup(mission_setup_data)
	end
	
	local x,y = self:get_marker_position(mission_setup_data.marker_data)
	if x ~= false then mm:set_position(x, y) end

	if should_trigger then mm:trigger() end
end


function malakai_battles:setup_complete_dilemma_chain(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_complete_dilemma_chain_" .. mission_key
	if not mission_setup_data.marker_data.marker_spawned ~= nil and mission_setup_data.marker_data.marker_spawned ~= true then
		mission_setup_data.marker_data.marker_spawned = false
	end

	mm:set_mission_issuer(self.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"DilemmaChoiceMadeEvent",
		function(context)
			-- Check if dilemma chain has been completed
			if context:faction():name() == self.malakai_faction and self:is_key_in_list(context:dilemma(), mission_setup_data.dilemma_completion_key) then
				-- Remove relevant spawned markers
				if mission_setup_data.marker_data ~= nil then
					self:remove_markers(mission_setup_data)
				end
				return true
			end
			return false
		end
	)

	self:setup_mission_payload(mm, mission_setup_data)
	if mission_setup_data.marker_data ~= nil and mission_setup_data.marker_data.marker_spawned ~= true then
		mission_setup_data.marker_data.marker_spawned = true
		self:handle_marker_setup(mission_setup_data)
	end

	local x,y = self:get_marker_position(mission_setup_data.marker_data)
	if x ~= false then mm:set_position(x, y) end

	if should_trigger then mm:trigger()	end
end


function malakai_battles:setup_fight_special_force(mission_setup_data, mission_key, should_trigger)
	local force_spawn_data = mission_setup_data.spawn_force_data
	local invasion_army_generals_list = {}
	local invasion_army_cqi_list = {}
	for i = 1, #force_spawn_data.spawn_list do
		local spawn_data = force_spawn_data[force_spawn_data.spawn_list[i]]
		local invasion_key = force_spawn_data.spawn_list[i] .. "_" .. tostring(i)
		local invasion = self:spawn_ai_army(spawn_data, invasion_key)
		local general = invasion:get_general()
		table.insert(invasion_army_generals_list, {general, false})
		if not general:is_null_interface() then
			table.insert(invasion_army_cqi_list, {general:command_queue_index(), false})
		end
	end

	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_fight_special_force_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("override_text " .. objective_key)
	mm:add_condition("script_key " .. force_spawn_data.script_key)

	self:setup_mission_payload(mm, mission_setup_data)
	
	self:setup_spawn_army_defeated_listener(objective_key, mission_key, invasion_army_generals_list, force_spawn_data.script_key, invasion_army_cqi_list)

	local general_interface = invasion_army_generals_list[1][1]
	if not general_interface:is_null_interface() then
		mm:set_position(general_interface:logical_position_x(), general_interface:logical_position_y())
	end

	if should_trigger then 
		mm:trigger()
	
		cm:callback(
			function()
				cm:set_scripted_mission_entity_completion_states(mission_key, force_spawn_data.script_key, invasion_army_generals_list)
			end,
			1.5
		)
	end
end


function malakai_battles:setup_use_ability(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.malakai_faction, mission_key)
	local objective_key = "mission_text_text_scripted_use_ability_" .. mission_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_scripted_objective(
		objective_key,
		"BattleCompleted",
		function(context)
			-- Check if ability used in battle
			local is_human = cm:pending_battle_cache_human_is_involved()
			local malakai_involved = cm:pending_battle_cache_faction_is_involved(self.malakai_faction)
			if malakai_involved and is_human then
				local pb = cm:model():pending_battle()
				local faction_cqi = cm:get_faction(self.malakai_faction):command_queue_index()
				if self:has_reached_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)

	if should_trigger then mm:trigger() end
end

---------------------
-- Marker setup
---------------------

function malakai_battles:handle_marker_setup(mission_setup_data)
	local data = mission_setup_data.marker_data
	local campaign = cm:get_campaign_name()
	if data.spawn_type == "region" then
		local region_list = data.region_area[campaign]
		for i = 1, data.marker_count do
			if data.dilemma_key then
				self:setup_marker(data, i, region_list[i])
			else
				self:setup_marker(data, i, region_list[i], true)
			end
		end
	elseif data.spawn_type == "character" then
		for i = 1, data.marker_count do
			self:setup_marker(data, i)
		end
	end
end


function malakai_battles:remove_markers(mission_setup_data)
	local data = mission_setup_data.marker_data	
	for i = 1, data.marker_count do
		local encounter_marker_object = Interactive_Marker_Manager:get_marker(data.key.."_"..i)
	
		if encounter_marker_object then
			encounter_marker_object:despawn_all()
		end
	end
end


function malakai_battles:setup_marker(marker_info, unique_key_mod, opt_region_key, is_battle_marker)
	local region_key = opt_region_key or nil
	local marker = Interactive_Marker_Manager:new_marker_type(marker_info.key.."_"..unique_key_mod, marker_info.marker_info, nil, 1, self.malakai_faction)

	if is_battle_marker then
		marker:add_interaction_event("ScriptEventMalakaiEncounterMarkerBattleTriggered")
	end
	
	if marker_info.dilemma_key then
		marker:add_dilemma(marker_info.dilemma_key)
		marker:add_interaction_event("ScriptEventMalakaiDilemmaMarkerTriggered")
	end
	
	marker:is_persistent(false)
	
	if marker_info.spawn_type == "region" then
		marker:spawn_at_region(region_key, nil, nil, nil, 20, self.malakai_faction)
	elseif marker_info.spawn_type == "character" then
		local faction = cm:get_faction(self.malakai_faction)
		local character = faction:faction_leader()
		if character:has_region() then
			marker:spawn_at_character(character:command_queue_index(), false, nil, 10)
		else
			marker:spawn_at_region(faction:home_region():name(), nil, nil, nil, 20, self.malakai_faction)
		end
	end
end


function malakai_battles:setup_marker_listeners()
	core:add_listener(
		"ScriptEventMalakaiEncounterMarkerBattleTriggered",
		"ScriptEventMalakaiEncounterMarkerBattleTriggered",
		true,
		function(context)
			local character = context:character()
			local marker_info = context.stored_table
			local marker_ref = marker_info.marker_ref
			local mission_key = marker_ref:sub(1, -3)
			local adventure_key = string.gsub(mission_key:sub(1, -3), "wh3_dlc25_mis_dwf_malakai_", "")
			local adventure_data = self.mission_data[adventure_key]
			local missions_data = adventure_data.missions[mission_key]
			local encounter = missions_data.marker_data

			if not is_table(encounter) then
				script_error("Malakai Battles: Received an event trigger for a marker "..marker_ref.." that cannot be found")
			end
			
			local battle_callback = self.marker_battle_setup_functions[adventure_key]
			if battle_callback ~= nil and is_function(battle_callback.on_battle_trigger_callback) then
				battle_callback:on_battle_trigger_callback(character, marker_ref)
			end
		end,
		true
	)
end


function malakai_battles:set_up_generic_encounter_forced_battle(character, target_faction_key, force_template_key, override_key, is_ambush, army_size_override, opt_general_subtype, opt_power_modifier, opt_ignore_effect_bundle)
	self:calculate_random_battle_power()
	local power_modifier = opt_power_modifier or 0
	local effect_bundle = nil
	
	if not opt_ignore_effect_bundle then
		effect_bundle = self.invasion_force_interrupted_effect_bundle
	end

	Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
		character:military_force():command_queue_index(),
		target_faction_key,
		force_template_key,
		army_size_override or malakai_battles:calculate_enemy_force_size_from_player_force(character, 0),
		malakai_battles.battle_power_modifier + power_modifier,
		false,
		true,
		is_ambush,
		nil,
		nil,
		opt_general_subtype or nil,
		malakai_battles.battle_power_modifier + power_modifier,
		effect_bundle,
		nil,
		override_key
	)
end

---------------------
-- Spawn Army battles
---------------------


function malakai_battles:spawn_ai_army(spawn_force_data, invasion_key)
	local force_size =spawn_force_data.force_size
	local force_power = spawn_force_data.force_power
	if force_power == nil then
		force_power = self:calculate_random_battle_power(true)
	end
	local make_faction_leader = spawn_force_data.make_faction_leader or false
	local maintain_strength = true
	local campaign = cm:get_campaign_name()
	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(self.malakai_faction, spawn_force_data.region_key[campaign], false, true, 25)
	local coordinates = {x, y}
	
	local force_list = WH_Random_Army_Generator:generate_random_army(invasion_key, spawn_force_data.template_key, force_size, force_power, true, false)
	
	local invasion
	if invasion_manager:get_invasion(invasion_key) ~= false then
		invasion = invasion_manager:get_invasion(invasion_key)
	else
		invasion = invasion_manager:new_invasion(invasion_key, spawn_force_data.faction_key, force_list, coordinates)
		
		local surname = ""
		if spawn_force_data.general_surname ~= nil then surname = spawn_force_data.general_surname end
		
		invasion:create_general(make_faction_leader, spawn_force_data.general_subtype, "names_name_" .. spawn_force_data.general_name, "", "names_name_" .. surname, "")
		
		if spawn_force_data.general_level then
			invasion:add_character_experience(spawn_force_data.general_level, true)
		end
		
		if spawn_force_data.unit_level then
			invasion:add_unit_experience(spawn_force_data.unit_level)
		end
		
		invasion:add_aggro_radius(5, {self.malakai_faction})
		
		invasion:start_invasion(maintain_strength, true, true, true, false)
		
		invasion:apply_effect(self.invasion_effect_bundles.no_upkeep, -1)
		invasion:apply_effect(self.invasion_effect_bundles.region_attrition_immune, -1)
		invasion:apply_effect(self.invasion_effect_bundles.immobile, -1)
		invasion:should_stop_at_end(true)
		
		cm:force_diplomacy("faction:" .. spawn_force_data.faction_key, "all", "all", false, false, true)
		cm:force_declare_war(spawn_force_data.faction_key, self.malakai_faction, false, false)
	end

	return invasion
end


function malakai_battles:setup_spawn_army_defeated_listener(listener_key, mission_key, invasion_army_generals_list, script_key, invasion_army_cqi_list)
	core:add_listener(
		listener_key,
		"BattleCompleted",
		function()
			local is_human = cm:pending_battle_cache_human_is_involved()
			local malakai_involved = cm:pending_battle_cache_faction_is_involved(self.malakai_faction)
			if is_human and malakai_involved then
				for _, v in ipairs(invasion_army_cqi_list) do
					if cm:pending_battle_cache_char_is_involved(v[1]) then
						return true
					end
				end
			end
			return false
		end,
		function()
			if cm:pending_battle_cache_faction_won_battle(self.malakai_faction) then
				local complete_count = 0
				for k, v in ipairs(invasion_army_cqi_list) do
					if cm:pending_battle_cache_char_is_involved(v[1]) then
						invasion_army_generals_list[k][2] = true
						v[2] = true
					end
					if v[2] == true then complete_count = complete_count + 1 end
				end
				cm:set_scripted_mission_entity_completion_states(mission_key, script_key, invasion_army_generals_list)

				if complete_count >= #invasion_army_cqi_list then
					cm:complete_scripted_mission_objective(self.malakai_faction, mission_key, script_key, true)
					core:remove_listener(listener_key)
				end
			end
		end,
		true
	)
end

---------------------
-- Functionality
---------------------

function malakai_battles:setup_ritual_locks()
	local faction = cm:get_faction(self.malakai_faction)
	for i = 1, #self.mission_set_list do
		local mission_data = self.mission_data[self.mission_set_list[i]]
		if self.currently_activated_adventure == self.mission_set_list[i] or self.activated_adventures[mission_data.activate_ritual] then
			cm:lock_ritual(faction, mission_data.activate_ritual)
		end
		if self.currently_activated_adventure == self.mission_set_list[i] or not self.activated_adventures[mission_data.activate_ritual] then
			cm:lock_ritual(faction, mission_data.switch_ritual)
		end
	end
end


function malakai_battles:ritual_switch_to_new_adventure(ritual_list)
	local previous_adventure = self.mission_data[self.currently_activated_adventure]
	local faction = cm:get_faction(self.malakai_faction)
	if self.currently_activated_adventure ~= "" then
		if self.activated_adventures[previous_adventure.activate_ritual] then
			cm:unlock_ritual(faction, previous_adventure.switch_ritual, -1)
		else
			cm:unlock_ritual(faction, previous_adventure.activate_ritual, -1)
		end
	end
	cm:lock_ritual(faction, ritual_list.activate_ritual)
	cm:lock_ritual(faction, ritual_list.switch_ritual)
	self.activated_adventures[ritual_list.activate_ritual] = true
end


function malakai_battles:get_mission_set_from_ritual(ritual_key)
	for _, mission_set in ipairs(self.mission_set_list) do
		if self.mission_data[mission_set].activate_ritual == ritual_key then
			return mission_set
		elseif self.mission_data[mission_set].switch_ritual == ritual_key then
			return mission_set
		end
	end
	return false
end


function malakai_battles:calculate_enemy_force_size_from_player_force(player_character_interface, modifier)
	local enemy_force_size = player_character_interface:military_force():unit_list():num_items()
	
	if enemy_force_size < 5 then
		enemy_force_size = 5
	end
	
	enemy_force_size = enemy_force_size + modifier
	
	if enemy_force_size > 19 then
		enemy_force_size = 19
	end
	
	return enemy_force_size
end


function malakai_battles:calculate_random_battle_power(should_return_value)
	local turn_number = cm:turn_number()
	local turn_mod = 0
	local difficulty_mod = 0
	
	if turn_number <= 10 then
		turn_mod = 1
	elseif turn_number <= 20 then
		turn_mod = 2
	elseif turn_number <= 40 then
		turn_mod = 3
	elseif turn_number <= 50 then
		turn_mod = 4
	elseif turn_number <= 75 then
		turn_mod = 5
	elseif turn_number < 100 then
		turn_mod = 6
	else
		turn_mod = 7
	end
	
	if cm:get_difficulty() < 2 then
		difficulty_mod = 2
	elseif cm:get_difficulty() >= 3 then
		difficulty_mod = 4
	else
		difficulty_mod = 3
	end
	
	if should_return_value then
		return turn_mod + difficulty_mod
	else
		malakai_battles.battle_power_modifier = turn_mod + difficulty_mod
	end
end


function malakai_battles:updated_scripted_objective_count(mission_manager, objective_key, objective_save_key, required_amount)
	local battles_fought = cm:get_saved_value(objective_save_key) or 0
	cm:callback(
		function()
			mission_manager:update_scripted_objective_text(
				objective_key,
				battles_fought,
				required_amount
			)
		end,
		0.5
	)
end


function malakai_battles:setup_mission_payload(mission_manager, mission_data)
	if mission_data.effect_bundle_payload ~= nil then
		mission_manager:add_payload("effect_bundle{bundle_key " .. mission_data.effect_bundle_payload .. ";turns 0;}")
	end

	if mission_data.treasury_payload ~= nil then
		mission_manager:add_payload("money " .. mission_data.treasury_payload)
	end

	if mission_data.pooled_resource_payload ~= nil then
		mission_manager:add_payload(self:generate_pooled_resource_payload_string(mission_data.pooled_resource_payload))
	end
end

---------------------
-- Helpers
---------------------

function malakai_battles:is_key_in_list(key_to_check, list_to_check)
	if type(list_to_check) == "table" then
		for j = 1, #list_to_check do
			if key_to_check == list_to_check[j] then
				return true
			end
		end
	else
		return list_to_check == key_to_check
	end
	return false
end


function malakai_battles:has_reached_required_number_for_objective(mission_setup_data, mission_manager, objective_key)
	local objective_count = cm:get_saved_value(mission_setup_data.objective_save_key) or 0
	objective_count = objective_count + 1
	cm:set_saved_value(mission_setup_data.objective_save_key, objective_count)
	self:updated_scripted_objective_count(mission_manager, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)
	if objective_count >= mission_setup_data.objective_required_amount then
		return true
	end
	return false
end


function malakai_battles:generate_pooled_resource_payload_string(pooled_resource_payload)
	local key = pooled_resource_payload.key
	local factor =pooled_resource_payload.factor
	local amount = pooled_resource_payload.amount

	return "faction_pooled_resource_transaction{resource "..key..";factor "..factor..";amount "..amount..";context absolute;}"
end


function malakai_battles:setup_ritual_lookup_table()
	self.ritual_lookup = {}
	local lookup = self.ritual_lookup
	for i = 1, #malakai_battles.mission_set_list do
		local mission_data = malakai_battles.mission_data[malakai_battles.mission_set_list[i]]
		lookup[tostring(mission_data.activate_ritual)] = true
		lookup[tostring(mission_data.switch_ritual)] = true
	end
end


function malakai_battles:setup_missions_list()
	self.campaign_missions_list = {}
	local campaign = cm:get_campaign_name()

	for _,v in ipairs(self.mission_set_list) do
		local set_data = self.mission_data[v]
		for _,mission in ipairs(set_data.missions_required_to_unlock_battle_mission) do
			table.insert(self.campaign_missions_list, mission)
		end

		table.insert(self.campaign_missions_list, set_data.narrative_battle_mission_key[campaign])
	end
end


function malakai_battles:get_adventure_set_from_mission_key(mission_key)
	for _,v in ipairs(self.mission_set_list) do
		local set_data = self.mission_data[v]
		if self:is_key_in_list(mission_key, set_data.missions_required_to_unlock_battle_mission) then
			return v
		end
	end
	return false
end


function malakai_battles:get_marker_position(marker_data)
	local key = marker_data.key.."_1"
	local marker = Interactive_Marker_Manager:get_marker(key)
	if marker ~= false then
		for k,v in pairs(marker.instances) do
			if string.find(k, key) ~= nil then
				return v.stored_x, v.stored_y
			end
		end
	end
	return false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

function malakai_battles:handle_ai_unlocking()
	core:add_listener(
		"malakai_battles_ai_reward_unlocking",
		"FactionTurnStart",
		function(context)
			local turn_number = cm:turn_number()
			return context:faction():name() == self.malakai_faction and self.ai_rewards_by_turn[turn_number] ~= nil
		end,
		function()
			local effect_bundle_turn_duration = -1
			local turn_number = cm:turn_number()
			local rewards_to_grant = self.ai_rewards_by_turn[turn_number]
			for _, reward in ipairs(rewards_to_grant.effect_bundles) do
				cm:apply_effect_bundle(reward, self.malakai_faction, effect_bundle_turn_duration)
			end
			cm:add_ancillary_to_faction(faction, rewards_to_grant.ancillary, false)

			if turn_number >= 70 then core:remove_listener("malakai_battles_ai_reward_unlocking") end
		end,
		true
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("adventure_mission_data", malakai_battles.mission_data, context)
		cm:save_named_value("adventure_completed_missions", malakai_battles.completed_missions, context)
		cm:save_named_value("adventure_activated_adventures", malakai_battles.activated_adventures, context)
		cm:save_named_value("adventure_currently_activated", malakai_battles.currently_activated_adventure, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			malakai_battles.mission_data = cm:load_named_value("adventure_mission_data", malakai_battles.mission_data, context)
			malakai_battles.completed_missions = cm:load_named_value("adventure_completed_missions", malakai_battles.completed_missions, context)
			malakai_battles.activated_adventures = cm:load_named_value("adventure_activated_adventures", malakai_battles.activated_adventures, context)
			malakai_battles.currently_activated_adventure = cm:load_named_value("adventure_currently_activated", malakai_battles.currently_activated_adventure, context)
		end
	end
)