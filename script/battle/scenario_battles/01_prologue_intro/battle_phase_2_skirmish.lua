







---------------------------------------------------------
--
-- start battle
--
---------------------------------------------------------


function start_battle()
	
	-- reposition player army and camera for start of gameplay
	sunits_player_start:teleport_to_start_location();
	cam:move_to(pos_cam_gameplay_start, pos_targ_gameplay_start, 0, false, 0);
	
	bm:set_close_queue_advice(false);
	
	show_advisor_progress_button(true);
	
	-- ensure player cannot move their forces
	sunits_player_start:take_control();

	setup_armies_for_battle_start();

	local uic_unit_info_panel = find_uicomponent(core:get_ui_root(), "info_panel_holder", "UnitInfoPopup")
	if uic_unit_info_panel then 
		uic_unit_info_panel:PropagateVisibility(false) 
	end
	
	if core:is_tweaker_set("SCRIPTED_TWEAKER_04") then
		jump_to_main_attack_phase();
	else
		bm:out("Starting first battle phase");
		hide_skirmish_combatants_for_battle_start();
		bm:callback(function() start_camera_advice() end, 1000);
	end;
	
	-- bm:callback(function() opening_battle_completed() end, 1000); 
	-- prepare_to_bring_on_mounted_reinforcements();
end;

---------------------------------------------------------
------- Check to See if Player Ignores Skirmish ---------
---------------------------------------------------------

-- This area is around the upper part of the battlefield, before the slope.
local skirmish_area = convex_area:new({
	v(63, -673),
	v(50, -387),
	v(80, -28),
	v(780, -178),
	v(650, -775)
})

-- This checks to see if X of the player's forces has left the slope.
bm:repeat_callback(
	function() 
		local counter = 0
		for i = 1, sunits_player_start:count() do 
			if not skirmish_area:standing_is_in_area(sunits_player_start:item(i)) then 
				counter = counter + 1 
			end 
		end
		if counter >= 1 then out("Player has moved bulk of army to restricted area"); player_loss_by_restricted_area() end
	end,
	1000,
	"CheckForStrayUnits"
)

function player_loss_by_restricted_area()
	bm:remove_callback("CheckForStrayUnits")
	sunits_allied_skirmishers:set_invincible_for_time_proportion(0)
	sunits_allied_skirmishers:rout_over_time(0)
	common.setup_dynamic_loading_screen("prologue_battle_1_intro", "prologue")
	out("All allied skirmishers routing")

	bm:queue_advisor(
		"wh3_main_scenario_01_0062",
		10000,
		false,
		function() out("Enemy alliance wins"); bm:restart_battle() end,
		10000
	)

end

---------------------------------------------------------
--
-- camera advice
--
---------------------------------------------------------

function setup_armies_for_battle_start()
	-- make allied army invincible
	sunits_allied_defenders:set_invincible(true);
	
	-- give enemy artillery infinite ammunition and set fire-at-will on
	sunits_enemy_artillery:grant_infinite_ammo();
	sunits_enemy_artillery:change_behaviour_active("fire_at_will", true);
end;


function hide_skirmish_combatants_for_battle_start()
	hide_skirmish_allies();
	hide_skirmish_enemies();
end;




