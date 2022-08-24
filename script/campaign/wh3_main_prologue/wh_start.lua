-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--	This file gets loaded before any of the faction scripts
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- require a file in the factions subfolder that matches the name of our local faction. The model will be set up by the time
-- the ui is created, so we wait until this event to query who the local faction is. This is why we defer loading of our
-- faction scripts until this time.

-------------------------------------------------------
--	load in faction scripts when the game is created
-------------------------------------------------------

cm:add_pre_first_tick_callback(
	function()
		-- only load faction scripts if we have a local faction
		if not cm:get_local_faction_name(true) then
			return;
		end;
				
		-- if the tweaker to force the campaign prelude is set, then set the sbool value as if the tickbox had been ticked on the frontend
		if core:is_tweaker_set("FORCE_FULL_CAMPAIGN_PRELUDE") then
			core:svr_save_bool("sbool_player_selected_first_turn_intro_on_frontend", true);
		end;
		
		-- if the tweaker to force the campaign prelude to the main section is set, then set the corresponding savegame value
		if core:is_tweaker_set("FORCE_CAMPAIGN_PRELUDE_TO_SECOND_PART") then
			core:svr_save_bool("sbool_player_selected_first_turn_intro_on_frontend", true);
			cm:set_saved_value("bool_first_turn_intro_completed", true);
		end;
		
		-- load the faction scripts (or benchmark)
		-- loads the file in script/campaigns/<campaign_name>/factions/<faction_name>/<faction_name>_start.lua
		cm:show_benchmark_if_required(
			function()
				cm:load_local_faction_script("_start");
			end, 
			"campaign_benchmark_prologue"
			-- 348.7,		-- x
			-- 330.9,		-- y
			-- 10,			-- d
			-- 0,			-- b
			-- 10			-- h
		);
		
		--setup_diplomacy();
	end
);



-------------------------------------------------------
--	functions to call when the first tick occurs
-------------------------------------------------------

cm:add_first_tick_callback_new(function() start_new_game_all_factions() end);
cm:add_first_tick_callback(function() start_game_all_factions() end);


-- Called when a new campaign game is started.
-- Put things here that need to be initialised only once, at the start 
-- of the first turn, but for all factions
-- This is run before start_game_all_factions()
function start_new_game_all_factions()
	out("start_new_game_all_factions() called");
	
	-- put the camera at the player's faction leader at the start of a new game
	--cm:position_camera_at_primary_military_force(cm:get_local_faction_name(true));
	cm:set_camera_position(265, 85, 7.6, 0.0, 4.0);
end;




-- Called each time a game is started/loaded.
-- Put things here that need to be initialised each time the game/script is
-- loaded here. This is run after start_new_game_all_factions()
function start_game_all_factions()
	out("start_game_all_factions() called");
	
	out.inc_tab();
	
	-- start all scripted behaviours that should apply across all campaigns
	setup_wh_campaign("script/battle/prologue_battle/battle_start.lua");
	
	out.dec_tab();
end;




-------------------------------------------------------
--	startup diplomacy
-------------------------------------------------------

-- sets up alliances and war between factions on the campaign
function setup_diplomacy()

	-- prevent diplomacy event messages from being generated
	cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
	
	local human_factions = cm:get_human_factions();
	local num_human_factions = #human_factions;
		
	out("");
	
	if num_human_factions == 1 then
		out(" *** setup_diplomacy() called, there is 1 human faction: " .. human_factions[1]);
		out("");
		setup_all_factions_at_war();
	else
		out(" *** setup_diplomacy() called, there are " .. tostring(num_human_factions) .. " human factions:");
		for i = 1, #human_factions do
			out("\t" .. human_factions[i]);
		end;
		
		out("");
		
		if num_human_factions == 2 then
			setup_random_alliances_player_competitive_1v1();
		elseif num_human_factions == 4 then
			setup_predetermined_alliances_player_competitive_2v2();
		end;
	end;
		
	-- allow diplomacy event messages to be generated again
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
end;


