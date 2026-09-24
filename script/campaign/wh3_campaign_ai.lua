-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--	CAMPAIGN AI SCRIPT
--	This script contains a wide variety of functions which affect AI behaviour, which aren't specifically related to another script. Some are only active on the RoC map and some are only 
--  active on IE, while others are active on both maps, so please take care	that you are targetting the correct combination of maps when modifying this script. 
--
--  Handles the following parts of the CAI behaviour:
--  - Adjusting strategic threat based on the number of souls gathered
--  - Norsca VS Cathay bastion AI logic
--  - First Turn behaviour for AI major factions in the IE map
--  - Functions to improve chaos dwarf occupation logic
-- 	- Functions to trigger the AI has got a bunch of settlements incidents and give the victory effect bundles to those factions.
--	- Handles the application of customization options
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

campaign_ai_script = {
	script_triggered_settlement_attack = false,
	soul_threat_modifier = 100,

	chaos_bastion_related_factions_list = {
		"wh3_main_rogue_kurgan_warband",
		"wh3_main_cth_celestial_loyalists",
		"wh3_main_cth_imperial_wardens",
		"wh3_main_cth_the_jade_custodians",
		"wh3_main_cth_the_northern_provinces",
		"wh3_main_cth_the_western_provinces",
	},
	chaos_bastions_list = {
		"wh3_main_chaos_region_dragon_gate",
		"wh3_main_chaos_region_snake_gate",
		"wh3_main_chaos_region_turtle_gate",
	},
	soul_keys = {
		"wh3_main_realm_complete_khorne",
		"wh3_main_realm_complete_nurgle",
		"wh3_main_realm_complete_slaanesh",
		"wh3_main_realm_complete_tzeentch",
	},
	chaos_dwarf_primary_building_chain_keys = {
		outpost = "wh3_dlc23_chd_settlement_outpost",
		factory = "wh3_dlc23_chd_settlement_factory",
		tower = "wh3_dlc23_chd_settlement_tower",
	},
	short_victory_ai_factions = {},
	long_victory_ai_factions = {},
	MaxDistance = 5000,
	FactionToFactionsDiscovered = {},
	FactionToCoordinates = {},
	FactionToCoordinatesIterator = 1,

	background_income_data = {
		-- KISLEV --
		-- KATARINA --
		wh3_main_ksl_the_ice_court = {
				effects = {
					{
						key = "wh3_main_effect_ksl_ice_court_support_faction",
						amount = 10,
						effect_scope = "faction_to_faction_own"
				},
			},
			bundle_key = "wh3_main_ksl_background_support_income_hidden",
			},
		-- KOSTALTYN --
		wh3_main_ksl_the_great_orthodoxy = {
				effects = {
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 10,
						effect_scope = "faction_to_faction_own"
					}
			},
			bundle_key = "wh3_main_ksl_background_support_income_hidden",
			},
		-- BORIS URSUS
		wh3_main_ksl_ursun_revivalists = {
				effects = {
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
				},
			},
			bundle_key = "wh3_main_ksl_background_support_income_hidden",
			},
		-- MOTHER OSTAMKYA --
		wh3_dlc24_ksl_daughters_of_the_forest = {
				effects = {
					{
						key = "wh3_main_effect_ksl_ice_court_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
					},
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
					},
		},
		bundle_key = "wh3_main_ksl_background_support_income_hidden",
	},
		-- HIGH ELVES --
		-- AISLINN --
		wh3_dlc27_hef_aislinn = {
		effects = {
			{
				key = "wh3_dlc27_effect_hef_aislinn_focus_ai_only",
				amount = 100,
				effect_scope = "faction_to_faction_own"
			},
			{
				key = "wh3_dlc27_effect_hef_aislinn_naval_supplies_ai_only",
				amount = 150,
				effect_scope = "faction_to_faction_own"
			},
			{
				key = "wh3_dlc27_effect_hef_aislinn_dragonship_growth_ai_only",
				amount = 8,
				effect_scope = "faction_to_force_own"
			},
		},
		bundle_key = "wh3_dlc27_hef_aislinn_background_ai_extra_resources_hidden",
	},
		-- TECLIS --
		wh2_main_hef_order_of_loremasters = {
		effects = {
			{
				key = "wh3_dlc27_effect_hef_teclis_scrolls_of_knowledge_ai_only",
				amount = 100,
				effect_scope = "faction_to_faction_own"
			},
		},
		bundle_key = "wh3_dlc27_hef_teclis_background_ai_extra_resources_hidden",
	},
		-- NORSCA --
		-- THROG --
		wh_dlc08_nor_wintertooth = {
		effects = {
			{
				key = "wh3_dlc27_effect_nor_throgg_kinfolk_ai_only", 
				amount = 7,
				effect_scope = "faction_to_faction_own"
			},
		},
			bundle_key = "wh3_dlc27_nor_throgg_background_ai_extra_resources_hidden",
	},
		-- SLAANESH --
		-- DECHALA --
		wh3_dlc27_sla_the_tormentors = {
		effects = {
			{
				key = "wh3_dlc27_effect_sla_dechala_thralls_ai_only", 
				amount = 220,
				effect_scope = "faction_to_faction_own"
			},
		},
			bundle_key = "wh3_dlc27_sla_dechala_background_ai_extra_resources_hidden",
	},
		-- EMPIRE --
		-- BORIS TODBRINGER --
		wh_main_emp_middenland = {
			effects = {
				{
					key = "wh3_dlc29_effect_emp_boris_todbringer_fervour_income_ai_only", 
					amount = 100,
					effect_scope = "faction_to_faction_own"
				},
			},
			bundle_key = "wh3_dlc29_emp_boris_todbringer_background_ai_extra_resources_hidden",
		},
		-- NAGASH --
		wh3_dlc29_nag_host_of_nagash = {
			effects = {
				{
					key = "wh3_dlc29_effect_nag_ritual_discount_ai_only",
					amount = 100,
					effect_scope = "faction_to_faction_own"
				},
			},
			bundle_key = "wh3_dlc29_nag_background_ai_extra_bonuses_hidden",
		},
	},

	-- background incomes whose amount scales with campaign difficulty, one entry per resource
	difficulty_scaled_background_incomes = {
		vmp_power = {
			factions = {
				"wh_main_vmp_schwartzhafen",			-- VLAD
				"wh3_main_vmp_caravan_of_blue_roses",	-- GHORST
				"wh3_dlc29_vmp_neferata",				-- NEFERATA
				"wh2_dlc11_vmp_the_barrow_legion",		-- KEMLER
				"wh_main_vmp_vampire_counts",			-- MANNFRED
			},
			effect_key = "wh3_dlc29_effect_vmp_power_ai_only",
			effect_scope = "faction_to_faction_own",
			bundle_key = "wh3_dlc29_vmp_background_ai_extra_resources_hidden",
			-- keyed by combined_difficulty_level(): 1 = easy, 0 = normal, -1 = hard, -2 = very hard, -3 = legendary
			amount_by_difficulty = {
				[1] = 200,
				[0] = 300,
				[-1] = 400,
				[-2] = 500,
				[-3] = 600,
			},
			-- on top of the difficulty amount, the income grows as the campaign progresses
			turn_scaling = {
				turn_interval = 10,
				amount_per_interval = 50,
			},
		},
	},

	ai_minor_faction_potential = {
		target_potential_types = {
			combi_minor_strong = 40,
			combi_minor_survivor = 40,
			minor = -25,
			minor_weak = -25,
			minor_strong = 50,
		},
	},
	ai_extra_aggro = {
		target_global_script_context = "cai_global_script_context_special_1",
	},
	sayl_difficulty_level_restrictred_rituals = {
		ritual_list = {
			"wh3_dlc27_sayl_manipulations_force_bundle",
			"wh3_dlc27_sayl_manipulations_force_damage",
			"wh3_dlc27_sayl_manipulations_force_movement",
			"wh3_dlc27_sayl_manipulations_force_rebel",
			"wh3_dlc27_sayl_manipulations_region_destroy",
			"wh3_dlc27_sayl_manipulations_region_foreign",
			"wh3_dlc27_sayl_manipulations_region_garrison",
		},
		min_difficulty = -1, -- HARD and above, -2 is VERY HARD, -3 is LEGENDARY
	},

	bhashiva_potential_overrides = {
		faction_key = "wh3_cp1_cth_tiger_warriors",
		potential_data = {
			{
				faction_key = "wh3_main_cth_the_western_provinces",
				override_amount = 210
			}
		}
	},
	
	nagash_background_income = {
		factor = "buildings",
		-- keyed by combined_difficulty_level(): 1 = easy, 0 = normal, -1 = hard, -2 = very hard, -3 = legendary
		base_amount = {
			[1] = 50,
			[0] = 100,
			[-1] = 150,
			[-2] = 200,
			[-3] = 250,
		},
		amount_per_bracket = 50,
		turns_per_bracket = 10,
	},
	woc_upgrading_scaling = {
		factions = {
			wh_main_chs_chaos = true,
			wh3_dlc20_chs_azazel = true,
			wh3_main_chs_shadow_legion = true,
			wh3_dlc20_chs_festus = true,
			wh3_dlc20_chs_kholek = true,
			wh3_dlc20_chs_sigvald = true,
			wh3_dlc20_chs_valkia = true,
			wh3_dlc20_chs_vilitch = true,
			wh3_dlc29_chs_host_of_the_triplets = true,
		},
		turn_start = 5,
		scaling_data  = {
			-- keyed by combined_difficulty_level(): 1 = easy, 0 = normal, -1 = hard, -2 = very hard, -3 = legendary
			-- (verified 2026-08-15 that autoruns return the same scale as player runs; cm:get_difficulty() does NOT, its autorun branch misreads this scale)
			--LEGENDARY
			[-3] = {
				effects = {
					{
						key = "wh3_dlc20_effect_unit_upgrade_cost",
						amount = -70,
						effect_scope = "faction_to_force_own_unseen"
					},
					{
						key = "wh3_dlc20_effect_increased_rank_woc_recruitment_panel", 
						amount = 7,
						effect_scope = "faction_to_force_own_unseen"
					},
				},
				bundle_key = "wh3_dlc29_woc_ai_all_upgrade_scaling_hidden",
			},
			--VERY HARD
			[-2] = {
				effects = {
					{
						key = "wh3_dlc20_effect_unit_upgrade_cost",
						amount = -60,
						effect_scope = "faction_to_force_own_unseen"
					},
					{
						key = "wh3_dlc20_effect_increased_rank_woc_recruitment_panel", 
						amount = 5,
						effect_scope = "faction_to_force_own_unseen"
					},
				},
				bundle_key = "wh3_dlc29_woc_ai_all_upgrade_scaling_hidden",
			},
			--HARD
			[-1] = {
				effects = {
					{
						key = "wh3_dlc20_effect_unit_upgrade_cost",
						amount = -50,
						effect_scope = "faction_to_force_own_unseen"
					},
					{
						key = "wh3_dlc20_effect_increased_rank_woc_recruitment_panel", 
						amount = 3,
						effect_scope = "faction_to_force_own_unseen"
					},
				},
				bundle_key = "wh3_dlc29_woc_ai_all_upgrade_scaling_hidden",			
			},
			--NORMAL
			[0] = {
				effects = {
					{
						key = "wh3_dlc20_effect_unit_upgrade_cost",
						amount = -40,
						effect_scope = "faction_to_force_own_unseen"
					},
					{
						key = "wh3_dlc20_effect_increased_rank_woc_recruitment_panel", 
						amount = 2,
						effect_scope = "faction_to_force_own_unseen"
					},
				},
				bundle_key = "wh3_dlc29_woc_ai_all_upgrade_scaling_hidden",
			},
			--EASY
			[1] = {
				effects = {
					{
						key = "wh3_dlc20_effect_unit_upgrade_cost",
						amount = -30,
						effect_scope = "faction_to_force_own_unseen"
					},
					{
						key = "wh3_dlc20_effect_increased_rank_woc_recruitment_panel", 
						amount = 1,
						effect_scope = "faction_to_force_own_unseen"
					},
				},
				bundle_key = "wh3_dlc29_woc_ai_all_upgrade_scaling_hidden",
			},
		},
	},
	woc_technology_auto_research = {
		factions = {
			wh_main_chs_chaos = true,
			wh3_dlc20_chs_azazel = true,
			wh3_main_chs_shadow_legion = true,
			wh3_dlc20_chs_festus = true,
			wh3_dlc20_chs_kholek = true,
			wh3_dlc20_chs_sigvald = true,
			wh3_dlc20_chs_valkia = true,
			wh3_dlc20_chs_vilitch = true,
			wh3_dlc29_chs_host_of_the_triplets = true,
		},
		technology_to_auto_research_turns = {
			-- turn = {tech_1, tech_2 ...}
			[7] = {
				"wh3_dlc20_chs_und_shared_chariots",
				"wh3_dlc20_chs_und_shared_chosen",
				"wh3_dlc20_chs_und_shared_mutants",
			},
			[11] = {
				"wh3_dlc20_chs_und_shared_daemonic_mounts",
				"wh3_dlc20_chs_und_shared_knights",
			},
			[15] = {
				"wh3_dlc20_chs_und_shared_marks_khorne",
				"wh3_dlc20_chs_und_shared_marks_tzeentch",
				"wh3_dlc20_chs_und_shared_marks_slaanesh",
				"wh3_dlc20_chs_und_shared_marks_nurgle",

			},
			[19] = {
				"wh3_dlc20_chs_kho_valkia_gift_slot_1",
			},
			[22] = {
				"wh3_dlc29_chs_glottkin_festus_shared_upgrades"
			},
			[23] = {
				"wh3_dlc20_chs_nur_warriors_gift_slot_1",
				"wh3_dlc20_chs_kho_archaon_gift_slot_1",
				"wh3_dlc20_chs_sla_warriors_gift_slot_1",
				"wh3_main_chs_belakor_1",
				"wh3_main_chs_belakor_2",
				"wh3_main_chs_belakor_3",
				"wh3_main_chs_belakor_4",
			},
			[24] = {
				"wh3_dlc20_chs_sla_azazel_gift_slot_1",
			},
		}
	},
}

