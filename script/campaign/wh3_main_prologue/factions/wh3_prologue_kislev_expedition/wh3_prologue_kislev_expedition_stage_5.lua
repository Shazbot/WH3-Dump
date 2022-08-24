out("IN STAGE 5")

PrologueInitialDisabling();

if prologue_check_progression["triggered_diplomacy"] == false then
	cm:cai_disable_movement_for_faction("wh3_prologue_the_tahmaks");
	cm:cai_disable_movement_for_faction("wh3_prologue_the_kvelligs");
	cm:cai_disable_movement_for_faction("wh3_prologue_great_eagle_tribe");
	cm:cai_disable_movement_for_faction("wh3_prologue_tong");
	cm:cai_disable_movement_for_faction("wh3_prologue_blood_keepers");
	cm:cai_disable_movement_for_faction("wh3_prologue_sarthoraels_watchers");	
end

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

cm:disable_pathfinding_restriction(6);

cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_5");
cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_4");
cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_the_brazen_lands");

--Make sure Concede button is available in battle
core:svr_save_string("can_concede", tostring(1));


if prologue_check_progression["stage_5_area_triggers"] == false then
	cm:add_circle_area_trigger(282, 324, 15, "brazen_altar", "", true, false, false)

	cm:add_circle_area_trigger(231, 275, 10, "norsca_1_diplomacy", "", true, false, false);
	cm:add_circle_area_trigger(258, 290, 10, "norsca_2_diplomacy", "", true, false, false);
	cm:add_circle_area_trigger(303, 287, 10, "norsca_3_diplomacy", "", true, false, false);

	prologue_check_progression["stage_5_area_triggers"] = true
end

if prologue_check_progression["lucent_maze_complete"] == false then
	core:add_listener(
		"prologue_battle_completed",
		"CharacterCompletedBattle",
		true,
		function()
			out("**** BattleCompleted event received ****");

			out("MADE IT TO STAGE 5")

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(93, "lucent_maze_quest_battle_won", false);

			-- Mark victory condition
			cm:complete_scripted_mission_objective("wh3_prologue_kislev_expedition", "wh_main_long_victory", "complete_lucent_maze", true)

			local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
			--cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_3");
			cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_2");

			prologue_check_progression["lucent_maze_complete"] = true;

			--clear the prebattle camera
			cm:clear_prebattle_display_configuration_override();

			if prologue_next_quote < 10 then
				prologue_next_quote = prologue_next_quote - 2;
			end

			prologue_last_battle_quest_battle = true

			-- unlock autoresolve and retreat buttons
			uim:override("pre_battle_autoresolve_with_button_hidden"):set_allowed(true);
			prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = true;
			uim:override("pre_battle_retreat_with_button_hidden"):set_allowed(true);
			prologue_tutorial_passed["pre_battle_retreat_with_button_hidden"] = true;

			-- Teaches about movement speed hotkey.
			AddIncreaseYuriSpeedListener()	
		end,
		false
	);
else
	out("BATTLE IS TRUE")
end

core:add_listener(
	"prologue_battle_completed_stage_5",
	"CharacterCompletedBattle",
	true,
	function()
		out("**** BattleCompleted event received ****");

		prologue_completed_battle = true;
		
	end,
	true
);

core:add_listener(
	"autoresolve_button_listener_intro",
	"ComponentLClickUp",
	function(context) return context.string == "dev_button_win_battle" end,
	function()
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
			out("STARTING AUTORESOLVE LISTENER")
			core:svr_save_bool("sbool_load_khorne_campaign", true) --sbool_load_post_open_campaign
			cm:load_local_faction_script("_stage_6", true);
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
			common.setup_dynamic_loading_screen("prologue_battle_brazen_altar_intro", "prologue")
			PrologueSetLoadingScreenQuote();
		else
			PrologueSetLoadingScreenQuote();
		end
	end,
	true
)

do
	local advice_played = false
	core:add_listener(
		"PanelOpenedCampaign_pre_battle_screen_stage_5",
		"PanelOpenedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
				
				AllowPreBattleUI(false)

				if advice_played == false then
					prologue_advice_brazen_altar_pre_battle_001();
					advice_played = true
				else
					EndWaitForAccept()
				end

				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(101, "initiated_brazen_altar_quest_battle", false);

				PrologueSetPreBattleScreen("brazen_altar_title");

				local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
				local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
				if title_bar_holder then
					title_bar_holder:SetVisible(true);
				end
				if title_bar then
					title_bar:SetVisible(true);
				end
			else		
				AllowPreBattleUI(true)
				local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
				if title_bar then
					title_bar:SetVisible(false);
				end
			end
		end,
		true
	);
end

--Check timelapse view of this to see if it's safe to remove
if prologue_check_progression["ice_maiden_embedded"] == false then
	core:add_listener(
		"embed_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_method" end,
		function()
			PrologueRemoveObjective();
			prologue_check_progression["ice_maiden_embedded"] = true;
		end,
		false
	);
end


core:add_listener(
	"AreaEntered_Prologue_stage_5",
	"AreaEntered", 
	true,
	function(context)
		local character = context:family_member():character();
		if character:is_null_interface() then
			return;
		end;

		if character:cqi() == prologue_player_cqi then
			if context:area_key() == "brazen_altar" then
				if cm:model():is_player_turn() then
					-- prologue_advice_reveal_brazen_altar_battle_location_001();
					prologue_advice_entered_khorne_area_001()
					cm:remove_area_trigger("brazen_altar")
					--Metric check (step_number, step_name, skippable)
					cm:trigger_prologue_step_metrics_hit(100, "close_to_brazen_altar", false);
				end
			end
			
			if context:area_key() == "norsca_1_diplomacy" or context:area_key() == "norsca_2_diplomacy" or context:area_key() == "norsca_3_diplomacy" then
				if cm:model():is_player_turn() then
					cm:contextual_vo_enabled(false);
					prologue_check_progression["triggered_diplomacy"] = true;
					cm:remove_area_trigger("norsca_1_diplomacy");
					cm:remove_area_trigger("norsca_2_diplomacy");
					cm:remove_area_trigger("norsca_3_diplomacy");

					PrologueTributeDilemma();
				end

			end
		end
	end,
	true
);

core:add_listener(
	"MissionSucceeded_Ursun_mission",
	"MissionSucceeded",
	true,
	function(context) 
		if context:mission():mission_record_key() == "wh3_prologue_mission_riddles" then
			cm:contextual_vo_enabled(false);
			cm:toggle_dilemma_generation(false);
			prologue_advice_mission_complete_lucent_maze();
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

		end,
	false
);