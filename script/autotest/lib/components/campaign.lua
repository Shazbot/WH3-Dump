function Lib.Components.Campaign.end_turn()
    return Functions.find_component("c_main_end_turn_button")
end

function Lib.Components.Campaign.cinematic_bars()
    return Functions.find_component("cinematic_bars")
end

function Lib.Components.Campaign.select_advisor_options()
    return Functions.find_component("advice_interface:advisor_portrait_parent:button_toggle_options")
end

function Lib.Components.Campaign.skip_notification()
    return Functions.find_component("c_main_skip_notification")
end

function Lib.Components.Campaign.battle_button_parent()
    return Functions.find_component("mid:battle_results:button_set_win")
end

function Lib.Components.Campaign.auto_resolve()
    -- auto-resolve button changes depending on battle type.
    local siege_result = Functions.find_component("popup_pre_battle:mid:battle_deployment:regular_deployment:button_set_siege:button_autoresolve")
    if(siege_result ~= nil and siege_result:Visible(true) == true) then
        return siege_result
    else
        return Functions.find_component("popup_pre_battle:mid:battle_deployment:regular_deployment:button_set_attack:button_autoresolve")
    end
    
end

function Lib.Components.Campaign.fight_battle()
    local fight_battle = Functions.find_component("button_docker:button_parent_when_no_countdown_active:button_set_attack:button_attack_container:button_attack")
    if(fight_battle == nil or fight_battle:Visible(true) == false) then
        fight_battle = Functions.find_component("button_docker:button_parent_when_no_countdown_active:button_set_siege:button_attack_container:button_attack")
    end
    return fight_battle
end

function Lib.Components.Campaign.button_counteroffer()
    return Functions.find_component("button_counteroffer")
end

function Lib.Components.Campaign.diplomacy_button_accept()
    local accept_1 = Functions.find_component("panel_diplomacy:offers_list_panel:button_accept")
    local accept_2 = Functions.find_component("panel_diplomacy:offers_list_panel:button_set_holder:button_set3:button_accept")
    local accept_3 = Functions.find_component("panel_diplomacy:offers_list_panel:button_set_holder:button_set2:button_accept")
    local accept_4 = Functions.find_component("diplomacy_dropdown:subpanel_group:war_declared:button_ok_war_declared")
    local accept_5 = Functions.find_component("diplomacy_dropdown:offers_panel:panel_diplomacy:offers_list_panel:button_set_holder:button_set1:button_send")
    if(accept_1 ~= nil and accept_1:Visible(true) == true) then
        return accept_1
    elseif(accept_2 ~= nil and accept_2:Visible(true) == true) then
        return accept_2
    elseif(accept_3 ~= nil and accept_3:Visible(true) == true) then
        return accept_3
    elseif(accept_4 ~= nil and accept_4:Visible(true) == true) then
        return accept_4
    else
        return accept_5
    end
end

function Lib.Components.Campaign.diplomacy_button_decline()
    return Functions.find_component("diplomacy_dropdown:offers_panel:panel_diplomacy:offers_list_panel:button_set_holder:button_set2:button_cancel")
end

function Lib.Components.Campaign.close_advisor()
    return Functions.find_component("advice_text_panel:maximised_button_docker:button_close")
end

function Lib.Components.Campaign.dismiss_battle_panel()
    return Functions.find_component("popup_battle_results:mid:battle_results:button_dismiss_holder:button_dismiss")
end

function Lib.Components.Campaign.event_layout_parent()
    return Functions.find_component("events:event_layouts")
end

function Lib.Components.Campaign.dilemma_option_parent()
    --return Functions.find_component("c_dilemma_choice_parent") --removed until I can fix the script tag duplication
    return Functions.find_component("events:event_layouts:dilemma_active:dilemma:dilemma_list")
end

function Lib.Components.Campaign.dilemma_option(option)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.dilemma_option_parent())
    return Functions.find_component(path..":"..option..":choice_button")
end

function Lib.Components.Campaign.turn_number()
    return Functions.find_component("c_main_turn_number")
end

function Lib.Components.Campaign.captives_option_parent()
    return Functions.find_component("popup_battle_results:mid:battle_results:button_set_win")
end

function Lib.Components.Campaign.battle_results_parent()
    return Functions.find_component("popup_battle_results:mid:battle_results")
end

function Lib.Components.Campaign.declare_war_on_master()
    return Functions.find_component("panel_manager:enemy_vassal_options:options_bar1")
