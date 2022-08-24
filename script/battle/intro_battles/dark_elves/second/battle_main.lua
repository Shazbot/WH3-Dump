

output_uicomponent_on_click();

-- hide user interface
bm:show_ui(false);
bm:show_ui_options_panel(false);
bm:enable_spell_browser_button(false);

bm:setup_battle(function() start_battle() end);

bm:register_phase_change_callback(
	"Deployment", 
	function()
		-- prevent UI hiding
		bm:enable_ui_hiding(false);
	
		-- hide army abilities
		find_uicomponent(core:get_ui_root(), "army_ability_parent"):SetVisible(false);
		
		-- show the cutscene borders immediately
		bm:enable_cinematic_ui(true, false, true);
		
		core:progress_on_loading_screen_dismissed(function() play_cutscene_deployment() end, "custom_loading_screen");
	end
);

-- setup victory callback
bm:setup_victory_callback(function() battle_is_ending() end);

-- ensure that the open campaign loads next
core:svr_save_bool("sbool_player_has_just_completed_second_intro_battle", true);







------------------------------------------------------------------------------
-- INTRO CUTSCENE - pre deployment
------------------------------------------------------------------------------

function play_cutscene_deployment()

	second_battle_start_cutscene_deployment(
		v(-490.0, 319.7, -479.2), 							-- end camera position
		v(-330.4, 257.3, -320.4), 							-- end camera target
		5500,			 									-- cutscene duration
		-- Battle is upon you once again, my Lord! Your forces are ready to deploy for the coming engagement. They may be positioned anywhere within the the area shown.
		"wh2.battle.intro.500", 							-- advice key
		{
			1,
			"wh2.battle.intro.info_500",
			"wh2.battle.intro.info_501",
			"wh2.battle.intro.info_502"
		}, 													-- infotext
		sunits_player_all,									-- sunits collection of all players army
		function() play_battle_attacker_advice() end		-- end callback
	);
end;












------------------------------------------------------------------------------
-- BATTLE ATTACKER ADVICE
------------------------------------------------------------------------------


function play_battle_attacker_advice()

	second_battle_start_cutscene_attacker(
		v(-10.8, 261.2, -28.9), 							-- start camera pos
		v(-240.4, 238.9, 7.8),								-- start camera targ
		v(7.2, 261.2, 93.6), 								-- end camera pos
		v(-209.4, 238.9, 8.8),								-- end camera targ
		45,													-- cutscene fov
		sunits_player_all,									-- sunits collection of all players army
		-- Always survey the terrain prior to battle and position your troops to gain an edge. The enemy gave battle so the onus is on them to attack. Use this to your advantage!
		"wh2.battle.intro.510",								-- advice key
		{
			1,
			"wh2.battle.intro.info_510",
			"wh2.battle.intro.info_511",
			"wh2.battle.intro.info_512"
		},													-- infotext
		function() play_cutscene_forest_deployment() end	-- end callback
	);
end;









------------------------------------------------------------------------------
-- PLAYER DEPLOYING IN FOREST
------------------------------------------------------------------------------

function play_cutscene_forest_deployment()

	second_battle_start_cutscene_forest(
		v(-209.6, 262.7, 27.0),
		v(-153.9, 204.0, 245.9),
		v(-207.3, 266.8, -39.8),
		v(-151.6, 207.1, 179.1),
		sunits_player_all,
		-- This forest may be used to conceal your forces. Arrange your cavalry here, my Lord, and they will remain unseen until the enemy draw close.
		"wh2.battle.intro.520",
		{
			1,
			"wh2.battle.intro.info_520",
			"wh2.battle.intro.info_521"
		},
		function() monitor_for_player_deployment_in_forest() end
	);
end;


function monitor_for_player_deployment_in_forest()

	second_battle_monitor_for_player_deployment_in_forest(
		sunits_player_cav,																	-- sunits to go in forest
		sunits_player_non_cav,																-- sunits not to go in forest
		sunits_player_all,																	-- all player sunits
		"wh2.battle.intro.forest_deployment.001",											-- objective key
		-- Good! Your troops are now hidden from enemy sight, as you can see.
		"wh2.battle.intro.530",																-- advice key
		{
			1,
			"wh2.battle.intro.info_520",
			"wh2.battle.intro.info_521",
			"wh2.battle.intro.info_522"
		},																					-- infotext
		v(-70, 80, -30),																	-- position offset for completion camera
		function() show_unit_card_features() end											-- end callback
	);
end;


