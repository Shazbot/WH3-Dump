 Functions = {}

----------------------------------------------------------------------------------------------------------------
-- UI Functions
----------------------------------------------------------------------------------------------------------------

--[[ Find Component ]]--
function Functions.find_component(component_path)
	if (component_path == nil) then
		return nil
	end

	-- Parent components can be indicated using a ':' delimiter.
	-- Follow the tree until we reach the end, or until we find an invalid component.
	local component			= ATGlobals.ui_root
	local script_tag		= component:FindByScriptTag(component_path)

	if(script_tag ~= nil) then
		component = UIComponent(script_tag)
		return component
	else
		local component_list 	= Utilities.split(component_path, ":")
		for k,v in pairs(component_list) do
			local name = Utilities.trim(v)
			local comp = component:Find(name, false)
			if (comp == nil) then
				-- Uncomment this if your having trouble debugging an issue, can often help.
				--Utilities.print("----- INFO: Cannot find component - "..component_path)
				return nil, name
			end
			component = UIComponent(comp)
		end
		return component
	end
end

function Functions.find_path_from_component(component)
	if(component ~= nil) then
		local component_id_list = {}
		local component_path_part = component:Id()
		local component_path

		repeat
			table.insert(component_id_list, 1, component_path_part)
			component = UIComponent(component:Parent())
			component_path_part = component:Id()..":"
		until component == nil or component:Id() == "root"

		for k, v in pairs(component_id_list) do
			if(component_path == nil) then
				component_path = v 
			else
				component_path = component_path..v
			end
		end

		return component_path
	else
		Utilities.print("----- INFO: component not found -----")
		return
	end
end

function Functions.get_all_children_from_parent(parent_component)
	if (parent_component == nil) then
		return nil, ("Could not locate parent component: " .. parent_component .. "!")
	end

	child_list = {}
	for i = 0, parent_component:ChildCount() -1 do

		local child_component = UIComponent(parent_component:Find(i))

		child_list[i] = child_component
	end

	return child_list
end

function Functions.find_random_child_component(parent_component, validator_fn, max_attempts)
	-- Default values.
	validator_fn = validator_fn or function(c) return true end
	max_attempts = max_attempts or 50

	if (parent_component == nil) then
		return nil, ("Could not locate parent component!")
	end

	local num_children 	= parent_component:ChildCount()

	-- Try a number of times to pick a random child.
	for i = 0, max_attempts do
		-- Pick a random index.
		local child_index = math.random(0, num_children - 1)

		-- Attempt to find the child component.
		local child_component = parent_component:Find(child_index)

		if (child_component ~= nil) then
			-- Make sure it's visible.
			local c = UIComponent(child_component)

			if (validator_fn(c) == true) then
				return c
			end
		end
	end

	-- If we get here, we didn't find a suitable child component.
	return nil, ("FAILED! to find suitable child component after " .. max_attempts .. " attempts!")
end

function Functions.find_child_component(parent_component, child_index, validator_fn, max_attempts)
	-- Default values.
	validator_fn = validator_fn or function(c) return true end
	max_attempts = max_attempts or 50

	if (parent_component == nil) then
		return nil, ("Could not locate parent component!")
	end

	local num_children 	= parent_component:ChildCount()

	-- Try a number of times to pick a random child.
	for i = 0, max_attempts do
		-- Pick a random index.
		local child_index = math.random(0, num_children - 1)

		-- Attempt to find the child component.
		local child_component = parent_component:Find(child_index)

		if (child_component ~= nil) then
			-- Make sure it's visible.
			local c = UIComponent(child_component)

			if (validator_fn(c) == true) then
				return c
			end
		end
	end
end

--[[ Click Component ]]--
function Functions.click_component(component, left_click, x, y)
	
	if (component == nil or component:Visible() == false) then
		return false
	end

	-- Default arguments.
	left_click = (left_click ~= false)

	-- Attempt to simulate a click on the button component.
	local done_opacity	= component:SetOpacity(255, true)	-- Button clicks require the component to be visible.
	local done_click	= false
	component:SimulateMouseOn()
	-- Try to click it.
	if (x ~= nil and y ~= nil) then
		if (left_click == true) then
			done_click = component:SimulateLClick(x, y)
		else
			done_click = component:SimulateRClick(x, y)
		end
	else
		if (left_click == true) then
			done_click = component:SimulateLClick()
		else
			done_click = component:SimulateRClick()
		end
	end
	component:SimulateMouseOff()

	return (done_opacity and done_click)
end

