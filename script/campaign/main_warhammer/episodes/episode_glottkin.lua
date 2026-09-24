episode_glottkin = {
	-- Important keys
	episode_name 			= "episode_glottkin",
	episode_set 			= "glottkin_narrative",
	missions_prefix 		= "wh3_dlc29_woc_glottkin_narrative_",
	faction_key 			= "wh3_dlc29_chs_host_of_the_triplets",
	souls_pool_res 			= "wh3_dlc20_chs_souls",
	festus_faction_key 		= "wh3_dlc20_chs_festus",
 	altdorf_settlement_key 	= "wh3_main_combi_region_altdorf",
	marienburg_key 			= "wh3_main_combi_region_marienburg",
	dark_fortress 			= "wh3_dlc29_chs_dark_fortress",
	final_quest_battle_key  = "wh3_dlc29_qb_chs_glottkin_final_battle",
	empire_region_group_key	= "cai_region_hint_area_empire",

	-- Designer variables
	first_trigger_turn 				= 2,	-- When to start the whole chain
	altdorf_main_building_level 	= 5,	-- Sets the Main Building Tier for Altdorf at the start of the game
	mission_souls_spent_required	= 2500,	-- Required souls to be spent in the Blessings feature
	mission_plague_spread_objective	= 10,	-- How many plagues needs to be spread in Empire
	brasskeep_invasion_timer		= 8,
	built_garden_invasion_timer		= 5,
	optional_trigger_for_souls_spend = 500,

	-- Gardens of nurgle_glory
	garden_of_nurgle_settlement_type = "wh3_dlc29_glottkin_garden_of_nurgle",

	-- Narrative keys
	-- ACT I
	narrative_assert_dominance 		= "wh3_dlc29_woc_glottkin_narrative_assert_dominance",
	dilemma_angle_of_attack			= "wh3_dlc29_glottkin_dilemma_angle_of_attack",
	narrative_join_or_die			= "wh3_dlc29_woc_glottkin_narrative_join_or_die",
	incident_narrative_act_1 		= "wh3_dlc29_woc_glottkin_narrative_act_1",
	incident_narrative_act_2		= "wh3_dlc29_woc_glottkin_narrative_act_2",

	nurgle_garden_tier_5 = "wh3_dlc29_settlement_woc_nurgle_garden_5",
	nurgle_garden_tier_1 = "wh3_dlc29_settlement_woc_nurgle_garden_1",
	nurgle_nurgle_garden_1_buildings = {
		["wh3_dlc29_settlement_woc_nurgle_garden_1"] = true,
		["wh3_dlc29_settlement_woc_nurgle_garden_minor_1"] = true
	},

	valid_norscan_regions = {
		["wh3_main_combi_province_vanaheim_mountains"] = true,
		["wh3_main_combi_province_mountains_of_naglfari"] = true,
		["wh3_dlc29_combi_province_kraken_coast"] = true,
		["wh3_main_combi_province_helspire_mountains"] = true,
		["wh3_main_combi_province_ice_tooth_mountains"] = true,
		["wh3_main_combi_province_trollheim_mountains"] = true,
		["wh3_main_combi_province_mountains_of_hel"] = true,
	},

	-- ACT II
	narrative_doctors_orders 		= "wh3_dlc29_woc_glottkin_narrative_doctors_orders",
	pestilence_and_plagues 			= "wh3_dlc29_woc_glottkin_narrative_ruinous_pestilence_and_plagues",
	narrative_plague_fleet_assault 	= "wh3_dlc29_woc_glottkin_narrative_plague_fleet_assault",
	narrative_weaking_the_veil 		= "wh3_dlc29_woc_glottkin_narrative_weaking_the_veil",
	narrative_ruinous_reik 			= "wh3_dlc29_woc_glottkin_narrative_ruinous_reik",
	narrative_pesticide 			= "wh3_dlc29_woc_glottkin_narrative_pesticide",
	dilemma_ruinous_reik 			= "wh3_dlc29_glottkin_dilemma_ruinous_reik",
	final_mission_corrupt_altdorf 	= "wh3_dlc29_woc_glottkin_narrative_corrupt_altdorf",

	missions_required_to_end_act_1 = {
		"wh3_dlc29_woc_glottkin_narrative_assert_dominance",
		"wh3_dlc29_woc_glottkin_narrative_join_or_die",
	},

	missions_required_to_end_act_2 = {
		"wh3_dlc29_woc_glottkin_narrative_pesticide",
		"wh3_dlc29_woc_glottkin_narrative_ruinous_reik",
		"wh3_dlc29_woc_glottkin_narrative_doctors_orders",
		"wh3_dlc29_chs_glottkin_narrative_the_fall_of_altdorf",
	},

	valid_occupation_options = {
		["2035182464"] 	= true, -- wh3_dlc29_sc_chs_glottkin_occupation_decision_colonise	wh3_dlc20_dark_fortress_region_group	wh3_dlc29_woc_glottkin_garden_of_nurgle_major
		["873449976"] 	= true, -- wh3_dlc29_sc_chs_glottkin_occupation_decision_colonise	wh3_dlc20_dark_fortress_region_group	wh3_dlc29_chs_dark_fortress
		["315079436"] 	= true, -- wh3_dlc29_sc_chs_glottkin_occupation_decision_occupy		wh3_dlc20_dark_fortress_region_group	wh3_dlc29_chs_dark_fortress
		["339049739"] 	= true, -- wh3_dlc29_sc_chs_glottkin_occupation_decision_occupy		wh3_dlc20_dark_fortress_region_group	wh3_dlc29_woc_glottkin_garden_of_nurgle_major
		["201786925"]	= true, -- wh3_dlc29_sc_chs_glottkin_occupation_decision_resettle   wh3_dlc20_dark_fortress_region_group	wh3_dlc29_chs_dark_fortress
	},
	
	-- Quest Battle data
	quest_battle_fall_of_altdorf 		= "wh3_dlc29_chs_glottkin_narrative_the_fall_of_altdorf",
	brass_keep_invasion_spawn_coords 	= {{586, 723}, {590, 724}, {596, 725}},
	brass_keep_invasion_has_spawned_event_feed = false,
	garden_invasion_has_spawned_event_feed = false,
	invasions_effect_bundle_no_withdraw = "wh3_dlc29_glottkin_narrative_invasion_no_withdraw",
	
	-- TODO: enable the episode when it is working properly
	episode_disabled = false,
	
	-- Initial Setup for CAI and factions
	cai_increased_potential = 190,	 
	cai_disable_regions = {
		"settlement:wh3_main_combi_region_altdorf",
		"settlement:wh3_main_combi_region_brass_keep"
	},
	factions_increased_potential = {
		"wh_main_emp_wissenland",
		"wh_main_emp_middenland",
		"wh_main_emp_empire"
	},
	episode_active_shared_state = "episode_glottkin_active",

	enemy_invasion_brass_keep = {
		region_key = "wh3_main_combi_region_brass_keep",
		saved_value_key = "brass_keep_invasion_armies_cqi",
		faction_data = 
		{
			["brass_kislev"] = {
				amount_to_spawn = 1,
				faction_keys = {
					"wh3_main_ksl_kislev_qb1",
				},
			},
			["brass_empire"] = {
				amount_to_spawn = 2,
				faction_keys = {
					"wh_main_emp_empire_qb4",
					"wh2_dlc16_emp_empire_invasion",
				},
			},
		},
	},

	enemy_invasion_garden_of_nurgle = {
		region_key = nil,
		saved_value_key = "nurgle_garden_invasion_armies_cqi",
		faction_data = 
		{
			["garden_wood_elves"] = {
				amount_to_spawn = 1,
				faction_keys = {
					"wh2_dlc16_wef_wood_elves_qb4",
				},
			},
			["garden_empire"] = {
				amount_to_spawn = 2,
				faction_keys = {
					"wh2_dlc16_emp_empire_invasion",
					"wh_main_emp_empire_qb3",
				},
			},
		},
	},

	empire_regions_converted_to_garden = {},

	scripted_mission_data = {
		["wh3_dlc29_woc_glottkin_narrative_assert_dominance"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_assert_dominance_objective"},
			payload = {
				"money 1500",
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 200;context absolute;}",
				--"text_display dummy_wh3_dlc29_assert_dominance"
			},
			objective_cultures = {"wh_dlc08_nor_norsca"},
			objective_total = 2
		},
		["wh3_dlc29_woc_glottkin_narrative_doctors_orders"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_doctors_orders_objective"},
			payload = {
				"text_display dummy_wh3_dlc29_woc_glottkin_narrative_doctors_orders",
				"text_display dummy_wh3_dlc29_woc_glottkin_narrative_doctors_orders_fb",
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 1500;context absolute;}"
			},
			objective_total = 3,
			mission_turn_limit = 7,
			entity = {
				type = "region",
				key = {"wh3_main_combi_region_brass_keep"}
			}
		},
		["wh3_dlc29_woc_glottkin_narrative_nurgles_favoured_sons"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_nurgles_favoured_sons_objective"},
			payload = {
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 500;context absolute;}",
				"effect_bundle{bundle_key wh3_dlc29_woc_glottkon_narrative_nurgle_diplomacy_mod;turns 3;}"
			},
		},
		["wh3_dlc29_woc_glottkin_narrative_pesticide"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_pesticide_objective"},
			payload = {
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 1200;context absolute;}",
				"text_display dummy_wh3_dlc29_woc_glottkin_narrative_pesticide"
			},
			objective_total = 3,
			mission_turn_limit = 7
		},
		["wh3_dlc29_woc_glottkin_narrative_plague_fleet_assault"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_plague_fleet_assault_objective"},
			payload = {
				"effect_bundle{bundle_key wh_dlc29_woc_glottkin_effect_bundle_morale_against_empire;turns 5;}",
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 800;context absolute;}",
				"money 5000"
			},
			entity = {
				type = "region",
				key = {"wh3_main_combi_region_marienburg"}
			}
		},
		["wh3_dlc29_woc_glottkin_narrative_ruinous_pestilence_and_plagues"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_ruinous_pestilence_and_plagues_objective"},
			payload = {
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 800;context absolute;}",
				"text_display dummy_wh3_dlc29_pestilence_and_plagues"
			},
			objective_total = 10
		},
		["wh3_dlc29_woc_glottkin_narrative_ruinous_reik"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_ruinous_reik_objective"},
			payload = {
				"text_display dummy_wh3_dlc29_woc_glottkin_narrative_ruinous_reik",
				"money 5000"
			},
			objective_building_level = "wh3_dlc29_special_marienburg_port_chs_2",
			objective_provinces = {"wh3_main_combi_province_the_wasteland"}
		},
		["wh3_dlc29_woc_glottkin_narrative_weaking_the_veil"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_weaking_the_veil_objective"},
			payload = {
				"text_display dummy_wh3_dlc29_weakening_the_veil",
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 800;context absolute;}"
			},
			entity = {
				type = "province",
				key = {	
					"wh3_main_combi_province_reikland",
					"wh3_main_combi_province_the_wasteland",
					"wh3_main_combi_province_middenland",
					"wh3_main_combi_province_the_misty_hills",
					"wh3_main_combi_province_nordland",
					"wh3_main_combi_province_ostland",
					"wh3_main_combi_province_talabecland",
					"wh3_main_combi_province_ostermark",
					"wh3_main_combi_province_averland",
					"wh3_main_combi_province_mootland",
					"wh3_main_combi_province_wissenland",
					"wh3_main_combi_province_solland",
					"wh3_main_combi_province_northern_sylvania",
					"wh3_main_combi_province_southern_sylvania"
				},
			}
		},
		["wh3_dlc29_woc_glottkin_narrative_corrupt_altdorf"] = {
			override_text = {"wh3_dlc29_woc_glottkin_narrative_corrupt_altdorf_objective"},
			payload = {
				"faction_pooled_resource_transaction{resource wh3_dlc20_chs_souls;factor wh3_dlc20_souls_other;amount 700;context absolute;}",
				"money 10000"
			},

			entity = {
				type = "region",
				key = {"wh3_main_combi_region_altdorf"}
			}
		}

	},

	mission_to_final_battle_modifiers = 
	{
		["wh3_dlc29_woc_glottkin_narrative_pesticide"] = "additional_daemonic_reinforce_in_final_battle",
		["wh3_dlc29_woc_glottkin_narrative_ruinous_reik"] = "enemy_cannot_reinforce_in_final_battle",
		["wh3_dlc29_woc_glottkin_narrative_doctors_orders"] = "weaken_empire_forces_in_final_battle",
	},

	prerequisites =
	{
		min_turn = 2
	},

	persistent =
	{
		-- current_stage_index = [number]

		-- maps the stage data by stage index
		-- the data includes
		--{
		--	turn_started = [number],
		--}
		stages_persistent_data =
		{
			-- stage_persistent_data_table,
		},

		---------------------
		-- persistent data specific to this episode

		-- result from dilemma 1
		dilemma_choices =
		{
			-- [dilemma_key] = [choice_index]
		},
		completed_missions = {
			-- it could be a regular vector of strings, but I think this is easier to check and a bit more performant
			-- [missoion_key] = true,
		},
		invasion_data = {

		},
		pesticide_region = nil,
	},
}

