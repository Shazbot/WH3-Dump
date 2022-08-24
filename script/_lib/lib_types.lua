


--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend


TYPE_TIMER_MANAGER = "timer_manager";
TYPE_CORE = "core";
TYPE_BATTLE_MANAGER = "battle_manager";
TYPE_CAMPAIGN_MANAGER = "campaign_manager";
TYPE_INVASION_MANAGER = "invasion_manager";
TYPE_RANDOM_ARMY_MANAGER = "random_army_manager";
TYPE_CUTSCENE_MANAGER = "cutscene_manager";
TYPE_CONVEX_AREA = "convex_area";
TYPE_SCRIPT_UNIT = "script_unit";
TYPE_SCRIPT_UNITS = "script_units";
TYPE_WAYPOINT = "waypoint";
TYPE_SCRIPT_AI_PLANNER = "script_ai_planner";
TYPE_UI_OVERRIDE = "ui_override";
TYPE_FACTION_START = "faction_start";
TYPE_FACTION_INTRO_DATA = "faction_intro_data";
TYPE_CAMPAIGN_CUTSCENE = "campaign_cutscene";
TYPE_SCRIPT_MESSAGER = "script_messager";
TYPE_CUSTOM_CONTEXT = "custom_context";
TYPE_PATROL_MANAGER = "patrol_manager";
TYPE_GENERATED_BATTLE = "generated_battle";
TYPE_GENERATED_ARMY = "generated_army";
TYPE_GENERATED_CUTSCENE = "generated_cutscene";
TYPE_CAMPAIGN_UI_MANAGER = "campaign_ui_manager";
TYPE_BATTLE_UI_MANAGER = "battle_ui_manager";
TYPE_OBJECTIVES_MANAGER = "objectives_manager";
TYPE_INFOTEXT_MANAGER = "infotext_manager";
TYPE_MISSION_MANAGER = "mission_manager";
TYPE_CAMPAIGN_VECTOR = "campaign_vector";
TYPE_CHAPTER_MISSION = "chapter_mission";
TYPE_INTERVENTION = "intervention";
TYPE_INTERVENTION_MANAGER = "intervention_manager";
TYPE_LINK_PARSER = "link_parser";
TYPE_HELP_PAGE_MANAGER = "help_page_manager";
TYPE_HELP_PAGE = "help_page";
TYPE_TOOLTIP_LISTENER = "tooltip_listener";
TYPE_CONTEXT_VISIBILITY_MONITOR = "context_visibility_monitor";
TYPE_TOOLTIP_PATCHER = "tooltip_patcher";
TYPE_ADVICE_MANAGER = "advice_manager";
TYPE_ADVICE_MONITOR = "advice_monitor";
TYPE_WEIGHTED_LIST = "weighted_list";
TYPE_UNIQUE_TABLE = "unique_table";
TYPE_TEXT_POINTER = "text_pointer";
TYPE_ACTIVE_POINTER = "active_pointer";
TYPE_SCRIPTED_TOUR = "scripted_tour";
TYPE_NAVIGABLE_TOUR = "navigable_tour";
TYPE_NAVIGABLE_TOUR_SECTION = "navigable_tour_section";
TYPE_MOVIE_OVERLAY = "movie_overlay"
TYPE_WINDOWED_MOVIE_PLAYER = "windowed_movie_player";
TYPE_INTRO_CAMPAIGN_CAMERA_MARKER = "intro_campaign_camera_marker";
TYPE_INTRO_CAMPAIGN_CAMERA_POSITIONS_ADVICE = "intro_campaign_camera_positions_advice";
TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE = "intro_campaign_select_and_attack_advice";
TYPE_INTRO_CAMPAIGN_SELECT_ADVICE = "intro_campaign_select_advice";
TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE = "intro_campaign_movement_advice";
TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE = "intro_campaign_recruitment_advice";
TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE = "intro_campaign_select_settlement_advice";
TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE = "intro_campaign_panel_highlight_advice";
TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE = "intro_campaign_building_construction_advice";
TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE = "intro_campaign_technology_advice";
TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE = "intro_campaign_end_turn_advice";
TYPE_CAMPAIGN_NARRATIVE_EVENT = "campaign_narrative_event";
TYPE_CAMPAIGN_NARRATIVE_QUERY = "campaign_narrative_query";
TYPE_CAMPAIGN_NARRATIVE_TRIGGER = "campaign_narrative_trigger";
TYPE_INFO_OVERLAY = "info_overlay";
TYPE_ATTACK_LANE_MANAGER = "attack_lane_manager";
TYPE_TOPIC_LEADER = "topic_leader";


















----------------------------------------------------------------------------
---	@section Object-Orientation, Inheritance, and Types
----------------------------------------------------------------------------


--- @function is_custom_type
--- @desc Returns true if the supplied value is of the supplied custom type. This is not intended to be directly called by client scripts, who should instead call one of the is_<type> functions listed elsewhere.
--- @p @table object
--- @p value custom type
--- @r @boolean is custom type
function is_custom_type(value, custom_type)
	return type(value) == "table" and getmetatable(value) and getmetatable(value).__custom_type == custom_type;
end;


--- @function get_custom_type
--- @desc Returns the custom type value of the supplied value. If it has no custom type then <code>nil</code> is returned.
--- @p @table object
--- @r value custom type, or @nil
function get_custom_type(value)
	if type(value) == "table" and getmetatable(value) then
		return getmetatable(value).__custom_type;
	end;
end;


--- @function set_class_custom_type
--- @desc Sets a supplied class table to the supplied type string by setting its <code>__custom_type</code> value. Once this is set, other object tables that are later set to derive from this class with @global:set_object_class will report this custom type when passed to @global:get_custom_type or @global:is_custom_type.
--- @p @table class table
--- @p @string custom type
--- @example TYPE_RABBIT = "rabbit"
--- @example 
--- @example -- class definition
--- @example rabbit = {}
--- @example set_class_custom_type(rabbit, TYPE_RABBIT)
--- @example 
--- @example -- object definition
--- @example thumper = {}
--- @example set_object_class(thumper, rabbit)
--- @example 
--- @example out("thumper custom type is " .. get_custom_type(thumper)
--- @result thumper custom type is rabbit
function set_class_custom_type(class, class_type)

	if not is_table(class) then
		script_error("ERROR: set_class_custom_type() called but supplied class [" .. tostring(class) .. "] is not a table");
		return false;
	end;

	if not is_string(class_type) then
		script_error("ERROR: set_class_custom_type() called but supplied custom type [" .. tostring(class_type) .. "] is not a string");
		return false;
	end;

	class.__custom_type = class_type;
end;


--- @function set_class_tostring
--- @desc Sets the tostring value of a supplied class table to the specified value by setting its <code>__tostring</code> value. Once this is set, other object tables that are later set to derive from this class with @global:set_object_class will return this value when passed to <code>tostring()</code>.
--- @desc The tostring specifier may be supplied as a @string or a @function. If supplied as a function, that function will be called when the <code>tostring()</code> function is called with an object derived from the supplied class. The object will be supplied as a single argument to the tostring specifier function, which allows the tostring() value to be assembled at runtime and include elements such as the objects name, co-ordinates or other realtime information. The specifier function should return a string.
--- @desc The default behaviour is for the generated string to be cached in the object table, at the <code>__cached_tostring</code> field. Further calls to <code>tostring()</code> will then return the cached string rather than regenerating it each time. If this is undesirable - for example if the generated string might change as the object changes state - then the <code>do_not_cache</code> flag may be set on this function.
--- @desc The flag to not append the memory address may be set if the memory address of the table is not wanted on the end of the returned tostring value. The default behaviour is to append the memory address.
--- @p @table class table
--- @p @string custom type
--- @new_example Setting a function tostring specifier
--- @example TYPE_CAT = "cat"
--- @example 
--- @example -- class definition
--- @example cat = {}
--- @example set_class_tostring(cat, function(cat_obj) return TYPE_CAT .. "_" .. cat_obj.name end)
--- @example 
--- @example -- object definition
--- @example cat_freddy = {name = "freddy"}
--- @example set_object_class(cat_freddy, cat)
--- @example out(tostring(cat_freddy))
--- @result cat_freddy: 000001C2B9D4E730
function set_class_tostring(class, tostring_specifier, do_not_cache, do_not_append_mem_address)

	if not is_table(class) then
		script_error("ERROR: set_class_tostring() called but supplied class [" .. tostring(class) .. "] is not a table");
		return false;
	end;

	if not is_function(tostring_specifier) and not is_string(tostring_specifier) then
		script_error("ERROR: set_class_tostring() called but supplied tostring specifier [" .. tostring(tostring_specifier) .. "] is not a string or a function");
		return false;
	end;

	-- If the type is a string and we don't have to add anything to it then we can directly set that as the __tostring field and return
	if is_string(tostring_specifier) and do_not_append_mem_address then
		class.__tostring = tostring_specifier;
		return;
	end;

	local internal_str_generator;

	if is_string(tostring_specifier) then
		-- The type is a static string so we internally generate it and concat the memory address of the object at runtime
		internal_str_generator = function(object)
			return tostring_specifier .. table.mem_address(object, true);
		end;

	elseif do_not_append_mem_address then
		-- The type is a function and we don't have to modify its output
		internal_str_generator = tostring_specifier;

	else
		-- The type is a function and we have to add the memory address of the object at runtime (this is the default behaviour)
		internal_str_generator = function(object)
			return tostring_specifier(object) .. table.mem_address(object, true);
		end;
	end;

	if do_not_cache then
		-- We don't have to cache so just return what we generated internally
		class.__tostring = internal_str_generator;
	else
		-- When the tostring is hit first check the cached location, and if that fails then generate internally, store in the cached location and return that
		class.__tostring = function(object)
			if rawget(object, "__cached_tostring") then
				return object.__cached_tostring;
			else
				local str = internal_str_generator(object);

				object.__cached_tostring = str;

				return str;
			end;
		end;
	end;
end;


--- @function set_class_custom_type_and_tostring
--- @desc Sets the custom type and tostring value on the supplied class table to the supplied string value. This function calls @global:set_class_custom_type and @global:set_class_tostring to do this.
--- @p @table class table
--- @p @string custom type value
function set_class_custom_type_and_tostring(class, class_type)
	set_class_custom_type(class, class_type);
	set_class_tostring(class, class_type);
end;


local function set_object_class_impl(force_unique_mt, object, ...)

	-- Check the object datatype
	if not is_table(object) then
		script_error("ERROR: attempting to set class of object but supplied value [" .. tostring(object) .. "] is not a table");
		return false;
	end;

	-- Check that we have at least one parent
	if arg.n == 0 then
		script_error("ERROR: attempting to set class of object but no class object(s) supplied");
		return false;
	end;

	-- Check any other parent datatypes. Each must be a table or userdata object.
	for i = 1, arg.n do
		local current_parent = arg[i];
		if not is_table(current_parent) and not is_userdata(current_parent) then
			script_error("ERROR: attempting to set class of object but element [" .. i .. "] of parent object chain, with value [" .. tostring(current_parent) .. "], is neither a table or userdata object");
			return false;
		end;
	end;

	local mt;

	-- Make a unique metatable for this object if we've been told to, or if it's indexing from more than just a class definition,
	-- or if the first parent arg we've been passed is not a table (so we cannot use it as a shared metatable)
	if force_unique_mt or arg.n > 1 or not is_table(arg[1]) then
		-- Make a unique mt
		mt = {};

		-- Copy the tostring and type values to the new metatable if the main prototype is a class definition
		if is_table(arg[1]) then
			mt.__tostring = arg[1].__tostring;
			mt.__custom_type = arg[1].__custom_type;
		end;
	else
		-- The class definition is also the shared metatable
		mt = arg[1];
	end;

	-- Store the indexes on the metatable - these are looked up by validation scripts when they try to generate errors
	if not rawget(mt, "__indexes") then
		rawset(mt, "__indexes", arg);
	end;

	-- Set the mt
	setmetatable(object, mt);
	
	-- If an __index value has already been set up in this metatable then return. This is presumably a class definition with which
	-- a previous object has been associated, so all this has already been called.
	if rawget(mt, __index) then
		return object;
	end;
	
	if arg.n == 1 then
		-- There's only one parent in our chain, so don't bother looping through the arg table each time __index is invoked as that would be silly
		local parent = arg[1];
		if getmetatable(parent) and not getmetatable(parent).__is_class_definition then
			-- If the parent has a metatable and it's not been explicitly marked as a class definition with __is_class_definition then we 
			-- are assuming that the parent is an object that has a state rather than a table that defines a class. In this case we'll create
			-- an __index function that calls the same function on the parent, passing in the parent as the first arg.
			-- This will mean object:func_call(arg1, arg2), or in its other form object.func_call(object, arg1, arg2), will resolve to 
			-- parent.func_call(parent, arg1, arg2) rather than parent.func_call(object, arg1, arg2), which is the critical difference 
			-- between indexing from a class definition (where 'self' is the child) and indexing from an object (where 'self' is the parent).
			function mt.__index(_child, key)
				-- Get the field being accessed from the parent. If it's a function then return the function 
				-- constructed as described above, otherwise just return the field value as it's something else
				local parent_field = parent[key];
				if type(parent_field) == "function" then
					return function(_child, ...)
						return parent_field(parent, ...);
					end;
				else
					return parent_field;
				end;
			end;
		else
			-- If the parent has no metatable, we can just return the key from it
			--[[
				function mt.__index(_child, key)
				return parent[key];
			end;
			]]

			-- If the parent has no metatable, we can just index it directly
			mt.__index = parent;
		end;
	else
		-- Assemble an __index function that iterates through all parents
		function mt.__index(_child, key)
			for i = 1, arg.n do
				local current_parent = arg[i];
				local current_parent_field = current_parent[key];
				local current_parent_field_type = type(current_parent_field);

				if current_parent_field_type ~= "nil" then
					-- The key that we're looking up exists on the current parent, so we're returning something
					if current_parent_field_type == "function" then
						local parent_mt = getmetatable(current_parent);
						if parent_mt and not parent_mt.__is_class_definition then
							-- The key exists on the current parent, it's a function, this parent has a metatable and
							-- it's not been explicitly marked as a class definition, so we assemble a function to return
							-- where the parent is the self object - see previous comments
							return function(_child, ...)
								return current_parent_field(current_parent, ...);
							end;
						end;
					end;
					-- The key exists on the current parent and it's either:-
					-- a) not a function, so return whatever it is
					-- b) it's a function, but this parent has no metatable and hasn't been explicitly marked as a 
					--    class definition so we don't need to change out the 'self' object
					-- In either case, just return it
					return current_parent_field;
				end;
			end;
		end;
	end;

	return object;
