-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Crown of Claws
-- Caverns of Mourn
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

gb:set_cutscene_during_deployment(true);

-- preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/ksl_crown_claws.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_00 = new_sfx("Play_Movie_WH3_DLC24_QB_Crown_of_Claws_Sweetener");

wh3_main_sfx_01 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_01");
wh3_main_sfx_02 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_02");
wh3_main_sfx_03 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_03");
wh3_main_sfx_04 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_04");
wh3_main_sfx_05 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_05");
wh3_main_sfx_06 = new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_06");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

 function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
		
	local cutscene_intro = cutscene:new_from_cindyscene(
		-- unique string name for cutscene
		"cutscene_intro",
		-- unitcontroller or scriptunits collection over player's army
		ga_player_01.sunits,
		-- end callback
		function() intro_cutscene_end() end,
		-- path to cindy scene
		intro_cinematic_file,
		-- optional fade in/fade out durations
		0,
		0
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
					
 			bm:callback(function() cam:fade(false, 0.5) end, 500);
 			bm:hide_subtitles();
 		end
 	);

 	-- set up actions on cutscene
 	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

 	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_main_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_01"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_02"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_03"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_04"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_05"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_05", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_06"));
				bm:show_subtitle("wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_pt_06", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end");
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "master_01");
ga_ai_01_boss = gb:get_army(gb:get_non_player_alliance_num(), "master_01_boss");
ga_ai_01_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "master_01_beasts");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "master_02");
ga_ai_02_boss = gb:get_army(gb:get_non_player_alliance_num(), "master_02_boss");
ga_ai_02_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "master_02_beasts");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "master_03");
ga_ai_03_boss = gb:get_army(gb:get_non_player_alliance_num(), "master_03_boss");
ga_ai_03_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "master_03_beasts");
ga_ai_boss = gb:get_army(gb:get_non_player_alliance_num(), "boss");

boss_01 = ga_ai_01_boss.sunits:item(1);
boss_02 = ga_ai_02_boss.sunits:item(1);
boss_03 = ga_ai_03_boss.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("beast_reinforce_01");
reinforce_02 = bm:get_spawn_zone_collection_by_name("beast_reinforce_02");
reinforce_03 = bm:get_spawn_zone_collection_by_name("beast_reinforce_03");

ga_ai_01_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);
ga_ai_01_reinforce:message_on_number_deployed("beast_reinforce_01_deployed", true, 1);
ga_ai_01_reinforce:assign_to_spawn_zone_from_collection_on_message("beast_reinforce_01_deployed", reinforce_01, false);

ga_ai_02_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforce_02, false);
ga_ai_02_reinforce:message_on_number_deployed("beast_reinforce_02_deployed", true, 1);
ga_ai_02_reinforce:assign_to_spawn_zone_from_collection_on_message("beast_reinforce_02_deployed", reinforce_02, false);

ga_ai_03_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforce_03, false);
ga_ai_03_reinforce:message_on_number_deployed("beast_reinforce_03_deployed", true, 1);
ga_ai_03_reinforce:assign_to_spawn_zone_from_collection_on_message("beast_reinforce_03_deployed", reinforce_03, false);

ga_ai_boss:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "beast_reinforce_01") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "beast_reinforce_02") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "beast_reinforce_03") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("masters_start", 1000);
gb:message_on_time_offset("boss_rumble", 120000);
gb:message_on_time_offset("boss_entry", 180000);

ga_ai_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_ai_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_ai_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("objective_01", 7500);
gb:add_listener(
	"objective_01",
	function()
		boss_01:add_ping_icon(15);
	end
);

gb:message_on_time_offset("objective_02", 12500);
gb:add_listener(
	"objective_02",
	function()
		boss_02:add_ping_icon(15);
	end
);

gb:message_on_time_offset("objective_03", 17500);
gb:add_listener(
	"objective_03",
	function()
		boss_03:add_ping_icon(15);
	end
);

ga_ai_01:rush_on_message("masters_start");
ga_ai_01:message_on_rout_proportion("master_01_forces_dead",0.95);

ga_ai_01_boss:rush_on_message("masters_start");
ga_ai_01_boss:message_on_rout_proportion("master_01_dead",0.99);

