

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	TIMER MANAGER
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c timer_manager Timer Manager
--- @desc The timer manager object provides library support for calling functions with a time interval i.e. waiting one second before calling a function. It is loaded in all game modes and provides similar but not identical functionality in each.
--- @desc It is rare for game scripts to need direct access to the timer manager. The timer manager is automatically created as the script libraries are loaded, and both the @battle_manager and @campaign_manager provide pass-through functions to the timer manager which game scripts typically use instead of calling the timer manager directly. For the campaign these functions are documented in the @"campaign_manager:Timer Callbacks" section of this documentation, and in battle they are documented here: @"battle_manager:Timer Callbacks".
--- @desc Direct access to the timer manager might be more useful for frontend scripts, but they are rarer in themselves. The core function @core:get_tm can be used to get a handle to the timer manager after it has been created.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------




timer_manager = {};

set_class_custom_type_and_tostring(timer_manager, TYPE_TIMER_MANAGER);

-- Forward declaration
local start_real_timer_listener;


-- Internal function to actually create the timer manager in any game mode
local function create_timer_manager()
	local tm = {};
	set_object_class(tm, timer_manager);

	-- Add a static reference for this object to the core
	core:add_static_object("timer_manager", tm);

	-- Start real timer system
	start_real_timer_listener();

	return tm;
end;










----------------------------------------------------------------------------
--- @section Campaign
--- @desc The campaign construction function @timer_manager:new_campaign is automatically called by the @campaign_manager during the loading sequence (when the <code>WorldCreated</code> model event is received), so there should be no need for client scripts to call it.
--- @desc The mechanics of the underlying campaign model timing system is very different to the equivalent system in battle. As such, the campaign constructor provides versions of @timer_manager:callback, @timer_manager:repeat_callback and @timer_manager:remove_callback which are different from those provided in battle. The usage of the campaign version of these functions is the same as for battle, with the key difference that model time in campaign is expressed in <strong>seconds</strong> in campaign and <strong>milliseconds</strong> in battle. @"timer_manager:Real Timers" use milliseconds in all game modes.
--- @desc During the end-turn sequence the update rate of the campaign model can accelerate wildly. This will cause a function registered to be called after five seconds to happen near-instantly during the end turn sequence, for example. To ameliorate this effect, the timer manager will automatically check the real world time once the interval has completed. If the real world time is less than would be expected then the callback is retried repeatedly until the real world interval has elapsed. This behaviour is only active in singleplayer mode as it would cause desyncs in multiplayer.

----------------------------------------------------------------------------


