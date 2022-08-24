






function jump_to_main_attack_phase()
	out("jump_to_main_attack_phase() called");

	-- show ui
	bm:show_army_panel(true);
	
	if core:is_tweaker_set("SCRIPTED_TWEAKER_40") then
		-- debug tweaker to show portrait panel, allowing unit ability to be triggered
		bm:show_portrait_panel(true);
	end;

	-- start the main attack phase and cutscene
	proceed_to_main_attack();
end;









---------------------------------------------------------
--
-- enemy attack begins cutscene
--
---------------------------------------------------------

cutscene_enemy_attack_begins = cutscene:new_from_cindyscene(
	"cutscene_enemy_attack_begins", 								-- unique string name for cutscene
	sunits_player_all,	 											-- unitcontroller over player's army
	function() play_cutscene_enemy_attack_siege_weapons() end,		-- what to call when cutscene is finished
	"script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_attack.CindySceneManager",
	0,
	4
);

-- cutscene_enemy_attack_begins:set_debug(true);
-- cutscene_enemy_attack_begins:set_post_cutscene_fade_time(0);
cutscene_enemy_attack_begins:set_should_disable_unit_ids(true);
cutscene_enemy_attack_begins:set_skippable(true);

function play_cutscene_enemy_attack_begins()
	
	cutscene_enemy_attack_begins:action(function() cam:fade(false, 0.5) end, 0);
	-- The Wolf's main pack advance on the beacon!
	cutscene_enemy_attack_begins:action(function() bm:queue_advisor("wh3_main_scenario_01_0070") end, 1000);

	--[[
	cutscene_enemy_attack_begins:action(function() cam:move_to(v(29.6, 378.4, -168.9), v(-26.2, 381.1, -203.4), 0, false, 55) end, 0);
	
	cutscene_enemy_attack_begins:action(function() cam:move_to(v(64.0, 380.5, 28.2), v(34.0, 370.2, -29.5), 4, false, 55) end, 4000);
		
	cutscene_enemy_attack_begins:action(function() cutscene_enemy_attack_begins:show_esc_prompt() end, cutscene_enemy_attack_begins_length - 10000);
	]]
	
	cutscene_enemy_attack_begins:start();
end;










---------------------------------------------------------
--
-- enemy attack siege weapons cutscene
--
---------------------------------------------------------

missile_units_infotext_fully_added = false;


-- for gameplay section that follows
pos_cam_artillery_defence_start = v(239.7, 413.4, -485.1);
pos_targ_artillery_defence_start = v(182.4, 388.7, -465.6);

cutscene_enemy_attack_siege_weapons = cutscene:new(
	"cutscene_enemy_attack_siege_weapons",											-- unique string name for cutscene
	sunits_player_all,	 															-- unitcontroller over player's army
	nil,																			-- duration of cutscene in ms
	function()
	end																				-- what to call when cutscene is finished
);

-- cutscene_enemy_attack_siege_weapons:set_debug(true);
cutscene_enemy_attack_siege_weapons:set_close_advisor_on_start(false);
cutscene_enemy_attack_siege_weapons:set_post_cutscene_fade_time(0);
cutscene_enemy_attack_siege_weapons:set_should_disable_unit_ids(true);

cutscene_enemy_attack_siege_weapons:set_skippable(
	true,
	function()
		local end_time = 1000;
		
		bm:stop_advisor_queue();

		if cutscene_enemy_attack_siege_weapons.pan_camera_to_starting_position then
			-- pan camera back to gameplay position
			local camera_scroll_time = 2;

			cam:move_to(pos_cam_artillery_defence_start, pos_targ_artillery_defence_start, camera_scroll_time, false, 0);
			bm:callback(function() set_player_units_invisible_during_artillery_attack_cutscene(false) end, 500);

			end_time = camera_scroll_time * 1000;
		else
			-- cut camera back to gameplay position
			cam:fade(true, 0);
			cam:move_to(pos_cam_artillery_defence_start, pos_targ_artillery_defence_start, 0, false, 0);
			set_player_units_invisible_during_artillery_attack_cutscene(false);
			reposition_artillery_attack_player_army_for_gameplay();

			bm:callback(function() cam:fade(false, 0) end, 1000);
		end;

		bm:callback(
			function() 
				start_artillery_attack_phase()
			end,
			end_time
		);
	end
);

