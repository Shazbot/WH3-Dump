-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Throt
-- final battle
-- Witch Wood Ritual Site
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);
--bm:enable_cinematic_ui(false, true, false)		-- ensures UI is avaiable during deployment

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\throt.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
-- Intro
wh2_main_sfx_01 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_05");

-- Drycha reveal convo
wh2_convo_sfx_01 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Thrott_pt_01");
wh2_convo_sfx_02 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Thrott_pt_02");
wh2_convo_sfx_03 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Thrott_pt_03");

wh2_convo_sfx_04 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_06");
wh2_convo_sfx_05 = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_07");

-- ariel objectives vo
wh2_objective_sfx_ariel_dead = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_08");
wh2_objective_sfx_ariel_retrieved = new_sfx("Play_wh2_dlc16_Throt_final_battle_pt_09");

-------------------------------------------------------------------------------------------------
---------------------------------------- COMPOSITE SCENE ----------------------------------------
-------------------------------------------------------------------------------------------------

rift_stage_1 = "composite_scene/wh2_dlc16_wef_chaos_rift_stage1.csc";
rift_stage_2 = "composite_scene/wh2_dlc16_wef_chaos_rift_stage2.csc";
rift_stage_3 = "composite_scene/wh2_dlc16_wef_chaos_rift_stage3.csc";
rift_stage_4 = "composite_scene/wh2_dlc16_wef_chaos_rift_stage4.csc";

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_throt_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_sisters_enemy = gb:get_army(gb:get_non_player_alliance_num(),"sisters_enemy");
ga_slave_wave_ally_1 = gb:get_army(gb:get_player_alliance_num(),"slave_wave_ally_1");
ga_slave_wave_ally_2 = gb:get_army(gb:get_player_alliance_num(),"slave_wave_ally_2");
ga_enemy_drycha = gb:get_army(gb:get_non_player_alliance_num(),"drycha_enemy");
ga_ally_false_drycha = gb:get_army(gb:get_player_alliance_num(),"drycha_false_ally");
ga_enemy_chaos = gb:get_army(gb:get_player_alliance_num(),"chaos_incursion");


-- Ariel teleport to ritual site
function battle_start_teleport_ariel(ariel_sunit)
	bm:out("\tbattle_start_teleport_ariel(ariel_sunit) called");
	ariel_sunit.uc:teleport_to_location(v(2, 184), 180, 25);
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- ARIEL + THROT BEHAVIOUR --------------------------------
-------------------------------------------------------------------------------------------------

ariel_sunit = ga_sisters_enemy.sunits:get_sunit_by_type("wh2_dlc16_wef_cha_ariel_0");
throt_sunit = ga_throt_player.sunits:get_sunit_by_type("wh2_dlc16_skv_cha_throt_the_unclean_2") or
ga_throt_player.sunits:get_sunit_by_type("wh2_dlc16_skv_cha_throt_the_unclean_1") or
ga_throt_player.sunits:get_sunit_by_type("wh2_dlc16_skv_cha_throt_the_unclean_0"); 		-- checking for different mounted versions

throt_escape_position = v(40, bm:get_terrain_height(40, -413), -413);
throt_is_escaping = false;
throt_position_monitor_listener_name = "ariel_position_monitor";
throt_escape_position_entry_threshold = 50;
throt_escape_position_exit_threshold = throt_escape_position_entry_threshold + 5;

function start_throt_position_monitor(throt_sunit)

	bm:remove_process(throt_position_monitor_listener_name);
	local throt_unit = throt_sunit.unit;

	if throt_is_escaping then
		bm:out("*** Starting Throt position monitor, watching for him leaving escape area");
		bm:watch(
			function()
				return throt_unit:position():distance_xz(throt_escape_position) > throt_escape_position_exit_threshold;
			end,
			0,
			function()
				throt_is_escaping = false;
				bm:out("*** Throt has left the escape area");
				gb.sm:trigger_message("throt_exits_escape_area");
				start_throt_position_monitor(throt_sunit);
			end,
			throt_position_monitor_listener_name
		);
	else
		bm:out("*** Starting Throt position monitor, watching for him entering escape area");
		bm:watch(
			function()
				return throt_unit:position():distance_xz(throt_escape_position) < throt_escape_position_entry_threshold;
			end,
			0,
			function()
				throt_is_escaping = true;
				bm:out("*** Throt has entered the escape area");
				gb.sm:trigger_message("throt_enters_escape_area");
				start_throt_position_monitor(throt_sunit);
			end,
			throt_position_monitor_listener_name
		);
	end;
	
