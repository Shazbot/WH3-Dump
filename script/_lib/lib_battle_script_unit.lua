
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	SCRIPT UNIT
--
--- @set_environment battle
--- @c script_unit Script Unit
--- @desc A scriptunit is a script object type which represents a single unit on the battlefield. Its primary function is to package a @battle_unit interface that represents the unit together with a @battle_unitcontroller that has control over that unit. By packaging these two interfaces together, a scriptunit provides access through one object to commands that test the state of a unit (the @battle_unit interface) as well as commands which issue orders to that unit (the @battle_unitcontroller interface). Scriptunit objects may be passed around in script with the receiving code being sure that it has access to both read and modify the state of the subject unit.
--- @desc The scriptunit interface provides direct access to the @battle_unit and @battle_unitcontroller interfaces related to the unit at the unit (<sunit_obj>.unit) and uc (<sunit_obj>.uc) elements respectively. The scriptunit interface also provides additional functionality related to the querying and control of units. See the list of functions on this page for more information.
---	@desc Scriptunit objects may be grouped together in a specialised container, the @script_units object. This provides yet further functionality that can be offered when a collection of script units are assembled together. See the @script_units documentation further down this page for more information.
--
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

script_unit = {
	name = "",
	full_name = "",
	alliance = nil,
	alliance_num = -1,
	army = nil,
	army_num = -1,
	unit = nil,
	uc = nil,
	enemy_alliance_num = -1,
	start_position = nil,
	start_bearing = nil,
	start_width = nil,
	uic_ping_marker = false,
	is_enabled = true,
	deployed_as_reinforcement_count = 0			-- number of times that deploy_reinforcement has deployed this unit
};


set_class_custom_type(script_unit, TYPE_SCRIPT_UNIT);
set_class_tostring(
	script_unit,
	function(obj)
		return TYPE_SCRIPT_UNIT .. "_" .. obj.unit:unique_ui_id()
	end
);








----------------------------------------------------------------------------
---	@section Creation
--- @desc On creation, the @battle_manager automatically sets up a <code>script unit</code> object for each unit and a @script_units collection object for each army in the battle. These can be retrieved from the @battle_manager with the functions listed in the @battle_manager:Scriptunits section of this documentation.
--- @desc New script unit objects may nevertheless be created using @script_unit:new or @script_unit:new_by_reference.
----------------------------------------------------------------------------


--- @function new_by_reference
--- @desc Creates a new script unit. The unit object to encapsulate is looked up by the supplied army and reference name.
--- @p @battle_army army, Army the target unit is a member of.
--- @p value reference, Reference for the unit. This can either be a @string name, or an integer number representing the unit's index within the army ('1' is generally the general, for example). If a @string name is supplied this must match the script name given to the unit in the battle setup - this is generally set in either the battle xml or in the relevant entry in the <code>battle_set_piece_armies_units_junctions</code> database table.
--- @r script_unit
function script_unit:new_by_reference(army, unit_ref)
	-- type check our startup parameters
	if not is_army(army) then
		script_error("ERROR: script_unit:new_by_reference() called but supplied army [" .. tostring(army) .. "] is not a valid army object");
		return false;
	end;
	
	if not is_string(unit_ref) then
		if not is_number(unit_ref) then
			script_error("ERROR: script_unit:new_by_reference() called but supplied unit reference " .. tostring(unit_ref) .. " is not a string or a number");
			return false;
		end;
	end;

	local unit = nil;
	local unit_found = false;
	
	--try and find this unit in the base army
	if pcall(function() unit = army:units():item(unit_ref) end) then
		-- call succeeded - unit was found in the base army
		unit_found = true;
	else
		-- call failed - check the reinforcing units of this army
		local num_units_in_last_checked_army = army:units():count();
		local reinforcing_ref = unit_ref;
		
		-- try and find this unit in each of the reinforcing armies
		for i = 1, army:num_reinforcement_units() do
		
			-- if unit_ref is a number at this point, then subtract the number of units in all armies examined by this point (including other
			-- reinforcing armies) to make the ref for this reinforcing army
			-- so that if the first army contains 15 units, the first reinforcing army contains 5 units and the second 4 units, and we're looking
			-- for unit #22, this will get the second unit in the second reinforcing army
			if is_number(reinforcing_ref) then
				reinforcing_ref = reinforcing_ref - num_units_in_last_checked_army;
			end;
			
			local current_r_units = army:get_reinforcement_units(i);
			
			-- try and find this unit in the current reinforcing army
			if pcall(function() unit = current_r_units:item(reinforcing_ref) end) then
				if is_number(reinforcing_ref) then
					unit_ref = "R_" .. reinforcing_ref;
				end;
				-- call succeeded
				unit_found = true;
				break;
			end;
			
			num_units_in_last_checked_army = current_r_units:count();			
		end;
	end;
	
	if not unit_found then
		script_error("ERROR: script_unit:new_by_reference() called but no unit with name or reference [" .. unit_ref .. "] could be found in army [" .. tostring(army) .. "]");
		return false;
	end;

	return script_unit:new_impl(unit, unit_ref);
end;


--- @function new
--- @desc Creates a new script unit from a supplied @battle_unit. An optional reference name may be passed which is used for debug output.
--- @p @battle_unit unit, Unit object to be contained.
--- @p [opt=nil] @string name, Reference name for the unit.
--- @r script_unit
function script_unit:new(unit, unit_ref)
	if not is_unit(unit) then
		script_error("ERROR: script_unit:new() called but supplied unit [" .. tostring(unit) .. "] is not a valid unit object");
		return false;
	end;

	if unit_ref and not is_string(unit_ref) then
		script_error("ERROR: script_unit:new() called but supplied unit reference [" .. tostring(unit_ref) .. "] is not a string or nil");
		return false;
	end;

	return script_unit:new_impl(unit, unit_ref);
end;


-- internal function to actually create the script_unit
function script_unit:new_impl(unit, unit_ref)

	-- if the battle manager exists then it should already have created a handle to this scriptunit during construction, so let's return that
	if bm then
		local sunit = bm:get_scriptunit_for_unit(unit);
		if sunit then
			
			-- we have found a sunit and should return it, but if a unit_ref has been provided then use it to reset the sunit name
			if unit_ref then
				sunit:set_name(unit_ref);
			end;
			return sunit;
		end;

		-- no existing scriptunit was found and we're not in construction, so throw an error but proceed
		script_error("WARNING: script_unit:new() called but no existing scriptunit could be found for unit [" .. tostring(unit) .. "] with supplied reference [" .. tostring(unit_ref) .. "] with army index [" .. unit:army_index() .. "] and alliance index [" .. unit:alliance_index() .. "], and we're not in construction. Creating one, but this should be investigated");
	end;

	-- get the bm this way as the battle manager is mid-construction, but it will be registered with core
	local bm = core:get_static_object("battle_manager");
	
	-- set up the script unit
	local su = {};

	-- store unit and unitcontroller
	su.unit = unit;
	su.uc = create_unitcontroller(unit);

	set_object_class(su, self);

	-- store alliance and enemy alliance indexes
	local alliance_num = unit:alliance_index();
	
	su.alliance_num = alliance_num;

	-- determine an enemy alliance number
	if alliance_num == 2 then
		su.enemy_alliance_num = 1;
	else
		su.enemy_alliance_num = 2;
	end;

	-- give this sunit a unique name for output purposes
	su:set_name(unit_ref);
	
	su.start_position = unit:ordered_position();
	su.start_bearing = unit:bearing();
	su.start_width = unit:ordered_width();

	-- register the scriptunit with the battle manager, which keeps a flat list of all scriptunits in the battle for reference
	bm:register_scriptunit_for_unit(unit, su);
	
	return su;
end;


-- sets or resets the name of the script unit, for debug output purposes
function script_unit:set_name(unit_ref)
	if unit_ref then
		self.name = tostring(self.unit:unique_ui_id()) .. ":" .. tostring(unit_ref);
	else
		self.name = tostring(self.unit:unique_ui_id());
	end;
	self.full_name = "script_unit_" .. self.name;
end;







----------------------------------------------------------------------------
---	@section Unit and Unitcontroller Access
----------------------------------------------------------------------------

--- @variable unit @battle_unit object representing the subject unit.
--- @variable uc @battle_unitcontroller unitcontroller object that controls the unit.
--- @variable army_index @number index of army that the unit belongs to.
--- @variable alliance_index @number index of alliance that the unit belongs to.


--- @function army
--- @desc Returns the army object to which the unit contained by this scriptunit currently belongs.
--- @r @battle_army army
function script_unit:army()
	return self.unit:army();
end;


--- @function alliance
--- @desc Returns the alliance object to which the unit contained by this scriptunit belongs.
--- @r @battle_alliance alliance
function script_unit:alliance()
	return self.unit:army():alliance();
end;










----------------------------------------------------------------------------
---	@section Start Location
----------------------------------------------------------------------------


--- @variable start_position @battle_vector Vector position the unit started the battle at.
--- @variable start_bearing @number Bearing in degrees the unit started the battle at.
--- @variable start_width @number Width in m of the unit at the start of the battle.


--- @function goto_start_location
--- @desc Instructs the scriptunit to move to its start location.
--- @p [opt=false] boolean should run
function script_unit:goto_start_location(should_run)
	self.uc:goto_location_angle_width(self.start_position, self.start_bearing, self.start_width, should_run); 
end;


--- @function teleport_to_start_location
--- @desc Teleports the scriptunit to the position/bearing/width it started the battle at.
function script_unit:teleport_to_start_location()
	self.uc:teleport_to_location(self.start_position, self.start_bearing, self.start_width); 
end;


