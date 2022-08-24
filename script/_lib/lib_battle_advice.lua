 

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	ADVICE MANAGER
--
--- @set_environment battle
--- @c advice_manager Advice Manager
--- @desc The battle advice manager provides a framework for managing the delivery of general advice by the advisor in battle. Client scripts create @advice_monitor objects for each item of advice they may wish to deliver. Each advice monitor is then set up to listen for certain in-game events or conditions becoming true, at which point the advice may be triggered. Advice monitors are also assigned a priority to allow higher-priority advice to supercede lower-priority advice.
--- @desc Advice monitors create and use an @advice_manager object to help manage the process of advice delivery. Client scripts do not need to create the @advice_manager themselves, but by doing so they will be able to set it into debug mode for more output with @advice_manager:set_debug, or disable advice with @advice_manager:lock_advice.
--- @desc The advice manager triggers the <code>ScriptEventDeploymentPhaseBegins</code> when deployment phase begins. Advice monitors should listen for this if they want to trigger during deployment rather than another event.
--- @desc The battle advice system outputs debug information to the <code>Lua - Interventions</code> console spool.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


advice_manager = {
	is_debug = false,
	advice_is_playing = false,
	cannot_interrupt = false,
	tab_level = 0,
	advice_lock_level = 0,
	advice_cannot_interrupt_duration = 6000			-- minimum duration that any advice gets to play for before it can be interrupted by other advice (assuming that other advice can interrupt)
	--[[
		advice_monitors = {},
		queue_to_trigger = {},
		enqueued_interruption_advice = {},
		advice_to_restart = {},
		ignore_advice_history_tweaker_warnings_issued = {}
	]]
};


set_class_custom_type_and_tostring(advice_manager, TYPE_ADVICE_MANAGER);





----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new advice manager. Client scripts do not need to call this, however by doing so they will be able to set it into debug mode for more output with @advice_manager:set_debug, or disable advice with @advice_manager:lock_advice.
--- @p [opt=false] boolean debug mode
--- @r advice_manager advice manager
--- @example -- create an advice manager with debug output
--- @example am = advice_manager:new(true);
function advice_manager:new(is_debug)

	local am = core:get_static_object("advice_manager");
	if am then
		return am;
	end;
	
	am = {};
	
	set_object_class(am, self);

	am.advice_monitors = {};
	am.queue_to_trigger = {};
	am.enqueued_interruption_advice = {};
	am.advice_to_restart = {};
	am.ignore_advice_history_tweaker_warnings_issued = {};
	
	if is_debug then
		am.is_debug = true;
		
		self:out("");
		self:out("");
		self:out("*********************************************");
		self:out("*** battle advice is starting");
		self:out("*********************************************");
		self:out("");
	end;
	
	-- start the engagement monitor, this monitors many battle conditions that our advice monitors are interested in
	bm:start_engagement_monitor();

	-- Start advice monitors when a PanelClosedBattle event is received for the winds of magic gambler. This means we're in deployment
	-- and the gambler has either been dismissed or wasn't on-screen at all.
	core:add_listener(
		"deployment_phase_winds_of_magic_gambler", 
		"PanelClosedBattle",
		function(context) return context.string == "winds_of_magic_gambler" end,
		function()
			am.advice_is_playing = false;
			am.cannot_interrupt = false;

			-- start all advice monitors here
			am:start_all_advice_monitors();

			am:out("*** Deployment phase has begun and the Winds of Magic gambler has been dismissed or wasn't shown :: triggering event ScriptEventDeploymentPhaseBegins ***");
			am:out("");
			core:trigger_event("ScriptEventDeploymentPhaseBegins");
		end,
		false
	);
	
	-- Reset advice-playing status when conflict phases begin (allows advice to trigger at start of phase).
	bm:register_phase_change_callback(
		"Deployed", 
		function() 
			am.advice_is_playing = false;
			am.cannot_interrupt = false;
			am:out("*** Conflict phase beginning :: triggering event ScriptEventConflictPhaseBegins ***");
			am:out("");
			core:trigger_event("ScriptEventConflictPhaseBegins");
		end
	);
	
	-- send an event notification when battle enters victory countdown phase, this will shut down most advice monitors
	bm:register_phase_change_callback("VictoryCountdown", function() core:trigger_event("ScriptEventVictoryCountdownPhaseBegins") end);
		
	bm:set_close_queue_advice(false);
	
	-- register the advice manager as a static object
	core:add_static_object("advice_manager", am);
	
	return am;
end;


-- internal function to get or create an advice manager - used by advice monitors
function get_advice_manager()
	local am = core:get_static_object("advice_manager");
	
	if am then
		return am;
	end;
	
	return advice_manager:new();
end;


-- internal function that advice monitors use to register themselves with the advice manager
function advice_manager:register_advice_monitor(advice_monitor)
	if not is_advicemonitor(advice_monitor) then
		script_error("ERROR: register_advice_monitor() called but supplied advice monitor [" .. tostring(advice_monitor) .. "] is not an advice monitor");
		return false;
	end;
	
	if self:get_advice_monitor(advice_monitor.name) then
		script_error("ERROR: register_advice_monitor() called but an advice monitor with supplied name [" .. tostring(advice_monitor.name) .. "] has already been registered");
		return false;
	end; 
	
	self:out("registering advice monitor [" .. advice_monitor.name .. "] with priority [" .. advice_monitor.priority .. "]");
	
	self.advice_monitors[advice_monitor.name] = advice_monitor;
end;


-- internal function to get an advice monitor from the manager by name
function advice_manager:get_advice_monitor(name)
	return self.advice_monitors[name];
end;


--- @function set_debug
--- @desc Sets debug mode on the advice manager for more output
--- @p [opt=true] boolean debug mode
function advice_manager:set_debug(value)
	if value == false then
		self.is_debug = false;
	else
		self.is_debug = true;
	end;
end;


