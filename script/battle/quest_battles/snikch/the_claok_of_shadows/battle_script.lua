-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Snikch
-- The Cloak of Shadows
-- INSERT ENVIRONMENT NAME
-- Attacker

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\41_sni_r02.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_patrol = gb:get_army(gb:get_non_player_alliance_num(),"enemy_patrol");
ga_enemy_patrol_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_patrol_2");
ga_enemy_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
	--teleport unit (1) of ga_enemy_patrol to [645, -420] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol.sunits:item(1).uc:teleport_to_location(v(-300, 320), 50, 25);
	--teleport unit (2) of ga_enemy_patrol to [600, -440] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol.sunits:item(2).uc:teleport_to_location(v(-280, 280), 90, 25);
	--teleport unit (3) of ga_enemy_patrol to [620, -430] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol.sunits:item(3).uc:teleport_to_location(v(-250, 250), 350, 25);
	--teleport unit (4) of ga_enemy_patrol to [620, -430] with an orientation of 45 degrees and a width of 25m
	--ga_enemy_patrol.sunits:item(4).uc:teleport_to_location(v(-230, 220), 350, 25);

	--teleport unit (1) of ga_artillery to [620, -430] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol_2.sunits:item(1).uc:teleport_to_location(v(300, -100), 350, 25);
	--teleport unit (2) of ga_enemy_patrol_2 to [620, -430] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol_2.sunits:item(2).uc:teleport_to_location(v(300, -60), 350, 25);
	--teleport unit (3) of ga_enemy_patrol_2 to [620, -430] with an orientation of 45 degrees and a width of 25m
	ga_enemy_patrol_2.sunits:item(3).uc:teleport_to_location(v(300, -20), 350, 25);
	--teleport unit (4) of ga_enemy_patrol_2 to [620, -430] with an orientation of 45 degrees and a width of 25m
	--ga_enemy_patrol_2.sunits:item(4).uc:teleport_to_location(v(300, 20), 350, 25);

	-- start patrol managers
	start_patrol_1();
	start_patrol_2()
end;


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");

	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		37000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\41_sni_r02.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_01", "subtitle_with_frame", 4, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 13500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_02", "subtitle_with_frame", 4, true) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 24000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_Cloak_of_Shadows_pt_03", "subtitle_with_frame", 4, true) end, 24000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 35000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")

	-- bm:callback(function() start_patrol_1() end, 5000);
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
------------------------------------------------------ PATROL 1 --------------------------------------------
function start_patrol_1()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_patrol.sunits:count() do
		local current_sunit = ga_enemy_patrol.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_skv_patrol_01", current_sunit, player_armies, 150);
		--pm:set_debug();
		pm:add_waypoint(v(-400, 380), true);
		pm:add_waypoint(v(-420, 90), true);
		pm:add_waypoint(v(-225, 30), true);
		pm:add_waypoint(v(-220, 120), true);
		pm:loop(true);
		pm:start();
	end;
end;

function start_patrol_2()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_patrol_2.sunits:count() do
		local current_sunit = ga_enemy_patrol_2.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_skv_patrol_01", current_sunit, player_armies, 150);
		--pm:set_debug();
		pm:add_waypoint(v(220, -260), true);
		pm:add_waypoint(v(40, -160), true);
		pm:add_waypoint(v(40, 0), true);
		pm:add_waypoint(v(260, 20), true);
		pm:loop(true);
		pm:start();
	end;
end;


-- ------------------------------------------------------ PATROL 2 SOON--------------------------------------------


--Stopping armies from firing until the cutscene is done and the player approaches the enemy positions
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--ga_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
--ga_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--ga_enemy_patrol:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
--ga_enemy_patrol:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


ga_enemy:message_on_proximity_to_enemy("army_close_to_player", 100);
ga_enemy:message_on_casualties("army_under_attack", 0.05);

--gb:message_on_time_offset("patrol_attack", 40000,"01_intro_cutscene_end");
gb:message_on_time_offset("patrol_release", 610000,"01_intro_cutscene_end");
gb:message_on_time_offset("army_release", 630000,"01_intro_cutscene_end");
gb:message_on_time_offset("safety_release_main", 660000,"01_intro_cutscene_end");
gb:message_on_time_offset("safety_release_patrol", 660000,"01_intro_cutscene_end");
gb:message_on_time_offset("safety_release_patrol_2", 660000,"01_intro_cutscene_end");

