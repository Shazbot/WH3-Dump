-- Mannfred Von Carstein, Intro, Hel Fenn, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
	gc:add_element(nil, nil, "gc_medium_absolute_hel_fenn_tower_01_to_absolute_hel_fenn_tower_02", 6000, false, false, false);
	
-- This stops the game playing the regular cutscene if the player has NOT brought Mannfred into the battle.
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_main_vmp_cha_mannfred_von_carstein_0", "wh_main_vmp_cha_mannfred_von_carstein_2", "wh_main_vmp_cha_mannfred_von_carstein_3", "wh_main_vmp_cha_mannfred_von_carstein_4") then
	gc:add_element("wh_qbattle_prelude_count_mannfred_von_carstein_pt_01_01", "wh_main_qb_vmp_mannfred_von_carstein_intro_battle_of_hel_fenn_pt_01", nil, 4000, true, false, false);
	gc:add_element("wh_qbattle_prelude_count_mannfred_von_carstein_pt_02", "wh_main_qb_vmp_mannfred_von_carstein_intro_battle_of_hel_fenn_pt_02", "gc_orbit_ccw_360_slow_commander_front_left_close_low_01", 4000, true, false, false);
	gc:add_element("wh_qbattle_prelude_count_mannfred_von_carstein_pt_03_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_intro_battle_of_hel_fenn_pt_03", "qb_final_position", 4000, true, false, false);
else

	gc:add_element(nil, nil, "gc_medium_absolute_hel_fenn_church_01_to_absolute_hel_fenn_church_02", 6000, false, false, false);
	gc:add_element(nil, nil, "qb_final_position", 6000, false, true, false);
end


gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_mannfred_von_carstein_intro_hint_objective");

-------ORDERS-------

