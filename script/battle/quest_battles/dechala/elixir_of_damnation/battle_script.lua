-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Dechala
-- Elixir of Damnation

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      			-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_qb_dechala_phase01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
mid_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_qb_sla_dechala_phase02.CindySceneManager";
bm:cindy_preload(mid_cinematic_file);



-------------------------------------------------------------------------------------------------
------------------------------------- INTRO CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC26_QB_Elixir_Of_Damnation_Intro", true, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC26_QB_Elixir_Of_Damnation_Mid", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Elixir_Of_Damnation_Intro", false, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Elixir_Of_Damnation_Mid", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	local cam = bm:camera();

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_dechala_phase01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	local player_units_hidden = false;

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

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
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			ga_player.sunits:get_general_sunit():set_invisible_to_all(true); -- Makes Dechala invisible so cinematic Dechala has the scene
			--ga_player.sunits:set_invisible_to_all(true)
			player_units_hidden = false;
		end, 
		200
	);	

	right_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	left_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	centreback_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	centreback_evac_point_art.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	
	militia_left.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	militia_right.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	militia_centre_back.sunits:set_always_visible_no_hidden_no_leave_battle(true);

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_01"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_02"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_03"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_04"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_04", false, true)
			end
	)
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_05"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_05", false, true)
			end
	)
		cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_06"))
				bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase1_06", false, true)
			end
	)

	cutscene_intro:start()
end;

function intro_cutscene_end()
	--ga_player.sunits:set_invisible_to_all(false)
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	gb.sm:trigger_message("01_intro_cutscene_end")
	bm:hide_subtitles()
end;


-------------------------------------------------------------------------------------------------
------------------------------------- MID CUTSCENE ----------------------------------------------
-------------------------------------------------------------------------------------------------

function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		cam:fade(false, 2)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_sla_dechala_phase02.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)

		cutscene_mid:action(
			function() 	
				ga_player.sunits:set_invisible_to_all(true)
			end, 
			10
		)

		-- set up subtitles
		local subtitles = cutscene_mid:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_mid:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0)
				bm:stop_cindy_playback(true)
				bm:callback(function() cam:fade(false, 0.5) end, 500)
				bm:hide_subtitles()
			end
		)
		
		-- set up actions on cutscene
		cutscene_mid:action(function() cam:fade(false, 1) end, 1000)

		--fade at the end
		cutscene_mid:action(function() cam:fade(true, 0) end, 82600)

		-- Voiceover and Subtitles --
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_01", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_01"))
					bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_01", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_02", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_02"))
					bm:show_subtitle("wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_02", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_03", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_03"))
					bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_03", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_04", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_04"))
					bm:show_subtitle("wh3_dlc27_qb_sla_dechala_elixir_of_damnation_phase2_04", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_05", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_05"))
					bm:show_subtitle("wh3_dlc27_qb_sla_daemon_prince_elixir_of_damnation_phase2_05", false, true)
				end
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	sm:trigger_message("khorne_enter")	
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	ga_player.sunits:set_invisible_to_all(false)

end

-------------------------------------------------------------------------------------------------
---------------------------------------- VO & SUBS  & Audio -------------------------------------
-------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1); -- Player's army

highelf_prince = gb:get_army(gb:get_non_player_alliance_num(),"hef_prince"); -- High Elf units that serve to attack, delay and/or ambush the player

left_evac_point = gb:get_army(gb:get_non_player_alliance_num(),"hef_defenders_left");
right_evac_point = gb:get_army(gb:get_non_player_alliance_num(),"hef_defenders_right");
centreback_evac_point = gb:get_army(gb:get_non_player_alliance_num(),"hef_defenders_centre");
centreback_evac_point_art = gb:get_army(gb:get_non_player_alliance_num(),"hef_defenders_centre");

militia_left = gb:get_army(gb:get_non_player_alliance_num(),"left_militia");
militia_right = gb:get_army(gb:get_non_player_alliance_num(),"right_militia");
militia_centre_back = gb:get_army(gb:get_non_player_alliance_num(),"centre_back_militia");