episode_glottkin.stages = 
{
	{
		stage_key = "narrative_glottkin_first_stage",
		payloads = {
			{
				payload_type = "incident",
				faction_key = episode_glottkin.faction_key,
				incident_key = episode_glottkin.incident_narrative_act_1,
			},
			{
				payload_type = "mission",
				mission_key = episode_glottkin.narrative_join_or_die,
			}
		},

		on_started = function(self)
			episode_glottkin:episode_mission(episode_glottkin.narrative_assert_dominance)
			--episode_glottkin:episode_mission(episode_glottkin.narrative_join_or_die)
		end,

		on_mission_succeeded = function(self, mission_key)
			if string.find(mission_key, "glottkin_narrative") then
				episodes_manager.mark_mission_completed(episode_glottkin, mission_key)
			end
			if episode_glottkin:all_act_1_missions_are_completed() then
				episodes_manager:advance_stage(episode_glottkin)
			end
		end,
		
	},

	{
		stage_key = "narrative_glottkin_second_stage_dilemma",
		payloads =
		{
			{
				payload_type = "dilemma",
				dilemma_key = episode_glottkin.dilemma_angle_of_attack,
			},
		},

		on_dilemma_choice = function(self, dilemma_key, choice_index)
			if dilemma_key == episode_glottkin.dilemma_angle_of_attack then
				episodes_manager.mark_dilemma_choice(episode_glottkin, dilemma_key, choice_index)
				episodes_manager:advance_stage(episode_glottkin)
			end
		end,

	},

	{
		stage_key = "narrative_glottkin_third_stage",
		payloads = {
			{
				payload_type = "incident",
				faction_key = episode_glottkin.faction_key,
				incident_key = episode_glottkin.incident_narrative_act_2,
			}
		},

		on_started = function(self)
			episode_glottkin:episode_mission(episode_glottkin.pestilence_and_plagues)
			episode_glottkin:episode_mission(episode_glottkin.narrative_plague_fleet_assault)
			episode_glottkin:episode_mission(episode_glottkin.narrative_weaking_the_veil)
		end,

		on_mission_succeeded = function(self, mission_key)
			if episode_glottkin:is_act_2_core_mission(mission_key) then
				episodes_manager:advance_stage(episode_glottkin)
			end
		end,

		on_dilemma_choice = function(self, dilemma_key, choice_index)

			if dilemma_key == episode_glottkin.dilemma_ruinous_reik then
				episodes_manager.mark_dilemma_choice(episode_glottkin, dilemma_key, choice_index)
				local marienburg_interface = cm:get_region(episode_glottkin.marienburg_key)
				if choice_index == 0 then
					cm:apply_effect_bundle("wh3_dlc29_woc_ruinous_reik_first_option_effect_bundle", episode_glottkin.faction_key, 0)
				elseif choice_index == 1 then
					cm:apply_effect_bundle("wh3_dlc29_woc_ruinous_reik_second_option_effect_bundle", episode_glottkin.faction_key, 0)
				elseif choice_index == 2 then
					cm:apply_effect_bundle("wh3_dlc29_woc_ruinous_reik_third_option_effect_bundle", episode_glottkin.faction_key, 0)
				end
			end
		end
	},

	--- Act 3 - trigger battle for Altdorf
	{
		stage_key = "narrative_glottkin_fourth_stage",
		payloads = {
			{
				payload_type = "mission",
				mission_key = episode_glottkin.quest_battle_fall_of_altdorf
			}
		},
		on_mission_succeeded = function(self, mission_key) 
			if mission_key == episode_glottkin.quest_battle_fall_of_altdorf then
				episodes_manager:advance_stage(episode_glottkin)
			end
		end
	},

	-- Act 4, final - convert Altdorf to garden
	{
		stage_key = "narrative_glottkin_final",
		payloads = {
			{
				payload_type = "mission",
				mission_key = episode_glottkin.final_mission_corrupt_altdorf

			}
		},
		on_started = function(self)
			episode_glottkin:episode_mission(episode_glottkin.final_mission_corrupt_altdorf)
			cm:callback(
				function()
					local altdorf = cm:get_region(episode_glottkin.altdorf_settlement_key)
					if not altdorf or altdorf:is_null_interface() then
						return
					end

					local primary_building = altdorf:settlement():primary_slot():building()
					if primary_building and not primary_building:is_null_interface() and primary_building:name() == episode_glottkin.nurgle_garden_tier_5 then
						cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.final_mission_corrupt_altdorf, episode_glottkin.final_mission_corrupt_altdorf, true)
					end
				end,
				0.5
			)
		end,

		on_mission_succeeded = function(self, mission_key) 
			if mission_key == episode_glottkin.final_mission_corrupt_altdorf then
				episodes_manager:advance_stage(episode_glottkin)
			end
		end
	}
}
-------------------
-- REQUIRED -------
-------------------