--- @function new_campaign
--- @desc Creates and returns a timer manager in campaign. This function should be supplied a <code>game_interface</code>, which requires that it is created when the <code>NewSession</code> script event is received (or later). The timer manager is automatically created by the @campaign_manager so there should be no need for game scripts to call this function.
--- @p game_interface game interface
--- @r @timer_manager timer manager
function timer_manager:new_campaign(cm)

	-- If we're not in the right game mode then return
	if not core:is_campaign() then
		script_error("ERROR: timer_manager:new_campaign() called but script is not running in campaign");
		return false;
	end;

	-- If the timer manager has already been created then just return that
	if core:get_static_object("timer_manager") then
		return core:get_static_object("timer_manager");
	end;
	
	-- Create the timer manager with shared functionality
	local tm = create_timer_manager();

	--
	--
	-- Campaign-specific model timer system
	local campaign_model_timers = {};

	local game_interface = cm:get_game_interface();

	-- forward declaration of check timers function
	local check_timers;

	if cm:is_multiplayer() then
		
		-- Multiplayer version of check_timers does not check os clock
		function check_timers(id)
			if id then
				local timer_entry = campaign_model_timers[id];
				if timer_entry then
					if not timer_entry.is_repeating then
						campaign_model_timers[id] = nil;
					end;

					timer_entry.callback();
				end;
			end;
		end;

	else
		
		-- Singleplayer version of check_timers verifies that enough time has elapsed according to the os clock before calling a callback
		function check_timers(id)
			if id then
				local timer_entry = campaign_model_timers[id];
				if timer_entry then
					if not timer_entry.is_repeating then
						-- If the os clock tells us that we haven't yet reached the time the callback should be called at then try again after a short interval
						local os_clock = os.clock();
						if timer_entry.callback_time > os.clock() then
							game_interface:add_time_trigger(id, 0.1, false);
							return;
						end;

						campaign_model_timers[id] = nil;
					end;

					timer_entry.callback();
				end;
			end;
		end;

	end;


	--
	-- Listener for campaign model timer events
	core:add_listener(
		"campaign_model_timer_system",
		"CampaignTimeTrigger", 
		true,
		function(context) 
			local id = tonumber(context.string);
			if id then
				check_timers(id);
			end;
		end, 
		true
	);

	--
	-- Shared callback creator, used by callback() and repeat_callback()
	local function impl_callback(callback, interval, name, is_repeating)
		is_repeating = not not is_repeating
		
		-- generate unique id for this call
		local id = 1;
		while campaign_model_timers[id] do
			id = id + 1;
		end;
		
		local timer_record = {
			callback = callback,
			name = name,
			--[[callstack = debug.traceback(),]] 
			is_repeating = is_repeating
		};

		-- If this is a singleshot timer, then record the estimated time that it should complete as we will check it when the timer is called. Subtract 90ms for a small amount of leeway.
		if not is_repeating then
			local os_clock = os.clock();
			local callback_time = os_clock + interval - 0.09;
			timer_record.callback_time = callback_time
		end;
				
		campaign_model_timers[id] = timer_record;

		game_interface:add_time_trigger(tostring(id), interval, not not is_repeating);
	end;


	--
	-- Campaign implementation of callback()
	function timer_manager:callback(callback, interval, name)
		if not validate.is_function(callback) or not validate.is_number(interval) or (name and not validate.is_string(name)) then
			return false;
		end;

		if interval <= 0 then
			callback();
		else
			impl_callback(callback, interval, name, false);
		end;
	end;


	--
	-- Campaign implementation of repeat_callback()
	function timer_manager:repeat_callback(callback, interval, name)
		if not validate.is_function(callback) or not validate.is_positive_number(interval) or (name and not validate.is_string(name)) then
			return false;
		end;

		impl_callback(callback, interval, name, true);
	end;


	--
	-- Campaign implementation of remove_callback()
	function timer_manager:remove_callback(name)
		if not validate.is_string(name) then
			return false;
		end;

		for id, timer_entry in pairs(campaign_model_timers) do
			if timer_entry.name == name then
				game_interface:remove_time_trigger(id);
				campaign_model_timers[id] = nil;
			end;
		end;
	end;


	return tm;
end;










----------------------------------------------------------------------------
--- @section Battle
--- @desc The battle-specific constructor @timer_manager:new_battle is automatically called by the @battle_manager when it is created, so there should be no need for client scripts to call it.
--- @desc The mechanics of the underlying battle model timing system is very different to the equivalent system in campaign. Therefore, the battle constructor provides versions of @timer_manager:callback, @timer_manager:repeat_callback and @timer_manager:remove_callback which are different from those provided in campaign. The usage of these functions is the same in battle and campaign, with the key difference that model time in campaign is expressed in <strong>seconds</strong> in campaign and <strong>milliseconds</strong> in battle. @"timer_manager:Real Timers" use milliseconds in all game modes.
----------------------------------------------------------------------------


