ga_oxyotl:grant_infinite_ammo_on_message("01_intro_cutscene_end")
-------------------------------------------------------------------------------------------------
-------------------------------------------- PATROL ---------------------------------------------
-------------------------------------------------------------------------------------------------
function start_patrol_1()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_taurox_patrol.sunits:count() do
		local current_sunit = ga_enemy_army_taurox_patrol.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_bst_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(-162, 148), true);
		pm:add_waypoint(v(190, 183), true);
		pm:add_waypoint(v(300, 349), true);
		pm:add_waypoint(v(190, 183), true);
		pm:add_waypoint(v(-162, 148), true);
		pm:add_waypoint(v(-271, 371), true);
		pm:loop(true);
		pm:set_stop_on_intercept(true);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ FAKE PATROL ------------------------------------------
-------------------------------------------------------------------------------------------------

--These patrols are used to move armies into position quickly. This is because patrols force units to march

function start_patrol_2()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_great_bray_01.sunits:count() do
		local current_sunit = ga_enemy_army_great_bray_01.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_bst_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(-295.399, 325.442), false);
		pm:add_waypoint(v(-206.54, 139.828), true);
		pm:add_waypoint(v(-281.899, -14.3999), false);
		pm:loop(false);
		pm:set_stop_on_intercept(false);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

function start_patrol_3()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_great_bray_02.sunits:count() do
		local current_sunit = ga_enemy_army_great_bray_02.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_bst_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(18.0989, 121.257), true);
		pm:add_waypoint(v(-205.975, -41.2934), false);
		pm:loop(false);
		pm:set_stop_on_intercept(false);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- FIRST ENEMY ORDERS --------------------------------------
-------------------------------------------------------------------------------------------------
--ga_enemy_army_doombull:reinforce_on_message("battle_started");
ga_enemy_army_doombull.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_doombull:message_on_commander_dead_or_routing("doombull_dead_first");
ga_enemy_army_doombull:message_on_commander_dead_or_routing("doombull_dead_second");
gb:message_on_time_offset("doombull_dead", 5000, "doombull_dead_first")
gb:message_on_time_offset("doombull_dead", 5000, "doombull_dead_second")

ga_enemy_army_doombull_ungor_swarm_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_doombull_ungor_swarm_01:deploy_at_random_intervals_on_message("01_intro_cutscene_end", 1, 1, 60000, 60000, "doombull_dead", true);
--ga_enemy_army_doombull_ungor_swarm:reinforce_on_message("battle_started");
ga_enemy_army_doombull_ungor_swarm_01:move_to_position(v(-170, 33, 360));

ga_enemy_army_doombull_ungor_swarm_02:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_doombull_ungor_swarm_02:deploy_at_random_intervals_on_message("01_intro_cutscene_end", 1, 1, 60000, 60000, "doombull_dead", true);
ga_enemy_army_doombull_ungor_swarm_02:move_to_position(v(170, 33, 360));

ga_enemy_army_doombull_gors_midtier:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_doombull_gors_midtier:deploy_at_random_intervals_on_message("01_intro_cutscene_end", 1, 1, 90000, 90000, "doombull_dead", true);
ga_enemy_army_doombull_gors_midtier:move_to_position(v(-170, 33, 360));

ga_enemy_army_doombull_beefy_boys:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_doombull_beefy_boys:deploy_at_random_intervals_on_message("01_intro_cutscene_end", 1, 1, 120000, 120000, "doombull_dead", true);
ga_enemy_army_doombull_beefy_boys:move_to_position(v(-170, 33, 360));

ga_enemy_army_doombull:message_on_under_attack("doombull_under_attack");
ga_enemy_army_doombull:message_on_proximity_to_enemy("doombull_under_attack", 170);
ga_enemy_army_doombull:attack_on_message("doombull_under_attack");
ga_enemy_army_doombull_command:reinforce_on_message("battle_started");
ga_enemy_army_doombull_command:defend_on_message("battle_started", -203.53, -202.98, 120);
ga_enemy_army_doombull_command:message_on_under_attack("doombull_under_attack");
ga_enemy_army_doombull_command:attack_on_message("doombull_under_attack");

bm:debug_drawing():draw_white_circle_on_terrain(v(-203.53, -202.98), 170, 100000000);

