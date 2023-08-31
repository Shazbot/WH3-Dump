-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Badlands & Southlands
-- Black Pyramid
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm = battle_manager:new(empire_battle:new());

local sm = get_messager();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                 	     		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "caster_01");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "caster_02");
ga_ai_ally_03 = gb:get_army(gb:get_player_alliance_num(), "caster_03");

ga_ai_start = gb:get_army(gb:get_non_player_alliance_num(), "tmb_start");
ga_ai_reinforce_01 = gb:get_army(gb:get_non_player_alliance_num(), "tmb_reinforce_01");
ga_ai_reinforce_02 = gb:get_army(gb:get_non_player_alliance_num(), "tmb_reinforce_02");
ga_ai_reinforce_03 = gb:get_army(gb:get_non_player_alliance_num(), "tmb_reinforce_03");

caster_01 = ga_ai_ally_01.sunits:item(1);
caster_02 = ga_ai_ally_02.sunits:item(1);
caster_03 = ga_ai_ally_03.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_reinforce_01:get_army():suppress_reinforcement_adc(1);
ga_ai_reinforce_02:get_army():suppress_reinforcement_adc(1);
ga_ai_reinforce_03:get_army():suppress_reinforcement_adc(1);

local reinforcements = bm:reinforcements();

reinforce_base = bm:get_spawn_zone_collection_by_name("tmb_base");
reinforce_sides = bm:get_spawn_zone_collection_by_name("tmb_side");

reinforce_ally_01 = bm:get_spawn_zone_collection_by_name("ally_spawn_01");
reinforce_ally_02 = bm:get_spawn_zone_collection_by_name("ally_spawn_02");
reinforce_ally_03 = bm:get_spawn_zone_collection_by_name("ally_spawn_03");

ga_ai_ally_01:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_01, false);
ga_ai_ally_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_02, false);
ga_ai_ally_03:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_03, false);

ga_ai_reinforce_01:assign_to_spawn_zone_from_collection_on_message("start", reinforce_base, false);
ga_ai_reinforce_01:message_on_number_deployed("tmb_reinforce_01_deployed", true, 1);
ga_ai_reinforce_01:assign_to_spawn_zone_from_collection_on_message("tmb_reinforce_01_deployed", reinforce_base, false);

ga_ai_reinforce_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_sides, false);
ga_ai_reinforce_02:message_on_number_deployed("tmb_reinforce_02_deployed", true, 1);
ga_ai_reinforce_02:assign_to_spawn_zone_from_collection_on_message("tmb_reinforce_02_deployed", reinforce_sides, false);

ga_ai_reinforce_03:assign_to_spawn_zone_from_collection_on_message("start", reinforce_base, false);
ga_ai_reinforce_03:message_on_number_deployed("tmb_reinforce_03_deployed", true, 1);
ga_ai_reinforce_03:assign_to_spawn_zone_from_collection_on_message("tmb_reinforce_03_deployed", reinforce_base, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "tmb_base") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "tmb_side") then
		line:enable_random_deployment_position();		
	end	
	
	if (line:script_id() == "ally_spawn") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------------------------------------------------------------
----------------------------------- CAPTURE POINT LOCATIONS -------------------------------------
-------------------------------------------------------------------------------------------------

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp1");
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp2");
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp3");

capture_point_01:change_holding_army(ga_ai_start.army);
capture_point_01:set_locked(true);

capture_point_02:change_holding_army(ga_ai_start.army);
capture_point_02:set_locked(true);

capture_point_03:change_holding_army(ga_ai_start.army);
capture_point_03:set_locked(true);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

local speed_01 = 20000;
local speed_02 = 30000;
local speed_03 = 40000;

local perpetual = true;
local shattered_only = true;
local permit_rampaging = true;

-- local cp1_waypoint = v(128, 499, 272);
local cp1_waypoint = capture_point_01:position();
-- local cp2_waypoint = v(-65, 495, 272);
local cp2_waypoint = capture_point_02:position();
-- local cp3_waypoint = v(-240, 508, 272);
local cp3_waypoint = capture_point_03:position();

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"caster_01_in_place",
	function()
		caster_01:add_ping_icon(15);
	end
);

gb:add_listener(
	"caster_02_in_place",
	function()
		caster_02:add_ping_icon(15);
	end
);

gb:add_listener(
	"caster_03_in_place",
	function()
		caster_03:add_ping_icon(15);
	end
);

