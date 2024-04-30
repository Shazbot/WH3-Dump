-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Quest Battle: A Fellow Engineer
-- Map - wh2_def_nor_coast_infield_qb (originally Naggaroth Norscan Coast 01 – 02)
-- Attacker (Land)

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                        		-- prevent deployment for ai
	function() play_intro_cutscene() end,	          	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true)


----SFX----

local cutscene_sfx_sweetener_play = new_sfx("Play_Movie_WH3_DLC25_QB_Malakai_Eyes_Of_Grungni", true, false)
local cutscene_sfx_sweetener_stop = new_sfx("Stop_Movie_WH3_DLC25_QB_Eyes_Of_Grungni", false, false)


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--GOOD GUYS
ga_player = gb:get_army(gb:get_player_alliance_num(), 1);
--AI Allies
ga_ally_captives_ai_03 = gb:get_army(gb:get_player_alliance_num(), "ally_captives");
ga_ai_master_engineer = gb:get_army(gb:get_player_alliance_num(), "ally_master_engi");

--BAD GUYS
ga_enemy_def_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_dark_elves_01");
ga_enemy_def_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_dark_elves_02");


-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	bm:out("playing intro cutscene")
	
	local cam = bm:camera()

	cam:fade(false, 1)

	ga_player.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_enemy_def_ai_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
		"script/battle/quest_battles/_cutscene/managers/the_eyes_of_grungni_m01.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        2
	)

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(false, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
		
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_01"))
				bm:show_subtitle("wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_02"))
				bm:show_subtitle("wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_03"))
				bm:show_subtitle("wh3_dlc25_qb_dwf_malakai_eyes_of_grungni_03", false, true)
			end
	)

	---SFX Trigger---

    cutscene_intro:action(function() cutscene_intro:play_sound(cutscene_sfx_sweetener_play) end,1000)
    -----------------

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(cutscene_sfx_sweetener_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	battle_start_dwarf_units()
end



-------------------------------------------------------------------------------------------------
---------------------------------------------- SETUP --------------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_dwarf_units()
	gb:message_on_time_offset("start", 100);
	bm:set_objective("wh3_dlc25_dwf_malakai_fellow_engineer_objective_01");
end

-------------------------------------------------------------------------------------------------
--------------------------------------- ALLY ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- Master Engineer exits the Mine first, followed by assembled captives and joins the fight
ga_ai_master_engineer:reinforce_on_message("def_army_1_casualty_trigger");
ga_ai_master_engineer:message_on_any_deployed("master_engineer_emerges");
gb:message_on_time_offset("captives_emerge", 6500, "master_engineer_emerges");
ga_ally_captives_ai_03:reinforce_on_message("captives_emerge");
ga_ally_captives_ai_03:message_on_any_deployed("captives_deployed");
ga_ai_master_engineer:rush_on_message("captives_deployed");
ga_ally_captives_ai_03:rush_on_message("captives_deployed");

-------------------------------------------------------------------------------------------------
-------------------------------------- ENEMY ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- Phase 1: DEF army 1 orders
ga_enemy_def_ai_01:attack_force_on_message("start", ga_player, 2000);
ga_enemy_def_ai_01:message_on_casualties("def_army_1_casualty_trigger",0.40);
ga_enemy_def_ai_01:message_on_casualties("def_army_1_defeated_trigger",0.70);

-- Phase 2: Deploy DEF army 2 when Dreadlord is weakened
ga_enemy_def_ai_02:reinforce_on_message("captives_emerge", 45000);
ga_enemy_def_ai_02:message_on_any_deployed("second_dreadlord_forces");
ga_enemy_def_ai_02:rush_on_message("second_dreadlord_forces");
ga_enemy_def_ai_02:message_on_casualties("def_army_2_defeated_trigger",0.70);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:complete_objective_on_message("slavers_subdued", "wh3_dlc25_dwf_malakai_fellow_engineer_objective_01");

gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_engineer_hint_01");
gb:queue_help_on_message("def_army_1_casualty_trigger", "wh3_dlc25_dwf_malakai_engineer_hint_02");
gb:queue_help_on_message("captives_emerge", "wh3_dlc25_dwf_malakai_engineer_hint_03", 10000, 2000, 43000);
gb:queue_help_on_message("slavers_subdued", "wh3_dlc25_dwf_malakai_engineer_hint_04");

-------------------------------------------------------------------------------------------------
----------------------------------------- VICTORY/DEFEAT ----------------------------------------
-------------------------------------------------------------------------------------------------

--VICTORY
--Listen for defeat
gb:message_on_all_messages_received("slavers_subdued", "def_army_1_defeated_trigger", "def_army_2_defeated_trigger");

-- Rout over time when the targets are dead
ga_enemy_def_ai_01:rout_over_time_on_message("slavers_subdued", 15000)
ga_enemy_def_ai_02:rout_over_time_on_message("slavers_subdued", 15000)
ga_player:force_victory_on_message("slavers_subdued", 20000)

--DEFEAT
gb:fail_objective_on_message("player_defeated", "wh3_dlc25_dwf_malakai_fellow_engineer_objective_01", 5);
ga_player:message_on_rout_proportion("player_defeated", 1);
ga_enemy_def_ai_01:force_victory_on_message("player_defeated", 15000);