end;


function stop_throt_position_monitor()
	bm:remove_process(throt_position_monitor_listener_name);
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ARIEL HEALTH -----------------------------------------
-------------------------------------------------------------------------------------------------

function start_ariel_health_monitor(ariel_sunit)
	if ariel_sunit then
		bm:watch(
			function()
				return is_shattered_or_dead(ariel_sunit)
			end,
			0,
			function()
				bm:out("*** Ariel is shattered or dead! ***");
				--stop_ariel_countdown_timer();
				--stop_ariel_position_monitor();
				gb.sm:trigger_message("ariel_shattered_or_dead")
			end
		);
	end;
end;



if ariel_sunit then
	bm:out("ARIEL is present in the enemy army, setting up objective markers");
	gb:message_on_time_offset("ariel_objectives_activate", 5000, "01_intro_cutscene_end");
	battle_start_teleport_ariel(ariel_sunit);
	--start_ariel_position_monitor(ariel_sunit);
	start_throt_position_monitor(throt_sunit)		-- Make sure this is only possible after Ariel is dead
	start_ariel_health_monitor(ariel_sunit);

	--gb.sm:add_listener("01_intro_cutscene_end", function() start_ariel_countdown_timer() end);
else
	bm:out("ARIEL is not present in the player's army, doing a little cry");
end;


-- This is a (not ideal) solution to stop ariel death VO lines starting and overlapping with the Drycha convo
gb.sm:add_listener(
    "false_ally_drycha_arrives",
    function()
        bm:out("Giving Ariel invincibility in response to message [false_ally_drycha_arrives]");
        ariel_sunit:set_invincible(true);
        ariel_sunit:morale_behavior_default();
        ariel_sunit.uc:release_control();
    end
);

gb.sm:add_listener(
    "convo_part_5",
    function()
        bm:out("Removing Ariel invincibility in response to message [convo_part_5]");
        ariel_sunit:set_invincible(false);
        ariel_sunit:morale_behavior_default();
        ariel_sunit.uc:release_control();
    end
);

-- In interest of fairness we'll make Throt invincible at the same time
gb.sm:add_listener(
    "false_ally_drycha_arrives",
    function()
        bm:out("Giving Throt invincibility in response to message [false_ally_drycha_arrives]");
        throt_sunit:set_invincible(true);
        throt_sunit:morale_behavior_default();
        throt_sunit.uc:release_control();
    end
);

gb.sm:add_listener(
    "convo_part_5",
    function()
        bm:out("Removing Throt invincibility in response to message [convo_part_5]");
        throt_sunit:set_invincible(false);
        throt_sunit:morale_behavior_default();
        throt_sunit.uc:release_control();
    end
);

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
 --teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
	--ga_eltharion_enemy.sunits:item(1).uc:teleport_to_location(v(-121, -10), 90, 25);
end;

battle_start_teleport_units();
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	bm:out("################## What do you call a bear with no teeth? ################");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_throt_player.sunits,					-- unitcontroller over player's army
		80000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_throt_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\throt.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_throt_player:set_enabled(true)
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_final_battle_pt_01", "subtitle_with_frame", 10, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_final_battle_pt_02", "subtitle_with_frame", 12, true) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 30000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_final_battle_pt_03", "subtitle_with_frame", 14, true) end, 30000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 48500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_final_battle_pt_04", "subtitle_with_frame", 12, true) end, 48500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 63000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 63500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_final_battle_pt_05", "subtitle_with_frame", 12, true) end, 63500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 80000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	bm:out("################## A Gummi Bear! ################");
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_throt_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_throt_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_sisters_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_sisters_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


-- give em a little extra spice
ga_sisters_enemy:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)