-- every faction at war with every other faction
function setup_all_factions_at_war()
	out(" *** Setting every faction at war with every other faction");
	
	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		if faction_list:item_at(i):name() ~= "wh3_prologue_ksl_kislev_survivors" then
			set_faction_at_war_with_all_other_factions(faction_list:item_at(i):name());
		end
	end;
end;


-- ally each player with one non-player faction at random
function setup_random_alliances_player_competitive_1v1()
	
	local faction_list = cm:model():world():faction_list();
	
	-- get a list of non-human factions
	local non_human_factions = {};
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		if not current_faction:is_human() and not current_faction:is_dead() and current_faction:region_list():num_items() > 0 then
			table.insert(non_human_factions, current_faction:name());
		end
	end;
	
	-- randomly sort human faction list
	local human_factions = cm:get_human_factions();
	human_factions = cm:random_sort(human_factions);
	
	-- don't proceed if we have less human factions than non-human
	if #non_human_factions < #human_factions then
		script_error("WARNING: setup_random_alliances_player_competitive_1v1() could find " .. tostring(#human_factions) .. " but only " .. tostring(#non_human_factions) .. " non-human factions, not allying anyone");
		return;
	end;
	
	-- randomly sort non-human faction list
	non_human_factions = cm:random_sort(non_human_factions);
	
	out(" *** Players are playing 1v1 competitive, setting random alliances");
	
	-- set each human faction to be allied to one non-human faction and at war with the rest
	for i = 1, #human_factions do
		out("\t* ALLYING " .. human_factions[i] .. " to " .. non_human_factions[i]);
		cm:force_alliance(human_factions[i], non_human_factions[i], true);
		set_faction_at_war_with_all_other_factions(human_factions[i], non_human_factions[i])
	end;
	
	-- set each non-human faction to be at war with every other non-human faction
	for i = 1, #non_human_factions do
		set_faction_at_war_with_all_other_factions(non_human_factions[i], human_factions);
	end;
	
	out("");
end;


function setup_predetermined_alliances_player_competitive_2v2()
	-- set up specific alliances
	local human_factions = cm:get_human_factions();
	
	out(" *** Players are playing 2v2 competitive, setting specified alliances");
	
	cm:force_alliance(human_factions[1], human_factions[2], true);
	out("\t* ALLYING " .. human_factions[1] .. " to " .. human_factions[2]);
	set_faction_at_war_with_all_other_factions(human_factions[1], human_factions[2])
	set_faction_at_war_with_all_other_factions(human_factions[2], human_factions[1])
	
	cm:force_alliance(human_factions[3], human_factions[4], true);
	out("\t* ALLYING " .. human_factions[3] .. " to " .. human_factions[4]);
	set_faction_at_war_with_all_other_factions(human_factions[3], human_factions[4])
	set_faction_at_war_with_all_other_factions(human_factions[4], human_factions[3])
end;


function setup_random_alliances_player_competitive_2v2()
	-- TBD
end;


-- set the specified faction at war with all other factions in the campaign, with the exception of those in the supplied list (list can also be a single string)
function set_faction_at_war_with_all_other_factions(faction_name, exception_list)
	local faction = cm:get_faction(faction_name);
	
	if not (faction and not faction:is_dead()) then
		return;
	end;

	local faction_list = cm:model():world():faction_list();
	
	if not is_table(exception_list) then
		exception_list = {exception_list};
	end;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:is_dead() then
			local current_faction_name = current_faction:name();
			
			local exclude_current_faction = false;
			
			if current_faction_name == faction_name then
				exclude_current_faction = true;
			else
				for j = 1, #exception_list do
					if exception_list[j] == current_faction_name then
						exclude_current_faction = true;
						break;
					end;
				end;
			end;
			
			if not exclude_current_faction then
				out("\t * " .. faction_name .. " is now at war with " .. current_faction_name);
				if current_faction_name ~= "wh3_prologue_ksl_kislev_survivors" then
					cm:force_declare_war(faction_name, current_faction_name, false, false);
				end
			end;
		end;
	end;
end;







--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

prologue_cheat = false;
prologue_garrison = false;
test_building = "";
building_complete = false;
recruited = false;
units_recruited = 0;
money_low = false;
enemy_faction_name = "wh3_prologue_gharhars";
enemy_army_cqi = 0;
found_agent = false;
new_objective = false;
open_settlement_taken = "";
dialogue_in_progress = false;
prologue_player_faction = "wh3_prologue_kislev_expedition";
prologue_current_objective = "";
prologue_current_advice = "";
prologue_current_army_cap = 8;
prologue_player_cqi = 0; 
prologue_load_check = "";
prologue_active_text_pointer = "";
prologue_trials_completed = 0;
prologue_yuri_dead = false;
prologue_show_compass = false;
prologue_next_quote = 0;
building_in_progress = false;
prologue_story_choice = 0;
prologue_mission_complete = false;
prologue_trial_mission = "";
prologue_number_of_buildings_constructed = 0;
prologue_number_of_skill_points_spent = 0;
prologue_trigger_linger = 0;


--These are only used in the prologue
prologue_check_progression = {
["first_settlement_revealed"] = false,
["found_debris"] = false,
["occupied_settlement"] = false,
["main_building_in_progress"] = false,
["main_building_mission_triggered"] = false,
["main_building_built"] = false,
["trouble_dilemma_triggered"] = false,
["enemy_sieging"] = false,
["special_building_built"] = false,
["special_building_in_progress"] = false,
["industry_building_in_progress"] = false,
["second_settlement_revealed"] = false,
["second_battle_complete"] = false,
["st_skill_point_complete"] = false,
["second_tutorial_army_created"] = false,
["agent_tutorial_complete"] = false,
["dervingard_battle_complete"] = false,
["open_world"] = false,
["shield_tutorial_complete"] = false,
["lucent_maze_complete"] = false,
["ice_maiden_embedded"] = false,
["brazen_altar_battle_complete"] = false,
["fought_first_open_battle"] = false,
["found_ice_maiden_qb"] = false,
["pre_battle_first_siege"] = false,
["pre_battle_first_siege_without_equipment"] = false,
["upkeep_intervention"] = false,
["triggered_reclaim_mission"] = false,
["triggered_mansion_of_eyes_mission"] = false,
["completed_mansion_of_eyes_mission"] = false,
["recruit_reminder"] = false,
["scripted_tour_reinforcements"] = false,
["lord_recruitment"] = false,
["first_stage_1_load"] = false,
["legendary_lord_death"] = false,
["lord_death"] = false,
["ap_bar"] = false,
["first_load"] = false,
["first_load_interventions"] = false,
["first_load_story_panels"] = false,
["recruited_units_tutorial_complete"] = false,
["spawned_patriarch"] = false,
["completed_ice_maiden_mission"] = false,
["triggered_ice_maiden_mission"] = false,
["completed_patriarch_mission"] = false,
["triggered_patriarch_mission"] = false,
["completed_mission_raid_region"] = false,
["quest_battle_explained"] = false,
["triggered_diplomacy"] = false,
["income_reminder"] = false,
["item_scripted_tour"] = false,
["item_generation"] = false,
["equipped_sword"] = false,
["triggered_fear_dilemma"] = false,
["first_demon_combat"] = false,
["taken_tribal_settlement"] = false,
["st_income_complete"] = false,
["lord_death_commanding"] = false,
["st_switch_commanders"] = false,
["st_quest_battle_loss"] = false,
["st_recruitment"] = false,
["st_quest_battle_enemy_stronger"] = false,
["besieged_once"] = false,
["besieged_twice"] = false,
["second_battle"] = false,
["help_reminder"] = false,
["killed_gerik"] = false,
["technology_research_started"] = false,
["new_lord_recruit_advice"] = false,
["lucent_maze_pre_battle"] = false,
["close_to_lucent_maze"] = false,
["completed_screaming_chasm_objective"] = false,
["triggered_screaming_chasm_objective"] = false,
["stage_6_area_triggers"] = false,
["stage_5_area_triggers"] = false,
["stage_4_area_triggers"] = false,
["stage_3_area_triggers"] = false,
["stage_2_area_triggers"] = false,
["stage_1_area_triggers"] = false

}


--These are overrides in the campaign_ui_overrides file
prologue_tutorial_passed = {
["technology_with_button_hidden"] = false,
["radar_map"] = false,
["faction_bar"] = false,
["other_factions_with_button_hidden"] = false,
["regions_with_button_hidden"] = false,
["lords_with_button_hidden"] = false,
["end_turn_skip_with_button_hidden"] = false,
["end_turn_previous_with_button_hidden"] = false,
["end_turn_next_with_button_hidden"] = false,
["character_details_with_button_hidden"] = false,
["resources_bar"] = false,
["end_turn_settings_with_button_hidden"] = false,
["skills_with_button_hidden"] = false,
["help_pages_with_button_hidden"] = false,
["missions_with_button_hidden"] = false,
["settlement_panel_help_with_button_hidden"] = false,
["units_panel"] = false,
["units_panel_small_bar"] = false,
["units_panel_small_bar_buttons"] = false,
["units_panel_recruit_with_button_hidden"] = false,
["units_panel_docker"] = false,
["settlement_panel_hero_recruit_with_button_hidden"] = false,
["settlement_panel_lord_recruit_with_button_hidden"] = false,
["settlement_panel_building_browser_with_button_hidden"] = false,
["settlement_panel_garrison_with_button_hidden"] = false,
["pre_battle_save_with_button_hidden"] = false,
["pre_battle_help_with_button_hidden"] = true,
["pre_battle_general_details_with_button_hidden"] = true,
["pre_battle_rank_with_button_hidden"] = false,
["pre_battle_autoresolve_with_button_hidden"] = false,
["pre_battle_retreat_with_button_hidden"] = false,
["demolish_with_button_hidden"] = false,
["tactical_map"] = false,
["siege_turns"] = false,
["province_info_panel"] = false,
["stances_with_button_hidden"] = false,
["end_turn_notification"] = false,
["stance_encamp"] = true,
["prebattle_continue_with_button_hidden"] = false,
["campaign_flags_strength_bars"] = false,
["postbattle_kill_captives_with_button_hidden"] = false,
["postbattle_middle_panel"] = false,
["diplomacy_with_button_hidden"] = false,
["regiments_of_renown_visible"] = false,
["hide_diplomacy_war_coordination"] = false,
["mouse_over_info_city_info_bar"] = false,
["building_browser"] = false,
["toggle_move_speed"] = false,
["disband_unit"] = false,
["hide_campaign_unit_information"] = false
}

-- These are the names of the RoR unit panels in the prologue.
prologue_regiments_of_renown = {
["wh3_main_pro_ksl_mon_elemental_bear_ror_0_recruitable"] = false, -- Unlocked
["wh3_main_pro_ksl_inf_ice_guard_ror_1_recruitable"] = false, -- Unlocked
["wh3_main_pro_ksl_inf_ice_guard_ror_0_recruitable"] = false, -- Glaives, Unlocked
["wh3_main_pro_ksl_veh_heavy_war_sled_ror_0_recruitable"] = false, -- Unlocked
["wh3_main_pro_ksl_cav_gryphon_legion_ror_0_recruitable"] = false, -- Unlocked
["wh3_main_pro_ksl_veh_light_war_sled_ror_0_recruitable"] = false, -- Unlocked
["wh3_main_pro_ksl_mon_snow_leopard_ror_0_recruitable"] = false, -- Unlocked
}

prologue_initial_loot = {
	"wh3_prologue_anc_follower_pathfinder",
	"wh3_prologue_anc_follower_quartermaster",
	"wh3_prologue_anc_follower_camp_cook",
	"wh3_prologue_anc_follower_babushka",
}

loading_screen_list = {
"prologue_kurnz_diary_01"
}

prologue_event_activation = {
	["character_dies_battle"] = false,
	["character_rank_gained"] = false,
	["diplomacy_faction_destroyed"] = false
}

prologue_end_turn_event_suppression = {
	["ECONOMICS_PROJECTED_NEGATIVE"] = false,
	["ECONOMICS_PROJECTED_NEGATIVE_WITH_DIPLOMATIC_EXPENDITURE"] = false,
	["ALLIED_BUILDINGS_CONSTRUCTION_AVAILABLE"] = false,
	["PROVINCES_NO_CONSTRUCTION_PROJECT"] = false,
	["DAMAGED_BUILDING"] = false,
	["ARMY_AP_AVAILABLE"] = false,
	["CHARACTER_TRAINING_ACTIVE_DILEMMA"] = false,
	["CHARACTER_UPGRADE_AVAILABLE"] = false,
	["GARRISONED_ARMY_AP_AVAILABLE"] = false,
	["HERO_AP_AVAILABLE"] = false,
	["COMMANDMENT_AVAILABLE"] = false,
	["COMPASS_DIRECTION_AVAILABLE"] = false,
	["MILITARY_FORCE_MORALE_LOW"] = false,
	["MISSION_CATEGORY_AVAILABLE"] = false,
	["IMMINENT_REBELLION"] = false,
	["SIEGE_NO_EQUIPMENT"] = false,
	["NOT_RESEARCHING_TECH"] = false
}

prologue_achievements = {
	["WH3_ACHIEVEMENT_PROLOGUE_ARMY_CAP"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_BATTLE_WIN"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_BUILDING_CONSTRUCTION"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_ITEMS"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_SECOND_GENERAL"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_CAPTURE"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_UPGRADE"] = false,
	["WH3_ACHIEVEMENT_PROLOGUE_SKILL_POINTS"] = false
}

prologue_audio_timing = {}

TRAIT_LORDS_RECORDS = {};

cm:add_saving_game_callback(
	function(context)
		--script_error("add_saving_game_callback() called");
		cm:save_named_value("test_building", test_building, context);
		cm:save_named_value("building_complete", building_complete, context);
		cm:save_named_value("recruited", recruited, context);
		cm:save_named_value("units_recruited", units_recruited, context);
		cm:save_named_value("prologue_tutorial_passed", prologue_tutorial_passed, context);
		cm:save_named_value("prologue_check_progression", prologue_check_progression, context);
		cm:save_named_value("prologue_current_objective", prologue_current_objective, context);
		cm:save_named_value("prologue_current_advice", prologue_current_advice, context);
		cm:save_named_value("money_low", money_low, context);
		cm:save_named_value("prologue_player_cqi", prologue_player_cqi, context);
		cm:save_named_value("enemy_army_cqi", enemy_army_cqi, context);
		cm:save_named_value("new_objective", new_objective, context);
		cm:save_named_value("open_settlement_taken", open_settlement_taken, context);
		cm:save_named_value("dialogue_in_progress", dialogue_in_progress, context);
		cm:save_named_value("loading_screen_list", loading_screen_list, context);
		cm:save_named_value("prologue_cheat", prologue_cheat, context);
		cm:save_named_value("prologue_garrison", prologue_garrison, context);
		cm:save_named_value("prologue_audio_timing", prologue_audio_timing, context);
		cm:save_named_value("prologue_load_check", prologue_load_check, context);
		cm:save_named_value("prologue_current_army_cap", prologue_current_army_cap, context);
		cm:save_named_value("prologue_regiments_of_renown", prologue_regiments_of_renown, context);
		cm:save_named_value("TRAIT_LORDS_RECORDS", TRAIT_LORDS_RECORDS, context);
		cm:save_named_value("prologue_trials_completed", prologue_trials_completed, context);
		cm:save_named_value("prologue_yuri_dead", prologue_yuri_dead, context);
		cm:save_named_value("prologue_show_compass", prologue_show_compass, context);
		cm:save_named_value("prologue_initial_loot", prologue_initial_loot, context);
		cm:save_named_value("prologue_next_quote", prologue_next_quote, context);
		cm:save_named_value("building_in_progress", building_in_progress, context);
		cm:save_named_value("prologue_event_activation", prologue_event_activation, context);
		cm:save_named_value("prologue_story_choice", prologue_story_choice, context);
		cm:save_named_value("prologue_end_turn_event_suppression", prologue_end_turn_event_suppression, context);
		cm:save_named_value("prologue_mission_complete", prologue_mission_complete, context);
		cm:save_named_value("prologue_trial_mission", prologue_trial_mission, context);
		cm:save_named_value("prologue_achievements", prologue_achievements, context);
		cm:save_named_value("prologue_number_of_buildings_constructed", prologue_number_of_buildings_constructed, context);
		cm:save_named_value("prologue_number_of_skill_points_spent", prologue_number_of_skill_points_spent, context);
		cm:save_named_value("prologue_trigger_linger", prologue_trigger_linger, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		test_building = cm:load_named_value("test_building", "", context);
		building_complete = cm:load_named_value("building_complete", false, context);
		recruited = cm:load_named_value("recruited", false, context);
		units_recruited = cm:load_named_value("units_recruited", 0, context);
		prologue_tutorial_passed = cm:load_named_value("prologue_tutorial_passed", prologue_tutorial_passed, context);
		prologue_check_progression = cm:load_named_value("prologue_check_progression", prologue_check_progression, context);
		prologue_current_objective = cm:load_named_value("prologue_current_objective", "", context);
		prologue_current_advice = cm:load_named_value("prologue_current_advice", "", context);
		money_low = cm:load_named_value("money_low", false, context);
		prologue_player_cqi = cm:load_named_value("prologue_player_cqi", 0, context);
		enemy_army_cqi = cm:load_named_value("enemy_army_cqi", 0, context);
		new_objective = cm:load_named_value("new_objective", false, context);
		open_settlement_taken = cm:load_named_value("open_settlement_taken", "", context);
		dialogue_in_progress = cm:load_named_value("dialogue_in_progress", false, context);
		loading_screen_list = cm:load_named_value("loading_screen_list", loading_screen_list, context);
		prologue_cheat = cm:load_named_value("prologue_cheat", false, context);
		prologue_garrison = cm:load_named_value("prologue_garrison", false, context);
		prologue_audio_timing = cm:load_named_value("prologue_audio_timing", prologue_audio_timing, context);
		prologue_load_check = cm:load_named_value("prologue_load_check", prologue_load_check, context);
		prologue_current_army_cap = cm:load_named_value("prologue_current_army_cap", 8, context);
		prologue_regiments_of_renown = cm:load_named_value("prologue_regiments_of_renown", prologue_regiments_of_renown, context);
		TRAIT_LORDS_RECORDS = cm:load_named_value("TRAIT_LORDS_RECORDS", {}, context);
		prologue_trials_completed = cm:load_named_value("prologue_trials_completed", 0, context);
		prologue_yuri_dead = cm:load_named_value("prologue_yuri_dead", false, context);
		prologue_show_compass = cm:load_named_value("prologue_show_compass", false, context);
		prologue_initial_loot = cm:load_named_value("prologue_initial_loot", {}, context);
		prologue_next_quote = cm:load_named_value("prologue_next_quote", 0, context);
		building_in_progress = cm:load_named_value("building_in_progress", false, context);
		prologue_event_activation = cm:load_named_value("prologue_event_activation", prologue_event_activation, context);
		prologue_story_choice = cm:load_named_value("prologue_story_choice", 0, context);
		prologue_end_turn_event_suppression = cm:load_named_value("prologue_end_turn_event_suppression", {}, context);
		prologue_mission_complete = cm:load_named_value("prologue_mission_complete", false, context);
		prologue_trial_mission = cm:load_named_value("prologue_trial_mission", "", context);
		prologue_achievements = cm:load_named_value("prologue_achievements", {}, context);
		prologue_number_of_buildings_constructed = cm:load_named_value("prologue_number_of_buildings_constructed", 0, context);
		prologue_number_of_skill_points_spent = cm:load_named_value("prologue_number_of_skill_points_spent", 0, context);
		prologue_trigger_linger = cm:load_named_value("prologue_trigger_linger", 0, context);
	end
);