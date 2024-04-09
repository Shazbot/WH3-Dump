


--- @set_environment battle

----------------------------------------------------------------------------
-- this section is defined in lib_convex_area
--- @section Vector Manipulation
----------------------------------------------------------------------------

--- @function v
--- @desc A shorthand method for creating a @battle_vector. Battle only.
--- @p number x position
--- @p number y position
--- @p number z position
--- @r vector
function v(x, y, z)
	if (not is_number(x)) or (not is_number(y)) then
		script_error("ERROR: v() called but didn't get at least two numeric parameters: " .. tostring(x) .. " and " .. tostring(y));
		
		return false;
	end;

	local retval = battle_vector:new();

	if is_number(z) then
		-- we are creating a 3D vector
		retval:set(x, y, z);
	else
		-- we are creating a 2D vector
		retval:set(x, 0, y);
	end;
	
	return retval;
end;


--- @function v_from_context_str
--- @desc Assembles and returns a vector from a supplied ui context string. The string should specify a function that returns co-ordinates, which can then be assembled into a vector.
--- @p [opt=nil] @string object id
--- @p [opt=nil] @string constructed string
--- @p @string function id
--- @r @battle_vector vector
function v_from_context_str(object_id, construction_str, function_id)
	if function_id then
		if not is_string(object_id) then
			script_error("ERROR: v_from_context() called but supplied object id [" .. tostring(object_id) .. "] is not a string");
			return false;
		end;

		if not is_string(function_id) then
			script_error("ERROR: v_from_context() called but supplied function id [" .. tostring(function_id) .. "] is not a string");
			return false;
		end;

		local x, y, z, w = common.get_context_value(object_id, construction_str, function_id);

		if not is_number(x) then
			script_error("ERROR: v_from_context() called but no position generated from supplied context string - object id " .. object_id .. ", construction string " .. construction_str .. ", function id " .. function_id);
		end;

		return v(x, y, z);
	else
		object_id = function_id;

		if not is_string(function_id) then
			script_error("ERROR: v_from_context() called but supplied function id [" .. tostring(function_id) .. "] is not a string");
			return false;
		end;

		local x, y, z, w = common.get_context_value(function_id, construction_str);

		if not is_number(x) then
			script_error("ERROR: v_from_context() called but no position generated from supplied context string - object id " .. object_id .. ", construction string " .. construction_str .. ", function id " .. function_id);
		end;

		return v(x, y, z);
	end;
	
	if not x and y then
		script_error("ERROR: v_from_context() called but supplied argument [" .. tostring(context_str) .. "] is not a string");
		return false;
	end;
end;



----------------------------------------------------------------------------
--- @section Sound
----------------------------------------------------------------------------

--- @function new_sfx
--- @desc A shorthand method for creating a sound effect object.
--- @p string sound event, Name of sound event
--- @r battle_sound_effect
function new_sfx(soundfile)
	local retval = battle_sound_effect:new();
	retval:load(soundfile);
	
	-- Check file exists.
	if not retval:is_valid() then
		script_error("new_sfx() called but supplied parameter is " .. tostring(soundfile) .. " and not a valid sound file. No audio will play.");
	end;
	
	return retval;
end;


--- @function play_sound
--- @desc Plays a sound effect at a position.
--- @p vector position
--- @p battle_sound_effect sound effect
function play_sound(position, sound)

	if not is_vector(position) then
		script_error("ERROR: play_sound() called but supplied position [" .. tostring(position) .. "] is not a vector");
		return false;
	end;
	
	if not is_battlesoundeffect(sound) or not sound:is_valid() then
		script_error("ERROR: play_sound() called but supplied sound [" .. tostring(sound) .. "] is not a valid battle sound effect");
		return false;
	end;
	
	sound:play3D(position);
end;


--- @function play_sound_2D
--- @desc Plays a sound effect. Sound will play at normal volume and will not appear to come from a position in 3D space.
--- @p battle_sound_effect sound effect
function play_sound_2D(sound)
	if not is_battlesoundeffect(sound) or not sound:is_valid() then
		script_error("ERROR: play_sound_2D() called but supplied sound [" .. tostring(sound) .. "] is not a valid battle sound effect");
		return false;
	end;

	sound:play3D();
end;


--- @function stop_sound
--- @desc Stops a sound, if it's playing.
--- @p battle_sound_effect sound effect
function stop_sound(sound)
	if sound then
		sound:stop();
	end;
end;





----------------------------------------------------------------------------
--- @section Unitcontroller Creation
----------------------------------------------------------------------------


