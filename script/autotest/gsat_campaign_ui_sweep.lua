-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925


local campaign_ui_sweep_results
require "data.script.autotest.lib.all"
local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]

-- variables_file: campaign_ui_sweep_variables.txt

variables.campaign_type = cv_campaign_type

Timers_Callbacks.suppress_intro_movie()
Lib.Helpers.Init.script_name("WH3 Campaign UI Sweep")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_chaos_campaign(nil, cv_campaign_type, false)
Lib.Helpers.UI_Sweeps.skip_cutscenes_close_advisor()
Lib.Helpers.UI_Sweeps.campaign_main_panel_sweep()
Lib.Helpers.UI_Sweeps.campaign_map_tab_sweep()
Lib.Helpers.UI_Sweeps.campaign_menu_bar_sweep()

callback(function()
	campaign_ui_sweep_results = Lib.Helpers.UI_Sweeps.get_sweep_results()
	for _,game_area in pairs(campaign_ui_sweep_results) do
		for panel_name, result in pairs(game_area) do
			Utilities.print(panel_name.." = "..result)
		end
	end
end)

Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()