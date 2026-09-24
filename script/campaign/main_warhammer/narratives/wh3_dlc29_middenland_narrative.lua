--------------------------------------------------------------
-------------------------- CONFIG ----------------------------
--------------------------------------------------------------

middenland_narrative = {}
middenland_narrative.config = {
	boris_faction_key = "wh_main_emp_middenland",
	boris_subtype_key = "wh_dlc03_emp_boris_todbringer",
	first_enemy_faction_key = "wh2_main_skv_clan_gnaw",

	middenheim_region_key = "wh3_main_combi_region_middenheim",
	great_temple_initiative_set = "DLC29_GREAT_TEMPLE_OF_ULRIC",

	-- each failed mission from act 1 adds + 1 invasion in act 2 to this value
	act_2_default_invasions = 4, 

	beastmen_invasion_faction_key = "wh_dlc03_bst_beastmen_qb1",
	beastmen_invasion_general_subtype = "wh_dlc03_bst_beastlord",
	beastmen_invasion_faction_trait_effect_bundle = "wh3_dlc29_faction_trait_chaos_invasion",
	beastmen_invasion_force_trait_effect_bundle = "wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",

	invasion_force_spawn_distance_from_settlement_min = 8,
	invasion_force_spawn_distance_from_settlement_max = 35,
	invasion_force_spawn_distance_from_marker_min = 4,
	invasion_force_spawn_distance_from_marker_max = 8,

	drakwald_threat = {

		random_invasion_regions = {
			"wh3_main_combi_region_middenheim",
			"wh3_main_combi_region_carroburg",
			"wh3_main_combi_region_talabheim",
			"wh3_main_combi_region_laurelorn_forest",
		},

		threat_increase_turns_interval = {
			min = 6, 
			max = 10,
		},

		invasion_marker_lifetime = 3, -- after this amount of turns invasion marker disappears and spawns invasion force
		invasion_marker_buffer_time_max = 4, -- minimum number of turns between marker spawns

		-- If invasion marker was not resolved - spawned invasion will be more powerful and numerous
		-- Amount of units does not include general, ie for full army set 19 units max
		threat_level_to_invasion_parameters = {
			["0"] =		{ spawn_chance = 0, 	},
			["1"] =		{ spawn_chance = 15, 	invasion_strength = { resolved_marker = { power = 1, units = 6}, expired_marker = { power = 3, units = 11}, }, },
			["2"] =  	{ spawn_chance = 20, 	invasion_strength = { resolved_marker = { power = 4, units = 10}, expired_marker = { power = 6, units = 15}, }, },
			["3"] = 	{ spawn_chance = 25,	invasion_strength =	{ resolved_marker = { power = 8, units = 14}, expired_marker = { power = 10, units = 19}, }, },
		},

		threat_incidents = {
			threat_increase = "wh3_dlc29_emp_middenland_narrative_drakwald_threat_increases",
			threat_decrease = "wh3_dlc29_emp_middenland_narrative_drakwald_threat_decreases",
		},

		beastmen_spawned_incident_key = "wh3_dlc29_emp_middenland_narrative_invasion_beastmen_spawned_incident",
		pooled_resource = "wh3_dlc29_emp_middenland_drakwald_threat",
		pooled_resource_factor = "other",
		shared_state_enabled = "middenland_drakwald_threat_enabled"
	},
}

middenland_narrative.marker_config = {
	act_1 = {
		mission_1 = {
			id = "middenland_act_1_mission_1_marker",
			marker_info = "wh3_dlc29_beastmen_marker_1_3",
			x_pos = 501,
			y_pos = 687,
		},
	},

	invasions = {
		middenland_invasion_marker = {
			id = "middenland_invasion_marker",
			marker_info = "wh3_dlc29_beastmen_marker_THREAT_TIMER",
			-- x_pos y_pos generated randomly for invasion markers
		},
	},

	marker_spawn_incidents = {
		"wh3_dlc29_emp_middenland_narrative_invasion_incident_2",
		"wh3_dlc29_emp_middenland_narrative_invasion_incident_3",
	},

	marker_initial_warning_event = {
		title = "event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_beastmen_invasion_title",
		primary_detail = "event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail",
		secondary_detail = "event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail",
		criteria_value = 554,
	},

	marker_final_warning_event = {
		title = "event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_beastmen_invasion_title",
		primary_detail = "event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
		secondary_detail = "event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail",
		criteria_value = 554,
	}

}

