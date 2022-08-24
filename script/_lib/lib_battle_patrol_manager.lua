

PATROL_MANAGER_REACHED_DESTINATION = 1;
PATROL_MANAGER_PURSUED_TOO_FAR = 2;
PATROL_MANAGER_STARTING = 3;
PATROL_MANAGER_RESTARTING = 4;
PATROL_MANAGER_STOPPING_ON_INTERCEPT = 5;
PATROL_MANAGER_INTERCEPT_AS_NORMAL = 6;
PATROL_MANAGER_UNIT_IS_DEAD_OR_ROUTING = 10;
PATROL_MANAGER_UNIT_IS_NO_LONGER_ROUTING = 11;
PATROL_MANAGER_COULDNT_FIND_TARGET = 12
__patrol_manager_debug = false;

PATROL_MANAGER_REORDER_INTERVAL = 5000;							-- when a waypoint is a unit, the unit is re-issued an order to their destination at this interval
PATROL_MANAGER_REINTERCEPT_INT_RADIUS_MODIFIER = 0.3;			-- multiplier on the intercept radius to prevent a unit from immediately reintercepting when it abandons a chase and turns away
PATROL_MANAGER_REINTERCEPT_GUARD_RADIUS_MODIFIER = 0.7;			-- multiplier on the guard radius to prevent a unit from immediately reintercepting when it abandons a chase and turns away
PATROL_MANAGER_WAIT_BEFORE_NORMAL_REINTERCEPT = 35000;			-- time after giving up a chase before which the manager resets its guard/intercept values to normal
PATROL_MANAGER_DEFAULT_GUARD_RADIUS = 0;
PATROL_MANAGER_DEFAULT_INTERCEPT_TIME = 10000;
PATROL_MANAGER_MIN_INTERCEPT_TO_ABANDON_SPACING = 10;
PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_INF = 20;
PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_CAV = 40;
PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_NAVAL = 35;

patrol_manager = {
	name = "",
	sunit = nil,
	enemy_armies = nil,
	intercept_radius = 0,
	--opt
	abandon_radius = 0,
	guard_radius = PATROL_MANAGER_DEFAULT_GUARD_RADIUS,
	--non parameter
	interception_callback = nil,
	abandon_callback = nil,
	completion_callback = nil,
	rout_callback = nil,
	stop_on_rout = true,
	stop_on_intercept = false,
	previous_pos = nil,
	waypoint_reached_threshold = PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_INF,
	is_debug = false,
	is_naval = false,
	is_intercepting = false,
	intercept_time = PATROL_MANAGER_DEFAULT_INTERCEPT_TIME,
	waypoints = {},
	current_waypoint = 1,
	width = 0,
	walk_speed = 1,
	force_run = false,
	is_running = false,
	should_loop = false,
	attack_with_primary_weapon = true
}


set_class_custom_type(patrol_manager, TYPE_PATROL_MANAGER);
set_class_tostring(
	patrol_manager,
	function(obj)
		return TYPE_PATROL_MANAGER .. "_" .. obj.name;
	end
);





