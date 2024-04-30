-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan the Maggot Lord
-- Black Cleaver ("Gates of Nuln")
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      			-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
local sfx_cutscene_sweetener_play = new_sfx("Play_Movie_WH3_DLC25_QB_Tamurkhan_Gates_Of_Nuln", true, false)
local sfx_cutscene_sweetener_stop = new_sfx("Stop_Movie_WH3_DLC25_QB_Tamurkhan_Gates_Of_Nuln", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	
	local cam = bm:camera();

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/the_gates_of_nuln_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
		end, 
		200
	);	

	enemy_starting_garrison_attack_emp_1.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_war_wagon_left.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_war_wagon_right.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_left_bridge_defenders.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_left_bridge_defenders_spear.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_left_bridge_defenders_cross.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_right_bridge_defenders.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_right_bridge_defenders_cross.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_right_bridge_defenders_spear.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_centre_bridge_defenders.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_artillery_detachment_emp_3.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_artillery_guard_emp.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_centre_bridge_defenders_eng.sunits:set_always_visible_no_hidden_no_leave_battle(false); -- Army visible during cutscene and deployment
	enemy_centre_cav.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment
	enemy_centre_tank.sunits:set_always_visible_no_hidden_no_leave_battle(true); -- Army visible during cutscene and deployment

 -------------------------------------------------------------------------------------------------
 ---------------------------------------- VO & SUBS  & Audio -------------------------------------
 -------------------------------------------------------------------------------------------------
 
    cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_play) end, 100)
	
	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_01"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_02"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_03"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_04"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_05"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_05", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_06", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_06"));
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_06", false, true);
			end
	);

	--cutscene_intro:action(function() cam:fade(true, 1) end, 38400);

	cutscene_intro:start();

end;

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

-- NOTE: Left = East on the map, Right = West on the map
-- Present Josh doesn't know why past Josh did it this way.


ga_player = gb:get_army(gb:get_player_alliance_num(), 1); -- Player's army
ga_player_ally = gb:get_army(gb:get_player_alliance_num(),"player_ally"); -- Beastmen allied reinforcements

enemy_left_ambushers = gb:get_army(gb:get_non_player_alliance_num(),"left_ambush"); -- Ambushers that hide in the trees on the left side of the map
enemy_right_ambushers = gb:get_army(gb:get_non_player_alliance_num(),"right_ambush"); -- Ambushers that hide in the trees on the right side of the map
late_enemy_left_ambushers = gb:get_army(gb:get_non_player_alliance_num(),"late_left_ambush"); -- Outriders that will attack when the player gets closer to the bridge
late_enemy_right_ambushers = gb:get_army(gb:get_non_player_alliance_num(),"late_right_ambush"); -- Outriders that will attack when the player gets closer to the bridge

enemy_starting_garrison_attack_emp_1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_attack_1"); -- Deployed garrison army, attacks the player immediately.
enemy_starting_garrison_attack_emp_1.sunits:prevent_rallying_if_routing(true, false, false) -- Prevents the starting enemy army from rallying once routed.

enemy_war_wagon_left = gb:get_army(gb:get_non_player_alliance_num(),"left_wagon");
enemy_war_wagon_right = gb:get_army(gb:get_non_player_alliance_num(),"right_wagon");

enemy_left_bridge_defenders = gb:get_army(gb:get_non_player_alliance_num(),"left_bridge");
enemy_left_bridge_defenders_spear = gb:get_army(gb:get_non_player_alliance_num(),"left_bridge_spear");
enemy_left_bridge_defenders_cross = gb:get_army(gb:get_non_player_alliance_num(),"left_bridge_def");
enemy_right_bridge_defenders = gb:get_army(gb:get_non_player_alliance_num(),"right_bridge");
enemy_right_bridge_defenders_spear = gb:get_army(gb:get_non_player_alliance_num(),"right_bridge_spear");
enemy_right_bridge_defenders_cross = gb:get_army(gb:get_non_player_alliance_num(),"right_bridge_def");
enemy_centre_bridge_defenders = gb:get_army(gb:get_non_player_alliance_num(),"centre_bridge");
enemy_centre_bridge_defenders_eng = gb:get_army(gb:get_non_player_alliance_num(),"centre_bridge_eng");
enemy_centre_cav = gb:get_army(gb:get_non_player_alliance_num(),"centre_cav");
enemy_centre_tank = gb:get_army(gb:get_non_player_alliance_num(),"centre_tank");