function campaign_ai_script:setup_listeners()
	
	-- ====================== COMBI ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_combi" then
		core:add_listener(
			--Force the AI to embed its starting hero (if it has one) and then force it to attack the closest army, then give control back to the AI. 
			"AIGameStartHeroEmbed",
			"FactionBeginTurnPhaseNormal",
			function(context)
				--Skips the human factions
				local faction = context:faction()
				return cm:turn_number() == 1 and not faction:is_human() and faction:is_contained_in_faction_set("all_vanilla_playable_factions")
			end,
			function(context)
				local faction = context:faction()
				local faction_name = faction:name()
				cm:cai_set_global_script_context("cai_global_script_context_alpha")
				cm:cai_disable_movement_for_faction(faction_name)
				self:embed_starting_hero(faction)
				self:fight_starting_battles(faction)
				cm:cai_enable_movement_for_faction(faction_name)
			end, 
			true
		)

		core:add_listener(
			--When the AI attacks a settlement, force it immediately to launch the attack, unless we caused it to attack a settlement earlier.
			"AIGameStartForceSiegeAttack",
			"CharacterBesiegesSettlement",
			function(context)
				--Skips the human factions
				local faction = context:character():faction()
				return cm:turn_number() == 1 and not faction:is_human() and faction:is_contained_in_faction_set("all_vanilla_playable_factions")
			end,
			function(context)
				if not self.script_triggered_settlement_attack then
					local character = context:character()
					cm:attack_region(cm:char_lookup_str(character), character:region():name())
				end
				self.script_triggered_settlement_attack = false
			end,
			true
		)

		core:add_listener(
			"AICleanUp", 
			"WorldStartRound", 
			function()
				return cm:turn_number() > 1
			end,
			function()
				core:remove_listener("AIGameStartHeroEmbed")
				core:remove_listener("AIGameStartForceSiegeAttack")
				cm:cai_clear_global_script_context()
			end,
			false
		)

		core:add_listener(
			"AIRegonCountForFauxVictory",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return not faction:is_human() and not faction:is_vassal() and not faction:is_rebel() and faction:region_list():num_items() >= 25
			end,
			function(context)
				self:process_faux_victory(context:faction())
			end,
			true
		)

		core:add_listener(
			"AIGolgfagWarDeclaration",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return cm:turn_number() == 1 and faction:name() == "wh3_dlc26_ogr_golgfag" and not faction:is_human()
			end,
			function(context)
				-- the diplomacy AI takes a while to do this, so we force it instead
				cm:force_declare_war("wh3_dlc26_ogr_golgfag", "wh_main_emp_nordland", false, false)
				core:remove_listener("AIGolgfagWarDeclaration")
			end,
			true
		)

		core:add_listener(
			"Sayl_PoolResCheckAIUnlocks",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:name() == sayl_manipulation.config.faction_key and not faction:is_human()
			end,
			function(context)
				-- AI sayl handles thing slightly differently - no missions, just unlocks manipulation rituals based on region count
				local sayl_faction = context:faction()
				local difficulty = cm:model():combined_difficulty_level()

				for level,tier_config in dpairs(sayl_manipulation.config.ritual_unlock_levels) do
					if sayl_faction:region_list():num_items() >= tier_config.ai_region_count then
						local ritual_list = tier_config.rituals
						for i = 1, #ritual_list do
							local current_ritual = ritual_list[i]
							local difficulty_restricted = table.contains(campaign_ai_script.sayl_difficulty_level_restrictred_rituals.ritual_list, current_ritual)
							
							if (difficulty_restricted == false) or (difficulty_restricted and difficulty <= campaign_ai_script.sayl_difficulty_level_restrictred_rituals.min_difficulty) then
								cm:unlock_ritual(sayl_faction, current_ritual, 0)
							end
						end
					end
				end
			end,
			true
		)

		core:add_listener(
			"AIDechalaTechnologyDaemonicUnitsUnlock",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return not faction:is_human() and faction:name() == dechala_daemonic_units.config.faction_key and cm:turn_number() >= dechala_daemonic_units.config.ai_unlock_turn
			end,
			function(context)
				cm:instantly_research_technology(dechala_daemonic_units.config.faction_key, dechala_daemonic_units.config.technology_key, false)
				for _, unit_key in ipairs(dechala_daemonic_units.config.units) do
					cm:remove_event_restricted_unit_record_for_faction(unit_key, dechala_daemonic_units.config.faction_key)
				end
			end,
			true
		)

		core:add_listener(
			"AIGlottkinTurnEndGardens",
			"FactionTurnEnd",
			function(context)
				local faction = context:faction()
				return faction:name() == glottkin_gardens_of_nurgle.config.faction_key and not faction:is_human()
			end,
			function(context)
				local faction = context:faction()
				-- we want to attempt to create a garden every turn
				self:glottkin_garden_of_nurgle_create_garden(faction)
				-- moving should occur once every 12 turns - this is enough time for a full cycle of the recruitment buildings
				if cm:turn_number() % 12 == 0 then
					self:glottkin_garden_of_nurgle_check_settlements_and_move_gardens(faction)
				end
			end,
			true
		)

		core:add_listener(
			"AINagashNecromanticEnergyIncome",
			"FactionTurnStart",
			function(context)
				local faction_interface = context:faction()
				return not faction_interface:is_human() and faction_interface:name() == land_of_the_dead.faction_key
			end,
			function(context)
				local manager = cm:model():world():region_group_pooled_resource_managers_system():get_dynamic_manager_for_region_group_id(land_of_the_dead.region_group_id)
				if manager and not manager:is_null_interface() then
					local resource = manager:resource(land_of_the_dead.pooled_resource_key)
					local config = self.nagash_background_income
					-- combined_difficulty_level() returns the same scale in player runs and autoruns; do not switch to cm:get_difficulty(), whose autorun branch misreads it
					local base = config.base_amount[cm:model():combined_difficulty_level()] or config.base_amount[0]
					local brackets = math.floor((cm:turn_number() - 1) / config.turns_per_bracket)
					cm:pooled_resource_factor_transaction(resource, config.factor, base + brackets * config.amount_per_bracket)
				end
			end,
			true
		)

		core:add_listener(
			"AIWoCFactionsUpgradeScalingOnTurnStart",
			"FactionTurnStart",
			function(context)
				return self.woc_upgrading_scaling.factions[context:faction():name()]
			end,
			function(context)
				local faction_interface = context:faction()
				if faction_interface:is_human() then
					-- the scaling is AI-only, so strip it if the faction has come under player control
					for difficulty, data in dpairs(self.woc_upgrading_scaling.scaling_data) do
						cm:remove_effect_bundle(data.bundle_key, faction_interface:name())
					end
				else
					campaign_ai_script:apply_woc_upgrade_scaling(faction_interface)
				end
			end,
			true
		)

		core:add_listener(
			"AIWoCFactionsUpgradeScalingOnDifficultyChange",
			"NominalDifficultyLevelChangedEvent", 
			true,
			function(context)
				local factions_list = self.woc_upgrading_scaling.factions
				for key, _ in dpairs(factions_list) do
					local faction_interface = cm:get_faction(key)
					if faction_interface and not faction_interface:is_human() then
						-- remove any old bundles, cannot rely on all difficulties using the same bundle key and apply removing the old version
						for difficulty, data in dpairs(self.woc_upgrading_scaling.scaling_data) do
							cm:remove_effect_bundle(data.bundle_key, key)
						end
						campaign_ai_script:apply_woc_upgrade_scaling(faction_interface)
					end
				end
			end,
			true
		)

		core:add_listener(
			"AIWoCFactionsTechnologies", 
			"FactionTurnEnd",
			function(context)
				local faction_interface = context:faction()
				return not faction_interface:is_human() and self.woc_technology_auto_research.factions[faction_interface:name()]
			end, 
			function(context)
				local technologies_for_turn = self.woc_technology_auto_research.technology_to_auto_research_turns[cm:turn_number()]
				if technologies_for_turn and not table.is_empty(technologies_for_turn) then
					for i = 1, #technologies_for_turn do
						local technology_key = technologies_for_turn[i]
						cm:instantly_research_technology(context:faction():name(), technology_key, false)
					end
				end
			end,
			true
		)
	end	

	-- ====================== CHAOS ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_chaos" then
		out.design("Initial Bastion state check");
		if self:count_standing_bastions() ~= #self.chaos_bastions_list then
			out.design("============== Campaign started with at least razed Bastion settlement, switching related AI factions to appropriate context ==============")
			self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
		end;
		
		out.design("===== CHAOS VS CATHAY BASTION SETUP =====");
		-- BASTION RAZED
		core:add_listener(
			"bastion_settlement_razed",
			"CharacterRazedSettlement",
			function(context)
				local region_name = context:garrison_residence():region():name()
				return cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") ~= "cai_faction_script_context_special_2" and (region_name == "wh3_main_chaos_region_dragon_gate" or region_name == "wh3_main_chaos_region_snake_gate" or region_name == "wh3_main_chaos_region_turtle_gate")
			end,
			function(context)
				--If the Kurgan Warband is not already in "special_2" context, switch to it; Same with Cathay factions
				out.design("============== Bastion settlement razed script running ==============")
				--Kurgan Warband now switches to "free for all" mode, Cathay factions try to capture back the gates
				out.design("============== Bastion settlement was destroyed, related factions will now be set to cai_faction_script_context_special_2 context ==============")
				self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
			end,
			true
		)
		
		-- BASTION COLONISED
		core:add_listener(
			"bastion_settlement_colonised",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local settlement_option = context:settlement_option()
				local region_name = context:garrison_residence():region():name()
				-- Check number of "standing" gates, if it's N-1, then change the context back to default
				return cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") ~= "cai_faction_script_context_type_default" and (settlement_option == "occupation_decision_colonise" or settlement_option == "occupation_decision_resettle") and (region_name == "wh3_main_chaos_region_dragon_gate" or region_name == "wh3_main_chaos_region_snake_gate" or region_name == "wh3_main_chaos_region_turtle_gate") and self:count_standing_bastions() == #self.chaos_bastions_list
			end,
			function(context)
				out.design("============== Bastion settlement colonised script running ==============")
				out.design("============== Bastion settlement was colonised, checking if all bastions are standing ==============")
				out.design("============== No more ruined gates, related factions will now be set to default faction context ==============")
				self:set_bastion_related_factions_to_context("cai_faction_script_context_type_default")
			end,
			true
		)
		
		-- FACTION TURN START - update threat score penalty for souls
		out.design("===== THREAT INCREASE FOR EACH SOUL SETUP =====")
		core:add_listener(
			"update_threat_score_for_souls",
			"FactionTurnStart",
			function(context)
				return context:faction():can_be_human() -- this should filter for only major factions
			end,
			function(context)
				local faction = context:faction()
				-- run a function that counts souls
				local soul_cnt = self:count_souls_for_faction(faction)
				if soul_cnt > 0 then
					-- set threat level modifier based on souls
					local modifier = soul_cnt * self.soul_threat_modifier
					out.design("============== Updated base threat score for faction: "..faction:name().." == "..modifier.."  ==============")
					cm:set_base_strategic_threat_score(faction, modifier)
				end
			end,
			true
		)
	end

	-- ====================== LISTENERS IN BOTH CAMPAIGNS ================ --
	core:add_listener(
		"update_chd_factory_outpost_ratio",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:subculture() == "wh3_dlc23_sc_chd_chaos_dwarfs" and not faction:is_human() and faction:can_be_human()
		end,
		function(context)
			self:calculate_and_set_chaos_dwarf_building_ratios(context:faction())
		end,
		true
	)

	core:add_listener(
		"AINearbyDiplomaticContact",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return not faction:is_rebel() and not faction:is_human()
		end,
		function(context)
			self:nearby_diplomatic_contact(context:faction())
		end,
		true
	)
	
	core:add_listener(
		"AINearbyDiplomaticContactRest",
		"WorldStartRound",
		true,
		function()
			self.FactionToCoordinates = {}
			self.FactionToCoordinatesIterator = 1
		end,
		true
	)	
