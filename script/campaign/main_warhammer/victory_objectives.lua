victory_objectives_ie = {
	victory_type = {
		multiplayer = "wh3_combi_victory_type_multiplayer",
		faction = "wh3_combi_victory_type_faction",
		subculture = "wh3_combi_victory_type_subculture",
		domination = "wh3_combi_victory_type_domination"
	},

	-- Multiplayer specific victory. Note this is an alternative to other victories, rather than a replacement
	multiplayer = {
		objectives = {
			{
				type = "ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS",
				conditions = {
					"total 100"
				}
			}
		}
	},

	-- Alignments are used for populating the faction/cultural victories with some generic expansionism as well
	-- The default value is used if we can't find a subculture, or a subculture is missing an alignment 
	alignments = {
		default = "destruction",
		order = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_order_short"
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_order_long"
			},
		},
		destruction = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_destruction_short"			
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_destruction_long"	
			}
		},
		death = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_death_short"			
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_death_long"	
			}
		},
		chaos = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_chaos_short"			
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_chaos_long"	
			}
		},
		dark_elves = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_destruction_short"            
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_def_long"   
			}
		},
		khorne = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_ancillary = "wh3_main_anc_weapon_chainsword"	
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_chaos_long"	
			}
		},
		chaos_dwarfs = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					}
				},
				payload_bundle = "wh3_dlc23_ie_victory_objective_chaos_dwarfs_short"	
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					}
				},
				payload_ancillary = {
					"wh3_dlc23_anc_armour_lesser_relic_of_skavor",
					"wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
					"wh3_dlc23_anc_weapon_lesser_relic_of_smednir"
				}
			}
		},
		ogre_kingdoms = {
			wh_main_short_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 30"
						}
					},
					{
						-- Build camp up to level 5
						type = "CONSTRUCT_N_OF_A_BUILDING",
						conditions = {
							"total 1",
							"building_level wh3_main_ogr_camp_town_centre_5",
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_destruction_short"			
			},
			wh_main_long_victory = {
				objectives = {
					{
						type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
						conditions = {
							"total 60"
						}
					},
					{
						-- Build camps up to level 5
						type = "CONSTRUCT_N_OF_A_BUILDING",
						conditions = {
							"total 2",
							"building_level wh3_main_ogr_camp_town_centre_5",
						}
					}
				},
				payload_bundle = "wh3_main_ie_victory_objective_destruction_long"	
			}
		},
	},

	-- Ideally every playable subculture should be in this table, but it isn't required
	-- The alignments are used for determining the generic alignment objectives
	subcultures = {
		wh_main_sc_emp_empire = {
			alignment = "order",
			objectives = {
				{
					-- Empire controls the Empire
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 13",
						"override_text mission_text_text_wh_main_objective_override_empire_control",
						"province wh3_main_combi_province_nordland",
						"province wh3_main_combi_province_ostland",
						"province wh3_main_combi_province_hochland",
						"province wh3_main_combi_province_middenland",
						"province wh3_main_combi_province_talabecland",
						"province wh3_main_combi_province_ostermark",
						"province wh3_main_combi_province_reikland",
						"province wh3_main_combi_province_stirland",
						"province wh3_main_combi_province_averland",
						"province wh3_main_combi_province_wissenland",
						"province wh3_main_combi_province_the_wasteland",
						"province wh3_main_combi_province_northern_sylvania",
						"province wh3_main_combi_province_southern_sylvania"
					}
				}
			}
		},
		wh_dlc05_sc_wef_wood_elves = {
			alignment = "order",
			objectives = {
				{
					-- Win the defend the oak battle
					type = "FIGHT_SET_PIECE_BATTLE",
					conditions = {
						"set_piece_battle wh_dlc05_qb_wef_grand_defense_of_the_oak"
					}
				},
				{
					--Heal Athel Loren
					type = "PERFORM_RITUAL",
						conditions = {
							"ritual wh2_dlc16_ritual_rebirth_athel_loren",
					}
				},
			    {
					--Heal the world roots
					type = "PERFORM_RITUAL",
					conditions = {
						"ritual_category WORLDROOTS_HEALING",
						"total 8"
					}
				}
			}
		},
		wh2_main_sc_hef_high_elves = {
			alignment = "order",
			objectives = {
				{
					-- High Elves & allies control Ulthuan
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 15",
						"province wh3_main_combi_province_eataine",
						"province wh3_main_combi_province_caledor",
						"province wh3_main_combi_province_tiranoc",
						"province wh3_main_combi_province_ellyrion",
						"province wh3_main_combi_province_nagarythe",
						"province wh3_main_combi_province_avelorn",
						"province wh3_main_combi_province_chrace",
						"province wh3_main_combi_province_cothique",
						"province wh3_main_combi_province_saphery",
						"province wh3_main_combi_province_northern_yvresse",
						"province wh3_main_combi_province_southern_yvresse",
						"province wh3_main_combi_province_eagle_gate",
						"province wh3_main_combi_province_griffon_gate",
						"province wh3_main_combi_province_unicorn_gate",
						"province wh3_main_combi_province_phoenix_gate"
					}
				},
				{
					-- Eliminate the Dark Elves
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_cult_of_pleasure",
						"faction wh2_main_def_hag_graef",
						"faction wh2_main_def_naggarond",
						"faction wh2_dlc11_def_the_blessed_dread",
						"faction wh2_twa03_def_rakarth",
						"confederation_valid"
					}
				}
			}
		},
		wh_main_sc_brt_bretonnia = {
			alignment = "order",
			objectives = {
				{
					-- Max out Chivalry
					type = "SCRIPTED",
					conditions = {
						"script_key max_chivalry",
						"override_text mission_text_text_mis_activity_attain_chivalry_1000"
					}
				},
				{
					-- Win the errantry war
					type = "SCRIPTED",
					conditions = {
						"script_key win_errantry_war",
						"override_text mission_text_text_mis_activity_win_errantry_war"
					}
				}
			}
		},
		wh_main_sc_dwf_dwarfs = {
			alignment = "order",
			objectives = {
				{
					-- Spend Grudge Points 
					type = "SCRIPTED",
					conditions = {
						"script_key dwarf_grudge_long_victory",
						"override_text mission_text_text_wh3_dlc25_dwf_long_objective_grudge_points",
						"total 4",
						"count 0",
						"count_completion"
					}
				}
			}
		},
		wh2_main_sc_lzd_lizardmen = {
			alignment = "order",
			objectives = {
				{
					-- Lizardmen + allies control the lustriabowl
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {	
						"total 19",
						"override_text mission_text_text_wh_main_objective_override_mazdamundi_control",
						"province wh3_main_combi_province_culchan_plains",
						"province wh3_main_combi_province_headhunters_jungle",
						"province wh3_main_combi_province_spine_of_sotek",
						"province wh3_main_combi_province_the_lost_valley",
						"province wh3_main_combi_province_river_qurveza",
						"province wh3_main_combi_province_mosquito_swamps",
						"province wh3_main_combi_province_the_gwangee_valley",
						"province wh3_main_combi_province_the_turtle_isles",
						"province wh3_main_combi_province_scorpion_coast",
						"province wh3_main_combi_province_the_creeping_jungle",
						"province wh3_main_combi_province_jungles_of_green_mist",
						"province wh3_main_combi_province_aymara_swamps",
						"province wh3_main_combi_province_jungles_of_pahualaxa",
						"province wh3_main_combi_province_the_isthmus_coast",
						"province wh3_main_combi_province_isthmus_of_lustria",
						"province wh3_main_combi_province_copper_desert",
						"province wh3_main_combi_province_the_night_forest_road",
						"province wh3_main_combi_province_the_capes",
						"province wh3_main_combi_province_volcanic_islands"
					}
				}
			}
		},
		wh3_main_sc_ksl_kislev = {
			alignment = "order",
			objectives = {
				{
					-- Eliminate the major Chaos factions near Kislev
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_chs_chaos",
						"faction wh3_main_dae_daemon_prince",
						"faction wh3_dlc20_chs_azazel",
						"faction wh3_dlc20_chs_festus",
						"confederation_valid"
					}
				}
			}
		},
		wh3_main_sc_cth_cathay = {
			alignment = "order",
			objectives = {
				{
					-- Eliminate the nearby threats to Cathay
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_cth_rebel_lords_of_nan_yang",
						"faction wh3_main_cth_dissenter_lords_of_jinshen",
						"faction wh3_dlc20_chs_vilitch",
						"faction wh3_dlc20_chs_kholek",
						"faction wh2_dlc11_def_the_blessed_dread",
						"faction wh2_main_skv_clan_eshin",
						"confederation_valid"
					}
				},
				{
					-- Cathay + allies control the Great Bastion
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {	
						"total 3",
						"province wh3_main_combi_province_western_great_bastion",
						"province wh3_main_combi_province_central_great_bastion",
						"province wh3_main_combi_province_eastern_great_bastion"
					}
				}
			}
		},
		wh_main_sc_vmp_vampire_counts = {
			alignment = "death",
			objectives = {
				{
					-- Vampire Counts + allies control the Empire
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 13",
						"override_text mission_text_text_wh_main_objective_override_empire_control",
						"province wh3_main_combi_province_nordland",
						"province wh3_main_combi_province_ostland",
						"province wh3_main_combi_province_hochland",
						"province wh3_main_combi_province_middenland",
						"province wh3_main_combi_province_talabecland",
						"province wh3_main_combi_province_ostermark",
						"province wh3_main_combi_province_reikland",
						"province wh3_main_combi_province_stirland",
						"province wh3_main_combi_province_averland",
						"province wh3_main_combi_province_wissenland",
						"province wh3_main_combi_province_the_wasteland",
						"province wh3_main_combi_province_northern_sylvania",
						"province wh3_main_combi_province_southern_sylvania"
					}
				},
				{
					-- Eliminate Karl Franz
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_empire",
						"confederation_valid"
					}
				}
			}
		},
		wh2_main_sc_skv_skaven = {
			alignment = "destruction",
			objectives = {
				{
					-- Capture 7 / 13 of the key Skaven locations on the map
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 7",
						"region wh3_main_combi_region_karag_orrud",
						"region wh3_main_combi_region_karak_eight_peaks",
						"region wh3_main_combi_region_skavenblight",
						"region wh3_main_combi_region_nagashizzar",
						"region wh3_main_combi_region_crookback_mountain",
						"region wh3_main_combi_region_hell_pit",
						"region wh3_main_combi_region_altdorf",
						"region wh3_main_combi_region_mount_gunbad",
						"region wh3_main_combi_region_iron_rock",
						"region wh3_main_combi_region_altar_of_the_horned_rat",
						"region wh3_main_combi_region_oyxl",
						"region wh3_main_combi_region_galbaraz",
						"region wh3_main_combi_region_karak_izor",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
					}
				}
			}
		},
		wh2_dlc09_sc_tmb_tomb_kings = {
			alignment = "death",
			objectives = {
				{
					-- Capture the Black Pyramid of Nagash region, and other Tomb Kings regions of interest
					type = "OWN_N_REGIONS_INCLUDING",
					conditions = {
						"total 11",
						"region wh3_main_combi_region_black_pyramid_of_nagash",
						"region wh3_main_combi_region_black_tower_of_arkhan",
						"region wh3_main_combi_region_khemri",
						"region wh3_main_combi_region_wizard_caliphs_palace",
						"region wh3_main_combi_region_al_haikk",
						"region wh3_main_combi_region_numas",
						"region wh3_main_combi_region_ka_sabar",
						"region wh3_main_combi_region_galbaraz",
						"region wh3_main_combi_region_karag_orrud",
						"region wh3_main_combi_region_lahmia",
						"region wh3_main_combi_region_rasetra",
					}
				},
				{
					-- Build the special tomb kings pyramids
					type = "CONSTRUCT_N_BUILDINGS_FROM",
					conditions = {
						"total 7",
						"building_level wh2_dlc09_special_pyramid_alcadizaar",
						"building_level wh2_dlc09_special_pyramid_amenemhetum",
						"building_level wh2_dlc09_special_pyramid_khatep",
						"building_level wh2_dlc09_special_pyramid_phar",
						"building_level wh2_dlc09_special_pyramid_settra",
						"building_level wh2_dlc09_special_pyramid_tutankhanut",
						"building_level wh2_main_special_pyramid_of_nagash_other"
					}
				}
			}
		},
		wh2_dlc11_sc_cst_vampire_coast = {
			alignment = "death",
			objectives = {
				{
					-- Be the most infamous pirate
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource cst_infamy",
						"total 25000"
					}
				}
			}
		},
		wh2_main_sc_def_dark_elves = {
			alignment = "dark_elves",
			objectives = {
				{
					-- Capture the Shrine of Khaine
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_shrine_of_khaine"
					}
				},
				{
					-- Eliminate the High Elves
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_hef_avelorn",
						"faction wh2_main_hef_eataine",
						"faction wh2_main_hef_nagarythe",
						"faction wh2_main_hef_order_of_loremasters",
						"faction wh2_main_hef_yvresse",
						"faction wh2_dlc15_hef_imrik",
						"confederation_valid"
					}
				},
				{
					-- Dark Elves & Allies have recaptured Eataine from the High Elves
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 1",
						"province wh3_main_combi_province_eataine"
					}
				}
			}
		},
		wh_dlc08_sc_nor_norsca = {
			alignment = "chaos",
			objectives = {
				{
					-- Max out one of the Chaos Gods
					type = "SCRIPTED",
					conditions = {
						"script_key attain_chaos_god_favour",
						"override_text mission_text_text_mis_activity_attain_chaos_god_favour"
					}
				},
				{
					-- Beat up the other chaos god challengers
					type = "SCRIPTED",
					conditions = {
						"script_key defeat_chaos_gods_challengers",
						"override_text mission_text_text_mis_activity_defeat_chaos_gods_challengers"
					}
				}
			}
		},
		wh_dlc03_sc_bst_beastmen = {
			alignment = "chaos",
			objectives = {
				{
					-- Destroy the empire factions (+ Bretonnia)
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_empire",
						"faction wh_main_brt_bretonnia",
						"faction wh_main_emp_averland",
						"faction wh_main_emp_hochland",
						"faction wh_main_emp_middenland",
						"faction wh_main_emp_nordland",
						"faction wh_main_emp_ostland",
						"faction wh_main_emp_ostermark",
						"faction wh_main_emp_stirland",
						"faction wh_main_emp_talabecland",
						"faction wh_main_emp_wissenland",
						"faction wh_main_emp_marienburg",
						"confederation_valid"
					}
				},
				{
					-- Control or Raze the Wood Elf Oak of Ages
					type = "RAZE_OR_OWN_SETTLEMENTS",
					conditions = {
						"region wh3_main_combi_region_the_oak_of_ages"
					}
				}
			}
		},
		wh3_main_sc_ogr_ogre_kingdoms = {
			alignment = "ogre_kingdoms",
			objectives = {
				{
					-- Have 60 units
					type = "OWN_N_UNITS",
					conditions = {
						"total 60",
					}
				}
			}
		},
		wh3_main_sc_nur_nurgle = {
			alignment = "chaos",
			objectives = {
				{
					-- Eliminate Tzeentch
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_tze_oracles_of_tzeentch",
						"faction wh3_main_tze_flaming_scribes",
						"confederation_valid"
					}
				}
			}
		},
		wh3_main_sc_sla_slaanesh = {
			alignment = "chaos",
			objectives = {
				{
					-- N'kari controls Ulthuan, including regular Vassals and Allies or via seduction
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 15",
						"province wh3_main_combi_province_eataine",
						"province wh3_main_combi_province_caledor",
						"province wh3_main_combi_province_tiranoc",
						"province wh3_main_combi_province_ellyrion",
						"province wh3_main_combi_province_nagarythe",
						"province wh3_main_combi_province_avelorn",
						"province wh3_main_combi_province_chrace",
						"province wh3_main_combi_province_cothique",
						"province wh3_main_combi_province_saphery",
						"province wh3_main_combi_province_northern_yvresse",
						"province wh3_main_combi_province_southern_yvresse",
						"province wh3_main_combi_province_eagle_gate",
						"province wh3_main_combi_province_griffon_gate",
						"province wh3_main_combi_province_unicorn_gate",
						"province wh3_main_combi_province_phoenix_gate"
					}
				}
			}
		},
		wh3_main_sc_kho_khorne = {
			alignment = "khorne",
			objectives = {
				{
					-- Use Skull throne 8 times 
					type = "PERFORM_RITUAL",
					conditions = {
						"ritual_category SKULLS_RITUAL",
						"total 8"
					}
				}
			}
		},
		wh3_main_sc_tze_tzeentch = {
			alignment = "chaos",
			objectives = {
				{
					-- Eliminate Nurgle
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_nur_poxmakers_of_nurgle",
						"faction wh3_main_nur_bubonic_swarm",
						"confederation_valid"
					}
				}
			}
		},
		wh3_main_sc_dae_daemons = {
			alignment = "chaos",
			objectives = {
				{
						-- Eliminate the other nearby Chaos factions
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_chs_chaos", 
						"faction wh3_dlc20_chs_kholek",
						"faction wh3_dlc20_chs_sigvald",
						"faction wh3_dlc20_chs_azazel",
						"faction wh3_dlc20_chs_valkia",
						"confederation_valid"
					}
				}
			}
		},
		wh_main_sc_chs_chaos = {
			alignment = "chaos",
			objectives = {
				{
					-- Capture X of the Dark Fortress regions
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 13",
						"region wh3_main_combi_region_ancient_city_of_quintex",
						"region wh3_main_combi_region_altar_of_the_crimson_harvest",
						"region wh3_main_combi_region_black_rock",
						"region wh3_main_combi_region_black_fortress",
						"region wh3_main_combi_region_brass_keep",
						"region wh3_main_combi_region_bloodwind_keep",
						"region wh3_main_combi_region_daemons_gate",
						"region wh3_main_combi_region_dagraks_end",
						"region wh3_main_combi_region_doomkeep",
						"region wh3_main_combi_region_fortress_of_the_damned",
						"region wh3_main_combi_region_karak_dum",
						"region wh3_main_combi_region_karak_vlag",
						"region wh3_main_combi_region_konquata",
						"region wh3_main_combi_region_middenheim",
						"region wh3_main_combi_region_monolith_of_borkill_the_bloody_handed",
						"region wh3_main_combi_region_nuln",
						"region wh3_main_combi_region_okkams_forever_maze",
						"region wh3_main_combi_region_praag",
						"region wh3_main_combi_region_red_fortress",
						"region wh3_main_combi_region_tower_of_gorgoth",
						"region wh3_main_combi_region_zanbaijin",
						"region wh3_main_combi_region_the_challenge_stone",
						"region wh3_main_combi_region_the_crystal_spires",
						"region wh3_main_combi_region_the_godless_crater",
						"region wh3_main_combi_region_the_forbidden_citadel",
						"region wh3_main_combi_region_the_frozen_city",
						"region wh3_main_combi_region_the_howling_citadel",
						"region wh3_main_combi_region_the_lost_palace",
						"region wh3_main_combi_region_the_monolith_of_katam",
						"region wh3_main_combi_region_the_palace_of_ruin",
						"region wh3_main_combi_region_the_silvered_tower_of_sorcerers",
						"region wh3_main_combi_region_the_tower_of_khrakk",
						"region wh3_main_combi_region_the_twisted_towers",
						"region wh3_main_combi_region_the_writhing_fortress",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
					}
				}
			}
		},
		wh3_dlc23_sc_chd_chaos_dwarfs = {
			alignment = "chaos_dwarfs",
			objectives = {
				{
					-- be the boss of Zharr Naggrund
					type = "OWN_N_REGIONS_INCLUDING",
					conditions = {
						"region wh3_main_combi_region_zharr_naggrund",
						"total 1"
					}
				},
				{
					--- Kill the Dwarfs & Grimgor
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_dwf_dwarfs",
						"faction wh_main_dwf_karak_kadrin",
						"faction wh_main_grn_greenskins",
						"confederation_valid"
					}
				}
			}
		}
	},

	-- Faction objectives are used for both the faction and cultural victory conditions
	-- If all playable factions in a subculture share an objective it should be in the subcultures table instad
	-- This table is optional; the script still populates all victory conditions without a faction-specific objective
	factions = {

		-- Karl Franz
		wh_main_emp_empire = {
			objectives = {
				{
					-- Clean up the early game empire threats
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_empire_separatists",
						"faction wh2_dlc11_vmp_the_barrow_legion",
						"faction wh_main_vmp_schwartzhafen",
						"confederation_valid"
					}
				}
			}
		},

		-- Volkmar the Grim
		wh3_main_emp_cult_of_sigmar = {
			objectives = {
				{	
					-- Eliminate Tzeentch and Mannfred
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_tze_oracles_of_tzeentch",
						"faction wh_main_vmp_vampire_counts",
						"confederation_valid"
					}
				}
			}
		},
		--- Elspeth Von Draken
		wh_main_emp_wissenland = {
			objectives = {
				{
					-- Level up Gunnery School to Level 3
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_elspeth_gunnery_school_progression_rank_achieved",
						"script_key gunnery_school_level_3_victory"
					}
				},
				{	
					-- Eliminate Vlad and Festus 
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_vmp_schwartzhafen",
						"faction wh3_dlc20_chs_festus",
						"confederation_valid"
					}
				}
			}
		},

		-- Markus Wulfhart
		wh2_dlc13_emp_the_huntmarshals_expedition = {
			objectives = {
				{
					-- Max out the empire support mechanic
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource emp_progress",
						"total 100"
					}
				},
				{
					-- Take the fight to the local factions
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_lzd_hexoatl",
						"faction wh2_main_lzd_itza",
						"faction wh2_main_skv_clan_pestilens",
						"faction wh2_dlc11_cst_vampire_coast",
						"faction wh2_dlc11_cst_noctilus",
						"confederation_valid",
					}
				}
			},
			long_objectives = {
				{
					-- Markus + allies control the lustriabowl
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {	
						"total 19",
						"override_text mission_text_text_wh_main_objective_override_mazdamundi_control",
						"province wh3_main_combi_province_culchan_plains",
						"province wh3_main_combi_province_headhunters_jungle",
						"province wh3_main_combi_province_spine_of_sotek",
						"province wh3_main_combi_province_the_lost_valley",
						"province wh3_main_combi_province_river_qurveza",
						"province wh3_main_combi_province_mosquito_swamps",
						"province wh3_main_combi_province_the_gwangee_valley",
						"province wh3_main_combi_province_the_turtle_isles",
						"province wh3_main_combi_province_scorpion_coast",
						"province wh3_main_combi_province_the_creeping_jungle",
						"province wh3_main_combi_province_jungles_of_green_mist",
						"province wh3_main_combi_province_aymara_swamps",
						"province wh3_main_combi_province_jungles_of_pahualaxa",
						"province wh3_main_combi_province_the_isthmus_coast",
						"province wh3_main_combi_province_isthmus_of_lustria",
						"province wh3_main_combi_province_copper_desert",
						"province wh3_main_combi_province_the_night_forest_road",
						"province wh3_main_combi_province_the_capes",
						"province wh3_main_combi_province_volcanic_islands"
					}
				}
			},
			no_subculture_objective = true
		},

		-- Balthasar Gelt
		wh2_dlc13_emp_golden_order = {
			objectives = {
				{
					-- Use College of Magic Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_gelt_college_of_magic_short_victory",
						"script_key college_of_magic_short",
						"total 12",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Eliminate snikch/Lokhir
					type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
					conditions = {
						"total 30"
					}
				}
			},
			long_objectives = {
				
				{
					-- Use College of Magic Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_gelt_college_of_magic_long_victory",
						"script_key college_of_magic_long",
						"total 24",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Gelt and Allies to control all of Cathay 
					type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
					conditions = {	
						"total 60"
					}
				}
			},
			no_subculture_objective = true,
			no_alignment_objective = true
		},

		-- Orion
		wh_dlc05_wef_wood_elves = {
			objectives = {
				{
					-- Heal Athel Loren
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_athel_healed",
						"script_key athel_healed"
					}
				}
			}
		},

		-- Durthu
		wh_dlc05_wef_argwylon = {
			objectives = {
				{
					-- Destroy the Barrow Legion
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc11_vmp_the_barrow_legion",
						"confederation_valid"
					}
				}
			}
		},

		-- Sisters of Twilight
		wh2_dlc16_wef_sisters_of_twilight = {
			objectives = {
				{
					--Heal 2 of the World Roots
					type = "PERFORM_RITUAL",
					conditions = {
						"ritual_category WORLDROOTS_HEALING",
						"total 2"
					}
				}
			}
		},

		-- Drycha
		wh2_dlc16_wef_drycha = {
			objectives = {
				{
					-- Hold the key WEF provinces
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 5",
						"province wh3_main_combi_province_argwylon",
						"province wh3_main_combi_province_wydrioth",
						"province wh3_main_combi_province_yn_edri_eternos",
						"province wh3_main_combi_province_talsyn",
						"province wh3_main_combi_province_torgovann"
						
					}
				}
			}
		},

		-- Tyrion
		wh2_main_hef_eataine = {
			objectives = {
				{
					-- Beat up the primary dark elves
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_cult_of_pleasure",
						"faction wh2_main_def_naggarond",
						"confederation_valid"
					}
				}
			}
		},

		-- Teclis
		wh2_main_hef_order_of_loremasters = {
			objectives = {
				{
					-- Mount an offensive on the bordering Southern Chaos factions
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_tze_sarthoraels_watchers",
						"faction wh3_main_skv_clan_morbidus",
						"faction wh3_main_tze_oracles_of_tzeentch",
						"faction wh3_main_nur_bubonic_swarm",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
				{
					-- Control at least 6 of the Elven Colony ports
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 6",
						"region wh3_main_combi_region_fortress_of_dawn",
						"region wh3_main_combi_region_tower_of_the_sun",
						"region wh3_main_combi_region_tower_of_the_stars",
						"region wh3_main_combi_region_tor_elasor",
						"region wh3_main_combi_region_gronti_mingol",
						"region wh3_main_combi_region_citadel_of_dusk",
						"region wh3_main_combi_region_the_star_tower",
						"region wh3_main_combi_region_great_turtle_isle",
						"region wh3_main_combi_region_arnheim",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
					}
				}
			},
			no_subculture_objective = true
		},

		-- Alarielle the Radiant
		wh2_main_hef_avelorn = {
			objectives = {
				{
					-- Mount an offensive on the bordering Chaos/DEF factions
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_scourge_of_khaine",
						"faction wh2_main_def_cult_of_excess",
						"faction wh3_main_sla_seducers_of_slaanesh",
						"confederation_valid"
					}
				}
			}
		},

		-- Alith Anar
		wh2_main_hef_nagarythe = {
			objectives = {
				{
					-- Destroy Malekith
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_naggarond",
						"confederation_valid"
					}
				},
				{
					-- Hold the Nagarythe province
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 1",
						"province wh3_main_combi_province_nagarythe"
					}
				}
			}
		},

		-- Eltharion
		wh2_main_hef_yvresse = {
			objectives = {
				{
					-- Upgrade Athel Tamarha
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_upgrade_athel_tamarha_victory",
						"script_key athel_tamarha_upgrades_attained"
					}
				},
				{
					-- Destroy surrounding Greenskins and Chaos
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_top_knotz", 
						"faction wh_main_grn_teef_snatchaz",
						"faction wh_main_grn_orcs_of_the_bloody_hand",
						"faction wh3_main_kho_exiles_of_khorne",
						"confederation_valid"
					}
				},
			},
			long_objectives = {
				{
					-- Max out Athel Tamarha
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_upgrade_max_athel_tamarha_victory",
						"script_key athel_tamarha_max_upgrades_attained"
					}
				},
				{
					-- Destroy key threats, including key rival Grom the Paunch
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_necksnappers",
						"faction wh_main_grn_scabby_eye",
						"faction wh2_main_skv_clan_mors",
						"faction wh2_main_skv_clan_skryre",
						"faction wh2_dlc15_grn_broken_axe",
						"confederation_valid"
					}
				},
				{
					-- Maintain control of your namesake, Tor Yvresse
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_tor_yvresse",
						"override_text mission_text_text_mis_upgrade_tor_yvresse_safe"
					}
				}
			},
			no_subculture_objective = true
		},

		-- Imrik
		wh2_dlc15_hef_imrik = {
			objectives = {
				{
					-- Destroy Tretch and Ku'gath 
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc09_skv_clan_rictus",
						"faction wh3_main_nur_poxmakers_of_nurgle",
						"confederation_valid"
					}
				},
				{
					-- Encounter special Dragons with Imrik
					type = "SCRIPTED",
					conditions = {
						"script_key dragon_encounters",
						"override_text mission_text_text_mis_activity_encounter_special_dragons"
					}
				},
			},
			long_objectives = {
				{
					-- Eliminate the chaos and destruction threats in the west
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_skv_clan_mors",
						"faction wh_main_grn_orcs_of_the_bloody_hand",
						"faction wh3_main_kho_exiles_of_khorne",
						"confederation_valid"
					}
				},
				{
					-- Encounter even more special Dragons with Imrik
					type = "SCRIPTED",
					conditions = {
						"script_key dragon_encounters_all",
						"override_text  mission_text_text_mis_activity_encounter_special_dragons_all"
					}
				}
			},
			no_subculture_objective = true
		},
		
		-- Belegar Ironhammer
		wh_main_dwf_karak_izor = {
			objectives = {
				{
					-- Destroy the other factions contesting Karak Eight Peaks
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_necksnappers",
						"faction wh_main_grn_crooked_moon",
						"faction wh2_main_skv_clan_mors",
						"confederation_valid"
					}
				},
				{
					-- Capture Karak Eight Peaks
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_karak_eight_peaks"
					}
				}
			}
		},

		-- Thorgrim Grudgebearer
		wh_main_dwf_dwarfs = {
			objectives = {
				{
					-- Complete one of Thorgrim's core grudges
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_thorgrim_grudge_actions_completed_success",
						"script_key thorgrim_grudge_short_victory",
						"total 2",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Kill Skarsnik
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_crooked_moon",
						"confederation_valid"
					}
				}
			}
		},

		-- Thorek Ironbrow
		wh2_dlc17_dwf_thorek_ironbrow = {
			objectives = {
				{
					-- Forge the artifacts
					type = "SCRIPTED",
					conditions = {
						"script_key artefacts_crafted_victory_objective_me_0",
						"override_text mission_text_text_mis_activity_craft_artefacts_some"
					}
				}
			}
		},

		-- Ungrim Ironfist
		wh_main_dwf_karak_kadrin = {
			objectives = {
				{
					-- Build the slayer shrine
					type = "CONSTRUCT_N_BUILDINGS_INCLUDING",
					conditions = {
						"total 1",
						"building_level wh_main_special_great_slayer_shrine"
					}
				},
				{
					-- Achieve rank X with character
					type = "ACHIEVE_CHARACTER_RANK",
					conditions = {
						"total 1",
						"total2 25",
						"start_pos_character 724031729",
						"include_generals"
					}
				}
			}
		},

		-- Grombrindal
		wh3_main_dwf_the_ancestral_throng = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy Naggarond
						"faction wh2_main_def_naggarond",
						"confederation_valid"
					}
				}
			}
		},
		---Malakai
		wh3_dlc25_dwf_malakai = {
			objectives = {
				{
					-- Complete Several Oaths of iron and glory battles
					type = "SCRIPTED",
					conditions = {
						"script_key oath_iron_glory_short_victory",
						"override_text mission_text_text_malakai_oath_steel_glory_short_victory",
						"total 4",
						"count 0",
						"count_completion"
					}
				},
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy Astragoth and Archaon
						"faction wh_main_chs_chaos",
						"faction wh3_dlc23_chd_astragoth",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
				{
					-- Complete Several Oaths of iron and glory battles
					type = "SCRIPTED",
					conditions = {
						"script_key oath_iron_glory_long_victory",
						"override_text mission_text_text_malakai_oath_steel_glory_long_victory",
						"total 7",
						"count 0",
						"count_completion"
					}
				},
				{
				type = "DESTROY_FACTION",
				conditions = {
					-- Destroy Chaos Dwarfs and Grimgor
					"faction wh3_dlc23_chd_legion_of_azgorh",
					"faction wh3_dlc23_chd_conclave",
					"faction wh_main_grn_greenskins",
					"confederation_valid"
					}
				}
			}, 
			no_subculture_objective = true	
		},
		-- Louen Leoncoeur
		wh_main_brt_bretonnia = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy Mousillon
						"faction wh_main_vmp_mousillon",
						"confederation_valid"
					}
				}
			}
		},

		-- Alberic de Bordeleaux
		wh_main_brt_bordeleaux = {
			objectives = {
				{
					-- Complete Alberic's Grail Vow
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_complete_grail_vow_alberic",
						"script_key alberic_grail_vow_success"
					}
				}
			}
		},

		-- Fay Enchantress
		wh_main_brt_carcassonne = {
			objectives = {
				{
					-- Complete Fay Enchantress' Trothe of Virtue
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_complete_troth_of_virute_vow_enchantress",
						"script_key enchantress_virtue_success"
					}
				}
			}
		},

		-- Repanse de Lyonesse
		wh2_dlc14_brt_chevaliers_de_lyonesse = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy Mannfred & Arkhan
						"faction wh_main_vmp_vampire_counts",
						"faction wh2_dlc09_tmb_followers_of_nagash",
						"confederation_valid"
					}
				}
			}
		},

		-- Mazdamundi
		wh2_main_lzd_hexoatl = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- destroy the surrounding chaos factions
						"faction wh3_dlc20_sla_keepers_of_bliss",
						"faction wh2_main_nor_skeggi",
						"confederation_valid"
					}
				}
			}
		},

		-- Kroq Gar
		wh2_main_lzd_last_defenders = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- beat up nearby Skaven, Vampires and Greenskins
						"faction wh3_main_skv_clan_morbidus",
						"faction wh2_main_skv_clan_mordkin",
						"faction wh2_main_vmp_the_silver_host",
						"faction wh_main_vmp_vampire_counts", 
						"faction wh2_dlc12_grn_leaf_cutterz_tribe",
						"confederation_valid"
					}
				},
			},
			long_objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy nearby destruction/chaos factions
						"faction wh_main_vmp_vampire_counts",
						"faction wh3_main_kho_exiles_of_khorne",
						"faction wh2_main_skv_clan_mors",
						"faction wh_main_grn_orcs_of_the_bloody_hand",
						"faction wh2_dlc17_bst_malagor",
						"faction wh3_main_nur_poxmakers_of_nurgle",
						"faction wh3_main_tze_oracles_of_tzeentch",
						"confederation_valid"
					}
				},
				{
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						-- Ensure at least 5 of the 7 Southern jungles provinces are in safe hands
						"total 5",
						"province wh3_main_combi_province_the_golden_pass",
						"province wh3_main_combi_province_central_jungles",
						"province wh3_main_combi_province_western_jungles",
						"province wh3_main_combi_province_southern_jungles",
						"province wh3_main_combi_province_the_jungles_of_the_gods",
						"province wh3_main_combi_province_kingdom_of_beasts",
						"province wh3_main_combi_province_the_dragon_isles",
						"override_text mission_text_text_mis_activity_control_n_southern_jungle_provinces"
					}
				},
			},
			no_subculture_objective = true
		},

		-- Tiktaq'to
		wh2_main_lzd_tlaqua = {
			objectives = {
				{
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						-- maintain control of the surrounding jungle provinces
						"total 2",
						"province wh3_main_combi_province_western_jungles",
						"province wh3_main_combi_province_central_jungles"
					}
				},
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- beat up nearby chaos
						"faction wh3_main_tze_oracles_of_tzeentch",
						"confederation_valid"
					}
				}
			}
		},

		-- Gor-Rok
		wh2_main_lzd_itza = {
			objectives = {
				{
					-- beat up nearby chaos and skaven
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_skv_clan_pestilens",
						"faction wh3_dlc20_nur_pallid_nurslings",
						"faction wh3_dlc26_kho_skulltaker",
						"faction wh2_main_skv_clan_spittel",
						"confederation_valid"
					}
				}
			}
		},

		-- Tehenhauin
		wh2_dlc12_lzd_cult_of_sotek = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy nearby skaven 
						"faction wh2_main_skv_clan_pestilens",
						"faction wh2_main_skv_clan_spittel",
						"faction wh3_main_skv_clan_skrat",
						"confederation_valid"
					}
				},
				{
					-- Complete the first stage of the Prophecy of Sotek
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_sotek_stage_one",
						"script_key prophecy_of_sotek_one"
					}
				}
			}
		},

		-- Nakai the Wanderer
		wh2_dlc13_lzd_spirits_of_the_jungle = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Push north through the Vampire Coast & Counts
						"faction wh2_dlc11_def_the_blessed_dread",
						"faction wh3_dlc21_cst_dead_flag_fleet",
						"faction wh3_dlc21_vmp_jiangshi_rebels",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy more servants of darkness - if Pestilens is alive, scripted dilemma will trigger
						"faction wh2_dlc11_def_the_blessed_dread",
						"faction wh3_dlc21_cst_dead_flag_fleet",
						"faction wh3_dlc21_vmp_jiangshi_rebels",
						"faction wh2_main_skv_clan_eshin",
						"faction wh3_dlc20_chs_vilitch",
						"faction wh3_main_vmp_caravan_of_blue_roses",
						"faction wh3_main_nur_poxmakers_of_nurgle",
						"faction wh2_main_skv_clan_pestilens",
						"confederation_valid"
					}
				}
			},
			wh_main_long_victory = {
				payload_bundle = "wh3_main_ie_victory_objective_nakai_long"	
			},
			no_subculture_objective = true
		},

		-- Oxylotl
		wh2_dlc17_lzd_oxyotl = {
			objectives = {
				{
					-- Beat up chaos
					type = "COMPLETE_N_MISSIONS_OF_CATEGORY",
					conditions = {
						"event_category Chaos_Map_Medium",
						"event_category Chaos_Map_Hard",
						"total 6"
					}
				}
			},
			long_objectives = {
				{
					-- Beat up chaos
					type = "COMPLETE_N_MISSIONS_OF_CATEGORY",
					conditions = {
						"event_category Chaos_Map_Medium",
						"event_category Chaos_Map_Hard",
						"total 25"
					}
				}
			},
			no_subculture_objective = true
		},

		-- Tzarina Katarin
		wh3_main_ksl_the_ice_court = {
			objectives = {
				{
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource wh3_main_ksl_support_level_ice_court",
						"total 10"
					}
				}
			}
		},

		-- Kostaltyn  
		wh3_main_ksl_the_great_orthodoxy = {
			objectives = {
				{
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource wh3_main_ksl_support_level_orthodoxy",
						"total 10"
					}
				},
				{
					-- Destroy nearby SKV and Chaos threats
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_skv_clan_moulder",
						"faction wh3_dlc20_chs_azazel",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
			{
				-- Eliminate the remaining major threats near Kislev
				type = "DESTROY_FACTION",
				conditions = {
					"faction wh_main_chs_chaos",
					"faction wh3_main_dae_daemon_prince",
					"faction wh3_dlc20_chs_festus",
					"confederation_valid"
					}
				},
			},
			no_subculture_objective = true
		},

		-- Boris Ursus
		wh3_main_ksl_ursun_revivalists = {
			objectives = {
				{
					-- Beat up Chaos
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_chs_chaos",
						"faction wh3_main_kho_bloody_sword",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
				{
					-- Eliminate surrounding major chaos threats
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_dae_daemon_prince",
						"faction wh_dlc08_nor_wintertooth",
						"faction wh3_dlc20_chs_kholek",
						"confederation_valid"
						}
					},
				},
				no_subculture_objective = true
			},

		-- Mother Ostankya
		wh3_dlc24_ksl_daughters_of_the_forest = {
			objectives = {
				{
					-- Collect 3 of Ostankya's forbidden Hexes
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_short_some",
						"override_text mission_text_text_mis_activity_ostankya_collect_some_hexes"
					}
				},
			},
			long_objectives = {
				{
					--Collect each Hex and win the final Malediction of Ruin Hex battle 
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_victory_5",
						"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_fifth"
					}
				},
				{
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_victory_1",
						"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_first"
					}
				},
				{
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_victory_2",
						"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_second"
					}
				},
				{
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_victory_3",
						"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_fourth"
					}
				},
				{
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_victory_4",
						"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_third"
					}
				},
				{
					type = "SCRIPTED",
					conditions = {
						"script_key hexes_long_all",
						"override_text mission_text_text_mis_activity_ostankya_collect_all_hexes"
					}
				},
		},
			no_alignment_objective = true,
			no_subculture_objective = true
		},
		
		-- Mannfred von Carstein
		wh_main_vmp_vampire_counts = {
			objectives = {
				{
					-- Eliminate Settra, Repanse and Volkmar nearby
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc09_tmb_khemri",
						"faction wh3_main_emp_cult_of_sigmar",
						"faction wh2_dlc14_brt_chevaliers_de_lyonesse",
						"confederation_valid"
					}
				},
				{
					type = "CONTROL_N_PROVINCES_INCLUDING",
						conditions = {
							"total 1",
							"province wh3_main_combi_province_land_of_the_dead",				
						}
				},
			},
			long_objectives = {
				{
					-- Awaken 7 Lords from any Vampiric Bloodline
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_vc_bloodline_awakenings",
						"script_key bloodline_awaken_threshold_victory"
						}
				},
				{
				--Hold key provinces with unique Landmarks/Books of Nagash
				type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 6",
						"province wh3_main_combi_province_broken_teeth",
						"province wh3_main_combi_province_crater_of_the_waking_dead",
						"province wh3_main_combi_province_great_mortis_delta",
						"province wh3_main_combi_province_marshes_of_madness",
						"province wh3_main_combi_province_eight_peaks",
						"province wh3_main_combi_province_the_plain_of_bones"

					}
				},
				
			},
			no_subculture_objective = true
		},	

		-- Heinrich Kemmler
		wh2_dlc11_vmp_the_barrow_legion = {
			objectives = {
				{
					-- Eliminate Durthu
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_dlc05_wef_argwylon",
						"confederation_valid"
					}
				},
				{
					-- maintain control of Brettonian Provinces leading to the WEF's
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 3",
						"province wh3_main_combi_province_bastonne",
						"province wh3_main_combi_province_forest_of_chalons",
						"province wh3_main_combi_province_carcassonne"
					}
				}
			}
		},

		-- Vlad / Isabella von Carstein
		wh_main_vmp_schwartzhafen = {
			objectives = {
				{
					-- Control northern and southern Sylvania
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 2",
						"province wh3_main_combi_province_northern_sylvania",
						"province wh3_main_combi_province_southern_sylvania"
				}
			},
				{
					-- Hold Altdorf
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_altdorf"
					}
				}
			}
		},

		-- Helman Ghorst
		wh3_main_vmp_caravan_of_blue_roses = {
			objectives = {
				{
					-- Destroy Ku'Gath
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_nur_poxmakers_of_nurgle",
						"confederation_valid"
					}
				},
				{
					-- Control Nagashizzar
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_nagashizzar"
					}
				}
			}
		},

		-- Settra the Imperishable
		wh2_dlc09_tmb_khemri = {
			objectives = {
				{
					-- Eliminate Arkhan, Volkmar and Mannfred
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc09_tmb_followers_of_nagash",
						"faction wh3_main_emp_cult_of_sigmar",
						"faction wh_main_vmp_vampire_counts",
						"confederation_valid"
					}
				}
			}
		},

		-- Grand Hierophant Khatep
		wh2_dlc09_tmb_exiles_of_nehek = {
			objectives = {
				{
					-- Awaken all four Legions of Legend units via the Mortuary Cult
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_legions_of_legends_all",
						"script_key mortuary_cult_all_victory"
					}
				}
			}
		},

		-- Arkhan the Black
		wh2_dlc09_tmb_followers_of_nagash = {
			objectives = {
				{
					-- Eliminate the other Tomb Kings
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc09_tmb_khemri",
						"faction wh2_dlc09_tmb_lybaras",
						"confederation_valid"
					}
				}
			}
		},

		-- High Queen Khalida
		wh2_dlc09_tmb_lybaras = {
			objectives = {
				{
					-- Eliminate nearby Vampires
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_vmp_the_silver_host",
						"faction wh2_main_vmp_necrarch_brotherhood",
						"faction wh_main_vmp_vampire_counts",
						"faction wh3_main_ie_vmp_sires_of_mourkain",
						"confederation_valid"
					}
				}
			},
			long_objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						-- Destroy the Followers of Nagash
						"faction wh2_dlc09_tmb_followers_of_nagash",
						"confederation_valid"
					}
				}
			},
			no_subculture_objective = false
		},

		--Greasus Goldtooth
		wh3_main_ogr_goldtooth = {
			objectives = {
				{
					-- Hold the Great Maw & the Mountains of Mourn provinces
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 3",
						"province wh3_main_combi_province_mountains_of_mourn",
						"province wh3_main_combi_province_ivory_road",
						"province wh3_main_combi_province_bone_road"
					}
				},
				{
					-- Use Greasus Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_greasus_tyrants_demands_short_victory",
						"script_key greasus_tyrants_demands_short",
						"total 12",
						"count 0",
						"count_completion"
					}
				},
			},
			long_objectives = {
				{
					-- Use Greasus Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_greasus_tyrants_demands_long_victory",
						"script_key greasus_tyrants_demands_long",
						"total 24",
						"count 0",
						"count_completion"
					}
				},
			}
		},

		-- Skrag the Slaughterer
		wh3_main_ogr_disciples_of_the_maw = {
			objectives = {
				{
					-- Obtain the Cauldron of the Maw
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_cauldron_of_maw",
						"script_key cauldron_of_maw_obtained"
					}
				},
				{
					-- Destroy the Border Princes
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_teb_border_princes",
						"confederation_valid"
					}
				}
			}
		},

		-- Golgfag Maneater
		wh3_dlc26_ogr_golgfag = {
			objectives = {				
				{
					-- Golgfags Contracts completed
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_golgfag_contracts_short_victory",
						"script_key golgfag_contracts_short",
						"total 15",
						"count 0",
						"count_completion"
					}
				},
			},
			long_objectives = {
				{
					-- Golgfags Contracts completed
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_golgfag_contracts_long_victory",
						"script_key golgfag_contracts_long",
						"total 25",
						"count 0",
						"count_completion"
					}
				},
			}
		},

		--Miao Ying
		wh3_main_cth_the_northern_provinces = {
			objectives = {
				{
					-- Control the Bastions and the Northern Provinces
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 6",
						"province wh3_main_combi_province_gunpowder_road",
						"province wh3_main_combi_province_lands_of_stone_and_steel",
						"province wh3_main_combi_province_imperial_road", 
						"province wh3_main_combi_province_western_great_bastion",
						"province wh3_main_combi_province_central_great_bastion",
						"province wh3_main_combi_province_eastern_great_bastion"
					}
				},
			}
		},

		--Zhao Ming
		wh3_main_cth_the_western_provinces = {
			objectives = {
				{
					-- Destroy the Dissenters of Jinshen
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_cth_dissenter_lords_of_jinshen",
						"confederation_valid"
					}
				},
				{
					-- Control the Warpstone Desert, Wastelands of Jinshin and Ivory Road into Cathay
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 3",
						"province wh3_main_combi_province_warpstone_desert",
						"province wh3_main_combi_province_wastelands_of_jinshen", 
						"province wh3_main_combi_province_ivory_road"
					}
				}
			}
		},
	
			-- Yuan Bo, The Jade Dragon
			wh3_dlc24_cth_the_celestial_court = {
				objectives = {
					{
						-- Complete 2 of the 4 astromantic relays
						type = "SCRIPTED",
						conditions = {
							"script_key empower_compass",
							"override_text mission_text_text_wh3_dlc24_victory_complete_astromantic_relays"
						}
					}
				},
				long_objectives = {
					{
						-- Complete the north astromantic relay
						type = "SCRIPTED",
						conditions = {
							"script_key empower_compass_north",
							"override_text  mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_north_ie"
						}
					},
					{
						-- Complete the east astromantic relay
						type = "SCRIPTED",
						conditions = {
							"script_key empower_compass_east",
							"override_text  mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_east_ie"
						}
					},
					{
						-- Complete the south astromantic relay
						type = "SCRIPTED",
						conditions = {
							"script_key empower_compass_south",
							"override_text  mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_south_ie"
						}
					},
					{
						-- Complete the west astromantic relay
						type = "SCRIPTED",
						conditions = {
							"script_key empower_compass_west",
							"override_text  mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_west_ie"
						}
					},
					{
						-- win the final battle
						type = "SCRIPTED",
						conditions = {
							"script_key final_battle",
							"override_text mission_text_text_wh3_dlc24_victory_yuan_bo_final_battle"
						}
					}
				},
				no_alignment_objective = true,
				no_subculture_objective = true
			},
	

		--Grimgor Ironhide
		wh_main_grn_greenskins = {
			objectives = {
				{
					-- Control X nearby capital regions belonging to strong Legendary Lords
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 5",
						"region wh3_main_combi_region_great_hall_of_greasus",
						"region wh3_main_combi_region_black_crag",
						"region wh3_main_combi_region_crookback_mountain",
						"region wh3_main_combi_region_nan_gau",
						"region wh3_main_combi_region_karak_eight_peaks",
						"region wh3_main_combi_region_karaz_a_karak",
						"region wh3_main_combi_region_castle_drakenhof",
						"region wh3_main_combi_region_kislev",
						"region wh3_main_combi_region_hell_pit",
						"region wh3_main_combi_region_khazid_irkulaz",
						"region wh3_main_combi_region_hanyu_port",
						"region wh3_main_combi_region_the_fortress_of_vorag",
						"region wh3_main_combi_region_the_tower_of_torment",  
						"region wh3_main_combi_region_the_challenge_stone",
						"region wh3_main_combi_region_uzkulak",
						"region wh3_main_combi_region_black_fortress",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
					}
				}
			}
		},

		--Azhag the Slaughterer
		wh2_dlc15_grn_bonerattlaz = {
			objectives = {
				{
					-- Control the nearby Dwarven/Kislev/Empire provinces with favourable climates
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 5",
						"province wh3_main_combi_province_northern_worlds_edge_mountains",
						"province wh3_main_combi_province_ostermark", 
						"province wh3_main_combi_province_river_urskoy",
						"province wh3_main_combi_province_ostland",
						"province wh3_main_combi_province_peak_pass"
					}
				}
			}
		},

		--Wuurzag Da Great Green Prophet  
		wh_main_grn_orcs_of_the_bloody_hand = {
			objectives = {
				{
					-- Obtain any of Wuurzag's unique items
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_complete_wuurzag_any_quest_battle",
						"script_key baleful_squiggly_bonewood_obtained"
					}
				},
				{
					-- Build the Wurrzag landmarks
					type = "CONSTRUCT_N_BUILDINGS_FROM",
					conditions = {
						"total 3",
						"building_level wh3_dlc26_special_bone_nose_idols_1",
						"building_level wh3_dlc26_special_bonewood_totems_1",
						"building_level wh3_dlc26_special_iron_penz_1",
					}
				},
				{
					-- Build the Wurrzag landmarks
					type = "CONSTRUCT_N_OF_A_BUILDING",
					conditions = {
						"total 3",
						"building_level wh3_dlc26_special_gork_mork_idols_1",
					}
				}
			},
			long_objectives = {
				{
					-- Build the Wurrzag landmarks
					type = "CONSTRUCT_N_OF_A_BUILDING",
					conditions = {
						"total 6",
						"building_level wh3_dlc26_special_gork_mork_idols_1",
					}
				}
			}
		},

		--Grom the Paunch
		wh2_dlc15_grn_broken_axe = {
			objectives = {
				{
					-- Hold Tor Yvresse 
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_tor_yvresse"
					}
				}
			}
		},

		--Gorbad Ironclaw
		wh3_dlc26_grn_gorbad_ironclaw = {
			objectives = {
				{
					-- Control the Badlands
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 5",
						"province wh3_main_combi_province_western_badlands",
						"province wh3_main_combi_province_southern_badlands",
						"province wh3_main_combi_province_eastern_badlands",
						"province wh3_main_combi_province_death_pass",
						"province wh3_main_combi_province_blood_river_valley",
						
					},
				},
				{
					-- Use Da Plan Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_gorbad_da_plan_short_victory",
						"script_key gorbad_da_plan_short",
						"total 5",
						"count 0",
						"count_completion"
					}
				}
			},
			long_objectives = {
				{
					-- Control the Gorbad's thematic Empire provinces
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 3",
						"province wh3_main_combi_province_wissenland",
						"province wh3_main_combi_province_reikland",
						"province wh3_main_combi_province_solland",
						
					}
				},
				{
					-- Use Da Plan Feature 
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_gorbad_da_plan_long_victory",
						"script_key gorbad_da_plan_long",
						"total 10",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Destroy the Gorbad's thematic Empire factions 
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_empire",
						"faction wh_main_emp_wissenland",
						"confederation_valid"
					}
				},
			}
		},

		--Khazrak the One Eyed
		wh_dlc03_bst_beastmen = {
			objectives = {
				{
					-- Destroy Middenland/Boris Todbringer
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_middenland",
						"confederation_valid"
					}
				}
			}
		},

		--Malagor the Dark Omen
		wh2_dlc17_bst_malagor = {
			objectives = {
				{
					-- Reach level 6 Ruination
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource bst_ruination",
						"total 220"
					}
				}
			}
		},

		--Morghur the Shadowgave
		wh_dlc05_bst_morghur_herd = {
			objectives = {
				{
					-- Reach level 6 Ruination
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource bst_ruination",
						"total 220"
					}
				},
				{
					-- Destroy nearby Empire, Brettonia and Wood Elves
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_teb_estalia",
						"faction wh_main_brt_carcassonne",
						"faction wh_dlc05_wef_wood_elves",
						"confederation_valid"
					}
				}
			}
		},

		-- Skarsnik
		wh_main_grn_crooked_moon = {
			objectives = {
				{
					-- Destroy the other factions contesting Karak Eight Peaks
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_necksnappers",
						"faction wh_main_dwf_karak_izor",
						"faction wh2_main_skv_clan_mors",
						"confederation_valid"
					}
				},
				{
					-- Capture Karak Eight Peaks
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_karak_eight_peaks"
					}
				}
			}
		},

		--Taurox the Brass Bull
		wh2_dlc17_bst_taurox = {
			objectives = {
				{
					-- Reach level 6 Ruination
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource bst_ruination",
						"total 220"
					}
				}
			}
		},

		-- Wulfrick the Wanderer
		wh_dlc08_nor_norsca = {
			objectives = {
				{
					-- Obtain level 2 favour with any god
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_attain_god_favour_2", 
						"script_key attain_chaos_god_favour_lvl_2"
					}
				}
			}
		},

		-- Throgg
		wh_dlc08_nor_wintertooth = {
			objectives = {
				{
					-- Destroy nearby Dwarves and Kislev
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_dlc25_dwf_malakai",
						"faction wh3_main_ksl_ropsmenn_clan",
						"faction wh3_main_ksl_the_ice_court",
						"faction wh3_main_ksl_the_great_orthodoxy",
						"confederation_valid"
					}
				}
			}
		},

		-- Luthor Harkon
		wh2_dlc11_cst_vampire_coast = {
			objectives = {
				{
					-- Restore Harkon's Mind
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_restore_harkons_mind", 
						"script_key restore_harkon_mind"
					}
				}
			}
		},

		-- Count Noctilus
		wh2_dlc11_cst_noctilus = {
			objectives = {
				{
					-- Obtain 1/3 of max infamy
					type = "HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
					conditions = {
						"pooled_resource cst_infamy",
						"total 8000"
					}
				}
			}
		},

		--Aranessa Saltspite
		wh2_dlc11_cst_pirates_of_sartosa = {
			objectives = {
				{
					-- Destroy the Dreadfleet
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc11_cst_noctilus",
						"confederation_valid"
					}
				},
				{
					-- Hold The Galleon�s Graveyard 
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_the_galleons_graveyard"
					}
				}
			}
		},

		-- Cylostra Direfin
		wh2_dlc11_cst_the_drowned = {
			objectives = {
				{
					-- Obtain the first sea shanty
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_gain_first_shanty",
						"script_key shanty_one_obtained"
					}
				}
			}
		},

		-- Queek Headtaker
		wh2_main_skv_clan_mors = {
			objectives = {
				{
					-- Destroy the other factions contesting Karak Eight Peaks
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_grn_necksnappers",
						"faction wh_main_grn_crooked_moon",
						"faction wh_main_dwf_karak_izor",
						"confederation_valid"
					}
				},
				{
					-- Capture Karak Eight Peaks
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_karak_eight_peaks"
					}
				}
			}
		},

		-- Skrolk
		wh2_main_skv_clan_pestilens = {
			objectives = {
				{
					-- Capture key lizardmen temples
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 4",
						"region wh3_main_combi_region_itza",
						"region wh3_main_combi_region_hexoatl",
						"region wh3_main_combi_region_tlaxtlan",
						"region wh3_main_combi_region_xlanhuapec"
					}
				}
			}
		},

		-- Ikit Claw
		wh2_main_skv_clan_skryre = {
			objectives = {
				{
					-- Level up the Forbidden Workshop to Rank 3
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_workshop_rank_achieved",
						"script_key workshop_rank_3_victory"
					}
				},
				{
					-- Destroy nearby Empire and Bretonnian's
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_teb_estalia",
						"faction wh_main_teb_tilea",
						"faction wh_main_brt_carcassonne",
						"confederation_valid"
					}
				}
			}
		},

		-- Tretch Craventail
		wh2_dlc09_skv_clan_rictus = {
			objectives = {
				{
					-- Destroy nearby hostile Greenskins and Imrik
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_grn_moon_howlerz",  
						"faction wh2_dlc15_hef_imrik",
						"confederation_valid"
					}
				}
			}
		},
		
		-- Deathmaster Snikch
		wh2_main_skv_clan_eshin = {
			objectives = {
				{
					-- Complete 8 Eshin Actions
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_perform_eshin_actions",
						"script_key snikch_eshin_actions_complete"
					}
				},
				{
					-- Destroy nearby hostile Greenskins and push towards Cathay
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_grn_dimned_sun",  
						"faction wh3_main_cth_celestial_loyalists",
						"faction wh3_main_cth_the_northern_provinces",
						"confederation_valid"
					}
				}
			}
		},

		-- Throt the Unclean
		wh2_main_skv_clan_moulder = {
			objectives = {
				{
					-- Destroy the big Kislev factions nearby
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_ksl_the_great_orthodoxy",
						"faction wh3_main_ksl_the_ice_court",
						"confederation_valid"
					}
				}
			}
		},

		-- Malekith
		wh2_main_def_naggarond = {
			objectives = {
				{
					-- Destroy Tyrion
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_hef_eataine",
						"confederation_valid"
					}
				},
				{
					-- Capture Lothern
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_lothern"
					}
				}
			}
		},

		-- Morathi
		wh2_main_def_cult_of_pleasure = {
			objectives = {
				{
					-- Destroy Crone Hellebron
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_har_ganeth",
						"confederation_valid"
					}
				}
			}
		},

		-- Hellebron
		wh2_main_def_har_ganeth = {
			objectives = {
				{
					-- Destroy Morathi
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_cult_of_pleasure",
						"confederation_valid"
					}
				},
				{
					-- Capture Morathi's lair
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_ancient_city_of_quintex",
						"override_text mission_text_text_mis_activity_control_n_regions_quintex"
					}
				}
			}
		},

		-- Lokir Felheart
		wh2_dlc11_def_the_blessed_dread = {
			objectives = {
				{
				-- Control 5 / 7 of the key Cathayan coastal regions
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 5",
						"region wh3_main_combi_region_shi_long",
						"region wh3_main_combi_region_bridge_of_heaven",
						"region wh3_main_combi_region_hanyu_port",
						"region wh3_main_combi_region_haichai",
						"region wh3_main_combi_region_beichai",
						"region wh3_main_combi_region_zhanshi",
						"region wh3_main_combi_region_li_zhu",
						"override_text mission_text_text_mis_activity_control_n_regions_cathayan_ports"
					}
				}
			}
		},

		 -- Malus
		 wh2_main_def_hag_graef = {
			objectives = {
				{
					-- Obtain the Swarpsword of Khaine
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_mis_activity_complete_warpsword_of_khaine",
						"script_key warpsword_of_khaine_obtained"
					}
				}
			}
		},

		-- Rakarth 
		wh2_twa03_def_rakarth = {
			objectives = {
				{
					-- Obtain the Whip of Agony
					type = "SCRIPTED",
					conditions = {
						"script_key whip_of_agony_obtained",
						"override_text mission_text_text_mis_activity_complete_whip_of_agony"
					}
				},
				{
					-- Control the Turtle Isles
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 1",
						"province wh3_main_combi_province_the_turtle_isles"
					}
				}
			}
		},

		-- The Daemon Prince
		wh3_main_dae_daemon_prince = {
			objectives = {
				{
						-- Ascend with a Chaos God/Chaos Undivided
						type = "SCRIPTED",
						conditions = {
							"script_key daemon_prince_ascend_ritual",
							"override_text mission_text_text_wh3_main_narrative_mission_description_ascend"
					}
				}
			}
		},

		-- Archaon the Everchosen
		wh_main_chs_chaos = {
			objectives = {
				{
					-- Destroy or Vassalise the Ice Court & Boris
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_ksl_the_ice_court",
						"faction wh3_main_ksl_ursun_revivalists",
						"confederation_valid",
						"vassalization_valid"
					}
				},
				{
					-- Control the Blood Marshes and Skull Road
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 2",
						"province wh3_main_combi_province_the_blood_marshes",
						"province wh3_main_combi_province_the_skull_road"
					}
				}
			},
			long_objectives = {
				{
					-- Bring ruin to the Empire of Man
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh_main_emp_empire",
						"faction wh_main_emp_averland",
						"faction wh_main_emp_hochland",
						"faction wh_main_emp_middenland",
						"faction wh_main_emp_marienburg",
						"faction wh_main_emp_nordland",
						"faction wh_main_emp_ostland",
						"faction wh_main_emp_ostermark",
						"faction wh_main_emp_stirland",
						"faction wh_main_emp_talabecland",
						"faction wh_main_emp_wissenland",
						"confederation_valid"
					}
				},
				{
					-- Capture at least 9 of the Dark Fortress regions
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 9",
						"region wh3_main_combi_region_ancient_city_of_quintex",
						"region wh3_main_combi_region_altar_of_the_crimson_harvest",
						"region wh3_main_combi_region_black_rock",
						"region wh3_main_combi_region_black_fortress",
						"region wh3_main_combi_region_brass_keep",
						"region wh3_main_combi_region_bloodwind_keep",
						"region wh3_main_combi_region_daemons_gate",
						"region wh3_main_combi_region_dagraks_end",
						"region wh3_main_combi_region_doomkeep",
						"region wh3_main_combi_region_fortress_of_the_damned",
						"region wh3_main_combi_region_karak_dum",
						"region wh3_main_combi_region_karak_vlag",
						"region wh3_main_combi_region_konquata",
						"region wh3_main_combi_region_middenheim",
						"region wh3_main_combi_region_monolith_of_borkill_the_bloody_handed",
						"region wh3_main_combi_region_nuln",
						"region wh3_main_combi_region_okkams_forever_maze",
						"region wh3_main_combi_region_praag",
						"region wh3_main_combi_region_red_fortress",
						"region wh3_main_combi_region_tower_of_gorgoth",
						"region wh3_main_combi_region_zanbaijin",
						"region wh3_main_combi_region_the_challenge_stone",
						"region wh3_main_combi_region_the_crystal_spires",
						"region wh3_main_combi_region_the_godless_crater",
						"region wh3_main_combi_region_the_forbidden_citadel",
						"region wh3_main_combi_region_the_frozen_city",
						"region wh3_main_combi_region_the_howling_citadel",
						"region wh3_main_combi_region_the_lost_palace",
						"region wh3_main_combi_region_the_monolith_of_katam",
						"region wh3_main_combi_region_the_palace_of_ruin",
						"region wh3_main_combi_region_the_silvered_tower_of_sorcerers",
						"region wh3_main_combi_region_the_tower_of_khrakk",
						"region wh3_main_combi_region_the_twisted_towers",
						"region wh3_main_combi_region_the_writhing_fortress",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
					},
				},
			},
			no_subculture_objective = true
		},

		-- Kholek Suneater
		wh3_dlc20_chs_kholek = {
			objectives = {
				{
					-- Mount an offensive into Cathay
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_cth_imperial_wardens",
						"faction wh3_main_cth_the_northern_provinces",
						"confederation_valid",
						"vassalization_valid"
					}
				},
				{
					-- Capture the dark fortresses towards Cathay
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 2",
						"region wh3_main_combi_region_the_challenge_stone",
						"region wh3_main_combi_region_fortress_of_eyes",
					}
				}
			}
		},

		-- Sigvald the Magnificent
		wh3_dlc20_chs_sigvald = {
			objectives = {
				{
					-- Obtain the Sliverslash
					type = "SCRIPTED",
					conditions = {
						"script_key sliverslash_obtained",
						"override_text mission_text_text_mis_activity_complete_sliverslash"
					}
				},
				{
					-- Control the Western pathway to Naggarond
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 3",
						"province wh3_main_combi_province_the_shard_lands",
						"province wh3_main_combi_province_deadwood",
						"province wh3_main_combi_province_the_road_of_skulls"
					}
				}
			}
		},

		-- Be'lakor
		wh3_main_chs_shadow_legion = {
			objectives = {
				{
					-- Destroy or Vassalise N'kari, Sigvald and the Sightless
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_sla_seducers_of_slaanesh",
						"faction wh3_dlc20_chs_sigvald",
						"faction wh3_dlc20_tze_the_sightless",
						"confederation_valid",
						"vassalization_valid"
					}
				},
				{
					-- Capture 4 of the 10 nearby dark fortresses
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 4",
						"region wh3_main_combi_region_konquata",
						"region wh3_main_combi_region_fortress_of_the_damned",
						"region wh3_main_combi_region_monolith_of_borkill_the_bloody_handed",
						"region wh3_main_combi_region_the_monolith_of_katam",
						"region wh3_main_combi_region_the_frozen_city", 
						"region wh3_main_combi_region_altar_of_the_crimson_harvest", 
						"region wh3_main_combi_region_the_silvered_tower_of_sorcerers",
						"region wh3_main_combi_region_doomkeep",
						"region wh3_main_combi_region_the_palace_of_ruin",
						"region wh3_main_combi_region_dagraks_end",
						"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
				}
				}
			}
		},

		-- Kairos Fateweaver 
		wh3_main_tze_oracles_of_tzeentch = {
			objectives = {
				{
					-- Destroy Teclis, Kroq-gar and Zlatan 
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_lzd_zlatan",
						"faction wh2_main_hef_order_of_loremasters",
						"faction wh2_main_lzd_last_defenders",						
						"confederation_valid"
					}
				}
			}
		},

		-- The Changeling
		wh3_dlc24_tze_the_deceivers = {
			objectives = {
				{
					-- Complete 2 Grand Schemes
					type = "SCRIPTED",
					conditions = {
						"script_key schemes",
						"override_text mission_text_text_wh3_dlc24_objective_the_changeling_short"
					}
				}
			},
			long_objectives = {
				{
					-- Complete 5 Grand Schemes
					type = "SCRIPTED",
					conditions = {
						"script_key schemes_grand",
						"override_text mission_text_text_wh3_dlc24_objective_the_changeling_long_grand_schemes_ie"
					}
				},
				{
					-- Complete the Ultimate Scheme
					type = "SCRIPTED",
					conditions = {
						"script_key schemes",
						"override_text mission_text_text_wh3_dlc24_objective_the_changeling_long"
					}
				}
			},
			wh_main_long_victory = {
				payload_bundle = "wh3_dlc24_ie_victory_objective_changeling_long"	
			},
			no_alignment_objective = true,
			no_subculture_objective = true
		},

		-- N'kari
		wh3_main_sla_seducers_of_slaanesh = {
			objectives = {
				{
					-- Destroy or Vassalise Tyrion, Alarielle, Eltharion
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_hef_avelorn",
						"faction wh2_main_hef_eataine",
						"faction wh2_main_hef_yvresse",
						"confederation_valid",
						"vassalization_valid"
					}
				},
				{
					-- Hold the Shrine of Asuryan
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_shrine_of_asuryan"
					}
				}
			}
			},

		-- Ku'Gath
		wh3_main_nur_poxmakers_of_nurgle = {
			objectives = {
				{
					-- Destroy nearby Dwarf factions and Imrik
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc15_dwf_clan_helhein",
						"faction wh_main_dwf_karak_azul",
						"faction wh3_main_vmp_caravan_of_blue_roses",
						"confederation_valid"
					}
				},
				{
					-- Control the Dragon Isles
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 1",
						"province wh3_main_combi_province_the_dragon_isles"
					}
				}
			}
		},
		--- Tamurkhan
		wh3_dlc25_nur_tamurkhan = {
			objectives = {
				{
					-- Complete Several Chieftains to devoted deference  
					type = "SCRIPTED",
					conditions = {
						"script_key chieftain_devoted_short",
						"override_text mission_text_text_tamurkhan_chieftain_devoted_deference_short",
						"total 3",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Destroy nearby Warriors of Chaos, Ogres and Greenskins
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_dlc20_chs_kholek",
						"faction wh_main_grn_greenskins",
						"faction wh3_main_ogr_goldtooth",
						"confederation_valid"
					}
				}

			},
			long_objectives = {
				{
					-- Complete all Chieftains to devoted deference  
					type = "SCRIPTED",
					conditions = {
						"script_key chieftain_devoted_long",
						"override_text mission_text_text_tamurkhan_chieftain_devoted_deference_short",
						"total 6",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Take Nuln
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_nuln"
					}
				}
					
			},
			no_subculture_objective = true,
			no_alignment_objective = true
		},
		wh3_dlc25_nur_epidemius = {
			objectives = {
				{
					-- Destroy nearby Dwarf factions and Imrik
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_main_def_hag_graef",
						"faction wh3_main_ksl_ursun_revivalists",
						"faction wh3_dlc25_dwf_malakai",
						"confederation_valid"
					}
				},

			},
			long_objectives = {
				{
					-- Destroy Kislev
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_ksl_the_ice_court",
						"faction wh3_main_ksl_the_great_orthodoxy",
						"confederation_valid"
					}
				},
				{
					-- Control the Talabecland Province
					type = "OWN_N_REGIONS_INCLUDING",
					conditions = {
						"total 1",
						"region wh3_main_combi_region_talabheim",
					}
				}
					
			},
			no_subculture_objective = true
		},
		-- Skarbrand 
		wh3_main_kho_exiles_of_khorne = {
			objectives = {
				{
						-- Obtain the Slaughter and Carnage
						type = "SCRIPTED",
						conditions = {
							"script_key slaughter_carnage_obtained",
							"override_text mission_text_text_mis_activity_complete_slaughter_carnage"
					}
				}
			}
		},

		--Skulltaker
		wh3_dlc26_kho_skulltaker = {
			objectives = {
				{
					-- Use Skulltaker's Claok of Skulls feature
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_skulltaker_cloak_of_skulls_short_victory",
						"script_key skulltaker_cloak_of_skulls_short",
						"total 9",
						"count 0",
						"count_completion"
					}
				},
			},
			long_objectives = {
				{
					-- Use Skulltaker's Cloak of skulls feature
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_skulltaker_cloak_of_skulls_long_victory",
						"script_key skulltaker_cloak_of_skulls_long",
						"total 18",
						"count 0",
						"count_completion"
					}
				},
			}
		},

		--Arbaal
		wh3_dlc26_kho_arbaal = {
			objectives = {
				{
					-- Use Arbaal's Wrath of Khorne feature
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_arbaal_wrath_of_khorne_short_victory",
						"script_key arbaal_wrath_of_khorne_short",
						"total 8",
						"count 0",
						"count_completion"
					}
				},
			},
			long_objectives = {
				{
					-- Use Arbaal's Wrath of Khorne feature
					type = "SCRIPTED",
					conditions = {
						"override_text mission_text_text_arbaal_wrath_of_khorne_long_victory",
						"script_key arbaal_wrath_of_khorne_long",
						"total 15",
						"count 0",
						"count_completion"
					}
				},
				{
					-- Eliminate Azazel
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_dlc20_chs_azazel",
						"confederation_valid"
					}
				}
			},
			--no_subculture_objective = true
		},
				
		-- Festus the Leechlord
		wh3_dlc20_chs_festus = {
			objectives = {
				{
					-- Hold nearby Dark Fortresses and the Ice Court's capital
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 3",
						"region wh3_main_combi_region_middenheim",
						"region wh3_main_combi_region_praag",
						"region wh3_main_combi_region_kislev",
					}
				}
			}
		},

		-- Azazel
		wh3_dlc20_chs_azazel = {
			objectives = {
				{
					-- Hold the Norscan mountains
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 5",
						"province wh3_main_combi_province_trollheim_mountains",
						"province wh3_main_combi_province_gianthome_mountains",
						"province wh3_main_combi_province_mountains_of_hel",
						"province wh3_main_combi_province_vanaheim_mountains",
						"province wh3_main_combi_province_mountains_of_naglfari",
					}
				},
			}
		},

		-- Valkia the Bloody   
		wh3_dlc20_chs_valkia = {
			objectives = {
				{
					-- Hold key Dark Elf provinces nearby
					type = "CONTROL_N_PROVINCES_INCLUDING",
					conditions = {
						"total 2",
						"province wh3_main_combi_province_spiteful_peaks",
						"province wh3_main_combi_province_iron_foothills",
					}
				},
				{
					-- Hold nearby Dark Fortresses
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 2",
						"region wh3_main_combi_region_the_palace_of_ruin",
						"region wh3_main_combi_region_the_frozen_city",
					}
				}
			}
		},

		-- Vilitch the Curseling
		wh3_dlc20_chs_vilitch = {
			objectives = {
				{
					-- Hold nearby Dark Fortresses
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 5",
						"region wh3_main_combi_region_red_fortress",
						"region wh3_main_combi_region_bloodwind_keep",
						"region wh3_main_combi_region_fortress_of_eyes",
						"region wh3_main_combi_region_wei_jin",
						"region wh3_main_combi_region_nan_gau",
					}
				}
			}
		},

		-- Drazhoath
		wh3_dlc23_chd_legion_of_azgorh = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh2_dlc09_skv_clan_rictus",
						"faction wh2_dlc15_hef_imrik",
						"confederation_valid"
					}
				}
			}
		},

		-- astragoth
		wh3_dlc23_chd_astragoth = {
			objectives = {
				{
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_vmp_lahmian_sisterhood",
						"faction wh3_dlc25_dwf_malakai",
						"confederation_valid"
					}
				}
			}
		},

		-- Zhatan
		wh3_dlc23_chd_zhatan = {
			objectives = {
				{
					-- seize the Bastion
					type = "CONTROL_N_REGIONS_FROM",
					conditions = {
						"total 3",
						"region wh3_main_combi_region_turtle_gate",
						"region wh3_main_combi_region_dragon_gate",
						"region wh3_main_combi_region_snake_gate",
					},
				},
				{
					type = "DESTROY_FACTION",
					conditions = {
						"faction wh3_main_cth_the_northern_provinces",
						"confederation_valid"
					}
				}
			}
		},

	},
	-- used to track gelts unique ritual objective
	gelt_unique_rituals = {},

	gorbad_unique_initiatives = {}
}

