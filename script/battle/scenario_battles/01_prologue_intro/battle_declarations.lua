cam = bm:camera();
alliances = bm:alliances();

output_uicomponent_on_click();

bm:suppress_unit_voices(true);

-- view of battlefield at start of intro
pos_cam_intro_start = v(454.6, 447.3, -507.5);
pos_targ_intro_start = v(390.2, 436.1, -444.8);
cam_fov_intro_start = 50.3;

-- reposition the camera at this time
-- bm:enable_cinematic_camera(true);
cam:move_to(pos_cam_intro_start, pos_targ_intro_start, 0, false, cam_fov_intro_start);

-- view of battlefield prior to camera bookmarks
pos_cam_gameplay_start = v(438.3, 452.5, -453.5);
pos_targ_gameplay_start = v(333.5, 405.5, -393.3);

-- view of battlefield prior to general selection advice
pos_cam_general_selection_start = v(427.4, 454.0, -457.6);
pos_targ_general_selection_start = v(333.7, 392.4, -392.9);







--
-- Player setup
--

alliance_player = alliances:item(1);
army_player_01 = alliance_player:armies():item(1);
army_player_02 = alliance_player:armies():item(2);


-- player starting units
sunit_player_01 = script_unit:new_by_reference(army_player_01, "player_01");
sunit_player_02 = script_unit:new_by_reference(army_player_01, "player_02");
sunit_player_03 = script_unit:new_by_reference(army_player_01, "player_03");

-- player additional skirmish units
sunit_player_04 = script_unit:new_by_reference(army_player_01, "player_04");
sunit_player_05 = script_unit:new_by_reference(army_player_01, "player_05");
sunit_player_06 = script_unit:new_by_reference(army_player_01, "player_06");


-- defending allies
sunit_allies_01 = script_unit:new_by_reference(army_player_02, "allies_01");
sunit_allies_02 = script_unit:new_by_reference(army_player_02, "allies_02");
sunit_allies_03 = script_unit:new_by_reference(army_player_02, "allies_03");
sunit_allies_04 = script_unit:new_by_reference(army_player_02, "allies_04");
sunit_allies_05 = script_unit:new_by_reference(army_player_02, "allies_05");
sunit_allies_06 = script_unit:new_by_reference(army_player_02, "allies_06");
sunit_allies_07 = script_unit:new_by_reference(army_player_02, "allies_07");
sunit_allies_08 = script_unit:new_by_reference(army_player_02, "allies_08");
sunit_allies_09 = script_unit:new_by_reference(army_player_02, "allies_09");
sunit_allies_10 = script_unit:new_by_reference(army_player_02, "allies_10");
sunit_allies_11 = script_unit:new_by_reference(army_player_02, "allies_11");
sunit_allies_12 = script_unit:new_by_reference(army_player_02, "allies_12");

sunit_allies_20 = script_unit:new_by_reference(army_player_02, "allies_20");
sunit_allies_21 = script_unit:new_by_reference(army_player_02, "allies_21");
sunit_allies_22 = script_unit:new_by_reference(army_player_02, "allies_22");



uc_player_01_all = unitcontroller_from_army(army_player_01);
--uc_player_01_all:take_control();

uc_player_02_all = unitcontroller_from_army(army_player_02);
uc_player_02_all:take_control();				-- prevent this army from redeploying at the start of the battle


sunits_player_general = script_units:new(
	"player_general",
	sunit_player_01
);

sunits_player_start = script_units:new(
	"player_start",
	sunit_player_01,
	sunit_player_02,
	sunit_player_03
);

sunits_player_start_no_general = script_units:new(
	"player_start_no_general",
	sunit_player_02,
	sunit_player_03
);

sunits_player_all = script_units:new(
	"player_all",
	sunit_player_01,
	sunit_player_02,
	sunit_player_03,
	sunit_player_04,
	sunit_player_05,
	sunit_player_06
);
sunits_player_all:hide_unbreakable_in_ui(true);

sunits_player_all_no_general = script_units:new(
	"player_all_no_general",
	sunit_player_02,
	sunit_player_03,
	sunit_player_04,
	sunit_player_05,
	sunit_player_06
);

sunits_player_missile_reinforcements = script_units:new(
	"player_missile_reinforcements",
	sunit_player_04,
	sunit_player_05,
	sunit_player_06
);

-- disable skirmish mode on all the player's missile units
sunits_player_missile_reinforcements_missile_only = sunits_player_missile_reinforcements:filter(
	"player_missile_reinforcements_missile_only",
	function(sunit)
		return sunit.unit:starting_ammo() > 5;
	end
);