-- Chaos Rift control (simple timer sequence for this version, the complex method from the sisters side isn't needed here)
gb:start_terrain_composite_scene_on_message("battle_started", rift_stage_1, 100);
gb:message_on_time_offset("rift_to_stage_2", 180000,"01_intro_cutscene_end");
gb:stop_terrain_composite_scene_on_message("rift_to_stage_2", rift_stage_1, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_2", rift_stage_2, 100);
gb:message_on_time_offset("rift_to_stage_3", 180000,"rift_to_stage_2");
gb:stop_terrain_composite_scene_on_message("rift_to_stage_3", rift_stage_2, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_3", rift_stage_3, 100);
gb:message_on_time_offset("rift_to_stage_4", 240000,"rift_to_stage_3");
gb:message_on_time_offset("chaos_arrives", 3000,"rift_to_stage_3");		-- chaos arrives to try and stop the portal closing
gb:stop_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_3, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_4, 100);
gb:stop_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_4, 10000);

-- if ariel dies, the rift cannot be closed
gb:message_on_time_offset("block_rift_closing", 1000,"ariel_shattered_or_dead");
gb:block_message_on_message("block_rift_closing", "rift_to_stage_4", true);
gb:block_message_on_message("block_rift_closing", "rift_to_stage_3", true);
gb:block_message_on_message("block_rift_closing", "rift_to_stage_2", true);


-- battle start sequence
gb:message_on_time_offset("false_ally_drycha_arrives", 350000,"01_intro_cutscene_end");		-- just making sure Drycha turns up
gb:message_on_time_offset("release_all", 600000,"01_intro_cutscene_end");
ga_slave_wave_ally_1:attack_on_message("01_intro_cutscene_end");
ga_slave_wave_ally_2:attack_on_message("01_intro_cutscene_end");


-- defend the northern position, with a radius of 0
--ga_sisters_enemy:defend_on_message("battle_started", 2, 182, 60);	--the defensive hill ai hint should mean this isn't needed maybe

--ga_sisters_enemy:message_on_casualties("false_ally_drycha_arrives", 0.3);
--ga_sisters_enemy:message_on_casualties("chaos_arrives", 0.2);


-- Drycha appears
gb:message_on_time_offset("false_ally_drycha_arrives", 10000,"rift_to_stage_2");
ga_ally_false_drycha:reinforce_on_message("false_ally_drycha_arrives", 10);
ga_ally_false_drycha:message_on_deployed("false_ally_drycha_deployed");
gb:message_on_time_offset("get_outa_here_false_drycha", 10000,"false_ally_drycha_deployed");
--gb:message_on_time_offset("get_outa_here_false_drycha", 20000,"false_ally_drycha_arrives");	--if we wanted it purely time based instead
ga_ally_false_drycha:withdraw_on_message("get_outa_here_false_drycha");
gb:message_on_time_offset("kill_false_ally_drycha", 10000,"get_outa_here_false_drycha");		--making sure false drycha gets removed in case they don't just leave
ga_ally_false_drycha:remove_on_message("kill_false_ally_drycha");
ga_ally_false_drycha:message_on_alliance_not_active_on_battlefield("enemy_drycha_arrives");
gb:message_on_time_offset("enemy_drycha_arrives", 10000,"get_outa_here_false_drycha");		--purely time based backup option

gb:message_on_time_offset("block_false_ally_drycha_arrives", 1000,"false_ally_drycha_arrives");
gb:block_message_on_message("block_false_ally_drycha_arrives", "false_ally_drycha_arrives", true);
gb:message_on_time_offset("block_enemy_drycha_arrives", 1000,"enemy_drycha_arrives");
gb:block_message_on_message("block_enemy_drycha_arrives", "enemy_drycha_arrives", true);

ga_enemy_drycha:reinforce_on_message("enemy_drycha_arrives", 10);
ga_enemy_drycha:message_on_deployed("drycha_attack");
ga_enemy_drycha:attack_on_message("drycha_attack");


--chaos incursion arrives
ga_enemy_chaos:reinforce_on_message("chaos_arrives", 10);

-- releases
ga_sisters_enemy:release_on_message("release_all");
ga_enemy_drycha:release_on_message("release_all");
ga_enemy_chaos:release_on_message("release_all");
ga_slave_wave_ally_1:release_on_message("release_all");
ga_slave_wave_ally_2:release_on_message("release_all");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_skv_final_battle_throt_objective_01");
gb:set_objective_on_message("ariel_shattered_or_dead", "wh2_dlc16_qb_skv_final_battle_throt_objective_02");		-- maybe force ariel to stay at ritual site?
gb:play_sound_on_message("ariel_shattered_or_dead", wh2_objective_sfx_ariel_dead, v(0,0), 1000, "ariel_body_retrieved", 8000);

--gb:set_objective_on_message("ariel_shattered_or_dead", "wh2_dlc16_qb_skv_final_battle_throt_objective_03");
gb:set_locatable_objective_on_message("ariel_body_retrieved", "wh2_dlc16_qb_skv_final_battle_throt_objective_03", 0, v(25, 770.7, -218), v(27.2, 759.8, -245.3), 2);

gb:message_on_time_offset("time_to_cheese_it", 1000,"ariel_body_retrieved");
gb:play_sound_on_message("ariel_body_retrieved", wh2_objective_sfx_ariel_retrieved, v(0,0), 1000, "cheesing_it", 6000);
gb:message_on_time_offset("cheesing_it", 12000,"chaos_arrives");	-- chaos will now arrive after ariels death, as the rift closing messages are now blocked
gb:message_on_time_offset("block_chaos_arrives", 1000,"chaos_arrives");
gb:block_message_on_message("block_chaos_arrives", "chaos_arrives", true);

gb:complete_objective_on_message("ariel_shattered_or_dead", "wh2_dlc16_qb_skv_final_battle_throt_objective_01", 5);
gb:complete_objective_on_message("ariel_body_retrieved", "wh2_dlc16_qb_skv_final_battle_throt_objective_02", 5);
gb:complete_objective_on_message("throt_enters_escape_area", "wh2_dlc16_qb_skv_final_battle_throt_objective_03", 5);

gb:block_message_on_message("01_intro_cutscene_end", "throt_enters_escape_area", true);		-- stops the player walking to the area at battle start and insta winning
gb:block_message_on_message("time_to_cheese_it", "throt_enters_escape_area", false);
ga_throt_player:force_victory_on_message("throt_enters_escape_area", 2000);

-- battle ends if Throt dies
ga_throt_player:message_on_commander_dead_or_shattered("throt_dead", 1);
ga_sisters_enemy:force_victory_on_message("throt_dead", 6000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_ping_icon_on_message("time_to_cheese_it", v(40, bm:get_terrain_height(40, -413), -413), 9, 2000);
gb:add_ping_icon_on_message("time_to_cheese_it", v(40, bm:get_terrain_height(40, -413), -413), 13, 2000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MID BATTLE VO -------------------------------------
-------------------------------------------------------------------------------------------------
gb:play_sound_on_message("false_ally_drycha_arrives", wh2_convo_sfx_01, v(0,0), 1000, "convo_part_2", 1000);
gb:play_sound_on_message("convo_part_2", wh2_convo_sfx_02, v(0,0), 1000, "convo_part_3", 3000);
gb:play_sound_on_message("convo_part_3", wh2_convo_sfx_03, v(0,0), 1000, "convo_part_4", 3000);
gb:play_sound_on_message("convo_part_4", wh2_convo_sfx_04, v(0,0), 1000, "convo_part_5", 3000);
gb:play_sound_on_message("convo_part_5", wh2_convo_sfx_05, v(0,0), 1000, nil, 3000);

--this isn't really the proper way to do subtitles mid battle, but it works
gb:queue_help_on_message("false_ally_drycha_arrives", "wh2_dlc16_Drycha_final_battle_Thrott_pt_01_sub", 3000, nil, 1000);
gb:queue_help_on_message("convo_part_2", "wh2_dlc16_Drycha_final_battle_Thrott_pt_02_sub", 6000, nil, 1000);
gb:queue_help_on_message("convo_part_3", "wh2_dlc16_Drycha_final_battle_Thrott_pt_03_sub", 6000, nil, 1000);
gb:queue_help_on_message("convo_part_4", "wh2_dlc16_Throt_final_battle_pt_06_sub", 6000, nil, 1000);
gb:queue_help_on_message("convo_part_5", "wh2_dlc16_Throt_final_battle_pt_07_sub", 6000, nil, 1000);

-- objective complete vo subtitles
gb:queue_help_on_message("ariel_shattered_or_dead", "wh2_dlc16_Throt_final_battle_pt_08_sub", 6000, nil, 1000);
gb:queue_help_on_message("ariel_body_retrieved", "wh2_dlc16_Throt_final_battle_pt_09_sub", 12000, nil, 1000);