end 

-- ================================= IE GAME START RELATED FUNCTIONS ================================= --
function campaign_ai_script:embed_starting_hero(faction)
	local list = faction:military_force_list()
	for i = 0, list:num_items() - 1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false then
			local general = force:general_character()

			local character, x = cm:get_closest_hero_to_position_from_faction(faction, general:logical_position_x(), general:logical_position_y())
			if character and character:is_null_interface() == false and character:is_embedded_in_military_force() == false then
				cm:embed_agent_in_force(character, force)
			end
		end
	end
end

function campaign_ai_script:fight_starting_battles(faction)
	local list = faction:military_force_list()
	local enemy_faction_list = faction:factions_at_war_with() 

	for i = 0, list:num_items() - 1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false and force:has_garrison_residence() == false then
			local general = force:general_character()

			local enemy_force, in_range = self:find_correct_enemy_force(force, enemy_faction_list, general:logical_position_x(), general:logical_position_y())
			if in_range == false then --If no enemy army is in range this turn then we break and allow the AI to get on with the rest of its turn 
				break
			end
			cm:attack_queued(cm:char_lookup_str(general), cm:char_lookup_str(enemy_force:general_character()))
			out.design("Our force " .. common.get_localised_string(general:get_forename()) .. " is attacking an enemy army led by ".. common.get_localised_string(enemy_force:general_character():get_forename()))
		end
	end
