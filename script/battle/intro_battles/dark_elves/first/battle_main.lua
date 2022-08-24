

output_uicomponent_on_click();

bm:setup_battle(function() play_cutscene_intro() end);

bm:register_phase_change_callback(
	"Deployment", 
	function()
		-- prevent UI hiding
		bm:enable_ui_hiding(false);
		
		-- show the cutscene borders immediately
		bm:enable_cinematic_ui(true, false, true);
	
		core:progress_on_loading_screen_dismissed(function() start_deployment_phase() end, "custom_loading_screen");
	end
);



function start_deployment_phase()	

	-- set up a listener which overrides the loading screen if the player skips
	override_loading_screen_on_skip();

	-- hide user interface
	bm:show_ui(false);
	bm:show_ui_options_panel(false)
	bm:show_start_battle_button(false);
	
	-- help panel does not close when ESC menu opened
	get_help_page_manager():set_close_on_game_menu_opened(false);
	
	-- prevent pausing
	bm:disable_shortcut("toggle_pause", true);
	
	-- prevent tactical map
	bm:disable_shortcut("show_tactical_map", true);
	
	-- prevent battle speed toggling
	bm:disable_shortcut("cycle_battle_speed", true);
	
	-- prevent first-person camera
	bm:disable_shortcut("context_camera", true);
	
	-- prevent UI hiding
	bm:enable_ui_hiding(false);
	
	-- prevent grouping and formations
	bm:disable_shortcut("toggle_group", true);
	bm:disable_groups(true);
	bm:disable_formations(true);
	
	-- force minimised tooltips
	bm:force_minimised_tooltips(true);
	
	-- disable spell browser button
	bm:enable_spell_browser_button(false);
	
	-- disable the ? help page button
	get_help_page_manager():enable_menu_bar_index_button(false);
	
	-- play intro movie
	-- bm:play_movie("Warhammer/race_intro_vmp", true);
	
	-- watch for intro movie finishing
	bm:watch(
		function() return not bm:is_movie_playing() end,
		0,
		function()
			bm:end_current_battle_phase();
			bm:set_volume(VOLUME_TYPE_MUSIC, 100);
			bm:set_volume(VOLUME_TYPE_SFX, 100);
			bm:set_volume(VOLUME_TYPE_VO, 100);
		end,
		"movie_finished"
	);
end;



















function start_battle()
	
	bm:set_close_queue_advice(false);
	
	show_advisor_progress_button(true);
	
	-- ensure player cannot move their forces
	sunits_player_start:take_control();
	
	if core:is_tweaker_set("SKIP_SCRIPTED_CONTENT_4") then
		jump_to_phase_two();
	else
		bm:callback(function() start_camera_advice() end, 1000);
	end;
	
	-- bm:callback(function() opening_battle_completed() end, 1000); 
	-- prepare_to_bring_on_mounted_reinforcements();
end;












---------------------------------------------------------
--
-- camera advice
--
---------------------------------------------------------

