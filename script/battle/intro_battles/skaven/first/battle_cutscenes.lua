

-- mute sounds for intro cutscene
bm:set_volume(VOLUME_TYPE_MUSIC, 0);
bm:set_volume(VOLUME_TYPE_SFX, 0);
bm:set_volume(VOLUME_TYPE_VO, 0);


cutscene_intro_length = 42500;

cutscene_intro = cutscene:new(
	"cutscene_intro", 						-- unique string name for cutscene
	sunits_player_start, 					-- unitcontroller over player's army
	cutscene_intro_length,					-- duration of cutscene in ms
	function() 								-- what to call when cutscene is finished
		start_battle();
	end
);

cutscene_intro:set_skippable(true, function() skip_cutscene_intro() end);
-- cutscene_intro:set_debug(true);

generals_speech_01 = new_sfx("play_wh2_intro_battle_skv_1_1");
generals_speech_02 = new_sfx("play_wh2_intro_battle_skv_2_1");
generals_speech_03 = new_sfx("play_wh2_intro_battle_skv_3_1");
generals_speech_04 = new_sfx("play_wh2_intro_battle_skv_4_1");

function play_cutscene_intro()
	
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	local cam_pos = cam:position();
	local cam_targ = cam:target();
	
	cutscene_intro:set_skip_camera(cam_pos, cam_targ);
	
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_start() end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(-471.4, 135.5, -224.8), v(-513.2, 167.5, -279.1), 0, false, 40) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-468.0, 122.0, -223.6), v(-509.6, 121.9, -286.7), 12, false, 30) end, 0);
	
	cutscene_intro:action(function() cam:fade(false, 1) end, 0);
	
	-- Why-why Gnawdwell, send Queek down to this backwater? To make fool of Queek, yes-yes?!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_skv_1") end, 1500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_01) end, 1500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, 12500);
	
	-- I not fail here – I make Clan Mors great in south, make Clanrats chirp my name! Make lands mine-mine!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_skv_2") end, 13000);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_02) end, 13000);
	
	cutscene_intro:action(function() cam:move_to(v(-458.9, 124.6, -275.9), v(-533.4, 114.9, -284.0), 0, false, 35) end, 13000);
	cutscene_intro:action(function() cam:move_to(v(-458.5, 124.6, -279.9), v(-533.0, 114.9, -288.0), 8, true, 35) end, 13000);
	
	cutscene_intro:action(function() cam:move_to(v(-484.6, 121.1, -285.1), v(-559.0, 107.6, -285.2), 0, false, 27) end, 16500);
	cutscene_intro:action(function() cam:move_to(v(-484.6, 121.1, -285.1), v(-559.0, 107.6, -285.2), 6, true, 29) end, 16500);
	
	cutscene_intro:action(function() cam:move_to(v(-548.1, 116.7, -274.7), v(-473.5, 119.6, -286.8), 0, false, 30) end, 20000);
	cutscene_intro:action(function() cam:move_to(v(-548.1, 119.0, -274.7), v(-473.5, 121.9, -286.8), 10, true, 30) end, 20000);
	
	cutscene_intro:action(function() teleport_and_move_player_general_cutscene_intro_mid() end, 25500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, 26500);
	
	-- Start by killing Elf-things! I want them dead-dead!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_skv_3") end, 27500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_03) end, 27500);
	
	cutscene_intro:action(function() cam:move_to(v(-195.9, 127.1, -160.3), v(-271.6, 122.2, -171.3), 0, false, 12) end, 27500);
	cutscene_intro:action(function() cam:move_to(v(-195.9, 126.6, -160.3), v(-271.3, 121.9, -172.9), 5, true, 14) end, 27500);
	
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_mid() end, 27500);
	
	cutscene_intro:action(function() cam:move_to(v(-203.2, 126.9, -152.7), v(-237.2, 119.5, -221.0), 0, false, 25) end, 31000);
	cutscene_intro:action(function() cam:move_to(v(-203.2, 126.9, -152.7), v(-233.7, 119.3, -222.6), 8, true, 25) end, 31000);
	
	cutscene_intro:action(function() cam:move_to(v(-199.3, 123.5, -246.8), v(-269.9, 121.2, -276.4), 0, false, 22) end, 34500);
	cutscene_intro:action(function() cam:move_to(v(-192.8, 123.5, -244.1), v(-263.5, 121.2, -273.7), 12, false, 23) end, 34500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, 34500);
	
	-- Go-go! Kill! Do not fail me-me!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_skv_4") end, 35500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_04) end, 35500);
	
	cutscene_intro:action(function() cam:move_to(v(-221.9, 130.3, -162.4), v(-147.2, 113.6, -166.6), 0, false, 50) end, 37000);
	
	cutscene_intro:action(function() sunits_player_start_no_general:teleport_to_start_location() end, 37000);
	
	cutscene_intro:action(function() cam:move_to(cam_pos, cam_targ, 4, false, 0) end, 38500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, cutscene_intro_length);
	
	cutscene_intro:start();
