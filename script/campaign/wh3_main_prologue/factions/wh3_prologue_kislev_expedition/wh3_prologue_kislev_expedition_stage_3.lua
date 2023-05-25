


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

prologue_player_cqi = cm:get_faction(cm:get_local_faction_name()):faction_leader():cqi();

PrologueInitialDisabling();

cm:cai_disable_movement_for_faction("wh3_prologue_apostles_of_change");
cm:cai_disable_movement_for_faction("wh3_prologue_the_sightless");
cm:cai_disable_movement_for_faction("wh3_prologue_tong");
cm:cai_disable_movement_for_faction("wh3_prologue_the_tahmaks");
cm:cai_disable_movement_for_faction("wh3_prologue_the_kvelligs");
cm:cai_disable_movement_for_faction("wh3_prologue_great_eagle_tribe");
cm:cai_disable_movement_for_faction("wh3_prologue_blood_keepers");
cm:cai_disable_movement_for_faction("wh3_prologue_sarthoraels_watchers");

prologue_tutorial_passed["pre_battle_autoresolve_with_button_hidden"] = false;
uim:override("pre_battle_autoresolve_with_button_hidden"):set_allowed(false);

-- add a marker for the second petrenko army
if prologue_check_progression["stage_3_area_triggers"] == false then
	cm:add_circle_area_trigger(280, 188, 10, "dervingard_marker", "", true, false, true);
	prologue_check_progression["stage_3_area_triggers"] = true
end

CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_minor");
CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");

--disable enemy killed in battle event
cm:disable_event_feed_events(true, "", "", "character_dies_battle"); 

disable_event_type(false, "character_rank_gained");

uim:override("campaign_flags"):set_allowed(true);

local faction = cm:get_faction(enemy_faction_name)
local observation_options = cm:model():world():observation_options_for_faction(faction, faction);
local test = observation_options:armies_options();
test:set_camera_follow_behaviour("OFF");
observation_options:set_armies_options(test);
cm:set_character_observation_options_for_faction(faction, observation_options);

-- Enable unit experience.
cm:set_unit_experience_disabled(false)


-- set the postbattle camera
--cm:set_prebattle_display_configuration_override(328.681976,11.544293,-4.195538,10.0,10.0);--distance,height,angle,scale,separation


if core:svr_load_bool("second_prologue_battle_just_fought") then
	out("");
	out("*** Second prologue battle just fought - applying battle results ***");

	-- prevent result from being re-applied
	core:svr_save_bool("second_prologue_battle_just_fought", false);

	-- attempt to spoof results from battle
	local character = cm:get_character_by_cqi(prologue_player_cqi);
	if character then
		cm:load_army_state_from_svr("player_army", character:military_force():command_queue_index(), true);
	else
		script_error("WARNING: Attempted to spoof battle results through script from the second prologue battle for the player army but no player character with cqi [" .. tostring(prologue_player_cqi) .. "] could be found? How can this be?");
	end;
	out("");
end;


core:add_listener(
	"prologue_battle_completed",
	"CharacterCompletedBattle",
	true,
	function(context)
		out("MADE IT TOR STEAGE 3")
		if prologue_check_progression["second_battle_complete"] == false then
			-- remove the flag that triggers the tutorial battle
			cm:remove_custom_battlefield("intro_battle_2");

			cm:replenish_action_points("faction:"..enemy_faction_name..",forename:709990315", 0)

			--core:remove_listener("autoresolve_button_listener_post");

			prologue_tutorial_passed["hide_campaign_unit_information"] = true;
			uim:override("hide_campaign_unit_information"):set_allowed(true);

			PrologueAfterSecondBattle();

			uim:override("disable_help_pages_panel_button"):set_allowed(false);

			if core:svr_load_bool("sbool_prologue_second_battle_loaded_in") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(47, "second_battle_loaded_in", false);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_read_unit_cards_tutorial") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(48, "second_battle_read_unit_cards_tutorial", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_finished_deployment_step") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(49, "second_battle_finished_deployment_step", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_started_battle") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(50, "second_battle_started_battle", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_claimed_high_ground") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(51, "second_battle_claimed_high_ground", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_read_unit_details_tutorial") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(52, "second_battle_read_unit_details_tutorial", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_won") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(53, "second_battle_won", true);
			end
			if core:svr_load_bool("sbool_prologue_second_battle_skipped") then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(54, "second_battle_skipped", true);
			end
			
		else
			PrologueLosingDervingardBattle(context);
		end
	end,
	false
);

core:add_listener(
	"post_battle_panel_opened_2",
	"PanelOpenedCampaign",
	function(context) 
		return context.string == "popup_battle_results" 
	end,
	function()

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
	end,
	true	
);



