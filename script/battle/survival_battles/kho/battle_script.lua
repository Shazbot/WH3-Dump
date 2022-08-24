load_script_libraries();

cam:fade(true, 0);

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

required_waves_kills = 4;
local sm = get_messager();
survival_mode = {};

intro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\intro.CindySceneManager";
help_01_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold01.CindySceneManager";
--help_02_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold02.CindySceneManager";
help_03_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold03.CindySceneManager";
help_04_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold04.CindySceneManager";
reveal_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\reveal.CindySceneManager";
outro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\outro.CindySceneManager";

bm:force_custom_battle_result("wh3_demo_victory", true);
bm:force_custom_battle_result("wh3_demo_defeat", false);

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

ga_ai_att_01_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_1");
ga_ai_att_01_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_2");
ga_ai_att_02_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_1");
ga_ai_att_02_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_2");
ga_ai_att_03_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_1");
ga_ai_att_03_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_2");

ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss");
ga_ai_att_05 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_backup");
ga_ai_att_06_1 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_wave_1");
ga_ai_att_06_2 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_wave_2");

ga_ai_def_02:get_army():suppress_reinforcement_adc(1);
ga_ai_def_03:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_01:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_02:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_03:get_army():suppress_reinforcement_adc(1);
ga_ai_att_01_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_01_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_04:get_army():suppress_reinforcement_adc(1);
ga_ai_att_05:get_army():suppress_reinforcement_adc(1);
ga_ai_att_06_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_06_2:get_army():suppress_reinforcement_adc(1);

-- reinforcement_manager_script:set_cost_based_support_units_event("event_number_0", 0);
local reinforcements = bm:reinforcements();

reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 1000);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_2", 1000, 1500);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1500, 9999999);

gb:add_listener(
	"cp_1_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

gb:add_listener(
	"cp_2_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_2");
	end
);

gb:add_listener(
	"cp_3_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_3");
	end
);

-- build spawn zone collections
sz_collection_1_left = bm:get_spawn_zone_collection_by_name("attacker_stage_1_left");
sz_collection_1_right = bm:get_spawn_zone_collection_by_name("attacker_stage_1_right");
sz_collection_2_left = bm:get_spawn_zone_collection_by_name("attacker_stage_2_left");
sz_collection_2_right = bm:get_spawn_zone_collection_by_name("attacker_stage_2_right");
sz_collection_3_left = bm:get_spawn_zone_collection_by_name("attacker_stage_3_left", "attacker_stage_4_left");
sz_collection_3_right = bm:get_spawn_zone_collection_by_name("attacker_stage_3_right", "attacker_stage_4_right");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("attacker_stage_4_helpers");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("attacker_boss");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("attacker_flow");

-- Setup Currency Caps
local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_ruined_fort");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp_blood_pits");
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp_boiling_moat");

capture_point_01:set_income_cap_for_alliance(bm:get_player_alliance(), 6000.0);
capture_point_02:set_income_cap_for_alliance(bm:get_player_alliance(), 6000.0);
capture_point_03:set_income_cap_for_alliance(bm:get_player_alliance(), 6000.0);

-- Link capture point with support units unlock event, so we can display this information on the capture point tooltip
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_2", capture_point_02);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_3", capture_point_03);

------FLOW 01------
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_6, false);
ga_ai_flow_01:message_on_number_deployed("flow_01_deployed", true, 1);
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("flow_01_deployed", sz_collection_6, false);

------FLOW 02------
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_6, false);
ga_ai_flow_02:message_on_number_deployed("flow_02_deployed", true, 1);
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("flow_02_deployed", sz_collection_6, false);

------FLOW 03------
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_6, false);
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

-----WAVE 3_1-----
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_3_left, false);
ga_ai_att_03_1:message_on_number_deployed("3_1_deployed", true, 1);
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("3_1_deployed", sz_collection_3_left, false);

-----WAVE 3_2-----
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_3_right, false);
ga_ai_att_03_2:message_on_number_deployed("3_2_deployed", true, 1);
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("3_2_deployed", sz_collection_3_right, false);

