function Lib.Components.Battle.start_battle()
    return Functions.find_component("finish_deployment:deployment_end_sp:button_battle_start")
end

function Lib.Components.Battle.bottom_bar()
     return Functions.find_component("battle_orders_pane:bottom_bar")
end

function Lib.Components.Battle.survival_build_point_parent()
    return Functions.find_component("building_icon_holder")
end

function Lib.Components.Battle.survival_build_point_option_parent(build_point)
    return Functions.find_component("building_icon_holder:"..build_point..":construct_radial")
end

function Lib.Components.Battle.survival_build_point_option_select(build_point_id, construct_id)
    return Functions.find_component("building_icon_holder:"..build_point_id..":construct_radial:"..construct_id)
end

function Lib.Components.Battle.battle_results_continue()
    return Functions.find_component("postbattle:docker:bottom_parent:button_continue")
end

function Lib.Components.Battle.start_deployment()
    return Functions.find_component("pre_deployment_parent:button_start_deployment")
end

function Lib.Components.Battle.button_dismiss_results()
    return Functions.find_component("in_battle_results_popup:background:button_background:button_parent:button_dismiss_results")
end

function Lib.Components.Battle.cards_panel()
	return Functions.find_component("battle_orders:battle_orders_pane:card_panel_docker:cards_panel")
end

function Lib.Components.Battle.cards_holder()
	local path = Functions.find_path_from_component(Lib.Components.Battle.cards_panel())
	return Functions.find_component(path..":review_DY")
end

function Lib.Components.Battle.cards_holder_card(card_id)
	local path = Functions.find_path_from_component(Lib.Components.Battle.cards_holder())
	return Functions.find_component(path..":"..card_id)
end

function Lib.Components.Battle.card_info_panel()
	return Functions.find_component("hud_battle:info_panel_parent:info_panel_background:unit_information:info_parent:info_panel")
end

function Lib.Components.Battle.battle_radar_holder()
    return Functions.find_component("hud_battle:radar_holder")
end

function Lib.Components.Battle.battle_radar()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":radar_group:radar")
end

function Lib.Components.Battle.battle_pause_battle()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":speed_controls:speed_buttons:pause")
end

function Lib.Components.Battle.battle_slowmo_battle()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":speed_controls:speed_buttons:slow_mo")
end

function Lib.Components.Battle.battle_play_battle()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":speed_controls:speed_buttons:play")
end

function Lib.Components.Battle.battle_forward_battle()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":speed_controls:speed_buttons:fwd")
end

function Lib.Components.Battle.battle_fast_forward_battle()
	local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
    return Functions.find_component(path..":speed_controls:speed_buttons:ffwd")
end

function Lib.Components.Battle.battle_help_panel()
    local path = Functions.find_path_from_component(Lib.Components.Battle.battle_radar_holder())
	return Functions.find_component(path..":help_panel")
end

function Lib.Components.Battle.battle_help_panel_close()
    local path = Functions.find_path_from_component(Lib.Components.Battle.battle_help_panel())
	return Functions.find_component(path..":top_bar_parent:button_hp_close")
end

function Lib.Components.Battle.battle_winds_of_magic()
    return Functions.find_component("hud_battle:winds_of_magic")
end

function Lib.Components.Battle.battle_bop_frame()
    return Functions.find_component("hud_battle:BOP_frame")
end