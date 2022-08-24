-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925


local battle_ui_sweep_results
require "data.script.autotest.lib.all"
local variables = {}

-- variables_file: battle_ui_sweep_variables.txt
g_test_case_table = g_test_case_holder["basic_test_cases"]
variables.campaign_type = cv_campaign_type

Timers_Callbacks.suppress_intro_movie()
Lib.Helpers.Init.script_name("WH3 Battle UI Sweep")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_custom_battle("Land Battle", nil, "Normal", "Unlimited Time", "Default Funds", nil, false, false, "Small", 1, 1, nil, false)
Lib.Helpers.UI_Sweeps.battle_main_ui_sweep()
Lib.Helpers.UI_Sweeps.battle_card_panel_sweep()
Lib.Helpers.UI_Sweeps.battle_speed_control_sweep()
Lib.Helpers.UI_Sweeps.battle_menu_bar_sweep()

callback(function()
	battle_ui_sweep_results = Lib.Helpers.UI_Sweeps.get_sweep_results()
	for _,game_area in pairs(battle_ui_sweep_results) do
		for panel_name, result in pairs(game_area) do
			if (result == "Failed") then
				Utilities.print(panel_name.." = "..result)
			end
		end
	end
end)

Lib.Menu.Misc.concede_battle_return_to_frontend()
Lib.Frontend.Clicks.return_to_main_menu()
Lib.Frontend.Misc.quit_to_windows()