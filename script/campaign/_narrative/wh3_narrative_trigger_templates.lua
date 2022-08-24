------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	NARRATIVE TRIGGER TEMPLATES
--
--	PURPOSE
--	This file defines narrative trigger templates. These templates can be used by any scripts that set up narrative 
--	event chains - either shared, racial, or campaign-specific.
--
--	See the script documentation for more information about the underlying narrative event system.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


--- @set_environment campaign


--- @data_interface narrative_triggers Narrative Trigger Templates
--- @function_separator .
--- @desc The <code>narrative_triggers</code> table contains a list of narrative trigger templates that campaign scripts can use to create narrative triggers. See the page on @narrative for an overview of the narrative event framework. See also the @narrative_trigger documentation for detailed information about the <code>narrative_trigger</code> object interface.
narrative_triggers = {};











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Generic Event/Condition
--
--	Triggers when client-supplied event is received and condition is met.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_generic(name, faction_key, start_messages, target_messages, cancel_messages, event, condition, immediate)

	if not validate.is_string(event) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = event,
			condition = condition,
			immediate = immediate
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	if nt then
		return nt;
	end;
end;


--- @function generic
--- @desc Creates and starts a narrative trigger that attempts to trigger when a specified event is received. An optional condition function may also be supplied, which must be passed for the narrative trigger to fire its target events. If supplied, the condition function will be called when the specified event is received, and will be passed the event context and the narrative trigger object as separate arguments. It must return a value that evaluates to <code>true</code> for the condition to pass. If no condition function is supplied then the condition always passes.
--- @desc If the immediate flag is set, or if it is a multiplayer game, then the narrative trigger will immediately trigger the target messages when the event is received and condition passes. If the flag is not set and it's a singleplayer game the narrative will instead create an @intervention which will fire the target messages when it gets to trigger.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string event name, Event name to listen for.
--- @p [opt=nil] @function condition, Condition function to call when the event is received. The event context and narrative trigger objects are provided to the function as arguments. If no condition function is supplied then the condition always passes.
--- @p [opt=true] @boolean Immediate, Trigger the target message(s) immediately when the event is received and the optional condition is met.
function narrative_triggers.generic(name, faction_key, start_messages, target_messages, cancel_messages, event, condition, immediate)
	local nt = construct_narrative_trigger_generic(name, faction_key, start_messages, target_messages, cancel_messages, event, condition, immediate);

	if nt then
		nt:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Message
--
--	Triggers when a message received for the specified faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_message(name, faction_key, trigger_messages, target_messages, cancel_messages)

	if not validate.is_string_or_table_of_strings(trigger_messages) then
		return false;
	end;

	if is_string(trigger_messages) then
		trigger_messages = {trigger_messages};
	end;

	local nt = narrative_trigger:new(name, faction_key, target_messages, nil, nil, cancel_messages);

	for i = 1, #trigger_messages do
		nt:add_monitor_message(trigger_messages[i], true, true);
	end;

	nt:set_should_setup_cancel_listeners_with_start_listeners(true);

	if nt then
		return nt;
	end;
end;


