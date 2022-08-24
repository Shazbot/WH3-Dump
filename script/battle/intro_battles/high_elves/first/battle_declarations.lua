cam = bm:camera();
alliances = bm:alliances();

bm:suppress_unit_voices(true);


--
-- Player setup
--

alliance_player = alliances:item(1);
army_player_01 = alliance_player:armies():item(1);
-- army_player_02 = alliance_player:armies():item(2);


sunit_player_01 = script_unit:new_by_reference(army_player_01, "player_01");
sunit_player_02 = script_unit:new_by_reference(army_player_01, "player_02");
sunit_player_03 = script_unit:new_by_reference(army_player_01, "player_03");
sunit_player_04 = script_unit:new_by_reference(army_player_01, "player_04");

-- missile reinforcements
sunit_player_10 = script_unit:new_by_reference(army_player_01, "player_10");
sunit_player_11 = script_unit:new_by_reference(army_player_01, "player_11");
sunit_player_12 = script_unit:new_by_reference(army_player_01, "player_12");
sunit_player_13 = script_unit:new_by_reference(army_player_01, "player_13");

-- cavalry reinforcements
sunit_player_20 = script_unit:new_by_reference(army_player_01, "player_20");
sunit_player_21 = script_unit:new_by_reference(army_player_01, "player_21");

uc_player_01_all = unitcontroller_from_army(army_player_01);
--uc_player_01_all:take_control();


sunits_player_general = script_units:new(
	"player_general",
	sunit_player_01
);

sunits_player_start = script_units:new(
	"player_start",
	sunit_player_01,
	sunit_player_02,
	sunit_player_03,
	sunit_player_04
);

sunits_player_start_no_general = script_units:new(
	"player_start_no_general",
	sunit_player_02,
	sunit_player_03,
	sunit_player_04
);

sunits_player_all = script_units:new(
	"player_all",
	sunit_player_01,
	sunit_player_02,
	sunit_player_03,
	sunit_player_04,
	sunit_player_10,
	sunit_player_11,
	sunit_player_12,
	sunit_player_13,
	sunit_player_20,
	sunit_player_21
);

sunits_player_start_and_missile = script_units:new(
	"player_start_and_missile",
	sunit_player_01,
	sunit_player_02,
	sunit_player_03,
	sunit_player_04,
	sunit_player_10,
	sunit_player_11,
	sunit_player_12,
	sunit_player_13
);

sunits_player_missile_reinforcements = script_units:new(
	"player_missile_reinforcements",
	sunit_player_10,
	sunit_player_11,
	sunit_player_12,
	sunit_player_13
);

sunits_player_missile_reinforcements:deploy_reinforcement(false);

sunits_player_missile_reinforcements_missiles_only = script_units:new(
	"player_missile_reinforcements_missiles_only",
	sunit_player_12,
	sunit_player_13
);

sunits_player_missile_reinforcements_melee_only = script_units:new(
	"player_missile_reinforcements_melee_only",
	sunit_player_10,
	sunit_player_11
);


sunits_player_cavalry_reinforcements = script_units:new(
	"player_cavalry_reinforcements",
	sunit_player_20,
	sunit_player_21
);

sunits_player_cavalry_reinforcements:set_enabled(false);



local pos_intro_start_dest = v(-327.0, -264.0);

sunit_player_02.pos_intro_start = v(-364.5, -266.4);
sunit_player_02.orient_intro_start = r_to_d(1.52);
sunit_player_02.width_intro_start = 12.2;
sunit_player_02.pos_intro_start_dest = pos_intro_start_dest;

do 
	local sunit_player_03_initial_men = sunit_player_03.unit:initial_number_of_men();
	
	if sunit_player_03_initial_men < 32 then
		-- small unit size
		sunit_player_03.pos_intro_start = v(-374.5, -266.4);
		sunit_player_04.pos_intro_start = v(-384.5, -266.4);
		
	elseif sunit_player_03_initial_men < 62 then
		-- medium unit size
		sunit_player_03.pos_intro_start = v(-378.5, -266.4);		
		sunit_player_04.pos_intro_start = v(-392.5, -266.4);
		
	elseif sunit_player_03_initial_men < 92 then
		-- large unit size
		sunit_player_03.pos_intro_start = v(-386.8, -269.1);		
		sunit_player_04.pos_intro_start = v(-409.9, -270.9);
		
	else
		-- ultra unit size
		sunit_player_03.pos_intro_start = v(-389.6, -268.1);		
		sunit_player_04.pos_intro_start = v(-414.0, -270.0);
		
	end;
	
	sunit_player_03.orient_intro_start = r_to_d(1.53);
	sunit_player_03.width_intro_start = 11.8;
	
	sunit_player_04.orient_intro_start = r_to_d(1.53);
	sunit_player_04.width_intro_start = 11.7;
	
	sunit_player_03.pos_intro_start_dest = pos_intro_start_dest;
	sunit_player_04.pos_intro_start_dest = pos_intro_start_dest;

