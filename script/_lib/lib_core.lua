


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CORE MANAGER
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c core Core
--- @index_pos 1
--- @desc The core object provides a varied suite of functionality that is sensible to provide in all the various game modes (campaign/battle/frontend). When the script libraries are loaded, a core_object is automatically created. It is called 'core' and the functions it provides can be called with a double colon e.g. <code>core:get_ui_root()</code>
--- @desc Examples of the kind of functionality provided by the core object are event listening and triggering, ui access, and saving and loading values to the scripted value registry.
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------





----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

core_object = {

	svr = false,
	
	-- switch to turn on performance reporting
	show_performance_report = (common.tweaker_value("ENABLE_SCRIPT_PERFORMANCE_WARNING_REPORTS") ~= "0" and common.tweaker_value("ENABLE_SCRIPT_PERFORMANCE_WARNING_REPORTS") ~= ""),

	-- ui creation and destruction
	ui_root = false,
	ui_is_created = false,
	ui_created_callbacks = {},
	ui_destroyed_callbacks = {},
	
	-- game mode
	game_mode = 0,
	
	path_to_dummy_component = "UI/Campaign UI/script_dummy.twui.xml",
	
	-- cached advisor priority
	cached_advisor_priority = -1,
	cached_objectives_priority = -1,
	cached_advisor_topmost = false,
	
	-- event handler
	add_func = nil,
	attached_events = {},
	event_listeners = {},
	env = false,

	-- loaded mods
	loaded_mods = {},

	-- lookup listeners
	all_lookup_listener_lists = {},
	
	-- unique counter, for use across script
	unique_counter = 0,
	
	-- ui hiding
	enable_ui_hiding_on_hide_fullscreen_highlight = true,
	
	-- text pointer names
	registered_text_pointer_names = {},
	advice_history_reset_listener_established_for_text_pointer_names = false,
	
	-- caching tooltips for component states
	cached_tooltips_for_component_states = {},

	-- cached preference values
	cached_preferences = {},
	
	-- static objects
	static_objects = {},

	-- limited callbacks
	limited_callbacks = {},

	-- LoadingScreenDismissed re-entrancy guard
	loading_screen_is_currently_dismissing = false,
	
	-- Movie tracks, for movie overlay playback - the boolean flag indicates whether the track is currently occupied
	movie_tracks = {
		[0] = false,
		[1] = false,
		[2] = false
	},
	
	-- windowed movie players
	registered_windowed_movie_players = {},
	
	active_pointers = {}
};


set_class_custom_type_and_tostring(core_object, TYPE_CORE);







----------------------------------------------------------------------------
--- @section Creation
--- @desc A core object is automatically created when the script libraries are loaded so there should be no need for client scripts to call @core:new themselves.
----------------------------------------------------------------------------

--- @function new
--- @desc Creates a core object. There is no need for client scripts to call this, as a core object is created automatically by the script libraries when they are loaded.
--- @r core_object
function core_object:new()

	local c = {};
	
	set_object_class(c, self);
	
	
	----------------------------------------------------------
	-- event handling functionality
	-- determine what game mode we're running in and choose an appropriate add
	----------------------------------------------------------
	local add_func = false;
	
	if __game_mode == __lib_type_battle then
		c.add_func = add_battle_event_callback;
	elseif __game_mode == __lib_type_campaign then
		c.add_func = add_campaign_event_callback;
	elseif __game_mode == __lib_type_frontend then
		c.add_func = add_frontend_event_callback;
	elseif __game_mode == __lib_type_autotest then
		c.add_func = add_event_callback;
	else
		script_error("ERROR: attempt was made to create core object but couldn't determine the game mode - how can this be?");
		return false;
	end;
	
	c.attached_events = {};
	c.event_listeners = {};	
	
	c.registered_windowed_movie_players = {};
	c.active_pointers = {};


	
	----------------------------------------------------------
	----------------------------------------------------------

	c.env = getfenv(1);	
	c.registered_text_pointer_names = {};
	c.cached_tooltips_for_component_states = {};
	c.limited_callbacks = {};
	c.all_lookup_listener_lists = {};
	c.cached_preferences = {};
	
	----------------------------------------------------------
	-- UI Creation and destruction listeners
	----------------------------------------------------------
		
	-- listen for the UICreated event, unless we're in battle 
	-- (the script is loaded after the UI is created, the battle manager will give us a handle to the ui root)
	c:add_listener(
		"core_ui_created_listener",
		"UICreated",
		true,
		function(context)
			c:ui_created(context);
		end,
		true
	);
	
	c:add_listener(
		"core_ui_destroyed_listener",
		"UIDestroyed",
		true,
		function(context)
			c:ui_destroyed(context);
		end,
		true
	);
		
	c.ui_created_callbacks = {};
	c.ui_destroyed_callbacks = {};
	
	----------------------------------------------------------
	----------------------------------------------------------
	
	-- automatically create a scripted value registry, used for passing messages between environments
	c.svr = ScriptedValueRegistry:new();
	
	
	-- overwrite this function so that another core_object cannot be created this session (hack?!)
	function core_object:new()
		script_error("ERROR: core_object:new() called but core_object has already been created");
		return false;
	end;
	
	return c;
end;






----------------------------------------------------------------------------
--- @section Usage
--- @desc Once created (which happens automatically within the declaration of the script libraries), functions on the core object may be called in the form showed below.
--- @new_example Specification
--- @example core:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example core = core_object:new()		-- object called 'core' is automatically set up
--- @example 
--- @example -- later, after UI creation
--- @example local x, y = core:get_screen_resolution()
--- @example out("Screen resolution is [" .. x .. ", " .. y .. "]")
--- @result Screen resolution is [1600, 900]
----------------------------------------------------------------------------









----------------------------------------------------------------------------
--- @section UI Root
--- @desc Functions concerning the UI root.
----------------------------------------------------------------------------

--- @function get_ui_root
--- @desc Gets a handle to the ui root object. A script_error is thrown if this is called before the ui has been created.
--- @r uicomponent ui root
function core_object:get_ui_root()
	if not self.ui_root then
		script_error("ERROR: get_ui_root() called on the core object but the ui has not been created yet");
		return false;
	end;
	
	return self.ui_root;
end;


--- @function set_ui_root
--- @p uicomponent ui root
--- @desc sets the ui root object that the core stores. Not to be called outside of the script libraries.
function core_object:set_ui_root(ui_root)
	if not is_uicomponent(ui_root) then
		script_error("ERROR: set_ui_root() called but supplied object [" .. tostring(ui_root) .. "] is not a uicomponent");
		return false;
	end;
	
	self.ui_is_created = true;
	self.ui_root = ui_root;
end;


--- @function is_ui_created
--- @desc Returns whether the ui has been created or not. Useful if clients scripts are running so early in the load sequence that the ui may not have been set up yet.
--- @desc Once this function returns true, client scripts should be okay to start asking questions of the game and model.
--- @r boolean is ui created
function core_object:is_ui_created()
	return self.ui_is_created;
end;








----------------------------------------------------------------------------
--- @section UI Creation and Destruction
--- @desc The core object listens for the UI being created and destroyed. Client scripts can register callbacks with the core object to get notified when the UI is set up or destroyed. 
--- @desc It is strongly advised that client scripts use this functionality rather than listen for the UICreated and UIDestroyed events directly, because the core object sets up the UI root before sending out notifications about the ui being created.
----------------------------------------------------------------------------

--- @function add_ui_created_callback
--- @desc Adds a callback to be called when the UI is created.
--- @p @function callback
function core_object:add_ui_created_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_ui_created_callback called but supplied callback [" .. tostring(callback) .. "] is not a function");
	end;
	
	table.insert(self.ui_created_callbacks, callback);
end;


-- called when ui is created
function core_object:ui_created(context)
	out.cache_tab();
	out("");
	out("********************************************************************************");
	out("event has occurred:: UICreated, environment is " .. context.string);
	out("********************************************************************************");
	out.inc_tab();
	
	-- get a handle to the ui root
	self.ui_root = UIComponent(context.component);
	self.ui_is_created = true;
	
	for i = 1, #self.ui_created_callbacks do
		self.ui_created_callbacks[i](context);
	end;
	
	out.dec_tab();
	out("********************************************************************************");
	out("");
	out.restore_tab();
end;


--- @function add_ui_destroyed_callback
--- @desc Adds a callback to be called when the UI is destroyed.
--- @p function callback
function core_object:add_ui_destroyed_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_ui_destroyed_callback called but supplied callback [" .. tostring(callback) .. "] is not a function");
	end;
	
	table.insert(self.ui_destroyed_callbacks, callback);
end;


-- called when ui is destroyed
function core_object:ui_destroyed(context)

	self.ui_is_created = false;
	self.ui_root = false;

	out.cache_tab();
	out("");
	out("********************************************************************************");
	out("event has occurred:: UIDestroyed");
	out("********************************************************************************");
	out.inc_tab();
	
	for i = 1, #self.ui_destroyed_callbacks do
		self.ui_destroyed_callbacks[i](context);
	end;
	
	out.dec_tab();
	out("********************************************************************************");
	out("");
	out.restore_tab();
end;





----------------------------------------------------------------------------
--- @section Game Configuration
--- @desc Functions that return information about the game.
----------------------------------------------------------------------------

--- @function is_debug_config
--- @desc Returns true if the game is not running in final release or intel configurations, false if the game is running in debug or profile configuration
--- @r boolean is debug config
function core_object:is_debug_config()
	return defined and not (defined.final_release or defined.intel);
end;


--- @function is_tweaker_set
--- @desc Returns whether a boolean tweaker with the supplied name is set. If the tweaker is set to <code>true</code> or <code>false</code> then that value is returned, otherwise @nil is returned.
--- @p @string tweaker name
--- @r @boolean tweaker value (or @nil if not set)
function core_object:is_tweaker_set(tweaker_name)
	local tweaker_value = common.tweaker_value(tweaker_name);
	if tweaker_value == "1" then
		return true;
	elseif tweaker_value == "0" then
		return false;
	end;
end;


--- @function get_screen_resolution
--- @desc Returns the current screen resolution
--- @r integer screen x dimension
--- @r integer screen y dimension
function core_object:get_screen_resolution()
	return self.ui_root:Dimensions();
end;





----------------------------------------------------------------------------
--- @section Game Mode
--- @desc Functions that return the mode the game is currently running in.
----------------------------------------------------------------------------

--- @function is_campaign
--- @desc Returns whether the game is currently in campaign mode
--- @r boolean is campaign
function core_object:is_campaign()
	return __game_mode == __lib_type_campaign;
end;


--- @function is_battle
--- @desc Returns whether the game is currently in battle mode
--- @r boolean is battle
function core_object:is_battle()
	return __game_mode == __lib_type_battle;
end;


--- @function is_frontend
--- @desc Returns whether the game is currently in the frontend
--- @r boolean is battle
function core_object:is_frontend()
	return __game_mode == __lib_type_frontend;
end;








----------------------------------------------------------------------------
--- @section Script Environment
----------------------------------------------------------------------------

--- @function get_env
--- @desc Returns the current global lua function environment. This can be used to force other functions to have global scope.
--- @r @table environment
function core_object:get_env()
	return self.env;
end;









----------------------------------------------------------------------------
--- @section Timer Manager
----------------------------------------------------------------------------


--- @function get_tm
--- @desc Returns a handle to the timer manager created for the current environment.
--- @r @timer_manager timer manager
function core_object:get_tm()
	return self.tm;
end;








----------------------------------------------------------------------------
--- @section File Loading
--- @desc Functions for file loading.
----------------------------------------------------------------------------


--- @function get_scripts_in_directory
--- @desc Get a list of all lua files in the specified folder (relative from the working_data folder)
--- @p @string directory, Directory to search under, relative to working_data. e.g. /script/campaign/
--- @p [opt=false] @boolean include_file_extension, Whether or not to include the script file extension in the returned strings.
--- @r @table List of the names of lua files found in this folder (including file expensions). Returns empty table if none were found.
function core_object:get_scripts_in_directory(directory, include_file_extension)
	include_file_extension = include_file_extension or false;
	local comma_separated_list = common.filesystem_lookup(directory, "*.lua");
	local list_of_scripts = {};
	if comma_separated_list ~= nil then
		-- Separate by comma.
		for substring in string.gmatch(comma_separated_list, "([^,]+)") do
			if not include_file_extension then
				substring = string.sub(substring, 1, -5);
			end;
			table.insert(list_of_scripts, substring);
			
		end;
	end;

	return list_of_scripts;
end









