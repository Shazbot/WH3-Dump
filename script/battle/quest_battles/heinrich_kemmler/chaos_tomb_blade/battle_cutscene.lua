function Play_Intro()
	bm:out("Play_Intro() called");
	
	--Audio Hooks
	General_Speech = new_sfx("Play_VAMP_Kemm_GS_Qbattle_tomb_blade");
	POS_Cam_Cutscene_Intro_Final = v(-276.967316,133.536041,-584.04364);
	Targ_Cam_Cutscene_Intro_Final = v(-277.32135,106.466652,-502.899719);
	
	
	--Initialise Cutscene
	local Cutscene_Intro = cutscene:new(
		"Cutscene_Intro", 							-- unique string name for cutscene
		ga_player_01:get_unitcontroller(),			-- unitcontroller over player's army
		47000 										-- duration of cutscene in ms
	);	
	
	--Set Skipping
	Cutscene_Intro:set_skippable(true, function() Skip_Cutscene_Intro() end);
	Cutscene_Intro:set_skip_camera(POS_Cam_Cutscene_Intro_Final, Targ_Cam_Cutscene_Intro_Final);
	--Cutscene_Intro:set_debug();
	
	cam = Cutscene_Intro:camera();
	Cutscene_Intro:action(function() cam:fade(false, 1) end, 2000);
	Cutscene_Intro:action(function() play_sound(General_Speech) end, 6000);
	
	Army_Pan(Cutscene_Intro, ga_player_01, 10, 20, 0, 20);
	
	Cutscene_Intro:start();
end

function Skip_Cutscene_Intro()
	bm:out("Skip_Cutscene_Intro() called");
end

--[[

Camera Types

]]--

function Army_Pan(Cutscene_Intro, army, height, distance, start_time, shot_length)

	right_sunit, left_sunit = get_furthest_extents_units(army);
	
	
	camera_start_pos = v_add(
							v_add(
								left_sunit.unit:position(), 
								v_set_magnitude(deg_to_xy_vec(left_sunit.unit:bearing()), distance)
								), 
							v(0, height, 0)
							);
	camera_end_pos = v_add(
							v_add(
								right_sunit.unit:position(), 
								v_set_magnitude(deg_to_xy_vec(right_sunit.unit:bearing()), distance)
								), 
							v(0, height, 0)
							);
	camera_start_look = left_sunit.unit:position();
	camera_end_look = right_sunit.unit:position();

	Cutscene_Intro:action(function() cam:move_to(camera_start_pos, camera_start_look, 0, false, 65) end, 0);
	Cutscene_Intro:action(function() cam:move_to(camera_end_pos, camera_end_look, shot_length, false, 65) end, start_time);
end

function get_furthest_extents_units(army, is_debug)
	is_debug = is_debug or false;
	
	sunits = army.sunits;
	bm:out("get_furthest_extents_units() called");
	local army_direction = deg_to_xy_vec(army:get_first_scriptunit().unit:bearing());
	
	local best_match_sunit_right = nil;
	local best_match_sunit_left = nil;
	local furthest_right = -100000; -- positive
	local furthest_left = 100000; -- negative
	
	for i = 1, sunits:count() do
		current_sunit = sunits:item(i);
		current_pos = current_sunit.unit:position();
		distance = distance_to_line(army_direction, v_set_magnitude(army_direction, -1), current_pos);
		
		bm:out("get_furthest_extents_units() testing unit " .. tostring(current_sunit));
		bm:out("get_furthest_extents_units() distance " .. tostring(distance));
		
		if distance > furthest_right then
			bm:out("get_furthest_extents_units() setting right");
			furthest_right = distance;
			best_match_sunit_right = current_sunit;
		end
		
		if distance < furthest_left then
			bm:out("get_furthest_extents_units() setting left");
			furthest_left = distance;
			best_match_sunit_left = current_sunit;
		end;
	end;
	
	bm:out("get_furthest_extents_units() furthest units are " .. tostring(best_match_sunit_right) .. "(" .. furthest_right .. ") and " .. tostring(best_match_sunit_left) .. "(" .. furthest_left .. ")");
	return best_match_sunit_right, best_match_sunit_left;
end