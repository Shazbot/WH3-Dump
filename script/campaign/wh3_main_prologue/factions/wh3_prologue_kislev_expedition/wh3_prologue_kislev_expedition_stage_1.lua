

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	MAIN CAMPAIGN INTRO SCRIPT
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- TABLE OF CONTENTS

-------------------------------------------------------------------------
--	INITIAL SETUP
-------------------------------------------------------------------------
cm:get_campaign_ui_manager():set_should_save_override_state(true)

-- prevent the ai from moving characters in this faction by itself
cm:cai_disable_movement_for_faction("wh3_prologue_dervingard_garrison");
cm:cai_disable_movement_for_faction(enemy_faction_name);
cm:cai_disable_movement_for_faction("wh3_prologue_apostles_of_change");
cm:cai_disable_movement_for_faction("wh3_prologue_blood_keepers");
cm:cai_disable_movement_for_faction("wh3_prologue_great_eagle_tribe");
cm:cai_disable_movement_for_faction("wh3_prologue_sarthoraels_watchers");
cm:cai_disable_movement_for_faction("wh3_prologue_the_sightless");
cm:cai_disable_movement_for_faction("wh3_prologue_tong");
cm:cai_disable_movement_for_faction("wh3_prologue_the_tahmaks");
cm:cai_disable_movement_for_faction("wh3_prologue_the_kvelligs");

uim:override("postbattle_character_deaths"):set_allowed(false);

-- Disable unit experience.
cm:set_unit_experience_disabled(true)

-- unlock radar and faction bar and missions
uim:override("faction_bar"):set_allowed(true);
prologue_tutorial_passed["faction_bar"] = true;

uim:override("siege_information"):set_allowed(false);
uim:override("siege_turns"):set_allowed(false);

-- Disable building recruitment info.
uim:override("building_info_recruitment_effects"):set_allowed(false)

-- disable unused features
PrologueInitialDisabling();

-- make the main building available
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");


if prologue_cheat == true then
	uim:override("pre_battle_autoresolve_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = true;
end


-- set the prebattle camera
--cm:set_prebattle_display_configuration_override(4.852317,4.054514,0.104159,0,10.0);--distance,height,angle,scale,separation
cm:set_prebattle_display_configuration_camera_type_override("character");

--disable rotating the camera
 cm:disable_shortcut("camera", "rot_l", true)
 cm:disable_shortcut("camera", "rot_r", true)

	
 -- add a marker to detect when the player is close to the siege battle
 if prologue_check_progression["stage_1_area_triggers"] == false then
	cm:add_circle_area_trigger(283, 146, 7, "siege_marker", "", true, false, true);
	cm:add_circle_area_trigger(268, 107, 10, "settlement_marker", "", true, false, true);
	cm:add_circle_area_trigger(265, 102, 10, "trouble_marker", "", true, false, true);

	prologue_check_progression["stage_1_area_triggers"] = true
end
 

if prologue_check_progression["first_stage_1_load"] == false then
	-- This sets all options in the prologue to their default values. It will run once at the beginning of a new campaign. 
	-- These are found in... C:\Users\jimmy.jones\AppData\Roaming\The Creative Assembly\Warhammer3\scripts

	-- Marker Scale
	common.call_context_command("SetPrefAsFloat('ui_unit_id_scale', 0)")
	-- Default Run
	common.call_context_command("SetPrefAsBool('battle_run_by_default', true)")
	-- Default Guard Mode
	common.call_context_command("SetPrefAsBool('battle_defend_default', true)")
	-- Default Skirmish Mode
	common.call_context_command("SetPrefAsBool('battle_skirmish_default', false)")
	-- Alliance Colouring 
	common.call_context_command("SetPrefAsBool('alliance_faction_colours', false)")
	-- Campaign Difficulty
	common.call_context_command("SetPrefAsInt('campaign_difficulty', 1)")
	-- Battle Time
	common.call_context_command("SetPrefAsInt('battle_time_limit', -1)")
	-- Battle Difficulty
	common.call_context_command("SetPrefAsInt('battle_difficulty', 1)")
	-- Battle Realism
	common.call_context_command("SetPrefAsBool('battle_realism_mode', false)")
	
	-- Sets up victory conditions
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
	cm:trigger_custom_mission_from_string(
		"wh3_prologue_kislev_expedition",
		[[mission
			{
				victory_type wh3_main_victory_type_prologue;
				key wh_main_long_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						override_text mission_text_text_mis_activity_prologue_complete_dervingard;
						type SCRIPTED;
						script_key complete_dervingard;
					}
					objective
					{
						override_text mission_text_text_mis_activity_prologue_complete_lucent_maze;
						type SCRIPTED;
						script_key complete_lucent_maze;
					}
					objective
					{
						override_text mission_text_text_mis_activity_prologue_complete_brazen_altar;
						type SCRIPTED;
						script_key complete_brazen_altar;
					}
					objective
					{
						override_text mission_text_text_mis_activity_prologue_complete_howling_citadel;
						type SCRIPTED;
						script_key complete_howling_citadel;
					}
					payload
					{
						game_victory;
					}
				}
			}
		]],
		false
	)
	cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "");

	-- Disable initial battle events.
	disable_key_battle_events(true)

	-- Suppress all event turn events.
	suppress_all_end_turn_events(true)

	-- Apply growth debuff to stop settlements growing.
	cm:apply_effect_bundle("wh3_prologue_suppress_growth", cm:get_local_faction_name(), 0)

	stop_ai_settlement_growth(true)

	prologue_check_progression["first_stage_1_load"] = true
end


------------------------------------
---
--------------------------------------

function move_enemy_army_into_siege()
	cm:force_declare_war(enemy_faction_name, "wh3_prologue_dervingard_garrison", true, true);
	second_enemy_char_cqi = cm:model():world():faction_by_key(enemy_faction_name):faction_leader():cqi();
	local survivor_army_list = cm:model():world():faction_by_key("wh3_prologue_dervingard_garrison"):military_force_list();
	for i = 0, survivor_army_list:num_items() - 1 do
		if survivor_army_list:item_at(i):upkeep() > 0 then
			local survivor_army_cqi = survivor_army_list:item_at(i):general_character():cqi();
			out("FOR survivor_army_cqi: "..survivor_army_cqi);
			cm:enable_movement_for_faction(enemy_faction_name);
			cm:replenish_action_points("character_cqi:"..second_enemy_char_cqi);
			cm:attack("character_cqi:"..second_enemy_char_cqi, "character_cqi:"..survivor_army_cqi, true);
		end
	end
end


