 -------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Boris Todbringer
-- Spilled Blood
-- Caverns of the Great Bat
-- Defending

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
cam = bm:camera();

local sm = get_messager();

gb = generated_battle:new(
	false,                                     		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);


gb:set_cutscene_during_deployment(true)

--preload stuttering fix
--intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_emp_boris_qb_intro_m01.CindySceneManager";
--bm:cindy_preload(intro_cinematic_file);



-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

boris = ga_defender_01.sunits:item(1);
boris_mount = boris.unit:type();
--boris_vector = boris.unit.position();



ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "cultist_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), "khorne_reinforcement");
ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), "wef_reinforcement");


cultist_lord_01 = ga_attacker_01.sunits:item(1);
cultist_hero_01 = ga_attacker_01.sunits:item(2);
cultist_hero_02 = ga_attacker_01.sunits:item(3);

reinforcements_spawned = false;



-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------



function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();

	if boris_mount == "wh_dlc03_emp_cha_boris_todbringer_1" then
	cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_defender_01.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_emp_boris_qb_intro_m01.CindySceneManager",	 	-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	); 
		print(boris_mount);
		print(cutscene_intro);
	else 
	cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_defender_01.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_emp_boris_qb_intro_m02.CindySceneManager",	 	-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	);
		print(boris_mount);
		print(cutscene_intro);
	end
	

	

	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC29_QB_Boris_Intro", true, false)) end, 100);
	
	
	ga_attacker_01:set_visible_to_all(true);
	
	ga_defender_01.sunits:get_general_sunit():set_invisible_to_all(true);

	cultist_lord_01:set_invisible_to_all(true);
		cultist_hero_01_1 = cultist_lord_01.unit:type();
		print(cultist_hero_01_1);

	cultist_hero_01:set_invisible_to_all(true)
		cultist_hero_01_01 = cultist_hero_01.unit:type();
		print(cultist_hero_01_01);

	cultist_hero_02:set_invisible_to_all(true);
		cultist_hero_02_1 = cultist_hero_02.unit:type();
		print(cultist_hero_02_1);






	-- Voiceover and Subtitles --
		--cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro) end, 0);
		
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_qb_01", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_qb_01"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_spilled_blood_intro_01", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_qb_02", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_qb_02"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_spilled_blood_intro_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_qb_03", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_qb_03"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_spilled_blood_intro_03", false, true)
				end
		)
	cutscene_intro:set_post_cutscene_fade_time(0.5)	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_QB_Boris_Intro", false, false))
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_defender_01.sunits:get_general_sunit():set_invisible_to_all(false);
	bm:hide_subtitles()
	cultist_lord_01:set_invisible_to_all(false);
	cultist_hero_01:set_invisible_to_all(false);
	cultist_hero_02:set_invisible_to_all(false);
	camera_target=v(-37.6, 438.4, 82.4);
	camera_position=v(-14, 560, 326);
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
	)
end;


-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local mid_game_vo_01 = new_sfx("Play_wh3_dlc29_emp_boris_qb_04", false, true);
local mid_game_vo_02 = new_sfx("Play_wh3_dlc29_emp_boris_qb_05", false, true);
local mid_game_vo_03 = new_sfx("Play_wh3_dlc29_emp_boris_qb_06", false, true);



-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:message_on_commander_dead_or_shattered("boris_dead_or_shattered")

--ga_attacker_01:halt();
gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("cultists_advance", 1000);
gb:message_on_time_offset("cultists_attack", 20000);
ga_attacker_01:message_on_proximity_to_enemy("cultists_rush", 190); 
ga_attacker_01:advance_on_message("cultists_advance");
ga_attacker_01:attack_on_message("cultists_attack");
ga_attacker_01:rush_on_message("cultists_rush");
ga_attacker_01:message_on_casualties("reinforcements_1", 0.20); 
ga_attacker_01:message_on_casualties("reinforcements_2", 0.60); 
gb:message_on_time_offset("reinforcements_2", 60000, "reinforcements_1");

--[[
ga_attacker_01:release_on_message("reinforcements_1", 100);
gb:message_on_time_offset("reinforcements_1", 43500);
ga_attacker_01:message_on_proximity_to_enemy("reinforcements_1", 190); 
ga_attacker_01:message_on_casualties("reinforcements_1", 0.1); 
]]--


----- Initial army -----

ga_attacker_01:attack_on_message("reinforcements_1");

ga_attacker_01:message_on_casualties("bat_1", 0.15);
ga_attacker_01:message_on_casualties("bat_2", 0.25); 
ga_attacker_01:message_on_casualties("bat_3", 0.35);

----- WEF reinforcements ----

