load_script_libraries();

bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

bm:notify_survival_started();
bm:force_cant_chase_down_routers();
bm:notify_survival_total_waves(3);

local sm = get_messager();
survival_mode = {};

bm:print_toggle_slots();
bm:print_capture_locations();

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

local speed_01 = 12500;
local speed_02 = 12500;
local speed_03 = 15000;
local speed_04 = 5000;

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_start = gb:get_army(gb:get_non_player_alliance_num(), "start");

ga_ai_vanguard_miners = gb:get_army(gb:get_non_player_alliance_num(), "van_miner");
ga_ai_vanguard_warriors = gb:get_army(gb:get_non_player_alliance_num(), "van_warrior");
ga_ai_vanguard_gyros = gb:get_army(gb:get_non_player_alliance_num(), "van_gyro");
ga_ai_vanguard_campaign = gb:get_army(gb:get_non_player_alliance_num(), "grey_dwf");

ga_ai_daemon_kho = gb:get_army(gb:get_non_player_alliance_num(), "dae_kho");
ga_ai_daemon_nur = gb:get_army(gb:get_non_player_alliance_num(), "dae_nur");
ga_ai_daemon_sla = gb:get_army(gb:get_non_player_alliance_num(), "dae_sla");
ga_ai_daemon_tze = gb:get_army(gb:get_non_player_alliance_num(), "dae_tze");
ga_ai_daemon_boss = gb:get_army(gb:get_non_player_alliance_num(), "dae_boss");

ga_ai_thorgrim_boss = gb:get_army(gb:get_non_player_alliance_num(), "dwf_boss_01");
ga_ai_thorgrim_units = gb:get_army(gb:get_non_player_alliance_num(), "dwf_01");
ga_ai_thorek_boss = gb:get_army(gb:get_non_player_alliance_num(), "dwf_boss_02");
ga_ai_thorek_units = gb:get_army(gb:get_non_player_alliance_num(), "dwf_02");
ga_ai_belegar_boss = gb:get_army(gb:get_non_player_alliance_num(), "dwf_boss_03");
ga_ai_belegar_units = gb:get_army(gb:get_non_player_alliance_num(), "dwf_03");
ga_ai_ogre_boss = gb:get_army(gb:get_non_player_alliance_num(), "ogr_boss");
ga_ai_ogres_units = gb:get_army(gb:get_non_player_alliance_num(), "ogr_01");
ga_ai_dwf_boss_backup = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_backup");

ga_ai_vanguard_miners:get_army():suppress_reinforcement_adc(1);
ga_ai_vanguard_warriors:get_army():suppress_reinforcement_adc(1);
ga_ai_vanguard_gyros:get_army():suppress_reinforcement_adc(1);

ga_ai_daemon_kho:get_army():suppress_reinforcement_adc(1);
ga_ai_daemon_nur:get_army():suppress_reinforcement_adc(1);
ga_ai_daemon_sla:get_army():suppress_reinforcement_adc(1);
ga_ai_daemon_tze:get_army():suppress_reinforcement_adc(1);

ga_ai_thorgrim_units:get_army():suppress_reinforcement_adc(1);
ga_ai_thorek_units:get_army():suppress_reinforcement_adc(1);
ga_ai_belegar_units:get_army():suppress_reinforcement_adc(1);
ga_ai_dwf_boss_backup:get_army():suppress_reinforcement_adc(1);

---------------------
-----MULTIPLAYER-----
---------------------

local armies_player = bm:alliances():item(1):armies()

if armies_player:count() == 2 then
	ga_player_02 = gb:get_army(gb:get_player_alliance_num(), 1);
	bm:out("2 Player armies loaded in to battle")
elseif armies_player:count() == 3 then
	ga_player_02 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_player_03 = gb:get_army(gb:get_player_alliance_num(), 1);
	bm:out("3 Player armies loaded in to battle")
elseif armies_player:count() == 4 then
	ga_player_02 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_player_03 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_player_04 = gb:get_army(gb:get_player_alliance_num(), 1);
	bm:out("4 Player armies loaded in to battle")
end

bm:out("Number of players in the alliance: " .. armies_player:count())

---------------------
-----Spawn Zones-----
---------------------

all_mines = bm:get_spawn_zone_collection_by_name("left_mine", "right_mine", "base_mine");
side_ramps = bm:get_spawn_zone_collection_by_name("left_ramp", "right_ramp");
left_mines = bm:get_spawn_zone_collection_by_name("left_mine");
left_ramps = bm:get_spawn_zone_collection_by_name("left_ramp");
left_side = bm:get_spawn_zone_collection_by_name("left_mine", "left_ramp");
right_mines = bm:get_spawn_zone_collection_by_name("right_mine");
right_ramps = bm:get_spawn_zone_collection_by_name("right_ramp");
right_side = bm:get_spawn_zone_collection_by_name("right_mine","right_ramp");
base_mines = bm:get_spawn_zone_collection_by_name("base_mine");
base_ramps = bm:get_spawn_zone_collection_by_name("base_ramp");

left_ramp_top = bm:get_spawn_zone_collection_by_name("left_ramp_top");
right_ramp_top = bm:get_spawn_zone_collection_by_name("right_ramp_top");
both_ramps_top = bm:get_spawn_zone_collection_by_name("left_ramp_top", "right_ramp_top");

kho_portals = bm:get_spawn_zone_collection_by_name("dae_kho");
nur_portals = bm:get_spawn_zone_collection_by_name("dae_nur");
sla_portals = bm:get_spawn_zone_collection_by_name("dae_sla");
tze_portals = bm:get_spawn_zone_collection_by_name("dae_tze");
boss_portal = bm:get_spawn_zone_collection_by_name("nur_boss");

------------------------
--Spawn Zone Selection--
------------------------

------DWARF VANGUARD------
ga_ai_vanguard_miners:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", all_mines, false);
ga_ai_vanguard_miners:message_on_number_deployed("van_01_deployed", true, 1);
ga_ai_vanguard_miners:assign_to_spawn_zone_from_collection_on_message("van_01_deployed", all_mines, false);

ga_ai_vanguard_warriors:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", base_mines, false);
ga_ai_vanguard_warriors:message_on_number_deployed("van_02_deployed", true, 1);
ga_ai_vanguard_warriors:assign_to_spawn_zone_from_collection_on_message("van_02_deployed", base_mines, false);

ga_ai_vanguard_gyros:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", side_ramps, false);
ga_ai_vanguard_gyros:message_on_number_deployed("van_03_deployed", true, 1);
ga_ai_vanguard_gyros:assign_to_spawn_zone_from_collection_on_message("van_03_deployed", side_ramps, false);

------DAEMON HORDE------
ga_ai_daemon_kho:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", kho_portals, false);
ga_ai_daemon_kho:message_on_number_deployed("dae_kho_deployed", true, 1);
ga_ai_daemon_kho:assign_to_spawn_zone_from_collection_on_message("dae_kho_deployed", kho_portals, false);

ga_ai_daemon_nur:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", nur_portals, false);
ga_ai_daemon_nur:message_on_number_deployed("dae_nur_deployed", true, 1);
ga_ai_daemon_nur:assign_to_spawn_zone_from_collection_on_message("dae_nur_deployed", nur_portals, false);

