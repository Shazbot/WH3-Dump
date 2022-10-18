

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	OPEN CAMPAIGN INTRO SCRIPT
--
--	Script for the intro to the main open campaign - loaded if the player hasn't
--	selected to play the intro first turn on the frontend, or if they have and
--	they've completed it
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_outpostnorsca_major");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_outpostnorsca_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_special_dervingard");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_major");

if prologue_check_progression["special_building_built"] == true then
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
	CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_growth");
	CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_royal_guards");
end


cm:cai_disable_movement_for_faction("wh3_prologue_the_tahmaks");
cm:cai_disable_movement_for_faction("wh3_prologue_the_kvelligs");
cm:cai_disable_movement_for_faction("wh3_prologue_great_eagle_tribe");
cm:cai_disable_movement_for_faction("wh3_prologue_tong");
cm:cai_disable_movement_for_faction("wh3_prologue_blood_keepers");
cm:cai_disable_movement_for_faction("wh3_prologue_sarthoraels_watchers");

cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_5");
cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_4");

PrologueInitialDisabling();

--Make sure Concede button is hidden in battle
core:svr_save_string("can_concede", tostring(0));

cm:disable_event_feed_events(false, "", "", "character_dies_battle"); 

uim:override("esc_menu"):set_allowed(true);

local prologue_completed_battle = false;

-- Unlock balance of power bar.
uim:override("prebattle_balance_of_power"):set_allowed(true);

prologue_current_army_cap = 20;
common.set_context_value("max_unit_count_override", prologue_current_army_cap)
cm:override_human_player_max_units(prologue_current_army_cap)

if prologue_check_progression["stage_4_area_triggers"] == false then
	cm:add_circle_area_trigger(278, 200, 5, "chaos_wastes", "", true, false, false)

	cm:add_circle_area_trigger(268, 208, 5, "tzeentch_flavour_1", "", true, false, false)
	cm:add_circle_area_trigger(285, 211, 5, "norse_flavour_1", "", true, false, false)

	cm:add_circle_area_trigger(293, 222, 5, "norse_settlement", "", true, false, false);
	cm:add_circle_area_trigger(257, 219, 5, "tzeentch_settlement", "", true, false, false);

	cm:add_circle_area_trigger(276, 266, 8, "ice_maiden_battle", "", true, false, false);

	cm:add_circle_area_trigger(295, 253, 8, "ruins_dilemma", "", true, false, false);
	cm:add_circle_area_trigger(259, 247, 8, "ruins_dilemma_2", "", true, false, false);

	cm:add_circle_area_trigger(277, 269, 15, "close_to_lucent_maze", "", true, false, false);

	prologue_check_progression["stage_4_area_triggers"] = true
end

if prologue_check_progression["triggered_ice_maiden_mission"] == true then
	cm:disable_pathfinding_restriction(5);
end

