



----------------------------------------------------------------------------
----------------------------------------------------------------------------
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c custom_context Custom Context
--- @page core
--- @desc A custom context is created when the core object is compelled to trigger an event with @core:trigger_event or @core:trigger_custom_event. Data items supplied to @core:trigger_event or @core:trigger_custom_event are added to the custom context, which is then sent to any script listening for the event being triggered.
--- @desc The receiving script should then be able to interrogate the custom context it receives as if it were a context issued from the game code.
--- @desc No script outside of <code>trigger_event</code> should need to create a custom context, but it's documented here in order to list the data types it supports.
----------------------------------------------------------------------------
----------------------------------------------------------------------------

custom_context = {};


set_class_custom_type_and_tostring(custom_context, TYPE_CUSTOM_CONTEXT);



--- @function new
--- @desc Creates a custom context object.
--- @r custom_context
function custom_context:new()
	local cc = {};
	
	set_object_class(cc, self);
	
	return cc;
end;


--- @function add_data
--- @desc Adds data to the custom context object. Supported data types:
--- @desc <ul><li>boolean: will be accessible to the receiving script as <code>context.bool</code></li>
--- @desc <ul><li>string: will be accessible to the receiving script as <code>context.string</code>.</li>
--- @desc <ul><li>number: will be accessible to the receiving script as <code>context.number</code>.</li>
--- @desc <li>table: will be accessible to the receiving script using @custom_context:table_data.</li>
--- @desc <li>region: will be accessible to the receiving script using @custom_context:region.</li>
--- @desc <li>character: will be accessible to the receiving script using @custom_context:character. A second character, if added, is accessible to the receiving script using @custom_context:target_character.</li>
--- @desc <li>faction: will be accessible to the receiving script using @custom_context:faction.</li>
--- @desc <li>component: will be accessible to the receiving script using @custom_context:component.</li>
--- @desc <li>military_force: will be accessible to the receiving script using @custom_context:military_force.</li>
--- @desc <li>pending_battle: will be accessible to the receiving script using @custom_context:pending_battle.</li>
--- @desc <li>garrison_residence: will be accessible to the receiving script using @custom_context:garrison_residence.</li>
--- @desc <li>building: will be accessible to the receiving script using @custom_context:building.</li>
--- @desc <li>vector: will be accessible to the receiving script using @custom_context:vector.</li></ul>
--- @desc A limitation of the implementation is that only one object of each type may be placed on the custom context (except for characters, currently).
--- @p object context data, Data object to add
function custom_context:add_data(obj)
	if is_boolean(obj) then
		self.bool = obj;
	elseif is_string(obj) then
		self.string = obj;
	elseif is_number(obj) then
		self.number = obj;
	elseif is_region(obj) then
		self.region_data = obj;
	elseif is_character(obj) then
		-- not such a nice construct - the first character will be accessible at "character", the second at "target_character"
		if self.character_data then
			self.target_character_data = obj;
		else
			self.character_data = obj;
		end;
	elseif is_faction(obj) then
		self.faction_data = obj;
	elseif is_component(obj) then
		self.component_data = obj;
	elseif is_militaryforce(obj) then
		self.military_force_data = obj;
	elseif is_pendingbattle(obj) then
		self.pending_battle_data = obj;
	elseif is_garrisonresidence(obj) then
		self.garrison_residence_data = obj;
	elseif is_building(obj) then
		self.building_data = obj;
	elseif is_garrisonresidence(obj) then
		self.garrison_residence_data = obj;
	elseif is_building(obj) then
		self.building_data = obj;
	elseif is_vector(obj) then
		self.vector_data = obj;
	elseif is_table(obj) then			-- keep this check last, as script objects are tables and will erroneously return true here
		self.stored_table = obj;
	else
		script_error("ERROR: adding data to custom context but couldn't recognise data [" .. tostring(obj) .. "] of type [" .. type(obj) .. "]");
	end;	
end;


--- @function add_data_with_key
--- @desc Adds data to the custom context which will be made accessible at the supplied function name. The function name is supplied by string key.
--- @p value value, Value to add to custom context. Any value may be supplied.
--- @p @string function name, Name of function at which the value may be retrieved, if called on the custom context.
function custom_context:add_data_with_key(value, function_name)
	if not is_string(function_name) then
		script_error("ERROR: add_data_with_key() called but supplied function name [" .. tostring(function_name) .. "] is not a string");
		return false;
	end;

	-- assemble a function on the specific custom context object that returns the supplied value
	self[function_name] = function()
		return value;
	end;
end;


--- @function table_data
--- @desc Called by the receiving script to retrieve the table placed on the custom context, were one specified by the script that created it.
--- @r table of user defined values
function custom_context:table_data()
	return self.stored_table;
end;


--- @function region
--- @desc Called by the receiving script to retrieve the region object placed on the custom context, were one specified by the script that created it.
--- @r region region object
function custom_context:region()
	return self.region_data;
end;


--- @function character
--- @desc Called by the receiving script to retrieve the character object placed on the custom context, were one specified by the script that created it.
--- @r character character object
function custom_context:character()
	return self.character_data;
end;


--- @function target_character
--- @desc Called by the receiving script to retrieve the target character object placed on the custom context, were one specified by the script that created it. The target character is the second character added to the context.
--- @r character target character object
function custom_context:target_character()
	return self.target_character_data;
end;


--- @function faction
--- @desc Called by the receiving script to retrieve the faction object placed on the custom context, were one specified by the script that created it.
--- @r faction faction object
function custom_context:faction()
	return self.faction_data;
end;


--- @function component
--- @desc Called by the receiving script to retrieve the component object placed on the custom context, were one specified by the script that created it.
--- @r component component object
function custom_context:component()
	return self.component_data;
end;


--- @function military_force
--- @desc Called by the receiving script to retrieve the military force object placed on the custom context, were one specified by the script that created it.
--- @r military_force military force object
function custom_context:military_force()
	return self.military_force_data;
end;


--- @function pending_battle
--- @desc Called by the receiving script to retrieve the pending battle object placed on the custom context, were one specified by the script that created it.
--- @r pending_battle pending battle object
function custom_context:pending_battle()
	return self.pending_battle_data;
end;


--- @function garrison_residence
--- @desc Called by the receiving script to retrieve the garrison residence object placed on the custom context, were one specified by the script that created it.
--- @r garrison_residence garrison residence object
function custom_context:garrison_residence()
	return self.garrison_residence_data;
end;


--- @function building
--- @desc Called by the receiving script to retrieve the building object placed on the custom context, were one specified by the script that created it.
--- @r building building object
function custom_context:building()
	return self.building_data;
end;


--- @function vector
--- @desc Called by the receiving script to retrieve the vector object placed on the custom context, were one specified by the script that created it.
--- @return vector vector object
function custom_context:vector()
	return self.vector_data;
end;