end;


--- @function set_object_class
--- @desc Sets the supplied object to index from the supplied class in a manner that emulates object-orientation. This will set the class to be the metatable of the object and will set the <code>__index</code> field of the metatable also to the supplied class. This means that if functions or values are looked up on the object and are not present they are then looked up on the class. It is through this kind of mechanism that object-orientation may be emulated in lua. Because the class is also the metatable, it means the metatable is shared between objects of the same type. Use @global:set_object_class_unique if this is not desired.
--- @desc <code>set_object_class</code> will also associate the object with any custom type or tostring values that have been previously set up on the class with calls to @global:set_class_custom_type and @global:set_class_tostring.
--- @desc Any number of additional classes and objects may be specified, from which the main supplied object will also derive. If a value (such as a function to be called) is looked up on the object and is not provided on the object or the main class table it derives from, it will be looked up in turn on each additional classes or objects supplied. These additional objects/classes may be @table or @userdata values.
--- @p @table object table, Object table.
--- @p @table class table, Class table.
--- @p ... additional interfaces, Additional classes or objects to index.
--- @r object
function set_object_class(object, ...)
	return set_object_class_impl(false, object, ...);
end;


--- @function set_object_class_unique
--- @desc Sets the supplied object to index from the supplied class in a manner that emulates object-orientation. This will set up a metatable unique to this object and will set the <code>__index</code> field of this metatable to the supplied class. This means that if functions or values are looked up on the object and are not present they are then looked up on the class. It is through this kind of mechanism that object-orientation may be emulated in lua. In contrast to object-to-class relationships set up with @global:set_object_class the metatable is not shared between objects of the same type, which is less memory-efficient but may be desirable in certain circumstances.
--- @desc <code>set_object_class_unique</code> will also associate the object with any custom type or tostring values that have been previously set up on the class with calls to @global:set_class_custom_type and @global:set_class_tostring.
--- @desc Any number of additional classes and objects may be specified, from which the main supplied object will also derive. If a value (such as a function to be called) is looked up on the object and is not provided on the object or the main class table it derives from, it will be looked up in turn on each additional classes or objects supplied. These additional objects/classes may be @table or @userdata values.
--- @p @table object table, Object table.
--- @p @table class table, Class table.
--- @p ... additional interfaces, Additional classes or objects to index.
--- @r object
function set_object_class_unique(object, ...)
	return set_object_class_impl(true, object, ...);
end;


--- @function set_class_metatable
--- @desc Sets the metatable of the specified class table to the supplied table. This also sets the <code>__is_class_definition</code> field in the metatable which @global:set_object_class uses internally to know the difference between a class definition (which has no concept of self) and an object definition (which does) in certain circumstances. This function is for use in specific situations where a class definition requires a metatable and objects derive from it.
--- @p @table class table, Class table.
--- @p @table metatable, Metatable.
--- @p [opt=false] @boolean allow overwrite, Allow the overwriting of the metatable if one already exists.
function set_class_metatable(class, mt, allow_overwrite)
	if not is_table(class) then
		script_error("ERROR: set_class_metatable() called but supplied class definition [" .. tostring(class) .. "] is not a table");
		return false;
	end;

	if not is_table(mt) then
		script_error("ERROR: set_class_metatable() called but supplied metatable [" .. tostring(mt) .. "] is not a table");
		return false;
	end;

	if not allow_overwrite and getmetatable(class) then
		script_error("WARNING: set_class_metatable() called but supplied class definition table [" .. tostring(class) .. "] already has a metatable - it will be overwritten");
		return false;
	end;

	mt.__is_class_definition = true;
	setmetatable(class, mt);
end;





















----------------------------------------------------------------------------
---	@section Lua Type Checking
--- @desc The functions in this section can be used to check whether variables are a built-in type.
----------------------------------------------------------------------------


--- @function is_nil
--- @desc Returns true if the supplied value is nil, false otherwise.
--- @p value value
--- @r @boolean is nil
function is_nil(value)
	return type(value) == "nil";
end;


--- @function is_number
--- @desc Returns true if the supplied value is a number, false otherwise.
--- @p value value
--- @r @boolean is number
function is_number(value)
	return type(value) == "number";
end;


--- @function is_function
--- @desc Returns true if the supplied value is a function, false otherwise.
--- @p value value
--- @r @boolean is function
function is_function(value)
	return type(value) == "function";
end;


--- @function is_string
--- @desc Returns true if the supplied value is a string, false otherwise.
--- @p value value
--- @r @boolean is string
function is_string(value)
	return type(value) == "string";
end;


--- @function is_boolean
--- @desc Returns true if the supplied value is a boolean, false otherwise.
--- @p value value
--- @r @boolean is boolean
function is_boolean(value)
	return type(value) == "boolean";
end;


--- @function is_table
--- @desc Returns true if the supplied value is a table, false otherwise.
--- @p value value
--- @r @boolean is table
function is_table(value)
	return type(value) == "table";
end;


--- @function is_userdata
--- @desc Returns true if the supplied value is userdata, false otherwise.
--- @p value value
--- @r @boolean is userdata
function is_userdata(value)
	return type(value) == "userdata";
end;








----------------------------------------------------------------------------
---	@section Complex Lua Type Checking
--- @desc The functions in this section can be used to check whether variables are specific arrangements of built-in types.
----------------------------------------------------------------------------


--- @function is_integer
--- @desc Returns true if the supplied value is a whole number with no decimal component, or false otherwise.
--- @p value value
--- @r @boolean value is integer
function is_integer(value)
	return type(value) == "number" and value % 1 == 0;
end;


