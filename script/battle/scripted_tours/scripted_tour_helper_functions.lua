--- @set_environment battle


--- @data_interface st_helper Scripted Tour Helpers
--- @function_separator .
--- @desc This interface provides a list of functions to empower scripted tour mechanics in battle.


st_helper = {};







----------------------------------------------------------------------------
-- Default camera scroll values
----------------------------------------------------------------------------


local DEFAULT_HORIZONTAL_BEARING_DELTA = 0.1745;			-- 10 degrees in radians
local DEFAULT_VERTICAL_BEARING = 0.5236;					-- 30 degrees in radians
local DEFAULT_RELAXED_VERTICAL_BEARING = 0.3491;			-- 20 degrees in radians










----------------------------------------------------------------------------
--- @section Building Queries
----------------------------------------------------------------------------


--- @function get_building_from_list
--- @desc Returns a building from a supplied list of buildings that matches a supplied filter function. The filter function should take a @battle_building as a single argument and return a @boolean result - <code>true</code> if the filter passes, or <code>false</code> otherwise. Each building in the list is tested sequentially, and the first building which passes the filter is returned.
--- @desc If no building from the supplied list matches then @nil is returned.
--- @p @table building list, List of buildings to test. This should be an indexed table of @battle_building objects, such as (but not restricted to) those returned by functions documented in the @"battle_manager:Building Lists" section of this documentation.
--- @p @function filter function, Filter function. This should take a @battle_building object as a single argument and return a boolean result.
--- @r @battle_building matched building, or @nil if no match
function st_helper.get_building_from_list(list, filter)

	if not is_table(list) then
		script_error("ERROR: get_building_from_list() called but supplied list [" .. tostring(list) .. "] is not a table");
		return false;
	end;

	if #list == 0 then
		script_error("ERROR: get_building_from_list() called but supplied list [" .. tostring(list) .. "] is empty");
		return false;
	end;

	if not is_function(filter) then
		script_error("ERROR: get_building_from_list() called but supplied filter [" .. tostring(filter) .. "] is not a function");
		return false;
	end;

	for i = 1, #list do
		local current_building = list[i];

		if filter(current_building) then
			return current_building;
		end;
	end;
end;