--- @function new_battle
--- @desc Creates and returns a timer manager in battle. This function should be supplied a @battle game object. The timer manager is automatically created by the @battle_manager so there should be no need for game scripts to call this function.
--- @p @battle battle interface
--- @r @timer_manager timer manager
function timer_manager:new_battle(battle)

	-- If we're not in the right game mode then return
	if not core:is_battle() then
		script_error("ERROR: timer_manager:new_battle() called but script is not running in battle");
		return false;
	end;

	-- If the timer manager has already been created then just return that
	if core:get_static_object("timer_manager") then
		return core:get_static_object("timer_manager");
	end;
	
	-- Create the timer manager with shared functionality
	local tm = create_timer_manager();

	--
	--
	-- Battle-specific model timer system
	local battle_model_timers = {};

	--
	-- timer_manager_battle_callback is a global function that the battle model calls when a timer finishes its interval
	function timer_manager_battle_callback()

		local time_elapsed_ms = battle:time_elapsed_ms();

		while #battle_model_timers > 0 do
			-- Get the timer at the start of the model timers list, which will be chronologically the next timer to trigger
			local next_timer = battle_model_timers[1];

			if next_timer.callback_time <= time_elapsed_ms then
				local callback = next_timer.callback;
				table.remove(battle_model_timers, 1);
				callback();
			else
				break;
			end;
		end;

		battle:unregister_timer("timer_manager_battle_callback");
		if #battle_model_timers > 0 then
			battle:register_singleshot_timer("timer_manager_battle_callback", battle_model_timers[1].callback_time - time_elapsed_ms);
		end;
	end;


	--
	-- Battle implementation of callback()
	function timer_manager:callback(callback, interval, name)
		if not validate.is_function(callback) or not validate.is_non_negative_number(interval) or (name and not validate.is_string(name)) then
			return false;
		end;

		local callback_time = battle:time_elapsed_ms() + interval;
		
		local timer_record = {
			callback = callback,
			callback_time = callback_time,
			name = name
		};

		if #battle_model_timers == 0 then
			-- If callback list is empty then the underlying timing mechanism will need to be started
			battle_model_timers[1] = timer_record;

			battle:unregister_timer("timer_manager_battle_callback");
			battle:register_singleshot_timer("timer_manager_battle_callback", interval);

			return;
		else
			-- Walk through the model timers list in chronological order and insert this callback record in place
			for i = 1, #battle_model_timers do
				if battle_model_timers[i].callback_time > callback_time then
					table.insert(battle_model_timers, i, timer_record);

					-- If the record got inserted at the start of the list (i.e. chronologically it will happen first,
					-- of all callbacks), then unregister/re-register the underlying timer to point to it
					if i == 1 then
						battle:unregister_timer("timer_manager_battle_callback");
						battle:register_singleshot_timer("timer_manager_battle_callback", interval);
					end;

					return;
				end;
			end;
		end;

		-- timer_record was not inserted, so it must be chronologically later than all the existing timers - it should go at the end
		table.insert(battle_model_timers, timer_record);
	end;


	--
	-- Battle implementation of repeat_callback()
	function timer_manager:repeat_callback(callback, interval, name)
		if not validate.is_function(callback) or not validate.is_positive_number(interval) or (name and not validate.is_string(name)) then
			return false;
		end;

		self:callback(
			function() 
				self:repeat_callback(callback, interval, name);
				callback();
			end,
			interval,
			name
		);
	end;


	--
	-- Battle implementation of remove_callback()
	function timer_manager:remove_callback(name)
		if not validate.is_string(name) then
			return false;
		end;

		local new_battle_model_timers = {};
		local restart_timers = false;

		for i = 1, #battle_model_timers do
			if battle_model_timers[i].name == name then
				if i == 1 then
					-- The first timer in the list, which is chronologically next, is being removed, so we will need to restart the timer mechanism
					restart_timers = true;
				end;
			else
				table.insert(new_battle_model_timers, battle_model_timers[i]);
			end;
		end;

		battle_model_timers = new_battle_model_timers;
	end;


	return tm;
end;










