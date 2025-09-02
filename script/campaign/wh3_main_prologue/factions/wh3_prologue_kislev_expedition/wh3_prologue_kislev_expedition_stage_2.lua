

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FIRST TURN INTRO SCRIPT
--
--	Script for first section of intro first-turn
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

---------------------------------------------------------------
--	Listeners
---------------------------------------------------------------
cm:cai_disable_movement_for_faction("wh3_prologue_apostles_of_change");
cm:cai_disable_movement_for_faction("wh3_prologue_blood_keepers");
cm:cai_disable_movement_for_faction("wh3_prologue_great_eagle_tribe");
cm:cai_disable_movement_for_faction("wh3_prologue_sarthoraels_watchers");
cm:cai_disable_movement_for_faction("wh3_prologue_the_sightless");
cm:cai_disable_movement_for_faction("wh3_prologue_tong");
cm:cai_disable_movement_for_faction("wh3_prologue_the_tahmaks");
cm:cai_disable_movement_for_faction("wh3_prologue_the_kvelligs");

uim:override("campaign_flags"):set_allowed(true);

--change the tect for max army size
prologue_current_army_cap = 9;
common.set_context_value("max_unit_count_override", prologue_current_army_cap)
cm:override_human_player_max_units(prologue_current_army_cap)

prologue_player_cqi = cm:get_faction(cm:get_local_faction_name()):faction_leader():cqi();

--CampaignUI.AddBuildingChainToWhitelist("wh_main_EMPIRE_outpostnorsca_major_EASY");

PrologueInitialDisabling();

local pre_battle_advice_played = false;

-- disable movement for the scorn faction
cm:cai_disable_movement_for_faction(enemy_faction_name);

cm:set_unit_experience_disabled(true);

-- Unlock the main and other buildings
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_minor");

CampaignUI.AddUnitToBlacklist("wh3_main_pro_ksl_inf_kossars_1");
CampaignUI.AddUnitToBlacklist("wh3_main_pro_ksl_inf_kossars_0");

-- add a marker for the second skollden army
if prologue_check_progression["stage_2_area_triggers"] == false then
	cm:add_circle_area_trigger(282, 168, 7, "second_battle", "", true, false, true)
	prologue_check_progression["stage_2_area_triggers"] = true
end

--Enable bronze bar beneath unit panel.
core:remove_listener("hide_small_bar_when_units_panel_is_open")
uim:override("units_panel_small_bar"):set_allowed(true)

-- Enable building recruitment info.
uim:override("building_info_recruitment_effects"):set_allowed(true)

-- add a listener for the player's faction turn start
core:add_listener(
	"FactionTurnStart_Prologue2",
	"FactionTurnStart",
	true,
	function(context)
		if context:faction():is_human() then
			
			if building_complete == false then 
				PrologueCheckIntroPostProgression();
			end
		end
	end,
	true
);


-- add a listener for when the attack button is pressed
core:add_listener(
	"post_battle_button_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_attack" end,
	function()
		out("STARTING SECOND TUTORIAL BATTLE")

		CampaignUI.ClearUnitBlacklist();

		core:remove_listener("FactionTurnStart_Prologue_enemy_turn3");
		-- set loading screen. This is also set in the battle_start of this battle. It needs to match.
		common.setup_dynamic_loading_screen("prologue_battle_2_intro", "prologue")

		cm:win_next_autoresolve_battle(prologue_player_faction);
		cm:modify_next_autoresolve_battle(
			0, 			-- attacker win chance
			1,	 		-- defender win chance
			5,	 		-- attacker losses modifier
			1.1,			-- defender losses modifier
			false
		);
		-- ensure the next battle we load (i.e. the one we're immediately about to launch) is the intro battle
		remove_generic_battle_script_override();
		cm:add_custom_battlefield(
			"intro_battle_2",												-- string identifier
			0,																-- x co-ord
			0,																-- y co-ord
			5000,															-- radius around position
			false,															-- will campaign be dumped
			"",																-- loading override
			"",																-- script override
			"script/battle/scenario_battles/02_standard_defence/battle.xml",		-- entire battle override
			0,																-- human alliance when battle override
			false,															-- launch battle immediately
			true,															-- is land battle (only for launch battle immediately)
			true															-- force application of autoresolver result
		);

		uim:override("postbattle_middle_panel"):set_allowed(false);
		prologue_tutorial_passed["postbattle_middle_panel"] = false;
	end,
	true
);


core:add_listener(
	"autoresolve_button_listener_post",
	"ComponentLClickUp",
	function(context) return context.string == "button_autoresolve" end,
	function()
		out("STARTING AUTORESOLVE LISTENER")
		cm:set_saved_value("bool_load_post_open_campaign", true)
		cm:set_saved_value("bool_load_post_intro_campaign", false)

		cm:load_local_faction_script("_stage_3", true);
		-- remove the flag that triggers the tutorial battle
		cm:remove_custom_battlefield("intro_battle_2");

		core:remove_listener("prologue_battle_completed");
		core:remove_listener("FactionTurnStart_Prologue_enemy_turn3");
		core:remove_listener("post_battle_button_listener");

		--cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 1)

		prologue_tutorial_passed["hide_campaign_unit_information"] = true;
		uim:override("hide_campaign_unit_information"):set_allowed(true);

		prologue_load_check = "Turn_8_end";

		out("MADE IT TO THE OPEN BIT");

	end,
	false
);

