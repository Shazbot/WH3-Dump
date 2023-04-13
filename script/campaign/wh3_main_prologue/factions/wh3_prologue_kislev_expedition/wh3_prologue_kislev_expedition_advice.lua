prologue_dialogue_about_to_start = false

-----------------------------------------------------------------------------------------------------------------------------
-------------- Common functions
-----------------------------------------------------------------------------------------------------------------------------
function prologue_start_of_dialogue(value, first_dialogue_function, ignore_save_lock, ignore_end_turn_lock)

	prologue_dialogue_about_to_start = true
	ignore_save_lock = ignore_save_lock or false
	ignore_end_turn_lock = ignore_end_turn_lock or false

	cm:contextual_vo_enabled(false);
	uim:override("disable_help_pages_panel_button"):set_allowed(false);

	if value then
		if value == true then
			PrologueRemoveObjective();
		end
	end

	if ignore_save_lock == false then
		cm:disable_saving_game(true)
	end

	if not ignore_end_turn_lock then
		uim:override("end_turn"):set_allowed(false);
	end

	cm:callback(function () DialogueAddListenerIfPanelOpen(first_dialogue_function, ignore_save_lock) end, 0.5)
end

function prologue_end_of_dialogue(save_load_check, objective, value, keep_saving_disabled, ignore_save_lock)
	dialogue_in_progress = false;
	ignore_save_lock = ignore_save_lock or false
	cm:dismiss_advice();

	set_end_of_dialogue_timer()

	if save_load_check then
		prologue_load_check = save_load_check;
	end

	if objective then 
		if objective ~= "" then
			PrologueAddTopicLeader(objective);
			if value then
				if value == true then
					-- We need to set the override instantly, otherwise the player can save before it's re-enabled (which leads to a soft-lock on load)
					uim:override("end_turn"):set_allowed(true)

					-- We can keep end turn disabled with this function that doesn't go into save game - JJ
					cm:disable_end_turn(true)
					cm:callback(function() cm:disable_end_turn(false); end, 2)
				end
			end
		
		elseif objective == "" then
			if value then 
				if value == true then
					uim:override("end_turn"):set_allowed(true);
				end
			end
		end
	end

	if ignore_save_lock == false then
		if keep_saving_disabled == true then
			cm:disable_saving_game(true)
		else
			cm:disable_saving_game(false)
		end
	end

	uim:override("disable_help_pages_panel_button"):set_allowed(true);
end

function DialogueAddListenerIfPanelOpen(first_dialogue_function, ignore_save_lock)
 
	-- This makes dialogue wait until an event has disappeared and no other dialogue is playing.
	local uic_event_button = find_uicomponent(core:get_ui_root(), "events", "button_set", "accept_holder", "button_accept")
	local uic_mission_button = find_uicomponent(core:get_ui_root(), "events", "event_layouts", "mission_active", "mission_complete", "footer", "button_accept")				
	
	if uic_event_button and uic_event_button:Visible(true) or uic_mission_button and uic_mission_button:Visible(true) or dialogue_in_progress then
		cm:callback(function () DialogueAddListenerIfPanelOpen(first_dialogue_function) end, 1)
	else
		first_dialogue_function();
		dialogue_in_progress = true;
		prologue_dialogue_about_to_start = false
	end

	skip_all_scripted_tours();
end

function trigger_campaign_vo_prologue(sound_event, character_lookup, delay)

	sound_event = sound_event or false
	character_lookup = character_lookup or false
	delay = delay or false

	if sound_event and not is_string(sound_event) then
		script_error("ERROR: trigger_campaign_vo_prologue() called but supplied sound_event [" .. tostring(sound_event) .. "] is not a string");
		return false;
	end

	if character_lookup and not is_string(character_lookup) then
		script_error("ERROR: trigger_campaign_vo_prologue() called but supplied character_lookup [" .. tostring(character_lookup) .. "] is not a string");
		return false;
	end

	if delay and not is_number(delay) then
		script_error("ERROR: trigger_campaign_vo_prologue() called but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end

	core:trigger_event("ScriptTriggeredVOStartingPrologue")
	cm:trigger_campaign_vo(sound_event, character_lookup, delay)
end
-----------------------------------------------------------------------------------------------------------------------------
-------------- Start of the game
-----------------------------------------------------------------------------------------------------------------------------

function prologue_advice_start_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_start_002() end, prologue_audio_timing["wh3_prologue_narrative_01_1_1"]) end);
	cm:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
end

function prologue_advice_start_002()
	-- Advisor text: We made it brother, we've crossed the mountains.  
	cm:show_advice("wh3_prologue_narrative_01_1_1", true, false, prologue_advice_start_003, 0, prologue_audio_timing["wh3_prologue_narrative_01_2_1"]);
end

function prologue_advice_start_003()
	-- Advisor text: Trust in Ursun, Gerik. His wisdom guides us.
	cm:show_advice("wh3_prologue_narrative_01_2_1", true, false, prologue_advice_start_trigger_mission, 0, 0.5);
end

function prologue_advice_start_trigger_mission()
	--prologue_end_of_dialogue("end_of_mission_event", "", false)
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", false, false, true)

	uim:override("faction_bar"):set_allowed(true);
	prologue_tutorial_passed["faction_bar"] = true;

	if prologue_check_progression["main_building_mission_triggered"] then
		prologue_start_of_dialogue(false, function () prologue_advice_start_004(); end)
	else
		
		core:add_listener(
			"MissionIssued_UrsunMission",
			"MissionIssued",
			true,
			function()
				--Ursun text: Yuri, you have led your kin through the mountain pass. The winds of the Chaos Wastes howl with unmatched fury. Journey north and seek respite.
				trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_01_1_1_1", "", 2.0);
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(3, "first_mission_triggered", false);
			end,
			false
		);

		prologue_mission_respite:trigger();
		

		core:add_listener(
			"ScriptTriggeredVOFinished_Prologue",
			"ScriptTriggeredVOFinished", 
			true,
			function()
				local uic_button_accept = find_uicomponent("events", "accept_holder", "button_accept")
				if uic_button_accept then
					highlight_component(true, false, "events", "accept_holder", "button_accept"); 
				end
			end,
			false
		);


		core:add_listener(
			"PanelClosedCampaign_StartMission",
			"PanelClosedCampaign",
			function(context) return context.string == "events" end,
			function()
				prologue_start_of_dialogue(
					false, 
					function () 
						cm:stop_campaign_advisor_vo();
						core:remove_listener("ScriptTriggeredVOFinished_Prologue");
						prologue_advice_start_004();
					end
				)																			
			end,
			false
		);	
	end
end

function prologue_advice_start_004()
	cm:callback(function() prologue_advice_start_005() end, prologue_audio_timing["wh3_prologue_narrative_01_3_1"]);
end

function prologue_advice_start_005()
	-- Advisor text: What are your orders Yuri?
	cm:show_advice("wh3_prologue_narrative_01_3_1", true, false, prologue_advice_start_006, 0, prologue_audio_timing["wh3_prologue_narrative_01_4_1"]);
end


function prologue_advice_start_006()
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		-- Advisor text: Push north. Find shelter.
		cm:show_advice("wh3_prologue_narrative_01_4_1", true, false, prologue_advice_show_text_pointer, 0, 0.5);
	else
		-- Advisor text: Push north. Find shelter.
		cm:show_advice("wh3_prologue_narrative_01_4_1", true, false, prologue_advice_start_show_objective, 0, 0.5);
	end

	uim:override("resources_bar"):set_allowed(true);
	prologue_tutorial_passed["resources_bar"] = true;
	prologue_show_compass = true;

	local uic_compass = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "compass_holder");
	local uic_treasury = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "treasury_holder");
	if uic_compass then
		uic_compass:SetVisible(true);
	end
	if uic_treasury then
		uic_treasury:SetVisible(false);
	end
	
	cm:steal_escape_key_with_callback("DismissPushNorthAdvice", function ()  prologue_advice_show_text_pointer(); core:remove_listener("first_help_button_listener") end)

end

function prologue_advice_show_text_pointer()
	cm:release_escape_key_with_callback("DismissPushNorthAdvice")

	cm:dismiss_advice();

	core:remove_listener("first_help_button_listener") 
	core:remove_listener("first_help_button_listener_2") 

	local mtp_advice_button = text_pointer:new_from_component(
		"advisor_button",
		"top",
		25,
		find_uicomponent(core:get_ui_root(), "menu_bar", "button_show_advice"),
		0.5,
		1
	);
	mtp_advice_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_advice_button")
	mtp_advice_button:set_style("semitransparent")
	mtp_advice_button:set_topmost(true)
	mtp_advice_button:set_highlight_close_button(1)
	mtp_advice_button:set_label_offset(100, 0)
	mtp_advice_button:set_close_button_callback(
		function() 
			prologue_advice_start_show_objective()
			core:remove_listener("first_help_button_listener")
		end
	)
	
	cm:callback(
		function() 
			mtp_advice_button:show();
			
			core:add_listener(
				"first_help_button_listener",
				"ComponentLClickUp",
				function(context) return context.string == "button_show_advice" end,
				function()
					--local uic_close_button = find_uicomponent("text_pointer_advisor_button", "button_parent", "button_close")
					--uic_close_button:SimulateLClick()
					mtp_advice_button:hide();

					--Metric check (step_number, step_name, skippable)
					cm:trigger_prologue_step_metrics_hit(4, "pressed_advice_button", true);
			
					core:add_listener(
						"first_help_button_listener_2_advice",
						"ComponentLClickUp",
						function(context) return context.string == "button_close" end,
						function()
							prologue_advice_start_show_objective()
						end,
						false
					);
					
				end,
				false
			);
		end, 
		0.5
	);
end

local replenish_once = false;

function prologue_advice_start_show_objective()
	cm:steal_escape_key(false)
	cm:contextual_vo_enabled(true);

	if replenish_once == false then	
		cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
		replenish_once = true;
	end

	-- Add listners for Yuri selection. This controls the early turn movement markers for Yuri.
	local movement_started = false
	
	core:add_listener(
		"CharacterDeselectedAddSelectionMarker",
		"CharacterDeselected",
		true,
		function() 
			add_selection_marker_prologue("turn_1",_, _, "select") 
			PrologueAddTopicLeader(
				"wh3_prologue_objective_turn_001_05", 
				function() 
					if prologue_current_objective == "wh3_prologue_objective_turn_001_02" or movement_started then 
						cm:remove_objective("wh3_prologue_objective_turn_001_05")
						cm:remove_objective("wh3_prologue_objective_turn_001_01") 
					end 
				end
			)
		end,
		true
	)

	core:add_listener(
		"CharacterSelectedAddSelectionMarker",
		"CharacterSelected",
		true,
		function() 

			PrologueAddTopicLeader(
				"wh3_prologue_objective_turn_001_02", 
				function() 
					if prologue_current_objective == "wh3_prologue_objective_turn_001_05" or prologue_current_objective == "wh3_prologue_objective_turn_001_01" or movement_started then 
						cm:remove_objective("wh3_prologue_objective_turn_001_02") 
					end 
				end
			)
			add_selection_marker_prologue("turn_1", 261.7, 87, "move_to") end,
		true
	)

	cm:notify_on_character_movement(
		"YuriStartMove",
		prologue_player_cqi, 
		function() 
			core:remove_listener("CharacterSelectedAddSelectionMarker")
			core:remove_listener("CharacterDeselectedAddSelectionMarker")
			
			cm:remove_objective("wh3_prologue_objective_turn_001_05")
			cm:remove_objective("wh3_prologue_objective_turn_001_01") 
			cm:remove_objective("wh3_prologue_objective_turn_001_02")
			
			remove_marker_prologue("turn_1")
			
			movement_started = true
		end
	)

	if common.get_context_value("CcoCampaignCharacter", prologue_player_cqi, "IsSelected") then
		prologue_end_of_dialogue("Turn_1_start", "wh3_prologue_objective_turn_001_02");
		add_selection_marker_prologue("turn_1", 261.7, 87, "move_to")
	else
		prologue_end_of_dialogue("Turn_1_start", "wh3_prologue_objective_turn_001_01");
		add_selection_marker_prologue("turn_1", _, _, "select")
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Start of turn 2
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_turn_two_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_turn_two_002(); end, prologue_audio_timing["wh3_prologue_narrative_02_1_1"]); end);
	core:remove_listener("Intro_CharacterDeselected_Event_Prologue");
	cm:trigger_2d_ui_sound("Campaign_Environment_Element_Wind_Gerrik_Stinger", 0);
end

function prologue_advice_turn_two_002()
	-- Advisor text: We should be cautious. A darkness covers this land. 
	cm:show_advice("wh3_prologue_narrative_02_1_1", true, false, prologue_advice_turn_two_003, 0, prologue_audio_timing["wh3_prologue_narrative_02_2_1"]);
end

function prologue_advice_turn_two_003()
	-- Advisor text: The influence of Chaos. The further north we travel, the stronger it becomes. 
	cm:show_advice("wh3_prologue_narrative_02_2_1", true, false, prologue_advice_turn_two_unlock_objectives, 0, 0.5);
end

function prologue_advice_turn_two_unlock_objectives()
	cm:dismiss_advice();
	uim:override("disable_help_pages_panel_button"):set_allowed(true);

	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		core:trigger_event("ScriptEventPrologueMissions");
	else
		prologue_tutorial_passed["missions_with_button_hidden"] = true;
		uim:override("missions_with_button_hidden"):set_allowed(true);
		cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
		prologue_advice_turn_two_show_objective();
	end

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_debris_setup();
end


