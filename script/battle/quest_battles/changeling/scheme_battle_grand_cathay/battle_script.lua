-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Grand Cathay
-- The Bastion
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                  	    		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "skv_01");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "skv_02");
ga_ai_ally_03 = gb:get_army(gb:get_player_alliance_num(), "skv_03");

ga_ai_miao_ying = gb:get_army(gb:get_non_player_alliance_num(), "miao_ying");
ga_ai_zhao_ming = gb:get_army(gb:get_non_player_alliance_num(), "zhao_ming");
ga_ai_yuan_bo = gb:get_army(gb:get_non_player_alliance_num(), "yuan_bo");
ga_ai_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "cth_reinforce");

skv_01 = ga_ai_ally_01.sunits:item(1);
skv_02 = ga_ai_ally_02.sunits:item(1);
skv_03 = ga_ai_ally_03.sunits:item(1);

miao_ying = ga_ai_miao_ying.sunits:item(1);
zhao_ming = ga_ai_zhao_ming.sunits:item(1);
yuan_bo = ga_ai_yuan_bo.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

cth_reinforce_west = bm:get_spawn_zone_collection_by_name("cth_west");
cth_reinforce_east = bm:get_spawn_zone_collection_by_name("cth_east");
cth_reinforce_fort = bm:get_spawn_zone_collection_by_name("cth_fort");

skv_reinforce_01 = bm:get_spawn_zone_collection_by_name("skv_01");
skv_reinforce_02 = bm:get_spawn_zone_collection_by_name("skv_02");
skv_reinforce_03 = bm:get_spawn_zone_collection_by_name("skv_03");

ga_ai_ally_01:assign_to_spawn_zone_from_collection_on_message("start", skv_reinforce_01, false);
ga_ai_ally_02:assign_to_spawn_zone_from_collection_on_message("start", skv_reinforce_02, false);
ga_ai_ally_03:assign_to_spawn_zone_from_collection_on_message("start", skv_reinforce_03, false);

ga_ai_zhao_ming:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforce_east, false);
ga_ai_yuan_bo:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforce_west, false);

ga_ai_reinforce:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforce_fort, false);

-------------------------------------------------------------------------------------------------
----------------------------------- CAPTURE POINT LOCATIONS -------------------------------------
-------------------------------------------------------------------------------------------------

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp1");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp2");
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp3");

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("objective_02", 10000);

gb:message_on_time_offset("skv_01_reinforce", 3000);
gb:message_on_time_offset("skv_02_reinforce", 120000);
gb:message_on_time_offset("skv_03_reinforce", 180000);

-------------------------------------------------------------------------------------------------
----------------------------------- CAPTURE POINT LOCATIONS -------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_capture_location_capture_completed("cp_1_owned", "start", "cp1", nil, ga_ai_miao_ying, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_2_owned", "start", "cp2", nil, ga_ai_miao_ying, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_3_owned", "start", "cp3", nil, ga_ai_miao_ying, ga_player_01);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ally_01:reinforce_on_message("skv_01_reinforce");
ga_ai_ally_01:message_on_any_deployed("skv_ally_01_in");
ga_ai_ally_01:attack_on_message("skv_ally_01_in");

ga_ai_ally_02:reinforce_on_message("skv_02_reinforce");
ga_ai_ally_02:message_on_any_deployed("skv_ally_02_in");
ga_ai_ally_02:attack_on_message("skv_ally_02_in");

ga_ai_ally_03:reinforce_on_message("skv_03_reinforce");
ga_ai_ally_03:message_on_any_deployed("skv_ally_03_in");
ga_ai_ally_03:attack_on_message("skv_ally_03_in");

-- local wall_01_pos = v(-200, 695)
-- local wall_02_pos = v(0, 695)
-- local wall_03_pos = v(200, 695)

gb:add_listener(
    "cp_1_owned",
	function()
		if ga_ai_ally_01.sunits:are_any_active_on_battlefield() == true then
			yuan_bo_unit = yuan_bo.unit

			if yuan_bo_unit:number_of_men_alive() == 1 then		
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_01_1", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", yuan_bo_pos);
				sm:trigger_message("nuke_01_1");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_01", 5000, 100, true);
			else
				get_skv_01_nuke_positions()
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_01_2", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", skv_01_pos);
				sm:trigger_message("nuke_01_2");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_02", 5000, 100, true);
			end
		end
	end
)

function get_skv_01_nuke_positions()
	yuan_bo_unit = yuan_bo.unit
	yuan_bo_pos = yuan_bo_unit:position()

	skv_01_unit = skv_01.unit
	skv_01_pos = skv_01_unit:position()
end

gb:add_listener(
    "cp_2_owned",
	function()
		if ga_ai_ally_02.sunits:are_any_active_on_battlefield() == true then
			miao_ying_unit = miao_ying.unit

			if miao_ying_unit:number_of_men_alive() == 1 then		
				get_skv_02_nuke_positions()
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_02_1", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", miao_ying_pos);
				sm:trigger_message("nuke_02_1");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_01", 5000, 100, true);
			else
				get_skv_02_nuke_positions()
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_02_2", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", skv_02_pos);
				sm:trigger_message("nuke_02_2");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_02", 5000, 100, true);
			end
		end
	end
)

