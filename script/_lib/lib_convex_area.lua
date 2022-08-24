



--- @set_environment battle
--- @set_environment campaign




----------------------------------------------------------------------------
--- @section Vector Manipulation
--- @desc A suite of functions related to vectors. In battle scripting terminology, vectors are 2D/3D positions in the game world.
----------------------------------------------------------------------------


--- @function v_to_s
--- @desc Converts a vector to a string, for debug output
--- @p @battle_vector vector
--- @r @string output string
function v_to_s(pos)
	if not is_vector(pos) then
		return "[[not a vector, actually " .. tostring(pos) .. "]]";
	end;
	
	return "[" .. pos:get_x() .. ", " .. pos:get_y() .. ", " .. pos:get_z() .. "]";
end;


--- @function v_offset
--- @desc Takes a source vector and some x/y/z offset values. Returns a target vector which is offset from the source by the supplied values.
--- @p @battle_vector source vector
--- @p [opt=0] @number x offset, X offset in metres (east-west).
--- @p [opt=0] @number y offset, Y offset in metres (height).
--- @p [opt=0] @number z offset, Z offset in metres (north-south).
--- @r vector target vector
function v_offset(vector, x, y, z)
	
	if not is_vector(vector) then
		script_error("ERROR: v_offset() called but supplied position [" .. tostring(vector) .. "] is not a vector");
		return false;
	end;

	-- set default parameters
	local x = x or 0;
	local y = y or 0;
	local z = z or 0;

	return v(vector:get_x() + x, vector:get_y() + y, vector:get_z() + z);
end;


--- @function v_copy
--- @desc Returns a copy of a vector.
--- @r vector vector copy
function v_copy(vector)
	if not is_vector(vector) then
		script_error("ERROR: v_copy() called but supplied position [" .. tostring(vector) .. "] is not a vector");
		return false;
	end;

	return v(vector:get_x(), vectory:get_y(), vector:get_z());
end;


--- @function v_offset_by_bearing
--- @desc Takes a source vector, a bearing, a distance, and an optional vertical bearing, and returns a vector at the computed position from the source vector. The horizontal bearing rotates in a horizontal plane (i.e. looking top-down), the vertical bearing rotates in a vertical plane (i.e. looking from side).
--- @p @battle_vector source vector
--- @p @number bearing, horizontal bearing in radians.
--- @p @number dist, distance in metres.
--- @p [opt=0] @number v bearing, Vertical bearing in radians.
--- @r @battle_vector target vector
function v_offset_by_bearing(vector, bearing, distance, v_bearing)

	if v_bearing then
		local horizontal_dist = distance * math.cos(v_bearing);
	
		return v(
			vector:get_x() + horizontal_dist * math.sin(bearing),
			vector:get_y() + distance * math.sin(v_bearing),
			vector:get_z() + horizontal_dist * math.cos(bearing)
		);
	end;

	return v(
		vector:get_x() + distance * math.sin(bearing),
		vector:get_y(),
		vector:get_z() + distance * math.cos(bearing)
	);
end;


--- @function v_add
--- @desc Takes two vectors, and returns a third which is the sum of both.
--- @p @battle_vector vector a
--- @p @battle_vector vector b
--- @r @battle_vector target vector
function v_add(vector_a, vector_b)

	if not is_vector(vector_a) then
		script_error("ERROR: v_add() called but first supplied position [" .. tostring(vector_a) .. "] is not a vector");
		return false;
	end;
	
	if not is_vector(vector_b) then
		script_error("ERROR: v_add() called but second supplied position [" .. tostring(vector_b) .. "] is not a vector");
		return false;
	end;
	
	return v(vector_a:get_x() + vector_b:get_x(), vector_a:get_y() + vector_b:get_y(), vector_a:get_z() + vector_b:get_z());
end;


--- @function v_subtract
--- @desc Takes two vectors, and returns a third which is the second subtracted from the first.
--- @p @battle_vector vector a
--- @p @battle_vector vector b
--- @r @battle_vector target vector
function v_subtract(vector_a, vector_b)
	
	if not is_vector(vector_a) then
		script_error("ERROR: v_subtract() called but first supplied position [" .. tostring(vector_a) .. "] is not a vector");
		return false;
	end;
	
	if not is_vector(vector_b) then
		script_error("ERROR: v_subtract() called but second supplied position [" .. tostring(vector_b) .. "] is not a vector");
		return false;
	end;
	
	return v(vector_a:get_x() - vector_b:get_x(), vector_a:get_y() - vector_b:get_y(), vector_a:get_z() - vector_b:get_z());
