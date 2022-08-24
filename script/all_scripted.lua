

--- @set_environment battle
--- @set_environment frontend
--- @set_environment campaign


-- lib types for scripting libraries
__lib_type_battle = 0;
__lib_type_campaign = 1;
__lib_type_frontend = 2;
__lib_type_autotest = 3;

-- store the starting time of this session
lua_start_time = os.clock();

-- gets a timestamp string
function get_timestamp()
	return "<" .. string.format("%.1f", os.clock() - lua_start_time) .. "s>";
end;





----------------------------------------------------------------------------
--- @section Script Errors
----------------------------------------------------------------------------


--- @function script_error
--- @desc Throws a script error with the supplied message, printing the lua callstack to the <code>Lua</code> console output spool. Useful for debugging.
--- @p @string message, Message to print.
--- @p [opt=0] @number stack level modifier, By default this function will print the callstack of the calling function. A modifier may be supplied here to alter which function in the callstack should be at the top of the callstack. A positive integer moves the callstack pointer down the callstack, so a supplied value of <code>1</code> here would mean the callstack of the function calling the function calling <code>script_error</code> would be printed.
--- @p_long_desc If the stack level modifier is set to a negative number then no traceback is printed as part of the script error. This can be useful if the error message itself contains a traceback.
--- @p [opt=false] @boolean suppress assert, If set to <code>true</code> then no assert is generated with this script error.
function script_error(msg, stack_level_modifier, suppress_assert)
	if not type(msg) == "string" then
		script_error("ERROR: script_error() called but supplied message [" .. tostring(msg) .. "] is not a string");
		return false;
	end;

	if stack_level_modifier then
		if not type(stack_level_modifier) == "number" then
			script_error("ERROR: script_error() called but supplied stack level modifier [" .. tostring(stack_level_modifier) .. "] is not a number");
			return false;
		end;
	else
		stack_level_modifier = 0;
	end;

	local ast_line = "********************";
	
	-- do output
	print(ast_line);
	print("SCRIPT ERROR, timestamp " .. get_timestamp());
	print(msg);
	if stack_level_modifier >= 0 then
		print(debug.traceback("", 2 + stack_level_modifier));
	end;
	print(ast_line);
	
	if not suppress_assert then
		if stack_level_modifier >= 0 then
			common.show_error_with_callstack("[SCRIPT] " .. msg);
		else
			common.show_error("[SCRIPT] " .. msg);
		end;
	end;
	
	-- logfile output
	if __write_output_to_logfile then
		local file = io.open(__logfile_path, "a");
		
		if file then
			file:write(ast_line .. "\n");
			file:write("SCRIPT ERROR, timestamp " .. get_timestamp() .. "\n");
			file:write(msg .. "\n");
			if stack_level_modifier >= 0 then
				file:write("\n");
				file:write(debug.traceback("", 2) .. "\n");
			end;
			file:write(ast_line .. "\n");
			file:close();
		end;
	end;
end;






-- script logging
do
	-- Set the ENABLE_SCRIPT_LOGGING tweaker, or make a file called "enable_console_logging" in 
	-- the root of the script folder to enable console logging
	local tweaker_value = common.tweaker_value("ENABLE_SCRIPT_LOGGING");
	
	if (tweaker_value ~= "0" and tweaker_value ~= "") then
		__write_output_to_logfile = true;
	else
		__write_output_to_logfile = (common.filesystem_lookup("/script/", "enable_console_logging") ~= "");
	end;
end;
__logfile_path = "";


if __write_output_to_logfile then
	-- create the logfile
	local filename = "script_log_" .. os.date("%d".."".."%m".."".."%y".."_".."%H".."".."%M") .. ".txt";
	
	_G.logfile_path = filename;
	
	
	local file, err_str = io.open(filename, "w");
	
	if not file then
		__write_output_to_logfile = false;
		script_error("ERROR: tried to create logfile with filename " .. filename .. " but operation failed with error: " .. tostring(err_str));
	else
		file:write("\n");
		file:write("creating logfile " .. filename .. "\n");
		file:write("\n");
		file:close();
		__logfile_path = _G.logfile_path;
	end;
end;










----------------------------------------------------------------------------
--- @section Output
----------------------------------------------------------------------------