--- @function message
--- @desc Triggers a message when a different message is received for the specified faction. Instead of using this, it is encouraged to make the narrative entity triggering the incoming message to instead just trigger the target message as well/instead, making this intermediate narrative trigger redundant. However, there are circumstances which can make the creation of an intermediate trigger desirable.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative trigger should trigger. If multiple trigger messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel. If multiple messages are required then a @table containing string message names can be supplied here instead.
function narrative_triggers.message(name, faction_key, trigger_messages, target_messages, cancel_messages)
	local nt = construct_narrative_trigger_message(name, faction_key, trigger_messages, target_messages, cancel_messages);

	if nt then
		nt:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Turn Start
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_turn_start(name, faction_key, start_messages, target_messages, cancel_messages, condition, faction_starting_turn_key, immediate)

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	if faction_starting_turn_key then
		if not validate.is_string(faction_starting_turn_key) then
			return false;
		end;
	else
		faction_starting_turn_key = faction_key;
	end;

	local event_name;
	local faction = cm:get_faction(faction_starting_turn_key);
	if faction and faction:is_human() then
		event_name = "ScriptEventHumanFactionTurnStart";
	else
		event_name = "FactionTurnStart";
	end;
	
	local condition_inner;

	if is_function(condition) then
		function condition_inner(context, nt)
			return context:faction():name() == faction_starting_turn_key and condition(context, nt);
		end;
	else
		function condition_inner(context, nt)
			return context:faction():name() == faction_starting_turn_key
		end;
	end;

	local main_events_and_conditions = {
		{
			event = event_name,
			condition = condition_inner,
			immediate = immediate
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	if nt then
		return nt;
	end;
end;


--- @function turn_start
--- @desc Creates and starts a narrative trigger that attempts to trigger on start of turn for the specified faction. An optional condition function may also be supplied, which must be passed for the narrative trigger to fire its target events. If supplied, the condition function will be called when the faction starts its turn and will be passed the context of the <code>FactionTurnStart</code> event and the narrative trigger object as separate arguments. It must return a value that evaluates to <code>true</code> for the condition to pass. If no condition function is supplied then the condition always passes.
--- @desc If the immediate flag is set, or if it is a multiplayer game, then the narrative trigger will immediately trigger the target messages when the turn start event is received. If the flag is not set and it's a singleplayer game the narrative will instead create an @intervention which will fire the target messages when it gets to trigger.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which must be passed for the trigger to fire. This function will be passed the context object from the <code>FactionTurnStart</code> event and the narrative trigger as two separate arguments. It must return a value that evaluates to <code>true</code> for the condition to pass.
--- @p_long_desc If no condition function is supplied here then the condition always passes.
--- @p [opt=nil] @string faction starting turn, Key of the faction whose turn start we should listen for. If @nil is supplied here then the key of the faction to which this narrative trigger applies is used.
--- @p [opt=true] @boolean Immediate, Trigger the target message(s) immediately when the event is received and the optional condition is met.
function narrative_triggers.turn_start(name, faction_key, start_messages, target_messages, cancel_messages, condition, faction_starting_turn_key, immediate)
	local nt = construct_narrative_trigger_turn_start(name, faction_key, start_messages, target_messages, cancel_messages, condition, faction_starting_turn_key, immediate);

	if nt then
		nt:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Dilemma Choice Made
--
--	Triggers when dilemma choice is made
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_dilemma_choice_made(name, faction_key, start_messages, target_messages, cancel_messages, dilemma_key, choice_value)

	if is_string(target_messages) then
		target_messages = {target_messages};
	end;

	local nt = construct_narrative_trigger_generic(
		name,
		faction_key,
		start_messages,
		target_messages,
		cancel_messages,
		"DilemmaChoiceMadeEvent", 
		function(context, nt)
			local result = (context:dilemma() == dilemma_key and context:faction():name() == faction_key and (not choice_value or context:choice() == choice_value));
			if result then
				nt:out();
				nt:out();
				nt:out("dilemma choice " .. (choice_value and ("[" .. choice_value .. "] ") or "") .. " was made for dilemma [" .. dilemma_key .. "] will trigger message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "]");
			end;
			return result;
		end, 
		true
	);

	return nt;
end;


--- @function dilemma_choice_made
--- @desc Creates and starts a narrative trigger that fires when a dilemma choice is made.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string dilemma key, Key of dilemma to listen for, from the <code>dilemmas</code> database table.
--- @p [opt=nil] @number choice value, Integer choice value.
function narrative_triggers.dilemma_choice_made(name, faction_key, start_messages, target_messages, cancel_messages, dilemma_key, choice_value)
	local nt = construct_narrative_trigger_dilemma_choice_made(name, faction_key, start_messages, target_messages, cancel_messages, dilemma_key, choice_value);

	if nt then
		nt:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Turn Countdown
--
--	Listens for a script message for a certain faction, and transmits another
--	message at the start of turn a specified number of turns later
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_turn_countdown(name, faction_key, start_messages, target_messages, cancel_messages, num_turns, immediate)

	if not validate.is_positive_number(num_turns) then
		return false;
	end;

	-- We must have one or more start messages for this narrative trigger
	if not validate.is_string_or_table_of_strings(start_messages) then
		return false;
	end;

	if is_string(start_messages) then
		start_messages = {start_messages};
	end;

	if is_string(target_messages) then
		target_messages = {target_messages};
	end;
	
	local nt = narrative_trigger:new(
		name, 
		faction_key, 
		target_messages, 
		nil, 
		start_messages, 
		cancel_messages
	);

	-- If the narrative trigger has not already been triggered, then for each start message we set up an equivalent _internal main monitor message.
	-- When any start message is received the start callback is called which, if we're not reloading, will start the turn countdown process that triggers the _internal main monitor message.
	if nt and not nt:has_triggered_this_campaign() then
		-- For each start message, add a monitor message with _internal appended.
		for i = 1, #start_messages do
			local current_message = start_messages[i];
	
			nt:add_monitor_message(
				name.. "_" .. current_message .. "_internal",			-- message
				true,													-- condition
				immediate												-- immediate
			);
		end;

		nt:add_start_callback(
			function(started_from_savegame, start_message)
				if not started_from_savegame then
					nt:out("will trigger target message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "] in " .. num_turns .. " turn" .. (num_turns == 1 and "" or "s") .. " for faction [" .. faction_key .. "]");
					cm:add_turn_countdown_message(faction_key, num_turns, name .. "_" .. start_message .. "_internal", faction_key, true);
				end;
			end
		);
	end;

	return nt;
end;


--- @function turn_countdown
--- @desc Creates and starts a narrative trigger that listens for a message from another narrative object, and then waits a specified number of turns (for the specified faction) before sending one or more target messages.
--- @desc The target messages are always triggered immediately, with no intervention being created in singleplayer mode.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p @string start message, Message on which this narrative trigger should start its turn countdown. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead. This message/these messages will be associated with the specified target faction rather than the source faction.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number turns, Number of turns to wait.
--- @p [opt=true] @boolean Immediate, Trigger the target message(s) immediately when the event is received and the optional condition is met.
function narrative_triggers.turn_countdown(name, faction_key, start_messages, target_messages, cancel_messages, num_turns, immediate)
	local nt = construct_narrative_trigger_turn_countdown(name, faction_key, start_messages, target_messages, cancel_messages, num_turns, immediate);

	if nt then
		nt:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Faction Switch
--
--	Listens for a script message for a certain faction, and transmits another
--	message for another faction. This is useful if a narrative flow has to continue
--	while the player changes faction.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_faction_switch(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key)

	if not validate.is_string(target_faction_key) then
		return false;
	end;

	-- We must have one or more start messages for this narrative trigger
	if not validate.is_string_or_table_of_strings(start_messages) then
		return false;
	end;

	if is_string(start_messages) then
		start_messages = {start_messages};
	end;

	if is_string(target_messages) then
		target_messages = {target_messages};
	end;

	
	local nt = narrative_trigger:new(
		name, 
		target_faction_key, 
		target_messages, 
		nil, 
		nil, 				-- we listen for the start messages ourselves
		cancel_messages
	);
	
	-- If the narrative trigger has not already been triggered, then for each start message set up a listener for the source faction, which forces the narrative trigger to fire for the target faction.
	if nt and not nt:has_triggered_this_campaign() then
		local listener_name = name .. "_" .. faction_key .. "_faction_switch";

		for i = 1, #start_messages do
			local current_message = start_messages[i];

			sm:add_listener(
				current_message,
				function(context)
					sm:remove_listener_by_name(listener_name);
					nt:force_main_trigger("message [" .. current_message .. "] received for faction [" .. faction_key .. "]");
				end,
				false,
				function(context)
					return context.faction_key == faction_key;
				end,
				listener_name
			);
		end;
	end;

	return nt;
end;


--- @function faction_switch
--- @desc Creates and starts a narrative trigger that listens for a start message from another narrative object associated with one faction, and then sends one or more target messages associated with another faction. This can be useful if a desired narrative sequence flows over the player changing faction.
--- @desc The target messages are always triggered immediately, with no intervention being created in singleplayer mode.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table. This should be the originator faction.
--- @p @string start message, Message on which this narrative trigger should initiate the faction switch process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target message, Target message or messages to trigger when this narrative trigger fires. These target message(s) will be associated with the target faction. If multiple target messages are required then a @table containing string message names can be supplied here instead. This message/these messages will be associated with the specified target faction rather than the source faction.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target faction key, Key of the target faction, to which the outgoing target message(s) will be associated.
function narrative_triggers.faction_switch(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key)
	local nt = construct_narrative_trigger_faction_switch(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key);

	if nt then
		nt:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Growth Point
--
--	Triggers when the specified faction gains a growth point.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_growth_point_gained(name, faction_key, start_messages, target_messages, cancel_messages, upgrade_available_only, province_keys)

	if province_keys and not validate.is_string_or_table_of_strings(province_keys) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "RegionGainedDevelopmentPoint",
			condition = function(context, nt)
				if context:region():owning_faction():name() == faction_key then
					if upgrade_available_only and not context:region():has_development_points_to_upgrade() then
						return false;
					end;

					if province_keys then
						local province_key_of_region = context:region():province_name();
						if is_string(province_keys) then
							if province_key_of_region ~= province_keys then
								return false;
							end;
						else
							local match_found = false;
							for i = 1, #province_keys do
								if province_key_of_region == province_keys[i] then
									match_found = true;
									break;
								end;
							end;

							if not match_found then
								return false;
							end;
						end;
					end;

					nt.data = {region_name = context:region():name()};
					return true;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function growth_point_gained
--- @desc Creates and starts a narrative trigger that fires when the specified faction has gained a growth point in a specified province, or any controlled territory if no province is specified.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=false] @boolean upgrade available only, The narrative trigger should only fire when a growth point is earned in a player-controlled region and an upgrade of the main settlement chain is available.
--- @p [opt=nil] @string province key, Key of province in which the growth point must be earned. This can also be a @table of string province keys. If left blank, then any growth point earned by the specified faction is counted.
function narrative_triggers.growth_point_gained(name, faction_key, start_messages, target_messages, cancel_messages, upgrade_available_only, province_keys)
	local nt = construct_narrative_trigger_growth_point_gained(name, faction_key, start_messages, target_messages, cancel_messages, upgrade_available_only, province_keys);

	if nt then
		nt:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Building Construction Issued
--
--	Triggers when the specified faction begins construction of a building.
--	This uses the BuildingConstructionIssuedByPlayer event so it only works on
--	player-controlled factions
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_building_construction_issued(name, faction_key, start_messages, target_messages, cancel_messages, condition)

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "BuildingConstructionIssuedByPlayer",
			condition = function(context, nt)

				if context:garrison_residence():faction():name() ~= faction_key then
					return false;
				end;

				if is_function(condition) then
					local result, suppress_output = condition(context, nt);
					if not result then
						return false;
					end;

					if not suppress_output then
						nt:out();
						nt:out();
						nt:out("triggering as player faction [" .. faction_key .. "] issued a construction order for building with key [" .. context:building() .. "] and supplied condition matches");
					end;
				else
					nt:out();
					nt:out();
					nt:out("triggering as player faction [" .. faction_key .. "] issued a construction order for building with key [" .. context:building() .. "]");
				end;

				return true;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function building_construction_issued
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts construction on a building. An optional condition function may be specified which is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.building_construction_issued(name, faction_key, start_messages, target_messages, cancel_messages, condition)
	local nt = construct_narrative_trigger_building_construction_issued(name, faction_key, start_messages, target_messages, cancel_messages, condition);

	if nt then
		nt:start();
	end;
end;


--- @function technology_building_construction_issued
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts construction on a building that unlocks a technology. An additional optional condition function may be specified which is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.technology_building_construction_issued(name, faction_key, start_messages, target_messages, cancel_messages, condition)
	
	local function condition_internal(context, nt)
		local faction = cm:get_faction(faction_key);

		if not faction or not cm:building_level_unlocks_technology_for_faction(faction, context:building()) then
			return false;
		end;

		if is_function(condition) then
			local result, suppress_output = condition(context, nt);
			if not result then
				return false;
			end;

			if not suppress_output then
				nt:out();
				nt:out();
				nt:out("triggering as player faction [" .. faction_key .. "] issued a construction order for building with key [" .. context:building() .. "] that unlocks technology research and supplied condition matches");
			end;
		
		else
			nt:out();
			nt:out();
			nt:out("triggering as player faction [" .. faction_key .. "] issued a construction order for building with key [" .. context:building() .. "] that unlocks technology research");
		end;

		return true, true;
	end;
	
	local nt = construct_narrative_trigger_building_construction_issued(name, faction_key, start_messages, target_messages, cancel_messages, condition_internal);

	if nt then
		nt:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Character Created
--
--	Triggers when a character is created for the specified faction.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_character_created(name, faction_key, start_messages, target_messages, cancel_messages, types_filter, condition)

	if types_filter and not validate.is_table_of_strings(types_filter) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local types_filter_lookup = table.indexed_to_lookup(types_filter);

	local main_events_and_conditions = {
		{
			event = "CharacterCreated",
			condition = function(context, nt)

				if context:character():faction():name() ~= faction_key then
					return false;
				end;

				if types_filter then
					local char_type_key = context:character():character_type_key();
					if not types_filter_lookup[char_type_key] then
						return false;
					end;
				end;

				if is_function(condition) then
					local result, suppress_output = condition(context, nt);
					if not result then
						return false;
					end;

					if not suppress_output then
						nt:out();
						nt:out();
						nt:out("triggering as player faction [" .. faction_key .. "] created a character with cqi [" .. context:character():command_queue_index() .. "] and type [" .. context:character():character_type_key() .. "] and supplied condition matches");
					end;
				else
					nt:out();
					nt:out();
					nt:out("triggering as player faction [" .. faction_key .. "] created a character with cqi [" .. context:character():command_queue_index() .. "] and type [" .. context:character():character_type_key() .. "]");
				end;

				return true, true;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function general_created
--- @desc Creates and starts a narrative trigger that fires when a general/lord character is created for the specified faction. An optional condition function may also be specified which is passed the context object supplied by the underlying <code>CharacterCreated</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.general_created(name, faction_key, start_messages, target_messages, cancel_messages, condition)
	local nt = construct_narrative_trigger_character_created(name, faction_key, start_messages, target_messages, cancel_messages, {"general"}, condition);

	if nt then
		nt:start();
	end;
end;


--- @function agent_created
--- @desc Creates and starts a narrative trigger that fires when an agent/hero character is created for the specified faction. An optional condition function may also be specified which is passed the context object supplied by the underlying <code>CharacterCreated</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.agent_created(name, faction_key, start_messages, target_messages, cancel_messages, condition)
	local nt = construct_narrative_trigger_character_created(name, faction_key, start_messages, target_messages, cancel_messages, cm:get_all_agent_types(), condition);

	if nt then
		nt:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Hero Action Performed
--
--	Triggers when any hero action is performed by a hero in the specified faction.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_hero_action_performed(name, faction_key, start_messages, target_messages, cancel_messages, condition)

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "CharacterCharacterTargetAction",
			condition = function(context, nt)

				if context:character():faction():name() ~= faction_key then
					return false;
				end;

				if not context:mission_result_success() and not context:mission_result_critial_success() then
					return false;
				end;

				if is_function(condition) then
					local result, suppress_output = condition(context, nt);
					if not result then
						return false;
					end;

					if not suppress_output then
						nt:out();
						nt:out();
						nt:out("triggering as character with cqi [" .. context:character():command_queue_index() .. "] in player faction [" .. faction_key .. "] successfully performed a hero action");
					end;
				else
					nt:out();
					nt:out();
					nt:out("triggering as character with cqi [" .. context:character():command_queue_index() .. "] in player faction [" .. faction_key .. "] successfully performed a hero action");
				end;

				return true, true;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function hero_action_performed
--- @desc Creates and starts a narrative trigger that fires when a hero character performs a successful action for the specified faction. An optional condition function may also be specified which is passed the context object supplied by the underlying <code>CharacterCharacterTargetAction</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.hero_action_performed(name, faction_key, start_messages, target_messages, cancel_messages, condition)
	local nt = construct_narrative_trigger_hero_action_performed(name, faction_key, start_messages, target_messages, cancel_messages, condition);

	if nt then
		nt:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Char Has Won X Battles
--
--	Triggers when any character of the supplied type(s) in the specified faction has won x battles
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_char_has_won_x_battles(name, faction_key, start_messages, target_messages, cancel_messages, num_victories, char_types, condition)

	if not validate.is_positive_number(num_victories) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local char_types_lookup = table.indexed_to_lookup(char_types);

	local main_events_and_conditions = {
		{
			event = "CharacterCompletedBattle",
			condition = function(context, nt)

				local character = context:character();
				if character:faction():name() ~= faction_key or character:battles_won() < num_victories or not char_types_lookup[character:character_type_key()] then
					return false;
				end;

				if is_function(condition) then
					local result, suppress_output = condition(context, nt);
					if not result then
						return false;
					end;

					if not suppress_output then
						nt:out();
						nt:out();
						nt:out("triggering as character with cqi [" .. character:command_queue_index() .. "] in player faction [" .. faction_key .. "] has won [" .. character:battles_won() .. "] victories which meets or exceed threshold [" .. num_victories .. "]");
					end;
				else
					nt:out();
					nt:out();
					nt:out("triggering as character with cqi [" .. character:command_queue_index() .. "] in player faction [" .. faction_key .. "] has won [" .. character:battles_won() .. "] victories which meets or exceed threshold [" .. num_victories .. "]");
				end;

				return true, true;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function any_general_won_x_battles
--- @desc Creates and starts a narrative trigger that fires when a lord in the specified faction has participated in a certain number of battle victories. An optional condition function may also be specified which is passed the context object supplied by the underlying <code>CharacterCompletedBattle</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=1] @number victories, Threshold number of victories.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.any_general_won_x_battles(name, faction_key, start_messages, target_messages, cancel_messages, num_victories, condition)
	local nt = construct_narrative_trigger_char_has_won_x_battles(name, faction_key, start_messages, target_messages, cancel_messages, num_victories, {"general"}, condition);

	if nt then
		nt:start();
	end;
end;


--- @function any_hero_won_x_battles
--- @desc Creates and starts a narrative trigger that fires when a hero character in the specified faction has participated in a certain number of battle victories. An optional condition function may also be specified which is passed the context object supplied by the underlying <code>CharacterCompletedBattle</code> script event.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=1] @number victories, Threshold number of victories.
--- @p [opt=nil] @function condition, Condition function which, if supplied, must be passed in order for the trigger to fire. The condition function is passed the context object supplied by the underlying <code>BuildingConstructionIssuedByPlayer</code> script event as well as the narrative trigger object as separate arguments, and should return a value that evaluates to a @boolean.
--- @p_long_desc The condition function may also return a second @boolean return value, which suppresses downstream output. This can be set if the condition function handles output itself.
function narrative_triggers.any_hero_won_x_battles(name, faction_key, start_messages, target_messages, cancel_messages, num_victories, condition)
	local nt = construct_narrative_trigger_char_has_won_x_battles(name, faction_key, start_messages, target_messages, cancel_messages, num_victories, cm:get_all_agent_types(), condition);

	if nt then
		nt:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Pooled Resource Gained
--
--	Triggers when the specified faction has an amount of a specified pooled resource
--	equal to or greater than a specified threshold
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, pooled_resource_faction_key, pooled_resource_keys, threshold_value, less_than)

	if not validate.is_string(pooled_resource_faction_key) then
		return false;
	end;
	
	if is_string(pooled_resource_keys) then
		pooled_resource_keys = {pooled_resource_keys};
	elseif not validate.is_table_of_strings(pooled_resource_keys) then
		return false;
	end;

	if not validate.is_number(threshold_value) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "PooledResourceChanged",
			condition = function(context, nt)
				if context:has_faction() and context:faction():name() == pooled_resource_faction_key then
					local resource = context:resource();
					local resource_value = resource:value();
					if (less_than and resource_value <= threshold_value) or (not less_than and resource_value >= threshold_value) then
						local resource_key = resource:key();
						for i = 1, #pooled_resource_keys do
							if resource_key == pooled_resource_keys[i] then
								return true;
							end;
						end;
					end;
					return false;
				end;
			end,
			immediate = true
		},
		{
			event = "PooledResourceRegularIncome",
			condition = function(context, nt)
				if context:has_faction() and context:faction():name() == pooled_resource_faction_key then
					local resource = context:resource();
					local resource_value = resource:value();
					if (less_than and resource_value <= threshold_value) or (not less_than and resource_value >= threshold_value) then
						local resource_key = resource:key();
						for i = 1, #pooled_resource_keys do
							if resource_key == pooled_resource_keys[i] then
								return true;
							end;
						end;
					end;
					return false;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	local calling_script_should_start_nt = true;

	-- trigger immediately if the faction already has this many pooled resource
	local faction = cm:get_faction(pooled_resource_faction_key);
	if faction then
		local prm = faction:pooled_resource_manager();
		for i = 1, #pooled_resource_keys do

			local resource = prm:resource(pooled_resource_keys[i]);
			if not resource:is_null_interface() then
				if resource:value() >= threshold_value then
					nt:force_main_trigger("Faction [" .. pooled_resource_faction_key .. "] already has [" .. resource:value() .. "] of pooled resource [" .. resource:key() .. "] on startup which is >= threshold value [" .. threshold_value .. "], triggering immediately", true);
					calling_script_should_start_nt = false;
				end;
			end;
		end;
	end;


	return nt, calling_script_should_start_nt;
end;


--- @function pooled_resource_gained
--- @desc Creates and starts a narrative trigger that fires when the specified faction has an amount of a specified pooled resource equal to or greater than a specified threshold.
--- @desc An optional flag makes the narrative trigger instead fire when the pooled resource is less than or equal to the threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string pooled resource key, Key of the pooled resource to monitor, from the <code>pooled_resources</code> database table. this can also be a @table of multiple pooled resource keys.
--- @p @number threshold value, Threshold value that the pooled resoure must meet or exceed for subject faction for trigger to fire.
--- @p [opt=false] @boolean less than, Trigger when the pooled resource is less than or equal to the threshold value, rather than greater than.
function narrative_triggers.pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, pooled_resource_keys, threshold_value, less_than)
	local nt, calling_script_should_start_nt = construct_narrative_trigger_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, faction_key, pooled_resource_keys, threshold_value, less_than);

	if nt and calling_script_should_start_nt then
		nt:start();
	end;
