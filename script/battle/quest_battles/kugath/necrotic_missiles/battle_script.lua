-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Ku'gath
-- Necrotic Missiles
-- The Underway
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/nmi.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);


-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_03");


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
		"script/battle/quest_battles/_cutscene/managers/nmi.CindySceneManager",			-- path to cindyscene
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
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	-- Slops-a-gravy, beggar's crumb. Finger-more and skip the thumb! I crave what a crave and that is Dwarfen-scum!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_nur_kugarth_the_fetid_underway_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_01"));
				bm:show_subtitle("wh3_main_qb_nur_kugarth_the_fetid_underway_01", false, true);
			end
	);

	-- I will have their hands and heads in my vice…  so best to infect them all with foetid beard-lice!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_nur_kugarth_the_fetid_underway_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_02"));
				bm:show_subtitle("wh3_main_qb_nur_kugarth_the_fetid_underway_02", false, true);
			end
	);

	-- [Sinister but weirdly warm laugh – like that uncle you don't like laughing at his own joke]
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_nur_kugarth_the_fetid_underway_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_nur_kugarth_the_fetid_underway_03"));
				bm:show_subtitle("wh3_main_qb_nur_kugarth_the_fetid_underway_03", false, true);
			end
	);

	cutscene_intro:set_music("NecroticMissiles_TheFetidUnderway", 0, 0)

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
ga_defender_reinforcements_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");
ga_defender_reinforcements_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2");
ga_defender_reinforcements_03 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_3");
ga_defender_reinforcements_04 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_4");

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_02");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_03");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_04");

-- assign reinforcement armies to spawn zones
ga_defender_reinforcements_01:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false);
ga_defender_reinforcements_02:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false);
ga_defender_reinforcements_03:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_3, false);
ga_defender_reinforcements_04:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_4, false);

-- Print slots
bm:print_toggle_slots()

--[[
--Player army setup
bm:register_phase_change_callback(
        "Deployment", 
        function()
            local v_top_left = v(-209, -201.90);
            local formation_width = 300;
 
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();
 
			uc:goto_location_angle_width(v_top_left, 270, formation_width);
			uc:change_group_formation("Multiple Selection Drag Out Land");

			--Ku'gath
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(-176.75, -201.90), 270, 7.40);



            uc:release_control();
        end
    );
]]--

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------

--Kugath
ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(-176.75, -201.90), 270, 7.40);


end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Enemy Main Army 
ga_defender_01:attack_on_message("01_intro_cutscene_end");
ga_defender_01:message_on_casualties("ambush_1_2", 0.2);
ga_defender_01:message_on_casualties("ambush_3_4", 0.4);

--Enemy Reinforcements 1
ga_defender_reinforcements_01:reinforce_on_message("ambush_1_2");
ga_defender_reinforcements_01:message_on_deployed("reinforcements_01_attack");
ga_defender_reinforcements_01:attack_on_message("reinforcements_01_attack");

--Enemy Reinforcements 2
ga_defender_reinforcements_02:reinforce_on_message("ambush_1_2");
ga_defender_reinforcements_02:message_on_deployed("reinforcements_02_attack")
ga_defender_reinforcements_02:attack_on_message("reinforcements_02_attack");

--Enemy Reinforcements 3
ga_defender_reinforcements_03:reinforce_on_message("ambush_3_4");
ga_defender_reinforcements_03:message_on_deployed("reinforcements_03_attack")
ga_defender_reinforcements_03:rush_on_message("reinforcements_03_attack");

--Enemy Reinforcements 4
ga_defender_reinforcements_04:reinforce_on_message("ambush_3_4");
ga_defender_reinforcements_04:message_on_deployed("reinforcements_04_attack")
ga_defender_reinforcements_04:rush_on_message("reinforcements_04_attack");


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--The corpses of these Dawi will prove excellent test subjects to enhance Father Nurgle's blessings! Kill them all!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_nur_kugath_necrotic_missiles_underway_hints_main_objective");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Defeat the Dwarf forces!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_nur_kugath_necrotic_missiles_underway_hints_main_hint", 10000, 2000, 5000, false);

-- Dwarfs arrive on your flanks, your grotesqueness.
gb:queue_help_on_message("reinforcements_01_attack", "wh3_main_qb_nur_kugath_necrotic_missiles_underway_hints_ambush_01");
ga_defender_reinforcements_01:add_ping_icon_on_message("reinforcements_01_attack", 15, 1, 10000);
ga_defender_reinforcements_02:add_ping_icon_on_message("reinforcements_02_attack", 15, 1, 10000);

--More Dwarfs join the fight!
gb:queue_help_on_message("reinforcements_03_attack", "wh3_main_qb_nur_kugath_necrotic_missiles_underway_hints_ambush_02");
ga_defender_reinforcements_03:add_ping_icon_on_message("reinforcements_03_attack", 15, 1, 10000);
ga_defender_reinforcements_04:add_ping_icon_on_message("reinforcements_04_attack", 15, 1, 10000);

--The Dawi Lord is defeated! He will receive the first test culture!
ga_defender_01:message_on_commander_dead_or_routing("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_nur_kugath_necrotic_missiles_underway_hints_lord_dead");


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