function patrol_manager:new(
								new_name,
								new_sunit,
								new_enemy_armies,
								new_intercept_radius,
								--opt
								new_abandon_radius,
								new_guard_radius
							)
	
	if not is_string(new_name) then
		script_error("ERROR: name given " .. tostring(new_name) .. " is not a string");
		
		return false;
	end;
	
	if not is_scriptunit(new_sunit) then
		script_error(self.name .. " ERROR: sunit given " .. tostring(new_sunit) .. " is not a sunit");
		
		return false;
	end;
	
	if not is_armies(new_enemy_armies) then
		script_error(self.name .. " ERROR: enemy armies given " .. tostring(new_enemy_armies) .. " is not a valid armies object");
		
		return false;
	end;
	
	if contains_unit(new_enemy_armies, new_sunit.unit) then
		script_error(self.name .. " ERROR: sunit given " .. new_sunit.name .. " is a member of the given enemy armies " .. tostring(new_enemy_armies));
		
		return false;
	end;
	
	if not is_number(new_intercept_radius) or new_intercept_radius < 0 then
		script_error(self.name .. " ERROR: intercept radius given " .. new_intercept_radius .. " is not a non-negative number");
		
		return false;
	end;
	
	-- if the abandon radius is not a number >= intercept radius + PATROL_MANAGER_MIN_INTERCEPT_TO_ABANDON_SPACING, then set it so
	if not (is_number(new_abandon_radius) and new_abandon_radius >= (new_intercept_radius + PATROL_MANAGER_MIN_INTERCEPT_TO_ABANDON_SPACING)) then
		-- if the user set it to be something else, warn them that we're resetting it
		if not is_nil(new_abandon_radius) then
			script_error(self.name .. " WARNING: abandon radius given " .. tostring(new_abandon_radius) .. " needs to be at least " .. PATROL_MANAGER_MIN_INTERCEPT_TO_ABANDON_SPACING .. "m bigger than given interception radius " .. new_intercept_radius .. ", setting it so");
		end;
		
		new_abandon_radius = new_intercept_radius + PATROL_MANAGER_MIN_INTERCEPT_TO_ABANDON_SPACING;
	end;
	
	-- if the guard radius is not a number >= 0, then set it to PATROL_MANAGER_DEFAULT_GUARD_RADIUS
	if not (is_number(new_guard_radius) and new_guard_radius >= 0) then
		-- if the user set it to be something else, warn them that we're resetting it
		if not is_nil(new_guard_radius) then
			script_error(self.name .. " WARNING: guard radius given " .. new_guard_radius .. " is a not a non-negative number, setting it to " .. PATROL_MANAGER_DEFAULT_GUARD_RADIUS .. "m");
		end;
		
		new_guard_radius = PATROL_MANAGER_DEFAULT_GUARD_RADIUS;
	end;
		
	pm = {};

	set_object_class(pm, self);
	
	pm.name = "Patrol_Manager_" .. new_name;
	pm.sunit = new_sunit;
	pm.enemy_armies = new_enemy_armies;
	pm.intercept_radius = new_intercept_radius;
	pm.abandon_radius = new_abandon_radius;
	pm.guard_radius = new_guard_radius;
	
	pm.waypoints = {};
	
	-- tweak the waypoint_reached threshold depending on the
	-- unit type (due to speed of unit)
	
	--if pm.sunit.unit:is_naval() then
		--pm.waypoint_reached_threshold = PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_NAVAL;
	--elseif self.sunit.unit:is_cavalry() then
		--pm.waypoint_reached_threshold = PATROL_MANAGER_WAYPOINT_REACHED_THRESHOLD_CAV;
	--end;
	
	return pm;
end;


--
--	Configuration functions
--


-- sets a callback to call if an intercept is triggered
function patrol_manager:set_intercept_callback(new_callback)
	if not is_function(new_callback) then
		script_error(self.name .. " ERROR: set_intercept_callback() called but callback supplied " .. tostring(new_callback) .. " is not a valid function!");
		
		return false;
	end;
	
	self.interception_callback = new_callback;
end;


-- sets a callback to call if an intercept is abandoned
function patrol_manager:set_abandon_callback(new_callback)
	if not is_function(new_callback) then
		script_error(self.name .. " ERROR: set_abandon_callback() called but callback supplied " .. tostring(new_callback) .. " is not a valid function!");
		
		return false;
	end;
	
	self.abandon_callback = new_callback;
end;


-- sets a callback to call if the subject unit completes the patrol
function patrol_manager:set_completion_callback(new_callback)
	if not is_function(new_callback) then
		script_error(self.name .. " ERROR: set_completion_callback() called but callback supplied " .. tostring(new_callback) .. " is not a valid function!");
		
		return false;
	end;
	
	self.completion_callback = new_callback;
end;


-- sets a custom walk speed for the unit
function patrol_manager:set_walk_speed(new_walk_speed)
	if not is_number(new_walk_speed) then
		script_error(self.name .. " ERROR: set_walk_speed() called but speed supplied " .. tostring(new_walk_speed) .. " is not a number!");
		
		return false;
	end;
	
	self.walk_speed = new_walk_speed;
end;


-- sets a callback to call if the subject unit routs
function patrol_manager:set_rout_callback(new_callback)
	if not is_function(new_callback) then
		script_error(self.name .. " ERROR: set_rout_callback() called but callback supplied " .. tostring(new_callback) .. " is not a valid function!");
		
		return false;
	end;
	
	self.rout_callback = new_callback;
end;


-- sets this patrol manager into debug mode (more output)
function patrol_manager:set_debug(value)
	if self.is_running then
		script_error(self.name .. " warning : trying to change debug state of a running patrol manager. This is undesirable, but doing it anyway.");
	end;

	if is_boolean(value) then
		self.is_debug = value;
	else
		self.is_debug = true;
	end;