function moving_listeners_for_first_few_turns()
	core:add_listener(
		"Intro_FactionTurnStart_Event_Prologue",
		"FactionTurnStart",
		true,
		function(context)
			if context:faction():name() == prologue_player_faction and cm:model():turn_number() > 1 then

				--autoselect Yuri
				common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");

				-- reduce action points
				cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)

				-- Remove highlight from the end turn button
				highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn");
				
				if cm:model():turn_number() == 2 then
					PrologueSecondTurn();
					cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)
					cm:set_camera_maximum_height(20);
					cm:set_camera_height(20);
				elseif prologue_load_check == "found_debris" then
					PrologueThirdTurn(false);
				else 
					out("THIS IS ALSO CALLED")
					if prologue_check_progression["first_settlement_revealed"] == false then
						if dialogue_in_progress == false then
							--PrologueAddTopicLeader("wh3_prologue_objective_turn_001_03");
						end
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"Intro_FactionTurnEnd_Event_Prologue",
		"FactionTurnEnd",
		true,
		function(context)
			if context:faction():name() == prologue_player_faction then
				new_objective = true;
			end
		end,
		true
	);

	core:add_listener(
		"Intro_CharacterSelected_Event_Prologue",
		"CharacterSelected",
		true,
		function(context)
			if prologue_current_objective ~= "wh3_prologue_objective_turn_001_04" or prologue_current_objective ~= "wh3_prologue_objective_turn_001_06" then
				new_objective = true;
			end

			if cm:model():turn_number() == 1 and (prologue_current_objective == "wh3_prologue_objective_turn_001_01" or prologue_current_objective == "wh3_prologue_objective_turn_001_05") and prologue_check_progression["ap_bar"] == false then
	
				local objectives = find_uicomponent(core:get_ui_root(), "under_advisor_docker", "scripted_objectives_panel");
				if objectives then
					if prologue_active_text_pointer == "advice_button" then
						objectives:SetVisible(false);
					else
						objectives:SetVisible(true);
					end
				end

				-- set objective variable
				new_objective = true;
			
			end

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(5, "selected_Yuri", false);
		end,
		true
	);
	local play_once = false;
	core:add_listener(
		"CharacterFinishedMovingEvent_Prologue",
		"CharacterFinishedMovingEvent", 
		true,
		function()
			if prologue_check_progression["ap_bar"] == false then 
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventMovementRange")
				else
					prologue_check_progression["ap_bar"] = true
					cm:contextual_vo_enabled(true);
					PrologueEndOfTurnOne(true)
				end
			end

			if prologue_check_progression["first_settlement_revealed"] == false and cm:model():turn_number() > 1 and prologue_current_objective ~= "wh3_prologue_objective_turn_001_04" then
				--PrologueAddTopicLeader("wh3_prologue_objective_turn_001_04");

				-- set the objective variable
				new_objective = false;
			end

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(6, "moved_Yuri", false);
		end,
		true
	);
end

-- add a listener for when the settlement is selected and make sure the bottom bar is visible
core:add_listener(
	"hide_settlement_panel_small_bar_ui_override",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "settlement_panel" or context.string == "objectives_screen" 
	end,
	function()
		if prologue_check_progression["main_building_built"] == false then
			--PrologueFloatingText_SettlementPanel();
		end
		out("Settlement panel open")
		--cm:override_ui("hide_units_panel_small_bar_buttons", false);
		--cm:override_ui("units_panel_small_bar", false);
		uim:override("units_panel_small_bar"):set_allowed(true);
		set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker", "small_bar");
		set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker");
	end,
	true			
);

core:add_listener(
	"hide_small_bar_when_units_panel_is_open",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "units_panel"
	end,
	function()
		uim:override("units_panel_small_bar"):set_allowed(false);
		--cm:override_ui("hide_units_panel_small_bar_buttons", true);
	end,
	true
);

-- add listener to check if a settlement is under siege
core:add_listener(
	"CharacterBesiegesSettlement_Prologue",
	"CharacterBesiegesSettlement",
	true,
	function(context)
		-- set variable
		if context:region():name() == "wh3_prologue_region_ice_canyon_beacon_fort" then
			core:remove_listener("FactionTurnStart_Prologue_enemy_turn1");
			cm:cai_disable_movement_for_faction(enemy_faction_name);
			prologue_check_progression["enemy_sieging"] = true;
		end
	end,
	false
);

-- add a listener for enemy factions turn
core:add_listener(
	"FactionTurnStart_Prologue_enemy_turn1",
	"FactionBeginTurnPhaseNormal",
	true,
	function(context)
		out("TRYING TO MOVE ENEMY ARMY")
		if context:faction():name() == enemy_faction_name then 
			--if prologue_check_progression["main_building_built"] == true and prologue_check_progression["enemy_sieging"] == false then
			if prologue_check_progression["enemy_sieging"] == false then
				move_enemy_army_into_siege()
			end
		end
	end,
	true
);

-------------------------------------------------------
----------- ALL TURN FUNCTIONS ------------------------
----------------------------------------------------------
---------------------------------------------------------------
-- Turn 1 - Move character 
---------------------------------------------------------------

function set_up_first_turn_of_prologue()

	-- hide undiscovered factions during the end turn cycle
	cm:get_campaign_ui_manager():display_faction_buttons(false);

	-- Set the camera height
	--cm:callback(function() cm:set_camera_height(10); end, 2)

	-- hide the end turn button
	uim:override("end_turn"):set_allowed(false);

	-- put the banner back
	uim:override("campaign_flags"):set_allowed(true);
	
	-- help panel does not close when ESC menu opened
	local hpm = get_help_page_manager();
	hpm:set_close_on_game_menu_opened(false);
	
	-- disable the ? help page button
	hpm:enable_menu_bar_index_button(false);
	
	-- remove selection
	CampaignUI.ClearSelection();
	
	-- replenish action points
	cm:callback(function() cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0) end, 1);
	
	-- turn off the cinematic borders
	CampaignUI.ToggleCinematicBorders(false);
	
	-- remove info text
	cm:clear_infotext(); 

	cm:callback(function() prologue_advice_start_trigger_mission(); end, 2)

	cm:callback(function() moving_listeners_for_first_few_turns(); end, 3)
	
end;

function PrologueMainBuildingBuilt()
	-- Disable the end turn button
	uim:override("end_turn"):set_allowed(false);

	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

	local popup = false;

	core:add_listener(
		"prologue_building_complete_open_main_building",
		"PanelOpenedCampaign",
		function(context) return context.string == "events" end,
		function()
			popup = true;
		end,
		false
	);

	if popup == true then
		core:add_listener(
			"prologue_after_main_building",
			"PanelClosedCampaign",
			function(context) return context.string == "events" end,
			function()
				prologue_advice_store_house_001(); 	
			end,
			false
		);
	else
		prologue_advice_store_house_001(); 	
	end

end

function PrologueEndOfTurnOne(instant)
	local timer1 = 2
	local timer2 = 3
	local end_turn_pressed = false

	if instant then
		timer1 = 0
		timer2 = 0
	end

	prologue_end_of_dialogue("Turn_1_end", "", true);

	--Hide the pinned missions so the player can't press the button and cause a softlock
	local mission_list = find_uicomponent(core:get_ui_root(), "hud_campaign", "mission_list");
	if mission_list then
		mission_list:SetVisible(false);
	end
	
	local mtp_end_turn_button = text_pointer:new_from_component(
		"end_turn_button",
		"bottom",
		50,
		find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_end_turn"),
		0.5,
		0
	);
	mtp_end_turn_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_end_turn")
	mtp_end_turn_button:set_style("semitransparent")
	mtp_end_turn_button:set_topmost(true)
	mtp_end_turn_button:set_label_offset(-75, 0)

	cm:callback(
		function() 
			cm:get_campaign_ui_manager():display_faction_buttons(true); 
			uim:override("end_turn"):set_allowed(false)
			cm:trigger_2d_ui_sound("UI_CAM_PRO_HUD_Show_End_Turn", 0);
		end, 
		timer1
	);

	cm:callback(
		function()
			if not end_turn_pressed then
				HighlightEndTurnButton() 
				uim:override("end_turn"):set_allowed(true) 
				
				AddPanelCallbacks(
					function() mtp_end_turn_button:hide() end, 
					function() mtp_end_turn_button:show() end, 
					"FactionTurnEnd", 
					"EndTurnAdvice", 
					"esc_menu", 
					true
				)
			end
		end,
		timer2
	)

	core:add_listener(
		"TPEndTurnButton", 
		"FactionTurnEnd", 
		function (context) return context:faction():is_human() end, 
		function () mtp_end_turn_button:hide(); end_turn_pressed = true end, 
		false
	)