khorne_army = gb:get_army(gb:get_non_player_alliance_num(),"kho_main_army");
khorne_army_com = gb:get_army(gb:get_non_player_alliance_num(),"kho_main_army_com");

--khorne_army_com.sunits:set_stat_attribute("flying", true)


-------------------------------------------------------------------------------------------------
------------------------------------------- WAYPOINTS -------------------------------------------
-------------------------------------------------------------------------------------------------

-- Waypoints are invisible markers that can be placed around the battle map, these can be used as triggers for messages or AI actions. Use the Cursor Position
-- option in the BattleDebugUI menu to get X, Y, Z coordinates.


defender_right_waypoint = v(358.2, 167.7, 93.8) 
defender_left_waypoint = v(-249.9, 171.7, -95.1) 
defender_back_waypoint = v(39.2, 145.0, -152.2) 
-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- ORDERS -------------------------------------------------
-- -------------------------------------------------------------------------------------------------

ga_player:message_on_proximity_to_position("right_defenders_defend", defender_right_waypoint, 150) -- If the player is within proximity to this waypoint, order the AI near it to defend a position
ga_player:message_on_proximity_to_position("back_defenders_defend", defender_right_waypoint, 150) 
right_evac_point:defend_on_message("right_defenders_defend", 382.1, 125.6, 100, 1000)
right_evac_point:attack_on_message("right_defenders_defend")

ga_player:message_on_proximity_to_position("left_defenders_defend", defender_left_waypoint, 150) -- If the player is within proximity to this waypoint, order the AI near it to defend a position
ga_player:message_on_proximity_to_position("back_defenders_defend", defender_left_waypoint, 150) 
left_evac_point:defend_on_message("left_defenders_defend", -280.5, -216.1, 100, 1000)
left_evac_point:attack_on_message("left_defenders_defend")

ga_player:message_on_proximity_to_position("back_defenders_defend", defender_back_waypoint, 250) -- If the player is within proximity to this waypoint, order the AI near it to defend a position
centreback_evac_point:defend_on_message("back_defenders_defend", 403.9, -351.2, 100, 1000)
highelf_prince:defend_on_message("back_defenders_defend", 403.9, -351.2, 100, 1000)
highelf_prince:attack_on_message("back_defenders_defend")

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- UNIT TELEPORTS -----------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Prince --

highelf_prince.sunits:item(1).uc:teleport_to_location(v(334.6, -289.9), 340, 20) -- High Elf Phoenix Guard

-- Evac Point defenders

left_evac_point.sunits:item(1).uc:teleport_to_location(v(-356.6, -151.9), 40, 40) -- High Elf Phoenix Guard
left_evac_point.sunits:item(2).uc:teleport_to_location(v(-305.5, -150.7), 40, 40) -- High Elf Phoenix Guard
left_evac_point.sunits:item(3).uc:teleport_to_location(v(-254.3, -178.9), 40, 40) -- High Elf Phoenix Guard
left_evac_point.sunits:item(4).uc:teleport_to_location(v(-313.6, -165.7), 40, 20) -- Swordmaster of Hoeth
left_evac_point.sunits:item(5).uc:teleport_to_location(v(-420.5, -105.3), 40, 20) -- Swordmaster of Hoeth
left_evac_point.sunits:item(6).uc:teleport_to_location(v(-195.8, -229.6), 40, 20) -- Swordmaster of Hoeth
left_evac_point.sunits:item(7).uc:teleport_to_location(v(-352.5, -292.7), 40, 20) -- Archers
left_evac_point.sunits:item(8).uc:teleport_to_location(v(-313.0, -300.5), 40, 20) -- Archers

right_evac_point.sunits:item(1).uc:teleport_to_location(v(325.0, 65.0), 340, 20) -- White Lions
right_evac_point.sunits:item(2).uc:teleport_to_location(v(447.4, 110.6), 340, 20) -- White Lions
right_evac_point.sunits:item(3).uc:teleport_to_location(v(326.7, -90.8), 340, 20) -- Dragon Princes
right_evac_point.sunits:item(4).uc:teleport_to_location(v(455.4, -92.1), 340, 20) -- Dragon Princes
right_evac_point.sunits:item(5).uc:teleport_to_location(v(397.7, 60.5), 340, 20) -- Moon Dragon
right_evac_point.sunits:item(6).uc:teleport_to_location(v(397.7, -18.5), 340, 20) -- Star Dragon

