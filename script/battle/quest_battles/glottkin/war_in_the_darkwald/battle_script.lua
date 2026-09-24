-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- The Glottkin
-- By Matthieu Bonnet-Mille
-- War in the Darkwald

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

-- bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)



-- preloading cutscenes
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_glottkin_qb_intro_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

outro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_glottkin_qb_outro_01.CindySceneManager";

-------------------------------------------------------------------------------------------------
------------------------------------------- INTRO CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Cutscene SFX here
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC29_QB_Glottkin_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC29_QB_Glottkin_Intro", false, false)
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC29_QB_Glottkin_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC29_QB_Glottkin_Outro", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")

	local cam = bm:camera();

	-- cutscene 1 phase 1
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_glottkin_qb_intro_01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

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
						
			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);

	-- ----------------------------- ACTIONS
	-- cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	-- Show objective during cutscene
	cutscene_intro:action(
		function()
			gb.sm:trigger_message("hide_shrine_flag")
			ga_ai_grn_savage_orc_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			ga_player.sunits:item(1):set_invisible_to_all(true);
		end, 
		100 -- time at which the action triggers
	);

	-- Show objective during cutscene
	-- cutscene_intro:action(
	-- 	function()
	-- 		gb.sm:trigger_message("objective_01_cutscene")
	-- 	end, 
	-- 	18000 -- time at which the action triggers
	-- );
	------------------------------
	

	-- add listeners for sound & subs here
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	-- Listeners here
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_01"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_intro_01", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_02"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_intro_02", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_03"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_intro_03", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_04"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_intro_04", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_05"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_intro_05", false, true)
			end
	);
	-------------------

	cutscene_intro:start();
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player.sunits:item(1):set_invisible_to_all(false);
	ga_player.sunits:item(1):release_control();
	sm:trigger_message("cutscene_intro_end")
	-- sm:trigger_message("objective_01_cutscene")
	bm:hide_subtitles()
end;



-------------------------------------------------------------------------------------------------
----------------------------------------- OUTRO CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------

function play_cutscene_outro()
	bm:out("\tplay_phase_2_cutscene() called")

	local cam = bm:camera()

	local cutscene_outro = cutscene:new_from_cindyscene(
		"cutscene_phase_2", 																		    -- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() cutscene_outro_end() end,																-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_glottkin_qb_outro_01.CindySceneManager",		-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	);

	-- cutscene_outro:action(function() cam:fade(false, 1) end, 1000);

	-- set up subtitles
	local subtitles = cutscene_outro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam = bm:camera()
			cam:fade(true, 0)
			bm:stop_cindy_playback(true)

			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles()
		end
	);

	-- add listeners for sound & subs here
	cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 0);
	
	-- listeners here
	cutscene_outro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_end_01", 
		function()
			cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_end_01"))
			bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_outro_01", false, true)
		end
	);
	------

	-- cutscene_outro:set_music("wh3_dlc27_Battle_Outro_Dechala", 0, 0)
	cutscene_outro:start()
end

function cutscene_outro_end()
	play_sound_2D(sfx_cutscene_sweetener_outro_stop)
	sm:trigger_message("cutscene_outro_end")
	bm:hide_subtitles()
end

-------------------------------------------------------------------------------------------------
------------------------------------------ LOCAL SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

local grn_ba = bm:get_non_player_alliance():armies():item(1);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

-- Reinforcement speeds
local speed_01 = 60000;
local speed_02 = 60000;
local speed_03 = 90000;

local shrine_capture_point = bm:capture_location_manager():capture_location_from_script_id("shrine_cp");

-- 3 mins
local countdown_length = 3*60*1000;
local temp_timer = countdown_length;

local player_alliance_id = gb:get_player_alliance_num();


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1)

-- ga_player_reinforce = gb:get_army(gb:get_player_alliance_num(), "player_reinforce")

ga_ai_grn_savage_orc_main = gb:get_army(gb:get_non_player_alliance_num(), "savage_orc_main")
ga_ai_grn_savage_orc_rein_01 = gb:get_army(gb:get_non_player_alliance_num(), "savage_orc_rein_1")
ga_ai_grn_savage_orc_rein_02 = gb:get_army(gb:get_non_player_alliance_num(), "savage_orc_rein_2")
ga_ai_grn_spider_main = gb:get_army(gb:get_non_player_alliance_num(), "spider_main")
ga_ai_grn_spider_rein_1 = gb:get_army(gb:get_non_player_alliance_num(), "spider_rein_1")
ga_ai_grn_spider_shaman_rein = gb:get_army(gb:get_non_player_alliance_num(), "spider_shaman_rein")
--objective holder
ga_ai_grn_spider_shaman_boss = gb:get_army(gb:get_non_player_alliance_num(), "spider_shaman")


