


--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend

--- @section Script Messager

--- @function get_messager
--- @desc Gets or creates a @script_messager object.
--- @r script_messager
function get_messager()
	return script_messager:new();
end;








----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	SCRIPT MESSAGER
--
--- @c script_messager Script Messager
--- @desc The script messager is a lightweight object designed to allow separate script systems to send and listen for string messages. It is very much like a cut-down event system, without the congestion of events that are naturally triggered by the game. Its main purpose is to underpin the mechanics of both the @generated_battle system in battle and the @narrative system in campaign.
--- @desc Unlike the events system, the script messager supports the blocking of messages, so that one bit of script can prevent the transmission of a specific message by any other bit of script.
--- @desc It is rare to need to get a handle to a script messager object directly, as the @generated_battle system stores an internal reference to it and calls it automatically when necessary.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


script_messager = {
	output = nil,
	listeners = {},
	blocked_messages = {}
};


set_class_custom_type_and_tostring(script_messager, TYPE_SCRIPT_MESSAGER);



-----------------------------------------------------------------------------
--- @section Creation
-----------------------------------------------------------------------------


--- @function new
--- @desc Gets or creates a @script_messager object.
--- @r @script_messager
function script_messager:new()
	
	local sm = core:get_static_object("script_messager");

	if is_scriptmessager(sm) then
		return sm;
	end;
	
	sm = {};
	
	set_object_class(sm, self);
	
	-- create an output function depending on what mode of game we're in
	if __game_mode == __lib_type_battle then
		sm.output = function(str) bm:out(str) end;
	elseif __game_mode == __lib_type_campaign then
		sm.output = function(str) out(str) end;
	else
		sm.output = function(str) print(str) end;
	end;
	
	sm.listeners = {};
	sm.blocked_messages = {};
	
	core:add_static_object("script_messager", sm);
	
	return sm;
end;








----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once an <code>script_messager</code> object has been created with @script_messager:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;script_messager_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local sm = script_messager:new()					-- set up automatically by campaign or battle managers
--- @example sm:add_listener(									-- calling a function on the object once created
--- @example 	"test_message",
--- @example	function() out("* test_message received") end
--- @example )












-----------------------------------------------------------------------------
--- @section Messages
-----------------------------------------------------------------------------


--- @function add_listener
--- @desc Adds a listener for a message. If the specified message is received, the specified callback is called. If the third parameter is set to <code>true</code> then the listener will continue after it calls the callback and will listen indefinitely.
--- @p @string message, Message to listen for.
--- @p @function callback to call, Target to call when the message is received and the optional condition passes.
--- @p [opt=false] @boolean persistent, Continue to listen after the target callback has been called.
--- @p [opt=nil] @function condition, Condition function which must pass for the target callback to be called. The condition function is called when the message is received, and will be passed the message context as a single argument. It must return true, or a value that equates to true in a boolean comparison, for the condition to pass. If no condition function is supplied then the condition always passes.
--- @p [opt=nil] @string listener name, Name for this listener, by which it may be later cancelled.
function script_messager:add_listener(message, callback, always_listen, condition, listener_name)
	if not validate.is_string(message) then
		return false;
	end;
	
	if not validate.is_function(callback) then
		return false;
	end;
	
	always_listen = not not always_listen;

	-- if true was supplied as a condition then assign nil to it, so we support the same condition format as events do
	if condition == true then
		condition = nil;
	end;

	if condition and not validate.is_function(condition) then
		return false;
	end;

	if listener_name and not validate.is_string(listener_name) then
		return false;
	end;

	local new_listener = {
		callback = callback,
		always_listen = always_listen,
		condition = condition,
		listener_name = listener_name
	};

	local listeners = self.listeners;
		
	if not listeners[message] then
		listeners[message] = {};
	end;
	
	table.insert(listeners[message], new_listener);
end;


--- @function trigger_message
--- @desc Triggers a string message. This prompts the messager system to notify any listeners for the subject message and call the callback that those listeners registered. An optional table of context data can be supplied to be passed through to the listening scripts.
--- @p @string message name
--- @p [opt=nil] @table context data
function script_messager:trigger_message(message, context_data)
	if not is_string(message) then
		script_error("script_messager ERROR: add_listener() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if context_data and not validate.is_table(context_data) then
		return false;
	end;
	
	-- if this message is in our blocked messages list then don't do anything
	if self.blocked_messages[message] then
		return false;
	end;
	
	local callbacks_to_call = {};
	local listeners = self.listeners[message];

	if listeners then
		for i = 1, #listeners do
			local current_listener = listeners[i];
			
			if not current_listener.condition or current_listener.condition(context_data) then
				
				-- we have found a callback to call, add it to our list of callbacks and mark this 
				-- listener to expire if it's only to trigger once
				table.insert(callbacks_to_call, current_listener.callback);
						
				if not current_listener.always_listen then
					current_listener.to_remove = true;
				end;
			end;
		end;

		-- rebuild our listeners list and call the callbacks to call if we have any
		if #callbacks_to_call > 0 then
			local new_listeners = {};
			for i = 1, #listeners do
				if not listeners[i].to_remove then
					table.insert(new_listeners, listeners[i]);
				end;
			end;

			self.listeners[message] = new_listeners;
	
			out.inc_tab();
			
			for i = 1, #callbacks_to_call do
				callbacks_to_call[i](context_data);
			end;
		
			out.dec_tab();
		end;
	end;
end;


--- @function remove_listener_by_message
--- @desc Removes any listener listening for a particular message.
--- @p string message name
function script_messager:remove_listener_by_message(message)
	if not is_string(message) then
		script_error("script_messager ERROR: remove_listener_by_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	self.listeners[message] = {};
end;


--- @function remove_listener_by_name
--- @desc Removes any listener by name.
--- @p string message name
function script_messager:remove_listener_by_name(name)
	if not is_string(name) then
		script_error("script_messager ERROR: remove_listener_by_name() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	for message, listeners in pairs(self.listeners) do
		for i = #listeners, 1, -1 do
			if listeners[i].listener_name == name then
				table.remove(listeners, i);
			end;
		end;
	end;
end;


--- @function block_message
--- @desc Blocks or unblocks a message from being transmitted in the future. If a message is blocked, no listeners will be notified when @script_messager:trigger_message is called.
--- @p string message name
--- @p [opt=true] boolean should block
function script_messager:block_message(message, should_block)
	if not is_string(message) then
		script_error("script_messager ERROR: block_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if should_block ~= false then
		-- block
		self.blocked_messages[message] = true;
	else
		-- unblock
		self.blocked_messages[message] = nil;
	end;
end;

