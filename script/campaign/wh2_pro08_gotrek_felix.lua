local gotrek_turns_available = 30		-- Turns that Gotrek & Felix are available for the player after appearing 
local gotrek_turns_available_ai = 20	-- Turns that Gotrek & Felix are available for the AI after appearing
local gotrek_cooldown_turns = 10		-- Turns before Gotrek & Felix appear for the AI after the player has them
local gotrek_cooldown_turns_ai = 10		-- Turns before Gotrek & Felix appear for the player after the AI has them
local gotrek_spawn_turn_ai = 10			-- The turn on which Gotrek & Felix will spawn if the feature is in AI only mode
local gotrek_subculture_details = {
	["wh_main_sc_emp_empire"] = {"wh_main_emp_tavern_1"}, -- The buildings that can unlock the characters when playing as this subculture
	["wh_main_sc_brt_bretonnia"] = {"wh_main_brt_tavern_1"},
	["wh_main_sc_dwf_dwarfs"] = {"wh_main_dwf_tavern_1"},
	["wh_main_sc_teb_teb"] = {"wh_main_emp_tavern_1"},
	["wh3_main_sc_ksl_kislev"] = {"wh3_main_ksl_growth_recruit_cost_2"},
	["wh3_main_sc_cth_cathay"] = {"wh3_main_cth_growth_yin_2"}
}
local gotrek_return_events = {"emp", "brt", "dwf", "teb", "misc"}
local gotrek_state = {
	building = 1,
	marker = 2,
	spawned = 3,
	spawned_ai = 4,
	cooldown = 5,
	cooldown_ai = 6
}
local gotrek_details = {
	player_origin = false,
	owner = false,
	ai_only = false,
	state = gotrek_state.building,
	marker_pending = false,
	level = 1,
	cooldown = 0,
	spawn_turn = 0,
	gotrek_cqi = 0,
	felix_cqi = 0,
	spawn_cqi = 0,
	start_event = 0,
	current_event = 0
}

function add_gotrek_felix_listeners()
	out("#### Adding Gotrek & Felix Listeners ####")
	
	if cm:is_new_game() then
		if cm:get_local_faction(true) and cm:is_dlc_flag_enabled_by_everyone("TW_WH2_GOTREK_FELIX") then
			gotrek_details.ai_only = false
			gotrek_details.state = gotrek_state.building
			gotrek_details.cooldown = 0
		else
			-- we are in an autorun, or game where they do not own the content, so switch to ai only mode
			gotrek_details.owner = gotrek_find_available_ai_faction()
			gotrek_details.ai_only = true
			gotrek_details.state = gotrek_state.cooldown
			gotrek_details.cooldown = gotrek_spawn_turn_ai
		end
		
		gotrek_details.level = 1
		gotrek_details.spawn_turn = 0
		gotrek_details.gotrek_cqi = 0
		gotrek_details.felix_cqi = 0
	end
	
	gotrek_setup()
end

