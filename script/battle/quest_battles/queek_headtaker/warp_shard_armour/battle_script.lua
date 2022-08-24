-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Queek Headtaker
-- Warp-shard Armour
-- Warp-shard Caverns
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/scenes/wsa_s01.CindyScene";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_03");


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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		33000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/scenes/wsa_s01.CindyScene", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_01", "subtitle_with_frame", 10) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_02", "subtitle_with_frame", 8) end, 15600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 26000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 26500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_03", "subtitle_with_frame", 5) end, 26600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 32500);
	


	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), "south_enemy");
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), "west_enemy");
ga_defender_04 = gb:get_army(gb:get_non_player_alliance_num(), "east_enemy");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh2_main_skv_cha_warlord_0") then
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"south_enemy");
	ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_enemy");
	ga_defender_04 = gb:get_army(gb:get_non_player_alliance_num(), 4,"east_enemy");
else
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_army");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"south_enemy");
	ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 4,"west_enemy");
	ga_defender_04 = gb:get_army(gb:get_non_player_alliance_num(), 2,"east_enemy");
end
]]

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:release_on_message("01_intro_cutscene_end");
ga_defender_02:release_on_message("01_intro_cutscene_end");
ga_defender_03:release_on_message("01_intro_cutscene_end");
ga_defender_04:release_on_message("01_intro_cutscene_end");
ga_defender_02:attack_on_message("01_intro_cutscene_end");

ga_defender_01:message_on_proximity_to_enemy("ambush", 150);
ga_defender_01:message_on_casualties("ambush", 0.05);   -- Backup triggers in case the player cheeses with long range arty

--ga_defender_01:release_on_message("ambush");
ga_defender_03:reinforce_on_message("ambush"); 
ga_defender_04:reinforce_on_message("ambush");
--ga_defender_01:attack_on_message("ambush");
ga_defender_03:attack_on_message("ambush"); 
ga_defender_04:attack_on_message("ambush");

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_hints_main_objective");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_hints_main_hint", 2000, nil, 7000);
gb:queue_help_on_message("ambush", "wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_hints_ambush");
gb:queue_help_on_message("lord_dead", "wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_hints_lord_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_defender_01:message_on_commander_dead_or_routing("lord_dead");
ga_attacker_01:force_victory_on_message("lord_dead")