end

function campaign_ai_script:find_correct_enemy_force(our_force, enemy_faction_list, x, y)
	local enemy_force = nil
	for i = 0, enemy_faction_list:num_items() - 1 do
		enemy_force = cm:get_closest_military_force_from_faction(enemy_faction_list:item_at(i):name(), x, y, true)
		if is_militaryforce(enemy_force) then
			if enemy_force:is_armed_citizenry() == false then
				if cm:character_can_reach_character(our_force:general_character(), enemy_force:general_character()) == true then
					if enemy_force:has_garrison_residence() == true then
						self.script_triggered_settlement_attack = true
					end
					return enemy_force, true
				end
			elseif cm:character_can_reach_settlement(our_force:general_character(), enemy_force:garrison_residence():settlement_interface()) == true then
				self.script_triggered_settlement_attack = true
				return enemy_force, true
			end
		end
	end
	return enemy_force, false
end

-- ================================= BASTION RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_standing_bastions()
	local cnt = 0
	
	for i, v in pairs(self.chaos_bastions_list) do
		-- Get region by name, check if it's not a ruin
		local region = cm:get_region(v)
		if region and not region:is_abandoned() then
			cnt = cnt + 1
		end
	end
	
	return cnt
end

function campaign_ai_script:set_bastion_related_factions_to_context(target_context)
	for i, faction_key in pairs(self.chaos_bastion_related_factions_list) do
		if cm:get_faction(faction_key) then
			cm:cai_set_faction_script_context(faction_key, target_context)
			out.design("============== This faction: "..faction_key.." is now using this context: "..cm:cai_get_faction_script_context(faction_key).." ==============")
		end
	end