end;




function teleport_and_move_player_army_cutscene_intro_start()
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		
		if current_sunit.pos_intro_start then
			current_sunit.uc:teleport_to_location(current_sunit.pos_intro_start, current_sunit.orient_intro_start, current_sunit.width_intro_start);
			
			if current_sunit.pos_intro_start_dest then
				current_sunit.uc:goto_location(current_sunit.pos_intro_start_dest);
			end;
		end;
	end;
end;




sunit_player_01.pos_intro_mid = v(-227.0, -163.8);
sunit_player_01.orient_intro_mid = r_to_d(0.3);
sunit_player_01.width_intro_mid = 1.0;

sunit_player_02.pos_intro_mid = v(-242.3, -233.3);
sunit_player_02.orient_intro_mid = r_to_d(1.57);
sunit_player_02.width_intro_mid = 18.5;

sunit_player_03.pos_intro_mid = v(-227.5, -252.0);
sunit_player_03.orient_intro_mid = r_to_d(1.61);
sunit_player_03.width_intro_mid = 17.6;

sunit_player_04.pos_intro_mid = v(-241.0, -270.2);
sunit_player_04.orient_intro_mid = r_to_d(1.68);
sunit_player_04.width_intro_mid = 14.5;



function teleport_and_move_player_general_cutscene_intro_mid()
	sunit_player_01.uc:teleport_to_location(sunit_player_01.pos_intro_mid, sunit_player_01.orient_intro_mid, sunit_player_01.width_intro_mid);
	sunit_player_01:goto_start_location();
end;


function teleport_and_move_player_army_cutscene_intro_mid()
	for i = 1, sunits_player_start_no_general:count() do
		local current_sunit = sunits_player_start_no_general:item(i);
		
		if current_sunit.pos_intro_start then
			current_sunit.uc:teleport_to_location(current_sunit.pos_intro_mid, current_sunit.orient_intro_mid, current_sunit.width_intro_mid);
			current_sunit:goto_start_location();
		end;
	end;
end;













sunit_player_20.pos_entry = v(715.5, 275.4);
sunit_player_20.orient_entry = r_to_d(-2.57);
sunit_player_20.width_entry = 18.8;

sunit_player_21.pos_entry = v(700.0, 286.9);
sunit_player_21.orient_entry = r_to_d(-2.57);
sunit_player_21.width_entry = 16.7;


function enable_and_teleport_player_cavalry_reinforcements()
	sunits_player_cavalry_reinforcements:set_enabled(true);
	
	for i = 1, sunits_player_cavalry_reinforcements:count() do
		local current_sunit = sunits_player_cavalry_reinforcements:item(i);
		current_sunit.uc:teleport_to_location(current_sunit.pos_entry, current_sunit.orient_entry, current_sunit.width_entry);
	end;
end;



















--
-- Enemy setup
--

alliance_enemy = alliances:item(2); 
army_enemy_01 = alliance_enemy:armies():item(1);
army_enemy_02 = alliance_enemy:armies():item(2);

uc_enemy_01_all = unitcontroller_from_army(army_enemy_01);
uc_enemy_02_all = unitcontroller_from_army(army_enemy_02);
uc_enemy_02_all:take_control();

sunit_enemy_01 = script_unit:new_by_reference(army_enemy_01, "enemy_01");
sunit_enemy_02 = script_unit:new_by_reference(army_enemy_01, "enemy_02");
sunit_enemy_03 = script_unit:new_by_reference(army_enemy_01, "enemy_03");
sunit_enemy_04 = script_unit:new_by_reference(army_enemy_01, "enemy_04");

