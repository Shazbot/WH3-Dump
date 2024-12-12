-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Arbaal the Undefeated
-- By Atanas Danovski
-- Destroyer of Khorne

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro = new_sfx("Play_Movie_WH3_DLC26_QB_Arbaal_Destroyer_of_Khorne_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Arbaal_Destroyer_of_Khorne_Intro", false, false)
		
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
local cam = bm:camera()
	
-- REMOVE ME
cam:fade(true, 0)

local cutscene_intro = cutscene:new_from_cindyscene(
	"cutscene_intro", 																				-- unique string name for cutscene
	ga_player.sunits,																					-- unitcontroller over player's army
	function() intro_cutscene_end() end,															-- what to call when cutscene is finished
	"script/battle/quest_battles/_cutscene/managers/wh3_qb_arbaal.CindySceneManager",	            -- path to cindyscene
	0,																								-- blend in time (s)
	0																								-- blend out time (s)
)

local player_units_hidden = false;
ga_ai_vmp_main.sunits:set_always_visible(true);

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
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_01"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_02"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_03"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_04"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_04", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_05"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_05", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_06"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_06", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_07", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_07"))
				bm:show_subtitle("wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_07", false, true)
			end
	)

cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	player_units_hidden = false;
	ga_player:set_enabled(true) 
	ga_ai_vmp_main.sunits:set_always_visible(false);
	ga_ai_vmp_main.sunits:release_control()
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_vmp_main = gb:get_army(gb:get_non_player_alliance_num(), "vmp_main")
ga_ai_cst_reinforce_01 = gb:get_army(gb:get_non_player_alliance_num(), "cst_enemy_reinforcement_1")
ga_ai_cst_reinforce_02 = gb:get_army(gb:get_non_player_alliance_num(), "cst_enemy_reinforcement_2")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

cst_reinforce_1 = bm:get_spawn_zone_collection_by_name("cst_reinforcements_1")
cst_reinforce_2 = bm:get_spawn_zone_collection_by_name("cst_reinforcements_2")

ga_ai_cst_reinforce_01:assign_to_spawn_zone_from_collection_on_message("start", cst_reinforce_1, false);
ga_ai_cst_reinforce_01:message_on_number_deployed("cst_01_deployed", true, 1);
ga_ai_cst_reinforce_01:assign_to_spawn_zone_from_collection_on_message("cst_01_deployed", cst_reinforce_1, false);
ga_ai_cst_reinforce_01:get_army():suppress_reinforcement_adc(1);

ga_ai_cst_reinforce_02:assign_to_spawn_zone_from_collection_on_message("start", cst_reinforce_2, false)
ga_ai_cst_reinforce_02:message_on_number_deployed("cst_02_deployed", true, 1);
ga_ai_cst_reinforce_02:assign_to_spawn_zone_from_collection_on_message("cst_02_deployed", cst_reinforce_2, false);
ga_ai_cst_reinforce_02:get_army():suppress_reinforcement_adc(1);

local reinforcements = bm:reinforcements();

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "cst_reinforcements_1") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "cst_reinforcements_2") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 200);
gb:message_on_time_offset("hint_01", 2700);
gb:message_on_time_offset("objective_02", 200);
gb:message_on_time_offset("vmp_rush", 5000);
gb:message_on_time_offset("vmp_rush_pls", 6000);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_vmp_main:rush_on_message("vmp_rush");
-- ga_ai_vmp_main:attack_force_on_message("vmp_rush_pls", ga_player)
ga_ai_vmp_main:message_on_casualties("vmp_wounded", 0.25)
ga_ai_vmp_main:message_on_casualties("cst_enter", 0.5)
ga_ai_vmp_main:message_on_casualties("vmp_main_defeated", 0.95)

ga_ai_cst_reinforce_01:deploy_at_random_intervals_on_message(
	"cst_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
	3000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_cst_reinforce_01:message_on_any_deployed("reinforcements_01_in");
ga_ai_cst_reinforce_01:rush_on_message("reinforcements_01_in");
ga_ai_cst_reinforce_01:message_on_casualties("reinforcements_01_defeated", 0.95)

ga_ai_cst_reinforce_02:deploy_at_random_intervals_on_message(
	"cst_reinforce", 			-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
	3000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_cst_reinforce_02:message_on_any_deployed("reinforcements_02_in");
ga_ai_cst_reinforce_02:rush_on_message("reinforcements_02_in");
ga_ai_cst_reinforce_02:message_on_casualties("reinforcements_02_defeated", 0.95)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_all_messages_received("reinforcements_defeated","reinforcements_01_defeated","reinforcements_02_defeated");

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_1");
gb:complete_objective_on_message("vmp_main_defeated", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_1", 2500)

gb:set_locatable_objective_callback_on_message(
    "objective_02",
    "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_2",
    0,
    function()
        local sunit = ga_player.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
gb:fail_objective_on_message("arbaal_dead_or_shattered", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_2", 2500)
gb:complete_objective_on_message("obj_2_complete", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_2", 2500)

gb:set_objective_with_leader_on_message("cst_enter", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_3");
gb:complete_objective_on_message("reinforcements_defeated", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_objective_3", 2500)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("cst_reinforce", 5000, "cst_enter");

gb:queue_help_on_message("hint_01", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_hint_1")
gb:queue_help_on_message("vmp_wounded", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_hint_2")
gb:queue_help_on_message("cst_enter", "wh3_dlc26_qb_kho_arbaal_destroyer_of_khorne_hint_3")

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_commander_dead_or_shattered("arbaal_dead_or_shattered")
ga_ai_vmp_main:force_victory_on_message("arbaal_dead_or_shattered", 5000)

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_all_messages_received("player_wins","objective_01","obj_2_complete","obj_3_complete");
ga_player:force_victory_on_message("player_wins", 5000)