function start_camera_advice()
	local cam = bm:camera();
	local cam_pos = cam:position();
	local cam_targ = cam:target();
	
	--
	-- Lord marker
	--
		
	local camera_marker_general = intro_battle_camera_marker:new(
		"general_marker",
		v_offset(sunit_player_01.unit:position(), 0, 2, 0),
		-- Your warriors rally behind your awesome presence, dread sire. Your power is such that it may carry any battle; be sure to use it wisely!
		"wh2.battle.intro.021"
	);
	camera_marker_general:set_advisor_delay(1000);
	camera_marker_general:set_advisor_duration(10000);
	camera_marker_general:add_infotext(1, "wh2.battle.intro.info_010", "wh2.battle.intro.info_011", "wh2.battle.intro.info_012");
	
	camera_marker_general:action(
		function()
			local unit = sunit_player_01.unit;
			-- local pos_officer = unit:position_of_officer();
			local pos_officer = unit:position();
		
			local h_camera_bearing = 30;
			local v_camera_bearing = 12;
			local camera_distance = 10;
			
			local camera_pos = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
			
			cam:move_to(camera_pos, v_offset(pos_officer, 0, 1, 0), 2.5, false, 40) 
		end, 
		0
	);
	
	camera_marker_general:action(
		function()
			local unit = sunit_player_01.unit;
			-- local pos_officer = v_offset(unit:position_of_officer(), 0, 1.3, 0);
			local pos_officer = v_offset(unit:position(), 0, 1.3, 0);
		
			local h_camera_bearing_start = 20;
			local h_camera_bearing_end = -10;
			local v_camera_bearing_start = 5;
			local v_camera_bearing_end = 5;
			local camera_distance = 4;
			
			local camera_pos_start = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_start, v_camera_bearing_start, camera_distance);
			local camera_pos_end = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_end, v_camera_bearing_end, camera_distance);
			
			cam:move_to(camera_pos_start, pos_officer, 0, false, 40) 
			cam:move_to(camera_pos_end, pos_officer, 8, true, 40) 
		end, 
		4500
	);
	
	camera_marker_general:action(
		function()
			local unit = sunit_player_01.unit;
			-- local pos_officer = v_offset(unit:position_of_officer(), 0, 1.3, 0);
			local pos_officer = v_offset(unit:position(), 0, 1.3, 0);
		
			local h_camera_bearing_start = 2;
			local h_camera_bearing_end = 2;
			local v_camera_bearing_start = 10;
			local v_camera_bearing_end = 10;
			local camera_distance_start = 4;
			local camera_distance_end = 40;
			
			local camera_pos_start = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_start, v_camera_bearing_start, camera_distance_start);
			local camera_pos_end = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing_end, v_camera_bearing_end, camera_distance_end);
			
			cam:move_to(camera_pos_start, pos_officer, 0, false, 40) 
			cam:move_to(camera_pos_end, pos_officer, 40, false, 40) 
		end, 
		12500
	);
	
	--
	-- Army marker
	--
	
	local camera_marker_army = intro_battle_camera_marker:new(
		"army_marker",
		v_offset(sunit_player_03.unit:position(), 0, 2, 0),
		-- Your Druchii soldiers are ready for battle, Malekith, my King. Each one of them yearns to spill the blood of the enemy in your name.
		"wh2.battle.intro.011"
	);
	camera_marker_army:set_advisor_delay(1000);
	camera_marker_army:set_advisor_duration(9000);
	camera_marker_army:add_infotext(1, "wh2.battle.intro.info_001", "wh2.battle.intro.info_002", "wh2.battle.intro.info_003");
	
	camera_marker_army:action(
		function()
			local unit = sunit_player_04.unit;
			local pos_officer = unit:position();
		
			local h_camera_bearing = 30;
			local v_camera_bearing = 12;
			local camera_distance = 20;
			
			local camera_pos = get_tracking_offset(pos_officer, unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
			
			cam:move_to(camera_pos, v_offset(pos_officer, 0, 1, 0), 2.5, false, 40) 
		end, 
		0
	);
	
	camera_marker_army:action(
		function()
			local start_unit = sunit_player_04.unit;
			local pos_officer_start = v_offset(start_unit:position(), 0, 1.0, 0);
			
			local end_unit = sunit_player_03.unit;
			local pos_officer_end = v_offset(end_unit:position(), 0, 0.2, 0);
			
			local h_camera_bearing = 50;
			local v_camera_bearing = 7;
			local camera_distance = 12;
			
			local camera_pos_start = get_tracking_offset(pos_officer_start, start_unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
			local camera_pos_end = get_tracking_offset(pos_officer_end, end_unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
			
			cam:move_to(camera_pos_start, pos_officer_start, 0, false, 40);
			cam:move_to(camera_pos_end, pos_officer_end, 40, true, 40);
		end, 
		6000
	);
	
	--
	-- Hill marker
	--
	
	local camera_marker_hill = intro_battle_camera_marker:new(
		"hill_marker",
		v(-6, 155.1, -353), 
		-- The hills and valleys of this place conceal the enemy's whereabouts, my Lord. This hilltop should afford a good view over the surrounding area.
		"wh2.battle.intro.030",
		100
	);
	
	camera_marker_hill:set_advisor_delay(1000);
	camera_marker_hill:set_advisor_duration(9000);
	
	camera_marker_hill:add_infotext(1, "wh2.battle.intro.info_005", "wh2.battle.intro.info_006");
	
	camera_marker_hill:action(function() cam:move_to(v(-45.5, 172.1, -366.5), v(34.4, 165.0, -364.8), 3, false, 55) end, 0);
	
	camera_marker_hill:action(function() cam:move_to(v(-64.0, 176.6, -381.2), v(12.9, 173.2, -358.5), 0, false, 50) end, 4500);
	camera_marker_hill:action(function() cam:move_to(v(-64.0, 176.6, -381.2), v(-104.3, 163.1, -313.3), 40, false, 50) end, 4500);
	
	--
	-- Container
	--
	
	local ca = intro_battle_camera_positions_advice:new(
		-- The foul musk of vermin drifts on the air, your majesty - the Skaven are close. Survey the area for yourself.
		"wh2.battle.intro.002",
		sunits_player_start,
		-- Survey the points of interest
		"wh2.battle.intro.camera_advice.001",
		function() start_general_selection_advice(cam_pos, cam_targ) end,
		{camera_marker_general, camera_marker_army, camera_marker_hill}
	);
	
	-- ca.should_skip = true;	-- uncomment to immdiately skip camera advice section
	ca:start();
end;




function start_general_selection_advice(cam_pos, cam_targ)

	-- allow pausing again
	bm:disable_shortcut("toggle_pause", false);

	local sa = intro_battle_selection_advice:new(
		-- The time has come to advance, my Lord. Select your own unit, and you will be able to rejoin your forces.
		"wh2.battle.intro.040",
		v(-242.9, 134.6, -150.7),
		v(-180.1, 113.2, -191.8),
		sunits_player_general,
		"wh2.battle.intro.general_selection_advice.001", 
		function() start_general_movement_advice() end
	);
	
	sa:add_infotext(
		1,
		"wh2.battle.intro.info_020",
		"wh2.battle.intro.info_021"
	);
	
	sa:set_all_player_sunits(sunits_player_start);
	sa:set_should_enable_unit_cards(false);
	sa:set_should_disable_camera(true);
	sa:set_enable_orders_on_end(false);
	sa:set_marker_position(v_offset(sunit_player_01.unit:position(), 0, 2, 0));
	
	sa:start();
end;



pos_lord_movement = v(-188, 119, -218);

function start_general_movement_advice()
	
	local ma = intro_battle_movement_advice:new(
		-- Good! Now, issue a move order towards your army. The troops are assembled, and await your arrival.
		"wh2.battle.intro.050",
		pos_lord_movement,
		sunits_player_general, 
		"wh2.battle.intro.movement_advice.001",
		function() bm:callback(function() transition_to_army_selection_advice() end, 3000); end
	);
	
	ma:set_allow_orders_on_advice_delivery(true);
	ma:set_prevent_orders_after_movement(true);
	ma:set_should_disable_camera(true);
	ma:set_advisor_delay(500);
	
	ma:add_infotext(
		1,
		"wh2.battle.intro.info_030",
		"wh2.battle.intro.info_031"
	);
	
	ma:start();
end;




function transition_to_army_selection_advice()
	bm:out("transition_to_army_selection_advice() called");
	
	-- order Lord into correct position
	move_lord_to_army();
	
	-- disable further movement
	bm:disable_orders(true);
	
	-- play cutscene
	play_cutscene_transition_to_army_selection_advice();
	
	bm:callback(
		function()
			-- Excellent! Your place is amongst your warriors, mighty Lord. Your very presence encourages them to fight harder.
			bm:stop_advisor_queue(true);
			bm:queue_advisor("wh2.battle.intro.042");
			bm:add_infotext(
				1,
				"wh2.battle.intro.info_010",
				"wh2.battle.intro.info_013",
				"wh2.battle.intro.info_014"
			);
		end,
		500
	);
end;


function move_lord_to_army(should_teleport)
	if should_teleport then
		sunit_player_01.uc:teleport_to_location(pos_lord_movement, sunit_player_02.unit:bearing(), sunit_player_01.unit:ordered_width());
	else
		sunit_player_01.uc:goto_location_angle_width(pos_lord_movement, sunit_player_02.unit:bearing(), sunit_player_01.unit:ordered_width(), true);		
	end;
	sunit_player_01.uc:release_control();
end;



function wait_before_start_army_selection_advice()
	-- if we skipped the cutscene, don't wait for the advisor
	if bool_cutscene_transition_to_army_selection_advice_skipped then
		bm:callback(function() start_army_selection_advice() end, 1000);
		return;
	end;
	
	-- highlight the advisor close button when it's finished playing
	bm:watch(
		function()
			return bm:advice_finished()
		end,
		0,
		function()
			show_advisor_progress_button();
			highlight_advisor_progress_button(true);
		end,
		"wait_before_start_army_selection_advice"
	);
	
	-- proceed when the advisor is dismissed
	core:add_listener(
		"wait_before_start_army_selection_advice",
		"AdviceDismissed",
		true,
		function()
			highlight_advisor_progress_button(false);
		
			bm:remove_process("wait_before_start_army_selection_advice");
			bm:callback(
				function() 
					show_advisor_progress_button(false);
					start_army_selection_advice() 
				end, 
				500
			);
		end,
		false
	);
end;


function start_army_selection_advice()

	-- allow unit movement
	bm:disable_orders(true);
	
	local sa = intro_battle_selection_advice:new(
		-- The time has come to advance your warriors, my Lord. Select your whole army, so that the order may be given to all.
		"wh2.battle.intro.041", 
		v(-260.0, 157.1, -244.5),
		v(-185.5, 137.2, -251.3),
		sunits_player_start, 
		"wh2.battle.intro.army_selection_advice.001", 
		function() start_army_movement_advice() end
	);
	
	sa:add_infotext(
		1,
		"wh2.battle.intro.info_020",
		"wh2.battle.intro.info_022",
		"wh2.battle.intro.info_023",
		"wh2.battle.intro.info_024"
	);
	
	sa:set_should_enable_unit_cards(true);
	
	sa:start();
end;




function start_army_movement_advice()

	-- show marker position
	local marker_pos = v(-4, 134, -248);
	
	local ma = intro_battle_movement_advice:new(
		-- Good! Now, order your army forward, my Lord. Let us find where the enemy lies.
		"wh2.battle.intro.051",
		marker_pos,
		sunits_player_start, 
		"wh2.battle.intro.movement_advice.002",
		function() start_maneouvring_advice(marker_pos) end
	);
	
	ma:set_advisor_delay(500);
	ma:set_remove_marker_on_end(false);
	
	ma:start();
end;



function start_maneouvring_advice(marker_pos)

	local ma = intro_battle_maneouvring_advice:new(
		-- Excellent! Your army advance in search of the enemy, my Lord. Take this time to practice manoeuvring your forces while not under threat of attack. Remember, always, that orders are issued only to units currently selected.
		"wh2.battle.intro.060",
		sunits_player_start,
		sunits_enemy_start,
		"wh2.battle.intro.maneouvring_advice.001",
		function() 
			bm:remove_ping_icon(marker_pos:get_x(), marker_pos:get_y(), marker_pos:get_z());
			prepare_to_start_advancing_advice() 
		end											-- called when enemy become visible
	);
	
	ma:add_infotext(
		1,
		"wh2.battle.intro.info_050",
		"wh2.battle.intro.info_051",
		"wh2.battle.intro.info_052"
	);
	
	bm:callback(function() ma:start() end, 2000);
	
	start_enemy_meandering();
	
	-- warn if player's forces are separated during the advance
	bm:watch(
		function()
			local sunit, distance = sunits_player_start:get_outlying();
			if distance > 70 then
				return true;
			end;
		end,
		0,
		function()
			 warn_of_force_separation();
		end,
		"warn_if_players_forces_separated_during_advance"
	);
	
	-- add info to reminder panel
	bm:callback(function() append_selection_controls_to_cheat_sheet() end, 1000);
end;


function prepare_to_start_advancing_advice()

	-- have the enemy turn to face the player
	stop_enemy_meandering();
	
	bm:remove_process("warn_if_players_forces_separated_during_advance");
	
	-- delay the advice and cutscene so that the enemy have time to fully turn
	bm:callback(function() start_attacking_advice() end, 3000);
end;
	
	
function start_attacking_advice()
	
	-- clear infotext
	bm:clear_infotext();
	
	-- play the cutscene
	play_cutscene_enemy_encounter();
	
	-- halt player units as they become visible
	bm:repeat_callback(function() halt_visible_player_units() end, 1000, "halt_visible_player_units");
	
	-- have the enemy try to form up when the cutscene is completed
	core:add_listener(
		"intro_battle_advancing_advice",
		"ScriptEventBattleCutsceneEnded",
		true,
		function()
		
			-- add info to the reminder panel
			bm:callback(function() append_movement_controls_to_cheat_sheet() end, 1000);
		
			bm:remove_process("halt_visible_player_units");
			form_up_enemy();
			
			bm:callback(function() warn_if_players_forces_separated_during_attack() end, 3000);
		end,
		false
	);
	
	local aa = intro_battle_attacking_advice:new(
		-- The enemy come into sight, my Lord! We have caught them out of position: advance quickly, and sieze the initiative!
		"wh2.battle.intro.070",
		v(160, 116, -240),
		"wh2.battle.intro.movement_advice.003",
		-- The foolish rats dare to resist your advance, sire. Attack, slaughter them, and take the pitiful survivors as slaves!
		"wh2.battle.intro.091",
		sunits_player_start,
		sunits_enemy_start,
		"wh2.battle.intro.attack_advice.001",
		function() bm:callback(function() start_monitoring_advice() end, 1000) end
	);
	
	aa:set_advance_threshold(155);
	
	aa:add_attacking_infotext(
		1,
		"wh2.battle.intro.info_060",
		"wh2.battle.intro.info_061"
	);
	
	aa:set_min_attacking_advice_duration(10000);
		
	-- Assign individual targets for your units when attacking, my Lord. Keep them in a wide formation: do not let them get surrounded!
	aa:set_follow_up_advice("wh2.battle.intro.095");
	
	aa:add_attacking_area(
		convex_area:new({
			v(200, -250),
			v(80, -120),
			v(200, -120)
		})
	);
	
	aa:add_attacking_area(
		convex_area:new({
			v(200, -350),
			v(200, -530),
			v(-10, -530)
		})
	);
	
	aa:add_attacking_area(
		convex_area:new({
			v(-100, 0),
			v(-100, -700),
			v(-1000, -700),
			v(-1000, 0) 
		})
	);	
	
	aa:start();
	
	-- set player's forces to be unkillable
	sunits_player_start:max_casualties(0.7, true);
	
	-- set enemy forces to be fearless
	sunits_enemy_start:morale_behavior_fearless();
	
	-- run enemy into position after a little bit (if they're not already attacking)
	bm:callback(
		function()
			if not aa:are_enemy_attacking() then
				form_up_enemy(true);
			end;
		end, 
		20000
	);
end;


area_initial_hill = convex_area:new({
	v(-20, -100),
	v(90, -100),
	v(90, -530),
	v(-70, -530)
});



function warn_if_players_forces_separated_during_attack()

	for i = 1, sunits_player_start:count() do
		if not area_initial_hill:is_in_area(sunits_player_start:item(i)) then
			warn_of_force_separation();
			return;
		end;
	end;
end;



bool_player_warned_of_force_separation = false;

function warn_of_force_separation()
	if bool_player_warned_of_force_separation then
		return;
	end;

	bool_player_warned_of_force_separation = true;

	bm:queue_advisor(
		-- Be sure to advance with all your warriors at once, my Lord! You risk becoming overwhelmed if you engage piecemeal.
		"wh2.battle.intro.080"
	);
end;





function start_monitoring_advice()
	bm:out("start_monitoring_advice() called");
		
	-- prevent enemy units rallying if they rout
	sunits_enemy_start:prevent_rallying_if_routing(true);
	
	-- unforce minimised tooltips
	bm:force_minimised_tooltips(false);
	
	local monitoring_advice_duration = 30000;
	
	bm:stop_advisor_queue(true);
	bm:queue_advisor(
		-- Be sure to keep watch on your warriors in battle, my Lord! Their very lives depend upon it!
		"wh2.battle.intro.100",
		monitoring_advice_duration
	);
	
	bm:clear_infotext();
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_070",
		"wh2.battle.intro.info_071",
		"wh2.battle.intro.info_072"
	);
		
	-- wait before potentially triggering routing advice
	bm:callback(
		function()
			sunits_enemy_start:morale_behavior_default();
			sunits_enemy_start:rout_on_casualties(0.3);
			monitor_for_routing();
		end, 
		monitoring_advice_duration
	);
	
	-- add info to the reminder panel
	bm:callback(
		function()
			append_attack_controls_to_cheat_sheet();
		end,
		1000
	);
end;










function monitor_for_routing()
	bm:out("monitor_for_routing() called");
	
	-- make the player's units vulnerable to damage if they are spread out (i.e. the player has engaged piecemeal)
	make_army_vulnerable_if_separated(
		sunits_player_start,			-- player's sunits
		sunits_enemy_start, 			-- enemy sunits
		50,								-- threshold distance
		0.7,							-- max number of casualties the player's forces can take when all are close to enemy
		30000							-- also begin to kill the enemy units over this amount of time if the player's forces are together
	);
	
	local ra = intro_battle_routing_advice:new(
		sunits_player_start,
		sunits_enemy_start,
		-- Haha! The enemy begin to crumble! They run from the battle!
		"wh2.battle.intro.110",							-- advice for if enemy units start to rout
		-- Your forces have been defeated in detail, my Lord. They run from the battle! Let us retreat and regroup!
		"wh2.battle.intro.120",							-- advice for if the players units start to rout
		function() opening_battle_completed() end,		-- function to call when all enemy sunits rout
		function() rout_player_army() end				-- function that routs the player army (over time)		
	);
	
	ra:add_enemy_routs_infotext(
		1, 
		"wh2.battle.intro.info_080",
		"wh2.battle.intro.info_081",
		"wh2.battle.intro.info_082",
		"wh2.battle.intro.info_083"
	);
	
	ra:add_player_routs_infotext(
		1, 
		"wh2.battle.intro.info_080",
		"wh2.battle.intro.info_081",
		"wh2.battle.intro.info_082",
		"wh2.battle.intro.info_084"
	);
	
	ra:start();
end;




pos_cam_reposition_player_phase_two = v(266.1, 148.9, -344.8);
pos_targ_reposition_player_phase_two = v(315.7, 132.9, -292.6);

function opening_battle_completed()
	bm:out("opening_battle_completed() called");
	
	stop_make_army_vulnerable_if_separated();
	
	sunits_enemy_phase_two:deploy_reinforcement(true);
	
	bm:callback(
		function()
			sunits_player_start:halt();
			
			if should_reposition_player_army_for_phase_two() then
				-- if we are going to need to reposition the player's army for phase two, also restore the camera to a known point
				cutscene_enemy_reinforcements:set_restore_cam(2, pos_cam_reposition_player_phase_two, pos_targ_reposition_player_phase_two);
				bool_should_reposition_player_army_for_phase_two = true;
			else
				-- otherwise, reposition the camera relative to the player's army
				local cam_targ = v_offset(sunits_player_start:centre_point(), 0, 10, 0);
				local cam_pos = v_offset(cam_targ, -42.5, 19, -50);
			
				cutscene_enemy_reinforcements:set_restore_cam(2, cam_pos, cam_targ);
			end;		

			play_cutscene_enemy_reinforcements();
		end,
		1000
	);
end;


bool_enemy_reinforcements_advice_played = false;

function play_enemy_reinforcements_advice()
	if bool_enemy_reinforcements_advice_played then
		return;
	end;
	
	bool_enemy_reinforcements_advice_played = true;
	
	-- The Skaven send more forces to contest the battlefield, your majesty. The situation is grave; they advance in great numbers!
	bm:queue_advisor("wh2.battle.intro.131");
	
end;


bool_ridge_advice_played = false;

function play_ridge_advice()
	if bool_ridge_advice_played then
		return;
	end;
	
	bool_ridge_advice_played = true;
	
	-- Move quickly to defend this ridge, my Lord. The trees will grant your warriors cover and conceal their numbers, while the slope will provide them an advantage in combat.
	bm:queue_advisor("wh2.battle.intro.140");
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_090",
		"wh2.battle.intro.info_091"
	);
end;











---------------------------------------------------------
--
-- PHASE TWO
--
---------------------------------------------------------

function jump_to_phase_two()
	
	-- make all of the phase two enemies deploy
	sunits_enemy_phase_two:deploy_reinforcement(true);
	bm:callback(function() sunits_enemy_phase_two:teleport_to_location_offset(0, 100) end, 1000);

	-- disappear the phase one enemies
	sunits_enemy_start:kill(true);
	
	-- reposition player's forces
	bool_should_reposition_player_army_for_phase_two = true;
	reposition_phase_two_player_army_if_appropriate();
	
	sunits_player_start:release_control();
	
	-- reposition camera
	cam:move_to(pos_cam_reposition_player_phase_two, pos_targ_reposition_player_phase_two, 0, false, 0);
		
	-- show cheat sheet panel
	bm:callback(
		function()
			show_battle_controls_cheat_sheet();
			append_selection_controls_to_cheat_sheet();
			append_movement_controls_to_cheat_sheet();
			append_attack_controls_to_cheat_sheet();
		end,
		1000
	);
	
	-- show ui
	bm:show_army_panel(true);
	
	bm:callback(function() start_phase_two() end, 200);
end;


sai_enemy_phase_two = false;
pos_ridge = v(500, 155, -30);

function start_phase_two()

	-- ensure player has no invulnerability (they only earn it if they capture the ridge)
	sunits_player_start:max_casualties(0, true);

	-- assemble the enemy into an ai planner
	sai_enemy_phase_two = script_ai_planner:new("enemy_phase_two", sunits_enemy_phase_two);

	-- start the enemy patrol
	start_phase_two_enemy_patrol();
	
	-- make the enemy fearless
	sunits_enemy_phase_two:morale_behavior_fearless();
		
	local ma = intro_battle_movement_advice:new(
		-- Advance upon the ridge without delay, my Lord! That position offers you the best chance of victory against such a number. Go, quickly!
		"wh2.battle.intro.145",
		pos_ridge,
		sunits_player_start_and_missile, 
		"wh2.battle.intro.defensive_advice.001",
		function() bool_phase_two_player_has_contacted_enemy = true end
	);
	
	ma:set_end_on_marker_reached(true);
	ma:remove_objective_on_proximity_to_enemy(sunits_enemy_phase_two, 50);
	
	ma:start();
	
	-- watch for player moving and bring on reinforcements
	sunits_player_start:cache_location();
	
	bm:watch(
		function()
			return sunits_player_start:have_all_moved();
		end,
		5000,
		function()
			-- start_phase_two_abilities_advice();
			phase_two_bring_on_player_missiles()
		end,
		"phase_two_bring_on_player_reinforcements"
	);
	
	-- bring on reinforcements after a while anyway
	bm:callback(function() phase_two_bring_on_player_missiles() end, 60000, "phase_two_bring_on_player_reinforcements");
end;


function start_phase_two_enemy_patrol()
	
	if not sai_enemy_phase_two then
		script_error("ERROR: start_phase_two_enemy_patrol() called but sai_enemy_phase_two not set up");
		return false;
	end;

	sai_enemy_phase_two:patrol(
		{
			v(460, 300)
		},
		sunits_player_all,
		function()
			sai_enemy_phase_two:attack_force(sunits_player_all);
		end
	);
end;




bool_phase_two_combatants_halted_for_missile_reinforcements = false;

function phase_two_bring_on_player_missiles()
	bm:remove_process("phase_two_bring_on_player_reinforcements");
	
	-- aLLow reinforcements to deploy
	sunits_player_missile_reinforcements_melee_only:deploy_reinforcement(true);
	bm:callback(function() sunits_player_missile_reinforcements_missiles_only:deploy_reinforcement(true) end, 1000);
	
	
	-- prevent reinforcing units from being controllable prematurely
	for i = 1, sunits_player_missile_reinforcements:count() do
		local current_sunit = sunits_player_missile_reinforcements:item(i);
		bm:watch(
			function() return has_deployed(current_sunit) end,
			0,
			function() current_sunit:take_control() end
		);
	end;
		
	-- play missile reinforcements cutscene when all missile reinforcements are deployed
	bm:watch(
		function()
			return has_deployed(sunits_player_missile_reinforcements);
		end,
		0,
		function()
		
			-- A HACK - order all units to stand in a line
			for i = 1, sunits_player_missile_reinforcements:count() do
				local current_sunit = sunits_player_missile_reinforcements:item(i);				
				current_sunit.uc:goto_location(v(763, current_sunit.unit:position():get_z()), true);
				current_sunit:release_control();
			end;
			
			local delay = 0;
			
			bm:callback(
				function()
					-- cache current camera position
					bm:cache_camera();
					play_cutscene_player_missile_reinforcements();
				end,
				delay
			);
			
			bm:callback(
				function()
					if bm:is_any_cutscene_running() then
						bool_phase_two_combatants_halted_for_missile_reinforcements = true;
					
						-- halt player units
						sunits_player_start:cache_destination_and_halt();
						
						-- halt enemy units by removing them from the ai controller and halting them
						sai_enemy_phase_two:remove_sunits(sunits_enemy_phase_two);
						sunits_enemy_phase_two:halt();
					end;
				end,
				delay + 500
			);
		end	
	);
end;


function play_missile_reinforcements_advice()
	-- Allies come into view, sire! Press them into your service at once. Some amongst their number carry crossbows; they will be able to fire on the ratmen from behind your frontlines.
	bm:queue_advisor("wh2.battle.intro.151");
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_100",
		"wh2.battle.intro.info_101",
		"wh2.battle.intro.info_102"
	);
end;



function cutscene_player_missile_complete()
	-- restart units if they stopped
	if bool_phase_two_combatants_halted_for_missile_reinforcements then
		sunits_player_start:goto_cached_destination(true);
		
		sai_enemy_phase_two:add_sunits(sunits_enemy_phase_two);
		start_phase_two_enemy_patrol();
	end;
	
	bm:clear_infotext();
	
	bm:callback(
		function()
			-- The reinforcements now fall under your control, my Lord. Move the infantry into your front line, the extra bodies are sorely needed.
			bm:queue_advisor(
				"wh2.battle.intro.160",
				10000
			);
		end,
		2500
	);
	
	-- this advice is enqueued behind the previous
	bm:callback(
		function()
			-- Arrange your fresh missile troops behind your army. They will fire automatically if the enemy come into range.
			bm:queue_advisor(
				"wh2.battle.intro.161",
				10000,
				false,
				function()
					bm:add_infotext(
						1,
						"wh2.battle.intro.info_100",
						"wh2.battle.intro.info_103",
						"wh2.battle.intro.info_104"
					);
				end
			);
		end,
		4000
	);
	
	bm:callback(function() play_battle_line_advice() end, 60000);
end;


bool_defend_ridge_objective_shown = false;

function play_battle_line_advice()

	-- Be sure to arrange your infantry in a line for the coming battle, my Lord. Each unit should cover the flank of the next. Do not let the enemy attack the sides of your formation, or break through to the rear!
	bm:queue_advisor("wh2.battle.intro.170");
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_110",
		"wh2.battle.intro.info_111",
		"wh2.battle.intro.info_112"
	);

	
	-- watch for the player closing on the ridge
	bm:watch(
		function()
			return is_close_to_position(sunits_player_start_and_missile, pos_ridge, 40, true);
		end,
		0,
		function()
			-- make player units unroutable now they've reached the ridge
			sunits_player_start_and_missile:fearless_until_casualties(0.55, true);
			sunits_player_start_and_missile:max_casualties(0.55, true);
		
			-- Excellent, my Lord! The ridge is yours. Arrange your infantry out to block the pass, and await the enemy's arrival. Do not be tempted out of position!
			bm:queue_advisor(
				"wh2.battle.intro.175",
				11000,
				false,
				function()
					bool_defend_ridge_objective_shown = true;
					bm:set_objective("wh2.battle.intro.defensive_advice.003");
				end				
			);
		end,
		"player_closing_on_ridge_advice"
	);
	
	-- watch for the two sides closing
	bm:watch(
		function() 
			return distance_between_forces(sunits_player_start_and_missile, sunits_enemy_phase_two) < 100;
		end,
		0,
		function()
			start_monitor_for_abilities_advice();
		end
	);