------WAVE BOSS------
ga_ai_att_04:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_5, false);

------WAVE BOSS BACKUP------
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_4, false);
ga_ai_att_05:message_on_number_deployed("5_deployed", true, 1);
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("5_deployed", sz_collection_4, false);

-----WAVE BOSS MINIONS_1-----
ga_ai_att_06_1:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_3_left, false);
ga_ai_att_06_1:message_on_number_deployed("6_1_deployed", true, 1);
ga_ai_att_06_1:assign_to_spawn_zone_from_collection_on_message("6_1_deployed", sz_collection_3_left, false);

-----WAVE BOSS MINIONS_2-----
ga_ai_att_06_2:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_3_right, false);
ga_ai_att_06_2:message_on_number_deployed("6_2_deployed", true, 1);
ga_ai_att_06_2:assign_to_spawn_zone_from_collection_on_message("6_2_deployed", sz_collection_3_right, false);

-- Set random deployment position in a reinforcement line..

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

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_01");
wh3_intro_sfx_01 = new_sfx("Play_wh3_khorne_demo_intro_survival_01");
wh3_intro_sfx_02 = new_sfx("Play_wh3_khorne_demo_intro_survival_02");
wh3_intro_sfx_03 = new_sfx("Play_wh3_khorne_demo_intro_survival_03");
wh3_intro_sfx_04 = new_sfx("Play_wh3_khorne_demo_intro_survival_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_02"); 
wh3_reveal_sfx_01 = new_sfx("Play_wh3_khorne_demo_reveal_survival_01");
wh3_reveal_sfx_02 = new_sfx("Play_wh3_khorne_demo_reveal_survival_02");
wh3_reveal_sfx_03 = new_sfx("Play_wh3_khorne_demo_reveal_survival_03");
wh3_reveal_sfx_04 = new_sfx("Play_wh3_khorne_demo_reveal_survival_04");
wh3_reveal_sfx_05 = new_sfx("Play_wh3_khorne_demo_reveal_survival_05");
wh3_reveal_sfx_06 = new_sfx("Play_wh3_khorne_demo_reveal_survival_06");
wh3_reveal_sfx_07 = new_sfx("Play_wh3_khorne_demo_reveal_survival_07");
wh3_reveal_sfx_08 = new_sfx("Play_wh3_khorne_demo_reveal_survival_08");
wh3_reveal_sfx_09 = new_sfx("Play_wh3_khorne_demo_reveal_survival_09");
wh3_reveal_sfx_10 = new_sfx("Play_wh3_khorne_demo_reveal_survival_10");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_03");
wh3_outro_sfx_01 = new_sfx("Play_wh3_khorne_demo_outro_survival_01");

-------------------------------------------------------------------------------------------------
------------------------------------------ EXTRA VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_extra_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_04");
wh3_extra_sfx_01 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_05");
wh3_extra_sfx_02 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_06");
wh3_extra_sfx_03 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_07");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	cam:fade(false, 3);

	local intro_units_hidden = false;
	
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
        2
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			--cam:fade(true, 2);
			bm:stop_cindy_playback(true);
			
			if intro_units_hidden then
				ga_player_01.sunits:set_enabled(true, false) 
			end;

			--bm:callback(function() cam:fade(false, 2) end, 2000);
		end
	);

	cutscene_intro:action(
		function()
			intro_units_hidden = true;
			ga_player_01.sunits:set_enabled(false, false) 
		end, 
		100
	);

	cutscene_intro:action(
		function()
			intro_units_hidden = false;
			ga_player_01.sunits:set_enabled(true, false) 
		end, 
		30000
	);	

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 2) end, 1000);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_01) end, 100);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_01", "subtitle_with_frame", 0.1)	end, 1000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_02) end, 12000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_02", "subtitle_with_frame", 0.1)	end, 12000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_03) end, 24500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_03", "subtitle_with_frame", 0.1)	end, 24500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_04) end, 34000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_04", "subtitle_with_frame", 0.1)	end, 34000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 50500);

	cutscene_intro:start()
end;

