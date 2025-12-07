load_script_libraries();

bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
                true,                          -- screen starts black
                true,                          -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
                false                           -- debug mode
);

---------------------------------------
----------HARD SCRIPT VERSION----------
---------------------------------------
--gb:set_cutscene_during_deployment(true);


---------------------------------------
----------HEF REINS FROM CAM-----------
---------------------------------------
local eataine_rein = tonumber(core:svr_load_string("dlc27_aislinn_tyrion"))
local avelorn_rein = tonumber(core:svr_load_string("dlc27_aislinn_alarielle"))
local nagarythe_rein = tonumber(core:svr_load_string("dlc27_aislinn_alith_anar"))
local order_loremasters_rein = tonumber(core:svr_load_string("dlc27_aislinn_teclis"))
local yvresse_rein = tonumber(core:svr_load_string("dlc27_aislinn_eltharion"))
local caledor_rein = tonumber(core:svr_load_string("dlc27_aislinn_imrik"))

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_player_02 = gb:get_army(gb:get_player_alliance_num(), "player_reinforce");
--Allied High Elf Garrison
ga_ai_ally_hef_start = gb:get_army(gb:get_player_alliance_num(), "hef_start");
ga_ai_ally_hef_garrison = gb:get_army(gb:get_player_alliance_num(), "hef_garrison");
--Allied High Elf legendary lord aid forces
if eataine_rein == 1 then ga_ai_ally_hef_eataine = gb:get_army(gb:get_player_alliance_num(), "eataine_ally"); end
if caledor_rein == 1 then ga_ai_ally_hef_caledor = gb:get_army(gb:get_player_alliance_num(), "caledor_ally"); end
if order_loremasters_rein == 1 then ga_ai_ally_hef_order_loremasters = gb:get_army(gb:get_player_alliance_num(), "loremaster_ally"); end
if avelorn_rein == 1 then ga_ai_ally_hef_avelorn = gb:get_army(gb:get_player_alliance_num(), "avelorn_ally"); end
if nagarythe_rein == 1 then ga_ai_ally_hef_nagarythe = gb:get_army(gb:get_player_alliance_num(), "nagarythe_ally"); end
if yvresse_rein == 1 then ga_ai_ally_hef_yvresse = gb:get_army(gb:get_player_alliance_num(), "yvresse_ally"); end
--Wave Invaders
ga_ai_sla_wave = gb:get_army(gb:get_non_player_alliance_num(), "sla_start");
ga_ai_nor_wave = gb:get_army(gb:get_non_player_alliance_num(), "invasion_wave_02");
ga_ai_def_wave = gb:get_army(gb:get_non_player_alliance_num(), "invasion_wave_03");
--Anti-aid forces
ga_ai_sla_rein_01 = gb:get_army(gb:get_non_player_alliance_num(), "sla_01_reinforcements");
ga_ai_sla_rein_02 = gb:get_army(gb:get_non_player_alliance_num(), "sla_02_reinforcements");
ga_ai_nor_rein_01 = gb:get_army(gb:get_non_player_alliance_num(), "nor_01_reinforcements");
ga_ai_nor_rein_02 = gb:get_army(gb:get_non_player_alliance_num(), "nor_02_reinforcements");
ga_ai_def_rein_01 = gb:get_army(gb:get_non_player_alliance_num(), "def_01_reinforcements");
ga_ai_def_rein_02 = gb:get_army(gb:get_non_player_alliance_num(), "def_02_reinforcements");

hef_start_boss = ga_ai_ally_hef_start.sunits:item(1);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Attackers Reinforce
naval_reinforcements = bm:get_spawn_zone_collection_by_name("naval_reinforce_01","naval_reinforce_02","naval_reinforce_03");
sla_reinforce = bm:get_spawn_zone_collection_by_name("sla_reinforce_01", "sla_reinforce_02");

--Second Invasion Fleet Landing
ga_ai_nor_wave:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
ga_ai_nor_wave:message_on_number_deployed("wave_02_deployed", true, 1);
ga_ai_nor_wave:assign_to_spawn_zone_from_collection_on_message("wave_02_deployed", naval_reinforcements, false);

--Third Invasion Fleet Landing
ga_ai_def_wave:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
ga_ai_def_wave:message_on_number_deployed("wave_03_deployed", true, 1);
ga_ai_def_wave:assign_to_spawn_zone_from_collection_on_message("wave_03_deployed", naval_reinforcements, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);

	if (line:script_id() == "naval_reinforce_01") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "naval_reinforce_02") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "naval_reinforce_03") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "sla_reinforce_01") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "sla_reinforce_02") then
		line:enable_random_deployment_position();		
	end
