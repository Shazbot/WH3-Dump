load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_arachnarok.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_arachnarok.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_arachnarok.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_arachnarok.002") end, 12700);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

gc:add_element(nil, nil, "gc_medium_absolute_ancient_hall_00", 4000, false, false, false);
gc:add_element(nil, nil, nil, 9060, false, false, false);
gc:add_element(nil, nil, "gc_medium_absolute_ancient_hall_01", 5260, false, false, false);
gc:add_element(nil, nil, nil, 5210, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 2000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);

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
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_3_hint_objective");
-- gb:queue_help_on_message("cavelry_arrived", "wh_dlc05_qb_wef_orion_spear_of_kurnous_stage_3_hint_reinforcement");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_plural");
-------ORDERS-------

gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 1000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:attack_on_message("under_attack");
ga_ai_02:attack_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.2);
ga_ai_03:reinforce_on_message("hurt",1000);
ga_ai_03:attack_on_message("release_boss");
-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_03:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




