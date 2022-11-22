



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FACTION SCRIPT
--
--	Custom script for this faction starts here. This script loads in additional
--	scripts depending on the mode the campaign is being started in (first turn vs
--	open), sets up the faction_start object and does some other things
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

out("THIS IS USING THE NEW SCRIPT")

------------------------------------------------------------------
---------------- COMMON FUNCTIONS -----------------------------
------------------------------------------------------------------
dialogue_in_progress = false
PrologueTopicLeaderAnimationTime = 3.1

prologue_cheat = false;
if prologue_cheat == true then
	--core:svr_save_bool("sbool_load_open_campaign", true)
	prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = true;
end

prologue_player_faction_interface = cm:model():world():faction_by_key(prologue_player_faction)


function PrologueInitialDisabling()
	-- disable unneeded features at the start of campaign
	disable_features();

	-- set-up event feed
	set_events_disabled()
	
	-- hide the end turn notification

	if prologue_tutorial_passed["end_turn_notification"] == false then
		local ui_root = core:get_ui_root();
		local uic_notification = find_uicomponent(ui_root, "end_turn_docker", "dy_notification");
		set_component_active_with_parent(false, uic_notification, "button_notification");
		uic_notification:SetVisible(false);
	end

	
    cm:skip_winds_of_magic_gambler(true);

	if prologue_show_compass == true then
		local uic_compass = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "compass_holder");
		local uic_treasury = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "treasury_holder");
		if uic_compass then
			uic_compass:SetVisible(true);
		end
		if prologue_check_progression["found_debris"] == false then
			if uic_treasury then
				uic_treasury:SetVisible(false);
			end
		else 
			if uic_treasury then
				uic_treasury:SetVisible(true);
			end
		end
	elseif prologue_tutorial_passed["resources_bar"] == true and prologue_show_compass == false then
		local uic_compass = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "compass_holder");
		if uic_compass then
			uic_compass:SetVisible(true);
		end
	end

	if prologue_tutorial_passed["stances_with_button_hidden"] == false then
		uim:override("terrain_tooltips"):set_allowed(false);
	end

	-- Set end of turn speed to normal.
	common.call_context_command("SetPrefAsBool('fast_forward_end_turns', false)")

	common.call_context_command("SetPrefAsBool('unit_info_show_description', false)")
	
	-- disable certain event feed events
	--cm:disable_event_feed_events(true, "", "", "conquest_province_secured"); 
	--cm:disable_event_feed_events(true, "", "", "character_wounded"); 
	--cm:disable_event_feed_events(true, "", "", "diplomacy_faction_encountered"); 
	--cm:disable_event_feed_events(true, "", "", "provinces_building_constructed"); 
	--cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
	--cm:disable_event_feed_events(true, "", "wh_event_subcategory_conquest_occupation", "");
	--cm:disable_event_feed_events(true, "", "wh_event_subcategory_conquest_battle", "");
	--cm:disable_event_feed_events(true, "", "wh_event_subcategory_diplomacy_state_matters", "");
	--cm:disable_event_feed_events(true, "wh_event_category_military", "", "");
	--cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");

	local map_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "radar_toggle");

	if map_button then
		map_button:SetVisible(false);
	end

	local uic_options_list = find_uicomponent(core:get_ui_root(), "campaign_space_bar_options", "background", "options_list")
	if uic_options_list then
		for i = 0, uic_options_list:ChildCount() - 1 do
			if i > 0 then
				local uic_options_list_slot = UIComponent(uic_options_list:Find(i))
				out(uic_options_list_slot:Id())
				if uic_options_list_slot:Id() ~= "overlay_ownership" and uic_options_list_slot:Id() ~= "overlay_diplomatic_status" and uic_options_list_slot:Id() ~= "overlay_attitude" and 
				uic_options_list_slot:Id() ~= "overlay_growth" and uic_options_list_slot:Id() ~= "overlay_attrition" then
					uic_options_list_slot:SetVisible(false)
				end
			end
		end
	end

	if prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] == false then
		--cm:disable_event_feed_events(true, "", "", "character_ready_for_duty_starting_general"); 
	end
	cm:toggle_dilemma_generation(true);
	cm:toggle_incident_generation(true);

	-- Disable rebellions
	cm:disable_rebellions_worldwide(true);	
	
	if prologue_check_progression["open_world"] == false then
		uim:override("prebattle_balance_of_power"):set_allowed(false);
	end

	if prologue_tutorial_passed["stances_with_button_hidden"] == false then
		cm:set_army_outer_movement_extents_rendering_disabled(true);
	end

	if prologue_check_progression["dervingard_battle_complete"] == false then
		uim:override("world_space_icons_for_prologue"):set_allowed(false);
	end

	if prologue_tutorial_passed["demolish_with_button_hidden"] == false then
		uim:override("demolish_with_button_hidden"):set_allowed(false);
	end
	
	--hiding the video settings button
	local ui_button_settings = find_uicomponent(core:get_ui_root(), "menu_bar", "button_settings");
	if ui_button_settings then
		ui_button_settings:SetVisible(false);
	end

	--exp 
	if prologue_check_progression["dervingard_battle_complete"] == false then
		-- Disable EXP
		cm:set_character_experience_disabled(true);
	else
		cm:set_character_experience_disabled(false);
	end

	if prologue_check_progression["second_settlement_revealed"] == true then
		--change the camera height
		cm:set_camera_maximum_height(30);
		cm:set_camera_height(30);
	else
		--change the camera height
		cm:set_camera_maximum_height(20);
		cm:set_camera_height(20);
	end
	
	CheckAndSetUIVisibility();

	PrologueSetLoadingScreen();
end

function CheckAndSetUIVisibility()
	for visibility, value in pairs(prologue_tutorial_passed) do
		if value == false then
			uim:override(visibility):set_allowed(value);
			out("Setting "..visibility.." to : "..tostring(value));
		else
			out("Setting "..visibility.." to : "..tostring(value));
		end
	end
end


function PrologueAddTopicLeader(objective, callback_after_animation, remove_objective_if_turn_end_during_anim, allow_during_dialogue)
	callback_after_animation = callback_after_animation or false
	remove_objective_if_turn_end_during_anim = remove_objective_if_turn_end_during_anim or false
	allow_during_dialogue = allow_during_dialogue or false
	local player_ended_turn = false

	if dialogue_in_progress == false or allow_during_dialogue then

		if prologue_current_objective ~= "" then
			out("TRYING TO REMOVE OBJECTIVE: "..prologue_current_objective)
			cm:remove_objective(prologue_current_objective);
		end

		prologue_current_objective = objective;
		out("CURRENT OBJECTIVE: "..prologue_current_objective)
		
		cm:set_objective_with_leader(objective);
		
		if remove_objective_if_turn_end_during_anim then 
			core:add_listener(
				"FactionTurnEndPrologueAddTopicLeader",
				"FactionTurnEnd",
				true,
				function() player_ended_turn = true end,
				false
			);
		end
		
		cm:callback(
			function() 
				if remove_objective_if_turn_end_during_anim and player_ended_turn then
					cm:remove_objective(objective)
				else
					core:remove_listener("FactionTurnEndPrologueAddTopicLeader")
				end

				if callback_after_animation then callback_after_animation() end
			end, 
			PrologueTopicLeaderAnimationTime
		)
	end
end

function PrologueRemoveObjective()
	if prologue_current_objective ~= "" then
		out("REMOVING OBJECTIVE: "..prologue_current_objective)
		cm:remove_objective(prologue_current_objective);
		prologue_current_objective = "";
	end
end


function PrologueTriggerMission(progress, objective, mission_intervention, mission, custom, intervention, intervention_name, intervention_event)
	
	core:add_listener(
		"MissionIssued_Prologue",
		"MissionIssued",
		true,
		function()
			core:add_listener(
				"hide_mission_panel",
				"PanelClosedCampaign",
				function(context) 
					return context.string == "events" 
				end,
				function()
					if prologue_check_progression[progress] == false then
						if objective ~= "" then
							--PrologueAddTopicLeader(objective);
						end
					end
					if intervention and prologue_check_progression[progress] == false then
						cm:callback(
							function() 
								mission_intervention:complete();
								out("START INTERVENTION")
								-- start intervention about building slots
								intervention_name:start();
								core:trigger_event(intervention_event);
							end, 
							1.5
						);
					elseif intervention == false then
						mission_intervention:complete();
					end;

					-- Enable the end turn button
					--uim:override("end_turn"):set_allowed(true);
				end,
				false
			);
		end, 
		false
	);
	
	if custom then
		out("Trying to trigger mission with objective: "..objective)
		mission:trigger();
	else
		cm:trigger_mission(prologue_player_faction, mission, true)
	end
end


function PrologueGetActionPoints()
	local player_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();
	for i = 0, player_army_list:num_items() - 1 do
		if player_army_list:item_at(i):upkeep() > 0 then
			local player_general_ap = player_army_list:item_at(i):general_character():action_points_remaining_percent();

			return player_general_ap;
		end
	end
end

function PrologueSetPreBattleScreen(title)
	local pre_battle_text = find_uicomponent(core:get_ui_root(), "mid", "prologue_narrative", "dy_pro_text");
	local pre_battle_title_text = find_uicomponent(core:get_ui_root(), "prologue_title_holder", "prologue_title");
	local pre_battle_narrative = find_uicomponent(core:get_ui_root(), "mid", "prologue_narrative");
	local pre_battle_information = find_uicomponent(core:get_ui_root(), "mid", "battle_information_panel");


	pre_battle_narrative:SetVisible(true);
	pre_battle_information:SetVisible(false);
	pre_battle_title_text:SetStateText(common.get_localised_string("random_localisation_strings_string_wh3_prologue_pre_battle_"..title), "random_localisation_strings_string_wh3_prologue_pre_battle_"..title)
end

function PrologueSetLoadingScreen()
	cm:set_loading_screen_id("prologue_intro")
end

function PrologueSetLoadingScreenQuote()
	if prologue_next_quote < 10 then
		prologue_next_quote = prologue_next_quote + 1;
		common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
		prologue_next_quote = prologue_next_quote + 1;
		core:svr_save_string("prologue_next_quote", tostring(prologue_next_quote));
	else
		local quote = math.random(23) + 1;
		common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..quote);
		local quote = math.random(23) + 1;
		core:svr_save_string("prologue_next_quote", tostring(quote));
	end

end

function PrologueResetLingerVariable(event)
	core:remove_listener(event);
	prologue_trigger_linger = 0;
end


function PrologueAddIceMaiden()

	uim:override("disable_help_pages_panel_button"):set_allowed(false);

	local player_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();
	local found_yuri = false

	for i = 0, player_army_list:num_items() - 1 do
		if player_army_list:item_at(i):upkeep() > 0 and player_army_list:item_at(i):general_character():is_faction_leader() and not found_yuri then
			
			out("FOUND YURI")
			found_yuri = true
			local faction = cm:model():world():faction_by_key(prologue_player_faction):command_queue_index()
			
			-- Spawn Ice Maiden at Yuri
			cm:spawn_unique_agent_at_character(faction, "wh3_main_pro_ksl_frost_maiden_ice", prologue_player_cqi, true)
			StopAgentsDisbanding()
			CampaignUI.ClearSelection();

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(72, "received_frost_maiden", false);

			-- Reduce AP of Ice Maiden.
			local character_list = cm:model():world():faction_by_key(prologue_player_faction):character_list();
			for j=0, character_list:num_items() - 1 do
				if character_list:item_at(j):character_type("wizard") == true then
					local agent_cqi = character_list:item_at(j):cqi()
					cm:replenish_action_points("character_cqi:"..agent_cqi, 1)
					--cm:add_agent_experience(cm:char_lookup_str(agent_cqi), 2, true)
				end
			end
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				SetUpIceMaidenTutorial()
			else
				prologue_check_progression["agent_tutorial_complete"] = true
				uim:override("character_details"):set_allowed(true);
				
				cm:disable_saving_game(true)
				PrologueJournalDilemma()
			end
		else
			out("NOT FOUND YURI")
		end
	end
end