--add more markers
if prologue_check_progression["dervingard_battle_complete"] == false then
	core:add_listener(
		"prologue_battle_completed",
		"CharacterCompletedBattle",
		true,
		function()
			out("**** BattleCompleted event received ****");

			out("MADE IT TO STAGE 4")

			--Allow unit disbanding.
			uim:override("disband_unit"):set_allowed(true);
			prologue_tutorial_passed["disband_unit"] = true;

			uim:override("postbattle_character_deaths"):set_allowed(true);

			-- display siege information
			uim:override("siege_information"):set_allowed(true);
			uim:override("siege_turns"):set_allowed(true);

			-- Mark victory condition
			cm:complete_scripted_mission_objective("wh3_prologue_kislev_expedition", "wh_main_long_victory", "complete_dervingard", true)

			--clear the prebattle camera
			cm:clear_prebattle_display_configuration_override();

			local player = cm:model():world():faction_by_key(prologue_player_faction):faction_leader();
			cm:add_character_model_override(player, "wh3_main_pro_art_set_ksl_yuri_2");
			cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_1");

			prologue_check_progression["dervingard_battle_complete"] = true;

			cm:contextual_vo_enabled(false);

			cm:set_character_experience_disabled(false);
			
			-- Enable settlement inspection panel.
			prologue_tutorial_passed["mouse_over_info_city_info_bar"] = true
			uim:override("mouse_over_info_city_info_bar"):set_allowed(true)
			
			-- Add reinforcements listener.
			add_reinforcements_listener();

			-- Set up the listener to put factions at war with each other
			PrologueSetFactionsAtWar();

			cm:remove_custom_battlefield("intro_battle_dervingard");

			cm:remove_effect_bundle("wh3_main_prologue_lord_trait_yuri", prologue_player_faction);
			cm:apply_effect_bundle("wh3_main_prologue_lord_trait_yuri_2", prologue_player_faction, -1);


			-- Unlock panel
			uim:override("postbattle_kill_captives_with_button_hidden"):set_allowed(true);
			prologue_tutorial_passed["postbattle_kill_captives_with_button_hidden"] = true;

			uim:override("prebattle_continue_with_button_hidden"):set_allowed(true);
			prologue_tutorial_passed["prebattle_continue_with_button_hidden"] = true;

			--AfterDervingardBattle	
			out("AFTER DERVINGARD BATTLE");

			prologue_current_objective = "";

			core:add_listener(
				"post_battle_panel_opened_3",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_battle_results" 
				end,
				function()

					local uic = find_uicomponent(core:get_ui_root(), "popup_battle_results", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
					if uic then uic:SetVisible(false) end
				end,
				true	
			);


			if core:svr_load_bool("sbool_prologue_dervingard_battle_loaded_in") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(58, "dervingard_battle_loaded_in", false);
			end
			if core:svr_load_bool("sbool_prologue_dervingard_battle_positioned_units") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(59, "dervingard_battle_positioned_units", true);
			end
			if core:svr_load_bool("sbool_prologue_dervingard_battle_grouped_units") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(60, "dervingard_battle_grouped_units", true);
			end
			if core:svr_load_bool("sbool_prologue_dervingard_battle_wolves_attacked") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(61, "dervingard_battle_wolves_attacked", true);
			end
			if core:svr_load_bool("sbool_prologue_dervingard_battle_rematched") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(62, "dervingard_battle_rematched", true);
			end
			if core:svr_load_bool("sbool_prologue_dervingard_battle_won") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(63, "dervingard_battle_won", false);
			end

			--cm:callback(function() prologue_advice_dervingard_post_battle_001() end, 3);
		end,
		false
	);
end

core:add_listener(
	"prologue_battle_completed_stage_4",
	"CharacterCompletedBattle",
	true,
	function()
		out("**** BattleCompleted event received ****");

		prologue_completed_battle = true;

		if prologue_check_progression["shield_tutorial_complete"] == true then
			cm:remove_custom_battlefield("intro_battle_shield");
		end
		
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
			core:svr_save_bool("sbool_load_tzeentch_campaign", true) --sbool_load_post_open_campaign
			cm:load_local_faction_script("_stage_5", true);
		end
	end,
	true
);

function CheckBuildingPrologueProgressOpen()
	if building_complete == true then
		if test_building == "wh3_prologue_building_ksl_special_1" and prologue_check_progression["special_building_built"] == false then
			prologue_check_progression["special_building_built"] = true;
			
			uim:override("character_details"):set_allowed(false);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(69, "built_totem", false);
			
			prologue_advice_leave_dervingard_001()
			
			-- remove action points
			cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_barracks");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_stables");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_sleds");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_timber");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_attack");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_armour");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_ammunition");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_building_second_growth");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_growth");
			CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_royal_guards");
		else
			if prologue_tutorial_passed["province_info_panel"] == false then
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)
				end
			end
		end

		building_complete = false;
	end
end

