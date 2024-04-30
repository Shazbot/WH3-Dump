-- LEGENDARY CHARACTERS UNLOCKING

------------------
--- HOW TO USE ---
------------------

-- To use the character unlocking function there are a few steps you need to take
-- Add the character name of the character you want to add into character_unlocking.character_list
-- 		EXAMPLE: character_unlocking.character_list = {"kroak", "ulrika", ...}
-- Next add a new section for the character in character_unlocking.character_data with the same name you added in the character_list
-- 		EXAMPLE: character_unlocking.character_data = {ulrika = {} }
-- Next determine the unlock conditions for the player and AI. This determines how the initial chain of events to unlock the character starts
-- 		In the example the player gets a mission once their LL reaches a specified rank, while the AI would get them once a specified turn is reached
-- 		EXAMPLE: ulrika = {
--					condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
--					ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
-- 					unlock_rank = 15,
--					ai_unlock_turn = 30,
--				}
-- Next add in required data points. See example.
-- 		EXAMPLE: ulrika = {
--					has_spawned = false,
-- 					factions_involved = {},
-- 				}
-- Next add character name and subtype information
-- 		EXAMPLE: ulrika = {
--					name = "ulrika", 						-> Needs to match the character name
--					subtype = "wh3_twa09_neu_ulrika", 		-> This is the Agent subtype from the agent_subtypes table
-- 				}
-- Next specify the allowed cultures that can potentially get the character.
-- 		EXAMPLE: ulrika = {
--					allowed_cultures = { "wh3_main_ksl_kislev" }
-- Next specify if you want the non-playable factions of that culture to also be able to get the character
-- 		NOTE! this is an optional variable and you don't have to include it
-- 		EXAMPLE: kroak = {
-- 					non_playable_factions_allowed = true,
-- 				}
-- Optionally you can instead specify override_allowed_factions which will limit the character's to certain factions
-- 		EXAMPLE: ghoritch = {
--					override_allowed_factions = {
--						"wh2_main_skv_clan_moulder",
--					},
-- 				}
-- Next add the keys required for your unlock condition
-- 		unlock type to key type:
--			mission_keys for rank, quest
-- 			ritual_keys for ritual
--		EXAMPLE: ulrika = {
--			mission_keys = "mission key"
-- 		OR
-- 			mission_keys = { "mission_key", ...}
--		OR
--			mission_keys = {
--					allowed_faction_1 = "mission key 1",
--					allowed_faction_2 = "mission key 2",
--					allowed_faction_3 = "mission key 1",
--					...} -> use if you have more than 1 allowed faction
-- Optional - add all the ancillaries that you want the character to start out having
-- 		EXAMPLE: ulrica = {
-- 					"wh3_twa09_anc_arcane_item_blood_shard",
-- 					"wh3_twa09_anc_weapon_item_silver_dagger",
-- 					"wh3_twa09_anc_follower_ksl_gabriella"
-- 				}
-- Optional - add the starting_owner_faction. Which will have the character spawn from the start of the game if you start playing as the listed faction
-- 		EXAMPLE: kroak = {.. starting_owner_faction = "wh2_main_lzd_itza", ..}
-- Optional - If the character requires a DLC, you can add a table containing the required DLCs as strings. As long as the player owns at least one of the specified DLC, the check is passed.
-- This prevents missions from firing if the player wouldn't be able to receive the characters when it completes.
-- EXAMPLE: Gotrek and Felix
--			require_dlc = {
--				"TW_WH3_THRONES_OF_DECAY_DWF",
--			"TW_WH2_GOTREK_FELIX",
--			},

---------------------------------
------ Character Data Setup -----
---------------------------------

character_unlocking = {}

character_unlocking.character_unlock_condition_types = {
	rank = "rank", -- Unlocked when character reaches rank
	quest = "quest", -- Unlocked when character starts specified quest
	ritual = "ritual", -- Unlocked when ritual is completed
	turn = "turn", -- Unlocked when specific world turn is reached
	building = "building" -- Unlocked when you build a specified building
}

character_unlocking.character_alternate_grant_condition_types = {
	-- Alternate payload options that handle granting the character
	dilemma_payload = "dilemma" -- Grant Character via payload
}

character_unlocking.character_list = {
	-- REQUIRED. List of all the characters to be used. Must match character names in character_data
	"kroak",
	"ghoritch",
	"ariel",
	"coeddil",
	"gorduz",
	"ulrika",		
	"harald",
	"scribes",
	"aekold",
	"saytang",
	"leysa",
	"gotrek_and_felix",
	"garagrim",
	"theodore"
}
character_unlocking.character_data = {
	kroak = {
		-- Lizardmen Players will get a mission to unlock lord kroak after reaching rank 15
		-- Human Itza unlocks kroak for free at the start (this stops anyone else getting him/the mission)
		-- If there's no lizard players the strongest AI lizard gets kroak after turn 30

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 15,
		ai_unlock_turn = 30, -- If there are no player lizardmen, assign kroak to the strongest current lizard faction
		has_spawned = false,
		name = "lord_kroak",
		subtype = "wh2_dlc12_lzd_lord_kroak",
		starting_owner_faction = "wh2_main_lzd_itza", -- Including this will spawn the hero for the faction when starting as them
		allowed_cultures = {
			"wh2_main_lzd_lizardmen"
		},
		non_playable_factions_allowed = false,
		factions_involved = {},
		mission_keys = {
			["wh2_main_lzd_hexoatl"] = "wh3_main_ie_mazdamundi_lord_kroak",
			["wh2_main_lzd_last_defenders"] = "wh3_main_ie_kroqgar_lord_kroak",
			["wh2_dlc12_lzd_cult_of_sotek"] = "wh3_main_ie_tehenhauin_lord_kroak",
			["wh2_main_lzd_tlaqua"] = "wh3_main_ie_tiktaqto_lord_kroak",
			["wh2_dlc13_lzd_spirits_of_the_jungle"] = "wh3_main_ie_nakai_lord_kroak",
			["wh2_dlc17_lzd_oxyotl"] = "wh3_main_ie_qb_oxyotl_lord_kroak"
		},
		ancillaries = {
			"wh2_dlc12_anc_arcane_item_standard_of_the_sacred_serpent",
			"wh2_dlc12_anc_armour_glyph_of_potec",
			"wh2_dlc12_anc_enchanted_item_golden_death_mask",
			"wh2_dlc12_anc_talisman_amulet_of_itza",
			"wh2_dlc12_anc_weapon_ceremonial_mace_of_malachite"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_main_ie_mazdamundi_lord_kroak",
				"wh3_main_ie_kroqgar_lord_kroak",
				"wh3_main_ie_tehenhauin_lord_kroak",
				"wh3_main_ie_tiktaqto_lord_kroak",
				"wh3_main_ie_nakai_lord_kroak",
				"wh3_main_ie_qb_oxyotl_lord_kroak",
			}
		}
	},
	ghoritch = {
		-- Clan Molder players will get Ghoritch awarded after completing Thrott's Quest -> Whip of Domination
		-- If AI is playing Clan Molder they will get Ghoritch after Thrott reaches rank 5

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.quest,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_unlock_rank = 5, -- If there are no player clan molder, assign ghoritch to the them
		has_spawned = false,
		name = "ghoritch",
		subtype = "wh2_dlc16_skv_ghoritch",
		override_allowed_factions = {
			"wh2_main_skv_clan_moulder"
		},
		factions_involved = {},
		mission_keys = {
			"wh3_main_ie_qb_skv_throt_main_whip_of_domination"
		},
		mission_incidents = {
			["wh2_main_skv_clan_moulder"] = "wh2_dlc16_incident_skv_ghoritch_arrives"
		}
	},
	ariel = {
		-- Wood Elf players playing either the Sisters, Orion or Durthu will unlock Ariel after completing the first forest ritual for any Forest
		-- If there's no Wood Elf players of the 3 factions then the strongest Wood Elf of the 3 will get Ariel after 20 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.ritual,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		ai_unlock_turn = 20,
		has_spawned = false,
		name = "ariel",
		subtype = "wh2_dlc16_wef_ariel",
		require_dlc = {"TW_WH2_DLC16_TWILIGHT"},
		override_allowed_factions = {
			"wh2_dlc16_wef_sisters_of_twilight",
			"wh_dlc05_wef_wood_elves",
			"wh_dlc05_wef_argwylon"
		},
		factions_involved = {},
		ritual_keys = {
			"wh2_dlc16_ritual_rebirth_athel_loren",
			"wh2_dlc16_ritual_rebirth_laurelorn",
			"wh2_dlc16_ritual_rebirth_gaean_vale",
			"wh2_dlc16_ritual_rebirth_heart_of_the_jungle",
			"wh2_dlc16_ritual_rebirth_gryphon_wood",
			"wh2_dlc16_ritual_rebirth_vale_of_webs",
			"wh2_dlc16_ritual_rebirth_naggarond_glade",
			"wh2_dlc16_ritual_rebirth_emerald_pools",
			"wh2_dlc16_ritual_rebirth_jungles_of_chian",
			"wh2_dlc16_ritual_rebirth_the_haunted_forest"
		},
		ancillaries = {
			"wh2_dlc16_anc_arcane_item_wand_of_wych_elm",
			"wh2_dlc16_anc_enchanted_item_acorns_of_the_oak_of_ages",
			"wh2_dlc16_anc_talisman_berry_wine",
			"wh2_dlc16_anc_weapon_dart_of_doom",
			"wh2_dlc16_anc_armour_heartstone_of_athel_loren"
		},
		mission_incidents = {
			["wh2_dlc16_wef_sisters_of_twilight"] = "wh2_dlc16_incident_wef_ariel_arrives",
			["wh_dlc05_wef_wood_elves"] = "wh2_dlc16_incident_wef_ariel_arrives",
			["wh_dlc05_wef_argwylon"] = "wh2_dlc16_incident_wef_ariel_arrives"
		}
	},
	coeddil = {
		-- Drycha players will get Coeddil after completing Drycha's Quest -> Coeddil Unchained stage 4
		-- If Drycha is AI controlled they will get Coeddil after 20 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.quest,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		ai_unlock_turn = 20,
		has_spawned = false,
		name = "coeddil",
		subtype = "wh2_dlc16_wef_coeddil",
		override_allowed_factions = {
			"wh2_dlc16_wef_drycha"
		},
		factions_involved = {},
		mission_keys = {
			"wh2_dlc16_wef_drycha_coeddil_unchained_stage_4"
		}
	},
	gorduz = {
		-- Chaos Dwarf players will get a mission to unlock Gorduz once their faction leader reaches rank 5
		-- If there are no human Chaos Dwarf players the strongest Chaos Dwarf faction will get Gorduz after 30 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.building,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 10,
		ai_unlock_turn = 30,
		has_spawned = false,
		name = "gorduz",
		subtype = "wh3_dlc23_chd_gorduz_backstabber",
		allowed_cultures = {
			"wh3_dlc23_chd_chaos_dwarfs"
		},
		factions_involved = {},
		mission_keys = "wh3_dlc23_mis_chd_gorduz_unlock",
		ancillaries = {
			"wh3_dlc23_anc_enchanted_item_chd_banner_of_slavery",
			"wh3_dlc23_anc_weapon_chd_dagger_of_malice"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc23_mis_chd_gorduz_unlock"
			},
			wh3_main_chaos = {
				"wh3_dlc23_mis_chd_gorduz_unlock"
			}
		},
		required_buildings = {
			"wh3_dlc23_chd_military_hobgoblins_1",
			"wh3_dlc23_chd_military_hobgoblins_2",
		}
	},
	ulrika = {
		-- Kislev players will get a quest chain mission to unlock Ulrika once their faction leader reaches rank 10
		-- Additionally at the end of the mission chain players will get a dilemma with options to either recruit Ulrika or let the AI recruit her
		-- If there are no human kislev players the strongest AI kislev faction will unlock Ulrika once their faction leader reaches rank 15

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		alternate_grant_condition = character_unlocking.character_alternate_grant_condition_types.dilemma_payload,
		unlock_rank = 11,
		ai_unlock_rank = 15,
		has_spawned = false,
		name = "ulrika",
		subtype = "wh3_dlc23_neu_ulrika",
		require_dlc = {"TW_WH3_ULRIKA_FREE"},
		allowed_cultures = {
			"wh3_main_ksl_kislev",
			"wh_main_emp_empire"
		},
		override_allowed_factions = {
			"wh3_dlc25_dwf_malakai"
		},
		factions_involved = {},
		mission_keys = {
			wh3_main_ksl_kislev = {
				["main_warhammer"] = "wh3_dlc23_ie_ksl_ulrika_stage_1",
				["wh3_main_chaos"] = "wh3_dlc23_chaos_ksl_ulrika_stage_1"
			},
			wh_main_emp_empire = {
				["main_warhammer"] = "wh3_dlc23_ie_emp_ulrika_stage_1",
				["wh3_main_chaos"] = "wh3_dlc23_chaos_emp_ulrika_stage_1"				
			},
			wh3_dlc25_dwf_malakai = {
				["main_warhammer"] = "wh3_dlc25_ie_dwf_ulrika_stage_1",
				["wh3_main_chaos"] = "wh3_dlc25_chaos_dwf_ulrika_stage_1"				
			},
		},
		dilemma_keys = {
			"wh3_dlc23_neu_ulrika_choice"
		},
		spawn_hero_dilemma_choice = {0},
		ai_spawn_hero_dilemma_choice = 1,
		ancillaries = {
			"wh3_dlc23_anc_arcane_item_blood_shard",
			"wh3_dlc23_anc_weapon_item_silver_dagger",
			"wh3_dlc23_anc_follower_neu_gabriella"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc23_ie_ksl_ulrika_stage_1",
				"wh3_dlc23_ie_ksl_ulrika_stage_2",
				"wh3_dlc23_ie_emp_ulrika_stage_1",
				"wh3_dlc23_ie_emp_ulrika_stage_2",
				"wh3_dlc25_ie_dwf_ulrika_stage_1",
				"wh3_dlc25_ie_dwf_ulrika_stage_2",
			},
			wh3_main_chaos = {
				"wh3_dlc23_chaos_ksl_ulrika_stage_1",
				"wh3_dlc23_chaos_ksl_ulrika_stage_2",
				"wh3_dlc23_chaos_emp_ulrika_stage_1",
				"wh3_dlc23_chaos_emp_ulrika_stage_2",
				"wh3_dlc25_chaos_dwf_ulrika_stage_1",
				"wh3_dlc25_chaos_dwf_ulrika_stage_2",
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc23_ie_ksl_ulrika_stage_2",
				"wh3_dlc23_ie_emp_ulrika_stage_2",
				"wh3_dlc25_ie_dwf_ulrika_stage_2",
			},
			wh3_main_chaos = {
				"wh3_dlc23_chaos_ksl_ulrika_stage_2",
				"wh3_dlc23_chaos_emp_ulrika_stage_2",
				"wh3_dlc25_chaos_dwf_ulrika_stage_2",
			}
		},
		trigger_dilemma_key = "wh3_dlc23_neu_ulrika_choice",
		alt_reward_dilemma_triggered = false
	},
	harald = {
		-- Warriors of Chaos players will get the chance to unlock Harald Hammerstone once their faction leader reaches rank 15
		-- If there are no human Warriors of Chaos players the strongest AI WoC faction will get Harald after 25 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 15,
		ai_unlock_turn = 25,
		has_spawned = false,
		name = "harald",
		subtype = "wh3_pro11_chs_cha_harald_hammerstorm",
		require_dlc = {"TW_WH3_PRO11_HARALD_HAMMERSTORM"},
		allowed_cultures = {
			"wh_main_chs_chaos"
		},
		factions_involved = {},
		mission_keys = "wh3_pro11_mis_chs_harald_hammerstorm_unlock",
		ancillaries = {
			"wh3_pro11_anc_enchanted_item_bane_shield",
			"wh3_pro11_anc_weapon_hammer_of_harry"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_pro11_mis_chs_harald_hammerstorm_unlock"
			},
			wh3_main_chaos = {
				"wh3_pro11_mis_chs_harald_hammerstorm_unlock"
			}
		},
	},
	scribes = {
		-- Tzeentch players will get a mission to unlock the Blue Scribes once their faction leader reaches rank 8
		-- Additionally at the end of the mission chain players will get a dilemma with options to either recruit the Blue Scribes or let the AI recruit them
		-- If there are no human Tzeentch players the strongest Tzeentch faction will get the Blue Scribes after 30 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		alternate_grant_condition = character_unlocking.character_alternate_grant_condition_types.dilemma_payload,
		unlock_rank = 10,
		ai_unlock_turn = 30,
		has_spawned = false,
		name = "scribes",
		subtype = "wh3_dlc24_tze_blue_scribes",
		require_dlc = {"TW_WH3_SHADOWS_OF_CHANGE"},
		override_allowed_factions = {
			main_warhammer = {
				"wh3_main_tze_oracles_of_tzeentch",
				"wh3_dlc24_tze_the_deceivers",
				"wh3_dlc20_chs_vilitch",
				"wh3_main_dae_daemon_prince",
				"wh3_dlc20_chs_kholek",
				"wh3_dlc20_chs_sigvald",
				"wh_main_chs_chaos",
				"wh3_main_chs_shadow_legion"
			},
			wh3_main_chaos = {
				"wh3_main_tze_oracles_of_tzeentch",
				"wh3_dlc24_tze_the_deceivers",
				"wh3_dlc20_chs_vilitch",
				"wh3_main_dae_daemon_prince"
			}
		},
		factions_involved = {},
		mission_keys = {
			["wh3_main_tze_oracles_of_tzeentch"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1",
			["wh3_dlc20_chs_kholek"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
			["wh3_dlc20_chs_sigvald"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
			["wh3_dlc20_chs_vilitch"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
			["wh_main_chs_chaos"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
			["wh3_main_chs_shadow_legion"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
			["wh3_main_dae_daemon_prince"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_dae",
			["wh3_dlc24_tze_the_deceivers"] = "wh3_dlc24_mis_tze_blue_scribes_stage_1_changeling"
		},
		dilemma_keys = {
			"wh3_dlc24_tze_blue_scribes_choice"
		},
		spawn_hero_dilemma_choice = {0,1},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc24_mis_tze_blue_scribes_stage_1",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_b",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_b_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_b_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_changeling",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_changeling",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_b_changeling",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_changeling"
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_tze_blue_scribes_stage_1",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_1_changeling",
				"wh3_dlc24_mis_tze_blue_scribes_stage_2_changeling",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_changeling"
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc24_mis_tze_blue_scribes_stage_3",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_changeling"
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_tze_blue_scribes_stage_3",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_chs",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_dae",
				"wh3_dlc24_mis_tze_blue_scribes_stage_3_changeling"
			}
		},
		trigger_dilemma_key = "wh3_dlc24_tze_blue_scribes_choice",
		alt_reward_dilemma_triggered = false
	},
	aekold = {
		-- Tzeentch players will get a mission to unlock Aekold Helbrass once their faction leader reaches rank 12
		-- Additionally at the end of the mission chain players will get a dilemma with options to either recruit Aekold or let the AI recruit him
		-- If there are no human Tzeentch players the strongest Tzeentch faction will get Aekold Helbrass after 30 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		alternate_grant_condition = character_unlocking.character_alternate_grant_condition_types.dilemma_payload,
		unlock_rank = 12,
		ai_unlock_turn = 30,
		has_spawned = false,
		name = "aekold",
		subtype = "wh3_dlc24_tze_aekold_helbrass",
		require_dlc = {"TW_WH3_AEKOLD_FREE"},
		override_allowed_factions = {
			main_warhammer = {
				"wh3_main_tze_oracles_of_tzeentch",
				"wh3_dlc24_tze_the_deceivers",
				"wh3_dlc20_chs_vilitch",
				"wh3_main_dae_daemon_prince",
				"wh3_dlc20_chs_kholek",
				"wh3_dlc20_chs_sigvald",
				"wh_main_chs_chaos",
				"wh3_main_chs_shadow_legion"
			},
			wh3_main_chaos = {
				"wh3_main_tze_oracles_of_tzeentch",
				"wh3_dlc24_tze_the_deceivers",
				"wh3_dlc20_chs_vilitch",
				"wh3_main_dae_daemon_prince"
			}
		},
		factions_involved = {},
		mission_keys = {
			wh3_main_tze_oracles_of_tzeentch = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1",
				["wh3_main_chaos"] = "wh3_dlc24_mis_tze_aekold_helbrass_stage_1"
			},
			wh3_dlc20_chs_vilitch = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
				["wh3_main_chaos"] = "wh3_dlc24_mis_tze_aekold_helbrass_stage_1_chs"
			},
			wh3_main_dae_daemon_prince = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_dae",
				["wh3_main_chaos"] = "wh3_dlc24_mis_tze_aekold_helbrass_stage_1_dae"
			},
			wh3_dlc24_tze_the_deceivers = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_changeling",
				["wh3_main_chaos"] = "wh3_dlc24_mis_tze_aekold_helbrass_stage_1_changeling"
			},
			wh3_dlc20_chs_kholek = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
			},
			wh3_dlc20_chs_sigvald = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
			},
			wh_main_chs_chaos = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
			},
			wh3_main_chs_shadow_legion = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
			},
		},
		dilemma_keys = {
			"wh3_dlc24_tze_aekold_helbras_choice"
		},
		spawn_hero_dilemma_choice = {0,1},
		ancillaries = {
			"wh3_dlc24_anc_weapon_the_windblade",
			"wh3_dlc24_anc_enchanted_item_the_breath_of_life"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_changeling",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_dae",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_2_changeling",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_2_chs",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_2_dae",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_2",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_changeling",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_chs",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_dae",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_1_changeling",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_1_chs",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_1_dae",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_1",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_2_changeling",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_2_chs",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_2_dae",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_2",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_changeling",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_chs",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_dae",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3"
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_changeling",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_chs",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3_dae",
				"wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_3",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_changeling",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_chs",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3_dae",
				"wh3_dlc24_mis_tze_aekold_helbrass_stage_3"
			}
		},
		trigger_dilemma_key = "wh3_dlc24_tze_aekold_helbras_choice",
		alt_reward_dilemma_triggered = false
	},
	saytang = {
		-- Cathayan players will get a mission to unlock Saytang once their faction leader reaches rank 13.
		-- If there are no human Cathayan players the strongest Cathay faction will get Saytang after 30 turns
		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		alternate_grant_condition = character_unlocking.character_alternate_grant_condition_types.dilemma_payload,
		unlock_rank = 13,
		ai_unlock_turn = 30,
		has_spawned = false,
		name = "saytang",
		subtype = "wh3_dlc24_cth_saytang_the_watcher",
		require_dlc = {"TW_WH3_SHADOWS_OF_CHANGE"},
		allowed_cultures = {
			"wh3_main_cth_cathay"
		},
		factions_involved = {},
		mission_keys = {
			wh3_dlc24_cth_the_celestial_court = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_cth_saytang_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_cth_saytang_unlock_01"
			},
			wh3_main_cth_the_northern_provinces = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_cth_saytang_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_cth_saytang_unlock_01"
			},
			wh3_main_cth_the_western_provinces = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_cth_saytang_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_cth_saytang_unlock_01"
			},
		},
		dilemma_keys = {
			"wh3_dlc24_cth_saytang_choice"
		},
		spawn_hero_dilemma_choice = {0,1},
		ancillaries = {
			"wh3_dlc24_anc_weapon_wind_bow"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_cth_saytang_unlock_01",
				"wh3_dlc24_mis_ie_cth_saytang_unlock_02",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_cth_saytang_unlock_01",
				"wh3_dlc24_mis_cth_saytang_unlock_02",
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_cth_saytang_unlock_02",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_cth_saytang_unlock_02",
			}
		},
		trigger_dilemma_key = "wh3_dlc24_cth_saytang_choice",
		alt_reward_dilemma_triggered = false
	},
	leysa = {
		-- Kislevite players will get a mission to unlock the Golden Knight, Leysa once their faction leader reaches rank 11
		-- If there are no human Kislevite players the strongest Kislev faction will get the Golden Knight after 30 turns

		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		alternate_grant_condition = character_unlocking.character_alternate_grant_condition_types.dilemma_payload,
		unlock_rank = 11,
		ai_unlock_turn = 30,
		has_spawned = false,
		name = "leysa",
		subtype = "wh3_dlc24_ksl_the_golden_knight",
		require_dlc = {"TW_WH3_SHADOWS_OF_CHANGE"},
		allowed_cultures = {
			"wh3_main_ksl_kislev"
		},
		factions_involved = {},
		mission_keys = {
			wh3_main_ksl_the_ice_court = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_ksl_golden_knight_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_ksl_golden_knight_unlock_01"
			},
			wh3_main_ksl_the_great_orthodoxy = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_ksl_golden_knight_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_ksl_golden_knight_unlock_01"
			},
			wh3_main_ksl_ursun_revivalists = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_ksl_golden_knight_unlock_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_ksl_golden_knight_unlock_01"
			},
			wh3_dlc24_ksl_daughters_of_the_forest = {
				["main_warhammer"] = "wh3_dlc24_mis_ie_ksl_golden_knight_unlock_ostankya_01",
				["wh3_main_chaos"] = "wh3_dlc24_mis_ksl_golden_knight_unlock_ostankya_01"
			},
		},
		dilemma_keys = {
			"wh3_dlc24_ksl_golden_knight_choice"
		},
		spawn_hero_dilemma_choice = {0,1},
		ancillaries = {
			"wh3_dlc24_anc_weapon_ursuns_claw",
			"wh3_dlc24_anc_enchanted_item_totem_of_ursus",
			"wh3_dlc24_anc_talisman_blessing_wafers"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_01",
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_02",
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_ostankya_01",
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_ostankya_02",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_ksl_golden_knight_unlock_01",
				"wh3_dlc24_mis_ksl_golden_knight_unlock_02",
				"wh3_dlc24_mis_ksl_golden_knight_unlock_ostankya_01",
				"wh3_dlc24_mis_ksl_golden_knight_unlock_ostankya_02",
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_02",
				"wh3_dlc24_mis_ie_ksl_golden_knight_unlock_ostankya_02",
			},
			wh3_main_chaos = {
				"wh3_dlc24_mis_ksl_golden_knight_unlock_02",
				"wh3_dlc24_mis_ksl_golden_knight_unlock_ostankya_02",
			}
		},
		trigger_dilemma_key = "wh3_dlc24_ksl_golden_knight_choice",
		alt_reward_dilemma_triggered = false
	},
	gotrek_and_felix = {
		-- Empire, Bretonnia, Dwarfs, Kislev and Cathay Players will get a mission to unlock Gotrek and Felix after reaching rank 15
		-- Malakai unlocks gotrek and felix for free at the start (this stops anyone else getting him/the mission)
		-- If there's no Empire, Bretonnia, Dwarfs, Kislev and Cathay players the strongest AI gets Gotrek and Felix after turn 30
		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 15,
		ai_unlock_turn = 30, -- If there are no player factions, assign Gotrek and Felix to the strongest current valid faction
		has_spawned = false,
		name = "gotrek_and_felix",
		subtype = "wh3_dlc25_neu_gotrek_hero",
		require_dlc = {
			"TW_WH3_THRONES_OF_DECAY_DWF",
			"TW_WH2_GOTREK_FELIX",
		},
		additional_subtype = "wh2_pro08_neu_felix",
		starting_owner_faction = "wh3_dlc25_dwf_malakai", -- Including this will spawn the hero for the faction when starting as them
		auto_embed_for_starting_owner_faction = true, -- This will automatically embed the hero into the starting army if this hero is spawned for the starting_owner_faction
		override_allowed_factions = {
			main_warhammer = {
				"wh_main_emp_empire",
				"wh_main_emp_wissenland",
				"wh2_dlc13_emp_golden_order",
				"wh2_dlc13_emp_the_huntmarshals_expedition",
				"wh3_main_emp_cult_of_sigmar",
				"wh3_main_ksl_the_ice_court",
				"wh3_main_ksl_ursun_revivalists",
				"wh3_main_ksl_the_great_orthodoxy",
				"wh3_dlc24_ksl_daughters_of_the_forest",
				"wh3_dlc24_cth_the_celestial_court",
				"wh3_main_cth_the_northern_provinces",
				"wh3_main_cth_the_western_provinces",
				"wh_main_brt_bordeleaux",
				"wh2_dlc14_brt_chevaliers_de_lyonesse",
				"wh_main_brt_bretonnia",
				"wh_main_brt_carcassonne",
				"wh_main_dwf_dwarfs",
				"wh3_main_dwf_the_ancestral_throng",
				"wh2_dlc17_dwf_thorek_ironbrow",
				"wh_main_dwf_karak_izor",
				"wh_main_dwf_karak_kadrin"
			},
			wh3_main_chaos = {
				"wh_main_emp_wissenland",
				"wh3_main_ksl_the_ice_court",
				"wh3_main_ksl_ursun_revivalists",
				"wh3_main_ksl_the_great_orthodoxy",
				"wh3_dlc24_ksl_daughters_of_the_forest",
				"wh3_dlc24_cth_the_celestial_court",
				"wh3_main_cth_the_northern_provinces",
				"wh3_main_cth_the_western_provinces"
			}
		},
		non_playable_factions_allowed = false,
		factions_involved = {},
		mission_keys = {
			wh_main_emp_wissenland = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_elspeth",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_elspeth"
			},
			wh_main_emp_empire = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_karl_franz"
			},
			wh2_dlc13_emp_golden_order = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_gelt"
			},
			wh2_dlc13_emp_the_huntmarshals_expedition = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_markus_wulfhart"
			},
			wh3_main_emp_cult_of_sigmar = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_volkmar"
			},
			wh3_main_ksl_the_ice_court = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_katarin",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_katarin"
			},
			wh3_main_ksl_ursun_revivalists = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_boris",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_boris"
			},
			wh3_main_ksl_the_great_orthodoxy = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_kostaltyn",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_kostaltyn"
			},
			wh3_dlc24_ksl_daughters_of_the_forest = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_ostankya",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_ostankya"
			},
			wh3_dlc24_cth_the_celestial_court = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_yuan_bo",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_yuan_bo"
			},
			wh3_main_cth_the_northern_provinces = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_miao_ying",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_miao_ying"
			},
			wh3_main_cth_the_western_provinces = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_zhao_ming",
				["wh3_main_chaos"] = "wh3_dlc25_qb_gotrek_felix_chaos_zhao_ming"
			},
			wh_main_brt_bordeleaux = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_alberic"
			},
			wh_main_brt_carcassonne = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_fay_enchantress"
			},
			wh_main_brt_bretonnia = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_louen"
			},
			wh2_dlc14_brt_chevaliers_de_lyonesse = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_repanse"
			},
			wh_main_dwf_karak_izor = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_belegar"
			},
			wh2_dlc17_dwf_thorek_ironbrow = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_thorek"
			},
			wh_main_dwf_dwarfs = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_thorgrim"
			},
			wh3_main_dwf_the_ancestral_throng = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_grombrindal"
			},
			wh_main_dwf_karak_kadrin = {
				["main_warhammer"] = "wh3_dlc25_qb_gotrek_felix_ie_ungrim"
			},
		},
		ancillaries = {
			"wh2_pro08_anc_weapon_gotrek_axe",
		},
		additional_ancillaries = {
			"wh2_pro08_anc_weapon_felix_sword"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc25_qb_gotrek_felix_ie_alberic",
				"wh3_dlc25_qb_gotrek_felix_ie_belegar",
				"wh3_dlc25_qb_gotrek_felix_ie_boris",
				"wh3_dlc25_qb_gotrek_felix_ie_elspeth",
				"wh3_dlc25_qb_gotrek_felix_ie_fay_enchantress",
				"wh3_dlc25_qb_gotrek_felix_ie_gelt",
				"wh3_dlc25_qb_gotrek_felix_ie_grombrindal",
				"wh3_dlc25_qb_gotrek_felix_ie_karl_franz",
				"wh3_dlc25_qb_gotrek_felix_ie_katarin",
				"wh3_dlc25_qb_gotrek_felix_ie_kostaltyn",
				"wh3_dlc25_qb_gotrek_felix_ie_louen",
				"wh3_dlc25_qb_gotrek_felix_ie_markus_wulfhart",
				"wh3_dlc25_qb_gotrek_felix_ie_miao_ying",
				"wh3_dlc25_qb_gotrek_felix_ie_ostankya",
				"wh3_dlc25_qb_gotrek_felix_ie_repanse",
				"wh3_dlc25_qb_gotrek_felix_ie_thorek",
				"wh3_dlc25_qb_gotrek_felix_ie_thorgrim",
				"wh3_dlc25_qb_gotrek_felix_ie_ungrim",
				"wh3_dlc25_qb_gotrek_felix_ie_volkmar",
				"wh3_dlc25_qb_gotrek_felix_ie_yuan_bo",
				"wh3_dlc25_qb_gotrek_felix_ie_zhao_ming"
			},
			wh3_main_chaos = {
				"wh3_dlc25_qb_gotrek_felix_chaos_boris",
				"wh3_dlc25_qb_gotrek_felix_chaos_elspeth",
				"wh3_dlc25_qb_gotrek_felix_chaos_katarin",
				"wh3_dlc25_qb_gotrek_felix_chaos_kostaltyn",
				"wh3_dlc25_qb_gotrek_felix_chaos_miao_ying",
				"wh3_dlc25_qb_gotrek_felix_chaos_ostankya",
				"wh3_dlc25_qb_gotrek_felix_chaos_yuan_bo",
				"wh3_dlc25_qb_gotrek_felix_chaos_zhao_ming"
			}
		},
	},
	garagrim = {
		-- Dwarf players will get a mission to unlock Garagrim once their faction leader reaches rank 10
		-- If there are no human Dwarf players the strongest Dwarf faction will get Garagrim after 30 turns
		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 10,
		ai_unlock_turn = 30,
		has_spawned = false,
		require_dlc = {"TW_WH3_THRONES_OF_DECAY_DWF"},
		name = "garagrim",
		subtype = "wh3_dlc25_dwf_garagrim_ironfist",
		priority_faction = "wh_main_dwf_karak_kadrin",
		priority_ai_faction = "wh_main_dwf_karak_kadrin",
		allowed_cultures = {
		"wh_main_dwf_dwarfs"
		},
		factions_involved = {},
		mission_keys = "wh3_dlc25_mis_dwf_garagrim_unlock",
		ancillaries = {
			"wh3_dlc25_anc_weapon_axes_of_kadrin"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc25_mis_dwf_garagrim_unlock"
			},
			wh3_main_chaos = {
				"wh3_dlc25_mis_dwf_garagrim_unlock"
			}
		},	
	},	
	theodore = {
		-- Empire players will get a mission to unlock Theodore once their faction leader reaches rank 10.
		-- If there are no human Empire players, Theodore spawns on turn 20 for Nuln faction.
		condition_to_start_unlock = character_unlocking.character_unlock_condition_types.rank,
		ai_condition_to_start_unlock = character_unlocking.character_unlock_condition_types.turn,
		unlock_rank = 10,
		ai_unlock_turn = 20,
		has_spawned = false,
		name = "theodore",
		require_dlc = {"TW_WH3_THRONES_OF_DECAY_EMP"},
		subtype = "wh3_dlc25_emp_theodore_bruckner",
		priority_faction = "wh_main_emp_wissenland",			-- This sets it so that if a human player is playing as the specified faction only they can get theodore
		priority_ai_faction = "wh_main_emp_wissenland",			-- This sets is so that if there is no human empire player then the specified AI faction gets them
		factions_involved = {},
		allowed_cultures = {
			"wh_main_emp_empire"
		},
		mission_keys = "wh3_dlc25_mis_emp_theodore_unlock_1",
		ancillaries = {
			"wh3_dlc25_anc_talisman_baleflame_amulet",
			"wh3_dlc25_anc_enchanted_item_stormlance",
			"wh3_dlc25_anc_weapon_liarsbane"
		},
		mission_chain_keys = {
			main_warhammer = {
				"wh3_dlc25_mis_emp_theodore_unlock_2"
			},
			wh3_main_chaos = {
				"wh3_dlc25_mis_emp_theodore_unlock_2"
			}
		},
	},
}

