------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	NARRATIVE EVENT TEMPLATES
--
--	PURPOSE
--	This file defines narrative events templates. These templates can be used by any scripts that set up narrative 
--	event chains - either shared, racial, or campaign-specific.
--
--	See the script documentation for more information about the underlying narrative event system.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file. It should get loaded on start of script.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_event_templates.lua loaded");


--- @set_environment campaign


--- @data_interface narrative_events Narrative Event Templates
--- @function_separator .
--- @desc The <code>narrative_events</code> table contains a list of narrative event templates that campaign scripts can use to create narrative events. See the page on @narrative for an overview of the narrative event framework. See also the @narrative_event documentation for detailed information about the <code>narrative_event</code> object interface.
narrative_events = {};







-- Local helper function to add mission rewards to a narrative event. The mission rewards are validated here.
local function add_narrative_event_mission_rewards(ne, mission_rewards)

	local mission_rewards_to_use;

	if is_function(mission_rewards) then
		mission_rewards_to_use = mission_rewards();
		if not is_table_of_strings(mission_rewards_to_use) then
			script_error("ERROR: add_narrative_event_mission_rewards() called with mission rewards callback for narrative event [" .. ne.name .. "], but the value returned by this callback [" .. tostring(mission_rewards_to_use) .. "] is not a table of strings");
			return false;
		end;
	else
		mission_rewards_to_use = mission_rewards;
		if not validate.is_table_of_strings(mission_rewards_to_use) then
			return false;
		end;
	end;

	for i = 1, #mission_rewards_to_use do
		ne:add_payload(mission_rewards_to_use[i]);
	end;
end;


-- Local helper function to add on-issued messages to a narrative event
local function add_narrative_event_on_issued_messages(ne, on_issued_messages)
	if on_issued_messages then
		if is_string(on_issued_messages) then
			ne:add_message_on_issued(on_issued_messages);
		else
			for i = 1, #on_issued_messages do
				ne:add_message_on_issued(on_issued_messages[i]);
			end;
		end;
	end;
end;


-- Local helper function to add trigger events to a narrative event
local function add_narrative_event_trigger_messages(ne, trigger_messages)
	-- trigger on the supplied event
	if is_string(trigger_messages) then
		ne:add_trigger_condition(trigger_messages, true, trigger_messages);
	else
		if not validate.is_table_of_strings(trigger_messages) then
			return false;
		end;

		for i = 1, #trigger_messages do
			ne:add_trigger_condition(trigger_messages[i], true, trigger_messages[i]);
		end;
	end;
end;








--- @section Event Messages


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	How They Play event
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_how_they_play(unique_name, faction_key, trigger_messages, on_issued_messages)

	if not validate.is_string(faction_key) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Set up a trigger callback that shows the event
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			-- Prevent the on-issued event from being immediately triggered when this callback returns
			allow_issue_completed_callback(false);
			
			show_how_to_play_event(
				faction_key,
				function()
					if cm:is_multiplayer() then
						allow_issue_completed_callback(true);
					else
						cm:progress_on_events_dismissed(
							unique_name,
							function()
								allow_issue_completed_callback(true);
							end
						);
					end;
				end
			);
		end
	);

	return ne;
end;


