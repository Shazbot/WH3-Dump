 
------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Khatep
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tbp_khatep.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
local sm = get_messager();
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_tmb_khatep_qb_final_battle_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_tmb_khatep_qb_final_battle_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_tmb_khatep_qb_final_battle_03");
--wh2_main_sfx_04 = new_sfx("Play_wh2_dlc09_tmb_khatep_qb_final_battle_04");

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
		45000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tbp_khatep.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_khatep_qb_final_battle_01", "subtitle_with_frame", 5.5)	end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12600);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12700);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_khatep_qb_final_battle_02", "subtitle_with_frame", 6.5)	end, 12700);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 25600);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 25600);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_khatep_qb_final_battle_03", "subtitle_with_frame", 6.5)	end, 25600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 42100);
	
	-- cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 42200);	
	-- cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_khatep_qb_final_battle_04", "subtitle_with_frame", 6.5)	end, 42200);	
	-- cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 55200);
	
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
	"unlock_second_ability",
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

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_attacker_01:halt();
battle_orders();

-- ga_attacker_01:release_on_message("reinforcements_1", 100);
-- gb:message_on_time_offset("reinforcements_1", 43500);
-- ga_attacker_01:message_on_proximity_to_enemy("reinforcements_1", 190); -- Skaven ambush when the player approaches the main army
-- ga_attacker_01:message_on_casualties("reinforcements_1", 0.1); -- Backup to trigger Skaven reinforcements if the player tries to kill them from long range

-- ga_ally_01:reinforce_on_message("reinforcements_1");
-- ga_ally_02:reinforce_on_message("reinforcements_1");
-- ga_ally_01:attack_on_message("reinforcements_1", 100);
-- ga_ally_02:attack_on_message("reinforcements_1", 100);



-- ga_attacker_01:message_on_casualties("bat_1", 0.15); -- Bat wave when the player approaches the main army
-- ga_attacker_01:message_on_casualties("bat_2", 0.25); -- Bat wave when the player approaches the main army
-- ga_attacker_01:message_on_casualties("bat_3", 0.35);


-- ga_bat_01:reinforce_on_message("bat_1");
-- ga_bat_01:release_on_message("bat_1", 100);
-- ga_bat_02:reinforce_on_message("bat_2");
-- ga_bat_02:release_on_message("bat_2", 100);
-- ga_bat_03:reinforce_on_message("bat_3");
-- ga_bat_03:release_on_message("bat_3", 100);
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
battle_message();
gb:queue_help_on_message("unlock_second_ability", "wh2_dlc09_tmb_qb_final_battle_hint_khalida_ready",10000,1000);

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