function character_unlocking:setup_legendary_hero_unlocking()
	for i = 1, #self.character_list do
		local character = self.character_list[i]
		local current_character = self.character_data[character]
		
		-- Generate allowed factions list for character
		if current_character.allowed_factions == nil then
			current_character.allowed_factions = self:get_allowed_factions_list(current_character)
		end

		if character and self:character_has_valid_faction_in_campaign(character) then
			local has_starting_owner = false
			if current_character.starting_owner_faction then

				-- Spawn character at game start if playing as starting owner faction
				local main_faction = cm:get_faction(current_character.starting_owner_faction)
				if main_faction then
					main_faction_human = main_faction:is_human()
				end
				if cm:is_new_game() and main_faction_human then
					--- remove hero recruited event message on turn 1 start 
					cm:disable_event_feed_events(true, "wh_event_category_agent", "", "");
					self:spawn_hero(current_character.starting_owner_faction, character)
					--- re-activate event feed after spawn
					cm:disable_event_feed_events(false, "wh_event_category_agent", "", "");
					has_starting_owner = true
				end
			end
			if has_starting_owner == false then --Remember to add the spawn_hero_for_ai() function to the end of function for any new unlock condition type that you may add.
				if current_character.condition_to_start_unlock == self.character_unlock_condition_types.rank then
					self:add_listeners_for_character_rank_unlock(character)
				elseif current_character.condition_to_start_unlock == self.character_unlock_condition_types.quest then
					self:add_quest_mission_listener(character)
				elseif current_character.condition_to_start_unlock == self.character_unlock_condition_types.ritual then
					self:add_ritual_listener(character)
				elseif current_character.condition_to_start_unlock == self.character_unlock_condition_types.building then
					self:add_building_completed_listeners(character)
				end

				-- Setup listeners for alternate grant conditions
				if current_character.alternate_grant_condition ~= nil then
					if current_character.alternate_grant_condition == self.character_alternate_grant_condition_types.dilemma_payload then
						self:add_dilemma_payload_listener(character)
					end
				end
			end
		end
	end
