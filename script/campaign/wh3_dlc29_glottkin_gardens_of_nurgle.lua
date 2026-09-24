glottkin_gardens_of_nurgle_config = {
	faction_key = "wh3_dlc29_chs_host_of_the_triplets",

	nurgle_corruption_key = "wh3_main_corruption_nurgle",
	nurgle_corruption_threshold = 75,
	plague_cooldown_bonus_corruption = 2,
	plague_cooldown_decrease_key = "wh3_dlc29_glottkin_plague_creation_cooldown_reduction",
	plague_cooldown_decrease_when_marked_key = "wh3_dlc29_glottkin_plague_creation_cooldown_reduction_marked_effects",
	plague_cooldown_increase_key = "wh3_dlc29_glottkin_plague_creation_cooldown_increase",

	major_garden_key = "wh3_dlc29_woc_glottkin_garden_of_nurgle_major",
	minor_garden_key = "wh3_dlc29_woc_glottkin_garden_of_nurgle_minor",
	owning_limit_group_key = "wh3_dlc29_woc_glottkin_garden_of_nurgle_owning_limit",
	plague_upgrade_building_chain_key = "wh3_dlc29_bch_woc_nurgle_garden_plagues_mod",
	dark_fortress_settlement_type_key = "wh3_dlc29_chs_dark_fortress",
	tech_garden_tier_improvement_key = "wh3_dlc29_chs_und_glottkin_building",
	garden_conversion_ritual_key = "wh3_dlc29_woc_glottking_convert_settlement_to_garden",

	major_garden_building_levels = {
		"wh3_dlc29_settlement_woc_nurgle_garden_1",
		"wh3_dlc29_settlement_woc_nurgle_garden_2",
		"wh3_dlc29_settlement_woc_nurgle_garden_3",
		"wh3_dlc29_settlement_woc_nurgle_garden_4",
		"wh3_dlc29_settlement_woc_nurgle_garden_5",
	},
	minor_garden_building_levels = {
		"wh3_dlc29_settlement_woc_nurgle_garden_minor_1",
		"wh3_dlc29_settlement_woc_nurgle_garden_minor_2",
		"wh3_dlc29_settlement_woc_nurgle_garden_minor_3",
	},
	garden_occupation_option = {
		["187743477"] = "minor",	--	occupation_decision_colonise minor		
		["554730390"] = "minor",	--	occupation_decision_occupy minor		
		["914657779"] = "major",	--	occupation_decision_colonise major		
		["1982656245"] = "major",	--	occupation_decision_occupy major		
	},

	 -- The plague string will be built like prefix + symptoms + random(1, max_amount_plagues)
	garden_plague_prefix = "wh3_dlc29_woc_nurgle_garden_plague_",

	plague_default_cooldown = 6,
	max_gardens_of_nurgle = 7,
	max_gardens_of_nurgle_shared_state_name = "glottkin_max_gardens_of_nurgle",

	turns_until_plague_shared_state_name = "glottkin_turns_until_plague",
	amount_of_symptoms_shared_state_name = "glottkin_num_symptoms",
	amount_of_blessed_symptoms_shared_state_name = "glottkin_num_blessed_symptoms",
	next_plague_state_name = "glottkin_next_plague_key",

    souls_progression_pooled_resource_key = "wh3_dlc29_glott_souls",

	ui_notification_shared_state_name = "glottkin_gardens_of_nurgle_notification",

	plague_event_popup_index = 127,
	plague_event_list_only_index = 128,

	default_symptom = "a", -- If the upgrades building is not present, we always have a "a" plague to spawn.
	symptom_pools = { "a", "b" },
	blessed_symptom_pools = { "c", "d" },

	building_level_to_plague_symptoms = {
		["wh3_dlc29_woc_nurgle_garden_plagues_mod_1"] = { -- Level 0
			symptom_pool = "aa",
		},
		["wh3_dlc29_woc_nurgle_garden_plagues_mod_2"] = { -- Level 1
			symptom_pool = "aa",
		},
		["wh3_dlc29_woc_nurgle_garden_plagues_mod_3a"] = { -- Level 2a
			symptom_pool = "aab",
		},
		["wh3_dlc29_woc_nurgle_garden_plagues_mod_3b"] = { -- Level 2b
			symptom_pool = "bac",
		},
		["wh3_dlc29_woc_nurgle_garden_plagues_mod_4"] = { -- Level 3
			symptom_pool = "bacd",
		},
	},

	-- We pick a random number between 1 and max, see plagues table in db
	max_amount_plagues_per_symptoms = {
		["a"] = 7,
		["aa"] = 10,
		["aab"] = 10,
		["bac"] = 10,
		["bacd"] = 10,
	},

	-- Used for UI, these are the effects displayed in the "Generated worldwide bonuses" list
	factionwide_effects = {
		"wh3_dlc29_effect_corruption_nurgle_buildings_gardens",
		"wh3_dlc29_effect_recruitment_cap_garden_units",
		"wh3_main_effect_nur_merc_xp",
		"wh_main_effect_force_all_campaign_replenishment_rate",
		"wh3_dlc29_effect_recruitment_cost_gifted_nur", --
		"wh3_dlc29_effect_building_nurgle_garden_plague_cycle_cost_mod",
		"wh_main_effect_force_all_campaign_post_battle_loot_mod",
		"wh_main_effect_force_all_campaign_sacking_income",
		"wh_main_effect_force_stat_physical_resistance",
		"wh3_dlc25_effect_plague_lifetime_good_faction",
		"wh3_dlc29_effect_force_stat_weapon_strength_nur_daemonic_all",

	},

	plague_to_effects_setup_mapping = {
		["wh3_dlc29_woc_nurgle_garden_plague_a_1"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_1",
		["wh3_dlc29_woc_nurgle_garden_plague_a_2"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_2",
		["wh3_dlc29_woc_nurgle_garden_plague_a_3"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_3",
		["wh3_dlc29_woc_nurgle_garden_plague_a_4"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_4",
		["wh3_dlc29_woc_nurgle_garden_plague_a_5"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_5",
		["wh3_dlc29_woc_nurgle_garden_plague_a_6"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_6",
		["wh3_dlc29_woc_nurgle_garden_plague_a_7"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_a_7",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_1"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_1",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_2"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_2",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_3"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_3",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_4"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_4",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_5"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_5",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_6"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_6",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_7"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_7",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_8"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_8",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_9"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_9",
		["wh3_dlc29_woc_nurgle_garden_plague_aa_10"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aa_10",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_1"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_1",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_2"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_2",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_3"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_3",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_4"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_4",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_5"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_5",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_6"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_6",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_7"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_7",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_8"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_8",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_9"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_9",
		["wh3_dlc29_woc_nurgle_garden_plague_aab_10"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_aab_10",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_1"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_1",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_2"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_2",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_3"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_3",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_4"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_4",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_5"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_5",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_6"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_6",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_7"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_7",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_8"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_8",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_9"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_9",
		["wh3_dlc29_woc_nurgle_garden_plague_bac_10"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bac_10",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_1"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_1",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_2"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_2",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_3"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_3",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_4"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_4",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_5"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_5",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_6"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_6",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_7"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_7",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_8"] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_8",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_9" ] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_9",
		["wh3_dlc29_woc_nurgle_garden_plague_bacd_10" ] = "wh3_dlc29_woc_nurgle_garden_plagues_effects_setup_bacd_10",
	},

	narrative_glott_garden = {
		mission_key = "wh3_dlc29_woc_glottkin_narrative_glott_garden",
		override_text = {"wh3_dlc29_woc_glottkin_narrative_glott_garden_objective"},
		payload = {
			"text_display dummy_wh3_dlc29_glotts_garden",
			"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 450;context absolute;}"
		},
		entity = {
			type = "province",
			key = {	
				"wh3_main_combi_province_helspire_mountains",
				"wh3_main_combi_province_vanaheim_mountains",
				"wh3_main_combi_province_mountains_of_naglfari",
				"wh3_dlc29_combi_province_kraken_coast",
				"wh3_main_combi_province_ice_tooth_mountains",
				"wh3_main_combi_province_trollheim_mountains"
			},
		},
		objective_total = 3,
		objective_chain_key = "wh3_dlc29_bch_woc_settlement_nurgle_garden"
	},
	dilemma_assert_dominance = "wh3_dlc29_glottkin_dilemma_assert_dominance",
}

glottkin_gardens_of_nurgle_persistent = {
	region_data = {
		--[[
        region_key = {
        	current_symptoms = "",
            total_symptoms = 0,
            total_blessed_symptoms = 0,
			current_plague_turn_counter = 0,
			current_plague_cooldown_bonus = 0,
			can_spread_to_whole_province = false,
			current_plague_name =  "",
        }
        --]]
	},
	garden_in_empire_region_planted = false,
	first_garden_established = false,
	failed_to_pay_lifecycle_upkeep = false,
	plague_event_last_popup_turn = 0,
}

glottkin_gardens_of_nurgle = {} 
glottkin_gardens_of_nurgle.config = glottkin_gardens_of_nurgle_config

function glottkin_gardens_of_nurgle:initialise()
	cm:set_script_state(glottkin_gardens_of_nurgle_config.max_gardens_of_nurgle_shared_state_name, glottkin_gardens_of_nurgle_config.max_gardens_of_nurgle)

	for _, effect_key in dpairs(glottkin_gardens_of_nurgle_config.factionwide_effects) do
		cm:set_script_state("glottkin_is_factionwide_" .. effect_key, true)
	end

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_settlement_type_converted",
		"SettlementTypeConvertedEvent",
		function(context)
			local settlement_type_key = context:settlement():settlement_type_key()
			return settlement_type_key == glottkin_gardens_of_nurgle_config.major_garden_key or settlement_type_key == glottkin_gardens_of_nurgle_config.minor_garden_key
		end,
		function(context)
			local settlement = context:settlement()
			local region = settlement:region()
			local region_key = region:name()

			if not glottkin_gardens_of_nurgle_persistent.first_garden_established and not next(glottkin_gardens_of_nurgle_persistent.region_data) then
				glottkin_gardens_of_nurgle:trigger_glott_garden_mission()
				glottkin_gardens_of_nurgle_persistent.first_garden_established = true
			end

			glottkin_gardens_of_nurgle:check_glott_garden_mission_progression(settlement)

			if not glottkin_gardens_of_nurgle_persistent.garden_in_empire_region_planted and region:is_contained_in_region_group("wh3_dlc24_schemes_theatre_ie_the_empire") then
				if region:owning_faction():is_human() == true then
					cm:trigger_dilemma(glottkin_gardens_of_nurgle_config.faction_key, glottkin_gardens_of_nurgle_config.dilemma_assert_dominance)
				end
				glottkin_gardens_of_nurgle_persistent.garden_in_empire_region_planted = true
			end

			local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
			if not region_data then
				glottkin_gardens_of_nurgle:reset_region_data(region)
			end

			glottkin_gardens_of_nurgle:apply_settlement_tier_upgrade(settlement)
			region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
			glottkin_gardens_of_nurgle:set_plague_symptoms(region:garrison_residence())
			glottkin_gardens_of_nurgle:update_symptoms_shared_state(region)
			glottkin_gardens_of_nurgle:set_next_plague_name(region)
		end,
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_character_occupation_decision", 
		"CharacterPerformsSettlementOccupationDecision", 
		function(context)
			local occupation_decision = glottkin_gardens_of_nurgle_config.garden_occupation_option[context:occupation_decision()] 
			return context:character():faction():name() == glottkin_gardens_of_nurgle_config.faction_key and occupation_decision ~= nil
		end, 
		function (context)
			local settlement = context:garrison_residence():settlement_interface()
			if settlement then
				glottkin_gardens_of_nurgle:apply_settlement_tier_upgrade(settlement)
			end

			if cm:get_local_faction_name(true) == glottkin_rotborne_rituals_config.faction_key then
				-- Create the "glottkin garden planted" animation
				local ui_root = core:get_ui_root();
				-- It automatically destroys itself, so no need to destroy it later.
				ui_root:CreateComponent("dlc29_chs_planting_garden_of_nurgle_animation", "ui/Campaign UI/dlc29_chs_planting_garden_of_nurgle_animation.twui.xml");
			end
		end,
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_faction_turn_start",
		"RegionTurnStart",
		function(context)
			local region = context:region()
			local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
			return region:owning_faction():name() == glottkin_gardens_of_nurgle_config.faction_key and region_data
		end, 
		function (context) 
			local region = context:region()
			local region_name = region:name()
			local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_name]

			local current_plague_cooldown = glottkin_gardens_of_nurgle_config.plague_default_cooldown
			local garrison_residence = region:garrison_residence()
			local cooldown_increase = cm:get_regions_bonus_value(region_name, glottkin_gardens_of_nurgle_config.plague_cooldown_increase_key) or 0
			local cooldown_bonus_if_marked = cm:get_regions_bonus_value(region_name, glottkin_gardens_of_nurgle_config.plague_cooldown_decrease_when_marked_key) or 0

			-- Add the cooldown coming from the plague improvement building then substract the possible bonus from corruption
			current_plague_cooldown = current_plague_cooldown + cooldown_increase - math.abs(region_data.current_plague_cooldown_bonus) - math.abs(cooldown_bonus_if_marked)

			region_data.current_plague_turn_counter = region_data.current_plague_turn_counter + 1

			if region_data.current_plague_turn_counter >= current_plague_cooldown then
				glottkin_gardens_of_nurgle:set_plague_symptoms(garrison_residence)
				-- When applying a plague using EndOfTurn, StartOfTurn, EndOfRound listeners, the code evaluates the spreading of the plagues on faction start
				-- Hence, applying a plague this way was spreading it at the same time (from a player's p.o.v)
				-- To prevent this, we use a callback to trigger the plague after all plague spreading evaluations are done.
				cm:callback(function()				
					glottkin_gardens_of_nurgle:trigger_plague(region, region_data)
				end, 0.5)
			end 

			glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
			glottkin_gardens_of_nurgle:update_symptoms_shared_state(region)
		end,
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_faction_turn_end", 
		"FactionTurnEnd", 
		function(context)
			return context:faction():name() == glottkin_gardens_of_nurgle_config.faction_key
		end, 
		function (context) 
			for key, value in dpairs(glottkin_gardens_of_nurgle_persistent.region_data) do
				local region = cm:get_region(key)
				glottkin_gardens_of_nurgle:update_corruption_bonus(region)
			end
		end, 
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_building_completed",
		"BuildingCompleted",
		function(context)
			return context:garrison_residence():faction():name() == glottkin_gardens_of_nurgle_config.faction_key and context:building():chain() == glottkin_gardens_of_nurgle_config.plague_upgrade_building_chain_key
		end,
		function(context)
			local region = context:garrison_residence():region()
			local region_key = region:name()
			local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
			glottkin_gardens_of_nurgle:set_plague_symptoms(context:garrison_residence())
			glottkin_gardens_of_nurgle:update_symptoms_shared_state(region)
			glottkin_gardens_of_nurgle:set_next_plague_name(region)
			glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
		end,
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_building_completed_mission",
		"BuildingCompleted",
		function(context)
			return context:garrison_residence():faction():name() == glottkin_gardens_of_nurgle_config.faction_key and string.find(context:building():chain(), glottkin_gardens_of_nurgle_config.narrative_glott_garden.objective_chain_key)
		end,
		function(context)
			local settlement = context:garrison_residence():settlement_interface()
			glottkin_gardens_of_nurgle:check_glott_garden_mission_progression(settlement)
		end,
		true
	)

	core:add_listener(
		"wh3_dlc29_gardens_of_nurgle_pooled_resource_changed",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == glottkin_gardens_of_nurgle_config.nurgle_corruption_key
		end,
		function(context)
			for key, value in dpairs(glottkin_gardens_of_nurgle_persistent.region_data) do
				local region = cm:get_region(key)
				glottkin_gardens_of_nurgle:update_corruption_bonus(region)
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Gardens_Notification_Souls_Progression",
		"PooledResourceEffectChangedEvent",
		function(context)
			return context:resource():key() == glottkin_gardens_of_nurgle_config.souls_progression_pooled_resource_key
		end,
		function(context)
			cm:set_script_state(glottkin_gardens_of_nurgle_config.ui_notification_shared_state_name, true)
		end,
		true
	)

	core:add_listener(
		"Glottkin_Gardens_mission_completed_listener",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == glottkin_gardens_of_nurgle_config.narrative_glott_garden.mission_key
		end,
		function(context)
			local faction = context:faction()
			if faction:is_human() then
				cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "wh3_main_nur_inf_plaguebearers_0", 2)
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Gardens_Failed_To_Pay_Lifecycle_Upkeep",
		"FactionBuildingLifecycleUpkeepPaid",
		function(context)
			return context:faction():name() == glottkin_gardens_of_nurgle_config.faction_key
		end,
		function(context)
			-- Cyclical building transitions (and the upkeep for them) happen at end of turn.
			-- Show the message at the start of next turn, so it won't get immediately wiped.
			glottkin_gardens_of_nurgle_persistent.failed_to_pay_lifecycle_upkeep = not context:fully_paid()
		end,
		true
	)

	core:add_listener(
		"Glottkin_Gardens_Show_Failed_Upkeep_Payment_Event", 
		"FactionTurnStart", 
		function(context)
			return context:faction():name() == glottkin_gardens_of_nurgle_config.faction_key and glottkin_gardens_of_nurgle_persistent.failed_to_pay_lifecycle_upkeep
		end, 
		function(context)
			cm:show_message_event(
				glottkin_gardens_of_nurgle_config.faction_key,
				"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_garden_cycle_halte_title",
				"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_garden_cycle_halte_description",
				"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nurgle_garden_cycle_halted_secondary_details",
				false,
				1971
			)
			glottkin_gardens_of_nurgle_persistent.failed_to_pay_lifecycle_upkeep = false
		end, 
		true
	)
end

function glottkin_gardens_of_nurgle:reset_region_data(region)
	local region_key = region:name()

	glottkin_gardens_of_nurgle_persistent.region_data[region_key] = {
		current_symptoms = "",
		total_symptoms = 0,
		total_blessed_symptoms = 0,
		current_plague_turn_counter = 0,
		current_plague_cooldown_bonus = 0,
		can_spread_to_whole_province = false,
		current_plague_name = "",
	}
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.amount_of_symptoms_shared_state_name, region_data.total_symptoms)
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.amount_of_blessed_symptoms_shared_state_name, region_data.total_blessed_symptoms)
	glottkin_gardens_of_nurgle:update_corruption_bonus(region)
	glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
	glottkin_gardens_of_nurgle:set_plague_symptoms(region:garrison_residence())
	glottkin_gardens_of_nurgle:set_next_plague_name(region)
end

function glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
	local region_key = region:name()
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
	
	if not region_data then
		-- somehow we hadn't set this up. Fixing the issue by resetting the region data.
		glottkin_gardens_of_nurgle:reset_region_data(region)
		region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]
	end
	
	local cooldown_increase = cm:get_regions_bonus_value(region_key, glottkin_gardens_of_nurgle_config.plague_cooldown_increase_key) or 0
	local cooldown_decrease_if_marked = cm:get_regions_bonus_value(region, glottkin_gardens_of_nurgle_config.plague_cooldown_decrease_when_marked_key) or 0
	local current_plague_cooldown = glottkin_gardens_of_nurgle_config.plague_default_cooldown + cooldown_increase - region_data.current_plague_cooldown_bonus - math.abs(cooldown_decrease_if_marked)
	local cooldown = current_plague_cooldown - region_data.current_plague_turn_counter
	if cooldown < 1 then
		cooldown = 1
	end
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.turns_until_plague_shared_state_name, cooldown)
end

function glottkin_gardens_of_nurgle:update_corruption_bonus(region)
	local province = region:province()
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
	local corruption_value = cm:get_corruption_value_in_province(province, glottkin_gardens_of_nurgle_config.nurgle_corruption_key) or 0

	if corruption_value >= glottkin_gardens_of_nurgle_config.nurgle_corruption_threshold then
		region_data.current_plague_cooldown_bonus = glottkin_gardens_of_nurgle_config.plague_cooldown_bonus_corruption
		glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
	else
		region_data.current_plague_cooldown_bonus = 0
	end
end

function glottkin_gardens_of_nurgle:trigger_plague(target_region, region_data)
	local glottkin_faction = cm:get_faction(glottkin_gardens_of_nurgle_config.faction_key)
	local plague_name = region_data.current_plague_name
	
	-- Is this garden marked and allow spread to the whole province ?
	local regions_to_spawn_plagues = {}
	if region_data.can_spread_to_whole_province == true then 
		local province_regions = target_region:province():regions()
		for i = 0, province_regions:num_items() - 1 do
			table.insert(regions_to_spawn_plagues, province_regions:item_at(i))
		end
	else 
		table.insert(regions_to_spawn_plagues, target_region)
	end

	for i = 1, #regions_to_spawn_plagues do 
		local current_region = regions_to_spawn_plagues[i]
		local event_data = {}
		event_data.faction = glottkin_faction
		event_data.region = current_region  
		
		cm:spawn_plague_at_region(glottkin_faction, current_region, plague_name)
		core:trigger_event("GlottkinGardenSpawnedPlague", event_data)

		local current_turn = cm:turn_number()
		local should_popup = glottkin_gardens_of_nurgle_persistent.plague_event_last_popup_turn ~= current_turn

		local event_index = glottkin_gardens_of_nurgle_config.plague_event_popup_index
		if should_popup then
			glottkin_gardens_of_nurgle_persistent.plague_event_last_popup_turn = current_turn
		else
			event_index = glottkin_gardens_of_nurgle_config.plague_event_list_only_index
		end
		
		cm:show_message_event_located(
			glottkin_gardens_of_nurgle_config.faction_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_plague_cauldron_title",
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nurgle_garden_plague_spawned_description",
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_nurgle_garden_plague_spawned_secondary_details",
			current_region:settlement():logical_position_x(),
			current_region:settlement():logical_position_y(),
			true,
			event_index
		)
		
		glottkin_gardens_of_nurgle:reset_region_data(current_region)
	end
end

function glottkin_gardens_of_nurgle:set_plague_symptoms(garrison_residence)
	local symptoms = glottkin_gardens_of_nurgle_config.default_symptom

	local buidling_data = glottkin_gardens_of_nurgle:get_plague_upgrades_building_data(garrison_residence)

	if buidling_data ~= nil then
		symptoms = buidling_data.symptom_pool
	end

	local region = garrison_residence:region()
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
	region_data.total_symptoms = string.len_lua(symptoms)

	region_data.total_blessed_symptoms = 0
	for i = 1, #glottkin_gardens_of_nurgle_config.blessed_symptom_pools do
		local first_char, last_char = string.find_lua(symptoms, glottkin_gardens_of_nurgle_config.blessed_symptom_pools[i])
		if first_char then
			region_data.total_blessed_symptoms = region_data.total_blessed_symptoms + 1 
		end
	end

	region_data.total_symptoms = region_data.total_symptoms - region_data.total_blessed_symptoms
	region_data.current_symptoms = symptoms
end

function glottkin_gardens_of_nurgle:set_next_plague_name(region)
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
	local plague_prefix = glottkin_gardens_of_nurgle_config.garden_plague_prefix
	local plague_id = cm:model():random_int(1, glottkin_gardens_of_nurgle_config.max_amount_plagues_per_symptoms[region_data.current_symptoms])
	local plague_name = plague_prefix .. region_data.current_symptoms .. "_" .. plague_id

	region_data.current_plague_name = plague_name
	glottkin_gardens_of_nurgle:update_plague_name_shared_state(region)
end

function glottkin_gardens_of_nurgle:update_symptoms_shared_state(region)
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.amount_of_symptoms_shared_state_name, region_data.total_symptoms)
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.amount_of_blessed_symptoms_shared_state_name, region_data.total_blessed_symptoms)
end

