load_script_libraries();

local gc = generated_cutscene:new(true, true);

gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 3000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, true, true, false);

gb = generated_battle:new(
                false,                          -- screen starts black
                false,                          -- prevent deployment for player
                true,                    	    -- prevent deployment for ai
                function() 
				gb:start_generated_cutscene(gc) 
				end, 							-- intro cutscene function
                false                           -- debug mode
);

gb:set_cutscene_during_deployment(true);

local sound_1 = new_sfx("CindyOneshot_WH3_DLC27_QB_Stinger_Next_Scene_01"); -- prelife 200ms
local sound_2 = new_sfx("CindyOneshot_WH3_DLC27_QB_Stinger_Next_Scene_02"); -- prelife 50ms
local sound_3 = new_sfx("CindyOneshot_WH3_DLC27_QB_Stinger_Next_Scene_03"); -- prelife 50ms
local sound_END = new_sfx("CindyOneshot_WH3_DLC27_QB_Stinger_END"); -- prelife 400ms
---------------------------
----HARD SCRIPT VERSION----
---------------------------
local sm = get_messager();

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
--Enemy Casters
ga_ai_casters = gb:get_army(gb:get_non_player_alliance_num(), "caster");
--Enemy Forces
ga_ai_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_forces");

caster_01 = ga_ai_casters.sunits:item(1);
caster_02 = ga_ai_casters.sunits:item(2);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--Defeat the Enemy Forces
gb:play_sound_on_message("deployment_started", sound_2, nil, 2950);
gb:play_sound_on_message("deployment_started", sound_1, nil, 6800);
gb:play_sound_on_message("deployment_started", sound_END, nil, 10600);
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01");
gb:complete_objective_on_message("enemy_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01");
gb:remove_objective_on_message("enemy_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01", 10000);

gb:queue_help_on_message("start", "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_01");

-----OBJECTIVE 2-----
--Defeat the Casters of X & Y
gb:set_objective_with_leader_on_message("casters_hint_01", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_life_death");
gb:complete_objective_on_message("casters_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_life_death");
gb:remove_objective_on_message("casters_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_life_death", 10000);

gb:queue_help_on_message("casters_in", "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_life_death");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);

caster_01:set_stat_attribute("unbreakable", true);
caster_02:set_stat_attribute("unbreakable", true);

gb:message_on_all_messages_received("enemy_defeated", "casters_defeated", "main_forces_defeated")

ga_player_01:force_victory_on_message("enemy_defeated", 5000);

----------------------------------
----------PHASE 1 ORDERS----------
----------------------------------
ga_ai_main_forces:rush_on_message("start");
ga_ai_main_forces:message_on_rout_proportion("casters_reinforce",0.35);
ga_ai_main_forces:message_on_rout_proportion("main_forces_defeated",0.95);

gb:add_listener(
	"casters_hint_01",
	function()
		caster_01:add_ping_icon(15);
		caster_02:add_ping_icon(15);
	end,
	true
);

----------------------------------
----------PHASE 2 ORDERS----------
----------------------------------
gb:message_on_time_offset("casters_hint_01", 5000, "casters_in");

ga_ai_casters:reinforce_on_message("casters_reinforce");
ga_ai_casters:message_on_any_deployed("casters_in");
ga_ai_casters:rush_on_message("casters_in");
ga_ai_casters:message_on_rout_proportion("casters_defeated",0.95);