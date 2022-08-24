function Lib.Campaign.Clicks.end_turn(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.end_turn(), "End turn (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.select_advisor_options(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.select_advisor_options(), "", left_click)
    end)end

function Lib.Campaign.Clicks.skip_notification(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.skip_notification(), "Skip notification (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.open_factions_summary_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.faction_summary_button(), "Open Factions Summary Panel (campaign)", left_click)
    end, wait.short)
end

function Lib.Campaign.Clicks.close_factions_summary_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.faction_summary_close_button(), "Close Factions Summary Panel (campaign)", left_click)
    end, wait.short)
end

function Lib.Campaign.Clicks.battle_button_parent(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.battle_button_parent(), "", left_click)
    end)
end

function Lib.Campaign.Clicks.auto_resolve(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.auto_resolve(), "Autoresolve (battle panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.fight_battle()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.fight_battle(), "Fight Battle (pre battle panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.button_counteroffer(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.button_counteroffer(), "", left_click)
    end)
end

function Lib.Campaign.Clicks.cancel_diplomacy(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.cancel_diplomacy(), "Close (diplomacy panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_button_accept(left_click)
    callback(function()
        local accept = Lib.Components.Campaign.diplomacy_button_accept()
        if(accept ~= nil and accept:Visible(true) == true) then
            Common_Actions.click_component(accept, "Accept (diplomacy panel)", left_click)
        end
    end)
end

function Lib.Campaign.Clicks.diplomacy_button_decline(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.diplomacy_button_decline(), "Decline (diplomacy panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_button_accept_alternative(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.diplomacy_button_accept_alternative(), "Accept (diplomacy panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.close_advisor(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.close_advisor(), "Close (advice)", left_click)
    end)
end

function Lib.Campaign.Clicks.dismiss_battle_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.dismiss_battle_panel(), "Dismiss (battle panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.dilemma_option(option, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.dilemma_option(option), "Dilemma choice: "..option.." (dilemma panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.end_turn_timer(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.end_turn_timer(), "", left_click)
    end)
end

function Lib.Campaign.Clicks.war_declared_ok(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.war_declared_ok(), "Declare War (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.confirm_declare_war(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.confirm_declare_war(), "Confirm War Declared (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.declare_war_on_master()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.declare_war_on_master(), "Declare war on master (enemy vassal popup)", left_click)
    end)
end

function Lib.Campaign.Clicks.peace_with_vassal()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.peace_with_vassal(), "Make peace with vassal (enemy vassal popup)", left_click)
    end)
end

--join ally as defender
function Lib.Campaign.Clicks.enter_war_with_ally(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.enter_war_with_ally(), "Enter war on side of ally (call to arms)", left_click)
    end)
end

function Lib.Campaign.Clicks.decline_break_alliance(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.decline_break_alliance(), "Decline and break alliance (call to arms)", left_click)
    end)
end

--join ally as attacker
function Lib.Campaign.Clicks.join_ally_in_war(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.join_ally_in_war(), "Enter war on side of ally (call to arms)", left_click)
    end)
end

function Lib.Campaign.Clicks.declare_war(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.declare_war(), "Declare War! (declare war panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.accept_declare_war(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.accept_declare_war(), "Accept (diplomacy war panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.confirm_declare_war(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.confirm_declare_war(), "Confirm (diplomacy war panel)", left_click)
    end)
end


function Lib.Campaign.Clicks.new_general_select(general, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.new_general_select(general), "Select General (replace general panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.button_hire(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.button_hire(), "Hire (replace general panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.accept_event(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.accept_event(), "Accept (Event popup)", left_click)
    end)
end

function Lib.Campaign.Clicks.accept_large_incident(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.accept_large_incident(), "Accept (Large Incident popup)", left_click)
    end)
end

function Lib.Campaign.Clicks.provinces_tab(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.provinces_tab(), "Provinces Tab (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.your_provinces_select(province, left_click)
    callback(function()
        Utilities.print(tostring(province))
        Common_Actions.click_component(Lib.Components.Campaign.your_provinces_select(province), "Select Province: "..province.." (province menu)", left_click)
    end)
end

function Lib.Campaign.Clicks.building_browser(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.building_browser(), "Building Browser (region panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.close_building_browser(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.close_building_browser(), "Close (building browser)", left_click)
    end)
end

function Lib.Campaign.Clicks.upgrade_building(building)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.upgrade_building(building), "Select Building: "..building.." (building browser)")
    end)
