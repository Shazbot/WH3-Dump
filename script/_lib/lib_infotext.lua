






----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INFOTEXT MANAGER
--
--	Provides a wrapper for setting and managing infotext. This is the bullet-pointed text
--	that can appear below the advisor panel.
--
--- @set_environment battle
--- @set_environment campaign
--- @c infotext_manager Infotext Manager
--- @desc The infotext manager provides an interface for setting and managing infotext. This is the text panel that appears below the advisor and hosts text breaking down the advisor string into game terms.
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

infotext_manager = {
	uic_advice_interface = false,
	uic_infotext = false,
	min_add_to_show_interval = 0.5,
	line_delay = 0.5,
	infotext_currently_being_added = false,
	infotext_queue = {},
	parser = nil,
	state_overrides = {},
	button_state_overrides = {},
	advice_history_listeners_started = false,			-- have the advice history listeners been started
	last_advice_shown = false,							-- key of most-recent advice shown
	infotext_to_advice_history = {},					-- junction between advice records and infotext
	infotext_docked_to_advisor = true,					-- is the infotext panel docked to the advisor panel
	cached_infotext_topmost = true,
	cached_detatched_infotext_priority = -1
};


set_class_custom_type_and_tostring(infotext_manager, TYPE_INFOTEXT_MANAGER);

local TOPIC_LEADER_HOLD_DURATION_FOR_INFOTEXT = 2000;


----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates an infotext manager. It should never be necessary for client scripts to call this directly, for an infotext manager is automatically set up whenever a @battle_manager or @campaign_manager is created.
--- @r infotext_manager
function infotext_manager:new()
	local i = core:get_static_object("infotext_manager");
	if i then
		return i;
	end;

	i = {};
	
	set_object_class(i, self);
	
	i.infotext_queue = {};
	i.state_overrides = {};
	i.button_state_overrides = {};
	i.infotext_to_advice_history = {};
	i.parser = link_parser:new();
	
	core:add_listener(
		"infotext_manager_history_button_listeners",
		"AdviceNavigated",
		true,
		function(context)
			i:show_infotext_for_advice_from_history(context.string);
			i:parse_history_page_for_tooltips();
		end,
		true	
	);	
	
	core:add_listener(
		"infotext_button_monitor",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_infotext_entry";
		end,
		function(context)
			local uic_infotext_line = UIComponent(UIComponent(context.component):Parent());
			local button_state_override_record = i.button_state_overrides[uic_infotext_line:Id()];
	
			if button_state_override_record then
				button_state_override_record.on_click_callback();
			end;
		end,
		true
	);

	core:add_static_object("infotext_manager", i);

	return i;
end;








--- @end_class
--- @section Infotext Manager

--- @function get_infotext_manager
--- @desc Gets an infotext manager, or creates one if one doesn't already exist.
--- @r infotext_manager
function get_infotext_manager()
	return infotext_manager:new();
end;

--- @c infotext_manager Infotext Manager







----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once a <code>infotext_manager</code> object has been created with @infotext_manager:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;infotext_manager_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local im = infotext_manager:new()						-- set up automatically by campaign or battle managers
--- @example local uic_advice_interface = im:get_uicomponent()		-- calling a function on the object once created









----------------------------------------------------------------------------
--	UI component creation. For internal use.
----------------------------------------------------------------------------

function infotext_manager:setup_infotext_uicomponents()
	if self.uic_advice_interface then
		return;
	end;

	self.uic_advice_interface = find_uicomponent("advice_interface");
	
	if self.infotext_docked_to_advisor and self.uic_advice_interface and is_uicomponent(self.uic_advice_interface) then
		self.uic_infotext = find_uicomponent(self.uic_advice_interface, "info_text");
	else
		self.uic_infotext = find_uicomponent("under_advisor_docker", "info_text");
	end;
end;


----------------------------------------------------------------------------
---	@section UI Component
----------------------------------------------------------------------------

--- @function get_uicomponent
--- @desc Gets a uicomponent handle to the advisor interface panel.
--- @r @uicomponent uicomponent
function infotext_manager:get_uicomponent()
	self:setup_infotext_uicomponents();
	
	return self.uic_advice_interface;