ga_ai_bst_allies = gb:get_army(gb:get_player_alliance_num(), "bst_ally")
bst_bray_shaman_unit = ga_ai_bst_allies.sunits:item(1);



-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

savage_orc_reinforce_zone_1 = bm:get_spawn_zone_collection_by_name("grn_savage_rein_1");
savage_orc_reinforce_zone_2 = bm:get_spawn_zone_collection_by_name("grn_savage_rein_2");
spider_reinforce_zone_1 = bm:get_spawn_zone_collection_by_name("grn_spider_rein_1");
spider_reinforce_main = bm:get_spawn_zone_collection_by_name("grn_spider_rein_main");

ga_ai_grn_savage_orc_rein_01:assign_to_spawn_zone_from_collection_on_message("start", savage_orc_reinforce_zone_1, false);
ga_ai_grn_savage_orc_rein_02:assign_to_spawn_zone_from_collection_on_message("start", savage_orc_reinforce_zone_2, false);

ga_ai_grn_spider_rein_1:assign_to_spawn_zone_from_collection_on_message("start", spider_reinforce_zone_1, false);
ga_ai_grn_spider_shaman_rein:assign_to_spawn_zone_from_collection_on_message("start", spider_reinforce_main, false);
ga_ai_grn_spider_shaman_boss:assign_to_spawn_zone_from_collection_on_message("start", spider_reinforce_main, false);

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

