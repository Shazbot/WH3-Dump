-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Sea Lord Aislinn
-- By Hristo Enev
-- Honor Among Admirals

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro = new_sfx("Play_Movie_WH3_DLC26_QB_Honor_Among_Admirals_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Honor_Among_Admirals_Intro", false, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC26_QB_Honor_Among_Admirals_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Honor_Among_Admirals_Mid", false, false)
		
-------------------------------------------------------------------------------------------------
------------------------------------------- INTRO CUTSCENE --------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
local cam = bm:camera()
	
--REMOVE ME
--cam:fade(true, 0)

local cutscene_intro = cutscene:new_from_cindyscene(
	"cutscene_intro", 																				-- unique string name for cutscene
	ga_player.sunits,																				-- unitcontroller over player's army
	function() intro_cutscene_end() end,															-- what to call when cutscene is finished
	"script/battle/quest_battles/_cutscene/managers/wh3_qb_aislinn_intro_m01.CindySceneManager",	-- path to cindyscene	
	0,																								-- blend in time (s)
	0																								-- blend out time (s)
)

local player_units_hidden = false;
ga_ai_def_main.sunits:set_always_visible(true);
ga_player.sunits:get_general_sunit():set_invisible_to_all(true);

-- set up subtitles
local subtitles = cutscene_intro:subtitles()
subtitles:set_alignment("bottom_centre")
subtitles:clear()

-- skip callback
cutscene_intro:set_skippable(
	true, 
	function()
		local cam = bm:camera()
		cam:fade(true, 0)
		bm:stop_cindy_playback(true)

		if player_units_hidden then
			ga_player:set_enabled(true)
		end;
				
		bm:callback(function() cam:fade(false, 0.5) end, 500)
		bm:hide_subtitles()
	end
)

-- set up actions on cutscene
cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

cutscene_intro:action(
	function()
		player_units_hidden = false;
		ga_player:set_enabled(true) 
	end, 
	200
)

-- set up actions on cutscene
cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro) end, 0);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_01"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_02"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_03"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_04"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_04", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_05"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_05", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_06"))
				bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase1_06", false, true)
			end
	)

cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	player_units_hidden = false;
	ga_player:set_enabled(true) 
	ga_ai_def_main.sunits:set_always_visible(true);
	--ga_ai_def_main.sunits:release_control()
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	--play_mid_cutscene()
end

-------------------------------------------------------------------------------------------------
------------------------------------------- MID CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------
function play_mid_cutscene()
	--bm:camera():fade(true, 0.2)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		--cam:fade(false, 1)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_aislinn_mid_m01.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
 
		-- set up subtitles
		local subtitles = cutscene_mid:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_mid:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0)
				bm:stop_cindy_playback(true)
				bm:callback(function() cam:fade(false, 0.5) end, 500)
				bm:hide_subtitles()
			end
		)
		
		-- set up actions on cutscene
		cutscene_mid:action(function() cam:fade(false, 1) end, 100)
		
		-- a fade at the end of the cutscene to hid the camera movement
		cutscene_mid:action(function() cam:fade(true, 1) end, 6200)
		
		-- Voiceover and Subtitles --
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase3_02", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase3_02"))
					bm:show_subtitle("wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase3_02", false, true)
				end
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	--camera position
	camera_target=v(80, 483, 477, -1) -- where lockhir spawns
	camera_position=v(65, 625, 340, -1)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	cam:fade(false, 1);
	play_sound_2D(sfx_cutscene_sweetener_mid_stop);
	player_units_hidden = false;
	ga_player:set_enabled(true) 
	ga_ai_def_main.sunits:set_always_visible(true);
	gb:message_on_time_offset("mid_cutscene_end",100)
end
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())


ga_player_reinforce = gb:get_army(gb:get_player_alliance_num(), "player_reinforce")

ga_ai_def_main = gb:get_army(gb:get_non_player_alliance_num(), "def_main")
ga_ai_def_reinforce_01 = gb:get_army(gb:get_non_player_alliance_num(), "def_reinforcement_1")

ga_ai_def_reinforce_02 = gb:get_army(gb:get_non_player_alliance_num(), "def_reinforcement_2")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

player_reinforcement = bm:get_spawn_zone_collection_by_name("player_reinforcement")
ga_player_reinforce:assign_to_spawn_zone_from_collection_on_message("start", player_reinforcement, false);
ga_player_reinforce:message_on_number_deployed("player_reinforcement_deployed", true, 1);

def_reinforce_1 = bm:get_spawn_zone_collection_by_name("def_reinforcements_1")
ga_ai_def_reinforce_01:assign_to_spawn_zone_from_collection_on_message("start", def_reinforce_1, false);
ga_ai_def_reinforce_01:message_on_number_deployed("def_01_deployed", true, 1);
ga_ai_def_reinforce_01:get_unitcontroller():fire_at_will(false)