end;



function start_monitor_for_abilities_advice()
	bm:remove_process("player_closing_on_ridge_advice");
	
	if bool_defend_ridge_objective_shown then
		bm:complete_objective("wh2.battle.intro.defensive_advice.003");
		bm:callback(function() bm:remove_objective("wh2.battle.intro.defensive_advice.003") end, 2000);
	end;
	
	-- watch for the two sides getting very close and start abilities advice
	bm:watch(
		function() 
			return distance_between_forces(sunits_player_start_and_missile, sunits_enemy_phase_two) < 40;
		end,
		0,
		function()
			start_phase_two_abilities_advice()
		end
	);
end;


function start_phase_two_abilities_advice()
	local aa = intro_battle_abilities_advice:new(
		-- The enemy are nearly upon you, my Lord! Be sure to make your presence felt in the coming battle: you have many abilities to rally and empower your troops. Be sure to use them!
		"wh2.battle.intro.180",
		sunit_player_01,
		sunits_player_all,
		sunits_enemy_phase_two,
		"wh2.battle.intro.general_selection_advice.001",
		"wh2.battle.intro.abilities_advice.001",
		function() phase_two_battle_joined() end
	);
	
	aa:add_infotext(
		1,
		"wh2.battle.intro.info_120",
		"wh2.battle.intro.info_121",
		"wh2.battle.intro.info_122"
	
	);
	
	aa:start();
