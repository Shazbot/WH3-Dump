load_script_libraries();

bm = battle_manager:new(empire_battle:new());
local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                         -- screen starts black
                false,                         -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function

					ga_ai_enemy_main_boss.sunits:item(1).uc:teleport_to_location(v(0.0, -15.0), 180.0, 5.0);
					ga_ai_enemy_main_boss.sunits:item(2).uc:teleport_to_location(v(-10.0, -10.0), 180.0, 5.0);
					ga_ai_enemy_main_boss.sunits:item(3).uc:teleport_to_location(v(-5.0, -10.0), 180.0, 5.0);
					ga_ai_enemy_main_boss.sunits:item(4).uc:teleport_to_location(v(5.0, -10.0), 180.0, 5.0);
					ga_ai_enemy_main_boss.sunits:item(5).uc:teleport_to_location(v(10.0, -10.0), 180.0, 5.0);

					battle_start_teleport_units()

					ga_ai_enemy_main_boss:set_visible_to_all(true);
					ga_ai_enemy_main_kho_lord_mortal:set_visible_to_all(true);
					ga_ai_enemy_main_nur_lord_mortal:set_visible_to_all(true);
					ga_ai_enemy_main_sla_lord_mortal:set_visible_to_all(true);
					ga_ai_enemy_main_tze_lord_mortal:set_visible_to_all(true);
					ga_ai_enemy_kho_main:set_visible_to_all(true);
					ga_ai_enemy_nur_main:set_visible_to_all(true);
					ga_ai_enemy_sla_main:set_visible_to_all(true);
					ga_ai_enemy_tze_main:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