sunits_allied_main = script_units:new(
	"allied_main",
	sunit_allies_01,
	sunit_allies_02,
	sunit_allies_03,
	sunit_allies_04,
	sunit_allies_05,
	sunit_allies_06,
	sunit_allies_07,
	sunit_allies_08,
	sunit_allies_09,
	sunit_allies_10,
	sunit_allies_11,
	sunit_allies_12
);
sunits_allied_main:hide_unbreakable_in_ui(true);

sunits_allied_skirmishers = script_units:new(
	"allied_skirmishers",
	sunit_allies_20,
	sunit_allies_21,
	sunit_allies_22
);
sunits_allied_skirmishers:hide_unbreakable_in_ui(true);





-- teleport position
sunit_player_01.pos_skirmish_attack_start = v(328.4, -236.7);
sunit_player_01.orient_skirmish_attack_start = r_to_d(-2.1);
sunit_player_01.width_skirmish_attack_start = 1.4;

sunit_player_02.pos_skirmish_attack_start = v(304.6, -232.9);
sunit_player_02.orient_skirmish_attack_start = r_to_d(-2.1);
sunit_player_02.width_skirmish_attack_start = 28.6;

sunit_player_03.pos_skirmish_attack_start = v(320.0, -259.3);
sunit_player_03.orient_skirmish_attack_start = r_to_d(-2.1);
sunit_player_03.width_skirmish_attack_start = 28.6;


function teleport_player_skirmish_attack_start()
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		current_sunit.uc:teleport_to_location(current_sunit.pos_skirmish_attack_start, current_sunit.orient_skirmish_attack_start, current_sunit.width_skirmish_attack_start);
		current_sunit.uc:release_control();
	end;
end;








-- set up artillery attack player positions
sunit_player_01.pos_art_attack_start = v(196.7, -468.2);
sunit_player_01.orient_art_attack_start = r_to_d(-1.72);
sunit_player_01.width_art_attack_start = 1.4;

sunit_player_02.pos_art_attack_start = v(155.9, -475.5);
sunit_player_02.orient_art_attack_start = r_to_d(-1.71);
sunit_player_02.width_art_attack_start = 26.9;
sunit_player_02.should_set_invisible_during_intro_cutscene = true;

sunit_player_03.pos_art_attack_start = v(152.1, -447.7);
sunit_player_03.orient_art_attack_start = r_to_d(-1.71);
sunit_player_03.width_art_attack_start = 25.2;
sunit_player_03.should_set_invisible_during_intro_cutscene = true;

sunit_player_04.pos_art_attack_start = v(159.5, -501.6);
sunit_player_04.orient_art_attack_start = r_to_d(-1.71);
sunit_player_04.width_art_attack_start = 22.0;

sunit_player_05.pos_art_attack_start = v(181.9, -480.5);
sunit_player_05.orient_art_attack_start = r_to_d(-1.72);
sunit_player_05.width_art_attack_start = 19.4;

sunit_player_06.pos_art_attack_start = v(178.8, -460.1);
sunit_player_06.orient_art_attack_start = r_to_d(-1.72);
sunit_player_06.width_art_attack_start = 18;


function reposition_artillery_attack_player_army_for_gameplay()
	for i = 1, sunits_player_all:count() do
		local current_sunit = sunits_player_all:item(i);
		current_sunit.uc:teleport_to_location(current_sunit.pos_art_attack_start, current_sunit.orient_art_attack_start, current_sunit.width_art_attack_start);
	end;
end;


function reposition_and_advance_artillery_attack_player_army_for_cutscene()
	for i = 1, sunits_player_all:count() do
		local current_sunit = sunits_player_all:item(i);
		current_sunit:teleport_to_location_offset(10, -20, current_sunit.orient_art_attack_start);
		current_sunit.uc:goto_location_angle_width(current_sunit.pos_art_attack_start, current_sunit.orient_art_attack_start, current_sunit.width_art_attack_start, true);
	end;
end;


function set_player_units_invisible_during_artillery_attack_cutscene(set_invisible)
	for i = 1, sunits_player_all:count() do
		local current_sunit = sunits_player_all:item(i);
		if current_sunit.should_set_invisible_during_intro_cutscene then
			current_sunit.uc:set_invisible_to_all(set_invisible, false);			-- do not update the ui, as doing so re-orders the unit cards
		end;
	end;
end;


function advance_artillery_attack_player_missiles()
	for i = 1, sunits_player_all:count() do
		local current_sunit = sunits_player_all:item(i);
		if current_sunit.player_missile_y_offset then
			current_sunit.unitcontroller:goto_location_angle_width(current_sunit.pos_art_attack_start, current_sunit.orient_art_attack_start, current_sunit.width_art_attack_start);
		end;
	end;
end;