def_reinforce_2 = bm:get_spawn_zone_collection_by_name("def_reinforcements_2")
ga_ai_def_reinforce_02:assign_to_spawn_zone_from_collection_on_message("start", def_reinforce_2, false);
ga_ai_def_reinforce_02:message_on_number_deployed("def_02_deployed", true, 1);

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
ga_ai_def_main:message_on_casualties("phase_2_start", 0.2);
gb:message_on_time_offset("spawn_player_reinforcements", 60000,"def_reinforcements_01_near");
ga_ai_def_main:message_on_casualties("phase_3_start", 0.6);


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"phase_3_start",
	function()
		bm:callback(
			function()
			play_mid_cutscene()
			end,
			2000
		)
	end
)
ga_ai_def_main:message_on_under_attack("def_main_under_attack");
ga_ai_def_main:message_on_proximity_to_enemy("player_army_nearby", 250);
gb:message_on_any_message_received("rush_main_enemy", "def_main_under_attack", "player_army_nearby")
ga_ai_def_main:rush_on_message("rush_main_enemy");

ga_ai_def_reinforce_01:deploy_at_random_intervals_on_message(
	"phase_2_start", 			-- message
	4, 							-- min units
	4, 							-- max units
	100, 					  	-- min period
	200, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

local phase_1_short_vo = new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_short_VO_line", false, true);

ga_ai_def_reinforce_01:message_on_any_deployed("reinforcements_01_in");
ga_ai_def_reinforce_01:rush_on_message("reinforcements_01_in");

ga_ai_def_reinforce_01:message_on_proximity_to_enemy("def_reinforcements_01_near", 70);
--[[for i = 1, ga_ai_def_reinforce_01.sunits:count() do
	local current_sunit = ga_ai_def_reinforce_01.sunits:item(i);
		current_sunit:modify_ammo(0.2)
end]]--
ga_ai_def_reinforce_01:change_behaviour_active_on_message("def_reinforcements_01_near","fire_at_will", false, false)

ga_player_reinforce:deploy_at_random_intervals_on_message(
	"spawn_player_reinforcements", 	-- message
	3, 								-- min units
	3, 								-- max units
	100, 					  		-- min period
	200, 							-- max period
	nil,				 			-- cancel message
	false,							-- spawn first wave immediately
	false,							-- allow respawning
	nil,							-- survival battle wave index
	nil,							-- is final survival wave
	false							-- show debug output
)

ga_player_reinforce:message_on_any_deployed("player_reinforcement_in");
ga_player_reinforce:move_to_position_on_message("player_reinforcement_in", v(-100, 200));

ga_ai_def_reinforce_02:deploy_at_random_intervals_on_message(
	"phase_3_start", 			-- message
	2, 							-- min units
	4, 							-- max units
	100, 					  	-- min period
	200, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
)

ga_ai_def_reinforce_02:rush_on_message("def_02_deployed");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--attack enemy--
gb:set_objective_on_message("start", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_1");

gb:fail_objective_on_message("aislinn_dead_or_shattered", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_1", 2500)
gb:complete_objective_on_message("def_reinforcements_01_near", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_1", 2500)

--survive--
gb:set_objective_on_message("def_reinforcements_01_near", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_2");

gb:fail_objective_on_message("aislinn_dead_or_shattered", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_2", 2500)
gb:complete_objective_on_message("phase_3_start", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_2", 2500)

--kill lokhir--
gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_3");

gb:fail_objective_on_message("aislinn_dead_or_shattered", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_3", 2500)
gb:complete_objective_on_message("player_wins", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_objective_3", 2500)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
local phase_2_reinforcements_in_01 = new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_01", false, true);
local phase_2_reinforcements_in_02 = new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_02", false, true);
local phase_2_reinforcements_in_03 = new_sfx("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_03", false, true);
local phase_3_player_reinforcements = new_sfx("Play_wh3_dlc27_qb_hef_unit_honour_between_admirals_phase3_01", false, true);


gb:queue_help_on_message("reinforcements_01_in", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_01", 5000)
gb:play_sound_on_message("reinforcements_01_in", phase_2_reinforcements_in_01);
--sound_effect:load("Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_01")
--sound_effect:playVO(ga_player.get_general_sunit())

--gb:play_sound_on_message(new_sfx("reinforcements_01_in", "Play_wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_01"))

gb:queue_help_on_message("def_reinforcements_01_near", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_02", 2500)
gb:play_sound_on_message("def_reinforcements_01_near", phase_2_reinforcements_in_02);

gb:message_on_time_offset("offset_for_sound", 5000, "def_reinforcements_01_near");
gb:queue_help_on_message("offset_for_sound", "wh3_dlc27_qb_hef_aislinn_honour_between_admirals_phase2_03")
gb:play_sound_on_message("offset_for_sound", phase_2_reinforcements_in_03);

gb:queue_help_on_message("player_reinforcement_deployed", "wh3_dlc27_qb_hef_unit_honour_between_admirals_phase3_01")
gb:play_sound_on_message("player_reinforcement_deployed", phase_3_player_reinforcements);

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_commander_dead_or_shattered("aislinn_dead_or_shattered")
ga_ai_def_main:force_victory_on_message("aislinn_dead_or_shattered", 5000)

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_def_reinforce_02:message_on_commander_dead_or_shattered("player_wins");
ga_player:force_victory_on_message("player_wins", 5000)