--- @function get_closest_building_from_list
--- @desc Returns the closest building from a supplied list of buildings. An optional filter function may also be supplied, which should take a @battle_building as a single argument and return a @boolean result - <code>true</code> if the filter passes, or <code>false</code> otherwise.
--- @p @battle_vector position, Position to test against.
--- @p @table building list, List of buildings to test. This should be an indexed table of @battle_building objects, such as (but not restricted to) those returned by functions documented in the @"battle_manager:Building Lists" section of this documentation.
--- @p [opt=nil] @function filter function, Filter function. This should take a @battle_building object as a single argument and return a boolean result. If no filter function is supplied then all buildings pass.
--- @r @battle_building closest building
function st_helper.get_closest_building_from_list(pos, list, filter)

	if not is_vector(pos) then
		script_error("ERROR: get_closest_building_from_list() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;

	if not is_table(list) then
		script_error("ERROR: get_closest_building_from_list() called but supplied list [" .. tostring(list) .. "] is not a table");
		return false;
	end;

	if #list == 0 then
		script_error("ERROR: get_closest_building_from_list() called but supplied list [" .. tostring(list) .. "] is empty");
		return false;
	end;

	if filter and not is_function(filter) then
		script_error("ERROR: get_closest_building_from_list() called but supplied filter [" .. tostring(filter) .. "] is not a function or nil");
		return false;
	end;

	local closest_distance = 5000;
	local closest_building = false;

	for i = 1, #list do
		local current_building = list[i];

		if not filter or filter(current_building) then
			local current_distance = current_building:central_position():distance(pos);
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_building = current_building;
			end;
		end;
	end;

	if not closest_building then
		script_error("WARNING: get_closest_building_from_list() couldn't find an eligible building, returning first in list");
		closest_building = list[1];
	end;

	return closest_building;
end;


--- @function building_is_standard_fort_wall
--- @desc Returns whether the supplied building is a fort wall but not a gate or a tower.
--- @p @battle_building building
--- @r @boolean building is standard fort wall
function st_helper.building_is_standard_fort_wall(building)
	return building:is_fort_wall() and not building:has_gate() and not building:is_fort_tower();
end;


--- @function building_is_standard_fort_wall_connected_n_times
--- @desc Returns whether the supplied building is a standard fort wall connected a supplied number of times on either side. Wall pieces are connected to adjacent pieces in the wall, so a wall piece that is connected n times would have n buildings to the left and to the right of it in the wall, meaning that it's not at or near the end of the wall.
--- @p @battle_building building, Building.
--- @p @number connections, Number of connections to test.
--- @p [opt=false] @number allow non-standard connections, Includes connections to buildings that are not standard fort walls (e.g. gates, towers).
--- @r @boolean building is connected
function st_helper.building_is_standard_fort_wall_connected_n_times(building, n, include_nonstandard_connections)
	if not st_helper.building_is_standard_fort_wall(building) then
		return false;
	end;

	local current_building = building;
	for i = 1, n do
		local next_building = current_building:next()
		if next_building and (include_nonstandard_connections or st_helper.building_is_standard_fort_wall(next_building)) then
			current_building = next_building;
		else
			return false;
		end;
	end;

	current_building = building;
	for i = 1, n do
		local prev_building = current_building:previous()
		if prev_building and (include_nonstandard_connections or st_helper.building_is_standard_fort_wall(prev_building)) then
			current_building = prev_building;
		else
			return false;
		end;
	end;

	return true;
end;


--- @function get_closest_connected_wall_building
--- @desc Returns the closest fort wall building to the supplied position that is connected n times to other buildings. The connection test is performed by @st_helper.building_is_standard_fort_wall_connected_n_times
--- @p @battle_vector position, Position to test against.
--- @p @number connections, Number of connections to test for each building.
--- @p [opt=false] @number allow non-standard connections, Includes connections to buildings that are not standard fort walls (e.g. gates, towers).
--- @r @battle_building closest building
function st_helper.get_closest_connected_wall_building(pos, connected_n_times, include_nonstandard_connections)

	if not is_vector(pos) then
		script_error("ERROR: get_closest_connected_wall_building() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;

	connected_n_times = connected_n_times or 0;

	local eligible_buildings = {};
	local fort_wall_buildings = bm:get_fort_wall_buildings();

	for i = connected_n_times, 1, -1 do
		for j = 1, #fort_wall_buildings do
			local current_building = fort_wall_buildings[j];

			if st_helper.building_is_standard_fort_wall_connected_n_times(current_building, i, include_nonstandard_connections) then
				table.insert(eligible_buildings, current_building);
			end;
		end;

		if #eligible_buildings > 0 then
			break;
		end;
	end;

	-- we didn't find any standard fort walls connected to other standard fort walls on both sides, so pick from any walls
	if #eligible_buildings == 0 then
		eligible_buildings = fort_wall_buildings;
	end;

	local closest_distance = 5000;
	local closest_building = false;

	for i = 1, #eligible_buildings do
		local current_building = eligible_buildings[i];
		local current_distance = current_building:central_position():distance(pos);
		if current_distance < closest_distance then
			closest_distance = current_distance;
			closest_building = current_building;
		end;
	end;

	if closest_building then
		return closest_building;
	end;

	script_error("ERROR: get_closest_connected_wall_building() couldn't find a fort wall building, are we not in a siege?");
end;


--- @function minor_supply_capture_location_exists
--- @desc Returns whether a minor key building capture location exists on the battlefield.
--- @r @boolean capture location of type exists
function st_helper.minor_supply_capture_location_exists()
	return st_helper.capture_location_of_type_exists("minor_point_supplies", true);
end;


--- @function minor_supply_capture_location_with_toggleable_slot_exists
--- @desc Returns whether any minor key building capture locations with attached toggleable slots exist on the battlefield.
--- @r @boolean capture location of type exists
function st_helper.minor_supply_capture_location_with_toggleable_slot_exists()
	return not not st_helper.capture_location_of_type_with_toggleable_slot_exists("minor_point_supplies", true);
end;


--- @function victory_point_plaza_capture_location_exists
--- @desc Returns whether a victory point capture location exists on the battlefield.
--- @r @boolean capture location of type exists
function st_helper.victory_point_plaza_capture_location_exists()
	return st_helper.capture_location_of_type_exists("victory_point_plaza");
end;


--- @function major_key_building_capture_location_exists
--- @desc Returns whether a major key building capture location exists on the battlefield.
--- @r @boolean capture location of type exists
function st_helper.major_key_building_capture_location_exists()
	return st_helper.capture_location_of_type_exists("major_key_building", true);
end;


--- @function fort_wall_building_exists
--- @desc Returns whether any fort wall buildings exist on the battlefield.
--- @r @boolean fort walls exist
function st_helper.fort_wall_building_exists()
	return #bm:get_fort_wall_buildings() > 0;
end;


--- @function fort_gate_building_exists
--- @desc Returns whether any fort gate buildings exist on the battlefield.
--- @r @boolean fort gates exist
function st_helper.fort_gate_building_exists()
	return #bm:get_fort_gate_buildings() > 0;
end;


--- @function selectable_tower_exists
--- @desc Returns whether any selectable tower buildings exist on the battlefield.
--- @r @boolean selectable towers exist
function st_helper.selectable_tower_exists()
	return not not st_helper.get_building_from_list(
		bm:get_fort_tower_buildings(),
		function(building)
			return building:is_selectable() and not building:has_gate()
		end
	);
end;


--- @function capture_location_exists
--- @desc Returns whether any capture locations exist on the battlefield.
--- @r @boolean capture location exists
function st_helper.capture_location_exists()
	return common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") > 0;
end;


--- @function capture_location_with_gate_exists
--- @desc Returns whether any capture location with a gate exists on the battlefield.
--- @r @boolean selectable towers exist
function st_helper.capture_location_with_gate_exists()
	local size = common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size");
	for i = 0, size - 1 do
		if common.get_context_value("CcoBattleRoot", "", "CapturePointList().At(" .. i .. ").HasCaptureBuilding") and common.get_context_value("CcoBattleRoot", "", "CapturePointList().At(" .. i .. ").CaptureBuilding.IsGate") then
			return true;
		end;
	end;
	return false;
end;


--- @function capture_location_of_type_exists
--- @desc Returns whether a capture location of the specified type exists on the battlefield.
--- @p @string capture location type, Capture location type, from the <code>capture_point_types</code> database table.
--- @p [opt=false] @boolean partial match, Perform a partial string match. This would allow a supplied capture location search string <code>"major_key_building"</code> to match capture locations with types such as <code>"major_key_building_magic"</code> or <code>"major_key_building_missile"</code>.
--- @r @boolean capture location of type exists
function st_helper.capture_location_of_type_exists(capture_location_type, match_partial)
	if not is_string(capture_location_type) then
		script_error("ERROR: capture_location_of_type_exists() called but supplied capture location type [" .. tostring(capture_location_type) .. "] is not a string");
		return false;
	end;

	local num_capture_points = common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size");
	if match_partial then
		for i = 0, num_capture_points - 1 do
			local current_capture_location_type = common.get_context_value("CcoBattleRoot", "", "CapturePointList().At(" .. i .. ").TypeRecordContext().Key");
			if string.find(current_capture_location_type, capture_location_type) then
				return true;
			end;
		end;
	else
		for i = 0, num_capture_points - 1 do
			local current_capture_location_type = common.get_context_value("CcoBattleRoot", "", "CapturePointList().At(" .. i .. ").TypeRecordContext().Key");
			if current_capture_location_type == capture_location_type then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function capture_location_of_type_with_toggleable_slot_exists
--- @desc Returns whether a capture location of the specified type exists on the battlefield with associated toggleable slots.
--- @p [opt=nil] @string capture location type, Capture location type, from the <code>capture_point_types</code> database table. If no type is specified then any type is matched.
--- @p [opt=false] @boolean partial match, Perform a partial string match. This would allow a supplied capture location search string <code>"major_key_building"</code> to match capture locations with types such as <code>"major_key_building_magic"</code> or <code>"major_key_building_missile"</code>.
--- @r @boolean capture location of type exists
function st_helper.capture_location_of_type_with_toggleable_slot_exists(capture_location_type, match_partial)

	-- If capture_location_type is blank then match any type
	if capture_location_type and not validate.is_string(capture_location_type) then
		return false;
	end;

	for i = 0, common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") - 1 do	
		local capture_location_str = "CapturePointList().At(" .. i .. ")";
		local capture_location_type_record = capture_location_str .. ".TypeRecordContext()";

		-- If no capture_location_type was specified then consider this a match
		local capture_location_type_matches = not capture_location_type;

		if not capture_location_type_matches then
			local current_capture_location_type = common.get_context_value("CcoBattleRoot", "", capture_location_type_record .. ".Key");

			if match_partial then
				if string.find(current_capture_location_type, capture_location_type) then
					capture_location_type_matches = true;
				end;
			else
				if capture_location_type_matches == capture_location_type then
					capture_location_type_matches = true;
				end;
			end;
		end;

		if capture_location_type_matches then
			if common.get_context_value("CcoBattleRoot", "", capture_location_str .. ".ToggleableSlotsList().Size") > 0 then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function get_closest_capture_location_of_type
--- @desc Returns the closest capture location of the specified type to the supplied position. The capture location is returned as a context string identifier. If the type is left blank then any capture location matches.
--- @p @battle_vector position, Position.
--- @p [opt=nil] @string capture location type, Capture location type, from the <code>capture_location_types<\code> database table.
--- @p [opt=false] @boolean partial match, Perform a partial string match. This would allow a supplied capture location search string <code>"major_key_building"</code> to match capture locations with types such as <code>"major_key_building_magic"</code> or <code>"major_key_building_missile"</code>.
--- @r @string capture location as context string
function st_helper.get_closest_capture_location_of_type(pos, capture_location_type, match_partial)

	if not is_vector(pos) then
		script_error("ERROR: get_closest_capture_location_of_type() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;

	if capture_location_type and not is_string(capture_location_type) then
		script_error("ERROR: get_closest_capture_location_of_type() called but supplied capture location type [" .. tostring(capture_location_type) .. "] is not a string");
		return false;
	end;

	local closest_location_str = false;
	local closest_distance = 5000;

	for i = 0, common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") - 1 do	
		local capture_location_str = "CapturePointList().At(" .. i .. ")";
		local capture_location_type_record = capture_location_str .. ".TypeRecordContext()";

		local type_match = not capture_location_type;			-- if no capture_location_type was supplied then consider that a match

		if not type_match then
			if match_partial then
				type_match = string.find(common.get_context_value("CcoBattleRoot", "", capture_location_type_record .. ".Key"), capture_location_type);
			else
				type_match = common.get_context_value("CcoBattleRoot", "", capture_location_type_record .. ".Key") == capture_location_type;
			end;
		end;

		if type_match then
			local current_distance = v_from_context_str("CcoBattleRoot", "", capture_location_str .. ".FlagPosition"):distance(pos);
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_location_str = capture_location_str;
			end;
		end;
	end;

	return closest_location_str;
end;


--- @function get_closest_toggleable_slot_from_capture_location_of_type
--- @desc Returns the closest toggleable slot from any capture location of the specified type, to the supplied position. The toggleable slot is returned as a context string identifier. If the capture location type is left blank then any capture location matches.
--- @p @battle_vector position, Position.
--- @p [opt=nil] @string capture location type, Capture location type, from the <code>capture_location_types<\code> database table.
--- @p [opt=false] @boolean partial match, Perform a partial string match. This would allow a supplied capture location search string <code>"major_key_building"</code> to match capture locations with types such as <code>"major_key_building_magic"</code> or <code>"major_key_building_missile"</code>.
--- @r @string capture location as context string
function st_helper.get_closest_toggleable_slot_from_capture_location_of_type(pos, capture_location_type, match_partial)
	if not is_vector(pos) then
		script_error("ERROR: get_closest_toggleable_slot_from_capture_location_of_type() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;

	-- If capture_location_type is blank then match any type
	if capture_location_type and not is_string(capture_location_type) then
		script_error("ERROR: get_closest_toggleable_slot_from_capture_location_of_type() called but supplied capture location type [" .. tostring(capture_location_type) .. "] is not a string");
		return false;
	end;

	local closest_slot_str = false;
	local closest_distance = 5000;

	for i = 0, common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") - 1 do	
		local capture_location_str = "CapturePointList().At(" .. i .. ")";
		local capture_location_type_record = capture_location_str .. ".TypeRecordContext()";

		local type_match = not capture_location_type;			-- if no capture_location_type was supplied then consider that a match

		if not type_match then
			if match_partial then
				type_match = string.find(common.get_context_value("CcoBattleRoot", "", capture_location_type_record .. ".Key"), capture_location_type);
			else
				type_match = common.get_context_value("CcoBattleRoot", "", capture_location_type_record .. ".Key") == capture_location_type;
			end;
		end;

		if type_match then
			local toggleableslotlist_str = capture_location_str .. ".ToggleableSlotsList()";

			for j = 0, common.get_context_value("CcoBattleRoot", "", toggleableslotlist_str .. ".Size") - 1 do
				local current_slot_str = toggleableslotlist_str .. ".At(" .. j .. ")";
				local current_distance = v_from_context_str("CcoBattleRoot", "", current_slot_str .. ".WorldPosition"):distance(pos);
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_slot_str = current_slot_str;
				end;
			end;
		end;
	end;

	return closest_slot_str;
end;













----------------------------------------------------------------------------
--- @section General Camera Offset Functions
--- @desc Scripted tour sections commonly have to find camera positions offset from a known camera target e.g. a unit, wall piece or capture location. Functions in this helpers library provide standardised ways to get camera co-ordinates for different types of battlefield objects that we may want to look at during a scripted tour.
--- @desc The functions in this section are general-purpose, and are primarily for use by the more specific camera helper functions found in the @"st_helper:Specialised Camera Offset Functions" section.
----------------------------------------------------------------------------


--- @function get_second_offset_camera_position
--- @desc Returns a second camera position from a supplied vector target and an initial camera position. The initial position and the second returned position defines a pair of camera co-ordinates that can be used to effect a camera rotation around the supplied target.
--- @desc The returned position will be rotated around the camera target from the initial position by the horizontal delta.
--- @p @battle_vector camera target, Camera target.
--- @p @battle_vector initial camera position, Initial camera position.
--- @p [opt=0.1745] @number delta, horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
function st_helper.get_second_offset_camera_position(cam_target, initial_position, horizontal_bearing_delta)

	if not validate.is_vector(cam_target) then
		return false;
	end;

	if not validate.is_vector(initial_position) then
		return false;
	end;

	if horizontal_bearing_delta then
		if not validate.is_number(horizontal_bearing_delta) then
			return false;
		end;
	else
		horizontal_bearing_delta = DEFAULT_HORIZONTAL_BEARING_DELTA;
	end;

	if horizontal_bearing_delta == 0 then
		script_error("WARNING: get_second_offset_camera_position() called with a horizontal bearing delta of 0 - the returned camera position will be the same as the supplied camera position");
		return initial_position;
	end;

	local final_position = get_vector_offset_by_bearing(
		cam_target,
		cam_target:distance(initial_position), 												-- distance
		get_bearing(cam_target, initial_position) + horizontal_bearing_delta, 				-- h bearing
		get_bearing(cam_target, initial_position, true)										-- v bearing
	);

	-- If the initial camera position is close to the terrain then ensure that the initial-to-final track follows the terrain, otherwise just ensure that the final is above ground
	if initial_position:get_y() < bm:get_terrain_height(initial_position:get_x(), initial_position:get_z()) + 10 then
		return v_min_height(
			final_position,
			initial_position:get_y()
		);
	end;

	return v_min_height(final_position, 5);
end;


--- @function get_offset_camera_positions_by_bearing
--- @desc Returns a pair of vectors that define camera positions around a supplied vector target. These camera positions can be used by scripted tour scripts to position and animate the camera as it rotates around the camera target. The positions are computed from the target vector, a distance, and horizontal/vertical bearings supplied from the target vector to the initial camera position.
--- @desc A horizontal bearing delta, which defines how separated the two returned positions are, may also be supplied. If the supplied horizontal bearing is 0 then only one position vector is returned.
--- @p @battle_vector target, Target position.
--- @p [opt=100] @number distance, Camera-to-target distance in m.
--- @p [opt=0] @number horizontal bearing, Horizontal bearing (i.e. looking from above) from camera target to initial camera position in radians.
--- @p [opt=0.6175] @number vertical bearing, Vertical vearing (i.e. looking from side) from camera target to initial camera position in radians. The default value is equivalent to 30 degrees.
--- @p [opt=0.1745] @number delta, Horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
--- @r @battle_vector start camera position
--- @r @battle_vector end camera position (or @nil if delta is 0)
function st_helper.get_offset_camera_positions_by_bearing(cam_target, distance, horizontal_bearing, vertical_bearing, horizontal_bearing_delta)

	if not validate.is_vector(cam_target) then
		return false;
	end;

	if distance then
		if not validate.is_number(distance) then
			return false;
		end;
	else
		distance = 100;
	end;

	if horizontal_bearing then
		if not validate.is_number(horizontal_bearing) then
			return false;
		end;
	else
		horizontal_bearing = 0;
	end;

	if vertical_bearing then
		if not validate.is_number(vertical_bearing) then
			return false;
		end;
	else
		vertical_bearing = DEFAULT_VERTICAL_BEARING;
	end;

	if horizontal_bearing_delta then
		if not validate.is_number(horizontal_bearing_delta) then
			return false;
		end;
	else
		horizontal_bearing_delta = DEFAULT_HORIZONTAL_BEARING_DELTA;
	end;
	
	local start_cam_position = v_min_height(
		get_vector_offset_by_bearing(
			cam_target,
			distance,
			horizontal_bearing,
			vertical_bearing
		),
		5
	);

	if horizontal_bearing_delta == 0 then
		return start_cam_position;
	end;

	local end_horizontal_bearing = horizontal_bearing + horizontal_bearing_delta;
	local end_cam_position = v_min_height(
		get_vector_offset_by_bearing(
			cam_target, 
			distance, 
			end_horizontal_bearing, 
			vertical_bearing
		),
		5
	);

	return start_cam_position, end_cam_position;
end;


--- @function get_offset_camera_positions_by_offset_and_bearing
--- @desc Returns a pair of vectors that define camera positions around a supplied vector target. The co-ordinates of the first camera position are determined by a supplied x/z offset from the camera target, the facing of which is determined by a supplied horizontal bearing, and a vertical bearing from the camera target to determine the height. The second returned camera position is offset from the first by an optional horizontal bearing delta. If this is set to 0 then only one camera position is returned.
--- @p @battle_vector camera target, Camera target.
--- @p @number x offset, X offset of the first camera position from the camera target, based on the horizontal bearing.
--- @p @number z offset, Z offset of the first camera position from the camera target, based on the horizontal bearing.
--- @p @number horizontal bearing, Horizontal bearing (i.e. looking from top down) in radians from which to take the offset, from the camera target.
--- @p [opt=0.6175] @number vertical bearing, Vertical bearing (i.e. looking from side) in radians of the first camera position, from the camera target. The default value is equivalent to 30 degrees.
--- @p [opt=0.1745] @number delta, Horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
--- @r @battle_vector start camera position
--- @r @battle_vector end camera position (or @nil if delta is 0)
function st_helper.get_offset_camera_positions_by_offset_and_bearing(cam_target, x_offset, z_offset, horizontal_bearing, vertical_bearing, horizontal_bearing_delta)

	if not validate.is_vector(cam_target) or not validate.is_number(x_offset) or not validate.is_number(z_offset) then
		return false;
	end;

	if horizontal_bearing then
		if not validate.is_number(horizontal_bearing) then
			return false;
		end;
	else
		horizontal_bearing = 0;
	end;

	if vertical_bearing then
		if not validate.is_number(vertical_bearing) then
			return false;
		end;
	else
		vertical_bearing = DEFAULT_VERTICAL_BEARING;
	end;

	if horizontal_bearing_delta then
		if not validate.is_number(horizontal_bearing_delta) then
			return false;
		end;
	else
		horizontal_bearing_delta = DEFAULT_HORIZONTAL_BEARING_DELTA;
	end;
	
	local horizontal_hyp = (x_offset ^ 2 + z_offset ^ 2) ^ 0.5;

	local true_horizontal_bearing = horizontal_bearing + math.atan2(x_offset, z_offset);

	local targ_x = cam_target:get_x();
	local targ_y = cam_target:get_y();
	local targ_z = cam_target:get_z();

	local x = cam_target:get_x() + math.sin(true_horizontal_bearing) * horizontal_hyp;
	local y = cam_target:get_y() + math.tan(vertical_bearing) * horizontal_hyp;
	local z = cam_target:get_z() + math.cos(true_horizontal_bearing) * horizontal_hyp;

	local first_camera_pos = v_min_height(v(x, y, z), 5);

	if horizontal_bearing_delta == 0 then
		return first_camera_pos;
	end;

	return first_camera_pos, st_helper.get_second_offset_camera_position(cam_target, first_camera_pos, horizontal_bearing_delta);
end;



--- @function get_offset_camera_positions_by_bearing_vector
--- @desc Returns a pair of vectors that define camera positions around a supplied vector target. The co-ordinates of the first camera position are determined by a supplied bearing vector, which defines a horizontal bearing along which the first camera position lies, and is further fixed by a supplied distance and optional vertical bearing. The second returned camera position is offset from the first by an optional horizontal bearing delta. If this is set to 0 then only one camera position is returned.
--- @p @battle_vector camera target, Camera target.
--- @p @battle_vector bearing vector, Bearing vector, which defines the horizontal bearing of the first computed camera position.
--- @p [opt=100] @number distance, Distance in metres from camera target to computed camera positions.
--- @p [opt=0.6175] @number v bearing, Vertical bearing in radians from the camera target to the camera positions, in radians. The default value is equivalent to 30 degrees.
--- @p [opt=0.1745] @number delta, Horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
--- @r @battle_vector start camera position
--- @r @battle_vector end camera position (or @nil if delta is 0)
function st_helper.get_offset_camera_positions_by_bearing_vector(cam_target, bearing_pos, distance, vertical_bearing, horizontal_bearing_delta)
	return st_helper.get_offset_camera_positions_by_bearing(cam_target, distance, get_bearing(cam_target, bearing_pos), vertical_bearing, horizontal_bearing_delta);
end;










----------------------------------------------------------------------------
--- @section Specialised Camera Offset Functions
--- @desc These specialised camera offset functions can be used by specific scripted tour sections to provide camera position/target vectors for camera movement. The functions in this section will generally return three @battle_vector objects - a camera target, and two camera positions. The contract is that a camera animated between the two supplied positions, looking at the supplied target, should provide a view of the camera target spinning slowly around it.
----------------------------------------------------------------------------


--- @function get_offset_camera_positions_from_sunit
--- @desc Returns camera offset positions for a supplied script unit. The first camera position is specified by an x and z offset from the supplied script unit, based on that unit's facing. The position height is determined by a vertical bearing (i.e. looking from the side) from the unit.
--- @desc The second returned camera is rotated around the unit from the first by the horizontal delta. If the delta is 0 then only one camera position is returned.
--- @p @script_unit script unit, Subject script unit.
--- @p @number x-offset, X-offset of first camera position from the script unit, by that unit's facing.
--- @p @number z-offset, Z-offset of first camera position from the script unit, by that unit's facing.
--- @p [opt=0.6175] @number vertical bearing, Vertical bearing from subject unit to first camera position. The default value is equivalent to 30 degrees.
--- @p [opt=0.1745] @number delta, Horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
--- @r @battle_vector camera target
--- @r @battle_vector start camera position
--- @r @battle_vector end camera position (or @nil if delta is 0)
function st_helper.get_offset_camera_positions_from_sunit(sunit, x_offset, z_offset, vertical_bearing, horizontal_bearing_delta)

	if not validate.is_scriptunit(sunit) then
		return false;
	end;

	if not validate.is_number(x_offset) or not validate.is_number(z_offset) then
		return false;
	end;

	if vertical_bearing then
		if not validate.is_number(vertical_bearing) then
			return false;
		end;
	else
		vertical_bearing = DEFAULT_VERTICAL_BEARING;
	end;

	if horizontal_bearing_delta then
		if not validate.is_number(horizontal_bearing_delta) then
			return false;
		end;
	else
		horizontal_bearing_delta = DEFAULT_HORIZONTAL_BEARING_DELTA;
	end;

	local unit_position = sunit.unit:position();

	return unit_position, st_helper.get_offset_camera_positions_by_offset_and_bearing(unit_position, x_offset, z_offset, sunit.unit:bearing(), vertical_bearing, horizontal_bearing_delta);
end;


--- @function get_offset_camera_positions_from_sunits
--- @desc Returns camera offset positions for a supplied scriptunits collection. The first camera position is specified by an x and z offset from the centre-point of the scriptunits collection, based on their average bearing (or a bearing override). The position height is determined by a vertical bearing (i.e. looking from the side) from that central point.
--- @desc The second returned camera is rotated around the unit from the first by the horizontal delta. If the delta is 0 then only one camera position is returned.
--- @p @script_units script units, Subject script units.
--- @p @number x-offset, X-offset of first camera position from the script unit, by that unit's facing.
--- @p @number z-offset, Z-offset of first camera position from the script unit, by that unit's facing.
--- @p [opt=0.6175] @number vertical bearing, Vertical bearing from subject unit to first camera position. The default value is equivalent to 30 degrees.
--- @p [opt=nil] @number horizontal bearing override, Horizontal bearing override in radians. By default, the average bearing of all units in the supplied scriptunits collection is used.
--- @p [opt=0.1745] @number delta, Horizontal bearing delta in radians. The default value is equivalent to 10 degrees.
--- @p [opt=false] @boolean relaxed pose, Activates relaxed pose. This raises the height of the camera target above the mean centre of the scriptunits collection, and changes the default vertical bearing from 30 degrees to 20 degrees. The scriptunits will be at the bottom-centre of the screen instead of the centre, with the camera raised, replicating a natural gameplay camera angle.
--- @r @battle_vector camera target
--- @r @battle_vector start camera position
--- @r @battle_vector end camera position (or @nil if delta is 0)
function st_helper.get_offset_camera_positions_from_sunits(sunits, x_offset, z_offset, horizontal_bearing, vertical_bearing, horizontal_bearing_delta, relaxed_camera_pose)

	if not validate.is_scriptunits(sunits) then
		return false;
	end;

	if not validate.is_number(x_offset) or not validate.is_number(z_offset) then
		return false;
	end;

	if horizontal_bearing then
		if not validate.is_number(horizontal_bearing) then
			return false;
		end;
	else
		horizontal_bearing = d_to_r(sunits:average_bearing());
	end;

	if vertical_bearing then
		if not validate.is_number(vertical_bearing) then
			return false;
		end;
	else
		if relaxed_camera_pose then
			vertical_bearing = DEFAULT_RELAXED_VERTICAL_BEARING;
		else
			vertical_bearing = DEFAULT_VERTICAL_BEARING;
		end;
	end;

	if horizontal_bearing_delta then
		if not validate.is_number(horizontal_bearing_delta) then
			return false;
		end;
	else
		horizontal_bearing_delta = DEFAULT_HORIZONTAL_BEARING_DELTA;
	end;

	local sunits_width = sunits:width();
	local centre_pos;

	if relaxed_camera_pose then
		centre_pos = v_offset(sunits:centre_point(), 0, sunits_width / 5, 0);			-- artificially raise the centre point above the sunits, which works better with the relaxed v bearing
	else
		centre_pos = sunits:centre_point();
	end;

	return centre_pos, st_helper.get_offset_camera_positions_by_offset_and_bearing(centre_pos, x_offset, z_offset, horizontal_bearing, vertical_bearing, horizontal_bearing_delta);
end;


--- @function get_offset_camera_positions_from_walls_as_attacker
--- @desc Returns camera offset positions for fortified walls as the siege attacker. The subject wall piece is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_walls_as_attacker()
	-- player is attacker, so we want the camera position to be from the outside of the fort looking in
	local target_building = st_helper.get_closest_connected_wall_building(cam:position(), 1);
	local target_building_pos = target_building:central_position();

	return target_building_pos, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_building_pos, 									-- camera target
		cam:position(),
		90
	);
end;


--- @function get_offset_camera_positions_from_walls_as_defender
--- @desc Returns camera offset positions for fortified walls as the siege defender. The subject wall piece is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_walls_as_defender()

	-- player is defender, so we want the camera position to be from the inside of the fort looking out
	local cam_position = cam:position();

	-- try and find the player unit on the walls closest to the camera that's not near to a gate
	local sunits_player = bm:get_scriptunits_for_local_players_army();
	if sunits_player then
		sunits_on_walls = sunits_player:filter("sunits_on_walls", function(sunit) return sunit.unit:is_on_top_of_platform() end);
		
		local closest_sunit_to_camera = false;
		local closest_sunit_to_camera_distance = 5000;
		for i = 1, sunits_on_walls:count() do
			local current_sunit = sunits_on_walls:item(i);
			local current_sunit_position = current_sunit.unit:position();

			-- only consider the unit if it's more than 100m from the closest gatehouse, so we don't zoom in on a gatehouse as that can be confusing
			local closest_gate_building = st_helper.get_closest_building_from_list(current_sunit_position, bm:get_fort_gate_buildings());

			if closest_gate_building:central_position():distance(current_sunit_position) > 100 then
				local current_sunit_to_camera_distance = current_sunit_position:distance(cam_position);
				if current_sunit_to_camera_distance < closest_sunit_to_camera_distance then
					closest_sunit_to_camera_distance = current_sunit_to_camera_distance;
					closest_sunit_to_camera = current_sunit;
				end;
			end;
		end;

		if closest_sunit_to_camera then
			-- a sunit on the walls was found, so compute a camera offset from it

			local sunit_position = closest_sunit_to_camera.unit:position()
			local target_vector = v(
				sunit_position:get_x(), 
				bm:get_terrain_height(sunit_position:get_x(), sunit_position:get_z()), 
				sunit_position:get_z()
			);

			return target_vector, st_helper.get_offset_camera_positions_by_bearing_vector(
				target_vector,												-- cam target vector
				cam_position,												-- from vector for bearing 
				120															-- distance
			);
		end;
	end;

	-- no suitable sunit on the walls was found
	local target_building = st_helper.get_closest_connected_wall_building(cam_position, 1);
	local target_building_pos = target_building:central_position();
	
	return target_building_pos, st_helper.get_offset_camera_positions_by_bearing(
		target_building_pos, 									-- camera target
		90, 													-- distance
		d_to_r(target_building:orientation())					-- orientation from target to pos
	);
end;


--- @function get_offset_camera_positions_from_gate
--- @desc Returns camera offset positions for a fortified gate. The subject gate is chosen automatically.
--- @p [opt=false] @boolean is attacker, Return offset positions as the attacker i.e. from outside the fort.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_gate(as_attacker)
	
	local target_building = st_helper.get_closest_building_from_list(cam:position(), bm:get_fort_gate_buildings());
	local target_building_pos = target_building:central_position();

	return target_building_pos, st_helper.get_offset_camera_positions_by_bearing(
		target_building_pos,							 									-- camera target
		80, 																				-- distance
		d_to_r(target_building:orientation() + (as_attacker and 180 or 0))					-- orientation from target to pos
	);
end;


--- @function get_offset_camera_positions_from_tower
--- @desc Returns camera offset positions for a tower building. The subject tower is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_tower()
	local camera_pos = cam:position();

	local target_building = st_helper.get_closest_building_from_list(
		camera_pos,
		bm:get_fort_tower_buildings(),
		function(building)
			return building:is_selectable() and not building:has_gate()
		end
	);
	local target_building_pos = v_to_ground(target_building:central_position(), 20);

	return target_building_pos, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_building_pos,											-- cam target vector
		camera_pos,														-- from vector for bearing
		50,																-- distance
		d_to_r(30)														-- v bearing
	);
end;


--- @function get_offset_camera_positions_from_capture_location
--- @desc Returns camera offset positions for a capture location of any type. The subject capture location is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_capture_location()
	local capture_location_records = {};

	-- get a list of all capture locations on the map
	for i = 0, common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") - 1 do
		local capture_location_str = "CapturePointList().At(" .. i .. ")";
		local pos_capture_location = v_from_context_str("CcoBattleRoot", "", capture_location_str .. ".FlagPosition");
		
		table.insert(
			capture_location_records, 
			{
				capture_location_str = capture_location_str,
				pos_capture_location = pos_capture_location
			}
		);
	end;

	if #capture_location_records == 0 then
		script_error("ERROR: get_offset_camera_positions_from_capture_location() could find no capture locations");
		return false;
	end;

	-- pick the closest to the camera
	local camera_pos = cam:position();

	local closest_record = false;
	local closest_distance = 5000;
	for i = 1, #capture_location_records do
		local current_record = capture_location_records[i];
		local current_distance = current_record.pos_capture_location:distance(camera_pos);

		if current_distance < closest_distance then
			closest_distance = current_distance;
			closest_record = current_record;
		end;
	end;
	
	local pos_capture_location = closest_record.pos_capture_location;

	local start_cam_pos, end_cam_pos = st_helper.get_offset_camera_positions_by_bearing_vector(
		pos_capture_location,											-- cam target vector
		camera_pos,														-- from vector for bearing
		70																-- distance
	);

	return pos_capture_location, start_cam_pos, end_cam_pos, closest_record.capture_location_str;
end;


--- @function get_offset_camera_positions_from_gate_capture_location
--- @desc Returns camera offset positions for a capture location for a gate. The subject capture location is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_gate_capture_location()
	local eligible_capture_location_records = {};

	-- get a list of all capture locations tied to gates on the map
	for i = 0, common.get_context_value("CcoBattleRoot", "", "CapturePointList().Size") - 1 do
		local capture_location_str = "CapturePointList().At(" .. i .. ")";
		
		if common.get_context_value("CcoBattleRoot", "", capture_location_str .. ".HasCaptureBuilding") then
			local building_str = capture_location_str .. ".CaptureBuilding";
			if common.get_context_value("CcoBattleRoot", "", building_str .. ".IsGate") then
				local pos_capture_location = v_from_context_str("CcoBattleRoot", "", capture_location_str .. ".FlagPosition");
				local pos_building = v_from_context_str("CcoBattleRoot", "", building_str .. ".CentralPosition");
				
				table.insert(
					eligible_capture_location_records, 
					{
						capture_location_str = capture_location_str,
						pos_capture_location = pos_capture_location,
						pos_building = pos_building
					}
				);
			end;
		end;
	end;

	if #eligible_capture_location_records == 0 then
		script_error("ERROR: get_offset_camera_positions_from_gate_capture_location() could find no gate capture locations");
		return false;
	end;

	-- pick the closest to the camera
	local camera_pos = cam:position();

	local closest_record = false;
	local closest_distance = 5000;
	for i = 1, #eligible_capture_location_records do
		local current_record = eligible_capture_location_records[i];
		local current_distance = current_record.pos_capture_location:distance(camera_pos);

		if current_distance < closest_distance then
			closest_distance = current_distance;
			closest_record = current_record;
		end;
	end;

	-- calculate an offset position, which is a point along a line drawn from the gate to the capture flag, but the same distance the other side of the flag away from the gate
	local pos_gate = closest_record.pos_building;
	local pos_capture_location = closest_record.pos_capture_location;

	local pos_offset_from_gate = position_along_line(pos_gate, pos_capture_location, pos_gate:distance(pos_capture_location) * 2);

	local start_cam_pos, end_cam_pos = st_helper.get_offset_camera_positions_by_bearing_vector(
		pos_capture_location,											-- cam target vector
		pos_offset_from_gate,											-- from vector for bearing
		70																-- distance
	);

	return pos_capture_location, start_cam_pos, end_cam_pos, closest_record.capture_location_str;
end;


--- @function get_offset_camera_positions_from_siege_weapons
--- @desc Returns camera offset positions for a siege weapon. The subject siege weapon is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_siege_weapons()
	
	-- get the closest vehicle to the camera
	local closest_vehicle = bm:get_closest_vehicle(cam:position());

	local target_position;
	if closest_vehicle then
		target_position = closest_vehicle:position();
	else
		script_error("WARNING: get_offset_camera_positions_from_siege_weapons() could find no siege weapons - will compute camera positions from attacking general instead");
		target_position = bm:get_scriptunits_for_main_attacker():get_general_sunit().unit:position();
	end;

	target_position = v_to_ground(target_position, 15);

	-- find the position of the closest gate to the target position
	local closest_gate = st_helper.get_closest_building_from_list(target_position, bm:get_fort_gate_buildings());

	-- return offset positions looking at the target from the direction of the nearest gate
	return target_position, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_position,											-- cam target vector
		closest_gate:central_position(),							-- from vector for bearing
		40,															-- distance
		d_to_r(10)													-- v bearing
	);
end;


--- @function get_offset_camera_positions_from_minor_point_supplies_toggleable_slot_location
--- @desc Returns camera offset positions for a minor-key-building toggleable slot location. The subject slot location is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_minor_point_supplies_toggleable_slot_location()

	local closest_slot_location_str = st_helper.get_closest_toggleable_slot_from_capture_location_of_type(cam:position(), "minor_point_supplies", true);

	if not closest_slot_location_str then
		script_error("ERROR: get_offset_camera_positions_from_minor_point_supplies_toggleable_slot_location() cannot find any minor key building capture locations");
		return false;
	end;

	local target_position = v_from_context_str("CcoBattleRoot", "", closest_slot_location_str .. ".WorldPosition");

	-- return offset positions looking at the target from the direction of the nearest gate
	return target_position, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_position,											-- cam target vector
		cam:position(),												-- from vector for bearing
		90															-- distance
	);
