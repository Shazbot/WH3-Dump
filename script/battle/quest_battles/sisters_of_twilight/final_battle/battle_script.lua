-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Sisters
-- final battle
-- Witch Wood Ritual Site
-- Defender

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\sis.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
-- Intro
wh2_main_sfx_01 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_05");
wh2_main_sfx_06 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_06");
wh2_main_sfx_07 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_07");
wh2_main_sfx_08 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_08");

-- Mid battle Drycha reveal
wh2_convo_sfx_01 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_09");
wh2_convo_sfx_02 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_10");
wh2_convo_sfx_03 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_11");
wh2_convo_sfx_04 = new_sfx("Play_wh2_dlc16_Sisters_Final_Battle_pt_12");

wh2_convo_sfx_05 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Sisters_pt_01");
wh2_convo_sfx_06 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Sisters_pt_02");
wh2_convo_sfx_07 = new_sfx("Play_wh2_dlc16_Drycha_final_battle_Sisters_pt_03");


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

ga_sisters_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_ally_drycha = gb:get_army(gb:get_player_alliance_num(),"drycha_ally");
ga_throt_enemy = gb:get_army(gb:get_non_player_alliance_num(),"throt_enemy");
ga_slave_wave_enemy_1 = gb:get_army(gb:get_non_player_alliance_num(),"slave_wave_enemy_1");
ga_slave_wave_enemy_2 = gb:get_army(gb:get_non_player_alliance_num(),"slave_wave_enemy_2");
ga_enemy_false_drycha = gb:get_army(gb:get_non_player_alliance_num(),"drycha_false_enemy");
ga_enemy_chaos = gb:get_army(gb:get_non_player_alliance_num(),"chaos_incursion");

-- Ariel teleport to ritual site
function battle_start_teleport_ariel(ariel_sunit)
	bm:out("\tbattle_start_teleport_ariel(ariel_sunit) called");
	ariel_sunit.uc:teleport_to_location(v(2, 184), 180, 25);
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- ARIEL BEHAVIOUR ----------------------------------------
-------------------------------------------------------------------------------------------------

ariel_sunit = ga_sisters_player.sunits:get_sunit_by_type("wh2_dlc16_wef_cha_ariel_0");

ariel_channeling_position = v(2, bm:get_terrain_height(2, 184), 184);
ariel_is_channeling = false;
ariel_position_monitor_listener_name = "ariel_position_monitor";
ariel_channeling_position_entry_threshold = 55;
ariel_channeling_position_exit_threshold = ariel_channeling_position_entry_threshold + 5;

function start_ariel_position_monitor(ariel_sunit)

	bm:remove_process(ariel_position_monitor_listener_name);
	local ariel_unit = ariel_sunit.unit;

	if ariel_is_channeling then
		bm:out("*** Starting Ariel position monitor, watching for her leaving the channeling area");
		bm:watch(
			function()
				return ariel_unit:position():distance_xz(ariel_channeling_position) > ariel_channeling_position_exit_threshold;
			end,
			0,
			function()
				ariel_is_channeling = false;
				bm:out("*** Ariel has left the channeling area");
				gb.sm:trigger_message("ariel_exits_channeling_area");
				start_ariel_position_monitor(ariel_sunit);
			end,
			ariel_position_monitor_listener_name
		);
	else
		bm:out("*** Starting Ariel position monitor, watching for her entering the channeling area");
		bm:watch(
			function()
				return ariel_unit:position():distance_xz(ariel_channeling_position) < ariel_channeling_position_entry_threshold;
			end,
			0,
			function()
				ariel_is_channeling = true;
				bm:out("*** Ariel has entered the channeling area");
				gb.sm:trigger_message("ariel_enters_channeling_area");
				start_ariel_position_monitor(ariel_sunit);
			end,
			ariel_position_monitor_listener_name
		);
	end;
	
end;


function stop_ariel_position_monitor()
	bm:remove_process(ariel_position_monitor_listener_name);
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ARIEL TIMER ------------------------------------------
-------------------------------------------------------------------------------------------------

ariel_countdown_timer_proess_name = "ariel_countdown_timer";
ariel_countdown_initial_s = 600;
ariel_countdown_current_s = ariel_countdown_initial_s;

ariel_countdown_message_thresholds = {
	[ariel_countdown_initial_s - 180] = "rift_to_stage_2",
	[ariel_countdown_initial_s - 360] = "rift_to_stage_3",
	[ariel_countdown_initial_s - 600] = "rift_to_stage_4",
};

