-- Which parts of the test will be executed?
local autotest_states = {
	campaign	= true,
	battle		= true
}

-- Current state of the autorun process.
--   0: Startup
--   1: Running campaign
--   2: Running battle
--   3: Finished
local autotest_cur_state = 0


--[[
Import all the lua scripts
--]]
-- Set up the "include" paths
-- This section is needed
package.path = ";?.lua;data/ui/templates/?.lua;data/ui/?.lua"
require "data.script.all_scripted"
local core = require "CoreUtils"

local ui_root = nil
local current_panel = nil

-- You can retrieve 2 bits of information from a context, a string (which is context dependant)
-- or a component

-- context: string = id of ui
--          component = root component of ui
function onUICreated(context)
    print("UI Created", context.string)
	ui_root = UIComponent(context.component)

    if context.string == "FrontEnd UI" then
		local new_state = false;
		
		while (new_state == false) do
			autotest_cur_state = autotest_cur_state + 1
			
			-- Campaign state
			if (autotest_cur_state == 1 and autotest_states.campaign == true) then
				Timers.register_singleshot("TryCampaign", 1000)
				print("Started 'TryCampaign' timer from UICreated event")
				new_state = true
				
			-- Battle state
			elseif (autotest_cur_state == 2 and autotest_states.battle == true) then
				Timers.register_singleshot("TryBattle", 1000)
				print("Started 'TryBattle' timer from UICreated event")
				new_state = true
			
			-- Exit state
			elseif (autotest_cur_state >= 3) then
				Timers.register_singleshot("TryQuit", 1000)
				print("Started 'TryQuit' timer from UICreated event")
				new_state = true
			end
		end
       
    elseif context.string == "Campaign UI" then
        Timers.register_singleshot("TryCampaign_Menu", 1000)
		print("Started 'TryCampaign_Menu' timer from UICreated event")
    end
	
    print("Autorun state:", autotest_cur_state)
end

function TryClick(button_name, label, timer, next_label, next_timer)
	local button_comp	= UIComponent(ui_root:Find(button_name))	-- Find the button component.
	local done_opacity	= button_comp:SetOpacity(255, true)			-- Button clicks require the component to be visible.
	local done_click 	= button_comp:SimulateLClick()				-- Try to click it.
	
	if (done_opacity and done_click) then
		if (next_label ~= nil) then
			Timers.register_singleshot(next_label, next_timer)
		end
		print("UI button event: "..label.." OK.")
	else
		Timers.register_singleshot(label, timer)
		print("UI button event: "..label.." failed.")
	end
end

function TryKey(key_name, next_label, next_timer)
	print("Keypress: "..key_name)

	ui_root:SimulateKey(key_name)
	
	if (next_label ~= nil) then
		Timers.register_singleshot(next_label, next_timer)
	end
end

-- context: string = name of the timer passed in to Timers.register_xxx
function onTimerTrigger(context)
	local label = context.string
    print("Timer trigger: "..label)

	-- Campaign
	--------------------------------
    if (label == "TryCampaign") then
		TryClick("button_header_campaigns",	label, 1000,	"TryCampaign_Header",				1000)	-- Click the campaigns header.
	elseif (label == "TryCampaign_Header") then
		TryClick("button_new_campaign",		label, 1000,	"TryCampaign_New", nil)						-- Click "New campaign".
	elseif (label == "TryCampaign_New") then
		TryClick("button_start_campaign",	label, 1000,	nil, nil)									-- Click "Start campaign".
	elseif (label == "TryCampaign_Menu") then
		ui_root:InterfaceFunction("QuitForScript")														-- We're now in-game. Exit to menu.
		print("---------------------------------------------\n--- Finished testing Campaign\n---------------------------------------------")

	-- Battle
	--------------------------------
	elseif (label == "TryBattle") then
		TryClick("button_historical_battle",label, 1000,	"TryBattle_HistoricalBattle",		1000)	-- Click "Historical battle".
	elseif (label == "TryBattle_HistoricalBattle") then
		TryClick("wh_test_empire_vs_orcs",	label, 1000,	"TryBattle_Start",					1000)	-- Click "Teutoburg Forest".
	elseif (label == "TryBattle_Start") then
		TryClick("button_start",			label, 1000,	nil, nil)									-- Click "Start battle".
	elseif (label == "TryBattle_StartBattle") then
		TryClick("button_battle_start",		label, 2000,	"TryBattle_Quit",					10000)	-- Click "Start battle" again, after it has been loaded.
	elseif (label == "TryBattle_Quit") then
		ui_root:InterfaceFunction("QuitForScript")														-- We're now in-game. Exit to menu.
	elseif (label == "TryBattle_DismissResults") then
		TryClick("button_dismiss_results",	label, 1000,	nil, nil)									-- At this point, the results panel should be open. Click 'end battle'.
		print("---------------------------------------------\n--- Finished testing Battle\n---------------------------------------------")
		
	-- Quit
	--------------------------------
	elseif (label == "TryQuit") then
		TryClick("button_quit", 			label, 1000,	"TryQuit_Tick",						1000)	-- Click "Quit".
	elseif (label == "TryQuit_Tick") then
		TryClick("button_tick",				label, nil, nil)											-- Click the tick to confirm quit.
	end
end

-- context: string = name of panel
function onPanelOpened(context)    
    local panel = context.string
    print("Panel opened: "..panel)

	current_panel = UIComponent(context.component)
  
	-- Campaign
	--------------------------------
    if (panel == "esc_menu_campaign") then								-- Campaign menu opened.
        Timers.register_singleshot("TryCampaign_ReturnToMenu", 1000)
		print("Started 'TryCampaign_ReturnToMenu' timer from panel event")
		
	-- Battle
	--------------------------------
	elseif (panel == "finish_deployment") then							-- Battle loaded.
		Timers.register_singleshot("TryBattle_StartBattle", 1000)
		print("Started 'TryBattle_StartBattle' timer from panel event")
	
	elseif (panel == "in_battle_results_popup") then					-- Battle results menu.
		Timers.register_singleshot("TryBattle_DismissResults", 1000)
		print("Started 'TryBattle_DismissResults' timer from panel event")
		
    end
end

-- For a list of what events you can add callbacks to see events.lua
AddEventCallBack("UICreated", onUICreated)
AddEventCallBack("PanelOpenedBattle", onPanelOpened)
AddEventCallBack("PanelOpenedCampaign", onPanelOpened)
AddEventCallBack("RealTimeTrigger", onTimerTrigger)