episode_glottkin.is_available_this_game = function(self)
	local faction = cm:get_faction(episode_glottkin.faction_key)
	if not faction then
		--when loading an old save that doesn't have the faction
		return false
	end

	if faction:is_null_interface() or faction:is_human() == false or cm:is_multiplayer() then
		return false
	end

	return true
end

episode_glottkin.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
	cm:set_script_state(episode_glottkin.episode_active_shared_state, true)
end

episode_glottkin.execute_stage_payloads = function(self, stage_index)
	local stage_table = episode_glottkin.stages[stage_index]

	if not stage_table then
		return
	end

	for i = 1, #stage_table.payloads do
		local payload = stage_table.payloads[i]
		local params_table = {}

		payloads_executor.execute_payload(payload, params_table)
	end
end

-------------------
-- SELF REGISTER --
-------------------

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_glottkin.is_available_this_game() then
			return
		end

		if not cm:get_faction(episode_glottkin.faction_key) then 
			return 
		end
		
		
		if cm:get_faction(episode_glottkin.faction_key):is_human() then
			episodes_manager:add_available_episode(episode_glottkin)
		end
	end	
)

function episode_glottkin:initialise()
	if self:is_available_this_game() then
		episode_glottkin:listeners()
	end
end

------------------
--- Listeners ----
------------------
function episode_glottkin:listeners()
	core:add_listener(
		"Glottkin_Episode_Start",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return context:faction():name() == episode_glottkin.faction_key and faction:is_human() and cm:turn_number() == 1
		end,
		function(context)
			local altdorf_interface = cm:get_region(episode_glottkin.altdorf_settlement_key)
			cm:instantly_set_settlement_primary_slot_level(altdorf_interface:settlement(),episode_glottkin.altdorf_main_building_level)
			for i = 1, #episode_glottkin.cai_disable_regions do
				cm:cai_disable_targeting_against_settlement(episode_glottkin.cai_disable_regions[i])
			end
			for i = 1, #episode_glottkin.factions_increased_potential do
				local faction = cm:get_faction(episode_glottkin.factions_increased_potential[i])
				if faction and not faction:is_null_interface() then
					cm:faction_set_potential_modifier(faction, episode_glottkin.cai_increased_potential)
				end
			end
		end,
		false
	)

	core:add_listener(
		"Glottkin_Vassal_Mission_Diplomacy",
		"FactionBecomesVassal",
		function(context)
			local vassal = context:vassal()
			local glottkin_faction = cm:get_faction(episode_glottkin.faction_key)
			if glottkin_faction and not glottkin_faction:is_dead() then
				local mission_data = episode_glottkin.scripted_mission_data[episode_glottkin.narrative_assert_dominance]
				return vassal:is_vassal_of(glottkin_faction) and table.contains(mission_data.objective_cultures, vassal:culture()) and cm:mission_is_active_for_faction(glottkin_faction, episode_glottkin.narrative_assert_dominance)
			else
				return false
			end
		end,
		function(context)
			cm:increase_scripted_mission_count(episode_glottkin.narrative_assert_dominance, episode_glottkin.narrative_assert_dominance, 1)
		end,
		true
	)


	-- Act 2 - Tier 3 Garden built in Empire territory
	core:add_listener(
		"Act_2_Nurgle_Garden_Empire",
		"BuildingCompleted",
		function(context)
			return context:building():name() == episode_glottkin.nurgle_garden_tier_5 and context:building():faction():is_human()
		end,
		function(context)
			local region_interface = context:garrison_residence():region();
			local region_key = region_interface:name()
			local glottkin_faction_interface = context:building():faction()

			for _, empire_region_key in ipairs(imperial_authority.empire_regions) do
				if(region_key == empire_region_key) then
					if region_key ~= "wh3_main_combi_region_brass_keep" and cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_weaking_the_veil) then
						episode_glottkin.persistent.pesticide_region = region_key
						cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.narrative_weaking_the_veil, episode_glottkin.narrative_weaking_the_veil, true)
						episode_glottkin:set_up_invastion_markers_garden_of_nurgle(region_interface)
						table.insert(episode_glottkin.empire_regions_converted_to_garden, region_key)
						core:remove_listener("Act_2_Nurgle_Garden_Empire")
					end
				end
			end	
		end,
		true
	)

	---------------------------------------------------------------
	-- -- Act 2 - Invasion on Garden of Nurgle Tier 3
	
	core:add_listener(
		"Enemy_Invasion_Garden_Destroyed",
		"MilitaryForceDestroyed",
		function(context)

			local nurgle_garden_invasion_armies = cm:get_saved_value("nurgle_garden_invasion_armies_cqi") or {}
			local mf_cqi = context:military_force():command_queue_index()

			return table.contains(nurgle_garden_invasion_armies, mf_cqi)

		end,
		function(context)
			local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key)

			if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_pesticide)  then
				cm:increase_scripted_mission_count(episode_glottkin.narrative_pesticide, episode_glottkin.narrative_pesticide, 1)
			end
		end,
		true
	)

	---------------------------------------------------------------
	-- Act 2 - Invasion on Brass Keep


	core:add_listener(
		"Enemy_Invasion_Brass_Keep_Destroyed",
		"MilitaryForceDestroyed",
		function(context)

			local brass_keep_invasion_armies = cm:get_saved_value("brass_keep_invasion_armies_cqi") or {}
			local mf_cqi = context:military_force():command_queue_index()

			return table.contains(brass_keep_invasion_armies, mf_cqi)
		end,
		function(context)
			local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key)
			if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_doctors_orders)  then
					cm:increase_scripted_mission_count(episode_glottkin.narrative_doctors_orders, episode_glottkin.narrative_doctors_orders, 1)
			end
		end,
		true
	)

	-- Act 2 - Plague Spreading mission
	core:add_listener(
		"Pestilence_and_Plagues_Region_Infection",
		"RegionInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			local is_in_empire = context:target_region():is_contained_in_region_group(episode_glottkin.empire_region_group_key)
			if not is_in_empire then
				return
			end

			local faction = context:faction()
			local creator_name = context:plague():creator_faction():name()
			local has_mission = cm:mission_is_active_for_faction(faction, episode_glottkin.pestilence_and_plagues)
			if has_mission and creator_name == episode_glottkin.faction_key then
				if not context:is_creation() and not context:is_removed() then
					cm:increase_scripted_mission_count(episode_glottkin.pestilence_and_plagues, episode_glottkin.pestilence_and_plagues, 1) 					
				end
			end
		end,
		true
	)

	core:add_listener(
		"Pestilence_and_Plagues_MilForces_Infection",
		"MilitaryForceInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			local general = context:target_force():general_character()
			if not general or not general:has_region() then
				return
			end

			local is_in_empire = general:region():is_contained_in_region_group(episode_glottkin.empire_region_group_key)
			if not is_in_empire then
				return
			end

			local faction = context:faction()
			local creator_name = context:plague():creator_faction():name()
			local has_mission = cm:mission_is_active_for_faction(faction, episode_glottkin.pestilence_and_plagues)
			if has_mission and creator_name == episode_glottkin.faction_key then
				if not context:is_creation() and not context:is_removed() then
					cm:increase_scripted_mission_count(episode_glottkin.pestilence_and_plagues, episode_glottkin.pestilence_and_plagues, 1) 					
				end
			end
		end,
		true
	)		

	-- Act 2 - 
	core:add_listener(
		"Second_Stage_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.pestilence_and_plagues
		end,
		function(context)
			cm:force_awake_from_death_and_confederate(episode_glottkin.faction_key, episode_glottkin.festus_faction_key)
			episode_glottkin:episode_mission(episode_glottkin.narrative_doctors_orders)
			episode_glottkin:set_up_invastion_markers_brass_keep()
		end,
		true
	)	

	-- Act 2 - Brass keep Marker expired -> invade
	core:add_listener(
		"ScriptEventBrassKeepInvasionMarkerExpired",
		"ScriptEventBrassKeepInvasionMarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			cm:remove_interactable_campaign_marker(marker_ref)
			episode_glottkin:trigger_glottkin_episode_invasion(x, y, episode_glottkin.enemy_invasion_brass_keep)
			
			if not episode_glottkin.brass_keep_invasion_has_spawned_event_feed then
				cm:show_message_event_located(
					episode_glottkin.faction_key,
					"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail",
					x,
					y,
					true,
					558
				)
				episode_glottkin.brass_keep_invasion_has_spawned_event_feed = true
			end
		end,
		true
	)

	core:add_listener(
		"ScriptEventBrassKeepInvasionMarkerInteraction",
		"ScriptEventBrassKeepInvasionMarkerInteraction",
		true,
		function(context)
			local area_info = context.stored_table
			local marker_ref = area_info.marker_ref
			local invasion_faction = nil
			local invasion_data = episode_glottkin.enemy_invasion_brass_keep
			for _, faction_key in ipairs(invasion_data.faction_data) do
				local faction = cm:get_faction(faction_key)
				if faction and faction:is_dead() then
					invasion_faction = faction_key
					break
				end
			end
			if not invasion_faction then
				invasion_faction = "wh2_dlc16_emp_empire_invasion"
			end

			local forced_battle = Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				invasion_faction,
				cm:get_faction(invasion_faction):subculture(),
				19,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				false,
				false,
				true,
				nil,
				nil,
				nil,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases general level based on turn number
				nil
			)

			local invasion_armies = cm:get_saved_value(invasion_data.saved_value_key) or {}
			table.insert(invasion_armies, forced_battle.target.cqi)
			cm:set_saved_value(invasion_data.saved_value_key, invasion_armies)
		end,
		true
	)

	-- Act 2 - Occupy/Colonize Marienburg as a DF or Garden
	core:add_listener(
		"Occupy_Marienburg",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == episode_glottkin.faction_key and episode_glottkin.valid_occupation_options[context:occupation_decision()] and context:character():faction():is_human()
		end,
		function(context)
			local decision = context:occupation_decision()
			local region = context:garrison_residence():region()
			local region_key = region:name()

			if region_key == episode_glottkin.marienburg_key then
				local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key);
				if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_plague_fleet_assault) then
					cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.narrative_plague_fleet_assault, episode_glottkin.narrative_plague_fleet_assault, true)
					core:remove_listener("Occupy_Marienburg")
				end
			end
			
		end,
		true
	)

	-- Act 2 - Build Port Landmark
	core:add_listener(
		"Plague_Fleet_Assault_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.narrative_plague_fleet_assault
		end,
		function(context)
			local glottkin_faction_interface = context:faction() 
			if glottkin_faction_interface:is_human() then
				episode_glottkin:episode_mission_ruinous_reik()
			end
		end,
		true
	)

	-- Act 2 - Ruinous Reik part 2 Dilemma
	core:add_listener(
		"Glottkin_Final_Battle_Modifiers_Mission_Rewards",
		"MissionSucceeded",
		function(context)
			return context:faction():is_human() and context:faction():name() == episode_glottkin.faction_key
		end,
		function(context)
			local mission = context:mission():mission_record_key()
			if episode_glottkin.mission_to_final_battle_modifiers[mission] then 
				core:svr_save_registry_string(episode_glottkin.mission_to_final_battle_modifiers[mission], "1")

				if mission == episode_glottkin.narrative_ruinous_reik then
					cm:trigger_dilemma(episode_glottkin.faction_key, episode_glottkin.dilemma_ruinous_reik);
				end
			end
		end,
		true
	)
	
	-- Act 2 - Grant a GUO for Planting Tier 3 Garden in Empire territory
	core:add_listener(
		"Weaking_the_Veil_Great_Unclean_one",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.narrative_weaking_the_veil
		end,
		function(context)
			local faction = context:faction() 
			if faction:is_human() then
				cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "wh3_main_nur_mon_great_unclean_one_0", 1)

				if episode_glottkin.persistent.pesticide_region ~= nil and is_string(episode_glottkin.persistent.pesticide_region) then
					local entity = {
						type = "region",
						key = {episode_glottkin.persistent.pesticide_region},
					}
					episode_glottkin.scripted_mission_data[episode_glottkin.narrative_pesticide].entity = entity
				end
				episode_glottkin:episode_mission(episode_glottkin.narrative_pesticide)
			end
		end,
		true
	)

	-- Act 2 - Gain Altdorf after winning the Final Battle
	core:add_listener(
		"Fall_of_Altdorf_Battle_Completed",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.quest_battle_fall_of_altdorf
		end,
		function(context)
			cm:transfer_region_to_faction(episode_glottkin.altdorf_settlement_key, episode_glottkin.faction_key, episode_glottkin.dark_fortress)
		end,
		true
	)

	core:add_listener(
		"Glottkin_Block_Shortcuts",
		"IncidentOccuredEvent",
		function(context)
			local faction = cm:get_faction(episode_glottkin.faction_key)

			if faction 
			and context:faction() == faction 
			and faction:is_human() then
				local key = context:dilemma()
				return key == episode_glottkin.incident_narrative_act_1 or key == episode_glottkin.incident_narrative_act_2
			end
			return false
		end,
		function(context)
			ui_scripted_tour:toggle_shortcuts(false)
		end,
		true
	)

	core:add_listener(
		"Glottkin_Unblock_Shortcuts",
		"IncidentOccuredEvent",
		function(context)
			local faction = cm:get_faction(episode_glottkin.faction_key)
			if faction 
			and context:faction() == faction 
			and faction:is_human() then
				local key = context:dilemma()
				return key == episode_glottkin.incident_narrative_act_1 or key == episode_glottkin.incident_narrative_act_2
			end
			return false
		end,
		function(context)
			core:add_listener(
				"Glottkin_Incident_Closed",
				"PanelClosedCampaign",
				true,
				function()
					ui_scripted_tour:toggle_shortcuts(true)
				end,
				false
			)
		end,
		true
	)

	core:add_listener(
		"Garden_of_Nurgle_MarkerInteraction", 
		"ScriptEvent_Garden_of_Nurgle_MarkerInteraction",
		true,
		function(context)
			local area_info = context.stored_table
			local marker_ref = area_info.marker_ref
			local invasion_faction = nil
			local invasion_data = episode_glottkin.enemy_invasion_garden_of_nurgle
			for _, faction_key in ipairs(invasion_data.faction_data) do
				local faction = cm:get_faction(faction_key)
				if faction and faction:is_dead() then
					invasion_faction = faction_key
					break
				end
			end
			if not invasion_faction then
				invasion_faction = "wh2_dlc16_emp_empire_invasion"
			end

			local forced_battle = Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				invasion_faction,
				cm:get_faction(invasion_faction):subculture(),
				19,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				false,
				false,
				true,
				nil,
				nil,
				nil,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				nil
			)


			local invasion_armies = cm:get_saved_value(invasion_data.saved_value_key) or {}
			table.insert(invasion_armies, forced_battle.target.cqi)
			cm:set_saved_value(invasion_data.saved_value_key, invasion_armies)
		end,
		true
	)

	core:add_listener(
		"ScriptEvent_Garden_of_Nurgle_MarkerExpired",
		"ScriptEvent_Garden_of_Nurgle_MarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			local region_data = cm:get_region_data_at_position(x, y)
			local region = region_data:region()
			episode_glottkin.enemy_invasion_garden_of_nurgle.region_key = region:name()
			cm:remove_interactable_campaign_marker(marker_ref)
			episode_glottkin:trigger_glottkin_episode_invasion(x, y, episode_glottkin.enemy_invasion_garden_of_nurgle)

			if not episode_glottkin.garden_invasion_has_spawned_event_feed then
				cm:show_message_event_located(
					episode_glottkin.faction_key,
					"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail",
					x,
					y,
					true,
					558
				)
				episode_glottkin.garden_invasion_has_spawned_event_feed = true
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Episode_Final_Battle_Won",
		"BattleCompleted",
		function() 
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key() == episode_glottkin.final_quest_battle_key
		end,
		function()
			-- If Glottkin won the final battle, unlock Altdorf for CAI targeting
			-- Assuming player is attacker as set in battle_set_pieces
			if cm:pending_battle_cache_attacker_value() then 
				cm:cai_enable_targeting_against_settlement(episode_glottkin.altdorf_settlement_key)
			end
		end,
		true
	)

	--- Act 5 --- 
	-- Construct Tier 5 garden in Altdorf
	core:add_listener(
		"Act_5_Corrupt_Altdorf_Building_Completed",
		"BuildingCompleted",
		function(context)
			local building = context:building()
			local faction = building:faction()
			return building:name() == episode_glottkin.nurgle_garden_tier_5 
				and faction:is_human()
				and cm:mission_is_active_for_faction(faction, episode_glottkin.final_mission_corrupt_altdorf)
		end,
		function(context)
			local region_interface = context:garrison_residence():region();
			local region_key = region_interface:name()
			local glottkin_faction_interface = context:building():faction()

			if region_key == episode_glottkin.altdorf_settlement_key then 
				cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.final_mission_corrupt_altdorf, episode_glottkin.final_mission_corrupt_altdorf, true)
			end
		end,
		true
	)

	-- Construct Tier 5 garden in Altdorf - settlement conversion
	core:add_listener(
		"Act_5_Corrupt_Altdorf_Settlement_Conversion",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key
				and cm:mission_is_active_for_faction(context:performing_faction(), episode_glottkin.final_mission_corrupt_altdorf)
		end,
		function(context)
			local region_interface = context:ritual_target_region()

			if not region_interface or region_interface:is_null_interface() then 
				return
			end

			if region_interface:name() == episode_glottkin.altdorf_settlement_key then 
				local primary_building = region_interface:settlement():primary_slot():building()

				if not primary_building or primary_building:is_null_interface() then 
					return
				end

				if primary_building:name() == episode_glottkin.nurgle_garden_tier_5 then 
					cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.final_mission_corrupt_altdorf, episode_glottkin.final_mission_corrupt_altdorf, true)
				end
			end
		end,
		true
	)

