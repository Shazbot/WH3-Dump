--buildings needed to ensure Kislev survives until End Times and beyond!!!
local fortress_kislev_buildings = {"wh3_main_ksl_city_town_watch_5", "wh3_main_ksl_city_walls_4", "wh3_main_ksl_city_temple_4", "wh3_main_special_ksl_kislev_1_3", "wh3_main_special_ksl_kislev_2_4", "wh3_main_ksl_city_gold_5", "wh3_main_ksl_city_recruit_growth_xp_5", "wh3_main_ksl_artillery_2", "wh3_main_ksl_ice_guard_2"}

--##### smoke test functions #####--

function Lib.Compat.Misc.campaign_smoke_test(fight_starting_battle, campaign_type, max_turns, campaign_battle_duration)
    callback(function()
        campaign_battle_duration = campaign_battle_duration or 10
        Lib.Campaign.Behaviours.set_action_weights()
        Lib.Frontend.Loaders.load_chaos_campaign(nil, campaign_type)
        if (fight_starting_battle) then
            Lib.Campaign.Actions.attack_nearest_target(campaign_battle_duration)
        end
        callback(function()
            g_manual_battles = false
        end)
        if (g_graphics_presets_test == true) then
            Lib.Compat.Downgrading.graphics_presets_stability_test()
        end
        Lib.Helpers.Loops.end_turn_loop(max_turns)
        Lib.Menu.Misc.quit_to_frontend()
    end)
end

function Lib.Compat.Misc.custom_battle_smoke_test(battle_duration)
    callback(function()
        battle_duration = battle_duration or 30
        Lib.Frontend.Misc.ensure_frontend_loaded()
        Lib.Frontend.Loaders.load_custom_battle()
        if (g_graphics_presets_test == true) then
            Lib.Compat.Downgrading.graphics_presets_stability_test()
        end
        Lib.Battle.Misc.concede_battle_after_duration(battle_duration)
        Lib.Frontend.Misc.return_to_frontend()
    end)
end

--##### VRAM logging functions #####--

local m_vram_log_line = ""

--logs the current VRAM usage to the logging file
function Lib.Compat.Misc.log_vram()
    callback(function()
        local vram = common.get_context_value("VramUsage")
        Utilities.print("Logging VRAM: "..tostring(vram))
        Lib.Compat.Misc.add_string_to_log_line(tostring(vram))
    end)
end

--setup the vram log file and add the dynamically(ish) generated header line
function Lib.Compat.Misc.setup_vram_log_file()
    local appdata = os.getenv("APPDATA")
    g_vram_log_location = appdata.."\\CA_Autotest\\WH3\\vram_logs"
    Utilities.print("LOGS! "..g_vram_log_location)
    g_vram_log_name = os.date("vram_log_%d%m%y_%H%M")

    os.execute("mkdir \""..g_vram_log_location.."\"")
    --create the header line by looping through the benchmark table and using the names as headers.
    --ensures the headers always match the order and amount of benchmarks should they ever change
    local header_line = "Preset"
    local benchmarks_table = Lib.Compat.Loops.get_vram_benchmark_table()
    for _,v in ipairs(benchmarks_table) do
        header_line = header_line..","..v.." VRAM"
    end
    header_line = header_line..",Frontend VRAM"

    Functions.write_to_document(header_line, g_vram_log_location, g_vram_log_name, ".csv", false, true)
end

--add the string to the current logline (so that all vram recordings for this preset are logged)
function Lib.Compat.Misc.add_string_to_log_line(string_to_add)
    callback(function()
        Utilities.print("Adding: "..tostring(string_to_add).." to vram log-line: "..tostring(m_vram_log_line))
        if(m_vram_log_line == "")then
            m_vram_log_line = string_to_add
        else
            m_vram_log_line = m_vram_log_line..","..string_to_add
        end
    end)
end

--write the contents of m_vram_log_line to the vram log file as a new line
function Lib.Compat.Misc.log_vram_line_to_file()
    callback(function()
        if(m_vram_log_line ~= "")then
            Functions.write_to_document(m_vram_log_line, g_vram_log_location, g_vram_log_name, ".csv", false, true)
            m_vram_log_line = ""
        else
            Utilities.print("Vram logline is empty, not logging!")
        end
    end)
end

--##### campaign progression functions #####--