-- This function creates the victory missions for all playable factions
-- Ideally all factions should have subculture and (optionally) faction objectives defined
-- The script supports adding generic victory objectives to factions that are missing data as well
function victory_objectives_ie:initialise_victory_missions(faction_key, multiplayer)
	local faction_subculture_key = cm:get_faction(faction_key):subculture()
	
	-- Set the faction alignment between order/destruction. 
	-- Use the default value if the subculture is missing for w/e reason
	local faction_alignment = self.alignments.default
	if self.subcultures[faction_subculture_key] then
		faction_alignment = self.subcultures[faction_subculture_key].alignment
	end
	
	-- Multiplayer victory
	if multiplayer then
		self:create_multiplayer_mission(faction_key)
	end

	-- Faction victory
	self:create_faction_mission(faction_key, faction_alignment)

	-- Cultural victory
	self:create_long_mission(faction_key, faction_subculture_key, faction_alignment)

	-- Domation victory
	self:create_domination_mission(faction_key)

end

-- The multiplayer victory required a team to paint the map
-- This is generic as it needs to support all combinations of factions vs all combinations
function victory_objectives_ie:create_multiplayer_mission(faction_key)
	local mission_key = "wh3_main_mp_victory"
	local mm = mission_manager:new(faction_key, mission_key)

	self:create_multiplayer_objective(mm, faction_key)

	self:trigger_mission(faction_key, mm, self.victory_type.multiplayer)
