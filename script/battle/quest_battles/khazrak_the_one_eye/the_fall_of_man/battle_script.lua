load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_dlc03_bst_cha_khazrak_one_eye_0", "wh_dlc03_bst_cha_khazrak_one_eye_1") then
	gc:add_element(nil, nil, "gc_medium_absolute_fall_of_man_00", 14000, false, false, false);
	gc:add_element("Play_wh_dlc03_qb_bst_the_final_battle_pt_01", "wh_dlc03_qb_bst_the_final_battle_pt_01", "gc_medium_absolute_fall_of_man_01", 13000, false, false, false);
	gc:add_element("Play_wh_dlc03_qb_bst_the_final_battle_pt_02", "wh_dlc03_qb_bst_the_final_battle_pt_02", "gc_medium_absolute_fall_of_man_02", 15000, false, false, false);
	gc:add_element("Play_wh_dlc03_qb_bst_the_final_battle_pt_03", "wh_dlc03_qb_bst_the_final_battle_pt_03", "gc_orbit_90_medium_commander_front_left_extreme_high_01", 6000, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 6000, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);
else
	gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 6000, false, false, false);
end

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");

-------ARMY SETUP-------
-- ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
-- ga_player_ally=gb:get_army(gb:get_player_alliance_num(), 2,"bst_ally");	
-- ga_ai_karl = gb:get_army(gb:get_non_player_alliance_num(), 1,"karl");
-- ga_ai_louen = gb:get_army(gb:get_non_player_alliance_num(), 2,"louen");
-- ga_ai_side_1 = gb:get_army(gb:get_non_player_alliance_num(), 3,"side");
-- ga_ai_side_2 = gb:get_army(gb:get_non_player_alliance_num(), 4,"side_2");
-- ga_ai_back_1 = gb:get_army(gb:get_non_player_alliance_num(), 5,"back_1");
-- ga_ai_back_2 = gb:get_army(gb:get_non_player_alliance_num(), 6,"back_2");
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_player_ally = gb:get_army(gb:get_player_alliance_num(), "bst_ally");
ga_ai_karl = gb:get_army(gb:get_non_player_alliance_num(), "karl");
ga_ai_louen = gb:get_army(gb:get_non_player_alliance_num(), "louen");

ga_ai_side_1 = gb:get_army(gb:get_non_player_alliance_num(), "side");
ga_ai_side_2 = gb:get_army(gb:get_non_player_alliance_num(), "side_2");
ga_ai_back_1 = gb:get_army(gb:get_non_player_alliance_num(), "back_1");
ga_ai_back_2 = gb:get_army(gb:get_non_player_alliance_num(), "back_2");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh_main_emp_cha_karl_franz_1") then
	ga_ai_karl = gb:get_army(gb:get_non_player_alliance_num(), 1,"karl");
	ga_ai_louen = gb:get_army(gb:get_non_player_alliance_num(), 2,"louen");
else
	ga_ai_karl = gb:get_army(gb:get_non_player_alliance_num(), 2,"karl");
	ga_ai_louen = gb:get_army(gb:get_non_player_alliance_num(), 1,"louen");
end

if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh_main_emp_cha_karl_franz_1") then
	ga_ai_side_1 = gb:get_army(gb:get_non_player_alliance_num(), 1,"side");
	ga_ai_side_2 = gb:get_army(gb:get_non_player_alliance_num(), 1,"side_2");
	ga_ai_back_1 = gb:get_army(gb:get_non_player_alliance_num(), 2,"back_1");
	ga_ai_back_2 = gb:get_army(gb:get_non_player_alliance_num(), 2,"back_2");
else
	ga_ai_side_1 = gb:get_army(gb:get_non_player_alliance_num(), 2,"side");
	ga_ai_side_2 = gb:get_army(gb:get_non_player_alliance_num(), 2,"side_2");
	ga_ai_back_1 = gb:get_army(gb:get_non_player_alliance_num(), 1,"back_1");
	ga_ai_back_2 = gb:get_army(gb:get_non_player_alliance_num(), 1,"back_2");	
end
]]




-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc03_qb_final_battle_hint_objective");


-------ORDERS-------

ga_ai_karl:halt()
ga_ai_louen:halt()

--ga_ai_karl:attack_on_message("battle_started");
--ga_ai_louen:attack_on_message("battle_started");

ga_ai_karl:message_on_proximity_to_enemy("beastmen_approach_0", 350);
ga_ai_karl:message_on_under_attack("beastmen_approach_0");
ga_ai_louen:message_on_proximity_to_enemy("beastmen_approach_0", 350);
ga_ai_louen:message_on_under_attack("beastmen_approach_0");

ga_ai_karl:attack_on_message("beastmen_approach_0");
ga_ai_louen:attack_on_message("beastmen_approach_0");

ga_ai_karl:message_on_casualties("human_hurt",0.20);
ga_ai_louen:message_on_casualties("human_hurt",0.20);

ga_ai_karl:message_on_casualties("human_fall",0.90);
ga_ai_louen:message_on_casualties("human_fall",0.90);

--gb:message_on_time_offset("start_battle", 10);

ga_ai_side_1:reinforce_on_message("beastmen_approach_0",15000);
ga_ai_side_2:reinforce_on_message("beastmen_approach_0",15000);
ga_ai_side_1:message_on_any_deployed("artillery_arrived");
ga_ai_side_2:message_on_any_deployed("artillery_arrived");
gb:queue_help_on_message("artillery_arrived", "wh_dlc03_qb_final_battle_hint_artillery");
ga_ai_back_1:reinforce_on_message("human_hurt",15000);
ga_ai_back_2:reinforce_on_message("human_hurt",15000);
ga_ai_back_1:message_on_any_deployed("cavelry_arrived");
ga_ai_back_2:message_on_any_deployed("cavelry_arrived");
gb:queue_help_on_message("cavelry_arrived", "wh_dlc03_qb_final_battle_hint_reinforcements_pegsus");