ga_ai_ally_01:reinforce_on_message("objective_01")
ga_ai_ally_01:message_on_deployed("tze_ally_01_in");
ga_ai_ally_01:move_to_position_on_message("tze_ally_01_in", cp1_waypoint);
ga_ai_ally_01:message_on_proximity_to_position("caster_01_in_place", v(112, 499, 272), 35)
ga_ai_ally_01:defend_on_message("caster_01_in_place", 112, 272, 5); 
ga_ai_ally_01:message_on_rout_proportion("caster_01_dead",0.99);

ga_ai_ally_01:message_on_rout_proportion("caster_01_wounded",0.4);
ga_ai_ally_01:move_to_position_on_message("caster_01_wounded", cp1_waypoint);
ga_ai_ally_01:message_on_proximity_to_position("caster_01_wounded_in_place", v(112, 499, 272), 35)
ga_ai_ally_01:defend_on_message("caster_01_wounded_in_place", 112, 272, 5); 

ga_ai_ally_02:reinforce_on_message("objective_01")
ga_ai_ally_02:message_on_deployed("tze_ally_02_in");
ga_ai_ally_02:move_to_position_on_message("tze_ally_02_in", cp2_waypoint);
ga_ai_ally_02:message_on_proximity_to_position("caster_02_in_place", v(-64, 495, 272), 35)
ga_ai_ally_02:defend_on_message("caster_02_in_place", -64, 272, 5); 
ga_ai_ally_02:message_on_rout_proportion("caster_02_dead",0.99);

ga_ai_ally_02:message_on_rout_proportion("caster_02_wounded",0.4);
ga_ai_ally_02:move_to_position_on_message("caster_02_wounded", cp2_waypoint);
ga_ai_ally_02:message_on_proximity_to_position("caster_02_wounded_in_place", v(-64, 495, 272), 35)
ga_ai_ally_02:defend_on_message("caster_02_wounded_in_place", -64, 272, 5); 

ga_ai_ally_03:reinforce_on_message("objective_01")
ga_ai_ally_03:message_on_deployed("tze_ally_03_in");
ga_ai_ally_03:move_to_position_on_message("tze_ally_03_in", cp3_waypoint);
ga_ai_ally_03:message_on_proximity_to_position("caster_03_in_place", v(-240, 508, 272), 35)
ga_ai_ally_03:defend_on_message("caster_03_in_place", -240, 272, 5); 
ga_ai_ally_03:message_on_rout_proportion("caster_03_dead",0.99);

ga_ai_ally_03:message_on_rout_proportion("caster_03_wounded",0.4);
ga_ai_ally_03:move_to_position_on_message("caster_03_wounded", cp3_waypoint);
ga_ai_ally_03:message_on_proximity_to_position("caster_03_wounded_in_place", v(-240, 508, 272), 35)
ga_ai_ally_03:defend_on_message("caster_02_wounded_in_place", -240, 272, 5); 

gb:message_on_capture_location_capture_completed("cp_1_owned", "objective_01", "cp1", nil, ga_ai_start, ga_ai_ally_01);
gb:message_on_capture_location_capture_completed("cp_2_owned", "objective_01", "cp2", nil, ga_ai_start, ga_ai_ally_02);
gb:message_on_capture_location_capture_completed("cp_3_owned", "objective_01", "cp3", nil, ga_ai_start, ga_ai_ally_03);

gb:add_listener(
	"caster_01_in_place",
	function()
		capture_point_01:set_locked(false);
		capture_point_01:change_holding_army(ga_ai_ally_01.army);
		capture_point_01:set_locked(true);
	end
);

gb:add_listener(
	"caster_02_in_place",
	function()
		capture_point_02:set_locked(false);
		capture_point_02:change_holding_army(ga_ai_ally_02.army);
		capture_point_02:set_locked(true);
	end
);

gb:add_listener(
	"caster_03_in_place",
	function()
		capture_point_03:set_locked(false);
		capture_point_03:change_holding_army(ga_ai_ally_03.army);
		capture_point_03:set_locked(true);
	end
);

ga_player_01:message_on_commander_death("changeling_dead");

gb:message_on_all_messages_received("casters_in_place", "caster_01_in_place", "caster_02_in_place", "caster_03_in_place");
gb:message_on_all_messages_received("casters_dead", "caster_01_dead", "caster_02_dead", "caster_03_dead");

gb:add_listener(
	"caster_01_dead",
	function()
		capture_point_01:set_enabled(false);	
	end
);

