


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Deployment setup
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------


bm:register_phase_change_callback(
	"Deployment", 
	function()
		--Set up a metric variable to be used in campaign later
		core:svr_save_bool("sbool_prologue_second_battle_read_wavering_tutorial", true);

		-- if the skip tweaker is set then ensure that the battle can be started
		if core:is_tweaker_set("SCRIPTED_TWEAKER_10") then
			bm:out("* SCRIPTED_TWEAKER_10 is set so allowing player to start battle immediately");
			cam:fade(false, 0);
			return;
		end;
				
		-- prevent user input
		bm:steal_input_focus(true);

		-- Disable pausing.
		bm:disable_shortcut("toggle_pause", true);

		-- prevent camera movement
		bm:enable_camera_movement(false);

		-- disable orders, so that when the player can interact they still can't move units
		bm:disable_orders(true);

		-- hide ui and start battle button
		bm:show_start_battle_button(false);
		bm:show_ui(false);

		-- prevent grouping and formations
		bm:disable_shortcut("toggle_group", true);
		bm:disable_groups(true);
		bm:disable_formations(true);

		-- Move camera up at beginning.
		cam:move_to(v(cam:position():get_x(), cam:position():get_y() + 50, cam:position():get_z()), v(cam:target():get_x(), cam:target():get_y(), cam:target():get_z() + 50), 0)

		
		core:progress_on_loading_screen_dismissed(
			function() 
				bm:callback(
					function()
						st_deployment_start();
					end,
					2000
				);
			end, 
			"custom_loading_screen"
		);
	end
);









---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Battle deployment scripted tour
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

local st_deployment = scripted_tour:new(
	"scripted_tour_deployment",
	function() scroll_camera_to_hill() end
);

-- add validation rule which must return true for the scripted tour to start
st_deployment:add_validation_rule(
	function()
		return bm:get_current_phase_name() == "Deployment";
	end,
	"not in deployment phase"
);

-- start event listener on which the scripted tour will re-assess its validity
st_deployment:add_validation_context_change_listener(
	"ScriptEventBattlePhaseChanged"
);