function Lib.Compat.Misc.add_kislev_garrison_buildings(campaign_type)
    callback(function()
        local test_cases = {}
        test_cases["The Realm of Chaos"] = "wh3_main_chaos_region_kislev"
        test_cases["Immortal Empires"] = "wh3_main_combi_region_kislev"
        local player_main_settlement_interface = Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
        local main_slot = player_main_settlement_interface:primary_slot()
        --upgrade the main settlement building in Kislev, using 3 to 5 as it starts at 2 by default
        for i = 3, 5 do
            cm:add_development_points_to_region(test_cases[campaign_type], 5)
            cm:instantly_upgrade_building_in_region(main_slot, "wh3_main_ksl_kislev_city_"..tostring(i))
        end
        --add the buildings from the table to ensure Kislev is protected
        for _, v in ipairs(fortress_kislev_buildings) do
            cm:add_building_to_settlement(test_cases[campaign_type], v)
        end
    end)
end

--##### Windows version functions #####--

function Lib.Compat.Misc.check_if_win7()
    local win7_testing
    local f = io.popen("ver")
    local version = f:read("*a")
    f:close()
    local version_number = string.match(version, "%d+")
    if (tonumber(version_number) < 10) then
        win7_testing = true
    else
        win7_testing = false
    end
    return win7_testing
end

--##### build functions #####--

function Lib.Compat.Misc.find_build_number_and_changelist()
    callback(function()
        local game_version = common.game_version()
        local trim = string.match(game_version, '%s(.*)%(')
        g_build_number = string.match(trim, '(%d+)%.')
        g_changelist = string.match(trim, '%.(.*)%s')
    end)
end

--##### resolution stability functions #####--

--setup the resolution stability log file and add the header line
function Lib.Compat.Misc.setup_csv_log_file()
    local appdata = os.getenv("APPDATA")
    g_reso_stab_log_location = appdata.."\\CA_Autotest\\WH3\\resolution_stability"
    Utilities.print("LOGS! "..g_reso_stab_log_location)
    g_reso_stab_log_name = os.date("resolution_stability_log_%d%m%y_%H%M")
    os.execute("mkdir \""..g_reso_stab_log_location.."\"")
    Functions.write_to_document("Game Area,Display Mode,Resolution,Result", g_reso_stab_log_location, g_reso_stab_log_name, ".csv", false, true)
end

function Lib.Compat.Misc.test_resolution_stability(variables)
    callback(function()
        if (variables.testing_area == 'All' or variables.testing_area == 'Frontend') then
            Lib.Compat.Misc.test_resolution_stability_in_frontend(variables)
        end
        if (variables.testing_area == 'All' or variables.testing_area == 'Campaign') then
            Lib.Compat.Misc.test_resolution_stability_in_campaign(variables)
        end
        if (variables.testing_area == 'All' or variables.testing_area == 'Custom Battle') then
            Lib.Compat.Misc.test_resolution_stability_in_custom_battle(variables)
        end
    end)
end

function Lib.Compat.Misc.test_resolution_stability_in_frontend(variables)
    callback(function()
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Compat.Misc.resolution_stability_test(variables.log_csv, "Frontend", variables.display_mode)
    end)
end

function Lib.Compat.Misc.test_resolution_stability_in_campaign(variables)
    callback(function()
        Lib.Frontend.Loaders.load_chaos_campaign("Random", variables.campaign_type)
        Lib.Campaign.Misc.ensure_cutscene_ended()
        Lib.Helpers.Misc.wait(5, true)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Compat.Misc.resolution_stability_test(variables.log_csv, "Campaign", variables.display_mode)
        Lib.Menu.Misc.quit_to_frontend()
    end)
end

function Lib.Compat.Misc.test_resolution_stability_in_custom_battle(variables)
    callback(function()
        Lib.Frontend.Loaders.load_custom_battle()
        Lib.Helpers.Misc.wait(5, true)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Compat.Misc.resolution_stability_test(variables.log_csv, "Custom Battle", variables.display_mode)
        Lib.Battle.Misc.concede_battle_after_duration(10)
    end)
end

function Lib.Compat.Misc.resolution_stability_test(log_csv, game_mode, display_mode)
    callback(function()
        if display_mode == "Both" then
            Lib.Frontend.Options.change_display_mode("fullscreen")
            Lib.Compat.Loops.resolution_stability_loop(log_csv, game_mode, "fullscreen")
            Lib.Helpers.Misc.wait(5, true)
            Lib.Frontend.Options.change_display_mode("windowed")
            Lib.Compat.Loops.resolution_stability_loop(log_csv, game_mode, "windowed")
        else
            Lib.Frontend.Options.change_display_mode(display_mode)
            Lib.Compat.Loops.resolution_stability_loop(log_csv, game_mode, display_mode)
        end
    end)
end