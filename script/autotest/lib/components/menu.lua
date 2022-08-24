function Lib.Components.Menu.quit_to_frontend()
    return Functions.find_component("esc_menu:main:menu_left:menu_buttons:frame_quit:button_quit")
end

function Lib.Components.Menu.popup_confirm()
    return Functions.find_component("button_tick")
end

function Lib.Components.Menu.open_save()
    return Functions.find_component("button_save")
end

function Lib.Components.Menu.open_load()
    return Functions.find_component("button_load")
end

function Lib.Components.Menu.confirm_load()
    return Functions.find_component("load_game_panel:footer:button_holder:list:button_confirm_load")
end

function Lib.Components.Menu.confirm_save()
    return Functions.find_component("save_game_panel:footer:button_holder:list:button_confirm_save")
end

function Lib.Components.Menu.resume_game()
    return Functions.find_component("button_resume")
end

function Lib.Components.Menu.concede_battle()
    return Functions.find_component("esc_menu:main:menu_left:menu_buttons:holder_resume_concede:frame_concede:button_concede")
end

function Lib.Components.Menu.results_continue()
    return Functions.find_component("postbattle:docker:bottom_parent:button_continue")
end

function Lib.Components.Menu.save_filename_textbox()
    return Functions.find_component("save_panel:filename_panel:input_name")
end