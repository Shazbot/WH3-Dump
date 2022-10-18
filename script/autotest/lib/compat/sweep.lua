local m_sweep_log_name, m_pc_index, m_sweep_tag, m_game_mode, m_used_resolution, m_random_resolution
local m_sweep_log_location = "c:\\compat_sweep"
local m_previous_resolutions = {} -- this table is needed to ensure we don't use the same resolution multiple times during a single compat sweep
local m_ui_scale_tests = {"min", "max", "default"}
local m_hardware_info = {} -- all the logged hardware information is now added to this table

--#################################
--## Compat Sweep Main Functions ##
--#################################

function Lib.Compat.Sweep.set_sweep_log_details(log_name, pc_index, sweep_tag)
    callback(function()
        Utilities.print("Setting Compat Sweep Details")
        m_pc_index = pc_index or os.getenv("COMPUTERNAME")
        m_sweep_tag = sweep_tag or os.date("%Y-%m-%d")
        if(log_name == nil) then
            Utilities.print("No name specified, defaulting to sweeptag_pcindex_compat_sweep_log")
            m_sweep_log_name = m_sweep_tag.."_"..m_pc_index.."_compat-sweep"
        else
            m_sweep_log_name = log_name
        end
        m_hardware_info["PC Index/Name"] = m_pc_index
    end)
end