function SetUpIceMaidenTutorial()
	if not prologue_check_progression["agent_tutorial_complete"] then
		
		core:add_listener(
			"PanelOpenedCampaignLockSwitch",
			"PanelOpenedCampaign",
			function(context) return context.string == "character_details_panel" end,
			function()
				local uic_1 = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "character_name", "button_cycle_right")
				local uic_2 = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "character_name", "button_cycle_left")

				if uic_1 then uic_1:SetVisible(false) end
				if uic_2 then uic_2:SetVisible(false) end
			end,
			true
		)

		local character_list = cm:model():world():faction_by_key(prologue_player_faction):character_list();
		for j=0, character_list:num_items() - 1 do
			if character_list:item_at(j):character_type("wizard") == true then

				local agent_cqi = character_list:item_at(j):cqi()
				local agent_character = cm:get_character_by_cqi(agent_cqi)

				-- For some mysterious reason, this world space pointer has to be called created and shown twice. No idea why (Steve doesn't know either)
				-- It was originally inside a function that was called twice due to a bug - Jimmy
				local tp_movement_extents = text_pointer:new("movement_extents", "worldspace", 100, agent_character:display_position_x(), agent_character:display_position_y());
				tp_movement_extents:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_agents");
				tp_movement_extents:set_worldspace_display_height(1)
				tp_movement_extents:show()
				tp_movement_extents:ignore_hide_all_text_pointers(true)
				
				local tp_movement_extents = text_pointer:new("movement_extents", "worldspace", 100, agent_character:display_position_x(), agent_character:display_position_y());
				tp_movement_extents:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_agents");
				tp_movement_extents:set_worldspace_display_height(1)
				tp_movement_extents:show()
				tp_movement_extents:ignore_hide_all_text_pointers(true)

				core:add_listener(
				"CharacterSelectedIceMaiden",
				"CharacterSelected",
				function(context)
					return context:character():character_type("wizard")
				end,
				function()
					completely_lock_input(true)
					tp_movement_extents:hide()
					core:trigger_event("ScriptEventAgents");
					core:remove_listener("PanelOpenedCampaignLockSwitch")
				end,
				true
				)
			end
		end
	end
end

function PrologueUnlockRoR(key_from_prologue_regiments_of_renown)

	prologue_regiments_of_renown[key_from_prologue_regiments_of_renown] = true

	-- This enables the Regiments of Renown recruitment button.
	--[[
	if prologue_tutorial_passed["regiments_of_renown_visible"] == false then
		prologue_tutorial_passed["regiments_of_renown_visible"] = true
		uim:override("regiments_of_renown_visible"):set_allowed(true)
	end
	--]]
	
	local unit_card = find_uicomponent(core:get_ui_root(), key_from_prologue_regiments_of_renown);
	if unit_card then
		out("Setting "..key_from_prologue_regiments_of_renown.." panel visibility to : true");
		unit_card:SetVisible(true);
	end
	
	local primary_detail = "event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_ror_unlock_"..key_from_prologue_regiments_of_renown.."_primary_detail"
	local secondary_detail = "event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_ror_unlock_"..key_from_prologue_regiments_of_renown.."_secondary_detail"

	cm:show_message_event(
		prologue_player_faction, 
		"event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_ror_unlock_title",
		primary_detail, 
		secondary_detail,
		true, 
		1312, 
		function ()
			-- Disabled because we no longer use a separate recruitment panel.
			-- core:trigger_event("ScriptEventROR")	
		end
	)

end

function UnlockItemGeneration(events_only)
	-- This will allow be items to be rewarded to the player for various actions/as loot for battles. It is controlled from the wh3_prologue_kislev_expedition_followers.lua script
	-- and wh3_prologue_kislev_expedition_magic_items.lua.
	-- This will also unlock trait generation!!
	if events_only == false then
		prologue_check_progression["item_generation"] = true
	end
	
	cm:whitelist_event_feed_event_type("faction_ancillary_gained_stolenevent_feed_target_faction")
	cm:whitelist_event_feed_event_type("faction_ancillary_gainedevent_feed_target_faction")
	cm:whitelist_event_feed_event_type("character_ancillary_lost_stolenevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_ancillary_lost_stolenevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_ancillary_gainedevent_feed_target_character_faction")

end

function AllowPreBattleUI(value)
	uim:override("prebattle_middle_panel"):set_allowed(value);
	uim:override("prebattle_balance_of_power"):set_allowed(value);
end

function AddYuriDeathObjective()
	cm:set_objective_with_leader("wh3_prologue_objective_recruit_yuri")
end

do
	local added_objective = false

	function YuriSpeedObjective()
		local shortcut_pressed = false
		added_objective = true

		uim:override("toggle_move_speed"):set_allowed(true)
		cm:set_objective_with_leader("wh3_prologue_objective_toggle_movement_speed")
		
		core:add_listener(
			"ShortcutPressedToggleMoveSpeed",
			"ShortcutPressed",
			function(context) return context.string == "toggle_move_speed" end,
			function() 
				cm:remove_objective("wh3_prologue_objective_toggle_movement_speed")
				shortcut_pressed = true
				prologue_tutorial_passed["toggle_move_speed"] = true
			end,
			false
		)
		cm:callback(
			function() if shortcut_pressed then cm:remove_objective("wh3_prologue_objective_toggle_movement_speed") end end, 
			PrologueTopicLeaderAnimationTime
		)

		--Remove the Toggle Speed objective
		core:add_listener(
			"FactionTurnEndRemoveToggleSpeed",
			"FactionTurnEnd",
			true,
			function()
				cm:remove_objective("wh3_prologue_objective_toggle_movement_speed")
			end,
			false
		);
	end

	function AddIncreaseYuriSpeedListener(apply_instant)
		if prologue_tutorial_passed["toggle_move_speed"] == false and added_objective == false then
			if apply_instant then
				YuriSpeedObjective()
			else
				core:add_listener(
					"FactionTurnStartAddObjective",
					"FactionTurnStart",
					true,
					function()
						if prologue_tutorial_passed["toggle_move_speed"] == false then
							YuriSpeedObjective()
						end
					end,
					false
				)
			end
		end
	end
end

function AddDeathListeners()
	
	local yuri_died_during_session = false
	cm:whitelist_event_feed_event_type("character_dies_battleevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_woundedevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_dies_suspiciousevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_dies_in_actionevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_ready_for_duty_starting_generalevent_feed_target_character_faction")
	cm:whitelist_event_feed_event_type("character_ready_for_dutyevent_feed_target_character_faction")

	if not prologue_check_progression["legendary_lord_death"] then
		core:add_listener(
			"CharacterConvalescedOrKilledLegendaryLord",
			"CharacterConvalescedOrKilled", 
			function(context)
				return prologue_check_progression["legendary_lord_death"] == false and context:character():character_type_key() == "general" and context:character():is_faction_leader() and context:character():faction():name() == prologue_player_faction and context:character():military_force():unit_list():is_empty()
			end,
			function()
				if cm:model():is_player_turn() then
					local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
					if new_player then
						core:trigger_event("ScriptEventLegendaryLordDeath");
					else
						if prologue_check_progression["lord_death_commanding"] == false and prologue_check_progression["lord_death"] == false then
							prologue_check_progression["legendary_lord_death"] = true;
	
							-- Activates lord recruitment button.
							uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
							prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true;
							AddYuriDeathObjective();
						end
						out("Should start legendary lord death 1")
					end
				else
					core:add_listener(
						"FactionTurnStart_YuriDied",
						"FactionTurnStart",
						true,
						function(context)
							if context:faction():name() == prologue_player_faction then
								local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
								if new_player then
									core:trigger_event("ScriptEventLegendaryLordDeath");
								else
									if prologue_check_progression["lord_death_commanding"] == false and prologue_check_progression["lord_death"] == false then
										prologue_check_progression["legendary_lord_death"] = true;
				
										-- Activates lord recruitment button.
										uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
										prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true;
										AddYuriDeathObjective();
									end
									out("Should start legendary lord death")
								end
								core:remove_listener("FactionTurnStart_YuriDied");
							end
						end,
						true
					)
				end
			end,
			true
		);
	end

	if not prologue_check_progression["lord_death"] then
		core:add_listener(
			"CharacterConvalescedOrKilledLord",
			"CharacterConvalescedOrKilled", 
			function(context)
				if prologue_check_progression["lord_death"] == false and context:character():character_type_key() == "general" and not context:character():is_faction_leader() and context:character():faction():name() == prologue_player_faction and context:character():age() > 0 and context:character():military_force():unit_list():is_empty() then
					return true
				end
			end,
			function()
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventLordDeath");
				else
					if prologue_check_progression["lord_death_commanding"] == false and prologue_check_progression["legendary_lord_death"] == false then
						prologue_check_progression["lord_death"] = true;

						-- Activates lord recruitment button.
						uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
						prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true;
					end
					out("Should start lord death")
				end
			end,
			true
		);
	end

	if not prologue_check_progression["lord_death_commanding"] then
		core:add_listener(
			"PanelOpenedCampaignAppointNewGeneral",
			"PanelOpenedCampaign",
			function(context) 
				return context.string == "appoint_new_general" and prologue_check_progression["lord_death_commanding"] == false
			end,
			function()
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventLordDeathCommanding")
				else
					if prologue_check_progression["lord_death"] == false and prologue_check_progression["legendary_lord_death"] == false then
						prologue_check_progression["lord_death_commanding"] = true;

						-- Activates lord recruitment button.
						uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
						prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true;
						AddYuriDeathObjective();
					end
					out("Should start lord death commanding")
				end
			end,
			true
		)
	end

	core:add_listener(
		"CharacterConvalescedOrKilledLegendaryLordObjective",
		"CharacterConvalescedOrKilled", 
		function(context) return context:character():character_type_key() == "general" and context:character():is_faction_leader() and context:character():faction():name() == prologue_player_faction end,
		function() prologue_yuri_dead = true; yuri_died_during_session = true  end,
		true
	)

	core:add_listener(
		"MilitaryForceCreatedTest",
		"MilitaryForceCreated",
		function(context) if prologue_yuri_dead and context:military_force_created():general_character():is_faction_leader() and context:military_force_created():general_character():faction():name() == prologue_player_faction then return true end end,
		function() cm:remove_objective("wh3_prologue_objective_recruit_yuri"); prologue_yuri_dead = false; yuri_died_during_session = false end,
		true
	)

	core:add_listener(
	"CharacterReplacingGeneralTest",
	"CharacterReplacingGeneral",
	function(context) if prologue_yuri_dead then if context:character():is_faction_leader() then if context:character():faction():name() == prologue_player_faction  then return true end end end end,
	function() cm:remove_objective("wh3_prologue_objective_recruit_yuri"); prologue_yuri_dead = false; yuri_died_during_session = false end,
	true
);

	-- Add objective to recruit Yuri if he's dead.
	core:add_listener(
		"LoadingScreenDismissedSetObjectiveIfYuriDead",
		"LoadingScreenDismissed",
		function() if prologue_yuri_dead and yuri_died_during_session == false then return true end end,
		function() AddYuriDeathObjective() end,
		true
	)

end

AddDeathListeners()


function RemoveEncampStance()
	cm:callback(function()
		local player_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();
		for i = 0, player_army_list:num_items() - 1 do
				if player_army_list:item_at(i):is_null_interface() == false and player_army_list:item_at(i):upkeep() > 0  and player_army_list:item_at(i):active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP" then
					general_cqi_test = player_army_list:item_at(i):general_character():cqi()
					local none_stance = player_army_list:item_at(i):can_activate_stance("MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT");
					local char_str = cm:char_lookup_str(general_cqi_test)
					if none_stance == true then
						cm:force_character_force_into_stance(char_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT")
					end
				end
		end
	end,
	0.1)
end

function UnlockPatriarch()
	if not prologue_check_progression["spawned_patriarch"] then
		cm:show_message_event(
			prologue_player_faction, 
			"event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_spawned_patriarch_title", 
			"event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_spawned_patriarch_primary_detail", 
			"event_feed_strings_text_wh3_main_pro_event_feed_string_scripted_event_spawned_patriarch_secondary_detail",
			true, 
			1312, 
			function () 
				local faction = cm:model():world():faction_by_key(prologue_player_faction);
				local closest_region = cm:get_closest_settlement_from_faction_to_position(prologue_player_faction, cm:model():world():faction_by_key(prologue_player_faction):faction_leader():logical_position_x(), cm:model():world():faction_by_key(prologue_player_faction):faction_leader():logical_position_y())
				local closest_settlement = closest_region:settlement()
				common.call_context_command("CcoCampaignSettlement", closest_settlement:cqi(), "Select(false)");
				cm:spawn_agent_at_settlement(faction, closest_settlement, "dignitary", "wh3_main_pro_ksl_patriarch")
				StopAgentsDisbanding()
				
				prologue_mission_patriarch_actions:trigger()

				if prologue_tutorial_passed["lords_with_button_hidden"] == false then
					local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
					if new_player then
						skip_all_scripted_tours();
						core:trigger_event("ScriptEventPrologueCharacters")
					else
						prologue_tutorial_passed["lords_with_button_hidden"] = true;
						uim:override("lords_with_button_hidden"):set_allowed(true);
						uim:override("end_turn"):set_allowed(true);
					end
				else
					uim:override("end_turn"):set_allowed(true);
				end
				
				prologue_check_progression["triggered_patriarch_mission"] = true
				prologue_check_progression["spawned_patriarch"] = true

			end
		)
	end
end

function AddQuestBattleLossListener()
	if prologue_check_progression["st_quest_battle_loss"] == false then
		core:add_listener(
			"PanelOpenedCampaignpopup_battle_results",
			"PanelOpenedCampaign",
			function(context) 
				if context.string == "popup_battle_results" and prologue_check_progression["st_quest_battle_loss"] == false then
					if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
						if cm:model():pending_battle():attacker():faction():name() == prologue_player_faction then
							if cm:model():pending_battle():attacker_battle_result() == "close_defeat" or
							cm:model():pending_battle():attacker_battle_result() == "decisive_defeat" or
							cm:model():pending_battle():attacker_battle_result() == "crushing_defeat" or 
							cm:model():pending_battle():attacker_battle_result() == "valiant_defeat" then
								return true
							end
						elseif cm:model():pending_battle():defender():faction():name() == prologue_player_faction then
							if cm:model():pending_battle():defender_battle_result() == "close_defeat" or
							cm:model():pending_battle():defender_battle_result() == "decisive_defeat" or
							cm:model():pending_battle():defender_battle_result() == "crushing_defeat" or 
							cm:model():pending_battle():defender_battle_result() == "valiant_defeat" then
								return true
							end
						end
					end
				end
			end,
			function()
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventQuestBattleLoss")
				else
					prologue_check_progression["st_quest_battle_loss"] = true;
				end
			end,
			true
		)
	end
end
AddQuestBattleLossListener()
-- This is a debug function to continually print out what keys are stolen.
--[[
function print_out_key_steal()
	cm:print_key_steal_entries()
	cm:callback(function() cm:print_key_steal_entries(); print_out_key_steal() end, 3)
end
--]]

function completely_lock_input(value)
	cm:steal_user_input(value)
	cm:steal_escape_key(value)
	out("Completely stealing input: "..tostring(value))
end

-- This blocks the player's hotkeys.
function allow_hotkeys(value)
	common.enable_all_shortcuts(value)
	out("Allow hotkeys: "..tostring(value))
end

-- Functions to control the end of turn event suppression.
do
	-- This should only be called in very specific circumstances (like the beginning of the prologue), otherwise the player will be able to see end turn events of features they haven't unlocked yet.
	function suppress_all_end_turn_events(should_suppress)
		
		if not is_boolean(should_suppress) then
			script_error("ERROR: suppress_all_end_turn_events() called but supplied should_suppress [" .. tostring(should_suppress) .. "] is not a boolean value");
			return;
		end

		out("suppress_all_end_turn_events() called. Suppression is "..tostring(should_suppress))
		for key in pairs(prologue_end_turn_event_suppression) do
			suppress_end_turn_event(key, should_suppress)
		end

	end

	-- Use this to toggle suppression of a specific event. Events can be found in the end_turn_notifications table.
	function suppress_end_turn_event(event, should_suppress)
		
		local found_key = false

		if not is_boolean(should_suppress) then
			script_error("ERROR: suppress_end_turn_event() called but supplied should_suppress [" .. tostring(should_suppress) .. "] is not a boolean value");
			return;
		end

		if not is_string(event) then
			script_error("ERROR: suppress_end_turn_event() called but event [" .. tostring(event) .. "] is not a string");
			return;
		end;

		-- Check to see the key (event type) exists.
		for key in pairs(prologue_end_turn_event_suppression) do
			if key == event then found_key = true end
		end

		if found_key == false then 
			script_error("ERROR: suppress_end_turn_event() called but event [" .. tostring(event) .. "] could not be found");
			return 
		end

		if prologue_end_turn_event_suppression[event] ~= should_suppress then
			out("suppress_end_turn_event() called. Toggling suppression of "..tostring(event).." to "..tostring(should_suppress))

			prologue_end_turn_event_suppression[event] = should_suppress
			common.call_context_command("CcoCampaignPendingActionNotificationQueue", "", "ToggleSupressNotificationType('"..event.."', true)")
		else
			if should_suppress then
				out("suppress_end_turn_event() called, but event "..tostring(event).." is already suppressed.")
			else
				out("suppress_end_turn_event() called, but event "..tostring(event).." is already not suppressed.")
			end
		end
	end
end

-- Achievement-related Functions
do
	-- The keys can be found in wh_start.lua
	function unlock_achievement(key)
		
		local found_key = false

		if not is_string(key) then
			script_error("ERROR: unlock_achievement() called but supplied key [" .. tostring(key) .. "] is not a string.");
			return;
		end

		-- Check to see the achievement key exists.
		for achievement_key in pairs(prologue_achievements) do
			if key == achievement_key then found_key = true end
		end

		if found_key == false then 
			script_error("ERROR: unlock_achievement() called but key [" .. tostring(key) .. "] could not be found");
			return 
		end

		if prologue_achievements[key] == true then
			script_error("ERROR: unlock_achievement() called but achievement [" .. tostring(key) .. "] is already unlocked.");
			return;
		end


		-- Unlock achievement and set in table.
		prologue_achievements[key] = true
		cm:award_achievement(key)

		-- Output achievement stuff.
		out("Achievement "..key.." was gained!")
		output_achievement_progress()
	end

	-- Output the progress of achievements.
	function output_achievement_progress()
		for achievement_key, achievement_value in pairs(prologue_achievements) do
			out(achievement_key.." is...")
			out(achievement_value)
		end
	end
end

core:add_listener(
	"PanelOpened_objectives_screen",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "objectives_screen"
	end,
	function()
		local uic_tree_holder = find_uicomponent(core:get_ui_root(), "objectives_screen", "subpanel_victory_conditions", "tree_holder")
		uic_tree_holder:SetVisible(false)

		if prologue_check_progression["dervingard_battle_complete"] == false then
			local uic_victory_conditions = find_uicomponent(core:get_ui_root(), "objectives_screen", "TabGroup", "tab_victory_conditions")
			uic_victory_conditions:SetVisible(false)
		end
	end,
	true
);

core:add_listener(
	"PanelOpenedCampaignFinance",
	"PanelOpenedCampaign",
	function(context) return context.string == "finance_screen" end,
	function()
		local uic_auto_management = find_uicomponent(core:get_ui_root(), "tab_taxes", "projected_income", "auto_management_holder");
		local uic_finance_tab_trade = find_uicomponent(core:get_ui_root(), "tab_trade");
		if uic_auto_management then
			uic_auto_management:SetVisible(false);
		end
		if uic_finance_tab_trade then
			uic_finance_tab_trade:SetVisible(false);
		end
	end,
	true
);

local hide_information = false;

core:add_listener(
	"SettlementSelected_prologue",
	"SettlementSelected",
	true,
	function(context)

		local faction_name = context:garrison_residence():faction():name();
		local uic_help_button = find_uicomponent(core:get_ui_root(), "info_holder", "button_info");
		if faction_name ~= prologue_player_faction then
			hide_information = true;
			
			if uic_help_button then
				uic_help_button:SetVisible(false);
			end
		else
			if uic_help_button then
				uic_help_button:SetVisible(true);
			end
		end
	end,
	true
);

core:add_listener(
	"PanelClosed_settlement_panel",
	"PanelClosedCampaign",
	function(context) 
		return context.string == "settlement_panel"
	end,
	function(context)
		hide_information = false;
	end,
	true
);
	

core:add_listener(
	"PanelOpened_settlement_panel",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "settlement_panel"
	end,
	function(context)
		local uic_rename_button = find_uicomponent(core:get_ui_root(), "button_holder", "button_rename");
		local uic_button_create_army = find_uicomponent(core:get_ui_root(), "button_subpanel", "button_create_army");

		if uic_rename_button then
			uic_rename_button:SetVisible(false);
		end
		
		if prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] or prologue_tutorial_passed["settlement_panel_building_browser_with_button_hidden"] or prologue_check_progression["lord_recruitment"] or prologue_check_progression["lord_death"] or prologue_check_progression["legendary_lord_death"] or prologue_check_progression["lord_death_commanding"] then
			 cm:override_ui("hide_units_panel_small_bar_buttons", false);	
		else
			 cm:override_ui("hide_units_panel_small_bar_buttons", true); 
		end

		if prologue_check_progression["st_income_complete"] == false or hide_information == true then
			local uic_help_button = find_uicomponent(core:get_ui_root(), "info_holder", "button_info");
			if uic_help_button then
				uic_help_button:SetVisible(false);
			end
		else
			local uic_help_button = find_uicomponent(core:get_ui_root(), "info_holder", "button_info");
			if uic_help_button then
				uic_help_button:SetVisible(true);
			end
		end

	end,
	true
);

if prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] == false then		
	core:add_listener(
		"SettlementSelectedGarrisonTour",
		"SettlementSelected",
		function(context) return context:garrison_residence():faction():name() ~= prologue_player_faction and prologue_check_progression["open_world"] end,
		function() 
			if dialogue_in_progress == false then 
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventPrologueGarrisonTour") 
				else
					cm:override_ui("hide_units_panel_small_bar_buttons", false);	
					uim:override("units_panel_small_bar_buttons"):set_allowed(true);
					uim:override("settlement_panel_garrison_with_button_hidden"):set_allowed(true);
					prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] = true;
				end
			end
		end,
		true
	)
