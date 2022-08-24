--Set up a metric variable to be used in campaign later
core:svr_save_bool("sbool_prologue_second_battle_loaded_in", true);

bm:register_phase_change_callback(
	"Deployed",
	function()
		battle_started();
	end
);


bm:register_phase_change_callback(
	"VictoryCountdown",
	function()
		victory_countdown_phase_entered();
	end
);


function battle_started()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_second_battle_started_battle", true);

	-- if the skip tweaker is set then end the battle now
	if core:is_tweaker_set("SCRIPTED_TWEAKER_10") then
		end_battle();
		return;
	end;

	-- allow movement
	bm:disable_orders(false);


	bm:change_conflict_time_update_overridden(false)
	
	bm:complete_objective("wh3_main_scenario_02_deploy_02");
	bm:callback(function() bm:remove_objective("wh3_main_scenario_02_deploy_02"); end, 2000);

	start_move_to_hill_objective(true, true);
	start_enemy_attack();
end;







---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Claim High Ground objective
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

ca_hill = convex_area:new({
	v(-264, -20),
	v(0, -140),
	v(0, -195),
	v(-265, -160)
});

local player_has_reached_hill = false;

function start_move_to_hill_objective(should_start, trigger_advice, set_objective_without_leader)

	local ping_x = -78;
	local ping_z = -114;
	local ping_y = bm:get_terrain_height(ping_x, ping_z) + 1;
	local ping_type = 9;

	if trigger_advice then
		-- Yuri
		-- The enemy begin their advance. Manoeuvre and claim the high ground before they do.
		bm:queue_advisor("wh3_main_scenario_02_0060");
		bm:remove_objective("wh3_main_scenario_02_deploy_02");
	end;

	local objective_key = "wh3_main_scenario_02_claim_hill_01";

	if not player_has_reached_hill then
		if should_start then
			bm:add_ping_icon(ping_x, ping_y, ping_z, ping_type);

			if set_objective_without_leader then
				bm:set_objective(objective_key)
			else
				bm:set_objective_with_leader(
					objective_key,
					nil,
					nil
				)
			end

			bm:watch(
				function()
					return ca_hill:is_in_area(sunits_player_all)
				end,
				0,
				function()
					bm:complete_objective(objective_key);
					bm:callback(
						function()
							bm:remove_objective(objective_key);
							bm:remove_ping_icon(ping_x, ping_y, ping_z, ping_type);
							--Set up a metric variable to be used in campaign later
							core:svr_save_bool("sbool_prologue_second_battle_claimed_high_ground", true);
						end,
						2000
					);
				end,
				"move_to_hill_objective"
			)
		else
			bm:remove_process("move_to_hill_objective");
			bm:remove_objective(objective_key);
			bm:remove_ping_icon(ping_x, ping_y, ping_z, ping_type);
			--Set up a metric variable to be used in campaign later
			core:svr_save_bool("sbool_prologue_second_battle_claimed_high_ground", true);
		end;
	end;
end;













---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Enemy Attack
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------


function start_enemy_attack()

	-- build the main ai planner and instruct them to attack
	sai_enemy_foot = script_ai_planner:new("enemy_foot", sunits_enemy_foot);
	sai_enemy_foot:move_to_position(v(0.0, 26.1, 62.1))

	-- start the enemy cavalry moving when all the player's army have moved, or on a timeout
	sunits_player_all:cache_location();

	bm:callback(
		function()
			bm:watch(
				function()
					return sunits_player_all:have_all_moved();
				end,
				10000,
				function()
					bm:remove_process("notify_player_of_enemy_cavalry_advance");
					start_enemy_cavalry_advance()
				end,
				"notify_player_of_enemy_cavalry_advance"
			);
		end,
		10000,
		"notify_player_of_enemy_cavalry_advance"
	);

	bm:callback(
		function()
			bm:remove_process("notify_player_of_enemy_cavalry_advance");
			start_enemy_cavalry_advance()
		end,
		30000,
		"notify_player_of_enemy_cavalry_advance"
	);
end;


-- start cavalry moving, then notify the player shortly after
function start_enemy_cavalry_advance()
	bm:out("starting enemy cavalry advance");
	sunits_enemy_cavalry:set_always_visible(true);
	sunits_enemy_cavalry:goto_location_offset(0, 80, true);
	bm:callback(function() notify_player_of_enemy_cavalry_advance() end, 3000);
end;