core:add_listener(
	"AreaEntered_Prologue_Open",
	"AreaEntered", 
	true,
	function(context)
		if context:area_key() == "dervingard_marker" then
			-- Found Dervingard
			if cm:model():is_player_turn() then
				skip_all_scripted_tours();
				prologue_advice_dervingard_revealed_001();
			end
		end
	end,
	true
);

core:add_listener(
	"CharacterConvalescedOrKilled_Prologue_stage3",
	"CharacterConvalescedOrKilled", 
	true,
	function(context)
		if context:character():cqi() == prologue_player_cqi then
			out("YURI DIED")

			cm:stop_character_convalescing(prologue_player_cqi);

			--[[cm:create_force_with_general(
				prologue_player_faction, 
				"wh3_main_pro_ksl_inf_tzar_guard_0,wh3_main_pro_ksl_inf_tzar_guard_0,wh3_main_pro_ksl_inf_kossars_0,wh3_main_pro_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_tutorial_1,wh3_main_ksl_inf_kossars_tutorial_1,wh3_main_ksl_inf_kossars_tutorial_1", 
				"wh3_prologue_region_frozen_plains_dervingard", 
				424, 
				242,
				"general",
				"wh3_main_pro_ksl_yuri_0",
				"names_name_1643960929",
				"",
				"names_name_89806305",
				"",
				false,
				function(cqi)
					prologue_player_cqi = cqi;
					out("CREATED YURI ARMY")
					
				end
			);]]
			
		end
	end,
	true
);

core:add_listener(
	"PanelOpenedCampaign_pre_battle_screen_stage_3",
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_pre_battle" end,
	function()
		local retreat_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_set_siege", "button_retreat");

		if retreat_button then
			retreat_button:SetVisible(false);
		end

		local uic_siege_panel = find_uicomponent(core:get_ui_root(), "mid", "siege_information_panel");
		if uic_siege_panel then
			uic_siege_panel:SetVisible(false);
		end

		cm:disable_saving_game(true)

		PrologueRemoveObjective();

		--Metric check (step_number, step_name, skippable)
		cm:trigger_prologue_step_metrics_hit(57, "initiated_dervingard_battle", false);

		PrologueSetPreBattleScreen("dervingard_title");
		local title_bar_holder = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder");
		local title_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "prologue_title_holder", "prologue_title");
		if title_bar_holder then
			title_bar_holder:SetVisible(true);
		end
		if title_bar then
			title_bar:SetVisible(true);
		end

		cm:set_character_experience_disabled(false);

		disable_key_battle_events(true)

		HideWolvesOnPreBattleScreen()

		HideGarrisonOnPopUp()
	end,
	true
);


core:add_listener(
	"CharacterSkillPointAllocated_Prologue",
	"CharacterSkillPointAllocated", 
	true,
	function(context)
		if cm:model():is_player_turn() then
			if prologue_check_progression["st_skill_point_complete"] == false then
				-- complete the mission to use a skill point
				prologue_check_progression["st_skill_point_complete"] = true;
				--PrologueRemoveObjective()
				cm:remove_objective("wh3_prologue_objective_turn_016_01");
			end
		end
	end,
	true
);

do
	local played_pre_battle_dialogue = false
	
	core:add_listener(
		"PanelOpenedCampaign_pre_battle_screen",
		"PanelOpenedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			if not played_pre_battle_dialogue then prologue_advice_dervingard_pre_battle_001() end
			played_pre_battle_dialogue = true

			local player_army_panel = find_uicomponent(core:get_ui_root(), "allies_combatants_panel");
			local enemy_army_panel = find_uicomponent(core:get_ui_root(), "enemy_combatants_panel");

			if player_army_panel and enemy_army_panel then
				player_army_panel:SetCanResizeHeight(true);
				enemy_army_panel:SetCanResizeHeight(true);
				player_army_panel:Resize(player_army_panel:Width(), 450);
				enemy_army_panel:Resize(enemy_army_panel:Width(), 450);
			end

		end,
		true
	);
end