middenland_narrative.stage_config = {
	-- stage_type: "incident", "mission", "dilemma", "invasion", "dummy"
	-- trigger_conditions: turn_number, region_owned, regions_owned_total, mission_complete, mission_failed, dilemma_choice_made, act_complete, incident_occured, marker_resolved, mission_issued
	-- Any stage type can have a paired condition of following combinations: turn_number and region_owned / turn_number and regions_owned_total (both conditions have to be true to trigger stage)
	-- Incident type stage can have a paired condition of following combinations: dilemma_choice_made or mission_complete / dilemma_choice_made or mission_failed (one of conditions have to be true to trigger incident)

	act_1 = {

		-- Danger of the Drakwald Incident
		stage_1_incident = { 
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_danger_of_the_drakwald",
			trigger_conditions = {
				regions_owned_total = 4,
			},
			callback = "set_drakwald_threat_feature_enabled",
			callback_parameters = {true, 1}, -- act 1 initial threat level
		},	

		-- Sacred Flame Mission 1
		stage_2_mission = { 
			stage_type = "mission",
			key = "wh3_dlc29_emp_middenland_narrative_sacred_flame_1",
			trigger_conditions = {
				incident_occured = "wh3_dlc29_emp_middenland_narrative_danger_of_the_drakwald",
			},
			database_mission = true,
		},

		-- Raided Hamlet Dilemma
		stage_3_dilemma = {
			stage_type = "dilemma",
			key = "wh3_dlc29_emp_middenland_raided_hamlet_dilemma",
			trigger_conditions = {
				turn_number = 8,
			},
		},

		-- Raided Hamlet Dilemma choice Invasion
		stage_3_invasion = {
			stage_type = "invasion",
			key = "stage_3_dilemma_choice_invasion",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_raided_hamlet_dilemma",
					dilemma_choice_index = 2,
				},
			},
			invasion_params = {
				x = middenland_narrative.marker_config.act_1.mission_1.x_pos,
				y = middenland_narrative.marker_config.act_1.mission_1.y_pos,
			},
		},

		-- Raided Hamlet Dilemma choice incident
		stage_3_incident = { 
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_invasion_incident_1",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_raided_hamlet_dilemma",
					dilemma_choice_index = 2,
				},
			},
		},	

		-- Strange Tracks Dilemma
		stage_4_dilemma = {
			stage_type = "dilemma",
			key = "wh3_dlc29_emp_middenland_strange_tracks_dilemma",
			trigger_conditions = {
				turn_number = 12,
				region_owned = "wh3_main_combi_region_weismund",
			},
		},

		-- Beastmen Tracked Down Incident
		stage_4_incident_1 = {
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_beastmen_tracked_down",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_strange_tracks_dilemma",
					dilemma_choice_index = 0,
				},
			},
		},

		-- Hunt Wrongly Abandoned Incident
		stage_4_incident_2 = {
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_hunt_wrongly_abandoned",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_strange_tracks_dilemma",
					dilemma_choice_index = 1,
				},
			},
		},
	},

	act_2 = {
		-- Khazrak in the Open Incident
		stage_1_incident = { 
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_khazrak_in_the_open",
			trigger_conditions = {
				act_complete = "act_1",
			},
			callback = "set_drakwald_threat_level",
			callback_parameters = {3}, -- act 2 initial threat level
		},

		-- Repel the Assault Mission
		stage_2_mission = { 
			stage_type = "mission",
			key = "wh3_dlc29_emp_middenland_mission_repel_the_assault",
			mission_complete_condition = "invasion_defeated",
			trigger_conditions = {
				incident_occured = "wh3_dlc29_emp_middenland_narrative_khazrak_in_the_open",
			},
			payload = {
				payload.pooled_resource_mission_payload("wh3_dlc29_emp_fervour", "missions", 300),
				payload.effect_bundle_mission_payload("wh3_dlc29_emp_middenland_narrative_act_2_mission_1_bundle", 5),
			},
			mission_text = "mission_text_text_wh3_dlc29_emp_middenland_mission_repel_the_assault_description",
		},

		-- Repel the Assault mission Invasions
		stage_2_invasion = {
			stage_type = "invasion",
			key = "stage_2_mission_issued_invasions",
			objective_of_mission = "wh3_dlc29_emp_middenland_mission_repel_the_assault",
			trigger_conditions = {
				mission_issued = "wh3_dlc29_emp_middenland_mission_repel_the_assault",
			},
			invasion_params = {
				-- Special flag which spawns invasion markers instead of invasions and calculates their amount depending on failed missions in act 1
				act_2_mission_invasion = true,
			},
		},
	},

	act_3 = {
		-- The Final Threat Draws Near Incident
		stage_1_incident = { 
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_the_final_threat_draws_near",
			trigger_conditions = {
				act_complete = "act_2",
			},
			callback = "set_drakwald_threat_level",
			callback_parameters = {1}, -- act 3 initial threat level
		},

		-- Sacred Flame Mission 2
		stage_2_mission = { 
			stage_type = "mission",
			key = "wh3_dlc29_emp_middenland_narrative_sacred_flame_2",
			trigger_conditions = {
				incident_occured = "wh3_dlc29_emp_middenland_narrative_the_final_threat_draws_near",
			},
			database_mission = true,
		},

		-- The Final Duel Mission
		stage_3_mission = { 
			stage_type = "mission",
			key = "wh3_dlc29_qb_emp_boris_final_battle",
			trigger_conditions = {
				mission_complete = "wh3_dlc29_emp_middenland_narrative_sacred_flame_2",
			},
			database_mission = true,
		},

		-- The Final Duel won Incident
		stage_3_incident = { 
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_the_final_duel_won",
			trigger_conditions = {
				mission_complete = "wh3_dlc29_qb_emp_boris_final_battle",
			},
			callback = "set_drakwald_threat_feature_enabled",
			callback_parameters = {false}, -- disable drakwald threat meter
		},

		-- Laurelorn Dilemma
		stage_4_dilemma_optional = {
			stage_type = "dilemma",
			key = "wh3_dlc29_emp_middenland_scour_the_forest_laurelorn_dilemma",
			trigger_conditions = {
				turn_number = 20,
				region_owned = "wh3_main_combi_region_laurelorn_forest",
			},
		},

		-- Wood Elves Saved
		stage_4_incident_1_optional = {
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_incident_wef_saved",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_scour_the_forest_laurelorn_dilemma",
					dilemma_choice_index = 0,
				},
			},
		},

		-- Laurelorn Dilemma Choice 0 - Final Battle Reinforcements
		stage_4_dummy_optional = {
			stage_type = "dummy",
			key = "stage_optional_mission_4_dilemma_choice",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_scour_the_forest_laurelorn_dilemma",
					dilemma_choice_index = 0,
				},
			},
			callback = "enable_final_battle_reinforcements",
		},

		-- Wood Elves Abandoned
		stage_4_incident_2_optional = {
			stage_type = "incident",
			key = "wh3_dlc29_emp_middenland_narrative_incident_wef_abandoned",
			trigger_conditions = {
				dilemma_choice_made = {
					dilemma_key = "wh3_dlc29_emp_middenland_scour_the_forest_laurelorn_dilemma",
					dilemma_choice_index = 1,
				},
			},
		},

	},
}

middenland_narrative.stage_callbacks = {
	
	set_drakwald_threat_level = function(threat_level)
		middenland_narrative:set_drakwald_threat_level(threat_level)
	end,

	set_drakwald_threat_feature_enabled = function(is_enabled, init_threat_level)
		middenland_narrative:set_drakwald_threat_feature_enabled(is_enabled)
		if value == false then
			middenland_narrative:abandon_scour_the_forest_missions()
			middenland_narrative:remove_all_invasion_markers()
		end
		if is_enabled and init_threat_level ~= nil then
			middenland_narrative:set_drakwald_threat_level(init_threat_level)
			--Trigger an invasion encounter after unlocking feature
			middenland_narrative:spawn_invasion_marker()
			-- Increase Drakwald threat in 4 turns to introduce Marker increases
			middenland_narrative:launch_drakwald_threat_cycle(4)
		end
	end,

	enable_final_battle_reinforcements = function()
		middenland_narrative.persistent.final_battle_reinforcements = true
		core:svr_save_bool("sbool_wh3_dlc29_middenland_boris_final_battle_reinforcements_enabled", true)
	end,
}

