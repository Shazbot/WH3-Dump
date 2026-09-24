-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Thanquol
-- By Boris Stamatov & Hristo Enev
-- Death from Within

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      			-- screen starts black
	false,                                    		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

local total_bell_dongs = 13;
local time_between_tolls = 0.42*60*1000;
local current_bell_dong = 0;
local time_for_marshal_reinforcements = 3*60*1000;
local time_for_delverance_reinforcements = 5*60*1000;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_skv_allies_deployed = gb:get_army(gb:get_player_alliance_num(), "skv_ally_deployed")
ga_ai_skv_allies_skreech = gb:get_army(gb:get_player_alliance_num(), "skv_ally_skreech")

ga_ai_emp_main = gb:get_army(gb:get_non_player_alliance_num(), "emp_main")
ga_ai_emp_main_2 = gb:get_army(gb:get_non_player_alliance_num(), "emp_main_2")
ga_ai_emp_gotrek_felix = gb:get_army(gb:get_non_player_alliance_num(), "emp_gotrek_felix")
local gotrek=ga_ai_emp_gotrek_felix.sunits:item(1);
local felix=ga_ai_emp_gotrek_felix.sunits:item(2);
ga_ai_emp_reinforcements_marshal = gb:get_army(gb:get_non_player_alliance_num(), "emp_reinf_marshal")
ga_ai_emp_reinforcements_deliverance = gb:get_army(gb:get_non_player_alliance_num(), "emp_reinf_deliverance")

--vectors--

objective_position=new v(-225, 250, 25);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

emp_reinforcements_marshal = bm:get_spawn_zone_collection_by_name("emp_reinf_marshal")
emp_reinforcements_deliverance = bm:get_spawn_zone_collection_by_name("emp_reinf_deliverance")
skv_allies_skreech = bm:get_spawn_zone_collection_by_name("skv_reinf_skreech")



ga_ai_skv_allies_skreech:assign_to_spawn_zone_from_collection_on_message("start", skv_allies_skreech, false);
ga_ai_skv_allies_skreech:message_on_number_deployed("skv_skreech_deployed", true, 1);
ga_ai_emp_reinforcements_marshal:assign_to_spawn_zone_from_collection_on_message("start", emp_reinforcements_marshal, false);
ga_ai_emp_reinforcements_marshal:message_on_number_deployed("emp_marshal_deployed", true, 1);
ga_ai_emp_reinforcements_deliverance:assign_to_spawn_zone_from_collection_on_message("start", emp_reinforcements_deliverance, false);
ga_ai_emp_reinforcements_deliverance:message_on_number_deployed("emp_deliverance_deployed", true, 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

emp_main_2_teleport_locations = {
	{x = -130,y = -125, orientation = 0.0}, -- Captain
	{x = -155,y = -254, orientation = 0.0}, -- Greatswords 1
	{x = -96, y = -209, orientation = 0.0}, -- Greatswords 2
	{x = -115,y = -287, orientation = 0.0}, -- Halberdiers 1
	{x = -58, y = -236, orientation = 0.0}, -- Halberdiers 2
	{x = -82, y = -286, orientation = 0.0}, -- Halberdiers 3
	{x = -90, y = -294, orientation = 0.0}, -- Ironsides 1
	{x = -59, y = -266, orientation = 0.0}, -- Ironsides 2
	{x = -58, y = -297, orientation = 0.0}, -- Ironsides 3
}

function battle_start_teleport_emp_allies()
	for i=1, 9 do
		local sunit = ga_ai_emp_main_2.sunits:item(i)
		local location = v(emp_main_2_teleport_locations[i].x, emp_main_2_teleport_locations[i].y)
		sunit.uc:teleport_to_location(location, emp_main_2_teleport_locations[i].orientation, 40)
	end
end

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_ui_bell_dong = new_sfx("UI_Battle_PopUp_Bell_Dong", false, false)
local sfx_ui_bell_dong_final = new_sfx("UI_Battle_PopUp_Bell_Dong_End", false, false)
	
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
		"script/battle/quest_battles/_cutscene/managers/wh3_qb_thanquol_intro.CindySceneManager",	 	-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	)

	ga_ai_skv_allies_deployed.sunits:set_always_visible(true);
	ga_ai_emp_main.sunits:set_always_visible(true);
	ga_ai_emp_main_2.sunits:set_always_visible(true);
	ga_ai_emp_gotrek_felix.sunits:set_always_visible(true);
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
			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)

	-- set up actions on cutscene

	cutscene_intro:action(
		function()
			--ga_ai_bst_allies:rush();
		end,
		100
	)

	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	

	-- set up actions on cutscene

	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)
	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC29_QB_Thanquol_Intro", true, false)) end, 100);

		-- Voiceover and Subtitles --

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_death_from_within_01", 
				function()
					--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_death_from_within_01"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_intro_01", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_death_from_within_03", 
				function()
					--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_death_from_within_03"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_intro_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_death_from_within_04", 
				function()
					--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_death_from_within_04"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_intro_03", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_death_from_within_05", 
				function()
					--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_death_from_within_05"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_intro_04", false, true)
				end
		)

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_QB_Thanquol_Intro", false, false));
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	ga_ai_skv_allies_deployed.sunits:set_always_visible(true);
	ga_ai_emp_main.sunits:set_always_visible(true);
	ga_ai_emp_main_2.sunits:set_always_visible(true);
	ga_ai_emp_gotrek_felix.sunits:set_always_visible(true);
	bm:camera():fade(false, 0);
	gb.sm:trigger_message("intro_cutscene_end")