ga_ai_daemon_sla:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sla_portals, false);
ga_ai_daemon_sla:message_on_number_deployed("dae_sla_deployed", true, 1);
ga_ai_daemon_sla:assign_to_spawn_zone_from_collection_on_message("dae_sla_deployed", sla_portals, false);

ga_ai_daemon_tze:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", tze_portals, false);
ga_ai_daemon_tze:message_on_number_deployed("dae_tze_deployed", true, 1);
ga_ai_daemon_tze:assign_to_spawn_zone_from_collection_on_message("dae_tze_deployed", tze_portals, false);

------DWARF ALLIANCE------
ga_ai_thorgrim_boss:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", base_ramps, false);
ga_ai_thorek_boss:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", base_ramps, false);
ga_ai_belegar_boss:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", base_ramps, false);

ga_ai_thorgrim_units:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", base_ramps, false);
ga_ai_thorgrim_units:message_on_number_deployed("thorgrim_deployed", true, 1);
ga_ai_thorgrim_units:assign_to_spawn_zone_from_collection_on_message("thorgrim_deployed", base_ramps, false);

ga_ai_thorek_units:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", left_side, false);
ga_ai_thorek_units:message_on_number_deployed("thorek_deployed", true, 1);
ga_ai_thorek_units:assign_to_spawn_zone_from_collection_on_message("thorek_deployed", left_side, false);

ga_ai_belegar_units:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", right_side, false);
ga_ai_belegar_units:message_on_number_deployed("belegar_deployed", true, 1);
ga_ai_belegar_units:assign_to_spawn_zone_from_collection_on_message("belegar_deployed", right_side, false);

ga_ai_dwf_boss_backup:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", base_ramps, false);

-------------------------
---Reinforcement Setup---
-------------------------

local reinforcements = bm:reinforcements();

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_drill");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp_pillars");

capture_point_02:change_holding_army(ga_ai_start.army);
capture_point_02:set_locked(true);
capture_point_02:set_enabled(false);

reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 999999);
gb:message_on_capture_location_capture_completed("cp_1_owned", "battle_start", "cp_drill", nil, ga_ai_start, ga_player_01);

gb:message_on_capture_location_capture_completed("cp_2_owned", "battle_start", "cp_pillars", nil, ga_ai_start, ga_player_01);

gb:add_listener(
	"ai_wave_01",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

--------------------------
-----COMPOSITE SCENES-----
--------------------------

drill_idle = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01_idle.csc";
drill_spin_up = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01_spin_up.csc";
drill_spin_idle = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01_spin_idle.csc";
drill_move_down = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01_movedown.csc";
drill_down_idle = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01_down_idle.csc";
drop_hammers_idle = "composite_scene/battle_props/chd/chd_drop_hammer_01_idle.csc";
drop_hammers = "composite_scene/battle_props/chd/chd_drop_hammer_01.csc";
trains_left = "composite_scene/battle_props/chd/minecarts/chd_traincar_finalbattle_left_01.csc";
trains_right = "composite_scene/battle_props/chd/minecarts/chd_minecart_finalbattle_right_01.csc";
trains_straight = "composite_scene/battle_props/chd/minecarts/chd_minecart_finalbattle_straight_01.csc";
trains_slope = "composite_scene/battle_props/chd/minecarts/chd_minetrack_slopeup_01a.csc";
magic_explosion = "composite_scene/battle_props/chd/drill/wh3_dlc23_hellshard_drill_hashut_magic_explosion.csc";
magic_looping = "composite_scene/battle_props/chd/drill/wh3_dlc23_hellshard_drill_hashut_magic_looping.csc";
drill_full = "composite_scene/battle_props/chd/drill/chd_hellshard_drill_01.csc"

bm:start_terrain_composite_scene(drill_idle, nil, 0);
bm:start_terrain_composite_scene(drop_hammers_idle, nil, 0);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Intro");
wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_01");
wh3_intro_sfx_02 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_02");
wh3_intro_sfx_03 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_03");
wh3_intro_sfx_04 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_04");
wh3_intro_sfx_05 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_05");
wh3_intro_sfx_06 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_06");
wh3_intro_sfx_07 = new_sfx("Play_wh3_dlc23_chd_narrator_drillignition_07");
--wh3_intro_sfx_lord = new_sfx("");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_mid_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Reveal");
wh3_mid_sfx_01 = new_sfx("Play_wh3_dlc23_chd_narrator_daemonincursion_01");
wh3_mid_sfx_02 = new_sfx("Play_wh3_dlc23_chd_narrator_daemonincursion_02");
wh3_mid_sfx_03 = new_sfx("Play_wh3_dlc23_chd_narrator_daemonincursion_03");
wh3_mid_sfx_04 = new_sfx("Play_wh3_dlc23_chd_narrator_daemonincursion_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------
wh3_final_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Final");
wh3_final_sfx_01 = new_sfx("Play_wh3_dlc23_chd_narrator_DwarfAlliance_01");
wh3_final_sfx_02 = new_sfx("Play_wh3_dlc23_chd_narrator_DwarfAlliance_02");
wh3_final_sfx_03 = new_sfx("Play_wh3_dlc23_chd_thorgrim_final_battle_01");
wh3_final_sfx_04 = new_sfx("Play_wh3_dlc23_chd_thorgrim_final_battle_02");
wh3_final_sfx_05 = new_sfx("Play_wh3_dlc23_chd_thorgrim_final_battle_03");

-------------------------------------------------------------------------------------------------
----------------------------------- INTRO CUTSCENE VARIATION ------------------------------------
-------------------------------------------------------------------------------------------------

local lord_subtitle = ""

intro_cinematic_file = "";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_two_m01.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);
outro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_three_m01.CindySceneManager";
bm:cindy_preload(outro_cinematic_file);

if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_astragoth_ironhand") then
	bm:out("Astragoth found, loading Astragoth intro scene")
	lord_subtitle = "wh3_dlc23_chd_intro_final_battle_astragoth"
	wh3_intro_sfx_lord = new_sfx("Play_wh3_dlc23_chd_astragoth_final_battle_01");
	intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_one_m01.CindySceneManager";
	wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Intro");
elseif gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_drazhoath_the_ashen") or gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_drazhoath_the_ashen_bale_taurus_cinderbreath") then
	bm:out("Drazhoath found, loading Drazhoath intro scene")
	lord_subtitle = "wh3_dlc23_chd_intro_final_battle_drazhoath"
	wh3_intro_sfx_lord = new_sfx("Play_wh3_dlc23_chd_drazhoath_final_battle_01");
	intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_one_drazhoath_m01.CindySceneManager";
	wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Intro");
elseif gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_zhatan_the_black") or gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_zhatan_the_black_great_taurus") or gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh3_dlc23_chd_cha_zhatan_the_black_lammasu") then
	bm:out("Zhatan found, loading Zhatan intro scene")
	lord_subtitle = "wh3_dlc23_chd_intro_final_battle_zhatan"
	wh3_intro_sfx_lord = new_sfx("Play_wh3_dlc23_chd_zhatan_final_battle_01");
	intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_one_zhatan_m01.CindySceneManager";
	wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Intro");
