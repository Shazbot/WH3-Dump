-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Noctilus
-- Piece of 8
-- INSERT ENVIRONMENT NAME
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\qsg.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc11_Luthor_Harkon_QB_Slann_Gold_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc11_Luthor_Harkon_QB_Slann_Gold_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc11_Luthor_Harkon_QB_Slann_Gold_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc11_Luthor_Harkon_QB_Slann_Gold_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc11_Luthor_Harkon_QB_Slann_Gold_pt_05");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_main = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_defenders = gb:get_army(gb:get_non_player_alliance_num(),"enemy_defenders");
-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [450, 20] with an orientation of 45 degrees and a width of 25m
--ga_artillery.sunits:item(1).uc:teleport_to_location(v(-70, 140), 180, 25);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		70000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(2.5, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\qsg.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_harkon_quest_for_slann_gold_stage_4_intro_01", "subtitle_with_frame", 9) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 13000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_harkon_quest_for_slann_gold_stage_4_intro_02", "subtitle_with_frame", 16) end, 13500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 30500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_harkon_quest_for_slann_gold_stage_4_intro_03", "subtitle_with_frame", 9) end, 31000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 41500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_harkon_quest_for_slann_gold_stage_4_intro_04", "subtitle_with_frame", 16) end, 42000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 58500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 59000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_harkon_quest_for_slann_gold_stage_4_intro_05", "subtitle_with_frame", 9) end, 59500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 69000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

gb:message_on_time_offset("go", 30000);
gb:message_on_time_offset("reinforce", 160000);

ga_enemy_defenders:message_on_under_attack("defenders_under_attack");
--ga_enemy_defenders:message_on_casualties("reinforcements_enemy", 0.1);

ga_enemy_defenders:release_on_message("go");

ga_enemy_defenders:message_on_rout_proportion("defenders_defeated", 0.8);
ga_enemy_defenders:rout_over_time_on_message("defenders_defeated", 10000);

ga_enemy_main:reinforce_on_message("reinforce", 100);
ga_enemy_main:attack_on_message("reinforce", 10);

ga_enemy_main:message_on_rout_proportion("done", 0.8);


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
objective = "wh2_dlc11_qb_harkon_battle_objective_defeat_tower_defenders_01";

gb:set_objective_on_message("01_intro_cutscene_end", objective);

gb:complete_objective_on_message("defenders_defeated", objective);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc11_cst_harkon_quest_for_slann_gold_stage_5_hints_start_battle", 6000, nil, 5000);

gb:queue_help_on_message("reinforce", "wh2_dlc11_cst_harkon_quest_for_slann_gold_stage_5_hints_start_battle_02", 6000, nil, 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
local sm = get_messager();
-------ARMY ABILITY-------
local army_abilities = "wh2_dlc11_army_abilities_rod_of_the_storm";

function show_army_abilities(value)
	local army_ability_parent = get_army_ability_parent();
	
	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities):SetVisible(value);

end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities(false);

sm:add_listener(
	"defenders_defeated",
	function()
		show_army_abilities(true);
		
		bm:callback(
			function()
				highlight_army_ability(true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(false);
			end,
			7000
		);
	end
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------