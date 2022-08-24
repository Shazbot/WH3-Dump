

--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend

SECONDS_PER_MONTH = 2678400;


-- Advice levels
-- These are to be used with advice_monitor:set_advice_level.
ADVICE_LEVEL_MINIMAL_LOW_HIGH = 0;
ADVICE_LEVEL_LOW_HIGH = 1;
ADVICE_LEVEL_HIGH = 2;



----------------------------------------------------------------------------
---	@section Volume Types
--- @desc A handful of sound-related functions in battle require a volume type to be specified when they are called. The values described below represent those volume types. They can be passed into functions such as @battle:set_volume and @battle:get_volume to specify a volume type.
----------------------------------------------------------------------------


VOLUME_TYPE_MUSIC = 0;			--- @variable VOLUME_TYPE_MUSIC @number Volume type representing music, that can be used with sound-related functions. Value is <code>0</code>.
VOLUME_TYPE_SFX = 1;			--- @variable VOLUME_TYPE_SFX @number Volume type representing sfx, that can be used with sound-related functions. Value is <code>1</code>.
VOLUME_TYPE_ADVISOR = 2;		--- @variable VOLUME_TYPE_ADVISOR @number Volume type representing advisor sounds, that can be used with sound-related functions. Value is <code>2</code>.
VOLUME_TYPE_VO = 3;				--- @variable VOLUME_TYPE_VO @number Volume type representing voiceover sounds, that can be used with sound-related functions. Value is <code>3</code>.
VOLUME_TYPE_INTERFACE = 1;		--- @variable VOLUME_TYPE_INTERFACE @number Volume type representing user interface sounds, that can be used with sound-related functions. Value is <code>4</code>.
VOLUME_TYPE_MOVIE = 5;			--- @variable VOLUME_TYPE_MOVIE @number Volume type representing movie sounds, that can be used with sound-related functions. Value is <code>5</code>.
VOLUME_TYPE_VOICE_CHAT = 6;		--- @variable VOLUME_TYPE_VOICE_CHAT @number Volume type representing voice chat audio, that can be used with sound-related functions. Value is <code>6</code>.
VOLUME_TYPE_MASTER = 7;			--- @variable VOLUME_TYPE_MASTER @number Volume type representing the master volume level, that can be used with sound-related functions. Value is <code>7</code>.




----------------------------------------------------------------------------
---	@section Iterators
----------------------------------------------------------------------------


--- @function model_pairs
--- @desc An iterator for use with model objects in campaign and battle. When used in a for loop with a model list object, the iterator function returns the index and next item provided by the list object each loop pass.
--- @desc In campaign, this iterator supports all model list objects such as <code>region_list</code>, <code>character_list</code>, <code>military_force_list</code> etc. In battle, this iterator supports model list objects such as @battle_alliances, @battle_armies and @battle_units, as well as @script_units script collection objects.
--- @p object parent list object
--- @r object child list item
--- @new_example model_pairs usage in campaign
--- @example local region_list = cm:model():world():region_manager():region_list();
--- @example for i, region in model_pairs(region_list) do
--- @example 	out(i .. " " .. region:name());
--- @example end;
--- @result <i>list of all regions</i>
--- @new_example model_pairs usage in battle
--- @example for i, unit in model_pairs(bm:get_player_army():units()) do
--- @example 	bm:out(i .. ": unit with id " .. unit:unique_ui_id() .. " is at position " .. v_to_s(unit:position()));
--- @example end;
--- @result <i>list of player units</i>


if __game_mode == __lib_type_battle then
	function model_pairs(list)
		local i = 0;
		local max = list:count();

		return function()
			i = i + 1;
			if i <= max then
				return i, list:item(i);
			end;
		end;
	end;
elseif __game_mode == __lib_type_campaign then

	function model_pairs(list)
		local i = -1;
		local max = list:num_items() - 1;

		return function()
			i = i + 1;
			if i <= max then
				return i, list:item_at(i);
			end;
		end;
	end;
end;


--- @function uic_pairs
--- @desc An iterator for use with @uicomponent objects, which returns each child in succession. When used in a for loop with a uicomponent object, the iterator function returns the index number and the child corresponding to that index each loop pass.
--- @p @uicomponent parent uicomponent object
--- @r object child uicomponent iterator
--- @example local uic_parent = find_uicomponent(core:get_ui_root(), "some_parent")
--- @example out("Listing children of some_parent:");
--- @example for i, uic_child in uic_pairs(uic_parent) do
--- @example 	out("\tChild " .. i .. " is " .. uic_child:Id());
--- @example end;
--- @result Listing children of some_parent:
--- @result 	Child 0 is first_child
--- @result 	Child 1 is some_other_child
--- @result 	Child 2 is yet_another_child
function uic_pairs(uic)
	if not validate.is_uicomponent(uic) then
		return false;
	end;

	local i = -1;
	local max = uic:ChildCount() - 1;

	return function()
		i = i + 1;
		if i <= max then
			return i, UIComponent(uic:Find(i));
		end;
	end;