function prologue_advice_turn_two_show_objective(from_load)

	prologue_end_of_dialogue("Turn_2_start", "wh3_prologue_objective_turn_001_03", true);

	cm:contextual_vo_enabled(true);

	cm:callback(function() 
		show_campaign_controls_cheat_sheet(); 

		local hpm = get_help_page_manager();

		-- Fake that the player has moved the help sheet.
		hpm.panel_has_moved_while_undocked = true
	
		local control_sheet_top_bar = find_uicomponent(core:get_ui_root(), "top_bar_parent");
		if control_sheet_top_bar then
			control_sheet_top_bar:SetVisible(false);
		end

		local uic_help_page = get_help_page_manager():get_uicomponent()

		local panel_width = uic_help_page:Width()

		local screen_x, screen_y = core:get_screen_resolution()

		uic_help_page:MoveTo(0, 250)
		uic_help_page:SetMoveable(false)

		core:add_listener(
		"FactionTurnStartStopHelpPageMoving",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			local uic_help_page = get_help_page_manager():get_uicomponent()
			uic_help_page:SetMoveable(false)
		end,
		true
	);
		
	end, 2);

	cm:callback(function() local control_sheet_slider = find_uicomponent(core:get_ui_root(), "help_panel", "vslider");
		if control_sheet_slider then
			control_sheet_slider:SetVisible(false);
		end
	end, 2.2)
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger until finding debris
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_debris_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeDebris",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_debris_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_debris_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_debris_002() end, prologue_audio_timing["wh3_prologue_narrative_01_5_1"]) end);
end

function prologue_advice_linger_before_debris_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: The cold bites. We should head north and find shelter.
		cm:show_advice("wh3_prologue_narrative_01_5_1", true, false, prologue_advice_linger_before_debris_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Move us north. Find respite.
		cm:show_advice("wh3_prologue_narrative_01_6_1", true, false, prologue_advice_linger_before_debris_end, 0, 0.5);
	else
		-- Advisor text: We must follow the path north. Find shelter.
		cm:show_advice("wh3_prologue_narrative_01_7_1", true, false, prologue_advice_linger_before_debris_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_debris_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end

if cm:model():turn_number() > 1 and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["found_debris"] == false then
	prologue_advice_linger_before_debris_setup();
end


---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Debris from Dervingard revealed
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_debris_001()
	PrologueResetLingerVariable("FactionTurnStartLingerBeforeDebris");
	PrologueRemoveObjective();
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_debris_002() end, prologue_audio_timing["wh3_prologue_narrative_03_1_1"]) end);
end

function prologue_advice_debris_002()
	-- Advisor text: In the snow. We found supplies. From Dervingard.
	cm:show_advice("wh3_prologue_narrative_03_1_1", true, false, prologue_advice_debris_003, 0, prologue_audio_timing["wh3_prologue_narrative_03_2_1"]);
end

function prologue_advice_debris_003()
	PrologueRemoveObjective();
	-- Advisor text: Dervingard? How did they get here?
	cm:show_advice("wh3_prologue_narrative_03_2_1", true, false, prologue_advice_debris_004, 0, prologue_audio_timing["wh3_prologue_narrative_03_3_1"]);
end

function prologue_advice_debris_004()
	-- Advisor text: Someone left in a hurry. Carried what they could. 
	cm:show_advice("wh3_prologue_narrative_03_3_1", true, false, prologue_advice_debris_005, 0, prologue_audio_timing["wh3_prologue_narrative_03_4_1"]);
end

function prologue_advice_debris_005()
	-- Advisor text: We thank Ursun. They will be needed.
	cm:show_advice("wh3_prologue_narrative_03_4_1", true, false, prologue_advice_debris_show_objective, 0, 0.5);
end

function prologue_advice_debris_show_objective()
	cm:dismiss_advice();
	prologue_end_of_dialogue("found_debris", "", false)

	prologue_check_progression["found_debris"] = true;

	-- start intervention about resource bar
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		core:trigger_event("ScriptEventPrologueResourceBar");
	else
		prologue_show_compass = false;

		local uic_treasury = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "treasury_holder");
				
		if uic_treasury then
			uic_treasury:SetVisible(true);
		end

		if prologue_check_progression["first_settlement_revealed"] == true then
			PrologueSettlementMarker();
		else
			PrologueAddTopicLeader("wh3_prologue_objective_turn_001_04", function() uim:override("end_turn"):set_allowed(true); HighlightEndTurnButton() end);
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Start of turn 3
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_turn_three_001(skip_load_check)
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_turn_three_002(skip_load_check); end, prologue_audio_timing["wh3_prologue_narrative_04_1_1"]); end);
end

function prologue_advice_turn_three_002(skip_load_check)
	-- Advisor text: The soldiers are ready. Give the order.  
	cm:show_advice("wh3_prologue_narrative_04_1_1", true, false, function() prologue_advice_turn_three_003(skip_load_check) end, 0, prologue_audio_timing["wh3_prologue_narrative_04_2_1"]);
end

function prologue_advice_turn_three_003(skip_load_check)
	-- Advisor text: We move north. 
	cm:show_advice("wh3_prologue_narrative_04_2_1", true, false, function() prologue_advice_turn_three_show_objective(skip_load_check) end, 0, 0.5);
end

function prologue_advice_turn_three_show_objective(skip_load_check)
	if skip_load_check then
		prologue_end_of_dialogue("", "wh3_prologue_objective_turn_001_03", true)
	else
		prologue_end_of_dialogue("turn_3_start", "wh3_prologue_objective_turn_001_03", true)
	end

	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
	cm:contextual_vo_enabled(true);
end


-------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Outpost revealed
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_outpost_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_outpost_002() end, prologue_audio_timing["wh3_prologue_narrative_04_3_1"]) end);
end

function prologue_advice_outpost_002()
	-- Advisor text: Up ahead. A shelter of some kind.
	cm:show_advice("wh3_prologue_narrative_04_3_1", true, false, prologue_advice_outpost_003, 0, prologue_audio_timing["wh3_prologue_narrative_04_4_1"]);
end

function prologue_advice_outpost_003()
	-- Advisor text: Send word Gerik. We rest there. 
	cm:show_advice("wh3_prologue_narrative_04_4_1", true, false, prologue_advice_outpost_show_objective, 0, 0.5);
end

function prologue_advice_outpost_show_objective()
	prologue_end_of_dialogue("Turn_3_end", "wh3_prologue_objective_turn_002_01", true)

	cm:disable_pathfinding_restriction(1);

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_until_occupying_setup();

	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)
	cm:contextual_vo_enabled(true);

	load_check_turn_3_end()
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger until occupying
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_until_occupying_setup()
	core:add_listener(
		"FactionTurnStartLingerUntilOccupying",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_until_occupying_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_until_occupying_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_until_occupying_002() end, prologue_audio_timing["wh3_prologue_narrative_04_5_1"]) end);
end

function prologue_advice_linger_until_occupying_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: We must occupy the refuge. 
		cm:show_advice("wh3_prologue_narrative_04_5_1", true, false, prologue_advice_linger_until_occupying_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Take refuge in the shelter.
		cm:show_advice("wh3_prologue_narrative_04_6_1", true, false, prologue_advice_linger_until_occupying_end, 0, 0.5);
	else
		-- Advisor text: We need shelter and rest.
		cm:show_advice("wh3_prologue_narrative_04_7_1", true, false, prologue_advice_linger_until_occupying_end, 0, 0.5);
	end
end

function prologue_advice_linger_until_occupying_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end

if prologue_check_progression["found_debris"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["occupied_settlement"] == false then
	prologue_advice_linger_until_occupying_setup();
end


---------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Mission complete - occupying the Kislev Refuge
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_mission_complete_kislev_refuge()
	PrologueResetLingerVariable("FactionTurnStartLingerUntilOccupying");

	core:add_listener(
		"PanelOpenedCampaign_UrsunMission",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "events"
		end,
		function()
			--Ursun text: You have found respite. Together we can overcome the trials ahead. Our journey has just begun. 
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_01_2_1_1", "", 2.0);
			cm:trigger_2d_ui_sound("UI_CAM_PRO_HUD_Occupy_First_Settlement", 0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(14, "completed_first_mission", false);
		end,
		false
	);

	-- complete the mission
	cm:callback(function() prologue_mission_respite:force_scripted_objective_success("mission_prologue_respite"); end, 2);

	local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
	cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_0_1");
	cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_0_1");

	core:add_listener(
		"PanelClosedCampaign_FirstMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()
			cm:stop_campaign_advisor_vo();												
			prologue_advice_occupy_outpost_001();		
		end,
		false
	);	
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
					
--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Occupy Outpost
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_occupy_outpost_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_occupy_outpost_002() end, prologue_audio_timing["wh3_prologue_narrative_05_1_1"]) end); 
end

function prologue_advice_occupy_outpost_002()
	-- Advisor text: The cold bites deep. The shelter is not enough.
	cm:show_advice("wh3_prologue_narrative_05_1_1", true, false, prologue_advice_occupy_outpost_003, 0, prologue_audio_timing["wh3_prologue_narrative_05_2_1"]);
end

function prologue_advice_occupy_outpost_003()
	-- Advisor text: Build a camp. Then we can rest. 
	cm:show_advice("wh3_prologue_narrative_05_2_1", true, false, prologue_advice_occupy_outpost_objective, 0, 0.5);
end	

function prologue_advice_occupy_outpost_objective()
	cm:dismiss_advice();
	prologue_end_of_dialogue("before_construction", "", false)

	cm:contextual_vo_enabled(true);

	core:remove_listener("BuildingConstructionIssuedByPlayer_Prologue_Main_Early");
	ConstructionTopicLeaders("wh3_prologue_objective_turn_003_01", "wh3_prologue_objective_turn_001_07", true)
	if prologue_check_progression["main_building_in_progress"] == false then
		local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_77");
		if uic_slot_entry and uic_slot_entry:Visible(true) then
			uic_slot_entry:Highlight(true, true)
		end
		load_check_before_construction()
	else
		PrologueAfterBuildingMain();
	end

	if prologue_check_progression["main_building_in_progress"] == false then
		cm:callback(function() prologue_advice_linger_build_camp_001(); end, 15, "build_camp_callback")

		core:add_listener(
			"BuildingConstructionIssuedByBuildCamp",
			"BuildingConstructionIssuedByPlayer",
			true,
			function()
				cm:remove_callback("build_camp_callback");
			end,
			false
		);
	end

end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger while building camp
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_build_camp_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_build_camp_002() end, prologue_audio_timing["wh3_prologue_narrative_05_4_1"]) end);
end

function prologue_advice_linger_build_camp_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Give the order and we'll build the Camp.
		cm:show_advice("wh3_prologue_narrative_05_4_1", true, false, prologue_advice_linger_build_camp_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Yuri, we should build a Camp.
		cm:show_advice("wh3_prologue_narrative_05_5_1", true, false, prologue_advice_linger_build_camp_end, 0, 0.5);
	else
		-- Advisor text: Build the Kislev Camp.
		cm:show_advice("wh3_prologue_narrative_05_6_1", true, false, prologue_advice_linger_build_camp_end, 0, 0.5);
	end
end

function prologue_advice_linger_build_camp_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Start building main building
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_build_main_building_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_build_main_building_002() end, prologue_audio_timing["wh3_prologue_narrative_05_3_1"]) end);
end

function prologue_advice_build_main_building_002()
	-- Advisor text: The order’s been given, but the camp will take time.
	cm:show_advice("wh3_prologue_narrative_05_3_1", true, false, prologue_advice_build_main_building_show_objective, 0, 0.5);
end

function prologue_advice_build_main_building_show_objective()
	Add_Main_Building_Progress_End_Turn_Listeners()
	prologue_end_of_dialogue("end_of_mission_event", "", false)
	cm:contextual_vo_enabled(true);
	load_check_before_end_of_mission_event()
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- To build a store house
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_store_house_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_store_house_002() end, prologue_audio_timing["wh3_prologue_narrative_06_1_1"]); end);
end

function prologue_advice_store_house_002()
	-- Advisor text: The camp protects us. But what of our supplies? 
	cm:show_advice("wh3_prologue_narrative_06_1_1", true, false, prologue_advice_store_house_003, 0, prologue_audio_timing["wh3_prologue_narrative_06_2_1"]);
end

function prologue_advice_store_house_003()
	-- Advisor text: We keep them safe. Build a storehouse.
	cm:show_advice("wh3_prologue_narrative_06_2_1", true, false, prologue_advice_store_house_show_objective, 0, 0.5);
end

