-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

local variables = {}
g_test_case_table = {}
g_simple_clicks = true
Lib.Helpers.Init.script_name("WH3 Save Loaderator")

Lib.Frontend.Misc.ensure_frontend_loaded()

Lib.Frontend.load_most_recent_save()
Lib.Menu.Misc.quit_to_frontend()

Lib.Frontend.Misc.quit_to_windows()
