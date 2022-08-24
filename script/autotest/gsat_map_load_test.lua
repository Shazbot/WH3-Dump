-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: map_load_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]

--faction = faction or Lib.Frontend.Campaign.get_random_faction()

variables.map_type = cv_map_type or "All"

variables.starting_land_map = cv_starting_land_map or 1
variables.starting_siege_map = cv_starting_siege_map or 1
variables.starting_ambush_map = cv_starting_ambush_map or 1
variables.starting_chokepoint_map = cv_starting_chokepoint_map or 1
variables.starting_settlement_map = cv_starting_settlement_map or 1
variables.starting_subterranean_map = cv_starting_subterranean_map or 1
variables.starting_survival_map = cv_starting_survival_map or 1
variables.starting_domination_map = cv_starting_domination_map or 1
variables.starting_overthrow_map = cv_starting_overthrow_map or 1

variables.wh3_maps_only = cv_wh3_maps_only or false
variables.set_dressed_only = cv_set_dressed_only or false
variables.log_names = cv_log_names or false

g_starting_maps = {}
g_starting_maps[1] = {"Land Battle", variables.starting_land_map}
g_starting_maps[2] = {"Siege Battle", variables.starting_siege_map}
g_starting_maps[3] = {"Ambush Battle", variables.starting_ambush_map}
g_starting_maps[4] = {"Chokepoint Battle", variables.starting_chokepoint_map}
g_starting_maps[5] = {"Minor Settlement Battle", variables.starting_settlement_map}
g_starting_maps[6] = {"Subterranean Battle", variables.starting_subterranean_map}
g_starting_maps[7] = {"Survival Battle", variables.starting_survival_map}
g_starting_maps[8] = {"Domination", variables.starting_domination_map}
g_starting_maps[9] = {"Overthrow", variables.starting_overthrow_map}

g_log_map_names_to_text_file = variables.log_names

Lib.Helpers.Init.script_name("WH3 Chaos Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Helpers.Loops.map_load_test_loop(variables.map_type, variables.wh3_maps_only, variables.set_dressed_only)
Lib.Frontend.Misc.quit_to_windows()