----------------------------------------------------------------------------
--- @section Filesystem
----------------------------------------------------------------------------


--- @function get_filepaths_from_folder
--- @desc Returns a list of all files in a specified folder, conforming to an optional filter. The list is returned as an indexed @table of string file paths.
--- @desc The folder path should be given from the working data folder. If no filter is supplied, then all files are searched for.
--- @p @string folder path, Folder path, from the working data folder.
--- @p [opt="*"] @string filter, File filter.
--- @return @table indexed table of file paths
--- @example local file_paths = core:get_filepaths_from_folder("/script/", "*scripted.lua")
--- @example for i = 1, #file_paths do
--- @example 	out(file_paths[i])
--- @example end
--- @result script\all_scripted.lua
--- @result script\battle_scripted.lua
--- @result script\campaign_scripted.lua
--- @result script\frontend_scripted.lua
function core_object:get_filepaths_from_folder(folder_path, filter)
	if not validate.is_string(folder_path) then
		return;
	end;

	if filter then
		if not validate.is_string(filter) then
			return;
		end;
	else
		filter = "*.*";
	end;

	local file_paths = {};
	local file_str = common.filesystem_lookup(folder_path, filter);

	for file_path in string.gmatch(file_str, '([^,]+)') do
		table.insert(file_paths, file_path);
	end;

	return file_paths;
end;


