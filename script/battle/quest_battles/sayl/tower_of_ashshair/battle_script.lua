-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Sayl the Faithless
-- By Hristo Enev
-- Tower of Ashshair

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      			-- screen starts black
	true,                                    		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

--gb:set_cutscene_during_deployment(true)
local phase_2_triggered = false

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_bst_allies = gb:get_army(gb:get_player_alliance_num(), "bst_ally")

ga_ai_cth_main = gb:get_army(gb:get_non_player_alliance_num(), "cth_main")
ga_ai_cth_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), "cth_reinforcement")
ga_ai_cth_relief_1 = gb:get_army(gb:get_non_player_alliance_num(), "cth_relief_1")
ga_ai_cth_relief_2 = gb:get_army(gb:get_non_player_alliance_num(), "cth_relief_2")

--vectors--
objective_position=v(2, 1524, 570);
escape_position=v(720, 1504, 280);
-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

cth_reinforcement = bm:get_spawn_zone_collection_by_name("cth_reinforce")
cth_relief_1 = bm:get_spawn_zone_collection_by_name("cth_relief")
cth_relief_2 = bm:get_spawn_zone_collection_by_name("cth_relief")

ga_ai_cth_reinforcement:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforcement, false);
ga_ai_cth_reinforcement:message_on_number_deployed("cth_reinforcement_deployed", true, 1);
ga_ai_cth_relief_1:assign_to_spawn_zone_from_collection_on_message("start", cth_relief_1, false);
ga_ai_cth_relief_1:message_on_number_deployed("cth_relief_1_deployed", true, 1);
ga_ai_cth_relief_2:assign_to_spawn_zone_from_collection_on_message("start", cth_relief_2, false);
ga_ai_cth_relief_2:message_on_number_deployed("cth_relief_2_deployed", true, 1);



-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro = new_sfx("Play_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Intro", false, false)
local sfx_cutscene_sweetener_mid = new_sfx("Play_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Mid", false, false)
		
-------------------------------------------------------------------------------------------------
------------------------------------------- INTRO CUTSCENE --------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
			
	local cam = bm:camera()
		
	--REMOVE ME
	--cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_sayl_intro_m01.CindySceneManager",	 	-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	)

	local player_units_hidden = false;
	ga_ai_cth_main.sunits:set_always_visible(true);
	ga_ai_bst_allies.sunits:set_always_visible(true);
	ga_player.sunits:get_general_sunit():set_invisible_to_all(true);


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
	cutscene_intro:action(
		function()
			--ga_ai_bst_allies:rush();
		end,
		100
	)

	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true);
		end, 
		200
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

		-- Voiceover and Subtitles --
		
		cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro) end, 0);
		
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_nor_sayl_QB_phase1_01", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_01"))
					bm:show_subtitle("wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase1_01", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_nor_sayl_QB_phase1_02", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_02"))
					bm:show_subtitle("wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase1_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_nor_sayl_QB_phase1_03", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_03"))
					bm:show_subtitle("wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase1_03", false, true)
				end
		)

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	player_units_hidden = false;
	ga_player:set_enabled(true) 
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	ga_ai_cth_main.sunits:set_always_visible(true);
	--ga_ai_cth_main.sunits:release_control()
	ga_ai_bst_allies.sunits:set_always_visible(true);
	--ga_ai_bst_allies.sunits:release_control()
	--ga_player.sunits:item(1).uc:teleport_to_location(v(50,  600), 180, 25);
	gb.sm:trigger_message("intro_cutscene_end")
end

-------------------------------------------------------------------------------------------------
------------------------------------------- MID CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------
function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		--cam:fade(false, 2)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_sayl_mid_m01.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
		
		ga_ai_cth_main.sunits:set_invisible_to_all(true);
		ga_ai_bst_allies.sunits:set_invisible_to_all(true);
		ga_ai_cth_reinforcement.sunits:set_invisible_to_all(true);
		ga_player.sunits:set_invisible_to_all(true);


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
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_nor_sayl_QB_phase2_01", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase2_01"))
					bm:show_subtitle("wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase2_01", false, true)
				end
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	player_units_hidden = false;
	ga_player:set_enabled(true);
	ga_player.sunits:get_general_sunit():set_enabled(true, true);
	ga_ai_cth_main.sunits:set_always_visible(true);
	--ga_ai_cth_main.sunits:release_control()
	ga_ai_bst_allies.sunits:set_always_visible(true);
	ga_ai_cth_reinforcement.sunits:set_always_visible(true);
	ga_player.sunits:set_always_visible(true);
	ga_player.sunits:get_general_sunit():release_control();
	--ga_ai_bst_allies.sunits:release_control()
	gb.sm:trigger_message("mid_cutscene_end")
end
-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);


bm:watch(
	function()
		return standing_is_close_to_position(ga_player.sunits:get_general_sunit(), objective_position, 20, true, false) 
	end,
	0,
	function()
		phase_2_triggered = true
		gb.sm:trigger_message("phase_2_start")
	end,
	"check_if_sayl_is_on_objective"
)
gb:message_on_time_offset("timer_for_reinforcements", 120000, "intro_cutscene_end");
--gb:message_on_all_messages_received("phase_2_start", "timer_for_reinforcements", "player_near_the_objective");