function end_intro_cutscene()
	gb.sm:trigger_message("intro_cutscene_end")
	ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_player_01.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_reveal_cutscene()
    --fade to black over 0.5 seconds
    cam:fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_reveal_cutscene() end, 1000)
end

function play_reveal_cutscene()
    
	cam_pos_reveal = cam:position();
	cam_targ_reveal = cam:target();

	cam:fade(false, 0.5);
		
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

	cutscene_reveal:set_post_cutscene_fade_time(0.5);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

	-- Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);	
	
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_10) end, 100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_10", "subtitle_with_frame", 3)	end, 100);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 9600);

	cutscene_reveal:start()

end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	--cam:fade(false, 0.5)
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 3.0)
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    cam:fade(true, 1.0)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	cam:fade(false, 0.5);

	local outro_units_hidden = false;
		
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

	cutscene_outro:set_post_cutscene_fade_time(-1);			-- never fade back to picture

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if outro_units_hidden then
				ga_player_01.sunits:set_invisible_to_all(true)
				ga_player_02.sunits:set_invisible_to_all(true)
			end;

			bm:callback(function() cam:fade(true, 0.5) end, 1000);
		end
	);

	cutscene_outro:action(
		function()
			outro_units_hidden = true;
			ga_player_01.sunits:set_invisible_to_all(true)
			ga_player_01.sunits:change_behaviour_active("fire_at_will", false)
			ga_player_02.sunits:set_invisible_to_all(true)
			ga_player_02.sunits:change_behaviour_active("fire_at_will", false)
		end, 
		100
	);

	cutscene_outro:action(
		function()
			outro_units_hidden = false;
			ga_player_01.sunits:set_invisible_to_all(false)
			ga_player_02.sunits:set_invisible_to_all(false)
		end, 
		20000
	);	

	-- Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);	

	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_01) end, 100);	
	cutscene_outro:action(function() cutscene_outro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_outro_survival_01", "subtitle_with_frame", 3)	end, 100);	
	cutscene_outro:action(function() cutscene_outro:hide_custom_cutscene_subtitles() end, 20100);

	cutscene_outro:start()
end;

function end_outro_cutscene()
	cam:fade(true, 0.5)
	gb.sm:trigger_message("outro_cutscene_end")
	bm:change_victory_countdown_limit(0)
	bm:notify_survival_completion()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb.sm:add_listener("play_foothold_01", function() play_foothold_01_cutscene() end);
gb.sm:add_listener("play_foothold_03", function() play_foothold_03_cutscene() end);
gb.sm:add_listener("play_foothold_04", function() play_foothold_04_cutscene() end);
gb.sm:add_listener("prepare_reveal", function() prepare_for_reveal_cutscene() end);
gb.sm:add_listener("prepare_outro", function() prepare_for_outro_cutscene() end);

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
	--Player Starting Units - teleport units of ga_player_01- e.g. [x ,z], [orientation of 180 degrees, width of 25m]
	
	ga_player_01.sunits:item(1).uc:teleport_to_location(v(0.00, -610.00), 0.0, 1.4); 

	ga_player_01.sunits:item(2).uc:teleport_to_location(v(-43.65, -617.67), 0.0, 26.90);
	ga_player_01.sunits:item(3).uc:teleport_to_location(v(-14.76, -617.67), 0.0, 26.90);
	ga_player_01.sunits:item(4).uc:teleport_to_location(v(14.13, -617.67), 0.0, 26.90);
	ga_player_01.sunits:item(5).uc:teleport_to_location(v(43.03, -617.67), 0.0, 26.90);

	ga_player_01.sunits:item(6).uc:teleport_to_location(v(-36.80, -636.29), 0.0, 33.70); 
	ga_player_01.sunits:item(7).uc:teleport_to_location(v(-1.12, -636.29), 0.0, 33.70);
	ga_player_01.sunits:item(8).uc:teleport_to_location(v(34.55, -636.29), 0.0, 33.70);

	ga_player_01.sunits:item(9).uc:teleport_to_location(v(-35.64, -595.08), 0.0, 40.40);
	ga_player_01.sunits:item(10).uc:teleport_to_location(v(36.62, -595.08), 0.0, 40.40); 
	
	ga_player_01.sunits:release_control();
	ga_player_02.sunits:release_control();
	--ga_player_01.sunits:change_behaviour_active("skirmish", false);		
end;

gb:message_on_time_offset("teleport", 10);
gb.sm:add_listener("teleport", function() battle_start_teleport_units() end)

function teleport_def_02_units()
	bm:out("\tteleport_def_02_units() called");
	
	ga_ai_def_02.sunits:item(1).uc:teleport_to_location(v(31.40, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(2).uc:teleport_to_location(v(11.20, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(3).uc:teleport_to_location(v(-9.00, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(4).uc:teleport_to_location(v(-29.19, 18.22), 180.0, 18.2); 

	ga_ai_def_02.sunits:item(5).uc:teleport_to_location(v(20.91, 42.86), 180.0, 39.0);
	ga_ai_def_02.sunits:item(6).uc:teleport_to_location(v(-20.09, 42.86), 180.0, 39.0);

	ga_ai_def_02.sunits:set_enabled(false);
end;

gb.sm:add_listener("teleport", function() teleport_def_02_units() end)

function teleport_def_03_units()
	bm:out("\tteleport_def_03_units() called");
	
	ga_ai_def_03.sunits:item(1).uc:teleport_to_location(v(31.37, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(2).uc:teleport_to_location(v(11.17, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(3).uc:teleport_to_location(v(-9.03, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(4).uc:teleport_to_location(v(-29.23, 305.91), 180.0, 18.20);

	ga_ai_def_03.sunits:item(5).uc:teleport_to_location(v(21.92, 330.04), 180.0, 39.00); 
	ga_ai_def_03.sunits:item(6).uc:teleport_to_location(v(-19.08, 330.04), 180.0, 39.00); 

	ga_ai_def_03.sunits:item(7).uc:teleport_to_location(v(0.0, 352.99), 180.0, 4.14); 

	ga_ai_def_03.sunits:set_enabled(false);
	--ga_ai_def_03.sunits:release_control();	
end;

gb.sm:add_listener("teleport", function() teleport_def_03_units() end)

-------------------------------------------------------------------------------------------------
----------------------------------------------SETUP----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_def_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);

gb:add_listener(
	"cp_1_owned",
	function()
		if ga_player_02.sunits:are_any_active_on_battlefield() == true then
			ga_player_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end;
	end,
	true
);

show_attack_closest_unit_debug_output = true;

-------DEFENDER 1-------
gb:add_listener(
	"intro_cutscene_end",
	function()
		-- delay call by 1 second
		bm:callback(
			function()
				ga_ai_def_01.sunits:start_attack_closest_enemy(nil, true);
			end,
			500
		);
	end
);

-------DEFENDER 2-------
gb:add_listener(
	"play_foothold_03",
	function()
		-- delay call by .5 second
		bm:callback(
			function()
					ga_ai_def_02.sunits:set_enabled(true);
					ga_ai_def_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);		
			end,
			500
		);
	end
);

ga_ai_def_02:rush_on_message("foothold_03_cutscene_end");

-------DEFENDER 3-------
gb:add_listener(
	"play_foothold_04",
	function()
		-- delay call by .5 second
		bm:callback(
			function()
					ga_ai_def_03.sunits:set_enabled(true);
					ga_ai_def_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			end,
			500
		);
	end
);

ga_ai_def_03:rush_on_message("foothold_04_cutscene_end");

-------Gates-------
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_02", "map_barrier_1_2", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_2_3", false);

-------Audio-------
ga_player_01:play_general_vo_on_message("ai_wave_01", wh3_reveal_sfx_05);
ga_player_01:play_general_vo_on_message("cp_2_owned", wh3_reveal_sfx_07);
ga_player_01:play_general_vo_on_message("cp_3_owned", wh3_reveal_sfx_09);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 1----------------------------------------------
-------------------------------------------------------------------------------------------------

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_capture_location_capture_completed("cp_1_owned", "intro_cutscene_end", "cp_ruined_fort", nil, ga_ai_def_01, ga_player_01);
gb:message_on_time_offset("play_foothold_01", 7500, "cp_1_owned");
gb:message_on_time_offset("ai_wave_01", 20000, "foothold_01_cutscene_end");
gb:message_on_time_offset("play_foothold_03", 5000, "ready_ai_wave_02");
gb:message_on_all_messages_received("ready_ai_wave_02", "wave_01_1_defeated", "wave_01_2_defeated")

-----ARMY1-----
ga_ai_att_01_1:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_1:message_on_any_deployed("1_1_in");
ga_ai_att_01_1:rush_on_message("1_1_in");
ga_ai_att_01_1:message_on_rout_proportion("wave_01_1_defeated", 0.99);
ga_ai_att_01_1:message_on_rout_proportion("wave_01_2_hook", 0.8);
ga_ai_att_01_1:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_1:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
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
ga_ai_att_01_2:message_on_rout_proportion("wave_01_2_defeated", 0.99);
ga_ai_att_01_2:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_2:deploy_at_random_intervals_on_message(
	"wave_01_2_hook", 			-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
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

gb:message_on_capture_location_capture_completed("cp_2_owned", "ready_ai_wave_02", "cp_blood_pits", nil, ga_ai_def_01, ga_player_01);
gb:message_on_time_offset("ai_wave_02", 20000, "cp_2_owned");
gb:message_on_time_offset("ai_wave_02_offset", 2500, "ai_wave_02");
gb:message_on_time_offset("play_foothold_04", 5000, "ready_ai_wave_03");
gb:message_on_all_messages_received("ready_ai_wave_03", "wave_02_1_defeated", "wave_02_2_defeated")

-----ARMY1-----
ga_ai_att_02_1:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_1:message_on_any_deployed("2_1_in");
ga_ai_att_02_1:rush_on_message("2_1_in");
ga_ai_att_02_1:message_on_rout_proportion("wave_02_1_defeated", 0.99);
ga_ai_att_02_1:rout_over_time_on_message("ready_ai_wave_03", 3000);
ga_ai_att_02_1:deploy_at_random_intervals_on_message(
	"ai_wave_02", 				-- message
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
ga_ai_att_02_2:message_on_rout_proportion("wave_02_2_defeated", 0.99);
ga_ai_att_02_2:rout_over_time_on_message("ready_ai_wave_03", 3000);
ga_ai_att_02_2:deploy_at_random_intervals_on_message(
	"ai_wave_02_offset", 		-- message
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
	"2_2_in",
	function()
		ga_ai_att_02_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 3----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_capture_location_capture_completed("cp_3_owned", "ready_ai_wave_03", "cp_boiling_moat", nil, ga_ai_def_01, ga_player_01);
gb:message_on_time_offset("ai_wave_03", 20000, "cp_3_owned");
gb:message_on_time_offset("ai_wave_03_offset", 3000, "ai_wave_03");
gb:message_on_time_offset("play_foothold_04", 5000, "ready_ai_wave_03");
gb:message_on_all_messages_received("prepare_for_reveal", "wave_03_1_defeated", "wave_03_2_defeated")

-----ARMY1-----
ga_ai_att_03_1:add_to_survival_battle_wave_on_message("ai_wave_03", 2, false);
ga_ai_att_03_1:message_on_any_deployed("3_1_in");
ga_ai_att_03_1:rush_on_message("3_1_in");
ga_ai_att_03_1:message_on_rout_proportion("wave_03_1_defeated", 0.99);
ga_ai_att_03_1:rout_over_time_on_message("prepare_for_reveal", 3000);
ga_ai_att_03_1:deploy_at_random_intervals_on_message(
	"ai_wave_03", 				-- message
	1, 							-- min units
	1, 							-- max units
	6000, 						-- min period
	6000, 						-- max period
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
ga_ai_att_03_2:add_to_survival_battle_wave_on_message("ai_wave_03", 2, false);
ga_ai_att_03_2:message_on_any_deployed("3_2_in");
ga_ai_att_03_2:rush_on_message("3_2_in");
ga_ai_att_03_2:message_on_rout_proportion("wave_03_2_defeated", 0.99);
ga_ai_att_03_2:rout_over_time_on_message("prepare_for_reveal", 3000);
ga_ai_att_03_2:deploy_at_random_intervals_on_message(
	"ai_wave_03_offset", 				-- message
	1, 							-- min units
	1, 							-- max units
	6000, 						-- min period
	6000, 						-- max period
	nil,				 		-- cancel message
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

-------------------------------------------------------------------------------------------------
-------------------------------------------BOSS WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_att_04:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 3, true);
ga_ai_att_04:message_on_rout_proportion("prepare_for_outro", 0.999);
gb:message_on_time_offset("prepare_reveal", 10000, "prepare_for_reveal");
gb:message_on_time_offset("prepare_outro", 10000, "prepare_for_outro");
gb:message_on_time_offset("boss_time", 100, "reveal_cutscene_end");
gb:message_on_time_offset("boss_time_offset_1", 4000, "boss_time");
gb:message_on_time_offset("boss_time_offset_2", 4000, "boss_time_offset_1");

ga_ai_att_04:message_on_any_deployed("4_in");
ga_ai_att_05:message_on_any_deployed("5_in");
ga_ai_att_06_1:message_on_any_deployed("6_1_in");
ga_ai_att_06_2:message_on_any_deployed("6_2_in");

ga_ai_att_04:rush_on_message("4_in");
ga_ai_att_05:rush_on_message("5_in");
ga_ai_att_06_1:rush_on_message("6_1_in");
ga_ai_att_06_2:rush_on_message("6_2_in");

ga_ai_att_05:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_att_06_1:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_att_06_2:rout_over_time_on_message("prepare_for_outro", 1000);

ga_ai_att_04:deploy_at_random_intervals_on_message(
	"boss_time", 				-- message
	1, 							-- min units
	1, 							-- max units
	15000, 						-- min period
	15000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	true,						-- is final survival wave
	false						-- show debug output
);

ga_ai_att_05:deploy_at_random_intervals_on_message(
	"boss_time", 				-- message
	4, 							-- min units
	4, 							-- max units
	500, 						-- min period
	1000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_att_06_1:deploy_at_random_intervals_on_message(
	"boss_time_offset_1", 		-- message
	1, 							-- min units
	1, 							-- max units
	8000, 						-- min period
	8000,  						-- max period
	"prepare_for_outro",		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_att_06_2:deploy_at_random_intervals_on_message(
	"boss_time_offset_2", 		-- message
	1, 							-- min units
	1, 							-- max units
	8000, 						-- min period
	8000, 						-- max period
	"prepare_for_outro",		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"4_in",
	function()
		ga_ai_att_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

gb:add_listener(
	"5_in",
	function()
		ga_ai_att_05.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_05.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:add_listener(
	"6_1_in",
	function()
		ga_ai_att_06_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_06_1.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:add_listener(
	"6_2_in",
	function()
		ga_ai_att_06_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_06_2.sunits:set_always_visible_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------FLOW WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_flow_01:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	2, 							-- min units
	2, 							-- max units
	30000, 						-- min period
	35000, 						-- max period
	"prepare_for_outro", 		-- cancel message
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
		ga_ai_flow_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_02:deploy_at_random_intervals_on_message(
	"cp_2_owned", 				-- message
	2, 							-- min units
	2, 							-- max units
	40000, 						-- min period
	45000, 						-- max period
	"prepare_for_outro", 		-- cancel message
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
		ga_ai_flow_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_03:deploy_at_random_intervals_on_message(
	"cp_3_owned", 				-- message
	2, 							-- min units
	2, 							-- max units
	50000, 						-- min period
	55000, 						-- max period
	"prepare_for_outro", 		-- cancel message
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
		ga_ai_flow_03.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_01:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_flow_02:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_flow_03:rout_over_time_on_message("prepare_for_outro", 1000);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_flow_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_01.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_flow_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_flow_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_03.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_att_05.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_05.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_att_06_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_06_1.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_outro",
	function()
		if ga_ai_att_06_2.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_06_2.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
-------------------------------------------OBJECTIVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"obj_01",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_kho_ruin", 
			v(-75.68, 200.48, -495.46), 
			v(-50.45, 176.24, -474.03), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_1_owned", "wh3_survival_point_kho_ruin", 1000);
gb:remove_objective_on_message("1_1_deployed", "wh3_survival_point_kho_ruin", 1000);

gb:add_listener(
	"obj_02",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_kho_blood", 
			v(-122.25, 192.19, -25.34), 
			v(97.20, 68.37, 79.73), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_2_owned", "wh3_survival_point_kho_blood", 1000);
gb:remove_objective_on_message("2_1_deployed", "wh3_survival_point_kho_blood", 1000);

gb:add_listener(
	"obj_03",
	function()
		bm:set_locatable_objective(
			"wh3_survival_point_kho_torment", 
			v(-72.71, 215.45, 270.60), 
			v(108.58, 90.65, 432.24), 
			1, 
			true
		);
	end
);
gb:complete_objective_on_message("cp_3_owned", "wh3_survival_point_kho_torment", 1000);
gb:remove_objective_on_message("3_1_deployed", "wh3_survival_point_kho_torment", 1000);

gb:set_objective_with_leader_on_message("reveal_cutscene_end", "wh3_survival_boss_khorne", 1000);
gb:complete_objective_on_message("prepare_for_outro", "wh3_survival_boss_khorne", 1000);

gb:message_on_time_offset("obj_01", 3000, "intro_cutscene_end");
gb:message_on_time_offset("obj_02", 3000, "foothold_03_cutscene_end");
gb:message_on_time_offset("obj_03", 3000, "foothold_04_cutscene_end");

gb:set_objective_with_leader_on_message("1_1_deployed", "wh3_survival_wave_khorne", 1000);
gb:complete_objective_on_message("ready_ai_wave_02", "wh3_survival_wave_khorne", 1000);
gb:remove_objective_on_message("obj_02", "wh3_survival_wave_khorne", 1000);

gb:set_objective_with_leader_on_message("2_1_deployed", "wh3_survival_wave_khorne", 1000);
gb:complete_objective_on_message("ready_ai_wave_03", "wh3_survival_wave_khorne", 1000);
gb:remove_objective_on_message("obj_03", "wh3_survival_wave_khorne", 1000);

gb:set_objective_with_leader_on_message("3_1_deployed", "wh3_survival_wave_khorne", 1000);
gb:complete_objective_on_message("prepare_for_reveal", "wh3_survival_wave_khorne", 1000);
gb:remove_objective_on_message("prepare_for_reveal", "wh3_survival_wave_khorne", 1000);

gb:add_listener(
	"4_deployed",
	function()
		if ga_ai_att_04.sunits:are_any_active_on_battlefield() == true then
			bm:set_objective_with_leader("wh3_survival_boss_khorne");
		end;
	end,
	true
);

gb:complete_objective_on_message("prepare_for_outro", "wh3_survival_boss_khorne", 1000);

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
		elseif index == 3 then
			gb.sm:trigger_message("wave_04_defeated");
		end;
	end,
	true
);

gb:add_listener(
	"outro_cutscene_end",
	function()
		-- delay call by 1 second
		bm:callback(
			function()
				bm:end_battle()
			end,
			3000
		);
	end
);

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 01 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_01_cutscene()

	local cutscene_foothold_01 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_01",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_01_cutscene() end,
        -- path to cindy scene
        help_01_cinematic_file,
        -- optional fade in/fade out durations
        3,
        3
	);

	-- skip callback
	cutscene_foothold_01:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_01:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
			ga_player_02.sunits:set_invincible(true);
		end, 
		21000
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_01:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_extra_sfx_00) end, 100);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_01) end, 100);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_01", "subtitle_with_frame", 0.1)	end, 100);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 6100);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_02) end, 6200);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_02", "subtitle_with_frame", 0.1)	end, 6200);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 9700);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_03) end, 12800);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_03", "subtitle_with_frame", 0.1)	end, 12800);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 15900);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_04) end, 20000);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_04", "subtitle_with_frame", 0.1)	end, 20000);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 28000);

	cutscene_foothold_01:start()
end;

function end_foothold_01_cutscene()
	gb.sm:trigger_message("foothold_01_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_02.sunits:set_invincible(false)
	ga_player_01.sunits:release_control()
	ga_player_02.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 03 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_03_cutscene()

	local cutscene_foothold_03 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_03",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_03_cutscene() end,
        -- path to cindy scene
        help_03_cinematic_file,
        -- optional fade in/fade out durations
        3,
        3
	);

	-- skip callback
	cutscene_foothold_03:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_03:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
			ga_player_02.sunits:set_invincible(true);
			ga_ai_def_02.sunits:set_invincible(true);
		end, 
		7100
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_03:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_03:action(function() cutscene_foothold_03:play_sound(wh3_extra_sfx_02) end, 100);

	cutscene_foothold_03:action(function() cutscene_foothold_03:play_sound(wh3_reveal_sfx_06) end, 9100);	
	cutscene_foothold_03:action(function() cutscene_foothold_03:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_06", "subtitle_with_frame", 0.1)	end, 9100);	
	cutscene_foothold_03:action(function() cutscene_foothold_03:hide_custom_cutscene_subtitles() end, 14100);

	cutscene_foothold_03:start()
end;

function end_foothold_03_cutscene()
	gb.sm:trigger_message("foothold_03_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_02.sunits:set_invincible(false)
	ga_ai_def_02.sunits:set_invincible(false)
	ga_player_01.sunits:release_control()
	ga_player_02.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 04 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_04_cutscene()

	local cutscene_foothold_04 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_04",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_04_cutscene() end,
        -- path to cindy scene
        help_04_cinematic_file,
        -- optional fade in/fade out durations
        3,
        1.5
	);

	-- skip callback
	cutscene_foothold_04:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_04:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
			ga_player_02.sunits:set_invincible(true);
			ga_ai_def_03.sunits:set_invincible(true);
		end, 
		11600
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_04:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_04:action(function() cutscene_foothold_04:play_sound(wh3_extra_sfx_03) end, 100);	

	cutscene_foothold_04:action(function() cutscene_foothold_04:play_sound(wh3_reveal_sfx_08) end, 1100);	
	cutscene_foothold_04:action(function() cutscene_foothold_04:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_08", "subtitle_with_frame", 0.1)	end, 1100);	
	cutscene_foothold_04:action(function() cutscene_foothold_04:hide_custom_cutscene_subtitles() end, 10500);

	cutscene_foothold_04:start()
end;

function end_foothold_04_cutscene()
	gb.sm:trigger_message("foothold_04_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_02.sunits:set_invincible(false)
	ga_ai_def_03.sunits:set_invincible(false)
	ga_player_01.sunits:release_control()
	ga_player_02.sunits:release_control()
end;

---------------------------------------------
--------------------DEBUG--------------------
---------------------------------------------

function skip_wave()
	bm:out("");
	bm:out("*** SKIPPING WAVE ***");
	bm:out("");

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
	elseif ga_ai_att_03_1.sunits:are_any_active_on_battlefield() == true then
		ga_ai_att_03_1.sunits:rout_over_time(1000);
		ga_ai_att_03_1.sunits:cancel_deploy_at_random_intervals();
		ga_ai_att_03_2.sunits:rout_over_time(1000);
		ga_ai_att_03_2.sunits:cancel_deploy_at_random_intervals();
	elseif ga_ai_att_04.sunits:are_any_active_on_battlefield() == true then
		ga_ai_att_04.sunits:rout_over_time(1000);
		ga_ai_att_04.sunits:cancel_deploy_at_random_intervals();
	end;
end;

core:add_listener(
	"skip_wave_listener",
	"ComponentLClickUp",
	function(context)
		return context.string == "dev_button_skip_wave";
	end,
	skip_wave,
	true
);