--- @function lock_advice
--- @desc Adds an advice lock level to the advice manager, preventing the advice manager from triggering any advice. No advice monitors will trigger if any advice lock is active, and advice only unlocked when all advice locks are removed with @advice_manager:unlock_advice.
function advice_manager:lock_advice()
	self.advice_lock_level = self.advice_lock_level + 1;
end;


--- @function unlock_advice
--- @desc Removes an advice lock level to the advice manager, potentially allowing the advice manager to trigger advice again. Advice locks are added with @advice_manager:lock_advice. No advice monitors will trigger if any advice lock is active, and advice only unlocked when all advice locks are removed with @advice_manager:unlock_advice.
function advice_manager:unlock_advice()
	if self.advice_lock_level == 0 then
		script_error("WARNINNG: advice_manager:unlock_advice() called but advice is not locked - this will be disregarded but should be fixed as something is not in sync");
		return;
	end;

	self.advice_lock_level = self.advice_lock_level - 1;
end;


-- debug output
function advice_manager:out(str)
	if self.tab_level > 0 then		
		for i = 1, self.tab_level do
			str = "\t" .. str;
		end;
	end;
	out.interventions(str);
end;


function advice_manager:inc_tab()
	self.tab_level = self.tab_level + 1;
end;


function advice_manager:dec_tab()
	if self.tab_level > 0 then
		self.tab_level = self.tab_level - 1;
	end;
end;


-- internal function to start all advice monitors, called in deployment phase
function advice_manager:start_all_advice_monitors()
	if self.is_debug then
		self:out("");
		self:out("##################################################################");
		self:out("### start_all_advice_monitors() called");
	end;

	for monitor_name, monitor in pairs(self.advice_monitors) do
		monitor:start();
	end;
	
	if self.is_debug then
		self:out("##################################################################");
		self:out("");
	end;
end;


-- called internally when an advice monitor wants to trigger its advice. The advice manager will enqueue it for a little bit and then trigger the highest-priority advice available
function advice_manager:attempt_to_trigger(advice_monitor)

	if advice_monitor.is_enqueued_to_trigger then
		if self.is_debug then
			self:out("Attempting to trigger advice monitor " .. advice_monitor.name .. " but it's already enqueued, doing nothing");
		end;
		return;
	end;

	if self.advice_is_playing then
		if advice_monitor.can_interrupt_other_advice then
			if self.cannot_interrupt then
				if self.is_debug then
					self:out("Attempting to trigger advice monitor " .. advice_monitor.name .. " - advice is currently playing and it can interrupt, but the cannot_interrupt flag is set (this is probably very soon after a previous piece of advice was triggered) - enqueuing for when it can");
				end;
				
				table.insert(self.enqueued_interruption_advice, advice_monitor);
				return;
			end;
			
		else		
			if self.is_debug then
				self:out("Attempting to trigger advice monitor " .. advice_monitor.name .. " - advice is currently playing and it cannot interrupt. Will restart this monitor when the advice has finished");
			end;
			table.insert(self.advice_to_restart, advice_monitor);
			return;
		end;
	end;
	
	-- if we have no enqueued monitors then wait one second for other advice monitors to trigger, after which we decide which one is the highest priority
	if #self.queue_to_trigger == 0 then
		bm:callback(
			function()
				-- also wait for the loading screen here if it's visible
				core:progress_on_loading_screen_dismissed(
					function()
						self:trigger_next_advice()
					end				
				);
			end,
			1000,
			"advice_manager"
		);
	end;
	
	if self.is_debug then
		self:out("Attempting to trigger advice monitor " .. advice_monitor.name .. " - nothing is stopping this monitor from queueing, so enqueuing it");
	end;
	
	advice_monitor.is_enqueued_to_trigger = true;
	
	table.insert(self.queue_to_trigger, advice_monitor);
end;


-- called internally to actually trigger some advice - triggers the highest priority enqueued advice
function advice_manager:trigger_next_advice()
	local queue_to_trigger = self.queue_to_trigger;
	
	if #queue_to_trigger == 0 then
		if self.is_debug then
			self:out("******************************************************************************************");
			self:out("******************************************************************************************");
			self:out("trigger_next_advice() called but no advice is enqueued, exiting");
			self:out("******************************************************************************************");
			self:out("******************************************************************************************");
			return;
		end;
	end;
	
	if self.is_debug then
		self:out("******************************************************************************************");
		self:out("******************************************************************************************");
		self:out("trigger_next_advice() called");
	end;
	
	-- get the highest-priority advice waiting to trigger
	local highest_priority = -1;
	local highest_priority_advice_monitor = false;
	local highest_priority_index = -1;
	local consider_interruption_advice_only = false;
	
	self:inc_tab();
	
	for i = 1, #queue_to_trigger do
		local current_monitor = queue_to_trigger[i];
		
		current_monitor.is_enqueued_to_trigger = false;
		
		if self.is_debug then
			self:out("querying advice " .. current_monitor.name .. " with priority " .. current_monitor.priority .. ", can_interrupt_other_advice is " .. tostring(current_monitor.can_interrupt_other_advice));
		end;
		
		if not consider_interruption_advice_only and current_monitor.can_interrupt_other_advice then
			-- first time we find an item of advice that can interrupt, automatically make this the highest priority monitor and only consider similar advice as we move on through the list
			consider_interruption_advice_only = true;
			highest_priority = current_monitor.priority;
			highest_priority_advice_monitor = current_monitor;
			highest_priority_index = i;
			
		elseif not consider_interruption_advice_only or (consider_interruption_advice_only and current_monitor.can_interrupt_other_advice) then
			-- only do this check if we don't care whether the advice can interrupt, or we do and it can
			if current_monitor.priority > highest_priority then
				highest_priority = current_monitor.priority;
				highest_priority_advice_monitor = current_monitor;
				highest_priority_index = i;
			end;
		end;
	end;
	
	-- remove the advice to trigger from the queue
	table.remove(queue_to_trigger, highest_priority_index);
	
	-- add all advice still remaining in the queue to the to-restart list
	for i = 1, #queue_to_trigger do
		table.insert(self.advice_to_restart, queue_to_trigger[i]);
	end;
	
	-- clear the queue
	self.queue_to_trigger = {};
	
	if self.is_debug then
		self:out("------");
		self:out("going to trigger " .. highest_priority_advice_monitor.name .. " with duration " .. highest_priority_advice_monitor.duration);
		self:dec_tab();
		self:out("******************************************************************************************");
		self:out("******************************************************************************************");
		self:out("");
	end;
	
	-- stop any previous countdown to when advice is finishing as we're about to play new advice
	bm:remove_process("advice_manager_advice_playing_monitor");
	
	self.advice_is_playing = true;
	self.cannot_interrupt = true;
	
	core:add_listener(
		"BattleAideDeCampEvent",
		"BattleAideDeCampEvent",
		true,
		function(context) bm:out("*** BattleAideDeCampEvent received, context.string is " .. context.string) end,
		true
	);
	
	bm:callback(
		function() 
			self.cannot_interrupt = false;
			self:advice_can_now_interrupt();
		end,
		self.advice_cannot_interrupt_duration,
		"advice_manager_advice_playing_monitor"
	);
	
	bm:callback(
		function()
			if self.cannot_interrupt then
				self.cannot_interrupt = false;
				self:advice_can_now_interrupt();
			end;

			self.advice_is_playing = false;
			self:advice_has_finished();
		end,
		highest_priority_advice_monitor.duration,
		"advice_manager_advice_playing_monitor"
	);
	
	-- tell the advice to trigger
	highest_priority_advice_monitor:trigger();
