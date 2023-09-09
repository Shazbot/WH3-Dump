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
	"aekold"
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
		require_dlc = "TW_WH2_DLC16_TWILIGHT",
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
		require_dlc = "TW_WH3_ULRIKA_FREE",
		allowed_cultures = {
			"wh3_main_ksl_kislev",
			"wh_main_emp_empire"
		},
		factions_involved = {},
		mission_keys = {
			wh3_main_ksl_kislev = {
				["main_warhammer"] = "wh3_dlc23_ie_ksl_ulrika_stage_1",
				["wh3_main_chaos"] = "wh3_dlc23_chaos_ksl_ulrika_stage_1"
			},
			wh_main_emp_empire = {
				["main_warhammer"] = "wh3_dlc23_ie_emp_ulrika_stage_1",
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
			},
			wh3_main_chaos = {
				"wh3_dlc23_chaos_ksl_ulrika_stage_1",
				"wh3_dlc23_chaos_ksl_ulrika_stage_2"
			}
		},
		missions_to_trigger_dilemma = {
			main_warhammer = {
				"wh3_dlc23_ie_ksl_ulrika_stage_2",
				"wh3_dlc23_ie_emp_ulrika_stage_2"
			},
			wh3_main_chaos = {
				"wh3_dlc23_chaos_ksl_ulrika_stage_2"
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
		require_dlc = "TW_WH3_PRO11_HARALD_HAMMERSTORM",
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
		require_dlc = "TW_WH3_SHADOWS_OF_CHANGE",
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
		require_dlc = "TW_WH3_AEKOLD_FREE",
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
	}
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
			if current_character.starting_owner_faction then -- Spawn character at game start if playing as starting owner faction
				local main_faction = cm:get_faction(current_character.starting_owner_faction)
				if main_faction then
					main_faction_human = main_faction:is_human()
				end
				
				if cm:is_new_game() and main_faction_human then
					self:spawn_hero(current_character.starting_owner_faction, character)
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

	for i = 1, #character_info.allowed_factions do
		local faction_interface = cm:get_faction(character_info.allowed_factions[i])
		if faction_interface and faction_interface:is_human() then
			-- there's at least 1 human player of mission factions
			self:setup_mission_listeners(character)
			rank_hero_unlock_human_count = rank_hero_unlock_human_count + 1
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

							if not character_info.factions_involved[faction_name] and faction:faction_leader():rank() >= character_info.unlock_rank then
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

	for i = 1, #character_info.allowed_factions do
		local faction = cm:get_faction(character_info.allowed_factions[i])

		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			quest_hero_unlock_human_count = quest_hero_unlock_human_count + 1

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
	local character_ritual_success = character_info.name .. "ritualCompletedEvent"
	local ritual_hero_unlock_human_count = 0

	for i = 1, #character_info.allowed_factions do
		local faction = cm:get_faction(character_info.allowed_factions[i])

		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			ritual_hero_unlock_human_count = ritual_hero_unlock_human_count + 1

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
				self:spawn_hero(self:get_strongest_ai_faction_available_to_character(character), character)
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
			for i = 1, #character_info.allowed_factions do
				if faction_name == character_info.allowed_factions[i] then
					return character_interface:rank() >= character_info.ai_unlock_rank and self:character_has_valid_faction_in_campaign(character) and character_info.has_spawned == false
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

	-- Setup mission trigger listeners
	for i = 1, #character_info.allowed_factions do
		local faction = cm:get_faction(character_info.allowed_factions[i])

		if faction and faction:is_human() then
			local faction_name = faction:name()
			character_info.factions_involved[faction_name] = true
			building_unlock_human_faction_counter = building_unlock_human_faction_counter + 1

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
		if character_info.require_dlc ~= nil and not cm:faction_has_dlc_or_is_ai(character_info.require_dlc, faction_name) then
			return
		end
		local character_ancillaries = character_info.name .. "GiveAncillaries"
		local names_table = "names_name_"

		core:add_listener(
			character_ancillaries,
			"UniqueAgentSpawned",
			function(context)
				return context:unique_agent_details():character():character_subtype(character_info.subtype)
			end,
			function(context)
				local agent = context:unique_agent_details():character()

				if agent:is_null_interface() == false and agent:character_subtype(character_info.subtype) then
					local cqi = agent:cqi()
					local spawn_rank = character_info.spawn_rank or 0

					if agent:rank() < spawn_rank then
						cm:add_agent_experience(cm:char_lookup_str(cqi), spawn_rank, true)
					end

					cm:replenish_action_points(cm:char_lookup_str(cqi))

					if faction:is_human() then
						cm:callback( --This can be a bit temperamental with AI factions, so we will use different method for them.
							function()
								if character_info.ancillaries then
									for i = 1, #character_info.ancillaries do
										cm:force_add_ancillary(agent, character_info.ancillaries[i], false, true)
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
						character_ancillaries_ai = character_ancillaries .. "_ai"
						core:add_listener(
							character_ancillaries_ai,
							"WorldStartRound",
							true,
							function()
								if character_info.ancillaries then
									for i = 1, #character_info.ancillaries do
										cm:force_add_ancillary(agent, character_info.ancillaries[i], false, true)
									end
								end
							end,
							false
						)
					end
				end
			end,
			false
		)
		
		if not spawn_character_cqi and faction:has_faction_leader() then
			local faction_leader = faction:faction_leader()
			if faction_leader:has_military_force() then
				spawn_character_cqi = faction_leader:command_queue_index()
			end
		end

		if spawn_character_cqi then
			local spawn_character = cm:get_character_by_cqi(spawn_character_cqi)
			
			if spawn_character:has_region() then
				cm:spawn_unique_agent_at_character(
					faction:command_queue_index(),
					character_info.subtype,
					spawn_character_cqi,
					true
				)
			elseif faction:has_home_region() then
				cm:spawn_unique_agent_at_region(faction:command_queue_index(), character_info.subtype, faction:home_region():cqi(), true)
			else
				cm:spawn_unique_agent(faction:command_queue_index(), character_info.subtype, true)
			end
		else
			cm:spawn_unique_agent(faction:command_queue_index(), character_info.subtype, true)
		end
		
		if character_info.mission_incidents ~= nil and faction:is_human() then -- Trigger optional incidents
			cm:trigger_incident(faction_name, character_info.mission_incidents[faction_name], true, true)
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
        local allowed_factions_list
        if character_data.override_allowed_factions[campaign_name] ~= nil then
            allowed_factions_list = character_data.override_allowed_factions[campaign_name]
        else
            allowed_factions_list = character_data.override_allowed_factions
        end
        for i = 1, #allowed_factions_list do
			if (character_data.require_dlc and cm:faction_has_dlc_or_is_ai(character_data.require_dlc, allowed_factions_list[i])) or not character_data.require_dlc then
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
				if (character_data.require_dlc and cm:faction_has_dlc_or_is_ai(character_data.require_dlc, culture_to_allowed_factions[i])) or not character_data.require_dlc then
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