ga_enemy_army_doombull:rout_over_time_on_message("doombull_dead", 1000);
ga_enemy_army_doombull_command:rout_over_time_on_message("doombull_dead", 1000);
ga_enemy_army_doombull_ungor_swarm_01:rout_over_time_on_message("doombull_dead", 1000);
ga_enemy_army_doombull_ungor_swarm_02:rout_over_time_on_message("doombull_dead", 1000);
ga_enemy_army_doombull_gors_midtier:rout_over_time_on_message("doombull_dead", 1000);
ga_enemy_army_doombull_beefy_boys:rout_over_time_on_message("doombull_dead", 1000);

-------------------------------------------------------------------------------------------------
--------------------------------------- BRAY GLOBAL ORDERS --------------------------------------
-------------------------------------------------------------------------------------------------
gb:add_listener("brays_move", function() start_patrol_2() end);
gb:add_listener("brays_move", function() start_patrol_3() end);
gb:message_on_any_message_received("brays_attack", "cutscene_brays_move_end", "cutscene_doombull_dead_end")

-------------------------------------------------------------------------------------------------
----------------------------------------- BRAY 01 ORDERS ----------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_army_great_bray_01:message_on_under_attack("brays_move_early");
ga_enemy_army_great_bray_01:attack_force_on_message("brays_attack", ga_oxyotl, 80000);
ga_enemy_army_great_bray_01:message_on_commander_dead_or_routing("great_bray_01_dead");
ga_enemy_army_great_bray_01.sunits:prevent_rallying_if_routing(true);

-- Prisoners 1
ga_reinforcement_army_prisoners_01:reinforce_on_message("great_bray_01_dead");
ga_reinforcement_army_prisoners_01:release_on_message("great_bray_01_dead");
gb:add_ping_icon_on_message("great_bray_01_dead", v(-456.31, 100, 366), 11, 0, 10000);

ga_reinforcement_army_prisoners_01_general:reinforce_on_message("don't do that");

-------------------------------------------------------------------------------------------------
---------------------------------------- BRAY 02 ORDERS -----------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_army_great_bray_02:message_on_under_attack("brays_move_early")
ga_enemy_army_great_bray_02:attack_force_on_message("brays_attack", ga_oxyotl, 80000);
ga_enemy_army_great_bray_02:message_on_commander_dead_or_routing("great_bray_02_dead");
ga_enemy_army_great_bray_02.sunits:prevent_rallying_if_routing(true);

-- Prisoners 2
ga_reinforcement_army_prisoners_02:reinforce_on_message("great_bray_02_dead");
ga_reinforcement_army_prisoners_02:release_on_message("great_bray_02_dead");
gb:add_ping_icon_on_message("great_bray_02_dead", v(459.215, 120, -57.218), 11, 0, 10000);

ga_reinforcement_army_prisoners_02_general:reinforce_on_message("don't do that");

-------------------------------------------------------------------------------------------------
------------------------------------- LIZARDMEN ALLY ORDERS -------------------------------------
-------------------------------------------------------------------------------------------------

ga_reinforcement_army_lizardmen:reinforce_on_message("release_taurox");
ga_reinforcement_army_lizardmen:reinforce_on_message("brays_total_dead_trigger1");
--ga_reinforcement_army_lizardmen:attack_force_on_message("trigger_ritual", ga_enemy_army_taurox_right_flank);
ga_reinforcement_army_lizardmen:move_to_position_on_message("trigger_ritual", v(343.55, 0, 285.858));
ga_reinforcement_army_lizardmen:release_on_message("trigger_ritual", 60000);

ga_reinforcement_army_lizardmen_rippers:reinforce_on_message("release_taurox");
ga_reinforcement_army_lizardmen_rippers:reinforce_on_message("brays_total_dead_trigger1");
--ga_reinforcement_army_lizardmen_rippers:attack_force_on_message("trigger_ritual", ga_enemy_army_taurox_right_flank)
ga_reinforcement_army_lizardmen_rippers:release_on_message("trigger_ritual");
ga_spotter:reinforce_on_message("battle_started");

gb:add_listener("01_intro_cutscene_end", function() move_spotter() end);

function move_spotter()
	ga_spotter.sunits:item(1).uc:teleport_to_location(v(-12.42, 425), 0, 40);
end;


-------------------------------------------------------------------------------------------------
-------------------------------------- TAUROX ENEMY ORDERS --------------------------------------
-------------------------------------------------------------------------------------------------

