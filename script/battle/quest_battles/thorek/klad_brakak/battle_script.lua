-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Thorek
-- Klad Brakak
-- Lzd_plains_infield_a / Catchment_07
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\klad.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

--Intro Thorek's Speech
wh2_main_sfx_01 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_01"); --7000
wh2_main_sfx_02 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_02"); --8000
wh2_main_sfx_03 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_03"); --9000
wh2_main_sfx_04 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_04"); --6000
wh2_main_sfx_05 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_05"); --6000

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--reinforcements
ga_dwfally = gb:get_army(gb:get_player_alliance_num(),"ally_dwf");

--friendly faction
ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_lzdally = gb:get_army(gb:get_player_alliance_num(),"ally_lzd");

--enemy faction
ga_empenemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_emp");
ga_lzdenemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_lzd");

--defining bosses in script
bigone_sunit = ga_lzdenemy.sunits:get_sunit_by_type("wh2_dlc17_lzd_mon_dread_saurian_qb_boss");
jorek_sunit = ga_empenemy.sunits:get_sunit_by_type("wh2_dlc13_emp_cha_hunter_jorek_grimm_0");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
	ga_playerarmy.sunits:item(1).uc:teleport_to_location(v(-214, 287), 90, 1);
	bigone_sunit.uc:teleport_to_location(v(144, 550), 180, 1);
	jorek_sunit.uc:teleport_to_location(v(-173, 285), 280, 1);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_playerarmy.sunits,					-- unitcontroller over player's army
		49000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;

	-- set up subtitles
	
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(2.0, 2000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_playerarmy:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\klad.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_playerarmy:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles -- 
	--VO LENGTHS: 7, 8, 9, 6, 6
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_02", "subtitle_with_frame", 0.1, true) end, 11000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 21000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_03", "subtitle_with_frame", 0.1, true) end, 21000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 32000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_04", "subtitle_with_frame", 0.1, true) end, 32000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 39000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 40000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_klad_brakak_pt_05", "subtitle_with_frame", 0.1, true) end, 40000);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 47000);

	cutscene_intro:start();
	
end;
function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_playerarmy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_playerarmy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_empenemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_empenemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_lzdally:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_lzdally:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_lzdenemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_lzdenemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_lzdenemy:add_winds_of_magic_on_message("deployment_started", -50)
ga_lzdally:add_winds_of_magic_on_message("deployment_started", -50)
ga_empenemy:add_winds_of_magic_on_message("deployment_started", -50)

ga_lzdenemy:add_winds_of_magic_on_message("01_intro_cutscene_end", 50)
ga_lzdally:add_winds_of_magic_on_message("01_intro_cutscene_end", 50)
ga_empenemy:add_winds_of_magic_on_message("01_intro_cutscene_end", 50)

gb:message_on_time_offset("reinforce", 25000,"01_intro_cutscene_end");
--gb:message_on_time_offset("the_beast", 60000,"01_intro_cutscene_end");

--Objective Markers
gb:add_listener("01_intro_cutscene_end", function() ping() end);
function ping()
	bigone_sunit:add_ping_icon(15)
	jorek_sunit:add_ping_icon(15)
	bm:out(">>>PINGGG<<<")
end



	-------THIS IS TO FIND THE RIGHT PING ICON -------
--[[
ga_playerarmy:add_ping_icon(10, 1)
ga_playerarmy:add_ping_icon(11, 2)
ga_playerarmy:add_ping_icon(12, 3)
ga_playerarmy:add_ping_icon(13, 4)
ga_playerarmy:add_ping_icon(14, 5)
ga_playerarmy:add_ping_icon(15, 6)
ga_playerarmy:add_ping_icon(16, 7)
ga_playerarmy:add_ping_icon(8, 8)
ga_playerarmy:add_ping_icon(9, 9)
]]

--start the fighting
ga_playerarmy:release_on_message("01_intro_cutscene_end");
ga_lzdally:release_on_message("01_intro_cutscene_end");
ga_empenemy:release_on_message("01_intro_cutscene_end");
ga_lzdenemy:release_on_message("01_intro_cutscene_end");

ga_dwfally:reinforce_on_message("reinforce", 1000);
ga_dwfally:release_on_message("reinforcement_release");
gb:message_on_time_offset("reinforcement_release", 2000,"reinforce");

--objective listener messages
ga_playerarmy:message_on_commander_death("thorek_dead", 1);

if bigone_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(bigone_sunit)
		end,
		0,
		function()
			bm:out("*** bigone is shattered or dead! ***");
			gb.sm:trigger_message("bigone_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	);
end;

if jorek_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(jorek_sunit)
		end,
		0,
		function()
			bm:out("*** jorek is shattered or dead! ***");
			gb.sm:trigger_message("jorek_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	);
end;


--subtitles
gb:queue_help_on_message("thorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_03", 6000, nil, 5000);
gb:queue_help_on_message("jorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_01", 6000, nil, 5000);
gb:queue_help_on_message("bigone_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_02", 6000, nil, 5000);
gb:queue_help_on_message("reinforcement_release", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_04", 6000, nil, 5000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_05", 6000, nil, 5000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_06", 6000, nil, 240000, 5000);
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_02");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03");

gb:complete_objective_on_message("jorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_01", 5);
gb:complete_objective_on_message("bigone_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_02", 5);
gb:fail_objective_on_message("thorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03", 5);

--objective locators
gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_01",
    5000,
    function()
        local sunit = jorek_sunit;  -- Where is says "get_general_sunit()" replace with item(number) i.e. item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_02",
    5000,
    function()
        local sunit = bigone_sunit;  -- Where is says "get_general_sunit()" replace with item(number) i.e. item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03",
    5000,
    function()
        local sunit = ga_playerarmy.sunits:item(1);  -- Where is says "get_general_sunit()" replace with item(number) i.e. item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_all_messages_received("mission_complete", "bigone_dead", "jorek_dead");

ga_lzdenemy:force_victory_on_message("thorek_dead", 10000); 
ga_playerarmy:force_victory_on_message("mission_complete", 12000); 