end

-- Faction victory utilises the faction unique objectives (if any)
-- We also add the short version of the alignment objective
-- This ensures all factions have an objective, whether or not they have a unique objective specified
function victory_objectives_ie:create_faction_mission(faction_key, faction_alignment)
	local mission_key = "wh_main_short_victory"
	local mm = mission_manager:new(faction_key, mission_key)

	self:create_faction_objective(mm, faction_key)
	self:create_alignment_objective(mm, faction_alignment, mission_key, faction_key)

	self:trigger_mission(faction_key, mm, self.victory_type.faction, mission_key, faction_alignment)
end

-- Long victory combines the faction unique objectives (if any) with the subculture objective
-- We also add the long version of the alignment objective
-- This ensures all factions have an objective, even if they are somehow missing both a faction and subculture objective
function victory_objectives_ie:create_long_mission(faction_key, faction_subculture_key, faction_alignment)
	local mission_key = "wh_main_long_victory"
	local mm = mission_manager:new(faction_key, mission_key)

	-- Add a requirement to complete the shorter faction objective first
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key complete_faction_victory")
	mm:add_condition("override_text mission_text_text_ie_attain_faction_victory")

	-- Populate the mission with the remaining alignment/long objectives
	self:create_alignment_objective(mm, faction_alignment, mission_key, faction_key)
	self:create_long_objective(mm, faction_subculture_key, faction_key)

	self:trigger_mission(faction_key, mm, self.victory_type.subculture, mission_key, faction_alignment)