--- @function is_positive_number
--- @desc Returns true if the supplied value is a number greater than 0, or false otherwise.
--- @p value value
--- @r @boolean value is positive number
function is_positive_number(value)
	return type(value) == "number" and value > 0;
end;


--- @function is_non_negative_number
--- @desc Returns true if the supplied value is a number greater than or equal to 0, or false otherwise.
--- @p value value
--- @r @boolean value is non-negative number
function is_non_negative_number(value)
	return type(value) == "number" and value >= 0;
end;


--- @function is_empty_table
--- @desc Returns true if the supplied value is an empty table, or false otherwise.
--- @p value value
--- @r @boolean value is an empty table
function is_empty_table(value)
	return type(value) == "table" and next(value) == nil;
end;


--- @function is_non_empty_table
--- @desc Returns true if the supplied value is a table containing one or more values at any keys, or false otherwise. See also @global:is_non_empty_table_indexed which checks if the values are stored at numerical keys.
--- @p value value
--- @r @boolean value is non-empty table
--- @r @string error message
function is_non_empty_table(value)
	if type(value) ~= "table" then
		return false, "value is not a table";
	end;
	if not next(value) then
		return false, "table contains no elements";
	end;

	return true;
end;


--- @function is_non_empty_table_indexed
--- @desc Returns true if the supplied value is a numerically-indexed table containing one or more values, or false otherwise.
--- @p value value
--- @r @boolean value is indexed table containing values
--- @r @string error message
function is_non_empty_table_indexed(value)
	if type(value) ~= "table" then
		return false, "value is not a table";
	end;
	if #value == 0 then
		return false, "table contains no values";
	end;

	return true;
end;


--- @function is_table_of_strings
--- @desc Returns true if the supplied value is a numerically-indexed table containing one or more string values, or false otherwise.
--- @p value value
--- @r @boolean value is indexed table of strings
--- @r @string error message
function is_table_of_strings(value)
	local result, err_str = is_non_empty_table_indexed(value);
	if not result then
		return result, err_str;
	end;
	for i = 1, #value do
		if type(value[i]) ~= "string" then
			return false, "value at key [" .. i .. "] is [" .. tostring(value[i]) .. " of type [" .. type(value[i]) .. "], not a string";
		end;
	end;
	
	return true;
end;


--- @function is_string_or_table_of_strings
--- @desc Returns true if the supplied value is a string, or a numerically-indexed table containing one or more string values. If the supplied value is neither of these types then false is returned.
--- @p value value
--- @r @boolean value is string/indexed table of strings
--- @r @string error message
function is_string_or_table_of_strings(value)
	if type(value) == "string" then
		return true;
	end;

	if type(value) ~= "table" then
		return false, " value is not a table or a string";
	end;
	
	for i = 1, #value do
		if type(value[i]) ~= "string" then
			return false, "value at key [" .. i .. "] is [" .. tostring(value[i]) .. " of type [" .. type(value[i]) .. "], not a string";
		end;
	end;

	return true;
end;


--- @function is_table_of_strings_allow_empty
--- @desc Returns true if the supplied value is an empty table or a numerically-indexed table containing one or more string values, or false otherwise.
--- @p value value
--- @r @boolean value is indexed table of strings
--- @r @string error message
function is_table_of_strings_allow_empty(value)
	if not is_table(value) then
		return false, "value is not a table";
	end;
	for i = 1, #value do
		if type(value[i]) ~= "string" then
			return false, "value at key [" .. i .. "] is [" .. tostring(value[i]) .. " of type [" .. type(value[i]) .. "], not a string";
		end;
	end;
	
	return true;
end;


--- @function is_condition
--- @desc Returns true if the supplied value is a function or the boolean value <code>true</code>. Event conditions in the scripting library commonly adhere to this format, where an event is received and the condition must either be a function that returns a result, or be the boolean value true. If the supplied value is not <code>true</code> or a function, then false is returned.
--- @p value value
--- @r @boolean value is a condition
function is_condition(value)
	return type(value) == "function" or value == true;
end;











----------------------------------------------------------------------------
---	@section Common Type Checking
--- @desc The functions in this section can be used to check whether variables are of a code type that is not built-in to Lua but common across all our game environments.
----------------------------------------------------------------------------


--- @function is_eventcontext
--- @desc Returns true if the supplied value is an event context, false otherwise.
--- @p value value
--- @r @boolean is event context
function is_eventcontext(value)
	return string.sub(tostring(value), 1, 14) == "Pointer<EVENT>";
end;


--- @function is_uicomponent
--- @desc Returns true if the supplied value is a uicomponent, false otherwise.
--- @p value value
--- @r @boolean is uicomponent
function is_uicomponent(value)
	return string.sub(tostring(value), 1, 12) == "UIComponent ";
end;


--- @function is_component
--- @desc Returns true if the supplied value is a component memory address, false otherwise.
--- @p value value
--- @r @boolean is component memory address
function is_component(value)
	return string.sub(tostring(value), 1, 19) == "Pointer<Component> ";
end;









----------------------------------------------------------------------------
---	@section Campaign Code Type Checking
--- @desc The functions in this section can be used to check whether variables are of a userdata code type that is provided in the campaign environment. In certain cases the function also works in battle.
----------------------------------------------------------------------------


--- @function is_null
--- @desc Returns true if the supplied value is a campaign null script interface, false otherwise.
--- @p value value
--- @r @boolean is null
function is_null(value)
	return string.sub(tostring(value), 1, 21) == "NULL_SCRIPT_INTERFACE";
end;


--- @function is_model
--- @desc Returns true if the supplied value is a campaign model interface, false otherwise.
--- @p value value
--- @r @boolean is model
function is_model(value)
	return string.sub(tostring(value), 1, 22) == "MODEL_SCRIPT_INTERFACE";
end;


--- @function is_world
--- @desc Returns true if the supplied value is a campaign world interface, false otherwise.
--- @p value value
--- @r @boolean is world
function is_world(value)
	return string.sub(tostring(value), 1, 22) == "WORLD_SCRIPT_INTERFACE";
end;


--- @function is_faction
--- @desc Returns true if the supplied value is a campaign faction interface, false otherwise.
--- @p value value
--- @r @boolean is faction
function is_faction(value)
	return string.sub(tostring(value), 1, 24) == "FACTION_SCRIPT_INTERFACE";
end;


--- @function is_factionlist
--- @desc Returns true if the supplied value is a campaign faction list interface, false otherwise.
--- @p value value
--- @r @boolean is faction list
function is_factionlist(value)
	return string.sub(tostring(value), 1, 29) == "FACTION_LIST_SCRIPT_INTERFACE";
end;


--- @function is_character
--- @desc Returns true if the supplied value is a campaign character interface, false otherwise.
--- @p value value
--- @r @boolean is character
function is_character(value)
	return string.sub(tostring(value), 1, 26) == "CHARACTER_SCRIPT_INTERFACE";
end;


--- @function is_family_member
--- @desc Returns true if the supplied value is a campaign family member interface, false otherwise.
--- @p value value
--- @r @boolean is family member
function is_familymember(value)
	return string.sub(tostring(value), 1, 30) == "FAMILY_MEMBER_SCRIPT_INTERFACE";
end;


--- @function is_characterlist
--- @desc Returns true if the supplied value is a campaign character list interface, false otherwise.
--- @p value value
--- @r @boolean is character list
function is_characterlist(value)
	return string.sub(tostring(value), 1, 31) == "CHARACTER_LIST_SCRIPT_INTERFACE";
end;


--- @function is_regionmanager
--- @desc Returns true if the supplied value is a campaign region manager interface, false otherwise.
--- @p value value
--- @r @boolean is region manager
function is_regionmanager(value)
	return string.sub(tostring(value), 1, 31) == "REGION_MANAGER_SCRIPT_INTERFACE";
end;


--- @function is_region
--- @desc Returns true if the supplied value is a campaign region interface, false otherwise.
--- @p value value
--- @r @boolean is region
function is_region(value)
	return string.sub(tostring(value), 1, 23) == "REGION_SCRIPT_INTERFACE";
end;


--- @function is_regiondata
--- @desc Returns true if the supplied value is a campaign region data interface, false otherwise.
--- @p value value
--- @r @boolean is region data
function is_regiondata(value)
	return string.sub(tostring(value), 1, 28) == "REGION_DATA_SCRIPT_INTERFACE";
end;


--- @function is_province
--- @desc Returns true if the supplied value is a campaign province interface, false otherwise.
--- @p value value
--- @r @boolean is province
function is_province(value)
	return string.sub(tostring(value), 1, 25) == "PROVINCE_SCRIPT_INTERFACE";
end;


--- @function is_factionprovince
--- @desc Returns true if the supplied value is a campaign faction province interface, false otherwise.
--- @p value value
--- @r @boolean is faction province
function is_factionprovince(value)
	return string.sub(tostring(value), 1, 41) == "FACTION_PROVINCE_MANAGER_SCRIPT_INTERFACE";
end;


--- @function is_regionlist
--- @desc Returns true if the supplied value is a campaign region list interface, false otherwise.
--- @p value value
--- @r @boolean is region list
function is_regionlist(value)
	return string.sub(tostring(value), 1, 28) == "REGION_LIST_SCRIPT_INTERFACE";
end;


--- @function is_garrisonresidence
--- @desc Returns true if the supplied value is a campaign garrison residence interface, false otherwise.
--- @p value value
--- @r @boolean is garrison residence
function is_garrisonresidence(value)
	return string.sub(tostring(value), 1, 35) == "GARRISON_RESIDENCE_SCRIPT_INTERFACE";
end;


--- @function is_settlement
--- @desc Returns true if the supplied value is a campaign settlement interface, false otherwise.
--- @p value value
--- @r @boolean is settlement
function is_settlement(value)
	return string.sub(tostring(value), 1, 27) == "SETTLEMENT_SCRIPT_INTERFACE";
end;


--- @function is_slot
--- @desc Returns true if the supplied value is a campaign slot interface, false otherwise.
--- @p value value
--- @r @boolean is slot
function is_slot(value)
	return string.sub(tostring(value), 1, 21) == "SLOT_SCRIPT_INTERFACE";
end;