---------------------------------------
----------HARD SCRIPT VERSION----------
---------------------------------------
local sm = get_messager();
local reinforcements = bm:reinforcements();

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
-- Witless mortal! You march eagerly unto your end.
-- Drunk on shallow exploits, you forget who you face.
-- Know then now, and forever.
-- At my feet, the eight points intersect into the mark of boundless Chaos!
-- Through my fist, your guts will drain like the fleeting sands of hope!
-- At the tip of my sword, your world will meet its end!
-- For I am Archaon! And you are NOTHING!                       
gc:add_element("Play_wh3_dlc29_endtimes_narrative_chaos_archaon_007_1", "wh3_dlc29_endtimes_narrative_chaos_archaon_007_1", "gc_orbit_90_medium_commander_front_right_close_low_01", 5500, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_chaos_archaon_007_2", "army_pan_front_mid", 9250, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_chaos_archaon_007_3", "gc_episodes_chaos_invasion_cam", 19250, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_chaos_archaon_007_4", "gc_orbit_ccw_90_medium_enemy_commander_front_close_low_01", 9000, true, false, false);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------
--Player
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

--Chaos Champions - 30 with Archaon? Do we add Be'lakor
ga_ai_enemy_main_boss = gb:get_army(gb:get_non_player_alliance_num(), "main_boss");
-- You have 7 - 4 Lords - Arbaal, Skulltaker, Valkiya, Skarbrand - 3 Heroes - Karanak, Skarr, Scyla
ga_ai_enemy_main_kho_lord_mortal = gb:get_army(gb:get_non_player_alliance_num(), "kho_lord_mortal");
ga_ai_enemy_main_kho_lord_daemon = gb:get_army(gb:get_non_player_alliance_num(), "kho_lord_daemon");
-- You have 10 - 5 Lords - Epidemius, Tamurkhan, Festus, Ku'gath, Glottkin - 5 Heroes - Kayzk, Orghotts, Morbidex, Gutrot, Bloab
ga_ai_enemy_main_nur_lord_mortal = gb:get_army(gb:get_non_player_alliance_num(), "nur_lord_mortal");
ga_ai_enemy_main_nur_lord_daemon = gb:get_army(gb:get_non_player_alliance_num(), "nur_lord_daemon");
-- You have 6 - 5 Lords - Masque, Sigvald, Dechala, Azazel, N'Kari - 1 Heroes - Styrkaar
ga_ai_enemy_main_sla_lord_mortal = gb:get_army(gb:get_non_player_alliance_num(), "sla_lord_mortal");
ga_ai_enemy_main_sla_lord_daemon = gb:get_army(gb:get_non_player_alliance_num(), "sla_lord_daemon");
-- You have 6 - 4 Lords - Vilitch, Kairos, Sarthoreal, Changeling - 2 Heroes - Scribes, Aekold
ga_ai_enemy_main_tze_lord_mortal = gb:get_army(gb:get_non_player_alliance_num(), "tze_lord_mortal");
ga_ai_enemy_main_tze_lord_daemon = gb:get_army(gb:get_non_player_alliance_num(), "tze_lord_daemon");

--Chaos Mortals
ga_ai_enemy_kho_main = gb:get_army(gb:get_non_player_alliance_num(), "kho_main");
ga_ai_enemy_nur_main = gb:get_army(gb:get_non_player_alliance_num(), "nur_main");
ga_ai_enemy_sla_main = gb:get_army(gb:get_non_player_alliance_num(), "sla_main");
ga_ai_enemy_tze_main = gb:get_army(gb:get_non_player_alliance_num(), "tze_main");

--Chaos Daemons
ga_ai_enemy_kho_wave = gb:get_army(gb:get_non_player_alliance_num(), "kho_wave");
ga_ai_enemy_nur_wave = gb:get_army(gb:get_non_player_alliance_num(), "nur_wave");
ga_ai_enemy_sla_wave = gb:get_army(gb:get_non_player_alliance_num(), "sla_wave");
ga_ai_enemy_tze_wave = gb:get_army(gb:get_non_player_alliance_num(), "tze_wave");

-------------------------------------------------------------------------------------------------
------------------------------------------SCRIPT UNITS-------------------------------------------
-------------------------------------------------------------------------------------------------
--Archaon
archaon_character = ga_ai_enemy_main_boss.sunits:item(1)

--------------------------------------------------------------------------------------------------
-----------------------------------------COMPOSITE SCENES-----------------------------------------
--------------------------------------------------------------------------------------------------
altar_capture = "composite_scene/wh3_dlc20_enviro_altar_of_battle_lightning_event_final.csc";
altar_cracks_1_start = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle.csc";
altar_cracks_2_capture = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle_complete.csc";
altar_cracks_3_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle_cont.csc";
cp_1_1_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_2.csc";
cp_1_1_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_2_cont.csc";
cp_1_2_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_1.csc";
cp_1_2_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_1_cont.csc";
cp_2_1_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_3.csc";
cp_2_1_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_3_cont.csc";
cp_2_2_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_4.csc";
cp_2_2_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_4_cont.csc";

bm:start_terrain_composite_scene(altar_capture, nil, 0);
bm:stop_terrain_composite_scene(altar_capture);

bm:start_terrain_composite_scene(altar_cracks_1_start, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_1_start);
bm:start_terrain_composite_scene(altar_cracks_2_capture, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_2_capture);
bm:start_terrain_composite_scene(altar_cracks_3_loop, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_3_loop);

bm:start_terrain_composite_scene(cp_1_1_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_1_1_cracks);
bm:start_terrain_composite_scene(cp_1_1_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_1_1_cracks_loop);
bm:start_terrain_composite_scene(cp_1_2_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_1_2_cracks);
bm:start_terrain_composite_scene(cp_1_2_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_1_2_cracks_loop);
bm:start_terrain_composite_scene(cp_2_1_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_2_1_cracks);
bm:start_terrain_composite_scene(cp_2_1_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_2_1_cracks_loop);
bm:start_terrain_composite_scene(cp_2_2_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_2_2_cracks);
bm:start_terrain_composite_scene(cp_2_2_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_2_2_cracks_loop);

gb:start_terrain_composite_scene_on_message("kho_cp_captured", cp_1_1_cracks);
gb:stop_terrain_composite_scene_on_message("kho_cp_captured", cp_1_1_cracks, 10000);
gb:start_terrain_composite_scene_on_message("kho_cp_captured", cp_1_1_cracks_loop, 10000);

gb:start_terrain_composite_scene_on_message("nur_cp_captured", cp_1_2_cracks);
gb:stop_terrain_composite_scene_on_message("nur_cp_captured", cp_1_2_cracks, 10000);
gb:start_terrain_composite_scene_on_message("nur_cp_captured", cp_1_2_cracks_loop, 10000);

gb:start_terrain_composite_scene_on_message("sla_cp_captured", cp_2_1_cracks);
gb:stop_terrain_composite_scene_on_message("sla_cp_captured", cp_2_1_cracks, 10000);
gb:start_terrain_composite_scene_on_message("sla_cp_captured", cp_2_1_cracks_loop, 10000);

gb:start_terrain_composite_scene_on_message("tze_cp_captured", cp_2_2_cracks);
gb:stop_terrain_composite_scene_on_message("tze_cp_captured", cp_2_2_cracks, 10000);
gb:start_terrain_composite_scene_on_message("tze_cp_captured", cp_2_2_cracks_loop, 10000);

gb:start_terrain_composite_scene_on_message("chs_cp_capture_commenced", altar_cracks_1_start, 0);

gb:start_terrain_composite_scene_on_message("chs_cp_captured", altar_capture, 1000);
gb:stop_terrain_composite_scene_on_message("chs_cp_captured", altar_cracks_1_start);
gb:start_terrain_composite_scene_on_message("chs_cp_captured", altar_cracks_2_capture);
gb:stop_terrain_composite_scene_on_message("chs_cp_captured", altar_cracks_2_capture, 10000);
gb:start_terrain_composite_scene_on_message("chs_cp_captured", altar_cracks_3_loop, 10000);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
--Daemon Reinforcement Locations
dae_kho_wave_reinforce_location = bm:get_spawn_zone_collection_by_name("kho_reinforce");
dae_kho_lord_reinforce_location = bm:get_spawn_zone_collection_by_name("kho_lord_reinforce");

dae_nur_wave_reinforce_location = bm:get_spawn_zone_collection_by_name("nur_reinforce");
dae_nur_lord_reinforce_location = bm:get_spawn_zone_collection_by_name("nur_lord_reinforce");

dae_sla_wave_reinforce_location = bm:get_spawn_zone_collection_by_name("sla_reinforce");
dae_sla_lord_reinforce_location = bm:get_spawn_zone_collection_by_name("sla_lord_reinforce");

dae_tze_wave_reinforce_location = bm:get_spawn_zone_collection_by_name("tze_reinforce");
dae_tze_lord_reinforce_location = bm:get_spawn_zone_collection_by_name("tze_lord_reinforce");

--Enemy Waves
ga_ai_enemy_main_kho_lord_daemon:assign_to_spawn_zone_from_collection_on_message("start", dae_kho_lord_reinforce_location, false);
ga_ai_enemy_main_nur_lord_daemon:assign_to_spawn_zone_from_collection_on_message("start", dae_nur_lord_reinforce_location, false);
ga_ai_enemy_main_sla_lord_daemon:assign_to_spawn_zone_from_collection_on_message("start", dae_sla_lord_reinforce_location, false);
ga_ai_enemy_main_tze_lord_daemon:assign_to_spawn_zone_from_collection_on_message("start", dae_tze_lord_reinforce_location, false);

ga_ai_enemy_kho_wave:assign_to_spawn_zone_from_collection_on_message("start", dae_kho_wave_reinforce_location, false);
ga_ai_enemy_kho_wave:message_on_number_deployed("kho_wave_deployed", true, 1);
ga_ai_enemy_kho_wave:assign_to_spawn_zone_from_collection_on_message("kho_wave_deployed", dae_kho_wave_reinforce_location, false);

ga_ai_enemy_nur_wave:assign_to_spawn_zone_from_collection_on_message("start", dae_nur_wave_reinforce_location, false);
ga_ai_enemy_nur_wave:message_on_number_deployed("nur_wave_deployed", true, 1);
ga_ai_enemy_nur_wave:assign_to_spawn_zone_from_collection_on_message("nur_wave_deployed", dae_nur_wave_reinforce_location, false);

ga_ai_enemy_sla_wave:assign_to_spawn_zone_from_collection_on_message("start", dae_sla_wave_reinforce_location, false);
ga_ai_enemy_sla_wave:message_on_number_deployed("sla_wave_deployed", true, 1);
ga_ai_enemy_sla_wave:assign_to_spawn_zone_from_collection_on_message("sla_wave_deployed", dae_sla_wave_reinforce_location, false);

ga_ai_enemy_tze_wave:assign_to_spawn_zone_from_collection_on_message("start", dae_tze_wave_reinforce_location, false);
ga_ai_enemy_tze_wave:message_on_number_deployed("tze_wave_deployed", true, 1);
ga_ai_enemy_tze_wave:assign_to_spawn_zone_from_collection_on_message("tze_wave_deployed", dae_tze_wave_reinforce_location, false);

--Reinforcement Lines
for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "dae_kho_wave_reinforce_location") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "dae_nur_wave_reinforce_location") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "dae_sla_wave_reinforce_location") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "dae_tze_wave_reinforce_location") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local chs_cp = bm:capture_location_manager():capture_location_from_script_id("chs_cp");
local kho_cp = bm:capture_location_manager():capture_location_from_script_id("kho_cp");
local nur_cp = bm:capture_location_manager():capture_location_from_script_id("nur_cp");
local sla_cp = bm:capture_location_manager():capture_location_from_script_id("sla_cp");
local tze_cp = bm:capture_location_manager():capture_location_from_script_id("tze_cp");

