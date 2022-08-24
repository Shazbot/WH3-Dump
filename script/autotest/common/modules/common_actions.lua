Common_Actions = {}

-- if set to true this will replace click functions with a simple _SimulateLClick() call on each component
-- ONLY set this to true if you know what you're doing as it can result in unintended behaviour!
-- does not do any click attempts etc, just does a single simulated click, primarily used for small, quick GSATs
g_simple_clicks = false
----------------------------------------------------------------------------------------------------------------
-- Simulate Click
----------------------------------------------------------------------------------------------------------------

-- each click will be attempted for 30s before throwing up an error if it can complete.
-- each attempt pauses for .05 seconds, meaning click_attempts needs to reach 600 before throwing an error.
-- resets back to 0 after each click pass/fail.
local click_attempts = 0

--[[ Single Click ]]--
function Common_Actions.click_component(component, alias, left_click)
	callback(function()
		if(g_simple_clicks)then
			Utilities.print("AttemptingSimpleClick '" .. alias .. "'")
			local result = component:SimulateLClick()

			if(result)then
				Utilities.print("SimpleClick '" .. alias .. "': OK! (maybe) "..tostring(result))
			else
				--this is deliberately written as Failed! not FAILED! as we don't want to mark runs as failed in the mailer report when using simple clicks
				Utilities.print("SimpleClick '" .. alias .. "': Failed! (maybe) "..tostring(result)) 
			end
				
			return
		end

		if(component ~= nil and type(component) == "userdata") then
			alias = alias or "No Alias"
			
			if(click_attempts == 0) then
				Utilities.print("AttemptingClick '" .. alias .. "'")
			end
			result, message = Functions.click_component(component, left_click)
			if (result == true) then
				click_attempts = 0
				callback(function()
					-- a slight pause here after a successful click to give UI a moment to update.
					Utilities.print("SimulateClick '" .. alias .. "': OK!")
					Utilities.print("...")
					Lib.Helpers.Test_Cases.update_checkpoint_file("clicked: "..tostring(alias)) --update checkpoint file with this click, if the file isn't updated after 10 minutes the watcher assumes the script has failed
				end, 100)
			elseif(click_attempts < 300) then
				click_attempts = click_attempts + 1
				Common_Actions.click_component(component, alias, left_click)
			else
				click_attempts = 0
				if (message ~= nil) then
					Utilities.print(message)
				else
					Utilities.print("SimulateClick '" .. alias .. "': FAILED!")
					Utilities.print("...")
				end
			end
		else
			Utilities.print("Component '"..alias.."' not found: FAILED!")
			Utilities.print("...")
		end
	end, 100)
end

--[[ Double Click ]]--
function Common_Actions.double_click_component(component, alias, left_click)
	callback(function()
		alias = alias or "No Alias"

		if(click_attempts == 0) then
			Utilities.print("AttemptingDoubleClick '" .. alias .. "'")
		end
		result, message = Functions.double_click(component, left_click)
		if (result == true) then
			click_attempts = 0
			callback(function()
				Utilities.print("SimulateDoubleClick '" .. alias .. "': OK!")
				Utilities.print("...")
				Lib.Helpers.Test_Cases.update_checkpoint_file("double-clicked: "..tostring(alias)) --update checkpoint file with this click, if the file isn't updated after 10 minutes the watcher assumes the script has failed
			end, 100)
		elseif(click_attempts < 600) then
			click_attempts = click_attempts + 1
			Common_Actions.double_click_component(component, alias, left_click)
		else
			click_attempts = 0
			if (message ~= nil) then
				Utilities.print(message)
				Utilities.print("...")
			else
				Utilities.print("SimulateDoubleClick '" .. alias .. "': FAILED!")
				Utilities.print("...")
			end
		end
	end, 50)
end

--[[ Single Click Without Fail ]]--
function Common_Actions.click_component_without_fail(component, alias, left_click)
	callback(function()
		alias = alias or "No Alias"
		
		if(click_attempts == 0) then
			Utilities.print("AttemptingClick '" .. alias .. "'")
		end
		result, message = Functions.click_component(component_name, left_click)
		if (result == true) then
			click_attempts = 0
			callback(function()
				Utilities.print("SimulateClick '" .. alias .. "': OK!")
				Utilities.print("...")
			end, 100)
		elseif(click_attempts < 600) then
			click_attempts = click_attempts + 1
			Common_Actions.click_component_without_fail(component, alias, left_click)
		else
			click_attempts = 0
			if (message == nil) then
				Utilities.print("SimulateClick '" .. alias .. "': NOT FOUND!")
				Utilities.print("...")
			end
		end
	end, 50)
