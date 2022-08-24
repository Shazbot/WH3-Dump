

-------------------------------------------------------
--	Disable technologies
-------------------------------------------------------

local technologies_list = {
	"wh_main_tech_emp_academy_1",
	"wh_main_tech_emp_academy_2",
	"wh_main_tech_emp_academy_3",
	"wh_main_tech_emp_barracks_1",
	"wh_main_tech_emp_barracks_2",
	"wh_main_tech_emp_barracks_3",
	"wh_main_tech_emp_barracks_4",
	"wh_main_tech_emp_barracks_5",
	"wh_main_tech_emp_barracks_6",
	"wh_main_tech_emp_forges_1",
	"wh_main_tech_emp_forges_2",
	"wh_main_tech_emp_forges_3",
	"wh_main_tech_emp_forges_4",
	"wh_main_tech_emp_forges_5",
	"wh_main_tech_emp_forges_6",
	"wh_main_tech_emp_port_1",
	"wh_main_tech_emp_port_2",
	"wh_main_tech_emp_port_3",
	"wh_main_tech_emp_port_4",
	"wh_main_tech_emp_port_5",
	"wh_main_tech_emp_port_6",
	"wh_main_tech_emp_smith_1",
	"wh_main_tech_emp_smith_2",
	"wh_main_tech_emp_smith_3",
	"wh_main_tech_emp_smith_4",
	"wh_main_tech_emp_smith_5",
	"wh_main_tech_emp_smith_6",
	"wh_main_tech_emp_stables_1",
	"wh_main_tech_emp_stables_2",
	"wh_main_tech_emp_stables_3",
	"wh_main_tech_emp_stables_4",
	"wh_main_tech_emp_stables_5",
	"wh_main_tech_emp_stables_6",
	"wh_main_tech_emp_worship_1",
	"wh_main_tech_emp_worship_2",
	"wh_main_tech_emp_worship_3"
};


function disable_features()

	local faction_list = cm:model():world():faction_list();
	local game_interface = cm:get_game_interface();
	

	--missions panel
	uim:override("objectives_panel_delete_with_button_hidden"):set_allowed(false);

	--rites
	uim:override("hide_rituals"):set_allowed(false);

	--diplomacy features - region trading and threaten
	uim:override("hide_diplomacy_region_trading"):set_allowed(false);
	uim:override("hide_diplomacy_threaten"):set_allowed(false);
	uim:override("hide_diplomacy_trade_ui"):set_allowed(false);
	
	--offices
	uim:override("offices_with_button_hidden"):set_allowed(false);
	
	--commandments
	uim:override("commandments"):set_allowed(false);
	
	--spell_browser
	uim:override("spell_browser_with_button_hidden"):set_allowed(false);
	
	--public_order
	uim:override("occupy_public_order"):set_allowed(false);
	uim:override("province_panel_public_order"):set_allowed(false);
	uim:override("building_browser_public_order"):set_allowed(false);
	uim:override("public_order_display"):set_allowed(false);

	--multi-turn
	cm:set_multi_turn_movement_enabled(false);
	
	--conquest
	uim:override("occupy_conquest"):set_allowed(false);
	
	--climate
	uim:override("occupy_climate"):set_allowed(false);
	
	--corruption
	uim:override("province_panel_corruption"):set_allowed(false);
	uim:override("building_browser_corruption"):set_allowed(false);
	uim:override("hide_settlement_label_corruption"):set_allowed(false);
	
	--effects
	uim:override("province_panel_effects"):set_allowed(false);
	uim:override("building_browser_effects"):set_allowed(false);	

	--allied recruitment
	uim:override("allied_recruitment_with_button_hidden"):set_allowed(false);

	--character details bottom buttons
	uim:override("character_details_view_records"):set_allowed(false)
	uim:override("character_details_rename"):set_allowed(false)
	
	--other
	--uim:override("advice_with_button_hidden"):set_allowed(false);
	local uic_button_close = find_uicomponent(core:get_ui_root(), "advice_interface", "button_toggle_options")
	if uic_button_close then
		uic_button_close:SetVisible(false);
	end
	uim:override("movie_viewer_with_button_hidden"):set_allowed(false);
	uim:override("spell_and_unit_browser_with_button_hidden"):set_allowed(false);
	AllowPreBattleUI(false)
	cm:enable_camera_bearing_clamp(0,0);

	-- remove treasure hunt mouse pointer
	uim:override("treasure_hunt_cursor"):set_allowed(true);
	uim:override("switch_treasure_hunt_cursor"):set_allowed(true);


	uim:override("global_recruitment_stance_checks"):set_allowed(false);
	uim:override("undiscovered_faction_flags_on_end_turn"):set_allowed(false);
	uim:override("winds_of_magic"):set_allowed(false);
	uim:override("diplomacy_double_click"):set_allowed(false);
	uim:override("faction_specific_pooled_resource"):set_allowed(false);
	uim:override("prebattle_spectate_with_button_hidden"):set_allowed(false);
	uim:override("abandon_settlements"):set_allowed(false);

	-- prevent help panel from docking
	uim:override("prevent_help_panel_docking"):set_allowed(false);

	-- finance help button
	uim:override("finance_help_button"):set_allowed(false);

	-- map overlay
	common.enable_shortcut("show_campaign_overlay_options", false)

	-- event zoom
	uim:override("event_zoom_button"):set_allowed(false);

	-- replace lord button for Yuri
	uim:override("disable_replace_faction_leader"):set_allowed(false);

	-- ai_control
	uim:override("hide_ai_control"):set_allowed(false);

	-- toggle_ui with "k"
	cm:enable_ui_hiding(false)

	local uic_popup_pre_battle = find_uicomponent(core:get_ui_root(), "popup_pre_battle")
	if uic_popup_pre_battle then 
		if common.get_context_value("CampaignBattleContext.IsQuestBattle") or prologue_check_progression["open_world"] == false then
			AllowPreBattleUI(false)
		else
			AllowPreBattleUI(true)
		end
	end
	
	local uic_faction_summary_button = find_uicomponent(core:get_ui_root(), "bar_small_top", "button_factions");
	if uic_faction_summary_button then
		uic_faction_summary_button:SetVisible(false)
	end

	if prologue_check_progression["st_income_complete"] == false then
		local dy_income = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "dy_income")
		local tx_b1 = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "tx_(")
		local tx_b2 = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "tx_)")
		if dy_income and tx_b1 and tx_b2 then
			dy_income:SetVisible(false)
			tx_b1:SetVisible(false)
			tx_b2:SetVisible(false)
		end
	end
	
end;