end;


--- @function v_to_ground
--- @desc Returns a @battle_vector at a supplied 2D position at a specified height above or below the ground, making use of @battle:get_terrain_height.
--- @p @battle_vector source position, Source position. A vertical line will be drawn at this position. Where this line intersects the terrain will be considered height 0.
--- @p [opt=0] @number height offset, Height offset from ground in metres. This can be negative.
--- @r @battle_vector target vector
function v_to_ground(source_pos, height)
	
	if not is_vector(source_pos) then
		script_error("ERROR: v_to_ground() called but supplied source vector [" .. tostring(source_pos) .. "] is not a vector");
		return false;
	end;

	if not height then
		height = 0;
	elseif not is_number(height) then
		script_error("ERROR: v_to_ground() called but supplied height offset [" .. tostring(height) .. "] is not a number or nil");
		return false;
	end;

	local x = source_pos:get_x();
	local z = source_pos:get_z();

	return v(x, bm:get_terrain_height(x, z) + height, z);
end;


--- @function v_min_height
--- @desc Returns a @battle_vector at the supplied position at an altitude of at-least the supplied minimum height. If the supplied position is above the minimum height over the terrain then it is returned unaltered.
--- @p @battle_vector input position
--- @p [opt=2] @number minimum altitude
--- @r @battle_vector output position
function v_min_height(input_pos, min_height)
	if not validate.is_vector(input_pos) then
		return false;
	end;

	if min_height then
		if not validate.is_number(min_height) then
			return false;
		end;
	else
		min_height = 2;
	end;

	local height = input_pos:get_y();
	
	if height < min_height then
		return v(input_pos:get_x(), min_height, input_pos:get_z());
	end;
	
	return input_pos;
end;


--- @function centre_point_table
--- @desc Takes a table of vectors, buildings, units or scriptunits, and returns a vector which is the mean centre of the positions described by those objects.
--- @p table position collection, Table of vectors/buildings/units/scriptunits.
--- @r vector centre position
function centre_point_table(t)
	local total_x = 0;
	local total_y = 0;
	local total_z = 0;

	if not is_table(t) then
		script_error("ERROR: centre_point_table() called but supplied object [" .. tostring(t) .. "] is not a table!");
	end;
	
	local table_size = #t;
	
	if table_size == 0 then
		return v(0, 0, 0);
	end;
	
	for i = 1, #t do
		local curr_vector = false;
		
		if is_vector(t[i]) then
			curr_vector = t[i];
			
		elseif is_building(t[i]) then
			curr_vector = t[i]:central_position();
			
		elseif is_unit(t[i]) then
			curr_vector = t[i]:position();
			
		elseif is_scriptunit(t[i]) then
			curr_vector = t[i].unit:position();
			
		else
			script_error("ERROR: centre_point_table() called but list item " .. i .. " is not a vector, building, unit or scriptunit, but a [" .. tostring(t[i]) .. "]");		
			return false;
		end;
		
		total_x = total_x + curr_vector:get_x();
		total_y = total_y + curr_vector:get_y();
		total_z = total_z + curr_vector:get_z();
	end;
	
	return v( total_x / table_size, total_y / table_size, total_z / table_size);
end;


