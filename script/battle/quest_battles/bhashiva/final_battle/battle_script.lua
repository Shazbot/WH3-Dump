-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Bhashiva the White Tiger
-- By Hristo Enev
-- Final Battle: End of the Hunt

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

countdown_length = 8*60*1000
temp_timer = countdown_length
reinforcements_kill_timer=countdown_length*2;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_cth_allies = gb:get_army(gb:get_player_alliance_num(), "cth_ally")
ga_ai_cth_allies_additional = gb:get_army(gb:get_player_alliance_num(), "cth_ally_additional")

ga_ai_ogre_main = gb:get_army(gb:get_non_player_alliance_num(), "ogres_main")
ga_ai_chaos_main = gb:get_army(gb:get_non_player_alliance_num(), "chaos_main")
ga_ai_daemons_boss = gb:get_army(gb:get_non_player_alliance_num(), "daemons_boss")
ga_ai_daemons_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), "daemons_reinforcements")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

cth_reinforcement = bm:get_spawn_zone_collection_by_name("cathay_reinforcements")
cth_reinforcement_additional= bm:get_spawn_zone_collection_by_name("cathay_reinforcements_additional")
daemon_main = bm:get_spawn_zone_collection_by_name("daemons_main")
daemon_waves = bm:get_spawn_zone_collection_by_name("daemons_reinf")

ga_ai_cth_allies:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforcement, false);
ga_ai_cth_allies:message_on_number_deployed("cth_ally_deployed", true, 5);
ga_ai_cth_allies_additional:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforcement_additional, false);
ga_ai_cth_allies_additional:message_on_number_deployed("cth_ally_deployed", true, 5);

ga_ai_daemons_boss:assign_to_spawn_zone_from_collection_on_message("start", daemon_main, false);
ga_ai_daemons_boss:message_on_number_deployed("daemon_boss_deployed", true, 4);
ga_ai_daemons_reinforcement:assign_to_spawn_zone_from_collection_on_message("start", daemon_waves, false);
ga_ai_daemons_reinforcement:message_on_number_deployed("daemon_reinforcements_deployed", true, 4);

-------------------------------------------------------------------------------------------------
------------------------------------------ TELEPORT ---------------------------------------------
-------------------------------------------------------------------------------------------------
--[[
ogre_army_teleport_locations = {
	{x = -168, y = -126, orientation = 0.0}, -- Engineer
	{x = -195, y = -145, orientation = 0.0}, -- Swordsmen 1
	{x = -141, y = -145, orientation = 0.0}, -- Swordsmen 2
	{x = -195, y = -126, orientation = 0.0}, -- Huntsmen 1
	{x = -141, y = -126, orientation = 0.0}, -- Huntsmen 2
}

function battle_start_teleport_emp_allies()
	for i=1, ga_ai_ogre_main.sunits:count() do
		local sunit = ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count())
		local location = v(emp_allies_teleport_locations[i].x, emp_allies_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, emp_allies_teleport_locations[i].orientation, 40)
	end
end
]]--
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro = new_sfx("Play_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Intro", false, false)
local sfx_cutscene_sweetener_mid = new_sfx("Play_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Mid", false, false)
local sfx_cutscene_sweetener_outro = new_sfx("Play_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_CP1_FB_Bhashiva_End_of_The_Hunt_Outro", false, false)
	
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
		"script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_fb_intro_01.CindySceneManager",	-- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)

	local player_units_hidden = false;
	ga_ai_ogre_main.sunits:set_always_visible(true);
	ga_ai_chaos_main.sunits:set_always_visible(true);
	ga_player.sunits:get_general_sunit():set_invisible_to_all(true);
	ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):set_invisible_to_all(true);
	ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):set_invisible_to_all(true);

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
			ga_player:set_enabled(true);
		end, 
		200
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

		-- Voiceover and Subtitles --
		
		cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro) end, 0);
		
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase1_01", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_01"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase1_01", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase1_02", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_02"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase1_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase1_03", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_03"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase1_03", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase1_04", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_04"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase1_04", false, true)
				end
		)

	cutscene_intro:start()
