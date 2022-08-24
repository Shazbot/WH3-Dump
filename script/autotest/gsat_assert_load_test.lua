-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

g_screenshot_events = false

Common_Actions.trigger_console_command("tweak monitorless_test true;")
Lib.Helpers.Init.script_name("GSAT Assert Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Misc.quit_to_windows_assert_load_test_version()