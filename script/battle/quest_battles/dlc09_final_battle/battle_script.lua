 
------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Settra
-- Final Battle
-- Black Pyramid
-- Attacking

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

-- include shared script 
local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;

require("battle_script_shared");

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tbp.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
local sm = get_messager();
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_tmb_settra_qb_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_tmb_settra_qb_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_tmb_settra_qb_final_battle_pt_03");

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
		ga_player.sunits,					-- unitcontroller over player's army
		40000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tbp.CindySceneManager", true) end, 200);
	
	-- cutscene_intro:action(
		-- function()
			-- player_units_hidden = false;
			-- ga_player:set_enabled(true) 
		-- end, 
		-- 200
	-- );	
	-- cutscene_intro:action(
		-- function() 
			-- player_units_hidden = false;
			-- ga_player:set_enabled(true) 
		-- end, 
		-- 25000
	-- );		
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_qb_final_battle_pt_01", "subtitle_with_frame", 6)	end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11600);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11700);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_qb_final_battle_pt_02", "subtitle_with_frame", 8.5)	end, 11650);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 23100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_qb_final_battle_pt_03", "subtitle_with_frame", 6.5)	end, 23050);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 32100);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

declare_armies();

-------ARMY ABILITY-------
local army_abilities = {
	"wh2_dlc09_army_abilities_barrage_of_the_legion",
	"wh2_dlc09_army_abilities_tomb_swarm"
};

function show_army_abilities(seq, value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities[seq]):SetVisible(value);
		
end;

function highlight_army_ability(seq, value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities[seq]):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

for i = 1, #army_abilities do
	show_army_abilities(i, false);
end

sm:add_listener(
	"unlock_first_ability",
	function()
		show_army_abilities(1, true);
		
		bm:callback(
			function()
				highlight_army_ability(1, true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(1, false);
			end,
			7000
		);
	end
);

sm:add_listener(
	"unlock_second_ability",
	function()
		show_army_abilities(2, true);
		
		bm:callback(
			function()
				highlight_army_ability(2, true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(2, false);
			end,
			7000
		);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


battle_orders();

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
battle_message();
gb:queue_help_on_message("unlock_first_ability", "wh2_dlc09_tmb_qb_final_battle_hint_khalida_ready",10000,1000);
gb:queue_help_on_message("unlock_second_ability", "wh2_dlc09_tmb_qb_final_battle_hint_khatep_ready",10000,1000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_skaven", 3000, nil, 5000);
-- gb:queue_help_on_message("bat_1", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_00");
-- gb:queue_help_on_message("bat_2", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_01");
-- gb:queue_help_on_message("bat_3", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

