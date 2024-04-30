
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	THE GREAT SCRIPT OF GRUDGES
--	This script generates Grudge Points when Dwarf factions are negatively
--	Interacted with by non-dwarf cultures
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------

OPTION_CHOICE = {
	"FIRST",
	"SECOND",
	"THIRD",
	"FOURTH"
}

FACTOR_TYPE = {
	BASE = "base",
	RAIDING = "raiding",
	NOT_DWARF_OWNED = "not_dwarf_owned",
	TRESPASSING = "trespassing"
}

local cqi_type = {
	mf = "mf",
	region = "region"
}

book_of_grudges = {
	grudge_culture = "wh_main_dwf_dwarfs",
	dwarf_faction_set_key = "anc_set_exclusive_dwarfs",
	grudges_factor_junction_dwarfs = "wh3_dlc25_dwf_grudge_points",
	grudges_factor_junction_enemy_armies = "wh3_dlc25_dwf_grudge_points_enemy_armies",
	grudges_factor_junction_enemy_settlements = "wh3_dlc25_dwf_grudge_points_enemy_settlements",
	grudge_exclusion_cultures = {
		"wh_main_dwf_dwarfs",
	},
	grudge_settlement_factors_to_keys = {
		grudges = "wh3_dlc25_dwf_grudge_points_enemy_settlements",
		grudges_passive = "wh3_dlc25_dwf_grudge_points_enemy_settlements_passive_gain",
		grudges_raiding = "wh3_dlc25_dwf_grudge_points_enemy_settlements_raiding",
		grudges_tresspassing = "wh3_dlc25_dwf_grudge_points_enemy_settlements_trespassing",
		grudges_historical_dwarf_settlement = "wh3_dlc25_dwf_grudge_points_historical_dwarf_settlement",
	},
	grudge_enemy_army_factors_to_keys = {
		grudges = "wh3_dlc25_dwf_grudge_points_enemy_armies",
		grudges_passive = "wh3_dlc25_dwf_grudge_points_enemy_armies_passive_gain",
		grudges_raiding = "wh3_dlc25_dwf_grudge_points_enemy_armies_raiding",
		grudges_tresspassing = "wh3_dlc25_dwf_grudge_points_enemy_armies_trespassing",
	},

	-- Grudge point generation values
	base_grudge_points = 40,
	not_owned_region_grudge_value = 20,
	raiding_grudge_value = 10,
	trespassing_grudge_value = 5,

	-- Factors for enemy army and settlement grudge pooled resources
	grudge_factors = {
		base = {
			army = "wh3_dlc25_dwf_grudge_points_enemy_armies",
			settlement = "wh3_dlc25_dwf_grudge_points_enemy_settlements"
		},
		raiding = {
			army = "wh3_dlc25_dwf_grudge_points_enemy_armies_raiding",
			settlement = "wh3_dlc25_dwf_grudge_points_enemy_settlements_raiding"
		},
		not_dwarf_owned = {
			settlement = "wh3_dlc25_dwf_grudge_points_historical_dwarf_settlement"
		},
		trespassing = {
			army = "wh3_dlc25_dwf_grudge_points_enemy_armies_trespassing",
			settlement = "wh3_dlc25_dwf_grudge_points_enemy_settlements_trespassing"
		},
	},

	grudge_culture_modifier_value_medium = 1.1,
	grudge_culture_modifier_value_high = 1.2,
	grudge_culture_modifiers = {
		wh2_dlc09_tmb_tomb_kings = "medium",
		wh2_dlc11_cst_vampire_coast = "medium",
		wh_main_vmp_vampire_counts = "medium",
		wh3_main_dae_daemons = "medium",
		wh3_main_kho_khorne = "medium",
		wh3_main_nur_nurgle = "medium",
		wh3_main_sla_slaanesh = "medium",
		wh3_main_tze_tzeentch = "medium",
		wh_main_chs_chaos = "medium",
		wh_dlc08_nor_norsca = "medium",
		wh_dlc03_bst_beastmen = "medium",

		wh2_main_skv_skaven = "high",
		wh3_dlc23_chd_chaos_dwarfs = "high",
		wh_main_grn_greenskins = "high",
		wh2_main_def_dark_elves = "high",
		wh2_main_hef_high_elves = "high",
		wh_dlc05_wef_wood_elves = "high"
	},
	
	-- unique lord data
	unique_lord = {
		ritual_key = "wh3_dlc25_dwf_ritual_grudges_campaign_upgrade_3",
		name = "names_name_291390137",
		age = 18,
		is_male = true,
		agent = "general",
		agent_subtype = "wh3_dlc25_dwf_lord_mikael_leadstrong",
		is_immortal = true
	},

	unit_packs = {
		pack_amount = 8,
		pack_key = "wh3_dlc25_dwf_ritual_mercenary_unit_pack_",
	},

	current_grudges_spent_key = "current_grudges_resource_spent_",
	max_grudges_spent_key = "max_grudges_resource_spent",
	max_grudges_spent_value = 2000,

	-- Disable/Enable book of grudges button
	disable_bog_key = "disable_book_of_grudges_button",
	grudges_pr_key = "wh3_dlc25_dwf_grudge_points",
	grudges_pr_key_enemy_army = "wh3_dlc25_dwf_grudge_points_enemy_armies",
	grudges_pr_key_enemy_settlement = "wh3_dlc25_dwf_grudge_points_enemy_settlements",
	grudges_required_to_unlock = 400,
	bog_unlocked_incident = "wh3_dlc25_dwf_bog_feature_unlocked",
	
	lock_faction_sets = {
		"anc_set_exclusive_dwarfs"
	},

	-- Confederation data
	confederation_factions_list = {
		"wh_main_dwf_karak_izor",
		"wh3_main_dwf_the_ancestral_throng",
		"wh3_dlc25_dwf_malakai",
		"wh2_dlc17_dwf_thorek_ironbrow",
		"wh_main_dwf_dwarfs",
		"wh_main_dwf_karak_kadrin"
	},
	
	faction_confederation_data = {
		wh_main_dwf_karak_izor = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_belegar",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_belegar_cost_mod"
		},
		wh3_main_dwf_the_ancestral_throng = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_grombrindal",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_grombrindal_cost_mod"
		},
		wh3_dlc25_dwf_malakai = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_malakai",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_malakai_cost_mod"
		},
		wh2_dlc17_dwf_thorek_ironbrow = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_thorek",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_thorek_cost_mod"
		},
		wh_main_dwf_dwarfs = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_thorgrim",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_thorgrim_cost_mod"
		},
		wh_main_dwf_karak_kadrin = {
			ritual = "wh3_dlc25_dwf_ritual_legendary_lord_ungrim",
			cost_mod_effect = "wh3_dlc25_dwf_ritual_confederation_ungrim_cost_mod"
		}
	},

	-- Confederation scaling
	percent_scale_cost_per_settlement = 10,
	confederation_cost_scale_bundle_key = "wh3_dlc25_bundle_dwf_confederation_rituals_cost_mods",

	-- Starting grudges for Legendary Lords
	starting_grudges_to_faction_leaders = {
		-- table_field_id
		names_name_2147343883 = { -- thorgrim
			main_warhammer = {	
				"wh2_dlc17_grudge_legendary_enemy_skarsnik",
				"wh2_dlc17_grudge_legendary_enemy_queek",
				"wh2_dlc17_grudge_legendary_settlement_black_crag",
				"wh2_dlc17_grudge_legendary_settlement_karak_azgal",
			}
		},
		names_name_2147344414 = { -- ungrim
			main_warhammer = {	
				"wh2_dlc17_grudge_legendary_settlement_karak_ungor",
				"wh2_dlc17_grudge_legendary_settlement_silver_pinnacle",
				"wh2_dlc17_grudge_legendary_settlement_karak_vlag",
				"wh3_dlc21_grudge_legendary_enemy_throt",
			}
		},
		names_name_2147358029 = { -- belegar
			main_warhammer = {	
				"wh_dlc06_grudge_belegar_eight_peaks",
				"wh_main_grudge_the_dragonback_grudge",
				"wh2_dlc17_grudge_legendary_enemy_skarsnik",
				"wh2_dlc17_grudge_legendary_enemy_queek",
			}
		},
		names_name_2147358917 = { -- grombrindal
			main_warhammer = {	
				"wh3_main_grudge_legendary_grombrindal",
				"wh2_dlc17_grudge_legendary_enemy_high_elves",
				"wh2_dlc17_grudge_legendary_enemy_dark_elves",
			}
		},
		names_name_976644877 = { -- thorek
			main_warhammer = {	
				"wh2_dlc17_main_grudge_legendary_artefact_beard_rings_of_grimnir",
				"wh2_dlc17_main_grudge_legendary_artefact_blessed_pick_of_grungni",
				"wh2_dlc17_main_grudge_legendary_artefact_keepsake_of_gazuls_favoured",
				"wh2_dlc17_main_grudge_legendary_artefact_lost_gifts_of_valaya",
				"wh2_dlc17_main_grudge_legendary_artefact_morgrims_gears_of_war",
				"wh2_dlc17_main_grudge_legendary_artefact_ratons_collar_of_bestial_control",
				"wh2_dlc17_main_grudge_legendary_artefact_smednirs_metallurgy_cipher",
				"wh2_dlc17_main_grudge_legendary_artefact_thungnis_tongs_of_the_runesmith",
			}
		},
		names_name_1197662411 = { -- malakai
			wh3_main_chaos = {
				"wh3_dlc25_grudge_legendary_settlement_karak_dum",
			},
			main_warhammer = {
				"wh3_dlc25_grudge_legendary_settlement_karak_dum_ie"
			}
		}
	},


	-- Grudge dilemmas
	dilemma_grudges_earned_threshold = 1000,
	dilemma_enemy_army_grudges_earned_threshold = 400,
	dilemma_not_enough_grudges_earned_threshold = 600,

	grudge_pr_tracker = {},
	grudge_pr_tracker_save_key = "grudges_pr_tracking_save_key",

	dilemma_data = {
		grudge_points_earned = {
			dilemma_type = "BoG_earned_grudge_points_dilemma",
			dilemma_key_start = "wh3_dlc25_dwf_book_of_grudges_dilemma_grudges_resolved_",
			dilemma_count = 1,
			dilemma_option_count = 2,
			cooldown_time = 12,
			initial_turn_cooldown = 6,

			options_data = {
				FIRST = {
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_guild_support",
					effect_list = {
						{type = "effect_bundle", key = "wh_main_effect_economy_gdp_mod_all", value = 10, scope = "faction_to_region_own"},
						{type = "effect_bundle", key = "wh2_dlc17_pooled_resource_oathgold_buildings_mod", value = 10, scope = "faction_to_region_own"},
						{type = "effect_bundle", key = "wh_main_effect_province_growth_events", value = 10, scope = "faction_to_region_own"},
						{type = "effect_bundle", key = "wh_main_effect_building_construction_cost_mod_all", value = -10, scope = "faction_to_region_own"},
					},
				},
				SECOND = {
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_clan_support",
					effect_list = {
						{type = "effect_bundle", key = "wh_main_effect_force_stat_ap_damage", value = 4, scope = "faction_to_force_own_unseen"},
						{type = "effect_bundle", key = "wh_main_effect_force_stat_armour", value = 15, scope = "faction_to_force_own_unseen"},
						{type = "effect_bundle", key = "wh_main_effect_force_stat_ammunition", value = 15, scope = "faction_to_province_own_unseen"},
						{type = "effect_bundle", key = "wh_main_effect_force_all_campaign_recruitment_cost_all", value = -15, scope = "faction_to_force_own_unseen"},
						{type = "effect_bundle", key = "wh_main_effect_force_all_campaign_upkeep", value = -10, scope = "faction_to_force_own_unseen"},
					},
				}
			}
		},
		enemy_army_reaches_threshold = {
			dilemma_type = "BoG_enemy_army_reaches_threshold_dilemma",
			dilemma_key_start = "wh3_dlc25_dwf_book_of_grudges_dilemma_grudges_building_",
			dilemma_count = 1,
			dilemma_option_count = 4,
			cooldown_time = 10,
			initial_turn_cooldown = 12,

			options_data = {
				FIRST = {
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_slayer_support",
					effect_list = {
						{type = "mercenary", mercenary = "wh_main_dwf_inf_slayers_grudge_reward", merc_amount = 2, key = "wh_main_effect_force_all_campaign_recruitment_cost_all", value = 20, scope = "faction_to_force_own_unseen"},
					},
				},
				SECOND = {
					choice_trigger_effects = {
						type = "grudges",
						target = "force",
						grudge_value = 250,
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_stoke_fury",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				},
				THIRD = {
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_reassure_clans",
					effect_list = {
						{type = "effect_bundle", key = "wh_main_effect_force_stat_weapon_strength", value = 15, scope = "faction_to_force_own_unseen", oathgold_cost = -300},
					},
				},
				FOURTH = {
					choice_trigger_effects = {
						type = "grudges",
						target = "faction",
						grudge_value = 50,
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_add_to_book",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				}
			}
		},
		neutral_faction_incurs_grudge = {
			dilemma_type = "BoG_faction_incurs_grudge_dilemma",
			dilemma_key_start = "wh3_dlc25_dwf_book_of_grudges_dilemma_faction_incurs_grudge_",
			dilemma_count = 3,
			dilemma_option_count = 2,
			cooldown_time = 10,
			initial_turn_cooldown = 9,

			options_data = {
				FIRST = {
					choice_trigger_effects = {
						type = "war",
						grudge_value = 100,
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_to_war",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				},
				SECOND = {
					choice_trigger_effects = {
						type = "grudges",
						target = "faction",
						grudge_value = 25,
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_add_to_book",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				}
			}
		},
		lack_of_grudges_gained = {
			dilemma_type = "BoG_not_completing_grudges_dilemma",
			dilemma_key_start = "wh3_dlc25_dwf_book_of_grudges_dilemma_too_many_grudges_",
			dilemma_count = 1,
			dilemma_option_count = 3,
			cooldown_time = 16,
			initial_turn_cooldown = 14,

			options_data = {
				FIRST = {
					choice_trigger_effects = {
						mission_to_trigger = "wh3_dlc25_dwf_book_of_grudges_dilemma_mission_earn_grudges",
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_grudge_mission",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				},
				SECOND = {
					choice_trigger_effects = {
						mission_to_trigger = "wh3_dlc25_dwf_book_of_grudges_dilemma_mission_earn_grudges_large",
					},
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_grudge_mission_hard",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				},
				THIRD = {
					custom_effect_bundle = "wh3_dlc25_dwf_dilemma_book_of_grudges_penalty",
					effect_list = {
						{type = "premade_effect_bundle"},
					},
				}
			}
		}
	},

	-- Traditional dwarf region list	
	dwarf_culture_regions = {
		wh3_main_chaos = {
			"wh3_main_chaos_region_kraka_dorden",
			"wh3_main_chaos_region_kraka_drak",
			"wh3_main_chaos_region_sjoktraken",
			"wh3_main_chaos_region_karak_dum",
			"wh3_main_chaos_region_karak_vlag",
			"wh3_main_chaos_region_karak_ungor",
			"wh3_main_chaos_region_kraz_und",
			"wh3_main_chaos_region_kurak_peak",
			"wh3_main_chaos_region_khazid_irkulaz",
			"wh3_main_chaos_region_karak_raziak",
			"wh3_main_chaos_region_karak_kadrin",
			"wh3_main_chaos_region_zhufbar",
			"wh3_main_chaos_region_oakenhammer",
			"wh3_dlc23_chaos_region_deadrock_gap",
			"wh3_dlc23_chaos_region_pillars_of_grungni",
			"wh3_main_chaos_region_karak_azgaraz",
			"wh3_main_chaos_region_karak_ziflin",
			"wh3_main_chaos_region_grim_duraz",
			"wh3_main_chaos_region_karak_azorn",
			"wh3_main_chaos_region_karak_krakaten",
			"wh3_main_chaos_region_karak_vrag"
		},
		main_warhammer = {
			"wh3_main_combi_region_karak_zorn",
			"wh3_main_combi_region_karag_orrud",
			"wh3_main_combi_region_vulture_mountain",
			"wh3_main_combi_region_eye_of_the_panther",
			"wh3_main_combi_region_misty_mountain",
			"wh3_main_combi_region_kradtommen",
			"wh3_main_combi_region_karak_azgal",
			"wh3_main_combi_region_dringorackaz",
			"wh3_main_combi_region_spitepeak",
			"wh3_main_combi_region_valayas_sorrow",
			"wh3_main_combi_region_karak_eight_peaks",
			"wh3_main_combi_region_sump_pit",
			"wh3_main_combi_region_karak_azul",
			"wh3_main_combi_region_black_iron_mine",
			"wh3_main_combi_region_black_crag",
			"wh3_main_combi_region_iron_rock",
			"wh3_main_combi_region_karag_dron",
			"wh3_main_combi_region_ash_ridge_mountains",
			"wh3_main_combi_region_karaz_a_karak",
			"wh3_main_combi_region_the_pillars_of_grungni",
			"wh3_main_combi_region_mount_squighorn",
			"wh3_main_combi_region_varenka_hills",
			"wh3_main_combi_region_barag_dawazbag",
			"wh3_main_combi_region_barak_varr",
			"wh3_main_combi_region_dok_karaz",
			"wh3_main_combi_region_ekrund",
			"wh3_main_combi_region_bitterstone_mine",
			"wh3_main_combi_region_dragonhorn_mines",
			"wh3_main_combi_region_stonemine_tower",
			"wh3_main_combi_region_zhufbar",
			"wh3_main_combi_region_oakenhammer",
			"wh3_main_combi_region_karag_dromar",
			"wh3_main_combi_region_mighdal_vongalbarak",
			"wh3_main_combi_region_karak_angazhar",
			"wh3_main_combi_region_karak_hirn",
			"wh3_main_combi_region_zarakzil",
			"wh3_main_combi_region_karak_bhufdar",
			"wh3_main_combi_region_karak_izor",
			"wh3_main_combi_region_grimhold",
			"wh3_main_combi_region_karak_norn",
			"wh3_main_combi_region_karak_azgaraz",
			"wh3_main_combi_region_karak_ziflin",
			"wh3_main_combi_region_the_high_place",
			"wh3_main_combi_region_mount_gunbad",
			"wh3_main_combi_region_worlds_edge_archway",
			"wh3_main_combi_region_grom_peak",
			"wh3_main_combi_region_fallen_king_mountain",
			"wh3_main_combi_region_gnashraks_lair",
			"wh3_main_combi_region_karak_kadrin",
			"wh3_main_combi_region_karak_raziak",
			"wh3_main_combi_region_khazid_irkulaz",
			"wh3_main_combi_region_karak_ungor",
			"wh3_main_combi_region_karak_krakaten",
			"wh3_main_combi_region_karak_azorn",
			"wh3_main_combi_region_karak_vrag",
			"wh3_main_combi_region_karak_dum",
			"wh3_main_combi_region_karak_vlag",
			"wh3_main_combi_region_sjoktraken",
			"wh3_main_combi_region_kraka_drak",
			"wh3_main_combi_region_mine_of_the_bearded_skulls",
			"wh3_main_combi_region_thrice_cursed_peak"
		}
	},

	-- Belegar ghost spawning for RoC confederation
	belegar_faction_key = "wh_main_dwf_karak_izor",
	belegar_dlc = "TW_WH1_LORDS_AND_UNITS_2",
	belegar_ghost_agents = {
		"wh_dlc06_dwf_master_engineer_ghost",
		"wh_dlc06_dwf_runesmith_ghost",
		"wh_dlc06_dwf_thane_ghost_1",
		"wh_dlc06_dwf_thane_ghost_2"
	}
}

---------------------------------------------------
------------------- Functions ---------------------
---------------------------------------------------

function book_of_grudges:setup_grudge_listeners()
	local campaign = cm:get_campaign_name()

	if cm:is_new_game() then
		local model = cm:model():world()
		for _,v in ipairs(self.lock_faction_sets) do
			lock_factions = model:lookup_factions_from_faction_set(v)
			for _, faction in model_pairs(lock_factions) do
				if not faction:is_null_interface() then
					if faction:is_human() then
						local faction_name = faction:name()

						-- lock the Book of Grudges button
						cm:override_ui(self.disable_bog_key, true)

						-- load starting grudges
						for faction_leader, missions in pairs(self.starting_grudges_to_faction_leaders) do
							if cm:general_with_forename_exists_in_faction_with_force(faction_name, faction_leader) then
								local campaign_missions = missions[campaign]
								for j = 1, #campaign_missions do
									cm:trigger_mission(faction_name, campaign_missions[j])
								end
							end
						end

						-- setup grudges confederation tab unlock tracker
						local faction_grudges_spent = self.current_grudges_spent_key .. faction_name
						local total_spent = cm:get_saved_value(faction_grudges_spent) or 0
						common.set_context_value(faction_grudges_spent, total_spent)
						common.set_context_value(self.max_grudges_spent_key, self.max_grudges_spent_value)
						
					end
				end
			end
		end

		self:generate_grudges_for_not_dwarf_owned_dwarf_settlements(true)
	end

	self:lock_dwarf_faction_confederations_for_human_players()
	self:setup_dilemma_listeners()

	-- War declared
	core:add_listener(
		"land_battle_result_grudge_points",
		"NegativeDiplomaticEvent",
		function(context)
			if context:is_war() then
				if context:proposer():culture() == self.grudge_culture or context:recipient():culture() == self.grudge_culture then
					return true
				end
			end
			return false
		end,
		function(context)
			-- Add grudge points to a factions MF and regions if war declared with a dwarf faction
			local proposer = context:proposer()
			local recipient = context:recipient()

			if proposer:culture() ~= self.grudge_culture then
				self:generate_grudge_points_for_faction(proposer)
			elseif recipient:culture() ~= self.grudge_culture then
				self:generate_grudge_points_for_faction(recipient)
			end
		end,
		true
	)


	-- -- listen for the player being raided (stance) and for trespassing
	core:add_listener(
		"BoG_raiding_and_trespassing",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) then
						return self:is_faction_being_raided(faction) or self:faction_has_tresspassers(faction)
					end
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local characters_in_regions_list = self:get_characters_in_faction_regions(faction)
			
			-- Raiding grudges generation
			local raiding_characters = self:get_raiding_characters(faction, characters_in_regions_list)
			for i = 1, #raiding_characters do
				local mf = raiding_characters[i]:military_force()
				self:generate_grudge_points_for_faction(mf:faction(), mf:command_queue_index(), cqi_type.mf, self.raiding_grudge_value, FACTOR_TYPE.RAIDING)
			end

			-- Tresspassing grudges generation
			local trespassing_characters = self:get_trespassing_characters(faction, characters_in_regions_list)
			for i = 1, #trespassing_characters do
				local mf = trespassing_characters[i]:military_force()
				self:generate_grudge_points_for_faction(mf:faction(), mf:command_queue_index(), cqi_type.mf, self.trespassing_grudge_value, FACTOR_TYPE.TRESPASSING)
			end
		end,
		true
	)


	-- listen for the player performing the ritual to unlock unique Lord
	core:add_listener(
		"mikael_leadstrong_unlocked",
		"RitualCompletedEvent",
		function(context)
			return context:succeeded() and context:ritual():ritual_key() == self.unique_lord.ritual_key
		end,
		function(context)
			cm:spawn_character_to_pool(
				context:performing_faction():name(),
				self.unique_lord.name,
				"",
				"",
				"",
				self.unique_lord.age,
				self.unique_lord.is_male,
				self.unique_lord.agent,
				self.unique_lord.agent_subtype,
				self.unique_lord.is_immortal,
				""
			)
		end,
		false
	)


	-- Setup grudge points for Dwarf factions' starting enemies
	if cm:is_new_game() then
		dwarf_factions = cm:model():world():lookup_factions_from_faction_set(self.dwarf_faction_set_key)
		for _, faction in model_pairs(dwarf_factions) do
			if not faction:is_null_interface() then
				local starting_enemy_list = faction:factions_at_war_with()
				for i = 0, starting_enemy_list:num_items() - 1 do
					if not starting_enemy_list:item_at(i):is_null_interface() then
						self:generate_grudge_points_for_faction(starting_enemy_list:item_at(i))
					end
				end
			end
		end
	end

	-- Track total ritual cost spent to unlock confederations	
	core:add_listener(
		"BoG_ritual_spent_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						return context:resource():key() == self.grudges_pr_key and context:amount() < 0
					end
				end
			end
			return false
		end,
		function(context)
			local amount = context:amount()
			local faction_grudges_spent = self.current_grudges_spent_key .. context:faction():name()
			local total_spent = cm:get_saved_value(faction_grudges_spent) or 0
			total_spent = total_spent + (-amount)

			cm:set_saved_value(faction_grudges_spent, total_spent)
			common.set_context_value(faction_grudges_spent, total_spent)

			if total_spent >= self.max_grudges_spent_value then
				core:remove_listener("bog_confederation_unlocker")
			end
		end,
		true
	)

	core:add_listener(
		"BoG_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						local pr = context:resource()
						return pr:key() == self.grudges_pr_key and pr:value() >= self.grudges_required_to_unlock
					end
				end
			end
			return false
		end,
		function(context)
			cm:override_ui(self.disable_bog_key, false)
			cm:trigger_incident(context:faction():name(), self.bog_unlocked_incident, true, true)
		end,
		false
	)

	core:add_listener(
		"BoG_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						local pr = faction:pooled_resource_manager():resource(self.grudges_pr_key)
						if not pr:is_null_interface() then
							return pr:value() >= self.grudges_required_to_unlock
						end
					end
				end
			end
			return false
		end,
		function(context)
			cm:override_ui(self.disable_bog_key, false)
			cm:trigger_incident(context:faction():name(), self.bog_unlocked_incident, true, true)
		end,
		false
	)

	-- Confederation cost scaling
	core:add_listener(
		"BoG_confederation_cost_scaling",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					return faction:is_contained_in_faction_set(v) and faction:is_human()
				end
			end
			return false
		end,
		function(context)
			self:scale_confederation_cost_based_on_owned_settlements(context:faction())
		end,
		true
	)

	-- Generate grudge points when traditional dwarf settlements aren’t owned by dwarf factions
	core:add_listener(
		"not_dwarf_owned_region_grudge_generation",
		"WorldStartRound",
		true,
		function(context)
			if not cm:is_new_game() then
				self:generate_grudges_for_not_dwarf_owned_dwarf_settlements()
			end
		end,
		false
	)

	-- Remove grudge points when traditional dwarf settlements aren’t owned by dwarf factions
	core:add_listener(
		"remove_grudge_points_when_non_dwarfs_attack_non_dwarfs",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:previous_owner_culture() ~= self.grudge_culture and context:character():faction():culture() ~= self.grudge_culture and not self:is_item_in_list(context:garrison_residence():region():name(), self.dwarf_culture_regions[campaign])
		end,
		function(context)
			local region_interface = context:garrison_residence():region()
			local grudge_resource = region_interface:pooled_resource_manager():resource(self.grudges_pr_key_enemy_settlement)
			if not grudge_resource:is_null_interface() then
				self:modify_grudge_value(region_interface, grudge_resource, self.grudge_settlement_factors_to_keys, true)
			end
		end,
		true
	)

	-- Remove grudge points from faction if makes alliance with Dwarf faction
	core:add_listener(
		"remove_grudge_points_when_form_alliance_with_dwarfs",
		"PositiveDiplomaticEvent",
		function(context)
			if context:proposer():culture() == self.grudge_culture or context:recipient():culture() == self.grudge_culture then
				return context:is_military_alliance() or context:is_defensive_alliance() or context:is_alliance()
			end
		end,
		function(context)
			local faction_to_remove = ""
			local grudge_faction = ""
			local proposer = context:proposer()
			local recipient = context:recipient()
			if proposer:culture() == self.grudge_culture then
				faction_to_remove = recipient
				grudge_faction = proposer
			elseif recipient:culture() == self.grudge_culture then
				faction_to_remove = proposer
				grudge_faction = recipient
			end

			self:remove_grudge_points_for_faction(faction_to_remove)

			if grudge_faction:is_human() then
				cm:trigger_incident_with_targets(
					grudge_faction:command_queue_index(),
					"wh3_dlc25_dwf_bog_grudge_settled_by_alliance",
					faction_to_remove:command_queue_index(),
					0,
					0,
					0,
					0,
					0
				)
			end
		end,
		true
	)

	-- If playing RoC spawn Belegar's ghosts when you confed him
	if campaign == "wh3_main_chaos" then
		core:add_listener(
			"belegar_confederated",
			"FactionJoinsConfederation",
			function(context)
				if cm:faction_has_dlc_or_is_ai(self.belegar_dlc, context:confederation():name()) == false then
					return false
				end
				return context:faction():name() == self.belegar_faction_key
			end,
			function(context)
				local faction = context:confederation()
				if faction:has_home_region() then
					for _, v in ipairs(self.belegar_ghost_agents) do
						cm:spawn_unique_agent_at_region(faction:command_queue_index(), v, faction:home_region():cqi(), true)
					end
				end
			end,
			false
		)
	end
end


--------------------------------------------
-------- Generation Functions --------------
--------------------------------------------


function book_of_grudges:generate_grudge_points_for_faction(faction_interface, cqi, type, opt_grudge_value, opt_factor_type)
	local mf_list = faction_interface:military_force_list()
	local region_list = faction_interface:region_list()
	local grudge_points_to_add = opt_grudge_value or self.base_grudge_points

	local culture_modifier = self.grudge_culture_modifiers[faction_interface:culture()]
	if culture_modifier ~= nil then
		if culture_modifier == "high" then
			grudge_points_to_add = grudge_points_to_add * self.grudge_culture_modifier_value_high
		elseif culture_modifier == "medium" then
			grudge_points_to_add = grudge_points_to_add * self.grudge_culture_modifier_value_medium
		end
	end

	local factor_type = self.grudge_factors[opt_factor_type] or self.grudge_factors[FACTOR_TYPE.BASE]
	local factor_armies = factor_type.army
	local factor_settlements = factor_type.settlement

	-- Iterate through each list and add grudge points to each entity CQI of that faction
	for i = 0, mf_list:num_items() - 1 do
		local mf_item = mf_list:item_at(i)
		-- add additional grudge points for specific army performing the action
		if type == cqi_type.mf and mf_item:command_queue_index() == cqi then
			cm:entity_add_pooled_resource_transaction(mf_item, factor_armies, grudge_points_to_add)
		end
		if not mf_item:is_armed_citizenry() then
			cm:entity_add_pooled_resource_transaction(mf_item, factor_armies, grudge_points_to_add)
		end
	end

	for i = 0, region_list:num_items() - 1 do
		local region_item = region_list:item_at(i)
		cm:entity_add_pooled_resource_transaction(region_item, factor_settlements, grudge_points_to_add)
	end
end


function book_of_grudges:remove_grudge_points_for_faction(faction_interface)
	local mf_list = faction_interface:military_force_list()
	local region_list = faction_interface:region_list()

	for i = 0, mf_list:num_items() - 1 do
		local mf_item = mf_list:item_at(i)
		local grudge_resource = mf_item:pooled_resource_manager():resource(self.grudges_pr_key_enemy_army)
		if not grudge_resource:is_null_interface() then
			self:modify_grudge_value(mf_item, grudge_resource, self.grudge_enemy_army_factors_to_keys, true)
		end
	end

	for i = 0, region_list:num_items() - 1 do
		local region_item = region_list:item_at(i)
		local grudge_resource = region_item:pooled_resource_manager():resource(self.grudges_pr_key_enemy_settlement)
		if not grudge_resource:is_null_interface() then
			self:modify_grudge_value(region_item, grudge_resource, self.grudge_settlement_factors_to_keys, true)
		end
	end
end


function book_of_grudges:generate_grudge_points_for_region(region_interface, factor, points_to_add)
	cm:entity_add_pooled_resource_transaction(region_interface, factor, points_to_add)
end


function book_of_grudges:get_unit_pack_list()
	local pack_list = {}
	for i = 1, self.unit_packs.pack_amount do
		table.insert(pack_list, tostring(self.unit_packs.pack_key .. i))
	end

	return pack_list
end


-- Lock confederations for human dwarf players so that you can't confederate other human dwarf factions in multiplayer
function book_of_grudges:lock_dwarf_faction_confederations_for_human_players()
	local model = cm:model():world()
	for _,v in ipairs(self.lock_faction_sets) do
		lock_factions = model:lookup_factions_from_faction_set(v)
		for _, faction in model_pairs(lock_factions) do
			if not faction:is_null_interface() then
				if faction:is_human() then
					local confed_data = self.faction_confederation_data[faction:name()]
					cm:lock_ritual(faction, confed_data.ritual)
				end
			end
		end
	end
end


function book_of_grudges:scale_confederation_cost_based_on_owned_settlements(faction_interface)
	local current_bundle = self:get_faction_bundle_by_key(faction_interface, self.confederation_cost_scale_bundle_key)
	local effects_to_new_values = {}
	
	if current_bundle then
		local active_effects = current_bundle:effects()
		for i = 0, active_effects:num_items() - 1 do
			local active_effect = active_effects:item_at(i)
			local active_effect_key = active_effect:key()
			local faction = self:get_faction_from_effect_key(active_effect_key)
			local scaled_cost_mod = self:get_settlement_count_for_ritual_faction(faction) * self.percent_scale_cost_per_settlement
			effects_to_new_values[active_effect_key] = scaled_cost_mod
		end
	end

	local bundle_to_apply = cm:create_new_custom_effect_bundle(self.confederation_cost_scale_bundle_key)
	local new_effects = bundle_to_apply:effects()

	for i = 0, new_effects:num_items() - 1 do
		local new_effect = new_effects:item_at(i)
		local new_effect_key = new_effect:key()

		if effects_to_new_values[new_effect_key] then
			bundle_to_apply:set_effect_value(new_effect, effects_to_new_values[new_effect_key])
		else
			bundle_to_apply:set_effect_value(new_effect, 0)
		end
	end

	bundle_to_apply:set_duration(0)
	cm:apply_custom_effect_bundle_to_faction(bundle_to_apply, faction_interface)
end


function book_of_grudges:get_faction_from_effect_key(effect_key)
	for _,v in ipairs(self.confederation_factions_list) do
		if self.faction_confederation_data[v].cost_mod_effect == effect_key then
			return v
		end
	end
	return false
end


function book_of_grudges:get_settlement_count_for_ritual_faction(faction)
	local settlement_count = 0
	local target_faction = cm:get_faction(faction)
	if not target_faction:is_null_interface() then
		settlement_count = target_faction:region_list():num_items()
	end
	return settlement_count
end

--------------------------------------------
----------- Grudge Listeners ---------------
--------------------------------------------

function book_of_grudges:setup_dilemma_listeners()
	local earned_grudges = self.dilemma_data.grudge_points_earned
	-- Earning many grudge points
	core:add_listener(
		earned_grudges.dilemma_type,
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() and self:is_off_cooldown(earned_grudges, faction:name()) then
						local pr = context:resource()
						return pr:key() == self.grudges_pr_key and pr:value() >= self.dilemma_grudges_earned_threshold
					end
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction():name()
			local dilemma_data = self.dilemma_data.grudge_points_earned
			self:setup_dilemma(dilemma_data, faction)
			self:set_cooldown_timer(earned_grudges.dilemma_type, dilemma_data.cooldown_time, faction)
		end,
		true
	)

	local threshold_reached = self.dilemma_data.enemy_army_reaches_threshold
	-- Enemy army reaches threshold
	core:add_listener(
		threshold_reached.dilemma_type,
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() and self:is_off_cooldown(threshold_reached, faction:name()) then
						local factions_at_war = faction:factions_at_war_with()
						for i = 0, factions_at_war:num_items() - 1 do
							local enemy_faction = factions_at_war:item_at(i)
							return self:has_army_above_threshold(enemy_faction, self.dilemma_enemy_army_grudges_earned_threshold)
						end
					end
				end
			end
			return false
		end,
		function(context)
			local dilemma_data = self.dilemma_data.enemy_army_reaches_threshold
			local faction = context:faction()
			local factions_at_war = faction:factions_at_war_with()
			local faction_name = faction:name()
			for i = 0, factions_at_war:num_items() - 1 do
				local enemy_faction = factions_at_war:item_at(i)
				if self:has_army_above_threshold(enemy_faction, self.dilemma_enemy_army_grudges_earned_threshold) then
					local force_target = self:get_army_above_threshold(enemy_faction, self.dilemma_enemy_army_grudges_earned_threshold)
					
					self:setup_dilemma(dilemma_data, faction_name, force_target)
					self:set_cooldown_timer(threshold_reached.dilemma_type, dilemma_data.cooldown_time, faction_name)
				end
			end
		end,
		true
	)

	local incurs_grudge = self.dilemma_data.neutral_faction_incurs_grudge
	-- faction incurs a grudge
	core:add_listener(
		incurs_grudge.dilemma_type,
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					return faction:is_contained_in_faction_set(v) and faction:is_human() and self:is_off_cooldown(incurs_grudge, faction:name())
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			local dilemma_data = self.dilemma_data.neutral_faction_incurs_grudge
			local faction_target = self:get_known_neutral_faction_target(faction)
			if faction_target ~= false then
				self:setup_dilemma(dilemma_data, faction_name, faction_target)
				self:set_cooldown_timer(incurs_grudge.dilemma_type, dilemma_data.cooldown_time, faction_name)
			end
		end,
		true
	)

	local bad_grudging = self.dilemma_data.lack_of_grudges_gained
	-- Not completing grudges enough
	core:add_listener(
		bad_grudging.dilemma_type,
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() and self:is_off_cooldown(bad_grudging, faction:name()) then
						self.grudge_pr_tracker = cm:get_saved_value(self.grudge_pr_tracker_save_key) or {}
						local faction_name = faction:name()
						if self.grudge_pr_tracker[faction_name] == nil then
							self.grudge_pr_tracker[faction_name] = {}
						end

						local turn_number = cm:turn_number()
						table.insert(self.grudge_pr_tracker[faction_name], turn_number, {0})
						cm:set_saved_value(self.grudge_pr_tracker_save_key, self.grudge_pr_tracker)

						return self:hasnt_earned_enough_grudge_points(faction, self.dilemma_not_enough_grudges_earned_threshold)
					end
				end
			end
			return false
		end,
		function(context)
			local faction_name = context:faction():name()
			local dilemma_data = self.dilemma_data.lack_of_grudges_gained
			self:setup_dilemma(dilemma_data, faction_name)
			self:set_cooldown_timer(bad_grudging.dilemma_type, dilemma_data.cooldown_time, faction_name)
		end,
		true
	)

	local bad_grudging_turn_start_track = self.dilemma_data.lack_of_grudges_gained.dilemma_type .. "_turn_start_tracking"
	-- Turn start pr tracking 
	core:add_listener(
		bad_grudging_turn_start_track,
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					return faction:is_contained_in_faction_set(v) and faction:is_human()
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction():name()
			self:track_grudge_points_earned_per_faction(faction)
		end,
		true
	)

	local bad_grudging_pr_track = self.dilemma_data.lack_of_grudges_gained.dilemma_type .. "_pr_tracking"
	-- Track Earned grudge points
	core:add_listener(
		bad_grudging_pr_track,
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						return context:resource():key() == self.grudges_pr_key
					end
				end
			end
			return false
		end,
		function(context)
			local pr_value = context:amount()
			local faction = context:faction():name()
			self:track_grudge_points_earned_per_faction(faction, pr_value)
		end,
		true
	)
end

--------------------------------------------
----------- Grudge Dilemmas ----------------
--------------------------------------------

function book_of_grudges:setup_dilemma(dilemma_data, faction, opt_target_interface)
	local dilemma_key = dilemma_data.dilemma_key_start .. tostring(cm:random_number(dilemma_data.dilemma_count))

	local dilemma = cm:create_dilemma_builder(dilemma_key)
	local setup_choice_trigger_effects = false
	for i = 1, dilemma_data.dilemma_option_count do
		local dilemma_payload = cm:create_payload()
		local option_data = dilemma_data.options_data[OPTION_CHOICE[i]]

		if option_data.effect_list ~= nil then
			local chosen_reward = option_data.effect_list[cm:random_number(#option_data.effect_list)]
			self:setup_payload(dilemma_payload, chosen_reward, option_data.custom_effect_bundle, opt_target_interface, faction)

			dilemma:add_choice_payload(OPTION_CHOICE[i], dilemma_payload)
		end

		if option_data.choice_trigger_effects ~= nil then
			setup_choice_trigger_effects = true
		end
	end

	if setup_choice_trigger_effects then
		-- Trigger the associated scripted mission
		core:add_listener(
			dilemma_key,
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma():starts_with(dilemma_key)
			end,
			function(context)
				local faction_name = context:faction():name()
				if context:choice() == 0 then
					local choice_data = dilemma_data.options_data[OPTION_CHOICE[1]]
					if choice_data.choice_trigger_effects ~= nil then
						local choice_trigger_setup = choice_data.choice_trigger_effects
						if choice_trigger_setup.mission_to_trigger ~= nil then
							cm:trigger_mission(faction_name, choice_trigger_setup.mission_to_trigger, true)
						elseif choice_trigger_setup.type ~= nil and choice_trigger_setup.type == "war" then
							self:generate_grudge_points_for_faction(opt_target_interface, nil, nil, choice_trigger_setup.grudge_value)
							cm:force_declare_war(opt_target_interface:name(), faction_name, false, false)
						end
					end
				elseif context:choice() == 1 then
					local choice_data = dilemma_data.options_data[OPTION_CHOICE[2]]
					if choice_data.choice_trigger_effects ~= nil then
						local choice_trigger_setup = choice_data.choice_trigger_effects
						if choice_trigger_setup.mission_to_trigger ~= nil then
							cm:trigger_mission(faction_name, choice_trigger_setup.mission_to_trigger, true)
						elseif choice_trigger_setup.type ~= nil and choice_trigger_setup.type == "grudges" then
							if choice_trigger_setup.target == "faction" then
								self:generate_grudge_points_for_faction(opt_target_interface, nil, nil, choice_trigger_setup.grudge_value)
							elseif choice_trigger_setup.target == "force" then
								cm:entity_add_pooled_resource_transaction(opt_target_interface, self.grudges_factor_junction_enemy_armies, choice_trigger_setup.grudge_value)
							end
						end
					end
				end
			end,
			false
		)
	end

	if opt_target_interface ~= nil then
		dilemma:add_target("target_faction_1", opt_target_interface)
		dilemma:add_target("target_faction_2", opt_target_interface)
		dilemma:add_target("target_faction_3", opt_target_interface)
		dilemma:add_target("default", opt_target_interface)
		dilemma:add_target("mission_objective", opt_target_interface)
	end
	cm:launch_custom_dilemma_from_builder(dilemma, cm:get_faction(faction))
end

--------------------------------------------
------------ Helper Functions --------------
--------------------------------------------


function book_of_grudges:is_item_in_list(item, list)
	for i = 1, #list do
		if item == list[i] then return true end
	end
	return false
end


function book_of_grudges:get_faction_bundle_by_key(faction_interface, bundle_key)
	local effect_bundle_list = faction_interface:effect_bundles()

	for i = 0, effect_bundle_list:num_items() - 1 do
		local effect_bundle = effect_bundle_list:item_at(i)

		if effect_bundle:key() == bundle_key then
			return effect_bundle
		end
	end
end


function book_of_grudges:has_army_above_threshold(faction_interface, threshold)
	local f = faction_interface:name()
	local mf_list = faction_interface:military_force_list()

	for i = 0, mf_list:num_items() - 1 do
		local mf_item = mf_list:item_at(i)
		if not mf_item:is_armed_citizenry() then
			local pr = mf_item:pooled_resource_manager():resource(self.grudges_pr_key_enemy_army)
			if not pr:is_null_interface() then
				local v = pr:value()
				return pr:value() >= threshold
			end
		end
	end
	return false
end


function book_of_grudges:get_army_above_threshold(faction_interface, threshold)
	local mf_list = faction_interface:military_force_list()

	for i = 0, mf_list:num_items() - 1 do
		local mf_item = mf_list:item_at(i)
		if not mf_item:is_armed_citizenry() then
			local pr = mf_item:pooled_resource_manager():resource(self.grudges_pr_key_enemy_army)
			if not pr:is_null_interface() then
				if pr:value() >= threshold then
					return mf_item
				end
			end
		end
	end
	return false
end


function book_of_grudges:get_known_neutral_faction_target(faction_interface)
	local factions_met = faction_interface:factions_met()
	for _ = 0, factions_met:num_items() - 1 do
		local random_fact_num = cm:random_number(factions_met:num_items()) - 1
		local faction = factions_met:item_at(random_fact_num)
		if not faction:is_null_interface() and not faction:at_war_with(faction_interface) and faction:culture() ~= self.grudge_culture and faction:region_list():num_items() > 0 then
			return faction
		end
	end
	return false
end


function book_of_grudges:generate_pooled_resource_payload_string(pooled_resource_payload)
	local key = pooled_resource_payload.key
	local factor =pooled_resource_payload.factor
	local amount = pooled_resource_payload.amount

	return "faction_pooled_resource_transaction{resource "..key..";factor "..factor..";amount "..amount..";context absolute;}"
end


function book_of_grudges:is_off_cooldown(dilemma_info, faction_name)
	local turn_time_save = "turn_time_save_"..dilemma_info.dilemma_type .. faction_name
	local turn_time = cm:get_saved_value(turn_time_save) or 0

	if cm:is_new_game() then
		turn_time = dilemma_info.initial_turn_cooldown
	end

	turn_time = turn_time - 1
	cm:set_saved_value(turn_time_save, turn_time)
	return turn_time <= 0
end


function book_of_grudges:set_cooldown_timer(listener_key, cooldown_time , faction_name)
	local turn_time_save = "turn_time_save_"..listener_key .. faction_name
	cm:set_saved_value(turn_time_save, cooldown_time)
	self:set_global_cooldown_delay(faction_name)
end


function book_of_grudges:set_global_cooldown_delay(faction_name)
	local global_time_delay = 5
	local dilemma_types = {
		self.dilemma_data.grudge_points_earned.dilemma_type,
		self.dilemma_data.enemy_army_reaches_threshold.dilemma_type,
		self.dilemma_data.lack_of_grudges_gained.dilemma_type,
		self.dilemma_data.neutral_faction_incurs_grudge.dilemma_type,
	}

	for i = 1, #dilemma_types do
		local turn_time_save = "turn_time_save_".. dilemma_types[i] .. faction_name
		local turn_time = cm:get_saved_value(turn_time_save) or 0
		turn_time = turn_time + global_time_delay
		cm:set_saved_value(turn_time_save, turn_time)
	end
end


function book_of_grudges:setup_payload(dilemma_payload, chosen_reward, custom_effect_bundle, opt_target_interface, opt_dwf_faction_name)
	if chosen_reward.type == "treasury" then
		dilemma_payload:treasury_adjustment(chosen_reward.value)

	elseif chosen_reward.type == "oathgold" then
		dilemma_payload:faction_pooled_resource_transaction("dwf_oathgold", "dwf_oathgold_missions", chosen_reward.value, false)

	elseif chosen_reward.type == "mercenary" then
		dilemma_payload:add_mercenary_to_faction_pool(chosen_reward.mercenary, chosen_reward.merc_amount)
		local effect_bundle = cm:create_new_custom_effect_bundle(custom_effect_bundle)
		effect_bundle:set_duration(10)
		effect_bundle:add_effect(chosen_reward.key, chosen_reward.scope, chosen_reward.value)
		dilemma_payload:effect_bundle_to_faction(effect_bundle)

	elseif chosen_reward.type == "effect_bundle" then
		local effect_bundle = cm:create_new_custom_effect_bundle(custom_effect_bundle)
		effect_bundle:set_duration(10)
		effect_bundle:add_effect(chosen_reward.key, chosen_reward.scope, chosen_reward.value)
		dilemma_payload:effect_bundle_to_faction(effect_bundle)

	elseif chosen_reward.type == "premade_effect_bundle" then
		local effect_bundle = cm:create_new_custom_effect_bundle(custom_effect_bundle)
		effect_bundle:set_duration(10)
		dilemma_payload:effect_bundle_to_faction(effect_bundle)
	end


	if chosen_reward.oathgold_cost ~= nil then
		dilemma_payload:faction_pooled_resource_transaction("dwf_oathgold", "grudges", chosen_reward.oathgold_cost, true)
	end
end


function book_of_grudges:track_grudge_points_earned_per_faction(faction, pr_value)
	local turn_number = cm:turn_number()
	pr_value = pr_value or 0
	self.grudge_pr_tracker = cm:get_saved_value(self.grudge_pr_tracker_save_key) or {}

	if self.grudge_pr_tracker[faction] == nil then
		self.grudge_pr_tracker[faction] = {}
	end

	table.insert(self.grudge_pr_tracker[faction], turn_number, {0})

	local faction_pr_array = self.grudge_pr_tracker[faction]
	table.insert(faction_pr_array[turn_number], pr_value)

	cm:set_saved_value(self.grudge_pr_tracker_save_key, self.grudge_pr_tracker)
end


function book_of_grudges:hasnt_earned_enough_grudge_points(faction_interface, threshold)
	self.grudge_pr_tracker = cm:get_saved_value(self.grudge_pr_tracker_save_key) or {}
	local faction_name = faction_interface:name()
	local faction_track = self.grudge_pr_tracker[faction_name]
	local current_turn_number = cm:turn_number()
	
	if faction_track == nil or current_turn_number <= 6 then
		return false
	end

	local pr_earned = 0
	for i = (current_turn_number - 6), current_turn_number do
		if faction_track[i] ~= nil then
			for _,v in ipairs(faction_track[i]) do
				if v > 0 then
					pr_earned = pr_earned + v
				end
			end
		end
	end

	return pr_earned < threshold
end


function book_of_grudges:get_characters_in_faction_regions(faction_interface)
	local character_list = {}
	local region_list = faction_interface:region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local region_chars = region:characters_in_region()
		for j = 0, region_chars:num_items() - 1 do
			local char = region_chars:item_at(j)
			if char:has_military_force() and char:faction():name() ~= faction_interface:name() then
				table.insert(character_list, char)
			end
		end
	end
	return character_list
end


function book_of_grudges:get_raiding_characters(faction, charater_list)
	local raiding_characters = {}
	for i = 1, #charater_list do
		local char = charater_list[i]
		local char_faction = char:faction()
		if char_faction:culture() ~= self.grudge_culture and char_faction:name() ~= faction:name() then
			local stance = char:military_force():active_stance()
			if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
				table.insert(raiding_characters, char)
			end
		end
	end
	return raiding_characters
end


function book_of_grudges:get_trespassing_characters(faction, charater_list)
	local trespassing_characters = {}
	for i = 1, #charater_list do
		local char = charater_list[i]
		local char_faction = char:faction()
		if char_faction:culture() ~= self.grudge_culture and char_faction:name() ~= faction:name() then
			local stance = char:military_force():active_stance()
			if faction:military_access_pact_with(char_faction) == false and stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
				table.insert(trespassing_characters, char)
			end
		end
	end
	return trespassing_characters
end


function book_of_grudges:is_faction_being_raided(faction)
	local characters_in_regions_list = self:get_characters_in_faction_regions(faction)
	local raid = self:get_raiding_characters(faction, characters_in_regions_list)
	return #raid >= 1
end


function book_of_grudges:faction_has_tresspassers(faction)
	local characters_in_regions_list = self:get_characters_in_faction_regions(faction)
	return #self:get_trespassing_characters(faction, characters_in_regions_list) >= 1
end


function book_of_grudges:generate_grudges_for_not_dwarf_owned_dwarf_settlements(opt_ignore_pr_value)
	-- Setup starting grudges for dwarf settlements not owned by dwarf culture
	local dwarf_regions = self.dwarf_culture_regions[cm:get_campaign_name()]
	for i = 1, #dwarf_regions do
		local region_interface = cm:get_region(dwarf_regions[i])
		local name = region_interface:name()
		if not region_interface:is_null_interface() then
			local culture = region_interface:owning_faction():culture()
			if region_interface:owning_faction():culture() ~= self.grudge_culture then				
				if opt_ignore_pr_value then
					self:generate_grudge_points_for_region(region_interface, self.grudge_factors[FACTOR_TYPE.NOT_DWARF_OWNED].settlement, self.not_owned_region_grudge_value)
				else
					local pr = region_interface:pooled_resource_manager():resource(self.grudges_pr_key_enemy_settlement)
					if not pr:is_null_interface() then
						local value = pr:value()
						if pr:value() <= 0 then
							self:generate_grudge_points_for_region(region_interface, self.grudge_factors[FACTOR_TYPE.NOT_DWARF_OWNED].settlement, self.not_owned_region_grudge_value)
						end
					end
				end
			end
		end
	end
end


function book_of_grudges:modify_grudge_value(interface, grudge_resource, factors_to_keys, remove_value)
	local pr_factors = grudge_resource:factors()
	for j = 0, pr_factors:num_items() - 1 do
		local factor = pr_factors:item_at(j)
		local factor_key = factors_to_keys[factor:key()]
		local value = factor:value()
		if remove_value then
			value = -value
		end
		if factor_key then
			cm:entity_add_pooled_resource_transaction(interface, factor_key, value)
		else
			script_error("Dwarf Grudges: factor doesn't exist in "  .. tostring(factors_to_keys) .." table in wh3_campaign_grudge.lua when removing grudges")
		end
	end
end