centreback_evac_point.sunits:item(1).uc:teleport_to_location(v(305.3, -338.8), 340, 20) -- Sisters of Avelon
centreback_evac_point.sunits:item(2).uc:teleport_to_location(v(272.6, -354.5), 340, 20) -- Sisters of Avelon
centreback_evac_point.sunits:item(3).uc:teleport_to_location(v(315.9, -283.7), 340, 20) -- Sisters of Avelon

centreback_evac_point_art.sunits:item(4).uc:teleport_to_location(v(383.9, -411.7), 320, 40) -- Bolt Thrower
centreback_evac_point_art.sunits:item(5).uc:teleport_to_location(v(458.5, -350.5), 320, 40) -- Bolt Thrower
centreback_evac_point_art.sunits:item(6).uc:teleport_to_location(v(434.5, -388.3), 320, 40) -- Bolt Thrower

-- Militia

militia_left.sunits:item(1).uc:teleport_to_location(v(-369.1, -238.4), 40, 20)
militia_left.sunits:item(2).uc:teleport_to_location(v(-296.3, -273.8), 340, 20)
militia_left.sunits:item(3).uc:teleport_to_location(v(-303.5, -227.3), 340, 20)

militia_right.sunits:item(1).uc:teleport_to_location(v(380.7, 24.2), 340, 20)
militia_right.sunits:item(2).uc:teleport_to_location(v(413.7, 60.8), 320, 20)
militia_right.sunits:item(3).uc:teleport_to_location(v(449.7, 65.3), 340, 20)

militia_centre_back.sunits:item(1).uc:teleport_to_location(v(344.2, -353.7), 340, 20)
militia_centre_back.sunits:item(2).uc:teleport_to_location(v(406.7, -310.8), 340, 20)
militia_centre_back.sunits:item(3).uc:teleport_to_location(v(354.1, -276.1), 340, 20)



-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- MESSAGES -----------------------------------------------
-- -------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 1000);

gb:message_on_time_offset("starting_message", 2000) -- Starting message, tells the player what to do
gb:queue_help_on_message("starting_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_01")

gb:message_on_time_offset("militia_message", 15000)
gb:queue_help_on_message("militia_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill_hint")

