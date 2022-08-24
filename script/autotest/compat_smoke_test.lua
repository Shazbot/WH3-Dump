require "script.autotest.lib.all"

--## Global Variables ##--
g_manual_battles = true
g_graphics_presets_test = true

--## Local Variables ##--
local variables = {}
variables.campaign_type = "The Realm of Chaos"
variables.max_turns = 5
-- This table defines which benchmarks the script will run; 
-- Since the actual game has more benchmarks than we normally want to run, we need to define which one we want to run; 
-- Make sure the name of the benchmark is exactly as the one that appears in game.
variables.benchmarks_table = {"battle benchmark", "campaign benchmark", "siege_benchmark"}
variables.benchmark_run_count = 3

--## Script Start ##--
Lib.Helpers.Init.script_name("WH3 Compat Smoke Test")
local win7_testing = Lib.Compat.Misc.check_if_win7()

-- smoke tests for campaign, campaign battle, and custom battle;
-- they also contain checks for changing the graphics preset.
Lib.Compat.Misc.campaign_smoke_test(true, variables.campaign_type, variables.max_turns)
Lib.Compat.Misc.custom_battle_smoke_test()

-- Run each benchmark from the table above several times to get some performance results;
-- only run this on win 7 as win 10 already gets nightly performance results.
if win7_testing == true then
    Lib.Compat.Loops.run_each_benchmark_from_provided_table(variables.benchmarks_table, variables.benchmark_run_count)
end

-- Test changing the graphics options in the frontend
Lib.Frontend.Misc.ensure_frontend_loaded()
if (g_graphics_presets_test == true) then
    Lib.Compat.Downgrading.graphics_presets_stability_test()
    Lib.Frontend.Options.navigate_to_graphics_advanced()
    Lib.Compat.Loops.graphics_setting_stability_sweep()
    Lib.Frontend.Misc.return_to_frontend()
end
Lib.Frontend.Misc.quit_to_windows()
