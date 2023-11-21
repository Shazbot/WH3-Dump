load_script_libraries();

local gc = generated_cutscene:new(true);


--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_ccw_360_slow_commander_back_right_close_low_01", 16000, true, false, false);
gc:add_element("wh_dlc07_qb_Bret_Leoncoeur_Sword_of_Couronne_PT1", "wh_dlc07_qb_brt_louen_sword_of_couronne_pt_01", nil, 16000, false, true, false);
gc:add_element("wh_dlc07_qb_Bret_Leoncoeur_Sword_of_Couronne_PT2", "wh_dlc07_qb_brt_louen_sword_of_couronne_pt_02", "wh_dlc07_qb_louen_sword_of_couronne_00", 15000, false, false, false);
gc:add_element("wh_dlc07_qb_Bret_Leoncoeur_Sword_of_Couronne_PT3", "wh_dlc07_qb_brt_louen_sword_of_couronne_pt_03", "wh_dlc07_qb_louen_sword_of_couronne_03", 13000, false, false, false);




gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);
--ga_ai_01:set_visible_to_all(true);
-- local battle_stage=0;
-- local shape_points={v(45,265),v(45,215),v(-5,215),v(-5,265)};
-- local duel_area=convex_area:new(shape_points);
-- local mountain_line={v(0,0),v(1,1)};
-- local bool_mountain_crossed=false;

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_1");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_2");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_2_reinforcements");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh_main_grn_cha_orc_warboss_2") then
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);
else
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 3);	
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1);
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 2);
end
]]







-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_dlc07_qb_brt_louen_sword_of_couronne_01");
gb:queue_help_on_message("louen_approach", "wh_dlc07_qb_brt_louen_sword_of_couronne_02");
gb:queue_help_on_message("beware_there_be_goblins", "wh_dlc07_qb_brt_louen_sword_of_couronne_03");
gb:queue_help_on_message("hoppers", "wh_dlc07_qb_brt_louen_sword_of_couronne_04");



-------ORDERS-------

ga_ai_01:attack_on_message("battle_started",100);
ga_ai_01:message_on_casualties("orcs_weak",0.5);
ga_ai_01:message_on_proximity_to_enemy("beware_there_be_goblins",100);

ga_ai_02:halt("battle_started");
ga_ai_02:message_on_proximity_to_enemy("beware_there_be_goblins",150);
ga_ai_02:message_on_proximity_to_enemy("louen_approach",50);
ga_ai_02:release_on_message("louen_approach");
ga_ai_02:release_on_message("orcs_weak",30000);
gb:message_on_time_offset("goblin_move", 300000);
ga_ai_02:release_on_message("goblin_move");

ga_ai_03:reinforce_on_message ("louen_approach",60000);
ga_ai_03:message_on_any_deployed ("hoppers");