core:add_listener(
	"autoresolve_button_listener_intro",
	"ComponentLClickUp",
	function(context) return context.string == "dev_button_win_battle" end,
	function()
		out("STARTING AUTORESOLVE LISTENER")
		cm:set_saved_value("bool_load_post_open_campaign", true)
		cm:set_saved_value("bool_load_post_intro_campaign", false)

		cm:load_local_faction_script("_stage_3", true);
		-- remove the flag that triggers the tutorial battle
		cm:remove_custom_battlefield("intro_battle_2");

		core:remove_listener("prologue_battle_completed");
		core:remove_listener("FactionTurnStart_Prologue_enemy_turn3");
		core:remove_listener("post_battle_button_listener");

		cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 1)

		prologue_load_check = "Turn_8_end";

		out("MADE IT TO THE OPEN BIT");

		PrologueAfterSecondBattle();
	end,
	false
)


core:add_listener(
	"prologue_battle_completed",
	"CharacterCompletedBattle",
	true,
	function()
		out("**** BattleCompleted event received ****");

		core:remove_listener("autoresolve_button_listener_intro");
		CheckPostBattlePrologueProgress()
		--clear the prebattle camera
		cm:clear_prebattle_display_configuration_override();
		-- Disble the esc_menu button
		uim:override("esc_menu"):set_allowed(false)
		-- Disble the end turn button
		uim:override("end_turn"):set_allowed(false);

		--Set up the metric variables from battle
		if core:svr_load_bool("sbool_prologue_first_battle_loaded_in") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(28, "first_battle_loaded_in", false);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_skipped") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(29, "first_battle_skipped", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_replayed") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(30, "first_battle_replayed", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_watched_intro_cutscene") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(31, "first_battle_watched_intro_cutscene", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_skipped_intro_cutscene") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(32, "first_battle_skipped_intro_cutscene", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_finished_camera_tutorial") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(33, "first_battle_finished_camera_tutorial", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_selected_Yuri") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(34, "first_battle_selected_Yuri", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_moved_Yuri") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(35, "first_battle_moved_Yuri", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_selected_all_units") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(36, "first_battle_selected_all_units", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_moved_all_units") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(37, "first_battle_moved_all_units", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_attacked_first_enemy") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(38, "first_battle_attacked_first_enemy", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_attacked_artillery") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(39, "first_battle_attacked_artillery", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_ability_used") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(40, "first_battle_ability_used", true);
		end
		if core:svr_load_bool("sbool_prologue_first_battle_won") then
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(41, "first_battle_won", true);
		end

	end,
	false
);

core:add_listener(
	"AreaEntered_Prologue_Post_Intro",
	"AreaEntered", 
	true,
	function(context)
		ProloguePostIntroCheckArea(context);
	end,
	true
);


local mtp_end_turn_button = active_pointer:new(
	"end_turn_button",
	"bottomright",
	find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_end_turn"),
	"ui_text_replacements_localised_text_prologue_text_pointer_end_turn_3",
	0.5,
	0.2,
	nil,
	true
);