bm:debug_drawing():draw_white_circle_on_terrain(v(-10.4747,487.706), 500, 100000000);
bm:debug_drawing():draw_white_circle_on_terrain(v(-152, 347), 80, 100000000);
bm:debug_drawing():draw_white_circle_on_terrain(v(8.51, 278.94), 80, 100000000);
bm:debug_drawing():draw_white_circle_on_terrain(v(169.64, 344.41), 80, 100000000);
bm:debug_drawing():draw_white_circle_on_terrain(v(-10.4747,487.706), 150, 100000000);

ga_enemy_army_taurox_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_taurox_main:change_behaviour_active_on_message("cutscene_ritual_complete_end", "fire_at_will", true, false);

ga_enemy_army_taurox_front:defend_on_message("brays_total_dead", 8.51, 278.94, 80);
ga_enemy_army_taurox_left_flank:defend_on_message("brays_total_dead", -152, 347, 80);
ga_enemy_army_taurox_right_flank:defend_on_message("brays_total_dead", 169.64, 344.41, 80);

ga_enemy_army_taurox_main:message_on_under_attack("release_taurox");
ga_enemy_army_taurox_front:message_on_under_attack("front_under_attack");
ga_enemy_army_taurox_left_flank:message_on_under_attack("left_flank_under_attack");
ga_enemy_army_taurox_right_flank:message_on_under_attack("right_flank_under_attack");
ga_enemy_army_taurox_patrol:message_on_under_attack("patrol_under_attack");

ga_enemy_army_taurox_main:attack_force_on_message("release_taurox", ga_oxyotl);
ga_enemy_army_taurox_front:attack_force_on_message("release_taurox", ga_oxyotl);

ga_enemy_army_taurox_main:change_behaviour_active_on_message("release_taurox", "fire_at_will", false, false);

ga_enemy_army_taurox_main:release_on_message("release_taurox", 300000);
ga_enemy_army_taurox_front:release_on_message("release_taurox", 300000);
ga_enemy_army_taurox_left_flank:release_on_message("release_taurox");
ga_enemy_army_taurox_right_flank:release_on_message("release_taurox");

ga_enemy_army_taurox_front:attack_force_on_message("front_under_attack", ga_oxyotl);
ga_enemy_army_taurox_front:release_on_message("front_under_attack", 300000);
ga_enemy_army_taurox_left_flank:release_on_message("left_flank_under_attack");
ga_enemy_army_taurox_right_flank:release_on_message("right_flank_under_attack");
ga_enemy_army_taurox_patrol:release_on_message("patrol_under_attack");


ga_enemy_army_taurox_main:message_on_commander_dead_or_routing("taurox_dead");

ga_enemy_army_taurox_main:rout_over_time_on_message("taurox_dead", 30000);
ga_enemy_army_taurox_left_flank:rout_over_time_on_message("taurox_dead", 30000);
ga_enemy_army_taurox_right_flank:rout_over_time_on_message("taurox_dead", 30000);

gb:message_on_time_offset("taurox_total_dead", 10000, "taurox_dead");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------