end

-- ================================= SOULS RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_souls_for_faction(faction)
	local cnt = 0

	for i = 1, #self.soul_keys do 
		if faction:pooled_resource_manager():resource(self.soul_keys[i]):is_null_interface() and faction:pooled_resource_manager():resource(self.soul_keys[i]) == 1 then
			cnt = cnt + 1
		end
	end

	return cnt
end

-- ================================= CHAOS DWARF OCCUPATION RELATED FUNCTIONS ================================= --
function campaign_ai_script:calculate_and_set_chaos_dwarf_building_ratios(faction)
	local factory_count = 0
	local outpost_count = 0
	local tower_count = 0
	local region_list = faction:region_list()

	for i = 0, region_list:num_items() - 1 do
		local building = region_list:item_at(i):settlement():primary_building_chain()
		if building == self.chaos_dwarf_primary_building_chain_keys.factory then
			factory_count = factory_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.outpost then
			outpost_count = outpost_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.tower then
			tower_count = tower_count + 1
		end
	end

	local other_count = factory_count + outpost_count

	if outpost_count == 0 then
		outpost_ratio = 0
	elseif factory_count == 0 then
		outpost_ratio = 10
	else 
		outpost_ratio = outpost_count/factory_count
	end

	if tower_count == 0 then
		tower_ratio = 0.01
	elseif other_count == 0 then
		tower_ratio = 10
	else
		tower_ratio = tower_count/other_count
	end

	outpost_ratio = outpost_ratio - 1.5 --It takes 1.5 outposts to fuel each factory, so we get a negative number if we need outposts and a positive number if we need factories, which we can use in DAVE to get the acutal occupation weights
	tower_ratio = 1 / tower_ratio

	cm:set_script_state(faction, "faction_chaos_dwarf_outpost_ratio", outpost_ratio)
	cm:set_script_state(faction, "faction_chaos_dwarf_tower_ratio", tower_ratio)
