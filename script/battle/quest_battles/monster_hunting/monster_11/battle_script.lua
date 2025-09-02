load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering wh2_dlc10.battle.speech.nor.battle_hellpit.001"); bm:queue_advisor("wh2_dlc10.battle.speech.nor.battle_hellpit.001") end, 2000); 
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_dlc10_hellpit_00", 18000, true, false, false);


gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");

-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);


stormvermin_units = ga_ai_01.sunits:get_sunit_by_type("wh2_main_skv_inf_stormvermin_0")


-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_11_hint_objective");
gb:queue_help_on_message("hint_revival", "wh_dlc08_qb_monster_hunt_11_hint_boss_ability");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_11_hint_boss_gone");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_11_0");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_11_1");

-------ORDERS-------

gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 15000);
gb:message_on_time_offset("hint_revival", 150000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:attack_on_message("under_attack");
ga_ai_02:attack_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.95);
-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




if ga_ai_02 then
	bm:watch(
		function()
			return is_shattered_or_dead(ga_ai_02.sunits:item(1))
		end,
		0,
		function()
			bm:out("*** boss is shattered or dead! ***")
			bm:complete_objective("wh_dlc08_qb_monster_hunt_objective");
			bm:complete_objective("wh_dlc08_qb_monster_hunt_objective_11_1");
			gb.sm:trigger_message("boss_dead")
		end
	)
end

if ga_ai_01 then 
		bm:watch(
		function()
			return is_shattered_or_dead(ga_ai_01.sunits)
		end,
		0,
		function()
			bm:out("*** units are shattered or dead! ***")
			bm:complete_objective("wh_dlc08_qb_monster_hunt_objective_11_0");
			gb.sm:trigger_message("stormvermin_units_dead")
		end
	)
end 	

gb:message_on_all_messages_received("mission_complete", "boss_dead", "stormvermin_units_dead");
ga_player_01:force_victory_on_message("mission_complete", 10000); 