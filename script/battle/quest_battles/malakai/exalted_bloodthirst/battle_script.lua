-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Exalted Bloodthirst
-- The Run of Blood
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_01", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_01", "gc_medium_army_pan_back_left_to_back_right_far_high_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_02", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_02", "gc_orbit_90_medium_commander_back_right_extreme_high_01", 7000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_03", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_cutscene_03", "gc_orbit_360_slow_commander_front_left_close_low_01", 8000, true, false, false);

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
ga_enemy_khorne_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_01");
ga_enemy_khorne_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_02");
ga_enemy_khorne_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_03");
ga_enemy_khorne_04 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_04");
ga_enemy_khorne_05 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_05");
ga_enemy_khorne_06 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_khorne_06");

ga_enemy_khorne_01:get_army():suppress_reinforcement_adc(1);
ga_enemy_khorne_02:get_army():suppress_reinforcement_adc(1);
ga_enemy_khorne_03:get_army():suppress_reinforcement_adc(1);
ga_enemy_khorne_06:get_army():suppress_reinforcement_adc(1);

-- build spawn zone collections
north_spawn = bm:get_spawn_zone_collection_by_name("north_teleport_reinforce");
south_spawn = bm:get_spawn_zone_collection_by_name("south_teleport_reinforce");
boss_spawn = bm:get_spawn_zone_collection_by_name("bloodthirster_teleport_reinforce");

-- Setup spawn zones and spawn splitting
ga_enemy_khorne_02:assign_to_spawn_zone_from_collection_on_message("start", north_spawn);
ga_enemy_khorne_03:assign_to_spawn_zone_from_collection_on_message("start", south_spawn);
ga_enemy_khorne_01:assign_to_spawn_zone_from_collection_on_message("start", boss_spawn);

ga_enemy_khorne_06:message_on_number_deployed("north_spawn", true, 1, 3);
ga_enemy_khorne_06:message_on_number_deployed("south_spawn", true, 2, 4);
ga_enemy_khorne_06:assign_to_spawn_zone_from_collection_on_message("north_spawn", north_spawn);
ga_enemy_khorne_06:assign_to_spawn_zone_from_collection_on_message("south_spawn", south_spawn);

boss_sunit = ga_enemy_khorne_01.sunits:item(1);

-------------------------------------------------------------------------------------------------
-------------------------------------------- SETUP ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);

gb:add_listener(
	"boss_in",
	function()
		boss_sunit:set_stat_attribute("unbreakable", true);
		boss_sunit:add_ping_icon(15);
		bm:set_objective("wh3_dlc25_dwf_malakai_exalted_bloodthirst_objective_02")

		-- Boss dead watcher, stops waves spawning
		if boss_sunit then
			bm:watch(
				function()
					return is_shattered_or_dead(boss_sunit)
				end,
				0,
				function()
					bm:out("*** Boss unit is shattered or dead! ***")
					gb.sm:trigger_message("boss_dead")
					ga_player:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
				end
			)
		end
	end,
	true
);


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- setup visibility
ga_enemy_khorne_01:set_visible_to_all(true);
ga_enemy_khorne_02:set_visible_to_all(true);
ga_enemy_khorne_03:set_visible_to_all(true);
ga_enemy_khorne_04:set_visible_to_all(true);
ga_enemy_khorne_05:set_visible_to_all(true);
ga_enemy_khorne_06:set_visible_to_all(true);

-- Start spawning enemy armies
ga_enemy_khorne_04:message_on_casualties("spawn_challengers", 0.3);
ga_enemy_khorne_05:message_on_casualties("spawn_challengers", 0.3);

gb:block_message_on_message("spawn_challengers", "spawn_challengers")

---------------------------
-- Starting Force
---------------------------

ga_enemy_khorne_04:rush_on_message("start");
ga_enemy_khorne_05:rush_on_message("start");

---------------------------
-- Daemons
---------------------------


-- Start spawning Daemon army if this one challenged
ga_enemy_khorne_02:message_on_any_deployed("daemons_in");
ga_enemy_khorne_02:rush_on_message("daemons_in");
ga_enemy_khorne_02:message_on_casualties("daemons_defeated", 0.80);
ga_enemy_khorne_02:rout_over_time_on_message("daemons_defeated", 15000);
ga_enemy_khorne_02:deploy_at_random_intervals_on_message(
	"spawn_challengers", 		-- message
	1, 							-- min units
	1, 							-- max units
	6000, 						-- min period
	6000, 						-- max period
	"boss_dead",				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

---------------------------
-- Mortals
---------------------------

-- Start spawning Mortal army if this one challenged
ga_enemy_khorne_03:message_on_any_deployed("mortals_in");
ga_enemy_khorne_03:rush_on_message("mortals_in");
ga_enemy_khorne_03:message_on_casualties("mortals_defeated", 0.80);
ga_enemy_khorne_03:rout_over_time_on_message("mortals_defeated", 15000);
ga_enemy_khorne_03:deploy_at_random_intervals_on_message(
	"spawn_challengers", 		-- message
	1, 							-- min units
	1, 							-- max units
	6000, 						-- min period
	6000, 						-- max period
	"boss_dead",				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

---------------------------
-- Boss Army
---------------------------

-- Start spawning Mortal army if this one challenged
ga_enemy_khorne_06:message_on_any_deployed("boss_army_in");
ga_enemy_khorne_06:rush_on_message("boss_army_in");
ga_enemy_khorne_06:deploy_at_random_intervals_on_message(
	"spawn_boss", 				-- message
	1, 							-- min units
	1, 							-- max units
	6000, 						-- min period
	6000, 						-- max period
	"boss_dead",				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);


---------------------------
-- Boss
---------------------------

gb:message_on_any_message_received("spawn_boss", "daemons_defeated", "mortals_defeated");

-- Spawn Boss
ga_enemy_khorne_01:message_on_any_deployed("boss_in");
ga_enemy_khorne_01:rush_on_message("boss_in");
ga_enemy_khorne_01:reinforce_on_message("spawn_boss", 40000)

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_hint_01", 7000, 2000, 1000);
gb:queue_help_on_message("spawn_challengers", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_hint_02", 7000, 2000, 10000);
gb:queue_help_on_message("spawn_boss", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_hint_03", 7000, 2000, 2000);
gb:queue_help_on_message("boss_in", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_hint_04", 7000, 2000, 2000);
gb:queue_help_on_message("boss_dead", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_hint_05", 7000, 2000, 2000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- OBJECTIVES ----------------------------------------
-------------------------------------------------------------------------------------------------

bm:set_objective("wh3_dlc25_dwf_malakai_exalted_bloodthirst_objective_01")
gb:complete_objective_on_message("spawn_boss", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_objective_01")
gb:complete_objective_on_message("boss_dead", "wh3_dlc25_dwf_malakai_exalted_bloodthirst_objective_02")

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_khorne_01:force_victory_on_message("player_defeated", 5000);

gb:message_on_all_messages_received("victory", "boss_dead")
ga_enemy_khorne_01:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_khorne_02:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_khorne_03:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_khorne_04:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_khorne_05:rout_over_time_on_message("boss_dead", 15000)
ga_enemy_khorne_06:rout_over_time_on_message("boss_dead", 15000)

ga_player:force_victory_on_message("victory", 20000)