end;

--Defenders Reinforce
garrison_reinforce = bm:get_spawn_zone_collection_by_name("hef_garrison_reinforce");
ally_reinforce = bm:get_spawn_zone_collection_by_name("hef_ally_reinforce");

--High Elf Garrison
ga_ai_ally_hef_garrison:assign_to_spawn_zone_from_collection_on_message("start", garrison_reinforce, false);
ga_ai_ally_hef_garrison:message_on_number_deployed("hef_garrison_deployed", true, 1);
ga_ai_ally_hef_garrison:assign_to_spawn_zone_from_collection_on_message("hef_garrison_deployed", garrison_reinforce, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "hef_garrison_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
--Aislinn Must Survive
-- REMOVED AS IT CAN BE EXPLOITED IN SURVIVAL BATTLES
-- gb:set_locatable_objective_callback_on_message(
--     "start",
--     "wh3_dlc27_hef_aislinn_final_battle_objective_00",
--     0,
--     function()
--         local sunit = ga_player_01.sunits:get_general_sunit();
--         if sunit then
--             local cam_targ = sunit.unit:position();
--             local cam_pos = v_offset_by_bearing(
--                 cam_targ,
--                 get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
--                 75,                                                -- distance from camera position to camera target
--                 d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
--             );
--             return cam_pos, cam_targ;
--         end;
--     end,
--     2
-- );

-----OBJECTIVE 1-----
--Secure the Landing Area - Defeat the Slaanesh vanguard forces and hold all the landing locations to signal the invasion
gb:set_objective_with_leader_on_message("intro_cutscene_end", "wh3_dlc27_hef_aislinn_final_battle_objective_01");
gb:complete_objective_on_message("landing_secured", "wh3_dlc27_hef_aislinn_final_battle_objective_01");
-- gb:fail_objective_on_message("aislinn_dead", "wh3_dlc27_hef_aislinn_final_battle_objective_01");
gb:remove_objective_on_message("landing_secured", "wh3_dlc27_hef_aislinn_final_battle_objective_01", 10000);

gb:queue_help_on_message("intro_cutscene_end_delay", "wh3_dlc27_hef_aislinn_final_battle_hint_01");

gb:message_on_time_offset("intro_cutscene_end_delay", 2500, "intro_cutscene_end");

-----OBJECTIVE 2-----
--Defend the Cache - Hold the High Elf Cache location and prevent enemy invaders from capturing it
gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc27_hef_aislinn_final_battle_objective_02");
gb:complete_objective_on_message("battle_won", "wh3_dlc27_hef_aislinn_final_battle_objective_02");
-- gb:fail_objective_on_message("aislinn_dead", "wh3_dlc27_hef_aislinn_final_battle_objective_02");
gb:fail_objective_on_message("cache_cp_captured", "wh3_dlc27_hef_aislinn_final_battle_objective_02");

gb:queue_help_on_message("sla_wave_defeated", "wh3_dlc27_hef_aislinn_final_battle_hint_02");
gb:queue_help_on_message("start_wave_01", "wh3_dlc27_hef_aislinn_final_battle_hint_03");

-----OBJECTIVE 3-----
--Defeat the Norscan Invaders
gb:set_objective_with_leader_on_message("nor_wave_in", "wh3_dlc27_hef_aislinn_final_battle_objective_03");
gb:complete_objective_on_message("nor_wave_defeated", "wh3_dlc27_hef_aislinn_final_battle_objective_03");
-- gb:fail_objective_on_message("aislinn_dead", "wh3_dlc27_hef_aislinn_final_battle_objective_03");
gb:remove_objective_on_message("nor_wave_defeated", "wh3_dlc27_hef_aislinn_final_battle_objective_03", 10000);

-----OBJECTIVE 4-----
--Defeat the Dark Elf Invaders
gb:set_objective_with_leader_on_message("def_wave_in", "wh3_dlc27_hef_aislinn_final_battle_objective_04");
gb:complete_objective_on_message("def_wave_defeated", "wh3_dlc27_hef_aislinn_final_battle_objective_04");
-- gb:fail_objective_on_message("aislinn_dead", "wh3_dlc27_hef_aislinn_final_battle_objective_04");
gb:remove_objective_on_message("def_wave_defeated", "wh3_dlc27_hef_aislinn_final_battle_objective_04", 10000);

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local cp_pier_01 = bm:capture_location_manager():capture_location_from_script_id("cp_pier_01");
local cp_pier_02 = bm:capture_location_manager():capture_location_from_script_id("cp_pier_02");
local cp_pier_03 = bm:capture_location_manager():capture_location_from_script_id("cp_pier_03");
local cp_main_01 = bm:capture_location_manager():capture_location_from_script_id("cp_main_01");

gb:add_listener(
	"start",
	function()
		cp_main_01:change_holding_army(ga_ai_sla_wave.army);
		cp_main_01:set_locked(true);
		cp_pier_01:change_holding_army(ga_ai_sla_wave.army);
		cp_pier_01:set_locked(true);
		cp_pier_02:change_holding_army(ga_ai_sla_wave.army);
		cp_pier_02:set_locked(true);
		cp_pier_03:change_holding_army(ga_ai_sla_wave.army);
		cp_pier_03:set_locked(true);
	end
);

gb:add_listener(
	"sla_wave_defeated",
	function()
		cp_main_01:set_locked(false);	
		cp_pier_01:set_locked(false);	
		cp_pier_02:set_locked(false);	
		cp_pier_03:set_locked(false);	
	end
);

reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", cp_main_01);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_2", cp_main_01);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_3", cp_main_01);