function play_cutscene_enemy_attack_siege_weapons()
	
	cutscene_enemy_attack_siege_weapons:action(function() cam:move_to(v(-13.5, 391.8, -225.0), v(-50.3, 376.8, -275.7), 3, false, 50) end, 0);
	
	cutscene_enemy_attack_siege_weapons:action(
		function() 
			-- The cannons rain death. They must be destroyed!
			bm:queue_advisor("wh3_main_scenario_01_0071");
		end, 
		500
	);
	
	cutscene_enemy_attack_siege_weapons:action(function() reposition_and_advance_artillery_attack_player_army_for_cutscene() end, 3000);
	cutscene_enemy_attack_siege_weapons:action(function() cam:move_to(v(107.6, 430, -475), v(167.4, 369.4, -464.2), 3, false, 50) end, 5000);

	cutscene_enemy_attack_siege_weapons:action(
		function() 
			-- The allies join our forces. We'll need the reach of their bows.
			bm:queue_advisor(
				"wh3_main_scenario_01_0075",
				0,
				false,
				function()
					bm:add_infotext_with_leader(
						"wh2.battle.intro.info_100",
						"wh2.battle.intro.info_101",
						"wh2.battle.intro.info_104",
						function()
							missile_units_infotext_fully_added = true;
						end	
					);
				end
			);
		end, 
		6000
	);

	cutscene_enemy_attack_siege_weapons:action(
		function()
			-- past this point we scroll back to the gameplay camera position rather than cutting
			cutscene_enemy_attack_siege_weapons.pan_camera_to_starting_position = true;
			cam:move_to(v(107.6, 440, -475), v(167.4, 369.4, -464.2), 60, true, 45);
		end, 
		11000
	);

	cutscene_enemy_attack_siege_weapons:action(
		function()
			cutscene_enemy_attack_siege_weapons:show_esc_prompt() 
		end,
		16000
	);

	cutscene_enemy_attack_siege_weapons:start();
end;












---------------------------------------------------------
--
-- artillery attack phase
--
---------------------------------------------------------


-- sai_enemy_main = false;
-- sai_enemy_artillery_defenders = false;
-- sai_allied_main = false;

main_attack_pos = v(63, 37);
main_defence_pos = v(42, 5);

function start_main_enemy_attack()
	-- declared in declarations
	alm_main_attack:start();
end;


function start_enemy_artillery_defence()
	sunits_enemy_artillery_defenders:max_casualties(0);
	sunits_enemy_artillery_defenders:morale_behavior_default();

	--[[
	sai_enemy_artillery_defenders = script_ai_planner:new("enemy_artillery_defenders", sunits_enemy_artillery_defenders);
	sai_enemy_artillery_defenders:set_debug(true);
	-- sai_enemy_artillery_defenders:defend_force(sunits_enemy_artillery, 60);
	sai_enemy_artillery_defenders:defend_position(v(-22, -278), 50);
	-- sai_enemy_artillery_defenders:move_to_force(sunits_player_all);
	]]
	move_enemy_artillery_defence_to_main();
end;

--[[
function start_enemy_artillery_defence_attacking_player()
	sai_enemy_artillery_defenders:attack_force(sunits_player_all);
end;
]]


function apply_protection_to_allied_defenders(should_apply, max_casualties, invincible_for_time_proportion)
	if should_apply then
		sunits_allied_defenders:max_casualties(max_casualties, true);
		sunits_allied_defenders:morale_behavior_fearless_if_standing();
		sunits_allied_defenders:set_invincible_for_time_proportion(invincible_for_time_proportion);
	else
		bm:out("*** removing protection from allied defenders! ***");
		sunits_allied_defenders:max_casualties(0, true);
		sunits_allied_defenders:morale_behavior_default();
		sunits_allied_defenders:set_invincible_for_time_proportion(0);
	end;
end;


marked_enemy_artillery_sunit = false;

