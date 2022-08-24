load_script_libraries();

bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

bm:notify_survival_started();
bm:force_cant_chase_down_routers();
bm:notify_survival_total_waves(4);

required_waves_kills = 4;

local sm = get_messager();
survival_mode = {};

intro_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq01_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq02_m02.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);
outro_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq03_m03.CindySceneManager";
bm:cindy_preload(outro_cinematic_file);

bm:force_custom_battle_result("wh3_survival_belakor_victory", true);
bm:force_custom_battle_result("wh3_survival_belakor_defeat", false);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_player_02 = gb:get_army(gb:get_player_alliance_num(), "player_reinforce");

ga_ai_def_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_01");
ga_ai_def_02 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_02");
ga_ai_def_03 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_03");

ga_ai_flow_01 = gb:get_army(gb:get_non_player_alliance_num(), "flow_01");
ga_ai_flow_02 = gb:get_army(gb:get_non_player_alliance_num(), "flow_02");
ga_ai_flow_03 = gb:get_army(gb:get_non_player_alliance_num(), "flow_03");

ga_ai_soul_grinder_01 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_01");
ga_ai_soul_grinder_02 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_02");
ga_ai_soul_grinder_03 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_03");
ga_ai_soul_grinder_04 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_04");
ga_ai_soul_grinder_05 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_05");
ga_ai_soul_grinder_06 = gb:get_army(gb:get_non_player_alliance_num(), "soul_grinder_06");

ga_ai_att_01_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_1");
ga_ai_att_01_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_2");

ga_ai_att_02_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_1");
ga_ai_att_02_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_2");
ga_ai_att_02_3 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_3");

ga_ai_att_03_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_1");
ga_ai_att_03_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_2");

ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss");

ga_ai_flow_01:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_02:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_03:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_01:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_02:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_03:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_04:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_05:get_army():suppress_reinforcement_adc(1);
ga_ai_soul_grinder_06:get_army():suppress_reinforcement_adc(1);
ga_ai_att_01_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_01_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_3:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_04:get_army():suppress_reinforcement_adc(1);

ga_ai_def_02.sunits:set_enabled(false);
ga_ai_def_03.sunits:set_enabled(false);
ga_ai_att_04.sunits:set_enabled(false);

-- build spawn zone collections
sz_collection_1_left = bm:get_spawn_zone_collection_by_name("attacker_stage_1_left", "attacker_flow");
sz_collection_1_right = bm:get_spawn_zone_collection_by_name("attacker_stage_1_right", "attacker_flow");
sz_collection_2_left = bm:get_spawn_zone_collection_by_name("attacker_stage_2_front_left", "attacker_stage_2_mid_left", "attacker_stage_2_back_left");
sz_collection_2_cindy_left = bm:get_spawn_zone_collection_by_name("attacker_stage_2_mid_left");
sz_collection_2_right = bm:get_spawn_zone_collection_by_name("attacker_stage_2_front_right", "attacker_stage_2_mid_right", "attacker_stage_2_back_right");
sz_collection_3_left = bm:get_spawn_zone_collection_by_name("attacker_stage_3_left", "attacker_stage_4_left");
sz_collection_3_right = bm:get_spawn_zone_collection_by_name("attacker_stage_3_right", "attacker_stage_4_right");
sz_collection_2_allies = bm:get_spawn_zone_collection_by_name("defender_stage_2_left", "defender_stage_2_right");
sz_collection_4_1 = bm:get_spawn_zone_collection_by_name("production_1");
sz_collection_4_2 = bm:get_spawn_zone_collection_by_name("production_2");
sz_collection_4_3 = bm:get_spawn_zone_collection_by_name("production_3");
sz_collection_4_4 = bm:get_spawn_zone_collection_by_name("production_4");
sz_collection_4_5 = bm:get_spawn_zone_collection_by_name("production_5");
sz_collection_4_6 = bm:get_spawn_zone_collection_by_name("production_6");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("attacker_boss");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("attacker_flow");

local reinforcements = bm:reinforcements();

-------------------------------------
----------Capture Locations----------
-------------------------------------

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_shadow_bridge");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp_engine_forge");
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp_throne_room");

reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_2", capture_point_02);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_3", capture_point_03);

capture_point_01:set_locked(true);
capture_point_02:set_locked(true);
capture_point_03:set_locked(true);

ga_ai_def_01:message_on_rout_proportion("def_01_dead", 0.95);

gb:add_listener(
	"def_01_dead",
	function()
		capture_point_01:set_locked(false);
	end
);

gb:add_listener(
	"ready_ai_wave_02",
	function()
		capture_point_02:set_locked(false);
	end
);

