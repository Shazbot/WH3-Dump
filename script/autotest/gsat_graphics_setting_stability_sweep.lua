-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: graphics_setting_stability_variables.txt

local variables = {}
variables.benchmark_choice = cv_benchmark or "No Benchmark"
variables.baseline_preset = cv_baseline_preset or "Low"
variables.location = cv_location or nil

Lib.Helpers.Init.script_name("GRAPHICS SETTING STABILITY SWEEP")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Options.navigate_to_graphics_advanced()
Lib.Helpers.Loops.graphics_setting_stability_sweep(variables.benchmark_choice, variables.location)
Lib.Frontend.Misc.quit_to_windows()