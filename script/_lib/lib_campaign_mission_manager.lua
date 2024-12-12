



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN MISSION MANAGER
--
---	@set_environment campaign
--- @c mission_manager Mission Managers
--- @desc Mission managers can be used to set up and manage scripted missions issued to the player. It isn't necessary to set up a mission manager in order to trigger a scripted mission, but they provide certain benefits:
--- @desc <ul><li>Success, failure, cancellation and nearing-expiry callbacks may be registered with the mission manager, which calls these when the mission reaches a certain state.</li>
--- @desc <li>Missions in the game may be triggered from a mission string - the mission manager offers easy methods to construct such a string.</li>
--- @desc <li>Missions may be set up with scripted objectives - success and/or fail conditions that are triggered by script, allowing mission completion conditions to be implemented of arbitrary complexity, or that aren't supported natively by the game. Mission managers provide a framework for allowing this to be set up relatively easily.</li>
--- @desc <li>Mission managers may be set up with first time and each time startup callbacks (see @mission_manager:add_first_time_trigger_callback and @mission_manager:add_each_time_trigger_callback for more details) allowing other scripts to be started while the mission is running.</li></ul>
--- @desc Mission managers can also be used to trigger incidents and dilemmas.
--
--- @section Different Methods of Specifying Objectives
--- @desc Most missions are only composed of one individual objective, but more than one is supported (chapter missions tend to have more). The objectives that make up a mission may be specified in one of three ways:
--- @desc <ul><li>A mission may be constructed from a mission string. Refer to the section on @"mission_manager:Constructing From Strings" to see how to do this.
--- @desc <ul><li>Mission objectives may be scripted, which means that it is the responsibility of script to monitor completion/failure conditions and notify the game. Scripted objectives may be set up using the functions in the @"mission_manager:Scripted Objectives" section. Scripted objectives are constructed internally from a mission string and as such can't be combined with mission records from the database or missions.txt file (see following points).</li></ul></li>
--- @desc <li>A mission may build its objectives from records in the database (see the <code>cdir_events_mission_option_junctions</code> table). To set a mission to build its objectives from the database set it to trigger from the database with @mission_manager:set_is_mission_in_db, @mission_manager:set_is_incident_in_db or @mission_manager:set_is_dilemma_in_db and do not add any text objectives (see @mission_manager:add_new_objective).</li>
--- @desc <li>Mission strings may also be baked into the missions.txt file that accompanies each campaign. This is the default option, but arguably the least desirable and flexible.</li></ul>
--
--- @section Persistence
--- @desc If a mission manager has been set up to use certain features then it is classified as persistent. Persistent mission managers have script values that are saved into the savegame so the mission manager can know whether to start certain listeners when a saved game is loaded. As such, persistent mission managers must be declared and set up prior to the first tick.
--- @desc Features that set a mission manager to be persistent are:
--- @desc <ul><li>Any success, failure, cancellation or nearing-expiry callbacks.</li>
--- @desc <li>Any @"mission_manager:Scripted Objectives".</li>
--- @desc <li>Any @"mission_manager:Persistent Values".</li>
--- @desc <li>One or more each-time startup callbacks added with @mission_manager:add_each_time_trigger_callback.</li></ul>
--- @desc Mission managers that are not persistent are "fire and forget", meaning they can be discarded once triggered. The underlying campaign model will remember that a mission has been triggered, the script mission manager does not need to be re-established if the game is reloaded.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Mission manager now passes one of these values through to either success, failure or cancellation callback.
-- This allows the same callback to be registered for all three and for that callback to know how the mission finished.
MISSION_MANAGER_MISSION_SUCCEEDED = 0;
MISSION_MANAGER_MISSION_FAILED = 1;
MISSION_MANAGER_MISSION_CANCELLED = 2;


mission_manager = {
	faction_name = "",
	mission_key = "",
	started = false,
	completed = false,
	success_callback = nil,
	failure_callback = nil,
	cancellation_callback = nil,
	nearing_expiry_callback = nil,
	is_mission_when_triggering_from_db = true,
	is_incident_when_triggering_from_db = false,
	is_dilemma_when_triggering_from_db = false,
	is_dilemma_in_intervention = false,
	should_whitelist = true,
	
	-- for triggering from string
	should_trigger_from_string = false,
	should_trigger_from_db = false,
	mission_issuer = "CLAN_ELDERS",
	victory_type = false,
	turn_limit = false,			-- set to a number to activate
	position_x = false,			-- set to a number to activate. will only be used with a SCRIPTED objective type
	position_y = false,			-- set to a number to activate. will only be used with a SCRIPTED objective type
	objectives = {},
	mission_string = "",
	is_registered = false,
	should_cancel_before_issuing_override = true,
	chapter_mission = false, 	-- set to number to activate
	scripted_objectives_unique_counter = 0,
	show_mission = true,
	victory_mission = false,
	
	-- for scripted mission types
	scripted_objectives = {},

	-- persistent values saved to savegame
	persistent_values = {},

	-- startup callbacks
	first_time_startup_callbacks = {},
	each_time_startup_callbacks = {}
};


set_class_custom_type(mission_manager, TYPE_MISSION_MANAGER);
set_class_tostring(
	mission_manager, 
	function(obj)
		return TYPE_MISSION_MANAGER .. "_" .. obj.faction_name .. "_" .. obj.mission_key
	end
);









