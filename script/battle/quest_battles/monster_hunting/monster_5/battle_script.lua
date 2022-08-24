load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_forestdragon.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_forestdragon.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_forestdragon.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_forestdragon.002") end, 5800);
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_forestdragon.003"); bm:queue_advisor("dlc08.battle.speech.nor.battle_forestdragon.003") end, 15200);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, false, false, false);
gc:add_element(nil, nil,  nil, 10500, false, false, false);
gc:add_element(nil,nil, "gc_orbit_ccw_360_slow_ground_offset_south_west_extreme_high_02", 6500, false, false, false);
gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 8000, true, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_front_medium_medium_to_close_low_01", 5700, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_5_hint_objective");
gb:queue_help_on_message("tree_man_arrives", "wh_dlc08_qb_monster_hunt_5_hint_reinforcements");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_5_hint_boss_gone");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_5_0");
-------ORDERS-------

gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 65000);
gb:message_on_time_offset("tree_man_arrives", 150000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:attack_on_message("under_attack");
ga_ai_02:attack_on_message("under_attack");
ga_ai_03:attack_on_message("under_attack");
ga_ai_03:deploy_at_random_intervals_on_message("start_ambush", 1, 1, 170000, 175000);
ga_ai_02:message_on_casualties("hurt",0.95);
ga_ai_03:rout_over_time_on_message("hurt", 5000);

-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_03:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