--- @function create_unitcontroller
--- @desc Shorthand method for creating a unitcontroller. Supply a host army, along with zero or more units belonging to the same army that will be placed within the unitcontroller
--- @p army host army
--- @p ... list of units
--- @r unitcontroller
function create_unitcontroller(...)
	local army;

	-- check that all supplied units belong to the supplied army
	for i = 1, arg.n do
		if not is_unit(arg[i]) then
			script_error("ERROR: create_unitcontroller() called but supplied arg [" .. i .. "] is not a valid unit object, its value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;

		if not army then
			army = arg[i]:army();
		elseif arg[i]:army() ~= army then
			script_error("ERROR: create_unitcontroller() called but unit [" .. i .. "] with id [" .. arg[i]:unique_ui_id() .. "] belongs to army [" .. tostring(arg[i]:army()) .. "] which is different from army [" .. tostring(army) .. "] of the first supplied scriptunit (id: [" .. arg[1]:unique_ui_id() .. "])");
			return false;
		end;
	end;

	local uc = army:create_unit_controller();
	
	if not is_unitcontroller(uc) then
		script_error("ERROR: create_unitcontroller() failed to create a unitcontroller on the army, possibly everyone in the army is dead? The army [" .. tostring(army) .. "] thinks it has " .. army:count() .. " units");
		return false;
	end;
	
	for i = 1, arg.n do
		if is_unit(arg[i]) then
			uc:add_units(arg[i]);
		end;
	end;
	
	return uc;
end;


--- @function unitcontroller_from_army
--- @desc Creates a unitcontroller from a supplied army, containing all the units within that army.
--- @p army host army
--- @r unitcontroller
function unitcontroller_from_army(army)
	if not is_army(army) then
		script_error("unitcontroller_from_army called but supplied parameter is " .. tostring(army) .. " and not an army!");
		
		return nil;
	end;

	local uc = army:create_unit_controller();
	local units = army:units();
	
	for i = 1, units:count() do
		uc:add_units(units:item(i));
	end;
	
	-- try and put in reinforcing units too
	for i = 1, army:num_reinforcement_units() do
		local r_units = army:get_reinforcement_units(i);
		
		if is_units(r_units) then
			for j = 1, r_units:count() do
				uc:add_units(r_units:item(j));
			end;
		end;
	end;

	return uc;
end;




----------------------------------------------------------------------------
--- @section Unit Routing and Engagement Tests
----------------------------------------------------------------------------


--- @function is_routing_or_dead
--- @desc Returns true if all units in the supplied object/collection are routing or dead.
--- @p object collection to test, Object or collection to test. Supported objects/collections are unit, scriptunit, scriptunits, units, army, armies, alliance or a table containing any of the above.
--- @p [opt=false] boolean shattered only, Only count shattered units
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
--- @r boolean all units routing or dead
function is_routing_or_dead(obj, shattered_only, permit_rampaging)
	if is_unit(obj) then
		if shattered_only then
			if obj:is_shattered() or obj:number_of_men_alive() == 0 then	
				return true;
			end;
		elseif permit_rampaging then
			if obj:is_routing() or obj:number_of_men_alive() == 0 then
				return true;
			end;
		else
			if obj:is_routing() or obj:is_rampaging() or obj:number_of_men_alive() == 0 then
				return true;
			end;
		end;
	
		return false;
	elseif is_scriptunit(obj) then
		return is_routing_or_dead(obj.unit, shattered_only, permit_rampaging);
	
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if not is_routing_or_dead(obj:item(i), shattered_only, permit_rampaging) then
				return false;
			end;
		end;
		
		return true;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			if not is_routing_or_dead(obj:item(i), shattered_only, permit_rampaging) then
				return false;
			end;
		end;
		
		return true;
		
	elseif is_army(obj) then
		
		local result = is_routing_or_dead(obj:units(), shattered_only, permit_rampaging);
		
		if not result then
			return false;
		else
			-- also consider reinforcing units
			for i = 1, obj:num_reinforcement_units() do
				local r_units = obj:get_reinforcement_units(i);
				
				result = is_routing_or_dead(r_units, shattered_only, permit_rampaging);
				
				if not result then
					return false;
				end;
			end;
	
			return true;
		end;
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if not is_routing_or_dead(obj:item(i):units(), shattered_only, permit_rampaging) then
				return false;
			end;
		end;
		
		return true;
	elseif is_alliance(obj) then
		return is_routing_or_dead(obj:armies(), shattered_only, permit_rampaging);
		
	elseif is_table(obj) then
		for i = 1, #obj do
			if not is_routing_or_dead(obj[i], shattered_only, permit_rampaging) then
				return false;
			end;
			
		end;

		return true;
	else
		script_error("ERROR: is_routing_or_dead() called but didn't recognise parameter " .. tostring(obj));
	end;
	
	return false;
end;


--- @function is_shattered_or_dead
--- @desc Alias for <code>is_routing_or_dead(obj, <strong>true</strong>, permit_rampaging)</code>. Returns true if all units in the supplied object/collection are shattered or dead.
--- @p object collection to test, Object or collection to test. Supported objects/collections are unit, scriptunit, scriptunits, units, army, armies, alliance or a table containing any of the above.
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually shattered too.
--- @r boolean all units shattered or dead
function is_shattered_or_dead(obj, permit_rampaging)
	return is_routing_or_dead(obj, true, permit_rampaging);
end;


--- @function num_units_routing
--- @desc Returns the number of units in the supplied collection that are routing or dead.
--- @desc The second parameter, if true, instructs <code>num_units_routing</code> to only count those units that are shattered or dead. The third parameter, if true, instructs the function to not automatically count rampaging units - they have to be actually routing as well.
--- @p object collection to test, Object or collection to test. Supported objects/collections are units, scriptunits, army, armies, alliance or a table containing any of the above, or units/scriptunits.
--- @p [opt=false] boolean shattered only, Only count shattered units
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
--- @r integer number of routing or dead units
function num_units_routing(obj, shattered_only, permit_rampaging)
	local count = 0;
			
	-- units, scriptunits and table objects will need check functions building so consider them first
	if is_units(obj) or is_scriptunits(obj) or is_table(obj) then
		
		-- build a check based on whether we care about routing or shattered units	
		local function check_to_perform(obj)
			return is_routing_or_dead(obj, shattered_only, permit_rampaging);
		end;
		
		if is_units(obj) then
			for i = 1, obj:count() do
				if check_to_perform(obj:item(i)) then
					count = count + 1;
				end;
			end;
		
		elseif is_scriptunits(obj) then
			for i = 1, obj:count() do
				if check_to_perform(obj:item(i).unit) then
					count = count + 1;
				end;
			end;
	
		else
			for i = 1, #obj do
				local current_obj = obj[i];
				if is_unit(current_obj) then
					-- element in table is a unit
					if check_to_perform(current_obj) then
						count = count + 1;
					end;
				elseif is_scriptunit(current_obj) then
					-- element in table is a scriptunit
					if check_to_perform(obj[i].unit) then
						count = count + 1
					end;
				else
					-- element in table is something else, let's hope it's supported !
					count = count + num_units_routing(obj[i], shattered_only, permit_rampaging);
				end;
			end;
		end;
			
	elseif is_army(obj) then
		count = num_units_routing(obj:units(), shattered_only, permit_rampaging);
		
		-- try reinforcing units too
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			
			if is_units(r_units) then
				count = count + num_units_routing(r_units, shattered_only, permit_rampaging);
			end;
		end;
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			count = count + num_units_routing(obj:item(i):units(), shattered_only, permit_rampaging);
		end;

	elseif is_alliance(obj) then
		count = num_units_routing(obj:armies(), shattered_only, permit_rampaging);
		
	else
		script_error("ERROR: num_units_routing() called but didn't recognise supplied parameter [" .. tostring(obj) .. "], returning 0");
	end;

	return count;
end;


--- @function num_units_shattered
--- @desc Alias of <code>num_units_routing(obj, <strong>true</strong>, permit_rampaging)</code>. Returns the number of units in the supplied collection that are shattered or dead. Supported collections are units, scriptunits, army, armies, alliance or a table containing any of the above, or units/scriptunits.
--- @desc The second parameter, if true, instructs <code>num_units_shattered</code> to not automatically count those units that are rampaging.
--- @p object collection to test, Object or collection to test. Supported objects/collections are units, scriptunits, army, armies, alliance or a table containing any of the above, or units/scriptunits.
--- @p [opt=false] boolean permit rampaging, Don't automatically count rampaging units, check if they are actually routing too.
--- @r integer number of shattered or dead units
function num_units_shattered(obj, permit_rampaging)
	return num_units_routing(obj, true, permit_rampaging);
end;


--- @function num_units_engaged
--- @desc Returns the number of units in the supplied collection which are currently engaged in melee.
--- @p object collection to test, Collection to test. Supported collection types are units, scriptunits, army, armies, alliance and table.
--- @r number of units engaged in melee
function num_units_engaged(obj)
	local count = 0;
	
	if is_units(obj) then
		for i = 1, obj:count() do
			if obj:item(i):is_in_melee() then
				count = count + 1;
			end;
		end;
		return count;
	
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if obj:item(i).unit:is_in_melee() then
				count = count + 1;
			end;
		end;
		return count;
		
	elseif is_army(obj) then
		return num_units_engaged(obj:units());

	elseif is_armies(obj) then
		for i = 1, obj:count() do
			count = count + num_units_engaged(obj:item(i));
		end;
		return count;
	
	elseif is_alliance(obj) then
		return num_units_engaged(obj:armies());
		
	elseif is_table(obj) then
		for i = 1, #obj do
			count = count + num_units_engaged(obj[i]);
		end;
		return count;
	
	else
		script_error("ERROR: num_units_engaged() called but didn't recognise supplied parameter [" .. tostring(obj) .. "], returning 0");
	end;

	return count;
end;


--- @function num_units_under_fire
--- @desc Returns the number of units in the supplied collection which are currently under missile fire.
--- @p object collection to test, Collection to test. Supported collection types are units, scriptunits, army, armies, alliance and table.
--- @r number of units under fire
function num_units_under_fire(obj)
	local count = 0;
	
	if is_units(obj) then
		for i = 1, obj:count() do
			if obj:item(i):is_under_missile_attack() then
				count = count + 1;
			end;
		end;
		return count;
	
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if obj:item(i).unit:is_under_missile_attack() then
				count = count + 1;
			end;
		end;
		return count;
		
	elseif is_army(obj) then
		return num_units_under_fire(obj:units());

	elseif is_armies(obj) then
		for i = 1, obj:count() do
			count = count + num_units_under_fire(obj:item(i));
		end;
		return count;
	
	elseif is_alliance(obj) then
		return num_units_under_fire(obj:armies());
		
	elseif is_table(obj) then
		for i = 1, #obj do
			count = count + num_units_under_fire(obj[i]);
		end;
		return count;
	
	else
		script_error("ERROR: num_units_under_fire() called but didn't recognise supplied parameter [" .. tostring(obj) .. "], returning 0");
	end;

	return count;
end;


--- @function rout_all_units
--- @desc Instantly rout all units in the supplied collection.
--- @p object collection of units, Collection of units to rout. Supported collection types are scriptunits, army, armies, alliance and table.
function rout_all_units(obj)
	if is_army(obj) then
		local uc = unitcontroller_from_army(obj);
		
		-- ensure any reinforcing units are actually on the battlefield
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);

			if is_units(r_units) then
				for j = 1, r_units:count() do
					r_units:item(j):deploy_reinforcement(true);
				end;
			end;
		end;

		uc:morale_behavior_rout();
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			rout_all_units(obj:item(i));
		end;
		
	elseif is_alliance(obj) then
		rout_all_units(obj:armies());
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			obj:item(i).uc:morale_behavior_rout();
		end;
		
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_element = obj[i];
			
			if is_unitcontroller(current_element) then
				current_element:morale_behavior_rout();
			
			elseif is_scriptunit(current_element) then
				current_element.uc:morale_behavior_rout();
			
			else
				rout_all_units(current_element);
				
			end;
		end;
		
	else
		script_error("ERROR: rout_all_units() called but supplied object " .. tostring(obj) .. " wasn't recognised!");
	end;
	
	return;
