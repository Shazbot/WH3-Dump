

-----------------------------------------------------------------------------
--	various types of help page records
-----------------------------------------------------------------------------

function hpr_title(key, section_name)
	local retval = {};
	retval.key = key;
	retval.state = "header";
	retval.show_links = true;
	retval.section_name = section_name;
	return retval;
end;


function hpr_leader(key, section_name)
	local retval = {};
	retval.key = key;
	retval.show_links = true;
	retval.state = "leader";
	retval.state_small = "leader_small";
	retval.section_name = section_name;
	return retval;
end;


function hpr_normal_unfaded(key, section_name)
	local retval = {};
	retval.key = key;
	retval.show_links = true;
	retval.state = "text_unfaded";
	retval.state_small = "text_small_unfaded";
	retval.section_name = section_name;
	return retval;
end;


function hpr_normal(key, section_name)
	local retval = {};
	retval.key = key;
	retval.show_links = true;
	retval.state = "text";
	retval.state_small = "text_small";
	retval.section_name = section_name;
	return retval;
end;


function hpr_small(key, section_name)
	local retval = {};
	retval.key = key;
	retval.show_links = true;
	retval.state = "text_small";
	retval.state_small = "text_small";
	retval.section_name = section_name;
	return retval;
end;


function hpr_right_aligned(key, section_name)
	local retval = {};
	retval.key = key;
	retval.state = "right_aligned";
	retval.state_small = "right_aligned_small";
	retval.show_links = true;
	retval.section_name = section_name;
	return retval;
end;


function hpr_bulleted(key, section_name)
	local retval = {};
	retval.key = key;
	retval.state = "bullet_text";
	retval.section_name = section_name;
	retval.state_small = "bullet_text_small";
	retval.show_links = true;
	return retval;
end;


function hpr_image(key, image_path, section_name)
	local retval = {};
	retval.key = key;
	retval.image_path = image_path;
	retval.section_name = section_name;
	return retval;
end;


function hpr_section(section_name)
	local retval = {};
	retval.section_name = section_name;
	retval.is_new_section = true;
	retval.show_links = true;
	return retval;
end;


function hpr_section_index(section_name, start_record, end_record, suppress_expand_button, expand_button_localised_text, collapse_button_localised_text)
	local retval = {};
	retval.section_name = section_name;
	retval.is_section_index = true;
	retval.start_record = start_record;
	retval.end_record = end_record;
	retval.suppress_expand_button = suppress_expand_button;
	retval.expand_button_localised_text = expand_button_localised_text;
	retval.collapse_button_localised_text = collapse_button_localised_text;
	return retval;
end;


local hpr_min_height_large = 54;
local hpr_min_height_med = 40;


function hpr_campaign_camera_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.state = "campaign_controls_camera";
	retval.show_modifier = true;
	retval.show_drag_modifier = true;
	retval.min_height = hpr_min_height_large;
	return retval;
end;