end;


--- @function faction_pooled_resource_gained
--- @desc Creates and starts a narrative trigger that fires when the specified faction has an amount of a specified pooled resource equal to or greater than a specified threshold. This differs from @narrative_triggers:pooled_resource_gained as it allows the faction which is being monitored to be different from the faction with which the triggered messages are associated with.
--- @desc An optional flag makes the narrative trigger instead fire when the pooled resource is less than or equal to the threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction with which the triggered messages are associated with, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string pooled resource faction key, Key of the faction whose pooled resources are being monitored, from the <code>factions</code> database table.
--- @p @string pooled resource key, Key of the pooled resource to monitor, from the <code>pooled_resources</code> database table. this can also be a @table of multiple pooled resource keys.
--- @p @number threshold value, Threshold value that the pooled resoure must meet or exceed for subject faction for trigger to fire.
--- @p [opt=false] @boolean less than, Trigger when the pooled resource is less than or equal to the threshold value, rather than greater than.
function narrative_triggers.faction_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, pooled_resource_faction_key, pooled_resource_keys, threshold_value, less_than)
	local nt, calling_script_should_start_nt = construct_narrative_trigger_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, pooled_resource_faction_key, pooled_resource_keys, threshold_value, less_than);

	if nt and calling_script_should_start_nt then
		nt:start();
	end;