end

--[[ Double Click Without Fail ]]--
function Common_Actions.double_click_component_without_fail(component, alias, left_click)
	callback(function()
		alias = alias or "No Alias"

		if(click_attempts == 0) then
			Utilities.print("AttemptingDoubleClick '" .. alias .. "'")
		end
		local result, message = Functions.double_click_component_by_name(component, left_click)
		if (result == true) then
			click_attempts = 0
			callback(function()
				Utilities.print("SimulateDoubleClick '" .. alias .. "': OK!")
				Utilities.print("...")
			end, 100)
		elseif(click_attempts < 600) then
			click_attempts = click_attempts + 1
			Common_Actions.double_click_component_without_fail(component, alias, left_click)
		else
			click_attempts = 0
			if (message == nil) then
				Utilities.print("SimulateDoubleClick '" .. alias .. "': NOT FOUND!")
				Utilities.print("...")
			end
		end
	end, 50)
end

----------------------------------------------------------------------------------------------------------------
-- Trigger Shortcuts
----------------------------------------------------------------------------------------------------------------

function Common_Actions.trigger_shortcut(key)
	callback(function()
		Functions.trigger_shortcut(key)
		Utilities.print("TriggerShortcut '"..tostring(key).."'")
		Utilities.print("...")
	end, wait.short)
end

----------------------------------------------------------------------------------------------------------------
-- Take Screenshot
----------------------------------------------------------------------------------------------------------------
-- only ".bmp" or ".tga" extensions can be used;
-- if you want to use the ImageMagick conversion software, use the .tga extension as the software has issues converting game screenshots if they are .bmp
function Common_Actions.take_screenshot(file_name, extension)
	callback(function()
		extension = extension or ".bmp"
		common.take_screenshot(common.get_appdata_screenshots_path()..[[\]]..file_name..extension)
	end, wait.short)	
end

----------------------------------------------------------------------------------------------------------------
-- Simulate Mouse
----------------------------------------------------------------------------------------------------------------

function Common_Actions.simulate_mouse_event(event_name, x_pos, y_pos)
	Functions.simulate_mouse_event(event_name, x_pos, y_pos)
end

----------------------------------------------------------------------------------------------------------------
-- Double Click
----------------------------------------------------------------------------------------------------------------

function Common_Actions.double_click(component)
	if (Functions.double_click(component)) then
		Utilities.print("DoubleClick SUCCESS!")
	else
		Utilities.print("DoubleClick FAIL!")
	end
end

----------------------------------------------------------------------------------------------------------------
-- Simulate Key Press
----------------------------------------------------------------------------------------------------------------

function Common_Actions.press_key(key, key_down, key_up)
	if (Functions.press_key(key, key_down, key_up)) then
		-- Do not report success in case many key presses are queued.
		return true
	else
		Utilities.print("SimulateKey '" .. key .. "': FAILED!")
		return false
	end
end

----------------------------------------------------------------------------------------------------------------
-- Component Existence
----------------------------------------------------------------------------------------------------------------

function Common_Actions.ensure_component_exists(component)
	
	if (component ~= nil) then
		Utilities.print("Ensure component '" .. component:Id() .. "' exists... OK!")
		return true
	else
		Utilities.print("Ensure component '" .. component:Id() .. "' exists... FAILED!")
		return false
	end
end

function Common_Actions.ensure_component_does_not_exist(component)

	if (component == nil) then
		Utilities.print("Ensure component '" .. component:Id() .. "' does not exist... OK!")
		return true
	else
		Utilities.print("Ensure component '" .. component:Id() .. "' does not exist... FAILED!")
		return false
	end
end

function Common_Actions.wait_until_component_visible(component, from_root)
	callback(function()
		if(Functions.check_component_visible(component, false, from_root)) then
			Common_Actions.wait_until_component_visible(component, from_root)
		end
	end, 50)
end

----------------------------------------------------------------------------------------------------------------
-- Global Actions
----------------------------------------------------------------------------------------------------------------

function Common_Actions.push_global(func, e, r)
	Action_Manager.push_global(func, e, r)
	Utilities.print("Registered global action.")
	return true