function hpr_campaign_camera_controls_alt(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "campaign_controls_camera_alt";
	retval.min_height = hpr_min_height_large;
	return retval;
end;


function hpr_campaign_camera_facing_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "campaign_controls_camera_facing";
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_campaign_camera_altitude_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "campaign_controls_camera_altitude";
	retval.show_modifier = true;
	retval.show_roll_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_campaign_selection_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "campaign_controls_select";
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_campaign_army_movement_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "campaign_controls_army_movement";
	retval.min_height = hpr_min_height_med;
	return retval;
end;







function hpr_battle_camera_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_camera";
	retval.min_height = hpr_min_height_large;
	return retval;
end;


function hpr_battle_camera_facing_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_camera_facing";
	retval.show_modifier = true;
	retval.show_drag_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_camera_altitude_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_camera_altitude";
	retval.show_modifier = true;
	retval.show_roll_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_camera_speed_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_camera_speed";
	retval.show_modifier = true;
	retval.show_hold_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_selection_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_selection";
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_multiple_selection_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_multiple_selection";
	retval.show_modifier = true;
	retval.show_drag_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_movement_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_unit_movement";
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_drag_out_formation_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_drag_out_formation";
	retval.show_modifier = true;
	retval.show_drag_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_unit_destination_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_unit_destinations";
	retval.show_modifier = true;
	retval.show_hold_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_halt_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_halt";
	retval.min_height = hpr_min_height_med;
	return retval;
end;


function hpr_battle_attack_controls(key, section_name)
	local retval = {};
	retval.key = key;
	retval.section_name = section_name;
	retval.prevent_resizing = true;
	retval.state = "battle_controls_attacking";
	retval.show_modifier = true;
	retval.show_on_enemy_modifier = true;
	retval.min_height = hpr_min_height_med;
	return retval;
end;













----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	HELP PANEL MANAGER
--	This system manages the state of the help panel, handling back/forward requests 
--	we're interested it replaces the contents of the tooltip with info from the db.
-- 	It also handles tooltip mouseover event listening.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Panel position overrides
-- UI panels which, when open, change the position of the help panel onscreen require an entry here. Any panel that displaces or 
-- hides the main game UI (e.g. tech, diplomacy, tactical map) needs an entry here. See also the lists of all panels in
-- lib_campaign_ui.lua
local help_panel_position_overrides_campaign = {

	-- BASE
	diplomacy_dropdown = {
		["x"] = "middle",
		["y"] = 20,
		["max_height"] = 500,
		["redocking_wait_period"] = 0.3
	},
	campaign_tactical_map = {
		["x"] = 5,
		["y"] = -5,
		["cede_priority_to"] = "diplomacy_dropdown"		-- if this other panel is also open, use the settings for that instead
	},
	clan = {
		["x"] = 5,
		["y"] = -5
	},
	popup_pre_battle = {
		["x"] = "middle",
		["y"] = 50,
		["max_height"] = 500,
		["close_help_panel_when_opened"] = true,
		["redocking_wait_period"] = 0.3
	},
	popup_battle_results = {
		["x"] = "middle",
		["y"] = 50,
		["max_height"] = 500,
		["redocking_wait_period"] = 0.3
	},
	technology_panel = {
		["x"] = -5,
		["y"] = -5
	},
	building_browser = {
		["x"] = -5,
		["y"] = 5
	},
	character_details_panel = {
		["x"] = 5,
		["y"] = -5
	},
	spell_browser = {
		["x"] = -5,
		["y"] = -5
	},
	
	-- WH1
	offices = {
		["x"] = 5,
		["y"] = -20
	},
	book_of_grudges = {
		["x"] = 5,
		["y"] = -5
	},
	bloodlines = {
		["x"] = -5,
		["y"] = -5
	},

	-- WH2
	rituals_panel = {
		["x"] = -5,
		["y"] = -5
	},
	slaves_panel = {
		["x"] = -5,
		["y"] = -5
	},
	mortuary_cult = {
		["x"] = 5,
		["y"] = -5
	},
	book_of_monster_hunts = {
		["x"] = -5,
		["y"] = 5
	},
	ikit_workshop_panel = {
		["x"] = -5,
		["y"] = -5
	},
	athel_tamarha_dungeon = {
		["x"] = -5,
		["y"] = -5
	},
	augment_panel = {
		["x"] = -5,
		["y"] = -5
	},
	hunters_panel = {
		["x"] = -5,
		["y"] = -5
	},

	-- WH3
	kislev_ice_court = {
		["x"] = -5,
		["y"] = -5
	},
	kislev_atamans = {
		["x"] = -350,
		["y"] = 75
	},
	cathay_compass = {
		["x"] = 5,
		["y"] = -5
	},
	cathay_caravans = {
		["x"] = -5,
		["y"] = 5
	},
	daemonic_progression = {
		["x"] = -5,
		["y"] = -5
	},
	nurgle_plagues = {
		["x"] = -5,
		["y"] = -5
	},
	tzeench_wom_manipulation = {
		["x"] = 5,
		["y"] = -5
	},
	tzeentch_changing_of_ways = {
		["x"] = 5,
		["y"] = -5
	},
	float_top_right = {
		["x"] = -5,
		["y"] = 5,
		["redocking_wait_period"] = 0.8
	},
	war_coordination = {
		["x"] = 5,
		["y"] = -5
	},
	beastmen_panel = {
		["x"] = 5,
		["y"] = -5
	}
};


local help_panel_position_overrides_battle = {
	float_top_right = {
		["x"] = -5,
		["y"] = 5,
		["redocking_wait_period"] = 800
	}
};


	

	




-- Spacing to keep between help panel and other ui elements
local HELP_PANEL_TO_UI_MARGIN = 20;

help_page_manager = {
	uic_help_panel = false,
	
	parser = false,
	
	overrides_table = false,
	
	title_bar_buttons_visible = true,
	
	-- hyperlink click listener
	-- hyperlink_click_listeners = {},
	hyperlink_click_listener_started = false,
	
	-- tooltip mouseover listeners
	-- tooltip_mouseover_listeners = {},
	active_tooltip_mouseover_listeners = {},
	tooltip_mouseover_listeners_started = false,
	
	-- help page history
	-- help_page_history = {},
	help_page_history_max_size = 20,
	history_pointer = 0,
	
	-- panel position
	default_max_height_campaign = 600,
	default_max_height_battle = 500,
	related_panels_open = 0,

	top_bar_height = 40,

	default_undocked_pos_x = 260,
	default_undocked_pos_y = 60,

	player_has_undocked_panel = false,
	panel_has_moved_while_undocked = false,

	should_reshow_after_cinematic_ui = false,

	panel_docking_disabled = false,
	close_on_game_menu_opened = true,

	-- screen height below which we use small text
	small_text_min_screen_height = 1000,
	never_use_small_text = true,
	
	-- info button to page map
	-- info_button_to_page_map = {},

	-- help panel position overrides
	-- position_overrides_table = {},
	
	-- cache the index button tooltips if we disable them
	help_panel_index_button_tooltip_text = false,
	help_panel_index_button_tooltip_text_src = false,
	menu_bar_index_button_tooltip_text = false,
	menu_bar_index_button_tooltip_text_src = false
};


set_class_custom_type_and_tostring(help_page_manager, TYPE_HELP_PAGE_MANAGER);





function help_page_manager:new()

	out.help_pages("");
	out.help_pages("");
	out.help_pages("");
	out.help_pages("*** help page system initialising ***");
	out.help_pages("");

	local hm = {};
	
	set_object_class(hm, self);
	
	hm.hyperlink_click_listeners = {};
	hm.tooltip_mouseover_listeners = {};
	hm.active_tooltip_mouseover_listeners = {};
	hm.help_page_history = {};
	hm.info_button_to_page_map = {};
	
	hm.parser = get_link_parser();
	
	core:add_static_object("help_page_manager", hm);
	
	-- set up listeners for the back/forward buttons
	core:add_listener(
		"help_page_previous_history",
		"ComponentLClickUp",
		function(context) return context.string == "button_hp_previous" end,
		function(context) hm:previous_history_button_clicked() end,
		true	
	);
	
	core:add_listener(
		"help_page_forward_history",
		"ComponentLClickUp",
		function(context) return context.string == "button_hp_next" end,
		function(context) hm:forward_history_button_clicked() end,
		true	
	);
	
	-- listen for the close button on the panel being clicked, and update the panel's visibility state
	core:add_listener(
		"help_page_close_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_hp_close" end,
		function(context)
			hm:panel_has_closed();
		end,
		true
	);
	
	-- listen for the ? button on the menu bar being clicked to close the panel, and update the panel's visibility state (to prevent battle radar getting stuck for example)
	core:add_listener(
		"help_page_toggle_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_help_panel" end,
		function(context)
			if hm:is_panel_visible() == false then
				hm:panel_has_closed();
			end
		end,
		true
	);

	core:add_listener(
		"help_panel_dock_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_dock" and uicomponent_descended_from(UIComponent(context.component), "help_panel"); end,
		function(context)
			hm.player_has_undocked_panel = false;
			hm:update_panel_docking_state();
		end,
		true
	);
		
	-- listen for the panel being moved
	core:add_listener(
		"help_page_panel_moved",
		"ComponentMoved",
		function(context) return context.string == "help_panel" end,
		function(context)
			hm.panel_has_moved_while_undocked = true;
		end,
		true
	);
	
	-- set up listener for index being generated
	core:add_listener(
		"help_page_index_generated",
		"HelpPageIndexGenerated",
		true,
		function()
			hm:help_page_index_generated() 
		end,
		true
	);
	
	-- set up listener for button_info buttons on each panel
	core:add_listener(
		"help_page_button_info_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_info" end,
		function(context) if not cm:model():campaign_name("wh3_main_prologue") then hm:info_button_clicked(UIComponent(context.component)) end end,
		true
	);


	-- Listen for cinematic ui being opened/closed
	hm:start_cinematic_ui_listeners();
		
	-- Establish a listener for panels being opened and closed
	local panel_opened_event;
	local panel_closed_event;
	local all_position_overrides_table;
	
	if core:is_campaign() then
		panel_opened_event = "ScriptEventPanelOpenedCampaign";
		panel_closed_event = "ScriptEventPanelClosedCampaign";
		all_position_overrides_table = help_panel_position_overrides_campaign;
	elseif core:is_battle() then
		panel_opened_event = "PanelOpenedBattle";
		panel_closed_event = "PanelClosedBattle";
		all_position_overrides_table = help_panel_position_overrides_battle;
	end;

	core:add_listener(
		"help_page_related_panel_opened",
		panel_opened_event,
		function(context)
			return not not all_position_overrides_table[context.string] 
		end,
		function(context)
			hm:related_panel_opened(context.string, true);
		end,
		true
	);

	core:add_listener(
		"help_page_related_panel_closed",
		panel_closed_event,
		function(context)
			local position_override_table = all_position_overrides_table[context.string];
			return position_override_table and position_override_table.is_active;
		end,
		function(context) 
			hm:related_panel_closed(context.string) 
		end,
		true
	);



	hm.position_overrides_table = all_position_overrides_table;
	
	-- hiding and showing on events
	-- hides the panel if certain events are received (end turn sequence, battle sequence) and then shows it afterwards if previously hidden
	local hide_on_event = {};
	table.insert(hide_on_event, "ScriptEventPlayerBattleStarted");
	table.insert(hide_on_event, "ScriptEventPlayerFactionTurnEnd");
	
	local attempt_show_on_event = {};
	table.insert(attempt_show_on_event, "ScriptEventPlayerBattleSequenceCompleted");
	table.insert(attempt_show_on_event, "ScriptEventPlayerFactionTurnStart");
		
	for i = 1, #hide_on_event do
		core:add_listener(
			"help_page_hide_on_event_listener",
			hide_on_event[i],
			true,
			function()
				if hm:is_panel_visible() then
					hm:hide_panel("hide event " .. hide_on_event[i] .. " received");

					if not hm:last_help_page_was_contents_or_index() then
						hm.make_visible_at_next_opportunity = true;
					end;
				end;			
			end,
			true
		);
	end;
	
	for i = 1, #attempt_show_on_event do
		core:add_listener(
			"help_page_show_on_event_listener",
			attempt_show_on_event[i],
			true,
			function()
				if hm.make_visible_at_next_opportunity then
					hm.make_visible_at_next_opportunity = false;
					hm:show_panel();
				end;
			end,
			true
		);
	end;
	
	-- hide the panel if the esc menu is opened
	if core:is_campaign() then
		core:add_listener(
			"help_page_close_button_listener",
			"PanelOpenedCampaign",
			function(context) return context.string == "esc_menu_campaign" and hm.close_on_game_menu_opened end,
			function(context)
				hm:hide_panel();
			end,
			true
		);
	
	elseif core:is_battle() then	
		core:add_listener(
			"help_page_close_button_listener",
			"PanelOpenedBattle",
			function(context) return context.string == "esc_menu_battle" and hm.close_on_game_menu_opened end,
			function(context)
				hm:hide_panel();
			end,
			true
		);
	end;
	
	return hm;
end;


function get_help_page_manager()
	local hpm = core:get_static_object("help_page_manager");
	if hpm then
		return hpm;
	end;
	
	return help_page_manager:new();
end;


function help_page_manager:get_uicomponent()
	if self.uic_help_panel then
		return self.uic_help_panel;
	end;

	-- listen for the UI being recreated and update our uicomponent handle
	core:add_listener(
		"help_page_manager_ui_created",
		"UICreated",
		true,
		function()
			self.uic_help_panel = find_uicomponent(core:get_ui_root(), "help_panel");
		end,
		true
	);
	
	local uic_help_panel = find_uicomponent(core:get_ui_root(), "help_panel");

	if not uic_help_panel then
		script_error("ERROR: help_panel_manager:get_uicomponent() called but uic_help_panel could not be found - how can this be?");
		return false;
	end;

	local uic_top_bar_parent = find_uicomponent(uic_help_panel, "top_bar_parent");
	if uic_top_bar_parent then
		self.top_bar_height = uic_top_bar_parent:Height();
	end;
	
	self.uic_help_panel = uic_help_panel;

	return uic_help_panel;
end;


function help_page_manager:get_index_button()	
	local uic = find_uicomponent(core:get_ui_root(), "menu_bar", "button_help_panel");
	
	if not uic then
		script_error("ERROR: get_index_button() called but couldn't find index button to return - how can this be?");
	end;
	
	return uic;
end;


function help_page_manager:set_close_on_game_menu_opened(value)
	if value == false then
		self.close_on_game_menu_opened = false;
	else
		self.close_on_game_menu_opened = true;
	end;
end;














function help_page_manager:start_cinematic_ui_listeners()
	core:add_listener(
		"help_panel_cinematic_listener",
		"CinematicUIEnabled",
		true,
		function()
			if self:is_panel_visible() then
				self.should_reshow_after_cinematic_ui = true;
				self:hide_panel(true);
			end;
		end,
		true
	);


	core:add_listener(
		"help_panel_cinematic_listener",
		"CinematicUIDisabled",
		true,
		function()
			if self.should_reshow_after_cinematic_ui then
				self.should_reshow_after_cinematic_ui = false;
				self:show_panel(true);
			end;
		end,
		true
	);
end;










-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Help Page History
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- Loads history from savegame
function help_page_manager:load_history_from_string(str)
	
	local help_page_history = self.help_page_history;
	local pointer = 1;
	
	while true do
		local next_separator = string.find(str, "#", pointer);
		
		if not next_separator then
			break;
		end;
		
		self:add_help_page_to_history(string.sub(str, pointer, next_separator - 1));
		
		pointer = next_separator + 1;
	end;
	
	self:print_help_page_history();
end;


-- Save history to savegame
function help_page_manager:help_page_history_to_string()
	local help_page_history = self.help_page_history;
	
	local str = "";
	
	for i = 1, #help_page_history do
		str = str .. help_page_history[i] .. "#";
	end;
	
	return str;
end;


-- Adding help page to history
function help_page_manager:add_help_page_to_history(page_name)
	local help_page_history = self.help_page_history;
	
	local insert_pointer = self.history_pointer + 1;
	
	-- delete all history past this point
	while(help_page_history[insert_pointer]) do
		table.remove(help_page_history, insert_pointer);
	end;
	
	-- insert our page into the history if it's different from the most-recent page
	-- (to avoid having successive pages that are the same)
	if help_page_history[self.history_pointer] ~= page_name then
		table.insert(help_page_history, insert_pointer, page_name)
		self.history_pointer = insert_pointer;
	end;
	
	-- if our history is bigger than our max history size then trim some off the end
	if #help_page_history > self.help_page_history_max_size then
		table.remove(help_page_history, 1);
		self.history_pointer = self.history_pointer - 1;
	end;
end;


-- Gets the name of the last viewed help page (nil if none have been viewed)
function help_page_manager:get_last_help_page()
	if #self.help_page_history == 0 then
		return;
	end;

	return self.help_page_history[#self.help_page_history];
end;


-- Was the last opened help page the index
function help_page_manager:last_help_page_was_index()
	return self:get_last_help_page() == "__index";
end;


-- Was the last opened help page the contents
function help_page_manager:last_help_page_was_contents()
	local last_help_page = self:get_last_help_page();
	return last_help_page == "script_link_campaign_contents" or last_help_page == "script_link_battle_contents";
end;


-- Was the last opened help page the index or contents
function help_page_manager:last_help_page_was_contents_or_index()
	local last_help_page = self:get_last_help_page();
	return last_help_page == "__index" or last_help_page == "campaign_contents" or last_help_page == "battle_contents";
end;


-- Is there anything in the help page history
function help_page_manager:is_help_page_history_empty()
	return #self.help_page_history == 0;
end;


-- Gets the name of the previous help page
function help_page_manager:get_previous_help_page()
	if self.history_pointer > 0 then
		self.history_pointer = self.history_pointer - 1;
	end;
	
	return self.help_page_history[self.history_pointer];
end;


-- Gets the name of the forward help page
function help_page_manager:get_forward_help_page()
	if self.history_pointer < #self.help_page_history then
		self.history_pointer = self.history_pointer + 1;
	end;
	
	return self.help_page_history[self.history_pointer];
end;


-- Are there any previous help pages
function help_page_manager:previous_help_pages_exist()
	return self.history_pointer > 1;
end;


-- Are there any forward help pages
function help_page_manager:forward_help_pages_exist()
	return self.history_pointer < #self.help_page_history;
end;


-- Common script that's called whether we show previous or forward page
function help_page_manager:show_previous_or_forward_page()

	if self:last_help_page_was_index() then
		self:get_uicomponent():InterfaceFunction("show_index");
	else
		local previous_page = self.help_page_history[self.history_pointer];
		self:hyperlink_clicked(previous_page, true);		-- this 'click' is from history, so it won't get added to the help page history
	end;
end;


-- Show the previous page
function help_page_manager:show_previous_page()
	self.history_pointer = self.history_pointer - 1;
	self:show_previous_or_forward_page();
end;


-- Show the forward page
function help_page_manager:show_forward_page()
	self.history_pointer = self.history_pointer + 1;
	self:show_previous_or_forward_page();
end;


-- Previous button clicked
function help_page_manager:previous_history_button_clicked()
	self:show_previous_page();
end;


-- Forward button clicked
function help_page_manager:forward_history_button_clicked()
	self:show_forward_page();
end;
















-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Index Page Generation
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- For external use - used for hyperlinks that bring up the index
function help_page_manager:show_index()
	self:clear_panel();
	self:get_uicomponent():InterfaceFunction("show_index");
	self:show_panel();
end;


-- Called when the code generates the index page. This script parses the index page, making the links work, and otherwise sets up the panel.
function help_page_manager:help_page_index_generated()
	local uic_help_panel = self:get_uicomponent();
	
	local uic_list = find_uicomponent(uic_help_panel, "listview", "list_box");
	
	local parser = self.parser;
		
	for i = 0, uic_list:ChildCount() - 1 do
		local uic_entry = UIComponent(uic_list:Find(i));
		
		local unparsed_text, text_source = uic_entry:GetStateText();
		local parsed_text = parser:parse_for_links(unparsed_text);
		
		uic_entry:SetStateText(parsed_text, text_source);
	end;
	
	self:add_help_page_to_history("__index");
	
	self:show_panel();
	
	self:print_help_page_history();
end;















-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Debug output
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function help_page_manager:print_help_page_history()
	local print_func = false;
	
	out.help_pages("printing help page history:");
	for i = 1, #self.help_page_history do
		if i == self.history_pointer then	
			out.help_pages("\t" .. i .. ": " .. self.help_page_history[i] .. " << history pointer here");
		else
			out.help_pages("\t" .. i .. ": " .. self.help_page_history[i]);
		end;
	end;
end;













-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Hyperlink Click Listeners
--	Each help page sets up a hyperlink click listener with
--	register_hyperlink_click_listener(). When a hyperlink in the help system
--	is clicked the listener in start_hyperlink_click_listener() is triggered.
--	This ends up calling help_page:link_clicked() which calls
--	help_page_manager:open_help_page() to open the new page.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


function help_page_manager:start_hyperlink_click_listener()
	if self.hyperlink_click_listener_started then
		return;
	end;
	
	self.hyperlink_click_listener_started = true;
	
	core:add_listener(
		"hyperlink_click_listener",
		"ComponentLinkClicked",
		true,
		function(context)
			self:hyperlink_clicked(context.string);
		end,
		true
	);
end;


function help_page_manager:stop_hyperlink_click_listener()
	self.hyperlink_click_listener_started = false;
	
	core:remove_listener("hyperlink_click_listener");
end;


-- called by each help page instance to register a listener for its own individual url
function help_page_manager:register_hyperlink_click_listener(url, callback)
	if not is_string(url) then
		script_error("ERROR: register_hyperlink_click_listener() called but supplied url [" .. tostring(url) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: register_hyperlink_click_listener() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self:start_hyperlink_click_listener();
		
	if not self.hyperlink_click_listeners[url] then
		self.hyperlink_click_listeners[url] = {};
	end;
	
	table.insert(self.hyperlink_click_listeners[url], callback);
end;


-- Called when some script wants to register that a hyperlink has been clicked - primarily the click event listener that listens
-- for hyperlinks being clicked, but also other functions that want to simulate this such as history buttons. Each individual page registers
-- a click listener with register_hyperlink_click_listener() above
function help_page_manager:hyperlink_clicked(url, is_from_history)
	local listener_list = self.hyperlink_click_listeners[url];
	
	if not listener_list then
		return;
	end;
	
	for i = 1, #listener_list do
		listener_list[i](is_from_history);
	end;
end;











-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Tooltip Mouseover listeners
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function help_page_manager:start_tooltip_mouseover_listeners()
	if self.tooltip_mouseover_listeners_started then
		return;
	end;
	
	self.tooltip_mouseover_listeners_started = true;
		
	core:add_listener(
		"tooltip_mouseover_listener",
		"ComponentLinkMouseOver",
		true,
		function(context) self:check_tooltip_mouseover_list(context.string) end,
		true
	);
end;


function help_page_manager:register_tooltip_listener(tl)
	table.insert(self.tooltip_mouseover_listeners, tl);
	
	if not self.tooltip_mouseover_listeners_started then
		self:start_tooltip_mouseover_listeners();
	end;
end;


function help_page_manager:check_tooltip_mouseover_list(str)

	if str == "" then
		-- this is a mouse-off event, so find all (should only be one) active tooltip listeners
		-- and call their mouseoff event
		
		local tooltip_listeners = {};
		
		for i = 1, #self.active_tooltip_mouseover_listeners do
			table.insert(tooltip_listeners, self.active_tooltip_mouseover_listeners[i]);
		end;
		
		self.active_tooltip_mouseover_listeners = {};
		
		-- actually call all our callbacks
		for i = 1, #tooltip_listeners do
			tooltip_listeners[i]:link_mouseoff();
		end;
		
	else
		-- this is a mouse-on event, so go through our tooltip listeners
		-- and see if the link matches the supplied string
		local matching_tooltip_listeners = {};

		for i = 1, #self.tooltip_mouseover_listeners do
			local current_listener = self.tooltip_mouseover_listeners[i];
			
			if current_listener.link == str and not current_listener.is_active then
				table.insert(matching_tooltip_listeners, current_listener);
			end;
		end;
		
		-- process the matching listeners
		for i = 1, #matching_tooltip_listeners do
			local current_listener = matching_tooltip_listeners[i];
			table.insert(self.active_tooltip_mouseover_listeners, current_listener);
			current_listener:link_mouseon();
		end;
	end;
end;



function help_page_manager:stop_tooltip_mouseover_listeners()
	self.tooltip_mouseover_listeners_started = false;
	core:remove_listener("tooltip_mouseover_listener");
end;












-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Help Page to Info Button mappings
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- A ? info button has been clicked somewhere, so work out what help page to load.
function help_page_manager:info_button_clicked(uicomponent)
	out.help_pages("info_button_clicked()");
	out.help_pages(uicomponent_to_str(uicomponent));
		
	local info_button_to_page_map = self.info_button_to_page_map;
	
	for i = 1, #info_button_to_page_map do
		local current_mapping = info_button_to_page_map[i];
		
		if uicomponent_descended_from(uicomponent, current_mapping.parent_id) then
			if not current_mapping.component_test or current_mapping.component_test() then
				self:hyperlink_clicked(current_mapping.help_page);
				return;
			end;
		end;
	end;
	
	script_error("WARNING: info_button_clicked() called but couldn't find help page mapping to match parent id. See Help Page tab for path to info button component");
end;


-- Register an info button mapping.
function help_page_manager:register_help_page_to_info_button_mapping(help_page, info_button_parent_id, component_test)
	if not is_string(help_page) then
		script_error("ERROR: register_help_page_to_info_button_mapping() called but supplied help page [" .. tostring(help_page) .. "] is not a string");
		return false;
	end;
	
	if not is_string(info_button_parent_id) then
		script_error("ERROR: register_help_page_to_info_button_mapping() called but supplied info button parent id [" .. tostring(info_button_parent_id) .. "] is not a string");
		return false;
	end;
	
	if component_test and not is_function(component_test) then
		script_error("ERROR: register_help_page_to_info_button_mapping() called but supplied component test [" .. tostring(component_test) .. "] is not a function or nil");
		return false;
	end;
	
	local mapping = {};
	mapping.parent_id = info_button_parent_id;
	mapping.help_page = help_page;
	mapping.component_test = component_test;
	
	table.insert(self.info_button_to_page_map, mapping);
end;














-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Related Panel functions
--	Handles a related panel being opened or closed. Related panels are
--	fullscreen panels like technology or diplomacy where we should reposition
--	the help panel if they open.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- Returns whether a related panel is open or closed
function help_page_manager:get_related_panel_open()
	for panel_name, override_table in pairs(self.position_overrides_table) do
		if override_table.is_active then
		
			-- if this related panel has to cede priority to another, and that one is open, then return that instead
			if override_table.cede_priority_to then
				if self.position_overrides_table[override_table.cede_priority_to].is_active then
					return override_table.cede_priority_to;
				end;
			end;
			
			return panel_name;
		end;
	end;
	
	return false;
end;


-- Potentially update the status of the help panel because a related panel has been opened.
-- This is also called if the related panel is already opened and the help panel has just been opened.
-- It can also be called externally to force the help page to respond to a "panel" (this is used to
-- position help pages for scripted tours and the like)
function help_page_manager:related_panel_opened(panel_name, related_panel_is_opening_now)

	local position_override_table = self.position_overrides_table[panel_name];

	if not position_override_table then
		script_error("ERROR: related_panel_opened() for panel [" .. tostring(panel_name) .. "] but no corresponding override table could be found - how can this be?");
		return false;
	end;

	position_override_table.is_active = true;

	if not self:is_panel_visible() then
		return;
	end;

	local uim;
	if core:is_campaign() then
		uim = cuim;
	else
		uim = buim;
	end;

	if is_string(position_override_table.cede_priority_to) and uim:is_panel_open(position_override_table.cede_priority_to) then
		out.help_pages("help_page_manager:related_panel_opened() called for panel [" .. panel_name .. "] but panel [" .. position_override_table.cede_priority_to .. "] is also open which supercedes it, doing nothing");
		return;
	end;
	
	if related_panel_is_opening_now and position_override_table.close_help_panel_when_opened then
		out.help_pages("help_page_manager:related_panel_opened() called for panel [" .. panel_name .. "] which is opening now, the associated position override data is instructing us to always close, so closing the help panel");
		self:hide_panel();
		return;
	end;

	local uic_help_panel = self:get_uicomponent();
	local screen_x, screen_y = core:get_screen_resolution();
	
	-- Set the panel state and buttons to be undocked
	if core:is_campaign() then
		self:undock_panel_campaign(true);
	else
		self:undock_panel_battle(true);
	end;

	-- if the panel provides a max height override, set it on the panel
	local max_height_override = position_override_table.max_height or (core:is_campaign() and self.default_max_height_campaign or self.default_max_height_battle);
			
	if is_number(max_height_override) then
		self:set_max_height(max_height_override);
	end;
	
	-- move the panel to the override position
	local override_x = position_override_table.x;
	local override_y = position_override_table.y;
	
	if override_x == "middle" then
		override_x = (screen_x / 2) - (uic_help_panel:Width() / 2);
		out.help_pages("\tsetting override_x to " .. override_x);
	end;
	
	if override_y == "middle" then
		override_y = (screen_y / 2) - (uic_help_panel:Height() / 2);
		out.help_pages("\tsetting override_y to " .. override_x);
	end;
	
	-- if the override values are less than zero then position the panel relative to the right/bottom of the screen
	if override_x < 0 then
		override_x = (screen_x + override_x) - uic_help_panel:Width();
	end;
	
	if override_y < 0 then
		override_y = (screen_y + override_y) - uic_help_panel:Height();
	end;
	
	uic_help_panel:MoveTo(override_x, override_y);
	
	out.help_pages("help_page_manager:related_panel_opened() called for panel [" .. panel_name .. "], moving help panel to [" .. override_x .. ", " .. override_y .. "]");
end;








-- Called when a panel that affects the state of the help panel (fullscreen panels like diplomacy) is closed.
-- Can also be called externally.
function help_page_manager:related_panel_closed(panel_name, suppress_panel_visibility_check)

	local position_override_table = self.position_overrides_table[panel_name];
	if not position_override_table then
		script_error("ERROR: help_page_manager:related_panel_closed() called but couldn't find override table for supplied panel [" .. tostring(panel_name) .. "], how can this be?");
		return false;
	end;

	position_override_table.is_active = false;

	if not suppress_panel_visibility_check and not self:is_panel_visible() then
		-- help panel is not visible, so don't proceed;
		return;
	end;

	out.help_pages("help_page_manager:related_panel_closed() is redocking the help panel upon closure of panel " .. panel_name);
	
	-- a bit hacky - we should wait for some kind of notification that the radar panel has animated back on
	local redocking_wait_period = position_override_table.redocking_wait_period;
	
	-- always wait a little bit of time
	if not is_number(redocking_wait_period) then
		if core:is_campaign() then
			redocking_wait_period = 0.1;
		else
			redocking_wait_period = 100;
		end;
	end;
	
	core:get_tm():callback(
		function()
			self:update_panel_docking_state();
		end, 
		redocking_wait_period
	);
end;










-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Panel Updating functions
--	Handle the display of a new help page and updating the state of the
--	help panel itself.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- Open a new help page.
function help_page_manager:open_help_page(hp, is_from_history)

	local link = hp.link;

	-- If this page is currently being displayed then close the panel if it's visible
	if not is_from_history and not self:is_help_page_history_empty() and self:get_last_help_page() == link and not self:forward_help_pages_exist() then
		if self:is_panel_visible() then
			self:hide_panel();
			return;
		end;
	end;
	
	out.help_pages("** Displaying help page [" .. link .. "]");
	
	-- register in advice history that this link has been clicked
	common.set_advice_history_string_seen(link);

	-- add this page to the help page history, unless this 'click' is actually spoofed from history because the player clicked one of the history back/forwards buttons
	if not is_from_history then
		self:add_help_page_to_history(link);
	end;
	
	-- clear any currently-showning tooltip highlights
	if core:is_campaign() then
		cuim:unhighlight_all_for_tooltips();
	elseif core:is_battle() then
		buim:unhighlight_all_for_tooltips();
	end;

	-- prepare panel for page display
	self:clear_panel();
		
	-- go through all records and display them
	local content = hp.content;
	local use_small_text = self:should_use_small_text();

	for i = 1, #content do
		self:append_help_page_record(content[i], use_small_text);
	end;
	
	out.help_pages("");

	self:show_panel();
end;


-- Is the panel currently visible
function help_page_manager:is_panel_visible()
	return self:get_uicomponent():Visible();
end;


-- Called prior to updating the panel with text in order clear the existing panel contents.
function help_page_manager:clear_panel()
	self:get_uicomponent():InterfaceFunction("clear_help_page");
end;


-- Shows the help panel. If the suppress_update flag is supplied then the state of the panel will not be updated - this is used if the panel is briefly hidden/unhidden.
function help_page_manager:show_panel(suppress_update)
	self:get_uicomponent():SetVisible(true);

	if suppress_update then
		return;
	end;
	
	self:update_panel();
end;


-- Hide the help panel. If the suppress_update flag is supplied then the state of the panel will not be updated - this is used if the panel is briefly hidden/unhidden.
function help_page_manager:hide_panel(suppress_update)
	self:get_uicomponent():SetVisible(false);

	if suppress_update then
		return;
	end;

	self:panel_has_closed();
end;


-- Called whenever the panel closes.
function help_page_manager:panel_has_closed()
	self:stop_listen_for_undocking();

	if core:is_battle() then
		self:show_battle_radar(true);
	end;

	self.player_has_undocked_panel = false;
	self.panel_has_moved_while_undocked = false;
	self.should_reshow_after_cinematic_ui = false;
end;


-- Update the state of the help panel after a new page has been displayed.
-- Docks the panel if appropriate, and updates the button states
function help_page_manager:update_panel()	

	local active_related_panel = self:get_related_panel_open();
	if active_related_panel and not self.panel_has_moved_while_undocked then
		self:related_panel_opened(active_related_panel);
	else
		self:update_panel_docking_state();
	end;
	
	-- update state of all buttons on the help panel
	self:update_help_panel_buttons();
end;


-- set the max height of the panel
function help_page_manager:set_max_height(value)
	local uic_help_panel = self:get_uicomponent()
	if not uic_help_panel then
		script_error("ERROR: set_max_height() called but couldn't find panel uicomponent");
		return false;
	end;
	uic_help_panel:SetProperty("max_height", value);
end;


-- Called externally by scripts that want to force hide the title bar buttons.
function help_page_manager:show_title_bar_buttons(value, exempt_close_button)	
	local uic_panel = self:get_uicomponent();
	
	if not uic_panel then
		script_error("ERROR: show_title_bar_buttons() called but couldn't find help page uicomponent");
		return false;
	end;
	
	self:update_help_panel_buttons(value);

	set_component_visible_with_parent(value, uic_panel, "button_dock");
	set_component_visible_with_parent(value, uic_panel, "button_undock");
	
	if not exempt_close_button then
		set_component_visible_with_parent(value, uic_panel, "button_hp_close");
	end;
end;


-- Update the state of all help panel buttons, except for the docking buttons which are handled separately.
function help_page_manager:update_help_panel_buttons(show_buttons)
	
	-- We show buttons by default
	if show_buttons ~= false then
		show_buttons = true;
	end;
	
	local uic_help_panel = self:get_uicomponent();
	if not uic_help_panel then
		script_error("ERROR: update_help_panel_buttons() called but couldn't find help page uicomponent");
		return false;
	end;
	
	-- Back history button
	local uic_button_hp_previous = find_uicomponent(uic_help_panel, "button_hp_previous");
	if not uic_button_hp_previous then
		script_error("WARNING: update_help_panel_buttons() could not find uic_button_hp_previous, how can this be?");
	else
		uic_button_hp_previous:SetVisible(show_buttons);
		if show_buttons then
			uic_button_hp_previous:SetVisible(true);
			if self:previous_help_pages_exist() then
				uic_button_hp_previous:SetState("active");
			else
				uic_button_hp_previous:SetState("inactive");
			end;
		end;		
	end;
	
	-- Forward history button
	local uic_button_hp_forward = find_uicomponent(uic_help_panel, "button_hp_next");
	if not uic_button_hp_forward then
		script_error("WARNING: update_help_panel_buttons() could not find uic_button_hp_forward, how can this be?");
	else
		uic_button_hp_forward:SetVisible(show_buttons);
		if self:forward_help_pages_exist() then
			uic_button_hp_forward:SetState("active");
		else
			uic_button_hp_forward:SetState("inactive");
		end;
	end;
	
	-- Index button - if the index page is being displayed then disable the index button, otherwise enabled it
	if show_buttons then
		if self:is_help_page_history_empty() then
			self:enable_help_panel_contents_button(true);
		else
			local last_help_page = self:get_last_help_page();
			if last_help_page == "script_link_campaign_contents" or last_help_page == "script_link_battle_contents" then
				self:enable_help_panel_contents_button(false);
			else
				self:enable_help_panel_contents_button(true);
			end;
		end;
	else
		set_component_visible_with_parent(false, uic_help_panel, "button_hp_index");
	end;
end;


-- enables or disables the index button on the panel
function help_page_manager:enable_help_panel_contents_button(value)
	local uic = find_uicomponent(self:get_uicomponent(), "button_hp_index");

	if not uic then
		script_error("WARNING: enable_help_panel_contents_button() could not find button_hp_index, how can this be?");
		return false;
	end;

	uic:SetVisible(true);
	
	if value == false then
		uic:SetState("inactive");
		self.help_panel_index_button_tooltip_text, self.help_panel_index_button_tooltip_text_src = uic:GetTooltipText();
		uic:SetTooltipText("", true);
	else
		uic:SetState("active");
		
		if self.help_panel_index_button_tooltip_text and self.help_panel_index_button_tooltip_text_src then
			uic:SetTooltipText(self.help_panel_index_button_tooltip_text, self.help_panel_index_button_tooltip_text_src, true);
		end;
	end;
end;


-- enables or disables the index button on the menu bar
function help_page_manager:enable_menu_bar_index_button(value)
	local uic = find_uicomponent(core:get_ui_root(), "menu_bar", "button_help_panel");
	
	if value == false then
		uic:SetState("inactive");
		self.menu_bar_index_button_tooltip_text, self.menu_bar_index_button_tooltip_text_src = uic:GetTooltipText();
		uic:SetTooltipText("", true);
	else
		uic:SetState("active");
		
		if self.menu_bar_index_button_tooltip_text then
			uic:SetTooltipText(self.menu_bar_index_button_tooltip_text, self.menu_bar_index_button_tooltip_text_src, true);
		end;
	end;
end;











-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Docking functions
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- Is it currently possible for the help panel to be docked
function help_page_manager:can_panel_be_docked()
	if self.panel_docking_disabled then
		return false, "help panel docking is disabled";

	else
		local related_panel_open = self:get_related_panel_open();

		if related_panel_open then
			return false, "related panel " .. related_panel_open .. " is open";
		end;
	end;

	return true;
end;


-- Prevent the help panel from being docked
function help_page_manager:set_panel_docking_disabled(value)
	if value == false then
		self.panel_docking_disabled = false;
	else
		self.panel_docking_disabled = true;
	end;
end;


-- Work out if we need to minimise the radar and/or any lists and "dock" the panel.
-- We dock if we're coming from a closed state and no override was applied
function help_page_manager:update_panel_docking_state()
	local uic_help_panel = self:get_uicomponent();

	-- Determine if we should dock
	local can_panel_be_docked, reason = self:can_panel_be_docked();

	if not can_panel_be_docked then
		panel_should_dock = false;

	else
		if self.player_has_undocked_panel then
			reason = "player has undocked panel";
			panel_should_dock = false;
			
		else
			panel_should_dock = true;
		end;
	end;

	if panel_should_dock then
		out.help_pages("\thelp page is docking");
		if core:is_campaign() then
			self:dock_panel_campaign();
		else
			self:dock_panel_battle();
		end;

	else
		out.help_pages("\thelp page is not docking, reason: " .. tostring(reason));
		if core:is_campaign() then
			self:undock_panel_campaign();
		else
			self:undock_panel_battle();
		end;
	end;
end;


-- Docks the panel on the main UI in campaign
function help_page_manager:dock_panel_campaign()
	local screen_x, screen_y = core:get_screen_resolution();
			
	self:stop_listen_for_undocking();

	self.panel_has_moved_while_undocked = false;

	local uic_help_panel = self:get_uicomponent();
	
	-- move the component into the centre of the screen to ensure that it does not get in the way of the SimulatedClicks below
	uic_help_panel:SetDockingPoint(0);
	uic_help_panel:MoveTo(screen_x, screen_y);
	uic_help_panel:SetState("docked");

	uic_help_panel:SetMoveable(false);

	self:set_docking_button_states(true);
	
	local radar_animating = false;

	local uic_bar_small_top = find_uicomponent("hud_campaign", "bar_small_top");
	
	-- Minimise the radar if it's visible
	local uic_radar_button = find_uicomponent(uic_bar_small_top, "radar_toggle");
	
	local radar_button_state = uic_radar_button:CurrentState();

	local visible = uic_radar_button:Visible();
	local onscreen = is_fully_onscreen(uic_radar_button);
	local found = string.find(radar_button_state, "selected");
	
	if uic_radar_button:Visible() and is_fully_onscreen(uic_radar_button) and string.find(radar_button_state, "selected") then
		-- radar is maximised, so minimise it
		uic_radar_button:SimulateLClick();
		radar_animating = true;
	end;
	
	-- Close any lists that are open
	local uic_tabgroup_parent = find_uicomponent(uic_bar_small_top, "TabGroup");
	
	for i = 0, uic_tabgroup_parent:ChildCount() - 1 do
		local uic_tab_button = UIComponent(uic_tabgroup_parent:Find(i));
		
		if uic_tab_button:Visible() and uic_tab_button:CurrentState() == "selected" then
			uic_tab_button:SimulateLClick();
			radar_animating = true;
		end;
	end;

	-- Dock help panel to the dropdown parent part of the radar
	local uic_dropdown_parent = find_uicomponent("hud_campaign", "radar_things", "dropdown_parent");
	if uic_dropdown_parent then
		uic_dropdown_parent:Adopt(uic_help_panel:Address());
		uic_help_panel:SetDockingPoint(1);
		uic_help_panel:SetDockOffset(0, -11);
	end;

	-- if the radar or a list is animating, set the panel to be invisible and then make it visible again in a short while to give those components a chance to get out of the way
	if radar_animating then
		self:hide_panel(true);
		cm:callback(
			function()
				self:set_docked_panel_height_campaign();

				self:show_panel(true);
				
				self:listen_for_undocking();
			end, 
			0.25
		);
	else
		self:set_docked_panel_height_campaign();
		
		-- Unsure why this is necessary, but the dropdown list gets confused if this is not there
		self:hide_panel(true);
		self:show_panel(true);

		self:listen_for_undocking();
	end;
end;


-- Set max height of panel so that it doesn't collide with faction buttons
function help_page_manager:set_docked_panel_height_campaign()
	local uic_help_panel = self:get_uicomponent();

	local desired_panel_height;
	local uic_faction_buttons_docker = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker");
	if uic_faction_buttons_docker then
		local help_panel_x, help_panel_y = uic_help_panel:Position();
		local screen_x, screen_y = core:get_screen_resolution();

		desired_panel_height = screen_y - (help_panel_y + HELP_PANEL_TO_UI_MARGIN + self.top_bar_height + uic_faction_buttons_docker:Height());
	else
		desired_panel_height = self.default_max_height_campaign;
	end;
	self:set_max_height(desired_panel_height);
end;


-- Undocks the help panel in campaign
function help_page_manager:undock_panel_campaign(suppress_panel_movement_and_resize)
	local uic_help_panel = self:get_uicomponent();

	uic_help_panel:SetState("undocked");

	core:get_ui_root():Adopt(uic_help_panel:Address());
	uic_help_panel:SetDockingPoint(0);

	uic_help_panel:SetMoveable(true);

	self:stop_listen_for_undocking();

	-- move the panel to somewhere in the middle of the screen, and set max height of panel to default
	if not suppress_panel_movement_and_resize then
		self:set_max_height(self.default_max_height_campaign);

		-- only move the panel in to the default position if the player has not dragged it to some other position
		if not self.panel_has_moved_while_undocked then
			local uic_advice_text_panel = find_uicomponent("advice_text_panel");
			if uic_advice_text_panel and uic_advice_text_panel:Visible(true) and is_fully_onscreen(uic_advice_text_panel) then
				local advice_pos_x, advice_pos_y = uic_advice_text_panel:Position();
				uic_help_panel:MoveTo(advice_pos_x + uic_advice_text_panel:Width() + HELP_PANEL_TO_UI_MARGIN, advice_pos_y);
			else
				uic_help_panel:MoveTo(self.default_undocked_pos_x, self.default_undocked_pos_y);
			end;
		end;
	end;

	self:set_docking_button_states(false);
end;


-- Docks the panel on the main UI in battle
function help_page_manager:dock_panel_battle()
	
	self.panel_has_moved_while_undocked = false;

	self:stop_listen_for_undocking();

	local uic_help_panel = self:get_uicomponent();
	
	local uic_radar_holder = find_uicomponent(core:get_ui_root(), "hud_battle", "radar_holder");
	if not uic_radar_holder then
		script_error("ERROR: help_page_manager:dock_panel_battle() called but could not find uic_radar_holder - how can this be?");
		return false;
	end;

	-- make the radar invisible
	self:show_battle_radar(false);

	-- y offset at which the help panel will dock from the radar holder
	local HELP_PANEL_VERTICAL_DOCK_OFFSET = 41;

	-- dock help panel to the radar holder
	uic_radar_holder:Adopt(uic_help_panel:Address(), 0);
	uic_help_panel:SetDockingPoint(3);
	uic_help_panel:SetDockOffset(0, 41);
	uic_help_panel:PropagatePriority(200);

	uic_help_panel:SetState("docked");
			
	uic_help_panel:SetMoveable(false);

	-- Set max height of panel so that it doesn't collide with army abilities, if any
	local desired_panel_height;
	local uic_army_abilities_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "army_ability_container", "army_ability_parent");
	if uic_army_abilities_parent and uic_army_abilities_parent:ChildCount() > 0 then
		local army_abilities_pos_x, army_abilities_pos_y = uic_army_abilities_parent:Position();
		desired_panel_height = army_abilities_pos_y - (HELP_PANEL_VERTICAL_DOCK_OFFSET + HELP_PANEL_TO_UI_MARGIN + self.top_bar_height);

		out.help_pages("About to calculate desired_panel_height, army_abilities_pos_y: " .. tostring(army_abilities_pos_y) .. ", HELP_PANEL_VERTICAL_DOCK_OFFSET: " .. tostring(HELP_PANEL_VERTICAL_DOCK_OFFSET) .. ", HELP_PANEL_TO_UI_MARGIN: " .. tostring(HELP_PANEL_TO_UI_MARGIN) .. ", top bar height: " .. tostring(self.top_bar_height));
	else
		-- We can't find any army ability parent or it has no army ability children, so set the height based on the position of the Winds of Magic panel
		local uic_winds_of_magic = find_uicomponent(core:get_ui_root(), "hud_battle", "winds_of_magic");
		if uic_winds_of_magic then
			local screen_x, screen_y = core:get_screen_resolution();

			desired_panel_height = screen_y - (HELP_PANEL_VERTICAL_DOCK_OFFSET + HELP_PANEL_TO_UI_MARGIN + self.top_bar_height + uic_winds_of_magic:Height());
		else
			desired_panel_height = self.default_max_height_battle;
		end;
	end;

	self:set_max_height(desired_panel_height);

	self:listen_for_undocking();

	self:set_docking_button_states(true);
end;


-- Undocks the help panel in battle
function help_page_manager:undock_panel_battle(suppress_panel_movement_and_resize)
	local uic_help_panel = self:get_uicomponent();

	uic_help_panel:SetState("undocked");

	core:get_ui_root():Adopt(uic_help_panel:Address());
	uic_help_panel:SetDockingPoint(0);

	uic_help_panel:SetMoveable(true);
	
	-- make the radar visible
	self:show_battle_radar(true);

	-- move the panel to somewhere in the middle of the screen, and set max height of panel to default
	if not suppress_panel_movement_and_resize then
		self:set_max_height(self.default_max_height_battle);

		-- only move the panel in to the default position if the player has not dragged it to some other position
		if not self.panel_has_moved_while_undocked then

			local uic_radar = find_uicomponent(core:get_ui_root(), "hud_battle", "radar_holder", "radar_group", "radar");
			if uic_radar then
				local radar_x, radar_y = uic_radar:Position();
				uic_help_panel:MoveTo(radar_x - (uic_help_panel:Width() + HELP_PANEL_TO_UI_MARGIN), radar_y);
			else
				script_error("ERROR: undock_panel_battle() called but could not find uic_radar - how can this be?");
			end;
		end;
	end;

	self:set_docking_button_states(false);
end;


-- Set the visibility/active states of the docking buttons based on the current state of the panel
function help_page_manager:set_docking_button_states(panel_is_docked)
	local uic_help_panel = self:get_uicomponent();

	local uic_dock_button = find_uicomponent(uic_help_panel, "button_dock");
	if not uic_dock_button then
		script_error("ERROR: help_page_manager:set_docking_button_states() called but couldn't find button_dock");
		return false;
	end;

	local uic_undock_button = find_uicomponent(uic_help_panel, "button_undock");
	if not uic_undock_button then
		script_error("ERROR: help_page_manager:set_docking_button_states() called but couldn't find button_undock");
		return false;
	end;
	
	if panel_is_docked then
		uic_undock_button:SetVisible(true);
		uic_undock_button:SetState("active");

		uic_dock_button:SetVisible(false);
	else
		uic_undock_button:SetVisible(false);

		uic_dock_button:SetVisible(true);
		if self:can_panel_be_docked() then
			uic_dock_button:SetState("active");
		else
			uic_dock_button:SetState("inactive");
		end;
	end;
end;


-- Shows or hides the radar in battle
function help_page_manager:show_battle_radar(value)
	local uic_radar_group = find_uicomponent(core:get_ui_root(), "hud_battle", "radar_holder", "radar_group");
	if not uic_radar_group then
		script_error("ERROR: help_page_manager:show_battle_radar() called but could not find uic_radar_group - how can this be?");
		return false;
	end;

	if value == false then
		uic_radar_group:SetVisible(false);
	else
		uic_radar_group:SetVisible(true);
	end;
end;



local docking_clicks_list_campaign = {
	{
		button = "radar_toggle",
		parent = "bar_small_top"
	},
	{
		button = "tab_missions",
		parent = "bar_small_top"
	},
	{
		button = "tab_events",
		parent = "bar_small_top"
	},
	{
		button = "tab_units",
		parent = "bar_small_top"
	},
	{
		button = "tab_regions",
		parent = "bar_small_top"
	},
	{
		button = "tab_factions",
		parent = "bar_small_top"
	},
	{
		button = "button_undock",
		parent = "help_panel"
	}
};

local docking_clicks_list_battle = {
	{
		button = "button_undock",
		parent = "help_panel"
	}
};

-- Watch for any lists being opened on the campaign interface while docked
function help_page_manager:listen_for_undocking()

	local docking_clicks_list;

	if core:is_campaign() then
		docking_clicks_list = docking_clicks_list_campaign;
	elseif core:is_battle() then
		docking_clicks_list = docking_clicks_list_battle;
	end;

	-- close the help panel if it's docked and one of the lists or the radar is expanded
	core:add_listener(
		"hpm_listen_for_undocking",
		"ComponentLClickUp",
		function(context)
			local button_name = context.string;
			for i = 1, #docking_clicks_list do
				if docking_clicks_list[i].button == button_name and uicomponent_descended_from(UIComponent(context.component), docking_clicks_list[i].parent) then
					return true;
				end;
			end;
		end,
		function(context)
			local uic_panel = self:get_uicomponent();
			
			out.help_pages("listen_for_undocking() has detected an undock click: " .. tostring(context.string));
			
			self.player_has_undocked_panel = true;
			self:update_panel_docking_state();
		end,
		true
	);
end;


function help_page_manager:stop_listen_for_undocking()	
	core:remove_listener("hpm_listen_for_undocking");
end;









-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--	Building A Help Page
--	Functions below are called as help page is being put together
--	for display.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- Displays a line of text and returns a link to the newly created uicomponent
function help_page_manager:create_entry(key, state, section_name)
	local uic_help_panel = self:get_uicomponent();

	if state then
		if section_name then
			uic_help_panel:InterfaceFunction("add_help_page_entry", key, state, section_name);
		else
			uic_help_panel:InterfaceFunction("add_help_page_entry", key, state);
		end;
	else
		uic_help_panel:InterfaceFunction("add_help_page_entry", key);
	end;		
	
	return find_uicomponent(self.uic_help_panel, key);
end;


-- Displays an image on the help page and returns a link to the newly created uicomponent
function help_page_manager:create_image(key, image_path, section_name)
	local uic = self:create_entry(key, "image", section_name);
	
	local w, h = uic:Dimensions();

	-- If we are not putting this image in a section then set the image dock offset +10 and the width -10, to offset it from the left margin
	if not section_name then
		w = w - 10;
		local dock_x, dock_y = uic:GetCurrentStateImageDockOffset(0);
		uic:SetCurrentStateImageDockOffset(0, dock_x + 10, dock_y);
	end;

	local img_index = uic:GetCurrentStateImageIndex(0);

	uic:SetImagePath(image_path, img_index, true);

	local img_w, img_h = uic:GetCurrentStateImageDimensions(0);

	-- Clear any text on the uicomponent
	uic:SetStateText("");

	-- Resize the image so that it's the same width as the uicomponent, but keeps its aspect ratio
	local new_height = w * img_h / img_w;

	uic:Resize(w, new_height);
	uic:ResizeCurrentStateImage(0, w, new_height);

	return uic;
end;


-- Creates a section on the help page
function help_page_manager:create_section(section_name)
	local uic_help_panel = self:get_uicomponent();

	uic_help_panel:InterfaceFunction("add_help_page_section", section_name);

	return find_uicomponent(self.uic_help_panel, section_name);
end;


-- Creates a section index
function help_page_manager:create_section_index(section_name, start_record, end_record, suppress_expand_button, expand_button_localised_text_key, collapse_button_localised_text_key)
	local uic_help_panel = self:get_uicomponent();
	
	if not end_record then
		end_record = "";
	end;
	
	local first_component = uic_help_panel:InterfaceFunction("show_index", section_name, false, start_record, end_record, not suppress_expand_button);

	if is_component(first_component) then
		local uic_first_index_entry = UIComponent(first_component);

		local parser = self.parser;
		local uic_parent = UIComponent(uic_first_index_entry:Parent());
		local index_entries_reached = false;

		for i = 0, uic_parent:ChildCount() - 1 do
			local uic_child = UIComponent(uic_parent:Find(i));

			if not index_entries_reached and uic_child == uic_first_index_entry then
				index_entries_reached = true;
			end;

			if index_entries_reached then
				if uic_child:Id() == "footer" then
					-- Set the text state of the footer button if we've been given overrides
					if expand_button_localised_text_key then
						uic_child:SetState("expand");
						local localised_str;
						local should_set = true;
						
						if expand_button_localised_text_key == "" then
							localised_str = "";
						else
							localised_str = common.get_localised_string(expand_button_localised_text_key);
							if not localised_str or localised_str == "" then
								script_error("WARNING: help_page_manager is attempting to create a section index with name [" .. tostring(section_name) .. "] but could not find localised expand button text with key [" .. tostring(expand_button_localised_text_key) .. "]");
								should_set = false;
							end;
						end;

						if should_set then
							uic_child:SetStateText(localised_str, expand_button_localised_text_key);
						end;
					end;

					if collapse_button_localised_text_key then
						uic_child:SetState("collapse");
						local localised_str;
						local should_set = true;
						
						if collapse_button_localised_text_key == "" then
							localised_str = "";
						else
							localised_str = common.get_localised_string(collapse_button_localised_text_key);
							if not localised_str or localised_str == "" then
								script_error("WARNING: help_page_manager is attempting to create a section index with name [" .. tostring(section_name) .. "] but could not find localised collapse button text with key [" .. tostring(collapse_button_localised_text_key) .. "]");
								should_set = false;
							end;
						end;

						if should_set then
							uic_child:SetStateText(localised_str, collapse_button_localised_text_key);
						end;
						uic_child:SetState("expand");
					end;
				else
					local unparsed_text, text_source = uic_child:GetStateText();
					local parsed_text = parser:parse_for_links(unparsed_text);
			
					uic_child:SetStateText(parsed_text, text_source);
				end;
			else

			end;
		end;
	end;
end;


-- Should we use small text size, based on global settings and the current screen resolution
function help_page_manager:should_use_small_text()
	if self.never_use_small_text then
		return false;
	end;

	-- get screen resolution and work out if we should use small or normal
	local screen_x, screen_y = core:get_screen_resolution();
	return screen_y < self.small_text_min_screen_height;
end;


-- Append a text record to a help page, called as a new page is being displayed
function help_page_manager:append_help_page_record(record, use_small_text)
	
	local key = record.key;
	
	record.is_active = true;

	local uic_entry;

	if record.is_new_section then
		uic_entry = self:create_section(record.section_name);

	elseif record.is_section_index then
		self:create_section_index(record.section_name, record.start_record, record.end_record, record.suppress_expand_button, record.expand_button_localised_text, record.collapse_button_localised_text);

	elseif record.image_path then
		uic_entry = self:create_image(record.key, record.image_path, record.section_name);

	else
		local state;

		if use_small_text and record.state_small then
			state = record.state_small;
		elseif record.state then
			state = record.state;
		end;
		
		uic_entry = self:create_entry(key, state, record.section_name);
			
		-- See if we need to show the modifier component
		if record.show_modifier then
			local uic_modifier = find_uicomponent(uic_entry, "modifier");
			
			if record.show_drag_modifier then
				local key = "ui_text_replacements_localised_text_hp_battle_cheat_sheet_drag_modifier";
				uic_modifier:SetStateText(common.get_localised_string(key), key);
			elseif record.show_roll_modifier then
				local key = "ui_text_replacements_localised_text_hp_battle_cheat_sheet_roll_modifier";
				uic_modifier:SetStateText(common.get_localised_string(key), key);
			elseif record.show_hold_modifier then
				local key = "ui_text_replacements_localised_text_hp_battle_cheat_sheet_hold_modifier";
				uic_modifier:SetStateText(common.get_localised_string(key), key);
			elseif record.show_on_enemy_modifier then
				local key = "ui_text_replacements_localised_text_hp_battle_cheat_sheet_on_enemy_modifier";
				uic_modifier:SetStateText(common.get_localised_string(key), key);
			end;
			
			uic_modifier:SetVisible(true);
		end;
	end;

	
	if record.image_path then
		out.help_pages("displayed image with path [" .. record.image_path .. "]" .. (record.section_name and " in section " .. record.section_name or ""));
		
	elseif record.is_section_index then
		out.help_pages("created section with name [" .. record.section_name .. "]");
		
	else
		-- Parse the localised text on this uicomponent
		local localised_text, source = uic_entry:GetStateText();

		if record.show_links then
			localised_text = self.parser:parse_for_links(localised_text);
		else
			localised_text = self.parser:parse_for_tooltips(localised_text);
		end;
		
		if localised_text then
			uic_entry:SetStateText(localised_text, source);
		else
			-- If we've got here then the parse failed for some reason, but we still need the localised_text for output so re-grab it from the component
			localised_text = uic_entry:GetStateText();
		end;

		out.help_pages("displaying line with state [" .. uic_entry:CurrentState() .. "]: " .. localised_text);
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	HELP PAGES
--	This file provides library support for help pages
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------
--	help page definition
-----------------------------------------------------------------------------

help_page = {
	hpm = false,
	link = "",
	content = {},
	always_use_small_text = false,
	always_use_normal_text = false,
	
	hp_info_text_padding = 5
};


set_class_custom_type(help_page, TYPE_HELP_PAGE);
set_class_tostring(
	help_page, 
	function(obj)
		return TYPE_HELP_PAGE .. "_" .. obj.link
	end
);



-----------------------------------------------------------------------------
--	help page declaration
-----------------------------------------------------------------------------

function help_page:new(link, ...)

	if not is_string(link) then
		script_error("ERROR: help_page:new() called but supplied link [" .. tostring(link) .. "] is not a string");
		return false;
	end;

	local hp = {};

	set_object_class(hp, self);
	
	local hpm = get_help_page_manager();

	hp.link = link;
	hp.content = arg;
	hp.hpm = hpm;
	
	hpm:register_hyperlink_click_listener(
		link, 
		function(is_from_history) 
			hp:link_clicked(is_from_history)
		end
	);
	
	return hp;
end;


-- This help page's link has been clicked.
-- We maintain this as a separate function so that it can be called by external scripts to open this page.
function help_page:link_clicked(is_from_history)
	self.hpm:open_help_page(self, is_from_history);
end;


-- Manually append a record to the help page.
-- This is not used for normal help page operations, but can be called externally by scripts that wish to individually add help page records, such as tutorial scripts 
-- adding elements to a cheat sheet help page at the appropriate time.
function help_page:append_help_page_record(record)
	self.hpm:append_help_page_record(record, self.hpm:should_use_small_text());
end;
