




----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	BATTLE UI MANAGER
--
--- @set_environment battle
--- @c battle_ui_manager Battle UI Manager
--- @desc The battle ui manager provides helper functions related to the UI for battle scripts. It is primarily of use for help page scripts that wish to highlight bits of the UI with a pulsing effect. In this respect, it performs the same function as the @campaign_ui_manager.
--- @desc By convention, the battle ui manager may be accessed at the global variable <code>buim</code> when in battle.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------




----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

battle_ui_manager = {
	unhighlight_action_list = {},
	panels_open = {},
	button_pulse_strength = 10,
	panel_pulse_strength = 5,
	help_page_link_highlighting_permitted = true
};


set_class_custom_type_and_tostring(battle_ui_manager, TYPE_BATTLE_UI_MANAGER);








----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a battle_ui_manager. It should never be necessary for a client script to need to call this directly, as the @battle_manager creates this object and stores it internally. Instead retrieve the battle_ui_manager from the battle_manager with @battle_manager:get_battle_ui_manager. By convention, the battle ui manager is also found at the global variable <code>buim</code>.
--- @p @battle_manager battle manager
--- @r battle_ui_manager
function battle_ui_manager:new(bm)
	
	-- there can only be one of these objects, if the bm already has a link to one return that instead
	if bm.battle_ui_manager then
		return bm.battle_ui_manager;
	end;

	local ui = {};

	set_object_class(ui, self);
	
	ui.unhighlight_action_list = {};
	ui.panels_open = {};
	bm.battle_ui_manager = ui;

	ui:start_listeners()

	return ui;
end;


function battle_ui_manager:start_listeners()

	-- panel opened
	core:add_listener(
		"battle_selection_listener",
		"PanelOpenedBattle",
		true,
		function(context)
			local panel = context.string;
			out.ui("Panel opened " .. panel);	
			
			self.panels_open[panel] = true;
			
			core:trigger_event("ScriptEventPanelOpenedBattle", panel);
		end,
		true
	);
	
	-- panel closed
	core:add_listener(
		"battle_selection_listener",
		"PanelClosedBattle",
		true,
		function(context)
			local panel = context.string;
			out.ui("Panel closed " .. panel);
			
			self.panels_open[panel] = false;
			
			core:trigger_event("ScriptEventPanelClosedBattle", panel);
		end,
		true
	);
end;








----------------------------------------------------------------------------
--- @section Panel Status
----------------------------------------------------------------------------


--- @function is_panel_open
--- @desc Returns whether a ui panel with the supplied name is currently open.
--- @p @string panel name
--- @r @boolean is panel open
function battle_ui_manager:is_panel_open(panel)
	if self.panels_open[panel] then
		return true;
	end;
	return false;
end;


--- @function is_esc_menu_open
--- @desc Returns whether the escape menu is currently open.
--- @r @boolean is esc menu open
function battle_ui_manager:is_esc_menu_open()
	return self:is_panel_open("esc_menu");
end;


--- @function get_open_fullscreen_panel
--- @desc Returns the name of a fullscreen panel that's open, or <code>false</code> if no panels are open. If more than one fullscreen panel is open then the name of one is returned at random.
--- @r @string open fullscreen panel
function battle_ui_manager:get_open_fullscreen_panel()
	local panel_name = next(self.panels_open);
	if panel_name then
		return panel_name;
	end;
	return false;
end;









----------------------------------------------------------------------------
--- @section Pulse Strength Constants
----------------------------------------------------------------------------


--- @function get_panel_pulse_strength
--- @desc Returns the panel pulse strength constant the battle_ui_manager stores internally. This value determines the strength of the pulse highlighting effect on large UI elements like panels.
--- @r number
function battle_ui_manager:get_panel_pulse_strength()
	return self.panel_pulse_strength;
end;