function start_ariel_countdown_timer()
	if ariel_sunit then
		bm:repeat_callback(
			function()
				if ariel_is_channeling then
					ariel_countdown_current_s = ariel_countdown_current_s - 1;

					bm:set_objective("wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_01", ariel_countdown_current_s);

					if ariel_countdown_message_thresholds[ariel_countdown_current_s] then
						bm:out("*** Ariel channelling threshold reached, sending message " .. ariel_countdown_message_thresholds[ariel_countdown_current_s] .. " ***");
						gb.sm:trigger_message(ariel_countdown_message_thresholds[ariel_countdown_current_s]);
					end;
				end;
			end,
			1000,
			ariel_countdown_timer_proess_name
		);
	end;
end;


function stop_ariel_countdown_timer()
	bm:remove_process(ariel_countdown_timer_proess_name);
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
				stop_ariel_countdown_timer();
				stop_ariel_position_monitor();
				gb.sm:trigger_message("ariel_shattered_or_dead")
			end
		);
	end;
end;



if ariel_sunit then
	bm:out("ARIEL is present in the player's army, setting up objective markers");
	gb:message_on_time_offset("ariel_objectives_activate", 5000, "01_intro_cutscene_end");
	battle_start_teleport_ariel(ariel_sunit);
	start_ariel_position_monitor(ariel_sunit);
	start_ariel_health_monitor(ariel_sunit);

	gb.sm:add_listener("01_intro_cutscene_end", function() start_ariel_countdown_timer() end);
else
	bm:out("ARIEL is not present in the player's army, doing a little cry");
end;


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
 --teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
	--ga_eltharion_enemy.sunits:item(1).uc:teleport_to_location(v(-121, -10), 90, 25);
	--ga_sisters_player.sunits:item(2).uc:teleport_to_location(v(288, -196), 270, 25);		--hero
end;

battle_start_teleport_units();
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	bm:out("################## What did the grape say when it got stepped on? ################");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_sisters_player.sunits,					-- unitcontroller over player's army
		78000, 									-- duration of cutscene in ms
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
				ga_sisters_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\sis.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_sisters_player:set_enabled(true)
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_01", "subtitle_with_frame", 8, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_02", "subtitle_with_frame", 5, true) end, 11000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 18500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 19000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_03", "subtitle_with_frame", 7, true) end, 19000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_04", "subtitle_with_frame", 9, true) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 40000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 40500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_05", "subtitle_with_frame", 10, true) end, 40500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 51000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_06) end, 51500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_06", "subtitle_with_frame", 7, true) end, 51500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 68000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_07) end, 68500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_07", "subtitle_with_frame", 2, true) end, 68500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 72500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_08) end, 73000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Final_Battle_pt_08", "subtitle_with_frame", 4, true) end, 73000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 78000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	bm:out("################## It let out a little whine! ################");
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_sisters_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_sisters_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_throt_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_throt_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


-- give em a little extra spice
ga_throt_enemy:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)
ga_enemy_chaos:add_winds_of_magic_on_message("chaos_deployed", 20)


-- Chaos Rift control 
gb:start_terrain_composite_scene_on_message("battle_started", rift_stage_1, 100);
-- gb:message_on_time_offset("rift_to_stage_2", 180000,"01_intro_cutscene_end");	-- these timers are no longer needed, but kept here as ref of an alternate method and testing use
gb:stop_terrain_composite_scene_on_message("rift_to_stage_2", rift_stage_1, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_2", rift_stage_2, 100);
-- gb:message_on_time_offset("rift_to_stage_3", 180000,"rift_to_stage_2");
gb:stop_terrain_composite_scene_on_message("rift_to_stage_3", rift_stage_2, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_3", rift_stage_3, 100);
-- gb:message_on_time_offset("rift_to_stage_4", 240000,"rift_to_stage_3");
gb:message_on_time_offset("chaos_arrives", 1000,"rift_to_stage_3");		-- chaos arrives to try and stop the portal closing
gb:stop_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_3, 100);

gb:start_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_4, 100);
gb:stop_terrain_composite_scene_on_message("rift_to_stage_4", rift_stage_4, 10000);

-- if ariel dies, the rift cannot be closed
gb:message_on_time_offset("block_rift_closing", 1000,"ariel_shattered_or_dead");
gb:block_message_on_message("block_rift_closing", "rift_to_stage_4", true);
gb:block_message_on_message("block_rift_closing", "rift_to_stage_3", true);
gb:block_message_on_message("block_rift_closing", "rift_to_stage_2", true);


