-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: playthrough_tracker_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]
variables.network_save_location = cv_network_save_location
variables.network_logging_path = cv_network_logging_path

g_network_save_path = variables.network_save_location

local appdata = os.getenv("APPDATA")
g_economy_tracker_location = variables.network_logging_path or appdata.."\\CA_Autotest\\WH3\\economy_tracker"

Lib.Helpers.Init.script_name("WH3 Economy Tracker")

if(g_network_save_path)then
    Lib.Frontend.Load_Campaign.setup_network_save_locations(true)
    Lib.Frontend.Load_Campaign.copy_all_saves_in_network_folder_to_local()
end


Lib.Frontend.Misc.ensure_frontend_loaded()

Lib.Campaign.Playthrough_Tracker.set_economy_tracker_details()

Lib.Frontend.Load_Campaign.gather_economy_data_for_all_saves_in_session()

Lib.Frontend.Misc.quit_to_windows()