end

-- ================================= FAUX VICTORY RELATED FUNCTIONS ================================= --
function campaign_ai_script:process_faux_victory(faction)
	local faction_key = faction:name()
	
	if self.long_victory_ai_factions[faction_key] then
		return
	end
	
	local region_list = faction:region_list()
	local incident_key = "wh3_dlc24_incident_ai_faux_victory_short"
	local faction_subculture_key = faction:subculture()
	local mission_key = "wh_main_short_victory"
	local faction_alignment = victory_objectives_ie.alignments.default
	
	if region_list:num_items() >= 50 then
		incident_key = "wh3_dlc24_incident_ai_faux_victory_long"
		mission_key = "wh_main_long_victory"
		self.long_victory_ai_factions[faction_key] = true
	elseif self.short_victory_ai_factions[faction_key] then
		return
	end

	if victory_objectives_ie.subcultures[faction_subculture_key] then
		faction_alignment = victory_objectives_ie.subcultures[faction_subculture_key].alignment
	end

	local bundle = victory_objectives_ie.alignments[faction_alignment][mission_key].payload_bundle
	local ancillary = victory_objectives_ie.alignments[faction_alignment][mission_key].payload_ancillary

	if bundle then
		cm:apply_effect_bundle(bundle, faction_key, 0)
	end	
		
	if ancillary then
		if is_string(ancillary) then
			cm:add_ancillary_to_faction(faction, ancillary, true)
		elseif is_table(ancillary) then
			for i, value in ipairs(ancillary) do
				if value then
					cm:add_ancillary_to_faction(faction, value, true)
				end
			end
		end
	end
	
	local faction_cqi = faction:command_queue_index()

	for _, current_faction_met in model_pairs(faction:factions_met()) do
		if current_faction_met:is_human() then
			cm:trigger_incident_with_targets(current_faction_met:command_queue_index(), incident_key, faction_cqi, 0, 0, 0, 0, 0)
		end
	end

	self.short_victory_ai_factions[faction_key] = true
end

-- ========================================= DIPLOMATIC CONTACT RELATED FUNCTIONS =========================== --

function campaign_ai_script:nearby_diplomatic_contact(faction)
	local counter = 0
	local region_list = faction:region_list()
	local military_force_list = faction:military_force_list()
	if region_list:num_items() > 0 then
		for j = 0, region_list:num_items() - 1 do
			local Current = {}
			table.insert(Current, faction:name())
			local CurrentX, CurrentY = cm:settlement_logical_pos(region_list:item_at(j):settlement():key())
			table.insert(Current, CurrentX)
			table.insert(Current, CurrentY)
			table.insert(self.FactionToCoordinates,	Current)
			counter = counter + 1
		end
	end
	if military_force_list:num_items() > 0 then
		for j = 0, military_force_list:num_items() - 1 do
			local force = military_force_list:item_at(j)
			
			if not force:is_armed_citizenry() and not force:has_garrison_residence() and force:has_general() then
				local general_character = force:general_character()
				
				if general_character:has_region() then
					local region = general_character:region()
					
					if not region:is_abandoned() and region:owning_faction() ~= faction then
						local Current = {}							--If a force is in a region owned by its faction then we ignore it as the the setttlement will be close enough, and ignoring these forces will be a huge performance gain
						table.insert(Current, faction:name())
						local CurrentX, CurrentY = cm:char_logical_pos(force:general_character())
						table.insert(Current, CurrentX)
						table.insert(Current, CurrentY)
						table.insert(self.FactionToCoordinates,	Current)
						counter = counter + 1
					end
				end
			end
		end
	end

	for i = self.FactionToCoordinatesIterator, #self.FactionToCoordinates do
		local SourceData = self.FactionToCoordinates[i]
		local Source = SourceData[1]
		for j = 1, #self.FactionToCoordinates do 
			TargetData = self.FactionToCoordinates[j]
			Target = TargetData[1]
			if self.FactionToFactionsDiscovered[Source..Target] == nil and Source ~= Target then	
				if distance_squared(SourceData[2], SourceData[3], TargetData[2], TargetData[3]) < self.MaxDistance then
					self.FactionToFactionsDiscovered[Source..Target] = true 										
					self.FactionToFactionsDiscovered[Target..Source] = true
					cm:make_diplomacy_available(Source, Target)
				end
			end
		end
	end
	self.FactionToCoordinatesIterator = self.FactionToCoordinatesIterator + counter