end

function PrologueSecondTurn()
	prologue_advice_turn_two_001();	

	--Metric check (step_number, step_name, skippable)
	cm:trigger_prologue_step_metrics_hit(8, "ended_first_turn", false);
end

function PrologueThirdTurn(skip_load_check)
	prologue_advice_turn_three_001(skip_load_check);
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)	

	--Metric check (step_number, step_name, skippable)
	cm:trigger_prologue_step_metrics_hit(12, "ended_supplies_turn", false);
end


----------------------------------------------------------------
----------- WHEN LOADING SAVE GAME ------------------------------
-----------------------------------------------------------------


if prologue_check_progression["enemy_sieging"] == true then
	cm:cai_disable_movement_for_faction(enemy_faction_name);
	out("stopping "..enemy_faction_name.." from moving")
else
	out("COULDN'T STOP THEM")
end

-------------------------------------------------------------------------
--	LISTENERS
-------------------------------------------------------------------------

core:add_listener(
	"AreaEntered_Prologue",
	"AreaEntered", 
	true,
	function(context)
		PrologueCheckSiegeBattleArea(context);
	end,
	true
);

core:add_listener(
	"MissionIssued_Prologue",
	"MissionIssued", 
	true,
	function(context)
		local mission = context:mission():mission_record_key();
	
		if mission == "wh3_prologue_mission_respite" then
			prologue_check_progression["main_building_mission_triggered"] = true;
			prologue_load_check = "first_mission_given";
			cm:callback(function() local accept_mission_button = find_uicomponent(core:get_ui_root(), "panel_manager", "events", "accept_holder", "button_accept"); 
				if accept_mission_button then
					accept_mission_button:Highlight(true, false, 0);
				end
			end, 0.5)
		end

	end,
	true
);


core:add_listener(
	"CharacterPerformsSettlementOccupationDecision_Prologue",
	"CharacterPerformsSettlementOccupationDecision", 
	true,
	function(context)
		if context:garrison_residence():region():name() == "wh3_prologue_region_mountain_pass_kislev_refuge" then
			highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn");
			core:remove_listener("CharacterFinishedMovingEvent_Prologue")
			core:remove_listener("FactionTurnEndTHOccupyRidge")
			core:remove_listener("FactionTurnStartTHOccupyRidge")
			-- remove objectives
			PrologueRemoveObjective();
			-- unhighlight settlement
			uim:unhighlight_settlement("settlement:wh3_prologue_mountain_pass_kislev_encampment");
			cm:disable_saving_game(true)
			
			t1_start_select_settlement_advice();

			local faction = cm:get_faction(prologue_player_faction)
			local observation_options = cm:model():world():observation_options_for_faction(faction, faction);
			local test = observation_options:armies_options();
			test:set_camera_follow_behaviour("OFF");
			observation_options:set_armies_options(test);
			cm:set_character_observation_options_for_faction(faction, observation_options);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(13, "occupied_kislev_refuge", false);
		end
	end,
	true
);

core:add_listener(
	"FactionTurnEnd_Prologue_highlight_end_turn",
	"FactionTurnEnd",
	true,
	function(context)
		if context:faction():is_human() then
			cm:remove_callback("highlight_end_turn_button");
			--cm:remove_objective(prologue_current_objective);
			highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn");

			if prologue_current_objective == "wh3_prologue_objective_turn_002_01" or prologue_current_objective == "wh3_prologue_objective_turn_006_01" or prologue_current_objective == "wh3_prologue_objective_turn_005_01" then return end

			if prologue_load_check ~= "Turn_2_start" then
				PrologueRemoveObjective();
			end
		end
	end,
	true
);


function PrologueAfterBuildingMain()
	prologue_advice_build_main_building_001();

	-- add a listener for it's the player factions turn
	core:add_listener(
		"FactionTurnEnd_Prologue",
		"FactionTurnEnd",
		true,
		function(context)
			if context:faction():is_human() then
				local player = context:faction():faction_leader();
				--cm:add_character_model_override(player, "wh_main_art_set_emp_general_01");

				--cm:clear_character_path_traversal_speed_multiplier(player);
			end
		end,
		false
	);
end

if prologue_check_progression["main_building_in_progress"] == true and prologue_check_progression["main_building_built"] == false then
	-- add a listener for it's the player factions turn
	core:add_listener(
		"FactionTurnEnd_Prologue",
		"FactionTurnEnd",
		true,
		function(context)
			if context:faction():is_human() then
				local player = context:faction():faction_leader();
				--cm:add_character_model_override(player, "wh_main_art_set_emp_general_01");

				--cm:clear_character_path_traversal_speed_multiplier(player);
			end
		end,
		false
	);
end


core:add_listener(
	"CharacterEntersGarrison_Prologue",
	"CharacterEntersGarrison",
	true,
	function(context)
		if context:character():cqi() == prologue_player_cqi then
			prologue_garrison = true;
		end
	end,
	true
);

core:add_listener(
	"CharacterLeavesGarrison_Prologue",
	"CharacterLeavesGarrison",
	true,
	function(context)
		if context:character():cqi() == prologue_player_cqi then
			prologue_garrison = false;
		end
	end,
	true
);


if prologue_check_progression["occupied_settlement"] == false then
	core:add_listener(
		"FactionTurnStart_Prologue_intro",
		"FactionTurnStart",
		true,
		function(context)
			--check if it's the player's turn
			if context:faction():name() == prologue_player_faction then

				-- Remove highlight from the end turn button
				highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn");
				
				--common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select")
				out("FACTION START")
			end

			-- Bug fix: fix for an issue with the resource bar appearing
			if prologue_tutorial_passed["resources_bar"] == false then
				local uic_treasury = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "treasury_holder");
				
				if uic_treasury then
					uic_treasury:SetVisible(false);
				end
				
			end
			
			--local uic_help_page = get_help_page_manager():get_uicomponent()
			--uic_help_page:MoveTo(0, 250)
		end,
		true
	);
	
	-- add a listener for when the settlement is being occupied, make sure Search Ruins and Do Nothing options aren't available
	core:add_listener(
		"hide_occupy_options_prologue",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "settlement_captured" 
		end,
		function()

			skip_all_scripted_tours();

			local uic_settlement_captured_panel = find_uicomponent(core:get_ui_root(), "settlement_captured", "button_parent");
			local uic_settlement_captured_child1 = UIComponent(uic_settlement_captured_panel:Find(0))
			local uic_settlement_captured_child2 = UIComponent(uic_settlement_captured_panel:Find(1))
			
			if uic_settlement_captured_child1 then
				--uic_settlement_captured_child1:SetVisible(false);
			end
			
			if uic_settlement_captured_child2 then
				uic_settlement_captured_child2:SetVisible(false);
			end
			
			--[[local uic_settlement_captured_panel_icons = find_uicomponent(core:get_ui_root(), "settlement_captured", "button_parent", "1513776188", "icon_parent");
			
			if uic_settlement_captured_panel_icons then
				uic_settlement_captured_panel_icons:SetVisible(false);
			end]]
			
			
			local uic_settlement_captured_button_text = find_uicomponent(core:get_ui_root(), "settlement_captured", "button_parent", "5608357", "option_button", "dy_option");
			if uic_settlement_captured_button_text then
				uic_settlement_captured_button_text:SetStateText(common.get_localised_string("campaign_localised_strings_string_prologue_occupy"), "campaign_localised_strings_string_prologue_occupy");
			end

			local uic_settlement_captured_title = find_uicomponent(core:get_ui_root(), "settlement_captured", "header_docker", "tx_title");
			uic_settlement_captured_title:SetStateText(common.get_localised_string("random_localisation_strings_string_wh3_prologue_discovered_settlement"), "random_localisation_strings_string_wh3_prologue_discovered_settlement");
		end,
		true			
	);
