-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Yuan Bo (The Jade Dragon)
-- Wei-Jin
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                	      		-- prevent deployment for ai
	nil,   										       	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_player_ally_start = gb:get_army(gb:get_player_alliance_num(), "cth_start");
ga_player_ally_reinforce = gb:get_army(gb:get_player_alliance_num(), "cth_reinforce");

ga_ai_lzd_maz = gb:get_army(gb:get_non_player_alliance_num(), "lzd_maz");
ga_ai_lzd_teh = gb:get_army(gb:get_non_player_alliance_num(), "lzd_teh");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

defender = bm:get_spawn_zone_collection_by_name("defender");
attacker = bm:get_spawn_zone_collection_by_name("attacker");

ga_player_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("start", defender, false);
ga_player_ally_reinforce:message_on_number_deployed("cth_reinforce_deployed", true, 1);
ga_player_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("cth_reinforce_deployed", defender, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "defender") then
		line:enable_random_deployment_position();		
	end
end;

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);

	if (line:script_id() == "attacker") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------------------------------------------------------------
----------------------------------- CAPTURE POINT LOCATIONS -------------------------------------
-------------------------------------------------------------------------------------------------

local capture_point = bm:capture_location_manager():capture_location_from_script_id("cp_key_building");

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("cth_reinforce_start", 45000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_ally_reinforce:deploy_at_random_intervals_on_message(
	"cth_reinforce_start", 		-- message
	2, 							-- min units
	2, 							-- max units
	45000, 						-- min period
	45000, 						-- max period
	"kb_captured", 				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_player_ally_reinforce:message_on_any_deployed("cth_in");

gb:message_on_time_offset("objective_02", 5000, "cth_in");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_capture_location_capture_completed("kb_captured", "start", "cp_key_building", nil, ga_player_01, ga_ai_lzd_maz);

ga_ai_lzd_maz:message_on_rout_proportion("maz_weak",0.75);
ga_ai_lzd_maz:message_on_rout_proportion("maz_dead",0.99);

ga_ai_lzd_teh:message_on_rout_proportion("teh_weak",0.75);
ga_ai_lzd_teh:message_on_rout_proportion("teh_dead",0.99);

gb:message_on_all_messages_received("lzd_weak", "maz_weak", "teh_weak");
gb:message_on_all_messages_received("lzd_defeated", "maz_dead", "teh_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_cth_yuan_bo_compass_objective_01");
gb:complete_objective_on_message("lzd_defeated", "wh3_dlc24_cth_yuan_bo_compass_objective_01");

gb:add_listener(
	"objective_02",
	function()
		bm:set_locatable_objective(
			"wh3_dlc24_cth_yuan_bo_compass_objective_02", 
			v(-0.686455, 1611.54895, 256.103516), 
			v(-2.576567, 1568.792603, 355.515686), 
			2, 
			true
		);
	end
);

gb:complete_objective_on_message("lzd_defeatedWe", "wh3_dlc24_cth_yuan_bo_compass_objective_02");
gb:fail_objective_on_message("kb_captured", "wh3_dlc24_cth_yuan_bo_compass_objective_02")
gb:remove_objective_on_message("kb_captured", "wh3_dlc24_cth_yuan_bo_compass_objective_02", 30000);

gb:queue_help_on_message("hint_01", "wh3_dlc24_cth_yuan_bo_compass_hint_01");
gb:queue_help_on_message("cth_in", "wh3_dlc24_cth_yuan_bo_compass_hint_02");
gb:queue_help_on_message("kb_captured", "wh3_dlc24_cth_yuan_bo_compass_hint_03");
gb:queue_help_on_message("maz_weak", "wh3_dlc24_cth_yuan_bo_compass_hint_04");
gb:queue_help_on_message("teh_weak", "wh3_dlc24_cth_yuan_bo_compass_hint_05");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
