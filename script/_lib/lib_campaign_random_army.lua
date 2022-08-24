----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	Random Army Manager
--
---	@set_environment campaign
--- @c random_army_manager Random Army Manager
--- @desc Used to create and manage multiple random or semi-random army templates that can be generated at any time throughout the campaign.
--- @desc Example Usage:
--- @desc 1) Create an army template
--- @desc <code>random_army_manager:new_force("my_template");</code>
--- @desc 2) Add 4 units to this army that will always be used when generating this template
--- @desc <code>random_army_manager:add_mandatory_unit("my_template", "unit_key1", 4);</code>
--- @desc 3) Add units to the template that can be randomly generated, with their weighting (that is their chance of being picked, this is not how many will be picked)
--- @desc <code>random_army_manager:add_unit("my_template", "unit_key1", 1);</code>
--- @desc <code>random_army_manager:add_unit("my_template", "unit_key2", 1);</code>
--- @desc <code>random_army_manager:add_unit("my_template", "unit_key3", 2);</code>
--- @desc 4) Generate a random army of 6 units from this template
--- @desc <code>local force = ram:generate_force("my_template", 6, false);</code>
--- @desc <code>Output: "unit_key1,unit_key1,unit_key1,unit_key1,unit_key2,unit_key3"</code>


---------------------
---- Definitions ----
---------------------
random_army_manager = {
	force_list = {}
};

function random_army_manager:__tostring()
	return TYPE_RANDOM_ARMY_MANAGER;
end;

function random_army_manager:__type()
	return TYPE_RANDOM_ARMY_MANAGER;
end


-------------------------------------------------------------------------------------------
--- @section Random Army Manager Functions
--- @desc Functions relating to the Manager and its control over the various defined forces
-------------------------------------------------------------------------------------------

--- @function new_force
--- @desc Adds a new force to the random army manager
--- @p string force key, a unique key for this new force
--- @r boolean Returns true if the force was created successfully
function random_army_manager:new_force(key)
	out.design("Random Army Manager: Creating New Force with key [" .. key .. "]");
	
	if self:get_force_by_key(key) then
		out.design("\tForce with key [" .. key .. "] already exists!");
		return false;
	end;

	local existing_force = self:get_force_by_key(key)

	if existing_force ~= false then
		self.existing_force[i].key = key;
		self.existing_force[i].units = {};
		self.existing_force[i].mandatory_units = {};
		self.existing_force[i].faction = "";
		out.design("\tForce with key [" .. key .. "] already exists - resetting force!");
		return true;
	end

	local force = {};
	force.key = key;
	force.units = {};
	force.mandatory_units = {};
	force.faction = "";
	table.insert(self.force_list, force);
	out.design("\tForce with key [" .. key .. "] created!");
	return true;
end;

--- @function clone_force
--- @desc Clones an existing force to the random army manager
--- @p string old force key, the key of the force to be cloned
--- @p string new force key, a unique key for this new force
--- @r boolean Returns true if the force was cloned successfully
function random_army_manager:clone_force(old_key, new_key)
	out.design("Random Army Manager: Cloning Force with key [" .. new_key .. "] from force with key [" .. old_key .. "]");
	
	local old_force_data = self:get_force_by_key(old_key);
	
	local force = {};
	force.key = new_key;
	force.units = table.copy(old_force_data.units);
	force.mandatory_units = table.copy(old_force_data.mandatory_units);
	force.faction = old_force_data.faction;
	table.insert(self.force_list, force);
	out.design("\tForce with key [" .. new_key .. "] cloned from force with key [" .. old_key .. "]!");
	return true;
end;

--- @function combine_forces
--- @desc Combines existing forces to the random army manager. If all specified forces have the same faction, then that faction is given to the new force. Otherwise, the faction of the new force is left blank.
--- @p string new force key, a unique key for this new force
--- @p ... old force keys, One or more existing force keys
--- @r boolean Returns true if the forces were combined successfully
function random_army_manager:combine_forces(new_key, ...)
	local force = {};
	force.key = new_key;
	force.units = {};
	force.mandatory_units = {};
	force.faction = "";

	local ubiquitous_faction = nil;
	local all_factions_identical = true;
	
	for i = 1, arg.n do
		local current_old_force_data = self:get_force_by_key(arg[i]);
		
		for j = 1, #current_old_force_data.units do
			table.insert(force.units, current_old_force_data.units[j]);
		end;
		
		for j = 1, #current_old_force_data.mandatory_units do
			table.insert(force.mandatory_units, current_old_force_data.mandatory_units[j]);
		end;

		if ubiquitous_faction == nil then
			ubiquitous_faction = current_old_force_data.faction;
		elseif ubiquitous_faction ~= current_old_force_data.faction then
			all_factions_identical = false;
		end;
	end;

	if all_factions_identical then
		force.faction = ubiquitous_faction;
	end
	
	table.insert(self.force_list, force);
	out.design("\tForce with key [" .. new_key .. "] combined from forces with keys:");
	for i = 1, arg.n do
		out.design("\t\t[" .. arg[i] .. "]");
	end;
	if not all_factions_identical then
		out.design("\tNot all factions of these forces were equal, so the new merged force does not have a faction. You may want to specify a faction for this new force.");
	end;
	return true;
end;

