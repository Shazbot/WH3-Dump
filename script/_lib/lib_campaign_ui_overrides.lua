

-------------------------------------------------------
-------------------------------------------------------
--	UI Override
--	Allows creation of a set of functions that
--	allows/disallows access to certain ui features.
--	Also allows these features to be locked/unlocked -
--	this is useful for sections of modal script that
--	turn off the whole ui to direct the player's
--	attention 
-------------------------------------------------------
-------------------------------------------------------


ui_override = {
	name = "",
	cm = nil,
	currently_locked = true,
	is_allowed = true,
	lock_func = nil,
	unlock_func = nil
};


set_class_custom_type(ui_override, TYPE_UI_OVERRIDE);
set_class_tostring(
	ui_override, 
	function(obj)
		return TYPE_UI_OVERRIDE .. "_" .. obj.name
	end
);






function ui_override:new(name, lock_func, unlock_func, lock_with_lock_ui)
	if not is_string(name) then
		script_error("ERROR: trying to create ui_override but name [" .. tostring(k_func) .. "] is not a function");
		return;
	end;
	
	if not is_function(lock_func) then
		script_error(name .. " ERROR: trying to create ui_override but supplied lock function [" .. tostring(lock_func) .. "] is not a function");
		return;
	end;
	if not is_function(unlock_func) then
		script_error(name .. " ERROR: trying to create ui_override but supplied unlock function [" .. tostring(unlock_func) .. "] is not a function");
		return;
	end;
		
	if lock_with_lock_ui ~= false then
		lock_with_lock_ui = true;
	end;
	
	local ui = {};
	
	ui.name = name;

	set_object_class(ui, self);

	ui.cm = get_cm();
	ui.lock_func = lock_func;
	ui.unlock_func = unlock_func;
	ui.lock_with_lock_ui = lock_with_lock_ui;

	return ui;
end;


-- sets whether a ui override is allowed or not. It can still be locked, which temporarily disables it.
function ui_override:set_allowed(value, silent)
	self.is_allowed = value;
		
	if value then
		if core:is_ui_created() then
			if not silent then
				out.ui("\t++ Allowing UI override [" .. self.name .. "]");
			end;
			self:unlock(true, silent);
		elseif not silent then
			out.ui("\t++ Allowing UI override [" .. self.name .. "] but not unlocking as ui is not yet initialised");
		end;
	else
		if core:is_ui_created() then
			if not silent then
				out.ui("\t++ Disallowing UI override [" .. self.name .. "]");
			end;
			self:lock(true, silent);
		elseif not silent then
			out.ui("\t++ Disallowing UI override [" .. self.name .. "] but not locking as ui is not yet initialised");
		end;
	end;
end;


function ui_override:get_allowed()
	return self.is_allowed;
end;


-- locks a ui override, turning it off. It will be turned on again if unlocked, assuming that it's allowed.
function ui_override:lock(force, silent, from_lock_ui)
	if not force then
		if self.currently_locked then
			return;
		end;
	end;
	
	-- don't lock if we're locking the whole ui and this override is marked to not lock at this time
	if from_lock_ui and not self.lock_with_lock_ui then
		return;
	end;
	
	self.currently_locked = true;
	
	if not silent then
		out.ui("\t++ Locking UI override [" .. self.name .. "]");
	end;
	
	self.lock_func();
end;


-- unlocks a ui override, turning it on - assuming it's allowed
function ui_override:unlock(force, silent)
	if not force then
		if not self.currently_locked or not self.is_allowed then
			out.ui("\t++ NOT Unlocking UI override: " .. self.name .. ", currently_locked: " .. tostring(self.currently_locked) .. ", is_allowed: " .. tostring(self.is_allowed));
			return;
		end;
	end;
	
	self.currently_locked = false;
	
	if not silent then
		out.ui("\t++ Unlocking UI override [" .. self.name .. "]");
	end;
	
	self.unlock_func();
end;


function ui_override:is_locked()
	return self.currently_locked;
end;