end

function Lib.Components.Campaign.peace_with_vassal()
    return Functions.find_component("panel_manager:enemy_vassal_options:options_bar2")
end

function Lib.Components.Campaign.enter_war_with_ally()
    return Functions.find_component("ally_attacked:button_parent:button_join_defender")
end

function Lib.Components.Campaign.decline_break_alliance()
    return Functions.find_component("ally_attacked:button_parent:decline_button")
end

function Lib.Components.Campaign.join_ally_in_war()
    return Functions.find_component("ally_attacked:button_parent:button_join_aggressor")
end

function Lib.Components.Campaign.declare_war()
    return Functions.find_component("panel_manager:move_options:panel:options_bar1")
end

function Lib.Components.Campaign.accept_declare_war()
    return Functions.find_component("war_declared:both_buttongroup:button_ok_declare")
end

function Lib.Components.Campaign.confirm_declare_war()
    return Functions.find_component("war_declared:button_ok_war_declared")
end

function Lib.Components.Campaign.new_general_parent()
    return Functions.find_component("general_selection_panel:character_list:listview:list_clip:list_box")
end

function Lib.Components.Campaign.new_general_select(general)
    return Functions.find_component("general_selection_panel:character_list:listview:list_clip:list_box:"..general)
end

function Lib.Components.Campaign.button_hire()
    return Functions.find_component("button_hire")
end

function Lib.Components.Campaign.accept_event()
    return Functions.find_component("events:button_set:accept_holder:button_accept")
end

function Lib.Components.Campaign.accept_large_incident()
    return Functions.find_component("incident_large:incident_large:background:footer:text_button")
end

function Lib.Components.Campaign.astral_projection_fragment_list()
    return Functions.find_component("c_main_astral_projection_fragment_list")
end

function Lib.Components.Campaign.astral_projection_button()
    return Functions.find_component("c_main_astral_projection")
end

function Lib.Components.Campaign.select_khorne_realm()
    return Functions.find_component("realm_l`ist:button_toggle_khorne")
end

function Lib.Components.Campaign.select_nurgle_realm()
    return Functions.find_component("realm_list:button_toggle_nurgle")
end

function Lib.Components.Campaign.enter_slaanesh_realm()
    return Functions.find_component("realm_list:button_toggle_slaanesh")
end

function Lib.Components.Campaign.select_tzeentch_realm()
    return Functions.find_component("realm_list:button_toggle_tzeentch")
end

function Lib.Components.Campaign.enter_ap_realm()
    return Functions.find_component("astral_projection:panel:button_frame:button_enter_realm")
end

function Lib.Components.Campaign.resource_bar_parent()
	return Functions.find_component("hud_campaign:resources_bar_holder:resources_bar")
end

function Lib.Components.Campaign.treasury_holder()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.resource_bar_parent())
	return Functions.find_component(path..":treasury_holder")
end

function Lib.Components.Campaign.treasury_button()
	return Functions.find_component("hud_campaign:resources_bar_holder:resources_bar:treasury_holder:dy_treasury:button_finance")
end

function Lib.Components.Campaign.treasury_income()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.treasury_holder())
	return Functions.find_component(path..":dy_income")
end

function Lib.Components.Campaign.treasury_finance_panel()
	return Functions.find_component("finance_screen")
end

function Lib.Components.Campaign.treasury_finance_projected_income_panel()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.treasury_finance_panel())
	return Functions.find_component(path..":TabGroup:tab_taxes:tab_child:taxes:projected_income")
end

function Lib.Components.Campaign.treasury_finance_projected_income_element()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.treasury_finance_projected_income_panel())
	return Functions.find_component(path..":tx_income_annual:dy_annual-income") -- The dy_annual-income is intended and how it appears in game. In the event that things start to break check here!
end

function Lib.Components.Campaign.technology_panel()
    return Functions.find_component("c_tech_panel")
end

function Lib.Components.Campaign.open_tech_panel()
    return Functions.find_component("c_main_technology_button")
end

function Lib.Components.Campaign.tech_parent()
    return Functions.find_component("c_tech_select_parent")
end

function Lib.Components.Campaign.select_tech(tech_id)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.tech_parent())
    return Functions.find_component(path..":"..tech_id..":technology_entry")
end

function Lib.Components.Campaign.close_tech_panel()
    return Functions.find_component("c_tech_close_button")