middenland_narrative.trigger_condition_templates = {
	
	turn_number = function(trigger_conditions)
		local event_to_listen = "FactionTurnStart"
		local filter = function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key and cm:turn_number() >= trigger_conditions.turn_number
		end
		return event_to_listen, filter
	end,

	region_owned = function(trigger_conditions)
		local event_to_listen = "RegionFactionChangeEvent"
		local filter = function(context)
			local region_obj = context:region()
			return region_obj:owning_faction():name() == middenland_narrative.config.boris_faction_key and region_obj:name() == trigger_conditions.region_owned
		end
		return event_to_listen, filter
	end,

	regions_owned_total = function(trigger_conditions)
		local event_to_listen = "RegionFactionChangeEvent"
		local filter = function(context)
			local faction_obj = cm:get_faction(middenland_narrative.config.boris_faction_key)
			return context:region():owning_faction():name() == middenland_narrative.config.boris_faction_key and faction_obj:region_list():num_items() >= trigger_conditions.regions_owned_total
		end
		return event_to_listen, filter
	end,

	mission_complete = function(trigger_conditions)
		local event_to_listen = "MissionSucceeded"
		local filter = function(context)
			return context:mission():mission_record_key() == trigger_conditions.mission_complete and context:faction():name() == middenland_narrative.config.boris_faction_key
		end
		return event_to_listen, filter
	end,

	mission_failed = function(trigger_conditions)
		local event_to_listen = "MissionFailed"
		local filter = function(context)
			return context:mission():mission_record_key() == trigger_conditions.mission_failed and context:faction():name() == middenland_narrative.config.boris_faction_key
		end
		return event_to_listen, filter
	end,

	mission_issued = function(trigger_conditions)
		local event_to_listen = "MissionIssued"
		local filter = function(context)
			return context:mission():mission_record_key() == trigger_conditions.mission_issued and context:faction():name() == middenland_narrative.config.boris_faction_key
		end
		return event_to_listen, filter
	end,

	dilemma_choice_made = function(trigger_conditions)
		local event_to_listen = "DilemmaChoiceMadeEvent"
		local filter = function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key and context:dilemma() == trigger_conditions.dilemma_choice_made.dilemma_key and context:choice() == trigger_conditions.dilemma_choice_made.dilemma_choice_index
		end
		return event_to_listen, filter
	end,

	act_complete = function(trigger_conditions)
		local event_to_listen = "FactionTurnStart"
		local filter = function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key 
				and table.contains(middenland_narrative.persistent.completed_acts, trigger_conditions.act_complete)
		end
		return event_to_listen, filter
	end,

	incident_occured = function(trigger_conditions)
		local event_to_listen = "IncidentOccuredEvent"
		local filter = function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key and context:dilemma() == trigger_conditions.incident_occured
		end
		return event_to_listen, filter
	end,

	marker_resolved = function(trigger_conditions)
		local event_to_listen = "AreaEntered"
		local filter = function(context)
			local character = context:family_member():character()
			return not character:is_null_interface() and character:has_military_force() and character:faction():name() == middenland_narrative.config.boris_faction_key and context:area_key() == trigger_conditions.marker_resolved 
		end
		return event_to_listen, filter
	end,

	region_owned_after_turn_number = function(trigger_conditions)
		local event_to_listen = "FactionTurnStart"
		local filter = function(context)
			local region_obj = cm:get_region(trigger_conditions.region_owned)
			return context:faction():name() == middenland_narrative.config.boris_faction_key 
				and region_obj:owning_faction():name() == middenland_narrative.config.boris_faction_key 
				and cm:turn_number() >= trigger_conditions.turn_number
		end
		return event_to_listen, filter
	end,

	regions_owned_total_after_turn_number = function(trigger_conditions)
		local event_to_listen = "FactionTurnStart"
		local filter = function(context)
			local faction_obj = cm:get_faction(middenland_narrative.config.boris_faction_key)
			return context:faction():name() == middenland_narrative.config.boris_faction_key 
				and faction_obj:region_list():num_items() >= trigger_conditions.regions_owned_total
				and cm:turn_number() >= trigger_conditions.turn_number
		end
		return event_to_listen, filter
	end,
}

middenland_narrative.persistent = {

	completed_acts = {},
	completed_missions = {},
	triggered_stages = {},

	act_1_failed_mission_stages = 0,
	act_2_spawned_invasion_markers = 0,
	act_2_invasion_forces_defeated = 0,

	spawned_mission_objective_invasion_mfs = {},
	active_invasion_marker_list = {},

	final_battle_reinforcements = false,

	drakwald_threat_enabled = false,
	drakwald_threat_level = 0, -- min: 0, max: 3
	threat_level_increased_at_turn_number = 0,

	invasion_marker_buffer_time = 0, -- this is the number of turns between invasion markers spawn event so they do not trigger back to back turns
}

--------------------------------------------------------------
--------------- NARRATIVE CHAIN FUNCTIONS --------------------
--------------------------------------------------------------

function middenland_narrative:initialise()
	if not cm:is_multiplayer() and cm:is_faction_human(middenland_narrative.config.boris_faction_key) then
		middenland_narrative:add_listeners()
		middenland_narrative:initialise_drakwald_threat()
		middenland_narrative:initialise_stored_invasion_marker_interaction_listeners()

		core:svr_save_bool("sbool_wh3_dlc29_middenland_boris_final_battle_reinforcements_enabled", middenland_narrative.persistent.final_battle_reinforcements)
		cm:disable_movement_for_faction(middenland_narrative.config.first_enemy_faction_key)
	end
end

function middenland_narrative:add_listeners()
	for act, act_data in dpairs(middenland_narrative.stage_config) do
		for stage, stage_data in dpairs(act_data) do
			local condititon_params = middenland_narrative:parse_trigger_conditions(stage, stage_data)
			if is_nil(condititon_params) then
				script_error("ERROR: invalid trigger_conditions setup for stage: " .. stage .. "  act: " .. act)
				return
			end
			if stage_data.stage_type == "incident" then
				middenland_narrative:trigger_incident_from_stage_data(act, stage, stage_data, condititon_params)
			elseif stage_data.stage_type == "mission" then
				middenland_narrative:trigger_mission_from_stage_data(act, stage, stage_data, condititon_params)
			elseif stage_data.stage_type == "dilemma" then
				middenland_narrative:trigger_dilemma_from_stage_data(act, stage, stage_data, condititon_params)
			elseif stage_data.stage_type == "invasion" then
				middenland_narrative:trigger_invasion_from_stage_data(act, stage, stage_data, condititon_params)
			elseif stage_data.stage_type == "dummy" then
				middenland_narrative:trigger_dummy_from_stage_data(act, stage, stage_data, condititon_params)
			else
				script_error("ERROR: stage_type for stage: " .. stage .. "  act: " .. act .. " has incorrect type")
			end
		end
	end

	core:add_listener(
		"Middenland_Incident_Shortcuts_Disable",
		"ContextUITriggerEvent",
		function(context)
			return context.string:starts_with("incident_large_panel_show:wh3_dlc29_emp_middenland_narrative")
		end,
		function(context)
			ui_scripted_tour:toggle_shortcuts(false)
		end,
		true
	)

	core:add_listener(
		"Middenland_Incident_Shortcuts_Enable",
		"ContextUITriggerEvent",
		function(context)
			return context.string:starts_with("incident_large_panel_hide:wh3_dlc29_emp_middenland_narrative")
		end,
		function(context)
			ui_scripted_tour:toggle_shortcuts(true)
		end,
		true
	)

	core:add_listener(
		"Middenland_Narrative_Sacred_Flame_Success_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return string.find(context:mission():mission_record_key(), "wh3_dlc29_emp_middenland_narrative_sacred_flame")
		end,
		function(context)
			middenland_narrative:update_mission_stage_progression(context:mission():mission_record_key(), true)
		end,
		true
	)

	core:add_listener(
		"Middenland_Narrative_FinalDuelWon_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh3_dlc29_qb_emp_boris_final_battle"
		end,
		function(context)
			middenland_narrative:update_mission_stage_progression(context:mission():mission_record_key(), true)
		end,
		false
	)

end

