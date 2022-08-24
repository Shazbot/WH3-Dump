require "script.autotest.lib.all"
-- path for the custom variables used by the compat tests
local custom_variables_file = [[C:\compat_sweep\variables.lua]]

--## Local Variables ##--
-- variables_file: replay_loading_times_sweep_variables.txt

local variables = {}
-- checking if there is a custom variables file. If this exists, it will override all pre-defined variables, even GSAT ones!!!
if Functions.check_file_exists(custom_variables_file) then
    package.path = package.path .. ";" ..custom_variables_file
    require "variables"
    variables = custom_variables['replay_loading_times_variables'] -- import the table from the variables files
    variables.target_folder = os.getenv("APPDATA")..variables.target_folder -- the path in the custom variables table doesn't include appdata, so it needs to be added here
else
    variables.source_folder = cv_source_folder or [[\\casan05\build1\custom_task_data\loading_times\custom_battle\replays]]
    variables.target_folder = cv_target_folder or os.getenv("APPDATA")..[[\The Creative Assembly\Warhammer3\replays]]
    variables.compat_run = cv_compat_run or false
    variables.custom_compat_variables = false -- should always be false unless you are using a custom variables file (in that case, the file should have this one included and set to true so no need to change here)
end


--## Script Start ##--
Lib.Helpers.Init.script_name("WH3 Replay Loading Times")
Lib.Compat.Misc.find_build_number_and_changelist()
Lib.Helpers.Misc.wait(60) -- loading times tests should always wait 1 min in frontend for async loading to finish
if (variables.compat_run) then
    Lib.Compat.Loading_Times.replay_loading_times_loop(variables)
else
    Functions.copy_folder_contents_to_another_folder(variables.source_folder, variables.target_folder)
    Lib.Helpers.Timers.create_battle_folder()
    Lib.Frontend.Misc.replays_load_sweep(variables.target_folder)
end
Lib.Frontend.Misc.quit_to_windows()