-- set up skirmish combatant initial positions
pos_allies_skirmish_staging = v(170, -360);

sunit_allies_20.pos_start = v(225.1, -221.2);
sunit_allies_20.orient_start = r_to_d(-2.30);
sunit_allies_20.width_start = 21.3;

--[[
sunit_allies_20.pos_skirmish_staging = v(202.6, -382.5);
sunit_allies_20.orient_skirmish_staging = r_to_d(-1.35);
sunit_allies_20.width_skirmish_staging = 29.9;
]]

sunit_allies_20.pos_skirmish_dest = v(115.5, -373);
sunit_allies_20.orient_skirmish_dest = r_to_d(-1.46);
sunit_allies_20.width_skirmish_dest = 24.5;



sunit_allies_21.pos_start = v(248.3, -200.7);
sunit_allies_21.orient_start = r_to_d(-2.29);
sunit_allies_21.width_start = 21.3;

--[[
sunit_allies_21.pos_skirmish_staging = v(214.8, -351.7);
sunit_allies_21.orient_skirmish_staging = r_to_d(-1.40);
sunit_allies_21.width_skirmish_staging = 32.0;
]]

sunit_allies_21.pos_skirmish_dest = v(119.9, -340);
sunit_allies_21.orient_skirmish_dest = r_to_d(-1.46);
sunit_allies_21.width_skirmish_dest = 36.3;



sunit_allies_22.pos_start = v(257.6, -192.6);
sunit_allies_22.orient_start = r_to_d(-2.28);
sunit_allies_22.width_start = 20.2;

--[[
sunit_allies_22.pos_skirmish_staging = v(235.5, -373.7);
sunit_allies_22.orient_skirmish_staging = r_to_d(-1.44);
sunit_allies_22.width_skirmish_staging = 40.8;
]]

sunit_allies_22.pos_skirmish_dest = v(126, -371);
sunit_allies_22.orient_skirmish_dest = r_to_d(-1.45);
sunit_allies_22.width_skirmish_dest = 30;



sunits_allied_defenders = script_units:new(
	"allied_defenders",
	sunit_allies_01,
	sunit_allies_02,
	sunit_allies_03,
	sunit_allies_04,
	sunit_allies_05,
	sunit_allies_06,
	sunit_allies_07,
	sunit_allies_08,
	sunit_allies_09,
	sunit_allies_10,
	sunit_allies_11,
	sunit_allies_12
);


function hide_skirmish_allies()
	for i = 1, sunits_allied_skirmishers:count() do
		local current_sunit = sunits_allied_skirmishers:item(i);
		current_sunit:take_control();
		current_sunit:teleport_to_location(current_sunit.pos_start, current_sunit.orient_start, current_sunit.width_start);
		current_sunit:change_behaviour_active("skirmish", false);
		bm:callback(function() current_sunit:set_enabled(false) end, 200);
	end;
end;


function skirmish_allies_unhide()
	
	for i = 1, sunits_allied_skirmishers:count() do
		local current_sunit = sunits_allied_skirmishers:item(i);
		
		-- disable LOS on this unit
		current_sunit.uc:set_always_visible_to_all(true);

		-- enable this unit
		current_sunit:set_enabled(true);

		-- disable skirmish and enable fire-at-will
		current_sunit.uc:change_behaviour_active("skirmish", false);
		current_sunit.uc:change_behaviour_active("fire_at_will", true);
	end;
end;


function skirmish_allies_move_staging(move_fast)
	move_fast = not not move_fast;

	for i = 1, sunits_allied_skirmishers:count() do
		local current_sunit = sunits_allied_skirmishers:item(i);
		-- current_sunit.uc:goto_location_angle_width(current_sunit.pos_skirmish_staging, current_sunit.orient_skirmish_staging, current_sunit.width_skirmish_staging, move_fast);
		current_sunit.uc:goto_location(pos_allies_skirmish_staging, move_fast);
	end;
end;


function skirmish_allies_move_main(move_fast)
	move_fast = not not move_fast;

	for i = 1, sunits_allied_skirmishers:count() do
		local current_sunit = sunits_allied_skirmishers:item(i);
		current_sunit.uc:goto_location_angle_width(current_sunit.pos_skirmish_dest, current_sunit.orient_skirmish_dest, current_sunit.width_skirmish_dest, move_fast);
	end;
end;


function have_skirmish_allies_arrived_main()
	local sunit = sunits_allied_skirmishers:item(1);

	return sunit.unit:position():distance_xz(sunit.pos_skirmish_dest) < 10;
end;


function skirmish_allies_respond_to_enemy()
	bm:out("* skirmish_allies_respond_to_enemy() called");

	bm:callback(function() sunits_allied_skirmishers:attack_enemy_scriptunits(sunits_enemy_skirmish, true) end, 10000)