function prologue_advice_store_house_show_objective()
	cm:dismiss_advice();

	prologue_tutorial_passed["settlement_panel_help_with_button_hidden"] = true;
	uim:override("settlement_panel_help_with_button_hidden"):set_allowed(true);

	cm:steal_user_input(false);
	
	prologue_end_of_dialogue("before_building_industry", "")

	cm:contextual_vo_enabled(true);

	ConstructionTopicLeaders("wh3_prologue_objective_turn_011_01", "wh3_prologue_objective_turn_001_08")

	if prologue_check_progression["industry_building_in_progress"] == false then
		
		local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_78");
		if uic_slot_entry and uic_slot_entry:Visible(true) then
			uic_slot_entry:Highlight(true, true)
		end

		load_check_before_building_industry()

		cm:callback(function() prologue_advice_linger_build_storehouse_001(); end, 15, "build_storehouse_callback")

		core:add_listener(
			"BuildingConstructionIssuedByBuildStoreHouse",
			"BuildingConstructionIssuedByPlayer",
			true,
			function()
				cm:remove_callback("build_storehouse_callback");
			end,
			false
		);
		
	else
		prologue_load_check = "end_of_industry_turn";
		Add_Industry_Progress_End_Turn_Listeners()	
		HighlightEndTurnButton()
		uim:override("end_turn"):set_allowed(true)
	end

end
---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger while building storehouse
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_build_storehouse_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_build_storehouse_002() end, prologue_audio_timing["wh3_prologue_narrative_06_3_1"]) end);
end

function prologue_advice_linger_build_storehouse_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: The supplies need protecting. Build a Storehouse.
		cm:show_advice("wh3_prologue_narrative_06_3_1", true, false, prologue_advice_linger_build_storehouse_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Our soldiers are waiting to build the Storehouse.
		cm:show_advice("wh3_prologue_narrative_06_4_1", true, false, prologue_advice_linger_build_storehouse_end, 0, 0.5);
	else
		-- Advisor text: We should build the Storehouse.
		cm:show_advice("wh3_prologue_narrative_06_5_1", true, false, prologue_advice_linger_build_storehouse_end, 0, 0.5);
	end
end

function prologue_advice_linger_build_storehouse_end()
	cm:dismiss_advice();
	cm:contextual_vo_enabled(true);
	if prologue_check_progression["industry_building_in_progress"] == false then
		prologue_end_of_dialogue(false, "", false)
	else
		HighlightEndTurnButton();
		prologue_end_of_dialogue(false, "", true)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- News from Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_fleeing_from_dervingard_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_fleeing_from_dervingard_002() end, prologue_audio_timing["wh3_prologue_narrative_07_1_1"]); end);
end

function prologue_advice_fleeing_from_dervingard_002()
	-- Advisor text: The storehouse is ready. The supplies are safe.
	cm:show_advice("wh3_prologue_narrative_07_1_1", true, false, prologue_advice_income_st, 0, 0.5);
end

function prologue_advice_income_st()
	prologue_end_of_dialogue("", "", false)
	cm:dismiss_advice();

	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		core:trigger_event("ScriptEventIncome")
	else
		prologue_advice_fleeing_from_dervingard_incident()
		prologue_check_progression["st_income_complete"] = true;
	end
end

function prologue_advice_fleeing_from_dervingard_incident()
	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			--Ursun text: Yuri, ready your warriors. Our sons and daughters cry out and flee in terror. The spilling of their blood must be prevented. 
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_02_1_1_1", "", 2.0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(20, "triggered_rescue_mission", false);
		end,
		false
	);

	prologue_mission_rescue:trigger();

	cm:toggle_dilemma_generation(false);

	core:add_listener(
		"PanelClosedCampaign_TroubleMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()					
			cm:stop_campaign_advisor_vo();	
			cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)	
			
			cm:disable_pathfinding_restriction(2);
			cm:contextual_vo_enabled(true);

			if prologue_garrison == true then
				prologue_end_of_dialogue("leave_first_settlement", "wh3_prologue_objective_turn_005_02", true)
			else
				prologue_end_of_dialogue("leave_first_settlement", "wh3_prologue_objective_turn_005_01", true)
			end
		end,
		false
	);

	local play_once = false;
	core:add_listener(
		"CharacterFinishedMovingEvent_Prologue2",
		"CharacterFinishedMovingEvent", 
		true,
		function(context)
			if play_once == false then
				if common.get_context_value("IsFullscreenPanelOpen") == false then
					IfNoFullScreenTriggerTroubleDilemma();
				else
					common.call_context_command("CloseAllPanels");
					IfNoFullScreenTriggerTroubleDilemma()
				end
				play_once = true;
			end
		end, 
		true
	);
end

function IfNoFullScreenTriggerTroubleDilemma()
	cm:steal_escape_key(true) 
	PrologueTroubleDilemma(); 
end

--------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Story Panel 1 - Trouble at the Beacon - Option 1 
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_trouble_at_beacon_1_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_trouble_at_beacon_1_002() end, prologue_audio_timing["wh3_prologue_narrative_07_2_1"]); end )
end

function prologue_advice_trouble_at_beacon_1_002()
	-- Advisor text: We fight at the Beacon. Save who we can. 
	cm:show_advice("wh3_prologue_narrative_07_2_1", true, false, prologue_advice_trouble_at_beacon_end, 0, 0.5);
end

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Story Panel 1 - Trouble at the Beacon - Option 2
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_trouble_at_beacon_2_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_trouble_at_beacon_2_002() end, prologue_audio_timing["wh3_prologue_narrative_07_3_1"]); end )
end

function prologue_advice_trouble_at_beacon_2_002()
	-- Advisor text: Rally the soldiers. We hunt the Wolf.
	cm:show_advice("wh3_prologue_narrative_07_3_1", true, false, prologue_advice_trouble_at_beacon_end, 0, 0.5);
end


function prologue_advice_trouble_at_beacon_end()

	prologue_check_progression["trouble_dilemma_triggered"] = true;

	core:add_listener(
		"FactionTurnStart_Prologue_before_attack",
		"FactionTurnStart",
		true,
		function(context)
			if context:faction():name() == prologue_player_faction then

				uim:override("disable_help_pages_panel_button"):set_allowed(false);

				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(24, "ended_trouble_dilemma_turn", false);

				core:add_listener(
					"PanelClosedCampaign_TroubleMission",
					"PanelClosedCampaign",
					function(context) return context.string == "character_details_panel" end,
					function()	

						cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)	

						if prologue_story_choice == 2 then
							prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_04", true)
							core:remove_listener("FactionTurnStart_Prologue_before_attack");
						else
							prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_03", true)
							core:remove_listener("FactionTurnStart_Prologue_before_attack");
						end
					end,
					false
				);

				cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)	

				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventItems")
				else
					uim:override("character_details_with_button_hidden"):set_allowed(true)
					prologue_tutorial_passed["character_details_with_button_hidden"] = true
					cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh3_prologue_anc_armour_basic", true)
					cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh3_prologue_anc_follower_orthodoxy_pastor", true)
					prologue_check_progression["item_scripted_tour"] = true
					UnlockItemGeneration(true)
					cm:contextual_vo_enabled(true);

					cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)	

					if prologue_story_choice == 2 then
						prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_04", true)
						core:remove_listener("FactionTurnStart_Prologue_before_attack");
					else
						prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_03", true)
						core:remove_listener("FactionTurnStart_Prologue_before_attack");
					end
					core:remove_listener("PanelClosedCampaign_TroubleMission")
					
				end
			end
		end,
		true
	);

	prologue_end_of_dialogue("item_scripted_tour", "wh3_prologue_objective_turn_001_06", true)

	cm:force_grant_military_access("wh3_prologue_dervingard_garrison", prologue_player_faction, false);
	cm:contextual_vo_enabled(true);

	HighlightEndTurnButton();

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_beacon_setup();
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger before Beacon
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_beacon_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeBeacon",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_beacon_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_beacon_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_beacon_002() end, prologue_audio_timing["wh3_prologue_narrative_07_5_1"]) end);
end

function prologue_advice_linger_before_beacon_002()
	local advice = math.random(1,2);
	if advice == 1 then
		-- Advisor text: Hunt Skollden, the Wolf of Dervingard.
		cm:show_advice("wh3_prologue_narrative_07_5_1", true, false, prologue_advice_linger_before_beacon_end, 0, 0.5);
	else
		-- Advisor text: Hurry to the Beacon. Find the Wolf.
		cm:show_advice("wh3_prologue_narrative_07_6_1", true, false, prologue_advice_linger_before_beacon_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_beacon_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
	HighlightEndTurnButton();
end

if prologue_check_progression["trouble_dilemma_triggered"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["second_settlement_revealed"] == false then
	prologue_advice_linger_before_beacon_setup();
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Beacon Revealed
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_beacon_revealed_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_beacon_revealed_002() end, prologue_audio_timing["wh3_prologue_narrative_08_1_1"]) end);
end

function prologue_advice_beacon_revealed_002()
	-- Advisor text: I see the Beacon. The fort is under attack.   
	cm:show_advice("wh3_prologue_narrative_08_1_1", true, false, prologue_advice_beacon_revealed_003, 0, prologue_audio_timing["wh3_prologue_narrative_08_2_1"]);
end

function prologue_advice_beacon_revealed_003()
	-- Advisor text: The enemy carry the flag of the Wolf. It must be Skollden.
	cm:show_advice("wh3_prologue_narrative_08_2_1", true, false, prologue_advice_beacon_revealed_show_objective, 0, 0.5);
end


function prologue_advice_beacon_revealed_show_objective()

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_attack_setup();
	cm:contextual_vo_enabled(true);

	-- Check to see if player has already attacked Skollden.
	if prologue_load_check == "first_pre_battle" then
		prologue_end_of_dialogue("first_pre_battle", "", true)
	else
		prologue_end_of_dialogue("turn_attack", "", true)

		PrologueAddTopicLeader("wh3_prologue_objective_turn_006_01", function() if prologue_load_check == "first_pre_battle" then cm:remove_objective("wh3_prologue_objective_turn_006_01") end end)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger before attacking Skollden
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_attack_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeFirstBattle",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_attack_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_attack_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_attack_002() end, prologue_audio_timing["wh3_prologue_narrative_08_4_1"]) end);
end

function prologue_advice_linger_before_attack_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Do not delay, send us to battle!
		cm:show_advice("wh3_prologue_narrative_08_4_1", true, false, prologue_advice_linger_before_attack_end, 0, 0.5);
	elseif advice == 2 then 
		-- Advisor text: It's time to fight!
		cm:show_advice("wh3_prologue_narrative_08_5_1", true, false, prologue_advice_linger_before_attack_end, 0, 0.5);
	else
		-- Advisor text: HYuri, attack Skollden!
		cm:show_advice("wh3_prologue_narrative_08_6_1", true, false, prologue_advice_linger_before_attack_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_attack_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end

if prologue_check_progression["second_settlement_revealed"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["second_tutorial_army_created"] == false then
	prologue_advice_linger_before_attack_setup();
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- First pre-battle screen
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_pre_battle_001(player_panel, enemy_panel, player, enemy, attack)
	prologue_start_of_dialogue(true, function() cm:callback(function() prologue_advice_pre_battle_002(player_panel, enemy_panel, player, enemy, attack) end, prologue_audio_timing["wh3_prologue_narrative_09_1_1"]) end);
end


function prologue_advice_pre_battle_002(player_panel, enemy_panel, player, enemy, attack)
	-- Advisor text: Battle draws near. Our soldiers are ready. 
	cm:show_advice("wh3_prologue_narrative_09_1_1", true, false, function() prologue_advice_pre_battle_003(enemy_panel, enemy, attack) end, 0, prologue_audio_timing["wh3_prologue_narrative_09_2_1"]);
	cm:callback(function() player_panel:SetVisible(true); player_panel:TriggerAnimation("show"); end, 1);
	cm:callback(function() cm:trigger_2d_ui_sound("UI_CAM_PRO_HUD_Pre_Battle_Army_Reveal_Tutorial_Player", 0); end, 1);
	cm:callback(function() player:SetVisible(true); 
		local uic_unit_1 = find_uicomponent(core:get_ui_root(), "allies_combatants_panel", "army", "units_window", "units", "unit_3");
		local uic_unit_2 = find_uicomponent(core:get_ui_root(), "allies_combatants_panel", "army", "units_window", "units", "unit_4");
		local uic_unit_3 = find_uicomponent(core:get_ui_root(), "allies_combatants_panel", "army", "units_window", "units", "unit_5");
		
		if uic_unit_1 then
			uic_unit_1:SetVisible(false)
		end

		if uic_unit_2 then
			uic_unit_2:SetVisible(false)
		end

		if uic_unit_3 then
			uic_unit_3:SetVisible(false)
		end
	end, 2);
	--CcoCampaignCharacter::HighlightCharacter(true);
	
end

function prologue_advice_pre_battle_003(enemy_panel, enemy, attack)
	-- Advisor text: We see the enemy. The Wolf leads an army of northmen. 
	cm:show_advice("wh3_prologue_narrative_09_2_1", true, false, function() prologue_advice_pre_battle_004(attack) end, 0, prologue_audio_timing["wh3_prologue_narrative_09_3_1"]);
			
	cm:callback(function() enemy_panel:SetVisible(true); enemy_panel:TriggerAnimation("show"); end, 1);
	cm:callback(function() cm:trigger_2d_ui_sound("UI_CAM_PRO_HUD_Pre_Battle_Army_Reveal_Tutorial_Enemy", 0); end, 1);
	cm:callback(function() enemy:SetVisible(true); end, 2);
end

function prologue_advice_pre_battle_004(attack)
	-- Advisor text: We are eager to fight. Bring us to battle!   
	cm:show_advice("wh3_prologue_narrative_09_3_1", true, false, prologue_advice_pre_battle_end, 0, 0.5);

	--cm:callback(function() attack:SetVisible(true); attack:TriggerAnimation("show"); end, 1);
	
	cm:callback(function() cm:trigger_2d_ui_sound("UI_CAM_PRO_HUD_Pre_Battle_Reveal_Start_Battle_Button", 0); attack:SetVisible(true); end, 0.5);

	local attack_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_set_attack", "button_attack");
	if attack_button then
		cm:callback(function() pulse_uicomponent(attack_button, 2, 6); highlight_component(true, true, "popup_pre_battle", "button_set_attack", "button_attack"); end, 1);
	else
		out("COULDN@T FIND ATTACK BUTTON")
	end

	local map_button = find_uicomponent(core:get_ui_root(), "button_preview_map");
	if map_button then
		map_button:SetVisible(false);
	end
end

function prologue_advice_pre_battle_end()
	prologue_end_of_dialogue(false, false, false, true, false);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Post battle
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_post_battle_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_post_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_10_1_1"]) end);
end

function prologue_advice_post_battle_002()
	-- Advisor text: We hold enemy captives. Their fate is mine to decide. I pray for Ursun's guidance. 
	cm:show_advice("wh3_prologue_narrative_10_1_1", true, false, prologue_advice_post_battle_end, 0, 0.5);
end

function prologue_advice_post_battle_end()
	prologue_end_of_dialogue("first_post_battle", "", false, false, true)
	out("START INTERVENTION")

	uim:override("disable_help_pages_panel_button"):set_allowed(false);
	
	cm:dismiss_advice();
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		core:trigger_event("ScriptEventProloguePostBattleOptions");
	else
		-- Unlock panel
		uim:override("postbattle_middle_panel"):set_allowed(true);
		prologue_tutorial_passed["postbattle_middle_panel"] = true;

		local uic_post_battle_buttons = find_uicomponent(core:get_ui_root(), "battle_results");

		if uic_post_battle_buttons then
			uic_post_battle_buttons:SetVisible(true);
		end

		core:add_listener(
			"BattleCompletedCameraMove_post",
			"BattleCompletedCameraMove",
			true,
			function()
		
				-- check what needs to be done after a battle
				cm:callback(function() PrologueAfterPostBattle(); end, 5);
			end,
			false
		);
	
	end
	
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Mission complete - Saving Beacon
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_mission_complete_saving_beacon()
	
	core:add_listener(
		"PanelOpenedCampaign_UrsunMission",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "events"
		end,
		function()
			--Ursun text: The innocent are spared from the Wolf’s vicious pack. The Beacon is under our control, a sanctuary in the cold, harsh wastes, but this is not Dervingard. Kislev’s northern stronghold awaits. 
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_02_2_1_1", "", 2.0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(43, "completed_rescue_mission", false);
		end,
		false
	);


	-- complete the mission
	prologue_mission_rescue:force_scripted_objective_success("mission_prologue_rescue");

	local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
	cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_0_2");
	cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_0_2");

	core:add_listener(
		"PanelClosedCampaign_RescueMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()	
			cm:stop_campaign_advisor_vo();
			prologue_advice_units_panel_001()
		end,
		false
	);
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Unlock Units panel post battle
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_units_panel_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_units_panel_002() end, prologue_audio_timing["wh3_prologue_narrative_11_1_1"]) end)
end

