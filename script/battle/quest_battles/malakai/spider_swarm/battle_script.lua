-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Spider Swarm
-- Subterranean - Mushroom Cave
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_spider_swarm_pt_01", "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_01", "gc_slow_army_pan_back_left_to_back_right_far_high_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_spider_swarm_pt_05", "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_05", "gc_orbit_360_slow_commander_front_left_close_low_01", 7000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_spider_swarm_pt_02", "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_02", "gc_medium_enemy_army_pan_front_left_to_front_right_medium_medium_01", 8000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_spider_swarm_pt_03", "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_03", "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 7000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_spider_swarm_pt_04", "wh3_dlc25_qb_dwf_malakai_spider_swarm_pt_04", "qb_final_position_short", 5000, false, false, false);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                        		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,    	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "gobbos_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "gobbos_02");
ga_ai_spider_01 = gb:get_army(gb:get_non_player_alliance_num(), "spiderlings_01");
ga_ai_spider_02 = gb:get_army(gb:get_non_player_alliance_num(), "spiderlings_02");
ga_ai_spider_03 = gb:get_army(gb:get_non_player_alliance_num(), "spider_queen");

ga_ai_gobbo_01 = gb:get_army(gb:get_non_player_alliance_num(), "boss_01");
ga_ai_gobbo_02 = gb:get_army(gb:get_non_player_alliance_num(), "boss_02");
ga_ai_queen_03 = gb:get_army(gb:get_non_player_alliance_num(), "spider_queen");

boss_03 = ga_ai_spider_03.sunits:item(1);
boss_03:set_stat_attribute("unbreakable", true)

ga_ai_01.sunits:set_always_visible_no_leave_battle(true);
ga_ai_02.sunits:set_always_visible_no_leave_battle(true);

-------------------------------------------------------------------------------------------------
--------------------------------------------- SETUP ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("gobbos_start", 100);
gb:message_on_time_offset("objective_01", 6500);
gb:message_on_time_offset("objective_02", 9000);

gb:add_listener(
	"objective_3",
	function()
		boss_03:add_ping_icon(15);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------
sz_spiderlings_1 = bm:get_spawn_zone_collection_by_name("spiderlings_zone_01");
sz_spiderlings_2 = bm:get_spawn_zone_collection_by_name("spiderlings_zone_02");
sz_spider_queen_3 = bm:get_spawn_zone_collection_by_name("spider_queen_01");

ga_ai_spider_01:assign_to_spawn_zone_from_collection_on_message("goblin_weak_01", sz_spiderlings_1, false);
ga_ai_spider_02:assign_to_spawn_zone_from_collection_on_message("goblin_weak_02", sz_spiderlings_2, false);
ga_ai_spider_03:assign_to_spawn_zone_from_collection_on_message("spiders_enter_03", sz_spider_queen_3, false);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ENEMY ORDERS ---------------------------------------
-------------------------------------------------------------------------------------------------

-- Goblin army 1
ga_ai_01:rush_on_message("gobbos_start");
ga_ai_gobbo_01:rush_on_message("gobbos_start");
ga_ai_gobbo_01:message_on_casualties("goblin_weak_01",0.50);
ga_ai_gobbo_01:message_on_casualties("goblin_dead_01",0.75);

-- Goblin army 2
ga_ai_02:rush_on_message("gobbos_start");
ga_ai_gobbo_02:rush_on_message("gobbos_start");
ga_ai_gobbo_02:message_on_casualties("goblin_weak_02",0.50);
ga_ai_gobbo_02:message_on_casualties("goblin_dead_02",0.75);

-- Spiderling armies 1 + 2 filter in unorganised
ga_ai_spider_01:deploy_at_random_intervals_on_message(
	"goblin_weak_01", 			-- message
	1, 							-- min units
	2, 							-- max units
	1500, 						-- min period
	1500, 						-- max period
	"bosses_subdued", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_spider_02:deploy_at_random_intervals_on_message(
	"goblin_weak_02", 			-- message
	1, 							-- min units
	2, 							-- max units
	1500, 						-- min period
	1500, 						-- max period
	"bosses_subdued", 			-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_spider_01:reinforce_on_message("goblin_weak_01");
ga_ai_spider_01:message_on_any_deployed("spiders_enter_01");
ga_ai_spider_01:rush_on_message("spiders_01_enter");

ga_ai_spider_02:reinforce_on_message("goblin_weak_02");
ga_ai_spider_02:message_on_any_deployed("spiders_enter_02");
ga_ai_spider_02:rush_on_message("spiders_enter_02");

-- Spider Queen Boss
gb:message_on_time_offset("spiders_enter_warning_03", 35000, "spiders_enter_02"); --fire warning
gb:message_on_time_offset("spiders_enter_03", 70000, "spiders_enter_02"); -- deploy the spider queen
ga_ai_spider_03:reinforce_on_message("spiders_enter_03");
ga_ai_spider_03:message_on_any_deployed("spiders_deployed_03");
gb:message_on_time_offset("objective_03", 6000, "spiders_deployed_03");
ga_ai_spider_03:message_on_any_deployed("objective_03");
ga_ai_spider_03:rush_on_message("spiders_deployed_03");
ga_ai_spider_03:message_on_casualties("queen_dead_03",0.99);

gb:message_on_all_messages_received("bosses_subdued", "goblin_dead_01", "goblin_dead_02", "queen_dead_03");

gb:add_listener(
	"bosses_subdued",
	function()
		if ga_ai_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_01.sunits:rout_over_time(20000);
		end;
		if ga_ai_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_02.sunits:rout_over_time(20000);
		end;
		if ga_ai_spider_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_spider_01.sunits:rout_over_time(9000);
		end;
		if ga_ai_spider_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_spider_02.sunits:rout_over_time(9000);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("objective_01", "wh3_dlc25_dwf_malakai_spider_swarm_objective_01");
gb:complete_objective_on_message("goblin_dead_01", "wh3_dlc25_dwf_malakai_spider_swarm_objective_01");

gb:set_objective_on_message("objective_02", "wh3_dlc25_dwf_malakai_spider_swarm_objective_02");
gb:complete_objective_on_message("goblin_dead_02", "wh3_dlc25_dwf_malakai_spider_swarm_objective_02");

gb:set_objective_with_leader_on_message("objective_03", "wh3_dlc25_dwf_malakai_spider_swarm_objective_03");
gb:complete_objective_on_message("queen_dead_03", "wh3_dlc25_dwf_malakai_spider_swarm_objective_03");

gb:queue_help_on_message("gobbos_start", "wh3_dlc25_dwf_malakai_spider_swarm_hint_01");
gb:queue_help_on_message("spiders_enter_01", "wh3_dlc25_dwf_malakai_spider_swarm_hint_02");
gb:queue_help_on_message("spiders_enter_02", "wh3_dlc25_dwf_malakai_spider_swarm_hint_03");
gb:queue_help_on_message("spiders_enter_warning_03", "wh3_dlc25_dwf_malakai_spider_swarm_hint_04_01");
gb:queue_help_on_message("spiders_deployed_03", "wh3_dlc25_dwf_malakai_spider_swarm_hint_04");
gb:queue_help_on_message("bosses_subdued", "wh3_dlc25_dwf_malakai_spider_swarm_hint_05"); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