end

function Common_Actions.pop_global()
	local result = Action_Manager.pop_global()

	if (result == true) then
		Utilities.print("Unregistered global action.")
	else
		Utilities.print("Attempted to unregister global, but the global stack is empty.")
	end

	return true
end

----------------------------------------------------------------------------------------------------------------
-- Debugging
----------------------------------------------------------------------------------------------------------------

function Common_Actions.print(message)
	Utilities.print(message)
	return true
end

----------------------------------------------------------------------------------------------------------------
-- Tables
----------------------------------------------------------------------------------------------------------------

function Common_Actions.table_length(table)
	-- table.getn() only counts table entries with a numerical index.
	-- This lets you get the actual length of a table, even if it doesn't have a number index.
    local count = 0
    for index, values in pairs(table) do
        count = count + 1
    end
    return count
end

function Common_Actions.print_table(table, value_only)
	for index, values in pairs(table) do
		if(value_only == true) then
			Utilities.print("----- INFO: "..values.." -----")
		else
			Utilities.print("----- INFO: "..index..": "..values.." -----")
		end
	end
	Utilities.print("...")
end

function Common_Actions.print_table_to_file(print_table, file_name, overwrite, header, value_only)
	local appdata = os.getenv("APPDATA")
	overwrite = overwrite or false
	local file_location = appdata.."\\CA_Autotest\\WH3\\gsat_logs"
	Utilities.print("LOGS! "..file_location)
	os.execute("mkdir \""..file_location.."\"")
	Functions.write_to_document("", file_location, file_name, ".txt", overwrite, false)
	if(header) then
		Functions.write_to_document(header, file_location, file_name, ".txt", false)
	end
	for index, values in pairs(print_table) do
		if(value_only == true) then
			printout = "----- INFO: "..values.." -----"
		else
			printout = "----- INFO: "..index..": "..values.." -----"
		end
		Functions.write_to_document(printout, file_location, file_name, ".txt", false)
	end
	Functions.write_to_document("\n", file_location, file_name, ".txt", false)
end

----------------------------------------------------------------------------------------------------------------
-- Dropdowns
----------------------------------------------------------------------------------------------------------------

function Common_Actions.select_dropdown_option(dropdown, option, string_match)
	Common_Actions.open_dropdown(dropdown)
	-- wait is needed to make sure the list populates on slower PCs before attempting to select any of the choices
	Lib.Helpers.Misc.wait(1)
	callback(function()
		local option_choice
		if(string_match and option ~= nil) then
			option_choice = Common_Actions.choose_dropdown_option_from_string(dropdown, option)
		else
			option_choice = Common_Actions.choose_dropdown_option(dropdown, option)
		end
		Common_Actions.click_dropdown_option(dropdown, option_choice)
	end)
end

function Common_Actions.open_dropdown(dropdown)
	callback(function()
		Common_Actions.click_component(dropdown, "Open dropdown: "..dropdown:Id())
	end)
end

function Common_Actions.choose_dropdown_option(dropdown, option_choice)
	local dropdown_list = {}
	local dropdown_count, dropdown_list = Common_Actions.get_dropdown_list_count(dropdown)
	if(dropdown_count > 0) then
		if(option_choice == nil or option_choice == "Random") then
			option_choice = math.random(1, table.getn(dropdown_list))
		end
		local option = dropdown_list[option_choice]
		return option
	else
		-- The dropdown has 0 child components, so probably failed to open even if it was "active"
		Utilities.print("Dropdown ("..tostring(dropdown:Id())..") failed to open or is empty ... FAILED!")
		return false
	end
end

function Common_Actions.choose_dropdown_option_from_string(dropdown, option_choice)
	local dropdown_list = {}
	local dropdown_count, dropdown_list = Common_Actions.get_dropdown_list_count(dropdown)
	if(dropdown_count > 0) then
		for i = 1, dropdown_count do
			local option = dropdown_list[i]
			local dropdown_text = Common_Actions.get_dropdown_text(dropdown, option:Id())
			if(dropdown_text == option_choice) then
				return option
			end
		end
		Utilities.print("Dropdown ("..tostring(dropdown:Id())..") failed to find matching string ... FAILED!")
		return false
	else
		-- The dropdown has 0 child components, so probably failed to open even if it was "active"
		Utilities.print("Dropdown ("..tostring(dropdown:Id())..") failed to open or is empty ... FAILED!")
		return false
	end
