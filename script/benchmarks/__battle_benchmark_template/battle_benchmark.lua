load_script_libraries();
battle = battle_manager:new(empire_battle:new());

alliances = battle:alliances();
uc_army1 = unitcontroller_from_army(alliances:item(1):armies():item(1));
uc_army1:take_control();

uc_army2 = unitcontroller_from_army(alliances:item(2):armies():item(1));
uc_army2:take_control();

bool_benchmark_mode = false;

if battle:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;
battle:setup_battle(function() end_deployment_phase() end);

function end_deployment_phase()
	battle:out("Starting benchmark");

	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
end;

function play_cutscene_intro()
	cutscene_intro = cutscene:new(
		"cutscene_intro", 							-- unique string name for cutscene
		uc_army1,			 						-- unitcontroller over player's army
		22000, 										-- duration of cutscene in ms
		function() battle:end_benchmark() end 		-- what to call when cutscene is finished
	);

	cam = cutscene_intro:camera();
	cutscene_intro:set_skippable(false, nil);
	cutscene_intro:set_should_enable_cinematic_camera(false); -- prevents the camera from clipping the terrain
	
	
	
	if battle:is_siege_battle() then
		local offset = 400;
		local fort_position = battle:get_fort_position();
		local position = fort_position;
		position:set_y(fort_position:get_y() + 50);
		
		cutscene_intro:action(function() cam:move_to(v(offset + position:get_x(), position:get_y(), position:get_z()), position, 0) end, 0);
		cutscene_intro:action(function() cam:move_to(v(position:get_x(), position:get_y(), offset + position:get_z()), position, 1) end, 5000);
		cutscene_intro:action(function() cam:move_to(v(-offset + position:get_x(), position:get_y(), position:get_z()), position, 1) end, 10000);
		cutscene_intro:action(function() cam:move_to(v(position:get_x(), position:get_y(), -offset + position:get_z()), position, 1) end, 15000);
		cutscene_intro:action(function() cam:move_to(v(offset + position:get_x(), position:get_y(), position:get_z()), position, 1) end, 20000);
	else
		local height = battle:get_terrain_height(0, 0) + 50
		local position = v(0, height, 0);
		cutscene_intro:action(function() cam:move_to(position, v(1 + position:get_x(), position:get_y(), position:get_z()), 0) end, 0);
		cutscene_intro:action(function() cam:move_to(position, v(position:get_x(), position:get_y(), 1 + position:get_z()), 1) end, 5000);
		cutscene_intro:action(function() cam:move_to(position, v(-1 + position:get_x(), position:get_y(), position:get_z()), 1) end, 10000);
		cutscene_intro:action(function() cam:move_to(position, v(position:get_x(), position:get_y(), -1 + position:get_z()), 1) end, 15000);
		cutscene_intro:action(function() cam:move_to(position, v(1 + position:get_x(), position:get_y(), position:get_z()), 1) end, 20000);
	end;
	cutscene_intro:start();	
end;