gb:add_listener(
	"caster_02_dead",
	function()
		capture_point_02:set_enabled(false);	
	end
);

gb:add_listener(
	"caster_03_dead",
	function()
		capture_point_03:set_enabled(false);	
	end
);

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start:rush_on_message("hint_01");
ga_ai_start:message_on_rout_proportion("tmb_start_dead",0.99);

function spawn_tmb_01()
	ga_ai_reinforce_01:deploy_at_random_intervals_on_message(
		"start", 					-- message
		1, 							-- min units
		1, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"help_04", 					-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

spawn_tmb_01()
ga_ai_reinforce_01:message_on_any_deployed("tmb_01_in");
ga_ai_reinforce_01:rush_on_message("tmb_01_in");

function spawn_tmb_02()
	ga_ai_reinforce_02:deploy_at_random_intervals_on_message(
		"start", 					-- message
		1, 							-- min units
		1, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"help_04", 					-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end


spawn_tmb_02()
ga_ai_reinforce_02:message_on_any_deployed("tmb_02_in");
ga_ai_reinforce_02:rush_on_message("tmb_02_in");

function spawn_tmb_03()
	ga_ai_reinforce_03:deploy_at_random_intervals_on_message(
		"start", 					-- message
		1, 							-- min units
		1, 							-- max units
		speed_03, 					-- min period
		speed_03, 					-- max period
		"help_04", 					-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

spawn_tmb_03()
ga_ai_reinforce_03:message_on_any_deployed("tmb_03_in");
ga_ai_reinforce_03:rush_on_message("tmb_03_in");

gb:add_listener(
	"scheme_complete",
	function()
		if ga_ai_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_start.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_reinforce_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_reinforce_01.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_reinforce_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_reinforce_02.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_reinforce_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_reinforce_03.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_objective_01");
gb:complete_objective_on_message("tmb_start_dead", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_objective_01");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_hint_01");
gb:queue_help_on_message("casters_in_place", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_hint_02");
gb:queue_help_on_message("help_03", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_hint_03");
gb:queue_help_on_message("help_04", "wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_hint_04");

final_obj_time = 2500
update_value = 8

gb:add_listener(
    "caster_01_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "caster_02_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "caster_03_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "changeling_dead",
	function()
		update_value = update_value -1
    end,
	true
)

gb:add_listener(
    "casters_in_place",
	function()
		bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_objective_02", final_obj_time)
		
		bm:repeat_callback(
			function()
				final_obj_time = final_obj_time - update_value

				if final_obj_time <= 1750 then
					sm:trigger_message("help_03");
				end

				if final_obj_time <= 500 then
					sm:trigger_message("help_04");
				end

				if final_obj_time <= 0 then			
					if ga_ai_start.sunits:are_any_active_on_battlefield() == true then
						ga_ai_start.sunits:kill_proportion_over_time(1.0, 30000, false);
					end;
					
					if ga_ai_reinforce_01.sunits:are_any_active_on_battlefield() == true then
						ga_ai_reinforce_01.sunits:kill_proportion_over_time(1.0, 30000, false);
					end;

					if ga_ai_reinforce_02.sunits:are_any_active_on_battlefield() == true then
						ga_ai_reinforce_02.sunits:kill_proportion_over_time(1.0, 30000, false);
					end;

					if ga_ai_reinforce_03.sunits:are_any_active_on_battlefield() == true then
						ga_ai_reinforce_03.sunits:kill_proportion_over_time(1.0, 30000, false);
					end;

					bm:complete_objective("wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_objective_02")
					sm:trigger_message("end_this");
					bm:remove_callback("end_countdown")
				else
					bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_badlands_and_southlands_objective_02", final_obj_time)
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

function update_reinforcements()
	local speed_01 = 40000;
	local speed_02 = 60000;
	local speed_03 = 80000;

	spawn_tmb_01()
	spawn_tmb_02()
	spawn_tmb_03()
end

ga_player_01:message_on_rout_proportion("player_dead",0.99);

gb:add_listener(
	"player_dead",
	function()
		if ga_ai_ally_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_01.sunits:teleport_withdraw_over_time(2500);
		end;

		if ga_ai_ally_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_02.sunits:teleport_withdraw_over_time(2500);
		end;

		if ga_ai_ally_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_03.sunits:teleport_withdraw_over_time(2500);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start:force_victory_on_message("player_dead", 5000);

ga_player_01:force_victory_on_message("end_this", 10000);