end

-- add a listener for when the settlement panel is open, make sure the bottom bar is visible
core:add_listener(
	"PanelOpenedCampaignUnitsPanelHideSmallBarButtons",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "units_panel" 
	end,
	function()
		if prologue_tutorial_passed["units_panel_recruit_with_button_hidden"] == false then
			cm:override_ui("hide_units_panel_small_bar_buttons", true);
		else
			cm:override_ui("hide_units_panel_small_bar_buttons", false);
		end
	end,
	true			
);


core:add_listener(
	"pre_battle_resize_panels",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "popup_battle_results" 
	end,
	function()
		local title_bar = find_uicomponent(core:get_ui_root(), "popup_battle_results", "prologue_title_holder");

		if title_bar then
			cm:callback(function() title_bar:SetVisible(false); end, 1);
		else
			out("Couldn't find the title")
		end

		local local_info_button = find_uicomponent(core:get_ui_root(), "popup_battle_results", "mid", "battle_results", "header", "button_info");
		if local_info_button then
			local_info_button:SetVisible(false);
		end
	end,
	true
);


core:add_listener(
	"RecruitmentItemCancelledByPlayer_before_stances",
	"RecruitmentItemCancelledByPlayer",
	true,
	function()
		cm:callback(function() 
			for unit, value in pairs(prologue_regiments_of_renown) do	
			
				local unit_card = find_uicomponent(core:get_ui_root(), unit);
	
				if value == false and unit_card then
					out("Setting "..unit.." panel visibility to : "..tostring(value));
					unit_card:SetVisible(false);
				elseif value and unit_card then
					out("Setting "..unit.." panel visibility to : "..tostring(value));
					unit_card:SetVisible(true);
				end
			end

			local local_recruitment = find_uicomponent(core:get_ui_root(), "recruitment_docker", "local1");
			local local_recruitment_1 = find_uicomponent(core:get_ui_root(), "recruitment_docker", "local1_min");

			if local_recruitment then
				local_recruitment:SetVisible(false);
			else
				out("COULD NOT FIND LOCAL1")
			end

			if local_recruitment_1 then
				local_recruitment_1:SetVisible(false);
			else
				out("COULD NOT FIND LOCAL 1 MIN")
			end

			local local_recruitment_header = find_uicomponent(core:get_ui_root(), "recruitment_docker", "global", "header_frame");
			if local_recruitment_header then
				local_recruitment_header:SetVisible(false);
			else
				out("COULD NOT FIND GLOBAL HEADER")
			end

		end,
		0.1)
	end,
	true
);

core:add_listener(
	"PanelOpenedCampaign_units_panel_units",
	"PanelOpenedCampaign",
	function(context) return context.string == "units_panel" end,
	function()
		--change the tect for max army size
		common.set_context_value("max_unit_count_override", prologue_current_army_cap)
	end,
	true
);

core:add_listener(
	"PanelOpenedCampaign_recruitment_panel",
	"PanelOpenedCampaign",
	function(context) return context.string == "units_recruitment" end,
	function()
		
		local local_recruitment = find_uicomponent(core:get_ui_root(), "recruitment_docker", "local1");
		local local_recruitment_1 = find_uicomponent(core:get_ui_root(), "recruitment_docker", "local1_min");

		if local_recruitment then
			local_recruitment:SetVisible(false);
		else
			out("COULD NOT FIND LOCAL1")
		end

		if local_recruitment_1 then
			local_recruitment_1:SetVisible(false);
		else
			out("COULD NOT FIND LOCAL 1 MIN")
		end

		local local_recruitment_header = find_uicomponent(core:get_ui_root(), "recruitment_docker", "global", "header_frame");
		if local_recruitment_header then
			local_recruitment_header:SetVisible(false);
		else
			out("COULD NOT FIND GLOBAL HEADER")
		end

	end,
	true
);

if prologue_tutorial_passed["stances_with_button_hidden"] == false then
	core:add_listener(
		"ComponentLClickUp_RemoveEncampStance",
		"ComponentLClickUp",
		function() return prologue_tutorial_passed["stances_with_button_hidden"] == false end,
		function() RemoveEncampStance() end,
		true
	)

	core:add_listener(
		"FactionTurnStart_RemoveEncampStance",
		"FactionTurnStart",
		function() return prologue_tutorial_passed["stances_with_button_hidden"] == false end,
		function() RemoveEncampStance() end,
		true
	)
end

if prologue_check_progression["income_reminder"] == false then
	core:add_listener(
		"FactionTurnStartIncomeReminder",
		"FactionTurnStart",
		function (context) if prologue_check_progression["open_world"] and context:faction():is_human() and context:faction():net_income() < 1000 then return true else return false end end,
		function() 
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				prologue_intervention_income_reminder:start(); core:trigger_event("ScriptEventIncomeReminder") 
			else
				prologue_check_progression["income_reminder"] = true;
			end
		end,
		true
	)
end


if prologue_tutorial_passed["end_turn_notification"] == false then
	core:add_listener(
		"FactionTurnStartEndTurnNotificationUnlock",
		"FactionTurnStart",
		function(context) return context:faction():is_human() and prologue_check_progression["open_world"] end,
		function() 
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				core:trigger_event("ScriptEventPrologueEndTurnNotification") 
			else
				uim:override("end_turn_notification"):set_allowed(true);
				prologue_tutorial_passed["end_turn_notification"] = true;
				uim:override("end_turn_previous_with_button_hidden"):set_allowed(true);
				prologue_tutorial_passed["end_turn_previous_with_button_hidden"] = true;
				uim:override("end_turn_next_with_button_hidden"):set_allowed(true);
				prologue_tutorial_passed["end_turn_next_with_button_hidden"] = true;
				uim:override("end_turn_skip_with_button_hidden"):set_allowed(true);
				prologue_tutorial_passed["end_turn_skip_with_button_hidden"] = true;

				-- Un-suppress end turn warnings.
				suppress_end_turn_event("ECONOMICS_PROJECTED_NEGATIVE", false)
				suppress_end_turn_event("ECONOMICS_PROJECTED_NEGATIVE_WITH_DIPLOMATIC_EXPENDITURE", false)
				suppress_end_turn_event("DAMAGED_BUILDING", false)
				suppress_end_turn_event("ARMY_AP_AVAILABLE", false)
				suppress_end_turn_event("CHARACTER_UPGRADE_AVAILABLE", false)
				suppress_end_turn_event("GARRISONED_ARMY_AP_AVAILABLE", false)
				suppress_end_turn_event("HERO_AP_AVAILABLE", false)
				suppress_end_turn_event("SIEGE_NO_EQUIPMENT", false)

				local uic_notification = find_uicomponent(core:get_ui_root(), "end_turn_docker", "dy_notification");
				set_component_active_with_parent(true, uic_notification, "button_notification");
				uic_notification:SetVisible(true);
			end
		end,
		false
	)
