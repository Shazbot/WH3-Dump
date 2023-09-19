the_changeling_features = {
	faction_key = "wh3_dlc24_tze_the_deceivers",
	campaign_name = "",
	cultist_type = "engineer",
	cultist_subtype = "wh3_dlc24_tze_the_changeling_cultist_special",
	slot_set = "wh3_dlc24_slot_set_tze_changeling",
	slot_template = "wh3_dlc24_tze_cult_changeling",
	cult_expansion_chance_bonus_value = "the_changeling_cult_adjacent_region_expansion_chance",
	bonus_cultist_buildings = { -- Added to trickster cults when created by the unique cultist agent action
		wh3_dlc24_agent_action_engineer_hinder_settlement_infiltrate_cults_unique_military = {
			"wh3_dlc24_tze_the_changeling_horror_barracks_2",
			"wh3_dlc24_tze_the_changeling_flamer_1",
			"wh3_dlc24_tze_the_changeling_caster_1"
		},
		wh3_dlc24_agent_action_engineer_hinder_settlement_infiltrate_cults_unique_parasitic = {
			"wh3_dlc24_tze_the_changeling_growth_parasitic_1",
			"wh3_dlc24_tze_the_changeling_income_parasitic_1",
			"wh3_dlc24_tze_the_changeling_expansion_parasitic_1"
		},
		wh3_dlc24_agent_action_engineer_hinder_settlement_infiltrate_cults_unique_symbiotic = {
			"wh3_dlc24_tze_the_changeling_diplomacy_symbiotic_2",
			"wh3_dlc24_tze_the_changeling_income_symbiotic_3",
		}
	},
	occupation_buildings = { -- one building is randomly selected when establishing a cult via settlement capture. The level is based on the level of the settlement
		symbiotic = {
			"wh3_dlc24_tze_the_changeling_growth_symbiotic_",
			"wh3_dlc24_tze_the_changeling_income_symbiotic_"
		},
		parasitic = {
			"wh3_dlc24_tze_the_changeling_expansion_parasitic_",
			"wh3_dlc24_tze_the_changeling_growth_parasitic_",
			"wh3_dlc24_tze_the_changeling_income_parasitic_"
		}
	},
	cultist_regions = { -- These are used by techs to spawn changeling special cultists in all the theatres
		wh3_dlc24_tech_the_changeling_cultist_1 = "wh3_main_combi_region_altdorf",
		wh3_dlc24_tech_the_changeling_cultist_2 = "wh3_main_combi_region_the_tower_of_khrakk",
		wh3_dlc24_tech_the_changeling_cultist_3 = "wh3_main_combi_region_castle_bastonne",
		wh3_dlc24_tech_the_changeling_cultist_4 = "wh3_main_combi_region_the_gates_of_zharr",
		wh3_dlc24_tech_the_changeling_cultist_5 = "wh3_main_combi_region_black_pyramid_of_nagash",
		wh3_dlc24_tech_the_changeling_cultist_6 = "wh3_main_combi_region_hag_graef",
		wh3_dlc24_tech_the_changeling_cultist_7 = "wh3_main_combi_region_whitefire_tor",
		wh3_dlc24_tech_the_changeling_cultist_8 = "wh3_main_combi_region_ming_zhu",
		wh3_dlc24_tech_the_changeling_cultist_9 = "wh3_main_combi_region_chaqua",
		wh3_dlc24_tech_the_changeling_cultist_1_roc = "wh3_main_chaos_region_altdorf",
		wh3_dlc24_tech_the_changeling_cultist_2_roc = "wh3_main_chaos_region_the_tower_of_khrakk",
		wh3_dlc24_tech_the_changeling_cultist_4_roc = "wh3_main_chaos_region_the_gates_of_zharr",
		wh3_dlc24_tech_the_changeling_cultist_10a_roc = "wh3_main_chaos_region_cliff_of_beasts",
		wh3_dlc24_tech_the_changeling_cultist_8_roc = "wh3_main_chaos_region_ming_zhu",
		wh3_dlc24_tech_the_changeling_cultist_10b_roc = "wh3_main_chaos_region_the_volary"
	},
	rift_template = "wh3_dlc24_teleportation_node_template_the_changeling",
	rift_regions = {  -- These are used by techs to create permenant teleporation rifts in all the theatres
		wh3_main_chaos = {
			wh3_dlc24_tech_the_changeling_rift_1_roc = "wh3_dlc24_the_changeling_rifts_chaos_the_empire_fort_solace",
			wh3_dlc24_tech_the_changeling_rift_2_roc = "wh3_dlc24_the_changeling_rifts_chaos_kislev",
			wh3_dlc24_tech_the_changeling_rift_4_roc = "wh3_dlc24_the_changeling_rifts_chaos_darklands",
			wh3_dlc24_tech_the_changeling_rift_10a_roc = "wh3_dlc24_the_changeling_rifts_chaos_chaos_wastes_cliff_of_beasts",
			wh3_dlc24_tech_the_changeling_rift_8_roc = "wh3_dlc24_the_changeling_rifts_chaos_grand_cathay",
			wh3_dlc24_tech_the_changeling_rift_10b_roc = "wh3_dlc24_the_changeling_rifts_chaos_chaos_wastes_the_volary"
		},
		main_warhammer = {
			wh3_dlc24_tech_the_changeling_rift_1 = "wh3_dlc24_the_changeling_rifts_combi_the_empire_wreckers_point",
			wh3_dlc24_tech_the_changeling_rift_2 = "wh3_dlc24_the_changeling_rifts_combi_kislev",
			wh3_dlc24_tech_the_changeling_rift_3 = "wh3_dlc24_the_changeling_rifts_combi_bretonnia",
			wh3_dlc24_tech_the_changeling_rift_4 = "wh3_dlc24_the_changeling_rifts_combi_darklands",
			wh3_dlc24_tech_the_changeling_rift_5 = "wh3_dlc24_the_changeling_rifts_combi_southlands",
			wh3_dlc24_tech_the_changeling_rift_6 = "wh3_dlc24_the_changeling_rifts_combi_naggaroth",
			wh3_dlc24_tech_the_changeling_rift_7 = "wh3_dlc24_the_changeling_rifts_combi_ulthuan",
			wh3_dlc24_tech_the_changeling_rift_8 = "wh3_dlc24_the_changeling_rifts_combi_grand_cathay",
			wh3_dlc24_tech_the_changeling_rift_9 = "wh3_dlc24_the_changeling_rifts_combi_lustria"
		}
	},
	rift_markers_tech = {
		wh3_main_chaos = {
			wh3_dlc24_the_changeling_rifts_chaos_chaos_wastes_cliff_of_beasts = {x = 270, y = 539},
			wh3_dlc24_the_changeling_rifts_chaos_chaos_wastes_the_volary = {x = 786, y = 493},
			wh3_dlc24_the_changeling_rifts_chaos_darklands = {x = 876, y = 198},
			wh3_dlc24_the_changeling_rifts_chaos_grand_cathay = {x = 1014, y = 548},
			wh3_dlc24_the_changeling_rifts_chaos_kislev = {x = 256, y = 224},
			wh3_dlc24_the_changeling_rifts_chaos_the_empire_fort_solace = {x = 111, y = 166},
		},
		main_warhammer = {
			wh3_dlc24_the_changeling_rifts_combi_bretonnia = {x = 438, y = 589},
			wh3_dlc24_the_changeling_rifts_combi_darklands = {x = 920, y = 552},
			wh3_dlc24_the_changeling_rifts_combi_grand_cathay = {x = 1203, y = 608},
			wh3_dlc24_the_changeling_rifts_combi_kislev = {x = 700, y = 789},
			wh3_dlc24_the_changeling_rifts_combi_lustria = {x = 176, y = 298},
			wh3_dlc24_the_changeling_rifts_combi_naggaroth = {x = 125, y = 700},
			wh3_dlc24_the_changeling_rifts_combi_southlands = {x = 597, y = 272},
			wh3_dlc24_the_changeling_rifts_combi_the_empire_wreckers_point = {x = 524, y = 713},
			wh3_dlc24_the_changeling_rifts_combi_ulthuan = {x = 236, y = 602}
		}
	},
	rift_markers_schemes = {
		wh3_main_chaos = {
			wh3_dlc24_the_changeling_rifts_chaos_the_empire_castle_drakenhof = {x = 495, y = 65}
		},
		main_warhammer = {
			wh3_dlc24_the_changeling_rifts_combi_the_empire_castle_drakenhof = {x = 702, y = 620}
		}
	},
	sacking_income_base = 2000, -- Multiplied by building health and building level to get the income for the sacking capstone building
	sacking_income_per_building_level = 500, -- Additional sacking money for each level of each building in the settlement
	sacking_health = 30, -- The health value of the buildings after being sacked
	army_spawns = { -- Created by the capstone buildings which allow The Changeling to create a new army, or spawn a hostile third party one
		the_changeling = {
			force_key = "the_changeling_scripted_cult_army",
			incident_self = "wh3_dlc24_incident_tze_the_changeling_army_the_changeling",
			incident_target = "wh3_dlc24_incident_tze_the_changeling_army_region_owner",
			units = {
				wh3_dlc20_chs_inf_chaos_warriors_mtze = 3,
				wh3_dlc20_chs_inf_chaos_marauders_mtze = 2,
				wh3_main_tze_inf_pink_horrors_0 = 2,
				wh3_main_tze_inf_blue_horrors_0 = 2,
				wh3_main_tze_cav_chaos_knights_0 = 1,
				wh3_dlc24_tze_mon_mutalith_vortex_beast = 1
			}
		},
		chaos_rebels = {
			factions = {"wh3_main_tze_tzeentch_rebels", "wh3_main_nur_nurgle_rebels", "wh3_main_kho_khorne_rebels", "wh3_main_sla_slaanesh_rebels"}, -- Used to randomly pick one of the chaos races for army spawns
			incident_self = "wh3_dlc24_incident_tze_chaos_army_the_changeling",
			incident_target = "wh3_dlc24_incident_tze_chaos_army_region_owner",
		}
	},
	schemes = {
		victory_conditions = { -- Number of grand schemes for the victory conditions.
			short = 2,
			main_warhammer = 5,
			wh3_main_chaos = 3
		},
		ultimate_battle_strings = {
			the_changeling_empire_army_reinforce = "0",
			the_changeling_bretonnia_army_reinforce = "0",
			the_changeling_cathay_army_reinforce = "0",
			the_changeling_high_elves_army_reinforce = "0",
			the_changeling_vampire_coast_army_reinforce = "0",
			the_changeling_greenskins_army_reinforce = "0",
			the_changeling_norsca_army_reinforce = "0",
			the_changeling_skaven_army_reinforce = "0",
			the_changeling_tomb_kings_army_reinforce = "0",
			the_changeling_tzeentch_army_reinforce = "0"
		},
		missions = {

			all = {
				wh3_dlc24_mission_schemes_darklands_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in the Darklands
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_darklands_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_darklands_minor_2 = {
					objectives = {
							{
							-- Build a max tier hidden expansion building in pigbarter
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_darklands_pigbarter_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_darklands_minor_2;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_darklands_minor_3 = {
					objectives = {
							{
							-- Obtain the form of Astragoth
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_darklands_form_astragoth_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_hellforge_flame;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_darklands_minor_4 = {
					objectives = {
							{
							-- Raise corruption in Zharr Naggrund
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_darklands_zharr_naggrund_corruption_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"faction_pooled_resource_transaction{resource wh3_dlc24_tze_cult_supplies;factor schemes;amount 250;context absolute;}",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_darklands_minor_4;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_darklands_minor_5 = {
					objectives = {
						{
							-- Defeat Ogre armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {	
								"total 12",
								"subculture wh3_main_sc_ogr_ogre_kingdoms",
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_darklands_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},				
				wh3_dlc24_mission_schemes_darklands_minor_6 = {
					objectives = {
						{
							-- Defeat Grimgor in battle
							type = "ELIMINATE_CHARACTER_IN_BATTLE",
							conditions = {	
								"character", -- needs a CQI, which requires the model to be loaded. Added after campaign starts
								"faction wh_main_grn_greenskins"
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_darklands_minor_6;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_darklands_minor_7 = {
					objectives = {
						{
							-- Defeat Imrik in battle
							type = "ELIMINATE_CHARACTER_IN_BATTLE",
							conditions = {	
								"character", -- needs a CQI, which requires the model to be loaded. Added after campaign starts
								"faction wh2_dlc15_hef_imrik"
							}
						},
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_arcane_item_corrupted_flame;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_darklands_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_greenskins",
						"text_display dummy_wh3_dlc24_mission_schemes_darklands_grand_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_gorduz_form",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_darklands_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_grn"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Grand Cathay
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_2 = {
					objectives = {
						{
							-- Win 15 land battles in the Grand Cathay theatre
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_win_battles",
								"script_key schemes",
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_caravan_von_carstein_blade;}",
						"add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_caravan_luminark_lens;}"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_3 = {
					objectives = {
						{
							-- Obtain the form of Zhao Ming
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_form_zhao_ming_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_arcane_item_alchemical_notes;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_4 = {
					objectives = {
						{
							-- Raise corruption in Nan-Gau, Gunpower Road
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_nan-gau_corruption_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_minor_4;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_6 = {
					objectives = {
						{
							-- Obtain the form of Snikch
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_form_snikch_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_weapon_weeping_blade;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_grand_cathay_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_cathay",
						"text_display dummy_wh3_dlc24_mission_schemes_grand_cathay_grand_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_enemy_cth"
				},
				wh3_dlc24_mission_schemes_norsca_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Norsca & Kislev
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_norsca_minor_3 = {
					objectives = {
						{
							-- Infiltrate the 3 Great Cities of Kislev
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_great_cities_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_kislev_all_forms_payload",
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_norsca_minor_5 = {
					objectives = {
						{
							-- Defeat Norsca armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh_dlc08_sc_nor_norsca",
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_wulfrik_throgg_form",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_norsca_minor_5;turns 0;}",
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in The Empire
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_the_empire_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_2 = {
					objectives = {
						{
							-- Raise corruption in Castle Drakenhof
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_the_empire_sylvania_corruption_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_open_rift_payload",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_the_empire_minor_2;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_3 = {
					objectives = {
						{
							-- Sack Altdorf
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_the_empire_sack_altdorf_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_unlock_ror_steam_tank"},
					icon = "ror"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_4 = {
					objectives = {
						{
							-- Win 15 battles in the the empire theatre
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_the_empire_win_battles",
								"script_key schemes",
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_the_empire_minor_4;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_5 = {
					objectives = {
						{
							-- Defeat Dwarf armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh_main_sc_dwf_dwarfs",
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_the_empire_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_the_empire_minor_6 = {
					objectives = {
						{
							-- Destroy Festus
							type = "DESTROY_FACTION",
							conditions = {
								"faction wh3_dlc20_chs_festus",
								"confederation_valid"
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_the_empire_minor_6;turns 0;}"},
					icon = "effect_bundle"
				},				
				wh3_dlc24_mission_schemes_the_empire_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_empire",
						"text_display dummy_wh3_dlc24_mission_schemes_the_empire_grand_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_aekold_form",
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_weapon_runefang;}",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_the_empire_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_enemy_emp"
				},
			},

			wh3_main_chaos = {
				wh3_dlc24_mission_schemes_chaos_wastes_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in the Chaos Wastes
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_chaos_wastes_minor_2 = {
					objectives = {
						{
							-- Ally Kairos
							type = "MAKE_ALLIANCE",
							conditions = {
								"faction wh3_main_tze_oracles_of_tzeentch",
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_armour_unknown_champions_cloak;}",
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_chaos_wastes_minor_3 = {
					objectives = {
						{
							-- Chaos Royal Rumble! Defeat the big Chaos factions
							type = "DESTROY_FACTION",
							conditions = {
								"faction wh3_main_kho_exiles_of_khorne",
								"faction wh3_main_nur_poxmakers_of_nurgle",
								"faction wh3_main_sla_seducers_of_slaanesh",
								"confederation_valid"
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_weapon_chainsword;}",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_chaos_wastes_minor_3;turns 0;}"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_chaos_wastes_minor_4 = {
					objectives = {
						{
							-- Establish a cult in 5 province capitals in the theatre
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_province_capitals_objective",
								"script_key schemes",
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_chaos_wastes_minor_4;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_chaos_wastes_minor_5 = {
					objectives = {
						{
							-- Win 15 battles in the chaos wastes theatre
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_win_battles",
								"script_key schemes",
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_chaos_wastes_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_chaos_wastes_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_chaos",
						"text_display dummy_wh3_dlc24_mission_schemes_chaos_wastes_grand_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_blue_scribes_form",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_chaos_wastes_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_tze"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_5 = {
					objectives = {
						{
							-- Sack or raze coastal/river settlements in Cathay
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 5",
								"region wh3_main_chaos_region_zhanshi",
								"region wh3_main_chaos_region_xing_po",
								"region wh3_main_chaos_region_shang_wu",
								"region wh3_main_chaos_region_bridge_of_heaven",
								"region wh3_main_chaos_region_hanyu_port",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_grand_cathay_theatre_corruption_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_minor_5;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_7_roc = {
					objectives = {
						{
							-- Destroy Yuan Bo
							type = "DESTROY_FACTION",
							conditions = {
								"faction wh3_dlc24_cth_the_celestial_court",
								"confederation_valid"
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_minor_7_roc;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_norsca_minor_2 = {
					objectives = {
						{
							-- Sack Hell Pit
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_sack_hell_pit_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_armour_scavenged_laboratory_materials;}",
						"text_display dummy_wh3_dlc24_mission_schemes_unlock_ror_feral_carnosaur",
						"text_display dummy_wh3_dlc24_mission_schemes_ghoritch_form"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_norsca_minor_4 = {
					objectives = {
						{
							-- Raise corruption in The Monolith of Katam
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_monolith_corruption_objective_roc",
								"script_key schemes"
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_norsca_minor_4;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_norsca_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_norsca",
						"text_display dummy_wh3_dlc24_mission_schemes_norsca_grand_scripted_roc",
						"text_display dummy_wh3_dlc24_mission_schemes_unlock_ror_frost_wyrm",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_norsca_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_nor"
				}
			},
			

			main_warhammer = {
				wh3_dlc24_mission_schemes_grand_cathay_minor_5 = {
					objectives = {
						{
							-- Sack or raze coastal/river settlements in Cathay
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 7",
								"region wh3_main_combi_region_haichai",
								"region wh3_main_combi_region_beichai",
								"region wh3_main_combi_region_fu_chow",
								"region wh3_main_combi_region_li_zhu",
								"region wh3_main_combi_region_shi_wu",
								"region wh3_main_combi_region_dai_cheng",
								"region wh3_main_combi_region_chimai",
								"region wh3_main_combi_region_zhanshi",
								"region wh3_main_combi_region_bridge_of_heaven",
								"region wh3_main_combi_region_bamboo_crossing",
								"region wh3_main_combi_region_shi_long",
								"region wh3_main_combi_region_hanyu_port",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_grand_cathay_theatre_corruption_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_minor_5;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_grand_cathay_minor_7_ie = {
					objectives = {
						{
							-- Destroy Nakai's faction, as well as his vassal
							type = "DESTROY_FACTION",
							conditions = {
								"faction wh2_dlc13_lzd_spirits_of_the_jungle",
								"faction wh2_dlc13_lzd_defenders_of_the_great_plan",
								"confederation_valid"
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_grand_cathay_minor_7_ie;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_norsca_minor_2 = {
					objectives = {
						{
							-- Sack Hell Pit
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_sack_hell_pit_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_armour_scavenged_laboratory_materials;}",
						"text_display dummy_wh3_dlc24_mission_schemes_ghoritch_form"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_norsca_minor_4 = {
					objectives = {
						{
							-- Raise corruption in Monolith of Bjorkil Bloody-Hand
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_norsca_monolith_corruption_objective_ie",
								"script_key schemes"
							}
						}
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_norsca_minor_4;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_norsca_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_norsca",
						"text_display dummy_wh3_dlc24_mission_schemes_norsca_grand_scripted_ie",
						"text_display dummy_wh3_dlc24_mission_schemes_unlock_ror_frost_wyrm",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_norsca_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_nor"
				},
				wh3_dlc24_mission_schemes_ulthuan_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Ulthuan
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_ulthuan_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_ulthuan_minor_2 = {
					objectives = {
							{
							-- Obtain the form of Alarielle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_ulthuan_form_alarielle_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_corrupted_icon;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_ulthuan_minor_3 = {
					objectives = {
						{
							-- Construct a Chaos rebel army spawning building in the Shrine of Khaine
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_ulthuan_spawn_chaos_rebels_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ulthuan_sword_of_khaine",
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload"
					},
					icon = "sword_of_khaine"
				},
				wh3_dlc24_mission_schemes_ulthuan_minor_4 = {
					objectives = {
						{
							-- Sack or raze all the Gates in Ulthuan
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 4",
								"region wh3_main_combi_region_eagle_gate",
								"region wh3_main_combi_region_griffon_gate",
								"region wh3_main_combi_region_phoenix_gate",
								"region wh3_main_combi_region_unicorn_gate",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ulthuan_inner_ring_chaos_rebels",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_ulthuan_minor_4;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_ulthuan_minor_5 = {
					objectives = {
						{
							-- Attack Galleon's Graveyard
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_ulthuan_sack_galleons_graveyard_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_kraken_fang;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_ulthuan_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_high_elves",
						"text_display dummy_wh3_dlc24_mission_schemes_ulthuan_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_blue_scribes_form",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_ulthuan_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_enemy_hef"
				},
				wh3_dlc24_mission_schemes_lustria_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Lustria
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_lustria_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_lustria_minor_2 = {
					objectives = {
							{
							-- Obtain the form of Mazdamundi
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_lustria_form_mazdamundi_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_pilfered_palanquin;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_lustria_minor_3 = {
					objectives = {
						{
							-- Defeat Lizardmen armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh2_main_sc_lzd_lizardmen",
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_lustria_minor_3;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_lustria_minor_4 = {
					objectives = {
						{
							-- Construct a Chaos rebel army spawning building in Itza
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_lustria_spawn_chaos_rebels_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_lustria_minor_4;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_lustria_minor_5 = {
					objectives = {
						{
							-- Sack or raze pyramids
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 3",
								"region wh3_main_combi_region_citadel_of_dusk",
								"region wh3_main_combi_region_great_turtle_isle",
								"region wh3_main_combi_region_the_star_tower",
								"override_text mission_text_text_wh3_dlc24_mission_schemes_lustria_elven_colonies_objective",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_lustria_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_lustria_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_skaven",
						"text_display dummy_wh3_dlc24_mission_schemes_lustria_grand_scripted",
						"text_display dummy_wh3_dlc24_mission_schemes_unlock_ror_feral_carnosaur",
						"text_display dummy_wh3_dlc24_mission_schemes_lord_kroak_form",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_lustria_grand;turns 0;}"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_skv"
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Naggaroth
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_naggaroth_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_2 = {
					objectives = {
						{
							-- Infiltrate the 3 major Dark Elf Fortress-Cities
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_naggaronth_great_cities_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_naggaroth_all_forms_payload",
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_3 = {
					objectives = {
						{
							-- Sack the Witchwood
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_naggaroth_sack_the_witchwood_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_naggaroth_witchwood_greenskins_payload",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_naggaroth_minor_3;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_4 = {
					objectives = {
						{
							-- Defeat Grombrindal in battle
							type = "ELIMINATE_CHARACTER_IN_BATTLE",
							conditions = {	
								"character", -- needs a CQI, which requires the model to be loaded. Added after campaign starts
								"faction wh3_main_dwf_the_ancestral_throng"
							}
						},
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_facial_scruff;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_5 = {
					objectives = {
						{
							-- Defeat Dark Elf armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh2_main_sc_def_dark_elves",
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_naggaroth_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_naggaroth_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_vampire_coast",
						"text_display dummy_wh3_dlc24_mission_schemes_naggaroth_scripted",
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_arcane_item_captains_horn;}",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_cst"
				},
				wh3_dlc24_mission_schemes_badlands_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in the Badlands & Southlands
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_badlands_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_badlands_minor_2 = {
					objectives = {
							{
							-- Obtain the form of Skarbrand
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_badlands_form_skarbrand_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_weapon_chainsword;}"},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_badlands_minor_3 = {
					objectives = {
						{
							-- Ally Kairos
							type = "MAKE_ALLIANCE",
							conditions = {
								"faction wh3_main_tze_oracles_of_tzeentch",
							}
						}
					},
					payload = {
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_armour_unknown_champions_cloak;}",
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_badlands_minor_4 = {
					objectives = {
						{
							-- Defeat Dwarf armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh2_dlc09_sc_tmb_tomb_kings",
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_badlands_minor_4;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_badlands_minor_5 = {
					objectives = {
						{
							-- Sack or raze pyramids
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 3",
								"region wh3_main_combi_region_black_pyramid_of_nagash",
								"region wh3_main_combi_region_black_tower_of_arkhan",
								"region wh3_main_combi_region_ka_sabar",
								"region wh3_main_combi_region_khemri",
								"region wh3_main_combi_region_wizard_caliphs_palace",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_badlands_minor_5;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_badlands_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_tomb_kings",
						"text_display dummy_wh3_dlc24_mission_schemes_badlands_grand_scripted",
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_undead_tome;}",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_ally_tmb"
				},
				wh3_dlc24_mission_schemes_bretonnia_minor_1 = {
					objectives = {
						{
							-- Infiltrate any settlement in Bretonnia & Athel Loren
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_bretonnia_create_cult_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload"},
					icon = "reveal_shroud"
				},
				wh3_dlc24_mission_schemes_bretonnia_minor_2 = {
					objectives = {
							{
							-- Raise corruption in Skavenblight
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_bretonnia_skavenblight_corruption_objective",
								"script_key schemes"
							}
						}
					},
					payload = {"faction_pooled_resource_transaction{resource skv_nuke;factor schemes;amount 3;context absolute;}"},
					icon = "doomrocket"
				},
				wh3_dlc24_mission_schemes_bretonnia_minor_3 = {
					objectives = {
							{
							-- Obtain the form of Orion
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_bretonnia_form_orion_objective",
								"script_key schemes"
							}
						}
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_hidden_cultist_payload",
						"add_ancillary_to_faction_pool{ancillary_key wh3_dlc24_anc_talisman_tree_sap;}"
					},
					icon = "ancillary"
				},
				wh3_dlc24_mission_schemes_bretonnia_minor_4 = {
					objectives = {
						{
							-- Defeat Bretonnia armies
							type = "DEFEAT_N_ARMIES_OF_FACTION",
							conditions = {
								"total 12",
								"subculture wh_main_sc_brt_bretonnia",
							}
						},
					},
					payload = {"effect_bundle{bundle_key wh3_dlc24_mission_schemes_bretonnia_minor_4;turns 0;}"},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_bretonnia_minor_5 = {
					objectives = {
						{
							-- Sack or raze Athel Loren
							type = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
							conditions = {
								"total 5",
								"region wh3_main_combi_region_the_oak_of_ages",
								"region wh3_main_combi_region_crag_halls_of_findol",
								"region wh3_main_combi_region_kings_glade",
								"region wh3_main_combi_region_vauls_anvil_loren",
								"region wh3_main_combi_region_waterfall_palace",
								"process_listed_regions_only true"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_bretonnia_athel_loren_beastmen_rebels",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_bretonnia_minor_5;turns 0;}"
					},
					icon = "effect_bundle"
				},
				wh3_dlc24_mission_schemes_bretonnia_grand = {
					objectives = {
						{
							-- Complete half the minor schemes, and then win the quest battle
							type = "SCRIPTED",
							conditions = {
								"override_text mission_text_text_wh3_dlc24_mission_schemes_grand_scheme_objective",
								"script_key schemes"
							}
						},
					},
					payload = {
						"text_display dummy_wh3_dlc24_mission_schemes_ultimate_battle_bretonnia",
						"text_display dummy_wh3_dlc24_mission_schemes_bretonnia_grand_scripted",
						"effect_bundle{bundle_key wh3_dlc24_mission_schemes_bretonnia_grand;turns 0;}",
						"text_display dummy_wh3_dlc24_mission_schemes_green_knight_form",
						"text_display dummy_wh3_dlc24_mission_schemes_rift_gem_payload"
					},
					icon = "grand_scheme",
					ultimate_scheme_battle_army = "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_enemy_brt"
				},
			}
		},
		grand_scheme_objectives = { --Tracks how many schemes we've done in a theatre
			wh3_dlc24_mission_schemes_chaos_wastes_grand = 0,
			wh3_dlc24_mission_schemes_badlands_grand = 0,
			wh3_dlc24_mission_schemes_bretonnia_grand = 0,
			wh3_dlc24_mission_schemes_darklands_grand = 0,
			wh3_dlc24_mission_schemes_grand_cathay_grand = 0,
			wh3_dlc24_mission_schemes_lustria_grand = 0,
			wh3_dlc24_mission_schemes_naggaroth_grand = 0,
			wh3_dlc24_mission_schemes_norsca_grand = 0,
			wh3_dlc24_mission_schemes_the_empire_grand = 0,
			wh3_dlc24_mission_schemes_ulthuan_grand = 0
		},
		grand_scheme_to_missions = { -- Used to track when to trigger the quest battles for the grand schemes
			wh3_dlc24_mission_schemes_badlands_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_badlands_minor_1 = true,
					wh3_dlc24_mission_schemes_badlands_minor_2 = true,
					wh3_dlc24_mission_schemes_badlands_minor_3 = true,
					wh3_dlc24_mission_schemes_badlands_minor_4 = true,
					wh3_dlc24_mission_schemes_badlands_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_bretonnia_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_bretonnia_minor_1 = true,
					wh3_dlc24_mission_schemes_bretonnia_minor_2 = true,
					wh3_dlc24_mission_schemes_bretonnia_minor_3 = true,
					wh3_dlc24_mission_schemes_bretonnia_minor_4 = true,
					wh3_dlc24_mission_schemes_bretonnia_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_chaos_wastes_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_chaos_wastes_minor_1 = true,
					wh3_dlc24_mission_schemes_chaos_wastes_minor_2 = true,
					wh3_dlc24_mission_schemes_chaos_wastes_minor_3 = true,
					wh3_dlc24_mission_schemes_chaos_wastes_minor_4 = true,
					wh3_dlc24_mission_schemes_chaos_wastes_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_darklands_grand = {
				total = 4,
				missions = {
					wh3_dlc24_mission_schemes_darklands_minor_1 = true,
					wh3_dlc24_mission_schemes_darklands_minor_2 = true,
					wh3_dlc24_mission_schemes_darklands_minor_3 = true,
					wh3_dlc24_mission_schemes_darklands_minor_4 = true,
					wh3_dlc24_mission_schemes_darklands_minor_5 = true,
					wh3_dlc24_mission_schemes_darklands_minor_6 = true,
					wh3_dlc24_mission_schemes_darklands_minor_7 = true
				}
			},
			wh3_dlc24_mission_schemes_grand_cathay_grand = {
				total = 4,
				missions = {
					wh3_dlc24_mission_schemes_grand_cathay_minor_1 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_2 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_3 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_4 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_5 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_6 = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_7_roc = true,
					wh3_dlc24_mission_schemes_grand_cathay_minor_7_ie = true
				}
			},
			wh3_dlc24_mission_schemes_lustria_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_lustria_minor_1 = true,
					wh3_dlc24_mission_schemes_lustria_minor_2 = true,
					wh3_dlc24_mission_schemes_lustria_minor_3 = true,
					wh3_dlc24_mission_schemes_lustria_minor_4 = true,
					wh3_dlc24_mission_schemes_lustria_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_naggaroth_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_naggaroth_minor_1 = true,
					wh3_dlc24_mission_schemes_naggaroth_minor_2 = true,
					wh3_dlc24_mission_schemes_naggaroth_minor_3 = true,
					wh3_dlc24_mission_schemes_naggaroth_minor_4 = true,
					wh3_dlc24_mission_schemes_naggaroth_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_norsca_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_norsca_minor_1 = true,
					wh3_dlc24_mission_schemes_norsca_minor_2 = true,
					wh3_dlc24_mission_schemes_norsca_minor_3 = true,
					wh3_dlc24_mission_schemes_norsca_minor_4 = true,
					wh3_dlc24_mission_schemes_norsca_minor_5 = true
				}
			},
			wh3_dlc24_mission_schemes_the_empire_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_the_empire_minor_1 = true,
					wh3_dlc24_mission_schemes_the_empire_minor_2 = true,
					wh3_dlc24_mission_schemes_the_empire_minor_3 = true,
					wh3_dlc24_mission_schemes_the_empire_minor_4 = true,
					wh3_dlc24_mission_schemes_the_empire_minor_5 = true,
					wh3_dlc24_mission_schemes_the_empire_minor_6 = true
				}
			},
			wh3_dlc24_mission_schemes_ulthuan_grand = {
				total = 3,
				missions = {
					wh3_dlc24_mission_schemes_ulthuan_minor_1 = true,
					wh3_dlc24_mission_schemes_ulthuan_minor_2 = true,
					wh3_dlc24_mission_schemes_ulthuan_minor_3 = true,
					wh3_dlc24_mission_schemes_ulthuan_minor_4 = true,
					wh3_dlc24_mission_schemes_ulthuan_minor_5 = true
				}
			},
		},
		region_groups_to_missions = { -- This table is used for the schemes which reveal the shroud over a theatre
			wh3_dlc24_schemes_theatre_chaos_chaos_wastes = "wh3_dlc24_mission_schemes_chaos_wastes_minor_1",
			wh3_dlc24_schemes_theatre_chaos_darklands = "wh3_dlc24_mission_schemes_darklands_minor_1",
			wh3_dlc24_schemes_theatre_chaos_grand_cathay = "wh3_dlc24_mission_schemes_grand_cathay_minor_1",
			wh3_dlc24_schemes_theatre_chaos_norsca = "wh3_dlc24_mission_schemes_norsca_minor_1",
			wh3_dlc24_schemes_theatre_chaos_the_empire = "wh3_dlc24_mission_schemes_the_empire_minor_1",
			wh3_dlc24_schemes_theatre_ie_badlands = "wh3_dlc24_mission_schemes_badlands_minor_1",
			wh3_dlc24_schemes_theatre_ie_bretonnia = "wh3_dlc24_mission_schemes_bretonnia_minor_1",
			wh3_dlc24_schemes_theatre_ie_darklands = "wh3_dlc24_mission_schemes_darklands_minor_1",
			wh3_dlc24_schemes_theatre_ie_grand_cathay = "wh3_dlc24_mission_schemes_grand_cathay_minor_1",
			wh3_dlc24_schemes_theatre_ie_lustria = "wh3_dlc24_mission_schemes_lustria_minor_1",
			wh3_dlc24_schemes_theatre_ie_naggaroth = "wh3_dlc24_mission_schemes_naggaroth_minor_1",
			wh3_dlc24_schemes_theatre_ie_norsca = "wh3_dlc24_mission_schemes_norsca_minor_1",
			wh3_dlc24_schemes_theatre_ie_the_empire = "wh3_dlc24_mission_schemes_the_empire_minor_1",
			wh3_dlc24_schemes_theatre_ie_ulthuan = "wh3_dlc24_mission_schemes_ulthuan_minor_1"
		},
		corruption_key = "wh3_main_corruption_tzeentch",
		corruption_target = 75,
		corruption_regions_to_mission = {
			wh3_main_chaos = {
				wh3_main_chaos_region_castle_drakenhof = "wh3_dlc24_mission_schemes_the_empire_minor_2",
				wh3_main_chaos_region_the_monolith_of_katam = "wh3_dlc24_mission_schemes_norsca_minor_4",
				wh3_main_chaos_region_zharr_naggrund = "wh3_dlc24_mission_schemes_darklands_minor_4",
				wh3_main_chaos_region_nan_gau = "wh3_dlc24_mission_schemes_grand_cathay_minor_4",
			},
			main_warhammer = {
				wh3_main_combi_region_castle_drakenhof = "wh3_dlc24_mission_schemes_the_empire_minor_2",
				wh3_main_combi_region_skavenblight = "wh3_dlc24_mission_schemes_bretonnia_minor_2",
				wh3_main_combi_region_monolith_of_borkill_the_bloody_handed = "wh3_dlc24_mission_schemes_norsca_minor_4",
				wh3_main_combi_region_zharr_naggrund = "wh3_dlc24_mission_schemes_darklands_minor_4",
				wh3_main_combi_region_nan_gau = "wh3_dlc24_mission_schemes_grand_cathay_minor_4"
			}
		},
		chaos_rebel_regions_to_mission = {
			wh3_main_combi_region_shrine_of_khaine = "wh3_dlc24_mission_schemes_ulthuan_minor_3",
			wh3_main_combi_region_itza = "wh3_dlc24_mission_schemes_lustria_minor_4"
		},
		sack_regions_to_mission = {
			wh3_main_chaos_region_hell_pit = "wh3_dlc24_mission_schemes_norsca_minor_2",
			wh3_main_combi_region_hell_pit = "wh3_dlc24_mission_schemes_norsca_minor_2",
			wh3_main_chaos_region_altdorf = "wh3_dlc24_mission_schemes_the_empire_minor_3",
			wh3_main_combi_region_altdorf = "wh3_dlc24_mission_schemes_the_empire_minor_3",
			wh3_main_combi_region_the_witchwood = "wh3_dlc24_mission_schemes_naggaroth_minor_3",
			wh3_main_combi_region_the_galleons_graveyard = "wh3_dlc24_mission_schemes_ulthuan_minor_5"
		},
		mission_to_infiltration_regions = {
			wh3_main_chaos = {
				wh3_dlc24_mission_schemes_chaos_wastes_minor_4 = {
					total = 5,
					regions = {
						wh3_main_chaos_region_black_rock = true,
						wh3_main_chaos_region_blood_haven = true,
						wh3_main_chaos_region_city_of_splinters = true,
						wh3_main_chaos_region_infernius = true,
						wh3_main_chaos_region_red_fortress = true,
						wh3_main_chaos_region_the_crystal_spires = true,
						wh3_main_chaos_region_the_gallows_tree = true,
						wh3_main_chaos_region_the_palace_of_ruin = true,
						wh3_main_chaos_region_the_shifting_monolith = true,
						wh3_main_chaos_region_the_silvered_tower_of_sorcerers = true,
						wh3_main_chaos_region_the_sunken_sewers = true,
						wh3_main_chaos_region_the_volary = true,
						wh3_main_chaos_region_the_writhing_fortress = true,
						wh3_main_chaos_region_zerulous = true
					},
					show_count_in_mission_text = "mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_province_capitals_objective"
				},
				wh3_dlc24_mission_schemes_norsca_minor_3 = {
					total = 3, 
					regions = {
						wh3_main_chaos_region_erengrad = true,
						wh3_main_chaos_region_kislev = true,
						wh3_main_chaos_region_praag = true
					}
				}
			},
			main_warhammer = {
				wh3_dlc24_mission_schemes_norsca_minor_3 = {
					total = 3,
					regions = {
						wh3_main_combi_region_erengrad = true,
						wh3_main_combi_region_kislev = true,
						wh3_main_combi_region_praag = true
					}
				},
				wh3_dlc24_mission_schemes_naggaroth_minor_2 = {
					total = 3,
					regions = {
						wh3_main_combi_region_ancient_city_of_quintex = true,
						wh3_main_combi_region_har_ganeth = true,
						wh3_main_combi_region_naggarond = true
					}
				}
			}
		},
		rift_gem_missions = { -- Schemes which grant a rift gem as a reward for success
			wh3_dlc24_mission_schemes_darklands_grand = true,
			wh3_dlc24_mission_schemes_grand_cathay_grand = true,
			wh3_dlc24_mission_schemes_the_empire_minor_2 = true,
			wh3_dlc24_mission_schemes_the_empire_grand = true,
			wh3_dlc24_mission_schemes_chaos_wastes_grand = true,
			wh3_dlc24_mission_schemes_norsca_grand = true,
			wh3_dlc24_mission_schemes_ulthuan_grand = true,
			wh3_dlc24_mission_schemes_lustria_grand = true,
			wh3_dlc24_mission_schemes_naggaroth_grand = true,
			wh3_dlc24_mission_schemes_badlands_grand = true,
			wh3_dlc24_mission_schemes_bretonnia_grand = true
		},
		hidden_cultist_missions = { -- Schemes which grant a hidden_cultist as a reward for success
			wh3_dlc24_mission_schemes_darklands_minor_2 = true,
			wh3_dlc24_mission_schemes_grand_cathay_minor_4 = true,
			wh3_dlc24_mission_schemes_norsca_minor_3 = true,
			wh3_dlc24_mission_schemes_the_empire_minor_4 = true,
			wh3_dlc24_mission_schemes_chaos_wastes_minor_2 = true,
			wh3_dlc24_mission_schemes_chaos_wastes_minor_4 = true,
			wh3_dlc24_mission_schemes_ulthuan_minor_3 = true,
			wh3_dlc24_mission_schemes_lustria_minor_3 = true,
			wh3_dlc24_mission_schemes_naggaroth_minor_2 = true,
			wh3_dlc24_mission_schemes_badlands_minor_3 = true,
			wh3_dlc24_mission_schemes_bretonnia_minor_3 = true
		},
		mission_to_agent_subtype = { -- Schemes which grant a form as a reward for success
			wh3_dlc24_mission_schemes_norsca_minor_3 = {"wh3_main_ksl_katarin","wh3_main_ksl_kostaltyn","wh3_dlc24_ksl_mother_ostankya"},
			wh3_dlc24_mission_schemes_naggaroth_minor_2 = {"wh2_main_def_morathi","wh2_dlc10_def_crone_hellebron","wh2_main_def_malekith"},
			wh3_dlc24_mission_schemes_darklands_grand = {"wh3_dlc23_chd_gorduz_backstabber"},
			wh3_dlc24_mission_schemes_norsca_minor_2 = {"wh2_dlc16_skv_ghoritch"},
			wh3_dlc24_mission_schemes_norsca_minor_5 = {"wh_dlc08_nor_wulfrik","wh_dlc08_nor_throgg"},
			wh3_dlc24_mission_schemes_the_empire_grand = {"wh3_dlc24_tze_aekold_helbrass"},
			wh3_dlc24_mission_schemes_bretonnia_grand = {"wh_dlc07_brt_green_knight"},
			wh3_dlc24_mission_schemes_lustria_grand = {"wh2_dlc12_lzd_lord_kroak"},
			wh3_dlc24_mission_schemes_ulthuan_grand = {"wh3_dlc24_tze_blue_scribes"},
			wh3_dlc24_mission_schemes_chaos_wastes_grand = {"wh3_dlc24_tze_blue_scribes"}
		},
		form_agent_subtype_to_mission = { -- All schemes which require the Changeling to obtain a form as an objective
			wh3_dlc23_chd_astragoth = "wh3_dlc24_mission_schemes_darklands_minor_3",
			wh3_main_cth_zhao_ming = "wh3_dlc24_mission_schemes_grand_cathay_minor_3",
			wh_dlc05_wef_orion = "wh3_dlc24_mission_schemes_bretonnia_minor_3",
			wh2_main_lzd_lord_mazdamundi = "wh3_dlc24_mission_schemes_lustria_minor_2",
			wh2_dlc10_hef_alarielle = "wh3_dlc24_mission_schemes_ulthuan_minor_2",
			wh2_dlc14_skv_deathmaster_snikch = "wh3_dlc24_mission_schemes_grand_cathay_minor_6",
			wh3_main_kho_skarbrand = "wh3_dlc24_mission_schemes_badlands_minor_2"
		},
		ror_locks = {
			all = {
				wh_main_emp_veh_steam_tank = "wh3_dlc24_lock_steam_tank_ror",
				wh_dlc08_nor_mon_frost_wyrm_ror_0 = "wh3_dlc24_lock_frost_wyrm_ror"
			},
			main_warhammer = {
				wh3_dlc24_lzd_mon_carnosaur_0 = "wh3_dlc24_lock_feral_carnosaur_ror_ie"
			},
			wh3_main_chaos = {
				wh3_dlc24_lzd_mon_carnosaur_0 = "wh3_dlc24_lock_feral_carnosaur_ror_roc"
			}
		},
		mission_to_ror_unlock = {
			wh3_dlc24_mission_schemes_norsca_grand = {"wh_dlc08_nor_mon_frost_wyrm_ror_0"},
			wh3_dlc24_mission_schemes_the_empire_minor_3 = {"wh_main_emp_veh_steam_tank"},
			wh3_dlc24_mission_schemes_lustria_grand = {"wh3_dlc24_lzd_mon_carnosaur_0"},
		},
		schemes_rewards_dummy_bundle_key = "wh3_dlc24_mission_schemes_scheme_rewards_dummy",
		schemes_rewards_bundle_key = "wh3_dlc24_mission_schemes_scheme_rewards",
		mission_to_schemes_rewards_effects = {
			wh3_dlc24_mission_schemes_chaos_wastes_minor_3 = true,
			wh3_dlc24_mission_schemes_chaos_wastes_minor_4 = true,
			wh3_dlc24_mission_schemes_chaos_wastes_minor_5 = true,
			wh3_dlc24_mission_schemes_darklands_minor_2 = true,
			wh3_dlc24_mission_schemes_darklands_minor_4 = true,
			wh3_dlc24_mission_schemes_darklands_minor_5 = true,
			wh3_dlc24_mission_schemes_darklands_minor_6 = true,
			wh3_dlc24_mission_schemes_grand_cathay_minor_4 = true,
			wh3_dlc24_mission_schemes_grand_cathay_minor_5 = true,
			wh3_dlc24_mission_schemes_grand_cathay_minor_7_roc = true,
			wh3_dlc24_mission_schemes_grand_cathay_minor_7_ie = true,
			wh3_dlc24_mission_schemes_the_empire_minor_2 = true,
			wh3_dlc24_mission_schemes_the_empire_minor_4 = true,
			wh3_dlc24_mission_schemes_the_empire_minor_5 = true,
			wh3_dlc24_mission_schemes_the_empire_minor_6 = true,
			wh3_dlc24_mission_schemes_badlands_minor_4 = true,
			wh3_dlc24_mission_schemes_badlands_minor_5 = true,
			wh3_dlc24_mission_schemes_bretonnia_minor_4 = true,
			wh3_dlc24_mission_schemes_bretonnia_minor_5 = true,
			wh3_dlc24_mission_schemes_bretonnia_grand = true,
			wh3_dlc24_mission_schemes_lustria_minor_3 = true,
			wh3_dlc24_mission_schemes_lustria_minor_4 = true,
			wh3_dlc24_mission_schemes_lustria_minor_5 = true,
			wh3_dlc24_mission_schemes_naggaroth_minor_3 = true,
			wh3_dlc24_mission_schemes_naggaroth_minor_5 = true,
			wh3_dlc24_mission_schemes_ulthuan_minor_4 = true,
			wh3_dlc24_mission_schemes_chaos_wastes_grand = true,
			wh3_dlc24_mission_schemes_grand_cathay_grand = true,
			wh3_dlc24_mission_schemes_norsca_grand = true,
			wh3_dlc24_mission_schemes_norsca_minor_4 = true,
			wh3_dlc24_mission_schemes_norsca_minor_5 = true,
			wh3_dlc24_mission_schemes_the_empire_grand = true,
			wh3_dlc24_mission_schemes_darklands_grand = true,
			wh3_dlc24_mission_schemes_lustria_grand = true,
			wh3_dlc24_mission_schemes_ulthuan_grand = true
		},
		schemes_complete = {},
	},
	formless_horror = {
		von_carsteins = {
			wh_pro02_vmp_isabella_von_carstein_hero = true,
			wh_pro02_vmp_isabella_von_carstein = true,
			wh_dlc04_vmp_vlad_von_carstein_hero = true,
			wh_dlc04_vmp_vlad_con_carstein = true
		},
		player_free_forms = { -- One is randomly given to the Changeling at campaign start if they're a player
			"wh_dlc08_nor_wulfrik",
			"wh_main_emp_karl_franz",
			"wh_main_grn_grimgor_ironhide",
			"wh_main_vmp_mannfred_von_carstein",
			"wh3_dlc20_kho_valkia",
			"wh3_dlc20_nur_festus",
			"wh3_dlc20_sla_azazel",
			"wh3_dlc20_tze_vilitch",
			"wh3_main_ogr_skrag_the_slaughterer",
			"wh3_main_nur_kugath",
			"wh3_main_sla_nkari",
			"wh3_main_tze_kairos",
			"wh3_main_ksl_katarin"
		},
		ai_free_forms = { -- Given to the Changeling at campaign start if they're under AI control
			"wh_dlc08_nor_wulfrik",
			"wh_main_emp_karl_franz",
			"wh_main_grn_grimgor_ironhide",
			"wh_main_vmp_mannfred_von_carstein",
			"wh3_dlc23_chd_astragoth",
			"wh3_dlc20_kho_valkia",
			"wh3_dlc20_nur_festus",
			"wh3_dlc20_sla_azazel",
			"wh3_dlc20_tze_vilitch",
			"wh3_main_ogr_skrag_the_slaughterer",
			"wh3_main_kho_skarbrand",
			"wh3_main_nur_kugath",
			"wh3_main_sla_nkari",
			"wh3_main_tze_kairos",
			"wh3_main_ksl_katarin"
		},
		unlocked_agent_subtypes = {}
	},
	cult_region_composite_scene = "wh3_dlc24_campaign_changeling_settlement",
	cult_region_vfx_prefix = "changeling_cult_",
}

function the_changeling_features:initialise()

	self.campaign_name = cm:get_campaign_name()
	local faction = cm:get_faction(self.faction_key)
	
	if not faction then return end
	
	local faction_cqi = faction:command_queue_index()

	if cm:is_new_game() then
		self:update_victory_conditions_text()

		-- Embed the starting hero into the changeling's army
		local force = faction:faction_leader():military_force()
		local character_list = faction:character_list()
		for i = 1,  character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			local subtype_key = character:character_subtype_key()
			if subtype_key ~= "wh3_dlc24_tze_the_changeling" and subtype_key ~= self.cultist_subtype then
				cm:embed_agent_in_force(character, force)
			end
		end

		-- Lock all the script locked techs involving rifts
		for tech_key, _ in pairs(self.rift_regions[self.campaign_name]) do
			cm:lock_technology(self.faction_key, tech_key)
		end
		
		-- Set the startpos characters to be immune to trespassing
		local character_list = faction:character_list()
		for i = 0, character_list:num_items() -1 do
			cm:set_character_excluded_from_trespassing(character_list:item_at(i), true)
		end
		
		if faction:is_human() then
			-- Disable event feed events for schemes triggered by script
			cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")

			-- Get the CQIs for characters that are involved in schemes, and supply them to the missions that require them
			local grimgor_cqi = cm:get_faction("wh_main_grn_greenskins"):faction_leader():command_queue_index()
			self.schemes.missions.all.wh3_dlc24_mission_schemes_darklands_minor_6.objectives[1].conditions[1] = "character "..grimgor_cqi
			
			local imrik_cqi = cm:get_faction("wh2_dlc15_hef_imrik"):faction_leader():command_queue_index()
			self.schemes.missions.all.wh3_dlc24_mission_schemes_darklands_minor_7.objectives[1].conditions[1] = "character "..imrik_cqi
			
			if self.campaign_name == "main_warhammer" then
				local grombrindal_cqi = cm:get_faction("wh3_main_dwf_the_ancestral_throng"):faction_leader():command_queue_index()
				self.schemes.missions[self.campaign_name].wh3_dlc24_mission_schemes_naggaroth_minor_4.objectives[1].conditions[1] = "character "..grombrindal_cqi
			end

			-- Trigger schemes that are shared across both campaigns
			self:trigger_scripted_mission(self.schemes.missions.all)

			-- Trigger schemes that are unique to the campaign (e.g. Grand/Ultimate schemes, or schemes with targeted locations)
			self:trigger_scripted_mission(self.schemes.missions[self.campaign_name])

			-- Reenable the event feed for missions
			cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "")

			-- Add markers for each of the Trickster Rift nodes, to show the player where they will appear
			for rift_node, coords in pairs(self.rift_markers_tech[self.campaign_name]) do
				cm:add_interactable_campaign_marker(rift_node, "wh3_dlc24_the_changeling_rifts_tech", coords.x, coords.y, 2, self.faction_key)
				local region =  cm:get_region_data_at_position(coords.x, coords.y)
				if region and not region:is_null_interface() then
					cm:make_region_seen_in_shroud("wh3_dlc24_tze_the_deceivers", region:key())
				end
			end
			for rift_node, coords in pairs(self.rift_markers_schemes[self.campaign_name]) do
				cm:add_interactable_campaign_marker(rift_node, "wh3_dlc24_the_changeling_rifts_schemes", coords.x, coords.y, 2, self.faction_key)
				local region =  cm:get_region_data_at_position(coords.x, coords.y)
				if region and not region:is_null_interface() then
					cm:make_region_seen_in_shroud("wh3_dlc24_tze_the_deceivers", region:key())
				end
			end

		else
			-- Give the AI a selection of formless horror forms to start with
			self:grant_formless_horror_form(self.formless_horror.ai_free_forms, faction_cqi)
		end

		cm:set_saved_value("the_changeling_schemes_complete", self.schemes.schemes_complete)
		cm:set_saved_value("the_changeling_schemes_grand_scheme_objectives", self.schemes.grand_scheme_objectives)
		cm:set_saved_value("the_changeling_agent_subtypes_unlocked", self.formless_horror.unlocked_agent_subtypes)
		cm:set_saved_value("the_changeling_schemes_rewards_bundle", {})
		cm:set_saved_value("the_changeling_cultist_agent_action_key", false)
		cm:set_saved_value("the_changeling_ultimate_battle_strings", self.schemes.ultimate_battle_strings)
		cm:set_saved_value("the_changeling_rift_tech_unlock", false)

		-- RoR unit locking
		for unit, reason in pairs(self.schemes.ror_locks.all) do
			cm:add_event_restricted_unit_record_for_faction(unit, self.faction_key, reason)
		end

		for unit, reason in pairs(self.schemes.ror_locks[self.campaign_name]) do
			cm:add_event_restricted_unit_record_for_faction(unit, self.faction_key, reason)
		end

		-- Add composite scene VFX for any settlements that have cults in the start pos
		local foreign_slots = faction:foreign_slot_managers()
		for i = 0, foreign_slots:num_items() -1 do
			self:change_composite_scene_in_region(foreign_slots:item_at(i):region(), true)
		end
	else
		self.schemes.schemes_complete = cm:get_saved_value("the_changeling_schemes_complete")
		self.schemes.grand_scheme_objectives = cm:get_saved_value("the_changeling_schemes_grand_scheme_objectives")
		self.formless_horror.unlocked_agent_subtypes = cm:get_saved_value("the_changeling_agent_subtypes_unlocked") or {}
	end

	-- Update the icons for the schemes in the schemes panel
	local the_changeling_schemes_icons = {}

	for mission_key, mission_data in pairs(self.schemes.missions.all) do
		the_changeling_schemes_icons[mission_key] = mission_data.icon
		
		-- junction the shared ultimate scheme army keys to grand scheme mission keys for UI to introspect
		local army_key = mission_data.ultimate_scheme_battle_army
		
		if army_key then
			common.set_context_value(army_key, mission_key)
		end
	end

	for mission_key, mission_data in pairs(self.schemes.missions[self.campaign_name]) do
		the_changeling_schemes_icons[mission_key] = mission_data.icon
		-- junction the campaign specific ultimate scheme army keys to grand scheme mission keys for UI to introspect
		local army_key = mission_data.ultimate_scheme_battle_army
		
		if army_key then
			common.set_context_value(army_key, mission_key)
		end
	end

	common.set_context_value("the_changeling_schemes_icons", the_changeling_schemes_icons)
	
	-- update rift tech zoom locations
	for tech_key, rift_id in pairs(self.rift_regions[self.campaign_name]) do
		common.set_context_value(tech_key .. "_coords", self.rift_markers_tech[self.campaign_name][rift_id])
	end

	core:add_listener(
		"the_changeling_hidden_cults_faction_turn_start",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context)
			local faction = context:faction()
			local cults = faction:foreign_slot_managers()
			
			for cult_index = 0, cults:num_items() - 1 do
				local cult = cults:item_at(cult_index)
				local region = cult:region()

				-- Expand cults
				local expand_chance = cm:get_regions_bonus_value(region, self.cult_expansion_chance_bonus_value)
				out("The Changeling hidden cult expansion - "..region:name())
					
				if expand_chance > 0 then
					out("\tChance - "..tostring(expand_chance).."%")
					if cm:model():random_percent(expand_chance) then
						out("\t\tSuccess!")
						local adjacent_region_list = region:adjacent_region_list()
						
						for adjacent_region_index = 0, adjacent_region_list:num_items() - 1 do
							local possible_region = adjacent_region_list:item_at(adjacent_region_index)
							local possible_region_key = possible_region:name()
							out("\t\tAdjacent Region: "..possible_region_key)
							
							if possible_region:is_abandoned() == false and possible_region:owning_faction():is_null_interface() == false and possible_region:owning_faction():name() ~= self.faction_key then
								local slot_manager = possible_region:foreign_slot_manager_for_faction(self.faction_key)
								
								if slot_manager:is_null_interface() == true then
									out("\t\t\tAccepting Region: "..possible_region_key)
									local region_cqi = possible_region:cqi()
									cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region_cqi, self.slot_set)
									cm:make_region_visible_in_shroud(self.faction_key, possible_region_key)
									
									-- Tell The Changeling
									if faction:is_human() then
										cm:trigger_incident_with_targets(
											faction:command_queue_index(),
											"wh3_dlc24_incident_tze_the_changeling_cult_expanded_passively",
											0,
											0,
											0,
											0,
											region_cqi,
											0
										)
									end

									break
								end
							end
						end
					end
				end

			end
			
		end,
		true
	)

	--Gives AI changeling a random form every 3 turns
	if faction:is_human() == false then
		core:add_listener(
			"the_changeling_ai_formless_horror",
			"WorldStartRound",
			function()
				local changeling_faction = cm:get_faction(self.faction_key)
				return changeling_faction:is_dead() == false and changeling_faction:was_confederated() == false and cm:turn_number() % 3 == 1
			end,
			function()
				local random_forms = {}
				for form, _ in pairs(self.formless_horror.unlocked_agent_subtypes) do
					table.insert(random_forms, form)
				end

				if #random_forms > 0 then
					local chosen_random_form = random_forms[cm:random_number(#random_forms, 1)]
					out("Equipping random Formless Horror form for the Changeling AI. Chosen form is: "..chosen_random_form)
					cm:equip_transformable_unit(cm:get_faction(self.faction_key):command_queue_index(), chosen_random_form)
				end
			end,
			true
		)
	end

	-- Removed the orb of tzeentch if the starter hero dies
	core:add_listener(
		"the_changeling_orbkeeper_dies",
		"CharacterDestroyed",
		function(context)
			local character = context:family_member():character_details()
			return not character:is_null_interface() and character:forename("names_name_1037444888")
		end,
		function(context)
			local character_faction = context:family_member():character_details():faction()
			if not character_faction:is_null_interface() then
				cm:force_remove_ancillary_from_faction(character_faction, "wh3_dlc24_anc_talisman_magic_orb")
			end
		end,
		true
	)

	-- Listener for the various buildings that remove the cult entirely upon completion
	core:add_listener(
		"the_changeling_capstone_buildings",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			return context:slot_manager():faction():name() == self.faction_key
		end,
		function(context)
			local building_key = context:building()
			local slot_manager = context:slot_manager()
			local region = slot_manager:region()
			local region_key = region:name()
			local dismantle = false

			if building_key == "wh3_dlc24_tze_the_changeling_raise_army_parasitic_2" then
				-- Spawn random army of Chaos Demon rebels
				self:trigger_rebellion(region)
				local chaos_rebel_mission = self.schemes.chaos_rebel_regions_to_mission[region_key]
				if chaos_rebel_mission then
					self:complete_objective(chaos_rebel_mission)
				end
				dismantle = true
			elseif building_key == "wh3_dlc24_tze_the_changeling_raise_army_symbiotic_2" then
				-- Spawn army for The Changeling
				self:cult_army_raised(region_key)
				dismantle = true
			elseif building_key == "wh3_dlc24_tze_the_changeling_plunder_2" then
				-- Spawn army for The Changeling
				self:sack_settlement(region)
				dismantle = true
			end

			-- If we need to auto-dismantle the building, find the slot it's built in and destroy it
			if dismantle == true then
				local slot_list = slot_manager:slots()
				for i = 0, slot_list:num_items() - 1 do
					local slot = slot_list:item_at(i)
					if slot:has_building() and slot:building() == building_key then
						cm:foreign_slot_instantly_dismantle_building(slot)
						break
					end
				end
			end

			-- Build a hidden expansion building in Pigbarter
			if not self.schemes.schemes_complete["wh3_dlc24_mission_schemes_darklands_minor_2"] then
				if string.match(region_key, "pigbarter") and (building_key == "wh3_dlc24_tze_the_changeling_expansion_parasitic_3" or building_key == "wh3_dlc24_tze_the_changeling_expansion_symbiotic_3") then
					self:complete_objective("wh3_dlc24_mission_schemes_darklands_minor_2")
				end
			end		
			
		end,
		true
	)

	core:add_listener(
		"the_changeling_cult_discovered_incidents",
		"ForeignSlotManagerDiscoveredEvent",
		function(context)
			return context:owner():name() == self.faction_key
		end,
		function(context)
			local faction = context:owner()
			local region_cqi = context:slot_manager():region():cqi()
			local region_owner = context:discoveree()

			-- Tell The Changeling
			if faction:is_human() then
				cm:trigger_incident_with_targets(
					faction:command_queue_index(),
					"wh3_dlc24_incident_tze_cult_discovered_the_changeling",
					0,
					0,
					0,
					0,
					region_cqi,
					0
				)
			end
			
			-- Tell the region owner
			if region_owner:is_human() then
				cm:trigger_incident_with_targets(
					region_owner:command_queue_index(),
					"wh3_dlc24_incident_tze_cult_discovered_region_owner",
					0,
					0,
					0,
					0,
					region_cqi,
					0
				)
			end
			
		end,
		true
	)

	core:add_listener(
		"the_changeling_cult_removed",
		"ForeignSlotManagerRemovedEvent",
		function(context)
			return context:owner():name() == self.faction_key
		end,
		function(context)
			local remover = context:remover()
			local region = context:region()
			local region_key = region:name()
			local settlement_x = region:settlement():logical_position_x()
			local settlement_y = region:settlement():logical_position_y()
			local cause_was_razing = context:cause_was_razing()
			local event_region = "regions_onscreen_" .. region_key
			
			if cause_was_razing then
				-- Tell The Changeling their region was razed
				cm:show_message_event_located(
					self.faction_key,
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_title",
					event_region,
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_razing_description",
					settlement_x,
					settlement_y,
					false,
					126
				)
			else
				-- Tell The Changeling they were removed
				cm:show_message_event_located(
					self.faction_key,
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_title",
					event_region,
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_description",
					settlement_x,
					settlement_y,
					false,
					126
				)
				
				-- Tell the region owner they removed a cult
				cm:show_message_event_located(
					remover:name(),
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_title",
					event_region,
					"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_cult_destroyed_remover_description",
					settlement_x,
					settlement_y,
					false,
					126
				)
			end

			self:change_composite_scene_in_region(region, false)

		end,
		true
	)

	core:add_listener(
		"the_changeling_cult_created",
		"ForeignSlotManagerCreatedEvent",
		function(context)
			return context:requesting_faction():name() == self.faction_key
		end,
		function(context)
			local region = context:region()

			self:change_composite_scene_in_region(region, true)
			self:check_cult_creation_scheme(region)
			local trickster_cultist = cm:get_saved_value("the_changeling_cultist_agent_action_key")
			if trickster_cultist then
				local foreign_slot_manager = region:foreign_slot_manager_for_faction(self.faction_key)
				if foreign_slot_manager:is_null_interface() == false and foreign_slot_manager:slots():item_at(0):template_key() == self.slot_template then
					for i = 1, #self.bonus_cultist_buildings[trickster_cultist] do
					cm:foreign_slot_instantly_upgrade_building(foreign_slot_manager:slots():item_at(i-1), self.bonus_cultist_buildings[trickster_cultist][i])
					end
				end
				cm:set_saved_value("the_changeling_cultist_agent_action_key", false)
			end
		end,
		true
	)

	-- Add trespass immunity to The Changeling's characters
	core:add_listener(
		"the_changeling_trespass_immunity",
		"CharacterCreated",
		function(context)
			return context:character():faction():name() == self.faction_key
		end,
		function(context)
			cm:set_character_excluded_from_trespassing(context:character(), true)
		end,
		true
	)

	-- Grant the form of legendary heroes when they are recruited
	core:add_listener(
		"the_changeling_formless_horror_unique_hero_recruited",
		"UniqueAgentSpawned",
		function(context)
			return context:unique_agent_details():character():faction():name() == self.faction_key
		end,
		function(context)
			local character = context:unique_agent_details():character()
			if not character:is_null_interface() then
				self:grant_formless_horror_form(character:character_subtype_key())
			end

		end,
		true
	)

	-- Unlock formless horror forms after the changeling defeats characters in battle
	core:add_listener(
		"the_changeling_formless_horror_defeated_in_battle",
		"CharacterCompletedBattle",
		function(context)
			local character = context:character()
			return character:character_subtype("wh3_dlc24_tze_the_changeling") and character:won_battle()
		end,
		function(context)
			local enemy_agent_subtype = self:get_enemy_subtypes()
			local the_changeling_faction_cqi = context:character():faction():command_queue_index()
			
			for i = 1, #enemy_agent_subtype do
				self:grant_formless_horror_form(enemy_agent_subtype[i], the_changeling_faction_cqi)
			end
		end,
	true
	)

	-- Cache the agent action used to create cults, as the foreign slot isn't created yet
	core:add_listener(
		"the_changeling_trickster_cultists_advanced_cults",
		"CharacterGarrisonTargetAction",
		function(context)
			return self.bonus_cultist_buildings[context:agent_action_key()]
		end,
		function(context)
			cm:set_saved_value("the_changeling_cultist_agent_action_key", context:agent_action_key())
		end,
		true
	)

	core:add_listener(
		"the_changeling_settlement_sacked",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction()
			return context:settlement_option() == "occupation_decision_establish_foreign_slot" and faction and faction:is_null_interface() == false and faction:name() == self.faction_key
		end,
		function(context)
			local region = context:garrison_residence():region()

			if context:character():faction():is_human() then
				local mission = self.schemes.sack_regions_to_mission[region:name()]
				if mission then
					self:complete_objective(mission)
				end
			end
			
			local building_to_add = tostring(math.min(math.max(region:slot_list():item_at(0):building():building_level(), 1), 3)) -- cap between 1 and 3
			
			if context:occupation_decision() == "1160131797" then -- parasitic
				building_to_add = self.occupation_buildings.parasitic[cm:random_number(#self.occupation_buildings.parasitic)] .. building_to_add
			else -- symbiotic
				building_to_add = self.occupation_buildings.symbiotic[cm:random_number(#self.occupation_buildings.symbiotic)] .. building_to_add
			end
			
			cm:foreign_slot_instantly_upgrade_building(region:foreign_slot_manager_for_faction(self.faction_key):slots():item_at(0), building_to_add)
		end,
		true
	)

	core:add_listener(
		"the_changeling_formless_horror_allied_to_faction",
		"PositiveDiplomaticEvent",
		function(context)
			return (context:recipient():name() == self.faction_key or context:proposer():name() == self.faction_key) and (context:is_military_alliance() or context:is_defensive_alliance() or context:is_vassalage())
		end,
		function(context)
			local other_faction
			
			if context:proposer():name() == self.faction_key then
				other_faction = context:recipient()
			else
				other_faction = context:proposer()
			end
			
			local agent_subtype = other_faction:faction_leader():character_subtype_key()	

			if agent_subtype and is_string(agent_subtype) then
				self:grant_formless_horror_form(agent_subtype)
			end

			-- grant any legendary heroes within the faction
			for _, unique_agent in model_pairs(other_faction:unique_agents()) do
				local current_character = unique_agent:character()
				if not current_character:is_null_interface() then
					self:grant_formless_horror_form(current_character:character_subtype_key())
				end
			end
		end,
		true
	)

	-- Update the owned forms for the changeling when they are involved in confederation
	core:add_listener(
		"the_changeling_formless_horror_confederates_faction",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == self.faction_key or context:faction():name() == self.faction_key
		end,
		function(context)
			local confederation = context:confederation()
			local character_list = confederation:character_list()

			for i = 0,  character_list:num_items() - 1 do
				local character = character_list:item_at(i)
				local subtype_key = character:character_subtype_key()
				if subtype_key ~= "wh3_dlc24_tze_the_changeling" then
					self:grant_formless_horror_form(subtype_key, confederation:command_queue_index())
				end
			end
		end,
		true
	);
	
	-- The below listeners are all based around missions, teleport networks, and schemes, which aren't available to the AI
	if faction:is_human() then

		core:add_listener(
			"the_changeling_scripted_schemes_rewards",
			"CampaignEffectsBundleAwarded",
			function(context)
				return context:faction():name() == self.faction_key
			end,
			function()
				self:update_schemes_reward_bundle()
			end,
			true
		)

		-- Listener for the schemes which require The Changeling to spread Tzeentch corruption to certain regions/provinces, by any means
		core:add_listener(
			"the_changeling_corruption_schemes_faction_turn_start",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == self.faction_key
			end,
			function()
				for region_key, mission_key in pairs(self.schemes.corruption_regions_to_mission[self.campaign_name]) do
					if not self.schemes.schemes_complete[mission_key] then
						local corruption_in_region = cm:get_corruption_value_in_region(region_key, self.schemes.corruption_key)

						if corruption_in_region >= self.schemes.corruption_target then
							self:complete_objective(mission_key)
						end
					end
				end
			end,
			true
		)

		core:add_listener(
			"the_changeling_research_completed",
			"ResearchCompleted",
			function(context)
				return context:faction():name() == self.faction_key
			end,
			function(context)
				local technology_key = context:technology()
				local cultist_region_key = self.cultist_regions[technology_key]
				if cultist_region_key then
					self:spawn_cultist(cultist_region_key)
				end
				local rift_node = self.rift_regions[self.campaign_name][technology_key]
				if rift_node then
					self:open_rift(rift_node)
				end
			end,
			true
		)

		-- Scripted mission rewards
		core:add_listener(
			"the_changeling_scripted_scheme_rewards",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == self.faction_key 
			end,
			function(context)
				local mission_key = context:mission():mission_record_key()
				
				-- narrative mission to give free form
				if mission_key == "wh3_dlc24_camp_narrative_the_changeling_establish_cult_with_hero_01" then
					local player_free_forms = self.formless_horror.player_free_forms
					local turn_1_free_form = player_free_forms[cm:random_number(#player_free_forms)]
					self:grant_formless_horror_form(turn_1_free_form)
				end
				
				if string.match(mission_key, "mission_schemes") then

					-- Grant rift gems as a scheme reward
					if self.schemes.rift_gem_missions[mission_key] then
						cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc24_tze_rift_gems", "schemes", 1)
					end

					-- Grant hidden cultists as a scheme reward
					if self.schemes.hidden_cultist_missions[mission_key] then
						cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc24_tze_hidden_cultists", "schemes", 1)
					end
					
					-- Initial rift scheme in sylvania which grants a rift gem and opens the first rift
					if mission_key == "wh3_dlc24_mission_schemes_the_empire_minor_2" then
						if self.campaign_name == "main_warhammer" then
							self:open_rift("wh3_dlc24_the_changeling_rifts_combi_the_empire_castle_drakenhof")
						elseif self.campaign_name == "wh3_main_chaos" then
							self:open_rift("wh3_dlc24_the_changeling_rifts_chaos_the_empire_castle_drakenhof")
						end
						local tech_unlocked = cm:get_saved_value("the_changeling_rift_tech_unlock") or false
						if not tech_unlocked then
							cm:set_saved_value("the_changeling_rift_tech_unlock", true)
							core:remove_listener("the_changeling_rift_tech_unlock")
							for tech_key, _ in pairs(self.rift_regions[self.campaign_name]) do
								cm:unlock_technology(self.faction_key, tech_key)
							end
						end
					end

					-- Passive corruption spread in all of Cathay
					if mission_key == "wh3_dlc24_mission_schemes_grand_cathay_minor_5" then
						local region_list = cm:model():world():region_manager():region_list()
						for i = 0, region_list:num_items() - 1 do
							local region = region_list:item_at(i)
							if region:is_province_capital() and (region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_grand_cathay") or region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_grand_cathay")) then
								local effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_the_changeling_schemes_regional_corruption")
								effect_bundle:set_duration(10)
								effect_bundle:add_effect("wh3_main_effect_corruption_tzeentch_events_bad", "region_to_province_own", 3)
								cm:apply_custom_effect_bundle_to_region(effect_bundle, region)
							end
						end	 
					end

					-- Spawn beastmen in wood elf capitals around the world
					if mission_key == "wh3_dlc24_mission_schemes_bretonnia_minor_5" then
						for _, potential_faction in model_pairs(cm:model():world():faction_list()) do
							if potential_faction:subculture() == "wh_dlc05_sc_wef_wood_elves" and not potential_faction:is_dead() and not potential_faction:was_confederated() and potential_faction:has_home_region() then
								local home_region = potential_faction:home_region()
								cm:force_rebellion_with_faction(home_region, "wh_dlc03_bst_beastmen_rebels", 19, true, false) 
							end
						end
					end

					-- Vandalise the buildings in The Witchwood and spawn greenskin rebels in the adjacent region accessible by land
					if mission_key == "wh3_dlc24_mission_schemes_naggaroth_minor_3" then
						local witchwood_slot_list = cm:get_region("wh3_main_combi_region_the_witchwood"):slot_list()

						for i = 1, witchwood_slot_list:num_items() -1 do -- Start at 1 to skip the primary chain
							local witchwood_slot = witchwood_slot_list:item_at(i)
							if witchwood_slot:active() then
								local vandal_building = "wh_main_special_greenskin_vandalisation_"..cm:random_number(5, 1)
								cm:instantly_upgrade_building_in_region(witchwood_slot, vandal_building)
							end
						end

						local witchwood_adjacent_regions = { -- The region list is a bit different to adjacent_region_list() as we don't want regions that are on the other side of the mountains to the south
							"wh3_main_combi_region_hag_hall",
							"wh3_main_combi_region_plain_of_dogs",
							"wh3_main_combi_region_plain_of_spiders",
							"wh3_main_combi_region_temple_of_addaioth"
						}

						for i = 1, #witchwood_adjacent_regions do
							cm:force_rebellion_with_faction(cm:get_region(witchwood_adjacent_regions[i]), "wh_main_grn_greenskins_rebels", 19, true, false) 
						end
					end

					-- Offer The Changeling the sword of khaine after the shrine of khaine mission
					if mission_key == "wh3_dlc24_mission_schemes_ulthuan_minor_3" then
						local sword_of_khaine_character, sword_of_khaine_faction = sword_of_khaine:get_sword_owner()
						if sword_of_khaine_faction ~= self.faction_key then
							local the_changeling_character = context:faction():faction_leader()
							sword_of_khaine:transfer_sword_after_battle(the_changeling_character)
						end
					end

					-- Spawn chaos rebels in Ulthuan after the gates are sacked
					if mission_key == "wh3_dlc24_mission_schemes_ulthuan_minor_4" then
						local inner_ring_regions = {
							"wh3_main_combi_region_angerrial",
							"wh3_main_combi_region_evershale",
							"wh3_main_combi_region_port_elistor",
							"wh3_main_combi_region_tor_elyr",
							"wh3_main_combi_region_tor_finu",
							"wh3_main_combi_region_tor_saroir",
							"wh3_main_combi_region_tower_of_lysean",
							"wh3_main_combi_region_white_tower_of_hoeth",
							"wh3_main_combi_region_whitefire_tor"
						}
						for i = 1, #inner_ring_regions do
							local current_inner_ring_region = cm:get_region(inner_ring_regions[i])
							self:trigger_rebellion(current_inner_ring_region, nil, true)
						end
					end

					-- Unlock any restricted units associated with the scheme
					local ror_unlock = self.schemes.mission_to_ror_unlock[mission_key]
					if ror_unlock ~= nil then
						for i = 1, #ror_unlock do
							cm:remove_event_restricted_unit_record_for_faction(ror_unlock[i], self.faction_key)
						end

						-- Bonus unlock for the carnosaur in roc
						if mission_key == "wh3_dlc24_mission_schemes_norsca_minor_2" and self.campaign_name == "wh3_main_chaos" then
							cm:remove_event_restricted_unit_record_for_faction("wh3_dlc24_lzd_mon_carnosaur_0", self.faction_key)
						end
					end

					local form_rewards = self.schemes.mission_to_agent_subtype[mission_key]
					if form_rewards ~= nil then
						self:grant_formless_horror_form(form_rewards)
					end

					if mission_key == "wh3_dlc24_mission_schemes_badlands_grand" then
						cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_badlands_grand_scheme")
					end

					if mission_key == "wh3_dlc24_mission_schemes_bretonnia_grand" then
						self:grand_scheme_bretonnia()
					end

					if mission_key == "wh3_dlc24_mission_schemes_chaos_wastes_grand" then
						cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_chaos_wastes_grand_scheme")
					end

					if mission_key == "wh3_dlc24_mission_schemes_darklands_grand" then
						self:grand_scheme_darklands()
					end

					if mission_key == "wh3_dlc24_mission_schemes_grand_cathay_grand" then
						cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_grand_cathay_grand_scheme_"..self.campaign_name)
					end

					if mission_key == "wh3_dlc24_mission_schemes_lustria_grand" then
						self:grand_scheme_lustria()
					end

					if mission_key == "wh3_dlc24_mission_schemes_naggaroth_grand" then
						cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_naggaroth_grand_scheme")
					end

					if mission_key == "wh3_dlc24_mission_schemes_norsca_grand" then
						if self.campaign_name == "main_warhammer" then
							cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_norsca_grand_scheme")
						else
							self:grand_scheme_norsca("cathay")
						end
					end
					
					if mission_key == "wh3_dlc24_mission_schemes_the_empire_grand" then
						cm:trigger_dilemma(self.faction_key, "wh3_dlc24_the_changeling_the_empire_grand_scheme")
					end

					if mission_key == "wh3_dlc24_mission_schemes_ulthuan_grand" then
						self:grand_scheme_ulthuan()
					end

					-- Check for grand scheme quest battle completion, and finish the theatre
					if string.match(mission_key, "grand_quest_battle") then
						cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
						local qb_string = "_quest_battle_"..self.campaign_name
						local grand_scheme = string.gsub(mission_key, qb_string, "")
						self:complete_objective(grand_scheme)
						cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1)
					else
						-- Check if we've done enough missions to trigger the Grand Scheme
						for grand_scheme, data in pairs(self.schemes.grand_scheme_to_missions) do
							if data.missions[mission_key] then
								self.schemes.grand_scheme_objectives[grand_scheme] = self.schemes.grand_scheme_objectives[grand_scheme] + 1
								cm:set_saved_value("the_changeling_schemes_grand_scheme_objectives", self.schemes.grand_scheme_objectives)
								if self.schemes.grand_scheme_objectives[grand_scheme] == data.total then
									local quest_battle = grand_scheme.."_quest_battle_"..self.campaign_name
									cm:trigger_mission(self.faction_key, quest_battle, true)
								end
								break
							end
						end
					end

					self.schemes.schemes_complete[mission_key] = true
					cm:set_saved_value("the_changeling_schemes_complete", self.schemes.schemes_complete)
				end

			end,
			true
		)

		-- Listener for the rift tech unlocks when the player has 2 rift gems
		local tech_unlocked = cm:get_saved_value("the_changeling_rift_tech_unlock") or false
		if not tech_unlocked then
			core:add_listener(
				"the_changeling_rift_tech_unlock",
				"PooledResourceChanged",
				function(context)
					return context:resource():key() == "wh3_dlc24_tze_rift_gems" and context:resource():value() >= 2 and context:faction():name() == self.faction_key
				end,
				function()
					local tech_unlock = cm:get_saved_value("the_changeling_rift_tech_unlock") or false
					if not tech_unlock then
						cm:set_saved_value("the_changeling_rift_tech_unlock", true)
						for tech_key, _ in pairs(self.rift_regions[self.campaign_name]) do
							cm:unlock_technology(self.faction_key, tech_key)
						end
					end
				end,
				false
			)
		end

		core:add_listener(
			"the_changeling_nukes_scheme",
			"PooledResourceChanged",
			function(context)
				return context:resource():key() == "skv_nuke" and context:faction():name() == self.faction_key
			end,
			function(context)
				if context:resource():value() > 0 then
					cm:apply_effect_bundle("wh2_dlc12_nuke_ability_enable", self.faction_key, 0)
				elseif context:resource():value() <= 0 then
					cm:remove_effect_bundle("wh2_dlc12_nuke_ability_enable", self.faction_key)
				end
			end,
			true
		)

		core:add_listener(
			"the_changeling_battle_completed_nuke_used",
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle()
				local the_changeling_faction_cqi = cm:get_faction(self.faction_key):command_queue_index()
				return pb:has_been_fought() and cm:pending_battle_cache_faction_is_involved(self.faction_key) and (pb:get_how_many_times_ability_has_been_used_in_battle(the_changeling_faction_cqi, "wh2_dlc12_army_abilities_warpstorm_doomrocket") > 0 or pb:get_how_many_times_ability_has_been_used_in_battle(the_changeling_faction_cqi, "wh2_dlc12_army_abilities_warpstorm_doomrocket") > 0)
			end,
			function()
				cm:faction_add_pooled_resource(self.faction_key, "skv_nuke", "consumed_in_battle", -1)
			end,
			true
		)

		-- Victory condition listeners
		local victory_complete = cm:get_saved_value("the_changeling_long_victory") or false
		if not victory_complete and cm:get_faction(self.faction_key):is_human() then
			core:add_listener(
				"the_changeling_victory_conditions",
				"MissionSucceeded",
				function(context)
					return context:faction():name() == self.faction_key
				end,
				function(context)
					local mission_key = context:mission():mission_record_key()
					if mission_key:ends_with("_grand") then
						local schemes_enacted = cm:get_saved_value("the_changeling_grand_scheme_complete") or 0
						schemes_enacted = schemes_enacted +1
						cm:set_saved_value("the_changeling_grand_scheme_complete", schemes_enacted)

						self:update_victory_conditions_text()

						-- Short victories are only in IE
						if self.campaign_name == "main_warhammer" and schemes_enacted == self.schemes.victory_conditions.short then
							cm:complete_scripted_mission_objective(self.faction_key, "wh_main_short_victory", "schemes", true)
						end

						-- The long victory is mostly the same in both campaigns, but IE needs more theatres complete
						if schemes_enacted == self.schemes.victory_conditions[self.campaign_name] then
							cm:complete_scripted_mission_objective(self.faction_key, "wh_main_long_victory", "schemes_grand", true)
							local final_battle = "wh3_dlc24_mission_schemes_ultimate_quest_battle_"..self.campaign_name
							cm:trigger_mission(self.faction_key, final_battle, true)
						end
					elseif mission_key == "wh3_dlc24_mission_schemes_ultimate_quest_battle_"..self.campaign_name then
						core:svr_save_registry_bool("the_changeling_win", true)
						cm:register_instant_movie("warhammer3/tze/the_changeling_win")
						
						cm:set_saved_value("the_changeling_long_victory", true)
						cm:complete_scripted_mission_objective(self.faction_key, "wh_main_long_victory", "schemes", true)
						core:remove_listener("the_changeling_victory_conditions")
					end
				end,
				true
			)
		end

		-- Grand scheme for Norsca, asking whether the player wants to direct Norsca to Ulthuan or Cathay
		core:add_listener(
			"the_changeling_grand_scheme_dilemmas",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:faction():name() == self.faction_key
			end,
			function(context)
				local choice = context:choice()

				if context:dilemma() == "wh3_dlc24_the_changeling_norsca_grand_scheme" then
					local theatre
					if choice == 0 then
						theatre = "ulthuan"
					elseif choice == 1 then
						theatre = "cathay"
					end
					self:grand_scheme_norsca(theatre)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_badlands_grand_scheme" then
					local region_key
					if choice == 0 then
						region_key = "wh3_main_combi_region_nonchang"
					elseif choice == 1 then
						region_key = "wh3_main_combi_region_castle_templehof"
					elseif choice == 2 then
						region_key = "wh3_main_combi_region_xlanhuapec"
					elseif choice == 3 then
						region_key = "wh3_main_combi_region_doomkeep"
					end
					self:grand_scheme_badlands(region_key)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_naggaroth_grand_scheme" then
					local region_key = ""
					if choice == 0 then
						region_key = "wh3_main_combi_region_shrine_of_khaine"
					elseif choice == 1 then
						region_key = "wh3_main_combi_region_fu_chow"
					elseif choice == 2 then
						region_key = "wh3_main_combi_region_sartosa"
					elseif choice == 3 then
						region_key = "wh3_main_combi_region_bitter_bay"
					end
					self:grand_scheme_naggaroth(region_key)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_grand_cathay_grand_scheme_main_warhammer" then
					local region_key, amount
					if choice == 0 then
						region_key = "wh3_main_combi_region_pigbarter"
						amount = 1
					elseif choice == 1 then
						region_key = "wh3_main_combi_region_great_turtle_isle"
						amount = 2
					end
					self:grand_scheme_grand_cathay(region_key, amount)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_grand_cathay_grand_scheme_wh3_main_chaos" then
					if choice == 0 then
						region_key = "wh3_main_chaos_region_pigbarter"
						amount = 1
					elseif choice == 1 then
						region_key = "wh3_main_chaos_region_fortress_of_eyes"
						amount = 2
					end
					self:grand_scheme_grand_cathay(region_key, amount)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_chaos_wastes_grand_scheme" then
					local regions
					local locked_army = true
					if choice == 0 then
						regions = {"wh3_main_chaos_region_novchozy"}
					elseif choice == 1 then
						regions = {"wh3_main_chaos_region_terracotta_graveyard"}
					elseif choice == 2 then
						regions = {"wh3_main_chaos_region_novchozy", "wh3_main_chaos_region_terracotta_graveyard"}
						locked_army = false
					end
					self:grand_scheme_chaos_wastes(regions, locked_army)

				elseif context:dilemma() == "wh3_dlc24_the_changeling_the_empire_grand_scheme" then
					local kislev = true
					local darklands = true
					local amount = 3
					if choice == 0 then
						darklands = false
					elseif choice == 1 then
						kislev = false
					elseif choice == 2 then
						amount = 1
					end
					self:grand_scheme_the_empire(kislev, darklands, amount)

				end
			end,
			true
		)

		core:add_listener(
			"the_changeling_schemes_land_battles_in_theatre",
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle()
				return cm:pending_battle_cache_faction_won_battle(self.faction_key) and pb:battle_type() == "land_normal" and not pb:region_data():region():is_null_interface()
			end,
			function()
				local region = cm:model():pending_battle():region_data():region()
				
				local chaos_wastes_mission = "wh3_dlc24_mission_schemes_chaos_wastes_minor_5"
				if not self.schemes.schemes_complete[chaos_wastes_mission] and region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_chaos_wastes") then
					local battles_won = cm:get_saved_value("the_changeling_chaos_wastes_land_battles") or 0
					battles_won = battles_won + 1
					cm:set_scripted_mission_text(chaos_wastes_mission, "schemes", "mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_win_battles", battles_won)
					if battles_won >= 15 then
						cm:complete_scripted_mission_objective(self.faction_key, chaos_wastes_mission, "schemes", true)
					end
					cm:set_saved_value("the_changeling_chaos_wastes_land_battles", battles_won)

				end

				local empire_mission = "wh3_dlc24_mission_schemes_the_empire_minor_4"
				if not self.schemes.schemes_complete[empire_mission] and (region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_the_empire") or region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_the_empire")) then
					local battles_won = cm:get_saved_value("the_changeling_the_empire_land_battles") or 0
					battles_won = battles_won + 1
					cm:set_scripted_mission_text(empire_mission, "schemes", "mission_text_text_wh3_dlc24_mission_schemes_the_empire_win_battles", battles_won)
					if battles_won >= 15 then
						cm:complete_scripted_mission_objective(self.faction_key, empire_mission, "schemes", true)
					end
					cm:set_saved_value("the_changeling_the_empire_land_battles", battles_won)

				end

				local cathay_mission = "wh3_dlc24_mission_schemes_grand_cathay_minor_2"
				if not self.schemes.schemes_complete[cathay_mission] and (region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_grand_cathay") or region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_grand_cathay")) then
					local battles_won = cm:get_saved_value("the_changeling_grand_cathay_land_battles") or 0
					battles_won = battles_won + 1
					cm:set_scripted_mission_text(cathay_mission, "schemes", "mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_win_battles", battles_won)
					if battles_won >= 15 then
						cm:complete_scripted_mission_objective(self.faction_key, cathay_mission, "schemes", true)
					end
					cm:set_saved_value("the_changeling_grand_cathay_land_battles", battles_won)

				end
			end,
			true
		)
		
		self:update_ultimate_battle_strings()

	end

end

-- Common function for updating victory condition text - counting the number of grand schemes completed
function the_changeling_features:update_victory_conditions_text()
	local schemes_enacted = cm:get_saved_value("the_changeling_grand_scheme_complete") or 0

	if self.campaign_name == "main_warhammer" then
		cm:set_scripted_mission_text("wh_main_short_victory", "schemes", "mission_text_text_wh3_dlc24_objective_the_changeling_short", schemes_enacted)
		cm:set_scripted_mission_text("wh_main_long_victory", "schemes_grand", "mission_text_text_wh3_dlc24_objective_the_changeling_long_grand_schemes_ie", schemes_enacted)
	else
		cm:set_scripted_mission_text("wh_main_long_victory", "schemes_grand", "mission_text_text_wh3_dlc24_objective_the_changeling_long_grand_schemes_roc", schemes_enacted)
	end
end

-- Common function for triggering the schemes which are handled entirely by script
function the_changeling_features:trigger_scripted_mission(mission_list)

	for mission, data in pairs(mission_list) do
		local mm = mission_manager:new(self.faction_key, mission)
		if data.objectives ~= nil then -- Make sure the mission has objectives before firing, else it'll fail to generate
			for i1 = 1, #data.objectives do
				if data.objectives[i1].type ~= nil then
					mm:add_new_objective(data.objectives[i1].type)
					for i2 = 1, #data.objectives[i1].conditions do
						mm:add_condition(data.objectives[i1].conditions[i2])
					end
				end
			end

			local payload_added = false

			-- Add payloads defined in the schemes.missions table
			if data.payload ~= nil then
				for i = 1, #data.payload do
					mm:add_payload(data.payload[i])
				end
				payload_added = true
			end
			
			-- Make sure the mission has a payload before firing, else it'll fail to generate
			if payload_added then
				mm:set_show_mission(false)
				mm:trigger()
			end
		end
	end
	
	-- set mission text/completion entities where necessary
	cm:set_scripted_mission_text("wh3_dlc24_mission_schemes_chaos_wastes_minor_5", "schemes", "mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_win_battles", 0)
	cm:set_scripted_mission_text("wh3_dlc24_mission_schemes_the_empire_minor_4", "schemes", "mission_text_text_wh3_dlc24_mission_schemes_the_empire_win_battles", 0)
	cm:set_scripted_mission_text("wh3_dlc24_mission_schemes_grand_cathay_minor_2", "schemes", "mission_text_text_wh3_dlc24_mission_schemes_grand_cathay_win_battles", 0)

	-- missions that require a list of regions
	for mission, data in pairs(self.schemes.mission_to_infiltration_regions[self.campaign_name]) do
		if data.show_count_in_mission_text then
			cm:set_scripted_mission_text(mission, "schemes", data.show_count_in_mission_text, 0)
		else
			local regions_to_add = {}
			for region, _ in pairs(data.regions) do
				table.insert(regions_to_add, {cm:get_region(region), false})
			end
			
			cm:set_scripted_mission_entity_completion_states(mission, "schemes", regions_to_add)
		end
	end
	
	-- missions that require faction leaders
	for _, faction in model_pairs(cm:model():world():faction_list()) do
		if not faction:is_dead() and faction:has_faction_leader() then
			local faction_leader = faction:faction_leader()
			local faction_leader_subtype = faction_leader:character_subtype_key()
			for agent_subtype, mission in pairs(self.schemes.form_agent_subtype_to_mission) do
				if faction_leader_subtype == agent_subtype then
					cm:set_scripted_mission_entity_completion_states(mission, "schemes", {{faction_leader, false}})
					break
				end
			end
		end
	end
	
	-- missions that require a specific region
	for region_key, mission in pairs(self.schemes.sack_regions_to_mission) do
		local region = cm:get_region(region_key)
		
		if region then
			cm:set_scripted_mission_entity_completion_states(mission, "schemes", {{region, false}})
		end
	end
	
	for region_key, mission in pairs(self.schemes.corruption_regions_to_mission[self.campaign_name]) do
		local region = cm:get_region(region_key)
		
		if region then
			cm:set_scripted_mission_entity_completion_states(mission, "schemes", {{region, false}})
		end
	end
	
	for region_key, mission in pairs(self.schemes.chaos_rebel_regions_to_mission) do
		local region = cm:get_region(region_key)
		
		if region then
			cm:set_scripted_mission_entity_completion_states(mission, "schemes", {{region, false}})
		end
	end
	
	if cm:get_campaign_name() == "main_warhammer" then
		cm:set_scripted_mission_entity_completion_states("wh3_dlc24_mission_schemes_darklands_minor_2", "schemes", {{cm:get_region("wh3_main_combi_region_pigbarter"), false}})
	else
		cm:set_scripted_mission_entity_completion_states("wh3_dlc24_mission_schemes_darklands_minor_2", "schemes", {{cm:get_region("wh3_main_chaos_region_pigbarter"), false}})
	end
end

-- Common function to grant formless horror forms
function the_changeling_features:grant_formless_horror_form(agent_subtype, faction_cqi)

	faction_cqi = faction_cqi or cm:get_faction(self.faction_key):command_queue_index()
	
	-- Isabella and Vlad are always unlocked as a pair, no matter how they are originally obtained
	if self.formless_horror.von_carsteins[agent_subtype] then
		agent_subtype = {"wh_pro02_vmp_isabella_von_carstein", "wh_dlc04_vmp_vlad_con_carstein"}
	end

	-- Convert any strings passed through to a table, to make it easier to handle unlocking multiple at the same time
	if is_string(agent_subtype) then
		agent_subtype = {agent_subtype}
	end


	for i = 1, #agent_subtype do
		local current_agent_subtype = agent_subtype[i]
		-- Before unlocking we need to make sure the agent subtype is valid in the current campaign, and that we haven't already unlocked it
		if cm:is_agent_transformation_available(current_agent_subtype) and not self.formless_horror.unlocked_agent_subtypes[current_agent_subtype] then
			self.formless_horror.unlocked_agent_subtypes[current_agent_subtype] = true
			cm:set_saved_value("the_changeling_agent_subtypes_unlocked", self.formless_horror.unlocked_agent_subtypes)
			cm:unlock_transformable_unit(faction_cqi, current_agent_subtype)
			out("Granting Formless Horror form to the Changeling: "..current_agent_subtype)
			local mission = self.schemes.form_agent_subtype_to_mission[current_agent_subtype]
			if mission then
				self:complete_objective(mission)
			end

			local faction = cm:model():faction_for_command_queue_index(faction_cqi)
			
			if faction:is_human() then
				cm:show_message_event(
					faction:name(),
					"event_feed_strings_text_wh3_dlc24_event_feed_scripted_the_changeling_new_form_title",
					"land_units_onscreen_name_" .. cco("CcoAgentSubtypeRecord", current_agent_subtype):Call("AssociatedUnitOverride.Key"),
					"event_feed_strings_text_wh3_dlc24_event_feed_scripted_the_changeling_new_form_secondary_detail",
					true,
					1500
				)
				
				core:trigger_event("ScriptEventChangelingGainsForm", faction)
			end
		end
	end
end

-- Damage buildings within the region and give The Changeling money based upon how developed it is
function the_changeling_features:sack_settlement(region)
	local region_owner = region:owning_faction()
	local slot_list = region:slot_list()
	local sacking_income = self.sacking_income_base
	local faction = cm:get_faction(self.faction_key)

	for i = 0, slot_list:num_items() -1 do
		local slot = slot_list:item_at(i)
		if slot:has_building() then
			local building = slot:building()
			local building_level = building:building_level() + 1
			local building_health = building:percent_health() / 100
			sacking_income = sacking_income + (self.sacking_income_per_building_level * building_level * building_health)
			cm:instant_set_building_health_percent(region:name(), building:name(), self.sacking_health)
		end
	end

	-- Tell The Changeling and give them the money
	if faction:is_human() then
		local incident_builder = cm:create_incident_builder("wh3_dlc24_incident_tze_the_changeling_settlement_sacked_the_changeling")
		local payload_builder = cm:create_payload()
		payload_builder:treasury_adjustment(math.floor(sacking_income))
		incident_builder:set_payload(payload_builder)
		incident_builder:add_target("default", region)
		cm:launch_custom_incident_from_builder(incident_builder, faction)
	else
		cm:treasury_mod(self.faction_key, sacking_income)
	end

	-- Tell the region owner
	if region_owner:is_human() then
		cm:trigger_incident_with_targets(
			region_owner:command_queue_index(),
			"wh3_dlc24_incident_tze_the_changeling_settlement_sacked_region_owner",
			faction:command_queue_index(),
			0,
			0,
			0,
			region_cqi,
			0
		)
	end	

	local mission = self.schemes.sack_regions_to_mission[region:name()]
	if mission then
		self:complete_objective(mission)
	end

end

-- Spawn an army of chaos rebels when the parasitic capstone army building is created
-- no_changeling_incident is optional. When set to true it'll not fire the incident
-- faction_key is optional. When set, it'll be used instead of a random rebel type
function the_changeling_features:trigger_rebellion(region, faction_key, no_changeling_incident)
	if is_string(region) then
		region = cm:get_region(region)
	end
	if region:is_abandoned() then
		return false
	end	
	local chaos_rebels = self.army_spawns.chaos_rebels
	faction_key = faction_key or chaos_rebels.factions[cm:random_number(#chaos_rebels.factions)]
	local faction = cm:get_faction(self.faction_key)

	local rebel_force = cm:force_rebellion_with_faction(region, faction_key, 19, true, false)

	if rebel_force:is_null_interface() then
		script_error("the_changeling_features:trigger_rebellion() called but no rebellion spawned - check the unit data!")
		return false
	end

	local rebel_force_cqi = rebel_force:command_queue_index()
	local region_owner = region:owning_faction()
	local region_cqi = region:cqi()

	-- Tell The Changeling
	if no_changeling_incident ~= true and faction:is_human() then
		cm:trigger_incident_with_targets(
			faction:command_queue_index(),
			chaos_rebels.incident_self,
			0,
			0,
			0,
			rebel_force_cqi,
			region_cqi,
			0
		)
	end

	-- Tell the region owner
	if region_owner:is_human() then
		cm:trigger_incident_with_targets(
			region_owner:command_queue_index(),
			chaos_rebels.incident_target,
			0,
			0,
			0,
			rebel_force_cqi,
			region_cqi,
			0
		)
	end
end

-- Spawn an army for The Changeling when the symbiotic capstone army building is created
function the_changeling_features:cult_army_raised(region_key)

	local ram = random_army_manager
	local army_template = self.army_spawns.the_changeling
	local force_key = army_template.force_key
	local unit_list = army_template.units
	local faction = cm:get_faction(self.faction_key)
	
	ram:remove_force(force_key)
	ram:new_force(force_key)
	
	-- Standard Army
	for unit_key, amount in pairs(unit_list) do
		ram:add_mandatory_unit(force_key, unit_key, amount)
	end
	
	local unit_count = random_army_manager:mandatory_unit_count(force_key)
	local spawn_units = random_army_manager:generate_force(force_key, unit_count, false)
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement( self.faction_key, region_key, false, false, 15)
	
	if pos_x > -1 then
		local region = cm:get_region(region_key)
		local region_owner = region:owning_faction()
		local region_cqi = region:cqi()
		local force_cqi = 0

		cm:create_force(
			self.faction_key,
			spawn_units,
			region_key,
			pos_x,
			pos_y,
			false,
			function(cqi, created_force_cqi)
				force_cqi = created_force_cqi
			end
		)
		
		-- Tell The Changeling
		if faction:is_human() then
			cm:trigger_incident_with_targets(
				faction:command_queue_index(),
				army_template.incident_self,
				0,
				0,
				0,
				force_cqi,
				region_cqi,
				0
			)
		end
		
		-- Tell the region owner
		if region_owner:is_human() then
			cm:trigger_incident_with_targets(
				region_owner:command_queue_index(),
				army_template.incident_target,
				0,
				0,
				0,
				force_cqi,
				region_cqi,
				0
			)
		end
	end
end

-- Make sure factions can actually declare war on a target before trying to declare war on them
function the_changeling_features:declare_war(attacking_faction, target_faction)
	if attacking_faction:is_null_interface() == false then
	
		local target_faction_key = target_faction:name()
		if target_faction:is_null_interface() == false and not target_faction:is_dead() and target_faction_key ~= "rebels" then 

			if target_faction:is_vassal() and target_faction:master():is_null_interface() == false then
				target_faction_key = target_faction:master():name()
			end

			local attacking_faction_key = attacking_faction:name()
			if attacking_faction_key ~= target_faction_key and attacking_faction:at_war_with(target_faction) == false and not attacking_faction:is_team_mate(target_faction) then
				cm:force_declare_war(attacking_faction_key, target_faction_key, false, false)
			end

		end
	end
end

function the_changeling_features:open_rift(rift_node)
	cm:teleportation_network_open_node(rift_node, self.rift_template)
	cm:remove_interactable_campaign_marker(rift_node)
end

function the_changeling_features:spawn_cultist(region_key, amount)
	amount = amount or 1
	for i = 1, amount do
		local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_key, region_key, false, true, 10)
		-- Prevent the spawned cultist from being auto selected
		local cultist = cm:create_agent(self.faction_key, self.cultist_type, self.cultist_subtype, agent_x, agent_y, true)
		if cultist then 
			cm:replenish_action_points(cm:char_lookup_str(cultist))
		end
	end
end


function the_changeling_features:check_cult_creation_scheme(region)

	-- The infiltrate anywhere schemes are intended to be the first scheme completed in each theatre, and reveal the shroud when complete
	for region_group, mission in pairs(self.schemes.region_groups_to_missions) do
		if not self.schemes.schemes_complete[mission] and region:is_contained_in_region_group(region_group) then
			self:complete_objective(mission)
			self:reveal_shroud_in_region_group(region_group)
			break
		end
	end

	-- Check completion of schemes that require infiltrating multiple regions
	for mission, data in pairs(self.schemes.mission_to_infiltration_regions[self.campaign_name]) do
		if not self.schemes.schemes_complete[mission] then
			if data.regions[region:name()] then
				local objective_complete = false
				local current_total = 0
				for current_region, _ in pairs(data.regions) do
					local foreign_slot_manager = cm:get_region(current_region):foreign_slot_manager_for_faction(self.faction_key)
					if foreign_slot_manager:is_null_interface() == false and foreign_slot_manager:slots():item_at(0):template_key() == self.slot_template then
						current_total = current_total + 1
						
						if data.show_count_in_mission_text then
							cm:set_scripted_mission_text(mission, "schemes", "mission_text_text_wh3_dlc24_mission_schemes_chaos_wastes_province_capitals_objective", current_total)
						else
							cm:set_scripted_mission_entity_completion_states(mission, "schemes", {{cm:get_region(current_region), true}})
						end
						
						if current_total == data.total then
							objective_complete = true
							break
						end
					end
				end

				if objective_complete then
					self:complete_objective(mission)
					break
				end

			end
		end
	end
	
end

-- Reveals the fog of war and shroud in a region for 1 turn, and then reverts back to fog of war
-- This should cause two way diplomatic discovery between both The Changeling and the opposing factions in the region
function the_changeling_features:reveal_shroud_in_region_group(region_group)
	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_contained_in_region_group(region_group) then
			cm:make_region_visible_in_shroud(self.faction_key, region:name())
		end
	end
end

-- Common function used for updating schemes objectives that have been completed
function the_changeling_features:complete_objective(mission)
	if not self.schemes.schemes_complete[mission] then
		if cm:get_faction(self.faction_key):is_human() then
			cm:complete_scripted_mission_objective(self.faction_key, mission, "schemes", true)
		end
	end
end

function the_changeling_features:get_enemy_subtypes()
	local pb = cm:model():pending_battle()
	local attacker_subtypes = {}
	local defender_subtypes = {}
	local was_attacker = false

	local num_attackers = cm:pending_battle_cache_num_attackers()
	local num_defenders = cm:pending_battle_cache_num_defenders()

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1
		num_defenders = 1
	end
	
	for i = 1, num_attackers do
		local char_subtype = cm:pending_battle_cache_get_attacker_subtype(i)
		
		if char_subtype == "wh3_dlc24_tze_the_changeling" then
			was_attacker = true
			break
		end

		if not was_attacker then
			table.insert(attacker_subtypes, char_subtype)
		
			local embedded_attacker_subtypes = cm:pending_battle_cache_get_attacker_embedded_character_subtypes(i)
			
			for j = 1, #embedded_attacker_subtypes do
				table.insert(attacker_subtypes, embedded_attacker_subtypes[j])
			end
		end
	end
	
	if was_attacker == false then
		return attacker_subtypes
	end
	
	for i = 1, num_defenders do
		local char_subtype = cm:pending_battle_cache_get_defender_subtype(i)
		
		table.insert(defender_subtypes, char_subtype)
		
		local embedded_defender_subtypes = cm:pending_battle_cache_get_defender_embedded_character_subtypes(i)
		
		for j = 1, #embedded_defender_subtypes do
			table.insert(defender_subtypes, embedded_defender_subtypes[j])
		end
	end

	return defender_subtypes
end

function the_changeling_features:update_schemes_reward_bundle()

	local faction = cm:get_faction(self.faction_key)
	local mission_bundle = false	
	local effect_bundle_list = faction:effect_bundles()

	for i = 0, effect_bundle_list:num_items() - 1 do
		local effect_bundle = effect_bundle_list:item_at(i)

		if self.schemes.mission_to_schemes_rewards_effects[effect_bundle:key()] then
			mission_bundle = effect_bundle
			break
		end
	end

	if mission_bundle then
		
		local bundle_key = self.schemes.schemes_rewards_bundle_key
		local bundle_data = cm:get_saved_value("the_changeling_schemes_rewards_bundle")
		local effects_list = mission_bundle:effects()

		-- Check whether the new effect already exists and increment it, otherwise add it to the table
		for i = 0, effects_list:num_items() -1 do
			local new_effect = effects_list:item_at(i)
			local new_effect_key = new_effect:key()
			local new_value = new_effect:value()

			if bundle_data[new_effect_key] ~= nil then
				bundle_data[new_effect_key].value = bundle_data[new_effect_key].value + new_value
			else
				bundle_data[new_effect_key] = {
					scope_key = new_effect:scope(),
					value = new_value
				}
			end

		end

		cm:remove_effect_bundle(mission_bundle:key(), self.faction_key)
		

		--Before adding the bundle we need to remove the old bundle and the dummy bundle, if they already exist
		if faction:has_effect_bundle(bundle_key) then
			cm:remove_effect_bundle(bundle_key, self.faction_key)
		end

		local bundle = cm:create_new_custom_effect_bundle(bundle_key)
		for effect_key, data in pairs(bundle_data) do
			bundle:add_effect(effect_key, data.scope_key, data.value)
		end
		bundle:set_duration(0)
		cm:apply_custom_effect_bundle_to_faction(bundle, faction)

		cm:set_saved_value("the_changeling_schemes_rewards_bundle", bundle_data)
	end
end

-- Add or remove the composite scene from settlements with cults
function the_changeling_features:change_composite_scene_in_region(region, add_composite_scene)
local region_key = region:name()
local composite_scene_key = self.cult_region_vfx_prefix..region_key

	if add_composite_scene then
		cm:add_scripted_composite_scene_to_settlement(
			composite_scene_key,
			self.cult_region_composite_scene,
			region,
			1,
			1,
			false,
			true,
			true,
			cm:get_faction(self.faction_key)
		)
	else

		cm:remove_scripted_composite_scene(composite_scene_key)

	end

end

-- Common function to check if a region is owned by any Tzeentch faction, or Vilitch
function the_changeling_features:is_region_owner_tzeentch(region_owner)
	return region_owner:name() ~= "rebels" and (region_owner:subculture() == "wh3_main_sc_tze_tzeentch" or region_owner:name() == "wh3_dlc20_chs_vilitch")
end

function the_changeling_features:create_random_invasion_force(faction_key, region_key, army_template, unique_key)
	local unit_list = WH_Random_Army_Generator:generate_random_army(unique_key, army_template, 19, 10, false, false)
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, false, 15)
	
	if pos_x > -1 then

		cm:create_force(
			faction_key,
			unit_list,
			region_key,
			pos_x,
			pos_y,
			false,
			function(cqi, created_force_cqi)
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 0)
				force_cqi = created_force_cqi
			end
		)
	end
end

-- Common function for spawned faction invasions post-grand scheme, or backup rebels if the faction isn't available
function the_changeling_features:grand_scheme_invasion(invasion_faction_key, regions, random_army_template, rebel_key, can_revive, transfer_region)
	local invasion_id = cm:get_saved_value("the_changeling_grand_scheme_invasion_id") or 0
	local invasion_faction = cm:get_faction(invasion_faction_key)
	if (can_revive or invasion_faction:is_dead() == false) and invasion_faction:was_confederated() == false and invasion_faction:is_human() == false then
		cm:treasury_mod(invasion_faction_key, 25000)
		for i = 1, #regions do
			local region = cm:get_region(regions[i])
			if region:is_abandoned() == false then
				local region_owner = region:owning_faction()
				if region_owner:is_null_interface() or (region_owner:is_human() == false and region_owner:name() ~= invasion_faction_key) then
					self:declare_war(invasion_faction, region_owner)
					invasion_id = invasion_id + 1
					self:create_random_invasion_force(invasion_faction_key, regions[i], random_army_template, "the_changeling_grand_invasion_"..invasion_id)
					if transfer_region then
						cm:transfer_region_to_faction(regions[i], invasion_faction_key)
					end
					cm:heal_garrison(region:cqi())
					local slot_manager = region:foreign_slot_manager_for_faction(self.faction_key)
					if slot_manager:is_null_interface() == true then
						cm:add_foreign_slot_set_to_region_for_faction(cm:get_faction(self.faction_key):command_queue_index(), region:cqi(), self.slot_set)
					end
					cm:make_region_visible_in_shroud(self.faction_key, regions[i])
				end
			end
		end
		cm:set_saved_value("the_changeling_grand_scheme_invasion_id", invasion_id)
	else
		for i = 1, #regions do
			local region = cm:get_region(regions[i])
			if region:is_abandoned() == false then
				local region_owner = region:owning_faction()
				if region_owner:is_null_interface() == false and region_owner:is_rebel() == false and region_owner:name() ~= invasion_faction_key then
					self:trigger_rebellion(region, rebel_key, true)
				end
			end
		end
	end
end

-- Spawns an army as a reward for the grand scheme quest battles
-- If locked_army is true, the army will have permanent free upkeep but will be unable to recruit/transfer units
-- If locked_army is false, the army will have free upkeep for 10 turns only, but is otherwise a normal army
function the_changeling_features:spawn_grand_scheme_army(region_key, unit_list, locked_army)
	local generals 
	if locked_army then 
		generals = {"wh3_dlc24_tze_exalted_lord_of_change_metal_locked_army", "wh3_dlc24_tze_exalted_lord_of_change_tzeentch_locked_army"}
	else
		generals = {"wh3_main_tze_exalted_lord_of_change_metal", "wh3_main_tze_exalted_lord_of_change_tzeentch"}
	end
	local army_x, army_y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_key, region_key, false, true, 10)
	if army_x > -1 then
		cm:create_force_with_general(
			self.faction_key,
			unit_list,
			region_key,
			army_x,
			army_y,
			"general",
			generals[cm:random_number(#generals, 1)],
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				local character = cm:char_lookup_str(cqi)
				if locked_army then
					cm:apply_effect_bundle_to_characters_force("wh3_dlc24_bundle_military_upkeep_free_locked_force", cqi, 0)
				else 
					cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 10)
				end
				cm:add_agent_experience(character, 20, true)
				cm:add_experience_to_units_commanded_by_character(character, 5)
				cm:replenish_action_points(character)
			end
		)
	end
end

-- Common function to set the string state for the ultimate scheme battle after completing the grand schemes
function the_changeling_features:update_ultimate_battle_strings(qb_string)
	local ultimate_battle_strings = cm:get_saved_value("the_changeling_ultimate_battle_strings")
	
	if qb_string then
		ultimate_battle_strings[qb_string] = "1"
		cm:set_saved_value("the_changeling_ultimate_battle_strings", ultimate_battle_strings)
	end

	for army_string, value in pairs(ultimate_battle_strings) do
		core:svr_save_string(army_string, value)
	end
end


-- Cinematic camera pan out from the region, similar to when a doomsphere detonates
-- Interventions are used in singleplayer so scripted tours don't interrupt the cutscene
-- MP doesn't have interventions, so the function is separated out to still work in mp
function the_changeling_features:start_camera_cutscene(region_key, incident_key)
	cm:make_region_visible_in_shroud(self.faction_key, region_key)
	
	if cm:is_multiplayer() then
		self:camera_cutscene(nil, region_key, incident_key)
	else
		cm:trigger_transient_intervention(
			"changeling_grand_scheme_cutscene",
			function(intervention)
				self:camera_cutscene(intervention, region_key, incident_key)
			end
		)
	end
end

function the_changeling_features:camera_cutscene(intervention, region_key, incident_key)
	core:add_listener(
		"show_story_panel",
		"UITrigger",
		function(context)
			return context:trigger() == "show_story_panel"
		end,
		function()
			cm:trigger_incident(self.faction_key, incident_key, true, true)
		end,
		false
	)
	
	if cm:get_local_faction_name(true) == self.faction_key then
		local cutscene_camera_start_offset = {24.23, 21.1} -- distance, heading - from the settlement in the cutscene
		local cutscene_camera_end_offset = {31.78, 41.04}
		local cutscene_camera_height_offset = 4 -- amount to zoom out from the settlement in the cutscene
		local settlement = cm:get_region(region_key):settlement()
		local pos_x = settlement:display_position_x()
		local pos_y = settlement:display_position_y()
		local fade_in_time = 1
		local pause_after_fade_before_vfx = 0.5
		local vfx_play_time = 4
		local fade_out_time = 3
		local x, y, d, b, h = cm:get_camera_position()
		
		cm:steal_user_input(true)
		cm:fade_scene(0, fade_in_time)
		
		cm:callback(
			function() -- 1.0s
				cm:scroll_camera_with_direction(true, vfx_play_time * 2, {pos_x, pos_y, cutscene_camera_start_offset[1], 0, cutscene_camera_start_offset[2]}, {pos_x, pos_y + cutscene_camera_height_offset, cutscene_camera_end_offset[1], 0, cutscene_camera_end_offset[2]})
				CampaignUI.ToggleCinematicBorders(true)
				cm:fade_scene(1, fade_in_time)
				
				cm:callback(
					function() -- 5.5s
						cm:fade_scene(0, fade_out_time)
						
						cm:callback(
							function() -- 3.0s
								cm:steal_user_input(false)
								cm:set_camera_position(x, y, d, b, h)
								CampaignUI.ToggleCinematicBorders(false)
								cm:fade_scene(1, fade_in_time)
								
								CampaignUI.TriggerCampaignScriptEvent(0, "show_story_panel")
								
								if intervention then
									core:add_listener(
										"the_changeling_grand_scheme_cutscence_complete",
										"ScriptEventPanelClosedCampaign",
										function(context)
											return context.string == "events"
										end,
										function()
											intervention:complete()
										end,
										false
									)
								end
							end,
							fade_out_time
						)
					end,
					vfx_play_time + fade_in_time + pause_after_fade_before_vfx
				)
			end,
			fade_in_time
		)
	end
end

-- GRAND SCHEME SCRIPTED EFFECTS

function the_changeling_features:grand_scheme_badlands(region_key)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_tomb_kings_army_reinforce")

	local region = cm:get_region(region_key)
	local black_pyramid_key = "wh3_main_combi_region_black_pyramid_of_nagash"
	if cm:get_region(black_pyramid_key):is_abandoned() == false then
		cm:set_region_abandoned(black_pyramid_key)
	end

	if region_key == "wh3_main_combi_region_nonchang" and region:is_abandoned() == false then
		cm:instantly_upgrade_building_in_region(region:slot_list():item_at(0), "wh2_dlc09_special_settlement_pyramid_of_nagash_tmb_5")
		cm:override_building_chain_display("wh3_main_cth_settlement_major", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating", region_key)
	end

	if region_key == "wh3_main_combi_region_castle_templehof" and region:is_abandoned() == false then
		cm:instantly_upgrade_building_in_region(region:slot_list():item_at(0), "wh2_dlc09_special_settlement_pyramid_of_nagash_tmb_5")
		cm:override_building_chain_display("wh_main_VAMPIRES_settlement_major", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating", region_key)
	end

	if region_key == "wh3_main_combi_region_xlanhuapec" and region:is_abandoned() == false then
		cm:instantly_upgrade_building_in_region(region:slot_list():item_at(0), "wh2_dlc09_special_settlement_pyramid_of_nagash_tmb_5")
		cm:override_building_chain_display("wh2_main_lzd_settlement_major", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating", region_key)
	end

	if region_key == "wh3_main_combi_region_doomkeep" and region:is_abandoned() == false then
		cm:instantly_upgrade_building_in_region(region:slot_list():item_at(0), "wh2_dlc09_special_settlement_pyramid_of_nagash_tmb_5")
		cm:override_building_chain_display("wh_main_NORSCA_settlement_major", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating", region_key)
	end

	if region:is_abandoned() == false then
		local slot_manager = region:foreign_slot_manager_for_faction(self.faction_key)
		if slot_manager:is_null_interface() == true then
			cm:add_foreign_slot_set_to_region_for_faction(cm:get_faction(self.faction_key):command_queue_index(), region:cqi(), self.slot_set)
			cm:make_region_visible_in_shroud(self.faction_key, region_key)
		end
	end

	self:trigger_rebellion(region, "wh2_dlc09_tmb_tomb_kings_rebels", true)
	self:trigger_rebellion(region, "wh2_dlc09_tmb_tomb_kings_rebels", true)
	self:trigger_rebellion(region, "wh2_dlc09_tmb_tomb_kings_rebels", true)

	-- Move the camera to the new pyramid location
	self:start_camera_cutscene(region_key, "wh3_dlc24_story_panel_the_changeling_badlands_grand")
end

function the_changeling_features:grand_scheme_bretonnia()
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_bretonnia_army_reinforce")

	local mousillon_faction_key = "wh_main_vmp_mousillon"
	local mousillon_region_key = "wh3_main_combi_region_mousillon"
	local mousillon_region = cm:get_region(mousillon_region_key)
	local regions = {
		"wh3_main_combi_region_lyonesse",
		"wh3_main_combi_region_bordeleaux",
		"wh3_main_combi_region_castle_artois",
		"wh3_main_combi_region_castle_carcassonne",
		"wh3_main_combi_region_couronne",		
		"wh3_main_combi_region_parravon",
		"wh3_main_combi_region_castle_bastonne",
		"wh3_main_combi_region_al_haikk"
	}
	if mousillon_region:is_abandoned() or (mousillon_region:owning_faction() and (mousillon_region:owning_faction():is_null_interface() or mousillon_region:owning_faction():name() ~= mousillon_faction_key)) then
		cm:transfer_region_to_faction("wh3_main_combi_region_mousillon", mousillon_faction_key)
	end
	self:grand_scheme_invasion(mousillon_faction_key, regions, "wh_main_sc_vmp_vampire_counts", "wh_main_vmp_vampire_rebels", true, false)
	for i = 1, #regions do
		local region = cm:get_region(regions[i])
		if region:is_abandoned() == false then
			local effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_the_changeling_schemes_regional_corruption")
			effect_bundle:set_duration(10)
			effect_bundle:add_effect("wh3_main_effect_corruption_vampiric_events_bad", "region_to_province_own", 10)
			cm:apply_custom_effect_bundle_to_region(effect_bundle, region)
		
			-- Add a random amount of Vampiric corruption to each of the province capitals
			local prm = region:province():pooled_resource_manager()
			cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_vampiric"), "events", cm:random_number(25, 10))
		end
	end

	-- Move the camera to the middle of Bretonnia
	self:start_camera_cutscene("wh3_main_combi_region_castle_bastonne", "wh3_dlc24_story_panel_the_changeling_bretonnia_grand")
end

function the_changeling_features:grand_scheme_chaos_wastes(regions, locked_army)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_tzeentch_army_reinforce")

	local unit_list = "wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_veh_burning_chariot_0,wh3_main_tze_veh_burning_chariot_0,wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_exalted_flamers_0,wh3_main_tze_mon_exalted_flamers_0,wh3_dlc24_tze_mon_mutalith_vortex_beast,wh3_dlc24_tze_mon_mutalith_vortex_beast"

	for i = 1, #regions do
		self:spawn_grand_scheme_army(regions[i], unit_list, locked_army)
	end

	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_abandoned() == false and region:is_province_capital() and region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_chaos_wastes") then
			local effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_the_changeling_schemes_regional_corruption")
			effect_bundle:set_duration(10)
			effect_bundle:add_effect("wh3_main_effect_corruption_tzeentch_events_bad", "region_to_province_own", 10)
			cm:apply_custom_effect_bundle_to_region(effect_bundle, region)
					
			-- Add a random amount of Tzeentch corruption to each of the province capitals
			local prm = region:province():pooled_resource_manager()
			cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_tzeentch"), "events", cm:random_number(25, 10))

			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() == false and region_owner:is_rebel() == false and self:is_region_owner_tzeentch(region_owner) == false then
				self:trigger_rebellion(region, "wh3_main_tze_tzeentch_rebels", true)
			end
		end
	end

	-- Move the camera to the new army spawn location
	self:start_camera_cutscene(regions[1], "wh3_dlc24_story_panel_the_changeling_chaos_wastes_grand")
end

function the_changeling_features:grand_scheme_darklands()
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_greenskins_army_reinforce")

	local bonus_regions = {
		wh3_main_combi_region_ekrund = true,
		wh3_main_chaos_region_karak_dum = true,
		wh3_main_combi_region_the_volary = true
	}

	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		-- Check includes the Volary as it lies outside the darklands but it's Zhatan's capital in IE
		if region:is_abandoned() == false and region:is_province_capital() and (region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_darklands") or region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_chaos_darklands") or bonus_regions[region:name()]) then
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() == false and region_owner:is_rebel() == false and not self:is_region_owner_tzeentch(region_owner) then
				self:trigger_rebellion(region, "wh3_dlc24_grn_chaos_dwarfs_labourer_rebels", true)
			end
		end
	end

	-- Move the camera to Zharr Naggrund
	local camera_region = "wh3_main_combi_region_zharr_naggrund"
	if self.campaign_name == "wh3_main_chaos" then
		camera_region = "wh3_main_chaos_region_zharr_naggrund"
	end
	self:start_camera_cutscene(camera_region, "wh3_dlc24_story_panel_the_changeling_darklands_grand")
end

function the_changeling_features:grand_scheme_grand_cathay(cultist_region_key, amount)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_cathay_army_reinforce")

	self:spawn_cultist(cultist_region_key, amount)

	local cathay_grand_scheme = {
		wh3_main_chaos = {
			gates = {
				wh3_main_chaos_region_dragon_gate = true,
				wh3_main_chaos_region_snake_gate = true,
				wh3_main_chaos_region_turtle_gate = true
			},
			kurgan_regions = {
				wh3_main_chaos_region_nan_gau = true,
				wh3_main_chaos_region_po_mei = true,
				wh3_main_chaos_region_terracotta_graveyard = true,
				wh3_main_chaos_region_wei_jin = true
			},
			region_group = "wh3_dlc24_schemes_theatre_chaos_grand_cathay"
		},
		main_warhammer = {
			gates = {
				wh3_main_combi_region_dragon_gate = true,
				wh3_main_combi_region_snake_gate = true,
				wh3_main_combi_region_turtle_gate = true
			},
			kurgan_regions = {
				wh3_main_combi_region_nan_gau = true,
				wh3_main_combi_region_po_mei = true,
				wh3_main_combi_region_terracotta_graveyard = true,
				wh3_main_combi_region_wei_jin = true
			},
			region_group = "wh3_dlc24_schemes_theatre_ie_grand_cathay"
		}
	}
	
	local data = cathay_grand_scheme[self.campaign_name]

	-- Raze the gates if they aren't owned by Tzeentch factions
	for region_key, _ in pairs(data.gates) do
		local region = cm:get_region(region_key)
		local region_owner = region:owning_faction()
		if region:is_abandoned() == false and (region_owner:is_null_interface() or region_owner:is_rebel() or self:is_region_owner_tzeentch(region_owner) == false) then
			cm:set_region_abandoned(region_key)
		end		
	end

	--Spawn Kurgan Warband in the regions just inside the gates
	for region_key, _ in pairs(data.kurgan_regions) do
		local region = cm:get_region(region_key)
		if region:is_abandoned() == false then
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() == true or region_owner:is_rebel() or self:is_region_owner_tzeentch(region_owner) == false then
				local settlement = region:settlement()
				local settlement_coords = {
					settlement:logical_position_x(), settlement:logical_position_y()
				}
				Bastion:spawn_army(19, "chaos_besiegers_1", settlement_coords)
			end	
		end
	end

	-- Spawn Tzeentch rebels in all the remaining province capitals in Cathay
	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local region_key = region:name()
		if region:is_abandoned() == false then
		local region_owner = region:owning_faction()
			if region:is_contained_in_region_group(data.region_group) and not data.kurgan_regions[region_key] and not data.gates[region_key] and region_owner:is_null_interface() == false and region_owner:is_rebel() == false and region:is_province_capital() and self:is_region_owner_tzeentch(region_owner) == false then
				self:trigger_rebellion(region, "wh3_main_tze_tzeentch_rebels", true)
			end
		end
	end

	-- Move the camera to the middle of the Great Bastion
	local camera_region = "wh3_main_combi_region_dragon_gate"
	if self.campaign_name == "wh3_main_chaos" then
		camera_region = "wh3_main_chaos_region_dragon_gate"
	end
	self:start_camera_cutscene(camera_region, "wh3_dlc24_story_panel_the_changeling_grand_cathay_grand")
end

function the_changeling_features:grand_scheme_lustria()
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_skaven_army_reinforce")

	local pestilens_key = "wh2_main_skv_clan_pestilens"
	local pestilens_faction = cm:get_faction("wh2_main_skv_clan_pestilens")
	local pestilens_valid = pestilens_faction:is_dead() == false and pestilens_faction:is_human() == false and pestilens_faction:was_confederated() == false
	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if (region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_lustria") or region:name() == "wh3_main_combi_region_tyrant_peak") and region:is_abandoned() == false then
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() == false and region_owner:is_rebel() == false and region_owner:subculture() == "wh2_main_sc_lzd_lizardmen" then
				under_empire_plague_cauldron_created(pestilens_faction, region)
				self:trigger_rebellion(region, "wh3_main_nur_nurgle_rebels", true)
			end
		
			-- Add a random amount of Nurgle and Skaven corruption to each of the province capitals
			if region:is_province_capital() then
				local effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_the_changeling_schemes_regional_corruption")
				effect_bundle:set_duration(10)
				effect_bundle:add_effect("wh3_main_effect_corruption_skaven_events", "region_to_province_own", 10)
				effect_bundle:add_effect("wh3_main_effect_corruption_nurgle_events", "region_to_province_own", 5)
				cm:apply_custom_effect_bundle_to_region(effect_bundle, region)

				local prm = region:province():pooled_resource_manager()
				cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_skaven"), "events", cm:random_number(55, 35))
				cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_nurgle"), "events", cm:random_number(25, 10))
			end

			-- Add foreign slots for Clan Pestilens, if we're able to
			if pestilens_valid and region_owner:name() ~= pestilens_key then
				local under_empire_present = false
				local foreign_slot_managers = region:foreign_slot_managers()
				for i2 = 0, foreign_slot_managers:num_items() -1 do
					local foreign_slot_manager = foreign_slot_managers:item_at(i2)
					if foreign_slot_manager:faction():name() == pestilens_key then
						under_empire_present = true
						break
					end
				end
				if under_empire_present == false then
					cm:add_foreign_slot_set_to_region_for_faction(pestilens_faction:command_queue_index(), region:cqi(), "wh2_dlc12_slot_set_underempire")
				end
			end
			
		end
	end

	-- Move the camera to a plague-ridden Temple city in the middle of Lustria
	self:start_camera_cutscene("wh3_main_combi_region_tlaxtlan", "wh3_dlc24_story_panel_the_changeling_lustria_grand")
end

function the_changeling_features:grand_scheme_naggaroth(region_key)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_vampire_coast_army_reinforce")

	local unit_list = "wh3_dlc24_tze_inf_tzaangors,wh3_dlc24_tze_inf_tzaangors,wh3_dlc24_tze_inf_tzaangors,wh3_dlc24_tze_inf_tzaangors,wh3_main_tze_mon_soul_grinder_0,wh3_dlc24_tze_mon_cockatrice,wh3_main_tze_mon_exalted_flamers_0,wh3_main_tze_mon_exalted_flamers_0,wh3_main_tze_mon_exalted_flamers_0,wh3_main_tze_mon_exalted_flamers_0,wh3_dlc24_tze_mon_mutalith_vortex_beast,wh3_dlc24_tze_mon_mutalith_vortex_beast,wh2_dlc11_cst_mon_bloated_corpse_0,wh2_dlc11_cst_mon_bloated_corpse_0,wh2_dlc11_cst_mon_bloated_corpse_0,wh2_dlc11_cst_mon_bloated_corpse_0,wh2_dlc11_cst_mon_bloated_corpse_0,wh2_dlc11_cst_mon_bloated_corpse_0"
	self:spawn_grand_scheme_army(region_key, unit_list, true)

	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_naggaroth") and region:is_abandoned() == false and region:settlement():is_port() then
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() == false and region_owner:is_rebel() == false then
				self:trigger_rebellion(region, "wh3_dlc24_cst_vampire_coast_bloated_rebels", true)
			end
		end
	end

	-- Move the camera to the Changeling's newly spawned army location
	self:start_camera_cutscene(region_key, "wh3_dlc24_story_panel_the_changeling_naggaroth_grand")
end

function the_changeling_features:grand_scheme_norsca(theatre)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_norsca_army_reinforce")

	local regions = {
		wh3_main_chaos = {
			cathay = {
				wulfrik = {"wh3_main_chaos_region_bridge_of_heaven","wh3_main_chaos_region_qiang", "wh3_main_chaos_region_shi_long"},
				throgg = {"wh3_main_chaos_region_temple_of_elemental_winds","wh3_main_chaos_region_village_of_the_tigermen"}
			},
		},
		main_warhammer = {
			cathay = {
				wulfrik = {"wh3_main_combi_region_dai_cheng","wh3_main_combi_region_tower_of_ashung"},
				throgg = {"wh3_main_combi_region_fu_hung","wh3_main_combi_region_temple_of_elemental_winds","wh3_main_combi_region_village_of_the_tigermen"}
			},
			ulthuan = {
				wulfrik = {"wh3_main_combi_region_avethir","wh3_main_combi_region_tor_anroc", "wh3_main_combi_region_whitepeak"},
				throgg = {"wh3_main_combi_region_cairn_thel","wh3_main_combi_region_elessaeli","wh3_main_combi_region_shrine_of_loec"}
			}
		}
	}
	local invasion_regions = regions[self.campaign_name][theatre]
	self:grand_scheme_invasion("wh_dlc08_nor_norsca", invasion_regions.wulfrik, "wh_dlc08_sc_nor_norsca", "wh_main_nor_norsca_rebels", true, true)
	self:grand_scheme_invasion("wh_dlc08_nor_wintertooth", invasion_regions.throgg, "wh_dlc08_sc_nor_norsca", "wh_main_nor_norsca_rebels", true, true)

	-- Move the camera to Wulfrik's primary region
	self:start_camera_cutscene(invasion_regions.wulfrik[1], "wh3_dlc24_story_panel_the_changeling_norsca_grand")
end

function the_changeling_features:grand_scheme_the_empire(kislev, darklands, amount)
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_empire_army_reinforce")

	local empire_rebels = "wh_main_emp_empire_rebels"
	local regions = {
		wh3_main_chaos = {
			kislev = "wh3_main_chaos_region_kislev",
			darklands = "wh3_main_chaos_region_the_silver_pinnacle"
		},
		main_warhammer = {
			kislev = "wh3_main_combi_region_erengrad",
			darklands = "wh3_main_combi_region_silver_pinnacle"
		}
	}

	if kislev then
		local region_key = regions[self.campaign_name].kislev
		self:trigger_rebellion(cm:get_region(region_key), empire_rebels, true)
		self:spawn_cultist(region_key, amount)
	end

	if darklands then
		local region_key = regions[self.campaign_name].darklands
		self:trigger_rebellion(cm:get_region(region_key), empire_rebels, true)
		self:spawn_cultist(region_key, amount)
	end

	-- Loop through the Empire elector count factions and force a war between all of them. Also restrict peace so they can't talk it out
	-- Uses the empire politics script to ensure parity with the Elector count list
	for i = 1, #empire_politics_factions do
		local faction_key = empire_politics_factions[i].faction
		local faction = cm:get_faction(faction_key)

		-- One sided human check is to ensure that a human player (in mpc) is declared on, but can still make peace/confederate
		if faction and faction:was_confederated() == false and faction:is_human() == false then
			for j = 1, #empire_politics_factions do
				local secondary_faction_key = empire_politics_factions[j].faction
				if faction_key ~= secondary_faction_key then
					local secondary_faction = cm:get_faction(secondary_faction_key)
					if secondary_faction then
						cm:force_diplomacy("faction:" .. faction_key, "faction:" .. secondary_faction_key, "form confederation", false, false, true)
						cm:force_diplomacy("faction:" .. faction_key, "faction:" .. secondary_faction_key, "peace", false, false, true)

						if faction:is_dead() == false and secondary_faction:was_confederated() == false and secondary_faction:is_dead() == false and faction:at_war_with(secondary_faction) == false then
							cm:force_declare_war(faction_key, secondary_faction_key, false, false)
						end
					end
				end
			end
		end
	end

	--Setting Reikland's imperial authority to the minimum value forces the empire politics script into civil war
	cm:faction_add_pooled_resource("wh_main_emp_empire", "emp_imperial_authority", "events_negative", -200)

	local altdorf = {
		main_warhammer = "wh3_main_combi_region_altdorf",
		wh3_main_chaos = "wh3_main_chaos_region_altdorf"
	}

	-- Move the camera to Altdorf
	self:start_camera_cutscene(altdorf[self.campaign_name], "wh3_dlc24_story_panel_the_changeling_the_empire_grand")
end

function the_changeling_features:grand_scheme_ulthuan()
	-- Update the ultimate battle with the grand scheme bonus
	self:update_ultimate_battle_strings("the_changeling_high_elves_army_reinforce")

	local regions = {
		"wh3_main_combi_region_lothern",
		"wh3_main_combi_region_eagle_gate",
		"wh3_main_combi_region_griffon_gate",
		"wh3_main_combi_region_phoenix_gate",
		"wh3_main_combi_region_unicorn_gate",
		"wh3_main_combi_region_ancient_city_of_quintex"
	}

	self:grand_scheme_invasion("wh2_main_def_cult_of_pleasure", regions, "wh2_main_sc_def_dark_elves", "wh3_main_sla_slaanesh_rebels", true, true)

	local region_list = cm:model():world():region_manager():region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_province_capital() and region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_ulthuan") and region:name() ~= "wh3_main_combi_region_the_galleons_graveyard" then
			local effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_the_changeling_schemes_regional_corruption")
			effect_bundle:set_duration(10)
			effect_bundle:add_effect("wh3_main_effect_corruption_slaanesh_events_bad", "region_to_province_own", 10)
			cm:apply_custom_effect_bundle_to_region(effect_bundle, region)
			
		
			-- Add a random amount of Slaanesh corruption to each of the province capitals
			local prm = region:province():pooled_resource_manager()
			cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_slaanesh"), "events", cm:random_number(55, 25))
		end
	end

	-- Move the camera to the middle of Ulthuan
	self:start_camera_cutscene("wh3_main_combi_region_shrine_of_asuryan", "wh3_dlc24_story_panel_the_changeling_ulthuan_grand")
end