end;


-- called a little after after any advice starts playing, and allows other advice to interrupt the advice playing. Before this is called, the advice being played cannot be interrupted, even by advice that is allowed to interrupt.
-- Advice that is allowed to interrupt that is triggered before this function is called is added to a pool which will be re-added for triggering when this function is called.
function advice_manager:advice_can_now_interrupt()

	if self.is_debug then
		self:out("------------------------------------------------------------------");
		
		local append_str;
		
		if #self.enqueued_interruption_advice == 0 then
			append_str = "no advice enqueued";
		elseif #self.enqueued_interruption_advice == 1 then
			append_str = "1 item of advice enqueued";
		else
			append_str = #self.enqueued_interruption_advice .. " items of advice enqueued";
		end;
		
		self:out("advice_can_now_interrupt() called, " .. append_str);
		self:inc_tab();
	end;
	
	for i = 1, #self.enqueued_interruption_advice do
		self:attempt_to_trigger(self.enqueued_interruption_advice[i]);
	end;
	
	self.enqueued_interruption_advice = {};		
	
	if self.is_debug then
		self:dec_tab();
		self:out("------------------------------------------------------------------");
		self:out("");
	end;
end;


-- Called when an item of advice has "finished", which is when its set duration has expired and not when the VO has actually completed.
-- This restarts any advice monitors that were previously enqueued but where the advice was not shown, allowing them to trigger again.
function advice_manager:advice_has_finished()

	bm:remove_process("advice_manager_advice_playing_monitor");

	if self.is_debug then
		self:out("---------------------------------");
		self:out("advice_has_finished() called - restarting stopped advice monitors");
		self:inc_tab();
	end;
	
	-- restart all advice that was previously unable to trigger
	for i = 1, #self.advice_to_restart do
		local current_monitor = self.advice_to_restart[i];
		
		if self.is_debug then
			self:out("restarting monitor " .. current_monitor.name);
		end;
		
		current_monitor:start_trigger_listeners();
	end;
	
	self.advice_to_restart = {};
	
	if self.is_debug then
		self:dec_tab();
		self:out("---------------------------------");
		self:out("");
	end;
end;


-- An advice monitor is halting - remove it from any pending lists so that it can't play
function advice_manager:advice_monitor_is_halting(advice_monitor)
	-- remove this advice monitor from any internal queues
	local queue_to_trigger = self.queue_to_trigger;
	for i = 1, #queue_to_trigger do
		if queue_to_trigger[i] == advice_monitor then
			table.remove(queue_to_trigger, i);
			break;
		end;
	end;
	
	local enqueued_interruption_advice = self.enqueued_interruption_advice;
	for i = 1, #enqueued_interruption_advice do
		if enqueued_interruption_advice[i] == advice_monitor then
			table.remove(enqueued_interruption_advice, i);
			break;
		end;
	end;
	
	local advice_to_restart = self.advice_to_restart;
	for i = 1, #advice_to_restart do
		if advice_to_restart[i] == advice_monitor then
			table.remove(advice_to_restart, i);
			break;
		end;
	end;
end;

























----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	ADVICE MONITOR
--
--- @c advice_monitor Advice Monitor
--- @page advice_manager

--- @desc Advice monitors provide a mechanism for the detection of trigger conditions of an individual item of advice, and for deciding whether to then trigger it. One advice monitor encapsulates the triggering conditions for one line of generic advice, so it's common to create multiple such objects. Each advice monitor attempts to create an @advice_manager (should one not exist already) which provides backbone services to all running advice monitors.
--- @desc Advice monitor trigger conditions may be specified as an event, a event with a condition, or just a condition. In the latter case the condition is repeatedly polled until it becomes true. Advice monitors also support the declaration of start conditions, which define when an advice monitor should start listening/polling for the trigger conditions, and halt conditions, which define when the monitor should stop. Like trigger conditions, start conditions and halt conditions may be specified as events, events with conditions, or just conditions. Multiple start/trigger/halt conditions may be specified for each advice monitor.
--- @desc Advice monitors also support the calling of a trigger function as well as, or instead of, playing the advice itself. Use @advice_monitor:set_trigger_callback to set such a function.
--- @desc Should the advice associated with the advice monitor have been played before, the advice monitor shuts down on startup.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


