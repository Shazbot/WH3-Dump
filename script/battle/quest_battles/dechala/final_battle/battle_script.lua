load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
                false,                          -- screen starts black
                false,                          -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
                false                           -- debug mode
);

---------------------------------------
----------HARD SCRIPT VERSION----------
---------------------------------------

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
--Allied Thralls
ga_ai_brt_ally = gb:get_army(gb:get_player_alliance_num(), "sla_brt_thralls");
ga_ai_cth_ally = gb:get_army(gb:get_player_alliance_num(), "sla_cth_thralls");
ga_ai_emp_ally = gb:get_army(gb:get_player_alliance_num(), "sla_emp_thralls");
ga_ai_hef_ally = gb:get_army(gb:get_player_alliance_num(), "sla_hef_thralls");
--Bretonnia
ga_ai_brt_start = gb:get_army(gb:get_non_player_alliance_num(), "brt_start");
ga_ai_brt_thralls = gb:get_army(gb:get_non_player_alliance_num(), "brt_thrall_reinforcements");
ga_ai_brt_main = gb:get_army(gb:get_non_player_alliance_num(), "brt_main_reinforcements");
--Cathay
ga_ai_cth_start = gb:get_army(gb:get_non_player_alliance_num(), "cth_start");
ga_ai_cth_main = gb:get_army(gb:get_non_player_alliance_num(), "cth_main_reinforcements");
--Empire
ga_ai_emp_start = gb:get_army(gb:get_non_player_alliance_num(), "emp_start");
ga_ai_emp_thralls = gb:get_army(gb:get_non_player_alliance_num(), "emp_thrall_reinforcements");
ga_ai_emp_main = gb:get_army(gb:get_non_player_alliance_num(), "emp_main_reinforcements");
--High Elves
ga_ai_hef_start = gb:get_army(gb:get_non_player_alliance_num(), "hef_start");
ga_ai_hef_thralls = gb:get_army(gb:get_non_player_alliance_num(), "hef_thrall_reinforcements");
ga_ai_hef_main = gb:get_army(gb:get_non_player_alliance_num(), "hef_main_reinforcements");

brt_boss = ga_ai_brt_start.sunits:item(1);
cth_boss = ga_ai_cth_start.sunits:item(1);
emp_boss = ga_ai_emp_start.sunits:item(1);
hef_boss = ga_ai_hef_start.sunits:item(1);

--------------------------
-------NO GO ZONES--------
--------------------------
ga_player_01:enable_map_barrier_on_message("disable zones", "brt_thrall_gate_no_go", false);
ga_player_01:enable_map_barrier_on_message("disable zones", "emp_thrall_gate_no_go", false);
ga_player_01:enable_map_barrier_on_message("disable zones", "hef_thrall_gate_no_go", false);
gb:message_on_time_offset("disable zones", 0);
-- ga_player_01:enable_map_barrier_on_message("brt_cp_owned", "brt_thrall_gate_no_go", true);
-- ga_player_01:enable_map_barrier_on_message("emp_cp_owned", "emp_thrall_gate_no_go", true);
-- ga_player_01:enable_map_barrier_on_message("hef_cp_owned", "hef_thrall_gate_no_go", true);


-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Defenders Reinforce
brt_thrall = bm:get_spawn_zone_collection_by_name("brt_thrall_reinforce");
emp_thrall = bm:get_spawn_zone_collection_by_name("emp_thrall_reinforce");
hef_thrall = bm:get_spawn_zone_collection_by_name("hef_thrall_reinforce");
enemy_main = bm:get_spawn_zone_collection_by_name("enemy_main_reinforce");

--Bretonnian Thralls Escaping
ga_ai_brt_thralls:assign_to_spawn_zone_from_collection_on_message("objective_01", brt_thrall, false);
ga_ai_brt_thralls:message_on_number_deployed("brt_thralls_deployed", true, 1);
ga_ai_brt_thralls:assign_to_spawn_zone_from_collection_on_message("brt_thralls_deployed", brt_thrall, false);