end;


-- sets all patrol managers into debug mode
function patrol_manager:set_debug_all(value)
	if self.is_running then
		script_error(self.name .. " warning : trying to change global debug state of a running patrol manager. This is undesirable, but doing it anyway.");
	end;

	if is_boolean(value) then
		__patrol_manager_debug = value;
	else
		__patrol_manager_debug = true;
	end;
end;


-- sets whether the patrol manager is naval or not (should be deprecated soon..)
function patrol_manager:set_naval(value)
	if is_boolean(value) then
		self.is_naval = value;
	else
		self.is_naval = true;
	end;
end;


-- sets whether the patrol manager shuts down when the subject unit routs
function patrol_manager:set_stop_on_rout(value)
	if not is_boolean(value) then
		value = true;
	end;
	
	self.stop_on_rout = value;
end;


-- sets whether the patrol manager shuts down when intercept is first triggered
function patrol_manager:set_stop_on_intercept(value)
	if not is_boolean(value) then
		value = true;
	end;
	
	self.stop_on_intercept = value;
end;


-- sets the default width parameter
function patrol_manager:set_width(width)
	if not width or not is_number(width) or width <= 0 then
		script_error(self.name .. " WARNING: set_width() called but no width supplied or width invalid");
		
		return false;
	end;
	
	self.width = width;
end;


function patrol_manager:set_waypoint_threshold(dist)
	if not is_number(dist) or dist <= 1 then
		script_error(self.name .. " ERROR: set_waypoint_threshold() called but distance supplied is invalid, must be a positive integer!");
		
		return false;
	end;

	if self.is_running then
		script_error(self.name .. " ERROR: set_waypoint_threshold() called on running patrol manager!");
		
		return false;
	end;
	
	self.waypoint_reached_threshold = dist;
end;


-- sets the intercept time in ms, which is the time the subject unit charges down the
-- nearest enemy for when an intercept is triggered before being released to the AI
function patrol_manager:set_intercept_time(t)
	if not is_number(t) then
		script_error(self.name .. " WARNING: set_intercept_time() called but supplied time [" .. tostring(t) .. "] is not a number");
		
		return false;
	end;

	self.intercept_time = t;
end;


function patrol_manager:set_attack_with_primary_weapon(value)
	if value == false then
		self.attack_with_primary_weapon = false;
	else
		self.attack_with_primary_weapon = true;
	end;
end;


-- sets whether the patrol manager should loop or not
function patrol_manager:loop(value)
	if self.is_running then
		bm:out(self.name .. " WARNING: trying to change loop value of a running patrol manager. This is undesirable, but doing it anyway.");
	end;

	if is_boolean(value) then
		self.should_loop = value;
	else
		self.should_loop = true;
	end;
end;


-- forces the subject unit to always run
function patrol_manager:set_force_run(value)
	if is_boolean(value) then
		self.force_run = value;
	else
		self.force_run = true;
	end;
	
	if self.is_running and not self.sunit.unit:is_moving_fast() then
		-- re-issue the current order as a run
		self:move_to_current_waypoint();
	end;
end;