--- @function is_slotlist
--- @desc Returns true if the supplied value is a campaign slot list interface, false otherwise.
--- @p value value
--- @r @boolean is slot list
function is_slotlist(value)
	return string.sub(tostring(value), 1, 26) == "SLOT_LIST_SCRIPT_INTERFACE";
end;


--- @function is_militaryforce
--- @desc Returns true if the supplied value is a campaign military force interface, false otherwise.
--- @p value value
--- @r @boolean is military force
function is_militaryforce(value)
	return string.sub(tostring(value), 1, 31) == "MILITARY_FORCE_SCRIPT_INTERFACE";
end;


--- @function is_militaryforcelist
--- @desc Returns true if the supplied value is a campaign military force list interface, false otherwise.
--- @p value value
--- @r @boolean is military force list
function is_militaryforcelist(value)
	return string.sub(tostring(value), 1, 36) == "MILITARY_FORCE_LIST_SCRIPT_INTERFACE";
end;


--- @function is_unit
--- @desc Returns true if the supplied value is a unit object, false otherwise. This works in both campaign and battle on their respective unit object types.
--- @p value value
--- @r @boolean is unit
function is_unit(value)
	return string.sub(tostring(value), 1, 12) == "battle.unit " or string.sub(tostring(value), 1, 21) == "UNIT_SCRIPT_INTERFACE";
end;


--- @function is_unitlist
--- @desc Returns true if the supplied value is a campaign unit list interface, false otherwise.
--- @p value value
--- @r @boolean is unit list
function is_unitlist(value)
	return string.sub(tostring(value), 1, 26) == "UNIT_LIST_SCRIPT_INTERFACE";
end;


--- @function is_pendingbattle
--- @desc Returns true if the supplied value is a campaign pending battle interface, false otherwise.
--- @p value value
--- @r @boolean is pending battle
function is_pendingbattle(value)
	return string.sub(tostring(value), 1, 31) == "PENDING_BATTLE_SCRIPT_INTERFACE";
end;


--- @function is_campaignmission
--- @desc Returns true if the supplied value is a campaign mission interface, false otherwise.
--- @p value value
--- @r @boolean is campaign mission
function is_campaignmission(value)
	return string.sub(tostring(value), 1, 33) == "CAMPAIGN_MISSION_SCRIPT_INTERFACE";
end;


--- @function is_campaignai
--- @desc Returns true if the supplied value is a campaign ai interface, false otherwise.
--- @p value value
--- @r @boolean is campaign ai
function is_campaignai(value)
	return string.sub(tostring(value), 1, 28) == "CAMPAIGN_AI_SCRIPT_INTERFACE";
end;


--- @function is_buildinglist
--- @desc Returns true if the supplied value is a building list object, false otherwise.
--- @p value value
--- @r @boolean is building list
function is_buildinglist(value)
	return string.sub(tostring(value), 1, 30) == "BUILDING_LIST_SCRIPT_INTERFACE";
end;


--- @function is_building
--- @desc Returns true if the supplied value is a building object in campaign or battle, false otherwise.
--- @p value value
--- @r @boolean is building
function is_building(value)
	local obj_str = tostring(value);
	return string.sub(obj_str, 1, 16) == "battle.building " or string.sub(obj_str, 1, 25) == "BUILDING_SCRIPT_INTERFACE";
end;


--- @function is_foreignslotmanager
--- @desc Returns true if the supplied value is a foreign slot manager interface, false otherwise.
--- @p value value
--- @r @boolean is foreign slot manager
function is_foreignslotmanager(value)
	return string.sub(tostring(value), 1, 37) == "FOREIGN_SLOT_MANAGER_SCRIPT_INTERFACE";
end;


--- @function is_foreignslot
--- @desc Returns true if the supplied value is a foreign slot interface, false otherwise.
--- @p value value
--- @r @boolean is foreign slot
function is_foreignslot(value)
	return string.sub(tostring(value), 1, 29) == "FOREIGN_SLOT_SCRIPT_INTERFACE";
end;












----------------------------------------------------------------------------
---	@section Battle Code Type Checking
--- @desc The functions in this section can be used to check whether variables are of a userdata code type that is provided in the battle environment. In certain cases functions are shared with campaign, in which case they are listed with the campaign type-checking functions.
----------------------------------------------------------------------------


--- @function is_battlesoundeffect
--- @desc Returns true if the supplied value is a battle sound effect, false otherwise.
--- @p value value
--- @r @boolean is battle sound effect
function is_battlesoundeffect(value)
	return string.sub(tostring(value), 1, 20) == "battle_sound_effect ";
end;


--- @function is_battle
--- @desc Returns true if the supplied value is an empire battle object, false otherwise.
--- @p value value
--- @r @boolean is battle
function is_battle(value)
	return string.sub(tostring(value), 1, 14) == "empire_battle ";
end;


--- @function is_alliances
--- @desc Returns true if the supplied value is an alliances object, false otherwise.
--- @p value value
--- @r @boolean is alliances
function is_alliances(value)
	return string.sub(tostring(value), 1, 17) == "battle.alliances ";
end;


--- @function is_alliance
--- @desc Returns true if the supplied value is an alliance, false otherwise.
--- @p value value
--- @r @boolean is alliance
function is_alliance(value)
	return string.sub(tostring(value), 1, 16) == "battle.alliance ";
end;


--- @function is_armies
--- @desc Returns true if the supplied value is an armies object, false otherwise.
--- @p value value
--- @r @boolean is armies
function is_armies(value)
	return string.sub(tostring(value), 1, 14) == "battle.armies ";
end;


--- @function is_army
--- @desc Returns true if the supplied value is an army object, false otherwise.
--- @p value value
--- @r @boolean is army
function is_army(value)
	return string.sub(tostring(value), 1, 12) == "battle.army ";
end;


--- @function is_units
--- @desc Returns true if the supplied value is a units object, false otherwise.
--- @p value value
--- @r @boolean is units
function is_units(value)
	return string.sub(tostring(value), 1, 13) == "battle.units ";
end;


--- @function is_unitcontroller
--- @desc Returns true if the supplied value is a unitcontroller, false otherwise.
--- @p value value
--- @r @boolean is unitcontroller
function is_unitcontroller(value)
	return string.sub(tostring(value), 1, 23) == "battle.unit_controller ";
end;


--- @function is_vector
--- @desc Returns true if the supplied value is a vector object, false otherwise.
--- @p value value
--- @r @boolean is vector
function is_vector(value)
	return string.sub(tostring(value), 1, 14) == "battle_vector " or is_custom_type(value, TYPE_CAMPAIGN_VECTOR);
end;


--- @function is_buildings
--- @desc Returns true if the supplied value is a buildings object, false otherwise.
--- @p value value
--- @r @boolean is buildings
function is_buildings(value)
	return string.sub(tostring(value), 1, 17) == "battle.buildings ";
end;


--- @function is_subtitles
--- @desc Returns true if the supplied value is a battle subtitles object, false otherwise.
--- @p value value
--- @r @boolean is subtitles
function is_subtitles(value)
	return string.sub(tostring(value), 1, 17) == "battle.subtitles ";
end;












----------------------------------------------------------------------------
---	@section Common Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in multiple game environments.
----------------------------------------------------------------------------


--- @function is_core
--- @desc Returns true if the supplied value is a @core object, false otherwise.
--- @p value value
--- @r @boolean is core
function is_core(value)
	return is_custom_type(value, TYPE_CORE);
end;


--- @function is_timermanager
--- @desc Returns true if the supplied value is a timer manager, false otherwise.
--- @p value value
--- @r @boolean is timer manager
function is_timermanager(value)
	return is_custom_type(value, TYPE_TIMER_MANAGER);
end;


--- @function is_scriptmessager
--- @desc Returns true if the supplied value is a script messager, false otherwise.
--- @p value value
--- @r @boolean is script messager
function is_scriptmessager(value)
	return is_custom_type(value, TYPE_SCRIPT_MESSAGER);
end;


--- @function is_customcontext
--- @desc Returns true if the supplied value is a custom event context, false otherwise.
--- @p value value
--- @r @boolean is custom context
function is_customcontext(value)
	return is_custom_type(value, TYPE_CUSTOM_CONTEXT);
end;


--- @function is_objectivesmanager
--- @desc Returns true if the supplied value is an @objectives_manager, false otherwise.
--- @p value value
--- @r @boolean is objectives manager
function is_objectivesmanager(value)
	return is_custom_type(value, TYPE_OBJECTIVES_MANAGER);
end;


--- @function is_infotextmanager
--- @desc Returns true if the supplied value is an @infotext_manager, false otherwise.
--- @p value value
--- @r @boolean is infotext manager
function is_infotextmanager(value)
	return is_custom_type(value, TYPE_INFOTEXT_MANAGER);
end;


--- @function is_linkparser
--- @desc Returns true if the supplied value is a link parser, false otherwise.
--- @p value value
--- @r @boolean is link parser
function is_linkparser(value)
	return is_custom_type(value, TYPE_LINK_PARSER);
end;


--- @function is_tooltiplistener
--- @desc Returns true if the supplied value is a tooltip listener, false otherwise.
--- @p value value
--- @r @boolean is tooltip listener
function is_tooltiplistener(value)
	return is_custom_type(value, TYPE_TOOLTIP_LISTENER);
end;


--- @function is_contextvisibilitymonitor
--- @desc Returns true if the supplied value is a context visibility monitor, false otherwise.
--- @p value value
--- @r @boolean is context visibility monitor
function is_contextvisibilitymonitor(value)
	return is_custom_type(value, TYPE_CONTEXT_VISIBILITY_MONITOR);
end;


--- @function is_tooltippatcher
--- @desc Returns true if the supplied value is a tooltip patcher, false otherwise.
--- @p value value
--- @r @boolean is tooltip patcher
function is_tooltippatcher(value)
	return is_custom_type(value, TYPE_TOOLTIP_PATCHER);
end;


--- @function is_helppagemanager
--- @desc Returns true if the supplied value is a help page manager, false otherwise.
--- @p value value
--- @r @boolean is help page manager
function is_helppagemanager(value)
	return is_custom_type(value, TYPE_HELP_PAGE_MANAGER);
