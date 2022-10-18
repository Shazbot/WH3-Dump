function Lib.Frontend.Options.select_graphics_quality(quality)
    callback(function()
        if (quality ~= nil) then
            if(quality ~= "Default") then
                Common_Actions.select_dropdown_option(Lib.Components.Frontend.graphics_quality_dropdown(), quality, true)
                Lib.Frontend.Clicks.apply_graphics()
                -- slower PCs need a wait to make sure the pop-up has triggered and it's visible
                Lib.Helpers.Misc.wait(2)
                callback(function()
                    local confirm_change = Lib.Components.Helpers.confirm_graphics_preset_change()
                    if(confirm_change ~= nil and confirm_change:Visible(true) == true) then
                        Lib.Helpers.Clicks.confirm_graphics_preset_change()
                    end
                end)
            else
                Utilities.print("Default graphics preset selected, resetting the options to ensure everything is on default")
                Lib.Frontend.Options.reset_graphics_quality()
            end
        else
            Utilities.print("No graphics quality selected, not making any changes!")
        end
    end)
end

-- return to default graphics preset
function Lib.Frontend.Options.reset_graphics_quality()
    callback(function()
        Lib.Frontend.Clicks.graphics_recommended()
        Lib.Frontend.Clicks.apply_graphics()
        -- slower PCs need a wait to make sure the pop-up has triggered and it's visible
        Lib.Helpers.Misc.wait(1)
        callback(function()
            local confirm_change = Lib.Components.Helpers.confirm_graphics_preset_change()
            if(confirm_change ~= nil and confirm_change:Visible(true) == true) then
                Lib.Helpers.Clicks.confirm_graphics_preset_change()
            end
        end)
    end)
end

-- changing resolution will result in a loding screen that can sometimes take a while on slower PCs
-- the function waits and repeats itself until the pop-up is visible
-- the same pop-up is also used for confirming the switch between windowed and fullscreen mode
local function confirm_resolution(count)
    callback(function()
        count = count or 0
        if(count <= 10) then
            local confirm_change = Lib.Components.Helpers.confirm_resolution_change()
            if (confirm_change ~= nil and confirm_change:Visible(true) == true) then
                Lib.Helpers.Clicks.confirm_resolution_change()
            else
                Lib.Helpers.Misc.wait(5)
                count = count + 1
                confirm_resolution(count)
            end
        else
            Utilities.print("No pop-up detected!")
        end
    end)
end

-- resolution has to be passed as a string, ex. "1920x1080"
function Lib.Frontend.Options.select_resolution(resolution)
    local found_resolution = false
    callback(function()
        if(resolution == nil) then
            Utilities.print("No Resolution Set")
        else
            local _, resolution_list = Common_Actions.get_dropdown_list_count(Lib.Components.Frontend.resolution_dropdown())
            for _, v in ipairs(resolution_list) do
                local used_resolution = UIComponent(v:Find("row_tx")):GetStateText()
                if(resolution == used_resolution) then
                    local current_resolution = Lib.Components.Helpers.current_resolution():GetStateText()
                    if(resolution ~= current_resolution) then
                        Common_Actions.select_dropdown_option(Lib.Components.Frontend.resolution_dropdown(), resolution, true)
                        Lib.Helpers.Misc.wait(1)
                        Lib.Frontend.Clicks.apply_graphics()
                        confirm_resolution()
                    else
                        Utilities.print("The game is already on "..resolution.." resolution!")
                    end
                    found_resolution = true
                end
            end
            if not found_resolution then
                Utilities.print("The specified value: '"..resolution.."' is not a valid in game resolution")
            end
        end
    end)
end

function Lib.Frontend.Options.select_benchmark(benchmark)
    callback(function()
        if(benchmark ~= nil) then
            local _, benchmark_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.benchmark_list_parent())
            for _, v in pairs(benchmark_list) do
                local benchmark_name_component = Lib.Components.Frontend.benchmark_name(v:Id())
                local benchmark_name = benchmark_name_component:GetStateText()
                if(benchmark == benchmark_name) then
                    Lib.Frontend.Clicks.select_benchmark(v:Id())
                    return
                end
            end
            Utilities.print("No Matching Benchmark Found")
        else
            Utilities.print("No Benchmark Set")
        end
    end)
end

function Lib.Frontend.Options.navigate_to_graphics_advanced()
    callback(function()
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Frontend.Clicks.graphics_advanced()
    end)
end

function Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
    callback(function()
        Lib.Helpers.Misc.wait(1)
        Lib.Helpers.Clicks.select_ingame_graphics_options()
        Lib.Helpers.Clicks.select_advanced_graphics_options()
    end)
end