--
-- add waypoints to the patrol manager prior to starting
--
function patrol_manager:add_waypoint(new_dest, new_should_run, new_delay, new_orientation, new_width)

	local BOOL_Vector_Input = true;
	
	-- if we've been supplied a waypoint, unpack it (rather hacky..)
	if is_waypoint(new_dest) then
		new_width = new_dest.width;
		new_orientation = new_dest.orient;
		new_delay = new_dest.wait_time;
		new_should_run = new_dest.speed;
		new_dest = new_dest.pos;
	end;
	
	if is_vector(new_dest) then
		BOOL_Vector_Input = true;
	elseif is_unit(new_dest) then
		BOOL_Vector_Input = false;
	else
		script_error(self.name .. " ERROR: add_waypoint() called but no vector or unit supplied, object is " .. tostring(new_dest));
		
		return false;		
	end;
	
	local waypoint = {};
	local should_calc_orient_at_runtime = false;
	
	if not is_boolean(new_should_run) then
		if not is_nil(new_should_run) then
			-- not boolean and not nil = junk
			script_error(self.name .. " WARNING: add_waypoint() called but should run flag " .. tostring(new_should_run) .. " is junk, setting to false");
		end;
	
		new_should_run = false;
	end;
	
	if not is_number(new_delay) then
		if not is_nil(new_delay) then
			script_error(self.name .. " WARNING: add_waypoint() called but delay " .. tostring(new_delay) .. " is junk, setting to 0");
		end;
	
		new_delay = 0;
	elseif new_delay > 0 and new_delay < 100 then
		script_error(self.name .. " ERROR: add_waypoint() called but delay is less than 100, be sure to specify this in milliseconds rather than seconds!");
	end;
	
	if not is_number(new_orientation) then
		if not is_nil(new_orientation) then
			-- not number and not nil = junk
			script_error(self.name .. " WARNING: add_waypoint() called but orientation " .. tostring(new_orientation) .. " is junk, setting to 0");
		end;
			
		new_orientation = 0;
		should_calc_orient_at_runtime = true;
	end;
	
	-- if no width was supplied then use the default width. If that isn't set use the starting width of the sunit
	if not is_number(new_width) or new_width <= 0 then
		if is_number(self.width) and self.width > 0 then
			new_width = self.width;
		else
			new_width = self.sunit.start_width;
		end;
	end;
	
	if self.is_debug or __patrol_manager_debug then
		if BOOL_Vector_Input then
			bm:out(self.name .. " adding waypoint vector " .. v_to_s(new_dest) .. ", orient " .. new_orientation .. ", width " .. new_width .. ", delay " .. new_delay .. " and running " .. tostring(new_should_run));
		else
			bm:out(self.name .. " adding waypoint unit " .. new_dest:name() .. " at " .. v_to_s(new_dest:position()) .. ", running " .. tostring(new_should_run));
		end;		
	end;
		
	waypoint = {destination = new_dest, should_run = new_should_run, delay = new_delay, orientation = new_orientation, width = new_width, calc_orient_at_runtime = should_calc_orient_at_runtime};
	
	table.insert(self.waypoints, waypoint);
end;




--
-- returns the angle between the last waypoint in the patrol and an arbitrary pos, used to set orientation where none was supplied
--
function patrol_manager:get_angle_to_pos(source, target)
	if self.is_debug then
		bm:out(self.name .. ":get_angle_to_pos(" .. v_to_s(source) .. ", " .. v_to_s(target) .. ") called, returning " .. math.atan2(target:get_x() - source:get_x(), target:get_z() - source:get_z()));
	end;

	return math.atan2(target:get_x() - source:get_x(), target:get_z() - source:get_z());
end;






--
-- start the patrol manager
--
function patrol_manager:start(reason)
	if self.is_running then
		script_error(self.name .. " WARNING: tried to start but is already running");
		
		return false;
	end;

	if #self.waypoints == 0 then
		script_error(self.name .. " ERROR: tried to start patrol manager before adding any waypoints!");
		
		return false;
	end;
		
	self.is_running = true;
	
	-- stop this sunit's current patrol if it's running
	self.sunit:stop_current_patrol();
		
	-- register this patrol with the sunit
	self.sunit:set_current_patrol(self);

	self:cache_current_unit_pos();
		
	self:resume_patrol(PATROL_MANAGER_STARTING);
end;



-- cache the start position of the subject unit (so we can
-- work out the guard distance from there to the first waypoint)
function patrol_manager:cache_current_unit_pos()
	self.previous_pos = self.sunit.unit:position();
end;