end;





----------------------------------------------------------------------------
--- @section Unit Position Tests
----------------------------------------------------------------------------


--- @function number_close_to_position
--- @desc Returns the number of units or sunits in a supplied collection within a given range of a given position.
--- @p object collection of units, Collection of units. Supported collection types are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p number range in m
--- @p boolean 2D only, Consider 2 dimensional distance only. If true, then <code>number_close_to_position</code> disregards height differences in its distance calculation.
--- @p boolean non-routing only, Disregard routing or dead units from inclusion in the result.
--- @r integer number within range of position
function number_close_to_position(obj, pos, range, two_d, standing_only, return_bool)
	local count = 0;
	
	local two_d = two_d or false;
	local standing_only = standing_only or false;
	local return_bool = return_bool or false;
	
	if is_unit(obj) then
		-- assemble a check
		local range_check = false;
		if two_d then
			range_check = function() return obj:position():distance_xz(pos) < range end;
		else
			range_check = function() return obj:position():distance(pos) < range end;
		end;
			
		-- if we either don't care about rout status, or we do and the unit isn't routing
		-- then return whether the unit passes the range check
		if (not standing_only) or (standing_only and not is_routing_or_dead(obj)) then
			local result = range_check();
			
			if result then
				if return_bool then
					return true;
				else
					return 1;
				end;
			else
				if return_bool then
					return false;
				else
					return 0;
				end;
			end
		end;
		
		if return_bool then
			return false;
		else
			return 0;
		end;
	end;
	
	if is_scriptunit(obj) then
		return number_close_to_position(obj.unit, pos, range, two_d, standing_only, return_bool);
	end;
	
	-- do param check now (otherwise it would spam an error for each unit in the collection)
	if not is_vector(pos) then
		script_error("ERROR: number_close_to_position() called but position given " .. tostring(pos) .. " is not a vector!");
		
		return nil;
	end;
		
	if not is_number(range) or range <= 0 then
		script_error("ERROR: number_close_to_position() called but range given " .. tostring(range) .. " is not a positive number!");
		
		return nil;
	end;
	
	if is_scriptunits(obj) then
		for i = 1, obj:count() do
			local result = number_close_to_position(obj:item(i), pos, range, two_d, standing_only, return_bool);
			
			if result then
				if return_bool then
					return true;
				else
					count = count + 1;
				end;
			end;
		end;
	
	elseif is_units(obj) then			
		for i = 1, obj:count() do
			local result = number_close_to_position(obj:item(i), pos, range, two_d, standing_only, return_bool);
			
			if result then
				if return_bool then
					return true;
				else
					count = count + 1;
				end;
			end;				
		end;
	
	elseif is_army(obj) then
		local result = number_close_to_position(obj:units(), pos, range, two_d, standing_only, return_bool);
		
		if return_bool then 
			if result then
				return true;
			end;
		else
			count = count + result;
		end;
		
		for i = 1, obj:num_reinforcement_units() do
			-- try reinforcing units
			local r_units = obj:get_reinforcement_units(i);

			if is_units(r_units) then
				result = number_close_to_position(r_units, pos, range, two_d, standing_only, return_bool);
				
				if return_bool then
					if result then
						return true;
					end;
				else
					count = count + result;
				end;
			end;
		end;

	elseif is_armies(obj) then
		local result = nil;
	
		for i = 1, obj:count() do
			result = number_close_to_position(obj:item(i), pos, range, two_d, standing_only, return_bool);
			
			if return_bool then
				if result then
					return true;
				end;
			else
				count = count + result;
			end;				
		end;
	
	elseif is_alliance(obj) then
		return number_close_to_position(obj:armies(), pos, range, two_d, standing_only, return_bool);
	
	elseif is_table(obj) then
		local result = nil;
		
		for i = 1, #obj do
			result = number_close_to_position(obj[i], pos, range, two_d, standing_only, return_bool);
			
			if return_bool then
				if result then
					return true;
				end;
			else
				count = count + result;
			end;
		end;
		
	else
		script_error("ERROR: number_close_to_position() called but supplied collection type " .. tostring(obj) .. " not recognised!");
	end;
	
	if return_bool then
		return false;
	end;
	
	return count;