ga_ai_def_03:message_on_rout_proportion("def_03_dead", 0.95);

gb:add_listener(
	"def_03_dead",
	function()
		capture_point_03:set_locked(false);
	end
);

gb:message_on_capture_location_capture_completed("cp_1_owned", "battle_start", "cp_shadow_bridge", nil, ga_ai_def_01, ga_player_01);

gb:add_listener(
	"cp_1_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

gb:message_on_capture_location_capture_completed("cp_2_owned", "ready_ai_wave_02", "cp_engine_forge", nil, ga_ai_def_01, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_2_lost", "ready_ai_wave_02", "cp_engine_forge", nil, ga_player_01, ga_ai_def_01);

gb:add_listener(
	"cp_2_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_2");
		capture_point_01:change_holding_army(ga_player_01.army);
		capture_point_01:set_locked(true);
	end
);

gb:add_listener(
	"cp_2_lost",
	function()
		capture_point_01:set_locked(false);
	end
);

gb:message_on_capture_location_capture_completed("cp_3_owned", "ready_ai_wave_03", "cp_throne_room", nil, ga_ai_def_01, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_3_lost", "ready_ai_wave_03", "cp_throne_room", nil, ga_player_01, ga_ai_def_01);

gb:add_listener(
	"cp_3_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_3");
		capture_point_02:change_holding_army(ga_player_01.army);
		capture_point_02:set_locked(true);
	end
);

gb:add_listener(
	"cp_3_lost",
	function()
		capture_point_02:set_locked(false);
	end
);

-- Setup Currency Caps
capture_point_01:set_income_cap_for_alliance(bm:get_player_alliance(), 7500.0);
capture_point_02:set_income_cap_for_alliance(bm:get_player_alliance(), 7500.0);
capture_point_03:set_income_cap_for_alliance(bm:get_player_alliance(), 7500.0);

reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 1000);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_2", 1000, 1500);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1500, 9999999);

------FLOW 01------
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_6, false);
ga_ai_flow_01:message_on_number_deployed("flow_01_deployed", true, 1);
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("flow_01_deployed", sz_collection_6, false);

------FLOW 02------
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_6, false);
ga_ai_flow_02:message_on_number_deployed("flow_02_deployed", true, 1);
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("flow_02_deployed", sz_collection_6, false);

------FLOW 03------
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_6, false);
ga_ai_flow_03:message_on_number_deployed("flow_03_deployed", true, 1);
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("flow_03_deployed", sz_collection_6, false);

-----WAVE 1_1-----
ga_ai_att_01_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_1_left, false);
ga_ai_att_01_1:message_on_number_deployed("1_1_deployed", true, 1);
ga_ai_att_01_1:assign_to_spawn_zone_from_collection_on_message("1_1_deployed", sz_collection_1_left, false);

-----WAVE 1_2-----
ga_ai_att_01_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_1_right, false);
ga_ai_att_01_2:message_on_number_deployed("1_2_deployed", true, 1);
ga_ai_att_01_2:assign_to_spawn_zone_from_collection_on_message("1_2_deployed", sz_collection_1_right, false);

-----WAVE 2_1-----
ga_ai_att_02_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_2_left, false);
ga_ai_att_02_1:message_on_number_deployed("2_1_deployed", true, 1);
ga_ai_att_02_1:assign_to_spawn_zone_from_collection_on_message("2_1_deployed", sz_collection_2_left, false);

-----WAVE 2_2-----
ga_ai_att_02_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_2_right, false);
ga_ai_att_02_2:message_on_number_deployed("2_2_deployed", true, 1);
ga_ai_att_02_2:assign_to_spawn_zone_from_collection_on_message("2_2_deployed", sz_collection_2_right, false);

-----WAVE 2_3-----
ga_ai_att_02_3:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_2_cindy_left, false);
ga_ai_att_02_3:message_on_number_deployed("2_3_deployed", true, 1);
ga_ai_att_02_3:assign_to_spawn_zone_from_collection_on_message("2_3_deployed", sz_collection_2_cindy_left, false);

-----WAVE 3_1-----
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_3_left, false);
ga_ai_att_03_1:message_on_number_deployed("3_1_deployed", true, 1);
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("3_1_deployed", sz_collection_3_left, false);

-----WAVE 3_2-----
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_3_right, false);
ga_ai_att_03_2:message_on_number_deployed("3_2_deployed", true, 1);
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("3_2_deployed", sz_collection_3_right, false);

-----WAVE SG_1-----
ga_ai_soul_grinder_01:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_1, false);
ga_ai_soul_grinder_01:message_on_number_deployed("sg_1_deployed", true, 1);
ga_ai_soul_grinder_01:assign_to_spawn_zone_from_collection_on_message("sg_1_deployed", sz_collection_4_1, false);

