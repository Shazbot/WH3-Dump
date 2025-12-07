-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kairos
-- The Staff of Tomorrow
-- Floating Chaos Island
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/sot_kairos.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_03");
wh3_main_sfx_04 = new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_04");

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
		"script/battle/quest_battles/_cutscene/managers/sot_kairos.CindySceneManager",			-- path to cindyscene
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
	
	-- ERE RATTY-RATTIES! 'ERE RATTY-RATTIES!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_tze_kairos_ilses_of_time_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_01"));
				bm:show_subtitle("wh3_main_qb_tze_kairos_ilses_of_time_01", false, true);
			end
	);

	-- Come and have a sniff of dis cheese. It’s all 'ere, in ma pot. Just scamper over and jump in!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_tze_kairos_ilses_of_time_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_02"));
				bm:show_subtitle("wh3_main_qb_tze_kairos_ilses_of_time_02", false, true);
			end
	);

	-- Oh Maw... they hang back... It's, it's a rat-trap! I ain't trapped in 'ere with them…
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_tze_kairos_ilses_of_time_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_03"));
				bm:show_subtitle("wh3_main_qb_tze_kairos_ilses_of_time_03", false, true);
			end
	);

	-- THEY'RE TRAPPED 'ERE WITH ME!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_tze_kairos_ilses_of_time_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_tze_kairos_ilses_of_time_04"));
				bm:show_subtitle("wh3_main_qb_tze_kairos_ilses_of_time_04", false, true);
			end
	);

	cutscene_intro:set_music("StaffofTomorrow_IslesofTime", 0, 0)

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
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1"); --Kairos (Past)
ga_reinforcements_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1"); --Kairos (future)

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_01");

-- assign reinforcement armies to spawn zones
ga_reinforcements_01:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false);

-- Print slots
bm:print_toggle_slots()


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------

--Kugath
--ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(-35.95, -252.75), 0, 3.20);


end;

battle_start_teleport_units();	


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_defender_01:halt();

--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_defender_01:defend_on_message("battle_started", 25.5, 112.8892364502, 621.5)
ga_defender_01:rush_on_message("01_intro_cutscene_end", 500)

--defender_01
ga_defender_01:message_on_commander_dead_or_shattered("kairos_past_dead"); 
ga_defender_01:message_on_commander_dead_or_shattered("reinforce"); 
--ga_defender_01:message_on_shattered_proportion("reinforce", 0.5); 
ga_defender_01:message_on_shattered_proportion("defender_01_defeated", 1); 

--reinforcements_01
ga_reinforcements_01:reinforce_on_message("reinforce"); 
ga_reinforcements_01:message_on_deployed("attack");
ga_reinforcements_01:rush_on_message("attack");
ga_reinforcements_01:message_on_commander_dead_or_shattered("kairos_future_dead");


-------------------------------------------Message Blocking -------------------------------------
-------------------------------------------------------------------------------------------------
gb:block_message_on_message("01_intro_cutscene_end", "kairos_future_dead", true);
gb:block_message_on_message("attack", "kairos_future_dead", false);


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Defeat your past self and their Daemonic host!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_main_objective_1", 5000);
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 5000);
gb:complete_objective_on_message("defender_01_defeated", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_main_objective_1", 5000);

--Defeat your future self and their Daemonic host!
gb:set_objective_on_message("attack", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_main_objective_2", 5000);
ga_reinforcements_01:add_ping_icon_on_message("attack", 15, 1, 5000);


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stir the Well of Eternity! Destroy your past self!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_main_hint", 10000, 2000, 5000, false);

--The future approaches, and with it your future self!
gb:queue_help_on_message("attack", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_ambush", 6000, nil, 5000);

--You have defeated your past self!
gb:queue_help_on_message("kairos_past_dead", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_lord_1_dead", 5000);

--With past and future defeated, time's wheel follows a new track. All hail the Changer of Ways!
gb:queue_help_on_message("kairos_future_dead", "wh3_main_qb_tze_kairos_staff_of_tomorrow_floating_chaos_island_hints_lord_2_dead", 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