end


if prologue_check_progression["open_world"] and not prologue_check_progression["completed_mission_raid_region"] then
	core:add_listener(
		"FactionTurnStartMissionRaidRegion",
		"FactionTurnStart",
		function(context)
			if context:faction():is_human() == false then return end

			local player_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list(); 
			for i = 0, player_army_list:num_items() - 1 do
				if player_army_list:item_at(i):has_garrison_residence() == false then 
					--out(player_army_list:item_at(i):active_stance())
					--out(player_army_list:item_at(i):general_character():region():owning_faction():name())
					--out(prologue_check_progression["completed_mission_raid_region"])
					if player_army_list:item_at(i):active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and player_army_list:item_at(i):general_character():region():owning_faction():name() ~= "wh3_prologue_kislev_expedition" and prologue_check_progression["completed_mission_raid_region"] == false then 
						return true
					end
				end
			end
		end,
		function() prologue_mission_raid_region:force_scripted_objective_success("prologue_raid_region"); prologue_check_progression["completed_mission_raid_region"] = true end,
		true
	)
end

core:add_listener(
	"CharacterRecruitedFindYuri",
	"CharacterRecruited",
	true,
	function(context)
		local character = context:character();
		
		if character:faction():name() == prologue_player_faction then
			if character:is_faction_leader() == true then
				prologue_player_cqi = character:cqi();
			end
		end
	end,
	true
)


core:add_listener(
	"CharacterPerformsSettlementOccupationDecision_Obsidian",
	"CharacterPerformsSettlementOccupationDecision", 
	true,
	function(context)

		prologue_captured_settlement_cqi = context:garrison_residence():region():cqi()

		if context:character():faction():name() == prologue_player_faction then

			local settlements = cm:model():world():faction_by_key(prologue_player_faction):region_list():num_items();

			out("AMOUNT OF SETTLEMENTS: "..settlements)

			
			if context:garrison_residence():region():name() == "wh3_prologue_region_the_maze_keep_mansion_of_eyes" then
				if prologue_check_progression["completed_mansion_of_eyes_mission"] == false then
					prologue_trial_mission = "mansion_of_eyes";
				end
			end

			if context:garrison_residence():region():name() == "wh3_prologue_region_plains_of_brass_the_tah_camp" or context:garrison_residence():region():name() == "wh3_prologue_region_canyons_of_gore_gore_town" or  
				context:garrison_residence():region():name() == "wh3_prologue_region_the_falls_of_circatrex_the_rookery" or settlements == 7 then
				if prologue_check_progression["taken_tribal_settlement"] == false then
					prologue_trial_mission = "tribal";
				end
			end

			if settlements == 4 then 
				if prologue_tutorial_passed["province_info_panel"] == false then

					local event_triggered = false;

					core:add_listener(
						"event_fired",
						"PanelOpenedCampaign",
						function(context) 
							return context.string == "events" 
						end,
						function()
							event_triggered = true;
						end,
						false
					);

					if context:character():faction():is_factions_turn() == true then
						PrologueTriggerProvincePanel(event_triggered)
					else
						core:add_listener(
							"FactionTurnStart_ProvincePanel",
							"FactionTurnStart",
							true,
							function(context)
								if cm:model():is_player_turn() then
									PrologueTriggerProvincePanel(event_triggered)
									core:remove_listener("FactionTurnStart_ProvincePanel");
								end
							end,
							true
						);
					end
				end
			elseif settlements >= 5 then
				if prologue_tutorial_passed["technology_with_button_hidden"] == false then

					if context:character():faction():is_factions_turn() == true then

						if prologue_mission_complete == false then
							prologue_advice_unlock_technology_001("left")
						else
							core:add_listener(
								"event_fired",
								"PanelClosedCampaign",
								function(context) 
									return context.string == "events" 
								end,
								function()
									prologue_advice_unlock_technology_001("left")
								end,
								false
							);
						end
					else
						core:add_listener(
							"FactionTurnStart_Technology",
							"FactionTurnStart",
							true,
							function(context)
								if cm:model():is_player_turn() then
									prologue_advice_unlock_technology_001("left")
									core:remove_listener("FactionTurnStart_Technology");
								end
							end,
							true
						);
					end
				
				else
					if prologue_trial_mission == "mansion_of_eyes" then
						prologue_trial_mission = "";
						if context:character():faction():is_factions_turn() == true then
							PrologueMansionOfEyes();
						else
							core:add_listener(
								"FactionTurnStart_MansionOfEyesComplete",
								"FactionTurnStart",
								true,
								function(context)
									if cm:model():is_player_turn() then
										PrologueMansionOfEyes();
										core:remove_listener("FactionTurnStart_MansionOfEyesComplete");
									end
								end,
								true
							);
						end
					end

					if prologue_trial_mission == "tribal" then
						prologue_trial_mission = "";
						if context:character():faction():is_factions_turn() == true then
							PrologueTribalMission();
						else
							core:add_listener(
								"FactionTurnStart_TribalMissionComplete",
								"FactionTurnStart",
								true,
								function(context)
									if cm:model():is_player_turn() then
										PrologueTribalMission();
										core:remove_listener("FactionTurnStart_TribalMissionComplete");
									end
								end,
								true
							);
						end
					end

				end

				
			end

		end
		
	end,
	true
);


-- These listeners display advice for after the player has recruited a new lord, and a new lord's first unit.
do
	if not prologue_tutorial_passed["lords_with_button_hidden"] then
		core:add_listener(
			"recruit_lord_button_listener",
			"ComponentLClickUp",
			function(context) 
				out(prologue_tutorial_passed["lords_with_button_hidden"])
				return context.string == "button_raise" and prologue_tutorial_passed["lords_with_button_hidden"] == false end,
			function() prologue_advice_new_lord_001() end,
			false
		)
	end

	if not prologue_check_progression["new_lord_recruit_advice"] then
		core:add_listener(
			"recruitment_issued_prologue_after_lord",
			"RecruitmentItemIssuedByPlayer",
			function() 
				local cqi = cuim:get_char_selected_cqi();
				local army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();
				for i = 0, army_list:num_items() - 1 do
					if army_list:item_at(i):general_character():cqi() == cqi and cqi ~= prologue_player_cqi and test == false and not prologue_check_progression["new_lord_recruit_advice"] then
						return true
					end
				end
			end,
			function() prologue_advice_new_army_001() end,
			false
		)
	end
end

function PrologueTriggerProvincePanel(event_triggered)
	cm:callback(function()
		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			if event_triggered == false then
				cm:steal_user_input(true)
				cm:callback(function() core:trigger_event("ScriptEventPrologueProvinceInfoPanel") end, 0.5)
			else
				core:add_listener(
					"event_fired",
					"PanelClosedCampaign",
					function(context) 
						return context.string == "events" 
					end,
					function()
						cm:callback(function() core:trigger_event("ScriptEventPrologueProvinceInfoPanel") end, 1)
					end,
					false
				);
			end
		else
			cm:override_ui("hide_units_panel_small_bar_buttons", false);	
		
			prologue_tutorial_passed["province_info_panel"] = true;
			uim:override("province_info_panel"):set_allowed(true);

			prologue_tutorial_passed["demolish_with_button_hidden"] = true;
			uim:override("demolish_with_button_hidden"):set_allowed(true);

			prologue_tutorial_passed["settlement_panel_building_browser_with_button_hidden"] = true;
			uim:override("settlement_panel_building_browser_with_button_hidden"):set_allowed(true);

			prologue_tutorial_passed["building_browser"] = true;
			uim:override("building_browser"):set_allowed(true)

			prologue_mission_building_level:trigger();

			-- Stop suppressing settlement growth.
			cm:remove_effect_bundle("wh3_prologue_suppress_growth", cm:get_local_faction_name())

			-- Enable end turn upgrade notifications.
			suppress_end_turn_event("PROVINCES_NO_CONSTRUCTION_PROJECT", false)

			core:add_listener(
				"PanelClosedCampaign_building_level_mission",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()
					if prologue_trial_mission == "mansion_of_eyes" then
						PrologueMansionOfEyes();
						prologue_trial_mission = "";
					elseif prologue_trial_mission == "tribal" then
						PrologueTribalMission();
						prologue_trial_mission = "";
					end
				end,
				false
			);

			
		end
	
	end,
	1)
end

function PrologueMansionOfEyes()
	if prologue_check_progression["triggered_mansion_of_eyes_mission"] then
		prologue_mission_capture_mansion_of_eyes:force_scripted_objective_success("mission_capture_regions_mansion_of_eyes")
		prologue_check_progression["completed_mansion_of_eyes_mission"] = true
		core:add_listener(
			"PanelClosedCampaign_mansion_of_eyes_complete",
			"PanelClosedCampaign",
			function(context) return context.string == "events" end,
			function()
				cm:contextual_vo_enabled(true);
			end,
			false
		);
	end
end

function PrologueTribalMission()
	prologue_advice_complete_trial_001();
	prologue_check_progression["taken_tribal_settlement"] = true;
end


function add_reinforcements_listener()
	
	local garrison_battle

	if prologue_check_progression["scripted_tour_reinforcements"] == false then
		core:add_listener(
			"PanelOpenedCampaign_popup_pre_battle_reinforcements",
			"PanelOpenedCampaign",
			function(context) return context.string == "popup_pre_battle" end,
			function()
				if prologue_check_progression["scripted_tour_reinforcements"] == false and garrison_battle == false and common.get_context_value("CampaignBattleContext.IsQuestBattle") == false and prologue_check_progression["scripted_tour_reinforcements"] == false then
					local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
					if new_player then
						core:trigger_event("ScriptEventReinforcements");
					else
						prologue_check_progression["scripted_tour_reinforcements"] = true;
					end
				end
			end,
			true
		)

		core:add_listener(
			"PendingBattleIsThereGarrison",
			"PendingBattle",
			true,
			function(context)
				if context:pending_battle():attacker():faction():name() == prologue_player_faction or context:pending_battle():defender():faction():name() == prologue_player_faction then
					if context:pending_battle():has_contested_garrison() then
						garrison_battle = true
						return
					end
				end
				garrison_battle = false
			end,
			true
		)
	end
end

if prologue_check_progression["scripted_tour_reinforcements"] == false and prologue_check_progression["dervingard_battle_complete"] then
	add_reinforcements_listener()
end

function prologue_pulse_info_button(path)
	local uic_button_help = path;
	if uic_button_help then
		pulse_uicomponent(uic_button_help, 2, 6);
	else
		out("COULD NOT FIND THE BUTTON")
	end
end

function PrologueSetFactionsAtWar()
	--[[core:add_listener(
		"FactionEncountersOtherFaction_prologue",
		"FactionEncountersOtherFaction",
		true,
		function(context)
			if context:faction():name() == prologue_player_faction then
				local other_faction = context:other_faction():name();
				local other_culture = context:other_faction():subculture();

				if other_culture == "wh3_main_pro_sc_kho_khorne" or other_culture == "wh3_main_pro_sc_tze_tzeentch" then
					cm:force_declare_war(other_faction, prologue_player_faction, true, true);
				end

				out("AT WAR NOW")
			end
		end,
		true			
	);]]
end

if prologue_check_progression["dervingard_battle_complete"] == true then
	PrologueSetFactionsAtWar();
end

function PrologueSetUpDiplomacy()
	local faction_list = cm:model():world():faction_list();
	
	out("CAN DECLARE WAR")
	cm:force_diplomacy("faction:"..prologue_player_faction, "all", "war", true, true, false)
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:is_dead() then
			local current_faction_name = current_faction:name();
			
			local exclude_current_faction = false;

			local other_culture = current_faction:subculture();
			
			if current_faction_name == prologue_player_faction then
				exclude_current_faction = true;
			end;
			
			if not exclude_current_faction then
				out("\t * " .. prologue_player_faction .. " is now at war with " .. current_faction_name);
				if current_faction_name ~= "wh3_prologue_ksl_kislev_survivors" then
					--cm:force_declare_war(prologue_player_faction, current_faction_name, false, false);
					if other_culture == "wh3_main_pro_sc_kho_khorne" or other_culture == "wh3_main_pro_sc_tze_tzeentch" then
						cm:force_diplomacy("faction:" .. current_faction_name, "faction:" .. prologue_player_faction, "all", false, false, true);
						cm:force_diplomacy("faction:"..prologue_player_faction, "faction:" .. current_faction_name, "war", true, true, false);
					else
						cm:force_diplomacy("faction:" .. current_faction_name, "faction:" .. prologue_player_faction, "trade agreement,defensive alliance,hard military access", false, false, true);
					end
				end
			end;
		end;
	end;
end

function RecruitmentReminder()
	local army_size = cm:model():world():faction_by_key(prologue_player_faction):faction_leader():military_force():unit_list():num_items()
	if prologue_check_progression["recruit_reminder"] == false and army_size ~= prologue_current_army_cap then 
		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			core:trigger_event("ScriptEventRecruitReminder"); 
		else
			prologue_check_progression["recruit_reminder"] = true;
		end
	end
end

if prologue_tutorial_passed["diplomacy_with_button_hidden"] == true then
	PrologueSetUpDiplomacy();