end;


--- @function skulls_gained
--- @desc Creates and starts a narrative trigger that fires when the specified faction has an amount of the skulls pooled resource equal to or greater than a specified threshold.
--- @desc An optional flag makes the narrative trigger instead fire when the pooled resource is less than or equal to the threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number threshold value, Threshold value that the pooled resoure must meet or exceed for subject faction for trigger to fire.
--- @p [opt=false] @boolean less than, Trigger when the pooled resource is less than or equal to the threshold value, rather than greater than.
function narrative_triggers.skulls_gained(name, faction_key, start_messages, target_messages, cancel_messages, threshold_value, less_than)
	local nt, calling_script_should_start_nt = construct_narrative_trigger_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, faction_key, "wh3_main_kho_skulls", threshold_value, less_than);

	if nt and calling_script_should_start_nt then
		nt:start();
	end;
end;


--- @function devotion_gained
--- @desc Creates and starts a narrative trigger that fires when the specified faction has an amount of the devotion pooled resource equal to or greater than a specified threshold.
--- @desc An optional flag makes the narrative trigger instead fire when the pooled resource is less than or equal to the threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number threshold value, Threshold value that the pooled resoure must meet or exceed for subject faction for trigger to fire.
--- @p [opt=false] @boolean less than, Trigger when the pooled resource is less than or equal to the threshold value, rather than greater than.
function narrative_triggers.devotion_gained(name, faction_key, start_messages, target_messages, cancel_messages, threshold_value, less_than)
	local nt, calling_script_should_start_nt = construct_narrative_trigger_pooled_resource_gained(name, faction_key, start_messages, target_messages, cancel_messages, faction_key, "wh3_main_ksl_devotion", threshold_value, less_than);

	if nt and calling_script_should_start_nt then
		nt:start();
	end;