end;

function skip_cutscene_intro()
	sunits_player_start:teleport_to_start_location()
	
	bm:hide_subtitles();
end;















-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- TRANSITION TO ARMY SELECTION
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

bool_cutscene_transition_to_army_selection_advice_skipped = false;
cutscene_transition_to_army_selection_advice_length = 6000;

cutscene_transition_to_army_selection_advice = cutscene:new(
	"cutscene_transition_to_army_selection_advice", 				-- unique string name for cutscene
	sunits_player_start_no_general, 								-- unitcontroller over player's army
	cutscene_transition_to_army_selection_advice_length,			-- duration of cutscene in ms
	function() wait_before_start_army_selection_advice() end		-- what to call when cutscene is finished
);

cam_transition_to_army_selection_advice = v(-248.5, 149.6, -218.4);
targ_transition_to_army_selection_advice = v(-173.3, 129.5, -225.2);


cutscene_transition_to_army_selection_advice:set_skippable(
	true,
	function()
		bool_cutscene_transition_to_army_selection_advice_skipped = true;
	
		cam:fade(true, 0);
		
		-- teleport player's general
		move_lord_to_army(true);
		
		bm:callback(function() cam:fade(false, 0.5) end, 500);
	end
);
cutscene_transition_to_army_selection_advice:set_skip_camera(cam_transition_to_army_selection_advice, targ_transition_to_army_selection_advice);
cutscene_transition_to_army_selection_advice:set_close_advisor_on_start(false);
cutscene_transition_to_army_selection_advice:set_close_advisor_on_end(false);
cutscene_transition_to_army_selection_advice:set_should_release_players_army(false);
cutscene_transition_to_army_selection_advice:set_should_disable_unit_ids(false);
cutscene_transition_to_army_selection_advice:set_should_enable_cinematic_camera(false);


function play_cutscene_transition_to_army_selection_advice()
	cutscene_transition_to_army_selection_advice:action(
		function() 
			cam:move_to(cam_transition_to_army_selection_advice, targ_transition_to_army_selection_advice, (cutscene_transition_to_army_selection_advice_length / 1000) - 1.5, false, 0);
		end, 
		0
	);
	
	cutscene_transition_to_army_selection_advice:start();
end;








-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- ENEMY ENCOUNTER
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

cutscene_enemy_encounter_length = 8000;

cutscene_enemy_encounter = cutscene:new(
	"cutscene_enemy_encounter", 			-- unique string name for cutscene
	sunits_player_start, 					-- unitcontroller over player's army
	cutscene_enemy_encounter_length,		-- duration of cutscene in ms
	nil										-- what to call when cutscene is finished
);

cutscene_enemy_encounter:set_restore_cam(1);
cutscene_enemy_encounter:set_close_advisor_on_start(false);
cutscene_enemy_encounter:set_close_advisor_on_end(false);
cutscene_enemy_encounter:set_should_disable_unit_ids(false);
cutscene_enemy_encounter:set_should_enable_cinematic_camera(false);