----------------------------------------------------------------------------
--- @section Frontend
--- @desc The frontend-specific constructor @timer_manager:new_frontend is automatically called in <code>lib_header.lua</code> as it's loaded, so there should be no need for client scripts to call it.
--- @desc There is no game model to provide timer functionality in the frontend, so only the real timer is available. The frontend-specific constructor creates @timer_manager:callback, @timer_manager:repeat_callback and @timer_manager:remove_callback functions but these remap to @timer_manager:real_callback, @timer_manager:repeat_real_callback and @timer_manager:remove_callback respectively.
----------------------------------------------------------------------------


--- @function new_frontend
--- @desc Creates and returns a timer manager in frontend.
--- @r @timer_manager timer manager
function timer_manager:new_frontend()

	-- If we're not in the right game mode then return
	if not core:is_frontend() then
		script_error("ERROR: timer_manager:new_frontend() called but script is not running in frontend");
		return false;
	end;

	-- If the timer manager has already been created then just return that
	if core:get_static_object("timer_manager") then
		return core:get_static_object("timer_manager");
	end;

	-- Create the timer manager with shared functionality
	local tm = create_timer_manager();


	--
	-- In frontend, we repoint model callbacks to use the real timer as we have no model
	timer_manager.callback = timer_manager.real_callback;
	timer_manager.repeat_callback = timer_manager.repeat_real_callback;
	timer_manager.remove_callback = timer_manager.remove_real_callback;


	core.tm = tm;

	return tm;
end;










----------------------------------------------------------------------------
--- @section Model Timers
--- @desc Model timers are synchronised to the game model in campaign and battle. They are the main timers used by game scripts. Both the campaign manager and battle manager provide pass-through interfaces to the functionality documented here - see @"campaign_manager:Timer Callbacks" (campaign) and @"battle_manager:Timer Callbacks" (battle). It is intended that game scripts call these pass-through functions rather than the timer manager itself.
--- @desc When a callback is created with an interval of one second, then the callback function would be called as part of a model update where at least one second of model time has elapsed. This means:<ul>
--- @desc <li>Model timers are confined to the resolution of the game model update, which is currently between 100ms and 200ms. A model timer callback with an interval of 250ms, for example, would not be called until the following model tick, at 300-400ms after the callback was created.</li>
--- @desc <li>Model updates will speed up and slow down in battle if the player changes their battle speed, and also speed up a lot during the end turn sequence in battle. Model updates are also stopped when the game is paused. For these reasons a model timer callback of one second cannot be relied on to trigger after one second has passed in the real world. See @"timer_manager:Real Timers" for callback functions linked to a timer synchronised to real time.</li>
--- @desc <li>As model updates are synchronised between all clients in a multiplayer game, so too are model timers.</li>
--- @desc <li>There is no game model present in the frontend, so only real timers are available. The functions @timer_manager:callback, @timer_manager:repeat_callback and @timer_manager:remove_callback are available in the frontend but will redirect to the real timer equivalents.</li></ul>
--- @desc It is <strong>strongly recommended</strong> that game scripts rely on model timers as their primary mode of script timing, and only use real timers in certain specific situations, usually to do with UI manipulation.
----------------------------------------------------------------------------


-- NB: implementations of the functions in this section are provided within the various game mode constructors - new_campaign, new_battle and new_frontend - as each game mode implements model timers very differently.


--- @function callback
--- @desc Adds a model callback to be called after the supplied interval has elapsed.
--- @p @function callback, Callback to call.
--- @p @number interval, Interval after which to call the callback. This should be in milliseconds in battle and in the frontend, and in seconds in campaign.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @timer_manager:remove_callback. If omitted the callback may not be cancelled.



--- @function repeat_callback
--- @desc Adds a repeating model callback to be called each time the supplied interval elapses.
--- @p @function callback, Callback to call.
--- @p @number interval, Interval after which to call the callback. This should be in milliseconds in battle and in the frontend, and in seconds in campaign.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @timer_manager:remove_callback. If omitted the repeating callback may not be cancelled.


--- @function remove_callback
--- @desc Removes a real callback previously added with @timer_manager:callback or @timer_manager:repeat_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @p @string name, Name of callback to remove.