--- @function out
--- @desc <code>out</code> is a table that provides multiple methods for outputting text to the various available debug console spools. It may be called as a function to output a string to the main <code>Lua</code> console spool, but the following table elements within it may also be called to output to different output spools:
--- @desc <li>grudges</li>
--- @desc <li>ui</li>
--- @desc <li>chaos</li>
--- @desc <li>traits</li>
--- @desc <li>help_pages</li>
--- @desc <li>interventions</li>
--- @desc <li>invasions</li>
--- @desc <li>design</li></ul>
--- @desc 
--- @desc out supplies four additional functions that can be used to show tab characters at the start of lines of output:
--- @desc <table class="simple"><tr><td>Function</td><td>Description</td></tr><tr><td><strong><code>out.inc_tab</td><td>Increments the number of tab characters shown at the start of the line by one.</td></tr><tr><td><strong><code>out.dec_tab</td><td>Decrements the number of tab characters shown at the start of the line by one. Decrementing below zero has no effect.</td></tr><tr><td><strong><code>out.cache_tab</td><td>Caches the number of tab characters currently set to be shown at the start of the line.</td></tr><tr><td><strong><code>out.restore_tab</td><td>Restores the number of tab characters shown at the start of the line to that previously cached.</td></tr></table>
--- @desc Tab levels are managed per output spool. To each of these functions a string argument can be supplied which sets the name of the output spool to apply the modification to. Supply no argument or a blank string to modify the tab level of the main output spool.
--- @p string output
--- @new_example Standard output
--- @example out("Hello World")
--- @example out.inc_tab()
--- @example out("indented")
--- @example out.dec_tab()
--- @example out("no longer indented")
--- @result Hello World
--- @result 	indented
--- @result no longer indented
--- @new_example UI tab
--- @desc Output to the ui tab, with caching and restoring of tab levels
--- @example out.ui("Hello UI tab")
--- @example out.cache_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.inc_tab("ui")
--- @example out.ui("very indented")
--- @example out.restore_tab("ui")
--- @example out.ui("not indented any more")
--- @result Hello UI tab
--- @result 			very indented
--- @result not indented any more


