-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: benchmark_variables.txt

local variables = {}

variables.gfx_preset = cv_gfx_preset or "Default"

variables.benchmark = cv_benchmark or "campaign benchmark" -- don't change this unless approved by Mihai Terhes or Matt Storr as this default value is being used by the nightly performance benchmarks

Lib.Helpers.Init.script_name("Benchmark Preset Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_benchmark(variables.gfx_preset, variables.benchmark)
Lib.Helpers.Misc.exit_benchmark_when_finished(variables.benchmark)
Lib.Frontend.Misc.quit_to_windows()