function middenland_narrative:parse_trigger_conditions(stage, stage_data)

	local trigger_conditions = stage_data.trigger_conditions

	if is_nil(trigger_conditions) then
		script_error("ERROR: empty trigger_conditions for stage: " .. stage)
		return
	end

	local condition_params = {}
	local event_to_listen
	local filter

	if table.size(trigger_conditions) == 2 then
		if trigger_conditions.turn_number then
			if trigger_conditions.region_owned then
				event_to_listen, filter = middenland_narrative.trigger_condition_templates.region_owned_after_turn_number(trigger_conditions)
			elseif trigger_conditions.regions_owned_total then
				event_to_listen, filter = middenland_narrative.trigger_condition_templates.regions_owned_total_after_turn_number(trigger_conditions)
			end
		elseif stage_data.stage_type == "incident" and trigger_conditions.dilemma_choice_made then
			local dilemma_condition = {}
			local mission_condition = {}
			local second_event_to_listen
			local second_filter

			event_to_listen, filter = middenland_narrative.trigger_condition_templates.dilemma_choice_made(trigger_conditions)

			if trigger_conditions.mission_complete then
				second_event_to_listen, second_filter = middenland_narrative.trigger_condition_templates.mission_complete(trigger_conditions)
			elseif trigger_conditions.mission_failed then
				second_event_to_listen, second_filter = middenland_narrative.trigger_condition_templates.mission_failed(trigger_conditions)
			else
				script_error("ERROR: trigger_conditions for stage: " .. stage .. " contains dilemma_choice_made condition with another incompatible condition")
				return
			end
			
			dilemma_condition.event_to_listen = event_to_listen
			dilemma_condition.filter = filter

			mission_condition.event_to_listen = second_event_to_listen
			mission_condition.filter = second_filter

			table.insert(condition_params, dilemma_condition)
			table.insert(condition_params, mission_condition)

			return condition_params
		else
			script_error("ERROR: trigger_conditions for stage: " .. stage .. " contains 2 incompatible conditions")
			return
		end
	elseif table.size(trigger_conditions) == 1 then
		if trigger_conditions.turn_number then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.turn_number(trigger_conditions)
		elseif trigger_conditions.region_owned then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.region_owned(trigger_conditions)
		elseif trigger_conditions.regions_owned_total then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.regions_owned_total(trigger_conditions)
		elseif trigger_conditions.mission_complete then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.mission_complete(trigger_conditions)
		elseif trigger_conditions.mission_failed then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.mission_failed(trigger_conditions)
		elseif trigger_conditions.mission_issued then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.mission_issued(trigger_conditions)
		elseif trigger_conditions.dilemma_choice_made then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.dilemma_choice_made(trigger_conditions)
		elseif trigger_conditions.act_complete then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.act_complete(trigger_conditions)
		elseif trigger_conditions.incident_occured then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.incident_occured(trigger_conditions)
		elseif trigger_conditions.marker_resolved then
			event_to_listen, filter = middenland_narrative.trigger_condition_templates.marker_resolved(trigger_conditions)
		end
	else
		script_error("ERROR: trigger_condition for stage: " .. stage .. " contains invalid amount of conditions")
		return
	end

	-- Incident trigger conditions have to be stored inside additional table
	if stage_data.stage_type == "incident" then
		local condition_table = {}
		condition_table.event_to_listen = event_to_listen
		condition_table.filter = filter
		table.insert(condition_params, condition_table)
	else
		condition_params.event_to_listen = event_to_listen
		condition_params.filter = filter
	end

	return condition_params
end

function middenland_narrative:trigger_incident_from_stage_data(act, stage, stage_data, condititon_params)
	
	if middenland_narrative:was_stage_triggered(act, stage) then
		return
	end
	
	for _, condition_data in dpairs(condititon_params) do 
		core:add_listener(
			"MiddenlandNarrativeIncidentListener_" .. act .. stage,
			condition_data.event_to_listen,
			function(context)
				return condition_data.filter(context)
			end,
			function(context)
				cm:trigger_incident(middenland_narrative.config.boris_faction_key, stage_data.key, true, true)
				middenland_narrative:trigger_stage_callback(stage_data)
				middenland_narrative:update_triggered_stages(act, stage)
			end,
			false
		)
	end
end

function middenland_narrative:trigger_mission_from_stage_data(act, stage, stage_data, condititon_params)
	
	-- Add mission listeners before checking if it was triggered to keep scripted mission objective listeners intact after mission was issued but not completed
	if stage_data.encounter_marker_mission then
		middenland_narrative:add_encounter_marker_interaction_listeners(stage, stage_data)
	end

	if stage_data.mission_complete_condition == "invasion_defeated" then
		middenland_narrative:add_invasion_defeated_listeners(stage, stage_data)
	end

	if middenland_narrative:was_stage_triggered(act, stage) then
		return
	end

	core:add_listener(
		"MiddenlandNarrativeMissionTriggerListener_" .. act .. stage,
		condititon_params.event_to_listen,
		function(context)
			return condititon_params.filter(context)
		end,
		function()
			if stage_data.database_mission then
				cm:trigger_mission(middenland_narrative.config.boris_faction_key, stage_data.key, true)
			else
				local mm = mission_manager:new(middenland_narrative.config.boris_faction_key, stage_data.key)
			
				mm:add_new_objective("SCRIPTED")
				mm:add_condition("script_key ".. stage_data.key)
				mm:add_condition("override_text " .. stage_data.mission_text)
				mm:set_mission_issuer("CLAN_ELDERS")

				if stage_data.encounter_marker_mission  then
					mm:set_position(stage_data.marker_parameters.x_pos, stage_data.marker_parameters.y_pos)
				end

				if stage_data.payload then
					if is_table(stage_data.payload) then
						for i = 1, #stage_data.payload do
							mm:add_payload(stage_data.payload[i])
						end
					else
						mm:add_payload(stage_data.payload)
					end
				else
					script_error("ERROR: middenland_narrative mission for stage: ".. stage .. " has no payload setup.")
				end

				if stage_data.failure_payload then
					if is_table(stage_data.failure_payload) then
						for i = 1, #stage_data.failure_payload do
							mm:add_failure_payload(stage_data.failure_payload)
						end
					else
						mm:add_failure_payload(stage_data.failure_payload)
					end
				end

				if stage_data.mission_duration then
					mm:set_turn_limit(stage_data.mission_duration)
				end

				mm:trigger()
			end

			if stage_data.spawn_marker_on_mission_start then
				middenland_narrative:spawn_interaction_marker(middenland_narrative:make_marker_parameters(stage_data.marker_parameters, true))
			end

			middenland_narrative:trigger_stage_callback(stage_data)
			middenland_narrative:update_triggered_stages(act, stage)
		end,
		false
	)
end

function middenland_narrative:trigger_dilemma_from_stage_data(act, stage, stage_data, condititon_params)
	
	if middenland_narrative:was_stage_triggered(act, stage) then
		return
	end

	core:add_listener(
		"MiddenlandNarrativeDilemmaListener_" .. act .. stage,
		condititon_params.event_to_listen,
		function(context)
			return condititon_params.filter(context)
		end,
		function(context)
			if stage_data.key == "wh3_dlc29_emp_middenland_scour_the_forest_laurelorn_dilemma"
				and middenland_narrative:get_last_completed_act() >= 3
			then
				-- The laurelorn dilemma's payload is directly related to the act3 final battle
				return
			end

			cm:trigger_dilemma(middenland_narrative.config.boris_faction_key, stage_data.key)
			middenland_narrative:trigger_stage_callback(stage_data)
			middenland_narrative:update_triggered_stages(act, stage)
		end,
		false
	)
end

