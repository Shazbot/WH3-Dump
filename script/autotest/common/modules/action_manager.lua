Action_Manager = {}

----------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------

-- table that holds the autotest actions
callback_list = {}

-- Global script actions.
local global_actions =
{
	action_list = {},
	cur_action 	= -1
}

local default_retry_delay 	= 1000
local default_exit_delay 	= 0
local last_action_result	= false

g_current_callback_level = nil

wait = {
	short = 300,
	standard = 1000,
	long = 5000,
	extreme = 15000
}

----------------------------------------------------------------------------------------------------------------
-- Injected Actions
----------------------------------------------------------------------------------------------------------------

function Action_Manager.register_private(action_table, func, retry_delay, exit_delay)
	-- Default values.
	retry_delay = retry_delay or default_retry_delay
	exit_delay 	= exit_delay  or default_exit_delay

	-- Create the action.
	local action =
	{
		action_callback = func,
		retry_delay 	= retry_delay,
		exit_delay 		= exit_delay
	}

	-- Insert the action into the actions table.
	table.insert(action_table.action_list, action)
end

function callback(func, exit_delay, retry_delay, level)
	-- When using a callback, a user can manually set the level, if unset it will automatically set it depending on the current level.
	if(level == nil) then
		if(g_current_callback_level) then
			-- g_current_callback_level is set on line 133, if it exists the callback is placed at 1 level lower than the current.
			level = g_current_callback_level + 1
		else
			-- if g_current_callback_level isn't set yet, the callback is set to level 1.
			level = 1
		end
	end

	-- expands the callback_list table to match the new callback level.
	if(callback_list[level] == nil) then
		while #callback_list < level do
			-- If they don't exist, creates callback levels up to the desired level so that the callback_list size always represents the current level.
			callback_list[#callback_list + 1] = {
				action_list = {},
				cur_action = 1
			}
		end
	end

	Action_Manager.register_private(callback_list[level], func, retry_delay, exit_delay)

	if(g_restart_required == true) then
		Utilities.print("----- INFO: New callbacks detected -----", true)
		Action_Manager.execute_next()
	end
end

function Action_Manager.push_global(func, exit_delay, retry_delay)
	Action_Manager.register_private(global_actions, func, retry_delay, exit_delay)
end

