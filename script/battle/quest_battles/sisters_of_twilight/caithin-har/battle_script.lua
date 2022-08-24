-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Sisters of Twilight
-- Caithin-Har (Dragon Mount)
-- The Search for Caithin-Har
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\cethin.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_05");
wh2_main_sfx_06 = new_sfx("Play_wh2_dlc16_Sisters_Ceithin_Har_pt_06");


------------------------------------------------------------------------------------------------
---------------------------------------- COMPOSITE SCENE ----------------------------------------
-------------------------------------------------------------------------------------------------

dragon_prison = "composite_scene/wh2_dlc16_witchwood_prison_const.csc";
dragon_prison_end = "composite_scene/wh2_dlc16_witchwood_prison_end.csc";

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_sisters_army = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_ritual_beastmen_army = gb:get_army(gb:get_non_player_alliance_num(),"ritual_beastmen_army");
ga_enemy_beastmen_ambusher_army_right = gb:get_army(gb:get_non_player_alliance_num(),"beastmen_ambusher_army_right");
ga_enemy_beastmen_ambusher_army_left = gb:get_army(gb:get_non_player_alliance_num(),"beastmen_ambusher_army_left");
ga_enemy_skaven_opportunists = gb:get_army(gb:get_non_player_alliance_num(),"skaven_opportunists");


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
		ga_sisters_army.sunits,					-- unitcontroller over player's army
		69000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_sisters_army:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\cethin.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_sisters_army:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_01", "subtitle_with_frame", 2, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 6000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 6500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_02", "subtitle_with_frame", 15, true) end, 6500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_03", "subtitle_with_frame", 8, true) end, 22000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 31500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_04", "subtitle_with_frame", 17, true) end, 31500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 49000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 50000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_05", "subtitle_with_frame", 9, true) end, 50000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 61500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_06) end, 62000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Sisters_Ceithin_Har_pt_06", "subtitle_with_frame", 1, true) end, 62000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 65000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("right_flank_advance", "wh2_dlc16_qb_wef_sisters_of_twilight_caithin_har_hint_01", 6000, nil, 5000);
gb:queue_help_on_message("left_flank_advance", "wh2_dlc16_qb_wef_sisters_of_twilight_caithin_har_hint_02", 6000, nil, 5000);
gb:queue_help_on_message("skaven_opportunists_advance", "wh2_dlc16_qb_wef_sisters_of_twilight_caithin_har_hint_03", 6000, nil, 5000);
gb:set_objective_on_message("deployment_started", "wh2_dlc16_qb_wef_sisters_of_twilight_caithin_har_objective_01");
gb:set_objective_on_message("left_flank_repulsed", "wh2_dlc16_qb_wef_sisters_of_twilight_caithin_har_objective_02");

-- second objective for player to survive triggered when dragon free

-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_enemy_ritual_beastmen_army:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);		
ga_sisters_army:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_ritual_beastmen_army:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);		
ga_sisters_army:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_ritual_beastmen_army:release_on_message("right_flank_alerted");

ga_sisters_army:message_on_proximity_to_enemy("right_flank_alerted",55);
ga_sisters_army:message_on_proximity_to_enemy("left_flank_alerted",55);
ga_enemy_ritual_beastmen_army:release_on_message("right_flank_alerted");
ga_enemy_beastmen_ambusher_army_right:reinforce_on_message("right_flank_alerted",10000);
ga_enemy_beastmen_ambusher_army_right:message_on_any_deployed("right_flank_advance"); 
ga_enemy_beastmen_ambusher_army_right:attack_on_message("right_flank_advance");
ga_enemy_beastmen_ambusher_army_right:message_on_proximity_to_enemy("right_flank_engaged",50);
ga_enemy_beastmen_ambusher_army_right:release_on_message("right_flank_engaged");


ga_enemy_beastmen_ambusher_army_left:reinforce_on_message("left_flank_alerted",150000);
ga_enemy_beastmen_ambusher_army_left:message_on_any_deployed("left_flank_alerted"); 
ga_enemy_beastmen_ambusher_army_left:attack_on_message("left_flank_advance");
ga_enemy_beastmen_ambusher_army_left:message_on_proximity_to_enemy("left_flank_engaged",200);
ga_enemy_beastmen_ambusher_army_left:release_on_message("left_flank_engaged");

ga_enemy_beastmen_ambusher_army_left:message_on_proximity_to_enemy("skaven_opportunists_alerted", 160);
ga_enemy_skaven_opportunists:reinforce_on_message("skaven_opportunists_alerted",50000);
ga_enemy_skaven_opportunists:message_on_any_deployed("skaven_opportunists_advance"); 
ga_enemy_skaven_opportunists:attack_on_message("skaven_opportunists_advance");
ga_enemy_skaven_opportunists:message_on_proximity_to_enemy("skaven_opportunists_engaged",50);
ga_enemy_skaven_opportunists:release_on_message("skaven_opportunists_engaged");

ga_enemy_ritual_beastmen_army:message_on_casualties("ritual_disrupted", 0.7);
ga_enemy_ritual_beastmen_army:rout_over_time_on_message("ritual_disrupted", 15000)


ga_enemy_beastmen_ambusher_army_right:message_on_casualties("right_flank_repulsed", 0.7);
ga_enemy_beastmen_ambusher_army_right:rout_over_time_on_message("right_flank_repulsed", 15000)


ga_enemy_beastmen_ambusher_army_left:message_on_casualties("left_flank_repulsed", 0.7);
ga_enemy_beastmen_ambusher_army_left:rout_over_time_on_message("left_flank_repulsed", 15000)


ga_enemy_skaven_opportunists:message_on_casualties("skaven_repulsed", 0.7);
ga_enemy_skaven_opportunists:rout_over_time_on_message("skaven_repulsed", 10000)


gb:start_terrain_composite_scene_on_message("battle_started", dragon_prison, 100);
gb:stop_terrain_composite_scene_on_message("skaven_opportunists_advance", dragon_prison, 100);		-- set string to match objective complete string

gb:start_terrain_composite_scene_on_message("skaven_opportunists_advance", dragon_prison_end, 100);
gb:stop_terrain_composite_scene_on_message("skaven_opportunists_advance", dragon_prison_end, 3000);
-------MISC-------
local sm = get_messager();

-------ARMY ABILITY-------
local army_abilities = "wh2_dlc16_army_abilities_call_to_ceithin_har";

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
	"skaven_opportunists_advance",
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