enemy_artillery_detachment_emp_3 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_artillery_1"); -- (Optional objective) Artillery army, routing them will trigger beastmen reinforcements
enemy_artillery_guard_emp = gb:get_army(gb:get_non_player_alliance_num(),"enemy_artillery_guard"); -- Units guarding the artillery

enemy_main_garrison_emp = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main"); -- Main Reinforcing Army
enemy_main_garrison_emp_com = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main_com"); -- Main Reinforcing army commander


-------------------------------------------------------------------------------------------------
------------------------------------------- WAYPOINTS -------------------------------------------
-------------------------------------------------------------------------------------------------


attacker_right_waypoint = v(-146.2, 188.5, 416.7) -- Coordinates for the attackers preventing inactive AI in the event of flanking
attacker_left_waypoint = v(198.9, 199.6, 423.4) -- Coordinates for the attackers preventing inactive AI in the event of flanking
east_waypoint = v(328.7, 238.4, 511.5) -- Coordinates to release the forward attackers and hidden cavalry in case the player flanks from the east side of the map.

left_bridge_entrance_waypoint = v(136.3, 196.8, 235.8) -- Coordinates for the left bridge on the player side
right_bridge_entrance_waypoint = v(-124.4, 199.0, 183.1) -- Coordinates for the right bridge on the player side
right_bridge_enemy_side_waypoint = v(-137.3, 200.9, 50.1) -- Coordinates for the right bridge on the enemy side
left_bridge_enemy_side_waypoint = v(159.6, 202.8, 55.3) -- Coordinates for the left bridge on the enemy side
artillery_waypoint = v(-197, 209.9, -165.4) -- Coordinates for the artillery placement
commander_entry_waypoint = v(83.8, 207.6, -275.5) -- Coordinates for the artillery placement

beastmen_reinforcement_waypoint = v(463.2, 205.1, -146.5) -- Coordinates for the beastmen reinforcement point, the bridge defenders will react accordingly.
east_bridge_flank_waypoint = v(273.8, 206.7, -55.3) -- Coordinates for the east bridge, if the beastmen reinforcements flank them they will react.

--- These waypoints exist for the AI to react to summons. ---

attacker_guard_waypoint_left = v(-55.5, 189.1, 355.0)
attacker_guard_waypoint_centre = v(15.3, 190.6, 370.3)
attacker_guard_waypoint_right = v(109.3, 191.4, 364.0)

artillery_rear_guard_waypoint = v(-192.1, 209.5, -237.2)
right_rear_guard_waypoint = v(155.9, 206.7, -1.7)
centre_rear_guard_waypoint = v(-10.5, 206.7, -42.6)

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

player_ally = bm:get_spawn_zone_collection_by_name("player_ally"); -- Beastmen Allied Reinforcement Zone

enemy_main = bm:get_spawn_zone_collection_by_name("emp_rein"); -- Main Garrison Reinforcement Zone
enemy_main_com = bm:get_spawn_zone_collection_by_name("emp_rein");

ga_player_ally:assign_to_spawn_zone_from_collection_on_message("start", player_ally, false);
enemy_main_garrison_emp:assign_to_spawn_zone_from_collection_on_message("start", enemy_main, false);
enemy_main_garrison_emp_com:assign_to_spawn_zone_from_collection_on_message("start", enemy_main_com, false);

