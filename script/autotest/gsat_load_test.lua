-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

g_screenshot_events = false
local lord = Lib.Frontend.Campaign.get_random_lord()

Lib.Helpers.Init.script_name("CI GSAT Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_chaos_campaign(lord)
Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Loaders.load_custom_battle("Land Battle", nil, "Normal", "Unlimited Time", "Default Funds", nil, false, false, "Small", 1, 1, nil, false)
Lib.Menu.Misc.concede_battle_return_to_frontend()
Lib.Battle.Misc.handle_battle_results()
Lib.Frontend.Misc.quit_to_windows()