end;


----------------------------------------------------------------------------
---	@section Angle Conversions
----------------------------------------------------------------------------


--- @function r_to_d
--- @desc Converts a supplied angle in radians to degrees.
--- @p number angle, Angle in radians
--- @r number angle in degrees
function r_to_d(value)
	if not is_number(value) then
		return false;
	else
		return value * 57.29578;
	end;
end;


--- @function d_to_r
--- @desc Converts a supplied angle in degrees to radians.
--- @p number angle, Angle in degrees
--- @r number angle in radians
function d_to_r(value)
	if not is_number(value) then
		return false;
	else
		return value * 0.017453;
	end;
end;








----------------------------------------------------------------------------
---	@section File and Folder Paths
--- @desc Functions to help get the filename and path of the calling script.
----------------------------------------------------------------------------


--- @function get_file_and_folder_path_as_table
--- @desc Returns the file and path of the calling script as a table of strings.
--- @p [opt=0] integer stack offset, Supply a positive integer here to return a result for a different file on the callstack e.g. supply '1' to return the file and folder path of the script file calling the the script file calling this function, for example.
--- @r table table of strings
function get_file_and_folder_path_as_table(stack_offset)
	stack_offset = stack_offset or 0;
	
	if not is_number(stack_offset) then
		script_error("ERROR: get_folder_name_and_shortform() called but supplied stack offset [" .. tostring(stack_offset) .. "] is not a number or nil");
		return false;
	end;
	
	-- path of the file that called this function
	local file_path = debug.getinfo(2 + stack_offset, "S").source;
	
	local retval = {};
	
	if string.len(file_path) == 0 then
		-- don't know if this can happen
		return retval;
	end;
	
	local current_separator_pos = 1;
	local next_separator_pos = 1;
	
	-- list of separators - we have to try each of them each time
	local separators = {"\\/", "\\", "//", "/"};
	
	while true do
		local next_separator_pos = string.len(file_path);
		local separator_found = false;
		
		-- try each of our separators and, if we find any, pick the "earliest"
		for i = 1, #separators do
			-- apologies for variable names in here..
			local this_separator = separators[i];
			
			local this_next_separator_pos = string.find(file_path, this_separator, current_separator_pos);
			
			if this_next_separator_pos and this_next_separator_pos < next_separator_pos then
				next_separator_pos = this_next_separator_pos;
				separator_found = this_separator;
			end;			
		end;

		if separator_found then
			table.insert(retval, string.sub(file_path, current_separator_pos, next_separator_pos - 1));
		else
			-- if we didn't find a separator, we must be the end of the path (and it doesn't end with a separator)
			table.insert(retval, string.sub(file_path, current_separator_pos));
			return retval;
		end;
		
		current_separator_pos = next_separator_pos + string.len(separator_found);
		
		-- stop if we're at the end of our string
		if current_separator_pos >= string.len(file_path) then
			return retval;
		end;
	end;
end;