function start_camera_advice()
	
	--
	-- Enemy Army marker
	--
	
	local camera_marker_enemy_army = intro_battle_camera_marker:new(
		"enemy_army_marker",
		v(-46.2, 367.5, -273.7),
		nil,
		250
	);

	camera_marker_enemy_army:set_close_advisor_on_start(true);
	camera_marker_enemy_army:set_cindy_scene("script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_battlelines.CindySceneManager", 0, 0);
	camera_marker_enemy_army:set_restore_cam_time(-1);
	camera_marker_enemy_army:action(
		function() 
			local cutscene_sfx = new_sfx("Play_Movie_WH3_Prologue_Battle_1_Sweetener_Layer_02")
			play_sound_2D(cutscene_sfx)
		end, 
		0
	)

	-- So, the wolf reveals himself. Skollden! 
	
	-- Cannons fire upon the defenders. When the barrage is over, his warriors will attack. Act swiftly! 

	-- Yuri, they shall perish without our help - we must reach them!

	-- What's that there, Brother? In the trees...

	-- An army. Those are Kislev colours. Observe their banners, they are allies!

	camera_marker_enemy_army:add_cinematic_trigger_listener(
		"defenders_push", 
		function()
			-- unhide and move the skirmish forces at this time
			start_skirmish_allies_advance();
			-- set the music to enter the bespoke music action so that we play marching music
			bm:set_music_vm_variable("bespoke_battle_script_actions", "set_marching_loop");		
		end
	);
	
	--
	-- Container
	--
	
	local ca = intro_battle_camera_positions_advice:new(
		-- The Beacon is under siege! See for yourself!
		"wh3_main_scenario_01_0010",
		sunits_player_start,
		-- Survey the points of interest
		"wh3_main_scenario_01_prologue_intro_camera_01",
		function() start_general_selection_advice() end,
		{camera_marker_enemy_army},
		true,
		true
	);
	
	ca:set_progress_immediately_into_cutscene(true);
	ca.should_skip = core:is_tweaker_set("SCRIPTED_TWEAKER_01");			-- set to immdiately skip camera advice section
	ca:hide_unit_ids_during_cutscene(true)
	ca:fade_into_cutscene(1)
	ca:start();



end;

-- Enable override for units' movement paths.
function force_enable_units_movement_paths(value)
	if value then
		if context_value_of_path ~= 2 then  
			common.get_context_value("SetPrefAsInt('ui_path_markers', 2)")
			context_value_of_path = common.get_context_value("PrefAsInt('ui_path_markers')")
			out(context_value_of_path)
		end
	else
		if context_value_of_path ~= 1 then  
			common.get_context_value("SetPrefAsInt('ui_path_markers', 1)")
			context_value_of_path = common.get_context_value("PrefAsInt('ui_path_markers')")
			out(context_value_of_path)
		end
	end
end

function start_skirmish_allies_advance()
	core:call_once(
		"skirmish_allies_advance", 
		function(context)
			skirmish_allies_unhide();
			skirmish_allies_move_staging();
		end
	)
end;
















---------------------------------------------------------
--
-- select and move general advice
--
---------------------------------------------------------


