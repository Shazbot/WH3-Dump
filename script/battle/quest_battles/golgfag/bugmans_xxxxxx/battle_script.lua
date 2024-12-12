-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Golgfag
-- By James Cox
-- Easy Come Easy Go

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC26_QB_Golgfag_Bugmans_XXXXXX_Intro", true, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC26_QB_Golgfag_Bugmans_XXXXXX_Mid", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Golgfag_Bugmans_XXXXXX_Intro", false, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Golgfag_Bugmans_XXXXXX_Mid", false, false)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
	local cam = bm:camera()
	
	-- REMOVE ME
	cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_golgfag_intro_m01.CindySceneManager",	-- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)

	cutscene_intro:action(
		function() 	
			ga_player.sunits:set_invisible_to_all(true)
			grn_ally.sunits:item(1):set_invisible_to_all(true)

			dwf_enemy.sunits:set_always_visible(true)
		end, 
		10
	)

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()
	
	-- skip callback
	cutscene_intro:set_skippable(
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
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_01"))
				bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_02"))
				bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_03"))
				bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_04"))
				bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_04", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	ga_player.sunits:set_invisible_to_all(false)
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	grn_ally.sunits:item(1):set_invisible_to_all(false)
end

-------------------------------------------------------------------------------------------------
----------------------------------------- MID CUTSCENE ------------------------------------------
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
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_golgfag_mid_m01.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)

		cutscene_mid:action(
			function() 	
				ga_player.sunits:set_invisible_to_all(true)

				grn_ally.sunits:set_invisible_to_all(true)
				grn_enemy.sunits:set_invisible_to_all(true)
				grn_enemy_reinforce.sunits:set_invisible_to_all(true)

				dwf_ally.sunits:set_invisible_to_all(true)
				dwf_enemy.sunits:set_invisible_to_all(true)
				dwf_enemy_reinforce.sunits:set_invisible_to_all(true)
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

		-- Voiceover and Subtitles --
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gnashrak_bugmans_xxxxxx_06", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gnashrak_bugmans_xxxxxx_06"))
					bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_05", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_06", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_06"))
					bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_06", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_07", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_07"))
					bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_07", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_08", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_08"))
					bm:show_subtitle("wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_08", false, true)
				end
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	sm:trigger_message("phase_2")
	
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)

	ga_player.sunits:set_invisible_to_all(false)

	grn_ally.sunits:set_invisible_to_all(false)
	grn_enemy.sunits:set_invisible_to_all(false)
	grn_enemy_reinforce.sunits:set_invisible_to_all(false)

	dwf_ally.sunits:set_invisible_to_all(false)
	dwf_enemy.sunits:set_invisible_to_all(false)
	dwf_enemy_reinforce.sunits:set_invisible_to_all(false)
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

grn_ally = gb:get_army(gb:get_player_alliance_num(), "grn_ally")
grn_enemy = gb:get_army(gb:get_non_player_alliance_num(), "grn_enemy")
grn_enemy_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "grn_enemy_reinforce")

dwf_ally = gb:get_army(gb:get_player_alliance_num(), "dwf_ally")
dwf_enemy = gb:get_army(gb:get_non_player_alliance_num(), "dwf_enemy")
dwf_enemy_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "dwf_enemy_reinforce")

-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------

dwf_spawn_1 = bm:get_spawn_zone_collection_by_name("dwarf_reinforce_1")
dwf_spawn_2 = bm:get_spawn_zone_collection_by_name("dwarf_reinforce_2")
grn_spawn_1 = bm:get_spawn_zone_collection_by_name("greenskin_reinforce_1")
grn_spawn_2 = bm:get_spawn_zone_collection_by_name("greenskin_reinforce_2")

grn_enemy:assign_to_spawn_zone_from_collection_on_message("start", grn_spawn_1, false)
grn_enemy_reinforce:assign_to_spawn_zone_from_collection_on_message("start", grn_spawn_2, false)