end;

























-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Can Reach Faction
--
--	Triggers when the specified faction starts a turn and its armies can reach 
--	any settlement (or optionally any army) in a target faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_can_reach_faction(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key, include_armies)

	if not is_string(target_faction_key) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				return context:faction():name() == faction_key and cm:faction_can_reach_faction(faction_key, target_faction_key, include_armies);
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function can_reach_faction
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts a turn and any of its military forces can reach any of the settlements of a specified target faction to attack this turn. An optional flag also includes the target faction's armies in this assessment.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target faction key, Key of the target faction, from the <code>factions</code> database table.
--- @p [opt=false] @boolean include armies, Includes the target faction's roving armies in the can-reach check, as well as their settlements.
function narrative_triggers.can_reach_faction(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key, include_armies)
	local nt = construct_narrative_trigger_can_reach_faction(name, faction_key, start_messages, target_messages, cancel_messages, target_faction_key, include_armies);

	if nt then
		nt:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Can Reach Settlement
--
--	Triggers when the specified faction starts a turn and its armies can reach 
--	the specified settlement/list of settlements
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_can_reach_settlement(name, faction_key, start_messages, target_messages, cancel_messages, target_region_keys, include_agents)

	if is_string(target_region_keys) then
		target_region_keys = {target_region_keys};
	elseif not validate.is_table_of_strings(target_region_keys) then
		return false;
	end;

	for i = 1, #target_region_keys do
		if not cm:get_region(target_region_keys[i]) then
			script_error("ERROR: construct_narrative_trigger_can_reach_settlement() called but element [" .. i .. "] in supplied target region keys list [" .. target_region_keys[i] .. "] is not a valid region key");
			return false;
		end;
	end;

	if not is_string(target_faction_key) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				if context:faction():name() == faction_key then
					local char_list = context:faction():character_list();
					for i, char in model_pairs(char_list) do
						if not char:is_wounded() and (include_agents or cm:char_is_general_with_army(char)) then
							for j = 1, #target_region_keys do
								if cm:character_can_reach_settlement(char, cm:get_region(target_region_keys[j]):settlement()) then
									return true;
								end;
							end;
						end;
					end;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function can_reach_settlement
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts a turn and any of its military forces can reach any of the specified settlements to attack this turn. An optional flag also includes the subject faction's agents in this assessment, as well as military forces.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string target settlements, Key of the region containing the target settlement, from the <code>campaign_map_regions</code> database table. If multiple target settlements are desired then a @table containing multiple string keys may be supplied here.
--- @p @boolean include agents, Include the source faction's agents/heroes in the can-reach assessment.
function narrative_triggers.can_reach_settlement(name, faction_key, start_messages, target_messages, cancel_messages, target_region_keys, include_agents)
	local nt = construct_narrative_trigger_can_reach_settlement(name, faction_key, start_messages, target_messages, cancel_messages, target_region_keys, include_agents);

	if nt then
		nt:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Corruption In Adjacent Region