end;


--- @function is_helppage
--- @desc Returns true if the supplied value is a help page, false otherwise.
--- @p value value
--- @r @boolean is help page
function is_helppage(value)
	return is_custom_type(value, TYPE_HELP_PAGE);
end;


--- @function is_textpointer
--- @desc Returns true if the supplied value is a text pointer, false otherwise.
--- @p value value
--- @r @boolean is text pointer
function is_textpointer(value)
	return is_custom_type(value, TYPE_TEXT_POINTER);
end;


--- @function is_activepointer
--- @desc Returns true if the supplied value is an active pointer, false otherwise.
--- @p value value
--- @r @boolean is active pointer
function is_activepointer(value)
	return is_custom_type(value, TYPE_ACTIVE_POINTER);
end;


--- @function is_scriptedtour
--- @desc Returns true if the supplied value is a scripted tour, false otherwise.
--- @p value value
--- @r @boolean is scripted tour
function is_scriptedtour(value)
	return is_custom_type(value, TYPE_SCRIPTED_TOUR);
end;


--- @function is_navigabletour
--- @desc Returns true if the supplied value is a navigable tour, false otherwise.
--- @p value value
--- @r @boolean is navigable tour
function is_navigabletour(value)
	return is_custom_type(value, TYPE_NAVIGABLE_TOUR);
end;


--- @function is_navigabletoursection
--- @desc Returns true if the supplied value is a navigable tour section, false otherwise.
--- @p value value
--- @r @boolean is navigable tour section
function is_navigabletoursection(value)
	return is_custom_type(value, TYPE_NAVIGABLE_TOUR_SECTION);
end;


--- @function is_movieoverlay
--- @desc Returns true if the supplied value is a @movie_overlay, false otherwise.
--- @p value value
--- @r @boolean is movie overlay
function is_movieoverlay(value)
	return is_custom_type(value, TYPE_MOVIE_OVERLAY);
end;


--- @function is_windowedmovieplayer
--- @desc Returns true if the supplied value is a @windowed_movie_player, false otherwise.
--- @p value value
--- @r @boolean is windowed movie player
function is_windowedmovieplayer(value)
	return is_custom_type(value, TYPE_WINDOWED_MOVIE_PLAYER);
end;


--- @function is_topicleader
--- @desc Returns true if the supplied value is a @topic_leader, false otherwise.
--- @p value value
--- @r @boolean is topic leader
function is_topicleader(value)
	return is_custom_type(value, TYPE_TOPIC_LEADER);
end;










----------------------------------------------------------------------------
---	@section Campaign Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in campaign.
----------------------------------------------------------------------------


--- @function is_campaignmanager
--- @desc Returns true if the supplied value is a campaign manager, false otherwise.
--- @p value value
--- @r @boolean is campaign manager
function is_campaignmanager(value)
	return is_custom_type(value, TYPE_CAMPAIGN_MANAGER);
end;


--- @function is_factionstart
--- @desc Returns true if the supplied value is a faction start object, false otherwise.
--- @p value value
--- @r @boolean is faction start
function is_factionstart(value)
	return is_custom_type(value, TYPE_FACTION_START);
end;


--- @function is_factionintrodata
--- @desc Returns true if the supplied value is a faction intro data object, false otherwise.
--- @p value, value
--- @r @boolean is intro data
function is_factionintrodata(value)
	return is_custom_type(value, TYPE_FACTION_INTRO_DATA);
end;


--- @function is_campaigncutscene
--- @desc Returns true if the supplied value is a campaign cutscene, false otherwise.
--- @p value value
--- @r @boolean is campaign cutscene
function is_campaigncutscene(value)
	return is_custom_type(value, TYPE_CAMPAIGN_CUTSCENE);
end;


--- @function is_uioverride
--- @desc Returns true if the supplied value is a ui override, false otherwise.
--- @p value value
--- @r @boolean is ui override
function is_uioverride(value)
	return is_custom_type(value, TYPE_UI_OVERRIDE);
end;


--- @function is_campaignuimanager
--- @desc Returns true if the supplied value is a campaign ui manager, false otherwise.
--- @p value value
--- @r @boolean is campaign ui manager
function is_campaignuimanager(value)
	return is_custom_type(value, TYPE_CAMPAIGN_UI_MANAGER);
end;


--- @function is_missionmanager
--- @desc Returns true if the supplied value is a mission manager, false otherwise.
--- @p value value
--- @r @boolean is mission manager
function is_missionmanager(value)
	return is_custom_type(value, TYPE_MISSION_MANAGER);
end;


--- @function is_chaptermission
--- @desc Returns true if the supplied value is a chapter mission, false otherwise.
--- @p value value
--- @r @boolean is chapter mission
function is_chaptermission(value)
	return is_custom_type(value, TYPE_CHAPTER_MISSION);
end;


--- @function is_intervention
--- @desc Returns true if the supplied value is an intervention, false otherwise.
--- @p value value
--- @r @boolean is intervention
function is_intervention(value)
	return is_custom_type(value, TYPE_INTERVENTION);
end;


--- @function is_interventionmanager
--- @desc Returns true if the supplied value is an intervention manager, false otherwise.
--- @p value value
--- @r @boolean is intervention manager
function is_interventionmanager(value)
	return is_custom_type(value, TYPE_INTERVENTION_MANAGER);
end;


--- @function is_invasionmanager
--- @desc Returns true if the supplied value is an invasion manager, false otherwise.
--- @p value value
--- @r @boolean is invasion manager
function is_interventionmanager(value)
	return is_custom_type(value, TYPE_INVASION_MANAGER);
end;


--- @function is_randomarmy
--- @desc Returns true if the supplied value is a random army manager, false otherwise.
--- @p value value
--- @r @boolean is random army manager
function is_interventionmanager(value)
	return is_custom_type(value, TYPE_INVASION_MANAGER);
end;


--- @function is_narrativeevent
--- @desc Returns true if the supplied value is a @narrative_event, false otherwise.
--- @p value value
--- @r @boolean is narrative event
function is_narrativeevent(value)
	return is_custom_type(value, TYPE_CAMPAIGN_NARRATIVE_EVENT);
end;


--- @function is_narrativequery
--- @desc Returns true if the supplied value is a @narrative_query, false otherwise.
--- @p value value
--- @r @boolean is narrative query
function is_narrativequery(value)
	return is_custom_type(value, TYPE_CAMPAIGN_NARRATIVE_QUERY);
end;


--- @function is_narrativetrigger
--- @desc Returns true if the supplied value is a @narrative_trigger, false otherwise.
--- @p value value
--- @r @boolean is narrative trigger
function is_narrativetrigger(value)
	return is_custom_type(value, TYPE_CAMPAIGN_NARRATIVE_TRIGGER);
end;


function is_introcampaigncameramarker(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_CAMERA_MARKER);
end;


function is_introcampaigncamerapositionsadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_CAMERA_POSITIONS_ADVICE);
end;


function is_introcampaignselectandattackadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE);
end;


function is_introcampaignselectadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_SELECT_ADVICE);
end;


function is_introcampaignmovementadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE);
end;


function is_introcampaignrecruitmentadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE);
end;


function is_introcampaignselectsettlementadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE);
end;


function is_introcampaignpanelhighlightadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE);
end;


function is_introcampaignbuildingconstructionadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE);
end;


function is_introcampaigntechnologyadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE);
end;


function is_introcampaignendturnadvice(value)
	return is_custom_type(value, TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE);
end;


function is_campaignnarrativeevent(value)
	return is_custom_type(value, TYPE_CAMPAIGN_NARRATIVE_EVENT);
end;














----------------------------------------------------------------------------
---	@section Battle Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in battle.
----------------------------------------------------------------------------


--- @function is_battlemanager
--- @desc Returns true if the supplied value is a @battle_manager, false otherwise.
--- @p value value
--- @r @boolean is battle manager
function is_battlemanager(value)
	return is_custom_type(value, TYPE_BATTLE_MANAGER);
end;


--- @function is_cutscene
--- @desc Returns true if the supplied value is a battle cutscene, false otherwise.
--- @p value value
--- @r @boolean is cutscene
function is_cutscene(value)
	return is_custom_type(value, TYPE_CUTSCENE_MANAGER);
end;


--- @function is_convexarea
--- @desc Returns true if the supplied value is a @convex_area, false otherwise.
--- @p value value
--- @r @boolean is convex area
function is_convexarea(value)
	return is_custom_type(value, TYPE_CONVEX_AREA);
end;


--- @function is_scriptunit
--- @desc Returns true if the supplied value is a @script_unit, false otherwise.
--- @p value value
--- @r @boolean is scriptunit
function is_scriptunit(value)
	return is_custom_type(value, TYPE_SCRIPT_UNIT);
end;


--- @function is_scriptunits
--- @desc Returns true if the supplied value is a @script_units object, false otherwise.
--- @p value value
--- @r @boolean is scriptunits
function is_scriptunits(value)
	return is_custom_type(value, TYPE_SCRIPT_UNITS);
end;


--- @function is_patrolmanager
--- @desc Returns true if the supplied value is a patrol manager, false otherwise.
--- @p value value
--- @r @boolean is patrol manager
function is_patrolmanager(value)
	return is_custom_type(value, TYPE_PATROL_MANAGER);
end;


--- @function is_waypoint
--- @desc Returns true if the supplied value is a patrol manager waypoint, false otherwise.
--- @p value value
--- @r @boolean is waypoint
function is_waypoint(value)
	return is_custom_type(value, TYPE_WAYPOINT);
end;


--- @function is_scriptaiplanner
--- @desc Returns true if the supplied value is a script ai planner, false otherwise.
--- @p value value
--- @r @boolean is script ai planner
function is_scriptaiplanner(value)
	return is_custom_type(value, TYPE_SCRIPT_AI_PLANNER);
end;


--- @function is_generatedbattle
--- @desc Returns true if the supplied value is a generated battle, false otherwise.
--- @p value value
--- @r @boolean is generated battle
function is_generatedbattle(value)
	return is_custom_type(value, TYPE_GENERATED_BATTLE);
end;


