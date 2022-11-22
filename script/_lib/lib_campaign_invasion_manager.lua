----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INVASION_MANAGER
--
---	@set_environment campaign
--- @c invasion_manager Invasion Manager
--- @desc The Invasion Manager is used to create and manage scripted A.I invasions in the campaign
--- @desc The primary purpose of the Invasion Manager is to created, hold and manage @invasion objects
--- @desc See the @invasion section below for details on how to set up and begin invasions

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
invasion_manager = {
	invasions = {}
};
im_spawn_locations = {};
invasion = {};

function invasion_manager:__tostring()
	return TYPE_INVASION_MANAGER;
end

function invasion_manager:__type()
	return TYPE_INVASION_MANAGER;
end


--- @section Creating Invasions
--- @function new_invasion
--- @desc Adds a new invasion to the invasion manager
--- @p string key, The key of this invasion
--- @p string faction_key, The key of the faction that this invasion belongs to
--- @p string force_list, The units that will be part of this invasion
--- @p object spawn_location, Pass either a table of x/y coordinates or a string for the key of a preset location
--- @r invasion The new invasion object created by this function
function invasion_manager:new_invasion(key, faction_key, force_list, spawn_location)
	if self.invasions[key] ~= nil then
		script_error("ERROR: Attempted to create an invasion with key [" .. tostring(key) .. "], but an invasion with that key already exists!");
		return nil;
	end
	
	if not cm:get_faction(faction_key) then
		script_error("ERROR: Attempted to create an invasion with faction key [" .. tostring(faction_key) .. "], but this faction does not exist in the start pos!");
		return nil;
	end
	
	out.invasions("Invasion Manager: New Invasion '"..tostring(key).."'...");
	out.invasions("\tFaction: "..tostring(faction_key));
	out.invasions("\tForce: "..tostring(force_list));
	if is_table(spawn_location) then
		out.invasions("\tSpawn: "..tostring(spawn_location[1])..", "..tostring(spawn_location[2]));
	else
		out.invasions("\tSpawn: "..tostring(spawn_location));
	end

	local new_invasion = invasion:new();
	new_invasion.key = key;
	new_invasion.faction = faction_key;
	new_invasion.general_cqi = nil;
	new_invasion.new_general = nil;
	new_invasion.immortal_general = nil;
	new_invasion.force_cqi = nil;
	new_invasion.unit_list = force_list;
	new_invasion.unit_list_table = {};
	for unit in string.gmatch(force_list, '([^,]+)') do
		table.insert(new_invasion.unit_list_table, unit);
	end
	new_invasion.spawn = self:parse_spawn_location(spawn_location);
	new_invasion.target_type = "NONE";
	new_invasion.target = nil;
	new_invasion.target_faction = nil;
	new_invasion.effect = {};
	new_invasion.effect_turns = {};
	new_invasion.turn_spawned = nil;
	new_invasion.started = false;
	new_invasion.stop_at_end = false;
	new_invasion.patrol_position = nil;
	new_invasion.aggro_enabled = false;
	new_invasion.aggro_radius = nil;
	new_invasion.aggro_targets = nil;
	new_invasion.aggro_target_cqi = nil;
	new_invasion.aggro_turn_abort = nil;
	new_invasion.aggro_turn_abort_value = nil;
	new_invasion.aggro_cooldown = nil;
	new_invasion.aggro_cooldown_value = nil;
	new_invasion.callback = nil;
	new_invasion.prespawned = false;
	new_invasion.target_owner_abort = false;
	new_invasion.respawn = false;
	new_invasion.respawn_count = nil;
	new_invasion.respawn_delay = nil;
	new_invasion.respawn_turn = nil;
	new_invasion.maintain_army = false;
	new_invasion.maintain_army_chance = nil;
	new_invasion.rogue_army = false;
	
	self.invasions[key] = new_invasion;
	out.invasions("\tInvasion Created!");
	return new_invasion;
end

--- @function new_invasion_from_existing_force
--- @desc Adds a new invasion to the invasion manager created from an existing force
--- @p string key, The key of this invasion
--- @p force_interface force, The existing force to use with this invasion
--- @r invasion The new invasion object created by this function
function invasion_manager:new_invasion_from_existing_force(key, force)
	out.invasions("Invasion Manager: New Invasion from existing force'"..tostring(key).."'...");
	out.invasions("\tForce: "..tostring(force));
	
	if self.invasions[key] ~= nil then
		script_error("ERROR: Attempted to create an invasion with a key that already exists!");
		return nil;
	end

	local new_invasion = invasion:new();
	new_invasion.key = key;
	new_invasion.faction = force:faction():name();
	new_invasion.general_cqi = force:general_character():command_queue_index();
	new_invasion.new_general = nil;
	new_invasion.immortal_general = nil;
	new_invasion.force_cqi = force:command_queue_index();
	new_invasion.unit_list = "";
	new_invasion.unit_list_table = {};
	for i = 0, force:unit_list():num_items() - 1 do
		local unit_key = force:unit_list():item_at(i):unit_key();
		table.insert(new_invasion.unit_list_table, unit_key);
		
		if i == 0 then
			new_invasion.unit_list = unit_key;
		else
			new_invasion.unit_list = new_invasion.unit_list..","..unit_key;
		end
	end
	new_invasion.spawn = {x = force:general_character():logical_position_x(), y = force:general_character():logical_position_y()};
	new_invasion.target_type = "NONE";
	new_invasion.target = nil;
	new_invasion.target_faction = nil;
	new_invasion.effect = {};
	new_invasion.effect_turns = {};
	new_invasion.turn_spawned = nil;
	new_invasion.started = false;
	new_invasion.stop_at_end = false;
	new_invasion.patrol_position = nil;
	new_invasion.aggro_enabled = false;
	new_invasion.aggro_radius = nil;
	new_invasion.aggro_targets = nil;
	new_invasion.aggro_target_cqi = nil;
	new_invasion.aggro_turn_abort = nil;
	new_invasion.aggro_turn_abort_value = nil;
	new_invasion.aggro_cooldown = nil;
	new_invasion.aggro_cooldown_value = nil;
	new_invasion.callback = nil;
	new_invasion.prespawned = true;
	new_invasion.target_owner_abort = false;
	new_invasion.respawn = false;
	new_invasion.respawn_count = nil;
	new_invasion.respawn_delay = nil;
	new_invasion.respawn_turn = nil;
	new_invasion.maintain_army = false;
	new_invasion.maintain_army_chance = nil;
	new_invasion.rogue_army = force:faction():culture() == "wh2_main_rogue";
	
	self.invasions[key] = new_invasion;
	out.invasions("\tInvasion Created!");
	return new_invasion;