core:add_listener(
	"CharacterPerformsSettlementOccupationDecision_Prologue_open",
	"CharacterPerformsSettlementOccupationDecision", 
	true,
	function(context)
		if context:character():faction():name() == prologue_player_faction then

			out("OCCUPIED")

			open_settlement_taken = context:garrison_residence():region():cqi();

			if context:garrison_residence():region():name() == "wh3_prologue_region_frozen_plains_dervingard" then

				cm:add_building_to_settlement("wh3_prologue_region_frozen_plains_dervingard", "wh3_prologue_building_ksl_stables_1");
				
				PrologueSwordDilemma();

				local player_faction = context:character():faction();
				local player_region = context:garrison_residence():region();
			
				cm:change_home_region_of_faction(player_faction, player_region);

				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(64, "occupied_dervingard", false);
				core:add_listener(
					"BuildingConstructionIssuedByPlayerTotemBuildInProgress",
					"BuildingConstructionIssuedByPlayer",
					function(context) return context:building() == "wh3_prologue_building_ksl_special_1" end,
					function()
						prologue_check_progression["special_building_in_progress"] = true;
						core:remove_listener("BuildingConstructionIssuedByPlayerTotemBuildInProgress");
					end,
					true
				);
			end
			
		end
	end,
	true
);


core:add_listener(
	"RecruitmentItemIssuedByPlayer_stage_4",
	"CharacterCreated",
	true,
	function(context)
		--if context:faction():name() == prologue_player_faction then
			
			out("UNIT RECRUITED: ");
		--end
	end,
	true			
);

core:add_listener(
	"AreaEntered_Prologue_stage_4",
	"AreaEntered", 
	true,
	function(context)
		local character = context:family_member():character();
		if character:is_null_interface() then
			return;
		end;

		if character:cqi() == prologue_player_cqi then
			
			if context:area_key() == "chaos_wastes" then	
				prologue_advice_fork_in_the_road_001();
				cm:remove_area_trigger("chaos_wastes");
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(78, "reached_the_fork", false);
			end
			if context:area_key() == "norse_flavour_1" or context:area_key() == "tzeentch_flavour_1" then
				if  cm:model():is_player_turn() then
					skip_all_scripted_tours();
					cm:contextual_vo_enabled(false);
					cm:remove_area_trigger("tzeentch_flavour_1");
					cm:remove_area_trigger("norse_flavour_1");
					prologue_advice_entering_new_area_001();
				end
			end
			if context:area_key() == "norse_settlement" then
				if cm:model():is_player_turn() then
					cm:remove_area_trigger("tzeentch_settlement");
					cm:remove_area_trigger("norse_settlement");
					prologue_advice_first_enemy_settlement_right_001();
				end
			end
			if context:area_key() == "tzeentch_settlement" then
				if cm:model():is_player_turn() then
					cm:remove_area_trigger("norse_settlement");
					cm:remove_area_trigger("tzeentch_settlement");
					prologue_advice_first_enemy_settlement_001();
				end
			end
			if context:area_key() == "ice_maiden_battle" then
				if cm:model():is_player_turn() then
					cm:remove_area_trigger("ice_maiden_battle");
					--Maybe add the cindy that shows the quest marker - the short one
				end
			end
			if context:area_key() == "ruins_dilemma" or context:area_key() == "ruins_dilemma_2" then
				if cm:model():is_player_turn() then
					cm:remove_area_trigger("ruins_dilemma");
					cm:remove_area_trigger("ruins_dilemma_2");

					prologue_load_check = "before_ruins_dilemma";

					core:add_listener(
						"FactionTurnStart_RuinsDilemma",
						"FactionTurnStart",
						true,
						function()
							skip_all_scripted_tours();
							cm:toggle_dilemma_generation(false);
							cm:contextual_vo_enabled(false);
							PrologueRuinsDilemma()
							cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)
						end,
						false
					)
				end
			end
			if context:area_key() == "close_to_lucent_maze" then
				prologue_check_progression["close_to_lucent_maze"] = true
				add_start_quest_battle_objective()
				cm:remove_area_trigger("close_to_lucent_maze")
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(91, "close_to_lucent_maze", false);
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
			common.setup_dynamic_loading_screen("prologue_battle_lucent_maze_intro", "prologue")
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
		"PanelOpenedCampaign_pre_battle_screen_stage_4",
		"PanelOpenedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			if common.get_context_value("CampaignBattleContext.IsQuestBattle") then

				cm:steal_user_input(true);

				cm:remove_custom_battlefield("intro_battle_shield");

				AllowPreBattleUI(false)

				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(92, "initiated_lucent_maze_quest_battle", false);

				PrologueSetPreBattleScreen("lucent_maze_title");
				
				local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
				local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
				if title_bar_holder then
					title_bar_holder:SetVisible(true);
				end
				if title_bar then
					title_bar:SetVisible(true);
				end

				if advice_played == false then
					prologue_advice_ice_maiden_battle_pre_battle_001();
					advice_played = true

					local bottom_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment");
					if bottom_panel then
						bottom_panel:SetVisible(false);
					end
				else
					cm:steal_user_input(false);
					EndWaitForAccept()
				end

				-- Remove objective for starting quest battles.
				prologue_check_progression["lucent_maze_pre_battle"] = true 
				cm:remove_objective("wh3_prologue_objective_start_quest_battle")
			else
				AllowPreBattleUI(true)

				local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
				if title_bar then
					title_bar:SetVisible(false);
				end

				if prologue_check_progression["shield_tutorial_complete"] == false then

					out("SHIELD TUTORIAL")
					local pb = cm:model():pending_battle();

					local attacker = pb:attacker():faction():subculture();
					local defender = pb:defender():faction():subculture();

					out("ATTCKER IS: "..attacker.." and DEFENDER IS: "..defender);

					if pb:attacker():faction():subculture() == "wh3_main_pro_sc_tze_tzeentch" or pb:defender():faction():subculture() == "wh3_main_pro_sc_tze_tzeentch" then

						core:add_listener(
							"attack_button_shield_listener",
							"ComponentLClickUp",
							function(context) return context.string == "button_attack" end,
							function()
								out("STARTING SHIELD TUTORIAL")
								prologue_check_progression["shield_tutorial_complete"] = true;

								remove_generic_battle_script_override();
								cm:add_custom_battlefield(
									"intro_battle_shield",												-- string identifier
									0,																-- x co-ord
									0,																-- y co-ord
									5000,															-- radius around position
									false,															-- will campaign be dumped
									"",									-- loading override
									"script/battle/scenario_battles/prologue_shield_tutorial/battle_start.lua",																-- script override
									"",		-- entire battle override
									0,																-- human alliance when battle override
									false,															-- launch battle immediately
									true,															-- is land battle (only for launch battle immediately)
									false															-- force application of autoresolver result
								);
							end,
							false
						);
					end
				end	
			end
		end,
		true
	);
