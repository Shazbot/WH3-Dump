-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Epidemius
-- Sands of Sickness
-- Tower of Hoeth
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

-- bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                       		-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);
gb:set_cutscene_during_deployment(true)

----SFX---

local cutscene_sfx_sweetener_play = new_sfx("Play_Movie_WH3_DLC25_QB_Epidemius_Sands_Of_Sickness", true, false)
local cutscene_sfx_sweetener_stop = new_sfx("Stop_Movie_WH3_DLC25_QB_Epidemius_Sands_Of_Sickness", false, false)


-----------------------------------------------------------------------------------------------
-------------------------------------- INTRO VO & SUBS & Audio---------------------------------
-----------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
	local cam = bm:camera()
	
	-- REMOVE ME
	cam:fade(false, 1)
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player_01.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/sands_of_sickness_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		2																				-- blend out time (s)
	)
	
	local player_units_hidden = false
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera()
			cam:fade(false, 0)
			bm:stop_cindy_playback(true)
			
			if player_units_hidden then
				ga_player_01:set_enabled(false)
			end
						
			bm:callback(function() cam:fade(false, 0.5) end, 2)
			bm:hide_subtitles()
		end
	)
	
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false
		end, 
		200
	)

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(cutscene_sfx_sweetener_play) end, 800)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_01"))
				bm:show_subtitle("wh3_dlc25_qb_nur_epidemius_sands_of_sickness_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_02"))
				bm:show_subtitle("wh3_dlc25_qb_nur_epidemius_sands_of_sickness_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_03"))
				bm:show_subtitle("wh3_dlc25_qb_nur_epidemius_sands_of_sickness_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_nur_epidemius_sands_of_sickness_04"))
				bm:show_subtitle("wh3_dlc25_qb_nur_epidemius_sands_of_sickness_04", false, true)
			end
	)




	cutscene_intro:start()
end



-----------------------------------------------------------------------------------------------
----------------------------------------- CUTSCENE --------------------------------------------
-----------------------------------------------------------------------------------------------



function intro_cutscene_end()
	play_sound_2D(cutscene_sfx_sweetener_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	
	
end


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1, "")
ga_hef_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army")
ga_brt_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("reinforcements", 120000)
ga_brt_01:reinforce_on_message("reinforcements")

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("attack", 1000)
ga_hef_01:attack_force_on_message("attack", ga_player_01)

ga_hef_01:kill_proportion_over_time_on_message(1, 480000, false, "attack")

ga_brt_01:message_on_proximity_to_enemy("stop_killing", 10)

ga_hef_01:stop_kill_proportion_over_time_on_message("stop_killing")

ga_hef_01:message_on_rout_proportion("hef_defeated", 0.8)
ga_brt_01:message_on_rout_proportion("brt_defeated", 0.8)

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("starting_message", 5000)
-- The High Elves are afflicted with our plague and are perishing, but the Bretonnians will soon rally with a cure!
gb:queue_help_on_message("starting_message", "wh3_dlc25_qb_nur_epidemius_sands_of_sickness_objective_1_hint")
gb:set_objective_with_leader_on_message("starting_message", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_02")

-- The Bretonnians have arrived with the cure - if they reach us, the elves will be cleansed!
gb:queue_help_on_message("reinforcements", "wh3_dlc25_qb_nur_epidemius_sands_of_sickness_objective_2_hint")
gb:set_objective_with_leader_on_message("reinforcements", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_01")

-- The cure has been administered! The elves will no longer wither!
gb:queue_help_on_message("stop_killing", "wh3_dlc25_qb_nur_epidemius_sands_of_sickness_objective_3_hint")

gb:complete_objective_on_message("hef_defeated", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_02")
gb:complete_objective_on_message("brt_defeated", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_01")