--release if hurt
ga_enemy:message_on_casualties("ouch", 0.5);
ga_enemy_patrol:message_on_casualties("ouch_patrol", 0.25);
ga_enemy_patrol_2:message_on_casualties("ouch_patrol_2", 0.25);
-- trigger reinforcements when army has 40% health left
ga_enemy:message_on_casualties("reinforce", 0.6);

--ga_enemy_patrol:attack_on_message("patrol_attack");
ga_enemy_patrol:attack_on_message("patrol_release");
ga_enemy_patrol:attack_on_message("army_close_to_player");
ga_enemy_patrol_2:attack_on_message("army_close_to_player");
ga_enemy:attack_on_message("army_release");
ga_enemy:attack_on_message("army_under_attack");

-- defend the northern position, with a radius of 0
ga_enemy:defend_on_message("battle_started", 1, 320, 60);

ga_enemy_patrol:message_on_rout_proportion("enemy_patrol_dead", 1);
ga_enemy_patrol_2:message_on_rout_proportion("enemy_patrol_dead_2", 1);
ga_enemy:message_on_rout_proportion("enemy_main_dead", 1);
ga_enemy_reinforcements:message_on_rout_proportion("enemy_reinforcements_dead", 1);
ga_enemy:message_on_commander_dead_or_shattered("enemy_lord_dead", 1);

ga_enemy:release_on_message("ouch");
ga_enemy_patrol:release_on_message("ouch");
ga_enemy_patrol_2:release_on_message("ouch");
ga_enemy_patrol:release_on_message("ouch_patrol");
ga_enemy_patrol_2:release_on_message("ouch_patrol_2");
--ga_enemy:release_on_message("enemy_patrol_dead");
--ga_enemy:release_on_message("enemy_patrol_dead_2");
ga_enemy:release_on_message("safety_release_main");
ga_enemy_patrol:release_on_message("safety_release_patrol");
ga_enemy_patrol_2:release_on_message("safety_release_patrol_2");

-- extra contingencies for if the player somehow kills Garrott first
ga_enemy:rout_over_time_on_message("enemy_lord_dead", 60000);
ga_enemy_patrol:attack_on_message("enemy_lord_dead");
ga_enemy_patrol_2:attack_on_message("enemy_lord_dead");

--gb:message_on_time_offset("reinforce", 240000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_release", 1000,"reinforce");
gb:message_on_time_offset("reinforcement_release_1", 1000,"enemy_lord_dead");

ga_enemy_reinforcements:reinforce_on_message("reinforce", 10);
ga_enemy_reinforcements:reinforce_on_message("enemy_lord_dead", 10);
ga_enemy_reinforcements:release_on_message("reinforcement_release");
ga_enemy_reinforcements:release_on_message("reinforcement_release_1");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------


gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_2");
gb:set_objective_on_message("reinforce", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_1", 10);
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_3");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_4");

gb:complete_objective_on_message("enemy_main_dead", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_2", 5);
gb:complete_objective_on_message("enemy_reinforcements_dead", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_1", 5);
gb:complete_objective_on_message("enemy_patrol_dead", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_3", 5);
gb:complete_objective_on_message("enemy_patrol_dead_2", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_objective_4", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_the_cloak_of_shadows_stage_4_hint_1", 6000, nil, 5000);
gb:queue_help_on_message("reinforce", "wh2_dlc14_Snikch_Cloak_of_Shadows_pt_04", 6000, nil, 3000, false, "last_vo");
gb:queue_help_on_message("last_vo", "wh2_dlc14_Snikch_Cloak_of_Shadows_pt_05", 5000, nil, 7000);

--message, objective_key, display_time, fade_time, offset_time, is_high_priority, message_on_trigger)

--(message, sound, position, wait_offset, message_on_finished, minimum_sound_duration)
gb:play_sound_on_message("reinforce", wh2_main_sfx_04, v(0, 0), 2000);	
gb:play_sound_on_message("reinforce", wh2_main_sfx_05, v(0, 0), 9000);	

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------