sunit_enemy_10 = script_unit:new_by_reference(army_enemy_02, "enemy_10");
sunit_enemy_11 = script_unit:new_by_reference(army_enemy_02, "enemy_11");
sunit_enemy_12 = script_unit:new_by_reference(army_enemy_02, "enemy_12");
sunit_enemy_13 = script_unit:new_by_reference(army_enemy_02, "enemy_13");
sunit_enemy_14 = script_unit:new_by_reference(army_enemy_02, "enemy_14");
sunit_enemy_15 = script_unit:new_by_reference(army_enemy_02, "enemy_15");
sunit_enemy_16 = script_unit:new_by_reference(army_enemy_02, "enemy_16");
sunit_enemy_17 = script_unit:new_by_reference(army_enemy_02, "enemy_17");
sunit_enemy_18 = script_unit:new_by_reference(army_enemy_02, "enemy_18");
sunit_enemy_19 = script_unit:new_by_reference(army_enemy_02, "enemy_19");

sunits_enemy_start = script_units:new(
	"enemy_start",
	sunit_enemy_01,
	sunit_enemy_02,
	sunit_enemy_03,
	sunit_enemy_04
);

sunits_enemy_phase_two = script_units:new(
	"enemy_phase_two",
	sunit_enemy_10,
	sunit_enemy_11,
	sunit_enemy_12,
	sunit_enemy_13,
	sunit_enemy_14,
	sunit_enemy_15,
	sunit_enemy_16,
	sunit_enemy_17,
	sunit_enemy_18,
	sunit_enemy_19
);

sunits_enemy_phase_two:deploy_reinforcement(false);

sunits_enemy_all = script_units:new(
	"enemy_all",
	sunit_enemy_01,
	sunit_enemy_02,
	sunit_enemy_03,
	sunit_enemy_04,
	sunit_enemy_10,
	sunit_enemy_11,
	sunit_enemy_12,
	sunit_enemy_13,
	sunit_enemy_14,
	sunit_enemy_15,
	sunit_enemy_16,
	sunit_enemy_17,
	sunit_enemy_18,
	sunit_enemy_19
);

-- prevent the ai from deploying the troops
sunits_enemy_start:take_control();


-- starting enemy meander start positions
sunit_enemy_01.pos_meander_start = v(259.5, -242.5);
sunit_enemy_01.pos_meander_end = v(268, -288);
sunit_enemy_01.orient_meander = r_to_d(1.4);
sunit_enemy_01.width_meander = 1.4;

sunit_enemy_02.pos_meander_start = v(269.9, -252.2);
sunit_enemy_02.orient_meander =  r_to_d(-1.77);
sunit_enemy_02.width_meander = 22.0;

sunit_enemy_03.pos_meander_start = v(274.8, -276.5);
sunit_enemy_03.orient_meander = r_to_d(-1.77);
sunit_enemy_03.width_meander = 23.5;

sunit_enemy_04.pos_meander_start = v(279.9, -301.4);
sunit_enemy_04.orient_meander = r_to_d(-1.77);
sunit_enemy_04.width_meander = 23.5;


-- starting enemy formup positions
sunit_enemy_01.pos_form_up = v(178.6, -240.9);
sunit_enemy_01.orient_form_up = r_to_d(-1.55);
sunit_enemy_01.width_form_up = 1.4;

sunit_enemy_02.pos_form_up = v(177.5, -254.0);
sunit_enemy_02.orient_form_up =  r_to_d(-1.57);
sunit_enemy_02.width_form_up = 21.5;

sunit_enemy_03.pos_form_up = v(177.5, -277.5);
sunit_enemy_03.orient_form_up = r_to_d(-1.57);
sunit_enemy_03.width_form_up = 21.5;

sunit_enemy_04.pos_form_up = v(177.6, -301.0);
sunit_enemy_04.orient_form_up = r_to_d(-1.57);
sunit_enemy_04.width_form_up = 21.5;