end;


--- @function standing_number_close_to_position
--- @desc Alias of <code>number_close_to_position(obj, pos, range, two_d, <strong>true</strong>)</code>. Returns the number of non-routing units or sunits in a supplied collection within a given range of a given position.
--- @p object collection of units, Collection of units. Supported collection types are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p number range in m
--- @p boolean 2D only, Consider 2 dimensional distance only. If true, then <code>standing_number_close_to_position</code> disregards height differences in its distance calculation.
--- @r integer number within range of position
function standing_number_close_to_position(obj, pos, range, two_d)
	return number_close_to_position(obj, pos, range, two_d, true);
end;


--- @function is_close_to_position
--- @desc Returns true if any units or sunits in a supplied collection are within a given range of a given position, false otherwise.
--- @p object collection of units, Collection of units. Supported container types are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p number range in m
--- @p boolean 2D only, Consider 2 dimensional distance only. If true, then <code>is_close_to_position</code> disregards height differences in its distance calculation.
--- @p boolean non-routing only, Disregard routing or dead units from inclusion in the result.
--- @r integer number within range of position
function is_close_to_position(obj, pos, range, two_d, standing_only)
	return number_close_to_position(obj, pos, range, two_d, standing_only, true);
end;


--- @function standing_is_close_to_position
--- @desc Alias of <code>is_close_to_position(obj, pos, range, two_d, <strong>true</strong>)</code>. Returns true if any non-routing units or sunits in a supplied collection are within a given range of a given position, false otherwise.  The 2D only flag instructs the function to disregard height differences in its distance calculation.
--- @p object collection of units, Collection of units. Supported container types are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p number range in m
--- @p boolean 2D only, Consider 2 dimensional distance only. If true, then <code>standing_is_close_to_position</code> disregards height differences in its distance calculation.
--- @r integer number within range of position
function standing_is_close_to_position(obj, pos, range, two_d)
	return is_close_to_position(obj, pos, range, two_d, true, true);
end;


--- @function distance_between_forces
--- @desc Returns the closest distance between two collections of units. Supported collections are scriptunits, units, army, armies, alliance and table of unit, scriptunit or any of the above object types.
--- @desc The function will also return the objects in both collections that are closest to one another. These will be @script_unit objects, if available, otherwise they will be @battle_unit objects.
--- @p object first collection
--- @p object second collection
--- @p [opt=false] boolean non-routing only, Disregard routing or dead units from inclusion in the result.
--- @p return number Closest distance in m between forces
--- @p return obj Closest object from first supplied force, a @script_unit or a @battle_unit
--- @p return obj Closest object from second supplied force, a @script_unit or a @battle_unit
function distance_between_forces(a, b, standing_only, ignore_deployed_test)
	local closest_distance = 50000;
	local closest_obj_a = false;
	local closest_obj_b = false;

	if is_scriptunits(a) then
		for i = 1, a:count() do
			local current_obj = a:item(i);
			local current_distance, current_closest_obj_b = distance_between_forces_test(current_obj.unit, b, standing_only, ignore_deployed_test)
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_obj_a = current_obj;
				closest_obj_b = current_closest_obj_b;
			end;
		end;
		
	elseif is_scriptunit(a) then
		closest_distance, closest_obj_b = distance_between_forces_test(a.unit, b, standing_only, ignore_deployed_test);
		closest_obj_a = a;
			
	elseif is_table(a) then
		for i = 1, #a do
			local current_obj = a[i];
			local current_closest_obj_a = current_obj;
			local current_closest_obj_b = false;
			local current_distance = 50000;
			
			if is_unit(current_obj) then
				current_distance, current_closest_obj_b = distance_between_forces_test(current_obj, b, standing_only, ignore_deployed_test)
			elseif is_scriptunit(current_obj) then
				current_distance, current_closest_obj_b = distance_between_forces_test(current_obj.unit, b, standing_only, ignore_deployed_test)
			else
				current_distance, current_closest_obj_a, current_closest_obj_b = distance_between_forces(current_obj, b, standing_only, ignore_deployed_test);
			end;
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_obj_a = current_closest_obj_a;
				closest_obj_b = current_closest_obj_b;
			end;
		end;
	
	elseif is_units(a) then
		for i = 1, a:count() do
			local current_unit = a:item(i);
			local current_closest_obj_b = false;
			
			local current_distance, current_closest_obj_b = distance_between_forces_test(current_unit, b, standing_only, ignore_deployed_test)
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_obj_a = current_unit;
				closest_obj_b = current_closest_obj_b;
			end;
		end;
		
	elseif is_army(a) then
		closest_distance, closest_obj_a, closest_obj_b = distance_between_forces(a:units(), b, standing_only, ignore_deployed_test);
		
		for i = 1, a:num_reinforcement_units() do
			local r_units = a:get_reinforcement_units(i);
			
			if is_units(r_units) then
				local r_closest_distance, r_closest_obj_a, r_closest_obj_b = distance_between_forces(r_units, b, standing_only, ignore_deployed_test);
				
				if r_closest_distance < closest_distance then
					closest_distance = r_closest_distance;
					closest_obj_a = r_closest_obj_a;
					closest_obj_b = r_closest_obj_b;
				end;
			end;
		end;
	
	elseif is_armies(a) then
		for i = 1, a:count() do
			local current_distance, current_closest_obj_a, current_closest_obj_b = distance_between_forces(a:item(i):units(), b, standing_only, ignore_deployed_test);
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_obj_a = current_closest_obj_a;
				closest_obj_b = current_closest_obj_b;
			end;
		end;
	
	elseif is_alliance(a) then
		closest_distance, closest_obj_a, closest_obj_b = distance_between_forces(a:armies(), b, standing_only, ignore_deployed_test);
	else
		script_error("ERROR: distance_between_forces() called but first force " .. tostring(a) .. " is not a recognised unit container")
	end;
	
	return closest_distance, closest_obj_a, closest_obj_b;
