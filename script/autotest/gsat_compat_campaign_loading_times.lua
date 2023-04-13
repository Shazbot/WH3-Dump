require "script.autotest.lib.all"
-- path for the custom variables used by the compat tests
local custom_variables_file = [[C:\compat_sweep\variables.lua]]

--## Local Variables ##--
-- variables_file: campaign_loading_times_variables.txt
local variables = {}
-- checking if there is a custom variables file. If this exists, it will override all pre-defined variables, even GSAT ones!!!
if Functions.check_file_exists(custom_variables_file) then
    package.path = package.path .. ";" ..custom_variables_file
    require "variables"
    local compat_test_type = core:svr_load_registry_string("compat_test_type")
    if compat_test_type ~= nil and compat_test_type ~= '' then
        variables = custom_variables[compat_test_type.."_campaign_loading_times_variables"] -- import the variables table specific for that test type
    else
        variables = custom_variables["main_campaign_loading_times_variables"] -- safeguard in case there is no registry string for the test type
    end
else
    variables.lord = cv_lord or "Random"
    variables.campaign_type = cv_campaign_type or "The Realm of Chaos"
    variables.fight_starting_battle = cv_fight_starting_battle or true
    variables.compat_run = cv_compat_run or false
    variables.custom_compat_variables = false -- should always be false unless you are using a custom variables file (in that case, the file should have this one included and set to true so no need to change here)
end

--## Global Variables ##--
g_manual_battles = variables.fight_starting_battle


--## Script Start ##--
Lib.Helpers.Init.script_name("WH3 Campaign Loading Times")
Lib.Compat.Misc.find_build_number_and_changelist()
Lib.Helpers.Misc.wait(60) -- loading times tests should always wait 1 min in frontend for async loading to finish
if variables.compat_run then
    Lib.Compat.Loading_Times.campaign_loading_times_loop(variables)
else
    Lib.Helpers.Timers.create_campaign_folder()
    Lib.Campaign.Misc.campaign_loading_times_sweep(variables)
end
Lib.Frontend.Misc.quit_to_windows()