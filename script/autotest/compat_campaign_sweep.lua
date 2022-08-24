
require "script.autotest.lib.all"

--## Global Variables ##--
g_manual_battles = true
g_compat_sweep = true

--## Local Variables ##--
local variables = {}
variables.campaign_type = "The Realm of Chaos"

--## Script Start ##--
Lib.Helpers.Init.script_name("Compat WH3 Campaign Sweep")
Lib.Compat.Sweep.set_sweep_log_details()
Lib.Compat.Sweep.log_session_stats()
Lib.Compat.Sweep.campaign_sweep(variables.campaign_type)
Lib.Frontend.Misc.quit_to_windows()