end

function Lib.Components.Campaign.open_objectives_panel()
	return Functions.find_component("hud_campaign:faction_buttons_docker:button_group_management:button_missions")
end

function Lib.Components.Campaign.objectives_panel_parent()
	return Functions.find_component("objectives_screen")
end

function Lib.Components.Campaign.close_objectives_panel()
	return Functions.find_component("hud_campaign:hud_center_docker:hud_center:small_bar:button_close_holder:button_close")
end

function Lib.Components.Campaign.main_units_panel()
	return Functions.find_component("units_panel:main_units_panel")
end

function Lib.Components.Campaign.main_units_panel_card_holder()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.main_units_panel())
	return Functions.find_component(path..":units")
end

function Lib.Components.Campaign.main_units_panel_card_holder_unit(unit)
	local path = Functions.find_path_from_component(Lib.Components.Campaign.main_units_panel_card_holder())
	return Functions.find_component(path..":"..unit)
end

function Lib.Components.Campaign.recruit_units()
    return Functions.find_component("c_army_recruit_units")
end

function Lib.Components.Campaign.recruitment_capacity_parent()
    return Functions.find_component("c_unit_recruitment_capacity_parent")
end

function Lib.Components.Campaign.recruitable_unit_parent()
    return Functions.find_component("c_recruitment_recruitable_unit_parent")
end

function Lib.Components.Campaign.recruitable_unit_select(unit)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.recruitable_unit_parent())
    return Functions.find_component(path..":"..unit)
end

function Lib.Components.Campaign.recruitable_unit_cost(unit)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.recruitable_unit_parent())
    return Functions.find_component(path..":"..unit..":RecruitmentCost:Cost")
end

function Lib.Components.Campaign.recruitable_unit_upkeep(unit)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.recruitable_unit_parent())
    return Functions.find_component(path..":"..unit..":UpkeepCost:Upkeep")
end

function Lib.Components.Campaign.lords_tab()
    return Functions.find_component("c_main_lord_tab")
end

function Lib.Components.Campaign.lord_select_parent()
    return Functions.find_component("c_lords_lord_select_parent")
end

function Lib.Components.Campaign.lord_select(lord)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.lord_select_parent())
    return Functions.find_component(path..":"..lord)
end

function Lib.Components.Campaign.provinces_tab()
    return Functions.find_component("c_main_regions_tab")
end

function Lib.Components.Campaign.your_provinces_parent()
    return Functions.find_component("c_provinces_your_province_parent")
end

function Lib.Components.Campaign.your_provinces_select(province)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.your_provinces_parent())
    return Functions.find_component(path..":"..province)
end

function Lib.Components.Campaign.settlement_panel()
    return Functions.find_component("settlement_panel")
end

function Lib.Components.Campaign.settlement_list()
    return Functions.find_component("settlement_panel:settlement_list")
end

function Lib.Components.Campaign.building_browser()
    return Functions.find_component("c_settlement_building_browser_button")
end

function Lib.Components.Campaign.close_building_browser()
    return Functions.find_component("c_building_browser_ok_button")
end

function Lib.Components.Campaign.building_upgrade_cost(settlement)
    return Functions.find_component("building_browser:listview:list_clip:list_box:building_tree:slot_parent:"..settlement..":mouseover_parent:upgrade-box:cost_list:building_cost")
end

function Lib.Components.Campaign.building_category_parent()
    return Functions.find_component("c_building_browser_catagory_parent")
end

function Lib.Components.Campaign.building_chain_parent(category)
    return Functions.find_component(category..":chain_list_parent:chain_list")
end

function Lib.Components.Campaign.building_parent(category, chain)
    return Functions.find_component(category..":"..chain..":building_chain:slot_parent")
end

function Lib.Components.Campaign.building_square_build_button(category, chain, building)
    return Functions.find_component(category..":"..chain..":building_chain:slot_parent:"..building..":square_building_button")
end

function Lib.Components.Campaign.building_build_turns_icon(category, chain, building)
    return Functions.find_component(category..":"..chain..":building_chain:slot_parent:"..building..":known_parent:turns_center")
end

function Lib.Components.Campaign.upgrade_building(building)
    return Functions.find_component(building)
end

function Lib.Components.Campaign.building_under_construction(building)
    return Functions.find_component(building..":constructing_animation")
end