function play_cutscene_enemy_encounter()
	cutscene_enemy_encounter:action(function() cam:move_to(v(199.9, 121.3, -224.5), v(555.2, 48.7, -493.5), 3, false, 0) end, 0);
	
	cutscene_enemy_encounter:action(
		function()
			local sunit = sunit_enemy_01;
			local unit = sunit.unit;
			-- local pos_officer = v_offset(unit:position_of_officer(), 0, 1.2, 0);
			local pos_officer = v_offset(unit:position(), 0, 1.2, 0);
		
			local h_camera_bearing_start = 20;
			local h_camera_bearing_end = 10;
			local v_camera_bearing_start = 5;
			local v_camera_bearing_end = 5;
			local camera_distance = 6;
			
			local camera_pos_start = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_start, v_camera_bearing_start, camera_distance);
			local camera_pos_end = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_end, v_camera_bearing_end, camera_distance);
			
			cam:move_to(camera_pos_start, pos_officer, 0, false, 40);
			cam:move_to(camera_pos_end, pos_officer, 4, true, 40);
			
			-- make general taunt
			sunit.uc:start_taunting();
		end, 
		4500
	);
	
	cutscene_enemy_encounter:start();
end;





























-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- ENEMY REINFORCEMENTS
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


cutscene_enemy_reinforcements = cutscene:new(
	"cutscene_enemy_reinforcements", 			-- unique string name for cutscene
	sunits_player_start, 						-- unitcontroller over player's army
	nil,										-- duration of cutscene in ms
	function() start_phase_two() end			-- what to call when cutscene is finished
);

-- cutscene_enemy_reinforcements:set_debug();
cutscene_enemy_reinforcements:set_restore_cam(2);
cutscene_enemy_reinforcements:set_close_advisor_on_start(false);
cutscene_enemy_reinforcements:set_post_cutscene_fade_time(0);
cutscene_enemy_reinforcements:set_should_disable_unit_ids(false);
cutscene_enemy_reinforcements:set_skippable(
	true,
	function()	
		bm:remove_process("play_cutscene_enemy_reinforcements");
		core:remove_listener("play_cutscene_enemy_reinforcements");
		sunits_enemy_start:kill(true);
		sunits_player_start:halt();
		reposition_phase_two_player_army_if_appropriate();
		
		-- bm:callback(function() cam:fade(false, 0.5) end, 500);
	end
);

function play_cutscene_enemy_reinforcements()
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(443.4, 148.6, 727.4), v(431.5, 146.5, 743.3), 6, false, 50) end, 0);
	
	cutscene_enemy_reinforcements:action(
		function()
			sunits_enemy_start:kill(true);
		end, 
		1000
	);
	
	cutscene_enemy_reinforcements:action(function() play_enemy_reinforcements_advice() end, 3000);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(393.3, 148.6, 730.2), v(381.9, 146.5, 746.1), 12, false, 50) end, 8500);
	
	-- teleport player's army if appropriate
	cutscene_enemy_reinforcements:action(function() reposition_phase_two_player_army_if_appropriate() end, 8500);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(440.5, 141.5, 754.7), v(429.1, 139.7, 771.0), 0, false, 45) end, 12500);
	
	-- move to ridge
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(605.4, 203.5, 173.6), v(583.6, 185.1, 103.6), 4, false, 55) end, 15000);
	
	cutscene_enemy_reinforcements:action(function() play_ridge_advice()	end, 17500);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(411.5, 181.0, 90.3), v(441.6, 159.5, 24.2), 20, true, 55) end, 20500);
	
	cutscene_enemy_reinforcements:action(function() cutscene_enemy_reinforcements:show_esc_prompt() end, cutscene_enemy_reinforcements_length);
	
	cutscene_enemy_reinforcements:start();
end;










-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- PLAYER MISSILE REINFORCEMENTS
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