end

----------------------------------
------ Player rank Unlocking -----
----------------------------------

function character_unlocking:add_listeners_for_character_rank_unlock(character)
	out("#### Add Legendary Hero unlocking Listeners ####")
	local character_info = self.character_data[character]
	local rank_hero_unlock_human_count = 0
	local priority_faction_found = false

	if character_info.priority_faction ~= nil then
		local faction_interface = cm:get_faction(character_info.priority_faction)
		if faction_interface and faction_interface:is_human() then
			self:setup_mission_listeners(character)
			rank_hero_unlock_human_count = rank_hero_unlock_human_count + 1
			priority_faction_found = true
		end
	end

	if not priority_faction_found then
		for i = 1, #character_info.allowed_factions do
			local faction_interface = cm:get_faction(character_info.allowed_factions[i])
			if faction_interface and faction_interface:is_human() then
				-- there's at least 1 human player of mission factions
				self:setup_mission_listeners(character)
				rank_hero_unlock_human_count = rank_hero_unlock_human_count + 1
			end
		end
	end
	if rank_hero_unlock_human_count == 0 then
		self:spawn_hero_for_ai(character)
	end
end

function character_unlocking:setup_mission_listeners(character)
	local character_info = self.character_data[character]
	local character_launch_mission = character_info.name .. "LaunchMission"
	local character_mission_success = character_info.name .. "MissionSuccess"

	if character_info.has_spawned == false then
		for i = 1, #character_info.allowed_factions do
			local faction = cm:get_faction(character_info.allowed_factions[i])
			if faction and faction:is_human() then
				

				cm:add_faction_turn_start_listener_by_name(
					character_launch_mission,
					character_info.allowed_factions[i],
					function(context)
						if character_info.has_spawned == false then
							local faction = context:faction()
							local faction_name = faction:name()
							local trigger_mission = false

							-- Is character available for the faction
							if not character_info.factions_involved[faction_name] then
								if character_info.priority_faction == faction_name and faction:faction_leader():rank() >= 2 then
									trigger_mission = true
								elseif faction:faction_leader():rank() >= character_info.unlock_rank then
									trigger_mission = true
								end
							end

							if trigger_mission then
								character_info.factions_involved[faction_name] = true
								local mission_key = self:get_mission_key(character_info.mission_keys, faction_name)
								if is_string(mission_key) then 
									cm:trigger_mission(faction_name, mission_key, true)
								else
									script_error("Legendary Hero spawning script returned >1 or 0 missions for a character when setting up listeners, which would otherwise crash the game")
								end 
							end
						end
					end,
					true
				)
			end
		end

		core:add_listener(
			character_mission_success,
			"MissionSucceeded",
			function(context)
				return self:is_match_key_from_list(
					context:mission():mission_record_key(),
					character_info.mission_chain_keys,
					context:faction():name()
				)
			end,
			function(context)
				local faction_name = context:faction():name()
				if not character_info.alternate_grant_condition then
					self:spawn_hero(faction_name, character)
					self:cancel_missions_for_other_players(faction_name, character, character_mission_success)
				end
			end,
			true
		)
	end