function start_general_selection_advice()
	-- start skirmish allies advance if it's not already started
	start_skirmish_allies_advance();

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_finished_camera_tutorial", true);
	
	local sa = intro_battle_selection_advice:new(
		-- We must advance and combine our strength. Select your own unit in order to re-join your forces.
		"wh3_main_scenario_01_0040",
		v(427.4, 454.0, -457.6),
		v(333.7, 392.4, -392.9),
		sunits_player_general,
		-- Select your Lord.
		"wh3_main_scenario_01_prologue_intro_selection_01", 
		function() start_general_movement_advice() end
	);
	
	sa:add_infotext(
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






pos_lord_movement = v_to_ground(v(381, -443.9), 2);

function start_general_movement_advice()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_selected_Yuri", true);
	
	local ma = intro_battle_movement_advice:new(
		-- Now issue a move order towards your troops. The soldiers are assembled and await your arrival.
		"wh3_main_scenario_01_0041",
		pos_lord_movement,
		sunits_player_general,
		-- Order your Lord to move to the army.
		"wh3_main_scenario_01_prologue_intro_movement_01",
		function() bm:callback(function() transition_to_army_movement() end, 1000); end
	);
	
	ma:set_allow_orders_on_advice_delivery(true);
	ma:set_prevent_orders_after_movement(true);
	ma:set_should_disable_camera(true);
	ma:set_advisor_delay(500);
	
	ma:add_infotext(
		"wh2.battle.intro.info_030",
		"wh2.battle.intro.info_031"
	);
	
	ma:start();
end;







function transition_to_army_movement()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_moved_Yuri", true);
	
	-- order Lord into correct position
	move_lord_to_army();
	
	-- play cutscene
	bm:callback(
		function()
			play_cutscene_transition_to_army_movement();
		end, 
		3000
	);

	bm:callback(
		function()
			bm:clear_infotext();

			-- Your place is amongst the warriors. Your presence grants them courage before the enemy.
			bm:queue_advisor("wh3_main_scenario_01_0042");	
			bm:add_infotext("wh2.battle.intro.info_010")
	
			bm:callback(
				function()
					bm:add_infotext(
						"wh2.battle.intro.info_013",
						"wh2.battle.intro.info_014"
					)
				end, 
				500
			);
		end,
		3500
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












---------------------------------------------------------
--
-- transition to army movement
--
---------------------------------------------------------

bool_cutscene_transition_to_army_movement_skipped = false;
cutscene_transition_to_army_movement_length = 6000;

cutscene_transition_to_army_movement = cutscene:new(
	"cutscene_transition_to_army_movement", 						-- unique string name for cutscene
	sunits_player_start, 											-- unitcontroller over player's army
	cutscene_transition_to_army_movement_length,					-- duration of cutscene in ms
	function() wait_before_start_army_movement() end				-- what to call when cutscene is finished
);

cam_transition_to_army_movement = v(440.1, 465.5, -465.4);
targ_transition_to_army_movement = v(348.7, 400.9, -400.7);


cutscene_transition_to_army_movement:set_skippable(
	true,
	function()
		bool_cutscene_transition_to_army_movement_skipped = true;
	
		cam:fade(true, 0);
		
		-- teleport player's general
		move_lord_to_army(true);
		
		bm:callback(function() cam:fade(false, 0.5) end, 500);
	end
);
-- cutscene_transition_to_army_movement:set_debug(true);
cutscene_transition_to_army_movement:set_skip_camera(cam_transition_to_army_movement, targ_transition_to_army_movement);
cutscene_transition_to_army_movement:set_close_advisor_on_start(false);
cutscene_transition_to_army_movement:set_close_advisor_on_end(false);
cutscene_transition_to_army_movement:set_should_release_players_army(false);
cutscene_transition_to_army_movement:set_should_disable_unit_ids(false);
cutscene_transition_to_army_movement:set_should_enable_cinematic_camera(false);


function play_cutscene_transition_to_army_movement()
	cutscene_transition_to_army_movement:action(
		function() 
			cam:move_to(cam_transition_to_army_movement, targ_transition_to_army_movement, (cutscene_transition_to_army_movement_length / 1000) - 1.5, false, 0);
		end, 
		0
	);
	
	cutscene_transition_to_army_movement:start();
end;


function wait_before_start_army_movement()
	-- if we skipped the cutscene, don't wait for the advisor
	if bool_cutscene_transition_to_army_movement_skipped then
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
		"wait_before_start_army_movement"
	);
	
	-- proceed when the advisor is dismissed
	core:add_listener(
		"wait_before_start_army_movement",
		"AdviceDismissed",
		true,
		function()
			highlight_advisor_progress_button(false);
		
			bm:remove_process("wait_before_start_army_movement");
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















---------------------------------------------------------
--
-- army selection and movement advice
--
---------------------------------------------------------


function start_army_selection_advice()

	bm:clear_selection()
	
	-- allow unit movement
	bm:disable_orders(true);

	-- start the skirmish allies moving towards their final positions
	skirmish_allies_move_main();
	
	local sa = intro_battle_selection_advice:new(
		-- Proceed into the valley. Select your entire army, so any order is given to all.
		"wh3_main_scenario_01_0043",
		v(436.1, 463.4, -481.4),
		v(372.8, 398, -388.9),
		sunits_player_start,
		-- Select all your units
		"wh3_main_scenario_01_prologue_intro_selection_02", 
		function() start_army_movement_advice() end
	);
	
	sa:add_infotext(
		"wh2.battle.intro.info_025",
		"wh2.battle.intro.info_022",
		"wh2.battle.intro.info_023",
		"wh2.battle.intro.info_024"
	);

	-- sa:set_show_topic_leader(false);
	
	sa:set_should_enable_unit_cards(true);
	sa:set_should_update_objective_counter(true)
	
	sa:start();
end;


do
	local x = 230;
	local y = -326;
	local height = bm:get_terrain_height(x, y) + 1;
	player_army_advance_pos = v(x, height, y);
end;

function start_army_movement_advice()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_selected_all_units", true);

	-- Show cheat sheet.
	show_battle_controls_cheat_sheet();

	-- Disable camera rotation.
	bm:disable_shortcut("rot_l", false)
	bm:disable_shortcut("rot_r", false)

	-- start the skirmish allies moving quickly towards their final positions
	skirmish_allies_move_main(true);

	-- start the enemies that the skirmish will fire upon listening for coming under attack
	enemy_art_defence_watch_for_skirmish_attack();

	local ma = intro_battle_movement_advice:new(
		-- Order your units forward. Our allies have not gone far.
		"wh3_main_scenario_01_0044",
		player_army_advance_pos,
		sunits_player_start,
		-- Order your forces to advance.
		"wh3_main_scenario_01_prologue_intro_movement_02",
		function()
			bm:callback(
				function()
					show_maneouvring_advice()
				end,
				2000
			);
		end
	);
	
	ma:set_advisor_delay(500);
	ma:set_remove_marker_on_end(false);
	
	ma:add_infotext(
		"wh2.battle.intro.info_030",
		"wh2.battle.intro.info_031"
	);

	ma:start();
	
	bm:callback(
		function()
			show_advisor_progress_button(true);
		end,
		2000
	);
end;










---------------------------------------------------------
--
-- maneouvring advice
--
---------------------------------------------------------


function show_maneouvring_advice()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_moved_all_units", true);
	
	bm:queue_advisor(
		-- The soldiers advance! Take this time to practice manoeuvring. Remember, orders are issued only to selected units.
		"wh3_main_scenario_01_0045",
		0,
		false,
		function() 
			bm:add_infotext_with_leader(
				"wh2.battle.intro.info_050",
				"wh2.battle.intro.info_051"
			)
			
			bm:progress_on_advice_dismissed(
				"AppendControlsToCheatSheet",
				function() append_unit_destination_controls_to_cheat_sheet() end,
				0,
				false
			)
		end
	)
	
	start_maneouvring_advice_visibility_monitor();
end;







area_player_enters_valley = convex_area:new({
	v(489.5, -217.1),
	v(281.6, -346),
	v(195, -221),
	v(419, -94)
});



function start_maneouvring_advice_visibility_monitor()
	-- Advance into the valley.
	local objective_key = "wh3_main_scenario_01_prologue_intro_movement_03";

	bm:set_objective(objective_key);

	-- start monitor for player entering valley trigger area
	bm:watch(
		function()
			return area_player_enters_valley:is_in_area(sunits_player_start);
		end,
		3000,
		function()
			bm:complete_objective(objective_key);
			bm:remove_ping_icon(player_army_advance_pos:get_x(), player_army_advance_pos:get_y(), player_army_advance_pos:get_z());

			-- release the music system! stops the bespoke music and returns to the dynamic music system
			bm:set_music_vm_variable("bespoke_battle_id", "NoBespokeFunctions");
			bm:set_music_vm_variable("bespoke_battle_script_actions", "NoBespokeFunctions");
			bm:watch(
				function()
					return have_skirmish_allies_arrived_main()
				end,
				2000,
				function()
					bm:remove_objective(objective_key);
					
					start_skirmish_attack_cutscene();
				end
			);
		end
	);





	
	-- warn if player's forces are separated during the advance
	--[[
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
	]]

end;



















---------------------------------------------------------
--
-- skirmish attack cutscene
--
---------------------------------------------------------

cutscene_skirmish_attack = cutscene:new_from_cindyscene(
	"cutscene_skirmish_attack",				 																		-- unique string name for cutscene
	sunits_player_start, 																							-- unitcontroller over player's army
	function(was_skipped) start_attacking_advice(was_skipped) end,													-- what to call when cutscene is finished
	"script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_ambush.CindySceneManager",					-- cindyscene
	0,
	4
);




cutscene_skirmish_attack:set_skippable(
	true,
	function()	
		cam:fade(true, 0, true);
		cam:move_to(v(373.3, 430.5, -205.4), v(323.7, 398.1, -242.2), 0, false, 0, false);

		teleport_player_skirmish_attack_start();
		reposition_skirmish_enemies_for_attack();
		skirmish_enemies_initial_attack();
				
		bm:callback(function() cam:fade(false, 0.5) end, 1000);
	end
);
-- cutscene_skirmish_attack:set_debug(true);
-- cutscene_skirmish_attack:set_skip_camera(v(373.3, 430.5, -205.4), v(323.7, 398.1, -242.2));
cutscene_skirmish_attack:set_close_advisor_on_end(false);
cutscene_skirmish_attack:set_should_disable_unit_ids(true);
-- cutscene_skirmish_attack:set_restore_cam(2.5, v(373.3, 430.5, -205.4), v(323.7, 398.1, -242.2));


function start_skirmish_attack_cutscene()

	-- cutscene_skirmish_attack:action(function() cam:move_to(v(197.0, 393.3, -311.0), v(75.2, 364.2, -344.8), 3.5, false, 50) end, 0);


	-- Our allies fire down upon Skollden's army! His forces scatter!
	cutscene_skirmish_attack:add_cinematic_trigger_listener("wh3_main_scenario_01_0050", function() bm:queue_advisor("wh3_main_scenario_01_0050") end);
	
	cutscene_skirmish_attack:add_cinematic_trigger_listener(
		"ambush_attack", 
		function() 
			teleport_player_skirmish_attack_start();
			skirmish_enemies_advance();
		end
	);
	
	--[[
		cutscene_skirmish_attack:action(function() cam:move_to(v(123.2, 385.8, -350.1), v(-3.8, 359.6, -351.3), 0, false, 45) end, 5500);
		cutscene_skirmish_attack:action(function() cam:move_to(v(123.2, 385.8, -346.1), v(-3.8, 359.6, -347.3), 30, false, 45) end, 5500);
	]]
		
	-- The allies are threatened from the rear! Up close, their bows are no match for swords and spears!
	cutscene_skirmish_attack:add_cinematic_trigger_listener("wh3_main_scenario_01_0051", function() bm:queue_advisor("wh3_main_scenario_01_0051") end);

	--[[
	cutscene_skirmish_attack:action(function() cam:move_to(v(38.4, 387.3, -319.9), v(149.7, 370.4, -384.4), 0, false, 35) end, 9000);
	cutscene_skirmish_attack:action(function() cam:move_to(v(38.4, 390.3, -319.9), v(149.7, 373.4, -384.4), 3, true, 35) end, 9000);

	cutscene_skirmish_attack:action(function() cam:move_to(v(214.9, 381.7, -428.8), v(297.0, 374.5, -528.9), 3, false, 35) end, 12000);
	]]

	cam:fade(true, 1)
	
	bm:callback(function() cam:fade(false, 0.5); cutscene_skirmish_attack:start() end, 1000)
end;
















---------------------------------------------------------
--
-- skirmish attack
--
---------------------------------------------------------


function start_attacking_advice(was_skipped)

	if not was_skipped then
		skirmish_enemies_initial_attack();
	end;

	skirmish_allies_respond_to_enemy();
	
	-- clear infotext
	bm:clear_infotext();

	local pos_fight_marker = v_to_ground(v(161.1, -353.7), 1);
		
	local aa = intro_battle_attacking_advice:new(
		-- They're under attack! We must hurry to their aid! 
		"wh3_main_scenario_01_0055",
		pos_fight_marker,
		-- Hurry your forces into battle.
		"wh3_main_scenario_01_prologue_intro_attacking_01",
		-- Draw your weapons! Turn the tide of battle!
		"wh3_main_scenario_01_0060",
		sunits_player_start,
		sunits_enemy_skirmish,
		-- Attack the enemy.
		"wh3_main_scenario_01_prologue_intro_attacking_02",
		function()
			-- Resets armies to default state once player engaged.
			sunits_enemy_skirmish:take_control()
			sunits_enemy_skirmish:set_invincible_for_time_proportion(0)
			sunits_allied_skirmishers:set_invincible_for_time_proportion(0.5)
			bm:callback(function() start_monitoring_advice() end, 1000) end
	);
	
	aa:set_advance_threshold(120);
	aa:set_enemy_should_attack(false);
	
	aa:add_attacking_infotext(
		"wh2.battle.intro.info_060",
		"wh2.battle.intro.info_061"
	);
	
	aa:set_min_attacking_advice_duration(12000);
		
	-- Envelop the enemy as best you can! They have their backs to us. A fatal mistake!
	aa:set_follow_up_advice("wh3_main_scenario_01_0065");
	
	--[[
	aa:add_attacking_area(
		convex_area:new({
			v(200, -220),
			v(100, -120),
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
	]]
	
	aa:start();
	
	-- set player's forces to be unkillable
	sunits_player_start:max_casualties(0.7, true);
	
	-- set enemy forces to be fearless
	sunits_enemy_skirmish:morale_behavior_fearless();

	-- set enemy forces to be invincible
	sunits_enemy_skirmish:set_invincible_for_time_proportion(1)
	
	-- set enemy artillery defenders invincible and unbreakable
	sunits_enemy_artillery_defenders:morale_behavior_fearless();
	sunits_enemy_artillery_defenders:set_invincible_for_time_proportion(1)

	-- set allied forces to be fearless and take max 50% casualties
	sunits_allied_skirmishers:morale_behavior_fearless();
	
	-- set allied forces to be invincible
	sunits_allied_skirmishers:set_invincible_for_time_proportion(1)
	
	-- give player units a kill aura
	sunits_player_start:start_kill_aura(sunits_enemy_skirmish, 10);

	-- watch for the player's forces moving and move the enemy into a defensive posture when they do
	sunits_player_start:cache_location();

	bm:watch(
		function()
			return sunits_player_start:has_moved(pos_fight_marker, 10);
		end,
		0,
		function()
			skirmish_enemies_respond_to_player();
		end
	);
end;


bool_player_warned_of_force_separation = false;

function warn_of_force_separation()
	if bool_player_warned_of_force_separation then
		return;
	end;

	bool_player_warned_of_force_separation = true;

	bm:queue_advisor(
		-- Advance with all your warriors at once! Or you risk becoming overwhelmed!
		"wh3_main_scenario_01_0046"
	);
end;









---------------------------------------------------------
--
-- monitor for routing
--
---------------------------------------------------------


function start_monitoring_advice()
		
	-- prevent enemy units rallying if they rout
	sunits_enemy_skirmish:prevent_rallying_if_routing(true);
	
	-- unforce minimised tooltips
	bm:force_minimised_tooltips(false);
	
	local monitoring_advice_duration = 20000;
	
	--[[
	bm:stop_advisor_queue(true);
	bm:queue_advisor(
		-- Be sure to keep watch on your warriors in battle, my Lord! Their very lives depend upon it!
		"wh2.battle.intro.100",
		monitoring_advice_duration
	);
	
	bm:clear_infotext();
	bm:add_infotext(
		"wh2.battle.intro.info_070",
		"wh2.battle.intro.info_071",
		"wh2.battle.intro.info_072"
	);
	]]
	
	-- wait before potentially triggering routing advice
	bm:callback(
		function()
			sunits_enemy_skirmish:morale_behavior_default();
			sunits_enemy_skirmish:rout_on_casualties(0.4);
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
	local ra = intro_battle_routing_advice:new(
		sunits_player_start,
		sunits_enemy_skirmish,
		-- The enemy raise the white flag! Their troops flee!
		"wh3_main_scenario_01_0061",								-- advice for if enemy units start to rout
		-- Our forces have been defeated. They run from the battle! Let us retreat and regroup!
		"wh3_main_scenario_01_0063",								-- advice for if the players units start to rout
		function() skirmish_completed() end,						-- function to call when all enemy sunits rout
		function() rout_player_army() end							-- function that routs the player army (over time)		
	);
	
	ra:add_allied_army(
		sunits_allied_skirmishers,
		-- The strength of our allies has failed! The cause is lost!
		"wh3_main_scenario_01_0062"
	);
	
	ra:add_enemy_routs_infotext(
		"wh2.battle.intro.info_080",
		"wh2.battle.intro.info_081",
		"wh2.battle.intro.info_082"--[[,
		"wh2.battle.intro.info_083"
		]]
	);
	
	ra:add_player_routs_infotext(
		"wh2.battle.intro.info_080",
		"wh2.battle.intro.info_081",
		"wh2.battle.intro.info_082",
		"wh2.battle.intro.info_084"
	);
	
	ra:add_allies_rout_infotext(
		"wh2.battle.intro.info_080",
		"wh2.battle.intro.info_081",
		"wh2.battle.intro.info_082",
		"wh2.battle.intro.info_084"
	);
	
	ra:start();
end;







---------------------------------------------------------
--
-- skirmish completion
--
---------------------------------------------------------

function skirmish_completed()

	bm:remove_callback("CheckForStrayUnits")

	stop_enemy_art_defence_watch_for_skirmish_attack();

	-- keep cinematic bars on-screen after previous cutscene
	bm:enable_cinematic_ui(true, false, true);
	
	-- fade to black
	cam:fade(true, 1);
	
	stop_make_army_vulnerable_if_separated();
	
	-- sunits_enemy_phase_two:deploy_reinforcement(true);
	
	bm:callback(
		function() 
			proceed_to_main_attack();
		end,
		1000
	);
end;


function proceed_to_main_attack()
	clean_up_skirmish_phase();
	
	start_main_enemy_attack();

	start_main_allied_defence_behaviour();
	
	start_enemy_artillery_defence();

	if core:is_tweaker_set("SCRIPTED_TWEAKER_09") then
		play_cutscene_enemy_attack_begins();
	else
		bm:callback(function() play_cutscene_enemy_attack_begins() end, 1000);
	end;
end;


function clean_up_skirmish_phase()
	-- Revert artillery defenders to normal behaviour.
	sunits_enemy_artillery_defenders:morale_behavior_default()
	sunits_enemy_artillery_defenders:set_invincible_for_time_proportion(0)
	
	-- stop kill aura
	sunits_player_start:stop_kill_aura();
	
	-- kill/swap/reposition units
	swap_allied_for_player_skirmishers();
	
	-- kill off skirmish enemy
	sunits_enemy_skirmish:kill(true);
	
	-- reposition player's forces
	reposition_artillery_attack_player_army_for_gameplay();
end;


function swap_allied_for_player_skirmishers()
	sunits_player_missile_reinforcements:set_enabled(true);
	sunits_player_missile_reinforcements:release_control();
	sunits_allied_skirmishers:kill(true);
end;