function gotrek_find_available_ai_faction()
	local faction_list = cm:model():world():faction_list()
	local possible_factions = {}
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)
		
		if not faction:is_human() and not faction:is_quest_battle_faction() and not faction:is_dead() then
			local faction_key = faction:name()
			
			if faction_key ~= "wh_main_emp_empire_separatists" and gotrek_subculture_details[faction:subculture()] then
				table.insert(possible_factions, faction_key)
			end
		end
	end
	
	return possible_factions[cm:random_number(#possible_factions)]
end

function gotrek_setup()
	-- Building Completed
	core:add_listener(
		"gotrek_BuildingCompleted",
		"BuildingCompleted",
		function(context)
			return gotrek_details.state == gotrek_state.building and context:building():faction():is_human()
		end,
		function(context)
			local building = context:building()
			local faction = building:faction()
			
			local buildings = gotrek_subculture_details[faction:subculture()]
			
			if buildings then
				for i = 1, #buildings do
					if buildings[i] == building:name() then
						local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), building:region():name(), false, true, 9)
						
						if pos_x > -1 then
							cm:add_interactable_campaign_marker("gotrek_marker", "gotrek_marker", pos_x, pos_y, 2)
							gotrek_details.state = gotrek_state.marker
							
							local function show_gotrek_and_felix_appear_event(event_faction, x, y)
								cm:show_message_event_located(
									event_faction:name(),
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_title",
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_appear_primary_detail",
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_appear_secondary_detail",
									x,
									y,
									false,
									1308
								)
							end
							
							local team_mates = faction:team_mates()
							
							for j = 0, team_mates:num_items() - 1 do
								local current_team_mate = team_mates:item_at(j)
								
								if gotrek_subculture_details[current_team_mate:subculture()] then
									show_gotrek_and_felix_appear_event(current_team_mate, pos_x, pos_y)
								end
							end
							
							show_gotrek_and_felix_appear_event(faction, pos_x, pos_y)
							
							core:trigger_event("ScriptEventGotrekAndFelixPubBuilt")
						end
						break
					end
				end
			end
		end,
		true
	)
	
	-- Marker Entered
	core:add_listener(
		"gotrek_AreaEntered",
		"AreaEntered",
		function(context)
			return context:area_key() == "gotrek_marker"
		end,
		function(context)
			local character = context:family_member():character()
			
			if not character:is_null_interface() then
				local faction = character:faction()
				
				if faction:is_human() and gotrek_subculture_details[faction:subculture()] then
					gotrek_details.spawn_cqi = character:command_queue_index()
					gotrek_details.marker_pending = gotrek_details.marker_pending or false
					
					if not gotrek_details.marker_pending then
						gotrek_details.marker_pending = true
						cm:trigger_dilemma(faction:name(), "wh2_pro08_dilemma_gotrek_felix")
					end
				end
			end
		end,
		true
	)
	
	-- Dilemma Choice
	core:add_listener(
		"gotrek_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "wh2_pro08_dilemma_gotrek_felix"
		end,
		function(context)
			gotrek_details.marker_pending = false
			
			if context:choice() == 0 then
				local faction = context:faction()
				local faction_name = faction:name()
				gotrek_details.player_origin = faction_name
				gotrek_details.owner = faction_name
				local character = cm:get_character_by_cqi(gotrek_details.spawn_cqi)
				
				if character then
					local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(faction_name, cm:char_lookup_str(character), true, 2)
					
					if pos_x > 1 then
						local function spawn_gotrek_and_felix_post_dilemma(intervention)
							-- Spawn Gotrek
							cm:create_force_with_general(
								faction_name,
								"",
								character:region():name(),
								pos_x,
								pos_y,
								"general",
								"wh2_pro08_neu_gotrek",
								"names_name_2147354371",
								"",
								"",
								"",
								false,
								function(cqi)
									-- spawn Felix next to him
									cm:spawn_unique_agent_at_character(faction:command_queue_index(), "wh2_pro08_neu_felix", cqi, true)
									CampaignUI.ClearSelection()
								end
							)
							
							gotrek_details.state = gotrek_state.spawned
							gotrek_details.level = gotrek_details.level + 1
							gotrek_details.cooldown = gotrek_turns_available
							
							local incident_payload = cm:create_payload()
							local effect_bundle = cm:create_new_custom_effect_bundle("wh2_pro08_gotrek_felix_cooldown")
							effect_bundle:set_duration(gotrek_turns_available)
							incident_payload:effect_bundle_to_faction(effect_bundle)
							cm:trigger_custom_incident(faction_name, "wh2_pro08_incident_neu_unlocking", true, incident_payload)
							
							trigger_gotrek_and_felix_cutscene("gotrek_felix_arrival", gotrek_details.spawn_cqi, {pos_x, pos_y}, false, intervention)
						end
						
						if cm:is_multiplayer() then
							spawn_gotrek_and_felix_post_dilemma()
						else
							cm:trigger_transient_intervention(
								"g_f_spawn_on_dilemma",
								function(intervention)
									spawn_gotrek_and_felix_post_dilemma(intervention)
								end,
								BOOL_INTERVENTIONS_DEBUG,
								function(intervention)
									-- allow transient scripted event to be shown while intervention is active
									intervention:whitelist_events("faction_event_incidentevent_feed_target_incident_faction")
									intervention:whitelist_events("faction_event_character_incidentevent_feed_target_incident_faction")
									intervention:whitelist_events("faction_event_region_incidentevent_feed_target_incident_faction")
								end
							)
						end
						
						cm:remove_interactable_campaign_marker("gotrek_marker")
					end
				end
			end
		end,
		true
	)
	
	-- Set Character CQI's
	core:add_listener(
		"gotrek_or_felix_created",
		"CharacterCreated",
		function(context)
			local character = context:character()
			return character:character_subtype("wh2_pro08_neu_gotrek") or character:character_subtype("wh2_pro08_neu_felix")
		end,
		function(context)
			local character = context:character()
			local char_lookup_str = cm:char_lookup_str(character)
			local char_cqi = character:command_queue_index()
			
			cm:callback(
				function()
					cm:replenish_action_points(char_lookup_str)
					cm:set_character_immortality(char_lookup_str, true)
				end,
				0.5
			)
			
			if character:character_subtype("wh2_pro08_neu_gotrek") then
				-- Gotrek has spawned
				gotrek_details.gotrek_cqi = char_cqi
				
				cm:callback(
					function()
						cm:apply_effect_bundle_to_characters_force("wh2_pro08_gotrek_xp_sharing", char_cqi, 30, true)
					end,
					0.5
				)
				
				if gotrek_details.level == 2 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_gotrek", true, 1)
				elseif gotrek_details.level == 3 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_gotrek", true, 2)
				elseif gotrek_details.level >= 4 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_gotrek", true, 3)
				end
			elseif character:character_subtype("wh2_pro08_neu_felix") then
				-- Felix has spawned
				gotrek_details.felix_cqi = char_cqi
				
				cm:callback(
					function()
						local felix_char = cm:get_character_by_cqi(gotrek_details.felix_cqi)
						
						-- check that Felix is still a valid char at this point
						if not felix_char or felix_char:is_null_interface() or felix_char:is_wounded() then
							return
						end
						
						local gotrek_char = cm:get_character_by_cqi(gotrek_details.gotrek_cqi)
						
						if gotrek_char and gotrek_char:has_military_force() then
							cm:embed_agent_in_force(felix_char, gotrek_char:military_force())
						end
					end,
					0.5
				)
				
				if gotrek_details.level == 2 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_felix", true, 1)
				elseif gotrek_details.level == 3 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_felix", true, 2)
				elseif gotrek_details.level >= 4 then
					cm:force_add_trait(char_lookup_str, "wh2_pro08_trait_felix", true, 3)
				end
			end
		end,
		true
	)
	
	-- Turns Available
	core:add_listener(
		"gotrek_FactionBeginTurnPhaseNormal",
		"FactionBeginTurnPhaseNormal",
		function(context)
			return gotrek_details.owner and context:faction():name() == gotrek_details.owner and (gotrek_details.state == gotrek_state.spawned or gotrek_details.state == gotrek_state.spawned_ai) and gotrek_details.cooldown > 0
		end,
		function(context)
			gotrek_details.cooldown = gotrek_details.cooldown - 1
			
			if gotrek_details.cooldown == 0 then
				local gotrek_char = cm:get_character_by_cqi(gotrek_details.gotrek_cqi)
				local gotrek_owner_is_human = cm:get_faction(gotrek_details.owner):is_human()
				
				if not gotrek_owner_is_human or not gotrek_char then
					kill_gotrek_and_felix_characters()
					return
				end
				
				local function destroy_gotrek_and_felix_post_cooldown(intervention)
					-- verify that Gotrek exists on the map before proceeding
					if not gotrek_char then
						kill_gotrek_and_felix_characters()
						intervention:complete()
						return
					end
					
					cm:show_message_event(
						gotrek_details.owner,
						"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_title",
						"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_leave_primary_detail",
						"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_leave_secondary_detail",
						false,
						1309
					)
					
					if gotrek_owner_is_human then
						core:trigger_event("ScriptEventGotrekAndFelixDepart")
					end
					
					trigger_gotrek_and_felix_cutscene("gotrek_felix_departure", gotrek_details.gotrek_cqi, {gotrek_char:logical_position_x(), gotrek_char:logical_position_y()}, true, intervention)
				end
				
				if cm:is_multiplayer() then
					destroy_gotrek_and_felix_post_cooldown()
				else
					-- wrap G + F leaving in an intervention, as it shows a cutscene
					cm:trigger_transient_intervention(
						"g_f_leave_faction_turn_start",
						function(intervention)
							destroy_gotrek_and_felix_post_cooldown(intervention)
						end,
						BOOL_INTERVENTIONS_DEBUG,
						function(intervention)
							-- allow transient scripted event to be shown while intervention is active
							intervention:whitelist_events("scripted_transient_eventevent_feed_target_faction")
						end
					)
				end
			end
		end,
		true
	)
	
	-- Owner faction died
	core:add_listener(
		"gotrek_FactionBeginTurnPhaseNormalDead",
		"WorldStartRound",
		function()
			if gotrek_details.owner then
				local owner = cm:get_faction(gotrek_details.owner)
				
				return gotrek_details.state == gotrek_state.spawned_ai and owner and (owner:is_null_interface() or owner:is_dead())
			end
		end,
		function()
			kill_gotrek_and_felix_characters()
		end,
		true
	)
	
	-- Respawn after cooldown
	core:add_listener(
		"gotrek_FactionBeginTurnPhaseNormal",
		"WorldStartRound",
		function()
			return gotrek_details.cooldown > 0 and (gotrek_details.state == gotrek_state.cooldown or gotrek_details.state == gotrek_state.cooldown_ai)
		end,
		function()
			gotrek_details.cooldown = gotrek_details.cooldown - 1
					
			if gotrek_details.cooldown == 0 then
				if gotrek_details.state == gotrek_state.cooldown then
					local faction = false
					
					if gotrek_details.owner then
						faction = cm:get_faction(gotrek_details.owner)
					end
					
					if not faction or not faction:is_human() or faction:is_dead() then
						faction = cm:get_faction(gotrek_find_available_ai_faction())
					end
					
					gotrek_details.owner = faction:name()
					
					-- Spawn them for the AI
					if faction:has_home_region() then
						local region_key = faction:home_region():name()
						local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(gotrek_details.owner, region_key, false, true, 3)
						
						if pos_x > 1 then
							-- Spawn Gotrek
							cm:create_force_with_general(
								gotrek_details.owner,
								"",
								region_key,
								pos_x,
								pos_y,
								"general",
								"wh2_pro08_neu_gotrek",
								"names_name_2147354371",
								"",
								"",
								"",
								false,
								function(cqi)
									gotrek_details.gotrek_cqi = cqi
									-- Spawn Felix
									cm:spawn_unique_agent_at_character(faction:command_queue_index(), "wh2_pro08_neu_felix", gotrek_details.gotrek_cqi, true)
								end
							)
							
							if gotrek_details.current_event == gotrek_details.start_event then
								gotrek_details.start_event = cm:random_number(#gotrek_return_events)
								gotrek_details.current_event = gotrek_details.start_event - 1
							end
							
							gotrek_details.current_event = gotrek_details.current_event + 1
						end
						
						gotrek_details.state = gotrek_state.spawned_ai
						gotrek_details.cooldown = gotrek_turns_available_ai
					end
				elseif gotrek_details.state == gotrek_state.cooldown_ai then
					-- Spawn them for the player
					local faction = cm:get_faction(gotrek_details.player_origin)
					local region_list = faction:region_list()
					local possible_regions = {}
					
					-- build a list of regions that have adjacent regions at war
					for i = 0, region_list:num_items() - 1 do
						local current_region = region_list:item_at(i)
						local adjacent_regions = current_region:adjacent_region_list()
						
						for j = 1, adjacent_regions:num_items() - 1 do
							local adj_region = adjacent_regions:item_at(j)
							
							if not adj_region:is_abandoned() and adj_region:owning_faction():at_war_with(faction) then
								table.insert(possible_regions, current_region)
								break
							end
						end
					end
					
					-- if no regions were found, use the capital
					if #possible_regions == 0 and faction:has_home_region() then
						table.insert(possible_regions, faction:home_region())
					end
					
					if #possible_regions > 0 then
						-- Spawn the marker
						local region = possible_regions[cm:random_number(#possible_regions)]
						local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region:name(), false, true, 9)
						
						if pos_x > -1 then
							cm:add_interactable_campaign_marker("gotrek_marker", "gotrek_marker", pos_x, pos_y, 2)
							gotrek_details.state = gotrek_state.marker
							
							local function show_gotrek_and_felix_reappear_event(event_faction, x, y)
								local event_num = gotrek_details.current_event or 1
								local event_apx = gotrek_return_events[event_num] or "misc"
								
								cm:show_message_event_located(
									event_faction:name(),
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_title",
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_reappear_" .. event_apx .. "_primary_detail",
									"event_feed_strings_text_wh2_pro08_event_feed_string_scripted_event_gotrek_felix_reappear_" .. event_apx .. "_secondary_detail",
									x,
									y,
									false,
									1308
								)
							end
							
							local team_mates = faction:team_mates()
							
							for j = 0, team_mates:num_items() - 1 do
								local current_team_mate = team_mates:item_at(j)
								
								if gotrek_subculture_details[current_team_mate:subculture()] then
									show_gotrek_and_felix_reappear_event(current_team_mate, pos_x, pos_y)
								end
							end
							
							show_gotrek_and_felix_reappear_event(faction, pos_x, pos_y)
						end
					else
						gotrek_details.state = gotrek_state.cooldown
						gotrek_details.cooldown = gotrek_cooldown_turns
					end
				end
			end
		end,
		true
	)
end

function kill_gotrek_and_felix_characters()
	if not (gotrek_details.state == gotrek_state.spawned or gotrek_details.state == gotrek_state.spawned_ai) then
		return
	end
	
	local character_killed = false
	
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	
	local gotrek_char = cm:get_character_by_cqi(gotrek_details.gotrek_cqi)
	
	if gotrek_char and not gotrek_char:is_null_interface() and gotrek_char:character_subtype("wh2_pro08_neu_gotrek") then
		-- Kill Gotrek
		cm:set_character_immortality(cm:char_lookup_str(gotrek_details.gotrek_cqi), false)
		cm:kill_character(gotrek_details.gotrek_cqi, false)
		
		character_killed = true
	end
	
	local felix_char = cm:get_character_by_cqi(gotrek_details.felix_cqi)
	
	if felix_char and not felix_char:is_null_interface() and felix_char:character_subtype("wh2_pro08_neu_felix") then
		-- Kill Felix
		cm:set_character_immortality(cm:char_lookup_str(gotrek_details.felix_cqi), false)
		cm:kill_character(gotrek_details.felix_cqi, false)
		
		character_killed = true
	end
	
	cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.2)
	
	if character_killed then
		if gotrek_details.state == gotrek_state.spawned or gotrek_details.ai_only then
			-- A.I's turn to have them!
			gotrek_details.owner =  gotrek_find_available_ai_faction()
			gotrek_details.state = gotrek_state.cooldown
			gotrek_details.cooldown = gotrek_cooldown_turns
		elseif gotrek_details.state == gotrek_state.spawned_ai then
			-- The Player's turn to have them!
			gotrek_details.owner = gotrek_details.player_origin
			gotrek_details.state = gotrek_state.cooldown_ai
			gotrek_details.cooldown = gotrek_cooldown_turns_ai
		end
	end
end

function trigger_gotrek_and_felix_cutscene(key, cqi, loc, kill, intervention)
	local gotrek = cm:get_character_by_cqi(cqi)
	
	if gotrek and not gotrek:faction():is_human() then
		if kill then
			kill_gotrek_and_felix_characters()
		end
		
		if intervention then
			intervention:complete()
		end
		
		return
	end
	
	-- multiplayer, don't play the cutscene
	if not intervention then
		if kill then
			kill_gotrek_and_felix_characters()
		end
		
		return
	end
	
	local length = 20
	cm:trigger_campaign_vo(key, cm:char_lookup_str(cqi), 3)
	
	local cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h = cm:get_camera_position()
	cm:take_shroud_snapshot()
	
	local gotrek_and_felix_cutscene = campaign_cutscene:new(
		"gotrek_and_felix_cutscene",
		length,
		function()
			cm:modify_advice(true)
			cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:restore_shroud_from_snapshot()
			cm:fade_scene(1, 1)
			
			-- complete supplied intervention
			if intervention then
				cm:callback(function() intervention:complete() end, 1)
			end
		end
	)
	
	gotrek_and_felix_cutscene:set_skippable(true, function() gotrek_and_felix_cutscene_skipped(kill) end)
	gotrek_and_felix_cutscene:set_skip_camera(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
	gotrek_and_felix_cutscene:set_disable_settlement_labels(false)
	gotrek_and_felix_cutscene:set_dismiss_advice_on_end(true)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:fade_scene(0, 2)
			cm:clear_infotext()
		end,
		0
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:show_shroud(false)
			
			local x_pos, y_pos = cm:log_to_dis(loc[1], loc[2])
			cm:set_camera_position(x_pos, y_pos, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 2)
		end,
		2
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:fade_scene(0, 1)
		end,
		length - 1
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 1)
			if kill then
				kill_gotrek_and_felix_characters()
			end
		end,
		length
	)
	
	gotrek_and_felix_cutscene:start()
	
	core:add_listener(
		"skip_camera_after_vo_ended",
		"ScriptTriggeredVOFinished",
		true,
		function()
			gotrek_and_felix_cutscene:skip(false)
		end,
		true
	)
end

function gotrek_and_felix_cutscene_skipped(kill)
	cm:override_ui("disable_advice_audio", true)
	
	common.clear_advice_session_history()
	
	cm:callback(function() cm:override_ui("disable_advice_audio", false) end, 0.5)
	cm:restore_shroud_from_snapshot()
	if kill then
		kill_gotrek_and_felix_characters()
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("gotrek_details", gotrek_details, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		gotrek_details = cm:load_named_value("gotrek_details", {}, context)
	end
)