--[[ Double Click ]]
function Functions.double_click(component, left_click)

	if (component == nil or component:Visible() == false) then
		return false
	end

	-- Default arguments.
	left_click = (left_click ~= false)

	-- Attempt to simulate a click on the button component.
	local done_opacity	= component:SetOpacity(255, true)	-- Button clicks require the component to be visible.
	local done_click	= false

	-- Try to click it.
	if (left_click == true) then
		done_click = component:SimulateDblLClick()

	else
		done_click = component:SimulateDblRClick()

	end
	return (done_opacity and done_click)
end

--[[ Press Key ]]--
function Functions.press_key(key, key_down, key_up)
	local result = false

	-- Default arguments.
	key_down = (key_down ~= false)
	key_up 	 = (key_up ~= false)

	-- Simulate key event.
	if (key_down and key_up) then
		result = (common.key_down(key) and common.key_up(key))
	elseif (key_down) then
		result = (common.key_down(key))
	elseif (key_up) then
		result = (common.key_up(key))
	end

	return result
end

--[[ Trigger Shortcut ]]--
function Functions.trigger_shortcut(key)
	return common.trigger_shortcut(key)
end

--[[ On Click Off ]]--
function Functions.click_component_mouse_on_off(component, left_click, mouse_move_x, mouse_move_y)
	-- Find the component.
	if (component == nil) then
		return false, ("FAILED! to locate component")
	end
	component:SimulateMouseOn()
	-- Default arguments.
	left_click = (left_click ~= false)

	local done_opacity	 = component:SetOpacity(255, true)	-- Button clicks require the component to be visible.
	local done_click	 = false

	-- Simulate mouse on the component
	
	-- Try to click it.
	if (x ~= nil and y ~= nil) then
		if (left_click == true) then
			done_click = component:SimulateLClick(x, y)
		else
			done_click = component:SimulateRClick(x, y)
		end
	else
		if (left_click == true) then
			done_click = component:SimulateLClick()
		else
			done_click = component:SimulateRClick()
		end
	end

	-- Simulate mouse off the component
	component:SimulateMouseOff()

	return (done_opacity and done_click)
end

--[[ Mouse Move ]]
function Functions.mouse_move(x, y)
	-- We need a component in order to be able call SimulateMouseMove 
	-- (this seems redundant as the mouse is moved to any X and Y coordinate and has nothing to do with the component specified).
	-- The menu button should always be visible during battle or campaign with a few exceptions.
	local component, missing_component_name = Functions.find_component("menu_bar:buttongroup:button_menu")
	if (component == nil) then
		return false, ("FAILED! to locate component '" .. missing_component_name .. "'")
	end

	if (x ~= nil and y ~= nil) then
		component:SimulateMouseMove(x, y)
	end
end

--[[ Mouse Move To Component ]]
function Functions.mouse_move_to_component(component)
	if (component == nil) then
		return false, ("FAILED! to locate component")
	end

	local x, y = component:Position()

	x = x + (component:Width() / 2)
	y = y + (component:Height() / 2)

	if (x ~= nil and y ~= nil) then
		component:SimulateMouseMove(x, y)
	end
end

--[[ Mouse Move To Component And Click ]]
function Functions.mouse_move_to_component_click(component, left_click)
	if (component == nil) then
		return false, ("FAILED! to locate component")
	end

	local x, y = component:Position()

	x = x + (component:Width() / 2)
	y = y + (component:Height() / 2)

	if (x ~= nil and y ~= nil) then
		component:SimulateMouseMove(x, y)
	end

	if (left_click == true) then
		done_click = component:SimulateLClick()
	else
		done_click = component:SimulateRClick()
	end
end

function Functions.hover_over_component(component, seconds)
	callback(function()
		if(component ~= nil) then
			callback(function() component:SimulateMouseOn() end)
			Lib.Helpers.Misc.wait(seconds)
			callback(function() component:SimulateMouseOff() end)
		else
			Utilities.print("FAILED! to locate component")
			return false
		end
	end)
end

function Functions.hover_over_component_then_call_function(hover_component, function_call)
	callback(function()
		if(hover_component ~= nil) then
			callback(function() hover_component:SimulateMouseOn() end)
			Lib.Helpers.Misc.wait(1)
			callback(function() function_call() end)
			callback(function() hover_component:SimulateMouseOff() end)
		else
			Utilities.print("FAILED! to locate hover component")
			return false
		end
	end)
end

--[[ Mouse On ]]--
function Functions.mouse_on(component)
	if (component == nil) then
		return false, ("FAILED! to locate component")
	end

	-- Simulate mouse on the component
	component:SimulateMouseOn()
end

