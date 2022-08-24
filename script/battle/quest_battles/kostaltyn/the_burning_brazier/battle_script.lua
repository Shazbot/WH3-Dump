-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kostaltyn
-- The Burning Brazier
-- Shrine of Ursun
-- Defender

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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/bbr.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_02");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_defender_01.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/bbr.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		4																				-- blend out time (s)
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

			if player_units_hidden then
				ga_defender_01:set_enabled(true)
			end;
			
			cutscene_skipped_teleport_units();

			bm:callback(
				function()
					bm:stop_cindy_playback(true); 
					cam:fade(false, 0.3) 
				end, 
				200
			);
			
			
			bm:hide_subtitles();
			
			
		end
	);
	

	-- intro fade-in
	cutscene_intro:action(
		function() 
			cam:fade(false, 1) 
		end, 
		0
	);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	-- There! There the knife-eared devils come to take you from Ursun's grasp. To spirit you across the heathen waters where you will eke out your lives misery and toil in sin, far from Ursun's embrace! Is that what you want? IS IT?!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_01"));
				bm:show_subtitle("wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_01", false, true);
			end
	)

	-- Then show me your hatred! If you love the Bear you will happily die rather than be taken.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_02"));
				bm:show_subtitle("wh3_main_qb_ksl_kostaltyn_shrine_of_ursun_02", false, true);
			end
	)

	cutscene_intro:set_music("BurningBrazier_ShrineofUrsen", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	cam:fade(true, 0)
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(false, 0)
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_defender_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_attacker_west = gb:get_army(gb:get_non_player_alliance_num(), "west");
ga_attacker_centre = gb:get_army(gb:get_non_player_alliance_num(), "centre");
ga_attacker_east = gb:get_army(gb:get_non_player_alliance_num(), "east");
ga_reinforcements_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");
ga_reinforcements_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2");
ga_reinforcements_03 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_3");


--Player Army deployment position
bm:register_phase_change_callback(
        "Deployment", 
        function()
            local v_top_left = v(0, 175);
            local formation_width = 750;
			
			--Player setup
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();

			uc:goto_location_angle_width(v_top_left, 180, formation_width);
			uc:change_group_formation("Multiple Selection Drag Out Land");
			ga_defender_01.sunits:item(1).uc:teleport_to_location(v(-4.38, 209), 180, 1.4);
            uc:release_control();

        end
    );
-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
----------------------------------- Player Deployment Setup -------------------------------------

--Defend centre entrance --

--Kostaltyn
ga_defender_01.sunits:item(1).uc:teleport_to_location(v(-4.38, 209), 180, 1.4);


----------------------------------- Enemy Deployment Setup -------------------------------------

--Attack west entrance --

--Bleaksword
ga_attacker_west.sunits:item(1).uc:teleport_to_location(v(-370, -100), 0, 25);
--Dreadspears
ga_attacker_west.sunits:item(2).uc:teleport_to_location(v(-340, -100), 0, 25);
--Shades
ga_attacker_west.sunits:item(3).uc:teleport_to_location(v(-315, -125), 0, 25);
--Doomfire Warlocks
ga_attacker_west.sunits:item(4).uc:teleport_to_location(v(-305, -100), 0, 40);
--Reaper Bolt Thrower
ga_attacker_west.sunits:item(5).uc:teleport_to_location(v(-350, -125), 0, 25);


--Attack middle entrance --

--Dreadlord
ga_attacker_centre.sunits:item(1).uc:teleport_to_location(v(-5, -130), 0, 1.50);
--Dark Sorceress
ga_attacker_centre.sunits:item(2).uc:teleport_to_location(v(5, -130), 0, 1.40);
--Bleakswords
ga_attacker_centre.sunits:item(3).uc:teleport_to_location(v(-25, -95), 0, 40);
--Dreadspears
ga_attacker_centre.sunits:item(4).uc:teleport_to_location(v(25, -95), 0, 40);
--Darkshards
ga_attacker_centre.sunits:item(5).uc:teleport_to_location(v(0, -115), 0, 30);

--	Attack east entrance --

--Bleaksword
ga_attacker_east.sunits:item(1).uc:teleport_to_location(v(253, -95), 0, 25);
--Dreadspears
ga_attacker_east.sunits:item(2).uc:teleport_to_location(v(285, -95), 0, 25);
--Shades
ga_attacker_east.sunits:item(3).uc:teleport_to_location(v(300, -130), 0, 25);
--Doomfire Warlocks
ga_attacker_east.sunits:item(4).uc:teleport_to_location(v(323, -95), 0, 40);
--Reaper Bolt Thrower
ga_attacker_east.sunits:item(5).uc:teleport_to_location(v(290, -130), 0, 25);

end;


function cutscene_skipped_teleport_units()
	bm:out("\tcutscene_skipped_teleport_units() called");
	
----------------------------------- Enemy Deployment Setup -------------------------------------

--Attack west entrance --

--Bleaksword
ga_attacker_west.sunits:item(1).uc:teleport_to_location(v(-370, -50), 0, 25);
--Dreadspears
ga_attacker_west.sunits:item(2).uc:teleport_to_location(v(-340, -50), 0, 25);
--Shades
ga_attacker_west.sunits:item(3).uc:teleport_to_location(v(-315, -75), 0, 25);
--Doomfire Warlocks
ga_attacker_west.sunits:item(4).uc:teleport_to_location(v(-305, -50), 0, 40);
--Reaper Bolt Thrower
ga_attacker_west.sunits:item(5).uc:teleport_to_location(v(-350, -75), 0, 25);


--Attack middle entrance --

--Dreadlord
ga_attacker_centre.sunits:item(1).uc:teleport_to_location(v(-5, -80), 0, 1.50);
--Dark Sorceress
ga_attacker_centre.sunits:item(2).uc:teleport_to_location(v(5, -80), 0, 1.40);
--Bleakswords
ga_attacker_centre.sunits:item(3).uc:teleport_to_location(v(-25, -50), 0, 40);
--Dreadspears
ga_attacker_centre.sunits:item(4).uc:teleport_to_location(v(25, -50), 0, 40);
--Darkshards
ga_attacker_centre.sunits:item(5).uc:teleport_to_location(v(0, -65), 0, 30);

--	Attack east entrance --

--Bleaksword
ga_attacker_east.sunits:item(1).uc:teleport_to_location(v(215, -50), 0, 25);
--Dreadspears
ga_attacker_east.sunits:item(2).uc:teleport_to_location(v(240, -50), 0, 25);
--Shades
ga_attacker_east.sunits:item(3).uc:teleport_to_location(v(285, -75), 0, 25);
--Doomfire Warlocks
ga_attacker_east.sunits:item(4).uc:teleport_to_location(v(280, -50), 0, 40);
--Reaper Bolt Thrower
ga_attacker_east.sunits:item(5).uc:teleport_to_location(v(260, -75), 0, 25);

end;

battle_start_teleport_units();


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--vector
reinforcements_01_attack_position = battle_vector:new(0, 154, 166);

--Stopping player from firing until the cutscene is done
ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Stopping enemy from firing until the cutscene is done
ga_attacker_west:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_west:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, false);