end

------------------
--- FUNCTIONS ----
------------------

function episode_glottkin:episode_mission(mission_key)
	local mission_data = episode_glottkin.scripted_mission_data[mission_key]
	local mm = mission_manager:new(episode_glottkin.faction_key, mission_key)
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key " .. mission_key)
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

	if mission_data.mission_turn_limit then 
		mm:set_turn_limit(mission_data.mission_turn_limit)
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
			cm:set_scripted_mission_entity_completion_states(mission_key, mission_key, entity_table)
		end
	end

	if mission_data.objective_total then
		for i = 1, #add_description do
			cm:set_scripted_mission_text(mission_key, mission_key, "mission_text_text_"..add_description[i], 0,  mission_data.objective_total)
		end
	end
end

function episode_glottkin:set_up_invastion_markers_brass_keep()				
	-- use the marker manager to spawn a series of invasion markers, with an event that fires when they expire
	local marker_base_key = "brass_keep_marker"
	local countdown_markers = Interactive_Marker_Manager:create_countdown(
		marker_base_key,
		"ScriptEventBrassKeepInvasionMarkerInteraction",
		"ScriptEventBrassKeepInvasionMarkerExpired",
		{"invasion_marker_5", "invasion_marker_4", "invasion_marker_3", "invasion_marker_2", "invasion_marker_1"}
	)
	
	local invasion_coord_list = episode_glottkin.brass_keep_invasion_spawn_coords
	local countdown_marker_stage_1 = countdown_markers[1]
	local has_setup_event_feed = false 

	for i = 1, #invasion_coord_list do
		local x = invasion_coord_list[i][1]
		local y = invasion_coord_list[i][2]
		
		if not has_setup_event_feed then
			cm:show_message_event_located(
				episode_glottkin.faction_key,
				"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail",
				x,
				y,
				true,
				558
			)
			has_setup_event_feed = true
		end

		countdown_marker_stage_1:spawn_at_location(x, y, false)
	end
