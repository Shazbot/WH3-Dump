





----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- ACTIVE TEXT POINTERS
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c active_pointer Active Text Pointers
--- @page text_pointer
--- @desc Active pointers are a particular style of @text_pointer, declared as a separate class with a cut-down interface. Visually, an active pointer appears as a text box with a close button and an enlarged pointer arrow with no connecting line. The pointer arrow appears in one of the four corners of the panel.
--- @desc Active pointers are always associated with a @uicomponent at which they visually point. While showing, the active pointer repeatedly polls the properties of this @uicomponent. Should the uicomponent move on-screen, become invisible, or be destroyed, the active pointer will automatically dismiss itself. From an implementation perspective active pointers are intended to be relatively 'fire and forget', requiring a minimum of manual setup in script.
--- @desc An active pointer will automatically immediately hide itself if any parent/ancestor of it, back to the ui root, is seen to play an animation called "hide". This generally occurs when the host panel (e.g. diplomacy panel) is closing.


--- @section Active Pointer Display Methods
--- @desc Once declared, an active pointer may be shown directly with @active_pointer:show. Alternatively, @active_pointer:show_when_ready may be used to show the pointer, which waits until the target uicomponent has stopped moving and become visible before the pointer is shown. @active_pointer:show_when_ready may optionally take a delay value, which imposes a grace period before the text pointer is shown, and a timeout period after which the function will stop trying to show the pointer. Default values for both of these can be set on the active pointer with @active_pointer:set_default_delay and @active_pointer:set_default_timeout.
--- @desc The active pointer interface also provides functionality to allow the pointer itself to manage being shown. @active_pointer:show_on_event may be used to specify a script event and condition on which the active pointer should attempt to display. Furthermore, @active_pointer:wait_for_active_pointer allows this active pointer to be enqueued behind another, so that the foreign active pointer must be shown before this one will attempt to display. One active pointer can wait for multiple other active pointers, which may themselves wait upon other active pointers and so-on.


--- @section Storing in Advice History
--- @desc By default, active pointers store a record when they are displayed in the advice history, and will not display if that record is present when @active_pointer:show is called again. This behaviour, which is enabled by default, requires that the active pointer name is unique amongst active pointers, as the name of the advice history flag is derived from the pointer name.
--- @desc This functionality can be disabled when calling @active_pointer:new by setting the suppress-record boolean argument to <code>true</code>. When this is set to <code>false</code> the active pointer need not have a unique name, but advanced functionality like @active_pointer:show_on_event and @active_pointer:wait_for_active_pointer will not be available.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

local ACTIVE_TEXT_POINTER_COMPONENT_MOVEMENT_THRESHOLD = 4;

active_pointer = {
	name = false,												-- String name for this active pointer. This has to be unique if the pointer is recording itself in the advice history.
	history_name = false,										-- String name to use for this active pointer in the advice history
	output_name = false,										-- String name to use for debug output related to this active pointer
	uic_specifier = false,										-- Specifier for uicomponent to be pointed at - either a direct handle, or a function that returns a direct handle.
	text_pointer = false,										-- Handle to underlying text pointer.
	orientations = {
		topleft = {
			text_pointer_orientation = "top",
			calculate_x_offset = function(width)
				return (width / 2) - 35;
			end,
			calculate_y_offset = function(width)
				return 0;
			end;
		},
		topright = {
			text_pointer_orientation = "top",
			calculate_x_offset = function(width)
				return 35 - (width / 2);
			end,
			calculate_y_offset = function(width)
				return 0;
			end;
		},
		bottomleft = {
			text_pointer_orientation = "bottom",
			calculate_x_offset = function(width)
				return (width / 2) - 35;
			end,
			calculate_y_offset = function(width)
				return 0;
			end;
		},
		bottomright = {
			text_pointer_orientation = "bottom",
			calculate_x_offset = function(width)
				return 35 - (width / 2);
			end,
			calculate_y_offset = function(width)
				return 0;
			end;
		}
	},															-- Static (in the formal sense) list of valid orientations.
	x_proportion = false,										-- Unary x (0 to 1) proportion of the point on the target uicomponent at which the pointer should point.
	y_proportion = false,										-- Unary y (0 to 1) proportion of the point on the target uicomponent at which the pointer should point.
	record_in_advice_history = false,							-- Determines whether this active pointer should leave a marker that it's been shown in the advice history.
																-- Setting this flag imposes that the active pointer has a unique name, and allows functions such as
																-- show_on_event() and show_after_active_pointer() to be used.
	higher_priority_active_pointer_names = {},					-- List of active pointers that this active pointer should wait for
	is_enqueued_to_show = false,								-- This flag is set to true while show_when_ready() has enqueued the active pointer to show
	default_delay = 1,											-- Default delay when show_is_ready() is called, will be multiplied by 1000 when in battle/frontend
	default_timeout = 5,										-- Default timeout when show_is_ready() is called, will be multiplied by 1000 when in battle/frontend
	show_output = false,										-- Show output - this is automatically enabled if we record being shown in the advice history
	show_after_active_pointer_records_for_advice_reset = {},	-- List of show_after_active_pointer processes to restart if advice history is reset
	show_on_event_records_for_advice_reset = {},				-- List of show_on_event processes to restart if advice history is reset
	hide_on_event_records = {},									-- List of event and conditions which should cause the text pointer to immediately hide
	hide_immediately_on_parent_with_hide_animation = true		-- Sets that the active pointer should hide itself immediately if it finds that it has a parent/ancestor
																-- uicomponent with an animation called "hide". This is presumed to be the host panel closing, at which
																-- point the active panel will hide itself immediately
};