if prologue_check_progression["recruited_units_tutorial_complete"] == false then
	core:add_listener(
		"recruitment_button_1",
		"RecruitmentItemIssuedByPlayer",
		function() return prologue_check_progression["st_recruitment"] == true end,
		function()
			-- This is set so the post PrologueCheckIntroPostProgression() is only called once.
			recruited = true;

			units_recruited = units_recruited + 1
			out("UNIT RECRUITED IS: "..units_recruited)

			if units_recruited == 3 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 3, 3);

				HighlightEndTurnButton();

				-- Enable the end turn button
				uim:override("end_turn"):set_allowed(true);

				core:stop_all_windowed_movie_players();

				cm:remove_objective("wh3_prologue_objective_turn_008_01") 

				core:remove_listener("RecruitmentItemIssuedByPlayerRecruitmentLinger");

				-- Apply end turn objective; remove it if player has less than required.
				PrologueAddTopicLeader("wh3_prologue_objective_turn_001_09", function() if units_recruited < 3 then cm:remove_objective("wh3_prologue_objective_turn_001_09") end end, true)

				prologue_load_check = "recruited_units";

				core:add_listener(
					"PanelClosedCampaign_unit_recruitment",
					"PanelClosedCampaign",
					function(context) 
						return context.string == "units_panel" 
					end,
					function()
						cm:contextual_vo_enabled(true);
					end,
					false
				);
				
			elseif units_recruited == 2 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 2, 3);

			elseif units_recruited == 1 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 1, 3);

			end
		end,
		true
	);

	core:add_listener(
		"RecruitmentItemCancelledByPlayer_prologue",
		"RecruitmentItemCancelledByPlayer",
		true,
		function()

			units_recruited = units_recruited - 1
			out("UNIT RECRUITED IS: "..units_recruited)

			-- If less than 3, disable end turn.
			if units_recruited < 3 then 
				mtp_end_turn_button:hide();

				highlight_component(false, false, "hud_campaign", "faction_buttons_docker", "button_end_turn")

				core:remove_listener("PanelClosedCampaign_unit_recruitment");
				cm:contextual_vo_enabled(false);

				-- Disable the end turn button
				uim:override("end_turn"):set_allowed(false);

				-- Set load check to not recruited.
				prologue_load_check = "after_recruit_button";

				-- Remove end turn objective instantly
				cm:remove_objective("wh3_prologue_objective_turn_001_09") 
			end

			if units_recruited == 0 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 0, 3)

			elseif units_recruited == 1 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 1, 3)

			elseif units_recruited == 2 then

				cm:set_objective("wh3_prologue_objective_turn_008_01", 2, 3);

			end
		end,
		true
	)

	core:add_listener(
		"FactionTurnStart_PlayerRecruitment",
		"FactionTurnStart",
		function(context) return context:faction():name() == prologue_player_faction end,
		function()
				-- Remove recruit objective.
				cm:remove_objective("wh3_prologue_objective_turn_008_01") 

				core:remove_listener("recruitment_button_1")
				core:remove_listener("RecruitmentItemCancelledByPlayer_prologue")
				core:remove_listener("disable_recruitment_cards")
				core:remove_listener("disable_recruitment_cards_2")
				prologue_check_progression["recruited_units_tutorial_complete"] = true
		end,
		false
	)
end


core:add_listener(
	"post_battle_panel_opened",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "popup_battle_results" 
	end,
	function()

		-- Disable the ESC key
		cm:steal_escape_key(true);
		

		local uic_ally = find_uicomponent(core:get_ui_root(), "units_and_banners_parent", "units_window", "commander_header_1");

		if uic_ally then
			uic_ally:SetVisible(false);
		end

		cm:callback(function() 
			local uic_kill_button = find_uicomponent(core:get_ui_root(), "button_set_win", "killwh3_main_pro_captive_option_kill_kislev");

			if uic_kill_button then
				uic_kill_button:SetVisible(false);
			else
				out("COULDNT FIND the Kill button")
			end
		end, 2.7);

		local player_army_panel = find_uicomponent(core:get_ui_root(), "allies_combatants_panel");
		local enemy_army_panel = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel");

		if player_army_panel and enemy_army_panel then
			player_army_panel:SetCanResizeHeight(true);
			enemy_army_panel:SetCanResizeHeight(true);
			player_army_panel:Resize(player_army_panel:Width(), 450);
			enemy_army_panel:Resize(enemy_army_panel:Width(), 450);
		else
			out("COULDNT FIND PANELS")
		end

		uim:override("units_panel"):set_allowed(true);
		prologue_tutorial_passed["units_panel"] = true;
	end,
	true	
);