--- @function load_global_script
--- @desc This function attempts to load a lua script from all folders currently on the path, and, when loaded, sets the environment of the loaded file to match the global environment. This is used when loading scripts within a block (within if statement that is testing for the file's existence, for example) - loading the file with <code>require</code> would not give it access to the global environment.
--- @desc If the script file fails to load cleanly, a script error will be thrown.
--- @p string script name
function core_object:load_global_script(scriptname)

	if not validate.is_string(scriptname) then
		return false;
	end;

	if package.loaded[scriptname] then
		return package.loaded[scriptname];
	end;
	
	local package_path = string.gsub(scriptname, "%.", "/");
	local file = loadfile(package_path);
	
	if file then
		-- the file has been loaded correctly - set its environment, record that it's been loaded, then execute it
		out("Loading script " .. scriptname .. ".lua");
		out.inc_tab();
		
		setfenv(file, self:get_env());
		local lua_module = file(scriptname);
		package.loaded[scriptname] = lua_module or true;
		
		out.dec_tab();
		out(scriptname .. ".lua script loaded");
		return package.loaded[scriptname];
	end;
	
	-- the file was not loaded correctly, however loadfile doesn't tell us why. Here we try and load it again with require which is more verbose
	local success, err_code = pcall(function() require(scriptname) end);

	script_error("ERROR: Tried to load script " .. scriptname .. " without success - either the script is not present or it is not valid. See error below");
	out("*************");
	out("Returned lua error is:");
	out(err_code);
	out("*************");

	return false;
end;












----------------------------------------------------------------------------
--- @section Mod Loading
--- @desc Functions for loading and, in campaign, executing mod scripts. Note that @global:ModLog can be used by mods for output.
----------------------------------------------------------------------------


--- @function load_mods
--- @desc Loads all mod scripts found on each of the supplied paths, setting the environment of every loaded mod to the global environment.
--- @p ... paths, List of @string paths from which to load mods from. The terminating <code>/</code> character must be included.
--- @r @boolean All mods loaded correctly
--- @example core:load_mods("/script/_lib/mod/", "/script/battle/mod/");
function core_object:load_mods(...)

	ModLog("");
	ModLog("****************************");
	ModLog("Loading Mods");
	out.inc_tab();

	local all_mods_loaded_successfully = true;
	local out_str = false;

	for i = 1, arg.n do
		local folder_path = arg[i];

		if not is_string(folder_path) then
			script_error("ERROR: load_mods() called but supplied path [" .. tostring(folder_path) .. "] is not a string");
			out.dec_tab();
			ModLog("****************************");
			ModLog("");
			return false;
		end;

		local file_paths = self:get_filepaths_from_folder(folder_path, "*.lua");

		if #file_paths > 0 then
			package.path = folder_path .. "?.lua;" .. package.path;

			for i = 1, #file_paths do
				local file_path = file_paths[i];

				local mod_load_successful = self:load_mod_script(file_path);
			
				if mod_load_successful then
					ModLog("Mod [" .. tostring(file_path) .. "] loaded successfully");
				else
					ModLog("Failed to load mod: [" .. tostring(file_path) .. "]");
					all_mods_loaded_successfully = false;
				end;

				self:trigger_event("ScriptEventModLoaded", file_path, mod_load_successful);
			end;
		end;
	end;

	out.dec_tab();
	ModLog("****************************");
	ModLog("");

	return all_mods_loaded_successfully;
end;


-- internal function to load an individual mod script
function core_object:load_mod_script(filename)
	local pointer = 1;

	local filename_for_out = filename;
	
	while true do
		local next_separator = string.find(filename, "\\", pointer) or string.find(filename, "/", pointer);
		
		if next_separator then
			pointer = next_separator + 1;
		else
			if pointer > 1 then
				filename = string.sub(filename, pointer);
			end;
			break;
		end;
	end;
	
	local suffix = string.sub(filename, string.len(filename) - 3);
	
	if string.lower(suffix) == ".lua" then
		filename = string.sub(filename, 1, string.len(filename) - 4);
	end;

	-- Avoid loading more than once
	if package.loaded[filename] then
		return false;
	end

	ModLog("Loading mod file [" .. filename_for_out .. "]");
	
	-- Loads a Lua chunk from the file
	local loaded_file, load_error = loadfile(filename);
	
	-- Make sure something was loaded from the file
	if loaded_file then
		-- Mod was loaded successfully - print some output, set its function environment, add it to the list of loaded mods and execute it
		
		-- Set the environment of the Lua chunk to the global environment
		setfenv(loaded_file, self:get_env());
		-- Make sure the file is set as loaded
		package.loaded[filename] = true;
		-- Execute the loaded Lua chunk so the functions within are registered
		out.inc_tab();
		local mod_executed_successfully, execute_error = pcall(loaded_file);
		if not mod_executed_successfully then
			ModLog("Failed to execute loaded mod file [" .. filename_for_out .. "], error is: " .. tostring(execute_error));	
			out.dec_tab();
			return false;
		end;

		out.dec_tab();

		table.insert(self.loaded_mods, filename);

		return true;
	else
		-- Mod was not loaded successfully - print some output
		
		ModLog("\tFailed to load mod file [" .. filename_for_out .. "], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:");

		local require_result, require_error = pcall(require, filename);

		if require_result then
			ModLog("\tWARNING: require() seemed to be able to load file [" .. filename .. "] with filename [" .. filename_for_out .. "], where loadfile failed? Maybe the mod is loaded, maybe it isn't - proceed with caution!");
			return true;
		else
			-- strip tab and newline characters from error string
			ModLog("\t\t" .. string.gsub(string.gsub(require_error, "\t", ""), "\n", ""));
		end;

		return false;
	end;
end;


--- @function execute_mods
--- @desc Attempts to execute a function of the same name as the filename of each mod that has previously been loaded by @core:load_mods. For example, if mods have been loaded from <code>mod_a.lua</code>, <code>mod_b.lua</code> and <code>mod_c.lua</code>, the functions <code>mod_a()</code>, <code>mod_b()</code> and <code>mod_c()</code> will be called, if they exist. This can be used to start the execution of mod scripts at an appropriate time, particularly during campaign script startup.
--- @desc One or more arguments can be passed to <code>execute_mods</code>, which are in-turn passed to the mod functions being executed.
--- @p ... arguments, Arguments to be passed to mod function(s).
--- @r @boolean No errors reported
function core_object:execute_mods(...)

	ModLog("");
	ModLog("****************************");
	ModLog("Executing Mods");
	out.inc_tab();

	local env = self:get_env();

	for i = 1, #self.loaded_mods do
		local current_mod_name = self.loaded_mods[i];

		-- proceed if there's a function with the same name as the mod file
		if is_function(env[current_mod_name]) then
			ModLog("Executing mod function " .. current_mod_name .. "()");
			out.inc_tab();

			-- call the function
			local ok, result = pcall(env[current_mod_name], unpack(arg));

			out.dec_tab();

			if ok then
				ModLog(current_mod_name .. "() executed successfully");
			else
				ModLog("ERROR: " .. current_mod_name .. "() failed while executing with error: " .. result);
			end;

			self:trigger_event("ScriptEventModExecuted", current_mod_name, ok);
		else
			ModLog(current_mod_name .. "() not found, continuing");
		end;
	end;

	out.dec_tab();
	ModLog("****************************");
	ModLog("");
end;


--- @function is_mod_loaded
--- @desc Returns whether a mod with the supplied name is loaded. The path may be omitted.
--- @p @string mod name
--- @r @boolean mod is loaded
function core_object:is_mod_loaded(mod_name)
	local loaded_mods = self.loaded_mods;

	for i = 1, #loaded_mods do
		if loaded_mods[i] == mod_name then
			return true;
		end;
	end;

	return false;
end;











----------------------------------------------------------------------------
--- @section Advice Level
--- @desc Functions concerning the advice level setting, which defaults to 'high' but can be changed by the player.
----------------------------------------------------------------------------

--- @function get_advice_level
--- @desc Returns the current advice level value. A returned value of 0 corresponds to 'minimal', 1 corresponds to 'low', and 2 corresponds to 'high'.
--- @r integer advice level
function core_object:get_advice_level()
	return common.get_advice_level();
end;


--- @function is_advice_level_minimal
--- @desc Returns whether the advice level is currently set to minimal.
--- @r boolean is advice level minimal
function core_object:is_advice_level_minimal()
	return (common.get_advice_level() == 0);
end;


--- @function is_advice_level_low
--- @desc Returns whether the advice level is currently set to low.
--- @r boolean is advice level low
function core_object:is_advice_level_low()
	return (common.get_advice_level() == 1);
end;


--- @function is_advice_level_high
--- @desc Returns whether the advice level is currently set to high.
--- @r boolean is advice level high
function core_object:is_advice_level_high()
	return (common.get_advice_level() == 2);
end;






----------------------------------------------------------------------------
--- @section Scripted Value Registry
--- @desc The scripted value registry is an object supplied by the game to script which can be used to set values that persist over lua sessions. As lua sessions are destroyed/recreated when the game loads from one mode to another (campaign to battle, frontend to campaign etc) the svr makes it possible for scripts to store information for scripts in future sessions to retrieve.
--- @desc This information is cleared when the game as a whole is closed and re-opened, but the scripted value registry also allows boolean values to be saved in the registry. Such values will persist, even between reloads of the game client.
--- @desc The core object automatically creates a handle to the scripted value registry and an interface to it. The following functions can be called to interact with the scripted value registry.
----------------------------------------------------------------------------


--- @function get_svr
--- @desc Returns a handle to the scripted value registry object. It shouldn't be necessary to call this, as the core object provides access to all its functionality through its wrapper functions.
--- @r scripted_value_registry svr
function core_object:get_svr()
	return self.svr;
end;


--- @function svr_save_bool
--- @desc Saves a boolean value to the svr. This will persist as the game loads between modes (campaign/battle/frontend) but will be destroyed if the game is restarted.
--- @p string value name
--- @p boolean value
function core_object:svr_save_bool(name, value)
	if not is_string(name) then
		script_error("ERROR: svr_save_bool() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_boolean(value) then
		script_error("ERROR: svr_save_bool() called but supplied value [" .. tostring(value) .. "] is not boolean");
		return false;
	end;
	
	return self.svr:SaveBool(name, value);
end;


--- @function svr_load_bool
--- @desc Retrieves a boolean value from the svr.
--- @p string value name
--- @r boolean value
function core_object:svr_load_bool(name)
	return self.svr:LoadBool(name);
end;


--- @function svr_save_string
--- @desc Saves a string value to the svr. This will persist as the game loads between modes (campaign/battle/frontend) but will be destroyed if the game is restarted.
--- @p string value name
--- @p string value
function core_object:svr_save_string(name, value)
	if not is_string(name) then
		script_error("ERROR: svr_save_string() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(value) then
		script_error("ERROR: svr_save_string() called but supplied value [" .. tostring(value) .. "] is not string");
		return false;
	end;

	return self.svr:SaveString(name, value);
end;


--- @function svr_load_string
--- @desc Retrieves a string value from the svr.
--- @p string value name
--- @r string value
function core_object:svr_load_string(name)
	return self.svr:LoadString(name);
end;


--- @function svr_save_registry_bool
--- @desc Saves a boolean value to the registry. This will persist, even if the game is reloaded.
--- @p string value name
--- @p boolean value
function core_object:svr_save_registry_bool(name, value)
	if not is_string(name) then
		script_error("ERROR: svr_save_registry_bool() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_boolean(value) then
		script_error("ERROR: svr_save_registry_bool() called but supplied value [" .. tostring(value) .. "] is not boolean");
		return false;
	end;

	return self.svr:SaveRegistryBool(name, value);
end;


--- @function svr_load_registry_bool
--- @desc Loads a boolean value from the registry.
--- @p string value name
--- @r boolean value
function core_object:svr_load_registry_bool(name)
	return self.svr:LoadRegistryBool(name);
end;


--- @function svr_save_registry_string
--- @desc Saves a string value to the registry. This will persist, even if the game is reloaded.
--- @p @string value name
--- @p @string value
function core_object:svr_save_registry_string(name, value)
	if not is_string(name) then
		script_error("ERROR: svr_save_registry_string() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(value) then
		script_error("ERROR: svr_save_registry_string() called but supplied value [" .. tostring(value) .. "] is not string");
		return false;
	end;

	return self.svr:SaveRegistryString(name, value);
end;


--- @function svr_load_registry_string
--- @desc Loads a string value from the registry.
--- @p @string value name
--- @r @string value
function core_object:svr_load_registry_string(name)
	return self.svr:LoadRegistryString(name);
end;


--- @function svr_save_timestamp
--- @desc Records a timestamp with the supplied name. This can be compared to a later timestamp with @core:svr_time_since_timestamp to see how much time has elapsed between two game events. This value is saved into the registry so will survive between game sessions.
--- @desc This can be used to trigger advice if the player has not performed a certain action in game for a given period (e.g. not loaded a campaign in three months), for example.
--- @p @string timestamp name
function core_object:svr_save_timestamp(name)
	if not validate.is_string(name) then
		return false;
	end;

	self.svr:SaveRegistryTimestamp(name);
end;


--- @function svr_time_since_timestamp
--- @desc Returns the number of seconds since a timestamp with the supplied name was last recorded with @core:svr_save_timestamp. If the timestamp has never been recorded then @nil is returned.
--- @p @string timestamp name
--- @r @number seconds since timestamp last recorded
function core_object:svr_time_since_timestamp(name)
	if not validate.is_string(name) then
		return false;
	end;
	
	return self.svr:CompareRegistryTimestamp(name);
end;






----------------------------------------------------------------------------
--- @section Preferences
--- @desc User preferences are stored and listed in <code>%appdata%\The Creative Assembly\&lt;game&gt;\scripts\preferences.script.txt</code>. They may be read and written with the functions below. Different functions must be used for different value types. Preference names and the type of each preference value are shown in the <code>preferences.script.txt</code> file.
----------------------------------------------------------------------------


--- @function get_boolean_preference
--- @desc Returns a boolean preference value. The value is looked up by a string preference name.
--- @p @string preference name
--- @r @boolean preference value
function core_object:get_boolean_preference(preference_name)
	if not validate.is_string(preference_name) then
		return nil;
	end;

	return common.get_context_value("PrefAsBool(\"" .. preference_name .. "\")");
end;


--- @function set_boolean_preference
--- @desc Sets a boolean preference value, by string preference name.
--- @p @string preference name
--- @p @boolean preference value
function core_object:set_boolean_preference(preference_name, value)
	if not validate.is_string(preference_name) or not validate.is_boolean(value) then
		return false;
	end;

	common.call_context_command("SetPrefAsBool(\"" .. preference_name .. "\", " .. tostring(value) .. ")");
end;


--- @function cache_boolean_preference
--- @desc Looks up a boolean preference value by name, stores it in an internal cache, and returns the value. The cached value may be later restored with @core:restore_boolean_preference.
--- @p @string preference name
--- @r @boolean preference value
function core_object:cache_boolean_preference(preference_name)
	local value = self:get_boolean_preference(preference_name);
	
	if is_boolean(value) then
		self.cached_preferences[preference_name] = value;
		return value;
	end;
end;


--- @function cache_and_set_boolean_preference
--- @desc Caches and then sets a boolean preference value. Equivalent to calling @core:cache_boolean_preference and then @core:set_boolean_preference. The value cached by @core:cache_boolean_preference is returned.
--- @p @string preference name
--- @p @boolean new value
--- @r @boolean existing preference value
function core_object:cache_and_set_boolean_preference(preference_name, new_value)
	if not validate.is_boolean(new_value) then
		return false;
	end;
	
	local value = self:cache_boolean_preference(preference_name);
	self:set_boolean_preference(preference_name, new_value);

	return value;
end;


--- @function restore_boolean_preference
--- @desc Looks up a boolean preference value by name from the internal cache and sets the preference to the looked-up value. The value retrieved from the cache is also returned by the function. The preference value must have been written to the cache with @core:cache_boolean_preference beforehand - if no cached value could be found then the preference is not set and @nil is returned.
--- @p @string preference name
--- @r @boolean restored preference value
function core_object:restore_boolean_preference(preference_name)
	local value = self.cached_preferences[preference_name];
	
	if is_boolean(value) then
		self:set_boolean_preference(preference_name, value);
		return value;
	end;
end;


--- @function get_integer_preference
--- @desc Returns an integer preference value. The value is looked up by a string preference name.
--- @p @string preference name
--- @r @number integer preference value
function core_object:get_integer_preference(preference_name)
	if not validate.is_string(preference_name) then
		return nil;
	end;

	return common.get_context_value("PrefAsInt(\"" .. preference_name .. "\")");
end;


--- @function set_integer_preference
--- @desc Sets an integer preference value, by string preference name.
--- @p @string preference name
--- @p @number preference value
function core_object:set_integer_preference(preference_name, value)
	if not validate.is_string(preference_name) or not validate.is_integer(value) then
		return false;
	end;

	common.call_context_command("SetPrefAsInt(\"" .. preference_name .. "\", " .. tostring(value) .. ")");
end;


--- @function cache_integer_preference
--- @desc Looks up an integer preference value by name, stores it in an internal cache, and returns the value. The cached value may be later restored with @core:restore_integer_preference.
--- @p @string preference name
--- @r @number preference value
function core_object:cache_integer_preference(preference_name)
	local value = self:get_integer_preference(preference_name);
	
	if is_integer(value) then
		self.cached_preferences[preference_name] = value;
		return value;
	end;
end;


--- @function cache_and_set_integer_preference
--- @desc Caches and then sets an integer preference value. Equivalent to calling @core:cache_integer_preference and then @core:set_integer_preference. The value cached by @core:cache_integer_preference is returned.
--- @p @string preference name
--- @p @number new value
--- @r @number existing preference value
function core_object:cache_and_set_integer_preference(preference_name, new_value)
	if not validate.is_integer(new_value) then
		return false;
	end;
	
	local value = self:cache_integer_preference(preference_name);
	self:set_integer_preference(preference_name, new_value);

	return value;
end;


--- @function restore_integer_preference
--- @desc Looks up an integer preference value by name from the internal cache and sets the preference to the looked-up value. The value retrieved from the cache is also returned by the function. The preference value must have been written to the cache with @core:cache_integer_preference beforehand - if no cached value could be found then the preference is not set and @nil is returned.
--- @p @string preference name
--- @r @number restored preference value
function core_object:restore_integer_preference(preference_name)
	local value = self.cached_preferences[preference_name];
	
	if is_integer(value) then
		self:set_integer_preference(preference_name, value);
		return value;
	end;
end;


--- @function get_float_preference
--- @desc Returns an float preference value. The value is looked up by a string preference name.
--- @p @string preference name
--- @r @number float preference value
function core_object:get_float_preference(preference_name)
	if not validate.is_string(preference_name) then
		return nil;
	end;

	return common.get_context_value("PrefAsFloat(\"" .. preference_name .. "\")");
end;


--- @function set_float_preference
--- @desc Sets an float preference value, by string preference name.
--- @p @string preference name
--- @p @number preference value
function core_object:set_float_preference(preference_name, value)
	if not validate.is_string(preference_name) or not validate.is_float(value) then
		return false;
	end;

	common.call_context_command("SetPrefAsFloat(\"" .. preference_name .. "\", " .. tostring(value) .. ")");
end;


--- @function cache_float_preference
--- @desc Looks up an float preference value by name, stores it in an internal cache, and returns the value. The cached value may be later restored with @core:restore_float_preference.
--- @p @string preference name
--- @r @number preference value
function core_object:cache_float_preference(preference_name)
	local value = self:get_float_preference(preference_name);
	
	if is_float(value) then
		self.cached_preferences[preference_name] = value;
		return value;
	end;
end;


--- @function cache_and_set_float_preference
--- @desc Caches and then sets a float preference value. Equivalent to calling @core:cache_float_preference and then @core:set_float_preference. The value cached by @core:cache_float_preference is returned.
--- @p @string preference name
--- @p [opt=nil] @number new value
--- @r @number existing preference value
function core_object:cache_and_set_float_preference(preference_name, new_value)
	if not validate.is_number(new_value) then
		return false;
	end;
	
	local value = self:cache_float_preference(preference_name);
	self:set_float_preference(preference_name, new_value);

	return value;
end;


--- @function restore_float_preference
--- @desc Looks up an float preference value by name from the internal cache and sets the preference to the looked-up value. The value retrieved from the cache is also returned by the function. The preference value must have been written to the cache with @core:cache_float_preference beforehand - if no cached value could be found then the preference is not set and @nil is returned.
--- @p @string preference name
--- @r @number restored preference value
function core_object:restore_float_preference(preference_name)
	local value = self.cached_preferences[preference_name];
	
	if is_float(value) then
		self:set_float_preference(preference_name, value);
		return value;
	end;
end;







----------------------------------------------------------------------------
--- @section Lookup Listeners
--- @desc For script events which are triggered often and in which many client scripts might be interested in listening for, such as <code>FactionTurnStart</code> in campaign or <code>ComponentLClickUp</code> across the game, it's common for client scripts to test the context of that event against a known value (e.g. does the faction have this string key or does the component have this string name) and to only proceed if there's a match. With many listeners all listening for the same common event, these tests can become more and more expensive.
--- @desc The lookup listener system is designed to alleviate this. It allows for downstream systems such as the @campaign_manager to declare lookup listeners for events like <code>FactionTurnStart</code>, which listen for that event, query the faction name or any other static value and then look up and trigger listeners that have subscribed to that event and lookup key combination. This is much more computationally efficient than having many listeners all running their own individual tests each time the event is triggered.
--- @desc Such a listener system may be set up by calling @core:declare_lookup_listener. Client scripts can then register a callback with @core:add_lookup_listener_callback, although it may be beneficial to set up wrappers for this functionality (see @campaign_manager:add_faction_turn_start_listener_by_name for an example). @core:remove_lookup_listener_callback can be called to remove listeners by name.
--- @new_example Declares a lookup listener that triggers listeners by faction name
--- @example core:declare_lookup_listener(
--- @example 	"faction_turn_start_faction_name",
--- @example 	"FactionTurnStart",
--- @example 	function(context) return context:faction():name() end
--- @example );
--- @example 
--- @example -- adds a listener entry to the declared lookup listener
--- @example -- to trigger when wh_main_emp_empire starts a turn
--- @example core:add_lookup_listener_callback(
--- @example 	"faction_turn_start_faction_name",
--- @example 	"test",
--- @example 	"wh_main_emp_empire",
--- @example 	function() out("Empire are starting a turn") end,
--- @example 	true
--- @example );

----------------------------------------------------------------------------


-- internal function to get a callback from a set of callback records that includes one or more non-persistent records
local function get_callbacks_for_key_from_transient_list(callback_records)
	local callbacks_to_call = {};
	local new_callback_records = {};

	for i = 1, #callback_records do
		local current_callback_record = callback_records[i];
		if current_callback_record.persistent then
			table.insert(new_callback_records, current_callback_record);
		else
			-- Record in the __listener_names list that we're losing one record with this listener name
			callback_records.__listener_names[current_callback_record.listener_name] = callback_records.__listener_names[current_callback_record.listener_name] - 1;
		end;
		table.insert(callbacks_to_call, current_callback_record.callback);
	end;

	new_callback_records.__listener_names = callback_records.__listener_names;
	new_callback_records.__are_any_listeners_transient = false;

	return callbacks_to_call, new_callback_records;
end;


-- internal function to get a callback from a set of callback records that includes only persistent records
local function get_callbacks_for_key_from_persistent_list(callback_records)
	local callbacks_to_call = {};
	for i = 1, #callback_records do
		table.insert(callbacks_to_call, callback_records[i].callback);
	end;
	return callbacks_to_call;
end;


-- internal function to process a lookup listener event when it occurs
local function process_lookup_listener_callback(context, test, lookup_listener_callback_list)
	-- Call the supplied test function with the event context to get a lookup key, which we then use to get a list
	-- of callback records of callbacks we need to call
	local lookup_key = test(context);
	local callback_records = lookup_listener_callback_list[lookup_key];

	if not callback_records then
		return;
	end;

	-- If there are any callback records marked as transient in this list (i.e. they trigger once and are then removed)
	-- then we will need to reconstruct the callback records list without them afterwards
	local callbacks_to_call;
	if callback_records.__are_any_listeners_transient then
		local new_callback_records;
		callbacks_to_call, new_callback_records = get_callbacks_for_key_from_transient_list(callback_records);
		lookup_listener_callback_list[lookup_key] = new_callback_records;
	else
		callbacks_to_call = get_callbacks_for_key_from_persistent_list(callback_records);
	end;

	-- Call the callbacks
	for i = 1, #callbacks_to_call do
		callbacks_to_call[i](context);
	end;
end


--- @function declare_lookup_listener
--- @desc Declares a new lookup listener, which listens for the supplied event and then calls listener records based on the key generated by the supplied test function. The test function will be called when the event is received and will be passed the event context. It should return a value which can be used to look up listeners added with @core:add_lookup_listener_callback.
--- @desc See the section documentation @"core:Lookup Listeners" for an example of usage.
--- @p @string list name, Unique list name.
--- @p @string event name, Script event to listen for.
--- @p @function test, Conditional test to perform on the function context. This must return a value.
function core_object:declare_lookup_listener(list_name, event_name, test)

	if not is_string(list_name) then
		script_error("ERROR: declare_lookup_listener() called but supplied list name [" .. tostring(list_name) .. "] is not a string");
		return false;
	end;

	if self.all_lookup_listener_lists[list_name] then
		script_error("ERROR: declare_lookup_listener() called but a list with supplied list name [" .. list_name .. "] has already been declared");
		return false;
	end;

	if not is_string(event_name) then
		script_error("ERROR: declare_lookup_listener() called but supplied event name [" .. tostring(event_name) .. "] is not a string");
		return false;
	end;

	if not is_function(test) then
		script_error("ERROR: declare_lookup_listener() called but supplied lookup test [" .. tostring(test) .. "] is not a function");
		return false;
	end;

	local lookup_listener_callback_list = {};

	-- These aren't used but can be useful for debugging
	lookup_listener_callback_list.list_name = list_name;
	lookup_listener_callback_list.event_name = event_name;

	self.all_lookup_listener_lists[list_name] = lookup_listener_callback_list;

	self:add_listener(
		"lookup_listener_" .. event_name,
		event_name,
		true,
		function(context)
			process_lookup_listener_callback(context, test, lookup_listener_callback_list)
		end,
		true
	);
end;


--- @function add_lookup_listener_callback
--- @desc Adds a listener entry to a lookup listener previously declared with @core:declare_lookup_listener. This specifies a lookup value which, should it match the value produced by the test specified when the lookup listener was declared, will cause the supplied callback to be called.
--- @desc See the section documentation @"core:Lookup Listeners" for an example of usage.
--- @p @string list name, Lookup listener to add this listener entry to. This should match the name passed to @core:declare_lookup_listener.
--- @p @string listener name, Listener name, by which this listener entry may later be removed with @core:remove_lookup_listener_callback if desired. It is valid to have multiple listeners with the same name.
--- @p value lookup value, Lookup value. If, when the test function supplied to @core:declare_lookup_listener is called it returns this value, then the callback for this listener will be called. The value given here can be any type.
--- @p @function callback, Callback to call if the lookup value is matched.
--- @p @boolean persistent, Is this a persistent listener. If <code>false</code> is specified here the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @core:remove_lookup_listener_callback.
function core_object:add_lookup_listener_callback(list_name, listener_name, lookup_value, callback, persistent)

	if not is_string(list_name) then
		script_error("ERROR: add_lookup_listener_callback() called but supplied list name [" .. tostring(list_name) .. "] is not a string");
		return false;
	end;
	
	local lookup_listener_callback_list = self.all_lookup_listener_lists[list_name];

	if not lookup_listener_callback_list then
		script_error("ERROR: add_lookup_listener_callback() called but no callback list with supplied list name [" .. list_name .. "] could be found. Lists must be declared with declare_lookup_listener() before callbacks can be added");
		return false;
	end;

	if not is_string(listener_name) then
		script_error("ERROR: add_lookup_listener_callback() called but supplied listener name [" .. tostring(listener_name) .. "] is not a string");
		return false;
	end;

	if not lookup_value then
		script_error("ERROR: add_lookup_listener_callback() called but no lookup value was supplied");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: add_lookup_listener_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	-- If we have no existing entry for the supplied lookup value then create a table
	local callback_records = lookup_listener_callback_list[lookup_value];
	
	if not callback_records then
		callback_records = {};
		callback_records.__listener_names = {};
		callback_records.__are_any_listeners_transient = false;
		lookup_listener_callback_list[lookup_value] = callback_records;
	end;

	-- Insert a record for our callback
	table.insert(
		callback_records,
		{
			listener_name = listener_name,
			callback = callback,
			persistent = persistent
		}
	);

	-- Record in the __listener_names table of the lookup listener list that we have another listener
	-- with the supplied name. Doing this allows us to optimise the process of removing listeners.
	local listener_names = callback_records.__listener_names;

	if listener_names[listener_name] then
		listener_names[listener_name] = listener_names[listener_name] + 1;
	else
		listener_names[listener_name] = 1;
	end;

	-- Make a note if this listener is transient - this is used when a callback occurs
	if not persistent then
		callback_records.__are_any_listeners_transient = true;
	end;
end;


--- @function remove_lookup_listener_callback
--- @desc Removes any listener entries from the specified lookup listener that match the supplied name.
--- @p @string list name, Lookup listener to remove listener entries from.
--- @p @string listener name, Name of listener to remove. This corresponds with the listener name specified when @core:add_lookup_listener_callback is called.
function core_object:remove_lookup_listener_callback(list_name, listener_name)
	if not is_string(list_name) then
		script_error("ERROR: add_lookup_listener_callback() called but supplied list name [" .. tostring(list_name) .. "] is not a string");
		return false;
	end;
	
	local lookup_listener_callback_list = self.all_lookup_listener_lists[list_name];

	if not lookup_listener_callback_list then
		script_error("ERROR: add_lookup_listener_callback() called but no callback list with supplied list name [" .. list_name .. "] could be found. Lists must be declared with declare_lookup_listener() before callbacks can be added");
		return false;
	end;

	if not is_string(listener_name) then
		script_error("ERROR: add_lookup_listener_callback() called but supplied listener name [" .. tostring(listener_name) .. "] is not a string");
		return false;
	end;

	local modifications = {};

	-- Look through all callback records associated with this list
	for lookup_key, callback_records in pairs(lookup_listener_callback_list) do
		if callback_records.__listener_names and callback_records.__listener_names[listener_name] and callback_records.__listener_names[listener_name] > 0 then
			-- We will re-assemble this callback list to avoid using table.remove
			local new_callback_records = {};
			local __are_any_listeners_transient = false;
			
			for i = 1, #callback_records do
				local current_callback_record = callback_records[i];
				if current_callback_record.listener_name ~= listener_name then
					table.insert(new_callback_records, current_callback_record);
					if not current_callback_record.persistent then
						__are_any_listeners_transient = true;
					end;
				end;
			end;

			-- Set the number of listeners registered with the supplied name to 0 as we're removing them all
			callback_records.__listener_names[listener_name] = nil;

			-- Copy the old listener names table to the new callback records table
			new_callback_records.__listener_names = callback_records.__listener_names;

			-- Set the any_listeners_transient flag to the new computed value
			new_callback_records.__are_any_listeners_transient = __are_any_listeners_transient;

			-- Don't alter the list as we're iterating through it, instead write the modifications to a separate table
			modifications[lookup_key] = new_callback_records;
		end;
	end;

	-- Actually apply the modifications
	for lookup_key, new_callback_records in pairs(modifications) do
		lookup_listener_callback_list[lookup_key] = new_callback_records;
	end;
end;












----------------------------------------------------------------------------
--- @section Fullscreen Highlighting
--- @desc A fullscreen highlight is an effect where the screen is masked out with a semi-opaque layer on top, save for a window cut out through which the game interface can be seen. This can be used by tutorial scripts to draw the player's attention to a particular part of the screen. The fullscreen highlight prevents the player from clicking on those portions of the screen that are masked off.
--- @desc A fullscreen highlight effect may be established around a supplied set of components with <code>show_fullscreen_highlight_around_components()</code>. Once established, a fullscreen highlight effect must be destroyed with <code>hide_fullscreen_highlight()</code>.
--- @desc This fullscreen highlight functionality wraps the FullscreenHighlight functionality provided by the underlying UI code. It's recommended to use this wrapper rather than calling the code functions directly.
----------------------------------------------------------------------------

--- @function show_fullscreen_highlight_around_components
--- @desc Shows a fullscreen highlight around a supplied component list. Once established, this highlight must later be destroyed with <code>hide_fullscreen_highlight()</code>.
--- @desc An integer padding value must be supplied, which specifies how much visual padding to give the components. The higher the supplied value, the more space is given around the supplied components visually.
--- @desc The underlying FullscreenHighlight functionality supports showing text on the fullscreen highlight itself. If you wish to specify some text to be shown, it may be supplied using the second parameter in the common localised text format <code>[table]_[field_of_text]_[key_from_table]</code>.
--- @p number padding, Padding value, must be 0 or greater
--- @p [opt=nil] string highlight text, Highlight text key, may be nil.
--- @p [opt=false] boolean allow interaction, Allows the components in the central window to be interacted with.
--- @p ... uicomponent list
function core_object:show_fullscreen_highlight_around_components(padding, highlight_text, allow_window_interaction, ...)

	if not is_number(padding) or padding < 0 then
		script_error("ERROR: show_fullscreen_highlight_around_components() called but supplied padding value [" .. tostring(padding) .. "] is not a positive number");
		return false;
	end;
	
	if highlight_text and not is_string(highlight_text) then
		script_error("ERROR: show_fullscreen_highlight_around_components() called but supplied highlight text key [" .. tostring(highlight_text) .. "] is not a string or nil/false");
		return false;
	end;
		
	-- work out the min/max bounds of the highlight we are to show
	local min_x = 10000000;
	local min_y = 10000000;
	local max_x = 0;
	local max_y = 0;
	
	for i = 1, arg.n do
		local current_component = arg[i];
		
		if not is_uicomponent(current_component) then
			script_error("ERROR: show_fullscreen_highlight_around_components() called but parameter " .. i .. " in supplied list is a [" .. tostring(current_component) .. "] and not a uicomponent");
			return false;
		end;
		
		local current_min_x, current_min_y = current_component:Position();
		local size_x, size_y = current_component:Dimensions();
		
		local current_max_x = current_min_x + size_x;
		local current_max_y = current_min_y + size_y;
		
		if current_min_x < min_x then
			min_x = current_min_x;
		end;
		
		if current_min_y < min_y then
			min_y = current_min_y;
		end;
		
		if current_max_x > max_x then
			max_x = current_max_x;
		end;
		
		if current_max_y > max_y then
			max_y = current_max_y;
		end;
	end;
	
	-- apply padding
	min_x = min_x - padding;
	min_y = min_y - padding;
	max_x = max_x + padding;
	max_y = max_y + padding;
	
	-- create the dummy component if we don't already have one lurking around somewhere
	local ui_root = self:get_ui_root();
	
	local uic_dummy = find_uicomponent(ui_root, "highlight_dummy");
	
	if not uic_dummy then
		ui_root:CreateComponent("highlight_dummy", self.path_to_dummy_component);
		uic_dummy = find_uicomponent(ui_root, "highlight_dummy");
	end;
	
	if not uic_dummy then
		script_error("ERROR: highlight_component_table() cannot find uic_dummy, how can this be?");
		return false;
	end;

	out.design("Creating fullscreen highlight from [" .. min_x .. ", " .. min_y .. "] to [" .. max_x .. ", " .. max_y .. "]");
	
	-- resize and move the dummy
	local size_x = max_x - min_x;
	local size_y = max_y - min_y;
	
	uic_dummy:MoveTo(min_x, min_y);
	uic_dummy:Resize(size_x, size_y);
	
	local new_pos_x, new_pos_y = uic_dummy:Position();
		
	if not highlight_text or highlight_text == "" then
		uic_dummy:FullScreenHighlight("", false);
	else
		uic_dummy:FullScreenHighlight(highlight_text, false);
	end;
	
	-- fullscreen highlights should be non-interactive by default
	self:set_fullscreen_highlight_interactive(false);
	
	-- make the central window interactive or not depending upon the allow_window_interaction flag
	if allow_window_interaction then
		self:set_fullscreen_highlight_window_interactive(false);
	else
		self:set_fullscreen_highlight_window_interactive(true);
	end;
		
	-- stop help page highlighting and disable UI toggling
	if self:is_campaign() then
		local cm = get_cm();
		
		if cm:is_ui_hiding_enabled() then
			cm:enable_ui_hiding(false);
			self.enable_ui_hiding_on_hide_fullscreen_highlight = true;
		else
			self.enable_ui_hiding_on_hide_fullscreen_highlight = false;
		end;		
		
		cm:get_campaign_ui_manager():override("help_page_link_highlighting"):set_allowed(false);
	elseif self:is_battle() then		
		if bm:is_ui_hiding_enabled() then
			bm:enable_ui_hiding(false);
			self.enable_ui_hiding_on_hide_fullscreen_highlight = true;
		else
			self.enable_ui_hiding_on_hide_fullscreen_highlight = false;
		end;
		
		buim:set_help_page_link_highlighting_permitted(false);
	end;
end;


--- @function hide_fullscreen_highlight
--- @desc Hides/destroys the active fullscreen highlight.
function core_object:hide_fullscreen_highlight()
	local uic_fh = find_uicomponent(self:get_ui_root(), "fullscreen_highlight");
	
	if uic_fh then
		uic_fh:Destroy();
	end;
	
	-- allow help page highlighting and UI toggling to work again
	if self:is_campaign() then
		local cm = get_cm();
		cm:get_campaign_ui_manager():override("help_page_link_highlighting"):set_allowed(true);
		
		if self.enable_ui_hiding_on_hide_fullscreen_highlight then
			cm:enable_ui_hiding(true);
		end;
	elseif self:is_battle() then
		buim:set_help_page_link_highlighting_permitted(true);
		
		if self.enable_ui_hiding_on_hide_fullscreen_highlight then
			bm:enable_ui_hiding(true);
		end;
	end;
end;


--- @function set_fullscreen_highlight_interactive
--- @desc Sets the active fullscreen highlight to be interactive. An interactive fullscreen highlight will respond to clicks. By default fullscreen highlights are non-interactive, but the functionality to make them interactive is provided here in case it's needed.
--- @p [opt=true] boolean value
function core_object:set_fullscreen_highlight_interactive(value)

	local uic_fh = find_uicomponent(self:get_ui_root(), "fullscreen_highlight");
	
	if not uic_fh then
		script_error("WARNING: set_fullscreen_highlight_interactive() called but could not find fullscreen highlight window component. This function needs to be called after the highlight is created");
		return false;
	end;
	
	if value == false then
		uic_fh:SetInteractive(false);
	else
		uic_fh:SetInteractive(true);
	end;
end;


--- @function set_fullscreen_highlight_window_interactive
--- @desc Sets the active fullscreen highlight to be interactive. An interactive fullscreen highlight will respond to clicks. By default fullscreen highlights are non-interactive, but the functionality to make them interactive is provided here in case it's needed.
--- @p [opt=true] boolean value
function core_object:set_fullscreen_highlight_window_interactive(value)
	
	local uic_fill = find_uicomponent(self:get_ui_root(), "fullscreen_highlight", "fill");
	
	if not uic_fill then
		script_error("WARNING: set_fullscreen_highlight_window_interactive() called but could not find fullscreen highlight window component. This function needs to be called after the highlight is created");
		return false;
	end;
	
	if value == false then
		uic_fill:SetInteractive(false);
	else
		uic_fill:SetInteractive(true);
	end;
end;














----------------------------------------------------------------------------
--- @section Advisor Priority Cache
--- @desc Functionality to set and reset the advisor UI priority, which determines at what level the advisor is displayed (i.e. on top of/underneath other components). This is useful during tutorial scripting when the ui priority of other elements on the screen (particularly fullscreen highlighting) has been modified, or is otherwise interfering with the visibility of the advisor.
----------------------------------------------------------------------------

--- @function cache_and_set_advisor_priority
--- @desc Sets the advisor priority to the supplied value, and caches the value previously set. The advisor priority can later be restored with <code>restore_advisor_priority</code>.
--- @desc The register_topmost flag can also be set to force the advisor to topmost.
function core_object:cache_and_set_advisor_priority(new_priority, register_topmost)
	if not is_number(new_priority) then
		script_error("ERROR: cache_and_set_advisor_priority() called but supplied priority [" .. tostring(new_priority) .."] is not a number");
		return false;
	end;

	local ui_root = self.ui_root;
		
	-- cache the current advisor priority and set it to its new value
	local uic_advisor = find_uicomponent(ui_root, "advice_interface");
	if uic_advisor then
		self.cached_advisor_priority = uic_advisor:Priority();
		uic_advisor:PropagatePriority(new_priority);
		ui_root:Adopt(uic_advisor:Address());
		
		if register_topmost then
			uic_advisor:RegisterTopMost();
			self.cached_advisor_topmost = true;
		end;
	end;
	
	-- ditto objectives panel
	--[[
	local uic_objectives = find_uicomponent(ui_root, "scripted_objectives_panel");
	if uic_objectives then
		self.cached_objectives_priority = uic_objectives:Priority();
		uic_objectives:PropagatePriority(new_priority);
		ui_root:Adopt(uic_objectives:Address());
	end;
	]]
end;


--- @function restore_advisor_priority
--- @desc Restores the advisor priority to a value previously cached with <code>cache_and_set_advisor_priority</code>.
function core_object:restore_advisor_priority()
	if self.cached_advisor_priority == -1 then
		script_error("WARNING: restore_advisor_priority() called but advisor priority hasn't been previously cached with cache_and_set_advisor_priority() - be sure to call that first");
		return false;
	end;
	
	local ui_root = core:get_ui_root();
	
	local uic_advisor = find_uicomponent(ui_root, "advice_interface");
	if uic_advisor then
		
		if self.cached_advisor_topmost then
			self.cached_advisor_topmost = false;
			uic_advisor:RemoveTopMost();
		end;
	
		uic_advisor:PropagatePriority(self.cached_advisor_priority);
		ui_root:Adopt(uic_advisor:Address());
	end;
	
	--[[
	local uic_objectives = find_uicomponent(ui_root, "scripted_objectives_panel");
	if uic_objectives then
		uic_objectives:PropagatePriority(self.cached_objectives_priority);
		ui_root:Adopt(uic_objectives:Address());
	end;
	]]
end;





----------------------------------------------------------------------------
--- @section UIComponent Creation
----------------------------------------------------------------------------

--- @function get_or_create_component
--- @desc Creates a UI component with the supplied name, or retrieves it if it's already been created.
--- @p string name, Name to give uicomponent.
--- @p string file path, File path to uicomponent layout, from the working data folder.
--- @p [opt=ui_root] uicomponent parent, Parent uicomponent.
--- @r uicomponent created or retrieved uicomponent
--- @r boolean uicomponent was created
--- @example uic_skip_button = core:get_or_create_component("scripted_tour_skip_button", "UI/Common UI/scripted_tour_skip_button.twui.xml")
function core_object:get_or_create_component(name, path, uic_parent)
	if not is_string(name) then
		script_error("ERROR: get_or_create_component() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(path) then
		script_error("ERROR: get_or_create_component() called but supplied path [" .. tostring(path) .. "] is not a string");
		return false;
	end;

	if uic_parent and not is_uicomponent(uic_parent) then
		script_error("ERROR: get_or_create_component() called but supplied uic_parent [" .. tostring(uic_parent) .. "] is not a uicomponent");
		return false;
	end;
	
	uic_parent = uic_parent or core:get_ui_root();
	
	for i = 0, uic_parent:ChildCount() - 1 do
		local uic_child = UIComponent(uic_parent:Find(i));
		
		if uic_child:Id() == name then
			return uic_child, false;
		end;
	end;
	
	return UIComponent(uic_parent:CreateComponent(name, path)), true;
end;







----------------------------------------------------------------------------
---	@section Event Handling
--- @desc The core object provides a wrapper interface for client scripts to listen for events triggered by the game code, which is the main mechanism by which the game sends messages to script.
----------------------------------------------------------------------------


--- @function add_listener
--- @desc Adds a listener for an event. When the code triggers this event, and should the optional supplied conditional test pass, the core object will call the supplied target callback with the event context as a single argument.
--- @desc A name must be specified for the listener which may be used to cancel it at any time. Names do not have to be unique between listeners.
--- @desc The conditional test should be a function that returns a boolean value. This conditional test callback is called when the event is triggered, and the listener only goes on to trigger the supplied target callback if the conditional test returns true. Alternatively, a boolean <code>true</code> value may be given in place of a conditional callback, in which case the listener will always go on to call the target callback if the event is triggered.
--- @desc Once a listener has called its callback it then shuts down unless the persistent flag is set to true, in which case it may only be stopped by being cancelled by name.
--- @p string listener name
--- @p string event name
--- @p function conditional test, Conditional test, or <code>true</code> to always pass
--- @p function target callback
--- @p boolean listener persists after target callback called
function core_object:add_listener(new_name, new_event, new_condition, new_callback, new_persistent)
	if not is_string(new_name) then
		script_error("ERROR: event_handler:add_listener() called but name given [" .. tostring(new_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(new_event) then
		script_error("ERROR: event_handler:add_listener() called but event given [" .. tostring(new_event) .. "] is not a string");
		return false;
	end;
	
	if not is_function(new_condition) and not (is_boolean(new_condition) and new_condition == true) then
		script_error("ERROR: event_handler:add_listener() called but condition given [" .. tostring(new_condition) .. "] is not a function or true");
		return false;
	end;
	
	if not is_function(new_callback) then
		script_error("ERROR: event_handler:add_listener() called but callback given [" .. tostring(new_callback) .. "] is not a function");
		return false;
	end;
	
	local new_persistent = new_persistent or false;
	
	-- attach to the event if we're not already
	self:attach_to_event(new_event);
	
	local new_listener = {
		name = new_name,
		event = new_event,
		condition = new_condition,
		callback = new_callback,
		persistent = new_persistent,
		callstack = debug.traceback(),
		to_remove = false
	};
	
	table.insert(self.event_listeners[new_event], new_listener);	
end;


-- Calls an event callback in protected mode and acts on the result
local function event_protected_callback(eventname, listener_record, context, call_event_condition)
	local condition_result, call_succeeded, error;

	local call_succeeded, error, traceback;

	local function error_handler(err)
		error = err;
		traceback = debug.traceback("", 2);
	end;

	if call_event_condition then
		call_succeeded = xpcall(function() condition_result = listener_record.condition(context) end, error_handler);
	else
		call_succeeded = xpcall(function() listener_record.callback(context) end, error_handler);
	end;

	if call_succeeded then
		return condition_result;
	end;

	local error_str = "ERROR - SCRIPT HAS FAILED - event " .. (call_event_condition and "condition" or "callback") .. " was called after receiving event [" .. eventname .. "] but the script failed with this error message:\n" .. error

	if core:is_campaign() then
		cm:log_event_error(eventname, error, traceback, listener_record.callstack, call_event_condition);
		cm:set_script_state("SCRIPT_FAILED_THIS_SESSION", true)
		cm:draw_2d_text(error_str, 50, 50, 20, 255, 0, 0)
	end;

	script_error(error_str .. "\n\nThe callstack of the failed script is:\n" .. traceback .. "\n\nThe callstack of the script which established the failed listener is:\n" .. listener_record.callstack, -1);
end;


-- event callback
-- an event has occured, work out who to notify
function core_object:event_callback(eventname, context)
	-- self:list_events();
	
	-- make a list of callbacks to fire and listeners to remove. We can't call the callbacks whilst
	-- processing the list because the callbacks may alter the list length, and we can't rescan because
	-- this will continually hit persistent callbacks
	local callbacks_to_call = {};
	local listeners = self.event_listeners[eventname];

	local should_rebuild = false;

	for i = 1, #listeners do
		local current_listener = listeners[i];
		
		if current_listener.condition == true or event_protected_callback(eventname, current_listener, context, true) then			
			table.insert(callbacks_to_call, current_listener);
			
			if not current_listener.persistent then
				-- mark this listener to be removed post-list
				current_listener.to_remove = true;
				should_rebuild = true;
			end;
		end;
	end;
	
	-- clean out all the listeners that have been marked for removal
	if should_rebuild then
		local new_listeners = {};

		for i = 1, #listeners do
			if not listeners[i].to_remove then
				table.insert(new_listeners, listeners[i]);
			end;
		end;

		self.event_listeners[eventname] = new_listeners;
	end;
	
	if not self.show_performance_report then
		for i = 1, #callbacks_to_call do
			event_protected_callback(eventname, callbacks_to_call[i], context, false);
		end;
	else
		local max_permitted_interval = 0.1;
		local passed_performance_check = self:monitor_performance(
			function()
				for i = 1, #callbacks_to_call do
					local callback_to_call_record = callbacks_to_call[i];
					
					local pre_callback_time = os.clock();
					
					callback_to_call_record.callback(context);
					
					callback_to_call_record.processing_time = os.clock() - pre_callback_time;
				end;
			end,
			max_permitted_interval,
			eventname
		);
		
		if not passed_performance_check and self.show_performance_report then
			out("");
			out("************************************************************************************************************************");
			out("* PERFORMANCE REPORT - this is associated with the performance warning that should have appeared prior to this message");
			out("* Event " .. eventname .. " has triggered and " .. #callbacks_to_call .. " triggered callbacks took longer than " .. max_permitted_interval .. " to finish");
			for i = 1, #callbacks_to_call do
				out("***");
				out("triggered callback " .. i .. " with the following callstack took " .. callbacks_to_call[i].processing_time .. "s to trigger:");
				out(callbacks_to_call[i].callstack);
				out("");
			end;
			out("************************************************************************************************************************");
		end;
	end;
end;


-- Attach a listener to an event we're not already listening for.
-- By attaching to an event we are registering a callback that will call
-- core:event_callback() when the event is triggered
function core_object:attach_to_event(eventname)

	if self.attached_events[eventname] then
		-- we're already attached, so return
		return;
	end;

	-- we're not attached, so attach
	self.attached_events[eventname] = true;

	-- create a table in events for this event if one is not already established
	if not events[eventname] then
		events[eventname] = {};
	end;

	-- create a table in self.event_listeners if one is not already established
	if not self.event_listeners[eventname] then
		self.event_listeners[eventname] = {};
	end;

	self.add_func(eventname, function(context) self:event_callback(eventname, context) end);
end;


-- go through all the listeners and remove those with the to_remove flag set
function core_object:clean_listeners(eventname)
	-- rebuild the relevant event_listeners subtable without the old event listeners
	local new_event_listeners = {};
	local event_listeners = self.event_listeners[eventname];

	for i = 1, #event_listeners do
		if not event_listeners[i].to_remove then
			table.insert(new_event_listeners, event_listeners[i]);
		end;
	end;

	self.event_listeners[eventname] = new_event_listeners;
end;


--- @function remove_listener
--- @desc Removes and stops any event listeners with the specified name.
--- @p string listener name
function core_object:remove_listener(name_to_remove)
	for event_name, listeners in pairs(self.event_listeners) do
		for i = #listeners, 1, -1 do
			if listeners[i].name == name_to_remove then
				table.remove(listeners, i);
			end;
		end;
	end;
end;


-- list current event listeners, for debug purposes
function core_object:list_events()
	print("**************************************");
	print("**************************************");
	print("**************************************");
	print("Event Handler attached events");
	print("**************************************");

	for eventname in pairs(self.attached_events) do
		print("\tname:\t\t" .. eventname);
	end;

	print("**************************************");
	print("Event Handler listeners");
	print("**************************************");
	
	for event_name, listeners in pairs(self.event_listeners) do
		for i = 1, #listeners do
			local l = listeners[i];
			print(i .. ":\tname:" .. tostring(l.name) .. "\tevent:" .. tostring(l.event) .. "\tcondition:" .. tostring(l.condition) .. "\tcallback:" .. tostring(l.callback) .. "\tpersistent:" .. tostring(l.persistent));
		end;
	end;
	
	print("**************************************");
end;


--- @function trigger_event
--- @desc Triggers an event from script, to which event listeners will respond. An event name must be specified, as well as zero or more items of data to package up in a custom event context. See @custom_context documentation for information about what types of data may be supplied with a custom context. A limitation of the implementation means that only one data item of each supported type may be specified.
--- @desc By convention, the names of events triggered from script are prepended with "ScriptEvent" e.g. "ScriptEventPlayerFactionTurnStart".
--- @p string event name
--- @p ... context data items
function core_object:trigger_event(event, ...)
	
	-- build an event context
	local context = custom_context:new();
	
	for i = 1, arg.n do
		local current_obj = arg[i];
	
		-- if this is a proper context object, pass it through directly
		if is_eventcontext(current_obj) then
		
			if arg.n > 1 then
				script_error("WARNING: trigger_event() was called with multiple objects to pass through on the event context, yet one of them was a proper event context - the rest will be discarded");
			end;
			
			context = current_obj;
			break;
		end;
	
		context:add_data(current_obj);
	end;
	
	-- trigger the event with the context
	local event_table = events[event];
	
	if event_table then
		for i = 1, #event_table do
			event_table[i](context);
		end;
	end;
end;


--- @function trigger_custom_event
--- @desc Triggers an event from script with a context object constructed from custom data. An event name must be specified, as well as a table containing context data at key/value pairs. For keys that are strings, the value corresponding to the key will be added to the @custom_context generated, and will be available to listening scripts through a function with the same name as the key value. An example might be a hypothetical event <code>ScriptEventCharacterInfected</code>, with a key <code>disease</code> and a value which is the name of the disease. This would be accessible to listeners of this event that call <code>context:disease()</code>.
--- @desc Should the key not be a string then the data is added to the context as normal, as if supplied to @custom_context:add_data.
--- @desc By convention, the names of events triggered from script are prepended with "ScriptEvent" e.g. "ScriptEventPlayerFactionTurnStart".
--- @p @string event name
--- @p @table data items
function core_object:trigger_custom_event(event, context_data)

	if not is_string(event) then
		script_error("ERROR: trigger_custom_event() called but supplied event name [" .. tostring(event) .. "] is not a string");
		return false;
	end;

	if not is_table(context_data) then
		script_error("ERROR: trigger_custom_event() called but supplied context data [" .. tostring(context_data) .. "] is not a table");
		return false;
	end;

    -- build an event context
	local context = custom_context:new();
	
	for key, value in pairs(context_data) do
		if is_eventcontext(value) then
			script_error("WARNING: trigger_custom_event() was called with a proper event context - any other values will be discarded. Use trigger_event() instead");
            context = value;
			break;
		end;

		if not is_string(key) then
			-- the key is not a string, so just add the data as if a key wasn't specified
			context:add_data(value);
		else
			-- add the value with the key
			context:add_data_with_key(value, key);
		end;
	end;

	local event_table = events[event];
    
    if event_table then
        for i = 1, #event_table do
            event_table[i](context);
        end;
    end;
end;











----------------------------------------------------------------------------
---	@section Custom Event Generator
--- @desc A custom event generator is a simple listener that listens for event, tests a condition, and if the condition passes triggers a target event with some optional context data. Performance and code re-use can be improved by setting up a custom event generator rather than having lots of instances of client scripts all listening for the same event and performing the same conditional test as one another.
----------------------------------------------------------------------------


--- @function start_custom_event_generator
--- @desc Adds a custom event generator. 
--- @p string source event, Source event to listen for.
--- @p function condition, Conditional test to perform. This test will be passed the context of the source event just triggered as a single argument, and should return a boolean value. If the condition returns <code>true</code>, or a value that evaluates to <code>true</code>, the target event will be triggered.
--- @p string target event, Target event to fire if the source event is received and the condition passes. By convention, events triggered from script begin with <code>"ScriptEvent"</code>
--- @p [opt=nil] function context generator, Function that returns an object to be placed on the context of the target event
--- @new_example ScriptEventPlayerBesieged
--- @desc This script fires a <code>"ScriptEventPlayerBesieged"</code> event, with the besieged region attached to the context, when a player settlement is besieged in campaign.
--- @example core:start_custom_event_generator(
--- @example 	"CharacterBesiegesSettlement",
--- @example 	function(context) return context:region():owning_faction():name() == cm:get_local_faction_name() end,
--- @example 	"ScriptEventPlayerBesieged",
--- @example 	function(context) return context:region() end
--- @example )
function core_object:start_custom_event_generator(event, condition, target_event, context_data_generator)
	if not is_string(event) then
		script_error("ERROR: add_custom_event_generator() called but supplied event [" .. tostring(event) .. "] is not a string");
		return false;
	end;
	
	if not is_function(condition) then
		script_error("ERROR: add_custom_event_generator() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	if not is_string(target_event) then
		script_error("ERROR: add_custom_event_generator() called but supplied target_event [" .. tostring(target_event) .. "] is not a string");
		return false;
	end;
	
	if not is_function(context_data_generator) and not is_nil(context_data_generator) then
		script_error("ERROR: add_custom_event_generator() called but supplied context data generator [" .. tostring(target_event) .. "] is not a function or nil");
		return false;
	end;
	
	self:add_listener(
		"custom_event_generator_" .. target_event,
		event,
		function(context) 
			return condition(context) 
		end,
		function(context)
			if context_data_generator then
				self:trigger_event(target_event, context_data_generator(context));
			else
				self:trigger_event(target_event);
			end;
		end,
		true
	);
end;


--- @function stop_custom_event_generator
--- @desc Stops a custom event generator, by the name of the target event. If multiple custom generators produce the same target event they will all be stopped.
function core_object:stop_custom_event_generator(target_event)
	self:remove_listener("custom_event_generator_" .. target_event);
end;








----------------------------------------------------------------------------
--- @section Performance Monitoring
----------------------------------------------------------------------------

--- @function monitor_performance
--- @desc Immediately calls a supplied function, and monitors how long it takes to complete. If this duration is longer than a supplied time limit a script error is thrown. A string name must also be specified for the function, for output purposes.
--- @p function function to call
--- @p number time limit in s
--- @p string name
--- @r @boolean passed perfomance check
function core_object:monitor_performance(callback, time_limit, name)
	local start_timestamp = os.clock();
	
	callback();
	
	local calltime = os.clock() - start_timestamp;
	
	if calltime > time_limit then
		local ast_line = "********************";
		
		print(ast_line);
		print("PERFORMANCE WARNING, timestamp " .. get_timestamp());
		print("function with the following name or callstack took [" .. tostring(calltime) .. "]s to execute, exceeding its allowed time of [" .. tostring(time_limit) .. "]s:\n%%%%%%%%%%%%%%%%%%%%\n" .. tostring(name) .. "\n%%%%%%%%%%%%%%%%%%%%\n");
		print("");
		print(debug.traceback("", 2));
		print(ast_line);
		
		return false;
	end;
	
	return true;
end;









----------------------------------------------------------------------------
--- @section Limited Callbacks
--- @desc The utility functions described in this section can be useful for script that goes round a loop of an indeterminate number of cycles (e.g. some script monitoring player interaction where they can click back and forth as many times as they like) which wishes to call an external function only on the first time, or the first x number of times, around the loop. Using these utility functions means those scripts do not have to maintain a counter of how many times the function has been called themselves.
----------------------------------------------------------------------------


--- @function call_limited
--- @desc Calls the supplied function if the number of previously function calls with the supplied name is less than the supplied limit. Only function calls handled by <code>call_limited</code> (or @core:call_once) are counted. If the function is called then the internal counter associated with the name given is incremented.
--- @p @string name, Name of the callback record to check.
--- @p @function callback, Callback to call.
--- @p [opt=1] @number quantity, Maximum number of times a callback with this name can be called. If the internal counter of the number of callbacks related to the supplied name is less than this supplied quantity then the callback will be called.
--- @r @boolean callback was called
--- @example -- This will be called, as no callback with the name test_callback has been previously called
--- @example core:call_limited("test_callback", function() out("This is a test") end, 1)
--- @example -- This will not be called, as the number of callbacks with the supplied
--- @example -- name is not less than the supplied quantity (1)
--- @example core:call_limited("test_callback", function() out("This is a test") end, 1)
--- @example -- This will be called, as the quantity has been increased.
--- @example -- The callback being different doesn't matter as the name is the same.
--- @example core:call_limited("test_callback", function() out("A different callback") end, 2)
--- @result This is a test
--- @result A different callback
function core_object:call_limited(name, callback, quantity)
	if not is_string(name) then
		script_error("ERROR: call_limited() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: call_limited() called but supplied function [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if quantity and (not is_number(quantity) or quantity <= 0) then
		script_error("ERROR: call_limited() called but supplied [" .. tostring(quantity) .. "] is not a positive number or nil");
		return false;
	end;

	quantity = quantity or 1;

	local limited_callbacks = self.limited_callbacks;

	if not limited_callbacks[name] then
		-- no callback with this name has been called before, so create a record for it
		limited_callbacks[name] = 1;
		callback();
		return true;
	else
		-- a callback with this name has been called before - check its quantity
		if limited_callbacks[name] < quantity then
			limited_callbacks[name] = limited_callbacks[name] + 1;
			callback();
			return true;
		end;
	end;
	return false;
end;


--- @function call_once
--- @desc Calls the supplied function if no function with the supplied name has previously been called by <code>call_once</code> or @core:call_limited.
--- @p @string name, Name of the callback record to check.
--- @p @function callback, Callback to call.
function core_object:call_once(name, callback)
	return self:call_limited(name, callback, 1);
end;









----------------------------------------------------------------------------
---	@section Text and Active Pointers
--- @desc Functionality to help prevent text pointers with duplicate names.
----------------------------------------------------------------------------

--- @function is_text_pointer_name_registered
--- @desc Returns true if a text pointer with the supplied name has already been registered, false otherwise.
--- @p string text pointer name
--- @r boolean has been registered
function core_object:is_text_pointer_name_registered(name)
	if self.registered_text_pointer_names[name] then
		return true;
	end;
	
	return false;
end;


--- @function register_text_pointer_name
--- @desc Registers a text pointer with the supplied name.
--- @p string text pointer name
function core_object:register_text_pointer_name(name)
	self.registered_text_pointer_names[name] = true;
	
	if not self.advice_history_reset_listener_established_for_text_pointer_names then
		self.advice_history_reset_listener_established_for_text_pointer_names = true;		
		self:add_listener(
			"advice_history_reset_listener_for_text_pointer_names",
			"AdviceCleared",
			true,
			function()
				self.registered_text_pointer_names = {};
			end,
			true		
		);
	end;
end;


--- @function register_active_pointer
--- @desc Registers an active pointer. This is called automatically when an active pointer is set to save a record of itself into the advice history. It should not be called externally.
--- @p @active_pointer active pointer
--- @r @boolean registration successful
function core_object:register_active_pointer(ap)
	if not is_activepointer(ap) then
		script_error("ERROR: register_active_pointer() called but supplied object [" .. tostring(ap) .. "] is not a valid active pointer");
		return false;
	end;

	if self.active_pointers[ap.name] then
		script_error("ERROR: register_active_pointer() called but a previous active pointer with name [" .. ap.name .. "] has already been registered. Active pointers that are set to save a record of themselves into the advice history should have unique names");
		return false;
	end;

	self.active_pointers[ap.name] = ap;

	return true;
end;


--- @function get_active_pointer
--- @desc Gets a previously-registered active pointer by name.
--- @p @string name
--- @r @active_pointer active pointer
function core_object:get_active_pointer(name)
	return self.active_pointers[name];
end;


--- @function is_any_active_pointer_showing
--- @desc Returns whether any active pointer is currently being displayed, as well as the active pointer being displayed if one is found.
--- @r @boolean active pointer is showing
--- @r @active_pointer active pointer being shown
function core_object:is_any_active_pointer_showing()
	local active_pointers = self.active_pointers;

	for ap_name, ap in pairs(active_pointers) do
		if ap.text_pointer:is_showing() then
			return true, ap;
		end;
	end;

	return false;
end;


--- @function hide_all_text_pointers
--- @desc Hide any @text_pointer's current visible.
--- @p [opt=false] @boolean hide immediately
function core_object:hide_all_text_pointers(immediate)
	immediate = not not immediate;

	self:trigger_event("ScriptEventHideTextPointers", immediate);
end;





----------------------------------------------------------------------------
---	@section Autonumbers
----------------------------------------------------------------------------

--- @function get_unique_counter
--- @desc Retrieves a unique integer number. Each number is 1 higher than the previous unique number. Useful for scripts that need to generate unique identifiers.
--- @r integer unique number
function core_object:get_unique_counter()
	self.unique_counter = self.unique_counter + 1;
	return self.unique_counter;
end;





----------------------------------------------------------------------------
---	@section Loading Screens/UI Event Progression
----------------------------------------------------------------------------


--- @function get_loading_screen
--- @desc Returns the name and uicomponent of any detected loading screen, or <code>false</code> if one is not currently resident in the ui hierarchy (which would indicate that loading has finished).
--- @r string loading screen name
--- @r uicomponent loading screen uicomponent
function core_object:get_loading_screen()
	local ui_root = self:get_ui_root();
		
	local all_loading_screen_names = {
		"battle",
		"campaign",
		"common",
		"advisor_loading_screen",
		"custom_loading_screen",
		"custom_loading_screen_no_quote",
		"demo",
		"demo_postbattle",
		"demo_prebattle",
		"frontend",
		"generals_speech_battle",
		"historic_battle",
		"postbattle",
		"postbattle_campaign",
		"prologue"
	};
	
	for i = 1, #all_loading_screen_names do
		local current_loading_screen_name = all_loading_screen_names[i];
		local uic = find_child_uicomponent(ui_root, current_loading_screen_name);

		if uic then
			return uic:Id(), uic;
		end;
	end;

	return false;
end;


--- @function is_loading_screen_visible
--- @desc Returns the name and uicomponent of any visible loading screen, or <code>false</code> otherwise.
--- @r string loading screen name
--- @r uicomponent loading screen uicomponent
function core_object:is_loading_screen_visible()
	-- If we're being called as the hiding animation of the LoadingScreenDismissed is completing then we need to guard against this and return false
	if self.loading_screen_is_currently_dismissing then
		return false, false;
	end;

	local uic_name, uic = self:get_loading_screen();

	if uic and uic:Visible(true) then
		return uic_name, uic;
	end;

	return false, false;
end;


--- @function progress_on_loading_screen_dismissed
--- @desc Calls the supplied callback once the loading screen has been dismissed. If no loading screen is currently visible the function throws a script error and calls the callback immediately.
--- @p function callback, Callback to call.
--- @p [opt=false] boolean suppress wait, Suppress wait for loading screen to animate offscreen.
function core_object:progress_on_loading_screen_dismissed(callback, suppress_wait_for_animation)
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_loading_screen_dismissed() called but supplied callback [" .. tostring(callback) .."] is not a function");
		return false;
	end;
	
	-- If this progress_on_loading_screen_dismissed() function has been called off the back of another progress_on_loading_screen_dismissed() callback where the
	-- LoadingScreenDismissed event has been received, we have to specifically guard against that
	if self.loading_screen_is_currently_dismissing then
		out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] is in the process of being dismissed, proceeding immediately");
		callback();
		return;
	end;

	local ui_root = self:get_ui_root();

	local loading_screen_name, uic_loading_screen = self:get_loading_screen();

	-- If we're in campaign, and time has not yet started ticking, then we force a wait for the LoadingScreenDismissed event.
	-- Sometimes the loading screen uicomponent cannot be found in this circumstance so we have to wait for the event instead.
	local force_wait_for_loading_screen_dismissed_in_campaign = core:is_campaign() and not cm:is_game_running();

	-- progress immediately if no loading screen was found and we're being forced to wait
	if not uic_loading_screen and not force_wait_for_loading_screen_dismissed_in_campaign then
		out("=== progress_on_loading_screen_dismissed() called but no loading screen could be found and we're not being forced to wait - progressing immediately");
		callback();
		return;
	end;
	
	-- if the loading screen is visible then wait for it to hide, otherwise progress immediately
	if force_wait_for_loading_screen_dismissed_in_campaign or uic_loading_screen:Visible(true) then
		local loading_screen_current_animation_name = uic_loading_screen:CurrentAnimationId();
		if not force_wait_for_loading_screen_dismissed_in_campaign and loading_screen_current_animation_name ~= "" then
			if suppress_wait_for_animation then
				out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] is currently animating but we're not to wait for it, proceeding immediately");
				callback();
				return;
			end;
			out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] is currently playing animation [" .. uic_loading_screen:CurrentAnimationId() .. "] - waiting for it to finish");
		
			-- loading screen is animating to hide
			self:progress_on_uicomponent_animation_finished(
				uic_loading_screen,
				function()
					out("=== progress_on_loading_screen_dismissed() - loading screen with name [" .. loading_screen_name .. "] has finished animating - calling progress_on_loading_screen() again to ensure that the loading screen is gone");
					self:progress_on_loading_screen_dismissed(callback);
				end,
				true
			);
		else
			if force_wait_for_loading_screen_dismissed_in_campaign then
				out("=== progress_on_loading_screen_dismissed() called and we're being forced to wait as we're in campaign and the game is not yet created - waiting for the LoadingScreenDismissed event");
			else
				out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] is visible - waiting for it to be dismissed");
			end;
			
			self:add_listener(
				"loading_screen_dismissed",
				"LoadingScreenDismissed",
				true,
				function()
					-- re-fetch the loading screen (there's a chance we've never found it before now)
					local loading_screen_name, uic_loading_screen = self:get_loading_screen();

					if suppress_wait_for_animation then
						out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] has been dismissed and we're not to wait for it to finish animating, proceeding immediately");

						-- Guard aainst re-entrancy
						self.loading_screen_is_currently_dismissing = true;
						callback();
						self.loading_screen_is_currently_dismissing = false;
						return;
					end;
					out("=== progress_on_loading_screen_dismissed() - loading screen with name [" .. loading_screen_name .. "] has been dismissed, waiting for it to finish animating");
					
					-- loading screen is animating to hide	
					self:progress_on_uicomponent_animation_finished(
						uic_loading_screen,
						function()
							out("=== progress_on_loading_screen_dismissed() - loading screen with name [" .. loading_screen_name .. "] has finished animating, proceeding");

							-- Guard aainst re-entrancy
							self.loading_screen_is_currently_dismissing = true;
							callback();
							self.loading_screen_is_currently_dismissing = false;
						end,
						true
					);
				end,
				false
			);
		end;
	else
		out("=== progress_on_loading_screen_dismissed() called, loading screen with name [" .. loading_screen_name .. "] doesn't seem to be visible - continuing immediately");
		callback();
	end;
end;


--- @function progress_on_uicomponent_animation_finished
--- @desc Calls the supplied callback once the supplied component has finished animating. This function polls the animation state every 1/10th of a second, so there may be a slight unavoidable delay between the animation finishing and the supplied callback being called.
--- @p uicomponent uicomponent
--- @p function callback
function core_object:progress_on_uicomponent_animation_finished(uicomponent, callback)
	if uicomponent:IsValid() then 
		local anim_id = uicomponent:CurrentAnimationId();

		if anim_id and anim_id ~= "" then
			if self:is_campaign() then
				cm:callback(function() self:progress_on_uicomponent_animation_finished(uicomponent, callback) end, 0.1);
			else
				bm:callback(function() self:progress_on_uicomponent_animation_finished(uicomponent, callback) end, 100);
			end;
			return;
		end;
	end;

	callback();
end;


--- @function progress_on_uicomponent_animation
--- @desc Calls the supplied callback when the active animation on the supplied uicomponent returns a certain string. By default this string is empty, which means this function would progress when the target uicomponent is not animating. However, an alternative animation name can be supplied, which makes this function progress when that animation plays instead.
--- @desc Note that this script has to repeatedly poll the supplied uicomponent, so because of model tick resolution it's not possible to guarantee that the callback will be called the instant the animation changes to the desired state.
--- @p string unique name, Unique name for this monitor (multiple such monitors may be active at once).
--- @p uicomponent uicomponent, Target uicomponent.
--- @p function callback, Callback to call.
--- @p [opt=0] number callback delay, Time in seconds to wait after the animation finishes before calling the supplied callback.
--- @p [opt=""] string animation name, Animation name which, when seen to be playing on the supplied uicomponent, causes the monitor to fire. The default animation name "" implies no animation playing.
function core_object:progress_on_uicomponent_animation(name, uicomponent, callback, delay, animation_id)
	if not is_string(name) then
		script_error("ERROR: progress_on_uicomponent_animation() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_uicomponent(uicomponent) then
		script_error("ERROR: progress_on_uicomponent_animation() called but supplied uicomponent [" .. tostring(uicomponent) .. "] is not a uicomponent");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_uicomponent_animation() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	delay = delay or 0;
	
	if not is_number(delay) or delay < 0 then
		script_error("ERROR: progress_on_uicomponent_animation() called but supplied delay [" .. tostring(delay) .. "] is not a positive number or nil");
		return false;
	end;
	
	animation_id = animation_id or "";
	
	if not is_string(animation_id) then
		script_error("ERROR: progress_on_uicomponent_animation() called but supplied animation id [" .. tostring(animation_id) .. "] is not a string or nil");
		return false;
	end;
	
	local callback_time = 100;
	local timer_obj = false;		-- object to make callback() and repeat_callback() calls on
	
	if self:is_campaign() then
		callback_time = 0.1;
		timer_obj = cm;
	else
		timer_obj = timer_manager:new();
	end;
	
	timer_obj:repeat_callback(
		function()
			if uicomponent:CurrentAnimationId() == animation_id then
				timer_obj:remove_callback("progress_on_uicomponent_animation_" .. name);
				
				if delay then
					timer_obj:callback(callback, delay, "progress_on_uicomponent_animation_" .. name);
				else
					callback();
				end;
			end;
		end,
		0.1,
		"progress_on_uicomponent_animation_" .. name
	);
end;


--- @function cancel_progress_on_uicomponent_animation
--- @desc Cancels a monitor started with @core:progress_on_uicomponent_animation by name.
--- @p @string unique name, Unique name for the monitor to cancel (multiple such monitors may be active at once).
function core_object:cancel_progress_on_uicomponent_animation(name)

	local timer_obj = false;
	if self:is_campaign() then
		timer_obj = cm;
	else
		timer_obj = timer_manager:new();
	end;
	
	timer_obj:remove_callback("progress_on_uicomponent_animation_" .. name);
end;







----------------------------------------------------------------------------
---	@section Caching/Restoring UIComponent Tooltips
----------------------------------------------------------------------------

--- @function cache_and_set_tooltip_for_component_state
--- @desc Caches and sets the tooltip for a particular state of a component. Once cached, the tooltip may be restored with <code>restore_tooltip_for_component_state</code>. This is used by tutorial scripts that overwrite the tooltip state of certain UIComponents.
--- @desc The tooltip text key should be supplied in the common localised text format <code>[table]_[field_of_text]_[key_from_table]</code>.
--- @p @uicomponent subject uicomponent
--- @p @string state name
--- @p @string text key
function core_object:cache_and_set_tooltip_for_component_state(uic, state, new_tooltip)
	
	if not is_uicomponent(uic) then
		script_error("ERROR: cache_and_set_tooltip_for_component_state() called but supplied uicomponent [" .. tostring(uic) .. "] is not a uicomponent");
		return false;
	end;
	
	if not is_string(state) then
		script_error("ERROR: cache_and_set_tooltip_for_component_state() called but supplied state [" .. tostring(state) .. "] is not a string");
		return false;
	end;
	
	if not is_string(new_tooltip) then
		script_error("ERROR: cache_and_set_tooltip_for_component_state() called but supplied new tooltip [" .. tostring(new_tooltip) .. "] is not a string");
		return false;
	end;
	
	local uic_str = uicomponent_to_str(uic);
	
	-- create a table for this uic if we don't already have one
	if not self.cached_tooltips_for_component_states[uic_str] then
		self.cached_tooltips_for_component_states[uic_str] = {};
	end;
	
	-- cache the current uic state, and set it into the target state
	local cached_state = uic:CurrentState();
	uic:SetState(state);
	
	-- create a state tooltip record and cache the target state tooltip and text source into it
	local state_tooltip_record = {};
	state_tooltip_record.tooltip_text, state_tooltip_record.tooltip_text_src = uic:GetTooltipText();

	self.cached_tooltips_for_component_states[uic_str][state] = state_tooltip_record;
	
	-- set the tooltip of the target state
	uic:SetTooltipText(common.get_localised_string(new_tooltip), new_tooltip, false);
	
	-- set the uic back to the state it was in
	uic:SetState(cached_state);
end;


--- @function restore_tooltip_for_component_state
--- @desc Restores a tooltip for a uicomponent state that's been previously modified with <code>cache_and_set_tooltip_for_component_state</code>.
--- @p uicomponent subject uicomponent
--- @p string state name
function core_object:restore_tooltip_for_component_state(uic, state)

	if not is_uicomponent(uic) then
		script_error("ERROR: restore_tooltip_for_component_state() called but supplied uicomponent [" .. tostring(uic) .. "] is not a uicomponent");
		return false;
	end;
	
	if not is_string(state) then
		script_error("ERROR: restore_tooltip_for_component_state() called but supplied state [" .. tostring(state) .. "] is not a string");
		return false;
	end;
	
	local uic_str = uicomponent_to_str(uic);
	
	local cached_tooltips_for_component = self.cached_tooltips_for_component_states[uic_str];
	if not cached_tooltips_for_component then
		return false;
	end;

	local state_tooltip_record = cached_tooltips_for_component[state];
	if not is_table(state_tooltip_record) then
		return false;
	end;
	
	-- cache the current uic state, and set it into the target state
	local cached_state = uic:CurrentState();
	uic:SetState(state);
	
	-- set the state tooltip (and source) back to its cached value
	uic:SetTooltipText(state_tooltip_record.tooltip_text, state_tooltip_record.tooltip_text_src, false);
	
	-- set the component back to its cached state
	uic:SetState(cached_state);
end;









----------------------------------------------------------------------------
---	@section Localised Text Tags
----------------------------------------------------------------------------

core_object.localised_text_tags = {
	{
		start_tag = "[[",
		end_tag = "]]"
	},
	{
		start_tag = "{{",
		end_tag = "}}"
	}
};


--- @function strip_tags_from_localised_text
--- @desc Strips any tags out of a localised text string. Tags stripped are "[[ .. ]]" and "{{ .. }}".
--- @p string text
--- @r string stripped text
function core_object:strip_tags_from_localised_text(localised_text)
	
	local localised_text_tags = self.localised_text_tags;
	
	for i = 1, #localised_text_tags do
		start_tag = selocalised_text_tags[i].start_tag;
		end_tag = localised_text_tags[i].end_tag;

		local still_searching = true;

		while still_searching do
			local start_pos = string.find(localised_text, start_tag, 1);
			-- local start_pos = string.find(localised_text, start_tag, 1, true);	-- uncomment if we move to a later version of lua
			
			if start_pos then
			
				local junk, end_pos = string.find(localised_text, end_tag, start_pos);
				-- local junk, end_pos = string.find(localised_text, end_tag, start_pos, true);		-- uncomment if we move to a later version of lua

				if end_pos then
					localised_text = string.sub(localised_text, 1, start_pos - 1) .. string.sub(localised_text, end_pos + 1);
				else
					still_searching = false;
				end;
			else
				still_searching = false;
			end;
		end;
	end;

	return localised_text;
end;









----------------------------------------------------------------------------
---	@section Bit Checking
----------------------------------------------------------------------------


--- @function check_bit
--- @desc Takes a number value and a numeric bit position. Returns true if the bit at the numeric bit position would be a '1' were the number value converted to binary, false otherwise.
--- @p number subject value
--- @p integer bit position
--- @r boolean bit value
function core_object:check_bit(test_value, bit_position)

	if not is_number(test_value) or test_value < 0 then
		script_error("ERROR: check_bit() called but supplied test value [" .. tostring(test_value) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(bit_position) or bit_position < 0 then
		script_error("ERROR: check_bit() called but supplied bit position [" .. tostring(bit_position) .. "] is not a positive number");
		return false;
	end;

	-- work out how many bits are in our supplied test value
	local num_bits = 0;
	while true do
		if num_bits ^ 2 > test_value then
			break;
		end;
		num_bits = num_bits + 1;
	end;
	
	
	-- if the bit position is greater than the number of bits needed to represent our number, return false
	if bit_position > num_bits then
		return false;
	end;
	
	-- determine whether the value at the given bit position would be a 1 or 0 by working backwards through test value
	local working_value = test_value;
	
	for i = num_bits, 0, -1 do
		local current_bit_dec_value = 2 ^ (i - 1);
	
		if working_value >= current_bit_dec_value then
		
			if bit_position == i then
				return true;
			end;
			
			working_value = working_value - current_bit_dec_value;
		else
			if bit_position == i then
				return false;
			end;
		end;
	end;
	
	return false;
end;









----------------------------------------------------------------------------
---	@section Static Object Registry
----------------------------------------------------------------------------


--- @function add_static_object
--- @desc Registers a static object by a string name, which can be retrieved later with @core:get_static_object. This is intended for use as a registry of global static objects (objects of which there should only be one copy) such as @battle_manager, @campaign_manager, @timer_manager, @script_messager, @generated_battle and so-on. Scripts that intended to create one of these objects can query the static object registry to see if they've been created before and, if not, can register it.
--- @desc An optional classification string may be supplied to specify a grouping for the object. Static objects in different classifications may share the same name. This functionality can be used to register static objects of a particular type, e.g. a particular mission manager, and to ensure that names are unique amongst those objects.
--- @desc If a static object with the supplied name and classification already exists then this function produces a script error unless the overwrite flag is set.
--- @desc The static object registry is not saved into the campaign savegame or saved between game sessions.
--- @p @string object name, Object name.
--- @p object object to register, Object to register.
--- @p [opt=nil] @string classification, Object classification.
--- @p [opt=false] @boolean overwrite, Should overwrite if an object already exists with this name.
--- @p [opt=false] @boolean silent, Do not generate a script error if the object couldn't be added.
--- @r @boolean object added successfully
function core_object:add_static_object(name, object, classification, overwrite, silent)

	if not is_string(name) then
		script_error("ERROR: add_static_object() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not classification then
		classification = "__default";
	elseif not is_string(classification) then
		script_error("ERROR: add_static_object() called but supplied classification [" .. tostring(classification) .. "] is not a string or nil");
		return false;
	end;

	local static_objects = self.static_objects;

	if not static_objects[classification] then
		static_objects[classification] = {};
	end;

	if not overwrite and self.static_objects[classification][name] then
		if not silent then
			if classification == "__default" then
				script_error("ERROR: add_static_object() called but static object with supplied name [" .. name .. "] is already registered, and overwrite flag is not set");
			else
				script_error("ERROR: add_static_object() called but static object with supplied name [" .. name .. "] and classification [" .. classification .. "] is already registered, and overwrite flag is not set");
			end;
		end;
		return false;
	end;

	static_objects[classification][name] = object;

	return true;
end;



--- @function get_static_object
--- @desc Returns the static object previously registered with the supplied string name and optional classification using @core:add_static_object, if any such object has been registered, or nil if no object was found.
--- @p @string object name
--- @p [opt=nil] @string classification
--- @r object object
function core_object:get_static_object(name, classification)
	if not is_string(name) then
		script_error("ERROR: get_static_object() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if classification then
		if not is_string(name) then
			script_error("ERROR: get_static_object() called but supplied name [" .. tostring(name) .. "] is not a string");
			return false;
		end;
	else
		classification = "__default";
	end;

	if self.static_objects[classification] then
		return self.static_objects[classification][name];
	end;
end;










----------------------------------------------------------------------------
---	@section Windowed Movie Players
----------------------------------------------------------------------------


--- @function stop_all_windowed_movie_players
--- @desc Stops any windowed movie players currently playing.
function core_object:stop_all_windowed_movie_players()
	for name, wmp in pairs(self.registered_windowed_movie_players) do
		wmp:hide();
	end;

	self.registered_windowed_movie_players = {};
end;


--- @function register_windowed_movie_player
--- @desc Registers a @windowed_movie_player with the core object so that it may be stopped if @core:stop_all_windowed_movie_players is called. This is only intended to be called internally by windowed movie players.
--- @p @windowed_movie_player player
function core_object:register_windowed_movie_player(wmp)
	if not is_windowedmovieplayer(wmp) then
		script_error("ERROR: register_windowed_movie_player() called but supplied object [" .. tostring(wmp) .. "] is not a valid windowed movie player");
		return;
	end;
	self.registered_windowed_movie_players[wmp.name] = wmp;
end;


--- @function unregister_windowed_movie_player
--- @desc Unregisters a @windowed_movie_player with the core object so that won't be stopped if @core:stop_all_windowed_movie_players is called. This is only intended to be called internally by windowed movie players.
--- @p @windowed_movie_player player
function core_object:unregister_windowed_movie_player(wmp)
	if not is_windowedmovieplayer(wmp) then
		script_error("ERROR: unregister_windowed_movie_player() called but supplied object [" .. tostring(wmp) .. "] is not a valid windowed movie player");
		return;
	end;
	self.registered_windowed_movie_players[wmp.name] = nil;
end;