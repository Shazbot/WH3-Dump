-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Malevolent Tree Spirits
-- The Iron Mines
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_01", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_01", "gc_medium_army_pan_back_left_to_back_right_far_high_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_02", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_02", "gc_orbit_360_slow_commander_front_left_close_low_01", 7000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_03", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_03", "gc_slow_enemy_army_pan_front_right_to_front_left_far_high_01", 8000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_04", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_cutscene_04", "gc_medium_enemy_army_pan_front_right_to_front_left_close_medium_01", 7000, true, false, false);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                        		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,    	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1);

--Enemy Armies
ga_enemy_wood_elves_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wood_elves_01");
ga_enemy_wood_elves_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wood_elves_02");
ga_enemy_wood_elves_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wood_elves_03");
ga_enemy_wood_elves_04 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wood_elves_04");

boss_treeman = ga_enemy_wood_elves_01.sunits:item(1);

ga_player:set_visible_to_all(true);
ga_enemy_wood_elves_01:set_visible_to_all(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------- SETUP ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("reinforce_defend", 1200);
gb:message_on_time_offset("ping_treeman_boss", 6500);

gb:add_listener(
	"ping_treeman_boss",
	function()
		boss_treeman:set_stat_attribute("unbreakable", true);
		boss_treeman:add_ping_icon(15);
		bm:set_objective("wh3_dlc25_dwf_malakai_malevolent_tree_spirits_objective_01")
	end,
	true
);

-- Boss dead watcher, stops waves spawning
if boss_treeman then
	bm:watch(
		function()
			return is_shattered_or_dead(boss_treeman)
		end,
		0,
		function()
			bm:out("*** Boss unit is shattered or dead! ***")
			gb.sm:trigger_message("boss_dead")
			ga_player:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end

boss_treeman.uc:teleport_to_location(v(-212.8, -324.0), 100, 1.5)

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

reinforcement_start = bm:get_spawn_zone_collection_by_name("reinforcement_start");
reinforcement_west = bm:get_spawn_zone_collection_by_name("reinforcement_west");
reinforcement_east = bm:get_spawn_zone_collection_by_name("reinforcement_east");

ga_enemy_wood_elves_02:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_start, false);
ga_enemy_wood_elves_03:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_west, false);
ga_enemy_wood_elves_04:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_east, false);

-- 1st enemy wave setup
ga_enemy_wood_elves_02:reinforce_on_message("start");

-- 2nd and 3rd enemy wave setup
ga_enemy_wood_elves_03:deploy_at_random_intervals_on_message(
	"reinforcement_spawn",
	1,
	1,
	20000,
	20000,
	"boss_dead",
	false,
	true
)
ga_enemy_wood_elves_04:deploy_at_random_intervals_on_message(
	"reinforcement_spawn",
	1,
	1,
	20000,
	20000,
	"boss_dead",
	false,
	true
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


ga_enemy_wood_elves_01:defend_on_message("start", -212.8, -324, 70, 500);
ga_enemy_wood_elves_01:message_on_casualties("reinforcement_spawn", 0.7);
ga_enemy_wood_elves_01:rush_on_message("reinforcement_spawn");

-- trigger for reinforcement wave spawns
ga_enemy_wood_elves_02:message_on_casualties("reinforcement_spawn", 0.4);

ga_enemy_wood_elves_02:message_on_any_deployed("wef_army_1_deployed");
ga_enemy_wood_elves_02:attack_force_on_message("wef_army_1_deployed", ga_player, 2000)

ga_enemy_wood_elves_03:message_on_any_deployed("wef_army_3_deployed");
ga_enemy_wood_elves_03:rush_on_message("wef_army_3_deployed");
ga_enemy_wood_elves_04:message_on_any_deployed("wef_army_4_deployed");
ga_enemy_wood_elves_04:rush_on_message("wef_army_4_deployed");

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:complete_objective_on_message("boss_dead", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_objective_01")

gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_hint_01", 7000, 2000, 1000);
gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_hint_02", 7000, 2000, 10000);
gb:queue_help_on_message("reinforcement_spawn", "wh3_dlc25_dwf_malakai_malevolent_tree_spirits_hint_03", 7000, 2000, 20000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_wood_elves_01:force_victory_on_message("player_defeated", 5000);

gb:message_on_all_messages_received("victory", "boss_dead")
ga_enemy_wood_elves_01:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_wood_elves_02:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_wood_elves_03:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_wood_elves_04:rout_over_time_on_message("boss_dead", 15000)
ga_player:force_victory_on_message("victory", 20000)