function PrologueCheckIntroPostProgression()
	-- if recruited is true
	if recruited == true then

		out("RECRUITED");

		cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

		prologue_advice_find_petrenko_001();
		
		PrologueRemoveObjective(); 

		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(45, "recruited_units", false);
			
		-- reset recruited variable
		recruited = false;
	end

end


function CheckPostBattlePrologueProgress()

	--Disable character selection. This is re-enabled in prologue_units_panel in _interventions
	uim:enable_character_selection_whitelist()

	-- turning the siege label back on
	uim:override("siege_turns"):set_allowed(true);
	prologue_tutorial_passed["siege_turns"] = true;
	
	-- Disable the end turn button
	uim:override("end_turn"):set_allowed(false);
	
	cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)

	-- disable movement for the scorn faction
	cm:cai_disable_movement_for_faction(enemy_faction_name);
	
	-- remove the flag that triggers the tutorial battle
	cm:remove_custom_battlefield("intro_battle_1");

	core:add_listener(
		"PostbattleRewardAnimationsFinished_Prologue2",
		"PostbattleRewardAnimationsFinished",
		true,
		function(context)
			prologue_advice_post_battle_001();
		end, 
		false
	);

end

function PrologueAfterPostBattle()
	
	-- Give the Kislev Survivors region to the player - needs to be removed when the tutorial battle is in
	cm:transfer_region_to_faction("wh3_prologue_region_ice_canyon_beacon_fort", prologue_player_faction)
	
	-- Kill survivor army 
	local survivor_army_list = cm:model():world():faction_by_key("wh3_prologue_dervingard_garrison"):military_force_list();
	for i = 0, survivor_army_list:num_items() - 1 do
		if survivor_army_list:item_at(i):upkeep() > 0 then
			local survivor_army_cqi = survivor_army_list:item_at(i):general_character():cqi();
			cm:kill_character(survivor_army_cqi, true);
		end
	end

	-- Kill enemy army
	local enemy_army_list = cm:model():world():faction_by_key(enemy_faction_name):military_force_list();
	for i = 0, enemy_army_list:num_items() - 1 do
		if enemy_army_list:item_at(i):upkeep() > 0 then
			local enemy_army_cqi = enemy_army_list:item_at(i):general_character():cqi();
			cm:kill_character(enemy_army_cqi, true);
		end
	end

	if prologue_check_progression["second_tutorial_army_created"] == false then
		out("TRYING TO CREATE AN ENEMY ARMY")
		cm:create_force_with_general(
			enemy_faction_name, 
			"wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0", 
			"wh3_prologue_region_frozen_plains_dervingard", 
			425, 
			230,
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
				prologue_check_progression["second_tutorial_army_created"] = true;
			end
		);
	else
		out("COULD NOT CREATE ENEMY ARMY")
		if prologue_check_progression["second_tutorial_army_created"] == true then
			out("THE VARIABLE IS SET TO TRUE")
		end
	end

	-- Add rank to units to match upcoming battle.
	out("Adding rank to units")
	local player_unit_list = cm:model():world():faction_by_key(prologue_player_faction):faction_leader():military_force():unit_list()
	cm:set_unit_experience_disabled(false)
	for i = 0, player_unit_list:num_items() - 1 do
		out(player_unit_list:item_at(i):unit_key())
		out(player_unit_list:item_at(i):unit_category())
		out(player_unit_list:item_at(i):unit_class())
		if player_unit_list:item_at(i):unit_key() == "wh3_main_pro_ksl_inf_tzar_guard_0" then
			cm:add_experience_to_unit(player_unit_list:item_at(i), 1)
		elseif player_unit_list:item_at(i):unit_key() == "wh3_main_pro_ksl_inf_kossars_0" then
			cm:add_experience_to_unit(player_unit_list:item_at(i), 1)
		end
	end
	cm:set_unit_experience_disabled(true)

	cm:steal_escape_key(false);

	prologue_advice_mission_complete_saving_beacon();
end