end

----------------------------------
------ quest MISSION UNLOCK ------
----------------------------------

function character_unlocking:add_quest_mission_listener(character)
	local character_info = self.character_data[character]
	local character_mission_success = character_info.name .. "MissionSuccess"
	local quest_hero_unlock_human_count = 0
	local priority_faction_found = false
	
	if character_info.priority_faction ~= nil then
		local faction = cm:get_faction(character_info.priority_faction)
		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			quest_hero_unlock_human_count = quest_hero_unlock_human_count + 1
			self:setup_mission_completed_spawn_hero_listener(character, faction_name, character_mission_success)
			priority_faction_found = true
		end
	end

	if not priority_faction_found then
		for i = 1, #character_info.allowed_factions do
			local faction = cm:get_faction(character_info.allowed_factions[i])

			if faction and faction:is_human() then
				local faction_name = faction:name()
				character_info.factions_involved[faction_name] = true
				quest_hero_unlock_human_count = quest_hero_unlock_human_count + 1
				self:setup_mission_completed_spawn_hero_listener(character, faction_name, character_mission_success)
			end
		end
	end
	if quest_hero_unlock_human_count == 0 then
		self:spawn_hero_for_ai(character)
	end
end

----------------------------------
--------- ritual UNLOCK ----------
----------------------------------