function prologue_advice_units_panel_002()
	-- Advisor text: A great victory! The survivors swear allegiance.
	cm:show_advice("wh3_prologue_narrative_11_1_1", true, false, prologue_advice_units_panel_003, 0, prologue_audio_timing["wh3_prologue_narrative_11_2_1"]);
end	

function prologue_advice_units_panel_003()
	-- Advisor text: They will aid our search for Ursun. Those with the heart to fight, let them join us. 
	cm:show_advice("wh3_prologue_narrative_11_2_1", true, false, prologue_advice_units_panel_show_objective, 0, 0.5);
end	

function prologue_advice_units_panel_show_objective()
	prologue_end_of_dialogue("before_unit_recruitment", "", false, false)
	
	SetUpUnitRecruitmentTour()
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger while recruiting
--------------------------------------------------------------------------------------------------------------------------------------------------

function SetUpRecruitLingeringCallback()
	cm:callback(function() prologue_advice_linger_recruit_001(); end, 15, "recruit_callback")

	core:add_listener(
		"RecruitmentItemIssuedByPlayerRecruitmentLinger",
		"RecruitmentItemIssuedByPlayer",
		true,
		function()
			if units_recruited == 3 then
				cm:remove_callback("recruit_callback");
			end
		end,
		true
	);
end

function prologue_advice_linger_recruit_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_recruit_002() end, prologue_audio_timing["wh3_prologue_narrative_12_6_1"]) end);
end

function prologue_advice_linger_recruit_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Recruit from the Beacon's survivors.
		cm:show_advice("wh3_prologue_narrative_12_6_1", true, false, prologue_advice_linger_recruit_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: We need fresh troops, Yuri.
		cm:show_advice("wh3_prologue_narrative_12_7_1", true, false, prologue_advice_linger_recruit_end, 0, 0.5);
	else
		-- Advisor text: Recruit Kossars.
		cm:show_advice("wh3_prologue_narrative_12_8_1", true, false, prologue_advice_linger_recruit_end, 0, 0.5);
	end
end

function prologue_advice_linger_recruit_end()
	cm:dismiss_advice();
	if units_recruited == 3 then
		prologue_end_of_dialogue(false, "", true)
	else
		prologue_end_of_dialogue(false, "", false)
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Find Skollden
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_find_petrenko_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_find_petrenko_002() end, prologue_audio_timing["wh3_prologue_narrative_12_1_1"]); end);
end		

function prologue_advice_find_petrenko_002()
	-- Advisor text: Our army grows! New soldiers, eager to fight.
	cm:show_advice("wh3_prologue_narrative_12_1_1", true, false, prologue_advice_find_petrenko_003, 0, prologue_audio_timing["wh3_prologue_narrative_12_2_1"]);
end

function prologue_advice_find_petrenko_003()
	-- Advisor text: They will see battle soon enough.
	cm:show_advice("wh3_prologue_narrative_12_2_1", true, false, prologue_advice_find_petrenko_trigger_mission, 0, 0.5);
end

function prologue_advice_find_petrenko_trigger_mission()

	prologue_end_of_dialogue(false, "", false, false, true)

	cm:dismiss_advice();
	
	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			--Ursun text: The spirit of men is frail, so easily corrupted. The northern tribes worship the Dark Gods. The chief of the Gharhars, Skollden, hungers for Kislevite blood. While he lives, he will hinder your search and prey on our people. The Wolf must be tamed.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_03_1_1_1", "", 2.0);

			core:add_listener(
				"PanelClosedCampaign_RevengeMission",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()						
					prologue_start_of_dialogue(false, function() prologue_advice_find_petrenko_004() end)														
					cm:stop_campaign_advisor_vo();		
				end,
				false
			);	
		end,
		false
	);

	prologue_mission_revenge:trigger();	

end

function prologue_advice_find_petrenko_004() 
	cm:callback(function() prologue_advice_find_petrenko_005() end, prologue_audio_timing["wh3_prologue_narrative_12_3_1"]);
end	

function prologue_advice_find_petrenko_005()
	-- Advisor text: Should we stay at the Beacon? Let the soldiers rest?
	cm:show_advice("wh3_prologue_narrative_12_3_1", true, false, prologue_advice_find_petrenko_006, 0, prologue_audio_timing["wh3_prologue_narrative_12_4_1"]);
end

function prologue_advice_find_petrenko_006() 
	-- Advisor text: We follow Skollden's trail. He must not get away. 
	cm:show_advice("wh3_prologue_narrative_12_4_1", true, false, prologue_advice_find_petrenko_show_objective, 0, 0.5);
end

function prologue_advice_find_petrenko_show_objective()
	prologue_end_of_dialogue("leave_beacon_fort_end", "wh3_prologue_objective_turn_013_03", true)

	cm:contextual_vo_enabled(true);

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_leaving_beacon_setup();

	-- reduce action points
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
end

function prologue_advice_find_petrenko_part_two_001()
	prologue_start_of_dialogue(false, function() prologue_advice_find_petrenko_part_two_002() end)	
end

function prologue_advice_find_petrenko_part_two_002()
	-- Advisor text: We’ve marched as far as we can.
	cm:show_advice("wh3_prologue_narrative_12_5_1", true, false, prologue_advice_find_petrenko_part_two_end, 0, 0.5);
end

function prologue_advice_find_petrenko_part_two_end()
	PrologueResetLingerVariable("FactionTurnStartLingerBeforeLeavingBeacon");
	prologue_end_of_dialogue("", "", true)
	HighlightEndTurnButton();
	cm:contextual_vo_enabled(true);
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger before leaving the beacon
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_leaving_beacon_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeLeavingBeacon",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_leaving_beacon_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_leaving_beacon_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_leaving_beacon_002() end, prologue_audio_timing["wh3_prologue_narrative_13_6_1"]) end);
end

function prologue_advice_linger_before_leaving_beacon_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Leave the Beacon. Journey north and find Skollden.
		cm:show_advice("wh3_prologue_narrative_13_6_1", true, false, prologue_advice_linger_before_leaving_beacon_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: We should leave the Beacon.
		cm:show_advice("wh3_prologue_narrative_13_7_1", true, false, prologue_advice_linger_before_leaving_beacon_end, 0, 0.5);
	else
		-- Advisor text: Move north. Find Skollden!
		cm:show_advice("wh3_prologue_narrative_13_8_1", true, false, prologue_advice_linger_before_leaving_beacon_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_leaving_beacon_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	HighlightEndTurnButton();
	cm:contextual_vo_enabled(true);
end

if prologue_check_progression["recruited_units_tutorial_complete"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["second_battle"] == false then
	prologue_advice_linger_before_leaving_beacon_setup();
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Skollden Attacks
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_petrenko_attacks_001()
	prologue_start_of_dialogue(true, function() cm:callback(function() prologue_advice_petrenko_attacks_002() end, prologue_audio_timing["wh3_prologue_narrative_13_1_1"]); end)
end

function prologue_advice_petrenko_attacks_002()
	-- Advisor text: Skollden! He was lying in wait!
	cm:show_advice("wh3_prologue_narrative_13_1_1", true, false, prologue_advice_petrenko_attacks_003, 0, prologue_audio_timing["wh3_prologue_narrative_13_2_1"]);
end

function prologue_advice_petrenko_attacks_003()
	-- Advisor text: Let him come. He will find us stronger than before.  
	cm:show_advice("wh3_prologue_narrative_13_2_1", true, false);
	prologue_end_of_dialogue(false, "", false, false, true)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Second pre-battle screen
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_pre_battle_two_001()
	prologue_start_of_dialogue(true, function() cm:callback(function() prologue_advice_pre_battle_two_002() end, 0.5); end)
end

function prologue_advice_pre_battle_two_002()
	-- Advisor text: The Wolf charges towards us!
	cm:show_advice("wh3_prologue_narrative_13_4_1", true, false, prologue_advice_pre_battle_two_002_end, 0, 0.5);
end

function prologue_advice_pre_battle_two_002_end()
	prologue_end_of_dialogue(false, "", false, false, true)

	uim:override("disable_help_pages_panel_button"):set_allowed(false);
end

function prologue_advice_pre_battle_two_003()
	-- Advisor text: Quick, brother, make ready for attack.
	cm:show_advice("wh3_prologue_narrative_13_3_1", true, false, prologue_advice_pre_battle_two_004, 0, prologue_audio_timing["wh3_prologue_narrative_13_5_1"]);
end

function prologue_advice_pre_battle_two_004()
	-- Advisor text: Our only option is to fight!
	cm:show_advice("wh3_prologue_narrative_13_5_1", true, false, prologue_advice_pre_battle_two_end, 0, 0.5);
end

function prologue_advice_pre_battle_two_end()
	prologue_end_of_dialogue(false, false, false, true, false);

	--uim:override("disable_help_pages_panel_button"):set_allowed(false);
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- After the second battle - post battle
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_after_second_battle_post_battle_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_after_second_battle_post_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_14_1_1"]); end);
end

function prologue_advice_after_second_battle_post_battle_002()
	-- Advisor text: Those who follow the Wolf. I decide their fate. What would Ursun do?
	cm:show_advice("wh3_prologue_narrative_14_1_1", true, false, prologue_advice_after_second_battle_post_battle_end, 0, 0.5);
end

function prologue_advice_after_second_battle_post_battle_end()
	prologue_end_of_dialogue("", "", true);

	uim:override("postbattle_middle_panel"):set_allowed(true);
	prologue_tutorial_passed["postbattle_middle_panel"] = true;

	local uic_post_battle_buttons = find_uicomponent(core:get_ui_root(), "battle_results");

	if uic_post_battle_buttons then
		uic_post_battle_buttons:SetVisible(true);
	end
end




--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Mission complete - Fought Skollden twice
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_second_fight()
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

	core:add_listener(
		"PanelOpenedCampaign_UrsunMission",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "events"
		end,
		function()
			--Ursun text: The cur runs, yelping for his Dark Gods. He fears your strength and returns to Dervingard. 
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_03_2_1_1", "", 2.0);

			core:add_listener(
				"PanelClosedCampaign_RevengeEndMission",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()	
					cm:stop_campaign_advisor_vo();																	
					prologue_advice_after_second_battle_skills_001_1();
				end,
				false
			);	
		end,
		false
	);

	-- complete the mission
	prologue_mission_revenge:force_scripted_objective_success("mission_prologue_revenge");

	local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
	cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_0_3");
	cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_0_3");

	cm:toggle_dilemma_generation(false);

end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- After the second battle - skills unlocked
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_after_second_battle_skills_001_1()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_after_second_battle_skills_002() end, prologue_audio_timing["wh3_prologue_narrative_14_2_1"]); end);
end

function prologue_advice_after_second_battle_skills_002()
	-- Advisor text: Two victories Yuri! The more we fight, the greater our skill.
	cm:show_advice("wh3_prologue_narrative_14_2_1", true, false, prologue_advice_after_second_battle_skills_show_objective, 0, 0.5);
end

function prologue_advice_after_second_battle_skills_show_objective()
	
	-- This is disabled to stop players loading inbetween a long chain of objectives/dialogues/events/interventions.
	-- It is disabled again after the skills intervention.
	-- It is re-enabled after the dialogue in prologue_advice_post_battle_move_out_trigger_mission.
	prologue_end_of_dialogue("", "", false, true);
	-- start the intevention about skills
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		uim:override("disable_help_pages_panel_button"):set_allowed(false);
		core:trigger_event("ScriptEventPrologueSkills");
	else
		uim:disable_character_selection_whitelist()
		disable_event_type(false, "character_rank_gained")
		uim:override("skills_with_button_hidden"):set_allowed(true);
		prologue_tutorial_passed["skills_with_button_hidden"] = true;
		PrologueAddTopicLeader("wh3_prologue_objective_turn_016_01"); 

		-- Kill enemy army
		local enemy_army_list = cm:model():world():faction_by_key(enemy_faction_name):military_force_list();
		for i = 0, enemy_army_list:num_items() - 1 do
			if enemy_army_list:item_at(i):upkeep() > 0 then
				local enemy_army_cqi = enemy_army_list:item_at(i):general_character():cqi();
				cm:kill_character(enemy_army_cqi, true);
			end
		end

		--local x = cm:model():world():region_manager():region_by_key("wh3_prologue_region_frozen_plains_dervingard"):settlement():logical_position_x();
		--local y = cm:model():world():region_manager():region_by_key("wh3_prologue_region_frozen_plains_dervingard"):settlement():logical_position_y();
		out("CREATING NEW PETRENKO ARMY")
		cm:create_force_with_general(
			enemy_faction_name, 
			"wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1",
			"wh3_prologue_region_frozen_plains_dervingard",
			424, 
			242,
			"general",
			"wh3_main_pro_ksl_sergi_0",
			"names_name_1250431856",
			"",
			"names_name_269711447",
			"",
			true,
			function(cqi)
				enemy_army_cqi = cqi;
				out("CREATED ENEMY ARMY")
				PrologueListenerToJoinGarrison();
			end
		);

		core:add_listener(
			"hide_mission_panel",
			"PanelClosedCampaign",
			function(context) 
				return context.string == "character_details_panel" 
			end,
			function()
				prologue_advice_post_battle_move_out_001();
			end,
			false
		);
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger while selecting skills
--------------------------------------------------------------------------------------------------------------------------------------------------

function SetUpSkillsLingeringCallback()
	cm:callback(function() prologue_advice_linger_skills_001(); end, 15, "skills_callback")

	core:add_listener(
		"CharacterSkillPointAllocatedLinger",
		"CharacterSkillPointAllocated", 
		true,
		function(context)
			cm:remove_callback("skills_callback");
			core:remove_listener("CharacterSkillPointAllocatedLinger");
		end,
		true
	);

end

function prologue_advice_linger_skills_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_skills_002() end, prologue_audio_timing["wh3_prologue_narrative_14_2_2"]) end);
end