gb:message_on_time_offset("timer_for_relief", 240000, "reinforcements_in");
gb:message_on_time_offset("player_captured_objective", 180000, "phase_2_start");
ga_ai_cth_reinforcement:message_on_casualties("reinforcements_casualties",0.6)
gb:message_on_any_message_received("phase_3_start","timer_for_relief","player_captured_objective","reinforcements_casualties");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_cth_main:rush_on_message("start");
ga_ai_bst_allies:rush_on_message("start");

ga_ai_cth_reinforcement:deploy_at_random_intervals_on_message(
	"timer_for_reinforcements", -- message
	4, 							-- min units
	6, 							-- max units
	1000, 					  	-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_cth_reinforcement:message_on_any_deployed("reinforcements_in");
--ga_ai_cth_reinforcement:move_to_position_on_message(objective_position, "reinforcements_in")
ga_ai_cth_reinforcement:message_on_proximity_to_enemy("reinforcement_rush", 50)
ga_ai_cth_reinforcement:rush_on_message("reinforcement_rush");

ga_ai_cth_relief_1:deploy_at_random_intervals_on_message(
	"phase_3_start", 			-- message
	4, 							-- min units
	6, 							-- max units
	1000, 					  	-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_cth_relief_2:deploy_at_random_intervals_on_message(
	"phase_3_start", 			-- message
	4, 							-- min units
	6, 							-- max units
	2000, 					  	-- min period
	3000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_cth_relief_2:message_on_any_deployed("relief_in");
--ga_ai_cth_relief_2:move_to_position_on_message(objective_position, "relief_in")
ga_ai_cth_relief_2:message_on_proximity_to_enemy("relief_rush", 50)
ga_ai_cth_relief_2:rush_on_message("relief_rush");
ga_ai_cth_relief_1:rush_on_message("relief_rush");

gb:add_listener(
	"phase_2_start",
	function()
		bm:callback(
			function()
				ga_player.sunits:get_general_sunit():set_enabled(false, true);
			end,
			1000
		)
	end
)

gb:add_listener(
	"phase_3_start",
	function()
		bm:callback(
			function()
				if phase_2_triggered == false then 
					bm:queue_help_message("wh3_dlc27_qb_nor_sayl_tower_of_ashshair_not_in_tower");
					gb.sm:trigger_message("player_lost"); 
				end
			end,
			100
		)
	end
)
ga_player:release_on_message("phase_3_start");
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--get to the tower--

gb:set_locatable_objective_on_message("intro_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_1", 1500, v(2, 1574, 520), objective_position, 1);
gb:fail_objective_on_message("player_lost", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_1", 2500);
--gb:message_on_all_messages_received("sayl_not_on_objective", "phase_3_start", "player_near_the_objective");
--gb:fail_objective_on_message("phase_3_start", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_1", 2500);
gb:complete_objective_on_message("phase_2_start", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_1", 2500);

--defend sayl, but you don't do anything basically survive--

gb:set_objective_on_message("phase_2_start", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_2", 4000);
gb:fail_objective_on_message("player_lost", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_2", 2500);
gb:complete_objective_on_message("phase_3_start", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_2", 2500);

--escape--
gb:set_locatable_objective_on_message("mid_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3", 1000, v(570, 1564, 220), escape_position, 1);
gb:fail_objective_on_message("player_lost", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3", 2500);
gb:complete_objective_on_message("sayl_escaped", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3", 2500);

--defeat the enemy (optional) --

gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3_optional", 3000);
gb:fail_objective_on_message("player_lost", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3_optional", 2500);
gb:complete_objective_on_message("enemy_army_is_defeated", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_objective_3_optional", 4000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--play mid cutscene--
gb:add_listener(
	"cth_relief_2_deployed",
	function()
		bm:callback(
			function()
			play_mid_cutscene()
			end,
			2000
		)
	end
)

local phase_1_short_vo = new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_short_VO_line", false, true);

gb:queue_help_on_message("intro_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_1", 10000, 2000, 2000)
gb:add_ping_icon_on_message("intro_cutscene_end", objective_position, 13);
gb:remove_ping_icon_on_message("phase_2_start", objective_position);

gb:queue_help_on_message("timer_for_reinforcements", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_2", 10000, 2000, 2000)
gb:message_on_time_offset("tower_vo_hint", 90000, "phase_2_start");
gb:queue_help_on_message("tower_vo_hint", "wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase1_04_short_VO")
gb:play_sound_on_message("tower_vo_hint", phase_1_short_vo);

gb:queue_help_on_message("mid_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_3", 10000, 2000, 1000)
gb:add_ping_icon_on_message("mid_cutscene_end", escape_position, 13);
gb:remove_ping_icon_on_message("sayl_escaped", escape_position);

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:message_on_shattered_proportion("player_army_defeated", 1);
ga_player:message_on_commander_dead_or_shattered("sayl_dead_or_shattered");
gb:message_on_any_message_received("player_lost", "player_army_defeated", "sayl_dead_or_shattered");
ga_ai_cth_main:force_victory_on_message("player_lost", 3000);

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

bm:watch(
	function()
		return standing_is_close_to_position(ga_player.sunits:get_general_sunit(), escape_position, 20, true, false) 
	end,
	0,
	function()
		gb.sm:trigger_message("sayl_escaped")
	end,
	"check_if_sayl_is_escaping"
)

ga_ai_cth_main:message_on_shattered_proportion("enemy_is_shattered", 1);
gb:message_on_all_messages_received("enemy_army_is_defeated", "cth_relief_2_deployed", "enemy_is_shattered");
gb:message_on_any_message_received("player_wins", "enemy_army_is_defeated", "sayl_escaped");
ga_player:force_victory_on_message("player_wins", 5000);