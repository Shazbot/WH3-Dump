-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Eltharion
-- Talisman of Hoeth
-- INSERT ENVIRONMENT NAME
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\elt_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_allied_reinforcements = gb:get_army(gb:get_player_alliance_num(), "allied_reinforcements");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_fimir = gb:get_army(gb:get_non_player_alliance_num(),"fimir_reinforcements");
ga_enemy_lord_of_change = gb:get_army(gb:get_non_player_alliance_num(),"lord_of_change_reinforcements");




-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
    --battle_start_teleport_units();
    
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
        ga_defender_01.sunits,					-- unitcontroller over player's army
		63000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(1.0, 1000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
                ga_defender_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\elt_01.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
            ga_defender_01:set_enabled(true) 
		end, 
		200
	);
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_01", "subtitle_with_frame", 8, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_02", "subtitle_with_frame", 8, true) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 32000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 33000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_03", "subtitle_with_frame", 8, true) end, 33000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 45000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 46000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_Talisman_of_Hoeth_pt_04", "subtitle_with_frame", 8, true) end, 46000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 58000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping armies from firing until the cutscene is done
ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

gb:message_on_time_offset("army_ability", 12000,"01_intro_cutscene_end");
gb:message_on_time_offset("army_ability_off", 20000,"01_intro_cutscene_end");

gb:message_on_time_offset("warning", 70000,"01_intro_cutscene_end");

gb:message_on_time_offset("reinforce_1", 90000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_1_attack", 90000,"01_intro_cutscene_end");

gb:message_on_time_offset("reinforce_2", 180000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_2_attack", 180000,"01_intro_cutscene_end");

gb:message_on_time_offset("reinforce_3", 300000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_3_release", 300000,"01_intro_cutscene_end");

gb:message_on_time_offset("enemy_release", 90000,"01_intro_cutscene_end");
ga_enemy:attack_on_message("01_intro_cutscene_end");
ga_enemy:release_on_message("enemy_release");

ga_enemy_fimir:reinforce_on_message("reinforce_1", 10);
ga_enemy_fimir:attack_on_message("reinforcement_1_attack");

ga_enemy_lord_of_change:reinforce_on_message("reinforce_2", 10);
ga_enemy_lord_of_change:attack_on_message("reinforcement_2_attack");

ga_allied_reinforcements:reinforce_on_message("reinforce_3", 10);
ga_allied_reinforcements:release_on_message("reinforcement_3_release");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_objective_01");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_01", 3000, nil, 5000);
gb:queue_help_on_message("army_ability", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_02", 6000, nil, 1000);
gb:queue_help_on_message("reinforce_1", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_04", 6000, nil, 5000);
gb:queue_help_on_message("reinforce_2", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_05", 6000, nil, 5000);
gb:queue_help_on_message("reinforce_3", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_06", 6000, nil, 5000);
gb:queue_help_on_message("warning", "wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_help_03", 6000, nil, 5000);


gb:add_listener("army_ability", function() highlight_army_ability(true) end)
gb:add_listener("army_ability_off", function() highlight_army_ability(false) end)
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
local army_abilities = {
	"wh2_dlc15_army_abilities_unleash_the_winds",
};


function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();
	
	for i = 1, #army_abilities do
		find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities[i]):Highlight(value, false, 100);
	end;
end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------