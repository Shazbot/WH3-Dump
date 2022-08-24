require "script.autotest.lib.all" 

local start_time = os.time()

-- variables_file: custom_battle_loading_times_variables.txt

local variables = {}

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

Lib.Helpers.Timers.create_battle_folder() 
Lib.Helpers.Init.script_name("WH3 Custom Battle Loading Times")

Lib.Frontend.Loaders.load_custom_battle(
        variables.battle_type, variables.map_preset, variables.difficulty, 
        variables.time, variables.funds, variables.tower_level, variables.realism, variables.large_armies, 
        variables.unit_scale, variables.team_1_size, variables.team_2_size)

Lib.Helpers.Timers.write_battle_timers_to_file("Custom Battle Menu into Battle")
Lib.Battle.Misc.concede_battle_after_duration(10)
Lib.Helpers.Timers.write_battle_timers_to_file("End of Battle to Custom Battle Menu") 
Lib.Helpers.Timers.write_battle_details_to_file()

Lib.Frontend.Misc.quit_to_windows()