--- @function teleport_to_start_location_offset
--- @desc Teleports the scriptunit to an offset from the position/bearing/width it started the battle at. This offset will be calculated from the scriptunit's start bearing, so an offset of [0, -10] will teleport it 10m behind its starting position. The function also optionally takes an override bearing to alter the position calculation, as well as a flag to release the unit to script control afterwards.
--- @p number x offset, x offset in m
--- @p number z offset, z offset in m
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @p [opt=false] boolean release control, Release control after teleporting. Set this to true if you want the player (or AI, if it's not player-controlled) to be able to control this unit immediately after teleporting.
function script_unit:teleport_to_start_location_offset(x_offset, z_offset, bearing, should_release)
	if not is_number(x_offset) then
		script_error(self.name .. " ERROR: teleport_to_start_location_offset() called but suppled x_offset [" .. tostring(x_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(z_offset) then
		script_error(self.name .. " ERROR: teleport_to_start_location_offset() called but suppled z_offset [" .. tostring(z_offset) .. "] is not a number");
		return;
	end;

	if not bearing then
		bearing = d_to_r(self.start_bearing);
	end;
	
	local x_pos = self.start_position:get_x() + x_offset * math.cos(bearing) + z_offset * math.sin(bearing);
	local z_pos = self.start_position:get_z() - x_offset * math.sin(bearing) + z_offset * math.cos(bearing);
	local destination = v(x_pos, z_pos);

	self.uc:teleport_to_location(destination, r_to_d(bearing), self.start_width); 
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function goto_start_location_offset
--- @desc Instructs the scriptunit to move to an offset from the position/bearing/width it started the battle at. This offset will be calculated from the scriptunit's start bearing, so an offset of [0, -10] will send it 10m behind its starting position. The function also optionally takes a flag to instruct the unit to run, an override bearing to alter the position calculation, as well as a flag to release the unit to script control afterwards.
--- @p number x offset, x offset in m
--- @p number z offset, z offset in m
--- @p [opt=false] boolean should run, Set to true to instruct the unit to move quickly to its destination.
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @p [opt=false] boolean release control, Release control after the movement order is issued. Set this to true if you want the player (or AI, if it's not player-controlled) to be able to control this unit immediately after moving.
function script_unit:goto_start_location_offset(x_offset, z_offset, should_run, bearing, should_release)
	if not is_number(x_offset) then
		script_error(self.name .. " ERROR: goto_start_location_offset() called but suppled x_offset [" .. tostring(x_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(z_offset) then
		script_error(self.name .. " ERROR: goto_start_location_offset() called but suppled z_offset [" .. tostring(z_offset) .. "] is not a number");
		return;
	end;

	if not bearing then
		bearing = d_to_r(self.start_bearing);
	end;
	
	local x_pos = self.start_position:get_x() + x_offset * math.cos(bearing) + z_offset * math.sin(bearing);
	local z_pos = self.start_position:get_z() - x_offset * math.sin(bearing) + z_offset * math.cos(bearing);
	local destination = v(x_pos, z_pos);
	
	self.uc:goto_location_angle_width(destination, r_to_d(bearing), self.start_width, should_run);
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function respawn_in_start_location
--- @desc Respawns the unit at the location it started the battle. This resets its health, fatigue, casualties and other stats.
--- @p [opt=false] @boolean only if dead, Respawn the unit only if it is dead, or if it has routed off the battlefield.
--- @r @boolean unit was respawned
function script_unit:respawn_in_start_location(only_if_dead)
	-- If the only_if_dead flag is set then we abort if neither of the following two conditions is true:
	--	1) the unit has no men left
	--	2) the unit is routing or shattered, and is off the battlefield
	if only_if_dead then
		if not (self.unit:number_of_men_alive() == 0 or ((self.unit:is_routing() or self.unit:is_shattered()) and not self.unit:is_valid_target())) then
			return false;
		end;
	end;

	self.unit:respawn(self.start_position, self.start_bearing, self.start_width);
	return true;
end;










----------------------------------------------------------------------------
---	@section Current Location
----------------------------------------------------------------------------


--- @function position_offset
--- @desc Returns the position of the scriptunit, offset from its current position. This offset will be calculated from the scriptunit's current bearing, so an offset of [0, 0, -10] will report a position 10m behind its current position. An override bearing to alter the position calculation may optionally be supplied.
--- @p number x offset, x offset in m
--- @p number y offset, y offset (height) in m
--- @p number z offset, z offset in m
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @r @battle_vector offset position
function script_unit:position_offset(x_offset, y_offset, z_offset, bearing_deg)
	if not is_number(x_offset) then
		script_error(self.name .. " ERROR: goto_location_offset() called but suppled x offset [" .. tostring(x_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(y_offset) then
		script_error(self.name .. " ERROR: goto_location_offset() called but suppled y offset [" .. tostring(y_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(z_offset) then
		script_error(self.name .. " ERROR: goto_location_offset() called but suppled z offset [" .. tostring(z_offset) .. "] is not a number");
		return;
	end;

	if not bearing_deg then
		bearing_deg = self.unit:bearing();
	end;
	
	local bearing_rad = d_to_r(bearing_deg);
	
	return v(
		self.unit:position():get_x() + x_offset * math.cos(bearing_rad) + z_offset * math.sin(bearing_rad),		-- x
		self.unit:position():get_y() + y_offset,																-- y
		self.unit:position():get_z() - x_offset * math.sin(bearing_rad) + z_offset * math.cos(bearing_rad)		-- z
	);
end;


--- @function goto_location_offset
--- @desc Instructs the scriptunit to move to an offset from its current position. This offset will be calculated from the scriptunit's current bearing, so an offset of [0, -10] will send it 10m behind its current position. The function also optionally takes a flag to instruct the unit to run, an override bearing to alter the position calculation, as well as a flag to release the unit to script control afterwards.
--- @p number x offset, x offset in m
--- @p number z offset, z offset in m
--- @p [opt=false] boolean should run, Set to true to instruct the unit to move quickly to its destination.
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @p [opt=false] boolean release control, Release control after the movement order is issued. Set this to true if you want the player (or AI, if it's not player-controlled) to be able to control this unit immediately after moving.
function script_unit:goto_location_offset(x_offset, z_offset, should_run, bearing_deg, should_release)
	if not is_number(x_offset) then
		script_error(self.name .. " ERROR: goto_location_offset() called but suppled x_offset [" .. tostring(x_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(z_offset) then
		script_error(self.name .. " ERROR: goto_location_offset() called but suppled z_offset [" .. tostring(z_offset) .. "] is not a number");
		return;
	end;

	if not bearing_deg then
		bearing_deg = self.unit:bearing();
	end;
	
	local bearing_rad = d_to_r(bearing_deg);
	
	local x_pos = self.unit:position():get_x() + x_offset * math.cos(bearing_rad) + z_offset * math.sin(bearing_rad);
	local z_pos = self.unit:position():get_z() - x_offset * math.sin(bearing_rad) + z_offset * math.cos(bearing_rad);
	local destination = v(x_pos, z_pos);

	self.uc:goto_location_angle_width(destination, bearing_deg, self.unit:ordered_width(), should_run);
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function teleport_to_location_offset
--- @desc Instructs the scriptunit to teleport to an offset from its current position. This offset will be calculated from the scriptunit's current bearing, so an offset of [0, -10] will teleport it 10m behind its current position. The function also optionally takes an override bearing to alter the position calculation, as well as a flag to release the unit to script control afterwards.
--- @p number x offset, x offset in m
--- @p number z offset, z offset in m
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @p [opt=false] boolean release control, Release control after the teleport order is issued. Set this to true if you want the player (or AI, if it's not player-controlled) to be able to control this unit immediately after teleporting.
function script_unit:teleport_to_location_offset(x_offset, z_offset, bearing_deg, should_release)
	if not is_number(x_offset) then
		script_error(self.name .. " ERROR: teleport_to_location_offset() called but suppled x_offset [" .. tostring(x_offset) .. "] is not a number");
		return;
	end;
	
	if not is_number(z_offset) then
		script_error(self.name .. " ERROR: teleport_to_location_offset() called but suppled z_offset [" .. tostring(z_offset) .. "] is not a number");
		return;
	end;
	
	local position = self.unit:position();

	if not bearing_deg then
		bearing_deg = self.unit:bearing();
	end;
	
	local bearing_rad = d_to_r(bearing_deg);
	
	local x_pos = position:get_x() + x_offset * math.cos(bearing_rad) + z_offset * math.sin(bearing_rad);
	local z_pos = position:get_z() - x_offset * math.sin(bearing_rad) + z_offset * math.cos(bearing_rad);
	local destination = v(x_pos, z_pos);
		
	bm:out(self.name .. " teleporting from " .. v_to_s(position) .. " to " .. v_to_s(destination));

	self.uc:teleport_to_location(destination, bearing_deg, self.unit:ordered_width());
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function goto_location_offset_when_deployed
--- @desc Instructs the scriptunit to goto an offset from its location when it deploys. This offset will be calculated from the scriptunit's bearing at the time it finds itself on the battlefield, so an offset of [0, -5] will move it 50m forward. The function also optionally takes a flag instructing it to run, an override bearing to alter the position calculation, as well as a flag to release the unit to script control afterwards.
--- @p number x offset, x offset in m
--- @p number z offset, z offset in m
--- @p [opt=false] boolean should run, Set to true to instruct the unit to move quickly to its destination.
--- @p [opt=nil] number bearing override, Bearing override in degrees. Supply a value here to override the bearing used to make the offset calculation.
--- @p [opt=false] boolean release control, Release control after the movement order is issued. Set this to true if you want the player (or AI, if it's not player-controlled) to be able to control this unit immediately after moving.
function script_unit:goto_location_offset_when_deployed(x_offset, z_offset, should_run, bearing, should_release)
	bm:watch(
		function()
			return has_deployed(self.unit)
		end,
		0,
		function()
			self:goto_location_offset(x_offset, z_offset, should_run, bearing, should_release)
		end,
		self.name .. "_goto_location_offset_when_deployed"
	);
end;


--- @function stop_goto_location_offset_when_deployed
--- @desc Stops a running @script_unit:goto_location_offset_when_deployed listener on the current unit. Call this after calling @script_unit:goto_location_offset_when_deployed to stop the listener for any reason.
function script_unit:stop_goto_location_offset_when_deployed()
	bm:remove_process(self.name .. "_goto_location_offset_when_deployed");
end;


--- @function turn_to_face
--- @desc Instructs the scriptunit to turn to face a position vector.
--- @p vector position
function script_unit:turn_to_face(pos)
	if not is_nil(pos) and not is_vector(pos) then
		script_error("ERROR: turn_to_face() called but supplied position " .. tostring(pos) .. " is not a vector!");
		return false;
	end;

	local current_pos_x = self.unit:position():get_x();
	local current_pos_y = self.unit:position():get_z();
	local target_pos_x = pos:get_x();
	local target_pos_y = pos:get_z();
	
	local adj = target_pos_y - current_pos_y;
	local opp = target_pos_x - current_pos_x;
	
	local angle = 0;
	
	-- divide-by-zero guard
	if adj ~= 0 then
		angle = r_to_d(math.atan2(opp, adj));
	end;
		
	if target_pos_y < current_pos_y then
		if target_pos_x > current_pos_x then
			angle = angle + 180;
		else
			angle = angle - 180;
		end;
	end;
	
	self.uc:goto_location_angle_width(self.unit:position(), angle, self.unit:ordered_width(), true);	
end;


--- @function teleport_to_location
--- @desc Instructs the scriptunit to teleport to a location.
--- @p vector position, Position to teleport to.
--- @p number bearing, Bearing to face at the target position in degrees.
--- @p number width, Width in m of formation at target position.
function script_unit:teleport_to_location(position, bearing, width)
	if not is_vector(position) then
		script_error(self.name .. " ERROR: teleport_to_location() called but supplied position [" .. tostring(position) .. "] is not a battle vector");
		return false;
	end;
	
	if not is_number(bearing) then
		script_error(self.name .. " ERROR: teleport_to_location() called but supplied bearing [" .. tostring(bearing) .. "] is not a number");
		return false;
	end;
	
	if not is_number(width) then
		script_error(self.name .. " ERROR: teleport_to_location() called but supplied width [" .. tostring(width) .. "] is not a number");
		return false;
	end;

	-- bm:out(self.name .. ":teleport_to_location(" .. v_to_s(position) .. ", " .. bearing .. ", " .. width .. ") called");
	self.uc:teleport_to_location(position, bearing, width);
end;











----------------------------------------------------------------------------
---	@section Location Caching
----------------------------------------------------------------------------


--- @function cache_location
--- @desc Caches the units current position, bearing and width.
function script_unit:cache_location()
	self.cached_pos = self.unit:position();
	self.cached_bearing = self.unit:bearing();
	self.cached_width = self.unit:ordered_width();
end;


--- @function get_cached_position
--- @desc Returns the vector position of the unit last time it was cached with @script_unit:cache_location.
--- @r vector position (or nil, if never cached).
function script_unit:get_cached_position()
	return self.cached_pos;
end;


--- @function get_cached_bearing
--- @desc Returns the bearing of the unit in degrees last time it was cached with @script_unit:cache_location.
--- @r number bearing (or nil, if never cached).
function script_unit:get_cached_bearing()
	return self.cached_bearing;
end;


--- @function get_cached_width
--- @desc Returns the width of the unit in m last time it was cached with @script_unit:cache_location.
--- @r number width (or nil, if never cached).
function script_unit:get_cached_width()
	return self.cached_width;
end;


--- @function goto_cached_location
--- @desc Instructs the scriptunit to move to the location the unit occupied the last time it was cached with @script_unit:cache_location.
--- @p [opt=false] boolean should run, Instructs the unit to move fast.
function script_unit:goto_cached_location(should_run)
	if is_vector(self.cached_pos) and is_number(self.cached_bearing) and is_number(self.cached_width) then
		should_run = not not should_run;
		self.uc:goto_location_angle_width(self.cached_pos, self.cached_bearing, self.cached_width, should_run);
	end;
end;


--- @function teleport_to_cached_location
--- @desc Teleports the scriptunit to the location the unit occupied the last time it was cached with @script_unit:cache_location.
function script_unit:teleport_to_cached_location()
	if is_vector(self.cached_pos) and is_number(self.cached_bearing) and is_number(self.cached_width) then
		self.uc:teleport_to_location(self.cached_pos, self.cached_bearing, self.cached_width);
	end;
end;


--- @function has_moved
--- @desc Returns true if the scriptunit has moved from the last cached position, or an optional supplied position. The movement threshold can also be overriden (by default it's 1m).
--- @p [opt=nil] vector position override
--- @p [opt=1] number threshold distance
--- @r boolean has moved
function script_unit:has_moved(pos, threshold_distance)
	if not is_number(threshold_distance) then
		if not is_nil(threshold_distance) then 
			script_error("ERROR: has_moved() called but supplied distance [" .. tostring(threshold_distance) .. "] is not a number");
			return false;
		end;
		
		threshold_distance = 1;
	end;
		
	local cached_pos = self.cached_pos;
	
	if not cached_pos then
		script_error(self.name .. " ERROR: has_moved() called but location was never cached with cache_location()")
		return false;
	end;
	
	if pos then
		if not is_vector(pos) then
			script_error("ERROR: has_moved() called but supplied position [" .. tostring(pos) .. "] is not a vector");
			return false;
		end;
		
		-- return true if the unit has moved the supplied distance closer to the specified pos
		return self.unit:position():distance_xz(pos) + threshold_distance < cached_pos:distance_xz(pos);
	end;

	local distance = self.unit:position():distance_xz(cached_pos);
	return distance > threshold_distance;
end;


--- @function cache_destination
--- @desc Caches the current destination position of the scriptunit. Note that the if the subject unit is attacking rather than moving to a position it will have no valid destination. The function also caches whether the unit is running.
function script_unit:cache_destination()
	local unit = self.unit;

	bm:out(self.name .. " cache_destination() called, position is " .. v_to_s(unit:position()) .. ", ordered_position is " .. v_to_s(unit:ordered_position()) .. ", bearing is " .. tostring(unit:ordered_bearing()) .. ", ordered_width is " .. v_to_s(unit:ordered_width()) .. ", moving_fast is " .. tostring(unit:is_moving_fast()))
	
	self.cached_destination_pos = unit:ordered_position();
	self.cached_destination_bearing = unit:ordered_bearing();
	self.cached_destination_width = unit:ordered_width();
	self.cached_is_running = unit:is_moving_fast();
end;


--- @function cache_destination_and_halt
--- @desc Caches the current destination position of the scriptunit with @script_unit:cache_destination, and then orders the unit to halt.
function script_unit:cache_destination_and_halt()
	self:cache_destination();
	self:halt();
end;


--- @function get_cached_destination_position
--- @desc Returns the vector destination last cached by @script_unit:cache_destination.
--- @r vector destination position (or nil if destination never cached).
function script_unit:get_cached_destination_position()
	return self.cached_destination_pos;
end;


--- @function get_cached_destination_bearing
--- @desc Returns the ordered bearing in degrees that was last cached by @script_unit:cache_destination.
--- @r number bearing in degrees (or nil if destination never cached).
function script_unit:get_cached_destination_bearing()
	return self.cached_destination_bearing;
end;


--- @function get_cached_destination_width
--- @desc Returns the ordered width in m that was last cached by @script_unit:cache_destination.
--- @r number width in m (or nil if destination never cached).
function script_unit:get_cached_destination_width()
	return self.cached_destination_width;
end;


--- @function goto_cached_destination
--- @desc Instructs the unit to move to the location last cached by @script_unit:cache_destination. If the unit was moving quickly when its destination was last cached, than it will resume moving quickly when this function is called.
--- @p [opt=false] boolean should release, Set to true to release script control of the unit after calling this function. Set this if it's desirable for the player (or AI, if it's not a player-controlled unit) to be able to control this unit after the order has been issued.
function script_unit:goto_cached_destination(should_release)
	if not is_vector(self.cached_destination_pos) then
		script_error(self.name .. " ERROR: goto_cached_destination() called but no destination has been previously cached with cache_destination() - call this first");
		return false;
	end;
	
	bm:out(self.name .. " goto_cached_destination() called, ordered_position is " .. v_to_s(self.cached_destination_pos) .. ", bearing is " .. tostring(self.cached_destination_bearing) .. ", ordered_width is " .. v_to_s(self.cached_destination_width) .. ", moving_fast is " .. tostring(self.cached_is_running))

	self.uc:goto_location_angle_width(self.cached_destination_pos, self.cached_destination_bearing, self.cached_destination_width, self.cached_is_running);
	
	-- release control if we should (for player control)
	if should_release then
		self.uc:release_control();
	end;
end;









----------------------------------------------------------------------------
---	@section Combat Status
----------------------------------------------------------------------------


--- @function is_under_attack
--- @desc Returns true if the unit is under missile attack, in melee, or has casualties since the last time <code>is_under_attack</code> was called. Designed to be called repeatedly.
--- @r boolean is under attack
function script_unit:is_under_attack()
	local unit = self.unit;
	
	return unit:is_under_missile_attack() or unit:is_in_melee() or self:has_taken_casualties(0, true);
end;


--- @function is_in_melee
--- @desc Returns true if the unit is in melee. This is an unembellished wrapper for an underlying code function.
--- @r boolean is in melee
function script_unit:is_in_melee()	
	return self.unit:is_in_melee();
end;








----------------------------------------------------------------------------
--	Patrol Manager interface
----------------------------------------------------------------------------

--	sets the current patrol manager on this sunit. For internal use by patrol manager script
function script_unit:set_current_patrol(pm)
	if is_patrolmanager(pm) then
		self.current_patrol = pm;
	else
		script_error(self.name .. " ERROR: set_current_patrol() called but supplied object is not a patrol manager");
	end;
end;


--	stops the current patrol manager applying to this sunit
function script_unit:stop_current_patrol()
	if self.current_patrol and is_patrolmanager(self.current_patrol) and self.current_patrol.is_running then
		self.current_patrol:stop();
	end;
end;








----------------------------------------------------------------------------
---	@section Orders
--- @desc Many of the functions in this section just wrap the function provided by code on the unitcontroller interface with no embellishments - by wrapping it here, however, access to it can be provided at the @script_units level, so a scriptunits collection can be told to stop with one call to @script_unit:halt, for example.
----------------------------------------------------------------------------


--- @function halt
--- @desc Instructs the scriptunit to halt. This is an unembellished wrapper for an underlying code function.
function script_unit:halt()
	self.uc:halt();
end;


--- @function celebrate
--- @desc Instructs the scriptunit to celebrate. This is an unembellished wrapper for an underlying code function.
function script_unit:celebrate()
	self.uc:start_celebrating();
end;

--- @function taunt
--- @desc Instructs the scriptunit to taunt. This is an unembellished wrapper for an underlying code function.
function script_unit:taunt()
	self.uc:start_taunting();
end;


--- @function play_sound_charge
--- @desc Instructs the scriptunit to play a charge sound. This is an unembellished wrapper for an underlying code function.
function script_unit:play_sound_charge()
	self.unit:trigger_sound_charge();
end;


--- @function play_sound_taunt
--- @desc Instructs the scriptunit to play a taunt sound. This is an unembellished wrapper for an underlying code function.
function script_unit:play_sound_taunt()
	self.unit:trigger_sound_taunt();
end;


function script_unit:play_vo(sound)
	if not is_battlesoundeffect(sound) or not sound:is_valid() then
		script_error(self.name .. ":play_vo() called but supplied sound [" .. tostring(sound) .. "] is not a valid battle sound effect object");
		return false;
	end;
	
	sound:playVO(self.unit);
end;


--- @function deploy_reinforcement
--- @desc Instructs the scriptunit to deploy as a reinforcement if it can.
--- @p [opt=true] boolean should deploy
function script_unit:deploy_reinforcement(value)
	-- Todo: remove this flag
	if value then
		self.deployed_as_reinforcement_count = self.deployed_as_reinforcement_count + 1;
		self.unit:deploy_reinforcement(true);
	end;
end;


--- @function change_behaviour_active
--- @desc Sets a supplied behaviour active on the unit or not. This is an unembellished wrapper for an underlying code function. This is the main mechanism for turning on/turning off certain unit behaviours such as fire at will, skirmish etc. Current list of behaviours includes, but may not be limited to the following:
--- @desc <i>"defend", "dismount", "fire_at_will", "skirmish", "change_formation_spacing", "drop_siege_equipment", "release_animals", "disembark_from_ship", "board_ship"</i>
--- @p string behaviour name
--- @p boolean activate
function script_unit:change_behaviour_active(behaviour, value, should_release)
	self.uc:change_behaviour_active(behaviour, value);
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function withdraw
--- @desc Instructs the specified unit to withdraw. This is an unembellished wrapper for an underlying code function.
--- @p boolean should run
function script_unit:withdraw(should_run)
	self.uc:withdraw(should_run);
end;


--- @function set_melee_mode
--- @desc Activates or deactivates melee mode. 
--- @p [opt=true] boolean activate, Should activate melee mode.
--- @p [opt=false] boolean release control, Release script control after setting melee mode. Set this to true if the unit is under player control.
function script_unit:set_melee_mode(value, should_release)
	self.uc:melee(value);
	if should_release then
		self.uc:release_control();
	end;
end;



--- @function set_stat_attribute
--- @desc Enables or disables a unit attribute for the unit. Valid attribute keys are listed in the @"battle_unit:Unit Attributes" section of this documentation.
--- @p @string attribute key
--- @p @boolean enable/disable
function script_unit:set_stat_attribute(attribute, enable)
	if not is_string(attribute) then
		script_error(self.name .. " ERROR: set_stat_attribute() called but supplied attribute [" .. tostring(attribute) .. "] is not a string");
		return false;
	end;

	if not is_boolean(enable) then
		script_error(self.name .. " ERROR: set_stat_attribute() called but supplied enable flag [" .. tostring(enable) .. "] is not a boolean");
		return false;
	end;

	self.unit:set_stat_attribute(attribute, enable);
end;








----------------------------------------------------------------------------
---	@section Enabling and Visibility
----------------------------------------------------------------------------


--- @function set_enabled
--- @desc Sets the unit to be enabled and visible if <code>true</code> is supplied as an argument, or disabled and invisible if <code>false</code> is supplied. The second argument forces the UI to refresh the unit card's visibility, but this only needs to be set to <code>true</code> in certain specific circumstances.
--- @desc The third argument, if set to <code>true</code> or <code>false</code>, will also set that unit to contribute to the army strength or not depending upon the value supplied. If no value is supplied here then enabled units will contribute to army strength whereas disabled units will not.
--- @p [opt=true] @boolean enabled
--- @p [opt=false] @boolean force unit card update
--- @p [opt=nil] @boolean unit contributes to army strength
function script_unit:set_enabled(enabled, update_card_existence, unit_contributes_to_army_strength)
	local uc = self.uc;
	if enabled == false and self.is_enabled then
		uc:set_invisible_to_all(true);
		uc:change_enabled(false);
		self.is_enabled = false;
	elseif enabled and not self.is_enabled then
		uc:set_invisible_to_all(false);
		uc:change_enabled(true);
		self.is_enabled = true;
	end;

	if update_card_existence then
		uc:update_card_existance_on_HUD();
	end;

	if unit_contributes_to_army_strength ~= nil then
		uc:set_contributes_to_army_strength(unit_contributes_to_army_strength);
	end;
end;


--- @function set_always_visible
--- @desc Sets the unit to be always visible, according to the rules of the terrain visibility system.
--- @p [opt=true] boolean always visible
function script_unit:set_always_visible(value)
	if value == false then
		self.uc:set_always_visible_to_all(false);
	else
		self.uc:set_always_visible_to_all(true);
	end;
end;

--- @function set_always_visible_no_hidden
--- @desc Sets the unit to be always visible, doesn't affect hidden by forest / abilities
--- @p [opt=true] boolean always visible
function script_unit:set_always_visible_no_hidden(value)
	if value == false then
		self.uc:set_always_visible_no_hidden_to_all(false);
	else
		self.uc:set_always_visible_no_hidden_to_all(true);
	end;
end;

--- @function set_always_visible_no_leave_battle
--- @desc Sets the unit to be always visible, doesn't affect leaving battle
--- @p [opt=true] boolean always visible
function script_unit:set_always_visible_no_leave_battle(value)
	if value == false then
		self.uc:set_always_visible_no_leave_battle_to_all(false);
	else
		self.uc:set_always_visible_no_leave_battle_to_all(true);
	end;
end;

--- @function set_always_visible_no_hidden_no_leave_battle
--- @desc Sets the unit to be always visible, doesn't affect hidden by forest / abilities  doesn't affect leaving battle
--- @p [opt=true] boolean always visible
function script_unit:set_always_visible_no_hidden_no_leave_battle(value)
	if value == false then
		self.uc:set_always_visible_no_hidden_no_leave_battle_to_all(false);
	else
		self.uc:set_always_visible_no_hidden_no_leave_battle_to_all(true);
	end;
end;


--- @function mark_as_ally
--- @desc Makes player unit look like ally (for script where gradually give units in tutorials). This is an unembellished wrapper for an underlying code function.
--- @p boolean mark as ally
function script_unit:mark_as_ally(value)
	self.unit:mark_as_ally(value);
end;


--- @function is_hidden
--- @desc Returns true if the unit is hidden in grass/forests etc. This is an unembellished wrapper for an underlying code function. Returned result is not related to the terrain visibility system, which came later than this code function, so a unit may not be hidden (according to this result returned by this function) but may still not be visible to its enemy - check also @script_unit:is_visible_to_enemy.
--- @r boolean is hidden
function script_unit:is_hidden()
	return self.unit:is_hidden();
end;


--- @function set_invisible_to_all
--- @desc Makes the unit invisible. This is an unembellished wrapper for an underlying code function.
--- @p boolean is hidden
function script_unit:set_invisible_to_all(visible, update_ui)
	return self.uc:set_invisible_to_all(visible, update_ui);
end;


--- @function is_visible_to_enemy
--- @desc Returns true if this unit is visible to its enemy, by the rules of the visibility system. Note that the unit may be visible according to the visibility system, but may still be hidden in forests or tall grass - check @script_unit:is_hidden.
--- @p boolean is visible
function script_unit:is_visible_to_enemy()
	return is_visible(self.unit, bm:alliances():item(self.enemy_alliance_num));
end;








----------------------------------------------------------------------------
---	@section Script Control
--- @desc These functions explicitly instruct script to take or release control of the subject unit. A unit under script control is removed from the player's control or from general AI control, but may still be controlled by an ai_planner (or @script_ai_planner). Note also that giving orders to a unit with a unitcontroller will usually also take control of that unit.
----------------------------------------------------------------------------


--- @function take_control
--- @desc Takes script control of this unit.
function script_unit:take_control()
	return self.uc:take_control();
end;


--- @function release_control
--- @desc Releases script control of the subject unit.
function script_unit:release_control()
	return self.uc:release_control();
end;










----------------------------------------------------------------------------
---	@section Ammo and Fatigue
----------------------------------------------------------------------------


--- @function modify_ammo
--- @desc Modifies this unit's ammo to a specified unary proportion of its starting value.
--- @p number proportion, Desired proportion of starting ammo. Supply 1 to set the ammo back to its starting value, 0.5 to half etc. Values of greater than one are semi-supported - the command will work, but any ammo bars on the UI will show as full until the unit's ammo value drops below its starting value.
function script_unit:modify_ammo(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR! modify_ammo() called but specified quantity [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.unit:set_current_ammo_unary(value);
end;


--- @function refill_ammo
--- @desc Modifies this unit's ammo to a specified unary proportion of its starting value, but only if it has less than the specified amount.
--- @p number proportion, Desired proportion of starting ammo. Supply 1 to set the ammo back to its starting value, 0.5 to half etc. Values of greater than one are semi-supported - the command will work, but any ammo bars on the UI will show as full until the unit's ammo value drops below its starting value.
function script_unit:refill_ammo(value)
	if not is_number(value) or value <= 0 then
		script_error(self.name .. " ERROR: refill_ammo() called but specified quantity [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	local starting_ammo = self.unit:starting_ammo();
	
	if starting_ammo > 0 and (self.unit:ammo_left() / starting_ammo) < value then
		self.unit:set_current_ammo_unary(value);
	end;
end;


--- @function grant_infinite_ammo
--- @desc Grants this unit infinite ammo by refilling ammo every 5 seconds.
function script_unit:grant_infinite_ammo()
	local starting_ammo = self.unit:starting_ammo();
	
	if starting_ammo > 0 then
		bm:repeat_callback(
			function()
				self.unit:set_current_ammo_unary(1);
			end,
			5000,
			"grant_infinite_ammo"
		);
	end;
end;


--- @function refresh
--- @desc Sets this unit to 1/10th its current fatigue level, and tops its ammo back to full.
--- @p [opt=false] boolean should release, Release script control of the unit after refreshing. Set this to <code>true</code> if the unit is under player control.
function script_unit:refresh(should_release)
	self.unit:set_current_ammo_unary(1);
	self.uc:change_fatigue_amount(0.1);
	
	if should_release then
		self.uc:release_control();
	end;
end;


--- @function cache_ammo
--- @desc Caches this unit's current ammunition level.
function script_unit:cache_ammo()
	self.cached_ammo = self.unit:ammo_left();
end;


--- @function restore_cached_ammo
--- @desc Restores this unit's ammunition level to the value previously cached with @script_unit:cache_ammo.
function script_unit:restore_cached_ammo()
	if not self.cached_ammo then
		script_error(self.name .. " ERROR: restore_cached_ammo() called but no cached ammo amount set - call cache_ammo() first");
		return false;
	end;
	
	local starting_ammo = self.unit:starting_ammo();
	
	if starting_ammo > 0 then
		self.unit:set_current_ammo_unary(self.cached_ammo / self.unit:starting_ammo());
	end;
end;











----------------------------------------------------------------------------
---	@section Health and Invincibility
----------------------------------------------------------------------------


--- @function cache_health
--- @desc Caches the proportion of the scriptunit still alive, so that it can be queried later with @script_unit:has_taken_casualties.
function script_unit:cache_health(under_attack_check)
	if under_attack_check then
		self.cached_hp_for_under_attack_check = self:unary_hitpoints();
	else
		self.cached_hp = self:unary_hitpoints();
	end;
end;


--- @function has_taken_casualties
--- @desc Compares the scriptunits current casualties with that when it was previously cached with @script_unit:cache_health, and returns true if they're different.
--- @p [opt=0] number tolerance, Tolerance value. The casualties values is expressed internally as a unary value (between 0 and 1), so this should be expressed in a similar manner. Therefore a tolerance of 0.1 would allow for 10% casualties (of the original number of soldiers in the unit) more than when previously cached before returning true.
--- @r boolean has taken casualties
function script_unit:has_taken_casualties(tolerance, under_attack_check)
	if is_nil(tolerance) then
		tolerance = 0;
	elseif not is_number(tolerance) then
		script_error("ERROR: has_taken_casualties() called but supplied tolerance [" .. tostring(tolerance) .. "] is not a number or nil");
		return false;
	end;	
	
	local cached_hp = self.cached_hp;
	
	if under_attack_check then
		cached_hp = self.cached_hp_for_under_attack_check;
		
		if not cached_hp then
			self:cache_health(true);
			return false;
		end;
		
	elseif not cached_hp then
		return false;
	end;
	
	return (self:unary_hitpoints() < cached_hp - tolerance);
end;


--- @function unary_hitpoints
--- @desc Returns this unit's hitpoints as a unary of its initial value. If the shattered-considered-dead flag is set and the unit is shattered (or it's routing and has left the field), then 0 is returned.
--- @p [opt=false] shattered considered dead
--- @r @number unary hitpoints
function script_unit:unary_hitpoints(shattered_considered_dead)
	if shattered_considered_dead and (self.unit:is_shattered() or (self.unit:is_routing() and not self.unit:is_valid_target())) then
		return 0;
	end;

	return self.unit:unary_hitpoints();
end;


--- @function max_casualties
--- @desc Sets the maximum number of casualties that this unit can take. If the unit's hitpoints drop below the specified unary value, the unit is made invincible so that it can no longer take casualties (note that it may still rout). Exception scriptunits can be set, so that proximity to those @script_unit or @script_units disables this invincibility (allow certain units to be perceived to charge in and 'save the day').
--- @p number unary proportion, Unary proportion. A value of 0.5 would allow the unit to take 50% casualties before becoming invincible (note that in extreme scenarios the unit may still die, if one-shotted by something for example).
--- @p_long_desc Call <code>max_casualties</code> with a proportion value of 0 to disables any previous <code>max_casualties</code> monitor on this unit.
--- @p [opt=false] boolean should release, Set to true to release script control of this unit after <code>max_casualties</code> makes a change. Set this primarily if the unit is under player control.
--- @p [opt=nil] @script_units exception sunit(s), Exception @script_unit or @script_units collection. If this unit comes within 30m of any unit specified here, the <code>max_casualties</code> monitor will temporarily cease and they will become vulnerable to casualties.
--- @p_long_desc The monitor will resume and this unit will (potentially) regain invincibility when this unit moves more than 40m away from any unit specified as an exception.
--- @p <opt=false> boolean silent mode, Activate silent mode. <code>max_casualties</code> writes output by default, supply <code>true</code> here to suppress this.
function script_unit:max_casualties(proportion, should_release, exception_sunits, silent)
	local should_release = should_release or false;
	
	local watchname = self.name .. "_casualty_watch";

	bm:remove_process(watchname);
	
	self.uc:set_invincible(false);
	self.max_casualties_unit_invulnerable = false;
	
	if should_release then
		self.uc:release_control();
	end;
	
	if proportion == 0 then
		return;
	end;
	
	bm:watch(
		function()
			return self:unary_hitpoints() < proportion 
		end, 
		0, 
		function()
			-- only generate this output when the silent flag is set - it should only be set when the subject unit moves far away from the exception units
			if not silent then
				bm:out("Making " .. self.name .. " invincible with " .. tostring(self.unit:number_of_men_alive()) .. " out of " .. tostring(self.unit:initial_number_of_men()) .. " remaining");
			end;
			self.uc:set_invincible(true);
			self.max_casualties_unit_invulnerable = true;
			
			if should_release then
				self.uc:release_control()
			end;
			
			
			if is_scriptunit(exception_sunits) or is_scriptunits(exception_sunits) then
				local distance_threshold = 30;
				local ext_distance_threshold = distance_threshold + 10;
			
				-- if we have a collection of exception sunits, then watch the distance from this unit to those - if they come close, remove the subject unit's invulnerability
				bm:watch(
					function()
						return is_close_to_position(exception_sunits, self.unit:position(), distance_threshold);
					end,
					0,
					function()
						bm:out("Making " .. self.name .. " un-invincible due to proximity with exception sunits");
					
						self.uc:set_invincible(false);
						self.max_casualties_unit_invulnerable = false;
						
						if should_release then
							self.uc:release_control();
						end;
						
						-- watch for this sunit moving further away from the exception sunits again
						-- if this happens, start the whole process again (with the silent flag set)
						bm:watch(
							function()
								return not is_close_to_position(exception_sunits, self.unit:position(), ext_distance_threshold);
							end,
							0,
							function()
								bm:out("Making " .. self.name .. " invincible again as gap has opened to exception sunits");
								self:max_casualties(proportion, should_release, exception_sunits, true);
							end,
							watchname
						);
					end,
					watchname
				);
			end;
		end, 
		watchname
	);
	bm:watch(function() return is_routing_or_dead(self.unit) end, 0, function() bm:remove_process(watchname) end, watchname);
end;


-- internal function to cancel max casualties
function script_unit:cancel_max_casualties()
	self.max_casualties_unit_invulnerable = false;
	bm:remove_process(self.name .. "_casualty_watch");
end;


--- @function set_invincible
--- @desc Makes the subject unit invincible. This wraps an underlying code function, and also cancels any running process started for this unit with @script_unit:max_casualties or @script_unit:set_invincible_for_time_proportion.
--- @p boolean set invincible
function script_unit:set_invincible(value)
	self:cancel_max_casualties();
	self:cancel_set_invincible_for_time_proportion()
	self.uc:set_invincible(value);
end;


--- @function set_invincible_for_time_proportion
--- @desc Makes the subject unit invincible a proportion of the time. The intended effect is to slow the rate at which the unit receives casualties. Invincibility is toggled on and off over a five second interval, with the unit being invincible the specified proportion of time. The proportion is set as a unary @number, so supplying a value of <code>0.8</code> would make the unit invincible for four seconds out of every five.
--- @desc Set a value of 0 to turn off any previous invincibility set with this function.
--- @p @number time proportion, Unary (0-1) time proportion over which this unit should be invincible.
--- @p [opt=false] @boolean should release, Instructs the function to release script control of the unit after setting it to be invincible or otherwise. Set this to <code>true</code> if the scriptunit is player-controlled.
function script_unit:set_invincible_for_time_proportion(time_proportion, should_release)

	if not is_number(time_proportion) then
		script_error(self.name .. " ERROR: set_invincible_for_time_proportion() called but supplied time proportion .. [" .. tostring(time_proportion) .. "] is not a number");
		return false;
	end;
	
	-- clamp upper value of time_proportion
	if time_proportion > 1 then
		time_proportion = 1;
	end;
	
	-- remove any previous processes that affect invincibility
	self:cancel_set_invincible_for_time_proportion();
	
	-- cancel this process if a proportion <= 0 has been set
	if time_proportion <= 0 then
		if not self.max_casualties_unit_invulnerable then
			self.uc:set_invincible(false);
			if should_release then
				self.uc:release_control();
			end;
		end;
		return;
	end;
	
	local callback_name = self.name .. "_set_invincible_for_time_proportion";
	
	-- function to call at the start of each five second interval
	local function to_repeat()
		-- make the unit invincible
		self.uc:set_invincible(true);
		if should_release then
			self.uc:release_control();
		end;
		
		if time_proportion < 1 then
			-- make the unit vulnerable again after a period
			bm:callback(
				function()
					if not self.max_casualties_unit_invulnerable then
						self.uc:set_invincible(false);
						if should_release then
							self.uc:release_control();
						end;
					end;
				end,
				time_proportion * 5000,
				callback_name
			);
		end;
	end;
	
	bm:repeat_callback(
		to_repeat,
		5000,
		callback_name
	);
	
	local invincible_time_slice = time_proportion * 5000;
end;


-- internal function to cancel set invincible for time proportion processes
function script_unit:cancel_set_invincible_for_time_proportion()
	bm:remove_process(self.name .. "_set_invincible_for_time_proportion");
end;







----------------------------------------------------------------------------
---	@section Morale and Invincibility
----------------------------------------------------------------------------


--- @function fearless_until_casualties
--- @desc Prevents this unit from routing until it takes a certain proportion of casualties. If a proportion of 0 is supplied then any previous monitor set up with <code>fearless_until_casualties</code> is cancelled and the unit is allowed to rout.
--- @p unary proportion, Proportion of unit at which it may rout. Value should be expressed as a unary e.g. 0.5 = 50% casualties.
--- @p [opt=false] boolean should release,  Set to true to release script control of this unit after <code>fearless_until_casualties</code> makes a change. Set this primarily if the unit is under player control.
function script_unit:fearless_until_casualties(proportion, should_release)
	local should_release = should_release or false;
	
	local watchname = self.name .. "_fearless_watch";

	bm:remove_process(watchname);
	
	if is_routing_or_dead(self.unit) then
		return;
	end;
	
	if proportion == 0 then
		self.uc:morale_behavior_default();
		return;
	end;
	
	self.uc:morale_behavior_fearless();
	
	if should_release then
		self.uc:release_control();
	end;
	
	bm:watch(
		function()
			return self:unary_hitpoints() < proportion 
		end, 
		0, 
		function()
			bm:out("Allowing " .. self.name .. " to rout with " .. tostring(self.unit:number_of_men_alive()) .. " out of " .. tostring(self.unit:initial_number_of_men()) .. " remaining");
			self.uc:morale_behavior_default();
			if should_release then
				self.uc:release_control()
			end;
		end, 
		watchname
	);
end;


--- @function rout_on_casualties
--- @desc Forces this unit to rout when it reaches a certain proportion of casualties. If a proportion of 0 is supplied then any previous monitor set up with <code>rout_on_casualties</code> is cancelled.
--- @p @number unary proportion, Proportion of unit hitpoints remaining at which it routs. Value should be expressed as a unary e.g. 0.6 = unit will rout when its health gets below 60%.
--- @p [opt=false] @boolean set invincible, Makes the unit invincible when it routs, so that it's guaranteed to survive.
function script_unit:rout_on_casualties(unary_proportion, set_invincible)
	local watchname = self.name .. "_rout_on_casualties";
	
	bm:remove_process(watchname);

	if not is_number(unary_proportion) or unary_proportion < 0 or unary_proportion > 1 then
		script_error(self.name .. " rout_on_casualties() ERROR: supplied unary proportion [" .. tostring(unary_proportion) .. "] is not a number between 0 and 1");
		return false;
	end;
	
	if unary_proportion == 0 then
		bm:out(self.name .. " rout_on_casualties() WARNING: supplied unary proportion is 0");
		return;
	end;

	local function execute_rout()
		bm:remove_process(watchname);

		if set_invincible then
			if self:unary_hitpoints() < unary_proportion
			then
				self.unit:heal_hitpoints_unary(unary_proportion - self:unary_hitpoints());
			end;
			self.uc:set_invincible(true);
		end;
		self.uc:morale_behavior_rout();
	end;

	bm:watch(
		function() return self:unary_hitpoints() < unary_proportion end,
		0,
		function()
			bm:out(self.name .. ":rout_on_casualties() is routing unit as health "..tostring(self:unary_hitpoints()) .." is below [" .. tostring(unary_proportion) .. "]");
			execute_rout();
		end,
		watchname
	);
	
	bm:watch(
		function() return is_routing_or_dead(self.unit) end,
		0,
		function() 
			bm:out(self.name .. ":rout_on_casualties() removed, unit is routing or dead");
			execute_rout();
		end,
		watchname
	);
end;


--- @function invincible_if_standing
--- @desc Makes the subject unit invincible/fearless if it's not already routing.
--- @p [opt=false] boolean should release,  Set to true to release script control of this unit after <code>invincible_if_standing</code> makes a change. Set this primarily if the unit is under player control.
function script_unit:invincible_if_standing(should_release)
	if not is_routing_or_dead(self.unit) then
		self.uc:set_invincible(true);
		self.uc:morale_behavior_fearless();
		
		if should_release then
			self.uc:release_control();
		end;
	end;	
end;


--- @function prevent_rallying_if_routing
--- @desc Prevents the subject unit from rallying if it's already routing. Supply <code>true</code> as a single argument to start a monitor that will continually poll whether this unit is routing, and prevent it
--- @p [opt=false] boolean check perpetually, Check perpetually. If false or no value is supplied here, the function will only check the unit's routing state once, at the time the function is called. If the unit is not routing at this time, it may later rout and subsequently rally.
--- @p_long_desc If true is supplied instead, the function sets up a monitor that will continually poll the unit's routing status and, when found to be routing, prevents it from rallying at that time.
--- @p [opt=false] boolean shattered only, Only count shattered units
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
function script_unit:prevent_rallying_if_routing(perpetual, shattered_only, permit_rampaging)

	bm:out(self.name .. ":prevent_rallying_if_routing() called, flags: perpetual " .. tostring(perpetual) .. " shattered only: ".. tostring(shattered_only).." permit rampaging: "..tostring(permit_rampaging));
	
	if perpetual then
		-- continually monitor the unit's routing state and prevent it from rallying
		bm:watch(
			function()
				return is_routing_or_dead(self.unit, shattered_only, permit_rampaging);
			end,
			0,
			function()
				bm:out(self.name .. " being prevented from rallying !");
				self.uc:morale_behavior_rout();
			end,		
			self.name .. "_prevent_rallying_if_routing"
		);
	else
		-- only check once
		if is_routing_or_dead(self.unit, shattered_only, permit_rampaging) then
			self.uc:morale_behavior_rout();
		end;
	end;
end;


--- @function stop_prevent_rallying_if_routing
--- @desc Stops any running monitor started by @script_unit:prevent_rallying_if_routing.
function script_unit:stop_prevent_rallying_if_routing()
	bm:remove_process(self.name .. "_prevent_rallying_if_routing");
end;


--- @function morale_behavior_fearless
--- @desc Sets this unit to be fearless/unroutable. This is an unembellished wrapper for an underlying code function.
function script_unit:morale_behavior_fearless()
	self.uc:morale_behavior_fearless();
end;


--- @function morale_behavior_rout
--- @desc Causes this unit to instantly rout. This is an unembellished wrapper for an underlying code function.
function script_unit:morale_behavior_rout()
	self.uc:morale_behavior_rout();
end;


--- @function morale_behavior_default
--- @desc Causes this unit to be subject to normal morale. This is an unembellished wrapper for an underlying code function.
function script_unit:morale_behavior_default()
	self.uc:morale_behavior_default();
end;


--- @function morale_behavior_fearless_if_standing
--- @desc Makes the subject unit fearless if it's not already routing.
--- @p [opt=false] boolean should release, Set to true to release script control of this unit after <code>morale_behavior_fearless_if_standing</code> makes a change. Set this primarily if the unit is under player control.
function script_unit:morale_behavior_fearless_if_standing(should_release)
	if not is_routing_or_dead(self.unit) then
		self.uc:morale_behavior_fearless();
		
		if should_release then
			self.uc:release_control();
		end;
	end;	
end;


--- @function morale_behavior_default_if_standing
--- @desc Makes the subject unit fearless if it's not already routing.
--- @p [opt=false] boolean should release, Set to true to release script control of this unit after <code>morale_behavior_default_if_standing</code> makes a change. Set this primarily if the unit is under player control.
function script_unit:morale_behavior_default_if_standing(should_release)
	if not is_routing_or_dead(self.unit) then
		self.uc:morale_behavior_default();
		
		if should_release then
			self.uc:release_control();
		end;
	end;	
end;


--- @function hide_unbreakable_in_ui
--- @desc Calls @battle_unitcontroller:hide_unbreakable_in_ui to prevent or allow the UI to show that this unit is unbreakable. This is useful for scripted content which is altering whether a unit can rout or not but doesn't want this to be reflected on the user interface.
--- @p @boolean hide unbreakable state
function script_unit:hide_unbreakable_in_ui(value)
	self.uc:hide_unbreakable_in_ui(value);
end;











----------------------------------------------------------------------------
---	@section Killing
----------------------------------------------------------------------------


--- @function kill
--- @desc Instantly kills this unit.
--- @p [opt=false] boolean should disappear, Set to true to make the unit instantly disappear, instead of appearing to drop dead on the spot.
function script_unit:kill(should_disappear)
	self.uc:kill();
	if should_disappear then
		self:set_enabled(false);
	end;
end;


--- @function kill_proportion
--- @desc Instantly kills a unary proportion of this unit.
--- @p number proportion, Proportion to kill, expressed as a unary value (e.g. 0.5 = 50% of the unit's starting number of soldiers die).
--- @p [opt=0] number preserve proportion, Prevents kill_proportion from reducing the strength of the unit below a specified unary proportion.
--- @p [opt=false] boolean hide bodies, Hides the bodies.
function script_unit:kill_proportion(proportion, preserve, hide_bodies)
	local unit = self.unit;
	
	if not is_number(proportion) or proportion < 0 or proportion > 1 then
		script_error("ERROR: kill_proportion() called but supplied parameter " .. tostring(proportion) .. " is not a number between 0 and 1!");
		return false;
	end;
	
	preserve = preserve or false;
	hide_bodies = hide_bodies or false;
	local proportion_to_kill = proportion;
	
	
	-- preserve flag prevents kill_unit_proportion from reducing unit strength to below supplied proportion
	if preserve_proportion then
		proportion_to_kill = proportion - (1 - self:unary_hitpoints());
	end;
	
	-- unit:kill_number_of_men(unit:initial_number_of_men() * proportion_to_kill, hide_bodies);
	unit:reduce_hitpoints_unary(proportion_to_kill, hide_bodies);
end;


--- @function kill_proportion_over_time
--- @desc Kills a unary proportion of this unit over a specified time period in ms.
--- @p number proportion, Proportion to kill, expressed as a unary value (e.g. 0.5 = 50% of the unit's starting number of soldiers die).
--- @p number duration, Duration in ms over which to kill soldiers.
--- @p [opt=false] boolean stop on rout, Stops the function from killing any more soldiers if the unit routs during the process.
function script_unit:kill_proportion_over_time(proportion, duration, stop_on_rout)

	out(self.name .. " kill_proportion_over_time() called, proportion is [" .. tostring(proportion) .. "] and time is [" .. tostring(duration) .. "]");
	
	if not is_number(proportion) or proportion <= 0 or proportion > 1 then
		script_error(self.name .. " ERROR: kill_proportion_over_time() called but supplied proportion [" .. tostring(proportion) .. "] is not a number greater than 0 and less than or equal to 1");
		return false;
	end;
	
	if not is_number(duration) or duration <= 0 then
		script_error(self.name .. " ERROR: kill_proportion_over_time() called but supplied duration [" .. tostring(duration) .. "] is not a number greater than 0");
		return false;
	end;
	
	local unit = self.unit;
	
	local duration_step = 200;
	
	local total_men_to_kill = unit:initial_number_of_men() * proportion;
	
	-- divide by zero failsafe
	if total_men_to_kill == 0 then
		return;
	end;
	
	local number_to_kill_per_step = total_men_to_kill * duration_step / duration;
	
	-- work out a duration step that actually means we'll be killing men each time we try
	if number_to_kill_per_step  < 1 then
		duration_step = math.floor(duration / total_men_to_kill);
		number_to_kill_per_step = 1;
	end;
	
	bm:repeat_callback(
		function()
			if stop_on_rout and is_routing_or_dead(unit) then
				self:stop_kill_proportion_over_time();
				return false;
			end;
		
			unit:kill_number_of_men(number_to_kill_per_step, false);
		end,
		duration_step, 
		self.name .. "_kill_proportion_over_time"
	);
end;


--- @function stop_kill_proportion_over_time
--- @desc Stops a running process started by @script_unit:kill_proportion_over_time.
function script_unit:stop_kill_proportion_over_time()
	bm:remove_process(self.name .. "_kill_proportion_over_time");
end;









----------------------------------------------------------------------------
---	@section Enemy Alliance
----------------------------------------------------------------------------


--- @function get_enemy_alliance_num
--- @desc Gets the enemy alliance number.
--- @r @number enemy alliance number
function script_unit:get_enemy_alliance_num()
	return self.enemy_alliance_num;
end;


--- @function get_enemy_alliance
--- @desc Gets the enemy alliance object.
--- @r @battle_alliance enemy alliance
function script_unit:get_enemy_alliance()
	return bm:alliances():item(self.enemy_alliance_num);
end;









----------------------------------------------------------------------------
---	@section Highlight Unit Card
----------------------------------------------------------------------------


--- @function highlight_unit_card
--- @desc Pulses a highlight effect on the unit card associated with this scriptunit.
--- @p boolean should highlight, Set to <code>true</code> to turn the highlight effect on, <code>false</code> to turn it off.
--- @p [opt=5] number pulse strength, Sets the strength of the pulse effect. A higher supplied value leads to a more pronounced pulse effect. The default value is 5.
--- @p [opt=false] boolean force highlight, Overrides the disabling of help page highlighting with @battle_ui_manager:set_help_page_link_highlighting_permitted. Set this to true if the script explicitly wants to highlight the UI cards when help page link highlighting is disabled (useful in tutorials).
function script_unit:highlight_unit_card(value, pulse_strength, force_highlight)
	
	if not buim:get_help_page_link_highlighting_permitted() and not force_highlight then
		return;
	end;

	local uic_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	local unique_ui_id = tostring(self.unit:unique_ui_id());
	
	if uic_parent and uic_parent:Visible() then	
		for i = 0, uic_parent:ChildCount() - 1 do
			local uic_card = UIComponent(uic_parent:Find(i));
			
			if uic_card:Id() == unique_ui_id then				
				local pulse_strength_to_use = pulse_strength or buim:get_panel_pulse_strength();
				
				pulse_uicomponent(uic_card, value, pulse_strength_to_use, false, "selected");
				pulse_uicomponent(uic_card, value, pulse_strength_to_use, false, "selected_hover");
				pulse_uicomponent(uic_card, value, pulse_strength_to_use, false, "active");
				pulse_uicomponent(uic_card, value, pulse_strength_to_use, false, "hover");
				
				local uic_health_frame = find_uicomponent(uic_card, "health_frame");
				if uic_health_frame and uic_health_frame:Visible() then
					pulse_uicomponent(uic_health_frame, value, pulse_strength_to_use);
				end;
				
				local uic_ammo = find_uicomponent(uic_card, "Ammunition");
				if uic_ammo and uic_ammo:Visible() then
					pulse_uicomponent(uic_ammo, value, pulse_strength_to_use);
				end;
				
				local uic_experience = find_uicomponent(uic_card, "experience");
				if uic_experience and uic_experience:Visible() then
					pulse_uicomponent(uic_experience, value, pulse_strength_to_use);
				end;
				
				break;
			end;
		end;
		
		if value then
			buim:register_unhighlight_callback(function() self:highlight_unit_card(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
end;









----------------------------------------------------------------------------
---	@section Ping Icons
----------------------------------------------------------------------------


--- @function add_ping_icon
--- @desc Adds a ping icon above the unit, optionally for a duration.
--- @p [opt=8] number icon_type Type of icon to add. This is a numeric index.
--- @p [opt=nil] number duration, Duration in ms.
function script_unit:add_ping_icon(icon_type, duration)

	if duration and not (is_number(duration) and duration > 0) then
		script_error(self.name .. " ERROR: add_ping_icon() called duration supplied [" .. tostring(duration) .. "] is not a number > 0 or nil");
		return false;
	end;

	icon_type = icon_type or 8;
	
	-- We create a ping icon that sits on top of unit id that is always preset for a unit. That way it will always stay at correct height over unit, its id and flag.
	local unit_id_parent = find_uicomponent(core:get_ui_root(), "unit_id_holder");
	if unit_id_parent then 
		local unit_id = find_uicomponent(unit_id_parent, tostring(self.unit:unique_ui_id()));
		if unit_id then
			local script_ping_parent = find_uicomponent(unit_id, "script_ping_parent");
			if script_ping_parent then
				local uic_ping_marker = UIComponent(script_ping_parent:CreateComponent(self.name .. "_ping_icon", "ui/battle ui/unit_ping_indicator.twui.xml"));
				uic_ping_marker:SetContextObject(cco("CcoBattleUnit", self.unit:unique_ui_id()));
				self.uic_ping_marker = uic_ping_marker;
				
				-- Set icon
				local icon_child = find_uicomponent(uic_ping_marker, "icon");
				if icon_child then
					local ping_icon_path = common.PingIconPath(icon_type);
					icon_child:SetImagePath(ping_icon_path);
				end;
				
				if is_number(duration) and duration > 0 then
					bm:callback(function() self:remove_ping_icon() end, duration, self.name .. "_remove_ping_icon");
				end;
			end;
		end;
	end;
end;


--- @function remove_ping_icon
--- @desc Removes a ping icon from above the unit added with @script_unit:add_ping_icon.
function script_unit:remove_ping_icon()
	if self.uic_ping_marker then
		bm:remove_process(self.name .. "_remove_ping_icon");
	
		self.uic_ping_marker:TriggerAnimation("destroy");
		self.uic_ping_marker = false;
	end;
end;











----------------------------------------------------------------------------
---	@section Attack Closest Enemy
----------------------------------------------------------------------------


-- Internal implement function for attack_closest_enemy
function script_unit:attack_closest_enemy_impl(enemy_alliance, show_debug_output)
	if is_shattered_or_dead(self.unit) then
		self:stop_attack_closest_enemy("unit is shattered or dead");
	else
		if self.unit:is_valid_target() then
			local enemy_unit = get_closest_standing_unit(enemy_alliance, self.unit:position());
			if enemy_unit then
				if show_debug_output then
					bm:out(self.name .. " at position " .. v_to_s(self.unit:position()) .. " with uuid [" .. self.unit:unique_ui_id() .. "] is attacking closest enemy with uuid [" .. enemy_unit:unique_ui_id() .. "] at position [" .. v_to_s(enemy_unit:position()) .. "]");
				end;
				self.uc:attack_unit(enemy_unit, true, true);
			else
				self:stop_attack_closest_enemy("no enemy units found");
			end;
		else
			if show_debug_output then
				bm:out(self.name .. " at position " .. v_to_s(self.unit:position()) .. " with uuid [" .. self.unit:unique_ui_id() .. "] has been told to attack the closest enemy but is not a valid target - it's probably not yet on the battlefield. Will try again in a short while");
			end;
		end;
	end;
end;


--- @function start_attack_closest_enemy
--- @desc Instructs this scriptunit to attack the closest enemy unit under full script control. This process will continually re-acquire the closest enemy target every interval and instruct the unit to attack. The process repeats until the unit is shattered, dead, or until @script_unit:stop_attack_closest_enemy is called.
--- @p [opt=10000] @number interval, Repeating interval in milliseconds after which the scriptunit re-acquires the closest enemy target.
--- @p [opt=false] @boolean debug, Shows debug output about what this unit is attacking.
function script_unit:start_attack_closest_enemy(interval, show_debug_output)
	if interval then
		if not is_number(interval) or interval < 1 then
			script_error(self.name .. " ERROR: start_attack_closest_enemy() called but supplied interval [" .. tostring(interval) .. "] is not a positive number");
			return false;
		end;
	else
		interval = 10000;
	end;

	self:stop_attack_closest_enemy();
	
	local enemy_alliance = self:get_enemy_alliance();

	bm:repeat_callback(
		function()
			self:attack_closest_enemy_impl(enemy_alliance, show_debug_output);
		end,
		interval,
		self.name .. "_attack_closest_enemy"
	);
	
	self:attack_closest_enemy_impl(enemy_alliance, show_debug_output);
end;


--- @function stop_attack_closest_enemy
--- @desc Stops any running attack closest enemy process that was started with @script_unit:start_attack_closest_enemy. An optional string reason may be supplied which is printed as debug output.
--- @p [opt=nil] @string reason
function script_unit:stop_attack_closest_enemy(reason)
	if reason then
		bm:out(self.name .. " is stopping attack closest enemy behaviour, reason: " .. tostring(reason));
	end;

	bm:remove_process(self.name .. "_attack_closest_enemy");
end;













































----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	SCRIPT_UNITS
--
--- @c script_units Scriptunits
--- @page script_unit
--- @desc A Scriptunits collection is a container for @script_unit objects. There are a couple of advantages to assembling a script_units collection object instead of just a throwing them into a single table:
--- @desc <ul><li>The collection object provides additional functionality that can only be provided on a number of scriptunits (e.g. @script_units:rout_over_time).</li>
--- @desc <li>Calls made to the scriptunits collection that are not recognised as function calls on the collection object are instead passed through and that same call is made on each script unit the collection contains. For example, setting a behaviour active on a scriptunits collection sets it active on all the scriptunits within that collection.</li></ul>
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

script_units = {
	name = "",
	sunit_list = {},
	is_debug = false
};


set_class_custom_type(script_units, TYPE_SCRIPT_UNITS);
set_class_tostring(
	script_units, 
	function(obj)
		return TYPE_SCRIPT_UNITS .. "_" .. obj.name
	end
);


-- allow script units collection to call passthrough functions on each of its script unit objects
set_class_metatable(
	script_units,	
	{
		__index = function(script_units, key)
			-- key doesn't exist in scriptunits
			-- return a function that calls the supplied function on each of the sunit objects in this sunits collection
			return function(sunits, ...)
				for i = 1, #sunits.sunit_list do
					local current_sunit = sunits.sunit_list[i];
					
					field = current_sunit[key];
					
					if type(field) == "function" then
						
						-- call the "key" function on the script_unit base class, with the current_sunit as the first parameter and
						-- the other passed-in parameters as additional parameters. This is the same as calling current_sunit:<key>(...)
						-- (the latter is syntactic sugar for the former)
						script_unit[key](current_sunit, ...);
					else
						script_error(sunits.name .. " ERROR: function [" .. tostring(key) .. "] called but this is not recognised as a function or value provided by script_units or script_unit");
						return false;
					end;
				end;
			end;
		end;
	}
);








----------------------------------------------------------------------------
--- @section Declaration
----------------------------------------------------------------------------

--- @function new
--- @desc Creates a new script units collection.
--- @p string name, Name for this script_units collection. Will be used for debug output.
--- @p ... scriptunits, One or more @script_unit objects to add to the collection. Note that a scriptunit can be a member of multiple script_units collections at the same time.
--- @r script_units
function script_units:new(new_name, ...)	
	-- type check our startup parameters
	if not is_string(new_name) then
		script_error("ERROR: Couldn't create script units, name given [" .. tostring(new_name) .. "] is not a string");
		return false;
	end;
	
	-- set up the script units object
	local su = {};
	
	su.name = "sunits_" .. new_name;

	set_object_class(su, self);

	su.sunit_list = {};
	
	-- add the new sunits if we've been given any
	if arg.n > 0 then
		su:add_sunits(unpack(arg));
	end;
	
	return su;
end;








----------------------------------------------------------------------------
--- @section Debug Mode
----------------------------------------------------------------------------


--- @function set_debug
--- @desc Sets the scriptunits collection into debug mode, for more output.
--- @p [opt=true] boolean debug mode
function script_units:set_debug(value)
	if value == false then
		self.is_debug = false;
	else
		self.is_debug = true;
	end;
end;








----------------------------------------------------------------------------
--- @section Adding and Removing Scriptunits
----------------------------------------------------------------------------


--- @function add_sunits
--- @desc Adds one or more supplied @script_unit objects to this scriptunits collection.
--- @p ... additional script units
function script_units:add_sunits(...)
	local count = 0;
	local output_str = "";
	
	for i = 1, arg.n do
		local current_sunit = arg[i];
		
		if not is_scriptunit(current_sunit) then
			-- if our current object is a table, then assuming it to be a table of sunits and try adding each of them in turn
			if is_table(current_sunit) then
				for j = 1, #current_sunit do
					self:add_sunits(current_sunit[j]);
				end;
			else
				-- our object is not a sunit or a table, so assert
				script_error(self.name .. " WARNING: add_sunits called but element [" .. i .. "] in supplied sunits collection is not a scriptunit but a [" .. tostring(current_sunit) .. "]");
			end;
		else
			if self.is_debug then
				if count == 0 then
					output_str = current_sunit.name;
				else
					output_str = output_str .. "|" .. current_sunit.name;
				end;
				count = count + 1;
			end;
			
			table.insert(self.sunit_list, current_sunit);
		end;
	end;
	
	if self.is_debug then
		if count == 1 then
			bm:out(self.name .. " successfully added " .. count .. " sunit [" .. output_str .. "]");
		else
			bm:out(self.name .. " successfully added " .. count .. " sunits [" .. output_str .. "]");
		end;
	end;
end;


--- @function merge
--- @desc Copies all @script_unit objects associated with a supplied @script_units collection into this script units collection.
--- @p @script_units other script units
function script_units:merge(other_sunits)
	if not validate.is_scriptunits(other_sunits) then
		return false;
	end;

	self:add_sunits(unpack(other_sunits:get_sunit_table()));
end;


--- @function remove_sunit
--- @desc Removes a supplied @script_unit object from this scriptunits collection.
--- @p script_unit scriptunit to remove
function script_units:remove_sunit(sunit, suppress_debug_output)
	for i = 1, #self.sunit_list do
		if self.sunit_list[i] == sunit then
			
			if self.is_debug and not suppress_debug_output then
				bm:out(self.name .. " removing sunit [" .. sunit.name .. "]");
			end;
			
			table.remove(self.sunit_list, i);
			return true;
		end;
	end;
	
	return false;
end;


--- @function remove_sunits
--- @desc Removes one or more supplied @script_unit objects from this scriptunits collection.
--- @p ... script_unit list, scriptunits to remove
function script_units:remove_sunits(...)
	local output_str = "";
	local count = 0;
	
	for i = 1, arg.n do
		local current_sunit = arg[i];
		
		if not is_scriptunit(current_sunit) then
			script_error(self.name .. " WARNING: remove_sunits() called but supplied item " .. i .. " is not a scriptunit but a [" .. tostring(current_sunit) .. "]");
		else
			if self:remove_sunit(current_sunit, true) then
				if self.is_debug then
					if count == 0 then
						output_str = current_sunit.name;
					else
						output_str = output_str .. "|" .. current_sunit.name;
					end;
					count = count + 1;
				end;
			end;
		end;
	end;
	
	if self.is_debug then
		if count == 1 then
			bm:out(self.name .. " successfully removed " .. count .. " sunit [" .. output_str .. "]");
		else
			bm:out(self.name .. " successfully removed " .. count .. " sunits [" .. output_str .. "]");
		end;
	end;
end;










----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function get_sunit_by_name
--- @desc Returns a @script_unit from this script_units collection that matches the supplied reference @number or @string. @nil is returned if no matching script_unit is found.
--- @p value reference, Reference @number or @string.
--- @r @script_unit matching name, or @nil
function script_units:get_sunit_by_name(ref)
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		if sunit_list[i].name == ref then
			return sunit_list[i];
		end;
	end;
end;


--- @function get_sunit_for_unit
--- @desc Returns a @script_unit from this script_units collection that contains the supplied @battle_unit. @nil is returned if no matching script_unit is found.
--- @p @battle_unit unit
--- @r @script_unit matching unit, or @nil
function script_units:get_sunit_for_unit(unit)
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		if sunit_list[i].unit == unit then
			return sunit_list[i];
		end;
	end;
end;


--- @function get_sunit_by_type
--- @desc Returns the first @script_unit in this script_units collection that contains a @battle_unit of the supplied type. @nil is returned if no matching script_unit is found.
--- @p @string unit type, Unit type, from the <code>main_units</code> table.
--- @r @script_unit matching unit, or @nil
function script_units:get_sunit_by_type(type_name)
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		if sunit_list[i].unit:type() == type_name then
			return sunit_list[i];
		end;
	end;
end;


--- @function count
--- @desc Returns the number of @script_unit objects in this script_units collection.
--- @r @number number of units
function script_units:count()
	return #self.sunit_list;
end;


--- @function item
--- @desc Returns the @script_unit in this collection at the supplied index.
--- @p @number index value
--- @r @script_unit
function script_units:item(index)
	local retval = self.sunit_list[index];
	
	if not is_scriptunit(retval) then
		script_error(self.name .. " ERROR: item() called but couldn't find a scriptunit at supplied index [" .. tostring(index) .. "]");
		return false;
	end;
	
	return retval;
end;


--- @function contains
--- @desc Returns whether the script units collection contains the supplied object. Supported object types are @script_unit, @battle_unit and @battle_unitcontroller.
--- @p object object, Object to test - supported types are @script_unit, @battle_unit and @battle_unitcontroller.
--- @r @script_unit
function script_units:contains(obj)
	if is_scriptunit(obj) then
		for i = 1, self:count() do
			if self:item(i) == obj then
				return true;
			end;
		end;

	elseif is_unit(obj) then
		for i = 1, self:count() do
			if self:item(i).unit == obj then
				return true;
			end;
		end;
	
	elseif is_unitcontroller(obj) then
		for i = 1, self:count() do
			if self:item(i).uc == obj then
				return true;
			end;
		end;

	else
		script_error(self.name .. " ERROR: contains() called but supplied object [" .. tostring(obj) .. "] is not a script_unit, a unit or a unitcontroller");
	end;

	return false;
end;


--- @function get_sunit_table
--- @desc Returns the internal table containing all the @script_unit objects in this @script_units collection. Be aware that modifications to this table will also modify this script_units object.
--- @r @table of script_unit objects
function script_units:get_sunit_table()
	return self.sunit_list;
end;


--- @function get_unit_table
--- @desc Returns a table containing all @battle_unit objects contained within this @script_units collection. The table that's returned is built each time this function is called, so be wary of calling this function too often.
--- @r @table of @battle_unit objects
function script_units:get_unit_table()
	local t = {};

	for i = 1, #self.sunit_list do
		table.insert(t, self.sunit_list[i].unit);
	end;
	
	return t;
end;


--- @function filter
--- @desc Returns another scriptunits collection containing all @script_unit objects from the subject collection that pass the supplied test. The test should be supplied as a function that takes a scriptunit parameter and returns a boolean value. Should a call to the function with a specific scriptunit return true, that scriptunit will be added to the returned collection.
--- @p @string name, Name for the returned scriptunits collection
--- @p @function test, Function that takes a scriptunit parameter and returns a boolean value.
--- @p [opt=false] @boolean assert if empty, If set to true, <code>filter</code> triggers a script assert if the returned collection is empty.
--- @p [opt=nil] @number max size, Maximum number of units to add to the returned scriptunit collection.
--- @r @script_units filtered scriptunits collection
function script_units:filter(name, pattern, assert_if_empty, max_size)
	
	if not is_string(name) then
		script_error(self.name .. " ERROR: filter() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(pattern) then
		script_error(self.name .. " ERROR: filter() called but supplied pattern [" .. tostring(pattern) .. "] is not a function");
		return false;
	end;
	
	local sunit_list = self.sunit_list;
	local sunits_to_add = {};
	
	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		
		if pattern(current_sunit) then
			table.insert(sunits_to_add, current_sunit);
			if max_size and #sunits_to_add >= max_size then
				break;
			end;
		end;
	end;
	
	if assert_if_empty and #sunits_to_add == 0 then
		script_error(self.name .. " WARNING: filter() has completed but no matching units found - scriptunits collection with name [" .. name .. "] will be empty. Remove assert_if_empty flag if this is okay.");
	end;
	
	return script_units:new(name, sunits_to_add);
end;


--- @function sort
--- @desc Sorts the internal list of @script_unit objects based on the supplied filter function. The filter function should take two @script_unit arguments and return <code>true</code> if the first should be sorted before the second, and <code>false</code> otherwise. @table:sort is used to perform the operation.
--- @p @function filter function
function script_units:sort(filter)
	if not validate.is_function(filter) then
		return false;
	end;

	table.sort(self.sunit_list, filter);
end;


--- @function out
--- @desc Prints the list of @script_unit objects this collection contains to the debug console spool.
function script_units:out()
	bm:out(self.name .. " sunit list:");
	
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		local current_unit = current_sunit.unit;
		bm:out("\t" .. current_sunit.name .. " is of type " .. current_unit:type() .. ", class " .. current_unit:unit_class() .. " at position " .. v_to_s(current_unit:position()));
	end;
	bm:out("***");
end;


--- @function duplicate
--- @desc Returns a duplicate @script_units collection with the supplied name.
--- @p @string name
--- @r @script_units duplicate collection
function script_units:duplicate(name)

	if not is_string(name) then
		script_error(self.name .. " ERROR: duplicate() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local sunits = script_units:new(name);
	
	local new_sunit_list = {};	
	for i = 1, #self.sunit_list do
		table.insert(new_sunit_list, self.sunit_list[i]);
	end;
	
	sunits.sunit_list = new_sunit_list;
	
	return sunits;
end;


--- @function get_unitcontroller
--- @desc Returns a unitcontroller with control over all the units this @script_units collection contains.
--- @p [opt=nil] @battle_army army, If an army is supplied here, the function will only add units that belong to that army and ignore any that don't.
--- @p_long_desc If no army is supplied, the function assumes that all units in the scriptunits collection are in the same army, and will assert if any aren't.
--- @r @battle_unitcontroller unitcontroller
function script_units:get_unitcontroller(army)
	if self:count() == 0 then
		script_error("ERROR: get_unitcontroller() called but no script unit objects have been added to this collection");
		return false;
	end;

	local army_was_specified = false;
	
	if army then
		if not is_army(army) then
			script_error("ERROR: get_unitcontroller() called but supplied army [" .. tostring(army) .. "] is not a valid battle army object or nil");
			return false;
		end;
		army_was_specified = true;
	else
		army = self.sunit_list[1].unit:army();
	end;

	local uc = army:create_unit_controller();
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);

		if not army_was_specified or current_sunit.unit:army() == army then
			uc:add_units(current_sunit.unit);
		end;
	end;
	
	return uc;
end;


--- @function num_generals
--- @desc Returns the number of commanding general units the scriptunits collection contains.
--- @r @number number of generals
function script_units:num_generals()
	local count = 0;
	for i = 1, self:count() do
		if self:item(i).unit:is_commanding_unit() then
			count = count + 1;
		end;
	end;
	return count;
end;


--- @function get_general_sunit
--- @desc Returns a commanding general scriptunit from the scriptunits collection. By default the first general scriptunit is returned. An index value may be given to specify a particular general to return.
--- @p [opt=1] @number general index
--- @r @script_unit number of generals
function script_units:get_general_sunit(index)
	if not index then
		index = 1;
	elseif not (is_number(index) and index > 0) then
		script_error(self.name .. " ERROR: get_general_sunit() called but supplied index [" .. tostring(index) .. "] is not a positive number or nil");
		return false;
	end;

	local count = 0;
	for i = 1, self:count() do
		if self:item(i).unit:is_commanding_unit() then
			count = count + 1;
			if count == index then
				return self:item(i);
			end;
		end;
	end;
	
	script_error(self.name .. " ERROR: get_general_sunit() called but no commanding general unit with supplied index [" .. tostring(index) .. "] could be found. Number of generals found in this script_units collection is [" .. count .. "].");
end;









----------------------------------------------------------------------------
--- @section Position Tests
----------------------------------------------------------------------------


--- @function centre_point
--- @desc Returns a vector corresponding to the mean centre position of all the @script_unit objects in the collection.
--- @r @battle_vector centre position
function script_units:centre_point()
	return centre_point_table(self.sunit_list);
end;


--- @function radius
--- @desc Returns the distance from the furthest unit from the centre, to the centre, which is an indication of how spread out the units in this collection are.
--- @r @number radius
function script_units:radius()
	local centre_point = self:centre_point();
	local max_dist = 0;
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);
		local current_dist = current_sunit.unit:position():distance(centre_point);
		
		if current_dist > max_dist then
			max_dist = current_dist;
		end;
	end;
	
	return max_dist;
end;


--- @function width
--- @desc Returns the current cumulative width of all units in the collection in metres.
--- @r @number combined width
function script_units:width()
	local width = 0;
	for i = 1, self:count() do
		width = width + self:item(i).unit:ordered_width();
	end;	
	return width;
end;


--- @function average_bearing
--- @desc Returns the average ordered bearing of all units in the collection, in degrees.
--- @r @number average bearing
function script_units:average_bearing()
	local sum_sin = 0;
	local sum_cos = 0;
	
	for i = 1, self:count() do
		local bearing_r = d_to_r(self:item(i).unit:bearing());
		sum_sin = sum_sin + math.sin(bearing_r);
		sum_cos = sum_cos + math.cos(bearing_r);
	end;	
	return r_to_d(math.atan2(sum_sin, sum_cos));
end;


--- @function get_northernmost
--- @desc Returns the northern-most @script_unit.
--- @r script_unit
function script_units:get_northernmost()
	local extreme_sunit = false;
	local extreme_lat = -5000;
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);
		local current_sunit_lat = current_sunit.unit:position():get_z();
		if current_sunit_lat > extreme_lat then
			extreme_lat = current_sunit_lat;
			extreme_sunit = current_sunit;
		end;
	end;	
	return extreme_sunit;
end;


--- @function get_southernmost
--- @desc Returns the southern-most @script_unit.
--- @r script_unit
function script_units:get_southernmost()
	local extreme_sunit = false;
	local extreme_lat = 5000;
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);
		local current_sunit_lat = current_sunit.unit:position():get_z();
		if current_sunit_lat < extreme_lat then
			extreme_lat = current_sunit_lat;
			extreme_sunit = current_sunit;
		end;
	end;	
	return extreme_sunit;
end;


--- @function get_westernmost
--- @desc Returns the western-most @script_unit.
--- @r script_unit
function script_units:get_westernmost()
	local extreme_sunit = false;
	local extreme_long = 5000;
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);
		local current_sunit_long = current_sunit.unit:position():get_x();
		if current_sunit_long < extreme_long then
			extreme_long = current_sunit_long;
			extreme_sunit = current_sunit;
		end;
	end;	
	return extreme_sunit;
end;


--- @function get_easternmost
--- @desc Returns the eastern-most @script_unit.
--- @r script_unit
function script_units:get_easternmost()
	local extreme_sunit = false;
	local extreme_long = -5000;
	
	for i = 1, self:count() do
		local current_sunit = self:item(i);
		local current_sunit_long = current_sunit.unit:position():get_x();
		if current_sunit_long > extreme_long then
			extreme_long = current_sunit_long;
			extreme_sunit = current_sunit;
		end;
	end;	
	return extreme_sunit;
end;


--- @function get_closest
--- @desc Returns the closest @script_unit in this collection to the supplied collection of units/positions, as well as the distance in m.
--- @p object position collection, Position object or collection. Supported object types are vector, unit, @script_unit, units, @script_units, army, armies, alliance or table.
--- @p [opt=false] 2d only, consider 2D distance only (disregarding altitude)
--- @r script_unit closest scriptunit
--- @r distance distance of closest scriptunit in m
--- @r object closest foreign object from the supplied object - either a @battle_vector, a @battle_unit or a @script_unit, depending upon the container type.
function script_units:get_closest(obj, two_d)
	two_d = not not two_d;
	
	local closest_distance = 9999999;
	local closest_sunit = false;
	local closest_obj = false;
	
	if is_vector(obj) then
		closest_obj = obj;

		for i = 1, self:count() do
			local current_sunit = self:item(i);
			local current_distance = 0;
			
			if two_d then
				current_distance = current_sunit.unit:position():distance_xz(obj);
			else
				current_distance = current_sunit.unit:position():distance(obj);
			end;
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_sunit = current_sunit;
			end;
		end;
		
	elseif is_unit(obj) then
		closest_distance, closest_sunit = self:get_closest(obj:position(), two_d);
		closest_obj = obj;
		
	elseif is_scriptunit(obj) then
		closest_distance, closest_sunit = self:get_closest(obj:position(), two_d);
		closest_obj = obj;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			local current_closest_sunit, current_closest_distance, current_closest_obj = self:get_closest(obj:item(i):position(), two_d);
			if current_closest_distance < closest_distance then
				closest_distance = current_closest_distance;
				closest_sunit = current_closest_sunit;
				closest_obj = current_closest_obj;
			end;
		end;
		
	elseif is_army(obj) then
		closest_distance, closest_sunit, closest_obj = self:get_closest(obj:units(), two_d);
	
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			local current_closest_sunit, current_closest_distance, current_closest_obj = self:get_closest(obj:item(i):units(), two_d);
			if current_closest_distance < closest_distance then
				closest_distance = current_closest_distance;
				closest_sunit = current_closest_sunit;
				closest_obj = current_closest_obj;
			end;
		end;
		
	elseif is_alliance(obj) then
		closest_sunit, closest_distance, closest_obj = self:get_closest(obj:armies(), two_d);
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			local current_closest_sunit, current_closest_distance = self:get_closest(obj:item(i).unit:position(), two_d);
			if current_closest_distance < closest_distance then
				closest_distance = current_closest_distance;
				closest_sunit = current_closest_sunit;
				closest_obj = obj:item(i);
			end;
		end;
	
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_closest_sunit, current_closest_distance, current_closest_obj = self:get_closest(obj[i], two_d);
			if current_closest_distance < closest_distance then
				closest_distance = current_closest_distance;
				closest_sunit = current_closest_sunit;
				closest_obj = current_closest_obj;
			end;
		end;
		
	else
		script_error(self.name .. " ERROR: get_closest() called but supplied obj [" .. tostring(obj) .. "] was not recognised");
		return false;		
	end;
	
	return closest_sunit, closest_distance, closest_obj;
end;


--- @function get_furthest
--- @desc Returns the furthest @script_unit in this collection from the supplied collection of units/positions, as well as the distance in m.
--- @p object position collection, Position object or collection. Supported object types are @battle_vector, @battle_unit, @script_unit, @battle_units, @script_units, @battle_army, @battle_armies, @battle_alliance or @table.
--- @p [opt=false] 2d only, consider 2D distance only (disregarding altitude)
--- @r script_unit furthest scriptunit
--- @r distance distance of furthest scriptunit in m
function script_units:get_furthest(obj, two_d)
	two_d = not not two_d;
	
	local furthest_distance = 0;
	local furthest_sunit = false;
	
	if is_vector(obj) then
		for i = 1, self:count() do
			local current_sunit = self:item(i);
			local current_distance = 0;
			
			if two_d then
				current_distance = current_sunit.unit:position():distance_xz(obj);
			else
				current_distance = current_sunit.unit:position():distance(obj);
			end;
			
			if current_distance > furthest_distance then
				furthest_distance = current_distance;
				furthest_sunit = current_sunit;
			end;
		end;
		
	elseif is_unit(obj) then
		return self:get_furthest(obj:position(), two_d);
		
	elseif is_scriptunit(obj) then
		return self:get_furthest(obj.unit:position(), two_d);
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			local current_furthest_sunit, current_furthest_distance = self:get_furthest(obj:item(i):position(), two_d);
			if current_furthest_distance > furthest_distance then
				furthest_distance = current_furthest_distance;
				furthest_sunit = current_furthest_sunit;
			end;
		end;
		
	elseif is_army(obj) then
		return self:get_furthest(obj:units(), two_d);
	
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			local current_furthest_sunit, current_furthest_distance = self:get_furthest(obj:item(i):units(), two_d);
			if current_furthest_distance > furthest_distance then
				furthest_distance = current_furthest_distance;
				furthest_sunit = current_furthest_sunit;
			end;
		end;
		
	elseif is_alliance(obj) then
		return self:get_furthest(obj:armies(), two_d);
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			local current_furthest_sunit, current_furthest_distance = self:get_furthest(obj:item(i).unit:position(), two_d);
			if current_furthest_distance > furthest_distance then
				furthest_distance = current_furthest_distance;
				furthest_sunit = current_furthest_sunit;
			end;
		end;
	
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_furthest_sunit, current_furthest_distance = self:get_furthest(obj[i], two_d);
			if current_furthest_distance > furthest_distance then
				furthest_distance = current_furthest_distance;
				furthest_sunit = current_furthest_sunit;
			end;
		end;
		
	else
		script_error(self.name .. " ERROR: get_furthest() called but supplied obj [" .. tostring(obj) .. "] was not recognised");
		return false;		
	end;
	
	return furthest_sunit, furthest_distance;
end;


--- @function get_centremost
--- @desc Returns the @script_unit in the collection that is closest to the calculated centre.
--- @r @script_unit
function script_units:get_centremost()
	return self:get_closest(self:centre_point());
end;


--- @function get_outlying
--- @desc Returns the furthest @script_unit in this collection from the mean centre.
--- @r script_unit
function script_units:get_outlying()

	local furthest_sunit = false;
	local furthest_sunit_distance = 0;
	
	local sunit_list = self.sunit_list;

	-- for each unit in the collection find the closest sunit to it, then compare that to the furthest sunit-to-other-sunits combination found
	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		local current_sunit_position = current_sunit.unit:position();
		
		-- work out which fellow sunit is closest to this sunit
		local closest_sunit = false;
		local closest_sunit_distance = 999999999;
				
		for j = 1, #sunit_list do
			if i ~= j then
				local current_inner_sunit = sunit_list[j];
				local current_inner_distance = current_inner_sunit.unit:position():distance_xz(current_sunit_position);
				
				if current_inner_distance < closest_sunit_distance then
					closest_sunit = current_inner_sunit;
					closest_sunit_distance = current_inner_distance;
				end;	
			end;
		end;
		
		-- if the closest sunit to this sunit is further away than the furthest combination recorded so far, record this sunit
		if closest_sunit_distance > furthest_sunit_distance then
			furthest_sunit_distance = closest_sunit_distance;
			furthest_sunit = closest_sunit;
		end;
	end;
	
	-- return the furthest sunit and its closest distance to its fellow sunits
	return furthest_sunit, furthest_sunit_distance;
end;







----------------------------------------------------------------------------
---	@section Morale
----------------------------------------------------------------------------


--- @function are_any_routing_or_dead
--- @desc Returns <code>true</code> if any unit in this scriptunits collection is routing or dead, or <code>false</code> otherwise.
--- @p [opt=false] boolean shattered only, Only count shattered units.
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
function script_units:are_any_routing_or_dead(shattered_only, permit_rampaging)
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		if is_routing_or_dead(sunit_list[i].unit, shattered_only, permit_rampaging) then
			return true;
		end;
	end;
	return false;
end;


--- @function are_all_routing_or_dead
--- @desc Returns <code>true</code> if all units in this scriptunits collection are routing or dead, or <code>false</code> otherwise.
--- @p [opt=false] boolean shattered only, Only count shattered units.
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
function script_units:are_all_routing_or_dead(shattered_only, permit_rampaging)
	return is_routing_or_dead(self, shattered_only, permit_rampaging);
end;


--- @function rout_over_time
--- @desc Prevents routing units within the collection from rallying, and routs all non-routing units over the specified period in ms so that all units are eventually routing.
--- @p number period in ms, Time in ms over which the units are routed. Must be positive.
function script_units:rout_over_time(period)
	if not is_number(period) or period < 0 then
		script_error(self.name .. " ERROR: rout_over_time() called but supplied period [" .. tostring(period) .. "] is not a positive number");
		return false;
	end;
	
	-- rout all units immediately if the period is not long enough
	if period < 1000 then
		rout_all_units(self.sunit_list);
		return;
	end;
	
	-- work out how many non-routing units we have, and prevent any that are currently routing from un-routing
	local standing_sunits = {};
	
	for i = 1, #self.sunit_list do
		local current_sunit = self.sunit_list[i];
		
		if is_routing_or_dead(current_sunit) then
			current_sunit.uc:morale_behavior_rout();
		elseif not current_sunit.unit:is_valid_target() then
			current_sunit.uc:kill();
		else
			table.insert(standing_sunits, current_sunit);
		end;
	end;
	
	-- don't proceed if we don't have any units to deal with
	if #standing_sunits == 0 then
		return;
	end;
	
	local graduation = math.floor(period / #standing_sunits);
	
	for i = 1, #standing_sunits do
		bm:callback(function() standing_sunits[i].uc:morale_behavior_rout() end, graduation * i);
	end;
end;








----------------------------------------------------------------------------
---	@section Deployment
----------------------------------------------------------------------------

--- @function have_any_deployed
--- @desc Have any of the @script_unit objects in the collection deployed onto the battlefield.
--- @r @boolean any deployed
function script_units:have_any_deployed()
	local sunit_list = self.sunit_list;

	for i = 1, #sunit_list do
		if has_deployed(sunit_list[i]) then
			return true;
		end;	
	end;
	
	return false;
end;


--- @function have_all_deployed
--- @desc Have all of the @script_unit objects in the collection deployed onto the battlefield.
--- @r @boolean all deployed
function script_units:have_all_deployed()
	local sunit_list = self.sunit_list;

	for i = 1, #sunit_list do
		if not has_deployed(sunit_list[i]) then
			return false;
		end;	
	end;

	return true;
end;


--- @function num_deployed
--- @desc Returns the number of @script_unit objects in the collection that are currently deployed onto the battlefield.
--- @r @number number deployed
function script_units:num_deployed()
	local sunit_list = self.sunit_list;
	local count = 0;
	for i = 1, #sunit_list do
		if has_deployed(sunit_list[i]) then
			count = count + 1;
		end;	
	end;

	return count;
end;


--- @function are_any_active_on_battlefield
--- @desc Returns true if any @script_unit in this collection is deployed on the battlefield and not routing or dead.
--- @r @boolean any active
function script_units:are_any_active_on_battlefield()
	local sunit_list = self.sunit_list;

	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		if current_sunit.unit:is_valid_target() and not is_routing_or_dead(current_sunit) then
			return true;
		end;	
	end;

	return false;
end;










----------------------------------------------------------------------------
--- @section Movement and Combat Tests
----------------------------------------------------------------------------


--- @function have_any_moved
--- @desc Returns true if @script_unit:has_moved returns true for any unit in this collection. Call @script_unit:cache_location() first to set a position from which each unit's distance is tested.
--- @p [opt=nil] vector position, Position to test against. May be of limited usefulness when testing multiple units like this.
--- @p [opt=0] distance threshold distance, Threshold distance in m.
--- @r @boolean have any moved
function script_units:have_any_moved(pos, dist)
	local sunit_list = self.sunit_list;

	for i = 1, #sunit_list do
		if sunit_list[i]:has_moved(pos, dist) then
			return true;
		end;	
	end;
	
	return false;
end;


--- @function num_moved
--- @desc Returns the number of units in this collection that have moved when tested with @script_unit:has_moved. Call @script_unit:cache_location() first to set a position from which each unit's distance is tested.
--- @p [opt=nil] vector position, Position to test against. May be of limited usefulness when testing multiple units like this.
--- @p [opt=0] distance threshold distance, Threshold distance in m.
--- @r @number Number that have moved
function script_units:num_moved(pos, dist)
	local sunit_list = self.sunit_list;
	local count = 0;
	for i = 1, #sunit_list do
		if sunit_list[i]:has_moved(pos, dist) then
			count = count + 1;
		end;	
	end;
	
	return count;
end;


--- @function have_all_moved
--- @desc Returns true if @script_unit:has_moved returns true for all units in this collection. Call @script_unit:cache_location() first to set a position from which each unit's distance is tested.
--- @p [opt=nil] vector position, Position to test against. May be of limited usefulness when testing multiple units like this.
--- @p [opt=0] distance threshold distance, Threshold distance in m.
--- @r boolean have all moved
function script_units:have_all_moved(pos, dist)
	local sunit_list = self.sunit_list;

	for i = 1, #sunit_list do
		if not sunit_list[i]:has_moved(pos, dist) then
			return false;
		end;	
	end;
	
	return true;
end;


--- @function are_any_running
--- @desc Returns true if any @script_unit in this collection is moving fast.
--- @r boolean any running
function script_units:are_any_running()
	for i = 1, #self.sunit_list	do
		local current_sunit = self.sunit_list[i];
		
		if current_sunit.unit:is_moving_fast() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function are_all_running
--- @desc Returns true if all @script_unit objects in this collection are moving fast.
--- @r boolean any running
function script_units:are_all_running()
	for i = 1, #self.sunit_list	do
		local current_sunit = self.sunit_list[i];
		
		if not current_sunit.unit:is_moving_fast() then
			return false;
		end;
	end;
	
	return true;
end;


--- @function is_under_attack
--- @desc Returns true if any @script_unit in this collection is under attack (uses @script_unit:is_under_attack)
--- @r boolean any under attack
function script_units:is_under_attack()
	for i = 1, #self.sunit_list	do
		local current_sunit = self.sunit_list[i];
		
		if current_sunit:is_under_attack() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function is_in_melee
--- @desc Returns true if any @script_unit in this collection is in melee combat (uses @script_unit:is_in_melee).
--- @r boolean any in melee
function script_units:is_in_melee()
	for i = 1, #self.sunit_list	do
		local current_sunit = self.sunit_list[i];
		
		if current_sunit:is_in_melee() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function unary_hitpoints
--- @desc Returns the average unary hitpoints of all @script_unit objects in this collection.
--- @p [opt=false] @boolean shattered considered dead, Shattered units (or units that have routed and left the field) are considered dead, with 0 hitpoints.
--- @r @number average hitpoints
function script_units:unary_hitpoints(shattered_considered_dead)
	local cumulative_hitpoints = 0;
	local num_units = #self.sunit_list;
	
	if num_units == 0 then
		return 0;
	end;
	
	for i = 1, num_units do
		cumulative_hitpoints = cumulative_hitpoints + self.sunit_list[i]:unary_hitpoints(shattered_considered_dead);
	end;
	
	return cumulative_hitpoints / num_units;
end;


--- @function number_of_enemies_killed
--- @desc Returns the total number of enemies killed by all units in this collection.
--- @r @number total enemies killed
function script_units:number_of_enemies_killed()
	local count = 0;
	for i = 1, #self.sunit_list do
		count = count + self.sunit_list[i].unit:number_of_enemies_killed();
	end;
	return count;
end;













----------------------------------------------------------------------------
--- @section Movement and Teleportation
----------------------------------------------------------------------------


--- @function disordered_teleport
--- @desc Performs a disordered teleport of all units contained within this collection to within a radius around a position, both supplied. A disordered teleport preserves the current orientation and width of each unit, but teleports them within the radius of the position if they're not already inside.
--- @desc The function is intended to assist in transitions between different sections of gameplay within a heavily scripted battle. We may wish for the player to start the latter section with their troops in unformed order, akin to where they were at the end of the previous section, but to ensure that none of the player's forces are too far away from a known position (i.e. where we'd like them to start the latter section of gameplay).
--- @desc Script control of the teleported units is automatically released after this function is called.
--- @p @battle_vector target position
--- @p @number radius in m
--- @p [opt=false] @boolean release control
function script_units:disordered_teleport(target_position, radius, release_control)
	if not is_vector(target_position) then
		script_error(self.name .. " ERROR: disordered_teleport() called but supplied position [" .. tostring(target_position) .. "] is not a battle vector");
		return false;
	end;

	if not is_number(radius) or radius < 1 then
		script_error(self.name .. " ERROR: disordered_teleport() called but supplied radius [" .. tostring(radius) .. "] is not a positive number");
		return false;
	end;

	local sunits = self.sunit_list;
	for i = 1, #sunits do
		local current_sunit = sunits[i];
		local current_distance = current_sunit.unit:position():distance_xz(target_position);
		if current_distance > radius then
			local pos = position_along_line(target_position, current_sunit.unit:position(), radius, true);
			current_sunit.uc:teleport_to_location(pos, current_sunit.unit:bearing(), current_sunit.unit:ordered_width());
		end;
	end;

	self:halt();

	if release_control then
		self:release_control();
	end;
end;










----------------------------------------------------------------------------
--- @section Respawning
----------------------------------------------------------------------------


--- @function respawn_in_start_location
--- @desc Respawns the units in the collection at the locations they started the battle. This resets their health, fatigue, casualties and other stats.
--- @p [opt=false] @boolean only if dead, Respawn each unit only if it is dead, or if it has routed off the battlefield.
--- @p [opt=false] @boolean debug output, Produce debug output about which units have been respawned.
--- @r @number number respawned
function script_units:respawn_in_start_location(only_if_dead, debug_output)
	local sunit_list = self.sunit_list;

	if only_if_dead then
		if debug_output then
			local respawned_sunit_names = {};

			for i = 1, #sunit_list do
				local respawned = sunit_list[i]:respawn_in_start_location(only_if_dead);
				if respawned then
					table.insert(respawned_sunit_names, sunit_list[i].name);
				end;
			end;

			if #respawned_sunit_names > 0 then
				bm:out(self.name .. " has respawned " .. #respawned_sunit_names .. (#respawned_sunit_names == 1 and " unit" or " units") .. ", [" .. table.concat(respawned_sunit_names, ", ") .. "]");
			end;
			return #respawned_sunit_names;
		else
			local count = 0;
			for i = 1, #sunit_list do
				local respawned = sunit_list[i]:respawn_in_start_location(only_if_dead);
				if respawned then
					count = count + 1;
				end;
			end;
			return count;
		end;
	end;

	for i = 1, #sunit_list do
		sunit_list[i]:respawn_in_start_location(only_if_dead);
	end;

	if debug_output and #sunit_list > 0 then
		bm:out(self.name .. " has respawned all " .. #sunit_list .. (#sunit_list == 1 and " unit" or " units"));
	end;

	return #sunit_list;
end;










----------------------------------------------------------------------------
--- @section Changing formation
--- @desc Changing formation won't work unless all @script_unit objects in the collection are in the same army (which is recommended anyway).
----------------------------------------------------------------------------


--- @function change_formation
--- @desc Sets all @script_unit objects in the collection into a group formation.
--- @desc A list of formations can be found in raw data. Valid entries at time of writing are:
--- @desc <ul><li>flanking</li>
--- @desc <li>generic_directfire_defence</li>
--- @desc <li>generic_directfire_attack</li>
--- @desc <li>generic</li>
--- @desc <li>generic_ranged_protected</li>
--- @desc <li>generic_melee_heavy</li>
--- @desc <li>generic_melee_super_heavy</li>
--- @desc <li>assault_gates_formation</li>
--- @desc <li>assault_reserves_formation</li>
--- @desc <li>Multiple Selection Drag Out Land</li>
--- @desc <li>Multiple Selection Deployable Drag Out Land</li>
--- @desc <li>single_line</li>
--- @desc <li>Multiple Selection Naval</li>
--- @desc <li>Ambush Defence Block</li>
--- @desc <li>test_melee_forward_simple</li>
--- @desc <li>test_missile_forward_simple</li>
--- @desc <li>river_ai_attack</li>
--- @desc <li>river_ai_attack_narrow</li>
--- @desc <li>river_ai_stop_and_shoot</li>
--- @desc <li>river_ai_defend</li>
--- @desc <li>stop_and_shoot_artillery</li>
--- @desc <li>stop_and_shoot_ranged_direct</li></ul>
--- @p string group formation name
function script_units:change_formation(formation)
	local uc = self:get_unitcontroller();
	
	if uc then
		uc:change_group_formation(formation);
	end;
end;










----------------------------------------------------------------------------
--- @section Visibility
----------------------------------------------------------------------------


--- @function is_hidden
--- @desc Returns true if any @script_unit in this collection is hidden in long grass or trees. If <code>true</code> is supplied as a single argument, then <strong>all</strong> units in the collection must be hidden for the function to return true.
--- @p [opt=false] boolean all units
--- @r boolean is hidden
function script_units:is_hidden(all)
	if all then
		for i = 1, #self.sunit_list	do
			local current_sunit = self.sunit_list[i];
			
			if not current_sunit:is_hidden() then
				return false;
			end;
		end;
		
		return true;
	else
		for i = 1, #self.sunit_list	do
			local current_sunit = self.sunit_list[i];
			
			if current_sunit:is_hidden() then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function is_visible_to_enemy
--- @desc Returns true if any @script_unit in this collection is visible to the enemy, by the rules of the terrain visibility system. Note that a unit can be considered visible by this system but still be hidden in forests.
--- @r boolean is visible
function script_units:is_visible_to_enemy()
	if #self.sunit_list == 0 then
		return false;
	end;
	
	return is_visible(self.sunit_list, bm:alliances():item(self.sunit_list[1].enemy_alliance_num));
end;










----------------------------------------------------------------------------
--- @section Reinforcement Behaviour
----------------------------------------------------------------------------


--- @function deploy_at_random_intervals
--- @desc Deploys the units in this collection onto the battlefield in randomly-sized, randomly-timed batches. Units must have been scripted to not deploy automatically before this is called. Arguments can be used to influence the size and timing of the batches of units.
--- @p @number min units, Minimum size of random unit batch. Must be postive.
--- @p @number max units, Maximum size of random unit batch. Must be positive, and not less than the supplied min units value.
--- @p @number min period, Minimum time period between the arrival of batches in ms. Must be positive.
--- @p @number max period, Maximum time period between the arrival of batches in ms. Must be positive, and not less than the supplied minimum period.
--- @p [opt=false] @boolean debug out, Supply true to turn on debug output.
--- @p [opt=false] @boolean spawn immediately, Spawns the first wave immediately.
--- @p [opt=false] @boolean allow respawning, Allows units to be respawned and deployed again.
--- @p [opt=nil] @function new wave callback, Callback to call when a new wave in deployed. A @table containing a list of @script_unit objects representing the units being deployed will be passed to the callback when it is called.
function script_units:deploy_at_random_intervals(min_units, max_units, min_period, max_period, force_output, spawn_first_wave_immediately, allow_respawning, new_wave_callback)
	if not is_number(min_units) or min_units <= 0 then
		script_error("ERROR: deploy_at_random_intervals() called but supplied minimum units [" .. tostring(min_units) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(max_units) or max_units < min_units then
		script_error("ERROR: deploy_at_random_intervals() called but supplied maximum units [" .. tostring(max_units) .. "] is not a number >= the supplied minimum [" .. min_units .. "]");
		return false;
	end;

	if not is_number(min_period) or min_period <= 0 then
		script_error("ERROR: deploy_at_random_intervals() called but supplied minimum period [" .. tostring(min_period) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(max_period) or max_period < min_period then
		script_error("ERROR: deploy_at_random_intervals() called but supplied maximum period [" .. tostring(max_period) .. "] is not a number >= the supplied minimum [" .. min_period .. "]");
		return false;
	end;

	if new_wave_callback and not validate.is_function(new_wave_callback) then
		return false;
	end;
	
	spawn_first_wave_immediately = not not spawn_first_wave_immediately;

	-- make all inputs integer
	min_units = math.floor(min_units);
	max_units = math.floor(max_units);
	min_period = math.floor(min_period);
	max_period = math.floor(max_period);
	
	self:enqueue_deploy_at_random_intervals_action(min_units, max_units, min_period, max_period, force_output, spawn_first_wave_immediately, allow_respawning, new_wave_callback)
end;


function script_units:enqueue_deploy_at_random_intervals_action(min_units, max_units, min_period, max_period, force_output, spawn_first_wave_immediately, allow_respawning, new_wave_callback)

	local wait_time = math.floor(bm:random_number(min_period, max_period) / 100) * 100;
	
	-- if the spawn_first_wave_immediately flag is set then we are to deploy the first wave immediately, so set the wait_time to 0
	if spawn_first_wave_immediately then
		wait_time = 0;
	end;
	
	if self.is_debug or force_output then
		bm:out(self.name .. ":deploy_at_random_intervals() waiting for " .. wait_time .. " ms.");
	end;
	bm:callback(
		function() 
			self:deploy_at_random_intervals_action(min_units, max_units, min_period, max_period, force_output, allow_respawning, new_wave_callback);
		end, 
		wait_time, 
		self.name .. "_deploy_at_random_intervals"
	);
end;


function script_units:deploy_at_random_intervals_action(min_units, max_units, min_period, max_period, force_output, allow_respawning, new_wave_callback)
	-- build a list of sunits yet to be deployed by this system
	local undeployed_sunits = {};
	for i = 1, #self.sunit_list	do
		local current_sunit = self.sunit_list[i];
		if current_sunit.unit:is_valid_for_deployment() and (allow_respawning or current_sunit.deployed_as_reinforcement_count == 0) then
			table.insert(undeployed_sunits, current_sunit);
		end;
	end;

	-- If we're not allow to respawn any units and we've found no units to respawn the terminate the process
	if not allow_respawning and #undeployed_sunits == 0 then
		return;
	end;
	
	-- randomly sort our table
	undeployed_sunits = bm:random_sort(undeployed_sunits);
	
	-- work out how many units to deploy. If we don't have enough units left, just deploy what we have
	local number_to_deploy = bm:random_number(min_units, max_units);
	
	if number_to_deploy > #undeployed_sunits then
		number_to_deploy = #undeployed_sunits;
	end;

	local sunits_deploying = {};
	
	for i = 1, number_to_deploy do
		local current_sunit = undeployed_sunits[i];
		if force_output then
			bm:out(self.name .. ":deploying unit " .. current_sunit.name .. " as reinforcement");
		end;
		current_sunit:deploy_reinforcement(true);
		table.insert(sunits_deploying, current_sunit);
		
		-- if this unit has a planner, we watch for them deploying and do some special behaviour
		--[[
		if current_sunit.planner then
			bm:watch(
				function() return has_deployed(current_sunit) end,
				0,
				function()
					-- If they still have a planner at the moment they are deployed, then re-issue the planner's order.
					-- This gives the AI a kick to properly pick the new unit up.
					if current_sunit.planner then
						current_sunit.planner:reissue_current_order();
					end
				end
			);
		end;
		]]
	end;
	
	if self.is_debug or force_output then
		local sunits_deploying_names = {};
		for i = 1, #sunits_deploying do
			table.insert(sunits_deploying_names, sunits_deploying[i].name);
		end;

		bm:out(self.name .. ":deploy_at_random_intervals() has deployed " .. number_to_deploy .. " reinforcement unit" .. (number_to_deploy == 1 and ": [" or "s: [") .. table.concat(sunits_deploying_names, ", ") .. "]");
	end;

	if new_wave_callback then
		new_wave_callback(sunits_deploying);
	end;
	
	-- Deploy more reinforcements in the future
	self:enqueue_deploy_at_random_intervals_action(min_units, max_units, min_period, max_period, force_output, false, allow_respawning, new_wave_callback);
end;


--- @function cancel_deploy_at_random_intervals
--- @desc Cancels/stops a running process started with @script_units:deploy_at_random_intervals.
function script_units:cancel_deploy_at_random_intervals()
	bm:remove_process(self.name .. "_deploy_at_random_intervals");
end;









----------------------------------------------------------------------------
--- @section Kill Aura
----------------------------------------------------------------------------


--- @function start_kill_aura
--- @desc Activates a kill aura around these units that cause a specified enemy/other @script_units to take casualties when they come within a specified range. Only one kill aura process may be active on a scriptunit at a time.
--- @p script_units target sunits, Target @script_units collection.
--- @p number range, Range in m at which the enemy @script_units begin to take casualties.
--- @p [opt=0.02] number casualties proportion, Proportion of casualties taken per second. This should be specified as a unary proportion of the unit's initial strength, so the default value of 0.02 represents 2% of the initial strength per second.
function script_units:start_kill_aura(enemy_sunits, range, proportion_per_second)
	if not is_scriptunits(enemy_sunits) then
		script_error(self.name .. " ERROR: start_kill_aura() called but supplied enemy [" .. tostring(enemy_sunits) .. "] is not a scriptunits collecion");
		return false;
	end;
	
	range = range or 20;
	proportion_per_second = proportion_per_second or 0.02;
	
	self:stop_kill_aura();

	self:kill_aura_action(enemy_sunits, range, proportion_per_second);
end;


function script_units:kill_aura_action(enemy_sunits, range, proportion_per_second)
	local casualty_list = {};
	local sunit_list = self.sunit_list;
	
	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		
		for j = 1, enemy_sunits:count() do
			local current_enemy_sunit = enemy_sunits:item(j);
			
			if not current_enemy_sunit.kill_aura_casualty_this_pass and current_enemy_sunit.unit:position():distance(current_sunit.unit:position()) < range then
				current_enemy_sunit.kill_aura_casualty_this_pass = true;		-- ensure this unit does not get counted multiple times
				table.insert(casualty_list, current_enemy_sunit);
			end
		end;
	end;
	
	for i = 1, #casualty_list do
		local current_enemy_sunit = casualty_list[i];
		current_enemy_sunit.kill_aura_casualty_this_pass = nil;
		current_enemy_sunit:kill_proportion(proportion_per_second);
	end;
	
	bm:callback(function() self:kill_aura_action(enemy_sunits, range, proportion_per_second) end, 1000, self.name .. "_kill_aura");
end;


--- @function stop_kill_aura
--- @desc Stops the kill aura started on this collection with @script_units:start_kill_aura.
function script_units:stop_kill_aura()
	bm:remove_process(self.name .. "_kill_aura");
end;









----------------------------------------------------------------------------
--- @section Attack Enemy Scriptunits
----------------------------------------------------------------------------


--- @function attack_enemy_scriptunits
--- @desc Instructs this scriptunits collection to attack another, acting entirely under script control. This is best used for a close-quarters scripted engagement where no AI randomness or maneouvring is desired.
--- @p script_units enemy script_units
--- @p [opt=false] boolean should run
function script_units:attack_enemy_scriptunits(enemy_sunits, should_run)
	if not is_scriptunits(enemy_sunits) then
		script_error(self.name .. " ERROR: attack_enemy_scriptunits() called but supplied enemy scriptunits [" .. tostring(enemy_sunits) .. "] is not a valid scriptunits collection");
		return false;
	end;
	
	if self:count() == 0 then
		return;
	end;
	
	if enemy_sunits:count() == 0 then
		script_error(self.name .. " ERROR: attack_enemy_scriptunits() called but supplied enemy scriptunits collection [" .. enemy_sunits.name .. "] is empty");
		return false;
	end;
	
	local sunit_list = self.sunit_list;
	
	if enemy_sunits:item(1).alliance_num == sunit_list[1].alliance_num then
		script_error(self.name .. " ERROR: attack_enemy_scriptunits() called but supplied enemy scriptunits collection [" .. enemy_sunits.name .. "] is of the same alliance");
		return false;
	end;
		
	-- dont continue if we have no controllable enemies or allies
	if is_routing_or_dead(sunit_list) then
		bm:out("attack_enemy_scriptunits() is stopping as all controlled sunits are routing or dead");
		return;
	end;
	
	if is_routing_or_dead(enemy_sunits) then
		bm:out("attack_enemy_scriptunits() is stopping as all enemy sunits are routing or dead");
		return;
	end;
	
	should_run = not not should_run;
	
	-- build a list of units to attack. This is the closest enemy unit plus any unit that's within a threshold distance of the group of units it's in
	local valid_enemy_sunits = false;
	
	do
		-- build a copy of the enemy units we've been given, we do this as the test we're about to run will destroy it
		local enemy_sunits_to_test = enemy_sunits:duplicate("enemy_sunits_to_test");
		valid_enemy_sunits = script_units:new("valid_enemy_sunits");
	
		-- add the closest enemy unit to our controlled units to the valid list as a starting point, and build the valid list up from there
		local closest_enemy_sunit = enemy_sunits_to_test:get_closest(self, true);
		
		valid_enemy_sunits:add_sunits(closest_enemy_sunit);
		enemy_sunits_to_test:remove_sunit(closest_enemy_sunit);

		while true do
			if enemy_sunits_to_test:count() == 0 then
				break;
			end;
		
			-- find the closest sunit to the valid sunits in the enemy sunits still to test
			-- if it's within a threshold distance, add it to the valid sunits and remove it from the to-test list
			local candidate_sunit, candidate_sunit_distance = enemy_sunits_to_test:get_closest(valid_enemy_sunits, true);
	
			if candidate_sunit_distance < 70 then 	-- threshold distance, consider exposing
				valid_enemy_sunits:add_sunits(candidate_sunit);
				enemy_sunits_to_test:remove_sunit(candidate_sunit);
			else
				break;
			end;
		end;	
	end;
		
	-- build a grid of all distances between all enemy and player sunits
	local distance_grid = {};
	
	for i = 1, #sunit_list do
		local current_controlled_sunit = sunit_list[i];
		
		table.insert(distance_grid, {});
		
		distance_grid[i].controlled_sunit = current_controlled_sunit;
		
		for j = 1, valid_enemy_sunits:count() do
			local current_enemy_sunit = valid_enemy_sunits:item(j);
		
			local grid_entry = {};
			
			grid_entry.controlled_sunit = current_controlled_sunit;
			grid_entry.enemy_sunit = current_enemy_sunit;
			grid_entry.distance = current_enemy_sunit.unit:position():distance_xz(current_controlled_sunit.unit:position());
			
			distance_grid[i][j] = grid_entry;
		end;
	end;
	
	-- loop through all controlled sunits and assign them their closest unattended enemy unit to attack	
	while #distance_grid > 0 do
		local closest_controlled_index = 0;
		local closest_enemy_index = 0;
		local closest_distance = 999999999;
		
		for i = 1, #distance_grid do
			if #distance_grid[i] == 0 then
				-- we have no more players that remain un-attacked
				break;
			end
		
			for j = 1, #distance_grid[i] do
				local current_distance = distance_grid[i][j].distance;
				
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_controlled_index = i;
					closest_enemy_index = j;
				end;
			end;
		end;
		
		if closest_enemy_index == 0 then
			-- we have no more enemy units that aren't being attacked, just send all remaining controlled units to attack whatever is nearest to them
			for i = 1, #distance_grid do
				local current_controlled_sunit = distance_grid[i].controlled_sunit;
				local closest_enemy_sunit = valid_enemy_sunits:get_closest(current_controlled_sunit.unit:position(), true);
				bm:out("attack_enemy_scriptunits() is sending " .. current_controlled_sunit.name .. " to attack " .. closest_enemy_sunit.name .. " (no more un-attacked enemy units at this point)");
				current_controlled_sunit.uc:attack_unit(closest_enemy_sunit.unit, true, should_run);
			end;
			return;
		end;
		
		local grid_entry = distance_grid[closest_controlled_index][closest_enemy_index];
		local controlled_sunit = grid_entry.controlled_sunit;
		local enemy_sunit = grid_entry.enemy_sunit;
		
		-- send the controlled unit to attack the enemy	
		if enemy_sunit.unit:is_visible_to_alliance(controlled_sunit:alliance()) then
			bm:out("attack_enemy_scriptunits() is sending " .. controlled_sunit.name .. " to attack " .. enemy_sunit.name .. ", they are " .. grid_entry.distance .. "m apart");
			controlled_sunit.uc:attack_unit(enemy_sunit.unit, true, should_run);
		else
			bm:out("attack_enemy_scriptunits() is sending " .. controlled_sunit.name .. " to position of " .. enemy_sunit.name .. " " .. v_to_s(enemy_sunit.unit:position()) .. " as it's not visible");
			controlled_sunit.uc:goto_location(enemy_sunit.unit:position(), true);
		end;
		
		-- remove grid entries relevant to this enemy
		table.remove(distance_grid, closest_controlled_index);
		for i = 1, #distance_grid do
			table.remove(distance_grid[i], closest_enemy_index);
		end;
	end;
	
	bm:callback(function() self:attack_enemy_scriptunits(enemy_sunits, should_run) end, 8000, self.name .. "_attack_enemy_scriptunits");
end;


--- @function stop_attack_enemy_scriptunits
--- @desc Stops an attack process started with @script_units:attack_enemy_scriptunits.
function script_units:stop_attack_enemy_scriptunits()
	bm:remove_process(self.name .. "_attack_enemy_scriptunits");
end;












----------------------------------------------------------------------------
---	@section Highlighting Unit Cards
----------------------------------------------------------------------------


--- @function highlight_unit_cards
--- @desc Pulses a highlight effect on all the unit cards associated with this scriptunits collection, using @script_unit:highlight_unit_card.
--- @p boolean should highlight, Set to <code>true</code> to turn the highlight effect on, <code>false</code> to turn it off.
--- @p [opt=5] number pulse strength, Sets the strength of the pulse effect. A higher supplied value leads to a more pronounced pulse effect. The default value is 5.
--- @p [opt=false] boolean force highlight, Overrides the disabling of help page highlighting with @battle_ui_manager:set_help_page_link_highlighting_permitted. Set this to true if the script explicitly wants to highlight the UI cards when help page link highlighting is disabled (useful in tutorials).
function script_units:highlight_unit_cards(value, pulse_strength, force_highlight)
	local sunit_list = self.sunit_list;
	for i = 1, #sunit_list do
		sunit_list[i]:highlight_unit_card(value, pulse_strength, force_highlight);
	end;
end;









-----------------------------------------------------------------------------
--- @section Serialised Army State
--- @desc The functions in this section allow scripts to save or apply a serialised state from the @scriptedvalueregistry, across campaign and battle. This allows battle script to apply health values to units that were set in campaign, or vice-versa. This is chiefly useful for scripted battles that are launched from campaign but are logically actually nothing to do with that campaign, such as a tutorial battle xml loaded from a campaign as if it was a campaign-generated battle. Using this functionality the battle scripts would be able to spoof the approximate health of the army as if it were coming from campaign, and then pass it back to campaign on battle completion.
--- @desc Campaign scripts can use @campaign_manager:save_army_state_to_svr and @campaign_manager:load_army_state_from_svr to save and load army states, and in battle @script_units:save_state_to_svr and @script_units:load_state_from_svr can be used to do the same.
--- @desc Note that at present this only serialises the health state of units and not their experience, items carried etc.
-----------------------------------------------------------------------------


--- @function serialise_state
--- @desc Returns a @string which represents the serialised state of this script_units collection. This does not embody the full model state of the units but only selected information. It is mainly intended for use by @script_units:save_state_to_svr which will save the returned string into the scripted value registry. This string can then be loaded by @campaign_manager:load_army_state_from_svr, allowing campaign scripts to spoof the results from a scripted battle that occurs mid-campaign flow.
--- @r @string serialised state
function script_units:serialise_state()
	local table_to_serialise = {};

	for i = 1, self:count() do
		local current_sunit = self:item(i);
		table.insert(
			table_to_serialise,
			{
				uuid = current_sunit.unit:unique_ui_id(),
				type = current_sunit.unit:type(),
				unary_hp = current_sunit.unit:unary_hitpoints()
			}
		);
	end;

	return table.tostring(table_to_serialise, true);
end;


--- @function save_state_to_svr
--- @desc Saves a @string which represents the serialised state of this script_units collection to the scripted value registry. @script_units:serialise_state is used to generate the state string, and @core:svr_save_string is used to save the string. This is for use by scripts that wish to pass the state of an army, usually at the end of a battle, from battle script to campaign script, usually so that the latter can spoof the battle results in script. The function @campaign_manager:load_army_state_from_svr can be used on the campaign-side to load the values saved by this string.
--- @p @string name, Name for this svr entry, to be passed to @core:svr_save_string.
function script_units:save_state_to_svr(name)
	if not is_string(name) then
		script_error(self.name .. " ERROR: save_state_to_svr() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local table_str = "return " .. self:serialise_state();
	bm:out(self.name .. ":save_state_to_svr() has serialised state to string with name [" .. name .. "], string is " .. table_str);
	core:svr_save_string(name, table_str);
end;


--- @function load_state_from_svr
--- @desc Checks for a @scriptedvalueregistry string with the supplied name, and attempts to apply the health values it contains to the units in this script_units collection. These svr strings would be set by either @campaign_manager:save_army_state_to_svr in campaign or @script_units:save_state_to_svr in battle.
--- @desc This is primarily intended to spoof casualties on a battle army that is coming from campaign, but where the army in battle is not logically related to that campaign army (for example, when loading from a campaign into a scripted xml battle).
--- @desc The function returns whether the application was successful. A successful application is one that modifies all units in the script_units collection (a "modification" from 100% health to 100% health would count), unless the <code>allow_partial</code> flag is set, in which case even a partial application would be considered successful. If the application is not successful then no changes are applied. Output is generated in all cases.
--- @p @string name, Name of string saved in the @scriptedvalueregistry.
--- @p [opt=false] @boolean allow partial, Allow a partial application of the state string. If this is set to <code>true</code then the application will be successful even if not all sunits in this collection end up being touched.
--- @r @boolean state was applied successfully
function script_units:load_state_from_svr(name, allow_partial)
	if not is_string(name) then
		script_error(self.name .. " ERROR: load_state_from_svr() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local svr_str = core:svr_load_string(name);

	if not svr_str then
		bm:out(self.name .. ":load_state_from_svr() did not apply state with name [" .. name .. "] as no such scripted value registry string could be found");
		return false;
	end;

	local table_func = loadstring(svr_str);
	if not is_function(table_func) then
		bm:out(self.name .. ":load_state_from_svr() did not apply state with name [" .. name .. "] as the scripted value registry string [" .. svr_str .. "] could not be converted into a function");
		return false;
	end;

	local t = table_func();
	if not is_table(t) then
		bm:out(self.name .. ":load_state_from_svr() did not apply state with name [" .. name .. "] as the function generated by scripted value registry string [" .. svr_str .. "] did not return a table");
		return false;
	end;

	local sunit_list = self.sunit_list;

	-- go through our derived table and store new hp values on our sunits where they match, to be applied later
	for i = 1, #t do
		local current_unit_record = t[i];
		if current_unit_record.type then
			for j = 1, #sunit_list do
				local current_sunit = sunit_list[j];
				
				if not current_sunit.svr_new_hp and current_unit_record.type == current_sunit.unit:type() then
					current_sunit.svr_new_hp = current_unit_record.unary_hp;
					break;
				end;
			end;
		end;
	end;

	-- check that all units in the script_units collection have been touched
	local untouched_sunits = {};
	for i = 1, #sunit_list do
		if not sunit_list[i].svr_new_hp then
			table.insert(untouched_sunits, sunit_list[i].name);
		end;
	end;

	-- if not all sunits are touched and the allow_partial flag is not set then clear up our flags and abort
	if not allow_partial and #untouched_sunits > 0 then
		for i = 1, #sunit_list do
			sunit_list[i].svr_new_hp = nil;
		end;
		
		bm:out(self.name .. ":load_state_from_svr() did not apply state with name [" .. name .. "] as the sunits [" .. table.concat(untouched_sunits, ", ") .. "] in this collection were not touched by the scripted value registry string [" .. svr_str .. "], and the allow_partial flag is not set");
		return false;
	end;

	-- apply the changes
	for i = 1, #sunit_list do
		local current_sunit = sunit_list[i];
		if current_sunit.svr_new_hp then
			-- kill a proportion of this unit immediately
			current_sunit.unit:kill_number_of_men(math.floor((1 - current_sunit.svr_new_hp) * current_sunit.unit:initial_number_of_men()), true);
		end;

		-- remove flag
		sunit_list[i].svr_new_hp = nil;
	end;

	if #untouched_sunits == 0 then
		bm:out(self.name .. ":load_state_from_svr() applied state with name [" .. name .. "], scripted value registry string was [" .. svr_str .. "]");
	else
		bm:out(self.name .. ":load_state_from_svr() applied state with name [" .. name .. "] despite sunits [" .. table.concat(untouched_sunits, ", ") .. "] not being touched. Scripted value registry string was [" .. svr_str .. "]");
	end;
	
	return true;
end;