core:add_listener(
	"post_battle_button_listener_dervingard",
	"ComponentLClickUp",
	function(context) return context.string == "button_attack" end,
	function()
		out("STARTING DERVINGARD TUTORIAL BATTLE")

		-- set loading screen. This is also set in the battle_start of this battle. It needs to match.
		common.setup_dynamic_loading_screen("prologue_battle_dervingard_intro", "prologue")


		--cm:win_next_autoresolve_battle(cm:get_local_faction_name());
		--[[cm:modify_next_autoresolve_battle(
			1, 			-- attacker win chance
			0,	 		-- defender win chance
			0,	 		-- attacker losses modifier
			5,			-- defender losses modifier
			false
		);]]
		-- ensure the next battle we load (i.e. the one we're immediately about to launch) is the intro battle
		remove_generic_battle_script_override();

		local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
		if new_player then
			cm:add_custom_battlefield(
				"intro_battle_dervingard",												-- string identifier
				0,																-- x co-ord
				0,																-- y co-ord
				5000,															-- radius around position
				false,															-- will campaign be dumped
				"",									-- loading override
				"script/battle/scenario_battles/prologue_dervingard/battle_start.lua",																-- script override
				"",		-- entire battle override
				0,																-- human alliance when battle override
				false,															-- launch battle immediately
				true,															-- is land battle (only for launch battle immediately)
				false															-- force application of autoresolver result
			);
		else
			cm:add_custom_battlefield(
				"intro_battle_dervingard",												-- string identifier
				0,																-- x co-ord
				0,																-- y co-ord
				5000,															-- radius around position
				false,															-- will campaign be dumped
				"",									-- loading override
				"script/battle/scenario_battles/prologue_dervingard/battle_start_no_tutorial.lua",																-- script override
				"",		-- entire battle override
				0,																-- human alliance when battle override
				false,															-- launch battle immediately
				true,															-- is land battle (only for launch battle immediately)
				false															-- force application of autoresolver result
			);
		end

	end,
	true
);

core:add_listener(
	"autoresolve_button_listener_post",
	"ComponentLClickUp",
	function(context) return context.string == "button_autoresolve" end,
	function()
		out("STARTING AUTORESOLVE LISTENER")
		cm:set_saved_value("bool_load_post_tzeentch_campaign", true)
		cm:set_saved_value("bool_load_post_open_campaign", false)
		cm:load_local_faction_script("_stage_4", true);
	end,
	false
);

core:add_listener(
	"autoresolve_button_listener_intro",
	"ComponentLClickUp",
	function(context) return context.string == "dev_button_win_battle" end,
	function()
		out("STARTING AUTORESOLVE LISTENER")
		cm:set_saved_value("bool_load_post_tzeentch_campaign", true)
		cm:set_saved_value("bool_load_post_open_campaign", false)
		cm:load_local_faction_script("_stage_4", true);
	end,
	false
)


function PrologueListenerForUpkeep()

	core:add_listener(
	"FactionTurnStart_PreDervingard",
	"FactionTurnStart",
	true,
	function(context)
		if context:faction():name() == prologue_player_faction then
			-- This intervention is to remind the player about recruitment and the relationship between upkeep and their army size.
			--core:trigger_event("ScriptEventUpkeep")
		end
	end,
	true
	)
end

if prologue_check_progression["upkeep_intervention"] == false and prologue_check_progression["triggered_reclaim_mission"] == true then
	PrologueListenerForUpkeep()
end

function PrologueAfterSecondBattle()
	prologue_check_progression["second_battle_complete"] = true;

	-- Stop characters from being selected. This is disabled in _interventions in prologue_skills
	uim:enable_character_selection_whitelist()


	core:add_listener(
		"PostbattleRewardAnimationsFinished_Prologue2",
		"PostbattleRewardAnimationsFinished",
		true,
		function(context)
			prologue_advice_after_second_battle_post_battle_001();
		end,
		false
	);
	

	core:add_listener(
		"Open_FactionTurnStart_Prologue",
		"FactionTurnStart",
		true,
		function(context)
			if context:faction():name() == prologue_player_faction then

				uim:override("disable_help_pages_panel_button"):set_allowed(false);
				
				cm:disable_saving_game(true)
				--Enable exp
				cm:set_character_experience_disabled(false);
				cm:add_agent_experience(cm:char_lookup_str(prologue_player_cqi), 1000)
				cm:set_character_experience_disabled(true);
				out("ADDING XP");

				-- A wait is needed here, otherwise there's overlap with the amount of messages.
				cm:callback(function() prologue_advice_second_fight(); end, 1)
				
				core:remove_listener("Open_FactionTurnStart_Prologue");

				-- Disble the end turn button
				uim:override("end_turn"):set_allowed(false);

			end
		end,
		true
	);
end

function PrologueListenerToJoinGarrison()
	core:add_listener(
		"FactionTurnStart_Prologue_enemy_turn_open",
		"FactionBeginTurnPhaseNormal",
		true,
		function(context)
			if context:faction():name() == enemy_faction_name then 
				out("TRYING TO JOIN GARRISON")
				cm:enable_movement_for_faction(enemy_faction_name);
				cm:join_garrison("character_cqi:"..enemy_army_cqi, "settlement:wh3_prologue_frozen_plains_dervingard");
				core:add_listener(
					"CharacterEntersGarrison_Prologue_open",
					"CharacterEntersGarrison",
					true,
					function(context)
						if context:character():faction():name() == enemy_faction_name then
							core:remove_listener("FactionTurnStart_Prologue_enemy_turn_open");
							cm:cai_disable_movement_for_faction(enemy_faction_name);
						end
					end,
					true
				)
			end
		end,
		true
	);
end

function HideGarrisonOnPopUp()
	local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
	if uic then uic:SetVisible(false) end
end

if prologue_check_progression["second_battle_complete"] == true then
	PrologueListenerToJoinGarrison();
end

function PrologueLosingDervingardBattle(context)
	out("LOST BATTLE")
end

function HideWolvesOnPreBattleScreen()
	local uic_units = find_uicomponent("popup_pre_battle", "enemy_combatants_panel", "units_and_banners_parent", "commander_header_0", "units")
	if uic_units then
		for i = 0, uic_units:ChildCount() - 1 do
			if i >= (uic_units:ChildCount() - 2) then
				local uic_child = UIComponent(uic_units:Find(i))
				uic_child:SetVisible(false)
			end
		end
	end
end

---------------------------------------------------------------
----------------- Load Check Functions ------------------------
---------------------------------------------------------------

function load_check_found_dervingard ()

	core:add_listener(
		"FactionTurnStart_Event_attack_dervingard",
		"FactionTurnStart",
		true,
		function(context)

			if context:faction():name() == prologue_player_faction then
				cm:disable_pathfinding_restriction(4);

				-- Load check for when Skollden retreats.
				prologue_load_check = "skollden_retreated"

				-- After player attacks settlement, new load check.
				local player_besieging_derv = false
				core:add_listener(
					"CharacterBesiegesSettlementFirstSiegeIntervention",
					"CharacterBesiegesSettlement",
					true,
					function () player_besieging_derv = true; PrologueRemoveObjective() end,
					false
				)
				PrologueAddTopicLeader("wh3_prologue_objective_turn_015_02", function() if player_besieging_derv then cm:remove_objective("wh3_prologue_objective_turn_015_02") end end)

				core:remove_listener("FactionTurnStart_Event_attack_dervingard");

				local enemy_army_list = cm:model():world():faction_by_key(enemy_faction_name):military_force_list();
			
				for i = 0, enemy_army_list:num_items() - 1 do
					if enemy_army_list:item_at(i):upkeep() == 0 then
						out("FOUND GARRISON");

						local enemy_garrison_character = cm:char_lookup_str(enemy_army_list:item_at(i):general_character():command_queue_index())

						cm:remove_unit_from_character(enemy_garrison_character, "wh_dlc08_nor_inf_marauder_champions_0")
						--cm:remove_unit_from_character(enemy_garrison_character, "wh_main_nor_inf_chaos_marauders_1")
						--cm:remove_unit_from_character(enemy_garrison_character, "wh_main_nor_inf_chaos_marauders_0")
						--cm:remove_unit_from_character(enemy_garrison_character, "wh_dlc08_nor_inf_marauder_spearman_0")
						--cm:remove_unit_from_character(enemy_garrison_character, "wh_dlc08_nor_inf_marauder_spearman_0")
					end
				end
			end
		end,
		true
	);
end

core:add_listener(
	"LoadingScreenDismissed_Prologue_intro_post",
	"LoadingScreenDismissed",
	true,
	function()
		uim:override("esc_menu"):set_allowed(true);
		HideGarrisonOnPopUp()
		
		if prologue_load_check == "after_skills" then		
			cm:callback(function() cm:set_objective("wh3_prologue_objective_turn_015_01"); end, 3);

			cm:disable_pathfinding_restriction(3);
			
			-- Add help reminder to make sure it gets seen before Dervingard
			AddHelpReminder()
			
		elseif prologue_load_check == "found_dervingard" then
			-- Add help reminder to make sure it gets seen before Dervingard
			AddHelpReminder()

			load_check_found_dervingard()

			PrologueAddTopicLeader("wh3_prologue_objective_turn_001_06", function() HighlightEndTurnButton() end, true)
		elseif prologue_load_check == "during_skills" then
			local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
			if new_player then
				cm:callback(function () 
				prologue_intervention_skills:start(); 
				core:trigger_event("ScriptEventPrologueSkills") end, 0.2)
			end
		elseif prologue_load_check == "skollden_retreated" then
			-- Add help reminder to make sure it gets seen before Dervingard
			AddHelpReminder()

			-- Remove area by Dervingard.
			cm:disable_pathfinding_restriction(4);

			-- After player attacks settlement, remove objective
			local player_besieging_derv = false
			core:add_listener(
				"CharacterBesiegesSettlementFirstSiegeIntervention",
				"CharacterBesiegesSettlement",
				true,
				function () player_besieging_derv = true; PrologueRemoveObjective() end,
				false
			)
			PrologueAddTopicLeader("wh3_prologue_objective_turn_015_02", function() if player_besieging_derv then cm:remove_objective("wh3_prologue_objective_turn_015_02") end end)
		end

		HideWolvesOnPreBattleScreen()
	end,
	false
);

out("VARIABLE IS SET TO: "..prologue_load_check);