else
	-- add a listener for it's the player factions turn
	core:add_listener(
		"FactionTurnStart_Prologue",
		"FactionTurnStart",
		true,
		function(context)
			if context:faction():is_human() then

				-- Remove highlight from the end turn button
				highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn");

				if building_complete == true then
					-- Check if a building was complete and do things if it was
					CheckBuildingPrologueProgress();
				end
			end
		end,
		true
	);

end

core:add_listener(
	"PanelOpenedCampaign_pre_battle_screen",
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_pre_battle" end,
	function()
		
		uim:override("campaign_flags"):set_allowed(false);

		PrologueSetPreBattleScreen("battle_1_title");

		local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
		local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
		if title_bar_holder then
			title_bar_holder:SetVisible(true);
		end
		if title_bar then
			title_bar:SetVisible(true);
		end

		--local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		--if new_player then
			PrologueFirstPreBattle();
		--else
			--prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = true;
			--uim:override("pre_battle_autoresolve_with_button_hidden"):set_allowed(true);
		--end
		
		prologue_load_check = "first_pre_battle";
		cm:remove_objective("wh3_prologue_objective_turn_006_01");
		prologue_current_objective = "";

		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(27, "attacked_skollden", false);
	end,
	false
);

if prologue_check_progression["occupied_settlement"] == false then
	core:add_listener(
		"PanelOpenedCampaign_settlement_captured",
		"PanelOpenedCampaign",
		function(context) return context.string == "settlement_captured" end,
		function()
			-- remove the control sheet
			get_help_page_manager():hide_panel();
		end,
		true
	);
end

core:add_listener(
	"BuildingConstructionIssuedByPlayerInProgressChecks",
	"BuildingConstructionIssuedByPlayer",
	true,
	function(context)
		local faction = context:garrison_residence():faction();
		if faction:is_human() then
			if context:building() == "wh3_prologue_building_ksl_industry_1" then
				prologue_check_progression["industry_building_in_progress"] = true
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(17, "built_storehouse", false);
			elseif context:building() == "wh3_prologue_building_ksl_minor_1" then
				prologue_check_progression["main_building_in_progress"] = true;
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(15, "built_kislev_camp", false);
			end
		end
	end,
	true
);

core:add_listener(
	"RegionBuildingCancelledProgressChecks",
	"RegionBuildingCancelled",
	true,
	function(context)
		if context:key() == "wh3_prologue_building_ksl_industry_1" then
			prologue_check_progression["industry_building_in_progress"] = false

			uim:override("end_turn"):set_allowed(false);
			highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
			local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_78");
			if uic_slot_entry and uic_slot_entry:Visible(true) then
				uic_slot_entry:Highlight(true, true)
			end
		elseif context:key() == "wh3_prologue_building_ksl_minor_1" then
			prologue_check_progression["main_building_in_progress"] = false

			uim:override("end_turn"):set_allowed(false);
			highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
			local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_77");
			if uic_slot_entry and uic_slot_entry:Visible(true) then
				uic_slot_entry:Highlight(true, true)
			end
		end
	end,
	true
);

function Add_Main_Building_Progress_End_Turn_Listeners ()
	core:add_listener(
	"BuildingConstructionIssuedByPlayerMainBuildingEndTurn",
	"BuildingConstructionIssuedByPlayer",
	true,
	function(context)
		local faction = context:garrison_residence():faction();
		if faction:is_human() then
			if context:building() == "wh3_prologue_building_ksl_minor_1" then
				cm:dismiss_advice();
				uim:override("end_turn"):set_allowed(true);
				HighlightEndTurnButton()
			end
		end
	end,
	true
);


core:add_listener(
	"FactionTurnStartMainBuildingEndTurn",
	"FactionTurnStart",
	true,
	function()
		core:remove_listener("BuildingConstructionIssuedByPlayerMainBuildingEndTurn")
	end,
	false
)
end

function Add_Industry_Progress_End_Turn_Listeners ()
	core:add_listener(
	"BuildingConstructionIssuedByPlayerIndustryEndTurn",
	"BuildingConstructionIssuedByPlayer",
	true,
	function(context)
		local faction = context:garrison_residence():faction();
		if faction:is_human() then
			if context:building() == "wh3_prologue_building_ksl_industry_1" then
				cm:dismiss_advice();
				uim:override("end_turn"):set_allowed(true);
				HighlightEndTurnButton()
			end
		end
	end,
	true
	);


	core:add_listener(
		"FactionTurnStartIndustryEndTurn",
		"FactionTurnStart",
		true,
		function()
			core:remove_listener("BuildingConstructionIssuedByPlayerIndustryEndTurn")
		end,
		false
	)
end

