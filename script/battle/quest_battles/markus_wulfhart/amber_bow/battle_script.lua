-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Markus Wulfhart
-- Amber Bow
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/tab_wulfhart_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player.sunits,					-- unitcontroller over player's army
		40000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/tab_wulfhart_01.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_01", "subtitle_with_frame", 2) end, 3250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 7300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 8500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_02", "subtitle_with_frame", 3) end, 8750);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 17000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_03", "subtitle_with_frame", 3.5) end, 17250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 24400);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_04", "subtitle_with_frame", 2.5) end, 24650);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 33000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_amber_bow_pt_05", "subtitle_with_frame", 3) end, 33250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 38000);
	
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
empire_ally = gb:get_army(gb:get_player_alliance_num(),"empire_ally");
empire_reinforcements = gb:get_army(gb:get_player_alliance_num(),"empire_reinforcements");

enemy_main = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main");
enemy_walls = gb:get_army(gb:get_non_player_alliance_num(),"enemy_walls");
enemy_port = gb:get_army(gb:get_non_player_alliance_num(),"enemy_port");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
empire_ally:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_port:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
empire_ally:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
empire_ally:change_behaviour_active_on_message("01_intro_cutscene_end", "skirmish", false, false);
enemy_port:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--enemy_main and enemy_port defend positions
enemy_port:defend_on_message("01_intro_cutscene_end",207.1,-545.5, 75);
enemy_walls:release_on_message("01_intro_cutscene_end", 10);
empire_ally:release_on_message("01_intro_cutscene_end", 10);

------------------------------------------------------------------------
------------------------- PORT REINFORCEMENTS --------------------------
------------------------------------------------------------------------

--enemy_port receives casualties release them from defend command
enemy_port:message_on_rout_proportion("enemy_port_release", 0.2);
enemy_port:release_on_message("enemy_port_release", 10);

--if enemy_port is "distracted"/injured allow reinforcements
enemy_port:message_on_rout_proportion("enemy_port_removed", 0.5);
enemy_port:message_on_rout_proportion("enemy_port_routed", 0.8);
enemy_port:message_on_proximity_to_position("enemy_port_removed", v(85, 25, -390), 30);
enemy_port:message_on_proximity_to_position("enemy_port_removed", v(230, 11, -350), 30);

--5 minute port rescue countdown starts
gb:message_on_time_offset("port_countdown", 300000, "01_intro_cutscene_end")
--reinforce if enemy_port defeated
empire_reinforcements:reinforce_on_message("enemy_port_removed", 1000);
empire_reinforcements:release_on_message("enemy_port_removed", 2000);
--if port defenders rout block countdown, if 5 minute countdown ends block rout message
gb:block_message_on_message("port_countdown", "enemy_port_removed", true);
gb:block_message_on_message("enemy_port_removed", "port_countdown", true);

------------------------------------------------------------------------
--------------------- WALL DEFENDERS ARMY ABILITY ----------------------
------------------------------------------------------------------------

--if enemy_walls routs allows empire_ally to retreat and gain army ability
enemy_walls:message_on_rout_proportion("enemy_walls_routed", 0.8);
empire_ally:message_on_rout_proportion("empire_ally_routed", 1);

--start routing ally over 5 minutes time
empire_ally:rout_over_time_on_message("01_intro_cutscene_end", 300000);

--retreat allies if enemy_walls defeated
empire_ally:rout_over_time_on_message("enemy_walls_routed", 500);

--if wall attackers rout block ally routed message, if ally defenders rout block enemy routed message
gb:block_message_on_message("enemy_walls_routed", "empire_ally_routed", true);
gb:block_message_on_message("empire_ally_routed", "enemy_walls_routed", true);

------------------------------------------------------------------------
------------------- MAIN ENEMY FORCE REINFORCEMENTS --------------------
------------------------------------------------------------------------

--main enemy reinforces after 5 minutes 15 seconds
enemy_main:reinforce_on_message("01_intro_cutscene_end", 315000);
enemy_main:release_on_message("01_intro_cutscene_end", 320000);
gb:message_on_time_offset("enemy_reinforcements", 315000, "01_intro_cutscene_end");

--all initial enemies defeated, trigger enemy main reinforcements
enemy_main:reinforce_on_message("enemy_reinforcements", 15000);
enemy_main:release_on_message("enemy_reinforcements", 20000);
gb:message_on_all_messages_received("enemy_reinforcements", "enemy_walls_routed", "enemy_port_routed");

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 0.95);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_main_objective_1");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_1"); 
gb:complete_objective_on_message("enemy_walls_routed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_1");
gb:fail_objective_on_message("empire_ally_routed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_1");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_2"); 
gb:complete_objective_on_message("enemy_port_removed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_2");
gb:fail_objective_on_message("port_countdown", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_sub_objective_2");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_start_battle", 7000, 2000, 0);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_start_battle_wall", 6000, 2000, 9000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_start_battle_port", 7000, 2000, 17000);
gb:queue_help_on_message("enemy_port_removed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_allied_reinforcements_arrive");
gb:queue_help_on_message("port_countdown", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_allied_reinforcements_lost");
gb:queue_help_on_message("enemy_walls_routed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_wall_defenders_saved");
gb:queue_help_on_message("empire_ally_routed", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_wall_defenders_lost");
gb:queue_help_on_message("enemy_reinforcements", "wh2_dlc13_emp_wulfhart_amber_bow_stage_4_hints_enemy_reinforcements_arrive");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

local sm = get_messager();
-------ARMY ABILITY-------
local army_abilities = "wh2_dlc13_army_abilities_amber_bow_cannons";

function show_army_abilities(value)
	local army_ability_parent = get_army_ability_parent();
	
	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities):SetVisible(value);

end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities(false);

sm:add_listener(
	"enemy_walls_routed",
	function()
		show_army_abilities(true);
		
		bm:callback(
			function()
				highlight_army_ability(true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(false);
			end,
			7000
		);
	end
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_main:force_victory_on_message("player_defeated", 5000);