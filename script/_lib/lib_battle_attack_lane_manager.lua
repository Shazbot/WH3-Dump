








attack_lane_manager = {
	name = "",									-- unique name for this alm, for debug output
	lanes = {},									-- internal list of lanes kept by this alm
	sunits = false,								-- sunits collection of units this alm will control
	enemy_armies = false,						-- armies collection object representing the enemies of these sunits. This is computed when the alm is started
	intercept_radius = false,					-- opt intercept radius for the underlying patrol managers
	default_melee_intercept_radius = 30, 		-- default intercept radius for melee units
	default_ranged_intercept_radius = 80, 		-- default intercept radius for ranged units
	patrol_managers = {},						-- list of patrol manager objects
	is_started = false,							-- set to true when start is called, false when stop is called
	is_debug = false							-- should print debug output
};


set_class_custom_type_and_tostring(attack_lane_manager, TYPE_ATTACK_LANE_MANAGER);





--- @function new
--- @desc Creates and returns a new attack_lane_manager object.

function attack_lane_manager:new(name, sunits, intercept_radius)
	if not is_string(name) then
		script_error("ERROR: attack_lane_manager:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	name = "attack_lane_manager_" .. name;

	if not is_scriptunits(sunits) then
		script_error(name .. " ERROR: attack_lane_manager:new() called but supplied scriptunits [" .. tostring(sunits) .. "] is not a valid scriptunits collection object");
		return false;
	end;

	if not sunits:count() == 0 then
		script_error(name .. " ERROR: attack_lane_manager:new() called but supplied scriptunits [" .. tostring(sunits) .. "] is not a valid scriptunits collection object");
		return false;
	end;

	if intercept_radius then
		if not is_number(intercept_radius) or intercept_radius < 0 then
			script_error(name .. " ERROR: attack_lane_manager:new() called but supplied intercept radius is not a positive number or nil");
			return false;
		end;
	end;

	local alm = {};
	
	set_object_class(alm, self);

	alm.name = name;
	alm.sunits = sunits;
	alm.lanes = {};
	-- alm.patrol_managers = {};		-- initialised later

	alm.intercept_radius = intercept_radius;

	return alm;
end;


function attack_lane_manager:set_debug(value)
	if value == false then
		self.is_debug = false;
	else
		self.is_debug = true;
	end;
end;


function attack_lane_manager:add_lane(...)
	if arg.n == 0 then
		script_error(self.name .. " ERROR: add_lane() called but no waypoints supplied");
		return false;
	end;

	local lane = {};

	for i = 1, arg.n do
		if not is_vector(arg[i]) then
			script_error(self.name .. " ERROR: add_lane() called but the value of argument [" .. i .. "] is [" .. tostring(arg[i]) .. "] and not a vector");
			return false;
		end;

		table.insert(lane, arg[i]);
	end;

	if self.is_debug then
		local out_str = self.name .. " is adding lane with waypoints ";
		for i = 1, arg.n do
			if i == arg.n then
				out_str = out_str .. v_to_s(arg[i]);
			else
				out_str = out_str .. v_to_s(arg[i]) .. ", ";
			end;
		end;
		out(out_str);
	end;

	table.insert(self.lanes, lane);
end;


function attack_lane_manager:start()

	if self.is_started then
		return;
	end;

	self.is_started = true;

	self.patrol_managers = {};

	-- get a handle to the enemy armies object
	self.enemy_armies = self.sunits:item(1):get_enemy_alliance():armies();

	if self.is_debug then
		out(self.name .. " starting, assigning " .. self.sunits:count() .. " units");
		out.inc_tab();
	end;

	-- start assigning attackers to lanes
	self:assign_attacker_to_lane(self:get_lanes_copy());

	if self.is_debug then
		out.dec_tab();
	end;
end;


function attack_lane_manager:get_lanes_copy()
	local copy = {};
	for i = 1, #self.lanes do
		copy[i] = self.lanes[i];
	end;
	return copy;
end;


function attack_lane_manager:assign_attacker_to_lane(lanes_to_consider, lane_starting_positions)

	-- if our list of lanes to consider is empty then use the full list stored by the manager
	if #lanes_to_consider == 0 then
		lanes_to_consider = self:get_lanes_copy();
		lane_starting_positions = false;
	end;

	-- get a list of unassigned sunits
	local unassigned_sunits = self.sunits:filter("unassigned", function(sunit) return sunit["alm_" .. self.name .. "_assigned"] ~= true end);
	
	if unassigned_sunits:count() == 0 then
		-- all units assigned, so start all patrols
		for i = 1, #self.patrol_managers do
			self.patrol_managers[i]:start();
		end;
		return;
	end;

	-- if we don't have a list of lane starting positions, which is just a table of the first positions in each lane, then build one
	if not lane_starting_positions then
		lane_starting_positions = {};
		for i = 1, #lanes_to_consider do
			lane_starting_positions[i] = lanes_to_consider[i][1];
		end;
	end;

	-- get the closest sunit/lane start position combination
	local closest_sunit, distance, closest_lane_start_pos = unassigned_sunits:get_closest(lane_starting_positions, true);

	-- now that we have the closest lane starting position, work out which lane it was actually from
	local lane_index = 0;
	for i = 1, #lane_starting_positions do
		if closest_lane_start_pos == lane_starting_positions[i] then
			lane_index = i;
		end;
	end;

	local intercept_radius;
	if self.intercept_radius then
		intercept_radius = self.intercept_radius;
	else
		if closest_sunit.unit:can_use_behaviour("skirmish") then
			-- assume that if this unit has the skirmish ability they are considered "ranged"
			intercept_radius = self.default_ranged_intercept_radius;
		else
			intercept_radius = self.default_melee_intercept_radius;
		end;
	end;

	-- construct a patrol manager for this scriptunit
	local pm = patrol_manager:new(
		closest_sunit.name .. "_" .. self.name,
		closest_sunit,
		self.enemy_armies,
		intercept_radius
	);
	pm:set_intercept_time(-1);

	closest_sunit["alm_" .. self.name .. "_assigned"] = true;

	if self.is_debug then
		out("assigning " .. closest_sunit.name .. " at " .. v_to_s(closest_sunit.unit:position()) .. " to lane starting with position " .. v_to_s(lane_starting_positions[lane_index]));
		out.inc_tab();
		pm:set_debug(true);
	end;

	-- add the waypoints in the selected lane to the patrol manager
	for i = 1, #lanes_to_consider[lane_index] do
		pm:add_waypoint(lanes_to_consider[lane_index][i], true);
	end;

	if self.is_debug then
		out.dec_tab();
	end;

	-- add constructed patrol manager to our internal list
	table.insert(self.patrol_managers, pm);

	-- remove this lane from the lanes to consider, so that it's not picked again until the lanes to consider list is refreshed
	table.remove(lanes_to_consider, lane_index);
	table.remove(lane_starting_positions, lane_index);

	self:assign_attacker_to_lane(lanes_to_consider, lane_starting_positions);
end;


function attack_lane_manager:stop()
	if not self.is_started then
		return;
	end;

	self.is_started = false;

	if self.is_debug then
		out(self.name .. " is stopping");
	end;

	-- stop all running patrol managers
	for i = 1, #self.patrol_managers do
		self.patrol_managers:stop();
	end;
end;