else
	cm:enable_all_diplomacy(false);
	cm:force_diplomacy("faction:"..prologue_player_faction, "all", "war", false, false, false)
end

core:add_listener(
	"PanelOpened_diplomacy_screen",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "diplomacy_dropdown"
	end,
	function(context)
		local uic_diplomacy_player_panel_trade = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel", "diplomatic_relations", "icon_trade_partners");
		local uic_diplomacy_player_panel_allies = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel", "diplomatic_relations", "icon_allies");
		local uic_diplomacy_player_panel_attribute = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel", "attributes_holder");
		local uic_diplomacy_player_panel_trade_goods = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel", "trade");
		local uic_diplomacy_player_panel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel");

		local uic_diplomacy_overlay_bar = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "overlay_bar");
		local uic_diplomacy_overlay_keys = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "overlay_key_parent");

		local uic_diplomacy_other_panel_trade = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "diplomatic_relations", "icon_trade_partners");
		local uic_diplomacy_other_panel_allies = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "diplomatic_relations", "icon_allies");
		local uic_diplomacy_other_panel_attribute = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "attributes_holder");
		local uic_diplomacy_other_panel_trade_goods = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "trade");
		local uic_diplomacy_other_panel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel");


		local uic_diplomacy_quick_deal = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_bottom", "button_quick_deal");

		if uic_diplomacy_player_panel_trade then
			uic_diplomacy_player_panel_trade:SetVisible(false);
		end

		if uic_diplomacy_player_panel_allies then
			uic_diplomacy_player_panel_allies:SetVisible(false);
		end

		if uic_diplomacy_player_panel_trade_goods then
			uic_diplomacy_player_panel_trade_goods:SetVisible(false);
		end

		if uic_diplomacy_player_panel_attribute then
			uic_diplomacy_player_panel_attribute:SetVisible(false);
		end

		if uic_diplomacy_other_panel_trade then
			uic_diplomacy_other_panel_trade:SetVisible(false);
		end

		if uic_diplomacy_other_panel_allies then
			uic_diplomacy_other_panel_allies:SetVisible(false);
		end

		if uic_diplomacy_other_panel_trade_goods then
			uic_diplomacy_other_panel_trade_goods:SetVisible(false);
		end

		if uic_diplomacy_other_panel_attribute then
			uic_diplomacy_other_panel_attribute:SetVisible(false);
		end
	
		if uic_diplomacy_overlay_bar then
			uic_diplomacy_overlay_bar:SetVisible(false);
		end
		
		if uic_diplomacy_overlay_keys then
			uic_diplomacy_overlay_keys:SetVisible(false);
		end

		if uic_diplomacy_quick_deal then
			uic_diplomacy_quick_deal:SetVisible(false);
		end

		
	end,
	true
);