function ProloguePostIntroCheckArea(context)
	if context:area_key() == "second_battle" then
		prologue_check_progression["second_battle"] = true;
		prologue_advice_find_petrenko_part_two_001();
	end
end

function SetUpUnitRecruitmentTour()
	
	local yuri_selected = false

	-- Unlock UI.
	uim:override("campaign_flags_strength_bars"):set_allowed(true);
	prologue_tutorial_passed["campaign_flags_strength_bars"] = true;
	uim:override("units_panel_small_bar"):set_allowed(true);
	prologue_tutorial_passed["units_panel_small_bar"] = true
	
	-- Clean up listeners.
	core:remove_listener("hide_units_panel_small_bar_ui_override");
	core:remove_listener("hide_settlement_panel_small_bar_ui_override")
	core:remove_listener("hide_small_bar_when_units_panel_is_open")
	
	local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
	if new_player then
		-- Add objective to select Yuri.
		PrologueAddTopicLeader("wh3_prologue_objective_turn_001_05", function() if yuri_selected then cm:remove_objective("wh3_prologue_objective_turn_001_05") end end)
		
		core:add_listener(
			"PanelOpenedCampaignUnitsPanel",
			"PanelOpenedCampaign",
			function(context) return context.string == "units_panel" end,
			function()
				yuri_selected = true
				cm:remove_objective("wh3_prologue_objective_turn_001_05")
				cm:steal_user_input(true);
				
				core:trigger_event("ScriptEventPrologueUnitsPanel")
			end,
			false
		)
	else
		uim:override("units_panel_small_bar_buttons"):set_allowed(true);
		prologue_tutorial_passed["units_panel_small_bar_buttons"] = true;
		uim:override("units_panel_recruit_with_button_hidden"):set_allowed(true);
		prologue_tutorial_passed["units_panel_recruit_with_button_hidden"] = true;
		uim:override("units_panel_docker"):set_allowed(true);
		prologue_tutorial_passed["units_panel_docker"] = true;
		
		prologue_load_check = "after_recruit_button";
				
		cm:set_objective("wh3_prologue_objective_turn_008_01", 0, 3);

		prologue_check_progression["st_recruitment"] = true

		SetUpRecruitLingeringCallback();
	end

	-- Re-enabled character selection. This is initially disabled in CheckPostBattlePrologueProgress() in _stage_2
	uim:disable_character_selection_whitelist()
end


core:add_listener(
	"FactionTurnStart_Prologue_enemy_turn3",
	"FactionBeginTurnPhaseNormal",
	true,
	function(context)
		
		if context:faction():name() == enemy_faction_name and cm:character_can_reach_character(cm:get_character_by_cqi(enemy_army_cqi), cm:get_character_by_cqi(prologue_player_cqi)) then 
			out("TRYING TO MOVE ENEMY ARMY INTRO POST")
			if prologue_check_progression["second_battle"] == true then
				--[[local faction = cm:get_faction(enemy_faction_name)
				local observation_options = cm:model():world():observation_options_for_faction(faction, faction);
				local test = observation_options:armies_options();
				test:set_camera_follow_behaviour("LOW");
				observation_options:set_armies_options(test);
				cm:set_character_observation_options_for_faction(faction, observation_options);]]

				cm:force_declare_war(enemy_faction_name, prologue_player_faction, true, true);
				cm:callback(function() 
					cm:enable_movement_for_faction(enemy_faction_name);
					cm:attack("character_cqi:"..enemy_army_cqi, "character_cqi:"..prologue_player_cqi, true);
				end, 1.5)

				cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 1)

				cm:remove_objective(prologue_current_objective);
				prologue_current_objective = "";

				prologue_advice_pre_battle_two_001();

				--prologue_advice_petrenko_attacks_001();

				-- Add a cindy scene camera
				--[[local cutscene_intro = campaign_cutscene:new_from_cindyscene(
					"prologue_petrenko_attacks",
					function() 
						CampaignUI.ClearSelection(); 
					end,
					"petrenko_attack_01", 
					0, 
					1
				);
					
				cutscene_intro:set_disable_settlement_labels(true);
				cutscene_intro:set_dismiss_advice_on_end(false);
				cutscene_intro:set_restore_shroud(false);

						
				cutscene_intro:action(
					function()
						uim:override("campaign_flags"):set_allowed(false);
						cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
					end,
					0
				);
					
				cutscene_intro:action(
					function()
						prologue_advice_petrenko_attacks_001();
					end,
					1
				);
				
				cutscene_intro:start();]]

			end

		end
	end,
	true
);