end


core:add_listener(
	"FactionTurnStart_OpenWorldCampaign",
	"FactionTurnStart",
	true,
	function(context)
		if context:faction():name() == prologue_player_faction then
			CheckBuildingPrologueProgressOpen();

			if prologue_check_progression["open_world"] == true and prologue_check_progression["triggered_mansion_of_eyes_mission"] == false then
				local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
				if new_player then
					cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.4);
				end
			end
		end
	end,
	true
);

core:add_listener(
	"FactionTurnStart_OpenWorld_settlements",
	"FactionTurnStart",
	function() return prologue_check_progression["open_world"] end,
	function(context) if context:faction():name() == prologue_player_faction then 
		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
		core:trigger_event("ScriptEventPrologueSettlements") end 
		else
			prologue_tutorial_passed["regions_with_button_hidden"] = true;
			uim:override("regions_with_button_hidden"):set_allowed(true);
		end
	end,
	true
);

function Add_Growth_Building_Progress_End_Turn_Listeners()
	if not prologue_check_progression["special_building_built"] then
		-- Remove listeners storing the state of the special building.
		core:remove_listener("BuildingConstructionIssuedByPlayerGrowthBuildingEndTurn2")
		core:remove_listener("RegionBuildingCancelledGrowthBuildingEndTurn2")

		-- Add listeners that also change the state of the end turn button.
		core:add_listener(
			"BuildingConstructionIssuedByPlayerGrowthBuildingEndTurn",
			"BuildingConstructionIssuedByPlayer",
			function(context) return context:building() == "wh3_prologue_building_ksl_special_1" end,
			function()
				prologue_check_progression["special_building_in_progress"] = true;
				load_check_before_building_growth_end_turn()
			end,
			true
		);

		core:add_listener(
			"RegionBuildingCancelledGrowthBuildingEndTurn",
			"RegionBuildingCancelled",
			function(context) return context:key() == "wh3_prologue_building_ksl_special_1" end,
			function()
				prologue_check_progression["special_building_in_progress"] = false;
				load_check_before_building_growth_end_turn()
			end,
			true
		);
		
		core:add_listener(
			"FactionTurnEndGrowthBuilding",
			"FactionTurnEnd",
			true,
			function()
				core:remove_listener("BuildingConstructionIssuedByPlayerGrowthBuildingEndTurn")
				core:remove_listener("RegionBuildingCancelledGrowthBuildingEndTurn")
				highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
			end,
			false
		)
	end
