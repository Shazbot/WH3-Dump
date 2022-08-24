-- This script is needed to run the campaign benchmark in the nightly performance tests.

require "data.script.autotest.lib.all"

--## Local Variables ##--
local variables = {}
variables.benchmark = "ie campaign benchmark"

--## Script Start ##--
Lib.Helpers.Init.script_name("Nightly Campaign Benchmark Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Frontend.Loaders.load_benchmark(nil, variables.benchmark)
Lib.Helpers.Misc.exit_benchmark_when_finished(variables.benchmark)
Lib.Frontend.Misc.quit_to_windows()