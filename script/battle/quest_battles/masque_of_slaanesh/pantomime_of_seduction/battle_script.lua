-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Masque of Slaanesh
-- By Matthieu Bonnet-Mille
-- Pantomime of Seduction

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)


-- gb:set_cutscene_during_deployment(true)

	
-------------------------------------------------------------------------------------------------
------------------------------------------- PHASE 1 CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC26_QB_Pantomime_Of_Seduction_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Pantomime_Of_Seduction_Intro", false, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC26_QB_Pantomime_Of_Seduction_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Pantomime_Of_Seduction_Mid", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")

	local cam = bm:camera();

	-- cutscene 1 phase 1
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_masque_sla_phase01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		1																				-- blend out time (s)
	);

	local player_units_hidden = false;
	-- Armies visible during cutscene and deployment
	ga_ai_nur_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ga_ai_nur_main_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ga_ai_emp_allies.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ga_ai_hef_allies.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ga_ai_sla_dancers.sunits:set_always_visible_no_hidden_no_leave_battle(true);

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
						
			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);

	----------------------------- ACTIONS
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			gb.sm:trigger_message("nur_main_1_rush")
		end, 
		45000 -- time at which the action triggers
	);
	cutscene_intro:action(
		function()
			gb.sm:trigger_message("nur_main_2_rush")
		end, 
		50000 -- time at which the action triggers
	);
	------------------------------

	-- add listeners for sound & subs here
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_01"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_01", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_02"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_02", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_03"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_03", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_04"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_04", false, true)
			end
	);

		cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_05"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_05", false, true)
			end
	);

		cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_06"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_06", false, true)
			end
	);

		cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_07", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase1_07"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_intro_07", false, true)
			end
	);

	------

	cutscene_intro:start();
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	gb.sm:trigger_message("nur_main_1_rush")
	gb.sm:trigger_message("nur_main_2_rush")
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- PHASE 2 CUTSCENE ------------------------------------------
-------------------------------------------------------------------------------------------------

function play_phase_2_cutscene()
	-- bm:camera():fade(true, 0)
	bm:out("\tplay_phase_2_cutscene() called")

	-- bm:callback(function() 
		local cam = bm:camera()

		local cutscene_phase_2 = cutscene:new_from_cindyscene(
			"cutscene_phase_2", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() phase_2_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_masque_sla_phase02.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			1																								-- blend out time (s)
		);

		local player_units_hidden = false;

		cutscene_phase_2:action(function() cam:fade(false, 1) end, 1000);

		cutscene_phase_2:action(
			function() 	
				-- ga_player.sunits:set_invisible_to_all(true)
				ga_ai_sla_dancers.sunits:set_invisible_to_all(true)
				ga_ai_nur_reinforce_strong:set_enabled(false)
				ga_player:set_enabled(false)
			end, 
			10
		);

		cutscene_phase_2:action(function() cam:fade(true, 0.4) end, 34600);
		cutscene_phase_2:action(
			function() 	
				cam:fade(false, 0.8)
				ga_player:set_enabled(true)
			end, 
			35000
		);

		cutscene_phase_2:action(
			function() 	
				gb.sm:trigger_message("end_cutscene_2")
				ga_ai_nur_reinforce_strong:set_enabled(true)
			end, 
			42000
		);

		-- set up subtitles
		local subtitles = cutscene_phase_2:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()

		-- skip callback
		cutscene_phase_2:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0)
				bm:stop_cindy_playback(true)

				if player_units_hidden then
					ga_player:set_enabled(false)
				end;

				bm:callback(function() 
					cam:fade(false, 0.5) 
					sm:trigger_message("phase_2_begins")
					gb.sm:trigger_message("end_cutscene_2")
				end, 500)
				bm:hide_subtitles()
			end
		)

		-- add listeners for sound & subs here
		cutscene_phase_2:action(function() cutscene_phase_2:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		
		cutscene_phase_2:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_01", 
			function()
				cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_01"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_mid_01", false, true)
			end
		);

		cutscene_phase_2:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_02", 
			function()
				cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_02"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_mid_02", false, true)
			end
		);

		cutscene_phase_2:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_03", 
			function()
				cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_03"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_mid_03", false, true)
			end
		);

		cutscene_phase_2:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_04", 
			function()
				cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_masque_pantomime_of_seduction_phase2_04"))
				bm:show_subtitle("wh3_dlc27_qb_sla_masque_pantomime_of_seduction_mid_04", false, true)
			end
		);

		------

		cutscene_phase_2:start()
	-- end, 1000)