-- If called without parameters, the marker will default to Yuri's position. If a marker with the desired name already exists, it will be replaced.
function add_selection_marker_prologue(name, real_display_position_x, real_display_position_y, marker_type)
	
	real_display_position_x = real_display_position_x or 0
	real_display_position_y = real_display_position_y or 0
	name = name or "default_yuri_marker"

	if not is_string(name) then
		script_error("ERROR: add_selection_marker_prologue() called but name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(marker_type) then
		script_error("ERROR: add_selection_marker_prologue() called but marker_type [" .. tostring(marker_type) .. "] is not a string");
		return false;
	end;

	if not is_number(real_display_position_x) then
		script_error("ERROR: add_selection_marker_prologue() called but supplied real_display_position_x [" .. tostring(real_display_position_x) .. "] is not a number");
		return false;
	end;

	if not is_number(real_display_position_y) then
		script_error("ERROR: add_selection_marker_prologue() called but supplied real_display_position_y [" .. tostring(real_display_position_y) .. "] is not a number");
		return false;
	end;
	
	if real_display_position_x == 0 and real_display_position_x == 0 then
		real_display_position_x = cm:model():world():faction_by_key(prologue_player_faction):faction_leader():display_position_x()
		real_display_position_y = cm:model():world():faction_by_key(prologue_player_faction):faction_leader():display_position_y()
	end
	
	-- Remove existing marker.
	remove_marker_prologue(name)

	-- Add new ones.
	cm:add_marker(name.."1", marker_type, real_display_position_x, real_display_position_y, 1)

	-- Concentric circles
	--cm:add_marker(name.."2", "move_to_vfx", real_display_position_x, real_display_position_y, 1)
end

-- If called without parameters, will remove Yuri's default marker.
function remove_marker_prologue(name)

	name = name or "default_yuri_marker"

	if not is_string(name) then
		script_error("ERROR: remove_marker_prologue() called but name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	cm:remove_marker(name.."1")
	cm:remove_marker(name.."2")
end

do
	-- This cycles through the events and enables/disables them based on their saved setting.
	function set_events_disabled()
		for key, value in pairs(prologue_event_activation) do
			cm:disable_event_feed_events(value, "","", key)
		end
	end

	-- Enables/controls event type in event feed.
	function disable_event_type(disable, event_type)
		
		local found_key = false
		
		-- Check to see the key (event type) exists.
		for key, value in pairs(prologue_event_activation) do
			if key == event_type then found_key = true end
		end

		if found_key == false then 
			script_error("ERROR: disable_event_type() called but event_type [" .. tostring(event_type) .. "] could not be found");
			return 
		end
		
		if not is_boolean(disable) then
			script_error("ERROR: disable_event_type() called but supplied disable [" .. tostring(disable) .. "] is not a boolean value");
			return;
		end

		if not is_string(event_type) then
			script_error("ERROR: disable_event_type() called but event_type [" .. tostring(event_type) .. "] is not a string");
			return false;
		end;

		-- Disable event type and save value in table.
		cm:disable_event_feed_events(disable, "","", event_type)
		prologue_event_activation[event_type] = disable
	end

	-- Disables events around key battles like Dervingard/quest battles. This will also disable item generation
	function disable_key_battle_events(value)

		if not is_boolean(value) then
			script_error("ERROR: disable_key_battle_events() called but supplied value [" .. tostring(value) .. "] is not a boolean value");
			return;
		end

		disable_event_type(value, "character_dies_battle")
		disable_event_type(value, "character_rank_gained")
		disable_event_type(value, "diplomacy_faction_destroyed")
		
		-- Disable item generation.
		prologue_check_progression["item_generation"] = not value
	end
	
	-- Add listener for quest battle completion. Disable events if it is (which must be re-activated after each post-battle scripted section)
	core:add_listener(
		"CharacterCompletedBattleQuestBattle",
		"CharacterCompletedBattle",
		function(context)
			if cm:pending_battle_cache_human_victory() and (context:pending_battle():set_piece_battle_key() == "wh3_prologue_ice_witch_rescue" or context:pending_battle():set_piece_battle_key() == "wh3_prologue_brazen_altar" or context:pending_battle():set_piece_battle_key() == "wh3_prologue_howling_citadel") then
				return true
			end
		end,
		function()
			disable_key_battle_events(true)
		end,
		true
	)
end

-- Stops AI settlements from growing by applying a massive debuff.
function stop_ai_settlement_growth(value)

	local player_faction = cm:get_local_faction()
	local faction_list = cm:model():world():faction_list()
	
	if value then
		for i = 0, faction_list:num_items() - 1 do
			if faction_list:item_at(i) ~= player_faction then
				cm:apply_effect_bundle("wh3_prologue_suppress_growth", faction_list:item_at(i):name(), 0)
			end
		end
	else
		for i = 0, faction_list:num_items() - 1 do
			if faction_list:item_at(i) ~= player_faction then
				cm:remove_effect_bundle("wh3_prologue_suppress_growth", faction_list:item_at(i):name())
			end
		end
	end
end

function add_demolish_listener()
	core:add_listener(
		"enable_demolish_for_player_start",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "settlement_panel"
		end,
		function()
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				core:trigger_event("ScriptEventPrologueDemolish")
			else
				prologue_tutorial_passed["demolish_with_button_hidden"] = true;
			end
		end,
		true
	)
	
end

if prologue_check_progression["open_world"] and prologue_tutorial_passed["demolish_with_button_hidden"] == false then
	add_demolish_listener()
end

function add_stances_listeners()
	if prologue_check_progression["brazen_altar_battle_complete"] and not prologue_tutorial_passed["stances_with_button_hidden"] then
		core:add_listener(
			"CharacterSelectedStartStancesTour",
			"CharacterSelected",
			function(context) return context:character():character_type_key() == "general" and context:character():faction():name() == prologue_player_faction end,
			function() uim:override("stances_with_button_hidden"):set_allowed(true) end,
			true
		)

		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			core:add_listener(
				"PanelOpenedCampaignStartStancesTour",
				"PanelOpenedCampaign",
				function(context) return context.string == "units_panel" end,
				function() skip_all_scripted_tours(); core:trigger_event("ScriptEventStances") end,
				true
			);
		else
			prologue_tutorial_passed["stances_with_button_hidden"] = true;
			uim:override("stances_with_button_hidden"):set_allowed(true)

			uim:override("terrain_tooltips"):set_allowed(true);
			prologue_mission_raid_region:trigger();

			core:remove_listener("CharacterSelectedStartStancesTour")
		end
	end
end

add_stances_listeners()

-- Stuff related to Technology objectives.
do
	function PrologueChooseTechnology(from_load)

		if from_load then
			cm:set_objective_with_leader("wh3_prologue_objective_turn_018_02")
		else
			cm:set_objective_with_leader("wh3_prologue_objective_turn_018_01")
		end

		core:add_listener(
			"ComponentLClickUpStartResearch",
			"ComponentLClickUp",
			function(context) return uicomponent_descended_from(UIComponent(context.component), "technology_list") and uicomponent_descended_from(UIComponent(context.component), "slot_parent") end,
			function()
				cm:remove_objective("wh3_prologue_objective_turn_018_01")
				cm:remove_objective("wh3_prologue_objective_turn_018_02")

				cm:callback(
					function()
						cm:remove_objective("wh3_prologue_objective_turn_018_01")
						cm:remove_objective("wh3_prologue_objective_turn_018_02")
					end,
					PrologueTopicLeaderAnimationTime
				)
				prologue_tutorial_passed["technology_research_started"] = true
			end,
			false
		)
	end

	-- Apply objective on load if necessary.
	if prologue_tutorial_passed["technology_with_button_hidden"] and not prologue_tutorial_passed["technology_research_started"] then
		PrologueChooseTechnology(true)
	end
end

do
	-- This function provides provides a structure for an objective that requires an ambiguous single building. 
	-- It will switch between them as the player queues and cancels a building.
	local active_listeners = {}

	function ConstructionTopicLeaders(construction_topic_leader, end_turn_topic_leader, stop_topic_leaders_during_dialogue)
		
		local wait_for_dialogue_time = wait_for_dialogue_time or 0 -- If this is set above 0, it apply after building/cancelling before applying objectives.
		local construction_callback = false -- Stores whether the final callback after dialogue should be construction or end turn.
		local repeat_callback_active = false -- Stores whether a repeat callback is active.

		prologue_current_objective = construction_topic_leader;

		if stop_topic_leaders_during_dialogue then -- Need a wait to check if dialogue is playing.
			wait_for_dialogue_time = 0.5
		end

		-- Check values are strings.
		if not is_string(construction_topic_leader) then
			script_error("ERROR: trying to call ConstructionTopicLeader() but supplied trigger argument " .. tostring(construction_topic_leader) .. " is not a string");
			return false;
		end;

		if not is_string(end_turn_topic_leader) then
			script_error("ERROR: trying to call ConstructionTopicLeader() but supplied trigger argument " .. tostring(end_turn_topic_leader) .. " is not a string");
			return false;
		end;

		if not is_number(wait_for_dialogue_time) then
			script_error("ERROR: trying to call ConstructionTopicLeader() but supplied trigger argument " .. tostring(wait_for_dialogue_time) .. " is not a number");
			return false;
		end;

		-- Do not re-apply listeners.
		if table.contains(active_listeners, construction_topic_leader) or table.contains(active_listeners, end_turn_topic_leader) then
			return
		end

		-- Keep track of active listeners
		table.insert(active_listeners, construction_topic_leader)
		table.insert(active_listeners, end_turn_topic_leader)

		-- Functions to apply the topic leaders. This needs to be separate from the removal so they can be called after dialogue, but removal can still happen during.
		local function ApplyConstructionTopicLeader()
			PrologueAddTopicLeader(
				construction_topic_leader, 
				function() 
					if building_in_progress == true then -- If building is in progress after the animation finishes, remove the construction objective..
						cm:remove_objective(construction_topic_leader)
					end
				end,
				true,
				true
			)
		end

		local function ApplyEndTurnTopicLeader()
			PrologueAddTopicLeader(
				end_turn_topic_leader, 
				function() 
					if building_in_progress == false then -- If building is not in progress after the animation finishes, remove the end turn objective..
						cm:remove_objective(end_turn_topic_leader)
					end
				end,
				true,
				true
			)
		end

		local function SetUpEndOfDialogueCallback(construction)
			-- Create the repeat callback if it doesn't exist.
			if repeat_callback_active == false then
				
				repeat_callback_active = true -- Set this to true so only one can be created at once.
				
				cm:repeat_callback(
					function()
						if dialogue_in_progress == false then

							if construction_callback then
								ApplyConstructionTopicLeader()
							else
								ApplyEndTurnTopicLeader()
							end

							cm:remove_callback("ConstructionTopicLeadersRepeatCallback")

							repeat_callback_active = false
						end
					end,
					0.1,
					"ConstructionTopicLeadersRepeatCallback"
				)
			end

			-- This determines the final callback
			if construction then 
				construction_callback = true
			else
				construction_callback = false
			end
		end

		-- Apply the initial objective, depending on whether a building is in progress.
		if building_in_progress then
			PrologueRemoveObjective()
			cm:remove_objective(construction_topic_leader)

			cm:callback(
					function()
						if dialogue_in_progress and stop_topic_leaders_during_dialogue then
							SetUpEndOfDialogueCallback(false)
						else
							ApplyEndTurnTopicLeader()
						end
					end,
					wait_for_dialogue_time
				)
		else
			cm:remove_objective(end_turn_topic_leader)
			PrologueRemoveObjective()

			cm:callback(
					function()
						if dialogue_in_progress and stop_topic_leaders_during_dialogue then
							SetUpEndOfDialogueCallback(true)
						else
							ApplyConstructionTopicLeader()
						end
					end,
					wait_for_dialogue_time
				)
		end
		
		-- Apply listeners for constructing or cancelling a building.
		core:add_listener(
			"BuildingConstructionIssuedByPlayerConstructionListener",
			"BuildingConstructionIssuedByPlayer",
			true,
			function()
				if prologue_current_objective == "wh3_prologue_objective_turn_003_01" or prologue_current_objective == "wh3_prologue_objective_turn_011_01" or prologue_current_objective == "wh3_prologue_objective_turn_014_02" then
					PrologueRemoveObjective()
					cm:remove_objective(construction_topic_leader)
					cm:callback(
						function()
							if dialogue_in_progress and stop_topic_leaders_during_dialogue then
								SetUpEndOfDialogueCallback(false)
							else
								ApplyEndTurnTopicLeader()
							end
						end,
						wait_for_dialogue_time
					)
				end
				
			end,
			true
		)

		core:add_listener(
			"RegionBuildingCancelledConstructionListener",
			"RegionBuildingCancelled",
			function(context) return context:slot():faction():name() == prologue_player_faction end,
			function()
				PrologueRemoveObjective()
				cm:remove_objective(end_turn_topic_leader)

				cm:callback(
					function()
						if dialogue_in_progress and stop_topic_leaders_during_dialogue then
							SetUpEndOfDialogueCallback(true)
						else
							ApplyConstructionTopicLeader()
						end
					end,
					wait_for_dialogue_time
				)
				
			end,
			true
		)

		-- Clean up listeners.
		core:add_listener(
			"FactionTurnEndCleanUpConstructionListeners",
			"FactionTurnEnd",
			true,
			function()
				core:remove_listener("BuildingConstructionIssuedByPlayerConstructionListener")
				core:remove_listener("RegionBuildingCancelledConstructionListener")
				cm:remove_objective(construction_topic_leader)
				cm:remove_objective(end_turn_topic_leader)
				
				for key, value in pairs(active_listeners) do
					if value == construction_topic_leader or value == end_turn_topic_leader then 
						table.remove(active_listeners, key);
					end
				end
			end,
			false
		);
	end
	
	-- Apply listeners to keep track of when a building is in progress or not
	core:add_listener(
		"BuildingConstructionIssuedByPlayerConstructionListenerProgressCheck",
		"BuildingConstructionIssuedByPlayer",
		true,
		function() building_in_progress = true end,
		true
	)

	core:add_listener(
		"RegionBuildingCancelledConstructionListenerProgressCheck",
		"RegionBuildingCancelled",
		function(context) return context:slot():faction():name() == prologue_player_faction end,
		function() building_in_progress = false end,
		true
	)

	core:add_listener(
		"BuildingCompletedConstructionListenerProgressCheck",
		"BuildingCompleted",
		function(context) return context:building():slot():faction():name() == prologue_player_faction end,
		function() building_in_progress = false end,
		true
	)

end

if prologue_check_progression["besieged_twice"] == false then
	-- Check the first time a player encircles the enemy.

	local function add_besiege_again_objective_and_listener()
		core:add_listener(
			"FactionTurnStart_PrologueCheckSiege",
			"FactionTurnStart",
			true,
			function(context)
				if context:faction():is_human() then

					local player_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();

					for i = 0, player_army_list:num_items() - 1 do
						if player_army_list:item_at(i):upkeep() > 0 and player_army_list:item_at(i):general_character():is_faction_leader() then
							if player_army_list:item_at(i):general_character():is_besieging() == true then
								cm:set_objective_with_leader("wh3_prologue_objective_besiege_again");
								core:remove_listener("FactionTurnStart_PrologueCheckSiege");
							end
						end
					end

					core:add_listener(
						"PanelOpenedCampaignBesiegeAgain",
						"PanelOpenedCampaign",
						function(context) 
							if context.string == "popup_pre_battle" then
								local uic_commander_0
								local uic_commander_0_context_object_id
								local contextValue
								local uic_commander_0_enemy
								local uic_commander_0_enemy_context_object_id
								local contextValue_enemy

								uic_commander_0 = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
								if uic_commander_0 then
									uic_commander_0_context_object_id = uic_commander_0:GetContextObjectId("CcoCampaignCharacter")
									if uic_commander_0_context_object_id then
										contextValue = common.get_context_value("CcoCampaignCharacter", uic_commander_0_context_object_id, "CQI")
									end
								end

								uic_commander_0_enemy = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
								if uic_commander_0_enemy then 
									uic_commander_0_enemy_context_object_id = uic_commander_0_enemy:GetContextObjectId("CcoCampaignCharacter")
									if uic_commander_0_enemy_context_object_id then
										contextValue_enemy = common.get_context_value("CcoCampaignCharacter", uic_commander_0_enemy_context_object_id, "CQI")
									end
								end

								if contextValue == prologue_player_cqi or contextValue_enemy == prologue_player_cqi then return true end
							end
						end,
						function() cm:remove_objective("wh3_prologue_objective_besiege_again"); prologue_check_progression["besieged_twice"] = true end,
						false
					)

					core:add_listener(
						"Intro_FactionTurnEndPrologueRemoveSiege",
						"FactionTurnEnd",
						true,
						function(context)
							if context:faction():name() == prologue_player_faction then
								cm:remove_objective("wh3_prologue_objective_besiege_again");
							end
						end,
						true
					);

				end
			end,
		true
		);
	end

	if prologue_check_progression["besieged_once"] then
		add_besiege_again_objective_and_listener()
	else
		core:add_listener(
		"ComponentLClickUpFirstSurround",
		"ComponentLClickUp",
		function(context) return context.string == "button_surround" end,
		function() add_besiege_again_objective_and_listener(); prologue_check_progression["besieged_once"] = true end,
		false
	)
	end
end

function AddHelpReminder(force_play)

	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then

		-- If you want the message to play more than once.
		force_play = force_play or false

		core:add_listener(
			"PanelOpenedCampaignHelpReminder",
			"PanelOpenedCampaign",
			function(context) 
				if context.string == "units_panel" and (prologue_check_progression["help_reminder"] == false or force_play) then 
					return true 
				end
			end,
			function()
				completely_lock_input(true)
				cm:callback(function() completely_lock_input(false) end, 1)
				local uic = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "tr_element_list", "button_info_holder", "button_info")

				if uic then
					uic:Highlight(true)

					local clean_up = false
					local tp = text_pointer:new_from_component(
						"tp_help_reminder",
						"bottom",
						50,
						uic,
						0.5,
						0
					)
					
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_help_reminder")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() clean_up() end)
					cm:callback(function() tp:show() end, 0.2);

					clean_up = function()
						core:remove_listener("PanelOpenedCampaignHelpReminder")
						core:remove_listener("PanelOpenedCampaignHelpReminderPanelCallback")
						core:remove_listener("PanelClosedCampaignHelpReminderPanelCallback")
						core:remove_listener("ComponentLClickUpHelpReminder")
						tp:hide(); 
						uic:Highlight(false);
						prologue_check_progression["help_reminder"] = true
					end

					core:add_listener(
						"ComponentLClickUpHelpReminder",
						"ComponentLClickUp",
						function(context) return context.string == "button_info" end,
						function() clean_up() end,
						false
					)

					AddPanelCallbacks(function() clean_up() end, function() clean_up() end, "PanelClosedCampaign", "HelpReminderPanelCallback")
				end
			end,
			true
		)
	end
end

-- Stops the player from disbanding their agents.
function StopAgentsDisbanding()

	local character_list = cm:model():world():faction_by_key(prologue_player_faction):character_list()
	
	for i=0, character_list:num_items() - 1 do
		if character_list:item_at(i):character_type_key() == "wizard" or character_list:item_at(i):character_type_key() == "dignitary" then
			out(character_list:item_at(i):cqi())
			cm:set_character_cannot_disband(character_list:item_at(i), true)
		end
	end
end


-- add a listener for when a building is complete
core:add_listener(
	"CharacterBuildingCompleted_Prologue",
	"BuildingCompleted",
	true,
	function(context)
		-- get a handle on the building name and faction 
		local building = context:building():name();
		local faction = context:garrison_residence():faction();
		if faction:is_human() then
			
			-- set the building_complete variable to true
			building_complete = true;
			
			-- save the building name in the test_building variable
			test_building = building;

			if building == "wh3_prologue_building_ksl_special_1" then
				PrologueRemoveObjective();
			end
		end
	end,
	true
);


core:add_listener(
	"opening_general_details_panel",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "character_details_panel" 
	end,
	function()
		if prologue_tutorial_passed["skills_with_button_hidden"] == false then
			local skills = find_uicomponent(core:get_ui_root(), "character_context_parent", "TabGroup", "skills")
			local skill_holder = find_uicomponent(core:get_ui_root(), "character_context_parent", "skill_pts_holder")
			if skills then
				skills:SetVisible(false);
			end
			if skill_holder then
				skill_holder:SetVisible(false);
			end
		end
		local quests = find_uicomponent(core:get_ui_root(), "character_context_parent", "TabGroup", "quests")
		if quests then
			quests:SetVisible(false);
		else
			out("DIDN@T FIND QUESTS")
		end
		if prologue_check_progression["occupied_settlement"] == false then
			local info_location = find_uicomponent(core:get_ui_root(), "character_context_parent", "character_details_subpanel", "location")
			if info_location then		
				info_location:SetVisible(false);
			end
		end
		local character_rank = find_uicomponent(core:get_ui_root(), "character_context_parent", "rank")
		if character_rank then
			character_rank:SetVisible(false);
		else
			out("DIDN@T FIND CHARACTER RANK")
		end
		local uic_auto_management_holder = find_uicomponent(core:get_ui_root(), "character_details_panel", "auto_management_holder")
		if uic_auto_management_holder then
			uic_auto_management_holder:SetVisible(false);
		else
			out("DIDN@T AUTO MANAGEMENT HOLDER")
		end
		local uic_fusing_salvaging_buttons_holder = find_uicomponent(core:get_ui_root(), "character_details_panel", "fusing_salvaging_buttons_holder")
		if uic_fusing_salvaging_buttons_holder then
			uic_fusing_salvaging_buttons_holder:SetVisible(false);
		else
			out("DIDN@T FUSE/SALVAGE HOLDER")
		end

		local function set_extraneous_details_visible (value)
			local uic_skills = find_uicomponent("character_details_panel", "character_context_parent", "TabGroup", "skills")
			uic_skills:SetVisible(value)
			
			local uic_stats_effects_holder = find_uicomponent("character_details_panel", "character_context_parent", "tab_panels", "stats_effects_holder")
			for i = 0, uic_stats_effects_holder:ChildCount() - 1 do
				local uic_stats_effects_holder_child = UIComponent(uic_stats_effects_holder:Find(i)) 
				uic_stats_effects_holder_child:SetVisible(value)
			end
		end
		
		if prologue_tutorial_passed["skills_with_button_hidden"] then
			set_extraneous_details_visible(true)
		else
			set_extraneous_details_visible(false)
		end
		cm:callback(function() 
			local uic_character_context_parent = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent");
			local replace_lord = find_uicomponent("character_details_panel", "character_context_parent", "holder_br", "bottom_buttons", "button_replace_general")
			local character_CQI_0 = uic_character_context_parent:GetContextObjectId("CcoCampaignCharacter")
			if character_CQI_0 == "1" then
				replace_lord:SetVisible(false)
			end
		end, 0.2)
	
		-- Disables second ancillary slot if Yuri's sword.
		cm:callback(
			function()
				if prologue_check_progression["equipped_sword"] == false then return end
				
				if uic_character_context_parent then
					local equipped_items_list = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel",
					"frame", "ancillary_parent", "magic_items_equiped", "equiped_items_list")
					if equipped_items_list then
						local uic_weapon_ancillary = UIComponent(equipped_items_list:Find(2))
						if uic_weapon_ancillary then
							local character_CQI = uic_character_context_parent:GetContextObjectId("CcoCampaignCharacter")
							if character_CQI == "1" then
								uic_weapon_ancillary:SetDisabled(true)
							else
								uic_weapon_ancillary:SetDisabled(false)
							end
						end
					end				
				end
			end,
			0.1
		)
	end,
	true
)

if prologue_check_progression["st_switch_commanders"] == false then
	core:add_listener(
		"CharacterCreatedFirstGeneral",
		"CharacterCreated", 
		function(context) 
			return prologue_check_progression["st_switch_commanders"] == false and 
			context:character():is_faction_leader() == false and 
			context:character():faction():name() == prologue_player_faction  and
			context:character():character_type_key() == "general"
		 end,
		function(context)
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				local cqi = context:character():command_queue_index()
				cm:callback(function() cm:replenish_action_points(cm:char_lookup_str(cqi)) end, 0.1)
				core:trigger_event("ScriptEventSwitchCommanders") 
			else
				prologue_check_progression["st_switch_commanders"] = true;
			end
		end,
		true
	)
end