function middenland_narrative:trigger_invasion_from_stage_data(act, stage, stage_data, condititon_params)

	if middenland_narrative:was_stage_triggered(act, stage) then
		return
	end
	
	core:add_listener(
		"MiddenlandNarrativeInvasionListener_" .. act .. stage,
		condititon_params.event_to_listen,
		function(context)
			return condititon_params.filter(context)
		end,
		function()
			if stage_data.invasion_params.act_2_mission_invasion then
				local invasions_to_spawn = middenland_narrative.config.act_2_default_invasions
				for i = 1, invasions_to_spawn do
					middenland_narrative:spawn_invasion_marker(stage_data.objective_of_mission)
				end
				middenland_narrative.persistent.act_2_spawned_invasion_markers = invasions_to_spawn
			else
				middenland_narrative:spawn_beastmen_invasion(stage_data.invasion_params.x, stage_data.invasion_params.y, stage_data.objective_of_mission, true)
			end
			middenland_narrative:trigger_stage_callback(stage_data)
			middenland_narrative:update_triggered_stages(act, stage)
		end,
		false
	)

end

function middenland_narrative:trigger_dummy_from_stage_data(act, stage, stage_data, condititon_params)

	if middenland_narrative:was_stage_triggered(act, stage) then
		return
	end
	
	core:add_listener(
		"MiddenlandNarrativeDummyListener_" .. act .. stage,
		condititon_params.event_to_listen,
		function(context)
			return condititon_params.filter(context)
		end,
		function()
			middenland_narrative:trigger_stage_callback(stage_data)
			middenland_narrative:update_triggered_stages(act, stage)
		end,
		false
	)

end

function middenland_narrative:trigger_stage_callback(stage_data)
	if stage_data.callback then
		if stage_data.callback_parameters then
			if is_table(stage_data.callback_parameters) then
				middenland_narrative.stage_callbacks[stage_data.callback](unpack(stage_data.callback_parameters))
			else
				middenland_narrative.stage_callbacks[stage_data.callback](stage_data.callback_parameters)
			end
		else
			middenland_narrative.stage_callbacks[stage_data.callback]()
		end
	end
end

--------------------------------------------------------------
---------------------- PERSISTENT DATA -----------------------
--------------------------------------------------------------

function middenland_narrative:get_all_act_mission_keys(act_name)

	local act_mission_key_list = {}

	if middenland_narrative.stage_config[act_name] then
		for stage, stage_data in dpairs(middenland_narrative.stage_config[act_name]) do
			if stage_data.stage_type == "mission" then
				table.insert(act_mission_key_list, stage_data.key)
			end
		end
	end

	return act_mission_key_list
end

function middenland_narrative:get_stage_from_mission_key(mission_key)
	for act, act_data in dpairs(middenland_narrative.stage_config) do
		for stage, stage_data in dpairs(act_data) do
			if stage_data.stage_type == "mission" and stage_data.key == mission_key then
				return act, stage
			end
		end
	end
	return nil
end

function middenland_narrative:was_stage_triggered(act, stage)
	for _ , triggered_stage in dpairs(middenland_narrative.persistent.triggered_stages) do
		if triggered_stage.act == act and triggered_stage.stage == stage then
			return true
		end
	end
	return false
end

function middenland_narrative:update_mission_stage_progression(completed_mission_key, is_success)

	local current_act, current_stage = middenland_narrative:get_stage_from_mission_key(completed_mission_key)
	table.insert(middenland_narrative.persistent.completed_missions, {act = current_act, mission = completed_mission_key, success = is_success})

	local all_current_act_mission_keys = middenland_narrative:get_all_act_mission_keys(current_act)
	local total_current_act_missions = table.size(all_current_act_mission_keys)

	local completed_act_missions = 0
	for _, completed_mission_data in dpairs(middenland_narrative.persistent.completed_missions) do
		if completed_mission_data.act == current_act then
			completed_act_missions = completed_act_missions + 1
		end
	end
	if completed_act_missions >= total_current_act_missions then
		table.insert(middenland_narrative.persistent.completed_acts, current_act)
	end

end

function middenland_narrative:update_triggered_stages(triggered_act, triggered_stage)
	table.insert(middenland_narrative.persistent.triggered_stages, {act = triggered_act, stage = triggered_stage})
end

function middenland_narrative:get_last_completed_act()
	if table.contains(middenland_narrative.persistent.completed_acts, "act_3") then
		return 3
	elseif table.contains(middenland_narrative.persistent.completed_acts, "act_2") then
		return 2
	elseif table.contains(middenland_narrative.persistent.completed_acts, "act_1") then
		return 1
	else 
		-- No acts have been completed
		return -1
	end
end

--------------------------------------------------------------
--------------------- MARKER FUNCTIONS -----------------------
--------------------------------------------------------------

function middenland_narrative:spawn_interaction_marker(marker_id, marker_info, x_pos, y_pos, scroll_camera)
	cm:add_interactable_campaign_marker(marker_id, marker_info, x_pos, y_pos, 2, middenland_narrative.config.boris_faction_key, "")
	if scroll_camera then
		local display_x, display_y = cm:log_to_dis(x_pos, y_pos)
		local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
		cm:scroll_camera_from_current(false, 2, {display_x, display_y, cached_d, 0, cached_h})
	end
end

function middenland_narrative:build_invasion_marker_info(threat, timer)
	local marker_info = middenland_narrative.marker_config.invasions.middenland_invasion_marker.marker_info
	return marker_info:gsub("THREAT", threat):gsub("TIMER", timer)
end

function middenland_narrative:generate_invasion_marker_id(timer, x_pos, y_pos)
	return middenland_narrative.marker_config.invasions.middenland_invasion_marker.id .. "_TIMER=" .. timer .. "_" .. x_pos .. y_pos .. os.clock()
end

function middenland_narrative:is_there_marker(x_pos, y_pos)
	for _, marker_data in dpairs(middenland_narrative.persistent.active_invasion_marker_list) do
		if marker_data[2] == x_pos and marker_data[3] == y_pos then
			return true
		end
	end

	return false
end

