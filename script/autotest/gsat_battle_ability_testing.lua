-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: battle_ability_testing_variables.txt
g_test_case_table = g_test_case_holder["basic_test_cases"]
local variables = {}
variables.player_faction = cv_player_faction or "Random"

Lib.Helpers.Init.script_name("WH3 BEDSAT")
Lib.Frontend.Misc.ensure_frontend_loaded()

Lib.Frontend.Custom_Battle.setup_and_start_bedsat_battles(variables.player_faction)

Lib.Frontend.Misc.quit_to_windows()