ga_ai_01_reinforce:deploy_at_random_intervals_on_message(
	"objective_01", 			-- message
	1, 							-- min units
	1, 							-- max units
	25000, 						-- min period
	25000, 						-- max period
	"master_01_routing", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survivals battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_01_reinforce:message_on_any_deployed("master_01_beasts_in");
ga_ai_01_reinforce:rush_on_message("master_01_beasts_in");

gb:add_listener(
	"master_01_routing",
	function()
		boss_01:remove_ping_icon();
		
		if ga_ai_01_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_01_reinforce.sunits:rout_over_time(3000);
		end;
	end,
	true
);

ga_ai_02:rush_on_message("masters_start");
ga_ai_02:message_on_rout_proportion("master_02_forces_dead",0.95);

ga_ai_02_boss:rush_on_message("masters_start");
ga_ai_02_boss:message_on_rout_proportion("master_02_dead",0.99);

ga_ai_02_reinforce:deploy_at_random_intervals_on_message(
	"objective_02", 			-- message
	1, 							-- min units
	1, 							-- max units
	30000, 						-- min period
	30000, 						-- max period
	"master_02_routing", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_02_reinforce:message_on_any_deployed("master_02_beasts_in");
ga_ai_02_reinforce:rush_on_message("master_02_beasts_in");

gb:add_listener(
	"master_02_routing",
	function()
		boss_02:remove_ping_icon();
		
		if ga_ai_02_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_02_reinforce.sunits:rout_over_time(3000);
		end;
	end,
	true
);

ga_ai_03:rush_on_message("masters_start");
ga_ai_03:message_on_rout_proportion("master_03_forces_dead",0.95);

ga_ai_03_boss:rush_on_message("masters_start");
ga_ai_03_boss:message_on_rout_proportion("master_03_dead",0.99);

ga_ai_03_reinforce:deploy_at_random_intervals_on_message(
	"objective_02", 			-- message
	1, 							-- min units
	1, 							-- max units
	35000, 						-- min period
	35000, 						-- max period
	"master_03_routing", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_03_reinforce:message_on_any_deployed("master_03_beasts_in");
ga_ai_03_reinforce:rush_on_message("master_03_beasts_in");

gb:add_listener(
	"master_03_routing",
	function()
		boss_03:remove_ping_icon();
		
		if ga_ai_03_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_03_reinforce.sunits:rout_over_time(3000);
		end;
	end,
	true
);

ga_ai_boss:reinforce_on_message("boss_entry", 5000);
ga_ai_boss:message_on_deployed("boss_in");
ga_ai_boss:rush_on_message("boss_in");
ga_ai_boss:message_on_rout_proportion("beastmaster_dead",0.95);

gb:add_listener(
	"boss_in",
	function()
		if ga_ai_boss.sunits:are_any_active_on_battlefield() == true then
			ga_ai_boss.sunits:set_stat_attribute("unbreakable", true);
		end;
	end,
	true
);

ga_ai_01_boss:message_on_commander_dead_or_routing("master_01_routing");
ga_ai_02_boss:message_on_commander_dead_or_routing("master_02_routing");
ga_ai_03_boss:message_on_commander_dead_or_routing("master_03_routing");

-- ga_ai_01_boss:message_on_rout_proportion("master_01_routing", 0.3);
-- ga_ai_02_boss:message_on_rout_proportion("master_02_routing", 0.3);
-- ga_ai_03_boss:message_on_rout_proportion("master_03_routing", 0.3);

gb:message_on_all_messages_received("master_01_all_dead", "master_01_dead", "master_01_forces_dead");
gb:message_on_all_messages_received("master_02_all_dead", "master_02_dead", "master_02_forces_dead");
gb:message_on_all_messages_received("master_03_all_dead", "master_03_dead", "master_03_forces_dead");

gb:message_on_all_messages_received("def_dead", "master_01_dead", "master_01_forces_dead", "master_02_dead", "master_02_forces_dead", "master_03_dead", "master_03_forces_dead", "beastmaster_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_01");
gb:complete_objective_on_message("master_01_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_01");
gb:remove_objective_on_message("master_01_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_01", 30000);

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_02");
gb:complete_objective_on_message("master_02_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_02");
gb:remove_objective_on_message("master_02_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_02", 30000);

gb:set_objective_with_leader_on_message("objective_03", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_03");
gb:complete_objective_on_message("master_03_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_03");
gb:remove_objective_on_message("master_03_all_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_03", 30000);

gb:set_objective_with_leader_on_message("boss_in", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_04");
gb:complete_objective_on_message("beastmaster_dead", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_objective_04");

gb:queue_help_on_message("masters_start", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_01");
gb:queue_help_on_message("boss_rumble", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_02");
gb:queue_help_on_message("boss_entry", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_03");

gb:queue_help_on_message("master_01_routing", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_04");
gb:queue_help_on_message("master_02_routing", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_05");
gb:queue_help_on_message("master_03_routing", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws_hint_06");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:force_victory_on_message("def_dead", 5000);