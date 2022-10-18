local wulfhart_faction = "wh2_dlc13_emp_the_huntmarshals_expedition"
local lizardmen_culture = "wh2_main_lzd_lizardmen"
local wulfhart_hunter_keys = {
	"wh2_dlc13_emp_hunter_doctor_hertwig_van_hal",
	"wh2_dlc13_emp_hunter_jorek_grimm",
	"wh2_dlc13_emp_hunter_kalara_of_wydrioth",
	"wh2_dlc13_emp_hunter_rodrik_l_anguille"
}

function add_wulfhart_hunters_listeners()
	out("#### Adding Wulfhart Hunters Listeners ####")
	
	local wulfhart_interface = cm:get_faction(wulfhart_faction)
	local wulfhart_is_human = wulfhart_interface:is_human()

	if cm:is_new_game() then
		if wulfhart_is_human then
			cm:callback(
				function()
					cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_jorek_grimm_stage_1", true)
					cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_hertwig_van_hal_stage_1", true)
					cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_kalara_stage_1", true)
					cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_rodrik_languille_stage_1", true)
				end,
				0.5
			)
		end
	end

	cm:force_diplomacy("faction:" .. wulfhart_faction, "culture:" .. lizardmen_culture, "all", false, false, true)
	cm:force_diplomacy("faction:" .. wulfhart_faction, "culture:" .. lizardmen_culture, "payments", true, true, true)
	cm:force_diplomacy("faction:" .. wulfhart_faction, "culture:" .. lizardmen_culture, "war", true, true, true)
	cm:force_diplomacy("faction:" .. wulfhart_faction, "culture:" .. lizardmen_culture, "peace", true, true, true)
	
	-- allow diplomacy between team mates in multiplayer
	if wulfhart_is_human then
		local team_mates = wulfhart_interface:team_mates()
		
		for i = 0, team_mates:num_items() - 1 do
			local current_team_mate = team_mates:item_at(i)
			
			if current_team_mate:culture() == lizardmen_culture then
				cm:force_diplomacy("faction:" .. wulfhart_faction, "faction:" .. current_team_mate:name(), "all", true, true, true)
			end
		end
	end
	
	core:add_listener(
		"HunterSpawned",
		"UniqueAgentSpawned",
		function(context)
			return context:unique_agent_details():character():character_subtype_key():starts_with("wh2_dlc13_emp_hunter_")
		end,
		function(context)
			local unique_agent = context:unique_agent_details():character()
			local unique_agent_subtype = unique_agent:character_subtype_key()
			
			if unique_agent_subtype == "wh2_dlc13_emp_hunter_kalara_of_wydrioth" then
				cm:set_saved_value("hunter_kalara_unlocked", 2)
			elseif unique_agent_subtype == "wh2_dlc13_emp_hunter_jorek_grimm" then
				cm:set_saved_value("hunter_jorek_unlocked", 2)
			elseif unique_agent_subtype == "wh2_dlc13_emp_hunter_rodrik_l_anguille" then
				cm:set_saved_value("hunter_rodrik_unlocked", 2)
			elseif unique_agent_subtype == "wh2_dlc13_emp_hunter_doctor_hertwig_van_hal" then
				cm:set_saved_value("hunter_hertwig_unlocked", 2)
			end
			
			cm:replenish_action_points(cm:char_lookup_str(unique_agent))
		end,
		true
	)
	
	cm:add_faction_turn_start_listener_by_name(
		"HunterFailedToSpawn",
		wulfhart_faction,
		function(context)
			local wulfhart_cqi = context:faction():command_queue_index()
			
			if cm:get_saved_value("hunter_kalara_unlocked") == 1 then
				cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_kalara_of_wydrioth", false)
			end
			
			if cm:get_saved_value("hunter_jorek_unlocked") == 1 then
				cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_jorek_grimm", false)
			end
			
			if cm:get_saved_value("hunter_rodrik_unlocked") == 1 then
				cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_rodrik_l_anguille", false)
			end
			
			if cm:get_saved_value("hunter_hertwig_unlocked") == 1 then
				cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_doctor_hertwig_van_hal", false)
			end
		end,
		true
	)
	
	core:add_listener(
		"HunterMissionsSucceeded",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == wulfhart_faction
		end,
		function(context)
			wulfhart_missions_updated(context:mission():mission_record_key())
		end,
		true
	)
	
	core:add_listener(
		"HunterMissionsCancelled",
		"MissionCancelled",
		function(context)
			return context:faction():name() == wulfhart_faction
		end,
		function(context)
			wulfhart_missions_updated(context:mission():mission_record_key())
		end,
		true
	)
	
	core:add_listener(
		"HunterMissionsGenerationFailed",
		"MissionGenerationFailed",
		true,
		function(context)
			local mission = context:mission()
			
			if mission == "wh2_dlc13_wulfhart_rodrik_languille_stage_2" then
				cm:trigger_dilemma(wulfhart_faction, "wh2_dlc13_wulfhart_rodrik_languille_stage_2_dilemma")
			elseif mission == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_4" then
				cm:trigger_dilemma(wulfhart_faction, "wh2_dlc13_wulfhart_hertwig_van_hal_stage_4_dilemma")
			elseif mission == "wh2_dlc13_wulfhart_kalara_stage_2" then
				cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_kalara_stage_3", true)
			elseif mission == "wh2_dlc13_wulfhart_rodrik_languille_stage_3" then
				cm:trigger_mission(wulfhart_faction, "wh2_dlc13_wulfhart_rodrik_languille_stage_4", true)
			end
		end,
		true
	)

	if wulfhart_is_human == false then
		core:add_listener(
			"Hunters_AiBehaviour",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == wulfhart_faction and wulfhart_interface:has_home_region()
			end,
			function()
				local turn_number = cm:model():turn_number()
				local wulfhart_faction_cqi = wulfhart_interface:command_queue_index()
				local wulfhart_capital_cqi = wulfhart_interface:home_region():cqi()
				if turn_number == 1 then
					cm:spawn_unique_agent_at_region(wulfhart_faction_cqi, wulfhart_hunter_keys[1],wulfhart_capital_cqi, false)
				elseif turn_number == 10 then
					cm:spawn_unique_agent_at_region(wulfhart_faction_cqi, wulfhart_hunter_keys[2],wulfhart_capital_cqi, false)
				elseif turn_number == 20 then
					cm:spawn_unique_agent_at_region(wulfhart_faction_cqi, wulfhart_hunter_keys[3],wulfhart_capital_cqi, false)
				elseif turn_number == 30 then
					cm:spawn_unique_agent_at_region(wulfhart_faction_cqi, wulfhart_hunter_keys[4],wulfhart_capital_cqi, false)
				end
			end,
			true
		)
	end