function notify_player_of_enemy_cavalry_advance()

	-- temporarily remove any objective
	start_move_to_hill_objective(false);

	-- disable camera movement
	bm:enable_camera_movement(false);

	-- disable pausing and other keyboard shortcuts
	bm:disable_pausing(true);
	bm:disable_tactical_map(true);
	bm:disable_help_page_button(true);
	bm:disable_cycle_battle_speed(true);
	bm:disable_unit_camera(true);

	-- calculate position to move to
	local sunit_centre_cavalry = sunits_enemy_cavalry:get_centremost();

	local cam_pos = track_unit_commander(
		sunit_centre_cavalry.unit, 		-- unit
		2, 								-- movement_speed
		10,								-- tracking_angle_h
		0,								-- tracking_angle_v
		40, 							-- tracking_distance
		2, 								-- tracking_height
		2								-- t
	);

	cam_pos = v(cam_pos:get_x(), bm:get_terrain_height(cam_pos:get_x(), cam_pos:get_z()) + 10, cam_pos:get_z());

	local cam_targ = sunit_centre_cavalry.unit:position();

	-- set up cutscene
	local cutscene_cavalry_advance = cutscene:new(
		"cavalry_advance",
		sunits_player_all,
		nil
	);

	cutscene_cavalry_advance:enable_debug_timestamps(true);
	cutscene_cavalry_advance:set_close_advisor_on_end(false);
	cutscene_cavalry_advance:set_battle_speed(0.2);
	cutscene_cavalry_advance:set_should_restore_battle_speed(false);
	cutscene_cavalry_advance:set_should_enable_cinematic_camera(false);

	cutscene_cavalry_advance:set_skippable(
		true,
		function()
			bm:cancel_progress_on_advice_dismissed("cutscene_cavalry_advance");
			return_camera_to_player_after_enemy_cavalry_advance();
		end
	);

	-- pan to calculated position
	cutscene_cavalry_advance:action(function() bm:camera():move_to(cam_pos, cam_targ, 0.8, false, 35) end, 0);

	-- advice
	cutscene_cavalry_advance:action(
		function()
			-- Gerik
			-- The enemy reveal their mounted troops! They have the speed to quickly run our forces down!
			bm:queue_advisor("wh3_main_scenario_02_0070");
			bm:add_infotext(
				"wh3_main_scenario_02_0050",
				"wh3_main_scenario_02_0051"
			);
			bm:progress_on_advice_dismissed(
				"cutscene_cavalry_advance",
				function()
					cutscene_cavalry_advance:skip()
				end
			);

			local end_sfx = new_sfx("Play_Movie_WH3_Prologue_Battle_2_Slow_Motion_Sweetener");
			play_sound_2D(end_sfx);
		end,
		0
	);

	cutscene_cavalry_advance:action(function() cutscene_cavalry_advance:show_esc_prompt(true) end, 1000);

	-- failsafe skip
	cutscene_cavalry_advance:action(function() cutscene_cavalry_advance:skip() end, cutscene_length);

	cutscene_cavalry_advance:start();

	-- manually hide the ui
	bm:show_ui(false);
end;


function return_camera_to_player_after_enemy_cavalry_advance()

	bm:stop_advisor_queue();

	-- determine which is the furthest player spearmen unit to the current camera position
	local sunit_furthest_spearmen = sunits_player_spearmen:get_furthest(bm:camera():position());

	local cam_pos = track_unit_commander(
		sunit_furthest_spearmen.unit,		-- unit
		1, 									-- movement_speed
		-25,								-- tracking_angle_h
		2, 									-- tracking_angle_v
		12, 								-- tracking_distance
		1.5, 								-- tracking_height
		8									-- t
	);
	cam_pos = v(cam_pos:get_x(), bm:get_terrain_height(cam_pos:get_x(), cam_pos:get_z()) + 10, cam_pos:get_z());
	local cam_targ = predict_commander_position(sunit_furthest_spearmen.unit, 1, 3, 1);

	-- hide all other player units
	for i = 1, sunits_player_non_spearmen:count() do
		sunits_player_non_spearmen:item(i).uc:set_invisible_to_all(true,false);
	end;

	-- set up cutscene
	local cutscene_unit_details = cutscene:new(
		"unit_details",
		sunits_player_all,
		1400,
		function()
			prepare_for_unit_details_scripted_tour()
		end
	);

	cutscene_unit_details:set_battle_speed(0.2);
	cutscene_unit_details:set_should_enable_cinematic_camera(false);
	cutscene_unit_details:set_should_restore_battle_speed(false);
	cutscene_unit_details:set_close_advisor_on_end(false);
	-- cutscene_unit_details:set_should_hide_ui(false);

	-- pan to calculated position
	cutscene_unit_details:action(function() bm:camera():move_to(cam_pos, cam_targ, 0.6, false, 0) end, 0);

	-- advice
	cutscene_unit_details:action(
		function()
			-- Gerik
			-- We have spearmen. They are well-suited to engage the enemy riders. Knowing how best to use our forces, is the key to victory.
			bm:queue_advisor("wh3_main_scenario_02_0080");
			bm:clear_infotext();
		end,
		100
	);

	cutscene_unit_details:start();
