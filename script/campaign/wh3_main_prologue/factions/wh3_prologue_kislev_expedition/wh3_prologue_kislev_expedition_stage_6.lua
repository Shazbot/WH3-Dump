PrologueInitialDisabling();

CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_outpostnorsca_major");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_outpostnorsca_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_growth");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_major");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_barracks");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_stables");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_sleds");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_timber");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_attack");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_armour");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_ammunition");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_ice_enclave");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_building_second_growth");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_special_dervingard");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_royal_guards");

local prologue_completed_battle = false;
local prologue_last_battle_quest_battle = false

--Make sure Concede button is available in battle
core:svr_save_string("can_concede", tostring(1));

cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_5");
cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_4");
cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_the_brazen_lands");

if prologue_check_progression["stage_6_area_triggers"] == false then
	cm:add_circle_area_trigger(297, 359, 10, "screaming_chasm_1", "", true, false, false);
	cm:add_circle_area_trigger(247, 350, 10, "screaming_chasm_2", "", true, false, false);
	cm:add_circle_area_trigger(292, 335, 5, "altar_exit_1", "", true, false, false);
	cm:add_circle_area_trigger(269, 336, 5, "altar_exit_2", "", true, false, false);
	cm:add_circle_area_trigger(275, 316, 5, "altar_exit_3", "", true, false, false);
	cm:add_circle_area_trigger(288, 318, 5, "altar_exit_4", "", true, false, false);
	
	prologue_check_progression["stage_6_area_triggers"] = true
end

if prologue_check_progression["triggered_screaming_chasm_objective"] and prologue_check_progression["completed_screaming_chasm_objective"] == false then
	cm:set_objective_with_leader("wh3_prologue_objective_screaming_chasm")
end

if prologue_check_progression["brazen_altar_battle_complete"] == false then
	core:add_listener(
		"prologue_battle_completed",
		"CharacterCompletedBattle",
		true,
		function()
			out("**** BattleCompleted event received ****");

			out("MADE IT TO STAGE 6")

			uim:override("disable_help_pages_panel_button"):set_allowed(false);

			-- Mark victory condition
			cm:complete_scripted_mission_objective("wh3_prologue_kislev_expedition", "wh_main_long_victory", "complete_brazen_altar", true)

			local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
			cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_3");
			cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_3");
			
			prologue_last_battle_quest_battle = true

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(102, "brazen_altar_quest_battle_won", false);

			cm:contextual_vo_enabled(false);

			prologue_check_progression["brazen_altar_battle_complete"] = true;

			--clear the prebattle camera
			cm:clear_prebattle_display_configuration_override();

			if prologue_next_quote < 10 then
				prologue_next_quote = prologue_next_quote - 2;
			end

			core:add_listener(
				"PanelOpenedCampaignRevealMissionComplete",
				"PanelOpenedCampaign",
				function(context) return context.string == "events" end,
				function()
					cm:callback(
						function()
							local uic_mission_complete = find_uicomponent("events", "event_layouts", "mission_active", "mission_complete")
							if uic_mission_complete then
								local context = uic_mission_complete:GetContextObject("CcoCampaignMission")
								if context and context:Call("MissionRecordContext.Key") == "wh3_prologue_mission_reveal" then
									prologue_advice_mission_complete_brazen_altar()
									core:remove_listener("PanelOpenedCampaignRevealMissionComplete")
								end
							end
						end,
						0.001
					)
				end,
				true
			)

			-- Teaches about movement speed hotkey.
			AddIncreaseYuriSpeedListener()
		end,
		false
	);
end

core:add_listener(
	"prologue_battle_completed_stage_6",
	"CharacterCompletedBattle",
	true,
	function()
		out("**** BattleCompleted event received ****");

		prologue_completed_battle = true;
		
	end,
	true
);