function character_unlocking:add_ritual_listener(character)
	local character_info = self.character_data[character]
	local character_ritual_success = character_info.name .. "RitualCompletedEvent"
	local ritual_hero_unlock_human_count = 0
	local priority_faction_found = false

	if character_info.priority_faction ~= nil then
		local faction = cm:get_faction(character_info.priority_faction)
		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			ritual_hero_unlock_human_count = ritual_hero_unlock_human_count + 1
			self:setup_ritual_completed_spawn_hero_listener(character, faction_name, character_ritual_success)
			priority_faction_found = true
		end
	end

	if not priority_faction_found then
		for i = 1, #character_info.allowed_factions do
			local faction = cm:get_faction(character_info.allowed_factions[i])

			if faction and faction:is_human() then
				local faction_name = faction:name()
				character_info.factions_involved[faction_name] = true
				ritual_hero_unlock_human_count = ritual_hero_unlock_human_count + 1
				self:setup_ritual_completed_spawn_hero_listener(character, faction_name, character_ritual_success)
			end
		end
	end
	if ritual_hero_unlock_human_count == 0 then
		self:spawn_hero_for_ai(character)
	end
end

----------------------------------
---------- AI UNLOCKING ----------
----------------------------------

function character_unlocking:spawn_hero_for_ai(character)
	local character_info = self.character_data[character]
	if character_info.ai_condition_to_start_unlock == self.character_unlock_condition_types.turn then
		self:ai_unlock_by_turn(character)
	elseif character_info.ai_condition_to_start_unlock == self.character_unlock_condition_types.rank then
		self:ai_unlock_by_rank(character)
	end
