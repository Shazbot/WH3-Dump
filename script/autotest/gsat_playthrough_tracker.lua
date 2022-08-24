-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: playthrough_tracker_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]
local appdata = os.getenv("APPDATA")

variables.network_save_location = cv_network_save_location
variables.network_logging_path = cv_network_logging_path or appdata.."\\CA_Autotest\\WH3\\playthrough_tracker"

g_network_save_path = variables.network_save_location


g_playthrough_tracker_location = variables.network_logging_path

Lib.Helpers.Init.script_name("WH3 Playthrough Tracker")

if(g_network_save_path)then
    Lib.Frontend.Load_Campaign.setup_network_save_locations(true)
    Lib.Frontend.Load_Campaign.copy_all_saves_in_network_folder_to_local()
end


Lib.Frontend.Misc.ensure_frontend_loaded()

--call the session logging function here
Lib.Frontend.Load_Campaign.open_save_panel()

if(g_network_save_path)then
    Lib.Campaign.Playthrough_Tracker.log_info_from_all_sessions()
else
    Lib.Campaign.Playthrough_Tracker.set_playthrough_tracker_details()
    Lib.Frontend.Load_Campaign.generate_all_session_info(1)
    Lib.Frontend.load_most_recent_save()
    
    Lib.Campaign.Playthrough_Tracker.get_campaign_statistics()
    
    Lib.Menu.Misc.quit_to_frontend()
end


Lib.Frontend.Misc.quit_to_windows()