end;



sunit_allies_08.pos_threat_response = v(-25, -10);
sunit_allies_08.pos_threat_response = v(-25, -10);

function start_main_allied_defence_behaviour()

	local armies_enemy = alliance_enemy:armies();

	for i = 1, sunits_allied_defenders:count() do
		local current_sunit = sunits_allied_defenders:item(i);
		local threshold_distance = current_sunit.threat_threshold or 100;
		bm:watch(
			function()
				return is_close_to_position(sunits_enemy_main, current_sunit.unit:position(), threshold_distance);
			end,
			0,
			function()
				local pm = patrol_manager:new(
					current_sunit.name .. "_respond_to_threat",
					current_sunit,
					armies_enemy,
					20,
					60,
					60
				);
				pm:add_waypoint(current_sunit.pos_threat_response or current_sunit:position_offset(0, 0, current_sunit.threat_advance_distance or 75), true, -1);
				-- pm:set_debug(true);
				pm:set_intercept_time(-1);
				pm:start();
			end,
			current_sunit.name .. "_threat_monitor"
		);
	end;
end;




-- disable the player's missile reinforcements at the start of the battle
sunits_player_missile_reinforcements:set_enabled(false);


-- disable the allied skirmishers at the start of the battle
-- sunits_allied_skirmishers:set_enabled(false);


-- teleport positions for intro cutscene
pos_intro_start_dest = v(460, -414);

local function teleport_to_position_facing_position(sunit, position, width, facing_position)
	sunit.uc:teleport_to_location(position, r_to_d(get_bearing(position, facing_position)), width);
end;

sunit_player_01.pos_intro_start = v(504.2, -422.2);
-- sunit_player_01.orient_intro_start = r_to_d(-0.49);
sunit_player_01.width_intro_start = 1.4;
sunit_player_01.pos_intro_start_dest = pos_intro_start_dest;

sunit_player_02.pos_intro_start = v(510.7, -423.6);
-- sunit_player_02.orient_intro_start = r_to_d(-0.49);
sunit_player_02.width_intro_start = 13.7;
sunit_player_02.pos_intro_start_dest = pos_intro_start_dest;

sunit_player_03.pos_intro_start = v(541.1, -429.2);
-- sunit_player_03.orient_intro_start = r_to_d(-0.47);
sunit_player_03.width_intro_start = 11.9;
sunit_player_03.pos_intro_start_dest = pos_intro_start_dest;


function teleport_player_army_cutscene_intro_start()
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		
		if current_sunit.pos_intro_start then
			teleport_to_position_facing_position(current_sunit, current_sunit.pos_intro_start, current_sunit.width_intro_start, current_sunit.pos_intro_start_dest);
		end;
	end;
end;


function move_player_army_cutscene_intro_start()
	for i = 1, sunits_player_start:count() do
		local current_sunit = sunits_player_start:item(i);
		
		if current_sunit.pos_intro_start_dest then
			current_sunit.uc:goto_location(current_sunit.pos_intro_start_dest);
		end;
	end;
end;


function set_player_army_visibility_cutscene_intro_start(visible)
	sunits_player_start:set_invisible_to_all(not visible);
end;

















--
-- Enemy setup
--

alliance_enemy = alliances:item(2); 
army_enemy_01 = alliance_enemy:armies():item(1);
army_enemy_02 = alliance_enemy:armies():item(2);

