load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_mammoth.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_mammoth.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_mammoth.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_mammoth.002") end, 15400);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play taunt)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_east_extreme_high_02", 8000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_back_right_close_low_01", 8000, true, false, true);
gc:add_element(nil, nil, "gc_slow_absolute_high_pass_statues_01_to_absolute_high_pass_statues_02", 4000, true, false, false);
gc:add_element(nil, nil, nil, 4000, true, false, false);
gc:add_element(nil, nil, "gc_medium_army_pan_front_right_to_front_left_far_high_01", 6000, true, false, false);


gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_player_ally = gb:get_army(gb:get_player_alliance_num(0), 2);	
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_6_hint_objective");
gb:queue_help_on_message("help_the_cub", "wh_dlc08_qb_monster_hunt_6_hint_boss_ability");
gb:remove_objective_on_message("help_the_cub", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("help_the_cub", "wh_main_qb_objective_attack_defeat_army");
-------ORDERS-------

gb:message_on_time_offset("help_the_cub", 20000);
ga_player_ally:defend_on_message("battle_started", -88, 40, 40); 
ga_ai_01:message_on_casualties("hurt",0.2);
ga_ai_01:attack_on_message("battle_started");
ga_ai_02:reinforce_on_message("hurt",1000);
ga_ai_02:message_on_deployed("ga_ai_02_in");
ga_ai_02:rush_on_message("ga_ai_02_in");

-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_03:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");