function start_enemy_meandering()
	local player_armies = sunit_player_01:alliance():armies();

	for i = 1, sunits_enemy_start:count() do
		local current_sunit = sunits_enemy_start:item(i);
		current_sunit.uc:teleport_to_location(current_sunit.pos_meander_start, current_sunit.orient_meander, current_sunit.width_meander);
		
		if current_sunit.pos_meander_end then
			local pm = patrol_manager:new(current_sunit.name .. "_meander",	current_sunit, player_armies, 0);
			pm:set_waypoint_threshold(5);
			pm:loop(true);
			pm:add_waypoint(current_sunit.pos_meander_end);
			pm:add_waypoint(current_sunit.pos_meander_start);
			pm:start();
		end;
	end;
end;


function stop_enemy_meandering()
	local player_pos = sunit_player_01.unit:position();
	
	-- just make the enemy general turn
	sunit_enemy_01:stop_current_patrol();
	sunit_enemy_01:turn_to_face(player_pos);
end;


function form_up_enemy(should_run)
	should_run = should_run or false;
	
	for i = 1, sunits_enemy_start:count() do
		local current_sunit = sunits_enemy_start:item(i);
		current_sunit.uc:goto_location_angle_width(current_sunit.pos_form_up, current_sunit.orient_form_up, current_sunit.width_form_up, should_run);
	end;
end;


function halt_visible_player_units()
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		if current_sunit.unit:is_visible_to_alliance(alliance_enemy) then
			current_sunit.uc:halt();
		end;
	end;
end;





-- starting player army formup positions, for phase two
sunit_player_01.pos_phase_two_start = v(288.0, -272.0);
sunit_player_01.orient_phase_two_start = r_to_d(0.84);
sunit_player_01.width_phase_two_start = 1.4;

sunit_player_02.pos_phase_two_start = v(296.7, -281.7);
sunit_player_02.orient_phase_two_start =  r_to_d(0.84);
sunit_player_02.width_phase_two_start = 20.5;

sunit_player_03.pos_phase_two_start = v(311.8, -298.5);
sunit_player_03.orient_phase_two_start = r_to_d(0.84);
sunit_player_03.width_phase_two_start = 20.5;

sunit_player_04.pos_phase_two_start = v(326.8, -315.3);
sunit_player_04.orient_phase_two_start = r_to_d(0.84);
sunit_player_04.width_phase_two_start = 20.5;

area_phase_one_combat = convex_area:new({
	v(320, -90),
	v(530, -470),
	v(85, -470),
	v(85, -90)
});

bool_should_reposition_player_army_for_phase_two = false;

function should_reposition_player_army_for_phase_two()

	-- always reposition now
	return true;

	--[[
	-- if any of player's army are outside the phase one combat area, then we should reposition
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		if not area_phase_one_combat:is_in_area(current_sunit) then
			bm:out("should_reposition_player_army_for_phase_two() thinks we should reposition the player's army for phase two, as player unit " .. current_sunit.name .. " is at " .. v_to_s(current_sunit.unit:position()) .. " and outside the phase one combat area");
			return true;
		end;
	end;
	
	-- if the player's army is quite spread out, then reposition
	local furthest_unit = sunits_player_start:radius();
	if furthest_unit > 100 then
		bm:out("should_reposition_player_army_for_phase_two() thinks we should reposition the player's army for phase two, as the player's army radius is " .. tostring(furthest_unit));
		return true;
	end;
	
	return false;
	]]
end;


-- reposition if any of the player's units are not in the phase one combat area
function reposition_phase_two_player_army_if_appropriate()
	if bool_should_reposition_player_army_for_phase_two then
		bm:out("Repositioning player's units for the start of phase two");

		for i = 1, sunits_player_start:count() do
			local current_sunit = sunits_player_start:item(i);
			current_sunit.uc:teleport_to_location(current_sunit.pos_phase_two_start, current_sunit.orient_phase_two_start, current_sunit.width_phase_two_start);
		end;
	end;
end;



-- teleport enemy army reinforcements forward a bit, so they don't have so far to walk. Only do this once.

bool_enemy_reinforcements_teleported = false;
enemy_reinforcements_teleport_x_offset = -50;
enemy_reinforcements_teleport_z_offset = 150;

function teleport_enemy_reinforcements_forward()
	if bool_enemy_reinforcements_teleported then
		return;
	end;
	
	bool_enemy_reinforcements_teleported = true;
	
	sunits_enemy_phase_two:teleport_to_location_offset(enemy_reinforcements_teleport_x_offset, enemy_reinforcements_teleport_z_offset);
end;