--- @function get_position_near_target
--- @desc Returns a vector at a random position near to a supplied vector. Additional parameters allow a min/max distance and a min/max angle in degrees from the source vector to be specified.
--- @p vector source position
--- @p [opt=20] number min distance, Minimum distance of target position in m.
--- @p [opt=50] number max distance, Maximum distance of target position in m.
--- @p [opt=0] number min bearing, Minimum bearing of target position in degrees.
--- @p [opt=360] number max bearing, Maximum bearing of target position in degrees.
--- @r vector target position
function get_position_near_target(pos, min_dist, max_dist, min_angle, max_angle)

	if not is_vector(pos) then
		script_error("ERROR: get_position_near_target() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;
	
	min_dist = min_dist or 20;
	max_dist = max_dist or 50;
	min_angle = min_angle or 0;
	max_angle = max_angle or 360;
	
	if not is_number(min_dist) or min_dist < 0 then
		script_error("ERROR: get_position_near_target() called but supplied minimum distance [" .. tostring(min_dist) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(max_dist) or max_dist < min_dist then
		script_error("ERROR: get_position_near_target() called but supplied maximum distance [" .. tostring(max_dist) .. "] is not a number greater than the supplied minimum distance [" .. tostring(min_dist) .. "]");
		return false;
	end;
	
	local retval = v(0,0);
	
	local dist = bm:random_number(min_dist, max_dist);
	local angle = bm:random_number(min_angle, max_angle);
	
	retval:set_x(pos:get_x() + (dist * math.cos(d_to_r(angle))));
	retval:set_y(pos:get_y());
	retval:set_z(pos:get_z() + (dist * math.sin(d_to_r(angle))));
	
	return retval;
end;


-- support function for get_furthest/get_nearest
function get_extreme_object(subject, v_list, get_nearest)
	-- if get_nearest we are looking for the nearest point, otherwise we are looking for the furthest
	local func_name = "get_furthest()";
	
	if get_nearest then
		func_name = "get_nearest()";
	end;

	-- check parameters
	if not is_vector(subject) then
		script_error("ERROR: " .. func_name .. " called but supplied subject [" .. tostring(subject) .. "] is not a vector");
		return false;
	end;
	
	-- if our list of positions is a sunits object then get its internal sunits table
	if is_scriptunits(v_list) then
		v_list = v_list:get_sunit_table();
	end;
	
	if not is_table(v_list) then
		script_error("ERROR: " .. func_name .. " called but supplied vector list [" .. tostring(v_list) .. "] is not a table");
		return false;
	end;
	
	if #v_list == 0 then
		script_error("ERROR: " .. func_name .. " called but supplied vector list is empty!");
		return false;
	end;
	
	local extreme_distance = 0;
	local extreme_index = nil;
	local comparison_test = false;
	
	if get_nearest then
		-- set up extreme distance and comparison test as if we were testing for the nearest distance
		extreme_distance = 5000;
		comparison_test = 
			function(vec_a, vec_b, curr_min)
				local curr_dist = vec_a:distance(vec_b);
				if curr_dist < curr_min then
					return curr_dist;
				else
					return false;
				end;
			end;
	else
		-- set up comparison test as if we were testing for the furthest distance
		comparison_test = 
			function(vec_a, vec_b, curr_max)
				local curr_dist = vec_a:distance(vec_b);
				if curr_dist > curr_max then
					return curr_dist;
				else
					return false;
				end;
			end;
	end;
	
	for i = 1, #v_list do
		local curr_list_item = v_list[i];
		local curr_list_vec = false;
		
		if is_vector(curr_list_item) then
			curr_list_vec = curr_list_item;
		elseif is_unit(curr_list_item) then
			curr_list_vec = curr_list_item:position();
		elseif is_scriptunit(curr_list_item) then
			curr_list_vec = curr_list_item.unit:position();
		elseif is_building(curr_list_item) then
			curr_list_vec = curr_list_item:central_position();
		else
			script_error("ERROR: " .. func_name .. " called but object " .. i .. " in vector list is not a vector, unit, scriptunit or building, but [" .. tostring(curr_list_vec) .. "]");
			return false;
		end;
		
		-- do the test, if it returns a value then we have a new max/min distance value
		local test_result = comparison_test(subject, curr_list_vec, extreme_distance);
		if test_result then
			extreme_distance = test_result;
			extreme_index = i;
		end;
	end;
		
	return extreme_index, extreme_distance;
end;


--- @function get_furthest
--- @desc Takes a subject vector and a table of vectors/units/sunits/buildings (or a scriptunits collection). Returns the index of the vector in the table/collection which is furthest from the subject vector.
--- @p vector source position
--- @p table position collection, Table of vector/unit/sunit/building objects, or a scriptunits collection
--- @r integer index of furthest object in list
function get_furthest(subject, v_list)
	return get_extreme_object(subject, v_list, false);
end;


--- @function get_nearest
--- @desc Takes a subject vector and a table of vectors/units/sunits/buildings (or a scriptunits collection). Returns the index of the vector in the table/collection which is closest to the subject vector.
--- @p vector source position
--- @p table position collection, Table of vector/unit/sunit/building objects, or a scriptunits collection
--- @r integer index of closest object in list
function get_nearest(subject, v_list)
	return get_extreme_object(subject, v_list, true);
end;


--- @function position_along_line
--- @desc Takes two vector positions as parameters and a distance in metres, and returns a position which is that distance from the first vector in the direction of the second vector.
--- @p @battle_vector first position, First position.
--- @p @battle_vector second position, Second position.
--- @p @number distance, Distance in metres.
--- @p [opt=false] @boolean 2D only, Disregard height.
--- @r @battle_vector target position
function position_along_line(vector_a, vector_b, dist, two_d)
	if dist == 0 then
		return vector_a;
	end;

	local magnitude;

	if two_d then
		magnitude = vector_a:distance_xz(vector_b);
	else
		magnitude = vector_a:distance(vector_b);
	end;
	
	-- divide-by-zero guard
	if magnitude == 0 then
		return vector_a;
	end;
	
	local x = dist * (vector_b:get_x() - vector_a:get_x()) / magnitude;
	local y = dist * (vector_b:get_y() - vector_a:get_y()) / magnitude;
	local z = dist * (vector_b:get_z() - vector_a:get_z()) / magnitude;
	
	return v_add(vector_a, v(x, y, z));
end;


--- @function position_along_line_unary
--- @desc Takes two vector positions as parameters and a unary (0-1) proportion, and returns a position which is that proportional distance from the first vector in the direction of the second vector. Unary values outside the range of 0-1 are supported.
--- @p @battle_vector first position, First position.
--- @p @battle_vector second position, Second position.
--- @p @number unary distance, Unary distance.
--- @p [opt=false] @boolean 2D only, Disregard height.
--- @r @battle_vector target position
function position_along_line_unary(vector_a, vector_b, unary_dist, two_d)

	if unary_dist == 0 then
		return vector_a;
	end;

	local dist;

	if two_d then
		dist = vector_a:distance_xz(vector_b) * unary_dist;
	else
		dist = vector_a:distance(vector_b) * unary_dist;
	end;

	return position_along_line(vector_a, vector_b, dist);
end;


--- @function dot
--- @desc Returns the dot product of two supplied vectors.
--- @p @battle_vector first position
--- @p @battle_vector second position
--- @r @number dot product
function dot(vector_a, vector_b)
	return (vector_a:get_x() * vector_b:get_x()) + (vector_a:get_z() * vector_b:get_z())
end;


--- @function dot3d
--- @desc Returns the dot product of two supplied vectors in three dimensions.
--- @p @battle_vector first position
--- @p @battle_vector second position
--- @r @number dot product
function dot3d(vector_a, vector_b)
	return (vector_a:get_x() * vector_b:get_x()) + (vector_a:get_y() * vector_b:get_y()) + (vector_a:get_z() * vector_b:get_z())
end;


--- @function normal
--- @desc Returns the normal vector of two supplied vectors.
--- @p @battle_vector first position
--- @p @battle_vector second position
--- @r @battle_vector normal
function normal(vector_a, vector_b)
	return v(vector_a:get_x() + vector_b:get_z() - vector_a:get_z(), 0, vector_a:get_z() + vector_a:get_x() - vector_b:get_x());
end;


--- @function distance_to_line
--- @desc Takes two vector positions that describe a 2D line of infinite length, and a target vector position. Returns the distance from the line to the target vector. This distance will be negative if the target is on the left side of the line, and positive if on the right side of the line.
--- @p @battle_vector line position a
--- @p @battle_vector line position b
--- @p @battle_vector target position
--- @r @number distance
function distance_to_line(line_a, line_b, position)
	
	if line_a:get_x() == line_b:get_x() and line_a:get_z() == line_b:get_z() then
		return 0;
	end;

	--reposition everything as if line_a was the origin
	local new_line_a = v(0,0,0);
	local new_line_b = v(line_b:get_x() - line_a:get_x(), 0, line_b:get_z() - line_a:get_z());
	local new_position = v(position:get_x() - line_a:get_x(), 0, position:get_z() - line_a:get_z());
	
	local dist = new_line_a:distance(new_line_b);
	
	-- divide-by-zero check
	if dist == 0 then
		return 0;
	end;
	
	return (dot(normal(new_line_a, new_line_b), new_position) / dist);
end;


--- @function has_crossed_line
--- @desc Takes a vector, unit, scriptunit or collection of objects and returns true if any element within it has crossed a line demarked by two supplied vector positions.
--- @desc An optional fourth parameter instructs <code>has_crossed_line</code> to only consider the positions of non-routing units, if set to true.
--- @desc An object is deemed to have 'crossed' the line if it's on the right-hand side of the line.
--- @p object position collection, Collection of position objects to test. Supported collection object types are scriptunits, units, army, armies, alliance or a numerically-indexed table of any supported objects.
--- @p @battle_vector line position a
--- @p @battle_vector line position b
--- @p @boolean standing only, Do not count positions of any routing or dead units
--- @r @boolean has crossed line
function has_crossed_line(obj, line_a, line_b, standing_only)
	if is_vector(obj) then
		if not is_vector(line_a) then
			script_error("ERROR: has_crossed_line called but first line point " .. tostring(line_a) .. " is not a vector!");
			
			return false;
		end;
		
		if not is_vector(line_b) then
			script_error("ERROR: has_crossed_line called but second line point " .. tostring(line_b) .. " is not a vector!");
			
			return false;
		end;
		
		if (distance_to_line(line_a, line_b, obj) > 0) then
			--position is on the right side of the line defined by line_a -> line_b
			return true;
		end;
	
	elseif is_unit(obj) then
		if (not standing_only) or (standing_only and not is_routing_or_dead(obj)) then
			return has_crossed_line(obj:position(), line_a, line_b, standing_only);		
		end;
		
	elseif is_scriptunit(obj) then
		return has_crossed_line(obj.unit, line_a, line_b, standing_only);
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if has_crossed_line(obj:item(i).unit, line_a, line_b, standing_only) then
				return true;
			end;
		end;
	
	elseif is_units(obj) then
		for i = 1, obj:count() do
			if has_crossed_line(obj:item(i), line_a, line_b, standing_only) then
				return true;
			end;
		end;
	
	elseif is_army(obj) then
		if has_crossed_line(obj:units(), line_a, line_b, standing_only) then
			return true;
		end;
		
		-- check all reinforcing armies
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			local result = false;
			
			if is_units(r_units) then
				result = has_crossed_line(r_units, line_a, line_b, standing_only);
				
				if result then
					return true;
				end;
			end;
		end;
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if has_crossed_line(obj:item(i), line_a, line_b, standing_only) then
				return true;
			end;
		end;
	
	elseif is_alliance(obj) then
		return has_crossed_line(obj:armies(), line_a, line_b, standing_only);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			if has_crossed_line(obj[i], line_a, line_b, standing_only) then
				return true;
			end;
		end;
	
	else
		script_error("ERROR: has_crossed_line didn't recognise object " .. tostring(obj) .. " to test!");
	end;
	
	return false;	
end;


--- @function get_bearing
--- @desc Returns the bearing in radians from one vector to another. If the vertical bearing flag is supplied then the vertical bearing is returned (i.e. looking from the side), otherwise the horizontal bearing (i.e. looking from above) is returned.
--- @p @battle_vector source vector
--- @p @battle_vector target vector
--- @p [opt=false] @number vertical bearing
--- @r @number bearing in radians
function get_bearing(source_vector, target_vector, return_vertical_bearing)
	if return_vertical_bearing then
		return math.atan2(target_vector:get_y() - source_vector:get_y(), source_vector:distance_xz(target_vector));
	end;
	return math.atan2(target_vector:get_x() - source_vector:get_x(), target_vector:get_z() - source_vector:get_z());
end;


--- @function get_vector_offset_by_bearing
--- @desc Returns a vector that is offset from a supplied source vector, in a particular horizontal 2d bearing (top-down), at a particular distance and vertical bearing. The function is primarily intended to compute camera position offsets from a supplied target but can be used for any purpose.
--- @p @battle_vector source
--- @p [opt=50] @number distance, Distance in m.
--- @p [opt=0] @number h bearing, Horizontal (top-down) bearing in radians.
--- @p [opt=0] @number v bearing, Vertical (from-side) bearing in radians.
--- @r @battle_vector offset vector
function get_vector_offset_by_bearing(source_vector, distance, horizontal_bearing, vertical_bearing)
	if not is_vector(source_vector) then
		script_error("ERROR: get_camera_position_offset_from_target() called but supplied target vector [" .. tostring(source_vector) .. "] is not a battle vector");
		return false;
	end;

	distance = distance or 50;									-- default distance of 100m
	horizontal_bearing = horizontal_bearing or 0;				-- default horizontal bearing
	vertical_bearing = vertical_bearing or 0.6175;				-- default v angle (from ground plane at target position to camera) of 35 degrees

	local target_x = source_vector:get_x();
	local target_y = source_vector:get_y();
	local target_z = source_vector:get_z();

	-- calculate the distance along the ground plane between the target and the camera 
	local horizontal_h = distance * math.cos(vertical_bearing);
	
	return v(
		target_x + horizontal_h * math.sin(horizontal_bearing),
		target_y + distance * math.sin(vertical_bearing),
		target_z + horizontal_h * math.cos(horizontal_bearing)
	);
end;











----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
--
--	CONVEX AREA
--
--- @c convex_area Convex Areas
--- @desc By creating a convex area, client scripts may define a convex hull shape on the battlefield or campaign map through a series of vectors, and then perform tests with it, such as seeing if a given position/unit is within the described shape.
--- @desc Convex areas are most useful for battle scripts, but may also be used in campaign.
--
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

convex_area = {
	my_points = {}
}


set_class_custom_type_and_tostring(convex_area, TYPE_CONVEX_AREA);


--- @section Creation

--- @function new
--- @desc Creates a convex area from a supplied table of vectors. The supplied table must contain a minimum of three vector positions, and these must describe a convex hull shape. The points must declared in a clockwise orientation around the hull shape.
--- @p table positions, Table of vector positions
--- @r convex_area
function convex_area:new(point_list)	
	local ca = {};

	set_object_class(ca, self);
	
	local valid, error_msg = ca:process_points(point_list)
	
	if not valid then
		script_error("ERROR: tried to create convex area but supplied points list was invalid! " .. error_msg);
		
		return false;
	end;
	  	
	return ca;
end;


-- validates a list of points being used to create a convex area
function convex_area:validate_points(forward_point, line_a, line_b)
	if not has_crossed_line(forward_point, line_a, line_b) then
		return false, (" Point " .. v_to_s(forward_point) .. " is not on the right side of the line defined by preceding points " .. v_to_s(line_a) .. " to " .. v_to_s(line_b));
	end;
	
	return true;
end;


-- process a series of points being used to create a convex area (test if they are valid, and return an error if not)
function convex_area:process_points(p)
	if not p or not is_table(p) or #p < 3 then
		return false, " No points list given!";
	end;
	
	if not is_table(p) then
		return false, " Points list is not a table!";	
	end;
	
	if #p < 3 then
		return false, " Points list does not contain at least three points!";
	end;
	
	for i = 1, #p do
		if not is_vector(p[i]) then
			return false, " List item " .. i .. " (" .. tostring(p[i]) .. " is not a vector!";
		end;
	end;
	
	-- walk the line and make sure that each point is on the
	-- correct side of the line formed of the two prior points
	local valid, error_msg = false, "";
	
	for j = 1, (#p - 2) do
		valid, error_msg = self:validate_points(p[j+2], p[j], p[j+1]);
		if not valid then
			-- outer edge of shape has turned anti-clockwise, bad !
			return false, error_msg;
		end;
	end;

	-- need to specifically validate last two point clusters as they wrap around the list
	valid, error_msg = self:validate_points(p[1], p[#p - 1], p[#p]);
	if not valid then
		return false, error_msg;
	end;
	
	valid, error_msg = self:validate_points(p[2], p[#p], p[1]);
	if not valid then
		return false, error_msg;
	end;
	
	self.my_points = p;
	
	return true;
end;







---	@section Usage
--- @desc Once a <code>convex_area</code> object has been created with @convex_area:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;convex_area_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local test_position = v(150, 150)
--- @example local area_01 = convex_area:new({v(0, 0), v(0, 300), v(300, 300), v(300, 0)})
--- @example if area_01:is_in_area(test_position) then
--- @example 	out("test position is in area_01")
--- @example end
--- @result test position is in area_01






--- @section Querying

--- @function item
--- @desc Retrieves the nth vector in the convex area. Returns false if no vector exists at this index.
--- @p integer index
--- @r vector
function convex_area:item(index)
	if index > 0 and index <= #self.my_points then
		return self.my_points[index];
	end;
	
	return false;
end;


--- @function count
--- @desc Returns the number of vector positions that make up this convex area shape
--- @r integer number of positions
function convex_area:count()
	return #self.my_points;
end;


--- @function is_in_area
--- @desc Returns true if any element of the supplied object or collection is in the convex area, false otherwise.
--- @desc The second boolean flag, if set to true, instructs <code>is_in_area</code> to disregard any routing or dead units in the collection.
--- @p object collection, Object or collection to test. Supported object/collection types are vector, unit, scriptunit, scriptunits, units, army, armies, alliance and table.
--- @p [opt=false] boolean standing only, Disregard routing or dead units.
--- @r boolean any are in area
function convex_area:is_in_area(obj, standing_only)
	if is_vector(obj) then
		for i = 1, #self.my_points-1 do
			if not has_crossed_line(self.my_points[i], self.my_points[i+1], obj) then
				return false;
			end;
		end;
	
		if not has_crossed_line(self.my_points[#self.my_points], self.my_points[1], obj) then
			return false;
		end;
	
		return true;
	
	elseif is_unit(obj) then
		if (not standing_only) or (standing_only and not is_routing_or_dead(obj)) then
			return self:is_in_area(obj:position());
		end;
	
	elseif is_scriptunit(obj) then
		return self:is_in_area(obj.unit, standing_only);
	
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if self:is_in_area(obj:item(i).unit, standing_only) then
				return true;
			end;
		end;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			if self:is_in_area(obj:item(i), standing_only) then
				return true;
			end;
		end;
			
	elseif is_army(obj) then
		if self:is_in_area(obj:units(), standing_only) then
			return true;
		end;
		
		-- check all reinforcing armies
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			local result = false;
			
			if is_units(r_units) then
				result = self:is_in_area(r_units, standing_only);
				
				if result then
					return true;
				end;
			end;
		end;
	
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if self:is_in_area(obj:item(i), standing_only) then
				return true;
			end;
		end;
		
	elseif is_generatedarmy(obj) then
		return self:is_in_area(obj.sunits, standing_only);
		
	elseif is_alliance(obj) then
		return self:is_in_area(obj:armies(), standing_only);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			if self:is_in_area(obj[i], standing_only) then
				return true;
			end;
		end;
		
	else
		script_error("ERROR: convex_area:is_in_area() called but parameter " .. tostring(obj) .. " not supported!")
	end;
	
	return false;
end;


--- @function standing_is_in_area
--- @desc Alias for <code>is_in_area(obj, <strong>true</strong>)</code>. Returns true if any element of the supplied object or collection is in the convex area, false otherwise. Supported object/collection types are vector, unit, scriptunit, scriptunits, units, army, armies, alliance and table. Disregards routing or dead units.
--- @p object object or collection to test
--- @r boolean any are in area
function convex_area:standing_is_in_area(obj)
	return self:is_in_area(obj, true);
end;


--- @function not_in_area
--- @desc Returns true if any element of the supplied object or collection is NOT in the convex area, false otherwise.
--- @desc The second boolean flag, if set to true, instructs <code>not_in_area</code> to disregard any routing or dead units in the collection.
--- @p object collection, Object or collection to test. Supported object/collection types are vector, unit, scriptunit, scriptunits, units, army, armies, alliance and table.
--- @p [opt=false] boolean standing only, Disregard routing or dead units.
--- @r boolean any are not in area
function convex_area:not_in_area(obj, standing_only)
	if is_vector(obj) then
		if not self:is_in_area(obj) then
			return true;
		end;
	
	elseif is_unit(obj) then
		if (not standing_only) or (standing_only and not is_routing_or_dead(obj)) then
			return self:not_in_area(obj:position());
		end;
	
	elseif is_scriptunit(obj) then
		return self:not_in_area(obj.unit, standing_only);
	
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if self:not_in_area(obj:item(i).unit, standing_only) then
				return true;
			end;
		end;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			if self:not_in_area(obj:item(i), standing_only) then
				return true;
			end;
		end;
			
	elseif is_army(obj) then
		if self:not_in_area(obj:units(), standing_only) then
			return true;
		end;
		
		-- check all reinforcing armies
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			local result = false;
			
			if is_units(r_units) then
				result = self:not_in_area(r_units, standing_only);
				
				if result then
					return true;
				end;
			end;
		end;
			
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if self:not_in_area(obj:item(i), standing_only) then
				return true;
			end;
		end;
	
	elseif is_alliance(obj) then
		return self:not_in_area(obj:armies(), standing_only);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			if self:not_in_area(obj[i], standing_only) then
				return true;
			end;
		end;
		
	else
		script_error("ERROR: convex_area:not_in_area() called but parameter " .. tostring(obj) .. " not supported!")
	end;
	
	return false;
end;


--- @function standing_not_in_area
--- @desc Alias for <code>not_in_area(obj, <strong>true</strong>)</code>. Returns true if any element of the supplied object or collection is NOT in the convex area, false otherwise.
--- @p object collection, Object or collection to test. Supported object/collection types are vector, unit, scriptunit, scriptunits, units, army, armies, alliance and table. Disregards routing or dead units.
--- @r boolean any are not in area
function convex_area:standing_not_in_area(obj)
	return self:not_in_area(obj, true);
end;


--- @function number_in_area
--- @desc Returns the number of elements in the target collection that fall in the convex area.
--- @desc The second boolean flag, if set to true, instructs <code>number_in_area</code> to disregard any routing or dead units in the collection.
--- @p object collection, Object or collection to test. Supported object types are unit, units, scriptunit, scriptunits, army, armies, alliance and table. 
--- @p [opt=false] boolean standing only, Disregard routing or dead units.
--- @r integer number in area
function convex_area:number_in_area(obj, standing_only)
	local count = 0;
	
	if is_vector(obj) then
		if self:is_in_area(obj) then
			return 1;
		end;
		
	elseif is_unit(obj) then
		if self:is_in_area(obj, standing_only) then
			return 1;
		end;
		
	elseif is_scriptunit(obj) then
		if self:is_in_area(obj.unit, standing_only) then
			return 1;
		end;

	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if self:is_in_area(obj:item(i).unit, standing_only) then
				count = count + 1;
			end;
		end;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			if self:is_in_area(obj:item(i), standing_only) then
				count = count + 1;
			end;
		end;
			
	elseif is_army(obj) then
		count = count + self:number_in_area(obj:units(), standing_only);
				
		-- check all reinforcing armies
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			
			if is_units(r_units) then
				count = count + self:number_in_area(r_units, standing_only);
			end;
		end;

	elseif is_armies(obj) then
		for i = 1, obj:count() do
			count = count + self:number_in_area(obj:item(i), standing_only);
		end;
	
	elseif is_alliance(obj) then
		return self:number_in_area(obj:armies(), standing_only);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			count = count + self:number_in_area(obj[i], standing_only);
		end;
		
	else
		script_error("ERROR: convex_area:is_in_area() called but parameter " .. tostring(obj) .. " not supported!")
	end;
	
	return count;
end;


--- @function standing_number_in_area
--- @desc Alias for <code>standing_number_in_area(obj, <strong>true</strong>)</code>. Returns the number of elements in the target collection that fall in the convex area. 
--- @p object collection, Object or collection to test. Supported object types are unit, units, scriptunit, scriptunits, army, armies, alliance and table. isregards routing or dead units.
--- @r integer number in area
function convex_area:standing_number_in_area(obj)
	return self:number_in_area(obj, true);
end;