core:add_listener(
	"AreaEntered_Prologue_stage_6",
	"AreaEntered", 
	true,
	function(context)
		local character = context:family_member():character();
		if character:is_null_interface() then
			return;
		end;

		if character:cqi() == prologue_player_cqi then
			if context:area_key() == "screaming_chasm_1" or context:area_key() == "screaming_chasm_2" then

				if cm:model():is_player_turn() then
					prologue_advice_reveal_screaming_chasm_001();
					cm:remove_area_trigger("screaming_chasm_1");
					cm:remove_area_trigger("screaming_chasm_2");
					--Metric check (step_number, step_name, skippable)
					cm:trigger_prologue_step_metrics_hit(107, "close_to_howling_citadel", false);
				end

			end

			if context:area_key() == "altar_exit_1" or context:area_key() == "altar_exit_2" or context:area_key() == "altar_exit_3" or context:area_key() == "altar_exit_4" then
				if cm:model():is_player_turn() then
					cm:remove_area_trigger("altar_exit_1");
					cm:remove_area_trigger("altar_exit_2");
					cm:remove_area_trigger("altar_exit_3");
					cm:remove_area_trigger("altar_exit_4");

					prologue_advice_my_brother_001();
				end
			end


			if context:area_key() == "kill_gerik" and prologue_check_progression["killed_gerik"] == false then
				
				if cm:model():is_player_turn() then
					skip_all_scripted_tours();
					cm:remove_scripted_composite_scene("kill_gerik_marker")
					cm:remove_area_trigger("kill_gerik")
					cm:toggle_dilemma_generation(false);
					cm:disable_saving_game(true)
					cm:contextual_vo_enabled(false);	

					-- Removing objective directing player to Screaming Chasm.
					prologue_check_progression["completed_screaming_chasm_objective"] = true
					cm:remove_objective("wh3_prologue_objective_screaming_chasm")

					local cutscene_intro = campaign_cutscene:new_from_cindyscene(
						"prologue_howling_citadel",
						function() 
							cm:disable_saving_game(false)
							PrologueDaemonDilemma();
						end,
						"bloodthirster_reveal",
						0, 
						1
					);
						
					cutscene_intro:set_disable_settlement_labels(true);
					cutscene_intro:set_dismiss_advice_on_end(false);
					cutscene_intro:set_restore_shroud(false);
					cutscene_intro:set_skippable(true);
							
					cutscene_intro:action(
						function()
							cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
							cm:trigger_2d_ui_sound("Play_Movie_WH3_Prologue_Campaign_Bloodthirster_Intro_Sweetener_01", 0);
							CampaignUI.ClearSelection();
						end,
						0
					);

					uim:override("campaign_flags"):set_allowed(false);

					cutscene_intro:start(); 

					
					-- Stop Yuri from moving. This must happen before disabling campaign flags.
					--[[cm:move_character(
						character:cqi(), 
						character:logical_position_x(), 
						character:logical_position_y()
					)]]

					cm:teleport_to(cm:char_lookup_str(character:cqi()), character:logical_position_x(), character:logical_position_y());
				end
				
			end
		end
		
	end,
	true
);

core:add_listener(
	"ComponentLClickUpSetLoadingScreen",
	"ComponentLClickUp",
	function(context) return context.string == "button_attack" end,
	function()
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
			common.setup_dynamic_loading_screen("prologue_battle_howling_citadel_intro", "prologue")
			PrologueSetLoadingScreenQuote();
		else
			PrologueSetLoadingScreenQuote();
		end
	end,
	true
)

core:add_listener(
	"PanelOpenedCampaign_pre_battle_screen_stage_6",
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_pre_battle" end,
	function()
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") then

			local ai_control = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "commander_header_1", "checkbox_delegate_to_ai");
			if ai_control then
				ai_control:SetVisible(false);
			end

			AllowPreBattleUI(false)

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(108, "initiated_howling_citadel_quest_battle", false);

			PrologueSetPreBattleScreen("howling_citadel_title");

			local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
			local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
			if title_bar_holder then
				title_bar_holder:SetVisible(true);
			end
			if title_bar then
				title_bar:SetVisible(true);
			end

			prologue_advice_howling_citadel_pre_battle_001();

			cm:set_prebattle_display_configuration_override(5.735127,10.247639,0.0,0.5,-3.0);--distance,height,angle,scale,separation
		else
			AllowPreBattleUI(true)
			cm:clear_prebattle_display_configuration_override();
			local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
			if title_bar then
				title_bar:SetVisible(false);
			end
		end
	end,
	true
);

core:add_listener(
	"post_battle_panel_opened",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "popup_battle_results" 
	end,
	function()
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
			cm:set_prebattle_display_configuration_override(5.735127,10.247639,0.0,0.5,-3.0);--distance,height,angle,scale,separation
		else
			cm:clear_prebattle_display_configuration_override();
		end
	end,
	true
);


core:add_listener(
	"LoadingScreenDismissed_Prologue_intro_post",
	"LoadingScreenDismissed",
	true,
	function()
		if prologue_completed_battle == false then
			if prologue_current_objective ~= "" then
				cm:set_objective(prologue_current_objective);
			end
		else
			prologue_completed_battle = false;
		end	

		if not prologue_last_battle_quest_battle then
			-- Add Yuri movement speed objective.
			AddIncreaseYuriSpeedListener(true)
		end
		
		if prologue_check_progression["brazen_altar_battle_complete"] == true and prologue_check_progression["killed_gerik"] == false then
			
			local found_retribution_mission = false;
			local reveal_mission_active = false;

			for i = 0, common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "ActiveMissionList.Size") - 1 do
				if common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "ActiveMissionList.At("..i..").MissionRecordContext.Key") == "wh3_prologue_mission_retribution" then
					found_retribution_mission = true;
				end

				if common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "ActiveMissionList.At("..i..").MissionRecordContext.Key") == "wh3_prologue_mission_reveal" then
					reveal_mission_active = true;
				end
			end

			if found_retribution_mission == false and reveal_mission_active == false then
				prologue_advice_trigger_retribution();
			end

		end

	end,
	false
);