end

function Common_Actions.click_dropdown_option(dropdown, option_choice)
	callback(function()
		local dropdown_count = Common_Actions.get_dropdown_list_count(dropdown)
		if(dropdown_count > 0) then
			local dropdown_text = Common_Actions.get_dropdown_text(dropdown, option_choice:Id())
			Common_Actions.click_component(option_choice, "Dropdown option: "..dropdown_text, true)
		end
	end)
end

function Common_Actions.get_dropdown_list_count(dropdown)
	local dropdown_path = Functions.find_path_from_component(dropdown)
	local component = Functions.find_component(dropdown_path..":popup_menu:popup_list")
	if(component == nil) then
		component = Functions.find_component(dropdown_path..":popup_menu:listview:list_clip:list_box")
		if(component == nil) then
			component = Functions.find_component(dropdown_path..":popup_menu:list_box")
			if(component == nil) then
				component = Functions.find_component(dropdown_path..":popup_menu:content:culture_list")
			end
		end
	end
	local count, list = Common_Actions.get_visible_child_count(component)
	return count, list
end

function Common_Actions.get_dropdown_text(dropdown, option)
	local component_option = Lib.Components.Helpers.dropdown_option_text(dropdown, option)
	if(component_option ~= nil) then
		return component_option:GetStateText()
	else
		return nil
	end
end

----------------------------------------------------------------------------------------------------------------
-- Checkboxes
----------------------------------------------------------------------------------------------------------------

function Common_Actions.toggle_checkbox(checkbox, turn_on)
	callback(function()
		local checkbox_id = checkbox:Id()
		if(turn_on == nil or turn_on == "Random") then
			checkbox_choice = math.random(1, 2)
			if(checkbox_choice == 1) then
				turn_on = true
			else
				turn_on = false
			end
		end
		if(turn_on == true and (checkbox:CurrentState() == "active")) then
			Common_Actions.click_component(checkbox, checkbox_id)
		elseif(turn_on == false and (checkbox:CurrentState() == "selected")) then
			Common_Actions.click_component(checkbox, checkbox_id)
		end
	end)
end

----------------------------------------------------------------------------------------------------------------
-- Child Components
----------------------------------------------------------------------------------------------------------------

function Common_Actions.get_child_id(parent_component)
	-- Returns the Component ID of a random child component.
	local child_component = Functions.find_random_child_component(parent_component)
	local child_id = child_component:Id()
	return child_id
end

function Common_Actions.get_visible_child_count(parent_component)
	-- returns the child count for all visible child components and a table with their IDs
	if(parent_component ~= nil) then
		local child_count = parent_component:ChildCount()
		local all_children = {}
		local visible_children = {}
		for i = 0, (child_count - 1) do
			local child_component = UIComponent(parent_component:Find(i))
			table.insert(all_children, child_component)
			if(child_component ~= nil and child_component:Visible() == true) then
				table.insert(visible_children, child_component)
			end
		end
		return table.getn(visible_children), visible_children
	else
		Utilities.print("Parent component not found, getting debug info: ")
		--debug.getinfo(2) will get us the debug information for the function that called get_visible_child_count(), this makes it easier to identify where the nil component has come from
		local debug_info = debug.getinfo(2)
		
		if(debug_info ~= nil)then
			for info_name, info in pairs(debug_info) do
				Utilities.print("Info name: "..tostring(info_name))
				Utilities.print("Info: "..tostring(info))
			end
		else
			Utilities.print("No debug info. Something has likely gone very wrong.")
		end
		
		return 0, {}
	end
end

function Common_Actions.print_all_children(parent_component)
	for i = 0, parent_component:ChildCount() - 1 do
		local child_component = UIComponent(parent_component:Find(i))
		Utilities.print(child_component:Id())
	end
end

----------------------------------------------------------------------------------------------------------------
-- Trigger Events
----------------------------------------------------------------------------------------------------------------

function Common_Actions.start_tech_research(component_id)
	callback(function()
		Functions.start_tech_research(component_id)
		Utilities.print("TriggerTechResearch '"..tostring(component_id).."'")
		Utilities.print("...")
	end)
end

function Common_Actions.trigger_console_command(command)
	callback(function()
		common.execute_cli_command(command)
	end, wait.long)
end