function Lib.Components.Campaign.main_diplomancy_component()
	return Functions.find_component("diplomacy_dropdown")
end

function Lib.Components.Campaign.open_diplomacy_panel()
    return Functions.find_component("c_main_diplomacy_button")
end

function Lib.Components.Campaign.cancel_diplomacy()
     return Functions.find_component("c_diplomacy_cancel_button")
end

function Lib.Components.Campaign.diplomacy_faction_parent()
    return Functions.find_component("sortable_list_factions:list_clip:list_box")
    --return Functions.find_component("c_diplomacy_faction_parent")
end
function Lib.Components.Campaign.diplomacy_select_faction(faction_id)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.diplomacy_faction_parent())
    return Functions.find_component(path..":"..faction_id)
end

function Lib.Components.Campaign.diplomacy_faction_attitude_icon(faction_id)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.your_provinces_parent())
    return Functions.find_component(path..":"..faction_id..":attitude")
end

function Lib.Components.Campaign.diplomacy_faction_attitude_value()
    return Functions.find_component("c_diplomacy_attitude_value")
end

function Lib.Components.Campaign.initiate_diplomacy()
    return Functions.find_component("diplomacy_dropdown:faction_panel:both_buttongroup:button_ok")
    --return Functions.find_component("c_diplomacy_initiate_diplomacy")
end

function Lib.Components.Campaign.add_offer_demand()
    return Functions.find_component("offers_list_panel:add_offer_button")
    --return Functions.find_component("c_diplomacy_add_offer_demand")
end

function Lib.Components.Campaign.diplomatic_action_parent()
    return Functions.find_component("offers_list_panel:list_possible_actions")
    --return Functions.find_component("c_diplomacy_action_parent")
end

function Lib.Components.Campaign.select_diplomatic_action(action_id)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.diplomatic_action_parent())
    return Functions.find_component(path..":"..action_id)
end

function Lib.Components.Campaign.diplomatic_action_name(action_id)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.diplomatic_action_parent())
    return Functions.find_component(path..":"..action_id..":row_tx")
end

function Lib.Components.Campaign.payments_ok()
    return Functions.find_component("ok_payments")
    --return Functions.find_component("c_diplomacy_confirm_payments")
end

function Lib.Components.Campaign.ok_request()
    return Functions.find_component("ok_request")
    --return Functions.find_component("c_diplomacy_approve_request")
end

function Lib.Components.Campaign.offer_payment()
    return Functions.find_component("pay_offer")
    --return Functions.find_component("c_diplomacy_offer_payment")
end

function Lib.Components.Campaign.demand_payment()
    return Functions.find_component("pay_demand")
    --return Functions.find_component("c_diplomacy_demand_payment")
end

function Lib.Components.Campaign.join_war_demands_parent()
    return Functions.find_component("request_join_war:list_demands:list_clip:list_box")
    --return Functions.find_component("c_diplomacy_join_war_demands_parent")
end

function Lib.Components.Campaign.propose_offer()
    return Functions.find_component("offers_list_panel:button_set1:button_send")
    --return Functions.find_component("c_diplomacy_send_request")
end

function Lib.Components.Campaign.cancel_offer()
    return Functions.find_component("offers_list_panel:button_set_holder:button_set1:button_cancel")
    --return Functions.find_component("c_diplomacy_cancel_offer")
end

function Lib.Components.Campaign.diplomacy_quick_deal_button()
    return Functions.find_component("diplomacy_dropdown:faction_panel:faction_panel_bottom:buttons_bl:button_quick_deal")
end

function Lib.Components.Campaign.diplomacy_quick_deal_options_list_parent()
    return Functions.find_component("diplomacy_dropdown:faction_panel:list_quick_deal_buttons")
end

function Lib.Components.Campaign.diplomacy_quick_deal_factions_list_parent()
    return Functions.find_component("diplomacy_dropdown:faction_panel:faction_panel_top:sortable_list_factions:list_clip:list_box")
end

function Lib.Components.Campaign.diplomacy_cancel_quick_deal()
    return Functions.find_component("diplomacy_dropdown:faction_panel:faction_panel_bottom:both_buttongroup:button_cancel")
end


function Lib.Components.Campaign.recruit_lord()
    return Functions.find_component("c_settlement_create_army")
end

function Lib.Components.Campaign.recruit_lord_parent()
    return Functions.find_component("c_recruit_lord_lord_parent")
end

