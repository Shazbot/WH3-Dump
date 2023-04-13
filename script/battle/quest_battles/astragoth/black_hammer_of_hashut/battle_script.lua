-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Astragoth
-- Black Hammer of Hashut
-- dar_infield tile 12
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

gb = generated_battle:new(
	false,                                      	-- screen starts black
	false,                                      	-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
)

gb:set_cutscene_during_deployment(true);


-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Astragoth_Black_Hammer_of_Hashut_Sweetener");

wh3_main_sfx_01 = new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_03");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/black_hammer_of_hashut_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
		end, 
		200
	);

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_01"));
				bm:show_subtitle("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_02"));
				bm:show_subtitle("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_03"));
				bm:show_subtitle("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_pt_03", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	payload_sunit:add_ping_icon(15)
	trigger_astragoth_starting_objectives()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- VARIABLES -------------------------------------------
-------------------------------------------------------------------------------------------------

payload_exit_reached = false

payload_waypoint_1 = v(-14, 908, -268)
payload_waypoint_2 = v(-138, 908, -162)
payload_waypoint_3 = v(-238, 908, 7)
payload_waypoint_4 = v(-310, 908, 317)
payload_waypoint_5 = v(-412, 908, 600)
payload_waypoint_6 = v(-516, 908, 741)

wave_status = {
	wave_1 = {started = false, complete = false, unit_status = nil},
	wave_2 = {started = false, complete = false, unit_status = nil},
	wave_3 = {started = false, complete = false, unit_status = nil}
}

current_waypoint = payload_waypoint_1
current_waypoint_number = 1

final_obj_time = 250

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "")

--Payload
ga_payload = gb:get_army(gb:get_player_alliance_num(), "player_ally")

payload_sunit = ga_payload.sunits:item(1)
payload_uc = payload_sunit.uc

payload_sunit:set_stat_attribute("unbreakable", true)
payload_sunit:modify_ammo(0)

--Enemy Armies
ga_enemy_goblins_rush = gb:get_army(gb:get_non_player_alliance_num(), "enemy_1_rush")
ga_enemy_goblins_attackers = gb:get_army(gb:get_non_player_alliance_num(), "enemy_1_payload_attacker")

ga_enemy_greenskins_rush = gb:get_army(gb:get_non_player_alliance_num(), "enemy_3_rush")
ga_enemy_greenskins_attackers = gb:get_army(gb:get_non_player_alliance_num(), "enemy_3_payload_attacker")

ga_enemy_ogres_rush = gb:get_army(gb:get_non_player_alliance_num(), "enemy_2_rush")
ga_enemy_ogres_attackers = gb:get_army(gb:get_non_player_alliance_num(), "enemy_2_payload_attacker")

wave_1 = {
	-- 3 gnoblars
	{sunit = ga_enemy_ogres_rush.sunits:item(2), v = v(-58, -484), rotation = 19.48057, width = 35.50},
	{sunit = ga_enemy_ogres_rush.sunits:item(3), v = v(-152, -421), rotation = 57.86874, width = 41.50},
	{sunit = ga_enemy_ogres_rush.sunits:item(4), v = v(-114.39, -460), rotation = 34.95043, width = 38.50},
	-- 1 goblin archer
	{sunit = ga_enemy_goblins_attackers.sunits:item(1), v = v(32.61, -445.737), rotation = 22.9183, width = 19.00}
}

