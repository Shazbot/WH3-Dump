load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_shaggoth.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_shaggoth.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_shaggoth.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_shaggoth.002") end, 11400);
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_shaggoth.003"); bm:queue_advisor("dlc08.battle.speech.nor.battle_shaggoth.003") end, 19500);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_cliff_beasts_pan_01_to_absolute_cliff_beasts_pan_02", 4000, false, false, false);
gc:add_element(nil, nil, nil, 4000, true, false, false);
gc:add_element(nil, nil, "gc_medium_army_pan_back_right_to_back_left_far_high_01", 4000, true, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_right_close_low_01", 9000, true, false, false);
gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 8000, true, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 8000, true, true, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_2_hint_objective");
gb:queue_help_on_message("start_counter", "wh_dlc08_qb_monster_hunt_2_storm_gathers");
gb:queue_help_on_message("released_for_a_while", "wh_dlc08_qb_monster_hunt_2_hint_boss_ability");
gb:queue_help_on_message("released_for_a_while_1", "wh_dlc08_qb_monster_hunt_2_hint_boss_ability");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_2_hint_boss_gone");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_2_0");
get_messager():add_listener(
	"start_counter",
	function()
		local vulnerability_loop_func = function()
			bm:out("*** Starting boss vulnerability loop");
				
			for i = 39, 1, -1 do
				bm:callback(function() bm:set_objective("wh_dlc08_qb_monster_hunt_2_storm_count", i) end, (40 - i) * 1000, "boss_vulnerability_loop");
			end;
			
			-- remove above objective
			bm:callback(function() bm:remove_objective("wh_dlc08_qb_monster_hunt_2_storm_count") end, 40000, "boss_vulnerability_loop");
			
			for i = 19, 1, -1 do
				bm:callback(function() bm:set_objective("wh_dlc08_qb_monster_hunt_2_storm_happening", i) end, (60 - i) * 1000, "boss_vulnerability_loop");
			end;
			
			-- remove above objective
			bm:callback(function() bm:remove_objective("wh_dlc08_qb_monster_hunt_2_storm_happening") end, 60000, "boss_vulnerability_loop");
		end;
		
		-- call first loop
		vulnerability_loop_func();
	
		-- call for subsequent loops
		bm:repeat_callback(
			function() 
				vulnerability_loop_func();
			end, 
			60000,
			"boss_vulnerability_loop"
		);

	end
);
-------ORDERS-------
gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 35000);
gb:message_on_time_offset("start_counter", 80000);
gb:message_on_time_offset("released_for_a_while", 120000);
gb:message_on_time_offset("released_for_a_while_1", 180000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:release_on_message("under_attack");
ga_ai_02:release_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.95);
-- ga_ai_01:message_on_casualties("hurt",0.10);