end

-------------------------------------------------------------------------------------------------
------------------------------------------- MID CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------

function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera():fade(false,0)
		

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_qb_thanquol_mid.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
		
		ga_ai_emp_main.sunits:set_invisible_to_all(true);
		ga_ai_emp_main_2.sunits:set_invisible_to_all(true);
		ga_ai_emp_gotrek_felix.sunits:set_invisible_to_all(true);
        ga_ai_emp_reinforcements_marshal.sunits:set_invisible_to_all(true);
        ga_ai_emp_reinforcements_deliverance.sunits:set_invisible_to_all(true);
        ga_ai_skv_allies_skreech.sunits:set_invisible_to_all(true);
		ga_player.sunits:set_invisible_to_all(true);

        
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

	cutscene_mid:action(function() cutscene_mid:play_sound(new_sfx("Play_Movie_WH3_DLC29_QB_Thanquol_Mid", true, false)) end, 100);


		-- Voiceover and Subtitles --
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_skreech_death_from_within_mid_01", 
				function()
					--cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_skreech_death_from_within_mid_01"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_mid_01", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_skreech_death_from_within_mid_02", 
				function()
					--cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_skreech_death_from_within_mid_02"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_mid_02", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_skreech_death_from_within_mid_03", 
				function()
					--cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_skreech_death_from_within_mid_03"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_death_from_within_mid_03", false, true)
				end
		)
       
		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_QB_Thanquol_Mid", false, false));
	ga_ai_emp_main.sunits:set_always_visible(true);
	ga_ai_emp_main_2.sunits:set_always_visible(true);
	ga_ai_emp_reinforcements_marshal.sunits:set_always_visible(true);
	ga_ai_emp_gotrek_felix.sunits:set_always_visible(true);
	ga_ai_emp_reinforcements_deliverance.sunits:set_always_visible(true);
	ga_ai_skv_allies_deployed.sunits:set_always_visible(true);
    ga_ai_skv_allies_skreech.sunits:set_always_visible(true);
	ga_player.sunits:set_always_visible(true);
	gb.sm:trigger_message("mid_cutscene_end")
end

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

battle_start_teleport_emp_allies()

gb:message_on_time_offset("start", 100);

ga_ai_skv_allies_deployed:message_on_casualties("bomboclat",0.85);
ga_ai_skv_allies_deployed:rout_over_time_on_message("bomboclat", 3000)