-----WAVE SG_2-----
ga_ai_soul_grinder_02:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_2, false);
ga_ai_soul_grinder_02:message_on_number_deployed("sg_2_deployed", true, 1);
ga_ai_soul_grinder_02:assign_to_spawn_zone_from_collection_on_message("sg_2_deployed", sz_collection_4_2, false);

-----WAVE SG_3-----
ga_ai_soul_grinder_03:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_3, false);
ga_ai_soul_grinder_03:message_on_number_deployed("sg_3_deployed", true, 1);
ga_ai_soul_grinder_03:assign_to_spawn_zone_from_collection_on_message("sg_3_deployed", sz_collection_4_3, false);

-----WAVE SG_4-----
ga_ai_soul_grinder_04:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_4, false);
ga_ai_soul_grinder_04:message_on_number_deployed("sg_4_deployed", true, 1);
ga_ai_soul_grinder_04:assign_to_spawn_zone_from_collection_on_message("sg_4_deployed", sz_collection_4_4, false);

-----WAVE SG_5-----
ga_ai_soul_grinder_05:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_5, false);
ga_ai_soul_grinder_05:message_on_number_deployed("sg_5_deployed", true, 1);
ga_ai_soul_grinder_05:assign_to_spawn_zone_from_collection_on_message("sg_5_deployed", sz_collection_4_5, false);

-----WAVE SG_6-----
ga_ai_soul_grinder_06:assign_to_spawn_zone_from_collection_on_message("outro_cutscene_end", sz_collection_4_6, false);
ga_ai_soul_grinder_06:message_on_number_deployed("sg_6_deployed", true, 1);
ga_ai_soul_grinder_06:assign_to_spawn_zone_from_collection_on_message("sg_6_deployed", sz_collection_4_6, false);

-- Example: Set random deployment position in a reinforcement line..
for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "attacker_stage_1_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_1_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2_cindy_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_4_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_4_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_4_helpers") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_flow") then
		line:enable_random_deployment_position();		
	end
end;

bm:print_toggle_slots()
bm:print_capture_locations()

belakor_throne = "composite_scene/cutscenes/belakor_fb/sq01_shadows/shot/s010_belakor_ingame_idle_shot_t01.csc";

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_01");

wh3_intro_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_01");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_02");

wh3_reveal_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_02");
 
-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_03");

wh3_outro_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_03");
wh3_outro_sfx_02 = new_sfx("Play_wh3_main_qb_belakor_final_battle_04");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();
	cam_pos_intro = cam:position();
	cam_targ_intro = cam:target();

	bm:start_terrain_composite_scene(belakor_throne, nil, 0)
	bm:stop_terrain_composite_scene(belakor_throne)

	cam:fade(false, 2);
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        intro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 22250); --23s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- I sit upon the precipice of godhood, and you have the gall to believe that the bear’s carrion is yours? Come then, try and take it!
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_01"));
				bm:show_subtitle("wh3_belakor_final_survival_01", false, true);
			end
	);

	cutscene_intro:set_music("Final_Battle_Intro", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_player_01.sunits:release_control()
	cam:move_to(cam_pos_intro, cam_targ_intro, 0.25)
	cam:fade(false, 2)
	bm:start_terrain_composite_scene(belakor_throne, nil, 0)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_reveal_cutscene()
    --fade to black over 0.5 seconds
    bm:camera():fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_reveal_cutscene() end, 1000)
end