sunit_enemy_01 = script_unit:new_by_reference(army_enemy_01, "enemy_01");
sunit_enemy_02 = script_unit:new_by_reference(army_enemy_01, "enemy_02");
sunit_enemy_03 = script_unit:new_by_reference(army_enemy_01, "enemy_03");
sunit_enemy_04 = script_unit:new_by_reference(army_enemy_01, "enemy_04");
sunit_enemy_05 = script_unit:new_by_reference(army_enemy_01, "enemy_05");
sunit_enemy_06 = script_unit:new_by_reference(army_enemy_01, "enemy_06");
sunit_enemy_07 = script_unit:new_by_reference(army_enemy_01, "enemy_07");
sunit_enemy_08 = script_unit:new_by_reference(army_enemy_01, "enemy_08");
sunit_enemy_09 = script_unit:new_by_reference(army_enemy_01, "enemy_09");
sunit_enemy_10 = script_unit:new_by_reference(army_enemy_01, "enemy_10");
sunit_enemy_11 = script_unit:new_by_reference(army_enemy_01, "enemy_11");
sunit_enemy_12 = script_unit:new_by_reference(army_enemy_01, "enemy_12");
sunit_enemy_13 = script_unit:new_by_reference(army_enemy_01, "enemy_13");
-- artillery
sunit_enemy_14 = script_unit:new_by_reference(army_enemy_01, "enemy_14");
sunit_enemy_15 = script_unit:new_by_reference(army_enemy_01, "enemy_15");
sunit_enemy_16 = script_unit:new_by_reference(army_enemy_01, "enemy_16");
sunit_enemy_17 = script_unit:new_by_reference(army_enemy_01, "enemy_17");
-- skirmishers
sunit_enemy_18 = script_unit:new_by_reference(army_enemy_01, "enemy_18");
sunit_enemy_19 = script_unit:new_by_reference(army_enemy_01, "enemy_19");
sunit_enemy_20 = script_unit:new_by_reference(army_enemy_01, "enemy_20");
-- second army, artillery defenders
sunit_enemy_21 = script_unit:new_by_reference(army_enemy_02, "enemy_21");
sunit_enemy_22 = script_unit:new_by_reference(army_enemy_02, "enemy_22");
sunit_enemy_23 = script_unit:new_by_reference(army_enemy_02, "enemy_23");
sunit_enemy_24 = script_unit:new_by_reference(army_enemy_02, "enemy_24");
sunit_enemy_25 = script_unit:new_by_reference(army_enemy_02, "enemy_25");


uc_enemy_01_all = unitcontroller_from_army(army_enemy_01);
uc_enemy_01_all:take_control();				-- prevent this army from redeploying at the start of the battle

uc_enemy_02_all = unitcontroller_from_army(army_enemy_02);
uc_enemy_02_all:take_control();				-- prevent this army from redeploying at the start of the battle

sunits_enemy_general = script_units:new(
	"enemy_general",
	sunit_enemy_01
);

sunits_enemy_all = script_units:new(
	"enemy_all",
	-- sunit_enemy_01,
	sunit_enemy_02,
	sunit_enemy_03,
	sunit_enemy_04,
	sunit_enemy_05,
	sunit_enemy_06,
	sunit_enemy_07,
	sunit_enemy_08,
	sunit_enemy_09,
	sunit_enemy_10,
	sunit_enemy_11,
	sunit_enemy_12,
	sunit_enemy_13,
	sunit_enemy_14,
	sunit_enemy_15,
	sunit_enemy_16,
	sunit_enemy_17,
	sunit_enemy_18,
	sunit_enemy_19,
	sunit_enemy_20,
	sunit_enemy_21,
	sunit_enemy_22,
	sunit_enemy_23,
	sunit_enemy_24,
	sunit_enemy_25
);
sunits_enemy_all:hide_unbreakable_in_ui(true);

-- make the enemy army always visible (not hidden by hills/line-of-sight etc)
sunits_enemy_all:set_always_visible(true);

sunits_enemy_main = script_units:new(
	"enemy_main",
	-- sunit_enemy_01,
	sunit_enemy_02,
	sunit_enemy_03,
	sunit_enemy_04,
	sunit_enemy_05,
	sunit_enemy_06,
	sunit_enemy_07,
	sunit_enemy_08,
	sunit_enemy_09,
	sunit_enemy_10,
	sunit_enemy_11,
	sunit_enemy_12,
	sunit_enemy_13,
	sunit_enemy_21
);

sunits_enemy_main_melee = script_units:new(
	"enemy_main_melee",
	-- sunit_enemy_01,
	sunit_enemy_02,
	sunit_enemy_03,
	sunit_enemy_04,
	sunit_enemy_05,
	sunit_enemy_06,
	sunit_enemy_07,
	sunit_enemy_08,
	sunit_enemy_09,
	sunit_enemy_10,
	sunit_enemy_21
);

sunits_enemy_main_missile = script_units:new(
	"enemy_main_missile",
	sunit_enemy_11,
	sunit_enemy_12,
	sunit_enemy_13
);

sunits_enemy_artillery = script_units:new(
	"enemy_artillery",
	sunit_enemy_14,
	sunit_enemy_15,
	sunit_enemy_16,
	sunit_enemy_17
);

sunits_enemy_skirmish = script_units:new(
	"enemy_skirmish",
	sunit_enemy_18,
	sunit_enemy_19,
	sunit_enemy_20
);

sunits_enemy_artillery_defenders = script_units:new(
	"enemy_artillery_defenders",
	-- sunit_enemy_21,
	sunit_enemy_22,
	sunit_enemy_23,
	sunit_enemy_24,
	sunit_enemy_25
);

sunits_enemy_artillery_and_defenders = script_units:new(
	"enemy_artillery_and_defenders",
	sunit_enemy_14,
	sunit_enemy_15,
	sunit_enemy_16,
	sunit_enemy_17,
	-- sunit_enemy_21,
	sunit_enemy_22,
	sunit_enemy_23,
	sunit_enemy_24,
	sunit_enemy_25
);