end;


function phase_two_battle_joined()

	sunits_enemy_phase_two:prevent_rallying_if_routing(true);

	-- watch for player being defeated
	bm:watch(
		function()
			return is_routing_or_dead(sunits_player_start_and_missile) and (not bool_player_cavalry_has_engaged or is_routing_or_dead(sunits_player_cavalry_reinforcements));
		end,
		0,
		function()
			player_has_lost_phase_two();
		end,
		"phase_two_battle"
	);
	
	bm:callback(
		function()
			bm:queue_advisor(
				-- Battle has been joined. Order your forces forward to envelop the enemy where possible, my Lord. Do not leave troops idle!
				"wh2.battle.intro.185",
				10000
			);
			bm:modify_advice(true);
		end,
		10000
	);
		
	bm:setup_victory_callback(function() player_has_won_phase_two() end);

	-- bring on cavalry reinforcements for the player
	bm:callback(function() prepare_to_bring_on_mounted_reinforcements() end, 80000, "phase_two_battle");
end;


function prepare_to_bring_on_mounted_reinforcements()
	-- fade to black
	cam:fade(true, 0.5);
	
	-- make player and enemies invulnerable to damage
	sunits_player_start_and_missile:set_invincible(true);
	sunits_enemy_phase_two:set_invincible(true);
	
	-- make player and enemies un-routable
	sunits_player_start_and_missile:morale_behavior_fearless();
	sunits_enemy_phase_two:morale_behavior_fearless();
	
	-- cache missiles
	sunits_player_start_and_missile:cache_ammo();
	sunits_enemy_phase_two:cache_ammo();
	
	bm:callback(function() bring_on_mounted_reinforcements() end, 500, "phase_two_battle");