end;


function distance_between_forces_test(unit, obj, standing_only, ignore_deployed_test) -- TODO: remove the ignore_deployed_test parameter once model side is investigated
	-- do the test if we're not only searching for routing units AND the unit is routing
	if (unit:is_deployed() or ignore_deployed_test) and (unit:is_valid_target() or unit:is_hidden() and not (standing_only and is_routing_or_dead(unit))) then
		local closest_unit, closest_distance, closest_sunit = get_closest_unit(obj, unit:position(), standing_only)
		
		if closest_sunit then
			return closest_distance, closest_sunit;
		elseif is_unit(closest_unit) then
			return closest_distance, closest_unit;
		end;
	end;
	
	return 50000;
end;


--- @function get_closest_unit
--- @desc Returns the closest unit in the supplied container to a supplied position, as well as its distance to that position. If the supplied collection is a scriptunits object, the closest scriptunit is also returned as the third return parameter (the scriptunit that contains the closest unit).
--- @p object unit collection, Unit collection. Supported types are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p [opt=false] boolean non-routing only, Disregard routing or dead units from inclusion in the result.
--- @p [opt=nil] function additional test, Additional test to perform on each candidate unit, which must be passed in order to count the subject unit towards the result. This must be supplied in the form of a function block which takes a unit as a parameter and returns a boolean result.
--- @p_long_desc If this function returns true when called, or a result that evaluates to true, then the subject unit can be considered for inclusion in the result.
--- @r unit closest unit
--- @r number distance of closest unit
--- @r scriptunit closest scriptunit if applicable, nil if not
function get_closest_unit(obj, pos, standing_only, test)
	if not is_vector(pos) then
		script_error("ERROR: get_closest_unit() called but supplied position " .. tostring(pos) .. " is not a vector!");
		
		return false;
	end;
		
	local standing_only = standing_only or false;
	local current_unit = nil;
	local current_distance = 0;
	local closest_unit = nil;
	local closest_distance = 50000;
	local closest_sunit = nil;
		
	if is_scriptunits(obj) then
		
		for i = 1, obj:count() do
			current_unit = obj:item(i).unit;
			current_distance = get_closest_unit_test(current_unit, pos, standing_only, test);
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_unit = current_unit;
				closest_sunit = obj:item(i);
			end;
		end;
		
	elseif is_scriptunit(obj) then
		current_distance = get_closest_unit_test(obj.unit, pos, standing_only, test);
		
		-- do this in case the condition check fails in the call above
		if current_distance < closest_distance then
			closest_distance = current_distance;
			closest_unit = obj.unit;
			closest_sunit = obj;
		end;
	
	elseif is_units(obj) then
		for i = 1, obj:count() do
			current_unit = obj:item(i);
			
			current_distance = get_closest_unit_test(current_unit, pos, standing_only, test);
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_unit = current_unit;
			end;
		end;
		
	elseif is_army(obj) then
		closest_unit, closest_distance = get_closest_unit(obj:units(), pos, standing_only, test);
		
		for i = 1, obj:num_reinforcement_units() do
			-- try reinforcing units
			local r_units = obj:get_reinforcement_units(i);
			
			if is_units(r_units) then
				current_unit, current_distance = get_closest_unit(r_units, pos, standing_only, test);
				
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_unit = current_unit;
				end;
			end;
		end;
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			current_unit, current_distance = get_closest_unit(obj:item(i), pos, standing_only, test);
			
			if current_distance < closest_distance then
				closest_distance = current_distance;
				closest_unit = current_unit;
			end;
		end;
	
	elseif is_alliance(obj) then
		return get_closest_unit(obj:armies(), pos, standing_only, test);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_obj = obj[i];
			
			if is_unit(current_obj) then	
				current_distance = get_closest_unit_test(current_obj, pos, standing_only, test);
			
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_unit = current_obj;
				end;
				
			elseif is_scriptunit(current_obj) then
				current_distance = get_closest_unit_test(current_obj.unit, pos, standing_only, test);
			
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_unit = current_obj.unit;
					closest_sunit = current_obj;
				end;
				
			else
				current_unit, current_distance = get_closest_unit(current_obj, pos, standing_only, test);
			
				if current_distance < closest_distance then
					closest_distance = current_distance;
					closest_unit = current_unit;
				end;
			end;
		end;
	
	else
		script_error("ERROR: get_closest_unit() called but supplied collection " .. tostring(obj) .. " is not supported!");
		
		return nil;
	end;
		
	return closest_unit, closest_distance, closest_sunit;
end;


--- @function get_closest_standing_unit
--- @desc Returns the closest unit in the supplied container to a supplied position, and its distance to that position. This function is an alias of <code>get_closest_unit(obj, pos, <strong>true</strong>, test)</code>.
--- @desc The third parameter allows the calling script to specify an additional test which must be passed in order to count the subject unit towards the result. This must be in the form of a function block which takes a unit as a parameter and returns a boolean result.
--- @p object unit collection, Unit collection. Supported containers are scriptunits, units, army, armies, alliance and table.
--- @p vector position
--- @p [opt=nil] function additional test, Additional test to perform on each candidate unit, which must be passed in order to count the subject unit towards the result. This must be supplied in the form of a function block which takes a unit as a parameter and returns a boolean result.
--- @p_long_desc If this function returns true when called, or a result that evaluates to true, then the subject unit can be considered for inclusion in the result.
--- @r unit closest unit
--- @r number distance of closest unit
--- @r scriptunit closest scriptunit if applicable, nil if not
function get_closest_standing_unit(obj, pos, test)
	return get_closest_unit(obj, pos, true, test);
end;


function get_closest_unit_test(unit, pos, standing_only, test)
	
	-- if we're only considering standing units and the unit is routing return massive distance, otherwise return actual distance
	if unit:is_valid_target() and not (standing_only and is_routing_or_dead(unit)) then
		if not is_function(test) or test(unit) then
			return unit:position():distance(pos);
		end;
	end;
	
	-- unit is not closer
	return 50000;
end;