function Lib.Frontend.Options.record_advanced_graphics_dropdown_counts()
    -- Get the size of each option
    for i = 1, #g_setting_sweep_list do
        local current_setting = g_setting_sweep_list[i]
        local current_setting_table = g_setting_sweep_list[current_setting]
        local current_setting_type = current_setting_table[1]
        local current_setting_function = current_setting_table[2]
        if(current_setting_type == "dropdown") then
            local current_setting_component = current_setting_function()
            local dropdown_count = Common_Actions.get_dropdown_list_count(current_setting_component)
            current_setting_table[3] = dropdown_count
        elseif(current_setting_type == "checkbox") then
            current_setting_table[3] = 2
        end
    end
end

function Lib.Frontend.Options.set_advanced_graphics_setting(setting, setting_choice)
    callback(function()
        -- g_setting_sweep_list can be found in frontend/tables

        if(type(setting) == "number") then
            setting_choice = g_setting_sweep_list[setting]
        end

        local setting_details = g_setting_sweep_list[setting]
        local setting_type = setting_details[1]
        local setting_function = setting_details[2]
        local setting_component = setting_function()

        if(setting_type == "dropdown") then
            local setting_limit = Common_Actions.get_dropdown_list_count(setting_component)
            if(setting_choice <= setting_limit) then
                -- check to see if the option we are wanting to set the setting to isn't already selected.
                local current_selection_text = Lib.Components.Helpers.current_dropdown_text(setting_component):GetStateText()
                local intended_selection_text = Common_Actions.get_dropdown_text(setting_component, "option"..setting_choice - 1)
                if(current_selection_text ~= intended_selection_text) then
                    -- if different, change to what we want.
                    Common_Actions.select_dropdown_option(setting_component, setting_choice)
                end
            else
                Utilities.print("Can't set "..setting_component:Id().. " higher than it's limit")
            end
        elseif(setting_type == "checkbox") then
            local turn_on
            if(setting_choice == 1) then
                turn_on = false
            elseif(setting_choice == 2) then
                turn_on = true
            end
            Common_Actions.toggle_checkbox(setting_component, turn_on)
        end
    end)
end

--navigates to options from front end, sets preset to specified option and sets texture quality to specified option
--preset is a string matching the presets in game e.g. "Low"
--texture_setting is an int relating to the option in the texture quality dropdown e.g. 1
function Lib.Frontend.Options.navigate_to_options_set_preset_and_texture_quality(preset, texture_setting)
    callback(function()
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Frontend.Options.select_graphics_quality(preset)
        Lib.Frontend.Clicks.graphics_advanced()
        --as part of this we want to set the texture quality to match the current preset e.g. Low preset == low texture quality
        Lib.Frontend.Options.set_advanced_graphics_setting("texture quality", texture_setting)
        Lib.Frontend.Clicks.apply_graphics()
        -- after changing some settings there is a popup.
        Lib.Frontend.Clicks.close_popup()
    end)
end

-- pass it a custom percentange value without the % sign, example custom_value = 150
function Lib.Frontend.Options.set_UI_scale_to_custom_value(custom_value, count)
    callback(function()
        count = count or 0
        if count > 15 then
            Utilities.print("The UI scale has been modified to it's lowest or highest value already. Breaking out of the loop in case the game doesn't support the value passed to the function.")
            return
        else
            custom_value = custom_value or nil
            local ui_scale_text = Lib.Components.Helpers.current_ui_scale()
            local current_ui_scale = string.match(ui_scale_text:GetStateText(), "%d+")
            if (custom_value ~= nil) then
                local current_resolution = Lib.Components.Helpers.current_resolution():GetStateText()
                local w, h = string.match(current_resolution, "%d+"), string.match(current_resolution, "%d+$")
                -- UI scale this only works for 2560x1440 and above resolutions
                -- w & h are the width and height of thew resolution. For example, 1920 is the width and 1080 is the height
                if(tonumber(w) >= 2560 and tonumber(h) >= 1440) then
                    if(custom_value == current_ui_scale) then
                        Lib.Frontend.Clicks.graphics_apply_ui_scale()
                        Lib.Frontend.Clicks.apply_graphics()
                    else
                        if(tonumber(custom_value) < tonumber(current_ui_scale)) then
                            Lib.Frontend.Clicks.graphics_decrease_ui_scale()
                            Lib.Frontend.Options.set_UI_scale_to_custom_value(custom_value, count)
                        else
                            Lib.Frontend.Clicks.graphics_increase_ui_scale()
                            Lib.Frontend.Options.set_UI_scale_to_custom_value(custom_value, count)
                        end
                    end
                else
                    Utilities.print("Current resolution is "..w.."x"..h.." and UI Scale cannot be changed if the resolution is below 2560x1440")
                end
            else
                Utilities.print("No UI Scale specified")
            end
        end
    end)
end

-- accepts "windowed" or "fullscreen"
function Lib.Frontend.Options.change_display_mode(display_mode)
    callback(function()
        display_mode = display_mode or "windowed"
        local checkbox = Lib.Components.Frontend.graphics_windowed_checkbox()
        local turn_on = (display_mode == "windowed")
        Common_Actions.toggle_checkbox(checkbox, turn_on)
        Lib.Frontend.Clicks.apply_graphics()
        confirm_resolution()
    end)
end