function st_deployment_start()

	if false then
		bm:show_army_panel(true);

		bm:callback(function() scroll_camera_to_hill() end, 2000);
		return;
	end;

	---------------------------------------------------
	-- main sequence actions
	---------------------------------------------------

	st_deployment:action(
		function()
			-- zoom the camera to a suitable position to view the deployment area
			bm:scroll_camera_with_cutscene(v(-88, 380, -372), v(30, 242, -275), 3, nil, nil, false);
		end,
		2000
	);

	st_deployment:action(
		function()
			core:cache_and_set_advisor_priority(1500, false);
			-- Gerik
			-- Battle is upon us once again. The arrangement of our forces can be key to achieving victory. They may be deployed anywhere in the shown area.
			bm:queue_advisor("wh3_main_scenario_02_0010");
			bm:add_infotext(
				1,
				"wh3_main_scenario_02_0001",
				"wh3_main_scenario_02_0002",
				"wh3_main_scenario_02_0003"
			);
			bm:progress_on_advice_dismissed(
				"st_deployment",
				function()
					st_deployment:start("section_2_pan_to_army");
				end,
				500,
				true
			);
		end,
		500
	);

	st_deployment:action(
		function()
			-- flash deployment zone

			bm:get_scriptunits_for_local_players_army():item(1).unit:army():highlight_deployment_areas(true);
		end,
		500
	);



	---------------------------------------------------
	-- section_2_pan_to_army actions
	---------------------------------------------------

	st_deployment:action(
		function()
			-- stop deployment zone flashing
			
			bm:get_scriptunits_for_local_players_army():item(1).unit:army():highlight_deployment_areas(false);
		end,
		0,
		"section_2_pan_to_army"
	);

	st_deployment:action(
		function()
			-- turn off the advisor progress button, so that the cutscene restores it to off
			--bm:modify_advice(false);

			-- scroll camera to position behind player's army
			
			-- find a position offset from the player's general
			local player_sunits = bm:get_scriptunits_for_local_players_army();
			if not player_sunits then
				script_error("ERROR: deployment scripted tour could not find player's army - how can this be?");
				return;
			end;

			local player_general_sunit = player_sunits:get_general_sunit();
			if not player_general_sunit then
				-- function call above will have errored if we get here
				return;
			end;


			bm:scroll_camera_with_cutscene(player_general_sunit:position_offset(0, 35, -40), player_general_sunit:position_offset(0, 15, 0), 3, nil, nil, false);
		end,
		500,
		"section_2_pan_to_army"
	);

	st_deployment:action(
		function()
			-- Gerik
			-- Take heed of your surroundings. The battlefield is a weapon to be used against your foe. The enemy gave battle, so the onus is on them to attack. This may be used to your advantage!
			bm:queue_advisor("wh3_main_scenario_02_0021");

			bm:progress_on_advice_dismissed(
				"st_deployment_unit_cards_start",
				function()
					st_deployment:start("section_3_unit_cards");
				end,
				500,
				true
			);

			--Set up a metric variable to be used in campaign later
			core:svr_save_bool("sbool_prologue_second_battle_finished_deployment_step", true);
			
		end,
		1000,
		"section_2_pan_to_army"
	);


	---------------------------------------------------
	-- section_3_unit_cards actions
	---------------------------------------------------

	st_deployment:action(
		function()
			-- raise camera slightly
						
			-- find a position offset from the player's general
			local player_sunits = bm:get_scriptunits_for_local_players_army();
			if not player_sunits then
				script_error("ERROR: deployment scripted tour could not find player's army - how can this be?");
				return;
			end;

			local player_general_sunit = player_sunits:get_general_sunit();
			if not player_general_sunit then
				-- function call above will have errored if we get here
				return;
			end;
			
			-- turn off the advisor progress button, so that the cutscene restores it to off
			show_advisor_progress_button(false);

			-- move camera
			bm:scroll_camera_with_cutscene(player_general_sunit:position_offset(0, 45, -60), player_general_sunit:position_offset(0, 15, 0), 2, nil, nil, false);
		end,
		500,
		"section_3_unit_cards"
	);

	st_deployment:action(
		function()
			-- Gerik
			-- Soldiers may be hidden behind hills and amongst the trees. See for yourself how the troops are concealed. Pay close attention to your unit cards, for they can tell you much about your forces during battle.
			bm:queue_advisor("wh3_main_scenario_02_0020");
			--bm:modify_advice(false);
			bm:progress_on_advice_dismissed(
				"st_deployment_unit_cards",
				function()
					st_deployment:start("section_3_unit_cards_1");
				end,
				100,
				true
			);
		end,
		1000,
		"section_3_unit_cards"
	);

	st_deployment:action(
		function()
			-- show army panel

			bm:show_army_panel(true);
			bm:steal_input_focus(false);
		end,
		2500,
		"section_3_unit_cards_1"
	);

	st_deployment:action(
		function()
			
			-- cache advisor settings in preparation for showing the fullscreen highlight
			core:cache_and_set_advisor_priority(1500, false);
	
			-- activate fullscreen highlight
			core:show_fullscreen_highlight_around_components(30, nil, false, find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel"));
		end,
		3500,
		"section_3_unit_cards_1"
	);

	-- inject all unit card content in to this scripted tour
	st_deployment_add_unit_card_actions(st_deployment, "section_3_unit_cards_1", 4000, "cleanup");

	st_deployment:action(
		function()
			core:hide_fullscreen_highlight();
		end,
		0,
		"cleanup"
	);

	st_deployment:action(
		function()
			st_deployment:complete();
		end,
		500,
		"cleanup"
	);

	st_deployment:start();
end;







---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Scroll camera to hill and then back to deployment zone
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------


function scroll_camera_to_hill()

	bm:stop_advisor_queue(true);

	local cam = bm:camera();

	local cutscene_hill = cutscene:new(
		"cutscene_hill",
		sunits_player_all,
		nil,
		nil
	);

	local proxy_id;
	local uc_player_army = sunits_player_all:get_unitcontroller();

	cutscene_hill:set_post_cutscene_fade_time(0);
	cutscene_hill:set_skippable(
		true,
		function()
			scroll_camera_to_deployment_zone();

			if proxy_id then
				uc_player_army:remove_animated_selection_proxy(proxy_id);
			end;
		end
	);

	cutscene_hill:action(
		function()
			-- Gerik
			-- Leave these trees, for they are exposed and the enemy will press us in great number. The high ground here will serve well as a defensive position.
			bm:queue_advisor("wh3_main_scenario_02_0030");
			bm:add_infotext(
				1,
				"war.battle.advice.terrain.info_001",
				"war.battle.advice.terrain.info_002",
				"war.battle.advice.terrain.info_005"
			);
			bm:progress_on_advice_dismissed(
				"scroll_camera_to_hill",
				function()
					if cutscene_hill:is_active() then
						cutscene_hill:skip();
					end;
				end
			);
		end, 
		500
	);

	-- scroll camera to hill
	cutscene_hill:action(function() cam:move_to(v(-120.2, 340, -144.5), v(-73.0, 263.3, -75), 3, false, 0) end, 1000);

	cutscene_hill:action(
		function()
			proxy_id = uc_player_army:add_animated_selection_proxy(v(-110, -58), v(-37, -104), 1, 3, true)
		end,
		3000
	);

	cutscene_hill:action(function() cutscene_hill:show_esc_prompt() end, 5000);

	cutscene_hill:action(
		function()
			-- automatically proceed if we get this far
			cutscene_hill:skip() 
		end, 
		34000
	);

	cutscene_hill:start();
end;


function scroll_camera_to_deployment_zone()

	bm:scroll_camera_with_cutscene(
		v(34.3, 331.2, -390.0), 
		v(37.4, 297.9, -332.8), 
		3,
		function()
			start_deployment_objective();
		end
	);

	bm:stop_advisor_queue(true);

	bm:callback(
		function()
			-- Yuri
			-- Arrange our forces at the base of the hill, claim the slopes for ourselves.
			bm:queue_advisor("wh3_main_scenario_02_0040");
			bm:add_infotext(
				1,
				"wh3_main_scenario_02_0001",
				"wh3_main_scenario_02_0002"
			);
		end,
		1000
	);
end;










---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Deployment objective
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

ca_deployment = convex_area:new({
	v(-75, -230),
	v(85, -230),
	v(85, -370),
	v(-75, -370)
});

function start_deployment_objective()

	-- allow camera movement and re-enable orders
	bm:enable_camera_movement(true);
	bm:disable_orders(false);
	bm:steal_input_focus(false);

	-- add position marker
	local ping_x = 12;
	local ping_z = -253;
	local ping_y = bm:get_terrain_height(ping_x, ping_z) + 2;

	local ping_type = 9;
	bm:add_ping_icon(ping_x, ping_y, ping_z, ping_type);

	-- allow advice to be dismissed
	show_advisor_progress_button(true);

	-- add objective
	bm:set_objective_with_leader("wh3_main_scenario_02_deploy_01");

	-- watch for objective completion
	bm:watch(
		function()
			return ca_deployment:standing_is_in_area(sunits_player_all) and ca_deployment:number_in_area(sunits_player_all) > 3
		end,
		0,
		function()
			-- prevent movement
			bm:disable_orders(true);

			-- remove position marker
			bm:remove_ping_icon(ping_x, ping_y, ping_z, ping_type);

			-- complete objective
			bm:complete_objective("wh3_main_scenario_02_deploy_01");

			bm:callback(function() deployment_ap_bar_tour() end, 1000);
		end
	);
end;

function deployment_ap_bar_tour()

	-- remove previous objective
	bm:callback(
		function()
			bm:remove_objective("wh3_main_scenario_02_deploy_01");
		end,
		1000
	);
	
	local st_deployment_end = scripted_tour:new(
		"scripted_tour_deployment_end",
		function() deployment_by_hill_objective_completed() end
	);



	st_deployment_end:action(
		function()
			-- show the top bar and allow interaction (so that it's not greyed out)
			bm:show_top_bar(true);
			bm:steal_input_focus(false);

			-- disable unit details panel
			bm:disable_unit_details_panel(true);
		end,
		0
	);

	st_deployment_end:action(
		function()
			-- show time limit text pointer
			local ap_time_limit = active_pointer:new(
				"time_limit", 
				"topright", 
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "simple_timer"), 
				"ui_text_replacements_localised_text_wh3_main_st_battle_time_limit", 
				0.5, 
				1, 
				200,
				true
			);

			ap_time_limit:set_style("minimalist_dont_close");

			ap_time_limit:show();
		end,
		1000
	);

	st_deployment_end:action(
		function()
			-- show balance of power text pointer
			local ap_bop = active_pointer:new(
				"bop", 
				"topleft", 
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "kill_ratio_PH"), 
				"ui_text_replacements_localised_text_wh2_intro_battle_balance_of_power", 
				0.5, 
				1, 
				250,
				true
			);

			ap_bop:add_hide_callback(
				function()
					core:hide_all_text_pointers();
					st_deployment_end:complete();
					
				end,
				0.5
			);

			ap_bop:set_highlight_close_button(2000);

			ap_bop:show();
		end,
		2000
	);

	st_deployment_end:start();