end

function episode_glottkin:set_up_invastion_markers_garden_of_nurgle(region)
	-- use the marker manager to spawn a series of invasion markers, with an event that fires when they expire
	local marker_base_key = "garden_of_nurgle"
	
	local countdown_markers = Interactive_Marker_Manager:create_countdown(
		marker_base_key,
		"ScriptEvent_Garden_of_Nurgle_MarkerInteraction",
		"ScriptEvent_Garden_of_Nurgle_MarkerExpired",
		{"invasion_marker_5", "invasion_marker_4", "invasion_marker_3", "invasion_marker_2", "invasion_marker_1"}
	)
	
	local countdown_marker_stage_1 = countdown_markers[1]
	local has_setup_event_feed = false 

	for i = 1, 3 do
		local offset = cm:random_number(6, 15)
		local x,y = cm:find_valid_spawn_location_for_character_from_settlement(episode_glottkin.faction_key, region:name(), false, false, offset)

		if not has_setup_event_feed then
			cm:show_message_event_located(
				episode_glottkin.faction_key,
				"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail",
				x,
				y,
				true,
				558
			)
			has_setup_event_feed = true
		end

		countdown_marker_stage_1:spawn_at_location(x, y, false)
	end
end

function episode_glottkin:trigger_glottkin_episode_invasion(x, y, invasion_data)
	out("Triggering Glottkin's episode's invasion")

	local invasion_faction = nil

	for id, faction_data in dpairs(invasion_data.faction_data) do
		if invasion_faction ~= nil then
			break
		end

		local invasion_persistent_data = episode_glottkin.persistent.invasion_data[id]
		if not invasion_persistent_data then
			local copy = table.copy(faction_data)
			episode_glottkin.persistent.invasion_data[id] = copy
			invasion_persistent_data = episode_glottkin.persistent.invasion_data[id]
		end 

		if invasion_persistent_data.amount_to_spawn > 0 then
			for i = 1, #faction_data.faction_keys do
				local faction = cm:get_faction(faction_data.faction_keys[i])
				if faction and faction:is_dead() then
					invasion_faction = faction_data.faction_keys[i]
					invasion_persistent_data.amount_to_spawn = invasion_persistent_data.amount_to_spawn - 1
					break
				end
			end
			if not invasion_faction then
				invasion_faction = "wh2_dlc16_emp_empire_invasion"
				invasion_persistent_data.amount_to_spawn = invasion_persistent_data.amount_to_spawn - 1
				break
			end
		end
	end

	local invasion_faction_override = cm:get_faction(invasion_faction):subculture()
	local unit_list = WH_Random_Army_Generator:generate_random_army(invasion_faction,invasion_faction_override,19,1,true,false)
	local invasion_key = "garden_of_nurgle_invasion_".. invasion_faction.. "_".. x.. "_".. y
	local spawn_location_x, spawn_location_y = cm:find_valid_spawn_location_for_character_from_position(episode_glottkin.faction_key, x,y,true)
	if spawn_location_x and spawn_location_y then
		local invasion_object = invasion_manager:new_invasion(invasion_key,invasion_faction,unit_list,{spawn_location_x, spawn_location_y})
		invasion_object:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",-1)
		invasion_object:set_target("REGION",invasion_data.target_region_key,episode_glottkin.faction_key)
		invasion_object:add_aggro_radius(25,episode_glottkin.faction_key,1)
		invasion_object:start_invasion(
			function(self)
			cm:force_declare_war(
			episode_glottkin.faction_key,
			invasion_faction,
			false,
			false
			)
		end,
		false,
		false,
		false
		)

		local invasion_armies = cm:get_saved_value(invasion_data.saved_value_key) or {}
		table.insert(invasion_armies, invasion_object.force_cqi)
		cm:set_saved_value(invasion_data.saved_value_key, invasion_armies)
	end