function show_unit_card_features()

	second_battle_show_unit_card_features(
		-- Pay attention to your Unit cards, my Lord, for they indicate the status of your troops. Be mindful of your army: success on the battlefield depends upon it.
		"wh2.battle.intro.540", 
		{
			1,
			"wh2.battle.intro.info_530",
			"wh2.battle.intro.info_531",
			"wh2.battle.intro.info_532",
			"wh2.battle.intro.info_533"
		}, 
		function() play_cutscene_hill_deployment() end
	);
end;








------------------------------------------------------------------------------
-- PLAYER DEPLOYING ON HILL
------------------------------------------------------------------------------

function play_cutscene_hill_deployment()

	second_battle_start_hill_deployment(
		v(-20.2, 254.2, 24.4),										-- cutscene start cam
		v(-128.9, 214.2, -178.5), 									-- cutscene start targ
		v(-269.8, 288.2, -22.0), 									-- cutscene end cam
		v(-45.8, 221.9, -18.7), 									-- cutscene end targ
		-- This hilltop will afford your troops an edge in the coming battle, my Lord. Place the rest of your troops close by, and claim its summit once battle begins.
		"wh2.battle.intro.550", 									-- advice key
		sunits_player_cav,											-- player forest sunits
		sunits_player_non_cav,										-- player non-forest sunits
		area_hill_deployment,										-- convex deployment area
		v(-160, 255, -120),											-- marker position
		"wh2.battle.intro.hill_deployment.001",						-- objective key
		v(-80, 30, -10),											-- end camera position offset
		-- Good! Your troops are ready, my Lord. Just give the signal and the engagement shall begin!
		"wh2.battle.intro.560",										-- end advice key
		function() allow_player_to_start_battle() end				-- end callback
	);
end;


function allow_player_to_start_battle()
	bm:show_start_battle_button(true);
	bm:set_objective("wh2.battle.intro.start_battle.001");
	
	-- show bits of hud that were previously hidden
	bm:show_winds_of_magic_panel(true);
	bm:show_portrait_panel(true);
	bm:show_radar_frame(true);
end;












------------------------------------------------------------------------------
-- BATTLE STARTED
------------------------------------------------------------------------------

bool_player_cavalry_has_been_spotted = false;

function start_battle()

	sunits_player_all:release_control();
		
	-- complete objective
	bm:complete_objective("wh2.battle.intro.start_battle.001");
	bm:callback(function() bm:remove_objective("wh2.battle.intro.start_battle.001") end, 1000);
	
	-- advice
	-- To arms, then! The enemy enter the field. Advance and claim the hilltop, my Lord, its slopes will serve your forces well. Keep your cavalry hidden!
	bm:callback(
		function() 
			bm:queue_advisor("wh2.battle.intro.570");
		end, 
		1000
	);
	
	bm:callback(function() play_artillery_advice() end, 30000);
	
	-- enemy behaviour
	sai_enemy_art = script_ai_planner:new("enemy_art", sunits_enemy_art);
	order_enemy_art_to_attack();
	
	sunits_enemy_main:release_control();
	
	-- watch for the player cavalry becoming visible
	bm:watch(
		function()
			return not sunits_player_cav:is_hidden(true)
		end,
		0,
		function()
			bool_player_cavalry_has_been_spotted = true;
		end
	);
end;



function order_enemy_art_to_attack()
	sai_enemy_art:attack_force(sunits_player_all);
end;



