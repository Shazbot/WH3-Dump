-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- N'kari
-- Sword
-- The Sea of Dreams
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wss.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_01");
wh3_main_sfx_02 = new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_02");
wh3_main_sfx_03 = new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_03");

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
		"script/battle/quest_battles/_cutscene/managers/wss.CindySceneManager",			-- path to cindyscene
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
				ga_attacker_01:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			ga_attacker_01.sunits:change_behaviour_active("fire_at_will", false);
			ga_defender_01.sunits:change_behaviour_active("fire_at_will", false);
			ga_defender_01:halt();
		end, 
		50
	);	

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01.sunits:change_behaviour_active("fire_at_will", false);
		end, 
		50
	);	
	
	-- Voiceover and Subtitles --
	
	-- You are in my way, Asur. Move aside and I may grant you a gift rarely bequeathed on my other playthings… a quick and mildly-painful death.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_sla_nkari_the_sea_of_dreams_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_01"));
				bm:show_subtitle("wh3_main_qb_sla_nkari_the_sea_of_dreams_01", false, true);
			end
	);

	-- But vex me and the agonies I shall visit upon you and your descendants will be as legend – sung in the halls of the Marcher Fortress for eternity!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_sla_nkari_the_sea_of_dreams_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_02"));
				bm:show_subtitle("wh3_main_qb_sla_nkari_the_sea_of_dreams_02", false, true);
			end
	);

	-- Bring them to me, my fiends – the feast begins!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_sla_nkari_the_sea_of_dreams_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_sla_nkari_the_sea_of_dreams_03"));
				bm:show_subtitle("wh3_main_qb_sla_nkari_the_sea_of_dreams_03", false, true);
			end
	);

	cutscene_intro:set_music("WitstealerSword_SeaofDreams", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	-- ga_defender_01.sunits:change_behaviour_active("fire_at_will", true);
	ga_defender_01:release();
	cam:fade(true, 0);
	cam:fade(false, 0);
	--ga_attacker_01.sunits:release_control();
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num());
--Enemy Army
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------

--N'Kari
ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(6.98, -202.56), 352.94, 4.40);

end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping units from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Defeat the High Elves!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_sla_nkari_daemon_blade_sea_of_Dreams_hints_main_objective");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Find their weak point and exploit it!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_sla_nkari_daemon_blade_sea_of_Dreams_hints_main_hint", 10000, 2000, 5000, false);

--The sword is almost within my grasp!
ga_defender_01:message_on_commander_dead_or_routing("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_sla_nkari_daemon_blade_sea_of_Dreams_hints_lord_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