function get_skv_02_nuke_positions()
	miao_ying_unit = miao_ying.unit
	miao_ying_pos = miao_ying_unit:position()

	skv_02_unit = skv_02.unit
	skv_02_pos = skv_02_unit:position()
end

gb:add_listener(
    "cp_3_owned",
	function()
		if ga_ai_ally_03.sunits:are_any_active_on_battlefield() == true then
			zhao_ming_unit = zhao_ming.unit

			if zhao_ming_unit:number_of_men_alive() == 1 then		
				get_skv_03_nuke_positions()
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_03_1", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", zhao_ming_pos);
				sm:trigger_message("nuke_03_1");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_01", 5000, 100, true);
			else
				get_skv_03_nuke_positions()
				ga_ai_ally_01:use_army_special_ability_on_message("nuke_03_2", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_doom_rocket", skv_03_pos);
				sm:trigger_message("nuke_03_2");
				bm:queue_help_message("wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_skv_02", 5000, 100, true);
			end
		end
	end
)

function get_skv_03_nuke_positions()
	zhao_ming_unit = zhao_ming.unit
	zhao_ming_pos = zhao_ming_unit:position()
	
	skv_03_unit = skv_03.unit
	skv_03_pos = skv_03_unit:position()
end

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_miao_ying:attack_on_message("hint_01");
ga_ai_miao_ying:message_on_rout_proportion("miao_ying_weak", 0.2);
ga_ai_miao_ying:message_on_rout_proportion("miao_ying_weaker", 0.4);
ga_ai_miao_ying:message_on_rout_proportion("miao_ying_defeated", 0.99);

gb:add_listener(
	"miao_ying_defeated",
	function()
		if ga_ai_miao_ying.sunits:are_any_active_on_battlefield() == true then
			ga_ai_miao_ying.sunits:rout_over_time(5000);
		end;
	end,
	true
);

ga_ai_zhao_ming:reinforce_on_message("miao_ying_weak");
ga_ai_zhao_ming:message_on_any_deployed("zhao_ming_in");
ga_ai_zhao_ming:rush_on_message("zhao_ming_in");
ga_ai_zhao_ming:message_on_rout_proportion("zhao_ming_defeated", 0.99);

gb:add_listener(
	"zhao_ming_defeated",
	function()
		if ga_ai_zhao_ming.sunits:are_any_active_on_battlefield() == true then
			ga_ai_zhao_ming.sunits:rout_over_time(5000);
		end;
	end,
	true
);

ga_ai_yuan_bo:reinforce_on_message("miao_ying_weaker");
ga_ai_yuan_bo:message_on_any_deployed("yuan_bo_in");
ga_ai_yuan_bo:rush_on_message("yuan_bo_in");
ga_ai_yuan_bo:message_on_rout_proportion("yuan_bo_defeated", 0.99);

gb:add_listener(
	"yuan_bo_defeated",
	function()
		if ga_ai_yuan_bo.sunits:are_any_active_on_battlefield() == true then
			ga_ai_yuan_bo.sunits:rout_over_time(5000);
		end;
	end,
	true
);

ga_ai_reinforce:deploy_at_random_intervals_on_message(
	"objective_01", 			-- message
	2, 							-- min units
	2, 							-- max units
	90000, 						-- min period
	90000, 						-- max period
	"gates_taken", 				-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_reinforce:message_on_any_deployed("cth_fort_in");
ga_ai_reinforce:rush_on_message("cth_fort_in");

gb:message_on_all_messages_received("gates_taken", "cp_1_owned", "cp_2_owned", "cp_3_owned");
gb:message_on_all_messages_received("cth_dead", "miao_ying_defeated", "zhao_ming_defeated", "yuan_bo_defeated");
gb:message_on_all_messages_received("game_over", "cth_dead", "gates_taken");

gb:add_listener(
	"cp_1_owned",
	function()
		capture_point_01:set_locked(true);
	end
);

gb:add_listener(
	"cp_2_owned",
	function()
		capture_point_02:set_locked(true);
	end
);

gb:add_listener(
	"cp_3_owned",
	function()
		capture_point_03:set_locked(true);
	end
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_objective_01");
gb:complete_objective_on_message("cth_dead", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_objective_01");

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_objective_02");
gb:complete_objective_on_message("gates_taken", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_objective_02");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_01");
gb:queue_help_on_message("zhao_ming_in", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_02");
gb:queue_help_on_message("yuan_bo_in", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_03");
gb:queue_help_on_message("gates_taken", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_05");

gb:queue_help_on_message("skv_ally_01_in", "wh3_dlc24_tze_changeling_theatre_scheme_grand_cathay_hint_04");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:force_victory_on_message("game_over", 5000);