-- battle start sequence
gb:message_on_time_offset("false_enemy_drycha_arrives", 300000,"01_intro_cutscene_end");		-- failsafe just making sure Drycha turns up
gb:message_on_time_offset("release_all", 600000,"01_intro_cutscene_end");
ga_slave_wave_enemy_1:attack_on_message("01_intro_cutscene_end");
ga_slave_wave_enemy_2:attack_on_message("01_intro_cutscene_end");

-- reinforcement safety checks
ga_sisters_player:message_on_casualties("false_enemy_drycha_arrives", 0.3);
ga_throt_enemy:message_on_casualties("chaos_arrives", 0.8);		-- incase Throt is getting utterly spanked get Chaos involved
gb:message_on_time_offset("chaos_arrives", 365000,"battle_started");	-- backup chaos spawn timer, ensuring they show up even if Ariel isn't ticking down the ritual

-- Drycha appears
gb:message_on_time_offset("false_enemy_drycha_arrives", 10000,"rift_to_stage_2");
ga_enemy_false_drycha:reinforce_on_message("false_enemy_drycha_arrives", 10);
ga_enemy_false_drycha:message_on_deployed("false_enemy_drycha_deployed");
gb:message_on_time_offset("get_outa_here_false_drycha", 10000,"false_enemy_drycha_deployed");	-- the length of this is roughly set to match VO
--gb:message_on_time_offset("get_outa_here_false_drycha", 10000,"false_enemy_drycha_arrives");	--if we wanted it purely time based instead of when deployed
ga_enemy_false_drycha:withdraw_on_message("get_outa_here_false_drycha");
gb:message_on_time_offset("kill_false_enemy_drycha", 10000,"get_outa_here_false_drycha");		--making sure false drycha gets removed in case they don't just leave
ga_enemy_false_drycha:remove_on_message("kill_false_enemy_drycha");
ga_enemy_false_drycha:message_on_alliance_not_active_on_battlefield("ally_drycha_arrives");
gb:message_on_time_offset("ally_drycha_arrives", 10000,"get_outa_here_false_drycha");		--purely time based option backup

gb:message_on_time_offset("block_false_enemy_drycha_arrives", 1000,"false_enemy_drycha_arrives");	-- making sure enemy drycha doesn't show up twice
gb:block_message_on_message("block_false_enemy_drycha_arrives", "false_enemy_drycha_arrives", true);
gb:message_on_time_offset("block_ally_drycha_arrives", 1000,"ally_drycha_arrives");
gb:block_message_on_message("block_ally_drycha_arrives", "ally_drycha_arrives", true);

ga_ally_drycha:reinforce_on_message("ally_drycha_arrives", 10);
ga_ally_drycha:message_on_deployed("drycha_attack");
ga_ally_drycha:attack_on_message("drycha_attack");


--chaos incursion arrives
ga_enemy_chaos:reinforce_on_message("chaos_arrives", 10);
ga_enemy_chaos:message_on_deployed("chaos_deployed");
ga_enemy_chaos:attack_force_on_message("chaos_deployed", ga_sisters_player, 100);		--might change this to after a teleport actually, and target ariel?


--objective listeners
ga_sisters_player:message_on_commander_dead_or_shattered("sisters_dead", 1);

-- releases
ga_throt_enemy:release_on_message("release_all");
ga_ally_drycha:release_on_message("release_all");
ga_enemy_chaos:release_on_message("release_all");
ga_slave_wave_enemy_1:release_on_message("release_all");
ga_slave_wave_enemy_2:release_on_message("release_all");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_final_battle_sisters_objective_01");
gb:set_objective_on_message("ariel_objectives_activate", "wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_01", ariel_countdown_current_s);
--gb:set_objective_on_message("ariel_objectives_activate", "wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_02");
gb:set_locatable_objective_on_message("ariel_objectives_activate", "wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_02", 0, v(1, 798, 298), v(0.5, 781.7, 249), 2);

gb:complete_objective_on_message("rift_to_stage_4", "wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_02", 10000);
gb:message_on_time_offset("rout_remaining_forces", 10000,"rift_to_stage_4");
ga_throt_enemy:rout_over_time_on_message("rout_remaining_forces", 30000);
ga_enemy_chaos:rout_over_time_on_message("rout_remaining_forces", 30000);