--
-- resume/start a patrol
--
function patrol_manager:resume_patrol(reason)
	if not self.is_running then
		script_error(self.name .. " WARNING: resume_patrol() called but patrol manager isn't running");
		
		return false;
	end;
	
	if not self.is_intercepting and not (reason == PATROL_MANAGER_STARTING or reason == PATROL_MANAGER_UNIT_IS_NO_LONGER_ROUTING or reason == PATROL_MANAGER_INTERCEPT_AS_NORMAL) then
		bm:out(self.name .. " warning: resume_patrol() called when not intercepting and not routing, disregarding")
		
		return false;
	end;
		
	-- debug output
	if self.is_debug or __patrol_manager_debug then
		if reason == PATROL_MANAGER_LOST_UNIT then
			bm:out(self.name .. " abandoning pursuit, lost contact with enemy units");
		elseif reason == PATROL_MANAGER_PURSUED_TOO_FAR then
			bm:out(self.name .. " abandoning pursuit, pursued too far from guard vector");
		elseif reason == PATROL_MANAGER_INTERCEPT_AS_NORMAL then		
			bm:out(self.name .. " guard and intercept radius' now set to full values");
		elseif reason == PATROL_MANAGER_STARTING then
			bm:out(self.name .. " is starting");
		elseif reason == PATROL_MANAGER_UNIT_IS_NO_LONGER_ROUTING then
			bm:out(self.name .. " was routing but has now recovered");
		end;
	end;
	
	-- reset state of patrol manager
	self:stop_running_processes();
			
	-- watch for the subject unit routing while we perform this action
	self:watch_for_unit_routing();
	
	self.sunit.uc:take_control();
	
	-- resume the patrol. Force the patrol to run if we are leaving the guard area
	local force_run = false;
	
	if reason == PATROL_MANAGER_PURSUED_TOO_FAR then
		force_run = true;
	end;
	
	self:move_to_current_waypoint(force_run);
	
	self.is_intercepting = false;
	
	-- assemble an intercept test
	-- either we never intercept, we intercept when we're close to an enemy unit or 
	-- we intercept when we're close to an enemy unit AND close to the patrol path	
	if self.intercept_radius and self.intercept_radius > 0 then
		local intercept_test = nil;
			
		if self.guard_radius > 0 then
			-- we need to stay close to the patrol path
			
			-- if we are abandoning a chase, then shrink the intercept radius
			-- and guard radius a while so we don't keep picking up the same unit
			local guard_radius = self.guard_radius;
			local intercept_radius = self.intercept_radius;
			
			if reason == PATROL_MANAGER_PURSUED_TOO_FAR then
				guard_radius = guard_radius * PATROL_MANAGER_REINTERCEPT_GUARD_RADIUS_MODIFIER;
				intercept_radius = intercept_radius * PATROL_MANAGER_REINTERCEPT_INT_RADIUS_MODIFIER;
				
				-- eventually reset those values back to normal
				bm:callback(function() self:resume_patrol(PATROL_MANAGER_INTERCEPT_AS_NORMAL) end, PATROL_MANAGER_WAIT_BEFORE_NORMAL_REINTERCEPT, self.name)
			end;
			
			intercept_test = function() return self:is_enemy_in_range(intercept_radius) and self:is_in_range_of_patrol_path_segment(guard_radius) end;
		else
			-- we don't need to stay close to the patrol path
			intercept_test = function() return self:is_enemy_in_range(self.intercept_radius) end;
		end;
		
		-- watch our assembled intercept test
		bm:watch(
			function() return intercept_test() end,
			0,
			function() self:intercept() end,
			self.name
		);
	end;
	
	-- call the abandon callback if one exists
	if reason ~= PATROL_MANAGER_STARTING and self.abandon_callback then
		self.abandon_callback();
	end;
end;