--- @function get_folder_name_and_shortform
--- @desc Returns the folder name of the calling file and the shortform of its filename as separate return parameters. The shortform of the filename is the portion of the filename before the first "_", if one is found. If no shortform is found the function returns only the folder name.
--- @desc A shortform used to be prepended on battle script files to allow them to be easily differentiated from one another in text editors e.g. "TF_battle_main.lua" vs "PY_battle_main.lua" rather than two "battle_main.lua"'s.
--- @p [opt=0] integer stack offset, Supply a positive integer here to return a result for a different file on the callstack e.g. supply '1' to return the folder name/shortform of the script file calling the the script file calling this function, for example.
--- @r string name of folder containing calling file
--- @r string shortform of calling filename, if any
function get_folder_name_and_shortform(stack_offset)
	stack_offset = stack_offset or 0;
	
	if not is_number(stack_offset) then
		script_error("ERROR: get_folder_name_and_shortform() called but supplied stack offset [" .. tostring(stack_offset) .. "] is not a number or nil");
		return false;
	end;
	
	local path = get_file_and_folder_path_as_table(stack_offset + 1);
	
	-- folder name is the last-but-one element in the returned path
	if #path < 2 then
		script_error("ERROR: get_folder_name_and_shortform() called but couldn't determine a valid path to folder? Investigate");
		return false;
	end;
	
	folder_name = path[#path - 1];
	
	local shortform_end = string.find(folder_name, "_");
	
	-- if we didn't find a "_" character pass back the whole folder name as a single return value
	if not shortform_end then
		return folder_name;
	end;
	
	-- pass back the substring before the first "_" as the folder shortform
	local shortform = string.sub(folder_name, 1, shortform_end - 1);
	
	return folder_name, shortform;
end;


--- @function get_full_file_path
--- @desc Gets the full filepath and name of the calling file.
--- @p [opt=0] integer stack offset, Supply a positive integer here to return a result for a different file on the callstack e.g. supply '1' to return the file path of the script file calling the the script file calling this function, for example.
--- @r string file path
function get_full_file_path(stack_offset)
	stack_offset = stack_offset or 0;
	
	if not is_number(stack_offset) then
		script_error("ERROR: get_full_file_path() called but supplied stack offset [" .. tostring(stack_offset) .. "] is not a number or nil");
		return false;
	end;
	
	return debug.getinfo(2 + stack_offset, "S").source;
end;


--- @function get_file_name_and_path
--- @desc Returns the filename and the filepath of the calling file as separate return parameters.
--- @p [opt=0] integer stack offset, Supply a positive integer here to return a result for a different file on the callstack e.g. supply '1' to return the file name and path of the script file calling the the script file calling this function, for example.
--- @r string file name
--- @r string file path
function get_file_name_and_path(stack_offset)
	stack_offset = stack_offset or 0;
	
	if not is_number(stack_offset) then
		script_error("ERROR: get_file_name_and_path() called but supplied stack offset [" .. tostring(stack_offset) .. "] is not a number or nil");
		return false;
	end;
	
	-- path of the file that called this function
	local file_path = debug.getinfo(2 + stack_offset).source;
	local current_pointer = 1;
		
	while true do
		local separator = "\\";
		local next_separator_pos = string.find(file_path, separator, current_pointer);
		
		if not next_separator_pos then
			separator = "/";
			next_separator_pos = string.find(file_path, separator, current_pointer);
			
			if not next_separator_pos then
				separator = "\\/";
				next_separator_pos = string.find(file_path, separator, current_pointer);
			end;
		end;
		
		if not next_separator_pos then
			-- there are no more separators in the file path
			
			if current_pointer == 1 then
				-- no file path was detected for some reason
				return file_path, "";
			end;
			-- otherwise return the file name and the file path as separate parameters
			return string.sub(file_path, current_pointer), string.sub(file_path, 1, current_pointer - 2);
		end;
		
		current_pointer = next_separator_pos + string.len(separator);
	end;
end;











----------------------------------------------------------------------------
---	@section UIComponents
----------------------------------------------------------------------------


--- @function find_child_uicomponent
--- @desc Takes a uicomponent and a string name. Searches the direct children (and no further - not grandchildren etc) of the supplied uicomponent for another uicomponent with the supplied name. If a uicomponent with the matching name is found then it is returned, otherwise <code>false</code> is returned.
--- @p uicomponent parent ui component
--- @p string name
--- @r uicomponent child, or false if not found
function find_child_uicomponent(parent, name)
	for i = 0, parent:ChildCount() - 1 do
		local uic_child = UIComponent(parent:Find(i));
		if uic_child:Id() == name then
			return uic_child;
		end;
	end;
	
	return false;
end;

--- @function find_child_uicomponent_by_index
--- @desc Takes a uicomponent and an index. Searches the direct children (and no further - not grandchildren etc) of the supplied uicomponent. If a uicomponent with the correct index is found then it is returned, otherwise <code>false</code> is returned.
--- @p uicomponent parent ui component
--- @p number index, starting at 0
--- @r uicomponent child, or false if not found
function find_child_uicomponent_by_index(parent, index)
	if not is_uicomponent(parent) then
		script_error("ERROR: find_child_uicomponent_by_index() called but supplied parent [" .. tostring(parent) .."] is not a ui component");
		return false;
	end;

	if not is_number(index) then
		script_error("ERROR: find_child_uicomponent_by_index() called but supplied index [" .. tostring(index) .. "] is not a number");
		return false;
	end;

	if index > parent:ChildCount() - 1 then
		script_error("ERROR: find_child_uicomponent_by_index() called, but index [" .. tostring(index) .. "] is out of range");
		return false;
	end

	local uic_child = UIComponent(parent:Find(index))
	if uic_child then 
		return uic_child
	else
		return false
	end
end;


-- can be used externally, but find_uicomponent is better
function find_single_uicomponent(parent, component_name)
	if not is_uicomponent(parent) then
		script_error("ERROR: find_single_uicomponent() called but supplied parent [" .. tostring(parent) .."] is not a ui component");
		return false;
	end;
	
	if not is_string(component_name) and not is_number(component_name) then
		script_error("ERROR: find_single_uicomponent() called but supplied component name [" .. tostring(component_name) .. "] is not a string or a number");
		return false;
	end;

	local component = parent:Find(component_name, false);
	
	if not component then
		return false;
	end;
	
	return UIComponent(component);
end;


--- @function find_uicomponent
--- @desc Finds and returns a uicomponent based on a set of strings that define its path in the ui hierarchy. This parent uicomponent can be supplied as the first argument - if omitted, the root uicomponent is used. Starting from the parent or root, the function searches through all descendants for a uicomponent with the next supplied uicomponent name in the sequence. If a uicomponent is found, its descendants are then searched for a uicomponent with the next name in the list, and so on until the list is finished or no uicomponent with the supplied name is found. A fragmentary path may be supplied if it still unambiguously specifies the intended uicomponent.
--- @p [opt=nil] @uicomponent parent ui component
--- @p ... list of string names
--- @r uicomponent child, or false if not found.
function find_uicomponent(...)

	local current_parent = arg[1];
	local start_index = 2;

	if not is_uicomponent(current_parent) then
		current_parent = core:get_ui_root();
		start_index = 1;
	end;
	
	for i = start_index, arg.n do
		local current_child = find_single_uicomponent(current_parent, arg[i]);
		
		if not current_child then
			-- out("find_uicomponent() couldn't find component called " .. tostring(arg[i]));
			return false;
		end;
		
		current_parent = current_child;
	end;
	
	return current_parent;
end;


--- @function find_uicomponent_from_table
--- @desc Takes a start uicomponent and a numerically-indexed table of string uicomponent names. Starting from the supplied start uicomponent, the function searches through all descendants for a uicomponent with the next supplied uicomponent name in the table. If a uicomponent is found, its descendants are then searched for a uicomponent with the next name in the list, and so on until the list is finished or no uicomponent with the supplied name is found. This allows a uicomponent to be searched for by matching its name and part of or all of its path.
--- @p uicomponent parent ui component, Parent uicomponent.
--- @p table table of string names, Table of string names, indexed by number.
--- @p [opt=false] assert on failure, Fire a script error if the search fails.
--- @r uicomponent child, or false if not found.
function find_uicomponent_from_table(parent, t, assert_on_failure)
	if not is_table(t) then
		script_error("ERROR: find_uicomponent_from_table() called but supplied path list [" .. tostring(t) .. "] is not a table");
		return false;
	end;
	
	local current_uic = parent;
	
	for i = 1, #t do
		local current_id = t[i];
		
		if not is_string(current_id) and not is_number(current_id) then
			script_error("ERROR: find_uicomponent_from_table() called but element " .. tostring(i) .. " of supplied path list is not a string, it is [" .. tostring(current_id) .. "]");
			return false;
		end;
		
		current_uic = find_single_uicomponent(current_uic, current_id);
		
		if not current_uic then
			if assert_on_failure then
				local path = table.concat(t, ", ");
				script_error("ERROR: find_uicomponent_from_table() couldn't find uicomponent, path is [" .. path .. "] and the failure occurred trying to find element " .. i .. " [" .. current_id .. "]");
			end;
			
			return false;
		end;
	end;	
	
	return current_uic;
end;


--- @function uicomponent_descended_from
--- @desc Takes a uicomponent and a string name. Returns true if any parent ancestor component all the way up to the ui root has the supplied name (i.e. the supplied component is descended from it), false otherwise.
--- @p uicomponent subject uic
--- @p string parent name
--- @r @boolean uic is descended from a component with the supplied name.
function uicomponent_descended_from(uic, parent_name)
	if not is_uicomponent(uic) then
		script_error("ERROR: uicomponent_descended_from() called but supplied uicomponent [" .. tostring(uic) .. "] is not a ui component");
		return false;
	end;
	
	if not is_string(parent_name) then
		script_error("ERROR: uicomponent_descended_from() called but supplied parent name [" .. tostring(parent_name) .. "] is not a string");
		return false;
	end;

	while true do
		-- uic is now the address of the parent uic
		uic = uic:Parent();

		-- if this address is nil then there was no parent, so return false
		if not uic then
			return false;
		end;

		-- the address is not nil, so wrap it as a uicomponent
		uic = UIComponent(uic);

		-- if it's not valid then return false
		if not uic:IsValid() then
			return false;
		end;

		-- we now have a valid uicomponent, see if the name matches
		if uic:Id() == parent_name then
			return true;
		end;
	end;
end;


--- @function uicomponent_to_str
--- @desc Converts a uicomponent to a string showing its path, for output purposes.
--- @p uicomponent subject uic
--- @r string output
function uicomponent_to_str(uic)
	if not is_uicomponent(uic) then
		return "";
	end;
	
	if uic:Id() == "root" then
		return "root";
	else
		local parent = uic:Parent();
		
		if parent then
			return uicomponent_to_str(UIComponent(parent)) .. " > " .. uic:Id();
		else
			-- this can happen if a click has resulted in some uicomponents being destroyed
			return uic:Id();
		end;
	end;	
end;


local animation_frame_data_types = {
	"colour",
	"position",
	"scale",
	"shader_values",
	"rotation",
	"image",
	"opacity",
	"text",
	"interpolation_time",
	"font_scale",
	"material_params"
};


--- @function output_uicomponent
--- @desc Outputs extensive debug information about a supplied uicomponent to the <code>Lua - UI</code> console spool.
--- @p uicomponent subject uic, Subject uicomponent.
--- @p [opt=false] boolean omit children, Do not show information about the uicomponent's children.
function output_uicomponent(uic, omit_children, include_animation_data)
	if not is_uicomponent(uic) then
		script_error("ERROR: output_uicomponent() called but supplied object [" .. tostring(uic) .. "] is not a ui component");
		return;
	end;
	
	-- not sure how this can happen, but it does ...
	if not uic:IsValid() then
		out.ui("output_uicomponent() called but supplied component seems to not be valid, so aborting");
		return;
	end;
	
	out.ui("");
	out.ui("uicomponent " .. uic:Id());
	out.inc_tab("ui");
	out.ui("path from root:\t" .. uicomponent_to_str(uic));
		
	local pos_x, pos_y = uic:Position();
	local size_x, size_y = uic:Bounds();

	out.ui("position on screen: [" .. tostring(pos_x) .. ", " .. tostring(pos_y) .. "], size: [" .. size_x .. ", " .. size_y .. "], state: [" .. uic:CurrentState() .. "], visible: [" .. tostring(uic:Visible(true)) .. "], priority: [" .. tostring(uic:Priority()) .. "], interactive: [" .. tostring(uic:IsInteractive()) .. "]");

	if include_animation_data then
		local animation_names = uic:GetAnimationNames();

		out.ui("animations:");

		for i = 1, #animation_names do
			local current_animation_name = animation_names[i];
			local current_num_frames = uic:NumAnimationFrames(current_animation_name);

			out.ui("\tanimation [" .. current_animation_name .. "]");
			for j = 0, current_num_frames - 1 do
				out.ui("\t\tframe " .. j .. ":");
				for k = 1, #animation_frame_data_types do
					local data_a, data_b, data_c, data_d = uic:GetAnimationFrameProperty(current_animation_name, j, animation_frame_data_types[k]);
					out.ui("\t\t\t" .. animation_frame_data_types[k] .. ": [" .. tostring(data_a) .. ", " .. tostring(data_b) .. ", " .. tostring(data_c) .. ", " .. tostring(data_d) .. "] ");
				end;
			end;
		end;
	end
	
	if not omit_children then
		out.ui("children:");
		
		out.inc_tab("ui");
		
		for i = 0, uic:ChildCount() - 1 do
			local child = UIComponent(uic:Find(i));
			
			out.ui(tostring(i) .. ": " .. child:Id());
		end;
	end;

	out.dec_tab("ui");
	out.dec_tab("ui");

	out.ui("");
end;


--- @function output_uicomponent_on_click
--- @desc Starts a listener which outputs debug information to the <code>Lua - UI</code> console spool about every uicomponent that's clicked on.
function output_uicomponent_on_click()	
	out.ui("*** output_uicomponent_on_click() called ***");
	
	core:add_listener(
		"output_uicomponent_on_click",
		"ComponentLClickUp",
		true,
		function(context) output_uicomponent(UIComponent(context.component), true) end,
		true
	);
end;


--- @function print_all_uicomponent_children
--- @desc Prints the name and path of the supplied uicomponent and all its descendents. Very verbose, and can take a number of seconds to complete.
--- @p [opt=uiroot] @uicomponent subject uic
--- @p [opt=false] @boolean full output
function print_all_uicomponent_children(uic, full_output)
	
	uic = uic or core:get_ui_root();

	if full_output then
		output_uicomponent(uic, true);
	else
		out.ui(uicomponent_to_str(uic));
	end;

	for i = 0, uic:ChildCount() - 1 do
		local uic_child = UIComponent(uic:Find(i));
		print_all_uicomponent_children(uic_child, full_output);
	end;
end;


--- @function pulse_uicomponent
--- @desc Activates or deactivates a pulsing highlight effect on a particular state of the supplied uicomponent. This is primarily used for scripts which activate when the player moves the mouse cursor over certain words in the help pages, to indicate to the player what UI feature is being talked about on the page.
--- @p uicomponent ui component, Subject ui component.
--- @p boolean should pulse, Set to <code>true</code> to activate the pulsing effect, <code>false</code> to deactivate it.
--- @p [opt=0] number brightness, Pulse brightness. Set a higher number for a more pronounced pulsing effect.
--- @p [opt=false] boolean progagate, Propagate the effect through the component's children. Use this with care, as the visual effect can stack and often it's better to activate the effect on specific uicomponents instead of activating this.
--- @p [opt=nil] string state name, Optional state name to affect. If no string state name is supplied here then the current state is used.
function pulse_uicomponent(uic, should_pulse, brightness_modifier, propagate, state_name)
	
	brightness_modifier = brightness_modifier or 0;
	silent = silent or false;

	if not is_uicomponent(uic) then
		script_error("ERROR: pulse_uicomponent() called but supplied uicomponent [" .. tostring(uic) .. "] is not a ui component");
		return false;
	end;

	if not uic:IsValid() then
		script_error("ERROR: pulse_uicomponent() called but supplied uicomponent [" .. tostring(uic) .. "] is no longer valid, has it been destroyed?");
		return false;
	end;
	
	if should_pulse then
		if state_name then
			uic:StartPulseHighlight(brightness_modifier, state_name);
		else
			uic:StartPulseHighlight(brightness_modifier);
		end;
	else
		if state_name then
			uic:StopPulseHighlight(state_name);
		else
			uic:StopPulseHighlight();
		end;
	end;
	
	if propagate then
		for i = 0, uic:ChildCount() - 1 do
			pulse_uicomponent(UIComponent(uic:Find(i)), should_pulse, brightness_modifier, propagate, state_name);
		end;
	end;
end;


--- @function is_fully_onscreen
--- @desc Returns true if the uicomponent is fully on-screen, false otherwise.
--- @p @uicomponent uicomponent
--- @r @boolean is onscreen
function is_fully_onscreen(uicomponent)
	local screen_x, screen_y = core:get_screen_resolution();
	
	local min_x, min_y = uicomponent:Position();
	local size_x, size_y = uicomponent:Bounds();
	local max_x = min_x + size_x;
	local max_y = min_y + size_y;
	
	return min_x >= 0 and max_x <= screen_x and min_y >= 0 and max_y <= screen_y;	
end;


--- @function is_partially_onscreen
--- @desc Returns true if the uicomponent is partially on-screen, false otherwise.
--- @p @uicomponent uicomponent
--- @r @boolean is onscreen
function is_partially_onscreen(uicomponent)
	local screen_x, screen_y = core:get_screen_resolution();
	
	local min_x, min_y = uicomponent:Position();
	local size_x, size_y = uicomponent:Bounds();
	local max_x = min_x + size_x;
	local max_y = min_y + size_y;
	
	return ((min_x >= 0 and min_x <= screen_x) or (max_x >= 0 and max_x <= screen_x)) and ((min_y >= 0 and min_y <= screen_y) or (max_y >= 0 and max_y <= screen_y));	
end;




--- @function set_component_visible
--- @desc Sets a uicomponent visible or invisible by its path. The path should be one or more strings which when sequentially searched for from the ui root lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean set visible
--- @p ... list of string names
function set_component_visible(visible, ...)
	local parent = core:get_ui_root();

	local arg_list = {};
	
	for i = 1, arg.n do
		table.insert(arg_list, arg[i]);
	end;
	
	local uic = find_uicomponent_from_table(parent, arg_list);
	
	if is_uicomponent(uic) then
		uic:SetVisible(not not visible);
	end;
end;


--- @function set_component_visible_with_parent
--- @desc Sets a uicomponent visible or invisible by its path. The path should be one or more strings which when sequentially searched for from a supplied uicomponent parent lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean set visible
--- @p uicomponent parent uicomponent
--- @p ... list of string names
function set_component_visible_with_parent(visible, parent, ...)
	local arg_list = {};
	
	for i = 1, arg.n do
		table.insert(arg_list, arg[i]);
	end;
	
	local uic = find_uicomponent_from_table(parent, arg_list)

	if is_uicomponent(uic) then
		uic:SetVisible(not not visible);
	end;
end;


--- @function set_component_active
--- @desc Sets a uicomponent to be active or inactive by its path. The path should be one or more strings which when sequentially searched for from the ui root lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean set active
--- @p ... list of string names
function set_component_active(is_active, ...)
	local parent = core:get_ui_root();
	
	local arg_list = {};
	
	for i = 1, arg.n do
		table.insert(arg_list, arg[i]);
	end;
	
	local uic = find_uicomponent_from_table(parent, arg_list);
	
	if is_uicomponent(uic) then
		set_component_active_action(is_active, uic);
	end;
end;


--- @function set_component_active_with_parent
--- @desc Sets a uicomponent to be active or inactive by its path. The path should be one or more strings which when sequentially searched for from a supplied uicomponent parent lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean set active
--- @p uicomponent parent uicomponent
--- @p ... list of string names
function set_component_active_with_parent(is_active, parent, ...)
	local arg_list = {};
	
	for i = 1, arg.n do
		table.insert(arg_list, arg[i]);
	end;
	
	local uic = find_uicomponent_from_table(parent, arg_list);
	
	if is_uicomponent(uic) then
		set_component_active_action(is_active, uic);
	end;
end;


-- for internal use
function set_component_active_action(is_active, uic)
	local active_str = nil;
	
	if is_active then
		active_str = "active";
	else
		active_str = "inactive";
	end;

	uic:SetState(active_str);
end;


--- @function highlight_component
--- @desc Highlights or unhighlights a uicomponent by its path. The path should be one or more strings which when sequentially searched for from the ui root lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean activate highlight, Set <code>true</code> to activate the highlight, <code>false</code> to deactivate.
--- @p boolean is square, Set to <code>true</code> if the target uicomponent is square, <code>false</code> if it's circular.
--- @p ... list of string names
function highlight_component(value, is_square, ...)
	return highlight_component_action(false, value, is_square, unpack(arg));
end;


--- @function highlight_visible_component
--- @desc Highlights or unhighlights a uicomponent by its path, but only if it's visible. The path should be one or more strings which when sequentially searched for from the ui root lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p boolean activate highlight, Set <code>true</code> to activate the highlight, <code>false</code> to deactivate.
--- @p boolean is square, Set to <code>true</code> if the target uicomponent is square, <code>false</code> if it's circular.
--- @p ... list of string names
function highlight_visible_component(value, is_square, ...)
	return highlight_component_action(true, value, is_square, unpack(arg));
end;


function highlight_component_action(visible_only, value, is_square, ...)
	local uic = find_uicomponent_from_table(core:get_ui_root(), arg);
	
	if is_uicomponent(uic) then
		if not visible_only or uic:Visible() then
			uic:Highlight(value, is_square, 0);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_all_visible_children
--- @desc Draws a box highlight around all visible children of the supplied uicomponent. A padding value in pixels may also be supplied to increase the visual space between the highlight and the components being highlighted.
--- @p uicomponent parent
--- @p [opt=0] number visual padding
function highlight_all_visible_children(uic, padding)
	
	if not is_uicomponent(uic) then
		script_error("ERROR: highlight_all_visible_children() called but supplied uicomponent [" .. tostring(uic) .. "] is not a uicomponent");
		return false;
	end;
	
	padding = padding or 0;
	
	local components_to_highlight = {};
	
	for i = 0, uic:ChildCount() - 1 do
		local uic_child = UIComponent(uic:Find(i));
			
		if uic_child:Visible() then
			table.insert(components_to_highlight, uic_child);
		end;
	end;
	
	highlight_component_table(padding, unpack(components_to_highlight));
end;


--- @function unhighlight_all_visible_children
--- @desc Cancels any and all highlights created with @global:highlight_all_visible_children.
function unhighlight_all_visible_children()
	unhighlight_component_table();
end;


--- @function highlight_component_table
--- @desc Draws a box highlight stretching around the supplied list of components. A padding value in pixels may also be supplied to increase the visual space between the highlight and the components being highlighted.
--- @p number visual padding, Visual padding in pixels.
--- @p ... uicomponents, Variable number of uicomponents to draw highlight over.
function highlight_component_table(padding, ...)
	
	local component_list = arg;

	if not is_number(padding) or padding < 0 then
		-- if the first parameter is a uicomponent then insert it at the start of our component list
		if is_uicomponent(padding) then
			table.insert(component_list, 1, padding);
			padding = 0;
		else
			script_error("ERROR: highlight_component_table() called but supplied padding value [" .. tostring(padding) .. "] is not a positive number (or a uicomponent)");
			return false;
		end;
	end;
	
	local min_x = 10000000;
	local min_y = 10000000;
	local max_x = 0;
	local max_y = 0;
	
	for i = 1, #component_list do
		local current_component = component_list[i];
		
		if not is_uicomponent(current_component) then
			script_error("ERROR: highlight_component_table() called but parameter " .. i .. " in supplied list is a [" .. tostring(current_component) .. "] and not a uicomponent");
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
	local ui_root = core:get_ui_root();
	
	local uic_dummy = find_uicomponent(ui_root, "highlight_dummy");
	
	if not uic_dummy then
		ui_root:CreateComponent("highlight_dummy", core.path_to_dummy_component);
		uic_dummy = find_uicomponent(ui_root, "highlight_dummy");
	end;
	
	if not uic_dummy then
		script_error("ERROR: highlight_component_table() cannot find uic_dummy, how can this be?");
		return false;
	end;
	
	-- resize and move the dummy
	local size_x = max_x - min_x;
	local size_y = max_y - min_y;
	
	-- uic_dummy:SetMoveable(true);
	uic_dummy:MoveTo(min_x, min_y);
	uic_dummy:Resize(size_x, size_y);
	
	local new_pos_x, new_pos_y = uic_dummy:Position();
	
	uic_dummy:Highlight(true, true, 0);
end;


--- @function unhighlight_component_table
--- @desc Cancels any and all highlights created with @global:highlight_component_table.
function unhighlight_component_table()
	highlight_component(false, true, "highlight_dummy");
end;


--- @function play_component_animation
--- @desc Plays a specified component animation on a uicomponent by its path. The path should be one or more strings which when sequentially searched for from the ui root lead to the target uicomponent (see documentation for @global:find_uicomponent_from_table, which performs the search).
--- @p string animation name
--- @p ... list of string names
function play_component_animation(animation, ...)
	
	local uic = find_uicomponent_from_table(core:get_ui_root(), arg, true);
	
	if is_uicomponent(uic) then
		uic:TriggerAnimation(animation);
	end;
end;


--- @function uicomponent_has_parent_filter
--- @desc Returns <code>true</code> if the supplied uicomponent has a parent or ancestor that matches the supplied filter, or <code>false</code> otherwise. The filter should be a function that accepts a uicomponent as a single argument and returns <code>true</code> or <code>false</code> depending on whether the uicomponent passes the filter. The first matching ancestor is also returned.
--- @p @uicomponent uicomponent
--- @p @function filter
--- @r @boolean uic parent passes filter
--- @r @uicomponent first matching ancestor
function uicomponent_has_parent_filter(uic, filter)
	while true do
		uic = uic:Parent();

		if not uic then
			return false;
		end;

		uic = UIComponent(uic);

		if filter(uic) then
			return true, uic;
		end;
	end;
end;
















----------------------------------------------------------------------------
---	@section Advisor Progress Button
----------------------------------------------------------------------------


--- @function get_advisor_progress_button
--- @desc Returns the advisor progress/close button uicomponent.
--- @r uicomponent
function get_advisor_progress_button()
	local uic_progress_button = false;
		
	if __game_mode == __lib_type_battle then
		uic_progress_button = find_uicomponent(core:get_ui_root(), "advice_interface", "button_close");
	elseif __game_mode == __lib_type_campaign then
		uic_progress_button = find_uicomponent(core:get_ui_root(), "advice_interface", "button_close");
	else
		script_error("ERROR: get_advisor_progress_button() called in frontend");
		return false;
	end;
	
	if not uic_progress_button then
		script_error("ERROR: get_advisor_progress_button() called but couldn't find advisor button");
		return false;
	end;
	
	return uic_progress_button;
end;


--- @function show_advisor_progress_button
--- @desc Shows or hides the advisor progress/close button.
--- @p [opt=true] boolean show button
function show_advisor_progress_button(value)
	if value ~= false then
		value = true;
	end;
		
	local uic_button = get_advisor_progress_button();
	
	if uic_button then
		uic_button:SetVisible(value);
	end;
	
	-- If we're not showing the button then disable the advisor button on the menu bar, and reinstate it when the advisor panel closes
	if not value then
		set_component_active(false, "menu_bar", "button_show_advice");
		core:add_listener(
			"show_advisor_progress_button",
			"AdviceDismissed",
			true,
			function(context)
				set_component_active(true, "menu_bar", "button_show_advice");
			end,
			false
		);
	end;
end;


--- @function highlight_advisor_progress_button
--- @desc Activates or deactivates a highlight on the advisor progress/close button.
--- @p [opt=true] boolean show button
function highlight_advisor_progress_button(value)
	if __game_mode == __lib_type_frontend then
		script_error("ERROR: highlight_advisor_progress_button() called when not in battle or campaign");
		return false;
	end;
	
	highlight_component(value, false, "advice_interface", "button_close");
	set_component_visible(value, "advice_interface", "tut_anim");
end;









----------------------------------------------------------------------------
-- We sometimes use table.tostring() to serialise a table when saving a game,
-- and then loadstring() to recreate it from its string. If the table contains
-- strings that contain certain special characters, however, loadstring() fails to
-- parse the string. To work around this we do a find/replace on each string
-- in the table before it's saved and swap out special characters for character
-- sequences (see the mapping below). When the table is loaded, we reverse the
-- process. This is pretty yucky.
----------------------------------------------------------------------------

local special_chars_to_replacement_mapping_for_saving_game = {
	["\""] = "&quot;",
	["\'"] = "&apos;",
	["\n"] = "&nl;",
	["\\"] = "&bs;"
};

local replacement_to_special_char_mapping_for_loading_game = {};
for key, value in pairs(special_chars_to_replacement_mapping_for_saving_game) do
	replacement_to_special_char_mapping_for_loading_game[value] = key;
end;

function string_special_chars_pre_save_fixup(str)
	for search_term, replacement in pairs(special_chars_to_replacement_mapping_for_saving_game) do
		str = string.gsub(str, search_term, replacement);
	end;
	return str;
end;

function string_special_chars_post_load_fixup(str)
	for search_term, replacement in pairs(replacement_to_special_char_mapping_for_loading_game) do
		str = string.gsub(str, search_term, replacement);
	end;
	return str;
end;





----------------------------------------------------------------------------
--	String Extensions
--	http://lua-users.org/wiki/StringRecipes
--
--	starts_with
--		example:
--			local mystring = "hello world";
--			local bool_hello = mystring:starts_with("hello");
--
--	ends_with
--		example:
--			local mystring = "hello world";
--			local bool_world = mystring:ends_with("world");
--
----------------------------------------------------------------------------
function string.starts_with(input, start_str)
   return string.sub(input, 1, string.len(start_str)) == start_str
end

function string.ends_with(input, end_str)
   return end_str == '' or string.sub(input, -string.len(end_str)) == end_str
end

----------------------------------------------------------------------------
--	Math Extensions
----------------------------------------------------------------------------
function math.ceilTo(value, nearest)
    nearest = nearest or 10;
    return math.ceil(value * (1 / nearest) ) * nearest;
end

function math.floorTo(value, nearest)
    nearest = nearest or 10;
    return math.floor(value * (1 / nearest) ) * nearest;
end

function math.clamp(value, minv, maxv)
	if value > maxv then
		return maxv;
	end
	if value < minv then
		return minv;
	end
	return value;
end

function math.computeCentroid(vertices)
	local x, y, area, k = 0,0,0,0;
	local a, b = nil, vertices[#vertices - 1];

	for i = 1, #vertices do
		a = vertices[i];
		k = a.y * b.x - a.x * b.y;
		area = area + k;
		x = x + ((a.x + b.x) * k);
		y = y + ((a.y + b.y) * k);
		b = a;
	end

	area = area * 3;
	return {x = x / area, y = y / area};
end

function math.round(value)
	return value % 1 >= 0.5 and math.ceil(value) or math.floor(value);
end;