--- @function get_button_pulse_strength
--- @desc Returns the button pulse strength constant the battle_ui_manager stores internally. This value determines the strength of the pulse highlighting effect on small UI elements like buttons.
--- @r number
function battle_ui_manager:get_button_pulse_strength()
	return self.button_pulse_strength;
end;







----------------------------------------------------------------------------
--- @section Unhighlighting
----------------------------------------------------------------------------


--- @function register_unhighlight_callback
--- @desc Allows registration of a function to be called when @battle_ui_manager:unhighlight_all_for_tooltips is called.
--- @p function callback to call
function battle_ui_manager:register_unhighlight_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: register_unhighlight_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	table.insert(self.unhighlight_action_list, callback);
end;



--- @function unhighlight_all_for_tooltips
--- @desc Calls all functions currently registered with @battle_ui_manager:register_unhighlight_callback. This is intended to be used to unhighlight all currently-highlighted UI elements, when the mouse cursor is moved off of a help page link.
function battle_ui_manager:unhighlight_all_for_tooltips()
	local unhighlight_action_list = self.unhighlight_action_list;
	
	for i = 1, #unhighlight_action_list do
		unhighlight_action_list[i]();
	end;
	
	self.unhighlight_action_list = {};
end;






----------------------------------------------------------------------------
--- @section Help Page Highlighting Permitted
----------------------------------------------------------------------------

--- @function set_help_page_link_highlighting_permitted
--- @desc Enables/disables the scripted behaviour which pulses a highlight over various elements of the UI when the mouse cursor is placed over related words on Help Pages.
--- @p [opt=true] boolean enable highlighting
function battle_ui_manager:set_help_page_link_highlighting_permitted(value)
	if not value then
		self:unhighlight_all_for_tooltips();
	end;
	self.help_page_link_highlighting_permitted = value;
end;


--- @function get_help_page_link_highlighting_permitted
--- @desc Returns whether help page link highlighting is permitted. This is true by default, unless it's been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted
--- @r boolean highlighting enabled
function battle_ui_manager:get_help_page_link_highlighting_permitted()
	return self.help_page_link_highlighting_permitted;
end;









----------------------------------------------------------------------------
--- @section Specific Component Highlighting
----------------------------------------------------------------------------