function prologue_advice_linger_skills_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: You have gained experience, Yuri. Improve a skill to gain advantage.
		cm:show_advice("wh3_prologue_narrative_14_2_2", true, false, prologue_advice_linger_skills_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: We are veteran fighters. New skills can be honed.
		cm:show_advice("wh3_prologue_narrative_14_2_3", true, false, prologue_advice_linger_skills_end, 0, 0.5);
	else
		-- Advisor text: Improve your skills, Yuri. Choose one to gain advantage.
		cm:show_advice("wh3_prologue_narrative_14_2_4", true, false, prologue_advice_linger_skills_end, 0, 0.5);
	end
end

function prologue_advice_linger_skills_end()
	cm:dismiss_advice();
	if prologue_check_progression["st_skill_point_complete"] == true then
		prologue_end_of_dialogue(false, "", true)
	else
		prologue_end_of_dialogue(false, "", false)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- After the second battle - Move towards Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_post_battle_move_out_001()
	PrologueRemoveObjective();
	cm:trigger_2d_ui_sound("Campaign_Environment_Element_Howling_Wolf_Stinger", 0);
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_post_battle_move_out_002() end, prologue_audio_timing["wh3_prologue_narrative_14_3_1"]); end)
end

function prologue_advice_post_battle_move_out_002()
	-- Advisor text: Listen… wolves howl in the north. Something disturbs them.
	cm:show_advice("wh3_prologue_narrative_14_3_1", true, false, prologue_advice_post_battle_move_out_003, 0, prologue_audio_timing["wh3_prologue_narrative_14_4_1"]);
end

function prologue_advice_post_battle_move_out_003()
	-- Advisor text: They howl for Skollden. A wounded animal. 
	cm:show_advice("wh3_prologue_narrative_14_4_1", true, false, prologue_advice_post_battle_move_out_trigger_mission, 0, 0.5);
end

function prologue_advice_post_battle_move_out_trigger_mission()
	prologue_end_of_dialogue("", "", false);

	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			-- Ursun text: The time has come to march on Dervingard and free our kin. If you do not strike swiftly, the Wolf will recover. End his reign of bloodshed.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_04_1_1_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(56, "triggered_reclaim_mission", false);
		end,
		false
	);

	prologue_mission_reclaim:trigger();
	prologue_check_progression["triggered_reclaim_mission"] = true

	core:add_listener(
		"PanelClosedCampaign_ReclaimMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()										
			cm:stop_campaign_advisor_vo();									
			prologue_advice_post_battle_move_out_004();				
		end,
		false
	);

	PrologueListenerForUpkeep()
end

function prologue_advice_post_battle_move_out_004()
	PrologueRemoveObjective();
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_post_battle_move_out_005() end, prologue_audio_timing["wh3_prologue_narrative_14_5_1"]); end)
end

function prologue_advice_post_battle_move_out_005()
	-- Advisor text: Ursun guides me. Dervingard is close. 
	cm:show_advice("wh3_prologue_narrative_14_5_1", true, false, prologue_advice_post_battle_move_out_006, 0, prologue_audio_timing["wh3_prologue_narrative_14_6_1"]);
end

function prologue_advice_post_battle_move_out_006()
	-- Advisor text: Then give the order. We’re ready to march.
	cm:show_advice("wh3_prologue_narrative_14_6_1", true, false, prologue_advice_post_battle_move_out_show_objective, 0, 0.5);
end

function prologue_advice_post_battle_move_out_show_objective()
	cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 0.6)
	
	-- Restore Yuri's actions points since Gerik says he can move.
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
	cm:contextual_vo_enabled(true);

	prologue_end_of_dialogue("after_skills", "wh3_prologue_objective_turn_015_01", true);
	cm:disable_pathfinding_restriction(3);
	
	-- Add help reminder to make sure it gets seen before Dervingard
	AddHelpReminder()

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_dervingard_setup();
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger before Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_dervingard_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeDervingard",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_dervingard_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_dervingard_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_dervingard_002() end, prologue_audio_timing["wh3_prologue_narrative_14_9_1"]) end);
end

function prologue_advice_linger_before_dervingard_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Dervingard is north of here. March to the stronghold.
		cm:show_advice("wh3_prologue_narrative_14_9_1", true, false, prologue_advice_linger_before_dervingard_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: March to Dervingard. Liberate the stronghold.
		cm:show_advice("wh3_prologue_narrative_14_10_1", true, false, prologue_advice_linger_before_dervingard_end, 0, 0.5);
	else
		-- Advisor text: Push north. Hunt the Wolf.
		cm:show_advice("wh3_prologue_narrative_14_11_1", true, false, prologue_advice_linger_before_dervingard_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_dervingard_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end

if prologue_check_progression["triggered_reclaim_mission"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["found_dervingard"] == false then
	prologue_advice_linger_before_dervingard_setup();
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Found Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_dervingard_revealed_001()
	PrologueResetLingerVariable("FactionTurnStartLingerBeforeDervingard");
	cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 0)
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_dervingard_revealed_002() end, prologue_audio_timing["wh3_prologue_narrative_14_7_1"]); end);
end

function prologue_advice_dervingard_revealed_002()
	-- Advisor text: There, I see it.
	cm:show_advice("wh3_prologue_narrative_14_7_1", true, false, prologue_advice_dervingard_revealed_003, 0, prologue_audio_timing["wh3_prologue_narrative_14_8_1"]);
end

function prologue_advice_dervingard_revealed_003()
	-- Advisor text: At last… Dervingard.
	cm:show_advice("wh3_prologue_narrative_14_8_1", true, false, prologue_advice_dervingard_revealed_show_objective, 0, 0.5);
end

function prologue_advice_dervingard_revealed_show_objective()
	prologue_end_of_dialogue("found_dervingard", "", true)
	PrologueAddTopicLeader("wh3_prologue_objective_turn_001_06", function() HighlightEndTurnButton() end, true)
	cm:contextual_vo_enabled(true);

	prologue_trigger_linger = cm:model():turn_number() + 2;
	prologue_advice_linger_before_dervingard_battle_setup();
	
	load_check_found_dervingard()
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger before attacking Skollden in Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_before_dervingard_battle_setup()
	core:add_listener(
		"FactionTurnStartLingerBeforeDervingardBattle",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			if cm:model():turn_number() == prologue_trigger_linger then
				prologue_advice_linger_before_dervingard_battle_001();
			end
		end,
		true
	);
end

function prologue_advice_linger_before_dervingard_battle_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_before_dervingard_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_15_1_1"]) end);
end

function prologue_advice_linger_before_dervingard_battle_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Skollden hides in Dervingard. Slay the Wolf.
		cm:show_advice("wh3_prologue_narrative_15_1_1", true, false, prologue_advice_linger_before_dervingard_battle_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Skollden waits for us. Push the attack.
		cm:show_advice("wh3_prologue_narrative_15_2_1", true, false, prologue_advice_linger_before_dervingard_battle_end, 0, 0.5);
	else
		-- Advisor text: Move to attack Skollden. Kill the Wolf and liberate Dervingard.
		cm:show_advice("wh3_prologue_narrative_15_3_1", true, false, prologue_advice_linger_before_dervingard_battle_end, 0, 0.5);
	end
end

function prologue_advice_linger_before_dervingard_battle_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", true)
	cm:contextual_vo_enabled(true);
end

if prologue_check_progression["found_dervingard"] == true and cm:model():turn_number() <= prologue_trigger_linger and prologue_check_progression["dervingard_battle_complete"] == false then
	prologue_advice_linger_before_dervingard_battle_setup();
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Dervingard Pre-battle screen
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_dervingard_pre_battle_001()
	PrologueResetLingerVariable("FactionTurnStartLingerBeforeDervingardBattle");
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_dervingard_pre_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_16_1_1"]); end);
end

function prologue_advice_dervingard_pre_battle_002()
	-- Gerik: Fort Dervingard! Finally we reach these walls. 
	cm:show_advice("wh3_prologue_narrative_16_1_1", true, false, prologue_advice_dervingard_pre_battle_003, 0, prologue_audio_timing["wh3_prologue_narrative_16_2_1"]);
end

function prologue_advice_dervingard_pre_battle_003()
	-- Yuri: Do not celebrate yet, Gerik. First we must deal with the Wolf!
	cm:show_advice("wh3_prologue_narrative_16_2_1", true, false, prologue_advice_dervingard_pre_battle_end, 0, 0.5);
end


function prologue_advice_dervingard_pre_battle_end()
	prologue_end_of_dialogue("", "", false, true, false)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- After Dervingard Battle - Post battle screen
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_dervingard_post_battle_001()
	prologue_start_of_dialogue(true, function () cm:callback(function() prologue_advice_dervingard_post_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_17_1_1"]); end);
end

function prologue_advice_dervingard_post_battle_002()
	-- Advisor text: Defilers of Dervingard. What fate do they deserve?
	cm:show_advice("wh3_prologue_narrative_17_1_1", true, false);
	prologue_end_of_dialogue(false, "", false, false, true)
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- After Dervingard Battle - Sword aqcuired
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_at_dervingard_sword_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_at_dervingard_sword_002() end, prologue_audio_timing["wh3_prologue_narrative_17_2_1"]); end);
end

function prologue_advice_at_dervingard_sword_002()
	-- Advisor text: Leave the sword. The weapon is cursed.
	cm:show_advice("wh3_prologue_narrative_17_2_1", true, false, prologue_advice_at_dervingard_sword_003, 0, prologue_audio_timing["wh3_prologue_narrative_17_2_2"]);
end

function prologue_advice_at_dervingard_sword_003()
	-- Advisor text: The blade is too rare to be cast aside. 
	cm:show_advice("wh3_prologue_narrative_17_2_2", true, false, prologue_advice_at_dervingard_sword_004, 0, prologue_audio_timing["wh3_prologue_narrative_17_2_3"]);
end

function prologue_advice_at_dervingard_sword_004()
	-- Advisor text: You hold sin in your hand.
	cm:show_advice("wh3_prologue_narrative_17_2_3", true, false, prologue_advice_at_dervingard_sword_005, 0, prologue_audio_timing["wh3_prologue_narrative_17_2_4"]);
end

function prologue_advice_at_dervingard_sword_005()
	-- Advisor text: I hold strength in my hand. Nothing more.
	cm:show_advice("wh3_prologue_narrative_17_2_4", true, false, prologue_advice_at_dervingard_sword_show_intervention, 0, 0.5);
end

function prologue_advice_at_dervingard_sword_show_intervention()
	prologue_end_of_dialogue(false, "", false, false, true)
	cm:dismiss_advice();
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		--TRIGGER SWORD INTERVENTION
		core:trigger_event("ScriptEventPrologueSwordAbility");
	else
		prologue_advice_at_dervingard_001();
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Finally at Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_at_dervingard_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_at_dervingard_002() end, prologue_audio_timing["wh3_prologue_narrative_17_3_1"]); end)
end