--Empire Thralls Escaping
ga_ai_emp_thralls:assign_to_spawn_zone_from_collection_on_message("objective_01", emp_thrall, false);
ga_ai_emp_thralls:message_on_number_deployed("emp_thralls_deployed", true, 1);
ga_ai_emp_thralls:assign_to_spawn_zone_from_collection_on_message("emp_thralls_deployed", emp_thrall, false);

--High Elf Thralls Escaping
ga_ai_hef_thralls:assign_to_spawn_zone_from_collection_on_message("objective_01", hef_thrall, false);
ga_ai_hef_thralls:message_on_number_deployed("hef_thralls_deployed", true, 1);
ga_ai_hef_thralls:assign_to_spawn_zone_from_collection_on_message("hef_thralls_deployed", hef_thrall, false);

--Main Forces Arriving
ga_ai_brt_main:assign_to_spawn_zone_from_collection_on_message("objective_01", enemy_main, false);
ga_ai_cth_main:assign_to_spawn_zone_from_collection_on_message("objective_01", enemy_main, false);
ga_ai_emp_main:assign_to_spawn_zone_from_collection_on_message("objective_01", enemy_main, false);
ga_ai_hef_main:assign_to_spawn_zone_from_collection_on_message("objective_01", enemy_main, false);

bm:print_toggle_slots()

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);

	if (line:script_id() == "brt_thrall_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "emp_thrall_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "hef_thrall_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "enemy_main_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

--Attackers Reinforce
brt_ally_teleoprt = bm:get_spawn_zone_collection_by_name("brt_thralls_teleoprt");
cth_ally_teleoprt = bm:get_spawn_zone_collection_by_name("brt_thralls_teleoprt","emp_thralls_teleoprt","hef_thralls_teleoprt");
emp_ally_teleoprt = bm:get_spawn_zone_collection_by_name("emp_thralls_teleoprt");
hef_ally_teleoprt = bm:get_spawn_zone_collection_by_name("hef_thralls_teleoprt");

--Bretonnian Thralls Summoned
ga_ai_brt_ally:assign_to_spawn_zone_from_collection_on_message("start", brt_ally_teleoprt, false);
ga_ai_brt_ally:message_on_number_deployed("brt_ally_deployed", true, 1);
ga_ai_brt_ally:assign_to_spawn_zone_from_collection_on_message("brt_ally_deployed", brt_ally_teleoprt, false);

--Cathayan Thralls Summoned
ga_ai_cth_ally:assign_to_spawn_zone_from_collection_on_message("start", cth_ally_teleoprt, false);
ga_ai_cth_ally:message_on_number_deployed("cth_ally_deployed", true, 1);
ga_ai_cth_ally:assign_to_spawn_zone_from_collection_on_message("cth_ally_deployed", cth_ally_teleoprt, false);

--Empire Thralls Summoned
ga_ai_emp_ally:assign_to_spawn_zone_from_collection_on_message("start", emp_ally_teleoprt, false);
ga_ai_emp_ally:message_on_number_deployed("emp_ally_deployed", true, 1);
ga_ai_emp_ally:assign_to_spawn_zone_from_collection_on_message("emp_ally_deployed", emp_ally_teleoprt, false);

--High Elf Thralls Summoned
ga_ai_hef_ally:assign_to_spawn_zone_from_collection_on_message("start", hef_ally_teleoprt, false);
ga_ai_hef_ally:message_on_number_deployed("hef_ally_deployed", true, 1);
ga_ai_hef_ally:assign_to_spawn_zone_from_collection_on_message("hef_ally_deployed", hef_ally_teleoprt, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "brt_thralls_teleoprt") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "emp_thralls_teleoprt") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "hef_thralls_teleoprt") then
		line:enable_random_deployment_position();		
	end
end;


--------------------------
-----COMPOSITE SCENES-----
--------------------------
brt_float_00 = "composite_scene/cth/cth_floating_building_collapse_s00_1.csc";
brt_float_01 = "composite_scene/cth/cth_floating_building_collapse_s01_1.csc";
brt_float_02 = "composite_scene/cth/cth_floating_building_collapse_s02_1.csc";