function middenland_narrative:spawn_invasion_marker(mission_key)
	local tries = 0
	local max_tries = 10
	local x_pos = -1
	local y_pos = -1
	
	-- pick random region to spawn invasion marker
	local random_region_key = middenland_narrative.config.drakwald_threat.random_invasion_regions[cm:random_number(table.size(middenland_narrative.config.drakwald_threat.random_invasion_regions), 1)]

	while x_pos == -1 and tries < max_tries do
		x_pos, y_pos = middenland_narrative:find_invasion_spawn_location_from_region(random_region_key)
		if middenland_narrative:is_there_marker(x_pos, y_pos) then
			x_pos, y_pos = -1, -1
		end
		tries = tries + 1
	end

	-- Get marker position from act 1 mission as fallback
	if x_pos == -1 then
		x_pos, y_pos = middenland_narrative:find_invasion_spawn_location_from_position(middenland_narrative.marker_config.act_1.mission_1.x_pos, middenland_narrative.marker_config.act_1.mission_1.y_pos, 0, 10)
		if middenland_narrative:is_there_marker(x_pos, y_pos) then
			x_pos, y_pos = -1, -1
		end
		if x_pos == -1 then
			script_error("ERROR: Failed to spawn middenland narrative act 2 invasion marker")
			return
		end
	end
	
	-- Don't trigger incident and scroll camera for act 2 invasions due to spawning multiple markers
	local random_incident_key = nil
	if middenland_narrative:get_last_completed_act() > 1 then
		random_incident_key = middenland_narrative.marker_config.marker_spawn_incidents[cm:random_number(#middenland_narrative.marker_config.marker_spawn_incidents, 1)]
	else
		cm:show_message_event_located(
			middenland_narrative.config.boris_faction_key,
			middenland_narrative.marker_config.marker_initial_warning_event.title,
			middenland_narrative.marker_config.marker_initial_warning_event.primary_detail,
			middenland_narrative.marker_config.marker_initial_warning_event.secondary_detail,
			x_pos,
			y_pos,
			true,
			middenland_narrative.marker_config.marker_initial_warning_event.criteria_value
		)
	end

	middenland_narrative:spawn_invasion_marker_internal(mission_key, random_incident_key, x_pos, y_pos, middenland_narrative.config.drakwald_threat.invasion_marker_lifetime)
end

function middenland_narrative:spawn_invasion_marker_internal(mission_key, incident_key, x_pos, y_pos, timer)
	local marker_info = middenland_narrative:build_invasion_marker_info(middenland_narrative.persistent.drakwald_threat_level, timer)
	local generated_marker_id = middenland_narrative:generate_invasion_marker_id(timer, x_pos, y_pos)

	if incident_key ~= nil then
		cm:trigger_incident(middenland_narrative.config.boris_faction_key, incident_key, true, true)
	end

	middenland_narrative:spawn_interaction_marker(generated_marker_id, marker_info, x_pos, y_pos, incident_key ~= nil)

	cm:add_turn_countdown_event(middenland_narrative.config.boris_faction_key, 1, "ScriptEventInvasionMarkerExpired", generated_marker_id)
	
	table.insert(middenland_narrative.persistent.active_invasion_marker_list, {generated_marker_id, x_pos, y_pos, mission_key})
	middenland_narrative:add_invasion_marker_interaction_listeners(generated_marker_id, x_pos, y_pos, mission_key)
end

function middenland_narrative:remove_marker(marker_id, listeners)
	cm:remove_interactable_campaign_marker(marker_id)
	if listeners then
		if is_table(listeners) then
			for i = 1, #listeners do
				core:remove_listener(listeners[i])
			end
		else
			core:remove_listener(listeners)
		end
	end
end

function middenland_narrative:add_encounter_marker_interaction_listeners(stage, stage_data)

	local marker_id = stage_data.marker_parameters.id

	core:add_listener(
		"Middenland_Narrative_Encounter_Marker_Interaction_Success_" .. marker_id,
		"AreaEntered",
		function(context)
			local character = context:family_member():character()
			return not character:is_null_interface() and character:has_military_force() and character:faction():name() == middenland_narrative.config.boris_faction_key and context:area_key() == marker_id
		end,
		function()
			-- Basic marker missions are compelted after resolving marker.
			if stage_data.mission_complete_condition == "marker_resolved" then
				cm:complete_scripted_mission_objective(middenland_narrative.config.boris_faction_key, stage_data.key, stage_data.key, true)
			end
			middenland_narrative:update_mission_stage_progression(stage_data.key, true)
			middenland_narrative:remove_marker(
				marker_id, 
				{
					"Middenland_Narrative_Encounter_Marker_Interaction_Success_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Failed_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Cancelled_" .. stage,
				}
			)
		end,
		false
	)

	core:add_listener(
		"Middenland_Narrative_Encounter_Marker_Interaction_Failed_" .. marker_id,
		"MissionFailed",
		function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key and context:mission():mission_record_key() == stage_data.key
		end,
		function(context)
			middenland_narrative:update_mission_stage_progression(stage_data.key, false)
			middenland_narrative:remove_marker(
				marker_id,
				{
					"Middenland_Narrative_Encounter_Marker_Interaction_Success_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Failed_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Cancelled_" .. stage,
				}
			)
		end,
		false
	)

	core:add_listener(
		"Middenland_Narrative_Encounter_Marker_Interaction_Cancelled_" .. marker_id,
		"MissionCancelled",
		function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key and context:mission():mission_record_key() == stage_data.key
		end,
		function(context)
			middenland_narrative:update_mission_stage_progression(stage_data.key, false)
			middenland_narrative:remove_marker(
				marker_id,
				{
					"Middenland_Narrative_Encounter_Marker_Interaction_Success_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Failed_" .. stage,
					"Middenland_Narrative_Encounter_Marker_Interaction_Cancelled_" .. stage,
				}
			)
		end,
		false
	)

end

function middenland_narrative:add_invasion_marker_interaction_listeners(marker_id, x_pos, y_pos, mission_key)
	core:add_listener(
		"Middenland_Narrative_Invasion_Marker_Interaction_" .. marker_id,
		"AreaEntered",
		function(context)
			local character = context:family_member():character()
			return not character:is_null_interface() and character:has_military_force() and character:faction():name() == middenland_narrative.config.boris_faction_key and marker_id == context:area_key()
		end,
		function(context)
			middenland_narrative:invasion_marker_interacted(marker_id, x_pos, y_pos, mission_key, true, true)
		end,
		false
	)

	core:add_listener(
		"Middenland_Narrative_Invasion_Marker_Expired_" .. marker_id,
		"ScriptEventInvasionMarkerExpired",
		function(context)
			return context.string == marker_id
		end,
		function(context)
			local remaining_cooldown = 0
			local timer = tonumber(marker_id:match("_TIMER=(%d+)_"))

			if timer == 1 or timer == nil then
				middenland_narrative:invasion_marker_interacted(marker_id, x_pos, y_pos, mission_key, false, true)
			else
				middenland_narrative:respawn_invasion_marker(marker_id, x_pos, y_pos, mission_key, timer - 1)
			end
		end,
		false
	)
end

function middenland_narrative:respawn_invasion_marker(marker_id, x_pos, y_pos, mission_key, timer)
	middenland_narrative:invasion_marker_interacted(marker_id, x_pos, y_pos, mission_key, false, false)
	middenland_narrative:spawn_invasion_marker_internal(mission_key, nil, x_pos, y_pos, timer)

	if timer == 1 then
		cm:show_message_event_located(
			middenland_narrative.config.boris_faction_key,
			middenland_narrative.marker_config.marker_final_warning_event.title,
			middenland_narrative.marker_config.marker_final_warning_event.primary_detail,
			middenland_narrative.marker_config.marker_final_warning_event.secondary_detail,
			x_pos,
			y_pos,
			true,
			middenland_narrative.marker_config.marker_final_warning_event.criteria_value
		)
	end
end

function middenland_narrative:invasion_marker_interacted(marker_id, x_pos, y_pos, mission_key, marker_resolved, spawn_invasion)
	local marker_idx_to_remove
	for idx, marker_data in dpairs(middenland_narrative.persistent.active_invasion_marker_list) do
		if table.contains(marker_data, marker_id) then
			middenland_narrative:remove_marker(marker_id, "Middenland_Narrative_Invasion_Marker_Expired_" .. marker_id)
			marker_idx_to_remove = idx
			if spawn_invasion then
				middenland_narrative:spawn_beastmen_invasion(x_pos, y_pos, mission_key, marker_resolved)
			end
		end
	end
	if marker_idx_to_remove then
		table.remove(middenland_narrative.persistent.active_invasion_marker_list, marker_idx_to_remove)
	end
end

function middenland_narrative:make_marker_parameters(marker_parameters, scroll_camera_to_marker)
	local marker_id = marker_parameters.id
	local marker_info = marker_parameters.marker_info
	local x_pos = marker_parameters.x_pos
	local y_pos = marker_parameters.y_pos
	return marker_id, marker_info, x_pos, y_pos, scroll_camera_to_marker
end

function middenland_narrative:initialise_stored_invasion_marker_interaction_listeners()
	for _, marker_data in dpairs(middenland_narrative.persistent.active_invasion_marker_list) do
		middenland_narrative:add_invasion_marker_interaction_listeners(unpack(marker_data))
	end
end

function middenland_narrative:remove_all_invasion_markers()
	for _, marker_data in dpairs(middenland_narrative.persistent.active_invasion_marker_list) do
		middenland_narrative:remove_marker(
			marker_data.marker_id,
			"Middenland_Narrative_Invasion_Marker_Expired_" .. marker_data.marker_id
		)
		middenland_narrative:remove_marker(
			marker_data.marker_id,
			"Middenland_Narrative_Invasion_Marker_Interaction_" .. marker_data.marker_id
		)
	end
end

--------------------------------------------------------------
--------------- BEASTMEN INVASION FUNCTIONS ------------------
--------------------------------------------------------------

function middenland_narrative:add_invasion_defeated_listeners(stage, stage_data)

	-- Adds listener to check if defeated invasion was related to any mission (act 2 Repel the Assault / act 3 Scour the forest) and complete the mission if all required invasions are defeated
	core:add_listener(
		"Middenland_Narrative_Invasion_Defeated_" .. stage_data.key,
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_lost_battle(middenland_narrative.config.beastmen_invasion_faction_key) 
				and cm:model():pending_battle():has_been_fought() 
		end,
		function()
			local mission_entries_to_remove = {}
			local mission_complete = false
			for mission_key, mf_cqi_list in dpairs(middenland_narrative.persistent.spawned_mission_objective_invasion_mfs) do
				local mf_indexes_to_remove = {}
				for i = 1, #mf_cqi_list do
					if cm:pending_battle_cache_mf_is_involved(mf_cqi_list[i]) then
						table.insert(mf_indexes_to_remove, i)

						if mission_key == middenland_narrative.stage_config.act_2.stage_2_mission.key then
							middenland_narrative.persistent.act_2_invasion_forces_defeated = middenland_narrative.persistent.act_2_invasion_forces_defeated + 1
						end
					end
				end
				if not table.is_empty(mf_indexes_to_remove) then
					for j = 1, #mf_indexes_to_remove do
						table.remove(mf_cqi_list, mf_indexes_to_remove[j])
					end

					-- To complete act 2 mission - need to make sure all forces were spawned and defeated as they spawn gradually
					-- For other missions just check if spawned forces were defeated as they spawn all at once
					if table.is_empty(mf_cqi_list) then
						if mission_key == middenland_narrative.stage_config.act_2.stage_2_mission.key then
							if middenland_narrative.persistent.act_2_invasion_forces_defeated >= middenland_narrative.persistent.act_2_spawned_invasion_markers then
								mission_complete = true
							end
						else
							mission_complete = true
						end
					end

					if mission_complete then
						cm:complete_scripted_mission_objective(middenland_narrative.config.boris_faction_key, mission_key, mission_key, true)
						core:remove_listener("Middenland_Narrative_Invasion_Defeated_" .. stage_data.key)
						middenland_narrative:update_mission_stage_progression(mission_key, true)
						table.insert(mission_entries_to_remove, mission_key)
					end
				end
			end

			if not table.is_empty(mission_entries_to_remove) then
				for i = 1, #mission_entries_to_remove do
					middenland_narrative.persistent.spawned_mission_objective_invasion_mfs[mission_entries_to_remove[i]] = nil
				end
			end
		end,
		true
	)
end

function middenland_narrative:find_invasion_spawn_location_from_position(x, y, distance_min, distance_max)
	local x_pos = -1
	local y_pos = -1
	local distance = cm:random_number(distance_max, distance_min)
	x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_position("rebels", x, y, true, distance)
	if x_pos == -1 then
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_position("rebels", x, y, false, distance)
	end
	return x_pos, y_pos
end

function middenland_narrative:find_invasion_spawn_location_from_region(region_key)

	local region_obj = cm:get_region(region_key)
	local settlement_obj = region_obj:settlement()

	local origin_x = settlement_obj:logical_position_x()
	local origin_y = settlement_obj:logical_position_y()

	local spawn_x, spawn_y = middenland_narrative:find_invasion_spawn_location_from_position(origin_x, origin_y, middenland_narrative.config.invasion_force_spawn_distance_from_settlement_min, middenland_narrative.config.invasion_force_spawn_distance_from_settlement_max)

	return spawn_x, spawn_y
end

function middenland_narrative:spawn_beastmen_invasion(x, y, mission_key, marker_resolved)
	local invasion_faction_key = middenland_narrative.config.beastmen_invasion_faction_key

	local tries = 0
	local max_tries = 10
	local x_pos = -1
	local y_pos = -1
	
	while x_pos == -1 and tries < max_tries do
		x_pos, y_pos = middenland_narrative:find_invasion_spawn_location_from_position(x, y, middenland_narrative.config.invasion_force_spawn_distance_from_marker_min, middenland_narrative.config.invasion_force_spawn_distance_from_marker_max)
		tries = tries + 1
	end

	-- fallback to marker position
	if x_pos == -1 then
		x_pos, y_pos = middenland_narrative:find_invasion_spawn_location_from_position(x, y, 0, 0)
		if x_pos == -1 then
			script_error("ERROR: Failed to spawn army for middenland narrative invasion at x: " .. x .. " y: " .. y)
			return
		end
	end

	-- generate unique invasion key for invasion manager to be able to spawn new invasion
	tries = 0
	local invasion_key = "middenland_narrative_invasion_key" .. x_pos .. y_pos
	while invasion_manager:get_invasion(invasion_key) and tries < max_tries do
		invasion_key = invasion_key .. os.clock()
		tries = tries + 1
	end

	if invasion_manager:get_invasion(invasion_key) then
		script_error("ERROR: Failed to generate unique invasion key to spawn new invasion: " .. invasion_key)
		return
	end

	local current_threat = middenland_narrative.persistent.drakwald_threat_level
	if current_threat < 1 then
		current_threat = 1
		script_error("ERROR: Trying to spawn middenland narrative invasion while drakwald threat is 0.")
	end

	local invasion_power
	local invasion_units
	local invasion_parameters = middenland_narrative.config.drakwald_threat.threat_level_to_invasion_parameters[tostring(current_threat)]

	if is_nil(invasion_parameters) then
		script_error("ERROR: Invalid invasion parameters for middenland narrative drakwald threat level: " .. current_threat)
		return
	end

	if marker_resolved then
		invasion_power = invasion_parameters.invasion_strength.resolved_marker.power
		invasion_units = invasion_parameters.invasion_strength.resolved_marker.units
	else
		invasion_power = invasion_parameters.invasion_strength.expired_marker.power
		invasion_units = invasion_parameters.invasion_strength.expired_marker.units
	end

	local unit_list = WH_Random_Army_Generator:generate_random_army(invasion_faction_key, "wh_dlc03_sc_bst_beastmen", invasion_units, invasion_power, true, false)
	local invasion_object = invasion_manager:new_invasion(invasion_key, invasion_faction_key, unit_list, {x_pos, y_pos})
	
	cm:apply_effect_bundle(middenland_narrative.config.beastmen_invasion_faction_trait_effect_bundle, invasion_faction_key, 0)
	
	invasion_object:apply_effect(middenland_narrative.config.beastmen_invasion_force_trait_effect_bundle, 0)
	invasion_object:create_general(false, middenland_narrative.config.beastmen_invasion_general_subtype)
	invasion_object:set_target("REGION", middenland_narrative.config.middenheim_region_key, middenland_narrative.config.boris_faction_key)
	invasion_object:add_aggro_radius(25, middenland_narrative.config.boris_faction_key, 1)
	invasion_object:start_invasion(true, true, false, false, false)
	
	cm:force_diplomacy("faction:" .. middenland_narrative.config.boris_faction_key, "faction:" .. invasion_faction_key, "war", false, false, true)

	cm:trigger_incident_with_targets(
		cm:get_faction(middenland_narrative.config.boris_faction_key):command_queue_index(),
		middenland_narrative.config.drakwald_threat.beastmen_spawned_incident_key,
		0,
		0,
		0,
		invasion_object.force_cqi,
		0,
		0
	)

	-- Store invasion force_cqi if it's related to any mission to check for mission completion
	if mission_key then
		if middenland_narrative.persistent.spawned_mission_objective_invasion_mfs[mission_key] then
			local mf_cqi_list = middenland_narrative.persistent.spawned_mission_objective_invasion_mfs[mission_key]
			table.insert(mf_cqi_list, invasion_object.force_cqi)
			middenland_narrative.persistent.spawned_mission_objective_invasion_mfs[mission_key] = mf_cqi_list
		else
			middenland_narrative.persistent.spawned_mission_objective_invasion_mfs[mission_key] = {invasion_object.force_cqi}
		end
	end
end

--------------------------------------------------------------
------------- DRAKWALD THREAT LEVEL FUNCTIONS ----------------
--------------------------------------------------------------

function middenland_narrative:set_drakwald_threat_level(value)
	value = math.clamp(value, 0, 3)
	local change = value - middenland_narrative.persistent.drakwald_threat_level
	middenland_narrative.persistent.drakwald_threat_level = value
	local cfg = middenland_narrative.config
	cm:faction_add_pooled_resource(cfg.boris_faction_key, cfg.drakwald_threat.pooled_resource, cfg.drakwald_threat.pooled_resource_factor, change)
end

function middenland_narrative:set_drakwald_threat_feature_enabled(feature_state)

	-- TODO: calls to enable/disable UI feature for act 1/2 faking
	if feature_state then
		middenland_narrative.persistent.drakwald_threat_enabled = true
		middenland_narrative:initialise_drakwald_threat()
	else
		middenland_narrative.persistent.drakwald_threat_enabled = false
		middenland_narrative:set_drakwald_threat_level(0)
		core:remove_listener("Drakwald_Threat_Increasing")
		core:remove_listener("Drakwald_Spawn_Invasion_Marker")
		core:remove_listener("Middenland_Narrative_Beastmen_Invasion_Battle_Reduce_Drakwald_Threat")
	end
	cm:set_script_state(middenland_narrative.config.drakwald_threat.shared_state_enabled, middenland_narrative.persistent.drakwald_threat_enabled)
end

function middenland_narrative:initialise_drakwald_threat()
	
	-- Drakwald threat feature only functions after act 2 completion before act 3 is finished
	if not middenland_narrative.persistent.drakwald_threat_enabled then
		return
	end

	-- Init turn countdown when initialising the threat mechanic
	middenland_narrative.persistent.threat_level_increased_at_turn_number = cm:turn_number()


	core:add_listener(
		"Drakwald_Spawn_Invasion_Marker",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == middenland_narrative.config.boris_faction_key
		end,
		function(context)

			local current_threat = middenland_narrative.persistent.drakwald_threat_level
			local chance_to_spawn = middenland_narrative.config.drakwald_threat.threat_level_to_invasion_parameters[tostring(current_threat)].spawn_chance
			
			local marker_buffer_remaining_turn_count = middenland_narrative.persistent.invasion_marker_buffer_time
			local attempt_to_spawn_marker = true

			if marker_buffer_remaining_turn_count ~= nil and  marker_buffer_remaining_turn_count > 0 then
				middenland_narrative.persistent.invasion_marker_buffer_time = marker_buffer_remaining_turn_count - 1
				attempt_to_spawn_marker = false
			end

			if cm:model():random_percent(chance_to_spawn) and attempt_to_spawn_marker then
				middenland_narrative:spawn_invasion_marker()

				middenland_narrative.persistent.invasion_marker_buffer_time = middenland_narrative.config.drakwald_threat.invasion_marker_buffer_time_max
			end
		end,
		true
	)

	core:add_listener(
		"Middenland_Narrative_Beastmen_Invasion_Battle_Reduce_Drakwald_Threat",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_lost_battle(middenland_narrative.config.beastmen_invasion_faction_key) and cm:model():pending_battle():has_been_fought()
		end,
		function()
			if middenland_narrative.persistent.drakwald_threat_level > 1 then
				middenland_narrative:set_drakwald_threat_level(middenland_narrative.persistent.drakwald_threat_level - 1)
				cm:trigger_incident(middenland_narrative.config.boris_faction_key, middenland_narrative.config.drakwald_threat.threat_incidents.threat_decrease, true, true)
			end
		end,
		true
	)
end

function middenland_narrative:launch_drakwald_threat_cycle(turns_to_trigger_threat_increase)
	
	cm:add_turn_countdown_event(middenland_narrative.config.boris_faction_key, turns_to_trigger_threat_increase, "ScriptEventIncreaseDrakwaldThreatLevel")

	core:add_listener(
		"Drakwald_Threat_Increasing",
		"ScriptEventIncreaseDrakwaldThreatLevel",
		true,
		function()
			if middenland_narrative.persistent.drakwald_threat_level < 3 then
				middenland_narrative:set_drakwald_threat_level(middenland_narrative.persistent.drakwald_threat_level + 1)
				cm:trigger_incident(middenland_narrative.config.boris_faction_key, middenland_narrative.config.drakwald_threat.threat_incidents.threat_increase, true, true)
			end

			middenland_narrative:launch_drakwald_threat_cycle(cm:random_number(middenland_narrative.config.drakwald_threat.threat_increase_turns_interval.min, middenland_narrative.config.drakwald_threat.threat_increase_turns_interval.max))
		end,
		false
	)
end



--------------------------------------------------------------
--------------------- SAVING / LOADING -----------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("middenland_narrative.persistent", middenland_narrative.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			middenland_narrative.persistent = cm:load_named_value("middenland_narrative.persistent", middenland_narrative.persistent, context)
		end
	end
)