end

function Lib.Campaign.Clicks.open_treasury_panel(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.treasury_button(), "Open (treasury panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.lords_tab(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.lords_tab(), "Lords & Heroes Tab (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.lord_select(lord, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.lord_select(lord), "Select: "..lord.." (lords & heroes panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.recruit_units(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.recruit_units(), "Recruit Units (army panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.recruitable_unit_select(unit, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.recruitable_unit_select(unit), "Recruit Unit: "..unit.." (recruit panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.open_tech_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.open_tech_panel(), "Open Tech Panel (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.select_tech(tech_id, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.select_tech(tech_id), "Select Tech: "..tech_id.." (tech panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.close_tech_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.close_tech_panel(), "Close (tech panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.open_objectives_panel(left_click)
	callback(function()
		Common_Actions.click_component(Lib.Components.Campaign.open_objectives_panel(), "Open (objectives panel)")
	end)
end

function Lib.Campaign.Clicks.close_objectives_panel(left_click)
	callback(function()
		Common_Actions.click_component(Lib.Components.Campaign.close_objectives_panel(), "Close (objectives panel)")
	end)
end

function Lib.Campaign.Clicks.open_diplomacy_panel(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.open_diplomacy_panel(), "Open Diplomacy (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_select_faction(faction_id, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.diplomacy_select_faction(faction_id), "Select Faction: "..faction_id.." (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.initiate_diplomacy(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.initiate_diplomacy(), "Initiate Diplomacy (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.add_offer_demand(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.add_offer_demand(), "Add Offer/Demand (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.select_diplomatic_action(action_id, left_click)
    callback(function()
		local trimmed_name = action_id:gsub("diplomatic_option_", ""):gsub("_", " "):upper()
        Common_Actions.click_component(Lib.Components.Campaign.select_diplomatic_action(action_id), "Select diplomatic proposal: "..trimmed_name.." (diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.astral_projection_button(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.astral_projection_button(), "Astral Projection (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.charge_astral_projection(left_click)
    callback(function()
        -- This is a debug click that charges AP for us.
        component = Lib.Components.Campaign.astral_projection_fragment_list()
        component:SimulateLClick()
    end)
end

function Lib.Campaign.Clicks.select_khorne_realm(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.select_khorne_realm(), "Select khorne (ap realm panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.select_nurgle_realm(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.select_nurgle_realm(), "Select nurgle (ap realm panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.enter_slaanesh_realm(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.enter_slaanesh_realm(), "Select slaanesh (ap realm panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.select_tzeentch_realm(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.select_tzeentch_realm(), "Select tzeentch (ap realm panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.enter_ap_realm(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.enter_ap_realm(), "Enter Realm (ap realm panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.ok_request(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.ok_request(), "Ok Request (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.offer_payment(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.offer_payment(), "Offer Payments (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.demand_payment(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.demand_payment(), "Demands Payments (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.payments_ok(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.payments_ok(), "Confirm Payments (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.propose_offer(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.propose_offer(), "Propose Offer (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.cancel_offer(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.cancel_offer(), "Cancel Offer (Diplomacy)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_quick_deal_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.diplomacy_quick_deal_button(), "Quick Deal (Diplomacy Panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_quick_deal_option(option, left_click)
    callback(function()
        Common_Actions.click_component(option, "Quick Deal Option (Diplomacy Panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.diplomacy_close_quick_deal(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.diplomacy_cancel_quick_deal(), "Cancel Quick Deal (Diplomacy Panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.recruit_lord(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.recruit_lord(), "Open Recruit Lord Panel (campaign)", left_click)
    end)
end

function Lib.Campaign.Clicks.recruit_lord_select(lord, left_click)
    callback(function()
        local lord_name = Lib.Components.Campaign.recruit_lord_name(lord):GetStateText()
        Common_Actions.click_component(Lib.Components.Campaign.recruit_lord_select(lord), "Select: "..lord_name.." (recruit lord panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.raise_selected_army(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.raise_selected_army(), "Raise Army (recruit lord panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.accept_battle_results(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.accept_battle_results(), "Accept (battle results)", left_click)
    end)
end

function Lib.Campaign.Clicks.captured_settlement_option(option, left_click)
    callback(function()
        local option_comp = Lib.Components.Campaign.captured_settlement_option_text(option)
        local option_txt = option_comp:GetStateText()
        Common_Actions.click_component(Lib.Components.Campaign.captured_settlement_option(option), "Select: "..option_txt.." (Settlement Captured Button)", left_click)
    end)
end

function Lib.Campaign.Clicks.scout_battle_map(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.scout_battle_map(), "Scout Map (pre battle panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.game_over_quit(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.game_over_panel_quit_button(), "Quit Game (Victory/Defeat panel)", left_click)
    end)
end

function Lib.Campaign.Clicks.click_loading_screen_continue_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.loading_screen_continue_button(), "Continue (Loading Screen)", left_click)
    end)
end

function Lib.Campaign.Clicks.click_ie_loading_screen_continue_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.ie_loading_screen_continue_button(), "Continue (IE Loading Screen)", left_click)
    end)
end

function Lib.Campaign.Clicks.open_treasury_details_panel()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.treasury_details_button(), "Treasury Details (campaign)", true)
    end)
end

function Lib.Campaign.Clicks.open_details_tab()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.treasury_details_tab_button(), "Treasury Details tab (campaign)", true)
    end)
end

function Lib.Campaign.Clicks.close_treasury_details_panel()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.treasury_details_close_button(), "Close Treasury Details (campaign)", true)
    end)
end

--############ MAP TAB UI CLICKS #############
function Lib.Campaign.Clicks.map_tab_events_button()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.map_tab_events_button(), "Open Events (campaign - map tab)", true)
    end)
end

function Lib.Campaign.Clicks.map_tab_lords_heroes_button()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.map_tab_lords_heroes_button(), "Open Lords & Heroes (campaign - map tab)", true)
    end)
end

function Lib.Campaign.Clicks.map_tab_provinces_button()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.map_tab_provinces_button(), "Open Provinces (campaign - map tab)", true)
    end)
end

function Lib.Campaign.Clicks.map_tab_known_factions_button()
    callback(function()
        Common_Actions.click_component(Lib.Components.Campaign.map_tab_known_factions_button(), "Open Known Factions (campaign - map tab)", true)
    end)
end

--############ MENU BAR UI CLICKS #############
function Lib.Campaign.Clicks.open_menu_bar_camera_settings()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_camera_settings_button(), "Open Camera Settings (campaign - menu bar)", true)
end

function Lib.Campaign.Clicks.close_menu_bar_camera_settings()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_camera_settings_close_button(), "Close Camera Settings (campaign - menu bar)", true)
end

function Lib.Campaign.Clicks.open_menu_bar_spell_browser()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_spell_browser_button(), "Open Spell Browser (campaign - menu bar)", true)
end

function Lib.Campaign.Clicks.close_spell_browser()
	return Common_Actions.click_component(Lib.Components.Campaign.spell_browser_close_button(), "Close Spell Browser (campaign)", true)
end

function Lib.Campaign.Clicks.open_menu_bar_help_pages()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_help_button(), "Open Help Pages (campaign - menu bar)", true)
end

function Lib.Campaign.Clicks.close_help_pages_campaign()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_help_panel_close_button(), "Close Help Pages (campaign)", true)
end

function Lib.Campaign.Clicks.open_menu_bar_advisor()
	return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_advisor_button(), "Open Advisor (campaign - menu bar)", true)
end

function Lib.Campaign.Clicks.pause_unpause_end_turn()
    return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_end_turn_pause(), "Pause/Unpause End Turn", true)
end

function Lib.Campaign.Clicks.fast_forward_end_turn()
    return Common_Actions.click_component(Lib.Components.Campaign.menu_bar_end_turn_fast_forward(), "Fast Forward End Turn", true)
end