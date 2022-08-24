require "script.autotest.lib.all"

Lib.Helpers.Init.script_name("WH3 Graphics Downgrading")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Compat.Downgrading.default_downgrading_checks()
Lib.Frontend.Options.navigate_to_graphics_advanced()
Lib.Compat.Downgrading.set_advanced_settings()
Lib.Compat.Downgrading.ultra_downgrading_checks()
Lib.Frontend.Misc.quit_to_windows()
