

__narrative_system_debug = true;


-- Function that returns a name and full name from a user-supplied name
function assemble_narrative_name(class, name, faction_key)
	local name_internal = "[" .. class .. "]" .. name;
	return name_internal, name_internal .. "(" .. faction_key .. ")"
end;


-- Function to trigger a single narrative message. Ideally client script would call trigger_narrative_script_message() which would in turn call this.
-- This is a good place to put a breakpoint.
local function trigger_narrative_script_message_single(narrative_obj, message)
	sm:trigger_message(message, {faction_key = narrative_obj.faction_key, triggering_obj = narrative_obj});
end;


-- Function used by narrative events/triggers/queries to trigger messages, automatically adding the faction key
local function trigger_narrative_script_message(narrative_obj, messages)
	local faction_key = narrative_obj.faction_key;
	out.inc_tab("narrative");
	if is_string(messages) then
		trigger_narrative_script_message_single(narrative_obj, messages);
	elseif is_table(messages) then
		for i = 1, #messages do
			trigger_narrative_script_message_single(narrative_obj, messages[i]);
		end;
	end;
	out.dec_tab("narrative");
end;




----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- NARRATIVE EVENTS
--
--- @set_environment campaign
--
--- @c narrative_event Narrative Events
--
--- @desc For an overview of the narrative events system see the @narrative topic page.
--- @desc Narrative events package a mission with some advice or narrative content, wrapped in an @intervention. They are designed to aid the creation of early-game missions, which commonly have to show a mission with some advice and occasionally a camera movement. They can also be used as a container to deliver other content like cutscenes, fullscreen movies etc.
--- @desc Once created, a narrative event may be associated with one or more a number of trigger messages that determine when it should trigger. See the @"narrative_event:Trigger Conditions" section for more information. Preconditions may be also be set which the narrative event must pass before it can trigger - see @"narrative_event:Preconditions". Preconditions can fire script messages when they fail.
--- @desc On-issued and on-mission-completed script messages may be specified - see the @"narrative_event:Scripted Messages" section. Script messages may be triggered when a) the narrative event object triggers its mission/advice and b) when the mission is completed. The intention is that these may be listened for by other narrative objects, so that the completion or triggering of one leads to the triggering of another.
--- @desc Once set up, the listeners associated with a narrative event must be started with @narrative_event:start.
--- @desc By default, narrative events will attempt to reduce the intrusiveness of advice, including not delivering the advice at all, if it's detected that the advice has been delivered before. This typically occurs when the player is experiencing the same narrative event on subsequent campaign playthroughs. See the @"narrative_event:Narrative Event Categories" section for more information.
--- @desc Narrative events may be declared and supported in multiplayer mode, but their content delivery will not be wrapped in an @intervention and no advice will be shown.
--- @desc Narrative events output diagnostic information on the <code>Lua - Narrative</code> console spool.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


-- Playback modes, for internal use.
NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY = 0;
NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT = 1;
NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT = 2;


-- Valid narrative event categories
NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY = 0;
NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY = 1;
NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION = 2;
NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED = 3;

local narrative_event_valid_categories = {
	NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY,
	NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY,
	NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION,
	NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED
};


narrative_event = {
	name = false,													-- String name for this narrative event object, must be unique amongst narrative events (once concatenated with the supplied faction key)
	faction_key = false,											-- String faction key to which this narrative event applies
	advice_key = false,												-- Key of advice to play. May be nil.
	infotext = false,												-- Table of infotext to show with advice, may be empty or nil
	mm = false,														-- Mission manager - this is only created if a mission key is supplied in the constructor
	forced_priority = false,										-- Forced priority for the narrative event intervention, if one is created - this affects what order interventions eligible at that time are triggered in. If no priority is forced then one is deduced from the category.
	category = NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED,				-- Category for this narrative event
	running = false,												-- Are the narrative event listeners active right now
	force_no_intervention = false,									-- Forces this narrative event to trigger without an intervention. If any advice is registered with the narrative event it won't be shown
	camera_scroll_target_callback = false,							-- Callback which generates a target to scroll the camera to at runtime. The target can be returned as a string region key (in which case the
	payload_inherited = false,										-- Has the mission payload from this narrative event been inherited?
	trigger_callback = false,										-- Trigger callback to call when the narrative event triggers. This can be used to trigger actions to happen as the mission is issued, or something other than a mission entirely.
																	-- camera will scroll to the settlement), a number char cqi or a table of co-ords in the form {x, y}
	--[[
	messages_on_issued = {},										-- Script messages(s) to fire when the narrative event has issued - other scripts can listen for this/these if they want to trigger afterwards
	messages_on_mission_completed = {},								-- Script messages(s) to fire when the mission is succeeded, failed or cancelled. These messages are not triggered if no mission is set up
	trigger_conditions = {},										-- Table of trigger conditions to start the narrative event
	preconditions = {},												-- Table of precondition function the narrative event must meet before any trigger condition monitors are started
	advice_preconditions = {},										-- Table of preconditions functions that are called when the narrative event triggers. If any return false, then no advice is delivered - only
																	-- The mission is issued and/or trigger callback called
	narrative_event_payload_inheritance = {},						-- List of narrative events that this narrative event should inherit the payload from. 
																	-- If this narrative event starts and any of those narrative events have not, then their
																	-- payload mission rewards will be added to this narrative event's and the payload_inherited
																	-- flag will be set on them
	intervention_configuration_callbacks = {}						-- List of external callbacks to call with which to configure the internally-created intervention. The intervention will be passed to each as a single arg.
	]]
};


set_class_custom_type(narrative_event, TYPE_CAMPAIGN_NARRATIVE_EVENT);
set_class_tostring(
	narrative_event, 
	function(obj)
		return TYPE_CAMPAIGN_NARRATIVE_EVENT .. "_" .. obj.name
	end
);