-- set up skirmish combatant initial positions
sunit_enemy_18.pos_start = v(242.7, -504.4);
sunit_enemy_18.orient_start = r_to_d(-0.23);
sunit_enemy_18.width_start = 33.7;
sunit_enemy_18.initial_attack_target = sunit_allies_20;

sunit_enemy_19.pos_start = v(276.6, -496.4);
sunit_enemy_19.orient_start = r_to_d(-0.23);
sunit_enemy_19.width_start = 32.0;
sunit_enemy_19.initial_attack_target = sunit_allies_21;
sunit_enemy_19.pos_respond_to_player = v(207.3, -346.3);
sunit_enemy_19.orient_respond_to_player = r_to_d(-0.93);
sunit_enemy_19.width_respond_to_player = 30.7;

sunit_enemy_20.pos_start = v(267.8, -522.1);
sunit_enemy_20.orient_start = r_to_d(-0.22);
sunit_enemy_20.width_start = 35.4;
sunit_enemy_20.initial_attack_target = sunit_allies_22;


function hide_enemy_general()
	sunit_enemy_01.uc:teleport_to_location(v(-775, 465), 0, 1);
	sunit_enemy_01:set_enabled(false);
end;


function remove_enemy_general()
	sunit_enemy_01:set_enabled(true);
	sunit_enemy_01:kill(true);
end;



function hide_skirmish_enemies()
	for i = 1, sunits_enemy_skirmish:count() do
		local current_sunit = sunits_enemy_skirmish:item(i);
		current_sunit:teleport_to_location(current_sunit.pos_start, current_sunit.orient_start, current_sunit.width_start);
		current_sunit:set_enabled(false);
	end;
end;


function skirmish_enemies_advance()
	sunits_enemy_skirmish:set_enabled(true);
	sunits_enemy_skirmish:goto_location_offset(-10, 100, true);
end;


function reposition_skirmish_enemies_for_attack()
	sunits_enemy_skirmish:set_enabled(true);
	sunits_enemy_skirmish:teleport_to_start_location_offset(-10, 100, nil, true);
end;


function skirmish_enemies_initial_attack()
	for i = 1, sunits_enemy_skirmish:count() do
		local current_sunit = sunits_enemy_skirmish:item(i);
		current_sunit.uc:attack_unit(current_sunit.initial_attack_target.unit, true, true);
	end;
end;


function skirmish_enemies_respond_to_player()
	bm:out("* skirmish_enemies_respond_to_player() called");

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_attacked_first_enemy", true);

	for i = 1, sunits_enemy_skirmish:count() do
		local current_sunit = sunits_enemy_skirmish:item(i);
		-- if the current sunit has a position to respond to the player with then set up a patrol manager which makes them guard that position
		if current_sunit.pos_respond_to_player then
			local pm = patrol_manager:new(
				current_sunit.name .. "_respond_to_player",
				current_sunit,
				bm:get_player_alliance():armies(),
				80,
				100,
				70
			);

			-- pm:set_debug(true);
			pm:set_stop_on_rout(true);
			pm:add_waypoint(current_sunit.pos_respond_to_player, true, -1, current_sunit.orient_respond_to_player, current_sunit.width_respond_to_player);

			pm:start();
		end;
	end;
end;





-- positions of artillery that assist in their own defence

sunit_enemy_16.pos_art_defence_main = v(-35, -294);
sunit_enemy_16.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_16.width_art_defence_main = 4;

sunit_enemy_17.pos_art_defence_main = v(-20, -290);
sunit_enemy_17.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_17.width_art_defence_main = 4;



sunit_enemy_22.pos_art_defence_skirmish_response = v(-12.2, -338.0);
sunit_enemy_22.orient_art_defence_skirmish_response = r_to_d(1.71);
sunit_enemy_22.width_art_defence_skirmish_response = 33.3;
sunit_enemy_22.delay_art_defence_skirmish_response = 3000;

sunit_enemy_22.pos_art_defence_main = v(-17.8, -311.6);
sunit_enemy_22.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_22.width_art_defence_main = 28;

sunit_enemy_22.pos_art_defence_advance = v_offset(sunit_enemy_22.pos_art_defence_main, 30, 0, -30);
sunit_enemy_22.orient_art_defence_advance = sunit_enemy_22.orient_art_defence_main;
sunit_enemy_22.width_art_defence_advance = sunit_enemy_22.width_art_defence_main;