--Objective 1
gb:message_on_time_offset("ping_doombull", 5000, "01_intro_cutscene_end")
ga_enemy_army_doombull:add_ping_icon_on_message("ping_doombull", 15, 1);
gb:add_ping_icon_on_message("ping_doombull", v(-203.53, 140, -202.98), 11, 0, 20000);
gb:queue_help_on_message("ping_doombull", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01_popup", 6000, nil, 0);
gb:set_locatable_objective_callback_on_message(
    "ping_doombull",
    "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01",
    0,
    function()
        local sunit = ga_enemy_army_doombull.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
gb:complete_objective_on_message("doombull_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01");
gb:queue_help_on_message("doombull_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01_complete", 6000, nil);
gb:remove_objective_on_message("cutscene_doombull_dead_end", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01");
gb:remove_objective_on_message("cutscene_doombull_dead_lite_end", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01");
ga_enemy_army_doombull:remove_ping_icon_on_message("doombull_dead", 1);

--Objective 2
gb:block_message_on_message("doombull_dead_first", "brays_move_early")
gb:block_message_on_message("brays_move_early", "doombull_dead_first")

gb:message_on_all_messages_received("doombull_dead_lite", "brays_move_early", "doombull_dead_second");

gb:message_on_time_offset("trigger_objective_2", 5000, "cutscene_doombull_dead_end")
gb:message_on_time_offset("trigger_objective_2", 5000, "cutscene_brays_move_end")

gb:queue_help_on_message("trigger_objective_2", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02_popup", 6000, nil);
ga_enemy_army_great_bray_01:add_ping_icon_on_message("trigger_objective_2", 15, 1);
ga_enemy_army_great_bray_02:add_ping_icon_on_message("trigger_objective_2", 15, 1);
gb:add_ping_icon_on_message("trigger_objective_2", v(283.538, 120, 17.1969), 11, 0, 10000);
gb:add_ping_icon_on_message("trigger_objective_2", v(-410.666, 120, 345.606), 11, 0, 10000);

--Objective 2A
gb:set_locatable_objective_callback_on_message(
    "trigger_objective_2",
    "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02a",
    0,
    function()
        local sunit = ga_enemy_army_great_bray_01.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("great_bray_01_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02a");
ga_enemy_army_great_bray_01:remove_ping_icon_on_message("great_bray_01_dead", 1);

--Obejctive 2B
gb:set_locatable_objective_callback_on_message(
    "trigger_objective_2",
    "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02b",
    0,
    function()
        local sunit = ga_enemy_army_great_bray_02.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("great_bray_02_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02b");
ga_enemy_army_great_bray_02:remove_ping_icon_on_message("great_bray_02_dead", 1);

gb:message_on_all_messages_received(
	"brays_total_dead",
	"great_bray_01_dead",
	"great_bray_02_dead");

gb:message_on_any_message_received(
	"first_bray_dead",
	"great_bray_01_dead",
	"great_bray_02_dead");

gb:queue_help_on_message("first_bray_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02a_complete", 6000, nil);
gb:queue_help_on_message("brays_total_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02b_complete", 6000, nil);

gb:block_message_on_message("first_bray_dead", "first_bray_dead")

gb:message_on_all_messages_received(
	"remove_objective_2",
	"great_bray_01_dead",
	"great_bray_02_dead",
	"cutscene_ritual_complete_end");

gb:remove_objective_on_message("remove_objective_2", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02a");
gb:remove_objective_on_message("remove_objective_2", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02b");

--Objective 3

ga_oxyotl:message_on_proximity_to_position("oxy_close", v(-10.4747,487.706), 500);

gb:message_on_all_messages_received("brays_total_dead_trigger1", "brays_total_dead", "oxy_close");

gb:message_on_time_offset("brays_total_dead_trigger2", 10000, "brays_total_dead_trigger1");
gb:message_on_time_offset("taurox_under_attack_trigger", 10000, "release_taurox");

gb:block_message_on_message("taurox_under_attack_trigger", "brays_total_dead_trigger2")
gb:block_message_on_message("brays_total_dead_trigger2", "taurox_under_attack_trigger")

gb:message_on_any_message_received("trigger_ritual", "brays_total_dead_trigger2", "taurox_under_attack_trigger")
gb:queue_help_on_message("trigger_ritual", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03a_popup", 6000, nil);

gb:message_on_time_offset("trigger_final_objective", 5000, "cutscene_ritual_complete_end");
ga_enemy_army_taurox_main:add_ping_icon_on_message("trigger_final_objective", 15, 1);
gb:queue_help_on_message("trigger_final_objective", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03b_popup", 6000, nil);
gb:message_on_time_offset("release_taurox", 0, "trigger_ritual");

gb:add_ping_icon_on_message("trigger_final_objective", v(-6.5, 60, 410.706), 11, 0, 20000);

gb:set_locatable_objective_callback_on_message(
    "trigger_final_objective",
    "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03",
    0,
    function()
        local sunit = ga_enemy_army_taurox_main.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

ga_enemy_army_taurox_main:remove_ping_icon_on_message("taurox_dead", 1);
gb:complete_objective_on_message("taurox_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03");
gb:queue_help_on_message("taurox_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03_complete");

-- Victory Trigger
ga_oxyotl:force_victory_on_message("taurox_total_dead")

gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_04",
    0,
    function()
        local sunit = ga_oxyotl.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
ga_oxyotl:message_on_commander_dead_or_shattered("oxyotl_dead");

gb:complete_objective_on_message("taurox_total_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_04")

gb:fail_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_04")
gb:queue_help_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_04_failed", 6000, nil, 0);
ga_enemy_army_taurox_main:force_victory_on_message("oxyotl_dead", 10000)

gb:remove_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_01")
gb:remove_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02a")
gb:remove_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_02b")
gb:remove_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_lzd_oxyotl_final_battle_objective_03")