cp_pier_01:set_income_cap_for_alliance(bm:get_player_alliance(), 5000.0);
cp_pier_02:set_income_cap_for_alliance(bm:get_player_alliance(), 5000.0);
cp_pier_03:set_income_cap_for_alliance(bm:get_player_alliance(), 5000.0);

reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 999);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_2", 1000, 1499);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1500, 9999999);

gb:add_listener(
	"start",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

gb:add_listener(
	"sla_wave_defeated",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_2");
	end
);

gb:add_listener(
	"nor_wave_defeated",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_3");
	end
);

gb:add_listener(
	"start",
	function()
		gb:message_on_capture_location_capture_completed("pier_01_cp_owned", "objective_01", "cp_pier_01", nil, nil, ga_player_01);
		gb:message_on_capture_location_capture_completed("pier_02_cp_owned", "objective_01", "cp_pier_02", nil, nil, ga_player_01);
		gb:message_on_capture_location_capture_completed("pier_03_cp_owned", "objective_01", "cp_pier_03", nil, nil, ga_player_01);
		gb:message_on_capture_location_capture_completed("cache_cp_owned", "objective_01", "cp_main_01", nil, nil, ga_player_01);
	end
);

gb:add_listener(
	"objective_02",
	function()
		gb:message_on_capture_location_capture_completed("cache_cp_captured", "objective_02", "cp_main_01", nil, nil, ga_ai_sla_wave);
	end
);


--------------------------
-----COMPOSITE SCENES-----
--------------------------
black_ark = "composite_scene/battle_props/black_ark_01.csc";
nor_ships = "composite_scene/battle_props/nor_ship_small_grp_idle_01.csc";

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local wave_speed = 2000;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);

--campaign hef reinforcements trigger messages
gb:message_on_time_offset("deploy_hef_reins_wave_1", 15000,"start");
gb:message_on_time_offset("deploy_hef_reins_wave_2", 25000,"nor_wave_in");
gb:message_on_time_offset("deploy_hef_reins_wave_3", 25000,"def_wave_in");

gb:message_on_all_messages_received("landing_secured","sla_wave_defeated","pier_01_cp_owned","pier_02_cp_owned","pier_03_cp_owned","cache_cp_owned");
gb:message_on_all_messages_received("battle_won","sla_wave_defeated","nor_wave_defeated","def_wave_defeated");

hef_start_boss:set_stat_attribute("unbreakable", true);

ga_ai_nor_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_def_wave:get_army():suppress_reinforcement_adc(1);
ga_ai_ally_hef_garrison:get_army():suppress_reinforcement_adc(1);

-------------------------------
----------ALLY ORDERS----------
-------------------------------
ga_ai_ally_hef_start:message_on_commander_death("hef_lord_dead");
ga_ai_ally_hef_start:defend_on_message("start", 375, 0, 100); 
ga_ai_ally_hef_start:defend_on_message("landing_secured", 125, 0, 100); 

