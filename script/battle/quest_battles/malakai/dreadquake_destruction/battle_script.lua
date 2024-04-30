-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Dreadquake Destruction
-- Dark Mouth Pass
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

local gc = generated_cutscene:new(true);

gc:add_element("Play_wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_01", "wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_01", "gc_medium_army_pan_back_left_to_back_right_far_high_01", 7000, true, false, false);
gc:add_element(nil, "wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_01", nil, 4000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_02", "wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_02", "gc_medium_enemy_army_pan_front_left_to_front_right_medium_low_02", 8000, true, false, false);
gc:add_element("Play_wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_03", "wh3_dlc25_dwf_malakai_dreadquake_destruction_cutscene_03", "gc_orbit_90_medium_commander_front_close_low_01", 7000, true, false, false);


gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, -- intro cutscene function
	false                                      		-- debug mode
);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1);

--Enemy Armies
sorcerer_prophet_army = gb:get_army(gb:get_non_player_alliance_num(), "enemy_chaos_dwarfs_01");
supply_reinforcements = gb:get_army(gb:get_non_player_alliance_num(), "enemy_chaos_dwarfs_02");

supply_unit = supply_reinforcements.sunits:get_sunit_by_type("wh3_dlc23_chd_veh_iron_daemon_3payload_qb")

-------------------------------------------------------------------------------------------------
-------------------------------------------- SETUP ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("deploy_reinforcements", 40000);

gb:add_listener(
	"move_to_sorcerer_army",
	function()
		supply_unit:set_stat_attribute("unbreakable", true);
		supply_unit:add_ping_icon(15);
		bm:set_objective("wh3_dlc25_dwf_malakai_dreadquake_destruction_objective_02");
	end,
	true
);

gb:add_listener(
	"reinforcement_arrives",
	function()
		if not is_shattered_or_dead(supply_unit) then
			sorcerer_prophet_army.sunits:refill_ammo(1.5)
		end
	end,
	true
);

-- Boss dead watcher
if supply_unit then
	bm:watch(
		function()
			return is_shattered_or_dead(supply_unit)
		end,
		0,
		function()
			bm:out("*** Boss unit is shattered or dead! ***")
			gb.sm:trigger_message("supply_unit_dead")
			ga_player:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
-- player army setup
local chaos_dwarf_position = battle_vector:new(-197.7, 110.5, -287.4)

-- Sorcerer prophet army setup
sorcerer_prophet_army:set_visible_to_all(true);
sorcerer_prophet_army:defend(-197.7, -287.4, 100);
sorcerer_prophet_army:message_on_proximity_to_enemy("player_army_close", 80);
sorcerer_prophet_army:rush_on_message("player_army_close");
sorcerer_prophet_army:message_on_casualties("sorcerer_prophet_defeated", 0.7);

-- Removing ammo from Sorcerer prophet dreadquakes
for i = 1, sorcerer_prophet_army.sunits:count() do
	local current_sunit = sorcerer_prophet_army.sunits:item(i);
	if current_sunit.unit:type() == "wh3_dlc23_chd_veh_dreadquake_mortar" then
		current_sunit:modify_ammo(0)
	end
end

-- Supply train setup
supply_reinforcements:set_visible_to_all(true);
supply_reinforcements:reinforce_on_message("deploy_reinforcements");
supply_reinforcements:message_on_number_deployed("move_to_sorcerer_army", false, 6);
supply_reinforcements:message_on_casualties("supply_reinforcements_defeated", 0.6);

-- Supply train movement
supply_reinforcements:move_to_position_on_message("move_to_sorcerer_army", chaos_dwarf_position);
supply_reinforcements:message_on_proximity_to_enemy("rush_to_sorcerer_army", 150)
supply_reinforcements:defend_on_message("rush_to_sorcerer_army", -197.7, -287.4, 150);
supply_reinforcements:message_on_proximity_to_position("reinforcement_arrives", chaos_dwarf_position, 150);



------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("battle_started", "wh3_dlc25_dwf_malakai_dreadquake_destruction_objective_01");
gb:complete_objective_on_message("victory", "wh3_dlc25_dwf_malakai_dreadquake_destruction_objective_01");
gb:complete_objective_on_message("supply_unit_dead", "wh3_dlc25_dwf_malakai_dreadquake_destruction_objective_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("battle_started", "wh3_dlc25_dwf_malakai_dreadquake_destruction_hint_01", 7000, 2000, 500);
gb:queue_help_on_message("deploy_reinforcements", "wh3_dlc25_dwf_malakai_dreadquake_destruction_hint_02", 7000, 2000, 2000);
gb:queue_help_on_message("supply_unit_dead", "wh3_dlc25_dwf_malakai_dreadquake_destruction_hint_03", 7000, 2000, 2000);
gb:queue_help_on_message("victory", "wh3_dlc25_dwf_malakai_dreadquake_destruction_hint_04", 7000, 2000, 1000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

sorcerer_prophet_army:force_victory_on_message("player_defeated", 5000);

gb:message_on_all_messages_received("victory", "sorcerer_prophet_defeated", "supply_reinforcements_defeated")
sorcerer_prophet_army:rout_over_time_on_message("victory", 15000)
supply_reinforcements:rout_over_time_on_message("victory", 15000)
ga_player:force_victory_on_message("victory", 20000)