ga_attacker_centre:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_centre:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, false);

ga_attacker_east:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_east:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, false);

--Moving enemy armies into position
ga_attacker_west:goto_location_offset_on_message("battle_started", 0, 50, false);
ga_attacker_centre:goto_location_offset_on_message("battle_started", 0, 50, false);
ga_attacker_east:goto_location_offset_on_message("battle_started", -15, 40, false);

--ga_attacker_west
ga_attacker_west:attack_on_message("01_intro_cutscene_end");
ga_attacker_west:message_on_casualties("reinforce_1", 0.1);
ga_attacker_west:message_on_casualties("reinforce_2", 0.5);

--ga_attacker_centre
ga_attacker_centre:attack_on_message("01_intro_cutscene_end");
ga_attacker_centre:message_on_casualties("reinforce_1", 0.1);
ga_attacker_centre:message_on_casualties("reinforce_2", 0.5);

--ga_attacker_east
ga_attacker_east:attack_on_message("01_intro_cutscene_end");
ga_attacker_east:message_on_casualties("reinforce_1", 0.1);
ga_attacker_east:message_on_casualties("reinforce_2", 0.5);

--ga_reinforcements_01 (Enemy Reinforcements - South)
ga_reinforcements_01:reinforce_on_message("reinforce_1", 30000); 
ga_reinforcements_01:message_on_deployed("reinforcements_deployed_01");
ga_reinforcements_01:move_to_position_on_message("reinforcements_deployed_01", reinforcements_01_attack_position);
ga_reinforcements_01:message_on_under_attack("under_attack_reinforcements_01");
ga_reinforcements_01:attack_on_message("under_attack_reinforcements_01");

--ga_reinforcements_02 (Enemy Reinforcements - West)
ga_reinforcements_02:reinforce_on_message("reinforce_2", 30000); 
ga_reinforcements_02:message_on_deployed("reinforcements_deployed_02");
ga_reinforcements_02:attack_on_message("reinforcements_deployed_02", 1000);

--ga_reinforcements_03 (Enemy Reinforcements - East)
ga_reinforcements_03:reinforce_on_message("reinforce_2", 30000);
ga_reinforcements_03:message_on_deployed("reinforcements_deployed_03");
ga_reinforcements_03:attack_on_message("reinforcements_deployed_03", 1000);

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Destroy the Dark Elves!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_kostaltyn_burning_brazier_shrine_of_ursun_hints_main_objective");
ga_attacker_centre:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Let's use the narrow entrances to this settlement to our advantage.
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_kostaltyn_burning_brazier_shrine_of_ursun_hints_main_hint", 10000, 2000, 5000, false);

--Powerful foes approach! We must prepare for their arrival.
gb:queue_help_on_message("reinforce_1", "wh3_main_qb_ksl_kostaltyn_burning_brazier_shrine_of_ursun_hints_reinforcements_1", 10000, 2000, 30000, false);

--The Dark Elves look to attack us from both sides at once.
gb:queue_help_on_message("reinforce_2", "wh3_main_qb_ksl_kostaltyn_burning_brazier_shrine_of_ursun_hints_reinforcements_2", 10000, 2000, 30000, false);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