gb:message_on_capture_location_capture_commenced("chs_cp_capture_commenced", "start", "chs_cp", nil, nil, ga_player_01);

gb:message_on_capture_location_capture_completed("chs_cp_captured", "start", "chs_cp", nil, nil, ga_player_01);

------------------------------------------------------------------------------------------------------------
------------------------------------------------MAP BARRIERS------------------------------------------------
------------------------------------------------------------------------------------------------------------
ga_player_01:enable_map_barrier_on_message("kho_cp_captured", "map_barrier_kho", false);
ga_player_01:enable_map_barrier_on_message("nur_cp_captured", "map_barrier_nur", false);
ga_player_01:enable_map_barrier_on_message("sla_cp_captured", "map_barrier_sla", false);
ga_player_01:enable_map_barrier_on_message("tze_cp_captured", "map_barrier_tze", false);

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	-- Khone Mortals
	ga_ai_enemy_main_kho_lord_mortal.sunits:item(1).uc:teleport_to_location(v(111.86, 119.38), 45.0, 5.0);

	ga_ai_enemy_kho_main.sunits:item(1).uc:teleport_to_location(v(116.55, 165.93), 45.0, 21.20);
	ga_ai_enemy_kho_main.sunits:item(2).uc:teleport_to_location(v(133.48, 150.06), 45.0, 21.20);
	ga_ai_enemy_kho_main.sunits:item(3).uc:teleport_to_location(v(150.40, 134.19), 45.0, 21.20);
	ga_ai_enemy_kho_main.sunits:item(4).uc:teleport_to_location(v(167.33, 118.32), 45.0, 21.20);

	-- Nurgle Mortals
	ga_ai_enemy_main_nur_lord_mortal.sunits:item(1).uc:teleport_to_location(v(-114.04, 126.27), 315.0, 5.0);

	ga_ai_enemy_nur_main.sunits:item(1).uc:teleport_to_location(v(-168.71, 110.90), 315.0, 21.20);
	ga_ai_enemy_nur_main.sunits:item(2).uc:teleport_to_location(v(-152.32, 127.32), 315.0, 21.20);
	ga_ai_enemy_nur_main.sunits:item(3).uc:teleport_to_location(v(-135.92, 143.74), 315.0, 21.20);
	ga_ai_enemy_nur_main.sunits:item(4).uc:teleport_to_location(v(-119.53, 160.16), 315.0, 21.20);

	-- Slaanesh Mortals
	ga_ai_enemy_main_sla_lord_mortal.sunits:item(1).uc:teleport_to_location(v(125.44, -114.95), 135.0, 5.0);

	ga_ai_enemy_sla_main.sunits:item(1).uc:teleport_to_location(v(129.54, -81.76), 135, 21.20);
	ga_ai_enemy_sla_main.sunits:item(2).uc:teleport_to_location(v(115.26, -100.26), 135, 21.20);
	ga_ai_enemy_sla_main.sunits:item(3).uc:teleport_to_location(v(101.68, -117.83), 135, 21.20);
	ga_ai_enemy_sla_main.sunits:item(4).uc:teleport_to_location(v(88.11, -135.40), 135, 21.20);

	-- Tzeentch Mortals
	ga_ai_enemy_main_tze_lord_mortal.sunits:item(1).uc:teleport_to_location(v(-125.90, -113.91), 225.0, 5.0);

	ga_ai_enemy_tze_main.sunits:item(1).uc:teleport_to_location(v(-84.81, -131.71), 225.0, 21.20);
	ga_ai_enemy_tze_main.sunits:item(2).uc:teleport_to_location(v(-101.03, -116.56), 225.0, 21.20);
	ga_ai_enemy_tze_main.sunits:item(3).uc:teleport_to_location(v(-117.25, -101.41), 225.0, 21.20);
	ga_ai_enemy_tze_main.sunits:item(4).uc:teleport_to_location(v(-133.48, -86.26), 225.0, 21.20);
