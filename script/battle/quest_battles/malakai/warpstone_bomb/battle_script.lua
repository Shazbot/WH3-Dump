-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Warpstone Bomb
-- The Old Peak
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_01", "wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_01", "gc_medium_army_pan_back_left_to_back_right_far_high_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_02", "wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_02", "gc_slow_enemy_army_pan_front_left_to_front_right_close_medium_01", 8000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_03", "wh3_dlc25_dwf_malakai_warpstone_bomb_cutscene_03", "gc_orbit_90_medium_enemy_commander_front_right_extreme_high_01", 7000, true, false, false);

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
ga_enemy_skaven_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven_01");
ga_enemy_skaven_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven_02");
ga_enemy_skaven_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven_03");
ga_enemy_skaven_04 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven_04");


-------------------------------------------------------------------------------------------------
---------------------------------------- MALAKAI BEHAVIOUR --------------------------------------
-------------------------------------------------------------------------------------------------

malakai_sunit = ga_player.sunits:get_sunit_by_type("wh3_dlc25_dwf_cha_malakai_makaisson");

malakai_channeling_position = v(147, bm:get_terrain_height(147, -388), -388);
malakai_is_channeling = false;
malakai_position_monitor_listener_name = "malakai_position_monitor";
malakai_channeling_position_entry_threshold = 55;
malakai_channeling_position_exit_threshold = malakai_channeling_position_entry_threshold + 5;

function start_malakai_position_monitor(malakai_sunit)

	bm:remove_process(malakai_position_monitor_listener_name);
	local malakai_unit = malakai_sunit.unit;

	if malakai_is_channeling then
		bm:out("*** Starting Malakai position monitor, watching for him leaving the channeling area");
		bm:watch(
			function()
				return malakai_unit:position():distance_xz(malakai_channeling_position) > malakai_channeling_position_exit_threshold;
			end,
			0,
			function()
				malakai_is_channeling = false;
				bm:out("*** Malakai has left the channeling area");
				gb.sm:trigger_message("malakai_exits_channeling_area");
				start_malakai_position_monitor(malakai_sunit);
			end,
			malakai_position_monitor_listener_name
		);
	else
		bm:out("*** Starting Malakai position monitor, watching for him entering the channeling area");
		bm:watch(
			function()
				return malakai_unit:position():distance_xz(malakai_channeling_position) < malakai_channeling_position_entry_threshold;
			end,
			0,
			function()
				malakai_is_channeling = true;
				bm:out("*** Malakai has entered the channeling area");
				gb.sm:trigger_message("malakai_enters_channeling_area");
				start_malakai_position_monitor(malakai_sunit);
			end,
			malakai_position_monitor_listener_name
		);
	end;
end;


function stop_malakai_position_monitor()
	bm:remove_process(malakai_position_monitor_listener_name);
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ MALAKAI TIMER ------------------------------------------
-------------------------------------------------------------------------------------------------

malakai_countdown_timer_process_name = "malakai_countdown_timer";
malakai_countdown_initial_s = 600;
malakai_countdown_current_s = malakai_countdown_initial_s;

malakai_countdown_message_thresholds = {
	[580] = "bomb_stage_2",
	[300] = "bomb_stage_3",
	[0] = "bomb_stage_4",
};

function start_malakai_countdown_timer()
	if malakai_sunit then
		bm:repeat_callback(
			function()
				if malakai_is_channeling then
					malakai_countdown_current_s = malakai_countdown_current_s - 1;

					bm:set_objective("wh3_dlc25_dwf_malakai_warpstone_bomb_objective_02", malakai_countdown_current_s);

					if malakai_countdown_message_thresholds[malakai_countdown_current_s] then
						bm:out("*** Malakai channelling threshold reached, sending message " .. malakai_countdown_message_thresholds[malakai_countdown_current_s] .. " ***");
						gb.sm:trigger_message(malakai_countdown_message_thresholds[malakai_countdown_current_s]);
					end;

					if malakai_countdown_current_s <= 0 then
						stop_malakai_countdown_timer()
					end
				end;
			end,
			1000,
			malakai_countdown_timer_process_name
		);
	end;
end;


function stop_malakai_countdown_timer()
	bm:remove_process(malakai_countdown_timer_process_name);
end;



-------------------------------------------------------------------------------------------------
------------------------------------------ MALAKAI HEALTH -----------------------------------------
-------------------------------------------------------------------------------------------------

function start_malakai_health_monitor(malakai_sunit)
	if malakai_sunit then
		bm:watch(
			function()
				return is_shattered_or_dead(malakai_sunit)
			end,
			0,
			function()
				bm:out("*** Malakai is shattered or dead! ***");
				stop_malakai_countdown_timer();
				stop_malakai_position_monitor();
				gb.sm:trigger_message("malakai_shattered_or_dead")
			end
		);
	end;
end;



