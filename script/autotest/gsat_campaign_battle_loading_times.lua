-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: campaign_battle_loading_times_sweep_variables.txt

local variables = {}
variables.source_folder = cv_source_folder or [[\\casan05\build1\custom_task_data\loading_times\campaign_battle\saves]]
variables.target_folder = cv_target_folder or os.getenv("APPDATA").."\\\"The Creative Assembly\"\\Warhammer3\\save_games"
g_local_file_location = variables.target_folder

local appdata = os.getenv("APPDATA")
g_network_save_path = variables.source_folder
g_campaign_timer_directory = appdata.."\\CA_Autotest\\WH3\\campaign_battle_loading_times"

g_campaign_clock = os.date("campaign_%d%m%y_%H%M")
os.execute("mkdir \""..g_campaign_timer_directory.."\"")

Lib.Helpers.Init.script_name("WH3 Campaign Battle Load Times Sweep")

Lib.Frontend.Load_Campaign.setup_network_save_locations(true) --backs up the current save game folder
Lib.Frontend.Load_Campaign.copy_all_saves_in_network_folder_to_local() --copies the saves from source folder

Lib.Frontend.Misc.ensure_frontend_loaded()

Lib.Frontend.Clicks.campaign_tab()
Lib.Frontend.Load_Campaign.open_save_panel()

Lib.Compat.Misc.load_into_all_quick_saves_for_battle_load_times()

Lib.Frontend.Misc.quit_to_windows()