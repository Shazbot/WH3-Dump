-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Gorbad Ironclaw
-- By Aleksandar Radulov
-- Forest Bane

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

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC26_QB_Gorbad_Forest_Bane", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Gorbad_Forest_Bane", false, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
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
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_gorbad_m01.CindySceneManager",		    -- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)

	local player_units_hidden = false;

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

			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
					
			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
			ga_ai_bst_main.sunits:set_always_visible(true)
		end, 
		200
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

		-- Voiceover and Subtitles --
		
		cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
		
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_01", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_01"))
					bm:show_subtitle("wh3_dlc26_forest_bane_01", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_02", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_02"))
					bm:show_subtitle("wh3_dlc26_forest_bane_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_03", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_03"))
					bm:show_subtitle("wh3_dlc26_forest_bane_03", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_04", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_04"))
					bm:show_subtitle("wh3_dlc26_forest_bane_04", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_05", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_05"))
					bm:show_subtitle("wh3_dlc26_forest_bane_05", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_06", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_06"))
					bm:show_subtitle("wh3_dlc26_forest_bane_06", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_07", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_07"))
					bm:show_subtitle("wh3_dlc26_forest_bane_07", false, true)
				end
		)

		-- cutscene_intro:add_cinematic_trigger_listener(
		-- 	"Play_wh3_dlc26_qb_grn_gorbad_forest_bane_08", 
		-- 		function()
		-- 			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_08"))
		-- 			bm:show_subtitle("wh3_dlc26_forest_bane_08", false, true)
		-- 		end
		-- )

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	-- player_units_hidden = false;
	-- ga_player:set_enabled(true) 
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_bst_main = gb:get_army(gb:get_non_player_alliance_num(), "main_force")
ga_ai_bst_ambush = gb:get_army(gb:get_non_player_alliance_num(), "ambush")
ga_ai_bst_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "reinforcement")
ga_ai_wef_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "wef_reinforce")

-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------

bst_reinforce_zone = bm:get_spawn_zone_collection_by_name("bst_reinforce_zone")
wef_reinforce_zone = bm:get_spawn_zone_collection_by_name("wef_reinforce_zone")

ga_ai_bst_reinforce:assign_to_spawn_zone_from_collection_on_message("start", bst_reinforce_zone, false)
ga_ai_wef_reinforce:assign_to_spawn_zone_from_collection_on_message("start", wef_reinforce_zone, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

bst_ambush_teleport_locations = {
	--Left side units
	{x = -400.0, y = -100.0, orientation = 120.0},
	{x = -420.0, y = -100.0, orientation = 120.0},
	{x = 90.0, y = 410.0, orientation = 255.0},
	{x = 110.0, y = 430.0, orientation = 255.0},

	--Right side units
	{x = -380.0, y = -100.0, orientation = 120.0},
	{x = -360.0, y = -100.0, orientation = 120.0},
	{x = 90.0, y = 450.0, orientation = 255.0},
	{x = 110.0, y = 470.0, orientation = 255.0}
}

function battle_start_teleport()
	for i=1, ga_ai_bst_ambush.sunits:count() do
		local sunit = ga_ai_bst_ambush.sunits:item(i)
		local location = v(bst_ambush_teleport_locations[i].x, bst_ambush_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, bst_ambush_teleport_locations[i].orientation, 40)
	end
end

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

battle_start_teleport()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 200);
gb:message_on_time_offset("hint_01", 2700);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_bst_main:message_on_under_attack("bst_main_attack")
ga_ai_bst_main:rush_on_message("bst_main_attack")
ga_ai_bst_main:message_on_rout_proportion("bst_main_hurt", 0.2)
ga_ai_bst_main:message_on_rout_proportion("bst_main_pained", 0.4)
ga_ai_bst_main:message_on_rout_proportion("bst_main_wounded", 0.6)
ga_ai_bst_main:prevent_rallying_if_routing_on_message("bst_main_wounded")
ga_ai_bst_main:message_on_rout_proportion("bst_main_defeated", 0.95)

ga_ai_bst_ambush:message_on_seen_by_enemy("bst_ambush_attack")
ga_ai_bst_ambush:attack_force_on_message("bst_ambush_attack", ga_player)
ga_ai_bst_ambush:message_on_rout_proportion("bst_ambush_wounded", 0.75)
ga_ai_bst_ambush:prevent_rallying_if_routing_on_message("bst_ambush_wounded")
ga_ai_bst_ambush:message_on_rout_proportion("bst_ambush_defeated", 0.95)

ga_ai_bst_reinforce:reinforce_on_message("bst_main_hurt")
ga_ai_bst_reinforce:message_on_any_deployed("bst_reinforce_in")
ga_ai_bst_reinforce:rush_on_message("bst_reinforce_in")
ga_ai_bst_reinforce:message_on_rout_proportion("bst_reinforce_wounded", 0.75)
ga_ai_bst_reinforce:prevent_rallying_if_routing_on_message("bst_reinforce_wounded")
ga_ai_bst_reinforce:message_on_rout_proportion("bst_reinforce_defeated", 0.95)

gb:message_on_all_messages_received("bst_defeated", "bst_main_defeated", "bst_ambush_defeated", "bst_reinforce_defeated")

gb:play_sound_on_message("bst_main_wounded", new_sfx("Play_wh3_dlc26_qb_grn_gorbad_forest_bane_08", false, true), nil)

ga_ai_wef_reinforce:reinforce_on_message("bst_main_wounded")
ga_ai_wef_reinforce:message_on_any_deployed("wef_reinforce_in")
ga_ai_wef_reinforce:rush_on_message("wef_reinforce_in")
ga_ai_wef_reinforce:message_on_rout_proportion("wef_reinforce_wounded", 0.75)
ga_ai_wef_reinforce:message_on_rout_proportion("wef_defeated", 0.95)
ga_ai_wef_reinforce:prevent_rallying_if_routing_on_message("wef_reinforce_wounded")

gb:message_on_all_messages_received("enemy_defeated", "bst_defeated", "wef_defeated")

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc26_qb_grn_gorbad_forest_bane_objective_1");
gb:complete_objective_on_message("bst_defeated", "wh3_dlc26_qb_grn_gorbad_forest_bane_objective_1", 2500)

gb:message_on_time_offset("wef_objective", 2500, "wef_reinforce_in");

gb:set_objective_with_leader_on_message("wef_objective", "wh3_dlc26_qb_grn_gorbad_forest_bane_objective_2");
gb:complete_objective_on_message("wef_defeated", "wh3_dlc26_qb_grn_gorbad_forest_bane_objective_2", 2500)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("hint_01", "wh3_dlc26_qb_grn_gorbad_forest_bane_hint_1")
gb:queue_help_on_message("bst_ambush_attack", "wh3_dlc26_qb_grn_gorbad_forest_bane_hint_1_1")
gb:queue_help_on_message("bst_reinforce_in", "wh3_dlc26_qb_grn_gorbad_forest_bane_hint_2")
gb:queue_help_on_message("bst_main_pained", "wh3_dlc26_qb_grn_gorbad_forest_bane_hint_3")
gb:queue_help_on_message("wef_reinforce_in", "wh3_dlc26_qb_grn_gorbad_forest_bane_hint_4")

-------------------------------------------------------------------------------------------------
---------------------------------------- VICTORY / DEFEAT ---------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:force_victory_on_message("enemy_defeated", 5000)

ga_ai_bst_main:force_victory_on_message("player_loss", 5000)