--- @function add_unit
--- @desc Adds a unit to a force, making it available for random selection if this force is generated. The weight value is an arbitrary figure that should be relative to other units in the force
--- @p string key of the force
--- @p string key of the unit
--- @p number weight value
function random_army_manager:add_unit(force_key, key, weight)
	local force_data = self:get_force_by_key(force_key);
	
	if force_data then
		for i = 1, weight do
			table.insert(force_data.units, key);
			out.design("Random Army Manager: Adding Unit- [" .. key .. "] with weight: [" .. weight .. "] to force: [" .. force_key .. "]");
		end;
		return;
	end;
	
	-- the force key doesn't exist, create it now
	self:new_force(force_key);
	self:add_unit(force_key, key, weight);
end;

--- @function add_mandatory_unit
--- @desc Adds a mandatory unit to a force composition, making it so that if this force is generated this unit will always be part of it
--- @p string key of the force
--- @p string key of the unit
--- @p number amount of these units
function random_army_manager:add_mandatory_unit(force_key, key, amount)
	local force_data = self:get_force_by_key(force_key);
	
	if force_data then
		for i = 1, amount do
			table.insert(force_data.mandatory_units, key);
			out.design("Random Army Manager: Adding Mandatory Unit- [" .. key .. "] with amount: [" .. amount .. "] to force: [" .. force_key .. "]");
		end;
		return;
	end;
	
	-- the force key doesn't exist, create it now
	self:new_force(force_key);
	self:add_mandatory_unit(force_key, key, amount);
end;

--- @function set_faction
--- @desc Sets the faction key associated with this force - Allows you to store the faction key used to spawn the army from the force
--- @p string key of the force
--- @p string key of the faction
function random_army_manager:set_faction(force_key, faction_key)
	local force_data = self:get_force_by_key(force_key)

	-- If the force doesn't exist, add it now.
	if not force_data then
		self:new_force(force_key);
	end;

	force_data.faction = faction_key;
end

--- @function generate_force
--- @desc This generates a force randomly, first taking into account the mandatory unit and then making random selection of units based on weighting. Returns an array of unit keys or a comma separated string for use in the create_force function if the last boolean value is passed as true
--- @p @string Key of the force.
--- @p [opt=nil] @number Number of units to spawn, If you have no non-mandatory units specified, this must equal the sum of all mandatory units (since no optional units are available for generating additional units). If unspecified, only the sum of your mandatory units will be spawned.
--- @p [opt=nil] @boolean Return as table, Pass <code>true</code> to return the force as a table, <code>false</code> to get a comma separated string.
--- @r object Either a table containing the unit keys, or a comma separated string of units
function random_army_manager:generate_force(force_key, unit_count, return_as_table)
	local force = {};
	local force_data = self:get_force_by_key(force_key);

	if not unit_count then
		unit_count = #force_data.mandatory_units
	elseif is_table(unit_count) then
		unit_count = cm:random_number(math.max(unit_count[1], unit_count[2]), math.min(unit_count[1], unit_count[2]));
	end
	
	unit_count = math.min(19, unit_count);
	
	out.design("Random Army Manager: Getting Random Force for army [" .. force_key .. "] with size [" .. unit_count .. "]");
	
	local mandatory_units_added = 0;
	
	for i = 1, #force_data.mandatory_units do
		table.insert(force, force_data.mandatory_units[i]);
		mandatory_units_added = mandatory_units_added + 1;
	end;
	
	if (unit_count - mandatory_units_added) > 0 and #force_data.units == 0 then
		script_error("Random Army Manager: Tried to add units to force_key [" .. force_key .. "] but the force has not been set up with any non-mandatory units - add them first!");
		return false;
	end;
	
	for i = 1, unit_count - mandatory_units_added do
		local unit_index = cm:random_number(#force_data.units);
		table.insert(force, force_data.units[unit_index]);
	end;
	
	if #force == 0 then
		script_error("Random Army Manager: Did not add any units to force with force_key [" .. force_key .. "] - was the force created?");
		return false;
	elseif return_as_table then
		return force;
	else
		return table.concat(force, ",");
	end;
end;

--- @function remove_force
--- @desc Remove an existing force from the force list
--- @p string key of the force
function random_army_manager:remove_force(force_key)
	out.design("Random Army Manager: Removing Force with key [" .. force_key .. "]");

	for i = 1, #self.force_list do
		if force_key == self.force_list[i].key then
			table.remove(self.force_list, i);
			break;
		end;
	end;
end;

--- @function mandatory_unit_count
--- @desc Returns the amount of mandatory units specified in this force
--- @p string key of the force
function random_army_manager:mandatory_unit_count(force_key)
	local force_data = self:get_force_by_key(force_key);
	if force_data then
		return #force_data.mandatory_units;
	else
		return -1
	end
end;

--- @function get_force_by_key
--- @desc Returns the force of the specified key, false if it's not found
--- @p string key of the force
--- @r table Returns the force
function random_army_manager:get_force_by_key(force_key)
	for i = 1, #self.force_list do
		if force_key == self.force_list[i].key then
			return self.force_list[i];
		end;
	end;
	
	return false;
end;

-- Internal Debug
local show_debug_output_ram = false;
function output_ram(text)
	if show_debug_output_ram then
		out(text);
	end;
end;