function play_reveal_cutscene()
    
	local cam_reveal = bm:camera();
	cam_pos_reveal = cam:position();
	cam_targ_reveal = cam:target();
	
	cam_reveal:fade(false, 2);

	local cutscene_reveal = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_reveal",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_reveal_cutscene() end,
        -- path to cindy scene
        reveal_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	cutscene_reveal:action(
		function()
			ga_player_01.sunits:set_invisible_to_all(true);
			ga_player_02.sunits:set_invisible_to_all(true);
		end, 100
	);

	cutscene_reveal:action(
		function()
			ga_player_01.sunits:set_invisible_to_all(false);
			ga_player_02.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:release_control();
			ga_player_02.sunits:release_control();
		end, 18500
	); --19s

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
			ga_player_01.sunits:set_invisible_to_all(false);
			ga_player_02.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:release_control();
			ga_player_02.sunits:release_control();
		end
	);

	-- set up actions on cutscene
	cutscene_reveal:action(function() cam:fade(true, 0.5) end, 18500); --19s

	--Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);

	-- You built an empire to sustain this futile quest – that is the first thing I shatter after my ascension. As I feast on Ursun’s power, my Soul-Grinders shall feed on yours… 
	cutscene_reveal:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_02", 
			function()
				cutscene_reveal:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_02"));
				bm:show_subtitle("wh3_belakor_final_survival_02", false, true);
			end
	);

	cutscene_reveal:set_music("Final_Battle_Mid", 0, 0)

	cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	gb.sm:trigger_message("teleport_sg")
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 0.25)
	ga_player_01.sunits:set_invisible_to_all(false);
	ga_player_02.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:release_control();
	ga_player_02.sunits:release_control();
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

	bm:stop_terrain_composite_scene(belakor_throne)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();
	cam_pos_outro = cam:position();
	cam_targ_outro = cam:target();

	cam_outro:fade(false, 2);

	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_outro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_outro_cutscene() end,
        -- path to cindy scene
        outro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	cutscene_outro:action(
		function()
			ga_player_01.sunits:set_invisible_to_all(true);
			ga_player_02.sunits:set_invisible_to_all(true);
		end, 100
	);

	cutscene_outro:action(
		function()
			ga_player_01.sunits:set_invisible_to_all(false);
			ga_player_02.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:release_control();
			ga_player_02.sunits:release_control();
		end, 15500
	); --16s

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam_outro = bm:camera();
			cam_outro:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
			ga_player_01.sunits:set_invisible_to_all(false);
			ga_player_02.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:release_control();
			ga_player_02.sunits:release_control();
		end
	);

	-- set up actions on cutscene
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 14500); --16s

	--Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);

	-- I may not be a god yet… but you will *suffer*
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_03", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_03"));
				bm:show_subtitle("wh3_belakor_final_survival_03", false, true);
			end
	);

	-- my majesty!
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_04", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_04"));
				bm:show_subtitle("wh3_belakor_final_survival_04", false, true);
			end
	);

	cutscene_outro:set_music("Final_Battle_Outro", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	cam:move_to(cam_pos_outro, cam_targ_outro, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function teleport_def_01_units()
	bm:out("\tbattle_start_teleport_units() called");

	ga_ai_def_01.sunits:item(1).uc:teleport_to_location(v(-22.33, -460.56), 180.0, 35.0);
	ga_ai_def_01.sunits:item(2).uc:teleport_to_location(v(15.09, -458.99), 180.0, 35.9);
	ga_ai_def_01.sunits:item(3).uc:teleport_to_location(v(52.70, -457.41), 180.0, 35.4);
	--ga_ai_def_01.sunits:item(4).uc:teleport_to_location(v(-59.50, -462.13), 180.0, 35.4);
	ga_ai_def_01.sunits:item(4).uc:teleport_to_location(v(-35.12, -430.41), 180.0, 41.4);
	ga_ai_def_01.sunits:item(5).uc:teleport_to_location(v(39.50, -428.02), 180.0, 42.0);
end;

teleport_def_01_units();

function teleport_att_02_4_units()
	bm:out("\tteleport_att_02_4_units() called");

	ga_ai_def_02.sunits:item(1).uc:teleport_to_location(v(-50.45, 131.09), 162.0, 8.80); 
	ga_ai_def_02.sunits:item(3).uc:teleport_to_location(v(-96.16, 97.21), 187.0, 8.80); 
	ga_ai_def_02.sunits:item(5).uc:teleport_to_location(v(-110.52, 81.52), 134.0, 8.80); 
	ga_ai_def_02.sunits:item(7).uc:teleport_to_location(v(-118.29, 69.14), 229.0, 8.80); 
	ga_ai_def_02.sunits:item(2).uc:teleport_to_location(v(-134.99, 54.33), 140.0, 8.80);
	ga_ai_def_02.sunits:item(4).uc:teleport_to_location(v(-153.18, 48.55), 140.0, 8.80);
	ga_ai_def_02.sunits:item(6).uc:teleport_to_location(v(-170.01, 48.30), 140.0, 8.80);
	ga_ai_def_02.sunits:item(8).uc:teleport_to_location(v(-185.72, 40.41), 140.0, 8.80);
end;

gb.sm:add_listener("battle_start", function() teleport_att_02_4_units() end)

function teleport_def_03_units()
	bm:out("\tteleport_def_03_units() called");
	
	ga_ai_def_03.sunits:item(1).uc:teleport_to_location(v(-44.74, 462.17), 166.0, 8.80);
	ga_ai_def_03.sunits:item(2).uc:teleport_to_location(v(44.76, 550.86), 166.0, 8.80);
	ga_ai_def_03.sunits:item(3).uc:teleport_to_location(v(42.60, 467.96), 166.0, 8.80);
	ga_ai_def_03.sunits:item(4).uc:teleport_to_location(v(-39.67, 648.20), 200.0, 8.80);
	--ga_ai_def_03.sunits:item(5).uc:teleport_to_location(v(-45.45, 553.40), 200.0, 8.80); 
	--ga_ai_def_03.sunits:item(6).uc:teleport_to_location(v(44.60, 643.25), 200.0, 8.80); 
end;

gb.sm:add_listener("battle_start", function() teleport_def_03_units() end)

function teleport_boss()
	bm:out("\tteleport_boss() called");
	
	ga_ai_att_04.sunits:item(1).uc:teleport_to_location(v(0.0, 762.66), 180.0, 4.5);

end;

gb.sm:add_listener("battle_start", function() teleport_boss() end)

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb.sm:add_listener("prepare_reveal", function() prepare_for_reveal_cutscene() end);
gb.sm:add_listener("prepare_outro", function() prepare_for_outro_cutscene() end);

-------------------------------------------------------------------------------------------------
----------------------------------------------SETUP----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("battle_start", 10);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_player_01.sunits:release_control();
ga_ai_def_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);

show_attack_closest_unit_debug_output = true;

-------DEFENDER 1-------
ga_ai_def_01:rush_on_message("battle_start");

-------DEFENDER 2-------
gb:add_listener(
	"teleport_sg",
	function()
		-- delay call by .1 second
		bm:callback(
			function()
				ga_ai_def_02.sunits:set_enabled(true);
				ga_ai_def_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);	
			end,
			100
		);
	end
);