if malakai_sunit then
	bm:out("MALAKAI is present in the player's army, setting up objective markers");
	start_malakai_position_monitor(malakai_sunit);
	start_malakai_health_monitor(malakai_sunit);

	gb.sm:add_listener("start", function() start_malakai_countdown_timer() end);
else
	bm:out("MALAKAI is not present in the player's army, doing a little cry");
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- SETUP ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);

gb:add_ping_icon_on_message("start", v(147, bm:get_terrain_height(147, -388), -388), 9, 1000)
gb:add_ping_icon_on_message("start", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000);
gb:remove_ping_icon_on_message("malakai_enters_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 9, 2000);
gb:remove_ping_icon_on_message("malakai_enters_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000);

gb:add_ping_icon_on_message("malakai_exits_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000, 10000);
gb:add_ping_icon_on_message("malakai_exits_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000, 10000);
gb:remove_ping_icon_on_message("malakai_enters_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000);
gb:remove_ping_icon_on_message("ariel_enters_channeling_area", v(147, bm:get_terrain_height(147, -388), -388), 13, 2000);


-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

enemy_wave_spawn = bm:get_spawn_zone_collection_by_name("enemy_wave_spawn");
enemy_elite_spawn = bm:get_spawn_zone_collection_by_name("enemy_elite_spawn");
enemy_rear_spawn = bm:get_spawn_zone_collection_by_name("enemy_rear_spawn");

ga_enemy_skaven_02:assign_to_spawn_zone_from_collection_on_message("start", enemy_wave_spawn, false);
ga_enemy_skaven_03:assign_to_spawn_zone_from_collection_on_message("start", enemy_elite_spawn, false);
ga_enemy_skaven_04:assign_to_spawn_zone_from_collection_on_message("start", enemy_rear_spawn, false);

-- 1st enemy wave setup
ga_enemy_skaven_02:deploy_at_random_intervals_on_message(
	"reinforcement_spawn",
	2,
	4,
	5000,
	15000,
	"bomb_stage_4",
	false,
	true
)

-- elite enemy spawns setup
ga_enemy_skaven_03:deploy_at_random_intervals_on_message(
	"bomb_stage_2",
	7,
	7,
	500,
	500,
	"bomb_stage_4",
	true,
	true
)
ga_enemy_skaven_04:deploy_at_random_intervals_on_message(
	"bomb_stage_3",
	6,
	6,
	500,
	500,
	"bomb_stage_4",
	true,
	true
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------



ga_enemy_skaven_01:set_visible_to_all(true);
ga_enemy_skaven_01:defend_on_message("start", 249, -377, 100, 100);

-- trigger for reinforcement wave spawns
ga_enemy_skaven_01:message_on_casualties("reinforcement_spawn", 0.2);

ga_enemy_skaven_02:attack()
ga_enemy_skaven_03:attack()
ga_enemy_skaven_04:attack()

ga_enemy_skaven_03:message_on_proximity_to_enemy("enemy_close_03", 150)
ga_enemy_skaven_04:message_on_proximity_to_enemy("enemy_close_04", 200)

ga_enemy_skaven_03:release_on_message("enemy_close_03")
ga_enemy_skaven_04:release_on_message("enemy_close_04")

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("start", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_01");
gb:set_objective_on_message("malakai_enters_channeling_area", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_02", ariel_countdown_current_s);
gb:set_objective_on_message("malakai_enters_channeling_area", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_03");

gb:complete_objective_on_message("malakai_enters_channeling_area", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_01", 1000);

gb:complete_objective_on_message("bomb_stage_4", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_02", 1000);
gb:complete_objective_on_message("bomb_stage_4", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_03", 1000);
gb:message_on_time_offset("rout_remaining_forces", 10000, "bomb_stage_4");
ga_enemy_skaven_02:rout_over_time_on_message("rout_remaining_forces", 25000);
ga_enemy_skaven_03:rout_over_time_on_message("rout_remaining_forces", 25000);
ga_enemy_skaven_04:rout_over_time_on_message("rout_remaining_forces", 25000);

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_01", 7000, 2000, 1000);
gb:queue_help_on_message("reinforcement_spawn", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_02", 7000, 2000, 10000);
gb:queue_help_on_message("malakai_enters_channeling_area", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_03", 7000, 2000, 1000);
gb:queue_help_on_message("bomb_stage_2", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_04", 7000, 2000, 1000);
gb:queue_help_on_message("bomb_stage_3", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_05", 7000, 2000, 1000);
gb:queue_help_on_message("bomb_stage_4", "wh3_dlc25_dwf_malakai_warpstone_bomb_hint_06", 7000, 2000, 1000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_skaven_02:force_victory_on_message("player_defeated", 5000);
gb:fail_objective_on_message("malakai_shattered_or_dead", "wh3_dlc25_dwf_malakai_warpstone_bomb_objective_02", 200)
ga_enemy_skaven_02:force_victory_on_message("malakai_shattered_or_dead", 5000);

gb:message_on_all_messages_received("victory", "bomb_stage_4")
ga_player:force_victory_on_message("victory", 30500)