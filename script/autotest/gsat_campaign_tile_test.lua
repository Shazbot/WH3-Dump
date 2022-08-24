-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"
g_test_case_table = g_test_case_holder["basic_test_cases"]
-- variables_file: campaign_tile_variables.txt

local lord = cv_lord

if(lord == nil or lord == "Random") then
	lord = Lib.Frontend.Campaign.get_random_lord()
end

local auto_resolve = cv_auto_resolve
local log_terrain = cv_log_terrain
local take_screenshot = cv_take_screenshot
local save_game = cv_save_game

if(auto_resolve == nil) then auto_resolve = false end
if(log_terrain == nil) then log_terrain = true end
if(take_screenshot == nil) then take_screenshot = false end
if(save_game == nil) then save_game = false end

g_save_location = cv_save_location or nil

Timers_Callbacks.suppress_intro_movie()
Lib.Campaign.Misc.toggle_skip_all_but_human(true)

Lib.Helpers.Init.script_name("Campaign Siege Sweep")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_chaos_campaign(lord)
Lib.Campaign.Actions.teleport_to_and_fight_dummy_army_at_coords(auto_resolve, log_terrain, take_screenshot, save_game)
Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()