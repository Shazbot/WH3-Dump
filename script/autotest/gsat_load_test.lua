ATMain 		= {}
ATGlobals 	= {}

----------------------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------------------
ATGlobals.ui_root = nil		-- UI root node.

----------------------------------------------------------------------------------------------------------------
_G.is_autotest = true  				-- Tell the game that we are in an autorun environment
ATMain.campaign_interface = nil		-- campaign interface
ATMain.battle_manager = nil 		-- battle interface

----------------------------------------------------------------------------------------------------------------
-- Includes
----------------------------------------------------------------------------------------------------------------

-- Required includes.
require "data.script.all_scripted"

-- Local includes.
require "data.script.autotest.common.settings"
require "data.script.autotest.common.utilities"
require "data.script.autotest.common.modules"

-- Script Includes
require "data.script.autotest.scripts.globals_warhammer_campaign"
require "data.script.autotest.scripts.globals_warhammer_battle"
require "data.script.autotest.scripts.warhammer_frontend_functions"
require "data.script.autotest.scripts.warhammer_campaign_functions"

-- Timers and Callbacks
require "data.script.autotest.common.modules.timers_callbacks"

-- Settings
ATModules.ActionManager.set_default_retry_delay(2000)
ATModules.ActionManager.set_default_exit_delay(2000)

----------------------------------------------------------------------------------------------------------------

-- Init
ATModules.Action.print("-------------------------------------------------")
ATModules.Action.print("Game Scripted Autotest (GSAT) - LOAD TEST")
ATModules.Action.print("-------------------------------------------------")
ATModules.ActionManager.register(function() ATModules.Action.print("<<<<< GSAT TEST CASE ENABLED>>>>> Random Campaign Load Test") end)
ATModules.ActionManager.register(function() ATModules.Action.print("<<<<< GSAT TEST CASE ENABLED>>>>> Random Battle Load Test") end)

ATModules.ActionRegistrar.sleep(2000)
ATModules.ActionManager.register(function() verify_front_end("--") end)

-- Campaign using a random tentpole faction
ATModules.ActionManager.register(function() ATModules.Action.print("------------------------------") end)
ATModules.ActionManager.register(function() ATModules.Action.print("TEST CASE 01 - Random Campaign Build Check") end)
ATModules.ActionManager.register(function() ATModules.Action.print("------------------------------") end)
ATModules.ActionManager.register(function() ATModules.Action.print("<< GSAT TEST CASE >> Random Campaign Load Test STARTED") end)
ATModules.ActionManager.register(function() random_main_campaign_loader("01") end)
ATModules.ActionManager.register(function() waiting_for_game_start("01") end)
ATModules.ActionManager.register(function() exit_to_main("01") end)
ATModules.ActionManager.register(function() ATModules.Action.print("<< GSAT TEST CASE >> Random Campaign Load Test COMPLETE") end)

-- Land Battle using a random tentpole faction
ATModules.ActionManager.register(function() ATModules.Action.print("------------------------------") end)
ATModules.ActionManager.register(function() ATModules.Action.print("TEST CASE 02 - Random Battle Build Check") end)
ATModules.ActionManager.register(function() ATModules.Action.print("------------------------------") end)
ATModules.ActionManager.register(function() ATModules.Action.print("<< GSAT TEST CASE >> Random Battle Load Test STARTED") end)
ATModules.ActionManager.register(function() random_custom_battle_loader("02") end)
ATModules.ActionManager.register(function() quit_battle("02") end)
ATModules.ActionManager.register(function() ATModules.Action.print("<< GSAT TEST CASE >> Random Battle Load Test COMPLETE") end)

ATModules.ActionManager.register(function() ATModules.Action.print("GSAT_SCRIPT_FINISHED_") end)
ATModules.ActionManager.register(function() exit_game("02") end)