ga_ally_02:reinforce_on_message("reinforcements_1");
ga_ally_02:rush_on_message("reinforcements_1", 10000);


----- Khorne Reinforcements -----

ga_ally_01:reinforce_on_message("reinforcements_2");
ga_ally_01:advance_on_message("reinforcements_2", 10000);
gb:message_on_time_offset("reinforcements_1", 20000, "daemons_attack");
ga_ally_01:attack_on_message("daemons_attack");
ga_ally_01:message_on_proximity_to_enemy("daemons_rush", 190); 
ga_ally_01:rush_on_message("daemons_rush", 100);






--------------------------
-----COMPOSITE SCENES-----
--------------------------
kho_portal_01 = "composite_scene/wh3_main_khorne_gate_portal_loop.csc";
kho_portal_02 = "composite_scene/spells_and_abilities/wh3_main_khorne_gate.csc";



gb:add_listener(
"reinforcements_2",
function()
	if reinforcements_spawned == false then
		print(reinforcements_spawned);
		bm:start_terrain_composite_scene(kho_portal_02, nil, 0);
		sm:trigger_message("khorne_portal_1");
		reinforcements_spawned = true;
		print("reinforcements_spawned set to true");
	end
end,
true);


gb:message_on_time_offset("khorne_portal_2", 3050, "khorne_portal_1");

gb:message_on_time_offset("mid_game_vo_01_trigger", 5000, "reinforcements_2");
gb:message_on_time_offset("mid_game_vo_02_trigger", 10000, "mid_game_vo_01_trigger");
gb:message_on_time_offset("mid_game_vo_03_trigger", 17000, "mid_game_vo_01_trigger");

gb:add_listener(
	"khorne_portal_2",
	function()
		bm:start_terrain_composite_scene(kho_portal_01, nil, 0);
	end,
	true
);


gb:message_on_time_offset("close_portals", 30000, "khorne_portal_1");

gb:add_listener(
	"close_portals",
	function()
		bm:stop_terrain_composite_scene(kho_portal_01, nil, 0);
		bm:stop_terrain_composite_scene(kho_portal_02, nil, 0);
	end,
	true
);


gb:add_listener(
	"mid_game_vo_01_trigger",
	function()
		bm:queue_help_message("wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_03")
		play_sound_2D(mid_game_vo_01);
	end,
	true
);
--[[gb:play_sound_on_message(
	"mid_game_vo_02_trigger",
	mid_game_vo_01,
	nil,
	0,
	nil,
	5000
)]]--
gb:add_listener(
	"mid_game_vo_02_trigger",
	function()
		play_sound_2D(mid_game_vo_02);
		bm:queue_help_message("wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_04")
	end,
	true
);

gb:add_listener(
	"mid_game_vo_03_trigger",
	function()
		play_sound_2D(mid_game_vo_03);
		bm:queue_help_message("wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_05")
	end,
	true
);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

---- Hints ----



---- Start----
--gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_01");

--gb:complete_objective_on_message("player_wins", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_01", 1000);
--gb:fail_objective_on_message("boris_dead_or_shattered", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_01", 1000);

---- Defeat ----

---- VICTORY ----
--gb:remove_objective_on_message("reinforcements_1", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_01", 1000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--gb:queue_help_on_message("reinforcements_2", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_01")

gb:queue_help_on_message("reinforcements_1", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_02")
--[[
gb:message_on_time_offset("Boris_mid_battle_dialogue_01", 15000, "khorne_portal_1");
gb:queue_help_on_message("Boris_mid_battle_dialogue_01", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_03")
gb:message_on_time_offset("Boris_mid_battle_dialogue_02", 17500, "khorne_portal_1");
gb:queue_help_on_message("Boris_mid_battle_dialogue_01", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_04")
gb:message_on_time_offset("Boris_mid_battle_dialogue_03", 20000, "khorne_portal_1");
gb:queue_help_on_message("Boris_mid_battle_dialogue_01", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_hint_05")
]]--

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01:force_victory_on_message("boris_dead_or_shattered", 3000)
gb:fail_objective_on_message("boris_dead_or_shattered", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_03");
gb:add_listener(
    "boris_dead_or_shattered",
    function()
        ga_attacker_01:get_alliance():force_battle_victory();
		ga_ally_01:get_alliance():force_battle_victory();
    end
);
-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_02");

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_03")

gb:complete_objective_on_message("player_wins", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_02", 1000);
gb:complete_objective_on_message("player_wins", "wh3_dlc29_qb_emp_boris_todbringer_spilled_blood_03")

gb:add_listener(
    "player_wins",
    function()
        ga_defender_01:get_alliance():force_battle_victory();
    end
);