sunit_enemy_23.pos_art_defence_skirmish_response = v(-28.9, -323.4);
sunit_enemy_23.orient_art_defence_skirmish_response = r_to_d(1.76);
sunit_enemy_23.width_art_defence_skirmish_response = 21.4;
sunit_enemy_23.delay_art_defence_skirmish_response = 4000;

sunit_enemy_23.pos_art_defence_main = v(-70.8, -317.5);
sunit_enemy_23.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_23.width_art_defence_main = 23.5;

sunit_enemy_23.pos_art_defence_advance = v_offset(sunit_enemy_23.pos_art_defence_main, 30, 0, -30);
sunit_enemy_23.orient_art_defence_advance = sunit_enemy_23.orient_art_defence_main;
sunit_enemy_23.width_art_defence_advance = sunit_enemy_23.width_art_defence_main;

sunit_enemy_24.pos_art_defence_skirmish_response = v(-33.3, -346.4);
sunit_enemy_24.orient_art_defence_skirmish_response = r_to_d(1.76);
sunit_enemy_24.width_art_defence_skirmish_response = 21.4;
sunit_enemy_24.delay_art_defence_skirmish_response = 5000;

sunit_enemy_24.pos_art_defence_main = v(-45.4, -314.7);
sunit_enemy_24.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_24.width_art_defence_main = 23.5;

sunit_enemy_24.pos_art_defence_advance = v_offset(sunit_enemy_24.pos_art_defence_main, 30, 0, -30);
sunit_enemy_24.orient_art_defence_advance = sunit_enemy_24.orient_art_defence_main;
sunit_enemy_24.width_art_defence_advance = sunit_enemy_24.width_art_defence_main;

sunit_enemy_25.pos_art_defence_skirmish_response = v(25.9, -336.6);
sunit_enemy_25.orient_art_defence_skirmish_response = r_to_d(1.68);
sunit_enemy_25.width_art_defence_skirmish_response = 42.0;
sunit_enemy_25.delay_art_defence_skirmish_response = 1000;

sunit_enemy_25.pos_art_defence_main = v(-50.6, -289.4);
sunit_enemy_25.orient_art_defence_main = r_to_d(3.03);
sunit_enemy_25.width_art_defence_main = 35.0;

sunit_enemy_25.pos_art_defence_advance = v_offset(sunit_enemy_25.pos_art_defence_main, 30, 0, -30);
sunit_enemy_25.orient_art_defence_advance = sunit_enemy_25.orient_art_defence_main;
sunit_enemy_25.width_art_defence_advance = sunit_enemy_25.width_art_defence_main;


function enemy_art_defence_watch_for_skirmish_attack()

	sunits_enemy_artillery_defenders:max_casualties(0.8);
	sunits_enemy_artillery_defenders:morale_behavior_fearless();

	bm:watch(
		function()
			return sunits_enemy_artillery_defenders:is_under_attack();
		end,
		0,
		function()
			for i = 1, sunits_enemy_artillery_defenders:count() do
				local current_sunit = sunits_enemy_artillery_defenders:item(i);
				bm:callback(
					function()
						current_sunit.uc:goto_location_angle_width(current_sunit.pos_art_defence_skirmish_response, current_sunit.orient_art_defence_skirmish_response, current_sunit.width_art_defence_skirmish_response);
					end,
					current_sunit.delay_art_defence_skirmish_response,
					"art_defence_skirmish_attack_response"
				);
			end;
		end,
		"art_defence_skirmish_attack_response"
	);
end;


function stop_enemy_art_defence_watch_for_skirmish_attack()
	bm:remove_process("art_defence_skirmish_attack_response");
end;


-- move the enemy artillery that will assist in the defence against the player into the correct positions
function move_enemy_artillery_to_assist_defence_positions()
	for i = 1, sunits_enemy_artillery:count() do
		local current_sunit = sunits_enemy_artillery:item(i);
		if current_sunit.pos_art_defence_main then
			current_sunit.uc:goto_location_angle_width(current_sunit.pos_art_defence_main, current_sunit.orient_art_defence_main, current_sunit.width_art_defence_main, true);
		end;
	end;
end;


-- pivot one or more of the enemy artillery to assist in the defence against the player
function enemy_artillery_assists_defence()
	local player_armies = bm:get_player_alliance():armies();
	for i = 1, sunits_enemy_artillery:count() do
		local current_sunit = sunits_enemy_artillery:item(i);
		if current_sunit.pos_art_defence_main then
			current_sunit.uc:goto_location_angle_width(current_sunit.pos_art_defence_main, current_sunit.orient_art_defence_main, current_sunit.width_art_defence_main, true);
			bm:watch(
				function()
					return current_sunit.unit:position():distance_xz(current_sunit.pos_art_defence_main) < 5;
				end,
				3000,
				function()
					local pm = patrol_manager:new(
						current_sunit.name .. "_artillery_defence",
						current_sunit,
						player_armies,
						220,
						240,
						40
					);

					pm:set_debug(true);
					pm:set_stop_on_rout(true);
					pm:set_intercept_time(-1);
					pm:set_attack_with_primary_weapon(false);
					pm:add_waypoint(current_sunit.pos_art_defence_main, true, -1, current_sunit.orient_art_defence_main, current_sunit.width_art_defence_main);

					pm:start();
				end
			);
		end;
	end;