end

--- @function new_spawn_location
--- @desc Create a new spawn location that can be used later by referencing its key
--- @p string key, The key of this location
--- @p number x, The X coordinate of this location
--- @p number y, The Y coordinate of this location
function invasion_manager:new_spawn_location(key, x, y)
	local spawn = {};
	spawn.x = x;
	spawn.y = y;
	im_spawn_locations[key] = spawn;
end

---- Internal - Allows parsing of arbitrary spawn location data into a relevant format
function invasion_manager:parse_spawn_location(spawn_location)
	out.invasions("Invasion Manager: Parsing a Spawn Location of '"..tostring(spawn_location).."'");
	local return_val = nil;
	
	if type(spawn_location) == "table" then
		-- Assume it's an X/Y coordinate table
		return_val = {x = spawn_location.x or spawn_location[1], y = spawn_location.y or spawn_location[2]};		
	elseif type(spawn_location) == "string" then
		-- Assume it's a predetermined location key
		for key, value in pairs(im_spawn_locations) do
			if spawn_location == key then
				return_val = {x = value.x, y = value.y};
			end
		end
	elseif not spawn_location then
		-- If no spawn location is supplied, pick a random one
		local size = 0;
		for key, value in pairs(im_spawn_locations) do
			size = size + 1;
		end
		
		-- Pick a random record based on the size
		local index = cm:random_number(size);
		local count = 0;
		
		for key, value in pairs(im_spawn_locations) do
			count = count + 1;
			
			if count == index then
				local chosen_x = value.x;
				local chosen_y = value.y;
				
				if self:is_valid_position(chosen_x, chosen_y) then
					return_val = {x = chosen_x, y = chosen_y};
				else
					script_error("ERROR: Parse_Spawn_Location() called but failed as a character is standing at coordinates ["..tostring(spawn_location).."]");
				end
				break;
			end
		end
	end
	
	if return_val then
		return return_val;
	else
		script_error("ERROR: Parse_Spawn_Location() called but failed to find coordinates ["..tostring(spawn_location).."]");
	end
end

---- Internal - Validates a set of coordinates by testing if a character is standing at that location
function invasion_manager:is_valid_position(x, y)
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		local char_list = faction:character_list();

		for i = 0, char_list:num_items() - 1 do
			local character = char_list:item_at(i);
			
			if character:logical_position_x() == x and character:logical_position_y() == y then
				return false;
			end
		end
	end
	return true;
end

--- @section Selecting & Removing Invasions
--- @function get_invasion
--- @desc Returns an invasion from the invasion manager by its key
--- @p string key, The key of the invasion object
--- @r invasion The invasion object with the key provided
function invasion_manager:get_invasion(key)
	if key and self.invasions[key] then
		return self.invasions[key];
	else
		return false;
	end
end

--- @function remove_invasion
--- @desc Removes an invasion from the invasion manager by its key
--- @p string key, The key of the invasion object
function invasion_manager:remove_invasion(key)
	if key ~= nil then
		out.invasions("Invasion Manager: Removing Invasion '"..key.."'");
		self.invasions[key] = nil;
		core:remove_listener("INVASION_"..key);
	end
end

--- @function kill_invasion_by_key
--- @desc Kills an invasion via the invasion manager, see the kill function on the invasion object for details
--- @p string key, The key of the invasion object
function invasion_manager:kill_invasion_by_key(key)	
	local invasion = self.invasions[key];
	
	if invasion then
		out.invasions("Invasion Manager: Killing Invasion [" .. invasion.key .. "]");
		invasion:kill();
	end
end

--- @c invasion Invasion
--- @page invasion_manager
--- @section Setup
---- Internal - Creates a new invasion object
function invasion:new(o)
	if o then
		out.savegame("Invasion: New Invasion object created from existing table ["..tostring(o).."]");
		out.invasions("Invasion: New Invasion object created from existing table ["..tostring(o).."]");
	else
		out.invasions("Invasion: New Invasion object created");
	end;
	
	o = o or {};
	
	setmetatable(o, self);
	self.__index = self;
	return o;
end

