
require "script.autotest.lib.all"

--## Global Variables ##--
g_manual_battles = false
g_compat_sweep = true

--## Script Start ##--
Lib.Helpers.Init.script_name("Compat WH3 Custom Battle Sweep")
Lib.Compat.Sweep.set_sweep_log_details()
Lib.Compat.Sweep.log_default_graphic_settings()
Lib.Compat.Sweep.custom_battle_sweep()
Lib.Frontend.Misc.quit_to_windows()