dwf_ally:assign_to_spawn_zone_from_collection_on_message("start", dwf_spawn_1, false)
dwf_enemy_reinforce:assign_to_spawn_zone_from_collection_on_message("start", dwf_spawn_2, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

-- teleport_locations = {
-- 	{x = -288.26, y = -408.01, orientation = 339.191},
-- 	{x = -293.48, y = -285.68, orientation = 339.191},
-- 	{x = -308.91, y = -291.54, orientation = 339.191},
-- 	{x = -324.33, y = -297.41, orientation = 339.191},
-- 	{x = -247.20, y = -268.83, orientation = 339.191},
-- 	{x = -340.95, y = -304.47, orientation = 339.191},
-- 	{x = -230.37, y = -262.43, orientation = 339.191},
-- 	{x = -357.78, y = -310.87, orientation = 339.191},
-- 	{x = -264.02, y = -275.22, orientation = 339.191},
-- 	{x = -389.18, y = -322.81, orientation = 339.191},
-- 	{x = -278.61, y = -280.77, orientation = 339.191},
-- 	{x = -303.37, y = -368.28, orientation = 339.191},
-- 	{x = -374.60, y = -317.27, orientation = 339.191},
-- 	{x = -403.76, y = -328.36, orientation = 339.191},
-- 	{x = -443.62, y = -344.80, orientation = 339.191},
-- 	{x = -214.15, y = -257.54, orientation = 339.191},
-- 	{x = -198.85, y = -250.23, orientation = 339.191},
-- 	{x = -459.92, y = -349.50, orientation = 339.191},
-- 	{x = -424.65, y = -337.58, orientation = 339.191},
-- 	{x = -404.65, y = -337.58, orientation = 339.191}
-- }

-- gb:add_listener(
--     "dwarfs_routed",
-- 	function()
-- 		bm:callback(
-- 			function()
-- 				for i = 1, ga_player.sunits:count() do
-- 					local sunit = ga_player.sunits:item(i)
-- 					local location = v(teleport_locations[i].x, teleport_locations[i].y)

-- 					sunit.uc:teleport_to_location(location, teleport_locations[i].orientation, 40)
-- 				end
-- 			end,
-- 			5000
-- 		)
--     end
-- )

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 200);
gb:message_on_time_offset("objective_01", 2700);

gb:add_listener(
    "mid_cutscene",
	function()
		bm:callback(
			function()
				play_mid_cutscene()
				sm:trigger_message("clean_up_units")
			end,
			2000
		)
    end
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

grn_ally:rush_on_message("start")
-- grn_ally:attack_force_on_message("start", dwf_enemy)
grn_ally:kill_proportion_over_time_on_message(1, 1, false, "clean_up_units")

dwf_enemy:rush_on_message("start")
dwf_enemy:message_on_casualties("phase_1", 0.2)
dwf_enemy:message_on_casualties("dwarf_rout", 0.8)
dwf_enemy:prevent_rallying_if_routing_on_message("dwarf_rout")
dwf_enemy:message_on_rout_proportion("dwarf_dead", 0.95)
dwf_enemy:kill_proportion_over_time_on_message(1, 1, false, "clean_up_units")

dwf_enemy_reinforce:reinforce_on_message("phase_1")
dwf_enemy_reinforce:message_on_deployed("dwf_reinforce_rush")
dwf_enemy_reinforce:rush_on_message("dwf_reinforce_rush")
dwf_enemy_reinforce:rout_over_time_on_message("dwarf_rout", 10000)
dwf_enemy_reinforce:message_on_rout_proportion("dwarf_reinforcement_dead", 0.95)
dwf_enemy_reinforce:kill_proportion_over_time_on_message(1, 1, false, "clean_up_units")

gb:message_on_all_messages_received("dwarfs_routed", "dwarf_dead", "dwarf_reinforcement_dead")
gb:message_on_time_offset("mid_cutscene", 2500, "dwarfs_routed");

dwf_ally:reinforce_on_message("phase_2")
dwf_ally:message_on_deployed("dwf_ally_rush")
-- dwf_ally:rush_on_message("dwf_ally_rush")
dwf_ally:attack_force_on_message("dwf_ally_rush", grn_enemy)

grn_enemy:reinforce_on_message("phase_2")
grn_enemy:message_on_deployed("grn_enemy_rush")
grn_enemy:attack_force_on_message("grn_enemy_rush", dwf_ally)
grn_enemy:rush_on_message("grn_wounded")
grn_enemy:message_on_casualties("grn_wounded", 0.3)
grn_enemy:message_on_casualties("grn_dead", 0.95)

gb:message_on_time_offset("hint_03", 2500, "phase_2");
gb:message_on_time_offset("phase_3", 5000, "grn_enemy_rush");

grn_enemy_reinforce:reinforce_on_message("phase_3")
grn_enemy_reinforce:message_on_deployed("grn_enemy_reinforce_rush")
grn_enemy_reinforce:attack_force_on_message("grn_enemy_reinforce_rush", ga_player)
grn_enemy_reinforce:message_on_casualties("grn_reinforcement_dead", 0.95)

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_objective_1")
gb:fail_objective_on_message("phase_2", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_objective_1")
gb:remove_objective_on_message("phase_2", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_objective_1", 10000)

gb:message_on_all_messages_received("victory", "grn_dead", "grn_reinforcement_dead")

gb:set_objective_with_leader_on_message("phase_2", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_objective_2")
gb:complete_objective_on_message("victory", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_objective_2")

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("hint_01", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_hint_1")
gb:queue_help_on_message("phase_1", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_hint_2")
gb:queue_help_on_message("hint_03", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_hint_3")
gb:queue_help_on_message("grn_enemy_reinforce_rush", "wh3_dlc26_qb_ogr_golgfag_bugmans_xxxxxx_hint_4")

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------