wave_2 = {
	-- Fat-Nose Scurry
	{sunit = ga_enemy_goblins_rush.sunits:item(1), v = v(30, 0), rotation = 235.4857, width = 1.56},
	-- 3 skulkers
	{sunit = ga_enemy_goblins_rush.sunits:item(2), v = v(41, -12), rotation = 235.4857, width = 28.00},
	{sunit = ga_enemy_goblins_rush.sunits:item(3), v = v(8, 29), rotation = 228.0372, width = 29.50},
	{sunit = ga_enemy_goblins_rush.sunits:item(4), v = v(61, -57), rotation = 250.3826, width = 31.00},
	-- 3 goblin archer
	{sunit = ga_enemy_goblins_attackers.sunits:item(2), v = v(99.87, -184.47), rotation = 218.8699, width = 34.00},
	{sunit = ga_enemy_goblins_attackers.sunits:item(4), v = v(72.12, -162.19), rotation = 217.724, width = 31.00},
	{sunit = ga_enemy_goblins_attackers.sunits:item(6), v = v(47.08, -138.41), rotation = 225.7454, width = 31.00},
	-- 2 orc boyz
	{sunit = ga_enemy_goblins_rush.sunits:item(5), v = v(-331, -227), rotation = 57.2958, width = 40.50},
	{sunit = ga_enemy_goblins_rush.sunits:item(6), v = v(-364, -168), rotation = 68.7549, width = 40.50},
	-- 2 goblin archers
	{sunit = ga_enemy_goblins_attackers.sunits:item(3), v = v(-369, -252), rotation = 58.4417, width = 41.50},
	{sunit = ga_enemy_goblins_attackers.sunits:item(5), v = v(-397.31, -183.75), rotation = 68.18198, width = 37.00},
}

wave_3 = {
	-- The Suntanz Kid
	{sunit = ga_enemy_ogres_rush.sunits:item(1), v = v(-429, 214), rotation = 115.1645, width = 7.54},
	-- 2 goblin riders
	{sunit = ga_enemy_goblins_rush.sunits:item(10), v = v(-372, -385), rotation = 305.9595, width = 39.60},
	{sunit = ga_enemy_goblins_rush.sunits:item(11), v = v(385, -125), rotation = 307.6783, width = 39.60},
	-- 1 boar boyz
	{sunit = ga_enemy_greenskins_rush.sunits:item(17), v = v(379, -182), rotation = 304.8135, width = 36.60},
	-- 2 rock lobbers
	{sunit = ga_enemy_greenskins_attackers.sunits:item(1), v = v(-39.79, 301), rotation = 250.3826, width = 32.10},
	{sunit = ga_enemy_greenskins_attackers.sunits:item(2), v = v(-20.02, 222), rotation = 264.1335, width = 32.10},
	-- maneaters_0
	{sunit = ga_enemy_ogres_rush.sunits:item(5), v = v(-76, 294), rotation = 242.9341, width = 38.40},
	-- maneaters_1
	{sunit = ga_enemy_ogres_rush.sunits:item(6), v = v(-57, 206), rotation = 262.9876, width = 32.40},
	-- maneaters_2
	{sunit = ga_enemy_ogres_rush.sunits:item(7), v = v(-494, 154), rotation = 88.2355, width = 28.00},
	-- 1 leadbeltchers
	{sunit = ga_enemy_ogres_attackers.sunits:item(1), v = v(-105.95, 96.49), rotation = 230.902, width = 32.40},
}