cutscene_player_missile_reinforcements = cutscene:new(
	"cutscene_player_missile_reinforcements", 				-- unique string name for cutscene
	sunits_player_start_and_missile, 						-- unitcontroller over player's army
	nil,													-- duration of cutscene in ms
	nil														-- what to call when cutscene is finished
);

-- cutscene_player_missile_reinforcements:set_debug();
cutscene_player_missile_reinforcements:set_restore_cam(1, v(820.4, 189.7, -395.6), v(813.1, 186.6, -389.4));
cutscene_player_missile_reinforcements:set_close_advisor_on_end(false);
cutscene_player_missile_reinforcements:set_post_cutscene_fade_time(0);
cutscene_player_missile_reinforcements:set_should_disable_unit_ids(false);
cutscene_player_missile_reinforcements:set_should_enable_cinematic_camera(false);
cutscene_player_missile_reinforcements:set_skippable(
	true,
	function()	
		bm:remove_process("play_cutscene_missile_reinforcements");
		core:remove_listener("play_cutscene_missile_reinforcements");
		cutscene_player_missile_complete();
	end
);

function play_cutscene_player_missile_reinforcements()

	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(695.5, 185.1, -371.3), v(703.0, 181.8, -365.6), 7, false, 50) end, 0);

	cutscene_player_missile_reinforcements:action(function() play_missile_reinforcements_advice() end, 2000);
	
	cutscene_player_missile_reinforcements:action(
		function()			
			cam:move_to(v(745.0, 157.2, -304.4), v(755.0, 156.6, -304.1), 0, false, 26);
			cam:move_to(v(744.3, 156.9, -276.4), v(754.3, 156.2, -276.1), 120, true, 26);
		end, 
		10000
	);
	
	cutscene_player_missile_reinforcements:action(function() cutscene_player_missile_reinforcements:wait_for_advisor() end, 12000);
	cutscene_player_missile_reinforcements:action(function() cutscene_player_missile_reinforcements:show_esc_prompt() end, 12000);
	
	cutscene_player_missile_reinforcements:start();
end;
















-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- PLAYER OGRE REINFORCEMENTS
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


cutscene_player_cavalry_reinforcements = cutscene:new(
	"cutscene_player_cavalry_reinforcements", 				-- unique string name for cutscene
	sunits_player_start, 									-- unitcontroller over player's army
	nil,													-- duration of cutscene in ms
	nil														-- what to call when cutscene is finished
);

-- cutscene_player_cavalry_reinforcements:set_debug();
cutscene_player_cavalry_reinforcements:set_restore_cam(1, v(705.6, 178.2, 271.5), v(655.1, 149.7, 209.7));
cutscene_player_cavalry_reinforcements:set_close_advisor_on_end(false);
cutscene_player_cavalry_reinforcements:set_post_cutscene_fade_time(0);
cutscene_player_cavalry_reinforcements:set_should_disable_unit_ids(false);
cutscene_player_cavalry_reinforcements:set_skippable(
	true,
	function()	
		bm:remove_process("play_cutscene_cavalry_reinforcements");
		core:remove_listener("play_cutscene_cavalry_reinforcements");
		cutscene_player_cavalry_complete();
	end
);

function play_cutscene_player_cavalry_reinforcements()

	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(704.5, 159.2, 274.7), v(653.0, 151.3, 207.8), 0, false, 40) end, 0);
	cutscene_player_cavalry_reinforcements:action(function() cam:fade(false, 0.5) end, 200);
	
	cutscene_player_cavalry_reinforcements:action(function() play_cavalry_reinforcements_advice() end, 3500);
	
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(691.2, 150.0, 274.8), 0, false, 45) end, 7000);
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(686.7, 149.2, 275.3), 5, false, 45) end, 7000);
	
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:wait_for_advisor() end, 10000);
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:show_esc_prompt() end, 10000);
	
	cutscene_player_cavalry_reinforcements:start();
end;