function glottkin_gardens_of_nurgle:update_plague_name_shared_state(region)
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region:name()]
	cm:set_script_state(region, glottkin_gardens_of_nurgle_config.next_plague_state_name, region_data.current_plague_name .. "+" .. glottkin_gardens_of_nurgle_config.plague_to_effects_setup_mapping[region_data.current_plague_name])
end

function glottkin_gardens_of_nurgle:get_plague_upgrades_building_data(garrison_residence)
	local data = nil

	for i = 0, garrison_residence:buildings():num_items() -1 do 
		local building = garrison_residence:buildings():item_at(i)
		if building:chain() == glottkin_gardens_of_nurgle_config.plague_upgrade_building_chain_key then 
			data = glottkin_gardens_of_nurgle_config.building_level_to_plague_symptoms[building:name()]
		end
	end

	return data
end

function glottkin_gardens_of_nurgle:apply_settlement_tier_upgrade(settlement)
	if not settlement:faction():has_technology(glottkin_gardens_of_nurgle_config.tech_garden_tier_improvement_key) then 	
		return
	end

	local current_region = settlement:region()
	local slot = current_region:settlement():primary_slot()
	local current_building_level = slot:building():building_level()
	local next_building_level 

	if settlement:settlement_type_key() == glottkin_gardens_of_nurgle_config.major_garden_key then 
		if current_building_level > #glottkin_gardens_of_nurgle_config.major_garden_building_levels then 
			next_building_level = glottkin_gardens_of_nurgle_config.major_garden_building_levels[#glottkin_gardens_of_nurgle_config.major_garden_building_levels]
		else
			next_building_level = glottkin_gardens_of_nurgle_config.major_garden_building_levels[current_building_level + 1]
		end
	else
		if current_building_level > #glottkin_gardens_of_nurgle_config.minor_garden_building_levels then 
			next_building_level = glottkin_gardens_of_nurgle_config.minor_garden_building_levels[#glottkin_gardens_of_nurgle_config.minor_garden_building_levels]
		else
			next_building_level = glottkin_gardens_of_nurgle_config.minor_garden_building_levels[current_building_level + 1]
		end
	end

	cm:region_slot_instantly_upgrade_building(slot, next_building_level)
end

function glottkin_gardens_of_nurgle:set_garden_plague_spread_to_province(region_key)
	local region_data = glottkin_gardens_of_nurgle_persistent.region_data[region_key]

	if region_data then
		region_data.can_spread_to_whole_province = true
	end
end

function glottkin_gardens_of_nurgle:trigger_glott_garden_mission()

	local mission_data = glottkin_gardens_of_nurgle_config.narrative_glott_garden
	local mm = mission_manager:new(glottkin_gardens_of_nurgle_config.faction_key, mission_data.mission_key)
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key " .. mission_data.mission_key)
	local add_description =  mission_data.override_text

	if add_description then
		for i = 1, #add_description do
			mm:add_condition("override_text mission_text_text_"..add_description[i])
		end
	end
	
	if mission_data.objective_total then 
		mm:add_condition("total " .. mission_data.objective_total)
		mm:add_condition("count 0")
		mm:add_condition("count_completion")
	end

	local payloads = mission_data.payload

	if payloads then
		for i = 1, #payloads do
			mm:add_payload(payloads[i])
		end
	end

	mm:set_should_whitelist(false)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:set_should_cancel_before_issuing(false)
	mm:trigger()

	if mission_data.entity then
		local entity_table = {}
		local should_update_ui = mission_data.entity.should_update_ui or false
		if mission_data.entity.type == "region" then	
			for i, record_key in ipairs(mission_data.entity.key) do	
				table.insert(entity_table, {cm:get_region(record_key), should_update_ui})
			end
		elseif mission_data.entity.type == "province" then
			for i, record_key in ipairs(mission_data.entity.key) do	
				table.insert(entity_table, {cm:get_province(record_key), should_update_ui})
			end
		end
		if next(entity_table) then
			cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, mission_data.mission_key, entity_table)
		end
	end

	if mission_data.objective_total then
		for i = 1, #add_description do
			cm:set_scripted_mission_text(mission_data.mission_key, mission_data.mission_key, "mission_text_text_"..add_description[i], 0,  mission_data.objective_total)
		end
	end
end

function glottkin_gardens_of_nurgle:check_glott_garden_mission_progression(settlement)
	local faction = settlement:faction()

	if not cm:mission_is_active_for_faction(faction, glottkin_gardens_of_nurgle_config.narrative_glott_garden.mission_key) then
		return
	end

	if settlement:primary_slot():building():building_level() >= glottkin_gardens_of_nurgle_config.narrative_glott_garden.objective_total then
		local province_name = settlement:region():province():key()
		if table.contains(glottkin_gardens_of_nurgle_config.narrative_glott_garden.entity.key, province_name) then
			cm:complete_scripted_mission_objective(glottkin_gardens_of_nurgle_config.faction_key, glottkin_gardens_of_nurgle_config.narrative_glott_garden.mission_key, glottkin_gardens_of_nurgle_config.narrative_glott_garden.mission_key, true)
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("glottkin_gardens_of_nurgle_persistent", glottkin_gardens_of_nurgle_persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			glottkin_gardens_of_nurgle_persistent = cm:load_named_value("glottkin_gardens_of_nurgle_persistent", glottkin_gardens_of_nurgle_persistent, context)

			if not is_table(glottkin_gardens_of_nurgle_persistent.region_data) then
				glottkin_gardens_of_nurgle_persistent.region_data = {}
			end
			if not glottkin_gardens_of_nurgle_persistent.plague_event_last_popup_turn then
				glottkin_gardens_of_nurgle_persistent.plague_event_last_popup_turn = 0
			end
		end
	end
)