--- @function set_target
--- @desc Sets the target for an invasion
--- @desc Target Types: REGION, CHARACTER, LOCATION, PATROL
--- @desc <li>REGION - Requires the target to be set as a region key
--- @desc <li>CHARACTER - Requires the target to be set as a character's CQI
--- @desc <li>LOCATION - Requires the target to be set as a table containing an x and y variable, e.g. {x = 5, y = 3}
--- @desc <li>PATROL - Requires the target to be set as a table containing any number of position tables, e.g. {{x = 5, y = 3}, {x = 9, y = 2}}
--- @p string target_type, The type of the target
--- @p object target, The actual target
--- @p string target_faction_key, The faction that is the indended target
function invasion:set_target(target_type, target, target_faction_key)
	out.invasions("Invasion: Set Target for '"..self.key.."'...");
	target_type = target_type or "NONE";
	
	if target_type == "REGION" then
		out.invasions("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		self.target = target;
	elseif target_type == "CHARACTER" then
		out.invasions("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		self.target = target;
	elseif target_type == "LOCATION" then
		out.invasions("\tTarget: "..target_type.." - X:"..tostring(target.x).." / Y:"..tostring(target.y));
		self.target_type = target_type;
		self.target = target;
	elseif target_type == "PATROL" then
		out.invasions("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		for i = 1, #target do
			if target[i] == "start" then
				target[i] = {x = self.spawn.x, y = self.spawn.y};
			end
		end
		self.target = target;
	elseif target_type == "TZEENTCH_COORDS" then
		out.invasions("\tTarget: "..target_type.." - "..tostring(target));
		self.target_type = target_type;
		self.target = target;
	else
		out.invasions("\tTarget: NONE");
		self.target_type = "NONE";
		self.target = nil;
	end
	
	self.target_faction = target_faction_key or nil;
end

--- @function remove_target
--- @desc Sets this invasion to no longer have a target
function invasion:remove_target()
	out.invasions("Invasion: Removing Target for '"..self.key.."'");
	self.target_type = "NONE";
	self.target = nil;
	self.target_faction = nil;
end

--- @function add_aggro_radius
--- @desc Add an aggravation radius to this invasion in which the force will attack all specified targets that enter its aggro range
--- @p number radius, The radius of the aggrevation range at which this invasion will trigger an attack
--- @p table target_list, A table containing faction keys of all the factions that will trigger an attack. If nil, will target any warring factions
--- @p number abort_timer, The number of turns after which this invasion will give up after chasing a target
function invasion:add_aggro_radius(radius, target_list, cooldown_timer, abort_timer)
	radius = radius or 0;
	target_list = target_list or {"war"};
	cooldown_timer = cooldown_timer or 0;
	abort_timer = abort_timer or 0;
	
	out.invasions("Invasion: Adding Aggro Radius of "..tostring(radius).." for '"..self.key.."' with "..tostring(#target_list).." targets, a cooldown of "..tostring(cooldown_timer).." and an abort time of "..tostring(abort_timer).." turns");
	self.aggro_enabled = true;
	self.aggro_radius = radius;
	self.aggro_targets = target_list;
	self.aggro_turn_abort = abort_timer;
	self.aggro_turn_abort_value = 0;
	self.aggro_cooldown = cooldown_timer;
	self.aggro_cooldown_value = 0;
end

--- @function remove_aggro_radius
--- @desc Removes all aggravation behaviour from this invasion
function invasion:remove_aggro_radius()
	self.aggro_enabled = false;
	self.aggro_radius = nil;
	self.aggro_targets = nil;
	self.aggro_target_cqi = nil;
	self.aggro_turn_abort = nil;
	self.aggro_turn_abort_value = nil;
	self.aggro_cooldown = nil;
	self.aggro_cooldown_value = nil;
end

--- @function abort_on_target_owner_change
--- @desc Sets if the Invasion will abort if the owner of the target differs to the Invasions faction target
--- @p boolean abort, Will abort if true
function invasion:abort_on_target_owner_change(abort)
	out.invasions("Invasion: Invasion '"..self.key.."' will abort on target owner change: "..tostring(abort));
	self.target_owner_abort = abort;
end

--- @function assign_general
--- @desc Sets a General to be used when spawning this invasion
--- @p character character, The general that will be used (can optionally be a character CQI)
function invasion:assign_general(character)
	if type(character) == "number" then
		self.general_cqi = character;
	elseif character:is_null_interface() == false then
		self.general_cqi = character:command_queue_index();
	end
end

--- @function create_general
--- @desc Sets up a general to be created to command this invasion force when it is spawned
--- @p boolean make_faction_leader, If True this character will become the faction leader
--- @p string agent_subtype, The key of this characters intended subtype
--- @p string forename, The name key of this characters forename
--- @p string clan_name, The name key of this characters clan name
--- @p string family_name, The name key of this characters family name
--- @p string other_name, The name key of this characters other name
function invasion:create_general(make_faction_leader, agent_subtype, forename, clan_name, family_name, other_name)
	local agent_type = "general";
	make_faction_leader = make_faction_leader or false;
	agent_subtype = agent_subtype or "default";
	forename = forename or "";
	clan_name = clan_name or "";
	family_name = family_name or "";
	other_name = other_name or "";
	
	self.new_general = {agent_type = agent_type, agent_subtype = agent_subtype, forename = forename, clan_name = clan_name, family_name = family_name, other_name = other_name, make_faction_leader = make_faction_leader};
	self.general_cqi = nil;
end

--- @function set_general_immortal
--- @desc Sets whether the General leading this invasion should be immortal or not
--- @p boolean should_stop, General spawned will be immortal if True
function invasion:set_general_immortal(is_immortal)
	self.immortal_general = is_immortal;
	
	if self:has_started() then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			cm:set_character_immortality("character_cqi:"..general:command_queue_index(), is_immortal);
		end
	end
end

--- @function should_stop_at_end
--- @desc Sets the Invasion should not move after completing it's objective
--- @p boolean should_stop, Will stop if True
function invasion:should_stop_at_end(should_stop)
	if should_stop == true then
		out.invasions("Invasion: Invasion will stop after target");
	else
		out.invasions("Invasion: Invasion will NOT stop after target");
	end
	self.stop_at_end = should_stop;
end

--- @function apply_effect
--- @desc Allows you to apply an effect bundle to the forces in this invasion
--- @p string effect_key, The key of the effect bundle
--- @p number turns, The turns the effect bundle will be applied for after the invasion is started
function invasion:apply_effect(effect_key, turns)
	if not effect_key and not turns then
		for i = 1, #self.effect do
			out.invasions("Invasion: Applying stored effect '"..self.effect[i].."' ("..self.effect_turns[i]..") to force "..self.force_cqi);
			cm:apply_effect_bundle_to_force(self.effect[i], self.force_cqi, self.effect_turns[i]);
		end;
	elseif self.started then
		out.invasions("Invasion: Applying effect '"..effect_key.."' ("..turns..") to force "..self.force_cqi);
		cm:apply_effect_bundle_to_force(effect_key, self.force_cqi, turns);
	else
		out.invasions("Invasion: Preparing effect '"..effect_key.."' ("..turns..")");
		table.insert(self.effect, effect_key);
		table.insert(self.effect_turns, turns);
	end
end

--- @function add_character_experience
--- @desc Allows you to add experience to the general in this invasion or set their level
--- @p number experience_amount, The amount of experience to apply
--- @p boolean by_level, If true the experience amount supplied will set the level of the character and not their xp
function invasion:add_character_experience(experience_amount, by_level)
	if experience_amount == nil then
		if self.experience_by_level == true then
			local xp = cm.character_xp_per_level[self.experience_amount];
			out.invasions("Invasion: Applying stored character experience amount (by level) of " .. xp .. " to general " .. self.general_cqi);
			cm:add_agent_experience(cm:char_lookup_str(self.general_cqi), xp);
		else
			out.invasions("Invasion: Applying stored character experience amount of " .. self.experience_amount .. " to general " .. self.general_cqi);
			cm:add_agent_experience(cm:char_lookup_str(self.general_cqi), self.experience_amount);
		end
	else
		if self.started == true then
			if by_level == true then
				local xp = cm.character_xp_per_level[experience_amount];
				out.invasions("Invasion: Applying character experience amount (by level) of " .. xp .. " to general " .. self.general_cqi);
				cm:add_agent_experience(cm:char_lookup_str(self.general_cqi), experience_amount);
			else
				out.invasions("Invasion: Applying character experience amount of " .. experience_amount .. " to general " .. self.general_cqi);
				cm:add_agent_experience(cm:char_lookup_str(self.general_cqi), experience_amount);
			end
		else
			out.invasions("Invasion: Preparing character experience amount of " .. experience_amount);
			self.experience_amount = experience_amount;
			self.experience_by_level = by_level or false;
		end
	end
end

--- @function add_unit_experience
--- @desc Allows you to add experience to the units of the army in this invasion
--- @p number unit_experience_amount, The amount of experience to apply
function invasion:add_unit_experience(unit_experience_amount)
	if unit_experience_amount == nil then
		out.invasions("Invasion: Applying stored unit experience amount of " .. self.unit_experience_amount .. " to units of general " .. self.general_cqi);
		cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(self.general_cqi), self.unit_experience_amount);
	else
		if self.started == true then
			out.invasions("Invasion: Applying unit experience amount of " .. unit_experience_amount .. " to units of general " .. self.general_cqi);
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(self.general_cqi), unit_experience_amount);
		else
			self.unit_experience_amount = (self.unit_experience_amount or 0) + unit_experience_amount;
			out.invasions("Invasion: Preparing unit experience amount of " .. unit_experience_amount .. " - Total: " .. self.unit_experience_amount);
		end
	end
end

--- @function add_respawn
--- @desc Allow you to add a respawn to the invasion so that if it dies it will respawn a set amount of times after a set delay
--- @p boolean respawn, If True this invasion will spawn after its force dies
--- @p number respawn_count, The amount of times the invasion will respawn before stopping
--- @p number respawn_delay, The delay before respawning another time after the force respawns
function invasion:add_respawn(respawn, respawn_count, respawn_delay)
	if respawn == true then
		self.respawn = true;
		self.respawn_count = respawn_count or 1;
		self.respawn_delay = respawn_delay or 10;
		self.respawn_turn = 0;
	else
		self.respawn = false;
		self.respawn_count = nil;
		self.respawn_delay = nil;
		self.respawn_turn = nil;
	end
end

--- @function should_maintain_army
--- @desc Allows you to set the invasion to maintain its army strength by adding a missing unit each turn with a percentage chance
--- @p boolean maintain, If True this invasion will attempt to maintain it strength
--- @p number respawn_count, The chance per turn to add one of its missing units
function invasion:should_maintain_army(maintain, chance)
	if maintain == true then
		chance = chance or 100;
		self.maintain_army_chance = chance;
	else
		self.maintain_army_chance = nil;
	end
	self.maintain_army = maintain;
end

--- @section Managing
--- @function start_invasion
--- @desc Starts the invasion, spawning its force if neccessary and handing control of the force over to the script instead of the A.I
--- @p function maintain, If True this invasion will attempt to maintain it strength
--- @p [opt=true] boolean declare_war, If True the invasion will declare war on its targets
--- @p [opt=true] boolean invite_attacker_allies, If True the invasion will invite its allies when declaring war
--- @p [opt=true] boolean invite_defender_allies, If True the invasions target will invite its allies when declaring war
function invasion:start_invasion(callback_function, declare_war, invite_attacker_allies, invite_defender_allies)
	out.invasions("Invasion: Starting Invasion for '"..self.key.."'...");
	if declare_war == nil then
		declare_war = true;
	end
	if invite_attacker_allies == nil then
		invite_attacker_allies = true;
	end
	if invite_defender_allies == nil then
		invite_defender_allies = true;
	end
	
	if self.started == false then
		self.started = true;
		self.callback = callback_function or nil;
		
		if self.prespawned == true then
			out.invasions("\tPre-Spawned force: Ignoring force spawning...");
			self:force_created(self.general_cqi, declare_war, invite_attacker_allies, invite_defender_allies);
		else
			out.invasions("\tSpawning Force '"..tostring(self.unit_list).."'...");
			local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
			
			local x, y = cm:find_valid_spawn_location_for_character_from_position(self.faction, self.spawn.x, self.spawn.y, false);
			
			if x == -1 or y == -1 then
				script_error("ERROR: Trying to start an invasion but could not find a valid spawn position from the given coordinates " .. self.spawn.x .. ", " .. self.spawn.y);
				return false;
			end
			
			if self.new_general ~= nil then
				out.invasions("\t\tCreating force with new general!");
				cm:create_force_with_general(self.faction, self.unit_list, temp_region, x, y, self.new_general.agent_type, self.new_general.agent_subtype, self.new_general.forename, self.new_general.clan_name, self.new_general.family_name, self.new_general.other_name, self.new_general.make_faction_leader,
				function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end, true);
			elseif self.general_cqi == nil then
				cm:create_force_with_full_diplomatic_discovery(self.faction, self.unit_list, temp_region, x, y, true,
				function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end, false);
			else
				out.invasions("\t\tCreating force with existing general!");
				cm:create_force_with_existing_general("character_cqi:"..self.general_cqi, self.faction, self.unit_list, temp_region, x, y,
				function(cqi) self:force_created(cqi, declare_war, invite_attacker_allies, invite_defender_allies) end);
			end
		end
		
		out.invasions("\tAdding Listener 'INVASION_"..self.key.."'");
		core:add_listener(
			"INVASION_"..self.key,
			"FactionBeginTurnPhaseNormal",
			function(context)
				return context:faction():name() == self.faction;
			end,
			function(context) self:advance() end,
			true
		);
	else
		script_error("ERROR: Trying to start an invasion that has already been started!");
	end
end

---- Internal - Function called when the force of the invasion is spawned
function invasion:force_created(general_cqi, declare_war, invite_attacker_allies, invite_defender_allies, was_respawn)
	self.general_cqi = general_cqi;
	self.declare_war = declare_war;
	self.invite_attacker_allies = invite_attacker_allies;
	self.invite_defender_allies = invite_defender_allies;
	
	if was_respawn == nil then
		was_respawn = false;
	end
	
	if self.target_type ~= "NONE" then
		cm:cai_disable_movement_for_character("character_cqi:"..general_cqi);
		
		if self.target_type == "PATROL" then
			self.patrol_position = 1;
		end
	end
	
	if self.immortal_general ~= nil then
		out.invasions("\t\tMaking Character Immortal: "..tostring(self.immortal_general));
		cm:set_character_immortality("character_cqi:"..general_cqi, self.immortal_general);
	end
	
	local force = cm:force_from_general_cqi(general_cqi);
	
	if force then
		self.force_cqi = force:command_queue_index();
	end
	
	out.invasions("\t\tForce Spawned (General CQI: "..tostring(general_cqi)..", Force CQI: "..tostring(self.force_cqi)..", Invasion: "..tostring(self.key)..")");
	
	self.turn_spawned = cm:model():turn_number();
	
	if self.callback ~= nil and type(self.callback) == "function" then
		self.callback(self);
	end
	
	if #self.effect > 0 then
		self:apply_effect();
	end
	
	if self.experience_amount then
		self:add_character_experience();
	end
	
	if self.unit_experience_amount then
		self:add_unit_experience();
	end
	
	if self.target_faction ~= nil then
		local this_faction = cm:get_faction(self.faction);
		local enemy_faction = cm:get_faction(self.target_faction);
		
		if this_faction and enemy_faction then
			if this_faction:at_war_with(enemy_faction) == false then
				if declare_war == true then
					if this_faction:is_vassal() then
						cm:force_declare_war(this_faction:master():name(), self.target_faction, invite_attacker_allies, invite_defender_allies);
					else
						cm:force_declare_war(self.faction, self.target_faction, invite_attacker_allies, invite_defender_allies);
					end
					
					out.invasions("\t\t\tDeclared war on "..tostring(self.target_faction));
				end
			end
		end
	end
	
	if was_respawn == true then
		self.respawn_turn = 0;
		
		if self.respawn_count and self.respawn_count > -1 then
			self.respawn_count = self.respawn_count - 1;
			
			if self.respawn_count == 0 then
				self.respawn = false;
				self.respawn_delay = nil;
				self.respawn_turn = nil;
			end
		end
		core:trigger_event("ScriptEventInvasionManagerRespawn", cm:get_character_by_cqi(general_cqi));
	end
end

---- Internal - Respawn the invasion at its start location
function invasion:attempt_respawn()
	out.invasions("Invasion: Attempting Respawn for '"..self.key.."'...");
	out.invasions("\tRespawns Remaining: "..tostring(self.respawn_count));
	
	if self.respawn_turn >= self.respawn_delay then
		local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
		
		local x, y = cm:find_valid_spawn_location_for_character_from_position(self.faction, self.spawn.x, self.spawn.y, false);
		
		if x == -1 or y == -1 then
			script_error("ERROR: Trying to start an invasion but could not find a valid spawn position from the given coordinates " .. self.spawn.x .. ", " .. self.spawn.y);
			return false;
		end
		
		if cm:model():has_character_command_queue_index(self.general_cqi) == true then
			-- If we can find the existing General to use for the respawn then do that
			out.invasions("\t\tRespawning force with existing general!");
			cm:create_force_with_existing_general("character_cqi:"..self.general_cqi, self.faction, self.unit_list, temp_region, x, y,
			function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end);
		elseif self.new_general ~= nil then
			-- If we couldn't find the existing General and the invasion was initially spawned with a new one, we can remake them
			out.invasions("\t\tRespawning force with new general!");
			cm:create_force_with_general(self.faction, self.unit_list, temp_region, x, y, self.new_general.agent_type, self.new_general.agent_subtype, self.new_general.forename, self.new_general.clan_name, self.new_general.family_name, self.new_general.other_name, self.new_general.make_faction_leader,
			function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end, true);
		elseif self.rogue_army == true then
			cm:spawn_rogue_army(self.faction, x, y);
			local forces = cm:get_faction(self.faction):military_force_list();
			local force_count = forces:num_items();
			
			if force_count > 0 then
				local last_force = forces:item_at(force_count - 1);
				
				if last_force:has_general() == true then
					local cqi = last_force:general_character():command_queue_index();
					self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true);
				end
			end
		else
			-- otherwise let the model create a new character
			cm:create_force_with_full_diplomatic_discovery(self.faction, self.unit_list, temp_region, x, y, true,
			function(cqi) self:force_created(cqi, self.declare_war, self.invite_attacker_allies, self.invite_defender_allies, true) end);
		end
	else
		out.invasions("\tTurns: "..tostring(self.respawn_turn).." / Delay: "..tostring(self.respawn_delay));
		self.respawn_turn = self.respawn_turn + 1;
		out.invasions("\tWaiting another turn...");
	end
end

---- Internal - Advances the invasion, moving or attacking their target if there is one
function invasion:advance()
	out.invasions("Invasion: Advancing Invasion for '"..self.key.."'...");
	local force = self:get_force();
	local should_remove = false;
	
	if force:is_null_interface() == false then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			local general_cqi = general:command_queue_index();
			local general_lookup = "character_cqi:"..general_cqi;
			out.invasions("\tGeneral Lookup: "..general_lookup);
			out.invasions("\tTarget: "..tostring(self.target_type).." ["..tostring(self.target).."]");
			
			if self.maintain_army == true then
				out.invasions("\tMaintaining army...");
				if force:unit_list():num_items() < #self.unit_list_table then
					out.invasions("\t\tArmy is missing units: "..force:unit_list():num_items().."/"..#self.unit_list_table);
					if cm:model():random_percent(self.maintain_army_chance) then
						out.invasions("\t\tArmy succeeded its maintain chance of "..self.maintain_army_chance.."%");
						-- Go through the initial force and the current force to compare the units in both
						local multiple_units = {};
						multiple_units["initial"] = {};
						multiple_units["current"] = {};
						
						for i = 1, #self.unit_list_table do
							local initial_unit = self.unit_list_table[i];
							multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] or 0;
							multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] + 1;
						end
						for i = 0, force:unit_list():num_items() - 1 do
							local current_unit = force:unit_list():item_at(i):unit_key();
							multiple_units["current"][current_unit] = multiple_units["current"][current_unit] or 0;
							multiple_units["current"][current_unit] = multiple_units["current"][current_unit] + 1;
						end
						
						for initial_unit, initial_number in pairs(multiple_units["initial"]) do
							for current_unit, current_number in pairs(multiple_units["current"]) do
								if initial_unit == current_unit then
									if current_number < initial_number then
										-- There are not enough of this unit in the army
										cm:grant_unit_to_character(general_lookup, initial_unit);
										out.invasions("\t\tAdding unit to army: "..initial_unit);
									end
								end
							end
						end
					else
						out.invasions("\t\tArmy failed its maintain chance of "..self.maintain_army_chance.."%");
					end
				end
			end
			
			if self.target_type ~= "NONE" then
				out.invasions("\tDisabling movement for invasion general");
				cm:cai_disable_movement_for_character(general_lookup);
				
				if self.target_faction ~= nil then
					out.invasions("\tOn advance, "..self.faction.." declares war on "..self.target_faction);
					cm:force_declare_war(self.faction, self.target_faction, true, true);
				end
				
				if self.aggro_enabled == true then
					if self.aggro_target_cqi ~= nil then
						out.invasions("\tAggro target already in progress");
						-- We have an aggro target already
						local still_valid = true;
						local target_char = cm:model():character_for_command_queue_index(self.aggro_target_cqi);
						
						-- Check if the target is still valid
						still_valid = target_char:is_null_interface() == false;
						still_valid = still_valid and target_char:has_military_force() == true;
						still_valid = still_valid and target_char:in_settlement() == false;
						still_valid = still_valid and target_char:is_at_sea() == general:is_at_sea();

						if still_valid == true then
							-- This check prevents Black Arks from causing naval attacks to end up on land
							if general:is_at_sea() == true and target_char:in_settlement() == true then
								still_valid = false;
							end
						end
						-- Check if the invasion has been chasing this aggro target for too long
						still_valid = still_valid and self.aggro_turn_abort_value < self.aggro_turn_abort;
						
						if still_valid then
							out.invasions("\tAggro target already in progress ("..tostring(self.aggro_target_cqi).." - "..target_char:faction():name()..")");
						else
							out.invasions("\tTarget is no longer valid!");
							self.aggro_target_cqi = nil;
							self.aggro_cooldown_value = self.aggro_cooldown;
						end
					end
					
					if self.aggro_target_cqi == nil then
						out.invasions("\tAggro is enabled - Targets:");
						for tar = 1, #self.aggro_targets do
							if self.aggro_targets[1] == "war" then
								out.invasions("\t\tAny factions at war");
							else
								out.invasions("\t\t'"..tostring(self.aggro_targets[tar]).."'");
							end;
						end
						
						-- We don't have an aggro target
						if self.aggro_cooldown_value > 0 then
							-- Invasion is in aggro cooldown
							self.aggro_cooldown_value = self.aggro_cooldown_value - 1;
							out.invasions("\t\tAggro cooldown is in effect ("..tostring(self.aggro_cooldown_value)..")");
						else
							out.invasions("\t\tAttempting to find target in aggro radius ("..tostring(self.aggro_radius)..")");
							local aggro_target_cqi, aggro_target_faction_name = self:find_aggro_target();
							
							if aggro_target_cqi ~= nil then
								out.invasions("\t\t\tFound target: "..tostring(aggro_target_cqi).." in faction " ..tostring(aggro_target_faction_name));
								self.aggro_target_cqi = aggro_target_cqi;
							else
								out.invasions("\t\t\tCouldn't find target");
							end
						end
					end
				end
				
				if self.aggro_enabled == true and self.aggro_target_cqi ~= nil then
					----------------------------------------------------------------------------------
					---- AGGRO TARGET ----------------------------------------------------------------
					----------------------------------------------------------------------------------
					---- Invasion force found a target within its aggro radius and will attack it ----
					----------------------------------------------------------------------------------
					local char_obj = cm:model():character_for_command_queue_index(self.aggro_target_cqi);
					
					if char_obj:is_null_interface() == false then
						local target_character_lookup = "character_cqi:"..self.aggro_target_cqi;
						out.invasions("\tAttacking aggro target: "..tostring(self.aggro_target_cqi));
						cm:cai_disable_movement_for_character(general_lookup);
						cm:enable_movement_for_character(general_lookup);
						cm:replenish_action_points(general_lookup);
						cm:force_declare_war(char_obj:faction():name(), general:faction():name(), false, false);
						cm:attack_queued(general_lookup, target_character_lookup);
						self.aggro_turn_abort_value = self.aggro_turn_abort_value + 1;
						out.invasions("\t\tTurns spent in aggro: "..tostring(self.aggro_turn_abort_value));
					else
						script_error("ERROR: Aggro Target CQI is set but interface was null");
					end
				elseif self.target_type == "LOCATION" then
					--------------------------------------------------------------------------------
					---- LOCATION ------------------------------------------------------------------
					--------------------------------------------------------------------------------
					---- Move to a location and then release the army when it gets close enough ----
					--------------------------------------------------------------------------------
					out.invasions("\tMoving to Location... ["..self.target.x..", "..self.target.y.."]");
					local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target.x, self.target.y);
					out.invasions("\tDistance from target = "..distance_from_target);
				
					if distance_from_target < 2 then
						out.invasions("\tArrived at Location!");
						self.target_type = "NONE";
					else
						out.invasions("\tMoving...");
						cm:move_to_queued(general_lookup, self.target.x, self.target.y);
					end
				elseif self.target_type == "CHARACTER" then
					-------------------------------------------------------------------------------------
					---- CHARACTER ----------------------------------------------------------------------
					-------------------------------------------------------------------------------------
					---- Attack a character as long as they aren't a null interface and have a force ----
					-------------------------------------------------------------------------------------
					local target_character_cqi = self.target;
					local target_character_lookup = "character_cqi:"..target_character_cqi;
					local tagert_character_obj = cm:model():character_for_command_queue_index(target_character_cqi);
					
					if tagert_character_obj:is_null_interface() == false and tagert_character_obj:has_military_force() then
						out.invasions("\tAttacking Character...");
						cm:cai_disable_movement_for_character(general_lookup);
						cm:enable_movement_for_character(general_lookup);
						cm:replenish_action_points(general_lookup);
						cm:attack_queued(general_lookup, target_character_lookup);
					else
						out.invasions("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "REGION" then
					-----------------------------------------------------------------------------------
					---- REGION -----------------------------------------------------------------------
					-----------------------------------------------------------------------------------
					---- Attack a region providing it is not a null interface and is not abandoned ----
					-----------------------------------------------------------------------------------
					local target_region_key = self.target;
					local target_region_obj = cm:model():world():region_manager():region_by_key(target_region_key);
					
					if target_region_obj:is_null_interface() == false and target_region_obj:is_abandoned() == false then
						local region_owner = target_region_obj:owning_faction():name();
						
						if region_owner == self.target_faction then
							out.invasions("\tAttacking Region...");
							cm:cai_disable_movement_for_character(general_lookup);
							cm:enable_movement_for_character(general_lookup);
							cm:replenish_action_points(general_lookup);
							cm:attack_region(general_lookup, target_region_key);
						else
							out.invasions("\tTarget Region owner is no longer initial faction target:");
							out.invasions("\t\tInitial: "..tostring(self.target_faction));
							out.invasions("\t\tCurrent: "..region_owner);
							
							if self.target_owner_abort == false then
								out.invasions("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Switching Target Faction!");
								self.target_faction = region_owner;
								cm:force_declare_war(self.faction, self.target_faction, true, true);
							else
								out.invasions("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Aborting Invasion!");
								self.target_type = "NONE";
							end
						end
					else
						out.invasions("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "FORCE" then
					-------------------------------------------------------------------------------
					---- FORCE --------------------------------------------------------------------
					-------------------------------------------------------------------------------
					---- Attack a force providing it is not a null interface and has a general ----
					-------------------------------------------------------------------------------
					local target_force_cqi = self.target;
					local target_force_obj = cm:model():military_force_for_command_queue_index(target_force_cqi);
					
					if target_force_obj:is_null_interface() == false then
						if target_force_obj:has_general() == true then
							local enemy_general_cqi = target_force_obj:general_character():command_queue_index();
							local enemy_general_lookup = "character_cqi:"..enemy_general_cqi;
							
							out.invasions("\tAttacking Force...");
							cm:cai_disable_movement_for_character(general_lookup);
							cm:enable_movement_for_character(general_lookup);
							cm:replenish_action_points(general_lookup);
							cm:attack_queued(general_lookup, enemy_general_lookup);
						end
					else
						out.invasions("\tCouldn't find target... releasing force!");
						self.target_type = "NONE";
					end
				elseif self.target_type == "PATROL" then
					------------------------------------------------------------------------------------
					---- PATROL ------------------------------------------------------------------------
					------------------------------------------------------------------------------------
					---- Walks to a set of coordinates indefinitely until destroyed or told to stop ----
					------------------------------------------------------------------------------------
					out.invasions("\tFollowing patrol route...");
					out.invasions("\tNext patrol point: #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
					local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target[self.patrol_position].x, self.target[self.patrol_position].y);
					out.invasions("\tDistance from next patrol point " .. general:logical_position_x() .. ", " .. general:logical_position_y() .. " -> " .. self.target[self.patrol_position].x .. ", " .. self.target[self.patrol_position].y .. " = "..distance_from_target);
					
					if distance_from_target < 2 then
						out.invasions("\tArrived at patrol location #"..self.patrol_position);
						
						if self.patrol_position == #self.target then
							out.invasions("\t\tLast patrol position reached...");
							
							if self.stop_at_end == true then
								out.invasions("\t\t\tStopping!");
								self.target_type = "NONE";
								self.patrol_position = 0;
							else
								self.patrol_position = 1;
								out.invasions("\t\t\tRestarting patrol and moving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
								cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
							end
						elseif self.target[self.patrol_position + 1] ~= nil then
							self.patrol_position = self.patrol_position + 1;
							out.invasions("\t\tMoving to next patrol point... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
							cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
						else
							out.invasions("\t\t\tAborting?!");
							self.target_type = "NONE";
							self.patrol_position = 0;
						end
					else
						out.invasions("\tMoving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
						cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
					end
				elseif self.target_type == "TZEENTCH_COORDS" then
					----------------------------------------------------------------------------------------------------------------------------------
					---- TZEENTCH_COORDS -------------------------------------------------------------------------------------------------------------
					----------------------------------------------------------------------------------------------------------------------------------
					---- Walks to the nearest coordinate (within the same region as the general) found within the supplied table of coordinates ------
					----------------------------------------------------------------------------------------------------------------------------------
					out.invasions("\tFinding nearest coordinate...");
					
					local closest_distance = 500000;
					local desired_position = {};
					local general_position_x = general:logical_position_x();
					local general_position_y = general:logical_position_y();
					local general_region = general:region_data():key();
					local world = cm:model():world();
					
					for i = 1, #self.target do
						local current_x = self.target[i][1];
						local current_y = self.target[i][2];
						
						if general_position_x ~= current_x and general_position_y ~= current_y and general_region ~= world:region_data_at_position(current_x, current_y) then
							local current_distance = distance_squared(general_position_x, general_position_y, current_x, current_y);
							
							if current_distance < closest_distance then
								closest_distance = current_distance;
								desired_position.x = current_x;
								desired_position.y = current_y;
							end;
						end;
					end;
					
					out.invasions("\tMoving... ["..desired_position.x..", "..desired_position.y.."]");
					cm:move_to_queued(general_lookup, desired_position.x, desired_position.y);
				end
			end
		end
	else
		-- This invasion force is a null interface, likely meaning it is dead
		out.invasions("\tForce is a null interface, assuming it has died...");
		
		if self.respawn == true then
			self:attempt_respawn();
		else
			self.target_type = "NONE";
			should_remove = true;
		end
	end
	
	if self.target_type == "NONE" then
		local general = self:get_general();
		
		if general:is_null_interface() == false then
			local general_cqi = general:command_queue_index();
			local general_lookup = "character_cqi:"..general_cqi;
			
			if self.stop_at_end == true then
				out.invasions("\tInvasion has been told to stop after completion");
				out.invasions("\tDisabling movement for invasion general");
				cm:cai_disable_movement_for_character(general_lookup);
			else
				out.invasions("\tEnabling movement for invasion general ["..general_lookup.."]");
				cm:cai_enable_movement_for_character(general_lookup);
				cm:enable_movement_for_character(general_lookup);
				should_remove = true;
			end
		end
		
		if should_remove == true then
			invasion_manager:remove_invasion(self.key);
		end
	end
end

---- Internal - Attempts to find a target for the invasion if it has aggrevation behaviour enabled
function invasion:find_aggro_target() -- TODO: might want to return the weakest force here, as currently will return the first one it finds
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		local pos_x = general:logical_position_x();
		local pos_y = general:logical_position_y();
		local at_sea = general:is_at_sea();
		
		if self.aggro_targets[1] == "war" then
			local faction_list = general:faction():factions_at_war_with();
			self.aggro_targets = {};
			
			for i = 0, faction_list:num_items() - 1 do
				table.insert(self.aggro_targets, faction_list:item_at(i):name());
			end
		end
		
		for i = 1, #self.aggro_targets do
			local target_faction = cm:get_faction(self.aggro_targets[i]);
			
			if target_faction then
				for j = 0, target_faction:military_force_list():num_items() - 1 do
					local force = target_faction:military_force_list():item_at(j);
					
					if force:is_armed_citizenry() == false and force:has_general() == true then
						local enemy_general = force:general_character();
						
						if enemy_general:is_at_sea() == at_sea then
							if self.aggro_radius < 1 then
								if self.aggro_radius == 0 or cm:character_can_reach_character(general, enemy_general) then
									return enemy_general:command_queue_index(), self.aggro_targets[i];
								end
							else
								local distance = distance_squared(pos_x, pos_y, enemy_general:logical_position_x(), enemy_general:logical_position_y());
								
								if distance <= self.aggro_radius then
									return enemy_general:command_queue_index(), self.aggro_targets[i];
								end
							end
						end
					end
				end
			end
		end
	end
end

--- @function release
--- @desc Releases the invasion force back to AI control
function invasion:release()
	out.invasions("Invasion: Releasing Invasion with key '"..self.key.."'...");
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		local general_cqi = general:command_queue_index();
		local general_lookup = "character_cqi:"..general_cqi;
		
		out.invasions("\tEnabling movement for invasion general ["..general_lookup.."]");
		cm:cai_enable_movement_for_character(general_lookup);
		cm:enable_movement_for_character(general_lookup);
		invasion_manager:remove_invasion(self.key);
	end
end

--- @function kill
--- @desc Kills this invasions General and the whole force (or just the General)
--- @p boolean general_only, If True only the Generate will be killed and the force will remain
function invasion:kill(general_only)
	general_only = general_only or false;
	local commander = self:get_commander();
	
	if commander:is_null_interface() == false then
		out.invasions("Invasion: Killing Invasion with key '"..self.key.."'...");
		local commander_cqi = commander:command_queue_index();
		local killed = cm:kill_character(commander_cqi, not general_only);
		out.invasions("\tKilled: "..tostring(killed));
	end
	self:remove_target();
	invasion_manager:remove_invasion(self.key);
end

--- @section Inspecting
--- @function get_general
--- @desc Returns the character leading this invasion force
--- @r character The general of the invasions force
function invasion:get_general()
	local force = self:get_force();
	
	if force:is_null_interface() == false then
		if force:has_general() == true then
			return force:general_character();
		end
	end
	return cm:null_interface();
end

--- @function get_commander
--- @desc Returns the character that is the current leader of this force even if it is a colonel
--- @r character The commander of the invasions force
function invasion:get_commander()
	local general = self:get_general();
	
	if general:is_null_interface() == false then
		return general;
	else
		local force = self:get_force();
		
		if force:is_null_interface() == false then
			local characters = force:character_list();
			
			for i = 0, characters:num_items() - 1 do
				local current_char = characters:item_at(i);
				
				if current_char:character_type("colonel") then
					return current_char;
				end
			end
		end
	end
	return cm:null_interface();
end

--- @function get_force
--- @desc Returns the force interface of this invasion
--- @r military_force The military force belonging to the invasion
function invasion:get_force()
	if cm:model():has_military_force_command_queue_index(self.force_cqi) then
		return cm:model():military_force_for_command_queue_index(self.force_cqi);
	end
	return cm:null_interface();
end

--- @function has_target
--- @desc Checks if an invasion has a target
--- @r boolean Returns True if the invasion has a target
function invasion:has_target()
	return (self.target ~= nil);
end

--- @function has_started
--- @desc Checks if an invasion has started
--- @r boolean Returns True if this invasion has started
function invasion:has_started()
	return self.started or false;
end

--- @function turn_spawned
--- @desc Checks what turn this invasion was spawned on
--- @r number Returns the turn number that this invasion was started on, or 0 if it has not been
function invasion:turn_spawned()
	return self.turn_spawned or 0;
end

--------------------------
---- Saving / Loading ----
--------------------------
function save_invasion_manager(context)
	cm:save_named_value("Invasion_Manager", invasion_manager, context);
end

function load_invasion_manager(context)
	local loaded_invasion_manager = cm:load_named_value("Invasion_Manager", invasion_manager, context);
	out.savegame("\t"..tostring(loaded_invasion_manager));
	out.invasions("Loaded invasion manager");
	
	if next(loaded_invasion_manager.invasions) == nil then
		out.savegame("\tThere are no saved invasions");
		out.invasions("\tThere are no saved invasions");
	end;
	
	for key, value in pairs(loaded_invasion_manager.invasions) do
		out.savegame("\t\tKey: "..tostring(key)..", Value: "..tostring(value));
		out.invasions("\t\tKey: "..tostring(key)..", Value: "..tostring(value));
		local loaded_invasion = invasion:new(value);
		invasion_manager.invasions[key] = loaded_invasion;
		
		if loaded_invasion:has_started() then
			-- Re-enable the invasion listeners
			out.savegame("\tAdding Listener 'INVASION_"..key.."'");
			out.invasions("\tAdding Listener 'INVASION_"..key.."'");
			core:add_listener(
				"INVASION_"..key,
				"FactionBeginTurnPhaseNormal",
				function(context)
					return context:faction():name() == value.faction;
				end,
				function(context) value:advance() end,
				true
			);
		end
	end
	core:add_listener(
		"INVASION_respawn_check",
		"EndOfRound",
		true,
		function()
			for key, value in pairs(invasion_manager.invasions) do
				if value:has_started() == true and value.respawn == true then
					local force = value:get_force();
					
					if force:is_null_interface() == true then
						value:advance();
					end
				end
			end
		end,
		true
	);
end