enemy_main_garrison_emp_com.sunits:set_stat_attribute("unbreakable", true)

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------- ORDERS ---------------------------------------------
-- -------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 1000);

enemy_starting_garrison_attack_emp_1:message_on_proximity_to_enemy("ambush_attack", 100) -- When the player is close to the attacking army, order the ambushers to attack
enemy_starting_garrison_attack_emp_1:message_on_proximity_to_enemy("att_attack", 100) -- When the player is close to the attacking army, order the attackers to attack

enemy_left_ambushers:attack_force_on_message("ambush_attack", ga_player, 1000); -- Outriders w Grenade Launchers attack the player
enemy_right_ambushers:attack_force_on_message("ambush_attack", ga_player, 1000); -- Outriders w Grenade Launchers attack the player
enemy_starting_garrison_attack_emp_1:attack_force_on_message("att_attack", ga_player, 1000); -- Forward army attacks

ga_player:message_on_proximity_to_position("late_right_ambush_attack", right_bridge_entrance_waypoint, 150)
ga_player:message_on_proximity_to_position("late_left_ambush_attack", left_bridge_entrance_waypoint, 150)
late_enemy_left_ambushers:attack_force_on_message("late_left_ambush_attack", ga_player, 1000);
late_enemy_right_ambushers:attack_force_on_message("late_right_ambush_attack", ga_player, 1000);

enemy_war_wagon_left:message_on_proximity_to_enemy("left_fallback", 100)
enemy_war_wagon_left:move_to_position_on_message("left_fallback", v(-22, 194, 209))
enemy_war_wagon_right:message_on_proximity_to_enemy("right_fallback", 100)
enemy_war_wagon_right:move_to_position_on_message("right_fallback", v(95.2, 192, 242))

enemy_artillery_detachment_emp_3:message_on_proximity_to_enemy("cross_att", 50) -- if the enemy is close to the artillery, order the crossbowmen on the left bridge to defend
enemy_left_bridge_defenders_cross:attack_on_message("cross_att");
enemy_centre_bridge_defenders:attack_on_message("cross_att");

ga_player:message_on_proximity_to_position("att_attack", attacker_right_waypoint, 100)
ga_player:message_on_proximity_to_position("ambush_attack", attacker_right_waypoint, 100)
ga_player:message_on_proximity_to_position("att_attack", attacker_left_waypoint, 100)
ga_player:message_on_proximity_to_position("ambush_attack", attacker_left_waypoint, 100)
ga_player:message_on_proximity_to_position("att_attack", east_waypoint, 100)
ga_player:message_on_proximity_to_position("ambush_attack", east_waypoint, 100)