wave_4 = {
	-- 3 orc boyz
	{sunit = ga_enemy_goblins_rush.sunits:item(7), v = v(-219, -61), rotaation = 350, width = 40.50},
	{sunit = ga_enemy_goblins_rush.sunits:item(8), v = v(-175, -33), rotation = 350, width = 40.50},
	{sunit = ga_enemy_goblins_rush.sunits:item(9), v =  v(-121, -12), rotation = 350, width = 40.50},
	-- Butch Cazzadie
	{sunit = ga_enemy_greenskins_rush.sunits:item(1), v = v(-522.64, 414.45), rotation = 61, width = 1.56},
	-- 2 black orcs
	{sunit = ga_enemy_greenskins_rush.sunits:item(2), v = v(-505.21, 395.07), rotation = 61, width = 30.20},
	{sunit = ga_enemy_greenskins_rush.sunits:item(3), v = v(-527.32, 442.25), rotation = 63, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(4), v = v(-555, 367), rotation = 63, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(5), v = v(-411, 146), rotation = 63, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(6), v = v(-390, 112), rotation = 63, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(7), v = v(-103, 226), rotation = 260, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(8), v = v(-105, 271), rotation = 260, width = 27.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(9), v = v(-203, 28), rotation = 350, width = 27.60},
	-- 3 big uns
	{sunit = ga_enemy_greenskins_rush.sunits:item(10), v = v(-443, 145), rotation = 63, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(11), v = v(-427, 114), rotation = 63, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(12), v = v(-77, 225), rotation = 63, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(13), v = v(-84, 275), rotation = 63, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(14), v = v(-251, -32), rotation = 350, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(15), v = v(-197, -3), rotation = 350, width = 40.60},
	{sunit = ga_enemy_greenskins_rush.sunits:item(16), v = v(-153, 27), rotation = 350, width = 40.60},
	-- 1 rogue idol
	{sunit = ga_enemy_greenskins_rush.sunits:item(18), v = v(-491.00, 429.61), rotation = 53.85803, width = 8.00}
}


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("battle_start_teleport_units() called")

	-- Payload unit setup
	payload_uc:teleport_to_location(v(223, -457), 320, 3.06)
	payload_uc:take_control()

	-- disable and hide all enemy units
	ga_enemy_goblins_rush:set_enabled(false)
	ga_enemy_greenskins_rush:set_enabled(false)
	ga_enemy_ogres_rush:set_enabled(false)
	ga_enemy_goblins_attackers:set_enabled(false)
	ga_enemy_greenskins_attackers:set_enabled(false)
	ga_enemy_ogres_attackers:set_enabled(false)

	bm:get_closest_capture_location(v(-379, 911, 596)):change_holding_army(bm:alliances():item(1):armies():item(1))
end

battle_start_teleport_units()

-------------------------------------------------------------------------------------------------
-------------------------------------------- TRIGGERS -------------------------------------------
-------------------------------------------------------------------------------------------------

function add_payload_spawn_trigger(message, x, y, z)
	local vec = v(x, y, z)
	ga_payload:message_on_proximity_to_position(message, vec, 50)
end

function add_player_spawn_trigger(message, x, y, z)
	local vec = v(x, y, z)
	ga_player:message_on_proximity_to_position(message, vec, 50)
end

add_payload_spawn_trigger("spawn_first_wave", -13, 924, -379)
add_payload_spawn_trigger("spawn_first_wave", -9, 917, -335)
add_payload_spawn_trigger("spawn_first_wave", 1, 907, -297)
add_payload_spawn_trigger("spawn_first_wave", 24, 906, -265)
add_payload_spawn_trigger("spawn_first_wave", 48, 906, -227)

add_player_spawn_trigger("spawn_first_wave", -24, 940, -460)
add_player_spawn_trigger("spawn_first_wave", -71, 946, -455)
add_player_spawn_trigger("spawn_first_wave", -118, 951, -446)
add_player_spawn_trigger("spawn_first_wave", -162, 955, -429)

add_payload_spawn_trigger("spawn_second_wave", -225, 931, -212)
add_payload_spawn_trigger("spawn_second_wave", -189, 916, -186)
add_payload_spawn_trigger("spawn_second_wave", -156, 909, -172)
add_payload_spawn_trigger("spawn_second_wave", -118, 905, -147)
add_payload_spawn_trigger("spawn_second_wave", -86, 903, -122)
add_payload_spawn_trigger("spawn_second_wave", -37, 908, -115)

add_player_spawn_trigger("spawn_second_wave", -308, 953, -282)
add_player_spawn_trigger("spawn_second_wave", -335, 954, -242)
add_player_spawn_trigger("spawn_second_wave", -356, 953, -199)
add_player_spawn_trigger("spawn_second_wave", -371, 954, -153)
add_player_spawn_trigger("spawn_second_wave", 46, 935, -67)
add_player_spawn_trigger("spawn_second_wave", 18, 939, -28)
add_player_spawn_trigger("spawn_second_wave", -10, 935, 12)
add_player_spawn_trigger("spawn_second_wave", -35, 938, 55)
add_player_spawn_trigger("spawn_second_wave", -294, 958, -320)
add_player_spawn_trigger("spawn_second_wave", -321, 964, -359)
add_player_spawn_trigger("spawn_second_wave", -357, 965, -392)
add_player_spawn_trigger("spawn_second_wave", -392, 969, -425)
add_player_spawn_trigger("spawn_second_wave", -430, 970, -454)
add_player_spawn_trigger("spawn_second_wave", -467, 970, -488)