end

-- Domination victory creates a generic objective to destroy factions of the opposing alignment
-- This guarantees that players painting the map and eliminating factions will eventually trigger a victory, no matter how they do it
function victory_objectives_ie:create_domination_mission(faction_key)
	local mission_key = "wh_main_domination_victory"
	local mm = mission_manager:new(faction_key, mission_key)
	
	self:create_domination_objective(mm, faction_key)

	self:trigger_mission(faction_key, mm, self.victory_type.domination)
end

-- Take the mission manager after objectives have been added, and perform the shared functionality to trigger it
function victory_objectives_ie:trigger_mission(faction_key, mm, victory_type, mission_key, faction_alignment)
	
	-- Add the permanent bonus for completing the objective, if applicable
	local bundle = nil
	if mission_key ~= nil and faction_alignment ~= nil then
		bundle = self.alignments[faction_alignment][mission_key].payload_bundle
		
		-- override the bundle on a faction level if necessary
		if self.factions[faction_key] and self.factions[faction_key][mission_key] then
			bundle = self.factions[faction_key][mission_key].payload_bundle
		end
		
		if is_table(bundle) then
			for i = 1, #bundle do
				if bundle[i] ~= nil then
					mm:add_payload("effect_bundle{bundle_key " .. bundle[i] .. ";turns 0;}")
				end
			end
		else
			if bundle ~= nil then
				mm:add_payload("effect_bundle{bundle_key " .. bundle .. ";turns 0;}")
			end
		end

		ancillary = self.alignments[faction_alignment][mission_key].payload_ancillary
		if is_table(ancillary) then
			for i = 1, #ancillary do
				if ancillary[i] ~= nil then
					mm:add_payload("add_ancillary_to_faction_pool{ancillary_key " .. ancillary[i] .. ";}")
				end
			end
		else
			if ancillary ~= nil then
				mm:add_payload("add_ancillary_to_faction_pool{ancillary_key " .. ancillary .. ";}")
			end
		end
	end

	-- Only add game victory if it's not multiplayer or the short victory. 
	-- If all payloads have failed for whatever reason we forcibly add victory, otherwise the mission will fail to generate
	if (bundle == nil and ancillary == nil) or victory_type == self.victory_type.multiplayer or victory_type == self.victory_type.domination then 
		mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
		mm:add_payload("game_victory")
	end

	-- Setup the mission as an actual victory mission (as this uses different library functions) and trigger it
	mm:set_victory_type(victory_type)
	mm:set_victory_mission(true)
	mm:set_show_mission(false)
	mm:trigger()