function spawn_hef_garrison()
	ga_ai_ally_hef_garrison:deploy_at_random_intervals_on_message(
		"landing_secured", 			-- message
		1, 							-- min units
		1, 							-- max units
		wave_speed, 				-- min period
		wave_speed, 				-- max period
		"stop_hef_garrison", 		-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_hef_garrison()
ga_ai_ally_hef_garrison:message_on_any_deployed("garrison_in");
ga_ai_ally_hef_garrison:defend_on_message("garrison_in", -145, 0, 150); 

---------------------------------
----------WAVE 1 ORDERS----------
---------------------------------
ga_ai_sla_wave:add_to_survival_battle_wave_on_message("start", 0, false);

gb:add_listener(
	"start",
	function()
		ga_ai_sla_wave.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_sla_wave.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-- ga_ai_sla_wave:attack_force_on_message("start", ga_ai_ally_hef_start);
ga_ai_sla_wave:rush_position_on_message("start", 375, 0, 100);
ga_ai_sla_wave:message_on_rout_proportion("sla_wave_defeated",0.99);

gb:message_on_time_offset("objective_02", 2500, "sla_wave_defeated");

--------------------------------------
----------WAVE 1 COMPLETION-----------
--------------------------------------
gb:message_on_time_offset("play_mid_cutscene", 2500, "landing_secured");

gb:add_listener(
	"play_mid_cutscene",
	function()
		play_mid_cutscene()
	end,
	true
);

gb:message_on_time_offset("start_nor_wave", 1000, "mid_cutscene_end");

---------------------------------
----------WAVE 2 ORDERS----------
---------------------------------
ga_ai_nor_wave:add_to_survival_battle_wave_on_message("start_nor_wave", 1, false);

ga_ai_nor_wave:deploy_at_random_intervals_on_message(
	"start_nor_wave", 			-- message
	1, 							-- min units
	1, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"stop_wave_02", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_nor_wave:message_on_any_deployed("nor_wave_in");
ga_ai_nor_wave:message_on_deployed("nor_wave_in");
--ga_ai_nor_wave:rush_on_message("nor_wave_in");
ga_ai_nor_wave:rush_position_on_message("nor_wave_in", 375, 0, 100);

ga_ai_nor_wave:message_on_rout_proportion("nor_wave_wounded", 0.5);
ga_ai_nor_wave:message_on_rout_proportion("nor_wave_defeated", 0.99);
ga_ai_nor_wave:rout_over_time_on_message("nor_wave_defeated", 5000);

gb:add_listener(
	"nor_wave_wounded",
	function()
		ga_ai_nor_wave.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_nor_wave.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

--------------------------------------
----------WAVE 2 COMEPLETION----------
--------------------------------------
gb:message_on_time_offset("play_outro_cutscene", 2500, "nor_wave_defeated");

gb:add_listener(
	"play_outro_cutscene",
	function()
		play_outro_cutscene()
	end,
	true
);

gb:message_on_time_offset("start_def_wave", 1000, "outro_cutscene_end");

---------------------------------
----------WAVE 3 ORDERS----------
---------------------------------
ga_ai_def_wave:add_to_survival_battle_wave_on_message("start_def_wave", 2, false);

ga_ai_def_wave:deploy_at_random_intervals_on_message(
	"start_def_wave", 			-- message
	1, 							-- min units
	1, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"stop_wave_03", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	true,						-- is final survival wave
	false						-- show debug output
);

ga_ai_def_wave:message_on_any_deployed("def_wave_in");
ga_ai_def_wave:message_on_deployed("def_wave_in");
-- ga_ai_def_wave:rush_on_message("def_wave_in");
ga_ai_def_wave:rush_position_on_message("def_wave_in", 375, 0, 100);

ga_ai_def_wave:message_on_rout_proportion("def_wave_wounded", 0.5);
ga_ai_def_wave:message_on_rout_proportion("def_wave_defeated", 0.99);
ga_ai_def_wave:rout_over_time_on_message("def_wave_defeated", 10000);

gb:add_listener(
	"def_wave_wounded",
	function()
		ga_ai_def_wave.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_def_wave.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

--------------------------------------
----------WAVE 3 COMEPLETION----------
--------------------------------------

----------------------
-------END GAME-------
----------------------

gb:add_listener(
	"def_wave_defeated",
	function()
		cam:fade(true, 5.0)

		bm:callback(
			function()
				bm:end_battle()
				bm:change_victory_countdown_limit(0)
				bm:notify_survival_completion()
			end,
			10000
		);
	end
);

--------------------------------------
---HEF REINS FROM CAMPAIGN DILEMNAS---
--------------------------------------
function campaign_hef_reinforcements()
	local hef_rein_speed = 10000
	-- DILEMNA 1 CHOICE
	if avelorn_rein == 1 then
		-- activate avelorn reins here
		ga_ai_ally_hef_avelorn:assign_to_spawn_zone_from_collection_on_message("start", garrison_reinforce, false);
		ga_ai_ally_hef_avelorn:message_on_number_deployed("alarielle_deployed", true, 1);
		ga_ai_ally_hef_avelorn:assign_to_spawn_zone_from_collection_on_message("alarielle_deployed", garrison_reinforce, false);

		function spawn_avelorn()
			ga_ai_ally_hef_avelorn:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_1", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_alarielle", 		    -- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_avelorn()
		ga_ai_ally_hef_avelorn:message_on_any_deployed("alarielle_in");
		-- ga_ai_ally_hef_avelorn:defend_force(garrison, 100);
		ga_ai_ally_hef_avelorn:rush_on_message("alarielle_in");
		ga_ai_ally_hef_avelorn:defend_on_message("landing_secured", -145, 0, 150);
	end
	if eataine_rein == 1 then
		-- activate tyrion reins here
		ga_ai_ally_hef_eataine:assign_to_spawn_zone_from_collection_on_message("start", garrison_reinforce, false);
		ga_ai_ally_hef_eataine:message_on_number_deployed("tyrion_deployed", true, 1);
		ga_ai_ally_hef_eataine:assign_to_spawn_zone_from_collection_on_message("tyrion_deployed", garrison_reinforce, false);

		function spawn_eataine()
			ga_ai_ally_hef_eataine:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_1", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_tyrion", 		        -- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_eataine()
		ga_ai_ally_hef_eataine:message_on_any_deployed("tyrion_in");
		-- ga_ai_ally_hef_eataine:defend_force(garrison, 100);
		ga_ai_ally_hef_eataine:rush_on_message("tyrion_in");
		ga_ai_ally_hef_eataine:defend_on_message("landing_secured", -145, 0, 150);
	end

	-- DILEMNA 2 CHOICE
	if order_loremasters_rein == 1 then
		-- activate teclis reins here
		ga_ai_ally_hef_order_loremasters:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce, false);
		ga_ai_ally_hef_order_loremasters:message_on_number_deployed("teclis_deployed", true, 1);
		ga_ai_ally_hef_order_loremasters:assign_to_spawn_zone_from_collection_on_message("teclis_deployed", ally_reinforce, false);

		function spawn_loremasters()
			ga_ai_ally_hef_order_loremasters:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_2", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_teclis", 		        -- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_loremasters()
		ga_ai_ally_hef_order_loremasters:message_on_any_deployed("teclis_in");
		-- ga_ai_ally_hef_order_loremasters:defend_force(garrison, 100);
		ga_ai_ally_hef_order_loremasters:rush_on_message("teclis_in");
	end
	if nagarythe_rein == 1 then
		-- activate alith anar reins here
		ga_ai_ally_hef_nagarythe:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce, false);
		ga_ai_ally_hef_nagarythe:message_on_number_deployed("alith_anar_deployed", true, 1);
		ga_ai_ally_hef_nagarythe:assign_to_spawn_zone_from_collection_on_message("alith_anar_deployed", ally_reinforce, false);

		function spawn_nagarythe()
			ga_ai_ally_hef_nagarythe:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_2", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_alith_anar", 		    -- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_nagarythe()
		ga_ai_ally_hef_nagarythe:message_on_any_deployed("alith_anar_in");
		-- ga_ai_ally_hef_nagarythe:defend_force(garrison, 100);
		ga_ai_ally_hef_nagarythe:rush_on_message("alith_anar_in");
	end
	if caledor_rein == 1 then
		-- activate imrik reins here
		ga_ai_ally_hef_caledor:assign_to_spawn_zone_from_collection_on_message("start", garrison_reinforce, false);
		ga_ai_ally_hef_caledor:message_on_number_deployed("imrik_deployed", true, 1);
		ga_ai_ally_hef_caledor:assign_to_spawn_zone_from_collection_on_message("imrik_deployed", garrison_reinforce, false);

		function spawn_caledor()
			ga_ai_ally_hef_caledor:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_3", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_imrik", 		    	-- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_caledor()
		ga_ai_ally_hef_caledor:message_on_any_deployed("imrik_in");
		ga_ai_ally_hef_caledor:defend_on_message("imrik_in", -145, 0, 150);
		-- ga_ai_ally_hef_caledor:rush_on_message("imrik_in");
	end
	if yvresse_rein == 1 then
		-- activate eltharion reins here
		ga_ai_ally_hef_yvresse:assign_to_spawn_zone_from_collection_on_message("start", garrison_reinforce, false);
		ga_ai_ally_hef_yvresse:message_on_number_deployed("eltharion_deployed", true, 1);
		ga_ai_ally_hef_yvresse:assign_to_spawn_zone_from_collection_on_message("eltharion_deployed", garrison_reinforce, false);

		function spawn_yvresse()
			ga_ai_ally_hef_yvresse:deploy_at_random_intervals_on_message(
				"deploy_hef_reins_wave_3", 	-- message
				2, 							-- min units
				2, 							-- max units
				hef_rein_speed, 			-- min period
				hef_rein_speed, 			-- max period
				"stop_eltharion", 		    -- cancel message
				nil,						-- spawn first wave immediately
				false,						-- allow respawning
				nil,						-- survival battle wave index
				nil,						-- is final survival wave
				false						-- show debug output
			);
		end

		spawn_yvresse()
		ga_ai_ally_hef_yvresse:message_on_any_deployed("eltharion_in");
		ga_ai_ally_hef_yvresse:defend_on_message("eltharion_in", -145, 0, 150);
		-- ga_ai_ally_hef_yvresse:rush_on_message("eltharion_in");
	end
end

--if the battle is from frontend we don't use additional reinforcements
if bm:is_from_campaign() then
	campaign_hef_reinforcements()
end

--------------------------------------
-----------ANTI AID FORCES------------
--------------------------------------
-- counteracts eataine reinforcements
if eataine_rein == 1 then
	ga_ai_sla_rein_01:assign_to_spawn_zone_from_collection_on_message("start", sla_reinforce, false);
	ga_ai_sla_rein_01:message_on_number_deployed("sla_rein_01_deployed", true, 1);
	ga_ai_sla_rein_01:assign_to_spawn_zone_from_collection_on_message("sla_rein_01_deployed", sla_reinforce, false);

	function spawn_sla_01()
		ga_ai_sla_rein_01:deploy_at_random_intervals_on_message(
			"tyrion_in", 				-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_sla_rein_01", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_sla_01()
	ga_ai_sla_rein_01:add_to_survival_battle_wave_on_message("tyrion_in", 1, false);
	ga_ai_sla_rein_01:message_on_any_deployed("sla_rein_01_in");
	-- ga_ai_sla_rein_01:attack_force_on_message("sla_rein_01_in", ga_ai_ally_hef_eataine);
	ga_ai_sla_rein_01:rush_on_message("sla_rein_01_in");

	gb:add_listener(
		"sla_rein_01_in",
		function()
			ga_ai_sla_rein_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_sla_rein_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end

-- counteracts avelorn reinforcements
if avelorn_rein == 1 then
	ga_ai_sla_rein_02:assign_to_spawn_zone_from_collection_on_message("start", sla_reinforce, false);
	ga_ai_sla_rein_02:message_on_number_deployed("sla_rein_02_deployed", true, 1);
	ga_ai_sla_rein_02:assign_to_spawn_zone_from_collection_on_message("sla_rein_02_deployed", sla_reinforce, false);
	function spawn_sla_02()
		ga_ai_sla_rein_02:deploy_at_random_intervals_on_message(
			"alarielle_in", 			-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_sla_rein_02", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_sla_02()
	ga_ai_sla_rein_02:add_to_survival_battle_wave_on_message("alarielle_in", 1, false);
	ga_ai_sla_rein_02:message_on_any_deployed("sla_rein_02_in");
	-- ga_ai_sla_rein_02:attack_force_on_message("sla_rein_02_in", ga_ai_ally_hef_avelorn);
	ga_ai_sla_rein_01:rush_on_message("sla_rein_01_in");

	gb:add_listener(
		"sla_rein_02_in",
		function()
			ga_ai_sla_rein_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_sla_rein_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end

-- counteracts order of loremasters reinforcements
if order_loremasters_rein == 1 then
	ga_ai_nor_rein_01:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
	ga_ai_nor_rein_01:message_on_number_deployed("nor_rein_01_deployed", true, 1);
	ga_ai_nor_rein_01:assign_to_spawn_zone_from_collection_on_message("nor_rein_01_deployed", naval_reinforcements, false);
	function spawn_nor_01()
		ga_ai_nor_rein_01:deploy_at_random_intervals_on_message(
			"teclis_in", 				-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_nor_rein_01", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_nor_01()
	ga_ai_nor_rein_01:add_to_survival_battle_wave_on_message("teclis_in", 1, false);
	ga_ai_nor_rein_01:message_on_any_deployed("nor_rein_01_in");
	-- ga_ai_nor_rein_01:attack_force_on_message("nor_rein_01_in", ga_ai_ally_hef_order_loremasters);
	ga_ai_nor_rein_01:rush_on_message("nor_rein_01_in");

	gb:add_listener(
		"nor_rein_01_in",
		function()
			ga_ai_nor_rein_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_nor_rein_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end

-- counteracts nagarythe reinforcements
if nagarythe_rein == 1 then
	ga_ai_nor_rein_02:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
	ga_ai_nor_rein_02:message_on_number_deployed("nor_rein_02_deployed", true, 1);
	ga_ai_nor_rein_02:assign_to_spawn_zone_from_collection_on_message("nor_rein_02_deployed", naval_reinforcements, false);
	function spawn_nor_02()
		ga_ai_nor_rein_02:deploy_at_random_intervals_on_message(
			"alith_anar_in", 			-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_nor_rein_02", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_nor_02()
	ga_ai_nor_rein_02:add_to_survival_battle_wave_on_message("alith_anar_in", 1, false);
	ga_ai_nor_rein_02:message_on_any_deployed("nor_rein_02_in");
	-- ga_ai_nor_rein_02:attack_force_on_message("nor_rein_02_in", ga_ai_ally_hef_nagarythe);
	ga_ai_nor_rein_02:rush_on_message("nor_rein_02_in");

	gb:add_listener(
		"nor_rein_02_in",
		function()
			ga_ai_nor_rein_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_nor_rein_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end

-- counteracts yvresse reinforcements
if yvresse_rein == 1 then
	ga_ai_def_rein_01:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
	ga_ai_def_rein_01:message_on_number_deployed("def_rein_01_deployed", true, 1);
	ga_ai_def_rein_01:assign_to_spawn_zone_from_collection_on_message("def_rein_01_deployed", naval_reinforcements, false);
	function spawn_def_01()
		ga_ai_def_rein_01:deploy_at_random_intervals_on_message(
			"def_wave_in", 			-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_def_rein_01", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_def_01()
	ga_ai_def_rein_01:add_to_survival_battle_wave_on_message("def_wave_in", 1, false);
	ga_ai_def_rein_01:message_on_any_deployed("def_rein_01_in");
	-- ga_ai_def_rein_01:attack_force_on_message("def_rein_01_in", ga_ai_ally_hef_yvresse);
	ga_ai_def_rein_01:rush_on_message("def_rein_01_in");

	gb:add_listener(
		"def_rein_01_in",
		function()
			ga_ai_def_rein_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_def_rein_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end

-- counteracts caledor reinforcements
if caledor_rein == 1 then
	ga_ai_def_rein_02:assign_to_spawn_zone_from_collection_on_message("start", naval_reinforcements, false);
	ga_ai_def_rein_02:message_on_number_deployed("def_rein_02_deployed", true, 1);
	ga_ai_def_rein_02:assign_to_spawn_zone_from_collection_on_message("def_rein_02_deployed", naval_reinforcements, false);
	function spawn_def_02()
		ga_ai_def_rein_02:deploy_at_random_intervals_on_message(
			"def_wave_in", 			-- message
			1, 							-- min units
			1, 							-- max units
			wave_speed, 				-- min period
			wave_speed, 			    -- max period
			"stop_def_rein_02", 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
	end
	spawn_def_02()
	ga_ai_def_rein_02:add_to_survival_battle_wave_on_message("def_wave_in", 1, false);
	ga_ai_def_rein_02:message_on_any_deployed("def_rein_02_in");
	-- ga_ai_def_rein_02:attack_force_on_message("def_rein_02_in", ga_ai_ally_hef_caledor);
	ga_ai_def_rein_02:rush_on_message("def_rein_02_in");

	gb:add_listener(
		"def_rein_02_in",
		function()
			ga_ai_def_rein_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ai_def_rein_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end
	);
end


-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Intro", false, false)
-------------------------------------
----------MID CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Mid", false, false)
-------------------------------------
----------OUTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Aislinn_The_Lost_Cache_Outro", false, false)

-----------------------------------
----------CINEMATIC FILES----------
-----------------------------------
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_aislinn_fb_intro_m01.CindySceneManager"; -- TURN THIS BACK ON
bm:cindy_preload(intro_cinematic_file);

mid_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_aislinn_fb_middle_m01.CindySceneManager";
outro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_aislinn_fb_outro_m01.CindySceneManager";

--gb:set_cutscene_during_deployment(true);

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
        1,
        1
	);

	--ga_player_01.sunits:set_always_visible(true);

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
	
	-- disable unit visibility
	cutscene_intro:action(
		function() 	
			ga_ai_ally_hef_start.sunits:set_invisible_to_all(true);
			ga_ai_sla_wave.sunits:set_invisible_to_all(true);
			ga_player_01.sunits:set_invisible_to_all(true);
			-- bm:start_terrain_composite_scene(black_ark, nil, 0);
			-- bm:stop_terrain_composite_scene(black_ark);
		end, 
		10
	);	
	
	cutscene_intro:action(function() ga_player_01.sunits:set_invisible_to_all(false); end, 25000);
	
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_01"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_01", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_02"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_02", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_03"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_03", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_04"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_04", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_05"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_intro_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_intro_06"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_intro_06", false, true);
			end
	);
	cutscene_intro:set_music("wh3_dlc27_Battle_Intro_Aislinn", 0, 0)
	
	cutscene_intro:start();

end;

function end_intro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_ai_ally_hef_start.sunits:release_control();
	ga_ai_sla_wave.sunits:release_control();
	ga_player_01.sunits:release_control();

	ga_ai_ally_hef_start.sunits:set_invisible_to_all(false);
	ga_ai_sla_wave.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:set_invisible_to_all(false);

	gb.sm:trigger_message("intro_cutscene_end");

	bm:cindy_preload(mid_cinematic_file);
	bm:hide_subtitles();
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
        1,
        1
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
	
	-- disable unit visibility
	cutscene_mid:action(
		function() 	
			ga_ai_ally_hef_start.sunits:set_invisible_to_all(true);
			ga_player_01.sunits:set_invisible_to_all(true);
		end, 
		10
	);

	cutscene_mid:action(
		function() 	
			ga_ai_ally_hef_start.sunits:set_invisible_to_all(false);
			ga_player_01.sunits:set_invisible_to_all(false);
		end, 
	43500
	);
	
	-- Voiceover and Subtitles --
	
	cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 100);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_middle_01", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_middle_01"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_middle_01", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_middle_02", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_middle_02"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_middle_02", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_middle_03", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_middle_03"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_middle_03", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_middle_04", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_middle_04"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_middle_04", false, true);
			end
	);

	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_middle_05", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_middle_05"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_middle_05", false, true);
			end
	);
	
	cutscene_mid:set_music("wh3_dlc27_Battle_Middle_Aislinn", 0, 0)
	
	cutscene_mid:start();
end;

function end_mid_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	ga_ai_ally_hef_start.sunits:release_control();
	ga_player_01.sunits:release_control();

	ga_ai_ally_hef_start.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:set_invisible_to_all(false);
	
	gb.sm:trigger_message("mid_cutscene_end");

	bm:start_terrain_composite_scene(nor_ships, nil, 0);

	bm:cindy_preload(outro_cinematic_file);
	bm:hide_subtitles();
end;

-----------------------------------
----------OUTRO CINEMATIC----------
-----------------------------------
function play_outro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "outro_cutscene_end",
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
	
	-- disable unit visibility
	cutscene_outro:action(
		function() 	
			ga_ai_ally_hef_start.sunits:set_always_visible(true);
			ga_player_01.sunits:set_always_visible(true);

			bm:stop_terrain_composite_scene(nor_ships);
			bm:start_terrain_composite_scene(black_ark, nil, 0);
		end, 
		100
	);
	
	-- Voiceover and Subtitles --
	
	cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 100);

	cutscene_outro:action(
		function() 	
			ga_ai_ally_hef_start.sunits:set_always_visible(false);
			ga_player_01.sunits:set_always_visible(false);
		end, 
		39500
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_outro_01", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_outro_01"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_outro_01", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_outro_02", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_outro_02"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_outro_02", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_outro_03", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_outro_03"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_outro_03", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_hef_aislinn_final_battle_outro_04", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_hef_aislinn_final_battle_outro_04"));
				bm:show_subtitle("wh3_dlc27_hef_aislinn_final_battle_outro_04", false, true);
			end
	);

	cutscene_outro:set_music("wh3_dlc27_Battle_Outro_Aislinn", 0, 0)

	cutscene_outro:start();


end;

function end_outro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_outro_stop)
	ga_ai_ally_hef_start.sunits:release_control();
	ga_player_01.sunits:release_control();

	ga_ai_ally_hef_start.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:set_invisible_to_all(false);

	gb.sm:trigger_message("outro_cutscene_end");

	bm:hide_subtitles();
end;