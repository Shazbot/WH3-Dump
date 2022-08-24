load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                     			-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_dlc08_nor_cha_wulfrik_0", "wh_dlc08_nor_cha_wulfrik_1","wh_dlc08_nor_cha_wulfrik_2","wh_dlc08_nor_cha_wulfrik_3") then
	if gb:get_army(gb:get_non_player_alliance_num(1), 1):get_script_name() == "khorne" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Hound_pt_01", "Nor_Wulfrik_Final_Battle_vs_Hound_pt_01", nil, 10000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Hound_pt_02", "Nor_Wulfrik_Final_Battle_vs_Hound_pt_02", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 7000, false, false, false);
		gc:add_element(nil, nil, nil, 3800, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Hound_pt_03", "Nor_Wulfrik_Final_Battle_vs_Hound_pt_03", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "nurgle" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Crow_pt_01", "Nor_Wulfrik_Final_Battle_vs_Crow_pt_01", nil, 10000, false, false, false);
		gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 3000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Crow_pt_02", "Nor_Wulfrik_Final_Battle_vs_Crow_pt_02", nil, 7100, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Crow_pt_03", "Nor_Wulfrik_Final_Battle_vs_Crow_pt_03", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "slaanesh" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 1000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Serpent_pt_01", "Nor_Wulfrik_Final_Battle_vs_Serpent_pt_01", nil, 12900, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Serpent_pt_02", "Nor_Wulfrik_Final_Battle_vs_Serpent_pt_02", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 9600, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Serpent_pt_03", "Nor_Wulfrik_Final_Battle_vs_Serpent_pt_03", nil, 6100, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Serpent_pt_04", "Nor_Wulfrik_Final_Battle_vs_Serpent_pt_04", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	else 
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 1000, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Eagle_pt_01", "Nor_Wulfrik_Final_Battle_vs_Eagle_pt_01", nil, 12100, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Eagle_pt_02", "Nor_Wulfrik_Final_Battle_vs_Eagle_pt_02", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 9300, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Eagle_pt_03", "Nor_Wulfrik_Final_Battle_vs_Eagle_pt_03", nil, 3500, false, false, false);
		gc:add_element("Nor_Wulfrik_Final_Battle_vs_Eagle_pt_04", "Nor_Wulfrik_Final_Battle_vs_Eagle_pt_04", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	end
elseif gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_dlc08_nor_cha_throgg_0") then
	if gb:get_army(gb:get_non_player_alliance_num(1), 1):get_script_name() == "khorne" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Hound_pt_01", "Nor_Throgg_Final_Battle_vs_Hound_pt_01", nil, 7000, false, false, false);
		gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 6000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Hound_pt_02", "Nor_Throgg_Final_Battle_vs_Hound_pt_02", nil, 7100, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "nurgle" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Crow_pt_01", "Nor_Throgg_Final_Battle_vs_Crow_pt_01", nil, 6600, false, false, false);
		gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Crow_pt_02", "Nor_Throgg_Final_Battle_vs_Crow_pt_02", nil, 7700, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Crow_pt_03", "Nor_Throgg_Final_Battle_vs_Crow_pt_03", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "slaanesh" then
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Serpent_pt_01", "Nor_Throgg_Final_Battle_vs_Serpent_pt_01", nil, 7900, false, false, false);
		gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Serpent_pt_02", "Nor_Throgg_Final_Battle_vs_Serpent_pt_02", nil, 9500, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Serpent_pt_03", "Nor_Throgg_Final_Battle_vs_Serpent_pt_03", "qb_final_position_short", 6000, false, false, false);
		gc:add_element(nil,nil, nil, 7000, true, true, false);
	else 
		gc:add_element(nil, nil, "gc_medium_absolute_conflict_of_gods_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Eagle_pt_01", "Nor_Throgg_Final_Battle_vs_Eagle_pt_01", nil, 8600, false, false, false);
		gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 3000, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Eagle_pt_02", "Nor_Throgg_Final_Battle_vs_Eagle_pt_02", nil, 9400, false, false, false);
		gc:add_element("Nor_Throgg_Final_Battle_vs_Eagle_pt_03", "Nor_Throgg_Final_Battle_vs_Eagle_pt_03", "qb_final_position_short", 4000, false, false, false);
		gc:add_element(nil,nil, nil, 3000, true, true, false);
	end
else
	gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 6000, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 6000, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);
end





gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(),"beastmen" );
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(),"norsca");

if gb:get_army(gb:get_non_player_alliance_num(1), 1):get_script_name() == "khorne" then
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"khorne");
	gb:queue_help_on_message("battle_started", "wh_dlc08_qb_final_battle_khorne");
elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "nurgle" then
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"nurgle");
	gb:queue_help_on_message("battle_started", "wh_dlc08_qb_final_battle_nurgle");
elseif gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "slaanesh" then
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"slaanesh");
	gb:queue_help_on_message("battle_started", "wh_dlc08_qb_final_battle_slaanesh");
else 
	ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"tzeentch");
	gb:queue_help_on_message("battle_started", "wh_dlc08_qb_final_battle_tzeentch");
end




-------OBJECTIVES-------
gb:queue_help_on_message("release_boss", "wh_dlc08_qb_final_battle_reinforcement_0");
gb:queue_help_on_message("released_for_a_while", "wh_dlc08_qb_final_battle_reinforcement_1");
gb:remove_objective_on_message("shield_off", "wh_dlc08_final_battle_hold_on");
gb:set_objective_on_message("deployment_started", "wh_dlc08_final_battle_hold_on");
gb:set_objective_on_message("shield_off", "wh_main_qb_objective_attack_defeat_army");
gb:queue_help_on_message("shield_off", "wh_dlc08_final_battle_shield_off");

-------ORDERS-------
gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 220000);
gb:message_on_time_offset("shield_off", 240000);
gb:message_on_time_offset("released_for_a_while", 260000);
ga_ai_01:message_on_casualties("hurt",0.5);
ga_ai_02:reinforce_on_message("release_boss",1000);
ga_ai_03:reinforce_on_message("released_for_a_while",1000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