end

-- Create objectives for missions 
function victory_objectives_ie:create_multiplayer_objective(mm, faction_key)

	local objectives = self.multiplayer.objectives

	if objectives ~= nil then
		
		self:add_objectives(mm, objectives, faction_key)

	end

end

function victory_objectives_ie:create_faction_objective(mm, faction_key)
	
	if self.factions[faction_key] then

		local objectives = self.factions[faction_key].objectives

		if objectives ~= nil then
			
			self:add_objectives(mm, objectives, faction_key)

		end

	end

end

function victory_objectives_ie:create_alignment_objective(mm, faction_alignment, mission_key, faction_key)

	if not self.factions[faction_key] or (self.factions[faction_key] and self.factions[faction_key].no_alignment_objective ~= true) then

		local objectives = self.alignments[faction_alignment][mission_key].objectives

		if objectives ~= nil then

			self:add_objectives(mm, objectives, faction_key)

		end

	end

end

function victory_objectives_ie:create_long_objective(mm, faction_subculture_key, faction_key)

	local objectives = {}

	if self.factions[faction_key] and self.factions[faction_key].long_objectives then
		for _,objective in pairs(self.factions[faction_key].long_objectives) do 
			table.insert(objectives,objective)
		end
	end

	if self.subcultures[faction_subculture_key] and (self.factions[faction_key] and self.factions[faction_key].no_subculture_objective ~= true) then
		 for _,objective in pairs(self.subcultures[faction_subculture_key].objectives) do 
			table.insert(objectives,objective)
		end
	end

	if #objectives > 0 then
		
		self:add_objectives(mm, objectives, faction_key)
	
	end
		