function Lib.Components.Campaign.recruit_lord_select(lord)
    local path = Functions.find_path_from_component(Lib.Components.Campaign.recruit_lord_parent())
    return Functions.find_component(path..":"..lord)
end

function Lib.Components.Campaign.recruit_lord_cost(lord)
    return Functions.find_component(lord..":Cost") 
end

function Lib.Components.Campaign.recruit_lord_upkeep(lord)
    return Functions.find_component(lord..":Upkeep") 
end

function Lib.Components.Campaign.recruit_lord_name(lord)
    return Functions.find_component(lord..":dy_name") 
end

function Lib.Components.Campaign.raise_selected_army()
    return Functions.find_component("c_recruit_lord_recruit_button") 
end

function Lib.Components.Campaign.khorne_skulls()
    return Functions.find_component("dy_khorne_skulls")
end

function Lib.Components.Campaign.accept_battle_results()
    return Functions.find_component("button_set_settlement_captured:button_accept")
end

function Lib.Components.Campaign.captured_settlement_option_parent()
    return Functions.find_component("settlement_captured:button_parent")
end

function Lib.Components.Campaign.captured_settlement_option(option)
    return Functions.find_component("settlement_captured:button_parent:"..option..":option_button")
end

function Lib.Components.Campaign.captured_settlement_option_text(option)
    return Functions.find_component("settlement_captured:button_parent:"..option..":option_button:dy_option")
end

function Lib.Components.Campaign.scout_battle_map()
    return Functions.find_component("button_preview_map")
end

function Lib.Components.Campaign.map_preview()
    return Functions.find_component("popup_pre_battle:mid:battle_deployment:regular_deployment:preview_map:preview_image")
end

function Lib.Components.Campaign.map_name()
    return Functions.find_component("popup_pre_battle:mid:battle_deployment:regular_deployment:list:battle_information_panel:location:dy_location")
end

function Lib.Components.Campaign.game_over_panel_quit_button()
    return Functions.find_component("campaign_victory:button_parent:button_quit")
end

function Lib.Components.Campaign.loading_screen_continue_button()
    return Functions.find_component("advisor_loading_screen:bottom_parent:button_continue")
end

function Lib.Components.Campaign.ie_loading_screen_continue_button()
    return Functions.find_component("custom_loading_screen:bottom_parent:button_continue")
end

--############ MAP TAB UI #############
function Lib.Components.Campaign.map_tab_events_button()
	return Functions.find_component("hud_campaign:bar_small_top:TabGroup:tab_events")
end

function Lib.Components.Campaign.map_tab_events_dropdown()
	return Functions.find_component("hud_campaign:radar_things:dropdown_parent:dropdown_events")
end

function Lib.Components.Campaign.map_tab_lords_heroes_button()
	return Functions.find_component("hud_campaign:bar_small_top:TabGroup:tab_units")
end

function Lib.Components.Campaign.map_tab_lords_heroes_dropdown()
	return Functions.find_component("hud_campaign:radar_things:dropdown_parent:dropdown_units")
end

function Lib.Components.Campaign.map_tab_provinces_button()
	return Functions.find_component("hud_campaign:bar_small_top:TabGroup:tab_regions")
end

function Lib.Components.Campaign.map_tab_provinces_dropdown()
	return Functions.find_component("hud_campaign:radar_things:dropdown_parent:dropdown_regions")
end

function Lib.Components.Campaign.map_tab_known_factions_button()
	return Functions.find_component("hud_campaign:bar_small_top:TabGroup:tab_factions")
end

function Lib.Components.Campaign.map_tab_known_factions_dropdown()
	return Functions.find_component("hud_campaign:radar_things:dropdown_parent:dropdown_regions")
end

--############ MENU BAR UI #############
function Lib.Components.Campaign.menu_bar_camera_settings_button()
    return Functions.find_component("menu_bar:buttongroup:button_settings")
end

function Lib.Components.Campaign.menu_bar_camera_settings_dropdown()
	return Functions.find_component("hud_campaign:settings_panel:camera_settings")
end

function Lib.Components.Campaign.menu_bar_camera_settings_close_button()
    return Functions.find_component("hud_campaign:settings_panel:camera_settings:button_close")
end

function Lib.Components.Campaign.menu_bar_spell_browser_button()
    return Functions.find_component("menu_bar:buttongroup:button_spell_browser")
end