gb:message_on_time_offset("marshal_to_reinforce", time_for_marshal_reinforcements, "start");

gb:message_on_time_offset("deliverance_to_reinforce", time_for_delverance_reinforcements, "start");

gb:add_listener(
	"play_mid_cutscene",
	function()
		play_mid_cutscene();
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_skv_allies_deployed:rush_position_on_message("start", 20, 180, 30);
ga_ai_skv_allies_deployed:prevent_rallying_if_routing_on_message("start");
ga_ai_emp_main:rush_position_on_message("start",-225,25,30);
ga_ai_emp_main_2:rush_position_on_message("start",-225,25,30);
ga_ai_emp_gotrek_felix:rush_on_message("start");

ga_ai_emp_gotrek_felix:rush_position_on_message("bomboclat",-225,25,30);

ga_ai_emp_reinforcements_marshal:deploy_at_random_intervals_on_message(
	"marshal_to_reinforce",		-- message
	4, 							-- min units
	6, 							-- max units
	1000, 					  	-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);
ga_ai_emp_reinforcements_marshal:rush_position_on_message("emp_marshal_deployed",-225,25,30);

ga_ai_emp_reinforcements_deliverance:deploy_at_random_intervals_on_message(
	"deliverance_to_reinforce",	-- message
	4, 							-- min units
	6, 							-- max units
	1000, 					  	-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);
ga_ai_emp_reinforcements_deliverance:rush_position_on_message("emp_deliverance_deployed",-225,25,30);

ga_ai_skv_allies_skreech:deploy_at_random_intervals_on_message(
	"play_mid_cutscene",		-- message
	4, 							-- min units
	6, 							-- max units
	1000, 					  	-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);
ga_ai_skv_allies_skreech:message_on_any_deployed("skv_skreech_in")
ga_ai_skv_allies_skreech:rush_position_on_message("skv_skreech_in", 20, 180, 30);

ga_ai_emp_main:rush_on_message("mid_cutscene_end");
ga_ai_emp_reinforcements_marshal:rush_on_message("mid_cutscene_end");
ga_ai_emp_reinforcements_deliverance:rush_on_message("mid_cutscene_end");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
-----THANQUOL MUST SURVIVE-----
gb:set_objective_on_message("intro_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 1100);
gb:fail_objective_on_message("thanquol_dead_or_shattered", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 500);
gb:complete_objective_on_message("enemy_is_shattered", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 1500);

--defend the bell--

gb:set_objective_on_message("intro_cutscene_end","wh3_dlc29_qb_skv_thanquol_death_from_within_objective_1",1000)

gb:add_listener(
    "start",
	function()
		bm:repeat_callback(
			function()
				current_bell_dong=current_bell_dong+1;
				if current_bell_dong == total_bell_dongs then
					bm:remove_callback("end_countdown");
					play_sound_2D(sfx_ui_bell_dong_final);
					sm:trigger_message("play_mid_cutscene")
					bm:complete_objective("wh3_dlc29_qb_skv_thanquol_death_from_within_objective_1");
				else
					bm:set_objective("wh3_dlc29_qb_skv_thanquol_death_from_within_objective_1", current_bell_dong, total_bell_dongs);
					play_sound_2D(sfx_ui_bell_dong);
				end;
			end, 
			time_between_tolls,
			"end_countdown"
		)
	end
)

gb:remove_objective_on_message("play_mid_cutscene", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_1", 8000);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_1", 500);

--defeat gotrek & felix (optional)--

gb:set_objective_on_message("start", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_2", 4000);

gb:add_listener(
	"start",
	function()
		bm:repeat_callback(
			function()
				if gotrek.unit:unary_hitpoints() <= 0 then
				sm:trigger_message("gotrek_dead")
				end
				if felix.unit:unary_hitpoints() <= 0 then
				sm:trigger_message("felix_dead")
				end
			end,
			1000,
			"gotrek_dead"
		)
	end
)
ga_ai_emp_gotrek_felix:message_on_casualties("gotrek_army_beaten",0.75)

gb:message_on_all_messages_received("gotrek_felix_defeated", "gotrek_dead", "felix_dead", "gotrek_army_beaten")
gb:complete_objective_on_message("gotrek_felix_defeated", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_2", 1500);
gb:remove_objective_on_message("gotrek_felix_defeated", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_2", 6500);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_2", 500);

--defeat all enemies--

gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3", 2000);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3", 2500);
gb:complete_objective_on_message("enemy_is_shattered", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3", 2000);

-----SKREECH MUST SURVIVE-----
gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3_skreech", 1000);
gb:fail_objective_on_message("skreech_dead_or_shattered", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3_skreech", 500);
gb:complete_objective_on_message("enemy_is_shattered", "wh3_dlc29_qb_skv_thanquol_death_from_within_objective_3_skreech", 1500);
-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------

local cp_main_01 = bm:capture_location_manager():capture_location_from_script_id("cp_main_01");

gb:add_listener(
	"start",
	function()
		cp_main_01:change_holding_army(ga_player.army);
	end
);

gb:add_listener(
	"play_mid_cutscene",
	function()
		cp_main_01:set_enabled(false);
	end
);

gb:message_on_capture_location_capture_completed("emp_succeded","start","cp_main_01","wh3_dlc29_qb_skv_death_from_within",gb:get_non_player_alliance_num())

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--[[
local phase_1_short_vo = new_sfx("Play_wh3_dlc27_qb_nor_sayl_QB_phase1_short_VO_line", false, true);

gb:queue_help_on_message("intro_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_1", 10000, 2000, 2000)
gb:add_ping_icon_on_message("intro_cutscene_end", objective_position, 13);
gb:remove_ping_icon_on_message("phase_2_start", objective_position);

gb:queue_help_on_message("timer_for_reinforcements", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_2", 10000, 2000, 2000)
gb:message_on_time_offset("tower_vo_hint", 90000, "phase_2_start");
gb:queue_help_on_message("tower_vo_hint", "wh3_dlc27_qb_nor_sayl_tower_of_ashsair_phase1_04_short_VO")
gb:play_sound_on_message("tower_vo_hint", phase_1_short_vo);

gb:queue_help_on_message("mid_cutscene_end", "wh3_dlc27_qb_nor_sayl_tower_of_ashshair_hint_3", 10000, 2000, 1000)
gb:add_ping_icon_on_message("mid_cutscene_end", escape_position, 13);
gb:remove_ping_icon_on_message("sayl_escaped", escape_position);
]]--

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_shattered_proportion("player_army_defeated", 0.95);
ga_player:message_on_commander_dead_or_shattered("thanquol_dead_or_shattered");
ga_ai_skv_allies_skreech:message_on_commander_dead_or_shattered("skreech_dead_or_shattered");

--if capture point is lost play message

gb:message_on_any_message_received("player_lost", "player_army_defeated", "thanquol_dead_or_shattered", "emp_succeded", "skreech_dead_or_shattered");
ga_ai_emp_main:force_victory_on_message("emp_succeded", 5000);
gb:message_on_time_offset("force_loss", 10000, "emp_succeded");
gb:message_on_time_offset("force_loss", 10000, "thanquol_dead_or_shattered");
gb:message_on_time_offset("force_loss", 10000, "skreech_dead_or_shattered");
gb:message_on_time_offset("force_loss", 10000, "player_army_defeated");
gb:message_on_time_offset("force_loss", 10000, "player_lost");

gb:add_listener(
	"force_loss",
	function()
		ga_ai_emp_main:get_alliance():force_battle_victory();
	end
);

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_emp_reinforcements_deliverance:message_on_shattered_proportion("enemy_is_shattered", 0.95);
ga_player:force_victory_on_message("enemy_is_shattered", 5000);
gb:message_on_time_offset("force_victory", 6000, "enemy_is_shattered");
gb:add_listener(
	"force_victory",
	function()
		ga_player:get_alliance():force_battle_victory();
	end
);