end;



function move_enemy_artillery_defence_to_main()
	for i = 1, sunits_enemy_artillery_defenders:count() do
		local current_sunit = sunits_enemy_artillery_defenders:item(i);
		current_sunit.uc:goto_location_angle_width(current_sunit.pos_art_defence_main, current_sunit.orient_art_defence_main, current_sunit.width_art_defence_main, true);
	end;
end;



function advance_enemy_artillery_defence()
	local player_armies = bm:get_player_alliance():armies();
	for i = 1, sunits_enemy_artillery_defenders:count() do
		local current_sunit = sunits_enemy_artillery_defenders:item(i);

		local pm = patrol_manager:new(
			current_sunit.name .. "_artillery_defence",
			current_sunit,
			player_armies,
			45,
			60,
			60
		);

		-- pm:set_debug(true);
		pm:set_stop_on_rout(true);
		pm:set_intercept_time(-1);
		pm:add_waypoint(current_sunit.pos_art_defence_advance, true, -1, current_sunit.orient_art_defence_advance, current_sunit.width_art_defence_advance);

		pm:start();
	end;
end;










local alm_waypoints = {
	{
		v(54, -118), 
		v(55, -10)
	},
	{
		v(35, -128),
		v(35, -10)
	},
	{
		v(25, -126),
		v(25, -10)
	},
	{
		v(15, -124),
		v(15, -10)
	},
	--[[
	{
		v(5, -122),
		v(5, -10)
	},
	]]
	{
		v(0, -120),
		v(0, -5)
	},
	{
		v(-15, -118),
		v(-15, 0)
	},
	{
		v(-25, -116),
		v(-25, 5)
	},
	{
		v(-35, -114),
		v(-35, 10)
	},
	{
		v(-140, 20),
		v(-30, 10)
	},
	{
		v(-153, 25),
		v(-70, 50)
	},
	{
		v(-165, 20),
		v(-40, 58)
	}
};


alm_main_attack = attack_lane_manager:new("main_attack", sunits_enemy_main);
alm_main_attack:set_debug(true);

-- main entrance
for i = 1, #alm_waypoints do
	alm_main_attack:add_lane(unpack(alm_waypoints[i]));	
end;

--[[
alm_main_attack:add_lane(v(54, -118), v(55, -10));
alm_main_attack:add_lane(v(35, -128), v(35, -10));
alm_main_attack:add_lane(v(25, -126), v(25, -10));
alm_main_attack:add_lane(v(15, -124), v(15, -10));
alm_main_attack:add_lane(v(5, -122), v(5, -10));
alm_main_attack:add_lane(v(-5, -120), v(-5, -5));
alm_main_attack:add_lane(v(-15, -118), v(-15, 0));
alm_main_attack:add_lane(v(-25, -116), v(-25, 5));
alm_main_attack:add_lane(v(-35, -114), v(-35, 10));
alm_main_attack:add_lane(v(-45, -114), v(-45, 15));

-- side entrance
alm_main_attack:add_lane(v(-140, 20), v(-30, 10));
alm_main_attack:add_lane(v(-153, 25), v(-70, 50));
alm_main_attack:add_lane(v(-165, 20), v(-40, 58));
]]




alm_main_defence = attack_lane_manager:new("main_defence", sunits_allied_main);

for i = 1, #alm_waypoints do
	alm_main_defence:add_lane(alm_waypoints[i][1]);	
end;




















-- starting enemy meander start positions
--[[
sunit_enemy_01.pos_meander_start = v(220.0, -220);
sunit_enemy_01.pos_meander_end = v(225, -260);
sunit_enemy_01.orient_meander = r_to_d(-1.75);
sunit_enemy_01.width_meander = 1.4;

area_phase_one_combat = convex_area:new({
	v(320, -90),
	v(530, -470),
	v(85, -470),
	v(85, -90)
});
]]

-- declared at bottom of file for ordering purposes
sunit_allies_20.turn_to_face_target = sunit_enemy_17;
sunit_allies_21.turn_to_face_target = sunit_enemy_18;
sunit_allies_22.turn_to_face_target = sunit_enemy_19;



