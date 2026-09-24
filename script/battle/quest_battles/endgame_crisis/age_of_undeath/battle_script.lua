load_script_libraries();

bm = battle_manager:new(empire_battle:new());
local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                         -- screen starts black
                false,                         -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function

					ga_player_01.sunits:item(1).uc:teleport_to_location(v(0.0, -300.0), 0.0, 5.0);

					ga_ai_enemy_main_boss.sunits:item(1).uc:teleport_to_location(v(0.0, 175.0), 180.0, 5.0);

					ga_ai_enemy_main_boss:set_visible_to_all(true);
					ga_ai_enemy_main_arkhan:set_visible_to_all(true);
					ga_ai_enemy_main_mannfred:set_visible_to_all(true);
					ga_ai_enemy_main_luthor:set_visible_to_all(true);
					ga_ai_enemy_main_vlad:set_visible_to_all(true);
					ga_ai_enemy_main_neferata:set_visible_to_all(true);
					ga_ai_enemy_main_krell:set_visible_to_all(true);
					ga_ai_enemy_main_dieter:set_visible_to_all(true);
					ga_ai_enemy_main_walach:set_visible_to_all(true);
					ga_ai_enemy_main_nameless:set_visible_to_all(true);
					ga_ai_enemy_cst_main:set_visible_to_all(true);
					ga_ai_enemy_vmp_main:set_visible_to_all(true);
					ga_ai_enemy_tmb_main:set_visible_to_all(true);
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
-- YOU HOPE THE END OF YOUR STRUGGLE IS NEAR. I KNOW IT IS.
-- FOR SUCH AS YOU, THERE IS ALWAYS AN END. 
-- FOR ME, THERE IS NOT. AND THUS, YOU ALWAYS FAIL, AGAIN AND AGAIN.
-- IT IS TIME YOU FAILED ONCE AND FOR ALL.
gc:add_element("Play_wh3_dlc29_endtimes_narrative_nagash_nagash_007_1", "wh3_dlc29_endtimes_narrative_nagash_nagash_007_1", "gc_orbit_90_medium_commander_front_right_close_low_01", 11500, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_nagash_nagash_007_2", "gc_slow_army_pan_back_right_to_back_left_close_medium_01", 9000, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_nagash_nagash_007_3", "gc_episodes_nagash_cam", 15000, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_nagash_nagash_007_4", "gc_medium_enemy_army_pan_front_right_to_front_left_medium_low_02", 9000, true, false, false);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------
--Player
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

--Nagash & Mortarchs
ga_ai_enemy_main_boss = gb:get_army(gb:get_non_player_alliance_num(), "nagash"); -- Nagash
ga_ai_enemy_main_arkhan = gb:get_army(gb:get_non_player_alliance_num(), "arkhan"); -- Mortarch #1 Arkhan
ga_ai_enemy_main_mannfred = gb:get_army(gb:get_non_player_alliance_num(), "mannfred"); -- Mortarch #2 Mannfred
ga_ai_enemy_main_luthor = gb:get_army(gb:get_non_player_alliance_num(), "luthor"); -- Mortarch #3 Luthor Harkon
ga_ai_enemy_main_vlad = gb:get_army(gb:get_non_player_alliance_num(), "vlad"); -- Mortarch #4 Vlad
ga_ai_enemy_main_neferata = gb:get_army(gb:get_non_player_alliance_num(), "neferata"); -- Mortarch #5 Neferata
ga_ai_enemy_main_krell = gb:get_army(gb:get_non_player_alliance_num(), "krell"); -- Mortarch #6 Krell
ga_ai_enemy_main_dieter = gb:get_army(gb:get_non_player_alliance_num(), "dieter"); -- Mortarch #7 Dieter
ga_ai_enemy_main_walach = gb:get_army(gb:get_non_player_alliance_num(), "walach"); -- Mortarch #8 Walach
ga_ai_enemy_main_nameless = gb:get_army(gb:get_non_player_alliance_num(), "nameless"); -- Mortarch #9 Nameless

--Vampire Coast Units
ga_ai_enemy_cst_main = gb:get_army(gb:get_non_player_alliance_num(), "cst_main");
ga_ai_enemy_cst_wave = gb:get_army(gb:get_non_player_alliance_num(), "cst_wave");

--Vampire Count Units
ga_ai_enemy_vmp_main = gb:get_army(gb:get_non_player_alliance_num(), "vmp_main");
ga_ai_enemy_vmp_wave = gb:get_army(gb:get_non_player_alliance_num(), "vmp_wave");

--Tomb King Units
ga_ai_enemy_tmb_main = gb:get_army(gb:get_non_player_alliance_num(), "tmb_main");
ga_ai_enemy_tmb_wave = gb:get_army(gb:get_non_player_alliance_num(), "tmb_wave");

-------------------------------------------------------------------------------------------------
------------------------------------------SCRIPT UNITS-------------------------------------------
-------------------------------------------------------------------------------------------------
nagash_boss = ga_ai_enemy_main_boss.sunits:item(1);
mortarch_arkhan = ga_ai_enemy_main_arkhan.sunits:item(1);
mortarch_mannfred = ga_ai_enemy_main_mannfred.sunits:item(1);
mortarch_luthor = ga_ai_enemy_main_luthor.sunits:item(1);
mortarch_vlad = ga_ai_enemy_main_vlad.sunits:item(1);
mortarch_neferata = ga_ai_enemy_main_neferata.sunits:item(1);
mortarch_krell = ga_ai_enemy_main_krell.sunits:item(1);
mortarch_dieter = ga_ai_enemy_main_dieter.sunits:item(1);
mortarch_walach = ga_ai_enemy_main_walach.sunits:item(1);
mortarch_nameless = ga_ai_enemy_main_nameless.sunits:item(1);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
-- Vampire Coast Reinforce
cst_reinforce_locaiton = bm:get_spawn_zone_collection_by_name("cst_wave_reinforcement");

-- Vampire Count Reinforce
vmp_reinforce_locaiton = bm:get_spawn_zone_collection_by_name("vmp_wave_reinforcement");

--TMB Reinforce
tmb_reinforce_locaiton = bm:get_spawn_zone_collection_by_name("tmb_wave_reinforcement");

-- Vampire Coast Wave
ga_ai_enemy_cst_wave:assign_to_spawn_zone_from_collection_on_message("start", cst_reinforce_locaiton, false);
ga_ai_enemy_cst_wave:message_on_number_deployed("cst_wave_deployed", true, 1);
ga_ai_enemy_cst_wave:assign_to_spawn_zone_from_collection_on_message("cst_wave_deployed", cst_reinforce_locaiton, false);

-- Vampire Count Wave
ga_ai_enemy_vmp_wave:assign_to_spawn_zone_from_collection_on_message("start", vmp_reinforce_locaiton, false);
ga_ai_enemy_vmp_wave:message_on_number_deployed("vmp_wave_deployed", true, 1);
ga_ai_enemy_vmp_wave:assign_to_spawn_zone_from_collection_on_message("vmp_wave_deployed", vmp_reinforce_locaiton, false);

-- Tomb King Wave
ga_ai_enemy_tmb_wave:assign_to_spawn_zone_from_collection_on_message("start", tmb_reinforce_locaiton, false);
ga_ai_enemy_tmb_wave:message_on_number_deployed("tmb_wave_deployed", true, 1);
ga_ai_enemy_tmb_wave:assign_to_spawn_zone_from_collection_on_message("tmb_wave_deployed", tmb_reinforce_locaiton, false);

--Reinforcement Lines
for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "cst_reinforce_locaiton") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "vmp_reinforce_locaiton") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "tmb_reinforce_locaiton") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local vmp_cp = bm:capture_location_manager():capture_location_from_script_id("vmp_cp");
local cst_cp = bm:capture_location_manager():capture_location_from_script_id("cst_cp");
local tmb_cp = bm:capture_location_manager():capture_location_from_script_id("tmb_cp");

