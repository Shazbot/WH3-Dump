

-- mute sounds for intro cutscene
bm:set_volume(VOLUME_TYPE_MUSIC, 0);
bm:set_volume(VOLUME_TYPE_SFX, 0);
bm:set_volume(VOLUME_TYPE_VO, 0);


cutscene_intro_length = 40000;

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

generals_speech_01 = new_sfx("play_wh2_intro_battle_hef_1_1");
generals_speech_02 = new_sfx("play_wh2_intro_battle_hef_2_1");
generals_speech_03 = new_sfx("play_wh2_intro_battle_hef_3_1");
generals_speech_04 = new_sfx("play_wh2_intro_battle_hef_4_1");

function play_cutscene_intro()
	
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	local cam_pos = cam:position();
	local cam_targ = cam:target();
	
	cutscene_intro:set_skip_camera(cam_pos, cam_targ);
	
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_start() end, 0);
	
	cutscene_intro:action(function() cam:fade(false, 1) end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(-348.7, 122.7, -261.6), v(-929.4, 527.1, -541.5), 0, false, 50) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-348.7, 122.7, -261.6), v(-1032.1, 216.5, -583.0), 7.5, false, 50) end, 0);
	
	-- Fellow Asur, hear my words! Yet again the Druchii come at us, a never-ending tide of war.
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_hef_1") end, 1500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_01) end, 1500);
	
	cutscene_intro:action(function() cam:move_to(v(-363.4, 122.3, -256.7), v(-330.2, 172.1, -1015.4), 0, false, 20) end, 7500);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 11000);
	cutscene_intro:action(function() bm:hide_subtitles() end, 11000);
	
	-- But Ulthuan’s cliffs are strong! Its shores refuse to be washed away by the waves of our hated kin.
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_hef_2") end, 11500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_02) end, 11500);
	
	cutscene_intro:action(function() cam:move_to(v(-382.4, 124.7, -264.9), v(377.5, 112.5, -304.2), 0, false, 40) end, 11500);
	cutscene_intro:action(function() cam:move_to(v(-382.4, 124.7, -264.9), v(377.3, 155.5, -298.7), 4, false, 39) end, 11500);
	
	cutscene_intro:action(function() cam:move_to(v(-619.3, 141.0, -121.9), v(92.7, 79.6, -383.6), 0, false, 35) end, 14500);
	cutscene_intro:action(function() cam:move_to(v(-619.3, 141.0, -121.9), v(103.5, 110.4, -358.2), 4, false, 35) end, 14500);
	
	cutscene_intro:action(function() cam:move_to(v(-404.9, 123.8, -279.4), v(-400.9, 124.1, -277.7), 0, false, 43) end, 17500);
	cutscene_intro:action(function() cam:move_to(v(-404.9, 123.8, -279.4), v(-400.9, 124.2, -277.9), 4, false, 43) end, 17500);
	
	cutscene_intro:action(function() teleport_and_move_player_general_cutscene_intro_mid() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 21000);
	cutscene_intro:action(function() bm:hide_subtitles() end, 21000);
	
	-- Today we must guard Lothern’s sea walls – let the Druchii torrent come!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_hef_3") end, 21500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_03) end, 21500);
	
	cutscene_intro:action(function() cam:move_to(v(-206.7, 127.1, -156.1), v(-274.7, 128.8, -189.0), 0, false, 30) end, 21500);
	cutscene_intro:action(function() cam:move_to(v(-206.7, 127.1, -156.1), v(-275.0, 128.2, -190.4), 4, false, 31) end, 21500);
		
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_mid() end, 21500);
	
	cutscene_intro:action(function() cam:move_to(v(-204.0, 126.8, -151.8), v(-232.4, 125.3, -221.9), 0, false, 35) end, 25500);
	cutscene_intro:action(function() cam:move_to(v(-204.0, 126.8, -151.8), v(-225.6, 122.3, -224.5), 8, false, 33) end, 25500);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 28000);
	cutscene_intro:action(function() bm:hide_subtitles() end, 28000);
	
	-- Their waves will break upon us! Turn back the flood! For Ulthuan, for the Phoenix King, for Asuryan!
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_hef_4") end, 28500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_04) end, 28500);
	
	cutscene_intro:action(function() cam:move_to(v(-200.1, 121.7, -261.6), v(-276.8, 129.4, -266.6), 0, false, 40) end, 28500);
	cutscene_intro:action(function() cam:move_to(v(-198.1, 121.3, -261.4), v(-274.8, 129.1, -266.5), 30, true, 43) end, 28500);
	
	cutscene_intro:action(function() cam:move_to(v(-242.8, 125.8, -222.3), v(-188.5, 110.9, -275.2), 0, false, 50) end, 31000);
	cutscene_intro:action(function() cam:move_to(v(-242.8, 125.8, -222.3), v(-179.7, 117.6, -266.2), 5, false, 52) end, 31000);
	
	cutscene_intro:action(function() cam:move_to(v(-215.6, 129.9, -159.6), v(-143.0, 110.5, -151.3), 0, false, 0) end, 35000);
	
	cutscene_intro:action(function() sunits_player_start_no_general:teleport_to_start_location() end, 35000);
	
	cutscene_intro:action(function() cam:move_to(cam_pos, cam_targ, 4, false, 0) end, 36000);
	
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

