----------------------------------------------------------------------------------------------------------------
-- Timers
----------------------------------------------------------------------------------------------------------------
local timers = 
{
	{ "ActionManagerExecuteNext", function() Action_Manager.execute_next() end }
}

----------------------------------------------------------------------------------------------------------------
-- Timer Functions
----------------------------------------------------------------------------------------------------------------
function Timers_Callbacks.timer_trigger(context)
	local label = context.string
	
	-- Check if the label matches any of the timers.
	for i = 1, #timers do
		if (label == timers[i][1]) then
			-- Execute timer function.
			timers[i][2]()
		end
	end
end

function Timers_Callbacks.build_timers_string()
	local str = ""
	
	for i = 1, #timers do
		if (i > 1) then
			str = str .. ", "
		end
		
		str = str .. timers[i][1]
	end
	
	return str
end

----------------------------------------------------------------------------------------------------------------
-- Entry / Exit
----------------------------------------------------------------------------------------------------------------
function Timers_Callbacks.ui_created(context)
	Utilities.print("UI created: " .. context.string .. " -- Timers started: " .. (Timers_Callbacks.build_timers_string()))
	
	-- Start all timers now
	for i = 1, #timers do
		Timers.register_singleshot(timers[i][1], 0, true)
	end

	-- Get the current UI root node.
	ATGlobals.ui_root = UIComponent(context.component)
end

function Timers_Callbacks.ui_destroyed(context)
	Utilities.print("UI destroyed: " .. context.string .. " -- Timers stopped: " .. (Timers_Callbacks.build_timers_string()))
	
	-- Stop all timers.
	for i = 1, #timers do
		Timers.unregister(timers[i][1])
	end
	
	-- Root node is no longer valid.
	ATGlobals.ui_root = nil
end

----------------------------------------------------------------------------------------------------------------
-- Interface to Campaign and Battle game environments
----------------------------------------------------------------------------------------------------------------

-- construct a special environment for autotest-to-game callbacks
local function construct_autotest_environment(game_environment)
	local env = {};
	local mt = {};

	local local_env = getfenv(1);

	-- if a value is read in the 'autotest callback' environment, the 'autotest' environment is checked first, then the 'game' environment
	mt.__index = function(t, k)
		if local_env[k] then
			return local_env[k];
		elseif game_environment[k] then
			return game_environment[k];
		end;		
	end;

	-- if a value is set in the 'autotest callback' environment then just set it in the 'autotest' environment
	mt.__newindex = function(t, k, v)
		rawset(local_env, k, v);
	end;

	setmetatable(env, mt);
	return env;
end;

function Timers_Callbacks.campaign_call(callback)
	
	if _G.campaign_env then

		if not Timers_Callbacks.autotest_campaign_env then
			Timers_Callbacks.autotest_campaign_env = construct_autotest_environment(_G.campaign_env);
		end;

		setfenv(callback, Timers_Callbacks.autotest_campaign_env);
		callback();
		return true;
	end;

	return false;
end;

function Timers_Callbacks.battle_call(callback)

	if _G.battle_env then
		if not Timers_Callbacks.autotest_battle_env then
			Timers_Callbacks.autotest_battle_env = construct_autotest_environment(_G.battle_env);
		end;

		setfenv(callback, Timers_Callbacks.autotest_battle_env);
		callback();
		return true;
	end;

	return false;
end;

function Timers_Callbacks.suppress_intro_movie()
	_G.suppress_intro_movie = true;
end;




----------------------------------------------------------------------------------------------------------------
-- Destruction of campaign and battle environments when 
----------------------------------------------------------------------------------------------------------------

function Timers_Callbacks.campaign_session_ends()
	_G.campaign_env = nil;
	Timers_Callbacks.autotest_campaign_env = nil;
end;

function Timers_Callbacks.battle_session_ends()
	_G.battle_env = nil;
	Timers_Callbacks.autotest_battle_env = nil;
end;

----------------------------------------------------------------------------------------------------------------
-- Callbacks
----------------------------------------------------------------------------------------------------------------

if (ATSettings.Main.autotest_enabled == true) then
	add_event_callback("UICreated",					Timers_Callbacks.ui_created)
	add_event_callback("UIDestroyed", 				Timers_Callbacks.ui_destroyed)
	add_event_callback("RealTimeTrigger", 			Timers_Callbacks.timer_trigger)

	-- delete the campaign env in _G that the game scripts have set up
	add_event_callback("CampaignSessionEnded",		Timers_Callbacks.campaign_session_ends)

	-- delete the battle env in _G that the game scripts have set up
	add_event_callback("BattleSessionEnds", 		Timers_Callbacks.battle_session_ends)

	Utilities.print("Autotesting is enabled.")
else
	Utilities.print("!! Autotesting is disabled !!")
end