set_class_custom_type(active_pointer, TYPE_ACTIVE_POINTER);
set_class_tostring(
	active_pointer,
	function(obj)
		return TYPE_ACTIVE_POINTER .. "_" .. obj.name
	end
);






----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new active text pointer object.
--- @p @string name, Name for this text pointer. If this pointer is storing a record in the advice history (which is the default behaviour, and must be opted-out of by setting this suppress record in advice argument to <code>true</code> on this function) then the supplied name must be unique.
--- @p @string orientation, Orientation of the pointer arrow that is drawn. Supported values are <code>"topleft"</code>, <code>"topright"</code>, <code>"bottomleft"</code> and <code>"bottomright"</code>.
--- @p @uicomponent/@function uicomponent specifier, Specifier of uicomponent to point at. This can either be a @uicomponent object or a @function that returns a uicomponent. It's strongly recommended that if the text pointer is not being displayed immediately after being created that a function is used.
--- @p @string text key, Localised text key to display, in <code>[table]_[field]_[key]</code> format.
--- @p [opt=0.5] @number x proportion, Unary x proportion specifying a pointed position relative to the dimensions of the specified component. Supply <code>0</code> to point at the left edge of the component, <code>1</code> to point at the right edge of the component, or 0.5 to point at the middle of the component, for example. Values less than zero or greater than one are valid.
--- @p [opt=0.5] @number y proportion, Unary y proportion specifying a pointed position relative to the dimensions of the specified component. Supply <code>0</code> to point at the top edge of the component, <code>1</code> to point at the bottom edge of the component, or <code>0.5</code> to point at the middle of the component, for example. Values less than zero or greater than one are valid.
--- @p [opt=250] @number width, Width of the text pointer panel in pixels.
--- @p [opt=false] @boolean suppress record, Sets this active pointer to not record a record of whether it's been triggered in advice history. If this is set to <code>true</code> then the active pointer is not registered with the script core, and it doesn't need to have a unique name. However, the active pointer will not be able to automatically listen for events.
--- @r @active_pointer active text pointer
function active_pointer:new(name, orientation, uic_specifier, localised_text_key, x_proportion, y_proportion, width, suppress_record_in_advice_history)
	if not is_string(name) then
		script_error("ERROR: active_pointer:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(orientation) then
		script_error("ERROR: active_pointer:new() called but supplied orientation [" .. tostring(orientation) .. "] is not a string");
		return false;
	end;

	-- get an orientation record to match the supplied orientation
	local orientation_record = self.orientations[orientation];
	if not orientation_record then
		-- no orientation record was found, so assemble an error string
		local valid_str = "";
		local first_record_added = false;
		for name in pairs(self.orientations) do
			if first_record_added then
				valid_str = valid_str .. "," .. name;
			else
				valid_str = valid_str .. name;
				first_record_added = true;
			end;
		end;

		script_error("ERROR: active_pointer:new() called but supplied orientation [" .. tostring(orientation) .. "] is not a supported orientation. Valid orientations are [" .. valid_str .. "]");
	end;
	
	if not is_uicomponent(uic_specifier) and not is_function(uic_specifier) then
		script_error("ERROR: active_pointer:new() called but supplied uicomponent specifier [" .. tostring(uic_specifier) .. "] is not a uicomponent or a function");
		return false;
	end;

	if not is_string(localised_text_key) then
		script_error("ERROR: active_pointer:new() called but supplied localised text key [" .. tostring(localised_text_key) .. "] is not a string");
		return false;
	end;

	if x_proportion and not is_number(x_proportion) then
		script_error("ERROR: active_pointer:new() called but supplied x proportion [" .. tostring(x_proportion) .. "] is not a number or nil");
		return false;
	end;

	if y_proportion and not is_number(y_proportion) then
		script_error("ERROR: active_pointer:new() called but supplied y proportion [" .. tostring(x_proportion) .. "] is not a number or nil");
		return false;
	end;

	if width and not is_number(width) then
		script_error("ERROR: active_pointer:new() called but supplied width override [" .. tostring(width) .. "] is not a number");
		return false;
	end;

	if suppress_record_in_advice_history and not is_boolean(suppress_record_in_advice_history) then
		script_error("ERROR: active_pointer:new() called but supplied suppress_record_in_advice_history flag [" .. tostring(suppress_record_in_advice_history) .. "] is not a boolean");
		return false;
	end;

	local ap = {};

	ap.name = name;
	ap.history_name = name .. "_action_ptr";					-- name used for advice history
	ap.output_name = "ap_" .. name;
	ap.uic_specifier = uic_specifier;

	ap.higher_priority_active_pointer_names = {};

	ap.hide_on_event_records = {};

	ap.show_after_active_pointer_records_for_advice_reset = {};
	ap.show_on_event_records_for_advice_reset = {};

	-- default width and target position (proportional to target uic dimensions)
	width = width or 250;
	x_proportion = x_proportion or 0.5;
	y_proportion = y_proportion or 0.5;
		
	local tp = text_pointer:new_from_component(
		name,
		orientation_record.text_pointer_orientation,
		22,
		uic_specifier,
		x_proportion,
		y_proportion
	);

	tp:add_component_text("text", localised_text_key);
	tp:set_style("active");
	tp:set_panel_width(width);
	tp:set_label_offset(orientation_record.calculate_x_offset(width), orientation_record.calculate_y_offset());

	ap.text_pointer = tp;

	-- set this object to pass further calls through to the constructed text pointer
	set_object_class(ap, self, tp);

	-- set this special flag which means the text pointer doesn't assert if the uicomponent can't be found
	tp.silent_on_uicomponent_find_failure = true;

	local process_name = "ap_" .. name .. "_repeat_callback";

	local poll_time;
	local tm = core:get_tm();

	if core:is_campaign() then
		poll_time = 0.1;
	else
		poll_time = 100;
		ap.default_delay = ap.default_delay * 1000;
		ap.default_timeout = ap.default_timeout * 1000;
	end;

	-- set up monitor which closes the text pointer if the target uic moves or is destroyed		
	tp:add_show_callback(
		function()
			local uic = ap:get_uicomponent();

			if not uic:Visible(true) then
				script_error(ap.output_name .. " WARNING: showing active pointer but the uicomponent being pointed at is invisible, so the pointer will hide straight away. uicomponent is " .. uicomponent_to_str(uic));
			end;

			-- hide all other text pointers
			-- core:hide_all_text_pointers();

			-- pulse panel
			-- pulse_uicomponent(tp:get_text_label(), true, 5, true);

			-- cache the current position of the uic being pointed at
			local cached_x, cached_y = uic:Position();
			
			-- repeatedly poll the uic being pointed at
			tm:repeat_callback(
				function()	
					local should_hide = false;
					local force_hide_immediately = false;
					
					if uic:IsValid() then
						local current_x, current_y = uic:Position();

						-- check whether this uicomponent has a parent/ancestor playing a "hide" animation and hide ourselves immediately, if we should
						if self.hide_immediately_on_parent_with_hide_animation and
							uicomponent_has_parent_filter(uic, function(uic_parent) return uic_parent:CurrentAnimationId() == "hide" end) then
							
							should_hide = true;
							force_hide_immediately = true;
						end;

						-- if the uic being pointed at has not moved, and is still visible, then don't hide it
						if not should_hide and (math.abs(current_x - cached_x) > ACTIVE_TEXT_POINTER_COMPONENT_MOVEMENT_THRESHOLD or math.abs(current_y - cached_y) > ACTIVE_TEXT_POINTER_COMPONENT_MOVEMENT_THRESHOLD or not uic:Visible(true)) then
							should_hide = true;
						end;	
					end;

					if should_hide then
						if tp:is_showing() then
							if force_hide_immediately then
								ap:out("hiding text pointer immediately");
							else
								ap:out("hiding text pointer");
							end;
							tp:hide(force_hide_immediately);
						end;
					end;
				end,
				poll_time,
				process_name
			);

			-- also listen for a hide-event being received
			for i = 1, #ap.hide_on_event_records do
				local current_hide_on_event_record = ap.hide_on_event_records[i];

				core:add_listener(
					process_name,
					current_hide_on_event_record.event,
					current_hide_on_event_record.condition,
					function()

						if current_hide_on_event_record.hide_immediately then 
							ap:out("received " .. current_hide_on_event_record.event .. " event and condition passes so hiding");
						else
							ap:out("received " .. current_hide_on_event_record.event .. " event and condition passes so hiding immediately");
						end;
						
						if tp:is_showing() then
							tp:hide(current_hide_on_event_record.hide_immediately);
						end;
					end,
					false
				);
			end;
		end
	);
	
	-- if the text pointer gets hidden for any reason then stop the polling process/listeners
	tp:add_hide_callback(
		function() 
			core:remove_listener(process_name);
			tm:remove_callback(process_name);
		end
	);


	-- listen for this text pointer hiding and cancel listeners
	core:add_listener(
		process_name,
		"ScriptEventTextPointerHiding",
		function(context) return context.string == name end,
		function(context)
			tm:remove_callback(process_name);
		end,
		false
	);

	-- hide this active pointer immediately if a PanelClosedCampaign event is received
	ap:add_hide_on_event_record("PanelClosedCampaign", true, true);

	-- register the pointer if we should record it in advice history
	if suppress_record_in_advice_history then
		ap.record_in_advice_history = false;
	else
		if not core:register_active_pointer(ap) then
			-- register_active_pointer() will have thrown a script error
			return;
		end;

		-- we show output if we're recording in advice history
		ap.show_output = true;

		ap.record_in_advice_history = true;

		-- listen for advice history being reset and restart our event listeners
		ap:start_advice_history_reset_listener();
	end;

	return ap;
end;










----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once a <code>active_pointer</code> object has been created with @active_pointer:new, functions on it may be called in the form showed below. Active text pointers inherit from text pointers, so all functions provided by the @text_pointer interface may be called on a active_pointer.
--- @new_example Specification
--- @example <i>&lt;text_pointer_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local ap_example = active_pointer:new(
--- @example 	"example",
--- @example 	"bottomright",
--- @example 	"ui_text_replacements_localised_text_example_text_pointer_str",
--- @example 	function()
--- @example 		-- function that should return a uicomponent
--- @example 		return find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "main_button_bar", "menu_buttons", "button_quick_deal");
--- @example 	end,
--- @example 	-- point at top-right of uicomponent
--- @example 	0.25,
--- @example 	0.75
--- @example )
--- @example 
--- @example -- calling a function on the object once created
--- @example ap_example:show_when_ready()