end;


--- @function get_infotext_panel
--- @desc Gets a uicomponent handle to the infotext panel.
--- @r @uicomponent uicomponent
function infotext_manager:get_infotext_panel()
	self:setup_infotext_uicomponents();
	
	return self.uic_infotext;
end;






----------------------------------------------------------------------------
---	@section Attach to Advisor
----------------------------------------------------------------------------


--- @function attach_to_advisor
--- @desc Attaches or detaches the infotext panel from the advisor panel. When detached, infotext may be triggered independently of advice, and the infotext panel will not close when the advisor panel is closed.
--- @p [opt=true] @boolean should attach
function infotext_manager:attach_to_advisor(should_attach)
	should_attach = not not should_attach;
	self:setup_infotext_uicomponents();
	self.uic_advice_interface:InterfaceFunction("dock_infotext_to_advice", should_attach);
	self.infotext_docked_to_advisor = should_attach;
end;


--- @function is_attached_to_advisor
--- @desc Returns whether the infotext panel is attached to the advisor.
--- @r @boolean infotext is attached
function infotext_manager:is_attached_to_advisor()
	self:setup_infotext_uicomponents();
	return self.uic_advice_interface:InterfaceFunction("is_infotext_docked_to_advice");
end;


--- @function cache_and_set_detached_infotext_priority
--- @desc After the infotext panel is undocked, sets the priority to the supplied value, and caches the value previously set. The infotext priority can later be restored with <code>restore_detatched_infotext_priority</code>.
--- @desc The register_topmost flag can also be set to force the infotext to topmost.
function infotext_manager:cache_and_set_detached_infotext_priority(new_priority, register_topmost)
	if not is_number(new_priority) then
		script_error("ERROR: cache_and_set_detached_infotext_priority() called but supplied priority [" .. tostring(new_priority) .."] is not a number");
		return false;
	end;
	
	-- cache the current infotext priority and set it to its new value
	if self.uic_infotext and self.infotext_docked_to_advisor == false then

		self.cached_detatched_infotext_priority = self.uic_infotext:Priority()
		self.uic_infotext:PropagatePriority(new_priority);
		
		if register_topmost then
			self.uic_infotext:RegisterTopMost();
			self.cached_infotext_topmost = true;
		end;
	end
	
end;

--- @function restore_detatched_infotext_priority
--- @desc Restores the advisor priority to a value previously cached with <code>cache_and_set_detached_infotext_priority</code>.
function infotext_manager:restore_detatched_infotext_priority()
	if self.cached_advisor_priority == -1 then
		script_error("WARNING: restore_detatched_infotext_priority() called but infotext priority hasn't been previously cached with cache_and_set_detached_infotext_priority() - be sure to call that first");
		return false;
	end;
	
	if self.uic_infotext and self.infotext_docked_to_advisor == false then
		
		if self.cached_infotext_topmost then
			self.cached_infotext_topmost = false;
			self.uic_infotext:RemoveTopMost();
		end;
	
		self.uic_infotext:PropagatePriority(self.cached_advisor_priority)
	end;
	
end








----------------------------------------------------------------------------
--- @section State Overrides
---	@desc State overrides allow calling scripts to map a given line of infotext to being shown in a different component state. This is to allow certain lines of infotext to be shown in a different configuration, or with images, such as an image of WASD keys along with text instructing the player how to move the camera.
----------------------------------------------------------------------------

--- @function set_state_override
--- @desc Maps a state override to a infotext key. When an infotext entry with this key is shown, the state of the infotext line component is overriden to that supplied here. This is generally called somewhere at the start of the calling script, with the actual infotext line being shown later.
--- @p string infotext key, Infotext key
--- @p string component state override, Component state override. This much match the name of a state on the infotext line component (editable in UIEd)
function infotext_manager:set_state_override(component_id, state_override)
	if not is_string(component_id) then
		script_error("ERROR: set_state_override() called but supplied component id [" .. tostring(component_id) .. "] is not a string");
		return false;
	end;
	
	if not is_string(state_override) then
		script_error("ERROR: set_state_override() called but supplied state override [" .. tostring(state_override) .. "] is not a string");
		return false;
	end;
	
	self.state_overrides[component_id] = state_override;