--- @function how_they_play
--- @desc Creates and starts a how-they-play narrative event. This shows the how-they-play event message for the supplied faction key in singelplayer mode. In multiplayer mode nothing is shown and the narrative flow proceeds immediately.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.how_they_play(unique_name, faction_key, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_how_they_play(unique_name, faction_key, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Event Message
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_message(unique_name, faction_key, title_key, primary_key, secondary_key, persistent, index, trigger_messages, on_issued_messages)
	if not validate.is_string(title_key) or not validate.is_string(primary_key) or not validate.is_string(secondary_key) or not validate.is_boolean(persistent) or not validate.is_positive_number(index) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Set up a trigger callback that shows the event. We handle triggering the on-completed events ourselves 
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			cm:show_message_event(faction_key, title_key, primary_key, secondary_key, persistent, index);
		end
	);

	return ne;
end;


--- @function event_message
--- @desc Creates and starts an event message narrative event. An event message with the specified title, primary and secondary text will be shown.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string title text key, Text key of title for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @string primary text key, Text key of primary text for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @string secondary text key, Text key of secondary text for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @boolean persistent, Persistence flag to pass to @campaign_manager:show_message_event.
--- @p @number index, Index value to pass to @campaign_manager:show_message_event. This determines the header image shown.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.event_message(unique_name, faction_key, title_key, primary_key, secondary_key, persistent, index, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_message(unique_name, faction_key, title_key, primary_key, secondary_key, persistent, index, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;


--- @function event_message_not_player_turn_only
--- @desc Creates and starts an event message narrative event. An event message with the specified title, primary and secondary text will be shown. It will be shown as it is triggered, regardless of which faction is taking their turn.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string title text key, Text key of title for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @string primary text key, Text key of primary text for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @string secondary text key, Text key of secondary text for the event message to create, in full localised <code>[table]_[field]_[record_key]</code> format.
--- @p @boolean persistent, Persistence flag to pass to @campaign_manager:show_message_event.
--- @p @number index, Index value to pass to @campaign_manager:show_message_event. This determines the header image shown.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.event_message_not_player_turn_only(unique_name, faction_key, title_key, primary_key, secondary_key, persistent, index, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_message(unique_name, faction_key, title_key, primary_key, secondary_key, persistent, index, trigger_messages, on_issued_messages);

	ne:add_intervention_configuration_callback(
		function(inv)
			inv:set_player_turn_only(false);
		end
	);

	if ne then
		ne:start();
	end;
end;










--- @section Interventions


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Intervention
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_intervention(unique_name, faction_key, config_callback, trigger_callback, trigger_messages, on_issued_messages)
	
	if config_callback and not validate.is_function(config_callback) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	if config_callback then
		ne:add_intervention_configuration_callback(config_callback);
	end;

	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)

			if cm:is_multiplayer() then
				if cm:get_local_faction_name(true) ~= faction_key then
					ne:out("Message [" .. tostring(triggering_message) .. "] received, not triggering as [" .. faction_key .. "] is not the local faction");
					return;
				end;
				ne:out("Message [" .. tostring(triggering_message) .. "] received, not starting an intervention as we're in multiplayer");
			else
				ne:out("Message [" .. tostring(triggering_message) .. "] received, starting an intervention as we're in multiplayer");
			end;

			if trigger_callback then
				trigger_callback(triggering_message, allow_issue_completed_callback);
			end;
		end
	);

	ne:set_priority(0);

	return ne;
end;


--- @function intervention
--- @desc Creates and starts a narrative event that starts an intervention with the supplied configuration and trigger callbacks. This allows the calling script to customise what happens within the intervention. It can also be used to trigger an intervention with a customised setup (e.g. must-trigger) which can be useful for starting a series of narrative events that would otherwise wait behind an event panel.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @function configuration callback, Intervention configuration callback. If supplied, this is passed to @narrative_event:add_intervention_configuration_callback to pre-configure the @intervention associated with the narrative event prior to it being triggered. The callback will be passed the @intervention object as a single argument when called.
--- @p [opt=nil] @function trigger callback, Trigger callback to call when the @intervention is triggered. If supplied, this is passed to @narrative_event:set_trigger_callback. The callback will be passed the @string triggering message, and a callback which can be used to prevent the narrative event completing immediately. Call the callback with <code>false</code> as an argument to stop it completing, then later with <code>true</code> as an argument to complete.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.intervention(unique_name, faction_key, config_callback, trigger_callback, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_intervention(unique_name, faction_key, config_callback, trigger_callback, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;









--- @section Callbacks and Intervals


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Callbacks
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_callback(unique_name, faction_key, callback, trigger_messages, on_issued_messages)
	if not validate.is_function(callback) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	ne:set_force_no_intervention(true);

	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			ne:out("Calling registered callback after receiving message [" .. tostring(triggering_message) .. "]");
			callback(ne, faction_key, triggering_message, allow_issue_completed_callback);
		end
	);

	return ne;
end;


--- @function callback
--- @desc Creates and starts a narrative event that calls a supplied callback when triggered. When called, the supplied callback will be passed the narrative event, the key of the faction to which it applies, the triggering message, and the <code>allow_issue_completed_callback</code> as four arguments.
--- @desc The <code>allow_issue_completed_callback</code> passed to the callback may be called with <code>false</code> supplied as an argument to prevent the narrative event from completing automatically. It will only later complete when the <code>allow_issue_completed_callback</code> is called again with <code>true</code> supplied as an argument. This mechanism allows the callback to control when the narrative event completes, rather than it completing immediately.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @function callback, Callback to call.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.callback(unique_name, faction_key, callback, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_callback(unique_name, faction_key, callback, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;








-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Intervals
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_interval(unique_name, faction_key, interval, trigger_messages, on_issued_messages)
	if not validate.is_positive_number(interval) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	ne:set_force_no_intervention(true);

	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			allow_issue_completed_callback(false);
			
			ne:out("Waiting interval " .. interval .. "s after receiving message [" .. tostring(triggering_message) .. "]");
			
			cm:callback(
				function()
					ne:out("Finished waiting interval");
					allow_issue_completed_callback(true);
				end,
				interval
			);
		end
	);

	return ne;
end;


--- @function interval
--- @desc Creates and starts a narrative event that waits a supplied interval in seconds when triggered.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @number interval, Interval in seconds to wait.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.interval(unique_name, faction_key, interval, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_interval(unique_name, faction_key, interval, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;













--- @section Advice and Savegame Values


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Set Saved Value
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_set_saved_value(unique_name, faction_key, key, value, local_machine_only, trigger_messages, on_issued_messages)
	if not validate.is_string(key) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	ne:set_force_no_intervention(true);

	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			if not local_machine_only or cm:get_local_faction_name(true) == faction_key then
				ne:out("Setting value [" .. tostring(key) .. "] to [" .. tostring(value) .. "] in savegame");
				cm:set_saved_value(key, value);
			end;
		end
	);

	return ne;
end;


--- @function set_saved_value
--- @desc Creates and starts a narrative event that saves a value to the savegame with @campaign_manager:set_saved_value when triggered.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string value key, Key of value to save.
--- @p value value, Value to save. Supported data types are @boolean, @number, @string and @table.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.set_saved_value(unique_name, faction_key, key, value, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_set_saved_value(unique_name, faction_key, key, value, false, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Set Advice String Seen
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_set_advice_string_seen(unique_name, faction_key, key, trigger_messages, on_issued_messages)
	if not validate.is_string(key) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	ne:set_force_no_intervention(true);
	
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			if faction_key == cm:get_local_faction_name(true) then
				common.set_advice_history_string_seen(key);
			end;
		end
	);

	return ne;
end;


--- @function set_advice_string_seen
--- @desc Creates and starts a narrative event that marks an advice string as 'seen' in the advice history. This is useful for marking that a particular stage has been reached in the narrative flow of events, and it can be later tested with @narrative_queries:advice_history. The string is reset if the player resets the advice history.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string value key, Key of value to mark as seen.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.set_advice_string_seen(unique_name, faction_key, key, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_set_advice_string_seen(unique_name, faction_key, key, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;















--- @section Movies and Cutscenes


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Fullscreen Movie
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_fullscreen_movie(unique_name, faction_key, movie_path, fade_start_duration, fade_end_duration, trigger_messages, on_issued_messages)

	if not validate.is_string(movie_path) then
		return false;
	end;

	if fade_start_duration then
		if not validate.is_number(fade_start_duration) then
			return false;
		end;
	else
		fade_start_duration = 0.5;
	end;

	if fade_end_duration then
		if not validate.is_number(fade_end_duration) then
			return false;
		end;
	else
		fade_end_duration = 0.5;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Allow intervention to play over fullscreen panels, pre-battle screen and not on player's turn
	ne:add_intervention_configuration_callback(
		function(inv)
			--inv:set_wait_for_dilemma(false);
			inv:set_wait_for_fullscreen_panel_dismissed(false);
			inv:set_wait_for_battle_complete(false);
			inv:set_player_turn_only(false);
		end
	);

	-- Forces the intervention to play with very high priority
	ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY);

	-- Set up a trigger callback that plays the movie. We handle triggering the on-completed events ourselves 
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			if cm:is_multiplayer() then
				allow_issue_completed_callback(false);
				
				if faction_key == cm:get_local_faction_name(true) then
					ne:out("Message [" .. tostring(triggering_message) .. "] received so playing fullscreen movie [" .. movie_path .. "] for faction [" .. faction_key .. "] in multiplayer mode");

					if fade_start_duration and fade_start_duration > 0 then
						cm:fade_scene(0, fade_start_duration);
						cm:callback(
							function()
								cm:register_instant_movie(movie_path);
							end,
							fade_start_duration
						);
					else
						cm:register_instant_movie(movie_path);
					end;
				else	
					ne:out("Message [" .. tostring(triggering_message) .. "] received but not playing fullscreen movie [" .. movie_path .. "] for faction [" .. faction_key .. "] in multiplayer mode as this is not the local faction. Will proceed when all clients have finished playing.");
				end;

				cm:progress_on_all_clients_ui_triggered(
					unique_name,
					function()
						ne:out("Fullscreen Movie [" .. movie_path .. "] for faction [" .. faction_key .. "] has finished playing for all players");
						allow_issue_completed_callback(true);
					end
				);
			else
				local function play_movie()
					cm:register_instant_movie(movie_path);
					cm:callback(
						function()
							allow_issue_completed_callback(true);
							if fade_end_duration then
								cm:fade_scene(255, fade_end_duration);
							end;
						end,
						0.2
					);
				end;

				allow_issue_completed_callback(false);
				ne:out("[NE] Fullscreen Movie [" .. movie_path .. "] for faction [" .. faction_key .. "] has received message [" .. tostring(triggering_message) .. "] and is playing in singleplayer mode");
				if fade_start_duration and fade_start_duration > 0 then
				
					cm:fade_scene(0, fade_start_duration);
					cm:callback(play_movie, fade_start_duration);
				else
					allow_issue_completed_callback(false);
					play_movie();
				end;
			end;
		end
	);

	return ne;
end;


--- @function fullscreen_movie
--- @desc Creates and starts a fullscreen movie narrative event.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string movie path, Path of movie to play. See the documentation of @episodic_scripting:register_instant_movie for more information.
--- @p [opt=0.5] @number start fade duration, Duration in seconds over which to fade the picture to black before playing the movie.
--- @p [opt=0.5] @number end fade duration, Duration in seconds over which to fade back to picture after playing the movie.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.fullscreen_movie(unique_name, faction_key, movie_path, fade_start_duration, fade_end_duration, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_fullscreen_movie(unique_name, faction_key, movie_path, fade_start_duration, fade_end_duration, trigger_messages, on_issued_messages);
	if ne then
		ne:start();
	end;
end;




















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Cutscene
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_cutscene(unique_name, faction_key, duration, cindyscene, blend_in_duration, blend_out_duration, cutscene_config, trigger_messages, on_issued_messages)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if duration and not validate.is_number(duration) then
		return false;
	end;

	if cindyscene and not validate.is_string(cindyscene) then
		return false;
	end;

	if blend_in_duration and not validate.is_number(blend_in_duration) then
		return false;
	end;

	if blend_out_duration and not validate.is_number(blend_out_duration) then
		return false;
	end;

	if cutscene_config and not validate.is_function(cutscene_config) then
		return false;
	end;

	if not duration and not cindyscene then
		script_error("ERROR: construct_narrative_event_cutscene() called with name [" .. tostring(unique_name) .. "] for faction [" .. faction_key .. "] but neither duration nor cindyscene specified - one must be supplied");
		return false;
	end;

	if not cindyscene and not cutscene_config then
		script_error("ERROR: construct_narrative_event_cutscene() called with name [" .. tostring(unique_name) .. "] for faction [" .. faction_key .. "] but neither a cindyscene nor a cutscene config has been specified - cutscene will do nothing. At least one of these must be specified.");
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	local process_name = unique_name .. "_" .. faction_key;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Allow intervention to play over dilemmas, fullscreen panels, pre-battle screen and not on player's turn
	ne:add_intervention_configuration_callback(
		function(inv)
			--[[
			inv:set_wait_for_dilemma(false);
			inv:set_wait_for_fullscreen_panel_dismissed(false);
			inv:set_wait_for_battle_complete(false);
			]]
			inv:set_player_turn_only(false);
		end
	);

	-- Forces the intervention to play with very high priority
	ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY);
	
	
	-- Construct and start cutscene
	local function cutscene_play(end_callback)
		local c;

		if cindyscene then
			c = campaign_cutscene:new_from_cindyscene(
				process_name, 
				function() 
					end_callback() 
				end, 
				cindyscene, blend_in_duration, blend_out_duration
			);
		else
			c = campaign_cutscene:new(
				process_name, 
				duration, 
				function() 
					end_callback()
				end
			);
		end;

		if not c then
			return false;
		end;

		-- Call configuration callback if one was supplied
		if is_function(cutscene_config) then
			cutscene_config(c);
		end;

		c:start();
	end;


	-- Set up a trigger callback that plays the movie. We handle triggering the on-completed events ourselves 
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			allow_issue_completed_callback(false);
			if cm:is_multiplayer() then

				local function mp_cutscene_end()
					cm:progress_on_all_clients_ui_triggered(
						process_name,
						function()
							ne:out("Cutscene [" .. unique_name .. "] for faction [" .. faction_key .. "] has finished playing for all players");
							allow_issue_completed_callback(true);
						end
					);
				end;

				if faction_key == cm:get_local_faction_name(true) then
					ne:out("Event [" .. tostring(triggered_event) .. "] received so playing cutscene [" .. unique_name .. "] for faction [" .. faction_key .. "] in multiplayer mode");
					cutscene_play(mp_cutscene_end);
				else	
					ne:out("Event [" .. tostring(triggered_event) .. "] received but not playing cutscene [" .. unique_name .. "] for faction [" .. faction_key .. "] in multiplayer mode as this is not the local faction. Will proceed when all clients have finished playing.");
					mp_cutscene_end();
				end;
			else
				ne:out("[NE] Cutscene [" .. unique_name .. "] for faction [" .. faction_key .. "] has received event [" .. tostring(triggered_event) .. "] and is playing in singleplayer mode");
				allow_issue_completed_callback(false);
				cutscene_play(
					function()
						allow_issue_completed_callback(true);
					end
				);
			end;
		end
	);

	return ne;
end;


--- @function scripted_cutscene
--- @desc Creates and starts a scripted cutscene narrative event. The cutscene constructor function @campaign_cutscene:new is used.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @number cutscene duration, Duration of scripted cutscene in seconds.
--- @p [opt=nil] @function cutscene config, This function will be called after the cutscene is created and before it is played. It can be used by client scripts to configure the cutscene object and populate it with actions. The function will be passed the cutscene object as a single argument.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.scripted_cutscene(unique_name, faction_key, duration, cutscene_config, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_cutscene(unique_name, faction_key, duration, nil, nil, nil, cutscene_config, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;


--- @function cindy_cutscene
--- @desc Creates and starts a scripted cutscene narrative event with a cindyscene. The cutscene constructor function @campaign_cutscene:new_from_cindyscene is used.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string cindyscene path, Path to cindyscene, from the working data folder.
--- @p @number blend in, Cindyscene blend in duration in seconds.
--- @p @number blend out, Cindyscene blend out duration in seconds.
--- @p [opt=nil] @function cutscene config, This function will be called after the cutscene is created and before it is played. It can be used by client scripts to configure the cutscene object and populate it with actions, if required. The function will be passed the cutscene object as a single argument.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.cindy_cutscene(unique_name, faction_key, cindyscene, blend_in_duration, blend_out_duration, cutscene_config, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_cutscene(unique_name, faction_key, nil, cindyscene, blend_in_duration, blend_out_duration, cutscene_config, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Camera Fade
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_camera_fade(unique_name, faction_key, duration, to_black, trigger_messages, on_issued_messages)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if duration and not validate.is_number(duration) then
		return false;
	end;

	to_black = not not to_black;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Set up a trigger callback that plays the movie. We handle triggering the on-completed messages ourselves 
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)

			if faction_key ~= cm:get_local_faction_name(true) then
				ne:out("Message [" .. tostring(triggering_message) .. "] received but not triggering camera fade [" .. unique_name .. "] for faction [" .. faction_key .. "] as this is not the local faction in a multiplayer game");
			else
				ne:out("Message [" .. tostring(triggering_message) .. "] received for faction [" .. faction_key .. "] so triggering camera fade to " .. (to_black and "black" or "picture") .. " over duration " .. duration .. "s");
				cm:fade_scene(to_black and 0 or 1, duration);
			end;
			
			if duration > 0 then
				allow_issue_completed_callback(false);
				cm:callback(
					function()
						allow_issue_completed_callback(true);
					end,
					duration
				);
			end;
		end
	);

	-- Make sure the fade happens asap
	ne:set_priority(0);

	return ne;
end;


--- @function camera_fade
--- @desc Creates and starts a narrative event that fades the camera to black or to picture when triggered.
--- @desc If the fade is to black, the narrative system will wait for the fade to finish before continuing. If the fade is to picture, then the narrative system continues immediately without waiting for the fade to complete.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @number fade duration, Duration of camera fade in seconds.
--- @p @boolean to black, Sets whether the camera should fade to black. Supply <code>false</code> to fade to picture instead.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.camera_fade(unique_name, faction_key, duration, to_black, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_camera_fade(unique_name, faction_key, duration, to_black, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;




















--- @section Missions


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Cancelling a mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_cancel_mission(unique_name, faction_key, mission_key, trigger_messages, on_issued_messages)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if not validate.is_string(mission_key) then
		return false;
	end;

	local ne = narrative_event:new(unique_name, faction_key);

	if not ne then
		return false;
	end;

	add_narrative_event_trigger_messages(ne, trigger_messages);
	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	-- Set up a trigger callback that plays the movie. We handle triggering the on-completed messages ourselves 
	ne:set_trigger_callback(
		function(triggering_message, allow_issue_completed_callback)
			ne:out("Message [" .. tostring(triggering_message) .. "] received for faction [" .. faction_key .. "] so cancelling mission with key [" .. mission_key .. "]");
			cm:cancel_custom_mission(faction_key, mission_key);
		end
	);

	-- Make sure the fade happens asap
	ne:set_priority(0);

	return ne;
end;


--- @function cancel_mission
--- @desc Creates and starts a narrative event that cancels a custom mission when triggered.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p @string mission key, Key of the mission to cancel, from the <code>missions</code> database table. The mission will be cancelled for the specified faction.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
function narrative_events.cancel_mission(unique_name, faction_key, mission_key, trigger_messages, on_issued_messages)
	local ne = construct_narrative_event_cancel_mission(unique_name, faction_key, mission_key, trigger_messages, on_issued_messages);

	if ne then
		ne:start();
	end;
end;
























-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Generic narrative event mission listener
--	To be used by other templates in this file to construct narrative event mission listeners
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice)
	mission_issuer = mission_issuer or "CLAN_ELDERS";
	force_advice = force_advice or false;
	
	-- One or more trigger events must be supplied
	if not validate.is_string_or_table_of_strings(trigger_messages) then
		return false;
	end;

	-- on issued and on completed events are optional
	if on_completed_messages and not validate.is_string_or_table_of_strings(on_completed_messages) then
		return false;
	end;

	if on_issued_messages and not validate.is_string_or_table_of_strings(on_issued_messages) then
		return false;
	end;

	if inherit_list and not validate.is_table_of_strings(inherit_list) then
		return false;
	end;

	local ne = narrative_event:new(
		unique_name,											-- unique name
		faction_key,											-- faction key
		advice_key,												-- advice key
		nil,													-- infotext
		mission_key,											-- mission key
		on_completed_messages									-- event to trigger when mission completed
	);

	ne:set_mission_issuer(mission_issuer);
	if force_advice then
		ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY);
	end
	add_narrative_event_trigger_messages(ne, trigger_messages);

	add_narrative_event_on_issued_messages(ne, on_issued_messages);

	if inherit_list then
		for i = 1, #inherit_list do
			ne:add_narrative_event_payload_inheritance(inherit_list[i], faction_key);
		end
	end;

	return ne;
end;





























-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Generic
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_generic(unique_name, faction_key, advice_key, mission_key, mission_text, events_and_conditions, camera_scroll_callback, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if not validate.is_table(events_and_conditions) then
		return false;
	end;

	if camera_scroll_callback and not validate.is_function(camera_scroll_callback) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();

		for i = 1, #events_and_conditions do
			local current_record = events_and_conditions[i];

			if is_string(current_record.event) and (is_function(current_record.condition) or current_record.condition == true) then
				if i == 1 then
					mm:add_new_scripted_objective(
						"mission_text_text_" .. mission_text,
						current_record.event,
						current_record.condition
					);
				else
					mm:add_scripted_objective_success_condition(
						current_record.event,
						current_record.condition
					);
				end;
			else
				if not is_string(current_record.event) then
					script_error("ERROR: construct_narrative_event_generic() is trying to set up a generic narrative event but entry [" .. i .. "] in supplied events_and_conditions table does not contain a valid event string. Each element of the supplied events_and_conditions table should itself be table containg an \"event\" element that is a string, and a \"condition\" element that is a function (or true)");
				else
					script_error("ERROR: construct_narrative_event_generic() is trying to set up a generic narrative event but entry [" .. i .. "] in supplied events_and_conditions table does not contain a valid condition function (or true value). Each element of the supplied events_and_conditions table should itself be table containg an \"event\" element that is a string, and a \"condition\" element that is a function (or true)");
				end;
				return false;
			end;
		end;
		
		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);


		if camera_scroll_callback then
			ne:set_camera_scroll_target_callback(camera_scroll_callback);
		end;

		return ne;
	end;
end;


--- @function generic
--- @desc Creates and starts a narrative event that issues a generic scripted mission. One or more event/condition pairs to pass to the underlying @mission_manager must be supplied in a @table. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p @table event/conditions, A @table containing one or more event/condition records. Each record should be a @table with a @string "event" element and a "condition" element that's either a condition function or <code>true</code>.
--- @p [opt=nil] @function camera scroll callback, A camera scroll callback, to be supplied to @narrative_event:set_camera_scroll_target_callback.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
--- @p [opt=nil] @boolean force_advice, this is used to override the default advice priority logic - by setting this to true, the supplied advice key will always be played regardless of advice level
function narrative_events.generic(unique_name, faction_key, advice_key, mission_key, mission_text, events_and_conditions, camera_scroll_callback, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice)
	local ne = construct_narrative_event_generic(unique_name, faction_key, advice_key, mission_key, mission_text, events_and_conditions, camera_scroll_callback, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:start();
	end;
end;




















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Defeat Enemy Army
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_defeat_enemy_army(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, target_char_cqi, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_string(enemy_faction_key) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("ENGAGE_FORCE");
		ne:add_condition("faction " .. enemy_faction_key);
		ne:add_condition("requires_victory");
		ne:add_condition("armies_only");

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- If we were supplied a target character cqi then zoom to that, otherwise pick the strongest army from the target faction
				if target_char_cqi then
					return target_char_cqi;
				end;

				local mf = cm:get_closest_military_force_from_faction_to_faction(enemy_faction_key, faction_key, true);
				if mf then
					return mf:general_character():command_queue_index();
				end;
			end
		);

		return ne;
	end;
end;


--- @function defeat_enemy_army
--- @desc Creates and starts a narrative event that issues a mission to defeat an army belonging to a specific enemy faction. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string enemy faction key, Key of target enemy faction, from the <code>factions</code> database table.
--- @p @number target cqi, Camera scroll target character cqi. If this is supplied the camera will scroll to the specified character when the mission is issued (assuming the narrative event decides to move the camera), otherwise it will scroll to the nearest character in the target faction to the local player's forces.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.defeat_enemy_army(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, target_char_cqi, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_defeat_enemy_army(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, target_char_cqi, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if ne then
		ne:start();
	end;
end;


--- @function defeat_initial_enemy_army
--- @desc Creates and starts a narrative event that issues a mission to defeat an army belonging to a specific enemy faction. Advice may optionally be supplied to be issued with the mission. @narrative_event:set_category is used to give this narrative event a higher priority than one created with @narrative_events:defeat_enemy_army.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string enemy faction key, Key of target enemy faction, from the <code>factions</code> database table.
--- @p @number target cqi, Camera scroll target character cqi. If this is supplied the camera will scroll to the specified character when the mission is issued (assuming the narrative event decides to move the camera), otherwise it will scroll to the nearest character in the target faction to the local player's forces.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.defeat_initial_enemy_army(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, target_char_cqi, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_defeat_enemy_army(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, target_char_cqi, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY);
		ne:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Defeat Army of Culture
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_defeat_army_of_culture(unique_name, faction_key, advice_key, mission_key, mission_text, culture_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_string(mission_text) then
		return false;
	end;

	if is_string(culture_keys) then
		culture_keys = {culture_keys};
	elseif not validate.is_string_or_table_of_strings(culture_keys) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:get_mission_manager():add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"BattleCompleted",
			function(context)
				if cm:pending_battle_cache_faction_is_attacker(faction_key) then
					local attacker_result = cm:model():pending_battle():attacker_battle_result();
					local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory");

					if attacker_won then
						for i = 1, #culture_keys do
							if cm:pending_battle_cache_culture_is_defender(culture_keys[i]) then
								ne:out();
								ne:out();
								ne:out("mission completing as faction [" .. faction_key .. "] has won a battle as attacker against army with culture [" .. culture_keys[i] .. "]");
								return true;
							end;
						end;
					end;

				elseif cm:pending_battle_cache_faction_is_defender(faction_key) then
					local defender_result = cm:model():pending_battle():defender_battle_result();
					local defender_won = (defender_result == "heroic_victory") or (defender_result == "decisive_victory") or (defender_result == "close_victory") or (defender_result == "pyrrhic_victory");
					
					if defender_won then
						for i = 1, #culture_keys do
							if cm:pending_battle_cache_culture_is_attacker(culture_keys[i]) then
								ne:out();
								ne:out();
								ne:out("mission completing as faction [" .. faction_key .. "] has won a battle as defender against army with culture [" .. culture_keys[i] .. "]");
								return true;
							end;
						end;
					end
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				local closest_char;
				local closest_dist = 9999999;
				for i = 1, #culture_keys do
					local current_char, current_dist = cm:get_closest_visible_character_of_culture(faction_key, culture_keys[i]);

					if current_dist and current_dist < closest_dist then
						closest_char = current_char;
						closest_dist = current_dist;
					end;
				end;

				if closest_char and closest_dist < 200 then
					return closest_char:command_queue_index();
				end;
			end
		);

		return ne;
	end;
end;


--- @function defeat_army_of_culture
--- @desc Creates and starts a narrative event that issues a mission to defeat an army belonging to a specified culture or list of cultures. Advice may optionally be supplied to be issued with the mission.
--- @desc As this is a scripted mission a text key for the mission objective must be supplied.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text key, Text key of mission ojective to show, in the full <code>[table]_[field]_[key]</code> format.
--- @p @string culture key, Key of target culture, from the <code>cultures</code> database table. This can also be a @table of strings if multiple target cultures are desired.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.defeat_army_of_culture(unique_name, faction_key, advice_key, mission_key, mission_text, culture_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_defeat_army_of_culture(unique_name, faction_key, advice_key, mission_key, mission_text, culture_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function defeat_chaos_army
--- @desc Creates and starts a narrative event that issues a mission to defeat an army belonging to a specified. Advice may optionally be supplied to be issued with the mission.
--- @desc As this is a scripted mission a text key for the mission objective must be supplied.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.defeat_chaos_army(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local chaos_cultures = {
		"wh3_main_dae_daemons",
		"wh3_main_kho_khorne",
		"wh3_main_nur_nurgle",
		"wh3_main_sla_slaanesh",
		"wh3_main_tze_tzeentch",
		"wh_main_chs_chaos",
		"wh_dlc08_nor_norsca",
		"wh_dlc03_bst_beastmen"
	};

	local mission_text_key = "wh3_main_narrative_mission_description_defeat_any_chaos_army";
	
	local ne = construct_narrative_event_defeat_army_of_culture(unique_name, faction_key, advice_key, mission_key, mission_text_key, chaos_cultures, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Consume Pooled Resource
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_consume_pooled_resource(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resource, value_to_consume, factor_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_string(pooled_resource) then
		return false;
	end;

	if not validate.is_number(value_to_consume) then
		return false;
	end;

	local full_mission_text = "mission_text_text_" .. mission_text;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		-- Ensure that a pooled resource tracker is started for this faction
		cm:start_pooled_resource_tracker_for_faction(faction_key);
		
		local mm = ne:get_mission_manager();

		mm:add_new_scripted_objective(
			full_mission_text,
			"ScriptEventTrackedPooledResourceChanged",
			function(context)
				if not context:has_faction() or context:faction():name() ~= faction_key then
					return false;
				end;
				
				local resource_value = 0;
				
				if factor_keys then
					for i = 1, #factor_keys do
						resource_value = resource_value + cm:get_total_pooled_resource_spent_for_faction(faction_key, pooled_resource, factor_keys[i]);
					end
				else
					resource_value = cm:get_total_pooled_resource_spent_for_faction(faction_key, pooled_resource);
				end;

				-- Update count on mission display
				mm:update_scripted_objective_text(full_mission_text, resource_value, value_to_consume);
				
				if resource_value >= value_to_consume then
					ne:out("mission completing as pooled resource [" .. pooled_resource .. "] for faction [" .. faction_key .. "] has a spent value of [" .. resource_value .. "] which is greater or equal to required value [" .. value_to_consume .. "]");
					
					return true;
				end;
			end
		);

		mm:add_first_time_trigger_callback(
			function()
				mm:update_scripted_objective_text(full_mission_text, 0, value_to_consume);
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function consume_pooled_resource
--- @desc Creates and starts a narrative event that issues a mission for the specified faction to consume a specified amount of a specified pooled resource.
--- @desc As it is a scripted mission, mission objective text must be supplied. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the mission_text database table. This must be set up for scripted missions such as this.
--- @p @string pooled resource key, Key of the pooled resource to monitor, from the <code>pooled_resources</code> database table.
--- @p @number value to consume, Amount of the pooled resource that is required to be consumed for the mission to complete.
--- @p [opt=nil] @table factor keys, Keys of specific factors to track.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.consume_pooled_resource(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resource, value_to_consume, factor_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_consume_pooled_resource(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resource, value_to_consume, factor_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Gain Pooled Resources
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_gain_pooled_resource(unique_name, faction_key, advice_key, mission_key, resource_key, resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	if not validate.is_string(resource_key) then
		return false;
	end;

	if not validate.is_number(resource_quantity) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE");
		ne:add_condition("pooled_resource  " .. resource_key);
		ne:add_condition("total " .. resource_quantity);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function gain_pooled_resource
--- @desc Creates and starts a narrative event that issues a mission to gain a specified amount of a specified pooled resource. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string resource key, Key of pooled resource, from the <code>pooled_resources</code> database table.
--- @p @string resource quantity, Absolute quantity of pooled resource the faction has to acquire to complete the mission.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.gain_pooled_resource(unique_name, faction_key, advice_key, mission_key, resource_key, resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_gain_pooled_resource(unique_name, faction_key, advice_key, mission_key, resource_key, resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function gain_devotion
--- @desc Creates and starts a narrative event that issues a mission to gain a specified amount of the Kislev Devotion pooled resource. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string resource quantity, Absolute quantity of pooled resource the faction has to acquire to complete the mission.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.gain_devotion(unique_name, faction_key, advice_key, mission_key, resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_gain_pooled_resource(unique_name, faction_key, advice_key, mission_key, "wh3_main_ksl_devotion", resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function gain_supporters
--- @desc Creates and starts a narrative event that issues a mission to gain a specified amount of the Kislev Supporters pooled resource. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string resource quantity, Absolute quantity of pooled resource the faction has to acquire to complete the mission.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.gain_supporters(unique_name, faction_key, advice_key, mission_key, resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_gain_pooled_resource(unique_name, faction_key, advice_key, mission_key, "wh3_main_ksl_followers", resource_quantity, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Gain Pooled Resources Scripted
--	This mission is script-driven, which allows multiple pooled resources to be
--	monitored at the same time. The Mission text must be supplied, however.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_gain_pooled_resource_scripted(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resources, lower_threshold, upper_threshold, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if is_string(pooled_resources) then
		pooled_resources = {pooled_resources};
	else
		if not validate.is_table_of_strings(pooled_resources) then
			return false;
		end;
	end;

	if lower_threshold and not validate.is_number(lower_threshold) then
		return false;
	end;

	if upper_threshold and not validate.is_number(upper_threshold) then
		return false;
	end;

	if not lower_threshold and not upper_threshold then
		script_error("ERROR: construct_narrative_event_gain_pooled_resource_scripted() is trying to construct a pooled resources narrative event but neither a lower threshold or upper threshold value were specified - one or both must be supplied");
		return false;
	end;

	if not validate.is_boolean(is_additive) then
		return false;
	end;

	local full_mission_text = "mission_text_text_" .. mission_text;

	local pooled_resources_lookup = table.indexed_to_lookup(pooled_resources);

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		-- Ensure that a pooled resource tracker is started for this faction
		cm:start_pooled_resource_tracker_for_faction(faction_key);


		-- Callback to check single pooled resource (all specified resources are checked against the total individually)
		local function single_resource_value_check(resource_changed)
			local resource_value = resource_changed:value();

			-- Update count on mission display
			ne:get_mission_manager():update_scripted_objective_text(full_mission_text, resource_value);

			-- Value must be between lower threshold and upper threshold (inclusive) to qualify
			if lower_threshold and resource_value < lower_threshold then
				return false;
			end;

			if upper_threshold and resource_value > upper_threshold then
				return false;
			end;
			
			ne:out();
			ne:out();
			if lower_threshold then
				if upper_threshold then
					ne:out("mission completing as pooled resource [" .. resource_changed:key() .. "] for faction [" .. faction_key .. "] has a value of [" .. resource_value .. "] between threshold levels [" .. lower_threshold .. " and " .. upper_threshold .. "]");
				else
					ne:out("mission completing as pooled resource [" .. resource_changed:key() .. "] for faction [" .. faction_key .. "] has a value of [" .. resource_value .. "] which is greater than or equal to lower threshold level [" .. lower_threshold .. "]");
				end;
			else
				ne:out("mission completing as pooled resource [" .. resource_changed:key() .. "] for faction [" .. faction_key .. "] has a value of [" .. resource_value .. "] which is less than or equal to upper threshold level [" .. upper_threshold .. "]");
			end;
			
			return true;
		end;


		-- Callback to check additive pooled resource (in this mode, all specified resources are summed and then compared with total)
		local function additive_resource_value_check()
			local faction = cm:get_faction(faction_key);
			if not faction then
				return false;
			end;

			local total_resource_value = 0;
			local prm = faction:pooled_resource_manager();

			for i = 1, #pooled_resources do
				local resource_name = pooled_resources[i];
				local current_resource = prm:resource(resource_name);
				if current_resource and not current_resource:is_null_interface() then
					total_resource_value = total_resource_value + current_resource:value();
				end;
			end;

			-- Update count on mission display
			ne:get_mission_manager():update_scripted_objective_text(full_mission_text, total_resource_value);

			-- Value must be between lower threshold and upper threshold (inclusive) to qualify
			if lower_threshold and total_resource_value < lower_threshold then
				return false;
			end;

			if upper_threshold and total_resource_value > upper_threshold then
				return false;
			end;
			
			ne:out();
			ne:out();
			if lower_threshold then
				if upper_threshold then
					ne:out("mission completing as faction [" .. faction_key .. "] has a total of all pooled resources [" .. table.concat(pooled_resources, ", ") .. "] of [" .. total_resource_value .. "] which is between threshold levels [" .. lower_threshold .. " and " .. upper_threshold .. "]");
				else
					ne:out("mission completing as faction [" .. faction_key .. "] has a total of all pooled resources [" .. table.concat(pooled_resources, ", ") .. "] of [" .. total_resource_value .. "] which is greater than or equal to lower threshold level [" .. lower_threshold .. "]");
				end;
			else
				ne:out("mission completing as faction [" .. faction_key .. "] has a total of all pooled resources [" .. table.concat(pooled_resources, ", ") .. "] of [" .. total_resource_value .. "] which is less than or equal to upper threshold level [" .. upper_threshold .. "]");
			end;
			
			return true;
		end;

		
		-- Check to be executed when tracked pooled resource event is received
		local function condition_check(context)
			if not context:has_faction() or context:faction():name() ~= faction_key then
				return false;
			end;
			local pooled_resource = context:resource();
			local resource_key = pooled_resource:key();
			if not pooled_resources_lookup[resource_key] then
				return;
			end;

			if is_additive then
				return additive_resource_value_check();
			end;

			return single_resource_value_check(pooled_resource);
		end;


		local mm = ne:get_mission_manager();

		mm:add_new_scripted_objective(
			full_mission_text,
			"ScriptEventTrackedPooledResourceChanged",
			condition_check
		);

		mm:add_scripted_objective_success_condition(
			"ScriptEventTrackedPooledResourceRegularIncome",
			condition_check
		);

		-- Check the faction's pooled resource when the mission starts
		mm:add_each_time_trigger_callback(
			function()
				local should_complete_immediately = false;

				if is_additive then
					should_complete_immediately = additive_resource_value_check();
				else
					local faction = cm:get_faction(faction_key);
					if faction then
						local prm = faction:pooled_resource_manager();
						for i = 1, #pooled_resources do
							local current_resource = prm:resource(pooled_resources[i]);
							if current_resource and not current_resource:is_null_interface() then
								should_complete_immediately = single_resource_value_check(current_resource);
								if should_complete_immediately then
									break;
								end;
							end;
						end;
					end;
				end;
				
				-- Complete the mission if the faction already has the required number of pooled resource
				if should_complete_immediately then
					mm:force_scripted_objective_success();
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function gain_pooled_resource_scripted
--- @desc Creates and starts a narrative event that issues a mission for the specified faction to gain a specified amount of one or more specified pooled resources. Unlike @narrative_events:gain_pooled_resource this sets up a scripted mission, where script is responsible for the completion of the mission. This allows multiple pooled resources to be considered at the same time, either additively or not, allowing mission constructs such as "earn x of pooled resources a, b and c together", or "earn x of pooled resources a, b or c".
--- @desc As it is a scripted mission, mission objective text must be supplied. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the mission_text database table. This must be set up for scripted missions such as this.
--- @p @string pooled resource key, Key of the pooled resource to monitor, from the <code>pooled_resources</code> database table. This may also be a @table of @string pooled resource keys if multiple pooled resources are to be monitored.
--- @p @number lower threshold, Lower threshold level of the pooled resource(s) at which the mission completes. If not supplied, then there is no lower pooled resource bound at which the mission completes.
--- @p @number upper threshold, Upper threshold level of the pooled resource(s) at which the mission completes. If not supplied, then there is no upper pooled resource bound at which the mission completes. One or both of the lower and upper thresholds must be provided.
--- @p @boolean additive, If set to <code>true</code> the value of all supplied specified pooled resources is counted towards the threshold value. If <code>false</code> is supplied, then the mission only completes when one of the pooled resources specified reaches the threshold value.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.gain_pooled_resource_scripted(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resources, lower_threshold, upper_threshold, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_gain_pooled_resource_scripted(unique_name, faction_key, advice_key, mission_key, mission_text, pooled_resources, lower_threshold, upper_threshold, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Capture Settlement
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_capture_settlement(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, region_keys, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority_category)
	
	if enemy_faction_key and not validate.is_string(enemy_faction_key) then
		return false;
	end;

	if region_keys then
		if is_string(region_keys) then
			region_keys = {region_keys};
		elseif not is_table_of_strings(region_keys) then
			script_error("WARNING: construct_narrative_event_capture_settlement() called but supplied target region key [" .. tostring(region_keys) .. "] is not a string, a table of strings, or nil. Disregarding it.");
			region_keys = nil;
		end;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("CAPTURE_REGIONS");
		if enemy_faction_key then
			ne:add_condition("faction " .. enemy_faction_key);
		end;

		if region_keys then
			for i = 1, #region_keys do
				ne:add_condition("region " .. region_keys[i]);
			end;
		end;

		if high_priority_category then
			ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY);
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		if scroll_camera_target then
			if is_function(scroll_camera_target) then
				ne:set_camera_scroll_target_callback(scroll_camera_target);
			else	
				ne:set_camera_scroll_target_callback(
					function()
						
						if is_string(scroll_camera_target) then
							-- If the scroll camera target is a faction key then use its closest settlement as the camera target
							if cm:get_faction(scroll_camera_target) then
								local region = cm:get_closest_settlement_from_faction_to_faction(scroll_camera_target, faction_key);
								if region then
									return region:name();
								end;
							else
								local region = cm:get_region(scroll_camera_target);

								if region then
									return region:name();
								end;
							end;
						end;

						return scroll_camera_target;
					end
				);
			end;

		elseif region_keys then
			-- If no scroll camera target was set but we were supplied one or more region keys, then use the closest settlement as the camera target
			ne:set_camera_scroll_target_callback(
				function()
					local region = cm:get_closest_settlement_from_table_to_faction(region_keys, faction_key);
					if region then
						return region:name();
					end;
				end
			);
		
		elseif enemy_faction_key then
			-- If no scroll camera target was set but we were supplied a faction key, then use its closest settlement as the camera target
			ne:set_camera_scroll_target_callback(
				function()
					local region = cm:get_closest_settlement_from_faction_to_faction(enemy_faction_key, faction_key);
					if region then
						return region:name();
					end;
				end
			);
		end;

		return ne;
	end;
end;


--- @function capture_settlement
--- @desc Creates and starts a narrative event that issues a mission to capture a settlement, optionally belonging to a specific enemy faction. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=nil] @string enemy faction key, Key of target enemy faction, from the <code>factions</code> database table. If no key is specified then the capture of any settlement qualifies.
--- @p [opt=nil] @string target region key. Key of specific target region(s). This can be a @string or a @table of strings, if multiple target settlements are desired. If no value is supplied then the capture of any settlement qualifies. 
--- @p [opt=nil] value scroll target, Camera scroll target. This can be a @string region key, a @string faction key (region is looked up before faction), or a @number character cqi. If this is supplied the camera will scroll to the specified target when the mission is issued (assuming the narrative event decides to move the camera).
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
--[[ replace the last arg at some point ]]
function narrative_events.capture_settlement(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, region_key, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority_category)
	local ne = construct_narrative_event_capture_settlement(unique_name, faction_key, advice_key, mission_key, enemy_faction_key, region_key, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority_category);

	if ne then
		ne:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Raze or Own Settlements
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_raze_or_own_settlements(unique_name, faction_key, advice_key, mission_key, region_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if is_string(region_keys) then
		region_keys = {region_keys};
	elseif not validate.is_table_of_strings(region_keys) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("RAZE_OR_OWN_SETTLEMENTS");
		for i = 1, #region_keys do
			ne:add_condition("region " .. region_keys[i])
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		--[[
		ne:set_camera_scroll_target_callback(
			function()
			end
		);
		]]

		return ne;
	end;
end;


--- @function raze_or_own_settlements
--- @desc Creates and starts a narrative event that issues a mission to raze or own all specified settlements. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string region key, Region key of target settlement, from the <code>campaign_map_regions</code> database table. If more than one target settlement is desired a @table of region keys can be supplied.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.raze_or_own_settlements(unique_name, faction_key, advice_key, mission_key, region_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_raze_or_own_settlements(unique_name, faction_key, advice_key, mission_key, region_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Control Provinces
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_control_provinces(unique_name, faction_key, advice_key, mission_key, num_provinces, province_keys, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if num_provinces then
		if not validate.is_number(num_provinces) then
			return false;
		end;
	else
		num_provinces = 1;
	end;

	if province_keys and not validate.is_string_or_table_of_strings(province_keys) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("CONTROL_N_PROVINCES_INCLUDING");
		ne:add_condition("total " .. num_provinces);

		if is_string(province_keys) then
			ne:add_condition("province " .. province_keys);
		elseif is_table(province_keys) then
			ne:add_condition("province " .. province_keys[i]);
		end;
		
		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		if scroll_camera_target then
			ne:set_camera_scroll_target_callback(
				function()
					-- If the scroll camera target is a faction key then use its closest settlement as the camera target
					if is_string(scroll_camera_target) and cm:get_faction(scroll_camera_target) then
						local region = cm:get_closest_settlement_from_faction_to_faction(scroll_camera_target, faction_key);
						if region then
							return region:name();
						end;
					end;

					return scroll_camera_target;
				end
			);
		
		elseif province_keys then
			ne:set_camera_scroll_target_callback(
				function()
					narrative.todo_output("construct_narrative_event_control_provinces() should figure out a camera scroll target from its list of provinces");
				end
			);
		else
			narrative.todo_output("construct_narrative_event_control_provinces() should figure out a camera scroll target from settlements the player needs to capture");
		end;

		return ne;
	end;
end;


--- @function control_provinces
--- @desc Creates and starts a narrative event that issues a mission to control a number of provinces. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=1] @number provinces, Target number of provinces to control.
--- @p [opt=nil] @string province key, Key of specific province to control. This may also be a @table of string keys if multiple are desired.
--- @p [opt=nil] value scroll target, Camera scroll target. This can be a @string region key, a @string faction key (region is looked up before faction), or a @number character cqi. If this is supplied the camera will scroll to the specified target when the mission is issued (assuming the narrative event decides to move the camera).
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.control_provinces(unique_name, faction_key, advice_key, mission_key, num_provinces, province_keys, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_control_provinces(unique_name, faction_key, advice_key, mission_key, num_provinces, province_keys, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Enact Commandment
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_enact_commandment(unique_name, faction_key, advice_key, mission_key, num_enactments, commandment_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if num_enactments then
		if not validate.is_positive_number(num_enactments) then
			return false;
		end;
	else
		num_enactments = 1;
	end;

	if commandment_key and not validate.is_string(commandment_key) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("ISSUE_PROVINCE_INITIATIVE");
		ne:add_condition("total " .. num_enactments);
		if commandment_key then
			ne:add_condition("province_initiative " .. commandment_key);
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- Find the closest province capital to the camera that's owned by the player
				local region = cm:get_closest_region_for_faction(
					cm:get_faction(faction_key, true),		-- faction
					nil,									-- x (if omitted then camera pos is used)
					nil,									-- y
					function(region)						-- condition
						return region:is_province_capital() and region:owning_faction():name() == faction_key;
					end
				);

				if not region then
					script_error("WARNING: construct_narrative_event_enact_commandment() could not find a province capital owned by faction [" .. faction_key .. "], how can this be? No camera scroll target will be set");
					return;
				end;

				return region:name();
			end
		);

		return ne;
	end;
end;


--- @function enact_commandment
--- @desc Creates and starts a narrative event that issues a mission to enact one or more commandments. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=1] @number enactments, Target number of commandments to enact.
--- @p [opt=nil] @string commandment key, Key of specific commamdment to enact.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.enact_commandment(unique_name, faction_key, advice_key, mission_key, num_enactments, commandment_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_enact_commandment(unique_name, faction_key, advice_key, mission_key, num_enactments, commandment_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Destroy Faction
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_destroy_faction(unique_name, faction_key, advice_key, mission_key, target_faction_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if is_string(target_faction_keys) then
		target_faction_keys = {target_faction_keys};
	elseif not validate.is_table_of_strings(target_faction_keys) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("DESTROY_FACTION");

		for i = 1, #target_faction_keys do
			ne:add_condition("faction " .. target_faction_keys[i]);
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- If we have just one target faction, then try and return the closest general from it
				if #target_faction_keys == 1 then
					local player_faction = cm:get_faction(faction_key);
					local player_character = player_faction:faction_leader()
					if not player_character:has_military_force() then
						local character_list = faction:character_list()
						for i = 0, character_list:num_items() -1 do
							local secondary_character = character_list:item_at(i)
							if secondary_character:has_military_force() and not secondary_character:military_force():is_armed_citizenry() then
								player_character = secondary_character
								break
							end
						end
					end

					if not player_character:is_wounded() then
						local x, y = cm:char_logical_pos(player_character);
						
						local char = cm:get_closest_general_to_position_from_faction(
							target_faction_keys[1],
							x,
							y,
							true,
							false,
							faction_key
						);

						if char then
							return char:command_queue_index();
						end;
					end;
				end;
			end
		);

		return ne;
	end;
end;


--- @function destroy_faction
--- @desc Creates and starts a narrative event that issues a mission to destroy one or more factions. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string target faction key, Faction key of target faction, from the <code>factions</code> database table. This may also be a table of multiple target faction keys.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.destroy_faction(unique_name, faction_key, advice_key, mission_key, target_faction_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_destroy_faction(unique_name, faction_key, advice_key, mission_key, target_faction_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Recruit Units
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_recruit_units(unique_name, faction_key, advice_key, mission_key, num_units, unit_keys, exclude_existing, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority)
	
	if not validate.is_positive_number(num_units) then
		return false;
	end;

	if unit_keys and not validate.is_string_or_table_of_strings(unit_keys) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("RECRUIT_N_UNITS_FROM");
		ne:add_condition("total " .. num_units);

		if exclude_existing then
			ne:add_condition("exclude_existing true");
		end;

		if unit_keys then
			if is_string(unit_keys) then
				ne:add_condition("unit " .. unit_keys);
			else
				for i = 1, #unit_keys do
					ne:add_condition("unit " .. unit_keys[i]);
				end;
			end;
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- Find the closest province capital to the camera that's owned by the player
				local faction = cm:get_faction(faction_key, true);
				if faction then
					local character = cm:get_closest_character_to_camera_from_faction(faction, true);

					if character then
						return character:command_queue_index();
					end
				end;
			end
		);

		if high_priority then
			ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY);
		end;

		return ne;
	end;
end;


--- @function recruit_units
--- @desc Creates and starts a narrative event that issues a mission to recruit a number of units across all armies. Unit keys may optionally be supplied . Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @number units, Target number of units to recruit.
--- @p [opt=nil] @string unit key, Optional unit key of unit that must be recruited, from the <code>land_units</code> database table. This may also be a @table of string unit keys. If a value is supplied here then recruited units only count towards the total if their unit keys match. If no value is supplied then any unit matches.
--- @p [opt=false] @boolean exclude existing, Excluding pre-existing units from the count.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.recruit_units(unique_name, faction_key, advice_key, mission_key, num_units, unit_keys, exclude_existing, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority)
	local ne = construct_narrative_event_recruit_units(unique_name, faction_key, advice_key, mission_key, num_units, unit_keys, exclude_existing, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority);

	if ne then
		ne:start();
	end;
end;




























-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Construct N of Building Chain
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_construct_n_of_building_chain(unique_name, faction_key, advice_key, mission_key, num_buildings, building_chains, exclude_existing, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_positive_number(num_buildings) then
		return false;
	end;

	if building_chains and not validate.is_string_or_table_of_strings(building_chains) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("CONSTRUCT_N_OF_A_BUILDING_CHAIN");
		ne:add_condition("total " .. num_buildings);

		if building_chains then
			if is_string(building_chains) then
				ne:add_condition("building_chain " .. building_chains);
			else
				for i = 1, #building_chains do
					ne:add_condition("building_chain " .. building_chains[i]);
				end;
			end;
		end;

		if exclude_existing then
			ne:add_condition("exclude_existing true");
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- If the scroll camera target is a faction key then use its closest settlement as the camera target
				if is_string(scroll_camera_target) and cm:get_faction(scroll_camera_target) then
					local region = cm:get_closest_settlement_from_faction_to_faction(scroll_camera_target, faction_key);
					if region then
						return region:name();
					end;
				end;

				return scroll_camera_target;
			end
		);

		return ne;
	end;
end;


--- @function construct_n_of_building_chain
--- @desc Creates and starts a narrative event that issues a mission to construct a number of buildings of zero or more building chains. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @number buildings, Target number of buildings to construct.
--- @p [opt=nil] @string building chain, Key of building chain the building must be a part of, from the <code>building_chains</code> database table. This may also be a @table of string chain keys. If a value is supplied here then the constructed buildings only count towards the total if they belong to a specified chain. If no value is supplied then any constructed building counts towards the total.
--- @p [opt=false] @boolean exclude existing, Excluding pre-existing buildings from the count.
--- @p [opt=nil] value scroll target, Camera scroll target. This can be a @string region key, a @string faction key (region is looked up before faction), or a @number character cqi. If this is supplied the camera will scroll to the specified target when the mission is issued (assuming the narrative event decides to move the camera).
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.construct_n_of_building_chain(unique_name, faction_key, advice_key, mission_key, num_buildings, building_chains, exclude_existing, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_construct_n_of_building_chain(unique_name, faction_key, advice_key, mission_key, num_buildings, building_chains, exclude_existing, scroll_camera_target, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if ne then
		ne:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Construct Building With Condition
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if condition and not validate.is_condition(condition) then
		return false;
	end;

	if not validate.is_string(mission_text) then
		return false;
	end;
	
	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:get_mission_manager():add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"BuildingCompleted",
			function(context)
				if context:building():faction():name() ~= faction_key then
					return false;
				end;

				if is_function(condition) then
					local result, suppress_output = condition(context:building(), ne);
					if not result then
						return false;
					end;

					if not suppress_output then
						ne:out();
						ne:out();
						ne:out("mission completing as faction [" .. faction_key .. "] has constructed building with key [" .. context:building():building_level() .. "] and related query passes");
						return true;
					end;
				else
					ne:out();
					ne:out();
					ne:out("mission completing as faction [" .. faction_key .. "] has constructed building with key [" .. context:building():building_level() .. "]");
				end;

				return true;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function construct_building_with_condition
--- @desc Creates and starts a narrative event that issues a mission that completes when a building is completed by the specified faction, optionally passing a supplied condition function. Advice may optionally be supplied to be issued with the mission.
--- @desc If supplied, the condition function will be passed the building provided by the <code>BuildingCompleted</code> event and the narrative event object as separate arguments. It should return a value that evaluates to a boolean to indicate whether the condition has passed. It can also return <code>true</code> as a second returned value to suppress output from this function. This can be useful if the condition function produces its own output.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key that specifies the objective text, from the <code>mission_texts</code> table.
--- @p [opt=nil] @function condition, Condition function to pass. If no condition function is supplied then the condition always passes.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function construct_buildings_with_condition
--- @desc Creates and starts a narrative event that issues a mission that completes when a building is completed by the specified faction, optionally passing a supplied condition function. The condition function is run on every building in the faction when a building is completed and if the number passing the test is greater than a supplied threshold then the mission is successfully completed. Advice may optionally be supplied to be issued with the mission.
--- @desc If supplied, the condition function will be called for each building in the faction when the <code>BuildingCompleted</code> event is received. When called, it will be passed the building and the narrative event object as separate arguments. It should return a value that evaluates to a boolean to indicate whether the condition has passed. It can also return <code>true</code> as a second returned value to suppress output from this function. This can be useful if the condition function produces its own output.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key that specifies the objective text, from the <code>mission_texts</code> table.
--- @p [opt=nil] @function condition, Condition function to pass. If no condition function is supplied then the condition always passes.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.constructs_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition, count_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne;

	if not validate.is_number(count_threshold) then
		return false;
	end;

	if condition and not validate.is_function(condition) then
		return false;
	end;
	
	if count_threshold == 1 then
		return narrative_events.construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	end;

	local function condition_inner(building, ne)
		local count = 0;

		local faction = building:faction();

		local region_list = faction:region_list();

		for i, region in model_pairs(region_list) do

			local slot_list = region:slot_list();
			for j, slot in model_pairs(slot_list) do
				if slot:has_building() then
					if condition then
						if condition(slot:building(), ne) then
							count = count + 1;
						end;
					else
						count = count + 1;
					end;

					if count >= count_threshold then
						ne:out();
						ne:out();
						ne:out("mission completing as faction [" .. faction_key .. "] has at least [" .. count_threshold .. "] buildings that conform to supplied condition");
						return true;
					end;
				end;
			end;
		end;
	end;

	local ne = construct_narrative_event_construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, mission_text, condition_inner, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;




--- @function construct_technology_enabling_building
--- @desc Creates and starts a narrative event that issues a mission that completes when a building that unlocks technologies is completed by the specified faction, optionally passing a supplied condition function. Advice may optionally be supplied to be issued with the mission.
--- @desc If supplied, the condition function will be passed the building object provided by the <code>BuildingCompleted</code> event and the narrative event object as separate arguments. It should return a value that evaluates to a boolean to indicate whether the condition has passed. It can also return <code>true</code> as a second returned value to suppress output from this function. This can be useful if the condition function produces its own output.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=nil] @function condition, Additional condition function to pass. If a condition is supplied, it will need to be passed in addition to the base "unlocks technologies" requirement.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.construct_technology_enabling_building(unique_name, faction_key, advice_key, mission_key, condition, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local function condition_inner(building, ne)
		if not building:unlocks_technologies() or building:faction():name() ~= faction_key then
			return false;
		end;

		if is_function(condition) then
			local result, suppress_output = condition(building, ne);
			if not result then
				return false;
			end;

			if not suppress_output then
				ne:out();
				ne:out();
				ne:out("mission completing as faction [" .. faction_key .. "] has constructed building with key [" .. building:building_level() .. "] that enables technology, and related query passes");
				return true;
			end;
		else
			ne:out();
			ne:out();
			ne:out("mission completing as faction [" .. faction_key .. "] has constructed building with key [" .. building:building_level() .. "] that enables technology");
		end;

		return true, true;
	end;

	local ne = construct_narrative_event_construct_building_with_condition(unique_name, faction_key, advice_key, mission_key, "wh3_main_narrative_mission_description_construct_technology_enabling_building", condition_inner, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Upgrade Any Settlement
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_upgrade_any_settlement(unique_name, faction_key, advice_key, mission_key, building_level, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if building_level and not validate.is_positive_number(building_level) then
		return false;
	end;
	
	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mission_text_key;

		if building_level then
			mission_text_key = "mission_text_text_wh3_main_narrative_mission_description_upgrade_any_settlement_level_" .. building_level;
		else
			mission_text_key = "mission_text_text_wh3_main_narrative_mission_description_upgrade_any_settlement";
		end;
		
		ne:get_mission_manager():add_new_scripted_objective(
			mission_text_key,
			"BuildingCompleted",
			function(context)
				local building = context:building();
				return building:faction():name() == faction_key and string.find(building:superchain(), "_settlement") and (not building_level or building:building_level() >= building_level);
			end
		);

		-- Add a different success condition to the objective added above
		ne:get_mission_manager():add_scripted_objective_success_condition(
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				if context:character():faction():name() == faction_key then
					local completed_building_key = context:building();
					local completed_building_superchain_key = cm:building_superchain_key_for_building(completed_building_key);
					local completed_building_level = cm:building_level_for_building(completed_building_key);

					if completed_building_superchain_key and completed_building_level then
						return string.find(completed_building_superchain_key, "_settlement") and (not building_level or completed_building_level + 1 >= building_level);
					end;
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				-- If we can get a region name from the triggering object then return that
				if ne.triggering_obj and ne.triggering_obj.data and ne.triggering_obj.data.region_name then
					return ne.triggering_obj.data.region_name;
				end;

				-- Scroll to the nearest settlement to the camera for the faction
				local region = cm:get_closest_settlement_from_faction_to_position(faction_key, cm:log_to_dis(cm:get_camera_position()));
				if region then
					return region:name();
				end
			end
		);

		-- Whitelist growth point event message
		ne:add_intervention_configuration_callback(
			function(inv)
				inv:add_whitelist_event_type("provinces_development_points_availableevent_feed_target_province_faction");
			end
		);

		return ne;
	end;
end;



--- @function upgrade_any_settlement
--- @desc Creates and starts a narrative event that issues a mission to upgrade any settlement. An optional building level that the settlement building must reach may be supplied. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.upgrade_any_settlement(unique_name, faction_key, advice_key, mission_key, building_level, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_upgrade_any_settlement(unique_name, faction_key, advice_key, mission_key, building_level, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Research Technology
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_research_technology(unique_name, faction_key, advice_key, mission_key, num_technologies, mandatory_technologies, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_positive_number(num_technologies) then
		return false;
	end;

	if mandatory_technologies and not validate.is_string_or_table_of_strings(mandatory_technologies) then
		return false;
	end;
		
	
	
	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("RESEARCH_N_TECHS_INCLUDING");
		ne:add_condition("total " .. num_technologies);

		if mandatory_technologies then
			if is_string(mandatory_technologies) then
				ne:add_condition("technology " .. mandatory_technologies);
			else
				for i = 1, #mandatory_technologies do
					ne:add_condition("technology " .. mandatory_technologies[i]);
				end;
			end;
		end;

		if is_additive then
			ne:add_condition("additive true");
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;



--- @function research_technology
--- @desc Creates and starts a narrative event that issues a mission to research one or more technologies. An optional list of technologies that must be included may be supplied. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @number technologies, Number of technologies that must be researched.
--- @p @string mandatory tech, The key of any mandatory technology that must be researched before the mission can be completed. This may be supplied as a @table of strings if multiple are desired.
--- @p [opt=false] @boolean additive, Sets whether pre-existing technologies count towards the total.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.research_technology(unique_name, faction_key, advice_key, mission_key, num_technologies, mandatory_technologies, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_research_technology(unique_name, faction_key, advice_key, mission_key, num_technologies, mandatory_technologies, is_additive, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Gain Income
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_gain_income(unique_name, faction_key, advice_key, mission_key, income, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	
	if not validate.is_number(income) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("INCOME_AT_LEAST_X");
		ne:add_condition("income " .. income);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;



--- @function gain_income
--- @desc Creates and starts a narrative event that issues a mission to gain a certain level of income. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @number income, Income level to be gained.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.gain_income(unique_name, faction_key, advice_key, mission_key, income, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_gain_income(unique_name, faction_key, advice_key, mission_key, income, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Reduce Upkeep
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_reduce_upkeep(unique_name, faction_key, advice_key, mission_key, mission_text, threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if not validate.is_number(threshold) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local full_mission_text = "mission_text_text_" .. mission_text;

		local function check_upkeep(faction)
			local upkeep = faction:upkeep_income_percent();
			ne:get_mission_manager():update_scripted_objective_text(full_mission_text, math.floor(upkeep));
			return upkeep < threshold;
		end;

		local mm = ne:get_mission_manager();
		
		-- set up scripted mission type to check upkeep on turn start, after a battle involving the player, and also when the player disbands a unit
		mm:add_new_scripted_objective(
			full_mission_text,
			"ScriptEventHumanFactionTurnStart",
			function(context) 
				if context:faction():name() == faction_key then
					return check_upkeep(context:faction());
				end;
			end
		);

		-- Add a different success condition to the objective added above
		mm:add_scripted_objective_success_condition(
			"UnitDisbanded",
			function(context)
				if context:unit():faction():name() == faction_key then
					return check_upkeep(context:unit():faction());
				end
			end
		);

		-- Add a different success condition to the objective added above
		mm:add_scripted_objective_success_condition(
			"BattleCompleted", 
			function(context)
				if cm:pending_battle_cache_faction_is_involved(faction_key) then
					local faction = cm:get_faction(faction_key);
					if faction then
						return check_upkeep(faction);
					end;
				end
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;



--- @function reduce_upkeep
--- @desc Creates and starts a narrative event that issues a mission to reduce upkeep. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text key, Key of mission objective text, from the <code>mission_texts</code> database table.
--- @p @number threshold, Threshold percentage of upkeep-expenditure to income which the player must reach to succeed the mission.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.reduce_upkeep(unique_name, faction_key, advice_key, mission_key, mission_text, threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_reduce_upkeep(unique_name, faction_key, advice_key, mission_key, mission_text, threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Recruit Any Hero
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_recruit_any_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("RECRUIT_AGENT");
		ne:add_condition("total 1");

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				local region = cm:get_closest_settlement_from_faction_to_camera(faction_key);

				if region then
					return region:name();
				end;
			end
		);

		return ne;
	end;
end;



--- @function recruit_any_hero
--- @desc Creates and starts a narrative event that issues a mission to recruit any hero. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.recruit_any_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_recruit_any_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Use Hero
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_use_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("PERFORM_ANY_AGENT_ACTION");

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		ne:set_camera_scroll_target_callback(
			function()
				local char = cm:get_closest_hero_to_camera_from_faction(faction_key);

				if char then
					return char:command_queue_index();
				end;
			end
		);

		return ne;
	end;
end;



--- @function use_hero
--- @desc Creates and starts a narrative event that issues a mission to use any hero against the enemy. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.use_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_use_hero(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Win Battles With Character (Hero currently, could expand to other types)
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_win_battles_with_hero(unique_name, faction_key, advice_key, mission_key, win_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_positive_number(win_threshold) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local full_mission_text = "mission_text_text_wh3_main_narrative_mission_description_win_ten_battles_with_any_hero";

		local hero_types_lookup = cm:get_all_agent_types_lookup();

		-- Setup check for all characters in a military force, by military force cqi
		local function military_force_check(mf)
			local most_battles_won = 0;
			if mf then
				local char_list = mf:character_list();
				for _, char in model_pairs(char_list) do
					-- Take local references to make it easier to debug this !
					local char_type = char:character_type_key();
					local battles_won = char:battles_won();

					if hero_types_lookup[char_type] then
						if battles_won > most_battles_won then
							most_battles_won = battles_won;
						end;
						
						if battles_won >= win_threshold then
							return true, most_battles_won;
						end;
					end;
				end;
			end;
			return false, most_battles_won;
		end;

		local mm = ne:get_mission_manager();

		mm:add_new_scripted_objective(
			full_mission_text,
			"BattleCompleted",
			function(context)
				local pb = context:model():pending_battle();
				local most_battles_won = 0;
				local update_text = false;

				-- Check attackers in battle
				if pb:attacker_won() then
					for i = 1, cm:pending_battle_cache_num_attackers() do
						local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
						if current_faction_name == faction_key then
							local threshold_reached, battles_won = military_force_check(cm:get_military_force_by_cqi(current_mf_cqi));

							if threshold_reached then
								mm:update_scripted_objective_text(full_mission_text, battles_won);
								return true;
							elseif battles_won > most_battles_won then
								update_text = true;
								most_battles_won = battles_won;
							end;
						end;
					end;
				end;

				-- Check defenders in battle
				if pb:defender_won() then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
						if current_faction_name == faction_key then
							local threshold_reached, battles_won = military_force_check(cm:get_military_force_by_cqi(current_mf_cqi));

							if threshold_reached then
								mm:update_scripted_objective_text(full_mission_text, battles_won);
								return true;
							elseif battles_won > most_battles_won then
								update_text = true;
								most_battles_won = battles_won;
							end;
						end;
					end;
				end;

				if update_text then
					mm:update_scripted_objective_text(full_mission_text, most_battles_won);
				end;
				return false;
			end
		);

		mm:add_each_time_trigger_callback(
			function()
				local most_battles_won = 0;

				local faction = cm:get_faction(faction_key);
				local mf_list = faction:military_force_list();

				for _, mf in model_pairs(mf_list) do
					if not mf:is_armed_citizenry() then
						local threshold_reached, battles_won = military_force_check(mf);

						if threshold_reached then
							mm:update_scripted_objective_text(full_mission_text, battles_won);
							mm:force_scripted_objective_success();
							return;
						elseif battles_won > most_battles_won then
							most_battles_won = battles_won;
						end;
					end;
				end;

				mm:update_scripted_objective_text(full_mission_text, most_battles_won);
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function win_battles_with_hero
--- @desc Creates and starts a narrative event that issues a mission to win a supplied number of battles with any hero. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @number win threshold, Number of victories to attain.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.win_battles_with_hero(unique_name, faction_key, advice_key, mission_key, win_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_win_battles_with_hero(unique_name, faction_key, advice_key, mission_key, win_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Win Set Piece/Quest Battle
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_win_set_piece_battle(unique_name, faction_key, advice_key, mission_key, battle_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(battle_key) then
		return false;
	end;

	if text_display and not validate.is_string(text_display) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("FIGHT_SET_PIECE_BATTLE");

		ne:add_condition("set_piece_battle " .. battle_key);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function win_set_piece_battle
--- @desc Creates and starts a narrative event that issues a mission to win a set piece/quest battle. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string battle key, Key of set piece battle, from the <code>battles</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.win_set_piece_battle(unique_name, faction_key, advice_key, mission_key, battle_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_win_set_piece_battle(unique_name, faction_key, advice_key, mission_key, battle_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Perform Ritual
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_perform_ritual(unique_name, faction_key, advice_key, mission_key, total, ritual_key, ritual_category_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if ritual_key and not validate.is_string(ritual_key) then
		return false;
	end;

	if ritual_category_key then
		if not validate.is_string(ritual_category_key) then
			return false;
		end;

		if ritual_key then
			script_error("WARNING: construct_narrative_event_perform_ritual() called with supplied ritual key [" .. ritual_key .. "] and ritual category key [" .. ritual_category_key .. "] - you can only have both with a scripted ritual mission. Will disregard ritual.");
			ritual_key = nil;
		end;
	end;

	if total then
		if not validate.is_positive_number(total) then
			return false;
		end;

		if total > 1 then
			if ritual_key then
				script_error("WARNING: construct_narrative_event_perform_ritual() called with supplied ritual key [" .. ritual_key .. "] and total [" .. total .. "] which is greater than one - you can only have both with a scripted ritual mission. Will disregard ritual.");
				ritual_key = nil;
			end;
		end;
	else
		total = 1;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		ne:add_new_objective("PERFORM_RITUAL");
		ne:add_condition("total " .. total);
		if ritual_key then
			ne:add_condition("ritual " .. ritual_key);
		end;
		if ritual_category_key then
			ne:add_condition("ritual_category " .. ritual_key);
		end;

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function perform_ritual
--- @desc Creates and starts a narrative event that issues a mission to perform one or more rituals. Advice may optionally be supplied to be issued with the mission.
--- @desc An optional total number of rituals may be specified, or a ritual key or a ritual category. If a total number greater than one is specified then the ritual key is disregarded. See @narrative_events:perform_ritual_scripted for a version of this function that triggers a scripted mission
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=1] @number num rituals, Number of rituals to enact. If a value other than <code>1</code> is specified then any ritual key is disregarded.
--- @p [opt=nil] @string ritual key, Key of ritual to enact, from the <code>rituals</code> database table. If no ritual is specified then any ritual counts. This is disregarded if the total is greater than one.
--- @p [opt=nil] @string ritual category key, Category key of ritual to enact, from the <code>ritual_categories</code> database table. If no ritual category is specified then any ritual counts.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.perform_ritual(unique_name, faction_key, advice_key, mission_key, total, ritual_key, ritual_category_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_ritual(unique_name, faction_key, advice_key, mission_key, total, ritual_key, ritual_category_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Perform Ritual Scripted
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_perform_ritual_scripted(unique_name, faction_key, advice_key, mission_key, mission_text, total, ritual_keys, ritual_category_keys, target_faction_keys, listen_for_ritual_completed, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if total then
		if not validate.is_positive_number(total) then
			return false;
		end;
	else
		total = 1;	
	end;

	if ritual_keys then
		if not validate.is_string_or_table_of_strings(ritual_keys) then
			return false;
		end;

		if is_string(ritual_keys) then
			ritual_keys = {ritual_keys};
		end;
	end;

	if ritual_category_keys then
		if not validate.is_string_or_table_of_strings(ritual_category_keys) then
			return false;
		end;

		if is_string(ritual_category_keys) then
			ritual_category_keys = {ritual_category_keys};
		end;
	end;

	if target_faction_keys then
		if not validate.is_string_or_table_of_strings(target_faction_keys) then
			return false;
		end;
	else
		if is_string(target_faction_keys) then
			target_faction_keys = {target_faction_keys};
		end;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local full_mission_text = "mission_text_text_" .. mission_text;
		local mm = ne:get_mission_manager();
		
		-- set up scripted mission type
		mm:add_new_scripted_objective(
			full_mission_text,
			(listen_for_ritual_completed and "RitualCompletedEvent" or "RitualStartedEvent"),
			function(context)
				if context:performing_faction():name() == faction_key then
					local ritual = context:ritual();

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

					-- We have a match - increment total, or return true
					if total == 1 then
						return true;
					end;

					local current_total = cm:get_saved_value(unique_name .. "_count") or 0;
					current_total = current_total + 1;

					mm:update_scripted_objective_text(full_mission_text, current_total);

					if current_total >= total then
						return true;
					end;

					cm:set_saved_value(unique_name .. "_count", current_total);
				end;
			end
		);

		mm:add_each_time_trigger_callback(
			function()
				if total > 1 then
					mm:update_scripted_objective_text(full_mission_text, cm:get_saved_value(unique_name .. "_count") or 0);
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function perform_ritual_scripted
--- @desc Creates and starts a narrative event that issues a mission to perform one or more rituals. Advice may optionally be supplied to be issued with the mission.
--- @desc An optional total number of rituals may be specified, and zero or more ritual keys, ritual categories and target faction keys. As this is a scripted mission, a mission text key must be specified also.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=1] @number num rituals, Number of rituals to enact.
--- @p [opt=nil] @string ritual keys, Key(s) of ritual(s) to enact, from the <code>rituals</code> database table. This can be a @string ritual key or a @table of strings. If no ritual keys are specified then any rituals match.
--- @p [opt=nil] @string ritual categories, Key(s) of ritual category/categories to enact, from the <code>ritual_categories</code> database table. This can be a @string category key or a @table of strings. If no categories are specified then any rituals match.
--- @p [opt=nil] @string target faction keys, Key(s) of any target factions, from the <code>factions</code> database table. This can be a @string faction key or a @table of strings. If no target factions are specified then any targets match.
--- @p [opt=false] @boolean listen for completion, Listen for the ritual being completed, rather than the ritual being started.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.perform_ritual_scripted(unique_name, faction_key, advice_key, mission_key, mission_text, total, ritual_keys, ritual_category_keys, target_faction_keys, listen_for_ritual_completed, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_ritual_scripted(
		unique_name,
		faction_key,
		advice_key,
		mission_key,
		mission_text,
		total,
		ritual_keys,
		ritual_category_keys,
		target_faction_keys,
		listen_for_ritual_completed,
		mission_issuer,
		mission_rewards,
		trigger_messages,
		on_issued_messages,
		on_completed_messages,
		inherit_list
	);

	if ne then
		ne:start();
	end;
end;


--- @function perform_motherland_ritual
--- @desc Creates and starts a narrative event that issues a mission to perform a kislev motherland ritual. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.perform_motherland_ritual(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_ritual_scripted(
		unique_name,
		faction_key,
		advice_key,
		mission_key,
		"wh3_main_narrative_mission_description_kislev_motherland",									-- objective key
		1,																							-- num rituals
		nil,																						-- ritual key(s)
		"MOTHERLAND_RITUAL", 																		-- ritual categories
		nil, 																						-- target factions
		false,																						-- listen for ritual completed instead of ritual started
		mission_issuer,
		mission_rewards,
		trigger_messages,
		on_issued_messages,
		on_completed_messages,
		inherit_list
	);

	if ne then
		ne:start();
	end;
end;


--- @function perform_ascension
--- @desc Creates and starts a narrative event that issues a mission to perform a daemon prince ascension. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.perform_ascension(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_ritual_scripted(
		unique_name,
		faction_key,
		advice_key,
		mission_key,
		"wh3_main_narrative_mission_description_ascend",											-- objective key
		1,																							-- num rituals
		{																							-- ritual key(s)
			"wh3_main_ritual_dae_ascend_khorne",
			"wh3_main_ritual_dae_ascend_nurgle",
			"wh3_main_ritual_dae_ascend_slaanesh",
			"wh3_main_ritual_dae_ascend_tzeentch",
			"wh3_main_ritual_dae_ascend_undivided"
		},								
		nil, 																						-- ritual categories
		nil, 																						-- target factions
		false,																						-- listen for ritual completed instead of ritual started
		mission_issuer,
		mission_rewards,
		trigger_messages,
		on_issued_messages,
		on_completed_messages,
		inherit_list
	);

	if ne then
		ne:start();
	end;
end;


--- @function concoct_plague
--- @desc Creates and starts a narrative event that issues a mission to concoct a Nurgle plague. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt=1] @number quantity, Quantity of plagues to to concoct.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.concoct_plague(unique_name, faction_key, advice_key, mission_key, num_plagues, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_ritual_scripted(
		unique_name,
		faction_key,
		advice_key,
		mission_key,
		"wh3_main_narrative_mission_description_concoct_plague",									-- objective key
		num_plagues,																				-- num rituals
		nil,																						-- ritual key(s)								
		"NURGLE_RITUAL", 																			-- ritual categories
		nil, 																						-- target factions
		true,																						-- listen for ritual completed instead of ritual started
		mission_issuer,
		mission_rewards,
		trigger_messages,
		on_issued_messages,
		on_completed_messages,
		inherit_list
	);

	if ne then
		ne:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Spread Corruption to Adjacent Region
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_spread_corruption_to_adjacent_region(unique_name, faction_key, advice_key, mission_key, corruption_key, threshold_value, culture_to_exclude, mission_text, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if not validate.is_string(corruption_key) then
		return false;
	end;

	if not validate.is_positive_number(threshold_value) then
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

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();

		local full_mission_text = "mission_text_text_" .. mission_text;


		local function spread_corruption_faction_check(faction)
			local highest_corruption = 0;
			local threshold_met = false;
			local region_list_table = cm:get_regions_adjacent_to_faction(faction, culture_condition);

			for i = 1, #region_list_table do
				local region_name = region_list_table[i]:name();
				local resource = region_list_table[i]:province():pooled_resource_manager():resource(corruption_key);

				local corruption_value = resource:value();

				if corruption_value > highest_corruption then
					highest_corruption = corruption_value;
				end;

				if not resource:is_null_interface() and corruption_value >= threshold_value then
					threshold_met = true;
					break;
				end;
			end;

			mm:update_scripted_objective_text(full_mission_text, highest_corruption);
			return threshold_met;
		end;

		
		mm:add_new_scripted_objective(
			full_mission_text,
			"FactionTurnStart",
			function(context) 
				if context:faction():name() == faction_key then
					return spread_corruption_faction_check(context:faction());
				end;
			end
		);

		mm:add_each_time_trigger_callback(
			function()
				local faction = cm:get_faction(faction_key);
				if faction and spread_corruption_faction_check(faction) then
					mm:force_scripted_objective_success();
				end;
			end
		)

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function spread_corruption_to_adjacent_region
--- @desc Creates and starts a narrative event that issues a mission to construct a foreign slot. It must be specified whether foreign slot is allied to the settlement owner or not. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string corruption type, Corruption type, from the <code>pooled_resources</code> database table.
--- @p @number threshold value, Threshold value which the corruption must meet or exceed in an adjacent region for the mission to be completed.
--- @p [opt=nil] @string culture key, Culture key of region owner to exclude. If an eligible region has a faction owner with this culture, the region will not be included.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.spread_corruption_to_adjacent_region(unique_name, faction_key, advice_key, mission_key, corruption_key, threshold_value, culture_to_exclude, mission_text, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_spread_corruption_to_adjacent_region(unique_name, faction_key, advice_key, mission_key, corruption_key, threshold_value, culture_to_exclude, mission_text, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Construct Foreign Building
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_construct_foreign_slot(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	should_be_allied = not not should_be_allied;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		
		mm:add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"ForeignSlotManagerCreatedEvent",
			function(context) 
				return should_be_allied == context:is_allied() and context:requesting_faction():name() == faction_key;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function construct_foreign_slot
--- @desc Creates and starts a narrative event that issues a mission to construct a foreign slot. It must be specified whether foreign slot is allied to the settlement owner or not. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=false] @boolean should be allied, Should the foreign slot be allied to the owner of the settlement in which it's created to count towards this mission.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.construct_foreign_slot(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_construct_foreign_slot(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Construct Foreign Building
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_construct_foreign_slot_building(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if not validate.is_boolean_or_nil(should_be_allied) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		
		mm:add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"ForeignSlotBuildingCompleteEvent",
			function(context) 
				if context:slot_manager():faction():name() == faction_key then
					if is_boolean(should_be_allied) then
						if cm:is_foreign_slot_manager_allied(context:slot_manager()) ~= should_be_allied then
							return false;
						end;
					end;

					return true;
				end;
			end
		);

		ne:set_camera_scroll_target_callback(
			function()
				local fsm = cm:get_closest_foreign_slot_manager_from_faction_to_faction(faction_key, faction_key);

				if fsm then
					return fsm:region():name();
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function construct_foreign_slot_building
--- @desc Creates and starts a narrative event that issues a mission to construct any building in any foreign slot. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=nil] @boolean should be allied, Should the building be constructed in an allied foreign slot. If <code>false</code> is supplied, the building should be constructed in a non-allied foreign slot. If @nil is supplied, a building constructed in any foreign slot will count.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.construct_foreign_slot_building(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_construct_foreign_slot_building(unique_name, faction_key, advice_key, mission_key, mission_text, should_be_allied, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;



















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Equip Armory Item
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_equip_armory_item(unique_name, faction_key, advice_key, mission_key, mission_text, item_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if item_keys then
		if is_string(item_keys) then
			item_keys = {item_keys};
		elseif not validate.is_table_of_strings(item_keys) then
			return false;
		end;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		
		mm:add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"CharacterArmoryItemEquipped",
			function(context) 
				if context:character():faction():name() == faction_key then
					if not item_keys then
						return true;
					end;

					local item_key = context:item_variant_key();

					for i = 1, #item_keys do
						if item_keys[i] == item_key then
							return true;
						end;
					end;
				end;
			end
		);

		ne:set_camera_scroll_target_callback(
			function()
				local character = cm:get_closest_character_to_camera_from_faction(faction_key, true);
				if character then
					return character:command_queue_index();
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function equip_armory_item
--- @desc Creates and starts a narrative event that issues a mission to equip an armory item. An optional armory item (or list of armory items) may be supplied, which the equipped armory item must match for the mission to succeed. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=nil] @string item key, The key of an armory item, from the <code>armory_items</code> database table, that the equipped item must match. This may also be a @table of item keys. If @nil is supplied then any item equipped by a character in the subject faction will match.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.equip_armory_item(unique_name, faction_key, advice_key, mission_key, mission_text, item_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_equip_armory_item(unique_name, faction_key, advice_key, mission_key, mission_text, item_keys, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function equip_any_daemonic_gift
--- @desc Creates and starts a narrative event that issues a mission to equip any daemonic gift armory item. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.equip_any_daemonic_gift(unique_name, faction_key, advice_key, mission_key, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_equip_armory_item(unique_name, faction_key, advice_key, mission_key, "wh3_main_narrative_mission_description_equip_any_daemonic_gift", nil, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;




















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Character Action
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_event_perform_character_action(unique_name, faction_key, advice_key, mission_key, mission_text, abilities, target_faction_keys, character_subtypes, must_be_success, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

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

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		
		if mm then 
			mm:add_new_scripted_objective(
				"mission_text_text_" .. mission_text,
				"CharacterCharacterTargetAction",
				function(context) 
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
				end
			);

			ne:set_camera_scroll_target_callback(
				function()
					local character = cm:get_closest_character_from_filter_to_camera_from_faction(
						faction_key, 
						function(char)
							if character_subtypes then
								local subtype = char:character_subtype_key();
								for i = 1, #character_subtypes do
									if character_subtypes[i] == subtype then
										return true;
									end;
								end;
							else
								return cm:char_is_agent(char);
							end;
						end
					);
					if character then
						return character:command_queue_index();
					end;
				end
			);

			-- set up mission rewards
			add_narrative_event_mission_rewards(ne, mission_rewards);

			return ne;
		end
	end;
end;


--- @function perform_character_action
--- @desc Creates and starts a narrative event that issues a mission for a character in the specified faction to perform a character/hero action. Optional lists of qualifying abilities, target factions and/or performing character subtypes may be supplied which the ability performed must match. It may also be specified that the action must have been successful. As with other narrative events, advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=nil] @string ability key, The key of the ability to perform, from the <code>abilities</code> database table. This may also be a @table of ability keys. If @nil is supplied then any ability performed will match.
--- @p [opt=nil] @string target faction key, The key of the target faction, from the <code>factions</code> database table. This may also be a @table of faction keys. If @nil is supplied then any faction target will match.
--- @p [opt=nil] @string character subtype, The subtype key of the performing character, from the <code>agent_subtypes</code> database table. This may also be a @table of character subtype keys. If @nil is supplied then any performing character will match.
--- @p [opt=false] @boolean must be success, If set to <code>true</code> this specifies that the action performed must have had a successful outcome.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.perform_character_action(unique_name, faction_key, advice_key, mission_key, mission_text, abilities, target_faction_keys, character_subtypes, must_be_success, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_perform_character_action(unique_name, faction_key, advice_key, mission_key, mission_text, abilities, target_faction_keys, character_subtypes, must_be_success, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;


--- @function embed_agent
--- @desc Creates and starts a narrative event that issues a mission for a character in the specified faction to embed a hero in an army. An optional list of hero character subtypes may be supplied, which specify eligible hero types to embed. It may also be specified that the action must have been successful. As with other narrative events, advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=nil] @string character subtype, The subtype key of the performing character, from the <code>agent_subtypes</code> database table. This may also be a @table of character subtype keys. If @nil is supplied then any performing character will match.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.embed_agent(unique_name, faction_key, advice_key, mission_key, mission_text, character_subtypes, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority)
	local ne = construct_narrative_event_perform_character_action(unique_name, faction_key, advice_key, mission_key, mission_text, "assist_army", nil, character_subtypes, false, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, high_priority);

	if ne then
		if high_priority then
			ne:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY);
			ne:set_priority(5);
		end;	

		ne:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Spread Plagues
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_spread_plagues(unique_name, faction_key, advice_key, mission_key, mission_text, spreads_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if spreads_threshold then
		if not validate.is_positive_number(spreads_threshold) then
			return false;
		end;
	else
		spreads_threshold = 1;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		local full_mission_text = "mission_text_text_" .. mission_text;
		
		mm:add_new_scripted_objective(
			full_mission_text,
			"ScriptEventPlagueSpreading",
			function(context)
				if context:faction():name() == faction_key then
					mm:update_scripted_objective_text(full_mission_text, 1);
					return true
				end;
			end
		);

		mm:add_first_time_trigger_callback(
			function()
				-- TODO: this script should work out what the counter should start at
				mm:update_scripted_objective_text(full_mission_text, 0);
			end
		)

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function spread_plagues
--- @desc Creates and starts a narrative event that issues a mission to spread a number of Nurgle plagues. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=nil] @string item key, The key of an armory item, from the <code>armory_items</code> database table, that the equipped item must match. This may also be a @table of item keys. If @nil is supplied then any item equipped by a character in the subject faction will match.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.spread_plagues(unique_name, faction_key, advice_key, mission_key, mission_text, spreads_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_spread_plagues(unique_name, faction_key, advice_key, mission_key, mission_text, spreads_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Unlock Nurgle Symptoms
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_unlock_symptoms(unique_name, faction_key, advice_key, mission_key, mission_text, symptoms_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if symptoms_threshold then
		if not validate.is_positive_number(symptoms_threshold) then
			return false;
		end;
	else
		symptoms_threshold = 1;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		local full_mission_text = "mission_text_text_" .. mission_text;


		local function symptoms_check()
			local symptoms_unlocked = cm:get_saved_value("plague_symptoms_unlocked_" .. faction_key) or 0;
			mm:update_scripted_objective_text(full_mission_text, symptoms_unlocked);
			return symptoms_unlocked >= symptoms_threshold;
		end;

		
		mm:add_new_scripted_objective(
			full_mission_text,
			"ScriptEventPlagueSymptomUnlocked",
			function(context) 
				return symptoms_check();
			end
		);

		mm:add_each_time_trigger_callback(
			function()
				if symptoms_check() then
					mm:force_scripted_objective_success();
				end;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function unlock_symptoms
--- @desc Creates and starts a narrative event that issues a mission to unlock a number of Nurgle plague symptoms. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=1] @number num symptoms, The number of symptoms that must be unlocked for the mission to be succeeded.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.unlock_symptoms(unique_name, faction_key, advice_key, mission_key, mission_text, symptoms_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_unlock_symptoms(unique_name, faction_key, advice_key, mission_key, mission_text, symptoms_threshold, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Enter Stance
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_enter_stance(unique_name, faction_key, advice_key, mission_key, mission_text, stance_number, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)

	if not validate.is_string(mission_text) then
		return false;
	end;

	if not validate.is_positive_number(stance_number) then
		return false;
	end;

	local ne = construct_narrative_event_with_mission(unique_name, faction_key, advice_key, mission_key, mission_issuer, trigger_messages, on_issued_messages, on_completed_messages, inherit_list, force_advice);

	if ne then
		local mm = ne:get_mission_manager();
		
		mm:add_new_scripted_objective(
			"mission_text_text_" .. mission_text,
			"ForceAdoptsStance",
			function(context) 
				local mf = context:military_force();
				return mf:stance_adopted() == stance_number and mf:faction():name() == faction_key;
			end
		);

		-- set up mission rewards
		add_narrative_event_mission_rewards(ne, mission_rewards);

		return ne;
	end;
end;


--- @function enter_stance
--- @desc Creates and starts a narrative event that issues a mission to enter a particular military force stance. Advice may optionally be supplied to be issued with the mission.
--- @p @string unique name, Unique name amongst other declared narrative events.
--- @p @string faction key, Key of the faction to which this narrative event applies, from the <code>factions</code> database table.
--- @p [opt=nil] @string advice key, Key of advice to issue with this mission, if any, from the <code>advice_threads</code> database table.
--- @p @string mission key, Key of mission to issue, from the <code>missions</code> database table.
--- @p @string mission text, Key of mission text to display, from the <code>mission_text</code> database table. This must be set up for scripted missions such as this.
--- @p [opt=1] @number stance number, Stance number, as returned by the <code>stance_adopted()</code> method provided by the <code>ForceAdoptsStance</code> event.
--- @p [opt="clan_elders"] @string mission issuer, Key of mission issuer, from the <code>mission_issuers</code> database table.
--- @p @table mission rewards, Rewards to add to the mission. This should be a table of strings. See the documentation for @mission_manager:add_payload for more information on the string formatting and available options.
--- @p @string trigger message, Script message on which the narrative event should trigger. This can also be a @table of strings if multiple trigger messages are desired.
--- @p [opt=nil] @string on-issued message, Message to trigger when the narrative event has finished issuing. This can be a @table of strings if multiple on-issued messages are desired.
--- @p [opt=nil] @string on-completed message, Message to trigger when the mission has completed. This can be a @table of strings if multiple on-completed messages are desired.
--- @p [opt=nil] @table inherit list, Table of string names of other narrative events to inherit the rewards from. If this narrative event triggers before another that it's set to inherit from, this narrative event will add the mission rewards from the other to its own mission rewards, and prevent the other narrative event from triggering.
function narrative_events.enter_stance(unique_name, faction_key, advice_key, mission_key, mission_text, stance_number, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list)
	local ne = construct_narrative_event_enter_stance(unique_name, faction_key, advice_key, mission_key, mission_text, stance_number, mission_issuer, mission_rewards, trigger_messages, on_issued_messages, on_completed_messages, inherit_list);

	if ne then
		ne:start();
	end;
end;