end;


function prepare_for_unit_details_scripted_tour()

	-- show portrait panel (and unit details panel with it)
	bm:show_portrait_panel(true);

	-- find the unit card uic of the first spearmen
	local uic_card = find_uicomponent(core:get_ui_root(), "hud_battle", "battle_orders", "battle_orders_pane", "cards_panel", "review_DY", tostring(sunits_player_spearmen:item(1).unit:unique_ui_id()));

	-- simulate a click and a mouse off on the unit card
	uic_card:SimulateLClick();
	uic_card:SimulateMouseOff();

	-- ensure the unit details panel is shown
	bm:disable_unit_details_panel(false);

	bm:steal_input_focus()
	bm:steal_escape_key()
	bm:callback(function() start_unit_details_scripted_tour() end, 300);
end;


function start_unit_details_scripted_tour()

	-- find uicomponents
	local uic_unit_details_button = get_unit_details_button();

	-- show unit details button, but make it non-interactive
	uic_unit_details_button:SetVisible(true);
	uic_unit_details_button:SetInteractive(true);
	
	-- make unit camera button non-interactive
	get_unit_camera_button():SetInteractive(false);

	-- show fullscreen highlight around unit details button
	core:show_fullscreen_highlight_around_components(
		1,
		false,
		true,
		uic_unit_details_button
	);

	-- set up unit details button pointer
	local tp_unit_details_button = text_pointer:new_from_component(
		"unit_details_button",
		"left",
		300,
		uic_unit_details_button,
		1,
		0.5
	);

	tp_unit_details_button:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_details_button");
	tp_unit_details_button:set_style("semitransparent_highlight");
	tp_unit_details_button:set_highlight_close_button(0);
	tp_unit_details_button:set_panel_width(250);
	tp_unit_details_button:set_close_button_callback(
		function()
			show_unit_details_panel(true);
		end
	);

	core:add_listener(
		"ComponentLClickUpClickToggleInfoPanel",
		"ComponentLClickUp",
		function(context) return context.string == "button_toggle_infopanel" end,
		function() 
			tp_unit_details_button:hide();
			start_unit_details_scripted_tour_2();
		end,
		false
	);

	bm:enable_paused_panel(false);

	bm:callback(
		function() 
			tp_unit_details_button:show(); 
			bm:release_input_focus(); 
			bm:release_escape_key()
			bm:modify_battle_speed(0) 
		end, 
		100
	)
end;

function start_unit_details_scripted_tour_2()

	bm:stop_advisor_queue(true);

	-- bm:steal_input_focus()
	-- bm:steal_escape_key()
	core:hide_fullscreen_highlight()
	-- bm:modify_battle_speed(0.2) 

	local uic_unit_details_panel = find_uicomponent(core:get_ui_root(), "hud_battle", "info_panel_parent", "unit_information")
	local uic_unit_details_bullet_point_parent = find_uicomponent(uic_unit_details_panel, "bullet_point_parent");
	local uic_button_description_toggle = find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent", "button_toggle_infopanel")
	if uic_button_description_toggle:CurrentState() == "active" or uic_button_description_toggle:CurrentState() == "hover" then uic_button_description_toggle:SimulateLClick() end
	
	bm:real_callback(
		function()
			core:show_fullscreen_highlight_around_components(
				1,
				false,
				true,
				uic_unit_details_panel
			);
		end,
		300
	);

	bm:real_callback(
		function()
			-- set up unit details top section pointer
			local tp_unit_details_top_section = text_pointer:new_from_component(
				"unit_details_top_section",
				"left",
				70,
				uic_unit_details_bullet_point_parent,
				1,
				0.6
			);

			tp_unit_details_top_section:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_details_panel");
			tp_unit_details_top_section:set_style("topmost");
			tp_unit_details_top_section:set_panel_width(350);
			tp_unit_details_top_section:set_label_offset(0, 60);
			tp_unit_details_top_section:set_close_button_callback(function() end_unit_details_scripted_tour() end)
			tp_unit_details_top_section:show()
			-- bm:release_input_focus()
			-- bm:release_escape_key()
		end,
		500
	);