-- add listener for when the attack button is pressed
core:add_listener(
	"attack_button_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_attack" end,
	function()
		out("STARTING FIRST TUTORIAL BATTLE")
		
		common.setup_dynamic_loading_screen("prologue_battle_1_intro", "prologue")

		if text_pointer_pre_battle_screen then
			text_pointer_pre_battle_screen:hide();
		end

		cm:win_next_autoresolve_battle(cm:get_local_faction_name());
		cm:modify_next_autoresolve_battle(
			1, 			-- attacker win chance
			0,	 		-- defender win chance
			4,	 		-- attacker losses modifier
			5,			-- defender losses modifier
			true
		);
		-- ensure the next battle we load (i.e. the one we're immediately about to launch) is the intro battle
		remove_generic_battle_script_override();
		cm:add_custom_battlefield(
			"intro_battle_1",												-- string identifier
			0,																-- x co-ord
			0,																-- y co-ord
			5000,															-- radius around position
			false,															-- will campaign be dumped
			"",																-- loading override
			"",																-- script override
			"script/battle/scenario_battles/01_prologue_intro/battle.xml",		-- entire battle override
			0,																-- human alliance when battle override
			false,															-- launch battle immediately
			true,															-- is land battle (only for launch battle immediately)
			true															-- force application of autoresolver result
		);
	end,
	false
);

core:add_listener(
	"autoresolve_button_listener_intro",
	"ComponentLClickUp",
	function(context) return context.string == "button_autoresolve" end,
	function()
		out("STARTING RETREAT LISTENER")
		cm:set_saved_value("bool_load_post_intro_campaign", true)
		cm:set_saved_value("bool_load_intro_campaign", false)

		if text_pointer_pre_battle_screen then
			text_pointer_pre_battle_screen:hide();
		end

		core:remove_listener("FactionTurnStart_Prologue");
		core:remove_listener("CharacterBuildingCompleted_Prologue");
		core:remove_listener("attack_button_listener");

		cm:load_local_faction_script("_stage_2", true);
		CheckPostBattlePrologueProgress()
	end,
	false
)

core:add_listener(
	"autoresolve_button_listener_intro",
	"ComponentLClickUp",
	function(context) return context.string == "dev_button_win_battle" end,
	function()
		out("STARTING RETREAT LISTENER")
		cm:set_saved_value("bool_load_post_intro_campaign", true)
		cm:set_saved_value("bool_load_intro_campaign", false)
		
		if text_pointer_pre_battle_screen then
			text_pointer_pre_battle_screen:hide();
		end

		core:remove_listener("FactionTurnStart_Prologue");
		core:remove_listener("CharacterBuildingCompleted_Prologue");
		core:remove_listener("attack_button_listener");

		cm:load_local_faction_script("_stage_2", true);
		CheckPostBattlePrologueProgress()
	end,
	false
)

core:add_listener(
	"MovementPointsExhaustedHighlightEndTurn",
	"MovementPointsExhausted",
	function(context) return prologue_load_check == "Turn_3_end" and context:character():command_queue_index() == prologue_player_cqi end,
	function() 
		HighlightEndTurnButton()
	end,
	true
)

core:add_listener(
	"BuildingConstructionIssuedByPlayerStopHighlightingBuildingSlots",
	"BuildingConstructionIssuedByPlayer",
	true,
	function(context)
		local faction = context:garrison_residence():faction();
		if faction:is_human() then
			if context:building() == "wh3_prologue_building_ksl_minor_1" then
				local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_77");
				if uic_slot_entry and uic_slot_entry:Visible(true) then
					uic_slot_entry:Highlight(false, true)
				end
			elseif context:building() == "wh3_prologue_building_ksl_industry_1" then
				local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_78");
				if uic_slot_entry and uic_slot_entry:Visible(true) then
					uic_slot_entry:Highlight(false, true)
				end
			end
		end
	end,
	true
)

-------------------------------------------------------------------------
--	SCRIPT START
-------------------------------------------------------------------------


cm:add_first_tick_callback_sp_each(
	function() 
		if cm:is_new_game() then

			t1_intro_setup();
			
			--cm:callback(function() cheattoposition() end, 2);
		else
			-- we are loading back in to the intro from a savegame
			if cm:get_saved_value("bool_camp_intro_end_t2_reached") then
				skip_to_t2_end_turn_advice();
			elseif cm:get_saved_value("bool_camp_intro_end_t1_reached") then
				skip_to_t1_end_turn_advice();
			end;
		end;
	end
);



-------------------------------------------------------------------------
--	TURN ONE
-------------------------------------------------------------------------

function t1_intro_setup()
	--t1_cutscene_intro_play();
	-- function to play the intro movie
	core:add_listener(
		"LoadingScreenDismissed_Prologue_intro",
		"LoadingScreenDismissed",
		true,
		function()
			t1_play_intro_movie()
			--cm:callback(function() t1_play_intro_movie() end, 1);
			--cm:move_character(prologue_player_cqi, 301, 110, false, false);
		end,
		false
	);	
end;


---------------------------------------------------------------
--	T1 Play the intro movie
---------------------------------------------------------------



function t1_play_intro_movie(belakor_movie_played)
	
	local mo = movie_overlay:new("prologue_intro", "warhammer3/prologue/pro_int");
	mo:set_end_callback(function() prepare_for_t1_cutscene_intro_play() 
		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(2, "skipped_intro_movie", true); end);
	mo:set_steal_user_input(true);
	mo:set_show_animation("");			-- want to play instantly rather than with initial anim

	mo:add_frame_callback(
		function()
			core:get_ui_root():CreateComponent("prologue_intro_transition", "ui/campaign ui/prologue_intro_camera_transition");
			prepare_for_t1_cutscene_intro_play();

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(1, "watched_intro_movie", true);

			-- We need to make cinematic bars topmost so appear over transition above. Cant do in layout as generally the cinematic bars appear below advice, so we get stuck in a loop of not being able to order by priority
			local cinematic_bars = UIComponent(core:get_ui_root():Find("cinematic_bars"));
			if cinematic_bars ~= nil then
				cinematic_bars:RegisterTopMost();
			end;
		end,
		6660
	);

	mo:start();
end;


---------------------------------------------------------------
--	Intro Cutscene
---------------------------------------------------------------

function prepare_for_t1_cutscene_intro_play()
	core:call_once("t1_cutscene_intro_play", function() t1_cutscene_intro_play() end);
end;


function t1_cutscene_intro_play()

	-- Moves the objective to the top centre of the screen, but there are loads of problems with this right now
	--get_objectives_manager():move_panel_top_centre();

	CampaignUI.ToggleCinematicBorders(true);

	local skipped = false;
	cm:set_camera_maximum_height(20);
	cm:set_camera_height(20);

	local cutscene_intro = campaign_cutscene:new_from_cindyscene(
		"prologue_intro_1",
		function() if skipped == false then set_up_first_turn_of_prologue(); CampaignUI.ToggleCinematicBorders(false) end end,
		"intro_sh01",
		--"script/campaign/wh3_main_prologue/factions/"..prologue_player_faction.."/_cutscene/managers/intro_manager.CindySceneManager", 
		0, 
		1
	);
	
	cutscene_intro:set_disable_settlement_labels(true);
	cutscene_intro:set_use_cinematic_borders(false);
	cutscene_intro:set_dismiss_advice_on_end(false);
	--cutscene_intro:set_skippable(false);
	cutscene_intro:set_skippable(true, function () skipped = true; cm:teleport_to(cm:char_lookup_str(cm:get_faction(prologue_player_faction):faction_leader():command_queue_index()), 396, 102); cm:callback(function() cm:move_character(prologue_player_cqi, 396, 104, false, false);  set_up_first_turn_of_prologue(); end, 0.5 );  end)

	
	cutscene_intro:action(
		function()
			
			cm:show_shroud(false);
			CampaignUI.ClearSelection();
			
			--cm:teleport_to(cm:char_lookup_str(cm:get_faction(prologue_player_faction):faction_leader():command_queue_index()), 396, 297);
			uim:override("campaign_flags"):set_allowed(false);
		end,
		0
	);
	
	cutscene_intro:action(
		function()

			cm:move_character(prologue_player_cqi, 396, 104, false, false);
			-- move the player character in the cutscene
			--cm:move_character(prologue_player_cqi, 405, 245, false, false);
			--cm:teleport_to(cm:char_lookup_str(cm:get_faction(prologue_player_faction):faction_leader():command_queue_index()), 405, 247);
			--cm:callback(function() cm:move_character(prologue_player_cqi, 405, 251, false, false); end, 0.5)
		end,
		2
	);
		
	cutscene_intro:start();

end;

function PrologueFirstPreBattle()

	cm:disable_saving_game(true)

	local player_army_panel = find_uicomponent(core:get_ui_root(), "allies_combatants_panel");
	local enemy_army_panel = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel");
	local player_army_list = find_uicomponent(core:get_ui_root(), "allies_combatants_panel", "commander_header_0");
	local ally_army_list = find_uicomponent(core:get_ui_root(), "allies_combatants_panel", "commander_header_1");
	local enemy_army_list = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel", "commander_header_0");

	local pre_battle_deployment = find_uicomponent(core:get_ui_root(), "mid", "regular_deployment");

	prologue_advice_pre_battle_001(player_army_panel, enemy_army_panel, player_army_list, enemy_army_list, pre_battle_deployment);

	player_army_list:SetVisible(false);
	ally_army_list:SetVisible(false);
	enemy_army_list:SetVisible(false);
	pre_battle_deployment:SetVisible(false);

	if player_army_panel then
		cm:callback(function() player_army_panel:SetVisible(false); end, 0.1);
		cm:callback(function() enemy_army_panel:SetVisible(false); end, 0.1);
		player_army_panel:TriggerAnimation("hide");
		enemy_army_panel:TriggerAnimation("hide");
	end
	

	local enemy_effect_bundles = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel", "effect_bundles_docker_enemy");

	if enemy_effect_bundles then
		enemy_effect_bundles:SetVisible(false);
	end

	local scout_terrain_button = find_uicomponent(core:get_ui_root(), "button_preview_map");

	if scout_terrain_button then
		scout_terrain_button:SetVisible(false);
	end

	if player_army_panel and enemy_army_panel then
		player_army_panel:SetCanResizeHeight(true);
		enemy_army_panel:SetCanResizeHeight(true);
		player_army_panel:Resize(player_army_panel:Width(), 450);
		enemy_army_panel:Resize(enemy_army_panel:Width(), 450);
	end

end


---------------------------------------------------------------
-- 	When player reach markers
---------------------------------------------------------------

function PrologueSettlementMarker()
	--dismiss advice
	cm:dismiss_advice();

	-- Remove the intro listeners
	core:remove_listener("Intro_FactionTurnStart_Event_Prologue");
	core:remove_listener("Intro_FactionTurnEnd_Event_Prologue");
	core:remove_listener("Intro_CharacterSelected_Event_Prologue");

	new_objective = false;

	CampaignUI.ClearSelection();
	
	-- Add a cindy scene camera
	local cutscene_intro = campaign_cutscene:new_from_cindyscene(
		"prologue_intro_2",
		function() 
			PrologueAfterShelterCindy()
		end,
		"prologue_intro_2",
		--"script/campaign/wh3_main_prologue/factions/"..prologue_player_faction.."/_cutscene/scenes/kislev_shelter_sh01.CindyScene",
		0, 
		1
	);
		
	cutscene_intro:set_disable_settlement_labels(true);
	cutscene_intro:set_dismiss_advice_on_end(false);
	cutscene_intro:set_restore_shroud(false);
	cutscene_intro:set_skippable(true, function() PrologueAfterShelterCindy() end);
			
	cutscene_intro:action(
		function()
			uim:override("campaign_flags"):set_allowed(false);
			cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
		end,
		0
	);
		
	cutscene_intro:action(
		function()
			prologue_advice_outpost_001();
		end,
		0
	);
	
	cutscene_intro:start();
end

function PrologueCheckSiegeBattleArea(context)
	if context:area_key() == "siege_marker" then
		skip_all_scripted_tours();
	
		cm:remove_area_trigger("siege_marker");

		-- Remove Feast Hall objective in case the player went here before finising that mission
		cm:remove_objective(prologue_current_objective);
		cm:remove_objective("wh3_prologue_objective_turn_005_01");
		cm:remove_objective("wh3_prologue_objective_turn_005_02");
		prologue_current_objective = "";

		core:remove_listener("CharacterFinishedMovingEvent_Prologue2");
		core:remove_listener("FactionTurnStart_Prologue_before_attack");

		CampaignUI.ClearSelection(); 

		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(26, "found_the_beacon", false);
		
		local cutscene_intro = campaign_cutscene:new_from_cindyscene(
			"prologue_intro_3",
			function() 
				cm:is_character_moving(
					prologue_player_cqi, 
					function() 
						cm:notify_on_character_halt(
							prologue_player_cqi, 
							function() 
								CampaignUI.ClearSelection();  
								cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)
								common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "SelectAndZoom(false)");
							end
						)
					end, 
					function() 
						CampaignUI.ClearSelection();  
						cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)
						common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "SelectAndZoom(false)");
					end
				)
				cm:disable_pathfinding_restriction(2);
				
				-- update progression variables
				prologue_check_progression["second_settlement_revealed"] = true;
				
				-- force alliance with the survivor faction
				cm:force_alliance(prologue_player_faction, "wh3_prologue_dervingard_garrison", true);
				cm:force_declare_war(prologue_player_faction, enemy_faction_name, false, false);

				uim:override("campaign_flags"):set_allowed(true);

				core:add_listener(
					"prologue_open_pre_battle",
					"PanelOpenedCampaign",
					function(context) return context.string == "popup_pre_battle" end,
					function()
						PrologueRemoveObjective();
					end,
					false
				);

			end,
			"prologue_intro_3",
			--"script/campaign/wh3_main_prologue/factions/"..prologue_player_faction.."/_cutscene/managers/petrenko_siege_01.CindySceneManager", 
			0, 
			1
		);
				
		cutscene_intro:set_disable_settlement_labels(true);
		cutscene_intro:set_dismiss_advice_on_end(false);
				
		cutscene_intro:action(
			function()
				uim:override("campaign_flags"):set_allowed(false);
				cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
				prologue_advice_beacon_revealed_001();
				
			end,
			0
		);
			
		cutscene_intro:action(
			function()
				
			end,
			1
		);
		
		cutscene_intro:start();
	
	elseif context:area_key() == "settlement_marker" and prologue_check_progression["st_income_complete"] == false then
		skip_all_scripted_tours();

		-- update progression variables
		prologue_check_progression["first_settlement_revealed"] = true;

		if prologue_check_progression["found_debris"] == true then
			PrologueSettlementMarker();
		end

	elseif context:area_key() == "trouble_marker" and prologue_check_progression["st_income_complete"] == false then
		prologue_advice_debris_001();
		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(10, "reached_supplies", false);
	end