--
--	Triggers when the value of a supplied type of corruption reaches a supplied value
--	in any region adjacent to territory held by the specified faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_corruption_in_adjacent_region(name, faction_key, start_messages, target_messages, cancel_messages, corruption_type, threshold_value, culture_to_exclude)

	if not is_string(corruption_type) then
		return false;
	end;

	if not is_positive_number(threshold_value) then
		return false;
	end;

	local culture_condition;
	if culture_to_exclude then
		if not validate.is_string(culture_to_exclude) then
			return false;
		else
			function culture_condition(region)
				return region:is_abandoned() or region:owning_faction():culture() ~= culture_to_exclude;
			end;
		end;
	end;

	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				if context:faction():name() == faction_key then
					
					local region_list_table = cm:get_regions_adjacent_to_faction(context:faction(), culture_condition);

					for i = 1, #region_list_table do
						local resource = region_list_table[i]:province():pooled_resource_manager():resource(corruption_type);

						if not resource:is_null_interface() and resource:value() >= threshold_value then
							if exclude_culture then

							else
								return true;
							end;
						end;
					end;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function corruption_in_adjacent_region
--- @desc Creates and starts a narrative trigger that fires when the amount of corruption in any adjacent region to the specified faction reaches a specified threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @string corruption type, Corruption type, from the <code>pooled_resources</code> database table.
--- @p @number threshold value, Threshold value which the corruption must meet or exceed in an adjacent region for the trigger condition to be met.
--- @p [opt=nil] @string culture key, Culture key of region owner to exclude. If an eligible region has a faction owner with this culture, the region will not be included.
function narrative_triggers.corruption_in_adjacent_region(name, faction_key, start_messages, target_messages, cancel_messages, corruption_type, threshold_value, culture_to_exclude)
	local nt = construct_narrative_trigger_corruption_in_adjacent_region(name, faction_key, start_messages, target_messages, cancel_messages, corruption_type, threshold_value, culture_to_exclude);

	if nt then
		nt:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Foreign Slot Established