function play_artillery_advice()
	
	local player_unit_destinations_cached = false;
	
	-- get enemy artillery unit
	local sunit_art = false;
	for i = 1, sunits_enemy_art:count() do
		current_sunit = sunits_enemy_art:item(i);
		if current_sunit.unit:unit_class() == "art_fld" then
			sunit_art = current_sunit;
			break;
		end;
	end;
	
	if not sunit_art then
		script_error("WARNING: play_artillery_advice() couldn't find artillery");
		sunit_art = sunits_enemy_art:item(1);
	end;
	
	-- remove units from enemy art ai planner in order to take control of them
	sai_enemy_art:remove_sunits(sunits_enemy_art);
	
	-- tell enemy art sunits to halt
	sunits_enemy_art:halt();

	-- cache current camera position
	local end_pos = cam:position();
	local end_targ = cam:target();
	
	local artillery_view_distance = 30;
	
	local cutscene_artillery_length = 17500;

	local cutscene_artillery = cutscene:new(
		"cutscene_artillery", 							-- unique string name for cutscene
		sunits_player_all, 								-- unitcontroller over player's army
		cutscene_artillery_length,						-- duration of cutscene in ms
		function() 										-- what to call when cutscene is finished
			
			-- restore what the player's units were doing if they have been stopped
			if player_unit_destinations_cached then
				-- restoring their destination doesn't actually work so well in this case, so just release them back to the player
				-- sunits_player_all:goto_cached_destination(true);
				sunits_player_all:release_control();
			end;
			
			-- restore what the artillery planner was up to
			sai_enemy_art:add_sunits(sunits_enemy_art);
			order_enemy_art_to_attack();
			
			bm:callback(function() monitor_for_enemy_closing_advice() end, 10000);
		end
	);
	
	cutscene_artillery:set_close_advisor_on_end(false);
	cutscene_artillery:set_post_cutscene_fade_time(0);
	cutscene_artillery:set_restore_cam(2, end_pos, end_targ);
	-- cutscene_artillery:set_debug(true);
		
	cutscene_artillery:action(
		function()
			local pos_unit = v_offset(sunit_art.unit:position(), 0, 2, 0);
			local h_camera_bearing_start = -30;
			local v_camera_bearing_start = 8;
			
			local camera_pos_start = get_tracking_offset(pos_unit, sunit_art.unit:bearing() + h_camera_bearing_start, v_camera_bearing_start, artillery_view_distance);
			
			cam:move_to(camera_pos_start, pos_unit, 4, false, 45);
			
			-- My Lord, the enemy field artillery against you! They will be able to strike against your forces at great range!
			bm:queue_advisor("wh2.battle.intro.590");
			bm:add_infotext(
				1,
				"war.battle.advice.artillery.info_001",
				"war.battle.advice.artillery.info_002"
			);
		end, 
		500
	);
	
	cutscene_artillery:action(
		function()
			local pos_unit = v_offset(sunit_art.unit:position(), 0, 2, 0);
			
			local h_camera_bearing_end = -40;
			local v_camera_bearing_end = 8;
			
			local camera_pos_end = get_tracking_offset(pos_unit, sunit_art.unit:bearing() + h_camera_bearing_end, v_camera_bearing_end, artillery_view_distance);
			
			cam:move_to(camera_pos_end, pos_unit, 10, true, 45);
		end, 
		4500
	);
	
	cutscene_artillery:action(
		function()
			-- don't continue with this cutscene if the cavalry have already been spotted
			if bool_player_cavalry_has_been_spotted then
				cutscene_artillery:skip();
				return;
			end;
			
			-- get the centre position of the player cavalry
			local pos_centre = v_offset(sunits_player_cav:centre_point(), 0, 30, 0);
			
			-- get a position for the camera to look at this target, with the same relative facing/distance as current
			-- local cam_pos = v_add(pos_centre, v_subtract(cam:position(), cam:target()));
			local cam_pos = v_add(pos_centre, v(20, 50, 80));
			
			cam:move_to(cam_pos, pos_centre, 3, false, 0);
			
			-- Your cavalry remain hidden, my Lord. Advance them slowly through the forest, and they will be able to quickly surprise and overwhelm the enemy war machines!
			bm:queue_advisor("wh2.battle.intro.600");
		end, 
		11500
	);
	
	-- halt player units (a little after the cutscene has started)
	bm:callback(
		function()
			if cutscene_artillery:is_active() then
				player_unit_destinations_cached = true;
				sunits_player_all:cache_destination_and_halt();
			end;
		end,
		500
	);
	
	cutscene_artillery:start();
end;



function monitor_for_enemy_closing_advice()
	
	-- watch for the two sides closing
	bm:watch(
		function()
			return distance_between_forces(sunits_player_all, sunits_enemy_main) < 300
		end,
		0,
		function()
			issue_enemy_closing_advice()
		end
	);
end;


function issue_enemy_closing_advice()
	-- The enemy draw close, my Lord! Be sure to have your troops arranged for battle. Employ all that you have learned: wear them down with missiles, pin them with infantry, then flank with mounted troops!
	bm:queue_advisor("wh2.battle.intro.580");
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_540",
		"wh2.battle.intro.info_541",
		"wh2.battle.intro.info_542",
		"wh2.battle.intro.info_543"
	);
	
	-- allow generic advice after a little while
	bm:callback(
		function()
			-- allowing generic advice
			am:unlock_advice();
		end,
		40000
	);
end;










------------------------------------------------------------------------------
-- ENDING
------------------------------------------------------------------------------

bool_battle_is_ending = false;

function battle_is_ending()
	
	if bool_battle_is_ending then
		return;
	end;
	
	bool_battle_is_ending = true;
	
	bm:stop_advisor_queue();

	if is_routing_or_dead(sunits_player_all) then
		-- player has lost
		
		-- The enemy have won the field, my Lord! Let us retreat while we still can!
		bm:queue_advisor("wh2.battle.intro.620");
		
		bm:callback(function() bm:end_battle() end, 10000);
	else
		-- player has won
		
		-- The enemy have been put to flight, my Lord! Victory is yours!
		bm:queue_advisor("wh2.battle.intro.610");
		
		bm:callback(function() bm:end_battle() end, 10000);
	end;
end;