function prologue_advice_at_dervingard_002()
	-- Advisor text: Look around you. Dervingard is infested with Chaos.   
	cm:show_advice("wh3_prologue_narrative_17_3_1", true, false, prologue_advice_at_dervingard_003, 0, prologue_audio_timing["wh3_prologue_narrative_17_4_1"]);
end

function prologue_advice_at_dervingard_003()
	-- Advisor text: We sanctify the grounds. 
	cm:show_advice("wh3_prologue_narrative_17_4_1", true, false, prologue_advice_at_dervingard_004, 0, prologue_audio_timing["wh3_prologue_narrative_17_5_1"]);
end

function prologue_advice_at_dervingard_004()
	-- Advisor text: How brother? How do we purge chaos from these walls?
	cm:show_advice("wh3_prologue_narrative_17_5_1", true, false, prologue_advice_at_dervingard_005, 0, prologue_audio_timing["wh3_prologue_narrative_17_6_1"]);
end

function prologue_advice_at_dervingard_005()
	-- Advisor text: We build a totem to Ursun. Let our devotion banish corruption.
	cm:show_advice("wh3_prologue_narrative_17_6_1", true, false, prologue_advice_at_dervingard_show_objective, 0, 0.5);
end

function prologue_advice_at_dervingard_show_objective()
	cm:dismiss_advice()
	ConstructionTopicLeaders("wh3_prologue_objective_turn_014_02", "wh3_prologue_objective_turn_014_03", true)
	cm:contextual_vo_enabled(true);
	
	if prologue_check_progression["special_building_in_progress"] == true then
		prologue_advice_at_dervingard_006();
	else
		prologue_end_of_dialogue("before_building_growth", "", false);

		cm:callback(function() prologue_advice_linger_build_totem_001(); end, 15, "build_totem_callback")

		core:add_listener(
			"BuildingConstructionIssuedByBuildTotem",
			"BuildingConstructionIssuedByPlayer",
			true,
			function()
				cm:remove_callback("build_totem_callback");
			end,
			false
		);
		
		cm:contextual_vo_enabled(true);
		load_check_before_building_growth() 
	end
end

function prologue_advice_at_dervingard_006()
	cm:contextual_vo_enabled(false);
	PrologueRemoveObjective();
	-- Advisor text: I pray Ursun can absolve the stronghold.
	cm:show_advice("wh3_prologue_narrative_17_7_1", true, false, prologue_advice_at_dervingard_007, 0, prologue_audio_timing["wh3_prologue_narrative_17_8_1"]);
end

function prologue_advice_at_dervingard_007()
	-- Advisor text: He will help us. Dervingard will be restored.
	cm:show_advice("wh3_prologue_narrative_17_8_1", true, false, prologue_advice_at_dervingard_end, 0, 0.5);
end

function prologue_advice_at_dervingard_end()
	prologue_end_of_dialogue("after_building_growth", "", false)
	load_check_before_building_growth_end_turn()
	Add_Growth_Building_Progress_End_Turn_Listeners();
	cm:contextual_vo_enabled(true);
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- Linger while building totem
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_linger_build_totem_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_linger_build_totem_002() end, prologue_audio_timing["wh3_prologue_narrative_17_9_1"]) end);
end

function prologue_advice_linger_build_totem_002()
	local advice = math.random(1,3);
	if advice == 1 then
		-- Advisor text: Our faith can purify Dervingard. Give the order to build a Totem.
		cm:show_advice("wh3_prologue_narrative_17_9_1", true, false, prologue_advice_linger_build_totem_end, 0, 0.5);
	elseif advice == 2 then
		-- Advisor text: Chaos taints Dervingard. Build a Totem to Ursun.
		cm:show_advice("wh3_prologue_narrative_17_10_1", true, false, prologue_advice_linger_build_totem_end, 0, 0.5);
	else
		-- Advisor text: Build a Totem.
		cm:show_advice("wh3_prologue_narrative_17_11_1", true, false, prologue_advice_linger_build_totem_end, 0, 0.5);
	end
end

function prologue_advice_linger_build_totem_end()
	cm:dismiss_advice();
	cm:contextual_vo_enabled(true);
	if prologue_check_progression["special_building_in_progress"] == false then
		prologue_end_of_dialogue(false, "", false)
	else
		prologue_end_of_dialogue(false, "", true)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Leave Dervingard
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_leave_dervingard_001()
	PrologueRemoveObjective();
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_leave_dervingard_002() end, prologue_audio_timing["wh3_prologue_narrative_18_1_1"]); end)

end

function prologue_advice_leave_dervingard_002()
	-- Advisor text: You were right. The taint of chaos recedes.  
	cm:show_advice("wh3_prologue_narrative_18_1_1", true, false, prologue_advice_leave_dervingard_003, 0, prologue_audio_timing["wh3_prologue_narrative_18_2_1"]);
end

function prologue_advice_leave_dervingard_003()
	-- Advisor text: Then Dervingard is truly liberated. 
	cm:show_advice("wh3_prologue_narrative_18_2_1", true, false, prologue_advice_leave_dervingard_mission_complete, 0, 0.5);
end

function prologue_advice_leave_dervingard_mission_complete()
	cm:dismiss_advice();
	prologue_end_of_dialogue(false, "", false, true)

	local event_triggered = false;
	
	core:add_listener(
		"PanelOpenedCampaign_UrsunMission",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "events"
		end,
		function()
			--Ursun text: Once more the light of Kislev shines in the darkness of the Chaos Wastes. Dervingard is free from tyranny. 
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_04_2_1_1", "", 2.0);

			event_triggered = true;

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(70, "completed_reclaim_mission", false);
	
		end,
		false
	);

	-- complete the mission
	prologue_mission_reclaim:force_scripted_objective_success("mission_prologue_reclaim");
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	
	if event_triggered == true then
		core:add_listener(
			"MissionComplete_dervingard",
			"PanelClosedCampaign",
			function(context) 
				return context.string == "events" 
			end,
			function()
				cm:stop_campaign_advisor_vo();
				core:add_listener(
					"MissionComplete_dervingard_item",
					"PanelClosedCampaign",
					function(context) 
						return context.string == "events" 
					end,
					function()
						if new_player then
							cm:stop_campaign_advisor_vo();
							core:trigger_event("ScriptEventVictoryConditionFulfilled");
						else
							prologue_advice_leave_dervingard_004();
						end
					end,
					false
				);
				
			end,
			false
		);
	else
		if new_player then
			core:trigger_event("ScriptEventVictoryConditionFulfilled");
		else
			prologue_advice_leave_dervingard_004();
		end
	end

	


end

function prologue_advice_leave_dervingard_004()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_leave_dervingard_005() end, prologue_audio_timing["wh3_prologue_narrative_18_3_1"]); end)
end

function prologue_advice_leave_dervingard_005()
	-- Advisor text: Word has reached those in hiding. They return to us. 
	cm:show_advice("wh3_prologue_narrative_18_3_1", true, false, prologue_advice_leave_dervingard_006, 0, prologue_audio_timing["wh3_prologue_narrative_18_4_1"]);
end

function prologue_advice_leave_dervingard_006()
	-- Advisor text: A Frost Maiden. We are fortunate to find a magic user.
	cm:show_advice("wh3_prologue_narrative_18_4_1", true, false, prologue_advice_leave_dervingard_trigger_intervention, 0, 0.5);
end

function prologue_advice_leave_dervingard_trigger_intervention()
	prologue_end_of_dialogue("", false, true);
	PrologueAddIceMaiden();
end
----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After Journal story panel - option 1
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_journal_option_1_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_journal_option_1_002() end, prologue_audio_timing["wh3_prologue_narrative_18_5_1"]); end)
end

function prologue_advice_journal_option_1_002()
	-- Advisor text: The testament of a traitor. No-one needs to see such heresy.
	cm:show_advice("wh3_prologue_narrative_18_5_1", true, false, prologue_advice_journal_end, 0, 0.5);
end

function prologue_advice_journal_end()

	prologue_end_of_dialogue("", "", false);
	cm:dismiss_advice();

	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			--Ursun text: Dervingard is reclaimed. Now we embark on a greater quest. Deep in the Chaos Wastes stands the citadel that howls. Within its halls lies a hidden portal that leads to my prison. The Citadel cannot be reached by mortal means, the Screaming Chasm prevents it. Journey to the Lucent Maze. Find the secret runes. They hold the knowledge you seek.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_05_1_1_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(77, "triggered_lucent_maze_quest_battle", false);
		end,
		false
	);

	cm:trigger_mission(prologue_player_faction, "wh3_prologue_mission_riddles", true) 

	core:add_listener(
		"Prologue_RiddlesMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()
			cm:stop_campaign_advisor_vo();
			
			cm:disable_saving_game(true)
			cm:disable_pathfinding_restriction(5);

			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				core:trigger_event("ScriptEventPrologueQuestMarker");
			else
				cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_3");
				prologue_advice_towards_the_maze_001();
				uim:override("campaign_flags"):set_allowed(true);
			end
		end,
		false
	);

end

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After Journal story panel - option 2
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_journal_option_2_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_journal_option_2_002() end, prologue_audio_timing["wh3_prologue_narrative_18_6_1"]); end)
end

function prologue_advice_journal_option_2_002()
	-- Advisor text: A book of lies. Burn it.
	cm:show_advice("wh3_prologue_narrative_18_6_1", true, false, prologue_advice_journal_option_2_003, 0, prologue_audio_timing["wh3_prologue_narrative_18_7_1"]);
end

function prologue_advice_journal_option_2_003()
	-- Advisor text: The testament of a traitor. He will face justice.
	cm:show_advice("wh3_prologue_narrative_18_7_1", true, false, prologue_advice_journal_end, 0, 0.5);
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After lucent maze mission has triggered
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_towards_the_maze_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_towards_the_maze_002() end, prologue_audio_timing["wh3_prologue_narrative_19_1_1"]); end)
end

function prologue_advice_towards_the_maze_002()
	-- Advisor text: At first light, we leave Dervingard. 
	cm:show_advice("wh3_prologue_narrative_19_1_1", true, false, prologue_advice_towards_the_maze_003, 0, prologue_audio_timing["wh3_prologue_narrative_19_2_1"]); 
end

function prologue_advice_towards_the_maze_003()
	-- Advisor text: Leave? We gave our word! To keep Dervingard safe.
	cm:show_advice("wh3_prologue_narrative_19_2_1", true, false, prologue_advice_towards_the_maze_004, 0, prologue_audio_timing["wh3_prologue_narrative_19_3_1"]);
end

function prologue_advice_towards_the_maze_004()
	-- Advisor text: Ursun confides in me. We must journey through the Chaos Wastes and find the Lucent Maze. The next step to save Ursun.
	cm:show_advice("wh3_prologue_narrative_19_3_1", true, false, prologue_advice_towards_the_maze_end, 0, 0.5);
end

function prologue_advice_towards_the_maze_end()
	prologue_end_of_dialogue("post_dervingard", "", true);
	cm:dismiss_advice();
	cm:contextual_vo_enabled(true);

	PrologueAddTopicLeader("wh3_prologue_objective_chaos_wastes", function() if prologue_check_progression["open_world"] then cm:remove_objective("wh3_prologue_objective_chaos_wastes") end end)

	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)

end



----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Reached the fork in the road
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_fork_in_the_road_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_fork_in_the_road_002() end, prologue_audio_timing["wh3_prologue_narrative_20_1_1"]); end)
	PrologueRemoveObjective();
end

function prologue_advice_fork_in_the_road_002()
	-- Advisor text: The path divides. Which way?
	cm:show_advice("wh3_prologue_narrative_20_1_1", true, false, prologue_advice_fork_in_the_road_003, 0, prologue_audio_timing["wh3_prologue_narrative_20_1_2"]);
end

function prologue_advice_fork_in_the_road_003()
	-- Advisor text: Ursun is silent. I must decide.  
	cm:show_advice("wh3_prologue_narrative_20_1_2", true, false, prologue_advice_fork_in_the_road_end, 0, 0.5);
end