end

function wulfhart_missions_updated(mission_key)
	local wulfhart_interface = cm:get_faction(wulfhart_faction)
	local wulfhart_cqi = wulfhart_interface:command_queue_index()
	local incident_key = false
	
	-- KALARA
	if mission_key == "wh2_dlc13_wulfhart_kalara_stage_1" then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
		
		cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_kalara_of_wydrioth", false)
		cm:set_saved_value("hunter_kalara_unlocked", 1)
		core:trigger_event("HunterUnlocked")
		
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			end,
			0.2
		)
		
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_join", wulfhart_faction) end, 0.5)
		
		incident_key = "wh2_dlc13_wulfhart_kalara_stage_1_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_kalara_stage_2" then
		incident_key = "wh2_dlc13_wulfhart_kalara_stage_2_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_kalara_stage_3" then
		cm:callback(
			function()
				local wulfhart_char_list = wulfhart_interface:character_list()
				
				for i = 0, wulfhart_char_list:num_items() - 1 do
					local wulfhart_char = wulfhart_char_list:item_at(i)
					if wulfhart_char:character_subtype_key() == "wh2_dlc13_emp_hunter_kalara_of_wydrioth" then
						cm:force_add_trait(cm:char_lookup_str(wulfhart_char), "wh2_dlc13_trait_kalara_pursuer")
						break
					end
				end
				
				cm:remove_effect_bundle("wh2_dlc13_payload_hunter_kalara_dummy", wulfhart_faction)
			end,
			0.5
		)
		
		incident_key = "wh2_dlc13_wulfhart_kalara_stage_3_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_kalara_stage_4" then
		incident_key = "wh2_dlc13_wulfhart_kalara_stage_4_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_kalara_stage_5" then
		incident_key = "wh2_dlc13_wulfhart_kalara_stage_5_incident"
		cm:set_saved_value("hunter_kalara_complete", true)
		core:trigger_event("ScriptEventHunterStoryCompleted")
		
	-- JOREK
	elseif mission_key == "wh2_dlc13_wulfhart_jorek_grimm_stage_1" then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
		
		cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_jorek_grimm", false)
		cm:set_saved_value("hunter_jorek_unlocked", 1)
		core:trigger_event("HunterUnlocked")
		
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			end,
			0.2
		)
		
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_join", wulfhart_faction) end, 0.5)
		
		incident_key = "wh2_dlc13_wulfhart_jorek_grimm_stage_1_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_jorek_grimm_stage_2" then
		incident_key = "wh2_dlc13_wulfhart_jorek_grimm_stage_2_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_jorek_grimm_stage_3" then
		incident_key = "wh2_dlc13_wulfhart_jorek_grimm_stage_3_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_jorek_grimm_stage_4" then
		incident_key = "wh2_dlc13_wulfhart_jorek_grimm_stage_4_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_jorek_grimm_stage_5" then
		cm:set_saved_value("hunter_jorek_complete", true)
		core:trigger_event("ScriptEventHunterStoryCompleted")
		
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_dilemma", wulfhart_faction) end, 0.5)
		
	-- HERTWIG
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_1" then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
		
		cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_doctor_hertwig_van_hal", false)
		cm:set_saved_value("hunter_hertwig_unlocked", 1)
		core:trigger_event("HunterUnlocked")
		
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			end,
			0.2
		)
		
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_join", wulfhart_faction) end, 0.5)
		
		incident_key = "wh2_dlc13_wulfhart_hertwig_van_hal_stage_1_incident"			
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_2" then
		incident_key = "wh2_dlc13_wulfhart_hertwig_van_hal_stage_2_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_3" then
		incident_key = "wh2_dlc13_wulfhart_hertwig_van_hal_stage_3_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_4" then
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_dilemma", wulfhart_faction) end, 0.5)
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_5a" then
		incident_key = "wh2_dlc13_wulfhart_hertwig_van_hal_stage_5a_incident"
		cm:set_saved_value("hunter_hertwig_complete", true)
		core:trigger_event("ScriptEventHunterStoryCompleted")
	elseif mission_key == "wh2_dlc13_wulfhart_hertwig_van_hal_stage_5b" then
		incident_key = "wh2_dlc13_wulfhart_hertwig_van_hal_stage_5b_incident"
		cm:set_saved_value("hunter_hertwig_complete", true)
		core:trigger_event("ScriptEventHunterStoryCompleted")
		
	-- RODRIK
	elseif mission_key == "wh2_dlc13_wulfhart_rodrik_languille_stage_1" then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
		
		cm:spawn_unique_agent(wulfhart_cqi, "wh2_dlc13_emp_hunter_rodrik_l_anguille", false)
		cm:set_saved_value("hunter_rodrik_unlocked", 1)
		core:trigger_event("HunterUnlocked")
		
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			end,
			0.2
		)
		
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_join", wulfhart_faction) end, 0.5)
		
		incident_key = "wh2_dlc13_wulfhart_rodrik_languille_stage_1_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_rodrik_languille_stage_2" then
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_dilemma", wulfhart_faction) end, 0.5)
	elseif mission_key == "wh2_dlc13_wulfhart_rodrik_languille_stage_3" then
		incident_key = "wh2_dlc13_wulfhart_rodrik_languille_stage_3_incident"
	elseif mission_key == "wh2_dlc13_wulfhart_rodrik_languille_stage_4" then
		cm:callback(function() cm:remove_effect_bundle("wh2_dlc13_payload_hunter_dilemma", wulfhart_faction) end, 0.5)
	elseif mission_key == "wh2_dlc13_wulfhart_rodrik_languille_stage_5" then
		incident_key = "wh2_dlc13_wulfhart_rodrik_languille_stage_5_incident"
		cm:set_saved_value("hunter_rodrik_complete", true)
		core:trigger_event("ScriptEventHunterStoryCompleted")
	end
	
	-- check if the incident key is an incdient or dilemma then trigger it
	if incident_key then
		cm:trigger_incident(wulfhart_faction, incident_key, true)
	end
end