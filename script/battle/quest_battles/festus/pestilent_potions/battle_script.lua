-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Festus
-- Pestilent Potions
-- Vomit Fields
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                              	        	-- screen starts black
	true,                             	         	-- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_chs_qb_festus.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
--Enemy Armies
ga_beastmen_main = gb:get_army(gb:get_non_player_alliance_num(), "enemy_main");
ga_beastmen_cygors_defenders = gb:get_army(gb:get_non_player_alliance_num(), "enemy_cygors_defenders");
ga_beastmen_cygors = gb:get_army(gb:get_non_player_alliance_num(), "enemy_cygors");
ga_beastmen_flank = gb:get_army(gb:get_non_player_alliance_num(), "enemy_flank");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------
--Festus
ga_player.sunits:item(1).uc:teleport_to_location(v(257, 63), 225, 5);

----------------------------------- Enemy Deployment Setup -------------------------------------
--Cygors
ga_beastmen_cygors.sunits:item(1).uc:teleport_to_location(v(-109, -233), 45, 5);
ga_beastmen_cygors.sunits:item(2).uc:teleport_to_location(v(-90, -258), 45, 5);

--Cygors Defenders
ga_beastmen_cygors_defenders.sunits:item(1).uc:teleport_to_location(v(-95, -237), 45, 5);
ga_beastmen_cygors_defenders.sunits:item(2).uc:teleport_to_location(v(-116, -194), 45, 40);
ga_beastmen_cygors_defenders.sunits:item(3).uc:teleport_to_location(v(-66, -247), 45, 40);
ga_beastmen_cygors_defenders.sunits:item(4).uc:teleport_to_location(v(-70, -315), -10, 40);

--Flanking Force 
ga_beastmen_flank.sunits:item(1).uc:teleport_to_location(v(150, -315), 45, 30);
ga_beastmen_flank.sunits:item(2).uc:teleport_to_location(v(145, -317), 45, 45);

end;

battle_start_teleport_units();	

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("WH3_DLC20_QB_Pestilent_Potions_Sweetener");

wh3_main_sfx_01 = new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_03");
wh3_main_sfx_04 = new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_04");
wh3_main_sfx_05 = new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_chs_qb_festus.CindySceneManager",			-- path to cindyscene
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
				ga_player:set_enabled(false)
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
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_nur_festus_pestilent_potions_pt_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_01"));
				bm:show_subtitle("wh3_dlc20_qb_nur_festus_pestilent_potions_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_nur_festus_pestilent_potions_pt_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_02"));
				bm:show_subtitle("wh3_dlc20_qb_nur_festus_pestilent_potions_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_nur_festus_pestilent_potions_pt_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_03"));
				bm:show_subtitle("wh3_dlc20_qb_nur_festus_pestilent_potions_pt_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_nur_festus_pestilent_potions_pt_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_04"));
				bm:show_subtitle("wh3_dlc20_qb_nur_festus_pestilent_potions_pt_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_nur_festus_pestilent_potions_pt_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_nur_festus_pestilent_potions_pt_05"));
				bm:show_subtitle("wh3_dlc20_qb_nur_festus_pestilent_potions_pt_05", false, true);
			end
	);
	

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
	--ga_attacker_01.sunits:release_control();
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping enemy from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:set_invincible_on_message("battle_started",true);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_player:set_invincible_on_message("01_intro_cutscene_end",false);

ga_beastmen_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_beastmen_main:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_beastmen_cygors_defenders:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_beastmen_cygors_defenders:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_beastmen_cygors:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_beastmen_cygors:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_beastmen_flank:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_beastmen_flank:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


--Defend Cygors
ga_beastmen_cygors_defenders:defend_on_message("01_intro_cutscene_end", -100, -245, 45);
ga_beastmen_cygors:message_on_under_attack("ga_beastmen_cygors_defenders_release");
ga_beastmen_cygors_defenders:message_on_under_attack("ga_beastmen_cygors_defenders_release");
ga_beastmen_cygors_defenders:release_on_message("ga_beastmen_cygors_defenders_release");

--Main Force
ga_beastmen_main:rush_on_message("01_intro_cutscene_end", 1000);
ga_beastmen_main:message_on_rout_proportion("ga_beastmen_main_release", 0.75);
ga_beastmen_main:release_on_message("ga_beastmen_main_release");


--Flanking Force
ga_beastmen_flank:rush_on_message("01_intro_cutscene_end", 1000);
ga_beastmen_flank:message_on_rout_proportion("ga_beastmen_flank_release", 0.5);
ga_beastmen_flank:release_on_message("ga_beastmen_flank_release");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_festus_pestilent_potions_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_festus_pestilent_potions_start_battle", 7000, 2000, 0);
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_festus_pestilent_potions_cygors", 7000, 2000, 30000);