gb:fail_objective_on_message("sisters_dead", "wh2_dlc16_qb_wef_final_battle_sisters_objective_01", 5);
ga_enemy_chaos:force_victory_on_message("sisters_dead", 5000);

gb:fail_objective_on_message("ariel_shattered_or_dead", "wh2_dlc16_qb_wef_final_battle_sisters_objective_ariel_01", 5);
ga_enemy_chaos:force_victory_on_message("ariel_shattered_or_dead", 5000);

ga_throt_enemy:message_on_shattered_proportion("skaven_dead", 1)
ga_enemy_chaos:message_on_shattered_proportion("chaos_dead", 1)
gb:message_on_all_messages_received("all_enemies_defeated", "skaven_dead", "chaos_dead")
ga_sisters_player:force_victory_on_message("all_enemies_defeated", 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_final_battle_sisters_hint_rift_01", 6000, nil, 1000);
gb:queue_help_on_message("rift_to_stage_3", "wh2_dlc16_qb_wef_final_battle_sisters_hint_rift_02", 6000, nil, 1000);
gb:queue_help_on_message("rift_to_stage_4", "wh2_dlc16_qb_wef_final_battle_sisters_hint_rift_03", 6000, nil, 1000);

gb:add_ping_icon_on_message("ariel_objectives_activate", v(2.0, 732.8, 184), 13, 2000, 6000);
--gb:remove_ping_icon_on_message("ariel_objectives_activate", v(2.0, 732.8, 184), 13, 8000);

gb:add_ping_icon_on_message("ariel_exits_channeling_area", v(2.0, bm:get_terrain_height(2.0, 184), 184), 13, 2000, 10000);
gb:remove_ping_icon_on_message("ariel_enters_channeling_area", v(2.0, bm:get_terrain_height(2.0, 184), 184), 13, 2000);		-- this isn't working for some reason :(

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
-- ritual site coords   2.0, 732.8, 184
-- can we block the contingency chaos army reinforce message for only a specific amount of time? so if the rift doesnt progress to the next stage they appear? something like that?
-------------------------------------------------------------------------------------------------
--------------------------------------------- MID BATTLE VO -------------------------------------
-------------------------------------------------------------------------------------------------

gb:play_sound_on_message("false_enemy_drycha_arrives", wh2_convo_sfx_01, v(0,0), 1000, "convo_part_2", 1000);
gb:play_sound_on_message("convo_part_2", wh2_convo_sfx_02, v(0,0), 1000, "convo_part_3", 3000);
gb:play_sound_on_message("convo_part_3", wh2_convo_sfx_03, v(0,0), 1000, "convo_part_4", 3000);
gb:play_sound_on_message("convo_part_4", wh2_convo_sfx_04, v(0,0), 1000, "convo_part_5", 3000);
gb:play_sound_on_message("convo_part_5", wh2_convo_sfx_05, v(0,0), 1000, "convo_part_6", 3000);
gb:play_sound_on_message("convo_part_6", wh2_convo_sfx_06, v(0,0), 1000, "convo_part_7", 3000);
gb:play_sound_on_message("convo_part_7", wh2_convo_sfx_07, v(0,0), 1000, nil, 3000);

--this isn't really the proper way to do subtitles mid battle, but it works
gb:queue_help_on_message("false_enemy_drycha_arrives", "wh2_dlc16_Sisters_Final_Battle_pt_09_sub", 1000, nil, 1000);
gb:queue_help_on_message("convo_part_2", "wh2_dlc16_Sisters_Final_Battle_pt_10_sub", 4000, nil, 1000);
gb:queue_help_on_message("convo_part_3", "wh2_dlc16_Sisters_Final_Battle_pt_11_sub", 8000, nil, 1000);	-- this is a long line
gb:queue_help_on_message("convo_part_4", "wh2_dlc16_Sisters_Final_Battle_pt_12_sub", 4000, nil, 1000);
gb:queue_help_on_message("convo_part_5", "wh2_dlc16_Drycha_final_battle_Sisters_pt_01_sub", 4000, nil, 1000);
gb:queue_help_on_message("convo_part_6", "wh2_dlc16_Drycha_final_battle_Sisters_pt_02_sub", 6000, nil, 1000);
gb:queue_help_on_message("convo_part_7", "wh2_dlc16_Drycha_final_battle_Sisters_pt_03_sub", 4000, nil, 1000);