end;

------------------------------------------------------------------------------------------------------------------
------------------------------------------------HINTS & OBJECTIVES------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-----OBJECTIVE 0-----
-- Defeat Archaon - Halt the Chaos Invasion
gb:set_locatable_objective_callback_on_message(
    "chs_cp_exposed",
    "wh3_dlc29_endgame_crisis_chaos_invasion_objective_00",
    0,
    function()
        local sunit = ga_ai_enemy_main_boss.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                               -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("archaon_defeated", "wh3_dlc29_endgame_crisis_chaos_invasion_objective_00");

-----OBJECTIVE 1-----
-- Defeat the Lords of Chaos - Defeating the lords of a Chaos God will close the portals to the Chaos Realm
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 0, 0, 8);

-----OBJECTIVE 2-----
-- Destroy the Marks of Chaos - Destroying a Mark of Chaos will open pathways to Archaon
gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc29_endgame_crisis_chaos_invasion_objective_02", 0, 0, 4);

-----HINTS-----
-- Chaos Daemons are being summoned to the battlefield, defeat their champions to close the portals!
gb:queue_help_on_message("daemons_spawned", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_01");

-- Archaon the Everchosen is no more, with no leader, the warband will fall apart
gb:queue_help_on_message("cp_main_stolen", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_02");

-- The Lords of Khorne have been defeated, the portals to the Realm of Khorne have been closed!
gb:queue_help_on_message("kho_lords_defeated", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_03");

-- The Lords of Nurlge have been defeated, the portals to the Realm of Nurlge have been closed!
gb:queue_help_on_message("nur_lords_defeated", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_04");

-- The Lords of Slaanesh have been defeated, the portals to the Realm of Slaanesh have been closed!
gb:queue_help_on_message("sla_lords_defeated", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_05");

-- The Lords of Tzeentch have been defeated, the portals to the Realm of Tzeentch have been closed!
gb:queue_help_on_message("tze_lords_defeated", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_06");

-- Archaon has been blessed by the Chaos Gods and cannot be harmed while the barriers around him remain
gb:queue_help_on_message("objective_02_hint", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_07");

-- An entrance to the platform has been opened, Archaon can now be attacked!
gb:queue_help_on_message("chs_cp_exposed", "wh3_dlc29_endgame_crisis_chaos_invasion_hint_08");

-----------------------------------------------------------------------------
-------------------------------CAMPAIGN CONTEXT-------------------------------
------------------------------------------------------------------------------
local dae_wave_speed = 30000;
local dae_wave_number = 1;

local chaos_invasion_fb_provinces_threshold_01 = core:svr_load_bool("chaos_invasion_fb_provinces_threshold_01")
local chaos_invasion_fb_provinces_threshold_02 = core:svr_load_bool("chaos_invasion_fb_provinces_threshold_02")
local chaos_invasion_fb_provinces_threshold_03 = core:svr_load_bool("chaos_invasion_fb_provinces_threshold_03")

function set_threshold_01_daemons()
	if chaos_invasion_fb_provinces_threshold_01 == true then
		dae_wave_speed = 30000;
		dae_wave_number = 1;

		bm:out("----------Using Province Threshold 01 - 0-14% of the world razed");
	elseif chaos_invasion_fb_provinces_threshold_01 == false then
		bm:out("----------Not using Province Threshold 01");
	else
		bm:out("----------Province Threshold 01 is broken, using default values...");
	end
end

function set_threshold_02_daemons()
	if chaos_invasion_fb_provinces_threshold_02 == true then
		dae_wave_speed = 22500;
		dae_wave_number = 1;

		bm:out("----------Using Province Threshold 02 - 15-44% of the world razed");
	elseif chaos_invasion_fb_provinces_threshold_02 == false then
		bm:out("----------Not using Province Threshold 02");
	else
		bm:out("----------Province Threshold 02 is broken, using default values...");
	end
end

function set_threshold_03_daemons()
	if chaos_invasion_fb_provinces_threshold_03 == true then
		dae_wave_speed = 15000;
		dae_wave_number = 1;

		bm:out("----------Using Province Threshold 03 - 45%+ of the world razed");
	elseif chaos_invasion_fb_provinces_threshold_03 == false then
		bm:out("----------Not using Province Threshold 03");
	else
		bm:out("----------Province Threshold 03 is broken, using default values...");
	end
end

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local chs_lords_defeated = 0;
local chs_marks_defeated = 0;

local kho_lords_dead = 0;
local nur_lords_dead = 0;
local sla_lords_dead = 0;
local tze_lords_dead = 0;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

set_threshold_01_daemons()
set_threshold_02_daemons()
set_threshold_03_daemons()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("defend", 500);
gb:message_on_time_offset("objective_01", 10000);
gb:message_on_time_offset("objective_02", 5000);
gb:message_on_time_offset("objective_02_hint", 2500);

gb:message_on_any_message_received("daemons_spawned","kho_wave_in","nur_wave_in","sla_wave_in","tze_wave_in")

----------------------------------------
----------CHAOS MORTALS ORDERS----------
----------------------------------------
ga_ai_enemy_kho_main:message_on_proximity_to_enemy("player_near_kho_army", 115);
ga_ai_enemy_nur_main:message_on_proximity_to_enemy("player_near_nur_army", 115);
ga_ai_enemy_sla_main:message_on_proximity_to_enemy("player_near_sla_army", 115);
ga_ai_enemy_tze_main:message_on_proximity_to_enemy("player_near_tze_army", 115);

--Chaos Lords
ga_ai_enemy_main_kho_lord_mortal:add_winds_of_magic_on_message("start", 5);
ga_ai_enemy_main_nur_lord_mortal:add_winds_of_magic_on_message("start", 5);
ga_ai_enemy_main_sla_lord_mortal:add_winds_of_magic_on_message("start", 5);
ga_ai_enemy_main_tze_lord_mortal:add_winds_of_magic_on_message("start", 5);

ga_ai_enemy_main_kho_lord_mortal:defend_on_message("defend", 125, 115, 75); 
ga_ai_enemy_main_nur_lord_mortal:defend_on_message("defend", -125, 115, 75); 
ga_ai_enemy_main_sla_lord_mortal:defend_on_message("defend", 125, -115, 75); 
ga_ai_enemy_main_tze_lord_mortal:defend_on_message("defend", -125, -115, 75); 

ga_ai_enemy_main_kho_lord_mortal:rush_on_message("kho_rush");
ga_ai_enemy_main_nur_lord_mortal:rush_on_message("nur_rush");
ga_ai_enemy_main_sla_lord_mortal:rush_on_message("sla_rush");
ga_ai_enemy_main_tze_lord_mortal:rush_on_message("tze_rush");

ga_ai_enemy_main_kho_lord_mortal:message_on_casualties("kho_lord_attacked", 0.05)
ga_ai_enemy_main_nur_lord_mortal:message_on_casualties("nur_lord_attacked", 0.05)
ga_ai_enemy_main_sla_lord_mortal:message_on_casualties("sla_lord_attacked", 0.05)
ga_ai_enemy_main_tze_lord_mortal:message_on_casualties("tze_lord_attacked", 0.05)

--Chaos Mortals
ga_ai_enemy_kho_main:defend_on_message("defend", 125, 115, 75);  
ga_ai_enemy_nur_main:defend_on_message("defend", -125, 115, 75); 
ga_ai_enemy_sla_main:defend_on_message("defend", 125, -115, 75);
ga_ai_enemy_tze_main:defend_on_message("defend", -125, -115, 75); 

ga_ai_enemy_kho_main:rush_on_message("kho_rush");
ga_ai_enemy_nur_main:rush_on_message("nur_rush");
ga_ai_enemy_sla_main:rush_on_message("sla_rush");
ga_ai_enemy_tze_main:rush_on_message("tze_rush");

ga_ai_enemy_kho_main:message_on_casualties("kho_main_attacked",0.05);
ga_ai_enemy_nur_main:message_on_casualties("nur_main_attacked",0.05);
ga_ai_enemy_sla_main:message_on_casualties("sla_main_attacked",0.05);
ga_ai_enemy_tze_main:message_on_casualties("tze_main_attacked",0.05);

ga_ai_enemy_kho_main:message_on_rout_proportion("kho_main_defeated",0.95);
ga_ai_enemy_nur_main:message_on_rout_proportion("nur_main_defeated",0.95);
ga_ai_enemy_sla_main:message_on_rout_proportion("sla_main_defeated",0.95);
ga_ai_enemy_tze_main:message_on_rout_proportion("tze_main_defeated",0.95);

gb:message_on_any_message_received("kho_rush","player_near_kho_army","chs_main_weak","kho_lord_attacked","kho_main_attacked")
gb:message_on_any_message_received("nur_rush","player_near_nur_army","chs_main_weak","nur_lord_attacked","nur_main_attacked")
gb:message_on_any_message_received("sla_rush","player_near_sla_army","chs_main_weak","sla_lord_attacked","sla_main_attacked")
gb:message_on_any_message_received("tze_rush","player_near_tze_army","chs_main_weak","tze_lord_attacked","tze_main_attacked")

gb:message_on_all_messages_received("chaos_mortals_defeated","chs_main_defeated","kho_main_defeated","nur_main_defeated","sla_main_defeated","tze_main_defeated");

----------------------------------------
----------CHAOS DAEMONS ORDERS----------
----------------------------------------
ga_player_01:message_on_proximity_to_position("spawn_kho_daemons", v(125, 2500, 115), 100);
ga_player_01:message_on_proximity_to_position("spawn_nur_daemons", v(-125, 2500, 115), 100);
ga_player_01:message_on_proximity_to_position("spawn_sla_daemons", v(125, 2500, -115), 100);
ga_player_01:message_on_proximity_to_position("spawn_tze_daemons", v(-125, 2500, -115), 100);

-- Khorne Daemons
ga_ai_enemy_main_kho_lord_daemon:reinforce_on_message("spawn_kho_daemons");
ga_ai_enemy_main_kho_lord_daemon:message_on_any_deployed("kho_daemon_in");
ga_ai_enemy_main_kho_lord_daemon:rush_on_message("kho_daemon_in");

ga_ai_enemy_kho_wave:deploy_at_random_intervals_on_message(
	"spawn_kho_daemons", 		-- message
	dae_wave_number, 			-- min units
	dae_wave_number, 			-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"kho_lords_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_kho_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_enemy_kho_wave:message_on_any_deployed("kho_wave_in");
ga_ai_enemy_kho_wave:rush_on_message("kho_wave_in");

gb:add_listener(
	"kho_lords_defeated",
	function()
		if ga_ai_enemy_kho_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_kho_wave.sunits:kill_proportion_over_time(1.0, 2500, false);
		end;
    end,
	true
);

-- Nurgle Daemons
ga_ai_enemy_main_nur_lord_daemon:reinforce_on_message("spawn_nur_daemons");
ga_ai_enemy_main_nur_lord_daemon:message_on_any_deployed("nur_daemon_in");
ga_ai_enemy_main_nur_lord_daemon:rush_on_message("nur_daemon_in");

ga_ai_enemy_nur_wave:deploy_at_random_intervals_on_message(
	"spawn_nur_daemons", 		-- message
	dae_wave_number, 			-- min units
	dae_wave_number, 			-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"nur_lords_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_nur_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_enemy_nur_wave:message_on_any_deployed("nur_wave_in");
ga_ai_enemy_nur_wave:rush_on_message("nur_wave_in");

gb:add_listener(
	"nur_lords_defeated",
	function()
		if ga_ai_enemy_nur_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_nur_wave.sunits:kill_proportion_over_time(1.0, 2500, false);
		end;
    end,
	true
);

-- Slaanesh Daemons
ga_ai_enemy_main_sla_lord_daemon:reinforce_on_message("spawn_sla_daemons");
ga_ai_enemy_main_sla_lord_daemon:message_on_any_deployed("sla_daemon_in");
ga_ai_enemy_main_sla_lord_daemon:rush_on_message("sla_daemon_in");

ga_ai_enemy_sla_wave:deploy_at_random_intervals_on_message(
	"spawn_sla_daemons", 		-- message
	dae_wave_number, 			-- min units
	dae_wave_number, 			-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"sla_lords_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_sla_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_enemy_sla_wave:message_on_any_deployed("sla_wave_in");
ga_ai_enemy_sla_wave:rush_on_message("sla_wave_in");

gb:add_listener(
	"sla_lords_defeated",
	function()
		if ga_ai_enemy_sla_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_sla_wave.sunits:kill_proportion_over_time(1.0, 2500, false);
		end;
    end,
	true
);

-- Tzeentch Daemons
ga_ai_enemy_main_tze_lord_daemon:reinforce_on_message("spawn_tze_daemons");
ga_ai_enemy_main_tze_lord_daemon:message_on_any_deployed("tze_daemon_in");
ga_ai_enemy_main_tze_lord_daemon:rush_on_message("tze_daemon_in");

ga_ai_enemy_tze_wave:deploy_at_random_intervals_on_message(
	"spawn_tze_daemons", 		-- message
	dae_wave_number, 			-- min units
	dae_wave_number, 			-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"tze_lords_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_tze_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_enemy_tze_wave:message_on_any_deployed("tze_wave_in");
ga_ai_enemy_tze_wave:rush_on_message("tze_wave_in");

gb:add_listener(
	"tze_lords_defeated",
	function()
		if ga_ai_enemy_tze_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_tze_wave.sunits:kill_proportion_over_time(1.0, 2500, false);
		end;
    end,
	true
);

----------------------------------------
----------CHAOS LORDS MECHANIC----------
----------------------------------------
gb:add_listener(
	"start",
	function()
		ga_ai_enemy_main_kho_lord_mortal.sunits:release_control();
		ga_ai_enemy_kho_main.sunits:release_control();

		ga_ai_enemy_main_nur_lord_mortal.sunits:release_control();
		ga_ai_enemy_nur_main.sunits:release_control();

		ga_ai_enemy_main_sla_lord_mortal.sunits:release_control();
		ga_ai_enemy_sla_main.sunits:release_control();

		ga_ai_enemy_main_tze_lord_mortal.sunits:release_control();
		ga_ai_enemy_tze_main.sunits:release_control();
    end,
	true
);

gb:add_listener(
	"archaon_attack_back",
	function()
		--Archaon Force
		ga_ai_enemy_main_boss:defend(0, 0, 25); 
    end,
	true
);

gb:add_listener(
	"chs_cp_exposed",
	function()
		--Archaon Force
		ga_ai_enemy_main_boss:rush();
		ga_ai_enemy_main_boss:add_winds_of_magic_on_message("chs_main_rush", 25);
		ga_ai_enemy_main_boss:message_on_rout_proportion("chs_main_weak",0.65);
		ga_ai_enemy_main_boss:message_on_rout_proportion("chs_main_defeated",0.95);

		if ga_ai_enemy_main_kho_lord_mortal.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_kho_lord_mortal:rush();
		end;

		if ga_ai_enemy_main_nur_lord_mortal.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_nur_lord_mortal:rush();
		end;

		if ga_ai_enemy_main_sla_lord_mortal.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_sla_lord_mortal:rush();
		end;

		if ga_ai_enemy_main_tze_lord_mortal.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_tze_lord_mortal:rush();
		end;
    end,
	true
);

ga_ai_enemy_main_boss:message_on_commander_dead_or_shattered("archaon_defeated")

gb:message_on_any_message_received("chs_cp_exposed","kho_cp_captured","nur_cp_captured","sla_cp_captured","tze_cp_captured")

ga_ai_enemy_main_boss:message_on_under_attack("archaon_attacked");
gb:message_on_time_offset("archaon_attack_back", 1000, "archaon_attacked");

gb:add_listener(
    "start",
	function()
		ga_ai_enemy_main_boss.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_enemy_main_boss.sunits:set_invincible(true);
		ga_ai_enemy_main_boss.sunits:take_control();

		ga_ai_enemy_main_kho_lord_mortal.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_enemy_main_nur_lord_mortal.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_enemy_main_sla_lord_mortal.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_enemy_main_tze_lord_mortal.sunits:set_stat_attribute("unbreakable", true);

		ga_ai_enemy_kho_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_enemy_nur_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_enemy_sla_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_enemy_tze_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
    end,
	true
);

gb:add_listener(
	"chs_cp_exposed",
	function()
		ga_ai_enemy_main_boss.sunits:set_invincible(false);
		ga_ai_enemy_main_boss.sunits:release_control();
    end,
	true
);

ga_ai_enemy_kho_main:rout_over_time_on_message("archaon_defeated", 60000);
ga_ai_enemy_nur_main:rout_over_time_on_message("archaon_defeated", 60000);
ga_ai_enemy_sla_main:rout_over_time_on_message("archaon_defeated", 60000);
ga_ai_enemy_tze_main:rout_over_time_on_message("archaon_defeated", 60000);

------------------------------------------
----------MARKS COUNTER MECHANIC----------
------------------------------------------
gb:message_on_all_messages_received("chs_marks_defeated","kho_cp_captured","nur_cp_captured","sla_cp_captured","tze_cp_captured");

gb:message_on_capture_location_capture_completed("kho_cp_captured", "start", "kho_cp", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("nur_cp_captured", "start", "nur_cp", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("sla_cp_captured", "start", "sla_cp", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("tze_cp_captured", "start", "tze_cp", nil, nil, ga_player_01);

ga_player_01:add_winds_of_magic_on_message("kho_cp_captured", 15);
ga_player_01:add_winds_of_magic_on_message("nur_cp_captured", 15);
ga_player_01:add_winds_of_magic_on_message("sla_cp_captured", 15);
ga_player_01:add_winds_of_magic_on_message("tze_cp_captured", 15);

gb:add_listener(
	"chs_cp_captured",
	function()
		chs_cp:set_locked(true);
		chs_cp:set_enabled(false);
	end
);

gb:add_listener(
	"kho_cp_captured",
	function()
		chs_marks_defeated = chs_marks_defeated + 1

		kho_cp:set_locked(true);
		kho_cp:set_enabled(false);
	end
);

gb:add_listener(
	"nur_cp_captured",
	function()
		chs_marks_defeated = chs_marks_defeated + 1

		nur_cp:set_locked(true);
		nur_cp:set_enabled(false);
	end
);

gb:add_listener(
	"sla_cp_captured",
	function()
		chs_marks_defeated = chs_marks_defeated + 1

		sla_cp:set_locked(true);
		sla_cp:set_enabled(false);
	end
);

gb:add_listener(
	"tze_cp_captured",
	function()
		chs_marks_defeated = chs_marks_defeated + 1

		tze_cp:set_locked(true);
		tze_cp:set_enabled(false);
	end
);

-- Chaos Marks Counter
gb:add_listener(
	"start",
	function()
    bm:repeat_callback(
        function()
            if chs_marks_defeated == 1 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_02", 1, 4);
            end

            if chs_marks_defeated == 2 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_02", 2, 4);
            end

            if chs_marks_defeated == 3 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_02", 3, 4);
            end

            if chs_marks_defeated == 4 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_02", 4, 4);
				bm:remove_callback("marks_captured")
            end
         end,
        1000,
        "marks_captured"
    )
	end,
	true
)

------------------------------------------
----------LORDS COUNTER MECHANIC----------
------------------------------------------
gb:message_on_all_messages_received("chs_lords_defeated","kho_lords_defeated","nur_lords_defeated","sla_lords_defeated","tze_lords_defeated");

-- Khorne Lords
ga_ai_enemy_main_kho_lord_mortal:message_on_commander_dead_or_shattered("kho_lord_01_defeated")
ga_ai_enemy_main_kho_lord_daemon:message_on_commander_dead_or_shattered("kho_lord_02_defeated")

gb:add_listener(
    "kho_lord_01_defeated",
	function()
		kho_lords_dead = kho_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:add_listener(
    "kho_lord_02_defeated",
	function()
		kho_lords_dead = kho_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:message_on_all_messages_received("kho_lords_defeated","kho_lord_01_defeated","kho_lord_02_defeated");

-- Nurgle Lords
ga_ai_enemy_main_nur_lord_mortal:message_on_commander_dead_or_shattered("nur_lord_01_defeated")
ga_ai_enemy_main_nur_lord_daemon:message_on_commander_dead_or_shattered("nur_lord_02_defeated")

gb:add_listener(
    "nur_lord_01_defeated",
	function()
		nur_lords_dead = nur_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:add_listener(
    "nur_lord_02_defeated",
	function()
		nur_lords_dead = nur_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:message_on_all_messages_received("nur_lords_defeated","nur_lord_01_defeated","nur_lord_02_defeated");

-- Slaanesh Lords
ga_ai_enemy_main_sla_lord_mortal:message_on_commander_dead_or_shattered("sla_lord_01_defeated")
ga_ai_enemy_main_sla_lord_daemon:message_on_commander_dead_or_shattered("sla_lord_02_defeated")

gb:add_listener(
    "sla_lord_01_defeated",
	function()
		sla_lords_dead = sla_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:add_listener(
    "sla_lord_02_defeated",
	function()
		sla_lords_dead = sla_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:message_on_all_messages_received("sla_lords_defeated","sla_lord_01_defeated","sla_lord_02_defeated");

-- Tzeentch Lords
ga_ai_enemy_main_tze_lord_mortal:message_on_commander_dead_or_shattered("tze_lord_01_defeated")
ga_ai_enemy_main_tze_lord_daemon:message_on_commander_dead_or_shattered("tze_lord_02_defeated")

gb:add_listener(
    "tze_lord_01_defeated",
	function()
		tze_lords_dead = tze_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:add_listener(
    "tze_lord_02_defeated",
	function()
		tze_lords_dead = tze_lords_dead + 1
		chs_lords_defeated = chs_lords_defeated + 1
    end,
	true
)

gb:message_on_all_messages_received("tze_lords_defeated","tze_lord_01_defeated","tze_lord_02_defeated");

-- All Chaos Lords
gb:add_listener(
	"start",
	function()
    bm:repeat_callback(
        function()
            if chs_lords_defeated == 1 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 1, 8);
            end

            if chs_lords_defeated == 2 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 2, 8);
            end

            if chs_lords_defeated == 3 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 3, 8);
            end

            if chs_lords_defeated == 4 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 4, 8);
            end

			if chs_lords_defeated == 5 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 5, 8);
            end

            if chs_lords_defeated == 6 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 6, 8);
            end

			 if chs_lords_defeated == 7 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 7, 8);
            end

            if chs_lords_defeated == 8 then
				bm:set_objective("wh3_dlc29_endgame_crisis_chaos_invasion_objective_01", 8, 8);
				bm:remove_callback("all_chs_lords_defeated")
            end
         end,
        1000,
        "all_chs_lords_defeated"
    )
	end,
	true
)

----------------------
-------END GAME-------
----------------------
gb:message_on_all_messages_received("invasion_halted","archaon_defeated", "chs_marks_defeated","chs_lords_defeated","chaos_mortals_defeated");

ga_player_01:force_victory_on_message("invasion_halted", 5000);