function prologue_advice_fork_in_the_road_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue("reached_fork", "", true);
	prologue_check_progression["open_world"] = true
	
	-- Allow AI settlement growth.
	stop_ai_settlement_growth(false)
	cm:contextual_vo_enabled(true);

	cm:remove_objective("wh3_prologue_objective_chaos_wastes")
	add_demolish_listener()

	-- Unlock all advanced pre-battle UI.
	uim:override("pre_battle_autoresolve_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = true;

	uim:override("pre_battle_retreat_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["pre_battle_retreat_with_button_hidden"] = true;

	uim:override("pre_battle_save_with_button_hidden"):set_allowed(true)
	prologue_tutorial_passed["pre_battle_save_with_button_hidden"] = true

	-- Enable event feed and items.
	disable_key_battle_events(false)
	UnlockItemGeneration(false)

end
------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Entering new area
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_entering_new_area_001()

	cm:toggle_dilemma_generation(false);
	PrologueTzeentchDilemma();
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Finding first enemy settlement - Left route Tzeentch
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_first_enemy_settlement_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_first_enemy_settlement_002() end, prologue_audio_timing["wh3_prologue_narrative_21_1_1"]); end)
	--Metric check (step_number, step_name, skippable)
	cm:trigger_prologue_step_metrics_hit(84, "reached_loci_palace", true);
end

function prologue_advice_first_enemy_settlement_002()
	-- Advisor text: Up ahead. An army beyond the treeline.
	cm:show_advice("wh3_prologue_narrative_21_1_1", true, false, prologue_advice_first_enemy_settlement_003, 0, prologue_audio_timing["wh3_prologue_narrative_21_1_2"]);
end

function prologue_advice_first_enemy_settlement_003()
	-- Advisor text: Servants of the Dark Gods… Daemons. 
	cm:show_advice("wh3_prologue_narrative_21_1_2", true, false, prologue_advice_first_enemy_settlement_end, 0, 0.5);
	cm:toggle_dilemma_generation(false);
end

function prologue_advice_first_enemy_settlement_end()
	prologue_end_of_dialogue("", "", false);
	PrologueTrialsDilemma()
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Finding first enemy settlement - Right route Norsca
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_first_enemy_settlement_right_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_first_enemy_settlement_right_002() end, prologue_audio_timing["wh3_prologue_narrative_21_2_1"]); end)
	--Metric check (step_number, step_name, skippable)
	cm:trigger_prologue_step_metrics_hit(83, "reached_claw_reach", true);
end

function prologue_advice_first_enemy_settlement_right_002()
	-- Advisor text: Today, we do not fight northmen. Today, we fight Daemons, but with Ursun's blessing, our blades will bite deep!
	cm:show_advice("wh3_prologue_narrative_21_2_1", true, false, prologue_advice_first_enemy_settlement_right_003, 0, prologue_audio_timing["wh3_prologue_narrative_21_2_2"]);
end

function prologue_advice_first_enemy_settlement_right_003()
	-- Advisor text: Every true Kislevite knows, suffer not the Daemon to live!
	cm:show_advice("wh3_prologue_narrative_21_2_2", true, false, prologue_advice_first_enemy_settlement_end, 0, 0.5);
	cm:toggle_dilemma_generation(false);
end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Unlock Technology - Left route
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_unlock_technology_001(direction)
	
	ForceSavingState(false)

	if direction == "left" then
		prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_unlock_technology_left_002(); end, prologue_audio_timing["wh3_prologue_narrative_22_1_1"]); end)
	else 
		prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_unlock_technology_right_002(); end, prologue_audio_timing["wh3_prologue_narrative_22_2_1"]); end)
	end
end

function prologue_advice_unlock_technology_left_002()
	-- Advisor text: What waits in hidden chambers? 
	cm:show_advice("wh3_prologue_narrative_22_1_1", true, false, prologue_advice_unlock_technology_left_003, 0, prologue_audio_timing["wh3_prologue_narrative_22_1_2"]);
end

function prologue_advice_unlock_technology_left_003()
	-- Advisor text: A chest of scrolls. Knowledge to harness.
	cm:show_advice("wh3_prologue_narrative_22_1_2", true, false, prologue_advice_unlock_technology_left_004, 0, prologue_audio_timing["wh3_prologue_narrative_22_1_3"]);
end

function prologue_advice_unlock_technology_left_004()
	-- Advisor text: Leave it! We have no need of dark magic.  
	cm:show_advice("wh3_prologue_narrative_22_1_3", true, false, prologue_advice_unlock_technology_left_005, 0, prologue_audio_timing["wh3_prologue_narrative_22_1_4"]);
end

function prologue_advice_unlock_technology_left_005()
	-- Advisor text: We fight alone. We use whatever we can. 
	cm:show_advice("wh3_prologue_narrative_22_1_4", true, false, prologue_advice_unlock_technology_trigger_intervention, 0, 0.5);
end

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Unlock Technology - Right route
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_unlock_technology_right_001()
	-- Advisor text: What hides in this daemon lair?  
	cm:show_advice("wh3_prologue_narrative_22_2_1", true, false, prologue_advice_unlock_technology_right_002, 0, prologue_audio_timing["wh3_prologue_narrative_22_2_2"]);
end

function prologue_advice_unlock_technology_right_002()
	-- Advisor text: Ancient tomes. Secrets to exploit. 
	cm:show_advice("wh3_prologue_narrative_22_2_2", true, false, prologue_advice_unlock_technology_right_003, 0, prologue_audio_timing["wh3_prologue_narrative_22_2_3"]);
end

function prologue_advice_unlock_technology_right_003()
	-- Advisor text: We need weapons, not words of heresy!  
	cm:show_advice("wh3_prologue_narrative_22_2_3", true, false, prologue_advice_unlock_technology_right_004, 0, prologue_audio_timing["wh3_prologue_narrative_22_2_4"]);
end

function prologue_advice_unlock_technology_right_004()
	-- Advisor text: This is not Kislev. We learn what we can! 
	cm:show_advice("wh3_prologue_narrative_22_2_4", true, false, prologue_advice_unlock_technology_trigger_intervention, 0, 0.5);
end

function prologue_advice_unlock_technology_trigger_intervention()
	prologue_end_of_dialogue("", "", true);

	StopForceSavingState()
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		core:trigger_event("ScriptEventPrologueTechnology");
	else
		-- Unlock technology
		uim:override("technology_with_button_hidden"):set_allowed(true);
		prologue_tutorial_passed["technology_with_button_hidden"] = true;

		cm:whitelist_event_feed_event_type("faction_technology_researchedevent_feed_target_faction");

		if prologue_trial_mission == "mansion_of_eyes" then
			PrologueMansionOfEyes();
			prologue_trial_mission = "";
		elseif prologue_trial_mission == "tribal" then
			PrologueTribalMission();
			prologue_trial_mission = "";
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Triggered the Ruins Dilemma
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_ruins_dilemma_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_ruins_dilemma_002() end, prologue_audio_timing["wh3_prologue_narrative_23_1_1"]); end)
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)
end

function prologue_advice_ruins_dilemma_002()
	-- Advisor text: The markings on the bodies. I've seen them before.
	cm:show_advice("wh3_prologue_narrative_23_1_1", true, false, prologue_advice_ruins_dilemma_003, 0, prologue_audio_timing["wh3_prologue_narrative_23_2_1"]);
end

function prologue_advice_ruins_dilemma_003()
	-- Advisor text: Runes of Chaos. Kurnz branded them with dark prayers.
	cm:show_advice("wh3_prologue_narrative_23_2_1", true, false, prologue_advice_ruins_dilemma_004, 0, prologue_audio_timing["wh3_prologue_narrative_23_3_1"]);
end

function prologue_advice_ruins_dilemma_004()
	-- Advisor text: How can you read them?
	cm:show_advice("wh3_prologue_narrative_23_3_1", true, false, prologue_advice_ruins_dilemma_005, 0, prologue_audio_timing["wh3_prologue_narrative_23_4_1"]);
end

function prologue_advice_ruins_dilemma_005()
	-- Advisor text: I took his journal from Dervingard. It deciphers the symbols. 
	cm:show_advice("wh3_prologue_narrative_23_4_1", true, false, prologue_advice_ruins_dilemma_end, 0, 0.5);
end


function prologue_advice_ruins_dilemma_end()
	prologue_end_of_dialogue("after_ruins_dilemma", "", true);
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
	cm:contextual_vo_enabled(true);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Reached Ice Maiden battle - Pre Battle screen
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_ice_maiden_battle_pre_battle_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_ice_maiden_battle_pre_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_24_1_1"]); end, false, true)
end

function prologue_advice_ice_maiden_battle_pre_battle_002()
	-- Advisor text: We have to fight these creatures? There must be another way!
	cm:show_advice("wh3_prologue_narrative_24_1_1", true, false, prologue_advice_ice_maiden_battle_pre_battle_003, 0, prologue_audio_timing["wh3_prologue_narrative_24_2_1"]);
end

function prologue_advice_ice_maiden_battle_pre_battle_003()
	-- Advisor text: No, Gerik, the lore we need is within that maze.
	cm:show_advice("wh3_prologue_narrative_24_2_1", true, false, prologue_advice_ice_maiden_battle_pre_battle_004, 0, prologue_audio_timing["wh3_prologue_narrative_24_3_1"]);
end

function prologue_advice_ice_maiden_battle_pre_battle_004()
	-- Advisor text: Then we should prey to Ursun for protection, if he can even hear us.
	cm:show_advice("wh3_prologue_narrative_24_3_1", true, false, prologue_advice_ice_maiden_battle_pre_battle_005, 0, prologue_audio_timing["wh3_prologue_narrative_24_4_1"]);
end

function prologue_advice_ice_maiden_battle_pre_battle_005()
	-- Advisor text: I told you, the bear talks to me. He knows, brother, he knows… 
	cm:show_advice("wh3_prologue_narrative_24_4_1", true, false, prologue_advice_ice_maiden_battle_pre_battle_end, 0, 0.5);
end

function prologue_advice_ice_maiden_battle_pre_battle_end()
	prologue_end_of_dialogue("", "", true, false, true)

	local bottom_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment");
	if bottom_panel then
		bottom_panel:SetVisible(true);
	end

	if prologue_check_progression["quest_battle_explained"] == false then
		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			core:trigger_event("ScriptEventPrologueQuestBattle");
		else
			prologue_check_progression["quest_battle_explained"] = true;
			cm:steal_user_input(false);
			cm:contextual_vo_enabled(true);
		end
	else
		cm:steal_user_input(false);
		cm:contextual_vo_enabled(true);
		EndWaitForAccept()
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Mission complete - Lucent Maze QB
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_mission_complete_lucent_maze()

	--Ursun text: The guardians of Lucent Maze are defeated. Enter the  labyrinth, discover the forbidden knowledge. I will guide you, protect you from Tzeentch's tricks.
	trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_05_2_1_1", "", 2.0);

	core:add_listener(
		"Prologue_RunesMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()
			cm:stop_campaign_advisor_vo();

			PrologueMazeDilemma();
		end,
		false
	);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After Ice Maiden mission
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_after_maze_battle_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_after_maze_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_25_1_1"]); end)
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)
end

function prologue_advice_after_maze_battle_002()
	-- Advisor text: You were gone for some time. I was worried.
	cm:show_advice("wh3_prologue_narrative_25_1_1", true, false, prologue_advice_after_maze_battle_003, 0, prologue_audio_timing["wh3_prologue_narrative_25_2_1"]);
end

function prologue_advice_after_maze_battle_003()
	-- Advisor text: It is done. I know how to cross the chasm. 
	cm:show_advice("wh3_prologue_narrative_25_2_1", true, false, prologue_advice_after_maze_battle_end, 0, 0.5);
end

function prologue_advice_after_maze_battle_end()
	cm:dismiss_advice();
	prologue_end_of_dialogue("", "", false);

	cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_the_brazen_lands");

	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			--Ursun text: The fears of lesser men must not sway you from the righteous path. You have shown courage, now, be as brazen as the altar you seek. Enter the lands of Khorne, the Blood God, conquer them and raid his shrine. Discover the name of the bridge-maker.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_06_1_1_1", "", 2.0);
		end,
		false
	);

	cm:trigger_mission(prologue_player_faction, "wh3_prologue_mission_reveal", true); 

	core:add_listener(
		"PanelClosedCampaign_EndTurnNotification",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()																				
			cm:stop_campaign_advisor_vo();
			UnlockPatriarch() 
		end,
		false
	);
end



----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Unlocking Diplomacy
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_unlock_diplomacy_001()
	cm:disable_saving_game(true)
	
	prologue_mission_make_alliance:trigger();

	core:add_listener(
		"PanelClosedCampaign_AllianceTrial",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()	
			prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_unlock_diplomacy_002() end, prologue_audio_timing["wh3_prologue_narrative_26_1_1"]) end);
		end,
		false
	);
end

function prologue_advice_unlock_diplomacy_002()
	-- Advisor text: And what if they don't submit to us?
	cm:show_advice("wh3_prologue_narrative_26_1_1", true, false, prologue_advice_unlock_diplomacy_003, 0, prologue_audio_timing["wh3_prologue_narrative_26_2_1"]);
end

function prologue_advice_unlock_diplomacy_003()
	-- Advisor text: You already know the answer, Gerik… we go to war.
	cm:show_advice("wh3_prologue_narrative_26_2_1", true, false, prologue_advice_unlock_diplomacy_trigger_intervention, 0, 0.5);
