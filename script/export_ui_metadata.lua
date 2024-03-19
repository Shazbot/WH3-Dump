require "data.script.autotest.lib.all"

Lib.Helpers.Init.script_name("Export UI Metadata")
Common_Actions.print("Ensure frontend has loaded")
Lib.Frontend.Misc.ensure_frontend_loaded()
Common_Actions.print("Execute export meta data function")
Functions.export_metadata()
Common_Actions.print("End of export_ui_metadata script")