core:add_listener(
	"PanelOpenedCampaign_pre_battle_screen",
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_pre_battle" end,
	function()
		-- set the prebattle camera
		--cm:set_prebattle_display_configuration_override(6.3,6.0,-0.0,1.0,10.0);--distance,height,scale,separation

		cm:disable_saving_game(true)

		PrologueSetPreBattleScreen("battle_2_title");

		local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
		local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
		if title_bar_holder then
			title_bar_holder:SetVisible(true);
		end
		if title_bar then
			title_bar:SetVisible(true);
		end

		prologue_load_check = "second_pre_battle";
		out("PRE BATTLE PANEL OPEN")

		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(46, "initiated_second_battle", false);

		if pre_battle_advice_played == false then
			prologue_advice_pre_battle_two_003();
			pre_battle_advice_played = true;
		end

		local map_button = find_uicomponent(core:get_ui_root(), "button_preview_map");
		if map_button then
			map_button:SetVisible(false);
		end

		local player_army_panel = find_uicomponent(core:get_ui_root(), "allies_combatants_panel");
		local enemy_army_panel = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel");

		if player_army_panel and enemy_army_panel then
			player_army_panel:SetCanResizeHeight(true);
			enemy_army_panel:SetCanResizeHeight(true);
			player_army_panel:Resize(player_army_panel:Width(), 450);
			enemy_army_panel:Resize(enemy_army_panel:Width(), 450);
		end

		local attack_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_attack");
		if attack_button then
			cm:callback(function() pulse_uicomponent(attack_button, 2, 6); end, 1);
		else
			out("COULDN@T FIND ATTACK BUTTON")
		end

	end,
	true
);


core:add_listener(
	"LoadingScreenDismissed_Prologue_intro_post",
	"LoadingScreenDismissed",
	true,
	function()
		uim:override("esc_menu"):set_allowed(false); 
		
		if prologue_load_check == "after_recruit_button" then
			-- Disable the end turn button
			uim:override("end_turn"):set_allowed(false)

			-- Display recruit helper video.
			local wmp_prologue_recruit = windowed_movie_player:new_from_advisor("prologue_test_movie_recruit", "warhammer3/prologue/kislev_tutorial_03", 1);
			wmp_prologue_recruit:set_width(300);
			wmp_prologue_recruit:show();

			-- Set recruit objective.
			if units_recruited == 0 then
				cm:set_objective("wh3_prologue_objective_turn_008_01", 0, 3)
			elseif units_recruited == 1 then
				cm:set_objective("wh3_prologue_objective_turn_008_01", 1, 3)
			elseif units_recruited == 2 then
				cm:set_objective("wh3_prologue_objective_turn_008_01", 2, 3)
			end
		elseif prologue_load_check == "first_post_battle" then
			PrologueAfterPostBattle();
		elseif prologue_load_check == "recruited_units" then
			-- Enable the end turn button
			uim:override("end_turn"):set_allowed(true);

			-- Set recruit objective.
			cm:set_objective("wh3_prologue_objective_turn_008_01", 3, 3)
			
			-- Set end turn objective.
			PrologueAddTopicLeader("wh3_prologue_objective_turn_001_09", function() if units_recruited < 3 then cm:remove_objective("wh3_prologue_objective_turn_001_09") end end)
			
		elseif prologue_load_check == "leave_beacon_fort_end" then
			-- Add objective to find Skollden.
			PrologueAddTopicLeader("wh3_prologue_objective_turn_013_03")

			core:add_listener(
				"CharacterFinishedMovingEvent_Prologue",
				"CharacterFinishedMovingEvent", 
				function() return PrologueGetActionPoints() < 15 end,
				function()
					-- Advisor text: We have marched as far as we can. There is nothing more we can do. 
					cm:show_advice("wh3_prologue_narrative_12_5_1", true, false, nil, 0, 0.5);
				end,
				false
			)
			
		elseif prologue_load_check == "before_unit_recruitment" then
			SetUpUnitRecruitmentTour()
		end
	end,
	false
);

out("VARIABLE IS SET TO: "..prologue_load_check);
