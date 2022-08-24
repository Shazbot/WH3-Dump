-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

Lib.Helpers.Init.script_name("Frontend UI Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Helpers.UI_Sweeps.create_ui_verification_file()
Lib.Helpers.UI_Sweeps.frontend_campaigns_sweep()
Lib.Helpers.UI_Sweeps.frontend_battles_sweep()
Lib.Helpers.UI_Sweeps.frontend_options_sweep()
Lib.Frontend.Misc.quit_to_windows()