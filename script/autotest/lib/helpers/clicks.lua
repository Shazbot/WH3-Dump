function Lib.Helpers.Clicks.dropdown_option(dropdown_component, option, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.dropdown_option(dropdown_component, option), "", left_click)
    end)
end

function Lib.Helpers.Clicks.dropdown_option_text(dropdown, option, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.dropdown_option_text(dropdown, option), "", left_click)
    end)
end

function Lib.Helpers.Clicks.popup_choice_component(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.popup_choice_component(), "", left_click)
    end)
end

function Lib.Helpers.Clicks.popup_choice_confirm(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.popup_choice_confirm(), "", left_click)
    end)
end

function Lib.Helpers.Clicks.popup_choice_cancel(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.popup_choice_cancel(), "", left_click)
    end)
end

function Lib.Helpers.Clicks.popup_tick(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.popup_tick(), "Tick (popup)", left_click)
    end)
end

function Lib.Helpers.Clicks.popup_both_tick(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.popup_both_tick(), "Tick (popup)", left_click)
    end)
end

function Lib.Helpers.Clicks.movie_player(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.movie_player(), "", left_click)
    end)
end

function Lib.Helpers.Clicks.confirm_quit(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.confirm_quit(), "Confirm Quit (popup)", left_click)
    end)
end

function Lib.Helpers.Clicks.exit_benchmark(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.exit_benchmark(), "Exit Benchmark (benchmark results)", left_click)
    end)
end

function Lib.Helpers.Clicks.select_ingame_graphics_options(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.select_campaign_graphics_options(), "Select Campaign Graphics Options", left_click)
    end)
end

function Lib.Helpers.Clicks.select_advanced_graphics_options(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.select_advanced_graphics_options(), "Select Advanced Graphics Options", left_click)
    end)
end

function Lib.Helpers.Clicks.confirm_graphics_preset_change(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.confirm_graphics_preset_change(), "Confirm Graphics Preset Change", left_click)
    end)
end

function Lib.Helpers.Clicks.confirm_resolution_change(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Helpers.confirm_resolution_change(), "Confirm Resolution Change", left_click)
    end)
end