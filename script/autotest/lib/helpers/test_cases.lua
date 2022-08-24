g_test_case_holder = {}
g_test_case_table = {}

--Test Case "Enums"
g_test_case_status = {
	"Pending",
	"InProgress",
	"Passed",
	"Failed",
	"DidNotStart"
}

g_test_case_type = {
	"Component",
	"Flag"
}

--member variables for test cases and checkpoints
local m_network_logging_path = [[\\casan05\tw\Automation\gsat_runs\WH3]]
local m_network_folder_name = "(project)_(script_name)_(machine_name)_(date+time)" 
local m_full_logging_path = ""
local m_previous_checkpoints_full_list = {}
local m_dont_do_any_logging = false
local m_dont_do_anymore_checkpoints = false

--###############################################################################
--########################## CHECKPOINT FUNCTIONS ###############################
--###############################################################################

function Lib.Helpers.Test_Cases.set_network_folder_name(script_name)
	if(m_dont_do_any_logging)then
		return
	end
	script_name = script_name:gsub(" ", "_")
	m_network_folder_name = script_name.."_"..os.getenv("COMPUTERNAME")..os.date("_%d%m%y_%H%M%S")
	m_full_logging_path = m_network_logging_path.."\\"..m_network_folder_name
	local result = os.execute("mkdir \""..m_network_logging_path.."\\"..m_network_folder_name.."\"")
	if(result ~= 0)then
		print("Something has gone wrong with the directory, dont do any logging!")
		m_dont_do_any_logging = true
	end
	
	Lib.Helpers.Test_Cases.update_checkpoint_file("GSAT Started")
end

function Lib.Helpers.Test_Cases.delete_checkpoint_file()
	if(m_dont_do_any_logging)then
		return
	end
	print("Successful script is successful, deleting checkpoint file")
	os.remove(m_full_logging_path.."\\checkpoint.txt")
	m_dont_do_anymore_checkpoints = true
end

local function count_value_in_table(table, value)
	local count = 0
	for _, table_value in ipairs(table) do
		if(table_value == value)then
			count = count+1
		end
	end
	return count
end

local function extract_sub_table(original_table, start_point, end_point)
	local temp_table = {}
	if(end_point == nil or end_point > #original_table)then
		end_point = #original_table
	end
	for i = start_point, end_point do
		table.insert(temp_table, original_table[i])
	end
	return temp_table
end

function Lib.Helpers.Test_Cases.update_checkpoint_file(message)
	if(m_dont_do_any_logging or m_dont_do_anymore_checkpoints)then
		return
	end
	local x_value = 10
	local last_x_entires = extract_sub_table(m_previous_checkpoints_full_list, #m_previous_checkpoints_full_list-x_value, #m_previous_checkpoints_full_list)
	local log_this_message = false
	local message_count = count_value_in_table(last_x_entires, message)
	if(message_count > 5)then
		--this message has appeared in the last X entries
		print("Message has appeared over 5 times in the last 10 messages, possible loop detected, will not log anymore of this message: "..tostring(message))
		log_this_message = false
	else
		log_this_message = true
	end

	if(log_this_message)then
		table.insert(m_previous_checkpoints_full_list, message)
		print("Logging checkpoint message: "..tostring(message))
		Functions.write_to_document(message, m_full_logging_path, "checkpoint", ".txt", false, false, true)
	end
end

--###############################################################################
--########################### TESTCASE FUNCTIONS ################################
--###############################################################################

--there should be NO callbacks in these functions because they are primarily called during the action manager loop which is above the level of callbacks
--adding in callbacks to these functions will likely cause weird behaviour with your scripts that rely on callbacks
local function get_table_size(table_to_count)
	local count = 0
	for _,_ in pairs(table_to_count) do
		count = count+1
	end
	return count
end

function Lib.Helpers.Test_Cases.check_for_test_cases()
	if(get_table_size(g_test_case_table) == 0)then --if there are no test cases in the table then dont do any logging
		m_dont_do_any_logging = true
		print("THERE ARE NO TEST CASES. WILL NOT DO ANY LOGGING OF TEST CASES OR CHECKPOINTS!")
	end
end

function Lib.Helpers.Test_Cases.set_test_case(test_case_key, flag_to_set, failed)
	if(m_dont_do_any_logging)then
		return
	end
	failed = failed or false
	if(g_test_case_table[test_case_key] ~= nil and g_test_case_table[test_case_key].type == g_test_case_type[2])then
		if(flag_to_set == "start" and g_test_case_table[test_case_key].status == g_test_case_status[1])then
			g_test_case_table[test_case_key].start_point = true
			g_test_case_table[test_case_key].status = g_test_case_status[2]
			print("TEST CASE STARTED: "..tostring(test_case_key))
			Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)
		elseif(flag_to_set == "end" and g_test_case_table[test_case_key].status == g_test_case_status[2]) then
			g_test_case_table[test_case_key].end_point = true
			if(failed)then
				g_test_case_table[test_case_key].status = g_test_case_status[4]
			else
				g_test_case_table[test_case_key].status = g_test_case_status[3]
			end
			
			print("TEST CASE PASSED: "..tostring(test_case_key))
			Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)
			g_test_case_table[test_case_key].function_to_call()
		end
	elseif(g_test_case_table[test_case_key] ~= nil and g_test_case_table[test_case_key].type ~= g_test_case_type[2]) then
		Utilities.print(string.format("The test case key %s is not a flag type but you have called Lib.Helpers.Test_Cases.set_test_case which is for flag types! This test case is of type %s",test_case_key, g_test_case_table[test_case_key].type))
	else
		Utilities.print("NO TEST CASE MATCHES THE KEY "..tostring(test_case_key))
	end