emp_float_00 = "composite_scene/cth/cth_floating_building_collapse_s00_2.csc";
emp_float_01 = "composite_scene/cth/cth_floating_building_collapse_s01_2.csc";
emp_float_02 = "composite_scene/cth/cth_floating_building_collapse_s02_2.csc";

hef_float_00 = "composite_scene/cth/cth_floating_building_collapse_s00_3.csc";
hef_float_01 = "composite_scene/cth/cth_floating_building_collapse_s01_3.csc";
hef_float_02 = "composite_scene/cth/cth_floating_building_collapse_s02_3.csc";

gb:add_listener(
	"intro_cutscene_end",
	function()
		bm:start_terrain_composite_scene(brt_float_00, nil, 0);
		bm:start_terrain_composite_scene(emp_float_00, nil, 0);
		bm:start_terrain_composite_scene(hef_float_00, nil, 0);
	end,
	true
);

gb:add_listener(
	"brt_cp_owned",
	function()
		bm:stop_terrain_composite_scene(brt_float_00);	
		bm:start_terrain_composite_scene(brt_float_01, nil, 0);

		gb.sm:trigger_message("brt_float_01_end")
	end,
	true
);

gb:message_on_time_offset("end_brt_float_01", 20000, "brt_float_01_end");

gb:add_listener(
	"end_brt_float_01",
	function()
		bm:stop_terrain_composite_scene(brt_float_01);	
		bm:start_terrain_composite_scene(brt_float_02, nil, 0);
	end,
	true
);

gb:add_listener(
	"emp_cp_owned",
	function()
		bm:stop_terrain_composite_scene(emp_float_00);	
		bm:start_terrain_composite_scene(emp_float_01, nil, 0);

		gb.sm:trigger_message("emp_float_01_end")
	end,
	true
);

gb:message_on_time_offset("end_emp_float_01", 20000, "emp_float_01_end");

gb:add_listener(
	"end_emp_float_01",
	function()
		bm:stop_terrain_composite_scene(emp_float_01);	
		bm:start_terrain_composite_scene(emp_float_02, nil,0);
	end,
	true
);

gb:add_listener(
	"hef_cp_owned",
	function()
		bm:stop_terrain_composite_scene(hef_float_00);	
		bm:start_terrain_composite_scene(hef_float_01, nil, 0);

		gb.sm:trigger_message("hef_float_01_end")
	end,
	true
);

gb:message_on_time_offset("end_hef_float_01", 20000, "hef_float_01_end");

gb:add_listener(
	"end_hef_float_01",
	function()
		bm:stop_terrain_composite_scene(hef_float_01);
		bm:start_terrain_composite_scene(hef_float_02, nil, 0);
	end,
	true
);

-------------------------------------
----------CAPTURE LOCATIONS----------
-------------------------------------
local brt_capture_point = bm:capture_location_manager():capture_location_from_script_id("brt_gate_cp");
local emp_capture_point = bm:capture_location_manager():capture_location_from_script_id("emp_gate_cp");
local hef_capture_point = bm:capture_location_manager():capture_location_from_script_id("hef_gate_cp");

brt_capture_point:set_locked(true);

gb:add_listener(
	"brt_thrall_leader_dead",
	function()
		brt_capture_point:set_locked(false);
	end
);

gb:message_on_capture_location_capture_completed("brt_cp_owned", "start", "brt_gate_cp", nil, ga_ai_brt_start, ga_player_01);
gb:message_on_time_offset("brt_cp_disabled", 5000, "brt_cp_owned");

gb:add_listener(
	"brt_cp_disabled",
	function()
		brt_capture_point:set_enabled(false);	
	end
);

emp_capture_point:set_locked(true);

gb:add_listener(
	"emp_thrall_leader_dead",
	function()
		emp_capture_point:set_locked(false);
	end
);

gb:message_on_capture_location_capture_completed("emp_cp_owned", "start", "emp_gate_cp", nil, ga_ai_emp_start, ga_player_01);
gb:message_on_time_offset("emp_cp_disabled", 5000, "emp_cp_owned");

gb:add_listener(
	"emp_cp_disabled",
	function()
		emp_capture_point:set_enabled(false);	
	end
);