core:add_listener(
	"FactionTurnStart_RemoveEndTurnOjectives",
	"FactionTurnStart",
	true,
	function(context)
		if context:faction():is_human() then
			if prologue_current_objective == "wh3_prologue_objective_turn_001_04" or prologue_current_objective == "wh3_prologue_objective_turn_001_06" or prologue_current_objective == "wh3_prologue_objective_turn_001_07" or
			prologue_current_objective == "wh3_prologue_objective_turn_001_08" or prologue_current_objective == "wh3_prologue_objective_turn_001_09" or prologue_current_objective == "wh3_prologue_objective_turn_001_03" then
				PrologueRemoveObjective()
			end			
		end
	end,
	true
)


core:add_listener(
	"hide_recruitment_cards",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "units_recruitment" 
	end,
	function()
		for unit, value in pairs(prologue_regiments_of_renown) do	
			
			local unit_card = find_uicomponent(core:get_ui_root(), unit);

			if value == false and unit_card then
				out("Setting "..unit.." panel visibility to : "..tostring(value));
				unit_card:SetVisible(false);
			elseif value and unit_card then
				out("Setting "..unit.." panel visibility to : "..tostring(value));
				unit_card:SetVisible(true);
			end
		end
	end,
	true
);

if prologue_check_progression["first_demon_combat"] == false then
	core:add_listener(
		"CharacterCompletedBattleFirstDaemonCombat",
		"CharacterCompletedBattle",
		function(context) 
			if prologue_check_progression["open_world"] == false or prologue_check_progression["first_demon_combat"] then
				return false
			end

			if context:pending_battle():attacker():faction():subculture() == "wh3_main_pro_sc_kho_khorne" or 
			context:pending_battle():attacker():faction():subculture() == "wh3_main_pro_sc_tze_tzeentch" or
			context:pending_battle():defender():faction():subculture() == "wh3_main_pro_sc_kho_khorne" or 
			context:pending_battle():defender():faction():subculture() == "wh3_main_pro_sc_tze_tzeentch" 
			then 
				return true 
			end
		end,
		function()
			prologue_check_progression["first_demon_combat"] = true
		end,
		false
	)
end

-- Set Public Order to 0 each turn.

core:add_listener(
		"FactionTurnStartSetPublicOrder",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function()
			local region_list = cm:model():world():region_manager():region_list()
			for i = 0, region_list:num_items() - 1 do cm:set_public_order_of_province_for_region(region_list:item_at(i):name(), 0) end
		end,
		true
	);

-- Hides the attack button highlight so it doesn't get stuck on load screen.
core:add_listener(
	"ComponentLClickUpAttackButtonHideHighlight",
	"ComponentLClickUp",
	function(context) return context.string == "button_attack" end,
	function() highlight_component(false, true, "popup_pre_battle", "button_set_attack", "button_attack");end,
	false
)

-- Update CQI variable if Yuri is re-recruited
core:add_listener(
	"MilitaryForceCreatedTest",
	"MilitaryForceCreated",
	function(context) if prologue_yuri_dead and context:military_force_created():general_character():is_faction_leader() and context:military_force_created():general_character():faction():name() == prologue_player_faction then return true end end,
	function(context) prologue_player_cqi = context:military_force_created():general_character():command_queue_index() end,
	true
)

if prologue_check_progression["st_quest_battle_enemy_stronger"] == false then
	core:add_listener(
		"PanelOpenedCampaignQuestBattleEnemyStronger",
		"PanelOpenedCampaign",
		function(context) if prologue_check_progression["st_quest_battle_enemy_stronger"] == false and context.string == "popup_pre_battle" then return true end end,
		function()
			if common.get_context_value("CampaignBattleContext.IsQuestBattle") and cm:model():world():faction_by_key(prologue_player_faction):faction_leader():military_force():unit_list():num_items() < 14 then
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					core:trigger_event("ScriptEventQuestBattleEnemyStronger")
				else
					prologue_check_progression["st_quest_battle_enemy_stronger"] = true;
				end
			end
		end,
		true
	)
end

core:add_listener(
	"CharacterSelectedWizard",
	"CharacterSelected",
	true,
	function(context)
		if not context:character():character_type("general") and context:character():faction():name() == prologue_player_faction then
			agent_selected = true
		else
			agent_selected = false
		end

		local uic_unit_info_panel_tze = find_uicomponent(core:get_ui_root(), "unit_info_panel_holder_parent", "unit_information", "agent_panel_visibility_parent", "agent_details", "action_list", "wh3_main_agent_action_dignitary_passive_spread_corruption_tze");
		if uic_unit_info_panel_tze then
			uic_unit_info_panel_tze:SetVisible(false);
		end

		local uic_unit_info_panel_kho = find_uicomponent(core:get_ui_root(), "unit_info_panel_holder_parent", "unit_information", "agent_panel_visibility_parent", "agent_details", "action_list", "wh3_main_agent_action_dignitary_passive_spread_corruption_kho");
		if uic_unit_info_panel_kho then
			uic_unit_info_panel_kho:SetVisible(false);
		end
	end,
	true
)

core:add_listener(
	"PanelOpenedCampaignAutoResolveIntervention",
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_pre_battle" end,
	function()
		skip_all_scripted_tours();
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") == false and prologue_check_progression["open_world"] and prologue_check_progression["fought_first_open_battle"] == false then
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				core:trigger_event("ScriptEventPrologueAutoresolve")
			else
				prologue_check_progression["fought_first_open_battle"] = true;
			end	
		end
	end,
	true
)

if prologue_check_progression["pre_battle_first_siege"] == false then
	-- This waits for the player's first siege battle and begins the associated intervention to teach them the basics.
	core:add_listener(
		"CharacterBesiegesSettlementFirstSiegeIntervention",
		"CharacterBesiegesSettlement",
		function () return prologue_check_progression["open_world"] end,
		function () 
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				core:trigger_event("ScriptEventPrologueFirstSiege") 
			else
				prologue_check_progression["pre_battle_first_siege_without_equipment"] = true;
				prologue_check_progression["pre_battle_first_siege"] = true;
			end
		end,
		true
	)
end

-- Setting the "i" button on the diplomacy screen to topmost. Sometimes it can draw below the dialogue box and can't be clicked.
do
	core:add_listener(
		"PanelOpenedCampaignDiplomacySetiTopMost",
		"PanelOpenedCampaign",
		function(context) return context.string == "diplomacy_dropdown" end,
		function()
			local uic = find_uicomponent(core:get_ui_root(), "offers_panel", "button_info")
			uic:RegisterTopMost()
		end,
		true
	)

	core:add_listener(
		"PanelClosedCampaignDiplomacySetiTopMost",
		"PanelClosedCampaign",
		function(context) return context.string == "diplomacy_dropdown" end,
		function()
			local uic = find_uicomponent(core:get_ui_root(), "offers_panel", "button_info")
			uic:RemoveTopMost()
		end,
		true
	)
end

--------------------------------------------------------------
--------------- Panel Related Functions/Listeners ------------
--------------------------------------------------------------

do
	local panels_open = {}

	local function InsertOpenPanel(panel_string)
		for key, value in pairs(panels_open) do
			if value == panel_string then 
				return false
			end
		end
		table.insert(panels_open, 1, panel_string)
	end
	
	function AddPanelCallbacks(open_function, close_function, event_to_remove_callbacks, listener_names, context_panel_string, call_close_function_if_context_panel_hidden, callback_when_listeners_removed)
		-- This function adds calls functions whenever a panel opens or closes. The close function can be called instantly while a specific panel is hidden.

		listener_names = listener_names or "PanelCallback"
		context_panel_string = context_panel_string or ""
		call_close_function_if_context_panel_hidden = call_close_function_if_context_panel_hidden or false
		callback_when_listeners_removed = callback_when_listeners_removed or false
		local panel_up = false

		for key, value in pairs(panels_open) do
			if value == context_panel_string then panel_up = true end
		end

		if panel_up == false and call_close_function_if_context_panel_hidden == true then close_function() end

		core:add_listener(
			"PanelOpenedCampaign"..listener_names,
			"PanelOpenedCampaign",
			function(context)
				InsertOpenPanel(context.string)

				if context_panel_string == "" then 
					return true
				else
					return context.string == context_panel_string
				end
			end,
			function() if open_function then open_function() end end,
			true
		)

		core:add_listener(
			"PanelClosedCampaign"..listener_names,
			"PanelClosedCampaign",
			function(context) 				
				if context_panel_string == "" then 
					return true
				else
					return context.string == context_panel_string
				end
			end,
			function() if close_function then close_function() end end,
			true
		)

		core:add_listener(
			event_to_remove_callbacks..listener_names,
			event_to_remove_callbacks,
			true,
			function() if callback_when_listeners_removed then callback_when_listeners_removed() end; core:remove_listener("PanelOpenedCampaign"..listener_names); core:remove_listener("PanelClosedCampaign"..listener_names) end,
			true
		)
	end

	-- This is a highlight end turn button of the function. It will hide the end turn highlight whenever a panel is up, unless an exlcusion is added.
	function HighlightEndTurnButton()
		AddPanelCallbacks(
			function() highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn") end, 
			function() highlight_component(true, false, "hud_campaign", "faction_buttons_docker", "button_end_turn") end, 
			"FactionTurnEnd", 
			"HighlightEndTurn",
			"character_details_panel",
			true,
			function() highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn") end
		)
	end

	core:add_listener(
		"PanelOpenedCampaignAnyPanel",
		"PanelOpenedCampaign",
		true,
		function(context) InsertOpenPanel(context.string) end,
		true
	)

	core:add_listener(
		"PanelClosedCampaignAnyPanel",
		"PanelClosedCampaign",
		true,
		function(context) 
			for key, value in pairs(panels_open) do
				if value == context.string then 
					table.remove(panels_open, key);
				end
			end;
		end,
		true
	)

end

--------------------------------------------------------------
--------- Mission Related Functions/Listeners ---------
--------------------------------------------------------------
if prologue_check_progression["triggered_fear_dilemma"] == false then
	core:add_listener(
		"MissionSucceededTrialsCounter",
		"MissionSucceeded",
		function(context) 
			if context:mission():mission_record_key() == "wh3_prologue_mission_defeat_n_armies_of_faction_tze" or 
			context:mission():mission_record_key() == "wh3_prologue_mission_capture_regions_mansion_of_eyes" or 
			context:mission():mission_record_key() == "wh3_prologue_trial_of_war_monger" or 
			context:mission():mission_record_key() == "wh3_prologue_eliminate_khorne_leader" or 
			context:mission():mission_record_key() == "wh3_prologue_ice_maiden_actions" or 
			context:mission():mission_record_key() == "wh3_prologue_mission_make_alliance" or 
			context:mission():mission_record_key() == "wh3_prologue_raid_region" or 
			context:mission():mission_record_key() == "wh3_prologue_mission_building_level" or 
			context:mission():mission_record_key() == "wh3_prologue_mission_patriarch_actions" 
			then return true end
		end,
		function() 
			prologue_trials_completed = prologue_trials_completed + 1
			if prologue_trials_completed >= 7 and prologue_check_progression["triggered_fear_dilemma"] == false then 
				PrologueFearMeDilemma(); 
				core:remove_listener("MissionSucceededTrialsCounter") 
				uim:override("end_turn"):set_allowed(false);
			end
		end,
		
		true
	)
end

core:add_listener(
	"MissionSucceededRewards",
	"MissionSucceeded",
	true,
	function(context)
		local mission_complete = false
		out(context:mission():mission_record_key())
		local unlock_function_key
		if context:mission():mission_record_key() == "wh3_prologue_mission_reveal" then 
			mission_complete = true
			unlock_function_key = "wh3_main_pro_ksl_mon_elemental_bear_ror_0_recruitable"
		elseif context:mission():mission_record_key() == "wh3_prologue_mission_make_alliance" then 
			mission_complete = true
			unlock_function_key = "wh3_main_pro_ksl_veh_heavy_war_sled_ror_0_recruitable"
		elseif context:mission():mission_record_key() == "wh3_prologue_ice_maiden_actions" then 
			mission_complete = true
			unlock_function_key = "wh3_main_pro_ksl_inf_ice_guard_ror_1_recruitable"
		elseif context:mission():mission_record_key() == "wh3_prologue_mission_building_level" then 
			mission_complete = true
			unlock_function_key = "wh3_main_pro_ksl_cav_gryphon_legion_ror_0_recruitable"
		elseif context:mission():mission_record_key() == "wh3_prologue_mission_capture_regions_mansion_of_eyes" then 
			mission_complete = true
			unlock_function_key = "wh3_main_pro_ksl_inf_ice_guard_ror_0_recruitable"
		end
		
		-- This is commented out because we don't want the Patriarch to unlock directly when the quest is finished, but instead after the dialogue chain that fires after it.
		--elseif context:mission():mission_record_key() == "wh3_prologue_mission_riddles" then 
		--	unlock_function_key = "Patriarch"
		--end
		
		if mission_complete then
			core:add_listener(
				"PanelClosedCampaignMissionReward",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function() 
					if unlock_function_key == "Patriarch" then 
						UnlockPatriarch() 
					else 
						PrologueUnlockRoR(unlock_function_key) 
					end 
				end,
				false
			)
		end

		core:add_listener(
			"PanelClosedCampaignMissionPanelClosed",
			"PanelClosedCampaign",
			function(context) return context.string == "events" end,
			function() 
				prologue_mission_complete = false;
			end,
			true
		);

		prologue_mission_complete = true;
	end,
	true
);

