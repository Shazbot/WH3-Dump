


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	SCRIPTED TOURS
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c scripted_tour Scripted Tours
--- @desc A scripted tour is a linear section of scripted gameplay where the script locks all player interaction with the game barring the minimum necessary for the player to perform a series of actions, generally with a fullscreen highlight to focus the players attention on one portion of the screen. This is most commonly used for tutorial scripting - the actions in this case would be the player acknowledging advice and @text_pointer objects and clicking on UI items as they are instructed to. This scripted_tour class allows a scripted tour (or a scripted tour segment, as multiple tour objects may be strung together to form what the player might call a single 'scripted tour') to be set up relatively easily.
--- @desc As an example, a scripted tour may be triggered when the player first gains a character skill point. Normal interaction is stopped at this point, with the script showing a sequence of advice to the player and compelling them to perform a series of steps (dismissing advice and/or clicking on highlighted ui buttons). Once the player has performed that series of steps then control is released back to them.
--- @desc An example screenshot of a scripted tour:
--- @desc <img alt="scripted tour" width=650px" src="../images/scripted_tour.jpg" \>
--- @desc This scripted tour mechanism provides a relatively easy interface to establish a fullscreen highlight around a portion of the user interface to better highlight to the player what section of the screen they should be looking at. With a fullscreen highlight visible the scripted tour mechanism also supports displaying a skip button, allowing the player to skip through tour content.
--- @desc If a scripted tour is intended to be shown during live campaign gameplay then it's strongly recommended to always trigger it from within an @intervention in order to control the flow of events around the tour that is triggering. Scripted tours may be triggered in battle and the frontend, but are primarily intended for use in campaign.
--- @desc Action callbacks may be added to a scripted tour along with a time offset at which they should be called with @scripted_tour:action. These actions are called at the supplied times when the tour is started. Multiple 'sequences' of actions may be specified for a single scripted tour, as a given tour will often have to wait for an indeterminate period for a player response before continuing - the actions that come after the player response would be laid out in a different sequence to those coming before.
--- @desc Once constructed, a tour (or a particular sequence within the tour) may be started with @scripted_tour:start.
--- @desc When a scripted tour finishes it will trigger the script event <code>ScriptEventScriptedTourCompleted</code>, with the scripted tour name as the context string.


--- @section At A Glance
--- @desc Each scripted tour must be declared with @scripted_tour:new. A name and a function to call when the tour ends (or is skipped) must be specified here.
--- @desc Once declared, actions may be added to the tour with @scripted_tour:action. Each action is a function to be called at some timed interval after the tour has started. It is through actions that events during the tour occur, such advice being displayed and buttons being highlighted. By specifying a sequence name when declaring actions, an action may be added to a specific action sequence within the tour. Action sequences may be used to group actions together. It's common that a scripted tour is made of several short segments of actions that commences when the player makes a certain input.
--- @desc A fullscreen highlight can be added over one or more ui components during the tour with @scripted_tour:add_fullscreen_highlight. A delay may be set so this highlight doesn't appear as soon as the tour starts with @scripted_tour:set_fullscreen_highlight_delay.
--- @desc The skip button can be shown or hidden with @scripted_tour:show_skip_button, or moved around the screen with @scripted_tour:move_skip_button. Functions to call if the scripted tour is skipped may be added with @scripted_tour:add_skip_action and removed again with @scripted_tour:remove_skip_action.
--- @desc Once a scripted tour is declared and configured it may be started with @scripted_tour:start. Supply no arguments to this function to start the main action sequence, or specify a name to start a particular action sequence.
--- @desc Once a sequence is started it must be ended by calling @scripted_tour:complete_sequence with the name of the sequence. All running sequences and the tour as a whole may be ended by calling @scripted_tour:complete. Alternatively, the tour ends immediately if the player clicks on the skip button or if @scripted_tour:skip is called. The tour must be ended by calling @scripted_tour:complete or @scripted_tour:skip after it has been started.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


scripted_tour = {
	name = "",													-- unique string name for this scripted tour
	end_callback = false,										-- function to call when this scripted tour ends
	action_list = {},											-- list of actions to perform during scripted tour
	skip_actions = {},											-- list of cleanup functions to call if the scripted tour is skipped
	validation_rules = {},										-- a list of validation rules that must all return true for this tour to start
	fullscreen_highlight_paths = {},							-- list of paths-to-components to perform a fullscreen highlight over while this scripted tour is active
	fullscreen_highlight_delay = 0,								-- delay between starting the tour and activating the fullscreen highlight. Given in seconds in campaign and ms in battle. Set to a negative number to not automatically show the fullscreen highlight.
	fullscreen_highlight_active = false,						-- the fullscreen highlight is currently visible
	fullscreen_highlight_padding = 25,							-- visible padding between the fullscreen highlight and the components it highlights in pixels
	allow_fullscreen_highlight_window_interaction = true,		-- sets whether the fullscreen highlight should allow central window interaction
	should_show_skip_button = true,								-- flag to indicate whether the skip option is/should be shown
	skip_button_position = false,								-- indicates that a corner of the screen has been specified for the skip button position. Default value will be set to "br" later.
	skip_button_position_x = false,								-- indicates that an x/y position has been specified for the skip button position
	skip_button_position_y = false,								-- indicates that an x/y position has been specified for the skip button position
	skip_button_shown = false,									-- skip button is currently visible
	is_running = false,											-- flag to indicate whether this scripted tour is currently running
	skip_button_screen_edge_padding = 50,						-- desired padding between the screen edge and the skip button
	should_hide_text_pointers_on_completion = true,				-- all visible text pointers should hide automatically when the tour completes
	should_dismiss_advice_on_completion = true,					-- advice should be dismissed when the tour completes
	allow_camera_movement = false,								-- sets whether the player should be able to move the camera while the tour is active. Currently battle-only.
	last_validation_state = true,								-- validation state when is_currently_valid was last called
	last_validation_reason = nil,								-- validation reason when is_currently_valid was last called
	cached_infotext_attached_to_advisor = true					-- cached state of infotext <-> advisor attachment at the start of the tour, which we will restore at the end
}


set_class_custom_type(scripted_tour, TYPE_SCRIPTED_TOUR);
set_class_tostring(
	scripted_tour,
	function(obj)
		return TYPE_SCRIPTED_TOUR .. "_" .. obj.name
	end
);






