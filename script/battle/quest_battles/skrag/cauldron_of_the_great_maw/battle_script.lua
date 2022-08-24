-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Skrag the Slaughterer
-- Cauldron of the Great Maw
-- Caverns of Mourn
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

bm:disable_all_abilities();

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/cgm.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_03");
wh3_main_sfx_04 = new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_04");

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
		"script/battle/quest_battles/_cutscene/managers/cgm.CindySceneManager",			-- path to cindyscene
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
	
	-- ERE RATTY-RATTIES! 'ERE RATTY-RATTIES!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_01"));
				bm:show_subtitle("wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_01", false, true);
			end
	);

	-- Come and have a sniff of dis cheese. It’s all 'ere, in ma pot. Just scamper over and jump in!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_02"));
				bm:show_subtitle("wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_02", false, true);
			end
	);

	-- Oh Maw... they hang back... It's, it's a rat-trap! I ain't trapped in 'ere with them…
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_03"));
				bm:show_subtitle("wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_03", false, true);
			end
	);

	-- THEY'RE TRAPPED 'ERE WITH ME!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_04"));
				bm:show_subtitle("wh3_main_qb_ogr_skrag_ice_caverns_of_ymirdrak_04", false, true);
			end
	);

	cutscene_intro:set_music("CauldronoftheGreatMaw_IceCavernsofYmirdrak", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
	
	bm:enable_all_abilities();
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_defender_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_1"); --War Cannons and Tough Infantry
ga_attacker_02_visible = gb:get_army(gb:get_non_player_alliance_num(), "visible"); --Grey Seer (needs to be visible at the start)
ga_attacker_02_bait = gb:get_army(gb:get_non_player_alliance_num(), "bait"); -- Plagueclaws (bait)
ga_attacker_03_stalk = gb:get_army(gb:get_non_player_alliance_num(), "stalk"); --force has stalk


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------

--Skrag
ga_defender_01.sunits:item(1).uc:teleport_to_location(v(-136, 192), 270, 2.79);


----------------------------------- Player Deployment Setup ------------------------------------

--Grey Seer (Ruin)
ga_attacker_02_visible.sunits:item(1).uc:teleport_to_location(v(328, 152), 270, 1.4);

--Plagueclaw Catapult
ga_attacker_02_bait.sunits:item(1).uc:teleport_to_location(v(302, 152), 270, 33);

end;

battle_start_teleport_units();	


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--ga_attacker_01
ga_attacker_01:advance_on_message("01_intro_cutscene_end");
ga_attacker_01:message_on_under_attack("attack");
ga_attacker_01:attack_on_message("attack");


--ga_attacker_02_visible
--Make Grey Seer visible for objective ping then hide afterwards
--ga_attacker_02_visible:set_always_visible_on_message("01_intro_cutscene_end", true);
--gb:message_on_time_offset("hide_grey_seer", 3000, "01_intro_cutscene_end");
--ga_attacker_02_visible:set_always_visible_on_message("hide_grey_seer", false);
ga_attacker_02_visible:set_always_visible_on_message("battle_started", true);
ga_attacker_02_visible:set_always_visible_on_message("01_intro_cutscene_end", false);
ga_attacker_02_visible:advance_on_message("01_intro_cutscene_end");
ga_attacker_02_visible:message_on_under_attack("attack");
ga_attacker_02_visible:advance_on_message("attack");

--ga_attacker_02_bait
ga_attacker_02_bait:advance_on_message("01_intro_cutscene_end");
ga_attacker_02_bait:message_on_under_attack("attack");
ga_attacker_02_bait:advance_on_message("attack");

--ga_attacker_03_stalk
ga_attacker_03_stalk:advance_on_message("01_intro_cutscene_end");
ga_attacker_03_stalk:message_on_seen_by_enemy("ambush");
ga_attacker_03_stalk:advance_on_message("ambush");

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Kill or rout Qrelk the Lethal
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_main_objective_1");
ga_attacker_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
gb:remove_objective_on_message("lord_dead_1", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_main_objective_1");

--Kill or rout Transiform of Mordheim
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_main_objective_2");
ga_attacker_02_visible:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
gb:remove_objective_on_message("lord_dead_2", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_main_objective_2");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Form up and advance! Grind them to tasty meat paste!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_main_hint", 10000, 2000, 5000, false);

--Those sneaky rats have sprung a trap!
gb:queue_help_on_message("ambush", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_ambush", 10000, 2000, 3000, false);
ga_attacker_03_stalk:add_ping_icon_on_message("ambush", 8, 1, 10000);

--Meat for the Cauldron! Meat for the Great Maw!
ga_attacker_01:message_on_commander_dead_or_shattered("lord_dead_1");
ga_attacker_02_visible:message_on_commander_dead_or_shattered("lord_dead_2");
gb:queue_help_on_message("lord_dead_1", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_lord_dead");
gb:queue_help_on_message("lord_dead_2", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw_caverns_of_mourn_hints_lord_dead");
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_all_messages_received("lords_dead", "lord_dead_1", "lord_dead_2");
ga_defender_01:force_victory_on_message("lords_dead");
