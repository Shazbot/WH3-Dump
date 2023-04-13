

-- mute sounds for intro cutscene
bm:set_volume(VOLUME_TYPE_MUSIC, 0);
bm:set_volume(VOLUME_TYPE_SFX, 0);
bm:set_volume(VOLUME_TYPE_VO, 0);


cutscene_intro_length = 31500;

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

generals_speech_01 = new_sfx("play_wh2_intro_battle_def_1_1");
generals_speech_02 = new_sfx("play_wh2_intro_battle_def_2_1");
generals_speech_03 = new_sfx("play_wh2_intro_battle_def_3_1");

function play_cutscene_intro()
	
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	local cam_pos = cam:position();
	local cam_targ = cam:target();
	
	cutscene_intro:set_skip_camera(cam_pos, cam_targ);
	
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_start() end, 0);
	
	-- cutscene_intro:action(function() cam:fade(false, 0); bm:modify_battle_speed(0); end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(-377.5, 124.8, -185.6), v(-416.1, 116.8, -250.1), 0, false, 30) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-377.5, 124.8, -185.6), v(-416.1, 116.8, -250.1), 3, false, 32) end, 0);
	
	cutscene_intro:action(function() cam:fade(false, 1) end, 0);
	
	-- Vermin dare infest my capital? Skavenblight over-exerts itself.
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_def_1") end, 1500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_01) end, 1500);
	
	cutscene_intro:action(function() cam:move_to(v(-377.5, 127.8, -185.6), v(-416.1, 119.8, -250.1), 5, false, 32) end, 2500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, 7500);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 7500);
	
	-- I will not tolerate pests in Naggarond. The vermin will learn that my city, my realm, is a cold, cruel place.
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_def_2") end, 8000);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_02) end, 8000);
	
	cutscene_intro:action(function() cam:move_to(v(-393.3, 122.0, -249.7), v(-468.2, 111.7, -252.1), 0, true, 35) end, 8000);
	cutscene_intro:action(function() cam:move_to(v(-384.2, 121.8, -249.1), v(-459.1, 111.5, -251.8), 18, true, 35) end, 8000);
	
	cutscene_intro:action(function() teleport_and_move_player_general_cutscene_intro_mid() end, 11000);
	
	cutscene_intro:action(function() cam:move_to(v(-468.6, 119.3, -237.9), v(-394.4, 120.2, -252.9), 0, true, 30) end, 11000);
	cutscene_intro:action(function() cam:move_to(v(-468.6, 121.3, -237.9), v(-394.4, 122.2, -252.9), 5, true, 30) end, 11000);
	
	cutscene_intro:action(function() cam:move_to(v(-202.8, 115.8, -154.2), v(-272.4, 119.7, -183.6), 0, true, 30) end, 15500);
	cutscene_intro:action(function() cam:move_to(v(-202.8, 115.8, -154.2), v(-270.9, 122.3, -186.5), 5, true, 34) end, 15500);
		
	cutscene_intro:action(function() teleport_and_move_player_army_cutscene_intro_mid() end, 17500);
	
	cutscene_intro:action(function() cam:move_to(v(-200.7, 116.4, -146.5), v(-233.3, 116.1, -214.8), 0, true, 30) end, 17500);
	cutscene_intro:action(function() cam:move_to(v(-200.7, 116.4, -146.5), v(-228.2, 116.9, -216.9), 4, true, 30) end, 17500);
	
	cutscene_intro:action(function() bm:hide_subtitles() end, 19000);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 20000);
	
	-- Purge the city, my warriors, but ensure you leave some alive - I wish to know how loud a rat can scream.
	cutscene_intro:action(function() bm:show_subtitle("wh2_intro_battle_def_3") end, 20500);
	cutscene_intro:action(function() cutscene_intro:play_sound(generals_speech_03) end, 20500);
	
	cutscene_intro:action(function() cam:move_to(v(-219.1, 122.1, -236.6), v(-219.6, 122.0, -238.6), 0, true, 40) end, 20500);					
	
	cutscene_intro:action(function() cam:move_to(v(-225.8, 124.4, -273.5), v(-227.8, 124.2, -273.3), 0, true, 45) end, 23000);					
	cutscene_intro:action(function() cam:move_to(v(-214.9, 124.4, -274.7), v(-216.9, 124.2, -274.5), 8, true, 45) end, 23000);					
	
	cutscene_intro:action(function() cam:move_to(v(-216.3, 118.5, -156.0), v(-191.0, 114.9, -156.3), 0, true, 50) end, 26000);
	
	cutscene_intro:action(function() sunits_player_start_no_general:teleport_to_start_location() end, 27000);
	
	cutscene_intro:action(function() cam:move_to(cam_pos, cam_targ, 4, false, 0) end, 27500);
	
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
	cutscene_enemy_encounter:action(function() cam:move_to(v(201.3, 113.1, -204.6), v(265.4, 111.4, -249.5), 3, false, 0) end, 0);
	
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
	end
);

