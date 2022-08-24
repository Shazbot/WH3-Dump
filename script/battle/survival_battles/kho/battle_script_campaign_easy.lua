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

intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\kho_citadel_intro_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\kho_reveal_m01.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);
outro_cinematic_file = "script\\battle\\survival_battles\\realm_win\\managers\\realmwin_intro_kho.CindySceneManager";
bm:cindy_preload(outro_cinematic_file);

bm:force_custom_battle_result("wh3_survival_khorne_victory", true);
bm:force_custom_battle_result("wh3_survival_khorne_defeat", false);

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

ga_ai_att_01_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_1");
ga_ai_att_01_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_2");
ga_ai_att_02_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_1");
ga_ai_att_02_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_2");
ga_ai_att_03_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_1");
ga_ai_att_03_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_2");

ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss");
ga_ai_att_05 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_backup");

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

ga_ai_def_02.sunits:set_enabled(false);
ga_ai_def_03.sunits:set_enabled(false);
ga_ai_att_04.sunits:set_enabled(false);

-- build spawn zone collections
sz_collection_1_left = bm:get_spawn_zone_collection_by_name("attacker_stage_1_left", "attacker_flow");
sz_collection_1_right = bm:get_spawn_zone_collection_by_name("attacker_stage_1_right", "attacker_flow");
sz_collection_2_left = bm:get_spawn_zone_collection_by_name("attacker_stage_2_left");
sz_collection_2_right = bm:get_spawn_zone_collection_by_name("attacker_stage_2_right");
sz_collection_3_left = bm:get_spawn_zone_collection_by_name("attacker_stage_3_left", "attacker_stage_4_left");
sz_collection_3_right = bm:get_spawn_zone_collection_by_name("attacker_stage_3_right", "attacker_stage_4_right");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("attacker_stage_4_helpers");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("attacker_boss");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("attacker_flow");

local reinforcements = bm:reinforcements();

reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 1000);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_2", 1000, 1500);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1500, 9999999);

-------------------------------------
----------Capture Locations----------
-------------------------------------

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_ruined_fort");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp_blood_pits");
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp_boiling_moat");

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

ga_ai_def_02:message_on_rout_proportion("def_02_dead", 0.95);

gb:add_listener(
	"def_02_dead",
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

gb:message_on_capture_location_capture_completed("cp_1_owned", "battle_start", "cp_ruined_fort", nil, ga_ai_def_01, ga_player_01);

gb:add_listener(
	"cp_1_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

gb:message_on_capture_location_capture_completed("cp_2_owned", "ready_ai_wave_02", "cp_blood_pits", nil, ga_ai_def_01, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_2_lost", "ready_ai_wave_02", "cp_blood_pits", nil, ga_player_01, ga_ai_def_01);

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

gb:message_on_capture_location_capture_completed("cp_3_owned", "ready_ai_wave_03", "cp_boiling_moat", nil, ga_ai_def_01, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_3_lost", "ready_ai_wave_03", "cp_boiling_moat", nil, ga_player_01, ga_ai_def_01);

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
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_6, false);
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
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_3_left, false);
ga_ai_att_03_1:message_on_number_deployed("3_1_deployed", true, 1);
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("3_1_deployed", sz_collection_3_left, false);

-----WAVE 3_2-----
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_3_right, false);
ga_ai_att_03_2:message_on_number_deployed("3_2_deployed", true, 1);
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("3_2_deployed", sz_collection_3_right, false);

------WAVE BOSS BACKUP------
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_4, false);
ga_ai_att_05:message_on_number_deployed("5_deployed", true, 1);
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("5_deployed", sz_collection_4, false);

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

wh3_intro_sfx_00 = new_sfx("WH3_Survival_Battle_Khonre_Sweetener_01");

wh3_intro_sfx_01 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_01_1");
wh3_intro_sfx_02 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_02_1");
wh3_intro_sfx_03 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_03_1");
wh3_intro_sfx_04 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_04_1");
wh3_intro_sfx_05 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_05_1");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("WH3_Survival_Battle_Khonre_Sweetener_02");