end

-- Unlike other victories with dynamic objective types, domination is a generic control half the map (so it should support allies/vassals)
function victory_objectives_ie:create_domination_objective(mm, faction_key)
	
	local objectives = {
		{
			type = "OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
			conditions = {
				"total 272"		
			}
		}
	}
		
	self:add_objectives(mm, objectives, faction_key)

end

-- Takes the objectives generated by the victory-specific functions, and passes them through to the mission manager
function victory_objectives_ie:add_objectives(mm, objectives, faction_key)

	for i1 = 1, #objectives do
		if objectives[i1].type ~= nil then
			mm:add_new_objective(objectives[i1].type)
			for i2 = 1, #objectives[i1].conditions do
				mm:add_condition(objectives[i1].conditions[i2])
			end
			-- Unlike all other objectives, construct buildings requires the performing faction key as well. These objectives will fail if we don't add them here
			if objectives[i1].type == "CONSTRUCT_N_BUILDINGS_FROM" or objectives[i1].type == "CONSTRUCT_N_BUILDINGS_INCLUDING" or objectives[i1].type == "CONSTRUCT_N_OF_A_BUILDING" then
				mm:add_condition("faction "..faction_key)
			end
		end
	end

end

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
			victory_objectives_ie:initialise_victory_missions(faction_key, multiplayer)
		end
	end
)

