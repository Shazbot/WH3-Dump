-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: chaos_load_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]

variables.lord = cv_lord or "Random"

variables.skip_intro = cv_skip_intro or true
variables.fight_starting_battle = cv_fight_starting_battle or false
variables.enter_astral_plane = cv_enter_astral_plane or false
variables.save_load_check = cv_save_load_check or false

if(variables.skip_intro) then
	Timers_Callbacks.suppress_intro_movie()
end

Lib.Helpers.Init.script_name("WH3 Chaos Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Campaign.Misc.create_end_turn_verification_file()
Lib.Frontend.Loaders.load_chaos_campaign(variables.lord)

if(variables.fight_starting_battle) then
	Lib.Campaign.Actions.attack_nearest_target()
end

Lib.Helpers.Loops.end_turn_loop(3)

if(variables.save_load_check) then
	Lib.Menu.Misc.save_campaign()
	Lib.Menu.Misc.load_campaign()
end

if(variables.enter_astral_plane ~= false) then
	Lib.Campaign.Misc.enter_astral_plane(variables.enter_astral_plane)
end

Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()