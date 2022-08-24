function Lib.Compat.Downgrading.default_downgrading_checks()
    callback (function()
        Lib.Frontend.Loaders.load_chaos_campaign(nil, "The Realm of Chaos")
        Lib.Compat.Downgrading.copy_preferences()
        Lib.Helpers.Misc.wait(1)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
        Lib.Compat.Downgrading.downgrading_screenshot("Campaign_DefaultSettings")
        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Loaders.load_custom_battle("Siege Battle")
        Lib.Helpers.Misc.wait(1)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
        Lib.Compat.Downgrading.downgrading_screenshot("CustomBattle_DefaultSettings")
        Lib.Battle.Misc.concede_battle_after_duration(5)
    end)
end

function Lib.Compat.Downgrading.ultra_downgrading_checks()
    callback(function()
        Lib.Frontend.Loaders.load_chaos_campaign(nil, "The Realm of Chaos")
        Lib.Helpers.Misc.wait(1)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
        Lib.Compat.Downgrading.downgrading_screenshot("Campaign_@CustomAdvancedSettings")
        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Loaders.load_custom_battle("Siege Battle")
        Lib.Helpers.Misc.wait(1)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Frontend.Options.navigate_to_battle_campaign_graphics()
        Lib.Compat.Downgrading.downgrading_screenshot("CustomBattle_@CustomAdvancedSettings")
        Lib.Battle.Misc.concede_battle_after_duration(5)
    end)
end

function Lib.Compat.Downgrading.copy_preferences()
	callback(function()
        Utilities.print("Start Copying Function")
		local appdata = os.getenv("APPDATA")
        local filename = os.date("Preferences_%d%m%y_%H%M")
		save_location = appdata.."\\CA_Autotest\\WH3\\graphics_downgrading"
        os.execute("mkdir \""..save_location.."\"")
        Utilities.print("EXECUTING COPY")
		os.execute([[copy ]]..appdata..[["\The Creative Assembly"\Warhammer3\scripts\preferences.script.txt ]]..save_location..[[\]]..filename..[[.txt /Y]])
        Utilities.print("Preferences Copy Success")
	end)
end

function Lib.Compat.Downgrading.downgrading_screenshot(m_filename)
    callback(function()
		local username = os.getenv("USERNAME")
		callback(function()
            Lib.Helpers.Misc.wait(1)
            local marker = Lib.Components.Helpers.select_advanced_graphics_options()
            if (marker:Visible()== true) then
                Utilities.print("----- INFO: Taking screenshot of Advanced Options -----")
		        Common_Actions.take_screenshot(m_filename)
                -- Screenshot Location- C:\Users\username\AppData\Roaming\The Creative Assembly\Warhammer3\screenshots
            end
		end)
		Lib.Helpers.Misc.wait(1)
	end)
end

function Lib.Compat.Downgrading.set_advanced_settings()
    callback(function()
        local settings_table = {["shadow detail"] = "Extreme", ["texture quality"] = "Ultra", ["reflections"] = "On"}

        for setting, value_to_set in pairs(settings_table) do
            local setting_type =  g_setting_sweep_list[setting] [1]
            local setting_component_function = g_setting_sweep_list[setting] [2]
            local setting_component =  setting_component_function()
            if(setting_type == "dropdown") then
                Common_Actions.select_dropdown_option(setting_component, value_to_set, true)
            else
                Common_Actions.toggle_checkbox(setting_component, value_to_set, true)
            end
        end
        Lib.Helpers.Misc.wait(1)
        Lib.Frontend.Clicks.apply_graphics()
        Lib.Helpers.Misc.wait(1)
        Lib.Compat.Downgrading.copy_preferences()
    end)
end

function Lib.Compat.Downgrading.graphics_presets_stability_test()
    callback(function()
        local graphics_presets = {"Low", "Medium", "High", "Ultra", "Custom"}
        local frontend_menu = Lib.Components.Frontend.frontend_menu()
        if (frontend_menu ~= nil and frontend_menu:Visible(true) == true) then
            for _, preset in ipairs(graphics_presets) do
                Lib.Frontend.Misc.return_to_frontend()
                Lib.Frontend.Clicks.options_tab()
                Lib.Frontend.Clicks.options_graphics()
                Lib.Frontend.Options.select_graphics_quality(preset)
            end
            Lib.Frontend.Misc.return_to_frontend()
            Lib.Frontend.Clicks.options_tab()
            Lib.Frontend.Clicks.options_graphics()
            Lib.Frontend.Options.reset_graphics_quality()
        else
            for _, preset in ipairs(graphics_presets) do
                Lib.Menu.Misc.open_menu_without_fail()
                Lib.Helpers.Clicks.select_ingame_graphics_options()
                Lib.Frontend.Options.select_graphics_quality(preset)
                Lib.Menu.Misc.close_menu_without_fail()
            end
            Lib.Menu.Misc.open_menu_without_fail()
            Lib.Helpers.Clicks.select_ingame_graphics_options()
            Lib.Frontend.Options.reset_graphics_quality()
            Lib.Menu.Misc.close_menu_without_fail()
        end
    end)
end
