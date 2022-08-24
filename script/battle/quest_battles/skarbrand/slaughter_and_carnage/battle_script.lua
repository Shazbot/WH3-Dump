-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Skarbrand
-- Slaughter & Carnage
-- The Brazen Altar
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      			-- screen starts black
	true,                                      			-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/sac.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_03");
wh3_main_sfx_04 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_04");
wh3_main_sfx_05 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_05");
wh3_main_sfx_06 = new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_06");

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
		ga_attacker_01.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/sac.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		2																				-- blend out time (s)
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
				ga_attacker_01:set_enabled(true)
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
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	
	-- Voiceover and Subtitles --
	
	-- I am the spine-crusher… the skull-taker… the blood-quencher
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_01"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_01", false, true);
			end
	)

	-- I am violence
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_02"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_02", false, true);
			end
	)

	-- I am WAR
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_03"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_03", false, true);
			end
	)

	-- I am WRATH
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_04"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_04", false, true);
			end
	)

	-- I am RAGE INCARNATE
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_05"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_05", false, true);
			end
	)

	-- I am Skarbrand, the UNFORGIVEN! 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_kho_skarbrand_the_brazen_altar_06", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_kho_skarbrand_the_brazen_altar_06"));
				bm:show_subtitle("wh3_main_qb_kho_skarbrand_the_brazen_altar_06", false, true);
			end
	)

	cutscene_intro:set_music("SlaughterandCarnage_BrazenAlter", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), "defender_2");
ga_reinforcements = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements");

--Player Army deployment position
bm:register_phase_change_callback(
        "Deployment", 
        function()
            local v_top_left = v(-60, 0);
            local formation_width = 400;
			
			--Player setup
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();

			uc:goto_location_angle_width(v_top_left, 90, formation_width);
			uc:change_group_formation("test_melee_forward_simple");
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(-130, 0), 90, 1.5);
            uc:release_control();

			--Defender 01 setup
			local sunits_defender_01 = bm:get_scriptunits_for_army(2, 1);
            local defender_01_uc = sunits_defender_01:get_unitcontroller();
			local defender_01_v_top_left = v(220, 200);
            local defender_01_formation_width = 200;

			defender_01_uc:goto_location_angle_width(defender_01_v_top_left, 270, defender_01_formation_width);
			defender_01_uc:change_group_formation("test_melee_forward_simple");
            
			--Defender 02 setup
			local sunits_defender_02 = bm:get_scriptunits_for_army(2, 2);
            local defender_02_uc = sunits_defender_02:get_unitcontroller();
			local defender_02_v_top_left = v(220, -200);
            local defender_02_formation_width = 200;

			defender_02_uc:goto_location_angle_width(defender_02_v_top_left, 270, defender_01_formation_width);
			defender_02_uc:change_group_formation("test_melee_forward_simple");

        end
    );


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping enemy from firing until the cutscene is done
ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("proximity", "fire_at_will", true, false);

--Stopping enemy from firing until the cutscene is done
ga_defender_02:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_02:change_behaviour_active_on_message("proximity", "fire_at_will", true, false);

--defender_01
--ga_defender_01:defend_on_message("01_intro_cutscene_end", 263, 176, 50, 0);
ga_defender_01:message_on_proximity_to_enemy("proximity", 150);
ga_defender_01:message_on_casualties("proximity", 0.05);   -- Backup triggers in case the player cheeses with long range arty
ga_defender_01:message_on_casualties("reinforce1", 0.75);
ga_defender_01:advance_on_message("proximity");
ga_defender_01:message_on_under_attack("attack_1");
ga_defender_01:attack_on_message("attack_1");

--defender_02
--ga_defender_02:defend_on_message("01_intro_cutscene_end", 263, -176, 50, 0);
ga_defender_02:message_on_proximity_to_enemy("proximity", 150);
ga_defender_02:message_on_casualties("proximity", 0.05);   -- Backup triggers in case the player cheeses with long range arty
ga_defender_02:message_on_casualties("reinforce2", 0.75);   -- Backup triggers in case the player cheeses with long range arty
ga_defender_02:advance_on_message("proximity");
ga_defender_02:message_on_under_attack("attack_2");
ga_defender_02:attack_on_message("attack_2");

gb:block_message_on_message("proximity", "proximity", true);

ga_reinforcements:reinforce_on_message("reinforce1");
ga_reinforcements:reinforce_on_message("reinforce2");

ga_reinforcements:attack_on_message("reinforce1", 15, 1, 10000);
ga_reinforcements:attack_on_message("reinforce2", 15, 1, 10000);


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Destroy the Khorne armies!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_main_objective");
gb:set_objective_on_message("reinforce1", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_main_objective_2");
gb:set_objective_on_message("reinforce2", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_main_objective_2");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
ga_defender_02:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
ga_reinforcements:add_ping_icon_on_message("reinforce1", 15, 1, 10000);
ga_reinforcements:add_ping_icon_on_message("reinforce2", 15, 1, 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--We can attack both armies at once or choose one to target first.
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_main_hint", 10000, 2000, 5000, false);

--Beware! Their forces have begun to move against us!
gb:queue_help_on_message("proximity", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_advance");

--The Nurgle Horde has finally arrived. More slaughter!
gb:queue_help_on_message("reinforce1", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_reinforcements");
gb:queue_help_on_message("reinforce2", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_reinforcements");
gb:block_message_on_message("reinforce1", "reinforce2", true);
gb:block_message_on_message("reinforce2", "reinforce1", true);

--One lord has fallen, slaughter the one that remains!
ga_defender_01:message_on_commander_dead_or_shattered("army_destroyed_1");
ga_defender_02:message_on_commander_dead_or_shattered("army_destroyed_2");
gb:queue_help_on_message("army_destroyed_1", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_lord_dead");
gb:queue_help_on_message("army_destroyed_2", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage_the_brazen_altar_hints_lord_dead");
gb:block_message_on_message("army_destroyed_1", "army_destroyed_2", true);
gb:block_message_on_message("army_destroyed_2", "army_destroyed_1", true);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