-- Trigger an incident after completing victory to let the player know they did it, and the reward for doing it
function victory_objectives_ie:trigger_victory_incident(faction, mission_key, incident_key)
	local faction_key = faction:name()
	local faction_subculture_key = faction:subculture()
	local faction_alignment = self.alignments.default
	if self.subcultures[faction_subculture_key] then
		faction_alignment = self.subcultures[faction_subculture_key].alignment
	end
	local bundle = self.alignments[faction_alignment][mission_key].payload_bundle
	
	-- override the bundle on a faction level if necessary
	if self.factions[faction_key] and self.factions[faction_key][mission_key] then
		bundle = self.factions[faction_key][mission_key].payload_bundle
	end
	
	local incident_builder = cm:create_incident_builder(incident_key)
	local payload = cm:create_new_custom_effect_bundle(bundle)
	--if the effect bundle is nil skip duration
	if bundle ~= nil then
		payload:set_duration(0)
	end
	local payload_builder = cm:create_payload()
	payload_builder:effect_bundle_to_faction(payload)
	incident_builder:set_payload(payload_builder)
	cm:launch_custom_incident_from_builder(incident_builder, faction)
end

-- Listeners for scripted faction-specific objectives
function victory_objectives_ie:add_scripted_victory_listeners()

	-- Mark faction victory as complete for the cultural victory objective and fire an incident informing the player they beat the mission
		core:add_listener(
		"IEVictoryConditionShortVictoryAttained",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_short_victory"
		end,
		function(context)
			local faction = context:faction()
			cm:complete_scripted_mission_objective(faction:name(), "wh_main_long_victory", "complete_faction_victory", true)
			self:trigger_victory_incident(faction, "wh_main_short_victory", "wh3_main_ie_victory_short")
		end,
		true
	)

	-- Let the player know they beat the long victory, since the event is suppressed
	core:add_listener(
		"IEVictoryConditionLongVictoryAttained",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_long_victory"
		end,
		function(context)
			self:trigger_victory_incident(context:faction(), "wh_main_long_victory", "wh3_main_ie_victory_long")
		end,
		true
	)

	-- Dwarf Grudges. Check for Thorgrim short victory otherwise long victory for all dwarfs 

	core:add_listener(
		"IEVictoryConditionDwarfsGrudges",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():starts_with("wh3_dlc25_grudge_legendary_")
		end,
		function(context)
			cm:increase_scripted_mission_count("wh_main_short_victory", "thorgrim_grudge_short_victory", 1)
			cm:increase_scripted_mission_count("wh_main_long_victory", "dwarf_grudge_long_victory", 1)
		end,
		true
	)

	-- Gelt College of Magic
	local gelt_faction_key = "wh2_dlc13_emp_golden_order"
	if cm:get_faction(gelt_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionShortVictoryGeltCollege",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_key():starts_with("wh3_dlc25_college_of_magic_")
			end,
			function(context)
				local ritual_key = context:ritual():ritual_key()
				if self.gelt_unique_rituals[ritual_key] == nil then
					self.gelt_unique_rituals[ritual_key] = true
					cm:increase_scripted_mission_count("wh_main_short_victory", "college_of_magic_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "college_of_magic_long", 1)
				end
			end,
			true
		)
	end

	-- Gorbad's Da Plan
	local gorbad_faction = cm:get_faction("wh3_dlc26_grn_gorbad_ironclaw")
	if gorbad_faction and gorbad_faction:is_human() then
		core:add_listener(
			"IEVictoryConditionVictoryGorbadDaPlan",
			"CharacterInitiativeActivationChangedEvent",
			function(context)
				return context:initiative():record_key():starts_with("wh3_dlc26_force_initiative_grn_da_plan_")
			end,
			function(context)
				local initative_key = context:initiative():record_key()
				if self.gorbad_unique_initiatives[initative_key] == nil then
					self.gorbad_unique_initiatives[initative_key] = true
					cm:increase_scripted_mission_count("wh_main_short_victory", "gorbad_da_plan_short", 1)
					cm:increase_scripted_mission_count("wh_main_long_victory", "gorbad_da_plan_long", 1)
				end
			end,
			true
		)
	end

	-- Greasus's feature
	local greasus_faction_key = "wh3_main_ogr_goldtooth"
	if cm:get_faction(greasus_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionVictoryGreasus",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_key():starts_with("wh3_dlc26_ogr_tyrants_demands_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "greasus_tyrants_demands_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "greasus_tyrants_demands_long", 1)
			end,
			true
		)
	end

	-- Golgfag's feature
	local golgfag_faction = cm:get_faction("wh3_dlc26_ogr_golgfag")
	if golgfag_faction and golgfag_faction:is_human() then
		core:add_listener(
			"IEVictoryConditionVictoryGolgfag",
			"WarContractSuccessEvent",
			function(context)
				return context:hired_faction():name() == "wh3_dlc26_ogr_golgfag"
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "golgfag_contracts_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "golgfag_contracts_long", 1)
			end,
			true
		)
	end

	-- Alberic's Grail Vow
	local alberic_faction_key = "wh_main_brt_bordeleaux"
	if cm:get_faction(alberic_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionAlbericGrailVowCompleted",
			"ScriptEventBretonniaGrailVowCompleted",
			function(context)
				return context:character():character_subtype("wh_dlc07_brt_alberic") 
			end,
			function()
				cm:complete_scripted_mission_objective(alberic_faction_key, "wh_main_short_victory", "alberic_grail_vow_success", true)
			end,
			true
		)
	end

	-- Fay Enchantress completes her Trothe of Virtue. 
	local fay_enchantress_faction_key = "wh_main_brt_carcassonne"
	if cm:get_faction(fay_enchantress_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionFayEnchantressTrotheCompleted",
			"ScriptEventBretonniaVirtueTrothCompleted",
			function(context)
				return context:character():character_subtype("wh_dlc07_brt_fay_enchantress")  
			end,
			function()
				cm:complete_scripted_mission_objective(fay_enchantress_faction_key, "wh_main_short_victory", "enchantress_virtue_success", true)
			end,
			true
		)
	end

	
	-- Daemon Prince ascends to any of the 5 paths
	local daemon_prince_faction_key = "wh3_main_dae_daemon_prince"
	if cm:get_faction(daemon_prince_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionDaemonPrinceAscendRitualListener",
			"RitualCompletedEvent",
			function(context)
				local ritual_key = context:ritual():ritual_key()
				return context:performing_faction():name() == daemon_prince_faction_key and (ritual_key == "wh3_main_ritual_dae_ascend_khorne" or ritual_key == "wh3_main_ritual_dae_ascend_nurgle" or ritual_key == "wh3_main_ritual_dae_ascend_slaanesh" or ritual_key == "wh3_main_ritual_dae_ascend_tzeentch" or ritual_key == "wh3_main_ritual_dae_ascend_undivided")
			end,
			function()
				cm:complete_scripted_mission_objective(daemon_prince_faction_key, "wh_main_short_victory", "daemon_prince_ascend_ritual", true)
			end,
			true
		)
	end

	-- Khatep awakens all four Legions of Legend via the Mortuary Cult.
	local khatep_faction_key = "wh2_dlc09_tmb_exiles_of_nehek"
	if cm:get_faction(khatep_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionKhatepAwakenLegionsofLegendAll",
			"RitualCompletedEvent",
			function(context)
				local ritual_key = context:ritual():ritual_key()
				return context:performing_faction():name() == khatep_faction_key and (ritual_key == "wh2_dlc09_ritual_crafting_tmb_carrion" or ritual_key == "wh2_dlc09_ritual_crafting_tmb_nehekhara_warriors" or ritual_key == "wh2_dlc09_ritual_crafting_tmb_necropolis_knights" or ritual_key == "wh2_dlc09_ritual_crafting_tmb_nehekhara_horsemen")
			end,
			function()
				-- add the saved value from awakened legions
				local awakened_ritual_count = cm:get_saved_value("khatep_short_victory_count") or 0
				awakened_ritual_count = awakened_ritual_count +1
				cm:set_saved_value("khatep_short_victory_count", awakened_ritual_count)
					if awakened_ritual_count == 4 then
						cm:complete_scripted_mission_objective(khatep_faction_key, "wh_main_short_victory", "mortuary_cult_all_victory", true)
					end
			end,
			true
		)
	end

	-- Cylostra obtains the first sea shanty
	local cylostra_faction_key = "wh2_dlc11_cst_the_drowned"
	if cm:get_faction(cylostra_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionCylostraVerseOneObtained",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == cylostra_faction_key and (context:mission():mission_record_key() == "wh2_dlc11_mission_sea_shanty_1" or context:mission():mission_record_key() == "wh2_dlc11_mission_sea_shanty_player_1") 
			end,
			function()
				cm:complete_scripted_mission_objective(cylostra_faction_key, "wh_main_short_victory", "shanty_one_obtained", true)
			end,
			true
		)
	end

	-- Skrag obtains the Cauldron of the Great Maw
	local skrag_faction_key = "wh3_main_ogr_disciples_of_the_maw"
	if cm:get_faction(skrag_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionSkragCauldronOfMaw",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == skrag_faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_ogr_skrag_cauldron_of_the_great_maw"
			end,
			function()
				cm:complete_scripted_mission_objective(skrag_faction_key, "wh_main_short_victory", "cauldron_of_maw_obtained", true)
			end,
			true
		)
	end

	-- Skulltaker's Claok of Skulls
	local skulltaker_faction = cm:get_faction("wh3_dlc26_kho_skulltaker")
	if skulltaker_faction and skulltaker_faction:is_human() then
		core:add_listener(
			"IEVictoryConditionVictorySkulltakerCloakOfSkulls",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_key():starts_with("wh3_dlc26_kho_cloak_of_skulls_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "skulltaker_cloak_of_skulls_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "skulltaker_cloak_of_skulls_long", 1)
			end,
			true
		)
	end

	-- Arbaal's Wrath of Khorne
	local arbaal_faction = cm:get_faction("wh3_dlc26_kho_arbaal")
	if arbaal_faction and arbaal_faction:is_human() then
		core:add_listener(
			"IEVictoryConditionVictoryArbaalWrathOfKhorne",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():starts_with("wh3_dlc26_arbaal_wrath_of_khorne_mission_")
			end,
			function(context)
				cm:increase_scripted_mission_count("wh_main_short_victory", "arbaal_wrath_of_khorne_short", 1)
				cm:increase_scripted_mission_count("wh_main_long_victory", "arbaal_wrath_of_khorne_long", 1)
			end,
			true
		)
	end

	-- Wurrzag obtains any of his three unique items
	local wurrzag_faction_key = "wh_main_grn_orcs_of_the_bloody_hand"
	if cm:get_faction(wurrzag_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionWuurzagBalefulSquigglyBonewood",
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				return context:faction():name() == wurrzag_faction_key and (mission_key == "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_baleful_mask" or mission_key == "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff" or mission_key == "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast")
			end,
			function()
				cm:complete_scripted_mission_objective(wurrzag_faction_key, "wh_main_short_victory", "baleful_squiggly_bonewood_obtained", true)
			end,
			true
		)
	end

	-- Rakarth obtains the Whip of Agony
	local rakarth_faction_key = "wh2_twa03_def_rakarth"
	if cm:get_faction(rakarth_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionRakarthWhipOfAgony",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == rakarth_faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_def_rakarth_whip_of_agony"
			end,
			function()
				cm:complete_scripted_mission_objective(rakarth_faction_key, "wh_main_short_victory", "whip_of_agony_obtained", true)
			end,
			true
		)
	end

	-- Skarbrand obtains the Slaughter and Carnage
	local skarbrand_faction_key = "wh3_main_kho_exiles_of_khorne"
	if cm:get_faction(skarbrand_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionSkarbrandObtainsCarnage",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == skarbrand_faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_kho_skarbrand_slaughter_and_carnage"
			end,
			function()
				cm:complete_scripted_mission_objective(skarbrand_faction_key, "wh_main_short_victory", "slaughter_carnage_obtained", true)
			end,
			true
		)
	end

	-- Sigvald obtains the Sliverslash
	local sigvald_faction_key = "wh3_dlc20_chs_sigvald"
	if cm:get_faction(sigvald_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionSkarbrandObtainsCarnage",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == sigvald_faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_chs_prince_sigvald_sliverslash"
			end,
			function()
				cm:complete_scripted_mission_objective(sigvald_faction_key, "wh_main_short_victory", "sliverslash_obtained", true)
			end,
			true
		)
	end

	-- Ikit Claw has levelled up the Forbidden Workshop to rank three
	local ikit_claw_faction_key = "wh2_main_skv_clan_skryre"
	if cm:get_faction(ikit_claw_faction_key):is_human() then
		core:add_listener(
			"Ikit_Claw_Incident_Workshop_3",
			"IncidentOccuredEvent",
			function(context)
				return context:faction():name() == ikit_claw_faction_key and context:dilemma() == "wh2_dlc12_incident_skv_workshop_upgrade_3"
			end,
			function()
				cm:complete_scripted_mission_objective(ikit_claw_faction_key, "wh_main_short_victory", "workshop_rank_3_victory", true)
			end,
		true
		)
	end

	-- Imrik encounters special Dragons
	local imrik_faction_key = "wh2_dlc15_hef_imrik"
	if cm:get_faction(imrik_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionImrikDragonEncounterDilemmaIssued",
			"DilemmaIssuedEvent",
			function(context)
				return context:faction():name() == imrik_faction_key and context:dilemma():starts_with("wh2_dlc15_dilemma_dragon_encounter_special_")
			end,
			function()
				-- Count Imrik's dragon dilemma encounters
				local dragon_encounter_count = cm:get_saved_value("imrik_short_victory_count") or 0
				dragon_encounter_count = dragon_encounter_count +1
				cm:set_saved_value("imrik_short_victory_count", dragon_encounter_count)
				if dragon_encounter_count == 5 then
					cm:complete_scripted_mission_objective(imrik_faction_key, "wh_main_long_victory", "dragon_encounters_all", true)
				elseif dragon_encounter_count == 2 then
					cm:complete_scripted_mission_objective(imrik_faction_key, "wh_main_short_victory", "dragon_encounters", true)
				end
			end,
		true
	)
	end

	-- Tehenhauin completes the first stage of the Prophecy of Sotek and any second stage missions are issued
	local tehenhauin_faction_key = "wh2_dlc12_lzd_cult_of_sotek"
	if cm:get_faction(tehenhauin_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionTehenhauinProphecyCompleted",
			"MissionIssued",
			function(context)
				return context:faction():name() == tehenhauin_faction_key and context:mission():mission_record_key():starts_with("wh2_dlc12_prophecy_of_sotek_2_")
			end,
			function()
				cm:complete_scripted_mission_objective(tehenhauin_faction_key, "wh_main_short_victory", "prophecy_of_sotek_one", true)
			end,
			true
		)
	end

	-- Malus obtains the Warpsword of Khaine
	local malus_faction_key = "wh2_main_def_hag_graef"
	if cm:get_faction(malus_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionMalusWarpswordOfKhaine",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == malus_faction_key and context:mission():mission_record_key() == "wh3_main_ie_qb_def_malus_warpsword_of_khaine"
			end,
			function()
				cm:complete_scripted_mission_objective(malus_faction_key, "wh_main_short_victory", "warpsword_of_khaine_obtained", true)
			end,
			true
		)
	end

	-- Snikch performs any 8 Clan Eshin Actions
	local snikch_faction_key = "wh2_main_skv_clan_eshin"
	if cm:get_faction(snikch_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionSnikchEshinActionsr",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == snikch_faction_key and context:ritual():ritual_key():starts_with("wh2_dlc14_eshin_actions_")
			end,
			function()
				-- Count the Eshin Actions performed by Snikch
				local performed_clan_ritual_count = cm:get_saved_value("snikch_short_victory_count") or 0
				performed_clan_ritual_count = performed_clan_ritual_count +1
				cm:set_saved_value("snikch_short_victory_count", performed_clan_ritual_count)
				if performed_clan_ritual_count >= 8 then
					cm:complete_scripted_mission_objective(snikch_faction_key, "wh_main_short_victory", "snikch_eshin_actions_complete", true)
				end
			end,
			true
		)
	end

	-- Eltharion upgrades Athel Tamarha
	local eltharion_faction_key = "wh2_main_hef_yvresse"
	if cm:get_faction(eltharion_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionEltharionTamarhaUpgrade",
			"RitualCompletedEvent",
			function(context)
				return context:ritual():ritual_category() == "ATHEL_TAMARHA_RITUAL" 
			end,
			function()
				-- Count the upgrade number within the facility for short and long victories. Note: Player facing condition is 5 for short and 15 for long, but +8 is added to each counter to accomadate for eight the rank 1 'ruined' rituals that are completed on campaign start
				local athel_tamarha_upgrade_count = cm:get_saved_value("eltharion_upgrade_short_victory_count") or 0
				athel_tamarha_upgrade_count = athel_tamarha_upgrade_count +1
				cm:set_saved_value("eltharion_upgrade_short_victory_count", athel_tamarha_upgrade_count)
				if  athel_tamarha_upgrade_count >= 23 then
					cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_long_victory", "athel_tamarha_max_upgrades_attained", true)
				elseif athel_tamarha_upgrade_count == 13 then
					cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_short_victory", "athel_tamarha_upgrades_attained", true)
				end
			end,
			true
		)
	end

	--Trigger dilemma for Nakai if he completes his short objective and Skrolk is still alive 
	local nakai_faction_key = "wh2_dlc13_lzd_spirits_of_the_jungle"
	local pestilens_faction_key = "wh2_main_skv_clan_pestilens"
	if cm:get_faction("wh2_dlc13_lzd_spirits_of_the_jungle"):is_human() then
		core:add_listener(
			"IEVictoryConditionNakaiShortVictoryDilemma",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == nakai_faction_key and (context:mission():mission_record_key() == "wh_main_short_victory")
			end,
			function()
				if cm:get_faction(pestilens_faction_key):is_dead() == false then
					cm:trigger_dilemma(nakai_faction_key, "wh3_dlc21_lzd_lingering_pestilence_dilemma_nakai")
				end
			end,
			true
		)
	end

	-- Mannfred performs 7 Bloodline Awakenings.
	local mannfred_faction_key = "wh_main_vmp_vampire_counts"
	if cm:get_faction(mannfred_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionBloodlineAwakenings",
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == mannfred_faction_key and (context:ritual():ritual_category() == "BLOODLINE_RITUAL" )
			end,
			function()
				-- add the saved value from awakened bloodlines
				local awakened_ritual_count = cm:get_saved_value("mannfred_victory_count") or 0
				awakened_ritual_count = awakened_ritual_count +1
				cm:set_saved_value("mannfred_victory_count", awakened_ritual_count)
					if awakened_ritual_count == 7 then
						cm:complete_scripted_mission_objective(mannfred_faction_key, "wh_main_long_victory", "bloodline_awaken_threshold_victory", true)
					end
			end,
			true
		)
	end

	-- Nakai chooses the dilemma option to spawn an army
	if cm:get_faction(nakai_faction_key):is_human() then
		core:add_listener(
			"IEVictoryConditionNakaiDilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == "wh3_dlc21_lzd_lingering_pestilence_dilemma_nakai" 
			end,
			function(context)
				local choice = context:choice()
				if choice == 0 then
					local units = "wh2_main_lzd_inf_saurus_spearmen_1,wh2_main_lzd_inf_saurus_spearmen_1,wh2_main_lzd_mon_kroxigors,wh2_main_lzd_mon_kroxigors,wh2_main_lzd_inf_saurus_warriors_1,wh2_main_lzd_inf_saurus_warriors_0,wh2_main_lzd_inf_saurus_warriors_0,wh2_main_lzd_inf_skink_cohort_1,wh2_main_lzd_inf_skink_cohort_1,wh2_main_lzd_mon_stegadon_1,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_bastiladon_2"
					local agents = {
						wh2_main_lzd_saurus_scar_veteran = "champion",
						wh2_main_lzd_skink_chief = "spy",
						wh2_main_lzd_skink_priest_heavens = "wizard",
					}
					if cm:get_faction(nakai_faction_key):at_war_with(cm:get_faction(pestilens_faction_key)) == false then
						cm:force_declare_war(nakai_faction_key, pestilens_faction_key, false, false)
					end
					local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(nakai_faction_key, "wh3_main_combi_region_itza", false, true, 10)
					cm:create_force(
						nakai_faction_key,
						units,
						"wh3_main_combi_region_itza",
						pos_x,
						pos_y,
						false,
						function(cqi)
							local force = cm:get_character_by_cqi(cqi):military_force()
							for subtype, type in pairs(agents) do
								local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_settlement(nakai_faction_key, "wh3_main_combi_region_itza", false, true, 10)
								local agent = cm:create_agent(nakai_faction_key, type, subtype, agent_x, agent_y)
								cm:add_agent_experience(cm:char_lookup_str(agent:command_queue_index()), cm:random_number(16, 10), true)
								cm:embed_agent_in_force(agent, force)
							end
							local character = cm:char_lookup_str(cqi)
							cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 8)
							cm:add_experience_to_units_commanded_by_character(character, 7)
							cm:add_growth_points_to_horde(force, 8)
							cm:add_building_to_force(force:command_queue_index(), 
								{"wh2_dlc13_horde_lizardmen_ziggurat_minor_1",
								"wh2_dlc13_horde_lizardmen_support_upkeep_1",
								"wh2_dlc13_horde_lizardmen_portal_quetzl_1" 
								}
							)
						end
					)
				end
			end,
			true
		)
	end

end

--------------------- SAVE/LOAD ---------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("victory_objectives_ie.gelt_unique_rituals", victory_objectives_ie.gelt_unique_rituals, context)
		cm:save_named_value("victory_objectives_ie.gorbad_unique_initiatives", victory_objectives_ie.gorbad_unique_initiatives, context, true)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			victory_objectives_ie.gelt_unique_rituals = cm:load_named_value("victory_objectives_ie.gelt_unique_rituals", victory_objectives_ie.gelt_unique_rituals, context)
			victory_objectives_ie.gorbad_unique_initiatives = cm:load_named_value("victory_objectives_ie.gorbad_unique_initiatives", victory_objectives_ie.gorbad_unique_initiatives, context, true)
		end
	end
)