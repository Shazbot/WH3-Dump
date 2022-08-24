require "data.script.autotest.lib.all"
-- path for the custom variables used by the compat tests
local custom_variables_file = [[C:\compat_sweep\variables.lua]]

--## Global Variables ##--
g_manual_battles = true
g_compat_sweep = true

--## Local Variables ##--
local variables = {}
-- checking if there is a custom variables file. If this exists, it will override all pre-defined variables, even GSAT ones!!!
if Functions.check_file_exists(custom_variables_file) then
    package.path = package.path .. ";" ..custom_variables_file
    require "variables"
    local compat_test_type = core:svr_load_registry_string("compat_test_type")
    if compat_test_type ~= nil then
        variables = custom_variables[compat_test_type.."_end_turn_times_variables"] -- import the variables table specific for that test type
    else
        variables = custom_variables["main_end_turn_times_variables"] -- safeguard in case there is no registry string for the test type
    end
else
    variables.lord = "Tzarina Katarin"
    variables.campaign_type = "The Realm of Chaos"
    variables.max_turns = 200
end

--## Script Start ##--
Lib.Helpers.Init.script_name("WH3 End Turn Times Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
Lib.Campaign.Misc.create_turn_timer_file()
if variables.compat_run then
    Lib.Campaign.Behaviours.set_action_weights(1, 6, 0, 10, "Random", 0, true)
    Lib.Compat.Sweep.log_default_graphic_settings()
    callback(function()
        Lib.Compat.Sweep.log_hardware_info(g_turn_timer_location, g_turn_timer_name)
    end)
    callback(function() g_manual_battles = false end)
    Lib.Frontend.Loaders.load_chaos_campaign(variables.lord, variables.campaign_type)
    Lib.Campaign.Settlements.remove_all_main_settlement_buildings()
    Lib.Compat.Misc.add_kislev_garrison_buildings(variables.campaign_type)
    Lib.Helpers.Loops.end_turn_loop(variables.max_turns)
end
Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()