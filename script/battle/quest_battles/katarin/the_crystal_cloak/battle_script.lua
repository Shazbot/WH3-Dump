-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Katarin
-- The Crystal Cloak
-- The Fractal Labyrinth
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      			-- screen starts black
	false,                                      			-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/tcc.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_ksl_katarin_the_fractal_maze_01");
--wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_ksl_katarin_the_fractal_maze_02");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	if bm:is_multiplayer() then
		intro_cutscene_end();
		return;
	end;

	local cam = bm:camera();
	
	-- REMOVE ME
	--cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_defender_01.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/tcc.CindySceneManager",			-- path to cindyscene
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
				ga_defender_01:set_enabled(true)
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
			ga_defender_01:set_enabled(true);
			
			--Stopping units from firing/skirmishing
			ga_defender_01.sunits:change_behaviour_active("fire_at_will", false);
			ga_defender_01.sunits:change_behaviour_active("skirmish", false);
			ga_attacker_01.sunits:change_behaviour_active("fire_at_will", false);
			ga_attacker_01.sunits:change_behaviour_active("skirmish", false);
		end,
		100
	);

	cutscene_intro:action(
		function()
			ga_attacker_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end, 
		4000
	);

	cutscene_intro:action(
		function()
			ga_attacker_01.sunits:goto_location_offset(0, 90, false, nil, false);
		end, 
		8500
	);

	cutscene_intro:action(
		function()
			cam:fade(true, 0.5);
		end, 
		41000
	);
	
	-- Voiceover and Subtitles --
	
	-- A trap then! They come before we enter the Changer's maze. Clear the path my subjects, The Crystal Cloak was worn by the Khan-Queens of old. I claim it, and even the hexes of Tzeentch cannot overrule my birthright!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ksl_katarin_the_fractal_maze_01", 
		function()
			cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_katarin_the_fractal_maze_01"));
			bm:show_subtitle("wh3_main_qb_ksl_katarin_the_fractal_maze_01", false, true);
		end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ksl_katarin_the_fractal_maze_02", 
		function()
			cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_katarin_the_fractal_maze_02"));
			bm:show_subtitle("wh3_main_qb_ksl_katarin_the_fractal_maze_02", false, true);
		end
	)

	--Set camera position after cutscene

	local override_position = v(286.9, 711.3, 178);
	local override_target = v(146.6, 579,-75.7);

	cutscene_intro:set_restore_cam(0, override_position, override_target);

	cutscene_intro:set_music("CrystalCloak_TheFractalMaze", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	--ga_attacker_01.sunits:release_control()
	gb.sm:trigger_message("01_intro_cutscene_end")

	if not bm:is_multiplayer() then
		ga_defender_01.sunits:change_behaviour_active("fire_at_will", true);
		-- ga_defender_01.sunits:change_behaviour_active("skirmish", true);
		ga_attacker_01.sunits:change_behaviour_active("fire_at_will", true);
		ga_attacker_01.sunits:change_behaviour_active("skirmish", true);
	end;	
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_defender_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_1");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Enemy Deployment Setup -------------------------------------

--Herald of Tzeentch
ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(328, -159), 315, 1.4);

--Blue Horrors
ga_attacker_01.sunits:item(2).uc:teleport_to_location(v(92, 250), 115, 42);

--Blue Horrors
ga_attacker_01.sunits:item(3).uc:teleport_to_location(v(380, 274), 57, 42);

--Blue Horrors
ga_attacker_01.sunits:item(4).uc:teleport_to_location(v(155, -122), 45, 42);

--Blue Horrors
ga_attacker_01.sunits:item(5).uc:teleport_to_location(v(334, -58), 275, 42);

--Forsaken
ga_attacker_01.sunits:item(6).uc:teleport_to_location(v(257, -166), 320, 40);

--Forsaken
ga_attacker_01.sunits:item(7).uc:teleport_to_location(v(301, -144), 332, 40);

--Pink Horrors
ga_attacker_01.sunits:item(8).uc:teleport_to_location(v(289, -186), 320, 40);

--Pink Horrors
ga_attacker_01.sunits:item(9).uc:teleport_to_location(v(63, 240), 97, 40);

--Pink Horrors
ga_attacker_01.sunits:item(10).uc:teleport_to_location(v(375, 44), 286, 40);

--Pink Horrors
ga_attacker_01.sunits:item(11).uc:teleport_to_location(v(388, 177), 280, 40);

--Chaos Knights
ga_attacker_01.sunits:item(12).uc:teleport_to_location(v(135, -142), 40, 30);

--Doom Knights
ga_attacker_01.sunits:item(13).uc:teleport_to_location(v(382, -61), 280, 30);

--Doom Knights
ga_attacker_01.sunits:item(14).uc:teleport_to_location(v(342, -167), 306, 30);

--Screamers
ga_attacker_01.sunits:item(15).uc:teleport_to_location(v(356, 31), 292, 24);

--Screamers
ga_attacker_01.sunits:item(16).uc:teleport_to_location(v(368, 63), 292, 24);

--Exalted Flamers
ga_attacker_01.sunits:item(17).uc:teleport_to_location(v(232, -156), 350, 3);

--Flamers
ga_attacker_01.sunits:item(18).uc:teleport_to_location(v(394, 51), 286, 20);

--Flamers
ga_attacker_01.sunits:item(19).uc:teleport_to_location(v(289, -186), 286, 20);

--Soul Grinder
ga_attacker_01.sunits:item(20).uc:teleport_to_location(v(372, -64), 285, 8);

end;

battle_start_teleport_units();

-- gb:add_listener(
-- 	"advance",
-- 	function()
-- 		ga_attacker_01.sunits:goto_location_offset(0, 90, false, nil, false);
-- 	end
-- );

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:fade_in_on_message("battle_started", 0.5);

ga_attacker_01:release_on_message("01_intro_cutscene_end");

--gb:message_on_time_offset("enemy_visible", 4000, "battle_started");
--gb:message_on_time_offset("advance", 8500, "battle_started");

gb:message_on_time_offset("rush", 500, "01_intro_cutscene_end");

--gb:message_on_time_offset("rush", 8600, "battle_started");

--gb:message_on_time_offset("attack", 8500, "battle_started");
--ga_attacker_01:set_always_visible_on_message("enemy_visible", true);
--ga_attacker_01:set_always_visible_on_message("01_intro_cutscene_end", false);
--ga_attacker_01:rush_on_message("01_intro_cutscene_end");

ga_attacker_01:rush_on_message("rush");

--ga_attacker_01:attack_on_message("advance");

ga_defender_01:set_invincible_on_message("battle_started", true);
ga_defender_01:set_invincible_on_message("01_intro_cutscene_end", false);
ga_defender_01:release_on_message("01_intro_cutscene_end");


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Destroy the ambushing army!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_katarin_crystal_cloak_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--The Daemon filth have ambushed us. We must destroy them utterly!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_katarin_crystal_cloak_hints_main_hint", 10000, 2000, 5000, false);

--Back to the abyss with you, foul servant of Tzeentch!
ga_attacker_01:message_on_commander_dead_or_shattered("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_ksl_katarin_crystal_cloak_hints_lord_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