end

function character_unlocking:ai_unlock_by_turn(character)
	local character_info = self.character_data[character]
	local character_ai_spawn = character_info.name .. "AISpawn"
	core:add_listener(
		character_ai_spawn,
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= character_info.ai_unlock_turn and self:character_has_valid_faction_in_campaign(character)
		end,
		function(context)
			if character_info.has_spawned == false then
				local ai_faction = self:get_strongest_ai_faction_available_to_character(character)
				if character_info.priority_ai_faction ~= nil then
					ai_faction = character_info.priority_ai_faction
				end

				self:spawn_hero(ai_faction, character)
			end
		end,
		false
	)
end

function character_unlocking:ai_unlock_by_rank(character)
	local character_info = self.character_data[character]
	local character_ai_spawn = character_info.name .. "AISpawn"

	core:add_listener(
		character_ai_spawn,
		"CharacterRankUp",
		function(context)
			local character_interface = context:character()
			local faction = character_interface:family_member():character_details():faction()
			local faction_name = faction:name()
			local has_priority_ai_faciton = false

			if character_info.priority_ai_faction ~= nil then
				if faction_name == character_info.priority_ai_faction then
					has_priority_ai_faciton = true
					return character_interface:rank() >= character_info.ai_unlock_rank and self:character_has_valid_faction_in_campaign(character) and character_info.has_spawned == false
				end
			end

			if not has_priority_ai_faciton then
				for i = 1, #character_info.allowed_factions do
					if faction_name == character_info.allowed_factions[i] then
						return character_interface:rank() >= character_info.ai_unlock_rank and self:character_has_valid_faction_in_campaign(character) and character_info.has_spawned == false
					end
				end
			end
		end,
		function(context)
			local faction = context:character():family_member():character_details():faction()
			self:spawn_hero(faction:name(), character)
		end,
		true
	)
end

function character_unlocking:ai_spawn_hero_strongest_faction(character)
	local character_info = self.character_data[character]
	if character_info.has_spawned == false then
		self:spawn_hero(self:get_strongest_ai_faction_available_to_character(character), character)
	end
end

----------------------------------
----- dilemma Payload Unlock -----
----------------------------------

function character_unlocking:add_dilemma_payload_listener(character)
	local character_info = self.character_data[character]
	local character_dilemma_choice = character_info.name .. "dilemmaSpawn"
	local character_trigger_dilemma = character_info.name .. "TriggerDilemma"

	core:add_listener(
		character_dilemma_choice,
		"DilemmaChoiceMadeEvent",
		function(context)
			return self:is_match_key_from_list(context:dilemma(), character_info.dilemma_keys)
		end,
		function(context)
			local choice = context:choice()
			local cancel_for_other_mp_players = true
			if self:is_match_key_from_list(choice, character_info.spawn_hero_dilemma_choice) then
				self:spawn_hero(context:faction():name(), character, context:faction():faction_leader():command_queue_index())
			elseif #cm:get_human_factions() > 1 and choice == character_info.ai_spawn_hero_dilemma_choice then
				cancel_for_other_mp_players = false -- Don't cancel for other mp players
			elseif character_info.ai_spawn_hero_dilemma_choice and choice == character_info.ai_spawn_hero_dilemma_choice then
				self:ai_spawn_hero_strongest_faction(character)
			end

			local faction_name = context:faction():name()
			if cancel_for_other_mp_players == true then
				self:cancel_missions_for_other_players(faction_name, character)
			end
		end,
		true
	)

	core:add_listener(
		character_trigger_dilemma,
		"MissionSucceeded",
		function(context)
			return self:is_match_key_from_list(context:mission():mission_record_key(), character_info.missions_to_trigger_dilemma)
		end,
		function(context)
			if character_info.alt_reward_dilemma_triggered ~= nil and not character_info.alt_reward_dilemma_triggered then
				cm:trigger_dilemma(context:faction():name(), character_info.trigger_dilemma_key)
				character_info.alt_reward_dilemma_triggered = true
			end
		end,
		true
	)
end

----------------------------------
---- Specific Building Unlock ----
----------------------------------

function character_unlocking:add_building_completed_listeners(character)
	local character_info = self.character_data[character]
	local character_building_complete = character_info.name .. "buildingcompleted"
	local building_unlock_human_faction_counter = 0
	local priority_faction_found = false

	-- Setup mission trigger listeners
	if character_info.priority_faction ~= nil then
		local faction = cm:get_faction(character_info.priority_faction)
		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			building_unlock_human_faction_counter = building_unlock_human_faction_counter + 1
			self:setup_building_completed_spawn_hero_listener(character, faction_name, character_building_complete)
			priority_faction_found = true
		end
	end

	if not priority_faction_found then
		for i = 1, #character_info.allowed_factions do
			local faction = cm:get_faction(character_info.allowed_factions[i])

			if faction and faction:is_human() then
				local faction_name = faction:name()
				character_info.factions_involved[faction_name] = true
				building_unlock_human_faction_counter = building_unlock_human_faction_counter + 1
				self:setup_building_completed_spawn_hero_listener(character, faction_name, character_building_complete)
			end
		end
	end

	-- Spawn hero on mission completion
	local building_mission_success = "legendary_character_building_mission_success"
	core:add_listener(
		building_mission_success,
		"MissionSucceeded",
		function(context)
			return self:is_match_key_from_list(
				context:mission():mission_record_key(),
				character_info.mission_keys,
				context:faction():name()
			)
		end,
		function(context)
			local faction_interface = context:faction()
			local faction_name = faction_interface:name()
			if not character_info.alternate_grant_condition then
				self:spawn_hero(faction_name, character, faction_interface:faction_leader():command_queue_index())
				self:cancel_missions_for_other_players(faction_name, character, building_mission_success)
			end
		end,
		false
	)

	if building_unlock_human_faction_counter == 0 then
		self:spawn_hero_for_ai(character)
	end