end

function intro_cutscene_end()
	--teleport bhasiva infront of the army
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	bhashiva_location_vector=v(611, 295, 210);
	--camera position
	camera_target=v(666, 291, 271);
	camera_position=v(715, 340, 342);
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	ga_player.sunits:item(1):teleport_to_location(bhashiva_location_vector, 230, 3);
	player_units_hidden = false;
	ga_player:set_enabled(true) 
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):set_invisible_to_all(false);
	ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):set_invisible_to_all(false);
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
			"script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_fb_middle_01.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
		
		ga_player.sunits:set_invisible_to_all(true);
		ga_ai_cth_allies.sunits:set_invisible_to_all(true);
		ga_ai_cth_allies_additional.sunits:set_invisible_to_all(true);
		ga_ai_daemons_boss.sunits:set_invisible_to_all(true);
		ga_ai_ogre_main.sunits:set_invisible_to_all(true);
		ga_ai_chaos_main.sunits:set_invisible_to_all(true);

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
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_0_5", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_0_5"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_0_5", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_01", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_01"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_01", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_02", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_02"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_02", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_03", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_03"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_03", false, true)
				end
		)

		cutscene_mid:start()
	end, 100)
end

function mid_cutscene_end()
	--camera position
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	camera_target=v(60, 275, -269, -1)
	camera_position=v(222, 367, -222, -1)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	cam:fade(false, 0.5);
	player_units_hidden = false;
	ga_player:set_enabled(true);
	ga_player.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies_additional.sunits:set_invisible_to_all(false);
	ga_ai_daemons_boss.sunits:set_invisible_to_all(false);
	ga_ai_ogre_main.sunits:set_invisible_to_all(false);
	ga_ai_chaos_main.sunits:set_invisible_to_all(false);
	gb.sm:trigger_message("mid_cutscene_end")
end

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO CUTSCENE ---------------------------------------
-------------------------------------------------------------------------------------------------
function play_outro_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		--cam:fade(false, 2)

		local cutscene_outro = cutscene:new_from_cindyscene(
			"cutscene_outro", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() outro_cutscene_end() end,															-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_fb_p02_outro_01.CindySceneManager",-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
		
		ga_player.sunits:set_invisible_to_all(true);
		ga_ai_daemons_boss.sunits:set_invisible_to_all(true);
		--ga_ai_bst_allies.sunits:set_invisible_to_all(true);
		--ga_ai_cth_reinforcement.sunits:set_invisible_to_all(true);
		--ga_player.sunits:set_invisible_to_all(true);


		-- set up subtitles
		local subtitles = cutscene_outro:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_outro:set_skippable(
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
		cutscene_outro:action(function() cam:fade(false, 1) end, 1000)

		-- Voiceover and Subtitles --
		--cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro) end, 0);
		
		cutscene_outro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_04", 
				function()
					cutscene_outro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_04"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_04", false, true)
				end
		)

		cutscene_outro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_05", 
				function()
					cutscene_outro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_05"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_05", false, true)
				end
		)

		cutscene_outro:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_FB_Phase2_06", 
				function()
					cutscene_outro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase2_06"))
					bm:show_subtitle("wh3_cp1_qb_cth_bhashiva_final_battle_phase2_06", false, true)
				end
		)

		cutscene_outro:start()
	end, 1000)
end

function outro_cutscene_end()
	--camera position
	camera_target=v(-8, 272, -306)
	camera_position=v(-15, 370, -180)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	cam:fade(false, 0.5);
	player_units_hidden = false;
	ga_player:set_enabled(true);
	ga_player.sunits:set_invisible_to_all(false);
	ga_ai_daemons_boss.sunits:set_invisible_to_all(false);
	gb.sm:trigger_message("outro_cutscene_end")
end

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);