end

function PrologueAfterShelterCindy()
	CampaignUI.ClearSelection(); 
	uim:override("campaign_flags"):set_allowed(true);
end

---------------------------------------------------------------
-- When the player occupies Kislev Refue
---------------------------------------------------------------

function t1_start_select_settlement_advice()
	-- output
	out("Start settlement tutorial")

	-- Disable end turn button
	uim:override("end_turn"):set_allowed(false);
	
	-- update progression variables
	prologue_check_progression["occupied_settlement"] = true;
	
	-- return user input
	cm:steal_user_input(false);
	
	prologue_advice_mission_complete_kislev_refuge();
	
	-- remove listener
	core:remove_listener("FactionTurnStart_Prologue_intro");

	-- add listeners
	core:add_listener(
		"FactionTurnStart_Prologue",
		"FactionTurnStart",
		true,
		function(context)
			if context:faction():is_human() then

				if building_complete == true then
					-- Check if a building was complete and do things if it was
					CheckBuildingPrologueProgress();
				end
			end
		end,
		true
	);
	
end;

---------------------------------------------------------------
-- When the player has issued a build order in the previous turn
---------------------------------------------------------------

function CheckBuildingPrologueProgress()
	--output
	out("This building was complete: "..test_building);
	
	-- if a building was complete, check what building it was
	if building_complete == true then
		-- if the main building was built
		if test_building == "wh3_prologue_building_ksl_minor_1" then
			prologue_check_progression["main_building_built"] = true;

			prologue_load_check = "turn_build_industry";

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(16, "ended_kislev_camp_turn", false);

			cm:remove_objective("wh3_prologue_objective_turn_003_01");
			prologue_current_objective = "";

			PrologueMainBuildingBuilt();
			
		-- if the industry buidling was built
		elseif test_building == "wh3_prologue_building_ksl_industry_1" and prologue_check_progression["second_settlement_revealed"] == false then
			prologue_load_check = "start_of_flee_turn";
			-- disable end turn button
			uim:override("end_turn"):set_allowed(false);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(18, "ended_storehouse_turn", false);
			
			local popup = false;

			core:add_listener(
				"prologue_building_complete_open",
				"PanelOpenedCampaign",
				function(context) return context.string == "events" end,
				function()
					popup = true;
				end,
				false
			);

			if popup == true then 
				core:add_listener(
					"prologue_building_complete",
					"PanelClosedCampaign",
					function(context) return context.string == "events" end,
					function()
						prologue_advice_fleeing_from_dervingard_001();
					end,
					false
				);
			else
				prologue_advice_fleeing_from_dervingard_001();
			end

			cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

			core:remove_listener("FactionTurnEnd_Prologue_highlight_end_turn");
		end
		
		-- reset the building_complete variable	
		building_complete = false;
	end
	
	
