-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"
local observer_script_path = Lib.Elastic.Misc.get_observer_path()

-- variables_file: quest_battle_variables.txt
local variables = {}

if (Utilities.check_if_nightly_autotest() == true )then
	local file = [[\\casan02\tw\Warhammer\TWWH3\_Automation\active_script_folder\Nightly_GSAT\?.lua]]
	package.path = package.path .. ";" ..file
	require "gsat_variable_database"

	local faction_choice_int = math.random(#nw_quest_battle_sweep_variables["factions"])
	variables.faction_choice = nw_quest_battle_sweep_variables["factions"][faction_choice_int]
	variables.lord_choice = "Random"
	variables.battle_choice = "Full_Sweep"
	local elastic_log_index = string.format("%q", "nightly")
	io.popen('start cmd /c python.exe -u '..observer_script_path.." "..elastic_log_index, 'r')
else
	g_test_case_table = g_test_case_holder["basic_test_cases"]
	variables.faction_choice = cv_faction_choice
	variables.lord_choice = cv_lord_choice
	variables.battle_choice = cv_battle_choice
	io.popen('start cmd /c python.exe -u '..observer_script_path, 'r')
end

g_quest_battle_elastic_table = {}
g_quest_battle_elastic_table.selected_faction = variables.faction_choice

g_failed_to_load_quest_battles = {}
variables.battle_duration = cv_battle_duration or 10

Lib.Helpers.Init.script_name("WH3 Quest Battle Sweep")
Lib.Frontend.Misc.ensure_frontend_loaded()

local build_number, cl_number = Utilities.get_build_number_and_cl_number()
g_quest_battle_elastic_table.build_number = build_number
g_quest_battle_elastic_table.cl_number = cl_number

Lib.Frontend.Loaders.navigate_to_quest_battle()
Lib.Frontend.Loaders.quest_battle_setup(variables.faction_choice, variables.lord_choice)

if (variables.battle_choice == "Full_Sweep") then
	Lib.Frontend.Quest_Battle.load_full_sweep_quest_battles(variables.faction_choice, variables.lord_choice, variables.battle_duration)
elseif (variables.battle_choice == "Random") then
	Lib.Frontend.Quest_Battle.load_random_quest_battle(variables.battle_duration)
else
	Lib.Frontend.Quest_Battle.load_specific_quest_battle(variables.battle_choice ,variables.battle_duration)
end

Lib.Frontend.Misc.quit_to_windows()