core:add_listener(
	"PositiveDiplomaticEventMilitaryAllianceQuest",
	"PositiveDiplomaticEvent",
	function(context) if context:proposer():name() == prologue_player_faction and prologue_tutorial_passed["diplomacy_with_button_hidden"] and context:is_military_alliance()
		or context:recipient():name() == prologue_player_faction and prologue_tutorial_passed["diplomacy_with_button_hidden"] and context:is_military_alliance() then return true else return false end end,
	function()
	prologue_mission_make_alliance:force_scripted_objective_success("prologue_mission_make_alliance")	
	end,
	false
);

if not prologue_check_progression["completed_ice_maiden_mission"] then
	
	local function CompleteIceMaidenMission()
		if prologue_check_progression["triggered_ice_maiden_mission"] then
			
			core:remove_listener("CharacterCharacterTargetActionIceMaidenArmy")
			core:remove_listener("CharacterCharacterTargetActionIceMaidenAgent")
			core:remove_listener("CharacterGarrisonTargetActionIceMaidenGarrison")

			prologue_mission_ice_maiden_actions:force_scripted_objective_success("mission_ice_maiden_actions")
			prologue_check_progression["completed_ice_maiden_mission"] = true
	
		end
	end

	core:add_listener(
		"CharacterCharacterTargetActionIceMaidenArmy",
		"CharacterCharacterTargetAction", 
		function (context)
			if context:character():character_subtype_key() == "wh3_main_pro_ksl_frost_maiden_ice" and context:target_character():character_type_key() == "general" and context:target_character():faction():name() ~= prologue_player_faction then
				return true
			end
		end,
		function()
			CompleteIceMaidenMission()
		end,
		true
	);

	core:add_listener(
		"CharacterCharacterTargetActionIceMaidenAgent",
		"CharacterCharacterTargetAction", 
		function (context)
			if context:character():character_subtype_key() == "wh3_main_pro_ksl_frost_maiden_ice" and context:target_character():character_type_key() ~= "general" and not context:target_character():faction():name() ~= prologue_player_faction then
				return true
			end
		end,
		function()
			CompleteIceMaidenMission()
		end,
		true
	);

	core:add_listener(
		"CharacterGarrisonTargetActionIceMaidenGarrison",
		"CharacterGarrisonTargetAction", 
		function (context)
			if context:character():character_subtype_key() == "wh3_main_pro_ksl_frost_maiden_ice" then
				return true
			end
		end,
		function()
			CompleteIceMaidenMission()
		end,
		true
	);

end

if not prologue_check_progression["completed_patriarch_mission"] then

	core:add_listener(
		"CharacterCharacterTargetActionPatriarch",
		"CharacterCharacterTargetAction", 
		function (context)
			if context:character():character_subtype_key() == "wh3_main_pro_ksl_patriarch" and context:target_character():character_type_key() ~= "general" 
			and context:target_character():faction():name() ~= prologue_player_faction and prologue_check_progression["triggered_patriarch_mission"] then
				if context:mission_result_success() or context:mission_result_critial_success() then 
					return true
				else
					return false
				end
			end
		end,
		function()
			prologue_mission_patriarch_actions:force_scripted_objective_success("mission_patriarch_actions")
			prologue_check_progression["completed_patriarch_mission"] = true
		end,
		false
	);

end

core:add_listener(
	"BuildingCompletedQuest",
	"BuildingCompleted",
	function(context) if context:building():building_level() == 5 and context:garrison_residence():settlement_interface():faction():is_human() and context:building():slot():type() == "primary" then return true else return false end end,
	function() prologue_mission_building_level:force_scripted_objective_success("prologue_mission_building_level") end,
	false
);

core:add_listener(
	"CharacterCompletedBattleDestroyEnemyArmy",
	"CharacterCompletedBattle",
	function(context) return context:character():faction():name() ~= prologue_player_faction and context:character():character_type_key() == "general" and context:character():won_battle() == false and prologue_check_progression["open_world"] end,
	function(context)
		local character_cqi = context:character():command_queue_index()
		
		core:add_listener(
			"PanelClosedCampaignDestroyEnemyArmy",
			"PanelClosedCampaign",
			function(context) return context.string == "popup_battle_results" end,
			function() cm:kill_character(character_cqi, true) end,
			false
		)
	end,
	true
)

core:add_listener(
	"SettlementSelectedHideProvinceInfoPanel",
	"SettlementSelected",
	true,
	function(context)
		if context:garrison_residence():faction():name() == prologue_player_faction then
			if prologue_tutorial_passed["province_info_panel"] then
				uim:override("province_info_panel"):set_allowed(true)
			else
				uim:override("province_info_panel"):set_allowed(false)
			end
		else
			uim:override("province_info_panel"):set_allowed(false)
		end
	end,
	true
)

core:add_listener(
	"ComponentLClickUpMainMenuLoadingScreen",
	"ComponentLClickUp",
	function(context) return context.string == "button_quit" end,
	function() common.setup_dynamic_loading_screen("prologue_intro", "prologue") end,
	false
)

--------------------------------------------------------------
--------- Saving/Loading Related Functions/Listeners ---------
--------------------------------------------------------------

if not prologue_check_progression["first_load"] then
prologue_check_progression["first_load"] = true
cm:disable_saving_game(true)
end

-- This prints out whenever saving is enabled. Active it during scripted segents to see if there's any place the player can save
-- where we don't want them to.
--[[
function output_save_button_state()
	cm:callback(
	function ()
		if common.get_context_value("CcoCampaignRoot", "", "CanQuickSave") then
			out("++++++++++++++++++++++++++++++++++++++++++++++++++++++++CAN SAVE++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
		end
		output_save_button_state()
	end, 0.5
	)
end
output_save_button_state()
--]]

do
	local wait_for_accept_active = false
	local prologue_vo_playing = false
	local accept_button_highlighted = false
	local block_event_save_disable = false

	-- This function is used with the listener below. Combined, they block saving while a panel with an accept button appears. (Since these are often part of a long sequence of scripted logic.)
	function WaitForAccept(uic_button_accept)
		if not wait_for_accept_active then
			cm:disable_saving_game(true)
			cm:release_escape_key_with_callback("missions_review")
			local esc_menu_active = false
			wait_for_accept_active = true

			uic_button_accept:Highlight(false, false)

			local function HighlightAcceptAfterDialogue()
				cm:repeat_callback(
					function()
						if dialogue_in_progress == false and prologue_vo_playing == false then
							if accept_button_highlighted == false then
								if uic_button_accept and uic_button_accept:Visible(true) then uic_button_accept:Highlight(true, false) end
								accept_button_highlighted = true
							end
						else
							if accept_button_highlighted == true then
								if uic_button_accept and uic_button_accept:Visible(true) then uic_button_accept:Highlight(false, false) end
								accept_button_highlighted = false
							end
						end
					end,
					0.1,
					"HighlightAcceptAfterDialogue"
				)
			end
			if prologue_check_progression["open_world"] then
				cm:callback(function () HighlightAcceptAfterDialogue() end, 2.5)
			else
				HighlightAcceptAfterDialogue()
			end

			core:add_listener(
				"ComponentLClickUp_button_accept_Saving",
				"ComponentLClickUp",
				function(context) return context.string == "button_accept" end,
				function() EndWaitForAccept() end,
				false
			);

			core:add_listener(
				"FactionTurnEnd_button_accept_saving",
				"FactionTurnEnd",
				function(context) return context:faction():is_human() end,
				function() EndWaitForAccept() end,
				false
			);

			core:add_listener(
				"PanelOpenedCampaignEscStopSaving",
				"PanelOpenedCampaign",
				function(context) return context.string == "esc_menu" end,
				function() esc_menu_active = true; cm:disable_saving_game(true) end,
				true
			);

			core:add_listener(
				"PanelClosedCampaignAllowSaving",
				"PanelClosedCampaign",
				function(context) cm:callback(function() return context.string == "events" and esc_menu_active == false end, 0.2) end,
				function() EndWaitForAccept() end,
				false
			);

			cm:steal_escape_key_with_callback("events_accept", function () uic_button_accept:SimulateLClick(); EndWaitForAccept() end)
		end 
	end

	function EndWaitForAccept ()
		if dialogue_in_progress == false and prologue_dialogue_about_to_start == false and block_event_save_disable == false then
			cm:disable_saving_game(false)
		end
		
		cm:release_escape_key_with_callback("events_accept")
		core:remove_listener("ComponentLClickUp_button_accept_Saving")
		core:remove_listener("PanelClosedCampaignAllowSaving")
		core:remove_listener("FactionTurnEnd_button_accept_saving"); 
		core:remove_listener("PanelOpenedCampaignEscStopSaving")
		cm:remove_callback("HighlightAcceptAfterDialogue")
		wait_for_accept_active = false
		accept_button_highlighted = false
	end

	-- This function will stop saving from being re-enabled when an event panel is dismissed. If called, it must be turned off again.
	function BlockEventSaveEnable(value)
		block_event_save_disable = value
	end

	-- This function forces saving to remain enabled or disabled. Any calls from other functions will be overwritten by this. Use this sparingly and ensure to call StopForceSavingState when done.
	function ForceSavingState(saving_enabled)
		-- Remove existing force save listener.
		cm:remove_callback("ForceSaveStateRepeatCallback")

		if saving_enabled then -- Force saving to stay enabled.
			cm:repeat_callback(
				function()	
					if not common.get_context_value("CcoCampaignRoot", "", "CanQuickSave") then
						cm:disable_saving_game(false)
					end
				end,
				0.1,
				"ForceSaveStateRepeatCallback"
			)
		else -- Force saving to be disabled.
			cm:repeat_callback(
				function()	
					if common.get_context_value("CcoCampaignRoot", "", "CanQuickSave") then
						cm:disable_saving_game(true)
					end
				end,
				0.1,
				"ForceSaveStateRepeatCallback"
			)
		end
	end

	function StopForceSavingState()
		-- Remove existing force save listener.
		cm:remove_callback("ForceSaveStateRepeatCallback")
	end

	core:add_listener(
		"PanelOpenedCampaign_events_Saving",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "events" end,
		function()
			cm:callback(
				function()
					-- Accept button for missions being issued.
					local uic_button_found = find_uicomponent(core:get_ui_root(), "events", "button_set", "accept_holder", "button_accept")
					if uic_button_found and uic_button_found:Visible(true) then
						WaitForAccept(uic_button_found)
						return
					end
					
					-- Accept button for missions being completed.
					local uic_button_found = find_uicomponent(core:get_ui_root(), "events", "event_layouts", "mission_active", "mission_complete", "footer", "button_accept")
					if uic_button_found and uic_button_found:Visible(true) then
						WaitForAccept(uic_button_found)
						return
					end
				end,
				0.1
			)
		end,
		true
	);

	-- These listeners wait for VO triggered with trigger_campaign_vo_prologue() to start and end.
	core:add_listener(
		"ScriptTriggeredVOFinishedPrologueVO",
		"ScriptTriggeredVOFinished",
		true,
		function()
			prologue_vo_playing = false
		end,
		true
	)

	core:add_listener(
		"ScriptTriggeredVOStartingProloguePrologueVO",
		"ScriptTriggeredVOStartingPrologue",
		true,
		function()
			prologue_vo_playing = true
		end,
		true
	)
end


---------------------------------------------------------------
--	Work out what configuration load scripts in
---------------------------------------------------------------
cm:load_local_faction_script("_audio");
cm:load_local_faction_script("_advice");
cm:load_local_faction_script("_interventions");
cm:load_local_faction_script("_scripted_tours");
cm:load_local_faction_script("_story_panels");
cm:load_local_faction_script("_traits")
cm:load_local_faction_script("_followers")
cm:load_local_faction_script("_magic_items")
cm:load_local_faction_script("_achievements")

cm:add_linear_sequence_configuration(
	"intro_campaign",							-- script name, must be unique and have no spaces
	"_stage_1",									-- script to load if this loading config selected
	"sbool_load_intro_campaign",				-- svr boolean that can force this loading config (will be set to false if successful)
	true,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_51"					-- tweaker to force this loading config
);

cm:add_linear_sequence_configuration(
	"post_intro_campaign",						-- script name, must be unique and have no spaces
	"_stage_2",								-- script to load if this loading config selected
	"sbool_load_post_intro_campaign",			-- svr boolean that can force this loading config (will be set to false if successful)
	false,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_52"					-- tweaker to force this loading config
);

cm:add_linear_sequence_configuration(
	"open_campaign",							-- script name, must be unique and have no spaces
	"_stage_3",									-- script to load if this loading config selected
	"sbool_load_open_campaign",					-- svr boolean that can force this loading config (will be set to false if successful)
	false,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_53"					-- tweaker to force this loading config
);

cm:add_linear_sequence_configuration(
	"post_open_campaign",							-- script name, must be unique and have no spaces
	"_stage_4",									-- script to load if this loading config selected
	"sbool_load_post_open_campaign",					-- svr boolean that can force this loading config (will be set to false if successful)
	false,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_54"					-- tweaker to force this loading config
);

cm:add_linear_sequence_configuration(
	"tzeentch_campaign",							-- script name, must be unique and have no spaces
	"_stage_5",									-- script to load if this loading config selected
	"sbool_load_tzeentch_campaign",					-- svr boolean that can force this loading config (will be set to false if successful)
	false,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_55"					-- tweaker to force this loading config
);

cm:add_linear_sequence_configuration(
	"khorne_campaign",							-- script name, must be unique and have no spaces
	"_stage_6",									-- script to load if this loading config selected
	"sbool_load_khorne_campaign",					-- svr boolean that can force this loading config (will be set to false if successful)
	false,										-- load this config if no other config forced
	"SCRIPTED_TWEAKER_56"					-- tweaker to force this loading config
);

cm:load_linear_sequence_configuration();