end


---------------------------------------------------------------
-- Check if it's a new game
---------------------------------------------------------------

if cm:is_new_game() then
	
	local function intro_character_created()
		
		-- only proceed if all intro characters have been created
		--if not (first_enemy_char_cqi and second_enemy_char_cqi) then
			--return;
		--end;
		local local_faction = cm:get_local_faction_name();
			-- Get cqis to all important characters (first time setup)
			--setup_intro_characters(first_enemy_char_cqi, second_enemy_char_cqi);
			
		prologue_player_cqi = cm:get_faction(cm:get_local_faction_name()):faction_leader():cqi();
		out("PLAYER CQI IS: "..prologue_player_cqi);

		local player = cm:get_faction(cm:get_local_faction_name()):faction_leader();
		--cm:set_character_path_traversal_speed_multiplier(player, 0.4)

		-- modify the player's treasury
		cm:treasury_mod(cm:get_local_faction_name(), 5000);
		
		-- increase AI's treasury to bring it in balance with player's
		cm:treasury_mod("wh3_prologue_apostles_of_change", 6000)
		cm:treasury_mod("wh3_prologue_blood_keepers", 6000)
		cm:treasury_mod("wh3_prologue_the_kvelligs", 6000)
		cm:treasury_mod("wh3_prologue_great_eagle_tribe", 6000)
		cm:treasury_mod("wh3_prologue_sarthoraels_watchers", 6000)
		cm:treasury_mod("wh3_prologue_the_sightless", 6000)
		cm:treasury_mod("wh3_prologue_gharhars", 6000)
		cm:treasury_mod("wh3_prologue_the_tahmaks", 6000)
		cm:treasury_mod("wh3_prologue_blood_sayters", 6000)
		cm:treasury_mod("wh3_prologue_tong", 6000)

		-- set enemy faction personality so that they don't retreat from battle
		cm:force_change_cai_faction_personality(enemy_faction_name, "wh_script_foolishly_brave");
		
	end

	out.inc_tab();


	intro_character_created();
	out.dec_tab();
else

	if prologue_check_progression["occupied_settlement"] == false then
		local local_faction = cm:get_local_faction_name();
			
		local player = cm:get_faction(cm:get_local_faction_name()):faction_leader();
	
		--cm:set_character_path_traversal_speed_multiplier(player, 0.4)
	end
	
end;

---------------------------------------------------------------
----------------- Load Check Functions ------------------------
---------------------------------------------------------------

function load_check_turn_3_end ()
	PrologueAddTopicLeader("wh3_prologue_objective_turn_002_01")

	uim:override("end_turn"):set_allowed(true);
end

function load_check_before_construction ()
	local wmp_prologue_main_building = windowed_movie_player:new_from_advisor("prologue_test_movie_2", "warhammer3/prologue/kislev_tutorial_01", 1);
	wmp_prologue_main_building:set_width(300);
	wmp_prologue_main_building:set_should_steal_esc_key_focus(false);
	cm:callback(function() if prologue_check_progression["main_building_in_progress"] == false then wmp_prologue_main_building:show(); end end, 2)
	
	core:add_listener(
	"PanelOpenedCampaignHighlightMainBuilding",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "settlement_panel"
	end,
	function()
		cm:callback(function () 
			local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_77");
			if uic_slot_entry and uic_slot_entry:Visible(true) and prologue_check_progression["main_building_in_progress"] == false then
				uic_slot_entry:Highlight(true, true)
			end
		end, 0.2)
	end,
	false);

	core:add_listener(
		"BuildingConstructionIssuedByPlayer_Prologue_Main",
		"BuildingConstructionIssuedByPlayer",
		true,
		function(context)
			local faction = context:garrison_residence():faction();
			if faction:is_human() then
				if context:building() == "wh3_prologue_building_ksl_minor_1" then

					wmp_prologue_main_building:hide();

					PrologueAfterBuildingMain();
				end
			end
		end,
		false
	);
end

function load_check_before_building_industry ()
	local wmp_prologue_building_slot = windowed_movie_player:new_from_advisor("prologue_test_movie", "warhammer3/prologue/kislev_tutorial_02", 1);
		wmp_prologue_building_slot:set_width(300);
		wmp_prologue_building_slot:set_should_steal_esc_key_focus(false);
		cm:callback(function() if prologue_check_progression["industry_building_in_progress"] == false then wmp_prologue_building_slot:show(); end end, 2)
		Add_Industry_Progress_End_Turn_Listeners()

			core:add_listener(
			"PanelOpenedCampaignHighlightMainBuilding",
			"PanelOpenedCampaign",
			function(context) 
				return context.string == "settlement_panel"
			end,
			function()
				cm:callback(function () 
					local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_78");
					if uic_slot_entry and uic_slot_entry:Visible(true) and prologue_check_progression["industry_building_in_progress"] == false then
						uic_slot_entry:Highlight(true, true)
					end
				end, 0.2)
			end,
			false);

		core:add_listener(
			"BuildingConstructionIssuedByPlayer_Prologue_industry",
			"BuildingConstructionIssuedByPlayer",
			true,
			function(context)
				local faction = context:garrison_residence():faction();
				if faction:is_human() then
					if context:building() == "wh3_prologue_building_ksl_industry_1" then
						wmp_prologue_building_slot:hide();

						prologue_load_check = "end_of_industry_turn";
						
						load_check_end_of_industry_turn()
						
					end
				end
			end,
			false
		);
end

function load_check_before_end_of_mission_event()
	core:add_listener(
	"PanelOpenedCampaignHighlightMainBuilding",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "settlement_panel"
	end,
	function()
		if not prologue_check_progression["main_building_in_progress"] then
		cm:callback(function () 
				local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_77");
				if uic_slot_entry and uic_slot_entry:Visible(true) and prologue_check_progression["main_building_in_progress"] == false then
					uic_slot_entry:Highlight(true, true)
				end
			end, 0.2)
		end
	end,
	false);
	
	if prologue_check_progression["main_building_in_progress"] then
		uim:override("end_turn"):set_allowed(true);
		HighlightEndTurnButton()
	else
		uim:override("end_turn"):set_allowed(false);
		highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
	end
