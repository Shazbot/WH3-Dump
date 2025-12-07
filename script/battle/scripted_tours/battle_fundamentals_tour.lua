


local cam = bm:camera();
local campaign_key = bm:get_campaign_key();
local infotext = get_infotext_manager();
local ui_root = core:get_ui_root();

local sunits_local_player = bm:get_scriptunits_for_local_players_army();
local sunit_local_player_general = sunits_local_player:get_general_sunit();

local sunits_enemy_main = bm:get_scriptunits_for_main_enemy_army_to_local_player();

local sai_enemy = false;

local player_army_has_one_unit = false;
if sunits_local_player:count() == 1 then
	player_army_has_one_unit = true;
end;










-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- BATTLE FUNDAMENTALS
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local function is_battle_type_suitable_for_battle_fundamentals_scripted_tour()
	return bm:battle_type() == "land_normal"
end;

do
	nt_battle_fundamentals = navigable_tour:new(
		"battle_fundamentals",														-- unique name
		function()																	-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_fundamentals_name"
	);

	nt_battle_fundamentals:set_allow_camera_movement(true);
	nt_battle_fundamentals:set_start_first_section_automatically(false);			-- start actions comprise an intro cutscene that can be skipped, so they will start the first section manually

	-- validation rules for this navigable tour
	nt_battle_fundamentals:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			return is_battle_type_suitable_for_battle_fundamentals_scripted_tour();
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_normal_land_battle"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			return nt_battle_fundamentals.bounding_box_to_use;
		end,
		"random_localisation_strings_string_scripted_tour_invalid_suitable_area_not_found"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			local phase_name = bm:get_current_phase_name(); 
			return phase_name == "Deployment" or phase_name == "Deployed"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_deployment_or_conflict_phase"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			return nt_battle_fundamentals.min_player_units_threshold_reached;
		end,
		"random_localisation_strings_string_scripted_tour_invalid_insufficient_player_units"
	);

	nt_battle_fundamentals:add_validation_rule(
		function()
			return nt_battle_fundamentals.min_enemy_units_threshold_reached;
		end,
		"random_localisation_strings_string_scripted_tour_invalid_insufficient_enemy_units"
	);
	
	
	
	
	
	-- Work out what units we will use, and where we will use them, at the start of the battle if this battle is suitable
	if is_battle_type_suitable_for_battle_fundamentals_scripted_tour() and not bm:is_multiplayer() then

		-- Work out what player and enemy units we can/should use for the attacking step of this scripted tour. The script_units collections are saved on the scripted tour itself - the advice preconditions will check their size
		-- and if there aren't enough eligible units (e.g. the player has only a general + artillery in their army) then the advice will not play/the scripted tour will not be offered.
		local MIN_ELIGIBLE_PLAYER_UNITS = 2;
		local MIN_ELIGIBLE_ENEMY_UNITS = 2;

		local player_unit_class_precedence = {
			"inf_mel",
			"inf_spr"
		};

		local enemy_unit_class_precedence = {
			"inf_mel",
			"inf_spr",
			"cav_mel",
			"cav_shk"
		};

		-- Some subcultures have fewer examples of the main unit classes that we would consider eligible for the fundamentals tour.
		-- If the armies in question are of those subcultures then we add in some additional unit classes to the eligible list.
		local subcultures_to_additional_unit_classes_mapping = {
			wh3_main_sc_ksl_kislev = {
				"inf_mis"
			},
			wh3_main_sc_tze_tzeentch = {
				"inf_mis"
			}
		}

		if sunits_local_player:count() > 0 then
			local local_player_subculture = sunits_local_player:item(1):army():subculture_key();
			local additional_unit_classes = subcultures_to_additional_unit_classes_mapping[local_player_subculture];
			if additional_unit_classes then
				for i = 1, #additional_unit_classes do
					table.insert(player_unit_class_precedence, additional_unit_classes[i]);
				end;
			end;
		end;

		if sunits_enemy_main:count() > 0 then
			local main_enemy_subculture = sunits_enemy_main:item(1):army():subculture_key();
			local additional_unit_classes = subcultures_to_additional_unit_classes_mapping[main_enemy_subculture];
			if additional_unit_classes then
				for i = 1, #additional_unit_classes do
					table.insert(enemy_unit_class_precedence, additional_unit_classes[i]);
				end;
			end;
		end;
		
		-- Get a list of eligible player and enemy units to use in the tour
		local sunits_player_eligible = sunits_local_player:filter(
			"player_eligible",
			function(sunit)
				if not sunit.unit:can_fly() then
					local unit_class = sunit.unit:unit_class();
					for i = 1, #player_unit_class_precedence do
						if unit_class == player_unit_class_precedence[i] then
							return true;
						end;
					end;
				end;
			end
		);

		local sunits_enemy_eligible = sunits_enemy_main:filter(
			"enemy_eligible",
			function(sunit)
				if not sunit.unit:can_fly() then
					local unit_class = sunit.unit:unit_class();
					for i = 1, #enemy_unit_class_precedence do
						if unit_class == enemy_unit_class_precedence[i] then
							return true;
						end;
					end;
				end;
			end
		);

		-- Do we have enough eligible units
		local num_eligible_player_units = sunits_player_eligible:count();
		local num_eligible_enemy_units = sunits_enemy_eligible:count();

		nt_battle_fundamentals.min_player_units_threshold_reached = num_eligible_player_units >= MIN_ELIGIBLE_PLAYER_UNITS;
		nt_battle_fundamentals.min_enemy_units_threshold_reached = num_eligible_enemy_units >= MIN_ELIGIBLE_ENEMY_UNITS;

		if nt_battle_fundamentals.min_player_units_threshold_reached and nt_battle_fundamentals.min_enemy_units_threshold_reached then

			-- Determine how many player/enemy units to use
			local num_player_units_to_use, num_enemy_units_to_use;

			if num_eligible_player_units >= 4 then
				num_player_units_to_use = 4;
			else
				num_player_units_to_use = num_eligible_player_units;
			end;

			num_enemy_units_to_use = num_player_units_to_use - 1;

			if num_enemy_units_to_use > num_eligible_enemy_units then
				num_enemy_units_to_use = num_eligible_enemy_units;
				num_player_units_to_use = num_enemy_units_to_use + 1;
			elseif num_enemy_units_to_use < MIN_ELIGIBLE_ENEMY_UNITS then
				num_enemy_units_to_use = MIN_ELIGIBLE_ENEMY_UNITS;
			end;
			
			-- Sort the eligible player sunits, highest-value to lowest-value
			sunits_player_eligible:sort(
				function(sunit1, sunit2)
					return sunit1.unit:strategic_value() > sunit2.unit:strategic_value();
				end
			);

			-- Sort the eligible enemy sunits, lowest-value to highest-value
			sunits_enemy_eligible:sort(
				function(sunit1, sunit2)
					return sunit1.unit:strategic_value() < sunit2.unit:strategic_value();
				end
			);

			-- Work out exactly what units to use
			local sunits_player_to_use = script_units:new("battle_fundamentals_player");
			for i = 1, num_player_units_to_use do
				sunits_player_to_use:add_sunits(sunits_player_eligible:item(i));
			end;

			local sunits_enemy_to_use = script_units:new("battle_fundamentals_enemy");
			for i = 1, num_enemy_units_to_use do
				sunits_enemy_to_use:add_sunits(sunits_enemy_eligible:item(i));
			end;

			-- By this point we should have player and enemy sunit collections to use in the scripted tour - save these to the tour object
			nt_battle_fundamentals.sunits_player = sunits_player_to_use;
			nt_battle_fundamentals.sunits_enemy = sunits_enemy_to_use;

			out.scripted_tours("");
			out.scripted_tours("Battle Fundamentals scripted tour is working out what units/battlefield area to use");
			out.inc_tab("scripted_tours");

			out.scripted_tours("player sunits:");
			for i = 1, sunits_player_to_use:count() do
				local current_sunit = sunits_player_to_use:item(i);
				out.scripted_tours("\t" .. i .. ": " .. current_sunit.name .. " of type " .. current_sunit.unit:type() .. " at position " .. v_to_s(current_sunit.unit:position()) .. " with strategic value " .. current_sunit.unit:strategic_value());
			end;

			out.scripted_tours("");
			out.scripted_tours("enemy sunits:");
			for i = 1, sunits_enemy_to_use:count() do
				local current_sunit = sunits_enemy_to_use:item(i);
				out.scripted_tours("\t" .. i .. ": " .. current_sunit.name .. " of type " .. current_sunit.unit:type() .. " at position " .. v_to_s(current_sunit.unit:position()) .. " with strategic value " .. current_sunit.unit:strategic_value());
			end;

			-- Compile collections of scriptunits in the primary player and primary enemy forces that we didn't use, as we have to treat them specially later
			local sunits_player_unused = script_units:new("battle_fundamentals_player_unused");
			for i = 1, sunits_local_player:count() do
				local current_sunit = sunits_local_player:item(i);
				if not sunits_player_to_use:contains(current_sunit) then
					sunits_player_unused:add_sunits(current_sunit);
				end;
			end;

			local sunits_enemy_unused = script_units:new("battle_fundamentals_enemy_unused");
			for i = 1, sunits_enemy_main:count() do
				local current_sunit = sunits_enemy_main:item(i);
				if not sunits_enemy_to_use:contains(current_sunit) then
					sunits_enemy_unused:add_sunits(current_sunit);
				end;
			end;

			nt_battle_fundamentals.sunits_player_unused = sunits_player_unused;
			nt_battle_fundamentals.sunits_enemy_unused = sunits_enemy_unused;


			
		

		
			--
			--
			-- Work out the area we would want to use for this scripted tour

			local player_sunits_width = sunits_player_to_use:width();
			local enemy_sunits_width = sunits_enemy_to_use:width();

			-- Compute a width/depth
			local combat_area_width = player_sunits_width > enemy_sunits_width and player_sunits_width or enemy_sunits_width;
			local combat_area_depth = 220;


			
			local function get_suitability_score_for_bounding_box(pos, bearing_deg, width, depth)
				local score;
				local area_clear = bm:is_area_clear(pos, bearing_deg, width, depth);
				if area_clear then
					score = 100 - ground_type_proportion_in_bounding_box(pos, d_to_r(bearing_deg), width + 140, depth, "forest", 8, 8);
				else
					score = 0;
				end;

				out.scripted_tours("suitability score for obb at " .. v_to_s(pos) .. " with bearing " .. bearing_deg .. " (deg), width " .. width .. " and depth " .. depth .. " is [" .. score .. (area_clear and "]" or "] - area is not clear of terrain obstructions"))

				return score;
			end;


			
			local sunit_player_general_pos = sunit_local_player_general.unit:position();
			local sunit_player_general_bearing_deg = sunit_local_player_general.unit:ordered_bearing();
			local sunit_player_general_bearing_rad = d_to_r(sunit_player_general_bearing_deg);

			local bounding_box_to_use;

			local highest_score = 0;
			local highest_score_position;
			local highest_score_bearing_deg;

			-- If the box projected forward from the player general is suitable then just proceed with that
			do
				local centre_pos = v_offset_by_bearing(sunit_player_general_pos, sunit_player_general_bearing_rad, combat_area_depth / 2);
				local score = get_suitability_score_for_bounding_box(centre_pos, sunit_player_general_bearing_deg, combat_area_width, combat_area_depth);
				if score > 90 then
					bounding_box_to_use = {
						pos = centre_pos,
						bearing = sunit_player_general_bearing_deg,
						width = combat_area_width,
						depth = combat_area_depth
					};

					out.dec_tab("scripted_tours");
					out.scripted_tours("Chosen this straight-ahead-from-player-start bounding box position as the tour combat area");
				else
					highest_score = score;
					highest_score_position = centre_pos;
					highest_score_bearing = sunit_player_general_bearing_deg;
				end;
			end;

			if not bounding_box_to_use then
				-- The straight-ahead-from-general position wasn't that good, so assemble a series of positions running left-to-right from the player general's perspective.
				local positions_to_test_from = {};

				local perpedicular_bearing_rad = sunit_player_general_bearing_rad + (math.pi / 2);
				for i = -300, 300, 100 do
					if i ~= 0 then
						table.insert(positions_to_test_from, v_offset_by_bearing(sunit_player_general_pos, perpedicular_bearing_rad, i));
					end;
				end;
				
				-- Test each of the 4 cardinal directions from the player general's facing, for each position to test from
				for i = 0, 3 do
					local bearing_to_test_deg = sunit_player_general_bearing_deg + (i * 90);
					local bearing_to_test_rad = d_to_r(bearing_to_test_deg);

					for j = 1, #positions_to_test_from do
						local current_pos = positions_to_test_from[j];

						-- Compute a centre position projected forward from the current position, based on the bearing we're currently testing
						local centre_position = v_offset_by_bearing(current_pos, bearing_to_test_rad, combat_area_depth / 2);
						local score = get_suitability_score_for_bounding_box(centre_position, bearing_to_test_deg, combat_area_width, combat_area_depth);

						if score > highest_score then
							highest_score = score;
							highest_score_position = centre_position;
							highest_score_bearing_deg = bearing_to_test_deg;
						end;
					end;

					-- At the end of each pass, see if we've found something really good
					if highest_score > 90 then
						bounding_box_to_use = {
							pos = highest_score_position,
							bearing = highest_score_bearing_deg,
							width = combat_area_width,
							depth = combat_area_depth
						};
						out.dec_tab("scripted_tours");
						out.scripted_tours("Chosen bounding box at " .. v_to_s(highest_score_position) .. " with bearing " .. highest_score_bearing_deg .. " as the tour combat area");
						break;
					else

						-- At the end of the first pass, re-insert the player general position in the list (otherwise we'd test the straight-ahead obb twice)
						if i == 0 then
							table.insert(positions_to_test_from, sunit_player_general_pos);
						end;
					end;
				end;

				if not bounding_box_to_use then
					out.dec_tab("scripted_tours");

					local low_threshold = 50;

					-- We haven't found a good area to use, so see if the best area that we did find is "okay"
					if highest_score > low_threshold then
						bounding_box_to_use = {
							pos = highest_score_position,
							bearing = highest_score_bearing_deg,
							width = combat_area_width,
							depth = combat_area_depth
						};
						out.scripted_tours("Chosen bounding box at " .. v_to_s(highest_score_position) .. " with bearing " .. highest_score_bearing_deg .. " as the tour combat area");
					else
						out.scripted_tours("Not choosing any bounding box as none reach low threshold value [" .. low_threshold .. "] - tour will not be accessible");
					end;
				end;
			end;

			nt_battle_fundamentals.bounding_box_to_use = bounding_box_to_use;
		end;
	end;


	local function reposition_sunits_for_tour(bounding_box, sunits, is_enemy)
		local uc = sunits:get_unitcontroller();

		if is_enemy then
			uc:teleport_to_location(v_offset_by_bearing(bounding_box.pos, d_to_r(bounding_box.bearing), bounding_box.depth / 2), bounding_box.bearing + 180, bounding_box.width);
		else
			uc:teleport_to_location(v_offset_by_bearing(bounding_box.pos, d_to_r(bounding_box.bearing), 0 - bounding_box.depth / 2), bounding_box.bearing, bounding_box.width);
		end;
	end;










	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------

	-- Returns true if a tooltip over any unit is visible
	local function is_unit_tooltip_visible()
		local uic_tooltip = find_uicomponent(ui_root, "SpecialTooltip", "tooltip");
		return uic_tooltip and uic_tooltip:Visible(true);
	end;

	local tooltip_visible_timestamp = false;
	local allow_tooltip_objective_completion = false;
	
	local nts_intro = st_helper.navigable_tour_section_battle_factory(
		"intro",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0010",
			"wh3_main_st_battle_fundamentals_0011",
			"wh3_main_st_battle_fundamentals_0012"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_inspect_unit",		-- objective
		function()											-- objective test
			if not allow_tooltip_objective_completion then
				return false;
			end;
			
			local tooltip_visible = is_unit_tooltip_visible();

			if tooltip_visible then
				if tooltip_visible_timestamp then
					-- Return true if more than 1.5s has elapsed since the tooltip was first visible
					if os.clock() - tooltip_visible_timestamp > 1.5 then
						tooltip_visible_timestamp = false;
						return true;
					end;
				else
					-- Tooltip has just now become visible - record the timestamp
					tooltip_visible_timestamp = os.clock();	
				end;
			else
				-- Tooltip is not visible, so ensure the timestamp is false
				tooltip_visible_timestamp = false;
			end;
		end,
		true												-- leave objective after completion
	);

	nts_intro:action(
		function()
			allow_tooltip_objective_completion = false;
			nt_battle_fundamentals:set_allow_camera_movement(false);
			nts_intro:add_skip_action(
				function()
					nt_battle_fundamentals:set_allow_camera_movement(true);
				end
			);
		end,
		5
	);

	nts_intro:action(
		function()
			allow_tooltip_objective_completion = true;
		end,
		5000
	);









	-------------------------------------------------
	--- Section 02 : Camera Movement
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0021", "battle_controls_camera");
	infotext:set_state_override("wh3_main_st_battle_fundamentals_0022", "battle_controls_camera_facing");
	infotext:set_state_override("wh3_main_st_battle_fundamentals_0023", "battle_controls_camera_altitude");
	infotext:set_state_override("wh3_main_st_battle_fundamentals_0024", "battle_controls_camera_speed");

	local nts_camera_movement_tracker_started = false;
	
	local nts_camera_movement = st_helper.navigable_tour_section_battle_factory(
		"camera_movement",									-- section name
		function() 
			-- get_offset_camera_positions_from_sunits() returns three camera co-ordinates but we only want to return two, so there's no camera animation
			local cam_pos, cam_targ = st_helper.get_offset_camera_positions_from_sunits(
				nt_battle_fundamentals.sunits_player, 			-- sunits
				0, 												-- x_offset
				-65,											-- z_offset
				nil,											-- h_bearing
				nil,											-- v_bearing
				nil,											-- h_bearing_delta
				true											-- relaxed pose
			);
			return cam_pos, cam_targ;
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0020",
			"wh3_main_st_battle_fundamentals_0021",
			"wh3_main_st_battle_fundamentals_0022",
			"wh3_main_st_battle_fundamentals_0023",
			"wh3_main_st_battle_fundamentals_0024"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_move_camera",		-- objective
		function()											-- objective test
			if nts_camera_movement_tracker_started then
				local cam_distance_travelled = bm:get_camera_distance_travelled();
				return cam_distance_travelled > 200 or (cam_distance_travelled > 100 and bm:get_camera_altitude_change() > 10);
			end;
		end
	);

	nts_camera_movement:action(
		function()
			nts_camera_movement_tracker_started = false;

			bm:show_army_panel(false);
			core:restore_boolean_preference("ui_mouse_scroll");
		end,
		0
	);

	nts_camera_movement:action(
		function()
			-- Track camera movement, for objective test
			bm:start_camera_movement_tracker();

			nts_camera_movement_tracker_started = true;

			nts_camera_movement:add_skip_action(
				function()
					bm:stop_camera_movement_tracker();
				end
			);
		end,
		2000 + nts_camera_movement.camera_scroll_time_s * 1000
	);






	-------------------------------------------------
	--- Section 03 : Unit Selection
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0032", "battle_controls_selection");
	
	local nts_unit_selection = st_helper.navigable_tour_section_battle_factory(
		"unit_selection",									-- section name
		function()
			-- sunits, x_offset, z_offset, horizontal_bearing, vertical_bearing, horizontal_bearing_delta, relaxed pose
			return st_helper.get_offset_camera_positions_from_sunits(
				nt_battle_fundamentals.sunits_player,
				0,
				-75,
				nil,
				nil,
				nil,
				true
			);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0030",
			"wh3_main_st_battle_fundamentals_0031",
			"wh3_main_st_battle_fundamentals_0032",
			"wh3_main_st_battle_fundamentals_0033",
			"wh3_main_st_battle_fundamentals_0034"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_select_unit",		-- objective
		function()											-- objective test
			return bm:is_any_unit_selected();
		end
	);

	nts_unit_selection:action(
		function()
			bm:clear_selection();
		end,
		0
	);

	nts_unit_selection:action(
		function()
			bm:show_army_panel(true);
			show_battle_controls_cheat_sheet(true);
			core:restore_boolean_preference("ui_selection_markers");
			core:restore_boolean_preference("ui_unit_select_outlines");

			nt_battle_fundamentals.sunits_player:release_control();
		end,
		1000
	);











	-------------------------------------------------
	--- Section 04 : Multiple Selection
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0041", "battle_controls_multiple_selection");
	
	local nts_multiple_selection = st_helper.navigable_tour_section_battle_factory(
		"multiple_selection",								-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0040",
			"wh3_main_st_battle_fundamentals_0041",
			"wh3_main_st_battle_fundamentals_0042",
			"wh3_main_st_battle_fundamentals_0043"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_select_multiple_units",				-- objective
		function()											-- objective test
			local num_units_selected = bm:num_units_selected();
			return num_units_selected > 1 or (num_units_selected == 1 and player_army_has_one_unit);
		end
	);

	nts_multiple_selection:action(
		function()
			bm:clear_selection();
		end,
		0
	);

	nts_multiple_selection:action(
		function()
			append_single_selection_controls_to_cheat_sheet();
		end,
		1000
	);






	-------------------------------------------------
	--- Section 05 : Unit Movement
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0051", "battle_controls_unit_movement");
	infotext:set_state_override("wh3_main_st_battle_fundamentals_0052", "battle_controls_unit_destinations");
	infotext:set_state_override("wh3_main_st_battle_fundamentals_0053", "battle_controls_halt");
	
	local nts_unit_movement = st_helper.navigable_tour_section_battle_factory(
		"unit_movement",								-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0050",
			"wh3_main_st_battle_fundamentals_0051",
			"wh3_main_st_battle_fundamentals_0052",
			"wh3_main_st_battle_fundamentals_0053"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_move_unit",		-- objective
		function()											-- objective test
			return nt_battle_fundamentals.sunits_player:have_any_moved(nil, 5);
		end
	);

	nts_unit_movement:action(
		function()
			-- Re-enable orders
			bm:disable_orders(false);

			bm:clear_selection();

			-- Cache location for objective completion
			nt_battle_fundamentals.sunits_player:cache_location();
		end,
		0
	);

	nts_unit_movement:action(
		function()
			append_multiple_selection_controls_to_cheat_sheet();
		end,
		1000
	);








	-------------------------------------------------
	--- Section 06 : Multiple Unit Movement
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0061", "battle_controls_drag_out_formation");
	
	local nts_multiple_movement = st_helper.navigable_tour_section_battle_factory(
		"multiple_movement",								-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0060",
			"wh3_main_st_battle_fundamentals_0061",
			"wh3_main_st_battle_fundamentals_0062"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_move_multiple_units",				-- objective
		function()											-- objective test
			local num_moved = nt_battle_fundamentals.sunits_player:num_moved(nil, 5);
			return num_moved > 1 or (player_army_has_one_unit and num_moved == 1);
		end
	);

	local pos_proxy_centre, pos_proxy_left, pos_proxy_right;
	local cam_pos_nts_multiple_movement, cam_targ_nts_multiple_movement;
	local proxy_id;

	local function setup_movement_proxies()
		local bounding_box = nt_battle_fundamentals.bounding_box_to_use;
		local bounding_box_bearing_r = d_to_r(bounding_box.bearing);
		local bounding_box_half_width = bounding_box.width / 2;
		
		local bounding_box_left = v_offset_by_bearing(bounding_box.pos, bounding_box_bearing_r - math.pi / 2, bounding_box_half_width);
		local bounding_box_right = v_offset_by_bearing(bounding_box.pos, bounding_box_bearing_r + math.pi / 2, bounding_box_half_width);
		
		local sunits_player = nt_battle_fundamentals.sunits_player;
		local most_forward_sunit, most_forward_sunit_distance = nil, -999999;

		for i = 1, sunits_player:count() do
			local current_sunit = sunits_player:item(i);
			local current_distance = distance_to_line(bounding_box_right, bounding_box_left, current_sunit.unit:position());
			
			if current_distance > most_forward_sunit_distance then
				most_forward_sunit_distance = current_distance;
				most_forward_sunit = current_sunit;
			end;
		end;

		local distance_of_units_to_proxy = most_forward_sunit_distance + 60;

		pos_proxy_centre = v_offset_by_bearing(bounding_box.pos, bounding_box_bearing_r, distance_of_units_to_proxy);
		pos_proxy_left = v_to_ground(v_offset_by_bearing(pos_proxy_centre, bounding_box_bearing_r - math.pi / 2, bounding_box_half_width), 1);
		pos_proxy_right = v_to_ground(v_offset_by_bearing(pos_proxy_centre, bounding_box_bearing_r + math.pi / 2, bounding_box_half_width), 1);
	end;


	local function show_movement_proxies()
		if not proxy_id then
			proxy_id = nt_battle_fundamentals.sunits_player:get_unitcontroller():add_animated_selection_proxy(pos_proxy_left, pos_proxy_right, 1, 3, true);
		end;
	end;


	local function remove_movement_proxies()
		if proxy_id then
			nt_battle_fundamentals.sunits_player:get_unitcontroller():remove_animated_selection_proxy(proxy_id);
			proxy_id = nil;
		end;
	end;


	local function restore_camera(period)
		if nts_multiple_movement.cached_cam_pos and nts_multiple_movement.cached_cam_targ then
			cam:move_to(nts_multiple_movement.cached_cam_pos, nts_multiple_movement.cached_cam_targ, period, false, 0);
		end;
	end;


	nts_multiple_movement:action(
		function()
			append_single_movement_controls_to_cheat_sheet();
		end,
		1000
	);

	nts_multiple_movement:action(
		function()
			bm:clear_selection();

			-- compute the positions of the movement proxy
			setup_movement_proxies();

			-- compute camera position offset from the movement proxy
			local cam_pos = st_helper.get_offset_camera_positions_by_bearing(pos_proxy_centre, 100, d_to_r(nt_battle_fundamentals.bounding_box_to_use.bearing) + math.pi, nil, 0);

			-- cache the current camera position
			nts_multiple_movement.cached_cam_pos = cam:position();
			nts_multiple_movement.cached_cam_targ = cam:target();

			-- disable player camera movement
			bm:enable_camera_movement(false);
			-- bm:enable_cinematic_ui(true, false, false);

			-- move the camera to the computed position
			cam:move_to(cam_pos, pos_proxy_centre, 1.5, false, 0);

			-- Cache locations for objective completion
			nt_battle_fundamentals.sunits_player:cache_location();

			nts_multiple_movement:add_skip_action(
				function()
					bm:enable_camera_movement(true);
				end,
				"disable_camera_movement"
			);

			nts_multiple_movement:add_skip_action(
				function()
					restore_camera(0);
				end,
				"restore_camera"
			);
		end,
		5
	);

	-- Show unit proxies
	nts_multiple_movement:action(
		function()
			local sunits_player = nt_battle_fundamentals.sunits_player;

			show_movement_proxies();

			for i = 1, sunits_player:count() do
				local current_sunit = sunits_player:item(i);
				bm:register_unit_selection_callback(
					sunits_player:item(i).unit,
					function()
						remove_movement_proxies();
					end
				);
			end;

			nts_multiple_movement:add_skip_action(
				function()
					remove_movement_proxies();
				end
			);
		end,
		1500
	);

	--Restore camera
	nts_multiple_movement:action(
		function()
			restore_camera(1.5);
		end,
		3500
	);

	-- Re-enable camera movement
	nts_multiple_movement:action(
		function()
			bm:enable_camera_movement(true);
			nts_multiple_movement:remove_skip_action("disable_camera_movement");
			nts_multiple_movement:remove_skip_action("restore_camera");
		end,
		5000
	);





	-------------------------------------------------
	--- Section 07 : Pausing
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0061", "battle_controls_drag_out_formation");
	
	-- Hack to set the objective interval shorter for this nts
	local __add_objective_interval = navigable_tour_section.__add_objective_interval;
	navigable_tour_section.__add_objective_interval = 500;

	local battle_paused_for_objective = false;
	local first_battle_speed_check_passed = false;

	local nts_pausing = st_helper.navigable_tour_section_battle_factory(
		"pausing",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0065",
			"wh3_main_st_battle_fundamentals_0066",
			"wh3_main_st_battle_fundamentals_0067"
		},													-- infotext
		nil,												-- advice/infotext delay
		"wh3_main_st_battle_fundamentals_unpause_battle",	-- objective
		function()											-- objective test
			local current_battle_speed = bm:current_battle_speed();
			if battle_paused_for_objective and current_battle_speed > 0 then
				-- We have to pass two checks in a row
				if first_battle_speed_check_passed then
					first_battle_speed_check_passed = false;
					battle_paused_for_objective = false;
					return true;
				else
					first_battle_speed_check_passed = true;
				end;
			end;
		end
	);
	
	navigable_tour_section.__add_objective_interval = __add_objective_interval;

	nts_pausing:action(
		function()
			-- Manually activate the tour controls
			nts_pausing:activate_tour_controls();

			bm:disable_pausing(false);
			bm:disable_time_speed_controls(false);
			bm:modify_battle_speed(0);

			battle_paused_for_objective = true;
		end,
		1000
	);






	-------------------------------------------------
	--- Section 08 : Attacking
	-------------------------------------------------

	infotext:set_state_override("wh3_main_st_battle_fundamentals_0071", "battle_controls_attacking");

	local nts_attacking;
	nts_attacking = st_helper.navigable_tour_section_battle_factory(
		"attacking",										-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0070",
			"wh3_main_st_battle_fundamentals_0071",
			"wh3_main_st_battle_fundamentals_0072",
			"wh3_main_st_battle_fundamentals_0073"
		},													-- infotext
		"ScriptEventTriggerFundamentalsTourAttackingText",	-- advice/infotext delay - event to trigger infotext/objective on
		"wh3_main_st_battle_fundamentals_attack_units",		-- objective
		function()											-- objective completion test
			if nt_battle_fundamentals.sunits_enemy:is_under_attack() then
				-- This callback will be cancelled if the section is skipped before it fires
				bm:callback(
					function()
						nt_battle_fundamentals:start_next_section();
					end,
					15000,
					"attacking_section_advance_to_flanking"
				);

				nts_attacking:add_skip_action(
					function()
						bm:remove_process("attacking_section_advance_to_flanking");
					end
				);

				return true;
			end;
		end,
		false												-- leave objective after completion
	);

	local animated_arrow_records;

	local function setup_animated_arrows()
		animated_arrow_records = {};

		local sunits_player = nt_battle_fundamentals.sunits_player;
		local sunits_enemy = nt_battle_fundamentals.sunits_enemy;

		local bounding_box = nt_battle_fundamentals.bounding_box_to_use;

		local bounding_box_bearing_r = d_to_r(bounding_box.bearing);

		local pos_centre_left = v_offset_by_bearing(bounding_box.pos, bounding_box_bearing_r - math.pi / 2, bounding_box.width / 2);
		local pos_front_left = v_offset_by_bearing(pos_centre_left, bounding_box_bearing_r, bounding_box.depth / 2);

		-- Make a table of player units sorted from left to right in bounding box
		local player_sunits_left_to_right = table.copy(sunits_player:get_sunit_table());
		for i = 1, #player_sunits_left_to_right do
			local current_sunit = player_sunits_left_to_right[i];
			current_sunit.distance_to_bounding_box_left = distance_to_line(pos_front_left, pos_centre_left, current_sunit.unit:position());
		end;

		table.sort(
			player_sunits_left_to_right, 
			function(sunit1, sunit2)
				return sunit1.distance_to_bounding_box_left > sunit2.distance_to_bounding_box_left;
			end
		);

		-- Make a table of enemy units sorted from left to right (from player's position)
		local enemy_sunits_left_to_right = table.copy(sunits_enemy:get_sunit_table());
		for i = 1, #enemy_sunits_left_to_right do
			local current_sunit = enemy_sunits_left_to_right[i];
			current_sunit.distance_to_bounding_box_left = distance_to_line(pos_front_left, pos_centre_left, current_sunit.unit:position());
		end;

		table.sort(
			enemy_sunits_left_to_right, 
			function(sunit1, sunit2)
				return sunit1.distance_to_bounding_box_left > sunit2.distance_to_bounding_box_left;
			end
		);

		-- If the player has more units than the enemy then build a list of units to double up on
		local num_enemies_to_double_up_on = #player_sunits_left_to_right - #enemy_sunits_left_to_right;
		local enemies_to_double_up_on = {};

		if num_enemies_to_double_up_on > 0 then
			-- Make a table of enemies by descending value, and add each in turn to the enemies_to_double_up_on list, so that its the highest value enemy targets that are doubled up on
			local enemies_by_value = table.copy(enemy_sunits_left_to_right);
			table.sort(
				enemies_by_value, 
				function(sunit1, sunit2)
					return sunit1.unit:strategic_value() > sunit2.unit:strategic_value()
				end
			);

			if num_enemies_to_double_up_on > #enemies_by_value then
				script_error("WARNING: nts_attacking() is trying to determine which enemies we should double up on while drawing animated arrows and it seems that we have more enemies to double up on than we have enemies? Is the size disparity between the player's force and the enemy force really so large? Some arrows won't be drawn");
				num_enemies_to_double_up_on = #enemies_by_value;
			end;

			for i = 1, num_enemies_to_double_up_on do
				enemies_to_double_up_on[enemies_by_value[i]] = true;
			end;
		end;

		-- Loop through player sunits and assign them to enemy sunits in order to draw an animated arrow between them, taking in to account enemies to double up on
		local j = 1;
		for i = 1, #player_sunits_left_to_right do
			local sunit_player_current = player_sunits_left_to_right[i];
			local sunit_enemy_current = enemy_sunits_left_to_right[j];

			table.insert(
				animated_arrow_records,
				{
					sunit_player = sunit_player_current,
					sunit_enemy = sunit_enemy_current
				}
			);

			if enemies_to_double_up_on[sunit_enemy_current] then
				enemies_to_double_up_on[sunit_enemy_current] = nil;
			elseif j < #enemy_sunits_left_to_right then
				j = j + 1;
			end;
		end;
		
		-- For each animated arrow record we have, determine the actual start and end co-ordinates on a line between the player unit and the target enemy unit
		for i = 1, #animated_arrow_records do
			local current_record = animated_arrow_records[i];

			local pos_sunit_player = current_record.sunit_player.unit:position();
			local pos_sunit_enemy = current_record.sunit_enemy.unit:position();

			current_record.pos_start = position_along_line_unary(pos_sunit_player, pos_sunit_enemy, 0.1);
			current_record.pos_end = position_along_line_unary(pos_sunit_player, pos_sunit_enemy, 0.70);
		end;
	end;


	local function draw_animated_arrows()
		if not animated_arrow_records then
			return;
		end;

		for i = 1, #animated_arrow_records do
			local current_record = animated_arrow_records[i];
			if current_record.pos_start and current_record.pos_end then
				bm:callback(
					function()
						current_record.index = bm:add_animated_arrow(0.8, 2, false, current_record.pos_start, current_record.pos_end);
					end,
					i * 500,
					"nts_attacking_draw_animated_arrows"
				);
			end;
		end;
	end;


	local function remove_animated_arrows()
		if not animated_arrow_records then
			return;
		end;

		bm:remove_process("nts_attacking_draw_animated_arrows");

		for i = 1, #animated_arrow_records do
			local current_record = animated_arrow_records[i];
			if current_record.index then
				bm:remove_animated_arrow(current_record.index);
			end;
		end;

		animated_arrow_records = nil;
	end;


	local function reset_armies_for_start_of_attacking_section()
		nt_battle_fundamentals.sunits_enemy:set_enabled(true);

		-- We respawn the units and then reposition them immediately
		nt_battle_fundamentals.sunits_player:respawn_in_start_location();
		nt_battle_fundamentals.sunits_enemy:respawn_in_start_location();

		nt_battle_fundamentals.sunits_player:set_always_visible(true);
		nt_battle_fundamentals.sunits_enemy:set_always_visible(true);

		reposition_sunits_for_tour(nt_battle_fundamentals.bounding_box_to_use, nt_battle_fundamentals.sunits_player, false);
		reposition_sunits_for_tour(nt_battle_fundamentals.bounding_box_to_use, nt_battle_fundamentals.sunits_enemy, true);		
	end;

	local function start_enemy_army_attack()
		local sunits_enemy = nt_battle_fundamentals.sunits_enemy;
		sunits_enemy:release_control();

		if not sai_enemy then
			sai_enemy = script_ai_planner:new("enemy_army", sunits_enemy);

			sai_enemy:attack_force(nt_battle_fundamentals.sunits_player);
			-- sai_enemy:defend_position(nt_battle_fundamentals.bounding_box_to_use.pos, 3 * nt_battle_fundamentals.bounding_box_to_use.depth / 2);
		end;
	end;

	local function release_enemy_from_planner()
		if is_scriptaiplanner(sai_enemy) and sai_enemy:count() > 0 then
			sai_enemy:release();
		end;
	end;

	local function compute_final_camera_position_for_attacking_section()
		-- sunits, x_offset, z_offset, horizontal_bearing override, vertical_bearing, horizontal_bearing_delta, relaxed pose
		nts_attacking.final_cam_target, nts_attacking.final_cam_position = st_helper.get_offset_camera_positions_from_sunits(
			nt_battle_fundamentals.sunits_player,
			0,
			-75,
			nil,
			nil,
			nil,
			true
		);
	end;

	-- actions
	nts_attacking:action(
		function()

			-- Fade camera to black and enable cinematic ui
			cam:fade(true, 0.5);
			bm:enable_cinematic_ui(true, false, false);

			nts_attacking:add_skip_action(
				function()
					bm:enable_cinematic_ui(false, true, false);
				end,
				"disable_cinematic_ui"
			);

			nts_attacking:add_skip_action(
				function(tour_ending, skipping_backwards)
					if not tour_ending and not skipping_backwards then
						-- We're skipping forwards before the attacking army has been established, so quickly establish it (and reset the player)

						-- Fade camera to black immediately
						cam:fade(true, 0);

						-- Reposition armies
						bm:callback(
							function()
								reset_armies_for_start_of_attacking_section();
							end,
							200
						);

						-- Compute and reposition final camera position
						bm:callback(
							function()
								compute_final_camera_position_for_attacking_section();

								cam:move_to(nts_attacking.final_cam_position, nts_attacking.final_cam_target, 0);
								cam:fade(false, 0.5);

								start_enemy_army_attack();
								nt_battle_fundamentals.sunits_player:release_control();
							end,
							500
						);
					end;
				end,
				"establish_attacking_army"
			);
		end,
		0
	);

	nts_attacking:action(
		function()
			-- show the cinematic bars now the screen is blacked-out
			bm:enable_cinematic_ui(false, false, false);
			bm:enable_cinematic_ui(true, false, true);

			reset_armies_for_start_of_attacking_section();

			nts_attacking:add_skip_action(
				function(tour_ending, skipping_backwards)
					if not tour_ending then
						if skipping_backwards then
							-- We're skipping backwards, so disable the enemy army
							nt_battle_fundamentals.sunits_enemy:set_enabled(false);
						end;
					end;
				end
			);
		end,
		700
	);

	nts_attacking:action(
		function()
			-- Move enemy forward
			nt_battle_fundamentals.sunits_enemy:goto_location_offset(0, 30, false);
		end,
		1000
	);

	nts_attacking:action(
		function()
			-- Compute camera positions for the enemy units walking on

			-- sunits, x_offset, z_offset, horizontal_bearing override, vertical_bearing, horizontal_bearing_delta, relaxed pose
			local cam_target, cam_position_1 = st_helper.get_offset_camera_positions_from_sunits(
				nt_battle_fundamentals.sunits_enemy,
				-50 - (nt_battle_fundamentals.sunits_enemy:width() / 2),
				60,
				nil,
				0.2,
				0
			);

			local cam_position_2 = st_helper.get_second_offset_camera_position(cam_target, cam_position_1);

			-- Also compute final camera positions for the tour section at this time and store them for later
			compute_final_camera_position_for_attacking_section();

			local cutscene_enemy_attack = cutscene:new(
				"enemy_attack",
				nt_battle_fundamentals.sunits_player,
				nil,
				function()
					append_movement_controls_to_cheat_sheet();

					bm:enable_cinematic_ui(false, true, false);

					bm:hide_subtitles();

					bm:cancel_progress_on_sound_effect_finished("battle_fundamentals_attack");

					nt_battle_fundamentals.sunits_player:release_control();
					start_enemy_army_attack();

					nts_attacking:remove_skip_action("disable_cinematic_ui");
					nts_attacking:remove_skip_action("establish_attacking_army");

					core:trigger_event("ScriptEventTriggerFundamentalsTourAttackingText");

					-- Move camera to final position behind player army
					cam:move_to(nts_attacking.final_cam_position, nts_attacking.final_cam_target, 3, false, 0);

					bm:callback(
						function()
							setup_animated_arrows();
							draw_animated_arrows();
							nts_attacking:add_skip_action(
								function()
									remove_animated_arrows();
								end
							);
						end,
						0,
						"nts_attacking_show_animated_arrows"
					);

					nts_attacking:add_skip_action(
						function()
							bm:remove_process("nts_attacking_show_animated_arrows");
						end
					);
				end
			);

			

			cutscene_enemy_attack:set_should_enable_cinematic_camera(false);

			cutscene_enemy_attack:action(
				function()
					-- Move camera to show enemy units walking on, and begin fade to picture
					cam:move_to(cam_position_1, cam_target, 0, false, 40);
					if cam_position_2 then
						cam:move_to(cam_position_2, cam_target, 30, true, 40);
					end;

					cam:fade(false, 0.5);
				end,
				0
			);

			cutscene_enemy_attack:action(
				function()
					-- The enemy advance! Ready your forces for battle!
					bm:show_subtitle("wh3_main_st_battle_fundamentals_mid_0001", false, true);

					local sfx = new_sfx("Play_wh3_main_st_battle_fundamentals_mid_0001_1");

					cutscene_enemy_attack:play_sound(sfx);


					bm:progress_on_sound_effect_finished(
						"battle_fundamentals_attack",
						sfx, 
						function()

							--is_active()
							cutscene_enemy_attack:skip();
						end,
						1000,												-- post VO finishing delay
						5000												-- min playing time
					);
				
				end,
				1000
			);

			cutscene_enemy_attack:start();
		end,
		2000
	);








	-------------------------------------------------
	--- Section 09 : Flanking
	-------------------------------------------------

	local function start_advance_tour_if_combatants_rout_monitor(just_highlight_button, nts)
		local sunits_player = nt_battle_fundamentals.sunits_player;
		local sunits_enemy = nt_battle_fundamentals.sunits_enemy;
		
		if not sunits_player:are_any_routing_or_dead() and not sunits_enemy:are_any_routing_or_dead() then
			bm:watch(
				function()
					return sunits_player:are_any_routing_or_dead() or sunits_enemy:are_any_routing_or_dead();
				end,
				0,
				function()
					if just_highlight_button and nts then
						nts:highlight_next_button();
					else
						nt_battle_fundamentals:start_next_section();
					end;
				end,
				"advance_tour_if_combatants_rout"
			);
			return true;
		end;
	end;

	local function stop_advance_tour_if_combatants_rout_monitor()
		bm:remove_process("advance_tour_if_combatants_rout");
	end;
	
	local nts_flanking = st_helper.navigable_tour_section_battle_factory(
		"flanking",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0090",
			"wh3_main_st_battle_fundamentals_0091",
			"wh3_main_st_battle_fundamentals_0092",
			"wh3_main_st_battle_fundamentals_0093"
		}													-- infotext
	);

	nts_flanking:action(
		function()
			-- If no combatants are currently routing then start a monitor for any of them routing, and advance
			if start_advance_tour_if_combatants_rout_monitor() then
				nts_flanking:add_skip_action(stop_advance_tour_if_combatants_rout_monitor);
			end;
		end,
		5
	);
	
	nts_flanking:action(
		function()
			append_attack_controls_to_cheat_sheet();
		end,
		1000
	);









	-------------------------------------------------
	--- Section 10 : Morale
	-------------------------------------------------
	
	local nts_morale = st_helper.navigable_tour_section_battle_factory(
		"morale",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0080",
			"wh3_main_st_battle_fundamentals_0081",
			"wh3_main_st_battle_fundamentals_0082",
			"wh3_main_st_battle_fundamentals_0083"
		}													-- infotext
	);

	nts_morale:action(
		function()
			-- If no combatants are currently routing then start a monitor for any of them routing, and advance
			if start_advance_tour_if_combatants_rout_monitor() then
				nts_morale:add_skip_action(stop_advance_tour_if_combatants_rout_monitor);
			end;
		end,
		5
	);
	






	-------------------------------------------------
	--- Section 11 : Routing
	-------------------------------------------------
	
	local nts_routing = st_helper.navigable_tour_section_battle_factory(
		"routing",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_battle_fundamentals_0100",
			"wh3_main_st_battle_fundamentals_0101",
			"wh3_main_st_battle_fundamentals_0102",
			"wh3_main_st_battle_fundamentals_0103"
		}													-- infotext
	);

	nts_routing:action(
		function()
			-- If no combatants are currently routing then start a monitor for any of them routing, and advance
			if start_advance_tour_if_combatants_rout_monitor(true, nts_routing) then
				nts_routing:add_skip_action(stop_advance_tour_if_combatants_rout_monitor);
			end;
		end,
		5
	);






	-- Add all sections to tour in order
	nt_battle_fundamentals:add_navigable_section(nts_intro);
	nt_battle_fundamentals:add_navigable_section(nts_camera_movement);
	nt_battle_fundamentals:add_navigable_section(nts_unit_selection);
	nt_battle_fundamentals:add_navigable_section(nts_multiple_selection);
	nt_battle_fundamentals:add_navigable_section(nts_unit_movement);
	nt_battle_fundamentals:add_navigable_section(nts_multiple_movement);
	nt_battle_fundamentals:add_navigable_section(nts_pausing);
	nt_battle_fundamentals:add_navigable_section(nts_attacking);
	nt_battle_fundamentals:add_navigable_section(nts_flanking);
	nt_battle_fundamentals:add_navigable_section(nts_morale);
	nt_battle_fundamentals:add_navigable_section(nts_routing);

	local function prepare_non_participant_army_for_tour(tour_starting, sunits)
		sunits:set_enabled(not tour_starting, false, true);
		
		if tour_starting then
			sunits:take_control();
		else
			sunits:release_control();
		end;
	end;

	-- Toggles invincibility, and disables/re-enables non-player units
	local function prepare_all_armies_for_tour(tour_starting, sunits_player, sunits_enemy, bounding_box, sunits_player_unused, sunits_enemy_unused)

		tour_starting = not not tour_starting;

		local player_alliance_index = sunits_player:item(1).alliance_num;
		local player_army_index = sunits_player:item(1).unit:army_index();

		local main_enemy_alliance_index = sunits_enemy:item(1).alliance_num;
		local main_enemy_army_index = sunits_enemy:item(1).unit:army_index();
		
		-- Enable/disable units not in the player or enemy primary armies
		for i = 1, bm:num_alliances() do
			for j = 1, bm:num_armies_in_alliance(i) do

				-- Non-participating main armies
				if not (i == player_alliance_index and j == player_army_index) or (i == main_enemy_alliance_index and j == main_enemy_army_index) then
					prepare_non_participant_army_for_tour(tour_starting, bm:get_scriptunits_for_army(i, j));
				end;

				-- Reinforcing armies
				for k = 1, bm:num_reinforcing_armies_for_army_in_alliance(i, j) do
					prepare_non_participant_army_for_tour(tour_starting, bm:get_scriptunits_for_army(i, j, k));
				end;
			end;
		end;

		-- Enable/disable units not in the player or enemy primary armies
		if tour_starting then

			-- Teleport the player and enemy armies in to their starting positions
			reposition_sunits_for_tour(bounding_box, sunits_player, false);
			reposition_sunits_for_tour(bounding_box, sunits_enemy, true);

			-- Disable enemy forces
			sunits_enemy:set_enabled(false, false, true);

			-- Disable remaining unused enemy/player forces
			sunits_player_unused:set_enabled(false, false, true);
			sunits_enemy_unused:set_enabled(false, false, true);

		else
			-- Respawn the player + enemy units, including unused, in their starting positions
			sunits_player:set_enabled(true);
			sunits_enemy:set_enabled(true);
			sunits_player_unused:set_enabled(true);
			sunits_enemy_unused:set_enabled(true);

			sunits_player:set_always_visible(false);
			sunits_enemy:set_always_visible(false);
			
			sunits_player:respawn_in_start_location();
			sunits_enemy:respawn_in_start_location();
			sunits_player_unused:respawn_in_start_location();
			sunits_enemy_unused:respawn_in_start_location();

			sunits_player:release_control();
			sunits_enemy:release_control();
			sunits_player_unused:release_control();
			sunits_enemy_unused:release_control();
		end;
	end;







	-------------------------------------------------------------
	-- Add startup actions
	-------------------------------------------------------------
	nt_battle_fundamentals:start_action(
		function()
			
			-- Record camera position
			nt_battle_fundamentals.cam_pos_start = cam:position();
			nt_battle_fundamentals.cam_targ_start = cam:target();
			
			-- Close current advisor
			bm:stop_advisor_queue(true);
			bm:clear_infotext();

			-- Disable pausing and changing of battle speed, set battle speed to normal, and prevent time updating
			bm:disable_pausing(true);
			bm:modify_battle_speed(1);
			bm:disable_time_speed_controls(true);
			bm:change_conflict_time_update_overridden(true);

			-- Disable orders
			bm:disable_orders(true);

			-- fade camera to black
			cam:fade(true, 0.5);
		end,
		0
	);


	nt_battle_fundamentals:start_action(
		function()
			-- If we're in deployment phase then proceed to conflict phase
			if bm:get_current_phase_name() == "Deployment" then
				bm:end_current_battle_phase();
			end;

			-- Detach infotext from advisor
			bm:attach_to_advisor(false);
			
			-- Set tour controls above infotext - this needs to be done after detaching infotext
			nt_battle_fundamentals:set_tour_controls_above_infotext(true);

			-- Disable bits of the UI we don't want
			bm:disable_tactical_map(true);
			bm:disable_help_page_button(true);
			bm:disable_unit_camera(true);
			bm:disable_unit_details_panel(true);
			bm:show_top_bar(false);
			bm:show_army_panel(false);
			bm:show_radar_frame(false);
			bm:show_army_abilities(false);
			bm:show_ui_options_panel(false);
			bm:enable_spell_browser_button(false);
			bm:show_winds_of_magic_panel(false);
			bm:show_portrait_panel(false);

			local hpm = get_help_page_manager();
			hpm:hide_panel();
			hpm:related_panel_opened("float_top_right", true);			-- spoof a panel opening which forces the help panel to float in the top-right corner
			

			-- Cache and set certain preferences
			core:cache_and_set_integer_preference("ui_leaf_clipping", 2);
			core:cache_and_set_boolean_preference("ui_mouse_scroll", false);
			core:cache_and_set_integer_preference("ui_selection_markers", 0);
			core:cache_and_set_integer_preference("ui_unit_select_outlines", 1);			

			-- Disable grouping/formations
			bm:disable_groups(true);
			bm:disable_formations(true);

			-- Disable units not involved in the scripted tour and teleport units being used into their starting positions
			prepare_all_armies_for_tour(true, nt_battle_fundamentals.sunits_player, nt_battle_fundamentals.sunits_enemy, nt_battle_fundamentals.bounding_box_to_use, nt_battle_fundamentals.sunits_player_unused, nt_battle_fundamentals.sunits_enemy_unused);			
		end,
		700
	);

	nt_battle_fundamentals:start_action(
		function()

			-- Begin player unit movement and position camera
			local sunits_player = nt_battle_fundamentals.sunits_player;
			local bounding_box = nt_battle_fundamentals.bounding_box_to_use;

			local show_post_skip_camera_movement = true;

			local cutscene_battle_fundamentals_intro = cutscene:new(
				"battle_fundamentals_intro",
				sunits_player,
				nil, 
				function()
					-- If the cutscene does not end naturally then show the post-skip camera movement
					if show_post_skip_camera_movement then
						-- sunits, x_offset, z_offset, horizontal_bearing, vertical_bearing, horizontal_bearing_delta, relaxed pose
						local cam_targ, cam_pos = st_helper.get_offset_camera_positions_from_sunits(
							nt_battle_fundamentals.sunits_player, 
							0, 
							-55,
							nil,
							nil,
							nil,
							true
						);

						cam:move_to(cam_pos, cam_targ, 3, false, 0);
					end;

					bm:hide_subtitles();
					nt_battle_fundamentals:start_next_section();
				end
			);

			cutscene_battle_fundamentals_intro:set_should_enable_cinematic_camera(false);
			cutscene_battle_fundamentals_intro:set_should_release_players_army(false);

			cutscene_battle_fundamentals_intro:action(
				function()
					local right_hand_sunit = sunits_player:get_closest(v_offset_by_bearing(bounding_box.pos, d_to_r(bounding_box.bearing), bounding_box.width / 2));

					local walk_on_distance = 30;																-- distance the units will walk forward

					local camera_pos_start_offset_x = 55;														-- start camera position offset from unit (left to right from unit's perspective)
					local camera_pos_start_offset_z = walk_on_distance + 10;									-- start camera position offset from unit (front to back from unit's perspective)
					local camera_pos_start_height = 10;															-- start camera position height above ground

					local camera_pos_end_travel = 2;															-- distance camera position will travel (in direction of unit facing)
					local camera_pos_end_height = 10;															-- end camera position height above ground

					local camera_target_start_offset_z = 5;														-- start camera target offset from unit (front to back from unit's perspective)

					local camera_fov_start = 47;																-- fov at camera start position
					local camera_fov_end = 47;																	-- fov at camera end position

					local camera_movement_duration = walk_on_distance / right_hand_sunit.unit:slow_speed();		-- camera movement duration in s

					-- Calculate start and end camera positions
					local camera_position_start = v_to_ground(right_hand_sunit:position_offset(camera_pos_start_offset_x, 0, camera_pos_start_offset_z), camera_pos_start_height);
					local camera_position_end = v_to_ground(v_offset_by_bearing(camera_position_start, d_to_r(bounding_box.bearing), camera_pos_end_travel), camera_pos_end_height);

					local camera_target_start = right_hand_sunit:position_offset(0, 0, camera_target_start_offset_z);
					local camera_target_end = right_hand_sunit:position_offset(0, 0, walk_on_distance);

					-- Order player units to start moving forward
					sunits_player:goto_location_offset(0, walk_on_distance, false);

					-- Instigate camera movements
					cam:move_to(camera_position_start, camera_target_start, 0, true, camera_fov_start);
					cam:move_to(camera_position_end, camera_target_end, camera_movement_duration, false, camera_fov_end);
				end,
				0
			);

			cutscene_battle_fundamentals_intro:action(
				function()
					-- Battles are fought between armies. No army may prosper without a skilled war leader to guide it. Only through your leadership may your troops gain victory.
					bm:show_subtitle("wh3_main_st_battle_fundamentals_intro_0001", false, true);

					local sfx = new_sfx("Play_wh3_main_st_battle_fundamentals_intro_0001_1");
					cutscene_battle_fundamentals_intro:play_sound(sfx);

					bm:progress_on_sound_effect_finished(
						"battle_fundamentals_intro", 
						sfx, 
						function()
							show_post_skip_camera_movement = false;
							if cutscene_battle_fundamentals_intro:is_active() then
								cutscene_battle_fundamentals_intro:skip();
							end;
						end,
						1000,												-- post VO finishing delay
						10000												-- min playing time											
					);
				end,
				1500
			);

			cutscene_battle_fundamentals_intro:start();
		end,
		900
	);

	-- Cam fade-to-picture should happen even if cutscene is skipped
	nt_battle_fundamentals:start_action(
		function()
			cam:fade(false, 0.5);
		end,
		2000
	);

	


	-------------------------------------------------------------
	-- Add end actions
	-------------------------------------------------------------
	nt_battle_fundamentals:end_action(
		function()
			cam:fade(true, 0.3);
			bm:enable_cinematic_ui(true, false, false);
		end,
		0
	);

	nt_battle_fundamentals:end_action(
		function()
			-- Re-enable orders
			bm:disable_orders(false);

			-- Re-enable grouping/formations
			bm:disable_groups(false);
			bm:disable_formations(false);

			-- Re-attach infotext to advisor
			nt_battle_fundamentals:set_tour_controls_above_infotext(false);
			bm:attach_to_advisor(true);

			-- Re-enable bits of the UI we didn't want
			bm:disable_help_page_button(false);
			bm:disable_tactical_map(false);
			bm:disable_unit_camera(false);
			bm:disable_unit_details_panel(false);
			bm:show_top_bar(true);
			bm:show_army_panel(true);
			bm:show_radar_frame(true);
			bm:show_army_abilities(true);
			bm:show_ui_options_panel(true);
			bm:enable_spell_browser_button(true);
			bm:show_winds_of_magic_panel(true);
			bm:show_portrait_panel(true);

			core:restore_integer_preference("ui_leaf_clipping");
			core:restore_boolean_preference("ui_mouse_scroll");
			core:restore_integer_preference("ui_selection_markers");
			core:restore_integer_preference("ui_unit_select_outlines");

			local hpm = get_help_page_manager();
			hpm:show_title_bar_buttons(true);
			hpm:hide_panel();
			hpm:related_panel_closed("float_top_right");

			-- Re-enable pausing and time updating, and allow battle speed to be changed
			bm:disable_pausing(false);
			bm:disable_time_speed_controls(false);
			bm:change_conflict_time_update_overridden(false);

			-- destroy attacking enemy units sai
			release_enemy_from_planner();

			-- Set all units non-invincible. Re-enable units not in the player's army.
			prepare_all_armies_for_tour(false, nt_battle_fundamentals.sunits_player, nt_battle_fundamentals.sunits_enemy, nt_battle_fundamentals.bounding_box_to_use, nt_battle_fundamentals.sunits_player_unused, nt_battle_fundamentals.sunits_enemy_unused);

			if nt_battle_fundamentals.cam_pos_start and nt_battle_fundamentals.cam_targ_start then
				cam:move_to(nt_battle_fundamentals.cam_pos_start, nt_battle_fundamentals.cam_targ_start, 0, false, 0);
			end;

			bm:enable_cinematic_ui(false, true, false);

			cam:fade(false, 0.5);
		end,
		500
	);
end;