gb = generated_battle:new(
	true,                                      		    -- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/heartoxy_first_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
bm:out("## ARMY SETUP INITIALISED ##");

--Friendlies
	--Player
ga_oxyotl = gb:get_army(gb:get_player_alliance_num(), 1, "");

	--Prisoners
ga_reinforcement_army_prisoners_01 = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_prisoners_01");
ga_reinforcement_army_prisoners_02 = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_prisoners_02");
ga_reinforcement_army_prisoners_01_general = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_prisoners_01_general");
ga_reinforcement_army_prisoners_02_general = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_prisoners_02_general");

	--Lizardmen
ga_reinforcement_army_lizardmen = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_lizardmen");
ga_reinforcement_army_lizardmen_rippers = gb:get_army(gb:get_player_alliance_num(), "reinforcement_army_lizardmen_rippers");

	--This spotter is  not used as a combat unit. It is hidden and stowed away on the map to provide spotting for summoned units during a cutscene
ga_spotter = gb:get_army(gb:get_player_alliance_num(), "lizardmen_spotter");

--Enemies
	--Taurox--
ga_enemy_army_taurox_main = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_taurox_main");
ga_enemy_army_taurox_front = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_taurox_front");
ga_enemy_army_taurox_left_flank = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_taurox_left_flank");
ga_enemy_army_taurox_right_flank = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_taurox_right_flank");
ga_enemy_army_taurox_patrol = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_taurox_patrol");

	--Doombull with Many Reinforcements--
ga_enemy_army_doombull = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull");
ga_enemy_army_doombull_ungor_swarm_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull_ungor_swarm_01");
ga_enemy_army_doombull_ungor_swarm_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull_ungor_swarm_02");
ga_enemy_army_doombull_gors_midtier = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull_gors_midtier");
ga_enemy_army_doombull_beefy_boys = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull_beefy_boys");
ga_enemy_army_doombull_command = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_doombull_command");

	--The Brays--
ga_enemy_army_great_bray_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_great_bray_01");
ga_enemy_army_great_bray_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_great_bray_02");
ga_enemy_army_prison_guards_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_prison_guards_01");
ga_enemy_army_prison_guards_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_prison_guards_02");

bm:out("## ARMY SETUP COMPLETE ##");

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	bm:out("## ARMY TELEPORT INITIALISED ##");

-- Oxyotl
	ga_oxyotl.sunits:item(1).uc:teleport_to_location(v(253.096, -124.698), 345, 2);

--Taurox Army Main
	ga_enemy_army_taurox_main.sunits:item(1).uc:teleport_to_location(v(-12.42, 498.99), 0, 40); --Taurox

	ga_enemy_army_taurox_main.sunits:item(9).uc:teleport_to_location(v(-42.22, 484.09), 220, 40); --Minos (Shields)
	ga_enemy_army_taurox_main.sunits:item(10).uc:teleport_to_location(v(21.52, 485.26), 130, 40); --Minos (Shields)
	ga_enemy_army_taurox_main.sunits:item(11).uc:teleport_to_location(v(187.135, 468.922), 137, 40); --Cygor

	ga_enemy_army_taurox_front.sunits:item(1).uc:teleport_to_location(v(8.51, 278.94), 180, 40); --Wargor
	ga_enemy_army_taurox_front.sunits:item(2).uc:teleport_to_location(v(-22.89, 257.18), 180, 40); --Minos
	ga_enemy_army_taurox_front.sunits:item(3).uc:teleport_to_location(v(42.68, 259.97), 180, 40); -- Minos
	ga_enemy_army_taurox_front.sunits:item(4).uc:teleport_to_location(v(41.10, 303.68), 180, 40); -- Minos (GW)
	ga_enemy_army_taurox_front.sunits:item(5).uc:teleport_to_location(v(-20.22, 306.03), 180, 40); --Minos (GW)

--Taurox Army Left
	ga_enemy_army_taurox_left_flank.sunits:item(1).uc:teleport_to_location(v(-152, 347), 225, 40);
	ga_enemy_army_taurox_left_flank.sunits:item(2).uc:teleport_to_location(v(-175.95, 441.17), 225, 40);
	ga_enemy_army_taurox_left_flank.sunits:item(3).uc:teleport_to_location(v(-180.59, 371.13), 225, 42);
	ga_enemy_army_taurox_left_flank.sunits:item(4).uc:teleport_to_location(v(-135.25, 314.36), 225, 42);
	ga_enemy_army_taurox_left_flank.sunits:item(5).uc:teleport_to_location(v(-125.60, 370.52), 225, 40);

--Taurox Army Right
	ga_enemy_army_taurox_right_flank.sunits:item(1).uc:teleport_to_location(v(169.64, 344.41), 140, 40);
	ga_enemy_army_taurox_right_flank.sunits:item(2).uc:teleport_to_location(v(186.35, 425.66), 140, 40);
	ga_enemy_army_taurox_right_flank.sunits:item(3).uc:teleport_to_location(v(196.72, 369.07), 140, 40);
	ga_enemy_army_taurox_right_flank.sunits:item(4).uc:teleport_to_location(v(145.23, 317.94), 140, 40);
	ga_enemy_army_taurox_right_flank.sunits:item(5).uc:teleport_to_location(v(141.60, 359.51), 140, 40);

--Centigor Patrol
	ga_enemy_army_taurox_patrol.sunits:item(1).uc:teleport_to_location(v(-360, 365), 135, 20);
	ga_enemy_army_taurox_patrol.sunits:item(2).uc:teleport_to_location(v(-384, 350), 135, 20);

--Doombull
	ga_enemy_army_doombull.sunits:item(1).uc:teleport_to_location(v(-203.53, -202.98), 135, 20);
	ga_enemy_army_doombull.sunits:item(2).uc:teleport_to_location(v(-210.351, -203.147), 140, 20);

--Great Bray 02
	ga_enemy_army_great_bray_02.sunits:item(1).uc:teleport_to_location(v(407.829, -41.9118), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(2).uc:teleport_to_location(v(387.704, -8.09902), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(3).uc:teleport_to_location(v(370.586, -48.4372), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(4).uc:teleport_to_location(v(416.144, 29.7477), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(5).uc:teleport_to_location(v(360.285, -88.7242), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(6).uc:teleport_to_location(v(372.555, 23.3723), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(7).uc:teleport_to_location(v(354.997, -16.5362), 280, 40);
	ga_enemy_army_great_bray_02.sunits:item(7).uc:teleport_to_location(v(337.44, -56.4448), 280, 40);
	
	ga_enemy_army_taurox_main:set_visible_to_all(true);
	ga_enemy_army_taurox_front:set_visible_to_all(true);
	ga_enemy_army_taurox_left_flank:set_visible_to_all(true);
	ga_enemy_army_taurox_right_flank:set_visible_to_all(true);
	ga_enemy_army_taurox_patrol:set_visible_to_all(true);
	ga_enemy_army_doombull:set_visible_to_all(true);
	ga_enemy_army_doombull_command:set_visible_to_all(true);
	ga_enemy_army_doombull_ungor_swarm_01:set_visible_to_all(true);
	ga_enemy_army_doombull_ungor_swarm_02:set_visible_to_all(true);
	ga_enemy_army_doombull_gors_midtier:set_visible_to_all(true);
	ga_enemy_army_doombull_gors_midtier:set_visible_to_all(true);
	ga_enemy_army_doombull_beefy_boys:set_visible_to_all(true);
	ga_enemy_army_great_bray_01:set_visible_to_all(true);
	ga_enemy_army_great_bray_02:set_visible_to_all(true);
	ga_enemy_army_prison_guards_01:set_visible_to_all(true);
	ga_enemy_army_prison_guards_02:set_visible_to_all(true);
	
	ga_enemy_army_taurox_main.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_taurox_front.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_taurox_left_flank.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_taurox_patrol.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull_command.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull_ungor_swarm_01.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull_ungor_swarm_02.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull_gors_midtier.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_doombull_beefy_boys.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_great_bray_01.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_great_bray_02.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_prison_guards_01.sunits:set_stat_attribute("stalk", false);
	ga_enemy_army_prison_guards_02.sunits:set_stat_attribute("stalk", false);

	ga_enemy_army_taurox_main.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_taurox_front.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_taurox_left_flank.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_taurox_patrol.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull_command.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull_ungor_swarm_01.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull_ungor_swarm_02.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull_gors_midtier.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_doombull_beefy_boys.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_great_bray_01.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_great_bray_02.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_prison_guards_01.sunits:set_stat_attribute("hide_forest", false);
	ga_enemy_army_prison_guards_02.sunits:set_stat_attribute("hide_forest", false);

	ga_spotter.sunits:take_control()
	ga_spotter:set_visible_to_all(false);
	ga_spotter:set_enabled(false);

	ga_enemy_army_doombull.sunits:item(1):set_stat_attribute("unbreakable", true);
	ga_enemy_army_great_bray_01.sunits:item(1):set_stat_attribute("unbreakable", true);
	ga_enemy_army_great_bray_02.sunits:item(1):set_stat_attribute("unbreakable", true);

	start_patrol_1()
end;