-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Greasus
-- Overtyrant's Crown
-- Fire Mouth Volcano
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

gb:set_cutscene_during_deployment(true)
 
--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/otc.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_03");

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
		ga_defender_01.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/otc.CindySceneManager",			-- path to cindyscene
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
				ga_defender_01:set_enabled(true)
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
	
	-- My crown ain't as shiny as it used to be. 'at's your fault! You let this Orc rampage though my lands without giving 'im any bother! That stops now! This battle's goin' to be huuge, that ain't no lie! And no one lies betta dan me!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_greasus_the_fire_mouth_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_01"));
				bm:show_subtitle("wh3_main_qb_ogr_greasus_the_fire_mouth_01", false, true);
			end
	);

	-- I brought this git here, now we goin' to swallow him whole, chew on his eyeballs and throw his nads into the Fire Mouth!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_greasus_the_fire_mouth_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_02"));
				bm:show_subtitle("wh3_main_qb_ogr_greasus_the_fire_mouth_02", false, true);
			end
	);

	-- Right! Let's get to it!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_greasus_the_fire_mouth_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_greasus_the_fire_mouth_03"));
				bm:show_subtitle("wh3_main_qb_ogr_greasus_the_fire_mouth_03", false, true);
			end
	);

	cutscene_intro:set_music("OvertyrantsCrown_TheFireMouth", 0, 0)

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
ga_defender_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_attacker_visible = gb:get_army(gb:get_non_player_alliance_num(), "visible");
ga_attacker_hidden = gb:get_army(gb:get_non_player_alliance_num(), "hidden");
ga_reinforcements_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");
ga_reinforcements_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2");

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("attacker_reinforcements_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("attacker_reinforcements_02");

-- assign reinforcement armies to spawn zones
ga_reinforcements_01:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false);
ga_reinforcements_02:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false);

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------

--Greasus
ga_defender_01.sunits:item(1).uc:teleport_to_location(v(-103, 214), 135.21, 1.4);

----------------------------------- Enemy Deployment Setup -------------------------------------

--Visible
--Goblin Great Shaman
ga_attacker_visible.sunits:item(1).uc:teleport_to_location(v(147.68, -132.70), 324.29, 1.2);
--Goblin Spearmen
ga_attacker_visible.sunits:item(2).uc:teleport_to_location(v(124.29, -107.02), 324.29, 29.50);
--Goblin Spearmen
ga_attacker_visible.sunits:item(3).uc:teleport_to_location(v(137.58, -118.65), 324.29, 29.50);
--Goblin Spearmen
ga_attacker_visible.sunits:item(4).uc:teleport_to_location(v(156.36, -83.96), 324.29, 29.50);
--Goblin Spearmen
ga_attacker_visible.sunits:item(5).uc:teleport_to_location(v(98.72, -125.41), 324.29, 29.50);
--Goblin Archers
ga_attacker_visible.sunits:item(6).uc:teleport_to_location(v(198.48, -74.87), 324.29, 35.50);
--Goblin Archers
ga_attacker_visible.sunits:item(7).uc:teleport_to_location(v(107.14, -140.54), 324.29, 35.50);
--Goblin Archers
ga_attacker_visible.sunits:item(8).uc:teleport_to_location(v(168.03, -96.76), 324.29, 35.50);
--Goblin Archers
ga_attacker_visible.sunits:item(9).uc:teleport_to_location(v(76.69, -162.43), 324.29, 35.50);


--Hidden
--Nasty Skulkers
ga_attacker_hidden.sunits:item(1).uc:teleport_to_location(v(191.55, -101.03), 324.29, 34);
--Nasty Skulkers
ga_attacker_hidden.sunits:item(2).uc:teleport_to_location(v(129.27, -145.81), 324.29, 34);
--Night Goblins
ga_attacker_hidden.sunits:item(3).uc:teleport_to_location(v(164.15, -120.74), 324.29, 29.50);
--Night Goblins
ga_attacker_hidden.sunits:item(4).uc:teleport_to_location(v(101.87, -165.51), 324.29, 29.50);
--Night Goblin Archers
ga_attacker_hidden.sunits:item(5).uc:teleport_to_location(v(178.28, -46.78), 324.29, 35.50);
--Night Goblin Archers
ga_attacker_hidden.sunits:item(6).uc:teleport_to_location(v(147.836, -68.67), 324.29, 35.50);
--Night Goblin Archers
ga_attacker_hidden.sunits:item(7).uc:teleport_to_location(v(117.38, -90.56), 324.29, 35.50);
--Night Goblin Fanatics
ga_attacker_hidden.sunits:item(8).uc:teleport_to_location(v(86.94, -112.45), 324.29, 35.50);
--Night Goblin Fanatics
ga_attacker_hidden.sunits:item(9).uc:teleport_to_location(v(56.49, -134.34), 324.29, 35.50);


end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("start", 100);

--Make enemy visible during cutscene
ga_attacker_visible:set_always_visible_on_message("battle_started", true);
ga_attacker_visible:set_always_visible_on_message("01_intro_cutscene_end", false);

--Enemy Main Army - visible
ga_attacker_visible:halt();
ga_attacker_visible:attack_on_message("start");
ga_attacker_visible:message_on_casualties("reinforce_1", 0.1);

--Enemy Main Army - hidden
ga_attacker_hidden:halt();
ga_attacker_hidden:attack_on_message("start");
ga_attacker_hidden:message_on_casualties("reinforce_1", 0.1);

--Enemy Reinforcements (North West - Large Force)
ga_reinforcements_01:reinforce_on_message("reinforce_1");
ga_reinforcements_01:message_on_deployed("reinforcements_deployed_1");
ga_reinforcements_01:attack_force_on_message("reinforcements_deployed_1", ga_defender_01);
ga_reinforcements_01:message_on_casualties("reinforce_2", 0.2);

--Enemy Reinforcements (North - Small Force)
ga_reinforcements_02:reinforce_on_message("reinforce_2");
ga_reinforcements_02:message_on_deployed("reinforcements_deployed_3");
ga_reinforcements_02:attack_on_message("reinforcements_deployed_3");

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
 --Defeat the Orc forces!
gb:set_objective_on_message("start", "wh3_main_qb_ogr_greasus_overtyrants_crown_Fire_mouth_volcano_hints_main_objective");
ga_attacker_visible:add_ping_icon_on_message("start", 15, 1, 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--While we hold the high ground, we have the advantage!
gb:queue_help_on_message("start", "wh3_main_qb_ogr_greasus_overtyrants_crown_Fire_mouth_volcano_hints_main_hint", 10000, 2000, 5000, false);

--An attack from behind! We must now fight on two fronts.
gb:queue_help_on_message("reinforce_1", "wh3_main_qb_ogr_greasus_overtyrants_crown_Fire_mouth_volcano_hints_reinforcements_1", 10000, 2000, 5000, false);

--More Orcs dare to challenge us. Destroy them like all the rest.
gb:queue_help_on_message("reinforce_2", "wh3_main_qb_ogr_greasus_overtyrants_crown_Fire_mouth_volcano_hints_reinforcements_2", 10000, 2000, 5000, false);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