gb:message_on_time_offset("dechala_death_hint", 30000);
gb:queue_help_on_message("dechala_death_hint", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_01_dechala_death_hint")

gb:queue_help_on_message("khorne_enter", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_02")

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Objectives ---------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Keep Dechala Alive

gb:set_objective_on_message("dechala_death_hint", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_dechala_alive")

-- Left Evac Point Guard

gb:set_objective_on_message("starting_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_1")

left_evac_point:message_on_rout_proportion("left_defenders_dead", 0.8) -- When this 80% of this force is dead, fire the message.
gb:queue_help_on_message("left_defenders_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_left")
gb:complete_objective_on_message("left_defenders_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_1", 1000) -- Sets the objective as complete
militia_left:rout_over_time_on_message("left_defenders_dead", 15)

-- Right Evac Point Guard

gb:set_objective_on_message("starting_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_2")

right_evac_point:message_on_rout_proportion("right_defenders_dead", 0.8) -- When this 80%% of this force is dead, fire the message.
gb:queue_help_on_message("right_defenders_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_right")
gb:complete_objective_on_message("right_defenders_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_2", 1000) -- Sets the objective as complete
militia_right:rout_over_time_on_message("right_defenders_dead", 15)

-- Centre Back Evac Guard

gb:set_objective_on_message("starting_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_3")

centreback_evac_point:message_on_rout_proportion("centre_back_defenders_dead", 0.8) -- When this 80% of this force is dead, fire the message.
gb:complete_objective_on_message("centre_back_defenders_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_evac_point_3", 1000) -- Sets the objective as complete
militia_centre_back:rout_over_time_on_message("centre_back_defenders_dead", 15)

gb:set_objective_on_message("militia_message", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill")

gb:add_listener( -- Adds a ping to the militia, then removes it after 10s
	"militia_message",
	function()
		militia_left.sunits:item(1):add_ping_icon(15, 30000)
		militia_left.sunits:item(2):add_ping_icon(15, 30000)
		militia_left.sunits:item(3):add_ping_icon(15, 30000)
		militia_right.sunits:item(1):add_ping_icon(15, 30000)
		militia_right.sunits:item(2):add_ping_icon(15, 30000)
		militia_right.sunits:item(3):add_ping_icon(15, 30000)
		militia_centre_back.sunits:item(1):add_ping_icon(15, 30000)
		militia_centre_back.sunits:item(2):add_ping_icon(15, 30000)
		militia_centre_back.sunits:item(3):add_ping_icon(15, 30000)
	end
);

gb:add_listener(
    "mid_cutscene",
	function()
		bm:callback(
			function()
				play_mid_cutscene()
			--	sm:trigger_message("clean_up_units")
			end,
			2000
		)
    end
)

gb:message_on_all_messages_received("mid_cutscene", "left_defenders_dead", "right_defenders_dead", "centre_back_defenders_dead") -- When all of the defenders have been killed, trigger the second cutscene
gb:complete_objective_on_message("mid_cutscene", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill", 1000) -- Set militia objective as complete.

khorne_army:reinforce_on_message("khorne_enter", 1000) -- Khorne reinforcements
khorne_army_com:reinforce_on_message("khorne_enter", 60000)
khorne_army:attack_force_on_message("khorne_enter", ga_player, 2000);
khorne_army_com:attack_force_on_message("khorne_enter", ga_player, 2000);

gb:set_objective_on_message("khorne_enter", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_khorne_prince")


-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Victory ------------------------------------------------
-- -------------------------------------------------------------------------------------------------

khorne_army_com:message_on_commander_dead_or_routing("commander_dead") -- On death, message is created for the garrison commander
gb:queue_help_on_message("commander_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_victory") -- Success message
gb:complete_objective_on_message("commander_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_khorne_prince", 1000) -- Sets the objective as complete

khorne_army:rout_over_time_on_message("commander_dead", 15000) -- Enemy slowly routs after the commander's death
ga_player:force_victory_on_message("commander_dead", 16000) -- Victory for the enemy after the commander's death

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Defeat -------------------------------------------------
-- -------------------------------------------------------------------------------------------------

ga_player:message_on_commander_death("lord_dead", 1) -- Dechala death message triggered
ga_player:rout_over_time_on_message("lord_dead", 15000) -- Player's force slowly routs followed by a defeat
highelf_prince:force_victory_on_message("lord_dead", 16000) -- Victory for the enemy after Dechala death
gb:queue_help_on_message("lord_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_dechala_death") -- Death message for Dechala
gb:fail_objective_on_message("lord_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_dechala_alive", 1000) -- Keep Dechala alive objective failed


militia_left:message_on_casualties("militia_dead",0.6); -- Fail objective and mission if 60% of the left Militia have been killed.
gb:fail_objective_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill", 1000) -- Keep Militia alive!
highelf_prince:force_victory_on_message("militia_dead", 16000)
gb:queue_help_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_fail")

militia_right:message_on_casualties("militia_dead",0.6); -- Fail objective and mission if 60% of the left Militia have been killed.
gb:fail_objective_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill", 1000) -- Keep Militia alive!
highelf_prince:force_victory_on_message("militia_dead", 16000)
gb:queue_help_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_fail")

militia_centre_back:message_on_casualties("militia_dead",0.6); -- Fail objective and mission if 60% of the left Militia have been killed.
gb:fail_objective_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_kill", 1000) -- Keep Militia alive!
highelf_prince:force_victory_on_message("militia_dead", 16000)
gb:queue_help_on_message("militia_dead", "wh3_dlc27_qb_sla_dechala_elixir_of_damnation_militia_fail")