--
-- sets the subject unit moving along the patrol to the current destination waypoint
--
function patrol_manager:move_to_current_waypoint(force_run)
	-- if we've run off the end of our waypoint list then finish
	if self.current_waypoint > #self.waypoints then
		self:complete(PATROL_MANAGER_REACHED_DESTINATION);
		
		return;
	end;
	
	-- stop any re-issueing orders
	bm:remove_process(self.name .. "_leg");
	
	local destination = self.waypoints[self.current_waypoint].destination;
	local BOOL_destination_is_vector = false;
	
	-- "destination" here could be a vector or a unit, determine which
	local dest_vector = 0;
	
	if is_vector(destination) then
		BOOL_destination_is_vector = true;
		
		dest_vector = destination;
	else
		dest_vector = destination:position();
	end;
	
	
	local dest_orientation = 0; 
	
	if self.waypoints[self.current_waypoint].calc_orient_at_runtime then
		dest_orientation = r_to_d(self:get_angle_to_pos(self.sunit.unit:position(), dest_vector));
	else
		dest_orientation = self.waypoints[self.current_waypoint].orientation;
	end;

	local dest_width = self.waypoints[self.current_waypoint].width;
	local dest_run = self.waypoints[self.current_waypoint].should_run or force_run or self.force_run;
	local dest_delay = self.waypoints[self.current_waypoint].delay;
	
	-- debug output
	if self.is_debug or __patrol_manager_debug then
		local prepend_string = "";
		
		if dest_run then
			prepend_string = self.name .. " running to ";
		else
			prepend_string = self.name .. " walking to ";
		end;
		
		if BOOL_destination_is_vector then
			prepend_string = prepend_string .. "position " .. v_to_s(destination) .. ", orient " .. dest_orientation .. " and width " .. dest_width;
		else
			prepend_string = prepend_string .. "intercept unit " .. destination:name() .. " at " .. v_to_s(destination:position());
		end;
		
		if dest_delay < 0 then
			prepend_string = prepend_string .. ", will wait there indefinitely";
		else
			prepend_string = prepend_string .. ", will wait there for " .. dest_delay .. "ms";
		end;
		
		bm:out(prepend_string);
	end;

	local movement_instruction = 0;
	local arrival_test = 0;
	
	-- assemble movement instructions and arrival tests depending on 
	-- whether our destination is a vector or a unit
	if BOOL_destination_is_vector then
		movement_instruction = function() self.sunit.uc:goto_location_angle_width(destination, dest_orientation, dest_width, dest_run) end;
		arrival_test = function() return self.sunit.unit:position():distance_xz(destination) < self.waypoint_reached_threshold end;
		
	else
		movement_instruction = function()
									self.sunit.uc:goto_location_angle_width(destination:position(), dest_orientation, dest_width, dest_run);
									
									bm:repeat_callback(
										function() 
											self.sunit.uc:goto_location_angle_width(destination:position(), dest_orientation, dest_width, dest_run)
										end, 
										PATROL_MANAGER_REORDER_INTERVAL, 
										self.name .. "_leg"
									)
								end;
		arrival_test = function() return is_routing_or_dead(destination) or self.sunit.unit:position():distance_xz(destination:position()) < self.waypoint_reached_threshold end;
	end;
	
	
	-- instruct the unit to move
	movement_instruction();
		
	-- if the delay time on this waypoint is positive
	-- watch to see when the unit has arrived
	bm:watch(
		function()
			return arrival_test()
		end,
		0,
		function()
			self:arrived_at_waypoint()
		end,
		self.name
	);
	
	-- change this unit's walk speed a fraction of a second later, if we need to
	if not dest_run and self.walk_speed ~= 1 then
		if self.is_debug or __patrol_manager_debug then
			bm:out("\tsetting walk speed to " .. tostring(self.walk_speed));
		end;
		
		bm:callback(function() self.sunit.uc:change_current_walk_speed(self.walk_speed) end, 100, self.name);
	end;
end;



--	unit has arrived at a waypoint, work out how long should it wait for
function patrol_manager:arrived_at_waypoint()
	local delay = self.waypoints[self.current_waypoint].delay;
	
	
	-- debug output
	if self.is_debug or __patrol_manager_debug then
		local prepend_string = self.name .. " has arrived at waypoint";
	
		if delay < 0 then
			prepend_string = prepend_string .. ", waiting indefinitely";
		elseif delay == 0 then
			prepend_string = prepend_string .. ", moving on immediately";
		else
			prepend_string = prepend_string .. ", waiting for " .. tostring(delay) .. "ms";
		end;
		
		bm:out(prepend_string);
	end;
	
	
	-- if delay on this waypoint is zero, move on immediately.
	-- if it's postive, wait that amount of time.
	-- if it's negative, never move on.	
	if delay == 0 then
		self:move_to_next_waypoint();
	elseif delay > 0 then
		bm:callback(function() self:move_to_next_waypoint() end, delay, self.name);
	end;
end;







--
-- advances the destination waypoint on to the next in the list
--
function patrol_manager:move_to_next_waypoint()
	-- if we're at the end of our patrol list, work out whether
	-- to go back round to the beginning or finish
	if self.current_waypoint >= #self.waypoints then
		if self.should_loop then
			self.current_waypoint = 0;
		else
			self:complete(PATROL_MANAGER_REACHED_DESTINATION);
			return;
		end;
	end;
	
	self:cache_current_unit_pos();
	
	self.current_waypoint = self.current_waypoint + 1;
		
	self:move_to_current_waypoint();
end;


--
-- start watching for our unit routing
--
function patrol_manager:watch_for_unit_routing()
	bm:watch(
		function() return is_routing_or_dead(self.sunit.unit) end,
		0,
		function() self:handle_unit_routing() end,
		self.name
	);
end;