--[[ Mouse Off ]]--
function Functions.mouse_off(component)
	if (component == nil) then
		return false, ("FAILED! to locate component")
	end

	-- Simulate mouse off the component
	component:SimulateMouseOff()
end

--[[ Mouse Event ]]
function Functions.simulate_mouse_event(event_name, x_pos, y_pos)

	--	List of possible mouse events
	--	"LBUTTON_UP",
	--	"LBUTTON_DOWN",
	--	"LBUTTON_DBL_CLICK_UP",
	--	"LBUTTON_DBL_CLICK_DOWN",
	--	"RBUTTON_UP",
	--	"RBUTTON_DOWN",
	--	"RBUTTON_DBL_CLICK_UP",
	--	"RBUTTON_DBL_CLICK_DOWN",
	--	"MBUTTON_UP",
	--	"MBUTTON_DOWN",
	--	"MBUTTON_DBL_CLICK_UP",
	--	"MBUTTON_DBL_CLICK_DOWN",
	--	"MOUSEMOVE",
	--	"MOUSEWHEEL",
	--	"MOUSELEAVE"

	Utilities.print("Event Name: " .. event_name .. " X: " .. x_pos .. " Y: " .. y_pos)

	common.mouse_event(event_name, x_pos, y_pos)
end

function Functions.simulate_mouse_event(event_name, component)
	
	local x, y = component:Position()

	x = x + (component:Width() / 2)
	y = y + (component:Height() / 2)

	--	List of possible mouse events
	--	"LBUTTON_UP",
	--	"LBUTTON_DOWN",
	--	"LBUTTON_DBL_CLICK_UP",
	--	"LBUTTON_DBL_CLICK_DOWN",
	--	"RBUTTON_UP",
	--	"RBUTTON_DOWN",
	--	"RBUTTON_DBL_CLICK_UP",
	--	"RBUTTON_DBL_CLICK_DOWN",
	--	"MBUTTON_UP",
	--	"MBUTTON_DOWN",
	--	"MBUTTON_DBL_CLICK_UP",
	--	"MBUTTON_DBL_CLICK_DOWN",
	--	"MOUSEMOVE",
	--	"MOUSEWHEEL",
	--	"MOUSELEAVE"

	Utilities.print("Event Name: " .. event_name .. " X: " .. x .. " Y: " .. y)

	common.mouse_event(event_name, x, y)
end

function Functions.export_metadata()
	common.call_context_command("GenerateNightlyUiData")
	Utilities.print("call context command: ExportMetadata")
end

function Functions.start_tech_research(component_id)
	-- Type ID + Object ID
	common.call_context_command("CcoCampaignTechnology", component_id, "StartResearching")
end

function Functions.check_component_visible(component, not_visible, from_root)

	if(from_root == nil or from_root == false) then
		if(not_visible == nil or not_visible == false) then
			if(component ~= nil and component:Visible() == true) then
				return true
			else
				return false
			end
		else
			if(component == nil or component:Visible() == false) then
				return true
			else
				return false
			end
		end
	else
		if(not_visible == nil or not_visible == false) then
			if(component ~= nil and component:Visible(true) == true) then
				return true
			else
				return false
			end
		else
			if(component == nil or component:Visible(true) == false) then
				return true
			else
				return false
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------------
-- File Writing Functions
----------------------------------------------------------------------------------------------------------------