--
--	Triggers when a foreign slot is established by the supplied faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_foreign_slot_established(name, faction_key, start_messages, target_messages, cancel_messages, should_be_allied)

	if not validate.is_boolean_or_nil(should_be_allied) then
		return false;
	end;
	
	local main_events_and_conditions = {
		{
			event = "ForeignSlotManagerCreatedEvent",
			condition = function(context, nt)
				if context:requesting_faction():name() == faction_key then
					return not is_boolean(should_be_allied) or context:is_allied() == should_be_allied;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function foreign_slot_established
--- @desc Creates and starts a narrative trigger that fires when the specified faction establishes a foreign slot. Whether the foreign slot should be allied to the region it's embedded in or not may optionally be specified.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @boolean should be allied, Should the foreign slot be allied to the region its embedded in or not. If @nil (or no value) is supplied here then the trigger fires in either case.
function narrative_triggers.foreign_slot_established(name, faction_key, start_messages, target_messages, cancel_messages, should_be_allied)
	local nt = construct_narrative_trigger_foreign_slot_established(name, faction_key, start_messages, target_messages, cancel_messages, should_be_allied);

	if nt then
		nt:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Ritual Performed
--
--	Triggers when a ritual is performed by the supplied faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_ritual_performed(name, faction_key, start_messages, target_messages, cancel_messages, ritual_keys, ritual_categorys, target_faction_keys)

	if ritual_keys then
		if is_string(ritual_keys) then
			ritual_keys = {ritual_keys};
		elseif not validate.is_table_of_strings(ritual_keys) then
			return false;
		end;
	end;

	if ritual_categories then
		if is_string(ritual_categories) then
			ritual_categories = {ritual_categories};
		elseif not validate.is_table_of_strings(ritual_categories) then
			return false;
		end;
	end;

	if target_faction_keys then
		if is_string(target_faction_keys) then
			target_faction_keys = {target_faction_keys};
		elseif not validate.is_table_of_strings(target_faction_keys) then
			return false;
		end;
	end;
	
	local main_events_and_conditions = {
		{
			event = "RitualStartedEvent",
			condition = function(context, nt)
				if context:performing_faction():name() == faction_key then
					-- Make sure the key of the ritual matches one of our supplied ritual key criteria (if we have any)
					if ritual_keys then
						local ritual_key_match = false;

						local ritual_key = ritual:ritual_key();

						for i = 1, #ritual_keys do
							if ritual_keys[i] == ritual_key then
								ritual_key_match = true;
								break;
							end;
						end;

						if not ritual_key_match then
							return false;
						end;
					end;
					
					-- Make sure the category of the ritual matches one of our supplied ritual category criteria (if we have any)
					if ritual_category_keys then
						local ritual_category_match = false;

						local ritual_category_key = ritual:ritual_category()

						for i = 1, #ritual_category_keys do
							if ritual_category_keys[i] == ritual_category_key then
								ritual_category_match = true;
								break;
							end;
						end;

						if not ritual_category_match then
							return false;
						end;
					end;

					-- Make sure the target faction matches one of our supplied criteria (if we have any)
					if target_faction_keys then
						local target_match = false;

						local target_faction_key = ritual:target_faction():name();

						for i = 1, #target_faction_keys do
							if target_faction_keys[i] == target_faction_key then
								target_match = true;
								break;
							end;
						end;

						if not target_match then
							return false;
						end
					end;

					return true;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function ritual_performed
--- @desc Creates and starts a narrative trigger that fires when the specified faction performs a ritual. One or more optional ritual keys, ritual categories and target faction keys may be specified which the ritual performed must satisfy. Where a list of ritual keys/ritual categories/target faction keys is given, the ritual performed must match one of those in the list to qualify.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string ritual keys, Key(s) of ritual(s), from the <code>rituals</code> database table. This can be a @string ritual key or a @table of strings. If no ritual keys are specified then any rituals match.
--- @p [opt=nil] @string ritual categories, Key(s) of ritual category/categories, from the <code>ritual_categories</code> database table. This can be a @string category key or a @table of strings. If no categories are specified then any rituals match.
--- @p [opt=nil] @string target faction keys, Key(s) of any target factions, from the <code>factions</code> database table. This can be a @string faction key or a @table of strings. If no target factions are specified then any targets match.
function narrative_triggers.ritual_performed(name, faction_key, start_messages, target_messages, cancel_messages, ritual_keys, ritual_categorys, target_faction_keys)
	local nt = construct_narrative_trigger_ritual_performed(name, faction_key, start_messages, target_messages, cancel_messages, ritual_keys, ritual_categorys, target_faction_keys);

	if nt then
		nt:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Character Action
--
--	Triggers when a character action (hero action) is performed by the supplied faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_character_action(name, faction_key, start_messages, target_messages, cancel_messages, abilities, target_faction_keys, character_subtypes, must_be_success)

	if abilities then
		if is_string(abilities) then
			abilities = {abilities};
		elseif not validate.is_table_of_strings(abilities) then
			return false;
		end;
	end;

	if target_faction_keys then
		if is_string(target_faction_keys) then
			target_faction_keys = {target_faction_keys};
		elseif not validate.is_table_of_strings(target_faction_keys) then
			return false;
		end;
	end;

	if character_subtypes then
		if is_string(character_subtypes) then
			character_subtypes = {character_subtypes};
		elseif not validate.is_table_of_strings(character_subtypes) then
			return false;
		end;
	end;
	
	local main_events_and_conditions = {
		{
			event = "CharacterCharacterTargetAction",
			condition = function(context, nt)
				if context:character():faction():name() == faction_key then

					-- Make sure the ability matches one of our supplied abilities criteria (if we have any)
					if abilities then
						local ability_match = false;

						local ability = context:ability();

						for i = 1, #abilities do
							if abilities[i] == ability then
								ability_match = true;
								break;
							end;
						end;

						if not ability_match then
							return false;
						end;
					end;

					-- Make sure the target faction matches one of our supplied criteria (if we have any)
					if target_faction_keys then
						local target_match = false;

						local target_faction_key = context:target_character():name();

						for i = 1, #target_faction_keys do
							if target_faction_keys[i] == target_faction_key then
								target_match = true;
								break;
							end;
						end;

						if not target_match then
							return false;
						end
					end;
					
					-- Make sure the character subtype matches one of our supplied criteria (if we have any)
					if character_subtypes then
						local subtype_match = false;

						local subtype = context:character():character_subtype_key()

						for i = 1, #character_subtypes do
							if character_subtypes[i] == subtype then
								subtype_match = true;
								break;
							end;
						end;

						if not subtype_match then
							return false;
						end;
					end;

					if must_be_success then
						if not (context:mission_result_success() or context:mission_result_critial_success()) then
							return false;
						end;
					end;

					return true;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function character_action
--- @desc Creates and starts a narrative trigger that fires when a character in the specified faction performs a character action (hero action). One or more optional action keys, performing character subtypes and/or target faction keys may be specified which the action performed must satisfy. It may also be specified whether the action must have succeeded to qualify.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string ability key(s), Key(s) of character ability/abilities, from the <code>abilities</code> database table. This can be a @string ability key or a @table of strings. If no ability keys are specified then any abilities match.
--- @p [opt=nil] @string target faction keys, Key(s) of any target factions, from the <code>factions</code> database table. This can be a @string faction key or a @table of strings. If no target factions are specified then any targets match.
--- @p [opt=nil] @string char subtypes, Key(s) of character subtypes of the performing character, from the <code>agent_subtypes</code> database table. This can be a @string subtype key or a @table of strings. If no subtypes are specified then any performing characters match.
--- @p [opt=nil] @boolean must be success, Specifies whether only successful character actions qualify.
function narrative_triggers.character_action(name, faction_key, start_messages, target_messages, cancel_messages, abilities, target_faction_keys, character_subtypes, must_be_success)
	local nt = construct_narrative_trigger_character_action(name, faction_key, start_messages, target_messages, cancel_messages, abilities, target_faction_keys, character_subtypes, must_be_success);

	if nt then
		nt:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Technology Research
--
--	Triggers when a faction starts or completes a technology
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_technology_research(name, faction_key, start_messages, target_messages, cancel_messages, trigger_on_completed, technology_keys, condition)

	if not validate.is_boolean(trigger_on_completed) then
		return false;
	end;

	if technology_keys then
		if is_string(technology_keys) then
			technology_keys = {technology_keys};
		elseif not validate.is_table_of_strings(technology_keys) then
			return false;
		end;
	end;

	if condition and not is_function(condition) then
		return false;
	end;

	local main_events_and_conditions = {
		{
			event = trigger_on_completed and "ResearchCompleted" or "ResearchStarted",
			condition = function(context, nt)
				if context:faction():name() == faction_key then
					local subject_technology_key = context:technology();

					if technology_keys then
						for i = 1, #technology_keys do
							if technology_keys[i] == subject_technology_key then
								if not condition or condition(context, nt) then
									nt:out("triggering as faction [" .. faction_key .. "] has " .. (trigger_on_completed and "completed" or "started") .. " a technology [" .. subject_technology_key .. "] which is in supplied list [" .. table.concat(technology_keys, ", ") .. "] and " .. (condition and "the supplied condition passed" or "there was no condition function to pass"));
									return true;
								end;
							end;
						end;
					else
						if not condition or condition(context, nt) then
							nt:out("triggering as faction [" .. faction_key .. "] has " .. (trigger_on_completed and "completed" or "started") .. " a technology [" .. subject_technology_key .. "], there was no supplied whitelist of technologies, and " .. (condition and "the supplied condition passed" or "there was no condition function to pass"));
							return true;
						end;
					end;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function technology_research_started
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts researching a technology. A list of zero or more technology keys can be supplied which the technology must be in. Additionally, a condition function may be supplied which must be passed if the trigger is to fire.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string technology key, Technology key, from the <code>technologies</code> database table, which the subject technology must match for the trigger to fire. A @table of @string technology keys may be supplied here, in which case the trigger will fire if the subject technology is in the list. Additionally, @nil may be specified, in which case any technology matches.
--- @p [opt=nil] @function condition, An additional condition function which, if supplied, must be passed for the trigger to fire. The condition function will be passed the context object from the <code>ResearchStarted</code> event and the narrative trigger as two separate arguments, and should return <code>true</code> if the trigger is allowed to fire.
function narrative_triggers.technology_research_started(name, faction_key, start_messages, target_messages, cancel_messages, technology_keys, condition)
	local nt = construct_narrative_trigger_technology_research(name, faction_key, start_messages, target_messages, cancel_messages, false, technology_keys, condition);

	if nt then
		nt:start();
	end;
end;


--- @function technology_research_completed
--- @desc Creates and starts a narrative trigger that fires when the specified faction completes the research of a technology. A list of zero or more technology keys can be supplied which the technology must be in. Additionally, a condition function may be supplied which must be passed if the trigger is to fire.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string technology key, Technology key, from the <code>technologies</code> database table, which the subject technology must match for the trigger to fire. A @table of @string technology keys may be supplied here, in which case the trigger will fire if the subject technology is in the list. Additionally, @nil may be specified, in which case any technology matches.
--- @p [opt=nil] @function condition, An additional condition function which, if supplied, must be passed for the trigger to fire. The condition function will be passed the context object from the <code>ResearchCompleted</code> event and the narrative trigger as two separate arguments, and should return <code>true</code> if the trigger is allowed to fire.
function narrative_triggers.technology_research_completed(name, faction_key, start_messages, target_messages, cancel_messages, technology_keys, condition)
	local nt = construct_narrative_trigger_technology_research(name, faction_key, start_messages, target_messages, cancel_messages, true, technology_keys, condition);

	if nt then
		nt:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Net Income
--
--	Triggers when the per-turn net income of the subject faction goes above or below a threshold value
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_net_income(name, faction_key, start_messages, target_messages, cancel_messages, income_threshold, trigger_when_lower)

	if not validate.is_number(income_threshold) then
		return false;
	end;
	
	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				local faction = context:faction();
				if faction:name() == faction_key then
					if trigger_when_lower then
						return faction:net_income() <= income_threshold;
					else
						return faction:net_income() >= income_threshold;
					end;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function net_income
--- @desc Creates and starts a narrative trigger that fires when the specified faction starts a turn with a net income greater than or equal to, or less than or equal to, a specified value.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number threshold, Net income threshold.
--- @p [opt=false] @boolean trigger when lower, If set to <code>true</code>, the narrative trigger fires when the net income is less than or equal to the specified threshold instead of greater than or equal to.
function narrative_triggers.net_income(name, faction_key, start_messages, target_messages, cancel_messages, income_threshold, trigger_when_lower)
	local nt = construct_narrative_trigger_net_income(name, faction_key, start_messages, target_messages, cancel_messages, income_threshold, trigger_when_lower);

	if nt then
		nt:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Controls Provinces
--
--	Triggers when the subject faction has complete control over the supplied number of provinces
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_controls_provinces(name, faction_key, start_messages, target_messages, cancel_messages, provinces_threshold)

	if not validate.is_number(provinces_threshold) then
		return false;
	end;
	
	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				local faction = context:faction();
				return faction:name() == faction_key and cm:num_provinces_controlled_by_faction(faction) >= provinces_threshold;
			end,
			immediate = true
		},
		{
			event = "GarrisonOccupiedEvent",
			condition = function(context, nt)
				local faction = context:character():faction();
				return faction:name() == faction_key and cm:num_provinces_controlled_by_faction(faction) >= provinces_threshold;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function controls_provinces
--- @desc Creates and starts a narrative trigger that fires when the number of provinces the specified faction fully controls is greater than or equal to the supplied threshold.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number threshold, Provinces threshold.
function narrative_triggers.controls_provinces(name, faction_key, start_messages, target_messages, cancel_messages, provinces_threshold)
	local nt = construct_narrative_trigger_controls_provinces(name, faction_key, start_messages, target_messages, cancel_messages, provinces_threshold);

	if nt then
		nt:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Highest Level Settlement
--
--	Triggers when the subject faction controls a settlement or camp where the  
--	main building chain is greater than or equal to a specified level
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_trigger_highest_level_settlement(name, faction_key, start_messages, target_messages, cancel_messages, threshold_level)

	if not validate.is_number(threshold_level) then
		return false;
	end;
	
	local main_events_and_conditions = {
		{
			event = "ScriptEventHumanFactionTurnStart",
			condition = function(context, nt)
				local faction = context:faction();
				if faction:name() == faction_key then
					local settlement, settlement_level = cm:get_highest_level_settlement_for_faction(faction);
					return settlement_level and settlement_level >= threshold_level;
				end;
			end,
			immediate = true
		},
		{
			event = "GarrisonOccupiedEvent",
			condition = function(context, nt)
				local faction = context:character():faction();
				if faction:name() == faction_key then
					local settlement, settlement_level = cm:get_highest_level_settlement_for_faction(faction);
					return settlement_level and settlement_level >= threshold_level;
				end;
			end,
			immediate = true
		}
	};

	local nt = narrative_trigger:new(name, faction_key, target_messages, main_events_and_conditions, start_messages, cancel_messages);

	return nt;
end;


--- @function highest_level_settlement
--- @desc Creates and starts a narrative trigger that fires when the specified faction controls a settlement or camp where the level of the main settlement building is greater than or equal to a specified value.
--- @p @string unique name, Unique name amongst other declared narrative triggers.
--- @p @string faction key, Key of the faction to which this narrative trigger applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string start message, Message on which this narrative trigger should start its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead. If no start messages are specified, then the trigger will start its main listeners when it is started.
--- @p @string target message, Target messages to trigger when this narrative trigger fires. If multiple target messages are required then a @table containing string message names can be supplied here instead.
--- @p [opt=nil] @string cancel message, Message on which this narrative trigger should cancel its main listening process. If multiple messages are required then a @table containing string message names can be supplied here instead.
--- @p @number threshold, Settlement building level threshold.
function narrative_triggers.highest_level_settlement(name, faction_key, start_messages, target_messages, cancel_messages, threshold_level)
	local nt = construct_narrative_trigger_highest_level_settlement(name, faction_key, start_messages, target_messages, cancel_messages, threshold_level);

	if nt then
		nt:start();
	end;
end;