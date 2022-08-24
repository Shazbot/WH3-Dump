Utilities = {}
local m_faction_load_test_lord = ""
----------------------------------------------------------------------------------------------------------------
-- String
----------------------------------------------------------------------------------------------------------------

function Utilities.split(str, delim)
	-- We need at least one delimiter.
	if (string.find(str, delim) == nil) then
		return {str}
	end

	local result 	= {}
	local pattern 	= "(.-)" .. delim .. "()"
	local last_pos 	= 0
	local i 		= 1

	-- Find all matches separated by the specified delimiter.
	for part, pos in string.gfind(str, pattern) do
		result[i] = part
		last_pos  = pos

		i = i + 1
	end

	-- Get the last entry.
	result[i] = string.sub(str, last_pos)

	return result
end

function Utilities.trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function Utilities.prepare_string_for_csv(text)
	text = string.gsub(text, ",", " ")
	text = string.gsub(text, "\n", " | ")
	return text
end


----------------------------------------------------------------------------------------------------------------
-- File
----------------------------------------------------------------------------------------------------------------

function Utilities.exists(file)
	-- Attempt to open file.
	local fh = io.open(file, "rb")
	
	-- File exists if file handle is not nil.
	if (fh ~= nil) then
		fh:close()
		return true
	else
		return false
	end
end

function Utilities.get_contents(file)
	-- First make sure the file exists.
	if (Utilities.exists(file) == false) then
		return {}
	end
	
	local lines = {}
	
	-- Read all lines from the file.
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	
	return lines
end



----------------------------------------------------------------------------------------------------------------
-- Debug
----------------------------------------------------------------------------------------------------------------

local function assemble_output_str(str)
	local timestamp = get_timestamp();
	local output_str_table = {
		"[Autotest] ",
		timestamp,
		string.format("%" .. 11 - string.len(timestamp) .. "s", " "),
		str
	};

	-- the autotest tab already has a timestamp, so removing to avoid doubling up.
	local output_autotest_str_table = {
		"[Autotest] ",
		string.format("%" .. 11 - string.len(timestamp) .. "s", " "),
		str
	};

	return table.concat(output_str_table), table.concat(output_autotest_str_table);
end;

function Utilities.print(str, supress_file_print)
	local out_str, out_auto_str = assemble_output_str(str)
	out.autotest(out_auto_str)
	print(out_str)
	if(g_auotest_log_file_location ~= nil and g_auotest_log_file_name ~= nil and supress_file_print ~= true) then
		Functions.write_to_document(out_str, g_auotest_log_file_location, g_auotest_log_file_name, ".txt")
	end
end

local m_faction_load_test_file_name = ""

function Utilities.set_faction_load_test_lord(lord)
	m_faction_load_test_lord = lord
	m_faction_load_test_file_name = "faction_load_test_"..tostring(m_faction_load_test_lord)..os.date("_%d%m%y_%H%M%S")
end

-- Adds "FAILED" to the end of a string.
-- This is to be expanded upon later once colour printing is possible inside the Lua - Status spool
local function status_print_failure(str)
	out.status(str..'- FAILED')
	Functions.write_to_document(str..",".."Failed", g_faction_load_test_csv_path, m_faction_load_test_file_name, ".csv", false, true)
end

-- Adds "PASSED" to the end of a string.
-- This is to be expanded upon later once colour printing is possible inside the Lua - Status spool
local function status_print_passed(str)
	out.status(str..'- PASSED')
	Functions.write_to_document(str..",".."Passed", g_faction_load_test_csv_path, m_faction_load_test_file_name, ".csv", false, true)
end

-- Prints a string to the Lua - Status spool. If the argument "pass" or "fail" is given, "PASSED" or "FAILED" will be added to the end of the string.
function Utilities.status_print(str, result)
	if result ~= nil then
		if string.lower(result) == "fail" then
			status_print_failure(str)
		elseif string.lower(result) == "pass" then
			status_print_passed(str)
		end
	else
		out.status(str)
	end
end

function Utilities.check_if_nightly_autotest()
	local appdata = os.getenv('APPDATA')
	local location = appdata .. [[\CA_Autotest\WH3\]]
	local local_filepath = location .. [[autotest.script.txt]]

	local autotest_file = io.open(local_filepath, "r")
	if autotest_file ~= nil then
		autotest_file:close()
		return true
	else
		return false
	end
end

function Utilities.get_build_stream()
	local build_details = common.get_context_value("GameCoreContext.BuildNumber")
	local build_stream = string.match(build_details, '%*%)%(((.*))%);')
	return build_stream
end

function Utilities.get_build_number_and_cl_number()
	local build_details = common.get_context_value("GameCoreContext.BuildNumberShort")
	local details_striped = string.match(build_details, "Build%s*(%d[%d.,]*)")
	local build_number, cl_number = string.match(details_striped, "([^.]+).([^.]+)")
	return tonumber(build_number), tonumber(cl_number)
end