end

function phase_2_cutscene_end()
	sm:trigger_message("phase_2_begins")
	
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	
	ga_ai_nur_reinforce_strong:set_enabled(true)
	ga_player:set_enabled(true)
	bm:hide_subtitles()
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1)

-- ga_player_reinforce = gb:get_army(gb:get_player_alliance_num(), "player_reinforce")

ga_ai_nur_main = gb:get_army(gb:get_non_player_alliance_num(), "nur_main")
ga_ai_nur_main_2 = gb:get_army(gb:get_non_player_alliance_num(), "nur_main_2")
ga_ai_nur_reinforce_01 = gb:get_army(gb:get_non_player_alliance_num(), "nur_portal_1_wave_1")
ga_ai_nur_reinforce_02 = gb:get_army(gb:get_non_player_alliance_num(), "nur_portal_2_wave_1")
ga_ai_nur_reinforce_03 = gb:get_army(gb:get_non_player_alliance_num(), "nur_portal_1_wave_2")
ga_ai_nur_reinforce_04 = gb:get_army(gb:get_non_player_alliance_num(), "nur_portal_2_wave_2")
ga_ai_nur_reinforce_strong = gb:get_army(gb:get_non_player_alliance_num(), "nur_reinforce")

ga_ai_emp_allies = gb:get_army(gb:get_player_alliance_num(), "emp_allies")
ga_ai_hef_allies = gb:get_army(gb:get_player_alliance_num(), "hef_allies")
ga_ai_sla_dancers = gb:get_army(gb:get_player_alliance_num(), "sla_dancers")

-- sunits_nur_main = bm:get_scriptunits_for_army(1,1)
-- sunits_player = bm:get_scriptunits_for_army(2,2)

gb:add_listener(
    "phase_2_cutscene",
	function()
		bm:callback(
			function()
				play_phase_2_cutscene()
				sm:trigger_message("remove_dancers")
			end,
			2000
		)
    end
)

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

portal_reinforce_zone_1 = bm:get_spawn_zone_collection_by_name("portal_rein_1")
portal_reinforce_zone_2 = bm:get_spawn_zone_collection_by_name("portal_rein_2")
main_reinforce_zone = bm:get_spawn_zone_collection_by_name("main_rein_zone")

ga_ai_nur_reinforce_01:assign_to_spawn_zone_from_collection_on_message("start", portal_reinforce_zone_1, false);
ga_ai_nur_reinforce_03:assign_to_spawn_zone_from_collection_on_message("start", portal_reinforce_zone_1, false);

ga_ai_nur_reinforce_02:assign_to_spawn_zone_from_collection_on_message("start", portal_reinforce_zone_2, false);
ga_ai_nur_reinforce_04:assign_to_spawn_zone_from_collection_on_message("start", portal_reinforce_zone_2, false);

ga_ai_nur_reinforce_strong:assign_to_spawn_zone_from_collection_on_message("start", main_reinforce_zone, false);