--- @function get_average_altitude
--- @desc Returns the average altitude in m and the total number of units in the supplied collection.
--- @p object unit collection
--- @r number average altitude in m
--- @r integer number of units in collection
function get_average_altitude(obj)
	local sum_altitude = 0;
	local num_units = 0;
	local average_altitude = 0;

	if is_scriptunits(obj) then
		num_units = obj:count();
		for i = 1, num_units do
			local current_pos = obj:item(i).unit:position();
			sum_altitude = sum_altitude + current_pos:get_y();
		end;
		
	elseif is_units(obj) then
		num_units = obj:count();
		for i = 1, num_units do
			local current_pos = obj:item(i):position();
			sum_altitude = sum_altitude + current_pos:get_y();
		end;
		
	elseif is_army(obj) then	
		average_altitude, num_units, sum_altitude = get_average_altitude(obj:units());
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			local army_average, army_count, army_sum = get_average_altitude(obj:units());
			num_units = num_units + army_count;
			sum_altitude = sum_altitude + army_sum;
		end;
		
	elseif is_alliance(obj) then
		average_altitude, num_units, sum_altitude = get_average_altitude(obj:armies());
		
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_element = obj[i];
			
			if is_unit(current_element) then
				num_units = num_units + 1;
				local element_pos = current_element:Position();
				sum_altitude = sum_altitude + element_pos:get_y();
			
			elseif is_scriptunit(current_element) then
				num_units = num_units + 1;
				local element_pos = current_element.unit:Position();
				sum_altitude = sum_altitude + element_pos:get_y();
			
			else			
				local element_average, element_count, element_sum = get_average_altitude(obj[i]);
				num_units = num_units + element_count;
				sum_altitude = sum_altitude + element_sum;
			end;
		end;
	else
		script_error("ERROR: get_average_altitude() called did not recognise supplied collection [" .. tostring(obj) .. "]");
	end;
	
	-- avoid divide-by-zero
	if num_units == 0 then
		return 0, 0, 0;
	end;
	
	local average_altitude = sum_altitude / num_units;
	
	return average_altitude, num_units, sum_altitude;
end;











----------------------------------------------------------------------------
--- @section Miscellaneous Unit Collection Tests
----------------------------------------------------------------------------


--- @function num_units_in_collection
--- @desc Returns the number of units in the supplied collection.
--- @p object collection to test, Collection to test. Supported collection types are units, scriptunits, army, armies, alliance and table.
--- @r number of units in collection
function num_units_in_collection(obj)	
	if is_units(obj) or is_scriptunits(obj) then
		return obj:count();
			
	elseif is_army(obj) then
		return num_units_in_collection(obj:units());

	elseif is_armies(obj) then
		local count = 0;
		for i = 1, obj:count() do
			count = count + num_units_in_collection(obj:item(i));
		end;
		return count;
	
	elseif is_alliance(obj) then
		return num_units_in_collection(obj:armies());
		
	elseif is_table(obj) then
		local count = 0;
		for i = 1, #obj do
			count = count + num_units_in_collection(obj[i]);
		end;
		return count;
	end;
	
	script_error("ERROR: num_units_in_collection() called but didn't recognise supplied parameter [" .. tostring(obj) .. "], returning 0");
	return 0;
end;


--- @function contains_unit
--- @desc Returns true is the supplied container contains the supplied unit, otherwise returns false.
--- @p object collection to test, Collection to test. Supported containers are scriptunits, units, army, armies, alliance and table.
--- @p unit subject unit
--- @r boolean collection contains unit
function contains_unit(obj, unit)
	if is_scriptunits(obj) then
		if not is_unit(unit) then
			script_error("ERROR: contains_unit() called but unit specified [" .. tostring(unit) .. "] is not a unit");
			return false;
		end;
		
		for i = 1, obj:count() do
			if obj:item(i).unit == unit then
				return true;
			end;
		end;
		
		return false;
	
	elseif is_units(obj) then
		if not is_unit(unit) then
			script_error("ERROR: contains_unit() called but unit specified [" .. tostring(unit) .. "] is not a unit");
			return false;
		end;
	
		for i = 1, obj:count() do
			if obj:item(i) == unit then
				return true;
			end;
		end;
		
		return false;
		
	elseif is_army(obj) then		
		if contains_unit(obj:units(), unit) then
			return true;
		end;
		
		-- check all reinforcement units collections
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
		
			if is_units(r_units) and contains_unit(r_units, unit) then
				return true;
			end;		
		end;
		
		return false;
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if contains_unit(obj:item(i), unit) then
				return true;
			end;
		end;
	
		return false;
		
	elseif is_alliance(obj) then
		return contains_unit(obj:armies(), unit);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			if contains_unit(obj[i]) then
				return true;
			end;
		end;
		
		return false;
	else
		script_error("ERROR: contains_unit() called but first parameter " .. tostring(obj) .. " was not recognised!");
	end;
	
	return false;
end;


--- @function num_units_passing_test
--- @desc Returns the number of units in the supplied collection that pass a supplied test, as well as the total number of units. The test must be supplied in the form of a function that takes a unit parameter and returns a boolean result.
--- @p object collection to test, Collection to test. Supported collection object types are units, scriptunits, army, armies, alliance and table.
--- @p function test function
--- @r integer number of passing units
--- @r integer total number of units
function num_units_passing_test(obj, test)
	local total_count = 0;
	local pass_count = 0;

	if is_scriptunits(obj) then
		for i = 1, obj:count() do
			total_count = total_count + 1;
			if test(obj:item(i).unit) then
				pass_count = pass_count + 1;
			end;
		end;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			total_count = total_count + 1;
			if test(obj:item(i)) then
				pass_count = pass_count + 1;
			end;
		end;
		
	elseif is_army(obj) then
		pass_count, total_count = num_units_passing_test(obj:units(), test);
	
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			local add_pass_count, add_total_count = num_units_passing_test(obj:item(i), test);
			pass_count = pass_count + add_pass_count;
			total_count = total_count + add_total_count;
		end;
		
	elseif is_alliance(obj) then
		pass_count, total_count = num_units_passing_test(obj:armies(), test);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_element = obj[i];
			
			if is_unit(current_element) then
				total_count = total_count + 1;
				
				if test(current_element) then
					pass_count = pass_count + 1;
				end;
			
			elseif is_scriptunit(current_element) then
				
				total_count = total_count + 1;
				
				if test(current_element.unit) then
					pass_count = pass_count + 1;
				end;
			
			else
				local add_pass_count, add_total_count = num_units_passing_test(current_element, test);
				pass_count = pass_count + add_pass_count;
				total_count = total_count + add_total_count;
			end;
		end;
	else
		script_error("ERROR: num_units_passing_test() called did not recognise supplied collection [" .. tostring(obj) .. "]");
	end;
	
	return pass_count, total_count;
end;