else
	bm:out("No lord found, defaulting to Astragoth")
	lord_subtitle = "wh3_dlc23_chd_intro_final_battle_astragoth"
	wh3_intro_sfx_lord = new_sfx("Play_wh3_dlc23_chd_astragoth_final_battle_01");
	intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\chd_drill_of_hashut_phase_one_m01.CindySceneManager";
	wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Final_Battle_Great_Drill_Of_Hashut_Sweetener_Intro");
end

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 1);

	teleport_starting_enemy_units();
	ga_ai_start:set_enabled(false);
	
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

	-- disable cp and drill comp scene
	cutscene_intro:action(
		function() 	
			capture_point_01:set_enabled(false);

			ga_player_01.sunits:set_invisible_to_all(true);

			if armies_player:count() == 2 then
				ga_player_02.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 3 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 4 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
				ga_player_04.sunits:set_invisible_to_all(true);
			end

			bm:stop_terrain_composite_scene(drill_idle);	
		end, 
		10
	);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_01", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_02", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_02);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_03", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_03);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_04", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_04);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_05", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_05);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_05", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_06", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_06);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_06", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_07", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_07);
				bm:show_subtitle("wh3_dlc23_chd_intro_final_battle_07", false, true);
			end
	);	
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_drillignition_08", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_lord);
				bm:show_subtitle(lord_subtitle, false, true);
			end
	);

	cutscene_intro:start();
end;

function end_intro_cutscene()
	ga_player_01.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:release_control();

	if armies_player:count() == 2 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
	elseif armies_player:count() == 3 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
	elseif armies_player:count() == 4 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
		ga_player_04.sunits:set_invisible_to_all(false);
		ga_player_04.sunits:release_control();
	end

	capture_point_01:set_enabled(true);
	gb.sm:trigger_message("intro_cutscene_end");
	bm:cindy_preload(reveal_cinematic_file);
	bm:hide_subtitles();
	bm:start_terrain_composite_scene(drill_spin_idle, nil, 0);	
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_mid_cutscene()
    --fade to black over 0.5 seconds
    bm:camera():fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_mid_cutscene() end, 1000)
end

function play_mid_cutscene()
    
	local cam_mid = bm:camera();
	cam_pos_mid = cam:position();
	cam_targ_mid = cam:target();

	cam_mid:fade(false, 2);
		
	local cutscene_mid = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_mid",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_mid_cutscene() end,
        -- path to cindy scene
        reveal_cinematic_file,
        -- optional fade in/fade out durations
        0,
        2
	);

	-- skip callback
	cutscene_mid:set_skippable(
		true, 
		function()
			local cam_mid = bm:camera();
			cam_mid:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam_mid:fade(false, 0.5) end, 1000);
		end
	);

	cutscene_mid:action(
		function() 	
			ga_player_01.sunits:set_invisible_to_all(true);
			
			if armies_player:count() == 2 then
				ga_player_02.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 3 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 4 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
				ga_player_04.sunits:set_invisible_to_all(true);
			end
			
			bm:stop_terrain_composite_scene(drill_move_down);	
			bm:start_terrain_composite_scene(drill_down_idle, nil, 0);	
		end, 
		10
	);

	-- set up subtitles	
	local subtitles = cutscene_mid:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	cutscene_mid:action(function() cutscene_mid:play_sound(wh3_mid_sfx_00) end, 100);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_daemonincursion_01", 
			function()
				cutscene_mid:play_sound(wh3_mid_sfx_01);
				bm:show_subtitle("wh3_dlc23_chd_mid_final_battle_01", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_daemonincursion_02", 
			function()
				cutscene_mid:play_sound(wh3_mid_sfx_02);
				bm:show_subtitle("wh3_dlc23_chd_mid_final_battle_02", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_daemonincursion_03", 
			function()
				cutscene_mid:play_sound(wh3_mid_sfx_03);
				bm:show_subtitle("wh3_dlc23_chd_mid_final_battle_03", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_daemonincursion_04", 
			function()
				cutscene_mid:play_sound(wh3_mid_sfx_04);
				bm:show_subtitle("wh3_dlc23_chd_mid_final_battle_04", false, true);
			end
	);

	cutscene_mid:start();
end;

function end_mid_cutscene()
	ga_player_01.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:release_control();
	
	if armies_player:count() == 2 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
	elseif armies_player:count() == 3 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
	elseif armies_player:count() == 4 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
		ga_player_04.sunits:set_invisible_to_all(false);
		ga_player_04.sunits:release_control();
	end

	gb.sm:trigger_message("mid_cutscene_end")
	cam:move_to(cam_pos_mid, cam_targ_mid, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
	bm:start_terrain_composite_scene(magic_looping, nil, 0);
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- FINAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_final_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_final_cutscene() end, 1000)
end

function play_final_cutscene()

	local cam_final = bm:camera();
	cam_pos_final = cam:position();
	cam_targ_final = cam:target();

	cam_final:fade(false, 2);
		
	local cutscene_final = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_final",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_final_cutscene() end,
        -- path to cindy scene
        outro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        2
	);

	-- skip callback
	cutscene_final:set_skippable(
		true, 
		function()
			local cam_final = bm:camera();
			cam_final:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam_final:fade(false, 0.5) end, 1000);
		end
	);

	cutscene_final:action(
		function() 	
			ga_player_01.sunits:set_invisible_to_all(true);

			if armies_player:count() == 2 then
				ga_player_02.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 3 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
			elseif armies_player:count() == 4 then
				ga_player_02.sunits:set_invisible_to_all(true);
				ga_player_03.sunits:set_invisible_to_all(true);
				ga_player_04.sunits:set_invisible_to_all(true);
			end

			bm:stop_terrain_composite_scene(drop_hammers_idle);	
		end, 
		10
	);

	-- set up subtitles	
	local subtitles = cutscene_final:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	cutscene_final:action(function() cutscene_final:play_sound(wh3_final_sfx_00) end, 100);
		
	cutscene_final:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_DwarfAlliance_01", 
			function()
				cutscene_final:play_sound(wh3_final_sfx_01);
				bm:show_subtitle("wh3_dlc23_chd_outro_final_battle_01", false, true);
			end
	);

	cutscene_final:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_narrator_DwarfAlliance_02", 
			function()
				cutscene_final:play_sound(wh3_final_sfx_02);
				bm:show_subtitle("wh3_dlc23_chd_outro_final_battle_02", false, true);
			end
	);

	-- There! There they are. The traitors… the grudge-mongers… 
	-- the vile wretched Dawi-scum that have fled the love of our Ancestors!
	cutscene_final:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_thorgrim_final_battle_01", 
			function()
				cutscene_final:play_sound(wh3_final_sfx_03);
				bm:show_subtitle("wh3_dlc23_chd_thorgrim_final_battle_01", false, true);
			end
	);

	-- We stop this abomination that burrows into the rock! A machine powered by remnants of our gods. 
	-- Such desecration must be answered in kind. 
	-- I will tear out every page of the Dammaz Kron to address this most wanton of grudges!
	cutscene_final:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_thorgrim_final_battle_02", 
			function()
				cutscene_final:play_sound(wh3_final_sfx_04);
				bm:show_subtitle("wh3_dlc23_chd_thorgrim_final_battle_02", false, true);
			end
	);

	-- Loyal Dwarfs, the clans of the Karaz Ankor unite! 
	-- Ready your axes, cleave the heads of every Dawi-Zharr you come across. 
	-- Burn their beards! Dreng them! DRENG THEM ALL! 
	cutscene_final:add_cinematic_trigger_listener(
		"Play_wh3_dlc23_chd_thorgrim_final_battle_03", 
			function()
				cutscene_final:play_sound(wh3_final_sfx_05);
				bm:show_subtitle("wh3_dlc23_chd_thorgrim_final_battle_03", false, true);
			end
	);

	cutscene_final:start();