end

----------------------------------
----------- Spawn Hero -----------
----------------------------------

function character_unlocking:spawn_hero(faction_name, character, spawn_character_cqi)
	local character_info = self.character_data[character]
	local faction = cm:get_faction(faction_name)
	if character_info.has_spawned == false then
		character_info.has_spawned = true
		local character_ancillaries = character_info.name .. "GiveAncillaries"
		
		core:add_listener(
			character_ancillaries,
			"UniqueAgentSpawned",
			function(context)
				return context:unique_agent_details():character():character_subtype(character_info.subtype)
			end,
			function(context)
				character_unlocking:unique_agent_listener(context, faction, character_info, character_info.subtype, character_info.ancillaries)
			end,
			false
		)

		if character_info.additional_subtype ~= nil then
			local character_ancillaries_additional = character_info.name .. "GiveAncillariesAdditional"

			core:add_listener(
				character_ancillaries_additional,
				"UniqueAgentSpawned",
				function(context)
					return context:unique_agent_details():character():character_subtype(character_info.additional_subtype)
				end,
				function(context)
					character_unlocking:unique_agent_listener(context, faction, character_info, character_info.additional_subtype, character_info.additional_ancillaries)
				end,
				false
			)
		end

		if not spawn_character_cqi and faction:has_faction_leader() then
			local faction_leader = faction:faction_leader()
			if faction_leader:has_military_force() then
				spawn_character_cqi = faction_leader:command_queue_index()
			end
		end

		if spawn_character_cqi then
			local spawn_character = cm:get_character_by_cqi(spawn_character_cqi)
			local has_region = spawn_character:has_region()
			local has_garrison_residence = false

			if has_region then
				has_garrison_residence = spawn_character:has_garrison_residence()
			end
			
			if has_region and not has_garrison_residence or (has_garrison_residence and not spawn_character:garrison_residence():is_under_siege()) then
				cm:spawn_unique_agent_at_character(
					faction:command_queue_index(),
					character_info.subtype,
					spawn_character_cqi,
					true
				)

				if character_info.additional_subtype ~= nil then
					cm:spawn_unique_agent_at_character(
						faction:command_queue_index(),
						character_info.additional_subtype,
						spawn_character_cqi,
						true
					)
				end

			elseif faction:has_home_region() then
				cm:spawn_unique_agent_at_region(faction:command_queue_index(), character_info.subtype, faction:home_region():cqi(), true)

				if character_info.additional_subtype ~= nil then
					cm:spawn_unique_agent_at_region(faction:command_queue_index(), character_info.additional_subtype, faction:home_region():cqi(), true)
				end
			else
				cm:spawn_unique_agent(faction:command_queue_index(), character_info.subtype, true)
				if character_info.additional_subtype ~= nil then
					cm:spawn_unique_agent(faction:command_queue_index(), character_info.additional_subtype, true)
				end
			end
		else
			cm:spawn_unique_agent(faction:command_queue_index(), character_info.subtype, true)
			if character_info.additional_subtype ~= nil then
				cm:spawn_unique_agent(faction:command_queue_index(), character_info.additional_subtype, true)
			end
		end
		
		if character_info.mission_incidents ~= nil and faction:is_human() then -- Trigger optional incidents
			cm:trigger_incident(faction_name, character_info.mission_incidents[faction_name], true, true)
		end
	end
end

function character_unlocking:unique_agent_listener(context, faction, character_info, agent_subtype, ancillaries)
	local character_ancillaries = character_info.name .. "GiveAncillaries"
	local agent = context:unique_agent_details():character()
	if agent:is_null_interface() == false and agent:character_subtype(agent_subtype) then
		local cqi = agent:cqi()
		local spawn_rank = character_info.spawn_rank or 0
		if agent:rank() < spawn_rank then
			cm:add_agent_experience(cm:char_lookup_str(cqi), spawn_rank, true)
		end

		cm:replenish_action_points(cm:char_lookup_str(cqi))

		if faction:is_human() then
			cm:callback( --This can be a bit temperamental with AI factions, so we will use different method for them.
				function()
					
					if ancillaries ~= nil then
						local agent = cm:get_character_by_cqi(cqi)
						for i = 1, #ancillaries do
							cm:force_add_ancillary(agent, ancillaries[i], false, true)
						end
						
						if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
							cm:save()
						end
					end

					cm:callback(
						function()
							CampaignUI.ClearSelection()
						end,
						0.5
					)
				end,
				0.5
			)

			-- Move camera to newly spawned character position
			if context:unique_agent_details():faction():is_human() and faction_name == cm:get_local_faction_name(true) then
				cm:callback(
					function()
						if not cm:model():pending_battle():is_active() then
							local character = faction:faction_leader()
							cm:scroll_camera_from_current(true, 1.5, {character:display_position_x(), character:display_position_y(), 6, 0, 6});
						end
					end,
					0.4
				)
			end
		else 
			core:add_listener(
				character_ancillaries .. "_ai",
				"WorldStartRound",
				function()
					return character_info.ancillaries
				end,
				function()
					local ai_character = cm:get_character_by_cqi(cqi)
					
					if ai_character then
						for i = 1, #character_info.ancillaries do
							cm:force_add_ancillary(ai_character, character_info.ancillaries[i], false, true)
						end
					end
				end,
				false
			)
		end

		local hero_faction = context:unique_agent_details():faction():name()

		if character_info.auto_embed_for_starting_owner_faction == true and hero_faction == character_info.starting_owner_faction  then
			local force_list = context:unique_agent_details():faction():military_force_list()
			if not force_list:is_empty() then
				cm:embed_agent_in_force(agent, force_list:item_at(0))
			end
		else
			-- Move camera to newly spawned character position
			if cm:get_faction(hero_faction):is_human() and faction == cm:get_local_faction_name(true) then
				cm:callback(
					function()
						if not cm:model():pending_battle():is_active() then
							local character = cm:get_faction(faction):faction_leader()
							cm:scroll_camera_from_current(true, 1.5, {character:display_position_x(), character:display_position_y(), 6, 0, 6});
						end
					end,
					0.4
				)
			end
		end
	end
	
end

----------------------------------
------------ Helpers -------------
----------------------------------

function character_unlocking:get_strongest_ai_faction_available_to_character(character)
	local character_info = self.character_data[character]
	-- Give Legendary Hero to the current strongest AI faction so that they have the best chance of surviving for a while
	local world = cm:model():world()
	local strongest_faction
	local strongest_rank = 3000

	for _, valid_faction in ipairs(character_info.allowed_factions) do
		local faction = cm:get_faction(valid_faction)

		if faction and not faction:is_human() then
			local rank = world:faction_strength_rank(faction)
			if rank < strongest_rank then
				strongest_faction = valid_faction
				strongest_rank = rank
			end
		end
	end
	out.design(
		"Legendary Character Unlocking - Spawning character [" ..
			character_info.name .. "] for AI faction [" .. strongest_faction .. "]"
	)
	return strongest_faction
end

function character_unlocking:is_match_key_from_list(key_to_check, list_to_check, faction_name)
	local faction_name = faction_name or ""
	local campaign_name = cm:get_campaign_name()
	if list_to_check[faction_name] then
		if type(list_to_check[faction_name]) == "table" then
			for j = 1, #list_to_check[faction_name] do
				local list = list_to_check[faction_name]
				if list[j] == key_to_check then
					return true
				end
			end
		else
			return list_to_check[faction_name] == key_to_check
		end
	elseif list_to_check[campaign_name] then
		if type(list_to_check[campaign_name]) == "table" then
			for j = 1, #list_to_check[campaign_name] do
				local list = list_to_check[campaign_name]
				if list[j] == key_to_check then
					return true
				end
			end
		else
			return list_to_check[campaign_name] == key_to_check
		end
	else
		if type(list_to_check) == "table" then
			for j = 1, #list_to_check do
				if key_to_check == list_to_check[j] then
					return true
				end
			end
		else
			return list_to_check == key_to_check
		end
	end
	return false