----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a mission manager object. A faction name for the mission recipient and a mission key must be specified at the very least. The mission key must match a record in the <code>missions</code> table, which must be present in all cases.
--- @desc A mission success callback, a mission failure callback, a mission cancellation callback and a mission nearing-expiry callback may optionally also be specified. Setting any of these also sets the mission to be persistent, which creates extra requirements for how the mission manager is declared - see the section above on @mission_manager:Persistence.
--- @p string faction name, Name of faction that will be receiving this mission.
--- @p string mission key, Key corresponding to a record in the <code>missions</code> table.
--- @p [opt=nil] function success callback, Callback to call if the mission is successfully completed. Setting this makes the mission manager persistent.
--- @p [opt=nil] function failure callback, Callback to call if the mission is failed. Setting this makes the mission manager persistent.
--- @p [opt=nil] function cancellation callback, Callback to call if the mission is cancelled. Setting this makes the mission manager persistent.
--- @p [opt=nil] function nearing-expiry callback, Callback to call if the mission is nearing expiry. Setting this makes the mission manager persistent.
--- @r mission_manager Mission manager object
function mission_manager:new(faction_name, mission_key, success_callback, failure_callback, cancellation_callback, nearing_expiry_callback)
	if not is_string(faction_name) then
		script_error("ERROR: mission_manager:new() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		script_error("ERROR: mission_manager:new() called but couldn't find a faction with supplied name [" .. faction_name .. "]");
		return false;
	end;
	
	if not faction:is_human() then
		script_error("ERROR: mission_manager:new() called but faction with supplied name [" .. faction_name .. "] is not human");
		return false;
	end;

	if not is_string(mission_key) then
		script_error("ERROR: mission_manager:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("ERROR: mission_manager:new() called but supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if not is_function(failure_callback) and not is_nil(failure_callback) then
		script_error("ERROR: mission_manager:new() called but supplied failure callback [" .. tostring(failure_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if not is_function(cancellation_callback) and not is_nil(cancellation_callback) then
		script_error("ERROR: mission_manager:new() called but supplied cancellation callback [" .. tostring(cancellation_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if not is_function(nearing_expiry_callback) and not is_nil(nearing_expiry_callback) then
		script_error("ERROR: mission_manager:new() called but supplied nearing-expiry callback [" .. tostring(nearing_expiry_callback) .. "] is not a function or nil");
		return false;
	end;
	
	local mm = {};

	mm.faction_name = faction_name;
	mm.mission_key = mission_key;
	
	set_object_class(mm, self);

	mm.objectives = {};
	mm.scripted_objectives = {};
	mm.persistent_values = {};
	mm.first_time_startup_callbacks = {};
	mm.each_time_startup_callbacks = {};
	
	mm.success_callback = success_callback;
	mm.failure_callback = failure_callback;
	mm.cancellation_callback = cancellation_callback;
	mm.nearing_expiry_callback = nearing_expiry_callback;
	
	-- If any of the success/failure/etc callbacks are set then set this mission manager to be persistent and register it with the campaign manager.
	-- A not-persistent mission manager supports multiple missions of the same key being triggered, but doesn't support any
	-- success/failure callbacks as the script/code cannot tell the difference between two missions with the same key. Furthermore,
	-- the mission manager state doesn't get saved into the savegame (the mission itself does, however). In this case, the mission
	-- manager is still useful to allow the scripter easy set up of a mission string.
	-- If a mission manager is later set up with a scripted objective, this also sets the mission to be persistent/saved into the
	-- savegame, with the same restriction of not allowing multiple missions with the same key.
	if success_callback or failure_callback or cancellation_callback or nearing_expiry_callback then
		mm:register();
	end;
	
	return mm;
end;


-- Internal function to register this mission manager with the campaign manager so that its state gets saved.
-- This is called by mission managers which have completion callbacks, persistent info or scripted objectives set.
function mission_manager:register()
	if not self.is_registered then
	
		if cm:register_mission_manager(self) then
			self.is_registered = true;
		end;
	end;
end;







----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a <code>mission_manager</code> object has been created with @mission_manager:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;mission_manager_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local mm_emp_05 = mission_manager:new("wh_main_emp_empire", "wh_empire_mission_05");
--- @example 
--- @example -- calling a function on the object once created
--- @example mm_emp_05:add_first_time_trigger_callback(function() out("mm_emp_05 starting") end)
----------------------------------------------------------------------------






----------------------------------------------------------------------------
--- @section Global Configuration Options
--- @desc The functions in this section apply changes to the behaviour of the mission manager regardless of the type of mission being triggered.
----------------------------------------------------------------------------


--- @function set_should_cancel_before_issuing
--- @desc When it goes to trigger the mission manager will, if the mission is persistent (see @mission_manager:Persistence), issue a call to cancel any mission with the key specified in @mission_manager:new before issuing its mission. This behaviour can be disabled, or enabled for non-persistent missions, by calling this function.
--- @p [opt=true] @boolean cancel before issuing
function mission_manager:set_should_cancel_before_issuing(value)
	if value == false then
		self.should_cancel_before_issuing_override = false;
	else
		self.should_cancel_before_issuing_override = true;
	end;
end;


--- @function set_should_whitelist
--- @desc When it goes to trigger the mission manager will, by default, add the relevant mission/dilemma/incident type to the event whitelist so that it triggers even if event messages are currently suppressed (see @campaign_manager:suppress_all_event_feed_messages). Events are commonly suppressed when an @intervention is triggering, for example. Use this function to disable this behaviour, if required, so that the triggered event is not whitelisted and does not show.
--- @p [opt=true] @boolean should whitelist
function mission_manager:set_should_whitelist(value)
	if value == false then
		self.should_whitelist = false;
	else
		self.should_whitelist = true;
	end;
end;


--- @function set_show_mission
--- @desc Activates/deactivates the showing of the mission event as it is triggered. By default, the event message is shown - this function may be used to disable this behaviour. When this setting is disabled, the mission manager will use @episodic_scripting:disable_event_feed_events to suppress the mission subcategory prior to triggering, and then again to unsuppress mission event once triggered.
--- @desc This setting only takes effect if the mission manager is triggering a mission. It has no effect if the mission manager has been set to trigger an incident or dilemma with @mission_manager:set_is_incident_in_db or @mission_manager:set_is_dilemma_in_db.
--- @p [opt=true] @boolean show event
function mission_manager:set_show_mission(value)
	if value == false then
		self.show_mission = false;
	else
		self.show_mission = true;
	end;
end;


--- @function set_victory_mission
--- @desc Specifies that this mission is a victory condition. These missions have different string formatting, so use their own function for constructing the strings.
--- @desc This setting only takes effect if the mission manager is triggering a mission via string. It has no effect if the mission manager has been set to trigger an incident or dilemma with @mission_manager:set_is_incident_in_db or @mission_manager:set_is_dilemma_in_db.
--- @p [opt=true] @boolean show event
function mission_manager:set_victory_mission(value)
	if value == false then
		self.victory_mission = false;
	else
		self.victory_mission = true;
	end;
end;



----------------------------------------------------------------------------
--- @section Startup Callbacks
----------------------------------------------------------------------------


--- @function add_first_time_trigger_callback
--- @desc Specifies a callback to call, one time, when the mission is first triggered. This can be used to set up other scripts or game objects for this mission.
--- @p @function callback
function mission_manager:add_first_time_trigger_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_first_time_trigger_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_time_startup_callbacks, callback);
end;


--- @function add_each_time_trigger_callback
--- @desc Adds a callback to call each time the mission is triggered, either for the first time or subsequently from a savegame. This can be used to set up other scripts or game objects for this mission each time the script is loaded, or to set up the mission manager itself with @"mission_manager:Persistent Values". Each-time callbacks are called after any first-time callbacks added with @mission_manager:add_each_time_trigger_callback.
--- @p @function callback
function mission_manager:add_each_time_trigger_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_each_time_trigger_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	table.insert(self.each_time_startup_callbacks, callback);
end;


-- internal function to call first/each time trigger callbacks
function mission_manager:call_trigger_callbacks(first_time)
	local first_time_callbacks;
	local each_time_callbacks = table.copy(self.each_time_startup_callbacks);

	if first_time then
		first_time_callbacks = table.copy(self.first_time_startup_callbacks);

		for i = 1, #first_time_callbacks do
			first_time_callbacks[i]();
		end;
	end;

	for i = 1, #each_time_callbacks do
		each_time_callbacks[i]();
	end;	
end;











----------------------------------------------------------------------------
--- @section Constructing From Strings
--- @desc Mission managers provide a mode where the mission being triggered is constructed from a @string. Example of such strings can be found in the <code>missions.txt</code> found in <code>data/campaigns/&lt;campaign_name&gt;/</code> for some campaigns. The main advantage of constructing missions from strings is that their initial setup may be dynamically constructed depending on game conditions at the time.
--- @desc If new objectives are added with @mission_manager:add_new_objective then the mission manager will be set to construct its mission with a string. It will subsequently attempt to construct the mission specification string when the mission is later triggered, with only the properties set in the <code>missions</code> table remaining immutable. The functions in this section are used to tell the mission manager what to put in the mission construction string.
--- @desc @mission_manager:add_new_objective is called to add a new objective to the mission. The first objective added is the primary objective; any further objectives added are treated as secondary/bonus objectives. Objective configuration functions such as @mission_manager:add_condition and @mission_manager:add_payload act on the most recently-added objective, so the ordering of these setup functions is important. At the very least at least one objective and one payload should be set using the functions below before the mission manager is triggered.
----------------------------------------------------------------------------


--- @function add_new_objective
--- @desc Adds a new objective type to the mission specification, and also sets the mission manager to construct its mission from a string.
--- @desc Multiple objectives may be added to a mission with this function. The first shall be the primary objective of the mission, while subsequent additions shall be set up as secondary objectives.
--- @p string objective type
--- @example mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM")
function mission_manager:add_new_objective(objective_type)
	if not is_string(objective_type) then
		script_error("ERROR: add_new_objective() called on mission manager for mission key [" .. self.mission_key .. "] but supplied objective type [" .. tostring(objective_type) .. "] is not a string");
		return false;
	end;
	
	local objective_record = {};
	objective_record.objective_type = objective_type;
	objective_record.conditions = {};
	objective_record.payloads = {};
	objective_record.failure_payloads = {};
	
	table.insert(self.objectives, objective_record);
	
	self.should_trigger_from_string = true;
end;


--- @function add_condition
--- @desc Adds a condition to the objective last added with @mission_manager:add_new_objective. Multiple conditions are commonly added - each objective type has different mandatory and optional conditions.
--- @p string condition
--- @example mm:add_condition("total 1")
--- @example mm:add_condition("building_level wh_main_emp_port_2")
function mission_manager:add_condition(condition)
	if not is_string(condition) then
		script_error("ERROR: add_condition() called on mission manager for mission key [" .. self.mission_key .. "] but supplied objective condition [" .. tostring(condition) .. "] is not a string");
		return false;
	end;
	
	if #self.objectives == 0 then
		script_error("ERROR: add_condition() called on mission manager for mission key [" .. self.mission_key .. "] but no objectives have been previously set up with add_new_objective(). Set one up before calling this.");
		return false;
	end;
		
	table.insert(self.objectives[#self.objectives].conditions, condition);
end;


-- Internal function to break down a payload string so that it's pre-string, number and post-string are
-- returned separately if its a suitable payload type, otherwise nil is returned.
local function break_down_payload_string(payload_str)

	-- eligible payload types are those that contain only one numeric value and where it might make sense to combine multiple payloads into one
	if string.starts_with(payload_str, "faction_pooled_resource_transaction") or 
			string.starts_with(payload_str, "adjust_loyalty_for_faction") or 
			string.starts_with(payload_str, "province_slaves_change") or 
			string.starts_with(payload_str, "faction_slaves_change") or
			string.starts_with(payload_str, "money") or
			string.starts_with(payload_str, "influence") or
			string.starts_with(payload_str, "honour") or
			string.starts_with(payload_str, "diplomacy_change") then

		local payload_value = string.match(payload_str, "%s+(%d+)");
		if payload_value then
			local payload_value_start, payload_value_end = string.find(payload_str, payload_value);
			return string.sub(payload_str, 1, payload_value_start - 1), payload_value, string.sub(payload_str, payload_value_end + 1);
		end;
	end;
end;


--- @function add_payload
--- @desc Adds a payload (reward) to the objective last added with @mission_manager:add_new_objective. Many different payload types exists: <code>faction_pooled_resource_transaction, add_mercenary_to_faction_pool, adjust_loyalty_for_faction, province_slaves_change, faction_slaves_change, money, influence, honour, grant_unit, grant_agent, ancillary, effect_bundle, rebellion, demolish_chain, damage_buildings, damage_character, building_restriction, unit_restriction, issue_mission,</code> and <code>game_victory</code>. Each has a different parameter requirement - see existing examples or a programmer for more information.
--- @desc The function will optionally attempt to combine this payload reward with others of the same type if they are found, if the <code>enable combining</code> parameter is set to <code>true</code>.
--- @p @string payload
--- @p [opt=false] @boolean enable payload combining
--- @new_example Adding money as a mission reward
--- @example mm:add_payload("money 1000")
--- @new_example Adding a pooled resource as a mission reward
--- @example mm:add_payload("faction_pooled_resource_transaction{resource dwf_oathgold;factor grudges;amount 10;context absolute;}")
--- @new_example Adding influence as a mission reward
--- @example mm:add_payload("influence 5")
--- @new_example Adding effect bundle as a mission reward
--- @example mm:add_payload("effect_bundle{bundle_key wh_dlc06_bundle_eight_peaks_recapture;turns 0;}")
function mission_manager:add_payload(payload, enable_combining)
	if not is_string(payload) then
		script_error("ERROR: add_payload() called on mission manager for mission key [" .. self.mission_key .. "] but supplied payload [" .. tostring(payload) .. "] is not a string");
		return false;
	end;
	
	if #self.objectives == 0 then
		script_error("ERROR: add_payload() called on mission manager for mission key [" .. self.mission_key .. "] but no objectives have been previously set up with add_new_objective(). Set one up before calling this.");
		return false;
	end;

	-- table to add payload to
	local payload_table = self.objectives[#self.objectives].payloads;
	
	if enable_combining then
		-- attempt to get a numerical value from the payload passed in to the function
		local pre_payload_value_str, payload_value, post_payload_value_str = break_down_payload_string(payload);

		if tonumber(payload_value) then
			-- if we have a numerical value, then search through the already-added payload strings for a matching payload
			for i = 1, #payload_table do
				local current_pre_payload_value_str, current_payload_value, current_post_payload_value_str = break_down_payload_string(payload_table[i]);

				if current_pre_payload_value_str == pre_payload_value_str and tonumber(current_payload_value) then
					-- insert the combined payload value back into the payload string
					payload_table[i] = current_pre_payload_value_str .. tostring(tonumber(payload_value) + tonumber(current_payload_value)) .. current_post_payload_value_str;
					return;
				end;
			end;
		end;
	end;

	-- insert payload unmodified
	table.insert(payload_table, payload);
end;


--- @function add_payload_from_mission_manager
--- @desc Adds the mission payloads from another mission manager to this mission manager.
--- @p @mission_manager mm
--- @r @boolean payloads successfully added
function mission_manager:add_payload_from_mission_manager(mm)
	if not is_missionmanager(mm) then
		script_error("ERROR: add_payload_from_mission_manager() called but supplied mission manager [" .. tostring(mm) .. "] is not a valid mission_manager");
		return false;
	end;

	if #mm.objectives == 0 then
		return false;
	end;

	for i = 1, #mm.objectives do
		local payload_list = mm.objectives[i].payloads;

		for j = 1, #payload_list do
			self:add_payload(payload_list[j], true);
		end;
	end;

	return true;
end;

--- @function add_failure_payload
--- @desc Adds a payload (on mission faiure) to the objective last added with @mission_manager:add_new_objective. Many different payload types exists - the following list is pulled from code: <code>faction_pooled_resource_transaction, add_mercenary_to_faction_pool, adjust_loyalty_for_faction, province_slaves_change, faction_slaves_change, money, influence, honour, grant_unit, grant_agent, effect_bundle, rebellion, demolish_chain, damage_buildings, damage_character, building_restriction, unit_restriction, issue_mission,</code> and <code>game_victory</code>. Each has a different parameter requirement - see existing examples or a programmer for more information.
--- @p string payload
--- @new_example Taking away money as a mission failure
--- @example mm:add_failure_payload("money -1000")
--- @new_example Taking away a pooled resource as a mission failure
--- @example mm:add_failure_payload("faction_pooled_resource_transaction{resource dwf_oathgold;factor wh2_main_resource_factor_missions;amount -10;}")
--- @new_example Decreasing influence as a mission failure
--- @example mm:add_failure_payload("influence -5")
--- @new_example Adding effect bundle as a mission failure
--- @example mm:add_failure_payload("effect_bundle{bundle_key wh_dlc06_bundle_eight_peaks_recapture;turns 0;}")
function mission_manager:add_failure_payload(payload)
	if not is_string(payload) then
		script_error("ERROR: add_failure_payload() called on mission manager for mission key [" .. self.mission_key .. "] but supplied payload [" .. tostring(payload) .. "] is not a string");
		return false;
	end;
	
	if #self.objectives == 0 then
		script_error("ERROR: add_failure_payload() called on mission manager for mission key [" .. self.mission_key .. "] but no objectives have been previously set up with add_new_objective(). Set one up before calling this.");
		return false;
	end;

	table.insert(self.objectives[#self.objectives].failure_payloads, payload);
end;

--- @function add_heading
--- @desc Adds a heading key override for the objective last added with @mission_manager:add_new_objective. This should be supplied as a string in the full localised text format <code>[table]_[field]_[record]</code>.
--- @p string heading key
function mission_manager:add_heading(heading)
	if not is_string(heading) then
		script_error("ERROR: add_heading() called on mission manager for mission key [" .. self.mission_key .. "] but supplied heading key [" .. tostring(heading) .. "] is not a string");
		return false;
	end;
	
	if #self.objectives == 0 then
		script_error("ERROR: add_heading() called on mission manager for mission key [" .. self.mission_key .. "] but no objectives have been previously set up with add_new_objective(). Set one up before calling this.");
		return false;
	end;
		
	self.objectives[#self.objectives].heading = heading;
end;


--- @function add_description
--- @desc Adds a description key override for the objective last added with @mission_manager:add_new_objective. This should be supplied as a string in the full localised text format <code>[table]_[field]_[record]</code>.
--- @p string description key
function mission_manager:add_description(description)
	if not is_string(description) then
		script_error("ERROR: add_description() called on mission manager for mission key [" .. self.mission_key .. "] but supplied description key [" .. tostring(description) .. "] is not a string");
		return false;
	end;
	
	if #self.objectives == 0 then
		script_error("ERROR: add_description() called on mission manager for mission key [" .. self.mission_key .. "] but no objectives have been previously set up with add_new_objective(). Set one up before calling this.");
		return false;
	end;
		
	self.objectives[#self.objectives].description = description;
end;


--- @function set_turn_limit
--- @desc Sets a turn limit for the entire mission. This is optional.
--- @p number turn limit
--- @new_example Mission expires in 5 turns
--- @example mm:set_turn_limit(5)
function mission_manager:set_turn_limit(turn_limit)
	if not is_number(turn_limit) then
		script_error("ERROR: set_turn_limit() called on mission manager for mission key [" .. self.mission_key .. "] but supplied turn limit [" .. tostring(turn_limit) .. "] is not a number");
		return false;
	end;
	
	self.turn_limit = turn_limit;
end;


--- @function set_chapter
--- @desc Sets this mission to be a particular chapter mission, which affects how it is displayed and categorised on the UI.
--- @p number chapter number
--- @new_example Mission is first chapter mission
--- @example mm:set_chapter(1)
function mission_manager:set_chapter(chapter)
	if not is_number(chapter) then
		script_error("ERROR: set_chapter() called on mission manager for mission key [" .. self.mission_key .. "] but supplied chapter [" .. tostring(chapter) .. "] is not a number");
		return false;
	end;
	
	self.chapter_mission = chapter;
end;


--- @function set_mission_issuer
--- @desc Sets an issuer for this mission, which determines some aspects of the mission's presentation. By default this is set to "CLAN_ELDERS", but use this function to change this. A list of valid mission issuers can be found in the <code>mission_issuers</code> table.
--- @p string mission issuer
function mission_manager:set_mission_issuer(issuer)
	if not is_string(issuer) then
		script_error("ERROR: set_mission_issuer() called on mission manager for mission key [" .. self.mission_key .. "] but supplied issuer [" .. tostring(issuer) .. "] is not a string");
		return false;
	end;
	
	self.mission_issuer = issuer;
end;


--- @function set_position
--- @desc Sets a position for this mission, which is used to zoom to a location.
--- @p @number x, Logical x co-ordinate
--- @p @number y, Logical y co-ordinate
function mission_manager:set_position(x, y)
	if not validate.is_positive_number(x) or not validate.is_positive_number(y) then
		return false;
	end;
	
	self.position_x = x;
	self.position_y = y;
end;


--- @function set_victory_type
--- @desc Sets a victory type for this mission, which is used for victory conditions only. A list of valid victory types can be found in the <code>victory_types</code> table.
--- @p string victory type
function mission_manager:set_victory_type(victory_type)
	if not is_string(victory_type) then
		script_error("ERROR: set_victory_type() called on mission manager for mission key [" .. self.mission_key .. "] but supplied victory type [" .. tostring(victory_type) .. "] is not a string");
		return false;
	end;
	
	self.victory_type = victory_type;
end;










----------------------------------------------------------------------------
--- @section Scripted Objectives
--- @desc Missions may contain scripted objectives, where the script is responsible for their monitoring and completion. Scripted objectives are constructed from strings, and set the mission manager into a mode where it will construct all its objectives in this way. As such they cannot be used in combination with objectives from the database or from the missions.txt file.
--- @desc A scripted objective may be added to the mission manager with @mission_manager:add_new_scripted_objective, which sets some display text and an initial success monitor - some script which determines when the mission has been succeeded. Once a scripted objective has been added, additional success or failure monitors may be added with @mission_manager:add_scripted_objective_success_condition and @mission_manager:add_scripted_objective_failure_condition.
--- @desc Scripted objectives may also be forceably succeeded or failed by external scripts calling @mission_manager:force_scripted_objective_success or @mission_manager:force_scripted_objective_failure, and their displayed text may be updated with @mission_manager:update_scripted_objective_text.
--- @desc If multiple scripted objectives are to be added they may optionally be individually named by giving them a script key. This allows individual target objectives to be specified when calling @mission_manager:add_scripted_objective_success_condition, @mission_manager:add_scripted_objective_failure_condition, @mission_manager:force_scripted_objective_success or @mission_manager:force_scripted_objective_failure, which will otherwise just target the first scripted objective in the mission.
--- @desc As mentioned in the section on @mission_manager:Persistence, setting a scripted objective forces the mission manager to be persistent, which means it must have a unique key and must be set up somewhere in the root of the script so that it's declared by the time the first tick happens after loading.
----------------------------------------------------------------------------


--- @function add_new_scripted_objective
--- @desc Adds a new scripted objective, along with some text to display, a completion event and condition to monitor. An optional script name for this objective may also be specified, which can be useful if there is more than one objective.
--- @p string display text, Display text for this objective. This should be supplied as a full localisation key, i.e. <code>[table]_[field]_[key]</code>.
--- @p string event, Script event name of mission success condition.
--- @p function condition, A function that returns a boolean value when called. The function will be passed the context of the event specified in the second parameter. Alternatively, if no conditional test needs to be performed then <code>true</code> may be supplied in place of a function block.
--- @p_long_desc While the mission is active the mission manager listens for the event specified in the second parameter. When it is received, the condition specified here is called. If it returns <code>true</code>, or if <code>true</code> was specified in place of a condition function, the mission objective is marked as being successfully completed.
--- @p [opt=nil] string script name, Script name for this objective. If specified, this allows calls to @mission_manager:add_scripted_objective_success_condition, @mission_manager:add_scripted_objective_failure_condition, @mission_manager:force_scripted_objective_success or @mission_manager:force_scripted_objective_failure to target this objective (they target the first objective by default).
--- @r @string script name of the new scripted objective
--- @new_example
--- @desc An example scripted objective that is completed when the player researches a technology.
--- @example mm:add_new_scripted_objective(
--- @example 	"mission_text_text_research_technology_mission_objective",
--- @example 	"ResearchCompleted",
--- @example 	function(context)
--- @example 		return context:faction():name() == cm:get_local_faction_name();
--- @example 	end;
--- @example );
function mission_manager:add_new_scripted_objective(override_text, event, condition, script_key)

	if not is_string(override_text) then
		script_error("ERROR: add_scripted_mission_objective() called but supplied override text key [" .. tostring(override_text) .. "] is not a string");
		return false;
	end;
	
	if not is_string(event) then
		script_error("ERROR: add_scripted_mission_objective() called but supplied event name (" .. tostring(event) .. ") is not a string");
		return false;
	end;
	
	if not is_function(condition) and not is_boolean(condition) then
		script_error("ERROR: add_scripted_mission_objective() called but supplied condition (" .. tostring(condition) .. ") is not a string or a boolean");
		return false;
	end;

	-- Check that a scripted objective with this override text has not already been registered. If so, it's likely someone has copied/pasted the call to 
	-- add_new_scripted_objective() in the client script where they actually meant to add a new success condition with add_scripted_objective_success_condition()
	local scripted_objectives = self.scripted_objectives;
	for i = 1, #scripted_objectives do
		if scripted_objectives[i].override_text == override_text then
			script_error("ERROR: add_scripted_mission_objective() called but an objective with override text [" .. override_text .. "] has already been registered for mission with key [" .. self.mission_key .. "]");
			return false;
		end;
	end;

	if not script_key then
		self.scripted_objectives_unique_counter = self.scripted_objectives_unique_counter + 1;
		script_key = self.mission_key .. "_" .. self.scripted_objectives_unique_counter;
	end;
		
	local objective_record = {
		["script_key"] = script_key,
		["is_completed"] = false, 
		["override_text"] = override_text,   
		["success_conditions"] = {},
		["failure_conditions"] = {}
	};
	
	table.insert(scripted_objectives, objective_record);
	
	self:add_new_objective("SCRIPTED");
	self:add_condition("script_key " .. script_key);
	self:add_condition("override_text " .. override_text);
	
	self:add_scripted_objective_success_condition(event, condition, script_key);
	
	-- register this mission manager as persistent
	self:register();

	return script_key;
end;


--- @function add_scripted_objective_success_condition
--- @desc Adds a new success condition to a scripted objective. scripted objective. If a script key is specified the success condition is added to the objective with this key (assuming it exists), otherwise the success condition is added to the first scripted objective.
--- @p string event, Script event name of mission success condition.
--- @p function condition, A function that returns a boolean value when called. The function will be passed the context of the event specified in the second parameter. Alternatively, if no conditional test needs to be performed then <code>true</code> may be supplied in place of a function block.
--- @p_long_desc While the mission is active the mission manager listens for the event specified in the second parameter. When it is received, the condition specified here is called. If it returns <code>true</code>, or if <code>true</code> was specified in place of a condition function, the mission objective is marked as being successfully completed.
--- @p [opt=nil] string script name, Script name of the scripted objective to append this success condition to.
function mission_manager:add_scripted_objective_success_condition(event, condition, script_key)
	return self:add_scripted_objective_completion_condition(true, event, condition, script_key);
end;


--- @function add_scripted_objective_failure_condition
--- @desc Adds a new failure condition to a scripted objective. scripted objective. If a script key is specified the failure condition is added to the objective with this key (assuming it exists), otherwise the failure condition is added to the first scripted objective.
--- @p string event, Script event name of mission failure condition.
--- @p function condition, A function that returns a boolean value when called. The function will be passed the context of the event specified in the second parameter. Alternatively, if no conditional test needs to be performed then <code>true</code> may be supplied in place of a function block.
--- @p_long_desc While the mission is active the mission manager listens for the event specified in the second parameter. When it is received, the condition specified here is called. If it returns <code>true</code>, or if <code>true</code> was specified in place of a condition function, the mission objective is marked as being failed.
--- @p [opt=nil] string script name, Script name of the scripted objective to append this failure condition to.
function mission_manager:add_scripted_objective_failure_condition(event, condition, script_key)
	return self:add_scripted_objective_completion_condition(false, event, condition, script_key);
end;


-- internal function
function mission_manager:add_scripted_objective_completion_condition(is_success, event, condition, script_key)

	if not is_boolean(is_success) then
		script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called but supplied is_success flag [" .. tostring(is_success) .. "] is not a boolean value. Has this function been called directly?");
		return false;
	end;		
	
	if not is_string(event) then
		script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called but supplied event name [" .. tostring(event) .. "] is not a string");
		return false;
	end;
	
	if not is_function(condition) and condition ~= true then
		script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called but supplied condition [" .. tostring(condition) .. "] is not a string or true");
		return false;
	end;
	
	if script_key and not is_string(script_key) then
		script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called but supplied script_key [" .. tostring(script_key) .. "] is not a string or nil");
		return false;
	end;
	
	local scripted_objectives = self.scripted_objectives;
	local scripted_objective_record = false;
	
	-- support the case that no script_key is supplied
	if not script_key then
	
		-- there must be exactly one scripted objective record registered in this case
		if #scripted_objectives ~= 1 then
			script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called with no script_key defined, and there is not exactly one scripted objective record (number of scripted objectives is [" .. #self.scripted_objectives .. "]");
			return false;
		end;
		
		-- take the script_key of the single existing scripted objective record 
		script_key = scripted_objectives[1].script_key;
		
		scripted_objective_record = scripted_objectives[1];
		
	else
		-- find the scripted objective record matching the script_key
		for i = 1, #scripted_objectives do
			if scripted_objectives[i].script_key == script_key then
				scripted_objective_record = scripted_objectives[i];
				break;
			end;
		end;
	
		if not scripted_objective_record then
			script_error(self.mission_key .. " ERROR: add_scripted_objective_completion_condition() called with script_key [" .. script_key .. "] but no scripted objective record with this key could be found");
			return false;
		end;
	end;
	
	-- create/add this completion condition record
	local completion_condition_record = {
		["event"] = event,
		["condition"] = condition
	};
	
	if is_success then
		table.insert(scripted_objective_record.success_conditions, completion_condition_record);
	else
		table.insert(scripted_objective_record.failure_conditions, completion_condition_record);
	end;
end;


--- @function force_scripted_objective_success
--- @desc Immediately forces the success of a scripted objective. A particular scripted objective may be specified by supplying a script key, otherwise this function will target the first scripted objective in the mission manager.
--- @desc This should only be called after the mission manager has been triggered.
--- @p [opt=nil] string script name, Script name of the scripted objective to force the success of.
function mission_manager:force_scripted_objective_success(script_key)
	return self:force_scripted_objective_completion(true, script_key);
end;


--- @function force_scripted_objective_failure
--- @desc Immediately forces the failure of a scripted objective. A particular scripted objective may be specified by supplying a script key, otherwise this function will target the first scripted objective in the mission manager.
--- @desc This should only be called after the mission manager has been triggered.
--- @p [opt=nil] string script name, Script name of the scripted objective to force the failure of.
function mission_manager:force_scripted_objective_failure(script_key)
	return self:force_scripted_objective_completion(false, script_key);
end;


-- internal function
function mission_manager:force_scripted_objective_completion(is_success, script_key)
	
	-- support no script_key being supplied - we must have exactly one scripted_objectives record
	if not script_key then
	
		if #self.scripted_objectives ~= 1 then
			script_error(self.mission_key .. " ERROR: force_scripted_objective_completion() called with no script_key but the number of registered scripted objectives is not one (it is [" .. #self.scripted_objectives .. "])");
			return false;
		end;
		
		script_key = self.scripted_objectives[1].script_key;
	end;

	if is_success then
		cm:complete_scripted_mission_objective(self.faction_name, self.mission_key, script_key, true);
		out("~~~ MissionManager :: " .. self.mission_key .. " is being externally forced to successfully complete scripted objective with script key [" .. script_key .. "]");
	else
		cm:complete_scripted_mission_objective(self.faction_name, self.mission_key, script_key, false);
		out("~~~ MissionManager :: " .. self.mission_key .. " is being externally forced to fail scripted objective with script key [" .. script_key .. "]");
	end;
	
	core:remove_listener(self.mission_key .. script_key .. "_completion_listener");
end;


--- @function update_scripted_objective_text
--- @desc Updates the displayed objective text of a scripted objective. This can be useful if some counter needs to be updated as progress towards an objective is made, and optional count and total numerical values may be specified which are formatted in to the displayed text. A particular scripted objective may be specified by supplying a script key, otherwise this function will target the first scripted objective in the mission manager.
--- @desc This should only be called after the mission manager has been triggered.
--- @p @string display text, Display text for this objective. This should be supplied as a full localisation key, i.e. <code>[table]_[field]_[key]</code>.
--- @p [opt=nil] @number count, Numeric count value to display. This is an optional first number formatted in to the display text, to allow a count value to be shown (e.g. "Current progress towards goal: %n")
--- @p [opt=nil] @number total, Numeric total value to display. This is an optional second number formatted in to the display text, to allow a count and total value to be shown (e.g. "Current progress towards goal: %n of %n")
--- @p [opt=nil] @string script name, Script name of the scripted objective to update the key of.
function mission_manager:update_scripted_objective_text(override_text, count, total, script_key)

	if not is_string(override_text) then
		script_error(self.mission_key .. " ERROR: update_scripted_objective_text() called but supplied override text [" .. tostring(override_text) .. "] is not a string");
		return false;
	end;

	if count and not validate.is_number(count) then
		return false;
	end;

	if total and not validate.is_number(total) then
		return false;
	end;
	
	-- support not supplying a script key if we only have one scripted objective
	if not script_key then
		if #self.scripted_objectives ~= 1 then
			script_error(self.mission_key .. " ERROR: update_scripted_objective_text() called with no script_key, but more or less than one scripted objective has been registered (number of registered scripted objectives is [" .. tostring(#self.scripted_objectives) .. "]");
			return false;
		end;
	
		script_key = self.scripted_objectives[1].script_key;
	end;
	
	if count then
		if total then
			cm:set_scripted_mission_text(self.mission_key, script_key, override_text, count, total);
		else
			cm:set_scripted_mission_text(self.mission_key, script_key, override_text, count);
		end;
	else
		cm:set_scripted_mission_text(self.mission_key, script_key, override_text);
	end;
end;









----------------------------------------------------------------------------
--- @section Persistent Values
--- @desc Persistent values may be stored and retrieved on a persistent mission manager. The mission manager will save those to the savegame and keep them available for client scripts to query even after the game has been reloaded. This can be useful if values important to the mission manager's working are only determined at the time that the mission manager is triggered, and can't be known when the mission manager is declared. For example, a @"mission_manager:Scripted Objectives" mission to build x number of temples, where x is the number of temples held by a rival faction at the time the mission is issued, would need to store x in the savegame in order to re-establish the mission manager with the correct success conditions.
--- @desc For example, a mission manager may establish its scripted conditions within a callback passed to @mission_manager:add_each_time_trigger_callback which uses persistent values that are first generated when the mission is first triggered.o
--- @example local mm = mission_manager:new(cm:get_local_faction_name(), "test_mission_key");
--- @example 
--- @example -- Call this setup function each time the mission manager is triggered
--- @example mm:add_each_time_trigger_callback(
--- @example	function()
--- @example		-- Mission is triggering - if persistent values have not been set
--- @example		-- (i.e. we are triggering for the first time) then set them
--- @example		if not mm:get_persistent_value("total_buildings") then
--- @example			mm:set_persistent_value("current_buildings", 0);
--- @example			
--- @example			-- Threshold value will be a random number 1-3, decided at the point the mission is first triggered
--- @example			mm:set_persistent_value("total_buildings", cm:random_number(3))
--- @example		end;
--- @example		
--- @example		mm:add_new_scripted_objective(
--- @example			"mission_text_text_test_mission_construct_random_num_buildings",
--- @example			"BuildingCompleted",				-- event
--- @example			function(context)					-- condition to test
--- @example				if context:building():faction():name() == cm:get_local_faction_name() then
--- @example					-- Local faction has constructed a building, increment our current
--- @example					-- building counter and return true if we've hit the threshold value
--- @example					mm:set_persistent_value("current_buildings", mm:get_persistent_value("current_buildings") + 1);
--- @example												
--- @example					if mm:get_persistent_value("current_buildings") >= mm:get_persistent_value("total_buildings") then
--- @example						return true;
--- @example					end;
--- @example				end;
--- @example			end
--- @example		);
--- @example		
--- @example		-- This has to be added after scripted objectives
--- @example		mm:add_payload("money 1000");
--- @example	end
--- @example );
--- @example 
--- @example -- ...Later
--- @example mm:trigger();
----------------------------------------------------------------------------









--- @function set_persistent_value
--- @desc Sets a persistent value on the mission manager with a supplied @string name. The value can be a @boolean, @number, @string or @table.
--- @p @string name
--- @p value value
function mission_manager:set_persistent_value(name, value)
	if not validate.is_string(name) then
		return false;
	end;

	if not is_boolean(value) and not is_number(value) and not is_string(value) and not is_table(value) then
		script_error("ERROR: set_persistent_value() called but supplied value [" .. tostring(value) .. "] cannot be saved into the savegame");
		return false;
	end;

	self:register();

	self.persistent_values[name] = value;
end;


--- @function get_persistent_value
--- @desc Returns a persistent value previously saved with @mission_manager:set_persistent_value. If no persistent value has been saved on this mission manager with the supplied name.
function mission_manager:get_persistent_value(name)
	return self.persistent_values[name];
end;










----------------------------------------------------------------------------
--- @section Sourcing Objectives from Database
--- @desc If the mission manager is not set to generate its objectives from strings then it will fall back to one of two sources - from the missions.txt file which accompanies the campaign data or from database records. By default, the missions.txt file is used as the source of the mission - use @mission_manager:set_is_mission_in_db, @mission_manager:set_is_incident_in_db or @mission_manager:set_is_dilemma_in_db to have the mission manager construct its mission objectives from the database instead. Doing this will require that records are present in various tables such as <code>cdir_events_mission_option_junctions</code> to allow the mission to fire (different but equivalent tables are used if the mission is actually an incident or a dilemma).
----------------------------------------------------------------------------


--- @function set_is_mission_in_db
--- @desc Sets that the mission objectives should be constructed from records in the game database.
function mission_manager:set_is_mission_in_db()
	self.should_trigger_from_db = true;

	self.is_mission_when_triggering_from_db = true;
	self.is_incident_when_triggering_from_db = false;
	self.is_dilemma_when_triggering_from_db = false;
end;


--- @function set_is_incident_in_db
--- @desc Sets that the mission objectives should be constructed from records in the game database, and that the mission is actually an incident.
function mission_manager:set_is_incident_in_db()
	self.should_trigger_from_db = true;

	self.is_mission_when_triggering_from_db = false;
	self.is_incident_when_triggering_from_db = true;
	self.is_dilemma_when_triggering_from_db = false;
end;


--- @function set_is_dilemma_in_db
--- @desc Sets that the mission objectives should be constructed from records in the game database, and that the mission is actually a dilemma.
--- @p [opt=false] @boolean is intervention, Is a dilemma in an intervention. If this is set to <code>true</code>, the dilemma will be triggered directly using @campaign_manager:trigger_dilemma_raw, which can cause softlocks when triggered from outside of an intervention. If set to <code>false</code> or left blank then the dilemma will be triggered in @campaign_manager:trigger_dilemma which attempts to package the dilemma in an intervention.
function mission_manager:set_is_dilemma_in_db(is_in_intervention)
	self.should_trigger_from_db = true;

	self.is_mission_when_triggering_from_db = false;
	self.is_incident_when_triggering_from_db = false;
	self.is_dilemma_when_triggering_from_db = true;

	if is_in_intervention then
		self.is_dilemma_in_intervention = true;
	else
		self.is_dilemma_in_intervention = false;
	end;
end;










----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function has_been_triggered
--- @desc Returns <code>true</code> if the mission manager has been triggered in the past, <code>false</code> otherwise. If triggered it might not still be running, as the mission could have been completed.
--- @r @boolean is triggered
function mission_manager:has_been_triggered()
	return self.started;
end;


--- @function is_active
--- @desc Returns <code>true</code> if the mission manager has been triggered but not yet completed.
--- @r @boolean is active
function mission_manager:is_active()
	return self.started and not self.completed;
end;


--- @function is_completed
--- @desc Returns <code>true</code> if the mission has been completed, <code>false</code> otherwise. Success, failure or cancellation all count as completion.
--- @r @boolean is completed
function mission_manager:is_completed()
	return self.completed;
end;


-- for internal use only
function mission_manager:should_cancel_before_issuing()
	if self.should_cancel_before_issuing_override ~= nil then
		return self.should_cancel_before_issuing_override;
	end;
	return self.is_registered;
end;







----------------------------------------------------------------------------
--- @section Resetting
----------------------------------------------------------------------------


--- @function reset
--- @desc Resets a running mission manager, so that it is ready to be triggered again.
function mission_manager:reset()
	self.started = false;
	self.completed = false;

	self:stop_listeners();

	cm:cancel_custom_mission(self.faction_name, self.mission_key);
end;








----------------------------------------------------------------------------
--- @section Triggering
----------------------------------------------------------------------------


--- @function trigger
--- @desc Triggers the mission, causing it to be issued.
--- @p [opt=nil] @function dismiss callback, Dismiss callback. If specified, this is called when the event panel is dismissed.
--- @p [opt=nil] @number callback delay, Dismiss callback delay, in seconds. If specified this introduces a delay between the event panel being dismissed and the dismiss callback being called.
function mission_manager:trigger(dismiss_callback, delay)
	if self.started then
		script_error("ERROR: an attempt was made to trigger a mission manager with key [" .. self.mission_key .. "] which has already been triggered");
		return false;
	end;
	
	if dismiss_callback and not is_function(dismiss_callback) then
		script_error("trigger() called on mission but supplied dismiss callback [" .. tostring(dismiss_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if delay and not is_number(delay) then
		script_error("trigger() called on mission but supplied dismiss callback delay [" .. tostring(delay) .. "] is not a number or nil");
		return false;
	end;
	
	delay = delay or 0;
	
	-- perform construction if we're constructing from a string
	if self.should_trigger_from_string then
		local mission_string = false;
		if self.victory_mission then 
			mission_string = self:construct_victory_objective_mission_string()
		else			
			mission_string = self:construct_mission_string();
		end
		
		if not mission_string then
			script_error("ERROR: trigger() called on mission manager with key [" .. self.mission_key .. "] but failed to construct a mission string");
			return false;
		else
			self.mission_string = mission_string;
		end;
	end;

	self.started = true;
	
	-- start completion listeners
	self:start_listeners();
	
	if dismiss_callback then
		local dismiss_callback_listener_name = self.faction_name .. "_" .. self.mission_key .. "_dismiss_callback";

		core:add_listener(
			dismiss_callback_listener_name,
			"PanelOpenedCampaign",
			function(context) return context.string == "events" end,
			function()
				cm:progress_on_events_dismissed(
					self.mission_key,
					dismiss_callback,
					delay
				);
			end,
			false
		);
		
		-- listen also for the mission generation to be failed
		core:add_listener(
			dismiss_callback_listener_name,
			"MissionGenerationFailed",
			function(context) return context:mission() == self.mission_key end,
			function()
				script_error("ERROR: mission manager failed to generate mission with key " .. self.mission_key .. ". Calling dismiss callback, but no mission has been issued to the player - this is a serious error");
				core:remove_listener(self.mission_key);
				cm:callback(function() dismiss_callback() end, delay);
			end,
			false
		);
	end;
	
	-- 
	-- trigger the mission
	-- 

	-- Suppress event dialogs if we're supposed to, and this is not an incident or dilemma
	local should_enable_mission_events_after_triggering = false;
	if not self.should_trigger_from_db or self.is_mission_when_triggering_from_db then
		if not self.show_mission then
			should_enable_mission_events_after_triggering = true;
			self:disable_mission_events(true);
		end;
	end;

	--- do one of the following..
	if self.should_trigger_from_string then
		-- trigger from a constructed string
		self:trigger_from_string();
		
	elseif self.should_trigger_from_db then
		-- trigger from db records
		if self.is_mission_when_triggering_from_db then
			cm:trigger_mission(self.faction_name, self.mission_key, true, self.should_whitelist);
		elseif self.is_incident_when_triggering_from_db then
			cm:trigger_incident(self.faction_name, self.mission_key, true, self.should_whitelist);
		elseif self.is_dilemma_when_triggering_from_db then
			if self.is_dilemma_in_intervention then
				-- this is a dilemma in an intervention, apparently, so trigger it immediately without trying to package it in an intervention
				cm:trigger_dilemma_raw(self.faction_name, self.mission_key, true, self.should_whitelist);
			else
				-- attempt to package this dilemma in an intervention (it will get triggered directly in multiplayer)
				cm:trigger_dilemma(self.faction_name, self.mission_key);
			end;
		else
			script_error("ERROR: mission manager is attempting to trigger() mission with key [" .. self.mission_key .. "] but cannot identify mission type - it doesn't seem to be a mission, incident or dilemma?");
			return false;
		end;
	else
		-- trigger from missions.txt file
		cm:trigger_custom_mission(self.faction_name, self.mission_key, not self:should_cancel_before_issuing(), self.should_whitelist);
	end;

	if should_enable_mission_events_after_triggering then
		self:disable_mission_events(false);
	end;

	-- call first-time/each-time trigger callbacks - this should be done after the mission itself is triggered
	self:call_trigger_callbacks(true);
end;


-- internal function to disable mission events
function mission_manager:disable_mission_events(disable)
	cm:disable_event_feed_events(not not disable, "", "wh_event_subcategory_faction_missions_objectives", "");
end;


-- internal function to construct the mission string we will be triggering with (if our mission is to be constructed this way)
function mission_manager:construct_mission_string()
	if #self.objectives == 0 then
		script_error("ERROR: construct_mission_string() called on mission manager with key [" .. self.mission_key .. "] but we have no objectives to add");
		return false;
	end;
	
	local is_primary_objective = true;
	local have_opened_secondary_objective_block = false;
	
	local mission_string = false;
	
	if self.chapter_mission then
		mission_string = "mission{chapter " .. self.chapter_mission .. ";key " .. self.mission_key .. ";issuer " .. self.mission_issuer;
	else
		mission_string = "mission{key " .. self.mission_key .. ";issuer " .. self.mission_issuer;
	end
	
	if self.victory_type then
		mission_string = mission_string .. ";victory_type " .. self.victory_type;
	end
	
	if self.turn_limit then
		mission_string = mission_string .. ";turn_limit " .. self.turn_limit;
	end;
	
	for i = 1, #self.objectives do
		local current_objective = self.objectives[i];
		
		-- data checking
		if not current_objective.objective_type then
			script_error("ERROR: construct_mission_string() called on mission manager with key [" .. self.mission_key .. "] but objective [" .. i .. "] has no type (how can this be?)");
			return false;
		end;
		
		if not is_table(current_objective.payloads) or #current_objective.payloads == 0 then
			script_error("ERROR: construct_mission_string() called on mission manager with key [" .. self.mission_key .. "] but objective [" .. i .. "] has no payload");
			return false;
		end;
		
		-- open the objective/payload block
		if is_primary_objective then
			mission_string = mission_string .. ";primary_objectives_and_payload{";
			is_primary_objective = false;
			
		elseif have_opened_secondary_objective_block then
			mission_string = mission_string .. "objectives_and_payload{";
			
		else
			mission_string = mission_string .. "secondary_objectives_and_payloads{objectives_and_payload{";
			have_opened_secondary_objective_block = true;
		end;
		
		-- optional heading/decription key overrides
		if current_objective.heading then
			mission_string = mission_string .. "heading " .. current_objective.heading .. ";";
		end;
		
		if current_objective.description then
			mission_string = mission_string .. "description " .. current_objective.description .. ";";
		end;
		
		mission_string = mission_string .. "objective{type " .. current_objective.objective_type .. ";";
		
		for j = 1, #current_objective.conditions do
			mission_string = mission_string .. current_objective.conditions[j] .. ";";
		end;
		
		if current_objective.objective_type == "SCRIPTED" and self.position_x and self.position_y then
			mission_string = mission_string .. "position " .. self.position_x .. "," .. self.position_y .. ";";
		end;
		
		-- payloads
		mission_string = mission_string .. "}payload{";
		
		for j = 1, #current_objective.payloads do
			local payload_string = current_objective.payloads[j];
			
			-- don't add a semicolon if the last character of the payload string is "}"
			if string.sub(payload_string, string.len(payload_string)) == "}" then
				mission_string = mission_string .. payload_string;
			else
				mission_string = mission_string .. payload_string .. ";";
			end;
		end;
		
		if #current_objective.failure_payloads > 0 then
			mission_string = mission_string .. "}failure_payload{";

			for j = 1, #current_objective.failure_payloads do
				local payload_string = current_objective.failure_payloads[j];
				if string.sub(payload_string, string.len(payload_string)) == "}" then
					mission_string = mission_string .. payload_string;
				else
					mission_string = mission_string .. payload_string .. ";";
				end;
			end;
		end;

		mission_string = mission_string .. "}}";
	end;
	
	if have_opened_secondary_objective_block then
		mission_string = mission_string .. "}}";
	else
		mission_string = mission_string .. "}";
	end;
	
	return mission_string;
end;


-- internal function to construct the mission string we will be triggering with (if our mission is to be constructed this way)
function mission_manager:construct_victory_objective_mission_string()
	if #self.objectives == 0 then
		script_error("ERROR: construct_victory_objective_mission_string() called on mission manager with key [" .. self.mission_key .. "] but we have no objectives to add");
		return false;
	end;
	
	local mission_string = false;
	local payload_added = false;
	
	mission_string = "mission{key " .. self.mission_key .. ";issuer " .. self.mission_issuer;

	if self.victory_type ~= false then
		if self.victory_type then
			mission_string = mission_string .. ";victory_type " .. self.victory_type;
		else
			script_error("ERROR: construct_victory_objective_mission_string() called on mission manager with key [" .. self.mission_key .. "] but no victory type has been added");
			return false;
		end
	end
	
	if self.turn_limit then
		mission_string = mission_string .. ";turn_limit " .. self.turn_limit;
	end;

	mission_string = mission_string .. ";primary_objectives_and_payload{";
	
	for i = 1, #self.objectives do
		local current_objective = self.objectives[i];
		
		-- data checking
		if not current_objective.objective_type then
			script_error("ERROR: construct_victory_objective_mission_string() called on mission manager with key [" .. self.mission_key .. "] but objective [" .. i .. "] has no type (how can this be?)");
			return false;
		end;
		
		-- optional heading/decription key overrides
		if current_objective.heading then
			mission_string = mission_string .. "heading " .. current_objective.heading .. ";";
		end;
		
		if current_objective.description then
			mission_string = mission_string .. "description " .. current_objective.description .. ";";
		end;
		
		mission_string = mission_string .. "objective{type " .. current_objective.objective_type .. ";";
		
		for j = 1, #current_objective.conditions do
			mission_string = mission_string .. current_objective.conditions[j] .. ";";
		end;
		
		-- payloads
		if #current_objective.payloads > 0 then
			payload_added = true;
			mission_string = mission_string .. "}payload{";
			
			for j = 1, #current_objective.payloads do
				local payload_string = current_objective.payloads[j];
				
				-- don't add a semicolon if the last character of the payload string is "}"
				if string.sub(payload_string, string.len(payload_string)) == "}" then
					mission_string = mission_string .. payload_string;
				else
					mission_string = mission_string .. payload_string .. ";";
				end;
			end;
		end

		mission_string = mission_string .. "}";
	end;

	if not payload_added then
		script_error("ERROR: construct_victory_objective_mission_string() called on mission manager with key [" .. self.mission_key .. "] but no payload has been added");
		return false;
	end;

	mission_string = mission_string .. "}}"
	
	return mission_string;
end;


-- internal function to trigger from a constructed string
function mission_manager:trigger_from_string()
	local mission_string = self.mission_string;
	
	out("++ mission manager triggering mission from string:");
	
	if self:should_cancel_before_issuing() then
		cm:cancel_custom_mission(self.faction_name, self.mission_key);
	end;
	cm:trigger_custom_mission_from_string(self.faction_name, mission_string, self.should_whitelist);
end;


-- internal function to trigger this mission manager from a savegame
function mission_manager:trigger_from_savegame(started, completed)
	self.started = started;
	self.completed = completed;

	if started and not completed then
		out("++ mission manager starting mission listeners from savegame for mission with key [" .. self.mission_key .. "] for faction [" .. self.faction_name .. "]");

		self:call_trigger_callbacks(false);

		self:start_listeners();
	end;
end;


-- internal function to start any success/failure/cancellation/nearing-expiry/scripted objective listeners we may have
function mission_manager:start_listeners()
	local mission_key = self.mission_key;
	local faction_name = self.faction_name;

	local scripted_objectives = self.scripted_objectives;
	local any_scripted_objectives = #scripted_objectives > 0;
	
	-- success listener
	if any_scripted_objectives or is_function(self.success_callback) then
		core:add_listener(
			mission_key .. "_success_listener",
			"MissionSucceeded",
			function(context) return context:mission():mission_record_key() == mission_key and context:faction():name() == faction_name end,
			function()
				out("~~~ MissionManager for mission [" .. mission_key .. "] and faction [" .. faction_name .. "] has received a MissionSucceeded event - this mission has been completed successfully");
				self:complete();
				if is_function(self.success_callback) then
					if self.force_immediate_callback then
						self.success_callback(MISSION_MANAGER_MISSION_SUCCEEDED);
					else
						cm:progress_on_battle_completed(
							"mm_" .. mission_key,
							function()
								self.success_callback(MISSION_MANAGER_MISSION_SUCCEEDED);
							end
						);
					end;
				end;
			end,
			false
		);
	end;
	
	-- failure listener
	if any_scripted_objectives or is_function(self.failure_callback) then
		core:add_listener(
			mission_key .. "_failure_listener",
			"MissionFailed",
			function(context) return context:mission():mission_record_key() == mission_key and context:faction():name() == faction_name end,
			function()
				out("~~~ MissionManager for mission [" .. mission_key .. "] and faction [" .. faction_name .. "] has received a MissionFailed event - this mission has been failed");
				self:complete();
				if is_function(self.failure_callback) then
					if self.force_immediate_callback then
						self.failure_callback(MISSION_MANAGER_MISSION_FAILED);
					else
						cm:progress_on_battle_completed(
							"mm_" .. mission_key,
							function()
								self.failure_callback(MISSION_MANAGER_MISSION_FAILED);
							end
						);
					end;
				end;
			end,
			false
		);	
	end;
	
	-- cancellation listener
	if any_scripted_objectives or is_function(self.cancellation_callback) then
		core:add_listener(
			mission_key .. "_cancellation_listener",
			"MissionCancelled",
			function(context) return context:mission():mission_record_key() == mission_key and context:faction():name() == faction_name end,
			function()
				out("~~~ MissionManager for mission [" .. mission_key .. "] and faction [" .. faction_name .. "] has received a MissionCancelled event - this mission has been cancelled");
				self:complete();
				if is_function(self.cancellation_callback) then
					if self.force_immediate_callback then
						self.cancellation_callback(MISSION_MANAGER_MISSION_CANCELLED);
					else
						cm:progress_on_battle_completed(
							"mm_" .. mission_key,
							function()
								self.cancellation_callback(MISSION_MANAGER_MISSION_CANCELLED);
							end
						);
					end;
				end;
			end,
			false
		);	
	end;
	
	-- nearing expiry listener
	if is_function(self.nearing_expiry_callback) then
		core:add_listener(
			mission_key .. "_nearing_expiry_listener",
			"MissionNearingExpiry",
			function(context) return context:mission():mission_record_key() == mission_key end,
			function()
				out("~~~ MissionManager for mission [" .. mission_key .. "] and faction [" .. faction_name .. "] has received a MissionNearingExpiry event - this mission is nearing expiry");
				if is_function(self.nearing_expiry_callback) then
					self.nearing_expiry_callback();
				end;
			end,
			true
		);	
	end;
	
	-- scripted objective listeners
	for i = 1, #scripted_objectives do
		local current_scripted_objective_record = scripted_objectives[i];
		local script_key = current_scripted_objective_record.script_key;
		
		for j = 1, #current_scripted_objective_record.success_conditions do
			local condition_record = current_scripted_objective_record.success_conditions[j];
			
			local listener_name = self.mission_key .. script_key .. "_completion_listener";
			
			core:add_listener(
				listener_name,
				condition_record.event,
				condition_record.condition,
				function(context)
					out("~~~ MissionManager :: " .. mission_key .. " has successfully completed scripted objective with script key [" .. script_key .. "] on receipt of event [" .. condition_record.event .. "]");
					
					core:remove_listener(listener_name);
					
					if cm:is_processing_battle() then
						out("\twill complete objective after battle sequence completes");
						cm:progress_on_battle_completed(
							listener_name,
							function()
								out("~~~ MissionManager :: " .. mission_key .. " is completing scripted objective with script key [" .. script_key .. "] now that battle sequence has completed");
								cm:complete_scripted_mission_objective(self.faction_name, self.mission_key, script_key, true);
							end,
							0.5
						);
					else
						out("\tcompleting objective immediately");
						cm:complete_scripted_mission_objective(self.faction_name, self.mission_key, script_key, true);
					end;
				end,
				false
			);
		end;
		
		for j = 1, #current_scripted_objective_record.failure_conditions do
			local condition_record = current_scripted_objective_record.failure_conditions[j];
			
			core:add_listener(
				self.mission_key .. script_key .. "_completion_listener",
				condition_record.event,
				condition_record.condition,
				function(context)
					out("~~~ MissionManager :: " .. mission_key .. " has failed scripted objective with script key [" .. script_key .. "]");
					cm:complete_scripted_mission_objective(self.faction_name, self.mission_key, script_key, false);
					core:remove_listener(self.mission_key .. script_key .. "_completion_listener");
				end,
				false
			);
		end;
	end;
end;


-- internal function to stop any listeners started with start_listeners()
function mission_manager:stop_listeners()
	local mission_key = self.mission_key;
	core:remove_listener(mission_key .. "_success_listener");
	core:remove_listener(mission_key .. "_failure_listener");
	core:remove_listener(mission_key .. "_cancellation_listener");
	core:remove_listener(mission_key .. "_nearing_expiry_listener");

	-- clean up any remaining scripted objective listeners
	for i = 1, #self.scripted_objectives do
		core:remove_listener(mission_key .. self.scripted_objectives[i].script_key .. "_completion_listener");
	end;
end;


--- @function cancel_dismiss_callback_listeners
--- @desc Cancels any dismiss callback listeners started by mission_manager:trigger. This can be useful in certain circumstances if the mission has failed to trigger.
function mission_manager:cancel_dismiss_callback_listeners()
	core:remove_listener(self.faction_name .. "_" .. self.mission_key .. "_dismiss_callback");
end;








----------------------------------------------------------------------------
--	Completing
----------------------------------------------------------------------------

-- called internally when the mission is completed
function mission_manager:complete()
	local mission_key = self.mission_key;
	
	self.completed = true;

	self:stop_listeners();	
end;


--- @end_class

















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CHAPTER MISSIONS WRAPPER
--
--- @c chapter_mission Chapter Missions
--- @desc The chapter mission system is a simple wrapper for the traditional method of packaging chapter missions. It triggers the mission within an @intervention to better control the flow of events on-screen, and optionally plays advice and infotext that can add flavour.
--- @desc This system is due a rewrite to allow them to use @mission_manager's and also allow chapter missions to be constructed from strings at runtime.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


chapter_mission = {
	cm = false,
	chapter_number = 0,
	player_faction = false,
	mission_key = false,
	advice_key = false,
	intervention = false
};


set_class_custom_type(chapter_mission, TYPE_CHAPTER_MISSION);
set_class_tostring(
	chapter_mission, 
	function(obj)
		return TYPE_CHAPTER_MISSION .. "_" .. obj.player_faction .. "_" .. obj.chapter_number
	end
);







----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a chapter mission object. This should happen in the root of the script somewhere, so that the object is declared and set up by the time the first tick happens so that it can be properly restarted from a savegame.
--- @p number chapter number, Chapter number. All numbers from 1 to n should be accounted for, where n is the last chapter in the sequence. When a chapter mission completes it automatically starts the next chapter mission in the sequence. 
--- @p string faction key, Faction key of the faction receiving the mission.
--- @p string mission key, Mission key of the chapter mission.
--- @p [opt=nil] string advice key, Key of advice to deliver alongside the mission.
--- @p [opt=nil] table infotext, table of string infotext keys to deliver alongside advice.
--- @r chapter_mission Chapter mission object
function chapter_mission:new(chapter_number, player_faction, mission_key, advice_key, infotext)

	if not is_number(chapter_number) then
		script_error("ERROR: chapter_mission:new() called but supplied chapter number [" .. tostring(chapter_number) .. "] is not a number");
		return false;
	end;

	if not is_string(player_faction) then
		script_error("ERROR: chapter_mission:new() called but supplied player faction key [" .. tostring(player_faction) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(player_faction) then
		script_error("ERROR: chapter_mission:new() called but no faction with supplied player faction key [" .. player_faction .. "] could be found");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: chapter_mission:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(advice_key) and not is_nil(advice_key) then
		script_error("ERROR: chapter_mission:new() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_nil(infotext) and not is_table(infotext) then
		script_error("ERROR: chapter_mission:new() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	local ch = {};
	
	ch.chapter_number = chapter_number;
	ch.player_faction = player_faction;

	set_object_class(ch, self);

	ch.mission_key = mission_key;
	ch.advice_key = advice_key;
	ch.infotext = infotext;
	
	local chapter_mission_string = "chapter_mission_" .. tostring(chapter_number);
	local mission_issued = ch:has_been_issued();
	local mission_completed = ch:has_been_completed();
	
	local intervention = intervention:new(
		chapter_mission_string,														-- string name
		0,																			-- cost
		function() 																	-- trigger callback
			ch:issue_mission();
		end,
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	intervention:set_allow_when_advice_disabled(true);
	
	intervention:add_precondition(function() return not mission_issued and not mission_completed end);
	
	intervention:add_trigger_condition(
		"ScriptEventTriggerChapterMission", 
		function(context) return context.string == tostring(chapter_number) end
	);
	
	if cm:is_new_game() then
		intervention:start();
	end;
	
	ch.intervention = intervention;
	
	-- We register chapter missions with the cm now so that it can be asked when a chapter mission is completed whether a further chapter mission exists
	-- This means we can avoid locking the saving-game functionality in legendary mode when there is no further mission (which is responsible for unlocking it)
	cm:register_chapter_mission(ch);
	
	-- listen for this chapter mission being completed and fire an event that should set off the next
	if not mission_completed then
		core:add_listener(
			chapter_mission_string,
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == ch.mission_key
			end,
			function()
				local next_chapter_number = chapter_number + 1;
				
				-- if this is a legendary game then disable saving, so the game doesn't save after one chapter objective has been completed but before the next has been issued
				-- only do this if another chapter mission exists!
				if cm:model():difficulty_level() == -3 and cm:chapter_mission_exists_with_number(next_chapter_number) then
					cm:disable_saving_game(true);
				end;
				
				cm:set_saved_value("chapter_mission_" .. chapter_number .. "_completed", true);
				core:trigger_event("ScriptEventTriggerChapterMission", tostring(next_chapter_number))
			end,
			false
		);
	end;
	
	return ch;
end;






----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a <code>chapter_mission</code> object has been created with @chapter_mission:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;chapter_mission_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local chapter_one_mission = chapter_mission:new(1, "wh_main_emp_empire", "wh_objective_empire_01")
--- @example chapter_one_mission:manual_start()
----------------------------------------------------------------------------







----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function has_been_issued
--- @desc returns whether the chapter mission has been issued.
--- @r boolean has been issued
function chapter_mission:has_been_issued()
	return not not cm:get_saved_value("chapter_mission_" .. self.chapter_number .. "_issued");
end;


--- @function has_been_completed
--- @desc returns whether the chapter mission has been completed.
--- @r boolean has been completed
function chapter_mission:has_been_completed()
	return not not cm:get_saved_value("chapter_mission_" .. self.chapter_number .. "_completed");
end;








----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function manual_start
--- @desc Manually starts the chapter mission. It should only be necessary to manually start the first chapter mission in the sequence - the second will start automatically when the first is completed, and so on.
function chapter_mission:manual_start()
	core:trigger_event("ScriptEventTriggerChapterMission", tostring(self.chapter_number));
end;


-- internal function, not to be called externally
function chapter_mission:issue_mission()
	local intervention = self.intervention;
	
	-- With ironman enabled (manual saves disabled), establish a listener for when the new mission is issued and then save the game.
	-- This is because with manual saves disabled the game autosaves at the start of turn, which can happen after
	-- the previous chapter mission is completed but before the next one is issued.
	local should_autosave_after_mission_issued = false;
	
	if cm:model():manual_saves_disabled() then
		should_autosave_after_mission_issued = true;
	end;
	
	-- allow the chapter mission complete to be shown
	cm:whitelist_event_feed_event_type("faction_campaign_chapter_objective_completeevent_feed_target_mission_faction")
	
	core:trigger_event("ScriptEventChapterMissionTriggered");
	
	cm:set_saved_value("chapter_mission_" .. self.chapter_number .. "_issued", true);
	
	if self.advice_key and cm:is_advice_enabled() then
		if self.infotext and not common.get_advice_history_string_seen("prelude_victory_conditions_advice") then
		
			common.set_advice_history_string_seen("prelude_victory_conditions_advice")
	
			-- show victory conditions infotext if it's not been seen by the player before
			intervention:play_advice_for_intervention(self.advice_key, self.infotext);
		else
			intervention:play_advice_for_intervention(self.advice_key);
		end;
		
		cm:callback(
			function()
				cm:trigger_custom_mission(self.player_faction, self.mission_key);
				
				if should_autosave_after_mission_issued then
					cm:disable_saving_game(false);
					cm:autosave_at_next_opportunity();
				end;
			end,
			1
		);
	else
		cm:trigger_custom_mission(self.player_faction, self.mission_key);
		
		if should_autosave_after_mission_issued then
			cm:disable_saving_game(false);
			cm:autosave_at_next_opportunity();
		end;
		
		cm:callback(function() intervention:complete() end, 1);
	end;
end;

















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	PAYLOAD STRING CONSTRUCTOR
--
--- @c payload Payload String Constructor
--- @function_separator .
--- @desc When constructing mission definitions from a string, a particularly fiddly point is assembling the payload strings for mission rewards. The payload table contains utility functions that should hopefully make this process a bit easier.
--- @desc The various functions provided in the payload table can each be called with the minimum of vital data. Each will return a string which can be plugged in to @mission_manager:add_payload (or equivalent functions) to specify that the mission should deliver that reward.
--- @desc The payload table also provides a basic remapping feature. This is useful for when a particular faction doesn't take a particular reward (usually money) but another reward in its place (e.g. a race-specific currency like daemonic glory). Rather than having to manually override each mission record for a particular faction which would be time-consuming and error-prone, data is provided which a remapping function can use to replace the mission rewards with something more appropriate.

--- @example local mm = mission_manager:new(faction_key, mission_key);
--- @example mm:add_new_objective("SEARCH_RUINS");
--- @example mm:add_condition("total 1");
--- @example mm:add_payload(payload.money(500));

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


payload = {};
payload.equivalence_mapping = {};


--- @section Payload Remapping


--- @function add_money_equivalence_mapping
--- @desc Adds a payload remapping for a particular faction, for money. Once this remapping is established, payloads for this faction set up with @payload:money will instead be replaced with an alternative. The alternative is determined by the callback that is supplied to this function.
--- @desc When a money payload is requested, the callback will be called and supplied three arguments - the amount of money to add, the faction key, and a table of arbitrary parameters supplied to @payload:money that can be used to determine the equivalent payload. What goes in to this table of arbitrary parameters can be decided by the implementer, but what is added to each mission specification should match what the callback looks for.
--- @p @string faction key
--- @p @function remapping callback
function payload.add_money_equivalence_mapping(faction_key, callback)
	if not validate.is_string(faction_key) or not validate.is_function(callback) then
		return false;
	end;

	if not payload.equivalence_mapping.money then
		payload.equivalence_mapping.money = {};
	end;

	payload.equivalence_mapping.money[faction_key] = callback;
end;


--- @function add_ancillary_equivalence_mapping
--- @desc Adds a payload remapping for a particular faction, for ancillary payloads. Once this remapping is established, payloads for this faction set up with @payload:ancillary_mission_payload will instead be replaced with an alternative. The alternative is determined by the callback that is supplied to this function.
--- @desc When an ancillary payload is requested, the callback will be called and supplied three arguments - the faction key, the ancillary category @string, and the ancillary rarity @string.
--- @p @string faction key
--- @p @function remapping callback
function payload.add_ancillary_equivalence_mapping(faction_key, callback)
	if not validate.is_string(faction_key) or not validate.is_function(callback) then
		return false;
	end;

	if not payload.equivalence_mapping.ancillary then
		payload.equivalence_mapping.ancillary = {};
	end;

	payload.equivalence_mapping.ancillary[faction_key] = callback;
end;






--- @section Money Payloads


--- @function money_direct
--- @desc Returns a payload string which defines a money reward for a string mission definition. No money-equivalence is looked up when this function is called - use @payload:money to return a money-equivalent reward when appropriate.
--- @p @number amount
--- @r @string payload string
function payload.money_direct(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return "money " .. amount;
end;


--- @function money
--- @desc Returns a payload string which defines a money reward (or equivalent) for a string mission definition. When this function is called, a money-equivalence mapping is looking up based on the supplied faction key. If one was previously added with @payload:add_money_equivalence_mapping then the mapping callback that was supplied to that function is called, and the returned result of that callback is returned by this function. If no remapping for this faction is found, then a money payload string is returned.
--- @p @number amount
--- @p @string faction key
--- @p @table equivalence parameters
--- @r @string payload string
function payload.money(amount, faction_key, params)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	if faction_key and payload.equivalence_mapping.money[faction_key] then
		return payload.equivalence_mapping.money[faction_key](amount, faction_key, params);
	end;

	return "money " .. amount;
end;









--- @section Text Override Payloads


--- @function text_display
--- @desc Returns a payload string which defines a text override for the payload description. If a text override is specified, the mission panel will display that message as the mission reward instead of trying to generate one itself. This is useful in certain circumstances, such as if completing the mission brings some custom scripted reward that the game does not natively support.
--- @p @string text key, Key of text to display, from the <code>campaign_payloads_ui_details</code> database table.
--- @r @string payload string
function payload.text_display(text_key)
	if not validate.is_string(text_key) then
		return false;
	end;

	local payload_string = "text_display " .. text_key;

	return payload_string;
end;











--- @section Agent Payloads


--- @function agent
--- @desc Returns a payload string which defines an agent reward for a string mission definition. No kind of equivalence is looked up.
--- @p @string spawn region, Key of region in which to spawn the agent, from the <code>regions</code> database table.
--- @p @string agent type, Agent type key, from the <code>agents</code> database table.
--- @p @string agent subtype, Agent subtype key, from the <code>agent_subtypes</code> database table.
--- @p [opt=100] @number action points, Percentage of action points that the spawned agent should start with. By default the agent starts with 100% action points.
--- @r @string payload string
function payload.agent(region_key, agent_type, agent_subtype, ap_factor)
	if not validate.is_string(region_key) then
		return false;
	end;

	if not validate.is_string(agent_type) then
		return false;
	end;

	if not validate.is_string(agent_subtype) then
		return false;
	end;

	if ap_factor then
		if not validate.is_number(ap_factor) then
			return false;
		end;
		if ap_factor < 0 or ap_factor > 100 then
			script_error("WARNING: payload.agent() was supplied an action_points factor value of [" .. tostring(ap_factor) .. "] which is not a valid 0 .. 100 percentage value - setting it to be 100%");
			ap_factor = 100;
		end;
	else
		ap_factor = 100;
	end;

	local payload_string = "grant_agent{location " .. region_key .. ";agent_key " .. agent_type .. ";agent_subtype_key " .. agent_subtype .. ";ap_factor " .. ap_factor .. ";}";

	return payload_string;
end;


--- @function agent_at_faction_leader
--- @desc Returns a payload string which defines an agent reward that is created at the event's faction leader for a string mission definition. No kind of equivalence is looked up.
--- @p @string agent type, Agent type key, from the <code>agents</code> database table.
--- @p @string agent subtype, Agent subtype key, from the <code>agent_subtypes</code> database table.
--- @p [opt=100] @number action points, Percentage of action points that the spawned agent should start with. By default the agent starts with 100% action points.
--- @r @string payload string
function payload.agent_at_faction_leader(agent_type, agent_subtype, ap_factor)
	if not validate.is_string(agent_type) then
		return false;
	end;

	if not validate.is_string(agent_subtype) then
		return false;
	end;

	if ap_factor then
		if not validate.is_number(ap_factor) then
			return false;
		end;
		if ap_factor < 0 or ap_factor > 100 then
			script_error("WARNING: payload.agent_at_faction_leader() was supplied an action_points factor value of [" .. tostring(ap_factor) .. "] which is not a valid 0 .. 100 percentage value - setting it to be 100%");
			ap_factor = 100;
		end;
	else
		ap_factor = 100;
	end;

	local payload_string = "grant_agent{location ; military_force_cqi ;agent_key " .. agent_type .. ";agent_subtype_key " .. agent_subtype .. ";ap_factor " .. ap_factor .. ";}";

	return payload_string;
end;


--- @function agent_for_faction
--- @desc Returns a payload string which defines an agent reward for a string mission definition, for a faction. This differs from @payload:agent in that this function takes a faction key, and looks up the home region of that faction. If the faction has no home region, then a script error is thrown and money is substituted.
--- @p @string faction key, Key of faction for which the agent is being spawned, from the <code>factions</code> table. This is used to specify the region in which the agent is spawned - the home region of the faction is used.
--- @p @string agent type, Agent type key, from the <code>agents</code> database table.
--- @p [opt=nil] @string agent subtype, Agent subtype key, from the <code>agent_subtypes</code> database table.
--- @p [opt=100] @number action points, Percentage of action points that the spawned agent should start with. By default the agent starts with 100% action points.
--- @r @string payload string
function payload.agent_for_faction(faction_key, agent_type, agent_subtype, ap_factor)
	if not validate.is_string(faction_key) then
		return false;
	end;

	local faction = cm:get_faction(faction_key);

	if not faction then
		script_error("WARNING: payload.agent_for_faction() called but no faction with key [" .. faction_key .. "] could be found - will generate a payload of 500 money instead");
		return payload.money(500);
	end;

	if not faction:has_home_region() then
		script_error("WARNING: payload.agent_for_faction() called but faction with key [" .. faction_key .. "] has no home region - will generate a payload of 1000 money instead (sounds like they could use it)");
		return payload.money(1000);
	end;

	return payload.agent(faction:home_region():name(), agent_type, agent_subtype, ap_factor);
end;











--- @section Ancillary Payloads


--- @function ancillary_mission_payload
--- @desc Returns a mission reward string that adds the specified ancillary to the faction pool when the mission being constructed is completed.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @p [opt=nil] @string ancillary category, Ancillary category. Valid values are presently <code>"armour"</code>, <code>"enchanted_item"</code>>, <code>"banner"</code>>, <code>"talisman"</code>>, <code>"weapon"</code> and <code>"arcane_item"</code>. Arcane items may only be equipped by spellcasters.
--- @p [opt=nil] @string ancillary rarity, Ancillary rarity. Valid values are presently <code>"common"</code>, <code>"uncommon"</code> and <code>"rare"</code>.
--- @return ancillary mission reward string
function payload.ancillary_mission_payload(faction_key, category, rarity)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if category and not validate.is_string(category) then
		return false;
	end;

	if rarity and not validate.is_string(rarity) then
		return false;
	end;

	if payload.equivalence_mapping.ancillary[faction_key] then
		return payload.equivalence_mapping.ancillary[faction_key](faction_key, category, rarity);
	end;

	local ancillary_key = get_random_ancillary_key_for_faction(faction_key, category, rarity);

	if ancillary_key then
		return "add_ancillary_to_faction_pool{ancillary_key " .. ancillary_key ..";}";
	end;
end;

--- @function ancillary_mission_payload_specific
--- @desc Returns a mission reward string that adds the specified ancillary to the faction pool when the mission being constructed is completed.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @return ancillary mission reward string
function payload.ancillary_mission_payload_specific(faction_key, ancillary_key)

	if not validate.is_string(faction_key) then
		return false
	end;

	if not validate.is_string(ancillary_key) then
		return false
	end;

	if ancillary_key then
		return "add_ancillary_to_faction_pool{ancillary_key " .. ancillary_key ..";}"
	end
end;











--- @section Pooled Resource Payloads


--- @function pooled_resource_mission_payload
--- @desc Returns a mission reward string that adds the specified quantity of the specified pooled resource with the specified factor when the mission being constructed is completed.
--- @p @string pooled resource key, Pooled resource key, from the <code>pooled_resources</code> database table.
--- @p @string factor key, Factor key, from the <code>factor</code> field in the <code>pooled_resource_factor_junctions</code> database table.
--- @p @number quantity, Quantity of pooled resource to award.
--- @return @string pooled resource mission reward string
function payload.pooled_resource_mission_payload(pooled_resource, factor, quantity)
	return "faction_pooled_resource_transaction{resource " .. tostring(pooled_resource) .. ";factor " .. tostring(factor) .. ";amount " .. tostring(quantity) .. ";context absolute;}";
end;


--- @function khorne_glory
--- @desc Returns a payload string which defines a Khorne glory reward for a Daemons of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.khorne_glory(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return payload.pooled_resource_mission_payload("wh3_main_dae_khorne_points", "events", amount);
end;


--- @function nurgle_glory
--- @desc Returns a payload string which defines a Nurgle glory reward for a Daemons of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.nurgle_glory(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return payload.pooled_resource_mission_payload("wh3_main_dae_nurgle_points", "events", amount);
end;


--- @function slaanesh_glory
--- @desc Returns a payload string which defines a Slaanesh glory reward for a Daemons of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.slaanesh_glory(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return payload.pooled_resource_mission_payload("wh3_main_dae_slaanesh_points", "events", amount);
end;


--- @function tzeentch_glory
--- @desc Returns a payload string which defines a Tzeentch glory reward for a Daemons of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.tzeentch_glory(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return payload.pooled_resource_mission_payload("wh3_main_dae_tzeentch_points", "events", amount);
end;


--- @function undivided_glory
--- @desc Returns a payload string which defines an Undivided glory reward for a Daemons of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.undivided_glory(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;

	return payload.pooled_resource_mission_payload("wh3_main_dae_undivided_points", "events", amount);
end;


--- @function skulls
--- @desc Returns a payload string which defines a Skulls reward for a Khorne string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.skulls(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_kho_skulls", "events", amount);
end;


--- @function infections
--- @desc Returns a payload string which defines an Infections reward for a Nurgle string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.infections(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_nur_infections", "events", amount);
end;


--- @function devotees
--- @desc Returns a payload string which defines a Devotees reward for a Slaanesh string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.devotees(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_sla_devotees", "events", amount);
end;


--- @function grimoires
--- @desc Returns a payload string which defines a Grimoires reward for a Tzeentch string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.grimoires(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_tze_grimoires", "events", amount);
end;


--- @function devotion
--- @desc Returns a payload string which defines a Devotion reward for a Kislev string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.devotion(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_ksl_devotion", "events", amount);
end;


--- @function supporters
--- @desc Returns a payload string which defines a Supporters reward for a Kislev string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.supporters(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_ksl_followers", "events", amount);
end;


--- @function meat
--- @desc Returns a payload string which defines a Meat reward for an Ogre Kingdoms string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.meat(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_main_ogr_meat", "events", amount);
end;


--- @function chivalry
--- @desc Returns a payload string which defines a Chivalry reward for a Bretonnia string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.chivalry(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("brt_chivalry", "missions", amount);
end;


--- @function slaves
--- @desc Returns a payload string which defines a Slaves reward for a Dark Elf string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.slaves(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("def_slaves", "missions", amount);
end;


--- @function infamy
--- @desc Returns a payload string which defines a infamy reward for a Vampire Coast string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.infamy(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("cst_infamy", "missions", amount);
end;


--- @function souls
--- @desc Returns a payload string which defines a souls reward for a Warriors of Chaos string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.souls(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", amount);
end;


--- @function canopic jars
--- @desc Returns a payload string which defines a canopic_jars reward for a Tomb Kings string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.canopic_jars(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("tmb_canopic_jars", "missions", amount);
end;


--- @function spirit essence
--- @desc Returns a payload string which defines a spirit_essence reward for a Mother Ostankya (Kislev) string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.spirit_essence(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_dlc24_ksl_spirit_essence", "missions", amount);
end;


--- @function khorne's favour
--- @desc Returns a payload string which defines a khornes_favour reward for a Arbaal (Khorne) string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.khornes_favour(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_dlc26_kho_arbaal_wrath_of_khorne_progress", "missions", amount);
end;


--- @function champion's essence
--- @desc Returns a payload string which defines a champions_essence reward for a Skultaker (Khorne) string mission definition. No kind of equivalence is looked up.
--- @p @number amount
--- @r @string payload string
function payload.champions_essence(amount)
	if not validate.is_positive_number(amount) then
		return false;
	end;
	
	return payload.pooled_resource_mission_payload("wh3_dlc26_kho_champions_essence_faction", "missions", amount);
end;











--- @section Mercenary Payloads


--- @function mercenary_mission_payload
--- @desc Returns a mission reward string that adds the specified quantity of the specified unit to the faction's mercenary pool when the mission being constructed is completed. This would only have an effect for faction's that feature a mercenary pool.
--- @p @string unit key, Unit key, from the <code>main_units</code> database table.
--- @p @number quantity, Quantity of units to add.
function payload.mercenary_mission_payload(unit_key, quantity)
	return "add_mercenary_to_faction_pool{unit_key " .. tostring(unit_key) .. ";amount " .. tostring(quantity) .. ";}";
end;












--- @section Effect Bundles


--- @function effect_bundle_mission_payload
--- @desc Returns a mission reward string that applies the specified effect bundle to the faction when the mission being constructed is completed. An optional duration in turns may be specified.
--- @p @string effect bundle key, Effect bundle key, from the <code>effect_bundles</code> database table.
--- @p @number turns, Number of turns the effect should be applied for. If this is omitted 
function payload.effect_bundle_mission_payload(bundle_key, turns)
	turns = turns or 0;
	return "effect_bundle{bundle_key " .. tostring(bundle_key) .. ";turns " .. tostring(turns) .. ";}";
end;