end

-- ========================================= BACKGROUND INCOMES ========================================= --

function campaign_ai_script:start_background_incomes()
	local data_table = self.background_income_data
	for faction_key, faction_data in dpairs(data_table) do
		local faction = cm:get_faction(faction_key)
		
		if faction and not faction:is_human() then 
			local bundle = cm:create_new_custom_effect_bundle(faction_data.bundle_key)
			if bundle:is_null_interface() then
				script_error("ERROR: campaign_ai_script:start_background_incomes failed to create custom effect bundle for faction with key [" .. faction_key .. "] and bundle key [" .. faction_data.bundle_key .. "]")
			else
				for _, effect in ipairs(faction_data.effects) do
					bundle:add_effect(effect.key, effect.effect_scope, effect.amount)
				end
				cm:apply_custom_effect_bundle_to_faction(bundle, faction)
			end
		end
	end

	for resource_key, income_data in dpairs(self.difficulty_scaled_background_incomes) do
		self:apply_difficulty_scaled_background_income(resource_key, income_data)
	end
end

-- (Re)applies the background income bundle for one difficulty_scaled_background_incomes entry. The amount is the difficulty
-- base plus, if turn_scaling is set, an increase of amount_per_interval for every turn_interval turns elapsed. Reapplying the
-- custom bundle with the same key replaces the previous one, so this can be called again as the campaign progresses.
function campaign_ai_script:apply_difficulty_scaled_background_income(resource_key, income_data)
	local difficulty = cm:model():combined_difficulty_level()
	local amount = income_data.amount_by_difficulty[difficulty]
	if not amount then
		script_error("ERROR: campaign_ai_script:apply_difficulty_scaled_background_income found no [" .. resource_key .. "] income amount for difficulty level [" .. tostring(difficulty) .. "]")
		return
	end

	local turn_scaling = income_data.turn_scaling
	if turn_scaling then
		amount = amount + math.floor(cm:turn_number() / turn_scaling.turn_interval) * turn_scaling.amount_per_interval
	end

	for _, faction_key in ipairs(income_data.factions) do
		local faction = cm:get_faction(faction_key)

		if faction and not faction:is_human() then
			local bundle = cm:create_new_custom_effect_bundle(income_data.bundle_key)
			if bundle:is_null_interface() then
				script_error("ERROR: campaign_ai_script:apply_difficulty_scaled_background_income failed to create custom effect bundle for faction with key [" .. faction_key .. "] and bundle key [" .. income_data.bundle_key .. "]")
			else
				bundle:add_effect(income_data.effect_key, income_data.effect_scope, amount)
				cm:apply_custom_effect_bundle_to_faction(bundle, faction)
			end
		end
	end
end

function campaign_ai_script:apply_woc_upgrade_scaling(faction)
	-- the scaling is strictly AI-only, never apply it to a player-controlled faction
	if faction:is_human() then
		return
	end
	-- combined_difficulty_level() returns the same scale in player runs and autoruns; do not switch to cm:get_difficulty(), whose autorun branch misreads it
	local difficulty = cm:model():combined_difficulty_level()
	local scaling_data = self.woc_upgrading_scaling.scaling_data[difficulty]
	if not scaling_data or self.woc_upgrading_scaling.turn_start > cm:turn_number() then
		return
	end
	if faction:has_effect_bundle(scaling_data.bundle_key) then
		return
	end
	local bundle = cm:create_new_custom_effect_bundle(scaling_data.bundle_key)
	if bundle:is_null_interface() then
		script_error("ERROR: campaign_ai_script:apply_woc_upgrade_scaling failed to create custom effect bundle for faction with key [" .. faction:name() .. "] and bundle key [" .. scaling_data.bundle_key .. "]")
	else
		for _, effect in ipairs(scaling_data.effects) do
			bundle:add_effect(effect.key, effect.effect_scope, effect.amount)
		end
		cm:apply_custom_effect_bundle_to_faction(bundle, faction)
	end
end

-- ========================================= GLOTTKIN GARDENS ==================================== --

function campaign_ai_script:glottkin_garden_of_nurgle_score_region(region)
	local score = 0
	local settlement = region:settlement()
	local settlement_type = settlement:settlement_type_key()
	local building_level = settlement:primary_slot():building():building_level()

	if settlement_type == glottkin_gardens_of_nurgle.config.dark_fortress_settlement_type_key then
		-- we want to convert high level fortresses
		score = score + (building_level * 100) 
	else
		-- if no fortresses are available we still want to convert, just less so
		score = score + building_level * 10
	end

	-- we want to convert highly corrupted regions, so we increase the score based on corruption value
	score = score + cm:get_corruption_value_in_province(region:province(), "wh3_main_corruption_nurgle")
	
	return score
end

function campaign_ai_script:glottkin_garden_of_nurgle_create_garden(faction)
	local num_gardens = faction:num_settlements_of_owning_limit_group(glottkin_gardens_of_nurgle.config.owning_limit_group_key)
	local gardens_limit = faction:max_settlements_of_owning_limit_group(glottkin_gardens_of_nurgle.config.owning_limit_group_key)
	out("num settlements is " .. num_gardens .. " and limit is " .. gardens_limit)

	if num_gardens < gardens_limit then
		-- find the most suitable settlement to convert to garden
		local best_region = nil
		local best_region_score = 0
		local region_list = faction:region_list()
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)
			local settlement_type = region:settlement():settlement_type_key()
			
			if settlement_type ~= glottkin_gardens_of_nurgle.config.major_garden_key and settlement_type ~= glottkin_gardens_of_nurgle.config.minor_garden_key then
				local region_score = self:glottkin_garden_of_nurgle_score_region(region)
				if region_score > best_region_score then
					best_region_score = region_score
					best_region = region
				end
			end
		end

		if best_region then
			local modify_ritual_setup = cm:create_new_ritual_setup(faction, glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key)
			if not modify_ritual_setup then
				script_error("ERROR: Failed to create ritual setup for ritual with key [" .. glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key .. "]")
				return
			end
			local modify_ritual_target = modify_ritual_setup:target()
			if modify_ritual_target:is_region_valid_target(best_region) then
				modify_ritual_target:set_target_region(best_region)
			end

			if modify_ritual_target:valid() then
				cm:perform_ritual_with_setup(modify_ritual_setup)
			end
		end
	end
