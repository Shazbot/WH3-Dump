local file_path = common.vfs_working_directory()
local script_file_path = string.sub(debug.getinfo(1).source, 1, string.len("/test.lua") * -1)
file_path = file_path..script_file_path

-- CMD execute command that returns the output of the command as a string
-- + cmd must be a string and contain all arguements that wish to be parsed in the command
local function osExecute(cmd, output)
	if output == true then
		local fileHandle = assert(io.popen(cmd, 'r'))
		local commandOutput = assert(fileHandle:read("*a"))
		return commandOutput
	elseif output == false then
		assert(io.popen(cmd, 'r'))
	end
end

-- Executes the generate_json_file() function of the faction_load_test_data.py script and returns the files path.
-- This function reads data from the g_chaos_lord_list & g_immortal_empires_lord_list tables found in: script\autotest\lib\frontend\tables.lua
-- + The lord varaible is the on screen version of a given lord and must be a string
-- + The campaign_type varaible must be a string  
function Lib.DAVE_Database.Misc.create_lord_context_json(lord, campaign_type)
	local faction_info
	local campaign
	if campaign_type == "The Realm of Chaos" then
		faction_info = g_chaos_lord_list[lord]
		campaign = string.format("%q", "chaos_realms")
	elseif campaign_type == "Immortal Empires" then
		faction_info = g_immortal_empires_lord_list[lord]
		campaign = string.format("%q", "immortal_empires")
	else
		Utilities.print("No valid campaign type selected")
		return false
	end
	local lord_name_fixed = string.format("%q", lord)
	local ccoIDstring = faction_info[2]
	local general_Index = string.match(ccoIDstring, ".-%d+.-([%d%.%,]+)")
	local json_path = osExecute("python "..file_path.."python\\faction_load_test_data.py "..lord_name_fixed.." "..general_Index.. " "..campaign, true)
	return json_path
end

-- Executes the generate_lua_table() function of the faction_load_test_data.py script and returns the files path.
-- This function reads data from the g_chaos_lord_list & g_immortal_empires_lord_list tables found in: script\autotest\lib\frontend\tables.lua
-- + The lord varaible is the on screen version of a given lord and must be a string
-- + The campaign_type varaible must be a string
function Lib.DAVE_Database.Misc.create_lord_context_table(lord, campaign_type)
	local faction_info
	local campaign
	if campaign_type == "The Realm of Chaos" then
		faction_info = g_chaos_lord_list[lord]
		campaign = string.format("%q", "chaos_realms")
	elseif campaign_type == "Immortal Empires" then
		faction_info = g_immortal_empires_lord_list[lord]
		campaign = string.format("%q", "immortal_empires")
	else
		Utilities.print("No valid campaign type selected")
		return false
	end

	local lord_name_fixed = string.format("%q", lord)
	local ccoIDstring = faction_info[2]
	local general_Index = string.match(ccoIDstring, "%d%d[%d]+")
	Utilities.print("LOCAL FILE PATH = "..file_path)
	-- Before initiating the table generation script we check to see if the 'luadata' python module is already installed.
	-- If its not we install it.
	osExecute("python "..file_path.."python\\module_installs.py", false)
	Utilities.print('LORD NAME = '..lord_name_fixed)
	Utilities.print('GENERAL INDEX = '..general_Index)
	local lua_path = osExecute("python "..file_path.."python\\faction_load_test_data.py lua "..lord_name_fixed.." "..general_Index.. " "..campaign, true)
	return lua_path:gsub("\n", "")
end

-- Takes the given lord_context_table (lua file) and adds it to the package.path and adds it as a require.
function Lib.DAVE_Database.Misc.get_lord_context_table(lua_path)
	local pathstring
	Utilities.print("CONTEXT TABLE PATH = "..lua_path)
	local requirestring = string.match(lua_path, "Context_Tables\\(.*)"):gsub("%.lua", "")
	if (string.match(lua_path, "Daemon_Prince")) then
		local demonstring = requirestring:gsub("%[", ""):gsub("%]", "")
		pathstring = lua_path:gsub("%[", ""):gsub("%]", ""):gsub(demonstring..".lua", "").."?.lua"
	else
		local removestring = requirestring:gsub("%-", "%%-")
		pathstring = lua_path:gsub(removestring..".lua", "").."?.lua"
	end
	package.path = package.path..";"..pathstring
	require(requirestring)
end

-- Cleans up the lord_context_table file that was generated as part of a script run.
function Lib.DAVE_Database.Misc.cleanup_context_lua_table_file()
	callback(function ()
		if g_context_table_lua_path == nil or g_context_table_lua_path == "" then
			return
		end
		Utilities.print(g_context_table_lua_path)
		local file_check = io.open(g_context_table_lua_path, "r")
		if file_check ~= nil then 
			io.close(file_check)
			os.remove(g_context_table_lua_path)
			return true
		else
			return false
		end
	end)
end

function Lib.DAVE_Database.Misc.python_screenshot(image_name)
	callback(function() 
		osExecute("python "..file_path.."python\\screenshot.py "..image_name, false)
		Lib.Helpers.Misc.wait(5, true)
		Utilities.print("PICTURE TAKEN!!!")
	end)
end

function Lib.DAVE_Database.Misc.GRIMES_function(faction_key)
	local faction_key_fixed = string.format("%q", faction_key)
	osExecute("python "..file_path.."python\\unit_testing_data.py "..faction_key_fixed)
end