end


function end_unit_details_scripted_tour()

	-- hide fullscreen highlight
	core:hide_fullscreen_highlight();

	-- hide text pointers
	core:hide_all_text_pointers();

	-- set time moving
	bm:modify_battle_speed(0.5);

	-- find the unit details toggle button and simulate a click on it to hide the unit details panel
	show_unit_details_panel(false);

	-- hide portrait panel
	bm:show_portrait_panel(false, true);

	-- blank screen to cover unit unhiding
	cam:fade(true, 0, true);

	bm:callback(function() restore_game_after_unit_details_scripted_tour() end, 100);
end;


function restore_game_after_unit_details_scripted_tour()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_second_battle_read_unit_details_tutorial", true);

	-- unhide hidden player units
	for i = 1, sunits_player_non_spearmen:count() do
		sunits_player_non_spearmen:item(i).uc:set_invisible_to_all(false,true);
	end;

	-- set time to fullspeed
	bm:slow_game_over_time(0.5, 1, 1000, 5);

	-- re-enable pausing and other keyboard shortcuts
	bm:disable_pausing(false);
	bm:disable_help_page_button(false);
	bm:disable_tactical_map(false);
	bm:disable_cycle_battle_speed(false);
	bm:disable_unit_camera(false);

	-- reposition camera behind player's forces, facing the enemy
	local player_army_centre_pos = sunits_player_all:centre_point();
	local point_on_line = position_along_line(player_army_centre_pos, sunits_enemy_all:centre_point(), -60);

	local cam_pos = v(point_on_line:get_x(), player_army_centre_pos:get_y() + 30, point_on_line:get_z());
	
	bm:camera():move_to(cam_pos, player_army_centre_pos, 0, false, 0);
	
	-- allow camera movement
	bm:enable_camera_movement(true);

	-- release player control
	sunits_player_all:release_control();

	-- show rest of ui
	bm:show_ui(true);

	-- allow pause panel to be shown again
	bm:enable_paused_panel(true);

	bm:callback(
		function()
			-- fade the camera in
			cam:fade(false, 0.5);

			-- start enemy attack behaviour
			start_enemy_cavalry_attack();
		end,
		200
	);
end;



--REMOVE THIS before shipping
core:add_listener(
	"skip_battle_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_concede" end,
	function() 
		core:svr_save_bool("sbool_load_open_campaign", true) -- load script for campaign  

		common.setup_dynamic_loading_screen("prologue_battle_2_outro", "prologue");

		--Set up a metric variable to be used in campaign later
		core:svr_save_bool("sbool_prologue_second_battle_skipped", true);
	end,
	false
);





function start_enemy_cavalry_attack()

	-- start a kill aura around the player units
	sunits_player_all:start_kill_aura(sunits_enemy_all, 10, 0.01);	
	
	-- build the main ai planner and instruct them to attack
	sai_enemy_cavalry = script_ai_planner:new("enemy_cavalry", sunits_enemy_cavalry);
	sai_enemy_cavalry:attack_force(sunits_player_all);
	
	-- remove enemy general from foot and place him in cavalry sunits group
	bm:callback(
		function()
			local sunit_enemy_general = sunits_enemy_all:item(1);
			sunits_enemy_foot:remove_sunit(sunit_enemy_general);
			sunits_enemy_cavalry:add_sunits(sunit_enemy_general);
			sai_enemy_cavalry:add_sunits(sunit_enemy_general);
		end,
		10000
	);

	bm:callback(function() notify_player_of_enemy_cavalry_attack() end, 2000);
end;


function notify_player_of_enemy_cavalry_attack()

	-- Yuri
	-- The mounted enemy charge our position. Spearmen, engage! Quickly!
	bm:queue_advisor(
		"wh3_main_scenario_02_0090",
		30000
	);
	bm:modify_advice(true);

	-- re-show objective and marker
	start_move_to_hill_objective(true, false, true)

	bm:callback(
		function()
			-- add objective
			bm:set_objective_with_leader("wh3_main_scenario_02_defeat_cavalry_01");

			bm:watch(
				function() return sunits_enemy_cavalry_2:are_all_routing_or_dead() end,
					0,
				function() 
					bm:complete_objective("wh3_main_scenario_02_defeat_cavalry_01")
					bm:callback(function() bm:remove_objective("wh3_main_scenario_02_defeat_cavalry_01") end, 3000)
					bm:remove_process("CavalryObjective") 
				end,
				"CavalryObjective"
			)

		end,
		2000
	);

	-- show pausing active pointer
	bm:callback(
		function()
			local ap = active_pointer:new(
				"battle_speed_controls",
				"topright",
				find_uicomponent(core:get_ui_root(), "hud_battle", "speed_controls", "speed_buttons"),
				"ui_text_replacements_localised_text_ap_battle_speed_controls",
				0.4,
				1,
				300,
				true
			);
			ap:show();
		end,
		6000
	);

	start_battle_monitors();