gb:message_on_capture_location_capture_completed("vmp_cp_captured", "start", "vmp_cp", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("cst_cp_captured", "start", "cst_cp", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("tmb_cp_captured", "start", "tmb_cp", nil, nil, ga_player_01);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
-- Defeat Nagash - Put a stopper in Undeath
gb:set_locatable_objective_callback_on_message(
    "mortarchs_defeated",
    "wh3_dlc29_endgame_crisis_age_of_undeath_objective_00",
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

gb:complete_objective_on_message("nagash_defeated", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_00");

-----OBJECTIVE 1-----
-- Break the Bindings - Capature the bindings to break the connection to the Black Pyramid and unbind their forces
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_01", 0, 0, 3);
-- gb:complete_objective_on_message("bindings_broken", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_01");
gb:remove_objective_on_message("bindings_broken", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_01", 10000);

-----OBJECTIVE 2-----
-- Weaken Nagash - The Mortarchs provide magical protection to Nagash, defeat them all to make him vulnerable
gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 0, 0, 9);
-- gb:complete_objective_on_message("mortarchs_defeated", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_02");
gb:remove_objective_on_message("mortarchs_defeated", "wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 10000);

-----HINTS-----
-- The magical bindings strengthen the undead legions, they will summon endless undead to the battlefield until the bindings are broken
gb:queue_help_on_message("hint_01", "wh3_dlc29_endgame_crisis_age_of_undeath_hint_01");

-- The Mortarchs have met their end, Nagash is now vulnerable!
gb:queue_help_on_message("mortarchs_defeated", "wh3_dlc29_endgame_crisis_age_of_undeath_hint_02");

-- The Vampire Counts binding has been broken, their forces begin to crumble
gb:queue_help_on_message("vmp_cp_captured", "wh3_dlc29_endgame_crisis_age_of_undeath_hint_03");

-- The Vampire Coasts binding has been broken, their forces begin to crumble
gb:queue_help_on_message("cst_cp_captured", "wh3_dlc29_endgame_crisis_age_of_undeath_hint_04");

-- The Tomb Kings binding has been broken, their forces begin to crumble
gb:queue_help_on_message("tmb_cp_captured", "wh3_dlc29_endgame_crisis_age_of_undeath_hint_05");

-----------------------------------------------------------------------------
-------------------------------CAMPAIGN CONTEXT-------------------------------
------------------------------------------------------------------------------
local age_of_undeath_fb_provinces_threshold_01 = core:svr_load_bool("age_of_undeath_fb_provinces_threshold_01")
local age_of_undeath_fb_provinces_threshold_02 = core:svr_load_bool("age_of_undeath_fb_provinces_threshold_02")
local age_of_undeath_fb_provinces_threshold_03 = core:svr_load_bool("age_of_undeath_fb_provinces_threshold_03")

function set_province_threshold_01_undead()
	if age_of_undeath_fb_provinces_threshold_01 == true then
		enemy_wave_speed = 30000;

		bm:out("----------Using Province Threshold 01 - 0-44 Devastation");
	elseif age_of_undeath_fb_provinces_threshold_01 == false then
		bm:out("----------Not using Province Threshold 01");
	else
		bm:out("----------Province Threshold 01 is broken, using default values... ".. tostring(age_of_undeath_fb_provinces_threshold_01));
	end
end

function set_province_threshold_02_undead()
	if age_of_undeath_fb_provinces_threshold_02 == true then
		enemy_wave_speed = 25000;

		bm:out("----------Using Province Threshold 02 - 45-144 Devastation");
	elseif age_of_undeath_fb_provinces_threshold_02 == false then
		bm:out("----------Not using Province Threshold 02");
	else
		bm:out("----------Province Threshold 02 is broken, using default values... ".. tostring(age_of_undeath_fb_provinces_threshold_02));
	end
end

function set_province_threshold_03_undead()
	if age_of_undeath_fb_provinces_threshold_03 == true then
		enemy_wave_speed = 20000;

		bm:out("----------Using Province Threshold 03 - 145+ Devastation");
	elseif age_of_undeath_fb_provinces_threshold_03 == false then
		bm:out("----------Not using Province Threshold 03");
	else
		bm:out("----------Province Threshold 03 is broken, using default values... ".. tostring(age_of_undeath_fb_provinces_threshold_03));
	end
end

local age_of_undeath_fb_necropolis_threshold_01 = core:svr_load_bool("age_of_undeath_fb_necropolis_threshold_01")
local age_of_undeath_fb_necropolis_threshold_02 = core:svr_load_bool("age_of_undeath_fb_necropolis_threshold_02")
local age_of_undeath_fb_necropolis_threshold_03 = core:svr_load_bool("age_of_undeath_fb_necropolis_threshold_03")

function set_necropolis_threshold_01_undead()
	if age_of_undeath_fb_necropolis_threshold_01 == true then
		necropolis_count = 1;

		bm:out("----------Using Necropolis Threshold 01 - 0-4 Necropolises");
	elseif age_of_undeath_fb_necropolis_threshold_01 == false then
		bm:out("----------Not using Necropolis Threshold 01");
	else
		bm:out("----------Necropolis Threshold 01 is broken, using default values... ".. tostring(age_of_undeath_fb_necropolis_threshold_01));
	end
end

function set_necropolis_threshold_02_undead()
	if age_of_undeath_fb_necropolis_threshold_02 == true then
		necropolis_count = 2;

		bm:out("----------Using Necropolis Threshold 02 - 5-14 Necropolises");
	elseif age_of_undeath_fb_necropolis_threshold_02 == false then
		bm:out("----------Not using Necropolis Threshold 02");
	else
		bm:out("----------Necropolis Threshold 02 is broken, using default values... ".. tostring(age_of_undeath_fb_necropolis_threshold_02));
	end
end

function set_necropolis_threshold_03_undead()
	if age_of_undeath_fb_necropolis_threshold_03 == true then
		necropolis_count = 3;

		bm:out("----------Using Necropolis Threshold 03 - 15+ Necropolises");
	elseif age_of_undeath_fb_necropolis_threshold_03 == false then
		bm:out("----------Not using Necropolis Threshold 03");
	else
		bm:out("----------Necropolis Threshold 03 is broken, using default values... ".. tostring(age_of_undeath_fb_necropolis_threshold_03));
	end
end

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local mortarchs_killed = 0;
local binding_broken = 0;

local enemy_wave_speed = 30000;
local necropolis_count = 1;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

set_province_threshold_01_undead()
set_province_threshold_02_undead()
set_province_threshold_03_undead()

set_necropolis_threshold_01_undead()
set_necropolis_threshold_02_undead()
set_necropolis_threshold_03_undead()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 2500);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("objective_02", 10000);

----------------------------------------
----------UNDEAD MINION ORDERS----------
----------------------------------------
ga_ai_enemy_cst_main:defend_on_message("start", -390.0, 0.0, 50);
ga_ai_enemy_vmp_main:defend_on_message("start", 0.0, 105.0, 50);
ga_ai_enemy_tmb_main:defend_on_message("start", 390.0, 0.0, 50);

ga_ai_enemy_cst_main:rush_on_message("cst_under_attack");
ga_ai_enemy_vmp_main:rush_on_message("vmp_under_attack");
ga_ai_enemy_tmb_main:rush_on_message("tmb_under_attack");

ga_ai_enemy_cst_main:message_on_rout_proportion("cst_main_defeated",0.95);
ga_ai_enemy_vmp_main:message_on_rout_proportion("vmp_main_defeated",0.95);
ga_ai_enemy_tmb_main:message_on_rout_proportion("tmb_main_defeated",0.95);

ga_ai_enemy_cst_main:message_on_under_attack("cst_under_attack");
ga_ai_enemy_vmp_main:message_on_under_attack("vmp_under_attack");
ga_ai_enemy_tmb_main:message_on_under_attack("tmb_under_attack");

ga_ai_enemy_cst_wave:deploy_at_random_intervals_on_message(
	"start", 					-- message
	necropolis_count, 			-- min units
	necropolis_count, 			-- max units
	enemy_wave_speed, 			-- min period
	enemy_wave_speed, 			-- max period
	"cst_cp_captured", 			-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_cst_wave:message_on_any_deployed("cst_wave_in");
ga_ai_enemy_cst_wave:rush_on_message("cst_wave_in");
ga_ai_enemy_cst_wave:get_army():suppress_reinforcement_adc(1);

ga_ai_enemy_vmp_wave:deploy_at_random_intervals_on_message(
	"start", 					-- message
	necropolis_count, 			-- min units
	necropolis_count, 			-- max units
	enemy_wave_speed, 			-- min period
	enemy_wave_speed, 			-- max period
	"vmp_cp_captured", 			-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_vmp_wave:message_on_any_deployed("vmp_wave_in");
ga_ai_enemy_vmp_wave:rush_on_message("vmp_wave_in");
ga_ai_enemy_vmp_wave:get_army():suppress_reinforcement_adc(1);

ga_ai_enemy_tmb_wave:deploy_at_random_intervals_on_message(
	"start", 					-- message
	necropolis_count, 			-- min units
	necropolis_count, 			-- max units
	enemy_wave_speed, 			-- min period
	enemy_wave_speed, 			-- max period
	"tmb_cp_captured", 			-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_tmb_wave:message_on_any_deployed("tmb_wave_in");
ga_ai_enemy_tmb_wave:rush_on_message("tmb_wave_in");
ga_ai_enemy_tmb_wave:get_army():suppress_reinforcement_adc(1);

gb:message_on_all_messages_received("undead_minions_defeated","cst_main_defeated","vmp_main_defeated","tmb_main_defeated");

---------------------------------------
----------UNDEAD LORDS ORDERS----------
---------------------------------------
-- Nagash
ga_ai_enemy_main_boss:defend_on_message("start", 0.0, 175.0, 50); 
ga_ai_enemy_main_boss:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_boss:message_on_rout_proportion("nagash_defeated",0.95);
ga_ai_enemy_main_boss:message_on_under_attack("nagash_under_attack");

gb:add_listener(
	"nagash_defeated",
	function()
		-- Mortarchs
		if ga_ai_enemy_main_arkhan.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_arkhan.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_mannfred.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_mannfred.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_luthor.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_luthor.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_vlad.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_vlad.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_neferata.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_neferata.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_krell.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_krell.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_dieter.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_dieter.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_walach.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_walach.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_main_nameless.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_nameless.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		-- Undead Minions
		if ga_ai_enemy_cst_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_cst_main.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_vmp_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_vmp_main.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_tmb_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_tmb_main.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_cst_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_cst_wave.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_vmp_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_vmp_wave.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_enemy_tmb_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_tmb_wave.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

-- Mortarch #1 Arkhan
ga_ai_enemy_main_arkhan:defend_on_message("start", 390.0, 0.0, 50); 
ga_ai_enemy_main_arkhan:rush_on_message("arkhan_under_attack");
ga_ai_enemy_main_arkhan:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_arkhan:message_on_under_attack("arkhan_under_attack");
ga_ai_enemy_main_arkhan:message_on_rout_proportion("arkhan_defeated",0.95);

-- Mortarch #2 Mannfred
ga_ai_enemy_main_mannfred:defend_on_message("start", 0.0, 105.0, 50); 
ga_ai_enemy_main_mannfred:rush_on_message("mannfred_under_attack");
ga_ai_enemy_main_mannfred:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_mannfred:message_on_under_attack("mannfred_under_attack");
ga_ai_enemy_main_mannfred:message_on_rout_proportion("mannfred_defeated",0.95);

-- Mortarch #3 Luthor Harkon
ga_ai_enemy_main_luthor:defend_on_message("start", -390.0, 0.0, 50); 
ga_ai_enemy_main_luthor:rush_on_message("luthor_under_attack");
ga_ai_enemy_main_luthor:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_luthor:message_on_under_attack("luthor_under_attack");
ga_ai_enemy_main_luthor:message_on_rout_proportion("luthor_defeated",0.95);

-- Mortarch #4 Vlad
ga_ai_enemy_main_vlad:defend_on_message("start", 0.0, 105.0, 50);  
ga_ai_enemy_main_vlad:rush_on_message("vlad_under_attack");
ga_ai_enemy_main_vlad:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_vlad:message_on_under_attack("vlad_under_attack");
ga_ai_enemy_main_vlad:message_on_rout_proportion("vlad_defeated",0.95);

-- Mortarch #5 Neferata
ga_ai_enemy_main_neferata:defend_on_message("start", 0.0, 105.0, 50); 
ga_ai_enemy_main_neferata:rush_on_message("neferata_under_attack");
ga_ai_enemy_main_neferata:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_neferata:message_on_under_attack("neferata_under_attack");
ga_ai_enemy_main_neferata:message_on_rout_proportion("neferata_defeated",0.95);

-- Mortarch #6 Krell
ga_ai_enemy_main_krell:defend_on_message("start", 0.0, 105.0, 50); 
ga_ai_enemy_main_krell:rush_on_message("krell_under_attack");
ga_ai_enemy_main_krell:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_krell:message_on_under_attack("krell_under_attack");
ga_ai_enemy_main_krell:message_on_rout_proportion("krell_defeated",0.95);

-- Mortarch #7 Dieter
ga_ai_enemy_main_dieter:defend_on_message("start", 0.0, 105.0, 50);  
ga_ai_enemy_main_dieter:rush_on_message("dieter_under_attack");
ga_ai_enemy_main_dieter:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_dieter:message_on_under_attack("dieter_under_attack");
ga_ai_enemy_main_dieter:message_on_rout_proportion("dieter_defeated",0.95);

-- Mortarch #8 Walach
ga_ai_enemy_main_walach:defend_on_message("start", 0.0, 105.0, 50); 
ga_ai_enemy_main_walach:rush_on_message("walach_under_attack");
ga_ai_enemy_main_walach:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_walach:message_on_under_attack("walach_under_attack");
ga_ai_enemy_main_walach:message_on_rout_proportion("walach_defeated",0.95);

-- Mortarch #9 Nameless
ga_ai_enemy_main_nameless:defend_on_message("start", 0.0, 105.0, 50); 
ga_ai_enemy_main_nameless:rush_on_message("nameless_under_attack");
ga_ai_enemy_main_nameless:rush_on_message("nagash_under_attack");
ga_ai_enemy_main_nameless:message_on_under_attack("nameless_under_attack");
ga_ai_enemy_main_nameless:message_on_rout_proportion("nameless_defeated",0.95);

------------------------------------------
----------BLACK PYRAMID MECHANIC----------
------------------------------------------
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("arkhan_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("mannfred_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("luthor_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("vlad_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("neferata_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("krell_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("dieter_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("walach_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("nameless_defeated", 15);

ga_ai_enemy_main_boss:add_winds_of_magic_on_message("cst_main_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("vmp_main_defeated", 15);
ga_ai_enemy_main_boss:add_winds_of_magic_on_message("tmb_main_defeated", 15);

-- Bindings Counter
gb:add_listener(
	"start",
	function()
    bm:repeat_callback(
        function()
            if binding_broken == 1 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_01", 1, 3);
            end

            if binding_broken == 2 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_01", 2, 3);
            end

            if binding_broken == 3 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_01", 3, 3);
            end
         end,
        1000,
        "bindings_broken"
    )
	end,
	true
)

gb:add_listener(
	"cst_cp_captured",
	function()
		binding_broken = binding_broken + 1
		
		cst_cp:set_locked(true);
		cst_cp:set_enabled(false);

		if ga_ai_enemy_cst_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_cst_main.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;

		if ga_ai_enemy_cst_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_cst_wave.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

gb:add_listener(
	"vmp_cp_captured",
	function()
		binding_broken = binding_broken + 1

		vmp_cp:set_locked(true);
		vmp_cp:set_enabled(false);

		if ga_ai_enemy_vmp_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_vmp_main.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;

		if ga_ai_enemy_vmp_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_vmp_wave.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

gb:add_listener(
	"tmb_cp_captured",
	function()
		binding_broken = binding_broken + 1

		tmb_cp:set_locked(true);
		tmb_cp:set_enabled(false);

		if ga_ai_enemy_tmb_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_tmb_main.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;

		if ga_ai_enemy_tmb_wave.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_tmb_wave.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

gb:message_on_all_messages_received("bindings_broken","vmp_cp_captured","cst_cp_captured","tmb_cp_captured");

gb:add_listener(
    "bindings_broken",
	function()
		bm:remove_callback("bindings_broken")
    end,
	true
);

-----------------------------------
----------NAGASH MECHANIC----------
-----------------------------------
gb:message_on_all_messages_received("mortarchs_defeated","arkhan_defeated","mannfred_defeated","luthor_defeated","vlad_defeated","neferata_defeated","krell_defeated","dieter_defeated","walach_defeated","nameless_defeated");

-- Mortarchs Counter
gb:add_listener(
	"start",
	function()
    bm:repeat_callback(
        function()
            if mortarchs_killed == 1 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 1, 9);
            end

            if mortarchs_killed == 2 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 2, 9);
            end

            if mortarchs_killed == 3 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 3, 9);
            end

            if mortarchs_killed == 4 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 4, 9);
            end

			if mortarchs_killed == 5 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 5, 9);
            end

            if mortarchs_killed == 6 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 6, 9);
            end

			 if mortarchs_killed == 7 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 7, 9);
            end

            if mortarchs_killed == 8 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 8, 9);
            end

			if mortarchs_killed == 9 then
				bm:set_objective("wh3_dlc29_endgame_crisis_age_of_undeath_objective_02", 9, 9);
				bm:remove_callback("mortarchs_defeated");
            end
         end,
        1000,
        "mortarchs_defeated"
    )
	end,
	true
)

-- Nagash
gb:add_listener(
	"start",
	function()
		nagash_boss:set_invincible(true);
	end,
	true
);

gb:add_listener(
    "mortarchs_defeated",
	function()
		nagash_boss:set_invincible(false);
    end,
	true
);

-- Mortarch #1 Arkhan
gb:add_listener(
	"arkhan_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_arkhan.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_arkhan.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #2 Mannfred
gb:add_listener(
	"mannfred_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_mannfred.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_mannfred.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #3 Luthor Harkon
gb:add_listener(
	"luthor_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_luthor.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_luthor.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #4 Vlad
gb:add_listener(
	"vlad_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_vlad.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_vlad.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #5 Neferata
gb:add_listener(
	"neferata_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_neferata.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_neferata.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #6 Krell
gb:add_listener(
	"krell_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_krell.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_krell.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #7 Dieter
gb:add_listener(
	"dieter_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_dieter.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_dieter.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #8 Walach
gb:add_listener(
	"walach_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_walach.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_walach.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

-- Mortarch #9 Nameless
gb:add_listener(
	"nameless_defeated",
	function()
		mortarchs_killed = mortarchs_killed + 1

		if ga_ai_enemy_main_nameless.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_main_nameless.sunits:kill_proportion_over_time(1.0, 15000, false);
		end;
	end,
	true
);

----------------------
-------END GAME-------
----------------------
gb:message_on_all_messages_received("undead_defeated","nagash_defeated","mortarchs_defeated","undead_minions_defeated");

ga_player_01:force_victory_on_message("undead_defeated", 5000);