end

local function ensure_test_cases_are_updated()
	for test_case_key, test_case in pairs(g_test_case_table) do
		if(test_case.status == g_test_case_status[2])then --if InProgress set to failed
			test_case.status = g_test_case_status[4]
		elseif(test_case.status == g_test_case_status[1]) then --if pending set to DidNotStart
			test_case.status = g_test_case_status[5]
		end
	end
end

function Lib.Helpers.Test_Cases.print_all_test_cases()
	ensure_test_cases_are_updated()
	Utilities.print("TEST CASES: ")
	for test_case_key,test_case in pairs(g_test_case_table) do
		Utilities.print(string.format("> Test case: %s : %s", tostring(test_case_key), tostring(test_case.status)))
		Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)
	end
end

function Lib.Helpers.Test_Cases.create_test_case_files()
	if(m_dont_do_any_logging)then
		return
	end
	local file_count = 0
	g_test_case_folder_path = m_full_logging_path

	for test_case_key, _ in pairs(g_test_case_table) do
		Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)		
		file_count = file_count+1
	end

	local file_list = Functions.get_file_names_in_directory(g_test_case_folder_path)
	Utilities.print(string.format("Potentially created %d out of the %d required files", #file_list, file_count))
end

function Lib.Helpers.Test_Cases.create_run_info_file()
	if(m_dont_do_any_logging)then
		return
	end
	local branch = Utilities.get_build_stream()
	local build_num, changelist = Utilities.get_build_number_and_cl_number()
	local machine_name = os.getenv("COMPUTERNAME")
	local full_string = string.format("Branch:%s \nBuild:%s \nChangelist:%s \nMachine:%s", branch, build_num, changelist, machine_name)
	Functions.write_to_document(full_string, g_test_case_folder_path, "run_info", ".txt", true, false, true)
end

function Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)
	if(m_dont_do_any_logging)then
		return
	end
	Functions.write_to_document(string.format("%s=%s", test_case_key, g_test_case_table[test_case_key].status), g_test_case_folder_path, test_case_key, ".txt", true, false, true)
end

function Lib.Helpers.Test_Cases.check_component_watchers()
	for test_case_key, test_case in pairs(g_test_case_table) do
		--if test case type is "Component" and status is "Pending" or "inProgress"
		if(test_case.type == g_test_case_type[1] and (test_case.status == g_test_case_status[1] or test_case.status == g_test_case_status[2])) then
			local status_to_set = ""
			local path = ""
			local function_to_call = function()end
			if(test_case.status == g_test_case_status[1]) then --pending
				status_to_set = g_test_case_status[2]
				path = test_case.start_point
			elseif(test_case.status == g_test_case_status[2]) then --InProgress
				status_to_set = g_test_case_status[3]
				path = test_case.end_point
				function_to_call = test_case.function_to_call --optional function that's called when test case passes
			end

			local component = Functions.find_component(path)
			if(Functions.check_component_visible(component, false, true)) then
				test_case.status = status_to_set
				Lib.Helpers.Test_Cases.update_test_case_file(test_case_key)
				function_to_call()
			end
		end
	end
end

function Lib.Helpers.Test_Cases.setup_test_cases_and_checkpoints(script_name)
	Lib.Helpers.Test_Cases.check_for_test_cases()
	if(m_dont_do_any_logging)then
		return
	end
	Lib.Helpers.Test_Cases.set_network_folder_name(script_name)
	Lib.Helpers.Test_Cases.create_test_case_files()
    Lib.Helpers.Test_Cases.create_run_info_file()
end

--###############################################################################
--########################## TESTCASE TABLES ####################################
--###############################################################################

--this is just used to help create new test cases
local test_case_example = {
	["start_point"] = "path:here:or true/false", -- a component path or true/false
	["end_point"] = "path:here:or true/false also", --same as above
	["function_to_call"] = function()end, --called when function passes (optional)
	["status"] = g_test_case_status[1], -- see contents of g_test_case_status table above
	["type"] = g_test_case_type[1] -- component, flag 
}

g_test_case_holder["campaign_progression_tests"] = {
	["Frontend Loaded"] = {
		["start_point"] = "main:menu",
		["end_point"] = "main:menu",
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[1]
	},
	["Select Campaign"] = {
		["start_point"] = "main:campaigns_frame:holder:new_campaign_holder:button_new_campaign",
		["end_point"] = "sp_grand_campaign:button_start_parent:button_start_campaign",
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[1]
	},
	["Start Campaign"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["Campign Turn Ended"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["Diplomatic Deal Made"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["Research Technology"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["Attack Someone"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["Fight Battle"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	},
	["GSAT Finished Successfully"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	}
}

--a very basic set of test cases that all GSATs use by default until they are given more bespoke/useful test cases
g_test_case_holder["basic_test_cases"] = {
	["Frontend Loaded"] = {
		["start_point"] = "main:menu",
		["end_point"] = "main:menu",
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[1]
	},
	["GSAT Finished Successfully"] = {
		["start_point"] = false,
		["end_point"] = false,
		["function_to_call"] = function()end,
		["status"] = g_test_case_status[1],
		["type"] = g_test_case_type[2]
	}
}
