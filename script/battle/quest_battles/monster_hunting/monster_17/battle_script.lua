load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                true,                                       -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function
					ga_ai_enemy_main_boss:set_visible_to_all(true);
					ga_ai_enemy_main_forces:set_visible_to_all(true);
					ga_ai_enemy_illusion_boss_01:set_visible_to_all(true);
					ga_ai_enemy_illusion_forces_01:set_visible_to_all(true);
					ga_ai_enemy_illusion_boss_02:set_visible_to_all(true);
					ga_ai_enemy_illusion_forces_02:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_jabberslythe_001_1", "dlc27_nor_monstrous_arcanum_battle_jabberslythe_001", "army_pan_front_mid", 8000, true, false, true);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_jabberslythe_002_1", "dlc27_nor_monstrous_arcanum_battle_jabberslythe_002", "gc_orbit_90_medium_commander_front_right_close_low_01", 7000, true, false, false);
gc:add_element(nil, nil, "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_enemy_commander_front_close_low_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 5000, false, false, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
-----Jabberslythe

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());
--Enemy Forces & Boss
ga_ai_enemy_main_boss = gb:get_army(gb:get_non_player_alliance_num(), "boss_01");
ga_ai_enemy_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_force");
--Illusion Force 01
ga_ai_enemy_illusion_boss_01 = gb:get_army(gb:get_non_player_alliance_num(), "boss_02");
ga_ai_enemy_illusion_forces_01 = gb:get_army(gb:get_non_player_alliance_num(), "main_force_illusion_01");
--Illusion Force 02
ga_ai_enemy_illusion_boss_02 = gb:get_army(gb:get_non_player_alliance_num(), "boss_03");
ga_ai_enemy_illusion_forces_02 = gb:get_army(gb:get_non_player_alliance_num(), "main_force_illusion_02");

boss = ga_ai_enemy_main_boss.sunits:item(1);
boss = ga_ai_enemy_illusion_boss_01.sunits:item(1);
boss = ga_ai_enemy_illusion_boss_02.sunits:item(1);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--???
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_monster_hunt_17_objective_01");
gb:complete_objective_on_message("jabberslythe_boss_dead", "wh3_dlc27_qb_monster_hunt_17_objective_01");

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_monster_hunt_17_hint_01");
gb:queue_help_on_message("jabberslythe_boss_dead", "wh3_dlc27_qb_monster_hunt_17_hint_02");
gb:queue_help_on_message("jabberslythe_illusion_01_dead", "wh3_dlc27_qb_monster_hunt_17_hint_03");
gb:queue_help_on_message("jabberslythe_illusion_02_dead", "wh3_dlc27_qb_monster_hunt_17_hint_04");

-----OBJECTIVE 2-----
--Defeat the Enemy Forces
gb:set_objective_on_message("start", "wh3_dlc24_ksl_hex_01_objective_01");
gb:complete_objective_on_message("enemy_forces_dead", "wh3_dlc24_ksl_hex_01_objective_01");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
ga_ai_enemy_main_boss:set_visible_to_all(false);
ga_ai_enemy_main_forces:set_visible_to_all(false);
ga_ai_enemy_illusion_boss_01:set_visible_to_all(false);
ga_ai_enemy_illusion_forces_01:set_visible_to_all(false);
ga_ai_enemy_illusion_boss_02:set_visible_to_all(false);
ga_ai_enemy_illusion_forces_02:set_visible_to_all(false);

gb:message_on_time_offset("start", 200);
gb:message_on_time_offset("objective_01", 2500);
gb:message_on_time_offset("hint_01", 7500);

gb:message_on_all_messages_received("enemy_forces_dead", "jabberslythe_boss_dead", "main_force_dead", "illusion_01_force_dead", "illusion_02_force_dead")

gb:message_on_time_offset("end_battle", 2500, "enemy_forces_dead");

ga_player:force_victory_on_message("end_battle", 2500);

boss:set_stat_attribute("unbreakable", true);
boss:set_stat_attribute("unbreakable", true);
boss:set_stat_attribute("unbreakable", true);

--------------------------------
----------ENEMY ORDERS----------
--------------------------------
-- ga_ai_enemy_main_boss.sunits:take_control()
-- ga_ai_enemy_main_forces.sunits:take_control()

ga_ai_enemy_main_boss:rush_on_message("start");
ga_ai_enemy_main_boss:message_on_commander_death("jabberslythe_boss_dead");

ga_ai_enemy_main_forces:attack_on_message("start");
ga_ai_enemy_main_forces:message_on_rout_proportion("main_force_dead", 0.95);

gb:add_listener(
	"jabberslythe_boss_dead",
	function()
		if ga_ai_enemy_illusion_boss_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_boss_01.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_enemy_illusion_forces_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_forces_01.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
		
		if ga_ai_enemy_illusion_boss_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_boss_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
		
		if ga_ai_enemy_illusion_forces_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_forces_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		gb:remove_listener("jabberslythe_illusion_01_dead");
		gb:remove_listener("jabberslythe_illusion_02_dead");
	end,
	true
);

ga_ai_enemy_illusion_boss_01:rush_on_message("start");
ga_ai_enemy_illusion_boss_01:message_on_commander_death("jabberslythe_illusion_01_dead");

ga_ai_enemy_illusion_forces_01:attack_on_message("start");

gb:add_listener(
	"jabberslythe_illusion_01_dead",
	function()
		if ga_ai_enemy_illusion_forces_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_forces_01.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_enemy_main_boss.sunits:are_any_active_on_battlefield() == true then
			gb.sm:trigger_message("illusion_01_defeated");
		end;
	end,
	true
);

ga_ai_enemy_illusion_boss_02:rush_on_message("start");
ga_ai_enemy_illusion_boss_02:message_on_commander_death("jabberslythe_illusion_02_dead");

ga_ai_enemy_illusion_forces_02:attack_on_message("start");

gb:add_listener(
	"jabberslythe_illusion_02_dead",
	function()
		if ga_ai_enemy_illusion_forces_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_enemy_illusion_forces_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_enemy_main_boss.sunits:are_any_active_on_battlefield() == true then
			gb.sm:trigger_message("illusion_02_defeated");
		end;
	end,
	true
);