function campaign_ui_manager:load_ui_overrides()
	local cm = self.cm;

	local ui_overrides = {};
	-- list of all ui_overrides:
		-- toggle_movement_speed
		-- toggle_movement_speed
		-- saving
		-- radar_rollout_buttons
		-- incentives
		-- stances
		-- province_details
		-- character_details
		-- force_details
		-- raise_army
		-- replace_general
		-- recruit_units
		-- enlist_agent
		-- recruit_mercenaries
		-- faction_button
		-- missions
		-- finance
		-- technology
		-- rituals
		-- diplomacy
		-- tactical_map
		-- enlist_navy
		-- events_rollout
		-- events_panel
		-- hide_event_zoom_button
		-- end_turn
		-- tax_exemption
		-- autoresolve
		-- autoresolve_for_advice
		-- maintain_siege
		-- prebattle_attack
		-- prebattle_attack_for_advice
		-- cancel_siege_weapons
		-- retreat
		-- dismantle_building
		-- disband_unit
		-- repair_building
		-- cancel_construction
		-- cancel_recruitment
		-- construction_site
		-- cost_display
		-- dismiss_advice_end_turn
		-- campaign_values
		-- toggle_move_speed
		-- end_of_turn_warnings
		-- windowed_movies
		-- upgrade_unit
		-- sally_forth_button
		-- subjugation_button
		-- occupy_button
		-- raze_button
		-- loot_button
		-- sack_button
		-- settlement_renaming
		-- food_display		
		-- abandon_settlements
		-- building_upgrades
		-- non_city_building_upgrades
		-- public_order_display
		-- intrigue_actions
		-- seek_wife
		-- large_info_panels
		-- building_browser
		-- migration
		-- migration_cancel
		-- prebattle_save
		-- resettle
		-- diplomacy_audio
		-- book_of_grudges
		-- offices
		-- grudges
		-- diplomacy_double_click
		-- giving_orders
		-- ping_clicks
		-- spell_browser
		-- advice_settings_button
		-- selection_change
		-- camera_settings
		-- army_panel_help_button
		-- province_overview_panel_help_button
		-- help_page_link_highlighting
		-- intrigue_at_the_court
		-- slaves
		-- geomantic_web
		-- skaven_corruption
		-- garrison_details
		-- end_turn_options
		-- esc_menu
		-- help_panel_button
		-- mortuary_cult
		-- books_of_nagash
		-- regiments_of_renown
		-- sword_of_khaine
		-- army_panel_visible
		-- province_overview_panel_visible
		-- siege_information
		-- technology_with_button_hidden
		-- diplomacy_with_button_hidden
		-- missions_with_button_hidden
		-- offices_with_button_hidden
		-- radar_map
		-- faction_bar
		-- other_factions_with_button_hidden
		-- commandments
		-- end_turn_skip_with_button_hidden
		-- end_turn_previous_with_button_hidden
		-- end_turn_next_with_button_hidden
		-- character_details_with_button_hidden
		-- resources_bar
		-- end_turn_settings_with_button_hidden
		-- stances_with_button_hidden
		-- skills_with_button_hidden
		-- spell_browser_with_button_hidden
		-- advice_with_button_hidden
		-- help_pages_with_button_hidden
		-- occupy_public_order
		-- occupy_conquest
		-- occupy_climate
		-- settlement_panel_help_with_button_hidden
		-- units_panel
		-- units_panel_small_bar
		-- units_panel_small_bar_buttons
		-- units_panel_recruit_with_button_hidden
		-- settlement_panel_small_bar
		-- units_panel_docker
		-- province_panel_corruption
		-- province_panel_effects
		-- province_panel_public_order
		-- province_info_panel
		-- settlement_panel_hero_recruit_with_button_hidden
		-- settlement_panel_lord_recruit_with_button_hidden
		-- settlement_panel_building_browser_with_button_hidden
		-- settlement_panel_garrison_with_button_hidden
		-- settlement_panel_label_corruption
		-- pre_battle_save_with_button_hidden
		-- pre_battle_help_with_button_hidden
		-- pre_battle_general_details_with_button_hidden
		-- pre_battle_rank_with_button_hidden
		-- pre_battle_autoresolve_with_button_hidden
		-- pre_battle_retreat_with_button_hidden
		-- pre_battle_attack_dismiss_with_button_hidden
		-- demolish_with_button_hidden
		-- building_browser_public_order
		-- building_browser_effects
		-- building_browser_corruption
		-- objectives_panel_delete_with_button_hidden
		-- objectives_panel_victory_conditions
		-- siege_turns
		-- prebattle_balance_of_power
		-- treasure_hunt_cursor
		-- terrain_tooltips
		-- mouse_over_info_city_info_bar
		-- undiscovered_faction_flags_on_end_turn
		-- switch_treasure_hunt_cursor
		-- campaign_flags
		-- winds_of_magic
		-- faction_specific_pooled_resource
		-- prebattle_spectate_with_button_hidden
		-- end_turn_notification
		-- movie_viewer_with_button_hidden
		-- spell_and_unit_browser_with_button_hidden
		-- stance_encamp
		-- global_recruitment_stance_checks
		-- prevent_help_panel_docking
		-- prebattle_continue_with_button_hidden
		-- world_space_icons_for_prologue
		-- campaign_flags_strength_bars
		-- allied_recruitment_with_button_hidden
		-- postbattle_kill_captives_with_button_hidden
		-- postbattle_middle_panel
		-- prebattle_middle_panel
		-- hide_diplomacy_region_trading
		-- hide_diplomacy_threaten
		-- hide_diplomacy_war_coordination
		-- hide_diplomacy_trade_ui
		-- hide_character_details_bottom_buttons
		-- hide_character_details_rename
		-- hide_character_details_view_records
		-- disable_building_info_recruitment_effects
		-- hide_campaign_unit_information
		-- disable_replace_faction_leader
		-- finance_help_button
		-- campaign_3d_ui
		-- parchment_overlay
		-- campaign_flags
		-- campaign_flags_strength_bars


		
	-------------------------------
	-- toggle_movement_speed
	-------------------------------
	ui_overrides.toggle_movement_speed = ui_override:new(
		"toggle_movement_speed",
		function()
			cm:disable_shortcut("root", "toggle_movement_speed", true);
		end,
		function()
			cm:disable_shortcut("root", "toggle_movement_speed", false);
		end
	);

	-------------------------------
	-- saving
	-------------------------------
	ui_overrides.saving = ui_override:new(
		"saving",
		function()
			cm:disable_saving_game(true);
		end,
		function()
			cm:disable_saving_game(false);
		end
	);
	
	-------------------------------
	-- radar_rollout_buttons
	-------------------------------
	ui_overrides.radar_rollout_buttons = ui_override:new(
		"radar_rollout_buttons",
		function()
			local ui_root = core:get_ui_root();
			local uic_parent = find_uicomponent(ui_root, "bar_small_top", "TabGroup");
			set_component_active_with_parent(false, uic_parent, "tab_units");
			set_component_active_with_parent(false, uic_parent, "tab_regions");
			set_component_active_with_parent(false, uic_parent, "tab_factions");
			cm:override_ui("disable_events_dropdown_button", true);
			cm:override_ui("disable_missions_dropdown_button", true);
		end,
		function()
			local ui_root = core:get_ui_root();
			local uic_parent = find_uicomponent(ui_root, "bar_small_top", "TabGroup");
			set_component_active_with_parent(true, uic_parent, "tab_units");
			set_component_active_with_parent(true, uic_parent, "tab_regions");
			set_component_active_with_parent(true, uic_parent, "tab_factions");
			cm:override_ui("disable_events_dropdown_button", false);
			cm:override_ui("disable_missions_dropdown_button", false);
		end
	);
	
	-------------------------------
	-- incentives
	-------------------------------
	ui_overrides.incentives = ui_override:new(
		"incentives",
		function()
			cm:override_ui("disable_incentives_stack", true);
		end,
		function()
			cm:override_ui("disable_incentives_stack", false);
		end
	);
	
	-------------------------------
	-- stances
	-------------------------------
	ui_overrides.stances = ui_override:new(
		"stances",
		function()
			cm:override_ui("disable_stances_stack", true);
		end,
		function()
			cm:override_ui("disable_stances_stack", false);
		end
	);
	
	-------------------------------
	-- province_details
	-------------------------------
	ui_overrides.province_details = ui_override:new(
		"province_details",
		function()
			cm:override_ui("disable_province_details", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "info_panel_holder", "button_province_details");
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "info_panel_holder", "button_province_details");
			cm:override_ui("disable_province_details", false);
		end
	);
	
	-------------------------------
	-- character_details
	-------------------------------
	ui_overrides.character_details = ui_override:new(
		"character_details",
		function()
			cm:override_ui("disable_character_details_panel", true);
		end,
		function()
			cm:override_ui("disable_character_details_panel", false);
		end
	);
	
	-------------------------------
	-- force_details
	-------------------------------
	ui_overrides.force_details = ui_override:new(
		"force_details",
		function()
			cm:override_ui("disable_force_details_panel", true);
		end,
		function()
			cm:override_ui("disable_force_details_panel", false);
		end
	);

	-------------------------------
	-- raise_army
	-------------------------------
	ui_overrides.raise_army = ui_override:new(
		"raise_army",
		function()
			cm:override_ui("disable_enlist_general", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_group_settlement", "button_create_army");
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_group_settlement", "button_create_army");
			cm:override_ui("disable_enlist_general", false);
		end
	);
	
	-------------------------------
	-- replace_general
	-------------------------------
	ui_overrides.replace_general = ui_override:new(
		"replace_general",
		function()
			cm:override_ui("disable_replace_general", true);
		end,
		function()
			cm:override_ui("disable_replace_general", false);
		end
	);
	
	-------------------------------
	-- recruit_units
	-------------------------------
	ui_overrides.recruit_units = ui_override:new(
		"recruit_units",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_group_army", "button_recruitment");
			cm:override_ui("disable_recruit_units", true);
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_group_army", "button_recruitment");
			cm:override_ui("disable_recruit_units", false);
		end
	);
	
	-------------------------------
	-- enlist_agent
	-------------------------------
	ui_overrides.enlist_agent = ui_override:new(
		"enlist_agent",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_group_settlement", "button_agents");
			cm:override_ui("disable_enlist_agent", true);
		end,
		function()
			cm:override_ui("disable_enlist_agent", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_group_settlement", "button_agents");
		end
	);
	
	-------------------------------
	-- recruit_mercenaries
	-------------------------------
	ui_overrides.recruit_mercenaries = ui_override:new(
		"recruit_mercenaries",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_group_army", "button_mercenaries");
			cm:override_ui("disable_recruit_mercenaries", true);
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_group_army", "button_mercenaries");
			cm:override_ui("disable_recruit_mercenaries", false);
		end
	);
	
	-------------------------------
	-- faction_button
	-------------------------------
	ui_overrides.faction_button = ui_override:new(
		"faction_button",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_group_management", "button_factions");
			cm:override_ui("disable_clan_button", true);
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_group_management", "button_factions");
			cm:override_ui("disable_clan_button", false);
		end
	);
	
	-------------------------------
	-- missions
	-------------------------------
	ui_overrides.missions = ui_override:new(
		"missions",
		function()
			cm:disable_shortcut("button_missions", "show_objectives", true);
			cm:override_ui("disable_missions_button", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_missions");
		end,
		function()
			cm:disable_shortcut("button_missions", "show_objectives", false);
			cm:override_ui("disable_missions_button", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_missions");
		end
	);
	
	-------------------------------
	-- finance
	-------------------------------
	ui_overrides.finance = ui_override:new(
		"finance",
		function()
			cm:disable_shortcut("button_finance", "show_finance", true);
			cm:override_ui("disable_finance_button", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_finance");
		end,
		function()
			cm:disable_shortcut("button_finance", "show_finance", false)
			cm:override_ui("disable_finance_button", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_finance");
		end
	);
	
	-------------------------------
	-- technology
	-------------------------------
	ui_overrides.technology = ui_override:new(
		"technology",
		function()
			cm:disable_shortcut("button_technology", "show_technologies", true)
			cm:override_ui("disable_tech_button", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_technology");
		end,
		function()
			cm:disable_shortcut("button_technology", "show_technologies", false)
			cm:override_ui("disable_tech_button", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_technology");
		end
	);
	
	-------------------------------
	-- rituals
	-------------------------------
	ui_overrides.rituals = ui_override:new(
		"rituals",
		function()
			cm:override_ui("disable_rituals", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_rituals");
		end,
		function()
			cm:override_ui("disable_rituals", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_rituals");
		end
	);
	
	-------------------------------
	-- diplomacy
	-------------------------------
	ui_overrides.diplomacy = ui_override:new(
		"diplomacy",
		function()
			cm:disable_shortcut("button_diplomacy", "show_diplomacy", true);
			cm:override_ui("disable_diplomacy", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_diplomacy");
		end,
		function()
			cm:disable_shortcut("button_diplomacy", "show_diplomacy", false);
			cm:override_ui("disable_diplomacy", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_diplomacy");
		end
	);
	
	-------------------------------
	-- tactical_map
	-------------------------------
	ui_overrides.tactical_map = ui_override:new(
		"tactical_map",
		function()
			cm:disable_shortcut("camera", "show_tactical_map", true);
			cm:override_ui("disable_campaign_tactical_map", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "bar_small_top", "button_tactical_map");
		end,
		function()
			cm:disable_shortcut("camera", "show_tactical_map", false);
			cm:override_ui("disable_campaign_tactical_map", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "bar_small_top", "button_tactical_map");
		end
	);
	
	-------------------------------
	-- enlist_navy
	-------------------------------
	ui_overrides.enlist_navy = ui_override:new(
		"enlist_navy",
		function()
			cm:override_ui("disable_enlist_navy", true);
		end,
		function()
			cm:override_ui("disable_enlist_navy", false);
		end
	);
	
	-------------------------------
	-- events_rollout
	-------------------------------
	ui_overrides.events_rollout = ui_override:new(
		"events_rollout",
		function()
			local ui_root = core:get_ui_root();
			local uic_events_rollout = find_uicomponent(ui_root, "dropdown_events", "panel");
			if uic_events_rollout then
				if uic_events_rollout:Visible() or uic_events_rollout:CurrentAnimationId() == "show" then
					uic_events_rollout:TriggerAnimation("hide");
				end;
			else
				script_error("Couldn't find uic_events_rollout");
			end;
			
			--cm:override_ui("disable_campaign_dropdowns", true);
			cm:override_ui("disable_events_dropdown_button", true);
		end,
		function()
			-- cm:override_ui("disable_campaign_dropdowns", false);
			cm:override_ui("disable_events_dropdown_button", false);
		end
	);
	
	-------------------------------
	-- events_panel
	-------------------------------
	ui_overrides.events_panel = ui_override:new(
		"events_panel",
		function()
			cm:override_ui("disable_event_panel_auto_open", true);
		end,
		function()
			cm:override_ui("disable_event_panel_auto_open", false);
		end
	);

	-------------------------------
	-- hide_event_zoom_button
	-------------------------------
	ui_overrides.event_zoom_button = ui_override:new(
		"event_zoom_button",
		function()
			cm:override_ui("hide_event_zoom_button", true);
		end,
		function()
			cm:override_ui("hide_event_zoom_button", false);
		end
	);
	
	-------------------------------
	-- end_turn
	-------------------------------
	ui_overrides.end_turn = ui_override:new(
		"end_turn",
		function()
			cm:disable_shortcut("button_end_turn", "end_turn", true);
			cm:override_ui("disable_end_turn", true);
			cm:disable_end_turn(true);
		end,
		function()
			cm:disable_shortcut("button_end_turn", "end_turn", false);
			cm:override_ui("disable_end_turn", false);
			cm:disable_end_turn(false);
		end
	);
	
	-------------------------------
	-- tax_exemption
	-------------------------------
	ui_overrides.tax_exemption = ui_override:new(
		"tax_exemption",
		function()
			set_component_active(false, "province_details_panel", "checkbox_tax_exempt");
			cm:override_ui("disable_tax_exempt", true);
		end,
		function()
			cm:override_ui("disable_tax_exempt", false);
			set_component_active(true, "province_details_panel", "checkbox_tax_exempt");
		end
	);
	
	-------------------------------
	-- autoresolve
	-------------------------------
	ui_overrides.autoresolve = ui_override:new(
		"autoresolve",
		function()
			cm:override_ui("disable_prebattle_autoresolve", true);
		end,
		function()
			-- only actually unlock if the "autoresolve_for_advice" ui override is also unlocked
			if ui_overrides.autoresolve_for_advice:get_allowed() and not ui_overrides.autoresolve_for_advice:is_locked() then
				cm:override_ui("disable_prebattle_autoresolve", false);
			end;
		end
	);
	
	-------------------------------
	-- autoresolve_for_advice
	-------------------------------
	ui_overrides.autoresolve_for_advice = ui_override:new(
		"autoresolve_for_advice",
		function()			
			-- set up a callback to set the tooltip on autoresolve buttons
			local function set_autoresolve_button_tooltip()
				local ui_root = core:get_ui_root();
				
				-- button_set_siege
				local uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_siege", "button_autoresolve");
				if uic_button then
					core:cache_and_set_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
				end;
				
				-- button_set_attack
				uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_attack", "button_autoresolve");
				if uic_button then
					core:cache_and_set_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
				end;
			end;
			
			-- call callback immediately
			set_autoresolve_button_tooltip();
			
			-- call callback again if pre-battle panel opened
			core:add_listener(
				"autoresolve_for_advice_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					set_autoresolve_button_tooltip();
				end,
				true			
			);
			
		end,
		function()
			-- only actually unlock if the "autoresolve" ui override is also unlocked
			if ui_overrides.autoresolve:get_allowed() and not ui_overrides.autoresolve:is_locked() then
				cm:override_ui("disable_prebattle_autoresolve", false);
			end;
			
			-- restore the tooltips on the buttons
			local ui_root = core:get_ui_root();
			
			-- button_set_siege
			local uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_siege", "button_autoresolve");
			if uic_button then
				core:restore_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
			end;
			
			-- button_set_attack
			uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_attack", "button_autoresolve");
			if uic_button then
				core:restore_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
			end;
			
			core:remove_listener("autoresolve_for_advice_ui_override");
		end
	);
	
	-------------------------------
	-- maintain_siege
	-------------------------------
	ui_overrides.maintain_siege = ui_override:new(
		"maintain_siege",
		function()
			cm:override_ui("disable_prebattle_continue", true);
			
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "button_set_siege", "button_continue_siege");
			set_component_active_with_parent(false, ui_root, "button_set_attack", "button_maintain_blockade");
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "button_set_attack", "button_maintain_blockade");
			set_component_active_with_parent(true, ui_root, "button_set_siege", "button_continue_siege");
			
			cm:override_ui("disable_prebattle_continue", false);
		end
	);
	
	-------------------------------
	-- prebattle_attack
	-------------------------------
	ui_overrides.prebattle_attack = ui_override:new(
		"prebattle_attack",
		function()
			cm:override_ui("disable_prebattle_attack", true);
		end,
		function()
			cm:override_ui("disable_prebattle_attack", false);
		end
	);
	
	-------------------------------
	-- prebattle_attack_for_advice
	-------------------------------
	ui_overrides.prebattle_attack_for_advice = ui_override:new(
		"prebattle_attack_for_advice",
		function()
			cm:override_ui("disable_prebattle_attack", true);
			
			-- set up a callback to set the tooltip on autoresolve buttons
			local function set_attack_button_tooltip()
				local ui_root = core:get_ui_root();
				
				-- button_set_siege
				local uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_siege", "button_attack");
				if uic_button then
					core:cache_and_set_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
				end;
				
				-- button_set_attack
				uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_attack", "button_attack");
				if uic_button then
					core:cache_and_set_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
				end;
			end;
			
			-- call callback immediately
			set_attack_button_tooltip();
			
			-- call callback again if pre-battle panel opened
			core:add_listener(
				"attack_for_advice_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					set_attack_button_tooltip();
				end,
				true			
			);
		end,
		function()
			cm:override_ui("disable_prebattle_attack", false);
			
			-- restore the tooltips on the buttons
			local ui_root = core:get_ui_root();
			
			-- button_set_siege
			local uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_siege", "button_attack");
			if uic_button then
				core:restore_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
			end;
			
			-- button_set_attack
			uic_button = find_uicomponent(ui_root, "popup_pre_battle", "mid", "regular_deployment", "button_set_attack", "button_attack");
			if uic_button then
				core:restore_tooltip_for_component_state(uic_button, "inactive", "campaign_localised_strings_string_attack_button_locked_for_advice");
			end;
			
			core:remove_listener("attack_for_advice_ui_override");
		end
	);
	
	-------------------------------
	-- cancel_siege_weapons
	-------------------------------
	ui_overrides.cancel_siege_weapons = ui_override:new(
		"cancel_siege_weapons",
		function()
			cm:override_ui("disable_cancel_siege_equipment", true);
		end,
		function()
			cm:override_ui("disable_cancel_siege_equipment", false);
		end
	);
	
	-------------------------------
	-- retreat
	-------------------------------
	ui_overrides.retreat = ui_override:new(
		"retreat",
		function()
			-- override disabled - if uncommenting for future projects, have the UI guys add a listener for when the override gets switched so they can
			-- recalculate the state of the retreat button rather than us setting it directly (script calls that previously did this have been removed)
			cm:override_ui("disable_prebattle_retreat", true);
		end,
		function()
			cm:override_ui("disable_prebattle_retreat", false);
		end
	);
	
	-------------------------------
	-- dismantle_building
	-------------------------------
	ui_overrides.dismantle_building = ui_override:new(
		"dismantle_building",
		function()
			cm:override_ui("disable_dismantle_building", true);
		end,
		function()
			cm:override_ui("disable_dismantle_building", false);
		end
	);
	
	-------------------------------
	-- disband_unit
	-------------------------------
	ui_overrides.disband_unit = ui_override:new(
		"disband_unit",
		function()
			cm:override_ui("disable_disband_unit", true);
		end,
		function()
			cm:override_ui("disable_disband_unit", false);
		end
	);
	
	-------------------------------
	-- repair_building
	-------------------------------
	ui_overrides.repair_building = ui_override:new(
		"repair_building",
		function()
			cm:override_ui("disable_repair_building", true);
		end,
		function()
			cm:override_ui("disable_repair_building", false);
		end
	);
	
	-------------------------------
	-- cancel_construction
	-------------------------------
	ui_overrides.cancel_construction = ui_override:new(
		"cancel_construction",
		function()
			cm:override_ui("disable_cancel_construction", true);
		end,
		function()
			cm:override_ui("disable_cancel_construction", false);
		end
	);
	
	-------------------------------
	-- cancel_recruitment
	-------------------------------
	ui_overrides.cancel_recruitment = ui_override:new(
		"cancel_recruitment",
		function()
			cm:override_ui("disable_cancel_recruitment", true);
		end,
		function()
			cm:override_ui("disable_cancel_recruitment", false);
		end
	);
	
	-------------------------------
	-- construction_site
	-------------------------------
	ui_overrides.construction_site = ui_override:new(
		"construction_site",
		function()
			cm:override_ui("disable_construction_site", true);
		end,
		function()
			cm:override_ui("disable_construction_site", false);
		end
	);
	
	-------------------------------
	-- cost_display
	-------------------------------
	ui_overrides.cost_display = ui_override:new(
		"cost_display",
		function()
			cm:override_ui("disable_cost_display", true);
		end,
		function()
			cm:override_ui("disable_cost_display", false);
		end,
		false
	);
	
	-------------------------------
	-- dismiss_advice_end_turn
	-------------------------------
	ui_overrides.dismiss_advice_end_turn = ui_override:new(
		"dismiss_advice_end_turn",
		function()
			cm:override_ui("disable_dismiss_advice_end_turn", true);
		end,
		function()
			cm:override_ui("disable_dismiss_advice_end_turn", false);
		end,
		false
	);
	
	-------------------------------
	-- campaign_values
	-------------------------------
	--[[
	ui_overrides.campaign_values = ui_override:new(
		"campaign_values",
		function()
			local ui_root = core:get_ui_root();
			set_component_visible(false, "resources_bar", "treasury");
			set_component_visible(false, "resources_bar", "income");
			set_component_visible(false, "resources_bar", "food");
			set_component_visible(false, "resources_bar", "end_turn_date");
		end,
		function()
			set_component_visible(true, "resources_bar", "end_turn_date");
			set_component_visible(true, "resources_bar", "food");
			set_component_visible(true, "resources_bar", "income");
			set_component_visible(true, "resources_bar", "treasury");
		end,
		false
	);
	]]
	
	-------------------------------
	-- toggle_move_speed
	-------------------------------
	ui_overrides.toggle_move_speed = ui_override:new(
		"toggle_move_speed",
		function()
			cm:disable_shortcut("root", "toggle_move_speed", true);
		end,
		function()
			cm:disable_shortcut("root", "toggle_move_speed", false);
		end
	);
		
	-------------------------------
	-- end_of_turn_warnings
	-------------------------------
	ui_overrides.end_of_turn_warnings = ui_override:new(
		"end_of_turn_warnings",
		function()
			cm:override_ui("disable_end_of_turn_warnings", true);
		end,
		function()
			cm:override_ui("disable_end_of_turn_warnings", false);
		end
	);
	
	-------------------------------
	-- windowed_movies
	-------------------------------
	ui_overrides.windowed_movies = ui_override:new(
		"windowed_movies",
		function()
			cm:override_ui("disable_windowed_movies", true);
		end,
		function()
			cm:override_ui("disable_windowed_movies", false);
		end
	);
	
	-------------------------------
	-- upgrade_unit
	-------------------------------
	ui_overrides.upgrade_unit = ui_override:new(
		"upgrade_unit",
		function()
			cm:override_ui("disable_upgrade_unit", true);
		end,
		function()
			cm:override_ui("disable_upgrade_unit", false);
		end
	);
	
	-------------------------------
	-- sally_forth_button
	-------------------------------
	ui_overrides.sally_forth_button = ui_override:new(
		"sally_forth_button",
		function()
			cm:override_ui("disable_sally_forth_button", true);
		end,
		function()
			cm:override_ui("disable_sally_forth_button", false);
		end
	);
		
	-------------------------------
	-- subjugation_button
	-------------------------------
	ui_overrides.subjugation_button = ui_override:new(
		"subjugation_button",
		function()
			cm:override_ui("disable_postbattle_subjugation_button", true);
		end,
		function()
			cm:override_ui("disable_postbattle_subjugation_button", false);
		end
	);
	
	-------------------------------
	-- occupy_button
	-------------------------------
	ui_overrides.occupy_button = ui_override:new(
		"occupy_button",
		function()
			cm:override_ui("disable_postbattle_occupy_button", true);
		end,
		function()
			cm:override_ui("disable_postbattle_occupy_button", false);
		end
	);
	
	-------------------------------
	-- raze_button
	-------------------------------
	ui_overrides.raze_button = ui_override:new(
		"raze_button",
		function()
			cm:override_ui("disable_postbattle_raze_button", true);
		end,
		function()
			cm:override_ui("disable_postbattle_raze_button", false);
		end
	);
	
	-------------------------------
	-- loot_button
	-------------------------------
	ui_overrides.loot_button = ui_override:new(
		"loot_button",
		function()
			cm:override_ui("disable_postbattle_loot_button", true);
		end,
		function()
			cm:override_ui("disable_postbattle_loot_button", false);
		end
	);
	
	-------------------------------
	-- sack_button
	-------------------------------
	ui_overrides.sack_button = ui_override:new(
		"sack_button",
		function()
			cm:override_ui("disable_postbattle_sack_button", true);
		end,
		function()
			cm:override_ui("disable_postbattle_sack_button", false);
		end
	);
	
	-------------------------------
	-- settlement_renaming
	-------------------------------
	ui_overrides.settlement_renaming = ui_override:new(
		"settlement_renaming",
		function()
			cm:override_ui("disable_settlement_renaming", true);
		end,
		function()
			cm:override_ui("disable_settlement_renaming", false);
		end
	);
	
	-------------------------------
	-- food_display
	-------------------------------
	ui_overrides.food_display = ui_override:new(
		"food_display",
		function()
			cm:override_ui("disable_food_display", true);
		end,
		function()
			cm:override_ui("disable_food_display", false);
		end,
		false
	);
	
	-------------------------------
	-- abandon_settlements
	-------------------------------
	ui_overrides.abandon_settlements = ui_override:new(
		"abandon_settlements",
		function()
			cm:override_ui("disable_abandon_settlements", true);
		end,
		function()
			cm:override_ui("disable_abandon_settlements", false);
		end
	);
	
	-------------------------------
	-- building_upgrades
	-------------------------------
	ui_overrides.building_upgrades = ui_override:new(
		"building_upgrades",
		function()
			cm:override_ui("disable_building_upgrades", true);
		end,
		function()
			cm:override_ui("disable_building_upgrades", false);
		end
	);
	
	-------------------------------
	-- non_city_building_upgrades
	-------------------------------
	ui_overrides.non_city_building_upgrades = ui_override:new(
		"non_city_building_upgrades",
		function()
			cm:override_ui("disable_non_city_building_upgrades", true);
		end,
		function()
			cm:override_ui("disable_non_city_building_upgrades", false);
		end
	);

	
	-------------------------------
	-- public_order_display
	-------------------------------
	ui_overrides.public_order_display = ui_override:new(
		"public_order_display",
		function()
			cm:override_ui("disable_public_order_display", true);
		end,
		function()
			cm:override_ui("disable_public_order_display", false);
		end,
		false
	);
	
	-------------------------------
	-- intrigue_actions
	-------------------------------
	ui_overrides.intrigue_actions = ui_override:new(
		"intrigue_actions",
		function()
			cm:override_ui("disable_intrigue_actions", true);
		end,
		function()
			cm:override_ui("disable_intrigue_actions", false);
		end
	);
	
	-------------------------------
	-- seek_wife
	-------------------------------
	ui_overrides.seek_wife = ui_override:new(
		"seek_wife",
		function()
			cm:override_ui("disable_seek_wife", true);
		end,
		function()
			cm:override_ui("disable_seek_wife", false);
		end
	);
	
	-------------------------------
	-- large_info_panels
	-------------------------------
	ui_overrides.large_info_panels = ui_override:new(
		"large_info_panels",
		function()
			cm:override_ui("disable_large_info_panels", true);
		end,
		function()
			cm:override_ui("disable_large_info_panels", false);
		end,
		false
	);
	
	-------------------------------
	-- building_browser
	-------------------------------
	ui_overrides.building_browser = ui_override:new(
		"building_browser",
		function()
			cm:override_ui("disable_building_browser", true);
		end,
		function()
			cm:override_ui("disable_building_browser", false);
		end
	);
	
	-------------------------------
	-- migration
	-------------------------------
	ui_overrides.migration = ui_override:new(
		"migration",
		function()
			cm:override_ui("disable_migrate_button", true);
		end,
		function()
			cm:override_ui("disable_migrate_button", false);
		end
	);
	
	-------------------------------
	-- migration_cancel
	-------------------------------
	ui_overrides.migration_cancel = ui_override:new(
		"migration_cancel",
		function()
			cm:override_ui("disable_cancel_migration", true);
		end,
		function()
			cm:override_ui("disable_cancel_migration", false);
		end
	);
	
	-------------------------------
	-- prebattle_save
	-------------------------------
	ui_overrides.prebattle_save = ui_override:new(
		"prebattle_save",
		function()
			cm:override_ui("disable_prebattle_save", true);
		end,
		function()
			cm:override_ui("disable_prebattle_save", false);
		end
	);
	
	-------------------------------
	-- resettle
	-------------------------------
	ui_overrides.resettle = ui_override:new(
		"resettle",
		function()
			cm:override_ui("disable_resettle", true);
		end,
		function()
			cm:override_ui("disable_resettle", false);
		end
	);
	
	-------------------------------
	-- diplomacy_audio
	-------------------------------
	ui_overrides.diplomacy_audio = ui_override:new(
		"diplomacy_audio",
		function()
			cm:override_ui("disable_diplomacy_audio", true);
		end,
		function()
			cm:override_ui("disable_diplomacy_audio", false);
		end
	);
	
	-------------------------------
	-- book_of_grudges
	-------------------------------
	ui_overrides.book_of_grudges = ui_override:new(
		"book_of_grudges",
		function()
			set_component_active(false, "faction_buttons_docker", "button_grudges");
		end,
		function()
			set_component_active(true, "faction_buttons_docker", "button_grudges");
		end
	);
	
	-------------------------------
	-- offices
	-------------------------------
	ui_overrides.offices = ui_override:new(
		"offices",
		function()
			set_component_active(false, "faction_buttons_docker", "button_offices");
			cm:override_ui("disable_office_button", true);
		end,
		function()
			cm:override_ui("disable_office_button", false);
			set_component_active(true, "faction_buttons_docker", "button_offices");
		end
	);
	
	-------------------------------
	-- grudges
	-------------------------------
	ui_overrides.grudges = ui_override:new(
		"grudges",
		function()
			set_component_active(false, "faction_buttons_docker", "button_grudges");
			cm:override_ui("disable_grudge_button", true);
		end,
		function()
			cm:override_ui("disable_grudge_button", false);
			set_component_active(true, "faction_buttons_docker", "button_grudges");
		end
	);
	
	-------------------------------
	-- diplomacy_double_click
	-------------------------------
	ui_overrides.diplomacy_double_click = ui_override:new(
		"diplomacy_double_click",
		function()
			cm:override_ui("disable_diplomacy_double_click", true);
		end,
		function()
			cm:override_ui("disable_diplomacy_double_click", false);
		end
	);
	
	-------------------------------
	-- giving_orders
	-------------------------------
	ui_overrides.giving_orders = ui_override:new(
		"giving_orders",
		function()
			cm:override_ui("disable_giving_orders", true);
		end,
		function()
			cm:override_ui("disable_giving_orders", false);
		end
	);
	
	-------------------------------
	-- ping_clicks
	-------------------------------
	ui_overrides.ping_clicks = ui_override:new(
		"ping_clicks",
		function()
			cm:override_ui("disable_ping_clicks", true);
		end,
		function()
			cm:override_ui("disable_ping_clicks", false);
		end
	);
	
	-------------------------------
	-- spell_browser
	-------------------------------
	ui_overrides.spell_browser = ui_override:new(
		"spell_browser",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "menu_bar", "button_spell_browser");
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "menu_bar", "button_spell_browser");
		end
	);
	
	-------------------------------
	-- advice_settings_button
	-------------------------------
	ui_overrides.advice_settings_button = ui_override:new(
		"advice_settings_button",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "advice_interface", "button_toggle_options");
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "advice_interface", "button_toggle_options");
		end
	);
	
	-------------------------------
	-- selection_change
	-------------------------------
	ui_overrides.selection_change = ui_override:new(
		"selection_change",
		function()
			cm:override_ui("disable_selection_change", true);
		end,
		function()
			cm:override_ui("disable_selection_change", false);
		end
	);
	
	-------------------------------
	-- camera_settings
	-------------------------------
	ui_overrides.camera_settings = ui_override:new(
		"camera_settings",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "menu_bar", "button_settings");
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "menu_bar", "button_settings");
		end
	);
	
	-------------------------------
	-- army_panel_help_button
	-------------------------------
	ui_overrides.army_panel_help_button = ui_override:new(
		"army_panel_help_button",
		function()
			local disable_func = function()
				-- disable the ? button on the army panel
				local uic_main_units_panel = find_uicomponent(core:get_ui_root(), "main_units_panel");
				if uic_main_units_panel then
					local uic_info_button = find_child_uicomponent(uic_main_units_panel, "button_info");
					if uic_info_button then
						uic_info_button:SetState("inactive");
					end;
					
					-- also disable the ? button on the recruitment panel
					uic_info_button = find_uicomponent(uic_main_units_panel, "recruitment_options", "button_info");
					if uic_info_button then
						uic_info_button:SetState("inactive");
					end;
				end;
			end;
		
			disable_func();
			core:add_listener(
				"ui_override_army_panel_help_button",
				"PanelOpenedCampaign",
				function(context) return context.string == "units_panel" end,
				function()
					disable_func()
				end,
				true
			);
		end,
		function()
			core:remove_listener("ui_override_army_panel_help_button");
			
			
			-- enable the ? button on the army panel
			local uic_main_units_panel = find_uicomponent(core:get_ui_root(), "main_units_panel");
			if uic_main_units_panel then
				local uic_info_button = find_child_uicomponent(uic_main_units_panel, "button_info");
				if uic_info_button then
					uic_info_button:SetState("active");
				end;
				
				-- also disable the ? button on the recruitment panel
				uic_info_button = find_uicomponent(uic_main_units_panel, "recruitment_options", "button_info");
				if uic_info_button then
					uic_info_button:SetState("active");
				end;
			end;
		end
	);
	
	-------------------------------
	-- pre_battle_panel_help_button
	-------------------------------
	ui_overrides.pre_battle_panel_help_button = ui_override:new(
		"pre_battle_panel_help_button",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment", "button_info");
			core:add_listener(
				"ui_override_pre_battle_panel_help_button",
				"PanelOpenedCampaign",
				function(context) return context.string == "popup_pre_battle" end,
				function() set_component_active_with_parent(false, core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment", "button_info") end,
				true
			);
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment", "button_info");
			core:remove_listener("ui_override_pre_battle_panel_help_button");
		end
	);
	
	-------------------------------
	-- province_overview_panel_help_button
	-------------------------------
	ui_overrides.province_overview_panel_help_button = ui_override:new(
		"province_overview_panel_help_button",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "settlement_panel", "button_info");
			core:add_listener(
				"ui_override_province_overview_panel_help_button",
				"PanelOpenedCampaign",
				function(context) return context.string == "settlement_panel" end,
				function() set_component_active_with_parent(false, core:get_ui_root(), "settlement_panel", "button_info") end,
				true
			);
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "settlement_panel", "button_info");
			core:remove_listener("ui_override_province_overview_panel_help_button");
		end
	);
	
	-------------------------------
	-- help_page_link_highlighting
	-------------------------------
	ui_overrides.help_page_link_highlighting = ui_override:new(
		"help_page_link_highlighting",
		function()
			self.help_page_link_highlighting_permitted = false;
		end,
		function()
			self.help_page_link_highlighting_permitted = true;
		end
	);
	
	-------------------------------
	-- intrigue_at_the_court
	-------------------------------
	ui_overrides.intrigue_at_the_court = ui_override:new(
		"intrigue_at_the_court",
		function()
			cm:override_ui("disable_intrigue_at_the_court", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_intrigue");
		end,
		function()
			cm:override_ui("disable_intrigue_at_the_court", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_intrigue");
		end
	);
	
	-------------------------------
	-- slaves
	-------------------------------
	ui_overrides.slaves = ui_override:new(
		"slaves",
		function()
			cm:override_ui("disable_slaves", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_slaves");
		end,
		function()
			cm:override_ui("disable_slaves", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_slaves");
		end
	);
	
	-------------------------------
	-- geomantic_web
	-------------------------------
	ui_overrides.geomantic_web = ui_override:new(
		"geomantic_web",
		function()
			cm:override_ui("disable_geomantic_web", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_geomantic_web");
		end,
		function()
			cm:override_ui("disable_geomantic_web", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_geomantic_web");
		end
	);
	
	-------------------------------
	-- skaven_corruption
	-------------------------------
	ui_overrides.skaven_corruption = ui_override:new(
		"skaven_corruption",
		function()
			cm:override_ui("disable_skaven_corruption", true);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_skaven_corruption");
		end,
		function()
			cm:override_ui("disable_skaven_corruption", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_skaven_corruption");
		end
	);
	
	-------------------------------
	-- garrison_details
	-------------------------------
	ui_overrides.garrison_details = ui_override:new(
		"garrison_details",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "hud_center", "small_bar", "button_group_settlement", "button_show_garrison");
			cm:override_ui("disable_garrison_details", true);
		end,
		function()
			cm:override_ui("disable_garrison_details", false);
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "hud_center", "small_bar", "button_group_settlement", "button_show_garrison");
		end
	);
	
	-------------------------------
	-- end_turn_options
	-------------------------------
	ui_overrides.end_turn_options = ui_override:new(
		"end_turn_options",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "faction_buttons_docker", "button_notification_settings");
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "faction_buttons_docker", "button_notification_settings");
		end
	);
	
	-------------------------------
	-- esc_menu
	-------------------------------
	ui_overrides.esc_menu = ui_override:new(
		"esc_menu",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "menu_bar", "button_menu");
			cm:disable_shortcut("root", "escape_menu", true);
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "menu_bar", "button_menu");
			cm:disable_shortcut("root", "escape_menu", false);
		end
	);
	
	-------------------------------
	-- help_panel_button
	-------------------------------
	ui_overrides.help_panel_button = ui_override:new(
		"help_panel_button",
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(false, ui_root, "menu_bar", "button_help_panel");
			
			-- hide the panel
			get_help_page_manager():hide_panel();
		end,
		function()
			local ui_root = core:get_ui_root();
			set_component_active_with_parent(true, ui_root, "menu_bar", "button_help_panel");
		end
	);
	
	-------------------------------
	-- mortuary_cult
	-------------------------------
	ui_overrides.mortuary_cult = ui_override:new(
		"mortuary_cult",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "faction_buttons_docker", "button_mortuary_cult");
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "faction_buttons_docker", "button_mortuary_cult");
		end
	);
	
	-------------------------------
	-- books_of_nagash
	-------------------------------
	ui_overrides.books_of_nagash = ui_override:new(
		"books_of_nagash",
		function()
			set_component_active_with_parent(false, core:get_ui_root(), "resources_bar", "right_spacer_tomb_kings", "button_books_of_nagash");
		end,
		function()
			set_component_active_with_parent(true, core:get_ui_root(), "resources_bar", "right_spacer_tomb_kings", "button_books_of_nagash");
		end
	);
	
	-------------------------------
	-- regiments_of_renown
	-------------------------------
	ui_overrides.regiments_of_renown = ui_override:new(
		"regiments_of_renown",
		function()
			cm:override_ui("disable_renown_button", true);
		end,
		function()
			cm:override_ui("disable_renown_button", false);
		end
	);

	-------------------------------
	-- regiments_of_renown_visible
	-------------------------------
	ui_overrides.regiments_of_renown_visible = ui_override:new(
		"regiments_of_renown_visible",
		function()
			cm:override_ui("hide_renown_button", true)

			core:add_listener(
			"regiments_of_renown_visible_ui_override",
			"PanelOpenedCampaign",
			function(context) return context.string == "units_panel" end,
			function()
				cm:override_ui("hide_renown_button", true)
			end,
			true
		);

		end,
		function()
			cm:override_ui("hide_renown_button", false)
			core:remove_listener("regiments_of_renown_visible_ui_override")
		
		end
	);
	
	-------------------------------
	-- sword_of_khaine
	-------------------------------
	ui_overrides.sword_of_khaine = ui_override:new(
		"sword_of_khaine",
		function()
			set_component_visible_with_parent(false, core:get_ui_root(), "faction_buttons_docker", "sword_of_khaine");
		end,
		function()
			-- set_component_visible_with_parent(true, core:get_ui_root(), "faction_buttons_docker", "sword_of_khaine");
			
			-- the sword of khaine button script can re-initialise the button
			core:trigger_event("ScriptEventInitiateSwordButton");
		end
	);
	
	-------------------------------
	-- army_panel_visible
	-------------------------------
	ui_overrides.army_panel_visible = ui_override:new(
		"army_panel_visible",
		function()
			if self:is_panel_open("units_panel") then
				set_component_visible_with_parent(false, core:get_ui_root(), "units_panel");
				set_component_visible_with_parent(false, core:get_ui_root(), "hud_center_docker");
			end;
			
			core:add_listener(
				"army_panel_visible_ui_override",
				"PanelOpenedCampaign",
				function(context) return context.string == "units_panel" end,
				function(context)
					set_component_visible_with_parent(false, core:get_ui_root(), "units_panel");
					set_component_visible_with_parent(false, core:get_ui_root(), "hud_center_docker");
				end,
				true
			);
			
			core:add_listener(
				"army_panel_visible_ui_override",
				"PanelOpenedCampaign",
				function(context) return context.string == "settlement_panel" end,
				function(context)
					if not self:override("province_overview_panel_visible"):is_locked() then
						set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker");
					end;
				end,
				true
			);
		end,
		function()
			if uim:is_panel_open("units_panel") then
				set_component_visible_with_parent(true, core:get_ui_root(), "units_panel");
				set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker");
			end;
			core:remove_listener("army_panel_visible_ui_override");
		end
	);
	
	-------------------------------
	-- province_overview_panel_visible
	-------------------------------
	ui_overrides.province_overview_panel_visible = ui_override:new(
		"province_overview_panel_visible",
		function()
			if self:is_panel_open("settlement_panel") then
				set_component_visible_with_parent(false, core:get_ui_root(), "settlement_panel");
				set_component_visible_with_parent(false, core:get_ui_root(), "hud_center_docker");
			end;
			
			core:add_listener(
				"province_overview_panel_visible_ui_override",
				"PanelOpenedCampaign",
				function(context) return context.string == "settlement_panel" end,
				function(context)
					set_component_visible_with_parent(false, core:get_ui_root(), "settlement_panel");
					set_component_visible_with_parent(false, core:get_ui_root(), "hud_center_docker");
				end,
				true
			);
			
			core:add_listener(
				"province_overview_panel_visible_ui_override",
				"PanelOpenedCampaign",
				function(context) return context.string == "units_panel" end,
				function(context)
					if not self:override("army_panel_visible"):is_locked() then
						set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker");
					end;
				end,
				true
			);
		end,
		function()
			if uim:is_panel_open("settlement_panel") then
				set_component_visible_with_parent(true, core:get_ui_root(), "settlement_panel");
				set_component_visible_with_parent(true, core:get_ui_root(), "hud_center_docker");
			end;
			core:remove_listener("province_overview_panel_visible_ui_override");
		end
	);

	-------------------------------
	-- siege_information
	-------------------------------
	ui_overrides.siege_information = ui_override:new(
		"siege_information",
		function()
			cm:override_ui("disable_siege_information", true);
		end,
		function()
			cm:override_ui("disable_siege_information", false);
		end
	);
	
	-------------------------------
	-- technology_with_button_hidden
	-------------------------------
	ui_overrides.technology_with_button_hidden = ui_override:new(
		"technology_with_button_hidden",
		function()
			cm:override_ui("hide_technology_button", true);
		end,
		function()
			cm:override_ui("hide_technology_button", false);
		end
	);

	-------------------------------
	-- diplomacy_with_button_hidden
	-------------------------------
	ui_overrides.diplomacy_with_button_hidden = ui_override:new(
		"diplomacy_with_button_hidden",
		function()
			cm:override_ui("hide_diplomacy_button", true);
			uim:override("diplomacy"):set_allowed(false);
		end,
		function()
			cm:override_ui("hide_diplomacy_button", false);
			uim:override("diplomacy"):set_allowed(true);
		end
	);
	

	-------------------------------
	-- missions_with_button_hidden
	-------------------------------
	ui_overrides.missions_with_button_hidden = ui_override:new(
		"missions_with_button_hidden",
		function()
			cm:override_ui("hide_missions_button", true);
		end,
		function()
			cm:override_ui("hide_missions_button", false);
		end
	);
	
	-------------------------------
	-- offices_with_button_hidden
	-------------------------------
	ui_overrides.offices_with_button_hidden = ui_override:new(
		"offices_with_button_hidden",
		function()
			cm:override_ui("hide_offices_button", true);
		end,
		function()
			cm:override_ui("hide_offices_button", false);
		end
	);
	
	-------------------------------
	-- hide_rituals
	-------------------------------
	ui_overrides.hide_rituals = ui_override:new(
		"hide_rituals",
		function()
			cm:override_ui("hide_rituals_button", true);
		end,
		function()
			cm:override_ui("hide_rituals_button", false);
		end
	);

	-------------------------------
	-- radar_map
	-------------------------------
	ui_overrides.radar_map = ui_override:new(
		"radar_map",
		function()
			cm:override_ui("hide_radar", true);
		end,
		function()
			cm:override_ui("hide_radar", false);
		end
	);

	-------------------------------
	-- faction_bar
	-------------------------------
	ui_overrides.faction_bar = ui_override:new(
		"faction_bar",
		function()
			cm:override_ui("hide_faction_bar_buttons", true);
		end,
		function()
			cm:override_ui("hide_faction_bar_buttons", false);
		end
	);
	
	-------------------------------
	-- other_factions_with_button_hidden
	-------------------------------
	ui_overrides.other_factions_with_button_hidden = ui_override:new(
		"other_factions_with_button_hidden",
		function()
			cm:override_ui("hide_faction_bar_other_factions_button", true);
		end,
		function()
			cm:override_ui("hide_faction_bar_other_factions_button", false);
		end
	);
	
	------------------------------
	-- regions_with_button_hidden
	-------------------------------
	ui_overrides.regions_with_button_hidden = ui_override:new(
		"regions_with_button_hidden",
		function()
			cm:override_ui("hide_faction_bar_regions_button", true);
		end,
		function()
			cm:override_ui("hide_faction_bar_regions_button", false);
		end
	);
	
	------------------------------
	-- lords_with_button_hidden
	-------------------------------
	ui_overrides.lords_with_button_hidden = ui_override:new(
		"lords_with_button_hidden",
		function()
			cm:override_ui("hide_faction_bar_lords_button", true);
		end,
		function()
			cm:override_ui("hide_faction_bar_lords_button", false);
		end
	);
	
	-------------------------------
	-- commandments
	-------------------------------
	ui_overrides.commandments = ui_override:new(
		"commandments",
		function()
			cm:override_ui("hide_commandments_button", true);
			
			-- set up a PanelOpenedCampaign listener and reapply the override once the panel is opened
			core:add_listener(
				"hide_commandments_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:callback(
						function() 
							cm:override_ui("hide_commandments_button", true);
						end, 
						0.1
					);
				end,
				true
			);
		end,
		function()
			cm:override_ui("hide_commandments_button", false);
			core:remove_listener("hide_commandments_ui_override")
		end
	);
	
	-------------------------------
	-- end_turn_skip_with_button_hidden
	-------------------------------
	ui_overrides.end_turn_skip_with_button_hidden = ui_override:new(
		"end_turn_skip_with_button_hidden",
		function()
			cm:override_ui("hide_end_turn_skip_button", true);
			set_component_visible_with_parent(false, core:get_ui_root(), "faction_buttons_docker", "button_skip_frame");
		end,
		function()
			cm:override_ui("hide_end_turn_skip_button", false);
			set_component_visible_with_parent(true, core:get_ui_root(), "faction_buttons_docker", "button_skip_frame");
		end
	);
	
	-------------------------------
	-- end_turn_previous_with_button_hidden
	-------------------------------
	ui_overrides.end_turn_previous_with_button_hidden = ui_override:new(
		"end_turn_previous_with_button_hidden",
		function()
			cm:override_ui("hide_end_turn_previous_button", true);
		end,
		function()
			cm:override_ui("hide_end_turn_previous_button", false);
		end
	);
	
	-------------------------------
	-- end_turn_next_with_button_hidden
	-------------------------------
	ui_overrides.end_turn_next_with_button_hidden = ui_override:new(
		"end_turn_next_with_button_hidden",
		function()
			cm:override_ui("hide_end_turn_next_button", true);
		end,
		function()
			cm:override_ui("hide_end_turn_next_button", false);
		end
	);
	
	-------------------------------
	-- character_details_with_button_hidden
	-------------------------------
	ui_overrides.character_details_with_button_hidden = ui_override:new(
		"character_details_with_button_hidden",
		function()
			cm:override_ui("hide_character_details_button", true);
			
			-- set up a PanelOpenedCampaign listener and reapply the override once the panel is opened
			core:add_listener(
				"hide_character_details_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_character_details_button", true);
				end,
				true
			);
		end,
		function()
			cm:override_ui("hide_character_details_button", false);
			core:remove_listener("hide_character_details_ui_override");
		end
	);
	
	-------------------------------
	-- resources_bar
	-------------------------------
	ui_overrides.resources_bar = ui_override:new(
		"resources_bar",
		function()
			cm:override_ui("hide_resources_bar", true);
			
			-- set up a PanelOpenedCampaign listener and reapply the override once the panel is opened
			core:add_listener(
				"hide_resources_bar_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "resources_bar" 
				end,
				function()
					cm:override_ui("hide_resources_bar", true);
				end,
				true
			);
		end,
		function()
			cm:override_ui("hide_resources_bar", false);
			core:remove_listener("hide_resources_bar_ui_override");
		end
	);
	
	-------------------------------
	-- end_turn_settings_with_button_hidden
	-------------------------------
	ui_overrides.end_turn_settings_with_button_hidden = ui_override:new(
		"end_turn_settings_with_button_hidden",
		function()
			cm:override_ui("hide_end_turn_settings_button", true);
			set_component_visible_with_parent(false, core:get_ui_root(), "faction_buttons_docker", "button_notification_settings_frame");
		end,
		function()
			cm:override_ui("hide_end_turn_settings_button", false);
			set_component_visible_with_parent(true, core:get_ui_root(), "faction_buttons_docker", "button_notification_settings_frame");
		end
	);
	
	-------------------------------
	-- stances_with_button_hidden
	-------------------------------
	ui_overrides.stances_with_button_hidden = ui_override:new(
		"stances_with_button_hidden",
		function()
			cm:override_ui("hide_stances_button", true);
			
			-- set up a PanelOpenedCampaign listener and reapply the override once the panel is opened
			core:add_listener(
				"hide_stances_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:callback(
						function() 
							cm:override_ui("hide_stances_button", true);
						end,
						0.1
					);
				end,
				true
			);
		end,
		function()
			cm:override_ui("hide_stances_button", false);
			core:remove_listener("hide_stances_ui_override");
		end
	);

	-------------------------------
	-- skills_with_button_hidden
	-------------------------------
	ui_overrides.skills_with_button_hidden = ui_override:new(
		"skills_with_button_hidden",
		function()
			core:add_listener(
				"hide_skills_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_skills_button", true);
				end,
				true			
			);
			cm:override_ui("hide_skills_button", true);
		end,
		function()
			cm:override_ui("hide_skills_button", false);
			core:remove_listener("hide_skills_ui_override");
		end
	);
	
	-------------------------------
	-- spell_browser_with_button_hidden
	-------------------------------
	ui_overrides.spell_browser_with_button_hidden = ui_override:new(
		"spell_browser_with_button_hidden",
		function()
			cm:override_ui("hide_spell_browser_button", true);
		end,
		function()
			cm:override_ui("hide_spell_browser_button", false);
		end
	);
	
	-------------------------------
	-- advice_with_button_hidden
	-------------------------------
	ui_overrides.advice_with_button_hidden = ui_override:new(
		"advice_with_button_hidden",
		function()
			cm:override_ui("hide_advice_button", true);
		end,
		function()
			cm:override_ui("hide_advice_button", false);
		end
	);
	
	-------------------------------
	-- help_pages_with_button_hidden
	-------------------------------
	ui_overrides.help_pages_with_button_hidden = ui_override:new(
		"help_pages_with_button_hidden",
		function()
			cm:override_ui("hide_help_button", true);
		end,
		function()
			cm:override_ui("hide_help_button", false);
		end
	);
	
	-------------------------------
	-- occupy_public_order
	-------------------------------
	ui_overrides.occupy_public_order = ui_override:new(
		"occupy_public_order",
		function()
			core:add_listener(
				"hide_occupy_public_order_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_captured" 
				end,
				function()
					cm:override_ui("hide_occupy_public_order_icon", true);
				end,
				true			
			);
			cm:override_ui("hide_occupy_public_order_icon", true);
		end,
		function()
			cm:override_ui("hide_occupy_public_order_icon", false);
			core:remove_listener("hide_occupy_public_order_ui_override")
		end
	);
	
	-------------------------------
	-- occupy_conquest
	-------------------------------
	ui_overrides.occupy_conquest = ui_override:new(
		"occupy_conquest",
		function()
			core:add_listener(
				"hide_occupy_conquest_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_captured" 
				end,
				function()
					cm:override_ui("hide_occupy_conquest_icon", true);
				end,
				true			
			);
			cm:override_ui("hide_occupy_conquest_icon", true);
		end,
		function()
			cm:override_ui("hide_occupy_conquest_icon", false);
			core:remove_listener("hide_occupy_conquest_ui_override")
		end
	);
	
	-------------------------------
	-- occupy_climate
	-------------------------------
	ui_overrides.occupy_climate = ui_override:new(
		"occupy_climate",
		function()
			core:add_listener(
				"hide_occupy_climate_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_captured" 
				end,
				function()
					cm:override_ui("hide_occupy_climate_icon", true);
				end,
				true			
			);
			cm:override_ui("hide_occupy_climate_icon", true);
		end,
		function()
			cm:override_ui("hide_occupy_climate_icon", false);
			core:remove_listener("hide_occupy_climate_ui_override")
		end
	);

	-------------------------------
	-- settlement_panel_help_with_button_hidden
	-------------------------------
	ui_overrides.settlement_panel_help_with_button_hidden = ui_override:new(
		"settlement_panel_help_with_button_hidden",
		function()
			core:add_listener(
				"hide_settlement_help_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_panel_help_button", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_panel_help_button", true);
		end,
		function()
			cm:override_ui("hide_settlement_panel_help_button", false);
			core:remove_listener("hide_settlement_help_ui_override")
		end
	);

	--------------------------------------------------------------------------------------------------
	-- settlement_panel_label_corruption (on the label that's displayed below each settlement's model)
	--------------------------------------------------------------------------------------------------
	ui_overrides.hide_settlement_label_corruption = ui_override:new(
		"hide_settlement_label_corruption",
		function() cm:override_ui("hide_settlement_label_corruption", true) end,
		function() cm:override_ui("hide_settlement_label_corruption", false) end
	)
	
	-------------------------------
	------ hide_ai_control --------
	-------------------------------
	ui_overrides.hide_ai_control = ui_override:new(
		"hide_ai_control",
		function()
			core:add_listener(
				"hide_ai_control_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_ai_control", true);
				end,
				true			
			);
			cm:override_ui("hide_ai_control", true);
		end,
		function()
			cm:override_ui("hide_ai_control", false);
			core:remove_listener("hide_ai_control_ui_override")
		end
	);
	
	-------------------------------
	-- units_panel
	-------------------------------
	ui_overrides.units_panel = ui_override:new(
		"units_panel",
		function()
			core:add_listener(
				"hide_units_panel_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_units_panel", true);
				end,
				true			
			);
			cm:override_ui("hide_units_panel", true);
		end,
		function()
			cm:override_ui("hide_units_panel", false);
			core:remove_listener("hide_units_panel_ui_override")
		end
	);
	
	-------------------------------
	-- units_panel_small_bar
	-------------------------------
	ui_overrides.units_panel_small_bar = ui_override:new(
		"units_panel_small_bar",
		function()
			core:add_listener(
				"hide_units_panel_small_bar_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_units_panel_small_bar", true);
				end,
				true			
			);
			cm:override_ui("hide_units_panel_small_bar", true);
		end,
		function()
			cm:override_ui("hide_units_panel_small_bar", false);
			core:remove_listener("hide_units_panel_small_bar_ui_override")
		end
	);

	-------------------------------
	-- units_panel_small_bar_buttons
	-------------------------------
	ui_overrides.units_panel_small_bar_buttons = ui_override:new(
		"units_panel_small_bar_buttons",
		function()
			core:add_listener(
				"hide_units_panel_small_bar_buttons_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_units_panel_small_bar_buttons", true);
				end,
				true			
			);
			cm:override_ui("hide_units_panel_small_bar_buttons", true);
		end,
		function()
			cm:override_ui("hide_units_panel_small_bar_buttons", false);
			core:remove_listener("hide_units_panel_small_bar_buttons_ui_override")
		end
	);
	
	-------------------------------
	-- units_panel_recruit_with_button_hidden
	-------------------------------
	ui_overrides.units_panel_recruit_with_button_hidden = ui_override:new(
		"units_panel_recruit_with_button_hidden",
		function()
			core:add_listener(
				"hide_units_panel_recruit_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_units_panel_recruit_button", true);
				end,
				true			
			);
			
			cm:override_ui("hide_units_panel_recruit_button", true);
		end,
		function()
			cm:override_ui("hide_units_panel_recruit_button", false);
			core:remove_listener("hide_units_panel_recruit_ui_override")
		end
	);
	
	-------------------------------
	-- settlement_panel_small_bar
	-------------------------------
	ui_overrides.settlement_panel_small_bar = ui_override:new(
		"settlement_panel_small_bar",
		function()
			core:add_listener(
				"hide_settlement_panel_small_bar_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()	
					cm:callback(
						function()
							cm:override_ui("hide_units_panel_recruit_button", true);
						end, 
						0.1
					);
				end,
				true			
			);
			
			cm:override_ui("hide_units_panel_recruit_button", true);
		end,
		function()
			cm:override_ui("hide_units_panel_recruit_button", false);
			core:remove_listener("hide_settlement_panel_small_bar_ui_override")
		end
	);
	
	-------------------------------
	-- units_panel_docker
	-------------------------------
	ui_overrides.units_panel_docker = ui_override:new(
		"units_panel_docker",
		function()
			core:add_listener(
				"hide_units_panel_docker_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					cm:override_ui("hide_units_panel_docker", true);
				end,
				true			
			);
			cm:override_ui("hide_units_panel_docker", true);
		end,
		function()
			cm:override_ui("hide_units_panel_docker", false);
			core:remove_listener("hide_units_panel_docker_ui_override")
		end
	);
	
	-------------------------------
	-- province_panel_corruption
	-------------------------------
	ui_overrides.province_panel_corruption = ui_override:new(
		"province_panel_corruption",
		function()
			core:add_listener(
				"hide_province_panel_corruption_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_province_panel_corruption_info", true);
				end,
				true			
			);
			cm:override_ui("hide_province_panel_corruption_info", true);
		end,
		function()
			cm:override_ui("hide_province_panel_corruption_info", false);
			core:remove_listener("hide_province_panel_corruption_ui_override")
		end
	);
	
	-------------------------------
	-- province_panel_effects
	-------------------------------
	ui_overrides.province_panel_effects = ui_override:new(
		"province_panel_effects",
		function()
			core:add_listener(
				"hide_province_panel_effects_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_province_panel_effects_info", true);
				end,
				true			
			);
			cm:override_ui("hide_province_panel_effects_info", true);
		end,
		function()
			cm:override_ui("hide_province_panel_effects_info", false);
			core:remove_listener("hide_province_panel_effects_ui_override")
		end
	);
	
	-------------------------------
	-- province_panel_public_order
	-------------------------------
	ui_overrides.province_panel_public_order = ui_override:new(
		"province_panel_public_order",
		function()
			core:add_listener(
				"hide_province_panel_public_order_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_province_panel_public_order_info", true);
				end,
				true			
			);
			cm:override_ui("hide_province_panel_public_order_info", true);
		end,
		function()
			cm:override_ui("hide_province_panel_public_order_info", false);
			core:remove_listener("hide_province_panel_public_order_ui_override")
		end
	);
	
	-------------------------------
	-- province_info_panel
	-------------------------------
	ui_overrides.province_info_panel = ui_override:new(
		"province_info_panel",
		function()
			core:add_listener(
				"hide_settlement_info_panel_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_info_panel", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_info_panel", true);
		end,
		function()
			cm:override_ui("hide_settlement_info_panel", false);
			core:remove_listener("hide_settlement_info_panel_ui_override")
		end
	);
	
	-------------------------------
	-- settlement_panel_hero_recruit_with_button_hidden
	-------------------------------
	ui_overrides.settlement_panel_hero_recruit_with_button_hidden = ui_override:new(
		"settlement_panel_hero_recruit_with_button_hidden",
		function()
			core:add_listener(
				"hide_settlement_panel_recruit_hero_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_panel_recruit_hero_button", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_panel_recruit_hero_button", true);
		end,
		function()
			cm:override_ui("hide_settlement_panel_recruit_hero_button", false);
			core:remove_listener("hide_settlement_panel_recruit_hero_ui_override")
		end
	);
	
	-------------------------------
	-- settlement_panel_lord_recruit_with_button_hidden
	-------------------------------
	ui_overrides.settlement_panel_lord_recruit_with_button_hidden = ui_override:new(
		"settlement_panel_lord_recruit_with_button_hidden",
		function()
			core:add_listener(
				"hide_settlement_panel_recruit_lord_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_panel_recruit_lord_button", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_panel_recruit_lord_button", true);
		end,
		function()
			cm:override_ui("hide_settlement_panel_recruit_lord_button", false);
			core:remove_listener("hide_settlement_panel_recruit_lord_ui_override")
		end
	);
	
	-------------------------------
	-- settlement_panel_building_browser_with_button_hidden
	-------------------------------
	ui_overrides.settlement_panel_building_browser_with_button_hidden = ui_override:new(
		"settlement_panel_building_browser_with_button_hidden",
		function()
			core:add_listener(
				"hide_settlement_panel_building_browser_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_panel_building_browser_button", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_panel_building_browser_button", true);
		end,
		function()
			cm:override_ui("hide_settlement_panel_building_browser_button", false);
			core:remove_listener("hide_settlement_panel_building_browser_ui_override")
		end
	);
	
	-------------------------------
	-- settlement_panel_garrison_with_button_hidden
	-------------------------------
	ui_overrides.settlement_panel_garrison_with_button_hidden = ui_override:new(
		"settlement_panel_garrison_with_button_hidden",
		function()
			core:add_listener(
				"hide_settlement_panel_garrison_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "settlement_panel" 
				end,
				function()
					cm:override_ui("hide_settlement_panel_garrison_button", true);
				end,
				true			
			);
			cm:override_ui("hide_settlement_panel_garrison_button", true);
		end,
		function()
			cm:override_ui("hide_settlement_panel_garrison_button", false);
			core:remove_listener("hide_settlement_panel_garrison_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_save_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_save_with_button_hidden = ui_override:new(
		"pre_battle_save_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_save_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_save_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_save_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_save_button", false);
			core:remove_listener("hide_pre_battle_save_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_help_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_help_with_button_hidden = ui_override:new(
		"pre_battle_help_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_help_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_help_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_help_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_help_button", false);
			core:remove_listener("hide_pre_battle_help_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_general_details_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_general_details_with_button_hidden = ui_override:new(
		"pre_battle_general_details_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_general_details_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_general_details_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_general_details_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_general_details_button", false);
			core:remove_listener("hide_pre_battle_general_details_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_rank_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_rank_with_button_hidden = ui_override:new(
		"pre_battle_rank_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_rank_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_rank_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_rank_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_rank_button", false);
			core:remove_listener("hide_pre_battle_rank_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_autoresolve_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_autoresolve_with_button_hidden = ui_override:new(
		"pre_battle_autoresolve_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_autoresolve_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_autoresolve_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_autoresolve_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_autoresolve_button", false);
			core:remove_listener("hide_pre_battle_autoresolve_ui_override")
		end
	);
	
	-------------------------------
	-- pre_battle_retreat_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_retreat_with_button_hidden = ui_override:new(
		"pre_battle_retreat_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_retreat_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_retreat_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_retreat_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_retreat_button", false);
			core:remove_listener("hide_pre_battle_retreat_ui_override")
		end
	);

	-------------------------------
	-- pre_battle_attack_dismiss_with_button_hidden
	-------------------------------
	ui_overrides.pre_battle_attack_dismiss_with_button_hidden = ui_override:new(
		"pre_battle_attack_dismiss_with_button_hidden",
		function()
			core:add_listener(
				"hide_pre_battle_attack_dismiss_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("hide_pre_battle_attack_dismiss_button", true);
				end,
				true			
			);
			cm:override_ui("hide_pre_battle_attack_dismiss_button", true);
		end,
		function()
			cm:override_ui("hide_pre_battle_attack_dismiss_button", false);
			core:remove_listener("hide_pre_battle_attack_dismiss_ui_override")
		end
	);
	
	
	-------------------------------
	-- demolish_with_button_hidden
	-------------------------------
	ui_overrides.demolish_with_button_hidden = ui_override:new(
		"demolish_with_button_hidden",
		function()
			core:add_listener(
				"hide_demolish_button_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "construction_popup" 
				end,
				function()
					cm:callback(
						function() 
							cm:override_ui("hide_demolish_button", true);
						end, 
						0.1
					);
				end,
				true			
			);
			cm:override_ui("hide_demolish_button", true);
		end,
		function()
			cm:override_ui("hide_demolish_button", false);
			core:remove_listener("hide_demolish_button_ui_override")
		end
	);
	
	-------------------------------
	-- building_browser_public_order
	-------------------------------
	ui_overrides.building_browser_public_order = ui_override:new(
		"building_browser_public_order",
		function()
			core:add_listener(
				"hide_building_browser_public_order_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "building_browser" 
				end,
				function()
					cm:override_ui("hide_building_browser_public_order", true);
				end,
				true			
			);
			cm:override_ui("hide_building_browser_public_order", true);
		end,
		function()
			cm:override_ui("hide_building_browser_public_order", false);
			core:remove_listener("hide_building_browser_public_order_ui_override")
		end
	);
	
	-------------------------------
	-- building_browser_effects
	-------------------------------
	ui_overrides.building_browser_effects = ui_override:new(
		"building_browser_effects",
		function()
			core:add_listener(
				"hide_building_browser_effects_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "building_browser" 
				end,
				function()
					cm:override_ui("hide_building_browser_effects", true);
				end,
				true			
			);
			cm:override_ui("hide_building_browser_effects", true);
		end,
		function()
			cm:override_ui("hide_building_browser_effects", false);
			core:remove_listener("hide_building_browser_effects_ui_override")
		end
	);
	
	-------------------------------
	-- building_browser_corruption
	-------------------------------
	ui_overrides.building_browser_corruption = ui_override:new(
		"building_browser_corruption",
		function()
			core:add_listener(
				"hide_building_browser_corruption_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "building_browser" 
				end,
				function()
					cm:override_ui("hide_building_browser_corruption", true);
				end,
				true			
			);
			cm:override_ui("hide_building_browser_corruption", true);
		end,
		function()
			cm:override_ui("hide_building_browser_corruption", false);
			core:remove_listener("hide_building_browser_corruption_ui_override")
		end
	);


	-------------------------------
	-- objectives_panel_delete_with_button_hidden
	-------------------------------
	ui_overrides.objectives_panel_delete_with_button_hidden = ui_override:new(
		"objectives_panel_delete_with_button_hidden",
		function()
			core:add_listener(
				"hide_objectives_screen_delete_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "objectives_screen" 
				end,
				function()
					cm:override_ui("hide_objectives_panel_delete_button", true);
				end,
				true			
			);
			cm:override_ui("hide_objectives_panel_delete_button", true);
		end,
		function()
			cm:override_ui("hide_objectives_panel_delete_button", false);
		end
	);

	-------------------------------
	-- objectives_panel_victory_conditions
	-------------------------------
	ui_overrides.objectives_panel_victory_conditions = ui_override:new(
		"objectives_panel_victory_conditions",
		function()
			core:add_listener(
				"hide_objectives_screen_victory_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "objectives_screen" 
				end,
				function()
					cm:override_ui("hide_objectives_panel_victory_conditions_button", true);
				end,
				true			
			);
			cm:override_ui("hide_objectives_panel_victory_conditions_button", true);
		end,
		function()
			cm:override_ui("hide_objectives_panel_victory_conditions_button", false);
		end
	);
	
	-------------------------------
	-- siege_turns
	-------------------------------
	ui_overrides.siege_turns = ui_override:new(
		"siege_turns",
		function()
			cm:override_ui("hide_siege_turns", true);
		end,
		function()
			cm:override_ui("hide_siege_turns", false);
		end
	);

	-------------------------------
	-- prebattle_balance_of_power 
	-------------------------------
	ui_overrides.prebattle_balance_of_power = ui_override:new(
		"prebattle_balance_of_power",
		function()
			cm:override_ui("disable_prebattle_balance_of_power", true);
		end,
		function()
			cm:override_ui("disable_prebattle_balance_of_power", false);
		end
	);
	
	-------------------------------
	-- treasure_hunt_cursor
	-------------------------------
	ui_overrides.treasure_hunt_cursor = ui_override:new(
		"treasure_hunt_cursor",
		function()
			cm:override_ui("disable_treasure_hunt_cursor", true);
		end,
		function()
			cm:override_ui("disable_treasure_hunt_cursor", false);
		end
	);
	
	-------------------------------
	-- terrain_tooltips
	-------------------------------
	ui_overrides.terrain_tooltips = ui_override:new(
		"terrain_tooltips",
		function()
			cm:override_ui("disable_terrain_tooltips", true);
		end,
		function()
			cm:override_ui("disable_terrain_tooltips", false);
		end
	);
	
	-------------------------------
	-- mouse_over_info_city_info_bar
	-------------------------------
	ui_overrides.mouse_over_info_city_info_bar = ui_override:new(
		"mouse_over_info_city_info_bar",
		function()
			cm:override_ui("disable_mouse_over_info_city_info_bar", true);
		end,
		function()
			cm:override_ui("disable_mouse_over_info_city_info_bar", false);
		end
	);
	
	-------------------------------
	-- undiscovered_faction_flags_on_end_turn
	-------------------------------
	ui_overrides.undiscovered_faction_flags_on_end_turn = ui_override:new(
		"undiscovered_faction_flags_on_end_turn",
		function()
			cm:override_ui("disable_undiscovered_faction_flags_on_end_turn", true);
		end,
		function()
			cm:override_ui("disable_undiscovered_faction_flags_on_end_turn", false);
		end
	);
	
	-------------------------------
	-- switch_treasure_hunt_cursor
	-------------------------------
	ui_overrides.switch_treasure_hunt_cursor = ui_override:new(
		"switch_treasure_hunt_cursor",
		function()
			cm:override_ui("switch_treasure_hunt_cursor", false);
		end,
		function()
			cm:override_ui("switch_treasure_hunt_cursor", true);
		end
	);

	-------------------------------
	-- campaign_flags
	-------------------------------
	ui_overrides.campaign_flags = ui_override:new(
		"campaign_flags",
		function()
			cm:override_ui("hide_campaign_flags", true);
		end,
		function()
			cm:override_ui("hide_campaign_flags", false);
		end
	);

	-------------------------------
	-- winds_of_magic
	-------------------------------
	ui_overrides.winds_of_magic = ui_override:new(
		"winds_of_magic",
		function()
			core:add_listener(
				"hide_winds_of_magic_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "units_panel" or context.string == "popup_pre_battle"
				end,
				function()
					cm:override_ui("hide_winds_of_magic", true);
				end,
				true			
			);
			
			cm:override_ui("hide_winds_of_magic", true);
		end,
		function()
			cm:override_ui("hide_winds_of_magic", false);
			core:remove_listener("hide_winds_of_magic_ui_override")
		end
	);
	
	-------------------------------
	-- faction_specific_pooled_resource
	-------------------------------
	ui_overrides.faction_specific_pooled_resource = ui_override:new(
		"faction_specific_pooled_resource",
		function()	
			cm:override_ui("hide_faction_specific_pooled_resource", true);
		end,
		function()
			cm:override_ui("hide_faction_specific_pooled_resource", false);
		end
	);
	
	-------------------------------
	-- prebattle_spectate_with_button_hidden
	-------------------------------
	ui_overrides.prebattle_spectate_with_button_hidden = ui_override:new(
		"prebattle_spectate_with_button_hidden",
		function()	
			core:add_listener(
				"hide_pre_battle_spectate_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "popup_pre_battle" 
				end,
				function()
					cm:override_ui("disable_prebattle_spectate", true);
				end,
				true			
			);
			cm:override_ui("disable_prebattle_spectate", true);
		end,
		function()
			core:remove_listener("hide_pre_battle_spectate_ui_override");
			cm:override_ui("disable_prebattle_spectate", false);
		end
	);

	-------------------------------
	-- end_turn_notification
	-------------------------------
	ui_overrides.end_turn_notification = ui_override:new(
		"end_turn_notification",
		function()
			cm:override_ui("hide_end_turn_notification", true);
		end,
		function()
			cm:override_ui("hide_end_turn_notification", false);
		end
	);
	
	-------------------------------
	-- movie_viewer_with_button_hidden
	-------------------------------
	ui_overrides.movie_viewer_with_button_hidden = ui_override:new(
		"movie_viewer_with_button_hidden",
		function()
			cm:override_ui("disable_movie_viewer", true);
		end,
		function()
			cm:override_ui("disable_movie_viewer", false);
		end
	);
	
	-------------------------------
	-- spell_and_unit_browser_with_button_hidden
	-------------------------------
	ui_overrides.spell_and_unit_browser_with_button_hidden = ui_override:new(
		"spell_and_unit_browser_with_button_hidden",
		function()
			cm:override_ui("disable_spell_and_unit_browser", true);
		end,
		function()
			cm:override_ui("disable_spell_and_unit_browser", false);
		end
	);

	-------------------------------
	-- stance_encamp
	-------------------------------
	ui_overrides.stance_encamp = ui_override:new(
		"stance_encamp",
		function()
			cm:override_ui("disable_stance_encamp", true);
		end,
		function()
			cm:override_ui("disable_stance_encamp", false);
		end
	);

	-------------------------------
	-- global_recruitment_stance_checks
	-------------------------------
	ui_overrides.global_recruitment_stance_checks = ui_override:new(
		"global_recruitment_stance_checks",
		function()
			cm:override_ui("disable_global_recruitment_stance_checks", true);
		end,
		function()
			cm:override_ui("disable_global_recruitment_stance_checks", false);
		end
	);

	-------------------------------
	-- prevent_help_panel_docking
	-------------------------------
	ui_overrides.prevent_help_panel_docking = ui_override:new(
		"prevent_help_panel_docking",
		function()
			get_help_page_manager():set_panel_docking_disabled(true);
		end,
		function()
			get_help_page_manager():set_panel_docking_disabled(false);
		end
	);

	-------------------------------
	-- prebattle_continue_with_button_hidden
	-------------------------------
	ui_overrides.prebattle_continue_with_button_hidden = ui_override:new(
		"prebattle_continue_with_button_hidden",
		function()
			cm:override_ui("hide_prebattle_continue", true);
		end,
		function()
			cm:override_ui("hide_prebattle_continue", false);
		end
	);

	-------------------------------
	-- world_space_icons_for_prologue
	-------------------------------
	ui_overrides.world_space_icons_for_prologue = ui_override:new(
		"world_space_icons_for_prologue",
		function()
			cm:override_ui("disable_world_space_icons_for_prologue", true);
		end,
		function()
			cm:override_ui("disable_world_space_icons_for_prologue", false);
		end
	);
	
	-------------------------------
	-- campaign_flags_strength_bars
	-------------------------------
	ui_overrides.campaign_flags_strength_bars = ui_override:new(
		"campaign_flags_strength_bars",
		function()
			cm:override_ui("hide_campaign_flags_strength_bars", true);
		end,
		function()
			cm:override_ui("hide_campaign_flags_strength_bars", false);
		end
	);
	
	-------------------------------
	-- allied_recruitment_with_button_hidden
	-------------------------------
	ui_overrides.allied_recruitment_with_button_hidden = ui_override:new(
		"allied_recruitment_with_button_hidden",
		function()
			cm:override_ui("hide_units_panel_allied_recruitment_button", true);
		end,
		function()
			cm:override_ui("hide_units_panel_allied_recruitment_button", false);
		end
	);

	-------------------------------
	-- postbattle_kill_captives_with_button_hidden
	-------------------------------
	ui_overrides.postbattle_kill_captives_with_button_hidden = ui_override:new(
		"postbattle_kill_captives_with_button_hidden",
		function()
			cm:override_ui("disable_postbattle_kill_captives", true);
		end,
		function()
			cm:override_ui("disable_postbattle_kill_captives", false);
		end
	);
	
    -------------------------------
	-- postbattle_character_deaths
	-------------------------------
	ui_overrides.postbattle_character_deaths = ui_override:new(
		"postbattle_character_deaths",
		function()
			cm:override_ui("hide_character_deaths", true);
		end,
		function()
			cm:override_ui("hide_character_deaths", false);
		end
	);

	-------------------------------
	-- postbattle_middle_panel
	-------------------------------
	ui_overrides.postbattle_middle_panel = ui_override:new(
		"postbattle_middle_panel",
		function()
			cm:override_ui("disable_postbattle_middle_panel", true);
		end,
		function()
			cm:override_ui("disable_postbattle_middle_panel", false);
		end
	);
	
	-------------------------------
	-- prebattle_middle_panel
	-------------------------------
	ui_overrides.prebattle_middle_panel = ui_override:new(
		"prebattle_middle_panel",
		function()
			cm:override_ui("hide_prebattle_middle_panel", true);
		end,
		function()
			cm:override_ui("hide_prebattle_middle_panel", false);
		end
	);
	
	
	-------------------------------
	-- hide_diplomacy_region_trading
	-------------------------------
	ui_overrides.hide_diplomacy_region_trading = ui_override:new(
		"hide_diplomacy_region_trading",
		function()
			cm:override_ui("hide_diplomacy_region_trading", true);
		end,
		function()
			cm:override_ui("hide_diplomacy_region_trading", false);
		end
	);

	-------------------------------
	-- hide_diplomacy_threaten
	-------------------------------
	ui_overrides.hide_diplomacy_threaten = ui_override:new(
		"hide_diplomacy_threaten",
		function()
			cm:override_ui("hide_diplomacy_threaten", true);
		end,
		function()
			cm:override_ui("hide_diplomacy_threaten", false);
		end
	);

	-------------------------------
	-- hide_diplomacy_war_coordination
	-------------------------------
	ui_overrides.hide_diplomacy_war_coordination = ui_override:new(
		"hide_diplomacy_war_coordination",
		function()
			cm:override_ui("hide_diplomacy_war_coordination", true);
		end,
		function()
			cm:override_ui("hide_diplomacy_war_coordination", false);
		end
	);
	
	-------------------------------
	-- hide_diplomacy_trade_ui
	-------------------------------
	ui_overrides.hide_diplomacy_trade_ui = ui_override:new(
		"hide_diplomacy_trade_ui",
		function()
			cm:override_ui("hide_diplomacy_trade_ui", true);
		end,
		function()
			cm:override_ui("hide_diplomacy_trade_ui", false);
		end
	);
	
	-------------------------------
	-- hide_character_details_bottom_buttons
	-------------------------------
	ui_overrides.hide_character_details_bottom_buttons = ui_override:new(
		"hide_character_details_bottom_buttons",
		function()
			core:add_listener(
				"hide_bottom_buttons_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "character_details_panel" 
				end,
				function()
					cm:override_ui("hide_character_details_bottom_buttons", true);
				end,
				true
			);
		end,
		function()
			core:remove_listener("hide_bottom_buttons_ui_override");
			cm:override_ui("hide_character_details_bottom_buttons", false);
		end
	);

	-------------------------------
	-- hide_character_details_rename
	-------------------------------
	ui_overrides.character_details_rename = ui_override:new(
		"character_details_rename",
		function()
			core:add_listener(
				"hide_bottom_buttons_rename_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "character_details_panel" 
				end,
				function()
					cm:override_ui("hide_character_details_rename", true);
				end,
				true
			);
		end,
		function()
			core:remove_listener("hide_bottom_buttons_rename_ui_override");
			cm:override_ui("hide_character_details_rename", false);
		end
	);

	-------------------------------
	-- hide_character_details_view_records
	-------------------------------
	ui_overrides.character_details_view_records = ui_override:new(
		"character_details_view_records",
		function()
			core:add_listener(
				"hide_bottom_buttons_view_records_ui_override",
				"PanelOpenedCampaign",
				function(context) 
					return context.string == "character_details_panel" 
				end,
				function()
					cm:override_ui("hide_character_details_view_records", true);
				end,
				true
			);
		end,
		function()
			core:remove_listener("hide_bottom_buttons_view_records_ui_override");
			cm:override_ui("hide_character_details_view_records", false);
		end
	);
	
	-------------------------------
	-- disable_building_info_recruitment_effects
	-------------------------------
	ui_overrides.building_info_recruitment_effects = ui_override:new(
		"building_info_recruitment_effects",
		function()
			cm:override_ui("disable_building_info_recruitment_effects", true);
		end,
		function()
			cm:override_ui("disable_building_info_recruitment_effects", false);
		end
	);
	
	-------------------------------
	-- hide_campaign_unit_information
	-------------------------------
	ui_overrides.hide_campaign_unit_information = ui_override:new(
		"hide_campaign_unit_information",
		function()
			cm:override_ui("hide_campaign_unit_information", true);
		end,
		function()
			cm:override_ui("hide_campaign_unit_information", false);
		end
	);
	
	-------------------------------
	-- disable_replace_faction_leader
	-------------------------------
	ui_overrides.disable_replace_faction_leader = ui_override:new(
		"disable_replace_faction_leader",
		function()
			cm:override_ui("disable_replace_faction_leader", true);
		end,
		function()
			cm:override_ui("disable_replace_faction_leader", false);
		end
	);

	------------------------------
	-- finance_help_button
	-------------------------------
	ui_overrides.finance_help_button = ui_override:new(
		"finance_help_button",
		function()
			cm:override_ui("hide_finance_help_button", true);
		end,
		function()
			cm:override_ui("hide_finance_help_button", false);
		end
	)

	------------------------------
	-- campaign_spacebar_options
	-------------------------------
	ui_overrides.campaign_spacebar_options = ui_override:new(
		"campaign_spacebar_options",
		function()
			common.set_context_value("disable_campaign_spacebar_options", 1);
		end,
		function()
			common.set_context_value("disable_campaign_spacebar_options", 0);
		end
	)

	------------------------------
	-- campaign_3d_ui
	-------------------------------
	ui_overrides.campaign_3d_ui = ui_override:new(
		"campaign_3d_ui",
		function()
			cm:override_ui("hide_3d_ui", true);
		end,
		function()
			cm:override_ui("hide_3d_ui", false);
		end
	)

	------------------------------
	-- parchment_overlay
	-------------------------------
	ui_overrides.parchment_overlay = ui_override:new(
		"parchment_overlay",
		function()
			cm:override_ui("hide_parchment_overlay", true);
		end,
		function()
			cm:override_ui("hide_parchment_overlay", false);
		end
	)

	------------------------------
	-- campaign_flags
	-------------------------------
	ui_overrides.campaign_flags = ui_override:new(
		"campaign_flags",
		function()
			cm:override_ui("hide_campaign_flags", true);
		end,
		function()
			cm:override_ui("hide_campaign_flags", false);
		end
	)

	------------------------------
	-- campaign_flags_strength_bars
	-------------------------------
	ui_overrides.campaign_flags_strength_bars = ui_override:new(
		"campaign_flags_strength_bars",
		function()
			cm:override_ui("hide_campaign_flags_strength_bars", true);
		end,
		function()
			cm:override_ui("hide_campaign_flags_strength_bars", false);
		end
	)

	------------------------------
	-- disable_help_pages_panel_button
	-------------------------------
	ui_overrides.disable_help_pages_panel_button = ui_override:new(
		"disable_help_pages_panel_button",
		function()
			cm:override_ui("disable_help_pages", true);
		end,
		function()
			cm:override_ui("disable_help_pages", false);
		end
	)
	
	-- load in the contents of the ui_overrides table that we've just declared
	for override_name, override in pairs(ui_overrides) do
		self:register_override(override_name, override);
	end;
end;


function campaign_ui_manager:register_override(override_name, override)
	if not is_string(override_name) then
		script_error("ERROR: register_override() called but supplied override name [" .. tostring(override_name) .. "] is not a string");
		return false;
	end;
	
	if not is_uioverride(override) then
		script_error("ERROR: register_override() called but supplied override [" .. tostring(override) .. "] is not a ui override");
		return false;
	end;

	-- check that we don't already have this override
	if self.override_list[override_name] then
		script_error("WARNING: register_override() called but supplied override [" .. tostring(override_name) .. "] is already registered");
		return false;
	end;
	
	self.override_list[override_name] = override;
end;


function campaign_ui_manager:override(override_name)
	local retval = self.override_list[override_name];
	
	if not retval then
		script_error("ERROR: override() called but supplied override name [" .. tostring(override_name) .. "] could not be found");
	end;
	
	return retval;
end;


function campaign_ui_manager:print_override_list()
	local override_list = self.override_list;
	
	out.ui("***********************");
	out.ui("Printing override list:");
	out.ui("***********************");
	
	local count = 0;
	
	for override_name, override in pairs(override_list) do
		count = count + 1;
		out.ui("\t" .. override_name);
	end;
	
	out.ui("***********************");
	if count == 1 then
		out.ui("Printed 1 override");
	else
		out.ui("Printed " .. count .. " overrides");
	end;
	out.ui("***********************");
end;