function Action_Manager.pop_global()
	if (#global_actions.action_list > 0) then
		table.remove(global_actions.action_list)
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------------------
-- Execute Action
----------------------------------------------------------------------------------------------------------------

function Action_Manager.actions_available(action_table)
	if(action_table ~= nil) then
		return action_table.cur_action <= #action_table.action_list
	else
		return nil
	end
end

function Action_Manager.execute_next_private(action_table)
	-- Check if we have actions to execute.
	if (action_table.cur_action > #action_table.action_list) then
		return false
	end

	-- Fetch the action.
	local action = action_table.action_list[action_table.cur_action]

	-- Perform the callback.
	local result = action.action_callback()

	if (result == true or result == nil) then
		-- Callback succeeded. Move on.
		action_table.cur_action = action_table.cur_action + 1
		Timers.register_singleshot("ActionManagerExecuteNext", action.exit_delay, true)
	else
		-- Callback failed. Try again.
		Timers.register_singleshot("ActionManagerExecuteNext", action.retry_delay, true)
	end

	last_action_result = result

	return true
end

function Action_Manager.execute_next()
	--check all test cases that are component based to see if any components are visible
	Lib.Helpers.Test_Cases.check_component_watchers()

	-- First go through any global actions.
	if (global_actions.cur_action ~= -1) then
		if ((Action_Manager.execute_next_private(global_actions)) == true) then
			return
		end
	end

	g_restart_required = false

	-- Callback Actions
	for i = #callback_list, 0, -1 do
		local action_available = Action_Manager.actions_available(callback_list[#callback_list])
		if(#callback_list >= 1 and action_available == true) then
			-- set the current callback level to the level we are currently at so that new callbacks can drop down to a lower level.
			g_current_callback_level = #callback_list
			-- If callbacks exist, execute the next one
			Action_Manager.execute_next_private(callback_list[#callback_list])
			return
		elseif(#callback_list >= 1 and action_available == false) then
			-- Keep removing callback levels until we reach the highest level with an action left to perform.
			table.remove(callback_list, #callback_list)
		else
			-- No callbacks at any level found.
			Utilities.print("----- INFO: Callback stack empty, waiting for new callbacks -----", true)
			g_restart_required = true
		end
	end

	-- Reset global action state.
	global_actions.cur_action = 1
end

function Action_Manager.skip_next()
	for i = #callback_list, 0, -1 do
		if (callback_list[i].cur_action <= #callback_list[i].action_list) then
			-- skip next action
			callback_list[i].cur_action = callback_list[i].cur_action + 1
			return true
		end
	end

	return false
end



----------------------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------------------

function Action_Manager.set_default_retry_delay(retry_delay)
	default_retry_delay = retry_delay
end

function Action_Manager.set_default_exit_delay(exit_delay)
	default_exit_delay = exit_delay
end

----------------------------------------------------------------------------------------------------------------
-- State Information
----------------------------------------------------------------------------------------------------------------

function Action_Manager.get_last_action_result()
	return last_action_result
end



----------------------------------------------------------------------------------------------------------------
-- Reset State
----------------------------------------------------------------------------------------------------------------

function Action_Manager.reset()
	-- Reset the state.
	callback_list = {}

	global_actions.action_list 		= {}
	global_actions.cur_action 		= -1

	default_retry_delay 			= 1000
	default_exit_delay 				= 0
end



----------------------------------------------------------------------------------------------------------------
-- Event Listener
-- Raw functionality
----------------------------------------------------------------------------------------------------------------

local attached_events = {};
local event_listeners = {};


--###### DEBUG FUNCTIONS FOR AUTOTEST PAUSING ##########
local m_suspended_listeners = {}
--take all the current event listeners and store them somewhere then clear the table
function suspend_all_listeners()
	m_suspended_listeners = event_listeners
	event_listeners = {}
end
--restore the event listeners so that they can fire again
function resume_all_listeners()
	event_listeners = m_suspended_listeners
	m_suspended_listeners = {}
end
--###### END OF DEBUG FUNCTIONS ###########

-- go through all the listeners and remove those with the to_remove flag set
local function clean_listeners()
	-- rebuild the event_listeners table without the old event listeners
	local new_event_listeners = {};

	for i = 1, #event_listeners do
		if not event_listeners[i].to_remove then
			table.insert(new_event_listeners, event_listeners[i]);
		end;
	end;

	event_listeners = new_event_listeners;
end;

-- a callback has been called
local function event_callback(eventname, context)
	local callbacks_to_call = {};
	local listeners_to_remove = {};

	-- Test whether any of our event callbacks should be called
	for i = 1, #event_listeners do
		local current_listener = event_listeners[i];

		if current_listener.event == eventname and (is_boolean(current_listener.condition) or current_listener.condition(context)) then
			table.insert(callbacks_to_call, current_listener.callback);

			if not current_listener.persistent then
				-- Mark this listener to be removed
				remove_event_listener_by_name(current_listener.name)
				current_listener.to_remove = true;
			end;
		end;
	end;

	-- Clean any listeners marked to be removed

	clean_listeners();

	-- Call the callbacks
	for i = 1, #callbacks_to_call do
		callbacks_to_call[i](context);
	end;
end;

local function attach_to_event(eventname)
	-- Return if we're already attached to the event
	if attached_events[eventname] then
		return;
	end;

	-- Mark the event as attached
	attached_events[eventname] = true;

	-- Create a table for this event if one is not already established
	if not events[eventname] then
		events[eventname] = {};
	end;

	-- Add a listener for this event
	table.insert(
		events[eventname],
		function(context)
			event_callback(eventname, context)
		end
	);
end;

function add_listener(name, event, condition, callback, persistent, core)
	-- Attach to the supplied script event if we're not already
	attach_to_event(event);
	core = core or false

	local listener_record = {
		name = name,
		event = event,
		condition = condition,
		callback = callback,
		persistent = persistent,
		to_remove = false,
		core = core
	};

	table.insert(event_listeners, listener_record);
end;

--removes all listeners that aren't marked as core
--to remove all listeners including core, call remove_all_listeners_including_core()
function remove_all_listeners()
	Utilities.print("<<<<<<<<< Removing all non-core listeners >>>>>>>>>>>> "..tostring(#event_listeners))
	for i = 1, #event_listeners do
		local name = event_listeners[i].name
		
		if(event_listeners[i].core == false)then
			--Utilities.print("Removing: "..tostring(name)) --uncomment to help debug listener issues
			event_listeners[i].to_remove = true
			remove_event_listener_by_name(name)
		else
			--Utilities.print("Keeping: "..tostring(name).." is core.") --uncomment to help debug listener issues
		end
		
	end
	clean_listeners()
end

--used to remove every single event listener including core
--only call if you are absolutely sure you know what you're doing as this will cause significant issues unless you setup handles for all the things core listeners handle
function remove_all_listeners_including_core()
	Utilities.print("<<<<<<<<< Removing all listeners including core >>>>>>>>>>>> "..tostring(#event_listeners))
	for i = 1, #event_listeners do
		local name = event_listeners[i].name
		
		event_listeners[i].to_remove = true
		remove_event_listener_by_name(name)	
	end
	clean_listeners()
end

----------------------------------------------------------------------------------------------------------------
-- Event Listener by id
----------------------------------------------------------------------------------------------------------------

event_listeners_by_name = {}

local m_listener_id_counter = 0
--returns a listener id by incrementing the counter, ensures we always have unique ids
--NOTE: it is unlikely we will hit the max number for unique ids as lua numbers are 64 bit integers which has an upper limit of 9,223,372,036,854,775,807 
local function get_event_listener_id()
	m_listener_id_counter = m_listener_id_counter+1
	--Utilities.print("Event listener ID: "..tostring(m_listener_id_counter)) --uncomment if debugging listener issues
	local id = m_listener_id_counter

	return id;
end;

--checks if the listener with the supplied name is in the event_listeners_by_name table
--is called by wait_for_event() and will only return true once the created listener has been triggered
local function has_event_been_received_by_name(name)
	return event_listeners_by_name[name];
end;

--uses slightly different functionality than creating an event listener
--will create a listener that listens for the supplied event
--when that listener fires it sets event_listeners_by_name[name] to true
--the callback at the end will loop continuously until event_listeners_by_name[name] is set to true
--as such, this can obviously create an infinte loop so use with caution
function wait_for_event(event, condition)
	-- If no condition was supplied then set it to true, which means the listener passes the first time it's received
	if not condition then
		condition = true;
	end;

	local name = "WaitForEvent_" ..tostring(event)
	-- Set up a listener a process which repeatedly checks the flag set by the listener above
	add_listener(
		name,
		event,
		condition,
		function()
			-- mark this event listener by id record as having been received
			event_listeners_by_name[name] = true;
		end,
		false, false, name
	);

	-- Inject a process which repeatedly checks the flag set by the listener above
	callback(
		function()
			-- Return true, meaning the ActionManager can proceed, if the event_listeners_by_name
			-- record is set to true (i.e. the event has been received)
			if has_event_been_received_by_name(name) then
				-- Also delete the entry in event_listeners_by_name
				remove_event_listener_by_name(name)
				return true;
			end;
			-- Return false, which causes this callback to repeat due to functionality in Action_Manager.execute_next_private()
			return false;
		end
	);
end;

--the primary method of creating listeners in the GSAT, a listener sits in the background, anytime the game triggers an event, all active listeners are check
--if any listener is listening for the triggered event then the condition is checked, if the condition returns true then the listeners followup action is executed
--[[
	arguments:

> event: the name of the event to listen for
> condition: an optional condition to check when the event triggers, can be used to narrow down specific events 
	e.g. "PanelOpenedCampaign" event can then have a conditon that the panel is the diploamcy panel
> followup: a function the listener executes if the condition returns true
> persistent: once this listener fires it will be marked for removal, therefore it only fires once, setting persistent to true prevents this, meaning it will fire everytime the event+condition happen
> core: prevents this listener form being removed when remove_all_listeners() is called, only set a listener to core if you know what you're doing as it will be present during player turn, end turn cycle, everything
> name: the name of this listener, use this to prevent duplicate versions of this listener being created
]]
function add_event_listener(event, condition, followup, persistent, core, name)
	-- If no condition was supplied then set it to true, which means the listener passes the first time it's received
	if not condition then
		condition = true;
	end

	--a listener with core set to true will not be removed unless remove_all_listeners_including_core() is called
	--listeners shouldn't be core by default
	core = core or false

	-- If no name is provided, add a generic one, id is generated by incrementing the global id count by 1 to ensure every generic name is unique
	if(name == nil)then
		local id = get_event_listener_id()
		name = name or  "actionmanager_listener_" .. id
	end
	
	--to prevent duplicates of listeners we check if it's name is already in the event_listeners_by_name table
	--if you want to ensure your listener doesn't get duplicated, give it a unique name, ideally one that describes it's function e.g. "ListenForPlayerTurnStart"
	if(check_if_listener_exists_already(name) == false)then
		--Utilities.print("V The listener "..tostring(name).." does not exist already, can safely create.") --uncomment if debugging listener issues

		--add this listeners name to the table to prevent duplicated
		event_listeners_by_name[name] = true

		--create a listener with all the information required
		add_listener(
			name,
			event,
			condition,
			function(context)
				-- what actions to take after the event has turned true, before the next autotest callback
				followup(context)
			end,
			persistent, core
		)

		-- return the name so that this listener can be removed manually if needed.
		return name
	else
		--Utilities.print("X The listener "..tostring(name).." is already present, will not create.") --uncomment if debugging listener issues
		return nil
	end
end

--simple function, the event_listeners_by_name table only holds the name of listeners in so to "remove" it we just set the entry to nil
--name should be a string
function remove_event_listener_by_name(name)
	event_listeners_by_name[name] = nil
end

--checks if the listener has already been created by checking the provided name in the table
--name should be a string, specifically the name of a listener
function check_if_listener_exists_already(name)
	if(event_listeners_by_name[name] == true)then
		return true
	else
		return false
	end
end