add_payload_spawn_trigger("spawn_third_wave", -383, 934, 119)
add_payload_spawn_trigger("spawn_third_wave", -346, 923, 146)
add_payload_spawn_trigger("spawn_third_wave", -306, 914, 166)
add_payload_spawn_trigger("spawn_third_wave", -263, 910, 179)
add_payload_spawn_trigger("spawn_third_wave", -223, 908, 190)
add_payload_spawn_trigger("spawn_third_wave", -182, 914, 195)

add_player_spawn_trigger("spawn_third_wave", -473, 956, 91)
add_player_spawn_trigger("spawn_third_wave", -470, 954, 138)
add_player_spawn_trigger("spawn_third_wave", -464, 953, 201)

-- Spawn final wave ONLY when payload reaches target
ga_payload:message_on_proximity_to_position("spawn_final_wave", v(-379, 908, 596), 60)
ga_player:message_on_proximity_to_position("spawn_final_wave", v(-552, 908, 402), 100)

-- Payload movement waypoints
ga_payload:message_on_proximity_to_position("payload_waypoint_1", payload_waypoint_1, 50)
ga_payload:message_on_proximity_to_position("payload_waypoint_2", payload_waypoint_2, 50)
ga_payload:message_on_proximity_to_position("payload_waypoint_3", payload_waypoint_3, 50)
ga_payload:message_on_proximity_to_position("payload_waypoint_4", payload_waypoint_4, 50)
ga_payload:message_on_proximity_to_position("payload_waypoint_5", payload_waypoint_5, 50)
ga_payload:message_on_proximity_to_position("payload_waypoint_6", payload_waypoint_6, 20)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

function move_payload_when_idle()
	bm:watch(
		function()
			return true
		end,
		3000,
		function()
			local pl_unit = ga_payload.sunits:get_unit_table()[1]
			
			if pl_unit:is_valid_target() then
				if(current_waypoint_number >= 2 and wave_status.wave_1.started == true and wave_status.wave_1.complete == false) then
					bm:out("waiting for wave 1 clear before moving train")
					payload_uc:halt()
				elseif(current_waypoint_number >= 3 and wave_status.wave_2.started == true and wave_status.wave_2.complete == false) then
					bm:out("waiting for wave 2 clear before moving train")
					payload_uc:halt()
				elseif(current_waypoint_number >= 3 and wave_status.wave_3.started == true and wave_status.wave_3.complete == false) then
					bm:out("waiting for wave 3 clear before moving train")
					payload_uc:halt()
				else
					if pl_unit:is_in_melee() == false and pl_unit:is_moving() == false then
						bm:out("train not moving or in melee")
						payload_uc:goto_location(current_waypoint, true)
					elseif(pl_unit:is_in_melee() == true) then
						bm:out("is in melee")
					elseif(pl_unit:is_moving() == true) then
						bm:out("is moving")
					end
				end

				if payload_exit_reached == false then
					move_payload_when_idle()
				end
			end
		end,
		"payload_behaviour"
	)
end

