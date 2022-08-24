-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: primary_building_chain_sweep_variables.txt

local variables = {}

variables.campaign_type = cv_campaign_type or "Immortal Empires"
variables.create_saves = cv_create_saves or false

g_test_case_table = {} --dont run any checkpoints or test cases

Lib.Helpers.Init.script_name("WH3 Campaign Progression Test")
Lib.Frontend.Misc.ensure_frontend_loaded()

Lib.Campaign.Actions.setup_test_tables(variables.campaign_type)
Lib.Frontend.Loaders.load_chaos_campaign("Boris Ursus", variables.campaign_type)
Lib.Campaign.Actions.begin_primary_building_sweep(variables.create_saves)

Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()