end

function prologue_advice_unlock_diplomacy_trigger_intervention()
	prologue_end_of_dialogue("", "", false);

	cm:trigger_mission(prologue_player_faction, "wh3_prologue_trial_of_war_monger", true)

	core:add_listener(
		"PanelClosedCampaign_WarMonger",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()	
			uim:override("end_turn"):set_allowed(true);

			cm:contextual_vo_enabled(true);
		end,
		false
	);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Fulfilling a trial
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_complete_trial_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_complete_trial_002() end, prologue_audio_timing["wh3_prologue_narrative_27_1_1"]) end);
end

function prologue_advice_complete_trial_002()
	-- Advisor text: Another stronghold falls under your rule. In our search for Ursun, we carve our own fiefdom. But we cannot be everywhere. What if we entrust a veteran to lead a new army? One to help enforce your will.
	cm:show_advice("wh3_prologue_narrative_27_1_1", true, false, prologue_advice_complete_trial_003, 0, prologue_audio_timing["wh3_prologue_narrative_27_2_1"]);
end

function prologue_advice_complete_trial_003()
	-- Advisor text: Bring forward those who wish to lead. Let me see who is worthy.
	cm:show_advice("wh3_prologue_narrative_27_2_1", true, false, prologue_advice_complete_trial_end, 0, 0.5);
end

function prologue_advice_complete_trial_end()
	prologue_end_of_dialogue("", "", false, false, true);
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		cm:callback(function() core:trigger_event("ScriptEventPrologueLordRecruit") end, 0.5)
	else
		uim:override("end_turn"):set_allowed(true);
		prologue_check_progression["lord_recruitment"] = true
		cm:override_ui("hide_units_panel_small_bar_buttons", false);
		prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true
		uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
		cm:disable_event_feed_events(false, "", "", "character_ready_for_duty_starting_general"); 
		cm:contextual_vo_enabled(true); 
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After recruiting Lord
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_new_lord_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_new_lord_002() end, prologue_audio_timing["wh3_prologue_narrative_27_3_1"]); end)
end

function prologue_advice_new_lord_002()
	-- Advisor text: A worthy Boyar, but the new lord needs an army. One to protect Dervingard. 
	cm:show_advice("wh3_prologue_narrative_27_3_1", true, false, prologue_advice_character_button_trigger, 0, 0.5);
end


function prologue_advice_character_button_trigger()
	cm:dismiss_advice();
	prologue_end_of_dialogue("character_button_trigger", "", false);
	if prologue_tutorial_passed["lords_with_button_hidden"] == false then
		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			cm:callback(function() completely_lock_input(false); core:trigger_event("ScriptEventPrologueCharacters"); end, 0.5)
		else
			uim:override("end_turn"):set_allowed(true);
			prologue_tutorial_passed["lords_with_button_hidden"] = true;
			uim:override("lords_with_button_hidden"):set_allowed(true);
			cm:contextual_vo_enabled(true);
		end
	else
		uim:override("end_turn"):set_allowed(true);
	end
	
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Recruited new army
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_new_army_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_new_army_002() end, prologue_audio_timing["wh3_prologue_narrative_27_4_1"]); end)
end

function prologue_advice_new_army_002()
	-- Advisor text: The army is recruiting new units.   
	cm:show_advice("wh3_prologue_narrative_27_4_1", true, false, prologue_advice_new_army_003, 0, prologue_audio_timing["wh3_prologue_narrative_27_5_1"]);
end

function prologue_advice_new_army_003()
	-- Advisor text: They will serve well. We need all we can for the trials to come.
	cm:show_advice("wh3_prologue_narrative_27_5_1", true, false, prologue_advice_new_army_end, 0, 0.5);
end

function prologue_advice_new_army_end()
	prologue_check_progression["new_lord_recruit_advice"] = true

	cm:contextual_vo_enabled(true);
	
	prologue_end_of_dialogue("", "", true);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Entered Khorne Area
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_entered_khorne_area_001()
	prologue_start_of_dialogue(false, function () cm:callback(function() prologue_advice_entered_khorne_area_002() end, prologue_audio_timing["wh3_prologue_narrative_28_1_1"]) end);
end

function prologue_advice_entered_khorne_area_002()
	-- Advisor text: The ground itself is red with blood.  
	cm:show_advice("wh3_prologue_narrative_28_1_1", true, false, prologue_advice_entered_khorne_area_003, 0, prologue_audio_timing["wh3_prologue_narrative_28_2_1"]);
end

function prologue_advice_entered_khorne_area_003()
	-- Advisor text: And more must be shed, until we reach the Brazen Altar.
	cm:show_advice("wh3_prologue_narrative_28_2_1", true, false, prologue_advice_entered_khorne_area_004, 0, prologue_audio_timing["wh3_prologue_narrative_28_3_1"]);
end

function prologue_advice_entered_khorne_area_004()
	-- Advisor text: Our comrades fear this land. 
	cm:show_advice("wh3_prologue_narrative_28_3_1", true, false, prologue_advice_entered_khorne_area_005, 0, prologue_audio_timing["wh3_prologue_narrative_28_4_1"]);
end

function prologue_advice_entered_khorne_area_005()
	-- Advisor text: Their doubt cannot stop us. We fight those who worship blood and fire. Match their rage with our own.
	cm:show_advice("wh3_prologue_narrative_28_4_1", true, false, prologue_advice_entered_khorne_area_end, 0, 0.5);
end

function prologue_advice_entered_khorne_area_end()
	if cm:model():world():faction_by_key("wh3_prologue_blood_keepers"):is_dead() == false then
		cm:trigger_mission(prologue_player_faction, "wh3_prologue_eliminate_khorne_leader", true)
		prologue_end_of_dialogue("", "", false);
		core:add_listener(
			"PanelClosedCampaign_KhorneLeader",
			"PanelClosedCampaign",
			function(context) return context.string == "events" end,
			function()	
				uim:override("end_turn"):set_allowed(true);

				cm:contextual_vo_enabled(true);
			end,
			false
		);
	else
		prologue_end_of_dialogue("", "", true);
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Pre Battle - Brazen Altar QB
--------------------------------------------------------------------------------------------------------------------------------------------------

function prologue_advice_brazen_altar_pre_battle_001()
	prologue_start_of_dialogue(
		false, 
		function ()
			cm:callback(function() cm:steal_user_input(true) end, 0.1)
			cm:callback(
				function() 
					ForceSavingState(false)
					prologue_advice_brazen_altar_pre_battle_002() 
				end,
				prologue_audio_timing["wh3_prologue_narrative_28_5_1"]
			) 
		end
	)
end

function prologue_advice_brazen_altar_pre_battle_002()
	-- Advisor text: Brother, please, do not take us down this path.
	cm:show_advice("wh3_prologue_narrative_28_5_1", true, false, prologue_advice_brazen_altar_pre_battle_003, 0, prologue_audio_timing["wh3_prologue_narrative_28_6_1"]);
end

function prologue_advice_brazen_altar_pre_battle_003()
	-- Advisor text: It is too late. We find Ursun, no matter the cost!
	cm:show_advice("wh3_prologue_narrative_28_6_1", true, false, prologue_advice_brazen_altar_pre_battle_end, 0, 0.5);
end

function prologue_advice_brazen_altar_pre_battle_end()
	StopForceSavingState()
	cm:steal_user_input(false)
	cm:dismiss_advice()
	prologue_end_of_dialogue("", "", true);
	cm:contextual_vo_enabled(true);
	EndWaitForAccept()
end



----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Mission complete - Brazen Altar QB
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_mission_complete_brazen_altar()
	--Ursun text: You have defiled Khorne’s altar. The name of the bridge-maker is yours. Summon him, at the Screaming Chasm. 
	trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_06_2_1_1", "", 2.0);

	core:add_listener(
		"Prologue_RaidMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()
			cm:stop_campaign_advisor_vo();
			core:add_listener(
				"Prologue_RaidMission_reward",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()
			
					PrologueBeyondDilemma();
				end,
				false
			);
		end,
		false
	);
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  After Brazen Altar battle
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_after_brazen_altar_battle_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_after_brazen_altar_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_29_1_1"]); end)
end

function prologue_advice_after_brazen_altar_battle_002()
	-- Advisor text: How can Ursun condone such heresy?
	cm:show_advice("wh3_prologue_narrative_29_1_1", true, false, prologue_advice_after_brazen_altar_battle_003, 0, prologue_audio_timing["wh3_prologue_narrative_29_2_1"]);
end


function prologue_advice_after_brazen_altar_battle_003()
	-- Advisor text: Those that haven't tasted power, fear it. Do not worry, little brother. Ursun guides us still.
	cm:show_advice("wh3_prologue_narrative_29_2_1", true, false, prologue_advice_after_brazen_altar_battle_end, 0, 0.5);
end

function prologue_advice_trigger_retribution()
	cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_4");

	cm:add_circle_area_trigger(277, 361, 3, "kill_gerik", "", true, false, false);

	core:add_listener(
		"MissionIssued_UrsunMission",
		"MissionIssued",
		true,
		function()
			--Ursun text: Yuri, your scent grows strong, saturated in the power you have gained. I am close, but I grow weak. Confront the traitor, Slavin Kurnz. Offer no mercy, only blood. Slay him and the Howling Citadel is yours. Together we will roar to melt the snows. Together we free Kislev of this winter. Make war Yuri, seek your true god.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_ursun_07_1_1_1", "", 2.0);
		end,
		false
	);

	cm:trigger_mission(prologue_player_faction, "wh3_prologue_mission_retribution", true);
	cm:add_scripted_composite_scene_to_logical_position("kill_gerik_marker", "prologue_quest_sub_goal_marker", 415, 468, 0, 0, false, true, true)
	
end

function prologue_advice_after_brazen_altar_battle_end()
	cm:dismiss_advice();

	prologue_end_of_dialogue("", "", false);

	prologue_advice_trigger_retribution();

	core:add_listener(
		"Prologue_RetributionMission",
		"PanelClosedCampaign",
		function(context) return context.string == "events" end,
		function()
			cm:stop_campaign_advisor_vo();
			add_stances_listeners();
			uim:override("end_turn"):set_allowed(true);
			cm:contextual_vo_enabled(true);
		end,
		false
	);

end


----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Close to north area
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_my_brother_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_my_brother_002() end, prologue_audio_timing["wh3_prologue_narrative_30_1_1"]); end)
end

function prologue_advice_my_brother_002()
	-- Advisor text: All we have done… ordered by you… in Ursun's name. Are you still my brother?
	cm:show_advice("wh3_prologue_narrative_30_1_1", true, false, prologue_advice_my_brother_003, 0, prologue_audio_timing["wh3_prologue_narrative_30_2_1"]);
end

function prologue_advice_my_brother_003()
	-- Advisor text: You are my blood… an honour no other can claim. 
	cm:show_advice("wh3_prologue_narrative_30_2_1", true, false, prologue_advice_my_brother_end, 0, 0.5);
end

function prologue_advice_my_brother_end()
	prologue_end_of_dialogue("", "", true);

	prologue_check_progression["triggered_screaming_chasm_objective"] = true
	cm:set_objective_with_leader("wh3_prologue_objective_screaming_chasm")
	cm:contextual_vo_enabled(true);
end


---------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Reveal Screaming Chasm
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_reveal_screaming_chasm_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_reveal_screaming_chasm_002() end, prologue_audio_timing["wh3_prologue_narrative_31_1_1"]); end)
	cm:trigger_2d_ui_sound("Campaign_Environment_Chaos_Howling_Citadel_Stinger_Play", 0);
end

function prologue_advice_reveal_screaming_chasm_002()
	-- Advisor text: Can you not hear it? The howling? the screaming? Is there no other way? 
	cm:show_advice("wh3_prologue_narrative_31_1_1", true, false, prologue_advice_reveal_screaming_chasm_003, 0, prologue_audio_timing["wh3_prologue_narrative_31_2_1"]);
end

function prologue_advice_reveal_screaming_chasm_003()
	-- Advisor text: Don't be a fool Gerik. Do I not hear Ursun's voice? Does he not guide me? 
	cm:show_advice("wh3_prologue_narrative_31_2_1", true, false, prologue_advice_reveal_screaming_chasm_end, 0, 0.5);
end

function prologue_advice_reveal_screaming_chasm_end()
	prologue_end_of_dialogue("", "", true);
	cm:contextual_vo_enabled(true);
end

---------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------  Howling Citadel pre-battle
--------------------------------------------------------------------------------------------------------------------------------------------------
function prologue_advice_howling_citadel_pre_battle_001()
	prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_howling_citadel_pre_battle_002() end, prologue_audio_timing["wh3_prologue_narrative_32_1_1"]); end)
end

function prologue_advice_howling_citadel_pre_battle_002()
	-- Advisor text: Know that your death was not wasted, brother. Your blood has brought us the Daemon's service. 
	cm:show_advice("wh3_prologue_narrative_32_1_1", true, false, prologue_advice_howling_citadel_pre_battle_end, 0, 0.5);
end

function prologue_advice_howling_citadel_pre_battle_end()
	prologue_end_of_dialogue("", "", true);
	cm:contextual_vo_enabled(true);
	EndWaitForAccept()
end

---------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
-------------- THE END
--------------------------------------------------------------------------------------------------------------------------------------------------



