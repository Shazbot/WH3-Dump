-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Kislev & Norsca
-- Map
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                     	 		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "caster_01");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "caster_02");
ga_ai_ally_03 = gb:get_army(gb:get_player_alliance_num(), "caster_03");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "nor_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "nor_02");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "nor_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("nor_reinforce_01");
reinforce_02 = bm:get_spawn_zone_collection_by_name("nor_reinforce_02");

ally_reinforce_01 = bm:get_spawn_zone_collection_by_name("ally_01");
ally_reinforce_02 = bm:get_spawn_zone_collection_by_name("ally_02");
ally_reinforce_03 = bm:get_spawn_zone_collection_by_name("ally_03");

ga_ai_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);
ga_ai_02:message_on_number_deployed("nor_reinforce_01_deployed", true, 1);
ga_ai_02:assign_to_spawn_zone_from_collection_on_message("nor_reinforce_01_deployed", reinforce_01, false);

ga_ai_03:assign_to_spawn_zone_from_collection_on_message("start", reinforce_02, false);
ga_ai_03:message_on_number_deployed("nor_reinforce_02_deployed", true, 1);
ga_ai_03:assign_to_spawn_zone_from_collection_on_message("nor_reinforce_02_deployed", reinforce_02, false);

ga_ai_ally_01:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce_01, false);
ga_ai_ally_02:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce_02, false);
ga_ai_ally_03:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce_03, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "nor_reinforce_01") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "nor_reinforce_02") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ally_01:reinforce_on_message("nor_01_weak")
ga_ai_ally_01:message_on_deployed("tze_ally_01_in");
ga_ai_ally_01:attack_on_message("tze_ally_01_in");

ga_ai_ally_02:reinforce_on_message("nor_02_weak")
ga_ai_ally_02:message_on_deployed("tze_ally_02_in");
ga_ai_ally_02:attack_on_message("tze_ally_02_in");

ga_ai_ally_03:reinforce_on_message("nor_03_weak")
ga_ai_ally_03:message_on_deployed("tze_ally_03_in");
ga_ai_ally_03:attack_on_message("tze_ally_03_in");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:attack_on_message("start");
ga_ai_01:message_on_rout_proportion("nor_01_hurt",0.4);
ga_ai_01:message_on_rout_proportion("nor_01_weak",0.6);
ga_ai_01:message_on_rout_proportion("nor_01_weaker",0.7);
ga_ai_01:teleport_withdraw_over_time_on_message("nor_01_weaker",15000);

gb:message_on_all_messages_received("nor_01_teleported", "nor_01_weaker");

gb:add_listener(
	"start",
	function()
		ga_ai_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

ga_ai_02:reinforce_on_message("nor_01_hurt", 5000);
ga_ai_02:message_on_any_deployed("nor_02_in");
ga_ai_02:attack_on_message("nor_02_in");
ga_ai_02:message_on_rout_proportion("nor_02_hurt",0.4);
ga_ai_02:message_on_rout_proportion("nor_02_weak",0.6);
ga_ai_02:message_on_rout_proportion("nor_02_weaker",0.75);
ga_ai_02:teleport_withdraw_over_time_on_message("nor_02_weaker",15000);

gb:message_on_all_messages_received("nor_02_teleported", "nor_02_weaker");

gb:add_listener(
	"nor_02_in",
	function()
		ga_ai_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

ga_ai_03:reinforce_on_message("nor_02_hurt", 5000);
ga_ai_03:message_on_any_deployed("nor_03_in");
ga_ai_03:attack_on_message("nor_03_in");
ga_ai_03:message_on_rout_proportion("nor_03_weak",0.6);
ga_ai_03:message_on_rout_proportion("nor_03_weaker",0.8);
ga_ai_03:teleport_withdraw_over_time_on_message("nor_03_weaker",15000);

gb:message_on_all_messages_received("nor_03_teleported", "nor_03_weaker");

gb:add_listener(
	"nor_03_in",
	function()
		ga_ai_03.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_01");
gb:complete_objective_on_message("nor_01_teleported", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_01");
gb:remove_objective_on_message("nor_01_teleported", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_01", 15000);

gb:set_objective_with_leader_on_message("nor_02_in", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_02");
gb:complete_objective_on_message("nor_02_teleported", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_02");
gb:remove_objective_on_message("nor_02_teleported", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_02", 15000);

gb:set_objective_with_leader_on_message("nor_03_in", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_03");
gb:complete_objective_on_message("nor_03_teleported", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_objective_03");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_01");
gb:queue_help_on_message("nor_01_weak", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_02");
gb:queue_help_on_message("nor_02_in", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_03");
gb:queue_help_on_message("nor_02_weak", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_04");
gb:queue_help_on_message("nor_03_in", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_05");
gb:queue_help_on_message("nor_03_weak", "wh3_dlc24_tze_changeling_theatre_scheme_kislev_and_norsca_hint_06");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
-- End the battle if the player army dies
ga_player_01:message_on_rout_proportion("changeling_dead", 1.0);
ga_ai_01:force_victory_on_message("changeling_dead", 5000);