gb:message_on_time_offset("def_02_attack", 1000, "teleport_sg");
ga_ai_def_02:rush_on_message("def_02_attack");
ga_ai_def_02:message_on_any_deployed("def_02_in");
ga_ai_def_02:add_to_survival_battle_wave_on_message("def_02_attack", 1, false);
ga_ai_def_02:message_on_rout_proportion("def_02_defeated", 0.99, permit_rampaging);

-------DEFENDER 3-------
gb:add_listener(
	"ready_ai_wave_03",
	function()
		-- delay call by .1 second
		bm:callback(
			function()
				ga_ai_def_03.sunits:set_enabled(true);
				ga_ai_def_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			end,
			100
		);
	end
);

ga_ai_def_03:defend_on_message("ready_ai_wave_03" , 0, 600, 100);
ga_ai_def_03:message_on_casualties("def_03_attack", 0.1);
ga_ai_def_03:attack_on_message("def_03_attack");

-------Gates-------
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_02", "map_barrier_1_2", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_2_3", false);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 1----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("ai_wave_01", 45000, "cp_1_owned");
gb:message_on_time_offset("ai_wave_01_offset", 2500, "ai_wave_01");
gb:message_on_all_messages_received("ready_ai_wave_02", "wave_01_1_defeated", "wave_01_2_defeated")

-----ARMY1-----
ga_ai_att_01_1:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_1:message_on_any_deployed("1_1_in");
ga_ai_att_01_1:rush_on_message("1_1_in");
ga_ai_att_01_1:message_on_rout_proportion("wave_01_1_defeated", 0.99, permit_rampaging);
ga_ai_att_01_1:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_1:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	5000, 						-- min period
	5000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"1_1_in",
	function()
		ga_ai_att_01_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_01_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_01_2:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_2:message_on_any_deployed("1_2_in");
