

---------------------------------------------------------------
--
-- SCRIPT AI PLANNER
--
--- @set_environment battle
--- @c script_ai_planner Script AI Planner
--- @desc The underlying battle scripting system provides support for the creation of ai planners, which are groups of units that are given high-level orders (e.g. defend this position/attack that unit) and left to carry it out in a semi-autonomous fashion. This functionality has also been exposed to the player in the past, allowing them to farm off control of their own units to the AI.
--- @desc The script ai planner is a wrapper interface for this system. It allows a scripted ai group to be created, units to be added to it, and for that group to be given high-level orders, many of which are script-level constructs (e.g. multiple "move-to-position" commands being daisychained into a "patrol" command).
--- @desc As the units in the script ai planner carry out their orders they do so under AI control, so they may decide to respond to live threats and opportunities.
---------------------------------------------------------------



----------------------------------------------------------------------------
--	Declaration
----------------------------------------------------------------------------

SCRIPT_AI_PLANNER_NO_ORDER = 0;
SCRIPT_AI_PLANNER_DEFEND_POSITION = 1;
SCRIPT_AI_PLANNER_ATTACK_UNIT = 2;
SCRIPT_AI_PLANNER_MERGE_INTO = 3;
SCRIPT_AI_PLANNER_PATROL = 4;
SCRIPT_AI_PLANNER_DEFEND_POSITION_OF_SUNIT = 5;
SCRIPT_AI_PLANNER_MOVE_TO_POSITION = 6;
SCRIPT_AI_PLANNER_MOVE_TO_POSITION_OF_SUNIT = 7;
SCRIPT_AI_PLANNER_MOVE_TO_FORCE = 8;
SCRIPT_AI_PLANNER_ALL_CONTROLLED_SUNITS_ROUTED = 9;
SCRIPT_AI_PLANNER_DEFEND_FORCE = 10;
SCRIPT_AI_PLANNER_ATTACK_FORCE = 11;
SCRIPT_AI_PLANNER_RUSH_UNIT = 12;
SCRIPT_AI_PLANNER_RUSH_FORCE = 13;



script_ai_planner = {
	name = "",
	alliance = nil,
	planner = nil,
	current_order = SCRIPT_AI_PLANNER_NO_ORDER,
	current_dest = nil,
	current_radius = nil,
	current_target = nil,
	end_callback = nil,
	completion_callback = nil,
	enemy_force = nil,
	is_debug = false,
	merge_target = false,
	perform_patrol_prox_text = true,
	merge_distance = 120,
	patrol_enemy_distance = 100,
	patrol_waypoint_distance = 75,
	patrol_defend_radius = 100,
	move_to_force_reorder_interval = 15000,
	sunit_list = {},
	waypoint_list = {},
	reorder_interval = 30000,
	should_reorder =  true
};


set_class_custom_type_and_tostring(script_ai_planner, TYPE_SCRIPT_AI_PLANNER);










----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a script_ai_planner object. A script ai planner must be given a string name and at least one unit in either a @script_units, @script_unit or table argument. This unit/these units will be placed under the control of the script_ai_planner being created.
--- @p string name, Name for script ai planner.
--- @p object units, Unit(s) to be controlled by the script ai planner. Supported types are @script_unit, @script_units, or a numerically-index table of script units. Units may be added or removed at a later time.
--- @p [opt=false] boolean debug mode, Activate debug mode, for more output.
--- @r script_ai_planner
function script_ai_planner:new(new_name, new_sunits, is_debug)
	local sai = {};
	
	set_object_class(sai, self);
	
	if not is_string(new_name) then
		script_error("ERROR: tried to create script_ai_planner but supplied name " .. tostring(new_name) .. " is not a string");
		return false;
	end;
		
	if is_scriptunits(new_sunits) then
		if new_sunits:count() > 0 then
			sai.alliance = new_sunits:item(1):alliance();
		else
			script_error("ERROR: tried to create script_ai_planner with name [" .. new_name .. "] but supplied sunits collection with name [" .. new_sunits.name .. "] is empty");
			return false;
		end;
	elseif is_scriptunit(new_sunits) then
		sai.alliance = new_sunits:alliance();
		new_sunits = {new_sunits};
	else
		if not is_table(new_sunits) then
			script_error("ERROR: tried to create script_ai_planner but supplied sunit list [" .. tostring(new_sunits) .. "] is not a scriptunits collection, a scriptunit object, or a table of scriptunit objects");
			return false;
		end;
		
		if not is_scriptunit(new_sunits[1]) then
			script_error("ERROR: tried to create script_ai_planner but first element in supplied list is not a sunit but a [" .. tostring(new_sunits[1]) .. "]");
			return false;
		end;
	
		sai.alliance = new_sunits[1]:alliance();
	end;
		
	sai.planner = sai.alliance:create_ai_unit_planner();
	
	sai.name = "SAI_" .. new_name;
	sai.sunit_list = {};
	sai.waypoint_list = {};
	sai.is_debug = not not is_debug; -- force boolean
	
	if not sai:add_sunits(new_sunits) then
		return false;
	end;
	
	return sai;
end;











----------------------------------------------------------------------------
--- @section Debug mode
----------------------------------------------------------------------------


--- @function set_debug
--- @desc Sets debug mode on this script_ai_planner.
--- @p boolean debug mode
function script_ai_planner:set_debug(value)
	if value or value == nil then
		self.is_debug = true;
	else
		self.is_debug = false;
	end; 	
end;











----------------------------------------------------------------------------
--- @section Adding and removing Scriptunits
----------------------------------------------------------------------------


