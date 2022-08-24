-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: vram_budget_variables.txt

local gfx_preset = cv_gfx_preset or "Default"
local benchmark = cv_benchmark or "campaign benchmark"

Lib.Helpers.Init.script_name("VRAM budget sweep")
--setup vram log file (csv)
Lib.Compat.Misc.setup_vram_log_file()
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Compat.Loops.vram_budget_loop()
Lib.Frontend.Misc.quit_to_windows()