--
-- our subject unit has routed, handle this
--
function patrol_manager:handle_unit_routing()
	if self.stop_on_rout then
		-- stop the patrol manager on rout
		self.sunit.uc:release_control();
		self:complete(PATROL_MANAGER_UNIT_IS_DEAD_OR_ROUTING);
	else
		-- don't stop the patrol manager on rout
		
		if self.is_debug or __patrol_manager_debug then
			bm:out(self.name .. " has routed but continuing to monitor state");
		end;
		
		-- watch for the unit moving to shattered state (in which case do stop
		-- the patrol manager as the unit definitely isn't coming back)
		
		bm:watch(
			function() return is_shattered_or_dead(self.sunit.unit) end,
			0,
			function() self:complete(PATROL_MANAGER_UNIT_IS_DEAD_OR_ROUTING) end,
			self.name
		);
		
		-- watch also for the unit un-routing, in which case
		-- jolt the patrol manager back into life
		bm:watch(
			function() return not is_routing_or_dead(self.sunit.unit) end,
			0,
			function() self:resume_patrol(PATROL_MANAGER_UNIT_IS_NO_LONGER_ROUTING) end,
			self.name
		)
	end;
end;


-- returns whether our unit is within a given range of an enemy (either intercept or abandon)
function patrol_manager:is_enemy_in_range(range)
	local current_pos = self.sunit.unit:position();
	local closest_unit = get_closest_standing_unit(self.enemy_armies, current_pos);
	
	if closest_unit and closest_unit:position():distance(current_pos) < range then
		return true;
	end;
	
	return false;
end;


-- returns if the sunit is close to the current patrol path segment
function patrol_manager:is_in_range_of_patrol_path_segment(range)
	-- current patrol path segment is defined as from the previous pos (which is either
	-- the previously reached waypoint along the line, or the position the unit started
	-- at) to the next waypoint.
	
	-- Current implementation of this returns an approximation, as it considers that
	-- line to be of infinite length. Theoretically it would be possible therefore to
	-- kite a unit along the line of the path segment forever. This calculation is much
	-- cheaper though.
	
	-- destination could be unit or vector
	local dest_pos = self.waypoints[self.current_waypoint].destination;
	
	if is_unit(dest_pos) then
		dest_pos = dest_pos:position();
	end;
	
	return (math.abs(distance_to_line(self.previous_pos, dest_pos, self.sunit.unit:position())) <= range);
end;



-- 
-- An intercept has been triggered
--
function patrol_manager:intercept()
	if not self.is_running then
		script_error(self.name .. " WARNING: intercept() called when patrol manager isn't running, disregarding");
		
		return false;
	end;
	
	if self.is_intercepting then
		script_error(self.name .. " WARNING: intercept() called when already intercepting, disregarding")
		
		return false;
	end;

	-- if we should stop on intercept then do so
	if self.stop_on_intercept then
		self:complete(PATROL_MANAGER_STOPPING_ON_INTERCEPT);
		return;
	end;
	
	local closest_unit = get_closest_standing_unit(self.enemy_armies, self.sunit.unit:position());
	
	if not is_unit(closest_unit) then
		self:complete(PATROL_MANAGER_COULDNT_FIND_TARGET);
		return;
	end;
	
	-- reset state of patrol manager
	self:stop_running_processes();
	
	-- debug output
	if self.is_debug or __patrol_manager_debug then
		bm:out(self.name .. " intercept triggered :: attacking " .. closest_unit:name() .. " at position " .. v_to_s(closest_unit:position()));
	end;
	
	-- watch for the subject unit routing while we perform this action
	self:watch_for_unit_routing();
	
	self.sunit.uc:take_control();
	
	self.is_intercepting = true;
	
	-- send the subject unit to attack the nearest unit
	self.sunit.uc:attack_unit(closest_unit, self.attack_with_primary_weapon, true);
	
	-- wait for the interception time and then release the subject unit to the AI
	if self.intercept_time >= 0 then
		bm:callback(
			function()
				if self.is_debug or __patrol_manager_debug then
					bm:out(self.name .. " : releasing unit to AI");
				end;
				self.sunit.uc:release_control();
			end, 
			self.intercept_time, 
			self.name
		);
	end;
	
	-- watch for us losing contact with the enemy
	bm:watch(function() return not self:is_enemy_in_range(self.abandon_radius) end, 0, function() self:resume_patrol(PATROL_MANAGER_LOST_UNIT) end, self.name);
		
	-- if we should guard the patrol path, watch for us losing contact with that as well
	if self.guard_radius > 0 then
		bm:watch(function() return not self:is_in_range_of_patrol_path_segment(self.guard_radius) end, 0, function() self:resume_patrol(PATROL_MANAGER_PURSUED_TOO_FAR) end, self.name);
	end;
	
	-- call the interception callback if one exists
	if self.interception_callback then
		self.interception_callback();
	end;
end;


-- stops any watches/callbacks associated with the patrol manager
function patrol_manager:stop_running_processes()
	bm:remove_process(self.name);
	bm:remove_process(self.name .. "_leg");
end;


-- restarts patrol manager, can be called externally
function patrol_manager:restart()
	if self.is_running then
		self:stop();
	end;

	self.current_waypoint = 1;
	
	if self.is_debug or __patrol_manager_debug then
		bm:out(self.name .. " restarting");
	end;
	
	self:start(PATROL_MANAGER_RESTARTING);
end;


-- begins shutdown of the patrol manager, should not be called externally
-- does debug output and works out end callbacks
function patrol_manager:complete(reason)
	if not self.is_running then
		return false;
	end;

	-- debug output
	if self.is_debug or __patrol_manager_debug then
		if reason == PATROL_MANAGER_REACHED_DESTINATION then
			bm:out(self.name .. " completed : unit has reached its destination");
		elseif reason == PATROL_MANAGER_UNIT_IS_DEAD_OR_ROUTING then
			bm:out(self.name .. " completed : unit is dead or routing");
		elseif reason == PATROL_MANAGER_STOPPING_ON_INTERCEPT then
			bm:out(self.name .. " completed : stopping on intercept");
		elseif reason == PATROL_MANAGER_COULDNT_FIND_TARGET then
			bm:out(self.name .. " completed : no-one left to attack?");
		else
			bm:out(self.name .. " completed for unknown reason");
		end;
	end;
	
	-- end callbacks - call rout callback or completion callback (if either exist)
	if reason == PATROL_MANAGER_UNIT_IS_DEAD_OR_ROUTING then
		if self.rout_callback then
			self.rout_callback();
		end;
	elseif self.completion_callback then
		self.completion_callback();
	end;
	
	self:stop();
end;


-- stop the patrol manager, either manually or as the last stage of it
-- stopping automatically (callbacks are handled in complete())
function patrol_manager:stop()
	if not self.is_running then	
		return false;
	end;
	
	-- debug output
	if self.is_debug or __patrol_manager_debug then
		bm:out(self.name .. " : stopping");
	end;
	
	self:stop_running_processes();
	
	self.is_running = false;
end;
















waypoint = {
	pos = nil,
	speed = false,
	wait_time = 0,
	orient = nil,
	width = nil
};


set_class_custom_type_and_tostring(waypoint, TYPE_WAYPOINT);




function waypoint:new(new_pos, new_speed, new_wait_time, new_orient, new_width)		
	-- type check our startup parameters
	if not is_vector(new_pos) then
		script_error("ERROR: Couldn't create waypoint, position parameter " .. tostring(new_pos) .. " is invalid");
		
		return false;
	end;
		
	if not is_boolean(new_speed) and not is_nil(new_speed) then
		script_error("WARNING: Creating waypoint but speed parameter " .. tostring(new_pos) .. " is junk, setting it to false");
		
		new_speed = false;
	end;
	
	if not is_number(new_wait_time) and not is_nil(new_wait_time) then
		script_error("WARNING: Creating waypoint but wait time parameter " .. tostring(new_wait_time) .. " is junk, setting it to 0");
		
		new_wait_time = 0;
	end;
	
	if not is_number(new_orient) and not is_nil(new_orient) then
		script_error("WARNING: Creating waypoint but orient parameter " .. tostring(new_orient) .. " is junk, setting it to nil");
		
		new_orient = nil;
	end;
	
	if not is_number(new_width) and not is_nil(new_width) then
		script_error("WARNING: Creating waypoint but width parameter " .. tostring(new_width) .. " is junk, setting it to nil");
		
		new_width = nil;
	end;
		
	
	-- set up the waypoint
	w = {};

	set_object_class(w, self);
	
	w.pos = new_pos;
	w.speed = new_speed;
	w.wait_time = new_wait_time;
	w.orient = new_orient;
	w.width = new_width;
	
	return w;
end;