--this used to have a callback in it, however sometimes we want to write to a file outside of the callback list
--so the functionality is not in a callback, but if go_fast is false or nil then it will call this function again wrapped with a callback
--this results in the same functionality as when it was callbacked previously but has the option to not be callbacked as well for speed
function Functions.write_to_document(contents, location, name, extension, overwrite, line_break, go_fast)
	go_fast = go_fast or false
	if(not go_fast)then
		callback(function() Functions.write_to_document(contents, location, name, extension, overwrite, line_break, true) end)
	else
		--contents is the target to be written
		--location is the ESCAPED file location to be written to. EG: c:\\test1\\test2
		--name is file save name
		--extension is the save extension of the file. If nil, defaults to .txt (THIS WILL SAVE AS ANYTHING, SO DON'T PASS INVALID EXTENSIONS)
		--overwrite is declaring if you want to append or write the document. True = Overwrite, False = Ammend
		--newline declares if the text should create a new line after every input, probably should be true by default
		local contents_found = nil
		line_break = line_break or true

		if contents ~= nil then
			contents_found = true
		elseif contents == nil then
			contents_found = false
			Utilities.print("no contents argument found. Contents == nil")
		end

		if contents_found == true then
			if name == nil then
				name = "test"
			end

			local escaped_location = "c:\\test"
			if location == nil then
				os.execute("mkdir "..[[c:\test]].. " 2> NUL")
				Utilities.print("No location specified, defaulting to c:\\test")

			elseif location ~= nil then
				escaped_location = location
			end

			local open_value = "w"
			if(overwrite == true) then
				open_value = "w"
			else
				open_value = "a"
			end

			if line_break == true then 
				lineadd = "\n"
			elseif line_break == false then
				lineadd = ""
			end

			if extension == nil then
				extension = ".txt"
			end

			local true_location = escaped_location.."\\"..name..extension
			local file = io.open(true_location, open_value)
			if(file ~= nil)then
				file:write(contents, lineadd)
				file:close()
			else
				Utilities.print("FAILED! Attempted to write to a file but the file is nil. This could be due to a number of reasons, please contact a member of the automaton team.")
			end
			
		elseif contents_found == false then
			Utilities.print("Write failed. No output found to write")
		end
	end
end

function Functions.split_string_to_table(string, sep)
	-- splits a string based on a seperation character and returns the sub-strings as a table
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(string, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

function Functions.get_csv_as_nested_table(file_path, tonum)
	local csv_table = {}
	local csv_file = io.open(file_path, "r")
	local loop = 1
	-- tonum will convert number strings to numbers if true/possible
	tonum = tonum or true

	for line in csv_file:lines() do
		-- we skip the first loop to allow for csv headers, there's also a weird symbols error that seems to occur on the first line. Official data should start on line 2.
		if(loop > 1) then
			local cells = Functions.split_string_to_table(line, ',')
			for k, cell in ipairs(cells) do
				if(cell == '') then
					cell = nil
				end
				cells[k] = tonumber(cell) or cell
			end
			table.insert(csv_table, cells)
		end
		loop = loop + 1
	end

	csv_file:close()
	return csv_table
end

function Functions.get_file_names_in_directory(directory)
	-- /b ensures it only returns a list of files
	local file_list = io.popen("dir \""..directory.."\" /b")
	local file_names = {}

	for line in file_list:lines() do
		table.insert(file_names, line)
	end

	return file_names
end

function Functions.check_file_exists(file_path)
	local f = io.open(file_path, "r")
	if f~= nil then io.close(f) return true else return false end
end

function Functions.find_file_from_partial_name(partial_name, file_location)
	local matches = {}
	local file_list = Functions.get_file_names_in_directory(file_location)

	for k, v in pairs(file_list) do
		if(string.find(v, partial_name) ~= nil) then
			table.insert(matches, v)
		end
	end
	
	if(#matches == 1) then
		return matches[1]
	elseif(#matches > 1) then
		Utilities.print("More than one match found, refine your search if possible")
		return nil
	else
		Utilities.print("No matches found")
		return nil
	end
end

function Functions.remove_lines_from_file(location, name, extension, starting_line, num_lines)
	local true_location = location.."\\"..name..extension
	local fp = io.open(true_location, "r" )

	if fp == nil then 
		return nil 
	end
 
    content = {}
    i = 1;
    for line in fp:lines() do
        if i < starting_line or i >= starting_line + num_lines then
	    	content[#content+1] = line
		end
		i = i + 1
    end

    if i > starting_line and i < starting_line + num_lines then
		Utilities.print( "Warning: Tried to remove lines after EOF." )
    end
 
    fp:close()
    fp = io.open(true_location, "w+" )

    for i = 1, #content do
		fp:write( string.format( "%s\n", content[i] ) )
    end
 
    fp:close()
end

function Functions.write_to_document_with_timestamp(start_time, str, location, file_name, extension, overwrite)
	local start_time = start_time
	local timestamp = Functions.get_time_difference(start_time)
	Functions.write_to_document("["..timestamp.."]  " .. str, location, file_name, extension, overwrite)
end

function Functions.get_time_difference(start_time)
--This requires "local start_time = os.time()" at the start of the script it's called in
	local now = os.clock()
	local time_since_startup = now - start_time
	return time_since_startup
end

function Functions.sleep(n)
--pass me seconds plz
	local now = os.clock()
	local finish = now + tonumber(n)
	while now > finish do
		now = os.clock()
	end
end

function Functions.copy_folder_contents_to_another_folder(source_folder, destination_folder)
    callback(function()
        local files = Functions.get_file_names_in_directory(source_folder)
        for _,file in ipairs(files) do
            local file_to_copy = source_folder.."\\"..file
            os.execute([[xcopy "]]..file_to_copy..[[" "]]..destination_folder..[[\" /Y]])
        end
    end)
end