-- this function re-maps all output functions so that they support timestamps
function remap_outputs(out_impl, suppress_new_session_output)

	-- Do not proceed if out_impl already has a metatable. This can happen if we're running in autotest mode and the game scripts have preconfigured the out table
	if getmetatable(out_impl) then
		return out_impl;
	end;

	-- construct a table to return	
	local out = {};
	
	-- construct an indexed list of output functions
	local output_functions = {};
	for key in pairs(out_impl) do
		table.insert(output_functions, key);
	end;

	-- sort the indexed list (just for output purposes)
	table.sort(output_functions);
	
	-- create a tab level record for each output function, and store it at out.tab_levels
	local tab_levels = {};
	for i = 1, #output_functions do
		tab_levels[output_functions[i]] = 0;
	end;
	tab_levels["out"] = 0;			-- default tab
	out.tab_levels = tab_levels;

	local svr = ScriptedValueRegistry:new();
	local game_uptime = os.clock();
		
	-- map each output function
	for i = 1, #output_functions do
		local current_func_name = output_functions[i];
		
		out[current_func_name] = function(str_from_script)		
			str_from_script = tostring(str_from_script) or "";
		
			-- get the current time at point of output
			local timestamp = get_timestamp();

			-- we construct our output string as a table - the first two entries are the timestamp and some whitespace
			local output_str_table = {timestamp, string.format("%" .. 11 - string.len(timestamp) .."s", " ")};

			-- add in all required tab chars
			for i = 1, out["tab_levels"][current_func_name] do
				table.insert(output_str_table, "\t");
			end;

			-- finally add the intended output
			table.insert(output_str_table, str_from_script);

			-- turn the table of strings into a string
			local output_str = table.concat(output_str_table);
			
			-- print the output
			out_impl[current_func_name](output_str);

			-- log that this output tab has been touched
			svr:SavePersistentBool("out." .. current_func_name .. "_touched", true);
			
			-- logfile output
			if __write_output_to_logfile then
				local file = io.open(__logfile_path, "a");
				if file then
					file:write("[" .. current_func_name .. "] " .. output_str .. "\n");
					file:close();
				end;
			end;
		end;

		-- if this tab has been touched in a previous session then write some new lines to it to differentiate this session's output
		if not suppress_new_session_output then
			if svr:LoadPersistentBool("out." .. current_func_name .. "_touched") then
				for i = 1, 10 do
					out_impl[current_func_name]("");
				end;
				out_impl[current_func_name]("* NEW SESSION, current game uptime: " .. game_uptime .. "s *");
				out_impl[current_func_name]("");
			end;
		end;
	end;
	
	-- also allow out to be directly called
	setmetatable(
		out, 
		{
			__call = function(t, str_from_script) 
				str_from_script = tostring(str_from_script) or "";
			
				-- get the current time at point of output
				local timestamp = get_timestamp();

				-- we construct our output string as a table - the first two entries are the timestamp and some whitespace
				local output_str_table = {timestamp, string.format("%" .. 11 - string.len(timestamp) .."s", " ")};

				-- add in all required tab chars
				for i = 1, out.tab_levels["out"] do
					table.insert(output_str_table, "\t");
				end;

				-- finally add the intended output
				table.insert(output_str_table, str_from_script);

				-- turn the table of strings into a string
				local output_str = table.concat(output_str_table);
				
				-- print the output
				print(output_str);

				-- log that this output tab has been touched
				svr:SavePersistentBool("out_touched", true);
				
				-- logfile output
				if __write_output_to_logfile then
					local file = io.open(__logfile_path, "a");
					if file then
						file:write("[out] " .. output_str .. "\n");
						file:close();
					end;
				end;
			end
		}
	);

	-- if the main output tab has been touched in a previous session then write some new lines to it to differentiate this session's output
	if not suppress_new_session_output then
		for i = 1, 10 do
			print("");
		end;
		
		print("* NEW SESSION, current game uptime: " .. game_uptime .. "s *");

		if not svr:LoadPersistentBool("out_touched") then
			print("  available output spools:");
			print("\tout");
			for j = 1, #output_functions do
				print("\tout." .. output_functions[j]);
			end;
			print("");
			print("");
		end;
		
		print("");
	end;
	
	-- add on functions inc, dec, cache and restore tab levels
	function out.inc_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: inc_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		out.tab_levels[func_name] = current_tab_level + 1;
	end;
	
	function out.dec_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: dec_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		if current_tab_level > 0 then
			out.tab_levels[func_name] = current_tab_level - 1;
		end;
	end;
	
	function out.cache_tab(func_name)
		func_name = func_name or "out";
		
		local current_tab_level = out.tab_levels[func_name];
		
		if not current_tab_level then
			script_error("ERROR: cache_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;
		
		-- store cached tab level elsewhere in the tab_levels table
		out.tab_levels["cached_" .. func_name] = current_tab_level;
		out.tab_levels[func_name] = 0;
	end;
	
	function out.restore_tab(func_name)
		func_name = func_name or "out";
		
		local cached_tab_level = out.tab_levels["cached_" .. func_name];
		
		if not cached_tab_level then
			script_error("ERROR: restore_tab() called but could find no cached tab value for supplied output function name [" .. tostring(func_name) .. "]");
			return false;
		end;
		
		-- restore tab level, and clear the cached value
		out.tab_levels[func_name] = cached_tab_level;
		out.tab_levels["cached_" .. func_name] = nil;
	end;
	
	return out;
end;


-- call the remap function so that timestamped output is available immediately (script in other environments will have to re-call it)
out = remap_outputs(out, __is_autotest);









-- set up the lua random seed
-- use script-generated random numbers sparingly - it's always better to ask the game for a random number
math.randomseed(os.time() + os.clock() * 1000);
math.random(); math.random(); math.random(); math.random(); math.random();










----------------------------------------------------------------------------
--- @section Loading Script Libraries
----------------------------------------------------------------------------


--- @function force_require
--- @desc Forceably unloads and requires a file by name.
--- @p string filename
function force_require(file)
	package.loaded[file] = nil;
	return require(file);
end;


--- @function load_script_libraries
--- @desc One-shot function to load the script libraries.
function load_script_libraries()
	-- path to the script folder
	package.path = package.path .. ";data/script/_lib/?.lua";

	-- loads in the script library header file, which queries the __game_mode and loads the appropriate library files
	-- __game_mode is set in battle_scripted.lua/campaign_scripted.lua/frontend_scripted.lua
	force_require("lib_header");
end;




-- functions to add event callbacks
-- inserts the callback in the events[event] table (the events table being a collection of event tables, each of which contains a list
-- of callbacks to be notified when that event occurs). If a user_defined_list is supplied, then an entry for this event/callback is added
-- to that. This allows areas of the game to clear their listeners out on shutdown (the events table itself is global).
function add_event_callback(event, callback, user_defined_list)

	if type(event) ~= "string" then
		script_error("ERROR: add_event_callback() called but supplied event [" .. tostring(event) .. "] is not a string");
		return false;
	end;
	
	if type(events[event]) ~= "table" then
		events[event] = {};
	end;
	
	if type(callback) ~= "function" then
		script_error("ERROR: add_event_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(events[event], callback);
	
	-- if we have been supplied a user-defined table, add this event callback to that
	if type(user_defined_list) == "table" then
		local user_defined_event = {};
		user_defined_event.event = event;
		user_defined_event.callback = callback;
		table.insert(user_defined_list, user_defined_event);
	end;
end;


-- function to clear callbacks in the supplied user defined list from the global events table. This can be called by areas of the game
-- when they shutdown.
function clear_event_callbacks(user_defined_list)
	if not type(user_defined_list) == "table" then
		script_error("ERROR: clear_event_callbacks() called but supplied user defined list [" .. tostring(user_defined_list) .. "] is not a table");
		return false;
	end;
	
	local count = 0;

	-- for each entry in the supplied user-defined list, look in the relevant event table
	-- and try to find a matching callback event. If it's there, remove it.
	for i = 1, #user_defined_list do	
		local current_event_name = user_defined_list[i].event;
		local current_event_callback = user_defined_list[i].callback;
		
		for j = 1, #events[current_event_name] do
			if events[current_event_name][j] == current_event_callback then
				count = count + 1;
				table.remove(events[current_event_name], j);
				break;
			end;
		end;
	end;

	-- overwrite the user defined list
	user_defined_list = {};
	
	return count;
end;



events = force_require("script.events");


