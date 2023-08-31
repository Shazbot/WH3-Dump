-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Naggaroth
-- Black Ark Landing
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                    	  		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ally_reinforce = gb:get_army(gb:get_player_alliance_num(), "bloats");

ga_ai_start = gb:get_army(gb:get_non_player_alliance_num(), "def_start");
ga_ai_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "def_reinforce");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

ga_ally_reinforce:get_army():suppress_reinforcement_adc(1);

local reinforcements = bm:reinforcements();

def_reinforce = bm:get_spawn_zone_collection_by_name("def_reinforce");
cst_reinforce = bm:get_spawn_zone_collection_by_name("cst_reinforce");

ga_ai_reinforce:assign_to_spawn_zone_from_collection_on_message("start", def_reinforce, false);

ga_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("start", cst_reinforce, false);
ga_ally_reinforce:message_on_number_deployed("bloater_deployed", true, 1);
ga_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("bloater_deployed", cst_reinforce, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "cst_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("def_start", 1000);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("bloaters", 120000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ally_reinforce:deploy_at_random_intervals_on_message(
	"bloaters",	 				-- message
	2, 							-- min units
	2, 							-- max units
	30000, 						-- min period
	30000, 						-- max period
	"player_dead",		 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ally_reinforce:message_on_any_deployed("bloats_in");
ga_ally_reinforce:rush_on_message("bloats_in");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start:rush_on_message("def_start");
ga_ai_start:message_on_rout_proportion("def_start_weaker",0.33);
ga_ai_start:message_on_rout_proportion("def_start_dead",0.99);

ga_ai_reinforce:reinforce_on_message("def_start_weaker");
ga_ai_reinforce:message_on_any_deployed("def_reinforce_in");
ga_ai_reinforce:rush_on_message("def_reinforce_in");
ga_ai_reinforce:message_on_rout_proportion("def_reinforce_dead",0.95);

gb:message_on_all_messages_received("def_dead", "def_start_dead", "def_reinforce_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_naggaroth_objective_01");
gb:complete_objective_on_message("def_dead", "wh3_dlc24_tze_changeling_theatre_scheme_naggaroth_objective_01");

gb:queue_help_on_message("def_start", "wh3_dlc24_tze_changeling_theatre_scheme_naggaroth_hint_01");
gb:queue_help_on_message("def_start_weaker", "wh3_dlc24_tze_changeling_theatre_scheme_naggaroth_hint_02");
gb:queue_help_on_message("bloaters", "wh3_dlc24_tze_changeling_theatre_scheme_naggaroth_hint_03");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:message_on_rout_proportion("player_dead",0.99);

gb:add_listener(
	"player_dead",
	function()
		if ga_ally_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ally_reinforce.sunits:kill_proportion_over_time(1.0, 1000, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start:force_victory_on_message("player_dead", 5000);
ga_player_01:force_victory_on_message("def_dead", 5000);