----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a scripted tour object. Each scripted tour must be given a unique string name and, optionally, an end callback which will be called when the scripted tour ends or is skipped.
--- @p @string name, Unique name for the scripted tour.
--- @p [opt=false] @function end callback, End callback.
--- @r scripted_tour scripted tour
function scripted_tour:new(name, end_callback)
	if not is_string(name) then
		script_error("ERROR: scripted_tour:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if end_callback and not is_function(end_callback) then
		script_error("ERROR: scripted_tour:new() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local st = {};
	
	st.name = "scripted_tour_" .. name;

	set_object_class(st, self);
	
	st.end_callback = end_callback;
	
	st.action_list = {};
	st.skip_actions = {};
	st.validation_rules = {};
	st.fullscreen_highlight_paths = {};
	
	return st;
end;











----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once a <code>scripted_tour</code> object has been created with @scripted_tour:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;scripted_tour_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local st = scripted_tour:new(
--- @example 	"deployment",
--- @example 	function() end_deployment_scripted_tour() end
--- @example );
--- @example 
--- @example st_deployment:add_validation_rule(		-- calling a function on the object once created
--- @example 	function()
--- @example 		return bm:get_current_phase_name() == "Deployment";
--- @example 	end,
--- @example 	"not in deployment phase"
--- @example );











----------------------------------------------------------------------------
--- @section Validation
--- @desc Validation rules may be built into a scripted tour using @scripted_tour:add_validation_rule, to allow it to know when it can be triggered. Validation rules added to a scripted tour are checked when that tour is started with @scripted_tour:start, and should any fail then the scripted tour will fail to trigger.
--- @desc Client scripts may also ask a scripted tour whether it is currently valid to trigger by calling @scripted_tour:is_currently_valid. Should the tour not currently be valid then a reason value, supplied to @scripted_tour:add_validation_rule when the rule is established, is returned to the calling script. This can be used by UI scripts, for example, to determine whether to enable or disable a scripted tour button, and to customise its appearance (e.g. change the tooltip) to indicate a reason why the tour can't currently be triggered.
--- @desc Furthermore, context change listeners may be added to a scripted tour with @scripted_tour:add_validation_context_change_listener by which a scripted tour may listen for events that may indicate its validation state changing. Should a scripted tour detect that a context change has altered its validation state it will trigger the script event <code>ScriptEventScriptedTourValidationStateChanged</code> which can be listened for by scripts elsewhere.
----------------------------------------------------------------------------


--- @function add_validation_rule
--- @desc Adds a validation callback. The supplied function will be called when the scripted tour is triggered with @scripted_tour:start, or validated with @scripted_tour:is_currently_valid, and it must return a boolean value that indicates whether the validation rule passes.
--- @desc Validation rules are checked in the same order in which they are added.
--- @p @function callback, Validation function.
--- @p value reason, Reason value. This can be a value of any type. It will be returned to scripts that call @scripted_tour:is_currently_valid if this validation rule fails.
function scripted_tour:add_validation_rule(callback, reason_value)
	if not is_function(callback) then
		script_error(self.name .. ":add_validation_rule() called but supplied validation rule callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	local validation_rule_record = {
		callback = callback,
		reason_value = reason_value
	};

	table.insert(self.validation_rules, validation_rule_record);
end;


--- @function add_validation_context_change_listener
--- @desc Starts a listener for the supplied scripted event. Should it be received, and should the optional condition also pass, the current validation state is checked against that previously cached. If the validation state has changed then the <code>ScriptEventScriptedTourValidationStateChanged</code> is triggered which scripts elsewhere can listen for and react to. This allows UI scripts that may be displaying an option to launch a scripted tour to update the state of that launch option as the game context changes.
--- @p @string event name, Name of script event to monitor.
--- @p [opt=true] @function condition, Condition to check if the event is received. 
function scripted_tour:add_validation_context_change_listener(event, condition)
	if not is_string(event) then
		script_error(self.name .. " ERROR: add_validation_context_change_listener() called but supplied event name [" .. tostring(event) .. "] is not a string");
		return false;
	end;

	if condition == nil then
		condition = true;
	elseif not is_function(condition) and not condition == true then
		script_error(self.name .. " ERROR: add_validation_context_change_listener() called but supplied event condition [" .. tostring(condition) .. "] is not, nil, true or a function");
		return false;
	end;

	core:add_listener(
		self.name,
		event,
		condition,
		function()
			local last_validation_state = self.last_validation_state;
			local last_validation_reason = self.last_validation_reason;

			local current_validation_state, current_validation_reason = self:is_currently_valid();

			if current_validation_state ~= last_validation_state or current_validation_reason ~= last_validation_reason then
				core:trigger_event("ScriptEventScriptedTourValidationStateChanged", self.name);
			end;
		end,
		true
	);
end;


--- @function is_currently_valid
--- @desc Checks whether this scripted tour is currently able to trigger. If the tour is not currently valid to trigger then the reason specified when setting the rule up with @scripted_tour:add_validation_rule is returned.
--- @r @boolean currently valid
--- @r value reason value if invalid
function scripted_tour:is_currently_valid()
	for i = 1, #self.validation_rules do
		if not self.validation_rules[i].callback() then
			local reason_value = self.validation_rules[i].reason_value;
			self.last_validation_state = false;
			self.last_validation_reason = reason_value;

			return false, reason_value;
		end;
	end;

	self.last_validation_state = true;
	self.last_validation_reason = nil;

	return true, true;
end;









----------------------------------------------------------------------------
--- @section Enqueuing Actions
--- @desc Actions must be added to a scripted tour if it is to do anything. Action callbacks added to a tour are called by that tour once the tour is started with @scripted_tour:start. Actions are added with an action time, which specifies how long the scripted tour should wait after being started before calling the action. Pending actions are cancelled when a tour is skipped or completed, so if this happens before an action is called then it will never be called.
--- @desc Actions may optionally be added to a 'sequence' by specifying a string sequence name when calling @scripted_tour:action. Different sequences in a scripted tour may be started by calling @scripted_tour:start with the sequence name.
----------------------------------------------------------------------------


--- @function action
--- @desc Adds an action to the scripted tour to be called at a specified time after the scripted tour starts. If no sequence is specified then the action is added to the main tour sequence, otherwise the action will be added to the sequence given.
--- @p function callback, Callback function to call.
--- @p number interval, Interval after the scripted tour starts at which the specified action should be triggered. This should be given in seconds in campaign, and in ms in battle and the frontend.
--- @p [opt=nil] string sequence, Sequence to add the action to. If no sequence name is specified then the action will be added to the main sequence.
function scripted_tour:action(action, action_time, sequence_name)
	if self.is_running then
		script_error(self.name .. " ERROR:action() called but the scripted tour is currently running");
		return false;
	end;
	
	if not is_function(action) then
		script_error(self.name .. " ERROR: action() called but the supplied action [" .. tostring(action) .. "] is not a function");
		return false;
	end;
	
	if not is_number(action_time) or action_time < 0 then
		script_error(self.name .. " ERROR: action() called but the supplied action time [" .. tostring(action_time) .. "] is not a positive number");
		return false;
	end;
	
	if sequence_name then
		if not is_string(sequence_name) then
			script_error(self.name .. " ERROR: action() called but the supplied sequence name [" .. tostring(sequence_name) .. "] is not a string");
			return false;
		end;
	else
		sequence_name = "default";				-- default sequence
	end;
	
	local action_record = {
		action = action,
		action_time = action_time
	};
	
	-- create the action list for this sequence if it has not already been created
	if not self.action_list[sequence_name] then
		self.action_list[sequence_name] = {};
	end;
	
	-- insert this action record in the correct chronological place in the action list
	local action_list_for_sequence = self.action_list[sequence_name];
		
	for i = 1, #action_list_for_sequence do
		if action_list_for_sequence[i].action_time > action_time then
			table.insert(action_list_for_sequence, i, action_record);
			return;
		end;
	end;
	
	table.insert(action_list_for_sequence, action_record);
end;


--- @function append_action
--- @desc Adds an action to the scripted tour to be called at the same time as the last currently-registered action of the specified sequence. If no sequence is specified then the action is added to the main tour sequence, otherwise the action will be added to the sequence given. If additional actions are added after <code>append_action</code> is called 
--- @p function callback, Callback function to call.
--- @p number interval, Interval after the scripted tour starts at which the specified action should be triggered. This should be given in seconds in campaign, and in ms in battle and the frontend.
--- @p [opt=nil] string sequence, Sequence to add the action to. If no sequence name is specified then the action will be added to the main sequence.
function scripted_tour:append_action(action, sequence_name)

	if not is_function(action) then
		script_error(self.name .. " ERROR: append_action() called but supplied action [" .. tostring(action) .. "] is not a function");
		return false;
	end;

	if sequence_name then
		if not is_string(sequence_name) then
			script_error(self.name .. " ERROR: append_action() called but supplied sequence name [" .. tostring(sequence_name) .. "] is not a string or nil");
			return false;
		end;
	else
		sequence_name = "default";
	end;

	-- create the action list for this sequence if it has not already been created
	if not self.action_list[sequence_name] then
		self.action_list[sequence_name] = {};
	end;

	local action_list_for_sequence = self.action_list[sequence_name];

	local last_action_time = 0;
	for i = #action_list_for_sequence, 1, -1 do
		if action_list_for_sequence[i].action_time > last_action_time then
			last_action_time = action_list_for_sequence[i].action_time;
		end;
	end;

	self:action(action, last_action_time, sequence_name);
end;









----------------------------------------------------------------------------
--- @section Fullscreen Highlight
--- @desc The scripted tour may be instructed to put a fullscreen highlight around one or more uicomponents when the tour starts. Components to highlight may be added by their path with @scripted_tour:add_fullscreen_highlight. Multiple calls may be made to this function to add multiple components to highlight. The highlighting is performed with @core:show_fullscreen_highlight_around_components, see documentation on that function for more information.
--- @desc Should any fullscreen highlight components be added to the scripted tour then a fullscreen highlight will be placed over them when the tour starts. The creation of the fullscreen highlight may be delayed with @scripted_tour:set_fullscreen_highlight_delay. Set a negative delay here to prevent the fullscreen highlight from being created automatically - in this case, external scripts may show or hide the fullscreen highlight manually with @scripted_tour:show_fullscreen_highlight.
----------------------------------------------------------------------------


--- @function add_fullscreen_highlight
--- @desc Specifies a component to extend a fullscreen highlight over, by elements within its string path. Supply one or more strings that specify a path to the component, read left to right.
--- @p ... path, One or more strings specifying a path to a uicomponent
--- @new_example Add the 'mid' component (child of 'popup_pre_battle') to the fullscreen highlight
--- @example tour:add_fullscreen_highlight("popup_pre_battle", "mid")
function scripted_tour:add_fullscreen_highlight(...)
	if arg.n == 0 then
		script_error(self.name .. " ERROR: add_fullscreen_highlight() called but no component path has been supplied. One or more strings specifying a component path should be supplied");
		return false;
	end;
	
	local fullscreen_highlight_record = {};
	
	-- copy the supplied path into the fullscreen_highlight_record so our record isn't affected by what any client scripts do after this function returns
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error(self.name .. " ERROR: add_fullscreen_highlight() called but component path element " .. i .. " is not a string, its value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;
		
		fullscreen_highlight_record[i] = arg[i];
	end;
	
	table.insert(self.fullscreen_highlight_paths, fullscreen_highlight_record);
end;


--- @function set_fullscreen_highlight_delay
--- @desc Sets a delay between the scripted tour starting and the fullscreen highlight being activated. If a negative number is set then the fullscreen highlight will not activate automatically - in this case client scripts may activate/deactivate it manually with @scripted_tour:show_fullscreen_highlight.
--- @desc The delay should be given in seconds in campaign, but ms in battle or the frontend.
--- @p number delay
function scripted_tour:set_fullscreen_highlight_delay(delay)
	if not is_number(delay) then
		script_error(self.name .. " ERROR: set_fullscreen_highlight_delay() called but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	self.fullscreen_highlight_delay = delay;	
end;


--- @function set_fullscreen_highlight_padding
--- @desc Sets a padding value in pixels between the visible fullscreen highlight and the uicomponents it surrounds. This value is passed to the underlying @core:show_fullscreen_highlight_around_components function. This should already be set to a sensible default - call this function can be used to override this.
--- @p number padding, Padding value in pixels
function scripted_tour:set_fullscreen_highlight_padding(value)
	if not is_number(value) or value < 0 then
		script_error(self.name .. " ERROR: set_fullscreen_highlight_padding() called but supplied padding value [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.fullscreen_highlight_padding = value;
end;


--- @function set_allow_fullscreen_highlight_window_interaction
--- @desc Sets whether the fullscreen highlight central window should allow interaction with the components it shows. Interaction is allowed by default, meaning components shown within the window will respond to mouse events - use this function to disable this interaction.
--- @p [opt=true] boolean allow interaction
function scripted_tour:set_allow_fullscreen_highlight_window_interaction(value)
	if value == false then
		self.allow_fullscreen_highlight_window_interaction = false;
	else
		self.allow_fullscreen_highlight_window_interaction = true;
	end;
end;


--- @function show_fullscreen_highlight
--- @desc Enables or disables a fullscreen highlight over the uicomponents previously specified with @scripted_tour:add_fullscreen_highlight. This is called automatically by the scripted tour at some point after the tour starts, unless it has been disabled by supplying a negative number to @scripted_tour:set_fullscreen_highlight_delay. It may also be called by external scripts to manually enable/disable the fullscreen highlight - this isn't necessary in most cases, however.
--- @p boolean should show
function scripted_tour:show_fullscreen_highlight(should_show)
	if not self.is_running then
		script_error(self.name .. " WARNING: show_fullscreen_highlight() called but this scripted tour is not running");
		return false;
	end;

	if should_show then
		if not self.fullscreen_highlight_active then
		
			-- don't proceed if we have no components to put a fullscreen highlight over
			if #self.fullscreen_highlight_paths == 0 then
				return;
			end;
		
			-- show the fullscreen highlight
			self.fullscreen_highlight_active = true;
			
			local ui_root = core:get_ui_root();
			
			-- get a list of uicomponents corresponding to all the paths this scripted_tour has been given
			local uicomponents = {};
			for i = 1, #self.fullscreen_highlight_paths do
				local current_path = self.fullscreen_highlight_paths[i];
			
				local current_uic = find_uicomponent_from_table(ui_root, current_path);
				
				if not current_uic then
					-- this uicomponent was not found, assemble an error message and exit
					local err_str = "";
					
					for j = 1, #current_path do
						if j == 1 then
							err_str = current_path[j];
						else
							err_str = err_str .. " > " .. current_path[j];
						end;
					end;
				
					script_error(self.name .. " ERROR: show_fullscreen_highlight() couldn't find supplied component [" .. i .. "] with path " .. err_str);
					return false;
				end;
				
				table.insert(uicomponents, current_uic);
			end;
			
			core:show_fullscreen_highlight_around_components(self.fullscreen_highlight_padding, false, self.allow_fullscreen_highlight_window_interaction, unpack(uicomponents));
			
			-- set the advisor to be topmost so it appears over the top of any fullscreen highlight
			core:cache_and_set_advisor_priority(1500, true);
			
			-- show skip option if we should
			if self.should_show_skip_button then
				core:get_tm():callback(
					function()
						self:show_skip_button(true);
					end,
					core:is_campaign() and 0.5 or 500,
					self.name .. "_action"
				);
			else
				-- we're not showing the skip button, so block the ESC key

				if core:is_campaign() then
					cm:steal_escape_key_with_callback(
						self.name .. "_esc_blocker",
						function()
							-- do nothing
						end,
						true									-- persistent
					);
				else
					bm:steal_escape_key_with_callback(
						self.name .. "_esc_blocker",
						function()
							-- do nothing
						end,
						true									-- persistent
					);
				end;
			end;
		end;
	
	else
		if self.fullscreen_highlight_active then
			-- hide the fullscreen highlight
			self.fullscreen_highlight_active = false;
			
			core:hide_fullscreen_highlight();
			
			-- set the advisor priority back to normal
			core:restore_advisor_priority();
			
			-- hide the skip button
			self:show_skip_button(false);
		end;
	end;
end;







----------------------------------------------------------------------------
--- @section Skip Button
--- @desc If a fullscreen highlight is visible then the scripted tour will display a skip button by default. The following functions control the visibility, on-screen position and functionality of the skip button.
--- @desc The tour will be skippable with the ESC key if a skip button is shown, and won't be skippable if it isn't.
----------------------------------------------------------------------------


-- Stops any listeners for the skip button being clicked. For internal use only.
function scripted_tour:stop_skip_button_listeners()
	local name = self.name .. "_skip_button_listener";

	if core:is_battle() then
		bm:release_escape_key_with_callback(name);

		-- also unblock the escape key in case we've blocked it
		bm:release_escape_key_with_callback(self.name .. "_esc_blocker");
	elseif core:is_campaign() then
		cm:release_escape_key_with_callback(name);

		-- also unblock the escape key in case we've blocked it
		cm:release_escape_key_with_callback(self.name .. "_esc_blocker");
	end;
	
	core:remove_listener(name);
end;


--- @function get_skip_button_container
--- @desc Creates the skip button if it has not been created before, or gets a handle to it if it has, and returns that handle. This is mainly for internal use but could feasibly be used externally. The skip button and its container will be invisible until made visible by the normal working of the scripted tour system.
--- @r uicomponent skip button container
function scripted_tour:get_skip_button_container()
	return core:get_or_create_component("scripted_tour_skip_button", "UI/Common UI/scripted_tour_skip_button.twui.xml");
end;


--- @function set_show_skip_button
--- @desc Sets whether the skip button should be shown when a fullscreen highlight is enabled. By default the skip button is shown - use this function to suppress this behaviour.
--- @p [opt=true] boolean should show
function scripted_tour:set_show_skip_button(value)
	if value == false then
		self.should_show_skip_button = false;
	else
		self.should_show_skip_button = true;
	end;
end;


--- @function add_skip_action
--- @desc Adds a skip action to the scripted tour, which will be called if the scripted tour is skipped (but not called if it is completed normally). An optional name may be added for the skip action, by which it may be removed later.
--- @p function skip action, Skip callback to call if this scripted tour is skipped.
--- @p [opt=nil] string name, Name for this skip action.
function scripted_tour:add_skip_action(skip_action, name)
	if not is_function(skip_action) then
		script_error(self.name .. " ERROR: add_skip_action() called but supplied callback [" .. tostring(skip_action) .. "] is not a function");
		return false;
	end;
	
	if name and not is_string(name) then
		script_error(self.name .. " ERROR: add_skip_action() called but supplied cancellation name [" .. tostring(name) .. "] is not a string or nil");
		return false;
	end;
	
	local skip_action_record = {
		skip_action = skip_action,
		name = name
	};
	
	table.insert(self.skip_actions, skip_action_record);
end;


--- @function remove_skip_action
--- @desc Remove a skip action from the scripted tour by name. If multiple skip actions share the same name then all will be removed.
--- @p string name
function scripted_tour:remove_skip_action(name)
	if not is_string(name) then
		script_error(self.name .. " ERROR: remove_skip_action() called but supplied cancellation name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	for i = #self.skip_actions, 1, -1 do
		if self.skip_actions[i].name == name then
			table.remove(self.skip_actions, i);
		end;
	end;
end;


--- @function clear_skip_actions
--- @desc Removes any skip actions currently associated with this scripted tour.
function scripted_tour:clear_skip_actions()
	self.skip_actions = {};
end;


--- @function show_skip_button
--- @desc Manually shows or hides the skip button while the scripted tour is running. Generally this should not be called externally, as the scripted_tour will show the skip and hide the skip button automatically along with the fullscreen highlight.
--- @p boolean should show
function scripted_tour:show_skip_button(should_show)
	if not self.is_running then
		script_error(self.name .. " WARNING: show_skip_button() called but this scripted tour is not running");
		return false;
	end;

	local uic_skip_button_container = self:get_skip_button_container();
	
	if not uic_skip_button_container then
		script_error(self.name .. " WARNING: show_skip_button() called but could not find resulting scripted_tour_skip_button uicomponent - how can this be?")
		return false;
	end;
	
	if should_show then
		if not self.skip_button_shown then
			-- we've been told to show the skip button and it's not currently being shown, so show it
		
			self.skip_button_shown = true;
			
			-- set the priority of the skip button container so that it appears above the fullscreen highlight
			uic_skip_button_container:PropagatePriority(1500);
			uic_skip_button_container:RegisterTopMost();
			
			-- show the skip button container
			uic_skip_button_container:SetVisible(true);
			uic_skip_button_container:TriggerAnimation("show");
					
			-- establish a listener for the skip button being clicked
			core:add_listener(
				self.name .. "_skip_button_listener",
				"ComponentLClickUp",
				function(context) return context.string == "button_skip_tour" and uicomponent_descended_from(UIComponent(context.component), "scripted_tour_skip_button") end,
				function()
					self:stop_skip_button_listeners();
					self:skip();
				end,
				false			
			);
			
			if core:is_battle() then
				bm:steal_escape_key_with_callback(
					self.name .. "_skip_button_listener",
					function()
						self:stop_skip_button_listeners();
						self:skip();
					end
				);
			elseif core:is_campaign() then
				cm:steal_escape_key_with_callback(
					self.name .. "_skip_button_listener",
					function()
						self:stop_skip_button_listeners();
						self:skip();
					end
				);
			end;
		end;	
	else
		if self.skip_button_shown then
			-- we've been told to hide the skip button and it's currently being shown, so hide it
		
			self.skip_button_shown = false;
			
			self:stop_skip_button_listeners();
			
			-- hide the skip button container
			uic_skip_button_container:TriggerAnimation("hide");
		end;
	end;
end;


--- @function move_skip_button
--- @desc Moves the skip button to a supplied position on the screen. This position can be specified by numeric x/y screen co-ordinates, or by a string specifying a position. Recognised strings:
--- @desc <table class="simple"><tr><td><code>tl</code></td><td>top-left corner</td></tr><tr><td><code>tr</code></td><td>top-right corner</td></tr><tr><td><code>bl</code></td><td>bottom-left corner</td></tr><tr><td><code>br</code></td><td>bottom-right corner</td></tr></table>
--- @desc By default the skip button will appear in the bottom-right corner of the screen. This function may be called before the scripted tour starts to set skip button position prior to it being shown, or while the scripted tour is running to move it.
--- @p boolean should show
function scripted_tour:move_skip_button(x, y)
	local uic_skip_button_container = self:get_skip_button_container();
	
	if not uic_skip_button_container then
		script_error(self.name .. " WARNING: move_skip_button() called but could not find resulting scripted_tour_skip_button uicomponent - how can this be?")
		return false;
	end;
	
	local screen_width, screen_height = core:get_screen_resolution();
	local uic_width, uic_height = uic_skip_button_container:Dimensions();
	
	-- handle the first argument being a supported screen-corner string
	if x == "tl" then
		self.skip_button_position = x;
		self.skip_button_position_x = false;
		self.skip_button_position_y = false;
		
		uic_skip_button_container:MoveTo(self.skip_button_screen_edge_padding, self.skip_button_screen_edge_padding);
		
	elseif x == "tr" then
		self.skip_button_position = x;
		self.skip_button_position_x = false;
		self.skip_button_position_y = false;
		
		uic_skip_button_container:MoveTo(screen_width - (self.skip_button_screen_edge_padding + uic_width), self.skip_button_screen_edge_padding);
		
		
	elseif x == "bl" then
		self.skip_button_position = x;
		self.skip_button_position_x = false;
		self.skip_button_position_y = false;
		
		uic_skip_button_container:MoveTo(self.skip_button_screen_edge_padding, screen_height - (self.skip_button_screen_edge_padding + uic_height));
		
	elseif x == "br" then
		self.skip_button_position = x;
		self.skip_button_position_x = false;
		self.skip_button_position_y = false;
		
		uic_skip_button_container:MoveTo(screen_width - (self.skip_button_screen_edge_padding + uic_width), screen_height - (self.skip_button_screen_edge_padding + uic_height));
		
	elseif is_number(x) and x > 0 and is_number(y) and y > 0 then
		self.skip_button_position = false;
		self.skip_button_position_x = x;
		self.skip_button_position_y = y;
		
		uic_skip_button_container:MoveTo(x, y);
	else
		script_error(self.name .. " ERROR: move_skip_button() called but could not recognise supplied arguments [" .. tostring(x) .. "] and [" .. tostring(y) .. "] - supply \"tl\", \"tr\", \"bl\", \"br\" or an x and a y position");
	end;
end;









----------------------------------------------------------------------------
--- @section Misc Configuration
----------------------------------------------------------------------------


--- @function set_should_hide_text_pointers_on_completion
--- @desc Scripted tours will hide all visible @text_pointer objects upon completion by default. This function may be used to suppress this behaviour if desired.
--- @p [opt=true] boolean should hide
function scripted_tour:set_should_hide_text_pointers_on_completion(value)
	if value == false then
		self.should_hide_text_pointers_on_completion = false;
	else
		self.should_hide_text_pointers_on_completion = true;
	end;
end;


--- @function set_should_dismiss_advice_on_completion
--- @desc Scripted tours will dismiss advice upon completion by default. This function may be used to suppress this behaviour if desired.
--- @p [opt=true] boolean should dismiss
function scripted_tour:set_should_dismiss_advice_on_completion(value)
	if value == false then
		self.should_dismiss_advice_on_completion = false;
	else
		self.should_dismiss_advice_on_completion = true;
	end;
end;


--- @function set_allow_camera_movement
--- @desc Scripted tours will prevent camera movement whilst active, by default. Use this function to allow the player to move the camera while the scripted tour is active. It can be used before the tour starts or while the tour is running.
--- @p [opt=true] boolean allow movement
function scripted_tour:set_allow_camera_movement(value)
	if value == false then
		self.allow_camera_movement = false;
	else
		self.allow_camera_movement = true;
	end;
	
	-- if the scripted tour is running then make this change immediately
	if self.is_running then
		self:allow_camera_movement_action();
	end;
end;


-- internal function to actually allow or disallow camera movement
function scripted_tour:allow_camera_movement_action(scripted_tour_ending)

	if scripted_tour_ending or self.allow_camera_movement then
		if core:is_battle() then
			bm:enable_camera_movement(true);
			
		elseif core:is_campaign() then
			-- TBD: enable camera movement in campaign
			
		end;
		
	elseif not self.allow_camera_movement then
		if core:is_battle() then
			bm:enable_camera_movement(false);
			
		elseif core:is_campaign() then
			-- TBD: disable camera movement in campaign
			
		end;
	end;
end;











----------------------------------------------------------------------------
--- @section Starting and Stopping
--- @desc A scripted tour will do nothing until it is started with @scripted_tour:start. If no argument is specified with this call then the main sequence of actions (i.e. those that were not added to a sequence) is started, otherwise the action sequence with the specified string name is started.
--- @desc Once started, a scripted tour will remain active until it is skipped or until the main action sequence is completed using @scripted_tour:complete. Calling this function with no arguments will complete the main action sequence (and the tour as a whole), whereas calling it with the name of a sequence will stop just that sequence. It is the responsibility of external scripts, usually those called within a scripted tour action, to complete the scripted tour.
--- @desc A scripted tour may be skipped by the player clicking on the skip button (if it is shown), which calls @scripted_tour:skip. Alternatively, this function may be called directly.
--- @desc When a scripted tour finishes it will trigger the script event <code>ScriptEventScriptedTourCompleted</code>, with the scripted tour name as the context string.
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the scripted tour or a scripted tour sequence. The first time this function is called the scripted tour as a whole starts. If no arguments are supplied the main action sequence commences, otherwise the actions associated with the specified sequence will start.
--- @p [opt=nil] string sequence name
function scripted_tour:start(sequence_name)
	if self.is_running and not sequence_name then
		script_error(self.name .. " WARNING: start() called with no sequence name but this scripted tour is already started");
		return false;
	end;

	if not self:is_currently_valid() then
		script_error(self.name .. " ERROR: start() called but this tour cannot start as it is not currently valid. Reason value: [" .. (is_string(self.last_validation_reason) and common.get_localised_string(self.last_validation_reason) or "<no reason>") .. "]");
		return false;
	end;
	
	sequence_name = sequence_name or "default";
	
	local action_list_for_sequence = self.action_list[sequence_name];
		
	if not is_table(action_list_for_sequence) or #action_list_for_sequence == 0 then
		script_error(self.name .. " ERROR: start() called for sequence [" .. sequence_name .. "] but no actions have been added to this sequence");
		return false;
	end;
	
	if action_list_for_sequence.is_sequence_running then
		script_error(self.name .. " ERROR: start() called for sequence [" .. sequence_name .. "] but this sequence is already running");
		return false;
	end;

	-- mark the sequence as running
	action_list_for_sequence.is_sequence_running = true;
	
	local tm = core:get_tm();
	
	-- if this scripted tour is not already running then start it for the first time
	if not self.is_running then
		out(self.name .. ":: starting tour, sequence is " .. sequence_name);

		self.is_running = true;

		-- set up a listener which skips this scripted tour if a ScriptEventSkipAllScriptedTours event is received
		core:add_listener(
			"skip_all_scripted_tours",
			"ScriptEventSkipAllScriptedTours",
			true,
			function()
				self:skip()
			end,
			false
		);

		-- cache advisor to infotext association
		self.cached_infotext_attached_to_advisor = get_infotext_manager():is_attached_to_advisor();

		-- Prevent generic advice from triggering while this tour is active
		if core:is_battle() then
			get_advice_manager():lock_advice();
		end;
	
		-- set the default skip button position if an override has not been set
		if not self.skip_button_position and not self.skip_button_position_x then
			self:move_skip_button("br");
		end;
	
		-- set the advisor to be topmost so it appears over the top of any fullscreen highlight
		core:cache_and_set_advisor_priority(1500, true);
	
		-- add the fullscreen highlight after the specified delay
		if self.fullscreen_highlight_delay >= 0 then
			tm:callback(function() self:show_fullscreen_highlight(true) end, self.fullscreen_highlight_delay, self.name .. "_fullscreen_highlight");
		end;
	
		-- restrict camera movement if we should (the function checks a set flag)
		self:allow_camera_movement_action();
	else
		out(self.name .. ":: starting sequence " .. sequence_name);
	end;
	
	-- enqueue actions to be called for this sequence
	local action_name = self.name .. "_action_" .. sequence_name;
	for i = 1, #action_list_for_sequence do
		tm:callback(function() action_list_for_sequence[i].action() end, action_list_for_sequence[i].action_time, action_name);
	end;
end;


--- @function skip
--- @desc Skips the scripted tour. This is called when the player clicks on the skip button, but may be called by external scripts. This will immediately terminate the tour and all running action sequences.
function scripted_tour:skip()

	if not self.is_running then
		script_error(self.name .. " WARNING: skip() called but this scripted tour is not running, disregarding");
		return false;
	end;
	
	out(self.name .. ":: skipping");
	
	-- make a duplicate of our skip action list
	local skip_action_list = {};
	
	for i = 1, #self.skip_actions do
		skip_action_list[i] = self.skip_actions[i];
	end;
	
	if #skip_action_list == 1 then
		out("\tcalling 1 skip action");
	else
		out("\tcalling " .. #skip_action_list .. " skip actions");
	end;
	
	-- call all of our skip actions
	for i = 1, #skip_action_list do
		skip_action_list[i].skip_action();
	end;
	
	self:complete();
end;


--- @function complete_sequence
--- @desc Instructs the scripted tour to complete an action sequence. Do this to cancel the sequence and prevent any further actions from that sequence being triggered. If no sequence name is specified then the main action sequence is completed.
--- @desc Note that calling this function does not complete the tour as a whole, which must still be terminated with @scripted_tour:complete.
--- @p [opt=nil] string sequence name
function scripted_tour:complete_sequence(sequence_name, scripted_tour_is_ending)

	sequence_name = sequence_name or "default";
	
	if not is_string(sequence_name) then
		script_error(self.name .. " ERROR: complete_sequence() called but supplied sequence name [" .. tostring(sequence_name) .. "] is not a string");
		return false;
	end;
	
	-- get the action list for the specified sequence_name
	local action_list_for_sequence = self.action_list[sequence_name];
	
	if not is_table(action_list_for_sequence) or #action_list_for_sequence == 0 then
		script_error(self.name .. " ERROR: start() called for sequence [" .. sequence_name .. "] but no actions have been added to this sequence");
		return false;
	end;
	
	if not action_list_for_sequence.is_sequence_running then
		return false;
	end;
	
	action_list_for_sequence.is_sequence_running = false;
	
	if not scripted_tour_is_ending then
		out(self.name .. ":: completing sequence " .. sequence_name);
	end;
	
	-- remove pending callbacks related to this sequence
	core:get_tm():remove_callback(self.name .. "_action_" .. sequence_name);
end;


--- @function complete
--- @desc Instructs the scripted tour to end after it has been started. All running action sequences will be terminated.
function scripted_tour:complete()

	if not self.is_running then
		script_error(self.name .. " WARNING: complete() called but this scripted tour is not running, disregarding");
		return false;
	end;

	out(self.name .. ":: ending");

	core:remove_listener("ScriptEventSkipAllScriptedTours");
	
	-- cancel any pending fullscreen highlight callback
	core:get_tm():remove_callback(self.name .. "_fullscreen_highlight");
	
	-- complete all running sequences
	for sequence_name, action_list_for_sequence in pairs(self.action_list) do
		if action_list_for_sequence.is_sequence_running then
			self:complete_sequence(sequence_name, true);
		end;
	end;
	
	-- hide fullscreen highlight
	self:show_fullscreen_highlight(false);
	
	-- hide any text pointers if we should
	if self.should_hide_text_pointers_on_completion then
		core:hide_all_text_pointers();
	end;
	
	-- dismiss advice if we should
	if self.should_dismiss_advice_on_completion then
		if core:is_campaign() then
			cm:dismiss_advice();
		elseif core:is_battle() then
			bm:stop_advisor_queue(true);

			-- Allow generic advice
			get_advice_manager():unlock_advice();
		end;
	end;
	
	-- unrestrict camera movement if we should
	self:allow_camera_movement_action(true);	
	
	-- stop skip button listeners
	self:stop_skip_button_listeners();

	-- restore cached advisor to infotext association
	get_infotext_manager():attach_to_advisor(self.cached_infotext_attached_to_advisor);
	
	self.is_running = false;
	
	-- call end callback
	if is_function(self.end_callback) then
		self.end_callback()
	end
	-- trigger ending event
	core:trigger_event("ScriptEventScriptedTourCompleted", self.name);
end;



































----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	NAVIGABLE TOURS
--
--- @c navigable_tour Navigable Tours
--- @desc A navigable tour is a particular type of @scripted_tour which provides a control panel to the player, allowing them to rewind back and forth between tour sections. The player may also exit the tour at any time from the control panel provided.
--- @desc Navigable tours are built on top of the functionality that scripted tours provide, and extend and wrap the scripted tour interface. One crucial difference is that actions are associated with a navigable tour through an intermediate @navigable_tour_section objects. Once created, actions are added to @navigable_tour_section objects and then they are registered with the parent navigable tour with @navigable_tour:add_navigable_section. Actions cannot be directly added to a navigable tour, asides from start and end actions.


--- @section Navigable Tours and Scripted Tours
--- @desc When created, a navigable tour creates a @scripted_tour object and stores it internally. Calls made to the navigable tour object that the navigable tour interface does not provide are automatically passed through to the internal scripted tour object. An exception to this is @scripted_tour:action - this is explicitly overridden by the navigable tour interface and will throw a script error if called.


--- @section At A Glance
--- @desc A navigable tour is declared with @navigable_tour:new. A name and a function to call when the tour ends (or is skipped) must be specified here, as well as an optional tour name as a full localisation key.
--- @desc Once the tour is created, separately-created @navigable_tour_section objects may be assigned to it with @navigable_tour:add_navigable_section. These objects contain the underlying actions that are ultimately played - much of the complexity of setting up a narrative tour comes from setting up the sections.
--- @desc Startup and finishing actions may be added to the navigable tour with @navigable_tour:start_action and @navigable_tour:end_action. These are played when the tour starts or ends.
--- @desc Once configured with sections, a tour may be started with @navigable_tour:start.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


navigable_tour = {
	--[[
	sections = {},															-- navigable tour sections
	start_actions = {},														-- actions to perform at the start of the tour
	end_actions = {},														-- actions to perform at the end of the tour
	]]
	name = false,															-- string name for this navigable tour
	tour_title = false,														-- optional string localisation key to use as the tour title
	st = false,																-- underlying scripted tour object
	section_currently_playing = false,										-- the navigable tour section currently playing
	uic_scripted_tour_controls = false,										-- handle to tour controls panel
	scripted_tour_controls_end_button_replacing_next = false,				-- is the end button current showing in place of the next button
	scripted_tour_controls_next_button_active = false,						-- is the next/end button currently active
	scripted_tour_controls_back_button_active = false,						-- is the back button currently active
	is_exiting = false,														-- is the navigable tour currently in the process of exiting
	interval_before_tour_controls_visible = 1000,							-- interval at the start of the tour after which the controls become visible - 1 second by default. This is reset in the constructor in campaign to use seconds.
	start_first_section_automatically = true,								-- should the first navigable tour section be started automatically when the last start action is called
	first_valid_section = false,											-- reference to the first valid section
	unhide_scripted_tour_controls_when_cinematic_ui_disabled = false,		-- should the scripted tour controls be unhidden when cinematic ui is disabled. Set to true if tour controls were hidden by the appearance of the cinematic ui

	-- cached values for uicomponents that we may shuffle around in the course of playing the navigable tour
	infotext_cached_dock_x = false,
	infotext_cached_dock_y = false,
	objectives_cached_dock_x = false,
	objectives_cached_dock_y = false,
	scripted_tour_controls_default_width = false,
	cached_scripted_tour_controls_priority = -1, 
	cached_scripted_tour_controls_topmost = false
}


set_class_custom_type(navigable_tour, TYPE_NAVIGABLE_TOUR);
set_class_tostring(
	navigable_tour,
	function(obj)
		return TYPE_NAVIGABLE_TOUR .. "_" .. obj.name
	end
);









----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a navigable tour object. Each navigable tour must be given a unique string name and, optionally, an end callback which will be called when the scripted tour ends or is skipped.
--- @desc An optional tour title may also be supplied as a full <code>[table]_[field]_[key]</code>-style localised key. If supplied, the title of the navigable tour control panel will be set to the localised text specified by the key.
--- @p @string name, Unique name for the scripted tour.
--- @p [opt=nil] @function end callback, End callback.
--- @p [opt=nil] @string tour title, Full localisation key to use for navigable tour title.
--- @r @navigable_tour navigable tour
function navigable_tour:new(name, end_callback, tour_title)
	local st = scripted_tour:new(name, end_callback);

	if not st then
		return false;
	end;

	if tour_title and not is_string(tour_title) then
		script_error("ERROR: navigable_tour:new() called but supplied tour title [" .. tostring(tour_title) .. "] is not a string or nil");
		return false;
	end;

	local nt = {};

	nt.name = "navigable_tour_" .. name;

	set_object_class(nt, self, st);

	nt.st = st;
	nt.sections = {};
	nt.start_actions = {};
	nt.end_actions = {};

	-- If we're in campaign then reset this value to use seconds rather than ms
	if core:is_campaign() then
		nt.interval_before_tour_controls_visible = nt.interval_before_tour_controls_visible / 1000;
	end;

	if tour_title then
		nt.tour_title = tour_title;
	end;

	return nt;
end;










----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once a <code>navigable_tour</code> object has been created with @navigable_tour:new, functions on it may be called in the form showed below. Any functions that are not recognised on the navigable tour are passed through to the @scripted_tour object created internally.
--- @new_example Specification
--- @example <i>&lt;scripted_tour_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local nt_siege_defence = navigable_tour:new(
--- @example 	"siege_battle_defence",																		-- unique name
--- @example 	end_siege_battle_defence_tour,																-- end callback
--- @example	"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_siege_defence_name"		-- title
--- @example );
--- @example 
--- @example -- calling a function on the object once created
--- @example nt_siege_defence:set_allow_camera_movement(true);
--- @example 
--- @example -- calling a function on the underlying scripted tour
--- @example -- (the function call is passed through automatically)
--- @example nt_siege_defence:add_validation_rule(
--- @example 	function()
--- @example 		return core:is_battle()
--- @example 	end,
--- @example 	"random_localisation_strings_string_scripted_tour_invalid_not_battle"
--- @example );









----------------------------------------------------------------------------
---	@section Configuration
----------------------------------------------------------------------------


--- @function set_tour_controls_above_infotext
--- @desc Sets the tour controls to appear above the infotext panel in the top-left of the screen. The tour controls panel will also be stretched horizontally to be the same width as the infotext panel.
--- @desc If <code>false</code> is supplied as an argument then the tour controls revert back to being underneath the infotext panel.
--- @p [opt=true] @boolean tour controls above infotext
function navigable_tour:set_tour_controls_above_infotext(value)
	local uic_under_advisor_docker = find_uicomponent("under_advisor_docker");

	if not uic_under_advisor_docker then
		script_error("ERROR: set_tour_controls_above_infotext() called but uic_under_advisor_docker could not be found? How can this be?");
		return false;
	end;

	local uic_scripted_tour_controls = self:get_scripted_tour_controls_uicomponent();

	if not uic_scripted_tour_controls then
		script_error("ERROR: set_tour_controls_above_infotext() called but uic_scripted_tour_controls could not be found? How can this be?");
		return false;
	end;

	local uic_objectives_docker = find_uicomponent(uic_under_advisor_docker, "scripted_objectives_docker");

	if not uic_objectives_docker then
		script_error("ERROR: set_tour_controls_above_infotext() called but uic_objectives_docker could not be found? How can this be?");
		return false;
	end;

	local uic_infotext = get_infotext_manager():get_infotext_panel();

	if value == false then
		uic_under_advisor_docker:Adopt(uic_scripted_tour_controls:Address());

		if self.scripted_tour_controls_default_width then
			uic_scripted_tour_controls:Resize(self.scripted_tour_controls_default_width, uic_scripted_tour_controls:Height(), true);
		end;

		if self.infotext_cached_dock_x and self.infotext_cached_dock_y then
			uic_infotext:SetDockOffset(self.infotext_cached_dock_x, self.infotext_cached_dock_y);
		end;

		if self.objectives_cached_dock_x and self.objectives_cached_dock_y then
			uic_infotext:SetDockOffset(self.objectives_cached_dock_x, self.objectives_cached_dock_y);
		end;
	else
		
		uic_under_advisor_docker:Adopt(uic_scripted_tour_controls:Address(), 0);

		if not uic_infotext then
			script_error("ERROR: set_tour_controls_above_infotext() called but uic_infotext could not be found? How can this be?");
			return false;
		end;

		-- TODO: change this script as it goes wrong the second time around (i.e when a second scripted tour is loaded), and fights with the infotext docking offset caching behaviour in code
		local infotext_dock_x, infotext_dock_y = uic_infotext:GetDockOffset();
		uic_infotext:SetDockOffset(infotext_dock_x, infotext_dock_y + 10);
		self.infotext_cached_dock_x = infotext_dock_x;
		self.infotext_cached_dock_y = infotext_dock_y;

		local objectives_dock_x, objectives_dock_y = uic_objectives_docker:GetDockOffset();
		uic_objectives_docker:SetDockOffset(objectives_dock_x, objectives_dock_y + 10);
		self.objectives_cached_dock_x = objectives_dock_x;
		self.objectives_cached_dock_y = objectives_dock_y;

		self.scripted_tour_controls_default_width = uic_scripted_tour_controls:Width();

		-- Only do this once. Ideally refactor all this in the future.
		core:call_once(
			"scripted_tour_controls_resize",
			function()
				uic_scripted_tour_controls:Resize(uic_infotext:Width(), uic_scripted_tour_controls:Height());
			end
		);
	end;
end;


--- @function set_interval_before_tour_controls_visible
--- @desc Sets the interval at the start of the tour before the tour controls are animated to visible. By default this value is set to 1 second. This value should be set in seconds in campaign, and milliseconds elsewhere.
--- @p @number interval
function navigable_tour:set_interval_before_tour_controls_visible(interval)
	if not validate.is_non_negative_number(interval) then
		return false;
	end;

	self.interval_before_tour_controls_visible = interval;
end;


--- @function set_start_first_section_automatically
--- @desc Sets the scripted tour to start the first section automatically or not. By default, the first section is started automatically. Disable this behaviour with this function if the start action sequence is not of a predetermined length, such as a cutscene that must be dismissed.
--- @desc If the first section is not started automatically then it must be started manually with @navigable_tour:start_next_section.
--- @p [opt=true] @boolean should start automatically
function navigable_tour:set_start_first_section_automatically(value)
	if value == false then
		self.start_first_section_automatically = false;
	else
		self.start_first_section_automatically = true;
	end;
end;











----------------------------------------------------------------------------
---	@section Start and End Actions
--- @desc Navigable tours contain start and end sequences, to which action callbacks may be added using the functions in this section. These sequences can be zero-length and don't have to contain any actions.
--- @desc The starting sequence is played as the tour is started, and can be used to set up the tour or play a one-time intro sequence. The main tour sequences will start when the start action with the longest interval is called.
--- @desc The end sequence is played as the tour is exited and can be used to play an outro or clean up after the tour. The tour will fully exit when the end action with the longest interval is called.
----------------------------------------------------------------------------


--- @function start_action
--- @desc Adds an action to the navigable tour's starting sequence.
--- @p @function action, Action callback.
--- @p [opt=0] @number action time, Interval after the start of the tour at which to trigger the action. This should be given in seconds in campaign, and milliseconds otherwise.
function navigable_tour:start_action(action, action_time)
	if not is_function(action) then
		script_error(self.name .. " ERROR: start_action() called but supplied action callback [" .. tostring(action) .. "] is not a function");
		return false;
	end;

	if action_time then
		if not is_number(action_time) then
			script_error(self.name .. " ERROR: start_action() called but supplied action time [" .. tostring(action_time) .. "] is not a positive number or nil");
			return false;
		end;
	else
		action_time = 0;
	end;

	if self.st.is_running then
		script_error(self.name .. " ERROR: start_action() called but this tour is already running");
		return false;
	end;

	table.insert(
		self.start_actions,
		{
			action = action,
			action_time = action_time
		}
	);
end;


--- @function end_action
--- @desc Adds an action to the navigable tour's ending sequence.
--- @p @function action, Action callback.
--- @p @function action time, Interval after the start of the tour at which to trigger the action. This should be given in seconds in campaign, and milliseconds otherwise.
function navigable_tour:end_action(action, action_time)
	if not is_function(action) then
		script_error(self.name .. " ERROR: end_action() called but supplied action callback [" .. tostring(action) .. "] is not a function");
		return false;
	end;

	if action_time then
		if not is_number(action_time) then
			script_error(self.name .. " ERROR: end_action() called but supplied action time [" .. tostring(action_time) .. "] is not a positive number or nil");
			return false;
		end;
	else
		action_time = 0;
	end;

	if self.st.is_running then
		script_error(self.name .. " ERROR: end_action() called but this tour is already running");
		return false;
	end;

	table.insert(
		self.end_actions,
		{
			action = action,
			action_time = action_time
		}
	);
end;


-- action override
function navigable_tour:action()
	script_error(self.name .. " WARNING: action() called but this is a navigable tour - actions should not be added directly, but associated with the tour through navigable tour sections. Disregarding this.");
end;











----------------------------------------------------------------------------
---	@section Main Construction
--- @desc The @navigable_tour:add_navigable_section function can be used to add @navigable_tour_section objects to the navigable tour. This is the intended method for building a navigable tour - actions are added to a section, and sections are added to a tour. When the navigable tour is started, the navigable tour sections are added as segments to the underlying @scripted_tour object, should their preconditions pass.
----------------------------------------------------------------------------


--- @function add_navigable_section
--- @desc Adds a @navigable_tour_section to the navigable tour. Navigable tour sections should be added in the order in which they should be shown in game.
--- @p @navigable_tour_section navigable tour section
function navigable_tour:add_navigable_section(section)
	if not is_navigabletoursection(section) then
		script_error(self.name .. " ERROR: add_navigable_section() called but supplied argument [" .. tostring(section) .. "] is not a valid navigable tour section");
		return false;
	end;

	if self.st.is_running then
		script_error(self.name .. " ERROR: add_navigable_section() called but this tour is already running");
		return false;
	end;

	table.insert(self.sections, section);
	section.navigable_tour = self;
end;


-- Internal function to add the actions for a particular tour section when the tour is started
function navigable_tour:add_section_actions_on_start(current_section, current_section_index, num_sections)

	local st = self.st;
	local current_section_name = current_section.name;
	local current_actions = current_section.actions;
	self.section_currently_playing = false;

	st:action(
		function()
			-- mark this section as playing
			current_section.playing = true;
			self.section_currently_playing = current_section;

			-- clear the current skip actions on this section - these get added during the section's actions
			current_section:reset_skip_actions();

			-- set up the tour counter
			self:set_tour_controls_count(current_section_index, num_sections);

			-- hide all text pointers at the start of each section
			core:hide_all_text_pointers();
		end,
		0,
		current_section_name
	);

	-- enqueue each action within the tour section, and work out which one has the longest interval
	for j = 1, #current_actions do
		local current_action = current_actions[j];
		st:action(current_action.action, current_action.action_time, current_section_name);
	end;

	if current_section.activate_tour_controls_on_start then
		-- if the tour section is set to allow controls on start then enable them when the section begins
		st:action(
			function()
				self:enable_tour_controls_for_current_section();
			end,
			0,
			current_section_name
		);
	else
		-- if the tour section is not set to allow controls on start then add an action to disable them at the start
		st:action(
			function()
				self:disable_tour_controls_buttons(
					not current_section.next_section				-- true if this is the last section, which causes end button to be shown
				);
			end,
			0,
			current_section_name
		);

		-- also append a failsafe action to enable them at the end of the section, if they're not already enabled
		st:append_action(
			function()
				self:enable_tour_controls_for_current_section();
			end,
			current_section_name
		);
	end;
end;












----------------------------------------------------------------------------
---	@section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the navigable tour.
-- the section_name parameter should not be used externally.
function navigable_tour:start(section_name)

	-- if we have a section name then we just pass that to the underlying scripted tour
	if section_name then
		self.st:start(section_name);
		return;
	end;

	if #self.sections == 0 then
		script_error(self.name .. " ERROR: start() called but this navigable tour contains no sections");
		return false;
	end;

	local valid_sections = {};
	local sections = self.sections;

	self.is_exiting = false;

	-- check section preconditions - sections that pass go into valid_sections
	for i = 1, #sections do
		local current_section = sections[i];

		if #current_section.actions == 0 then
			script_error(self.name .. " ERROR: start() called but navigable tour section [" .. i .. "] (" .. tostring(current_section) .. ") has no actions registered");
			return false;
		end;

		local precondition_result, err_msg = current_section:check_preconditions();

		if precondition_result then
			table.insert(valid_sections, current_section);
		elseif err_msg then
			script_error(self.name .. " WARNING: start() called and the precondition of navigable tour section [" .. i .. "] (" .. tostring(current_section) .. ") failed with the following error: " .. err_msg);
		end;
	end;

	-- if we have no valid sections left then error
	local num_valid_sections = #valid_sections;
	if num_valid_sections == 0 then
		script_error(self.name .. " ERROR: no valid sections remain in this navigable tour after preconditions check");
		return false;
	end;
	
	-- add actions to the underlying scripted tour from all valid sections
	for i = 1, num_valid_sections do
		local current_section = valid_sections[i];

		if i > 1 then
			current_section.previous_section = valid_sections[i - 1];
		end;

		if i < num_valid_sections then
			current_section.next_section = valid_sections[i + 1];
		end;
		
		self:add_section_actions_on_start(current_section, i, num_valid_sections);
	end;
	
	local st = self.st;

	-- add the start sequence for the navigable tour to the underlying scripted tour
	local start_actions = self.start_actions;
	for i = 1, #start_actions do
		local current_action = start_actions[i];
		st:action(current_action.action, current_action.action_time);
	end;

	-- append an action to the starting sequence of the tour to start the first valid section
	if self.start_first_section_automatically then
		st:append_action(function() st:start(valid_sections[1].name) end);
	end;

	self.first_valid_section = valid_sections[1];

	-- add the end sequence for the navigable tour to the underlying scripted tour
	local end_actions = self.end_actions;

	st:action(
		function() 
			-- destroy controls panel
			self:hide_tour_controls();
		end,
		0,
		"end_actions"
	);

	for i = 1, #end_actions do
		local current_action = end_actions[i];
		st:action(current_action.action, current_action.action_time, "end_actions");
	end;

	-- append an action to the ending sequence of the tour to actually end the tour
	st:append_action(
		function() 
			st:complete() 
		end, 
		"end_actions"
	);

	-- make the tour controls visible
	st:action(
		function()
			local uic_tour_controls = self:get_scripted_tour_controls_uicomponent();
			
			if (core:is_battle() and bm:is_cinematic_ui_enabled()) or (core:is_campaign() and cm:is_cinematic_ui_enabled()) then
				-- Cinematic UI is enabled, so don't show the controls immediately
				uic_tour_controls:SetVisible(false);
				self.unhide_scripted_tour_controls_when_cinematic_ui_disabled = true;
			else
				-- Cinematic UI is not enabled, go ahead and show the controls
				uic_tour_controls:SetVisible(true);
				uic_tour_controls:TriggerAnimation("show");
			end;			

			-- Start listeners for the cinematic UI being shown/hidden, and hide the tour controls if they are visible
			core:add_listener(
				"navigable_tour_cinematic_ui_listener",
				"CinematicUIEnabled",
				true,
				function()
					if self.uic_scripted_tour_controls then
						self.uic_scripted_tour_controls:SetVisible(false);
						self.unhide_scripted_tour_controls_when_cinematic_ui_disabled = true;
					end;
				end,
				true
			);

			core:add_listener(
				"navigable_tour_cinematic_ui_listener",
				"CinematicUIDisabled",
				true,
				function()
					if self.unhide_scripted_tour_controls_when_cinematic_ui_disabled then
						self.unhide_scripted_tour_controls_when_cinematic_ui_disabled = false;
						self.uic_scripted_tour_controls:SetVisible(true);
						self.uic_scripted_tour_controls:TriggerAnimation("show");
					end;
				end,
				true
			);
		end,
		self.interval_before_tour_controls_visible
	);

	-- start the tour
	st:start();
	
	-- set tour title
	if st.is_running and self.tour_title then
		self:set_tour_controls_title(self.tour_title);
	end;

end;














----------------------------------------------------------------------------
---	@section Playback
--- @desc The functions in this section are for use while the tour is playing.
----------------------------------------------------------------------------


-- Internal function which skips the current section, and start the ending section
function navigable_tour:begin_exit()

	if not self.st.is_running then
		script_error(self.name .. " ERROR: begin_exit() called but this navigable tour is not running");
		return false;
	end;

	if self.is_exiting then
		return;
	end;

	self.is_exiting = true;

	-- skip the current section
	self:skip_current_section(true);

	-- start the end sequence
	self.st:start("end_actions");
end;


-- Internal function to activate the tour controls (called during playback of each section)
function navigable_tour:enable_tour_controls_for_current_section()
	if not self.st.is_running then
		script_error(self.name .. " ERROR: enable_tour_controls_for_current_section() called but tour is not running");
		return false;
	end;

	if self.scripted_tour_controls_next_button_active then
		-- controls are already enabled
		return;
	end;

	local current_section = self.section_currently_playing;

	-- set up state of next button
	if current_section.next_section then
		self:set_tour_controls_next_button_state(
			true, 
			function()
				self:start_next_section();
			end
		);
	else
		self:set_tour_controls_next_button_state(
			true, 
			function()
				-- skip the tour as a whole
				self:begin_exit();
			end,
			true				-- show the end button rather than next button
		);
	end;

	-- set up state of previous button
	if current_section.previous_section then
		self:set_tour_controls_back_button_state(
			true, 
			function()
				self:start_previous_section();
			end
		);
	end;
end;


--- @function start_next_section
--- @desc Cause the navigable tour to skip to the next section. If the start actions are being played then the first section of the tour is started.
function navigable_tour:start_next_section()
	if not self.st.is_running then
		script_error(self.name .. " ERROR: start_next_section() called but tour is not running");
		return false;
	end;

	local current_section = self.section_currently_playing;

	if current_section then
		if not current_section.next_section then
			script_error(self.name .. " WARNING: start_next_section() called but current section with name " .. current_section.name .. " has no next section, disregarding");
			return false;
		end;

		-- skip the current section
		self:skip_current_section(false, false);
	
		-- start the next section of the tour
		self:start(current_section.next_section.name);
		
	elseif self.first_valid_section then
		-- assume we're playing the start actions, and start the first section
		self:start(self.first_valid_section.name);
	else
		script_error(self.name .. " ERROR: start_next_section() called but current section could not be determined, how can this be?");
		return false;
	end;
end;


--- @function start_previous_section
--- @desc Cause the navigable tour to skip to the previous section.
function navigable_tour:start_previous_section()
	if not self.st.is_running then
		script_error(self.name .. " ERROR: start_previous_section() called but tour is not running");
		return false;
	end;

	local current_section = self.section_currently_playing;

	if not current_section then
		script_error(self.name .. " ERROR: start_previous_section() called but current section could not be determined, how can this be?");
		return false;
	end;

	if not current_section.previous_section then
		script_error(self.name .. " WARNING: start_previous_section() called but current section with name " .. current_section.name .. " has no previous section, disregarding");
		return false;
	end;

	-- skip the current section
	self:skip_current_section(false, true);

	-- start the previous section of the tour
	self:start(current_section.previous_section.name);
end;


-- Internal function to skip/complete the section currently playing
function navigable_tour:skip_current_section(is_tour_ending, is_skipping_backwards)
	local current_section = self.section_currently_playing;

	if not current_section then
		script_error(self.name .. " ERROR: skip_current_section() called but section is currently playing");
		return;
	end;

	-- remove any additional actions related to this sequence
	self.st:complete_sequence(current_section.name);

	-- call skip actions
	current_section:call_skip_actions(is_tour_ending, is_skipping_backwards);
end;


--- @function get_scripted_tour_controls_uicomponent
--- @desc Gets the scripted tour controls panel, creating it if it doesn't already exist. This is mainly for internal use but could feasibly be called externally.
--- @p [opt=false] @boolean do not create, Do not create - if set to <code>true</code>, the tour controls are not created if they do not already exist.
--- @r @uicomponent tour controls
function navigable_tour:get_scripted_tour_controls_uicomponent(do_not_create)

	if self.uic_scripted_tour_controls or do_not_create then
		return self.uic_scripted_tour_controls;
	end;

	if not self.st.is_running then
		script_error(self.name .. " ERROR: get_scripted_tour_controls_uicomponent() called but tour is not running");
		return false;
	end;

	local uic_scripted_tour_controls = core:get_or_create_component("scripted_tour_controls", "UI/Common UI/scripted_tour_controls.twui.xml");

	if not uic_scripted_tour_controls then
		script_error(self.name .. "ERROR: get_scripted_tour_controls_uicomponent() could not create scripted tour controls? How can this be?");
		return false;
	end;
	
	-- attach the controls to the scripted objectives docker
	local uic_scripted_objectives_docker = find_uicomponent("scripted_objectives_docker");
	if uic_scripted_objectives_docker then
		uic_scripted_objectives_docker:Adopt(uic_scripted_tour_controls:Address());
	else
		script_error(self.name .. " ERROR: get_scripted_tour_controls_uicomponent() could not find scripted objectives docker uicomponent? How can this be? The scripted objective controls will be undocked");
	end;

	-- if we have an interval before tour controls should be visible then make the tour controls transparent initially
	if self.interval_before_tour_controls_visible > 0 then
		uic_scripted_tour_controls:SetVisible(false);
	end;

	self.uic_scripted_tour_controls = uic_scripted_tour_controls;

	core:add_listener(
		"scripted_tour_skip_button",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_close" and UIComponent(UIComponent(context.component):Parent()):Id() == "scripted_tour_controls";
		end,
		function()
			-- skip the tour as a whole
			self:begin_exit();
		end,
		false
	);

	return uic_scripted_tour_controls;
end;


-- Internal function to set the title of the tour
function navigable_tour:set_tour_controls_title(key)
	find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_title"):SetStateText(common.get_localised_string(key), key);
end;


-- Internal function to set the progress counter
function navigable_tour:set_tour_controls_count(current, total)
	find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_progress_label"):SetStateText(current .. " / "  .. total, "from script - navigable_tour:set_tour_controls_count()");
end;


-- Internal function to disable all tour controls, called at the start of each section
function navigable_tour:disable_tour_controls_buttons(use_end_button)
	self:set_tour_controls_back_button_state(false);
	self:set_tour_controls_next_button_state(false, nil, use_end_button);
end;


-- Internal function to set the back button state - whether it's active, and what it does if pressed
function navigable_tour:set_tour_controls_back_button_state(active, callback)
	if active and not callback then
		script_error(self.name .. " WARNING: set_tour_controls_back_button_state() has been instructed to set the back button to be active but no callback was specified - the back button will not made active");
		return false;
	end;

	core:remove_listener("scripted_tour_back_button");

	local uic_back_button = find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_prev_button");
	if not uic_back_button then
		script_error(self.name .. " ERROR: set_tour_controls_back_button_state() could not find scripted_tour_prev_button uicomponent - how can this be?");
		return false;
	end;

	if active then
		core:add_listener(
			"scripted_tour_back_button",
			"ComponentLClickUp",
			function(context)
				return context.string == "scripted_tour_prev_button"
			end,
			function()
				self:set_tour_controls_next_button_highlight(false);
				callback();
			end,
			true
		);

		uic_back_button:SetState("active");
	else
		uic_back_button:SetState("inactive");
	end;

	self.scripted_tour_controls_back_button_active = active;
end;


-- Internal function to set the next button state - whether it's active, and what it does if pressed, and whether to actually use the 'end' button (i.e. on last section of tour)
function navigable_tour:set_tour_controls_next_button_state(active, callback, use_end_button)
	if active and not callback then
		script_error(self.name .. " ERROR: set_tour_controls_next_button_state() has been instructed to set the next button to be active but no callback was specified");
		return false;
	end;

	core:remove_listener("scripted_tour_next_button");

	local uic_next_button = find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_next_button");
	if not uic_next_button then
		script_error(self.name .. " ERROR: set_tour_controls_next_button_state() could not find scripted_tour_next_button uicomponent - how can this be?");
		return false;
	end;

	local uic_end_button = find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_end_button");
	if not uic_end_button then
		script_error(self.name .. " ERROR: set_tour_controls_next_button_state() could not find scripted_tour_end_button uicomponent - how can this be?");
		return false;
	end;

	local active_button_name;
	local uic_active_button;

	if use_end_button then
		uic_next_button:SetVisible(false);
		uic_end_button:SetVisible(true);
		active_button_name = "scripted_tour_end_button";
		uic_active_button = uic_end_button;
		self.scripted_tour_controls_end_button_replacing_next = true;
	else
		uic_next_button:SetVisible(true);
		uic_end_button:SetVisible(false);
		active_button_name = "scripted_tour_next_button";
		uic_active_button = uic_next_button;
		self.scripted_tour_controls_end_button_replacing_next = false;
	end;

	if active then
		core:add_listener(
			"scripted_tour_next_button",
			"ComponentLClickUp",
			function(context)
				return context.string == active_button_name
			end,
			function(context)
				self:set_tour_controls_next_button_highlight(false, UIComponent(context.component));
				callback();
			end,
			true
		);

		uic_active_button:SetState("active");
	else
		uic_active_button:SetState("inactive");
	end;

	self.scripted_tour_controls_next_button_active = active;
end;


-- Internal function to set the highlight state of the next/end button (whichever is being used)
function navigable_tour:set_tour_controls_next_button_highlight(active, uic_button)
	if not uic_button then
		if self.scripted_tour_controls_end_button_replacing_next then
			uic_button = find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_end_button");
		else
			uic_button = find_uicomponent(self:get_scripted_tour_controls_uicomponent(), "scripted_tour_next_button");
		end;
	end;

	if uic_button then
		uic_button:Highlight(not not active, true);
	end;
end;


-- Internal function to hide/clean up the tour controls panel. Called when navigable tour begins its exit sequence
function navigable_tour:hide_tour_controls(immediate)
	if not self.uic_scripted_tour_controls then
		return;
	end;

	core:remove_listener("scripted_tour_next_button");
	core:remove_listener("scripted_tour_back_button");
	core:remove_listener("scripted_tour_skip_button");
	core:remove_listener("navigable_tour_cinematic_ui_listener");

	self.unhide_scripted_tour_controls_when_cinematic_ui_disabled = false;

	-- remove me
	immediate = true;

	if immediate then
		self.uic_scripted_tour_controls:Destroy();
	else
		self.uic_scripted_tour_controls:TriggerAnimation("hide");
	end;

	self.uic_scripted_tour_controls = false;
end;

--- @function cache_and_set_scripted_tour_controls_priority
--- @desc Sets the priority to the supplied value, and caches the value previously set. The scripted tour controls priority can later be restored with <code>restore_scripted_tour_controls_priority</code>.
--- @desc The register_topmost flag can also be set to force the scripted tour controls to topmost.
function navigable_tour:cache_and_set_scripted_tour_controls_priority(new_priority, register_topmost)
	if not is_number(new_priority) then
		script_error("ERROR: cache_and_set_scripted_tour_controls_priority() called but supplied priority [" .. tostring(new_priority) .."] is not a number");
		return false;
	end;
	
	local uic_scripted_tour_controls = self:get_scripted_tour_controls_uicomponent()

	-- cache the current scripted tour controls priority and set it to its new value
	if uic_scripted_tour_controls then

		self.cached_scripted_tour_controls_priority = uic_scripted_tour_controls:Priority()
		uic_scripted_tour_controls:PropagatePriority(new_priority);
		
		if register_topmost then
			uic_scripted_tour_controls:RegisterTopMost();
			self.cached_scripted_tour_controls_topmost = true;
		end;
	end
	
end;


--- @function restore_scripted_tour_controls_priority
--- @desc Restores the scripted tour controls priority to a value previously cached with <code>cache_and_set_scripted_tour_controls_priority</code>.
function navigable_tour:restore_scripted_tour_controls_priority()
	if self.cached_scripted_tour_controls_priority == -1 then
		script_error("WARNING: restore_scripted_tour_controls_priority() called but scripted tour priority hasn't been previously cached with cache_and_set_scripted_tour_controls_priority() - be sure to call that first");
		return false;
	end;
	
	local uic_scripted_tour_controls = self:get_scripted_tour_controls_uicomponent(true); 		-- do not recreate the tour controls if they don't already exist

	if uic_scripted_tour_controls then
		
		if self.cached_scripted_tour_controls_topmost then
			self.cached_scripted_tour_controls_topmost = false;
			uic_scripted_tour_controls:RemoveTopMost();
		end;
	
		uic_scripted_tour_controls:PropagatePriority(self.cached_scripted_tour_controls_priority)
	end;
	
end














----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	NAVIGABLE TOUR SECTIONS
--
--- @c navigable_tour_section Navigable Tour Section
--- @page navigable_tour
--- @desc A navigable tour section is a container for action callbacks that occur during a section of a @navigable_tour. A navigable tour is wrapper for a @scripted_tour, and a navigable tour section represents a scripted tour segment. Declaring navigable tour sections, loading them with actions, and then adding them to a navigable tour is the route by which actions get added to a navigable tour.
--- @desc Navigable tour sections can be reused between different navigable tours.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


navigable_tour_section = {
	--[[
		preconditions = {},									-- preconditions which must be passed if section is to be added to tour
		actions = {},										-- actions to perform during tour section
		skip_actions = {},									-- actions to perform if this tour section is skipped
	]]
	name = false,											-- unique name for this section
	navigable_tour = false,									-- link to the parent navigable tour
	playing = false,										-- is this navigable tour section playing right now
	activate_tour_controls_on_start = false,				-- this tour section should activate the tour controls (allow next/prev to be clicked) immediately
	previous_section = false,								-- the previous section in the tour - this is set by the tour itself when started
	next_section = false,									-- the next section in the tour - this is set by the tour itself when started
	next_button_highlight_previously_shown = false,			-- has the button highlight for the next button been shown this session? This is not saved between sessions
	__add_objective_interval = 4000							-- period after which an objective should be added when using a factory function. Not key to the core workings of the navigable tour but is used by client scripts
};


set_class_custom_type(navigable_tour_section, TYPE_NAVIGABLE_TOUR_SECTION);
set_class_tostring(
	navigable_tour_section, 
	function(obj)
		return TYPE_NAVIGABLE_TOUR_SECTION .. "_" .. obj.name
	end
);









----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new navigable tour section.
--- @p @string name
--- @p [opt=false] @boolean activate controls, Activate scripted tour controls on start of this navigable tour section. Setting this to <code>true</code> means that the tour next/prev buttons will be active as soon as this tour section starts. In this case @navigable_tour_section:activate_tour_controls does not need to be called within a tour action.
--- @r @navigable_tour_section navigable tour section
function navigable_tour_section:new(name, activate_tour_controls_on_start)
	if not is_string(name) then
		script_error("ERROR: navigable_tour_section:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local nts = {};

	nts.name = "navigable_tour_section_" .. name;
	
	set_object_class(nts, self);

	nts.preconditions = {};
	nts.actions = {};
	nts.skip_actions = {};

	nts.activate_tour_controls_on_start = not not activate_tour_controls_on_start;
	
	return nts;
end;









----------------------------------------------------------------------------
--- @section Configuration
----------------------------------------------------------------------------


--- @function add_precondition
--- @desc Adds a precondition check to be called when the navigable tour is started. The supplied function will be called and, should it return <code>nil</code> or <code>false</code>, the section will <strong>not</strong> be added to the navigable tour.
--- @desc If an optional error message string is added with the precondition then a script error displaying that message will be triggered should the precondition not pass.
--- @p @function callback, Precondition callback. 
--- @p [opt=nil @string error message, Error message to display should the precondition fail. If no error message is supplied then no error is triggered.
function navigable_tour_section:add_precondition(callback, error_msg_on_failure)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_precondition() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	if error_msg_on_failure and not is_string(error_msg_on_failure) then
		script_error(self.name .. " ERROR: add_precondition() called but supplied error message [" .. tostring(error_msg_on_failure) .. "] is not a string or nil");
		return false;
	end;

	table.insert(
		self.preconditions, 
		{
			callback = callback,
			error_msg_on_failure = error_msg_on_failure
		}
	);
end;


-- local function to check all preconditions prior to adding this tour
function navigable_tour_section:check_preconditions()
	local preconditions = self.preconditions;
	for i = 1, #preconditions do
		if not preconditions[i].callback() then
			return false, preconditions[i].error_msg_on_failure;
		end;
	end;
	return true;
end;


--- @function action
--- @desc Adds an action to be triggered while the navigable tour section is playing. Actions are added with an interval, which is the time after the start of the section that the action should occur.
--- @p function callback, Callback function to call.
--- @p number interval, Interval after the navigable tour section starts at which the specified action should be triggered. This should be given in seconds in campaign, and in ms in battle and the frontend.
function navigable_tour_section:action(action, action_time)
	if not is_function(action) then
		script_error(self.name .. " ERROR: action() called but supplied action callback [" .. tostring(action) .. "] is not a function");
		return false;
	end;

	if not is_number(action_time) or action_time < 0 then
		script_error(self.name .. " ERROR: action() called but supplied action time [" .. tostring(number) .. "] is not a number");
		return false;
	end;

	table.insert(
		self.actions,
		{
			action = action,
			action_time = action_time
		}
	);
end;











----------------------------------------------------------------------------
--- @section Playback Controls
--- @desc The functions in this section should only be called from within a callback registered to @navigable_tour_section:action, so that they are only called while the navigable tour section is actively playing.
----------------------------------------------------------------------------


-- Local function to call current skip actions
function navigable_tour_section:call_skip_actions(is_tour_ending, is_skipping_backwards)

	local skip_actions = self.skip_actions;
	local skip_actions_copy = {};
	
	for i = 1, #skip_actions do
		skip_actions_copy[i] = skip_actions[i];
	end;
	
	for i = 1, #skip_actions_copy do
		skip_actions_copy[i].skip_action(is_tour_ending, is_skipping_backwards);
	end;
end;


-- Local function to reset current skip actions when the section begins to play
function navigable_tour_section:reset_skip_actions()
	if not self.playing then
		script_error(self.name .. " ERROR: reset_skip_actions() called but this navigable tour section isn't currently playing - this shouldn't happen");
		return false;
	end;

	self.skip_actions = {};
end;


--- @function add_skip_action
--- @desc Adds a skip action for this navigable tour section. Navigable tour sections should use skip callbacks to clean up after themselves. The skip action will be called when this section of the tour is skipped by the player during playback, either by navigating forwards or backwards to other tour sections or by closing the tour. Two @boolean argument will be passed to the skip action function - the first, if <code>true</code>, indicates that the entire tour is ending, and the second, if <code>true</code> indicates that the tour is being skipped backwards rather than forwards.
--- @desc Skip actions may be added with an optional name, by which they be later removed.
--- @desc This function should only be called from within an action when the tour section is running.
--- @p @function skip action
--- @p [opt=nil] @string action name
function navigable_tour_section:add_skip_action(skip_action, name)
	if not self.playing then
		script_error(self.name .. " ERROR: add_skip_action() called but this navigable tour section isn't currently playing");
		return false;
	end;

	if not is_function(skip_action) then
		script_error(self.name .. " ERROR: add_skip_action() called but supplied skip callback [" .. tostring(skip_action) .. "] is not a function");
		return false;
	end;

	if name and not is_string(name) then
		script_error(self.name .. " ERROR: add_skip_action() called but supplied skip callback name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	table.insert(
		self.skip_actions,
		{
			skip_action = skip_action,
			name = name
		}
	);
end;


--- @function remove_skip_action
--- @desc Immediately removes any skip actions from this navigable tour section with the supplied name. This should only be called during an action within the tour section.
--- @p @string action name
function navigable_tour_section:remove_skip_action(name)
	if not self.playing then
		script_error(self.name .. " ERROR: remove_skip_action() called but this navigable tour section isn't currently playing");
		return false;
	end;

	if not is_string(name) then
		script_error(self.name .. " ERROR: remove_skip_action() called but supplied skip callback name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local skip_actions = self.skip_actions;
	for i = #skip_actions, 1, -1 do
		if skip_actions[i].name == name then
			table.remove(skip_actions, i);
		end;
	end;
end;


--- @function activate_tour_controls
--- @desc Activates the tour control panel during playback of the navigable tour section. This should only be called during an action within the tour section.
--- @desc If the activate-controls flag is not set when @navigable_tour_section:new is called, as is the default behaviour, then the tour controls will remain inactive until this function is called during playback. If the last action in the tour section is called and the controls are still not active then this function will be called automatically. This failsafe behaviour prevents a situation where a section is playing and the tour controls never become active, but it should probably be avoided by either calling this function directly during an action within the section or setting the appropriate flag when calling @navigable_tour_section:new.
function navigable_tour_section:activate_tour_controls()
	if not self.playing then
		script_error(self.name .. " WARNING: activate_tour_controls() called but this navigable tour section isn't currently playing");
		return false;
	end;

	self.navigable_tour:enable_tour_controls_for_current_section();
end;


--- @function highlight_next_button
--- @desc Highlights the next (or finish) button on the navigable tour controls during playback. This should only be called during an action within the tour section.
function navigable_tour_section:highlight_next_button()
	if not self.playing then
		script_error(self.name .. " WARNING: highlight_next_button() called but this navigable tour section isn't currently playing");
		return false;
	end;

	if self.next_button_highlight_previously_shown then
		return;
	end;

	self.next_button_highlight_previously_shown = true;

	self.navigable_tour:set_tour_controls_next_button_highlight(true);
end;


--- @function is_playing
--- @desc Is this navigable tour section playing right now.
--- @r @boolean is playing
function navigable_tour_section:is_playing()
	return self.playing;
end;