advice_monitor = {
	am = false,	
	priority = 0,
	name = "",
	advice_key = "",
	
	duration = 60000,
	delay_before_triggering = 1000,
	advice_level = 1,
	
	-- callback to trigger instead of playing the advice ourselves
	callback_to_trigger = false,
	
	
	trigger_callback = false,
	halt_callback = false,
	
	should_trigger_advice = true,
	
	halt_advice_on_battle_end = true,
	trigger_listeners_started = false,
	
	
	can_interrupt_other_advice = false,
	
	is_started = false,
	is_enqueued_to_trigger = false,
	is_halted = false
	
	--[[
	infotext = {},
	start_conditions = {},
	trigger_conditions = {},
	halt_conditions = {},
	halt_on_advice_monitor_triggering = {},
	halt_advice_monitor_on_trigger = {},
	ignore_advice_history_conditions = {}
	]]
};


set_class_custom_type(advice_monitor, TYPE_ADVICE_MONITOR);
set_class_tostring(
	advice_monitor,
	function(obj)
		return TYPE_ADVICE_MONITOR .. "_" .. am.name
	end
);








----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new advice monitor.
--- @p string name, Name for the advice monitor. Must be unique amongst advice monitors.
--- @p number priority, Priority of the advice. When two items of advice wish to trigger at the same time, the advice with the higher priority is triggered.
--- @p string advice key, Key of the advice to trigger. The history of this advice thread is also checked when monitor is started - if it has been heard before then the monitor does not start.
--- @p [opt=nil] table infotext, Table of infotext keys to show alongside the advice.
--- @r advice_monitor advice monitor
--- @new_example Deployment advice
--- @example advice_deployment = advice_monitor:new(
--- @example 	"deployment",
--- @example 	50,
--- @example 	"war.battle.advice.deployment.001",
--- @example 	{
--- @example 		"war.battle.advice.deployment.info_001",
--- @example 		"war.battle.advice.deployment.info_002",
--- @example 		"war.battle.advice.deployment.info_003",
--- @example 		"war.battle.advice.deployment.info_004"
--- @example 	}
--- @example );
function advice_monitor:new(name, priority, advice_key, infotext)
	if not is_string(name) then
		script_error("ERROR: attempting to create advice monitor but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_number(priority) or priority < 0 then
		script_error("ERROR: attempting to create advice monitor but supplied priority [" .. tostring(priority) .. "] is not a positive number");
		return false;
	end;
	
	if not is_string(advice_key) then
		script_error("ERROR: attempting to create advice monitor but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	if infotext and not is_table(infotext) then
		script_error("ERROR: attempting to create advice monitor but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;

	local am = get_advice_manager();
	
	-- check that an advice monitor of this name has not already been registered
	if am:get_advice_monitor(name) then
		script_error("ERROR: attempting to create advice monitor but an advice monitor with the supplied name [" .. name .. "] already exists");
		return false;
	end;
	
	local a = {};
		
	a.am = am;
	a.name = name;

	set_object_class(a, self);
	
	a.priority = priority;
	a.advice_key = advice_key;
	a.infotext = infotext;
	
	a.start_conditions = {};
	a.trigger_conditions = {};
	a.halt_conditions = {};
	
	a.halt_on_advice_monitor_triggering = {};
	a.halt_advice_monitor_on_trigger = {};
	a.ignore_advice_history_conditions = {};
	
	am:register_advice_monitor(a);
	
	return a;	
end;


-- internal function to test whether the advice manager is set in debug mode
function advice_monitor:is_debug()
	return self.am.is_debug;
end;










----------------------------------------------------------------------------
---	@section Configuration
----------------------------------------------------------------------------


--- @function set_advice_level
--- @desc Sets the minimum advice level at which the advice may be allowed to trigger. If the advice level is set to less than that required by the advice monitor when the advice monitor is started, then the monitor will immediately terminate. By default, advice monitors allow their advice to trigger if the advice level is set to low or high.
--- @p @number advice level, Minimum advice level. Valid values are 0 (minimul advice), 1 (low advice) and 2 (high advice).
function advice_monitor:set_advice_level(value)
	if value == 0 or value == 1 or value == 2 then
		self.advice_level = value;
	else
		script_error(self.name .. " ERROR: set_advice_level() called but supplied advice level is not recognised - valid values are 0 (priority-less), 1 (low priority) or 2 (high priority)");
	end;
end;


--- @function set_can_interrupt_other_advice
--- @desc Sets whether this advice can interrupt other advice. By default this is disabled.
--- @p [opt=true] @boolean can interrupt
function advice_monitor:set_can_interrupt_other_advice(value)
	if value == false then
		self.can_interrupt_other_advice = false;
	else
		self.can_interrupt_other_advice = true;
	end;
end;


--- @function set_delay_before_triggering
--- @desc Sets a delay period before the advice is actually triggered. This is 1000ms by default.
--- @p @number delay in ms
function advice_monitor:set_delay_before_triggering(value)
	if is_number(value) and value >= 0 then
		self.delay_before_triggering = value;
	end;
end;


--- @function set_duration
--- @desc Sets the duration for which this advice monitor blocks other non-interrupting advice for. By default this is 60000ms.
--- @p @number duration in ms
function advice_monitor:set_duration(value)
	if not validate.is_number(value) then
		return false;
	end;

	self.duration = value;
end;


--- @function set_trigger_callback
--- @desc Sets a callback for the advice monitor to call at the point the advice is triggered (i.e. after any delay set with @advice_monitor:set_delay_before_triggering).
--- @p @function callback, Callback to call.
--- @p [opt=false] @boolean dont trigger advice, If set to <code>true</code>, this monitor will trigger the callback but will not trigger the supplied advice or infotext itself. Set this to <code>true</code> if the callback takes care of triggering the advice itself.
function advice_monitor:set_trigger_callback(callback, do_not_trigger_advice)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_trigger_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self.trigger_callback = callback;
	self.should_trigger_advice = not do_not_trigger_advice;
end;

--- @function set_halt_callback
--- @desc Sets a callback for the advice monitor to call at the point the advice is halted.
--- @p @function callback, Callback to call.
function advice_monitor:set_halt_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_halt_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self.halt_callback = callback;
end;


--- @function set_halt_advice_on_battle_end
--- @desc Sets the advice monitor to automatically halt or not when the battle ends. Advice monitors do halt when the battle ends by default - use this function to suppress this behaviour.
--- @p [opt=true] @boolean halt on end
function advice_monitor:set_halt_advice_on_battle_end(value)
	if value == false then
		self.halt_advice_on_battle_end = false;
	else
		self.halt_advice_on_battle_end = true;
	end;
end;












----------------------------------------------------------------------------
---	@section Ignore Advice History Conditions
---	@desc By default, advice monitors will not start or trigger if the advice key supplied to @advice_monitor:new is present in the advice history, which is to say that it has been triggered before. This behaviour can be overridden by setting an ignore advice history condition with @advice_monitor:add_ignore_advice_history_condition. If any condition added with this function returns <code>true</code> when the advice monitor starts then the advice monitor will disregard advice history when deciding to trigger. This can be used to set certain conditions that force advice to trigger even if it's been heard before, such as time elapsed since a timestamp last recorded (e.g. player hasn't done X for a certain period of time, so let's remind them how it works) or tweaker settings (to force a certain bit of advice to trigger for development purposes).
--- @desc Note that ignore advice history conditions will not override other considerations that may prevent a certain advice monitor from triggering, such as advice level settings.
----------------------------------------------------------------------------


--- @function add_ignore_advice_history_condition
--- @desc Adds an ignore advice history condition callback. Advice history conditions are queried when the advice monitor is started and, if any return <code>true</code> or a value that evaluates to true then advice history for this advice monitor will be disregarded when it decides whenther to start.
--- @p @function condition
function advice_monitor:add_ignore_advice_history_condition(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(self.ignore_advice_history_conditions, callback);
end;


--- @function add_ignore_advice_history_tweaker
--- @desc Adds an ignore advice history condition for a tweaker. If the supplied tweaker is set, then the advice monitor will ignore its advice history condition. Tweakers are used during development and the game should not be released with any tweakers active. Therefore, a script error will be thrown if the tweaker is set to remind developers to unset it at some point.
--- @p @string tweaker name
function advice_monitor:add_ignore_advice_history_tweaker(tweaker_name)
	if not validate.is_string(tweaker_name) then
		return false;
	end;

	local callback = function()
		if core:is_tweaker_set(tweaker_name) then
			-- Issue a script error for this tweaker being set. We only want to issue one for each tweaker, as one tweaker may be connected to lots of advice monitors, so we maintain a list on the advice manager
			if not self.am.ignore_advice_history_tweaker_warnings_issued[tweaker_name] then
				self.am.ignore_advice_history_tweaker_warnings_issued[tweaker_name] = true;
				script_error("WARNING: tweaker " .. tweaker_name .. " is set which means advice monitor " .. self.name .. " (and potentially others) is ignoring advice history - advice will be triggering where it otherwise wouldn't");
			end;
			return true;
		end;
	end;

	table.insert(self.ignore_advice_history_conditions, callback);
end;








----------------------------------------------------------------------------
---	@section Start Conditions
---	@desc By default, advice monitors start monitoring for their trigger conditions when the deployment phase of the battle begins. This can be changed by adding one or more start conditions with @advice_monitor:add_start_condition.
----------------------------------------------------------------------------


--- @function add_start_condition
--- @desc Adds a start condition for the advice monitor, which determines when the advice monitor will begin monitoring its trigger conditions. Supply one of the following combination of arguments:
--- @desc <ul><li>A condition function that returns a boolean value. In this case, the condition will be repeatedly called until it returns <code>true</code>. Once this happens the advice monitor will begin monitoring for the trigger condition.</li>
--- @desc <li>A condition function that returns a boolean value, and an event. In this case, the event will be listened for and, when received, the condition function called. Should it return <code>true</code> the advice monitor will begin monitoring for the trigger condition.</li>
--- @desc <li><code>true</code> in place of a condition function, and an event. In this case, the advice monitor will begin monitoring for the trigger condition as soon as the event is received, with no conditional check.</li></ul>
--- @p function condition, Conditional function. Supply a function that returns a boolean value, or <code>true</code> (if also supplying an event).
--- @p [opt=nil] string event, Event to test.
--- @new_example
--- @desc This advice monitor starts monitoring its trigger conditions when a player unit routs.
--- @example advice_player_rallies:add_start_condition(
--- @example 	function() 
--- @example		return num_units_routing(player_army) > 0
--- @example	end
--- @example );
--- @new_example
--- @desc This advice monitor starts monitoring its trigger conditions when a unit attacks the walls.
--- @example advice_siege_capture:add_start_condition(
--- @example 	true,
--- @example 	"BattleUnitAttacksWalls"
--- @example );
--- @new_example
--- @desc This advice monitor starts at the beginning of conflict phase, if the player has one or more artillery pieces.
--- @example advice_player_artillery:add_start_condition(
--- @example 	function()	
--- @example 		local player_artillery = num_units_passing_test(
--- @example 			bm:get_player_army(), 
--- @example 			function(unit)
--- @example 				return unit:unit_class() == "art_fld";
--- @example 			end
--- @example 		);
--- @example 		return player_artillery > 0;
--- @example 	end,
--- @example 	"ScriptEventConflictPhaseBegins"
--- @example );
function advice_monitor:add_start_condition(condition, event)
	if not is_function(condition) and condition ~= true then
		script_error(self.name .. " ERROR: add_start_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	if event and not is_string(event) then
		script_error(self.name .. " ERROR: add_start_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	local condition_record = {};
	condition_record.condition = condition;
	condition_record.event = event;
	
	table.insert(self.start_conditions, condition_record);
end;









----------------------------------------------------------------------------
---	@section Trigger Conditions
--- @desc Trigger conditions tell advice monitors when to try and play advice. Once started (either when deployment phase begins or when a condition registered with @advice_monitor:add_start_condition passes), an advice monitor begins monitoring for one of its trigger conditions to pass. Once a trigger condition passes the advice monitor stops its trigger monitors, and sends the advice to the @advice_manager. This waits a short period for other advice to also trigger, then picks the highest-priority advice from the available selection. The unsuccessful advice monitors are restarted when the successful advice finishes, and may be triggered again.
--- @desc Each advice monitor must have at least one trigger condition registered, otherwise it won't be able to fire its advice at all.
----------------------------------------------------------------------------


--- @function add_trigger_condition
--- @desc Adds a trigger condition for the advice monitor. Supply one of the following combination of arguments:
--- @desc <ul><li>A condition function that returns a boolean value. In this case, the condition will be polled until it passes, at which point the advice will be considered for playing.</li>
--- @desc <li>A condition function that returns a boolean value, and an event. In this case, the event will be listened for and, when received, the condition checked. Should it pass, the advice will be considered for playing.</li>
--- @desc <li><code>true</code> in place of a condition function, and an event. In this case, the advice will be considered for playback when the event is received.</li></ul>
--- @p function condition, Conditional function. Supply a function that returns a boolean value, or <code>true</code> (if also supplying an event).
--- @p [opt=nil] string event, Event to test.
--- @new_example
--- @desc Trigger advice when a player unit rallies.
--- @example advice_player_unit_rallies:add_trigger_condition(
--- @example 	true,
--- @example	"ScriptEventPlayerUnitRallies"
--- @example );
--- @new_example
--- @desc Trigger advice when one of the player's giants becomes visible to the enemy.
--- @example advice_player_giant:add_trigger_condition(
--- @example 	function()
--- @example 		local enemy_alliance = advice_player_giant.enemy_alliance;
--- @example 		local player_giants = advice_player_giant.player_giants;
--- @example 		local num_visible_player_giants = num_units_passing_test(
--- @example 			player_giants,
--- @example 			function(unit)
--- @example 				return unit:is_visible_to_alliance(enemy_alliance);
--- @example 			end
--- @example 		);
--- @example 		return num_visible_player_giants > 0;
--- @example 	end
--- @example );
function advice_monitor:add_trigger_condition(condition, event)
	if not is_function(condition) and condition ~= true then
		script_error(self.name .. " ERROR: add_trigger_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	if event and not is_string(event) then
		script_error(self.name .. " ERROR: add_trigger_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	local condition_record = {};
	condition_record.condition = condition;
	condition_record.event = event;
	
	table.insert(self.trigger_conditions, condition_record);
end;











----------------------------------------------------------------------------
---	@section Halt Conditions
--- @desc Halt conditions tell advice monitors when to stop monitoring. For example, advice about preparing an ambush would be inappropriate for playback when the two armies engage, so such an advice monitor could be halted. Like start and trigger conditions, halt conditions can be supplied as events, conditions, or events and conditions.
----------------------------------------------------------------------------


--- @function add_halt_condition
--- @desc Adds a halt condition for the advice monitor. Supply one of the following combination of arguments:
--- @desc <uo><li>A condition function that returns a boolean value. In this case, the condition will be polled until it passes, at which point the monitor halts.</li>
--- @desc <li>A condition function that returns a boolean value, and an event. In this case, the event will be listened for and, when received, the condition checked. Should it pass, the advice monitor will halt.</li>
--- @desc <li><code>true</code> in place of a condition function, and an event. In this case, the advice monitor will halt when the event is received.</li></ul>
--- @p function condition, Conditional function. Supply a function that returns a boolean value, or <code>true</code> (if also supplying an event).
--- @p [opt=nil] string event, Event to test.
--- @new_example
--- @desc Halt when the "enemy victory point captured" aide-de-camp message is shown.
--- @example advice_player_captures_victory_point:add_trigger_condition(
--- @example 	function(context)
--- @example 		return context.string == "adc_enemy_point_captured"
--- @example 	end,
--- @example 	"BattleAideDeCampEvent"
--- @example );
--- @new_example
--- @desc Halt when the <code>ScriptEventPlayerApproachingVictoryPoint</code> event is received.
--- @example advice_player_approaches_victory_point:add_trigger_condition(
--- @example 	true,
--- @example 	"ScriptEventPlayerApproachingVictoryPoint"
--- @example );
function advice_monitor:add_halt_condition(condition, event)
	if not is_function(condition) and condition ~= true then
		script_error(self.name .. " ERROR: add_halt_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function or true");
		return false;
	end;
	
	if event and not is_string(event) then
		script_error(self.name .. " ERROR: add_halt_condition() called but supplied condition [" .. tostring(condition) .. "] is not a function");
		return false;
	end;
	
	local condition_record = {};
	condition_record.condition = condition;
	condition_record.event = event;
	
	table.insert(self.halt_conditions, condition_record);
end;


--- @function add_halt_on_advice_monitor_triggering
--- @desc Halts this advice monitor when another advice monitor successfully triggers its advice. The other advice monitor is specified by its name.
--- @p string name, Name of advice monitor to halt on.
function advice_monitor:add_halt_on_advice_monitor_triggering(monitor_name)
	if not is_string(monitor_name) then
		script_error(self.name .. " ERROR: add_halt_on_advice_monitor_triggering() called but supplied monitor name [" .. tostring(monitor_name) .. "] is not a string");
		return false;
	end;

	self.halt_on_advice_monitor_triggering[monitor_name] = true;
end;


--- @function add_halt_advice_monitor_on_trigger
--- @desc Halts another advice monitor when this monitor successfully triggers. The other advice monitor is specified by its name.
--- @p string name, Name of advice monitor to halt when this monitor triggers.
function advice_monitor:add_halt_advice_monitor_on_trigger(monitor_name)
	if not is_string(monitor_name) then
		script_error(self.name .. " ERROR: add_halt_advice_monitor_on_trigger) called but supplied monitor name [" .. tostring(monitor_name) .. "] is not a string");
		return false;
	end;

	self.halt_advice_monitor_on_trigger[monitor_name] = true;
end;



--
--	starting
--

function advice_monitor:start()
	local name = self.name;

	if self.is_started then
		script_error(name .. " WARNING: an attempt was made to start this advice monitor but it's already been started");
		return false;
	end;
	
	if self.is_halted then
		script_error(name .. " WARNING: an attempt was made to start this advice monitor but it's previously been halted");
		return false;
	end;
	
	local am = self.am;
	
	-- Set that we should ignore advice history (if any of our ignore advice history conditions return true)
	local should_ignore_advice_history = false;
	local ignore_advice_history_conditions = self.ignore_advice_history_conditions;
	for i = 1, #ignore_advice_history_conditions do
		if ignore_advice_history_conditions[i]() then
			should_ignore_advice_history = true;
			am:out(name .. " is ignoring advice history because ignore advice history condition [" .. i .. "] returned true");
			break;
		end;
	end;

	-- If we should not ignore advice history then check the advice history of this advice monitor
	if not should_ignore_advice_history then
		local advice_score = common.get_advice_thread_score(self.advice_key);
		if is_number(advice_score) and advice_score > 0 then		
			if self:is_debug() then
				am:out(name .. " not starting listeners as advice key [" .. self.advice_key .. "] has already been listened to");
				return;
			end;
		end;
	end;
	
	-- see if the advice level permits this advice from happening
	if self.advice_level > common.get_advice_level() then
		if self:is_debug() then
			am:out(name .. " not starting listeners as minimum advice level [" .. self.advice_level .. "] is greater than current advice level setting [" .. common.get_advice_level() .. "] (0 = no advice, 1 = low advice, 2 = high advice)");
			return;
		end;
	end;
	
	self.is_started = true;
	
	if self:is_debug() then
		am:out(name .. " starting listeners");
		am:inc_tab();
	end;
	
	if #self.trigger_conditions == 0 then
		if self:is_debug() then
			am:out("no trigger listeners registered - not proceeding");
			am:dec_tab();
		end;
		return;
	end;
	
	--
	-- make sure other monitors are notified that they should halt this monitor, or be halted by it
	--
	
	for monitor_name in pairs(self.halt_on_advice_monitor_triggering) do
		local monitor = am:get_advice_monitor(monitor_name);
		if monitor then
			monitor:add_halt_advice_monitor_on_trigger(self.name);
		end;
	end;
	
	for monitor_name in pairs(self.halt_advice_monitor_on_trigger) do
		local monitor = am:get_advice_monitor(monitor_name);
		if monitor then
			monitor:add_halt_on_advice_monitor_triggering(self.name);
		end;
	end;
	
	-- add a halt condition for battle completion if required
	if self.halt_advice_on_battle_end then
		self:add_halt_condition(true, "ScriptEventVictoryCountdownPhaseBegins");
	end;
	
	--
	-- start halt listeners
	--
	
	for i = 1, #self.halt_conditions do
		local condition_record = self.halt_conditions[i];
		
		local event = condition_record.event;
		local condition = condition_record.condition;
		
		-- if we have an event, then we listen for the event to occur and then test the condition, otherwise we poll the condition constantly
		if is_string(event) then
		
			if self:is_debug() then
				am:out("establishing halt listener for event [" .. event .. "]");
			end;
		
			core:add_listener(
				name .. "_halt_listeners",
				event,
				condition,
				function()
					if self:is_debug() then
						am:out("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						am:out(name .. " is halting due to satisfied condition with triggered event [" .. event .. "]");
						am:inc_tab();
					end;
					
					self:halt();
					
					if self:is_debug() then
						am:dec_tab();
						am:out("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						am:out("");
					end;
				end,
				false
			);
		else
			if self:is_debug() then
				am:out("establishing halt poll");
			end;
			
			bm:watch(
				function()
					return condition();
				end,
				0,
				function()
					if self:is_debug() then
						am:out("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						am:out(name .. " is halting because of satisfied polling condition");
						am:inc_tab();
					end;
					
					self:halt();
					
					if self:is_debug() then
						am:dec_tab();
						am:out("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						am:out("");
					end;
				end,
				name .. "_startup_listeners"
			);
		end;
	end;
	
	
	--
	-- start startup listeners
	--
	
	-- if we have no start listeners declared then just start the trigger listeners
	if #self.start_conditions == 0 then
		if self:is_debug() then
			am:out("no start listeners declared so starting trigger listeners");
		end;
		
		self:start_trigger_listeners();
		am:dec_tab();
		return;
	end;
	
	for i = 1, #self.start_conditions do
		local condition_record = self.start_conditions[i];
		
		local event = condition_record.event;
		local condition = condition_record.condition;
		
		-- if we have an event, then we listen for the event to occur and then test the condition, otherwise we poll the condition constantly
		if is_string(event) then
		
			if self:is_debug() then
				am:out("establishing startup listener for event [" .. event .. "]");
			end;
		
			core:add_listener(
				name .. "_startup_listeners",
				event,
				condition,
				function()
					if self:is_debug() then
						am:out("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
						am:out(name .. " is starting trigger listeners due to satisfied condition with triggered event [" .. event .. "]");
						am:inc_tab();
					end;
					
					self:start_trigger_listeners();
					
					if self:is_debug() then
						am:dec_tab();
						am:out("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
						am:out("");
					end;
				end,
				false
			);
		else
			if self:is_debug() then
				am:out("establishing startup poll");
			end;
			
			bm:watch(
				function()
					return condition();
				end,
				0,
				function()
					if self:is_debug() then
						am:out("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
						am:out(name .. " is starting trigger listeners due to satisfied polling condition");
						am:inc_tab();
					end;
					
					self:start_trigger_listeners();
					
					if self:is_debug() then
						am:dec_tab();
						am:out("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
						am:out("");
					end;
				end,
				name .. "_startup_listeners"
			);
		end;
	end;
	
	if self:is_debug() then
		am:dec_tab();
	end;
end;





--
--	starting trigger listeners
--

function advice_monitor:start_trigger_listeners()
	local name = self.name;

	if not self.is_started then
		script_error(name .. " WARNING: an attempt was made to start trigger listeners but this monitor is not yet started");
		return false;
	end;
	
	if self.is_halted then
		return false;
	end;
	
	if self.trigger_listeners_started then
		script_error(name .. " WARNING: an attempt was made to start trigger listeners but they're already started");
		return false;
	end;
	
	self.trigger_listeners_started = true;
	
	local am = self.am;

	-- halt any startup listeners
	self:stop_startup_listeners();
	
	if self:is_debug() then
		am:inc_tab();
	end;
	
	-- start trigger listeners
	for i = 1, #self.trigger_conditions do
		local condition_record = self.trigger_conditions[i];
		
		local event = condition_record.event;
		local condition = condition_record.condition;
		
		-- if we have an event, then we listen for the event to occur and then test the condition, otherwise we poll the condition constantly
		if is_string(event) then
		
			if self:is_debug() then
				am:out("establishing trigger listener for event [" .. event .. "]");
			end;
		
			core:add_listener(
				name .. "_trigger_listeners",
				event,
				function(context) 
					return am.advice_lock_level == 0 and (condition == true or condition(context))
				end,
				function()
					if self:is_debug() then
						am:out("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						am:out(name .. " is attempting to trigger due to satisfied condition with triggered event [" .. event .. "]");
						am:inc_tab();
					end;
					
					self:attempt_to_trigger();
						
					if self:is_debug() then
						am:dec_tab();
						am:out("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						am:out("");
					end;
				end,
				true
			);
		else
			if self:is_debug() then
				am:out("establishing trigger poll");
			end;
			
			bm:watch(
				function()
					return am.advice_lock_level == 0 and (condition == true or condition());
				end,
				0,
				function()
					if self:is_debug() then
						am:out("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						am:out(name .. " is attempting to trigger due to satisfied polling condition");
						am:inc_tab();
					end;
					
					self:attempt_to_trigger();
						
					if self:is_debug() then
						am:dec_tab();
						am:out("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						am:out("");
					end;
				end,
				name .. "_trigger_listeners"
			);
		end;
	end;
	
	if self:is_debug() then
		am:dec_tab();
	end;
end;





--
--	triggering
--

function advice_monitor:attempt_to_trigger()
	self:stop_trigger_listeners();

	self.am:attempt_to_trigger(self);
end;



function advice_monitor:trigger()
	local am = self.am;

	if self:is_debug() then
		am:out("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
		am:out(self.name .. " is triggering");
		am:inc_tab();
	end;
	
	-- halt other monitors that can't play alongside this one	
	for monitor_name in pairs(self.halt_advice_monitor_on_trigger) do
		local monitor = am:get_advice_monitor(monitor_name);
		if monitor then
			monitor:halt();
		end;
	end;
		
	if self:is_debug() then
		if not self.should_trigger_advice then
			am:out(self.name .. " will call trigger callback in " .. self.delay_before_triggering .. "ms");
		elseif self.infotext then
			am:out(self.name .. " will play advice [" .. self.advice_key .. "] with infotext in " .. self.delay_before_triggering .. "ms");
		else
			am:out(self.name .. " playing advice [" .. self.advice_key .. "] with no infotext in " .. self.delay_before_triggering .. "ms");
		end;
	end;
	
	-- stop any previously-triggered advice with a long delay_before_triggering from appearing
	bm:remove_process("advice_monitor_delay_before_triggering");
	
	bm:callback(
		function()
			if self.should_trigger_advice then
				if self:is_debug() then
					am:out("+++ " .. self.name .. " is now playing advice [" .. self.advice_key .. "] +++");
					am:out("");
				end;
			
				-- stop/clear any previous advice
				bm:stop_advisor_queue(true);
				
				-- play our advice
				bm:queue_advisor(
					self.advice_key, 
					5000, 
					false, 
					function()
						-- clear infotext
						local infotext_manager = get_infotext_manager();
						infotext_manager:clear_infotext();
						
						-- show infotext
						if self.infotext then
							infotext_manager:add_infotext(unpack(self.infotext));
						end;
					end
				);
				
			else
				if self:is_debug() then
					am:out("+++ " .. self.name .. " is now calling trigger callback +++");
					am:out("");
				end;
			end;
			
			-- call trigger callback if we have one
			if self.trigger_callback then
				self.trigger_callback();
			end;
		end,
		self.delay_before_triggering,
		"advice_monitor_delay_before_triggering"
	);
	
	
	if self:is_debug() then
		am:dec_tab();
		am:out("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
	end;
end;









--
--	stopping
--


function advice_monitor:halt(reason)
	if self.is_halted then
		return;
	end;
	
	local am = self.am;

	self.is_halted = true;
	
	am:advice_monitor_is_halting(self);
	
	if self:is_debug() then
		if is_string(reason) then
			am:out(self.name .. " is halting, reason given: " .. reason);
		else
			am:out(self.name .. " is halting");
		end;
	end;
	
	self:stop_startup_listeners();
	self:stop_trigger_listeners();
	self:stop_halt_listeners();

	if self.halt_callback then 
		am:out(self.name .. " is running halt callback function");
		self.halt_callback();
	end

end;


function advice_monitor:stop_startup_listeners()
	bm:remove_process(self.name .. "_startup_listeners");
	core:remove_listener(self.name .. "_startup_listeners");
end;


function advice_monitor:stop_trigger_listeners()
	self.trigger_listeners_started = false;
	
	bm:remove_process(self.name .. "_trigger_listeners");
	core:remove_listener(self.name .. "_trigger_listeners");
end;


function advice_monitor:stop_halt_listeners()
	bm:remove_process(self.name .. "_halt_listeners");
	core:remove_listener(self.name .. "_halt_listeners");
end;