--- @function highlight_advice_history_buttons
--- @desc Pulse-highlights the advice history buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_advice_history_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_button_next = find_uicomponent(ui_root, "advice_interface", "button_next");
	
	if uic_button_next and uic_button_next:Visible(true) and is_fully_onscreen(uic_button_next) then
		pulse_uicomponent(uic_button_next, value, pulse_strength or self.button_pulse_strength);
		
		local uic_button_previous = find_uicomponent(ui_root, "advice_interface", "button_previous");
		
		if uic_button_previous and uic_button_previous:Visible(true) then
			pulse_uicomponent(uic_button_previous, value, pulse_strength or self.button_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_advice_history_buttons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_advisor_button(value);
	end;
	
	return false;
end;


--- @function highlight_advisor_button
--- @desc Pulse-highlights the advice button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_advisor_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic = find_uicomponent(ui_root, "menu_bar", "button_show_advice");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_advisor_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_advisor
--- @desc Pulse-highlights the advisor.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_advisor(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_advice_interface = find_uicomponent(ui_root, "advice_interface");
	
	if uic_advice_interface and uic_advice_interface:Visible(true) and is_fully_onscreen(uic_advice_interface) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		local uic_text_parent = find_uicomponent(uic_advice_interface, "text_parent");
		if uic_text_parent then
			pulse_uicomponent(uic_text_parent, value, pulse_strength);
		end;
		
		local uic_frame = find_uicomponent(uic_advice_interface, "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		local uic_button_options = find_uicomponent(uic_advice_interface, "button_toggle_options");
		if uic_button_options  then
			pulse_uicomponent(uic_button_options, value, pulse_strength);
		end;
		
		local uic_button_close = find_uicomponent(uic_advice_interface, "button_close");
		if uic_button_close then
			pulse_uicomponent(uic_button_close, value, pulse_strength);
		end;
		
		if value then
			self:highlight_advice_history_buttons(value, pulse_strength, force_highlight);
			
			table.insert(self.unhighlight_action_list, function() self:highlight_advisor(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_advisor_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_army_abilities
--- @desc Pulse-highlights any army abilities buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_army_abilities(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "army_ability_parent");
		
	if uic and uic:Visible(true) then
		for i = 0, uic:ChildCount() - 1 do
			local uic_army_ability = UIComponent(uic:Find(i));
			
			pulse_uicomponent(uic_army_ability, value, pulse_strength or self.panel_pulse_strength);
			
			for j = 0, uic_army_ability:ChildCount() - 1 do
				pulse_uicomponent(UIComponent(uic_army_ability:Find(j)), value, pulse_strength or self.panel_pulse_strength);
			end;
		end;
		
		if value then
			self:highlight_army_abilities_meter(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_army_abilities(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_army_abilities_meter
--- @desc Pulse-highlights any army abilities buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_army_abilities_meter(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "army_ability_parent");

	if uic and uic:Visible(true) then
		for i = 0, uic:ChildCount() - 1 do
			local uic_army_ability = UIComponent(uic:Find(i));

			-- pulse_uicomponent(uic_army_ability, value, pulse_strength or self.panel_pulse_strength);

			for j = 0, uic_army_ability:ChildCount() - 1 do
				local ui_child = UIComponent(uic_army_ability:Find(j));
				local ui_ability_bar = find_uicomponent(ui_child, "bar_frame");
				pulse_uicomponent(ui_ability_bar, value, pulse_strength or self.panel_pulse_strength);
			end;
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_army_abilities_meter(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;

	return false;
end;


--- @function highlight_army_panel
--- @desc Pulse-highlights the army panel.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_army_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_army_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_balance_of_power
--- @desc Pulse-highlights the balance of power bar.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_balance_of_power(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "kill_ratio_PH");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_balance_of_power(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_drop_equipment_button
--- @desc Pulse-highlights the drop equipment button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_drop_equipment_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_behaviour_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "orders_parent", "behaviour_parent");
	
	if uic_behaviour_parent and uic_behaviour_parent:Visible(true) then	
		for i = 0, uic_behaviour_parent:ChildCount() - 1 do
			local uic_button_slot = UIComponent(uic_behaviour_parent:Find(i));
			local uic_button = UIComponent(uic_button_slot:Find(0));
			
			if uic_button and uic_button:InterfaceFunction("AbilityKeyForScript") == "drop_siege_equipment" then
				pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
				break;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_drop_equipment_button(false, pulse_strength, force_highlight) end);
		end;
	end;
	
	return false;
end;


--- @function highlight_fire_at_will_button
--- @desc Pulse-highlights the fire-at-will button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_fire_at_will_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_behaviour_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "orders_parent", "behaviour_parent");
	
	if uic_behaviour_parent and uic_behaviour_parent:Visible(true) then	
		for i = 0, uic_behaviour_parent:ChildCount() - 1 do
			local uic_button_slot = UIComponent(uic_behaviour_parent:Find(i));
			local uic_button = UIComponent(uic_button_slot:Find(0));
			
			if uic_button and uic_button:InterfaceFunction("AbilityKeyForScript") == "fire_at_will" then
				pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
				break;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_fire_at_will_button(false, pulse_strength, force_highlight) end);
		end;
	end;
	
	return false;
end;


--- @function highlight_formations_button
--- @desc Pulse-highlights the formations button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_formations_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_orders", "button_toggle_formations");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_formations_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_game_guide_button
--- @desc Pulse-highlights the game guide button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_game_guide_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "menu_bar", "button_encyclopedia");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_game_guide_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_group_button
--- @desc Pulse-highlights the group button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_group_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_orders", "button_group");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_group_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_guard_button
--- @desc Pulse-highlights the guard button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_guard_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_orders", "button_guard");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_guard_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_lore_panel
--- @desc Pulse-highlights the lore panel.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_lore_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "winds_of_magic", "top_right_holder");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_lore_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_melee_mode_button
--- @desc Pulse-highlights the melee mode button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_melee_mode_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_orders", "button_melee");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_melee_mode_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_power_reserve_bar
--- @desc Pulse-highlights the power reserve bar.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_power_reserve_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "winds_of_magic", "reserves_parent");
	
	if uic_parent and uic_parent:Visible(true) then
		pulse_uicomponent(uic_parent, value, pulse_strength or self.panel_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_power_reserve_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_radar_map
--- @desc Pulse-highlights the radar map.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_radar_map(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_frame = find_uicomponent(core:get_ui_root(), "radar_holder", "radar_group", "radar_frame");
	
	if uic_frame and uic_frame:Visible(true) then
		pulse_uicomponent(uic_frame, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_radar_map(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_realm_of_souls
--- @desc Pulse-highlights the realm of souls bar.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_realm_of_souls(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_bar = find_uicomponent(core:get_ui_root(), "BOP_frame", "realm_of_souls_parent");
	
	if uic_bar and uic_bar:Visible(true) then
		pulse_uicomponent(uic_bar, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_realm_of_souls(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_skirmish_button
--- @desc Pulse-highlights the skirmish button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_skirmish_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_behaviour_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "orders_parent", "behaviour_parent");
	
	if uic_behaviour_parent and uic_behaviour_parent:Visible(true) then	
		for i = 0, uic_behaviour_parent:ChildCount() - 1 do
			local uic_button_slot = UIComponent(uic_behaviour_parent:Find(i));
			local uic_button = UIComponent(uic_button_slot:Find(0));
			
			if uic_button and uic_button:InterfaceFunction("AbilityKeyForScript") == "skirmish" then
				pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
				break;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_skirmish_button(false, pulse_strength, force_highlight) end);
		end;
	end;
	
	return false;
end;


--- @function highlight_spells
--- @desc Pulse-highlights any spells buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_spells(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_spell_parent = find_uicomponent(core:get_ui_root(), "winds_of_magic", "spell_parent");
	if uic_spell_parent and uic_spell_parent:Visible(true) then
	
		for i = 0, uic_spell_parent:ChildCount() - 1 do
			local uic_child = UIComponent(uic_spell_parent:Find(i));
			pulse_uicomponent(uic_child, value, pulse_strength or self.button_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_spells(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_supplies
--- @desc Pulse-highlights the supplies.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_supplies(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_component = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "supplies_display");

	if uic_component and uic_component:Visible(true) then
		pulse_uicomponent(uic_component, value, pulse_strength or self.panel_pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_supplies(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;

	return false;
end;


--- @function highlight_tactical_map_button
--- @desc Pulse-highlights the tactical map button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_tactical_map_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "radar_holder", "button_tactical_map");
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tactical_map_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_time_controls
--- @desc Pulse-highlights the time controls buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_time_controls(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_parent = find_uicomponent(core:get_ui_root(), "radar_holder", "speed_buttons");
	
	if uic_parent and uic_parent:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		local uic_pause = find_uicomponent(uic_parent, "pause");
		if uic_pause then
			pulse_uicomponent(uic_pause, value, pulse_strength);
		end;
		
		local uic_slow_mo = find_uicomponent(uic_parent, "slow_mo");
		if uic_slow_mo then
			pulse_uicomponent(uic_slow_mo, value, pulse_strength);
		end;
		
		local uic_play = find_uicomponent(uic_parent, "play");
		if uic_play then
			pulse_uicomponent(uic_play, value, pulse_strength);
		end;
		
		local uic_fwd = find_uicomponent(uic_parent, "fwd");
		if uic_fwd then
			pulse_uicomponent(uic_fwd, value, pulse_strength);
		end;
		
		local uic_ffwd = find_uicomponent(uic_parent, "ffwd");
		if uic_ffwd then
			pulse_uicomponent(uic_ffwd, value, pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_time_controls(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_time_limit
--- @desc Pulse-highlights the time limit.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_time_limit(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "BOP_frame", "simple_timer");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength + 5, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_time_limit(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_unit_abilities
--- @desc Pulse-highlights any unit abilities buttons.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_unit_abilities(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_behaviour_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "orders_parent", "behaviour_parent");
	
	if uic_behaviour_parent and uic_behaviour_parent:Visible(true) then	
		for i = 0, uic_behaviour_parent:ChildCount() - 1 do
			local uic_button_slot = UIComponent(uic_behaviour_parent:Find(i));
			local uic_button = UIComponent(uic_button_slot:Find(0));
			
			if uic_button and string.len(tostring(uic_button:InterfaceFunction("AbilityKeyForScript"))) > 3 then
				pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_abilities(false, pulse_strength, force_highlight) end);
		end;
	end;
	
	return false;
end;


--- @function highlight_unit_cards
--- @desc Pulse-highlights the unit cards.
--- @p @boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] @number pulse strength, Override pulse strength
--- @p [opt=false] @boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
--- @p [opt=false] @boolean highlight health, Only highlight/unhighlight the health bar of unit cards.
--- @p [opt=false] @boolean highlight ammo, Only highlight/unhighlight the ammunition bar of unit cards.
--- @p [opt=false] @boolean highlight xp, Only highlight/unhighlight the experience icon of unit cards.
--- @p [opt=false] @boolean highlight status, Only highlight/unhighlight the status tab of unit cards.
function battle_ui_manager:highlight_unit_cards(value, pulse_strength, force_highlight, highlight_health, highlight_ammo, highlight_experience, highlight_status)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	
	if uic_parent and uic_parent:Visible() then
		card_pulse_strength = pulse_strength or self.panel_pulse_strength;		-- less intense (unless overridden), since the whole of each unit card is being highlighted
		icon_pulse_strength = pulse_strength or self.button_pulse_strength;		-- more intense (unless overridden), since only a very small part of the card is being highlighted
	
		for i = 0, uic_parent:ChildCount() - 1 do
			local uic_card = UIComponent(uic_parent:Find(i));
			
			if highlight_health then
				local uic_health_frame = find_uicomponent(uic_card, "health_frame");
				if uic_health_frame and uic_health_frame:Visible() then
					pulse_uicomponent(uic_health_frame, value, icon_pulse_strength, true);
				end;
				
			elseif highlight_ammo then
				local uic_ammo = find_uicomponent(uic_card, "Ammunition");
				if uic_ammo and uic_ammo:Visible() then
					pulse_uicomponent(uic_ammo, value, icon_pulse_strength, true);
				end;
			
			elseif highlight_experience then
				local uic_experience = find_uicomponent(uic_card, "experience");
				if uic_experience and uic_experience:Visible() then
					pulse_uicomponent(uic_experience, value, icon_pulse_strength, true);
				end;

			elseif highlight_status then
				local uic_status = find_uicomponent(uic_card, "battle", "status_list");
				if uic_status and uic_status:Visible() then
					pulse_uicomponent(uic_status, value, icon_pulse_strength, true);
				end;
			else
				-- highlight whole card
				local uic_card_image = find_uicomponent(uic_card, "card_image_holder"); 
				if uic_card_image then
					pulse_uicomponent(uic_card_image, value, card_pulse_strength);
				end;

				local uic_cat_frame = find_uicomponent(uic_card, "unit_cat_frame");
				if uic_cat_frame and uic_cat_frame:Visible() then
					pulse_uicomponent(uic_cat_frame, value, card_pulse_strength, true);
				end;

				local uic_ammunition = find_uicomponent(uic_card, "Ammunition");
				if uic_ammunition and uic_ammunition:Visible() then
					pulse_uicomponent(uic_ammunition, value, card_pulse_strength, true);
				end;

				local uic_health = find_uicomponent(uic_card, "health_frame");
				if uic_health and uic_health:Visible() then
					pulse_uicomponent(uic_health, value, card_pulse_strength, true);
				end;

				local uic_battle = find_uicomponent(uic_card, "battle");
				if uic_battle and uic_battle:Visible() then
					pulse_uicomponent(uic_battle, value, card_pulse_strength, true);
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_cards(false, pulse_strength, force_highlight, highlight_health, highlight_ammo, highlight_experience, highlight_status) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_unit_details_button
--- @desc Pulse-highlights the unit details button.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_unit_details_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "porthole_parent", "button_toggle_infopanel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_details_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_unit_details_panel
--- @desc Pulse-highlights the unit details panel.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_unit_details_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_panel = find_uicomponent(core:get_ui_root(), "hud_battle", "info_panel_parent", "unit_information");

	if uic_panel and uic_panel:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		pulse_uicomponent(uic_panel, value, pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_details_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_unit_details_button(value, pulse_strength, force_highlight);
	end;

	return false;
end;


--- @function highlight_unit_portrait_panel
--- @desc Pulse-highlights the unit portrait panel.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_unit_portrait_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_porthole_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent");
	
	if uic_porthole_parent and uic_porthole_parent:Visible(true) then
		local uic_porthole = find_uicomponent(uic_porthole_parent, "porthole_mask");
		if uic_porthole then
			pulse_uicomponent(uic_porthole, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_button_camera = find_uicomponent(uic_porthole_parent, "button_unit_camera");
		if uic_button_camera then
			pulse_uicomponent(uic_button_camera, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			self:highlight_unit_details_button(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_portrait_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_victory_locations
--- @desc Pulse-highlights the victory locations.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_victory_locations(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_component = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "icon_parent");

	if uic_component and uic_component:Visible(true) then
		pulse_uicomponent(uic_component, value, pulse_strength or self.panel_pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_victory_locations(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;

	return false;
end;


--- @function highlight_victory_tickets
--- @desc Pulse-highlights the victory tickets.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_victory_tickets(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_component = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "siege_victory_bar_holder");

	if uic_component and uic_component:Visible(true) then
		pulse_uicomponent(uic_component, value, pulse_strength or self.panel_pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_victory_tickets(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;

	return false;
end;


--- @function highlight_winds_of_magic_panel
--- @desc Pulse-highlights the winds of magic panel.
--- @p boolean enable highlight, Set to true to enable the highlight, false to disable
--- @p [opt=nil] number pulse strength, Override pulse strength
--- @p [opt=false] boolean force, Enable the highlight even if highlighting has been disabled with @battle_ui_manager:set_help_page_link_highlighting_permitted.
function battle_ui_manager:highlight_winds_of_magic_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_winds_of_magic = find_uicomponent(core:get_ui_root(), "hud_battle", "winds_of_magic");
	
	if uic_winds_of_magic and uic_winds_of_magic:Visible(true) then
		local uic_holder = find_uicomponent(uic_winds_of_magic, "holder");
		if uic_holder then
			pulse_uicomponent(uic_holder, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_mask = find_uicomponent(uic_winds_of_magic, "mask");
		if uic_mask then
			pulse_uicomponent(uic_mask, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_frame = find_uicomponent(uic_winds_of_magic, "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.panel_pulse_strength);

			local uic_frame_lid = find_uicomponent(uic_frame, "lid");
			if uic_frame_lid then
				pulse_uicomponent(uic_frame_lid, value, pulse_strength or self.panel_pulse_strength);
			end;
		end;
		
		if value then
			self:highlight_spells(value, pulse_strength, force_highlight);
			self:highlight_power_reserve_bar(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_winds_of_magic_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;