end;


--- @function get_offset_camera_positions_from_minor_point_supplies_capture_location
--- @desc Returns camera offset positions for a minor-key-building capture location. The subject capture location is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_minor_point_supplies_capture_location()

	local closest_location_str = st_helper.get_closest_capture_location_of_type(cam:position(), "minor_point_supplies", true);

	if not closest_location_str then
		script_error("ERROR: get_offset_camera_positions_from_minor_point_supplies_capture_location() cannot find any minor key building capture locations");
		return false;
	end;

	local target_position = v_from_context_str("CcoBattleRoot", "", closest_location_str .. ".Position");

	-- return offset positions looking at the target from the direction of the nearest gate
	return target_position, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_position,											-- cam target vector
		cam:position(),												-- from vector for bearing
		90															-- distance
	);
end;


--- @function get_offset_camera_positions_from_major_victory_point
--- @desc Returns camera offset positions for a major victory point. The subject victory point is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_major_victory_point()
	local closest_location_str = st_helper.get_closest_capture_location_of_type(cam:position(), "victory_point_plaza");

	if not closest_location_str then
		script_error("ERROR: get_offset_camera_positions_from_victory_point() cannot find any minor key building capture locations");
		return false;
	end;

	local target_position = v_from_context_str("CcoBattleRoot", "", closest_location_str .. ".Position");

	-- return offset positions looking at the target from the direction of the nearest gate
	return target_position, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_position,											-- cam target vector
		cam:position(),												-- from vector for bearing
		90															-- distance
	);