end;


function start_battle_monitors()

	-- prevent any of the enemy from rallying
	sunits_enemy_all:prevent_rallying_if_routing(true);

	-- watch for the enemy cavalry approaching
	bm:watch(
		function()
			return distance_between_forces(sunits_player_all, sunits_enemy_cavalry) < 100;
		end,
		0,
		function()
			-- Gerik
			-- Enemy riders approach! Tackle them head on with our spears, employ your archers to strike at range. Don't allow them charge your rear!
			bm:queue_advisor(
				"wh3_main_scenario_02_0100",
				30000
			);

			-- start kill aura around the player
			sunits_player_all:start_kill_aura(sunits_enemy_all, 10, 0.01);

			-- start intermittent invincibility for the player
			sunits_player_all:set_invincible_for_time_proportion(0.1, true);

			bm:callback(function() sunits_enemy_foot:release_control(); sai_enemy_foot:move_to_force(sunits_player_all) end, 10000)
		end
	);

	-- watch for the main enemy army approaching
	bm:watch(
		function()
			return distance_between_forces(sunits_player_all, sunits_enemy_foot) < 150;
		end,
		0,
		function()
			-- Gerik
			-- The main body of the enemy approach! Divert some rotas to meet them.
			bm:queue_advisor(
				"wh3_main_scenario_02_0110",
				5000
			);

			-- set objective
			bm:callback(
				function()
					bm:set_objective("wh3_main_scenario_02_defeat_enemy_01");
				end,
				5000
			);
		end
	);

	local sunit_enemy_commander = sunits_enemy_all:get_general_sunit();

	sunit_enemy_commander:rout_on_casualties(0.4, true);
end;









---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Battle is ending
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

function victory_countdown_phase_entered()
	bm:stop_advisor_queue();

	local player_won = false

	if sunits_player_all:are_all_routing_or_dead() then
		-- player has lost

		-- Gerik
		-- Our forces have met with defeat! Let us retreat and regroup!
		bm:queue_advisor("wh3_main_scenario_02_0140");

		bm:fail_objective("wh3_main_scenario_02_defeat_enemy_01");
	else
		-- player has won
		player_won = true

		-- Gerik@@@@@@
		-- The Wolf's army has been put to flight! Victory is ours!
		bm:queue_advisor("wh3_main_scenario_02_0130");
		bm:progress_on_advice_finished(
			"advisor_before_outro", 
			function() play_outro_movie() end,
			3000
		)
		bm:complete_objective("wh3_main_scenario_02_defeat_enemy_01");

		bm:change_victory_countdown_limit(-1);
	end;

	bm:callback(function() bm:remove_objective("wh3_main_scenario_02_defeat_enemy_01") end, 5000);

	-- Update svr states.
	bm:register_phase_change_callback(
		"Complete", 
		function() 
			core:svr_save_bool("sbool_load_open_campaign", true) -- load script for campaign  
			common.setup_dynamic_loading_screen("prologue_battle_2_outro", "prologue");
			
			if player_won then
				sunits_player_all:save_state_to_svr("player_army");
				core:svr_save_bool("second_prologue_battle_just_fought", true);

				--Set up a metric variable to be used in campaign later
				core:svr_save_bool("sbool_prologue_second_battle_won", true);
			end
		end
	)
end;


function play_outro_movie()
	cam:fade(true, 1);

	bm:stop_advisor_queue(true);
	
	bm:end_battle();
	
	--[[bm:callback(
		function()
			common.setup_dynamic_loading_screen("prologue_battle_2_outro", "prologue");
			bm:play_movie("warhammer3/prologue/pro_swd", true);
			
			bm:callback(
				function()
					bm:watch(
						function()
							return not bm:is_movie_playing()
						end,
						0,
						function()
							bm:change_victory_countdown_limit(0);
							bm:callback(
								function()
									bm:end_battle();
								end,
								3000
							);
						end
					);
				end,
				500
			);
		end,
		1500
	);]]
end;