function start_artillery_attack_phase()
	out("start_artillery_attack_phase() called");

	-- show cheat sheet panel (this will do nothing if they've already been shown)
	show_battle_controls_cheat_sheet();
	append_selection_controls_to_cheat_sheet();
	append_movement_controls_to_cheat_sheet();
	append_attack_controls_to_cheat_sheet();

	local uic_button_hp_close = find_uicomponent("help_panel", "button_hp_close")
	uic_button_hp_close:SetVisible(true)

	sunits_player_missile_reinforcements_missile_only:change_behaviour_active("skirmish", false);
	script_error("Why doesn't setting the player's units to not skirmish work?");

	-- start enemy defence behaviour
	-- start_enemy_artillery_defence();
	
	-- control the casualty rate of the enemy and allies
	sunits_enemy_main:max_casualties(0.6, true);
	sunits_enemy_main:morale_behavior_fearless();
	sunits_enemy_main:set_invincible_for_time_proportion(0.75);
	
	-- prevent the artillery defenders from rallying if they rout
	sunits_enemy_artillery_and_defenders:prevent_rallying_if_routing(true);
	
	-- cause the artillery to rout when the receive a certain level of casualties
	-- sunits_enemy_artillery:rout_on_casualties(0.6);
	
	-- slow casualty rate of allied defenders
	apply_protection_to_allied_defenders(true, 0.5, 0.75);

	-- set player's forces to be unkillable
	sunits_player_all:morale_behavior_fearless();
	sunits_player_all:max_casualties(0.55, true);
	
	-- give player units a kill aura
	sunits_player_all:start_kill_aura(sunits_enemy_artillery_and_defenders, 20, 0.05);
	
	-- give player infinite ammunition
	sunits_player_all:grant_infinite_ammo();
	
	bm:callback(
		function()
			-- text pointer test
			--[[
			local tp_test = text_pointer:new("test", "worldspace", 20, -3, -373);
			tp_test:add_component_text("text", "advice_info_texts_localised_text_wh2.battle.intro.info_112");
			tp_test:set_panel_state_override("semitransparent");

			tp_test:show();
			]]


			-- Advance on those hellish cannons! They must fall silent if we are to save the Beacon. 
			bm:queue_advisor(
				"wh3_main_scenario_01_0080",
				0,
				false,
				function()
					local function show_obj()						
						-- Destroy the enemy artillery and its defenders.
						bm:set_objective_with_leader("wh3_main_scenario_01_prologue_intro_attacking_03");
					end;

					if missile_units_infotext_fully_added then
						show_obj();
					else
						bm:clear_infotext();
						bm:add_infotext_with_leader(
							"wh2.battle.intro.info_100",
							"wh2.battle.intro.info_101",
							"wh2.battle.intro.info_104",
							function()
								show_obj();
							end
						);
						show_advisor_progress_button(true)
					end;
					
					-- show marker on the enemy artillery unit closest to the centre of all enemy artillery units
					marked_enemy_artillery_sunit = sunits_enemy_artillery:get_centremost();
					marked_enemy_artillery_sunit:add_ping_icon(9);

					local threshold_distance = 180;
					if core:is_tweaker_set("SCRIPTED_TWEAKER_03") then
						threshold_distance = 300;
						script_error("increasing threshold_distance to " .. threshold_distance .. " as SCRIPTED_TWEAKER_03 is set");
					end;
					
					-- monitor for player closing on enemy
					bm:watch(
						function()
							local dist, player_sunit, enemy_sunit = distance_between_forces(sunits_player_all, sunits_enemy_artillery_and_defenders);
							if dist < threshold_distance then
								bm:out("player has closed on artillery defenders, player sunit is " .. player_sunit.name .. " at " .. v_to_s(player_sunit.unit:position()) .. ", enemy sunit is " .. enemy_sunit.name .. " at " .. v_to_s(enemy_sunit.unit:position()) .. ", distance: " .. dist);
								return true;
							end;
						end,
						0,
						function()
							bm:remove_process("player_closes_on_artillery_defenders");
							prepare_for_player_closes_on_artillery_defenders("player has closed on artillery defenders");
						end,
						"player_closes_on_artillery_defenders"
					);
					
					-- failsafe timeout
					bm:callback(
						function() 
							bm:remove_process("player_closes_on_artillery_defenders");
							prepare_for_player_closes_on_artillery_defenders("timeout");
						end,
						240000,
						"player_closes_on_artillery_defenders"
					);
				end
			);
		end,
		1000
	);
	
	-- if the player doesn't trigger the next section within a certain period then remove casualty proteections from the defenders
	--[[
	bm:callback(
		function()
			apply_protection_to_allied_defenders(false);
		end,
		90000,
		"lift_protection_on_allied_defenders"
	);
	]]
end;


function prepare_for_player_closes_on_artillery_defenders(reason)
	bm:out("prepare_for_player_closes_on_artillery_defenders() called, reason: " .. tostring(reason));

	-- have the defenders advance towards the player
	advance_enemy_artillery_defence();

	bm:callback(
		function()
			player_closes_on_artillery_defenders()
		end,
		5000
	);
end;


function player_closes_on_artillery_defenders()
	bm:out("player_closes_on_artillery_defenders() called");

	bm:remove_process("lift_protection_on_allied_defenders");

	-- re-establish protections on allied defenders
	apply_protection_to_allied_defenders(true, 0.5, 0.75);
	
	-- compute cutscene target
	local sunit_closest_artillery_defender = sunits_enemy_artillery_defenders:get_closest(sunits_player_all:centre_point());

	local pos_cam_targ = predict_commander_position(sunit_closest_artillery_defender.unit, 1.5, 2, 2);
	local pos_cam = v_to_ground(position_along_line(pos_cam_targ, sunits_player_all:centre_point(), 20), 5);

	bm:out("closest artillery defender is " .. sunit_closest_artillery_defender.name .. " at position " .. v_to_s(sunit_closest_artillery_defender.unit:position()) .. ", cam targ is " .. v_to_s(pos_cam_targ) .. ", cam is " .. v_to_s(pos_cam));
	
	play_cutscene_artillery_defenders(pos_cam, pos_cam_targ);
end;












---------------------------------------------------------
--
-- artillery defenders cutscene
--
---------------------------------------------------------

cutscene_artillery_defenders_modify_speed = 0.25;
cutscene_artillery_defenders_length = 2000;

cutscene_artillery_defenders = cutscene:new(
	"cutscene_artillery_defenders", 						-- unique string name for cutscene
	sunits_player_all,	 									-- unitcontroller over player's army
	cutscene_artillery_defenders_length,					-- duration of cutscene in ms
	function()
		bm:slow_game_over_time(cutscene_artillery_defenders_modify_speed, 1, 500, 5);
		start_artillery_defence_monitors();
	end														-- what to call when cutscene is finished
);


cutscene_artillery_defenders:set_restore_cam(1);
cutscene_artillery_defenders:set_should_disable_unit_ids(true);
cutscene_artillery_defenders:set_skippable(
	true,
	function()
		cam:fade(true, 0);
		
		bm:callback(
			function()
				cam:fade(false, 0.5);
			end,
			500
		);
	end
);

function play_cutscene_artillery_defenders(pos_cam, pos_cam_targ)
	
	local initial_camera_movement_time = 3;
		
	cutscene_artillery_defenders:action(
		function()			
			cam:move_to(pos_cam, pos_cam_targ, initial_camera_movement_time * cutscene_artillery_defenders_modify_speed, false, 0);
			bm:modify_battle_speed(cutscene_artillery_defenders_modify_speed);
			local end_sfx = new_sfx("Play_Movie_WH3_Prologue_Battle_1_Slow_Motion_Sweetener");
			play_sound_2D(end_sfx);
		end, 
		0
	);
		
	cutscene_artillery_defenders:action(function() play_artillery_defenders_advice() end, 100);
	
	-- Show fullscreen movie
	--[[
	cutscene_artillery_defenders:action(
		function()
			local screen_x, screen_y = core:get_screen_resolution();
			
			local uic_bottom_bar_height = 0;
			local uic_bottom_bar = find_uicomponent(core:get_ui_root(), "cinematic_bars", "bottom_bar");
			if uic_bottom_bar then
				uic_bottom_bar_height = uic_bottom_bar:Height();
			end;
			
			local movie_ratio = 1.6;
			local movie_size_y = screen_y - uic_bottom_bar_height * 2;
			local movie_size_x = movie_size_y * movie_ratio;
			
			-- core:play_overlay_movie("infantry_line", "wh3_form_army", 9000, screen_x - movie_size_x, uic_bottom_bar_height, movie_size_x, movie_size_y, 0, "ui/skins/default/mask_movie_bottom_right.png");
			local mo = movie_overlay:new("infantry_line", "wh3_form_army");
			mo:set_bottom_right_mask_image();
			mo:set_should_loop(true);
			mo:start();
		end,
		cutscene_artillery_defenders_modify_speed * initial_camera_movement_time * 1000
	);
	]]
	
	cutscene_artillery_defenders:start();
end;


function play_artillery_defenders_advice()

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_attacked_artillery", true);

	-- The cannons are defended!
	core:call_once("artillery_defenders_advice", function() bm:queue_advisor("wh3_main_scenario_01_0090") end);
end;


function play_artillery_defenders_battle_line_advice()
	core:call_once(
		"artillery_defenders_battle_line_advice", 
		function()
			bm:clear_infotext();

			-- Order the infantry to form a line, face the enemy. Have your archers remain behind the line. It protects them.
			bm:queue_advisor("wh3_main_scenario_01_0091");

			bm:add_infotext_with_leader(
				"wh2.battle.intro.info_110",
				"wh2.battle.intro.info_112",
				"wh2.battle.intro.info_113"
			);

			show_advisor_progress_button(true)
		end
	);
end;












---------------------------------------------------------
--
-- artillery defence monitors
--
---------------------------------------------------------

function start_artillery_defence_monitors()

	core:hide_all_text_pointers();

	-- pivot one or more enemy artillery pieces against the player
	enemy_artillery_assists_defence();

	play_artillery_defenders_battle_line_advice();

	-- compel the artillery defenders to attack the player under AI control
	-- sai_enemy_artillery_defenders:defend_force(sunits_enemy_artillery, 140);

	-- trigger further advice when the battle is nearly joined
	bm:callback(
		function()
			bm:watch(
				function()
					return distance_between_forces(sunits_player_all, sunits_enemy_artillery_defenders) < 50;
				end,
				0,
				function()
					-- Keep the enemy in front of you! Do not let yourself become surrounded!
					bm:queue_advisor("wh3_main_scenario_01_0100");

					core:stop_all_windowed_movie_players();
				end,
				"artillery_defence_monitors"
			);
		end,
		3000
	);
	
	-- watch for the artillery defenders beginning to break, and deliver advice
	bm:watch(
		function()
			return sunits_enemy_artillery_and_defenders:are_any_routing_or_dead()
		end,
		0,
		function()
			-- The enemy break from the fight! Press your advantage! Destroy their weapons of war!
			bm:queue_advisor("wh3_main_scenario_01_0111");
		end,
		"artillery_defence_monitors"
	);

	-- rout the artillery over time when they've taken enough casualties
	local artillery_hp_threshold = 0.6;
	bm:watch(
		function()
			return sunits_enemy_artillery:unary_hitpoints() < artillery_hp_threshold;
		end,
		0,
		function()
			local duration = 6000;
			bm:out("Beginning to rout enemy artillery over " .. duration .. "ms as it is on less than " .. artillery_hp_threshold * 100 .. "% hp");
			sunits_enemy_artillery:rout_over_time(duration);
		end,
		"artillery_defence_monitors"
	);

	-- watch for enemy artillery all routing, at which point start to diminish strength of defenders
	bm:watch(
		function()
			return sunits_enemy_artillery:are_all_routing_or_dead()
		end,
		0,
		function()
			local objective_key = "wh3_main_scenario_01_prologue_intro_attacking_03";

			marked_enemy_artillery_sunit:remove_ping_icon();
			bm:complete_objective(objective_key);

			if sunits_enemy_artillery_defenders:are_all_routing_or_dead() then
				bm:callback(
					function()
						bm:remove_objective(objective_key);
						start_player_involvement_in_main_battle_phase("artillery defenders routing", true);
					end,
					2000
				);
			else
				bm:out("Enemy artillery are routing/dead and still some defenders remain - routing them over time");
				sunits_enemy_artillery_defenders:rout_over_time(8000, true);

				bm:watch(
					function()
						return sunits_enemy_artillery_and_defenders:are_all_routing_or_dead()
					end,
					2000,
					function()
						bm:remove_objective(objective_key);
						start_player_involvement_in_main_battle_phase("artillery defenders routing", true);
					end
				);
			end;
		end
	);
		
	-- watch for player closing on the main enemy forces
	bm:watch(
		function()
			return distance_between_forces(sunits_player_all, sunits_enemy_main) < 120;
		end,
		0,
		function()
			start_player_involvement_in_main_battle_phase("player approaching main battle");
		end,
		"artillery_defence_monitors"
	);
	
	-- failsafe timeout
	bm:callback(
		function()
			start_player_involvement_in_main_battle_phase("timeout");
		end,
		450000,
		"artillery_defence_monitors"
	);
end;