-- None

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
-- gb:message_on_time_offset("hint_01", 500, "01_intro_cutscene_end");
gb:message_on_time_offset("objective_01", 5500,"start");
gb:message_on_time_offset("objective_02", 5500,"shaman_in");
gb:message_on_time_offset("objective_03", 5500,"shaman_defeated");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- Defend the bray shaman
ga_ai_bst_allies:halt()
ga_ai_bst_allies:message_on_proximity_to_enemy("bst_counter_attack", 75) -- When the enemy is close to the beastmen, they will react
ga_ai_bst_allies:rush_on_message("bst_counter_attack")
gb:add_listener(
	"wave_1_start",
	function()
		ga_ai_bst_allies.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

ga_ai_grn_savage_orc_main: rush_on_message("start")
ga_ai_grn_spider_main: rush_on_message("start")

-- Defend shrine position when the battle enters phase 2
ga_ai_grn_savage_orc_main:rush_position_on_message("objective_03",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)
ga_ai_grn_spider_main:rush_position_on_message("objective_03",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)
ga_ai_grn_spider_shaman_rein:rush_position_on_message("objective_03",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)
ga_ai_grn_spider_rein_1:rush_position_on_message("objective_03",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)

-- Reclaim the shrine when the battle enters phase 2
ga_ai_grn_savage_orc_rein_01:rush_position_on_message("shrine_captured_by_player",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)
ga_ai_grn_savage_orc_rein_02:rush_position_on_message("shrine_captured_by_player",shrine_capture_point:position():get_x(), shrine_capture_point:position():get_y(), 125)

-- start a timer when first army is defeated, after which send second wave
gb:message_on_time_offset("wave_1_start", 135000, "start") --2min15
gb:message_on_time_offset("wave_2_start", 210000, "start") --3min30



ga_ai_grn_spider_shaman_rein:reinforce_on_message("wave_1_start", 1000)
ga_ai_grn_spider_shaman_rein:message_on_any_deployed("shaman_in")
-- ga_ai_grn_spider_shaman_rein:rush_on_message("shaman_in")
ga_ai_grn_spider_shaman_rein:attack_force_on_message("shaman_in", ga_player, 100)

ga_ai_grn_spider_shaman_boss:reinforce_on_message("wave_1_start", 1000)
ga_ai_grn_spider_shaman_boss:message_on_any_deployed("shaman_in")
-- ga_ai_grn_spider_shaman_boss:rush_on_message("shaman_in")
ga_ai_grn_spider_shaman_boss:attack_force_on_message("shaman_in", ga_player, 100)


-- when Beastmen are defeated, all enemies attack the glottkin army
ga_ai_bst_allies:message_on_rout_proportion("bst_defeated", 0.7)
ga_ai_grn_savage_orc_main:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_spider_main:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_spider_shaman_rein:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_spider_shaman_boss:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_savage_orc_rein_01:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_savage_orc_rein_02:attack_force_on_message("bst_defeated", ga_player, 100)
ga_ai_grn_spider_rein_1:attack_force_on_message("bst_defeated", ga_player, 100)


----------------------------------------
--- Deploy savage orc reinforcements #1
----------------------------------------
function spawn_savage_orc_1_units_wave()
	ga_ai_grn_savage_orc_rein_01:deploy_at_random_intervals_on_message(
		"wave_1_start", 				-- message
		2, 							-- min units
		2, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"shaman_defeated", 		-- cancel message
		true,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_savage_orc_1_units_wave()
ga_ai_grn_savage_orc_rein_01:message_on_any_deployed("01_in")
ga_ai_grn_savage_orc_rein_01:rush_on_message("01_in")

gb:add_listener(
	"01_in",
	function()
		ga_ai_grn_savage_orc_rein_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_grn_savage_orc_rein_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

----------------------------------------
--- Deploy savage orc reinforcements #2
----------------------------------------
function spawn_savage_orc_2_units_wave()
	ga_ai_grn_savage_orc_rein_02:deploy_at_random_intervals_on_message(
		"wave_2_start", 				-- message
		2, 							-- min units
		2, 							-- max units
		speed_02, 					-- min period
		speed_02, 					-- max period
		"shrine_disabled", 		-- cancel message
		true,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_savage_orc_2_units_wave()
ga_ai_grn_savage_orc_rein_02:message_on_any_deployed("02_in")
ga_ai_grn_savage_orc_rein_02:rush_on_message("02_in")

gb:add_listener(
	"02_in",
	function()
		ga_ai_grn_savage_orc_rein_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_grn_savage_orc_rein_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

----------------------------------------
--- Deploy spider tribe reinforcements
----------------------------------------
function spawn_spider_tribe_units_wave()
	ga_ai_grn_spider_rein_1:deploy_at_random_intervals_on_message(
		"wave_2_start", 				-- message
		3, 							-- min units
		3, 							-- max units
		speed_03, 					-- min period
		speed_03, 					-- max period
		"shrine_disabled", 		-- cancel message
		true,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end

spawn_spider_tribe_units_wave()
ga_ai_grn_spider_rein_1:message_on_any_deployed("03_in")
ga_ai_grn_spider_rein_1:rush_on_message("03_in")

gb:add_listener(
	"03_in",
	function()
		ga_ai_grn_spider_rein_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_grn_spider_rein_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);


-- Objective completion
ga_ai_grn_spider_shaman_boss:message_on_rout_proportion("shaman_defeated", 0.99)

-- rout units as the cutscene starts
ga_ai_grn_spider_main:rout_over_time_on_message("shrine_disabled", 3000);
ga_ai_grn_savage_orc_main:rout_over_time_on_message("shrine_disabled", 3000);
ga_ai_grn_savage_orc_rein_02:rout_over_time_on_message("shrine_disabled", 3000);
ga_ai_grn_spider_shaman_rein:rout_over_time_on_message("shrine_disabled", 3000);
ga_ai_grn_spider_rein_1:rout_over_time_on_message("shrine_disabled", 3000);


-------------------------------------
----------CAPTURE LOCATION-----------
-------------------------------------
gb:add_listener(
	"hide_shrine_flag",
	function()
		shrine_capture_point:change_holding_army(grn_ba);
		shrine_capture_point:set_locked(true);
		-- shrine_capture_point:set_enabled(false);
	end
);

-- When the shaman is defeated, move on to this objective and enable the cp
gb:add_listener(
	"shaman_defeated",
	function()
		shrine_capture_point:set_enabled(true);
		shrine_capture_point:set_locked(false);

		-- when the shaman is defeated, units prioritize defending the shrine
		sm:block_message("bst_defeated");
	end
);

-- When cp is capped, send message that stops reinforcements
gb:message_on_capture_location_capture_completed("shrine_captured_by_player", "start", "shrine_cp", nil, ga_ai_grn_savage_orc_main, ga_player);
gb:message_on_time_offset("objective_04", 3000, "shrine_captured_by_player");

-- When cp is capped by orcs, send a message
-- gb:message_on_capture_location_capture_completed("shrine_captured_by_orcs", "start", "shrine_cp", nil, ga_player, ga_ai_grn_savage_orc_main);

-- Close the cap location (optional)
gb:message_on_time_offset("shrine_disabled", 3000, "shrine_held");
gb:add_listener(
	"shrine_disabled",
	function()
		shrine_capture_point:set_enabled(false);
	end
);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

-- gb:set_objective_on_message("objective_01_cutscene","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_1")
gb:set_objective_with_leader_on_message("objective_01","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_1")
gb:set_objective_on_message("objective_01","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive")
gb:set_objective_with_leader_on_message("objective_02","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_2")
gb:set_objective_with_leader_on_message("objective_03","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3")
-- Located objective 03 
gb:set_locatable_objective_callback_on_message(
    "objective_03",
    "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3",
    0,
    function()
		local cam_targ = v(shrine_capture_point:position():get_x(), bm:camera():position():get_y(), shrine_capture_point:position():get_z());
		
		local cam_pos = v_offset_by_bearing(
			cam_targ,
			get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
			100,                                                -- distance from camera position to camera target
			d_to_r(60)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
		);
		return cam_pos, cam_targ;
    end,
    2
);

local reset_obj = false;
-- set hold shrine objective with timer
gb:add_listener(
    "objective_04",
	function()
		-- bm:set_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_4", countdown_length)
		bm:repeat_callback(
			function()
				-- If the player holds the shrine, show the objective and decrease the timer
				if shrine_capture_point:holding_alliance_id() == player_alliance_id then
					temp_timer = temp_timer - 1000
					bm:set_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_4", temp_timer/1000, countdown_length/1000)
					if not reset_obj then
						bm:complete_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3")
					end
					reset_obj = true;
				else 
					-- Else, hide it until they retake
					if reset_obj then
						bm:remove_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3")
						bm:remove_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_4")
						sm:trigger_message("objective_04_shrine_retake")
					end
					bm:set_objective("wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3")
					reset_obj = false;
				end

				-- When the timer runs out, the player completes the objective
				if temp_timer <= 1 then 
					sm:trigger_message("shrine_held")
					bm:remove_callback("end_countdown");
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

gb:remove_objective_on_message("wave_1_start", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_1", 1000)
gb:complete_objective_on_message("shaman_defeated", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_2")
gb:complete_objective_on_message("shrine_captured_by_player", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_3")
gb:complete_objective_on_message("shrine_held", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_objective_4")
gb:complete_objective_on_message("shrine_held", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive")

-- Add a ping on top of the shaman to locate it easily
gb:add_listener(
	"objective_02",
	function()
		ga_ai_grn_spider_shaman_boss.sunits:item(1):add_ping_icon(15);
	end
);
gb:add_listener(
	"shaman_defeated",
	function()
		ga_ai_grn_spider_shaman_boss.sunits:item(1):remove_ping_icon();
	end
);


-------------------------------------------------------------------------------------------------
------------------------------------------- HINTS -----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("objective_01", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_hint_1", 10000, 2000, 15000)
gb:queue_help_on_message("hint_02", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_hint_2", 10000, 2000, 15000)
gb:queue_help_on_message("objective_03", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_hint_3", 10000, 2000, 10000)
gb:queue_help_on_message("objective_04_shrine_retake", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_hint_4", 10000, 2000, 4000)


local sfx_mid_battle_01 = new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_in_battle_01", false, true)
local sfx_mid_battle_02 = new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_in_battle_02", false, true)
local sfx_mid_battle_03 = new_sfx("Play_wh3_dlc29_chs_glottkin_war_in_the_drakwald_in_battle_03", false, true)
local vo_position_default = v(0, 0)
local vo_offset_default = 0

-- Mid battle VO
gb:play_sound_on_message("objective_02", sfx_mid_battle_01, vo_position_default, vo_offset_default, "mid_battle_vo_02")
gb:queue_help_on_message("objective_02", "wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_mid_01", 8880, 1000, 0)

gb:play_sound_on_message("mid_battle_vo_02", sfx_mid_battle_02, vo_position_default, vo_offset_default, "mid_battle_vo_03")
gb:queue_help_on_message("mid_battle_vo_02", "wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_mid_02", 12270, 1000, 0)

gb:play_sound_on_message("mid_battle_vo_03", sfx_mid_battle_03)
gb:queue_help_on_message("mid_battle_vo_03", "wh3_dlc29_qb_chs_glottkin_war_in_the_drakwald_mid_03", 8530, 1000, 0)
gb:message_on_time_offset("hint_02", 12530, "mid_battle_vo_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- DEFEAT -------------------------------------------------
-------------------------------------------------------------------------------------------------

-- Keep Glottkin alive objective failed
ga_player:message_on_commander_dead_or_shattered("lord_dead",1)
ga_ai_grn_savage_orc_main:force_victory_on_message("lord_dead", 6000)
gb:fail_objective_on_message("lord_dead", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive", 3000) 


-------------------------------------------------------------------------------------------------
---------------------------------------- VICTORY ------------------------------------------------
-------------------------------------------------------------------------------------------------

-- Play the outro scene when the shrine is held
gb:add_listener(
	"shrine_disabled",
	function()
		play_cutscene_outro()
	end
);

ga_player:force_victory_on_message("cutscene_outro_end", 6000) -- Claim victory after the cutscene

gb:message_on_time_offset("force_victory", 10000, "cutscene_outro_end");
gb:add_listener(
	"force_victory",
	function()
		ga_player:get_alliance():force_battle_victory();
	end
);