--- @function is_generatedarmy
--- @desc Returns true if the supplied value is a generated army, false otherwise.
--- @p value value
--- @r @boolean is generated army
function is_generatedarmy(value)
	return is_custom_type(value, TYPE_GENERATED_ARMY);
end;


--- @function is_generatedcutscene
--- @desc Returns true if the supplied value is a generated cutscene, false otherwise.
--- @p value value
--- @r @boolean is generated cutscene
function is_generatedcutscene(value)
	return is_custom_type(value, TYPE_GENERATED_CUTSCENE);
end;


--- @function is_advicemanager
--- @desc Returns true if the supplied value is an advice manager, false otherwise.
--- @p value value
--- @r @boolean is advice manager
function is_advicemanager(value)
	return is_custom_type(value, TYPE_ADVICE_MANAGER);
end;


--- @function is_advicemonitor
--- @desc Returns true if the supplied value is an advice monitor, false otherwise.
--- @p value value
--- @r @boolean is advice monitor
function is_advicemonitor(value)
	return is_custom_type(value, TYPE_ADVICE_MONITOR);
end;


--- @function is_attacklanemanager
--- @desc Returns true if the supplied value is an attack lane manager, false otherwise.
--- @p value value
--- @r @boolean is attack lane manager
function is_attacklanemanager(value)
	return is_custom_type(value, TYPE_ATTACK_LANE_MANAGER);
end;





































----------------------------------------------------------------------------
--- @c validate Validate
--- @function_separator .
--- @desc The validation table contains a suite of functions that can provide input validation for other scripts. A validation function, when provided with a value, checks that value and returns <code>true</code> if it passes the check. If the value does not pass the check then the validation function throws a @global:script_error containing a descriptive error message and return <code>false</code>.
--- @desc The diference between calling a validation function and calling one of the global @"global:Lua Type Checking" functions is that the validation function will automatically throw a script error if the validation fails.
----------------------------------------------------------------------------

-- validate table that contains all validation functions
validate = {}

-- If this is set to false, then all validation functions will always return true. We may wish to disable validation in released builds for performance reasons.
local validation_enabled = true;


-- local function to get string names for class and object, for a given object reference
local function get_class_and_object_name_for_object(object)
	local class_name = get_custom_type(object);
	local object_name;

	-- try and find a name for the object
	if is_string(object.name_for_validation) then
		object_name = object.name_for_validation;
	elseif is_string(object.full_name) then
		object_name = object.full_name;
	elseif is_string(object.id) then
		object_name = object.id;
	elseif is_string(object.name) then
		object_name = object.name;
	end;
	
	return class_name, object_name;
end;

-- local function to get a name for a method, for given object and function reference
local function get_function_name_for_object_and_function(object, func)
	for key, value in pairs(object) do
		if value == func then
			return tostring(key);
		end;
	end;

	-- if key wasn't found, then try looking on this object's indexes if they've been set
	local mt = getmetatable(object);
	
	-- mt.__indexes is set by set_object_class
	if is_table(mt) and mt.__indexes then
		for i = 1, #mt.__indexes do
			local current_index = mt.__indexes[i];
			for key, value in pairs(current_index) do
				if value == func then
					return tostring(key);
				end;
			end;
		end;
	end;
end;


