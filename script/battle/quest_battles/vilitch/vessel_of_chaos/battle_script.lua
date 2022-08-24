-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Vilitch
-- Vessel of Chaos
-- Fiels of Eternity
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                  	    	-- screen starts black
	true,                                 	     	-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);


--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/chs_vilitch.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");

--Ally Armies
ga_ally_1 = gb:get_army(gb:get_player_alliance_num(), "ally_1");
ga_ally_2 = gb:get_army(gb:get_player_alliance_num(), "ally_2");

--Enemy Armies
ga_enemy_empire = gb:get_army(gb:get_non_player_alliance_num(), "enemy_empire");
ga_enemy_cathay = gb:get_army(gb:get_non_player_alliance_num(), "enemy_cathay");
ga_enemy_cathay_artillery = gb:get_army(gb:get_non_player_alliance_num(), "enemy_cathay_artillery");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------
--Vilitch
ga_player.sunits:item(1).uc:teleport_to_location(v(150, -152), 180, 5);

end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("WH3_DLC20_QB_Vessel_Of_Chaos_Sweetener");	

wh3_main_sfx_01 = new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_03");
wh3_main_sfx_04 = new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_04");
wh3_main_sfx_05 = new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_05");

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
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/chs_vilitch.CindySceneManager",			-- path to cindyscene
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
		"wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_01"));
				bm:show_subtitle("wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_02"));
				bm:show_subtitle("wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_03"));
				bm:show_subtitle("wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_04"));
				bm:show_subtitle("wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_05"));
				bm:show_subtitle("wh3_dlc20_qb_tze_vilitch_vessel_of_chaos_05", false, true);
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
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Ally Armies
ga_ally_1:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_1:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_ally_2:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_2:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--enemy Armies
ga_enemy_empire:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_empire:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_cathay:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_cathay:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_cathay_artillery:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_cathay_artillery:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Portal Reinforcement Set Up
cathay_portal = bm:get_spawn_zone_collection_by_name("cathay_portal");
ally_1_portal = bm:get_spawn_zone_collection_by_name("ally_1_portal");
ally_2_portal = bm:get_spawn_zone_collection_by_name("ally_2_portal");

ga_enemy_cathay:assign_to_spawn_zone_from_collection_on_message("battle_started", cathay_portal, false);
ga_enemy_cathay_artillery:assign_to_spawn_zone_from_collection_on_message("battle_started", cathay_portal, false);
ga_ally_1:assign_to_spawn_zone_from_collection_on_message("battle_started", ally_1_portal, false);
ga_ally_2:assign_to_spawn_zone_from_collection_on_message("battle_started", ally_2_portal, false);

--Reinforce Timing
ga_enemy_cathay:reinforce_on_message("01_intro_cutscene_end", 170000);
ga_enemy_cathay:message_on_deployed("reinforce_cathay");

ga_enemy_cathay_artillery:reinforce_on_message("01_intro_cutscene_end", 200000);
ga_enemy_cathay_artillery:message_on_deployed("reinforce_cathay_artillery");

ga_ally_1:reinforce_on_message("01_intro_cutscene_end", 360000);
ga_ally_1:message_on_deployed("release_ally_1");
ga_ally_1:release_on_message("release_ally_1");

ga_ally_2:reinforce_on_message("01_intro_cutscene_end", 370000);
ga_ally_2:message_on_deployed("release_ally_2");
ga_ally_2:release_on_message("release_ally_2");

--Enemy Empire Orders
ga_enemy_empire:attack_force_on_message("01_intro_cutscene_end", ga_player, 1000);
ga_enemy_empire:message_on_rout_proportion("enemy_empire_release", 0.75);
ga_enemy_empire:release_on_message("enemy_empire_release");

--Enemy Cathay Orders
ga_enemy_cathay:attack_force_on_message("reinforce_cathay", ga_player, 1000);
ga_enemy_cathay:message_on_rout_proportion("enemy_cathay_release", 0.75);
ga_enemy_cathay:release_on_message("enemy_cathay_release");

ga_enemy_cathay_artillery:release_on_message("reinforce_cathay_artillery");

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_main_objective");
ga_enemy_empire:message_on_rout_proportion("enemy_empire_defeated", 1);
gb:complete_objective_on_message("enemy_empire_defeated", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_main_objective", 500)

gb:set_objective_on_message("reinforce_cathay", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_main_objective_2");
ga_enemy_cathay:message_on_rout_proportion("enemy_cathay_defeated", 1);
ga_enemy_cathay_artillery:message_on_rout_proportion("enemy_cathay_artillery_defeated", 1);
gb:message_on_all_messages_received("all_enemy_cathay_defeated", "enemy_cathay_defeated", "enemy_cathay_artillery_defeated");
gb:complete_objective_on_message("all_enemy_cathay_defeated", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_main_objective_2", 500)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_start_battle", 7000, 2000, 0);
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_enemy_reinforcements", 7000, 2000, 150000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos_ally_reinforcements", 7000, 2000, 330000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_empire:force_victory_on_message("player_defeated", 5000);