hef_capture_point:set_locked(true);

gb:add_listener(
	"hef_thrall_leader_dead",
	function()
		hef_capture_point:set_locked(false);
	end
);

gb:message_on_capture_location_capture_completed("hef_cp_owned", "start", "hef_gate_cp", nil, ga_ai_hef_start, ga_player_01);
gb:message_on_time_offset("hef_cp_disabled", 5000, "hef_cp_owned");

gb:add_listener(
	"hef_cp_disabled",
	function()
		hef_capture_point:set_enabled(false);	
	end
);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
--Keep Dechala Alive
gb:set_locatable_objective_callback_on_message(
    "start",
    "wh3_dlc27_sla_dechala_final_battle_objective_00",
    0,
    function()
        local sunit = ga_player_01.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

-----OBJECTIVE 1-----
--Prevent the Thralls Escaping - Capture the locaitons to break the Cathayan magic
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_sla_dechala_final_battle_objective_01");
gb:complete_objective_on_message("thralls_dead", "wh3_dlc27_sla_dechala_final_battle_objective_01");
gb:fail_objective_on_message("dechala_dead", "wh3_dlc27_sla_dechala_final_battle_objective_01");
gb:remove_objective_on_message("thralls_dead", "wh3_dlc27_sla_dechala_final_battle_objective_01", 10000);

gb:queue_help_on_message("start", "wh3_dlc27_sla_dechala_final_battle_hint_01");

-----OBJECTIVE 2-----
--Break the Thrall Leaders - Defeating the Thrall leaders will unlock their capture locations
gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc27_sla_dechala_final_battle_objective_02");
gb:complete_objective_on_message("thrall_leaders_dead", "wh3_dlc27_sla_dechala_final_battle_objective_02");
gb:fail_objective_on_message("dechala_dead", "wh3_dlc27_sla_dechala_final_battle_objective_02");
gb:remove_objective_on_message("thrall_leaders_dead", "wh3_dlc27_sla_dechala_final_battle_objective_02", 10000);

gb:queue_help_on_message("hint_02", "wh3_dlc27_sla_dechala_final_battle_hint_02");

-----OBJECTIVE 3-----
--Defeat the Reinforcements
gb:set_objective_with_leader_on_message("objective_03", "wh3_dlc27_sla_dechala_final_battle_objective_03");
gb:complete_objective_on_message("main_forces_dead", "wh3_dlc27_sla_dechala_final_battle_objective_03");
gb:fail_objective_on_message("dechala_dead", "wh3_dlc27_sla_dechala_final_battle_objective_03");

gb:queue_help_on_message("brt_forces_in", "wh3_dlc27_sla_dechala_final_battle_hint_03");
gb:message_on_time_offset("objective_03", 5000, "brt_forces_in");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local ally_speed = 20000;

local brt_speed = 30000;
local emp_speed = 30000;
local hef_speed = 30000;

local brt_reinforce_delay = 0;
local emp_reinforce_delay = 0;
local hef_reinforce_delay = 0;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("hint_02", 10000);
gb:message_on_time_offset("objective_02", 15000);
gb:message_on_time_offset("start", 100, "thing");
gb:message_on_time_offset("ally_reinforce", 5000, "objective_03");

gb:message_on_all_messages_received("stage_01_complete","thralls_dead","thrall_leaders_dead","locations_captured");
gb:message_on_all_messages_received("locations_captured","brt_cp_owned","emp_cp_owned","hef_cp_owned");
gb:message_on_all_messages_received("thralls_dead","brt_thralls_dead","cth_thralls_dead","emp_thralls_dead","hef_thralls_dead");
gb:message_on_all_messages_received("thrall_leaders_dead","brt_thrall_leader_dead","cth_thrall_leader_dead","emp_thrall_leader_dead","hef_thrall_leader_dead");
gb:message_on_all_messages_received("main_forces_dead","brt_forces_dead","cth_forces_dead","emp_forces_dead","hef_forces_dead");
-- gb:message_on_all_messages_received("stage_02_complete","main_forces_dead","thrall_leaders_dead","thralls_dead");

brt_boss:set_stat_attribute("unbreakable", true);
cth_boss:set_stat_attribute("unbreakable", true);
emp_boss:set_stat_attribute("unbreakable", true);
hef_boss:set_stat_attribute("unbreakable", true);

ga_ai_brt_thralls:get_army():suppress_reinforcement_adc(1);
ga_ai_emp_thralls:get_army():suppress_reinforcement_adc(1);
ga_ai_hef_thralls:get_army():suppress_reinforcement_adc(1);
ga_ai_brt_ally:get_army():suppress_reinforcement_adc(1);
ga_ai_cth_ally:get_army():suppress_reinforcement_adc(1);
ga_ai_emp_ally:get_army():suppress_reinforcement_adc(1);
ga_ai_hef_ally:get_army():suppress_reinforcement_adc(1);

ga_player_01:message_on_commander_dead_or_shattered("dechala_dead");
ga_ai_brt_start:force_victory_on_message("dechala_dead", 5000);
ga_player_01:force_victory_on_message("outro_cutscene_end", 1000);

--prevent traditional battle countdown
bm:setup_victory_callback(function() check_win() end)
function check_win()
	local player_army = bm:get_scriptunits_for_local_players_army();
	local dechala = player_army:get_general_sunit();
	if bm:victorious_alliance() == dechala.alliance_num then
		gb:stop_end_battle(true)
	else
		bm:end_battle()
	end
end

-------------------------------
----------ALLY ORDERS----------
-------------------------------
ga_ai_brt_ally:deploy_at_random_intervals_on_message(
	"ally_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	ally_speed, 				-- min period
	ally_speed, 				-- max period
	"stop_it", 					-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_brt_ally:message_on_any_deployed("brt_ally_in");
ga_ai_brt_ally:rush_on_message("brt_ally_in");

ga_ai_cth_ally:deploy_at_random_intervals_on_message(
	"ally_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	ally_speed, 				-- min period
	ally_speed, 				-- max period
	"stop_it", 					-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_cth_ally:message_on_any_deployed("cth_ally_in");
ga_ai_cth_ally:rush_on_message("cth_ally_in");

ga_ai_emp_ally:deploy_at_random_intervals_on_message(
	"ally_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	ally_speed, 				-- min period
	ally_speed, 				-- max period
	"stop_it", 					-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_emp_ally:message_on_any_deployed("emp_ally_in");
ga_ai_emp_ally:rush_on_message("emp_ally_in");

ga_ai_hef_ally:deploy_at_random_intervals_on_message(
	"ally_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	ally_speed, 				-- min period
	ally_speed, 				-- max period
	"stop_it", 					-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_hef_ally:message_on_any_deployed("hef_ally_in");
ga_ai_hef_ally:rush_on_message("hef_ally_in");

----------------------------------
----------PHASE 1 ORDERS----------
----------------------------------
ga_ai_brt_start:defend_on_message("start", -350, 255, 50);  
ga_ai_emp_start:defend_on_message("start", -50, 350, 50);  
ga_ai_hef_start:defend_on_message("start", 190, 255, 50);  

ga_ai_cth_start:rush_on_message("start");

ga_ai_cth_start:message_on_rout_proportion("cth_thralls_weak",0.25);

ga_ai_brt_start:message_on_rout_proportion("brt_thralls_dead",0.99);
ga_ai_cth_start:message_on_rout_proportion("cth_thralls_dead",0.99);
ga_ai_emp_start:message_on_rout_proportion("emp_thralls_dead",0.99);
ga_ai_hef_start:message_on_rout_proportion("hef_thralls_dead",0.99);

ga_ai_brt_start:message_on_commander_death("brt_thrall_leader_dead");
ga_ai_cth_start:message_on_commander_death("cth_thrall_leader_dead");
ga_ai_emp_start:message_on_commander_death("emp_thrall_leader_dead");
ga_ai_hef_start:message_on_commander_death("hef_thrall_leader_dead");

ga_ai_brt_start:rout_over_time_on_message("brt_thrall_leader_dead", 15000);
ga_ai_cth_start:rout_over_time_on_message("cth_thrall_leader_dead", 15000);
ga_ai_emp_start:rout_over_time_on_message("emp_thrall_leader_dead", 15000);
ga_ai_hef_start:rout_over_time_on_message("hef_thrall_leader_dead", 15000);

gb:add_listener(
	"start",
	function()
		ga_ai_cth_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:add_listener(
	"hint_02",
	function()
		brt_boss:add_ping_icon(15);
		cth_boss:add_ping_icon(15);
		emp_boss:add_ping_icon(15);
		hef_boss:add_ping_icon(15);
	end
);

ga_ai_brt_thralls:deploy_at_random_intervals_on_message(
	"cth_thralls_weak", 		-- message
	1, 							-- min units
	1, 							-- max units
	brt_speed, 					-- min period
	brt_speed, 					-- max period
	"brt_cp_owned", 			-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_brt_thralls:message_on_any_deployed("brt_thrall_in");
ga_ai_brt_thralls:defend_on_message("brt_thrall_in", -255, 255, 50);  

gb:add_listener(
	"brt_cp_owned",
	function()
		if ga_ai_brt_thralls.sunits:are_any_active_on_battlefield() == true then
			ga_ai_brt_thralls.sunits:rout_over_time(15000);
		end;

		if ga_ai_brt_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_brt_start.sunits:rout_over_time(15000);
		end;
	end,
	true
);

ga_ai_emp_thralls:deploy_at_random_intervals_on_message(
	"cth_thralls_weak", 		-- message
	1, 							-- min units
	1, 							-- max units
	emp_speed, 					-- min period
	emp_speed, 					-- max period
	"emp_cp_owned",				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_emp_thralls:message_on_any_deployed("emp_thrall_in");
ga_ai_emp_thralls:defend_on_message("emp_thrall_in", 55, 300, 50);  

gb:add_listener(
	"emp_cp_owned",
	function()
		if ga_ai_emp_thralls.sunits:are_any_active_on_battlefield() == true then
			ga_ai_emp_thralls.sunits:rout_over_time(15000);
		end;

		if ga_ai_emp_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_emp_start.sunits:rout_over_time(15000);
		end;
	end,
	true
);

ga_ai_hef_thralls:deploy_at_random_intervals_on_message(
	"cth_thralls_weak", 		-- message
	1, 							-- min units
	1, 							-- max units
	hef_speed, 					-- min period
	hef_speed, 					-- max period
	"hef_cp_owned",				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_hef_thralls:message_on_any_deployed("hef_thrall_in");
ga_ai_hef_thralls:defend_on_message("hef_thrall_in", 300, 295, 50);  

gb:add_listener(
	"hef_cp_owned",
	function()
		if ga_ai_hef_thralls.sunits:are_any_active_on_battlefield() == true then
			ga_ai_hef_thralls.sunits:rout_over_time(15000);
		end;

		if ga_ai_hef_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_hef_start.sunits:rout_over_time(15000);
		end;
	end,
	true
);

gb:add_listener(
	"objective_02_failed",
	function()
		brt_boss:remove_ping_icon();
		cth_boss:remove_ping_icon();
		emp_boss:remove_ping_icon();
		hef_boss:remove_ping_icon();
	end,
	true
);

---------------------------------------
----------PHASE 1 COMPLETION-----------
---------------------------------------
gb:message_on_time_offset("play_mid_cutscene", 2500, "stage_01_complete");

gb:add_listener(
	"play_mid_cutscene",
	function()
		play_mid_cutscene()
	end,
	true
);

----------------------------------
----------PHASE 2 ORDERS----------
----------------------------------
gb:message_on_time_offset("main_reinforce", 2500, "mid_cutscene_end");

ga_ai_brt_main:reinforce_on_message("main_reinforce");
ga_ai_brt_main:message_on_any_deployed("brt_forces_in");
ga_ai_brt_main:rush_on_message("brt_forces_in");

ga_ai_cth_main:reinforce_on_message("main_reinforce");
ga_ai_cth_main:message_on_any_deployed("cth_forces_in");
ga_ai_cth_main:rush_on_message("cth_forces_in");

ga_ai_emp_main:reinforce_on_message("main_reinforce");
ga_ai_emp_main:message_on_any_deployed("emp_forces_in");
ga_ai_emp_main:rush_on_message("emp_forces_in");

ga_ai_hef_main:reinforce_on_message("main_reinforce");
ga_ai_hef_main:message_on_any_deployed("hef_forces_in");
ga_ai_hef_main:rush_on_message("hef_forces_in");

ga_ai_brt_main:message_on_rout_proportion("brt_forces_dead",0.90);
ga_ai_cth_main:message_on_rout_proportion("cth_forces_dead",0.90);
ga_ai_emp_main:message_on_rout_proportion("emp_forces_dead",0.80); --the steam tank otherwise locks that message
ga_ai_hef_main:message_on_rout_proportion("hef_forces_dead",0.90);

---------------------------------------
----------PHASE 1 COMPLETION-----------
---------------------------------------
gb:message_on_time_offset("play_outro_cutscene", 2500, "main_forces_dead");

gb:add_listener(
	"play_outro_cutscene",
	function()
		play_outro_cutscene()
	end,
	true
);

-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Intro", false, false)
-------------------------------------
----------MID CUTSCENE 1 VO----------
-------------------------------------
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Mid", false, false)
-------------------------------------
----------MID CUTSCENE 2 VO----------
-------------------------------------
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Dechala_Gateway_to_Khuresh_Outro", false, false)
-----------------------------------
----------CINEMATIC FILES----------
-----------------------------------
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\dechala_fb_managaer_p01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

mid_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\dechala_fb_m01_p02.CindySceneManager";
outro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\dechala_fb_managaer_p03.CindySceneManager";

gb:set_cutscene_during_deployment(true);

-----------------------------------
----------INTRO CINEMATIC----------
-----------------------------------
function play_intro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        intro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_01"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_01", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_02"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_02", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_03"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_03", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_04"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_04", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_05"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_06"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_06", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_07", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_07"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_07", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_08", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_08"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_08", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_intro_09", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_intro_09"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_intro_09", false, true);
			end
	);

	cutscene_intro:set_music("wh3_dlc27_Battle_Intro_Dechala", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	gb.sm:trigger_message("intro_cutscene_end");

	bm:cindy_preload(mid_cinematic_file);

end;

---------------------------------
----------MID CINEMATIC----------
---------------------------------
function play_mid_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_mid = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_mid",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_mid_cutscene() end,
        -- path to cindy scene
        mid_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_mid:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_mid:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 100);

	--fade at the end
	cutscene_mid:action(function() cam:fade(true, 0) end, 38500)
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_middle_01", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_middle_01"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_middle_01", false, true);
			end
	);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_middle_02", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_middle_02"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_middle_02", false, true);
			end
	);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_middle_03", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_middle_03"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_middle_03", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_middle_04", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_middle_04"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_middle_04", false, true);
			end
	);

	cutscene_mid:set_music("wh3_dlc27_Battle_Middle_Dechala", 0, 0)
	cutscene_mid:set_stop_all_vo_on_start(true)

	cutscene_mid:start();
end;

function end_mid_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	gb.sm:trigger_message("mid_cutscene_end");
	
	bm:cindy_preload(outro_cinematic_file);

end;

-----------------------------------
----------OUTRO CINEMATIC----------
-----------------------------------
function play_outro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "outro_cutscene",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_outro_cutscene() end,
        -- path to cindy scene
        outro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_outro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 100);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_outro_01", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_outro_01"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_outro_01", false, true);
			end
	);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_outro_02", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_outro_02"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_outro_02", false, true);
			end
	);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_sla_dechala_final_battle_outro_03", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_sla_dechala_final_battle_outro_03"));
				bm:show_subtitle("wh3_dlc27_sla_dechala_final_battle_outro_03", false, true);
			end
	);

	cutscene_outro:set_music("wh3_dlc27_Battle_Outro_Dechala", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_outro_stop)
	gb.sm:trigger_message("outro_cutscene_end");

	bm:hide_subtitles();
end;