-- local function to actually perform validation
local function generate_validation_error(value, function_identifier, variable_identifier, error_str)
	local info = debug.getinfo(3, "nflS")

	local print_lua_src = true;			
	local error_str_table = {"ERROR: validation failed in "};
	
	if info.what == "C" then
		-- Call has come from a C function
		table.insert(error_str_table, "C function ");
			table.insert(error_str_table, info.name);
		print_lua_src = false;
	elseif info.what == "main" then
		-- Call has come from a main chunk i.e. the root of a lua script file
		table.insert(error_str_table, "main chunk of ");
	else		
		local namewhat = info.namewhat;
		if namewhat == "" or namewhat == "method" or namewhat == "field" then
			-- Call has come from a lua method ( obj:func() ), a lua table field ( t.func() ) or a from function whose name could not be determined (which can still be a function in a table, depending on how it's called)
			
			-- try and find a object, class and function names
			local class_name, object_name, function_name;
			if is_string(function_identifier) then
				function_name = function_identifier;
			elseif is_table(function_identifier) then
				class_name, object_name = get_class_and_object_name_for_object(function_identifier);

				if not info.name or info.name == "?" then
					function_name = get_function_name_for_object_and_function(function_identifier, info.func);
				else
					function_name = info.name;
				end;
			end;

			if not function_name then
				function_name = "<unnamed function>";
			end;

			if namewhat == "method" then
				table.insert(error_str_table, "lua method ");
			else
				table.insert(error_str_table, "lua function ");
			end;
	
			if class_name then
				table.insert(error_str_table, class_name);
				table.insert(error_str_table, ":");
			end;
	
			table.insert(error_str_table, function_name);
			
			if object_name then
				table.insert(error_str_table, "() on object with name [");
				table.insert(error_str_table, object_name);
				table.insert(error_str_table, "] at ");
			else
				table.insert(error_str_table, "() at ");
			end;
		else
			-- Call has come from a local or global lua function
			table.insert(error_str_table, namewhat);
			table.insert(error_str_table, " lua function ");
			table.insert(error_str_table, info.name);
			table.insert(error_str_table, "() at ");
		end;
	end;
	
	table.insert(error_str_table, info.short_src);
	table.insert(error_str_table, ":");
	table.insert(error_str_table, info.currentline);

	table.insert(error_str_table, " - ");

	if is_string(variable_identifier) then
		table.insert(error_str_table, "variable [");
		table.insert(error_str_table, variable_identifier);
		table.insert(error_str_table, "] with value [");
	else
		table.insert(error_str_table, "value [");
	end;

	table.insert(error_str_table, tostring(value));
	table.insert(error_str_table, "] of type [");
	table.insert(error_str_table, type(value));
	table.insert(error_str_table, "] ");

	table.insert(error_str_table, error_str);

	script_error(table.concat(error_str_table), 1);
end;


-- internal factory function which creates the validation
local function add_validation_function(validation_table, validation_function_name, validation_function, error_string_generator)

	if validation_enabled then
		validation_table[validation_function_name] = function(value, function_identifier, variable_identifier)
			local is_valid, error_str_from_validation = validation_function(value)
			if is_valid then
				-- validation passed, so return
				return true;
			end;

			-- Produce the final bit of the error here e.g. " is not a string"
			-- error_string_generator: 			
			--		Either a string or a function which generates a string
			-- error_string_from_validation:	
			--		An optional string from the validation function which specifies exactly why validation failed e.g. "object is not a table" vs "object is a table but contains no elements". In most cases this is nil.
			--		If error_string_generator is a function then this value is passed to it to produce the final error string
			local error_str;
			if is_function(error_string_generator) then
				error_str = error_string_generator(error_str_from_validation or "<unknown error>");
			elseif is_string(error_string_generator) then
				error_str = error_string_generator;
			end;

			generate_validation_error(value, function_identifier, variable_identifier, error_str);

			return false;
		end
	else
		validation_table[validation_function_name] = function()
			return true;
		end;
	end;
end;






----------------------------------------------------------------------------
---	@section Lua Type Checking
--- @desc The functions in this section can be used to check whether variables are a built-in type.
----------------------------------------------------------------------------


--- @function is_nil
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not @nil. If the supplied value is nil then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is nil
add_validation_function(validate, "is_nil", is_nil, "is not nil");


--- @function is_number
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @number. If the supplied value is a number then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a number
add_validation_function(validate, "is_number", is_number, "is not a number");


--- @function is_function
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @function. If the supplied value is a function then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a function
add_validation_function(validate, "is_function", is_function, "is not a function");


--- @function is_string
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @string. If the supplied value is a string then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a string
add_validation_function(validate, "is_string", is_string, "is not a string");


--- @function is_boolean
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @boolean. If the supplied value is a boolean then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a boolean
add_validation_function(validate, "is_boolean", is_boolean, "is not a boolean");


--- @function is_boolean_or_nil
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @boolean or @nil. If the supplied value is a boolean or nil then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a boolean
add_validation_function(
	validate,
	"is_boolean_or_nil", 
	function(value)
		return is_boolean(value) or is_nil(value)
	end,
	"is not a boolean"
);


--- @function is_table
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a @table. If the supplied value is a table then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a table
add_validation_function(validate, "is_table", is_table, "is not a table");


--- @function is_userdata
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not @userdata. If the supplied value is userdata then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is userdata
add_validation_function(validate, "is_userdata", is_userdata, "is not userdata");











----------------------------------------------------------------------------
---	@section Complex Lua Type Checking
--- @desc The functions in this section can be used to check whether variables are specific arrangements of built-in types.
----------------------------------------------------------------------------


--- @function is_integer
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an integer value. If the supplied value is an integer then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an integer
add_validation_function(validate, "is_integer", is_integer, "is not an integer");


--- @function is_positive_number
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a number greater than zero. If the supplied value is a positive number then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a positive number
add_validation_function(validate, "is_positive_number", is_positive_number, "is not a positive number");


--- @function is_non_negative_number
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a number greater than or equal to zero. If the supplied value is a non-negative number then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a non-negative number
add_validation_function(validate, "is_non_negative_number", is_non_negative_number, "is not a non-negative number");


--- @function is_non_empty_table
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a non-empty table. If the supplied value is considered to be a non-empty indexed table then <code>true</code> is returned. See also @validate:is_non_empty_table_indexed which should be used for numerically-indexed tables in place of this function.
--- @p value value
--- @r @boolean value is a non-empty table
add_validation_function(
	validate,
	"is_non_empty_table",
	is_non_empty_table,
	function(error_str)
		if not error_str then script_error("eh?") end;
		return "is not a non-empty table - " .. error_str;
	end
);


--- @function is_non_empty_table_indexed
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a non-empty indexed table. An indexed table contains values stored in elements with keys which are ascending integer numbers, starting at 1. Values stored at keys that are not ascending integers are not queried by this test, so a table that contains only values stored in elements with string keys will not count as a "non empty table indexed". If the supplied value is considered to be a non-empty indexed table then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a non-empty indexed table
add_validation_function(
	validate,
	"is_non_empty_table_indexed",
	is_non_empty_table_indexed,
	function(error_str)
		return "is not a non-empty indexed table - " .. error_str;
	end
);


--- @function is_table_of_strings
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a numerically-indexed table of strings. If the supplied value is a table of strings then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a table of strings
add_validation_function(
	validate, 
	"is_table_of_strings", 
	is_table_of_strings, 
	function(error_str) 
		return "is not a table of strings - " .. error_str;
	end
);


--- @function is_string_or_table_of_strings
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a string, or a numerically-indexed table of strings. If the supplied value is either of these value types then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a string/table of strings
add_validation_function(
	validate, 
	"is_string_or_table_of_strings", 
	is_string_or_table_of_strings, 
	function(error_str) 
		return "is not a string or a table of strings - " .. error_str;
	end
);


--- @function is_table_of_strings_allow_empty
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an empty table or a numerically-indexed table of strings. If the supplied value is either of these value types then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a string/table of strings
add_validation_function(
	validate, 
	"is_table_of_strings_allow_empty", 
	is_table_of_strings_allow_empty, 
	function(error_str) 
		return "is not a string, an empty table, or a table of strings - " .. error_str;
	end
);


--- @function is_condition
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a function or the boolean value <code>true</code>. Event conditions in the scripting library commonly adhere to this format, where an event is received and the condition must either be a function that returns a result, or be the boolean value true. If the supplied value is a condition then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a function or true
add_validation_function(validate, "is_condition", is_condition, "is not a condition - the value is not a function or the boolean value true");






----------------------------------------------------------------------------
---	@section Common Type Checking
--- @desc The functions in this section can be used to check whether variables are of a code type that is not built-in to Lua but common across all our game environments.
----------------------------------------------------------------------------


--- @function is_eventcontext
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an event context. If the supplied value is an event context then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an event context
add_validation_function(validate, "is_eventcontext", is_eventcontext, "is not an event context");


--- @function is_uicomponent
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a uicomponent. If the supplied value is a uicomponent then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an event context
add_validation_function(validate, "is_uicomponent", is_uicomponent, "is not a uicomponent");


--- @function is_component
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a component memory address. If the supplied value is a component memory address then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a component memory address
add_validation_function(validate, "is_component", is_component, "is not a component memory address");











----------------------------------------------------------------------------
---	@section Campaign Code Type Checking
--- @desc The functions in this section can be used to check whether variables are of a userdata code type that is provided in the campaign environment. In certain cases the function also works in battle.
----------------------------------------------------------------------------


--- @function is_null
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign null script interface. If the supplied value is a null script interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a null script interface
add_validation_function(validate, "is_null", is_null, "is not a campaign null script interface");


--- @function is_model
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign model interface. If the supplied value is a model interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a model interface
add_validation_function(validate, "is_model", is_model, "is not a campaign model interface");


--- @function is_world
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign world interface. If the supplied value is a world interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a world interface
add_validation_function(validate, "is_world", is_world, "is not a campaign world interface");


--- @function is_faction
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign faction interface. If the supplied value is a faction interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a faction interface
add_validation_function(validate, "is_faction", is_faction, "is not a faction interface");


--- @function is_factionlist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign faction list interface. If the supplied value is a faction list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a faction list interface
add_validation_function(validate, "is_factionlist", is_factionlist, "is not a faction list interface");


--- @function is_character
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign character interface. If the supplied value is a character interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a character interface
add_validation_function(validate, "is_character", is_character, "is not a character interface");


--- @function is_familymember
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign family member interface. If the supplied value is a family member interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a family member interface
add_validation_function(validate, "is_familymember", is_familymember, "is not a family member interface");


--- @function is_characterlist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign character list interface. If the supplied value is a character list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a character list interface
add_validation_function(validate, "is_characterlist", is_characterlist, "is not a character list interface");


--- @function is_regionmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign region manager interface. If the supplied value is a region manager interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a region manager interface
add_validation_function(validate, "is_regionmanager", is_regionmanager, "is not a region manager interface");


--- @function is_region
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign region interface. If the supplied value is a region interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a region interface
add_validation_function(validate, "is_region", is_region, "is not a region interface");


--- @function is_regiondata
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign region data interface. If the supplied value is a region data interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a region data interface
add_validation_function(validate, "is_regiondata", is_regiondata, "is not a region data interface");


--- @function is_province
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign province interface. If the supplied value is a province interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a province interface
add_validation_function(validate, "is_province", is_province, "is not a province interface");


--- @function is_factionprovince
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign faction province interface. If the supplied value is a faction province interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a faction province interface
add_validation_function(validate, "is_factionprovince", is_factionprovince, "is not a faction province interface");


--- @function is_regionlist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign region list interface. If the supplied value is a region list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a region list interface
add_validation_function(validate, "is_regionlist", is_regionlist, "is not a region list interface");


--- @function is_garrisonresidence
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign garrison residence interface. If the supplied value is a garrison residence interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a garrison residence interface
add_validation_function(validate, "is_garrisonresidence", is_garrisonresidence, "is not a garrison residence interface");


--- @function is_settlement
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign settlement interface. If the supplied value is a settlement interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a settlement interface
add_validation_function(validate, "is_settlement", is_settlement, "is not a settlement interface");


--- @function is_slot
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign slot interface. If the supplied value is a slot interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a slot interface
add_validation_function(validate, "is_slot", is_slot, "is not a slot interface");


--- @function is_slotlist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign slot list interface. If the supplied value is a slot list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a slot list interface
add_validation_function(validate, "is_slotlist", is_slotlist, "is not a slot list interface");


--- @function is_militaryforce
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign military force interface. If the supplied value is a military force interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a military force interface
add_validation_function(validate, "is_militaryforce", is_militaryforce, "is not a military force interface");


--- @function is_militaryforcelist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign military force list interface. If the supplied value is a military force list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a military force list interface
add_validation_function(validate, "is_militaryforcelist", is_militaryforcelist, "is not a military force list interface");


--- @function is_unit
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a unit interface. If the supplied value is a unit interface then <code>true</code> is returned. This works in both campaign and battle on their respective unit object types.
--- @p value value
--- @r @boolean value is a unit interface
add_validation_function(validate, "is_unit", is_unit, "is not a unit interface");


--- @function is_unitlist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign unit list interface. If the supplied value is a unit list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a unit list interface
add_validation_function(validate, "is_unitlist", is_unitlist, "is not a unit list interface");


--- @function is_pendingbattle
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign pending battle interface. If the supplied value is a pending battle interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a pending battle interface
add_validation_function(validate, "is_pendingbattle", is_pendingbattle, "is not a pending battle interface");


--- @function is_campaignmission
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign mission interface. If the supplied value is a mission interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a mission interface
add_validation_function(validate, "is_campaignmission", is_campaignmission, "is not a mission interface");


--- @function is_campaignai
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign ai interface. If the supplied value is a campaign ai interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign ai interface
add_validation_function(validate, "is_campaignai", is_campaignai, "is not a campaign ai interface");


--- @function is_buildinglist
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign building list interface. If the supplied value is a building list interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a building list interface
add_validation_function(validate, "is_buildinglist", is_buildinglist, "is not a building list interface");


--- @function is_building
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a building interface. If the supplied value is a building interface then <code>true</code> is returned. This works in both campaign and battle on their respective object types.
--- @p value value
--- @r @boolean value is a building interface
add_validation_function(validate, "is_building", is_building, "is not a building interface");


--- @function is_foreignslotmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a foreign slot manager interface. If the supplied value is a foreign slot manager interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a foreign slot manager interface
add_validation_function(validate, "is_foreignslotmanager", is_foreignslotmanager, "is not a foreign slot manager interface");


--- @function is_foreignslot
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a foreign slot interface. If the supplied value is a foreign slot interface then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a foreign slot interface
add_validation_function(validate, "is_foreignslot", is_foreignslot, "is not a foreign slot interface");










----------------------------------------------------------------------------
---	@section Battle Code Type Checking
--- @desc The functions in this section can be used to check whether variables are of a userdata code type that is provided in the battle environment. In certain cases functions are shared with campaign, in which case they are listed with the campaign type-checking functions.
----------------------------------------------------------------------------


--- @function is_battlesoundeffect
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle sound effect. If the supplied value is a battle sound effect then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle sound effect
add_validation_function(validate, "is_battlesoundeffect", is_battlesoundeffect, "is not a battle sound effect");


--- @function is_battle
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle object. If the supplied value is a battle object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle object
add_validation_function(validate, "is_battle", is_battle, "is not a battle object");


--- @function is_alliances
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an alliances collection object. If the supplied value is an alliances object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an alliances object
add_validation_function(validate, "is_alliances", is_alliances, "is not an alliances collection object");


--- @function is_alliance
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an alliance object. If the supplied value is an alliance object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an alliance object
add_validation_function(validate, "is_alliance", is_alliance, "is not an alliance object");


--- @function is_armies
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an armies collection object. If the supplied value is an armies object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an armies object
add_validation_function(validate, "is_armies", is_armies, "is not an armies collection object");


--- @function is_army
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an army object. If the supplied value is an army object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an army object
add_validation_function(validate, "is_army", is_army, "is not an army object");


--- @function is_units
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a units collection object. If the supplied value is a units object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a units object
add_validation_function(validate, "is_units", is_units, "is not a units object");


--- @function is_unitcontroller
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a unitcontroller object. If the supplied value is a unitcontroller object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a unitcontroller object
add_validation_function(validate, "is_unitcontroller", is_unitcontroller, "is not a unitcontroller object");


--- @function is_vector
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle vector object. If the supplied value is a vector object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle vector object
add_validation_function(validate, "is_vector", is_vector, "is not a battle vector object");


--- @function is_buildings
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a buildings collection object. If the supplied value is a buildings collection object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a buildings collection object
add_validation_function(validate, "is_buildings", is_buildings, "is not a buildings collection object");


--- @function is_subtitles
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a subtitles object. If the supplied value is a subtitles object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a subtitles object
add_validation_function(validate, "is_subtitles", is_subtitles, "is not a subtitles object");













----------------------------------------------------------------------------
---	@section Common Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in multiple game environments.
----------------------------------------------------------------------------


--- @function is_core
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a core script object. If the supplied value is a core object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a core object
add_validation_function(validate, "is_core", is_core, "is not a core object");


--- @function is_timermanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a timer manager script object. If the supplied value is a timer manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a timer manager object
add_validation_function(validate, "is_timermanager", is_timermanager, "is not a core object");


--- @function is_scriptmessager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a script messager object. If the supplied value is a script messager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a script messager object
add_validation_function(validate, "is_scriptmessager", is_scriptmessager, "is not a script messager object");


--- @function is_customcontext
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a custom event context object. If the supplied value is a custom context then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a script messager object
add_validation_function(validate, "is_customcontext", is_customcontext, "is not a custom context object");


--- @function is_objectivesmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an objectives manager script object. If the supplied value is an objectives manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an objectives manager object
add_validation_function(validate, "is_objectivesmanager", is_objectivesmanager, "is not an objectives manager object");


--- @function is_infotextmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an infotext manager script object. If the supplied value is an infotext manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an infotext manager object
add_validation_function(validate, "is_infotextmanager", is_infotextmanager, "is not an infotext manager object");


--- @function is_linkparser
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a link parser script object. If the supplied value is a link parser then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a link parser object
add_validation_function(validate, "is_linkparser", is_linkparser, "is not a link parser object");


--- @function is_tooltiplistener
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a tooltip listener script object. If the supplied value is a tooltip listener then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a tooltip listener object
add_validation_function(validate, "is_tooltiplistener", is_tooltiplistener, "is not a tooltip listener object");


--- @function is_tooltippatcher
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a tooltip patcher script object. If the supplied value is a tooltip patcher then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a tooltip patcher object
add_validation_function(validate, "is_tooltippatcher", is_tooltippatcher, "is not a tooltip patcher object");


--- @function is_helppagemanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a help page manager script object. If the supplied value is a help page manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a help page manager object
add_validation_function(validate, "is_helppagemanager", is_helppagemanager, "is not a help page manager object");


--- @function is_helppage
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a help page script object. If the supplied value is a help page then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a help page object
add_validation_function(validate, "is_helppage", is_helppage, "is not a help page object");


--- @function is_textpointer
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a text pointer script object. If the supplied value is a text pointer then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a help page object
add_validation_function(validate, "is_textpointer", is_textpointer, "is not a text pointer object");


--- @function is_activepointer
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an active pointer script object. If the supplied value is an active pointer then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an active pointer object
add_validation_function(validate, "is_activepointer", is_activepointer, "is not an active pointer object");


--- @function is_scriptedtour
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a scripted tour object. If the supplied value is a scripted tour then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a scripted tour object
add_validation_function(validate, "is_scriptedtour", is_scriptedtour, "is not a scripted tour object");


--- @function is_navigabletour
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a navigable tour object. If the supplied value is a navigable tour then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a navigable tour object
add_validation_function(validate, "is_navigabletour", is_navigabletour, "is not a navigable tour object");


--- @function is_navigabletoursection
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a navigable tour section object. If the supplied value is a navigable tour section then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a navigable tour section object
add_validation_function(validate, "is_navigabletoursection", is_navigabletoursection, "is not a navigable tour section object");


--- @function is_movieoverlay
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a movie overlay script object. If the supplied value is a movie overlay then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a movie overlay object
add_validation_function(validate, "is_movieoverlay", is_movieoverlay, "is not a movie overlay object");


--- @function is_windowedmovieplayer
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a windowed movie player script object. If the supplied value is a windowed movie player then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a windowed movie player object
add_validation_function(validate, "is_windowedmovieplayer", is_windowedmovieplayer, "is not a windowed movie player script object");


--- @function is_topicleader
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a topic leader script object. If the supplied value is a topic leader then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a topic leader object
add_validation_function(validate, "is_topicleader", is_topicleader, "is not a topic leader script object");













----------------------------------------------------------------------------
---	@section Campaign Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in campaign.
----------------------------------------------------------------------------


--- @function is_campaignmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign manager script object. If the supplied value is a campaign manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign manager script object
add_validation_function(validate, "is_campaignmanager", is_campaignmanager, "is not a campaign manager script object");


--- @function is_campaigncutscene
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign cutscene script object. If the supplied value is a campaign cutscene then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign cutscene script object
add_validation_function(validate, "is_campaigncutscene", is_campaigncutscene, "is not a campaign cutscene script object");


--- @function is_uioverride
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a ui override script object. If the supplied value is a ui override then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a ui override script object
add_validation_function(validate, "is_uioverride", is_uioverride, "is not a ui override script object");


--- @function is_campaignuimanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign ui manager script object. If the supplied value is a campaign ui manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign ui manager script object
add_validation_function(validate, "is_campaignuimanager", is_campaignuimanager, "is not a campaign ui manager script object");


--- @function is_missionmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign mission manager script object. If the supplied value is a campaign mission manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign mission manager script object
add_validation_function(validate, "is_missionmanager", is_missionmanager, "is not a mission manager script object");


--- @function is_chaptermission
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign chapter mission script object. If the supplied value is a chapter mission then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign chapter mission script object
add_validation_function(validate, "is_chaptermission", is_chaptermission, "is not a campaign chapter mission script object");


--- @function is_intervention
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign intervention script object. If the supplied value is an intervention then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign intervention script object
add_validation_function(validate, "is_intervention", is_intervention, "is not a campaign intervention script object");


--- @function is_interventionmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign intervention manager script object. If the supplied value is an intervention manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign intervention manager script object
add_validation_function(validate, "is_interventionmanager", is_interventionmanager, "is not a campaign intervention manager script object");


--- @function is_invasionmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign invasion manager script object. If the supplied value is an invasion manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign intervention manager script object
add_validation_function(validate, "is_invasionmanager", is_invasionmanager, "is not a campaign invasion manager script object");


--- @function is_randomarmy
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign random army manager script object. If the supplied value is a random army manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign random army manager script object
add_validation_function(validate, "is_randomarmy", is_randomarmy, "is not a campaign random army manager script object");


--- @function is_narrativeevent
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign narrative event script object. If the supplied value is a narrative event then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign narrative event script object
add_validation_function(validate, "is_narrativeevent", is_narrativeevent, "is not a campaign narrative event script object");


--- @function is_narrativequery
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign narrative query script object. If the supplied value is a narrative query then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign narrative query script object
add_validation_function(validate, "is_narrativequery", is_narrativequery, "is not a campaign narrative query script object");


--- @function is_narrativetrigger
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a campaign narrative trigger script object. If the supplied value is a narrative trigger then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a campaign narrative trigger script object
add_validation_function(validate, "is_narrativetrigger", is_narrativetrigger, "is not a campaign narrative trigger script object");














----------------------------------------------------------------------------
---	@section Battle Script Type Checking
--- @desc The functions in this section can be used to check whether variables are of a script data type that is provided in battle.
----------------------------------------------------------------------------


--- @function is_battlemanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle manager script object. If the supplied value is a battle manager then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle manager script object
add_validation_function(validate, "is_battlemanager", is_battlemanager, "is not a battle manager script object");


--- @function is_cutscene
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle cutscene script object. If the supplied value is a battle cutscene then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle cutscene script object
add_validation_function(validate, "is_cutscene", is_cutscene, "is not a battle cutscene script object");


--- @function is_convexarea
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle convex area script object. If the supplied value is a battle convex area then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle convex area script object
add_validation_function(validate, "is_convexarea", is_convexarea, "is not a convex area script object");


--- @function is_scriptunit
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle scriptunit object. If the supplied value is a scriptunit object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle scriptunit object
add_validation_function(validate, "is_scriptunit", is_scriptunit, "is not a battle scriptunit object");


--- @function is_scriptunits
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle scriptunits collection object. If the supplied value is a scriptunits collection object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle scriptunits collection object
add_validation_function(validate, "is_scriptunits", is_scriptunits, "is not a battle scriptunits collection object");


--- @function is_patrolmanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle patrol manager object. If the supplied value is a patrol manager collection object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle scriptunits collection object
add_validation_function(validate, "is_patrolmanager", is_patrolmanager, "is not a battle patrol manager object");


--- @function is_waypoint
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle waypoint script object. If the supplied value is a waypoint object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle scriptunits collection object
add_validation_function(validate, "is_waypoint", is_waypoint, "is not a waypoint object");


--- @function is_scriptaiplanner
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a battle script ai planner object. If the supplied value is a script ai planner then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a battle script ai planner object
add_validation_function(validate, "is_scriptaiplanner", is_scriptaiplanner, "is not a script ai planner object");


--- @function is_generatedbattle
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a generated battle script object. If the supplied value is a generated battle object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a generated battle object
add_validation_function(validate, "is_generatedbattle", is_generatedbattle, "is not a generated battle script object");


--- @function is_generatedarmy
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a generated army script object. If the supplied value is a generated army object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a generated army object
add_validation_function(validate, "is_generatedarmy", is_generatedarmy, "is not a generated army script object");


--- @function is_generatedcutscene
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not a generated cutscene script object. If the supplied value is a generated cutscene object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is a generated cutscene object
add_validation_function(validate, "is_generatedcutscene", is_generatedcutscene, "is not a generated cutscene script object");


--- @function is_advicemanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an advice manager script object. If the supplied value is an advice manager object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an advice manager script object
add_validation_function(validate, "is_advicemanager", is_advicemanager, "is not an advice manager script object");


--- @function is_advicemonitor
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an advice monitor script object. If the supplied value is an advice monitor object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an advice monitor script object
add_validation_function(validate, "is_advicemonitor", is_advicemonitor, "is not an advice monitor script object");


--- @function is_attacklanemanager
--- @desc Throws a @global:script_error and returns <code>false</code> if the supplied value is not an attack lane manager script object. If the supplied value is an attack lane manager object then <code>true</code> is returned.
--- @p value value
--- @r @boolean value is an attack lane manager script object
add_validation_function(validate, "is_attacklanemanager", is_attacklanemanager, "is not an attack lane manager script object");