-- it's useful to see if the hardware info & game defaults recorded during the sweep are the same values we expect from that hardware configuration
function Lib.Compat.Sweep.log_session_stats()
    callback(function()
        Functions.write_to_document("Test Case,Result,Recorded", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Functions.write_to_document("Compat Sweep - Start,Passed,Start", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Lib.Compat.Sweep.log_default_graphic_settings()
        callback(function()
            Lib.Compat.Sweep.log_hardware_info(m_sweep_log_location, m_sweep_log_name)
        end, wait.long)
        Lib.Helpers.Misc.wait(5)
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Frontend.Options.change_display_mode("fullscreen")
        Lib.Helpers.Misc.wait(10)
    end)
end

function Lib.Compat.Sweep.campaign_sweep(campaign_type)
    callback(function()
        m_game_mode = "Campaign"
        Functions.write_to_document(m_game_mode.." Checks - Start,Passed", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Lib.Helpers.Misc.wait(2)
        callback(function()
            Lib.Frontend.Loaders.load_chaos_campaign(nil, campaign_type)
        end)
        Lib.Campaign.Misc.ensure_cutscene_ended()
        Functions.write_to_document("Campaign Type,Passed,"..campaign_type, m_sweep_log_location, m_sweep_log_name, ".csv", false)
        callback(function()
            Functions.write_to_document("Campaign Lord,Passed,"..g_lord, m_sweep_log_location, m_sweep_log_name, ".csv", false)
        end, wait.standard)
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(false, "1")
        Lib.Compat.Sweep.ingame_display_mode_test("windowed")
        Lib.Compat.Sweep.ingame_display_mode_test("fullscreen")
        Lib.Compat.Sweep.change_ingame_resolution("max_resolution")
        Lib.Compat.Sweep.ingame_ui_scale_tests()
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(true, "2")
        Lib.Compat.Sweep.alt_tab_test(true, 5)
        Lib.Compat.Sweep.ingame_graphics_preset_and_resolution_sweep()
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(true, "3")
        Lib.Campaign.Actions.attack_nearest_target(15)
        callback(function()
            local file_name = m_sweep_tag.."_"..m_pc_index.."_"..m_game_mode.."_battle"
            Common_Actions.take_screenshot(file_name, ".tga")
            Functions.write_to_document("Campaign Checks - End,Passed", m_sweep_log_location, m_sweep_log_name, ".csv", false)
            Lib.Menu.Misc.quit_to_frontend()
        end)
    end)
end

function Lib.Compat.Sweep.custom_battle_sweep()
    callback(function()
        m_game_mode = "Custom Battle"
        m_graphics_reset_count = tonumber(core:svr_load_registry_string("ootb_reset_count"))
        Functions.write_to_document(m_game_mode.." Checks - Start,Passed", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Lib.Helpers.Misc.wait(2)
        callback(function()
            Lib.Frontend.Loaders.load_custom_battle()
        end, wait.standard)
        Lib.Compat.Sweep.record_custom_battle_details()
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(false, "4")
        Lib.Compat.Sweep.ingame_display_mode_test("windowed")
        Lib.Compat.Sweep.ingame_display_mode_test("fullscreen")
        Lib.Compat.Sweep.change_ingame_resolution("max_resolution")
        Lib.Compat.Sweep.ingame_ui_scale_tests()
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(true, "5")
        Lib.Compat.Sweep.alt_tab_test(true, 5)
        Lib.Compat.Sweep.ingame_graphics_preset_and_resolution_sweep()
        Lib.Compat.Sweep.ingame_reset_to_ootb_settings(true, "6")
        callback(function()
            local file_name = m_sweep_tag.."_"..m_pc_index.."_sweep_finished"
            Common_Actions.take_screenshot(file_name, ".tga")
            Functions.write_to_document(m_game_mode.." Checks - End,Passed", m_sweep_log_location, m_sweep_log_name, ".csv", false)
            Lib.Battle.Misc.concede_battle_after_duration(10)
        end)
    end)
end

--###################################
--## Compat Sweep Helper Functions ##
--###################################

-- for running python script through cmd
local function osExecute(cmd)
    local fileHandle = assert(io.popen(cmd, 'r'))
    local commandOutput = assert(fileHandle:read("*a"))
    local returnTable = {fileHandle:close()}
    return commandOutput
end

-- use a powershell script which runs a different function based on the provided query_name and adds the requested information to the hardware info table;
-- query names: gpu_driver, ram_amount, os_version, os_country, os_language, machine_type, native_resolution, cpu_name;
-- pass on gpu_name so it can filter and return the driver number just for the gpu used by the game
-- the powershell script used by this is copied by the weekend testing master script to c:\compat_sweep
local function get_hardware_info(sweep_log_location)
    local gpu_name
    for k, v in pairs(g_hardware_info_functions) do
        if k == "GPU Driver Version" then
            gpu_name = m_hardware_info["GPU"]
        else
            gpu_name = ""
        end
        local pipe = io.popen("powershell -File "..sweep_log_location.."\\get_hardware_info.ps1 "..v.." "..gpu_name)
        local ps_output = pipe:read("*a")
        pipe:close()
        local hw_info = string.gsub(ps_output, "%s+$", "")
        m_hardware_info[k] = hw_info
    end
end

-- use the function above to get all the hardware info we need for a compat sweep;
-- afterwards, add it to the compat sweep log as columns (easier to import into powerBI);
-- the python script used by this is copied by the weekend testing master script to c:\compat_sweep
function Lib.Compat.Sweep.log_hardware_info(sweep_log_location, sweep_log_name)
    get_hardware_info(sweep_log_location)
    callback(function()
        Lib.Helpers.Misc.wait(5)
        Utilities.print("Adding the default graphics settings and hardware information to the compat sweep log. Please stand by!")
        for k, v in pairs(m_hardware_info) do
            callback(function()
                osExecute("py "..sweep_log_location.."\\add_columns_to_compat_sweep_csv.py "..string.format("%q", k).." "..string.format("%q", v).." "..sweep_log_location.." "..sweep_log_name..".csv")
                Lib.Helpers.Misc.wait(2) -- cheeky wait to ensure the python script finished
            end)
        end
    end)
end

local function log_default_resolution()
    callback(function()
        local resolution_display = Lib.Components.Helpers.current_resolution()
        if (resolution_display ~= nil and resolution_display:Visible(true) == true) then
            local current_resolution = resolution_display:GetStateText()
            m_hardware_info["Default Resolution"] = current_resolution
            table.insert(m_previous_resolutions, m_hardware_info["Default Resolution"])
        else
            log_default_resolution()
        end
    end)
end

function Lib.Compat.Sweep.log_default_graphic_settings()
    callback(function()
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Helpers.Misc.wait(5)
        Utilities.print("Logging the default graphics settings and the PC's hardware information")
        log_default_resolution()
        if g_manual_battles then
            callback(function()
                local graphics_preset_dropdown = Lib.Components.Frontend.graphics_quality_dropdown()
                m_hardware_info["Default Graphics Preset"] = UIComponent(graphics_preset_dropdown:Find("dy_selected_txt")):GetStateText()
                Utilities.print("Default resolution is: "..m_hardware_info["Default Resolution"])
                Utilities.print("Default graphics preset is: "..m_hardware_info["Default Graphics Preset"])
                Lib.Frontend.Clicks.graphics_advanced()
                m_hardware_info["GPU"] = Lib.Components.Helpers.graphics_card_text():GetStateText()
                m_hardware_info["VRAM"] = string.gsub(Lib.Components.Helpers.video_memory_text():GetStateText(), "%s+", "")
                m_hardware_info["Default UI Scale"] = string.match(Lib.Components.Helpers.current_ui_scale():GetStateText(), "%d+")
                Utilities.print("Game GPU is: "..m_hardware_info["GPU"])
                Utilities.print("VRAM: "..m_hardware_info["VRAM"])
                Utilities.print("Default UI Scale: "..m_hardware_info["Default UI Scale"].."%")
                Lib.Frontend.Clicks.campaign_tab()
                Lib.Helpers.Misc.wait(5)
            end)
        end
    end)
end

local function select_resolution_choice(resolution_choice, skip_insert)
    skip_insert = skip_insert or false
    callback(function() 
        Lib.Frontend.Options.select_resolution(resolution_choice)
        if not skip_insert then
            table.insert(m_previous_resolutions, resolution_choice)
            m_used_resolution = resolution_choice
        end
        Lib.Menu.Misc.close_menu_without_fail()
    end)
end

local function find_random_unused_resolution(resolution_list)
    callback(function()
        m_random_resolution = nil
        local random_resolution = resolution_list[math.random(2, Common_Actions.table_length(resolution_list) - 1)]
        local resolution = UIComponent(random_resolution:Find("row_tx")):GetStateText()
        for _,value in pairs(m_previous_resolutions) do
            if value == resolution then
                Utilities.print(tostring(resolution).." resolution already used, finding another one")
                find_random_unused_resolution(resolution_list)
            end
        end
        m_random_resolution = resolution
    end)
end

function Lib.Compat.Sweep.change_ingame_resolution(resolution_option)
    callback(function()
        resolution_option = resolution_option or "default"
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Helpers.Misc.wait(2)
        callback(function()
            local resolution_count, resolution_list = Common_Actions.get_dropdown_list_count(Lib.Components.Frontend.resolution_dropdown())
            local max_resolution = resolution_list[resolution_count]
            if (max_resolution:IsDisabled() and not max_resolution:IsInteractive()) then
                max_resolution = resolution_list[resolution_count - 1]
            end
            find_random_unused_resolution(resolution_list)
            local test_cases = {}
            test_cases["min_resolution"] = {UIComponent(resolution_list[1]:Find("row_tx")):GetStateText(), false}
            test_cases["max_resolution"] = {UIComponent(max_resolution:Find("row_tx")):GetStateText(), false}
            test_cases["default"] = {m_hardware_info["Default Resolution"], true}
            test_cases["random_unused_resolution"] = {m_random_resolution, false}

            local resolution_choice
            local skip_insert = true

            if(test_cases[resolution_option] ~= nil)then
                resolution_choice = test_cases[resolution_option][1]
                skip_insert = test_cases[resolution_option][2]
            end
            select_resolution_choice(resolution_choice, skip_insert)
        end)
    end)
end

function Lib.Compat.Sweep.ingame_graphics_preset_and_resolution_sweep()
    callback(function()
        for graphics_preset, resolution_option in pairs(g_presets_resolutions_combos) do
            Lib.Menu.Misc.open_menu_without_fail()
            Lib.Helpers.Clicks.select_ingame_graphics_options()
            Lib.Frontend.Options.select_graphics_quality(graphics_preset)
            Lib.Compat.Sweep.change_ingame_resolution(resolution_option)
            callback(function()
                local file_name = m_sweep_tag.."_"..m_pc_index.."_"..graphics_preset.."_"..m_used_resolution.."_"..m_game_mode
                Common_Actions.take_screenshot(file_name, ".tga")
                Functions.write_to_document(m_game_mode.." "..graphics_preset..",Passed,"..m_used_resolution, m_sweep_log_location, m_sweep_log_name, ".csv", false)
            end)
        end
    end)
end

function Lib.Compat.Sweep.ingame_display_mode_test(display_mode)
    callback(function()
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Frontend.Options.change_display_mode(display_mode)
        Lib.Menu.Misc.close_menu_without_fail()
        local file_name = m_sweep_tag.."_"..m_pc_index.."_"..display_mode.."_"..m_game_mode
        Common_Actions.take_screenshot(file_name, ".tga")
        Functions.write_to_document(m_game_mode.." "..display_mode..",Passed" , m_sweep_log_location, m_sweep_log_name, ".csv", false)
    end)
end

-- ootb means out of the box settings aka default;
-- doesn't work in frontend, for that check reset_graphics_quality in options
function Lib.Compat.Sweep.ingame_reset_to_ootb_settings(take_screenshot, reset_number)
    take_screenshot = take_screenshot or false
    callback(function()
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Frontend.Options.reset_graphics_quality()
        Lib.Compat.Sweep.change_ingame_resolution("default")
        Lib.Menu.Misc.close_menu_without_fail()
        if take_screenshot then
            local file_name = m_sweep_tag.."_"..m_pc_index.."_Reset_to_OOTB"
            Common_Actions.take_screenshot(file_name, ".tga")
        end
        Functions.write_to_document("Reset to OOTB Settings - "..reset_number..",Passed" , m_sweep_log_location, m_sweep_log_name, ".csv", false)
    end)
end

function Lib.Compat.Sweep.ingame_ui_scale_tests()
    callback(function()
        for _,value in ipairs(m_ui_scale_tests) do
            if(value == "default") then
                Lib.Menu.Misc.open_menu_without_fail()
                Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
                Lib.Frontend.Options.set_UI_scale_to_custom_value(m_hardware_info["Default UI Scale"])
                Lib.Menu.Misc.close_menu_without_fail()
                local file_name = m_sweep_tag.."_"..m_pc_index.."_default_ui_scale_"..m_game_mode
                Common_Actions.take_screenshot(file_name, ".tga")
                Functions.write_to_document(m_game_mode.." "..value.." UI Scale,Passed" , m_sweep_log_location, m_sweep_log_name, ".csv", false)
            else
                Lib.Menu.Misc.open_menu_without_fail()
                Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
                Lib.Compat.Sweep.set_ui_scale_to_min_or_max(value)
                Lib.Menu.Misc.close_menu_without_fail()
                local file_name = m_sweep_tag.."_"..m_pc_index.."_"..value.."_ui_scale_"..m_game_mode
                Common_Actions.take_screenshot(file_name, ".tga")
                Functions.write_to_document(m_game_mode.." "..value.." UI Scale,Passed" , m_sweep_log_location, m_sweep_log_name, ".csv", false)
            end
        end
    end)
end

-- specify which you want, "min" or "max";
-- for a function which sets the UI scale to a custom value, check Lib.Frontend.Options.set_UI_scale_to_custom_value
function Lib.Compat.Sweep.set_ui_scale_to_min_or_max(min_max)
    callback(function()
        min_max = min_max or nil
        if (min_max ~= nil) then
            local current_resolution = Lib.Components.Helpers.current_resolution():GetStateText()
            local w, h = string.match(current_resolution, "%d+"), string.match(current_resolution, "%d+$")
            -- UI scale only works for 2560x1440 and above resolutions
            -- w & h are the width and height of thew resolution. For example, 1920 is the width and 1080 is the height
            if(tonumber(w) >= 2560 and tonumber(h) >= 1440) then
                if(min_max == "min") then
                    local min_button = Lib.Components.Frontend.graphics_decrease_ui_scale()
                    local min_button_state = min_button:CurrentState()
                    if(min_button ~= nil and min_button_state ~= "inactive") then
                        Lib.Frontend.Clicks.graphics_decrease_ui_scale()
                        Lib.Compat.Sweep.set_ui_scale_to_min_or_max(min_max)
                    else
                        Lib.Frontend.Clicks.graphics_apply_ui_scale()
                        Lib.Frontend.Clicks.apply_graphics()
                    end
                else
                    local max_button = Lib.Components.Frontend.graphics_increase_ui_scale()
                    local max_button_state = max_button:CurrentState()
                    if(max_button ~= nil and max_button_state ~= "inactive") then
                        Lib.Frontend.Clicks.graphics_increase_ui_scale()
                        Lib.Compat.Sweep.set_ui_scale_to_min_or_max(min_max)
                    else
                        Lib.Frontend.Clicks.graphics_apply_ui_scale()
                        Lib.Frontend.Clicks.apply_graphics()
                    end
                end
            else
                Utilities.print("Current resolution is "..w.."x"..h.." and UI Scale cannot be changed if the resolution is below 2560x1440")
            end
        else
            Utilities.print("No UI Scale specified")
        end
    end)
end

function Lib.Compat.Sweep.record_custom_battle_details()
    callback(function()
        Functions.write_to_document("Battle Type,Passed,"..g_battle_settings["Map Type"], m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Functions.write_to_document("Map Name,Passed,"..g_map_name, m_sweep_log_location, m_sweep_log_name, ".csv", false)
        Functions.write_to_document("Unit Scale,Passed,"..g_battle_settings["Unit Scale"], m_sweep_log_location, m_sweep_log_name, ".csv", false)
        if(g_battle_settings["Large Armies"] ~= nil) then
            Functions.write_to_document("Large Armies,Passed,"..g_battle_settings["Large Armies"], m_sweep_log_location, m_sweep_log_name, ".csv", false)
        else
            Functions.write_to_document("Large Armies,N/A,N/A", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        end
        Functions.write_to_document("No of Players,Passed,"..g_battle_settings["TEAMS"], m_sweep_log_location, m_sweep_log_name, ".csv", false)
        if(g_battle_settings["Map Type"] == "Siege Battle") then
            Functions.write_to_document("Settlement Level,Passed,"..g_battle_settings["Tower Level"], m_sweep_log_location, m_sweep_log_name, ".csv", false)
        else
            Functions.write_to_document("Settlement Level,N/A,N/A", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        end
    end)
end

-- for the alt-tab test during campaign or battle
function Lib.Compat.Sweep.alt_tab_test(log_info, wait_time)
    callback(function()
        local file_name
        if log_info then
            file_name = m_sweep_tag.."_"..m_pc_index.."_"..m_game_mode.."_before_alt_tab"
            Common_Actions.take_screenshot(file_name, ".tga")
        end
        Utilities.print("Alt-tabbing out of the game by opening a file explorer window")
        os.execute([[explorer]])
        Utilities.print("Waiting for "..wait_time.." seconds then switching back to the game")
        Lib.Helpers.Misc.wait(wait_time)
        Lib.Compat.Sweep.alt_tab("Total War: WARHAMMER 3")
        if log_info then
            file_name = m_sweep_tag.."_"..m_pc_index.."_"..m_game_mode.."_after_alt_tab"
            Common_Actions.take_screenshot(file_name, ".tga")
            Functions.write_to_document("Alt-Tab Check - "..m_game_mode..",Passed", m_sweep_log_location, m_sweep_log_name, ".csv", false)
        end
    end)
end

function Lib.Compat.Sweep.alt_tab(program_name)
    callback(function()
        Utilities.print("Alt-Tabbing to "..program_name..". Stand by!")
        io.popen(m_sweep_log_location..[[\app_switch.bat "]]..program_name..[["]], 'r')
    end)
end
