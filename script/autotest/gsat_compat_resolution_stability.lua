-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

--## Local Variables ##--
-- variables_file: resolution_stability_variables.txt

local variables = {}
variables.graphics_preset = cv_graphics_preset or 'Default'
variables.log_csv = cv_log_csv or true
variables.testing_area = cv_testing_area or "All"
variables.campaign_type = cv_campaign_type or "The Realm of Chaos"
variables.display_mode = cv_display_mode or "Both"


--## Script Start ##--
Lib.Helpers.Init.script_name("WH3 Resolution Stability")
Lib.Frontend.Misc.ensure_frontend_loaded()
if variables.log_csv then
    Lib.Compat.Misc.setup_csv_log_file()
end
Lib.Compat.Misc.test_resolution_stability(variables)
Lib.Frontend.Misc.quit_to_windows()