--- @function get_all_matching_units
--- @desc Returns a table containing all units in the supplied collection that pass a supplied test.
--- @p object collection to test, Collection to test. Supported collection object types are units, scriptunits, army, armies, alliance and table.
--- @p function test function, Test function. The test must be supplied in the form of a function that takes a unit parameter and returns a boolean result. If the boolean result is true, or evaluates to true, the unit is added to the result.
--- @r table table containing passing units
function get_all_matching_units(obj, test, starting_table)
	local matching_units = starting_table or {};

	if is_scriptunits(obj) then
		for i = 1, obj:count() do
			local current_unit = obj:item(i).unit;
			if test(current_unit) then
				table.insert(matching_units, current_unit);
			end;
		end;
		
	elseif is_units(obj) then
		for i = 1, obj:count() do
			local current_unit = obj:item(i);
			if test(current_unit) then
				table.insert(matching_units, current_unit);
			end;
		end;
		
	elseif is_army(obj) then
		get_all_matching_units(obj:units(), test, matching_units);
		
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			get_all_matching_units(obj:item(i), test, matching_units);
		end;
		
	elseif is_alliance(obj) then
		get_all_matching_units(obj:armies(), test, matching_units);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			local current_element = obj[i];
		
			if is_unit(current_element) then
				if test(current_element) then
					table.insert(matching_units, current_element);
				end;
			
			elseif is_scriptunit(current_element) then
				if test(current_element.unit) then
					table.insert(matching_units, current_element.unit);
				end;
			
			else
				get_all_matching_units(obj[i], test, matching_units);
			end;
		end;
	else
		script_error("ERROR: get_all_matching_units() called did not recognise supplied collection [" .. tostring(obj) .. "]");
	end;
		
	return matching_units;
end;


--- @function number_alive
--- @desc Returns the number of soldiers in a collection that are alive, as well as the initial number of soldiers that collection started with.
--- @p object collection to test, Collection to test. Supported collections are alliance, armies, army, units, unit, scriptunit, scriptunits and table.
--- @r integer number of soldiers currently alive
--- @r integer initial number of soldiers
function number_alive(obj)
	if is_unit(obj) then
		return obj:number_of_men_alive(), obj:initial_number_of_men();
	elseif is_scriptunit(obj) then
		return number_alive(obj.unit);
	elseif is_alliance(obj) then
		return number_alive(obj:armies());
	elseif is_army(obj) then
		local total_men_alive, total_men = number_alive(obj:units());
		
		for i = 1, obj:num_reinforcement_units() do
			local r_units = obj:get_reinforcement_units(i);
			
			local total_r_men_alive = 0;
			local total_r_men = 0;
			
			if is_units(r_units) then
				total_r_men_alive, total_r_men = number_alive(r_units);
			end;
			
			total_men_alive = total_men_alive + total_r_men_alive;
			total_men = total_men + total_r_men;
		end;
		
		return total_men_alive, total_men;
	end;
	
	local total_men = 0;
	local total_men_alive = 0;
	
	if is_scriptunits(obj) then
		for i = 1, obj:count() do
			local additional_men_alive, additional_men = number_alive(obj:item(i).unit);
			
			total_men_alive = total_men_alive + additional_men_alive;
			total_men = total_men + additional_men;
		end;
	
	elseif is_armies(obj) or is_units(obj) then
		for i = 1, obj:count() do
			local additional_men_alive, additional_men = number_alive(obj:item(i));
			
			total_men_alive = total_men_alive + additional_men_alive;
			total_men = total_men + additional_men;
		end;
		
	elseif is_table(obj) then
		for i = 1, #obj do
			local additional_men_alive, additional_men = number_alive(obj[i]);
			
			total_men_alive = total_men_alive + additional_men_alive;
			total_men = total_men + additional_men;
		end;
		
	else
		script_error("number_alive ERROR: didn't recognise object [" .. tostring(obj) .. "]");
		return 0, 1;		-- 1 to prevent divide by zero
	end;
	
	return total_men_alive, total_men;
end;


--- @function is_visible
--- @desc Returns true if any part of the supplied collection object is visible to the supplied alliance by the rules of the visibility system.
--- @p object collection to test, Collection to test.
--- @p alliance alliance
--- @r boolean visibility result
function is_visible(obj, alliance)
	
	if is_unit(obj) then
		return obj:is_visible_to_alliance(alliance);
		
	elseif is_scriptunit(obj) then
		return obj.unit:is_visible_to_alliance(alliance);
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if is_visible(obj:item(i).unit, alliance) then
				return true;
			end;
		end;

	elseif is_units(obj) or is_armies(obj) then
		for i = 1, obj:count() do
			if is_visible(obj:item(i), alliance) then
				return true;
			end;
		end;

	elseif is_army(obj) then
		return is_visible(obj:units(), alliance);
	
	elseif is_armies(obj) then
		for i = 1, obj:count() do
			if is_visible(obj:item(i):units(), alliance) then
				return true;
			end;
		end;

	elseif is_alliance(obj) then
		return is_visible(obj:armies(), alliance);
	
	elseif is_table(obj) then
		for i = 1, #obj do
			if is_visible(obj[i], alliance) then
				return true;
			end;
		end;
	else
		script_error("WARNING: is_visible() called but object [" .. tostring(obj) .. "] supplied not recognised");
	end;
	
	return false;
end;


--- @function has_deployed
--- @desc Returns true if all units in the supplied collection object are valid targets and are not routing or dead, and are therefore considered to be deployed. Supported objects are unit, scriptunit, units, scriptunits, army, armies and table.
--- @p object collection to test, Collection to test. Supported collection objects are unit, units, army, armies, scriptunit, scriptunits and table.
--- @r boolean are all deployed
function has_deployed(obj)
	if is_unit(obj) then
		return obj:is_valid_target() or is_routing_or_dead(obj);
		
	elseif is_scriptunit(obj) then
		return obj.unit:is_valid_target() or is_routing_or_dead(obj);
		
	elseif is_scriptunits(obj) then
		for i = 1, obj:count() do
			if not has_deployed(obj:item(i).unit) then
				return false;
			end;
		end;
		
		return true;
	elseif is_units(obj) or is_armies(obj) then
		for i = 1, obj:count() do
			if not has_deployed(obj:item(i)) then
				return false;
			end;
		end;
		
		return true;
	elseif is_army(obj) then
		return has_deployed(obj:units());
	elseif is_table(obj) then
		for i = 1, #obj do
			if not has_deployed(obj[i]) then
				return false;
			end;
		end;
		
		return true;
	else
		script_error("WARNING: has_deployed() called but object [" .. tostring(obj) .. "] supplied not recognised");
	end;
	
	return false;
end;










--- @section Ground Types