function wave_defeated_check(wave, wave_units)
	bm:watch(
		function()
			return true
		end,
		3000,
		function()
			if (wave.unit_status == nil) then
				wave.unit_status = {}

				for k, v in ipairs(wave_units) do
					local sunit = v.sunit
					table.insert(wave.unit_status, {
						sunit = sunit, 
						alive = true
					})
					wave.unit_status.dead_count = 0
				end
			end

			local target = #wave.unit_status
			bm:out("-----------------------------")
			for k, v in ipairs(wave.unit_status) do
				local sunit = v.sunit
				bm:out(tostring(v.alive))
				if (v.alive == true and is_routing_or_dead(sunit)) then
					bm:out("killing this guy off")
					v.alive = false
					wave.unit_status.dead_count = wave.unit_status.dead_count + 1
					sunit:morale_behavior_rout()
					sunit:kill_proportion_over_time(1, 10000)
				end
			end
			
			if(wave.unit_status.dead_count >= target) then
				wave.complete = true

				if(wave == wave_status.wave_1) then
					bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_1")
					bm:callback(function()
						bm:remove_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_1")
					end, 15000)
				elseif(wave == wave_status.wave_2) then
					bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_2")
					bm:callback(function()
						bm:remove_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_2")
					end, 15000)
				elseif(wave == wave_status.wave_3) then
					bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_3")
					bm:callback(function()
						bm:remove_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_3")
					end, 15000)
				end
			end

			if wave.complete == false then
				wave_defeated_check(wave, wave_units)
			end
		end,
		"payload_behaviour"
	)
end

-------------------------------------------------------------------------------------------------
----------------------------------------- LISTENERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

function enable_unit_controller(uc)
	uc:change_enabled(true)
	uc:set_invisible_to_all(false)
	uc:release_control()
end

gb:add_listener(
    "spawn_first_wave",
	function()
		bm:out("Spawning first wave")	
		wave_status.wave_1.started = true
        for _, unit in ipairs(wave_1) do
			unit.sunit.uc:teleport_to_location(unit.v, unit.rotation, unit.width)
			unit.sunit:set_always_visible(true)
			enable_unit_controller(unit.sunit.uc)
			unit.sunit:start_attack_closest_enemy()
			wave_defeated_check(wave_status.wave_1, wave_1)
			bm:set_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_1")
		end
    end
)

gb:add_listener(
    "spawn_second_wave",
	function()
		bm:out("Spawning second wave")
		wave_status.wave_2.started = true
		for _, unit in ipairs(wave_2) do
			unit.sunit.uc:teleport_to_location(unit.v, unit.rotation, unit.width)
			unit.sunit:set_always_visible(true)
			enable_unit_controller(unit.sunit.uc)
			unit.sunit:start_attack_closest_enemy()
			wave_defeated_check(wave_status.wave_2, wave_2)
			bm:set_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_2")
		end
    end
)

gb:add_listener(
    "spawn_third_wave",
	function()
		bm:out("Spawning third wave")
		wave_status.wave_3.started = true
		for _, unit in ipairs(wave_3) do
			unit.sunit.uc:teleport_to_location(unit.v, unit.rotation, unit.width)
			unit.sunit:set_always_visible(true)
			enable_unit_controller(unit.sunit.uc)
			unit.sunit:start_attack_closest_enemy()
			wave_defeated_check(wave_status.wave_3, wave_3)
			bm:set_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_3")
		end
    end
)

gb:add_listener(
    "payload_waypoint_1",
	function()
		bm:out("Switching to waypoint 2")
		current_waypoint_number = 2
		current_waypoint = payload_waypoint_2
		payload_uc:goto_location(current_waypoint, true)
    end
)

gb:add_listener(
    "payload_waypoint_2",
	function()
		bm:out("Switching to waypoint 3")
		current_waypoint_number = 3
		current_waypoint = payload_waypoint_3
		payload_uc:goto_location(current_waypoint, true)
    end
)

gb:add_listener(
    "payload_waypoint_3",
	function()
		bm:out("Switching to waypoint 4")
		current_waypoint_number = 4
		current_waypoint = payload_waypoint_4
		payload_uc:goto_location(current_waypoint, true)
    end
)

gb:add_listener(
    "payload_waypoint_4",
	function()
		bm:out("Switching to waypoint 5")
		current_waypoint_number = 5
		current_waypoint = payload_waypoint_5
		payload_uc:goto_location(current_waypoint, true)
    end
)

gb:add_listener(
    "payload_waypoint_5",
	function()
		bm:out("Switching to waypoint 6")
		current_waypoint_number = 6
		current_waypoint = payload_waypoint_6
		payload_uc:goto_location(current_waypoint, true)
    end
)