ga_ai_att_01_2:rush_on_message("1_2_in");
ga_ai_att_01_2:message_on_rout_proportion("wave_01_2_defeated", 0.99, permit_rampaging);
ga_ai_att_01_2:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_2:deploy_at_random_intervals_on_message(
	"ai_wave_01_offset", 		-- message
	1, 							-- min units
	1, 							-- max units
	5000, 						-- min period
	5000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"1_2_in",
	function()
		ga_ai_att_01_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_01_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 2----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("prepare_reveal", 45000, "cp_2_owned");
gb:message_on_time_offset("ai_wave_02", 1000, "reveal_cutscene_end");
gb:message_on_time_offset("ai_wave_02_offset", 45000, "ai_wave_02");
gb:message_on_time_offset("ai_wave_02_offset_next", 3000, "ai_wave_02_offset");
gb:message_on_all_messages_received("ready_ai_wave_03", "wave_02_1_defeated", "wave_02_2_defeated", "wave_02_3_defeated", "def_02_defeated");


-----ARMY1-----
ga_ai_att_02_1:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_1:message_on_any_deployed("2_1_in");
ga_ai_att_02_1:rush_on_message("2_1_in");
ga_ai_att_02_1:message_on_rout_proportion("wave_02_1_defeated", 0.99, permit_rampaging);
ga_ai_att_02_1:deploy_at_random_intervals_on_message(
	"ai_wave_02_offset", 		-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"2_1_in",
	function()
		ga_ai_att_02_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_02_2:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_2:message_on_any_deployed("2_2_in");
ga_ai_att_02_2:rush_on_message("2_2_in");
ga_ai_att_02_2:message_on_rout_proportion("wave_02_2_defeated", 0.99, permit_rampaging);
ga_ai_att_02_2:deploy_at_random_intervals_on_message(
	"ai_wave_02_offset_next", 	-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"2_2_in",
	function()
		ga_ai_att_02_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY3-----
ga_ai_att_02_3:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_3:message_on_any_deployed("2_3_in");
ga_ai_att_02_3:rush_on_message("2_3_in");
ga_ai_att_02_3:message_on_rout_proportion("wave_02_3_defeated", 0.99, permit_rampaging);
ga_ai_att_02_3:deploy_at_random_intervals_on_message(
	"ai_wave_02", 				-- message
	1, 							-- min units
	1, 							-- max units
	1000, 						-- min period
	1000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"2_3_in",
	function()
		ga_ai_att_02_3.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_3.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------BOSS WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("prepare_outro", 45000, "cp_3_owned");
gb:message_on_time_offset("boss_time", 100, "outro_cutscene_end");
gb:message_on_time_offset("boss_time_offset_1", 4000, "boss_time");
gb:message_on_time_offset("boss_time_offset_2", 4000, "boss_time_offset_1");
gb:message_on_time_offset("end_game", 1000, "boss_defeated");

-----ARMY1-----
ga_ai_att_03_1:message_on_any_deployed("3_1_in");
ga_ai_att_03_1:rush_on_message("3_1_in");
ga_ai_att_03_1:deploy_at_random_intervals_on_message(
	"boss_time_offset_1", 				-- message
	1, 							-- min units
	1, 							-- max units
	15000, 						-- min period
	15000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"3_1_in",
	function()
		ga_ai_att_03_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_03_2:message_on_any_deployed("3_2_in");
ga_ai_att_03_2:rush_on_message("3_2_in");
ga_ai_att_03_2:deploy_at_random_intervals_on_message(
	"boss_time_offset_2", 		-- message
	1, 							-- min units
	1, 							-- max units
	15000, 						-- min period
	15000, 						-- max period
	"boss_defeated",			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"3_2_in",
	function()
		ga_ai_att_03_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

gb:add_listener(
	"boss_defeated",
	function()
		if ga_ai_att_03_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_03_1.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_att_03_2.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_03_2.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
	end,
	true
);

-----BOSS ARMY-----
ga_ai_att_04:message_on_any_deployed("4_in");
ga_ai_att_04:rush_on_message("4_in");
ga_ai_att_04:message_on_rout_proportion("boss_defeated", 1.0, permit_rampaging);
ga_ai_att_04:add_to_survival_battle_wave_on_message("outro_cutscene_end", 2, true);

gb:add_listener(
	"outro_cutscene_end",
	function()
		-- delay call by .1 second
		bm:callback(
			function()
				ga_ai_att_04.sunits:set_enabled(true);
				ga_ai_att_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);	
			end,
			100
		);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------FLOW WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_flow_01:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	25000, 						-- min period
	25000, 						-- max period
	"cp_2_owned", 				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_flow_01:message_on_any_deployed("flow_01_in");
ga_ai_flow_01:rush_on_message("flow_01_in");

gb:add_listener(
	"flow_01_in",
	function()
		--ga_ai_flow_01.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_flow_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_02:deploy_at_random_intervals_on_message(
	"reveal_cutscene_end", 		-- message
	1, 							-- min units
	1, 							-- max units
	20000, 						-- min period
	20000, 						-- max period
	"cp_3_owned", 				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_flow_02:message_on_any_deployed("flow_02_in");
ga_ai_flow_02:rush_on_message("flow_02_in");

gb:add_listener(
	"flow_02_in",
	function()
		--ga_ai_flow_02.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_flow_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_03:deploy_at_random_intervals_on_message(
	"boss_time", 				-- message
	1, 							-- min units
	1, 							-- max units
	15000, 						-- min period
	15000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_flow_03:message_on_any_deployed("flow_03_in");
ga_ai_flow_03:rush_on_message("flow_03_in");

gb:add_listener(
	"flow_03_in",
	function()
		ga_ai_flow_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

gb:add_listener(
	"boss_defeated",
	function()
		if ga_ai_flow_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_01.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_flow_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_02.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_flow_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_03.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
---------------------------------------SOUL GRINDER WAVES----------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("production_lines", 10000, "outro_cutscene_end");
gb:message_on_time_offset("production_lines_offset_1", 40000, "production_lines");
gb:message_on_time_offset("production_lines_offset_2", 40000, "production_lines_offset_1");

ga_ai_soul_grinder_01:deploy_at_random_intervals_on_message(
	"production_lines", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_01:message_on_any_deployed("grinder_01_in");
ga_ai_soul_grinder_01:rush_on_message("grinder_01_in");

ga_ai_soul_grinder_02:deploy_at_random_intervals_on_message(
	"production_lines", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_02:message_on_any_deployed("grinder_02_in");
ga_ai_soul_grinder_02:rush_on_message("grinder_02_in");

ga_ai_soul_grinder_03:deploy_at_random_intervals_on_message(
	"production_lines_offset_1", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_03:message_on_any_deployed("grinder_03_in");
ga_ai_soul_grinder_03:rush_on_message("grinder_03_in");

ga_ai_soul_grinder_04:deploy_at_random_intervals_on_message(
	"production_lines_offset_1", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_04:message_on_any_deployed("grinder_04_in");
ga_ai_soul_grinder_04:rush_on_message("grinder_04_in");

ga_ai_soul_grinder_05:deploy_at_random_intervals_on_message(
	"production_lines_offset_2", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_05:message_on_any_deployed("grinder_05_in");
ga_ai_soul_grinder_05:rush_on_message("grinder_05_in");

ga_ai_soul_grinder_06:deploy_at_random_intervals_on_message(
	"production_lines_offset_2", 		-- message
	1, 							-- min units
	1, 							-- max units
	120000, 						-- min period
	120000, 						-- max period
	"boss_defeated", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_soul_grinder_06:message_on_any_deployed("grinder_06_in");
ga_ai_soul_grinder_06:rush_on_message("grinder_06_in");

gb:add_listener(
	"boss_defeated",
	function()
		if ga_ai_soul_grinder_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_01.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_soul_grinder_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_02.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_soul_grinder_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_03.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_soul_grinder_04.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_04.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_soul_grinder_05.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_05.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
		if ga_ai_soul_grinder_06.sunits:are_any_active_on_battlefield() == true then
			ga_ai_soul_grinder_06.sunits:kill_proportion_over_time(1.0, 3000, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
-------------------------------------------OBJECTIVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("wave_01_45", 2500, "cp_1_owned");
gb:queue_help_on_message("wave_01_45", "wh3_survival_waves_timer_45", 2000, 500);
gb:message_on_time_offset("wave_01_30", 15000, "wave_01_45");
gb:queue_help_on_message("wave_01_30", "wh3_survival_waves_timer_30", 2000, 500);
gb:message_on_time_offset("wave_01_45", 15000, "wave_01_30");
gb:queue_help_on_message("wave_01_15", "wh3_survival_waves_timer_15", 2000, 500);

gb:message_on_time_offset("wave_02_45", 2500, "cp_2_owned");
gb:queue_help_on_message("wave_02_45", "wh3_survival_waves_timer_45", 2000, 500);
gb:message_on_time_offset("wave_02_30", 15000, "wave_02_45");
gb:queue_help_on_message("wave_02_30", "wh3_survival_waves_timer_30", 2000, 500);
gb:message_on_time_offset("wave_02_45", 15000, "wave_02_30");
gb:queue_help_on_message("wave_02_15", "wh3_survival_waves_timer_15", 2000, 500);

gb:message_on_time_offset("wave_03_45", 2500, "cp_3_owned");
gb:queue_help_on_message("wave_03_45", "wh3_survival_waves_timer_45", 2000, 500);
gb:message_on_time_offset("wave_03_30", 15000, "wave_03_45");
gb:queue_help_on_message("wave_03_30", "wh3_survival_waves_timer_30", 2000, 500);
gb:message_on_time_offset("wave_03_45", 15000, "wave_03_30");
gb:queue_help_on_message("wave_03_15", "wh3_survival_waves_timer_15", 2000, 500);

gb:add_listener(
	"obj_01",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_dae_bridge", 
			v(-99.18, 134.61, -496.83), 
			v(86.60, 2.51, -343.29), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_1_owned", "wh3_survival_point_dae_bridge", 1000);
gb:remove_objective_on_message("1_1_deployed", "wh3_survival_point_dae_bridge", 1000);

gb:add_listener(
	"obj_02",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_dae_engine", 
			v(74.48, 151.41, -123.46), 
			v(98.59, 3.34, 27.05), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_2_owned", "wh3_survival_point_dae_engine", 1000);
gb:remove_objective_on_message("def_02_in", "wh3_survival_point_dae_engine", 1000);

gb:add_listener(
	"obj_03",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_dae_throne", 
			v(-1.48, 80.56, 503.96),
			v(12.43, 42.00, 747.87),
			1, 
			true
		);
	end
);
gb:complete_objective_on_message("cp_3_owned", "wh3_survival_point_dae_throne", 1000);
gb:remove_objective_on_message("3_1_deployed", "wh3_survival_point_dae_throne", 1000);

gb:set_objective_with_leader_on_message("outro_cutscene_end", "wh3_survival_boss_daemon", 1000);
gb:complete_objective_on_message("boss_dead", "wh3_survival_boss_daemon", 1000);

gb:message_on_time_offset("obj_01", 3000, "battle_start");
gb:message_on_time_offset("obj_02", 3000, "ready_ai_wave_02");
gb:message_on_time_offset("obj_03", 3000, "ready_ai_wave_03");

gb:set_objective_with_leader_on_message("1_1_deployed", "wh3_survival_wave_belakor", 1000);
gb:complete_objective_on_message("ready_ai_wave_02", "wh3_survival_wave_belakor", 1000);
gb:remove_objective_on_message("obj_02", "wh3_survival_wave_belakor", 1000);

gb:set_objective_with_leader_on_message("def_02_in", "wh3_survival_wave_belakor", 1000);
gb:complete_objective_on_message("ready_ai_wave_03", "wh3_survival_wave_belakor", 1000);
gb:remove_objective_on_message("obj_03", "wh3_survival_wave_belakor", 1000);

gb:add_listener(
	"4_deployed",
	function()
		if ga_ai_att_04.sunits:are_any_active_on_battlefield() == true then
			bm:set_objective_with_leader("wh3_survival_boss_daemon");
		end;
	end,
	true
);

gb:complete_objective_on_message("end_game", "wh3_survival_boss_daemon", 1000);

---------------
-----WAVES-----
---------------

core:add_listener(
	"waves_defeated",
	"ScriptEventSurvivalBattleWaveDefeated",
	true,
	function(context)
		local index = context:index();
		if index == 0 then
			gb.sm:trigger_message("wave_01_defeated");
		elseif index == 1 then
			gb.sm:trigger_message("wave_02_defeated");
		elseif index == 2 then
			gb.sm:trigger_message("wave_03_defeated");
		end;
	end,
	true
);

gb:message_on_time_offset("boss_dead", 7500, "end_game");

gb:add_listener(
	"boss_dead",
	function()
		-- delay call by 1 second
		bm:callback(
			function()
				bm:end_battle()
				cam:fade(true, 2.0)
				bm:change_victory_countdown_limit(0)
				bm:notify_survival_completion()
			end,
			3000
		);
	end
);

---------------------------------------------
-----------------OUTRO TEXTS-----------------
---------------------------------------------

--ga_player_01:message_on_victory("player_wins");
ga_player_01:message_on_defeat("player_loses");

loading_screen_key_defeat = "wh3_main_survival_forge_of_souls_outro";

sm:add_listener(
	"player_loses",
	function()
		core:add_listener(
			"set_loading_screen",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_dismiss_results";
			end,
			function()
				common.set_custom_loading_screen_key(loading_screen_key_defeat);
			end,
			false
		);
	end
);

---------------------------------------------
--------------------DEBUG--------------------
---------------------------------------------

core:add_listener(
	"skip_wave_listener",
	"ComponentLClickUp",
	function(context)
		return context.string == "dev_button_skip_wave";
	end,
	function()
		if ga_ai_att_01_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_01_1.sunits:rout_over_time(1000);
			ga_ai_att_01_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_01_2.sunits:rout_over_time(1000);
			ga_ai_att_01_2.sunits:cancel_deploy_at_random_intervals();
		elseif ga_ai_att_02_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_02_1.sunits:rout_over_time(1000);
			ga_ai_att_02_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_02_2.sunits:rout_over_time(1000);
			ga_ai_att_02_2.sunits:cancel_deploy_at_random_intervals();
			ga_ai_def_02.sunits:rout_over_time(1000);
		elseif ga_ai_att_03_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_03_1.sunits:rout_over_time(1000);
			ga_ai_att_03_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_03_2.sunits:rout_over_time(1000);
			ga_ai_att_03_2.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_01.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_01.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_02.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_02.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_03.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_03.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_04.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_04.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_05.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_05.sunits:cancel_deploy_at_random_intervals();
			ga_ai_soul_grinder_06.sunits:rout_over_time(1000);
			ga_ai_soul_grinder_06.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_04.sunits:rout_over_time(1000);
		end;
	end,
	true
);