end


function deployment_by_hill_objective_completed()

	-- scroll camera to position behind player's army
			
	-- find a position offset from the player's general
	local player_sunits = bm:get_scriptunits_for_local_players_army();
	if not player_sunits then
		script_error("ERROR: deployment scripted tour could not find player's army - how can this be?");
		return;
	end;

	local player_general_sunit = player_sunits:get_general_sunit();
	if not player_general_sunit then
		-- function call above will have errored if we get here
		return;
	end;

	bm:scroll_camera_with_cutscene(
		player_general_sunit:position_offset(0, 35, -60), 
		player_general_sunit:position_offset(-5, 20, -10), 
		2, 
		function()
			bm:show_radar_frame(true);

			bm:callback(
				function()
					-- Gerik
					-- The soldiers are ready, give the signal and the engagement shall begin!
					bm:queue_advisor("wh3_main_scenario_02_0050");
					bm:modify_advice(false);
					
					bm:callback(
						function()
							local objective_key = "wh3_main_scenario_02_deploy_02";
							bm:set_objective_with_leader(
								objective_key,
								nil,
								nil,
								function()
									-- add objective
									bm:set_objective("wh3_main_scenario_02_deploy_02");

									-- show start battle button
									bm:show_start_battle_button(true);

									-- show elements of ui that are still hidden
									bm:show_winds_of_magic_panel(true);
									bm:show_portrait_panel(true);
								end
							);
						end,
						500
					);
				end,
				1000
			)
		end, 
		nil, 
		false
	);

end;




