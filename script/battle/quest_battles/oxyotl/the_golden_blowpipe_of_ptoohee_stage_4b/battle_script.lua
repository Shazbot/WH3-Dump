-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Oxyotl
-- The Golden Blowpipe of P'Toohee
-- Version B without enemy reinforcements
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/ptoohee.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

gb:set_cutscene_during_deployment(true);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_04b");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player.sunits,						-- unitcontroller over player's army
		42000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/ptoohee.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_01", "subtitle_with_frame", 10, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_02", "subtitle_with_frame", 6, true) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_03", "subtitle_with_frame", 10, true) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 33500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_04b", "subtitle_with_frame", 7, true) end, 33500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41500);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");

enemy_main = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", true, true);
enemy_main:change_behaviour_active_on_message("battle_started", "fire_at_will", true, true);

--Release enemy_main once cutsene is done
enemy_main:release_on_message("battle_started", 10);

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 0.95);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("battle_started", "wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("battle_started", "wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_hints_start_battle", 7000, 2000, 0);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_main:force_victory_on_message("player_defeated", 5000);