end

function load_check_end_of_industry_turn()
	core:add_listener(
		"PanelOpenedCampaignHighlightMainBuilding",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "settlement_panel"
		end,
		function()
			cm:callback(function () 
				if not prologue_check_progression["industry_building_in_progress"] then
					local uic_slot_entry = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list", "CcoCampaignSettlementwh3_prologue_region_mountain_pass_kislev_refuge", "settlement_view", "default_view", "default_slots_list", "CcoCampaignBuildingSlotregion_slot_78");
					if uic_slot_entry and uic_slot_entry:Visible(true) and prologue_check_progression["main_building_in_progress"] then
						uic_slot_entry:Highlight(true, true)
				end
			end
			end, 0.2)
		end,
		false
	);

	if prologue_check_progression["industry_building_in_progress"] then
		uim:override("end_turn"):set_allowed(true);
		HighlightEndTurnButton()
	else
		uim:override("end_turn"):set_allowed(false);
		highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
	end
end

core:add_listener(
	"LoadingScreenDismissed_Prologue_intro_post",
	"LoadingScreenDismissed",
	true,
	function()
		out("LOADING "..prologue_load_check)

		uim:override("esc_menu"):set_allowed(true);
		
		if prologue_load_check == "Turn_1_start" then
			set_up_first_turn_of_prologue();
		elseif prologue_load_check == "Turn_1_end" then
			moving_listeners_for_first_few_turns()
			PrologueEndOfTurnOne(true)
		elseif prologue_load_check == "Turn_2_start" then
			prologue_advice_turn_two_show_objective(true);
		elseif prologue_load_check == "turn_3_start" then
			PrologueThirdTurn(false);
		elseif prologue_load_check == "found_debris" then
			uim:override("end_turn"):set_allowed(false)
			PrologueAddTopicLeader("wh3_prologue_objective_turn_001_04", function() HighlightEndTurnButton(); uim:override("end_turn"):set_allowed(true) end)
			
			core:add_listener(
				"FactionTurnStartMainBuildingEndTurn",
				"FactionTurnStart",
				function(context) return prologue_load_check == "found_debris" and context:faction():name() == prologue_player_faction end,
				function() PrologueThirdTurn(false) end,
				false
			)
			
		elseif prologue_load_check == "Turn_3_end" then
			cm:disable_pathfinding_restriction(1);
			
			core:add_listener(
				"FactionTurnStartMainBuildingEndTurn",
				"FactionTurnStart",
				function(context) return prologue_load_check == "Turn_3_end" and context:faction():name() == prologue_player_faction end,
				function() PrologueThirdTurn(true) end,
				false
			)
			
			if cm:get_local_faction():faction_leader():action_points_remaining_percent() < 75 then
				HighlightEndTurnButton()				
			end

			load_check_turn_3_end()
		elseif prologue_load_check == "first_mission_given" then
			prologue_advice_occupy_outpost_show_objective();
		elseif prologue_load_check == "before_construction" then
			cm:disable_pathfinding_restriction(2);
			ConstructionTopicLeaders("wh3_prologue_objective_turn_003_01", "wh3_prologue_objective_turn_001_07", true)
			load_check_before_construction ()
		elseif prologue_load_check == "end_of_mission_event" then
			load_check_before_end_of_mission_event()
			Add_Main_Building_Progress_End_Turn_Listeners()
			ConstructionTopicLeaders("wh3_prologue_objective_turn_003_01", "wh3_prologue_objective_turn_001_07", true)
			cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)	
		elseif prologue_load_check == "before_building_industry" then
			load_check_before_building_industry()
			ConstructionTopicLeaders("wh3_prologue_objective_turn_011_01", "wh3_prologue_objective_turn_001_08")
		elseif prologue_load_check == "turn_build_industry" then
			cm:callback(function() PrologueMainBuildingBuilt(); end, 5);
		elseif prologue_load_check == "second_mission_given" then
			prologue_advice_store_house_show_objective();
		elseif prologue_load_check == "end_of_industry_turn" then
			load_check_end_of_industry_turn()
			Add_Industry_Progress_End_Turn_Listeners()
			ConstructionTopicLeaders("wh3_prologue_objective_turn_011_01", "wh3_prologue_objective_turn_001_08")
		elseif prologue_load_check == "start_of_flee_turn" then
			cm:callback(function() prologue_advice_fleeing_from_dervingard_001(); end, 5);
		elseif prologue_load_check == "leave_first_settlement" then
			cm:disable_pathfinding_restriction(2);

			cm:toggle_dilemma_generation(false);

			local play_once = false;
			core:add_listener(
				"CharacterFinishedMovingEvent_Prologue2",
				"CharacterFinishedMovingEvent", 
				true,
				function(context)
					if play_once == false then
						cm:callback(function() PrologueTroubleDilemma(); end, 3);
						play_once = true;
					end
					if PrologueGetActionPoints() < 50 then
						--PrologueAddTopicLeader("wh3_prologue_objective_turn_001_04");
						--HighlightEndTurnButton()
					end
				end, 
				true
			);

			--Add current objective.
			PrologueAddTopicLeader(prologue_current_objective)

		elseif prologue_load_check == "item_scripted_tour" then
			PrologueAddTopicLeader(prologue_current_objective);
			HighlightEndTurnButton()
			
			core:add_listener(
				"FactionTurnStart_Prologue_item_scripted_tour",
				"FactionTurnStart",
				true,
				function(context)
					if context:faction():name() == prologue_player_faction then
						out("STARTING TOUR")
						core:remove_listener("FactionTurnStart_Prologue_item_scripted_tour");
						
						uim:override("disable_help_pages_panel_button"):set_allowed(false);

						if prologue_check_progression["item_scripted_tour"] == false then
							core:add_listener(
								"PanelClosedCampaignObjectiveCharacterDetails",
								"PanelClosedCampaign",
								function(context) return context.string == "character_details_panel" end,
								function() 
									cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)	
									if prologue_story_choice == 2 then
										prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_04", true)
									else
										prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_03", true)
									end
								end,
								false
							)

							local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
							if new_player then
								cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)	
								cm:callback(
									function()
										core:trigger_event("ScriptEventItems")
									end,
									1
								)
							else
								core:remove_listener("PanelClosedCampaignObjectiveCharacterDetails");
								if prologue_story_choice == 2 then
									prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_04", true)
								else
									prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_03", true)
								end
							end
						else
							cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)	
							if prologue_story_choice == 2 then
								prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_04", true)
							else
								prologue_end_of_dialogue("end_item_scripted_tour", "wh3_prologue_objective_turn_005_03", true)
							end
						end

						
					end
				end,
				true
			);
		elseif prologue_load_check == "turn_attack" then
			PrologueAddTopicLeader("wh3_prologue_objective_turn_006_01", function() if prologue_load_check == "first_pre_battle" then cm:remove_objective("wh3_prologue_objective_turn_006_01") end end)
		elseif prologue_load_check == "first_pre_battle" then
			PrologueFirstPreBattle()
		else
			if prologue_current_objective ~= "" then
				cm:callback(function() PrologueAddTopicLeader(prologue_current_objective); end, 3);
			end
		end
		
		
		
		out("CURRENT LOAD IS: "..prologue_load_check);

	end
);