end;


--- @function get_offset_camera_positions_from_minor_victory_point
--- @desc Returns camera offset positions for a minor victory point. The subject victory point is chosen automatically.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_from_minor_victory_point()
	local closest_location_str = st_helper.get_closest_capture_location_of_type(cam:position(), "major_key_building", true);

	if not closest_location_str then
		script_error("ERROR: get_offset_camera_positions_from_victory_point() cannot find any minor key building capture locations");
		return false;
	end;

	local target_position = v_from_context_str("CcoBattleRoot", "", closest_location_str .. ".Position");

	-- return offset positions looking at the target from the direction of the nearest gate
	return target_position, st_helper.get_offset_camera_positions_by_bearing_vector(
		target_position,											-- cam target vector
		cam:position(),												-- from vector for bearing
		90															-- distance
	);
end;


--- @function get_offset_camera_positions_for_siege_defence_start
--- @desc Returns camera offset positions suitable for the opening shot of a siege defence. A camera position over the top of the controlled unit closest to the enemy army is chosen.
--- @r @battle_vector camera target
--- @r @battle_vector first camera position
--- @r @battle_vector second camera position
function st_helper.get_offset_camera_positions_for_siege_defence_start()

	local sunits_enemy_main = bm:get_scriptunits_for_main_enemy_army_to_local_player();
	
	-- Find the closest gate building to the enemy
	local closest_building;
	local closest_enemy_sunit;
	do
		local fort_gate_buildings = bm:get_fort_gate_buildings();
		local closest_distance = 999999;

		for i = 1, sunits_enemy_main:count() do
			local current_sunit = sunits_enemy_main:item(i);
			local current_sunit_pos = current_sunit.unit:position();
			
			for j = 1, #fort_gate_buildings do
				local current_building = fort_gate_buildings[j];
				local current_distance = current_sunit_pos:distance_xz(current_building:central_position());
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_building = current_building;
					closest_enemy_sunit = current_sunit;
				end;
			end;
		end;
	end;

	-- Compute a camera target that is 30m to the right of the gate, by the gate's orientation (should be pointing inwards towards the fort), and 30m off the ground

	local camera_target = v_to_ground(
		v_offset_by_bearing(
			closest_building:central_position(),						-- position of building
			d_to_r(closest_building:orientation() + 270), 				-- orientation of building + 90 degrees
			30															-- distance away from building along orientation
		),
		30																-- height of final position above ground
	);

	
	-- Orientation is from computed camera target to the closest enemy
	local orientation_targ_to_pos_r = get_bearing(camera_target, closest_enemy_sunit.unit:position()) + 3.14159;

	return camera_target, st_helper.get_offset_camera_positions_by_bearing(
		camera_target,									 									-- camera target
		60, 																				-- distance
		orientation_targ_to_pos_r,															-- orientation from target to pos
		DEFAULT_RELAXED_VERTICAL_BEARING													-- vertical bearing
	);