-- ga_ai_def_reinforce_01:message_on_number_deployed("def_01_deployed", true, 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

sla_heroes_teleport_locations = {
	{x = -230, y = -100, orientation = 180.0}, -- Alluress
	{x = -275, y = -100, orientation = 180.0}, -- Alluress
	{x = -185, y = -100, orientation = 180.0}, -- Alluress
}

function battle_start_teleport_sla_alluress()
	for i=1, ga_ai_sla_dancers.sunits:count() do
		local sunit = ga_ai_sla_dancers.sunits:item(i)
		local location = v(sla_heroes_teleport_locations[i].x, sla_heroes_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, sla_heroes_teleport_locations[i].orientation, 40)
	end
end



emp_allies_teleport_locations = {
	{x = -168, y = -126, orientation = 0.0}, -- Engineer
	{x = -195, y = -145, orientation = 0.0}, -- Swordsmen 1
	{x = -141, y = -145, orientation = 0.0}, -- Swordsmen 2
	{x = -195, y = -126, orientation = 0.0}, -- Huntsmen 1
	{x = -141, y = -126, orientation = 0.0}, -- Huntsmen 2
}

function battle_start_teleport_emp_allies()
	for i=1, ga_ai_emp_allies.sunits:count() do
		local sunit = ga_ai_emp_allies.sunits:item(i)
		local location = v(emp_allies_teleport_locations[i].x, emp_allies_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, emp_allies_teleport_locations[i].orientation, 40)
	end
end



hef_allies_teleport_locations = {
	{x = -288, y = -127, orientation = 0.0}, -- Sea Helm
	{x = -261, y = -146, orientation = 0.0}, -- Spearmen 1
	{x = -315, y = -146, orientation = 0.0}, -- Spearmen 2
	{x = -261, y = -127, orientation = 0.0}, -- Lothern sea guard 1
	{x = -315, y = -127, orientation = 0.0}, -- Lothern sea guard 2
}

function battle_start_teleport_hef_allies()
	for i=1, ga_ai_hef_allies.sunits:count() do
		local sunit = ga_ai_hef_allies.sunits:item(i)
		local location = v(hef_allies_teleport_locations[i].x, hef_allies_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, hef_allies_teleport_locations[i].orientation, 40)
	end
end



nur_main_teleport_locations = {
	{x = -252, y = 218, orientation = 170.0}, -- Plagueridden
	{x = -262, y = 233, orientation = 170.0}, -- Warriors
	{x = -207, y = 243, orientation = 170.0}, -- Warriors
	{x = -160, y = 232, orientation = 170.0}, -- Pestigors
	{x = -290, y = 210, orientation = 170.0}, -- Plaguebearers
	{x = -215, y = 223, orientation = 170.0}, -- Plaguebearers
}

function battle_start_teleport_nur_main()
	for i=1, ga_ai_nur_main.sunits:count() do
		local sunit = ga_ai_nur_main.sunits:item(i)
		local location = v(nur_main_teleport_locations[i].x, nur_main_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, nur_main_teleport_locations[i].orientation, 40)
	end
end



nur_main_2_teleport_locations = {
	{x = 78, y = 98, orientation = 255.0}, -- Warriors
	{x = 102, y = 58, orientation = 255.0}, -- Warriors
	{x = 90, y = 33, orientation = 255.0}, -- Plaguebearers
	{x = 101, y = -13, orientation = 255.0}, -- Plaguebearers
	{x = 116, y = 7.5, orientation = 255.0}, -- Chaos spawn
}

function battle_start_teleport_nur_main_2()
	for i=1, ga_ai_nur_main_2.sunits:count() do
		local sunit = ga_ai_nur_main_2.sunits:item(i)
		local location = v(nur_main_2_teleport_locations[i].x, nur_main_2_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, nur_main_2_teleport_locations[i].orientation, 40)
	end
end


-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

battle_start_teleport_sla_alluress()
battle_start_teleport_emp_allies()
battle_start_teleport_hef_allies()
battle_start_teleport_nur_main()
battle_start_teleport_nur_main_2()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 500, "01_intro_cutscene_end");
gb:message_on_time_offset("objective_01", 5500,"01_intro_cutscene_end");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


ga_ai_emp_allies:halt()
ga_ai_emp_allies:get_unitcontroller():fire_at_will(false)
ga_ai_emp_allies:rush_on_message("end_cutscene_2")

ga_ai_hef_allies:halt()
ga_ai_hef_allies:get_unitcontroller():fire_at_will(false)
ga_ai_hef_allies:rush_on_message("end_cutscene_2")

ga_ai_sla_dancers:halt()
-- wait a little before removing dancers
ga_ai_sla_dancers:remove_on_message("remove_dancers")
-- gb:message_on_time_offset("remove_dancers", 5000, "phase_1_ends")

-- When objective 1 is complete, AI can no longer win by killing the alluresses
gb:add_listener(
	"phase_1_ends",
	function()
		gb:remove_listener("sla_ally_killed")
	end
);


-- ga_ai_nur_main: rush()
ga_ai_nur_main: halt()
ga_ai_nur_main: rush_on_message("nur_main_1_rush")
ga_ai_nur_main: message_on_rout_proportion("nur_main_defeated", 0.5)

-- ga_ai_nur_main_2: rush()
ga_ai_nur_main_2: rush_on_message("nur_main_2_rush")
ga_ai_nur_main_2: message_on_rout_proportion("nur_main_2_defeated", 0.5) -- optional?