ga_ai_chaos_main:message_on_casualties("chaos_casualties_sustained",0.7)
ga_ai_ogre_main:message_on_casualties("ogre_casualties_sustained",0.7)
gb:message_on_all_messages_received("phase_2_start","ogre_casualties_sustained","chaos_casualties_sustained")

--play mid cutscene--
gb:add_listener(
	"boss_in",
	function()
		bm:callback(
			function()
			play_mid_cutscene()
			end,
			1000
		)
	end
)

gb:message_on_time_offset("show_reinforcement_armies", 40000, "boss_in")
gb:add_listener(
	"show_reinforcement_armies",
	function()
	ga_player.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies_additional.sunits:set_invisible_to_all(false);
	ga_ai_daemons_boss.sunits:set_invisible_to_all(false);
	ga_ai_ogre_main.sunits:set_invisible_to_all(false);
	ga_ai_chaos_main.sunits:set_invisible_to_all(false);
	end,
	true
)

gb:message_on_time_offset("show_final_armies", 29000, "player_wins")
gb:add_listener(
	"show_final_armies",
	function()
	ga_player.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies.sunits:set_invisible_to_all(false);
	ga_ai_cth_allies_additional.sunits:set_invisible_to_all(false);
	ga_ai_daemons_boss.sunits:set_invisible_to_all(false);
	ga_ai_ogre_main.sunits:set_invisible_to_all(false);
	ga_ai_chaos_main.sunits:set_invisible_to_all(false);
	end,
	true
)

