-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: custom_battle_variables.txt

local variables = {}
g_test_case_table = g_test_case_holder["basic_test_cases"]

variables.battle_count = cv_battle_count or 1
variables.battle_duration = cv_battle_duration or 20
variables.battle_type = cv_battle_type
variables.map_preset = cv_map_preset
variables.time = cv_time
variables.funds = cv_funds
variables.tower_level = cv_settlement_level
variables.difficulty = cv_difficulty
variables.realism = cv_realism
variables.large_armies = cv_large_armies
variables.unit_scale = cv_unit_scale
variables.team_1_size = cv_team_1_size
variables.team_2_size = cv_team_2_size


--users can specify a map name or the map number, but both are initially passed in as a string, this converts the number to a number
if(variables.map_preset~= nil and tonumber(variables.map_preset) ~= nil)then
	variables.map_preset = tonumber(variables.map_preset)
end

variables.team_faction_table = {
	{cv_1_1_faction or "Random",
	cv_1_2_faction or "Random",
	cv_1_3_faction or "Random",
	cv_1_4_faction or "Random"},

	{cv_2_1_faction or "Random",
	cv_2_2_faction or "Random",
	cv_2_3_faction or "Random",
	cv_2_4_faction or "Random"}
}

Lib.Helpers.Init.script_name("WH3 Custom Battle Test")
Lib.Frontend.Misc.ensure_frontend_loaded()

for i = 1, variables.battle_count do
	Lib.Frontend.Loaders.load_custom_battle(variables.battle_type, variables.map_preset, variables.difficulty, 
											variables.time, variables.funds, variables.tower_level, variables.realism, 
											variables.large_armies, variables.unit_scale, variables.team_1_size, 
											variables.team_2_size, variables.team_faction_table)
	Lib.Battle.Misc.concede_battle_after_duration(variables.battle_duration)
end

Lib.Frontend.Misc.quit_to_windows()