gb:add_listener(
    "payload_waypoint_6",
	function()
		payload_exit_reached = true
		bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_1")
		payload_uc:change_enabled(false)
    end
)

gb:add_listener(
    "battle_started",
	function()
		move_payload_when_idle()
    end
)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

function trigger_astragoth_starting_objectives()
	-- Dont Let Train Die
	bm:set_locatable_objective_callback(
		"wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_1",
		function()
			local cam_targ = ga_payload.sunits:item(1).unit:position()
			local cam_pos = v_offset_by_bearing(
				cam_targ,
				get_bearing(cam_targ, bm:camera():position()),    	-- horizontal bearing from camera target to current camera position
				100,                                                -- distance from camera position to camera target
				d_to_r(30)                                        	-- vertical bearing from horizon to cam-targ/cam-pos line
			)
			return cam_pos, cam_targ
		end,
		1,
		false
	)

	-- Get Train to Exit
	bm:set_locatable_objective(
		"wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_2",
		v_offset_by_bearing(
			v(-379, 911, 596),
			get_bearing(v(-379, 911, 596), bm:camera():position()),    	-- horizontal bearing from camera target to current camera position
			100,                                                		-- distance from camera position to camera target
			d_to_r(30)                                        			-- vertical bearing from horizon to cam-targ/cam-pos line
		),
		v(-379, 911, 596),
		1,
		false
	)
end

-- Hold off against final wave
gb:add_listener(
    "spawn_final_wave",
	function()

		bm:out("Spawning final wave")

		for _, unit in ipairs(wave_4) do
			unit.sunit.uc:teleport_to_location(unit.v, unit.rotation, unit.width)
			unit.sunit:morale_behavior_fearless()
			unit.sunit:set_always_visible(true)

			enable_unit_controller(unit.sunit.uc)
			unit.sunit:start_attack_closest_enemy()
		end

		bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_2")
		bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_3")

		bm:callback(function()
			bm:remove_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_2")
			bm:remove_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_side_objective_3")
		end, 10000)

		bm:set_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_3", final_obj_time)

		bm:repeat_callback(
			function()
				-- count down final timer
				final_obj_time = final_obj_time - 1

				if final_obj_time < 0 then
					bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_1")
					bm:complete_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_3")
				

					bm:callback(
						function()
							-- end the battle after a short delay
							bm:out("end battle")
							sm:trigger_message("end_battle_victory")
						end,
						5000
					)
				else
					bm:set_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_3", final_obj_time)
				end
			end, 
			1000
		)
    end
)

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT --------------------------------------------
-------------------------------------------------------------------------------------------------

ga_payload:message_on_casualties("payload_dead", 0.99)
ga_player:message_on_casualties("player_dead", 0.99)

gb:add_listener(
    "payload_dead",
	function()
		bm:out("Payload has died")

		bm:callback(
			function()
				-- end the battle after a short delay
				bm:out("\tend battle")
				sm:trigger_message("end_battle_defeat")
			end,
			5000
		)

		bm:fail_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_1")
		bm:fail_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_2")
		bm:fail_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_3")
    end
)

gb:add_listener(
    "player_dead",
	function()
		bm:out("Player has died")

		bm:callback(
			function()
				-- end the battle after a short delay
				bm:out("end battle")
				bm:fail_objective("wh3_dlc23_qb_chd_astragoth_black_hammer_of_hashut_payload_objective_3")
				sm:trigger_message("end_battle_defeat")
			end,
			5000
		)
    end
)

ga_enemy_greenskins_rush:force_victory_on_message("end_battle_defeat", 3)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:force_victory_on_message("end_battle_victory", 10)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc23_chd_hellshard_amulet_02", 7000, 2000, 0)
--gb:queue_help_on_message("wave_1_released", "wh3_dlc23_chd_hellshard_amulet_03", 7000, 2000, 4000)
--gb:queue_help_on_message("wave_2_released", "wh3_dlc23_chd_hellshard_amulet_04", 7000, 2000, 0)