--- @function ground_type_proportion_along_line
--- @desc Returns the percentage of points sampled along a supplied line that match the supplied ground type. The line is specified by start and end vectors.
--- @p @battle_vector start position, Starting position of line.
--- @p @battle_vector end position, End position of line.
--- @p @string ground type, Ground type key, from the <code>ground_types</code> database table.
--- @p [opt=10] @number samples, Number of samples to take. A higher number of samples will give a more accurate result but will be slower.
--- @r @number percentage of ground type
function ground_type_proportion_along_line(pos_a, pos_b, ground_type, samples)

	if samples then
		if samples < 2 then
			samples = 2;
		end;
	else
		samples = 10;
	end;

	local interval = pos_a:distance_xz(pos_b) / (samples - 1);
	local num_occurrences = 0;

	for i = 0, samples - 1 do
		local current_pos = position_along_line(pos_a, pos_b, i * interval, true);

		if bm:ground_type(current_pos) == ground_type then
			num_occurrences = num_occurrences + 1;
		end;
	end;
	
	return 100 * num_occurrences / samples;
end;


--- @function ground_type_proportion_in_bounding_box
--- @desc Returns the percentage of points sampled in a bounding box that match the supplied ground type. The oriented-bounding box is specified by a centre position, a bearing in radians, a width and a depth. The number of width and depth samples may optionally be specified, the total number of samples being these numbers multiplied together.
--- @desc Be aware of the performance implications of using this function.
--- @p @battle_vector centre position, Centre position of the oriented bounding box.
--- @p @number bearing, Bearing of bounding box in radians.
--- @p @number width, Width of bounding box in metres.
--- @p @number depth, Depth of bounding box in metres.
--- @p [opt=10] @number width samples, Number of sample lines to take across width of bounding box.
--- @p [opt=10] @number depth samples, Number of samples to take for each front-to-back sample line taken.
--- @r @number percentage of ground type
function ground_type_proportion_in_bounding_box(pos_centre, bearing, width, depth, ground_type, width_samples, depth_samples)

	if width_samples then
		if width_samples < 2 then
			width_samples = 2;
		end;
	else
		width_samples = 10;
	end;

	if depth_samples then
		if depth_samples < 2 then
			depth_samples = 2;
		end;
	else
		depth_samples = 10;
	end;

	local width_interval = width / (width_samples - 1);

	-- calculate the back-centre and front-centre
	local pos_centre_back = v_offset_by_bearing(pos_centre, bearing, 0 - depth / 2);
	local pos_centre_front = v_offset_by_bearing(pos_centre, bearing, depth / 2);

	-- calculate normal bearing
	local perpendicular_bearing = bearing + (math.pi / 2);

	local cumulative_proportion = 0;

	for i = 0, width_samples - 1 do
		local width_offset = i * width_interval - (width / 2);

		-- calculate the position of each end of the line
		local pos_depth_line_back = v_offset_by_bearing(pos_centre_back, perpendicular_bearing, width_offset);
		local pos_depth_line_front = v_offset_by_bearing(pos_centre_front, perpendicular_bearing, width_offset);

		cumulative_proportion = cumulative_proportion + ground_type_proportion_along_line(pos_depth_line_back, pos_depth_line_front, ground_type, depth_samples);
	end;

	return cumulative_proportion / depth_samples;
end;






















--[[
	THESE ARE ALL CURRENTLY UNSAFE TO USE

---------------------------------------------------------------
--
-- print_buildings
--
-- Debug output of all building positions
--
---------------------------------------------------------------

function print_buildings(start_index, end_index)
	if not start_index or not is_number(start_index) or start_index < 1 then
		start_index = 1;
	end;
	
	if not end_index or not is_number(end_index) or end_index > battle:buildings():count() then
		end_index = battle:buildings():count();
	end;

	for i = start_index, end_index do
		bm:out("Building " .. i .. " is at position " .. v_to_s(battle:buildings():item(i):position()));
	end;
end;



---------------------------------------------------------------
--
-- print_buildings_near
--
-- Debug output of all buildings near a position
--
---------------------------------------------------------------

function print_buildings_near(x, y, range)
	if not x or not is_number(x) or x < -1000 or x > 1000 then
		script_error("ERROR: print_buildings_near(x, y) called but first parameter " .. tostring(x) .. " is not a number!");
		
		return false;
	end;
	
	if not y or not is_number(y) or y < -1000 or y > 1000 then
		script_error("ERROR: print_buildings_near(x, y) called but second parameter " .. tostring(y) .. " is not a number!");
		
		return false;
	end;
	
	if not is_number(range) or range <= 0 then
		range = 50;
	end;
	
	local pos = v(x, y);
	
	bm:out("Printing list of buildings within " .. range .. "m of " .. v_to_s(pos));
	bm:out("*****");
	
	for i = 1, bm:buildings():count() do
		if pos:distance_xz(bm:buildings():item(i):position()) < range then
			bm:out("Building " .. i .. " is at position " .. v_to_s(bm:buildings():item(i):position()));
		end;
	end;
	
	bm:out("*****");
end;



---------------------------------------------------------------
--
-- get_building_near
--
-- Returns the nearest building to a position
--
---------------------------------------------------------------

function get_building_near(x, y)
	if not x or not is_number(x) or x < -1000 or x > 1000 then
		bm:out("get_building_near :: x co-ordinate is not valid (supplied value is (" .. tostring(x) .. ")");
	
		return false;
	end;
	
	if not y or not is_number(y) or y < -1000 or y > 1000 then
		bm:out("get_building_near :: y co-ordinate is not valid (supplied value is (" .. tostring(y) .. ")");
	
		return false;
	end;
	
	local pos = v(x, y);
	local current_distance = 0;
	local closest_distance = 50000;
	local closest_index = false;
	
	for i = 1, bm:buildings():count() do
		current_distance = pos:distance_xz(bm:buildings():item(i):central_position());
		
		if current_distance < closest_distance then
			closest_distance = current_distance;
			closest_index = i;
		end;
	end;
	
	if not closest_index then
		bm:out("get_building_near :: did not find any buildings on the map!");
		
		return nil;
	end;
	
	bm:out("get_building_near :: found building #" .. closest_index .. " at " .. v_to_s(bm:buildings():item(closest_index):position()) .. "(centre position is " .. v_to_s(bm:buildings():item(closest_index):central_position()) .. " which is " .. closest_distance .. " from " .. v_to_s(pos) .. ")");
	
	local debugdrawing = bm:debug_drawing();
	debugdrawing:draw_white_circle_on_terrain(bm:buildings():item(closest_index):central_position(), 5, 500);
	
	return bm:buildings():item(closest_index);
end;

]]