end;


function bring_on_mounted_reinforcements()
	bm:out("bring_on_mounted_reinforcements() called");

	-- make cavalry appear / teleport
	enable_and_teleport_player_cavalry_reinforcements();
	
	-- order the cavalry forwards - wait a little to allow the unit positions to catch up after teleporting
	bm:callback(function() sunits_player_cavalry_reinforcements:goto_location_offset(0, 70, true, r_to_d(-2.57)) end, 500, "phase_two_battle");
	
	play_cutscene_player_cavalry_reinforcements();	
end;


function play_cavalry_reinforcements_advice()
	-- Mounted reinforcements, my Lord! Hurry them into battle, for they are sorely needed!
	bm:queue_advisor("wh2.battle.intro.190");
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_130",
		"wh2.battle.intro.info_131",
		"wh2.battle.intro.info_132",
		"wh2.battle.intro.info_133"
	);
end;


function cutscene_player_cavalry_complete()
	bm:out("cutscene_player_cavalry_complete() called");
	
	-- make player and enemies vulnerable to damage again
	sunits_player_start_and_missile:set_invincible(false);
	sunits_player_start_and_missile:fearless_until_casualties(0.4, true);
	sunits_player_start_and_missile:max_casualties(0.4, true);
	
	sunits_enemy_phase_two:fearless_until_casualties(0.4);
	sunits_enemy_phase_two:set_invincible(false);
	
	
	-- restore cached missile values
	sunits_player_start_and_missile:restore_cached_ammo();
	sunits_enemy_phase_two:restore_cached_ammo();
	
	-- release control
	sunits_player_cavalry_reinforcements:release_control();
	sunits_player_start_and_missile:release_control();
	sunits_enemy_phase_two:release_control();
	
	-- show cavalry objective
	bm:set_objective("wh2.battle.intro.reinforcements.001");
	
	start_mounted_reinforcement_monitors();