--play outro cutscene--
gb:add_listener(
	"player_wins",
	function()
		play_outro_cutscene()
	end,
	true
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ogre_main:rush_position_on_message("intro_cutscene_end", 417, -25, 100)

ga_ai_chaos_main:message_on_proximity_to_enemy("chaos_rush_when_close", 150)
ga_ai_chaos_main:rush_on_message("chaos_rush_when_close");
ga_ai_ogre_main:message_on_proximity_to_enemy("ogre_rush_when_close", 150)
ga_ai_ogre_main:rush_on_message("ogre_rush_when_close");

--Damaging Cathay army from the siege
ga_ai_cth_allies:kill_proportion_over_time_on_message(1, reinforcements_kill_timer, false, "intro_cutscene_end")
ga_ai_cth_allies_additional:kill_proportion_over_time_on_message(1, reinforcements_kill_timer, false, "intro_cutscene_end")
gb:message_on_any_message_received("stop_killing","failed_optional_objective","completed_optional_objective")
ga_ai_cth_allies:stop_kill_proportion_over_time_on_message("stop_killing")
ga_ai_cth_allies_additional:stop_kill_proportion_over_time_on_message("stop_killing")

--Additional Damage to Cathay army because of failing the optional objective
ga_ai_cth_allies:kill_proportion_over_time_on_message(1, 5000, true, "failed_optional_objective")
ga_ai_cth_allies_additional:kill_proportion_over_time_on_message(1, 5000, true, "failed_optional_objective")
gb:message_on_time_offset("stop_damaging_ally", 1000, "failed_optional_objective"); 
ga_ai_cth_allies:stop_kill_proportion_over_time_on_message("stop_damaging_ally")
ga_ai_cth_allies_additional:stop_kill_proportion_over_time_on_message("stop_damaging_ally")

--Forcing Initial enemy armies to rout when Phase 2 starts
ga_ai_chaos_main:rout_over_time_on_message("phase_2_start",50000)
ga_ai_ogre_main:rout_over_time_on_message("phase_2_start",50000)

--Reinforcements deploying

ga_ai_cth_allies:deploy_at_random_intervals_on_message(
	"phase_2_start", 	-- message
	5, 							-- min units
	6, 							-- max units
	3000, 					  	-- min period
	5000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_cth_allies_additional:deploy_at_random_intervals_on_message(
	"phase_2_start", 	-- message
	5, 							-- min units
	6, 							-- max units
	3000, 					  	-- min period
	5000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_cth_allies:message_on_any_deployed("reinforcements_in");
ga_ai_cth_allies:advance_on_message("reinforcements_in");
ga_ai_cth_allies_additional:advance_on_message("reinforcements_in");

ga_ai_daemons_boss:deploy_at_random_intervals_on_message(
	"phase_2_start", 			-- message
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

ga_ai_daemons_boss:message_on_any_deployed("boss_in");
ga_ai_daemons_boss:advance_on_message("boss_in");
ga_ai_daemons_boss:message_on_proximity_to_enemy("boss_attack", 150)
ga_ai_daemons_boss:release_on_message("boss_attack", 5000);

ga_ai_daemons_reinforcement:deploy_at_random_intervals_on_message(
	"mid_cutscene_end", 		-- message
	4, 							-- min units
	4, 							-- max units
	50000, 					  	-- min period
	60000, 						-- max period
	"player_wins",				-- cancel message
	false,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_daemons_reinforcement:message_on_any_deployed("wave_in");
ga_ai_daemons_reinforcement:advance_on_message("wave_in");
ga_ai_daemons_reinforcement:message_on_proximity_to_enemy("boss_attack", 150)
ga_ai_daemons_reinforcement:attack_on_message("boss_attack");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--engage the enemy--

gb:set_objective_on_message("intro_cutscene_end", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1", 3000);
gb:fail_objective_on_message("player_lost", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1", 1500);
gb:complete_objective_on_message("phase_2_start", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1", 1500);

--bhashiva needs to survive--

gb:set_objective_on_message("intro_cutscene_end", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_peramanent", 6000);
gb:fail_objective_on_message("player_lost", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_peramanent", 1500);
gb:complete_objective_on_message("player_wins", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_peramanent", 2500);

--kill targets (optional)--
gb:message_on_time_offset("trigger_optional_objective", 1000, "chaos_rush_when_close" )
gb:set_objective_on_message("trigger_optional_objective", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1_optional", 1000);
gb:fail_objective_on_message("failed_optional_objective", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1_optional", 1500);
gb:complete_objective_on_message("completed_optional_objective", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_1_optional", 1500);

gb:add_listener(
    "trigger_optional_objective",
	function()
		bm:set_objective("wh3_cp1_qb_cth_bhashiva_final_battle_objective_1_optional", countdown_length)
		bm:repeat_callback(
			function()
				temp_timer = temp_timer - 1000
				bm:set_objective("wh3_cp1_qb_cth_bhashiva_final_battle_objective_1_optional", temp_timer/1000, countdown_length/1000)
				if is_routing_or_dead(ga_ai_ogre_main.sunits:item(1)) then
					sm:trigger_message("ogre_commander_dead")
				end
				if is_routing_or_dead(ga_ai_chaos_main.sunits:item(1)) then
					sm:trigger_message("chaos_commander_dead")
				end
				if is_routing_or_dead(ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count())) then
					sm:trigger_message("ogre_artillery_dead")
				end
				if is_routing_or_dead(ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count())) then
					sm:trigger_message("chaos_artillery_dead")
				end
				gb:message_on_all_messages_received("completed_optional_objective","ogre_commander_dead","chaos_commander_dead","ogre_artillery_dead","chaos_artillery_dead")
				if temp_timer <= 1 then 
					sm:trigger_message("enemies_not_killed_in_time")
					gb:block_message_on_message("enemies_not_killed_in_time","completed_optional_objective",true)
					bm:remove_callback("end_countdown");
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

gb:add_listener(
	"completed_optional_objective",
	function()
		gb:block_message_on_message("completed_optional_objective","optional_objective_not_completed",true)
		bm:remove_callback("end_countdown");
	end
);

gb:add_listener(
	"ogre_commander_dead",
	function()
		ga_ai_ogre_main.sunits:item(1):remove_ping_icon();
	end
);

gb:add_listener(
	"chaos_commander_dead",
	function()
		ga_ai_chaos_main.sunits:item(1):remove_ping_icon();
	end
);

gb:add_listener(
	"ogre_artillery_dead",
	function()
		ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):remove_ping_icon();
	end
);

gb:add_listener(
	"chaos_artillery_dead",
	function()
		ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):remove_ping_icon();
	end
);

gb:add_listener(
	"failed_optional_objective",
	function()
		ga_ai_ogre_main.sunits:item(1):remove_ping_icon();
		ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):remove_ping_icon();
		ga_ai_chaos_main.sunits:item(1):remove_ping_icon();
		ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):remove_ping_icon();
		bm:remove_callback("end_countdown");
	end
);

gb:add_listener(
	"phase_2_start",
	function()
		ga_ai_ogre_main.sunits:item(1):remove_ping_icon();
		ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):remove_ping_icon();
		ga_ai_chaos_main.sunits:item(1):remove_ping_icon();
		ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):remove_ping_icon();
		bm:remove_callback("end_countdown");
		if temp_timer >= 1 then
			sm:trigger_message("optional_objective_not_completed")
		end
	end
);

gb:message_on_any_message_received("failed_optional_objective", "player_lost", "enemies_not_killed_in_time","optional_objective_not_completed")

--kill boss--
gb:set_objective_on_message("mid_cutscene_end", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_2", 2500);
gb:fail_objective_on_message("player_lost", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_2", 2500);
gb:complete_objective_on_message("player_wins", "wh3_cp1_qb_cth_bhashiva_final_battle_objective_2", 2000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"trigger_optional_objective",
	function()
		ga_ai_ogre_main.sunits:item(1):add_ping_icon(15);
		ga_ai_ogre_main.sunits:item(ga_ai_ogre_main.sunits:count()):add_ping_icon(15);
		ga_ai_chaos_main.sunits:item(1):add_ping_icon(15);
		ga_ai_chaos_main.sunits:item(ga_ai_chaos_main.sunits:count()):add_ping_icon(15);
	end
);

local optional_objective_success_vo = new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_Optional_Complete_01", false, true);
local optional_objective_fail_vo = new_sfx("Play_wh3_cp1_cat_Bhashiva_FB_Phase1_Optional_Failed_01", false, true);

gb:queue_help_on_message("intro_cutscene_end", "wh3_cp1_qb_cth_bhashiva_final_battle_hint_starting", 10000, 2000, 2000)

gb:block_message_on_message("phase_2_start","trigger_hint_for_completed_optional_objective", true)
gb:message_on_time_offset("trigger_hint_for_completed_optional_objective",1000,"completed_optional_objective")
gb:block_message_on_message("completed_optional_objective","failed_optional_objective", true)
gb:queue_help_on_message("trigger_hint_for_completed_optional_objective", "wh3_cp1_qb_cth_bhashiva_final_battle_hint_optional_objective_success", 10000, 2000, 2000)
gb:play_sound_on_message("trigger_hint_for_completed_optional_objective", optional_objective_success_vo);



gb:block_message_on_message("phase_2_start","trigger_hint_for_failed_optional_objective", true)
gb:message_on_time_offset("trigger_hint_for_failed_optional_objective",1000,"failed_optional_objective")
gb:queue_help_on_message("trigger_hint_for_failed_optional_objective", "wh3_cp1_qb_cth_bhashiva_final_battle_hint_optional_objective_fail", 10000, 2000, 2000)
gb:play_sound_on_message("trigger_hint_for_failed_optional_objective", optional_objective_fail_vo);

gb:message_on_time_offset("boss_hint", 5000, "mid_cutscene_end")
gb:queue_help_on_message("boss_hint", "wh3_cp1_qb_cth_bhashiva_final_battle_hint_boss", 10000, 2000, 2000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:message_on_shattered_proportion("player_army_defeated", 1);
ga_player:message_on_commander_dead_or_shattered("bhashiva_dead_or_shattered");
gb:message_on_any_message_received("player_lost", "player_army_defeated", "bhashiva_dead_or_shattered");
ga_ai_chaos_main:force_victory_on_message("player_lost", 3000);

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_daemons_boss:message_on_commander_dead_or_shattered("player_wins");
ga_player:force_victory_on_message("outro_cutscene_end", 100);