function play_cutscene_enemy_reinforcements()
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(434.2, 151.4, 714.6), v(396.4, 145.4, 779.6), 6, false, 0) end, 0);
	
	cutscene_enemy_reinforcements:action(
		function()
			sunits_enemy_start:kill(true);
		end, 
		1000
	);
	
	cutscene_enemy_reinforcements:action(function() play_enemy_reinforcements_advice() end, 3000);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(425.5, 142.1, 742.3), v(421.2, 141.9, 747.9), 0, false, 45) end, 8500);
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(377.3, 143.6, 744.4), v(373.0, 143.4, 750.0), 15, true, 45) end, 8500);
	
	-- teleport player's army if appropriate
	cutscene_enemy_reinforcements:action(function() reposition_phase_two_player_army_if_appropriate() end, 8500);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(444.0, 135.8, 749.1), v(440.5, 136.0, 755.0), 0, false, 25) end, 11000);
	
	cutscene_enemy_reinforcements:action(
		function()
			-- make general taunt
			sunit_enemy_10.uc:start_taunting();
		end, 
		11500
	);
	
	-- move to ridge
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(598.6, 170.0, 101.9), v(555.4, 158.8, 40.8), 4, false, 55) end, 14000);
	
	cutscene_enemy_reinforcements:action(function() play_ridge_advice() end, 16500);
	
	cutscene_enemy_reinforcements:action(function() cam:move_to(v(428.3, 161.0, 93.2), v(462.5, 149.8, 26.6), 20, true, 55) end, 19500);
	
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
cutscene_player_missile_reinforcements:set_restore_cam(1, v(830.4, 198.1, -409.8), v(775.7, 172.8, -367.4));
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

	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(744.2, 162.7, -402.0), v(801.4, 152.9, -354.0), 7, false, 0) end, 0);

	cutscene_player_missile_reinforcements:action(function() play_missile_reinforcements_advice() end, 2000);
	
	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(758.2, 157.8, -351.6), v(819.4, 151.8, -312.6), 0, false, 45) end, 10000);
	cutscene_player_missile_reinforcements:action(function() cam:move_to(v(759.1, 155.1, -339.7), v(820.2, 149.2, -300.6), 40, true, 45) end, 10000);
	
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
	NCI_Create_Character,									-- duration of cutscene in ms
	nil														-- what to call when cutscene is finished
);

-- cutscene_player_cavalry_reinforcements:set_debug();
cutscene_player_cavalry_reinforcements:set_restore_cam(1, v(715.9, 178.0, 292.4), v(664.8, 148.3, 231.7));
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

	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(704.5, 152.3, 274.7), v(653.0, 144.9, 207.8), 0, false, 40) end, 0);
	cutscene_player_cavalry_reinforcements:action(function() cam:fade(false, 0.5) end, 200);
	
	cutscene_player_cavalry_reinforcements:action(
		function() 
			play_cavalry_reinforcements_advice();
			
			local advice_finished_func = function()				
				cutscene_player_cavalry_reinforcements:show_esc_prompt();
			end;
			
			-- failsafe (remove this when VO goes in)
			bm:callback(function() advice_finished_func() end, 7000, "play_cutscene_cavalry_reinforcements");
		end, 
		3500
	);
	
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(691.2, 150.0, 274.8), 0, false, 45) end, 7000);
	cutscene_player_cavalry_reinforcements:action(function() cam:move_to(v(670.0, 164.3, 194.0), v(686.7, 149.2, 275.3), 5, false, 45) end, 7000);
	
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:wait_for_advisor() end, 10000);
	cutscene_player_cavalry_reinforcements:action(function() cutscene_player_cavalry_reinforcements:show_esc_prompt() end, 10000);
	
	cutscene_player_cavalry_reinforcements:start();
end;