end;



bool_cavalry_closing_with_enemy_advice_delivered = false;

function start_mounted_reinforcement_monitors()
	
	-- watch for cavalry closing with enemy
	bm:watch(
		function()
			return distance_between_forces(sunits_player_cavalry_reinforcements, sunits_enemy_phase_two) < 200
		end,
		0,
		function()
			play_cavalry_closing_advice()
		end,
		"phase_two_battle"
	);
	
	bm:callback(
		function()
			play_cavalry_hurry_up_advice();
		end,
		90000,
		"player_cavalry_hurry_up"
	);
end;


function play_cavalry_hurry_up_advice()
	-- Hurry your troops, my Lord! Those in the fight are beginning to tire!
	bm:queue_advisor("wh2.battle.intro.210");
end;


function play_cavalry_closing_advice()
	bm:remove_process("player_cavalry_hurry_up");
	
	bm:stop_advisor_queue(true);
	bm:queue_advisor(
		-- Your reinforcements approach the battle. Have them charge the enemy rear! The impact alone may break their courage to fight!
		"wh2.battle.intro.200",
		10000,
		false,
		function()
			bm:complete_objective("wh2.battle.intro.reinforcements.001");
		
			bm:add_infotext(
				1,
				"wh2.battle.intro.info_140",
				"wh2.battle.intro.info_141",
				"wh2.battle.intro.info_142",
				function()
					bm:remove_objective("wh2.battle.intro.reinforcements.001");
					bm:set_objective("wh2.battle.intro.reinforcements.002");
					
					-- watch for cavalry fully engaging and complete objective
					bm:watch(
						function()
							return sunits_player_cavalry_reinforcements:is_in_melee()
						end,
						1000,
						function()
							player_cavalry_has_engaged();
						end,
						"phase_two_battle"
					);
				end
			);
		end
	);