--- @function add_sunits
--- @desc Adds one or more @script_unit objects to the script_ai_planner. Each @script_unit added must be in the same alliance as those already in the script_ai_planner.
--- @p object scriptunits to add, Scriptunits to add. Supported argument types are a single @script_unit, @script_units or a table of @script_unit objects.
function script_ai_planner:add_sunits(input)	
	-- construct a table out of our input (if it's not already)
	if is_scriptunit(input) then
		input = {input};
	elseif is_scriptunits(input) then
		input = input:get_sunit_table();
	end;

	if not is_table(input) then
		script_error(self.name .. " ERROR: add_sunits() called but supplied list " .. tostring(input) .. " is not a table or a sunit!");
		
		return false;
	end;
	
	-- make a copy of our input in case bits of it start disappearing
	-- as we remove units from other script_ai_planners
	local new_sunits = {};
	
	for i = 1, #input do
		new_sunits[i] = input[i];
	end;
	
	local count_sunits_added = 0;
	local sunits_added_string = "";
	
	for i = 1, #new_sunits do
		local new_sunit = new_sunits[i];
	
		if not is_scriptunit(new_sunit) then
			script_error(self.name .. " ERROR: add_sunits() called but object " .. i .. " in list is not a scriptunit but a " .. tostring(new_sunit));
			
			return false;
		end;
		
		-- if we don't have an alliance, then take the one from this script unit
		if not self.alliance then
			self.alliance = new_sunit:alliance();
		else
		
			-- check that this scriptunit is in the same alliance
			if new_sunit:alliance() ~= self.alliance then
				script_error(self.name .. " ERROR: add_sunits() called but scriptunit " .. i .. " in list, " .. new_sunit.name .. ", is not of required alliance " .. tostring(self.alliance) .. " but of alliance " .. tostring(new_sunit:alliance()) .. " instead");
				
				return false;
			end;
		end;
		
		-- check to see if we already have this sunit
		local skip_sunit = false;
		
		for j = 1, #self.sunit_list do
			if new_sunit.name == self.sunit_list[j].name then
				skip_sunit = true;
			end;
		end;
		
		if not skip_sunit then
			-- add this sunit to our internal list
			table.insert(self.sunit_list, new_sunit);
			
			-- if this sunit is currently attached to a different script_ai_planner, detach it
			if new_sunit.planner then
				new_sunit.planner:remove_sunits(new_sunit);
			end;
			
			-- add unit to planner
			-- adds callback with name built from planner and sunit name to allow this callback to be cancelled
			bm:callback(function() self.planner:add_units(new_sunit.unit) end, 400, self.name .. "_adding_" .. new_sunit.name);
			-- self.planner:add_units(new_sunit.unit);
			
			-- register this planner on the sunit
			new_sunit.planner = self;
			
			if count_sunits_added == 0 then
				sunits_added_string = new_sunit.name;
			else
				sunits_added_string = sunits_added_string .. "|" .. new_sunit.name;
			end;
			
			count_sunits_added = count_sunits_added + 1;
		else
			skip_sunit = false;
		end;
	end;
	
	if self.is_debug then
		if count_sunits_added > 0 then
			sunits_added_string = " [" .. sunits_added_string .. "]";
		end;
		bm:out(self.name .. ":add_sunits() called, added " .. tostring(count_sunits_added) .. sunits_added_string);
	end;
	
	return true;
end;


--- @function remove_sunits
--- @desc Removes one or more @script_unit objects from the script_ai_planner.
--- @p object scriptunits to remove, Scriptunits to remove. Supported argument types are a single @script_unit, @script_units or a table of @script_unit objects.
function script_ai_planner:remove_sunits(input)
	-- construct a table out of our input (if it's not already)
	if is_scriptunit(input) then
		input = {input};
	elseif is_scriptunits(input) then
		input = input:get_sunit_table();
	elseif not is_table(input) then
		script_error(self.name .. " ERROR: remove_sunits() called but supplied list " .. tostring(input) .. " is not a table, a scriptunits collection or a scriptunit");
		return false;
	end;
	
	local count_sunits_deleted = 0;
	local sunits_deleted_string = "";

	local sunit_list = self.sunit_list;
	
	for i = 1, #input do
		local current_input_sunit = input[i];
	
		if not is_scriptunit(current_input_sunit) then
			script_error(self.name .. " ERROR: remove_sunits() called but object " .. i .. " in list is not a scriptunit but a " .. tostring(current_input_sunit));
			return false;
		end;
		
		-- remove any pending process that would add this sunit to the planner
		bm:remove_process(self.name .. "_adding_" .. current_input_sunit.name);
		
		-- Try and find the current input scriptunit in the internal list
		for j = 1, #sunit_list do
			local current_sunit = sunit_list[j];

			if not current_sunit.is_being_removed_from_planner and current_input_sunit.name == current_sunit.name then
				-- mark this sunit for removal from our sunit list/planner
				current_sunit.is_being_removed_from_planner = true;
				
				count_sunits_deleted = count_sunits_deleted + 1;

				if self.is_debug then
					if i == 1 then
						sunits_deleted_string = current_input_sunit.name;
					else
						sunits_deleted_string = sunits_deleted_string .. "|" .. current_input_sunit.name;
					end;
				end;

				break;
			end;
		end;
	end;

	-- Rebuild our internal sunit list if we've marked any sunits for removal
	if count_sunits_deleted > 0 then
		local new_sunit_list = {};

		for i = 1, #sunit_list do
			local current_sunit = sunit_list[i];
			if current_sunit.is_being_removed_from_planner then
				-- remove from our planner object
				self.planner:remove_units(current_sunit.unit);
			
				-- unmark this sunit
				current_sunit.planner = nil;

				current_sunit.is_being_removed_from_planner = nil;
			else
				table.insert(new_sunit_list, current_sunit);
			end;
		end;

		self.sunit_list = new_sunit_list;
	end;

	if self.is_debug then
		bm:out(self.name .. ":remove_sunits() called, removed " .. count_sunits_deleted .. " sunits [" .. sunits_deleted_string .. "]");
	end;
end;


--- @function count
--- @desc Returns the number of units currently belonging to this ai planner
--- @r number count
function script_ai_planner:count()
	return #self.sunit_list;
end;



--- @function release
--- @desc Removes all units and releases control of them to the ai/player.
function script_ai_planner:release()
	bm:remove_process(self.name);
	
	self:ensure_units_are_released();
	
	self:remove_sunits(self.sunit_list);
end;


-- for internal use
function script_ai_planner:ensure_units_are_released()
	for i = 1, #self.sunit_list do
		local current_sunit = self.sunit_list[i];
		current_sunit.uc:release_control();
	end;
end;







----------------------------------------------------------------------------
--- @section Tests
----------------------------------------------------------------------------


--- @function any_controlled_sunit_standing
--- @desc Returns true if any controlled unit is still alive/not-routed, false otherwise.
--- @r boolean any standing
function script_ai_planner:any_controlled_sunit_standing()
	for i = 1, #self.sunit_list do
		local current_sunit = self.sunit_list[i];
		if not is_routing_or_dead(current_sunit) then		
			return true;
		end;
	end;
		
	return false;
end;


--- @function get_centre_point
--- @desc Returns a vector position of the mean centre of all units this script_ai_planner controls.
--- @r vector centre position
function script_ai_planner:get_centre_point()
	if #self.sunit_list == 0 then
		return v(0, 0, 0);
	end;
	
	return centre_point_table(self.sunit_list);
end;










----------------------------------------------------------------------------
--	Re-issuing order
----------------------------------------------------------------------------

-- for internal use
function script_ai_planner:reissue_current_order()
	local current_order = self.current_order;
	
	if current_order == SCRIPT_AI_PLANNER_NO_ORDER then
		return;
	elseif current_order == SCRIPT_AI_PLANNER_DEFEND_POSITION then
		self:defend_position(self.current_dest, self.current_radius, true);
	elseif current_order == SCRIPT_AI_PLANNER_ATTACK_UNIT then
		self:attack_unit(self.current_target, true);
	elseif current_order == SCRIPT_AI_PLANNER_RUSH_UNIT then
		self:rush_unit(self.current_target, true);
	elseif current_order == SCRIPT_AI_PLANNER_MERGE_INTO then
		self:merge_into(self.merge_target, true);
	elseif current_order == SCRIPT_AI_PLANNER_PATROL then
		self:patrol(self.waypoint_list,	self.enemy_force, self.completion_callback, true);	
	elseif current_order == SCRIPT_AI_PLANNER_DEFEND_POSITION_OF_SUNIT then
		self:defend_position_of_sunit(self.current_target, self.current_radius, self.end_callback);
	elseif current_order == SCRIPT_AI_PLANNER_MOVE_TO_POSITION then
		self:move_to_position_action(self.current_dest, true);
	elseif current_order == SCRIPT_AI_PLANNER_MOVE_TO_POSITION_OF_SUNIT then
		self:move_to_position_of_sunit(self.current_target, self.end_callback, true, false)
	elseif current_order == SCRIPT_AI_PLANNER_MOVE_TO_FORCE then
		self:move_to_force(self.enemy_force, true);
	elseif current_order == SCRIPT_AI_PLANNER_DEFEND_FORCE then
		self:move_to_force(self.enemy_force, true, self.current_radius);
	elseif current_order == SCRIPT_AI_PLANNER_ATTACK_FORCE then
		self:attack_force(self.enemy_force, true);
	elseif current_order == SCRIPT_AI_PLANNER_RUSH_FORCE then
		self:rush_force(self.enemy_force, true);
	else
		script_error(self.name .. " WARNING: reissue_current_order() called but couldn't recognise current order [" .. current_order .. "], it probably needs to be added to this function");
	end;
end;










----------------------------------------------------------------------------
--- @section Moving
----------------------------------------------------------------------------


--- @function move_to_position
--- @desc Instructs the script_ai_planner to move its units to a position. This will supercede any previously-issued order.
--- @p vector position
function script_ai_planner:move_to_position(pos)
	if not is_vector(pos) then
		script_error(self.name .. " ERROR: move_to_position() called but supplied position [" .. tostring(pos) .. "] is not a vector!");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	if self.is_debug then
		bm:out(self.name .. ":move_to_position() called, position is " .. v_to_s(pos));
	end;
	
	self.current_order = SCRIPT_AI_PLANNER_MOVE_TO_POSITION;

	self:move_to_position_action(pos);
end;



-- part of move_to_position that does the action. Not to be called externally as it doesn't cancel other processes
function script_ai_planner:move_to_position_action(pos, reorder, do_not_reorder)
	do_not_reorder = false or do_not_reorder;
	
	-- ensure our units are released to the AI
	self:ensure_units_are_released();

	-- give the order to our units
	self.planner:move_to_position(pos);
	
	-- give this order again in 30 secs if we have any units left
	if not do_not_reorder and self.should_reorder then
		bm:callback(
			function()
				if self:any_controlled_sunit_standing() then
					self:move_to_position_action(pos, true, do_not_reorder);
				end;
			end, 
			self.reorder_interval, 
			self.name
		);
	end;
	
	if reorder and self.is_debug then
		bm:out(self.name .. " being reordered by move_to_position_action() to " .. v_to_s(pos));
	end;
		
	self.current_dest = pos;
end;


--- @function move_to_position_of_sunit
--- @desc Instructs the script_ai_planner to move its units to the position of a supplied @script_unit, tracking the target as it moves. The supplied script_unit may be allied with or enemies of the units controlled by this script_ai_planner.
--- @p script_unit target sunit, Target @script_unit.
--- @p function rout callback, Function callback to call if the target @script_unit routs or dies, or if the target unit's position is reached.
function script_ai_planner:move_to_position_of_sunit(sunit, end_callback, reorder, internal)
	if not is_scriptunit(sunit) then
		script_error(self.name .. " ERROR: move_to_position_of_sunit() called but supplied sunit " .. tostring(sunit) .. " is not a scriptunit!");
		
		return false;
	end;
	
	if not is_function(end_callback) then
		end_callback = nil;
	end;
		
	local pos = sunit.unit:position();
	
	-- if this is an external order (i.e. not passed down from move_to_force or similar), then reorder the script ai planner and do debug output
	if not internal then
		bm:remove_process(self.name);
	
		self.current_order = SCRIPT_AI_PLANNER_MOVE_TO_POSITION_OF_SUNIT;
		self.current_target = sunit;
		self.end_callback = end_callback;
		
		if self.is_debug then
			if reorder then
				bm:out(self.name .. ":move_to_position_of_sunit() target " .. sunit.name .. " is now at " .. v_to_s(pos));
			else
				bm:out(self.name .. ":move_to_position_of_sunit() called, target is " .. sunit.name .. " at " .. v_to_s(pos));
			end;
		end;
		
		-- watch for our target unit routing
		bm:watch(
			function()
				return is_routing_or_dead(sunit.unit)
			end,
			0,
			function()
				self:move_to_position_of_sunit_complete(sunit, end_callback);
			end,
			self.name
		);
	end;
		
	-- give the order to our units	
	self:move_to_position_action(pos, false, true);
		
	-- watch for our target unit moving and update if it moves too far away from our current destination
	bm:watch(
		function()
			return sunit.unit:position():distance(self.current_dest) > 25
		end,
		0,
		function()
			self:move_to_position_of_sunit(sunit, end_callback, true, internal)
		end,
		self.name
	);
end;


-- for internal use
function script_ai_planner:move_to_position_of_sunit_complete(sunit, end_callback)
	if self.is_debug then
		bm:out(self.name .. ":move_to_position_of_sunit() has completed, target " .. sunit.name .. " is routing or dead. Remaining at " .. v_to_s(self.current_dest) .. " until ordered otherwise");
	end;
	
	bm:remove_process(self.name);
	
	if is_function(end_callback) then
		end_callback();
	end;
end;


--- @function move_to_force
--- @desc Instructs the script_ai_planner to move its units to the position of a supplied force, tracking the target as it moves. The supplied force may be allied with or enemies of the units controlled by this script_ai_planner.
--- @p object target force, Target force. May be a @script_units collection or a table of @script_unit objects.
-- note, setting a defend_radius causes move_to_force to issue a defend order instead of a movement order (defend_force just calls this instead of duplicating logic)
function script_ai_planner:move_to_force(enemy_force, reorder, defend_radius)

	-- should we attack or actually defend
	local function_name = "move_to_force()";
	local should_defend = false;
	
	if is_number(defend_radius) and defend_radius > 0 then
		function_name = "defend_force()";
		should_defend = true
	end;
	
	if is_scriptunits(enemy_force) then
		enemy_force = enemy_force:get_sunit_table();
	end;
	
	if not is_table(enemy_force) then
		script_error(self.name .. " ERROR: " .. function_name .. " called but supplied force [" .. tostring(enemy_force) .. "] is not a table!");
		return false;
	end;
	
	-- check that we have some non-routing units to order
	if is_routing_or_dead(self.sunit_list) then
		if self.is_debug then
			bm:out(self.name .. ":" .. function_name .. " called but all controlled units are routing, doing nothing");
			return;
		end;
	end;

	-- get closest enemy
	local closest_enemy = nil;
	local closest_enemy_dist = 5000;
	
	for i = 1, #enemy_force do
		local curr_enemy_sunit = enemy_force[i];
		
		if is_scriptunit(curr_enemy_sunit) then
			if not is_routing_or_dead(curr_enemy_sunit.unit) then
				local closest_standing_unit = get_closest_standing_unit(self.sunit_list, curr_enemy_sunit.unit:position());
				
				if closest_standing_unit then
					local curr_enemy_sunit_dist = closest_standing_unit:position():distance(curr_enemy_sunit.unit:position());
					
					if curr_enemy_sunit_dist < closest_enemy_dist then
						closest_enemy = curr_enemy_sunit;
						closest_enemy_dist = curr_enemy_sunit_dist;
					end;
				end;
			end;
		else
			script_error(self.name .. " ERROR: " .. function_name .. " called but item " .. i .. " [" .. tostring(curr_enemy_sunit) .. " ]  of supplied force [" .. tostring(enemy_force) .. "] is not a scriptunit");
			return false;
		end;
	end;
	
	-- only give the order if we have a valid target
	if not closest_enemy then
		if self.is_debug then
			bm:out(self.name .. ":" .. function_name .. " called but couldn't find any non-routing targets!");
		end;
		return;
	end;
	
	local reorder_function = function()
		bm:callback(function() self:move_to_force(enemy_force, true, defend_radius) end, self.move_to_force_reorder_interval, self.name);
	end;
	
		
	-- if we're rescanning, only re-order if our target has changed
	if reorder and self.current_target == closest_enemy then
	
		-- reorder every so often, so that we continually home on the nearest target
		reorder_function();
		
		return;
	end;
	
	bm:remove_process(self.name);
	
	-- reorder every so often, so that we continually home on the nearest target
	reorder_function();

	self.enemy_force = enemy_force;
	self.current_target = closest_enemy;
		
	if self.is_debug then
		if reorder then
			if should_defend then
				bm:out(self.name .. " defend_force() now defending closest target " .. closest_enemy.name .. " at " .. v_to_s(closest_enemy.unit:position()));
			else
				bm:out(self.name .. " move_to_force() now targeting closest enemy " .. closest_enemy.name .. " at " .. v_to_s(closest_enemy.unit:position()));
			end;
		else
			if should_defend then
				bm:out(self.name .. " defend_force() called, defending closest target " .. closest_enemy.name .. " at " .. v_to_s(closest_enemy.unit:position()));
			else
				bm:out(self.name .. " move_to_force() called, targeting closest enemy " .. closest_enemy.name .. " at " .. v_to_s(closest_enemy.unit:position()));
			end;
		end;
	end;
	
	-- give the order itself
	if should_defend then
		self.current_order = SCRIPT_AI_PLANNER_DEFEND_FORCE;
		self:defend_position_of_sunit(closest_enemy, defend_radius, nil, true);
	else
		self.current_order = SCRIPT_AI_PLANNER_MOVE_TO_FORCE;
		self:move_to_position_of_sunit(closest_enemy, nil, false, true);
	end;
	
	-- watch for target unit routing
	bm:watch(
		function()
			return is_routing_or_dead(closest_enemy.unit)
		end,
		0,
		function()
			self:move_to_force(enemy_force, true, defend_radius);
		end,
		self.name
	);
end;








----------------------------------------------------------------------------
--- @section Defending
--- @desc A script_ai_planner may be instructed to defend a position, much as it can be instructed to move. Defend orders result in different formation postures being adopted and may result in the order being carried out with a different sense of urgency, compared to move orders.
----------------------------------------------------------------------------


--- @function defend_position
--- @desc Instructs the script_ai_planner to defend a position on the battlefield. Alongside a vector position a radius must be supplied, which sets how tightly bound to the position the controlled units are.
--- @p vector position to defend
--- @p radius radius in m
function script_ai_planner:defend_position(pos, radius, reorder)
	if not is_vector(pos) then
		script_error(self.name .. " ERROR: defend_position() called but supplied position " .. tostring(pos) .. " is not a vector!");
		
		return false;
	end;
	
	if not is_number(radius) then
		script_error(self.name .. " ERROR: defend_position() called but supplied radius " .. tostring(radius) .. " is not a number!");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	self.current_order = SCRIPT_AI_PLANNER_DEFEND_POSITION;
	
	if not reorder and self.is_debug then
		bm:out(self.name .. ":defend_position() called, position is " .. v_to_s(pos) .. ", radius is " .. tostring(radius));
	end;
		
	self:defend_position_action(pos, radius);
end;



-- part of defend_position that does the action. Not to be called externally as it doesn't cancel other processes
function script_ai_planner:defend_position_action(pos, radius, reorder)

	-- cache our current destination
	self.current_dest = pos;
	self.current_radius = radius;

	-- ensure our units are released to the AI
	self:ensure_units_are_released();

	-- give the order to our units
	self.planner:defend_position(pos, radius);
	
	-- give this order again in 30 secs if we still have any units left and our destination hasn't been changed
	if self.should_reorder then
		bm:callback(
			function() 
				if is_vector(self.current_dest) and self.current_dest:distance(pos) < 1 and self:any_controlled_sunit_standing() then
					self:defend_position_action(pos, radius, true);
				end;
			end,
			self.reorder_interval, 
			self.name
		);
	end;
	
	-- do debug output (only if this order has been re-issued)
	if reorder and self.is_debug then
		bm:out(self.name .. " being reordered by defend_position_action() to defend " .. v_to_s(pos) .. " with radius " .. tostring(radius));
	end;
end;


--- @function defend_position_of_sunit
--- @desc Instructs the script_ai_planner to defend the position of a target @script_unit, tracking this target as it moves. Alongside a target @script_unit a radius must be supplied, which sets how tightly bound to the position the controlled units are.
--- @p script_unit sunit, Scriptunit to defend.
--- @p radius radius, Radius in m.
--- @p function callback, Function to call if position of target @script_unit is reached, or if it routs or dies.
function script_ai_planner:defend_position_of_sunit(sunit, radius, end_callback, internal)
	if not is_scriptunit(sunit) then
		script_error(self.name .. " ERROR: defend_position_of_sunit() called but supplied sunit " .. tostring(sunit) .. " is not a scriptunit!");
		
		return false;
	end;
	
	if not is_number(radius) then
		script_error(self.name .. " ERROR: defend_position_of_sunit() called but supplied radius " .. tostring(radius) .. " is not a number!");
		
		return false;
	end;
	
	if not is_function(end_callback) then
		end_callback = nil;
	end;
	
	-- only cancel running processes if this is an external order
	if not internal then
		bm:remove_process(self.name);
		self.current_order = SCRIPT_AI_PLANNER_DEFEND_POSITION_OF_SUNIT;
		self.current_target = sunit;
		self.current_radius = radius;
		self.end_callback = end_callback;
	end;
	
	local pos = sunit.unit:position();
		
	if self.is_debug then
		bm:out(self.name .. ":defend_position_of_sunit() called, target is " .. sunit.name .. " at " .. v_to_s(pos));
	end;
	
	self:defend_position_action(pos, radius);
	
	-- watch for our target unit routing
	bm:watch(
		function()
			return is_routing_or_dead(sunit.unit)
		end,
		0,
		function()
			self:defend_position_of_sunit_complete(sunit, radius, end_callback);
		end,
		self.name
	);
	
	-- watch for our target unit moving and update if it moves too far away from our current destination
	bm:watch(
		function()
			return sunit.unit:position():distance(self.current_dest) > 25
		end,
		0,
		function()
			self:defend_position_action(sunit.unit:position(), radius)
		end,
		self.name
	);
end;


function script_ai_planner:defend_position_of_sunit_complete(sunit, radius, end_callback)
	if self.is_debug then
		bm:out(self.name .. ":defend_position_of_sunit() has completed, target " .. sunit.name .. " is routing or dead. Remaining at " .. v_to_s(self.current_dest) .. " until ordered otherwise");
	end;
	
	bm:remove_process(self.name);
	
	if is_function(end_callback) then
		end_callback();
	end;
end;


--- @function defend_force
--- @desc Instructs the script_ai_planner to defend the position of a target military force, tracking this target as it moves. Alongside a target @script_unit a radius must be supplied, which sets how tightly bound to the computed position the controlled units are.
--- @p script_unit sunit, Scriptunit to defend.
--- @p radius radius, Radius in m.
function script_ai_planner:defend_force(enemy_force, radius)
	if not is_number(radius) or radius < 0 then
		script_error(self.name .. " ERROR: defend_force() called but supplied radius [" .. tostring(radius) .. "] is not a positive number");
		return false;
	end;

	self:move_to_force(enemy_force, false, radius);
end;


--- @function set_should_reorder
--- @desc Instructs the script_ai_planner to reissue defend and movement orders every 30 seconds. By default, this behaviour is enabled. Supply <code>false</code> as a single argument to disable it.
--- @p [opt=true] boolean should reorder
function script_ai_planner:set_should_reorder(value)
	if value == false then
		self.should_reorder = false;
	else
		self.should_reorder = true;
	end;
end;









----------------------------------------------------------------------------
--- @section Attacking
----------------------------------------------------------------------------


--- @function attack_unit
--- @desc Instructs the script_ai_planner to attack a target unit. The target unit must be an enemy of those controlled by the script_ai_planner.
--- @p unit target unit
function script_ai_planner:attack_unit(unit, reorder)
	if not is_unit(unit) then
		script_error(self.name .. " ERROR: attack_unit() called but supplied unit " .. tostring(unit) .. " is not a unit!");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	if not reorder and self.is_debug then
		bm:out(self.name .. ":attack_unit() called, target is a unit at " .. v_to_s(unit:position()));
	end;
	
	-- ensure our units are released to the AI
	self:ensure_units_are_released();

	-- give the order to our units
	self.planner:attack_unit(unit);
	
	self.current_order = SCRIPT_AI_PLANNER_ATTACK_UNIT;
	self.current_target = unit;
end;



--- @function rush_unit
--- @desc Instructs the script_ai_planner to rush a target unit. The target unit must be an enemy of those controlled by the script_ai_planner.
--- @p unit target unit
function script_ai_planner:rush_unit(unit, reorder)
	if not is_unit(unit) then
		script_error(self.name .. " ERROR: rush_unit() called but supplied unit " .. tostring(unit) .. " is not a unit!");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	if not reorder and self.is_debug then
		bm:out(self.name .. ":rush_unit() called, target is a unit at " .. v_to_s(unit:position()));
	end;
	
	-- ensure our units are released to the AI
	self:ensure_units_are_released();

	-- give the order to our units
	self.planner:rush_unit(unit);
	
	self.current_order = SCRIPT_AI_PLANNER_RUSH_UNIT;
	self.current_target = unit;
end;


--- @function attack_force
--- @desc Instructs the script_ai_planner to attack a target force. The target force is supplied as a @script_units collection, or as a table of @script_unit objects. Each of these must be an enemy of the units controlled by the script_ai_planner.
--- @p object enemy force, Enemy force. Must be a @script_units collection or a table of @script_unit objects.
function script_ai_planner:attack_force(enemy_force, reorder)
	local function custom_function(closest_enemy)
		self.current_order = SCRIPT_AI_PLANNER_ATTACK_FORCE;
		self.planner:attack_unit(closest_enemy.unit);
	end;

	self:call_on_enemy_force(custom_function, "attack_force", enemy_force)
end;

--- @function rush_force
--- @desc Instructs the script_ai_planner to rush a target force. The target force is supplied as a @script_units collection, or as a table of @script_unit objects. Each of these must be an enemy of the units controlled by the script_ai_planner.
--- @p object enemy force, Enemy force. Must be a @script_units collection or a table of @script_unit objects.
function script_ai_planner:rush_force(enemy_force, reorder)
	local function custom_function(closest_enemy)
		self.current_order = SCRIPT_AI_PLANNER_RUSH_FORCE;
		self.planner:rush_unit(closest_enemy.unit);
	end;

	self:call_on_enemy_force(custom_function, "rush_force", enemy_force, reorder)
end;

-- for internal use
function script_ai_planner:call_on_enemy_force(custom_function, function_name, enemy_force, reorder)
	if is_scriptunits(enemy_force) then
		enemy_force = enemy_force:get_sunit_table();
	end;
	
	if not is_table(enemy_force) then
		script_error(self.name .. " ERROR: " .. function_name .. "() called but supplied force [" .. tostring(enemy_force) .. "] is not a table!");
		return false;
	end;
	
	-- check that we have some non-routing units to order
	if is_routing_or_dead(self.sunit_list) then
		if self.is_debug then
			bm:out(self.name .. ": " .. function_name .. "() called but all controlled units are routing, doing nothing");
			return;
		end;
	end;
	
	-- get closest visible enemy
	local closest_enemy = nil;
	local closest_enemy_dist = 5000;
	local alliance = self.alliance;	
	local non_routing_enemy_found = false;
	
	for i = 1, #enemy_force do
		local curr_enemy_sunit = enemy_force[i];
		
		if is_scriptunit(curr_enemy_sunit) then
			if not is_routing_or_dead(curr_enemy_sunit.unit) then
				non_routing_enemy_found = true;

				if is_visible(curr_enemy_sunit.unit, alliance) then
					local closest_standing_unit = get_closest_standing_unit(self.sunit_list, curr_enemy_sunit.unit:position());
					
					if closest_standing_unit then
						local curr_enemy_sunit_dist = closest_standing_unit:position():distance(curr_enemy_sunit.unit:position());
						
						if curr_enemy_sunit_dist < closest_enemy_dist then
							closest_enemy = curr_enemy_sunit;
							closest_enemy_dist = curr_enemy_sunit_dist;
						end;
					end;
				end;
			end;
		else
			script_error(self.name .. " ERROR: " .. function_name .. "() called but item " .. i .. " [" .. tostring(curr_enemy_sunit) .. " ]  of supplied force [" .. tostring(enemy_force) .. "] is not a scriptunit");
			return false;
		end;
	end;
	
	-- only give the order if we have a valid target
	if not closest_enemy then
	
		if not non_routing_enemy_found then
			if self.is_debug then
				bm:out(self.name .. ":" .. function_name .. "() called but couldn't find any targets that are not routing - exiting");
			end;			
		else	
			if self.is_debug then
				bm:out(self.name .. ":" .. function_name .. "() called but couldn't find any targets that are visible and not routing - will move to the enemy force instead, and try attacking again in 30 seconds");
				
				self:move_to_force(enemy_force);
				
				-- try again in a little while
				bm:callback(
					function()
						self:call_on_enemy_force(custom_function, function_name, enemy_force, true);
					end,
					20000,
					self.name
				);
			end;
		end;
		return;
		
	else	
		bm:remove_process(self.name);
		
		self.enemy_force = enemy_force;
		self.current_target = closest_enemy;
			
		if self.is_debug then
			bm:out(self.name .. " " .. function_name .. "() now attacking closest target " .. closest_enemy.name .. " at " .. v_to_s(closest_enemy.unit:position()));
		end;
		
		-- ensure our units are released to the AI
		self:ensure_units_are_released();
		
		-- give the order itself
		custom_function(closest_enemy);
	
	end;
	
	-- watch for our units routing
	bm:watch(
		function()
			return is_routing_or_dead(self.sunit_list);
		end,
		0,
		function()
			if self.is_debug then
				bm:out(self.name .. ": " .. function_name .. "() is stopping as all controlled units are routing");
			end;
			bm:remove_process(self.name);
		end,
		self.name
	);
	
	bm:watch(
		function()
			for i = 1, #enemy_force do
				local current_sunit = enemy_force[i];
				if is_visible(current_sunit.unit, alliance) and not is_routing_or_dead(current_sunit.unit) then
					return false;
				end;
			end;
			return true;
		end,
		0,
		function()
			if self.is_debug then
				bm:out(self.name .. ": " .. function_name .. "() can no longer find any visible and non-routing enemies - re-issuing order in an attempt to cope");
			end;
			bm:remove_process(self.name);
			self:call_on_enemy_force(custom_function, function_name, enemy_force, true);
		end,
		self.name
	);
end;









----------------------------------------------------------------------------
--- @section Merging
----------------------------------------------------------------------------


--- @function merge_into
--- @desc Instructs the script_ai_planner to merge into another. This script_ai_planner instructs its units to move towards those controlled by the target planner, and when it gets close it removes units from itself and gives them to the target planner. The threshold distance is 120m.
--- @p script_ai_planner target ai planner
function script_ai_planner:merge_into(planner, reorder)
	if not is_scriptaiplanner(planner) then
		script_error(self.name .. " ERROR: merge_into() called but supplied object " .. tostring(planner) .. " is not a script ai planner!");
		
		return false;
	end;
	
	-- alliance check
	if self.alliance ~= planner.alliance then
		script_error(self.name .. " ERROR: merge_into() called but supplied planner " .. tostring(planner.name) .. " has an alliance of " .. tostring(planner.alliance) .. " instead of " .. tostring(self.alliance) .. " !");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	self.current_order = SCRIPT_AI_PLANNER_MERGE_INTO;
	self.merge_target = planner;
	
	if not reorder and self.is_debug then
		bm:out(self.name .. ":merge_into() called, merge target is " .. planner.name);
	end;
		
	-- repeatedly track this planner towards the target planner
	bm:repeat_callback(
		function()
			if self:any_controlled_sunit_standing() then
				self:track_towards_merge_target();
			end;
		end,
		10000,
		self.name
	);
	
	-- do this after registering the repeat_callback above, so that it has a chance to cancel if the target is found immediately
	self:track_towards_merge_target();
end;


function script_ai_planner:track_towards_merge_target()
	local centre = centre_point_table(self.merge_target.sunit_list);
	
	-- we have arrived at our target if any of our units are within a certain distance of the centre of the target
	if standing_is_close_to_position(self.sunit_list, centre, self.merge_distance) then
		-- we have arrived, merge us into the target planner
		if self.is_debug then
			bm:out(self.name .. " has arrived within " .. self.merge_distance .. "m of " .. v_to_s(centre) .. ", merging into " .. self.merge_target.name);
		end;
		
		self.merge_target:add_sunits(self.sunit_list);
		
		self.merge_target = nil;
		self.current_order = SCRIPT_AI_PLANNER_NO_ORDER;
		
		bm:remove_process(self.name);
	else
		-- we have not arrived, track towards our target
		
		-- if our target is in a defensive action use defend_position_centre, if they're attacking use
		-- move_to_position to minimise reforming when contact is made
		local merge_target_order = self.merge_target.current_order;
		local move_posture = "defensive";
		
		if merge_target_order == SCRIPT_AI_PLANNER_DEFEND_POSITION or merge_target_order == SCRIPT_AI_PLANNER_DEFEND_POSITION_OF_SUNIT then
			self:defend_position_action(centre, 100);
		else
			self:move_to_position_action(centre);
			move_posture = "offensive";
		end;
		
		if self.is_debug then
			bm:out(self.name .. " is continuing tracking towards " .. self.merge_target.name .. " at " .. v_to_s(centre) .. ", movement posture is " .. move_posture);
		end;
	end;
end;








----------------------------------------------------------------------------
--- @section Patrolling
----------------------------------------------------------------------------


--- @function patrol
--- @desc Instructs the script_ai_planner to send its units on a patrol path along a series of waypoint positions. The units will move from point to point along the path, and move to engage any of the specified enemy units they find along the path. Should the enemy units retreat far enough from the path then the subject units will resume their patrol.
--- @p table waypoint list, Numerically-indexed table of vector waypoint positions.
--- @p object enemy force, Enemy force to engage. This can be a @script_units object or a table of @script_unit objects.
--- @p [opt=nil] function completion callback, Function to call when the patrol is completed.
function script_ai_planner:patrol(waypoint_list, enemy_force, completion_callback, reorder)
	if not is_table(waypoint_list) then
		script_error(self.name .. " patrol called but supplied waypoint list is not a table, but a " .. tostring(waypoint_list) .. " !");
		return false;
	end;
	
	if is_scriptunits(enemy_force) then
		enemy_force = enemy_force:get_sunit_table();
	end;
	
	if not is_table(enemy_force) then
		script_error(self.name .. " patrol called but supplied enemy force is not a table, but an " .. tostring(enemy_force) .. " !");
		return false;
	end;
	
	bm:remove_process(self.name);
	
	if #waypoint_list == 0 then
		-- we have arrived at our destination
		if self.is_debug then
			bm:out(self.name .. " has completed patrol");
		end;
		
		self.current_order = SCRIPT_AI_PLANNER_NO_ORDER;
		
		if completion_callback and is_function(completion_callback) then
			completion_callback();
		end;
		
		return true;
	end;

	-- take one off the waypoint list each time we pass through this function
	local current_waypoint = waypoint_list[1];
	table.remove(waypoint_list, 1);
	
	-- stash our arguments in case we need to re-order
	self.waypoint_list = waypoint_list;
	self.enemy_force = enemy_force;
	self.completion_callback = completion_callback;
	
	-- officially change the order
	self.current_order = SCRIPT_AI_PLANNER_PATROL;
	
	-- self:move_to_position_action(current_waypoint);
	self:defend_position_action(current_waypoint, self.patrol_defend_radius);
	
	if not reorder and self.is_debug then
		bm:out(self.name .. " now patrolling to " .. v_to_s(current_waypoint));
	end;
	
	-- assemble a proximity test to enemy force (if we should)
	if self.perform_patrol_prox_test then
		local prox_test_enemy = function() return distance_between_forces(self.sunit_list, enemy_force) < self.patrol_enemy_distance end;
		
		-- watch for getting close to enemy
		bm:watch(
			function()
				return prox_test_enemy();
			end,
			0,
			function()
				-- we have encountered our enemy, attack
				if self.is_debug then
					bm:out(self.name .. " is on patrol and has encountered an enemy");
				end;
				
				bm:remove_process(self.name);
				
				self:attack_force(enemy_force);
			end,
			self.name
		);
	end;
	
	-- watch for arriving at destination
	bm:watch(
		function()
			-- position test is 2D
			return is_close_to_position(self.sunit_list, current_waypoint, self.patrol_waypoint_distance, true);
		end,
		5000,
		function()
			-- go on to next waypoint
			self:patrol(waypoint_list, enemy_force, completion_callback);
		end,
		self.name
	);
end;


--- @function set_patrol_defend_radius
--- @desc Sets the radius at which a script_ai_planner patrol will defend each waypoint along its patrol path. This influences how tightly bound the script ai planner arranges its defensive position at each destination, which is likely to influence how it moves. The default value is 100m.
--- @p number radius in m
function script_ai_planner:set_patrol_defend_radius(value)
	if not is_number(value) or value <= 0 then
		script_error(self.name .. " ERROR: set_patrol_defend_radius() called but supplied distance [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.patrol_defend_radius = value;
end;


--- @function set_patrol_enemy_distance
--- @desc Sets the distance at which a patrol will intercept an enemy it finds on its path. The distance will be the closest distance in m between any two units in the opposing forces. Set a higher number here to make the script_ai_planner more prone to intercept enemies at a greater distance. Note that this is the distance at which the script will instruct the script_ai_planner to intercept the enemy - the AI may have already responded of its own volition. The default value is 100m.
--- @p number radius in m
function script_ai_planner:set_patrol_enemy_distance(value)
	if not is_number(value) or value <= 0 then
		script_error(self.name .. " ERROR: set_patrol_enemy_distance() called but supplied distance [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.patrol_enemy_distance = value;
end;


-- 
--- @function set_patrol_waypoint_distance
--- @desc Sets the distance between the controlled units and a patrol waypoint at the patrol will considered to have arrived at the waypoint. Set a lower number here to bind the patrol more tightly to its waypoints. The default value is 75.
--- @p number radius in m
function script_ai_planner:set_patrol_waypoint_distance(value)
	if not is_number(value) or value <= 0 then
		script_error(self.name .. " ERROR: set_patrol_waypoint_distance() called but supplied distance [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.patrol_waypoint_distance = value;
end;


--- @function set_perform_patrol_prox_test
--- @desc Instructs the script_ai_planner whether to perform its enemy proximity test when on a patrol. Be default it does, and it is this that causes the script_ai_planner to engage enemies. Disable the proximity test by supplying <code>false</code> as an argument to this function.
--- @p [opt=true] boolean perform proximity test
function script_ai_planner:set_perform_patrol_prox_test(value)
	if value == false then
		self.perform_patrol_prox_test = false;
	else
		self.perform_patrol_prox_test = true;
	end; 	
end;