function Lib.Components.Campaign.spell_browser_parent()
	return Functions.find_component("spell_browser")
end

function Lib.Components.Campaign.spell_browser_close_button()
    return Functions.find_component("spell_browser:button_close")
end

function Lib.Components.Campaign.menu_bar_help_button()
    return Functions.find_component("menu_bar:buttongroup:button_help_panel")
end

function Lib.Components.Campaign.menu_bar_help_panel()
	return Functions.find_component("hud_campaign:radar_things:dropdown_parent:help_panel")
end

function Lib.Components.Campaign.menu_bar_help_panel_close_button()
    return Functions.find_component("hud_campaign:radar_things:dropdown_parent:help_panel:top_bar_parent:button_hp_close")
end

function Lib.Components.Campaign.menu_bar_advisor_button()
    return Functions.find_component("menu_bar:buttongroup:button_show_advice")
end

function Lib.Components.Campaign.menu_bar_advisor_panel()
    return Functions.find_component("advice_interface")
end

function Lib.Components.Campaign.menu_bar_end_turn_pause()
    return Functions.find_component("ai_turns:main_holder:bottom_parent:controls:button_pause")
end

function Lib.Components.Campaign.menu_bar_end_turn_fast_forward()
    return Functions.find_component("ai_turns:main_holder:bottom_parent:controls:button_skip")
end

--############ EVENTS DETAILS #############
function Lib.Components.Campaign.dilemma_choices_parent()
    return Functions.find_component("events:event_layouts:dilemma_active:dilemma:dilemma_list")
end

function Lib.Components.Campaign.dilemma_title()
    return Functions.find_component("events:event_layouts:dilemma_active:dilemma:main_holder:title_holder:panel_title:button_txt")
end

function Lib.Components.Campaign.dilemma_description()
    return Functions.find_component("event_layouts:dilemma_active:dilemma:main_holder:details_holder:dy_details_text:dy_description")
end

function Lib.Components.Campaign.incident_title()
    return Functions.find_component("event_layouts:incident:list:dy_title")
end

function Lib.Components.Campaign.incident_subtitle()
    return Functions.find_component("events:event_layouts:incident:list:dy_subtitle")
end

function Lib.Components.Campaign.incident_details()
    return Functions.find_component("events:event_layouts:incident:list:dy_details_text")
end

function Lib.Components.Campaign.incident_effects_parent()
    return Functions.find_component("events:event_layouts:incident:list:effect_window")
end

--########### FACTION STATS ################
function Lib.Components.Campaign.faction_summary_button()
    return Functions.find_component("hud_campaign:bar_small_top:button_factions")
end

function Lib.Components.Campaign.faction_statistics_button()
    return Functions.find_component("clan:main:TabGroup:Stats")
end

function Lib.Components.Campaign.faction_statistics_list_parent()
    return Functions.find_component("clan:main:tab_children_parent:Stats:stats_panel:listview:list_clip:list_box")
end

function Lib.Components.Campaign.faction_summary_close_button()
    return Functions.find_component("clan:button_ok_holder:button_ok")
end

function Lib.Components.Campaign.faction_details_panel()
    return Functions.find_component("clan:main:tab_children_parent:Summary:parchment_L:details:details_list")
end

function Lib.Components.Campaign.faction_details_income_element()
	local path = Functions.find_path_from_component(Lib.Components.Campaign.faction_details_panel())
    return Functions.find_component(path..":tx_income:dy_income")
end

--########### TREASURY DETAILS ################
function Lib.Components.Campaign.treasury_details_button()
    return Functions.find_component("hud_campaign:resources_bar_holder:resources_bar:treasury_holder:dy_treasury:button_finance")
end

function Lib.Components.Campaign.treasury_details_tab_button()
    return Functions.find_component("finance_screen:TabGroup:tab_summary")
end

function Lib.Components.Campaign.treasury_details_close_button()
    return Functions.find_component("hud_campaign:hud_center_docker:hud_center:small_bar:button_close_holder:button_close")
end

function Lib.Components.Campaign.treasury_details_background_income_value()
    return Functions.find_component("finance_screen:TabGroup:tab_taxes:tab_child:taxes:projected_income:income_parent:regular_income_background_income:dy_value")
end

function Lib.Components.Campaign.treasury_details_list_parent()
    return Functions.find_component("finance_screen:TabGroup:tab_summary:tab_child:summary:listview:list_clip:list_box")
end