----------------------------------------------------------------------------
--- @section Creation
--- @desc Narrative events create persistent @mission_manager objects internally. Due to this, narrative events need to be created before the first tick occurs - see the section in the mission manager documentation on @mission_manager:Persistence for more information.
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a narrative event object. An advice key, infotext, and mission key may optionally be specified. Alternatively, narrative elements (e.g. cutscenes, event messages) can be triggered by adding them as an on-trigger callback using @narrative_event:set_trigger_callback.
--- @p @string name, Unique name amongst narrative event objects.
--- @p @string faction key, Key of faction, from the <code>factions</code> database table, to issue the content to.
--- @p [opt=nil] @string advice key, Advice key to play with content, from the <code>advice_threads</code> table.
--- @p [opt=nil] @table infotext, Infotext to issue with advice. This should be a table of strings, each specifying a record from the <code>advice_info_texts</code> table.
--- @p [opt=nil] @string mission key, Key of mission record from <code>missions</code> table to issue.
--- @p [opt=nil] @string completion message, Script message to trigger when the supplied mission is completed. This can also be a @table of strings if multiple completion messages are desired.
--- @p [opt=false] @boolean suppress completion event, Suppress mission completion event messages when this mission completes. This is experimental functionality.
--- @r @narrative_event narrative event
function narrative_event:new(name, faction_key, advice_key, infotext, mission_key, messages_on_mission_completed, suppress_mission_complete_event_msg)

	-- arg checks
	if not is_string(name) then
		script_error("ERROR: narrative_event:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(faction_key) then
		script_error("ERROR: narrative_event:new() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	if advice_key and not is_string(advice_key) then
		script_error("ERROR: narrative_event:new() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;	

	if infotext then
		if not is_table(infotext) then
			script_error("ERROR: narrative_event:new() called but supplied infotext [" .. tostring(infotext) .. "] is not a table");
			return false;
		end;

		for i = 1, #infotext do
			if not is_string(infotext[i]) then
				script_error("ERROR: narrative_event:new() called but element " .. i .. " of supplied infotext table is not a string, it's value is [" .. tostring(infotext[i]) .. "]");
				return false;
			end;
		end;
	else
		infotext = {};
	end;

	if mission_key and not is_string(mission_key) then
		script_error("ERROR: narrative_event:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string or nil");
		return false;
	end;

	if messages_on_mission_completed then
		if is_string(messages_on_mission_completed) then
			messages_on_mission_completed = {messages_on_mission_completed};
		elseif not validate.is_table_of_strings(messages_on_mission_completed) then
			return false;
		end;
	end;

	if messages_on_mission_completed and not mission_key then
		script_error("WARNING: narrative_event:new() called with message(s) on mission completion specified, but no mission key has been supplied - these messages will never be triggered");
		return false;
	end;

	local ne = {};
	
	ne.name, ne.full_name = assemble_narrative_name("EVENT", name, faction_key);

	if not core:add_static_object(ne.full_name, ne, "narrative_events", false, true) then
		script_error("ERROR: narrative_event:new() called but couldn't add narrative event to the static object registry - has a narrative event with this name [" .. ne.full_name .. "] already been created?");
		return false;
	end;

	set_object_class(ne, self);

	ne.advice_key = advice_key;
	ne.infotext = infotext;
	ne.faction_key = faction_key;
	
	ne.trigger_conditions = {};
	ne.preconditions = {};
	ne.advice_preconditions = {};
	ne.narrative_event_payload_inheritance = {};
	ne.messages_on_issued = {};
	ne.intervention_configuration_callbacks = {};

	ne.messages_on_mission_completed = messages_on_mission_completed;

	-- attempt to create a mission manager if we've been given a mission key
	if mission_key then
		-- Assemble a completion callback
		local function completion_callback(mission_completion_status)
			local messages_on_mission_completed = ne.messages_on_mission_completed;

			if not messages_on_mission_completed or #messages_on_mission_completed == 0 then
				if __narrative_system_debug then
					ne:out();
					ne:out();
					ne:out("mission completed - no mission-completed messages registered");
				end;
			else
				if __narrative_system_debug then
					ne:out();
					ne:out();
					ne:out("mission completed - triggering completion message" .. (#messages_on_mission_completed == 1 and "" or "s") .. " [" .. table.concat(messages_on_mission_completed, ", ") .. "] for faction [" .. faction_key .. "]");
				end;
				trigger_narrative_script_message(ne, messages_on_mission_completed);
			end;

			if suppress_mission_complete_event_msg then
				cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
				script_error("INFO: " .. ne.full_name .. " is suppressing mission completion dialogues - this is expected, but needs to be reimplemented a better way");
				cm:callback(
					function()
						cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "");
					end,
					0.5
				);
			end;
		end;

		local mm = mission_manager:new(
			faction_key,
			mission_key,
			completion_callback,
			completion_callback,
			completion_callback
		);

		if not mm then
			-- the mission manager was not created for some reason - it will have thrown a script error, so just return false
			return false;
		end;

		ne.mm = mm;
	end;

	return ne;
end;











----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc A narrative event object is created and returned by calling @narrative_event:new. Once created, functions on a <code>narrative_event</code> may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;narrative_event_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example -- name, faction_key, advice_key, infotext, mission_key, messages_on_mission_completed
--- @example local ne_example = narrative_event:new(
--- @example 	"example_early_game_narrative_event",
--- @example 	"wh3_main_ksl_the_ice_court",
--- @example 	"wh3_main_camp_early_game_example_01",
--- @example 	nil,
--- @example 	"wh3_main_ksl_early_game_example_mission_key_01"
--- @example 	"KislevExampleMission01Completed"
--- @example )
--- @example 
--- @example -- calling a function on the object once created
--- @example ne_example:add_trigger_condition(
--- @example	"FactionTurnStart",
--- @example	function(context)
--- @example		return context:faction():name() == "wh3_main_ksl_the_ice_court" and cm:turn_number() >= 3
--- @example	end
--- @example )
--- @example 
--- @example -- start listening for the trigger condition
--- @example ne_example:start()










----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function is_running
--- @desc Returns whether this narrative event is currently active and listening for its various trigger conditions. This becomes <code>true</code> when @narrative_event:start is called and <code>false</code> when the narrative event triggers.
--- @r @boolean is running
function narrative_event:is_running()
	return self.running;
end;


--- @function has_triggered_this_campaign
--- @desc Returns whether this narrative event has triggered in this campaign save.
--- @r @boolean has triggered
function narrative_event:has_triggered_this_campaign()
	return cm:get_saved_value(self.full_name);
end;


--- @function has_been_seen_in_advice_history
--- @desc Returns whether this narrative event has ever been triggered in any campaign, from the advice history. This is mainly for internal use but can be called externally if required.
--- @r @boolean has triggered in 
function narrative_event:has_been_seen_in_advice_history()
	return common.get_advice_history_string_seen(self.name);
end;


-- internal function for debug output
function narrative_event:out(str)
	if str then
		out.narrative(self.full_name .. ": " .. str);
	else
		out.narrative("");
	end;
end;











----------------------------------------------------------------------------
--- @section Scripted Objectives
----------------------------------------------------------------------------


--- @desc If a mission key was specified in @narrative_event:new then this mission type can be customised using the functions in this section. These call the equivalent functions on the internally-created mission manager. Alternatively, the internal mission manager may be directly accessed with @narrative_event:get_mission_manager, at which point function calls may be made to it to customise the mission to be delivered.
--- @desc If no mission key was specified to @narrative_event:new then no mision manager will have been generated, and these functions will produce errors and return <code>false</code>.


--- @function add_new_objective
--- @desc Adds a new scripted objective to the internally-created mission manager. See @mission_manager:add_new_objective for more information.
--- @p @string objective type
function narrative_event:add_new_objective(objective_type)
	if not self.mm then
		script_error(self.full_name .. " ERROR: add_new_objective() called but no mission manager has been created for this narrative event");
		return false;
	end;

	self.mm:add_new_objective(objective_type);
end;


--- @function add_condition
--- @desc Adds a new condition to the mission objective most recently added with @narrative_event:add_new_objective. See @mission_manager:add_condition for more information.
--- @p @string condition
function narrative_event:add_condition(condition)
	if not self.mm then
		script_error(self.full_name .. " ERROR: add_condition() called but no mission manager has been created for this narrative event");
		return false;
	end;

	self.mm:add_condition(condition);
end;


--- @function add_payload
--- @desc Adds a new payload to the mission objective most recently added with @narrative_event:add_new_objective. See @mission_manager:add_payload for more information.
--- @p @string payload
function narrative_event:add_payload(payload)
	if not self.mm then
		script_error(self.full_name .. " ERROR: add_payload() called but no mission manager has been created for this narrative event");
		return false;
	end;

	self.mm:add_payload(payload, true);
end;


--- @function set_mission_issuer
--- @desc Sets a mission issuer for the internally-generated mission manager. See @mission_manager:set_mission_issuer for more information.
--- @p @string issuer
function narrative_event:set_mission_issuer(issuer)

	if not is_string(issuer) then
		script_error(self.full_name .. " ERROR: set_mission_issuer() called but supplied issuer name [" .. tostring(issuer) .. "] is not a string");
		return false;
	end;

	if not self.mm then
		script_error(self.full_name .. " ERROR: set_mission_issuer() called but no mission manager has been created for this narrative event");
		return false;
	end;

	self.mm:set_mission_issuer(issuer);
end;


--- @function get_mission_manager
--- @desc Returns the internally-created mission manager, which can be used to further customise the mission to be generated.
--- @r @mission_manager mission manager
function narrative_event:get_mission_manager()
	return self.mm;
end;










----------------------------------------------------------------------------
--- @section Payload Inheritance
--- @desc Narrative events may be set to inherit mission reward payloads from other narrative events, if that other narrative event has not yet triggered by the time the first does. This is to allow chains of narrative missions set up where individual missions can be bypassed without the player losing out on the reward that mission would bring.
--- @desc Consider two narrative events that encapsulate missions, one to recruit an agent and another to use an agent against an enemy target. Neither has yet triggered. The agent-action mission, which triggers when an agent is recruited, would naturally lead on from the first, but not in all cases - the player may be gifted an agent from an incident or other scripted event. By setting the agent-action mission to inherit the rewards of the recruit-agent mission, the rewards of the now-redundant recruit-agent mission will be rolled in to the agent-action mission, meaning the player is not penalised for having inadvertantly skipped a mission before it can trigger.
--- @desc If the narrative event being inherited from has already triggered then those rewards are not inherited. Should one narrative event inherit the rewards of another, that second narrative event will shut down and be unable to trigger.
----------------------------------------------------------------------------


--- @function add_narrative_event_payload_inheritance
--- @desc Marks this narrative event as inheriting from another narrative event. The other narrative event is specified by the unique name and faction key supplied on creation.
--- @p @string narrative event name
--- @p @string faction key
function narrative_event:add_narrative_event_payload_inheritance(narrative_event_name, faction_key)
	if not is_string(narrative_event_name) then
		script_error("ERROR: add_narrative_event_payload_inheritance() called but supplied narrative event name [" .. tostring(narrative_event_name) .. "] is not a string");
		return false;
	end;

	if not is_string(faction_key) then
		script_error("ERROR: add_narrative_event_payload_inheritance() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	local _, full_name = assemble_narrative_name("EVENT", narrative_event_name, faction_key);

	table.insert(self.narrative_event_payload_inheritance, full_name);
end;


-- internal function to query if this narrative event has had its payload inherited by another
function narrative_event:has_payload_been_inherited()
	return self.payload_inherited;
end;


-- internal function to mark this narrative event as having had its payload inherited
function narrative_event:mark_payload_as_inherited()
	self.payload_inherited = true;
	self:cancel_trigger_listeners();
end;


-- internal function, called when the narrative event is triggered, to compel it to actually perform the inheritance operation
function narrative_event:attempt_to_inherit_on_trigger()
	if self.mm then
		for i = 1, #self.narrative_event_payload_inheritance do
			local other_ne = core:get_static_object(self.narrative_event_payload_inheritance[i], "narrative_events");

			if other_ne then
				if not other_ne:has_triggered_this_campaign() and not other_ne:has_payload_been_inherited() then
					local other_mm = other_ne:get_mission_manager();
					if other_mm then
						if self.mm:add_payload_from_mission_manager(other_mm) then
							if __narrative_system_debug then
								self:out("Inheriting mission reward payloads from narrative event [" .. other_ne.name .. "]");
							end;
							other_ne:mark_payload_as_inherited();
						end;
					else
						script_error(self.name .. " WARNING: attempted to inherit from narrative event with name [" .. self.narrative_event_payload_inheritance[i] .. "] on trigger but this narrative event has no mission manager?");
					end;
				end;
			else
				script_error(self.name .. " WARNING: attempted to inherit from narrative event with name [" .. self.narrative_event_payload_inheritance[i] .. "] on trigger but no narrative event with this name could be found");
			end;
		end;
	end;
end;














----------------------------------------------------------------------------
--- @section Scripted Messages
----------------------------------------------------------------------------


--- @function add_message_on_issued
--- @desc Adds a script message that is triggered when this narrative event begins to issue. Multiple messages to be triggered can be added by calling this function multiple times. If the narrative event wraps its contents within an @intervention then this intervention will have started by the time these messages are triggered. This means that other scripts can respond to these messages and trigger their own interventions, which will queue up behind the intervention currently playing.
--- @p @string message
function narrative_event:add_message_on_issued(message)
	if not validate.is_string(message) then
		return false;
	end;

	table.insert(self.messages_on_issued, message);
end;


--- @function add_message_on_mission_completed
--- @desc Adds a script message that fires when the mission associated with this narrative event is completed, either successfully or unsuccessfully. Multiple messages to be triggered can be added by calling this function multiple times. Other scripts can listen for this message and respond accordingly.
--- @desc If no mission is associated with this narrative event then this setting will have no effect.
--- @p @string message
function narrative_event:add_message_on_mission_completed(message)
	if not is_string(message) then
		script_error(self.full_name .. " ERROR: add_message_on_mission_completed() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	table.insert(self.messages_on_mission_completed, message);
end;







----------------------------------------------------------------------------
--- @section Trigger Callbacks
----------------------------------------------------------------------------


--- @function set_trigger_callback
--- @desc Adds a callback to be called when this narrative event is triggered. This can be used to trigger narrative event actions like a cutscene or a fullscreen movie if a mission is not being triggered, or can be used to trigger actions in addition to a mission.
--- @p @function callback
function narrative_event:set_trigger_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	self.trigger_callback = callback;
end;







----------------------------------------------------------------------------
--- @section Narrative Event Categories
--- @desc Narrative events will not show advice, or not scroll the camera despite a scroll target being set with @narrative_event:set_camera_scroll_target_callback, if they reason that the player has seen the content enough times before. They do this to avoid irritating the player with too much advice and too many intrusive camera movements for content that they're familiar with. The category of a scripted event and the advice level (high/low/minimal) set by the player is used to make this judgement and determine whether:
--- @desc <ol><li>Advice should be played and the camera scrolled.</li>
--- @desc <li>Advice should be played with no camera movement.</li>
--- @desc <li>No advice or camera movement should be played.</li></ol>
--- @desc In all cases the mission associated with the narrative event is triggered, if one was set up.
--- @desc <table class="simple"><tr><th>Value</th><th>Description</th></tr>
--- @desc <tr><td><code>NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY</code></td><td>Sets that the advice associated with this narrative event is mandatory and will always be played, including camera movements, even if the advice level is set to minimal. Only in multiplayer mode or if an advice precondition fails will the advice not be shown in this case. Use this setting sparingly.</td></tr>
--- @desc <tr><td><code>NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY</code></td><td>Sets that the advice associated with this narrative event is high-priority. The only circumstance in which a narrative event of this category would not show its advice would be if the advice level was set to minimal.</td></tr>
--- @desc <tr><td><code>NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION</code></td><td>Sets that the advice is normal priority, but that the advice shown is specific to the faction currently being played and not associated with the same narrative event but for different factions.</td></tr>
--- @desc <tr><td><code>NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED</code></td><td>Sets that the advice is normal priority and is shared amongst many different factions for which this narrative event triggers (e.g. a particular early game mission shared between many different playable factions).</td></tr></table>
--- @desc The values listed in the table above are defined in script as constants. The default narrative event category is <code>NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED</code>.
----------------------------------------------------------------------------


--- @function set_category
--- @desc Sets the category of the narrative event. Supply a constant value from the table above.
--- @p @number category enum
--- @example ne_example:set_category(NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION)
function narrative_event:set_category(category)
	if not is_number(category) then
		script_error(self.full_name .. " ERROR: set_category() called but supplied category [" .. tostring(category) .. "] is not a number");
		return false;
	end;

	for i = 1, #narrative_event_valid_categories do
		if narrative_event_valid_categories[i] == category then
			self.category = category;
			return;
		end;
	end;

	script_error(self.full_name .. " ERROR: set_category() called but supplied category [" .. tostring(category) .. "] is not a valid category. Valid values are [" .. table.concat(narrative_event_valid_categories, ",") .. "] - read documentation to see their meaning");
end;











----------------------------------------------------------------------------
--- @section Intervention Priority
--- @desc Should the narrative event trigger with an @intervention, the priority for that intervention will determine the sort order of interventions that want to trigger at that same time. The priority for each narrative event intervention is determined from the category (see @"narrative_event:Narrative Event Categories"), with mandatory and high-priority narrative events triggering before narrative events set with other categories. Alternatively, the priority may be overridden directly with @narrative_event:set_priority.
----------------------------------------------------------------------------


--- @function set_priority
--- @desc Sets the priority for the @intervention created by this narrative event, if one is created. If a priority is not set with this function then one is determined from the category (see @narrative_event:set_category).
--- @desc The supplied value should be a number between 0 (high priority) and 100 (lowest). See the @intervention documentation for more details.
--- @p @number priority
function narrative_event:set_priority(priority)
	if not validate.is_number(priority) then
		return false;
	end;

	self.forced_priority = priority;
end;













----------------------------------------------------------------------------
--- @section Camera Scrolling
--- @desc A scroll-camera target may be set with @narrative_event:set_camera_scroll_target_callback. This specifies a target region, character or position to which the camera is scrolled when the mission and advice are shown.
--- @desc If the narrative event has been seen before in the advice history, it may decide not to scroll the camera even when a scroll-camera target has been set. See the @"narrative_event:Narrative Event Categories" section for more information.
----------------------------------------------------------------------------


--- @function set_camera_scroll_target_callback
--- @desc Sets a camera scroll target callback. This function will be stored and then later called when the narrative event is triggered. It should return either a @string, a @number or a @table that specifies a scroll target for the narrative event. Note that the narrative event may decide not to scroll the camera in any case due to advice settings, in which case this function would not be called - see the documentation for @"narrative_event:Narrative Event Categories" for more information.
--- @desc If the function returns a @string, a region is looked up with this key and, if found, the region's settlement is used as the camera scroll target. If no region is found then a faction is looked up with the key. If found, the closest military force from the faction to the camera is used for the scroll target.
--- @desc If the function returns a @number then it is assumed to be a character command queue index value. The character looked up by this cqi is used as the camera scroll target.
--- @desc The function may also return an indexed @table that specifies a display position e.g. <code>{100, 200}</code>.
--- @desc If the function returns @nil or any of the above queries fail then no scroll target is set.
--- @p @function callback
function narrative_event:set_camera_scroll_target_callback(callback)
	if not is_function(callback) then
		script_error(self.full_name .. " ERROR: set_camera_scroll_target_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	self.camera_scroll_target_callback = callback;
end;








----------------------------------------------------------------------------
--- @section Preconditions
--- @desc Precondition checks may be added to a narrative event that it has to pass in order to trigger successfully. Once added, each precondition is checked when the narrative event is started and also when the narrative event attempts to trigger.
--- @desc Preconditions can be added with a name, which allows them to removed again if configuration is handled by multiple separate scripts that set a default behaviour for a particular narrative event and then customise that default.
----------------------------------------------------------------------------


--- @function add_precondition
--- @desc Adds a precondition function.
--- @p @function precondition, Precondition function. This should be a function that returns a @boolean value. Should the value evaluate to <code>false</code> when the precondition is called, the precondition is failed.
--- @p [opt=nil] @string name, Name by which this precondition function may later be removed with @narrative_event:remove_precondition.
--- @p [opt=nil] @string fail message, Script message to transmit in the event that this precondition fails. This can either be a @string or an indexed @table of strings if multiple messages are required.
function narrative_event:add_precondition(precondition, name, fail_message)

	if not is_function(precondition) then
		script_error(self.full_name .. " ERROR: add_precondition() called but supplied precondition [" .. tostring(precondition) .. "] is not a function");
		return false;
	end;

	if name then
		if not is_string(name) then
			script_error(self.full_name .. " ERROR: add_precondition() called but supplied precondition name [" .. tostring(name) .. "] is not a string or nil");
			return false;
		end;

		for i = 1, #self.preconditions do
			if self.preconditions[i].name == name then
				script_error(self.full_name .. " ERROR: add_precondition() called but a precondition with name [" .. tostring(name) .. "] has already been registered");
				return false;
			end;
		end;
	end;

	if fail_message then
		if is_string(fail_message) then
			fail_message = {fail_message};
		elseif not validate.is_table_of_strings(fail_message) then
			return false;
		end;
	end;
	
	local precondition_record = {
		precondition = precondition,
		name = name,
		fail_messages = fail_message
	};

	table.insert(self.preconditions, precondition_record);
end;


--- @function remove_precondition
--- @desc Removes a previously-added precondition by name.
--- @p @string name, Name of precondition to remove.
function narrative_event:remove_precondition(name)
	for i = 1, #self.preconditions do
		if self.preconditions[i].name == name then
			table.remove(self.preconditions, i);
			return;
		end;
	end;
end;


-- internal function to check all preconditions
function narrative_event:check_preconditions()
	local preconditions = self.preconditions;
	for i = 1, #preconditions do
		if not preconditions[i].precondition then
			return false, i;
		end;
	end;
	return true;
end;










----------------------------------------------------------------------------
--- @section Advice Preconditions
--- @desc Advice precondition checks may be added to suppress the advice registered to the narrative event under certain conditions. Should an advice precondition fail when the narrative event is triggered, the advice will not be shown. The narrative event and its associated mission will still trigger, however.
----------------------------------------------------------------------------


--- @function add_advice_precondition
--- @desc Adds an advice precondition function.
--- @p @function precondition, Advice precondition function. This should be a function that returns a @boolean value. Should the value evaluate to <code>false</code> when the precondition is called, the precondition is failed.
--- @p [opt=nil] @string name, Name for this advice precondition, by which it may be later removed with @narrative_event:remove_advice_precondition.
function narrative_event:add_advice_precondition(precondition, name)

	if not is_function(precondition) then
		script_error(self.full_name .. " ERROR: add_precondition() called but supplied advice precondition [" .. tostring(precondition) .. "] is not a function");
		return false;
	end;

	if name then
		if not is_string(name) then
			script_error(self.full_name .. " ERROR: add_precondition() called but supplied advice precondition name [" .. tostring(name) .. "] is not a string or nil");
			return false;
		end;

		for i = 1, #self.advice_preconditions do
			if self.advice_preconditions[i].name == name then
				script_error(self.full_name .. " ERROR: add_precondition() called but an advice precondition with name [" .. tostring(name) .. "] has already been registered");
				return false;
			end;
		end;
	end;
	
	local precondition_record = {
		precondition = function(context)
			if precondition(context) then
				return true;
			else
				if __narrative_system_debug then
					self:out("Advice precondition with name [" .. tostring(name) .. "] has failed");
				end;
				return true;
			end;
		end,
		name = name
	};

	table.insert(self.advice_preconditions, precondition_record);
end;


--- @function remove_advice_precondition
--- @desc Removes a previously-added advice precondition by name.
--- @p @string name
function narrative_event:remove_advice_precondition(name)
	for i = 1, #self.advice_preconditions do
		if self.advice_preconditions[i].name == name then
			table.remove(self.advice_preconditions, i);
			return;
		end;
	end;
end;


-- internal function to check all advice preconditions
function narrative_event:check_advice_preconditions()
	local advice_preconditions = self.advice_preconditions;
	for i = 1, #advice_preconditions do
		if not advice_preconditions[i].precondition then
			return false, i;
		end;
	end;
	return true;
end;









----------------------------------------------------------------------------
--- @section Trigger Conditions
--- @desc Trigger messages must be added to a narrative event. A narrative event will only trigger when a trigger message is received. One or more trigger messages may be added with @narrative_event:add_trigger_condition.
--- @desc If no trigger conditions are added to a narrative event the only way it can trigger is by specifying it must trigger immediately when calling @narrative_event:start.
----------------------------------------------------------------------------


-- internal function to see if a trigger condition with a given name already exists - all should have unique names
local function trigger_condition_with_name_exists(ne, name)
	local trigger_conditions = ne.trigger_conditions;

	for i = 1, #trigger_conditions do
		if trigger_conditions[i].name == name then
			return i;
		end;
	end;

	return false;
end;


--- @function add_trigger_condition
--- @desc Adds a trigger message and condition. If the narrative event has been started and the supplied script message is received, and the optional condition passes, and no preconditions fail, then the narrative event will attempt to trigger.
--- @p @string message, Message name.
--- @p [opt=nil] @function condition, Conditional function to execute when the supplied message is received. The condition function will be passed the message context. If the function returns <code>true</code> then the check passes. If no function is specified then the check will always pass.
--- @p [opt=nil] @string name, Name for this trigger listener. If specified, the trigger listener may be later removed during configuration by @narrative_event:remove_trigger_condition.
function narrative_event:add_trigger_condition(message, condition, name)
	if not is_string(message) then
		script_error(self.full_name .. " ERROR: add_trigger_condition() called but supplied script message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if condition and not is_condition(condition) then
		script_error(self.full_name .. " ERROR: add_trigger_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function or nil");
		return false;
	end;

	if name then
		if not is_string(name) then
			script_error(self.full_name .. " ERROR: add_trigger_condition() called but supplied trigger condition name [" .. tostring(name) .. "] is not a string or nil");
			return false;
		end;

		local index = trigger_condition_with_name_exists(self, name);

		if index then
			script_error(self.full_name .. " ERROR: add_trigger_condition() called but a trigger condition with name [" .. tostring(name) .. "] has already been registered");
			for i = 1, #self.trigger_conditions do
				out("trigger condition " .. i .. " is " .. self.trigger_conditions[i].name);
			end;
			return false;
		end;
	else
		-- generate a unique name
		local count = 0;
		repeat
			count = count + 1;
			name = "unnamed_trigger_" .. count;
		until not trigger_condition_with_name_exists(self, name);
	end;

	-- Construct the actual condition function we will use - we have to check the faction key on the context of the triggered message, and also the condition function we were passed (if any)
	local condition_inner;
	if is_function(condition) then
		condition_inner = function(context)
			return context.faction_key == self.faction_key and condition(context);
		end;
	else
		condition_inner = function(context)
			return context.faction_key == self.faction_key;
		end;
	end;
	
	local trigger_condition_record = {
		message = message,
		condition = condition_inner,
		name = name
	};

	table.insert(self.trigger_conditions, trigger_condition_record);
end;


--- @function remove_trigger_condition
--- @desc Removes a previously-added trigger condition by name.
--- @p @string name
function narrative_event:remove_trigger_condition(name)
	for i = 1, #self.trigger_conditions do
		if self.trigger_conditions[i].name == name then
			table.remove(self.trigger_conditions, i);
			return;
		end;
	end;
end;







----------------------------------------------------------------------------
--- @section Force No Intervention
--- @desc Some narrative events may not wish an intervention to trigger at all, even in singleplayer. These narrative events would typically not display any information to the player and would be a hidden part of a greater sequence e.g. they might just set a value in the savegame or advice history and return. @narrative_event:set_force_no_intervention can be used to force a narrative event to not bother creeating an intervention.
----------------------------------------------------------------------------


--- @function set_force_no_intervention
--- @desc Forces the narrative event to not bother creating an intervention and instead trigger its contents directly, as it would in multiplayer mode. Missions associated with this narrative event will still be triggered, but associated advice will not be shown.
--- @p [opt=true] @boolean value
function narrative_event:set_force_no_intervention(value)
	if value == false then
		self.force_no_intervention = false;
	else
		self.force_no_intervention = true;
	end;
end;










----------------------------------------------------------------------------
--- @section Intervention Configuration
--- @desc Some narrative events may wish to configure the @intervention that is created internally. This can be done by setting a configuration callback with @narrative_event:add_intervention_configuration_callback. This could be used to allow the intervention to play before a battle sequence has been completed or when a fullscreen panel is showing, for example.
----------------------------------------------------------------------------


--- @function add_intervention_configuration_callback
--- @desc Adds a configuration callback for the @intervention object the narrative event may create internally (interventions are created in singleplayer mode only). If any configuration callbacks have been supplied then they are called as the intervention is created, which is generally just as it's triggered. Configuration callbacks will be passed the intervention object as a single argument, which they can then make configuration calls upon.
--- @desc Setting a configuration callback allows calling scripts to tailor aspects of the intervention's presentation, such as allowing it to trigger over the top of fullscreen panels or not on the player's turn.
--- @desc Multiple configuration callbacks may be added to a narrative event. They will be called in the order that they were added.
--- @p @function callback
function narrative_event:add_intervention_configuration_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(self.intervention_configuration_callbacks, callback);
end;











----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the narrative event listeners. If the narrative event has already triggered this campaign, or if its payload has already been inherited, then the listeners will not be started.
--- @desc If the optional flag is set, the narrative event will attempt to trigger immediately on startup.
--- @p [opt=false] @boolean trigger immediately
function narrative_event:start(trigger_immediately)

	-- error if already running
	if self.running then
		script_error(self.full_name .. " ERROR: start() called but this narrative event is already running");
		return false;
	end;

	-- exit if already triggered
	if self:has_triggered_this_campaign() then
		if __narrative_system_debug then
			self:out("start() called but this narrative event has already triggered this campaign, exiting");
		end;
		return false;
	end;

	-- exit if payload has already been inherited
	if self.payload_inherited then
		if __narrative_system_debug then
			self:out("start() called but this narrative event has already had its payload inherited, exiting");
		end;
		return false;
	end;

	local trigger_conditions = self.trigger_conditions;
	local num_trigger_conditions = #trigger_conditions;

	if num_trigger_conditions == 0 then
		script_error(self.full_name .. " ERROR: start() called but no trigger conditions have been registered");
		return false;
	end;

	-- check that all preconditions pass
	do
		local pass, failed_precondition_index = self:check_preconditions();
		if not pass then
			if __narrative_system_debug then
				if self.preconditions[failed_precondition_index].name then
					self:out("start() called but precondition [" .. failed_precondition_index .. "] with name [" .. preconditions[failed_precondition_index].name .. "] has failed, exiting");
				else
					self:out("start() called but precondition [" .. failed_precondition_index .. "] has failed, exiting");
				end;
			end;
			return false;
		end;
	end;

	self.running = true;

	if trigger_immediately then
		if __narrative_system_debug then
			self:out(" started - triggering immediately");
		end;
		self:trigger();
		return;
	end;

	-- set up trigger listeners
	local messages_for_output = {};

	for i = 1, #trigger_conditions do
		local current_condition_record = trigger_conditions[i];
		sm:add_listener(
			current_condition_record.message, 
			function(context)
				self.triggering_obj = context.triggering_obj;
				self:trigger(i);
			end,
			false, 
			current_condition_record.condition,
			self.full_name .. "_" .. current_condition_record.name
		);
		table.insert(messages_for_output, current_condition_record.message);
	end;

	if __narrative_system_debug then
		self:out("started, trigger condition monitors established for message" .. (#messages_for_output == 1 and " " or "s ") .. table.concat(messages_for_output, ", "));
	end;
end;


-- internal function to determine how to deliver advice and camera movements
function narrative_event:decide_content_delivery_mode()

	if not self.advice_key then
		return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "no advice registered, showing event only";
	end;

	local advice_key_score = common.get_advice_thread_score(self.advice_key);
	local category = self.category;

	if not self:check_advice_preconditions() then
		
		return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice preconditions failed, showing event only";

	elseif category == NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY then

		return NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT, "narrative event category is mandatory, showing advice with event";

	elseif core:is_advice_level_minimal() then
		
		return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice level is minimal, showing event only";

	elseif core:is_advice_level_low() then
	
		if category == NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY then
			return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT, "advice level is low and is voiced by LL, showing advice with event";
			
		elseif category == NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION then
		
			if advice_key_score == 0 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT, "advice level is low, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing advice with event";
				
			else
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice level is low, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing event only";
			end;
			
		else
			-- category == NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED
			
			if advice_key_score < 2 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT, "advice level is low, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing advice with event";
			else
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice level is low, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing event only";
			end;
		end;
	
	else
		-- core:advice_level_high() == true
		
		if category == NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY then
			return NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT, "advice level is high and is voiced by LL, scrolling camera with advice with event";
			
		elseif category == NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION then
		
			if advice_key_score == 0 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", scrolling camera with advice with event";
				
			elseif advice_key_score == 1 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing advice with event";
				
			else
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing event only";
			end;
		
		else
			-- category == NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED
			
			if advice_key_score == 0 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", scrolling camera with advice with event";
				
			elseif advice_key_score == 1 or advice_key_score == 2 then
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_ADVICE_WITH_EVENT, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing advice with event";
				
			else
				return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing event only";
			end;
		end;
	end;
	
	script_error(self.full_name .. " WARNING: decide_content_delivery_mode() couldn't decide a content delivery mode, category is [" .. tostring(category) .. "], advice_key is [" .. tostring(advice_key) .. "] and advice score is [" .. tostring(advice_key_score) .. "]");
	return NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY, "default";
end;


-- internal function to determine the priority with which the intervention should be registered
function narrative_event:decide_intervention_priority()
	if self.forced_priority then
		return self.forced_priority;
	end;
	
	local category = self.category;
	if category == NARRATIVE_EVENT_CATEGORY_ADVICE_MANDATORY then
		return 0;
	elseif category == NARRATIVE_EVENT_CATEGORY_ADVICE_HIGH_PRIORITY then
		return 10;
	end;
	
	-- category == NARRATIVE_EVENT_CATEGORY_ADVICE_SPECIFIC_TO_FACTION or category == NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED
	return 40;
end;


-- internal function to determine whether to show infotext
function narrative_event:should_show_infotext()

	-- return false if no infotext has been registered
	if not is_table(self.infotext) or #self.infotext == 0 or not self.advice_key then
		return false;
	end;
	
	if core:is_advice_level_minimal() then
		-- if advice level is minimal then never show infotext
		return false;

	elseif core:is_advice_level_low() then
		if self.category == NARRATIVE_EVENT_CATEGORY_ADVICE_SHARED then
			-- if advice level is low and advice is shared between events of this type (between factions), then show infotext if the event has never been logged in the advice history
			return not self:has_been_seen_in_advice_history();
		else
			-- if advice level is low and the advice key is specific to this faction/event combination then show infotext if this advice key has never been seen
			return common.get_advice_thread_score(self.advice_key) == 0;
		end;

	else
		-- on high advice, show the infotext if the advice has been seen less than twice
		return common.get_advice_thread_score(self.advice_key) < 2;
	end;
end;


-- internal function, triggers the narrative event
function narrative_event:trigger(trigger_condition_index)

	if not self.running then
		script_error(self.full_name .. " ERROR: trigger() called but this narrative event is not running - has this function been called externally?");
		return false;
	end;

	-- inherit payloads from other narrative events/mission managers if we should
	self:attempt_to_inherit_on_trigger();

	-- output about triggering
	if __narrative_system_debug and trigger_condition_index then 
		local trigger_condition_record = self.trigger_conditions[trigger_condition_index];
		self:out("Attempting to trigger after receiving message [" .. trigger_condition_record.message .. "]");
	end;

	-- cancel any still-running trigger listeners
	self:cancel_trigger_listeners()

	self.running = false;

	-- check preconditions again
	if trigger_condition_index then 
		local pass, failed_precondition_index = self:check_preconditions();
		if not pass then
			local precondition_record = self.preconditions[failed_precondition_index];
			if __narrative_system_debug then
				self:out("\tprecondition [" .. failed_precondition_index .. "] " .. (precondition_record.name and ("with name [" .. precondition_record.name .. "] ") or "") .. "has failed, exiting" .. ((precondition_record.fail_messages and #precondition_record.fail_messages > 0) and (" and triggering fail message" .. (#precondition_record.fail_messages == 1 and " [" or "s [") .. table.concat(precondition_record.fail_messages, ", ") .. "]" or "") or ""));
			end;
			if precondition_record.fail_messages then
				for i = 1, #precondition_record.fail_messages do
					sm:trigger_message(precondition_record.fail_messages[i]);
				end;
			end;

			return false;
		end;
	end;

	-- mark that this event has been seen in the savegame 
	cm:set_saved_value(self.full_name, true);

	-- A reference to the intervention is created in this scope as allow_issue_completed_callback() won't have access to it otherwise (to pass to issue_completed_callback)
	local inv_persistent;

	local issue_completion_blocked = false;
	local issue_successfully_completed = false;
	local allow_issue_completed_callback;

	-- Function which attempts to complete. This may be blocked by client scripts if allow_issue_completed_callback() is called. This is only used if trigger_basic() is called,
	-- i.e not when an intervention behaviour function like play_advice_for_intervention is used instead
	local function issue_completed_callback()
		if not issue_completion_blocked and not issue_successfully_completed then
			issue_successfully_completed = true;
			if __narrative_system_debug then
				self:out();
				self:out();
				self:out("finished issuing" .. (#self.messages_on_issued == 0 and "" or (", triggering on-issued message" .. (#self.messages_on_issued == 1 and "" or "s") .. " [" .. table.concat(self.messages_on_issued, ", ") .. "]")) .. " for faction [" .. self.faction_key .. "]");
			end;
			trigger_narrative_script_message(self, self.messages_on_issued);
			if inv_persistent then
				inv_persistent:complete();
			end;
		end;
	end;
	
	-- Create an issue completed callback if there is a trigger callback. The issue completed callback is supplied to the trigger callback,
	-- and if called by that script with false as an argument will block the on-issued events from being triggered, and also the intervention
	-- from being completed (if one has been created)
	
	if self.trigger_callback then
		function allow_issue_completed_callback(allow_completion)
			if allow_completion == false then
				issue_completion_blocked = true;
				return;
			end;
			
			issue_completion_blocked = false;

			issue_completed_callback();
		end;
	end;


	-- Basic-mode callback which calls trigger callback if therre is one, triggers the mission if there is one, then attempts to complete.
	-- The trigger callback is passed the function allow_issue_completed_callback, which if called with false as an arg blocks the completion
	-- until it's called again with true (or any value other than false)
	local function trigger_basic(inv)
		inv_persistent = inv;

		if self.trigger_callback then
			self.trigger_callback(self.trigger_conditions[trigger_condition_index].message, allow_issue_completed_callback);
		end;
		if self.mm then
			self.mm:trigger();

			cm:callback(
				function()
					issue_completed_callback();
				end,
				0.5
			)
		else
			issue_completed_callback();
		end;
	end;

	-- If it's a multiplayer game then call trigger_basic() without creating an intervention and exit
	if cm:is_multiplayer() then
		if __narrative_system_debug then
			self:out("\tthis is a multiplayer game, triggering immediately without advice");
		end;
		trigger_basic();
		return;
	end;

	-- If we've been told not to trigger using an intervention then trigger directly then exit
	if self.force_no_intervention then
		if __narrative_system_debug then
			self:out("\tthis narrative event is being forced to not use an intervention, triggering immediately");
		end;
		trigger_basic();
		return;
	end;

	-- Assemble some infotext to show - if we shouldn't show any infotext then this will be nil
	local infotext;
	if self:should_show_infotext() then
		infotext = self.infotext;
	end;

	-- Mark this event as seen by the player in the advice history
	common.set_advice_history_string_seen(self.name);
	
	cm:trigger_transient_intervention(
		self.full_name, 
		function(inv)

			local delivery_mode, delivery_mode_str = self:decide_content_delivery_mode();
		
			if __narrative_system_debug then
				self:out();
				self:out();
				self:out("Intervention triggering - " .. delivery_mode_str);
			end;
			
			if delivery_mode == NARRATIVE_EVENT_PLAYBACK_MODE_SHOW_EVENT_ONLY then
				-- We're only showing a mission/event - just call trigger_basic(), complete, and return
				trigger_basic(inv);
				return;
			end;

			local content_delivered = false;
			local out_str = "";

			if delivery_mode == NARRATIVE_EVENT_PLAYBACK_MODE_SCROLL_CAMERA_WITH_ADVICE_AND_EVENT then
				-- We're going to attempt to scroll the camera to a target, work out if we can
				local camera_scroll_target = false;

				if is_function(self.camera_scroll_target_callback) then
					camera_scroll_target = self.camera_scroll_target_callback();
				end;

				if camera_scroll_target then
					if is_string(camera_scroll_target) then
						-- The camera scroll target is a string - try and look up a region by key with it
						if cm:get_region(camera_scroll_target) then
							content_delivered = true;
							if __narrative_system_debug then
								self:out("\tscrolling camera to region [" .. camera_scroll_target .. "], with advice and mission");
							end;

							inv:scroll_camera_to_settlement_for_intervention(
								camera_scroll_target, 
								self.advice_key, 
								infotext,
								self.mm
							);

						-- No region was found, so try looking up a faction by key next
						else
							local faction = cm:get_faction(camera_scroll_target);
							if faction then
								local x, y = cm:get_camera_position();
								x, y = cm:dis_to_log(x, y);
								local char = cm:get_closest_character_to_position_from_faction(faction, x, y, true, true);

								if char then
									content_delivered = true;

									local cqi = char:command_queue_index();

									if __narrative_system_debug then
										self:out("\tscrolling camera to character with cqi [" .. cqi .. "] from faction [" .. camera_scroll_target .. "], with advice and mission");
									end;
		
									inv:scroll_camera_to_character_for_intervention(
										cqi,
										self.advice_key, 
										infotext,
										self.mm
									);
								end;
							end;
						end;
							
						if not content_delivered and __narrative_system_debug then
							self:out("\tplaying advice with mission - no region or faction with key [" .. camera_scroll_target .. "] could be found");
						end;

					elseif is_number(camera_scroll_target) then
						-- The camera scroll target is a number, so it should be a character cqi
						if cm:get_character_by_cqi(camera_scroll_target) then
							content_delivered = true;
							if __narrative_system_debug then
								self:out("\tscrolling camera to character with cqi [" .. camera_scroll_target .. "], with advice and mission");
							end;

							inv:scroll_camera_to_character_for_intervention(
								camera_scroll_target, 
								self.advice_key, 
								infotext,
								self.mm
							);
						else
							if __narrative_system_debug then
								self:out("\tplaying advice with mission - no character with cqi [" .. camera_scroll_target .. "] could be found");
							end;
						end;
					elseif is_table(camera_scroll_target) and is_number(camera_scroll_target[1]) and is_number(camera_scroll_target[2]) then

						-- the camera scroll target must be a table of camera co-ordinates
						content_delivered = true;
						if __narrative_system_debug then
							self:out("\tscrolling camera to position [" .. camera_scroll_target[1] .. ", " .. camera_scroll_target[2] .. "] with advice and mission");
						end;

						inv:scroll_camera_for_intervention(
							nil,
							camera_scroll_target[1],
							camera_scroll_target[2],
							self.advice_key,
							infotext,
							self.mm
						);
					else
						script_error(self.full_name .. " WARNING: trigger() called, the camera scroll callback was called and a target value [" .. tostring(camera_scroll_target) .. "] was returned, but it is not a string region name, numeric char cqi or table containing numeric camera co-ordinates. Not setting camera target");
					end;
				else
					-- No scroll target set at all
					if __narrative_system_debug then
						self:out("\tplaying advice with mission - no camera scroll target set");
					end;
				end;
			else
				if __narrative_system_debug then
					self:out("\tplaying advice with mission");
				end;
			end;
			
			if not content_delivered then
				-- We don't want to, or can't, scroll the camera to a target, so just show advice with the mission
				inv:play_advice_for_intervention(
					self.advice_key,
					infotext,
					self.mm
				);
			end;
			
			-- Call the trigger callback if one has been set up
			if self.trigger_callback then
				self.trigger_callback(self.trigger_conditions[trigger_condition_index].event);
			end;

			-- Trigger the on-issued message(s) if one or more have been set up
			local messages_on_issued = self.messages_on_issued;
			if #messages_on_issued > 0 then
				self:out();
				self:out();
				self:out("triggering on-issued message" .. (#messages_on_issued == 1 and " [" or "s [") .. table.concat(messages_on_issued, ", ") .. "] for faction [" .. self.faction_key .. "]");
				trigger_narrative_script_message(self, messages_on_issued);
			end;
		end,
		true,
		function(inv)
			local intervention_configuration_callbacks = self.intervention_configuration_callbacks;
			for i = 1, #intervention_configuration_callbacks do
				intervention_configuration_callbacks[i](inv);
			end;
		end,
		self:decide_intervention_priority()
	);
end;


-- internal function to cancel any still-running trigger listeners
function narrative_event:cancel_trigger_listeners()
	local trigger_conditions = self.trigger_conditions;
	for i = 1, #trigger_conditions do
		sm:remove_listener_by_name(self.full_name .. "_" .. trigger_conditions[i].name);
	end;
end;


















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- NARRATIVE QUERIES
--
--- @c narrative_query Narrative Queries
--- @page narrative_event
--
--- @desc For an overview of the narrative events system see the @narrative topic page.
--- @desc Narrative queries represent decision points within a narrative structure. When triggered, a narrative query will run a supplied function query and may trigger script messages depending upon the result. Other narrative objects listening for those messages can then act upon the result of the query. See the page about the @script_messager for more information about script messages (they are different-but-equivalent to script events).
--- @desc All the data associated with a narrative query is supplied to it when it's constructed. Of particular note is the query records data structure - see the documentation of @narrative_query:new for more information.
--- @desc Once constructed, a narrative query is started by calling @narrative_query:start. This starts its internal trigger listeners.
--- @desc A narrative query triggers when it receives one of the trigger messages specified on creation (and the faction information contained in the message context matches the faction registered with the narrative query). At this point, all query functions supplied to the narrative event will be run, in order of registration. Each function will be passed the message context supplied to the narrative query as a first argument and the narrative query itself as a second. The query function can use the narrative query object to store data that other query functions that are about execute can read, if required.
--- @desc For any query that passes (i.e. the query function returns true) the related pass script message is triggered. Where a query doesn't pass, and a fail message was specified in the query setup, that fail message is triggered.
--- @desc Unlike @narrative_event and @narrative_trigger objects, narrative queries are stateless and do not save any information into the savegame. This means that any narrative query can trigger multiple times. The narrative event framework is designed so that narrative events and triggers should only be issued once, however, so this should be avoided.
--- @desc Narrative queries should work as expected in multiplayer mode.
--- @desc Narrative queries output diagnostic information on the <code>Lua - Narrative</code> console spool.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


narrative_query = {
	
	name = false,													-- String name for this narrative query object, must be unique amongst narrative queries (once concatenated with the supplied faction key)
	full_name = false,												-- Full name for this narrative query object, includes the faction key
	faction_key = false,											-- String faction key to which this narrative query applies
	is_deferred = false,											-- Has the current query been deferred? When deferred, a query can be retriggered with narrative_query:retrigger
	trigger_message_while_deferred = false,							-- The trigger message which led to the query being deferred
	is_processing_query = false,									-- Are we actively processing a query right now? While this is true this is the only valid time to set defer_query to true
	--[[
	trigger_messages = {},											-- Message(s) which triggers the query
	query_records = {												-- Queries to run when a trigger message is received.
		{																-- Each query record contains:
			message = "PassExample",										-- The message to trigger if the query passes. This can be a single string or a table of strings.
			fail_message = "FailExample",									-- The message to trigger if the query fails [opt]. This can be a single string or a table of strings.
			query = function(context, nq)									-- The query function, which returns a value that determines if the query passes. The query function is passed the message context and the narrative query object
				return true
			end
		}
	}
	]]
};


set_class_custom_type(narrative_query, TYPE_CAMPAIGN_NARRATIVE_QUERY);
set_class_tostring(
	narrative_query, 
	function(obj)
		return TYPE_CAMPAIGN_NARRATIVE_QUERY .. "_" .. obj.full_name
	end
);



----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a narrative query object. As with all narrative objects a unique name and faction key to which the query applies must be supplied.
--- @desc The query records table must be an indexed table containing one or more subtables. Each subtable should contain elements at the following keys:
--- @desc <table class="simple"><tr><th>Key</th><th>Data Description</th></tr>
--- @desc <tr><td><code>message</code></td><td>Message to trigger if the related query function returns true (or a value that equates to true). This can be a single string or a table of strings if multiple pass messages are desired.</td></tr>
--- @desc <tr><td><code>fail_message</code></td><td><strong>Optional</strong> message to trigger if the related query function returns false (or a value that equates to false). This can be a single string or a table of strings if multiple pass messages are desired.</td></tr>
--- @desc <tr><td><code>query</code></td><td>A function that should return a boolean value which determines whether the query passes or fails. The function will be passed two arguments:<ol><li>The context of the message which triggered the narrative query.</li><li>The narrative query object itself.</li></td></tr>
--- @desc </table>
--- @desc See the @narrative_query:Usage section of this documentation for a declaration example.
--- @p @string name, Unique name amongst narrative query objects.
--- @p @string faction key, Key of faction, from the <code>factions</code> database table, this narrative query is related to.
--- @p @string trigger message, String name of message which triggers this narrative query. This may also be a @table of multiple string message names, any of which will trigger the query.
--- @p @table query records, Query records - see the function documentation for a description of the data format to supply here.
--- @r @narrative_query narrative query
function narrative_query:new(name, faction_key, trigger_messages, query_records)

	if not validate.is_string(name) then
		return false;
	end;

	if not validate.is_string(faction_key) then
		return false;
	end;

	if is_string(trigger_messages) then
		trigger_messages = {trigger_messages};
	elseif not is_table_of_strings(trigger_messages) then
		script_error("ERROR: narrative_query:new() called but supplied trigger messages value [" .. tostring(trigger_messages) .. "] is not a table of strings, or a single string");
		return false;
	end;

	if not validate.is_non_empty_table_indexed(query_records) then
		return false;
	end;

	for i = 1, #query_records do
		local record = query_records[i];

		if record.message and not is_string_or_table_of_strings(record.message) then
			script_error("ERROR: narrative_query:new() called but positive message of query record [" .. i .. "] has a value of [" .. tostring(record.message) .. "] - this should be a string, a table of strings or nil. This is specified at an element in the query record with key [\"message\"]");
			return false;
		end;

		if record.fail_message and not is_string_or_table_of_strings(record.fail_message) then
			script_error("ERROR: narrative_query:new() called but fail message of query record [" .. i .. "] has a value of [" .. tostring(record.message) .. "] - this should be a string, a table of strings or nil. This is specified at an element in the query record with key [\"fail_message\"]");
			return false;
		end;

		if not is_function(record.query) then
			script_error("ERROR: narrative_query:new() called but query record [" .. i .. "] contains no query - this should be specified at an element in the query record with key [\"query\"]");
			return false;
		end;
	end;

	local nq = {};
	
	nq.name, nq.full_name = assemble_narrative_name("QUERY", name, faction_key);

	if not core:add_static_object(nq.full_name, nq, "narrative_queries", false, true) then
		script_error("ERROR: narrative_query:new() called but couldn't add narrative query to the static object registry - has a narrative query with the name [" .. nq.full_name .. "] already been created?");
		return false;
	end;

	set_object_class(nq, self);

	nq.faction_key = faction_key;
	
	nq.trigger_messages = trigger_messages;
	nq.query_records = query_records;

	return nq;
end;







----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc A narrative query object is created and returned by calling @narrative_query:new. Once created, functions on a <code>narrative_query</code> may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;narrative_query_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example -- name, faction_key, trigger_messages, query_records
--- @example local nq_advice_level = narrative_query:new(
--- @example 	"advice_level",
--- @example 	"wh3_main_ksl_the_ice_court",
--- @example 	{"Example1", "Example2", "Example3"},
--- @example 	{
--- @example 		-- all queries will be run when narrative_query triggered
--- @example 		{
--- @example 			message = "ExampleAdviceLevelHigh",
--- @example 			query = function(context, nq)
--- @example 				return common.get_advice_level() == 2
--- @example 			end
--- @example 		{,
--- @example		{
--- @example 			message = "ExampleAdviceLevelLow",
--- @example 			query = function(context, nq)
--- @example 				return common.get_advice_level() == 1
--- @example 			end
--- @example 		{,
--- @example		{
--- @example 			message = "ExampleAdviceLevelMinimal",
--- @example 			query = function(context, nq)
--- @example 				return common.get_advice_level() == 0
--- @example 			end
--- @example 		{
--- @example 	}
--- @example )
--- @example 
--- @example -- starting the narrative query
--- @example nq_advice_level:start()









----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the narrative query's listeners.
function narrative_query:start()
	-- Establish a listener for each of our trigger messages
	local trigger_messages = self.trigger_messages;
	for i = 1, #trigger_messages do
		sm:add_listener(
			trigger_messages[i],
			function()
				self:trigger_message_received(context, trigger_messages[i], false);
			end,
			true,
			function(context)
				-- Return true if the context contains no faction key, or if it does and the faction key matches the one we have
				return context.faction_key == self.faction_key;
			end
		);
	end;

	if __narrative_system_debug then
		self:out("Started listeners for trigger message" .. (#trigger_messages == 0 and "" or "s") .. " [" .. table.concat(trigger_messages, ", ") .. "]");
	end;
end;


-- Internal functions for output
function narrative_query:out(str)
	if str then
		out.narrative(self.full_name .. ": " .. str);
	else
		out.narrative("");
	end;
end;


-- Internal function called when the narrative query is triggered
function narrative_query:trigger_message_received(context, trigger_message, this_trigger_deferred)

	-- If this is a deferred trigger then reset the deferral state of this query
	if this_trigger_deferred then
		self.trigger_message_while_deferred = false;
		self.is_deferred = false;
	end;

	-- Check each of our queries and trigger the associated message if it returns true
	local query_records = self.query_records;

	local pass_messages_for_triggering = {};
	local fail_messages_for_triggering = {};

	for i = 1, #query_records do
		local current_query_record = query_records[i];

		self.is_processing_query = true;

		local query_passes, output = current_query_record.query(context, self);

		self.is_processing_query = false;

		-- If the query callback has set the defer flag on this query then we establish an internal trigger listener and
		-- don't proceed with the query now. 
		if self.is_deferred then
			self.trigger_message_while_deferred = trigger_message;
			return;
		end;
		
		if query_passes then
			
			local pass_record = {messages = {}, output = output};

			-- Defer the triggering of the message so we don't get any weird ordering issues
			if is_string(current_query_record.message) then
				table.insert(pass_record.messages, current_query_record.message);
			elseif is_table(current_query_record.message) then
				for j = 1, #current_query_record.message do
					table.insert(pass_record.messages, current_query_record.message[j]);
				end;
			end;

			table.insert(pass_messages_for_triggering, pass_record);

		else
			-- The query failed, if we have a fail message then add that to a list of messages to trigger

			if current_query_record.fail_message then
				local fail_record = {messages = {}, output = output};

				if is_string(current_query_record.fail_message) then
					table.insert(fail_record.messages, current_query_record.fail_message);
				else
					for j = 1, #current_query_record.fail_message do
						table.insert(fail_record.messages, current_query_record.fail_message[j]);
					end;
				end;

				table.insert(fail_messages_for_triggering, fail_record);
			end;
		end;
	end;

	-- Trigger any messages associated with queries that have passed
	if #pass_messages_for_triggering == 0 then

		-- No pass records, so we have failed
		if #fail_messages_for_triggering == 0 then
			if __narrative_system_debug then
				self:out((this_trigger_deferred and "[DEFERRED] " or "") .. "Trigger message [" .. trigger_message .. "] received but 0 out of " .. #query_records .. " queries passed and no fail message were registered");
			end;
		else
			for i = 1, #fail_messages_for_triggering do
				local fail_record = fail_messages_for_triggering[i];

				if __narrative_system_debug then
					self:out((this_trigger_deferred and "[DEFERRED] " or "") .. "Triggering fail message" .. ((#fail_record.messages == 1) and " [" or "s [") .. table.concat(fail_record.messages, ", ") .. "] for faction [" .. self.faction_key .. "] as trigger message [" .. trigger_message .. "] was received and related query failed" .. (fail_record.output and (", output: " .. fail_record.output) or ""));
				end;

				-- Trigger the message(s)
				trigger_narrative_script_message(self, fail_record.messages);
			end;
		end;
	else
		for i = 1, #pass_messages_for_triggering do
			local pass_record = pass_messages_for_triggering[i];

			if __narrative_system_debug then
				self:out((this_trigger_deferred and "[DEFERRED] " or "") .. "Triggering pass message" .. ((#pass_record.messages == 1) and " [" or "s [") .. table.concat(pass_record.messages, ", ") .. "] for faction [" .. self.faction_key .. "] as trigger message [" .. trigger_message .. "] was received and related query passed" .. (pass_record.output and (", output: " .. pass_record.output) or ""));
			end;

			-- Trigger the message(s)
			trigger_narrative_script_message(self, pass_record.messages);
		end;
	end;
end;




----------------------------------------------------------------------------
--- @section Deferring
--- @desc It may be desirable for a narrative query to not immediately return a result when it is triggered, such as if a multiplayer query is run with @campaign_manager:progress_on_mp_query. @narrative_query:defer may be called while is query is actively processing to instruct the query not to act on any result at that moment. At a later time @narrative_query:retrigger may be called, which re-runs the query. In the interim, scripts can have prepared the information that the query needs to successfully complete.
----------------------------------------------------------------------------


--- @function defer
--- @desc Defers the query, instructing it to not transmit any success or failure messages at that time. The query may be re-run with @narrative_query:retrigger.
--- @desc This function may only be called from within one of the narrative query's condition callbacks.
function narrative_query:defer()
	if not self.is_processing_query then
		script_error(self.full_name .. "WARNING: defer() called but this narrative query is not actively processing a query. This function may only be called from within a narrative query callback. Will do nothing.")
		return false;
	end;

	self.is_deferred = true;
	self:out("result is being deferred");
end;


--- @function retrigger
--- @desc Retriggers a deferred query.
function narrative_query:retrigger()
	if not self.is_deferred then
		script_error(self.full_name .. "WARNING: retrigger() called but this narrative query has not been deferred. Will do nothing.")
		return false;
	end;

	if self.is_processing_query then
		script_error(self.full_name .. "WARNING: retrigger() called but this narrative query is actively processing. Will do nothing.")
		return false;
	end;

	if not self.trigger_message_while_deferred then
		script_error(self.full_name .. "WARNING: retrigger() called but no deferred trigger message is registered? How can this be?")
		return false;
	end;

	self:trigger_message_received(nil, self.trigger_message_while_deferred, true);
end;









































----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- NARRATIVE TRIGGERS
--
--- @c narrative_trigger Narrative Triggers
--- @page narrative_event
--
--- @desc For an overview of the narrative events system see the @narrative topic page.
--- @desc Narrative triggers monitor game conditions in order to trigger other objects within the narrative system. All narrative events, or chains of narrative events, should ultimately be started by a narrative trigger.
--- @desc One or more game script event/condition checks are registered with the narrative trigger either as it's created with @narrative_trigger:new or later with @narrative_trigger:add_monitor_event. When the narrative trigger is subsequently started when @narrative_trigger:start is called, it starts a listener for each supplied event/condition and, if the event is received and the related condition is met, triggers one or more script messages that can start other objects in the narrative event system. Narrative triggers can also listen for script messages to know when to trigger - these can be added with @narrative_trigger:add_monitor_message - although it's intended that narrative triggers should primarily listen for script events rather than messages.
--- @desc Note the distinction between script messages and script events - while narrative triggers can listen for script events and messages from the game (or other scripts) to know when to trigger, the communication with other narrative objects happens exclusively with script messages. Script messages are a script-only parallel mechanism to script events, see the @script_messager documentation for more information.
--- @desc In most cases, all data relevant to the narrative trigger is supplied during construction, when @narrative_trigger:new is called. Additional script events/conditions to monitor can be added after creation by calling @narrative_trigger:add_monitor_event.
--- @desc Once created, a narrative trigger will begin its monitors when @narrative_trigger:start is called. Like narrative events and queries, narrative triggers are intended to only trigger once per-campaign playthrough. If a narrative trigger finds in the savegame data that it has triggered before it will not start its listeners when @narrative_trigger:start is called.
--- @desc Narrative triggers should work in multiplayer mode. Narrative triggers should only listen for model game events in multiplayer mode to allow scripts on different physical machines to maintain synchronicity.
--- @desc Like other narrative objects, narrative triggers output diagnostic information on the <code>Lua - Narrative</code> console spool.
--
--- @section Deferred Triggering
--- @desc Invididual event/condition pairs can be set up to trigger immediately or not. Should an event/condition pair not be set up to trigger immediately then the narrative trigger will fire its trigger messages(s) within an intervention, which means that the message may not be triggered straight away. This can help reduce the intrusiveness of the narrative event system by spacing out the delivery of narrative events over time.
--- @desc In multiplayer mode, where interventions are not supported, trigger messages are always fired immediately.
--
--- @section Start and Cancel Messages
--- @desc Narrative triggers may also be set up with start messages. Should one or more start message be registered then the narrative trigger will not start its main event/condition monitoring process until a start message is received from another object within the narrative event system. This can be useful in certain circumstances, for example to listen for the start of a particular faction's turn but only after another mission in the narrative event system has completed. If no start messages are specified the narrative trigger starts its main monitoring process immediately when narrative_trigger:start is called.
--- @desc Cancel messages may also be set up for narrative triggers. These allow other narrative objects to cancel the trigger's main monitoring process, which can be used to stop a trigger from firing if some other condition is met within the narrative event system.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


local NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_NOT_STARTED = 0;
local NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED = 1;
local NARRATIVE_TRIGGER_STATUS_ATTEMPTING_TO_TRIGGER_LOW_PRIORITY = 2;
local NARRATIVE_TRIGGER_STATUS_TRIGGERED = 3;
local NARRATIVE_TRIGGER_STATUS_CANCELLED = 4;




narrative_trigger = {
	
	name = false,													-- String name for this narrative trigger object, must be unique amongst narrative triggers (once concatenated with the supplied faction key)
	full_name = false,												-- Full name for this narrative trigger object, includes the faction key
	faction_key = false,											-- String faction key to which this narrative trigger applies
	status = NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_NOT_STARTED,	-- Status of this narrative trigger (see enums above)
	running = false,												-- Is this narrative trigger running. This helps it guard against being started twice.
	intervention_priority = 60,										-- Priority value for the intervention if triggering in low priority mode
	should_setup_cancel_listeners_with_start_listeners = false,		-- Should the cancel listeners be set up before the main trigger listeners are even started?
	--[[
	target_messages = {},											-- The target message(s) this narrative trigger fires once its main monitor conditions pass
	start_messages = {},											-- Message(s) which start this narrative trigger's main monitoring processes
	start_callbacks = {},											-- Callback(s) to call once the narrative trigger starts its main monitoring process, either when one of the start messages is received + the faction matches, or on startup if no start messages specified
	stop_callbacks = {},											-- Callback(s) to call once the narrative trigger stops its main monitoring process, either by being cancelled or by firing its target messages. Each stop callback will be passed a boolean flag to indicate whether the target messages were fired
	main_event_and_condition_records = {							-- Main events and conditions which this narrative trigger monitors once it is started. When an event is received, and its associated condition passes, the target message(s) are triggered (directly or within an intervention)
		{
			event = "ScriptEventExample",							-- Script event to listen for
			condition = function(context, nt)						-- Condition function to run when the event is received. The function should return a boolean value. The boolean value true may be supplied in place of a condition to always trigger.
				return true
			end,
			immediate = false										-- Trigger the target message(s) immediately if this particular event/condition passes. If this is set to false and it's not a multiplayer game then an intervention is created which triggers the messages.
		}
	},
	main_message_and_condition_records = {							-- Equivalent to main_event_and_condition_records, but for messages
		{
			message = "MessageExample",
			condition = function(context, nt)
				return true
			end,
			immediate = true										
		}
	},
	cancel_messages = {}											-- Message(s) which, if received while the main monitors are active, cancel the main monitors
	]]
};



set_class_custom_type(narrative_trigger, TYPE_CAMPAIGN_NARRATIVE_TRIGGER);
set_class_tostring(
	narrative_trigger, 
	function(obj)
		return TYPE_CAMPAIGN_NARRATIVE_TRIGGER .. "_" .. obj.full_name
	end
);








----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a narrative trigger object. As with all narrative objects a unique name and faction key to which the trigger applies must be supplied.
--- @desc The main events and conditions table must be an indexed table containing one or more subtables for each event/condition pair. Each subtable should contain elements at the following keys:
--- @desc <table class="simple"><tr><th>Key</th><th>Data Description</th></tr>
--- @desc <tr><td><code>event</code></td><td>Game event to listen for. This should be a model event and not a UI event to prevent the game desynchronising in multiplayer mode.</td></tr>
--- @desc <tr><td><code>condition</code></td><td>Condition check to perform at the time the related event is received. This should be a @function which returns a boolean value. When called, the function will be passed the event context and the narrative trigger object as two separate arguments.</p>In common with other event/condition systems elsewhere, the @boolean value <code>true</code> may be supplied here in place of a function, in which case the condition always passes.</td></tr>
--- @desc <tr><td><code>immediate</code></td><td><strong>Optional</strong> boolean value which, if set to true, forces the narrative trigger to fire its trigger events immediately if this event/condition pair pass. If this value is false or is not supplied, the target message(s) are fired in an intervention which can delay their issue. In multiplayer mode the target message(s) are always fired immediately.</li></td></tr>
--- @desc </table>
--- @desc See the @narrative_trigger:Usage section of this documentation for a declaration example.
--- @p @string name, Unique name amongst narrative query objects.
--- @p @string faction key, Key of faction, from the <code>factions</code> database table, this narrative query is related to.
--- @p @string target message, String message which this narrative trigger fires when any event/condition pair are met. This may also be a @table of multiple string message names, in which case all will be triggered.
--- @p [opt=nil] @table main event records, Main event and condition records. See the function documentation above for a description of the data format to supply here. This may be left blank, with main listeners added later using either @narrative_trigger:add_monitor_event or @narrative_trigger:add_monitor_message.
--- @p [opt=false] @string start message, Message on which to start this trigger's main event monitors. This can be supplied as a single string or a @table of multiple string message names.
--- @p_long_desc If no start messages are supplied then the narrative trigger will start its main event monitors as soon as it is started.
--- @p [opt=false] @string cancel messages, Narrative messages on which to cancel the narrative trigger. This can be supplied as a single string or a @table of multiple string message names.
--- @p [opt=60] @number intervention priority, Priority at which to trigger the internal @intervention object, if one is declared. See intervention documentation for more information about intervention priorities.
--- @r @narrative_trigger narrative trigger
function narrative_trigger:new(name, faction_key, target_messages, main_event_and_condition_records, start_messages, cancel_messages, intervention_priority)

	if not validate.is_string(name) then
		return false;
	end;

	if not validate.is_string(faction_key) then
		return false;
	end;

	if not validate.is_string_or_table_of_strings(target_messages) then
		return false;
	end;

	if is_string(target_messages) then
		target_messages = {target_messages};
	end;

	if is_string(cancel_messages) then
		cancel_messages = {cancel_messages};
	end;
	
	if start_messages then
		if not validate.is_string_or_table_of_strings(start_messages) then
			return false;
		end;

		if is_string(start_messages) then
			start_messages = {start_messages};
		end;
	end;

	if main_event_and_condition_records then
		if is_non_empty_table_indexed(main_event_and_condition_records) then
			for i = 1, #main_event_and_condition_records do
				local record = main_event_and_condition_records[i];

				if not is_string(record.event) then
					script_error("ERROR: narrative_trigger:new() called for trigger with name [" .. name .. "] and faction [" .. faction_key .. "] but event field of element [" .. tostring(i) .. "] in supplied monitor events list is not a string, its value is [" .. tostring(record.event) .. "]");
					return false;
				end;

				if not is_function(record.condition) and record.condition ~= true then
					script_error("ERROR: narrative_trigger:new() called for trigger with name [" .. name .. "] and faction [" .. faction_key .. "] but condition field of element [" .. tostring(i) .. "] in supplied monitor events list is not a function or true, its value is [" .. tostring(record.condition) .. "]");
					return false;
				end;
			end;
		end;
	else
		main_event_and_condition_records = {};		
	end;
	
	-- ensure that each target message to trigger is in our cancel messages table
	if cancel_messages then
		if not validate.is_string_or_table_of_strings(cancel_messages) then
			return false;
		end;

		for i = 1, #target_messages do
			if not table.contains(cancel_messages, target_messages[i]) then
				table.insert(cancel_messages, target_messages[i]);
			end;
		end;
	else
		cancel_messages = table.copy(target_messages);
	end;

	if intervention_priority and not is_positive_number(intervention_priority) then
		script_error("ERROR: narrative_trigger:new() called for trigger with name [" .. name .. "] and faction [" .. faction_key .. "] but supplied intervention priority [" .. tostring(intervention_priority) .. "] is not a positive number or nil");
		return false;
	end;

	local nt = {};
	
	nt.name, nt.full_name = assemble_narrative_name("TRIGGER", name, faction_key);

	if not core:add_static_object(nt.full_name, nt, "narrative_triggers", false, true) then
		script_error("ERROR: narrative_trigger:new() called but couldn't add narrative trigger with name [" .. nt.full_name .. "] to the static object registry - has a narrative trigger with this name already been created?");
		return false;
	end;

	set_object_class(nt, self);

	nt.faction_key = faction_key;
	
	nt.target_messages = target_messages;
	nt.start_messages = start_messages;
	nt.main_event_and_condition_records = main_event_and_condition_records;
	nt.main_message_and_condition_records = {};
	nt.cancel_messages = cancel_messages;
	nt.start_callbacks = {};
	nt.stop_callbacks = {};
	
	return nt;
end;



----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc A narrative trigger object is created and returned by calling @narrative_trigger:new. Once created, functions on a <code>narrative_trigger</code> may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;narrative_trigger_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example -- name, faction_key, target_messages, main_event_and_condition_records, start_messages, cancel_messages, intervention_priority
--- @example local nt_player_starts_turn_ten = narrative_query:new(
--- @example 	"player_starts_turn_ten",
--- @example 	"wh3_main_ksl_the_ice_court",
--- @example 	"ScriptEventPlayerStartsTurnTen",
--- @example 	{
--- @example 		{
--- @example 			event = "ScriptEventHumanFactionTurnStart",
--- @example 			condition = function(context, nt)
--- @example 				return context:faction():name() == "wh3_main_ksl_the_ice_court"
--- @example 			end,
--- @example 			immediate = true
--- @example 		{
--- @example 	},
--- @example 	nil,
--- @example 	"CancelPlayerStartsTurnTen"
--- @example );
--- @example 
--- @example -- calling a function on the object once created
--- @example nt_player_starts_turn_ten:start()







----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function has_triggered_this_campaign
--- @desc Returns whether this narrative event has triggered in this campaign save.
--- @r @boolean has triggered
function narrative_trigger:has_triggered_this_campaign()
	local status = cm:get_saved_value(self.full_name);

	return status and status ~= NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_NOT_STARTED and status ~= NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED;
end;







----------------------------------------------------------------------------
--- @section Configuration
----------------------------------------------------------------------------


--- @function add_monitor_event
--- @desc Adds a event/condition monitor record to this narrative trigger. This should only be called after the creation of the narrative trigger, but before it is started with @narrative_trigger:start.
--- @p @string event, Event name.
--- @p @function condition, Condition function. This function will be called when the specified event is received, and will be passed the event context and the narrative trigger object as two arguments. It should return a value that evaluates to true if the condition passes, or otherwise if the condition fails.
--- @p_long_desc Alternatively the @boolean value <code>true</code> may be supplied in place of a function, in which case the condition always passes.
--- @p [opt=true] @boolean trigger immediately, Instructs the narrative trigger to fire its target messages immediately if this event/condition pair pass. If <code>false</code> is specified here, and it's a singleplayer game, the triggering of the target messages happens within an intervention.
function narrative_trigger:add_monitor_event(event, condition, immediate)
	
	if not validate.is_string(event) then
		return false;
	end;

	if not condition then
		condition = true;
	end;
	
	if not validate.is_condition(condition) then
		return false;
	end;

	if immediate ~= false then
		immediate = true;
	end;

	if self.running then
		script_error(self.full_name .. " ERROR: add_monitor_event() called but this narrative trigger is already started");
		return false;
	end;
	
	table.insert(
		self.main_event_and_condition_records
		{
			event = event,
			condition = condition,
			immediate = immediate
		}
	);
end;


--- @function add_monitor_message
--- @desc Adds a script message/condition monitor record to this narrative trigger. This should only be called after the creation of the narrative trigger, but before it is started with @narrative_trigger:start.
--- @p @string message, Message name.
--- @p [opt=nil] @function condition, Condition function. This function will be called when the specified message is received, and will be passed the message context and the narrative trigger object as two arguments. It should return a value that evaluates to true if the condition passes, or otherwise if the condition fails.
--- @p_long_desc Alternatively the @boolean value <code>true</code> may be supplied in place of a function, in which case the condition always passes.
--- @p [opt=true] @boolean trigger immediately, Instructs the narrative trigger to fire its target messages immediately if this event/condition pair pass. If <code>false</code> is specified here, and it's a singleplayer game, the triggering of the target messages happens within an intervention.
function narrative_trigger:add_monitor_message(message, condition, immediate)
	
	if not validate.is_string(message) then
		return false;
	end;

	if not condition then
		condition = true;
	end;
	
	if not validate.is_condition(condition) then
		return false;
	end;

	if immediate ~= false then
		immediate = true;
	end;

	if self.running then
		script_error(self.full_name .. " ERROR: add_monitor_message() called but this narrative trigger is already started");
		return false;
	end;
	
	table.insert(
		self.main_message_and_condition_records,
		{
			message = message,
			condition = condition,
			immediate = immediate
		}
	);
end;


--- @function set_should_setup_cancel_listeners_with_start_listeners
--- @desc Sets whether the narrative trigger should start cancel message listeners with start message listeners. If the narrative trigger is set up with both start messages and cancel messages, then by default the cancel message listeners are not started until the start messages are received. Use this function to change this behaviour and allow the narrative trigger to be cancelled before a start message is received.
--- @p [opt=true] @boolean value
function narrative_trigger:set_should_setup_cancel_listeners_with_start_listeners(value)

	if self.running then
		script_error(self.full_name .. " ERROR: set_should_setup_cancel_listeners_with_start_listeners() called but this narrative trigger is already started");
		return false;
	end;

	if value == false then
		self.should_setup_cancel_listeners_with_start_listeners = false;
	else
		self.should_setup_cancel_listeners_with_start_listeners = true;
	end;
end;


--- @function add_start_callback
--- @desc Adds a start callback to the narrative trigger. This will be called when the narrative trigger starts its main monitoring processes, either when the start message is received or on startup (if no start message was specified). If the game is saved and reloaded at this point, causing the main monitors to be restarted, then any start callbacks are called again.
--- @desc A boolean flag will be passed to any start functions to indicate whether the main monitors are being started from a savegame. If the main monitors are not being started from a savegame then it means a start message has just been received - in this case the start message string is supplied to each callback as a second argument.
--- @p @function calllback
function narrative_trigger:add_start_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(self.start_callbacks, callback);
end;


--- @function add_stop_callback
--- @desc Adds a stop callback to the narrative trigger. This will be called when the narrative trigger stops its main monitoring processes, either when a main monitor is satisfied and fires the target message(s), or when a cancel event is received while the main monitors are running. Each stop callback will be passed a flag to indicate whether the narrative trigger's target messages were fired.
--- @p @function calllback
function narrative_trigger:add_stop_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(self.stop_callbacks, callback);
end;


-- Local function to call stop callbacks
local function call_stop_callbacks(nt, target_messages_fired)
	local stop_callbacks = nt.stop_callbacks;
	out.inc_tab("narrative");
	for i = 1, #stop_callbacks do
		stop_callbacks[i](true);
	end;
	out.dec_tab("narrative");
end;













----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Start the narrative trigger. If any start messages have been registered with the narrative trigger then a listener for these is started, otherwise the main event/condition listeners are started.
--- @desc Some main monitor records must have been added to the narrative trigger prior to this function being called, either during construction (see @narrative_trigger:new) or afterwards with @narrative_trigger:add_monitor_event or @narrative_trigger:add_monitor_message.
function narrative_trigger:start()

	--[[
	if #self.main_event_and_condition_records == 0 and #self.main_message_and_condition_records == 0 and not self:has_triggered_this_campaign() then
		script_error(self.full_name .. " ERROR: start() called but no monitor events or messages have been registered");
		return false;
	end;
	]]

	if self.running then
		script_error(self.full_name .. " ERROR: start() called but this narrative trigger is already started");
		return false;
	end;

	self.running = true;

	-- set narrative trigger status from savegame based on name, if it's been set before
	local status = cm:get_saved_value(self.full_name);
	if status then
		self.status = status;
	end;

	self:start_listeners(nil, true);
end;


function narrative_trigger:set_status(status)
	self.status = status;
	cm:set_saved_value(self.full_name, status);
end;


function narrative_trigger:start_listeners(reason_str, is_startup)

	self:stop_listeners();

	local faction_key = self.faction_key;
	local status = self.status;

	if status == NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_NOT_STARTED then

		-- This narrative trigger has not yet started its main monitors been started in the past, so we should start listening for its start events
		local start_messages = self.start_messages;

		-- We have no start messages to listen for in order, so start the main event monitors immediately
		if not start_messages then
			self:set_status(NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED);
			self:start_listeners("no start messages were specified", is_startup);

			return;
		end;

		-- Start start message listeners
		for i = 1, #start_messages do
			sm:add_listener(
				start_messages[i],
				function(context)
					-- A start message has been received - update the status of the narrative trigger, show some output, and then call start_listeners() again which should establish the main listeners
					self:set_status(NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED);
					self.start_message_received = start_messages[i];			-- This value is used only for the start callbacks, and is then unset
					self:start_listeners("start message [" .. start_messages[i] .. "] was received");
				end,
				false,
				function(context)
					return context and context.faction_key == faction_key;
				end,
				self.full_name
			);
		end;

		-- Start cancel event listeners
		if self.should_setup_cancel_listeners_with_start_listeners then
			self:start_cancel_listeners();
			if __narrative_system_debug then
				self:out("Starting - started listeners for start message" .. (#self.start_messages == 1 and " [" or "s [") .. table.concat(self.start_messages, ", ") .. "] and cancel message" .. (#self.cancel_messages == 1 and " [" or "s [") .. table.concat(cancel_events, ", ") .. "]");
			end;
		else
			if __narrative_system_debug then
				self:out("Starting - started listeners for start message" .. (#self.start_messages == 1 and " [" or "s [") .. table.concat(self.start_messages, ", ") .. "]");
			end;
		end;

	elseif status == NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED then

		local events_for_output = {};
		local messages_for_output = {};

		-- Assemble a trigger function
		local function trigger(record, is_message)
			local target_messages = self.target_messages;

			local monitor_type = is_message and "message" or "event";

			if record.immediate ~= false or cm:is_multiplayer() then
				-- A main event or message has been received, and its record is set to trigger immediately or it's a multiplayer game (where everything triggers immediately) - update our status, produce some output, and then generate our target message(s)

				self:stop_listeners();

				self:set_status(NARRATIVE_TRIGGER_STATUS_TRIGGERED);
				if __narrative_system_debug then
					if monitor_type == "event" then
						self:out();
						self:out();	
					end;
					self:out("Main " .. monitor_type .. " [" .. record[monitor_type] .. "] received, and condition passes - immediately triggering target message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "] for faction [" .. self.faction_key .. "]");
				end;

				for i = 1, #target_messages do
					trigger_narrative_script_message(self, target_messages[i]);
				end;

				call_stop_callbacks(self, true);

				-- Call start_listeners() again to stop our listeners and properly complete
				self:start_listeners();
			else
				-- A main event or message has been received, and its record is set to not trigger immediately - update our status, produce some output, and then call start_listeners() again which should set up an intervention

				self:set_status(NARRATIVE_TRIGGER_STATUS_ATTEMPTING_TO_TRIGGER_LOW_PRIORITY);
				if __narrative_system_debug then
					if monitor_type == "event" then
						self:out();
						self:out();
					end;
					self:out("Main " .. monitor_type .. " [" .. record[monitor_type] .. "] received, and condition passes - starting intervention to trigger target message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "]");
				end;
				self:start_listeners();
			end;
		end;



		-- This narrative trigger has received a start message (or none were specified), so we should start its main event monitors
		local main_event_and_condition_records = self.main_event_and_condition_records;
		for i = 1, #main_event_and_condition_records do
			local current_record = main_event_and_condition_records[i];
			
			core:add_listener(
				self.full_name,
				current_record.event,
				function(context)
					return current_record.condition == true or current_record.condition(context, self);
				end,
				function(context)
					trigger(current_record, false);
				end,
				false
			);

			table.insert(events_for_output, current_record.event);
		end;

		local main_message_and_condition_records = self.main_message_and_condition_records;
		for i = 1, #main_message_and_condition_records do
			local current_record = main_message_and_condition_records[i];

			sm:add_listener(
				current_record.message,
				function(context)
					trigger(current_record, true);
				end,
				false,
				function(context)
					return current_record.condition == true or current_record.condition(context, self)
				end,
				self.full_name
			);

			table.insert(messages_for_output, current_record.message);
		end;
		
		-- Start cancel event listeners
		self:start_cancel_listeners();

		if __narrative_system_debug then
			local cancel_messages = self.cancel_messages;
			self:out("Started main event listeners for event" .. (#events_for_output == 1 and "" or "s") .. " [" .. table.concat(events_for_output, ", ") .. "]" .. 
			(#messages_for_output == 0 and "" or ((#cancel_messages > 0 and "," or " and") .. " main message listeners for message" .. (#messages_for_output == 1 and " [" or "s [") .. table.concat(messages_for_output, ", ") .. "]")) .. 
			((cancel_messages and #cancel_messages > 0) and (" and cancel message" .. (#cancel_messages == 1 and " [" or "s [") .. table.concat(cancel_messages, ", ") .. "]") or "") .. (reason_str and (" as " .. tostring(reason_str)) or " on startup"));
		end;

		-- Call start callbacks
		local start_callbacks = self.start_callbacks;
		local start_message_received = self.start_message_received;
		out.inc_tab("narrative");
		for i = 1, #start_callbacks do
			start_callbacks[i](is_startup, start_message_received);
		end;
		out.dec_tab("narrative");
		self.start_message_received = nil;				-- Unset this value once the start messages are called - it's not saved in to the savegame so it's unreliable to pretend to provide it on a permanent basis

		
	elseif status == NARRATIVE_TRIGGER_STATUS_ATTEMPTING_TO_TRIGGER_LOW_PRIORITY then

		if __narrative_system_debug then
			self:out((is_startup and "Starting - " or "") and "attempting to trigger with an intervention with priority [" .. self.intervention_priority .. "]");
		end;

		-- This narrative trigger is attempting to fire its trigger message(s) via an intervention - construct a transient intervention here
		local inv;

		inv = intervention:new(
			self.full_name,								-- unique name
			self.intervention_priority,					-- priority
			function(context)							-- trigger callback
				self:stop_listeners();

				self:set_status(NARRATIVE_TRIGGER_STATUS_TRIGGERED);

				local target_messages = self.target_messages;

				if __narrative_system_debug then
					self:out("Intervention triggered, now triggering message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "] for faction [" .. self.faction_key .. "]");
				end;

				for i = 1, #target_messages do
					trigger_narrative_script_message(self, target_messages[i]);
				end;

				call_stop_callbacks(self, true);

				inv:complete();
			end,
			true,										-- debug output
			true										-- transient (not saved in to savegame)
		);

		inv:add_trigger_condition(
			"ScriptEventHumanFactionTurnStart", 
			function(context)
				return context:faction():name() == faction_key;
			end
		);

		local full_name = self.full_name;

		-- set up a listener by which we can attempt to trigger this intervention immediately
		if not is_startup then
			inv:add_trigger_condition(
				"ScriptEventImmediatelyTriggerNarrativeTrigger",
				function(context)
					return context:full_name() == full_name
				end
			);
		end;

		inv:start();

		self.intervention = inv;

		-- attempt to trigger the intervention if we've got here and we're not starting the script from new or from a savegame
		if not is_startup then
			core:trigger_custom_event("ScriptEventImmediatelyTriggerNarrativeTrigger", {full_name = full_name});
		end;

		self:start_cancel_listeners();

	elseif status == NARRATIVE_TRIGGER_STATUS_TRIGGERED then

		if __narrative_system_debug then
			if is_startup then
				self:out("Not starting as this trigger has been triggered in the past");
			else
				self:out("Triggered, shutting down");
			end;
		end;


	elseif status == NARRATIVE_TRIGGER_STATUS_CANCELLED then

		if __narrative_system_debug then
			if is_startup then
				self:out("Not starting as this trigger has been cancelled in the past");
			else
				self:out("Cancelled, shutting down");
			end;
		end;

	else
		script_error("WARNING: narrative_trigger:start_listeners() called for trigger with name [" .. self.full_name .. "] that has a status value of [" .. tostring(status) .. "] that isn't recognised - how can this have happened. Setting this trigger to be cancelled, but something has gone wrong.");
		self:set_status(NARRATIVE_TRIGGER_STATUS_CANCELLED);
	end;
end;


function narrative_trigger:start_cancel_listeners()
	local cancel_messages = self.cancel_messages;

	if cancel_messages then
		for i = 1, #cancel_messages do
			sm:add_listener(
				cancel_messages[i],
				function(context)
					if self.status == NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED or self.status == NARRATIVE_TRIGGER_STATUS_ATTEMPTING_TO_TRIGGER_LOW_PRIORITY then
						call_stop_callbacks(self, false);
					end;

					self:set_status(NARRATIVE_TRIGGER_STATUS_CANCELLED);

					if __narrative_system_debug then
						self:out("Cancel message [" .. cancel_messages[i] .. "] received, cancelling this trigger");
					end;

					if self.intervention and self.intervention.is_started then
						self.intervention:stop();
					end;

					self:start_listeners();
				end,
				false,
				function(context)
					return not context or (not context.faction_key or context.faction_key == self.faction_key);
				end,
				self.full_name
			);
		end;
	end;
end;


function narrative_trigger:stop_listeners()
	core:remove_listener(self.full_name);
	sm:remove_listener_by_name(self.full_name);
end;











----------------------------------------------------------------------------
--- @section Manipulation
----------------------------------------------------------------------------


function narrative_trigger:out(str)
	if str then
		out.narrative(self.full_name .. ": " .. str);
	else
		out.narrative("");
	end;
end;


--- @function trigger_message
--- @desc Force this narrative trigger to trigger a message, associated with the faction related to this narrative trigger.
--- @p @string message
function narrative_trigger:trigger_message(message)
	trigger_narrative_script_message(self, message);
end;


--- @function force_main_trigger
--- @desc Instruct this narrative trigger to act as if one of its main monitors has been triggered. The narrative trigger must be in the correct phase, where its main monitors are active. A reason string may be supplied for output purposes.
--- @p [opt=nil] @string reason, Reason string.
--- @p [opt=true] @boolean immediate, Force the narrative trigger to trigger its target messages immediately. If this is set to <code>false</code>, and it's a singleplayer game, then the narrative trigger will trigger the target messages within an intervention.
function narrative_trigger:force_main_trigger(reason, immediate)

	if reason and not validate.is_string(reason) then
		return false;
	end;
	
	if self.status ~= NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_NOT_STARTED and self.status ~= NARRATIVE_TRIGGER_STATUS_MAIN_MONITORS_STARTED then
		script_error(self.full_name .. " ERROR: force_main_trigger() called but this narrative trigger's main monitors have already triggered");
		return false;
	end;

	if not reason or string.len(reason) == 0 then
		reason = "<no reason specified>";
	end;

	local target_messages = self.target_messages;

	if immediate ~= false or cm:is_multiplayer() then
		self:stop_listeners();

		self:set_status(NARRATIVE_TRIGGER_STATUS_TRIGGERED);
		if __narrative_system_debug then
			self:out("immediately triggering target message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "] for faction [" .. self.faction_key .. "] for reason: " .. reason);
		end;

		for i = 1, #target_messages do
			trigger_narrative_script_message(self, target_messages[i]);
		end;

		call_stop_callbacks(self, true);

		-- Call start_listeners() again to stop our listeners and properly complete
		self:start_listeners();
	else
		self:set_status(NARRATIVE_TRIGGER_STATUS_ATTEMPTING_TO_TRIGGER_LOW_PRIORITY);
		if __narrative_system_debug then
			self:out("starting intervention to trigger target message" .. (#target_messages == 1 and "" or "s") .. " [" .. table.concat(target_messages, ", ") .. "] for faction [" .. self.faction_key .. "] for reason: " .. reason);
		end;
		self:start_listeners();
	end;
end;