end

function add_start_quest_battle_objective()
	if prologue_check_progression["lucent_maze_pre_battle"] == false and prologue_check_progression["close_to_lucent_maze"] then
		cm:set_objective_with_leader("wh3_prologue_objective_start_quest_battle")

		prologue_mission_ice_maiden_actions:trigger();
		prologue_check_progression["triggered_ice_maiden_mission"] = true
	end
end

-- Store state of special building.
if not prologue_check_progression["special_building_built"] then
	core:add_listener(
		"BuildingConstructionIssuedByPlayerGrowthBuildingEndTurn2",
		"BuildingConstructionIssuedByPlayer",
		function(context) return context:building() == "wh3_prologue_building_ksl_special_1" end,
		function() prologue_check_progression["special_building_in_progress"] = true end,
		true
	)

	core:add_listener(
		"RegionBuildingCancelledGrowthBuildingEndTurn2",
		"RegionBuildingCancelled",
		function(context) return context:key() == "wh3_prologue_building_ksl_special_1" end,
		function() prologue_check_progression["special_building_in_progress"] = false end,
		true
	)
end

---------------------------------------------------------------
----------------- Load Check Functions ------------------------
---------------------------------------------------------------
function load_check_before_building_growth_end_turn() 
	if prologue_check_progression["special_building_in_progress"] == true then
		uim:override("end_turn"):set_allowed(true);
		HighlightEndTurnButton()
	else
		uim:override("end_turn"):set_allowed(false);
		highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")
	end
end

function load_check_before_building_growth() 
	core:add_listener(
		"BuildingConstructionIssuedByPlayerBuildTotem",
		"BuildingConstructionIssuedByPlayer",
		true,
		function(context)
			local faction = context:garrison_residence():faction();
			if faction:is_human() then
				if context:building() == "wh3_prologue_building_ksl_special_1" then
					prologue_check_progression["special_building_in_progress"] = true;
					prologue_start_of_dialogue(false, function() cm:callback(function() prologue_advice_at_dervingard_006() end, prologue_audio_timing["wh3_prologue_narrative_17_7_1"]) end)
				end
			end
		end,
		false
	);
end

core:add_listener(
	"LoadingScreenDismissed_Prologue_intro_post",
	"LoadingScreenDismissed",
	true,
	function()
		if prologue_completed_battle == false then
			if prologue_load_check == "before_building_growth" then	
					load_check_before_building_growth()
					ConstructionTopicLeaders("wh3_prologue_objective_turn_014_02", "wh3_prologue_objective_turn_014_03", true)
			elseif prologue_load_check == "after_building_growth" then
				load_check_before_building_growth_end_turn()
				Add_Growth_Building_Progress_End_Turn_Listeners()
				ConstructionTopicLeaders("wh3_prologue_objective_turn_014_02", "wh3_prologue_objective_turn_014_03", true)
			elseif prologue_lock_check == "post_dervingard" then
				PrologueAddTopicLeader("wh3_prologue_objective_chaos_wastes", function() if prologue_check_progression["open_world"] then cm:remove_objective("wh3_prologue_objective_chaos_wastes") end end)
			elseif prologue_load_check == "trials" then
				PrologueTrialsDilemma()
			elseif prologue_load_check == "before_ruins_dilemma" then
				core:add_listener(
					"FactionTurnStart_RuinsDilemma",
					"FactionTurnStart",
					true,
					function()
						cm:toggle_dilemma_generation(false);
						PrologueRuinsDilemma()
					end,
					false
				)
			end

			if prologue_current_objective ~= "" then
				cm:set_objective(prologue_current_objective);
			end
		else
			prologue_completed_battle = false;
		end	

		add_start_quest_battle_objective()
	end,
	false
);


out("VARIABLE IS SET TO: "..prologue_load_check);