end;

function end_final_cutscene()
	ga_player_01.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:release_control();

	if armies_player:count() == 2 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
	elseif armies_player:count() == 3 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
	elseif armies_player:count() == 4 then
		ga_player_02.sunits:set_invisible_to_all(false);
		ga_player_02.sunits:release_control();
		ga_player_03.sunits:set_invisible_to_all(false);
		ga_player_03.sunits:release_control();
		ga_player_04.sunits:set_invisible_to_all(false);
		ga_player_04.sunits:release_control();
	end

	bm:start_terrain_composite_scene(drop_hammers, nil, 0);
	bm:start_terrain_composite_scene(trains_left, nil, 0);
	bm:start_terrain_composite_scene(trains_right, nil, 0);
	bm:start_terrain_composite_scene(trains_straight, nil, 0);
	bm:start_terrain_composite_scene(trains_slope, nil, 0);
	gb.sm:trigger_message("final_cutscene_end")
	cam:move_to(cam_pos_final, cam_targ_final, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

--------------------------
-----CAMPAIGN GRIMNIR-----
--------------------------

local grimnir_objectives = tonumber(core:svr_load_string("relic_of_grimnir_bound"))
 
function spawn_grimnir_campaign_army()
	if grimnir_objectives == 1 then
		gb:message_on_time_offset("hint_02_objective_nurgle", 7500, "ai_wave_02");
		gb:message_on_time_offset("hint_02_advice_nurgle", 5000, "hint_02_objective_nurgle");

		gb:set_objective_with_leader_on_message("hint_02_objective_nurgle", "wh3_dlc23_chd_final_battle_02_objective_nurgle", 1000);
		gb:complete_objective_on_message("wave_02_5_defeated", "wh3_dlc23_chd_final_battle_02_objective_nurgle", 1000);
		gb:queue_help_on_message("hint_02_advice_nurgle", "wh3_dlc23_chd_final_battle_02_hint_02", 2000, 500);
		gb:remove_objective_on_message("wave_02_5_defeated", "wh3_dlc23_chd_final_battle_02_objective_nurgle", 6000);

		ga_ai_daemon_boss:get_army():suppress_reinforcement_adc(1);

		ga_ai_daemon_boss:assign_to_spawn_zone_from_collection_on_message("ai_wave_02_boss", boss_portal, false);
		ga_ai_daemon_boss:message_on_number_deployed("nur_boss_deployed", true, 1);
		ga_ai_daemon_boss:assign_to_spawn_zone_from_collection_on_message("nur_boss_deployed", boss_portal, false);
		
		ga_ai_daemon_boss:message_on_rout_proportion("wave_02_5_defeated", 0.9);
		ga_ai_daemon_boss:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);

		function spawn_boss_dae()
			ga_ai_daemon_boss:deploy_at_random_intervals_on_message(
				"ai_wave_02", 				-- message
				1, 							-- min units
				1, 							-- max units
				speed_02, 					-- min period
				speed_02, 					-- max period
				"stop_daemons", 			-- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end
		
		spawn_boss_dae()
		ga_ai_daemon_boss:message_on_any_deployed("dae_boss_in");
		ga_ai_daemon_boss:rush_on_message("dae_boss_in");

		gb:add_listener(
			"wave_02_5_defeated",
			function()
				if ga_ai_daemon_boss.sunits:are_any_active_on_battlefield() == true then
					ga_ai_daemon_boss.sunits:kill_proportion_over_time(1.0, 10000, false);
				end;
			end,
			true
		);

		gb:add_listener(
			"nur_boss_deployed",
			function()
				ga_ai_daemon_boss.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
				ga_ai_daemon_boss.sunits:set_always_visible_no_leave_battle(true);
			end
		);

		bm:out("Adding Grimnir Relic units");
	elseif grimnir_objectives == 0 then
		gb:message_on_time_offset("wave_02_5_defeated", 100);
		bm:out("Not adding Grimnir Relic units");
	else
		bm:out("This Grimnir Relic counter is broken...");
	end
end

--------------------------
-----CAMPAIGN GRUNGNI-----
--------------------------

local grungni_objectives = tonumber(core:svr_load_string("relic_of_grungni_bound"))

function spawn_grungni_campaign_army()
	if grungni_objectives == 1 then
		gb:message_on_time_offset("hint_01_objective_dwarfs", 7500, "ai_wave_01");
		gb:message_on_time_offset("hint_01_advice_dwarfs", 5000, "hint_01_objective_dwarfs");

		gb:set_objective_with_leader_on_message("hint_01_objective_dwarfs", "wh3_dlc23_chd_final_battle_01_objective_grey_dwf", 1000);
		gb:complete_objective_on_message("wave_01_5_defeated", "wh3_dlc23_chd_final_battle_01_objective_grey_dwf", 1000);
		gb:queue_help_on_message("hint_01_advice_dwarfs", "wh3_dlc23_chd_final_battle_01_hint_02", 2000, 500);
		gb:remove_objective_on_message("wave_01_5_defeated", "wh3_dlc23_chd_final_battle_01_objective_grey_dwf", 6000);

		ga_ai_vanguard_campaign:get_army():suppress_reinforcement_adc(1);
		
		ga_ai_vanguard_campaign:assign_to_spawn_zone_from_collection_on_message("ai_wave_01_boss", both_ramps_top, false);
		ga_ai_vanguard_campaign:message_on_number_deployed("grey_dwf_deployed", true, 1);
		ga_ai_vanguard_campaign:assign_to_spawn_zone_from_collection_on_message("grey_dwf_deployed", both_ramps_top, false);
		
		ga_ai_vanguard_campaign:message_on_rout_proportion("wave_01_5_defeated", 0.85);
		ga_ai_vanguard_campaign:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
		
		function spawn_grey_dwf()
			ga_ai_vanguard_campaign:deploy_at_random_intervals_on_message(
				"ai_wave_01", 				-- message
				1, 							-- min units
				1, 							-- max units
				speed_01, 					-- min period
				speed_01, 					-- max period
				"stop_vanguard", 			-- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end
		
		spawn_grey_dwf()
		ga_ai_vanguard_campaign:message_on_any_deployed("grey_dwf_boss_in");
		ga_ai_vanguard_campaign:rush_on_message("grey_dwf_boss_in");
		
		gb:add_listener(
			"wave_01_5_defeated",
			function()
				if ga_ai_vanguard_campaign.sunits:are_any_active_on_battlefield() == true then
					ga_ai_vanguard_campaign.sunits:rout_over_time(10000);
				end;
			end,
			true
		);
		
		gb:add_listener(
			"grey_dwf_deployed",
			function()
				ga_ai_vanguard_campaign.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
				ga_ai_vanguard_campaign.sunits:set_always_visible_no_leave_battle(true);
			end
		);

		bm:out("Adding Grungni Relic units");
	elseif grungni_objectives == 0 then
		gb:message_on_time_offset("wave_01_5_defeated", 100);
		bm:out("Not adding Grungni Relic units");
	else
		bm:out("This Grungni Relic counter is broken...");
	end
end

-------------------------
-----CAMPAIGN VALAYA-----
-------------------------

local valaya_objectives = tonumber(core:svr_load_string("relic_of_valaya_bound"))
 
function spawn_valaya_campaign_army()
	if valaya_objectives == 1 then
		gb:message_on_time_offset("hint_03_objective_ogres", 7500, "ai_wave_03");
		gb:message_on_time_offset("hint_03_advice_ogres", 5000, "hint_03_objective_ogres");

		gb:set_objective_with_leader_on_message("hint_03_objective_ogres", "wh3_dlc23_chd_final_battle_03_objective_slaughtermaster", 1000);
		gb:complete_objective_on_message("wave_03_4_defeated", "wh3_dlc23_chd_final_battle_03_objective_slaughtermaster", 1000);
		gb:queue_help_on_message("hint_03_advice_ogres", "wh3_dlc23_chd_final_battle_03_hint_02", 2000, 500);
		gb:remove_objective_on_message("wave_03_4_defeated", "wh3_dlc23_chd_final_battle_03_objective_slaughtermaster", 6000);

		ga_ai_ogre_boss:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", both_ramps_top, false);

		ga_ai_ogre_boss:message_on_rout_proportion("wave_03_4_defeated", 0.99);
		ga_ai_ogre_boss:add_to_survival_battle_wave_on_message("ai_wave_03", 2, true);

		function spawn_ogre_boss()
			ga_ai_ogre_boss:deploy_at_random_intervals_on_message(
				"ai_wave_03", 				-- message
				1, 							-- min units
				1, 							-- max units
				3000, 						-- min period
				3000, 						-- max period
				"wave_03_4_defeated", 		-- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end
		
		spawn_ogre_boss()
		ga_ai_ogre_boss:message_on_any_deployed("ogres_in");
		ga_ai_ogre_boss:rush_on_message("ogres_in");
		
		ga_ai_ogres_units:get_army():suppress_reinforcement_adc(1);

		ga_ai_ogres_units:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", both_ramps_top, false);
		ga_ai_ogres_units:message_on_number_deployed("ogres_deployed", true, 1);
		ga_ai_ogres_units:assign_to_spawn_zone_from_collection_on_message("ogres_deployed", both_ramps_top, false);

		function spawn_ogres()
			ga_ai_ogres_units:deploy_at_random_intervals_on_message(
				"ai_wave_03", 				-- message
				1, 							-- min units
				1, 							-- max units
				speed_03, 					-- min period
				speed_03, 					-- max period
				"wave_03_4_defeated", 		-- cancel message
				nil,						-- spawn first wave immediately
				true,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end
		
		spawn_ogres()
		ga_ai_ogres_units:message_on_any_deployed("ogres_in");
		ga_ai_ogres_units:rush_on_message("ogres_in");

		gb:add_listener(
			"wave_03_4_defeated",
			function()
				if ga_ai_ogres_units.sunits:are_any_active_on_battlefield() == true then
					ga_ai_ogres_units.sunits:rout_over_time(10000);
				end;
			end,
			true
		);
		
		gb:add_listener(
			"ogres_deployed",
			function()
				ga_ai_ogres_units.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
				ga_ai_ogres_units.sunits:set_always_visible_no_leave_battle(true);
			end
		);

		bm:out("Adding Valaya Relic units");
	elseif valaya_objectives == 0 then
		gb:message_on_time_offset("wave_03_4_defeated", 100);
		bm:out("Not adding Valaya Relic units");
	else
		bm:out("This Valaya Relic counter is broken...");
	end
end

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function teleport_starting_enemy_units()
	bm:out("\tbattle_start_teleport_units() called");

	ga_ai_start.sunits:item(1).uc:teleport_to_location(v(542.54, -295.07), 270, 1.5); -- Lord

	ga_ai_start.sunits:item(2).uc:teleport_to_location(v(524.96, -308.92), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(3).uc:teleport_to_location(v(526.31, -280.95), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(4).uc:teleport_to_location(v(530.99, -38.31), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(5).uc:teleport_to_location(v(529.94, -10.33), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(6).uc:teleport_to_location(v(521.66, 116.16), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(7).uc:teleport_to_location(v(520.86, 144.15), 270.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(8).uc:teleport_to_location(v(-539.37, -388.12), 90.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(9).uc:teleport_to_location(v(-552.90, -87.61), 90.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(10).uc:teleport_to_location(v(-521.16, 183.74), 90.0, 26.0); -- Dwarf Miner 0
	ga_ai_start.sunits:item(11).uc:teleport_to_location(v(-523.91, 155.88), 90.0, 26.0); -- Dwarf Miner 0

	ga_ai_start.sunits:item(12).uc:teleport_to_location(v(-525.41, -403.90), 90.0, 26.0); -- Dwarf Miner 1
	ga_ai_start.sunits:item(13).uc:teleport_to_location(v(-523.41, -375.98), 90.0, 26.0); -- Dwarf Miner 1
	ga_ai_start.sunits:item(14).uc:teleport_to_location(v(-536.36, -74.02), 90.0, 26.0); -- Dwarf Miner 1
	ga_ai_start.sunits:item(15).uc:teleport_to_location(v(-536.36, -102.02), 90.0, 26.0); -- Dwarf Miner 1
	ga_ai_start.sunits:item(16).uc:teleport_to_location(v(-507.04, 166.12), 90.0, 26.0); -- Dwarf Miner 1

	ga_ai_start.sunits:item(17).uc:teleport_to_location(v(550.71, -27.45), 270.0, 31.0); -- Gyrocopter 1
	ga_ai_start.sunits:item(18).uc:teleport_to_location(v(542.73, 130.02), 270.0, 31.0); -- Gyrocopter 1
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("timer_01", 180000);

gb:add_listener(
	"battle_started",
	function()
		bm:stop_terrain_composite_scene(drill_spin_idle);	
		bm:start_terrain_composite_scene(drill_move_down, nil, 0);
	end,
	true
);

gb:add_listener(
	"timer_01",
	function()
		bm:stop_terrain_composite_scene(drill_move_down);	
		bm:start_terrain_composite_scene(drill_down_idle, nil, 0);
	end,
	true
);

gb:add_listener(
	"intro_cutscene_end",
	function()
		ga_ai_start:set_enabled(true);
		ga_ai_start.sunits:release_control();
		ga_ai_start.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

ga_ai_start:release_on_message("battle_started");
ga_ai_start:message_on_any_deployed("start_in");
ga_ai_start:rush_on_message("start_in");

gb:message_on_time_offset("begin_drilling", 1000);

if bm:is_from_campaign() then
	spawn_grungni_campaign_army()
	spawn_grimnir_campaign_army()
	spawn_valaya_campaign_army()
else
	gb:message_on_time_offset("wave_03_4_defeated", 100);
	bm:out("Not adding Valaya Relic units to custom battle");

	gb:message_on_time_offset("wave_01_5_defeated", 100);
	bm:out("Not adding Grungni Relic units to custom battle");

	gb:message_on_time_offset("wave_02_5_defeated", 100);
	bm:out("Not adding Grimnir Relic units to custom battle");
end

----------------------
-----ENEMY WAVE 1-----
----------------------

gb:message_on_time_offset("fight", 1000, "battle_started");
gb:message_on_time_offset("ai_wave_01", 5000, "battle_started");

ga_ai_start:rush_on_message("fight");

ga_ai_start:message_on_rout_proportion("wave_01_1_defeated", 0.85);
ga_ai_vanguard_miners:message_on_rout_proportion("wave_01_2_defeated", 0.85);
ga_ai_vanguard_warriors:message_on_rout_proportion("wave_01_3_defeated", 0.85);
ga_ai_vanguard_gyros:message_on_rout_proportion("wave_01_4_defeated", 0.85);

ga_ai_start:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_vanguard_miners:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_vanguard_warriors:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_vanguard_gyros:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);

gb:add_listener(
	"wave_01_1_defeated",
	function()
		if ga_ai_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_start.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"battle_started",
	function()
		ga_ai_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_start.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_vanguard_01()
	ga_ai_vanguard_miners:deploy_at_random_intervals_on_message(
		"ai_wave_01", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"stop_vanguard", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_vanguard_01()
ga_ai_vanguard_miners:message_on_any_deployed("van_01_in");
ga_ai_vanguard_miners:rush_on_message("van_01_in");

gb:add_listener(
	"wave_01_2_defeated",
	function()
		if ga_ai_vanguard_miners.sunits:are_any_active_on_battlefield() == true then
			ga_ai_vanguard_miners.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"van_01_deployed",
	function()
		ga_ai_vanguard_miners.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_vanguard_miners.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_vanguard_02()
	ga_ai_vanguard_warriors:deploy_at_random_intervals_on_message(
		"ai_wave_01", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"stop_vanguard", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_vanguard_02()
ga_ai_vanguard_warriors:message_on_any_deployed("van_02_in");
ga_ai_vanguard_warriors:rush_on_message("van_02_in");

gb:add_listener(
	"wave_01_3_defeated",
	function()
		if ga_ai_vanguard_warriors.sunits:are_any_active_on_battlefield() == true then
			ga_ai_vanguard_warriors.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"van_02_deployed",
	function()
		ga_ai_vanguard_warriors.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_vanguard_warriors.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_vanguard_03()
	ga_ai_vanguard_gyros:deploy_at_random_intervals_on_message(
		"ai_wave_01", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"stop_vanguard", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_vanguard_03()
ga_ai_vanguard_gyros:message_on_any_deployed("van_03_in");
ga_ai_vanguard_gyros:rush_on_message("van_03_in");

gb:add_listener(
	"wave_01_4_defeated",
	function()
		if ga_ai_vanguard_gyros.sunits:are_any_active_on_battlefield() == true then
			ga_ai_vanguard_gyros.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"van_03_deployed",
	function()
		ga_ai_vanguard_gyros.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_vanguard_gyros.sunits:set_always_visible_no_leave_battle(true);
	end
);

------------------------------
------WAVE 1 COMEPLETION------
------------------------------

gb:message_on_all_messages_received("ready_ai_wave_02", "wave_01_1_defeated", "wave_01_2_defeated", "wave_01_3_defeated", "wave_01_4_defeated", "wave_01_5_defeated");
gb:message_on_all_messages_received("complete_01_base_objective", "wave_01_1_defeated", "wave_01_2_defeated", "wave_01_3_defeated", "wave_01_4_defeated");
gb:message_on_time_offset("play_mid", 40000, "ready_ai_wave_02");

gb.sm:add_listener("play_mid", function() prepare_for_mid_cutscene() end);

gb:message_on_time_offset("ai_wave_02", 5000, "mid_cutscene_end");

----------------------
-----ENEMY WAVE 2-----
----------------------

ga_ai_daemon_kho:message_on_rout_proportion("wave_02_1_defeated", 0.9);
ga_ai_daemon_nur:message_on_rout_proportion("wave_02_2_defeated", 0.9);
ga_ai_daemon_sla:message_on_rout_proportion("wave_02_3_defeated", 0.9);
ga_ai_daemon_tze:message_on_rout_proportion("wave_02_4_defeated", 0.9);

ga_ai_daemon_kho:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_daemon_nur:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_daemon_sla:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_daemon_tze:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);

function spawn_kho_dae()
	ga_ai_daemon_kho:deploy_at_random_intervals_on_message(
		"ai_wave_02", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"stop_daemons", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_kho_dae()
ga_ai_daemon_kho:message_on_any_deployed("dae_kho_in");
ga_ai_daemon_kho:rush_on_message("dae_kho_in");

gb:add_listener(
	"wave_02_1_defeated",
	function()
		if ga_ai_daemon_kho.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_kho.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

gb:add_listener(
	"dae_kho_deployed",
	function()
		ga_ai_daemon_kho.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_daemon_kho.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_nur_dae()
	ga_ai_daemon_nur:deploy_at_random_intervals_on_message(
		"ai_wave_02", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"stop_daemons", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_nur_dae()
ga_ai_daemon_nur:message_on_any_deployed("dae_nur_in");
ga_ai_daemon_nur:rush_on_message("dae_nur_in");

gb:add_listener(
	"wave_02_2_defeated",
	function()
		if ga_ai_daemon_nur.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_nur.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

gb:add_listener(
	"dae_nur_deployed",
	function()
		ga_ai_daemon_nur.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_daemon_nur.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_sla_dae()
	ga_ai_daemon_sla:deploy_at_random_intervals_on_message(
		"ai_wave_02", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"stop_daemons", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_sla_dae()
ga_ai_daemon_sla:message_on_any_deployed("dae_sla_in");
ga_ai_daemon_sla:rush_on_message("dae_sla_in");

gb:add_listener(
	"wave_02_3_defeated",
	function()
		if ga_ai_daemon_kho.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_kho.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

gb:add_listener(
	"dae_sla_deployed",
	function()
		ga_ai_daemon_kho.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_daemon_kho.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_tze_dae()
	ga_ai_daemon_tze:deploy_at_random_intervals_on_message(
		"ai_wave_02", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"stop_daemons", 			-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_tze_dae()
ga_ai_daemon_tze:message_on_any_deployed("dae_tze_in");
ga_ai_daemon_tze:rush_on_message("dae_tze_in");

gb:add_listener(
	"wave_02_4_defeated",
	function()
		if ga_ai_daemon_tze.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_tze.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

gb:add_listener(
	"dae_tze_deployed",
	function()
		ga_ai_daemon_tze.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_daemon_tze.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:add_listener(
	"ready_ai_wave_03",
	function()
		if ga_ai_daemon_kho.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_kho.sunits:kill_proportion_over_time(1.0, 1000, false);
		end;
		if ga_ai_daemon_nur.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_nur.sunits:kill_proportion_over_time(1.0, 1000, false);
		end;
		if ga_ai_daemon_sla.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_sla.sunits:kill_proportion_over_time(1.0, 1000, false);
		end;
		if ga_ai_daemon_tze.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_tze.sunits:kill_proportion_over_time(1.0, 1000, false);
		end;

		ga_player_01:play_sound_charge()
	end,
	true
);

--------------------------------
--------WAVE 2 COMPLETION-------
--------------------------------

gb:message_on_all_messages_received("ready_ai_wave_03", "wave_02_1_defeated", "wave_02_2_defeated", "wave_02_3_defeated", "wave_02_4_defeated", "wave_02_5_defeated");
gb:message_on_all_messages_received("complete_02_base_objective", "wave_02_1_defeated", "wave_02_2_defeated", "wave_02_3_defeated", "wave_02_4_defeated");
gb:message_on_time_offset("play_final", 40000, "ready_ai_wave_03");

gb.sm:add_listener("play_final", function() prepare_for_final_cutscene() end);

gb:message_on_time_offset("ai_wave_03", 10000, "final_cutscene_end");

----------------------
-----ENEMY WAVE 3-----
----------------------

ga_ai_thorgrim_boss:message_on_rout_proportion("wave_03_1_defeated", 0.99);
ga_ai_thorek_boss:message_on_rout_proportion("wave_03_2_defeated", 0.99);
ga_ai_belegar_boss:message_on_rout_proportion("wave_03_3_defeated", 0.99);

gb:message_on_all_messages_received("game_over", "wave_03_1_defeated", "wave_03_2_defeated", "wave_03_3_defeated", "wave_03_4_defeated");
gb:message_on_all_messages_received("end_game", "game_over");

ga_ai_thorgrim_boss:add_to_survival_battle_wave_on_message("ai_wave_03", 2, true);
ga_ai_thorek_boss:add_to_survival_battle_wave_on_message("ai_wave_03", 2, true);
ga_ai_belegar_boss:add_to_survival_battle_wave_on_message("ai_wave_03", 2, true);

gb:message_on_time_offset("boss_time", 20000, "ai_wave_03");

ga_ai_dwf_boss_backup:reinforce_on_message("ai_wave_03");
ga_ai_dwf_boss_backup:message_on_any_deployed("protect_the_boss");
ga_ai_dwf_boss_backup:rush_on_message("protect_the_boss");

gb:add_listener(
	"protect_the_boss",
	function()
		ga_ai_dwf_boss_backup.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:add_listener(
	"ai_wave_03",
	function()
		capture_point_02:set_enabled(true);
		capture_point_02:change_holding_army();
		capture_point_02:set_locked(false);
	end,
	true
);

function spawn_thorgrim_boss()
	ga_ai_thorgrim_boss:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_04, 					-- min period
		speed_04, 					-- max period
		"wave_03_1_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_thorgrim_boss()
ga_ai_thorgrim_boss:message_on_any_deployed("thorgrim_boss_in");
ga_ai_thorgrim_boss:rush_on_message("thorgrim_boss_in");

gb:add_listener(
	"thorgrim_boss_in",
	function()
		ga_ai_thorgrim_boss.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_thorgrim_units_wave()
	ga_ai_thorgrim_units:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_03, 					-- min period
		speed_03, 					-- max period
		"wave_03_1_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_thorgrim_units_wave()
ga_ai_thorgrim_units:message_on_any_deployed("thorgrim_in");
ga_ai_thorgrim_units:rush_on_message("thorgrim_in");

gb:add_listener(
	"wave_03_1_defeated",
	function()
		if ga_ai_thorgrim_units.sunits:are_any_active_on_battlefield() == true then
			ga_ai_thorgrim_units.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"thorgrim_deployed",
	function()
		ga_ai_thorgrim_units.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_thorgrim_units.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

function spawn_thorek_boss()
	ga_ai_thorek_boss:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_04, 					-- min period
		speed_04, 					-- max period
		"wave_03_2_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_thorek_boss()
ga_ai_thorek_boss:message_on_any_deployed("thorek_boss_in");
ga_ai_thorek_boss:rush_on_message("thorek_boss_in");

gb:add_listener(
	"thorek_boss_in",
	function()
		ga_ai_thorek_boss.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_thorek_units_wave()
	ga_ai_thorek_units:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_03, 					-- min period
		speed_03, 					-- max period
		"wave_03_2_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_thorek_units_wave()
ga_ai_thorek_units:message_on_any_deployed("thorek_in");
ga_ai_thorek_units:rush_on_message("thorek_in");

gb:add_listener(
	"wave_03_2_defeated",
	function()
		if ga_ai_thorek_units.sunits:are_any_active_on_battlefield() == true then
			ga_ai_thorek_units.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"thorek_deployed",
	function()
		ga_ai_thorek_units.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_thorek_units.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

function spawn_belegar_boss()
	ga_ai_belegar_boss:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_04, 					-- min period
		speed_04, 					-- max period
		"wave_03_3_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_belegar_boss()
ga_ai_belegar_boss:message_on_any_deployed("belegar_boss_in");
ga_ai_belegar_boss:rush_on_message("belegar_boss_in");

gb:add_listener(
	"belegar_boss_in",
	function()
		ga_ai_belegar_boss.sunits:set_always_visible_no_leave_battle(true);
	end
);

function spawn_belegar_units_wave()
	ga_ai_belegar_units:deploy_at_random_intervals_on_message(
		"boss_time", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_03, 					-- min period
		speed_03, 					-- max period
		"wave_03_3_defeated", 		-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_belegar_units_wave()
ga_ai_belegar_units:message_on_any_deployed("belegar_in");
ga_ai_belegar_units:rush_on_message("belegar_in");

gb:add_listener(
	"wave_03_3_defeated",
	function()
		if ga_ai_belegar_units.sunits:are_any_active_on_battlefield() == true then
			ga_ai_belegar_units.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:add_listener(
	"belegar_deployed",
	function()
		ga_ai_belegar_units.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_belegar_units.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

--------------------------------
-------HINTS & OBJECTIVES-------
--------------------------------

gb:message_on_capture_location_capture_completed("drill_captured", "ai_wave_01", "cp_drill", nil, ga_player_01, ga_ai_start);

gb:add_listener(
    "battle_started",
	function()
		bm:set_locatable_objective(
			"wh3_dlc23_chd_final_battle_main_objective_drill", 
			v(0, 100, 250), 
			v(0, 80, 325), 
			1, 
			true
		);
    end
);

gb:block_message_on_message("complete_02_base_objective", "drill_captured", true);

gb:add_listener(
    "drill_captured",
	function()
		bm:out("Player lost the Drill")
		bm:fail_objective("wh3_dlc23_chd_final_battle_main_objective_drill")

		bm:callback(
			function()
				ga_player_01:quit_battle();
				bm:end_battle();
				bm:change_victory_countdown_limit(0);
			end,
			5000
		)
    end
);

gb:complete_objective_on_message("complete_02_base_objective", "wh3_dlc23_chd_final_battle_main_objective_drill", 1000);
gb:remove_objective_on_message("play_final", "wh3_dlc23_chd_final_battle_main_objective_drill", 6000);

------Wave 1------
gb:message_on_time_offset("hint_01_advice", 2500, "ai_wave_01");
gb:message_on_time_offset("hint_01_objective", 2500, "hint_01_advice");

gb:set_objective_with_leader_on_message("hint_01_objective", "wh3_dlc23_chd_final_battle_01_objective", 1000);
gb:queue_help_on_message("hint_01_advice", "wh3_dlc23_chd_final_battle_01_hint_01", 2000, 500);
gb:complete_objective_on_message("complete_01_base_objective", "wh3_dlc23_chd_final_battle_01_objective", 1000);
gb:remove_objective_on_message("complete_01_base_objective", "wh3_dlc23_chd_final_battle_01_objective", 6000);

------Wave 2------
gb:message_on_time_offset("hint_02_advice", 2500, "ai_wave_02");
gb:message_on_time_offset("hint_02_objective", 2500, "hint_02_advice");

gb:set_objective_with_leader_on_message("hint_02_objective", "wh3_dlc23_chd_final_battle_02_objective", 1000);
gb:queue_help_on_message("hint_02_advice", "wh3_dlc23_chd_final_battle_02_hint_01", 2000, 500);
gb:complete_objective_on_message("complete_02_base_objective", "wh3_dlc23_chd_final_battle_02_objective", 1000);
gb:remove_objective_on_message("complete_02_base_objective", "wh3_dlc23_chd_final_battle_02_objective", 6000);

------Wave 3------
gb:message_on_time_offset("hint_03_advice", 2500, "ai_wave_03");
gb:message_on_time_offset("hint_03_objective_thorgrim", 2500, "hint_03_advice");
gb:message_on_time_offset("hint_03_objective_thorek", 5000, "hint_03_advice");
gb:message_on_time_offset("hint_03_objective_belegar", 7500, "hint_03_advice");

gb:set_objective_with_leader_on_message("hint_03_objective_thorgrim", "wh3_dlc23_chd_final_battle_03_objective_thorgrim", 1000);
gb:set_objective_with_leader_on_message("hint_03_objective_thorek", "wh3_dlc23_chd_final_battle_03_objective_thorek", 1000);
gb:set_objective_with_leader_on_message("hint_03_objective_belegar", "wh3_dlc23_chd_final_battle_03_objective_belegar", 1000);
gb:queue_help_on_message("hint_03_advice", "wh3_dlc23_chd_final_battle_03_hint_01", 2000, 500);
gb:complete_objective_on_message("wave_03_1_defeated", "wh3_dlc23_chd_final_battle_03_objective_thorgrim", 1000);
gb:complete_objective_on_message("wave_03_2_defeated", "wh3_dlc23_chd_final_battle_03_objective_thorek", 1000);
gb:complete_objective_on_message("wave_03_3_defeated", "wh3_dlc23_chd_final_battle_03_objective_belegar", 1000);
gb:remove_objective_on_message("wave_03_1_defeated", "wh3_dlc23_chd_final_battle_03_objective_thorgrim", 11000);
gb:remove_objective_on_message("wave_03_2_defeated", "wh3_dlc23_chd_final_battle_03_objective_thorek", 11000);
gb:remove_objective_on_message("wave_03_3_defeated", "wh3_dlc23_chd_final_battle_03_objective_belegar", 11000);

----------------------
-------END GAME-------
----------------------

gb:add_listener(
	"end_game",
	function()
		cam:fade(true, 10.0)
		-- delay call by 3 seconds
		bm:callback(
			function()
				bm:end_battle()
				bm:change_victory_countdown_limit(0)
				bm:notify_survival_completion()
			end,
			10000
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
		if ga_ai_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_start.sunits:rout_over_time(1000);
			ga_ai_start.sunits:cancel_deploy_at_random_intervals();
			ga_ai_vanguard_miners.sunits:rout_over_time(1000);
			ga_ai_vanguard_miners.sunits:cancel_deploy_at_random_intervals();
			ga_ai_vanguard_warriors.sunits:rout_over_time(1000);
			ga_ai_vanguard_warriors.sunits:cancel_deploy_at_random_intervals();
			ga_ai_vanguard_gyros.sunits:rout_over_time(1000);
			ga_ai_vanguard_gyros.sunits:cancel_deploy_at_random_intervals();
		elseif ga_ai_daemon_kho.sunits:are_any_active_on_battlefield() == true then
			ga_ai_daemon_kho.sunits:rout_over_time(1000);
			ga_ai_daemon_kho.sunits:cancel_deploy_at_random_intervals();
			ga_ai_daemon_nur.sunits:rout_over_time(1000);
			ga_ai_daemon_nur.sunits:cancel_deploy_at_random_intervals();
			ga_ai_daemon_sla.sunits:rout_over_time(1000);
			ga_ai_daemon_sla.sunits:cancel_deploy_at_random_intervals();
			ga_ai_daemon_tze.sunits:rout_over_time(1000);
			ga_ai_daemon_tze.sunits:cancel_deploy_at_random_intervals();
			ga_ai_daemon_boss.sunits:rout_over_time(1000);
			ga_ai_daemon_boss.sunits:cancel_deploy_at_random_intervals();
		elseif ga_ai_thorgrim_boss.sunits:are_any_active_on_battlefield() == true then
			ga_ai_thorgrim_boss.sunits:rout_over_time(1000);
			ga_ai_thorgrim_boss.sunits:cancel_deploy_at_random_intervals();
			ga_ai_thorek_boss.sunits:rout_over_time(1000);
			ga_ai_thorek_boss.sunits:cancel_deploy_at_random_intervals();
			ga_ai_belegar_boss.sunits:rout_over_time(1000);
			ga_ai_belegar_boss.sunits:cancel_deploy_at_random_intervals();
			ga_ai_ogre_boss.sunits:rout_over_time(1000);
			ga_ai_ogre_boss.sunits:cancel_deploy_at_random_intervals();
			ga_ai_thorgrim_units.sunits:rout_over_time(1000);
			ga_ai_thorgrim_units.sunits:cancel_deploy_at_random_intervals();
			ga_ai_thorek_units.sunits:rout_over_time(1000);
			ga_ai_thorek_units.sunits:cancel_deploy_at_random_intervals();
			ga_ai_belegar_units.sunits:rout_over_time(1000);
			ga_ai_belegar_units.sunits:cancel_deploy_at_random_intervals();
			ga_ai_ogres_units.sunits:rout_over_time(1000);
			ga_ai_ogres_units.sunits:cancel_deploy_at_random_intervals();
		end;
	end,
	true
);