cam_transition_to_army_selection_advice = v(-245.4, 147.3, -243.3);
targ_transition_to_army_selection_advice = v(197.8, 35.2, -280.3);


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
-- cutscene_transition_to_army_selection_advice:set_debug(true);


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
	cutscene_enemy_encounter:action(function() cam:move_to(v(217.4, 123.1, -244.9), v(283.6, 115.4, -281.4), 3, false, 0) end, 0);
	
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
		
		teleport_enemy_reinforcements_forward();
		
		-- bm:callback(function() cam:fade(false, 0.5) end, 500);
	end
);

function play_cutscene_enemy_reinforcements()
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(392.5, 148.4, 715.4), v(357.6, 152.0, 782.1), 6, false, 0) end, 0);
	
	cutscene_enemy_reinforcements:action(
		function()
			sunits_enemy_start:kill(true);
		end, 
		1000
	);
	
	cutscene_enemy_reinforcements:action(function() play_enemy_reinforcements_advice() end, 3000);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(383.4, 145.9, 731.4), v(379.1, 145.7, 736.9), 0, false, 45) end, 8500);
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(361.0, 145.9, 734.4), v(356.7, 145.7, 740.0), 20, true, 45) end, 8500);
	
	-- teleport player's army if appropriate
	cutscene_enemy_reinforcements:action(function() reposition_phase_two_player_army_if_appropriate() end, 8500);
	
	cutscene_enemy_reinforcements:action(
		function()			
			cam:move_to(v(378.9, 142.2, 753.8), v(375.0, 141.6, 759.4), 0, false, 40);
			
			-- make general taunt
			sunit_enemy_10.uc:start_taunting();
		end, 
		11500
	);
	
	-- move to ridge
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(605.4, 203.5, 173.6), v(583.6, 185.1, 103.6), 4, false, 55) end, 14000);
	
	cutscene_enemy_reinforcements:action(function() play_ridge_advice()	end, 16500);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(418.7, 181.0, 43.5), v(450.4, 162.1, -22.6), 20, true, 55) end, 19500);
	
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
cutscene_player_missile_reinforcements:set_restore_cam(1, v(800.0, 169.0, -386.0), v(745.2, 146.1, -344.1));
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

	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(681.8, 163.5, -378.6), v(749.5, 148.6, -356.2), 7, false, 0) end, 0);

	cutscene_player_missile_reinforcements:action(function() play_missile_reinforcements_advice() end, 2000);
	
	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(758.6, 139.2, -331.0), v(827.3, 130.2, -309.1), 0, false, 45) end, 10000);
	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(758.3, 144.6, -304.9), v(827.0, 135.6, -283.0), 90, true, 45) end, 10000);
	
	cutscene_player_missile_reinforcements:action(function() cutscene_player_missile_reinforcements:wait_for_advisor() end, 12000);
	cutscene_player_missile_reinforcements:action(function() cutscene_player_missile_reinforcements:show_esc_prompt() end, 12000);
	
	cutscene_player_missile_reinforcements:start();
end;
















-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--
-- PLAYER CAVALRY REINFORCEMENTS
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

	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(703.5, 158.9, 274.7), v(652.0, 151.5, 207.8), 0, false, 40) end, 0);
	cutscene_player_cavalry_reinforcements:action(function() cam:fade(false, 0.5) end, 200);
	
	cutscene_player_cavalry_reinforcements:action(function() play_cavalry_reinforcements_advice() end, 3500);
	
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(691.2, 150.0, 274.8), 0, false, 45) end, 7000);
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(686.7, 149.2, 275.3), 5, false, 45) end, 7000);
	
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:wait_for_advisor() end, 10000);
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:show_esc_prompt() end, 10000);
	
	cutscene_player_cavalry_reinforcements:start();
end;