ga_player:message_on_proximity_to_position("centre_cav_attack", right_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("centre_cav_attack", left_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("right_cross_attack", left_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("left_cross_attack", right_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("centre_tank_attack", right_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("centre_tank_attack", left_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("centre_attack", right_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("centre_attack", left_bridge_enemy_side_waypoint, 50)
ga_player:message_on_proximity_to_position("artillery_guard_defend", artillery_waypoint, 50)
enemy_main_garrison_emp_com:message_on_proximity_to_position("comm_attack", commander_entry_waypoint, 100)
ga_player:message_on_proximity_to_position("left_cross_guard", left_bridge_entrance_waypoint, 50)
ga_player:message_on_proximity_to_position("right_cross_guard", right_bridge_entrance_waypoint, 50)

enemy_centre_cav:attack_force_on_message("centre_cav_attack", ga_player, 1000);
enemy_centre_tank:attack_force_on_message("centre_tank_attack", ga_player, 1000);
--enemy_left_bridge_defenders_cross:attack_force_on_message("left_cross_attack", ga_player, 1000);
enemy_right_bridge_defenders_cross:attack_force_on_message("right_cross_attack", ga_player, 1000);
enemy_centre_bridge_defenders:attack_force_on_message("centre_attack", ga_player, 1000);
enemy_artillery_guard_emp:defend_on_message("artillery_guard_defend", -197, -165.4, 100, 1000)
enemy_left_bridge_defenders_cross:defend_on_message("right_cross_guard", -202, 53.14, 50, 1000)
enemy_right_bridge_defenders_cross:defend_on_message("left_cross_guard", 204.7, 37.7, 50, 1000)

ga_player_ally:message_on_proximity_to_position("centre_attack_beastmen", beastmen_reinforcement_waypoint, 100) -- Beastmen reinforcement entry
enemy_centre_bridge_defenders:attack_force_on_message("centre_attack_beastmen", ga_player_ally, 1000); -- Centre units will move to intercept the beastmen reinforcements if possible
enemy_centre_cav:attack_force_on_message("centre_attack_beastmen", ga_player_ally, 1000); -- Centre units will move to intercept the beastmen reinforcements if possible
enemy_centre_tank:attack_force_on_message("centre_attack_beastmen", ga_player_ally, 1000); -- Centre units will move to intercept the beastmen reinforcements if possible
enemy_centre_bridge_defenders_eng:attack_force_on_message("centre_attack_beastmen", ga_player_ally, 1000); -- Centre units will move to intercept the beastmen reinforcements if possible

ga_player_ally:message_on_proximity_to_position("east_abandon", east_bridge_flank_waypoint, 50) -- Beastmen reinforcement army is within 50m of this waypoint
enemy_right_bridge_defenders:attack_force_on_message("east_abandon", ga_player_ally, 1000); -- Handgunner moves to intercept
enemy_right_bridge_defenders_cross:attack_force_on_message("east_abandon", ga_player_ally, 1000); -- Crossbow men move to intercept.

enemy_left_bridge_defenders:attack_force_on_message("right_rout", ga_player, 1000); -- If the defenders of the right bridge has routed, left defenders will abandon their position and attack
enemy_left_bridge_defenders_spear:attack_force_on_message("right_rout", ga_player, 1000); -- If the defenders of the right bridge has routed, left defenders will abandon their position and attack
enemy_left_bridge_defenders_cross:attack_force_on_message("right_rout", ga_player, 1000); -- If the defenders of the right bridge has routed, left defenders will abandon their position and attack
enemy_right_bridge_defenders:attack_force_on_message("left_rout", ga_player, 1000); -- If the defenders of the left bridge has routed, right defenders will abandon their position and attack
enemy_right_bridge_defenders_spear:attack_force_on_message("left_rout", ga_player, 1000); -- If the defenders of the left bridge has routed, right defenders will abandon their position and attack
enemy_right_bridge_defenders_cross:attack_force_on_message("left_rout", ga_player, 1000); -- If the defenders of the left bridge has routed, right defenders will abandon their position and attack

--- These orders are for reactions to summoned units ---

enemy_starting_garrison_attack_emp_1:message_on_proximity_to_enemy("ambush_attack", 100) -- When the player is close to the attacking army, order the ambushers to attack
enemy_starting_garrison_attack_emp_1:message_on_proximity_to_enemy("att_attack", 100) -- When the player is close to the attacking army, order the attackers to attack

ga_player:message_on_proximity_to_position("att_attack", attacker_guard_waypoint_left, 150);
ga_player:message_on_proximity_to_position("att_attack", attacker_guard_waypoint_centre, 150);
ga_player:message_on_proximity_to_position("att_attack", attacker_guard_waypoint_right, 150);

ga_player:message_on_proximity_to_position("ambush_attack", attacker_guard_waypoint_left, 150);
ga_player:message_on_proximity_to_position("ambush_attack", attacker_guard_waypoint_centre, 150);
ga_player:message_on_proximity_to_position("ambush_attack", attacker_guard_waypoint_right, 150);

ga_player:message_on_proximity_to_position("artillery_guard_defend", artillery_rear_guard_waypoint, 150);
enemy_artillery_guard_emp:defend_on_message("artillery_guard_defend", -197, -165.4, 100, 1000);

ga_player:message_on_proximity_to_position("left_cross_guard", right_rear_guard_waypoint, 50);
enemy_left_bridge_defenders_cross:defend_on_message("left_cross_guard", -202, 53.14, 50, 1000);

ga_player:message_on_proximity_to_position("centre_guard_defend", centre_rear_guard_waypoint, 150);
enemy_centre_bridge_defenders:defend_on_message("centre_guard_defend", -10.5, -42.6, 50, 1000);
enemy_centre_bridge_defenders_eng:defend_on_message("centre_guard_defend", -10.5, -42.6, 50, 1000);
enemy_centre_cav:defend_on_message("centre_guard_defend", -10.5, -42.6, 50, 1000);

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- UNIT TELEPORTS -----------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Attacking Garrison Swordsmen

enemy_starting_garrison_attack_emp_1.sunits:item(1).uc:teleport_to_location(v(-37.83, 395.43), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(2).uc:teleport_to_location(v(-63.33, 395.82), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(3).uc:teleport_to_location(v(107.92, 392.09), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(4).uc:teleport_to_location(v(85.38, 392.52), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(5).uc:teleport_to_location(v(-10.76, 410.33), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(6).uc:teleport_to_location(v(13.26, 410.13), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(7).uc:teleport_to_location(v(37.28, 409.92), 1, 20)
enemy_starting_garrison_attack_emp_1.sunits:item(8).uc:teleport_to_location(v(60.56, 409.72), 1, 20)
enemy_war_wagon_left.sunits:item(1).uc:teleport_to_location(v(-58.33, 370.82), 1, 40) -- War Wagons
enemy_war_wagon_right.sunits:item(1).uc:teleport_to_location(v(98.0, 371.72), 1, 40) -- War Wagons
enemy_left_ambushers.sunits:item(1).uc:teleport_to_location(v(241.54, 355.39), 1, 40) -- Outrider Grenadiers in the trees
enemy_right_ambushers.sunits:item(1).uc:teleport_to_location(v(-225.22, 404.30), 1, 40) -- Outrider Grenadiers in the trees
late_enemy_left_ambushers.sunits:item(1).uc:teleport_to_location(v(320.40, 365.61), 1, 40) -- Outriders in the trees
late_enemy_left_ambushers.sunits:item(2).uc:teleport_to_location(v(293.46, 338.44), 1, 40) -- Outriders in the trees
late_enemy_right_ambushers.sunits:item(1).uc:teleport_to_location(v(-221.85, 256.50), 1, 40) -- Outriders in the trees
late_enemy_right_ambushers.sunits:item(2).uc:teleport_to_location(v(-231.70, 285.26), 1, 40) -- Outriders in the trees

-- Centre Bridge Defenders

enemy_centre_bridge_defenders_eng.sunits:item(1).uc:teleport_to_location(v(-10.48, -11.60), 12, 1) -- Engineer
enemy_centre_bridge_defenders.sunits:item(1).uc:teleport_to_location(v(-34.83, 2.73), 0, 20) -- Greatswords
enemy_centre_bridge_defenders.sunits:item(2).uc:teleport_to_location(v(13.54, 1.65), 2, 20) -- Greatswords

enemy_centre_cav.sunits:item(1).uc:teleport_to_location(v(-66.20, -27.17), 1.1, 20) -- Empire Knights
enemy_centre_cav.sunits:item(2).uc:teleport_to_location(v(46.04, -28.36), 1.1, 20) -- Empire Knights
enemy_centre_tank.sunits:item(1).uc:teleport_to_location(v(-9.41, 3.77), 359.8, 20) -- Steam Tank

--enemy_centre_tank.sunits:item(1).uc:teleport_to_location(v(-9.41, 0.77), 359.8, 20) -- Steam Tank

-- Left Bridge Defenders

enemy_left_bridge_defenders_spear.sunits:item(1).uc:teleport_to_location(v(-148.02, 72.73), 4, 20) -- Spearmen w/ shields
enemy_left_bridge_defenders_spear.sunits:item(2).uc:teleport_to_location(v(-123.04, 71.23), 3, 20) -- Spearmen w/ shields
enemy_left_bridge_defenders_cross.sunits:item(1).uc:teleport_to_location(v(-202.18, 53.14), 39, 20) -- Crossbowmen
enemy_left_bridge_defenders_cross.sunits:item(2).uc:teleport_to_location(v(-187.80, 41.34), 39, 20) -- Crossbowmen
enemy_left_bridge_defenders.sunits:item(1).uc:teleport_to_location(v(-84.01, 45.34), -12, 20) -- Handgunners

-- Right Bridge Defenders

enemy_right_bridge_defenders_spear.sunits:item(1).uc:teleport_to_location(v(170.98, 78.72), 351, 20) -- Spearmen w/ shields
enemy_right_bridge_defenders_spear.sunits:item(2).uc:teleport_to_location(v(146.72, 76.17), 356, 20) -- Spearmen w/ shields
enemy_right_bridge_defenders_cross.sunits:item(1).uc:teleport_to_location(v(204.7, 37.7), -39, 20) -- Crossbowmen
enemy_right_bridge_defenders_cross.sunits:item(2).uc:teleport_to_location(v(164.4, 34.4), 1, 20) -- Crossbowmen
enemy_right_bridge_defenders.sunits:item(1).uc:teleport_to_location(v(123.8, 50.82), 22, 20) -- Handgunners

-- Artillery detachment

enemy_artillery_detachment_emp_3.sunits:item(1).uc:teleport_to_location(v(-225.06, -170.54), 19.4, 20) -- Hellstorm
enemy_artillery_detachment_emp_3.sunits:item(2).uc:teleport_to_location(v(-204.37, -177.74), 19.4, 20) -- Hellstorm
enemy_artillery_detachment_emp_3.sunits:item(3).uc:teleport_to_location(v(-183.68, -184.95), 19.4, 20) -- Hellstorm

enemy_artillery_guard_emp.sunits:item(1).uc:teleport_to_location(v(-192.96, -146.45), 19.4, 20) -- Halberdier
enemy_artillery_guard_emp.sunits:item(2).uc:teleport_to_location(v(-219.82, -136.18), 19.4, 20) -- Swordsmen
enemy_artillery_guard_emp.sunits:item(3).uc:teleport_to_location(v(-165.15, -157.78), 19.4, 20) -- Swordsmen
enemy_artillery_guard_emp.sunits:item(4).uc:teleport_to_location(v(-229.62, -197.79), 19.4, 20) -- Handgunners
enemy_artillery_guard_emp.sunits:item(5).uc:teleport_to_location(v(-185.12, -207.74), 19.4, 20) -- Handgunners
enemy_artillery_guard_emp.sunits:item(6).uc:teleport_to_location(v(-207.37, -202.76), 19.4, 20) -- Handgunners

----------------------------------------------                ------------------------------------------------------
---------------------------------------------- MAIN OBJECTIVE ------------------------------------------------------
----------------------------------------------                ------------------------------------------------------

gb:message_on_time_offset("starting_message", 5000) -- Starting message, tells the player what to do
gb:queue_help_on_message("starting_message", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_1_hint")

gb:set_objective_on_message("starting_message", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_1") -- Kill the defending garrison
gb:set_objective_on_message("starting_message", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_tamurkhan_alive") -- Keep Tamurkhan alive

enemy_centre_bridge_defenders:message_on_rout_proportion("centre_rout", 0.6) -- When 80% of this force has routed, fire the message
enemy_left_bridge_defenders:message_on_rout_proportion("left_rout", 0.6) -- When 80% of this force has routed, fire the message
enemy_right_bridge_defenders:message_on_rout_proportion("right_rout", 0.6) -- When 80% of this force has routed, fire the message

gb:message_on_all_messages_received("enemy_main_rein", "centre_rout", "left_rout", "right_rout") -- When the left, right, and centre bridge defenders have routed trigger the main reinforcements

enemy_main_garrison_emp:reinforce_on_message("enemy_main_rein", 1000) -- Main garrison reinforcements
enemy_main_garrison_emp_com:reinforce_on_message("enemy_main_rein", 50000) -- Commander enters the field after the main force does

enemy_main_garrison_emp:attack_force_on_message("enemy_main_rein", ga_player, 2000);
enemy_main_garrison_emp_com:attack_force_on_message("comm_attack", ga_player, 2000);

gb:queue_help_on_message("enemy_main_rein", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_2_hint_1") -- Main garrison message
gb:complete_objective_on_message("enemy_main_rein", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_1", 1000) -- Sets the objective as complete
gb:set_objective_on_message("enemy_main_rein", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_2", 50000) -- New objective

enemy_main_garrison_emp_com:message_on_commander_dead_or_routing("commander_dead") -- On death, message is created for the garrison commander
gb:queue_help_on_message("commander_dead", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_2_success") -- Success message
gb:complete_objective_on_message("commander_dead", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_objective_2", 1000) -- Sets the objective as complete

enemy_main_garrison_emp_com:rout_over_time_on_message("commander_dead", 15000) -- Enemy slowly routs after the commander's death
enemy_main_garrison_emp:rout_over_time_on_message("commander_dead", 15000)
ga_player:force_victory_on_message("commander_dead", 16000) -- Victory for the enemy after the commander's death

----------------------------------------                                --------------------------------------------
---------------------------------------- OPTIONAL OBJECTIVE 1 ARTILLERY --------------------------------------------
----------------------------------------                                --------------------------------------------

gb:message_on_time_offset("artillery_optional_trigger", 30000) -- Displays the optional artillery objective after xxx seconds
gb:queue_help_on_message("artillery_optional_trigger", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_tamurkhan_artillery_hint") -- Displays the hint
gb:set_objective_on_message("artillery_optional_trigger", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_optional_objective_1") -- Objective appears

gb:add_listener(
	"artillery_optional_trigger",
	function()
		enemy_artillery_detachment_emp_3:add_ping_icon(15, 1, 10000); -- Adds a ping to the artillery detachment, then removes it after 10s
	end
);

enemy_artillery_detachment_emp_3:message_on_rout_proportion("player_ally_rein", 0.8) -- When 80% of the artillery detachment is gone, trigger allied reinforcements
ga_player_ally:reinforce_on_message("player_ally_rein", 1000) -- Allied Beastmen reinforcements
gb:queue_help_on_message("player_ally_rein", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_optional_objective_1_success") -- Success message
gb:complete_objective_on_message("player_ally_rein", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_optional_objective_1", 1000) -- Sets the objective as complete
enemy_artillery_guard_emp:release_on_message("player_ally_rein", 100)

-- -------------------------------------------------------------------------------------------------
-- --------------------------------------------- DEFEAT ----------------------------------------------
-- -------------------------------------------------------------------------------------------------

ga_player:message_on_commander_death("lord_dead", 1) -- Tamurkhan death message triggered
ga_player:rout_over_time_on_message("lord_dead", 15000) -- Player's force slowly routs followed by a defeat
enemy_main_garrison_emp:force_victory_on_message("lord_dead", 16000) -- Victory for the enemy after Tamurkhan's death
gb:queue_help_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_tamurkhan_alive_hint") -- Death message for tamurkhan
gb:fail_objective_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_gates_of_nuln_tamurkhan_alive", 1000) -- Keep Tamurkhan alive objective failed