end

function campaign_ai_script:glottkin_garden_of_nurgle_check_settlements_and_move_gardens(faction)
	local lowest_level_minor_garden = 6
	local lowest_level_minor_garden_region = nil
	local highest_level_fortress = 0
	local highest_level_fortress_region = nil
	local region_list = faction:region_list()
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local settlement_type = region:settlement():settlement_type_key()
		local building_level = region:settlement():primary_slot():building():building_level()
		if settlement_type == glottkin_gardens_of_nurgle.config.dark_fortress_settlement_type_key then
			if building_level > highest_level_fortress then
				highest_level_fortress = building_level
				highest_level_fortress_region = region
			end
		elseif settlement_type == glottkin_gardens_of_nurgle.config.minor_garden_key then
			if building_level < lowest_level_minor_garden then
				lowest_level_minor_garden = building_level
				lowest_level_minor_garden_region = region
			end
		end
	end

	if lowest_level_minor_garden_region and highest_level_fortress_region and (highest_level_fortress >= lowest_level_minor_garden) then

		local modify_ritual_setup = cm:create_new_ritual_setup(faction, glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key)
		if not modify_ritual_setup then
			script_error("ERROR: Failed to create ritual setup for ritual with key [" .. glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key .. "]")
			return
		end
		local modify_ritual_target = modify_ritual_setup:target()
		if modify_ritual_target:is_region_valid_target(highest_level_fortress_region) then
			modify_ritual_target:set_target_region(highest_level_fortress_region)
		end

		if modify_ritual_target:valid() then
			cm:reset_settlement_type(lowest_level_minor_garden_region:settlement(), "wh3_dlc29_chs_altar", lowest_level_minor_garden)
			cm:perform_ritual_with_setup(modify_ritual_setup)
		end
	end
end

-- ========================================= CUSTOMIZATION =========================== --

cm:add_first_tick_callback(
	function()
		local ssm = cm:model():shared_states_manager()
		local minor_potential = ssm:get_state_as_bool_value("ai_minor_faction_potential")

		if minor_potential == false then
			local faction_list = cm:get_faction_list()
			local config = campaign_ai_script.ai_minor_faction_potential
			for i = 0, faction_list:num_items() - 1 do
				local faction = faction_list:item_at(i)
				local override_amount = config.target_potential_types[faction:faction_potential_type()]
				if not faction:is_human() and not faction:is_rebel() and is_number(override_amount) then
					cm:faction_set_total_potential_override_value(faction, true, override_amount)
				end
			end
		end

		local extra_aggro = ssm:get_state_as_bool_value("ai_extra_aggro")
		if extra_aggro == true then
			local config = campaign_ai_script.ai_extra_aggro
			cm:cai_set_global_script_context(config.target_global_script_context)
		end

		-- If player is Bhashiva, modify the potentials of the listed factions.
		local bhashiva_faction = cm:get_faction(campaign_ai_script.bhashiva_potential_overrides.faction_key)
		if bhashiva_faction and bhashiva_faction:is_human() then
			for i, data in ipairs(campaign_ai_script.bhashiva_potential_overrides.potential_data) do
				local curr_faction = cm:get_faction(data.faction_key)
				if curr_faction and not curr_faction:is_human() then
					cm:faction_set_total_potential_override_value(curr_faction, true, data.override_amount)
				end
			end
		end

		-- grow the turn-scaled background incomes every turn_interval turns by reapplying their bundles with the new amount
		core:add_listener(
			"AITurnScaledBackgroundIncomes",
			"WorldStartRound",
			function()
				return cm:turn_number() > 1
			end,
			function()
				for resource_key, income_data in dpairs(campaign_ai_script.difficulty_scaled_background_incomes) do
					local turn_scaling = income_data.turn_scaling
					if turn_scaling and cm:turn_number() % turn_scaling.turn_interval == 0 then
						campaign_ai_script:apply_difficulty_scaled_background_income(resource_key, income_data)
					end
				end
			end,
			true
		)
	end
)
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("AIFactiontoFactionContact", campaign_ai_script.FactionToFactionsDiscovered, context)
		cm:save_named_value("FactionToCoordinatesIterator", campaign_ai_script.FactionToCoordinatesIterator, context)
		cm:save_named_value("FactionToCoordinates", campaign_ai_script.FactionToCoordinates, context)
		cm:save_named_value("short_victory_ai_factions", campaign_ai_script.short_victory_ai_factions, context)
		cm:save_named_value("long_victory_ai_factions", campaign_ai_script.long_victory_ai_factions, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if (cm:is_new_game() == false) then
			campaign_ai_script.FactionToFactionsDiscovered = cm:load_named_value("AIFactiontoFactionContact", campaign_ai_script.FactionToFactionsDiscovered, context)
			campaign_ai_script.FactionToCoordinate = cm:load_named_value("FactionToCoordinates", campaign_ai_script.FactionToCoordinates, context)
			campaign_ai_script.FactionToCoordinatesIterator =  cm:load_named_value("FactionToCoordinatesIterator", campaign_ai_script.FactionToCoordinatesIterator, context)
			campaign_ai_script.short_victory_ai_factions = cm:load_named_value("short_victory_ai_factions", campaign_ai_script.short_victory_ai_factions, context)
			campaign_ai_script.long_victory_ai_factions = cm:load_named_value("long_victory_ai_factions", campaign_ai_script.long_victory_ai_factions, context)
		end
	end
)