end

function episode_glottkin:add_configured_objectives(mm, objectives, mission_key)
	for i = 1, #objectives do
		local objective = objectives[i]

		mm:add_new_objective(objective.type)

		for j = 1, #objective.conditions do
			mm:add_condition(objective.conditions[j])
		end

		local payloads = episode_glottkin.scripted_mission_data[mission_key].payload

		if payloads then
			for k = 1, #payloads do
				mm:add_payload(payloads[k])
			end
		end
	end
end


function episode_glottkin:episode_mission_ruinous_reik()

	local mm = mission_manager:new(
		episode_glottkin.faction_key,
		episode_glottkin.narrative_ruinous_reik
	)
	local mission_data = episode_glottkin.scripted_mission_data[episode_glottkin.narrative_ruinous_reik]

	episode_glottkin:add_configured_objectives(
		mm,
		{
			generate_CONSTRUCT_BUILDING_IN_PROVINCES_objective(
				mission_data.objective_building_level,
				mission_data.objective_provinces,
				episode_glottkin.faction_key
			)
		},
		episode_glottkin.narrative_ruinous_reik
	)

	mm:trigger()
end

function episode_glottkin:all_act_1_missions_are_completed()
	
	for i, required_mission_check in ipairs(episode_glottkin.missions_required_to_end_act_1) do
		if not episodes_manager.is_mission_completed(episode_glottkin, required_mission_check) then
			return false
		end
	end
	return true
end

function episode_glottkin:all_act_2_missions_are_completed()
	
	for i, required_mission_check in ipairs(episode_glottkin.missions_required_to_end_act_2) do
		if not episodes_manager.is_mission_completed(episode_glottkin, required_mission_check) then
			return false
		end
	end
	return true
end

function episode_glottkin:is_act_2_core_mission(mission_key)
	if mission_key == episode_glottkin.pestilence_and_plagues or
		mission_key == episode_glottkin.narrative_plague_fleet_assault or 
		mission_key == episode_glottkin.narrative_weaking_the_veil then 
			return true
	end

	return false
end

--------------------- SAVE/LOAD ---------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("empire_regions_converted_to_garden", episode_glottkin.empire_regions_converted_to_garden, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			episode_glottkin.empire_regions_converted_to_garden = cm:load_named_value("empire_regions_converted_to_garden", episode_glottkin.empire_regions_converted_to_garden, context)
		else
			for mission_key, string_key in dpairs(episode_glottkin.mission_to_final_battle_modifiers) do
				core:svr_save_registry_string(string_key, "")
			end
		end
	end
)