end;


bool_player_cavalry_has_engaged = false;

function player_cavalry_has_engaged()
	bool_player_cavalry_has_engaged = true;
	
	-- allow the enemy to rout
	sunits_enemy_phase_two:fearless_until_casualties(0);
	sunits_enemy_phase_two:morale_behavior_default();

	bm:complete_objective("wh2.battle.intro.reinforcements.002");
	bm:callback(function() bm:remove_objective("wh2.battle.intro.reinforcements.002") end, 2000);
end;













---------------------------------------------------------
--
-- DEFEAT
--
---------------------------------------------------------

function stop_phase_two_battle()
	bm:remove_process("phase_two_battle");
	bm:remove_process("player_cavalry_hurry_up");
end;


function player_has_lost_phase_two()
	stop_phase_two_battle()
	bm:stop_advisor_queue(true);
	
	bm:queue_advisor(
		-- The last of your forces flee, my Lord! This battle is lost: let us retreat and regroup!
		"wh2.battle.intro.250"	
	);
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_150",
		"wh2.battle.intro.info_151"
	);
	
	rout_player_army();
	
	bm:callback(
		function()
			bm:end_battle();
		end,
		10000
	);
end;


-- could be called in phase one or phase two
function rout_player_army()
	bm:out("rout_player_army() called");
	
	stop_make_army_vulnerable_if_separated();
	
	sunits_player_all:rout_over_time(10000);
	
	-- force-rout hidden cavalry
	bm:callback(
		function()
			sunits_player_cavalry_reinforcements:set_enabled(true);
			sunits_player_cavalry_reinforcements:kill(true);		
		end,
		10000
	);
end;











---------------------------------------------------------
--
-- VICTORY
--
---------------------------------------------------------

function player_has_won_phase_two()

	-- listen for the player winning the battle, and override the loading screen
	bm:register_phase_change_callback("Complete", function() override_loading_screen() end);

	bm:queue_advisor(
		-- The Skaven abandon the field, as is typical of their cowardly race! I almost pity the wounded they leave behind. Victory is yours!
		"wh2.battle.intro.241"	
	);
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_150",
		"wh2.battle.intro.info_151"
	);
	
	bm:callback(
		function()	
			bm:end_battle();
		end,
		12000
	);
end;










---------------------------------------------------------
--
-- END LOADING SCREEN
--
---------------------------------------------------------

bool_battle_is_being_replayed = false;

function override_loading_screen_on_skip()

	core:add_listener(
		"skip_battle_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_quit" end,
		function() override_loading_screen() end,
		false
	);
	
	core:add_listener(
		"skip_battle_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_rematch" end,
		function() bool_battle_is_being_replayed = true end,
		false
	);
end;


function override_loading_screen()

	if not bool_battle_is_being_replayed then
		bm:out("Overriding loading screen");
		common.set_custom_loading_screen_key("wh2_main_def_naggarond_12");
	end;
end;