end;



--- @function set_button_state_override
--- @desc Marks a advice infotext key with an override that causes a button to be shown if or when it's later displayed. After a particular infotext key is marked with this function, should that infotext be later displayed with @infotext_manager:add_infotext then that infotext line will display a button instead of normal text. When the player clicks that button the supplied on-click callback is called.
--- @desc Should an on-display callback be supplied to this function, that callback is called each time the infotext entry is added i.e. when the button is shown. It is passed the button uicomponent as a single argument. This callback can do processing to determine if it wants to change the state of the button e.g. make it inactive.
--- @desc Should an event be supplied to this function, the button will disable when the event is received.
--- @p @string infotext key
--- @p @function on-click callback
--- @p [opt=nil] @function on-display callback
--- @p [opt=nil] @string event name to disable button on
function infotext_manager:set_button_state_override(infotext_key, on_click_callback, on_display_callback, event_to_disable_button_on)
		
	if not is_string(infotext_key) then
		script_error("ERROR: set_button_state_override() called but supplied infotext key [" .. tostring(infotext_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(on_click_callback) then
		script_error("ERROR: set_button_state_override() called but supplied button override callback [" .. tostring(on_click_callback) .. "] is not a function");
		return false;
	end;

	if on_display_callback and not is_function(on_display_callback) then
		script_error("ERROR: set_button_state_override() called but supplied button override callback [" .. tostring(on_click_callback) .. "] is not a function");
		return false;
	end;

	if event_to_disable_button_on and not is_string(event_to_disable_button_on) then
		script_error("ERROR: set_button_state_override() called but supplied event name [" .. tostring(event_to_disable_button_on) .. "] is not a string");
		return false;
	end;
	
	self.button_state_overrides[infotext_key] = {
		on_click_callback = on_click_callback, 
		on_display_callback = on_display_callback,
		event_to_disable_button_on = event_to_disable_button_on
	};
end;






----------------------------------------------------------------------------
--- @section Manipulation
----------------------------------------------------------------------------


--- @function add_infotext
--- @desc Adds one or more lines of infotext to the infotext panel. The infotext box will expand to the final required size and then individual infotext lines are faded on sequentially with an interval between each. The first argument may optionally be an initial delay - this is useful when triggering infotext at the same time as advice, as it gives the advisor an amount of time to animate on-screen before infotext begins to display, which looks more refined.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay (ms in battle, s in campaign) after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function infotext_manager:add_infotext(param1, ...)
	self:add_infotext_action(false, false, param1, ...);
end;


--- @function add_infotext_with_leader
--- @desc Adds one or more lines of infotext to the infotext panel, with a @topic_leader. The infotext box will expand to the final required size and then individual infotext lines are faded on sequentially with an interval between each. The first argument may optionally be an initial delay - this is useful when triggering infotext at the same time as advice, as it gives the advisor an amount of time to animate on-screen before infotext begins to display, which looks more refined.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay (ms in battle, s in campaign) after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function infotext_manager:add_infotext_with_leader(param1, ...)
	self:add_infotext_action(false, true, param1, ...);
end;


--- @function add_infotext_simultaneously
--- @desc Adds one or more lines of infotext to the infotext panel, simultaneously. The infotext box will expand to the final required size and then all infotext lines are faded on at the same time. The first argument may optionally be an initial delay - this is useful when triggering infotext at the same time as advice, as it gives the advisor an amount of time to animate on-screen before infotext begins to display, which looks more refined.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay (ms in battle, s in campaign) after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function infotext_manager:add_infotext_simultaneously(param1, ...)
	self:add_infotext_action(true, false, param1, ...);
end;


--- @function add_infotext_simultaneously_with_leader
--- @desc Adds one or more lines of infotext to the infotext panel, simultaneously, and with a @topic_leader. The infotext box will expand to the final required size and then all infotext lines are faded on simultaneously. The first argument may optionally be an initial delay - this is useful when triggering infotext at the same time as advice, as it gives the advisor an amount of time to animate on-screen before infotext begins to display, which looks more refined.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay (ms in battle, s in campaign) after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function infotext_manager:add_infotext_simultaneously_with_leader(param1, ...)
	self:add_infotext_action(true, true, param1, ...);
end;


-- Internal function to action the adding of infotext
function infotext_manager:add_infotext_action(show_simultaneously, show_topic_leader, param1, ...)
	local infotext_record = {};
	infotext_record.delay = 0;
	infotext_record.show_simultaneously = show_simultaneously;
	
	if is_string(param1) then
		-- first parameter was a string i.e. no delay was specified
		table.insert(infotext_record, param1);
	else
		-- we now just disregard any initial delay value passed in, in favour of the internal default
		-- infotext_record.delay = param1;
	end;

	-- make a table of the inputs
	for i = 1, arg.n do
		table.insert(infotext_record, arg[i]);
	end;
		
	self:setup_infotext_uicomponents();

	-- should only happen in autoruns
	if not self.uic_advice_interface then
		return;
	end;

	if self.infotext_currently_being_added then
		table.insert(self.infotext_queue, infotext_record);
	else
		if show_topic_leader then
			local uic_advice = self:get_uicomponent();
			local uic_infotext_panel = self:get_infotext_panel();
			
			if uic_advice and uic_infotext_panel then
				
				local x, y = uic_infotext_panel:Position();

				local advice_animation_name = uic_advice:CurrentAnimationId();
				if advice_animation_name ~= "" then
					local num_frames = uic_advice:NumAnimationFrames(advice_animation_name);
					local anim_x, anim_y = uic_advice:GetAnimationFrameProperty(advice_animation_name, num_frames - 1, "position");

					x = x + anim_x;
					y = y + anim_y;
				end;

				local tl = topic_leader:new(
					"new_info",
					"advice_info_texts_localised_text_" .. infotext_record[1]
				);

				tl:set_shrink_target(x + 15, y + 15);

				tl:set_hold_duration(TOPIC_LEADER_HOLD_DURATION_FOR_INFOTEXT);
				tl:start();

				core:get_tm():real_callback(function() self:show_infotext(infotext_record) end, TOPIC_LEADER_HOLD_DURATION_FOR_INFOTEXT, "add_infotext");

				return;
			end;
		end;
		
		core:get_tm():real_callback(function() self:show_infotext(infotext_record) end, 200, "add_infotext");
	end;
end;


-- Internal function to add infotext
function infotext_manager:add_infotext_entry(key, show_hidden)
	-- assume this has been created
	local uic_advice_interface = self.uic_advice_interface;

	if self.button_state_overrides[key] then
		uic_advice_interface:InterfaceFunction("add_info_text_entry", key, show_hidden, true);

		local uic_button = find_uicomponent(self.uic_infotext, key, "button_infotext_entry");
		if not uic_button then
			script_error("ERROR: add_infotext_entry() could not find button for infotext entry [" .. key .. "] just added - how can this be?");
			return false;
		end;

		local button_state_override_record = self.button_state_overrides[key];

		if button_state_override_record and button_state_override_record.on_display_callback then
			button_state_override_record.on_display_callback(uic_button);
		end;

		if button_state_override_record and button_state_override_record.event_to_disable_button_on then
			core:add_listener(
				button_state_override_record.event_to_disable_button_on.."InfotextButtonDisable"..key,
				button_state_override_record.event_to_disable_button_on,
				true,
				function()
					uic_button:SetDisabled(true)
					uic_button:SetState("inactive")
				end,
				false
			)

			core:add_listener(
				"AdviceIssuedRemoveInfotextButtonDisable",
				"AdviceIssued",
				true,
				function() core:remove_listener(button_state_override_record.event_to_disable_button_on.."InfotextButtonDisable"..key) end,
				false
			)
		end
	else
		uic_advice_interface:InterfaceFunction("add_info_text_entry", key, show_hidden, false);
	end;
end;


--	Actually shows an infotext record - for internal use
function infotext_manager:show_infotext(infotext_record, end_callback)
	local initial_delay = infotext_record.delay;
	local show_simultaneously = infotext_record.show_simultaneously;
	local time_multiplier = 1000;
	local out_func = nil;
	local last_update = 0;
	
	self.infotext_currently_being_added = true;
	
	-- set up some vars depending on whether we're in campaign or battle
	if __game_mode == __lib_type_battle then
		out_func = function(str) bm:out(str) end;
	else
		out_func = function(str) out(str) end;
	end;

	local uic_advice_interface = self.uic_advice_interface;
	local uic_infotext = self.uic_infotext;

	for i = 1, #infotext_record do
		local current_infotext_record = infotext_record[i];
	
		-- if this record is a callback, then we call it after all the infotext has been shown
		if is_function(current_infotext_record) then
			end_callback = current_infotext_record;
	
		-- find any infotext lines that we have to remove, they must have a "-" character prepended to the string
		elseif string.sub(current_infotext_record, 1, 1) == "-" then
			local key = string.sub(current_infotext_record, 2);
			
			self:remove_infotext(key);
			out_func("\tRemoving infotext key " .. key);
		else
			-- otherwise add them
			local key = current_infotext_record;

			local add_infotext_interval = (initial_delay + ((i - 1) * 0.1)) * time_multiplier;
			
			-- increase the size of the infotext box
			core:get_tm():real_callback(
				function()
					-- out_func("\tAdding infotext key " .. key .. " to panel");
					self:add_infotext_entry(key, true);

					-- also add this infotext to our infotext-to-advice history
					self:associate_infotext_with_advice(key);
					
					-- find the entry just added
					local uic_entry = find_uicomponent(uic_infotext, key);
					if uic_entry then
						-- see if we have an override state for it
						self:parse_component_for_state_overrides(uic_entry, out_func);
						
						-- parse the text in it for script links
						self.parser:parse_component_for_tooltips(uic_entry);
					else
						script_error("ERROR: could not find infotext entry just added with key " .. key .. ", is the key correct?");
						print_all_uicomponent_children(uic_advice_interface);
					end;
				end, 
				add_infotext_interval,
				"add_infotext"
			);

			local t;

			if show_simultaneously then
				if #infotext_record * 0.1 > self.min_add_to_show_interval then
					t = (#infotext_record * 0.1 + initial_delay) * time_multiplier;
				else
					t = (self.min_add_to_show_interval + initial_delay) * time_multiplier;
				end;
			else
				t = (self.min_add_to_show_interval + initial_delay + ((i - 1) * self.line_delay)) * time_multiplier;
			end;

			-- actually show the infotext entry
			core:get_tm():real_callback(
				function()
					local uic_entry = find_uicomponent(uic_infotext, key);
					if not uic_entry then
						script_error("WARNING: attempting to show infotext with key [" .. key .. "] after it's been added but the infotext uicomponent could not be found. This can happen if infotext is added on the same tick as the previous advice has been removed. Will re-add the infotext now. Please fix this by delaying the addition of this infotext");
						print_all_uicomponent_children(uic_advice_interface);
						self:add_infotext_entry(key, false);
					end;

					out_func("\tShowing infotext key " .. key .. " in panel");
					uic_advice_interface:InterfaceFunction("show_text_entry", key) 
				end, 
				t, 
				"add_infotext"
			);

			last_update = t;
		end;
	end;
	
	-- see if any more infotext records have been queued up after we've finished
	core:get_tm():real_callback(
		function()
			if #self.infotext_queue > 0 then
				local new_infotext_record = self.infotext_queue[1];
				table.remove(self.infotext_queue, 1);
				self:show_infotext(new_infotext_record, end_callback);
			else
				self:show_infotext_finish(end_callback);
			end;
		end,
		last_update + initial_delay * time_multiplier, 
		"add_infotext"
	);
end;


--	for internal use
function infotext_manager:show_infotext_finish(end_callback)
	self.infotext_currently_being_added = false;
	
	if is_function(end_callback) then
		end_callback();
	end;
end;


local function parse_history_page_for_tooltips(im)
	-- get the actual infotext list
	local uic_infotext = get_infotext_manager():get_infotext_panel()
	
	for i = 0, uic_infotext:ChildCount() - 1 do	
		local uic_entry = UIComponent(uic_infotext:Find(i));
		
		im:parse_component_for_state_overrides(uic_entry);
		
		-- uic_entry:SetCanResizeHeight(true);		
		im.parser:parse_component_for_tooltips(uic_entry);
		-- local w, h, d = uic_entry:TextDimensions();
		-- uic_entry:Resize(uic_entry:Width(), h + 5);
		-- uic_entry:SetCanResizeHeight(false);
	end;
end;


-- called when the player clicks back/forward, parses the newly-displayed infotext page for script links and formats them
function infotext_manager:parse_history_page_for_tooltips()
	if __game_mode == __lib_type_battle then
		-- bm:callback(parse_func, 200);
		parse_history_page_for_tooltips(self);
	else
		core:get_tm():real_callback(function() parse_history_page_for_tooltips(self) end, 200, "add_infotext");
	end;
end;


-- see if we have an override state for this component
function infotext_manager:parse_component_for_state_overrides(uic_entry, out_func)
	local state_override = self.state_overrides[uic_entry:Id()];
	if state_override then
		if is_function(out_func) then
			out_func("\tOverride state of infotext component corresponding to key " .. uic_entry:Id() .. " to " .. state_override);
		end;
		uic_entry:SetState(state_override);
	end;
end;


--- @function remove_infotext
--- @desc Removes a line of infotext from the infotext panel, by key.
--- @p string infotext key
function infotext_manager:remove_infotext(key)
	self:setup_infotext_uicomponents();
	
	if self.uic_advice_interface then
		self.uic_advice_interface:InterfaceFunction("remove_info_text_entry", key);
	end;
end;


--- @function clear_infotext
--- @desc Clears all infotext from the infotext panel.
function infotext_manager:clear_infotext()
	self:setup_infotext_uicomponents();
	
	if self.uic_advice_interface then
		self.uic_advice_interface:InterfaceFunction("clear_all_info_text");
	end;
	
	self:cancel_add_infotext();
end;


--- @function hide_infotext
--- @desc Hides all infotext from the infotext panel with an animation.
function infotext_manager:hide_infotext()
	self:setup_infotext_uicomponents();
	
	if self.uic_advice_interface then
		self.uic_advice_interface:InterfaceFunction("hide_info_text");
	end;
	
	self:cancel_add_infotext();
end;


--	cancels any pending infotext
function infotext_manager:cancel_add_infotext()	
	core:get_tm():remove_real_callback("add_infotext");
	
	self.infotext_currently_being_added = false;
	self.infotext_queue = {};
end;







-- campaign/battle managers call this to notify infotext manager when a new advice has been shown
function infotext_manager:notify_of_advice(advice_key)
	if not self.infotext_docked_to_advisor then
		return;
	end;

	self.last_advice_shown = advice_key;
end;


-- called internally when infotext is shown, to associate it with the most recently-displayed advice
function infotext_manager:associate_infotext_with_advice(infotext_key)
	local last_advice_shown = self.last_advice_shown;

	if not last_advice_shown or not self.infotext_docked_to_advisor then
		return;
	end;

	local infotext_to_advice_history = self.infotext_to_advice_history;

	if not infotext_to_advice_history[last_advice_shown] then
		infotext_to_advice_history[last_advice_shown] = {};
	end;

	table.insert(infotext_to_advice_history[last_advice_shown], infotext_key);
end;


-- called when advice history is navigated - re-displays associated infotext if they're not already being shown
function infotext_manager:show_infotext_for_advice_from_history(advice_key)
	local infotext_list = self.infotext_to_advice_history[advice_key];

	if not is_table(infotext_list) then
		return;
	end;

	self:setup_infotext_uicomponents();

	local uic_infotext = self.uic_infotext;

	for i = 1, #infotext_list do
		if not find_uicomponent(uic_advice_interface or "", infotext_list[i]) then
			self:add_infotext_entry(infotext_list[i], false);
		end;
	end;
end;