----------------------------------------------------------------------------
--- @section Real Timers
--- @desc Real timers are synchronised to user-interface updates rather than game model updates, like @"timer_manager:Model Timers". In practice, this means:<ul>
--- @desc <li>Real timers continue to tick and will call their callback even if model updates are paused (e.g. the game is paused in battle).</li>
--- @desc <li>Real timers do not change speed with the model (in battle, and also in campaign during the end-turn sequence).</li>
--- @desc <li>Real timers can have a resolution greater than a model tick (100-200ms).</li>
--- @desc <li>Real timers have a variable resolution - as the frame rate changes, so does the frequency with which real timers get checked.</li>
--- @desc <li>Real timers work in the frontend where no game model is present.</li>
--- @desc <li>Synchronicity between different clients in a multiplayer game cannot be guaranteed (and is highly unlikely to be achieved).</li>
--- @desc <li>Due to the lack of synchronisation between the real timer and the model, the latter may not be in a suitable state to be queried when a real timer is called.</li></ul>
--- @desc It is <strong>strongly recommended</strong> that game scripts rely on model timers as their primary mode of script timing, and only use real timers in certain specific situations, usually to do with UI manipulation.
----------------------------------------------------------------------------

local real_timers = {};

-- This function is local, it was forward-declared at the top of this file
function start_real_timer_listener()
	core:add_listener(
		"real_timer_listener",
		"RealTimeTrigger",
		true,
		function(context)
			local id = tonumber(context.string);
			if id then
				local timer_entry = real_timers[id];
				if timer_entry then
					if not timer_entry.is_repeating then
						real_timers[id] = nil;
					end;

					timer_entry.callback();
				end;
			end;
		end,
		true
	);	
end;


-- Local implementation of adding real callbacks
local function real_callback_impl(callback, interval, name, is_repeating)		
	-- generate unique id for this call
	local id = 1;
	while real_timers[id] do
		id = id + 1;
	end;
	
	local timer_record = {
		callback = callback,
		name = name,
		is_repeating = is_repeating
	};
			
	real_timers[id] = timer_record;
	
	if is_repeating then
		real_timer.register_repeating(tostring(id), interval);
	else
		real_timer.register_singleshot(tostring(id), interval);
	end;
end;


--- @function real_callback
--- @desc Adds a real callback to be called after the supplied interval has elapsed.
--- @p @function callback, Callback to call.
--- @p @number interval, Interval after which to call the callback. This should be in milliseconds, regardless of game mode.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @timer_manager:remove_real_callback. If omitted the callback may not be cancelled.
function timer_manager:real_callback(callback, interval, name)
	if not validate.is_function(callback) or not validate.is_number(interval) or (name and not validate.is_string(name)) then
		return false;
	end;

	if interval <= 0 then
		callback();
	else
		real_callback_impl(callback, interval, name, false);
	end;
end;


--- @function repeat_real_callback
--- @desc Adds a repeating real callback to be called each time the supplied interval elapses.
--- @p @function callback, Callback to call.
--- @p @number interval, Repeating interval after which to call the callback. This should be in milliseconds, regardless of game mode.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @timer_manager:remove_real_callback. If omitted the repeating callback may not be cancelled.
function timer_manager:repeat_real_callback(callback, interval, name)
	if not validate.is_function(callback) or not validate.is_positive_number(interval) then
		return false;
	end;

	real_callback_impl(callback, interval, name, true);
end;


--- @function remove_real_callback
--- @desc Removes a real callback previously added with @timer_manager:real_callback or @timer_manager:repeat_real_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @p @string name, Name of callback to remove.
function timer_manager:remove_real_callback(name)
	if not validate.is_string(name) then
		return false;
	end;

	for id, timer_entry in pairs(real_timers) do
		if timer_entry.name == name then
			real_timer.unregister(id);
			real_timer[id] = nil;
		end;
	end;
end;