-- when both forces have been routed, the portal reinforcements start alongside a timer 
gb:message_on_all_messages_received("initial_force_defeated", "nur_main_defeated", "nur_main_2_defeated")

ga_ai_nur_reinforce_01:reinforce_on_message("initial_force_defeated", 1000)
ga_ai_nur_reinforce_01:message_on_any_deployed("rein_01_in")
ga_ai_nur_reinforce_01:rush_on_message("rein_01_in")
ga_ai_nur_reinforce_02:reinforce_on_message("initial_force_defeated", 1000)
ga_ai_nur_reinforce_02:rush_on_message("rein_01_in")

-- start a timer when first army is defeated, after which send second wave
gb:message_on_time_offset("wave_1_timer_complete", 140000, "initial_force_defeated")
gb:message_on_time_offset("wave_2_timer_complete", 267000, "initial_force_defeated")
gb:message_on_time_offset("phase_1_ends", 280000, "initial_force_defeated")
gb:message_on_time_offset("phase_2_cutscene", 2500, "phase_1_ends"); -- cutscene now
gb:message_on_time_offset("hint_03", 500, "phase_2_begins") -- phase_2_begins end of cutscene
gb:message_on_time_offset("objective_02", 5500, "phase_2_begins") -- phase_2_begins end of cutscene

ga_ai_nur_reinforce_03:reinforce_on_message("wave_1_timer_complete", 1000)
ga_ai_nur_reinforce_03:message_on_any_deployed("03_in")
ga_ai_nur_reinforce_03:rush_on_message("03_in")
ga_ai_nur_reinforce_04:reinforce_on_message("wave_1_timer_complete", 1000)
ga_ai_nur_reinforce_04:rush_on_message("03_in")


-- send the strong army just before the portal armies have been defeated
ga_ai_nur_reinforce_strong: reinforce_on_message("wave_2_timer_complete")
ga_ai_nur_reinforce_strong: message_on_any_deployed("reinforce_strong_in")
-- ga_ai_nur_reinforce_strong: rush_on_message("reinforce_strong_in")
gb:add_listener(
	"reinforce_strong_in",
	function()
		-- ga_ai_nur_reinforce_strong.sunits:item(1):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(2):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(3):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(4):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(5):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(6):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(7):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(8):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(9):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(10):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(11):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(12):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(13):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(14):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(15):change_current_walk_speed(0.3)
		-- ga_ai_nur_reinforce_strong.sunits:item(16):change_current_walk_speed(0.3)
	end
);
ga_ai_nur_reinforce_strong: rush_on_message("phase_2_begins")

-- win
ga_ai_nur_reinforce_strong: message_on_rout_proportion("nur_strong_defeated", 0.8)



-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01","wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_objective_1")
gb:set_objective_on_message("objective_01","wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_masque_alive")
gb:set_objective_with_leader_on_message("objective_02","wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_objective_2")

gb:complete_objective_on_message("phase_1_ends", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_objective_1")
gb:complete_objective_on_message("nur_strong_defeated", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_objective_2")
gb:complete_objective_on_message("nur_strong_defeated", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_masque_alive")


-------------------------------------------------------------------------------------------------
------------------------------------------- HINTS -----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_hint_1")
gb:queue_help_on_message("rein_01_in", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_hint_2")
gb:queue_help_on_message("hint_03", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_hint_3")

-------------------------------------------------------------------------------------------------
---------------------------------------- DEFEAT -------------------------------------------------
-------------------------------------------------------------------------------------------------

-- Defend the 3 alluress objective failed
ga_ai_sla_dancers:message_on_rout_proportion("sla_ally_killed",0.99)
ga_ai_nur_main:force_victory_on_message("sla_ally_killed",5000)
gb:fail_objective_on_message("sla_ally_killed", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_objective_1", 1000) 

-- Keep Masque alive objective failed
ga_player:message_on_commander_dead_or_shattered("lord_dead",1)
ga_ai_nur_main:force_victory_on_message("lord_dead",5000)
gb:fail_objective_on_message("lord_dead", "wh3_dlc27_qb_sla_masque_of_slaanesh_pantomime_of_seduction_masque_alive", 1000) 


-------------------------------------------------------------------------------------------------
---------------------------------------- VICTORY ------------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:force_victory_on_message("nur_strong_defeated", 16000) -- Victory for the enemy after strong force is defeated


