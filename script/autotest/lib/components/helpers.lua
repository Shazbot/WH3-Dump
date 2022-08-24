function Lib.Components.Helpers.dropdown_option(dropdown_component, option)
    local dropdown_path = Functions.find_path_from_component(dropdown_component)
    local component = Functions.find_component(dropdown_path..":popup_menu:popup_list"..option)
    if(component == nil) then
        return Functions.find_component(dropdown_path..":popup_menu:listview:list_clip:list_box:"..option)
    else
        return Functions.find_component(dropdown_path..":popup_menu:popup_list:"..option)
	end
end

function Lib.Components.Helpers.dropdown_option_text(dropdown_component, option_choice)
	local dropdown_path = Functions.find_path_from_component(dropdown_component)
    local component = Functions.find_component(dropdown_path..":popup_menu:popup_list:"..option_choice)
	if(component == nil) then
		component = Functions.find_component(dropdown_path..":popup_menu:popup_list:"..option_choice)
		if(component == nil) then
            component = Functions.find_component(dropdown_path..":popup_menu:content:culture_list:"..option_choice)
            if(component == nil) then
			    return Functions.find_component(dropdown_path..":popup_menu:list_box:"..option_choice..":label_context_name")
            else
                return Functions.find_component(dropdown_path..":popup_menu:content:culture_list:"..option_choice..":race_button:label_context_name")
            end
		else
			return Functions.find_component(dropdown_path..":popup_menu:listview:list_clip:list_box:"..option_choice..":label_context_name")
		end
	else
		return Functions.find_component(dropdown_path..":popup_menu:popup_list:"..option_choice..":row_tx")
	end
end

function Lib.Components.Helpers.current_dropdown_text(dropdown_component)
    local dropdown_path = Functions.find_path_from_component(dropdown_component)
    return Functions.find_component(dropdown_path..":dy_selected_txt")
end

function Lib.Components.Helpers.popup_choice_component()
    return Functions.find_component("popup_message_box")
end

function Lib.Components.Helpers.popup_choice_confirm()
    return Functions.find_component("popup_message_box:box:bottom_buttons:both_group:button_tick")
end

function Lib.Components.Helpers.popup_choice_cancel()
    return Functions.find_component("popup_message_box:box:bottom_buttons:both_group:button_cancel")
end

function Lib.Components.Helpers.popup_tick()
    return Functions.find_component("popup_message_box:ok_group:button_tick")
end

function Lib.Components.Helpers.popup_both_tick()
    return Functions.find_component("dialogue_box:both_group:button_tick")
end

function Lib.Components.Helpers.movie_player()
    return Functions.find_component("movie_player")
end

function Lib.Components.Helpers.confirm_quit()
    return Functions.find_component("p_confirm_quit")
end

function Lib.Components.Helpers.exit_benchmark()
    return Functions.find_component("benchmark_summary:button_exit")
end

function Lib.Components.Helpers.select_campaign_graphics_options()
    return Functions.find_component("esc_menu:main:menu_left:menu_buttons:frame_options:button_graphics")
end

function Lib.Components.Helpers.select_advanced_graphics_options()
    return Functions.find_component("esc_menu:main:options_background_frame:options_graphics:graphics_parent:tabs:advanced_tab")
end

function Lib.Components.Helpers.confirm_graphics_preset_change()
    return Functions.find_component("popup_message_box:both_group:button_tick")
end

function Lib.Components.Helpers.confirm_resolution_change()
    return Functions.find_component("options_graphics:resolution_popup:button_res_ok")
end

function Lib.Components.Helpers.current_ui_scale()
    return Functions.find_component("scale_parent:ui_scale:scale_percentage_tx")
end

function Lib.Components.Helpers.current_resolution()
    return Functions.find_component("graphics_parent:basic_options:dropdown_resolution:dy_selected_txt")
end

function Lib.Components.Helpers.current_preset()
    return Functions.find_component("graphics_parent:basic_options:dropdown_quality:dy_selected_txt")
end

function Lib.Components.Helpers.graphics_card_text()
    return Functions.find_component("graphics_parent:panel_advanced:graphics_card:button_txt")
end

function Lib.Components.Helpers.video_memory_text()
    return Functions.find_component("graphics_parent:panel_advanced:video_memory:button_txt")
end

function Lib.Components.Helpers.scripted_tour_window()
    return Functions.find_component("scripted_tour_controls")
end

function Lib.Components.Helpers.scripted_tour_close()
    return Functions.find_component("scripted_tour_controls:button_close")
end

function Lib.Components.Helpers.scripted_tour_next()
    return Functions.find_component("scripted_tour_controls:scripted_tour_controls_list:scripted_tour_next_button")
end

function Lib.Components.Helpers.scripted_tour_end()
    return Functions.find_component("scripted_tour_controls:scripted_tour_controls_list:scripted_tour_end_button")
end