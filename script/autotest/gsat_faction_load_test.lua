-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"


-- variables_file: faction_load_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]
g_test_case_table = {}

g_faction_load_test_csv_path = os.getenv("APPDATA").."\\CA_Autotest\\WH3\\faction_load_test"

variables.skip_intro = cv_skip_intro or true
variables.save_load_check = cv_save_load_check or false

variables.lord = cv_lord or "Random"
variables.campaign_type = cv_campaign_type or "The Realm of Chaos"
variables.fight_starting_battle = cv_fight_starting_battle or false
variables.database_checking = cv_database_check or false
variables.race_choice = cv_race or "None"

-- global variables for test
g_technology_unlocked = true

if(variables.skip_intro) then
	Timers_Callbacks.suppress_intro_movie()
end

Lib.Helpers.Init.script_name("WH3 Faction Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Campaign.Misc.create_end_turn_verification_file()

Lib.Helpers.Loops.faction_load_test_loop(variables)

Lib.DAVE_Database.Misc.cleanup_context_lua_table_file()
Lib.Frontend.Misc.quit_to_windows()
