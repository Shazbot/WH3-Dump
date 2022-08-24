-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Valkia
-- The Spear Slaupnir
-- Cracked Lands
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);


--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/coc_qb_valkia.CindySceneManager";
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
ga_enemy_greenskins = gb:get_army(gb:get_non_player_alliance_num(), "enemy_greenskins");
ga_enemy_skaven = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven");
ga_enemy_skaven_artillery = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skaven_artillery");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------
--Valkia
ga_player.sunits:item(1).uc:teleport_to_location(v(115, 347), 180, 5);

end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("WH3_DLC20_QB_The_Spear_Slaupnir_Sweetener");	

wh3_main_sfx_01 = new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_03");
wh3_main_sfx_04 = new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_04");

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
		"script/battle/quest_battles/_cutscene/managers/coc_qb_valkia.CindySceneManager",			-- path to cindyscene
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
		"wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_01"));
				bm:show_subtitle("wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_02"));
				bm:show_subtitle("wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_03"));
				bm:show_subtitle("wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_04"));
				bm:show_subtitle("wh3_dlc20_qb_kor_valkia_spear_slaupnir_pt_04", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
end;


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Ally Armies
ga_ally_1:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_1:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_ally_2:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_2:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Enemy Armies
ga_enemy_greenskins:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_greenskins:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_skaven:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_skaven:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_skaven_artillery:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_skaven_artillery:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


--Defend Version
--Ally 1 vs Greenskins
ga_ally_1:attack_on_message("01_intro_cutscene_end", 1000);
ga_ally_1:message_on_rout_proportion("release_greenskins", 0.75);

ga_enemy_greenskins:defend_on_message("01_intro_cutscene_end", 250, 5, 200);
ga_enemy_greenskins:message_on_rout_proportion("release_greenskins", 0.75);
ga_enemy_greenskins:release_on_message("release_greenskins");

--Ally 2 vs Skaven
ga_ally_2:attack_on_message("01_intro_cutscene_end", 1000);
ga_ally_2:message_on_rout_proportion("release_skaven", 0.75);

ga_enemy_skaven:defend_on_message("01_intro_cutscene_end", -213, -8, 200);
ga_enemy_skaven:message_on_rout_proportion("release_skaven", 0.75);
ga_enemy_skaven:release_on_message("release_skaven");

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_start_battle", 7000, 2000, 0);

ga_enemy_greenskins:message_on_rout_proportion("enemy_greenskins_defeated", 1);
gb:block_message_on_message("all_enemy_skaven_defeated", "enemy_greenskins_defeated")
gb:queue_help_on_message("enemy_greenskins_defeated", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_greenskins_defeated");

ga_enemy_skaven:message_on_rout_proportion("enemy_skaven_defeated", 1);
ga_enemy_skaven_artillery:message_on_rout_proportion("enemy_skaven_artillery_defeated", 1);
gb:message_on_all_messages_received("all_enemy_skaven_defeated", "enemy_skaven_defeated", "enemy_skaven_artillery_defeated");
gb:block_message_on_message("enemy_greenskins_defeated", "all_enemy_skaven_defeated")
gb:queue_help_on_message("all_enemy_skaven_defeated", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_greenskins_defeated");

ga_ally_1:message_on_rout_proportion("ally_1_defeated", 1);
gb:block_message_on_message("enemy_greenskins_defeated", "ally_1_defeated")
gb:queue_help_on_message("ally_1_defeated", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_ally_1_defeated");

ga_ally_2:message_on_rout_proportion("ally_2_defeated", 1);
gb:queue_help_on_message("ally_2_defeated", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir_ally_2_defeated");

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_skaven:force_victory_on_message("player_defeated", 5000);