-- internal function to start a listener for the advice history being reset
function active_pointer:start_advice_history_reset_listener()

	core:add_listener(
		self.output_name .. "_advice_history",
		"AdviceCleared",
		true,
		function()
			-- cancel all event listeners still running
			core:remove_listener(self.name .. "_trigger_listener");

			-- restart all event listeners
			local show_after_active_pointer_records = self.show_after_active_pointer_records_for_advice_reset;
			for i = 1, #show_after_active_pointer_records do
				local current_record = show_after_active_pointer_records[i];
				self:start_show_after_active_pointer_listener(current_record.pointer_name, current_record.delay, current_record.timeout);
			end;

			local show_on_event_records = self.show_on_event_records_for_advice_reset;
			for i = 1, #show_on_event_records do
				local current_record = show_on_event_records[i];
				self:start_show_on_event_listener(current_record.event, current_record.condition, current_record.delay, current_record.timeout);
			end;

			self:out("Responding to advice being cleared, have restarted " .. #show_after_active_pointer_records + #show_on_event_records .. " monitors");
		end,
		true
	);
end;










----------------------------------------------------------------------------
--- @section Configuration
----------------------------------------------------------------------------


--- @function set_default_delay
--- @desc Sets a default delay period for this active pointer, which is the period between when @active_pointer:show_when_ready has detected that the pointer is ready to be shown and when the pointer is actually shown. Any default set here may be overridden when @active_pointer:show_when_ready, @active_pointer:show_after_active_pointer or @active_pointer:show_on_event are called.
--- @p @number delay, Delay value. This should be set in seconds in campaign, and milliseconds in battle or in the frontend.
function active_pointer:set_default_delay(delay)
	if not is_number(delay) or delay < 0 then
		script_error(self.output_name .. " ERROR: set_default_delay() called but supplied delay value [" .. tostring(delay) .. "] is not a positive number");
		return false;
	end;

	self.default_delay = delay;
end;


--- @function set_default_timeout
--- @desc Sets a default timeout period for this active pointer, which is the period over which @active_pointer:show_when_ready will poll the target uicomponent to see if it becomes visible and stops moving. If the timeout period elapses then the attempt to show the text pointer is stopped. By default this is 5 seconds in campaign, or 5000ms in battle or the frontend.
--- @p @number timeout, Default timeout value. This should be set in seconds in campaign, and milliseconds in battle or in the frontend.
function active_pointer:set_default_timeout(timeout)
	if not is_number(timeout) or timeout < 0 then
		script_error(self.output_name .. " ERROR: set_default_timeout() called but supplied timeout value [" .. tostring(timeout) .. "] is not a positive number");
		return false;
	end;

	self.default_timeout = timeout;
end;


-- internal function to return the underlying text pointer
function active_pointer:get_uicomponent()
	if is_function(self.uic_specifier) then
		return self.uic_specifier();
	end;

	return self.uic_specifier;
end;

-- internal function to record display of this text pointer in advice history
function active_pointer:record_usage_in_advice()
	common.set_advice_history_string_seen(self.history_name);
end;


-- internal function to determine whether this text pointer has been displayed before
function active_pointer:is_usage_recorded_in_advice()
	local is_seen = common.get_advice_history_string_seen(self.history_name);
	return is_seen;
end;


-- internal function to determine whether all active pointers marked as higher-priority than this one have been shown
function active_pointer:all_higher_priority_pointers_shown()
	for i = 1, #self.higher_priority_active_pointer_names do
		local current_ap = core:get_active_pointer(self.higher_priority_active_pointer_names[i]);

		if current_ap and not current_ap:is_usage_recorded_in_advice() then
			return false, current_ap.name;
		end;
	end;
	return true;
end;


-- debug output function
function active_pointer:out(str)
	if self.show_output then
		out.design(table.concat({"[", self.output_name, "]: ", str}));
	end;
end;











----------------------------------------------------------------------------
--- @section Hide on Event
--- @desc While being displayed, the active pointer polls its target uicomponent and will automatically hide itself once the target uicomponent moves or becomes invisible. Due to the inherent delay when polling with a model timer, in certain circumstances there is a visible delay before the text pointer hides. @active_pointer:add_hide_on_event_record can be used to make the active pointer directly respond to script events and hide itself before its poll picks up on a ui state change.
----------------------------------------------------------------------------


--- @function add_hide_on_event_record
--- @desc Adds a hide-on-event record for this active pointer. If the event is received while the active pointer is being shown, and the optional conditional check passes, then the active pointer is hidden. An optional flag specifies whether this hide should happen immediately, without any fade animation.
--- @p @string event name, Script event name.
--- @p [opt=true] @function/@boolean condition, Conditional check. This can be a function that returns a boolean, or <code>true</code> to always pass when the supplied event is received.
--- @p [opt=true] @boolean hide immediately, Hide the text pointer immediately, without a fade animation.
function active_pointer:add_hide_on_event_record(event, condition, hide_immediately)
	if not is_string(event) then
		script_error(self.output_name .. " ERROR: add_hide_on_event_record() called but supplied event name [" .. tostring(event) .. "] is not a string");
		return false;
	end;

	if condition == nil then
		condition = true;
	elseif not (is_function(condition) or condition == true) then
		script_error(self.output_name .. " ERROR: add_hide_on_event_record() called but supplied condition [" .. tostring(condition) .. "] is not a function or true");
		return false;
	end;

	if hide_immediately ~= false then
		hide_immediately = true;
	end;

	table.insert(
		self.hide_on_event_records,
		{
			event = event,
			condition = condition,
			hide_immediately = hide_immediately
		}
	);
end;











----------------------------------------------------------------------------
--- @section Direct Triggering
----------------------------------------------------------------------------


--- @function show
--- @desc Immediately shows the text pointer, unless it's been set to pay attention to advice history (and has already been shown).
function active_pointer:show()
	if self.record_in_advice_history then
		if self:is_usage_recorded_in_advice() then
			return false;
		end;

		local can_show, higher_priority_advice_not_shown = self:all_higher_priority_pointers_shown();
		if not can_show then
			return false;
		end;

		-- remove all current event listeners
		core:remove_listener(self.name .. "_trigger_listener");

		self:record_usage_in_advice();
	end;

	self:out("is showing");

	core:trigger_event("ScriptEventActivePointerShowing", self.name);

	self.text_pointer:show();
end;


--- @function show_when_ready
--- @desc Shows the active text pointer when the target uicomponent that was specified when the active pointer was created is not moving, is visible, and is fully onscreen. If this does not happen within the timeout period (default 5 seconds) then the process is cancelled.
--- @p [opt=0] @number delay override, Delay between the uicomponent stopping moving/becoming visible and the text pointer actually being shown. This should be supplied in seconds in campaign, and in milliseconds in battle and the frontend. The default value is 1 second, or 1000ms, or whatever has been set with @active_pointer:set_default_delay.
--- @p [opt=0] @number timeout override, Timeout period override. The timeout is the elapsed period after which the show_when_ready process will halt if the target uicomponent has not stopped moving or become visible. In campaign this should be supplied in seconds, and defaults to either 5 or whatever value has been set with @active_pointer:set_default_timeout. In battle and the frontend, the timeout period is set in milliseconds and defaults to 5000.
function active_pointer:show_when_ready(delay, timeout)
	-- don't show if we're already currently attempting to show or are already showing
	if self.text_pointer:is_showing() or self.is_enqueued_to_show then
		self:out("not showing as active pointer is already showing or is about to show");
		return false;
	end;
	
	if self.record_in_advice_history then
		if self:is_usage_recorded_in_advice() then
			self:out("not showing as active pointer has already been shown");
			return false;
		end;
		
		local can_show, higher_priority_advice_not_shown = self:all_higher_priority_pointers_shown();
		if not can_show then
			self:out("not showing as a higher-priority active pointer [" .. tostring(higher_priority_advice_not_shown) .. "] has yet to show");
			return false;
		end;

		if core:is_any_active_pointer_showing() then
			local is_other_pointer_showing, other_pointer_showing = core:is_any_active_pointer_showing();
			self:out("not showing as active pointer [" .. tostring(other_pointer_showing) .. "] is currently showing");
			return false;
		end;
	end;

	delay = delay or self.default_delay;			-- can be seconds (campaign) or ms (battle/frontend)
		
	local poll_time = 0.1;
	local tm = core:get_tm();
	
	if core:is_campaign() then
		timeout = timeout or self.default_timeout;					-- seconds
		max_tries = timeout / poll_time;
	else
		timeout = timeout or self.default_timeout;					-- ms
		poll_time = 100;
	end;
	
	local max_tries = timeout / poll_time;
	local num_tries = 0;

	local previous_x, previous_y;

	local process_name = self.output_name .. "_show_when_ready";

	-- cancel any previous show_when_ready process
	tm:remove_callback(process_name);

	-- start polling process
	tm:repeat_callback(
		function()
			-- stop if we've exceeded the max number of tries
			if num_tries > max_tries then
				self:out("show when ready process is stopping as the timeout period has elapsed and the target uicomponent hasn't become valid/visible and stopped moving");
				tm:remove_callback(process_name);
				return;
			end;

			-- stop if another active pointer is showing
			if self.record_in_advice_history and core:is_any_active_pointer_showing() then
				local is_other_pointer_showing, other_pointer_showing = core:is_any_active_pointer_showing();
				self:out("show when ready process is stopping as active pointer [" .. tostring(other_pointer_showing.name) .. "] is currently showing");
				tm:remove_callback(process_name);
				return false;
			end;

			local uic = self:get_uicomponent();
			
			if uic and uic:IsValid() then
				local current_x, current_y = uic:Position();

				if not previous_x then
					previous_x = current_x;
					previous_y = current_y;
				else
					if current_x == previous_x and current_y == previous_y and uic:VisibleFromRoot() and is_fully_onscreen(uic) then
						if delay == 0 then
							self:show();
						else
							self.is_enqueued_to_show = true;
							tm:callback(
								function()
									self.is_enqueued_to_show = false;
									
									-- test the target uic one last time before showing the text pointer
									local uic = self:get_uicomponent();
									if uic and uic:IsValid() then
										self:show();
									else
										if core:is_campaign() then
											self:out("show when ready process was unable to show the pointer after a delay of " .. delay .. "s as the target uicomponent no longer exists");
										else
											self:out("show when ready process was unable to show the pointer after a delay of " .. delay .. "ms as the target uicomponent no longer exists");
										end;
									end;
								end, 
								delay
							);
						end;
						tm:remove_callback(process_name);
					else
						previous_x = current_x;
						previous_y = current_y;
					end;
				end;
			end;

			num_tries = num_tries + 1;
		end,
		poll_time,
		process_name
	);
end;











----------------------------------------------------------------------------
--- @section Managed Triggering
--- @desc These functions are only supported when the active pointer is set to store its use in the advice history - see the @"active_pointer:Storing in Advice History" section for more information.
----------------------------------------------------------------------------


--- @function wait_for_active_pointer
--- @desc Prevents this active pointer from being shown before another active pointer has been shown. An active pointer may wait for multiple other active pointers, each wait being registered with a call to this function. Should multiple waits be set up for an active pointer, it will fail to display until all active pointers being waited for have finished showing.
--- @desc This function sets up an @active_pointer:show_after_active_pointer process automatically, which attempts to show this pointer once the active pointer being waited for is dismissed.
--- @desc This active pointer must have registered itself in the advice history for this function to work.
--- @p @string active pointer name, Name of active pointer to wait for. The active pointer being waited for must have registered itself in the advice history.
--- @p [opt=0] @number delay override, Delay override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. This is the delay between the uicomponent stopping moving/becoming visible and the text pointer actually being shown. This should be supplied in seconds in campaign, and in milliseconds in battle and the frontend. The default value is 1 second, or 1000ms, or whatever has been set with @active_pointer:set_default_delay.
--- @p [opt=0] @number timeout override, Timeout period override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. The timeout is the elapsed period after which the show_when_ready process will halt if the target uicomponent has not stopped moving or become visible. In campaign this should be supplied in seconds, and defaults to either 5 or whatever value has been set with @active_pointer:set_default_timeout. In battle and the frontend, the timeout period is set in milliseconds and defaults to 5000.
function active_pointer:wait_for_active_pointer(pointer_name, delay, timeout)
	if not is_string(pointer_name) then
		script_error(self.output_name .. " ERROR: wait_for_active_pointer() called but supplied pointer name [" .. tostring(pointer_name) .. "] is not a string");
		return false;
	end;

	if not self.record_in_advice_history then
		script_error(self.output_name .. " ERROR: wait_for_active_pointer() called but this pointer is not recording itself in advice history - only such unique pointers support this functionality");
		return false;
	end;

	table.insert(self.higher_priority_active_pointer_names, pointer_name);
	
	self:add_show_after_active_pointer_record_for_advice_reset(pointer_name, delay, timeout);

	self:start_show_after_active_pointer_listener(pointer_name, delay, timeout);
end;


--- @function show_after_active_pointer
--- @desc Sets up a listener that attempts to show this active pointer once the specified active pointer closes. Unlike @active_pointer:wait_for_active_pointer this doesn't demand that the specified active pointer must have first been shown before this active pointer can be shown - this active pointer could trigger before the specified active pointer (from a different event, for example).
--- @desc This active pointer must have registered itself in the advice history for this function to work.
--- @p @string active pointer name, Name of active pointer to wait for. The active pointer being waited for must have registered itself in the advice history.
--- @p [opt=0] @number delay override, Delay override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. This is the delay between the uicomponent stopping moving/becoming visible and the text pointer actually being shown. This should be supplied in seconds in campaign, and in milliseconds in battle and the frontend. The default value is 1 second, or 1000ms, or whatever has been set with @active_pointer:set_default_delay.
--- @p [opt=0] @number timeout override, Timeout period override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. The timeout is the elapsed period after which the show_when_ready process will halt if the target uicomponent has not stopped moving or become visible. In campaign this should be supplied in seconds, and defaults to either 5 or whatever value has been set with @active_pointer:set_default_timeout. In battle and the frontend, the timeout period is set in milliseconds and defaults to 5000.
function active_pointer:show_after_active_pointer(pointer_name, delay, timeout)
	if not is_string(pointer_name) then
		script_error(self.output_name .. " ERROR: show_after_active_pointer() called but supplied pointer name [" .. tostring(pointer_name) .. "] is not a string");
		return false;
	end;

	if not self.record_in_advice_history then
		script_error(self.output_name .. " ERROR: show_after_active_pointer() called but this pointer is not recording itself in advice history - only such unique pointers support this functionality");
		return false;
	end;
	
	self:add_show_after_active_pointer_record_for_advice_reset(pointer_name, delay, timeout);

	self:start_show_after_active_pointer_listener(pointer_name, delay, timeout);
end;


-- internal function to add a show_after_active_pointer listener to an internal table 
function active_pointer:add_show_after_active_pointer_record_for_advice_reset(pointer_name, delay, timeout)
	table.insert(
		self.show_after_active_pointer_records_for_advice_reset,
		{
			pointer_name = pointer_name,
			delay = delay,
			timeout = timeout
		}
	);
end;


-- internal function to start a show after active pointer listener
function active_pointer:start_show_after_active_pointer_listener(pointer_name, delay, timeout)
	core:add_listener(
		self.name .. "_trigger_listener",
		"ScriptEventTextPointerHiding",
		function(context) 
			return context.string == pointer_name 
		end,
		function()
			if not self:is_usage_recorded_in_advice() then
				if self.show_output then
					self:out("active pointer [" .. pointer_name.. "] has finished being shown, so attempting to show this pointer");
				end;
				self:show_when_ready(delay, timeout);
			end;
		end,
		true
	);
end;


--- @function show_on_event
--- @desc Sets the active pointer to trigger when a script event is received, with an optional conditional check that must be passed.
--- @desc This active pointer must have registered itself in the advice history for this function to work.
--- @p @string event, Event name.
--- @p [opt=true] @boolean/@function condition, Conditional check. This may be omitted, or <code>true</code> may be supplied to always trigger whenever the supplied event is received.
--- @p [opt=0] @number delay override, Delay override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. This is the delay between the uicomponent stopping moving/becoming visible and the text pointer actually being shown. This should be supplied in seconds in campaign, and in milliseconds in battle and the frontend. The default value is 1 second, or 1000ms, or whatever has been set with @active_pointer:set_default_delay.
--- @p [opt=0] @number timeout override, Timeout period override, which will be supplied to @active_pointer:show_when_ready if this monitor tries to show the pointer. The timeout is the elapsed period after which the show_when_ready process will halt if the target uicomponent has not stopped moving or become visible. In campaign this should be supplied in seconds, and defaults to either 5 or whatever value has been set with @active_pointer:set_default_timeout. In battle and the frontend, the timeout period is set in milliseconds and defaults to 5000.
function active_pointer:show_on_event(event, condition, delay, timeout)
	if not is_string(event) then
		script_error(self.output_name .. " ERROR: show_on_event() called but supplied event [" .. tostring(event) .. "] is not a string");
		return false;
	end;

	if not condition then
		condition = true;
	elseif not (condition == true or is_function(condition)) then
		script_error(self.output_name .. " ERROR: show_on_event() called but supplied condition [" .. tostring(condition) .. "] is not a function, nil, or true");
		return false;
	end;

	if delay and not is_number(delay) then
		script_error(self.output_name .. " ERROR: show_on_event() called but supplied delay [" .. tostring(delay) .. "] is not a number or nil");
		return false;
	end;

	if timeout and not is_number(timeout) then
		script_error(self.output_name .. " ERROR: show_on_event() called but supplied timeout [" .. tostring(timeout) .. "] is not a number or nil");
		return false;
	end;

	-- make a record so that the listener may be restarted if the advice history is reset
	table.insert(
		self.show_on_event_records_for_advice_reset,
		{
			event = event,
			condition = condition,
			delay = delay,
			timeout = timeout
		}
	);

	self:start_show_on_event_listener(event, condition, delay, timeout);
end;


-- internal function to start the show-on-event listener
function active_pointer:start_show_on_event_listener(event, condition, delay, timeout)
	core:add_listener(
		self.name .. "_trigger_listener",
		event,
		condition,
		function()
			if not self:is_usage_recorded_in_advice() then
				if is_function(condition) then
					self:out("event " .. event .. " received and condition check passes, so attempting to show this pointer");
				else
					self:out("event " .. event .. " received and no condition check was specified, so attempting to show this pointer");
				end;
				self:show_when_ready(delay, timeout);
			end;
		end,
		true
	);
end;