wh3_reveal_sfx_01 = new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_06_1");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("WH3_Survival_Battle_Khonre_Sweetener_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 3);
	
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
			bm:stop_cindy_playback(true);
		end
	);

	-- set up fade actions on cutscene
	--cutscene_intro:action(function() cam:fade(true, 0.5) end, 49800); --55s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- The Brass Citadel! The keep of the Blood God. Home of the Skull Throne.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_01_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_01", false, true);
			end
	);

	-- The Citadel is guarded by eight hundred and eighty-eight Bloodthirsters, but we only need breach its outer-defences to draw out the Gatekeeper.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_02_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_02", false, true);
			end
	);

	-- Start at the Ruined Fort, defeat its garrison and capture the Icon of Ruin. This will give you a foothold and grant us supplies to reinforce for the struggle ahead. 	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_03_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_03", false, true);
			end
	);

	-- There are two other Icons you will need to capture and so dominate the battle. 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_04_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_04", false, true);
			end
	);

	-- You have drawn the Blood God's gaze, make sure you are worthy of his attention. Let the slaughter begin!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_05_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:set_music("Khorne_Intro", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	--gb.sm:trigger_message("intro_cutscene_end")
	ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_player_01.sunits:release_control()
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
        2
	);

	-- set up fade actions on cutscene
	cutscene_reveal:action(function() cam:fade(true, 0.5) end, 18500); --20s

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
		end, 19500
	); --20s

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam_reveal:fade(false, 0.5) end, 1000);
			ga_player_01.sunits:set_invisible_to_all(false);
			ga_player_02.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:release_control();
			ga_player_02.sunits:release_control();
		end
	);

	--Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);
		
	-- Khorne's Gatekeeper! This is the Daemon Prince we seek, whose soul we require. 
	cutscene_reveal:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_battle_intro_06", 
			function()
				cutscene_reveal:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_khorne_battle_intro_06_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_khorne_battle_intro_06", false, true);
			end
	);

	cutscene_reveal:set_music("Khorne_Daemon_Prince", 0, 0)

	cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
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

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();

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
        2
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
		end, 49200
	); --49.7s

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

	-- set up fade actions on cutscene
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 45950); --49.7s

	--Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);
	
	cutscene_outro:set_music("Khorne_Realm_Conquered", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	bm:change_victory_countdown_limit(0)
	bm:notify_survival_completion()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function teleport_def_01_units()
	bm:out("\tbattle_start_teleport_units() called");

	ga_ai_def_01.sunits:item(1).uc:teleport_to_location(v(30.32, -428.46), 180.0, 20.30);
	ga_ai_def_01.sunits:item(2).uc:teleport_to_location(v(8.02, -428.46), 180.0, 20.30);
	ga_ai_def_01.sunits:item(3).uc:teleport_to_location(v(-14.28, -428.46), 180.0, 20.30);
	ga_ai_def_01.sunits:item(4).uc:teleport_to_location(v(-36.58, -428.46), 180.0, 20.30);
	ga_ai_def_01.sunits:item(5).uc:teleport_to_location(v(-58.88, -428.46), 180.0, 20.30);
	ga_ai_def_01.sunits:item(6).uc:teleport_to_location(v(52.62, -428.46), 180.0, 20.30);
end;

teleport_def_01_units();

function teleport_def_02_units()
	bm:out("\tteleport_def_02_units() called");
	
	ga_ai_def_02.sunits:item(1).uc:teleport_to_location(v(31.40, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(2).uc:teleport_to_location(v(11.20, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(3).uc:teleport_to_location(v(-9.00, 18.22), 180.0, 18.2); 
	ga_ai_def_02.sunits:item(4).uc:teleport_to_location(v(-29.19, 18.22), 180.0, 18.2); 

	ga_ai_def_02.sunits:item(5).uc:teleport_to_location(v(20.91, 42.86), 180.0, 39.0);
	ga_ai_def_02.sunits:item(6).uc:teleport_to_location(v(-20.09, 42.86), 180.0, 39.0);
end;

gb.sm:add_listener("battle_start", function() teleport_def_02_units() end)

function teleport_def_03_units()
	bm:out("\tteleport_def_03_units() called");
	
	ga_ai_def_03.sunits:item(1).uc:teleport_to_location(v(31.37, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(2).uc:teleport_to_location(v(11.17, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(3).uc:teleport_to_location(v(-9.03, 305.91), 180.0, 18.20);
	ga_ai_def_03.sunits:item(4).uc:teleport_to_location(v(-29.23, 305.91), 180.0, 18.20);

	ga_ai_def_03.sunits:item(5).uc:teleport_to_location(v(21.92, 330.04), 180.0, 39.00); 
	ga_ai_def_03.sunits:item(6).uc:teleport_to_location(v(-19.08, 330.04), 180.0, 39.00); 

	ga_ai_def_03.sunits:item(7).uc:teleport_to_location(v(0.0, 352.99), 180.0, 4.14); 
end;

gb.sm:add_listener("battle_start", function() teleport_def_03_units() end)

function teleport_boss()
	bm:out("\tteleport_boss() called");
	
	ga_ai_att_04.sunits:item(1).uc:teleport_to_location(v(0.0, 485.45), 180.0, 4.5);

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

ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_player_01.sunits:release_control();
ga_ai_def_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);

show_attack_closest_unit_debug_output = true;

-------DEFENDER 1-------
ga_ai_def_01:defend_on_message("battle_start" , 0, -420, 50);
ga_ai_def_01:message_on_casualties("def_01_attack", 0.05);
ga_ai_def_01:attack_on_message("def_01_attack");

-------DEFENDER 2-------
gb:add_listener(
	"ready_ai_wave_02",
	function()
		bm:callback(
			function()
					ga_ai_def_02.sunits:set_enabled(true);
					ga_ai_def_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);		
			end,
			100
		);
	end
);

ga_ai_def_02:defend_on_message("ready_ai_wave_02" , 0, 40, 50);
ga_ai_def_02:message_on_casualties("def_02_attack", 0.05);
ga_ai_def_02:attack_on_message("def_02_attack");

-------DEFENDER 3-------
gb:add_listener(
	"ready_ai_wave_03",
	function()
		bm:callback(
			function()
					ga_ai_def_03.sunits:set_enabled(true);
					ga_ai_def_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			end,
			100
		);
	end
);

ga_ai_def_03:defend_on_message("ready_ai_wave_03" , 0, 335, 50);
ga_ai_def_03:message_on_casualties("def_03_attack", 0.05);
ga_ai_def_03:attack_on_message("def_03_attack");

-------Gates-------
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_02", "map_barrier_1_2", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_2_3", false);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 1----------------------------------------------
-------------------------------------------------------------------------------------------------

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("ai_wave_01", 45000, "cp_1_owned");
gb:message_on_time_offset("ai_wave_01_offset", 2500, "ai_wave_01");
gb:message_on_all_messages_received("ready_ai_wave_02", "wave_01_1_defeated", "wave_01_2_defeated")

-----ARMY1-----
ga_ai_att_01_1:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_1:message_on_any_deployed("1_1_in");
ga_ai_att_01_1:rush_on_message("1_1_in");
ga_ai_att_01_1:message_on_rout_proportion("wave_01_1_defeated", 0.99);
ga_ai_att_01_1:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_1:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
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
	"ai_wave_01_offset", 		-- message
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
	"1_2_in",
	function()
		ga_ai_att_01_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_01_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 2----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("ai_wave_02", 45000, "cp_2_owned");
gb:message_on_time_offset("ai_wave_02_offset", 3000, "ai_wave_02");
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
	8000, 						-- min period
	8000, 						-- max period
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
	8000, 						-- min period
	8000, 						-- max period
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
-------------------------------------------BOSS WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("prepare_reveal", 45000, "cp_3_owned");
gb:message_on_time_offset("boss_time", 100, "reveal_cutscene_end");
gb:message_on_time_offset("boss_time_offset_1", 4000, "boss_time");
gb:message_on_time_offset("boss_time_offset_2", 4000, "boss_time_offset_1");
gb:message_on_time_offset("prepare_outro", 15000, "prepare_for_outro");
gb:message_on_all_messages_received("prepare_for_outro", "wave_03_1_defeated", "wave_03_2_defeated", "boss_defeated", "boss_helpers_defeated")

-----ARMY1-----
ga_ai_att_03_1:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_03_1:message_on_any_deployed("3_1_in");
ga_ai_att_03_1:rush_on_message("3_1_in");
ga_ai_att_03_1:message_on_rout_proportion("wave_03_1_defeated", 0.99);
ga_ai_att_03_1:rout_over_time_on_message("prepare_for_outro", 3000);
ga_ai_att_03_1:deploy_at_random_intervals_on_message(
	"boss_time_offset_1", 				-- message
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
	"3_1_in",
	function()
		ga_ai_att_03_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_03_2:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_03_2:message_on_any_deployed("3_2_in");
ga_ai_att_03_2:rush_on_message("3_2_in");
ga_ai_att_03_2:message_on_rout_proportion("wave_03_2_defeated", 0.99);
ga_ai_att_03_2:rout_over_time_on_message("prepare_for_outro", 3000);
ga_ai_att_03_2:deploy_at_random_intervals_on_message(
	"boss_time_offset_2", 		-- message
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
	"3_2_in",
	function()
		ga_ai_att_03_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

--ga_ai_att_04:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_04:message_on_any_deployed("4_in");
ga_ai_att_04:rush_on_message("4_in");
ga_ai_att_04:message_on_rout_proportion("boss_defeated", 1.0, permit_rampaging);
ga_ai_att_04:rout_over_time_on_message("prepare_for_outro", 1000);

gb:add_listener(
	"boss_time",
	function()
		-- delay call by .1 second
		bm:callback(
			function()
				ga_ai_att_04.sunits:set_enabled(true);
				ga_ai_att_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);	
				bm:add_survival_battle_wave(2, ga_ai_att_04.sunits, true);
			end,
			100
		);
	end
);

ga_ai_att_05:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_05:message_on_any_deployed("5_in");
ga_ai_att_05:rush_on_message("5_in");
ga_ai_att_05:message_on_rout_proportion("boss_helpers_defeated", 0.99);
ga_ai_att_05:rout_over_time_on_message("prepare_for_outro", 1000);
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
	"prepare_for_outro",
	function()
		if ga_ai_att_05.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_05.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
-------------------------------------------FLOW WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_flow_01:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	30000, 						-- min period
	30000, 						-- max period
	"ready_ai_wave_02", 		-- cancel message
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
		ga_ai_flow_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_02:deploy_at_random_intervals_on_message(
	"ai_wave_02", 				-- message
	2, 							-- min units
	2, 							-- max units
	50000, 						-- min period
	50000, 						-- max period
	"ready_ai_wave_03", 		-- cancel message
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
		ga_ai_flow_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_03:deploy_at_random_intervals_on_message(
	"reveal_cutscene_end", 		-- message
	3, 							-- min units
	3, 							-- max units
	70000, 						-- min period
	70000, 						-- max period
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
		ga_ai_flow_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

ga_ai_flow_01:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_flow_02:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_flow_03:rout_over_time_on_message("prepare_for_outro", 1000);


gb:add_listener(
	"ready_ai_wave_02",
	function()
		if ga_ai_flow_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_01.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"ready_ai_wave_03",
	function()
		if ga_ai_flow_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"prepare_for_outro",
	function()
		if ga_ai_flow_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_flow_03.sunits:kill_proportion_over_time(1.0, 100, false);
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

-- gb:message_on_time_offset("wave_01_60", 45000, "cp_1_owned");
-- gb:queue_help_on_message("wave_01_60", "wh3_survival_waves_timer_60", 2000, 500);

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
			v(-120.77, 222.73, 362.50), 
			v(104.25, 105.84, 463.66), 
			1, 
			true
		);
	end
);
gb:complete_objective_on_message("cp_3_owned", "wh3_survival_point_kho_torment", 1000);
gb:remove_objective_on_message("3_1_deployed", "wh3_survival_point_kho_torment", 1000);

gb:set_objective_with_leader_on_message("reveal_cutscene_end", "wh3_survival_boss_khorne", 1000);
gb:complete_objective_on_message("prepare_for_outro", "wh3_survival_boss_khorne", 1000);

gb:message_on_time_offset("obj_01", 3000, "battle_start");
gb:message_on_time_offset("obj_02", 3000, "ready_ai_wave_02");
gb:message_on_time_offset("obj_03", 3000, "ready_ai_wave_03");

gb:set_objective_with_leader_on_message("1_1_deployed", "wh3_survival_wave_khorne", 1000);
gb:complete_objective_on_message("ready_ai_wave_02", "wh3_survival_wave_khorne", 1000);
gb:remove_objective_on_message("obj_02", "wh3_survival_wave_khorne", 1000);

gb:set_objective_with_leader_on_message("2_1_deployed", "wh3_survival_wave_khorne", 1000);
gb:complete_objective_on_message("ready_ai_wave_03", "wh3_survival_wave_khorne", 1000);
gb:remove_objective_on_message("obj_03", "wh3_survival_wave_khorne", 1000);

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

---------------------------------------------
-----------------OUTRO TEXTS-----------------
---------------------------------------------

ga_player_01:message_on_victory("player_wins");
ga_player_01:message_on_defeat("player_loses");

loading_screen_key_defeat = "wh3_main_survival_brass_citadel_defeat";

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

local num_realms_completed = tonumber(core:svr_load_string("player_num_realms_completed"))
 
if num_realms_completed == 0 then
	loading_screen_win = "wh3_main_survival_brass_citadel_first_win";
elseif num_realms_completed == 1 then
	loading_screen_win = "wh3_main_survival_brass_citadel_second_win";
elseif num_realms_completed == 2 then
	loading_screen_win = "wh3_main_survival_brass_citadel_third_win";
elseif num_realms_completed == 3 then
	loading_screen_win = "wh3_main_survival_brass_citadel_fourth_win";
end

sm:add_listener(
	"player_wins",
	function()
		core:add_listener(
			"set_loading_screen",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_dismiss_results";
			end,
			function()
				common.set_custom_loading_screen_key(loading_screen_win);
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
		elseif ga_ai_att_03_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_03_1.sunits:rout_over_time(1000);
			ga_ai_att_03_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_03_2.sunits:rout_over_time(1000);
			ga_ai_att_03_2.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_04.sunits:rout_over_time(1000);
			ga_ai_att_04.sunits:cancel_deploy_at_random_intervals();
		end;
	end,
	true
);