end

function character_unlocking:character_has_valid_faction_in_campaign(character)
	local character_info = self.character_data[character]
	for i = 1, #character_info.allowed_factions do
		local faction_interface = cm:get_faction(character_info.allowed_factions[i])
		if faction_interface then
			if not faction_interface:is_null_interface() then
				return true
			end
		end
	end
	return false
end

function character_unlocking:get_allowed_factions_list(character_data)
	local allowed_factions = {}
	local campaign_name = cm:get_campaign_name()

	if character_data.override_allowed_factions then
		local allowed_factions_list = character_data.override_allowed_factions
		if character_data.override_allowed_factions[campaign_name] ~= nil then
            allowed_factions_list = character_data.override_allowed_factions[campaign_name]
        else
            allowed_factions_list = character_data.override_allowed_factions
        end
		for i = 1, #allowed_factions_list do
			if character_data.require_dlc ~= nil then
				if self:check_dlc_ownership(character_data.require_dlc, allowed_factions_list[i]) then
					table.insert(allowed_factions, allowed_factions_list[i])
				end
			elseif character_data.require_dlc == nil then
				table.insert(allowed_factions, allowed_factions_list[i])
			end
		end
	end
	if character_data.allowed_cultures then
		local cultures_list
        if character_data.allowed_cultures[campaign_name] ~= nil then
            cultures_list = character_data.allowed_cultures[campaign_name]
        else
            cultures_list = character_data.allowed_cultures
        end

        for _, v in ipairs(cultures_list) do
            local culture_to_allowed_factions = self:get_allowed_factions_for_culture(v, character_data.non_playable_factions_allowed)
            for i = 1, #culture_to_allowed_factions do
                -- Don't setup missions for characters a player wouldn't be able to spawn due to lacking the DLC permissions anyway
                if character_data.require_dlc ~= nil then
					if self:check_dlc_ownership(character_data.require_dlc, culture_to_allowed_factions[i]) then
                   		table.insert(allowed_factions, culture_to_allowed_factions[i])
					end
                elseif character_data.require_dlc == nil then
                    table.insert(allowed_factions, culture_to_allowed_factions[i])
                end
            end
        end
	end
	return allowed_factions
end

function character_unlocking:get_allowed_factions_for_culture(culture, non_playable_factions_allowed)
	local available_factions = {}

	for _, current_faction in model_pairs(cm:model():world():faction_list()) do
		if current_faction:culture() == culture then
			if non_playable_factions_allowed then
				table.insert(available_factions, current_faction:name())
			else
				if current_faction:can_be_human() then
					table.insert(available_factions, current_faction:name())
				end
			end
		end
	end
	return available_factions
end

function character_unlocking:check_dlc_ownership(dlc_table, faction)
	local permission_passed = false
	for i = 1, #dlc_table do  -- If any of the required DLC is owned, we return true, since there are multiple pathways to ownership.
		if cm:faction_has_dlc_or_is_ai(dlc_table[i], faction) then
			permission_passed = true
		end
	end
	return permission_passed
end

--Should rewrite this function at some point, it currently must return a string to achieve desired functionality but as written can return a table, a string, or nil. 
function character_unlocking:get_mission_key(mission_keys, faction_name)
	local faction_name = faction_name or ""
	local campaign_name = cm:get_campaign_name()
	local culture_name = cm:get_faction(faction_name):culture()
	if mission_keys[faction_name] then
		if is_table(mission_keys[faction_name]) then
			return self:get_mission_key(mission_keys[faction_name], faction_name)
		end
		return mission_keys[faction_name]
	elseif mission_keys[campaign_name] then
		if is_table(mission_keys[campaign_name]) then
			return self:get_mission_key(mission_keys[campaign_name], faction_name)
		end
		return mission_keys[campaign_name]
	elseif mission_keys[culture_name] then
		if is_table(mission_keys[culture_name]) then
			return self:get_mission_key(mission_keys[culture_name], faction_name)
		end
		return mission_keys[culture_name]
	elseif is_table(mission_keys) then
		return mission_keys[1]
	else
		return mission_keys
	end
end

function character_unlocking:cancel_missions_for_other_players(completing_faction, character, character_mission_success_listener)
	local character_info = self.character_data[character]
	local campaign_name = cm:get_campaign_name()
	for i = 1, #character_info.allowed_factions do
		local faction = character_info.allowed_factions[i]
		if character_info.factions_involved[faction] and faction ~= completing_faction then
			if character_info.mission_chain_keys ~= nil then
				for _, mission_key in ipairs(character_info.mission_chain_keys[campaign_name]) do
					cm:cancel_custom_mission(faction, mission_key)
				end
			else
				cm:cancel_custom_mission(faction, self:get_mission_key(character_info.mission_keys, faction))
			end
			if character_mission_success_listener then
				core:remove_listener(faction .. character_mission_success_listener)
			end
		end
	end
	character_info.has_spawned = true
end


function character_unlocking:setup_mission_completed_spawn_hero_listener(character, faction_name, character_mission_success)
	local character_info = self.character_data[character]

	core:add_listener(
		faction_name .. character_mission_success,
		"MissionSucceeded",
		function(context)
			return self:is_match_key_from_list(
				context:mission():mission_record_key(),
				character_info.mission_keys,
				context:faction():name()
			)
		end,
		function(context)
			local faction_name = context:faction():name()
			if not character_info.alternate_grant_condition then
				self:spawn_hero(faction_name, character, faction:faction_leader():command_queue_index())
				self:cancel_missions_for_other_players(faction_name, character, character_mission_success)
			end
		end,
		true
	)
end


function character_unlocking:setup_ritual_completed_spawn_hero_listener(character, faction_name, character_ritual_success)
	local character_info = self.character_data[character]

	core:add_listener(
		faction_name .. character_ritual_success,
		"RitualCompletedEvent",
		function(context)
			return self:is_match_key_from_list(
				context:ritual():ritual_key(),
				character_info.ritual_keys,
				context:performing_faction():name()
			)
		end,
		function(context)
			local name = context:performing_faction():name()
			if not character_info.alternate_grant_condition then
				self:spawn_hero(name, character, faction:faction_leader():command_queue_index())

				for _, v in ipairs(character_info.allowed_factions) do
					if v ~= name and character_info.factions_involved[v] == true then
						core:remove_listener(v .. character_ritual_success)
					end

					if character_info.factions_involved[v] then
						character_info.factions_involved[v] = false
					end
				end
			end
		end,
		true
	)
end


function character_unlocking:setup_building_completed_spawn_hero_listener(character, faction_name, character_building_complete)
	local character_info = self.character_data[character]

	core:add_listener(
		faction_name..character_building_complete,
		"BuildingCompleted",
		function(context)
			local building_interface = context:building()
			local faction_key = building_interface:faction():name()
			local building_key = building_interface:name()
			return faction_key == faction_name and self:is_match_key_from_list(building_key, character_info.required_buildings)
		end,
		function(context)
			local faction_key = context:building():faction():name()
			cm:trigger_mission(faction_key, self:get_mission_key(character_info.mission_keys, faction_key), true)
			core:remove_listener(faction_name..character_building_complete)
		end,
		true
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		for i = 1, #character_unlocking.character_list do
			local data = character_unlocking.character_data[character_unlocking.character_list[i]]
			cm:save_named_value(data.name .. ".factions_involved", data.factions_involved, context)
			cm:save_named_value(data.name .. ".has_spawned", data.has_spawned, context)
			if data.allowed_factions then
				cm:save_named_value(data.name .. ".allowed_factions", data.allowed_factions, context)
			end
		end
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			for i = 1, #character_unlocking.character_list do
				local data = character_unlocking.character_data[character_unlocking.character_list[i]]
				data.factions_involved = cm:load_named_value(data.name .. ".factions_involved", data.factions_involved, context)
				data.has_spawned = cm:load_named_value(data.name .. ".has_spawned", data.has_spawned, context)
				if data.allowed_factions then
					data.allowed_factions = cm:load_named_value(data.name .. ".allowed_factions", data.allowed_factions, context)
				end
			end
		end
	end
)
