-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Dragon Hunters
-- Firemouth Volcano
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_01", "wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_01", "gc_orbit_90_medium_commander_back_left_close_low_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_02", "wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_02", "gc_orbit_90_medium_enemy_commander_front_right_extreme_high_01", 8000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_03", "wh3_dlc25_dwf_malakai_dragon_hunters_cutscene_03", "gc_medium_army_pan_front_left_to_front_right_close_medium_01", 7000, true, false, false);

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
ga_enemy_high_elves_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_high_elves_01");
ga_boss_army = gb:get_army(gb:get_non_player_alliance_num(), "enemy_high_elves_02");

boss_unit = ga_boss_army.sunits:get_sunit_by_type("wh3_dlc25_hef_mon_sun_dragon_boss")

-------------------------------------------------------------------------------------------------
-------------------------------------------- SETUP ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"boss_army_spawned",
	function()
		boss_unit:set_stat_attribute("unbreakable", true);
		boss_unit:add_ping_icon(15);
		bm:set_objective("wh3_dlc25_dwf_malakai_dragon_hunters_objective_02")
	end,
	true
);

-- Boss dead watcher
if boss_unit then
	bm:watch(
		function()
			return is_shattered_or_dead(boss_unit)
		end,
		0,
		function()
			bm:out("*** Boss unit is shattered or dead! ***")
			gb.sm:trigger_message("boss_dead")
			ga_player:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- 1st enemy wave setup
ga_enemy_high_elves_01:set_visible_to_all(true);
ga_enemy_high_elves_01:attack();

--enemy_main receives casualties trigger ga_boss_army message
ga_enemy_high_elves_01:message_on_casualties("enemy_reinforcement_casualties", 0.6);
ga_enemy_high_elves_01:message_on_casualties("enemy_army_defeated", 0.7);

--ga_boss_army enter battlefield
ga_boss_army:reinforce_on_message("enemy_reinforcement_casualties");
ga_boss_army:message_on_any_deployed("boss_army_spawned");
ga_boss_army:rush_on_message("boss_army_spawned");

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("battle_started", "wh3_dlc25_dwf_malakai_dragon_hunters_objective_01");
gb:complete_objective_on_message("enemy_army_defeated", "wh3_dlc25_dwf_malakai_dragon_hunters_objective_01");
gb:complete_objective_on_message("boss_dead", "wh3_dlc25_dwf_malakai_dragon_hunters_objective_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("battle_started", "wh3_dlc25_dwf_malakai_dragon_hunters_hint_01", 7000, 2000, 0);
gb:queue_help_on_message("enemy_reinforcement_casualties", "wh3_dlc25_dwf_malakai_dragon_hunters_hint_02", 7000, 2000, 4000);
gb:queue_help_on_message("victory", "wh3_dlc25_dwf_malakai_dragon_hunters_hint_03", 7000, 2000, 4000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_boss_army:force_victory_on_message("player_defeated", 5000);

gb:message_on_all_messages_received("victory", "enemy_army_defeated", "boss_dead")
ga_enemy_high_elves_01:rout_over_time_on_message("victory", 15000)
ga_boss_army:rout_over_time_on_message("victory", 15000)
ga_player:force_victory_on_message("victory", 20000)