end;









----------------------------------------------------------------------------
--- @section Navigable Tour Section Factory
----------------------------------------------------------------------------


--- @function navigable_tour_section_battle_factory
--- @desc Builds and returns a @navigable_tour_section with certain standardised behaviours.
--- @p @string section name, Section name for the navigable tour section being created.
--- @p [opt=nil] @function camera positions generator, Camera positions generator function. If supplied, this function should return two or three @battle_vector objects. If two are supplied, these are assumed to be a camera target and position to pan the camera to when the navigable tour starts.
--- @p [opt=nil] @string advice key, Key of advice to show when the navigable tour section plays. If @nil is supplied then no advice is shown.
--- @p [opt=nil] @table infotext, Table of infotext keys to show when the navigable tour section plays. If @nil is supplied then no infotext is shown.
--- @p [opt=1000] @number advice delay, Interval before the advice, infotext and objectives begin to display. By default this is 1000ms. A @string may also be supplied, in which case it specifies an event which, when received, causes the advice/infotext/objectives to be triggered.
--- @p [opt=nil] @string objective, Objective key of objective to show. This should be a key for a record from the <code>scripted_objectives</code> database table. If @nil is supplied then no objective is shown.
--- @p [opt=nil] @function objective test, Objective completion test function. If supplied, a @battle_manager:watch is set up with this function as the condition. When the condition passes, the supplied objective is marked as completed.
--- @p [opt=false] @boolean leave objective, Leave section objective on-screen after it has been completed. By default the section objective is removed from the screen once it's completed - set this value to <code>true</code> to suppress this behaviour.
--- @p [opt=nil] @string windowed movie path, Path of movie to play in window, if one is required for this navigable tour section.
function st_helper.navigable_tour_section_battle_factory(section_name, camera_positions_generator, advice_key, infotext, advice_infotext_delay, objective_key, objective_completion_test, leave_objective_after_completion, windowed_movie_path)

	if not is_string(section_name) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied section name [" .. tostring(section_name) .. "] is not a string");
		return false;
	end;

	if camera_positions_generator and not is_function(camera_positions_generator) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied camera positions generator function [" .. tostring(camera_positions_generator) .. "] is not a function or nil");
		return false;
	end;

	if advice_key and not is_string(advice_key) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;

	if infotext and not is_table(infotext) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied infotext table [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;

	if advice_infotext_delay then
		if not is_non_negative_number(advice_infotext_delay) and not is_string(advice_infotext_delay) then
			script_error("ERROR: navigable_tour_section_battle_factory() called but supplied objective completion test [" .. tostring(objective_completion_test) .. "] is not a function");
			return false;
		end;
	else
		if advice_key then
			advice_infotext_delay = 1000;
		else
			advice_infotext_delay = 0;
		end;
	end;

	if objective_key and not is_string(objective_key) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;

	if objective_completion_test and not is_function(objective_completion_test) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied objective completion test [" .. tostring(objective_completion_test) .. "] is not a function");
		return false;
	end;

	if windowed_movie_path and not is_string(windowed_movie_path) then
		script_error("ERROR: navigable_tour_section_battle_factory() called but supplied movie key [" .. tostring(windowed_movie_path) .. "] is not a string");
		return false;
	end;

	local nts = navigable_tour_section:new(
		section_name,					-- name
		false							-- activate tour controls on start
	);

	if camera_positions_generator then
		nts.camera_scroll_time_s = 2;
	else
		-- This is still used for unlocking progress controls
		nts.camera_scroll_time_s = 1;
	end;

	-- actions
	nts:action(
		function()
			bm:clear_infotext();
			
			bm:modify_battle_speed(1);
			
			if is_function(camera_positions_generator) then
				-- calculate camera positions to use
				local cam_target, cam_start, cam_end = camera_positions_generator();

				-- move camera
				if cam_start and cam_target then
					cam:move_to(cam_start, cam_target, nts.camera_scroll_time_s, false, 0);

					-- store some values for use later in this section
					nts.cam_target = cam_target;
				end;

				-- only store a cam_end position if it's different from cam_start
				if is_vector(cam_end) and cam_end:distance(cam_start) > 0 then
					nts.cam_end = cam_end;
				end;
			end;
		end,
		0
	);


	local function show_windowed_movie()
		-- show windowed movie if we have one
		if windowed_movie_path then
			local wmp = windowed_movie_player:new_centred("wmp_" .. section_name, windowed_movie_path, 16/9);
			
			local movie_default_width = 1440;
			local width_set = false;
			
			if infotext then
				local uic_infotext = get_infotext_manager():get_infotext_panel();

				if uic_infotext then
					local screen_x = core:get_screen_resolution();

					-- Max width of movie to avoid encroaching on infotext panel
					local movie_max_width = screen_x - (2 * uic_infotext:Width() + 80)

					if movie_max_width < movie_default_width then
						wmp:set_width(movie_max_width);
						width_set = true;
					end;
				end;
			end;

			if not width_set then
				wmp:set_width(movie_default_width);
			end;
			
			wmp:set_show_close_button(false);
			wmp:set_hide_animation("fade");
			wmp:show();

			nts:add_skip_action(
				function()
					wmp:hide();
				end
			);
		end;
	end;


	local function trigger_advice()
		if advice_key then
			bm:queue_advisor(advice_key);
		end;

		if infotext then
			table.insert(infotext, show_windowed_movie);
			if advice_key then
				bm:add_infotext_with_leader(unpack(infotext));
			else
				bm:add_infotext_simultaneously_with_leader(unpack(infotext));
			end;
		end;

		-- highlight the next button when the advisor finishes speaking
		if not core:svr_load_registry_bool("navigable_tour_progress_button_highlighted") then
			bm:progress_on_advice_finished(
				"navigable_tour_section_progress_on_advice_finished",
				function()
					core:svr_save_registry_bool("navigable_tour_progress_button_highlighted", true);
					nts:highlight_next_button();
				end
			);
		end;

		-- remove the advice listener if this section is skipped
		nts:add_skip_action(
			function()
				bm:cancel_progress_on_advice_finished("navigable_tour_section_progress_on_advice_finished");
			end
		);
	end;

	if is_number(advice_infotext_delay) then
		nts:action(
			trigger_advice,
			advice_infotext_delay
		);
	elseif is_string(advice_infotext_delay) then
		-- advice_infotext_delay is actually a string that specifies a script event to listen to
		nts:action(
			function()
				core:add_listener(
					section_name .. "_battle_factory_advice_trigger",
					advice_infotext_delay,
					true,
					trigger_advice,
					false
				);

				nts:add_skip_action(function() core:remove_listener(section_name .. "_battle_factory_advice_trigger") end);
			end,
			0
		);
	end;

	nts:action(
		function()
			-- pan the camera around target if we have an end position
			if nts.cam_end and nts.cam_target then
				cam:move_to(nts.cam_end, nts.cam_target, 30, true);
			end;
			
			-- activate tour next/prev controls
			nts:activate_tour_controls();
		end, 
		nts.camera_scroll_time_s * 1000
	);


	local objective_process_name = section_name .. "_objective_completion";
	local objective_added = false;
	local objective_completed = false;
	
	if objective_key then
		nts:action(
			function()
				-- Reset these values
				objective_added = false;
				objective_completed = false;

				nts:add_skip_action(
					function()
						bm:remove_process(objective_process_name);
					end,
					"stop_objective_process"
				);
			end,
			0
		);
		
		nts:action(
			function()
				objective_added = true;
				bm:set_objective(objective_key);

				-- If the objective has already been completed then remove it in a bit
				if objective_completed then
					nts:remove_skip_action("stop_objective_process");
					bm:callback(
						function()
							bm:remove_process(objective_process_name);
							if not leave_objective_after_completion then
								bm:remove_objective(objective_key);
							end;
						end,
						2000,
						objective_process_name
					);
				end;

				nts:add_skip_action(
					function()
						bm:remove_objective(objective_key);
					end
				);
			end, 
			navigable_tour_section.__add_objective_interval
		);
	end;

	if objective_key and objective_completion_test then
		nts:action(
			function()
				-- Watch for objective being completed
				bm:watch(
					objective_completion_test,
					0,
					function()
						-- Objective has been completed
						bm:complete_objective(objective_key);
						objective_completed = true;
						
						if objective_added then
							nts:remove_skip_action("stop_objective_process");
							-- Remove
							bm:real_callback(
								function()
									bm:remove_process(objective_process_name);
									bm:remove_real_callback(objective_process_name);
									if not leave_objective_after_completion then
										bm:remove_objective(objective_key);
									end;

									-- Highlight the continue button 1 second after removing the objective
									bm:real_callback(
										function()
											bm:progress_on_advice_finished(
												"navigable_tour_section_progress_on_advice_finished_failsafe",
												function()
													if nts:is_playing() then
														core:svr_save_registry_bool("navigable_tour_progress_button_highlighted", true);
														nts:highlight_next_button();
													end;
												end,
												nil,
												500
											);
								
											nts:add_skip_action(
												function()
													bm:cancel_progress_on_advice_finished("navigable_tour_section_progress_on_advice_finished_failsafe");
												end
											);
										end,
										1000,
										nts.name .. "_highlight_continue_after_removing_objective"
									);

									nts:add_skip_action(
										function()
											bm:remove_process(nts.name .. "_highlight_continue_after_removing_objective");
										end
									);
								end,
								2000,
								objective_process_name
							);
						end;
					end,
					objective_process_name
				);
			end,
			-- Don't start listening for objective completion until a second after the tour section starts, to allow the tour actions some time to set stuff up
			1000
		);
	else

		-- If the player hasn't advanced the tour after 45 seconds then highlight the button
		nts:action(
			function()
				bm:progress_on_advice_finished(
					"navigable_tour_section_progress_on_advice_finished_failsafe",
					function()
						if nts:is_playing() then
							core:svr_save_registry_bool("navigable_tour_progress_button_highlighted", true);
							nts:highlight_next_button();
						end;
					end
				);
	
				nts:add_skip_action(
					function()
						bm:cancel_progress_on_advice_finished("navigable_tour_section_progress_on_advice_finished_failsafe");
					end
				);
			end, 
			45000
		);
	end;


	return nts;
end;











----------------------------------------------------------------------------
--- @section Tour Start and End
----------------------------------------------------------------------------


--- @function setup_tour_start
--- @desc A generic function for setting up aspects of the UI at the start of a navigable tour in battle.
--- @p @navigable_tour navigable tour, Host navigable tour.
--- @p [opt=false] @boolean suppress record camera position, If set to <code>true</code>, the current camera position is not recorded on the scripted tour. This is useful if the scripted tour has already done this.
function st_helper.setup_tour_start(nt)
	-- Close current advisor
	bm:stop_advisor_queue(true);
	bm:clear_infotext();

	-- record camera position
	if not suppress_record_camera_position then
		nt.cam_pos_start = cam:position();
		nt.cam_targ_start = cam:target();
	end;

	-- Disable pausing and changing of battle speed, set battle speed to normal, and prevent time updating
	bm:disable_pausing(true);
	bm:modify_battle_speed(1);
	bm:disable_time_speed_controls(true);
	bm:change_conflict_time_update_overridden(true);

	-- Disable orders
	bm:disable_orders(true);

	-- Disable grouping/formations
	bm:disable_groups(true);
	bm:disable_formations(true);

	-- Detach infotext from advisor
	bm:attach_to_advisor(false);
	
	-- Set tour controls above infotext - this needs to be done after detaching infotext
	nt:set_tour_controls_above_infotext(true);

	-- Hide start battle button/advisor progress button
	bm:show_start_battle_button(false);
	show_advisor_progress_button(false);

	-- Hide help panel
	get_help_page_manager():hide_panel();

	-- Disable other bits of the UI we don't want
	bm:disable_tactical_map(true);
	bm:disable_help_page_button(true);
	bm:disable_unit_camera(true);
	bm:disable_unit_details_panel(true);
	bm:show_ui_options_panel(false);
	bm:enable_spell_browser_button(false);
	bm:show_army_panel(false);
	bm:show_winds_of_magic_panel(false);
	bm:show_portrait_panel(false);
end;


--- @function setup_tour_end
--- @desc A generic function for setting up aspects of the UI at the end of a navigable tour in battle.
--- @p @navigable_tour navigable tour
function st_helper.setup_tour_end(nt)
	-- Close current advisor
	bm:stop_advisor_queue(true);
	bm:clear_infotext();

	-- Re-enable bits of the ui
	bm:disable_tactical_map(false);
	bm:disable_help_page_button(false);
	bm:disable_unit_camera(false);
	bm:disable_unit_details_panel(false);
	bm:show_ui_options_panel(true);
	bm:enable_spell_browser_button(true);
	bm:show_army_panel(true);
	bm:show_winds_of_magic_panel(true);
	bm:show_portrait_panel(true);

	-- Show start battle button/advisor progress button
	bm:show_start_battle_button(true);
	show_advisor_progress_button(true);

	-- Re-attach infotext to advisor
	nt:set_tour_controls_above_infotext(false);
	bm:attach_to_advisor(true);

	-- Re-enable orders
	bm:disable_orders(false);

	-- Re-enable grouping/formations
	bm:disable_groups(false);
	bm:disable_formations(false);

	-- Re-enable pausing and time updating, and allow battle speed to be changed
	bm:disable_pausing(false);
	bm:disable_time_speed_controls(false);
	bm:change_conflict_time_update_overridden(false);

	if nt.cam_pos_start and nt.cam_targ_start then
		bm:camera():move_to(nt.cam_pos_start, nt.cam_targ_start, 3);
	end;
end;




